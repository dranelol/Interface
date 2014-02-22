local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local Tooltip = PetBattleTeams:NewModule("Tooltip")
local teamManager = PetBattleTeams:GetModule("TeamManager")
local _
local libPetBreedInfo = LibStub("LibPetBreedInfo-1.0")


local nameFormat = "|c%s%s|r"
local nameBreedFormat = "|c%s%s|r %s%s|r"
local function GetColor(confidence)
	if confidence and confidence < 2.5 then
		return "|cff888888"
	end
	return "|cffffcc00"
end


function Tooltip:OnInitialize()
	
	local defaults = {
		global = {
			ShowHelpText = true,
			ShowBreedInfo = false,
		}
	}

	-- Assuming the .toc says ## SavedVariables: MyAddonDB
	local db = LibStub("AceDB-3.0"):New("PetBattleTeamsDB", {} , true)
	local name = self:GetName()
	self.db = db:RegisterNamespace(name, defaults)
	
	
	
	
	self.tooltip =  CreateFrame("frame","PetBattleTeamsTooltip",nil,"PetBattleUnitTooltipTemplate")
	local tooltip = self.tooltip
	tooltip:SetHeight(215)
	
	
	--icon quality glow
	tooltip.rarityGlow = tooltip:CreateTexture("PetBattleTeamTooltipGlow","OVERLAY")
	tooltip.rarityGlow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	tooltip.rarityGlow:SetBlendMode("ADD")
	tooltip.rarityGlow:ClearAllPoints()
	tooltip.rarityGlow:SetDrawLayer("OVERLAY", 0)
	tooltip.rarityGlow:SetWidth(tooltip.Icon:GetWidth() * 1.7)
	tooltip.rarityGlow:SetHeight(tooltip.Icon:GetHeight() * 1.7)
	tooltip.rarityGlow:SetPoint("CENTER", tooltip.Icon, "CENTER", 0, 0)
	
	--team indicator
	tooltip.teamText = tooltip:CreateFontString("PetBattleTeamTooltipTeamText","OVERLAY","GameFontNormalSmall")
	tooltip.teamText:SetJustifyH("LEFT")
	tooltip.teamText:SetText("Team XX") 
	tooltip.teamText:SetTextColor(1,1,1)
	tooltip.teamText:SetSize(0,0)
	tooltip.teamText:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
	tooltip.teamText:SetPoint("BOTTOMLEFT",tooltip.Name,"TOPLEFT",0,2)
	tooltip.teamText:SetPoint("BOTTOMRIGHT",tooltip.Name,"TOPRIGHT",0,2)
	
	--Helper Text
	tooltip.helpText = tooltip:CreateFontString("PetBattleTeamTooltipHelperText","OVERLAY","GameFontNormalSmall")
	tooltip.helpText:SetJustifyH("LEFT")
	tooltip.helpText:SetText("Drag to swap pets between teams.|nShift-Drag to copy pet to a new team.|nControl-Drag to move team.")
	tooltip.helpText:SetTextColor(0,1,0)
	tooltip.helpText:SetSize(0,0)
	tooltip.helpText:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
	tooltip.helpText:SetPoint("BOTTOMLEFT",tooltip,"BOTTOMLEFT",6,6)
	tooltip.helpText:SetPoint("BOTTOMRIGHT",tooltip,"BOTTOMRIGHT",-6,6)

	--template parts
	tooltip.AbilitiesLabel:Show()
	tooltip.XPBar:Show()
	tooltip.XPBG:Show()
	tooltip.XPBorder:Show()
	tooltip.XPText:Show()
	tooltip.teamText:Show()
	tooltip.WeakToLabel:Hide()
	tooltip.ResistantToLabel:Hide()
end

function Tooltip:Attach(frame)
	local tooltip = self.tooltip
	self.owner = frame
	tooltip:SetParent(UIParent)
	tooltip:SetFrameStrata("TOOLTIP")
	tooltip:ClearAllPoints()
	
	tooltip:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", 0, 0)
	local left, bottom, width, height = tooltip:GetBoundsRect()
	
	if left + width > GetScreenWidth() then 
		tooltip:ClearAllPoints()
		tooltip:SetPoint( "TOPRIGHT", frame, "BOTTOMLEFT", 0, 0)
	end
	if bottom < 0 then
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", 0, 0)
	end

	tooltip:Show()
end

function Tooltip:Hide()
	self.tooltip:Hide()
end

function Tooltip:IsShown()
	return self.tooltip:IsShown()
end

function Tooltip:GetOwner()
	return self.owner
end

function Tooltip:SetShowHelpText(enabled)
	self.db.global.ShowHelpText = enabled
end

function Tooltip:GetShowHelpText()
	return self.db.global.ShowHelpText
end

function Tooltip:SetShowBreedInfo(enabled)
	self.db.global.ShowBreedInfo = enabled
end

function Tooltip:GetShowBreedInfo()
	return self.db.global.ShowBreedInfo
end


function Tooltip:SetUnit(petID,abilities,teamName)
	

	local speciesID, customName, level, xp, maxXp, displayID, _,petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(petID)
	local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID)
	
	if petID == 0 then return false end
	if not rarity then return false end
	
	local r, g, b,hex = GetItemQualityColor(rarity-1)
	
	local tooltip = self.tooltip
	tooltip.rarityGlow:SetVertexColor(r, g, b)
	tooltip.Icon:SetTexture(petIcon)
	
	
	if self.db.global.ShowBreedInfo then
		local breedIndex, confidence = libPetBreedInfo:GetBreedByPetID(petID)
		local breedName = libPetBreedInfo:GetBreedName(breedIndex) or ""
		local breedColor = GetColor(confidence)
		tooltip.Name:SetText(string.format(nameBreedFormat,hex,petName,breedColor,breedName ))
	else
		tooltip.Name:SetText(string.format(nameFormat,hex,petName))
	end
	tooltip.Level:SetText(level)
	tooltip.XPBar:SetWidth(max((xp / max(maxXp,1)) * tooltip.xpBarWidth, 1))
	tooltip.Delimiter:SetPoint("TOP", tooltip.XPBG, "BOTTOM", 0, -10)
	tooltip.XPText:SetFormattedText(tooltip.xpTextFormat or PET_BATTLE_CURRENT_XP_FORMAT, xp, maxXp)
	tooltip.teamText:SetText(teamName)
	tooltip.AttackAmount:SetText(attack)
	tooltip.SpeedAmount:SetText(speed)
	tooltip.PetType.Icon:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
	
	tooltip.SpeciesName:Hide()
	if customName then
		if ( customName ~= petName ) then
			tooltip.Name:SetText("|c"..hex..customName.."|r")
			tooltip.SpeciesName:SetText("|c"..hex..petName.."|r")
			tooltip.SpeciesName:Show()
		end
	end
	
	if Tooltip:GetShowHelpText() then
		self.tooltip:SetHeight(250)
		tooltip.helpText:Show()
	else
		tooltip.helpText:Hide()
		self.tooltip:SetHeight(215)
	end
	
	if ( tooltip.HealthText ) then
		tooltip.HealthText:SetFormattedText(tooltip.healthTextFormat or PET_BATTLE_CURRENT_HEALTH_FORMAT, health, maxHealth)
	end
	
	if ( health == 0 ) then
		tooltip.ActualHealthBar:SetWidth(1)
	else
		tooltip.ActualHealthBar:SetWidth((health / max(maxHealth,1)) * tooltip.healthBarWidth)
	end
		
	
	for i=1, #abilities do
		
		local name, icon, petType = C_PetJournal.GetPetAbilityInfo(abilities[i])
		
		local abilityIcon = tooltip["AbilityIcon"..i]
		local abilityName = tooltip["AbilityName"..i]

		abilityName:SetShown(true)
		abilityIcon:SetShown(true)
		abilityIcon:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Neutral")
		if name then 
			abilityName:SetText(name)
		end
	end
	
	return true
end