--[[ 	GupPet by Gup 	]]--
 
-- TEMP VARS
GUPPET_AUTOCOMPANION = {} ;
 
----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionBoot		 																	]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionBoot()

	GUPPET_AUTOCOMPANION.Frame = CreateFrame("Frame", "GUPPET_AUTOCOMPANIONFrameq"); 
	GUPPET_AUTOCOMPANION.TotalElapsed = 0;
	GUPPET_AUTOCOMPANION.Frame:Hide() ;
	GUPPET_AUTOCOMPANION.Force = false ; 

	GUPPET_AUTOCOMPANION.Frame:SetScript("OnEvent", function(self, event, ...) GupPet_AutoCompanionEvent(event, ...); end ) ;
	GUPPET_AUTOCOMPANION.Frame:SetScript("OnUpdate", function(self, elap) GupPet_AutoCompanionUpdate(self, elap); end ) ;
	GUPPET_AUTOCOMPANION.Frame:SetScript("OnShow", function() GUPPET_AUTOCOMPANION.TotalElapsed = 0; end) ;
	
	-- ResumonFrame
	GUPPET_AUTOCOMPANION.ResummonFrame = CreateFrame("Frame", "GUPPET_AUTOCOMPANIONResummonFrame"); 
	GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed = 0;
	GUPPET_AUTOCOMPANION.ResummonFrame:Hide() ;
	GUPPET_AUTOCOMPANION.ResummonFrame:SetScript("OnUpdate", GupPet_AutoCompanionResummonUpdate  ) ;
	GUPPET_AUTOCOMPANION.ResummonFrame:SetScript("OnShow", function() GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed = 0; end) ;	
	
	GupPet_AutoCompanionSetEnable() ;
	GupPet_AutoCompanionResumonSetEnable();
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionPetOfTheDay			 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionPetOfTheDay()

	if GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Enabled then
	
		local _, currentMonth, currentDay, currentYear = CalendarGetDate();
	
		if GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Month == currentMonth 
			and GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Day == currentDay 
				and GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Year == currentYear then 

					C_PetJournal.SummonPetByGUID( GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.PetId ) ;
				
			return true ;
		else 
			-- Get a new pet random
			GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Month = currentMonth ;
			GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Day = currentDay ;
			GUPPET_OPTIONS.AutoCompanion.PetOfTheDay.Year = currentYear;
		
			return false; 
		end
	else
		-- Its of go random
	
		return false; 
	end
end



----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionResumonSetEnable	 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionResumonSetEnable()

	if GUPPET_OPTIONS.AutoCompanion and GUPPET_OPTIONS.AutoCompanion.Resummon > 0 then
		GUPPET_AUTOCOMPANION.ResummonFrame:Show() ;
	else
		GUPPET_AUTOCOMPANION.ResummonFrame:Hide() ;
		GUPPET_AUTOCOMPANION.Force = false ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionResumonUpdate		 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionResummonUpdate(self, elap)

	GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed = GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed + elap ;

	if GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed > GUPPET_OPTIONS.AutoCompanion.Resummon then
		
		if IsResting() or GUPPET_OPTIONS.AutoCompanion.ResummonEveryWhere then
			GUPPET_AUTOCOMPANION.Force = true ;
			GUPPET_AUTOCOMPANION.Frame:Show();
			
		else
			GUPPET_AUTOCOMPANION.Force = false ;
		end
		
		GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed = 0 ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionUpdate		 																	]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionUpdate(self, elap)

	GUPPET_AUTOCOMPANION.TotalElapsed = GUPPET_AUTOCOMPANION.TotalElapsed + elap ;
	
	if GUPPET_AUTOCOMPANION.TotalElapsed > GUPPET_OPTIONS.AutoCompanion.Delay then 
		
		GUPPET_AUTOCOMPANION.TotalElapsed = 0 ;
		local _, instanceType = IsInInstance() ;
		
		if GUPPET_OPTIONS.AutoCompanion.City and IsResting() then
		elseif ( GUPPET_OPTIONS.AutoCompanion.BattleGround and instanceType == "pvp" ) then
		elseif ( GUPPET_OPTIONS.AutoCompanion.Arena and instanceType == "arena" ) then
		elseif ( GUPPET_OPTIONS.AutoCompanion.Party and instanceType == "party" ) then
		elseif ( GUPPET_OPTIONS.AutoCompanion.Raid and instanceType == "raid" ) then
		elseif ( GUPPET_OPTIONS.AutoCompanion.Outside and not( IsResting() ) and instanceType == "none"  ) then
		else
			GUPPET_AUTOCOMPANION.Frame:Hide() ;
			return ;
		end
		
		if IsMounted() or IsFlying() then
		
			if GUPPET_OPTIONS.AutoCompanion.DismissMounted then
				if C_PetJournal.GetSummonedPetGUID() then C_PetJournal.SummonPetByGUID(C_PetJournal.GetSummonedPetGUID()) end
			end
				
			GupPet_Debug( "Return") ;
			GUPPET_AUTOCOMPANION.Frame:Hide() ;
			return 
		 
		elseif IsStealthed() or IsFalling() or UnitCastingInfo("player") or UnitChannelInfo("player") or InCombatLockdown() or not(HasFullControl()) 
			or UnitBuff("player", GUPPET_TEMPCLASSDATA["FeignDeath"]["Name"]) 
			or UnitBuff("player", GUPPET_TEMPCLASSDATA["SpiritOfRedemption"]["Name"] ) 
			or UnitBuff("player", GUPPET_TEMPCLASSDATA["Invisibility"]["Name"])
			or UnitBuff("player", GUPPET_TEMPCLASSDATA["Camouflage"]["Name"] )
			or UnitIsDead("player") 
			or UnitIsDeadOrGhost("player")
			or UnitBuff("player", TUTORIAL_TITLE11  ) or UnitBuff("player", TUTORIAL_TITLE12 ) then
				
			GupPet_Debug( "Return") ;
			return 
		end
		
		-- Dont summmon while looting
		if LootFrame:IsVisible() then
			return
		end
		
		if GUPPET_AUTOCOMPANION.Force then
			GUPPET_AUTOCOMPANION.Force = false ;
		else
		
			if  C_PetJournal.GetSummonedPetGUID() then
				GUPPET_AUTOCOMPANION.Frame:Hide() ;
				return ;
				
			end	
		end
		
		if GupPet_AutoCompanion_OnQuest() then
			GUPPET_AUTOCOMPANION.Frame:Hide() ;
			return ;
		end
		
		if not GupPet_AutoCompanionPetOfTheDay() then 
			GupPet_PreCallCompanion() ;
		end
		
		GUPPET_AUTOCOMPANION.Frame:Hide() ;		
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionSetEnable	 																	]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionSetEnable()

	if GUPPET_OPTIONS.AutoCompanion.Enabled then
	
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("COMPANION_UPDATE") ;		--For dismounting
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("PLAYER_UNGHOST") ; 		--Walking to corpse
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("PLAYER_ALIVE") ;			--Res
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("ZONE_CHANGED") ;			--Portal or summon not far away 
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA") ;	--Portal 
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("PLAYER_CONTROL_GAINED") ; --After taxi
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("UNIT_EXITED_VEHICLE") ; 	--After using a vehicle
	--	GUPPET_AUTOCOMPANION.Frame:RegisterEvent("UPDATE_STEALTH") ; 		--Dismiss for Stealth
		
		GUPPET_AUTOCOMPANION.Frame:Show() ;
	else
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("COMPANION_UPDATE") ;
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("PLAYER_UNGHOST") ;	
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("PLAYER_ALIVE") ;		
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("ZONE_CHANGED_NEW_AREA") ;
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("ZONE_CHANGED") ;
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("PLAYER_CONTROL_GAINED") ;
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("UNIT_EXITED_VEHICLE") ;
	--	GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("UPDATE_STEALTH") ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanionEvent		 																	]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanionEvent(event, ... )

	if ... and ... == "CRITTER" then
		return ;
	end
	
	if InCombatLockdown() then 
				
		GUPPET_AUTOCOMPANION.Frame:RegisterEvent("PLAYER_REGEN_ENABLED") ;
		return  ;
	else
		GUPPET_AUTOCOMPANION.Frame:UnregisterEvent("PLAYER_REGEN_ENABLED") ;
	end
				
	if not( HasFullControl() ) then 
		return ;
	end
		
	GUPPET_AUTOCOMPANION.Frame:Show() ;
end
 
----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoCompanion_OnQuest	 																	]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoCompanion_OnQuest()
	local CurrentMap = ""
 
	for Item , Map in pairs(GUPPET_ITEMDATA.Quest) do
	
		if GetItemCount(Item) > 0 then
			 
			if #Map == 0 then
				return true
			else
				if not WorldMapFrame:IsVisible()  then
					SetMapToCurrentZone();
					CurrentMap = GetMapInfo() ;
				else
					return true
				end
			end
			
			for i = 1 , #Map do
								
				if Map[i] == CurrentMap then
					return true
				end
			end
			
		end
	end
 
 return false ;
end 
 	