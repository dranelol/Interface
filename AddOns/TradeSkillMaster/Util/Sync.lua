-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file handled multi-account syncing and communication

-- register this file with Ace libraries
local TSM = select(2, ...)
local Sync = TSM:NewModule("Sync", "AceComm-3.0", "AceEvent-3.0")
TSMAPI.Sync = {}
local private = {callbacks={}}
TSMAPI:RegisterForTracing(private, "TradeSkillMaster.Sync_private")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table

-- Request friend info from the server
ShowFriends()


function Sync:OnEnable()
	Sync:RegisterComm("TSMSyncData")
	
	local data = {characters={}, accountKey=TSMAPI.Sync:GetAccountKey()}
	for name in pairs(TSM.db.factionrealm.characters) do
		data.characters[name] = TSMAPI.Sync:GetAccountKey()
	end
	TSMAPI:CreateTimeDelay("syncSetupDelay", 3, function() TSMAPI.Sync:BroadcastData("TradeSkillMaster", "SETUP", data) end)
end

--Load the libraries
local libS = LibStub:GetLibrary("AceSerializer-3.0")
local libC = LibStub:GetLibrary("LibCompress")
local libCE = libC:GetAddonEncodeTable()

function Sync:OnCommReceived(_, data, _, source)
	-- Decode the compressed data
	data = libCE:Decode(data)
		
	-- Decompress the decoded data
	local data = libC:Decompress(data)
	if not data then return end
		
	-- Deserialize the decompressed data
	local success
	local tmpData = data
	success, data = libS:Deserialize(data)
	if not success or not data then return end
	
	-- data is good, do callback
	local key = data.__key
	local module = data.__module
	local account = data.__account
	if not key or not module or not private.callbacks[module] then return end
	data.__key = nil
	data.__module = nil
	data.__account = nil
	
	-- make sure we are getting this from a known source
	if not TSM.db.factionrealm.syncAccounts[account] and (module ~= "TradeSkillMaster" and not data.isSetup) then return end
	private.callbacks[module](key, data, source)
end


function TSMAPI.Sync:GetAccountKey()
	return TSM.db.factionrealm.accountKey
end

function TSM:RegisterSyncCallback(module, callback)
	private.callbacks[module] = callback
end

function private:IsPlayerOnline(target, noAdd)
	for i=1, GetNumFriends() do
		local name, _, _, _, connected = GetFriendInfo(i)
		if name and strlower(name) == strlower(target) then
			return connected
		end
	end
	
	if not noAdd then
		-- add them as a friend temporarily
		if GetNumFriends() == 50 then return end
		AddFriend(target)
		for i=1, GetNumFriends() do
			local name, _, _, _, connected = GetFriendInfo(i)
			if name and strlower(name) == strlower(target) then
				return connected
			end
		end
	end
end

function TSMAPI.Sync:SendData(module, key, data, target)
	local playerOnline = private:IsPlayerOnline(target)
	if not playerOnline then return end

	data.__module = module
	data.__key = key
	data.__account = TSMAPI.Sync:GetAccountKey()
	
	-- we will encode using Huffman, LZW, and no compression separately
	-- this is to deal with a bug in the compression code
	local orig = data
	local serialized = libS:Serialize(data)
	local encodedData = {}
	encodedData[1] = libCE:Encode(libC:CompressHuffman(serialized))
	encodedData[2] = libCE:Encode(libC:CompressLZW(serialized))
	encodedData[3] = libCE:Encode("\001"..serialized)
	
	-- verify each compresion and pick the shorted valid one
	local minIndex = -1
	local minLen = math.huge
	for i=#encodedData, 1, -1 do
		local test = libC:Decompress(libCE:Decode(encodedData[i]))
		if test and test == serialized and #encodedData[i] < minLen then
			minLen = #encodedData[i]
			minIndex = i
		end
	end
	
	-- sanity check
	if not encodedData[minIndex] then error("Could not encode data.") end
	-- send off the serialized, compressed, and encoded data
	Sync:SendCommMessage("TSMSyncData", encodedData[minIndex], "WHISPER", target)
end


function TSMAPI.Sync:BroadcastData(module, key, data)
	for account, players in pairs(TSM.db.factionrealm.syncAccounts) do
		if account ~= TSMAPI.Sync:GetAccountKey() then
			local sent
			for player in pairs(players) do
				if private:IsPlayerOnline(player, true) then
					TSMAPI.Sync:SendData(module, key, data, player)
					sent = true
					break
				end
			end
			if not sent then
				for player in pairs(players) do
					if private:IsPlayerOnline(player) then
						TSMAPI.Sync:SendData(module, key, data, player)
						sent = true
						break
					end
				end
			end
		end
	end
end


function private:SendSetupData(target, isResponse, isSetup)
	local data = {isResponse=isResponse, isSetup=isSetup, characters={}, accountKey=TSMAPI.Sync:GetAccountKey()}
	for name in pairs(TSM.db.factionrealm.characters) do
		data.characters[name] = true
	end
	TSMAPI.Sync:SendData("TradeSkillMaster", "SETUP", data, target)
end

function TSM:DoSyncSetup(target)
	if target == "" then
		private.syncSetupTarget = nil
		return
	end
	private.syncSetupTarget = target
	private:SendSetupData(target, nil, true)
end

function TSM:SyncCallback(key, data, source)
	if key == "SETUP" then
		if (data.isSetup and strlower(source) ~= strlower(private.syncSetupTarget or "")) or (not data.isSetup and not TSM.db.factionrealm.syncAccounts[data.accountKey]) then
			return
		end
		TSM.db.factionrealm.syncAccounts[data.accountKey] = data.characters
		if data.isSetup then
			TSMAPI:CloseFrame()
			TSM:Printf(L["Setup account sync'ing with the account which '%s' is on."], source)
		end
		if data.isResponse then return end -- already responded
		private:SendSetupData(source, true, data.isSetup)
	end
end