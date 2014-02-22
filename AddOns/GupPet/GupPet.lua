--[[ 	GupPet by Gup 	]]--

-- SAVED VARS
GUPPET_SAVEDDATA = { Ground = { Total=0  } , Fly = { Total=0} , Aquatic = { Total=0} , Unknown= { Total=0}, Companion = { Total=0}  } ;

GUPPET_SAVEDLOCATIONS = { [GUPPET_C["M_GLOBALWORLD"]] = 0 , [GUPPET_C["M_CITIES"]] = 10 , [GUPPET_C["M_INSTANCES"]] = 20 , [GUPPET_C["M_ARENAS"]] =30 , [GUPPET_C["M_BATTLEGROUNDS"]] = 40  };

GUPPET_OPTIONS = { Debug = false , Mode = "Expert_", NewVersion = 0 , PreviewFrameSpeed = 1, PreviewFrameStartPos = 0,
						AutoCompanion 	= { Resummon = 0, Enabled = false, Delay = 2, City = true , Arena = true , BattleGround = true , Outside = true , Party = true , Raid = true, DismissMounted = false, 
												PetOfTheDay = { Enabled = false , Month = 0 , Day = 0, Year = 0 , PetId = 0 }
											}, 
						IngameButton 	= { RelativePoint = "CENTER" , xOffset = 0 , yOffset = 0, Scale = 1 , Show = true , Lock = false , MountButton = "Auto" , Alignment = "H" , CompanionButton = true, Icons = { Ground = "Interface\\Icons\\Ability_Mount_Mammoth_Black.blp" , Fly = "Interface\\Icons\\Ability_Mount_Drake_Bronze.blp" , Auto = "Interface\\Icons\\Ability_Mount_Drake_Azure.blp" , Companion = "Interface\\Icons\\INV_Box_PetCarrier_01.blp" }}, 
						Class 			= { FlyForm = true , AquaticForm = true  }  
					} ;

-- TEMP VARS
GUPPET_AUTOCOMPANION = {} ;
GUPPET_TEMPCLASSDATA = { Type = ""} ; --  "MAGE", "WARRIOR", "HUNTER", "PALADIN", "DRUID", "SHAMAN", "DK", "PRIEST" 

-- ADD it to the frames so you can Escape it away ;)
tinsert(UIMenus, "GupPet_InterfaceOptionsFrame");
tinsert(UIMenus, "GupPet_IconPopupFrame");

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_SlashCommand			 																		]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_SlashCommand(msg)
	
	msg = string.lower( msg ) ;
	local command, param = msg:match("^(%S*)%s*(.-)$");

	
	if command == GUPPET_S["MULTIGROUNDMOUNT"][1] or command == GUPPET_S["MULTIGROUNDMOUNT"][2] then	GupPet_PreMounten( "Multi" )
	elseif command == GUPPET_S["AQUATICMOUNT"][1] or command == GUPPET_S["AQUATICMOUNT"][2] then		GupPet_PreMounten( "Aquatic" )
	elseif command == GUPPET_S["AUTOMOUNT"][1] or command == GUPPET_S["AUTOMOUNT"][2] then				GupPet_AutoMounten()
	elseif command == GUPPET_S["CALLCOMPANION"][1] or command == GUPPET_S["CALLCOMPANION"][2] then		GupPet_PreCallCompanion()
	elseif command == GUPPET_S["AUTOGROUNDMOUNT"][1] or command == GUPPET_S["AUTOGROUNDMOUNT"][2] then	GupPet_AutoGround()
	elseif command == GUPPET_S["AUTOFLYMOUNT"][1] or command == GUPPET_S["AUTOFLYMOUNT"][2] then		GupPet_AutoFly()
	elseif command == GUPPET_S["DEBUG"][1] or command == GUPPET_S["DEBUG"][2] then
	
		if GUPPET_OPTIONS.Debug == false then
		
			GUPPET_OPTIONS.Debug = true ;
			GupPet_Text( GUPPET_T["DEBUGMODEON"] );
		else
			GUPPET_OPTIONS.Debug = false ;
			GupPet_Text( GUPPET_T["DEBUGMODEOFF"] );		
		end		

	elseif command == GUPPET_S["TOGGLEINCONSIS"][1] or command == GUPPET_S["TOGGLEINCONSIS"][2] then
	
		if GUPPET_OPTIONS.Class.Inconsistent then
			GUPPET_OPTIONS.Class.Inconsistent = false ;
		else
			GUPPET_OPTIONS.Class.Inconsistent = true ;
		end
	
 	elseif command == GUPPET_S["OPTIONMENU"][1] or command == GUPPET_S["OPTIONMENU"][2] or command == ""  then 
		if param == GUPPET_S["SLASH_T_OM_RESET"] then
			GupPet_InterfaceOptionsFrame:ClearAllPoints();
			GupPet_InterfaceOptionsFrame:SetPoint("CENTER",0, 0);
		end
			ShowUIPanel(GupPet_InterfaceOptionsFrame);
	
	else  
		GupPet_Text( GUPPET_T["UNKNOWNSLASHCOMMAND"] );
		
		for i=1 , #GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"] do
			
			print( GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][i] );
		
		
		end
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_OnLoad				 																		]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_OnLoad(self)

	SLASH_GUPPET1 = "/GupPet" 
	
	if (GetLocale() ~= "esES") then
		SLASH_GUPPET2 = "/GP" ;
	end
	
 	SlashCmdList["GUPPET"] = GupPet_SlashCommand;
	
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("COMPANION_LEARNED");	
	self:RegisterEvent("COMPANION_UPDATE");
	self:RegisterEvent("UPDATE_BINDINGS");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB");  	-- For update fly

	self:RegisterEvent("CHAT_MSG_ADDON");			-- Listen for a Update spam message
	
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	
	-- Newly added --
	self:RegisterEvent("PET_JOURNAL_LIST_UPDATE");
	self.TotalElapsed = 0;
	self:SetScript("OnUpdate", GupPet_UpdateCompanionDataListTime  ) ;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_OnEvent				 																		]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_OnEvent(self, event, ...) --self, event, ...

	
	GupPet_Debug( event );
	
	

	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD");
		
		if not GUPPET_OPTIONS.HideLoaded then
			GupPet_Text( GUPPET_T["LOADED"] );
		end
		
		if GUPPET_Z["SUPPORT"] == false then  GupPet_Text( GUPPET_T["NOTSUPPORTED"] ) ; end
				
		GupPet_UpdateDataList() ;
		GupPet_UpdateClassDataList() ; -- CLASS 
		
		GupPet_Interface_UpdateLocationFrame() ;
			
		GupPet_AutoCompanionBoot() ;
		
		GupPet_Interface_Option() ;
		GupPet_Interface_IngameButtons();
		GupPet_Interface_IngameButtons_UpdateIcons();
		
		GupPet_AutoDismount( GUPPET_OPTIONS["AutoDismount"] ) ;
		
		-- for buttons to the optionmenu
		GupPet_Interface_MakeButtons() ;
		GupPet_Interface_MinimapButton_Init() ;
		
		if IsInGuild() then
			GupPet_SendMyVersion( "GUILD" ) ;
		end
		
		self:Show();
		
	elseif event == "VARIABLES_LOADED" then
	
		-- SET to Default from versions lower then 1.00 
		if GUPPET_OPTIONS.IngameButton == nil then
			GUPPET_OPTIONS = { Debug = false , Mode = "Expert_", 
								AutoCompanion 	= { Enabled = false, Delay = 2, City = true , Arena = true , BattleGround = true , Outside = true , Party = true , Raid = true  }, 
								IngameButton 	= { RelativePoint = "CENTER" , xOffset = 0 , yOffset = 0, Scale = 1 , Show = true , Lock = false , MountButton = "Auto" , CompanionButton = true}, 
								Class 			= { FlyForm = true , AquaticForm = true  }  
							} ;
		end
				
		if not GUPPET_OPTIONS.NewVersion then GUPPET_OPTIONS.NewVersion = 0 ; end
		if not GUPPET_OPTIONS.PreviewFrameSpeed then GUPPET_OPTIONS.PreviewFrameSpeed = 1; end
		if not GUPPET_OPTIONS.PreviewFrameStartPos then GUPPET_OPTIONS.PreviewFrameStartPos = 0; end
			
		if not GUPPET_OPTIONS.IngameButton.Icons then	
			GUPPET_OPTIONS.IngameButton.Icons = { 	Ground = "Interface\\Icons\\Ability_Mount_Mammoth_Black" , 
													Fly = "Interface\\Icons\\Ability_Mount_Drake_Bronze" , 
													Auto = "Interface\\Icons\\Ability_Mount_Drake_Azure" , 
													Companion = "Interface\\Icons\\INV_Box_PetCarrier_01" }
		end 
		
		if not GUPPET_OPTIONS.AutoCompanion.DismissMounted then GUPPET_OPTIONS.AutoCompanion.DismissMounted = false; end
		
		if not GUPPET_OPTIONS.IngameButton.Alignment then GUPPET_OPTIONS.IngameButton.Alignment = "H" ; end 
		
		if not ( GUPPET_OPTIONS.AutoCompanion.Party or GUPPET_OPTIONS.AutoCompanion.Raid ) and GUPPET_OPTIONS.AutoCompanion.Instance then 
			GUPPET_OPTIONS.AutoCompanion.Party = GUPPET_OPTIONS.AutoCompanion.Instance ;
			GUPPET_OPTIONS.AutoCompanion.Raid = GUPPET_OPTIONS.AutoCompanion.Instance ;
			GUPPET_OPTIONS.AutoCompanion.Instance = nil ;
		end
		
		if not GUPPET_OPTIONS.AutoCompanion.Resummon then GUPPET_OPTIONS.AutoCompanion.Resummon = 0 end
		
		if not GUPPET_OPTIONS.AutoCompanion.ResummonEveryWhere == nil then GUPPET_OPTIONS.AutoCompanion.ResummonEveryWhere = false; end 
		
		if not GUPPET_OPTIONS.MinimapButton then 
			GUPPET_OPTIONS.MinimapButton = { Show = false , Radius = 78 , Position = 355 , xOffset = 0 , yOffset = 0 , Lock = true , RelativePoint = ""  } ;
		end
	 
		if not GUPPET_SAVEDDATA.MultiGround then  GUPPET_SAVEDDATA.MultiGround = { Total=0} ; end
	 
		if not GUPPET_OPTIONS.AutoCompanion.PetOfTheDay then
			GUPPET_OPTIONS.AutoCompanion.PetOfTheDay = { Enabled = false , Month = 0 , Day = 0, Year = 0 , PetId = 0 } ;
		end
	 
		
		if not GUPPET_SAVEDDATA.Ground then GUPPET_SAVEDDATA = { Ground={Total=0} , Multi={Total=0} , Fly = { Total=0} , Aquatic = { Total=0} , Unknown= { Total=0}, Companion = { Total=0}  } ; end
	 
	elseif event == "COMPANION_LEARNED" then

		GupPet_Debug( "New Pet/Mount" );
		GupPet_UpdateDataList() ;
		GupPet_Interface_UpdateLocationFrame() ;
	
	elseif event == "UI_ERROR_MESSAGE" then
		
		local arg1 = ... ;
	
		if UnitOnTaxi("player") then 
		elseif ( arg1 == ERR_NOT_WHILE_MOUNTED 
			or arg1 == SPELL_FAILED_NOT_MOUNTED 
			or arg1 == ERR_ATTACK_MOUNTED 
			or arg1 == ERR_TAXIPLAYERALREADYMOUNTED 
			or arg1 == SPELL_FAILED_NOT_ON_MOUNTED ) 
			and not IsFlying() then
			
			GupPet_Debug( "Dismount" ) ; 
			Dismount() ;
		end
		
		return ;

	elseif 	event == "UPDATE_BINDINGS" or event == "PLAYER_REGEN_ENABLED" then
		
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED") ;
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED") ;
		
			GupPet_Interface_IngameButtons() ;
					
			GupPet_UpdateBindings( "GUPPET_AUTO" 			, GupPet_IngameFrameTemplateAuto );
			GupPet_UpdateBindings( "GUPPET_AUTOGROUND"		, GupPet_IngameFrameTemplateGround );
			GupPet_UpdateBindings( "GUPPET_AUTOFLY" 		, GupPet_IngameFrameTemplateFly );
			GupPet_UpdateBindings( "GUPPET_CALLCOMPANION" 	, GupPet_IngameFrameTemplateCompanion );
		end
		
	elseif event == "COMPANION_UPDATE" then	
		
		local arg1 = ... ;
	
		if arg1 == nil then 
		
			GupPet_UpdateDataList() ;
			GupPet_Interface_UpdateLocationFrame() ;
			self:UnregisterEvent("COMPANION_UPDATE");
		end
		
	elseif event == "PET_JOURNAL_LIST_UPDATE" then
	
		self:UnregisterEvent("PET_JOURNAL_LIST_UPDATE");
	
	elseif event == "LEARNED_SPELL_IN_TAB" then 
		
		GupPet_UpdateClassDataList() ;
	
	elseif event == "CHAT_MSG_ADDON" then
	
		local arg1 , arg2 , arg3 , arg4 = ... ;
		
		if arg1 == "GupPetVersion" then -- Listen for new versions
	
			n_arg2 = tonumber( arg2 ) ;
			
			if n_arg2 > tonumber(GetAddOnMetadata("GupPet", "Version")) and n_arg2 > GUPPET_OPTIONS.NewVersion   then	 
				GupPet_Text( "|cffee4400".. GUPPET_T["NEWVERSIONFOUND"] .. arg2) ;
				GUPPET_OPTIONS.NewVersion = n_arg2 ;
			end
			
		elseif 	arg1 == "GupPet_GVer" then -- GupPet_GetVersion
			GupPet_SendMyVersion( "WHISPER" , arg4 ) ;
		elseif 	arg1 == "GupPet_RVer" then -- GupPet_ReturnVersion
			GupPet_Text( arg4 .. " uses ".. arg2);
		end
 
	end
	
	if event == "PLAYER_REGEN_DISABLED" then
	 
		if GUPPET_TEMPCLASSDATA.Type == "DRUID" then
				
				local BuildMacro = "/use "

				if GUPPET_TEMPCLASSDATA["Aquatic"]["Usable"] then
					BuildMacro = BuildMacro .."[swimming,nomounted] "..GUPPET_TEMPCLASSDATA["Aquatic"]["Name"] ..";"
				end
				
				if GUPPET_TEMPCLASSDATA["Travel"]["Usable"] then
					BuildMacro = BuildMacro .."[outdoors,nomounted] "..GUPPET_TEMPCLASSDATA["Travel"]["Name"] ..";"
				end
				
				if GUPPET_TEMPCLASSDATA["Cat"]["Usable"] and GUPPET_OPTIONS["Class"]["CatOnIndoors"] then
					BuildMacro = BuildMacro .."[indoors,nomounted] "..GUPPET_TEMPCLASSDATA["Cat"]["Name"] ..";"
				end
				
				BuildMacro = BuildMacro .."\n/script GupPet_Exit()" ;
				
				_G["GupPet_IngameFrameTemplateAuto"]:SetAttribute("macrotext", BuildMacro );
				_G["GupPet_IngameFrameTemplateAuto"]:SetAttribute("shift-macrotext1", BuildMacro );
				_G["GupPet_IngameFrameTemplateGround"]:SetAttribute("macrotext", BuildMacro );
				_G["GupPet_IngameFrameTemplateGround"]:SetAttribute("shift-macrotext1", BuildMacro );

		elseif GUPPET_TEMPCLASSDATA.Type == "SHAMAN" then
		
			if GUPPET_TEMPCLASSDATA["Ghost"]["Usable"] then
				_G["GupPet_IngameFrameTemplateAuto"]:SetAttribute("macrotext", "/use [nomounted] "..GUPPET_TEMPCLASSDATA["Ghost"]["Name"] .."\n/script GupPet_Exit()")
				_G["GupPet_IngameFrameTemplateGround"]:SetAttribute("macrotext", "/use [nomounted] "..GUPPET_TEMPCLASSDATA["Ghost"]["Name"] .."\n/script GupPet_Exit()")
			end

		elseif GUPPET_TEMPCLASSDATA.Type == "MAGE" then
		
			if GUPPET_OPTIONS["Class"]["SlowFallOnFalling"] and GUPPET_TEMPCLASSDATA["SlowFall"]["Usable"] then
				_G["GupPet_IngameFrameTemplateAuto"]:SetAttribute("macrotext", "/use [nomounted] "..GUPPET_TEMPCLASSDATA["SlowFall"]["Name"] .."\n/script GupPet_Exit()")
				_G["GupPet_IngameFrameTemplateGround"]:SetAttribute("macrotext", "/use [nomounted] "..GUPPET_TEMPCLASSDATA["SlowFall"]["Name"] .."\n/script GupPet_Exit()")
			end
		end
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_SendMyVersion				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_SendMyVersion( To , Target )	--GUILD , WHISPER

	local MyVersion = tonumber( GetAddOnMetadata("GupPet", "Version")) ;
	
	if To == "GUILD" then --Send latest know version of the addon.
		if MyVersion < GUPPET_OPTIONS.NewVersion then
			SendAddonMessage("GupPetVersion", GUPPET_OPTIONS.NewVersion , To ) ;
		else
			SendAddonMessage("GupPetVersion", MyVersion , To ) ;
		end
	
	elseif To == "WHISPER" and Target then
		SendAddonMessage( "GupPet_RVer" , MyVersion , "WHISPER" , Target ) ;

	end --SendAddonMessage( "GupPetVersion" , "1" , "WHISPER" , "Whazaa" ) ;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_UpdateBindings				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_UpdateBindings( binding , button )

	ClearOverrideBindings(button) ;
	local key1, key2 = GetBindingKey(binding) ;
	if key1 then
		SetOverrideBindingClick( button, true, key1, button:GetName() ) ;
	end 
	if key2 then
		SetOverrideBindingClick( button, true, key2, button:GetName() ) ;
	end 
end 

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_IsInBook				 																		]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_IsInBook( spell )
	
	local tempvar = { Usable = false }
	
	tempvar.Name = GetSpellInfo(spell) ;
	tempvar.Spell = spell ;
	tempvar.Usable = (GetSpellBookItemInfo(tempvar.Name ) == "SPELL" );

	return tempvar
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_UpdateClassDataList				 															]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_UpdateClassDataList()
	
	local temp ;

	 temp, GUPPET_TEMPCLASSDATA.Type = UnitClass("player") ;

	if GUPPET_TEMPCLASSDATA.Type == "HUNTER" then
		
		GUPPET_TEMPCLASSDATA["Pack"]  	= GupPet_IsInBook( GUPPET_CLASSDATA.HUNTER.Pack ) ;
		GUPPET_TEMPCLASSDATA["Cheetah"] = GupPet_IsInBook( GUPPET_CLASSDATA.HUNTER.Cheetah ) ;
	
	elseif GUPPET_TEMPCLASSDATA.Type == "DRUID" then
	
		GUPPET_TEMPCLASSDATA["Travel"]  = GupPet_IsInBook( GUPPET_CLASSDATA.DRUID.Travel ) ;
		GUPPET_TEMPCLASSDATA["SlowFly"] = GupPet_IsInBook( GUPPET_CLASSDATA.DRUID.SlowFly ) ;
		GUPPET_TEMPCLASSDATA["FastFly"] = GupPet_IsInBook( GUPPET_CLASSDATA.DRUID.FastFly ) ;
		GUPPET_TEMPCLASSDATA["Aquatic"] = GupPet_IsInBook( GUPPET_CLASSDATA.DRUID.Aquatic ) ;
		GUPPET_TEMPCLASSDATA["Cat"]  	= GupPet_IsInBook( GUPPET_CLASSDATA.DRUID.Cat ) ;
	
	elseif GUPPET_TEMPCLASSDATA.Type == "SHAMAN" then
		
		GUPPET_TEMPCLASSDATA["Ghost"] = GupPet_IsInBook( GUPPET_CLASSDATA.SHAMAN.Ghost ) ;
		GUPPET_TEMPCLASSDATA["WaterWalking"] = GupPet_IsInBook( GUPPET_CLASSDATA.SHAMAN.WaterWalking ) ;
		
	elseif GUPPET_TEMPCLASSDATA.Type == "MAGE" then
	
		GUPPET_TEMPCLASSDATA["SlowFall"]  = GupPet_IsInBook( GUPPET_CLASSDATA.MAGE.SlowFall ) ;
		
	elseif GUPPET_TEMPCLASSDATA.Type == "DEATHKNIGHT" then
	
		GUPPET_TEMPCLASSDATA["PathOfFrost"]  = GupPet_IsInBook( GUPPET_CLASSDATA.DEATHKNIGHT.PathOfFrost ) ;
	
	end
	
	------ 
	GUPPET_TEMPCLASSDATA["SpiritOfRedemption"] = {} ;
	GUPPET_TEMPCLASSDATA["FeignDeath"] = {} ;
	GUPPET_TEMPCLASSDATA["Invisibility"] = {} ;
	GUPPET_TEMPCLASSDATA["SpiritOfRedemption"]["Name"]  = GetSpellInfo( GUPPET_CLASSDATA.PRIEST.SpiritOfRedemption ) ;
	GUPPET_TEMPCLASSDATA["FeignDeath"]["Name"]  = GetSpellInfo( GUPPET_CLASSDATA.HUNTER.FeignDeath ) ;
	GUPPET_TEMPCLASSDATA["Camouflage"] = {} ;
	GUPPET_TEMPCLASSDATA["Camouflage"]["Name"]  = GetSpellInfo( GUPPET_CLASSDATA.HUNTER.Camouflage ) ;
	GUPPET_TEMPCLASSDATA["Invisibility"]["Name"]  = GetSpellInfo( GUPPET_CLASSDATA.MAGE.Invisibility ) ;
	------
	
end



----------------------------------------------------------------------------------------------------------------
--[[	GupPet_Location						 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_Location( Option , location , Type )
-- Option  = Add , Remove

	if Option == "Add" then
	
	-- First check if it is not already there ;) 
		for SavedLocation in pairs(GUPPET_SAVEDLOCATIONS) do
	
			if location == SavedLocation then
				return -1 ; -- Error .. Location Already here 
			end
		end
		
		GUPPET_SAVEDLOCATIONS[ location ] = Type ;
		
		GupPet_UpdateDataList() 
		return 1 ; -- OK .. Location Added
		
	elseif Option == "Remove" then
	
		Type = GUPPET_SAVEDLOCATIONS[location] ;
	
		if Type == 0 or  Type == 10 or  Type == 20 or  Type == 30 or  Type == 40 then
			return -2 ; -- Location is protected 
		end
		
		local GUPPET_SAVEDLOCATIONS_TEMP = {} ;
		
		for SavedLocation , Type in pairs(GUPPET_SAVEDLOCATIONS) do
			
			if SavedLocation == location then
			else
				GUPPET_SAVEDLOCATIONS_TEMP[SavedLocation] = Type ;
			end
		
		end
		
		GUPPET_SAVEDLOCATIONS = GUPPET_SAVEDLOCATIONS_TEMP ;
		return 2 ; -- OK .. Location Deleted
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_UpdateDataList				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_UpdateDataList()

	-- Update Companion list
	GupPet_UpdateCompanionDataList();



	-- OLD Style ( MOUNTS )
	
	GupPet_Debug( "GupPet_UpdateDataList Start" );	

	local	GUPPET_SAVEDDATA_TEMP = { Ground = { Total=0  } , Fly = { Total=0} , Multi = { Total=0}, Aquatic = { Total=0} , Unknown= { Total=0} , Companion = { Total=0}  } ;
		
	for slot = 1, GetNumCompanions("MOUNT") do
		local creatureID, creatureName, creatureSpellID , creatureIcon , summoned ,mountFlag = GetCompanionInfo("MOUNT", slot) ;
		local detected = false ;
	
		for DBMountID, DBMountData in pairs(Gup_MountData) do
		
			if DBMountID == creatureSpellID then
			
				if DBMountData[1] then
					detected = true ;
					GUPPET_SAVEDDATA_TEMP["Ground"]["Total"] = GUPPET_SAVEDDATA_TEMP["Ground"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Ground"][ GUPPET_SAVEDDATA_TEMP["Ground"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Ground" , creatureSpellID )  }
				end
				
				if DBMountData[30] then
					detected = true ;
					GUPPET_SAVEDDATA_TEMP["Multi"]["Total"] = GUPPET_SAVEDDATA_TEMP["Multi"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Multi"][ GUPPET_SAVEDDATA_TEMP["Multi"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Multi" , creatureSpellID )  }
				end
			
				if DBMountData[10] then
					detected = true ;
					GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] = GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Fly"][ GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Fly" , creatureSpellID )  }
				end
			
				if DBMountData[20] then
					detected = true ;
					GUPPET_SAVEDDATA_TEMP["Aquatic"]["Total"] = GUPPET_SAVEDDATA_TEMP["Aquatic"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Aquatic"][ GUPPET_SAVEDDATA_TEMP["Aquatic"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Aquatic" , creatureSpellID )  }
				end
				
				if not( DBMountData[1] and DBMountData[10] ) and DBMountData[10] then
					GupPet_Temp_CanFly = GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] ;
				end
				
				break; -- SpeedUp
				
			end
		end
		
		
		if detected == false then
		
		
				-- Flying mount --
				if GupPet_IsBitTrue(mountFlag,2) then
				
					GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] = GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Fly"][ GUPPET_SAVEDDATA_TEMP["Fly"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Fly" , creatureSpellID )  } 
				
				-- GROUND MOUNT --
				elseif GupPet_IsBitTrue(mountFlag,1) then
								
					GUPPET_SAVEDDATA_TEMP["Ground"]["Total"] = GUPPET_SAVEDDATA_TEMP["Ground"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Ground"][ GUPPET_SAVEDDATA_TEMP["Ground"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Ground" , creatureSpellID )  } 
							
				-- Usable at the water's surface --
				elseif GupPet_IsBitTrue(mountFlag,4) then
					GUPPET_SAVEDDATA_TEMP["Aquatic"]["Total"] = GUPPET_SAVEDDATA_TEMP["Aquatic"]["Total"] + 1 ;
					GUPPET_SAVEDDATA_TEMP["Aquatic"][ GUPPET_SAVEDDATA_TEMP["Aquatic"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = GupPet_CheckWeightData( "Aquatic" , creatureSpellID )  }
				
				-- Usable underwater --
--				elseif GupPet_IsBitTrue(mountFlag,8) then
				
				-- 0x10 - Can jump (the turtle mount cannot, for example) --
--				elseif GupPet_IsBitTrue(mountFlag,16) then
				end
		
	--		GUPPET_SAVEDDATA_TEMP["Unknown"]["Total"] = GUPPET_SAVEDDATA_TEMP["Unknown"]["Total"] + 1 ;
	--		GUPPET_SAVEDDATA_TEMP["Unknown"][ GUPPET_SAVEDDATA_TEMP["Unknown"]["Total"] ] =  { Name = creatureName , Id = creatureSpellID, CreatureID = creatureID ,Slot = slot , Weight = {}  }
		end
		
	end
	

	 
	GUPPET_SAVEDDATA["Ground"] = GUPPET_SAVEDDATA_TEMP["Ground"]
	GUPPET_SAVEDDATA["Multi"] = GUPPET_SAVEDDATA_TEMP["Multi"] ;
	GUPPET_SAVEDDATA["Fly"] = GUPPET_SAVEDDATA_TEMP["Fly"] ;
	GUPPET_SAVEDDATA["Aquatic"] = GUPPET_SAVEDDATA_TEMP["Aquatic"] ;

	
	GUPPET_SAVEDDATA["Ground"]["TotalWeight"] = GupPet_CheckWeightDataTotal( "Ground" ) ;
	GUPPET_SAVEDDATA["Multi"]["TotalWeight"] = GupPet_CheckWeightDataTotal( "Multi" ) ;
	GUPPET_SAVEDDATA["Fly"]["TotalWeight"] = GupPet_CheckWeightDataTotal( "Fly" ) ;
	GUPPET_SAVEDDATA["Aquatic"]["TotalWeight"] = GupPet_CheckWeightDataTotal( "Aquatic" ) ;
	
	
	GupPet_Debug( "GupPet_UpdateDataList End" );

--	if GUPPET_SAVEDDATA["Unknown"]["Total"]> 0 then
--		GupPet_Text( "|cffee4400".. GUPPET_T["UNKNOWNMOUNTFOUND"]   ) ;
	
--		for nr = 1 , GUPPET_SAVEDDATA["Unknown"]["Total"] do
--				GupPet_Text( "|cffee4400 "..  GUPPET_SAVEDDATA["Unknown"][nr]["Name"] .. " , "..  GUPPET_SAVEDDATA["Unknown"][nr]["Id"] ) ;
--		end
--	end
end


function GupPet_IsBitTrue(x, p)
	if x == nil then
		return false ;
	end

	if bit.band( x , p ) == p then
		return true;
	else
		return false ;
	end
end


----------------------------------------------------------------------------------------------------------------
--[[	GupPet_SetWeight					 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_SetWeight( Type , Id , Weight , Location )

	if Weight == nil or Weight == false then
		Weight = 0 ;
	elseif Weight == 1000 then
		
		for i=1 , GUPPET_SAVEDDATA[ Type ]["Total"] do
			GupPet_SetWeight( Type , i , 0 , Location )
		end
		return ;
		
	elseif Weight == 1001 then
		
		for i=1 , GUPPET_SAVEDDATA[ Type ]["Total"] do
			if GUPPET_SAVEDDATA[ Type ][ i ]["Weight"][ Location ] == 0 then
				GupPet_SetWeight( Type , i , 1 , Location )
			end
		end		
		return ;
	end
	
	local deltaWeight =	Weight - GUPPET_SAVEDDATA[ Type ][ Id ]["Weight"][ Location ] ;

	GUPPET_SAVEDDATA[ Type ][ Id ]["Weight"][ Location ] = Weight ;
	
	GUPPET_SAVEDDATA[ Type ]["TotalWeight"][ Location ] = GUPPET_SAVEDDATA[ Type ]["TotalWeight"][ Location ] + deltaWeight ;
	
	GupPet_Debug( "deltaWeight: "..deltaWeight .."   Weight: ".. Weight ) ;

end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_CheckWeightDataTotal			 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_CheckWeightDataTotal( MountType )

	local GUPPET_SAVEDLOCATIONS_TEMP = {} ;

	for Location in pairs(GUPPET_SAVEDLOCATIONS) do

		GUPPET_SAVEDLOCATIONS_TEMP[Location] = 0 ;
		
		for i = 1 , GUPPET_SAVEDDATA[ MountType ]["Total"] do
	
			GUPPET_SAVEDLOCATIONS_TEMP[Location] = GUPPET_SAVEDLOCATIONS_TEMP[Location] + GUPPET_SAVEDDATA[ MountType ][i]["Weight"][Location] ;
	
		end
	end
	
	return GUPPET_SAVEDLOCATIONS_TEMP ;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_CheckWeightData				 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_CheckWeightData( MountType , MountSpellID )

	local GUPPET_SAVEDLOCATIONS_TEMP = {} ;
	local NewMount = true ;
	
	if  GUPPET_SAVEDDATA[ MountType ] then
	
		for i = 1 , GUPPET_SAVEDDATA[ MountType ]["Total"] do
			if GUPPET_SAVEDDATA[ MountType ][i]["Id"] == MountSpellID then
				NewMount = false ;
				
				for Location in pairs(GUPPET_SAVEDLOCATIONS) do
				
					if GUPPET_SAVEDDATA[ MountType ][i]["Weight"][ Location ] then
						
						GUPPET_SAVEDLOCATIONS_TEMP[Location] = GUPPET_SAVEDDATA[ MountType ][i]["Weight"][ Location ] ;
					else
						GUPPET_SAVEDLOCATIONS_TEMP[Location] = 0 ;
					end
				end
			end
		end
	end

	if NewMount == true then
	
		for  Location in pairs(GUPPET_SAVEDLOCATIONS) do
			
			if Location == GUPPET_C["M_GLOBALWORLD"] then
				GUPPET_SAVEDLOCATIONS_TEMP[Location] = 1 ;				
			else
				GUPPET_SAVEDLOCATIONS_TEMP[Location] = 0 ;				
			end
		end
	end
		
	return GUPPET_SAVEDLOCATIONS_TEMP ;
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_Debug						 																]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_Debug( text )

	if GUPPET_OPTIONS.Debug then
		DEFAULT_CHAT_FRAME:AddMessage( text );
	end
end

----------------------------------------------------------------------------------------------------------------
--[[	GupPet_Text						 																	]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function GupPet_Text( text )
	
	DEFAULT_CHAT_FRAME:AddMessage( "GupPet: ".. text ) ;
end
	