--[[
	Copyright (c) 2013 Bastien Clément

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local GridRoster = Grid:GetModule("GridRoster")
local GridStatus = Grid:GetModule("GridStatus")

local GridStatusAncientBarrier = GridStatus:NewModule("GridStatusAncientBarrier")

local SPELL_SHIELD_LOW    = GetSpellInfo(142863)
local SPELL_SHIELD_MEDIUM = GetSpellInfo(142864)
local SPELL_SHIELD_FULL   = GetSpellInfo(142865)

GridStatusAncientBarrier.defaultDB = {
	unit_ancient_barrier = {
		color = { r = 0.84, g = 0.32, b = 0, a = 1.0 },
		colorFull = { r = 0.42, g = 0.76, b = 0.11, a = 1.0 },
		text = "Ancien Barrier",
		enable = true,
		priority = 30,
		range = false,
		shortText = true,
		percAsStack = true
	}
}

GridStatusAncientBarrier.menuName = "Malkorok: Ancient Barrier"
GridStatusAncientBarrier.options = false

local settings
local tracking = false
local unitHasShield = {}

local MalkorokShields_options = {
	["break1"] = {
		type = "description",
		order = 80,
		name = "",
	},
	["color"] = {
		type = "color",
		name = "Color 1",
		desc = "Color when the shield is not fully stacked",
		hasAlpha = true,
		order = 81,
		get = function ()
			local color = settings.color
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = settings.color
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["colorFull"] = {
		type = "color",
		name = "Color 2",
		desc = "Color once the shield is fully stacked.",
		hasAlpha = true,
		order = 82,
		get = function ()
			local color = settings.colorFull
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = settings.colorFull
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["break2"] = {
		type = "description",
		order = 90,
		name = "",
	},
	["shortText"] = {
		type = "toggle",
		name = "Short text",
		desc = "Displays 1250 as 1.2k",
		order = 91,
		get = function()
			return settings.shortText
		end,
		set = function(_, v)
			settings.shortText = v
			GridStatusAncientBarrier:UpdateAllUnits()
		end,
	},
	["percAsStack"] = {
		type = "toggle",
		name = "Percent as stacks",
		desc = "Displays shield percent as stacks (like Sanity on Yogg-Saron)",
		order = 92,
		get = function()
			return settings.percAsStack
		end,
		set = function(_, v)
			settings.percAsStack = v
			GridStatusAncientBarrier:UpdateAllUnits()
		end,
	},
	["opacity"] = false
}

function GridStatusAncientBarrier:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("unit_ancient_barrier", "Malkorok: Ancient Barrier", MalkorokShields_options, true)
	settings = self.db.profile.unit_ancient_barrier
end

function GridStatusAncientBarrier:OnStatusEnable(status)
	if status == "unit_ancient_barrier" then
		self:RegisterEvent("ZONE_CHANGED", "UpdateTracking")
		self:RegisterEvent("ZONE_CHANGED_INDOORS", "UpdateTracking")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateTracking")
		self:UpdateTracking()
	end
end

function GridStatusAncientBarrier:OnStatusDisable(status)
	if status == "unit_ancient_barrier" then
		self:Reset()
		self:UnregisterEvent("ZONE_CHANGED")
		self:UnregisterEvent("ZONE_CHANGED_INDOORS")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end
end

function GridStatusAncientBarrier:Reset()
	self.super.Reset(self)
	
	for guid, unitid in GridRoster:IterateRoster() do
		self.core:SendStatusLost(guid, "unit_ancient_barrier")
	end
	
	self:UnregisterMessage("Grid_RosterUpdated")
	self:UnregisterEvent("UNIT_MAXHEALTH")
	self:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	tracking = false
	
	unitHasShield = {}
end

function GridStatusAncientBarrier:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnitShield(unitid)
	end
end

function GridStatusAncientBarrier:UpdateTracking()
	local should_track = (GetMapInfo() == "OrgrimmarRaid")
	if should_track ~= tracking then
		if tracking then
			-- Ends tracking
			--print("Malkorok Shield: stop tracking")
			self:Reset()
		else
			-- Start tracking
			--print("Malkorok Shield: start tracking")
			self:RegisterMessage("Grid_RosterUpdated", "UpdateAllUnits")
			self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
			self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED", "UpdateUnit")
			self:UpdateAllUnits()
		end
		tracking = should_track
	end
end

function GridStatusAncientBarrier:UpdateUnit(_, unitid)
	self:UpdateUnitShield(unitid)
end

function GridStatusAncientBarrier:UpdateUnitShield(unitid)
	local shield = select(15, UnitDebuff(unitid, SPELL_SHIELD_LOW)) or select(15, UnitDebuff(unitid, SPELL_SHIELD_MEDIUM)) or select(15, UnitDebuff(unitid, SPELL_SHIELD_FULL))
	local guid = UnitGUID(unitid)
	
	if not shield then
		if unitHasShield[guid] then
			unitHasShield[guid] = nil
			self.core:SendStatusLost(guid, "unit_ancient_barrier")
		end
		return
	elseif not unitHasShield[guid] then
		unitHasShield[guid] = true
	end
	
	local shieldFull = UnitDebuff(unitid, SPELL_SHIELD_FULL)
	local maxShield = UnitHealthMax(unitid)

	self.core:SendStatusGained(
		guid,
		"unit_ancient_barrier",
		settings.priority,
		nil,
		shieldFull and settings.colorFull or settings.color,
		(shield > 999 and settings.shortText) and string.format("%.1fk", shield / 1000) or tostring(shield),
		shield,
		maxShield,
		shieldFull and "Interface\\Icons\\ability_malkorok_blightofyshaarj_red" or "Interface\\Icons\\ability_malkorok_blightofyshaarj_green",
		nil,
		nil,
		settings.percAsStack and (shieldFull and 100 or (math.floor((shield / maxShield) * 99) + 1)) or nil
	)
end
