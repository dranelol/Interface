-- ----------------------------------------------------------------------------
-- GridIndicatorSideText by Szandos
-- ----------------------------------------------------------------------------
local L = GridIndicatorSideTextLocale
local media = LibStub("LibSharedMedia-3.0", true)

local GridFrame = Grid:GetModule("GridFrame")
GridIndicatorSideText = GridFrame:NewModule("GridIndicatorSideText")

GridIndicatorSideText.defaultDB = {
	SideTextFontSize = 8,
	SideTextFont = "Friz Quadrata TT",
	SideTextOutline = true,
	}

local indicators = GridFrame.prototype.indicators
table.insert(indicators, { type = "sidetexttop", order = 11.5, name = L["Side Text Top"] })
table.insert(indicators, { type = "sidetextright", order = 11.6, name = L["Side Text Right"] })
table.insert(indicators, { type = "sidetextleft", order = 11.7, name = L["Side Text Left"] })
table.insert(indicators, { type = "sidetextbottom", order = 11.8, name = L["Side Text Bottom"] })

local statusmap = GridFrame.db.profile.statusmap
if not statusmap["sidetexttop"] then
	statusmap["sidetexttop"] = {}
	statusmap["sidetextright"] = {}
	statusmap["sidetextleft"] = {}
	statusmap["sidetextbottom"] = {}
end

GridIndicatorSideText.options = {
	type = "group",
	name = L["Side Text"],
	desc = L["Side Text Options."],
	order = 110,
	args = {
		["sidetextfontsize"] = {
			type = "range",
			name = L["Side Text Font Size"],
			desc = L["Adjust the font size for Side Text."],
			order = 111,
			min = 4,
			max = 24,
			step = 1,
			get = function ()
				return GridIndicatorSideText.db.profile.SideTextFontSize
			end,
			set = function (_, v)
				GridIndicatorSideText.db.profile.SideTextFontSize = v
				GridFrame:WithAllFrames(function (f) GridIndicatorSideText:UpdateFont(f) end)
			end,
		},
		["sidetextfont"] = {
			type = "select",
			name = L["Side Text Font"],
			desc = L["Adjust the font setting for Side Text."],
			order = 112,
			values = media:HashTable("font"),
			dialogControl = "LSM30_Font",
			get = function ()
				return GridIndicatorSideText.db.profile.SideTextFont
			end,
			set = function (_, v)
				GridIndicatorSideText.db.profile.SideTextFont = v
				GridFrame:WithAllFrames(function (f) GridIndicatorSideText:UpdateFont(f) end)
			end,
		},
		["sidetextoutline"] = {
			type = "select",
			name = L["Outline Text"],
			desc = L["Use outlined font"],
			order = 113,
			values = { ["NONE"] = L["None"], ["OUTLINE"] = L["Thin"], ["THICKOUTLINE"] = L["Thick"] },
			get = function ()
				return GridIndicatorSideText.db.profile.SideTextOutline
			end,
			set = function (_, v)
				GridIndicatorSideText.db.profile.SideTextOutline = v
				GridFrame:WithAllFrames(function (f) GridIndicatorSideText:UpdateFont(f) end)
			end,
		},
	},
}

function GridIndicatorSideText:OnInitialize()
	GridFrame:RegisterModule(self.moduleName, self)
	
	hooksecurefunc(GridFrame.prototype, "CreateIndicator", GridIndicatorSideText.CreateIndicator)
	hooksecurefunc(GridFrame.prototype, "PositionIndicator", GridIndicatorSideText.PositionIndicator)
	hooksecurefunc(GridFrame.prototype, "SetIndicator", GridIndicatorSideText.SetIndicator)
	hooksecurefunc(GridFrame.prototype, "ClearIndicator", GridIndicatorSideText.ClearIndicator)
end

function GridIndicatorSideText:PositionIndicator(indicator)
	if indicator == "sidetexttop"
	or indicator == "sidetextright"
	or indicator == "sidetextleft"
	or indicator == "sidetextbottom"
	then
		if self[indicator] and self[indicator].Text then
			local borderSize = GridFrame.db.profile.borderSize
			if indicator == "sidetexttop" then
				self[indicator].Text:SetPoint("TOP", self, "TOP",0,-borderSize)
			elseif indicator == "sidetextright" then
				self[indicator].Text:SetPoint("RIGHT", self, "RIGHT",-borderSize,0)
			elseif indicator == "sidetextleft" then
				self[indicator].Text:SetPoint("LEFT", self, "LEFT",borderSize,0)
			elseif indicator == "sidetextbottom" then
				self[indicator].Text:SetPoint("BOTTOM", self, "BOTTOM",0,borderSize)
			end
		end
	end
end

function GridIndicatorSideText:CreateIndicator(indicator)
	if indicator == "sidetexttop" 
	or indicator == "sidetextright"
	or indicator == "sidetextleft"
	or indicator == "sidetextbottom"
	then
		local font = media and media:Fetch("font", GridIndicatorSideText.db.profile.SideTextFont) or STANDARD_TEXT_FONT
		self[indicator].Text = self[indicator]:CreateFontString(nil, "OVERLAY")
		self[indicator].Text:SetFontObject(GameFontHighlightSmall)
		self[indicator].Text:SetFont(font, GridIndicatorSideText.db.profile.SideTextFontSize, GridIndicatorSideText.db.profile.SideTextOutline)
		self[indicator].Text:SetJustifyH("CENTER")
		self[indicator].Text:SetJustifyV("CENTER")
		
		self:PositionIndicator(indicator)
	end
end

function GridIndicatorSideText:SetIndicator(indicator, color, text, value, maxValue, texture, start, duration, stack)
	if indicator == "sidetexttop"
	or indicator == "sidetextright"
	or indicator == "sidetextleft"
	or indicator == "sidetextbottom"
	then
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

function GridIndicatorSideText:ClearIndicator(indicator)
	if indicator == "sidetexttop"
		or indicator == "sidetextright"
		or indicator == "sidetextleft"
		or indicator == "sidetextbottom"
	then
		if self[indicator] then
			self[indicator]:Hide()
		end
	end
end

function GridIndicatorSideText:UpdateFont(f)
	local font = media and media:Fetch("font", GridIndicatorSideText.db.profile.SideTextFont) or STANDARD_TEXT_FONT
	local size = GridIndicatorSideText.db.profile.SideTextFontSize
	local outline = GridIndicatorSideText.db.profile.SideTextOutline
	if f["sidetexttop"] then 
		f["sidetexttop"].Text:SetFont(font, size, outline)
	end
	if f["sidetextright"] then 
		f["sidetextright"].Text:SetFont(font, size, outline)
	end
	if f["sidetextleft"] then 
		f["sidetextleft"].Text:SetFont(font, size, outline)
	end
	if f["sidetextbottom"] then 
		f["sidetextbottom"].Text:SetFont(font, size, outline)
	end
end

function GridIndicatorSideText:Reset()
end
