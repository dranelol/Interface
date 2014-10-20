local _, AskMrRobot = ...

-- initialize the Frame class (inherit from a dummy frame)
AskMrRobot.FontString = AskMrRobot.inheritsFrom(AskMrRobot.Frame:new():CreateFontString(nil, "ARTWORK", "GameFontNormal"))

-- Frame contructor
function AskMrRobot.FontString:new(parentFrame, name, layer, style, fontSize)

	local o = parentFrame:CreateFontString(name, layer, style)	-- create a new frame (if one isn't supplied)

	-- use the fontstring class
	setmetatable(o, { __index = AskMrRobot.FontString })

	if fontSize then
		o:SetFontSize(fontSize)
	end

	return o
end

function AskMrRobot.FontString:SetFontSize(fontSize)
	local file, _, flags = self:GetFont()
	self:SetFont(file, fontSize, flags)
end

function AskMrRobot.FontString:IncreaseFontSize(add)
	local file, fontSize, flags = self:GetFont()
	self:SetFont(file, fontSize + add, flags)
end

function AskMrRobot.SetFontSize(fontString, fontSize)
	local file, _, flags = fontString:GetFont()
	fontString:SetFont(file, fontSize, flags)
end