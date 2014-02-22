--[[
Callback events  

TEAM_UPDATED 
	args: teamIndex or nil
		nil indicates all teams should be refreshed
		teamindex indicates which team should refresh
		
TEAM_DELETED
	args: teamIndex
		indicates which team was deleted
		
TEAM_CREATED
	args: teamIndex
		indicates the newly created teams index

SELECTED_TEAM_CHANGED
	args: teamIndex
		indicates when a new team is selected

]]


local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local TeamManager = PetBattleTeams:NewModule("TeamManager")
local PETS_PER_TEAM = 3
local START = 1
local UPDATE_PETJOURNAL = 4
local DESUMMON_PET = 5
local FINISHED = 6
local EMPTY_PET = "0x0000000000000000"
local _
local LibPetJournal = LibStub("LibPetJournal-2.0")

--frame functions
local function OnUpdate(self,elapsed)
	local selected = TeamManager:GetSelected()
	
	--[[self.elapsed = self.elapsed + elapsed
	if self.elapsed > .1 then
		self.elapsed = self.elapsed - .1
	else
		return
	end]]
	
	
	if self.step <= PETS_PER_TEAM  then
		
		local petID, abilities = TeamManager:GetPetInfo(selected,self.step)
		local isValidPet = C_PetJournal.GetPetInfoByPetID(petID or EMPTY_PET)
		local currentPetID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(self.step)
		
		
		
		if not isValidPet or locked then
			local IgnoreEmptyPets = TeamManager:GetIgnoreEmptyPets()
			if not IgnoreEmptyPets then
				C_PetJournal.SetPetLoadOutInfo(self.step,EMPTY_PET)
			end
			if IgnoreEmptyPets or C_PetJournal.GetPetLoadOutInfo(self.step) == nil then
				self.step = self.step +1
				return
			end
		end
		
		--print(self.step,tonumber(petID,16) ~= tonumber(currentPetID or EMPTY_PET,16),ability1 ~= abilities[1],ability2 ~= abilities[2],ability3 ~= abilities[3])
		if tonumber(petID,16) ~= tonumber(currentPetID or EMPTY_PET ,16) then 
			C_PetJournal.SetPetLoadOutInfo(self.step,petID) 
			return
		else
			
			if ability1 ~= abilities[1] then 
				C_PetJournal.SetAbility(self.step, 1, abilities[1])
				return
			elseif ability2 ~= abilities[2] then
				C_PetJournal.SetAbility(self.step, 2, abilities[2])
				return
			elseif ability3 ~= abilities[3] then
				C_PetJournal.SetAbility(self.step, 3, abilities[3])
				return
			end
		end
		
		
		if tonumber(petID,16) == tonumber(currentPetID,16) and ability1 == abilities[1] and ability2 == abilities[2] and ability3 == abilities[3] then
			self.step = self.step +1
			return
		end
	elseif self.step == UPDATE_PETJOURNAL then
		if PetJournal_UpdatePetLoadOut then
			PetJournal_UpdatePetLoadOut()
		end
		self.step = self.step +1
	elseif self.step == DESUMMON_PET then
		
		self.waitForPetElapsed = self.waitForPetElapsed + elapsed
		self.waitForPetTotal = self.waitForPetTotal + elapsed
		
		if self.waitForPetElapsed > 0.5 then
			if not TeamManager:GetDismissPet() then
				self.step = self.step + 1
				return
			end
			
			local summonedGuid = C_PetJournal.GetSummonedPetGUID()
			if summonedGuid then
				C_PetJournal.SummonPetByGUID(summonedGuid)
			end
			self.waitForPetElapsed = 0
		end
		
		if self.waitForPetTotal > 6 then
			self.step = self.step +1
		end
	elseif self.step == FINISHED then
		self:SetScript("OnUpdate",nil)
	end 
end

function TeamManager:ApplyTeam(teamIndex)
	assert(type(teamIndex) == "number")
	self.frame.step = START
	self.frame.waitForPetElapsed = 1 --so it fires immediately
	self.frame.waitForPetTotal = 0
	self.frame.elapsed = 0
	self.frame:SetScript("OnUpdate",OnUpdate)
end

function TeamManager:IsWorking()
	return self.frame.step < DESUMMON_PET
end

--User options and user commands

function TeamManager:GetShowTeamName()
	return self.db.global.showTeamName 
end
function TeamManager:GetShowXpInLevel()
	return self.db.global.showXpInLevel 
end
function TeamManager:GetShowXpInHealthBar()
	return self.db.global.showXpInHealthBar 
end

function TeamManager:SetShowTeamName(enabled)
	assert(type(enabled) == "boolean")
	self.db.global.showTeamName = enabled
	self.callbacks:Fire("TEAM_UPDATED")
end

function TeamManager:SetShowXpInLevel(enabled)
	assert(type(enabled) == "boolean")
	self.db.global.showXpInLevel = enabled
	self.callbacks:Fire("TEAM_UPDATED")
end

function TeamManager:SetShowXpInHealthBar(enabled)
	assert(type(enabled) == "boolean")
	self.db.global.showXpInHealthBar = enabled 
	self.callbacks:Fire("TEAM_UPDATED")
end

function TeamManager:ResetTeams()
	wipe(self.teams)
	self.db.global.selected = 0
	self:CreateTeam()
end

function TeamManager:ResetUI()
	self:SetShowTeamName(true)
	self:SetShowXpInLevel(true)
	self:SetShowXpInHealthBar(false)
	self:SetAutomaticallySaveTeams(true)
	self:SetLockStateAllTeams(false)
	self:SetSelected(1)
end

--[[function TeamManager:ImportTeams()
	if PetBattleTeamsSettings and PetBattleTeamsSettings.teams and #PetBattleTeamsSettings.teams > 0 then
		local teams = PetBattleTeamsSettings.teams
		local start = self:GetNumTeams() +1
		for i=1,#teams do
			local team = {}
			team.enabled = {}
			team.name = nil
			for j=1,PETS_PER_TEAM do
				team.enabled[j] = true
				local pet = {}
				pet.abilities = {}
				pet.petID = teams[i][j].petID
				for k=1,#teams[i][j].abilities do
					pet.abilities[k] = teams[i][j].abilities[k]
				end
				table.insert(team,pet)
			end
			table.insert(self.teams,team)
		end
		self:SetSelected(1)
		self.callbacks:Fire("TEAM_UPDATED")
		return #teams
	end
	return 0
end]]

function TeamManager:SetAutomaticallySaveTeams(enabled)
	assert(type(enabled)== "boolean")
	self.db.global.automaticallySaveTeams = enabled
end

function TeamManager:GetAutomaticallySaveTeams()
	return self.db.global.automaticallySaveTeams
end

function TeamManager:SetDismissPet(enabled)
	assert(type(enabled)== "boolean")
	self.db.global.dismissPet = enabled
end
	
function TeamManager:GetDismissPet()
	return self.db.global.dismissPet
end

function TeamManager:SetIgnoreEmptyPets(enabled)
	assert(type(enabled)== "boolean")
	self.db.global.ignoreEmptyPets = enabled
end
	
function TeamManager:GetIgnoreEmptyPets()
	return self.db.global.ignoreEmptyPets
end



--team locking functions
function TeamManager:IsTeamLockedByUser(teamIndex)
	assert(type(teamIndex) == "number")
	if self.teams[teamIndex] and self.teams[teamIndex].locked == true then return true end
	return false
end

function TeamManager:SetLockStateAllTeams(enabled)
	assert(type(enabled)== "boolean")
	for i=1,#self.teams do
		self.teams[i].locked = enabled
	end
	self.callbacks:Fire("TEAM_UPDATED")
end

function TeamManager:LockTeam(teamIndex,enabled)
	assert(type(enabled)== "boolean" and type(teamIndex) == "number")
	if self.teams[teamIndex] then
		self.teams[teamIndex].locked = enabled
	end
	self.callbacks:Fire("TEAM_UPDATED",teamIndex)
end

function TeamManager:IsTeamLocked(teamIndex)
	assert(type(teamIndex) == "number")
	if teamIndex == self:GetSelected() and (C_PetBattles.GetPVPMatchmakingInfo()) then return true end
	return false
end


--team information functions
function TeamManager:GetPetInfo(teamIndex,petIndex)
	assert(type(teamIndex) == "number" and type(petIndex) == "number")
	if self.teams[teamIndex] and self.teams[teamIndex][petIndex] then
		local pet = self.teams[teamIndex][petIndex]
		
		if pet and pet.petID and tonumber(pet.petID, 16) > 0  then
			local abilities = pet.abilities
			return pet.petID, abilities
		end
	end
	return EMPTY_PET
end

function TeamManager:GetNumPets(teamIndex)
	assert(type(teamIndex) == "number")
	if self.teams[teamIndex] then 
		return #self.teams[teamIndex]
	end
	return 0
end

function TeamManager:GetNumTeams()
	return #self.teams
end

function TeamManager:SetTeamName(teamIndex,name)
	assert(type(teamIndex) == "number"  and  (type(name) == "string" or name == nil))
	if  self.teams[teamIndex] then
		self.teams[teamIndex].name = name
	end
	self.callbacks:Fire("TEAM_UPDATED",teamIndex)
end

function TeamManager:GetTeamName(teamIndex)
	if type(teamIndex) ~= "number" then return "Unknown Team" end
	
	local name = "Team: "..tostring(teamIndex)
	local customName
	
	if self.teams[teamIndex] and self.teams[teamIndex].name then
		customName = self.teams[teamIndex].name
	end
	
	local displayName = customName and customName or name
	
	return displayName, name, customName
end

function TeamManager:TeamExists(teamIndex)
	assert(type(teamIndex) == "number")
	if self.teams[teamIndex] then return true end
	return false
end

function TeamManager:RemovePetFromTeam(teamIndex,petIndex)
	assert(type(teamIndex) == "number")
	assert(type(petIndex) == "number" and petIndex >= 1 and petIndex <= PETS_PER_TEAM)
	if TeamManager:IsTeamLocked(teamIndex) or  TeamManager:IsTeamLockedByUser(teamIndex) then return end
	
	if self.teams[teamIndex] then
		self.teams[teamIndex][petIndex].petID = EMPTY_PET
		self.teams[teamIndex][petIndex].abilities = {}
	end
	self.callbacks:Fire("TEAM_UPDATED",teamIndex)
end

function TeamManager:TeamContainsPet(teamIndex,petID)
	assert(type(teamIndex) == "number")
	
	if not self.teams[teamIndex] or not petID or petID == EMPTY_PET then return false end
	local numPets = TeamManager:GetNumPets(teamIndex)
	for i=1,numPets do
		local teamPetID = TeamManager:GetPetInfo(teamIndex,i)
		if teamPetID == petID then
			return true,i
		end
	end
	return false
end

function TeamManager:SetTeamEnabled(teamIndex,petIndex,enabled)
	assert(type(enabled)== "boolean")
	if teamIndex and self.teams[teamIndex] then
		if petIndex then
			self.teams[teamIndex].enabled[petIndex] = enabled
		else
			self.teams[teamIndex].enabled[1] = enabled
			self.teams[teamIndex].enabled[2] = enabled
			self.teams[teamIndex].enabled[3] = enabled
		end
		
	end
end

function TeamManager:GetTeamEnabled(teamIndex,petIndex)
	assert(type(teamIndex) == "number")
	assert(type(petIndex) == "number" and petIndex >= 1 and petIndex <= PETS_PER_TEAM)
	if teamIndex and self.teams[teamIndex] then
		return self.teams[teamIndex].enabled[petIndex] and not TeamManager:IsTeamLocked(teamIndex)
	end
	return true
end

function TeamManager:GetSelected()
	return self.db.global.selected 
end

function TeamManager:IsSelected(teamIndex)
	assert(type(teamIndex) == "number")
	return self.db.global.selected  == teamIndex
end 

function TeamManager:SetSelected(teamIndex)
	assert(type(teamIndex) == "number" )
	local selected = self:GetSelected()
	if teamIndex <= 0 or teamIndex > self:GetNumTeams() or self:IsTeamLocked(selected) then return end
	local prevSelected = self.db.global.selected
	self.db.global.selected = teamIndex
	TeamManager.callbacks:Fire("TEAM_UPDATED",prevSelected)
	self.callbacks:Fire("SELECTED_TEAM_CHANGED",teamIndex)
	self:ApplyTeam(teamIndex)
end

--pet copy and swaping, team move
function TeamManager:UpdateTeamSwapPets(destinationTeam,destinationPetIndex,sourceTeam,sourcePetIndex)
	assert(type(destinationTeam) == "number")
	assert(type(destinationPetIndex) == "number" and destinationPetIndex <= PETS_PER_TEAM and destinationPetIndex > 0)
	assert(type(sourceTeam) == "number")
	assert(type(sourcePetIndex) == "number" and sourcePetIndex <= PETS_PER_TEAM and sourcePetIndex > 0)
	
	
	
	local selected = self:GetSelected()
	if self:IsTeamLocked(destinationTeam) or self:IsTeamLocked(sourceTeam) then return end
	if self:IsTeamLockedByUser(destinationTeam) or self:IsTeamLockedByUser(sourceTeam) then return end
	
	local petA = self.teams[destinationTeam][destinationPetIndex]
	local petB = self.teams[sourceTeam][sourcePetIndex]
	
	if destinationTeam ~=  sourceTeam and  ( (petB and self:TeamContainsPet(destinationTeam,petB.petID)) or (petA and self:TeamContainsPet(sourceTeam,petA.petID))) then return end
	
	self.teams[destinationTeam][destinationPetIndex] = petB
	self.teams[sourceTeam][sourcePetIndex] = petA
	
	if selected == sourceTeam or selected == destinationTeam then 
		self:ApplyTeam(selected)
	end
	
	
	self.callbacks:Fire("TEAM_UPDATED",destinationTeam)
	self.callbacks:Fire("TEAM_UPDATED",sourceTeam)
end

function TeamManager:MoveTeam(teamIndexSource,teamIndexDesintation)
	assert(type(teamIndexSource) == "number" and type(teamIndexDesintation) == "number")
	if self.teams[teamIndexSource] and self.teams[teamIndexDesintation] then
		
		local selected = self:GetSelected()
		local distance = math.abs(teamIndexSource - teamIndexDesintation)
		
		if true then --distance > 1 then
			local tempTeam = self.teams[teamIndexSource] 
			table.remove(self.teams,teamIndexSource)
			
			 --adjust for the fact that we delete first to make sure their is consistant behavior for the user
			if teamIndexSource < teamIndexDesintation then
				teamIndexDesintation = teamIndexDesintation - 1
			end
			
			table.insert(self.teams,teamIndexDesintation ,tempTeam )
			
			--if the swap happens in such as way as to re-order the teams pushing the selected team to another team number
			--then update the selected team to the predicted new location of the old selected team
			
			--if source && desintation < selected or source && desintation > selected do nothing
			--if destination == selected and source < selected then post move do nothing
			
			--if source < selected and destination > selected then post move, selected is -1
			--if source == selected then post move selected is desintation - 1
			
			--if destination == selected and source > selected then post move selected +1
			--if source > selected and destination < selected then post move, selected is +1
			
			local adjust = teamIndexSource <  teamIndexDesintation and -1 or 1
			
			if teamIndexSource == selected then
				self:SetSelected(teamIndexDesintation)
			elseif teamIndexDesintation == selected   then
				self:SetSelected(teamIndexDesintation + adjust)
			elseif (teamIndexSource < selected and teamIndexDesintation > selected) or (teamIndexSource > selected and teamIndexDesintation < selected) then
				self:SetSelected(selected + adjust)
			end
			
			self.callbacks:Fire("TEAM_UPDATED")
		--[[else 
			local tempTeam = self.teams[teamIndexSource] 
			self.teams[teamIndexSource]  = self.teams[teamIndexDesintation]
			self.teams[teamIndexDesintation] = tempTeam
			
			--swap selection
			if selected == teamIndexSource then
				self:SetSelected(teamIndexDesintation)
			elseif selected == teamIndexDesintation then
				self:SetSelected(teamIndexSource)
			end

			self.callbacks:Fire("TEAM_UPDATED")]]
		end
	end
end

function TeamManager:UpdateTeamNewPet(petID,teamIndex,petIndex,sourceTeamIndex,sourcePetIndex)
	assert(type(petID) == "string")
	assert(type(petIndex) == "number" and petIndex <= PETS_PER_TEAM and petIndex > 0)
	assert(type(teamIndex) == "number")
	if not petID then return end
	if self:IsTeamLocked(teamIndex) or self:IsTeamLockedByUser(teamIndex) then return end
	if self:TeamContainsPet(teamIndex,petID) then return  end
	
	local speciesID, customName, level, xp, maxXp, displayID, _,name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(petID)
	
	if speciesID and canBattle then
		local pet = {}
		pet.petID = petID
		pet.abilities = {}
		pet.speciesID = C_PetJournal.GetPetInfoByPetID(pet.petID)
		
		if sourceTeamIndex and sourcePetIndex and  sourcePetIndex < PETS_PER_TEAM then
			local _, sourceAbilities = self:GetPetInfo(sourceTeamIndex,sourcePetIndex)
			
			for i=1,3 do
				pet.abilities[i] = sourceAbilities[i]
			end
			
		else
			local abilities = {}
			C_PetJournal.GetPetAbilityList(speciesID, abilities, {})
			for i=1,3 do
				pet.abilities[i] = abilities[i]
			end
		end
			
		self.teams[teamIndex][petIndex] = pet;
		if self:IsSelected(teamIndex) then
			self:ApplyTeam(teamIndex)
		end
		self.callbacks:Fire("TEAM_UPDATED",teamIndex)
		return 
	end
	return
end



--CRUD functions

function TeamManager:CreateTeam()
	local numTeams = self:GetNumTeams()
	
	local team = {}
	team.name = nil;
	team.enabled = {}
	
	for i = 1,PETS_PER_TEAM do
		team.enabled[i] = true
		pet = {}
		pet.abilities = {}
		
		if self:GetAutomaticallySaveTeams() then 
			pet.petID, pet.abilities[1], pet.abilities[2], pet.abilities[3] = C_PetJournal.GetPetLoadOutInfo(i)
			
			if pet.petID then
				pet.speciesID = C_PetJournal.GetPetInfoByPetID(pet.petID)
			end
		else
			pet.petID, pet.abilities[1], pet.abilities[2], pet.abilities[3] = EMPTY_PET,0,0,0
		end
		
		
		table.insert(team,pet)
	end

	table.insert(self.teams,self:GetSelected()+1,team)
	self.callbacks:Fire("TEAM_CREATED",self:GetSelected()+1)
	self.callbacks:Fire("TEAM_UPDATED",self:GetSelected()+1)
	self:SetSelected(self:GetSelected()+1)
end

function TeamManager:DeleteTeam(teamIndex)
	assert(type(teamIndex) == "number")
	
	
	local numTeams = self:GetNumTeams()
	local selectedTeam = self:GetSelected()
	
	if numTeams > 1 then
		table.remove(self.teams,teamIndex)
		
		if teamIndex == numTeams then
			self:SetSelected(teamIndex-1)
		elseif teamIndex == selectedTeam then
			self:SetSelected(teamIndex)
		end
		
		self.callbacks:Fire("TEAM_DELETED",teamIndex)
	end
end

function TeamManager.UpdateCurrentTeam()
	if not TeamManager:GetAutomaticallySaveTeams() then return end
	local selected = TeamManager:GetSelected()
	if not TeamManager:IsWorking() and not TeamManager:IsTeamLocked(selected) and not TeamManager:IsTeamLockedByUser(selected) then
		
		local team =  TeamManager.teams[selected]
		if team then
			for i = 1,PETS_PER_TEAM do
				pet = {}
				pet.abilities = {}
				pet.petID, pet.abilities[1], pet.abilities[2], pet.abilities[3] = C_PetJournal.GetPetLoadOutInfo(i)
				if pet.petID then
					pet.speciesID = C_PetJournal.GetPetInfoByPetID(pet.petID)
				end
				team[i] = pet
			end
		end
		
		TeamManager.callbacks:Fire("TEAM_UPDATED",selected)
	end
end


--Initialization functions
function TeamManager:OnInitialize()
	self.callbacks = LibStub("CallbackHandler-1.0"):New(self)
	self.frame = CreateFrame("frame")
	self.frame.step = FINISHED
	
	local defaults = {
		global = {
			teams = {},
			selected = 0,
			dismissPet = false,
			hasImported = false,
			userLocked = false,
			showTeamName = true,
			showXpInLevel = true,
			showXpInHealthBar = false,
			automaticallySaveTeams = true,
			ignoreEmptyPets = false,
		}
	}

	-- Assuming the .toc says ## SavedVariables: MyAddonDB
	local db = LibStub("AceDB-3.0"):New("PetBattleTeamsDB", {} , true)
	local name = self:GetName()
	self.db = db:RegisterNamespace(name, defaults)
	
	self.teams = self.db.global.teams 
	
	
	
	
	--convert numbered petID's to new hex strings
	for i=1,#self.teams do
		for j=1,3 do
			if self.teams[i][j] and self.teams[i][j].petID and type(self.teams[i][j].petID) == "number" then
				self.teams[i][j].petID = string.format("%0#18x",  self.teams[i][j].petID)
			end
		end
	end
	
	if #self.teams == 0 then
		self:CreateTeam()
		self:SetSelected(1)
	end
	
	if #self.teams ~= 0 and self:GetSelected() == 0 then
		self:SetSelected(1)
	end
	
	for i=1,#self.teams do
		self.teams[i].enabled = {}
		for j=1,PETS_PER_TEAM do
			self.teams[i].enabled[j] = true
		end
	end
	 
	hooksecurefunc(C_PetJournal, "SetPetLoadOutInfo", TeamManager.UpdateCurrentTeam)
	hooksecurefunc(C_PetJournal, "SetAbility", TeamManager.UpdateCurrentTeam)
	
	
	local Cursor = PetBattleTeams:GetModule("Cursor")
	Cursor.RegisterCallback(self,"BATTLE_PET_CURSOR_CHANGED")
	
	
	
	LibPetJournal.RegisterCallback(self,"PetListUpdated", "setupSpeciesIDRunOnce")
end


function TeamManager:setupSpeciesIDRunOnce()
	local numTeams = self:GetNumTeams()
	for team=1,numTeams do
		for petIndex = 1, PETS_PER_TEAM do
			local teamPetID = self.teams[team][petIndex].petID
			if teamPetID then
				local speciesID, _, level = C_PetJournal.GetPetInfoByPetID(teamPetID)
				if speciesID then
					self.teams[team][petIndex].speciesID = speciesID
				end
			end
		end
	end
	LibPetJournal.UnregisterCallback(self,"PetListUpdated")
end

function TeamManager:ReconstructTeams()
	local availablePets = {}
	for _,petID in LibPetJournal:IteratePetIDs() do 
		local speciesID, _, level, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petID)
		if not availablePets[speciesID] or availablePets[speciesID].level < level then
			availablePets[speciesID] = {["petID"]=petID,["level"]=level,["name"]=name}
		end
	end
	
	local numTeams = self:GetNumTeams()
	for team=1,numTeams do
		for petIndex = 1, PETS_PER_TEAM do
			local teamPetID = self.teams[team][petIndex].petID
			if teamPetID then
				local speciesID, _, level = C_PetJournal.GetPetInfoByPetID(teamPetID)
				if speciesID then
					self.teams[team][petIndex].speciesID = speciesID
				else
					local teamSpeciesID = self.teams[team][petIndex].speciesID
					if teamSpeciesID and availablePets[teamSpeciesID] then
						 self.teams[team][petIndex].petID = availablePets[teamSpeciesID].petID
					end
				end
			end
		end
	end
	TeamManager.callbacks:Fire("TEAM_UPDATED")
end

function TeamManager:BATTLE_PET_CURSOR_CHANGED(event,operation,petID,teamIndex,petIndex)
	
	
	for team=1,#self.teams do
		--player is in a queue, always disable the selected team
		if TeamManager:GetSelected() == team and TeamManager:IsTeamLocked(team)  then 
			TeamManager:SetTeamEnabled(team,nil,false)
		elseif petID then	
			if (operation and operation ~= "MOVE TEAM" and TeamManager:IsTeamLockedByUser(team)) then
				TeamManager:SetTeamEnabled(team,nil,false)
			elseif teamIndex and petIndex and operation == "SWAP" then
				local containsPet, index = TeamManager:TeamContainsPet(team,petID)
				for i=1,PETS_PER_TEAM do
					local selfPetID = TeamManager:GetPetInfo(team,i)
					local sourceContainsDestination = TeamManager:TeamContainsPet(teamIndex,selfPetID)
					local enabled = (selfPetID == petID or teamIndex == team) or  (not containsPet and not sourceContainsDestination)
					TeamManager:SetTeamEnabled(team,i,enabled)
				end
			elseif operation == "COPY" then
				local containsPet = TeamManager:TeamContainsPet(team,petID)
				for i=1,PETS_PER_TEAM do
					local enabled = not containsPet or petID == TeamManager:GetPetInfo(team,i)
					TeamManager:SetTeamEnabled(team,i,enabled)
				end
			end
		else --cursor cleared
			TeamManager:SetTeamEnabled(team,nil,true)
		end
	end
	
	TeamManager.callbacks:Fire("TEAM_UPDATED")
end

--/run PetBattleTeams.modules.TeamManager:FixTeams()
function TeamManager:FixTeams()
	--set theory functions
	local function intersect(a, b)
	  
	  
		local ret = {}
		if type(a) == "table" and type(b) == "table" then
			for _,b_ in pairs(b) do
				if a[b_] then ret[b_]=b_ end
			end
		end
		return ret
	end

	--map ability IDs to species with that ability
	local abilities2species={};
	for _,speciesID in LibPetJournal:IterateSpeciesIDs() do 
	  local abilities = C_PetJournal.GetPetAbilityList(speciesID); 
	  if abilities then
		for j=1,#abilities do
		  if not abilities2species[abilities[j]] then abilities2species[abilities[j]]= {} end
		  abilities2species[abilities[j]][speciesID] = speciesID
		end
	  end
	end 
	
	--map speciesIds to possible pet matches
	local availablePets = {}
	for _,petID in LibPetJournal:IteratePetIDs() do 
	  local speciesID, _, level, _, _, _, _, name = C_PetJournal.GetPetInfoByPetID(petID)
	  if not availablePets[speciesID] or availablePets[speciesID].level < level then
		availablePets[speciesID] = {["petID"]=petID,["level"]=level,["name"]=name}
	  end
	end

	--find intersections between an invalid pets previous ability ID's and currently valid pets
	for i=1,#self.teams do
		for j=1,PETS_PER_TEAM do 
			if self.teams[i][j].petID and not C_PetJournal.GetPetInfoByPetID(self.teams[i][j].petID) then
				
				--get possible pet matches
				local matches = abilities2species[self.teams[i][j].abilities[1]]
				
				for k=2,3 do
				  matches = intersect(matches,abilities2species[self.teams[i][j].abilities[k]])
				end
				
				--pick a pet from the possible matches
				local maxLevel = 0
				local pet = nil
				for k,_ in pairs(matches) do
					if availablePets[k] and availablePets[k].level > maxLevel then
						pet = availablePets[k]
						maxLevel = availablePets[k].level
					end
				end
			
				if pet then
					self.teams[i][j].petID = pet.petID
				end
			end
		end
	end

	self.callbacks:Fire("TEAM_UPDATED")
end

