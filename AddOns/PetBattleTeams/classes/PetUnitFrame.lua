

PetBattleTeamsUnitFrame = {}

--private static 
local PetBattleTeams =  LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local Tooltip = PetBattleTeams:GetModule("Tooltip")
local TeamManager = PetBattleTeams:GetModule("TeamManager")
local Cursor = PetBattleTeams:GetModule("Cursor")
local Embed = PetBattleTeams.Embed
local PETS_PER_TEAM = 3
local _

local menuFrame = CreateFrame("frame", "PetBattleTeamsUnitFrameMenu", UIParent, "UIDropDownMenuTemplate")
menuFrame.menu = {
		{ text = "Team Options",notCheckable = true, isTitle = true },
		
		{text = "Lock Team", notCheckable = false,isNotRadio = true,keepShownOnClick = true, 
		func = function() 
			local teamIndex = menuFrame.teamIndex
			local locked = TeamManager:IsTeamLockedByUser(teamIndex)
			TeamManager:LockTeam(teamIndex, not locked)
		end,
		checked = function()
			local teamIndex = menuFrame.teamIndex
			return TeamManager:IsTeamLockedByUser(teamIndex)
		end,
		},
		{ text = "Rename Team", notCheckable = true,func = function() 
			local teamIndex = menuFrame.teamIndex
			local displayName = TeamManager:GetTeamName(teamIndex)
			StaticPopup_Show("PBT_TEAM_RENAME",displayName,nil,teamIndex)
		end,
		
		}, 
		{ text = "Delete Team", notCheckable = true,func = function() 
			local teamIndex = menuFrame.teamIndex  
			local displayName = TeamManager:GetTeamName(teamIndex)
			StaticPopup_Show("PBT_TEAM_DELETE",displayName,nil,teamIndex)
		end,
		},
		{ text = "Remove Pet", notCheckable = true,func = function() 
			local teamIndex = menuFrame.teamIndex  
			local petIndex = menuFrame.petIndex
			TeamManager:RemovePetFromTeam(teamIndex,petIndex)
		end,
		},
	}
	
--event handler for widget
local function OnEvent(self,event,...)
	if event == "PET_JOURNAL_LIST_UPDATE" then
		self:UpdateWidget()
	end
end

-- Local UI widget event handlers
local function OnReceiveDrag(self) 
	local operation, petID, teamIndex, petIndex = Cursor:GetCursorInfo()
	
	if petID then
		if teamIndex and petIndex and operation == "SWAP" then
			TeamManager:UpdateTeamSwapPets(self.teamIndex,self.petIndex,teamIndex, petIndex)
		elseif operation == "COPY" then
			TeamManager:UpdateTeamNewPet(petID,self.teamIndex,self.petIndex,teamIndex, petIndex)
		end
	end
	ClearCursor()
end

local function OnEnter(self) 
	self:SetTooltip()
end


local function OnLeave(self) 
	Tooltip:Hide()
end

local function OnDragStart(self) 
	Cursor:PickupPet(self.teamIndex,self.petIndex)
end

local function OnClick(self,button) 
	
	local operation = Cursor:GetCursorInfo()
	
	if button == "LeftButton" then
		if operation then
			OnReceiveDrag(self)
		else
			TeamManager:SetSelected(self.teamIndex)
		end
	elseif button == "RightButton" then
		self:ShowTeamOptionsMenu()
		Tooltip:Hide()
	end
end
-- end widget event handlers
function PetBattleTeamsUnitFrame:SetTooltip()
	if self.teamIndex and self.petIndex then 
		local petID, abilities = TeamManager:GetPetInfo(self.teamIndex,self.petIndex)
		if petID then
			local displayName = TeamManager:GetTeamName(self.teamIndex)
			if Tooltip:SetUnit(petID, abilities,displayName) then
				Tooltip:Attach(self)
			end
		end
	end
end


function PetBattleTeamsUnitFrame:ShowTeamOptionsMenu()
	local menu = menuFrame.menu
	menuFrame.teamIndex = self.teamIndex
	menuFrame.petIndex = self.petIndex
	EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
end

function PetBattleTeamsUnitFrame:New()
	local self = PetBattleTeamsUnitFrame:CreateWidget()
	Embed(self,PetBattleTeamsUnitFrame)
	self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
	self:SetScript("OnEvent",OnEvent)
	TeamManager.RegisterCallback(self,"TEAM_UPDATED")
	self:SetDefaultPet()
	return self
end

function PetBattleTeamsUnitFrame:CreateWidget()
	local self = CreateFrame("button", nil, nil, "PetBattleMiniUnitFrameAlly")
	self:EnableMouse(true)
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self:RegisterForDrag("LeftButton")
	
	self.rarityGlow = self:CreateTexture(nil,"ARTWORK") 
	self.rarityGlow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	self.rarityGlow:SetBlendMode("ADD")
	self.rarityGlow:ClearAllPoints()
	self.rarityGlow:SetDrawLayer("ARTWORK", 0)
	self.rarityGlow:SetWidth(self:GetWidth() * 1.5)
	self.rarityGlow:SetHeight(self:GetHeight() * 1.3)
	self.rarityGlow:SetPoint("CENTER", self.Icon, "CENTER", 0, 4)

	self.level = self:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	self.level:SetJustifyH("RIGHT")
	self.level:SetText("00")
	self.level:SetSize(0,0)
	self.level:SetFont("Fonts\\FRIZQT__.TTF",11,"OUTLINE")
	self.level:SetPoint("BOTTOMRIGHT",self.Icon,"BOTTOMRIGHT",0,10)
	
	self:SetScript("OnLoad",nil)
	self:SetScript("OnReceiveDrag",OnReceiveDrag)
	self:SetScript("OnDragStart",OnDragStart)
	self:SetScript("OnEnter",OnEnter)
	self:SetScript("OnLeave",OnLeave)
	self:SetScript("OnClick",OnClick)
	return self
end

function  PetBattleTeamsUnitFrame:SetDefaultPet()
	self.level:SetText("XX")
	self.Icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark")
	self.BorderAlive:Show()
	self.rarityGlow:Hide();
	self.level:Hide()
	self.ActualHealthBar:Hide()
	self.BorderDead:Hide()
	self.HealthDivider:Hide()
	self.HealthBarBG:Hide()
	self:Show()
	self.BorderAlive:SetVertexColor(1,1,1)
	
	if self.teamIndex then
		self.Icon:SetDesaturated(not TeamManager:GetTeamEnabled(self.teamIndex,self.petIndex))
	else
		self.Icon:SetDesaturated(false)
	end
	
	if self.teamIndex and TeamManager:IsTeamLockedByUser(self.teamIndex) then
		self.BorderAlive:SetVertexColor(.95,1,.2)
	else
		self.BorderAlive:SetVertexColor(1,1,1)
	end
end

function PetBattleTeamsUnitFrame:SetPet(teamIndex,petIndex)
	assert(type(teamIndex) == "number")
	assert(type(petIndex) == "number" and petIndex <= PETS_PER_TEAM and petIndex > 0)
	self.teamIndex = teamIndex
	self.petIndex = petIndex
	
	self:UpdateWidget()

	if Tooltip:GetOwner() == self and Tooltip:IsShown() then
		self:SetTooltip()
	end
	self:Show()
end

function PetBattleTeamsUnitFrame:UpdateWidget()
	if not self.teamIndex or not self.petIndex then return end
	local petID = TeamManager:GetPetInfo(self.teamIndex,self.petIndex)
	if not petID then self:SetDefaultPet() return end
	
	local showXpInLevel = TeamManager:GetShowXpInLevel()
	local showXpInHealthBar = TeamManager:GetShowXpInHealthBar()
	local isEnabled = TeamManager:GetTeamEnabled(self.teamIndex,self.petIndex) 
	
	local speciesID, _, level,  xp, maxXp, _, _,name, icon, _, _, _, _, _, canBattle, _ = C_PetJournal.GetPetInfoByPetID(petID)
	local health, maxHealth, _, _, rarity = C_PetJournal.GetPetStats(petID)

	if not speciesID then self:SetDefaultPet() return end
	
	if rarity then
		local r, g, b = GetItemQualityColor(rarity-1)
		self.rarityGlow:SetVertexColor(r, g, b)
		self.rarityGlow:SetHeight(self:GetHeight() * 1.3)
		self.rarityGlow:SetPoint("CENTER", self.Icon, "CENTER", 0, 4)
		self.rarityGlow:SetShown(isEnabled)
	end
	
	if icon then
		self.Icon:SetTexture(icon)
	else
		self.Icon:SetTexture("Interface\\ICONS\\INV_Misc_QuestionMark")
	end
	
	self.Icon:SetDesaturated(not isEnabled)
	
	if TeamManager:IsTeamLockedByUser(self.teamIndex) then
		self.BorderAlive:SetVertexColor(.95,1,.2)
	else
		self.BorderAlive:SetVertexColor(1,1,1)
	end
	
	
	if level then
	
		if isEnabled then
			self.level:SetTextColor(1,.82,0)
		else
			self.level:SetTextColor(.6,.6,.6)
		end
		
		local levelText = level 
		if showXpInLevel then
			local xpPercent = (xp/maxXp)*100
			if xpPercent > 10 then 
				levelText = levelText.."." ..string.sub( tostring(xpPercent) ,1,1)
			end
		end
		self.level:Show()
		self.level:SetText(levelText)
	end
	
	if health  then
		if health > 0 then
			self.BorderAlive:Show()
			self.ActualHealthBar:Show()
			self.BorderDead:Hide()
			self.HealthDivider:Show()
			self.HealthBarBG:Show()
			
			self.level:SetPoint("BOTTOMRIGHT",self.Icon,"BOTTOMRIGHT",0,10)
			
			if isEnabled then
				
				if showXpInHealthBar == true then
					--print(xp / max(maxXp,1))
					self.ActualHealthBar:SetWidth(((xp / maxXp) * self.healthBarWidth)+1)
					self.ActualHealthBar:SetVertexColor(0.08203125,0.2578125,0.6640625)
				else
					self.ActualHealthBar:SetWidth((health / max(maxHealth,1)) * self.healthBarWidth)
					self.ActualHealthBar:SetVertexColor(0,1,0)
				end
			else
				self.ActualHealthBar:SetVertexColor(.6,.6,.6)
			end

		else
			self.ActualHealthBar:Hide()
			self.BorderAlive:Hide()
			self.BorderDead:Show()
			self.HealthDivider:Hide()
			self.HealthBarBG:Hide()
			self.rarityGlow:SetHeight(self:GetHeight() * 1.7)
			self.rarityGlow:SetPoint("CENTER", self.Icon, "CENTER", 0, 0)
			self.level:SetPoint("BOTTOMRIGHT",self.Icon,"BOTTOMRIGHT",0,0)
		end
	end
	
	if  isEnabled then
		self:SetScript("OnReceiveDrag",OnReceiveDrag)
		self:SetScript("OnDragStart",OnDragStart)
		self:SetScript("OnClick",OnClick)
	else
		self:SetScript("OnReceiveDrag",nil)
		self:SetScript("OnDragStart",nil)
		self:SetScript("OnClick",nil)
	end
	
end



function PetBattleTeamsUnitFrame:TEAM_UPDATED(event,teamIndex)
	if self.teamIndex == teamIndex or teamIndex == nil then
		self:UpdateWidget()
	end
end

