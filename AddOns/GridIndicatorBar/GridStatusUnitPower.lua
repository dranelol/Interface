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

local GridStatusUnitPower = GridStatus:NewModule("GridStatusUnitPower")

local powerTypes = {
	[SPELL_POWER_MANA] = "Mana",
	[SPELL_POWER_RAGE] = "Rage",
	[SPELL_POWER_FOCUS] = "Focus",
	[SPELL_POWER_ENERGY] = "Energy",
	[SPELL_POWER_RUNIC_POWER] = "Runic Power"
}

GridStatusUnitPower.defaultDB = {
	unit_power = {
		enable = true,
		range = false,
		priority = 30,
		color = { r = 1, g = 1, b = 1, a = 1 },
		ignorePets = false,
		types = {
			[SPELL_POWER_MANA] = {
				enable = true,
				color = { r = 0.00, g = 0.50, b = 1.00, a = 1 }
			},
			[SPELL_POWER_RAGE] = {
				enable = true,
				color = { r = 1.00, g = 0.10, b = 0.10, a = 1 }
			},
			[SPELL_POWER_FOCUS] = {
				enable = true,
				color = { r = 1.00, g = 0.50, b = 0.25, a = 1 }
			},
			[SPELL_POWER_ENERGY] = {
				enable = true,
				color = { r = 1.00, g = 1.00, b = 0.00, a = 1 }
			},
			[SPELL_POWER_RUNIC_POWER] = {
				enable = true,
				color = { r = 0.00, g = 0.82, b = 1.00, a = 1 }
			},
		}
	}
}

GridStatusUnitPower.menuName = "Unit Power"
GridStatusUnitPower.options = false

local settings

local UnitPower_options = {
	["color"] = false,
	["ignorePets"] = {
		type = "toggle",
		name = "Ignore pets",
		desc = "Ignore pets power",
		order = 10,
		get = function()
			return settings.ignorePets
		end,
		set = function(_, v)
			settings.ignorePets = v
			GridStatusUnitPower:UpdateAllUnits()
		end,
	},
	["opacity"] = false,
}

local i = 100
for powerT, powerN in pairs(powerTypes) do
	UnitPower_options[powerN] = {
		type = "group",
		name = powerN,
		inline = true,
		order = i,
		args = {
			["enable"] = {
				type = "toggle",
				name = "Enable",
				desc = "Enable " .. powerN .. " tracking",
				order = 1,
				get = function()
					return settings.types[powerT].enable
				end,
				set = function(_, v)
					settings.types[powerT].enable = v
					GridStatusUnitPower:UpdateAllUnits()
				end,
			},
			["color"] = {
				type = "color",
				name = "Color",
				desc = powerN .. " color",
				order = 2,
				hasAlpha = true,
				disabled = function() return not settings.types[powerT].enable end,
				get = function()
					local color = settings.types[powerT].color
					return color.r, color.g, color.b, color.a
				end,
				set = function(_, r, g, b, a)
					settings.types[powerT].color = { r = r, g = g, b = b, a = a }
					GridStatusUnitPower:UpdateAllUnits()
				end,
			},
		}
	}
	i = i + 1
end

function GridStatusUnitPower:OnInitialize()
	self.super.OnInitialize(self)
	self:RegisterStatus("unit_power", "Unit Power", UnitPower_options, true)
	settings = self.db.profile.unit_power
end

function GridStatusUnitPower:OnStatusEnable(status)
	if status == "unit_power" then
		self:RegisterMessage("Grid_RosterUpdated")
		self:RegisterEvent("UNIT_DISPLAYPOWER", "UpdateUnit")
		self:RegisterEvent("UNIT_MAXPOWER", "UpdateUnit")
		self:RegisterEvent("UNIT_POWER", "UpdateUnit")
		self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UpdateUnit") -- Hack to catch range changes
		self:UpdateAllUnits()
	end
end

function GridStatusUnitPower:OnStatusDisable(status)
	if status == "unit_power" then
		for guid, unitid in GridRoster:IterateRoster() do
			self.core:SendStatusLost(guid, "unit_power")
		end
		self:UnregisterMessage("Grid_RosterUpdated")
		self:UnregisterEvent("UNIT_DISPLAYPOWER", "UpdateUnit")
		self:UnregisterEvent("UNIT_MAXPOWER", "UpdateUnit")
		self:UnregisterEvent("UNIT_POWER", "UpdateUnit")
		self:UnregisterEvent("UNIT_PORTRAIT_UPDATE", "UpdateUnit")
	end
end

function GridStatusUnitPower:Reset()
	self.super.Reset(self)
	self:UpdateAllUnits()
end

function GridStatusUnitPower:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnitPower(unitid)
	end
end

function GridStatusUnitPower:Grid_RosterUpdated()
	self:UpdateAllUnits()
end

function GridStatusUnitPower:UpdateUnit(_, unitid)
	self:UpdateUnitPower(unitid)
end

function GridStatusUnitPower:UpdateUnitPower(unitid)
	if not unitid then return end
	
	local guid = UnitGUID(unitid)
	if not guid then return end
	
	local powerType = UnitPowerType(unitid)
	local powerSettings = settings.types[powerType]
	
	if powerSettings and powerSettings.enable and (UnitIsPlayer(unitid) or not settings.ignorePets) then
		local power, powerMax = UnitPower(unitid), UnitPowerMax(unitid)
		self.core:SendStatusGained(
			guid,
			"unit_power",
			(power == powerMax and 1 or settings.priority),
			nil,
			powerSettings.color,
			tostring(power),
			power,
			powerMax,
			nil
		)
	else
		self.core:SendStatusLost(guid, "unit_power")
	end
end
