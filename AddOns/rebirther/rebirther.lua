-- Bunch of vars describing the addon
local AddonName = "Rebirther"
local AddonVersion = "r87"
local AddonDBName = AddonName.."DB"
local AddonDesc = "Tracks Rebirth and Innervate cooldowns"
local AddonSlash = {"rebirther", "rbr"}
local AddonCommPrefix = "Rebirther3"
local Window = {}
local Debug = false
local RosterUpdate = false
local MustUpdateNames = false

--local RosterLastUpdate = 0
--local RosterUpdateInterval = 1
local LastUpdate = 0
local UpdateInterval = 1
local lastFrequentUpdate = 0
local frequentUpdateInterval = 0.2
local lastEncounterInProgress = 0

local testmode = false
local ClassColour = {}
--local druid = {}
--local sortedlist = {}
local innervate = {}
local sortedinnervate = {}
local rebirth = {}
local sortedrebirth = {}
local CRsRemaining = 0
local hasIncomingResurrection = {}
--local olddruid = {}
--local AddonEvents = {"UNIT_SPELLCAST_SENT", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PARTY_MEMBERS_CHANGED", "COMBAT_LOG_EVENT_UNFILTERED", "GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_BATTLEGROUND", "PLAYER_ENTERING_WORLD"}	-- What events we want to check for, some of these might not be necessary e.g. player_entering_world, player_enter_battleground. Don't know if they both will fire at the same time
Rebirther = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceHook-3.0", "LibSink-2.0")
local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Rebirther", true)
local mapfiles = LibStub("LibMapData-1.0")

-- upvalues
local SetMapToCurrentZone = SetMapToCurrentZone
local GetPlayerMapPosition = GetPlayerMapPosition
local GetMapInfo = GetMapInfo
local GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsFriend = UnitIsFriend
local IsEncounterInProgress = IsEncounterInProgress
local select = select
local UnitClass = UnitClass
local UnitName = UnitName
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local UnitLevel = UnitLevel
local UnitAffectingCombat = UnitAffectingCombat
local UnitIsConnected = UnitIsConnected
local UnitInBattleground = UnitInBattleground
local GetRaidDifficulty = GetRaidDifficulty
local GetRaidRosterInfo = GetRaidRosterInfo
local GetTalentInfo = GetTalentInfo
local GetSpecialization = GetSpecialization
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellInfo = GetSpellInfo
local CanInspect = CanInspect
local UnitIsPlayer = UnitIsPlayer
local GetChannelName = GetChannelName
local IsInRaid = IsInRaid
local IsRaidLeader = IsRaidLeader
local IsRaidOfficer = IsRaidOfficer
local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local SendChatMessage = SendChatMessage
local FillLocalizedClassList = FillLocalizedClassList
local NotifyInspect = NotifyInspect
local CheckInteractDistance = CheckInteractDistance
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local CreateFont = CreateFont
local CreateFrame = CreateFrame
local UIParent = UIParent
local print = print
local GetTime = GetTime
local math = math
local string = string
local type = type
local table = table
local pairs = pairs
local time = time
local _G = _G
local format = format
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local _ = _
local GetRealZoneText = GetRealZoneText
local IsInInstance = IsInInstance
local UnitHasIncomingResurrection = UnitHasIncomingResurrection
local next = next
local wipe = wipe
local GetInstanceInfo = GetInstanceInfo

-- stop tainting -- XXX review the scopes for all of these variables
local MasterWindow, SuperWindow, window, bar, name, class, rank, ResId, uss_target, spellIsNormalRes, spellIsCR, spellIsManaCD, tname, target, lvl, nameFont, targetFont, timeFont, belongs, tempFont, titleFont, file
local NoInnervates, NoRebirths, size, hex, server, unitname, needtoupdatebars, newtime, tmpi, tmpr

-- Our neat spells
local SpellTemplate = {
	-- Combat resses
	rebirth = {
		id = 20484,
		cooldown = 600,
		level = 20,
		range = 40,
	},
	raiseally = {
		id = 61999,
		cooldown = 600,
		level = 72,
		range = 30,
	},
	soulstone = {
		id = 95750,
		cooldown = 600,
		level = 18,
		auraid = 20707,
		range = 30,
	},

	-- Mana Cooldowns
	innervate = {
		id = 29166,
		cooldown = 180,
		level = 28,
	},
	manatide = {
		id = 16190,
		cooldown = 180,
		level = 30,
	},
	hymnofhope = {
		id = 64901,
		cooldown = 360,
		level = 64,
	},
}
for _,val in pairs(SpellTemplate) do
	val.name = GetSpellInfo(val.id)
	--val.time = "Ready"
end
local NormalRes = {
	ancestralspirit = 2008,
	resurrection = 2006,
	revive = 50769,
	redemption = 7328,
}

function spellIsCR(spell)
	if ( spell == SpellTemplate.rebirth.id or spell == SpellTemplate.raiseally.id or spell == SpellTemplate.soulstone.id ) then
		return true
	end
	return false
end
function spellIsManaCD(spell)
	if ( spell == SpellTemplate.innervate.id or spell == SpellTemplate.manatide.id or spell == SpellTemplate.hymnofhope.id ) then
		return true
	end
	return false
end
function spellIsNormalRes(spell)
	for _,val in pairs(NormalRes) do
		if (spell == val or spell == (GetSpellInfo(val))) then
			return true
		end
	end
	return false
end
function ResId(spell)
	for _,val in pairs(NormalRes) do
		if (spell == (GetSpellInfo(val))) then
			return val
		end
	end
	return nil
end

function belongs(bar)
	if bar.belongsToRebirther then
		return true
	end
	return false
end

--[===[@debug@
-- put debugging stuff in here
--Debug = true
--SpellTemplate.innervate.cooldown = 1
--NormalRes.ancestralspirit = 331	-- Healing Wave
--@end-debug@]===]



-- Random functions

function size(array)	-- Return the number of elements in a table
	local x = 0;
	for _,val in pairs(array) do
		x = x + 1;
	end
	return x
end
--[[
function NoDruids()	-- Number of druids
	local x = 0;
	for _,val in pairs(druid) do
		if ( val.show ) then
			x = x + 1;
		end
	end
	return x
end
]]
function NoInnervates()
	local x = 0;
	for _,val in pairs(innervate) do
		if ( val.show ) then
			x = x + 1;
		end
	end
	return x
end
function NoRebirths()
	local x = 0;
	for _,val in pairs(rebirth) do
		if ( val.show ) then
			x = x + 1;
		end
	end
	return x
end

function Rebirther:SetColour(dest, r, g, b, a)
	dest.r = r
	dest.g = g
	dest.b = b
	dest.a = a
	return dest
end

function Rebirther:GetColour(dest)
	return dest.r, dest.g, dest.b, dest.a
end

function Rebirther:Round(number)
	if ( number % 1 >= 0.5 ) then
		return math.ceil(number)
	else
		return math.floor(number)
	end
end

function Rebirther:FloatToHex(number)
	hex = string.format("%x", self:Round(number * 255))
	if ( number <= 0.06 ) then
		hex = "0"..hex
	end
	return hex
end

--[[	-- Doesn't seem to be used
function Rebirther:Cout(message)	-- Just puts a message in the default chat frame (if set to)
	if ( self.db.profile.verbose and self:IsEnabled() ) then
		self:Print(message)
	end
end
]]

function Rebirther:InnervateOut(message)	-- Just puts a message in the default chat frame (if set to)
	if ( self.db.profile.verbose and self:IsEnabled() ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cff".."1db1f9"..L["Mana"].."|r: "..message)
	end
end

function Rebirther:RebirthOut(message)	-- Just puts a message in the default chat frame (if set to)
	if ( self.db.profile.verbose and self:IsEnabled() ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cff".."fc051a"..L["Res"].."|r: "..message)
	end
end

function Rebirther:Debug(message)	-- Puts out debugging messages if Debug == true
	if ( Debug and self:IsEnabled() ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffef3131Debug|r: "..message)
	end
end

function Rebirther:SetDebug(orly)
	Debug = orly
end

function Rebirther:ColourByClass(name)
	if ( name ) then
		local class = UnitClass(name)
		if ( class and ClassColour[class] ) then
			self:Debug("ColourByClass: Name = "..name.." / Class = "..UnitClass(name))
			return "|cff"..ClassColour[class]..self:GetProperName(name).."|r"
		else
			self:Debug("Class not found")
			return self:GetProperName(name)
		end
	end
end

function Rebirther:GetProperName(name)
	if ( testmode ) then
		if ( string.find(name, "-") and not self.db.profile.showServerName ) then
			return string.sub(name, 1, string.find(name, "-")-1)
		else
			return name
		end
	end
	unitname,server = UnitName(name)
	if ( unitname ) then
		if ( server and server ~= "" and self.db.profile.showServerName ) then
			return unitname.."-"..server
		else
			return unitname
		end
	else
		return name
	end
end

function Rebirther:GetFullName(name)
	if ( not name or name == "" ) then
		return "Unknown"
	end
	unitname,server = UnitName(name)
	if ( server and server ~= "" ) then
		return unitname.."-"..server
	else
		return unitname
	end
	--return GetUnitName(name, true)
end

function Rebirther:GetLocalizedClassesWithColours()
	local classes, males, females = {}, {}, {}
	FillLocalizedClassList(males, false)
	FillLocalizedClassList(females, true)
	for id,classname in pairs(males) do
		local colour = RAID_CLASS_COLORS[id]
		classes[classname] = self:FloatToHex(colour.r)..self:FloatToHex(colour.g)..self:FloatToHex(colour.b)
	end
	for id,classname in pairs(females) do
		local colour = RAID_CLASS_COLORS[id]
		classes[classname] = self:FloatToHex(colour.r)..self:FloatToHex(colour.g)..self:FloatToHex(colour.b)
	end
	for class,colour in pairs(classes) do
	end
	return classes
end

function Rebirther:UpdateDistanceToTarget(target)
	for _, v in pairs(rebirth) do
		local distance
		local class = select(2,UnitClass(v.name))
		local maxDistance = 0
		if class == "DEATHKNIGHT" then
			maxDistance = SpellTemplate.raiseally.range
		elseif class == "DRUID" then
			maxDistance = SpellTemplate.rebirth.range
		elseif class == "WARLOCK" then
			maxDistance = SpellTemplate.soulstone.range
		end
		if UnitIsDeadOrGhost(target) and UnitIsFriend("player", target) then
			-- CAVEAT: can't get corpse coordinates when someone realease spirit
			-- XXX needs review
			-- would like to use this to always get current map data,
			-- however since we call this in OnUpdate, the player won't be able to change map if this is used
			-- maybe only call it when we are in an instance?
			-- SetMapToCurrentZone()
			local dstX, dstY = GetPlayerMapPosition(target)
			local srcX, srcY = GetPlayerMapPosition(v.name)
			-- Assuming both the one resurrecting and the one being resurrected are on the same map and dungeon level
			distance = mapfiles:Distance((GetMapInfo()), GetCurrentMapDungeonLevel(), srcX, srcY, dstX, dstY)
		elseif not UnitIsDeadOrGhost(target) then
			distance = nil
		end
		if type(distance) == "number" then
			v.rebirth.distance = distance < maxDistance and distance or nil
		elseif not distance then
			v.rebirth.distance = nil
		end
		self:SetPlayerAlive(v.name, v.alive)
	end
end













function Rebirther:AddInnervate(name)	-- Add an innervate to the table
	if ( not innervate[name] ) then	-- Only fire if that innervate doesn't exist (duplicates are extremely bad)
		table.insert(sortedinnervate, name)
		innervate[name] = {}
		innervate[name].timeofdeath = 0
		innervate[name].name = name
		innervate[name].alive = true
		innervate[name].show = true
		innervate[name].spec = 0
		innervate[name].innervate = {	-- Seems to bug out like shit if you set this to SpellTemplate.innervate ?
			--enname = SpellTemplate.innervate.enname,
			time = "Ready",
			target = "Unknown",
		}
		class = select(2,UnitClass(name))
		if ( class == "DRUID" ) then
			innervate[name].innervate.name = SpellTemplate.innervate.name
			innervate[name].innervate.id = SpellTemplate.innervate.id
			innervate[name].innervate.cooldown = SpellTemplate.innervate.cooldown
			innervate[name].innervate.bar = self:CreateBar(name, Window.innervates, SpellTemplate.innervate)
		elseif ( class == "SHAMAN" ) then
			innervate[name].innervate.name = SpellTemplate.manatide.name
			innervate[name].innervate.id = SpellTemplate.manatide.id
			innervate[name].innervate.cooldown = SpellTemplate.manatide.cooldown
			innervate[name].innervate.bar = self:CreateBar(name, Window.innervates, SpellTemplate.manatide)
		elseif ( class == "PRIEST" ) then
			innervate[name].innervate.name = SpellTemplate.hymnofhope.name
			innervate[name].innervate.id = SpellTemplate.hymnofhope.id
			innervate[name].innervate.cooldown = SpellTemplate.hymnofhope.cooldown
			innervate[name].innervate.bar = self:CreateBar(name, Window.innervates, SpellTemplate.hymnofhope)
		elseif ( testmode ) then
			innervate[name].innervate.name = SpellTemplate.innervate.name
			innervate[name].innervate.id = SpellTemplate.innervate.id
			innervate[name].innervate.cooldown = SpellTemplate.innervate.cooldown
			innervate[name].innervate.bar = self:CreateBar(name, Window.innervates, SpellTemplate.innervate)
		end
	else	-- If the innervate already exists just show the bars again
		if ( not innervate[name].show ) then
			table.insert(sortedinnervate, name)
		end
		innervate[name].show = true
		innervate[name].innervate.bar:Show()
	end
	MustUpdateNames = true

	self:TryToShow()
	self:UpdateBars()
	self:SetNames()

	return innervate[name]	-- Do not know if all these returns are even necessary (probably not)
end
function Rebirther:RemoveInnervate(name)	-- Remove that innervate! This has the set back of deleting his cooldowns. Need a better way of doing this
	if ( innervate[name] --[[ and not (UnitInBattleground(val.name) or UnitInRaid(val.name) or UnitInParty(val.name) or UnitName("player") == val.name) ]] ) then
		for key,val in pairs(sortedinnervate) do
			if ( val == name ) then
				table.remove(sortedinnervate, key)
			end
		end
		innervate[name].innervate.bar:Hide()	-- Can't delete frames I'm afraid, only hide them
		innervate[name].show = false
	else
		self:Debug("Failed removing: "..name)
	end

	self:TryToShow()
	self:UpdateBars()
	self:SetNames()
end

function Rebirther:AddRebirth(name)	-- Add a rebirth to the global (not really global) table
	if ( not rebirth[name] ) then	-- Only fire if that rebirth doesn't exist (duplicates are extremely bad)
		table.insert(sortedrebirth, name)
		rebirth[name] = {}
		rebirth[name].timeofdeath = 0
		rebirth[name].name = name
		rebirth[name].alive = true
		rebirth[name].show = true
		rebirth[name].rebirth = {
			--enname = SpellTemplate.rebirth.enname,
			time = "Ready",
			target = "Unknown",
		}
		class = select(2,UnitClass(name))
		if ( class == "DRUID" ) then
			rebirth[name].rebirth.name = SpellTemplate.rebirth.name
			rebirth[name].rebirth.id = SpellTemplate.rebirth.id
			rebirth[name].rebirth.cooldown = SpellTemplate.rebirth.cooldown
			rebirth[name].rebirth.bar = self:CreateBar(name, Window.rebirths, SpellTemplate.rebirth)
		elseif ( class == "WARLOCK" ) then
			rebirth[name].rebirth.name = SpellTemplate.soulstone.name
			rebirth[name].rebirth.id = SpellTemplate.soulstone.id
			rebirth[name].rebirth.cooldown = SpellTemplate.soulstone.cooldown
			rebirth[name].rebirth.bar = self:CreateBar(name, Window.rebirths, SpellTemplate.soulstone)
		elseif ( class == "DEATHKNIGHT" ) then
			rebirth[name].rebirth.name = SpellTemplate.raiseally.name
			rebirth[name].rebirth.id = SpellTemplate.raiseally.id
			rebirth[name].rebirth.cooldown = SpellTemplate.raiseally.cooldown
			rebirth[name].rebirth.bar = self:CreateBar(name, Window.rebirths, SpellTemplate.raiseally)
		elseif ( testmode ) then
			rebirth[name].rebirth.name = SpellTemplate.rebirth.name
			rebirth[name].rebirth.id = SpellTemplate.rebirth.id
			rebirth[name].rebirth.cooldown = SpellTemplate.rebirth.cooldown
			rebirth[name].rebirth.bar = self:CreateBar(name, Window.rebirths, SpellTemplate.rebirth)
		end
	else	-- If the rebirth already exists just show the bars again
		if ( not rebirth[name].show ) then
			table.insert(sortedrebirth, name)
		end
		rebirth[name].show = true
		rebirth[name].rebirth.bar:Show()
	end
	MustUpdateNames = true

	self:TryToShow()
	self:UpdateBars()
	self:SetNames()

	return rebirth[name]	-- Do not know if all these returns are even necessary (probably not)
end
function Rebirther:RemoveRebirth(name)	-- Remove that rebirth! This has the set back of deleting his cooldowns. Need a better way of doing this
	if ( rebirth[name] --[[ and not (UnitInBattleground(val.name) or UnitInRaid(val.name) or UnitInParty(val.name) or UnitName("player") == val.name) ]] ) then
		for key,val in pairs(sortedrebirth) do
			if ( val == name ) then
				table.remove(sortedrebirth, key)
			end
		end
		rebirth[name].rebirth.bar:Hide()
		rebirth[name].show = false
	else
		self:Debug("Failed removing: "..name)
	end

	self:TryToShow()
	self:UpdateBars()
	self:SetNames()
end

function Rebirther:SetPlayerAlive(name, isAlive, isOffline)	-- Changes the colours of that druid's bars
	if ( innervate[name] ) then
		innervate[name].alive = isAlive
		if ( isAlive ) then
			-- Now find the appropriate colours for each bar (very crude)
			if ( innervate[name].innervate.time == "Ready" ) then
				innervate[name].innervate.bar.time:SetText(L["Ready"])
				-- I thought I had a function for retreiving colours more easily. Does it work?
				local r, g, b, a
				class = select(2,UnitClass(name))
				if ( class and self.db.profile.bar.useClassColour ) then
					r, g, b, a = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, self.db.profile.bar.opacity
				else
					r, g, b, a = self.db.profile.bar.readyColour.r, self.db.profile.bar.readyColour.g, self.db.profile.bar.readyColour.b, self.db.profile.bar.opacity
				end
				innervate[name].innervate.bar.texture:SetVertexColor( r, g, b, a )
			else
				local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
				innervate[name].innervate.bar.texture:SetVertexColor( r, g, b, a )
			end
		else
			innervate[name].timeofdeath = time()
			local r, g, b, a = self.db.profile.bar.deadColour.r, self.db.profile.bar.deadColour.g, self.db.profile.bar.deadColour.b, self.db.profile.bar.opacity
			innervate[name].innervate.bar.texture:SetVertexColor( r, g, b, a )
			if ( innervate[name].innervate.time == "Ready" ) then
				if ( isOffline ) then
					innervate[name].innervate.bar.time:SetText(L["Offline"])
				else
					innervate[name].innervate.bar.time:SetText(L["Dead"])
				end
			end
		end
	end
	if ( rebirth[name] ) then
		rebirth[name].alive = isAlive
		if ( isAlive ) then
			if ( rebirth[name].rebirth.time == "Ready" ) then
				rebirth[name].rebirth.bar.time:SetText(L["Ready"])
				local r, g, b, a
				class = select(2,UnitClass(name))
				if ( class and self.db.profile.bar.useClassColour ) then
					r, g, b, a = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b, self.db.profile.bar.opacity
				else
					r, g, b, a = self.db.profile.bar.readyColour.r, self.db.profile.bar.readyColour.g, self.db.profile.bar.readyColour.b, self.db.profile.bar.opacity
				end
				if rebirth[name].rebirth.distance and self.db.profile.bar.useRangeRecolor then
					r, g, b, a = self.db.profile.bar.RangeColor.r, self.db.profile.bar.RangeColor.g, self.db.profile.bar.RangeColor.b, self.db.profile.bar.opacity
				end
				rebirth[name].rebirth.bar.texture:SetVertexColor( r, g, b, a )
			else
				local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
				rebirth[name].rebirth.bar.texture:SetVertexColor( r, g, b, a )
			end
		else
			rebirth[name].timeofdeath = time()
			local r, g, b, a = self.db.profile.bar.deadColour.r, self.db.profile.bar.deadColour.g, self.db.profile.bar.deadColour.b, self.db.profile.bar.opacity
			rebirth[name].rebirth.bar.texture:SetVertexColor( r, g, b, a )
			if ( rebirth[name].rebirth.time == "Ready" ) then
				if ( isOffline ) then
					rebirth[name].rebirth.bar.time:SetText(L["Offline"])
				else
					rebirth[name].rebirth.bar.time:SetText(L["Dead"])
				end
			end
		end
	end
	self:UpdateBars()
end

function Rebirther:DebugMode()
	Debug = not Debug
end

function Rebirther:TestMode()
	testmode = not testmode
	if ( testmode ) then
		self:Show(MasterWindow, true)

		self:AddInnervate("Venkman-New York")
		self:AddRebirth("Venkman-New York")
		self:AddRebirth("Stantz-New York")
		self:AddInnervate("Stantz-New York")
		self:AddRebirth("Spengler-New York")
		--self:StartCooldown(druid["Venkman-New York"].innervate, nil, "Venkman-New York", "Barret-New York")
		self:StartCooldown(rebirth["Stantz-New York"].rebirth, nil, "Stantz-New York", "Zuul-Ghost Realm")
		self:StartCooldown(innervate["Stantz-New York"].innervate, nil, "Stantz-New York", "Peck-New York")
		self:StartCooldown(rebirth["Spengler-New York"].rebirth, 450, "Spengler-New York", UnitName("player"))
		self:SetPlayerAlive("Spengler-New York", false)
		--[[
		names = {"Dopey", "Grumpy", "Doc", "Happy", "Bashful", "Sneezy", "Sleepy", "Snow White", "Prince-Server Name"}
		for _,val in pairs(names) do
			self:AddInnervate(val)
			self:AddRebirth(val)
		end
		self:StartCooldown(rebirth["Prince-Server Name"].rebirth, nil, "Prince", "Snow White")
		self:StartCooldown(innervate["Doc"].innervate, nil, "Doc", "Sneezy")
		self:StartCooldown(innervate["Bashful"].innervate, nil, "Bashful", "Sleepy")
		self:StartCooldown(innervate["Grumpy"].innervate, 90, "Grumpy", "Prince")
		self:SetPlayerAlive("Snow White",false)
		self:SetPlayerAlive("Dopey",true,false)
		]]
		Window.rebirths.title:SetText(L["Battle Resses"]..": 3 remain")
		self:UpdateBars()
		self:SetNames()
		Window.rebirths:Show()
		Window.innervates:Show()
	else
		Window.rebirths.title:SetText(L["Battle Resses"])
		self:CheckGroupStatus()
	end
end







-- Window relates functions

function Rebirther:CreateWindow(name, icon, title)
	self:Debug("Creating window: "..name)
	local padding = self:GetPadding()
	window = CreateFrame("FRAME", name, MasterWindow, "ContainerTemplate")
	window:SetParent(MasterWindow)
	--window:SetUserPlaced(false)

	window.icon = _G[name.."Icon"]
	window.title = _G[name.."Title"]
	window.background = _G[name.."Background"]

	window.icon:SetTexture(icon)
	window.title:SetFontObject(titleFont)
	window.title:SetText(title)
	window.title:SetPoint("TOPLEFT", window, "TOPLEFT", padding, 0);
	window:SetWidth(self.db.profile.bar.width)
	--window:EnableMouseWheel(true)

	window.belongsToRebirther = true

	return window
end

function Rebirther:SaveWindowPos()
	--_,_,_,self.db.profile.rebirthCoord.x, self.db.profile.rebirthCoord.y = Window.rebirths:GetPoint(1)
	--_,_,_,self.db.profile.innervateCoord.x, self.db.profile.innervateCoord.y = Window.innervates:GetPoint(1)
	self.db.profile.rebirthCoord.x = Window.rebirths:GetLeft()
	self.db.profile.rebirthCoord.y = Window.rebirths:GetBottom()
	self.db.profile.innervateCoord.x = Window.innervates:GetLeft()
	self.db.profile.innervateCoord.y = Window.innervates:GetBottom()
end

function Rebirther:MakeFont(name, size, r, g, b, a)	-- Like the name says. Need different fonts for text of different size to avoid graphical corruption of it
	file = self.db.profile.font.filePath
	tempFont = CreateFont(name)
	tempFont:SetFont(file, size)
	tempFont:SetTextColor(r, g, b, a)
	return tempFont
end

function Rebirther:SetFonts()
	nameFont = self:MakeFont("nameFont", self.db.profile.font.nameSize, self.db.profile.font.nameColour.r, self.db.profile.font.nameColour.g, self.db.profile.font.nameColour.b, 1)
	timeFont = self:MakeFont("timeFont", self.db.profile.font.timeSize, self.db.profile.font.timeColour.r, self.db.profile.font.timeColour.g, self.db.profile.font.timeColour.b, 1)
	targetFont = self:MakeFont("targetFont", self.db.profile.font.targetSize, self.db.profile.font.targetColour.r, self.db.profile.font.targetColour.g, self.db.profile.font.targetColour.b, 1)
	titleFont = self:MakeFont("titleFont", self.db.profile.font.titleSize, self.db.profile.font.titleColour.r, self.db.profile.font.titleColour.g, self.db.profile.font.titleColour.b, 1)
end

function Rebirther:SetScale()
	MasterWindow:SetScale(self.db.profile.scale)
end

function Rebirther:SetPos()
	Window.rebirths:ClearAllPoints()
	Window.rebirths:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.rebirthCoord.x, self.db.profile.rebirthCoord.y)
	Window.innervates:ClearAllPoints()
	Window.innervates:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.innervateCoord.x, self.db.profile.innervateCoord.y)
end

function Rebirther:SetSize()
	--[[
	local width, height = self.db.profile.bar.width, (self.db.profile.bar.height + self.db.profile.bar.spacing)
	local padding = self:GetPadding()
	for _,window in pairs({MasterWindow:GetChildren()}) do
		window:SetWidth(width)
		local p, r, rp = _G[window:GetName().."Title"]:GetPoint()
		_G[window:GetName().."Title"]:SetPoint(p, r, rp, padding, -padding)
		window:SetHeight( self.db.profile.font.titleSize + padding * 2)
		for key,val in pairs({window:GetChildren()}) do
			val:SetSize(width,height)
			_G[val:GetName().."TextureAnimation"].max = width
			_G[val:GetName().."TextureCasting"].max = width
			_G[val:GetName().."Texture"]:SetSize(width,height-Rebirther.db.profile.bar.spacing)
			local p, r, rp = _G[val:GetName().."Name"]:GetPoint(1)
			_G[val:GetName().."Name"]:SetPoint(p, r, rp, padding, padding)
			local p, r, rp = _G[val:GetName().."Name"]:GetPoint(2)
			_G[val:GetName().."Name"]:SetPoint(p, r, rp, padding, padding)
			local p, r, rp = _G[val:GetName().."Time"]:GetPoint(1)
			_G[val:GetName().."Time"]:SetPoint(p, r, rp, -padding, padding)
			local p, r, rp = _G[val:GetName().."Time"]:GetPoint(2)
			_G[val:GetName().."Time"]:SetPoint(p, r, rp, -padding, padding)
			_G[val:GetName().."Name"]:SetHeight(self.db.profile.font.nameSize)

			_G[val:GetName().."Name"]:SetWidth(0)
			_G[val:GetName().."Name"]:SetWidth(math.min(_G[val:GetName().."Name"]:GetWidth(), val:GetWidth() - _G[val:GetName().."Time"]:GetWidth() - self:GetPadding()*2))
		end
	end
	self:UpdateBars()
	self:SetPos()
	]]

	local width, height = self.db.profile.bar.width, (self.db.profile.bar.height + self.db.profile.bar.spacing)
	local padding = self:GetPadding()
	--for _,window in pairs({MasterWindow:GetChildren()}) do
	for _,window in pairs(Window) do
		if ( belongs(window) ) then
			window:SetWidth(width)
			local p, r, rp = _G[window:GetName().."Title"]:GetPoint()
			window.title:SetPoint(p, r, rp, padding, -padding)
			window:SetHeight( self.db.profile.font.titleSize + padding * 2)
			for key,val in pairs({window:GetChildren()}) do
				if ( belongs(val) ) then
					val:SetSize(width,height)
					val.animation.max = width
					val.casting.max = width
					val.texture:SetSize(width,height-Rebirther.db.profile.bar.spacing)
					local p, r, rp = val.name:GetPoint(1)
					val.name:SetPoint(p, r, rp, padding, padding)
					local p, r, rp = val.name:GetPoint(2)
					val.name:SetPoint(p, r, rp, padding, padding)
					local p, r, rp = val.time:GetPoint(1)
					val.time:SetPoint(p, r, rp, -padding, padding)
					local p, r, rp = val.time:GetPoint(2)
					val.time:SetPoint(p, r, rp, -padding, padding)
					val.name:SetHeight(self.db.profile.font.nameSize)

					val.name:SetWidth(0)
					val.name:SetWidth(math.min(val.name:GetWidth(), val:GetWidth() - val.time:GetWidth() - self:GetPadding()*2))
				end
			end
		end
	end
	self:UpdateBars()
	self:SetPos()
end

function Rebirther:SetColours()
	for key,val in pairs(rebirth) do
		self:SetPlayerAlive(val.name, val.alive)
	end
	for key,val in pairs(innervate) do
		self:SetPlayerAlive(val.name, val.alive)
	end
end

function Rebirther:SetBackground()
	--[[
	local r, g, b, a = self.db.profile.backgroundColour.r, self.db.profile.backgroundColour.g, self.db.profile.backgroundColour.b, self.db.profile.backgroundColour.a
	for _,window in pairs({MasterWindow:GetChildren()}) do
		_G[window:GetName().."Background"]:SetTexture( r, g, b, a)
		for _,bar in pairs({window:GetChildren()}) do
			bg = _G[bar:GetName().."Background"]
			bg:SetTexture( r, g, b , a )
			tex = _G[bar:GetName().."Texture"]
			tex:SetTexture( self.db.profile.bar.texturePath )
			tex:SetAlpha( self.db.profile.bar.opacity )
		end
	end
	]]
	local r, g, b, a = self.db.profile.backgroundColour.r, self.db.profile.backgroundColour.g, self.db.profile.backgroundColour.b, self.db.profile.backgroundColour.a
	--for _,window in pairs({MasterWindow:GetChildren()}) do
	for _,window in pairs(Window) do
		if ( belongs(window) ) then
			window.background:SetTexture( r, g, b, a)
			for _,bar in pairs({window:GetChildren()}) do
				if ( belongs(bar) ) then
					bar.background:SetTexture( r, g, b , a )
					bar.texture:SetTexture( self.db.profile.bar.texturePath )
					bar.texture:SetAlpha( self.db.profile.bar.opacity )
				end
			end
		end
	end
end

function Rebirther:SetNames()
	--[[
	for key,val in pairs({MasterWindow:GetChildren()}) do
		for _,bar in pairs({val:GetChildren()}) do
			local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
			_G[bar:GetName().."Name"]:SetText(self:GetProperName(name))
			_G[bar:GetName().."Name"]:SetWidth(0)
			_G[bar:GetName().."Name"]:SetWidth(math.min(_G[bar:GetName().."Name"]:GetWidth(), bar:GetWidth() - _G[bar:GetName().."Time"]:GetWidth() - self:GetPadding()*2))
			if ( rebirth[name] ) then
				if ( string.find(bar:GetName(), "_RebirthsBar") ) then
					_G[bar:GetName().."Target"]:SetText(" ("..self:GetProperName(rebirth[name].rebirth.target)..")")
				end
			end
			if ( innervate[name] ) then
				if ( string.find(bar:GetName(), "_InnervatesBar") ) then
					_G[bar:GetName().."Target"]:SetText(" ("..self:GetProperName(innervate[name].innervate.target)..")")
				end
			end
		end
	end
	]]
	--for key,val in pairs({MasterWindow:GetChildren()}) do
	for _,val in pairs(Window) do
		if ( belongs(val) ) then
			for _,bar in pairs({val:GetChildren()}) do
				if ( belongs(bar) ) then
					local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
					bar.name:SetText(self:GetProperName(name))
					bar.name:SetWidth(0)
					bar.name:SetWidth(math.min(bar.name:GetWidth(), bar:GetWidth() - bar.time:GetWidth() - self:GetPadding()*2))
					if ( rebirth[name] ) then
						if ( string.find(bar:GetName(), "_RebirthsBar") ) then
							bar.target:SetText(" ("..self:GetProperName(rebirth[name].rebirth.target)..")")
						end
					end
					if ( innervate[name] ) then
						if ( string.find(bar:GetName(), "_InnervatesBar") ) then
							bar.target:SetText(" ("..self:GetProperName(innervate[name].innervate.target)..")")
						end
					end
				end
			end
		end
	end
end

function Rebirther:SetIcons()
	--[[
	if ( self.db.profile.showicon ) then
		for key,val in pairs({MasterWindow:GetChildren()}) do
			_G[val:GetName().."Icon"]:Show()
		end
	else
		for key,val in pairs({MasterWindow:GetChildren()}) do
			_G[val:GetName().."Icon"]:Hide()
		end
	end
	]]
	--for key,val in pairs({MasterWindow:GetChildren()}) do
	for _,val in pairs(Window) do
		if ( belongs(val) ) then
			if ( self.db.profile.showicon ) then
				val.icon:Show()
			else
				val.icon:Hide()
			end
		end
	end

end

function Rebirther:GetPadding()
	if ( self.db.profile.showtarget ) then
		return ( self.db.profile.bar.height - math.max( self.db.profile.font.nameSize, self.db.profile.font.timeSize, self.db.profile.font.targetSize ) ) / 2
	else
		return ( self.db.profile.bar.height - math.max( self.db.profile.font.nameSize, self.db.profile.font.timeSize ) ) / 2
	end
end

function Rebirther:ShowTarget(value)
	--for _,window in pairs({MasterWindow:GetChildren()}) do
	for _,window in pairs(Window) do
		if ( belongs(window) ) then
			for _, bar in pairs({window:GetChildren()}) do
				if ( belongs(bar) ) then
					if ( value and bar.animation:IsPlaying() and bar.target:GetText() ~= " (Unknown)" ) then
						bar.target:Show()
					else
						bar.target:Hide()
					end
				end
			end
		end
	end
end

function Rebirther:Show(frame, show)	-- Shows/hides a frame if show is true/false
	if ( show ) then
		frame:Show()
	else
		frame:Hide()
	end
end

--[[
function Rebirther:UpdateBars()
	for _,name in pairs(sortedlist) do
		if ( self.db.profile.bar.growUp ) then
			druid[name].innervate.bar:ClearAllPoints()
			druid[name].innervate.bar:SetPoint("BOTTOMLEFT", Window.innervates, "TOPLEFT")
			_G[druid[name].innervate.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].innervate.bar:GetName().."Texture"]:SetPoint("TOPLEFT", druid[name].innervate.bar, "TOPLEFT")
			druid[name].rebirth.bar:ClearAllPoints()
			druid[name].rebirth.bar:SetPoint("BOTTOMLEFT", Window.rebirths, "TOPLEFT")
			_G[druid[name].rebirth.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].rebirth.bar:GetName().."Texture"]:SetPoint("TOPLEFT", druid[name].rebirth.bar, "TOPLEFT")
		else
			druid[name].innervate.bar:ClearAllPoints()
			druid[name].innervate.bar:SetPoint("TOPLEFT", Window.innervates, "BOTTOMLEFT")
			_G[druid[name].innervate.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].innervate.bar:GetName().."Texture"]:SetPoint("BOTTOMLEFT", druid[name].innervate.bar, "BOTTOMLEFT")
			druid[name].rebirth.bar:ClearAllPoints()
			druid[name].rebirth.bar:SetPoint("TOPLEFT", Window.rebirths, "BOTTOMLEFT")
			_G[druid[name].rebirth.bar:GetName().."Texture"]:ClearAllPoints()
			_G[druid[name].rebirth.bar:GetName().."Texture"]:SetPoint("BOTTOMLEFT", druid[name].rebirth.bar, "BOTTOMLEFT")
		end
	end

	local x = 0
	local height = self.db.profile.bar.height + self.db.profile.bar.spacing
	if ( self.db.profile.bar.growUp ) then
		height = -height
	end
	for _,name in pairs(sortedlist) do
		self:Debug("Updating bars for: "..name)
		self:UpdateBar(name, druid[name].innervate, x * height )
		self:UpdateBar(name, druid[name].rebirth, x * height )
		x = x + 1
	end
end
]]

function Rebirther:UpdateBars()
	for _,name in pairs(sortedinnervate) do
		if ( self.db.profile.bar.growUp ) then
			innervate[name].innervate.bar:ClearAllPoints()
			innervate[name].innervate.bar:SetPoint("BOTTOMLEFT", Window.innervates, "TOPLEFT")
			innervate[name].innervate.bar.texture:ClearAllPoints()
			innervate[name].innervate.bar.texture:SetPoint("TOPLEFT", innervate[name].innervate.bar, "TOPLEFT")
		else
			innervate[name].innervate.bar:ClearAllPoints()
			innervate[name].innervate.bar:SetPoint("TOPLEFT", Window.innervates, "BOTTOMLEFT")
			innervate[name].innervate.bar.texture:ClearAllPoints()
			innervate[name].innervate.bar.texture:SetPoint("BOTTOMLEFT", innervate[name].innervate.bar, "BOTTOMLEFT")
		end
	end

	local x = 0
	local height = self.db.profile.bar.height + self.db.profile.bar.spacing
	if ( self.db.profile.bar.growUp ) then
		height = -height
	end
	for _,name in pairs(sortedinnervate) do
		if not (self.db.profile.bar.hideOnCD and (innervate[name].innervate.time ~= "Ready" or not innervate[name].alive)) then
			self:UpdateBar(name, innervate[name].innervate, x * height )
			x = x + 1
			innervate[name].innervate.bar:Show()
		else
			if ( innervate[name].innervate.time ~= "Ready" and GetTime() - innervate[name].innervate.time >= innervate[name].innervate.cooldown and innervate[name].alive) then
				innervate[name].innervate.bar:Show()
				self:UpdateBar(name, innervate[name].innervate, x * height )
				x = x + 1
			else
				innervate[name].innervate.bar:Hide()
			end
		end
	end

	for _,name in pairs(sortedrebirth) do
		if ( self.db.profile.bar.growUp ) then
			rebirth[name].rebirth.bar:ClearAllPoints()
			rebirth[name].rebirth.bar:SetPoint("BOTTOMLEFT", Window.rebirths, "TOPLEFT")
			rebirth[name].rebirth.bar.texture:ClearAllPoints()
			rebirth[name].rebirth.bar.texture:SetPoint("TOPLEFT", rebirth[name].rebirth.bar, "TOPLEFT")
		else
			rebirth[name].rebirth.bar:ClearAllPoints()
			rebirth[name].rebirth.bar:SetPoint("TOPLEFT", Window.rebirths, "BOTTOMLEFT")
			rebirth[name].rebirth.bar.texture:ClearAllPoints()
			rebirth[name].rebirth.bar.texture:SetPoint("BOTTOMLEFT", rebirth[name].rebirth.bar, "BOTTOMLEFT")
		end
	end

	local x = 0
	local height = self.db.profile.bar.height + self.db.profile.bar.spacing
	if ( self.db.profile.bar.growUp ) then
		height = -height
	end
	for _,name in pairs(sortedrebirth) do
		if not (self.db.profile.bar.hideOnCD and (rebirth[name].rebirth.time ~= "Ready" or not rebirth[name].alive)) then
			self:UpdateBar(name, rebirth[name].rebirth, x * height )
			x = x + 1
			rebirth[name].rebirth.bar:Show()
		else
			if ( rebirth[name].rebirth.time ~= "Ready" and GetTime() - rebirth[name].rebirth.time >= rebirth[name].rebirth.cooldown and rebirth[name].alive) then
				rebirth[name].rebirth.bar:Show()
				self:UpdateBar(name, rebirth[name].rebirth, x * height )
				x = x + 1
			else
				rebirth[name].rebirth.bar:Hide()
			end
		end
	end
end

function Rebirther:ChangeGrowDir()
	if ( self.db.profile.bar.growUp ) then
		Window.innervates.icon:SetPoint("CENTER", Window.innervates, "BOTTOMRIGHT", -14, 0)
		Window.rebirths.icon:SetPoint("CENTER", Window.rebirths, "BOTTOMRIGHT", -14, 0)
	else
		Window.innervates.icon:SetPoint("CENTER", Window.innervates, "TOPRIGHT", -14, 0)
		Window.rebirths.icon:SetPoint("CENTER", Window.rebirths, "TOPRIGHT", -14, 0)
	end
end








-- Bar related functions

function Rebirther:CreateBar(name, parent, spell)
	local padding = self:GetPadding()
	--local bar = {}
	local fname = name.."_SpellIs"..spell.id.."_"..parent:GetName().."Bar"
	local propername = self:GetProperName(name)
	if ( _G[fname] ) then
		--self:Debug("Creating bar: "..fname.." (already exists: showing)")
		--bar.frame = _G[fname]
		--bar.frame:Show()
		_G[fname]:Show()
	else
		self:Debug("Creating bar: "..fname)
		--bar.frame = CreateFrame("FRAME", fname, parent, "BarTemplate")
		--bar.frame:SetSize(self.db.profile.bar.width, ( self.db.profile.bar.height + self.db.profile.bar.spacing ) )
		bar = CreateFrame("FRAME", fname, parent, "BarTemplate")
		bar:SetSize(self.db.profile.bar.width, ( self.db.profile.bar.height + self.db.profile.bar.spacing ) )
		local r, g, b, a = self.db.profile.backgroundColour.r, self.db.profile.backgroundColour.g, self.db.profile.backgroundColour.b, self.db.profile.backgroundColour.a
		bar.background = _G[fname.."Background"]
		bar.background:SetTexture(r, g, b, a)
		bar.animation = _G[fname.."TextureAnimation"]
		bar.animation:SetDuration(spell.cooldown)
		bar.animation.max = self.db.profile.bar.width
		_G[fname.."TextureCasting"].max = self.db.profile.bar.width
		bar.texture = _G[fname.."Texture"]
		local r, g, b, a
		class = select(2,UnitClass(name))
		if ( class and self.db.profile.bar.useClassColour ) then
			r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
		else
			r, g, b = self.db.profile.bar.readyColour.r, self.db.profile.bar.readyColour.g, self.db.profile.bar.readyColour.b
		end
		bar.texture:SetVertexColor(r, g, b, self.db.profile.bar.opacity);
		bar.texture:SetTexture(self.db.profile.bar.texturePath)
		bar.texture:SetSize(self.db.profile.bar.width, self.db.profile.bar.height)
		bar.name = _G[fname.."Name"]
		--local p, r, rp = bar.name:GetPoint()
		--bar.name:SetPoint(p, r, rp, padding, padding)
		bar.name:SetFontObject(nameFont)
		bar.name:SetText(propername)
		bar.target = _G[fname.."Target"]
		bar.target:Hide()
		bar.target:SetFontObject(targetFont)
		bar.time = _G[fname.."Time"]
		--local p, r, rp = bar.time:GetPoint()
		--bar.time:SetPoint(p, r, rp, -padding, padding)
		bar.time:SetFontObject(timeFont)
		bar.time:SetText(L["Ready"])
		bar.time:SetWidth(0)

		bar:EnableMouseWheel(true)

		bar.name:ClearAllPoints()
		bar.name:SetPoint("BOTTOM", bar.texture, "BOTTOM", padding, padding)
		bar.name:SetPoint("LEFT", bar, "LEFT", padding, padding)

		bar.time:ClearAllPoints()
		bar.time:SetPoint("BOTTOM", bar.texture, "BOTTOM", -padding, padding)
		bar.time:SetPoint("RIGHT", bar, "RIGHT", -padding, padding)

		--[[
		bar.icon = bar.frame:CreateTexture(fname.."Icon","ARTWORK",nil,1)
		bar.icon:SetTexture(select(3,GetSpellInfo(spell.id)))
		bar.icon:SetSize((self.db.profile.bar.height-padding*2), (self.db.profile.bar.height-padding*2))
		bar.icon:SetPoint("BOTTOM", bar.frame, "BOTTOM", padding, padding)
		bar.icon:SetPoint("LEFT", bar.name, "RIGHT", padding, padding)
		bar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		bar.icon:SetBlendMode("BLEND")
		]]

		bar.casting =  _G[fname.."TextureCasting"]

		--Parenting
		--bar.animation:SetParent(bar.texture)
		bar:SetParent(parent)


		--bar.name:SetPoint("BOTTOMLEFT", padding, padding)
		--bar.time:SetPoint("BOTTOMRIGHT", -padding, padding)
		bar.name:SetHeight(self.db.profile.font.nameSize)
		bar.name:SetJustifyH("LEFT")
		bar.target:SetJustifyH("LEFT")
		bar.time:SetJustifyH("RIGHT")
		bar.name:SetWidth(0)
		bar.name:SetWidth(math.min(bar.name:GetWidth(), self.db.profile.bar.width - bar.time:GetWidth() - self:GetPadding()*2))

		bar.belongsToRebirther = true

	end
	return bar
end
function Rebirther:UpdateBar(player, spell, yOffset)
	local p, r, rp, xOffset, _ = spell.bar:GetPoint()
	spell.bar:SetPoint(p, r, rp, xOffset, -yOffset)
end
function Rebirther:AnimationFinished(texture)
	local name = string.sub(texture:GetName(), 1, string.find(texture:GetName(), "_")-1)
	local spell = {}
	local alive
	if ( string.find(texture:GetName(), "_InnervatesBar") ) then
		self:Debug("Assuming innervate")
		spell = innervate[name].innervate
		innervate[name].innervate.target = "Unknown"
		alive = innervate[name].alive
	else
		self:Debug("Assuming rebirth")
		spell = rebirth[name].rebirth
		rebirth[name].rebirth.target = "Unknown"
		alive = rebirth[name].alive
	end
	spell.time = "Ready"
	--[[
	if ( UnitIsDeadOrGhost(name) or not UnitIsConnected(name) ) then
		self:SetPlayerAlive(name, alive)
	else
		self:SetPlayerAlive(name, true)
	end
	]]
	self:SetPlayerAlive(name,alive)
	spell.bar.texture:SetWidth( spell.bar:GetWidth() )
	spell.bar.texture:SetTexCoord(0, 1, 0, 1)
	spell.bar.target:Hide()
end
function Rebirther:BarClicked(bar, button)	-- Fires when a bar is clicked
	if ( self.db.profile.bar.allowClick ) then
		local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
		if ( name ~= UnitName("player") ) then
			if ( string.find(bar:GetName(), "_InnervatesBar") ) then
				self:Request(name, innervate[name].innervate.id, "player")
			elseif ( string.find(bar:GetName(), "_RebirthsBar") ) then
				if UnitIsUnit("target", "player") or not UnitExists("target") or not UnitIsPlayer("target") then
					self:Request(name, rebirth[name].rebirth.id, "123")
				elseif UnitInRaid("target") then
					self:Request(name, rebirth[name].rebirth.id, "target")
				end
			end
		end
	end
end

function Rebirther:MouseWheel(bar, delta)
	if ( self.db.profile.bar.allowScroll ) then
		local name = string.sub(bar:GetName(), 1, string.find(bar:GetName(), "_")-1)
		local x = 0
		if ( string.find(bar:GetName(), "_InnervatesBar") ) then
			for key,val in pairs(sortedinnervate) do
				if ( val == name ) then
					x = key
				end
			end
			if ( x - delta > 0 and x - delta <= size(sortedinnervate) ) then
				local temp = sortedinnervate[x]
				sortedinnervate[x] = sortedinnervate[x-delta]
				sortedinnervate[x-delta] = temp
			end
		elseif ( string.find(bar:GetName(), "_RebirthsBar") ) then
			for key,val in pairs(sortedrebirth) do
				if ( val == name ) then
					x = key
				end
			end
			if ( x - delta > 0 and x - delta <= size(sortedrebirth) ) then
				local temp = sortedrebirth[x]
				sortedrebirth[x] = sortedrebirth[x-delta]
				sortedrebirth[x-delta] = temp
			end
		end
		self:UpdateBars()
	end
end

function Rebirther:StartCooldown(spell, spelltime, source, target)	-- Starts a cooldown on spell. Note that spell in this particular case is a reference to a table (e.g. druid.innervate) and not the name of the spell. (inconsistent, I know)
	if ( not spell.time ) then	-- I'm not sure about this check
		self:Debug("False cooldown: "..spell.name)
		-- This person isn't in the raid
		return
	end
	spell.bar.animation:Stop()
	if ( spelltime ) then	-- note that spelltime is the remaining cooldown for the spell
		if ( spelltime > 0 and spelltime < spell.cooldown ) then
			spell.time = GetTime() - ( spell.cooldown - spelltime )
			local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
			spell.bar.texture:SetVertexColor( r, g, b, a )
			spell.bar.animation:SetDuration( spelltime )
			spell.bar.animation.max = self.db.profile.bar.width * ( spelltime / spell.cooldown )
			spell.bar.animation.spelltime = spell.time
			spell.bar.animation:Play()
		end
	else
		self:Debug("Cooldown started: "..spell.name.." / Bar = "..spell.bar:GetName())
		spell.time = GetTime()
		local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
		spell.bar.texture:SetVertexColor( r, g, b, a )
		spell.bar.animation:SetDuration(spell.cooldown)
		spell.bar.animation.max = self.db.profile.bar.width
		spell.bar.animation.spelltime = GetTime()
		spell.bar.animation:Play()
	end
	if ( target ) then
		spell.target = target
		spell.bar.target:SetText(" ("..self:GetProperName(target)..")")
		if ( self.db.profile.showtarget ) then
			spell.bar.target:Show()
		end
		if ( spell.id == SpellTemplate.innervate.id and source ~= UnitName("player") ) then
			self:InnervateOut(L["X innervated Y"](self:ColourByClass(source), self:ColourByClass(target)))
		elseif ( spellIsCR(spell.id) and source ~= UnitName("player") ) then
			self:RebirthOut(L["X ressed Y"](self:ColourByClass(source), self:ColourByClass(target)))
			--_G[spell.bar:GetName().."Target"]:SetText(" (Unknown)")
		end
	else
		if ( spell.id == SpellTemplate.manatide.id and source ~= UnitName("player") ) then
			self:InnervateOut(L["X mana tide"](self:ColourByClass(source)))
		elseif ( spell.id == SpellTemplate.hymnofhope.id and source ~= UnitName("player") ) then
			self:InnervateOut(L["X hymn of hope"](self:ColourByClass(source)))
		end
	end
	self:UpdateBars()
	self:SendSync("StartCooldown", source, spell.id, target)
	return spell
end
function Rebirther:StartCasting(spell, target)
	if ( not spell.time ) then	-- I'm not sure about this check
		self:Debug("False cooldown: "..spell.name)
		-- This person isn't in the raid
		return
	end
	local r, g, b, a = self.db.profile.bar.cooldownColour.r, self.db.profile.bar.cooldownColour.g, self.db.profile.bar.cooldownColour.b, self.db.profile.bar.opacity
	spell.bar.texture:SetVertexColor( r, g, b, a )
	spell.bar.casting:Stop()
	spell.bar.casting:Play()
	if ( target and self.db.profile.showtarget ) then
		spell.bar.target:SetText(" ("..self:GetProperName(target)..")")
		spell.bar.target:Show()
	end
end
function Rebirther:CastingFinished(texture)
	local name = string.sub(texture:GetName(), 1, string.find(texture:GetName(), "_")-1)	-- This shit is crude, but it works
	local spell = {}
	local player = {}
	if ( string.find(texture:GetName(), "_InnervatesBar") ) then
		self:Debug("Assuming innervate")
		spell = innervate[name].innervate
		player = innervate[name]
	else	-- This could probably go awry
		self:Debug("Assuming rebirth")
		spell = rebirth[name].rebirth
		player = innervate[name]
	end
	if ( spell.time == "Ready" ) then
		self:SetPlayerAlive(name, player.alive)
		spell.bar.target:SetText(" (Unknown)")
		spell.bar.target:Hide()
		spell.bar.texture:SetTexCoord(0, 1, 0, 1)
	end
end












-- Player communication

--[[
function Rebirther:Request(name, spell, target)	-- This function may not work properly
	unitname = self:GetFullName(target)
	if ( self.db.profile.bar.allowClick and spell == SpellTemplate.innervate.name and innervate[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) and not UnitIsDeadOrGhost(unitname) ) then
		SendChatMessage(L["Innervate me!"], "WHISPER", nil, name)
		self:Debug("Innervate requested")
	elseif ( self.db.profile.bar.allowClick and target == "123" and spell == SpellTemplate.rebirth.name and rebirth[name].rebirth.time == "Ready" and UnitIsDeadOrGhost("player") ) then
		SendChatMessage(L["Res me!"], "WHISPER", nil, name)
		self:Debug("Rebirth requests on random")
	elseif ( spell == SpellTemplate.rebirth.name and rebirth[name].rebirth.time == "Ready" and (IsRaidLeader() or IsRaidOfficer()) and not UnitIsDeadOrGhost(name) and UnitIsDeadOrGhost(unitname)) then
		SendChatMessage(L["Combat res %t!"](unitname), "WHISPER", nil, name)
		self:Debug("Rebirth requested on specific")
	else
		self:Debug("Unknown request: Name = "..name.. " / Spell = "..spell.." / Target = "..target)
	end
end
]]
do
	local hexColors = {}
	for k, v in pairs(RAID_CLASS_COLORS) do
		hexColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if type(key) == "nil" then return nil end
			local class = select(2, UnitClass(key))
			if class then
				self[key] = hexColors[class]  .. key .. "|r"
			else
				return key
			end
			return self[key]
		end
	})

	function Rebirther:OutputRequest(event, target, spellId)
		local message = nil
		local r, g, b = self:GetColour(self.db.profile.sinkColour)
		if event == "InnervateRequest" then
			message = string.gsub(self.db.profile.innervatexRequest, "%%t", coloredNames[target])
			self:Pour(message, r, g, b, nil, nil, nil, nil, nil, (select(3,GetSpellInfo(SpellTemplate.innervate.id))))
		elseif event == "ManaTideRequest" then
			message = string.gsub(self.db.profile.manatideRequest, "%%s", SpellTemplate.manatide.name)
			self:Pour(message, r, g, b, nil, nil, nil, nil, nil, (select(3,GetSpellInfo(SpellTemplate.manatide.id))))
		elseif event == "HymnofHopeRequest" then
			message = string.gsub(self.db.profile.hymnRequest, "%%s", SpellTemplate.hymnofhope.name)
			self:Pour(message, r, g, b, nil, nil, nil, nil, nil, (select(3,GetSpellInfo(SpellTemplate.hymnofhope.id))))
		elseif event == "ResRequest" then
			message = string.gsub(self.db.profile.rebirthonxRequest, "%%t", coloredNames[target])
			message = string.gsub(message, "%%s", SpellTemplate.rebirth.name)
			self:Pour(message, r, g, b, nil, nil, nil, nil, nil, (select(3,GetSpellInfo(spellId))))
		end
	end
end

function Rebirther:Request(name, spellId, target)	-- This function may not work properly
	unitname = self:GetFullName(target)
	local pName = UnitName("player")
	local message = nil

	-- Innervate
	if ( spellId == SpellTemplate.innervate.id and innervate[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) and not UnitIsDeadOrGhost(unitname) ) then
		message = string.gsub(self.db.profile.innervateRequest, "%%s", SpellTemplate.innervate.name)
		SendChatMessage(message, "WHISPER", nil, name)
		self:SendRequest("InnervateRequest", name, nil, pName)
	-- Mana Tide
	elseif ( spellId == SpellTemplate.manatide.id and innervate[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) ) then
		message = string.gsub(self.db.profile.manatideRequest, "%%s", SpellTemplate.manatide.name)
		SendChatMessage(message, "WHISPER", nil, name)
		self:SendRequest("ManaTideRequest", name)
	-- Hymn of Hope
	elseif ( spellId == SpellTemplate.hymnofhope.id and innervate[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) ) then
		message = string.gsub(self.db.profile.hymnRequest, "%%s", SpellTemplate.hymnofhope.name)
		SendChatMessage(message, "WHISPER", nil, name)
		self:SendRequest("HymnofHopeRequest", name)
	-- Rebirth on self
	elseif ( target == "123" and (spellId == SpellTemplate.rebirth.id or spellId == SpellTemplate.raiseally.id or spellId == SpellTemplate.soulstone.id) and rebirth[name].rebirth.time == "Ready" and not UnitIsDeadOrGhost(name) and UnitIsDeadOrGhost("player") ) then
		message = string.gsub(self.db.profile.rebirthRequest, "%%s", SpellTemplate.rebirth.name)
		SendChatMessage(message, "WHISPER", nil, name)
		self:SendRequest("ResRequest", name, spellId, pName)
	-- Rebirth on X
	elseif UnitExists(unitname) and ( (spellId == SpellTemplate.rebirth.id or spellId == SpellTemplate.raiseally.id or spellId == SpellTemplate.soulstone.id) and rebirth[name].rebirth.time == "Ready" and (IsRaidLeader() or IsRaidOfficer()) and not UnitIsDeadOrGhost(name) and UnitIsDeadOrGhost(unitname)) then
		message = string.gsub(self.db.profile.rebirthonxRequest, "%%t", unitname)
		message = string.gsub(message, "%%s", SpellTemplate.rebirth.name)
		SendChatMessage(message, "WHISPER", nil, name)
		self:SendRequest("ResRequest", name, spellId, unitname)
	end
end

function Rebirther:Announce(spellId, destName)
	if ( destName == "Unknown" or not destName or destName == "" ) then
		if ( self.db.profile.guess == "mouseover" ) then
			destName = UnitName("mouseover")
		elseif ( self.db.profile.guess == "target" ) then
			destName = UnitName("target")
		else
			--return false
		end
	end

	-- Form the message
	local message = ""
	local spellName = (GetSpellInfo(spellId))
	-- Innervate
	if ( spellId == SpellTemplate.innervate.id and self.db.profile.announceOnInnervate ) then
		if ( destName ) then
			message = string.gsub(self.db.profile.innervateGroup, "%%t", destName)
		end
		message = string.gsub(message, "%%s", SpellTemplate.innervate.name)
	-- Battle res
	elseif ( spellIsCR(spellId) and self.db.profile.announceOnRebirth ) then
		if ( destName ) then
			message = string.gsub(self.db.profile.rebirthGroup, "%%t", destName)
		end
		message = string.gsub(message, "%%s", spellName)
	-- Mana Tide
	elseif ( spellId == SpellTemplate.manatide.id and self.db.profile.announceOnManaTide ) then
		message = string.gsub(self.db.profile.manatideGroup, "%%s", SpellTemplate.manatide.name)
	-- Hymn of Hope
	elseif ( spellId == SpellTemplate.hymnofhope.id and self.db.profile.announceOnHymn ) then
		message = string.gsub(self.db.profile.hymnGroup, "%%s", SpellTemplate.hymnofhope.name)
	-- Normal res
	elseif ( spellIsNormalRes(spellId) and self.db.profile.announceOnNormal ) then
		if ( destName ) then
			message = string.gsub(self.db.profile.normalGroup, "%%t", destName)
		end
		message = string.gsub(message, "%%s", spellName)
	end

	-- Send to appropriate channel
	local group = self:GroupType()
	if ( (group == "BATTLEGROUND" and self.db.profile.announceToBG) or (group == "RAID" and self.db.profile.announceToRaid) or (group == "PARTY" and self.db.profile.announceToParty) ) then
		-- Innervate
		if ( spellId == SpellTemplate.innervate.id and self.db.profile.announceOnInnervate ) then
			if ( destName == UnitName("player") ) then
				if ( self.db.profile.announceOnSelf ) then
					SendChatMessage(message, group, nil, nil)
				end
			else
				SendChatMessage(message, group, nil, nil)
			end
		-- Battle res
		elseif ( spellIsCR(spellId) and self.db.profile.announceOnRebirth ) then
			SendChatMessage(message, group, nil, nil)
		-- Mana Tide
		elseif ( spellId == SpellTemplate.manatide.id and self.db.profile.announceOnManaTide ) then
			SendChatMessage(message, group, nil, nil)
		-- Hymn of Hope
		elseif ( spellId == SpellTemplate.hymnofhope.id and self.db.profile.announceOnHymn ) then
			SendChatMessage(message, group, nil, nil)
		-- Normal res
		elseif ( spellIsNormalRes(spellId) and self.db.profile.announceOnNormal ) then
			SendChatMessage(message, group, nil, nil)
		end
	end
	-- Announce to custom channel
	if ( group ~= "SOLO" and self.db.profile.announceToChannel ~= "" and message ~= "") then
		SendChatMessage(message, "CHANNEL", nil, GetChannelName(self.db.profile.announceToChannel))
	end
	-- To target
	if ( self.db.profile.announceToTarget and destName and destName ~= "" and destName ~= "Unknown" and destName ~= UnitName("player") ) then
		if ( spellId == SpellTemplate.innervate.id ) then
			message = string.gsub(self.db.profile.innervateWhisper, "%%t", destName)
			message = string.gsub(message, "%%s", SpellTemplate.innervate.name)
			SendChatMessage(message, "WHISPER", nil, destName)
		elseif ( spellIsCR(spellId) ) then
			message = string.gsub(self.db.profile.rebirthWhisper, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, "WHISPER", nil, destName)
		elseif ( spellIsNormalRes(spellId) and self.db.profile.announceOnNormal ) then
			message = string.gsub(self.db.profile.normalWhisper, "%%t", destName)
			message = string.gsub(message, "%%s", spellName)
			SendChatMessage(message, "WHISPER", nil, destName)
		end
	end
end

function Rebirther:AnnounceInterrupt(spellId, destName)
	if ( not self.db.profile.announceOnInterrupt ) then
		return false
	end
	if ( destName == "Unknown" or not destName ) then
		if ( self.db.profile.guess == "mouseover" ) then
			destName = UnitName("mouseover")
		elseif ( self.db.profile.guess == "target" ) then
			destName = UnitName("target")
		else
			return false
		end
	end
	local group = self:GroupType()
	local message = ""
	local spellName = (GetSpellInfo(spellId))
	if ( destName ) then
		message = string.gsub(self.db.profile.interruptGroup, "%%t", destName)
	end
	message = string.gsub(message, "%%s", spellName)local group = self:GroupType()
	if ( (group == "BATTLEGROUND" and self.db.profile.announceToBG) or (group == "RAID" and self.db.profile.announceToRaid) or (group == "PARTY" and self.db.profile.announceToParty) ) then
		-- Innervate
		if ( spellIsCR(spellId) and self.db.profile.announceOnRebirth ) then
			SendChatMessage(message, group, nil, nil)
		-- Hymn of Hope
		elseif ( spellId == SpellTemplate.hymnofhope.id and self.db.profile.announceOnHymn ) then
			SendChatMessage(message, group, nil, nil)
		-- Normal res
		elseif ( spellIsNormalRes(spellId) and self.db.profile.announceOnNormal ) then
			SendChatMessage(message, group, nil, nil)
		end
	end
	if ( self.db.profile.announceToChannel ~= "" and message ~= "") then
		SendChatMessage(message, "CHANNEL", nil, GetChannelName(self.db.profile.announceToChannel))
	end
end










-- Group related functions

function Rebirther:GroupType(test)
	if ( test ) then
		if ( test == "BATTLEGROUND" and UnitInBattleground("player") ) then
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		elseif ( test == "RAID" and IsInRaid() ) then -- Some said to use IsInRaid() Instead of UnitInRaid("player")
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		elseif ( test == "PARTY" and  not IsInRaid() ) then -- Some said to use IsInRaid() Instead of UnitInParty("player")
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		elseif ( test == "SOLO") then
			self:Debug("Group test POSTIVIVE for: "..test)
			return true
		else
			self:Debug("Group test NEGATIVE for: "..test)
			return false
		end
	else
		if ( UnitInBattleground("player") ) then	-- Battleground
			return "BATTLEGROUND"
		elseif ( IsInRaid() ) then	-- Raid
			return "RAID"
		elseif (not (GetNumGroupMembers()==0) and not IsInRaid() ) then	-- Party
			return "PARTY"
		else
			return "SOLO"
		end
	end
end
function Rebirther:TryToAdd(name)
	lvl = UnitLevel(name)
	class = select(2,UnitClass(name))
	if ( (class == "DRUID" and lvl >= SpellTemplate.rebirth.level) or (class == "WARLOCK" and lvl >= SpellTemplate.soulstone.level) or (class == "DEATHKNIGHT" and lvl >= SpellTemplate.raiseally.level) ) then
		self:AddRebirth(name)
	end
	if (class == "DRUID" and lvl >= SpellTemplate.innervate.level) then
		if ( not innervate[name] ) then
			self:AddInnervate(name)	-- Create the druid so we can track his cooldowns even if we don't want to see them.
			self:RemoveInnervate(name) -- But don't show him
		end
		--[[
		if ( not self.db.profile.druid.balance and not self.db.profile.druid.feral and not self.db.profile.druid.resto ) then
			self:RemoveInnervate(name)
		elseif ( self.db.profile.druid.balance and self.db.profile.druid.feral and self.db.profile.druid.resto ) then
			self:AddInnervate(name)
		else
			NotifyInspect(name)
		end
		]]
		if ( not self.db.profile.druid.balance and not self.db.profile.druid.feral and not self.db.profile.druid.resto ) then
			self:RemoveInnervate(name)
		elseif ( self.db.profile.druid.balance and self.db.profile.druid.feral and self.db.profile.druid.resto ) then
			self:AddInnervate(name)
		elseif ( (innervate[name].spec == 1 and self.db.profile.druid.balance) or (innervate[name].spec == 2 and self.db.profile.druid.feral) or (innervate[name].spec == 3 and self.db.profile.druid.resto) ) then
			self:AddInnervate(name)
		else
			self:RemoveInnervate(name)
		--[[
		elseif ( innervate[name].spec == 0 ) then
			--NotifyInspect(name)
			self:RemoveInnervate(name)
		elseif ( innervate[name].spec == 1 ) then
			if ( self.db.profile.druid.balance ) then
				self:AddInnervate(name)
			else
				self:RemoveInnervate(name)
			end
		elseif ( innervate[name].spec == 2 ) then
			if ( self.db.profile.druid.feral ) then
				self:AddInnervate(name)
			else
				self:RemoveInnervate(name)
			end
		elseif ( innervate[name].spec == 3 ) then
			if ( self.db.profile.druid.resto ) then
				self:AddInnervate(name)
			else
				self:RemoveInnervate(name)
			end
		]]
		end
	end
	if ( (class == "PRIEST" and lvl >= SpellTemplate.hymnofhope.level) ) then
		if ( not innervate[name] ) then
			self:AddInnervate(name)
		end
		if ( self.db.profile.priest ) then
			self:AddInnervate(name)
		else
			self:RemoveInnervate(name)
		end
	end
	if (class == "SHAMAN" and lvl >= SpellTemplate.manatide.level) then
		if ( not innervate[name] ) then
			self:AddInnervate(name)
		end
		if ( innervate[name].spec == 3 and self.db.profile.shaman ) then
			self:AddInnervate(name)
		else
			self:RemoveInnervate(name)
		end
	end
end
function Rebirther:TryToShow()
	if ( self.db.profile.autoshow ) then
		self:Show(MasterWindow, true)
		if self.db.profile.rebirthShow and ( (self:GroupType() == "BATTLEGROUND" and self.db.profile.showInBG and NoRebirths() > 0) or (self:GroupType() == "RAID" and self.db.profile.showInRaid and NoRebirths() > 0) or (self:GroupType() == "PARTY" and self.db.profile.showInParty and NoRebirths() > 0) or (self:GroupType() == "SOLO" and self.db.profile.showWhenSolo) ) then
			self:Show(Window.rebirths, true)
		else
			self:Show(Window.rebirths, false)
		end
		if self.db.profile.innervateShow and ( (self:GroupType() == "BATTLEGROUND" and self.db.profile.showInBG and NoInnervates() > 0) or (self:GroupType() == "RAID" and self.db.profile.showInRaid and NoInnervates() > 0) or (self:GroupType() == "PARTY" and self.db.profile.showInParty and NoInnervates() > 0) or (self:GroupType() == "SOLO" and self.db.profile.showWhenSolo) ) then
			self:Show(Window.innervates, true)
		else
			self:Show(Window.innervates, false)
		end
	end
end
function Rebirther:CheckGroupStatus()	-- Find new druids
	self:Debug("Checking group status")
	if ( UnitAffectingCombat("player") ) then	-- Don't update if the player is in combat! Dunno why but something bugged when stuff happened in combat (or was it something else?)
		RosterUpdate = true
		self:Debug("You are in combat: Waiting")
	elseif ( testmode ) then
		self:Debug("You are in testing mode: Waiting")
	else
		--self:Debug("Number of raid members: "..GetNumGroupMembers())
		self:Debug("Number of real raid members: "..GetNumGroupMembers())
		self:Debug("Number of real party members: "..GetNumGroupMembers())
		RosterUpdate = false
		--RosterLastUpdate = time()
		--tmpa = NoDruids()
		tmpi = NoInnervates()
		tmpr = NoRebirths()
		if ( self:GroupType() == "RAID" ) then	-- Raid
			self:Debug("You are in a raid")
			local x, n, d = 1, GetNumGroupMembers(), select(3, GetInstanceInfo())
			if ( d == 4 or d == 6 or d == 7 ) then -- 25 man
				d = 25
			else -- 10 man
				d = 10
			end
			self:Debug("Number of raid members: "..n)
			while x <= n do
				local name, _, subgroup, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
				if ( name ) then
					--self:Debug("Raid member #"..x..": "..name)
					self:TryToAdd(name)
				end
				x = x + 1
			end
			self:Debug("Size of raid: "..d)
			--[[
			if ( not self.db.profile.showExtraGroups ) then
				self:Debug("Checking for redundant druids")
				x = 1
				while x <= n do
					local name, _, subgroup, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
					self:Debug("Name: "..name)
					self:Debug("Subgroup: "..subgroup)
					self:Debug("Class: "..class)
					if ( druid[name] and ((d == 25 and subgroup > 5) or (d == 10 and subgroup > 2)) ) then
						self:RemoveDruid(name)
						tmpa = 1000
					end
					x = x + 1
				end
			end
			]]
			if ( not self.db.profile.showExtraGroups ) then
				self:Debug("Checking for redundant druids")
				x = 1
				while x <= n do
					local name, _, subgroup, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
					if ( name ) then
						--self:Debug("Name: "..name)
						--self:Debug("Subgroup: "..subgroup)
						--self:Debug("Class: "..class)
						if ( rebirth[name] and ((d == 25 and subgroup > 5) or (d == 10 and subgroup > 2)) ) then
							self:RemoveRebirth(name)
						end
						if ( innervate[name] and ((d == 25 and subgroup > 5) or (d == 10 and subgroup > 2)) ) then
							self:RemoveInnervate(name)
						end
					end
					x = x + 1
				end
			end
		elseif ( self:GroupType() == "BATTLEGROUND" ) then	-- Battleground
			self:Debug("You are in a battleground")
			local x, n = 1, GetNumGroupMembers()
			while x <= n do
				local name, _, _, _, class, _, _, _, _, _, _ = GetRaidRosterInfo(x)
				if ( name ) then
					--self:Debug("Raid member #"..x..": "..name)
					self:TryToAdd(name)
				end
				x = x + 1
			end
		elseif ( self:GroupType() == "PARTY" ) then	-- Party
			self:Debug("You are in a party")
			local x, n = 1, GetNumGroupMembers()
			while x <= n do
				local name,class = self:GetFullName("party"..x), UnitClass("party"..x)
				if ( name ) then
					--self:Debug("Party member #"..x..": "..name)
					self:TryToAdd(name)
				end
				x = x + 1
			end
			self:TryToAdd(UnitName("player"))
		else	-- All alone
			self:Debug("You are solo")
			self:TryToAdd(UnitName("player"))
		end
		for key,val in pairs(innervate) do	-- Remove the druids who aren't in your group anymore
			if ( not (UnitInBattleground(val.name) or UnitInRaid(val.name) or UnitInParty(val.name) or UnitName("player") == val.name) ) then
				--self:Debug(val.name.." is considered to NOT be in your group")
				self:RemoveInnervate(val.name)
			else
				--self:Debug(val.name.." is considered to be in your group")
			end
		end
		for key,val in pairs(rebirth) do	-- Remove the druids who aren't in your group anymore
			if ( not (UnitInBattleground(val.name) or UnitInRaid(val.name) or UnitInParty(val.name) or UnitName("player") == val.name) ) then
				--self:Debug(val.name.." is considered to NOT be in your group")
				self:RemoveRebirth(val.name)
			else
				--self:Debug(val.name.." is considered to be in your group")
			end
		end
		--[[
		if ( tmpa - size(druid) ~= 0 ) then	-- If the number of druids changed (i.e. a druid joined or left)
			self:Debug("A druid has joined or left the group")
			if ( tmpa < size(druid) ) then
				self:RequestSync()	-- If a druid joined we want to see if he has any cooldowns to sync (this probably spams the shit out of the addon channel: find better solution)
			end
			local x = 0
			local height = self.db.profile.bar.height + self.db.profile.bar.spacing
			for key,val in pairs(druid) do
				self:Debug("Updating bars for: "..val.name)
				self:UpdateBar(val, val.innervate, x * height )
				self:UpdateBar(val, val.rebirth, x * height )
				x = x + 1
			end
		end
		]]
		if ( tmpr < NoRebirths() ) then
			self:RequestSync()	-- If a druid joined we want to see if he has any cooldowns to sync (this probably spams the shit out of the addon channel: find better solution)
		end
		--[[
		local x = 0
		local height = self.db.profile.bar.height + self.db.profile.bar.spacing
		for key,val in pairs(druid) do
			if ( val.show ) then
				self:Debug("Updating bars for: "..val.name)
				self:UpdateBar(val, val.innervate, x * height )
				self:UpdateBar(val, val.rebirth, x * height )
				x = x + 1
			end
		end
		]]
		self:UpdateBars()
		self:SetNames()


		--self:Debug("Number of druids: "..NoDruids())
		self:Debug("Group type: "..self:GroupType())
		if ( self.db.profile.autoshow ) then
			self:Debug("Auto show: on")
		else
			self:Debug("Auto show: off")
		end
		if ( self.db.profile.showInBG ) then
			self:Debug("showInBG: on")
		else
			self:Debug("showInBG: off")
		end
		if ( self.db.profile.showInRaid) then
			self:Debug("showInRaid: on")
		else
			self:Debug("showInRaid: off")
		end
		if ( self.db.profile.showInParty ) then
			self:Debug("showInParty: on")
		else
			self:Debug("showInParty: off")
		end
		if ( self.db.profile.showWhenSolo ) then
			self:Debug("showWhenSolo: on")
		else
			self:Debug("showWhenSolo: off")
		end



		self:TryToShow()
	end
end













-- Events

uss_target = ""
function Rebirther:COMBAT_LOG_EVENT_UNFILTERED (eventName, ...)
	--local _,clevent,_,sourceName,_,_,destName,_,_,spellName = ... -- pre 4.1
	--local _,clevent,_,_,sourceName,_,_,destName,_,_,spellName -- 4.1

	-- 4.2
	local clevent = select(2,...)
	local sourceName = select(5,...)
	local destName = select(9,...)
	local spellId = select(12,...)
	local spellName = select(13,...)

	if ( clevent == "SPELL_CAST_SUCCESS" ) then
		if ( spellIsManaCD(spellId) ) then
			if ( innervate[sourceName] ) then
				self:StartCooldown(innervate[sourceName].innervate, nil, sourceName, destName)
				if ( sourceName == UnitName("player") ) then
					self:Announce(spellId, destName)
				end
			end
		end
	elseif ( clevent == "SPELL_RESURRECT" ) then
		if ( spellIsCR(spellId) ) then
			if ( rebirth[sourceName] ) then
				self:StartCooldown(rebirth[sourceName].rebirth, nil, sourceName, destName)
				if ( sourceName == UnitName("player") and spellId == SpellTemplate.raiseally.id ) then
					self:Announce(spellId, destName)
				end
				--if ( self:GroupType() == "RAID" and IsEncounterInProgress() ) then
				--	if ( CRsRemaining > 0 ) then
				--		CRsRemaining = CRsRemaining - 1
				--		Window.rebirths.title:SetText(L["Battle Resses"]..": "..CRsRemaining.." remain")
				--	end
				--end
			end
		end
		--[[
	elseif ( clevent == "SPELL_CAST_START" and sourceName == UnitName("player") ) then
		uss_target = destName
		if ( spellId == SpellTemplate.rebirth.id or spellId == SpellTemplate.soulstone.id ) then
			self:Announce(spellId, destName)
		elseif (spellIsNormalRes(spellId)) then
			self:Announce(spellId, destName)
		end
	elseif ( clevent == "SPELL_CAST_FAILED" and sourceName == UnitName("player") ) then
		if ( spellId == SpellTemplate.rebirth.id or spellId == SpellTemplate.soulstone.id ) then
			self:AnnounceInterrupt(spellId, uss_target)
		elseif (spellIsNormalRes(spellId)) then
			self:AnnounceInterrupt(spellId, uss_target)
		end
		]]
	elseif ( clevent == "SPELL_CAST_START" and sourceName ~= UnitName("player") and sourceName and sourceName ~= "" ) then
		target = UnitName(format("%s-target",sourceName))
		if ( target and target ~= "" and UnitIsDeadOrGhost(target) ) then
			if ( spellId == SpellTemplate.rebirth.id or spellId == SpellTemplate.soulstone.id ) then
				self:RebirthOut(L["X is ressing Y"](self:ColourByClass(sourceName),self:ColourByClass(target)))
			elseif ( spellIsNormalRes(spellId) ) then
				self:RebirthOut(L["X is ressing Y"](self:ColourByClass(sourceName),self:ColourByClass(target)))
			end
		end
	elseif ( clevent == "SPELL_AURA_APPLIED" or clevent == "SPELL_AURA_REFRESH" ) then
		if ( spellId == SpellTemplate.soulstone.auraid ) then
			if ( rebirth[sourceName] ) then
				self:StartCooldown(rebirth[sourceName].rebirth, nil, sourceName, destName)
			end
		end
	end
end

function Rebirther:UNIT_SPELLCAST_SENT(eventName, unitID, spell, rank, target)
	uss_target = UnitName(target)
	if ( spell == SpellTemplate.rebirth.name ) then
		self:Announce(SpellTemplate.rebirth.id, uss_target)
	elseif ( spell == SpellTemplate.soulstone.name ) then
		self:Announce(SpellTemplate.soulstone.id, uss_target)
	elseif (spellIsNormalRes(spell)) then
		self:Announce(ResId(spell), uss_target)
	end
end
function Rebirther:UNIT_SPELLCAST_INTERRUPTED(eventName, unitID, spell, rank)
	if ( UnitName(unitID) == UnitName("player") and uss_target and uss_target ~= "") then
		if ( spell == SpellTemplate.rebirth.name ) then
			self:AnnounceInterrupt(SpellTemplate.rebirth.id, uss_target)
			uss_target = ""
		elseif ( spell == SpellTemplate.soulstone.name ) then
			self:AnnounceInterrupt(SpellTemplate.soulstone.id, uss_target)
			uss_target = ""
		elseif (spellIsNormalRes(spell)) then
			self:AnnounceInterrupt(ResId(spell), uss_target)
			uss_target = ""
		end
	end
end

function Rebirther:GroupChanged(eventName, ...) -- isn't this a bit too generic?
	self:Debug("Event: "..eventName)
	if eventName == "PLAYER_ENTERING_WORLD" then
		Rebirther:ZoneChange()
	end
	RosterUpdate = true
end

function Rebirther:TargetChange(eventName)
	local target = "target"
	if eventName == "UPDATE_MOUSEOVER_UNIT" then target = "mouseover" end
	self:UpdateDistanceToTarget(target)
end

function Rebirther:ZoneChange()
	local zone = GetRealZoneText()

	if zone == nil or zone == "" then
		-- zone hasn't been loaded yet, try again in 5 secs.
		Rebirther:ScheduleTimer(Rebirther.ZoneChange, 5)
		return
	end

	-- normally zoned into a raid where nothing is happening so we are safe to reset remaining CRs
	if not IsEncounterInProgress() and not UnitIsDeadOrGhost("player") and not UnitAffectingCombat("player") and select(2, IsInInstance()) == "raid" then
		local _, _, diff = GetInstanceInfo()
		if ( diff == 4 or diff == 6 or diff == 7 ) then -- 25 man
			CRsRemaining = 3
		else -- 10 man
			CRsRemaining = 1
		end
		Window.rebirths.title:SetText(L["Battle Resses"]..": "..CRsRemaining.." remain")
	elseif not IsInInstance() then
		Window.rebirths.title:SetText(L["Battle Resses"])
	end
end

function Rebirther:INCOMING_RESURRECT_CHANGED(eventName, unitId)
	if self:GroupType() ~= "RAID" and not unitId:find("raid") then return end
	if UnitHasIncomingResurrection(unitId) then
		hasIncomingResurrection[unitId] = true
	else
		Rebirther:RegisterEvent("UNIT_HEALTH")
	end
end

function Rebirther:UNIT_HEALTH(eventName, unitId)
	if not UnitIsDeadOrGhost(unitId) and hasIncomingResurrection[unitId] and not UnitHasIncomingResurrection(unitId) and unitId:find("raid") then
		hasIncomingResurrection[unitId] = nil
		if IsEncounterInProgress() then
			CRsRemaining = CRsRemaining - 1
			Window.rebirths.title:SetText(L["Battle Resses"]..": "..CRsRemaining.." remain")
		end
		if not next(hasIncomingResurrection) then
			Rebirther:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

function Rebirther:CheckForWipe()
	local wiped = true
	local num = GetNumGroupMembers()
	for i = 1, num do
		local name = GetRaidRosterInfo(i)
		if name then
			if UnitAffectingCombat(name) then
				wiped = false
			end
		end
	end
	if wiped then
		-- reset the remaining CR counter after a wipe
		if ( self:GroupType() == "RAID" ) then
			local _, _, diff = GetInstanceInfo()
			if ( diff == 4 or diff == 6 or diff == 7 ) then -- 25 man
				CRsRemaining = 3
			else -- 10 man
				CRsRemaining = 1
			end
			wipe(hasIncomingResurrection)
			Window.rebirths.title:SetText(L["Battle Resses"]..": "..CRsRemaining.." remain")
		end
	end
	return wiped
end

function Rebirther:ResetCombatResCooldowns() -- might want to do something similar for other cooldowns too
	-- we reset everyones CD here, probably would be better to poll during wipe check and see if they were in combat during the encounter, and reset based on that
	for name in pairs(rebirth) do
		rebirth[name].rebirth.bar.animation:Stop()
	end
end

function Rebirther:KeepCheckingForWipe()
	local wiped = false
	if not Rebirther:CheckForWipe() then
		Rebirther:ScheduleTimer(Rebirther.KeepCheckingForWipe, 2)
	else
		if GetTime() - lastEncounterInProgress < 10 then -- this was a wipe on an encounter
			Rebirther:ResetCombatResCooldowns()
		end
		wiped = true
	end
	return wiped
end

function Rebirther:PLAYER_REGEN_ENABLED (eventName, ...)	-- Coming out of combat
	if self:GroupType() == "RAID" then -- handle raid wipes separately
		Rebirther:KeepCheckingForWipe()
	else
		Window.rebirths.title:SetText(L["Battle Resses"])
	end
end
function Rebirther:PLAYER_TALENT_UPDATE (eventName, ...)
	NotifyInspect(UnitName("player"))
end


function Rebirther:INSPECT_READY (eventName, guid)
	_,class,_,_,_,name = GetPlayerInfoByGUID(guid)
	name = self:GetFullName(name)
	if ( name and name ~= "" and CanInspect(name) ) then
		if ( class == "SHAMAN" and innervate[name] ) then
			tname,_,_,_,rank = GetTalentInfo(3,15,true)
			if not tname or not rank then return end -- XXX hack to not throw errors, this needs rework for MoP
			if ( --[[tname == "Mana Tide Totem" and]] rank > 0 ) then
				innervate[name].spec = 3
				self:AddInnervate(name)
				if (not self.db.profile.shaman) then
					self:RemoveInnervate(name)
				end
			else
				self:RemoveInnervate(name)
				innervate[name].spec = 1
			end
		elseif ( class == "DRUID" and innervate[name] ) then
			--[[
			balance = select(5,GetTalentTabInfo(1,true))
			feral = select(5,GetTalentTabInfo(2,true))
			resto = select(5,GetTalentTabInfo(3,true))
			if ( self.db.profile.druid.balance == true and balance > feral and balance > resto ) then
				self:AddInnervate(name)
			elseif ( self.db.profile.druid.feral == true and feral > resto and feral > balance ) then
				self:AddInnervate(name)
			elseif ( self.db.profile.druid.resto == true and resto > feral and resto > balance ) then
				self:AddInnervate(name)
			elseif ( balance == 0 and feral == 0 and resto == 0 ) then
				-- lol
			else
				self:RemoveInnervate(name)
			end
			]]
			innervate[name].spec = GetSpecialization()--GetPrimaryTalentTree(true)
			if ( not innervate[name].spec ) then
				--NotifyInspect(name)
				innervate[name].spec = 0
			elseif ( self.db.profile.druid.balance and innervate[name].spec == 1 ) then
				self:AddInnervate(name)
			elseif ( self.db.profile.druid.feral and innervate[name].spec == 2 ) then
				self:AddInnervate(name)
			elseif ( self.db.profile.druid.resto and innervate[name].spec == 3 ) then
				self:AddInnervate(name)
			else
				innervate[name].spec = 0
			end
		end
		--ClearInspectPlayer()
	else
		--NotifyInspect(name)
	end
end










-- Syncing

function Rebirther:SendRequest(event, name, spellId, target)
	if self:GroupType() ~= "SOLO" then
		self:SendCommMessage( AddonCommPrefix, self:Serialize(event,_,spellId,target), "WHISPER", name )
	end
end

function Rebirther:SendSync (event, name, spellId, target, remainingCD)
	if ( self.db.profile.sync and self:GroupType() ~= "SOLO" ) then
		local PossibleGroups = { "RAID", "BATTLEGROUND", "PARTY" }
		for _,val in pairs(PossibleGroups) do
			if ( self:GroupType(val) ) then
				self:SendCommMessage( AddonCommPrefix, self:Serialize(event,name,spellId,target,remainingCD), val )
			end
		end
	end
end
function Rebirther:RequestSync()
	if ( self.db.profile.sync and self:GroupType() ~= "SOLO" ) then
		local PossibleGroups = { "RAID", "BATTLEGROUND", "PARTY" }
		for _,val in pairs(PossibleGroups) do
			if ( self:GroupType(val) ) then
				self:SendCommMessage( AddonCommPrefix, self:Serialize("BroadcastRequest"), val )
			end
		end
	end
end
function Rebirther:OnCommReceived (prefix, message, distribution, sender)	-- When we receive a message from another client
	if ( self:GroupType() ~= "SOLO" and sender ~= UnitName("player")  ) then	-- only use communication if we're not solo
		local success, event, name, spellId, target, remainingCD = self:Deserialize(message)
		if ( success ) then
			if self.db.profile.sync then -- Only use syncing if syncing is enabled
				if ( event == "StartCooldown" ) then
					if ( spellIsCR(spellId) and rebirth[name] and rebirth[name].rebirth.time == "Ready" ) then
						self:StartCooldown(rebirth[name].rebirth,nil,name,target)
					elseif ( spellIsManaCD(spellId) and innervate[name] and innervate[name].innervate.time == "Ready" ) then
						self:StartCooldown(innervate[name].innervate,nil,name,target)
					end
				elseif ( event == "BroadcastRequest" ) then
					for key,val in pairs(rebirth) do
						if ( val.rebirth.time ~= "Ready" ) then
							self:SendSync("SyncCooldown", val.name, val.rebirth.id, val.target, val.rebirth.cooldown - (GetTime() - val.rebirth.time))
						end
					end
					for key,val in pairs(innervate) do
						if ( val.innervate.time ~= "Ready" ) then
							self:SendSync("SyncCooldown", val.name, val.innervate.id, val.target, val.innervate.cooldown - (GetTime() - val.innervate.time))
						end
					end
				elseif ( event == "SyncCooldown" ) then
					if ( spellIsCR(spellId) and rebirth[name] and rebirth[name].rebirth.time == "Ready" ) then
						self:StartCooldown(rebirth[name].rebirth,remainingCD,name,target)
					elseif ( spellIsManaCD(spellId) and innervate[name] and innervate[name].innervate.time == "Ready" ) then
						self:StartCooldown(innervate[name].innervate,remainingCD,name,target)
					end
				end
			end
			if event == "InnervateRequest" then
				self:OutputRequest(event, target)
			elseif event == "ManaTideRequest" then
				self:OutputRequest(event)
			elseif event == "HymnofHopeRequest" then
				self:OutputRequest(event)
			elseif event == "ResRequest" then
				self:OutputRequest(event, target, spellId)
			end
		end
	end
end












-- Options and defaults

function Rebirther:GetDefaults()
	return {
		profile = {
			-- Default settings
			enable = true,

			-- General
			show = true,
			showtarget = true,
			showServerName = false,
			showExtraGroups = false,
			sync = false,
			verbose = true,
			guess = "mouseover",

			-- Specs
			druid = {
				balance = true,
				feral = true,
				resto = true,
			},
			shaman = true,
			priest = true,

			-- Windows
			lock = false,
			showicon = true,
			rebirthShow = true,
			innervateShow = true,
			scale = 1,
			backgroundColour = { r = 0, g = 0, b = 0, a = 0.5 },
			rebirthCoord = { x = UIParent:GetWidth()/2, y = UIParent:GetHeight()/2 },
			innervateCoord = { x = UIParent:GetWidth()/2, y = UIParent:GetHeight()/2 },

			-- Announce when...
			announceOnInnervate = true,
			announceOnRebirth = true,
			announceOnNormal = true,
			announceOnSelf = false,
			announceToBG = false,
			announceToRaid = true,
			announceToParty = true,
			announceToTarget = false,
			announceToChannel = "",
			announceOnInterrupt = false,
			announceOnManaTide = true,
			announceOnHymn = true,
			rebirthWhisper = L["DefaultRebirthWhisper"],
			rebirthGroup = L["DefaultRebirthGroup"],
			innervateWhisper = L["DefaultInnervateWhisper"],
			innervateGroup = L["DefaultInnervateGroup"],
			normalWhisper = L["DefaultNormalWhisper"],
			normalGroup = L["DefaultNormalGroup"],
			manatideGroup = L["DefaultManaTideGroup"],
			hymnGroup = L["DefaultHymnGroup"],
			interruptGroup = L["DefaultInterruptGroup"],
			-- Requests
			innervateRequest = L["DefaultInnervateRequest"],
			innervatexRequest = L["DefaultInnervateXRequest"],
			manatideRequest = L["DefaultManaTideRequest"],
			hymnRequest = L["DefaultHymnRequest"],
			rebirthRequest = L["DefaultRebirthRequest"],
			rebirthonxRequest = L["DefaultRebirthOnXRequest"],

			-- Show when...
			autoshow = true,
			showInBG = false,
			showInRaid = true,
			showInParty = true,
			showWhenSolo = false,

			-- Bars
			bar = {
				allowClick = true,
				allowScroll = true,
				readyColour = { r = 0, g = 1, b = 0 },
				RangeColor = { r = 0, g = 1, b = 1 },
				deadColour = { r = 0.5, g = 0.5, b = 0.5 },
				cooldownColour = { r = 1, g = 0, b = 0 },
				opacity = 0.75,
				texture = SM:GetDefault("statusbar"),
				texturePath = SM:Fetch("statusbar", SM:GetDefault("statusbar")),
				width = 175,
				height = 20,
				spacing = 1,
				growUp = false,
				useClassColour = false,
				useRangeRecolor = false,
				hideOnCD = false,
			},

			-- Fonts
			font = {
				file = SM:GetDefault("font"),
				filePath = SM:Fetch("font", SM:GetDefault("font")),
				nameColour = { r = 1, g = 1, b = 1 },
				nameSize = 14,
				targetColour = { r = 1, g = 0.82, b = 0 },
				targetSize = 10,
				timeColour = { r = 1, g = 1, b = 1 },
				timeSize = 10,
				titleSize = 10,
				titleColour = { r = 1, g = 0.82, b = 0 },
			},

			-- Output
			sink20OutputSink = "RaidWarning",
			sinkColour = {r = 1, g = 1, b = 1 },
		}
	}
end

function Rebirther:GetOptions()
	return {
		name = AddonName,
		childGroups = "tab",
		handler = Rebirther,
		type = "group",
		args = {
			version = {
				order = 0,
				name = L["Version"].." "..AddonVersion,
				--desc = "testing",
				type = "description",
			},
			enable = {
				name = L["Enable"],
				desc = L["EnablesDesc"],
				type = "toggle",
				order = 1,
				set = function(info,val) if ( self:IsEnabled() ) then self:Disable() else self:Enable() end end,
				get = function(info) return self:IsEnabled() end
			},
			testmode = {
				name = L["Test Mode"],
				desc = L["Test ModeDesc"],
				type = "toggle",
				order = 2,
				set = function(info,val) self:TestMode() end,
				get = function(info) return testmode end,
			},
			debugmode = {
				name = L["Debug Mode"],
				desc = L["Debug ModeDesc"],
				type = "toggle",
				order = 3,
				set = function(info,val) self:DebugMode() end,
				get = function(info) return Debug end,
			},
			requestres = {
				name = L["Request Res"],
				usage = L["requestresusage"],
				desc = L["requestresdesc"],
				type = "input",
				guiHidden = true,
				set = function(info, input)
						--[==[
						for a,b in pairs(druid) do
							if ( b.show and b.rebirth.time == "Ready" and not UnitIsDeadOrGhost(b.name) --[[and UnitIsDeadOrGhost(unitname)]] ) then
								self:Request(b.name, b.rebirth.name, input)
								break;
							end
						end
						]==]
						for _,name in pairs(sortedrebirth) do
							if ( spellIsCR(rebirth[name].rebirth.id) and rebirth[name].show and rebirth[name].rebirth.time == "Ready" and not UnitIsDeadOrGhost(name) --[[and UnitIsDeadOrGhost(unitname)]] ) then
								print(name, rebirth[name].rebirth.id, input)
								self:Request(name, rebirth[name].rebirth.id, input)
								break;
							end
						end
					end
			},
			checkgroup = {
				name = L["Check Group"],
				usage = L["Check GroupUsage"],
				desc = L["Check GroupDesc"],
				type = "input",
				guiHidden = true,
				set = function(info, input) self:CheckGroupStatus() end
			},
			debugme = {
				name = "Debug",
				usage = "Debug",
				desc = "Debug",
				type = "input",
				hidden = true,
				set = function(info, input) if (Debug) then self:Debug("Now shutting up"); Debug = false else Debug = true; self:Debug("Now displaying debug information") end end
			},
			requestinnervate = {
				name = "Request Innervate",
				desc = L["requestinnervatedesc"],
				type = "input",
				guiHidden = true,
				set = 	function(info, input)
							for _,name in pairs(sortedinnervate) do
								if ( innervate[name].innervate.id == SpellTemplate.innervate.id and innervate[name].show and innervate[name].innervate.time == "Ready" and not UnitIsDeadOrGhost(name) and not UnitIsDeadOrGhost("player") ) then
									self:Request(name, innervate[name].innervate.id, "player")
									break;
								end
							end
						end
			},
			general = {
				type = "group",
				name = L["General"],
				desc = L["GeneralDesc"],
				order = 4,
				args = {
					showheader = {
						name = L["Show..."],
						type = "header",
						order = 5,
					},
					--[[
					show = {
						name = L["Show"],
						desc = L["ShowDesc"],
						type = "toggle",
						order = 0,
						set = function(info,val) self.db.profile.show = val; self:Show(MasterWindow, val) end,
						get = function(info) return self.db.profile.show end,
					},]]
					showtarget = {
						name = L["ShowTarget"],
						desc = L["ShowTargetDesc"],
						type = "toggle",
						order = 10,
						set = function(info,val) self.db.profile.showtarget = val; self:ShowTarget(val); self:SetSize() end,
						get = function(info) return self.db.profile.showtarget end,
					},
					showservername = {
						name = L["Show server name"],
						desc = L["Show server nameDesc"],
						type = "toggle",
						order = 15,
						set = function(info,val) self.db.profile.showServerName = val; self:SetNames() end,
						get = function(info) return self.db.profile.showServerName end,
					},
					showextragroups = {
						name = L["Show extra"],
						desc = L["Show extraDesc"],
						type = "toggle",
						order = 20,
						set = function(info,val) self.db.profile.showExtraGroups = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showExtraGroups end,
					},
					showicon = {
						name = L["ShowIcon"],
						desc = L["ShowIconDesc"],
						type = "toggle",
						order = 25,
						set = function(info,val) self.db.profile.showicon = val; self:SetIcons() end,
						get = function(info) return self.db.profile.showicon end,
					},
					rebirth_window_show = {
						name = L["Show Rebirth Window"],
						desc = L["Show Rebirth WindowDesc"],
						type = "toggle",
						order = 30,
						set = function(info,val) self.db.profile.rebirthShow = val; self:Show(Window.rebirths, val) end,
						get = function(info) return self.db.profile.rebirthShow end,
					},
					innervate_window_show = {
						name = L["Show Innervate Window"],
						desc = L["Show Innervate WindowDesc"],
						type = "toggle",
						order = 35,
						set = function(info,val) self.db.profile.innervateShow = val; self:Show(Window.innervates, val) end,
						get = function(info) return self.db.profile.innervateShow end,
					},
					showspecsheader = {
						name = L["Show Specs"],
						type = "header",
						order = 36,
					},
					showbalance = {
						name = L["InBalance"],
						desc = L["InBalanceDesc"],
						type = "toggle",
						order = 37,
						set = function(info,val) self.db.profile.druid.balance = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.druid.balance end,
					},
					showferal = {
						name = L["InFeral"],
						desc = L["InFeralDesc"],
						type = "toggle",
						order = 38,
						set = function(info,val) self.db.profile.druid.feral = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.druid.feral end,
					},
					showresto = {
						name = L["InResto"],
						desc = L["InRestoDesc"],
						type = "toggle",
						order = 39,
						set = function(info,val) self.db.profile.druid.resto = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.druid.resto end,
					},
					showshaman = {
						name = L["InShaman"],
						desc = L["InShamanDesc"],
						type = "toggle",
						order = 39,
						set = function(info,val) self.db.profile.shaman = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.shaman end,
					},
					showpriest = {
						name = L["InPriest"],
						desc = L["InPriestDesc"],
						type = "toggle",
						order = 39,
						set = function(info,val) self.db.profile.priest = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.priest end,
					},
					mischeader = {
						name = L["Miscellaneous"],
						type = "header",
						order = 40,
					},
					sync = {
						name = L["Sync"],
						desc = L["SyncDesc"],
						type = "toggle",
						order = 45,
						set = function(info,val) self.db.profile.sync = val end,
						get = function(info) return self.db.profile.sync end,
					},
					verbose = {
						name = L["Verbose"],
						desc = L["VerboseDesc"],
						type = "toggle",
						order = 50,
						set = function(info,val) self.db.profile.verbose = val end,
						get = function(info) return self.db.profile.verbose end,
					},
					guess = {
						name = L["Guess"],
						type = "select",
						style = "radio",
						values = {
							mouseover = "Mouseover",
							target = "Target",
							none = "Don't guess",
						},
						set = function(info,val) self.db.profile.guess = val end,
						get = function(info) return self.db.profile.guess end,
					},

					--[[
				}
			},
			windows = {
				type = "group",
				name = L["Windows"],
				desc = L["WindowsDesc"],
				order = 5,
				args = {]]
					lock = {
						name = L["Lock"],
						desc = L["LockDesc"],
						type = "toggle",
						order = 55,
						set = function(info,val) self.db.profile.lock = val end,
						get = function(info) return self.db.profile.lock end,
					},
					scale = {
						name = L["Scale"],
						desc = L["ScaleDesc"],
						type = "range",
						min = 0.1,
						max = 2,
						bigStep = 0.05,
						isPercent = true,
						order = 60,
						set = function(info,val) self.db.profile.scale = val; self:SetScale() end,
						get = function(info) return self.db.profile.scale end,
					},
					colour_background = {
						name = L["Background Colour"],
						desc = L["Background ColourDesc"],
						type = "color",
						order = 65,
						hasAlpha = true,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.backgroundColour, r, g, b, a); self:SetBackground() end,
						get = function(info) return self:GetColour(self.db.profile.backgroundColour) end,
					},
				}
			},
			announcewhen = {
				type = "group",
				name = L["Announcements"],
				desc = L["AnnouncementsDesc"],
				order = 8,
				args = {
					announcewhen = {
						name = L["Announce when..."],
						type = "header",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 5,
					},
					castinginnervate = {
						name = L["AnnounceOnInnervate"],
						desc = L["AnnounceOnInnervateDesc"],
						type = "toggle",
						hidden = select(2,UnitClass("player")) ~= "DRUID",
						order = 10,
						set = function(info,val) self.db.profile.announceOnInnervate = val end,
						get = function(info) return self.db.profile.announceOnInnervate end,
					},
					castingrebirth = {
						name = L["AnnounceOnRebirth"],
						desc = L["AnnounceOnRebirthDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "DEATHKNIGHT" and class ~= "WARLOCK")
						end,
						order = 15,
						set = function(info,val) self.db.profile.announceOnRebirth = val end,
						get = function(info) return self.db.profile.announceOnRebirth end,
					},
					castingnormal = {
						name = L["AnnounceOnNormal"],
						desc = L["AnnounceOnNormalDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN")
						end,
						order = 20,
						set = function(info,val) self.db.profile.announceOnNormal = val end,
						get = function(info) return self.db.profile.announceOnNormal end,
					},
					castinginterrupted = {
						name = L["AnnounceOnInterrupt"],
						desc = L["AnnounceOnInterruptDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 21,
						set = function(info,val) self.db.profile.announceOnInterrupt = val end,
						get = function(info) return self.db.profile.announceOnInterrupt end,
					},
					castingonself = {
						name = L["AnnounceOnSelf"],
						desc = L["AnnounceOnSelfDesc"],
						type = "toggle",
						hidden = select(2,UnitClass("player")) ~= "DRUID",
						order = 22,
						set = function(info,val) self.db.profile.announceOnSelf = val end,
						get = function(info) return self.db.profile.announceOnSelf end,
					},
					castingmanatide = {
						name = L["AnnounceOnManaTide"],
						desc = L["AnnounceOnManaTideDesc"],
						type = "toggle",
						hidden = select(2,UnitClass("player")) ~= "SHAMAN",
						order = 23,
						set = function(info,val) self.db.profile.announceOnManaTide = val end,
						get = function(info) return self.db.profile.announceOnManaTide end,
					},
					castinghymn = {
						name = L["AnnounceOnHymn"],
						desc = L["AnnounceOnHymnDesc"],
						type = "toggle",
						hidden = select(2,UnitClass("player")) ~= "PRIEST",
						order = 24,
						set = function(info,val) self.db.profile.announceOnHymn = val end,
						get = function(info) return self.db.profile.announceOnHymn end,
					},
					announceto = {
						name = L["Announce to..."],
						type = "header",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 25,
					},
					tobg = {
						name = L["AnnounceToBG"],
						desc = L["AnnounceToBGDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 30,
						set = function(info,val) self.db.profile.announceToBG = val end,
						get = function(info) return self.db.profile.announceToBG end,
					},
					toraid = {
						name = L["AnnounceToRaid"],
						desc = L["AnnounceToRaidDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 35,
						set = function(info,val) self.db.profile.announceToRaid = val end,
						get = function(info) return self.db.profile.announceToRaid end,
					},
					toparty = {
						name = L["AnnounceToParty"],
						desc = L["AnnounceToPartyDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 40,
						set = function(info,val) self.db.profile.announceToParty = val end,
						get = function(info) return self.db.profile.announceToParty end,
					},
					totarget = {
						name = L["AnnounceToTarget"],
						desc = L["AnnounceToTargetDesc"],
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 45,
						set = function(info,val) self.db.profile.announceToTarget = val end,
						get = function(info) return self.db.profile.announceToTarget end,
					},
					facebook = {
						name = "Facebook",
						desc = "Guru meditation",
						type = "toggle",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 50,
						disabled = true,
						set = function(info,val) end,
						get = function(info) return true end,
					},
					channelname = {
						name = L["AnnounceToChannel"],
						desc = L["AnnounceToChannelDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						width = "full",
						order = 51,
						set = function(info,val) self.db.profile.announceToChannel = val end,
						get = function(info) return self.db.profile.announceToChannel end,
					},
					rebirthannouncement = {
						name = L["Announcements for Rebirth"],
						type = "header",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "WARLOCK")
						end,
						order = 55,
					},
					announcedesc = {
						order = 57,
						name = L["AnnouncementstringDesc"],
						type = "description",
					},
					rebirthwhisper = {
						name = L["RebirthWhisper"],
						desc = L["RebirthWhisperDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "WARLOCK")
						end,
						width = "full",
						order = 60,
						set = function(info,val) self.db.profile.rebirthWhisper = val end,
						get = function(info) return self.db.profile.rebirthWhisper end,
					},
					rebirthgroup = {
						name = L["RebirthGroup"],
						desc = L["RebirthGroupDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DEATHKNIGHT" and class ~= "DRUID" and class ~= "WARLOCK")
						end,
						width = "full",
						order = 65,
						set = function(info,val) self.db.profile.rebirthGroup = val end,
						get = function(info) return self.db.profile.rebirthGroup end,
					},
					innervateannouncements = {
						name = L["Announcements for Innervate"],
						type = "header",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID")
						end,
						order = 70,
					},
					innervatewhisper = {
						name = L["InnervateWhisper"],
						desc = L["InnervateWhisperDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID")
						end,
						width = "full",
						order = 75,
						set = function(info,val) self.db.profile.innervateWhisper = val end,
						get = function(info) return self.db.profile.innervateWhisper end,
					},
					innervategroup = {
						name = L["InnervateGroup"],
						desc = L["InnervateGroupDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID")
						end,
						width = "full",
						order = 80,
						set = function(info,val) self.db.profile.innervateGroup = val end,
						get = function(info) return self.db.profile.innervateGroup end,
					},
					normalannouncements = {
						name = L["Announcements for Normal"],
						type = "header",
						order = 85,
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN")
						end,
					},
					normalwhisper = {
						name = L["NormalWhisper"],
						desc = L["NormalWhisperDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN")
						end,
						width = "full",
						order = 90,
						set = function(info,val) self.db.profile.normalWhisper = val end,
						get = function(info) return self.db.profile.normalWhisper end,
					},
					normalgroup = {
						name = L["NormalGroup"],
						desc = L["NormalGroupDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN")
						end,
						width = "full",
						order = 95,
						set = function(info,val) self.db.profile.normalGroup = val end,
						get = function(info) return self.db.profile.normalGroup end,
					},
					otherannouncements = {
						name = L["OtherAnnouncements"],
						type = "header",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						order = 96,
					},
					interruptgroup = {
						name = L["InterruptGroup"],
						desc = L["InterruptGroupDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "DRUID" and class ~= "SHAMAN" and class ~= "PRIEST" and class ~= "PALADIN" and class ~= "WARLOCK")
						end,
						width = "full",
						order = 97,
						set = function(info,val) self.db.profile.interruptGroup = val end,
						get = function(info) return self.db.profile.interruptGroup end,
					},
					manatidegroup = {
						name = L["ManaTideGroup"],
						desc = L["ManaTideGroupDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "SHAMAN")
						end,
						width = "full",
						order = 98,
						set = function(info,val) self.db.profile.manatideGroup = val end,
						get = function(info) return self.db.profile.manatideGroup end,
					},
					hymngroup = {
						name = L["HymnGroup"],
						desc = L["HymnGroupDesc"],
						type = "input",
						hidden = function()
							class = select(2,UnitClass("player"))
							return (class ~= "PRIEST")
						end,
						width = "full",
						order = 99,
						set = function(info,val) self.db.profile.hymnGroup = val end,
						get = function(info) return self.db.profile.hymnGroup end,
					},
					requestannouncements = {
						name = L["Requests"],
						type = "header",
						order = 100,
					},
					innervaterequest = {
						name = L["InnervateRequest"],
						desc = L["InnervateRequestDesc"],
						type = "input",
						width = "full",
						order = 105,
						set = function(info,val) self.db.profile.innervateRequest = val end,
						get = function(info) return self.db.profile.innervateRequest end,
					},
					innervatexrequest = {
						name = L["InnervateXRequest"],
						desc = L["InnervateXRequestDesc"],
						type = "input",
						width = "full",
						order = 106,
						set = function(info,val) self.db.profile.innervatexRequest = val end,
						get = function(info) return self.db.profile.innervatexRequest end,
					},
					manatiderequest = {
						name = L["ManaTideRequest"],
						desc = L["ManaTideRequestDesc"],
						type = "input",
						width = "full",
						order = 110,
						set = function(info,val) self.db.profile.manatideRequest = val end,
						get = function(info) return self.db.profile.manatideRequest end,
					},
					hymnrequest = {
						name = L["HymnRequest"],
						desc = L["HymnRequestDesc"],
						type = "input",
						width = "full",
						order = 115,
						set = function(info,val) self.db.profile.hymnRequest = val end,
						get = function(info) return self.db.profile.hymnRequest end,
					},
					rebirthrequest = {
						name = L["RebirthRequest"],
						desc = L["RebirthRequestDesc"],
						type = "input",
						width = "full",
						order = 120,
						set = function(info,val) self.db.profile.rebirthRequest = val end,
						get = function(info) return self.db.profile.rebirthRequest end,
					},
					rebirthonxrequest = {
						name = L["RebirthOnXRequest"],
						desc = L["RebirthOnXRequestDesc"],
						type = "input",
						width = "full",
						order = 125,
						set = function(info,val) self.db.profile.rebirthonxRequest = val end,
						get = function(info) return self.db.profile.rebirthonxRequest end,
					},
				},
			},
			showwhen = {
				type = "group",
				name = L["Show when..."],
				desc = L["Show when...Desc"],
				order = 10,
				args = {
					autoshow = {
						name = L["Auto show"],
						desc = L["Auto showDesc"],
						type = "toggle",
						order = 0,
						set = function(info,val) self.db.profile.autoshow = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.autoshow end,
					},
					showwhen = {
						name = L["Show when..."],
						type = "header",
						order = 2,
					},
					inbg = {
						name = L["ShowInBG"],
						desc = L["ShowInBGDesc"],
						type = "toggle",
						order = 5,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showInBG = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showInBG end,
					},
					inraid = {
						name = L["ShowInRaid"],
						desc = L["ShowInRaidDesc"],
						type = "toggle",
						order = 10,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showInRaid = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showInRaid end,
					},
					inparty = {
						name = L["ShowInParty"],
						desc = L["ShowInPartyDesc"],
						type = "toggle",
						order = 15,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showInParty = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showInParty end,
					},
					solo = {
						name = L["ShowWhenSolo"],
						desc = L["ShowWhenSoloDesc"],
						type = "toggle",
						order = 20,
						disabled = function(info) return not self.db.profile.autoshow end,
						set = function(info,val) self.db.profile.showWhenSolo = val; self:CheckGroupStatus() end,
						get = function(info) return self.db.profile.showWhenSolo end,
					},
				},
			},
			bar = {
				type = "group",
				name = L["Bars"],
				desc = L["BarsDesc"],
				order = 15,
				args = {
					growup = {
						name = L["GrowUp"],
						desc = L["GrowUpDesc"],
						type = "toggle",
						order = 19,
						set = function(info,val) self.db.profile.bar.growUp = val; self:UpdateBars(); self:ChangeGrowDir() end,
						get = function(info) return self.db.profile.bar.growUp end,
					},
					allowclick = {
						name = L["AllowClick"],
						desc = L["AllowClickDesc"],
						type = "toggle",
						order = 20,
						set = function(info,val) self.db.profile.bar.allowClick = val end,
						get = function(info) return self.db.profile.bar.allowClick end,
					},
					allowscroll = {
						name = L["AllowScroll"],
						desc = L["AllowScrollDesc"],
						type = "toggle",
						order = 21,
						set = function(info,val) self.db.profile.bar.allowScroll = val end,
						get = function(info) return self.db.profile.bar.allowScroll end,
					},
					hideoncd = {
						name = L["HideOnCD"],
						desc = L["HideOnCDDesc"],
						type = "toggle",
						order = 22,
						set = function(info,val) self.db.profile.bar.hideOnCD = val; self:UpdateBars() end,
						get = function(info) return self.db.profile.bar.hideOnCD end,
					},
					colour_useclass = {
						name = L["UseClassColours"],
						desc = L["UseClassColoursDesc"],
						type = "toggle",
						order = 23,
						set = function(info,val) self.db.profile.bar.useClassColour = val; self:SetColours() end,
						get = function(info) return self.db.profile.bar.useClassColour end,
					},
					colour_ready = {
						name = L["Ready Colour"],
						desc = L["Ready ColourDesc"],
						type = "color",
						order = 25,
						disabled = function() return self.db.profile.bar.useClassColour end,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.readyColour, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.readyColour) end,
					},
					colour_userange = {
						name = L["UseRangeColours"],
						desc = L["UseRangeColoursDesc"],
						type = "toggle",
						order = 26,
						set = function(info,val) self.db.profile.bar.useRangeRecolor = val; self:SetColours() end,
						get = function(info) return self.db.profile.bar.useRangeRecolor end,
					},
					colour_range = {
						name = L["Range Colour"],
						desc = L["Range ColourDesc"],
						type = "color",
						order = 27,
						disabled = function() return not self.db.profile.bar.useRangeRecolor end,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.RangeColor, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.RangeColor) end,
					},
					colour_cooldown = {
						name = L["Cooldown Colour"],
						desc = L["Cooldown ColourDesc"],
						type = "color",
						order = 28,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.cooldownColour, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.cooldownColour) end,
					},
					colour_dead = {
						name = L["Dead Colour"],
						desc = L["Dead ColourDesc"],
						type = "color",
						order = 29,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.bar.deadColour, r, g, b, a); self:SetBackground(); self:SetColours() end,
						get = function(info) return self:GetColour(self.db.profile.bar.deadColour) end,
					},
					alpha = {
						name = L["Opacity"],
						desc = L["OpacityDesc"],
						type = "range",
						min = 0,
						max = 1,
						bigStep = 0.05,
						order = 30,
						isPercent = true,
						set = function(info,val) self.db.profile.bar.opacity = val; self:SetBackground(); self:SetColours() end,
						get = function(info) return self.db.profile.bar.opacity end,
					},
					width = {
						name = L["Width"],
						desc = L["WidthDesc"],
						type = "range",
						min = 100,
						max = 500,
						bigStep = 5,
						order = 40,
						set = function(info,val) self.db.profile.bar.width = val; self:SetSize() end,
						get = function(info) return self.db.profile.bar.width end,
					},
					height = {
						name = L["Height"],
						desc = L["HeightDesc"],
						type = "range",
						min = 5,
						max = 50,
						bigStep = 1,
						order = 46,
						set = function(info,val) self.db.profile.bar.height = val; self:SetSize()  end,
						get = function(info) return self.db.profile.bar.height end,
					},
					spacing = {
						name = L["Spacing"],
						desc = L["SpacingDesc"],
						type = "range",
						min = 0,
						max = 10,
						bigStep = 1,
						order = 47,
						set = function(info,val) self.db.profile.bar.spacing = val; self:SetSize()  end,
						get = function(info) return self.db.profile.bar.spacing end,
					},
					bar_texture = {
						name = L["Texture"],
						desc = L["TextureDesc"],
						type = "select",
						--values = SM:List("statusbar");

						values = SM:HashTable("statusbar"),
						dialogControl = 'LSM30_Statusbar',

						style = "dropdown",
						order = 49,
						set = function(info,val) self.db.profile.bar.texture = val; self.db.profile.bar.texturePath = SM:Fetch("statusbar", self.db.profile.bar.texture); self:SetBackground() end,
						get = function(info) return self.db.profile.bar.texture end,
					},
				}
			},
			font = {
				type = "group",
				name = L["Fonts"],
				desc = L["FontsDesc"],
				order = 20,
				args = {
					font_name_colour = {
						name = L["Name Font Colour"],
						desc = L["Name Font ColourDesc"],
						type = "color",
						order = 55,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.nameColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.nameColour) end,
					},
					font_time_colour = {
						name = L["Time Font Colour"],
						desc = L["Time Font ColourDesc"],
						type = "color",
						order = 65,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.timeColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.timeColour) end,
					},
					font_target_colour = {
						name = L["Target Font Colour"],
						desc = L["Target Font ColourDesc"],
						type = "color",
						order = 72,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.targetColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.targetColour) end,
					},
					font_title_colour = {
						name = L["Title Font Colour"],
						desc = L["Title Font ColourDesc"],
						type = "color",
						order = 74,
						set = function(info, r, g, b, a) self:SetColour(self.db.profile.font.titleColour, r, g, b, a); self:SetFonts() end,
						get = function(info) return self:GetColour(self.db.profile.font.titleColour) end,
					},
					font_name_size = {
						name = L["Name Font Size"],
						desc = L["Name Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 60,
						set = function(info,val) self.db.profile.font.nameSize = val; self:SetFonts(); self:SetSize() end,
						get = function(info) return self.db.profile.font.nameSize end,
					},
					font_time_size = {
						name = L["Time Font Size"],
						desc = L["Time Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 70,
						set = function(info,val) self.db.profile.font.timeSize = val; self:SetFonts(); self:SetSize() end,
						get = function(info) return self.db.profile.font.timeSize end,
					},
					font_target_size = {
						name = L["Target Font Size"],
						desc = L["Target Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 73,
						set = function(info,val) self.db.profile.font.targetSize = val; self:SetFonts(); self:SetSize() end,
						get = function(info) return self.db.profile.font.targetSize end,
					},
					font_title_size = {
						name = L["Title Font Size"],
						desc = L["Title Font SizeDesc"],
						type = "range",
						min = 6,
						max = 20,
						bigStep = 1,
						order = 75,
						set = function(info,val) self.db.profile.font.titleSize = val; self:SetFonts(); self:SetSize(); self:SetSize() end,
						get = function(info) return self.db.profile.font.titleSize end,
					},
					font_file = {
						name = L["Font"],
						desc = L["FontDesc"],
						type = "select",
						--values = {"Font1", "Font2"},
						--values = SM:List("font");

						values = SM:HashTable("font"),
						dialogControl = 'LSM30_Font',

						style = "dropdown",
						order = 80,
						set = function(info,val) self.db.profile.font.file = val; self.db.profile.font.filePath = SM:Fetch("font", self.db.profile.font.file); self:SetFonts() end,
						get = function(info) return self.db.profile.font.file  end,
					},
				},
			},
			output = self:GetSinkOptionsDataTable()
		},
	}
end

function Rebirther:GetSinkOptionsDataTable()
	local ta = self:GetSinkAce3OptionsDataTable()
	ta.name =  L["Incoming Requests"]
	ta.args.sink_color_header = {
		name = L["Incoming Requests Colour"],
		type = "header",
		order = 1,
	}
	ta.args.sink_color = {
		name = L["Incoming Requests Colour"],
		desc = L["IncRequestColourDesc"],
		type = "color",
		order = 5,
		set = function(info, r, g, b) self:SetColour(self.db.profile.sinkColour, r, g, b) end,
		get = function(info) return self:GetColour(self.db.profile.sinkColour) end,
	}
	ta.args.sink_output_header = {
		name = L["Output"],
		type = "header",
		order = 10,
	}
	return ta
end





-- Other kinds of events

function Rebirther:OnUpdate(handle, elapsed)

	LastUpdate = LastUpdate + elapsed
	lastFrequentUpdate = lastFrequentUpdate + elapsed
	if lastFrequentUpdate > frequentUpdateInterval then
		-- this needs more frequent update than 1 sec -- currently 0.2 sec
		if UnitExists("mouseover") then
			self:TargetChange("UPDATE_MOUSEOVER_UNIT")
		elseif UnitExists("target") then
			self:TargetChange("PLAYER_TARGET_CHANGED")
		end
		lastFrequentUpdate = 0
	end
	if ( LastUpdate > UpdateInterval ) then
		if ( MustUpdateNames ) then
			self:SetNames()
			MustUpdateNames = false
		end
		LastUpdate = 0
		if ( RosterUpdate ) then
		self:Debug("RosterUpdate Event TRUE")
			self:CheckGroupStatus()
		end

		if IsEncounterInProgress() then
			lastEncounterInProgress = GetTime()
		end

		newtime = GetTime()
		needtoupdatebars = false
		for _,val in pairs(sortedinnervate) do
			val = innervate[val]
			if val.innervate.time ~= "Ready" then
				if newtime - val.innervate.time >= val.innervate.cooldown and val.show then
					needtoupdatebars = true
				end
			end
			-- Check for a talent spec
			if (val.innervate.id == SpellTemplate.innervate.id or val.innervate.id == SpellTemplate.manatide.id) and val.spec == 0 and CheckInteractDistance(val.name,1) then
				NotifyInspect(val.name)
			end
		end
		for _,val in pairs(rebirth) do
			if val.rebirth.time ~= "Ready" then
				if newtime - val.rebirth.time >= val.rebirth.cooldown and val.show then
					needtoupdatebars = true
				end
			end
		end
		if needtoupdatebars then
			self:UpdateBars()
		end

		if ( not testmode ) then
			for _,val in pairs(rebirth) do
				if ( val.show ) then
					if ( UnitIsConnected(val.name) and not UnitIsDeadOrGhost(val.name) and not val.alive ) then
						self:SetPlayerAlive(val.name, true)
					elseif ( not UnitIsConnected(val.name) and val.alive ) then
						self:SetPlayerAlive(val.name, false, true)
					elseif ( UnitIsDeadOrGhost(val.name) and val.alive ) then
						self:SetPlayerAlive(val.name, false)
					end
				end
			end
			for _,val in pairs(innervate) do
				if ( val.show ) then
					if ( UnitIsConnected(val.name) and not UnitIsDeadOrGhost(val.name) and not val.alive ) then
						self:SetPlayerAlive(val.name, true)
					elseif ( not UnitIsConnected(val.name) and val.alive ) then
						self:SetPlayerAlive(val.name, false, true)
					elseif ( UnitIsDeadOrGhost(val.name) and val.alive ) then
						self:SetPlayerAlive(val.name, false)
					end
				end
			end
		end
	end
end

function Rebirther:OnEnable()

	self:RegisterEvent("MAIL_CLOSED", "GroupChanged")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "GroupChanged")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "GroupChanged")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PARTY_MEMBER_DISABLE", "GroupChanged") --Add LB
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "GroupChanged")
	self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND", "GroupChanged")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "GroupChanged")
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "GroupChanged")
	self:RegisterEvent("INSPECT_READY")
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "TargetChange")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "TargetChange")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChange")
	self:RegisterEvent("INCOMING_RESURRECT_CHANGED")


	self:SetSize()
	self:SetScale()
	self:SetBackground()
	self:SetIcons()
	self:ChangeGrowDir()

	self:RegisterComm(AddonCommPrefix)

	self:HookScript(SuperWindow, "OnUpdate")

	self:Show(Window.rebirths, self.db.profile.rebirthShow)
	self:Show(Window.innervates, self.db.profile.innervateShow)
	self:Show(MasterWindow, self.db.profile.show)
end

function Rebirther:OnDisable()
	self:UnregisterEvent("MAIL_CLOSED", "GroupChanged")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE", "GroupChanged")
	self:UnregisterEvent("PARTY_MEMBER_DISABLE", "GroupChanged") --Add LB
	self:UnregisterEvent("PLAYER_TALENT_UPDATE")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PARTY_MEMBERS_CHANGED", "GroupChanged")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE", "GroupChanged")
	self:UnregisterEvent("PLAYER_ENTERING_BATTLEGROUND", "GroupChanged")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD", "GroupChanged")
	self:UnregisterEvent("PLAYER_DIFFICULTY_CHANGED", "GroupChanged")
	self:UnregisterEvent("INSPECT_READY")
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED", "TargetChange")
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT", "TargetChange")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChange")
	self:UnregisterEvent("INCOMING_RESURRECT_CHANGED")

	self:Show(Window.rebirths, false)
	self:Show(Window.innervates, false)
	self:Show(MasterWindow, false)
end
function Rebirther:ProfileChanged()
	self:SetFonts()
	self:SetSize()
	self:SetScale()
	self:SetBackground()
	self:SetIcons()
	self:SetNames()
	self:SetColours()
	self:CheckGroupStatus()
end
function Rebirther:ChatCommand(input)
    if ( not input or input:trim() == "" ) then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(Rebirther, "Rebirther", "Rebirther", input)
    end
end
function Rebirther:OnInitialize()	-- This function is run when the ADDON_LOADED event is fired
	local AddonDefaults = self:GetDefaults()
	self.db = LibStub("AceDB-3.0"):New(AddonDBName, AddonDefaults, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
	local AddonOptions = self:GetOptions()
	AddonOptions.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	--LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, AddonOptions, AddonSlash)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, AddonOptions)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(AddonName)
	for _,cmd in pairs(AddonSlash) do
		self:RegisterChatCommand(cmd, "ChatCommand")
	end
	self:SetSinkStorage(self.db.profile)
	--[[
	if ( not SuperWindow ) then
		SuperWindow = CreateFrame("FRAME", "SUPERWINDOW", UIParent, "ParentFrameTemplate")
	end
	if ( not MasterWindow ) then
		MasterWindow = CreateFrame("FRAME", AddonName, MasterWindow, "ParentFrameTemplate")
	end]]

	SuperWindow = CreateFrame("FRAME", "SUPERWINDOW", UIParent, "ParentFrameTemplate")
	MasterWindow = CreateFrame("FRAME", AddonName, SuperWindow, "ParentFrameTemplate")

	self:SetFonts()

	--[[
	if ( not Window.rebirths ) then
		Window.rebirths = self:CreateWindow(L["Rebirths"], "Interface\\ICONS\\Spell_Nature_Reincarnation")
	end
	if ( not Window.innervates ) then
		Window.innervates = self:CreateWindow(L["Innervates"], "Interface\\ICONS\\Spell_Nature_Lightning")
	end]]


	Window.rebirths = self:CreateWindow("Rebirths", "Interface\\ICONS\\Spell_Nature_Reincarnation", L["Battle Resses"])
	Window.innervates = self:CreateWindow("Innervates", "Interface\\ICONS\\Spell_Nature_Lightning", L["Mana CDs"])

	Window.rebirths:ClearAllPoints()
	Window.rebirths:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.rebirthCoord.x, self.db.profile.rebirthCoord.y)
	Window.innervates:ClearAllPoints()
	Window.innervates:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.db.profile.innervateCoord.x, self.db.profile.innervateCoord.y)

	--Window.rebirths:SetMovable(true)
	--[[
	SuperWindow = CreateFrame("FRAME", "SUPERWINDOW", UIParent, "ParentFrameTemplate")
	MasterWindow = CreateFrame("FRAME", AddonName, MasterWindow, "ParentFrameTemplate")
	self:SetFonts()
	Window.rebirths = self:CreateWindow(L["Rebirths"], "Interface\\ICONS\\Spell_Nature_Reincarnation")
	Window.innervates = self:CreateWindow(L["Innervates"], "Interface\\ICONS\\Spell_Nature_Lightning")
	self:SetSize()
	self:SetScale()
	self:SetBackground()
	self:SetIcons()
	]]

	ClassColour = Rebirther:GetLocalizedClassesWithColours()
end

