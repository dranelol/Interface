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

if not Grid or not LibStub then
	return
end

local GridFrame = Grid:GetModule("GridFrame")
local GridIndicatorBar = GridFrame:NewModule("GridIndicatorBar")

local media = LibStub("LibSharedMedia-3.0")
local LibSmooth = LibStub("LibSmoothStatusBar-1.0", true)

local ColorTransparent = { r = 0, g = 0, b = 0, a = 0 }
local settings

GridIndicatorBar.defaultDB = {
	GridIndicatorBar = {
		-- Look
		texture      = "Gradient",
		orientation  = "HORIZONTAL",
		rotateTex    = false,
		-- Colors
		color        = { r = 1, g = 1, b = 1, a = 1 },
		background   = { r = 0, g = 0, b = 0, a = 0.75 },
		colorAlone   = false,
		colorShowBar = false,
		colorIgnore  = false,
		-- Position
		width        = 30,
		height       = 6,
		offsetX      = 0,
		offsetY      = 0,
		frameStrata  = 50,
		-- Text
		textEnable   = false,
		textAlone    = false,
		textShowBar  = false,
		textIgnore   = false,
		textNoColor  = false,
		textFont     = "Friz Quadrata TT",
		textSize     = 12,
		textOutline  = "NONE",
		textShadow   = true,
		textBarColor = false,
		textColor    = { r = 1, g = 1, b = 1, a = 1 },
		textAlign    = "CENTER",
		textLOffset  = 0,
		textROffset  = 0,
		textVOffset  = 0,
		-- Effects
		enableCD     = true,
		cooldownFill = false,
		textStacks   = true,
		textStkApnd  = true,
		hideUseless  = false,
		smooth       = false,
	}
}

Grid.options.args["GridIndicatorBar"] = {
	type = "group",
	name = "Additional Bar",
	desc = "Options for Additional Bar indicator",
	args = {
		["look"] = {
			type = "group",
			name = "Look",
			inline = true,
			order = 10,
			args = {
				["texture"] = {
					type = "select",
					name = "Texture",
					desc = "Texture of each additional bar",
					values = media:HashTable("statusbar"),
					dialogControl = "LSM30_Statusbar",
					order = 10,
					disabled = function() return settings.sameAsGrid end,
					get = function()
						return settings.texture
					end,
					set = function(_, v)
						settings.texture = v
						local texture = media:Fetch("statusbar", v)
						GridFrame:WithAllFrames("SetBar2Texture", texture)
					end,
				},
				["orientation"] = {
					type = "range",
					name = "Orientation",
					desc = "Bar orientation",
					type = "select",
					values = { VERTICAL = "Vertical", HORIZONTAL = "Horizontal" },
					order = 11,
					disabled = function() return settings.sameAsGrid end,
					get = function()
						return settings.orientation
					end,
					set = function(_, v)
						settings.orientation = v
						GridFrame:WithAllFrames("SetBar2Orientation", v)
					end,
				},
				["colorAlone"] = {
					type = "toggle",
					name = "Rotate texture",
					desc = "Rotates the bar texture when displayed in vertical orientation",
					order = 15,
					get = function()
						return settings.rotateTex
					end,
					set = function(_, v)
						settings.rotateTex = v
						GridFrame:WithAllFrames("SetBar2RotatesTexture", v)
					end,
				},
			},
		},
		["colors"] = {
			type = "group",
			name = "Colors",
			inline = true,
			order = 15,
			args = {
				["color"] = {
					type = "color",
					name = "Default color",
					desc = "Bar default color",
					order = 1,
					hasAlpha = true,
					get = function ()
						local color = settings.color
						return color.r, color.g, color.b, color.a
					end,
					set = function (_, r, g, b, a)
						settings.color = { r = r, g = g, b = b, a = a or 1 }
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["background"] = {
					type = "color",
					name = "Background color",
					desc = "Bar background color",
					order = 2,
					hasAlpha = true,
					get = function ()
						local color = settings.background
						return color.r, color.g, color.b, color.a
					end,
					set = function (_, r, g, b, a)
						settings.background = { r = r, g = g, b = b, a = a or 1 }
						GridFrame:WithAllFrames("SetBar2BGColor", settings.background)
					end,
				},
				["break1"] = {
					type = "description",
					order = 3,
					name = "",
				},
				["colorAlone"] = {
					type = "toggle",
					name = "Standalone color",
					desc = "Dissociate the color indicator from the bar indicator. The bar text indicator will now appear as a standalone indicator.",
					order = 4,
					get = function()
						return settings.colorAlone
					end,
					set = function(_, v)
						settings.colorAlone = v
						GridFrame:UpdateOptionsMenu()
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["colorShowBar"] = {
					type = "toggle",
					name = "Show bar",
					desc = "When used as a standalone indicator the color indicator will still show the bar if not already displayed.",
					order = 5,
					disabled = function() return not settings.colorAlone end,
					get = function()
						return settings.colorShowBar
					end,
					set = function(_, v)
						settings.colorShowBar = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["colorIgnore"] = {
					type = "toggle",
					name = "Ignore base value",
					desc = "When used as a standalone indicator the color indicator will ignore colors from the base indicator instead of working as an overriding indicator.",
					order = 6,
					disabled = function() return not settings.colorAlone end,
					get = function()
						return settings.colorIgnore
					end,
					set = function(_, v)
						settings.colorIgnore = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
			},
		},
		["pos"] = {
			type = "group",
			name = "Position",
			inline = true,
			order = 20,
			args = {
				["width"] = {
					type = "range",
					name = "Width",
					desc = "Bar width",
					min = 1,
					max = 100,
					step = 1,
					width = "double",
					order = 10,
					get = function()
						return settings.width
					end,
					set = function(_, v)
						settings.width = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["height"] = {
					type = "range",
					name = "Height",
					desc = "Bar height",
					min = 1,
					max = 100,
					step = 1,
					width = "double",
					order = 11,
					get = function()
						return settings.height
					end,
					set = function(_, v)
						settings.height = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["offsetX"] = {
					type = "range",
					name = "X offset",
					desc = "Horizontal offset",
					min = -200,
					max = 200,
					step = 1,
					width = "double",
					order = 20,
					get = function()
						return settings.offsetX
					end,
					set = function(_, v)
						settings.offsetX = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["offsetY"] = {
					type = "range",
					name = "Y offset",
					desc = "Vertical offset",
					min = -200,
					max = 200,
					step = 1,
					width = "double",
					order = 21,
					get = function()
						return settings.offsetY
					end,
					set = function(_, v)
						settings.offsetY = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["frameStrata"] = {
					type = "range",
					name = "Frame Strata",
					desc = "Level of the bar relative to other indicators",
					min = 0,
					max = 200,
					step = 1,
					width = "double",
					order = 22,
					get = function()
						return settings.frameStrata
					end,
					set = function(_, v)
						settings.frameStrata = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
			}
		},
		["text"] = {
			type = "group",
			name = "Text",
			inline = true,
			order = 25,
			args = {
				["textEnable"] = {
					type = "toggle",
					name = "Enable",
					desc = "Enable bar text display",
					order = 1,
					get = function()
						return settings.textEnable
					end,
					set = function(_, v)
						settings.textEnable = v
						settings.textAlone = false
						GridFrame:UpdateOptionsMenu()
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["break1"] = {
					type = "description",
					order = 10,
					name = "",
				},
				["textAlone"] = {
					type = "toggle",
					name = "Standalone text",
					desc = "Dissociate the text indicator from the bar indicator. The bar text indicator will now appear as a standalone indicator.",
					order = 12,
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textAlone
					end,
					set = function(_, v)
						settings.textAlone = v
						GridFrame:UpdateOptionsMenu()
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["textShowBar"] = {
					type = "toggle",
					name = "Show bar",
					desc = "When used as a standalone indicator the text indicator will still show the bar if not already displayed.",
					order = 13,
					disabled = function() return not settings.textEnable or not settings.textAlone end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textShowBar
					end,
					set = function(_, v)
						settings.textShowBar = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["textIgnore"] = {
					type = "toggle",
					name = "Ignore base value",
					desc = "When used as a standalone indicator the text indicator will ignore text values from the base indicator instead of working as an overriding indicator.",
					order = 14,
					disabled = function() return not settings.textEnable or not settings.textAlone end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textIgnore
					end,
					set = function(_, v)
						settings.textIgnore = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["textNoColor"] = {
					name = "Ignore color",
					desc = "When used as a standalone indicator the text indicator will ignore color values and follow the settings below.",
					order = 15,
					type = "toggle",
					disabled = function() return not settings.textEnable or not settings.textAlone end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textNoColor
					end,
					set = function(_, v)
						settings.textNoColor = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["break2"] = {
					type = "description",
					order = 20,
					hidden = function() return not settings.textEnable end,
					name = "",
				},
				["textFont"] = {
					name = "Font",
					desc = "Adjust the font settings",
					order = 21,
					type = "select",
					values = media:HashTable("font"),
					dialogControl = "LSM30_Font",
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textFont
					end,
					set = function(_, v)
						settings.textFont = v
						GridFrame:WithAllFrames("SetBar2TextFont")
					end,
				},
				["textSize"] = {
					name = "Font Size",
					desc = "Adjust the font size.",
					order = 22,
					type = "range",
					min = 6,
					max = 24,
					step = 1,
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textSize
					end,
					set = function(_, v)
						settings.textSize = v
						GridFrame:WithAllFrames("SetBar2TextFont")
					end,
				},
				["textOutline"] = {
					name = "Font Outline",
					desc = "Adjust the font outline.",
					order = 23,
					type = "select",
					values = { NONE = "None", OUTLINE = "Thin", THICKOUTLINE = "Thick" },
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textOutline
					end,
					set = function(_, v)
						settings.textOutline = v
						GridFrame:WithAllFrames("SetBar2TextFont")
					end,
				},
				["textShadow"] = {
					name = "Font Shadow",
					desc = "Toggle the font drop shadow effect.",
					order = 24,
					type = "toggle",
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textShadow
					end,
					set = function(_, v)
						settings.textShadow = v
						GridFrame:WithAllFrames("SetBar2TextFont")
					end,
				},
				["break3"] = {
					type = "description",
					order = 30,
					hidden = function() return not settings.textEnable end,
					name = "",
				},
				["textColor"] = {
					type = "color",
					name = "Text color",
					desc = "Text default color",
					order = 31,
					hasAlpha = true,
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function ()
						local color = settings.textColor
						return color.r, color.g, color.b, color.a
					end,
					set = function (_, r, g, b, a)
						settings.textColor = { r = r, g = g, b = b, a = a or 1 }
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["textBarColor"] = {
					name = "Use bar color",
					desc = "The text uses the same color as the bar.",
					order = 32,
					type = "toggle",
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textBarColor
					end,
					set = function(_, v)
						settings.textBarColor = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["break4"] = {
					type = "description",
					order = 40,
					hidden = function() return not settings.textEnable end,
					name = "",
				},
				["textAlign"] = {
					name = "Text align",
					desc = "Sets text alignment",
					order = 41,
					type = "select",
					values = { LEFT = "Left", CENTER = "Center", RIGHT = "Right" },
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textAlign
					end,
					set = function(_, v)
						settings.textAlign = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["textLOffset"] = {
					type = "range",
					name = "Left padding",
					desc = "Text left padding",
					min = -100,
					max = 100,
					step = 1,
					order = 51,
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textLOffset
					end,
					set = function(_, v)
						settings.textLOffset = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["textROffset"] = {
					type = "range",
					name = "Right padding",
					desc = "Text right padding",
					min = -100,
					max = 100,
					step = 1,
					order = 52,
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textROffset
					end,
					set = function(_, v)
						settings.textROffset = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
				["textVOffset"] = {
					type = "range",
					name = "Vertical offset",
					desc = "Text vertical offset",
					min = -100,
					max = 100,
					step = 1,
					order = 53,
					disabled = function() return not settings.textEnable end,
					hidden = function() return not settings.textEnable end,
					get = function()
						return settings.textVOffset
					end,
					set = function(_, v)
						settings.textVOffset = v
						GridFrame:WithAllFrames("SetBar2Position")
					end,
				},
			}
		},
		["fx"] = {
			type = "group",
			name = "Effects",
			inline = true,
			order = 30,
			args = {
				["enableCD"] = {
					type = "toggle",
					name = "Enable durations",
					desc = "Enable the use of an animated bar to display durations statuses",
					order = 12,
					get = function()
						return settings.enableCD
					end,
					set = function(_, v)
						settings.enableCD = v
					end,
				},
				["cooldownFill"] = {
					type = "toggle",
					name = "Fill",
					desc = "Fills the bar up instead of draining it when used for durations display",
					order = 13,
					get = function()
						return settings.cooldownFill
					end,
					set = function(_, v)
						settings.cooldownFill = v
					end,
				},
				["break1"] = {
					type = "description",
					order = 20,
					name = "",
				},
				["textStacks"] = {
					type = "toggle",
					name = "Display stacks as text",
					desc = "Display stacks count as text if possible",
					order = 21,
					disabled = function() return not settings.textEnable end,
					get = function()
						return settings.textStacks
					end,
					set = function(_, v)
						settings.textStacks = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["textStkApnd"] = {
					type = "toggle",
					name = "Append stacks",
					desc = "Appends stacks count to text rather than replace it",
					order = 22,
					disabled = function() return not settings.textEnable end,
					get = function()
						return settings.textStkApnd
					end,
					set = function(_, v)
						settings.textStkApnd = v
						GridFrame:WithAllFrames("UpdateBar2")
					end,
				},
				["break2"] = {
					type = "description",
					order = 30,
					name = "",
				},
				["hideUseless"] = {
					type = "toggle",
					name = "Hide bar if only standalone text is available",
					desc = "When text is used as a standalone indicator and nothing is displayed from the base indicator and the Show bar options is checked, shows the text but hides the bar.",
					order = 31,
					width = "double",
					disabled = function() return not settings.textEnable or not settings.textAlone or not settings.textShowBar end,
					get = function()
						return settings.hideUseless
					end,
					set = function(_, v)
						settings.hideUseless = v
						GridFrame:WithAllFrames("UpdateBar2", v)
					end,
				},
				["break3"] = {
					type = "description",
					order = 40,
					name = "",
				},
				["smooth"] = {
					type = "toggle",
					name = "Smooth",
					desc = "Smoothly animates the bar",
					order = 41,
					get = function()
						return settings.smooth
					end,
					set = function(_, v)
						settings.smooth = v
						GridFrame:WithAllFrames("SetBar2Smoothing", v)
					end,
				},
			}
		}
	}
}

if not LibSmooth then
	Grid.options.args["GridIndicatorBar"].args["fx"].args["smooth"] = nil
end

local indicators = GridFrame.prototype.indicators
table.insert(indicators, { type = "bar2", order = 4.5, name = "Additional Bar" })
table.insert(indicators, { type = "bar2color", order = 4.6, name = "Additional Bar Color" })
table.insert(indicators, { type = "bar2text", order = 4.7, name = "Additional Bar Text" })

-------------------------------------------------------------------------------

function GridIndicatorBar:OnInitialize()
	GridFrame:RegisterModule("GridIndicatorBar", self)
	
	local statusmap = GridFrame.db.profile.statusmap
	if not statusmap["bar2"] then
		statusmap["bar2"] = { unit_power = true }
	end
	
	hooksecurefunc(GridFrame, "InitializeFrame", self.InitializeFrame)
	hooksecurefunc(GridFrame, "UpdateOptionsForIndicator", self.UpdateOptionsForIndicator)
	hooksecurefunc(GridFrame.prototype, "SetIndicator", self.SetIndicator)
	hooksecurefunc(GridFrame.prototype, "ClearIndicator", self.ClearIndicator)
	
	settings = GridIndicatorBar.db.profile.GridIndicatorBar
end

function GridIndicatorBar:OnEnable()
end

function GridIndicatorBar:OnDisable()
end

function GridIndicatorBar:Reset()
end

-------------------------------------------------------------------------------

local animating = false
local animated = {}
local animationFrame = CreateFrame("Frame")

local function AnimationTick()
	if #animated == 0 then	
		animating = false
		animationFrame:SetScript("OnUpdate", nil)
		return
	end
	
	for i, frame in ipairs(animated) do
		local state = frame.Bar2State
		if not state.isCooldown then
			state.animating = false
			table.remove(animated, i)
		else
			local start, duration, now = state.cooldownStart, state.cooldownDuration, GetTime()
			local val
			if settings.cooldownFill then
				val = now - start
			else
				val = start + duration - now
			end
			frame:SetBar2(val, state.cooldownDuration)
		end
	end
end

local function StartAnimating(frame)
	local state = frame.Bar2State
	if not state.isCooldown or state.animating then
		return
	end
	
	state.animating = true
	table.insert(animated, frame)
	
	if not animating then
		animating = true
		animationFrame:SetScript("OnUpdate", AnimationTick)
	end
end

-------------------------------------------------------------------------------

function GridIndicatorBar:InitializeFrame(frame)
	local texture = media:Fetch("statusbar", settings.texture)
	frame.Bar2State = {}
	
	frame.Bar2Holder = CreateFrame("Frame", nil, frame)
	frame.Bar2Holder:SetBackdrop({
		bgFile = "Interface\\BUTTONS\\WHITE8X8", tile = true, tileSize = 8,
		edgeFile = "Interface\\BUTTONS\\WHITE8X8", edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	frame.Bar2Holder:SetBackdropBorderColor(0, 0, 0, 1)
	frame:SetBar2BGColor(settings.background)
	frame.Bar2Holder:Hide()
	
	frame.Bar2 = CreateFrame("StatusBar", nil, frame.Bar2Holder)
	frame.Bar2:SetMinMaxValues(0, 100)
	frame.Bar2:SetValue(100)
	
	frame.Bar2Text = frame.Bar2:CreateFontString(nil, "ARTWORK")
	frame:SetBar2TextFont()
	
	frame:SetBar2Position()
	
	frame:SetBar2Orientation(settings.orientation)
	frame:SetBar2Texture(texture)
	frame:SetBar2RotatesTexture(settings.rotateTex)
	frame:SetBar2Smoothing(settings.smooth)
	
	frame:UpdateBar2()
end

function GridIndicatorBar:UpdateOptionsForIndicator(indicator, name, order)
	local menu = Grid.options.args.GridIndicator.args
	if indicator == "bar2color" and not settings.colorAlone then
		menu[indicator] = nil
		return
	end
	if indicator == "bar2text" and not (settings.textEnable and settings.textAlone) then
		menu[indicator] = nil
		return
	end
end

function GridIndicatorBar:SetIndicator(indicator, color, text, value, maxValue, texture, start, duration, stacks)
	if not self.Bar2 then return end
	local state = self.Bar2State
	
	if indicator == "bar2" then
		state.displayed = true
		state.isCooldown = false
		
		if value and maxValue then
			self:SetBar2(value, maxValue)
		elseif start and duration and settings.enableCD then
			state.cooldownStart = start
			state.cooldownDuration = duration
			state.isCooldown = true
			StartAnimating(self)
		else
			self:SetBar2(100, 100)
		end
		
		if type(color) == "table" then
			state.color = color
		end
		
		state.text = text
		state.stacks = stacks
		
		self:UpdateBar2()
	elseif indicator == "bar2color" and type(color) == "table" then
		state.overrideColor = color
		self:UpdateBar2()
	elseif indicator == "bar2text" then
		state.overrideTextDisplayed = true
		state.overrideText = text
		state.overrideTextStacks = stacks
		if type(color) == "table" then
			state.overrideTextColor = color
		end
		self:UpdateBar2()
	end
end

function GridIndicatorBar:ClearIndicator(indicator)
	if not self.Bar2 then return end
	local state = self.Bar2State
	
	if indicator == "bar2" then
		state.displayed = nil
		state.color = nil
		state.text = nil
		state.stacks = nil
		
		state.cooldownStart = nil
		state.cooldownDuration = nil
		state.isCooldown = nil
		self:SetBar2(100, 100)
		self:UpdateBar2()
	elseif indicator == "bar2color" then
		state.overrideColor = nil
		self:UpdateBar2()
	elseif indicator == "bar2text" then
		state.overrideTextDisplayed = nil
		state.overrideText = nil
		state.overrideTextColor = nil
		state.overrideTextStacks = nil
		self:UpdateBar2()
	end
end

-------------------------------------------------------------------------------

function GridFrame.prototype:SetBar2(value, max)
	if max == nil then
		max = 100
	end
	
	self.Bar2:SetMinMaxValues(0, max)
	self.Bar2:SetValue(value)
end

function GridFrame.prototype:SetBar2Position()
	local width, height = settings.width, settings.height
	local textAlign = settings.textAlign
	
	self.Bar2Holder:SetFrameLevel(settings.frameStrata)
	
	self.Bar2Holder:SetPoint("CENTER", self, "CENTER", settings.offsetX, settings.offsetY)
	self.Bar2Holder:SetWidth(width + 2)
	self.Bar2Holder:SetHeight(height + 2)
	
	self.Bar2:SetPoint("CENTER", self.Bar2Holder, "CENTER")
	self.Bar2:SetWidth(width)
	self.Bar2:SetHeight(height)
	
	self.Bar2Text:SetJustifyH(textAlign)
	self.Bar2Text:SetPoint("LEFT", self.Bar2, "LEFT", settings.textLOffset, settings.textVOffset)
	self.Bar2Text:SetPoint("RIGHT", self.Bar2, "RIGHT", -settings.textROffset, settings.textVOffset)
end

function GridFrame.prototype:SetBar2TextFont()
	local font = media:Fetch("font", settings.textFont) or STANDARD_TEXT_FONT
	self.Bar2Text:SetFont(font, settings.textSize, settings.textOutline)
	self.Bar2Text:SetShadowOffset(0, 0)
	if settings.textShadow then
		self.Bar2Text:SetShadowOffset(1, -1)
	end
end

function GridFrame.prototype:SetBar2Orientation(orientation)
	self.Bar2:SetOrientation(orientation)
end

function GridFrame.prototype:SetBar2Texture(texture)
	self.Bar2:SetStatusBarTexture(texture)
end

function GridFrame.prototype:SetBar2RotatesTexture(rotate)
	self.Bar2:SetRotatesTexture(rotate)
end

function GridFrame.prototype:SetBar2Smoothing(smoothing)
	if not LibSmooth then return end
	if smoothing then
		LibSmooth:SmoothBar(self.Bar2)
	else
		LibSmooth:ResetBar(self.Bar2)
	end
end

function GridFrame.prototype:SetBar2BGColor(color)
	self.Bar2Holder:SetBackdropColor(
		color.r,
		color.g,
		color.b,
		color.a
	)
end

-------------------------------------------------------------------------------

function GridFrame.prototype:UpdateBar2()
	local state = self.Bar2State
	local s = settings
	
	-- Visibility
	local display = false
	local useless = false
	
	if state.displayed then
		display = true
	elseif state.overrideColor and s.colorAlone and s.colorShowBar then
		display = true
	elseif state.overrideText and s.textAlone and s.textShowBar then
		display = true
		useless = s.hideUseless
	end
	
	if display ~= state.oldDisplay then
		state.oldDisplay = display
		if display then
			self.Bar2Holder:Show()
		else
			self.Bar2Holder:Hide()
			return
		end
	end
	
	if useless ~= state.useless then
		state.useless = useless
		if useless then
			self.Bar2Holder:SetBackdropBorderColor(0, 0, 0, 0)
			self:SetBar2BGColor(ColorTransparent)
		else
			self.Bar2Holder:SetBackdropBorderColor(0, 0, 0, 1)
			self:SetBar2BGColor(s.background)
		end
	end
	
	-- Color
	local color
	
	if useless then
		color = ColorTransparent
	elseif state.overrideColor and s.colorAlone then
		color = state.overrideColor
	elseif state.color and not (s.colorAlone and s.colorIgnore) then
		color = state.color
	else
		color = s.color
	end
	
	if color ~= state.oldColor then
		state.oldColor = color
		self.Bar2:SetStatusBarColor(
			color.r,
			color.g,
			color.b,
			color.a
		)
	end
	
	-- Text display
	if s.textEnable ~= state.textDisplay then
		state.textDisplay = s.textEnable
		if s.textEnable then
			self.Bar2Text:Show()
		else
			self.Bar2Text:Hide()
		end
	end
	
	if s.textEnable then
		-- Text
		local text
		
		if state.overrideTextDisplayed and s.textAlone then
			text = state.overrideText
			if state.overrideTextStacks and state.overrideTextStacks > 0 and s.textStacks then
				local stacks = tostring(state.overrideTextStacks)
				if text and s.textStkApnd then
					text = text.." ("..stacks..")"
				else
					text = stacks
				end
			end
		elseif state.displayed and not (s.textAlone and s.textIgnore) then
			text = state.text
			if state.stacks and state.stacks > 0 and s.textStacks then
				local stacks = tostring(state.stacks)
				if text and s.textStkApnd then
					text = text.." ("..stacks..")"
				else
					text = stacks
				end
			end
		end
		
		if not text then
			text = ""
		end
		
		if text ~= state.oldText then
			state.oldText = text
			self.Bar2Text:SetText(text)
		end
		
		-- Text color
		local textColor
		
		if state.overrideTextColor and not s.textNoColor and s.textAlone then
			textColor = state.overrideTextColor
		elseif s.textBarColor then
			textColor = useless and s.textColor or color
		else
			textColor = s.textColor
		end
		
		if textColor ~= state.oldTextColor then
			state.oldTextColor = textColor
			self.Bar2Text:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
		end
	end
end
