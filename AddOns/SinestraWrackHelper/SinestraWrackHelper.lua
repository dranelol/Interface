
-------------------- GLOBALS/LOCALS/UPVALUES --------------------
SWH = LibStub("AceAddon-3.0"):NewAddon(CreateFrame("Frame", "SinestraWrackHelper"), "SinestraWrackHelper", "AceEvent-3.0", "AceConsole-3.0")
local SWH = SWH
local L = LibStub("AceLocale-3.0"):GetLocale("SinestraWrackHelper", true)
local LSM = LibStub("LibSharedMedia-3.0")
local LBZ = LibStub("LibBabble-Zone-3.0", true)
local BZ = LBZ and LBZ:GetLookupTable() or setmetatable({}, {__index = function(t,k) return k end})

local GetTime, sort, ipairs, pairs, rawget, ceil, format, max, random =
	  GetTime, sort, ipairs, pairs, rawget, ceil, format, max, random
local UnitClass, UnitName, UnitDebuff, UnitBuff, GetSpellTexture, GetRealZoneText, UnitPlayerOrPetInRaid, CreateFrame =
	  UnitClass, UnitName, UnitDebuff, UnitBuff, GetSpellTexture, GetRealZoneText, UnitPlayerOrPetInRaid, CreateFrame

local debug = SWH_DEBUG
local clientVersion = select(4, GetBuildInfo())

local db, st, co, bkg
local bars
local orderedBars = {}


-------------------- OPTIONS --------------------
local Defaults = {
	profile = {
		Locked		=	true,
		barx		=	160,
		bary		=	20,
		barMax		=	20,
		barspace	=	0,
		bardir		=	-1,
		st		 	= 	{r=0, g=1, b=0, a=1},
		co 			= 	{r=1, g=0, b=0, a=1},
		bkg 		= 	{r=0, g=0, b=0, a=0.5},
		barTexture	= 	"Blizzard",
		icside		= 	-1, -- no, this isnt supposed to be "icsize"
		icscale		=	1,
		icx			=	0,
		icy			=	0,
		icenabled	=	true,
		point = {
			point = "TOP",
			relpoint = "CENTER",
			x = 200,
			y = 0,
		},
		Fonts = {
			["**"] = {
				Enabled = true,
				Name = "Arial Narrow",
				Size = 12,
				Outline = "OUTLINE",
				x = 0,
				y = 0,
				Color = NORMAL_FONT_COLOR,
				HGColor = NORMAL_FONT_COLOR,
				DGColor = {r=1, g=0, b=0},
			},
			Name = {
				x = 3,
			},
			Time = {
				x = -40,
			},
			Damage = {
				x = 0,
			},
			Health = {
				Enabled = false,
				x = 0,
			},
		},
	},
}
local fontsettingnames = {
	Name = L["FONT_HEADER_PLAYERNAME"],
	Time = L["FONT_HEADER_TIMEACTIVE"],
	Damage = L["FONT_HEADER_NEXTDAMAGE"],
	Health = L["FONT_HEADER_CURRHEALTH"],
}
local fontsettingorders = {
	Name = 10,
	Time = 11,
	Damage = 12,
	Health = 13,
}
local fontsettingcolors = {
	Name = 1,
	Time = 1,
	Damage = 2,
	Health = 2,
}
local fontTemplate = {
	type = "group",
	name = function(info)
		return fontsettingnames[info[#info]]
	end,
	order = function(info)
		return fontsettingorders[info[#info]]
	end,
	set = function(info, val)
		db.profile.Fonts[info[#info-1]][info[#info]] = val
		SWH:Update()
	end,
	get = function(info) return db.profile.Fonts[info[#info-1]][info[#info]] end,
	args = {
		Enabled = {
			name = L["ENABLED"],
			desc = L["FONT_ENABLE"],
			type = "toggle",
			order = 1,
		},
		Name = {
			name = L["FONT_TYPEFACE"],
			type = "select",
			order = 3,
			dialogControl = 'LSM30_Font',
			values = LSM:HashTable("font"),
		},
		Outline = {
			name = L["FONT_OUTLINE"],
			type = "select",
			values = {
				[""] = L["MONOCHROME"],
				OUTLINE = L["OUTLINE"],
				THICKOUTLINE = L["THICKOUTLINE"],
			},
			style = "dropdown",
			order = 11,
		},
		Size = {
			name = L["FONT_SIZE"],
			type = "range",
			width = "full",
			order = 12,
			softMin = 6,
			softMax = 26,
			step = 1,
			bigStep = 1,
		},
		x = {
			name = L["XOFFS"],
			type = "range",
			width = "full",
			order = 21,
			softMin = -100,
			softMax = 100,
			step = 1,
			bigStep = 1,
		},
		y = {
			name = L["YOFFS"],
			width = "full",
			type = "range",
			order = 22,
			softMin = -40,
			softMax = 40,
			step = 1,
			bigStep = 1,
		},
		Color = {
			name = L["FONT_COLOR"],
			type = "color",
			order = 30,
			set = function(info, r, g, b, a)
				local c = db.profile.Fonts[info[#info-1]][info[#info]]
				c.r = r
				c.g = g
				c.b = b
				SWH:Update()
			end,
			get = function(info)
				local c = db.profile.Fonts[info[#info-1]][info[#info]]
				return c.r, c.g, c.b
			end,
			hidden = function(info)
				return fontsettingcolors[info[#info-1]] == 2
			end,
		},
		DGColor = {
			name = L["FONT_DGCOLOR"],
			desc = L["FONT_DGCOLOR_DESC"],
			type = "color",
			order = 30,
			set = function(info, r, g, b, a)
				local c = db.profile.Fonts[info[#info-1]][info[#info]]
				c.r = r
				c.g = g
				c.b = b
				SWH:Update()
			end,
			get = function(info)
				local c = db.profile.Fonts[info[#info-1]][info[#info]]
				return c.r, c.g, c.b
			end,
			hidden = function(info)
				return fontsettingcolors[info[#info-1]] == 1
			end,
		},
		HGColor = {
			name = L["FONT_HGCOLOR"],
			desc = L["FONT_HGCOLOR_DESC"],
			type = "color",
			order = 30,
			set = function(info, r, g, b, a)
				local c = db.profile.Fonts[info[#info-1]][info[#info]]
				c.r = r
				c.g = g
				c.b = b
				SWH:Update()
			end,
			get = function(info)
				local c = db.profile.Fonts[info[#info-1]][info[#info]]
				return c.r, c.g, c.b
			end,
			hidden = function(info)
				return fontsettingcolors[info[#info-1]] == 1
			end,
		}
	},
}
local OptionsTable = {
	type = "group",
	set = function(info, val)
		db.profile[info[#info]] = val
		SWH:Update()
	end,
	get = function(info) return db.profile[info[#info]] end,
	args = {
		bars = {
			type = "group",
			name = L["BAR_HEADER"],
			order = 1,
			args = {
				Locked = {
					name = L["LOCKED"],
					desc = L["CONFIG_LOCK"],
					type = "toggle",
					order = 10,
					set = function(info, val)
						db.profile.Locked = not val -- intended since the value is switching in SWH:ToggleLock()
						SWH:ToggleLock()
					end,
				},
				barx = {
					name = L["BAR_WIDTH"],
					type = "range",
					order = 20,
					width = "full",
					softMin = 10,
					softMax = 500,
					step = 1,
					bigStep = 1,
				},
				bary = {
					name = L["BAR_HEIGHT"],
					type = "range",
					order = 30,
					width = "full",
					softMin = 10,
					softMax = 50,
					step = 0.1,
					bigStep = 0.1,
				},
				barspace = {
					name = L["BAR_SPACING"],
					desc = L["BAR_SPACING_DESC"],
					type = "range",
					order = 40,
					width = "full",
					min = 0,
					softMax = 20,
					step = 0.1,
					bigStep = 0.1,
				},
				barMax = {
					name = L["BAX_MAX"],
					desc = L["BAR_MAX_DESC"],
					type = "range",
					order = 50,
					width = "full",
					min = 1,
					softMax = 60,
					step = 1,
					bigStep = 1,
				},
				bardir = {
					name = L["BAR_DIRECTION"],
					desc = L["BAR_DIRECTION_DESC"],
					type = "select",
					style = "radio",
					order = 60,
					values = {
						[-1] = L["DOWN"],
						[1] = L["UP"],
					},
				},
				barTexture = {
					name = L["BAR_TEXTURE"],
					type = "select",
					order = 90,
					dialogControl = 'LSM30_Statusbar',
					values = LSM:HashTable("statusbar"),
				},
				color = {
					type = "group",
					name = L["BAR_COLORS"],
					order = 200,
					guiInline = true,
					dialogInline = true,
					set = function(info, r, g, b, a)
						local c = db.profile[info[#info]]
						c.r = r
						c.g = g
						c.b = b
						c.a = a
						SWH:Update()
					end,
					get = function(info)
						local c = db.profile[info[#info]]
						return c.r, c.g, c.b, c.a
					end,
					args = {
						st = {
							name = L["BAR_COLOR_START"],
							desc = L["BAR_COLOR_START_DESC"],
							type = "color",
							hasAlpha = true,
							order = 1,
						},
						co = {
							name = L["BAR_COLOR_END"],
							desc = L["BAR_COLOR_END_DESC"],
							type = "color",
							hasAlpha = true,
							order = 2,
						},
						bkg = {
							name = L["BAR_COLOR_BKG"],
							desc = L["BAR_COLOR_BKG_DESC"],
							type = "color",
							hasAlpha = true,
							order = 3,
						},
					},
				},
			},
		},
		auras = {
			type = "group",
			name = L["ICON_HEADER"],
			desc = L["ICON_DESC"],
			order = 2,
			args = {
				icenabled = {
					name = L["ENABLED"],
					desc = L["ICON_ENABLE_DESC"],
					type = "toggle",
					order = 1,
				},
				icside = {
					name = L["ICON_ANCHORSIDE"],
					type = "select",
					style = "radio",
					order = 2,
					values = {
						[-1] = L["LEFT"],
						[1] = L["RIGHT"],
					},
				},
				icscale = {
					name = L["SCALE"],
					type = "range",
					order = 7,
					width = "full",
					min = 0.1,
					softMin = 0.5,
					softMax = 2,
					step = 0.01,
					bigStep = 0.01,
				},
				icx = {
					name = L["XOFFS"],
					type = "range",
					width = "full",
					order = 21,
					softMin = -20,
					softMax = 20,
					step = 1,
					bigStep = 1,
				},
				icy = {
					name = L["YOFFS"],
					width = "full",
					type = "range",
					order = 22,
					softMin = -20,
					softMax = 20,
					step = 1,
					bigStep = 1,
				},

			},
		},
		Name = fontTemplate,
		Time = fontTemplate,
		Damage = fontTemplate,
		Health = fontTemplate,
	},
}


-------------------- DATA --------------------
local wrack = {
    [89421] = 1,
	[89435] = 1,
	[92955] = 1,
	[92956] = 1,
}
local reductions = {
    [   17] = 1,	-- PW:S
    [47585] = 1,	-- disperse
    [48707] = 1,	-- AMS
    [50461] = 1,	-- AMZ
    [47788] = 1,	-- guardian spirit
    [33206] = 1,	-- pain supp
}
for k, v in pairs(reductions) do
	reductions[k] = GetSpellInfo(k)
end
local Headers = {
	Name = L["FRAMEHEADER_NAME"],
	Time = L["FRAMEHEADER_TIME"],
	Damage = L["FRAMEHEADER_DAMAGE"],
	Health = L["FRAMEHEADER_HEALTH"],
}
local dmg = setmetatable({},{ __index = function(t, k)
	local d = 2000*1.5^k
	t[k] = d
	return d
end})
-------------------- BAR CONTAINER --------------------
SWH:SetMovable(1)
SWH.text = SWH:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SWH.text:SetText(L["CONFIG_TEXT"])

local function SortBars(a, b)
	if a.start and b.start then
		return a.start < b.start
	else
		return a.start
	end
end
local function Reposition()
	sort(orderedBars, SortBars)
	local y = 0
	for i, bar in ipairs(orderedBars) do
		if bar.active then
			bar:SetPoint("TOPLEFT", SWH, "TOPLEFT", 0, y*(db.profile.bary+db.profile.barspace)*db.profile.bardir)
			bar:Show()
			y = y + 1
		else
			bar:Hide()
		end
	end
end

function SWH:OnUpdate()
	local time = GetTime()
	for name, bar in pairs(bars) do
		local start = bar.start
		local d = start and time-start
		if not bar.isTest and d then
			if d > 60 then -- last resort fix for bars that stick around
				bar.active = nil
				bar:Hide()
				Reposition()
			elseif bar.active then
				bar.timet:SetText(ceil(d))
				bar:SetValue(d)

				local pct = (d) / db.profile.barMax
				local inv = 1-pct
				bar:SetStatusBarColor(
					(co.r*pct) + (st.r * inv),
					(co.g*pct) + (st.g * inv),
					(co.b*pct) + (st.b * inv),
					1
				)
				bar:SetAlpha((co.a*pct) + (st.a * inv))

			end
		end
	end
end


-------------------- BARS --------------------
local function UpdateBar(bar)

	---- SET SETTINGS ----
	bar:SetSize(db.profile.barx, db.profile.bary)
	bar.tex:SetTexture(LSM:Fetch("statusbar", db.profile.barTexture))
	bar:SetMinMaxValues(0, db.profile.barMax)

	local bkg = db.profile.bkg
	bar.bkg:SetTexture(bkg.r, bkg.g, bkg.b, bkg.a)

	local f = db.profile.Fonts.Name
	bar.namet:SetPoint("LEFT", bar, f.x, f.y)
	bar.namet:SetFont(LSM:Fetch("font", f.Name), f.Size, f.Outline)
	if f.Enabled then
		bar.namet:Show()
	else
		bar.namet:Hide()
	end

	f = db.profile.Fonts.Damage
	bar.dmgt:SetPoint("RIGHT", bar, f.x, f.y)
	bar.dmgt:SetFont(LSM:Fetch("font", f.Name), f.Size, f.Outline)
	bar.dmgt:SetVertexColor(f.Color.r, f.Color.g, f.Color.b)
	if f.Enabled then
		bar.dmgt:Show()
	else
		bar.dmgt:Hide()
	end

	f = db.profile.Fonts.Time
	bar.timet:SetPoint("RIGHT", bar, f.x, f.y)
	bar.timet:SetFont(LSM:Fetch("font", f.Name), f.Size, f.Outline)
	bar.timet:SetVertexColor(f.Color.r, f.Color.g, f.Color.b)
	if f.Enabled then
		bar.timet:Show()
	else
		bar.timet:Hide()
	end

	f = db.profile.Fonts.Health
	bar.health:SetPoint("RIGHT", bar, f.x, f.y)
	bar.health:SetFont(LSM:Fetch("font", f.Name), f.Size, f.Outline)
	bar.health:SetVertexColor(f.Color.r, f.Color.g, f.Color.b)
	if f.Enabled then
		bar.health:Show()
	else
		bar.health:Hide()
	end
	---- SETTINGS SET ----


	if db.profile.icenabled then
		local s = db.profile.icscale*db.profile.bary
		bar.ic:SetSize(s, s)
		bar.ic:ClearAllPoints()
		if db.profile.icside == -1 then
			bar.ic:SetPoint("RIGHT", bar, "LEFT", db.profile.icx, db.profile.icy)
		else
			bar.ic:SetPoint("LEFT", bar, "RIGHT", db.profile.icx, db.profile.icy)
		end
		if bar.isTest then
			bar.ic:Show()
			bar.cd:Show()
		elseif not bar.icEnabled then
			bar.ic:Hide()
			bar.cd:Hide()
		end
	else
		bar.ic:Hide()
		bar.cd:Hide()
	end

	if db.profile.Locked then
		bar:EnableMouse(0)
		bar.ic:SetTexture(bar.texpath)
		if bar.icEnabled then
			bar.ic:Show()
			bar.cd:Show()
		else
			bar.ic:Hide()
			bar.cd:Hide()
		end
		if bar.isTest then
			bar.active = nil
		end
		if bar.active and not bar.isTest then
			bar:Show()
		else
			bar:Hide()
		end
	else
		bar:EnableMouse(1)
		if bar.isTest then
		
			-- stupid hack because bars dont update their visual when their size changes unless their value is changed
			bar:SetValue(0)
			bar:SetValue(bar.isTest)
			
			-- update the color for when the max changes
			local pct = bar.isTest / db.profile.barMax
			local inv = 1-pct
			bar:SetStatusBarColor(
				(co.r*pct) + (st.r*inv),
				(co.g*pct) + (st.g*inv),
				(co.b*pct) + (st.b*inv),
				1
			)
			bar:SetAlpha((co.a*pct) + (st.a * inv))
			bar.active = random(10)
		else
			bar:Hide()
		end
	end
	bar:UpdateTextColors()
end
local function UpdateTextColors(bar)

	local h = bar.health.val or 1
	local d = bar.dmgt.val or 0

	local Color = h > d and db.profile.Fonts.Health.HGColor or db.profile.Fonts.Health.DGColor
	bar.health:SetVertexColor(Color.r, Color.g, Color.b)

	local Color = h > d and db.profile.Fonts.Damage.HGColor or db.profile.Fonts.Damage.DGColor
	bar.dmgt:SetVertexColor(Color.r, Color.g, Color.b)
end
local function StartMoving()
	if not db.profile.Locked then
		SWH:StartMoving()
	end
end
local function StopMoving()
	if not db.profile.Locked then
		SWH:StopMovingOrSizing()
		local p = db.profile.point
		p.point, _, p.relpoint, p.x, p.y = SWH:GetPoint()
	end
end
local function OnShow(bar)
	bar:SetStatusBarColor(st.r, st.g, st.b, 1)
	bar:SetAlpha(st.a)
end
local function CreateBar(name)
	local bar = CreateFrame("StatusBar", "SWH_Bar_"..name, SWH)
	bar:SetScript("OnDragStart", StartMoving)
	bar:SetScript("OnDragStop", StopMoving)
	bar:SetScript("OnMouseUp", StopMoving)
	bar:SetScript("OnShow", OnShow)
	bar.UpdateBar = UpdateBar
	bar.UpdateTextColors = UpdateTextColors
	bar:RegisterForDrag("LeftButton")

	bar.bkg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bkg:SetAllPoints(bar)
	bar.bkg:SetTexture(1, 1, 1, 1)

	bar.tex = bar:CreateTexture()
	bar:SetStatusBarTexture(bar.tex)

	local namet = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bar.namet = namet
	namet:SetText(name)
	local _, class = UnitClass(name)
	if class then
		local c = RAID_CLASS_COLORS[class]
		if c then
			namet:SetVertexColor(c.r, c.g, c.b, 1)
		end
	end
	bar.ic = bar:CreateTexture()
	bar.ic:SetTexCoord(.07, .93, .07, .93)
	bar.cd = CreateFrame("Cooldown", nil, bar)
	bar.cd:SetAllPoints(bar.ic)

	bar.dmgt = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bar.health = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bar.timet = bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bar:UpdateBar()

	tinsert(orderedBars, bar)
	return bar
end

bars = setmetatable({}, {__index = function(tbl, k)
	if not k then return end
	local bar = CreateBar(k)
	tbl[k] = bar
	return bar
end}) SWH.bars = bars


-------------------- GENERAL --------------------
function SWH:Update()
	local rzt = GetRealZoneText()
	if debug or rzt == BZ["The Bastion of Twilight"] or rzt == "The Bastion of Twilight" then
		SWH:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		SWH:RegisterEvent("UNIT_HEALTH")
		SWH:SetScript("OnUpdate", SWH.OnUpdate)
	else
		SWH:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		SWH:UnregisterEvent("UNIT_HEALTH")
		SWH:SetScript("OnUpdate", nil)
		for name, bar in pairs(bars) do
			bar.active = nil
		end
	end

	st, co = db.profile.st, db.profile.co

	local p = db.profile.point
	SWH:ClearAllPoints()
	SWH:SetPoint(p.point, UIParent, p.relpoint, p.x, p.y)
	SWH:SetSize(db.profile.barx, db.profile.bary)
	SWH:Show()

	SWH.text:SetWidth(max(db.profile.barx, 150))
	SWH.text:ClearAllPoints()
	if db.profile.bardir == 1 then
		SWH.text:SetPoint("TOP", SWH, "BOTTOM", 0, -15)
	else
		SWH.text:SetPoint("BOTTOM", SWH, "TOP", 0, 15)
	end
	if db.profile.Locked then
		SWH.text:Hide()
	else
		SWH.text:Show()
	end
	for name, bar in pairs(bars) do
		bar:UpdateBar()
	end

	if not db.profile.Locked then
		for k, v in pairs(Headers) do
			SWH[k] = SWH[k] or SWH:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			SWH[k]:SetText(v)
			local ps = k == "Name" and "LEFT" or "RIGHT"
			SWH[k]:ClearAllPoints()
			if db.profile.bardir == 1 then
				SWH[k]:SetPoint("TOP"..ps, SWH, "BOTTOM"..ps, db.profile.Fonts[k].x, 0)
			else
				SWH[k]:SetPoint("BOTTOM"..ps, SWH, "TOP"..ps, db.profile.Fonts[k].x, 0)
			end
			if db.profile.Fonts[k].Enabled then
				SWH[k]:Show()
			else
				SWH[k]:Hide()
			end
		end

	elseif SWH.Name then
		for k, v in pairs(Headers) do
			SWH[k]:Hide()
		end
	end

	Reposition()
end

function SWH:ToggleLock()
	db.profile.Locked = not db.profile.Locked
	if not db.profile.Locked then
		for _, name in pairs({
			"TEST 1",
			"TEST 2",
			"TEST 3",
			"TEST 4",
			"TEST 5",
		}) do
			local bar = bars[name]
			local t = random(24)
			bar.isTest = t

			bar.timet:SetText(ceil(t))
			bar:SetValue(t)
			bar.start = GetTime() - t
			local pct = t / db.profile.barMax
			local inv = 1-pct
			bar:SetStatusBarColor(
				(co.r*pct) + (st.r * inv),
				(co.g*pct) + (st.g * inv),
				(co.b*pct) + (st.b * inv),
				1)
			bar:SetAlpha((co.a*pct) + (st.a * inv))
			bar.ic:SetTexture(GetSpellTexture(47585))

			local d = dmg[max(1, ceil(t/2)-1 )]
			bar.dmgt:SetText(format("%.1f", d/1000) .. "k")
			bar.dmgt.val = d

			local h = random(120000)
			bar.health:SetText(format("%.1f", h/1000) .. "k")
			bar.health.val = h

			bar:UpdateTextColors()

			bar.ic:Show()
			bar.cd:Show()
			bar:Show()
		end
		SWH.text:Show()
	end

	SWH:Update()
end

function SWH:OnInitialize()
	SWH.db = LibStub("AceDB-3.0"):New("SinestraWrackHelperDB", Defaults)
	db = SWH.db
	db.RegisterCallback(SWH, "OnProfileChanged", "Update")
	db.RegisterCallback(SWH, "OnProfileCopied", "Update")
	db.RegisterCallback(SWH, "OnProfileReset", "Update")
	db.RegisterCallback(SWH, "OnNewProfile", "Update")
	db.profile.Locked = true

	OptionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Sinestra Wrack Helper Options", OptionsTable)
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("Sinestra Wrack Helper Options", 610, 500)
	if not SWH.AddedToBlizz then
		SWH.AddedToBlizz = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Sinestra Wrack Helper Options", "Sinestra Wrack Helper")
	else
		LibStub("AceConfigRegistry-3.0"):NotifyChange("Sinestra Wrack Helper Options")
	end

	SWH:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Update")
	SWH:RegisterEvent("ZONE_CHANGED_INDOORS", "Update")
	SWH:RegisterEvent("ZONE_CHANGED", "Update")

	for k, v in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
		if v.addon == "SinestraWrackHelper" and not v.obj then -- this is the AddonLoader interface options stub
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			InterfaceAddOnsList_Update()
			break
		end
	end

	SWH:Update()
end

function SWH:COMBAT_LOG_EVENT_UNFILTERED(_, ...)
	local event, destName, spellID, spellName, amount, absorbed, missAmt
	if clientVersion >= 40200 then
		_, event, _, _, _, _, _, _, destName, _, _, spellID, spellName, _, amount, missAmt, _, resist, _, absorbed = ...
	elseif clientVersion >= 40100 then
		_, event, _, _, _, _, _, destName, _, spellID, spellName, _, amount, missAmt, _, resist, _, absorbed = ...
	else
		_, event, _, _, _, _, destName, _, spellID, spellName, _, amount, missAmt, _, resist, _, absorbed = ...
	end
	if event == "UNIT_DIED" then
		local bar = rawget(bars, destName)
		if bar then
			bar.active = nil
			Reposition()
		end
	elseif wrack[spellID] then
		local bar = bars[destName]
		if event == "SPELL_AURA_APPLIED" then
			bar.start = GetTime()
			bar.active = 0

			bar.dmgt:SetText("2.0k")
			bar.dmgt.val = 2000

			SWH:UNIT_HEALTH(_, destName)

			Reposition()
		elseif event == "SPELL_AURA_REMOVED" then
			bar.active = nil
			Reposition()
		elseif event == "SPELL_PERIODIC_DAMAGE" and bar.active then
			bar.active = bar.active + 1
			
			local d = ((amount or 0) + (absorbed or 0))*1.5
			
			bar.dmgt:SetText(format("%.1f", d/1000) .. "k")
			bar.dmgt.val = d
			bar:UpdateTextColors()
		elseif event == "SPELL_PERIODIC_MISSED" and bar.active then
			bar.active = bar.active + 1
			
			local d = (missAmt or 0)*1.5
			if not missAmt then
				bar.dmgt:SetText("ERROR")
			else
				bar.dmgt:SetText(format("%.1f", d/1000) .. "k")
			end
			bar.dmgt.val = d
			bar:UpdateTextColors()
		end
	elseif reductions[spellID] and db.profile.icenabled then
		local bar = bars[destName]
		if event == "SPELL_AURA_APPLIED" then
			local _, _, _, _, _, duration, expirationTime = UnitBuff(destName, spellName)
			local start = duration and expirationTime - duration
			if debug and not start then
				start = GetTime()
				duration = random(10)
			end
			if start and start > 0 and duration > 0 then
				bar.cd:SetCooldown(start, duration)
				bar.cd:Show()
			else
				bar.cd:Hide()
			end
			local tex = GetSpellTexture(spellID)
			bar.texpath = tex
			bar.ic:SetTexture(tex)
			bar.ic:Show()
			bar.icActive = 1
		elseif event == "SPELL_AURA_REMOVED" then
			bar.ic:Hide()
			bar.cd:Hide()
			bar.texpath = nil
			bar.icActive = nil
		end
	end
end

function SWH:UNIT_HEALTH(_, unit)
	local destName = UnitName(unit)
	local bar = rawget(bars, destName)
	if bar and bar.active then
		local h = UnitHealth(unit)
		bar.health.val = h
		bar.health:SetText(format("%.1f", h/1000) .. "k")
		bar:UpdateTextColors()
	end
end

function SWH:SlashCommand(str)
	local cmd = SWH:GetArgs(str)
	cmd = strlower(cmd or "")
	if cmd == strlower(L["OPTIONS"]) or cmd == strlower(L["CONFIG"]) or cmd == "options" or cmd == "config" then --allow unlocalized "options" too
		LibStub("AceConfigDialog-3.0"):Open("Sinestra Wrack Helper Options")
	else
		SWH:ToggleLock()
	end
end
SWH:RegisterChatCommand("swh", "SlashCommand")
SWH:RegisterChatCommand("sinestrawrackhelper", "SlashCommand")
SWH:RegisterChatCommand("sinestrawh", "SlashCommand")



