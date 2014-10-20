local _, AskMrRobot = ...

-- initialize the ItemLink class
AskMrRobot.ItemTooltipFrame = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- item link contructor
function AskMrRobot.ItemTooltipFrame:new(name, parent)
	-- create a new frame
	local o = AskMrRobot.Frame:new(name, parent)

	-- use the ItemTooltipFrame class
	setmetatable(o, { __index = AskMrRobot.ItemTooltipFrame })

	o.tooltipShown = false

	-- initialize the enter/leave scripts for showing the tooltips
	o:SetScript("OnEnter", AskMrRobot.ItemTooltipFrame.OnEnterTooltipFrame)
	o:SetScript("OnLeave", AskMrRobot.ItemTooltipFrame.OnLeaveTooltipFrame)

	-- return the instance of the ItemTooltipFrame
	return o
end

function AskMrRobot.ItemTooltipFrame:OnEnterTooltipFrame()
	if self.itemLink then
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")

		GameTooltip:SetHyperlink(self.itemLink)

		GameTooltip:Show()
		self.tooltipShown = true
	end
end

function AskMrRobot.ItemTooltipFrame:OnLeaveTooltipFrame()
	GameTooltip:Hide()
	self.tooltipShown = false
end

-- set the tooltip from the specified item link
function AskMrRobot.ItemTooltipFrame:SetItemLink(link)
	if self.tooltipShown then
		GameTooltip:Hide()
	end
	self.itemLink = link
end
