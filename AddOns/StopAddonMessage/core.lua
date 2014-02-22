-- GLOBAL --
SAM = select(2, ...) 
-- MODULE --
local _G = getfenv(0)
setmetatable(SAM, {__index = _G})
setfenv(1, SAM)
-- LOCAL --
title		= "StopAddonMessage"
folder		= title
version		= GetAddOnMetadata(folder, "X-Curse-Packaged-Version") or ""
titleFull	= title.." "..version

coreFrame = CreateFrame("Frame", nil, UIParent)
core	= LibStub("AceAddon-3.0"):NewAddon(coreFrame, title, "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0") -- 
local L = LibStub("AceLocale-3.0"):GetLocale(title, true)
db = {}
P = {} --db.profile
S = {} --perfix & player settings

local knownPrefixes		= SAM.prefixes --list pulled from Prefixes.lua

--Globals
local GAMEOPTIONS_MENU_						= _G.GAMEOPTIONS_MENU
local ENABLE_								= _G.ENABLE
local pairs_								= _G.pairs
local InterfaceOptionsFrame_OpenToCategory_	= _G.InterfaceOptionsFrame_OpenToCategory
local tostring_								= _G.tostring
local table_getn							= _G.table.getn
local GetFramesRegisteredForEvent_			= _G.GetFramesRegisteredForEvent
local table_insert							= _G.table.insert
local table_sort							= _G.table.sort
local UnitName_								= _G.UnitName
local date_									= _G.date
local GetNumIgnores_						= _G.GetNumIgnores
local GetIgnoreName_						= _G.GetIgnoreName
local string_char 							= _G.string.char
local StaticPopup_Show_						= _G.StaticPopup_Show
local GetRealNumPartyMembers_				= _G.GetRealNumPartyMembers
local GetRealNumRaidMembers_				= _G.GetRealNumRaidMembers
local GetNumRaidMembers_					= _G.GetNumRaidMembers
local IsInGuild_							= _G.IsInGuild
local ERR_GUILD_PLAYER_NOT_IN_GUILD_		= ERR_GUILD_PLAYER_NOT_IN_GUILD
local ERR_NOT_IN_RAID_						= ERR_NOT_IN_RAID


-- Default Settings
defaultSettings = {profile = {}}
defaultSettings.profile.defaultOutgoingAction	= 0 --0=allow, 1=deny
defaultSettings.profile.defaultIncomingAction	= 0 --0=allow, 1=deny
defaultSettings.profile.printOutgoingMessages	= 0 --off, 4=new
defaultSettings.profile.printIncomingMessages	= 0 --off
defaultSettings.profile.chatFrame				= 1 --main chat frame.
defaultSettings.profile.addIncomingPrefixes		= false
defaultSettings.profile.addOutgoingPrefixes		= true
defaultSettings.profile.ppSettings				= "global"--save prefix and player settings globally.


defaultSettings.global = {prefixActions	= {}, blockedSenders = {}}

-- Echo Strings
local strDebugFrom		= "|cffffff00[%s]|r" --Yellow function name. help pinpoint where the debug msg is from.
local strWhiteBar		= "|cffffff00 || |r" -- a white bar to seperate the debug info.
local greenText			= "|cff00ff00%s|r"
local redText			= "|cffff0000%s|r"
local yellowText		= "|cffffff00%s|r"
local grayText			= "|cff7f7f7f%s|r"
local colouredName		= "|cff7f7f7f{|r|cffff0000SAM|r|cff7f7f7f}|r "
local unknownAddon		= "??"

local notInRaid = {}
local notInGuild = {}

local coreUI
local prefixUI
local senderUI
local newPrefixes = {}

local userName

--IgnoreMore addon stuff.
local ignoreMoreRunning = false 
local ignoredNames = {}


badCharacters = {--these are some shady characters I tell ya.
	[string_char(1)] = true,
	[string_char(2)] = true,
	[string_char(3)] = true,
}

local regEvents = {
	"PLAYER_ENTERING_WORLD",
}

-- Ace3 Functions
function core:OnInitialize()
	db = LibStub("AceDB-3.0"):New("SAM_DB", defaultSettings, true)
	CoreOptionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)--save option profile or load another chars opts.
	db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")

	core:RegisterChatCommand("sam", "MySlashProcessorFunc")

	self:BuildAboutMenu()
	
	local config = LibStub("AceConfig-3.0")
	local dialog = LibStub("AceConfigDialog-3.0")
	config:RegisterOptionsTable(title, CoreOptionsTable)
	coreUI = dialog:AddToBlizOptions(title, "SAM "..version)
	
	config:RegisterOptionsTable(title.."Prefix", PrefixOptionsTable)
	prefixUI = dialog:AddToBlizOptions(title.."Prefix", L["Prefixes"], "SAM "..version)

	config:RegisterOptionsTable(title.."Sender", SenderOptionsTable)
	senderUI = dialog:AddToBlizOptions(title.."Sender", L["Players"], "SAM "..version)
	
	BuildPrefixUI()
	BuildSenderUI()
	
	for i, event in pairs(regEvents) do 
		core:RegisterEvent(event)
	end
	
	--reset options on old version.
	if version ~= "" then
		if not db.global.lastVersion then
			db.global.prefixActions = {}
			db.global.lastVersion = version
		end
	end
end



function core:OnEnable()
	P = db.profile
	S = db[P.ppSettings]

	--make all options clickable.
	for name, data in pairs_(CoreOptionsTable.args.core.args) do 
		if name ~= "enable" then
			CoreOptionsTable.args.core.args[name].disabled = false
		end
	end
	
	if _G.IgM_SV then-- IgnoreMore is running.
		ignoreMoreRunning = true
		UpdateIgnoreList()
		core:RegisterEvent("IGNORELIST_UPDATE")
	end
	
	userName = UnitName_("player")
	
	HookOnEventFrames()
	
	self:RawHook("SendAddonMessage", true)
	BuildPrefixUI()
end

------------------------------------------------------------------------------------------
function core:PLAYER_ENTERING_WORLD(event, ...)											--
-- This fires after ADDON_LOADED and PLAYER_LOGIN. 										--
-- Most addons would have created their frames and registered CHAT_MSG_ADDON by now.	--
------------------------------------------------------------------------------------------
	HookOnEventFrames()
end

--------------------------------------------------
function core:IGNORELIST_UPDATE(event, ...)		--
-- Update our list of ignored names. 			--
-- This only fires if IgnoreMore is running.	--
--------------------------------------------------
	UpdateIgnoreList()
end

----------------------------------------------
function core:MySlashProcessorFunc(input)	--
-- /att function brings up the UI options.	--
----------------------------------------------
	InterfaceOptionsFrame_OpenToCategory_(prefixUI)--Expands the menu.
	InterfaceOptionsFrame_OpenToCategory_(coreUI)--Shows the main screen.
end

------------------------------------------------------------------------------
function UpdateIgnoreList()													--
-- We cache ignored names. This is only if user's running IgnoreMore addon.	--
------------------------------------------------------------------------------
	ignoredNames = {} --reset, maybe they removed someone.
	local iName
	for i=1, GetNumIgnores_() do
		iName = GetIgnoreName_(i)
		if iName then--would this ever not exist?
			ignoredNames[iName] = true
		end
	end
end

------------------------------------------------------------------
function HookOnEventFrames()									--	/script SAM.HookOnEventFrames()
-- Raw hook frames so we can intercept their incoming messages.	--
------------------------------------------------------------------
	for i,frame in ipairs({GetFramesRegisteredForEvent("CHAT_MSG_ADDON")}) do
		if frame:HasScript("OnEvent") and not core:IsHooked(frame, "OnEvent") then
			core:RawHookScript(frame, "OnEvent", "OnEventHook")
--~ 			Debug("HookOnEventFrames", frame)
		end
    end
end

----------------------------------------------------------------------
function core:OnEventHook(frame, event, ...)						--
-- Our incoming message hook. We intercept incoming messages here.	--
----------------------------------------------------------------------
	if event == "CHAT_MSG_ADDON" then
		local prefix, message, distribution, sender = ...
		
		if sender ~= userName then --no need to block our own messages right?
--~ 			Debug("OnEventHook A", frame, ...)
			if ignoreMoreRunning == true and ignoredNames[sender] then
				--sender's on our ignore list. Lets ignore what they have to say.
--~ 				Debug("OnEventHook", "Blocking icoming msg from ignored", sender)
				return
			end
--~ 			Debug("OnEventHook B", frame, ...)
			--Check if sender is on our block list.
			if S.blockedSenders and S.blockedSenders[sender] then
				return
			end
--~ 			Debug("OnEventHook C", frame, ...)
			for char in pairs(badCharacters) do --Bad characters!
				while prefix:find(char) do
					prefix = prefix:gsub(char, "")--this won't affect how the addon recevies the prefix.
				end
			end
--~ 			Debug("OnEventHook D", frame, ...)
			
			if not prefix:find("[%c\127]") then
				local pA = S.prefixActions[prefix]
	
				if pA then
					if pA.incomingAction == 0 then --allow
						pA.incomingAllowed = pA.incomingAllowed + 1
						
						PrintIncomingAddonMessage("Allowed", false, ...)
					else
						pA.incomingDenied = pA.incomingDenied + 1
						
						PrintIncomingAddonMessage("Blocked", false, ...)
						return
					end
				elseif P.addIncomingPrefixes == true then
					newPrefixes[prefix] = true
					S.prefixActions[prefix] = {incomingDenied=0,incomingAllowed=0, outgoingDenied=0,outgoingAllowed=0}
					local pA = S.prefixActions[prefix]
					
					
					pA.incomingAction = P.defaultIncomingAction
					pA.outgoingAction = P.defaultOutgoingAction
					
					local addonName = knownPrefixes[prefix] or unknownAddon
					echo(L["Added incoming prefix |cffffff00%s|r (|cffffff00%s|r) from |cffffff00%s|r."]:format(prefix, addonName, sender))
	
					if P.defaultOutgoingAction == 0 then
						pA.incomingAllowed = 1
						PrintIncomingAddonMessage("Allowed", true, ...)
						BuildPrefixUI()
					else
						pA.incomingDenied = 1
						PrintIncomingAddonMessage("Blocked", true, ...)
						BuildPrefixUI()
						return
					end
				end
			end
			
			
--~ 			Debug("OnEventHook E", frame, ...)
		end
	end
	
	--send message to addon's event handler.
	self.hooks[frame].OnEvent(frame, event, ...)
end

--	/run SendAddonMessage("ZZZ","testing","GUILD")
--	/run SendAddonMessage("ZZZ","testing","RAID")
--------------------------------------------------------------------------------------
function core:SendAddonMessage(...)													--
-- Our send addon message hook. We check what prefix is being sent and block it.	--
--------------------------------------------------------------------------------------
	local prefix, text, type, target = ...
	-- 
	if type:lower() == "raid" and GetRealNumRaidMembers_() == 0 and GetNumRaidMembers_() > 0 then --some addons send msgs to raid while in BGs. 
		if not notInRaid[prefix] then
			notInRaid[prefix] = true
			echo("|cffffff00"..ERR_NOT_IN_RAID_.."|r |cff000000|||r "..L.blockedRaidMsg:format(knownPrefixes[prefix] or prefix))
		end
		return
	end
	
	if type:lower() == "party" and GetRealNumPartyMembers_() == 0 then
--~ 		Debug("SendAddonMessage","Stopped party msg")
		return
	end
	
	if type:lower() == "guild" and not IsInGuild_() then
--~ 		Debug("SendAddonMessage","Stopped guild msg")
		if not notInGuild[prefix] then
			notInGuild[prefix] = true
			echo("|cffffff00"..ERR_GUILD_PLAYER_NOT_IN_GUILD_.."|r |cff000000|||r "..L.blockedGuildMsg:format(knownPrefixes[prefix] or prefix))
		end
		return
	end
	
	if target then
		if ignoreMoreRunning == true and ignoredNames[target] then
			--target's on our ignore list. Lets not talk to them.
			return
		end
		
		if S.blockedSenders and S.blockedSenders[target] then
			--Name is on our block list, block the msg from leaving the client.
			return
		end
	end
	
	for char in pairs(badCharacters) do --Bad characters!
		while prefix:find(char) do
			prefix = prefix:gsub(char, "") --this won't affect the outgoing prefix.
		end
	end
		
	if not prefix:find("[%c\127]") then
		local pA = S.prefixActions[prefix]
		
		if pA then
			if pA.outgoingAction == 0 then --allow
				pA.outgoingAllowed = pA.outgoingAllowed + 1
				
				PrintOutgoingAddonMessage("Allowed", false, ...)
			else
				pA.outgoingDenied = pA.outgoingDenied + 1
				PrintOutgoingAddonMessage("Blocked", false, ...)
				return
			end
		elseif P.addOutgoingPrefixes == true then
			newPrefixes[prefix] = true
			S.prefixActions[prefix] = {incomingDenied=0,incomingAllowed=0, outgoingDenied=0,outgoingAllowed=0}
			local pA = S.prefixActions[prefix]
			pA.incomingAction = P.defaultIncomingAction or 0
			pA.outgoingAction = P.defaultOutgoingAction or 0
			
			local addonName = knownPrefixes[prefix] or unknownAddon
			echo(L["Added outgoing prefix |cffffff00%s|r (|cffffff00%s|r)."]:format(prefix, addonName))

			if P.defaultOutgoingAction == 0 then
				pA.outgoingAllowed = 1
				BuildPrefixUI()
				PrintOutgoingAddonMessage("Allowed", true, ...)
			else
				pA.outgoingDenied = 1
				BuildPrefixUI()
				PrintOutgoingAddonMessage("Blocked", true, ...)
				return
			end
		end
	end

	core.hooks.SendAddonMessage(...)
end

function core:OnDisable()
	--make all the options unclickable except for the enable button.
	for name, data in pairs_(CoreOptionsTable.args.core.args) do 
		if name ~= "enable" then
			CoreOptionsTable.args.core.args[name].disabled = true
		end
	end
end

----------------------------------------------------------------------
function core:OnProfileChanged(...)									--
-- User has reset proflie, so we reset addon.						--
----------------------------------------------------------------------
	-- Shut down anything left from previous settings
	self:Disable()
	-- Enable again with the new settings
	self:Enable()
end



------------------------------
function Debug(from, ...)	--	/script DA.Debug("hey","bye")
-- simple print function.	--
------------------------------
	if version ~= "" then--version's from curse, user doesn't need to see debug msgs.
		return
	end
	local tbl  = {...}
	local msg = tostring_(tbl[1])
	for i=2,table_getn(tbl) do 
		msg = msg..strWhiteBar..tostring_(tbl[i])
	end
	echo(strDebugFrom:format(tostring(from)).." "..tostring(msg))
end

function echo(...)
	local tbl  = {...}
	local msg = tostring_(tbl[1])
	for i=2,table_getn(tbl) do 
		msg = msg..strWhiteBar..tostring_(tbl[i])
	end
	
	local cf = _G["ChatFrame"..P.chatFrame]
	if cf then
		cf:AddMessage(colouredName..msg,.7,.7,.7)
	end
end

function PrintOutgoingAddonMessage(action, new, ...)
	local prefix, message, distribution, target  = ...
	local pA = S.prefixActions[prefix]

	if not pA then
		return
	end
	
	if pA and pA.printMsgs ~= true then
		if P.printOutgoingMessages == 0 then
			return
		elseif P.printOutgoingMessages == 2 and action ~= "Allowed" then
			return
		elseif P.printOutgoingMessages == 3 and action ~= "Blocked" then
			return
		elseif P.printOutgoingMessages == 4 and new ~= true then
			return
		end
	end
	
	
--~ 	Debug("out", pA.printMsgs, P.printOutgoingMessages, action, new)
	
	local cf = _G["ChatFrame"..P.chatFrame]
	if cf then
		if distribution == "WHISPER" then
			cf:AddMessage(colouredName.."|cffffffff"..L["Outgoing"].." "..L[action].."|r> |cffff0000"..prefix.."|r || |cff00ff00"..distribution.."|r || |cff00ffff"..target.."|r || "..message,.5,.5,.5)
		else
			cf:AddMessage(colouredName.."|cffffffff"..L["Outgoing"].." "..L[action].."|r> |cffff0000"..prefix.."|r || |cff00ff00"..distribution.."|r || "..message,.5,.5,.5)
		end
	end
end

--	/run SendAddonMessage("ZZZ","testing","WHISPER", UnitName("player"))
function PrintIncomingAddonMessage(action, new, ...)
	local prefix, message, distribution, sender  = ...
	local pA = S.prefixActions[prefix]
--~ 	print("PrintIncomingAddonMessage", action, new, pA, ...)
	if not pA then
		return
	end
	
	if pA and pA.printMsgs ~= true then
		if P.printIncomingMessages == 0 then--off
			return
		elseif P.printIncomingMessages == 2 and action ~= "Allowed" then
			return
		elseif P.printIncomingMessages == 3 and action ~= "Blocked" then
			return
		elseif P.printIncomingMessages == 4 and new ~= true then
			return
		end
	end
	
	local cf = _G["ChatFrame"..P.chatFrame]
	if cf then
		cf:AddMessage(colouredName.."|cffffffff"..L["Incoming"].." "..L[action].."|r> |cffff0000"..prefix.."|r || |cff00ff00"..distribution.."|r || |cff00ffff"..sender.."|r || "..message,.5,.5,.5)
	end
end

--------------------------------------------------------------
function GetPrefixColour(prefix)							--
-- Returns a red, green or yellow string of the prefix.		--
-- Red = blocked, green = allowed, yellow = half blocked.	--
--------------------------------------------------------------
	local pA = S.prefixActions[prefix]
	if pA.outgoingAction == 0 and pA.incomingAction == 0 then
		return greenText:format(prefix)
	elseif pA.outgoingAction == 1 and pA.incomingAction == 1 then
		return redText:format(prefix)
	else
		return yellowText:format(prefix)
	end
end

function AddNewSender(name)
	if not S.blockedSenders[name] then
		S.blockedSenders[name] = {}
	end
	S.blockedSenders[name].when = date_("%c")
	
	BuildSenderUI()
end

function RemoveSender(name)
	S.blockedSenders[name] = nil
	BuildSenderUI()
	echo(L["Removed |cffffff00%s|r from list."]:format(name))
end


----------------
--     UI     --
----------------
_G.StaticPopupDialogs["SAM_IncomingPrefixNote"] = {
	text = L["StopAddonMessage\nPlease note. There's no benefit in blocking prefixes if you're not running the addon that receives them."],
	button1 = OKAY,
	timeout = 0,
	hideOnEscape = 1,
}


PrefixOptionsTable = {
	name = titleFull,
	type = "group",
	args = {},
}

SenderOptionsTable = {
	name = titleFull,
	type = "group",
	args = {},
}

SenderOptionsTable.args.whatThisDo = {
	type = "description",	order = 1,
	name = L["Block messages incoming and outgoing to these players"],
}

tmpNewName = ""
SenderOptionsTable.args.inputName = {
	type = "input",	order	= 2,
	name = L["Name"],
	desc = L["Input a name to block"],
	set = function(info,val) 
		tmpNewName = val
	end,
	get = function(info) return tmpNewName end
}

SenderOptionsTable.args.addName = {
	type = "execute",	order	= 3,
	name	= L["Add Name"],
	desc	= L["Add sender name to list"],
	func = function(info) 
		if tmpNewName ~= "" then
			AddNewSender(tmpNewName)
			tmpNewName = ""
		end
	end
}

SenderOptionsTable.args.senderList = {
	type = "group",	order	= 4,
	name	= L["Names"],
	args={}
}


---------------------------

CoreOptionsTable = {
	name = titleFull,
	type = "group",
	childGroups = "tab",

	args = {
		core={
			name = GAMEOPTIONS_MENU_,
			type = "group",
			order = 1,
			args={}
		},
	},
}




CoreOptionsTable.args.core.args.enable = {
	type = "toggle",	order	= 1,
	name	= ENABLE_,
	desc	= L["Enables / Disables the addon"],
	set = function(info,val) 
		if val == true then
			core:Enable()
		else
			core:Disable()
		end
	end,
	get = function(info) return core:IsEnabled() end
}

CoreOptionsTable.args.core.args.chatFrame = {
	name = L["Chat Frame"],
	order = 2,
	desc = L["Chat frame to print messages to"],
	type = "select",
	
	values = function()
		local tbl = {}
		for i=1, NUM_CHAT_WINDOWS do 
			table_insert(tbl,(_G["ChatFrame"..i] and _G["ChatFrame"..i].name) or "ChatFrame"..i)
		end
		return tbl
	end,
	set = function(info,val) 
		P.chatFrame = val
	end,
	get = function(info) return P.chatFrame end
}



CoreOptionsTable.args.core.args.ppSettings = {--prefix & player settings
	name = L["Save Prefixes & Players"],
	order = 3,
	desc = L["Save prefix & player settings globally or per profile."],
	type = "select",
	
	values = function()
		return {["global"]=L["Globally"], ["profile"]=L["Per profile"]}
	end,
	set = function(info,val) 
		P.ppSettings = val
		
		S = db[val]
		
		if not db[val].blockedSenders then
			S.blockedSenders = {}
		end
		if not db[val].prefixActions then
			S.prefixActions = {}
		end

		BuildPrefixUI()
		BuildSenderUI()
	end,
	get = function(info) return P.ppSettings end
}

CoreOptionsTable.args.core.args.incomingHeader = {
	name	= L["Incoming"],
	order	= 10,
	type = "header",
}

CoreOptionsTable.args.core.args.defaultIncomingAction = {
	name = L["Default Action"],
	order = 11,
	desc = L["Default action for new incoming prefixes"],
	type = "select",
	
	values = function()
		return {[0]=greenText:format(L["Allow"]), [1]=redText:format(L["Block"])}
	end,
	set = function(info,val) 
		P.defaultIncomingAction = val
	end,
	get = function(info) return P.defaultIncomingAction end
}

CoreOptionsTable.args.core.args.printIncomingMessages = {
	name = L["Print Messages"],
	order = 12,
	desc = L["Print your incoming messages to a chat frame."],
	type = "select",
	
	values = function()
		return {
			[0] = L["Off"],
			[1] = L["All"],
			[2] = L["Allowed"],
			[3] = L["Blocked"],
--~ 			[4] = L["New"],
		}
		
	end,
	set = function(info,val) 
		P.printIncomingMessages = val
	end,
	get = function(info) return P.printIncomingMessages end
}

CoreOptionsTable.args.core.args.addIncomingPrefixes = {
	type = "toggle",	order	= 13,
	name	= L["Add incoming prefixes"],
	desc	= L["Add incoming prefixes to the prefix list."],
	set = function(info,val) 
		P.addIncomingPrefixes = val
		if val == true then
			StaticPopup_Show_("SAM_IncomingPrefixNote")
		end
		
	end,
	get = function(info) return P.addIncomingPrefixes end
}


CoreOptionsTable.args.core.args.outgoingHeader = {
	name	= L["Outgoing"],
	order	= 20,
	type = "header",
}


CoreOptionsTable.args.core.args.defaultOutgoingAction = {
	name = L["Default Action"],
	order = 21,
	desc = L["Default action for new outgoing prefixes"],
	type = "select",
	
	values = function()
		return {[0]=greenText:format(L["Allow"]), [1]=redText:format(L["Block"])}
	end,
	set = function(info,val) 
		P.defaultOutgoingAction = val
	end,
	get = function(info) return P.defaultOutgoingAction end
}



CoreOptionsTable.args.core.args.printOutgoingMessages = {
	name = L["Print Messages"],
	order = 22,
	desc = L["Print your outgoing messages to a chat frame."],
	type = "select",
	
	values = function()
		return {
			[0] = L["Off"],
			[1] = L["All"],
			[2] = L["Allowed"],
			[3] = L["Blocked"],
--~ 			[4] = L["New"],
		}
		
	end,
	set = function(info,val) 
		P.printOutgoingMessages = val
	end,
	get = function(info) return P.printOutgoingMessages end
}

CoreOptionsTable.args.core.args.addOutgoingPrefixes = {
	type = "toggle",	order	= 23,
	name	= L["Add outgoing prefixes"],
	desc	= L["Add outgoing prefixes to the prefix list."],
	set = function(info,val) 
		P.addOutgoingPrefixes = val
	end,
	get = function(info) return P.addOutgoingPrefixes end
}

function BuildSenderUI()
	SenderOptionsTable.args.senderList.args = {} --reset
	
	if not S.blockedSenders then
		return
	end
	
	
	local list = {}
	for name, data in pairs_(S.blockedSenders) do 
		table_insert(list, name)
	end
	
	table_sort(list, function(a,b) 
		if(a and b) then 
			return a < b
		end 
	end)
	
	local sender, data
	for i=1, table_getn(list) do 
		sender = list[i]
		data = S.blockedSenders[sender]
		
		SenderOptionsTable.args.senderList.args[sender] = {
			type	= "group",
			name	= sender,
			desc	= "someName",
			order = i,
			args={}
		}
		
		SenderOptionsTable.args.senderList.args[sender].args.addedWhen = {
			type = "description",	order = 1,
			name = L["Added: "]..data.when,
		}
		
		
		SenderOptionsTable.args.senderList.args[sender].args.removeSender = {
			type = "execute",	order	= 10,
			name	= L["Remove Name"],
			desc	= L["Remove sender name from list"],
			func = function(info) 
				RemoveSender(info[2])
			end
		}
		
	end
	
end


function BuildPrefixUI()--	/script SAM.BuildPrefixUI()
	PrefixOptionsTable.args = {} --reset
	
	if not S.prefixActions then
		return
	end
	
	local addonPrefixes = {}
	
	local addonName
	
	--Get addonname of prefixes and insert them into a sortable table.
	for prefix, data in pairs_(S.prefixActions) do 
		if not prefix:find("[%c\127]") then
			addonName = knownPrefixes[prefix] or unknownAddon
			if not addonPrefixes[addonName] then
				addonPrefixes[addonName] = {}
			end
			table.insert(addonPrefixes[addonName], prefix)
		end
	end

	--Sort the prefixes in each addon.
	for addon in pairs(addonPrefixes) do 
		table_sort(addonPrefixes[addon], function(a,b) 
			if(a and b) then 
				return a < b
			end 
		end)
	end
	
	--Sort the addon's list.
	local sortedAddons = {}
	for addon, data in pairs_(addonPrefixes) do 
		table.insert(sortedAddons, addon)
	end
	
	table_sort(sortedAddons, function(a,b) 
		if(a and b) then 
			return a < b
		end 
	end)
		
	
	local prefix--prefix
	local pColoured--coloured prefix
	local isNew
	local prefixes--string list of prefixes.
	local aColoured --coloured addon
	local numAllowed, numBlocked
	for a=1, table_getn(sortedAddons) do 
		addonName = sortedAddons[a]

		--If a new prefix is in the list, add gray 'New' to title.
		isNew = false
		if newPrefixes[addonPrefixes[addonName][1]] then
			isNew = true
		end
		
		numAllowed = 0
		numBlocked = 0
		prefixes = ""
		for p=1, table_getn(addonPrefixes[addonName]) do
			prefixes = prefixes..GetPrefixColour(addonPrefixes[addonName][p])..", "
			
			if S.prefixActions[addonPrefixes[addonName][p]].incomingAction == 0 then
				numAllowed = numAllowed + 1
			else
				numBlocked = numBlocked + 1
			end
			if S.prefixActions[addonPrefixes[addonName][p]].outgoingAction == 0 then
				numAllowed = numAllowed + 1
			else
				numBlocked = numBlocked + 1
			end
			
		end
		prefixes	= prefixes:sub(1,prefixes:len() - 2)--remove the last ", "

		if numAllowed > 0 and numBlocked == 0 then
			aColoured = greenText:format(addonName)
		elseif numBlocked > 0 and numAllowed == 0 then
			aColoured = redText:format(addonName)
		else
			aColoured = yellowText:format(addonName)
		end

		--Add the gray text to title.
		if isNew == true then
			aColoured = aColoured .. " "..grayText:format(L["New"])
		end
		
		--Create the addon's prefix table.
		PrefixOptionsTable.args[addonName] = {
			type = "group",	order	= a,
			name	= aColoured,
			desc	= prefixes,
			args={}
		}
		
		--Add list of prefixes addon uses.
		PrefixOptionsTable.args[addonName].args.prefixes = {
			type = "description",	order = 1,
			name = L["Prefixes"]..": "..prefixes,
		}

		--Add buttons to allow/block all prefixes for a addon.
		if addonName ~= unknownAddon then
			PrefixOptionsTable.args[addonName].args.allowAll = {
				type = "execute",	order	= 2,
				width = "half",
				name	= L["Allow"],
				desc	= L["Allow all incoming and outgoing"],
				func = function(info) 
					for prefix, data in pairs_(S.prefixActions) do 
						if knownPrefixes[prefix] and knownPrefixes[prefix] == info[1] then
							S.prefixActions[prefix].incomingAction = 0 --allow
							S.prefixActions[prefix].outgoingAction = 0 --allow
							
						end
					end
					BuildPrefixUI()
				end
			}
		
			PrefixOptionsTable.args[addonName].args.blockAll = {
				type = "execute",	order	= 3,
				width = "half",
				name	= L["Block"],
				desc	= L["Block all incoming and outgoing"],
				func = function(info) 
					for prefix, data in pairs_(S.prefixActions) do 
						if knownPrefixes[prefix] and knownPrefixes[prefix] == info[1] then
							S.prefixActions[prefix].incomingAction = 1 --allow
							S.prefixActions[prefix].outgoingAction = 1 --allow
							
						end
					end
					BuildPrefixUI()
				end
			}
		end
		
		
		
		--Add each prefix to the addon's sub menu.
		for p=1, table_getn(addonPrefixes[addonName]) do 
			prefix = addonPrefixes[addonName][p]
			
			--Colour the prefix based on blockage.
			
			
			pColoured = GetPrefixColour(prefix)
	
			--Add gray 'New' text if prefix is new this session.
			if newPrefixes[prefix] then
				pColoured = pColoured .. " "..grayText:format(L["New"])
			end

			--Add the prefix menu
			PrefixOptionsTable.args[addonName].args[prefix] = {
				type	= "group",
				name	= pColoured,
				desc	= addonName,
				order = p,
				args={}
			}
		
			--Add pulldown menu of what to do on incoming messages.
			PrefixOptionsTable.args[addonName].args[prefix].args.incomingAction = {
				name = L["Incoming"].." "..L["Action"],
				order = 4,
				desc = L["What to do when message is received."],
				type = "select",
				
				values = function()
					return {[0]=greenText:format(L["Allow"]), [1]=redText:format(L["Block"])}
				end,
				set = function(info,val) 
					S.prefixActions[info[2]].incomingAction = val
					BuildPrefixUI()
				end,
				get = function(info) return S.prefixActions[info[2]].incomingAction end
			}
			
			--Add outgoing message pulldown menu.
			PrefixOptionsTable.args[addonName].args[prefix].args.outgoingAction = {
				name = L["Outgoing"].." "..L["Action"],
				order = 5,
				desc = L["What to do when message is sent."],
				type = "select",
				
				values = function()
					return {[0]=greenText:format(L["Allow"]), [1]=redText:format(L["Block"])}
				end,
				set = function(info,val) 
					S.prefixActions[info[2]].outgoingAction = val
					BuildPrefixUI()
				end,
				get = function(info) return S.prefixActions[info[2]].outgoingAction end
			}
	
			--Show how many times the incoming prefix has been allowed/blocked.
			PrefixOptionsTable.args[addonName].args[prefix].args.incomingCount = {
				type = "description",
				name = L["Incoming"]..": "..greenText:format((S.prefixActions[prefix].incomingAllowed or 0)).." :: "..redText:format((S.prefixActions[prefix].incomingDenied or 0)),
				order = 6,
			}
			
			--Show how many times the outgoing prefix has been allowed/blocked.
			PrefixOptionsTable.args[addonName].args[prefix].args.outgoingCount = {
				type = "description",
				name = L["Outgoing"]..": "..greenText:format((S.prefixActions[prefix].outgoingAllowed or 0)).." :: "..redText:format((S.prefixActions[prefix].outgoingDenied or 0)),
				order = 7,
			}
	
			--Add option to print this prefixes messages to chat.
			PrefixOptionsTable.args[addonName].args[prefix].args.printMsgs = {
				type = "toggle",	order	= 8,
				name	= L["Print message"],
				desc	= L["Print this prefix's messages to chat frame."],
				set = function(info,val) 
					S.prefixActions[info[2]].printMsgs = val
				end,
				get = function(info) return S.prefixActions[info[2]].printMsgs end
			}	

			--Add a remove button. 
			PrefixOptionsTable.args[addonName].args[prefix].args.removePrefix = {
				type = "execute",	order	= 10,
				name	= L["Remove Prefix"],
				desc	= L["Remove prefix from list."],
				func = function(info) 
					S.prefixActions[info[2]] = nil
					BuildPrefixUI()
				end
			}

		end
	end
end

do
	local tostring = tostring
	local GetAddOnMetadata = GetAddOnMetadata
	local pairs = pairs
	local fields = {"Author", "X-Category", "X-License", "X-Email", "Email", "eMail", "X-Website", "X-Credits", "X-Localizations", "X-Donate", "X-Bitcoin"}
	local haseditbox = {["X-Website"] = true, ["X-Email"] = true, ["X-Donate"] = true, ["Email"] = true, ["eMail"] = true, ["X-Bitcoin"] = true}
	local fNames = {
		["Author"] = L.author,
		["X-License"] = L.license,
		["X-Website"] = L.website,
		["X-Donate"] = L.donate,
		["X-Email"] = L.email,
		["X-Bitcoin"] = L.bitcoinAddress,
	}
	local yellow = "|cffffd100%s|r"
	
	local val
	local options
	function core:BuildAboutMenu()
		options = self.options
		
		CoreOptionsTable.args.about = {
			type = "group",
			name = L.about,
			order = 99,
			args = {
			}
		}

		
		CoreOptionsTable.args.about.args.title = {
			type = "description",
			name = yellow:format(L.title..": ")..title,
			order = 1,
		}
		CoreOptionsTable.args.about.args.version = {
			type = "description",
			name = yellow:format(L.version..": ")..version,
			order = 2,
		}
		CoreOptionsTable.args.about.args.notes = {
			type = "description",
			name = yellow:format(L.notes..": ")..tostring(GetAddOnMetadata(folder, "Notes")),
			order = 3,
		}
	
		for i,field in pairs(fields) do
			val = GetAddOnMetadata(folder, field)
			if val then
				
				if haseditbox[field] then
					CoreOptionsTable.args.about.args[field] = {
						type = "input",
						name = fNames[field] or field,
						order = i+10,
						desc = L.clickCopy,
						width = "full",
						get = function(info)
							local key = info[#info]
							return GetAddOnMetadata(folder, key)
						end,	
					}
				else
					CoreOptionsTable.args.about.args[field] = {
						type = "description",
						name = yellow:format((fNames[field] or field)..": ")..val,
						width = "full",
						order = i+10,
					}
				end
		
			end
		end
	
		LibStub("AceConfig-3.0"):RegisterOptionsTable(title, CoreOptionsTable ) --
--~ 		LibStub("AceConfigDialog-3.0"):SetDefaultSize(title, 600, 500) --680
	end
end