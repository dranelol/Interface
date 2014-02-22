--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Korvo on US Proudmoore
--  - Idunnô, Clorell, Mcstabin on US Hellscream
--

local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local LSM = LibStub("LibSharedMedia-3.0")

-------------------------------------------------------
-- Proc Cooldown Frame

-- Create Frame
function Proculas:CreateCDFrame()
	self.procCooldowns = self:NewBarGroup(L["Proc Cooldowns"], nil, self.opt.cooldowns.barWidth, self.opt.cooldowns.barHeight, "ProculasProcCD")
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.cooldowns.barFont), self.opt.cooldowns.barFontSize)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, self.opt.cooldowns.colorStart.r, self.opt.cooldowns.colorStart.g, self.opt.cooldowns.colorStart.b, self.opt.cooldowns.colorStart.a)
	self.procCooldowns:SetColorAt(0.25, self.opt.cooldowns.colorEnd.r, self.opt.cooldowns.colorEnd.g, self.opt.cooldowns.colorEnd.b, self.opt.cooldowns.colorEnd.a)
	self.procCooldowns.RegisterCallback(self, "AnchorClicked")
	self.procCooldowns:SetUserPlaced(true)
	self.procCooldowns:ReverseGrowth(self.opt.cooldowns.reverseGrowth)

	if(self.opt.cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end

	self:setMovableCooldownsFrame(self.opt.cooldowns.movableFrame)
end

-- Anchor Clicked
function Proculas:AnchorClicked(...)
	local button = select(3,...)
	if button == "RightButton" then
		self:setMovableCooldownsFrame(false)
	end
end

-- Set Movable
function Proculas:setMovableCooldownsFrame(movable)
	self.opt.cooldowns.movableFrame = movable
	if movable then
		self.procCooldowns:ShowAnchor()
	else
		self.procCooldowns:HideAnchor()
	end
end

-- Update Frame
function Proculas:updateCooldownsFrame()
	self.procCooldowns:SetFont(LSM:Fetch('font', self.opt.cooldowns.barFont), self.opt.cooldowns.barFontSize)
	self.procCooldowns:SetWidth(self.opt.cooldowns.barWidth)
	self.procCooldowns:SetHeight(self.opt.cooldowns.barHeight)
	self.procCooldowns:SetTexture(LSM:Fetch('statusbar', self.opt.cooldowns.barTexture))
	self.procCooldowns:SetColorAt(1.00, self.opt.cooldowns.colorStart.r, self.opt.cooldowns.colorStart.g, self.opt.cooldowns.colorStart.b, self.opt.cooldowns.colorStart.a)
	self.procCooldowns:SetColorAt(0.25, self.opt.cooldowns.colorEnd.r, self.opt.cooldowns.colorEnd.g, self.opt.cooldowns.colorEnd.b, self.opt.cooldowns.colorEnd.a)
	self.procCooldowns:ReverseGrowth(self.opt.cooldowns.reverseGrowth)
	self:setMovableCooldownsFrame(self.opt.cooldowns.movableFrame)
	if(self.opt.cooldowns.show) then
		self.procCooldowns:Show()
	else
		self.procCooldowns:Hide()
	end
end
