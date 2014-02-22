local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local GUI = PetBattleTeams:GetModule("GUI")
local _

local function OnEvent(self,event)
	if event == "SPELL_UPDATE_COOLDOWN"  then
		local start, duration, enable = GetSpellCooldown(self.spellID)
		CooldownFrame_SetTimer(self.Cooldown, start, duration, enable)
		if ( GameTooltip:GetOwner() == self ) then
			--cheat and use blizzards tooltip setup
			PetJournalHealPetButton_OnEnter(self)
		end
	end
end

local function OnLeave()  
	GameTooltip:Hide() 
end

local function OnShow(self) 
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

local function OnHide(self) 
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
end

function GUI:CreateReviveButton(name,parent)
	local HEAL_PET_SPELL = 125439
	local spellName, spellSubname, spellIcon = GetSpellInfo(HEAL_PET_SPELL)
	local start, duration, enable = GetSpellCooldown(HEAL_PET_SPELL)
	
	button = CreateFrame("Button",parent:GetName()..name,UIParent,"secureactionbuttontemplate")
	button:SetAttribute("type", "spell")
	button.spellID = HEAL_PET_SPELL
	button:SetAttribute("spell",spellName)
	button:SetSize(38,38)
	
	button.Icon = button:CreateTexture(name.."Icon","ARTWORK")
	button.Icon:SetTexture(spellIcon)
	button.Icon:SetAllPoints()
	
	button.Border = button:CreateTexture(name.."Border","OVERLAY","ActionBarFlyoutButton-IconFrame")
	button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square","ADD")
	
	button.Cooldown = CreateFrame("Cooldown", name.."Cooldown",button, "CooldownFrameTemplate")
	CooldownFrame_SetTimer(button.Cooldown, start, duration, enable)
	
	button:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	button:RegisterEvent("PLAYER_REGEN_DISABLED")
	button:RegisterEvent("PLAYER_REGEN_ENABLED")
	
	button:SetScript("OnEvent", OnEvent)
	button:SetScript("OnShow", OnShow)
	button:SetScript("OnHide",OnHide)
	button:SetScript("OnEnter", PetJournalHealPetButton_OnEnter )
	button:SetScript("OnLeave",OnLeave)
	
	return button
end

