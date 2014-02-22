--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Korvo on US Proudmoore
--  - Idunnô, Clorell, Mcstabin on US Hellscream
--

-------------------------------------------------------
-- Proculas
Proculas = LibStub("AceAddon-3.0"):NewAddon("Proculas", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0", "LibEffects-1.0", "LibBars-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

Proculas.enabled = true

-------------------------------------------------------
-- Proculas Version
Proculas.revision = "c70b5b769c60"
Proculas.version = GetAddOnMetadata('Proculas', 'Version').." c70b5b769c60"
if(Proculas.revision == "@".."project-abbreviated-hash".."@") then
	Proculas.version = "DEV"
end
local VERSION = Proculas.version

-------------------------------------------------------
-- Register some media
LSM:Register("sound", "Rubber Ducky", [[Sound\Doodad\Goblin_Lottery_Open01.wav]])
LSM:Register("sound", "Cartoon FX", [[Sound\Doodad\Goblin_Lottery_Open03.wav]])
LSM:Register("sound", "Explosion", [[Sound\Doodad\Hellfire_Raid_FX_Explosion05.wav]])
LSM:Register("sound", "Shing!", [[Sound\Doodad\PortcullisActive_Closed.wav]])
LSM:Register("sound", "Wham!", [[Sound\Doodad\PVP_Lordaeron_Door_Open.wav]])
LSM:Register("sound", "Simon Chime", [[Sound\Doodad\SimonGame_LargeBlueTree.wav]])
LSM:Register("sound", "War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.wav]])
LSM:Register("sound", "Cheer", [[Sound\Event Sounds\OgreEventCheerUnique.wav]])
LSM:Register("sound", "Humm", [[Sound\Spells\SimonGame_Visual_GameStart.wav]])
LSM:Register("sound", "Short Circuit", [[Sound\Spells\SimonGame_Visual_BadPress.wav]])
LSM:Register("sound", "Fel Portal", [[Sound\Spells\Sunwell_Fel_PortalStand.wav]])
LSM:Register("sound", "Fel Nova", [[Sound\Spells\SeepingGaseous_Fel_Nova.wav]])

-------------------------------------------------------
-- Procs
Proculas.procs = {
	ITEMS = {},
	ENCHANTS = {},
	GEMS = {},
	PALADIN = {},
	DEATHKNIGHT = {},
	SHAMAN = {},
	HUNTER = {},
	PRIEST = {},
	ROGUE = {},
	DRUID = {},
	WARRIOR = {},
	WARLOCK = {},
	MAGE = {},
}

-------------------------------------------------------
-- Things that need to be defined locally
local playerClass = select(2,UnitClass("player"))
local playerName = UnitName("player")
local combatTickTimer
local inCombat

-------------------------------------------------------
-- Startup stuff

-- OnInitialize
function Proculas:OnInitialize()
	self:Print(VERSION.." running.")

	-- Database stuff
	self.db = LibStub("AceDB-3.0"):New("ProculasDB", self.defaults)
	self.opt = self.db.profile
	self.optpc = self.db.char

	-- Tracked procs
	self.tracked = self.optpc.tracked

	-- Active procs
	self.active = {}

	-- Create the Cooldown bars frame.
	self:CreateCDFrame()

	-- Set the Sink options.
	self:SetSinkStorage(self.opt.sinkOptions)

	-- Register Custom Sounds
	for name,info in pairs(self.opt.customSounds) do
		LSM:Register("sound", info.name, info.location)
	end

	self.newproc = {types={}}
end

-- OnEnable
function Proculas:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	combatTickTimer = self:ScheduleRepeatingTimer("combatTick", 1)
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:scanForProcs();
end

-------------------------------------------------------
-- Custom Sounds

-- Add Custom Sound
function Proculas:addCustomSound(sname,slocation)
	self.opt.customSounds[sname] = {name = sname,location = slocation}
	LSM:Register("sound", sname, slocation)
end

-- Delete Custom Sound
function Proculas:deleteCustomSound(sname)
	self.opt.customSounds[sname] = nil
end

-------------------------------------------------------
-- Time Functions

-- Increments the proc uptime count
function Proculas:combatTick()
	for key,proc in pairs(self.optpc.procs) do
		-- Update seconds for uptime calculation
		if self.active[proc.procId] then
			proc.uptime = proc.uptime+1
		end
		-- Update Total Time
		if self.active[proc.procId] or inCombat then
			proc.time = proc.time+1
		end
	end

	--for procID, spellID in pairs(self.active) do
	--	self.optpc.tracked[spellID].uptime = self.optpc.tracked[spellID].uptime+1
	--end
end

-- Does the required things for when the player enters combat
function Proculas:PLAYER_REGEN_DISABLED()
	--combatTickTimer = self:ScheduleRepeatingTimer("combatTick", 1)
	inCombat = true
end

-- Does the required things for when the player leaves combat
function Proculas:PLAYER_REGEN_ENABLED()
	--self:CancelTimer(combatTickTimer)
	inCombat = false
end

-------------------------------------------------------
-- Proc Functions

-- Adds Procs to the Proc List
function Proculas:addProcList(list,procs)
	for id,info in pairs(procs) do
		self.procs[list][id] = info
	end
end

-- Adds a proc to the tracked procs
function Proculas:addProc(procInfo)
	if not procInfo.rank then
		procInfo.rank = ""
	end
	if not self.optpc.procs[procInfo.procId] then
		self:debug("Adding proc: "..procInfo.name)--.." | "..procInfo.spellId)
		local procStats = {}
		procStats.name = procInfo.name
		procStats.rank = procInfo.rank
		procStats.count = 0
		procStats.started = 0
		procStats.uptime = 0
		procStats.cooldown = 0
		procStats.lastProc = 0
		procStats.updateCD = true
		procStats.enabled = true
		procStats.time = 0
		procStats.icon = procInfo.icon
		procStats.procId = procInfo.procId
		if procInfo.heroic then
			procStats.heroic = true
		end

		self.optpc.procs[procInfo.procId] = procStats

		for _,spellId in pairs(procInfo.spellIds) do
			local procData = {}
			procData.name = procInfo.name
			procData.rank = procInfo.rank
			procData.types = procInfo.types
			procData.onSelfOnly = procInfo.onSelfOnly
			procData.procId = procInfo.procId
			if procInfo.itemID then
				procData.itemID = procInfo.itemID
			end
			if procInfo.heroic then
				procData.heroic = true
			end
			self.optpc.tracked[tonumber(spellId)] = procData
		end
		self:Print("Added proc: "..procInfo.name);
	end
end

-- Adds the proc from the options panel.
function Proculas:addNewProc()
	-- blarg...
	procId = 'custom'..time()
	procInfo = {types={}}

	procInfo.procId = procId
	procInfo.count = 0
	procInfo.started = 0
	procInfo.uptime = 0
	procInfo.cooldown = 0
	procInfo.lastProc = 0
	procInfo.updateCD = true
	procInfo.enabled = true
	procInfo.time = 0

	if not self.newproc.name or not self.newproc.spellId then
		return
	end

	if self.newproc.item then
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self.newproc.itemId)
		procInfo.icon = itemTexture
		procInfo.rank = ''
		procInfo.item = true
	else
		local name, rank, icon = GetSpellInfo(self.newproc.spellId)
		procInfo.icon = icon
		procInfo.rank = rank
	end

	procInfo.spellIds = self.newproc.spellId
	procInfo.spellIds = string.explode(",",procInfo.spellIds)

	--procInfo.types = self.newproc.types
	procInfo.name = self.newproc.name
	procInfo.onSelfOnly = self.newproc.selfOnly

	if not self.newproc.selfOnly then
		procInfo.onSelfOnly = 0
	end

	for t,v in pairs(self.newproc.types) do
		if v then
			table.insert(procInfo.types, t)
		end
	end

	self.optpc.procs[procId] = procInfo

	for _, spellId in pairs(procInfo.spellIds) do
		local procData = {}
		procData.name = procInfo.name
		procData.rank = procInfo.rank
		procData.types = procInfo.types
		procData.onSelfOnly = procInfo.onSelfOnly
		procData.procId = procInfo.procId
		if procInfo.itemID then
			procData.itemID = procInfo.itemID
		end
		if procInfo.heroic then
			procData.heroic = true
		end
		self.optpc.tracked[tonumber(spellId)] = procData
	end

	-- Reset newproc array
	Proculas.newproc = {types={}}
end

function Proculas:deleteProc(procId)
	local procInfo = self.optpc.procs[procId]

	for index,info in pairs(self.optpc.tracked) do
		if info.procId == procId then
			self.optpc.tracked[index] = nil
		end
	end

	self.optpc.procs[procId] = nil
end

-- Resets the proc stats
function Proculas:resetProcStats()
	for _,proc in pairs(self.optpc.procs) do
		proc.started = 0
		proc.time = 0
		proc.lastProc = 0
		proc.uptime = 0
		proc.cooldown = 0
		proc.count = 0
	end
end

-------------------------------------------------------
-- Event Functions

-- Rescans the players gear when they change an item
function Proculas:UNIT_INVENTORY_CHANGED(event,unit)
	if unit == "player" then
		self:scanForProcs()
	end
end

-------------------------------------------------------
-- Local Functions

-- Used to check if the Combat Log Event Type (type) is in the types array.
local function checkType(types,type)
	for _,thisType in pairs(types) do
		if(thisType == type) then
			return true
		end
	end
	return false
end

function string.trim(str)
	-- Function by Colandus
	return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

function string.explode(sep, str)
	-- Function by Colandus
	local pos, t = 1, {}
	--if #sep == 0 or #str == 0 then return end
	for s, e in function() return string.find(str, sep, pos) end do
		table.insert(t, string.trim(string.sub(str, pos, s-1)))
		pos = e+1
	end
	table.insert(t, string.trim(string.sub(str, pos)))
	return t
end

local function countarray(array)
	local count = 0
	for a,b in pairs(array) do
		count = count+1
	end
	return count
end

-------------------------------------------------------
-- Misc. Functions

-- About Proculas
function Proculas:AboutProculas()
	self:Print("Version "..VERSION)
end

-- Debug function
function Proculas:debug(msg)
--[===[@debug@
	if self.opt.debug.enabled then
		print("[Proculas][Debug]: "..msg)
	end
--@end-debug@]===]
end
