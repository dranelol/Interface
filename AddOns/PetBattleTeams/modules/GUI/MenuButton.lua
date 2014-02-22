local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local Config = PetBattleTeams:GetModule("Config","AceConsole-3.0")
local GUI = PetBattleTeams:GetModule("GUI")
local _
local AUTO_HIDE_DELAY = 12

function GUI:CreateMenuButton()
	local button = CreateFrame("BUTTON")
	local menuFrame = CreateFrame("frame", "PetBattleTeamsMenu", UIParent, "UIDropDownMenuTemplate")
	
	
	local options = Config:GetEasyMenu()

	
	button:EnableMouse(true)
	button:SetSize(33,33)
	button:ClearAllPoints()
	
	button.icon = button:CreateTexture("PetBattleTeambuttonButtonIcon","ARTWORK")
	button.icon:SetTexture("Interface\\Icons\\INV_PET_BATTLEPETTRAINING")
	button.icon:SetSize(21,21)
	button.icon:ClearAllPoints()
	button.icon:SetPoint("TOPLEFT",button,"TOPLEFT",7,-6)
	
	button.overlay = button:CreateTexture("PetBattleTeambuttonButtonIcon","OVERLAY")
	button.overlay:SetTexture("Interface\\MiniMap\\MiniMap-TrackingBorder")
	button.overlay:SetSize(56,56)
	button.overlay:ClearAllPoints()
	button.overlay:SetPoint("TOPLEFT",button,"TOPLEFT")
	
	button:SetHighlightTexture("Interface\\MiniMap\\UI-MiniMap-ZoomButton-Highlight","ADD")
	button:RegisterForClicks("LeftButtonUp","RightButtonUp")
	button:SetScript("OnClick", function(self,mouseButton) 		
			if mouseButton == "LeftButton" then
				GUI:ToggleMinimize(not GUI:GetIsMinimized())
			else
				EasyMenu(options, menuFrame, button, 0 , 0, "MENU",AUTO_HIDE_DELAY);
			end
	end)
	return button
end