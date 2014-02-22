PetBattleTeamsFrame = {}

local PETS_PER_TEAM = 3
local PetBattleTeams =  LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local TeamManager = PetBattleTeams:GetModule("TeamManager")
local Cursor =  PetBattleTeams:GetModule("Cursor")
local Embed = PetBattleTeams.Embed
local HEIGHT_WITH_NAME = 55
local HEIGHT = 42

local _

local function OnEnter(self)	
	local operation = Cursor:GetCursorInfo()
	self.helperText:Show()
		
	local parent = self:GetParent()
	
	local height = TeamManager:GetShowTeamName() and HEIGHT_WITH_NAME or HEIGHT
	
	parent:SetHeight(55*1.5)
	
end

local function OnLeave(self)
	local parent = self:GetParent()
	self.helperText:Hide()
	local height = TeamManager:GetShowTeamName() and HEIGHT_WITH_NAME or HEIGHT
	parent:SetHeight(height)
end

local function OnClickOrDrag(self)
	local parent = self:GetParent()
	local operation, petID, teamIndex, petIndex = Cursor:GetCursorInfo()
	if operation == "MOVE TEAM" then
		TeamManager:MoveTeam(teamIndex,parent.teamIndex)
	end
	parent:SetHeight(HEIGHT)
	ClearCursor()
end

local function OnEvent(self,event,...)
	if event == "PET_BATTLE_QUEUE_STATUS" or event == "PET_BATTLE_OPENING_START" or event == "PET_BATTLE_CLOSE" then
		self:PET_BATTLE_QUEUE_STATUS(event,...)
	end
end

function PetBattleTeamsFrame:New()
	local self = CreateFrame("frame")
	Embed(self,PetBattleTeamsFrame)
	
	local width = 135
	local height = HEIGHT
	self:SetSize(width,height)
	
	self.unitFrames = {}
	self.unitFrames[1]= PetBattleTeamsUnitFrame:New()
	self.unitFrames[1]:SetParent(self)
	self.unitFrames[1]:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",15,2)
	
	for i=2,PETS_PER_TEAM do
		local unitFrame = PetBattleTeamsUnitFrame:New()
		unitFrame:SetParent(self)
		unitFrame:SetPoint("LEFT",self.unitFrames[i-1],"RIGHT",1,0)
		self.unitFrames[i] = unitFrame;
	end
	
	
	self.logicalLeft = self.unitFrames[1]
	self.logicalRight = self.unitFrames[PETS_PER_TEAM]
	
	local teamMovementFrame = CreateFrame("button")
	self.teamMovementFrame = teamMovementFrame
	teamMovementFrame:SetParent(self)
	teamMovementFrame:SetAllPoints(self)
	teamMovementFrame:SetFrameLevel(10000)
	teamMovementFrame:Hide()
	
	teamMovementFrame:SetScript("OnEnter",OnEnter)
	teamMovementFrame:SetScript("OnLeave",OnLeave)
	teamMovementFrame:SetScript("OnClick",OnClickOrDrag)
	teamMovementFrame:SetScript("OnReceiveDrag",OnClickOrDrag)
	
	local helperText = self:CreateFontString(nil,"OVERLAY","GameFontNormal")
	teamMovementFrame.helperText = helperText
	helperText:SetParent(teamMovementFrame)
	helperText:SetText("Place Team Here")
	helperText:SetPoint("CENTER", teamMovementFrame, "TOP",0,-15)
	helperText:SetJustifyH("CENTER")
	helperText:Hide()
	
	local teamNameText = self:CreateFontString(nil,"OVERLAY","GameFontHighlight")
	self.teamNameText = teamNameText
	
	teamNameText:SetText("")
	teamNameText:SetPoint("BOTTOMLEFT", self.unitFrames[1], "TOPLEFT",0,2)
	teamNameText:SetPoint("BOTTOMRIGHT", self.unitFrames[3], "TOPRIGHT",0,2)
	teamNameText:SetJustifyH("LEFT")
	teamNameText:Hide()
	
	self.selectedTexture = self:CreateTexture(nil,"OVERLAY") 
	self.selectedTexture:SetSize(36,36)
	self.selectedTexture:SetTexture("Interface\\PetBattles\\PetJournal")
	self.selectedTexture:SetTexCoord(0.11328125,0.16210938,0.02246094,0.04687500)
	self.selectedTexture:SetPoint("CENTER",self.unitFrames[1],"LEFT",0,0)
	self.selectedTexture:SetParent(self.unitFrames[1])
	self.selectedTexture:Hide()
	
	self.lockedTexture = self:CreateTexture(nil,"OVERLAY") 
	self.lockedTexture:SetSize(30,30)
	self.lockedTexture:SetTexture("Interface\\PetBattles\\PetBattle-LockIcon")
	self.lockedTexture:SetPoint("CENTER",self.unitFrames[1],"LEFT",0,0)
	self.lockedTexture:SetParent(self.unitFrames[1])
	self.lockedTexture:Hide()
	
	--[[self:SetBackdrop({
      bgFile="Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
      --edgeFile="Interface\\LFGFRAME\\LFGBorder", 
      --tile=1, tileSize=16, edgeSize=16, 
      --insets={left=5, right=5, top=5, bottom=5}
	  })
	 self:SetBackdropColor(0,1,0)]]
	
	TeamManager.RegisterCallback(self,"TEAM_UPDATED")
	TeamManager.RegisterCallback(self,"TEAM_DELETED")
	TeamManager.RegisterCallback(self,"SELECTED_TEAM_CHANGED")
	
	Cursor.RegisterCallback(self,"BATTLE_PET_CURSOR_CHANGED")
		
	self:RegisterEvent("PET_BATTLE_QUEUE_STATUS")
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	--self:RegisterEvent("PET_BATTLE_OPENING_START","PET_BATTLE_QUEUE_STATUS")
	--self:RegisterEvent("PET_BATTLE_CLOSE","PET_BATTLE_QUEUE_STATUS")
	self:SetScript("OnEvent",OnEvent)
	
	
	
	return self
end


function PetBattleTeamsFrame:Update()
	local isSelected = (self.teamIndex == TeamManager:GetSelected())
	local showTeamName = TeamManager:GetShowTeamName()
	
	if showTeamName then
		local displayName = TeamManager:GetTeamName(self.teamIndex)
		self.teamNameText:SetText(displayName)
		self:SetHeight(HEIGHT_WITH_NAME)
	else
		self:SetHeight(HEIGHT)
	end
	self.teamNameText:SetShown(showTeamName)
	
	if self.teamIndex and TeamManager:IsTeamLockedByUser(self.teamIndex) then
		self.teamNameText:SetTextColor(.95,1,.2)
	else
		self.teamNameText:SetTextColor(1,1,1)
	end
	
	local showLocked = TeamManager:IsTeamLocked(self.teamIndex)
	
	
	if isSelected then
		self.selectedTexture:SetShown(not showLocked)
		self.lockedTexture:SetShown(showLocked)
	else
		self.selectedTexture:Hide()
		self.lockedTexture:Hide()
	end
	
	for i=1,#self.unitFrames do
		self.unitFrames[i]:UpdateWidget()
	end
end

function PetBattleTeamsFrame:SetTeam(teamIndex)
	assert(type(teamIndex) == "number")
	self.teamIndex = teamIndex
	
	self:Update()
	
	for i=1,#self.unitFrames do
		self.unitFrames[i]:SetPet(teamIndex,i)
	end
end

function PetBattleTeamsFrame:TEAM_UPDATED(event,teamIndex)
	if teamIndex == self.teamIndex or teamIndex == nil  then
		self:Update()
	end
end

function PetBattleTeamsFrame:TEAM_DELETED(event,teamIndex)
	if teamIndex <= self.teamIndex then
		self:Update()
	end
end

function PetBattleTeamsFrame:SELECTED_TEAM_CHANGED(event,teamIndex)
	self:Update()
end

function PetBattleTeamsFrame:PET_BATTLE_QUEUE_STATUS(event, status)
	self:Update()
end

function PetBattleTeamsFrame:BATTLE_PET_CURSOR_CHANGED(event,operation , petID, teamIndex, petIndex)
	local show =  operation == "MOVE TEAM"
	self.teamMovementFrame:SetShown(show)
end

