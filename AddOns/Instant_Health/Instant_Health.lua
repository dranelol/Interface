-- Author: Meloeth

Original_UnitHealth = UnitHealth
local Original_UnitHealth = UnitHealth

local _G = _G
local pairs = _G.pairs
local select = _G.select
local UnitGUID = _G.UnitGUID
local strsplit = _G.strsplit
local UnitExists = _G.UnitExists
local UnitHealthMax = _G.UnitHealthMax
local GetFramesRegisteredForEvent = _G.GetFramesRegisteredForEvent

local activeGUID = {}
local enabled = false
local IH_event = {}
local filterUnitID = {}
local register = {}
local registerExtra = {}
IH_Settings = { ["filter"] = false }
local filter = false
Instant_Health_frame = CreateFrame("Frame", "Instant_Health_frame")

function IH_Register(key, method, extra)
	if type(key) ~= "string" then
		error("First argument must be a string")
		return
	end
	if method and type(method) ~= "function" then
		error("Second argument must be a function")
		return
	end
	if extra then
		registerExtra[key] = true
	else
		registerExtra[key] = false
	end
	
	register[key] = method
	registerExtra[key] = extra
end

function IH_Unregister(key)
	if type(key) ~= "string" then
		error("Key must be of type string")
		return
	end
	
	if register[key] then
		register[key] = nil
		registerExtra[key] = nil
		return true
	else
		return false
	end
end

function IH_IterateRegister()
	return pairs(register)
end

function IH_UnitHealth(unitID, ...)
	if UnitExists(unitID) then
		local unitTable = activeGUID[UnitGUID(unitID)]
		if unitTable ~= nil and unitTable.health ~= 0 then
			unitTable.unitID[unitID] = true
			return unitTable.health
		elseif(UnitHealthMax(unitID) ~= 100) then
			local health = Original_UnitHealth(unitID, ...)
			if health < 2 then
				return Original_UnitHealth(unitID, ...) 
			end
			activeGUID[UnitGUID(unitID)] = {
				["unitID"] = {[unitID] = true},
				["health"] = health,
				["history"] = {},
				["historyEnd"] = 29,
				["getHealth"] = health
			}
			return Original_UnitHealth(unitID, ...)
		end
		return Original_UnitHealth(unitID, ...)
	else
		if unitTable ~= nil then
			activeGUID[UnitGUID(unitID)] = nil
		end
	end
	return Original_UnitHealth(unitID, ...)
end

local L = {
	["noregister"] = "No addons has registered for faster health updates.",
	["filterinfo"] = "Turning on the filter will make only addons that has registered for faster health updates recieve them.",
	["filteroptions"] = "Options: enable, disable",
	["enable"] = "|cffffff00Filter enabled|r",
	["disable"] = "|cffffff00Filter disabled|r",
	["load"] = "Instant Health loaded succesfully."
}

local function IH_SlashHandler(msg)
	msg1, msg2 = strsplit(" ", strlower(msg))
	if msg1 == "list" then
		local count = 0
		for key,method in pairs(register) do
			count = count + 1
			DEFAULT_CHAT_FRAME:AddMessage(count..". "..key)
		end
		if count == 0 then
			DEFAULT_CHAT_FRAME:AddMessage(L.noregister)
		end
	elseif msg1 == "filter" then
		if not msg2 then
			DEFAULT_CHAT_FRAME:AddMessage(L.filterinfo)
			DEFAULT_CHAT_FRAME:AddMessage(L.filteroptions)
			DEFAULT_CHAT_FRAME:AddMessage(L.status)
		elseif msg2 == "enable" then
			local count = 0
			for key,method in pairs(register) do
				count = count + 1
			end
			if count == 0 then
				DEFAULT_CHAT_FRAME:AddMessage(localization.noregister)
				return
			end
			L.status = L.enable
			DEFAULT_CHAT_FRAME:AddMessage(L.status)
			IH_Settings.filter = true
			filter = true
			UnitHealth = Original_UnitHealth
		elseif msg2 == "disable" then
			L.status = L.disable
			DEFAULT_CHAT_FRAME:AddMessage(L.status)
			IH_Settings.filter = false
			filter = false
			UnitHealth = IH_UnitHealth
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("Options: list, filter")
		DEFAULT_CHAT_FRAME:AddMessage(L.status)
	end
end

local function IH_CombatLogFilter(timestamp, msg, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, msg1, msg2, msg3, msg4)
	local prefix, suffix, special = strsplit("_", msg)
	if prefix == "SPELL" then
		if suffix == "HEAL" or special == "HEAL" then
			return msg4
		elseif suffix == "DAMAGE" or special == "DAMAGE" then
			return -msg4
		end
	elseif suffix == "DAMAGE" then
		if prefix == "SWING" then
			return -msg1
		elseif prefix == "RANGE" then
			return -msg4
		elseif prefix == "ENVIRONMENTAL" then
			return -msg2
		end
	elseif prefix == "DAMAGE" and special ~= "MISSED" then
		return -msg4
	end
	return 0
end

local function IH_GenerateFilteredEvents(unitID)
	for key,method in pairs(register) do
		if method then
			for id, exists in pairs(unitID) do
				if exists and (registerExtra[key] or filterUnitID[id]) then
					method(id)
				end
			end
		end
	end
end

local function IH_GenerateEvents(unitID, ...)
	for i = 1, select("#", ...) do
		if (select(i, ...) ~= Instant_Health_frame) then
			for id, exists in pairs(unitID) do
				if exists and filterUnitID[id] then
					local frame = select(i, ...)
					local script = frame:GetScript("OnEvent")
					if script then
						event = "UNIT_HEALTH"
						arg1 = id
						this = frame
						script(frame, "UNIT_HEALTH", id)
					end
				end
			end
		end
	end
end

local function IH_Reregister(...)
	for i = 1, select("#", ...) do
		if (select(i, ...) ~= Instant_Health_frame) then
			select(i, ...):UnregisterEvent("UNIT_HEALTH")
			select(i, ...):RegisterEvent("UNIT_HEALTH")
		end
	end
end

function IH_event.PLAYER_LEAVING_WORLD(arg1)
	enabled = false
	activeGUID = {}
end

function IH_event.PLAYER_ENTERING_WORLD(arg1)
	enabled = true
end

function IH_event.COMBAT_LOG_EVENT_UNFILTERED(...)
	Instant_Health_frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local dstGUID = select(6, ...)
	if(enabled and activeGUID[dstGUID]~=nil) then
		local unitTable = activeGUID[dstGUID]
		local validID = "none"
		for id, exists in pairs(unitTable.unitID) do
			if dstGUID == UnitGUID(id) then
				validID = id
			else
				unitTable.unitID[id] = false
			end
		end
		if( UnitExists(validID) ) then
			if(UnitHealthMax(validID) ~= 100) then
				local health = unitTable.health
				local maxHealth = UnitHealthMax(validID)
				unitTable.health = unitTable.health + IH_CombatLogFilter(...)
				if (unitTable.health > maxHealth) then
					unitTable.health = maxHealth
				end
				local change = unitTable.health - health
				if(change ~= 0) then
					IH_GenerateFilteredEvents(unitTable.unitID)
					if not filter then
						IH_GenerateEvents(unitTable.unitID, GetFramesRegisteredForEvent("UNIT_HEALTH"))
					end
					unitTable.historyEnd = (unitTable.historyEnd + 1) % 30
					unitTable.history[unitTable.historyEnd + 1] = change
				end
			else
				for id, exists in pairs(unitTable.unitID) do
					unitTable.unitID[id] = false
				end
			end
		else
			activeGUID[dstGUID] = nil
		end
	end
end

function IH_event.UNIT_HEALTH(arg1)
	local unitTable = activeGUID[UnitGUID(arg1)]
	if(unitTable ~= nil) then
		unitTable.unitID[arg1] = true
		if(unitTable.health == unitTable.getHealth and unitTable.getHealth ~= Original_UnitHealth(arg1)) then
			unitTable.getHealth = Original_UnitHealth(arg1)
			unitTable.health = unitTable.getHealth
			IH_GenerateFilteredEvents(unitTable.unitID)
		else
			local testHealth = unitTable.health
			local size = #(unitTable.history) - 1
			
			for i=0, size do
				if(testHealth == unitTable.getHealth) then
					unitTable.getHealth = Original_UnitHealth(arg1)
					return
				end
				testHealth = testHealth - unitTable.history[(unitTable.historyEnd - i) % 30 + 1]
			end
			testHealth = unitTable.health
			
			unitTable.getHealth = Original_UnitHealth(arg1)
			for i=0, size do
				if(testHealth == unitTable.getHealth) then
					return
				end
				testHealth = testHealth - unitTable.history[(unitTable.historyEnd - i) % 30 + 1]
			end
			
			unitTable.health = unitTable.getHealth
			IH_GenerateFilteredEvents(unitTable.unitID)
		end
	else
		IH_GenerateFilteredEvents({[arg1]=true})
	end
end

function IH_event.ADDON_LOADED(arg1)
	if arg1 == "Instant_Health" then
		SLASH_InstantHealth1 = "/InstantHealth"
		SlashCmdList["InstantHealth"] = IH_SlashHandler
		filter = IH_Settings.filter
		if not filter then
			L.status = L.disable
			UnitHealth = IH_UnitHealth
		else
			L.status = L.enable
		end
		DEFAULT_CHAT_FRAME:AddMessage(strjoin(" ", L.load, L.status))
	end
end
	
function IH_event.PLAYER_LOGIN()
	filterUnitID["player"] = true
	filterUnitID["target"] = true
	filterUnitID["focus"] = true
	filterUnitID["pet"] = true
	for i=1, 40 do
		filterUnitID["raid"..i] = true
		filterUnitID["raidpet"..i] = true
	end
	for i=1, 4 do
		filterUnitID["party"..i] = true
		filterUnitID["partypet"..i] = true
	end
end

local function CombatLogEvent()
	Instant_Health_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local delayFrame = CreateFrame("Frame", "delayFrame")
delayFrame:SetScript("OnEvent", CombatLogEvent)
delayFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local dummyFrame = CreateFrame("Frame", "DummyFrame")
dummyFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") -- makes sure delayFrame is never the last frame registered for COMBAT_LOG_EVENT_UNFILTERED

Instant_Health_frame:SetScript("OnEvent", function(this, event, ...) IH_event[event](...) end)
Instant_Health_frame:RegisterEvent("UNIT_HEALTH")
Instant_Health_frame:RegisterEvent("PLAYER_LEAVING_WORLD")
Instant_Health_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Instant_Health_frame:RegisterEvent("PLAYER_LOGIN")
Instant_Health_frame:RegisterEvent("ADDON_LOADED");

IH_Reregister(GetFramesRegisteredForEvent("UNIT_HEALTH"))