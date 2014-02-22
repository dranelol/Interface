------------------------------------------------------------------------------
-- GridStatusTankCooldown by Slaren
------------------------------------------------------------------------------
GridStatusTankCooldown = Grid:GetModule("GridStatus"):NewModule("GridStatusTankCooldown")
GridStatusTankCooldown.menuName = "Tanking cooldowns"

local tankingbuffs = {
	["DEATHKNIGHT"] = {
		48707, -- Anti-Magic Shell
		50461, -- Anti-Magic Zone
		42650, -- Army of the Dead
		77535, -- Blood Shield		
		49222, -- Bone Shield
		49028, -- Dancing Rune Weapon
		48792, -- Icebound Fortitude
		55233, -- Vampiric Blood
		105588, -- Vampiric Brood (tier bonus)
	},
	["DRUID"] = {
		22812,  -- Barkskin
		124769, -- Glyph of Frenzied Regeneration
		102342, -- Ironbark
		105737, -- Mass Regeneration (tier bonus)
		132402, -- Savage Defense
		61336,  -- Survival Instincts
	},
	["HUNTER"] = {
		19263,  -- Deterrence
		63087,  -- Glyph of Raptor Strike
	},
	["MAGE"] = {
		45438,  -- Ice Block
		11426,  -- Ice Barrier
		1463,   -- Incanter's Ward
		115610, -- Temporal Shield
	},
	["MONK"] = {
		115213, -- Avert Harm
		122278, -- Dampen Harm
		122783, -- Diffuse Magic
		115308, -- Elusive Brew
		115203, -- Fortifying Brew
		115295, -- Guard
		116849, -- Life Cocoon
		115176, -- Zen Meditation
	},
	["PALADIN"] = {
		31850,  -- Ardent Defender
		31821,  -- Devotion Aura
		498,    -- Divine Protection
		642,    -- Divine Shield
		86659,  -- Guardian of Ancient Kings
		1022,   -- Hand of Protection
		114039, -- Hand of Purity
		6940,   -- Hand of Sacrifice
		20925,  -- Holy Shield
		132403, -- Shield of the Righteous
	},
	["PRIEST"] = {
		47585,  -- Dispersion
		47788,  -- Guardian Spirit
		33206,  -- Pain Suppression
		81782,  -- Power Word: Barrier
	},
	["ROGUE"] = {
		31224,  -- Cloak of Shadows
		5277,   -- Evasion
		1966,   -- Feint
		76577,  -- Smoke Bomb
	},
	["SHAMAN"] = {
		108271, -- Astral Shift
		30823,  -- Shamanistic Rage
		98008,  -- Spirit Link Totem
		114893, -- Stone Bulwark Totem
	},
	["WARLOCK"] = {
		110913, -- Dark Bargain        
		108359, -- Dark Regeneration
		91711,  -- Nether Ward
		108416, -- Sacrificial Pact
		6229,   -- Shadow Ward
		104773, -- Unending Resolve
	},
	["WARRIOR"] = {
		118038, -- Die by the Sword
		12975,  -- Last Stand
		97463,  -- Rallying Cry
		46947,  -- Safeguard
		112048, -- Shield Barrier		
		2565,   -- Shield Block
		105914, -- Shield Fortress (tier bonus)
		871,    -- Shield Wall
		114030, -- Vigilance
	}
}

GridStatusTankCooldown.tankingbuffs = tankingbuffs

-- locals
local GridRoster = Grid:GetModule("GridRoster")
local GetSpellInfo = GetSpellInfo
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local UnitGUID = UnitGUID

local settings
local spellnames = {}

GridStatusTankCooldown.defaultDB = {
	debug = false,
	alert_tankcd = {
		enable = true,
		color = { r = 1, g = 1, b = 0, a = 1 },
		priority = 99,
		range = false,
		showtextas = "caster",
		active_spellids =  { -- default spells
			31850,	-- Ardent Defender
			86659,	-- Guardian of Ancient Kings
			47788,	-- Guardian Spirit
			6940, 	-- Hand of Sacrifice
			48792, 	-- Icebound Fortitude
			33206,	-- Pain Suppression
			871,	-- Shield Wall
			61336,	-- Survival Instincts
			115203, -- Fortifying Brew
		},
		inactive_spellids = { -- used to remember priority of disabled spells
		}
	}
}

local myoptions = {
	["gstcd_header_1"] = {
		type = "header",
		order = 200,
		name = "Options",
	},
	["showtextas"] = {
		order = 201,
		type = "select",
		name = "Show text as",
		desc = "Text to show when assigned to an indicator capable of displaying text",
		values = { ["caster"] = "Caster name", ["spell"] = "Spell name" },
		style = "radio",
		get = function() return GridStatusTankCooldown.db.profile.alert_tankcd.showtextas end,
		set = function(_, v) GridStatusTankCooldown.db.profile.alert_tankcd.showtextas = v end,
	},
	["gstcd_header_2"] = {
		type = "header",
		order = 203,
		name = "Spells",
	},
	["spells_description"] = {
		type = "description",
		order = 204,
		name = "Check the spells that you want GridStatusTankCooldown to keep track of. Their position on the list defines their priority in the case that a unit has more than one of them.",
	},
	["spells"] = {
		type = "input",
		order = 205,
		name = "Spells",
		control = "GSTCD-SpellsConfig",
	},
}

function GridStatusTankCooldown:OnInitialize()
	self.super.OnInitialize(self)
	
	for class, buffs in pairs(tankingbuffs) do
		for _, spellid in pairs(buffs) do
			local sname = GetSpellInfo(spellid)
			spellnames[spellid] = sname
		end
	end
	
	self:RegisterStatus("alert_tankcd", "Tanking cooldowns", myoptions, true)

	settings = self.db.profile.alert_tankcd

	-- delete old format settings
	if settings.spellids then
		settings.spellids = nil
	end
	
	-- remove old spellids
	for p, aspellid in ipairs(settings.active_spellids) do
		local found = false
		for class, buffs in pairs(tankingbuffs) do
			for _, spellid in pairs(buffs) do
				if spellid == aspellid then
					found = true
					break
				end				
			end
		end
		
		if not found then
			table.remove(settings.active_spellids, p)
		end
		
		-- remove duplicates
		for i = #settings.active_spellids, p + 1, -1 do
			if settings.active_spellids[i] == aspellid then
				table.remove(settings.active_spellids, i)
			end
		end
	end
end

function GridStatusTankCooldown:OnStatusEnable(status)
	if status == "alert_tankcd" then
		self:RegisterEvent("UNIT_AURA", "ScanUnit")
		self:RegisterEvent("Grid_UnitJoined")
		-- self:ScheduleRepeatingEvent("GridStatusTankCooldown:UpdateAllUnits", self.UpdateAllUnits, 0.5, self)
		self:UpdateAllUnits()
	end
end

function GridStatusTankCooldown:OnStatusDisable(status)
	if status == "alert_tankcd" then
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("Grid_UnitJoined")

		--self:CancelScheduledEvent("GridStatusTankCooldown:UpdateAllUnits")
		self.core:SendStatusLostAllUnits("alert_tankcd")
	end
end

function GridStatusTankCooldown:Grid_UnitJoined(guid, unitid)
	self:ScanUnit("Grid_UnitJoined", unitid, guid)
end

function GridStatusTankCooldown:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:ScanUnit("UpdateAllUnits", unitid, guid)
	end
end

function GridStatusTankCooldown:ScanUnit(event, unitid, unitguid)
	unitguid = unitguid or UnitGUID(unitid)
	if not GridRoster:IsGUIDInRaid(unitguid) then
		return
	end

	for _, spellid in ipairs(settings.active_spellids) do
		local name, _, icon, count, _, duration, expirationTime, caster = UnitBuff(unitid, spellnames[spellid])
		
		-- Used to check for debuffs when Argent Defender was a debuff - it is not necessary anymore
		--[[
		if not name then
			name, _, icon, count, _, duration, expirationTime, caster = UnitDebuff(unitid, spellnames[spellid])
		end
		]]

		if name then
			local text 
			if settings.showtextas == "caster" then
				if caster then
					text = UnitName(caster)
				end
			else
				text = name
			end

			self.core:SendStatusGained(unitguid, 
						"alert_tankcd",
						settings.priority,
						(settings.range and 40),
						settings.color,
						text,
						0,							-- value
						nil,						-- maxValue
						icon,						-- icon
						expirationTime - duration,	-- start
						duration,					-- duration
						count)						-- stack
			return
		end
	end

	self.core:SendStatusLost(unitguid, "alert_tankcd")
end
