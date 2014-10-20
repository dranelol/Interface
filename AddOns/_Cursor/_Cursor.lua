-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local next = _G.next
local pairs = _G.pairs
local tonumber = _G.tonumber
local type = _G.type

-- Libraries
local table = _G.table

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME = ...
local Version = GetAddOnMetadata(FOLDER_NAME, "Version"):match("^([%d.]+)")
_CursorOptions = nil
_CursorOptionsCharacter = {
	Cursors = {},
	Version = Version
}

local L = _CursorLocalization
local NS = CreateFrame("Frame", "_Cursor")

-------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------
local ActiveModels = {}
local InactiveModels = {}

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
NS.DefaultModelSet = L.SETS["Energy beam"]
NS.DefaultType = ""
NS.DefaultValue = "spells\\errorcube" -- Used when cursor preset not found
NS.ScaleDefault = 0.01 -- Baseline scaling factor applied before presets and custom scales

-- Set strings formatted as follows:
-- "Name|[Enabled]|Strata|[Type]|Value[|Scale][|Facing][|X][|Y]"
NS.DefaultSets = {
	[L.SETS["Energy beam"]] = {
		-- Energy/lightning trail
		L.CURSORS["Layer 1"] .. "|1|TOOLTIP|Trail|Electric, blue",
		L.CURSORS["Layer 2"] .. "|1|FULLSCREEN_DIALOG|Particle|Fire, blue",
		L.CURSORS["Layer 3"] .. "||FULLSCREEN_DIALOG"
	},
	[L.SETS["Shadow trail"]] = {
		-- Cloudy shadow trail
		L.CURSORS["Layer 1"] .. "|1|TOOLTIP|Trail|Shadow|0.5",
		L.CURSORS["Layer 2"] .. "|1|FULLSCREEN_DIALOG|Particle|Shadow cloud",
		L.CURSORS["Layer 3"] .. "||FULLSCREEN_DIALOG",
	},
	[L.SETS["Face Melter (Warning, bright!)"]] = {
		-- Large red blowtorch
		L.CURSORS["Laser"] .. "|1|LOW||spells\\cthuneeyeattack|1.5|.4|32|13",
		L.CURSORS["Heat"] .. "|1|BACKGROUND||spells\\deathanddecay_area_base",
		L.CURSORS["Smoke"] .. "|1|BACKGROUND||spells\\sandvortex_state_base",
	}
}

-- Preset strings formatted as follows:
-- "Path[|Scale][|Facing][|X][|Y]"
NS.Presets = {
	["Glow"] = {
		["Burning cloud, blue"] = "spells\\manafunnel_impact_chest|||4|-6",
		["Burning cloud, green"] = "spells\\lifetap_state_chest|||4|-6",
		["Burning cloud, purple"] = "spells\\soulfunnel_impact_chest|1|0|4|-6",
		["Burning cloud, red"] = "spells\\healrag_state_chest|||4|-6",
		["Cloud, black & blue"] = "spells\\enchantments\\soulfrostglow_high|4||8|-7",
		["Cloud, blue"] = "spells\\enchantments\\spellsurgeglow_high|6||10|-8",
		["Cloud, bright purple"] = "spells\\gouge_precast_state_hand|2.4||11|-9",
		["Cloud, corruption"] = "spells\\seedofcorruption_state|.9||9|-8",
		["Cloud, dark blue"] = "spells\\summon_precast_hand|2.7||9|-8",
		["Cloud, executioner"] = "spells\\enchantments\\disintigrateglow_high|4||8|-7",
		["Cloud, fire"] = "spells\\enchantments\\sunfireglow_high|5||10|-8",
		["Cloud, frost"] = "spells\\icyenchant_high|8||8|-8",
		["Ring, bloodlust"] = "spells\\bloodlust_state_hand|2.6||9|-8",
		["Ring, bones"] = "spells\\bonearmor_state_chest|.8||12|-9",
		["Ring, holy"] = "spells\\holy_precast_high_base|.8||9|-9",
		["Ring, pulse blue"] = "spells\\brillianceaura|.8||8|-8",
		["Ring, frost"] = "spells\\ice_precast_high_hand|1.9||11|-9",
		["Ring, vengeance"] = "spells\\vengeance_state_hand|2||9|-8",
		["Simple, black"] = "spells\\shadowmissile|2||5|-6",
		["Simple, green"] = "spells\\nature_precast_chest|||8|-8",
		["Simple, white"] = "spells\\enchantments\\whiteflame_low|4|5.3|10|-8",
		["Weather, lightning"] = "spells\\goblin_weather_machine_lightning|1.3||10|-11",
		["Weather, sun"] = "spells\\goblin_weather_machine_sunny|1.5|2.1|11|-9",
		["Weather, snow"] = "spells\\goblin_weather_machine_snow|1.5|2.1|11|-9",
		["Weather, cloudy"] = "spells\\goblin_weather_machine_cloudy|1.5|2.1|11|-9",
	},
	["Particle"] = {
		["Dust, arcane"] = "spells\\arcane_form_precast|1.1|.7|9|-11",
		["Dust, embers"] = "spells\\fire_form_precast|1.1|.7|9|-11",
		["Dust, holy"] = "spells\\holy_form_precast|1.1|.7|9|-11",
		["Dust, ice shards"] = "spells\\frost_form_precast|1.1|.7|9|-11",
		["Dust, shadow"] = "spells\\shadow_form_precast|1.1|.7|9|-11",
		["Fire"] = "spells\\demolisher_missile||2.2|11|-11",
		["Fire, blue"] = "spells\\fire_blue_precast_uber_hand|||6|-8",
		["Fire, fel"] = "spells\\fel_fire_precast_hand|||6|-8",
		["Fire, orange"] = "spells\\fire_precast_uber_hand|1.5||4|-6",
		["Fire, periodic red & blue"] = "spells\\incinerate_impact_base|.8||11|-10",
		["Fire, wavy purple"] = "spells\\incinerateblue_low_base|.25|2.3|11|-10",
		["Frost"] = "spells\\ice_precast_low_hand|2.5||8|-7",
		["Lava burst"] = "spells\\shaman_lavaburst_missile|.8||9|-7",
		["Leaves"] = "spells\\nature_form_precast|2.5|1|13|-11",
		["Periodic glint"] = "spells\\enchantments\\sparkle_a|4",
		["Plague cloud"] = "spells\\forsakencatapult_missile|1.5|2.3|10|-10",
		["Shadow cloud"] = "spells\\cripple_state_chest|.5||8|-8",
		["Spark, small white"] = "spells\\dispel_low_recursive|4",
		["Spark, small blue"] = "spells\\detectmagic_recursive|4",
		["Sparks, periodic healing"] = "spells\\lifebloom_state|||8|-8",
		["Sparks, red"] = "spells\\immolationtrap_recursive|4",
	},
	["Trail"] = {
		["Blue"] = "spells\\beartrap|.9||5|-6",
		["Electric, blue long"] = "spells\\lightningboltivus_missile|.1||4|-6",
		["Electric, blue"] = "spells\\lightning_precast_low_hand|||4|-6",
		["Electric, green"] = "spells\\lightning_fel_precast_low_hand|||4|-6",
		["Electric, yellow"] = "spells\\wrath_precast_hand|1.5||4|-6",
		["First-aid"] = "spells\\firstaid_hand|2||4|-6",
		["Freedom"] = "spells\\blessingoffreedom_state|.4||8|-8",
		["Ghost"] = "spells\\zig_missile|.7|1|8|-5",
		["Holy bright"] = "spells\\holy_missile_uber|.9||11|-9",
		["Long blue & holy glow"] = "spells\\alliancectfflag_spell|.9|2.3|1|-2",
		["Shadow"] = "spells\\shadow_precast_uber_hand|||4|-6",
		["Souls, small"] = "spells\\soulshatter_missile|1.7||5|-6",
		["Souls"] = "spells\\wellofsouls_base|.5||9|-8",
		["Sparkling, blue"] = "spells\\intervenetrail||2.4|7|-7",
		["Sparkling, light green"] = "spells\\sprint_impact_chest|1.3|.8|3|-4",
		["Sparkling, red"] = "spells\\chargetrail||2.4",
		["Sparkling, white"] = "spells\\ribbontrail",
		["Swirling, black"] = "spells\\shadow_impactdd_med_base|.5||5|-6",
		["Swirling, blood"] = "spells\\bloodbolt_chest|.5||5|-6",
		["Swirling, blue"] = "spells\\banish_chest_blue|.5||11|-9",
		["Swirling, holy"] = "spells\\holy_precast_uber_hand|||5|-6",
		["Swirling, nature"] = "spells\\rejuvenation_impact_base|.35||5|-6",
		["Swirling, poison"] = "spells\\banish_chest|.5||11|-9",
		["Swirling, purple"] = "spells\\banish_chest_purple|.5||11|-9",
		["Swirling, shadow"] = "spells\\banish_chest_dark|.5||11|-9",
		["Swirling, white"] = "spells\\banish_chest_white|.5||11|-9",
		["Swirling, yellow"] = "spells\\banish_chest_yellow|.5||11|-9",
	},
	["Breath"] = {
		["Arcane"] = "spells\\dragonbreath_arcane|.25|5.4",
		["Fire. blue"] = "spells\\dragonbreath_frost|.25|5.4",
		["Fire, fel"] = "spells\\fel_flamebreath|.5|5.5",
		["Fire, purple"] = "spells\\dragonbreath_shadow|.25|5.4",
		["Fire, red"] = "spells\\dragonbreath_fire|.25|5.4",
		["Frost"] = "spells\\flamebreath_blue|.5|5.5",
		["Frostfire"] = "spells\\flamebreathmff|.5|5.5",
		["Smoke"] = "spells\\corrosivesandbreath|.5|5.5",
	}
}

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------
local AddHideCondition, RemoveHideCondition
do
	local ActiveHideConditions = {}

	function AddHideCondition(Name)
		if not ActiveHideConditions[Name] then
			ActiveHideConditions[Name] = true
			NS:Hide()
		end
	end

	function RemoveHideCondition(Name)
		if ActiveHideConditions[Name] then
			ActiveHideConditions[Name] = nil

			if next(ActiveHideConditions) == nil then
				NS:Show()
			end
		end
	end
end

local function DisableModel(model)
	if not ActiveModels[model] then
		return
	end
	ActiveModels[model] = nil
	InactiveModels[model] = true

	model.X = nil
	model.Y = nil
	model:Hide()
	model:ClearModel()
end

local function EnableModel(model, cursorData)
	if ActiveModels[model] then
		DisableModel(model)
	end
	InactiveModels[model] = nil
	ActiveModels[model] = cursorData

	local cursor = ActiveModels[model]
	local scale = (cursor.Scale or 1.0) * NS.ScaleDefault
	local facing = cursor.Facing or 0

	model.X = cursor.X or 0
	model.Y = cursor.Y or 0

	if #cursor.Type == 0 then -- Custom
		model:SetModel(cursor.Value .. ".mdx")
	else
		local presetType = NS.Presets[cursor.Type]

		if not presetType or not presetType[cursor.Value] then
			cursor.Type = NS.DefaultType
			cursor.Value = NS.DefaultValue
			presetType = NS.Presets[cursor.Type]
		end

		local path, scalePreset, facingPreset, x, y = ("|"):split(presetType[cursor.Value])
		model:SetModel(path .. ".mdx")
		model.X = model.X + (tonumber(x) or 0)
		model.Y = model.Y + (tonumber(y) or 0)

		scale = scale * (tonumber(scalePreset) or 1.0)
		facing = facing + (tonumber(facingPreset) or 0)
	end

	model:SetModelScale(scale)
	model:SetFacing(facing)
	model:SetFrameStrata(cursor.Strata)
	model:Show()
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------
NS:RegisterEvent("ADDON_LOADED")
NS:RegisterEvent("CINEMATIC_START")
NS:RegisterEvent("CINEMATIC_STOP")
NS:RegisterEvent("SCREENSHOT_FAILED")
NS:RegisterEvent("SCREENSHOT_SUCCEEDED")

function NS:SCREENSHOT_FAILED()
	RemoveHideCondition("Screenshot")
end

NS.SCREENSHOT_SUCCEEDED = NS.SCREENSHOT_FAILED

function NS:CINEMATIC_START()
	AddHideCondition("Cinematic")
end

function NS:CINEMATIC_STOP()
	RemoveHideCondition("Cinematic")
end

do
	local function VersionCompare(Version1, Version2) -- Compares delimited version strings
		if Version1 == Version2 then
			return 0
		end

		Version1 = {
			("."):split(Version1 or "")
		}

		Version2 = {
			("."):split(Version2 or "")
		}

		for index, Sub1 in ipairs(Version1) do
			local Sub2 = Version2[index]
			if not Sub2 or Sub1 > Sub2 then
				return 1
			elseif Sub1 < Sub2 then
				return -1
			end
		end
		return #Version1 - #Version2
	end

	function NS:ADDON_LOADED(_, addonName)
		if addonName:lower() ~= FOLDER_NAME:lower() then
			return
		end

		NS:UnregisterEvent("ADDON_LOADED")
		NS.ADDON_LOADED = nil

		if not _CursorOptions then
			_CursorOptions = {
				Sets = CopyTable(NS.DefaultSets)
			}
		end

		if _CursorOptions.Version ~= Version then
			if VersionCompare(_CursorOptions.Version, "3.1.0.2") < 0 then -- 3.1.0.2: Updated the Face Melter preset
				local Name = L.SETS["Face Melter (Warning, bright!)"]

				if _CursorOptions.Sets[Name] then
					_CursorOptions.Sets[Name] = CopyTable(NS.DefaultSets[Name])
				end
			end

			_CursorOptions.Version = Version
		end

		_CursorOptionsCharacter.Version = Version

		if not _CursorOptionsCharacter.Cursors[1] then
			NS.LoadSet(NS.DefaultSets[NS.DefaultModelSet])
		else
			NS:UpdateModels()

			if NS.Options then
				NS.Options.Update()
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Hooks.
-------------------------------------------------------------------------------
-- Hide during screenshots
_G.hooksecurefunc("Screenshot", function()
	AddHideCondition("Screenshot")
end)

-- Hide while FMV movies play
_G.MovieFrame:HookScript("OnShow", function()
	AddHideCondition("Movie") -- FMV movie sequence, like the Wrathgate cinematic
end)

_G.MovieFrame:HookScript("OnHide", function()
	RemoveHideCondition("Movie")
end)

-- Hook camera movement to hide cursor effects
_G.hooksecurefunc("CameraOrSelectOrMoveStart", function()
	AddHideCondition("Camera")
end)

_G.hooksecurefunc("CameraOrSelectOrMoveStop", function()
	RemoveHideCondition("Camera")
end)

-------------------------------------------------------------------------------
-- Scripts.
-------------------------------------------------------------------------------
do
	local UPDATE_INTERVAL = 1

	local TotalElapsed = 0
	local IsMouselooking = _G.IsMouselooking

	_G.CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		TotalElapsed = TotalElapsed + elapsed

		if TotalElapsed >= UPDATE_INTERVAL then
			TotalElapsed = 0

			if IsMouselooking() then
				AddHideCondition("Mouselook")
			else
				RemoveHideCondition("Mouselook")
			end
		end
	end)
end

NS:SetScript("OnEvent", function(self, eventName, ...)
	return self[eventName](self, eventName, ...)
end)

NS:SetScript("OnShow", function()
	for model in pairs(ActiveModels) do
		local path = model:GetModel() -- Returns model table if unset

		if type(path) == "string" then
			model:SetModel(path)
		end
	end
end)

do
	local GetCursorPosition = _G.GetCursorPosition
	local hypotenuse = (_G.GetScreenWidth() ^ 2 + _G.GetScreenHeight() ^ 2) ^ 0.5 * _G.UIParent:GetEffectiveScale()
	local previousX, previousY

	NS:SetScript("OnUpdate", function(self, elapsed)
		local cursorX, cursorY = GetCursorPosition()
		if cursorX == previousX and cursorY == previousY then
			return
		end

		for model in pairs(ActiveModels) do
			model:SetPosition((cursorX + model.X) / hypotenuse, (cursorY + model.Y) / hypotenuse, 0)
		end

		previousX = cursorX
		previousY = cursorY
	end)
end

--[[****************************************************************************
  * Function: _Cursor.LoadSet                                                  *
  * Description: Unpacks a set into the current settings.                      *
  ****************************************************************************]]
do
	local tempCursors = {}

	function NS.LoadSet(set)
		local cursors = _CursorOptionsCharacter.Cursors

		-- Unload tables
		for index = 1, #cursors do
			local cursor = cursors[index]
			cursors[index] = nil
			tempCursors[cursor] = true
		end

		-- Unpack new data
		for index = 1, #set do
			local cursorData = set[index]
			local cursor = next(tempCursors) or {}
			tempCursors[cursor] = nil

			cursor.Name, cursor.Enabled, cursor.Strata, cursor.Type, cursor.Value, cursor.Scale, cursor.Facing, cursor.X, cursor.Y = ("|"):split(cursorData)
			cursor.Enabled = #cursor.Enabled > 0
			cursor.Type = cursor.Type or ""
			cursor.Value = cursor.Value or ""
			cursor.Scale = tonumber(cursor.Scale)
			cursor.Facing = tonumber(cursor.Facing)
			cursor.X = tonumber(cursor.X)
			cursor.Y = tonumber(cursor.Y)
			cursors[index] = cursor
		end

		NS:UpdateModels()

		if NS.Options then
			NS.Options.Update()
		end
	end
end

--[[****************************************************************************
  * Function: _Cursor.SaveSet                                                  *
  * Description: Packs a set from the current settings.                        *
  ****************************************************************************]]
function NS.SaveSet(set)
	table.wipe(set)

	local cursors = _CursorOptionsCharacter.Cursors
	for index = 1, #cursors do
		local cursorData = cursors[index]

		set[index] = ("|"):join(cursorData.Name, cursorData.Enabled and 1 or "",
			cursorData.Strata, cursorData.Type, cursorData.Value, cursorData.Scale or "",
			cursorData.Facing or "", cursorData.X or "", cursorData.Y or ""):gsub("|+$", "")
	end
end

do
	local ModelStrataLevels = {
		BACKGROUND = 0,
		LOW = 0,
		MEDIUM = 0,
		HIGH = 0,
		DIALOG = 0,
		FULLSCREEN = 0,
		FULLSCREEN_DIALOG = 0,
		TOOLTIP = 0
	}

	function NS:UpdateModels()
		for Model in pairs(ActiveModels) do
			DisableModel(Model)
		end

		for strataName in pairs(ModelStrataLevels) do
			ModelStrataLevels[strataName] = 0
		end
		local cursors = _CursorOptionsCharacter.Cursors

		for index = 1, #cursors do
			local cursorData = cursors[index]

			if cursorData.Enabled then
				local model = next(InactiveModels)

				if not model then
					model = _G.CreateFrame("Model", nil, self)
					model:SetAllPoints(nil) -- Fullscreen
					model:Hide()
					model:SetLight(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) -- Allows trails like warriors' intervene to work
				end
				EnableModel(model, cursorData)

				local strataLevel = ModelStrataLevels[cursorData.Strata] + 1
				ModelStrataLevels[cursorData.Strata] = strataLevel
				model:SetFrameLevel(strataLevel)
			end
		end
	end
end
