--------------------------------------------------------------------------------------------------------------
--	GupPet_Mount_CanFlyThisContinent		 																--
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
function GupP_Mount_CanFlyThisContinent()

	local spellname = GetSpellInfo( 90267 ) ; --EDDIT TO VAnilla  Flight Master's License
	--Flight Master's License
	if not  IsUsableSpell(spellname) then
		
		-- To avoid errors
		if InCombatLockdown() then return false end 
		
		local savedContinent, savedZone = GetCurrentMapContinent(), GetCurrentMapZone();
		SetMapToCurrentZone();
		local continent = GetCurrentMapContinent();
		SetMapZoom(savedContinent, savedZone);
		
		if continent == -1 or continent == 1 or continent == 2 or continent == 5 then -- BG, Kalimdor, Eastern Kingdom or Maelstrom (Deepholm)
			return false ;
		end
	end
	
	--Check flyspells
	local spellname = GetSpellInfo( 54197 ) ;
	
	-- ColdWeather 
	if not  IsUsableSpell(spellname) then
	
		-- To avoid errors
		if InCombatLockdown() then return false end 
	
		local savedContinent, savedZone = GetCurrentMapContinent(), GetCurrentMapZone();
		SetMapToCurrentZone();
		local continent = GetCurrentMapContinent();
		SetMapZoom(savedContinent, savedZone);
		
		if continent == 4 then -- Northrend
			return false;
		end
	end
	
	return true;
  
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_CanFly							 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
GupPet_Temp_CanFly = 0 ;

function GupPet_CanFly()

	-- Swimming logic
	local isFlyerUsable = false ;
	if GUPPET_SAVEDDATA["Fly"][GupPet_Temp_CanFly] then
		isFlyerUsable = IsUsableSpell( GUPPET_SAVEDDATA["Fly"][GupPet_Temp_CanFly]["Id"] )
	end
	
	if IsSwimming() and not( isFlyerUsable ) then
		return false ;
	end
	
	if  GupP_Mount_CanFlyThisContinent() == false  then
		return false ;
	end
	
	if not(isFlyerUsable) and GUPPET_SAVEDDATA["Fly"][GupPet_Temp_CanFly] then
		return false ;
	end
		
	-- Check for active World PVP
	local numWorldPvP = GetNumWorldPVPAreas();
	local currentZone = GetZoneText() ;
	
	for i=1,numWorldPvP do
		local	_, localizedName, isActive = GetWorldPVPAreaInfo(i);
		
		if localizedName == currentZone and isActive then
			return false ;
		elseif localizedName == currentZone then
			return true; 
		end
	end
	
	if  not(IsFlyableArea()) then
		return false ;
	else
		return true ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_ExitVehicle						 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_ExitVehicle()
	if UnitInVehicle("player")  then
		VehicleExit() ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_Exit								 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_Exit()

	if IsMounted() then
	
		Dismount() ;
		return true ;
	
	elseif UnitInVehicle("player")  then
	
		VehicleExit() ;
		return true ;
	else
		return false ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoMultiGround						 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoMultiGround()
	
	if GupPet_PreMounten( "Multi" ) then return end -- If you can mount return

end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoMounten						 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoMounten()
	
	if GupPet_Exit() then return end	-- If you exit something return

	if GupPet_CanFly() then 	
		if GupPet_AutoFly() then return end -- If you can fly return
	end

	if GupPet_AutoGround() then return end -- If you can mount return

end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoGround						 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoGround()
	if GupPet_Exit() then return end ;	-- If you exit something return
	if IsSwimming() then  if GupPet_PreMounten( "Aquatic" ) then return end end -- If you can swim then swim ;p
	
	if GupPet_PreMounten( "Ground" ) then	return true end ;
	
	return false;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoFly						 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoFly()
	if GupPet_Exit() then return end ;	-- If you exit something return

	if GupPet_PreMounten( "Fly" ) then	return true end ;

	return false;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_AutoDismount						 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_AutoDismount( dismount ) 
	if dismount then
		GupPetFrame:RegisterEvent("UI_ERROR_MESSAGE");
		GUPPET_OPTIONS["AutoDismount"] = true ;
	else
		GupPetFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		GUPPET_OPTIONS["AutoDismount"] = false ;
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_PreMounten					 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_PreMounten( MountType )
	
	local Location = GetRealZoneText() ;

	-- First check if you got something enabled for this Location 
	if GUPPET_SAVEDLOCATIONS[ Location ] then
	
		if GUPPET_SAVEDDATA[MountType]["TotalWeight"][ Location ] > 0 then	
			GupPet_Mounten( MountType , Location ) ; 
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
		
	if GUPPET_SAVEDDATA[MountType]["TotalWeight"][ Location ] > 0 then	
		GupPet_Mounten( MountType , Location ) ; 
		return true ;
	end
	
	if GUPPET_SAVEDDATA[MountType]["TotalWeight"][ GUPPET_C["M_GLOBALWORLD"] ] > 0 then	
		GupPet_Mounten( MountType , GUPPET_C["M_GLOBALWORLD"] ) ; 
		return true ;
	end
	
	return false;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_Mounten						 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_Mounten( MountType , Location   ) 

	--Delay pet summoning so if you got a small amount off lag you wont get kicked off your mount again 
	if GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed then
		GUPPET_AUTOCOMPANION.ResummonFrame.TotalElapsed = -3 ;
	end

	
	local MountSlots = { Total=0} ;

	for i = 1 , GUPPET_SAVEDDATA[ MountType ]["Total"] do 

		if GUPPET_SAVEDDATA[ MountType ][i]["Weight"][ Location ] > 0 then
		
			for q = 1 , GUPPET_SAVEDDATA[ MountType ][i]["Weight"][ Location ] do
		
				MountSlots.Total = MountSlots.Total + 1;
			--	MountSlots[MountSlots.Total] = GUPPET_SAVEDDATA[ MountType ][i]["Slot"] ;
				MountSlots[MountSlots.Total] = GUPPET_SAVEDDATA[ MountType ][i]["CreatureID"] ;
			end
		end
	end

	if MountSlots.Total > 0 then
	
		local randomMount =  math.random( MountSlots.Total  ) ;
		
		
		for i = 1, GetNumCompanions("MOUNT") do
            local creatureID = GetCompanionInfo("MOUNT", i);
            
			if MountSlots[randomMount] == creatureID then
				
                CallCompanion("MOUNT", i);
                return;
            end
        end
		
--		CallCompanion("MOUNT", MountSlots[randomMount] ) ;
	end
end