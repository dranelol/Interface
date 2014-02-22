local L = AceLibrary("AceLocale-2.2"):new("GridStatusLifebloom")
local GridRoster = Grid:GetModule("GridRoster")

local spellNameLifebloom = GetSpellInfo(33763)

GridStatusLifebloom = Grid:GetModule("GridStatus"):NewModule("GridStatusLifebloom")
local GridStatusLifebloom = GridStatusLifebloom
GridStatusLifebloom.menuName = spellNameLifebloom

L:RegisterTranslations("enUS", function()
	return {
		["Lifebloom Stack"] = true,
		["Lifebloom Duration"] = true,

		["Color 2"] = true,
		["Color 3"] = true,

		["Color when player has 2 stacks of lifebloom."] = true,
		["Color when player has 3 stacks of lifebloom."] = true,

		["Global Cooldown Mode"] = true,
		["Global Cooldown Duration"] = true,
		["Global Cooldown Delay"] = true,
	}
end)

L:RegisterTranslations("deDE", function()
	return {
		["Lifebloom Stack"] = "Blühendes Leben Anzahl",
		["Lifebloom Duration"] = "Blühendes Leben Dauer",

		["Color 2"] = "Farbe 2",
		["Color 3"] = "Farbe 3",

		["Color when player has 2 stacks of lifebloom."] = "Farbe wenn Spieler 2 'Blühendes Leben' hat.",
		["Color when player has 3 stacks of lifebloom."] = "Farbe wenn Spieler 3 'Blühendes Leben' hat.",

		["Global Cooldown Mode"] = "Globaler Cooldown Modus",
		["Global Cooldown Duration"] = "Globaler Cooldown Dauer",
		["Global Cooldown Delay"] = "Globaler Cooldown Verzögerung",
	}
end)

L:RegisterTranslations("esES", function()
	return {
		["Lifebloom Stack"] = "Lifebloom Stack",
		["Lifebloom Duration"] = "Lifebloom Duration",

		["Color 2"] = "Color 2",
		["Color 3"] = "Color 3",

		["Color when player has 2 stacks of lifebloom."] = "Color when player has 2 stacks of lifebloom.",
		["Color when player has 3 stacks of lifebloom."] = "Color when player has 3 stacks of lifebloom.",

		["Global Cooldown Mode"] = "Global Cooldown Mode",
		["Global Cooldown Duration"] = "Global Cooldown Duration",
		["Global Cooldown Delay"] = "Global Cooldown Delay",
	}
end)

L:RegisterTranslations("esMX", function()
	return {
		["Lifebloom Stack"] = "Lifebloom Stack",
		["Lifebloom Duration"] = "Lifebloom Duration",

		["Color 2"] = "Color 2",
		["Color 3"] = "Color 3",

		["Color when player has 2 stacks of lifebloom."] = "Color when player has 2 stacks of lifebloom.",
		["Color when player has 3 stacks of lifebloom."] = "Color when player has 3 stacks of lifebloom.",

		["Global Cooldown Mode"] = "Global Cooldown Mode",
		["Global Cooldown Duration"] = "Global Cooldown Duration",
		["Global Cooldown Delay"] = "Global Cooldown Delay",
	}
end)

L:RegisterTranslations("frFR", function()
	return {
		["Lifebloom Stack"] = "Lifebloom Stack",
		["Lifebloom Duration"] = "Lifebloom Duration",

		["Color 2"] = "Color 2",
		["Color 3"] = "Color 3",

		["Color when player has 2 stacks of lifebloom."] = "Color when player has 2 stacks of lifebloom.",
		["Color when player has 3 stacks of lifebloom."] = "Color when player has 3 stacks of lifebloom.",

		["Global Cooldown Mode"] = "Global Cooldown Mode",
		["Global Cooldown Duration"] = "Global Cooldown Duration",
		["Global Cooldown Delay"] = "Global Cooldown Delay",
	}
end)

L:RegisterTranslations("koKR", function()
	return {
		["Lifebloom Stack"] = "피어나는 생명 중첩",
		["Lifebloom Duration"] = "피어나는 생명 지속시간",

		["Color 2"] = "색상 2",
		["Color 3"] = "색상 3",

		["Color when player has 2 stacks of lifebloom."] = "플레이어에 피어나는 생명 2 중첩시 색상",
		["Color when player has 3 stacks of lifebloom."] = "플레이어에 피어나는 생명 3 중첩시 색상",

		["Global Cooldown Mode"] = "재사용 대기시간 모드",
		["Global Cooldown Duration"] = "재사용 대기시간 지속시간",
		["Global Cooldown Delay"] = "재사용 대기시간 지연",
	}
end)

L:RegisterTranslations("ruRU", function()
	return {
		["Lifebloom Stack"] = "Сумма Жизнецвета",
		["Lifebloom Duration"] = "Длительность Жизнецвета",

		["Color 2"] = "Цвет 2",
		["Color 3"] = "Цвет 3",

		["Color when player has 2 stacks of lifebloom."] = "Окраска, когда на игроке наложено 2 Жизнецвета.",
		["Color when player has 3 stacks of lifebloom."] = "Окраска, когда на игроке наложено 3 Жизнецвета.",

		["Global Cooldown Mode"] = "Режим глоб. перезарядк",
		["Global Cooldown Duration"] = "Длительность глоб. перезарядки",
		["Global Cooldown Delay"] = "Задержка глобальной перезарядки",
	}
end)

L:RegisterTranslations("zhCN", function()
	return {
		["Lifebloom Stack"] = "生命绽放堆叠",
		["Lifebloom Duration"] = "生命绽放持续时间",

		["Color 2"] = "颜色二",
		["Color 3"] = "颜色三",

		["Color when player has 2 stacks of lifebloom"] = "当生命绽放堆叠二次的颜色",
		["Color when player has 3 stacks of lifebloom"] = "当生命绽放堆叠三次的颜色",

		--["Global Cooldown Mode"] = true,
		--["Global Cooldown Duration"] = true,
		--["Global Cooldown Delay"] = true,
	}
end)

L:RegisterTranslations("zhTW", function()
	return {
		["Lifebloom Stack"] = "生命之花堆疊",
		["Lifebloom Duration"] = "生命之花持續時間",

		["Color 2"] = "顏色二",
		["Color 3"] = "顏色三",

		["Color when player has 2 stacks of lifebloom"] = "當生命之花堆疊二次的顏色",
		["Color when player has 3 stacks of lifebloom"] = "當生命之花堆疊三次的顏色",

		["Global Cooldown Mode"] = "全域冷卻時間模式",
		["Global Cooldown Duration"] = "全域持續冷卻時間",
		["Global Cooldown Delay"] = "全域延遲冷卻時間",
	}
end)

GridStatusLifebloom.defaultDB = {
	debug = false,
	alert_LifebloomStack = {
		text = L["Lifebloom Stack"],
		enable = true,
		color = { r = 1, g = 1, b = 0, a = 1 },
		color2 = { r = 0, g = 1, b = 1, a = 1 },
		color3 = { r = 0, g = 1, b = 0, a = 1 },
		gcdMode = false,
		gcdDuration = 1.5,
		gcdDelay = 0.5,
		priority = 70,
		range = false,
	},
	alert_LifebloomDuration = {
		text = L["Lifebloom Duration"],
		enable = true,
		color = { r = 1, g = 1, b = 0, a = 1 },
		color2 = { r = 0, g = 1, b = 1, a = 1 },
		color3 = { r = 0, g = 1, b = 0, a = 1 },
		priority = 70,
		range = false,
	},
}

local alert_LifebloomStackOptions = {
	["color2"] = {
		type = "color",
		order = 100,
		name = L["Color 2"],
		desc = L["Color when player has 2 stacks of lifebloom."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusLifebloom.db.profile.alert_LifebloomStack.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (r, g, b, a)
			local color = GridStatusLifebloom.db.profile.alert_LifebloomStack.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		order = 101,
		name = L["Color 3"],
		desc = L["Color when player has 3 stacks of lifebloom."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusLifebloom.db.profile.alert_LifebloomStack.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (r, g, b, a)
			local color = GridStatusLifebloom.db.profile.alert_LifebloomStack.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local alert_LifebloomDurationOptions = {
	["color2"] = {
		type = "color",
		order = 100,
		name = L["Color 2"],
		desc = L["Color when player has 2 stacks of lifebloom."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusLifebloom.db.profile.alert_LifebloomDuration.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (r, g, b, a)
			local color = GridStatusLifebloom.db.profile.alert_LifebloomDuration.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		order = 101,
		name = L["Color 3"],
		desc = L["Color when player has 3 stacks of lifebloom."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusLifebloom.db.profile.alert_LifebloomDuration.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (r, g, b, a)
			local color = GridStatusLifebloom.db.profile.alert_LifebloomDuration.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["gcdMode"] = {
		type = "toggle",
		order = 102,
		name = L["Global Cooldown Mode"],
		desc = L["Global Cooldown Mode"]..".",
		get = function ()
			return GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdMode
		end,
		set = function (arg)
			GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdMode = arg
		end,
	},
	["gcdDuration"] = {
		type = "range",
		order = 103,
		name = L["Global Cooldown Duration"],
		desc = L["Global Cooldown Duration"]..".",
		min = 1.5,
		max = 2,
		step = 0.01,
		disabled = function()
			if GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdMode then
				return false
			else
				return true
			end
		end,
		get = function ()
			return GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdDuration
		end,
		set = function (arg)
			GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdDuration = arg
		end,
	},
	["gcdDelay"] = {
		type = "range",
		order = 104,
		name = L["Global Cooldown Delay"],
		desc = L["Global Cooldown Delay"]..".",
		min = 0,
		max = 1,
		step = 0.01,
		disabled = function()
			if GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdMode then
				return false
			else
				return true
			end
		end,
		get = function ()
			return GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdDelay
		end,
		set = function (arg)
			GridStatusLifebloom.db.profile.alert_LifebloomStack.gcdDelay = arg
		end,
	}
}

local format = string.format
local GetTime = GetTime

function GridStatusLifebloom:OnInitialize()
	self.super.OnInitialize(self)

	self:RegisterStatuses()
end

function GridStatusLifebloom:OnEnable()
	self.debugging = self.db.profile.debug
	self:Debug("OnEnable")

	self.super.OnEnable(self)
end

function GridStatusLifebloom:Reset()
	self.super.Reset(self)

	self:UnregisterStatuses()
	self:RegisterStatuses()
	self:UpdateAllUnits()
end


function GridStatusLifebloom:RegisterStatuses()
	self:RegisterStatus("alert_LifebloomStack", L["Lifebloom Stack"], alert_LifebloomStackOptions)
	self:RegisterStatus("alert_LifebloomDuration", L["Lifebloom Duration"], alert_LifebloomDurationOptions)
end

function GridStatusLifebloom:UnregisterStatuses()
	self:UnregisterStatus("alert_LifebloomStack")
	self:UnregisterStatus("alert_LifebloomDuration")
--[[
	for status, moduleName, desc in self.core:RegisteredStatusIterator() do
		if (moduleName == self.name) then
			self:UnregisterStatus(status)
		end
	end
--]]
end


function GridStatusLifebloom:Grid_UnitJoined(guid, unitid)
	self:UpdateUnit(unitid)
end

function GridStatusLifebloom:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnit(unitid)
	end
end


-- expirationTimeList[guid] = expirationTime
-- colorList[guid] = color
local activeCount = 0
local expirationTimeList = {}
local colorList = {}

function GridStatusLifebloom:RefreshActiveUnits()
	local settings = self.db.profile.alert_LifebloomDuration
	local now = GetTime()
	activeCount = 0

	for guid, expirationTime in pairs(expirationTimeList) do
		if (expirationTime > now) then
			local timeLeft = expirationTime - now
			local color = colorList[guid]
			activeCount = activeCount + 1

			if (timeLeft < 0) then
				timeLeft = 0
			end

			if settings.gcdMode then
				local gcd_count = (timeLeft - settings.gcdDelay) / settings.gcdDuration
				if (gcd_count < 0) then
					gcd_count = 0
				end
				local max_gcd_count = (7 - settings.gcdDelay) / settings.gcdDuration

				self.core:SendStatusGained(guid, "alert_LifebloomDuration",
										   settings.priority,
										   (settings.range and 40),
										   color,
										   format("%.1f", gcd_count),
										   gcd_count,
										   max_gcd_count)
			else
				self.core:SendStatusGained(guid, "alert_LifebloomDuration",
										   settings.priority,
										   (settings.range and 40),
										   color,
										   format("%.1f", timeLeft),
										   timeLeft,
										   7)
			end
		else
			expirationTimeList[guid] = nil
			colorList[guid] = nil

			self.core:SendStatusLost(guid, "alert_LifebloomDuration")
		end
	end

	-- no units with lifebloom on them?  cancel the repeating event
	if (activeCount == 0) then
		self:CancelScheduledEvent("GridLifebloom_Refresh")
	end
end


local f = function()
	GridStatusLifebloom:RefreshActiveUnits()
end

local myUnits = {
	player = true,
	pet = true,
	vehicle = true,
}
function GridStatusLifebloom:UpdateUnit(unitid)
	local guid = UnitGUID(unitid)
	if (not GridRoster:IsGUIDInRaid(guid)) then
		return
	end

	local settings = self.db.profile.alert_LifebloomStack
	local durationEnabled = self.db.profile.alert_LifebloomDuration.enable
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unitid, spellNameLifebloom, nil, "HELPFUL|PLAYER")
	local isMine = myUnits[caster]

	if (isMine and duration) then
		local startTime = expirationTime - duration

		local thecolor = settings.color
		if (count == 2) then
			thecolor = settings.color2
		elseif (count == 3) then
			thecolor = settings.color3
		end

		if (settings.enable) then
			self.core:SendStatusGained(guid, "alert_LifebloomStack",
									   settings.priority,
									   (settings.range and 40),
									   thecolor,
									   tostring(count),
									   count,
									   3,
									   icon,
									   startTime,
									   duration,
									   count)
		end

		-- update info for alert_LifebloomDuration
		expirationTimeList[guid] = expirationTime
		colorList[guid] = thecolor

		-- whenever activeCount is zero, we need to start the repeating event
		if (activeCount == 0 and durationEnabled) then
			self:ScheduleRepeatingEvent("GridLifebloom_Refresh", f, 0.07)
			self:RefreshActiveUnits()
		end
	else
		self.core:SendStatusLost(guid, "alert_LifebloomStack")
		if (durationEnabled) then
			self.core:SendStatusLost(guid, "alert_LifebloomDuration")
		end

		-- update info for alert_LifebloomDuration
		expirationTimeList[guid] = nil
		colorList[guid] = nil
	end
end


function GridStatusLifebloom:EnabledStatusCount()
	local enabledStatusCount = 0

	for status, settings in pairs(self.db.profile) do
		if (type(settings) == "table" and settings.enable) then
			enabledStatusCount = enabledStatusCount + 1
		end
	end

	return enabledStatusCount
end

function GridStatusLifebloom:OnStatusEnable(status)
	self:RegisterEvent("Grid_UnitJoined")
	self:RegisterEvent("UNIT_AURA", "UpdateUnit")

	if (status == "alert_LifebloomDuration") then
		activeCount = 0
	end

	self:UpdateAllUnits()
end

function GridStatusLifebloom:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
	self:UpdateAllUnits()

	if (self:EnabledStatusCount() == 0) then
		self:UnregisterEvent("Grid_UnitJoined")
		self:UnregisterEvent("UNIT_AURA")
	end

	if (status == "alert_LifebloomDuration") then
		self:CancelScheduledEvent("GridLifebloom_Refresh")
	end
end
