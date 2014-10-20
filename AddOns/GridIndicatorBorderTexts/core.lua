local media = LibStub("LibSharedMedia-3.0", true)
local GridFrame = Grid:GetModule("GridFrame")
local addonId = "GridIndicatorBorderTexts"

local addon = GridFrame:NewModule(addonId)

local L = LibStub("AceLocale-3.0"):GetLocale(addonId, true)


local dbEach = {
	TextFontSize = 8,
	TextFont = "Friz Quadrata TT",
	TextOutline = "NONE",
}


local groups = {
	corner = {name=L["GRP_CORNER"], order = 1},
	side = {name=L["GRP_SIDE"], order = 2},
}

local indData = { 
	cornertexttopleft = {name=L["TITLE_TOPLEFT"], ofsX=-1, ofsY=-1, pos="TOPLEFT", grp="corner", ord=1}, 
	cornertexttopright = {name=L["TITLE_TOPRIGHT"], ofsX=1, ofsY=-1, pos="TOPRIGHT", grp="corner", ord=2}, 
	cornertextbottomleft = {name=L["TITLE_BOTTOMLEFT"], ofsX=-1, ofsY=1, pos="BOTTOMLEFT", grp="corner", ord=3}, 
	cornertextbottomright = {name=L["TITLE_BOTTOMRIGHT"], ofsX=1, ofsY=1, pos="BOTTOMRIGHT", grp="corner", ord=4}, 
	sidetexttop = {name=L["TITLE_TOP"], ofsX=0, ofsY=-1, pos="TOP", grp="side", ord=5}, 
	sidetextright = {name=L["TITLE_RIGHT"], ofsX=1, ofsY=0, pos="RIGHT", grp="side", ord=6}, 
	sidetextleft = {name=L["TITLE_LEFT"], ofsX=-1, ofsY=0, pos="LEFT", grp="side", ord=7}, 
	sidetextbottom = {name=L["TITLE_BOTTOM"], ofsX=0, ofsY=1, pos="BOTTOM", grp="side", ord=8},
}


local opargs = {}
for name, data in pairs(indData) do
	local opnum = data.ord
	
	opargs["header_"..name] = {
		type = "header",
		order = opnum,
		width = "full",
		name = data.name,
	}
	opnum = opnum + 0.1

	opargs["fontsize_"..name] = {
		type = "range",
		name = L["FONT_SIZE"],
		desc = L["FONT_SIZE_DESC"],
		order = opnum,
		min = 4,
		max = 24,
		step = 1,
		get = function ()
			return addon.db.profile[name].TextFontSize
		end,
		set = function (_, v)
			addon.db.profile[name].TextFontSize = v
			GridFrame:WithAllFrames(function (f) addon:UpdateFont(f) end)
		end,
	}
	opnum = opnum + 0.1

	opargs["font_"..name] = {
		type = "select",
		name = L["FONT"],
		desc = L["FONT_DESC"],
		order = opnum,
		values = media:HashTable("font"),
		dialogControl = "LSM30_Font",
		get = function ()
			return addon.db.profile[name].TextFont
		end,
		set = function (_, v)
				addon.db.profile[name].TextFont = v
				GridFrame:WithAllFrames(function (f) addon:UpdateFont(f) end)
		end,
	}
	opnum = opnum + 0.1

	opargs["outline"..name] = {
		type = "select",
		name = L["OUTLINE"],
		desc = L["OUTLINE_DESC"],
		order = opnum,
		values = { ["NONE"] = L["OUTLINE_NONE"], ["OUTLINE"] = L["OUTLINE_THIN"], ["THICKOUTLINE"] = L["OUTLINE_THICK"] },
		get = function ()
			return addon.db.profile[name].TextOutline
		end,
		set = function (_, v)
			addon.db.profile[name].TextOutline = v
			GridFrame:WithAllFrames(function (f) addon:UpdateFont(f) end)
		end,
	}

end

local options = {
	type="group",
	name=L["OPTIONS_TITLE"],
	order=110,
	args = opargs,
}

Grid.options.args[addonId] = options

local ddb = {}
for name, _ in pairs(indData) do
	ddb[name] = {}
	for k, v in pairs(dbEach) do
		ddb[name][k] = v
	end
end

addon.defaultDB = ddb

local indicators = GridFrame.prototype.indicators
for name, data in pairs(indData) do
	table.insert(indicators,  {type=name, order=11+data.ord/10, name=data.name})
end

local statusmap = GridFrame.db.profile.statusmap
for name, _ in pairs(indData) do
	if not statusmap[name] then statusmap[name] = {} end
end


function addon:OnInitialize()
	GridFrame:RegisterModule(self.moduleName, self)
	hooksecurefunc(GridFrame, "UpdateOptionsMenu", self.UpdateOptionsMenu)
	self:UpdateOptionsMenu()
	hooksecurefunc(GridFrame.prototype, "CreateIndicator", addon.CreateIndicator)
	hooksecurefunc(GridFrame.prototype, "PositionIndicator", addon.PositionIndicator)
	hooksecurefunc(GridFrame.prototype, "SetIndicator", addon.SetIndicator)
	hooksecurefunc(GridFrame.prototype, "ClearIndicator", addon.ClearIndicator)
end

function addon:UpdateOptionsMenu()
	if not addon:IsEnabled() then return end
	for name, _ in pairs(indData) do
		local dt = Grid.options.args.GridIndicator.args[name]
		if dt ~= nil then
			local grp = indData[name].grp
			local grOpt = Grid.options.args.GridIndicator.args[addonId .. "_" .. grp] 
			if grOpt == nil then
				grOpt = {
					type = "group",
					name = groups[grp].name,
					order = 109.99 + groups[grp].order / 1000,
					args = {},
				}
				Grid.options.args.GridIndicator.args[addonId .. "_" .. grp] = grOpt
			end
			grOpt.args[name] = dt
			Grid.options.args.GridIndicator.args[name] = nil			
		end
	end

	if not Grid.options.args.GridIndicator.args.iconTLcornerleft then return end
	
end

function addon:PositionIndicator(indicator)
	local data = indData[indicator]
	if data ~= nil then
		if self[indicator] and self[indicator].Text then
			local borderSize = GridFrame.db.profile.borderSize
			self[indicator].Text:SetPoint(data.pos, self, data.pos, -borderSize * data.ofsX, borderSize * data.ofsY)
		end
	end
end

function addon:CreateIndicator(indicator)
	if indData[indicator] ~= nil then
		local font = media and media:Fetch("font", addon.db.profile[indicator].TextFont) or STANDARD_TEXT_FONT
		self[indicator].Text = self[indicator]:CreateFontString(nil, "OVERLAY")
		self[indicator].Text:SetFontObject(GameFontHighlightSmall)
		self[indicator].Text:SetFont(font, addon.db.profile[indicator].TextFontSize, addon.db.profile[indicator].TextOutline)
		self[indicator].Text:SetJustifyH("CENTER")
		self[indicator].Text:SetJustifyV("CENTER")
		self:PositionIndicator(indicator)
	end
end

function addon:SetIndicator(indicator, color, text, value, maxValue, texture, start, duration, stack)
	if indData[indicator] ~= nil then
		if not self[indicator] then
			self:CreateIndicator(indicator)
		end
		local text = text:utf8sub(1, GridFrame.db.profile.textlength)
		self[indicator].Text:SetText(text)
		if text and text ~= "" then
			self[indicator]:Show()
		else
			self[indicator]:Hide()
		end
		if color then
			self[indicator].Text:SetTextColor(color.r, color.g, color.b, color.a)
		end
	end
end

function addon:ClearIndicator(indicator)
	if indData[indicator] ~= nil then
		if self[indicator] then
			self[indicator]:Hide()
		end
	end
end

function addon:UpdateFont(f)
	for name, _ in pairs(indData) do
		local font = media and media:Fetch("font", addon.db.profile[name].TextFont) or STANDARD_TEXT_FONT
		local size = addon.db.profile[name].TextFontSize
		local outline = addon.db.profile[name].TextOutline
		if f[name] then f[name].Text:SetFont(font, size, outline) end
	end
end

function addon:Reset()
end
