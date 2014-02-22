-- -------------------------------------------------------------------------- --
-- GridIndicatorText3 by kunda                                                --
-- -------------------------------------------------------------------------- --

local L = GridIndicatorText3_Locales

local Grid = Grid

local GridFrame = Grid:GetModule("GridFrame")
local GridIndicatorText3 = GridFrame:NewModule("GridIndicatorText3", "AceEvent-3.0")
local media = LibStub("LibSharedMedia-3.0", true)
local hasMediaWidgets = media and LibStub("AceGUISharedMediaWidgets-1.0", true)

local configMode = false

GridIndicatorText3.defaultDB = {
	Text3fontSize = 8,
	Text3font = "Friz Quadrata TT",
	Text3OriginalSize = true,
	Text3Offset = 0,
}

local options = {
	type = "group",
	--inline = true,
	icon = "Interface\\AddOns\\GridIndicatorText3\\GridIndicatorText3-icon-text",
	name = L["Center Text 3 (Middle)"],
	desc = L["Options for Center Text 3 (Middle)."],
	disabled = function() return not GridFrame.db.profile.enableText2 end,
	order = -0.591,--110,
	args = {
		["configuration"] = {
			type = "toggle",
			name = L["Configuration Mode"],
			desc = L["Configuration Mode"]..".",
			order = 110.1,
			get = function(self) return configMode end,
			set = function(_, v)
				configMode = v
				for _, f in pairs(GridFrame.registeredFrames) do
					GridIndicatorText3:GridIndicatorText3Config(f)
				end
			end
		},
		["header1"] = {
			type = "header",
			order = 110.2,
			width = "full",
			name = "",
		},
		["text3offset"] = {
			type = "range",
			name = L["Offset"],
			desc = L["Adjust the offset for Center Text 3 (Middle)."],
			order = 110.3,
			min = -20,
			max = 20,
			step = 1,
			get = function()
				return GridIndicatorText3.db.profile.Text3Offset
			end,
			set = function(_, v)
				GridIndicatorText3.db.profile.Text3Offset = v
				local font     = media and media:Fetch("font", GridIndicatorText3.db.profile.Text3font) or STANDARD_TEXT_FONT
				local fontsize = GridIndicatorText3.db.profile.Text3fontSize
				if GridIndicatorText3.db.profile.Text3OriginalSize then
					font     = media and media:Fetch("font", GridFrame.db.profile.font) or STANDARD_TEXT_FONT
					fontsize = GridFrame.db.profile.fontSize
				end
				for _, f in pairs(GridFrame.registeredFrames) do
					GridIndicatorText3.SetFrameFont(f, font, fontsize, "text3")
				end
				if configMode then
					for _, f in pairs(GridFrame.registeredFrames) do
						GridIndicatorText3:GridIndicatorText3Config(f)
					end
				end
			end,
		},
		["text3originalsize"] = {
			type = "toggle",
			name = L["Same font and font size as Grid standard"],
			desc = L["If enabled, the font and font size of the Text 3 indicator is adjustable with the standard Grid font options. If deactivated, you can set an individual font and font size for the Text 3 indicator."],
			order = 110.4,
			width = "full",
			get = function()
				return GridIndicatorText3.db.profile.Text3OriginalSize
			end,
			set = function(_, v)
				GridIndicatorText3.db.profile.Text3OriginalSize = v
				local font     = media and media:Fetch("font", GridIndicatorText3.db.profile.Text3font) or STANDARD_TEXT_FONT
				local fontsize = GridIndicatorText3.db.profile.Text3fontSize
				if GridIndicatorText3.db.profile.Text3OriginalSize then
					font     = media and media:Fetch("font", GridFrame.db.profile.font) or STANDARD_TEXT_FONT
					fontsize = GridFrame.db.profile.fontSize
				end
				for _, f in pairs(GridFrame.registeredFrames) do
					GridIndicatorText3.SetFrameFont(f, font, fontsize, "text3")
				end
				if configMode then
					for _, f in pairs(GridFrame.registeredFrames) do
						GridIndicatorText3:GridIndicatorText3Config(f)
					end
				end
			end,
		},
		["text3fontsize"] = {
			type = "range",
			name = L["Font Size"],
			desc = L["Adjust the font size for Center Text 3 (Middle)."],
			order = 110.5,
			disabled = function() return GridIndicatorText3.db.profile.Text3OriginalSize end,
			min = 6,
			max = 24,
			step = 1,
			get = function()
				return GridIndicatorText3.db.profile.Text3fontSize
			end,
			set = function(_, v)
				GridIndicatorText3.db.profile.Text3fontSize = v
				local font = media and media:Fetch('font', GridIndicatorText3.db.profile.Text3font) or STANDARD_TEXT_FONT
				for _, f in pairs(GridFrame.registeredFrames) do
					GridIndicatorText3.SetFrameFont(f, font, v, "text3")
				end
				if configMode then
					for _, f in pairs(GridFrame.registeredFrames) do
						GridIndicatorText3:GridIndicatorText3Config(f)
					end
				end
			end,
		}
	}
}

if media then
	options.args["text3font"] = {
		type = "select",
		name = L["Font"],
		desc = L["Adjust the font setting for Center Text 3 (Middle)."],
		order = 110.6,
		disabled = function() return GridIndicatorText3.db.profile.Text3OriginalSize end,
		values = media:HashTable("font"),
		dialogControl = hasMediaWidgets and "LSM30_Font",
		get = function()
			return GridIndicatorText3.db.profile.Text3font
		end,
		set = function(_, v)
			GridIndicatorText3.db.profile.Text3font = v
			local font = media:Fetch("font", v)
			local fontsize = GridIndicatorText3.db.profile.Text3fontSize
			for _, f in pairs(GridFrame.registeredFrames) do
				GridIndicatorText3.SetFrameFont(f, font, fontsize, "text3")
			end
			if configMode then
				for _, f in pairs(GridFrame.registeredFrames) do
					GridIndicatorText3:GridIndicatorText3Config(f)
				end
			end
		end,
	}
end
Grid.options.args["GridIndicatorText3"] = options


local indicators = GridFrame.prototype.indicators
table.insert(indicators, { type = "text3", order = 5.5, name = L["Center Text 3 (Middle)"] })

local statusmap = GridFrame.db.profile.statusmap
if not statusmap["text3"] then
	statusmap["text3"] = {}
end

function GridIndicatorText3:OnInitialize()
	GridIndicatorText3.ConfigWarningFrame = CreateFrame("Frame", nil, UIParent)
	GridIndicatorText3.ConfigWarningFrame:EnableMouse(true)
	GridIndicatorText3.ConfigWarningFrame:SetMovable(true)
	GridIndicatorText3.ConfigWarningFrame:SetResizable(true)
	GridIndicatorText3.ConfigWarningFrame:SetToplevel(true)
	GridIndicatorText3.ConfigWarningFrame:SetClampedToScreen(true)
	GridIndicatorText3.ConfigWarningFrame:SetHeight(44)
	GridIndicatorText3.ConfigWarningFrame:SetPoint("LEFT", GridLayoutFrame, "RIGHT", 20, 0)
	GridIndicatorText3.ConfigWarningFrame:Hide()
	GridIndicatorText3.ConfigWarningBackground = GridIndicatorText3.ConfigWarningFrame:CreateTexture(nil, "BACKGROUND")
	GridIndicatorText3.ConfigWarningBackground:SetAllPoints(GridIndicatorText3.ConfigWarningFrame)
	GridIndicatorText3.ConfigWarningBackground:SetTexture(0, 0, 0, 1)
	GridIndicatorText3.ConfigWarningButton = CreateFrame("Button", nil, GridIndicatorText3.ConfigWarningFrame, "UIPanelButtonTemplate")
	GridIndicatorText3.ConfigWarningButton:SetHeight(24)
	GridIndicatorText3.ConfigWarningButton:SetPoint("LEFT", GridIndicatorText3.ConfigWarningFrame, "LEFT", 10, 0)
	GridIndicatorText3.ConfigWarningButton:SetText(L["Center Text 3 (Middle)"].."  |TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:17.5:20:0:0:64:64:0:64:0:56|t  "..L["Configuration Mode"])
	GridIndicatorText3.ConfigWarningButton:SetScript("OnClick", function()
		configMode = false
		for _, f in pairs(GridFrame.registeredFrames) do
			GridIndicatorText3:GridIndicatorText3Config(f)
		end
	end)
	local w = GridIndicatorText3.ConfigWarningButton:GetTextWidth()
	GridIndicatorText3.ConfigWarningButton:SetWidth(w+50)
	GridIndicatorText3.ConfigWarningFrame:SetWidth(w+50+20)

	GridFrame:RegisterModule(self.moduleName, self)
	
	-- hack for better indicator menu
	hooksecurefunc(GridFrame, "UpdateOptionsMenu", self.CleanOptionsMenu)
	self:CleanOptionsMenu()

	hooksecurefunc(GridFrame.prototype, "ClearIndicator", self.ClearIndicator)
	hooksecurefunc(GridFrame.prototype, "CreateIndicator", self.CreateIndicator)
	hooksecurefunc(GridFrame.prototype, "SetIndicator", self.SetIndicator)
	hooksecurefunc(GridFrame.prototype, "SetFrameFont", self.SetFrameFont)
	hooksecurefunc(GridFrame.prototype, "PlaceIndicators", self.PlaceIndicators)
end

function GridIndicatorText3:OnEnable()
end

function GridIndicatorText3:OnDisable()
end

function GridIndicatorText3:Reset()
end

function GridIndicatorText3:CleanOptionsMenu()
	if not GridIndicatorText3:IsEnabled() then return end
	if not Grid.options then return end
	if not Grid.options.args then return end
	local GridIndicator
	if     type(Grid.options.args.GridIndicator) == "table" then GridIndicator = "GridIndicator"
	elseif type(Grid.options.args.Indicators)    == "table" then GridIndicator = "Indicators" end
	if not Grid.options.args[GridIndicator] then return end
	if not Grid.options.args[GridIndicator].args then return end

	if not Grid.options.args[GridIndicator].args.text3 then return end

	Grid.options.args[GridIndicator].args["text3"].icon = "Interface\\AddOns\\GridIndicatorText3\\GridIndicatorText3-icon-text"

	if not GridFrame.db.profile.enableText2 then
		Grid.options.args[GridIndicator].args["text3"].disabled = true
	else
		Grid.options.args[GridIndicator].args["text3"].disabled = false
	end

	for _, f in pairs(GridFrame.registeredFrames) do
		GridIndicatorText3.PlaceIndicators(f)
	end
end

function GridIndicatorText3:GridIndicatorText3Config(frame)
	if configMode then
		GridIndicatorText3.ConfigWarningFrame:Show()
		self.SetIndicator(frame, "text3", {r=1, g=1, b=1, a=1}, "test123")
	else
		GridIndicatorText3.ConfigWarningFrame:Hide()
		self.ClearIndicator(frame, "text3")
		--if GridFrame.db.profile.enableText2 then
			GridFrame:UpdateAllFrames()
		--end
	end
end

function GridIndicatorText3.PlaceIndicators(frame)
	if frame.Text3 then
		if GridFrame.db.profile.enableText2 then
			if GridFrame.db.profile.textorientation == "VERTICAL" then
				frame.Text3:SetPoint("CENTER", frame, "CENTER", GridIndicatorText3.db.profile.Text3Offset, 0)
			else
				frame.Text3:SetPoint("CENTER", frame, "CENTER", 0, GridIndicatorText3.db.profile.Text3Offset)
			end
			frame.Text3:Show()
		else
			frame.Text3:Hide()
		end
	end
end

function GridIndicatorText3.CreateIndicator(f, indicator)
	if indicator == "text3" then
		local font     = media and media:Fetch("font", GridIndicatorText3.db.profile.Text3font) or STANDARD_TEXT_FONT
		local fontsize = GridIndicatorText3.db.profile.Text3fontSize
		if GridIndicatorText3.db.profile.Text3OriginalSize then
			font     = media and media:Fetch("font", GridFrame.db.profile.font) or STANDARD_TEXT_FONT
			fontsize = GridFrame.db.profile.fontSize
		end

		f.Text3 = f.Bar:CreateFontString(nil, "ARTWORK")
		f.Text3:SetFontObject(GameFontHighlightSmall)
		f.Text3:SetFont(font, fontsize)
		f.Text3:SetJustifyH("CENTER")
		f.Text3:SetJustifyV("CENTER")
		
		if GridFrame.db.profile.textorientation == "VERTICAL" then
			f.Text3:SetPoint("CENTER", f, "CENTER", GridIndicatorText3.db.profile.Text3Offset, 0)
		else
			f.Text3:SetPoint("CENTER", f, "CENTER", 0, GridIndicatorText3.db.profile.Text3Offset)
		end

		f.Text3:Hide()
	end
end

function GridIndicatorText3.SetIndicator(frame, indicator, color, text, value, maxValue, texture, start, duration, stack)
	if indicator == "text3" then
		if not frame.Text3 then
			frame.CreateIndicator(frame, indicator)
		end
		local text = text:utf8sub(1, GridFrame.db.profile.textlength)
		frame.Text3:SetText(text)
		if text and text ~= "" then
			frame.Text3:Show()
		else
			frame.Text3:Hide()
		end
		if color then
			frame.Text3:SetTextColor(color.r, color.g, color.b, color.a)
		end
		GridIndicatorText3.PlaceIndicators(frame)
	end
end

function GridIndicatorText3.ClearIndicator(frame, indicator)
	if indicator == "text3" then
		if frame.Text3 then
			frame.Text3:SetText("")
			frame.Text3:Hide()
		end
	end
end

function GridIndicatorText3.SetFrameFont(frame, font, size, check)
	if check and check == "text3" then
		if frame.Text3 then
			if GridFrame.db.profile.textorientation == "VERTICAL" then
				frame.Text3:SetPoint("CENTER", frame, "CENTER", GridIndicatorText3.db.profile.Text3Offset, 0)
			else
				frame.Text3:SetPoint("CENTER", frame, "CENTER", 0, GridIndicatorText3.db.profile.Text3Offset)
			end
			frame.Text3:SetFont(font, size)
		end
	else
		if frame.Text3 then
			local font     = media and media:Fetch("font", GridIndicatorText3.db.profile.Text3font) or STANDARD_TEXT_FONT
			local fontsize = GridIndicatorText3.db.profile.Text3fontSize
			if GridIndicatorText3.db.profile.Text3OriginalSize then
				font     = media and media:Fetch("font", GridFrame.db.profile.font) or STANDARD_TEXT_FONT
				fontsize = GridFrame.db.profile.fontSize
			end
			if GridFrame.db.profile.textorientation == "VERTICAL" then
				frame.Text3:SetPoint("CENTER", frame, "CENTER", GridIndicatorText3.db.profile.Text3Offset, 0)
			else
				frame.Text3:SetPoint("CENTER", frame, "CENTER", 0, GridIndicatorText3.db.profile.Text3Offset)
			end
			frame.Text3:SetFont(font, fontsize)
		end
	end
end