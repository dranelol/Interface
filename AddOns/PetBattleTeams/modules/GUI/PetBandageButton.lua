local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local GUI = PetBattleTeams:GetModule("GUI")
local _

local function OnEvent(self,event)
	local itemCount = GetItemCount(86143)
	self.QuantityOwned:SetText(itemCount)
	self.Icon:SetDesaturated(itemCount <= 0 )
end

local function OnLeave()  
	GameTooltip:Hide() 
end

local function OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetItemByID(86143) 
end

local function OnShow(self) 
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

local function OnHide(self) 
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
end

function GUI:CreateBandageButton(name,parent)
	
	local itemName = "Battle Pet Bandage"
	local icon = GetItemIcon(86143)
	local itemCount = GetItemCount(86143)
	local button = CreateFrame("Button",parent:GetName()..name,UIParent,"secureactionbuttontemplate")
	button:SetAttribute("unit", "player")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext","/use item:86143" )
	
	button:SetSize(38,38)
	
	button.Icon = button:CreateTexture(name.."Icon","ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:SetAllPoints()
	
	button.Border = button:CreateTexture(name.."Border","OVERLAY","ActionBarFlyoutButton-IconFrame")
	button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square","ADD")
	
	button.QuantityOwned = button:CreateFontString(nil,"OVERLAY","GameFontHighlight")
	button.QuantityOwned:SetText(itemCount)
	button.QuantityOwned:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button.QuantityOwned:SetJustifyH("RIGHT")
	
	button:SetScript("OnEvent", OnEvent)
	button:SetScript("OnShow", OnShow)
	button:SetScript("OnHide",OnHide)
	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave",OnLeave)
	button:RegisterEvent("BAG_UPDATE")
	
	return button
end

