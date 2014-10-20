local _, AskMrRobot = ...

local primaryGemTexture = "Interface\\ItemSocketingFrame\\UI-ItemSockets";
local engineeringGemTexture = "Interface\\ItemSocketingFrame\\UI-EngineeringSockets";
 
GEM_TYPE_INFO = {
	Yellow = {tex=primaryGemTexture, left=0, right=0.16796875, top=0.640625, bottom=0.80859375, r=0.97, g=0.82, b=0.29, OBLeft=0.7578125, OBRight=0.9921875, OBTop=0, OBBottom=0.22265625},
	Red = {tex=primaryGemTexture, left=0.1796875, right=0.34375, top=0.640625, bottom=0.80859375, r=1, g=0.47, b=0.47, OBLeft=0.7578125, OBRight=0.9921875, OBTop=0.4765625, OBBottom=0.69921875},
	Blue = {tex=primaryGemTexture,left=0.3515625, right=0.51953125, top=0.640625, bottom=0.80859375, r=0.47, g=0.67, b=1, OBLeft=0.7578125, OBRight=0.9921875, OBTop=0.23828125, OBBottom=0.4609375},
	Hydraulic = {tex=engineeringGemTexture, left=0.01562500, right=0.68750000, top=0.50000000, bottom=0.58398438, r=1, g=1, b=1, OBLeft=0.01562500, OBRight=0.93750000, OBTop=0.11132813, OBBottom=0.21679688},
	Cogwheel = {tex=engineeringGemTexture, left=0.01562500, right=0.68750000, top=0.41210938, bottom=0.49609375, r=1, g=1, b=1, OBLeft=0.01562500, OBRight=0.78125000, OBTop=0.31640625, OBBottom=0.40820313},
	Meta = {tex=primaryGemTexture, left=0.171875, right=0.3984375, top=0.40234375, bottom=0.609375, r=1, g=1, b=1, OBLeft=0.7578125, OBRight=0.9921875, OBTop=0, OBBottom=0.22265625},
	Prismatic = {tex=engineeringGemTexture, left=0.01562500, right=0.68750000, top=0.76367188, bottom=0.84765625, r=1, g=1, b=1, OBLeft=0.01562500, OBRight=0.68750000, OBTop=0.58789063, OBBottom=0.67187500}
}

AskMrRobot.GemIcon = AskMrRobot.inheritsFrom(AskMrRobot.ItemIcon)

-- item icon contructor
function AskMrRobot.GemIcon:new(name, parent)
	-- create a new frame (if one isn't supplied)
	local o = AskMrRobot.ItemIcon:new(name, parent)

	-- use the ItemIcon class
	setmetatable(o, { __index = AskMrRobot.GemIcon })

	-- add the overlay for the 
	o.openBracket = o:CreateTexture(nil, "ARTWORK")
	o.openBracket:SetPoint("TOPLEFT")
	o.openBracket:SetPoint("BOTTOMRIGHT")

	-- return the instance of the GemIcon
	return o
end

function AskMrRobot.GemIcon:UpdateGemStuff()
	local info = GEM_TYPE_INFO[self.color]

	if self.itemLink then
		-- hide the 2nd half of the empty gem icon
		self.openBracket:Hide()

		if info then
			self:SetBackdropBorderColor(info.r, info.g, info.b)			
		end
	else
		if info then
			-- set the empty gem background texture		
			self.itemIcon:SetTexture(info.tex)
			self.itemIcon:SetTexCoord(info.left, info.right, info.top, info.bottom)

			-- set the empty gem overlay
			self.openBracket:SetTexture(info.tex)
			self.openBracket:SetTexCoord(info.OBLeft, info.OBRight, info.OBTop, info.OBBottom)
			self.openBracket:Show()

			--hide the border (the empty gem icon has a border)
			self:SetBackdropBorderColor(0,0,0,0)

			-- set the empty gem background texture		
			self.itemIcon:SetTexture(info.tex)
			self.itemIcon:SetTexCoord(info.left, info.right, info.top, info.bottom)

			-- set the empty gem overlay
			self.openBracket:SetTexture(info.tex)
			self.openBracket:SetTexCoord(info.OBLeft, info.OBRight, info.OBTop, info.OBBottom)
			self.openBracket:Show()
		else
			self.openBracket:Hide()
		end

		self:SetBackdropBorderColor(0,0,0,0)
	end

end

function AskMrRobot.GemIcon:SetItemLink(link)
	AskMrRobot.ItemIcon.SetItemLink(self, link)
	self:UpdateGemStuff()
end

function AskMrRobot.GemIcon:SetGemColor(color)
	self.color = color
	self:UpdateGemStuff()
end