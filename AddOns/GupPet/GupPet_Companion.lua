
----------------------------------------------------------------------------------------------------------------
--[[	GupPet_PreCallCompanion				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_PreCallCompanion()
	
	local Location = GetRealZoneText() ;

	-- First check if you got something enabled for this Location 
	if GUPPET_SAVEDLOCATIONS[ Location ] then
	
		if GUPPET_SAVEDDATA["Companion"]["TotalWeight"][ Location ] > 0 then	
			GupPet_CallCompanion( Location ) ; 
			return true ;
		end
	end
	
	local _, instanceType = IsInInstance() ;
	
	if ( IsResting() ) then
		Location = GUPPET_C["M_CITIES"]
	elseif ( instanceType == "pvp" ) then
		Location = GUPPET_C["M_BATTLEGROUNDS"]
	elseif ( instanceType == "arena" ) then
		Location = GUPPET_C["M_ARENAS"] ;
	elseif ( instanceType == "party" or instanceType == "raid" ) then
		Location = GUPPET_C["M_INSTANCES"] ;
	else
		Location = GUPPET_C["M_GLOBALWORLD"] ;
	end
		
	if GUPPET_SAVEDDATA["Companion"]["TotalWeight"][ Location ] > 0 then	
		GupPet_CallCompanion( Location ) ; 
		return true ;
	end
	
	if GUPPET_SAVEDDATA["Companion"]["TotalWeight"][ GUPPET_C["M_GLOBALWORLD"] ] > 0 then	
		GupPet_CallCompanion( GUPPET_C["M_GLOBALWORLD"] ) ; 
		return true ;
	end
		
	return false;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_CallCompanion				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_CallCompanion( Location ) 

	GupPet_Debug( Location );

	local CompanionSlots = { Total=0} ;
	local IsSummoned = false ;

	for i = 1 , GUPPET_SAVEDDATA[ "Companion" ]["Total"] do 

		if GUPPET_SAVEDDATA[ "Companion" ][i]["Weight"][ Location ] > 0 then

		--	_, _, _, _, IsSummoned = GetCompanionInfo("CRITTER", GUPPET_SAVEDDATA[ "Companion" ][i]["Slot"] );
			
			if not(IsSummoned) then
			
				for q = 1 , GUPPET_SAVEDDATA[ "Companion" ][i]["Weight"][ Location ] do
									
					CompanionSlots.Total = CompanionSlots.Total + 1;
					CompanionSlots[CompanionSlots.Total] = GUPPET_SAVEDDATA[ "Companion" ][i]["Id"] ;
				end
			end
		end
	end

	if CompanionSlots.Total > 0 then
	
		local randomMount =  math.random( CompanionSlots.Total  ) ;
		
		--CallCompanion("CRITTER", CompanionSlots[randomMount] ) ; 
		C_PetJournal.SummonPetByGUID(CompanionSlots[randomMount]);
		--C_PetJournal.GetSummonedPetGUID()
		
		-- Save the new pet ID 
		GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.PetId = CompanionSlots[randomMount] ; 
	
	elseif IsSummoned then
	
		GupPet_Text( GUPPET_T["CANTCALLCOMPANIONONEINTHETABLE"] );	
	
	else
		GupPet_Text( GUPPET_T["CANTCALLCOMPANION"] );	
	end
end


function GupPet_GetSummonedCompanion()

	return C_PetJournal.GetSummonedPetGUID()
end

function GupPet_UpdateCompanionDataListTime(self, elap)

	self.TotalElapsed = self.TotalElapsed + elap ;

	if self.TotalElapsed > 5 then
		self.TotalElapsed = 0 ;
				
		if not InCombatLockdown() then 
			if GupPet_UpdateCompanionDataList() > 0 then
				GupPet_Interface_UpdateLocationFrame() ;
				self:Hide() ;
			else
				self:Show();
			end
		end
	end
	
end


----------------------------------------------------------------------------------------------------------------
--[[	GupPet_UpdateCompanionDataList				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_UpdateCompanionDataList()

	GupPet_Debug( "GupPet_UpdateCompanionDataList Start" );	

	local	GUPPET_SAVEDDATA_TEMP = { Companion = { Total=0}  } ;

	-- Companions
--[[	for slot = 1, GetNumCompanions("CRITTER") do
		local creatureID, creatureName, creatureSpellID = GetCompanionInfo("CRITTER", slot) ;
		
		GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] = GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] + 1 ;
		GUPPET_SAVEDDATA_TEMP["Companion"][ GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] ] = { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID, Slot = slot , Weight = GupPet_CheckWeightData( "Companion" , creatureSpellID ) } ;
	end 
]]
	
	-- Companions out off the new database ..
    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true) -- displays pets we do have
    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, false) -- ignores pets we don't have
    C_PetJournal.ClearSearchFilter() -- prevents the game from crashing
 
    local numPets = C_PetJournal.GetNumPets(false)
	
	if numPets == 0  then
		return numPets;
	end
	
    for i=1,numPets do
       local creatureSpellID, speciesID, isOwned, customName, level,
            favorite, isRevoked, creatureName, icon, petType,
            creatureID, sourceText, description, isWildPet = C_PetJournal.GetPetInfoByIndex(i, false)

		GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] = GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] + 1 ;
		GUPPET_SAVEDDATA_TEMP["Companion"][ GUPPET_SAVEDDATA_TEMP["Companion"]["Total"] ] = { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID,  Weight = GupPet_CheckWeightData( "Companion" , creatureSpellID ) } ;

		
	   
--	   if name and name:lower() == petName:lower() and C_PetJournal.PetIsSummonable(petID) and petID ~= C_PetJournal.GetSummonedPetGUID() then
 --           return C_PetJournal.SummonPetByGUID(petID)
 --       end
    end
	
	
	
	
	GUPPET_SAVEDDATA["Companion"] = GUPPET_SAVEDDATA_TEMP["Companion"] ;
	GUPPET_SAVEDDATA["Companion"]["TotalWeight"] = GupPet_CheckWeightDataTotal( "Companion" ) ;

	
	GupPet_Debug( "GupPet_UpdateCompanionDataList END" );	
	
	return numPets;
end
