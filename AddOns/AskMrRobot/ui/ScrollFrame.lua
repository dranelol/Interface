local _, AskMrRobot = ...

-- initialize the ScrollFrame class (inherit from a dummy frame)
AskMrRobot.ScrollFrame = AskMrRobot.inheritsFrom(CreateFrame("ScrollFrame"))

function AskMrRobot.ScrollFrame:OnMouseWheel(value)
	local currentValue = self.scrollbar:GetValue()
	if value < 0 then
		currentValue = currentValue + 15
	else
		currentValue = currentValue - 15
	end
	self.scrollbar:SetValue(currentValue)
end

function AskMrRobot.ScrollFrame:RecalcScrollbar()
	self.scrollbar:SetMinMaxValues(0, self.content:GetHeight() * 100 / self:GetHeight())
end

function AskMrRobot.ScrollFrame:OnSizeChanged(width, height)
	self.content:SetWidth(width)
	self:RecalcScrollbar()
end

-- ScrollFrame contructor
function AskMrRobot.ScrollFrame:new(name, parentFrame)
	-- create a new frame (if one isn't supplied)
	local scrollframe = CreateFrame("ScrollFrame", name, parentFrame)

	-- use the ScrollFrame class
	setmetatable(scrollframe, { __index = AskMrRobot.ScrollFrame })

	scrollframe:EnableMouseWheel(true)
	scrollframe:SetScript("OnMouseWheel", AskMrRobot.ScrollFrame.OnMouseWheel)
	scrollframe:SetScript("OnSizeChanged", AskMrRobot.ScrollFrame.OnSizeChanged)

	local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate" )
	scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 4, -16) 
	scrollbar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", 4, 16)
	scrollbar:SetMinMaxValues(0, 100) 
	scrollbar:SetValueStep(10)
	scrollbar.scrollStep = 10
	scrollbar:SetValue(0) 
	scrollbar:SetWidth(16) 
	scrollbar:SetScript("OnValueChanged", 
	function (self, value) 
		self:GetParent():SetVerticalScroll(value)
	end)
	scrollbar:Enable()
	scrollbar:SetOrientation("VERTICAL");
	scrollbar:Show()
	scrollframe.scrollbar = scrollbar	

	--content frame 
	local content = AskMrRobot.Frame:new(nil, scrollframe)
	scrollframe.content = content

	scrollframe:SetScrollChild(content)

	content:SetScript('OnSizeChanged', function(a, width, height)
		scrollframe:RecalcScrollbar()
	end)

	-- return the instance of the ScrollFrame
	return scrollframe
end