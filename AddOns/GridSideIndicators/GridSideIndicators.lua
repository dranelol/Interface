local L = GridSideIndicators_Locales
local GridFrame = Grid:GetModule("GridFrame")

GridSIFrame = GridFrame:NewModule("GridSideIndicators")

local indicators = GridFrame.prototype.indicators
table.insert(indicators, { type = "side1", order = 15, name = L["Top Side"] })
table.insert(indicators, { type = "side2", order = 18, name = L["Right Side"] })
table.insert(indicators, { type = "side3", order = 16, name = L["Bottom Side"] })
table.insert(indicators, { type = "side4", order = 17, name = L["Left Side"] })

local statusmap = GridFrame.db.profile.statusmap
if ( not statusmap["side1"] ) then
	statusmap["side1"] = { player_target = true }
	statusmap["side2"] = {}
	statusmap["side3"] = {}
	statusmap["side4"] = {}
end



function GridSIFrame:PositionIndicator(indicator)
	local f = self[indicator]
	if f then
		local borderSize = GridFrame.db.profile.borderSize
		-- position indicator wherever needed
		if indicator == "side1" then
			-- top
			f:SetPoint("TOP", self, "TOP", 0, -borderSize)
		elseif indicator == "side2" then
			-- right
			f:SetPoint("RIGHT", self, "RIGHT", -borderSize, 0)
		elseif indicator == "side3" then
			-- bottom
			f:SetPoint("BOTTOM", self, "BOTTOM", 0, borderSize)
		elseif indicator == "side4" then
			-- left
			f:SetPoint("LEFT", self, "LEFT", borderSize, 0)
		end
	end
end



function GridSIFrame:SetIndicator(indicator, color, text, value, maxValue, texture, start, duration, stack)
	if indicator == "side1"
	or indicator == "side2"
	or indicator == "side3"
	or indicator == "side4"
	then
		-- create indicator on demand if not available yet
		if not self[indicator] then
			self:CreateIndicator(indicator)
		end
		if not color then color = { r = 1, g = 1, b = 1, a = 1 } end
		self[indicator]:SetBackdropColor(color.r, color.g, color.b, color.a)
		self[indicator]:Show()
	end
end



function GridSIFrame:ClearIndicator(indicator)
	if indicator == "side1"
	or indicator == "side2"
	or indicator == "side3"
	or indicator == "side4"
	then
		if self[indicator] then
			self[indicator]:SetBackdropColor(1, 1, 1, 1)
			self[indicator]:Hide()
		end
	end
end



function GridSIFrame:SetCornerSize(size)
	for x = 1, 4 do
		local indicator = "side"..x
		if self[indicator] then
			self[indicator]:SetHeight(size)
			self[indicator]:SetWidth(size)
		end
	end
end



function GridSIFrame:OnInitialize()
    if not self.db then
        self.db = Grid.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
    end
    Grid:Debug("init GridSideIndicators")
    
    --hook the functions we need.
    hooksecurefunc(GridFrame.prototype, "PositionIndicator", GridSIFrame.PositionIndicator)
    hooksecurefunc(GridFrame.prototype, "SetIndicator", GridSIFrame.SetIndicator)
    hooksecurefunc(GridFrame.prototype, "ClearIndicator", GridSIFrame.ClearIndicator)
    hooksecurefunc(GridFrame.prototype, "SetCornerSize", GridSIFrame.SetCornerSize)
end



function GridSIFrame:Reset()
end
