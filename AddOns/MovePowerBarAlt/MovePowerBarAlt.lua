--[[
Moveable PlayerPowerBarAlt Frame
(used in encounters like Atramedes or Cho'gall)

Commands:
/movepowerbaralt
/moveplayerpowerbaralt
/mpba

Source: http://www.mmo-champion.com/threads/811732-Movable-PlayerPowerBarAlt-problem
Credits to Treeston on the MMO-Champion forums
--]]

local p = PlayerPowerBarAlt
local a = CreateFrame("Frame", nil, UIParent)
a:SetSize(50,50)
a:SetPoint("TOP", p, "TOP", 0, 2.5)
a:EnableMouse(true)
p:SetMovable(true)
p:SetUserPlaced(true)
p:SetSize(50,50)
a:SetScript("OnMouseDown", function() p:StartMoving() end)
a:SetScript("OnMouseUp", function() p:StopMovingOrSizing() end)
a.t = a:CreateTexture()
a.t:SetAllPoints()
a.t:SetTexture(0, 0.5, 1)	-- the finest light blue you've ever seen
a.t:SetAlpha(0.8)
a:Hide()

SlashCmdList["MOVEPOWERBARALT"]=function() a[a:IsShown() and "Hide" or "Show"](a) end
SLASH_MOVEPOWERBARALT1 = "/movepowerbaralt"
SLASH_MOVEPOWERBARALT2 = "/moveplayerpowerbaralt"
SLASH_MOVEPOWERBARALT3 = "/mpba"