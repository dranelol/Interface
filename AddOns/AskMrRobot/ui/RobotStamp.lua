local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the RobotStamp class (inherit from Frame)
AskMrRobot.RobotStamp = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- item icon contructor
function AskMrRobot.RobotStamp:new(name, parent)
	-- create a new frame (if one isn't supplied)
	local o = AskMrRobot.Frame:new(name, parent)

	-- use the RobotStamp class
	setmetatable(o, { __index = AskMrRobot.RobotStamp })

	o:SetPoint("TOPLEFT", parent, "TOPLEFT")
	o:SetPoint("RIGHT", parent, "RIGHT")
	o:SetHeight(80);

	o.bigText = o:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	o.bigText:SetTextColor(7/255, 166/255, 11/255)
	local file, _, flags = o.bigText:GetFont()
	o.bigText:SetFont(file, 24, flags)
	o.bigText:SetText(L.AMR_ROBOTSTAMP_TEXT)
	o.bigText:SetPoint("TOPLEFT", o, "TOPLEFT", 15, -20)
	o.bigText:SetPoint("RIGHT", o, "RIGHT", -15, 0)

	o.smallText = o:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	o.smallText:SetText(AMR_ROBOTSTAMP_GEMS)
	o.smallText:SetPoint("TOPLEFT", o.bigText, "BOTTOMLEFT", 0, -7)
	o.smallText:SetPoint("RIGHT", o, "RIGHT", -15, 0)
	o.smallText:SetWidth(o.smallText:GetWidth())
	o.smallText:SetJustifyH("CENTER")

	o:SetBackdrop({edgeFile = "Interface\\AddOns\\AskMrRobot\\Media\\round-edge-big", edgeSize = 16})
	o:SetBackdropBorderColor(7/255, 166/255, 11/255)

	-- return the instance of the RobotStamp
	return o
end