local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local GUI = PetBattleTeams:GetModule("GUI")
local _


function GUI:CreateLockTeamsButton()
	
	local self = CreateFrame("CheckButton")
	self:SetChecked(false);
	self:SetSize(32,32)
	self:SetNormalTexture("Interface\\Buttons\\LockButton-Locked-Up")
	self:SetPushedTexture("Interface\\Buttons\\LockButton-Unlocked-Down")
	self:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight","ADD")
	self:SetCheckedTexture("Interface\\Buttons\\LockButton-Unlocked-Up")
	
	return self
end