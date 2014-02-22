--[[ 
    __________________________________________
   /                ECLIPSE                   \
  |--------------------------------------------|
  |         Eclipse Cooldown Watcher           |
  |        Now also a debuff watcher!!         |
  |                                            |
  |            Author: Scruffles               |
  |--------------------------------------------|
   \__________________________________________/
   
   
		This code is completely dependent on the add-on Deadly Boss Mods, and some of the code is adapted from DBM itself
  and is therefore attributed to the author(s) of DBM.
   
   
--]]


		--[[ for reference DBT:CreateBar(timer, id, icon, huge, small, color)
				 the color arg requires a color table {r, g, b} -- all between 1 and 0
				 DBT:New() will create bars that are separate from DBM's main
				 e.g. DBM.Bars:CreateBar(30, "Eclipse Cooldown", "Interface\\Icons\\Ability_Druid_Eclipse")
				 DBT:CancelBar(id)
				 DBT:UpdateBar(id, elapsed, totalTime) --]]
				 
				 

--/----------\--
--| Defaults |--
--\----------/--



ECL = {}

ECL_DefaultOptions = {
			BarXOffset = 0,	
			BarYOffset = 0,
			HugeBarXOffset = 0,	
			HugeBarYOffset = 0,
			ExpandUpwards = false,
			Flash = true,
			FadeIn = true,
			Break = true,
			IconLeft = true,
			IconRight = false,
			Texture = "Interface\\AddOns\\DBM-Core\\textures\\default.tga",
			StartColorR = 1,
			StartColorG = 0.7,
			StartColorB = 0,
			EndColorR = 1,
			EndColorG = 0,
			EndColorB = 0,
			TextColorR = 1,
			TextColorG = 1,
			TextColorB = 1,
			DynamicColor = true,
			Width = 183,
			Scale = 0.9,
			HugeBarsEnabled = false,
			HugeWidth = 200,
			HugeScale = 1.03,
			TimerPoint = "CENTER",
			TimerX = 0,
			TimerY = -120,
			HugeTimerPoint = "CENTER",
			HugeTimerX = 0,
			HugeTimerY = -120,
			EnlargeBarsTime = 8,
			EnlargeBarsPercent = 0.125,
			FillUpBars = true,
			Font = STANDARD_TEXT_FONT,
			FontSize = 10,
		}
		
function DEF_Eclipse()

	if (Eclipse ~= nil) then
		Eclipse = table.wipe(Eclipse)
	end

	Eclipse = {
		CurrentEdit,
		Version = 0,
		lcl = {
			EW = "BLANK",
			EC = "BLANK",
			WR = "BLANK",
			SF = "BLANK",
			IS = "BLANK",
			MF = "BLANK",
			ER = "BLANK",
			FF = "BLANK",
			NG = "BLANK",
			OD = "BLANK",
			LA = "BLANK",
			TR1 = "BLANK",
			TR2 = "BLANK",
			IDOL = "BLANK",
			SolarECIcon = "BLANK",
			LunarECIcon = "BLANK",},
		Opt = {
			ECWEclipseCooldownCB = 1,
			ECWEclipseCB = 1,
			ECWInsectswarmCB = 1,
			ECWMoonfireCB = 1,
			ECWEluneCB = 1,
			ECWNGraceCB = 1,
			ECWRootsCB = 1,
			ECWFaerieCB = 1,
			ECWTrinketsCB = 1,
			ECWOmenDoomCB = 1,
			ECWLanguishCB = 1,
			ECWSeperateBarsCB = 1,},
		Colors = {
			Wrath = {r = 1, g = 0.4, b = 0},
			Starfire = {r = 0, g = 0.7, b = 0.7},
			Insectswarm = {r = 0, g = 0.7, b = 0},
			Moonfire = {r = 0.7, g = 0, b = 0},
			Elune = {r = 0, g = 0, b = 0.7},
			NGrace = {r = 0.25, g = 0.4, b = 1},
			Roots = {r = 0.25, g = 0.1, b = 0.1},
			Faerie = {r = 1, g = 0.4, b = 0.5},
			OmenDoom = {r = 0.5, g = 0, b = 0.5},
			Languish = {r = 0, g = 0.8, b = 0.3},
			Trinkets = {r = 0.5, g = 0.5, b = 0.5},},
		Var = {
			TR1splid = nil,
			TR2splid = nil,},
		}
end

do DEF_Eclipse() end

	local EclipseVersion = 3.6
	local ECLB = DBM.Bars
	local ECWcolor
	local color
	local icon
	local timer	
	
	-- Event Handler --

	ECL_EVENTS = {
		"ADDON_LOADED",
		"COMBAT_LOG_EVENT_UNFILTERED",
		"PLAYER_EQUIPMENT_CHANGED",
		"PLAYER_LEAVING_WORLD",
		"PLAYER_LOGOUT",
		"PLAYER_TARGET_CHANGED",
		"PLAYER_QUITING",
		"UNIT_AURA",};
	
	Eclipse_Event = CreateFrame("Frame");
	Eclipse_Event:SetScript("OnEvent", function(self, event, ...)
		local test = select(1, ...)
		if (test == nil) then
			ECL_EVENTS[event](self)
		else
			ECL_EVENTS[event](self, ...)
		end
	end);
	
	for k, v in pairs(ECL_EVENTS) do
		Eclipse_Event:RegisterEvent(v);
	end
	
	------------------

local ecl_load = 0

function Eclipse_Addon_Loaded()

	if (Eclipse.Opt == nil) then
		DEF_Eclipse();
	end
	
	if (EclipseVersion ~= Eclipse.Version) then
		-- Do stuff on version update
		DEF_Eclipse();
		
		Eclipse.Version = EclipseVersion
		Eclipse_Print("Welcome to version " .. Eclipse.Version .. "!")
	end
	
	ECL.Bars = DBT:New();
	
	Eclipse_loadOptions();
	
	Eclipse_GetSpellInfo();
	--Eclipse_GetItemInfo();
	--Eclipse_CreateGUIFrames()
	
	SlashCmdList["Eclipse"] = Eclipse_SlashCmd;
	SLASH_Eclipse1 = "/eclipse";
	SLASH_Eclipse2 = "/ecw";

	ColorPickerFrame.func = Eclipse_CustomColor
	
	--This must be called after variables are loaded.
	Eclipse_FrameCreation();
	
	Eclipse_Print("Use /eclipse to open the options panel.");

end


--[[function addDefaultOptions(t1, t2)
	for i, v in pairs(t2) do
		if t1[i] == nil then
			t1[i] = v
		elseif type(v) == "table" then
			addDefaultOptions(v, t2[i])
		end
	end
end--]]
	
function Eclipse_loadOptions()
	
	if (DBT_SavedOptions.Eclipse == nil) then
		ECL.Bars.options = ECL_DefaultOptions
		Eclipse_Print("Default Options Loaded.")
	else
		ECL.Bars.options = DBT_SavedOptions.Eclipse
		Eclipse_Print("Saved Options Loaded.")
	end
	
	ECL.Bars.defaultOptions = ECL_DefaultOptions
	
	local EBHtable = ECL.Bars.options
	ECL.Bars.mainAnchor:ClearAllPoints()
	ECL.Bars.mainAnchor:SetPoint(EBHtable.TimerPoint, UIParent, EBHtable.TimerPoint, EBHtable.TimerX, EBHtable.TimerY)
	ECL.Bars.secAnchor:ClearAllPoints()
	ECL.Bars.secAnchor:SetPoint(EBHtable.HugeTimerPoint, UIParent, EBHtable.HugeTimerPoint, EBHtable.HugeTimerX, EBHtable.HugeTimerY)

end

function Eclipse_GetSpellInfo()

	local name, rank, icon, powercost, isfunnel, powertype, castingtime, minrange, maxrange = GetSpellInfo(48517);
	Eclipse.lcl.EC = name;
	Eclipse.lcl.SolarECIcon = icon;
	
	local name, rank, icon, powercost, isfunnel, powertype, castingtime, minrange, maxrange = GetSpellInfo(48518);
	Eclipse.lcl.LunarECIcon = icon;

end

function Eclipse_GetItemInfo()

	local itemid = GetInventoryItemID("player", 13);
	local name, rank = GetItemSpell(itemid);
	Eclipse.lcl.TR1 = name;

	local itemid = GetInventoryItemID("player", 14);
	local name, rank = GetItemSpell(itemid);
	Eclipse.lcl.TR2 = name;

	local itemid = GetInventoryItemID("player", 18);
	local name, rank = GetItemSpell(itemid);
	Eclipse.lcl.IDOL = name;

end


--/-------------\--
--| Random Func |--
--\-------------/--

function Eclipse_Print(text)

	if (text == nil) then
	text = "nil"
	end
	
	DEFAULT_CHAT_FRAME:AddMessage("Ecl: " .. text, 0, 0.7, 0.7);

end


--/-----------\--
--| On Events  |--
--\-----------/--

function ECL_EVENTS:COMBAT_LOG_EVENT_UNFILTERED(...)

  local EclipsePlayer = UnitGUID("player")
  local EclipseTarget = UnitGUID("target")	

	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
	if (sourceGUID == EclipsePlayer) then
	
		
		if (type == "SPELL_AURA_APPLIED") or (type == "SPELL_AURA_REFRESH") then
		local spellId, spellName, spellSchool = select(9, ...)

			if (destGUID == EclipsePlayer) then
				Eclipse_Buffs(spellId, spellName)			
			end    -- end dest = player
			if (destGUID == EclipseTarget) then	
				Eclipse_Debuffs(spellId, spellName)			
			end    -- end dest = target	
		end    -- end  type and source
	--------------------------------------	
	
		if (type == "SPELL_DAMAGE") and (sourceGUID == EclipsePlayer) then  -- starfire will update moonfire AND cancel the Elune's Wrath
			local spellId, spellName, spellSchool = select(9, ...)
			if (spellId == 2912) or (spellId == 8949) or (spellId == 8950) or (spellId == 8951) or (spellId == 9875) or (spellId == 9876) or (spellId == 25298) or (spellId == 26986) or (spellId == 48464) or (spellId == 48465) then
				Eclipse.lcl.SF = spellName
				Eclipse_UpdateMoonfire();
				local BarExists = ECLB:GetBar(Eclipse.lcl.EW)
				if (BarExists ~= nil) then
					EclipseBar("CANCEL", Eclipse.lcl.EW)
				end
			end
		end
		
		if (type == "SPELL_AURA_REMOVED") or (type == "SPELL_AURA_BROKEN") or (type == "SPELL_AURA_BROKEN_SPELL") or  (type == "SPELL_DISPEL") then
			local spellId, spellName, spellSchool = select(9, ...)
			
			if (spellId == 339) or (spellId == 1062) or (spellId == 5195) or (spellId == 5196) or (spellId == 9852) or (spellId == 9853) or (spellId == 26989) or (spellId == 53308) then
				EclipseBar("CANCEL", Eclipse.lcl.ER)
			end
			if (spellId == 770) or (spellId == 16857) then
				EclipseBar("CANCEL", Eclipse.lcl.FF)
			end
		
		end
	end

end

function ECL_EVENTS:PLAYER_TARGET_CHANGED(...)
	Eclipse_UpdateDebuffBars();   -- update bars on target change
end

function ECL_EVENTS:ADDON_LOADED(...)

	local name = select(1, ...)
	if (name == "Eclipse") and (ecl_load == 0) then
		ecl_load = 1
		Eclipse_Addon_Loaded();
	end

end

function ECL_EVENTS:PLAYER_LOGOUT(...)
	DBT_SavedOptions.Eclipse = ECL.Bars.options
end

function ECL_EVENTS:PLAYER_LEAVING_WORLD(...)
	DBT_SavedOptions.Eclipse = ECL.Bars.options
end

function ECL_EVENTS:PLAYER_QUITING(...)
	DBT_SavedOptions.Eclipse = ECL.Bars.options
end

function ECL_EVENTS:UNIT_AURA(...)
	local unitid = select(1, ...)
	if (unitid == "player") then
		Eclipse_UpdateEclipse();
	end
end

function ECL_EVENTS:PLAYER_EQUIPMENT_CHANGED(...)

end


--/-----------\--
--| Bar Stuff |--
--\-----------/--

function EclipseBar(method, name, timer, icon, color, elapsed)

	if (Eclipse.Opt.ECWSeperateBarsCB == 1) then
		ECLB = ECL.Bars
	else 
		ECLB = DBM.Bars
	end

	local bar

	if (method == "CREATE") then
		ECLB:CreateBar(timer, name, icon, false, true, color)
	elseif (method == "UPDATE") then
		ECLB:UpdateBar(name, elapsed, timer)
	elseif (method == "CANCEL") then
		ECLB:CancelBar(name)
	elseif (method == "CREATEUP") then
		ECLB:CreateBar(timer, name, icon, false, true, color)
		ECLB:UpdateBar(name, elapsed, timer)
	elseif (method == "SMCREATEUP") then
		bar = ECLB:GetBar(name)
		if (bar == nil) then
			ECLB:CreateBar(timer, name, icon, false, true, color)
		else
			ECLB:UpdateBar(name, elapsed, timer)
		end
	end

end


function Eclipse_UpdateDebuffBars()

		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable
		local TargetExists = UnitExists("playertarget")
		
		EclipseBar("CANCEL", Eclipse.lcl.MF);
		EclipseBar("CANCEL", Eclipse.lcl.IS);
		EclipseBar("CANCEL", Eclipse.lcl.ER);
		EclipseBar("CANCEL", Eclipse.lcl.FF);
		EclipseBar("CANCEL", Eclipse.lcl.LA);
		
		if (TargetExists == 1) then
			local i
			for i=1,40 do 
				local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff("playertarget", i);
				
				if (name ==  nil) then
					break;
				end
				
				if (unitCaster == "player") then				-- this block is only called if you have debuffs on the target
					local BarExists = ECLB:GetBar(name)
					local BarAllowed = nil
					local startTime = GetTime()
					timer = (expirationTime - startTime)
					local elapsed = (duration - timer)
					
					if (name ==  Eclipse.lcl.IS) then
						color = Eclipse.Colors.Insectswarm
						BarAllowed = Eclipse.Opt.ECWInsectswarmCB
					elseif (name ==  Eclipse.lcl.MF) then
						color = Eclipse.Colors.Moonfire
						BarAllowed = Eclipse.Opt.ECWMoonfireCB
					elseif (name ==  Eclipse.lcl.ER) then
						color = Eclipse.Colors.Roots
						BarAllowed = Eclipse.Opt.ECWRootsCB
					elseif (name ==  Eclipse.lcl.FF) then
						color = Eclipse.Colors.Faerie
						BarAllowed = Eclipse.Opt.ECWFaerieCB
					elseif (name ==  Eclipse.lcl.LA) then
						color = Eclipse.Colors.Languish
						BarAllowed = Eclipse.Opt.ECWLanguishCB
					end
					
					if (BarExists == nil) and (BarAllowed == 1) then
						EclipseBar("CREATEUP", name, duration, icon, color, elapsed);    -- there aren't bars, but there are debuffs
					elseif (BarExists ~= nil) and (BarAllowed == 1) then
						EclipseBar("UPDATE", name, duration, nil, nil, elapsed);		-- there are bars and there are debuffs
					end
				end
				
			end  -- end of loop
		end


end

function Eclipse_UpdateEclipse()

	local i
	for i=1,40
	do 
	local name, rank, icon, count, debuffType, duration, expirationTime, source, isStealable = UnitBuff("player", i); 
	
	if (name == nil) then
		break;
	end
		
		
		local SolarEclName = Eclipse.lcl.EC .. " (W)";
		local LunarEclName = Eclipse.lcl.EC .. " (S)";
	
		local SolarEclCDName = Eclipse.lcl.EC .. " Cooldown (W)";
		local LunarEclCDName = Eclipse.lcl.EC .. " Cooldown (S)";
				
	local startTime = GetTime()
	local timer = (expirationTime - startTime)
	local elapsed = (duration - timer)
		
		
	if (icon == Eclipse.lcl.SolarECIcon) then
		color = Eclipse.Colors.Wrath;
		if Eclipse.Opt.ECWEclipseCB then
			EclipseBar("SMCREATEUP", SolarEclName, 15, icon, color, elapsed);
		end
		if Eclipse.Opt.ECWEclipseCooldownCB then
			EclipseBar("SMCREATEUP", SolarEclCDName, 30, icon, color, elapsed);
		end
	end
				
	if (icon == Eclipse.lcl.LunarECIcon) then
		color = Eclipse.Colors.Starfire;
		if Eclipse.Opt.ECWEclipseCB then
			EclipseBar("SMCREATEUP", LunarEclName, 15, icon, color, elapsed);
		end
		if Eclipse.Opt.ECWEclipseCooldownCB then
			EclipseBar("SMCREATEUP", LunarEclCDName, 30, icon, color, elapsed);
		end
	end
	
	end
		

end

function Eclipse_Buffs(spellId, spellName)

	
	if (spellId == 64823) then
		Eclipse.lcl.EW = spellName
		icon = "Interface\\Icons\\Spell_Nature_WispSplode";
		color = Eclipse.Colors.Elune;
		if Eclipse.Opt.ECWEluneCB == 1 then
			EclipseBar("CREATE", Eclipse.lcl.EW, 10, icon, color);
		end
	end
	
	if (spellId == 16886) then
		Eclipse.lcl.NG = spellName
		icon = "Interface\\Icons\\Spell_Nature_NaturesBlessing";
		color = Eclipse.Colors.NGrace;
		if Eclipse.Opt.ECWNGraceCB == 1 then
			EclipseBar("CREATE", Eclipse.lcl.NG, 3, icon, color);
		end
	end
	
	if (spellId == 70721) then
		Eclipse.lcl.OD = spellName
		icon = "Interface\\Icons\\Spell_Shadow_BurningSpirit";
		color = Eclipse.Colors.OmenDoom;
		if Eclipse.Opt.ECWOmenDoomCB == 1 then
			EclipseBar("CREATE", Eclipse.lcl.OD, 6, icon, color);
		end
	end

end

function Eclipse_Debuffs(spellId, spellName)

	local nameTalent, iconPath, tier, column, NaturesSplendor, maxRank, isExceptional, meetsPrereq = GetTalentInfo(1, 8);

	if (spellId == 5570) or (spellId == 24974) or (spellId == 24975) or (spellId == 24976) or (spellId == 24977) or (spellId == 27013) or (spellId == 48468) then
		Eclipse.lcl.IS = spellName
		icon = "Interface\\Icons\\Spell_Nature_InsectSwarm";
		color = Eclipse.Colors.Insectswarm;
		timer = 12;
		if (NaturesSplendor == 1) then
			timer = 14;
		end
		if (Eclipse.Opt.ECWInsectswarmCB == 1) then
			EclipseBar("CREATE", Eclipse.lcl.IS, timer, icon, color);
		end
	end

	if (spellId == 8921) or (spellId == 8924) or (spellId == 8925) or (spellId == 8926) or (spellId == 8927) or (spellId == 8928) or (spellId == 8929) or (spellId == 9833) or (spellId == 9834) or (spellId == 9835) or (spellId == 26987) or (spellId == 26988) or (spellId == 48462) or (spellId == 48463) then
		Eclipse.lcl.MF = spellName
		icon = "Interface\\Icons\\Spell_Nature_StarFall";
		color = Eclipse.Colors.Moonfire;
		timer = 12;
		if (NaturesSplendor == 1) then
			timer = 15;
		end
		if (Eclipse.Opt.ECWMoonfireCB == 1) then
			EclipseBar("CREATE", Eclipse.lcl.MF, timer, icon, color);
		end
	end
	
	if (spellId == 770) or (spellId == 16857) then
		Eclipse.lcl.FF = spellName
		icon = "Interface\\Icons\\Spell_Nature_FaerieFire";
		color = Eclipse.Colors.Faerie;
		timer = 300;
		if (Eclipse.Opt.ECWFaerieCB == 1) then
			EclipseBar("CREATE", Eclipse.lcl.FF, timer, icon, color);
		end
	end

	if (spellId == 339) or (spellId == 1062) or (spellId == 5195) or (spellId == 5196) or (spellId == 9852) or (spellId == 9853) or (spellId == 26989) or (spellId == 53308) then
		Eclipse.lcl.ER = spellName
		icon = "Interface\\Icons\\Spell_Nature_StrangleVines";
		color = Eclipse.Colors.Roots;
		timer = 27;
		if (Eclipse.Opt.ECWRootsCB == 1) then
			EclipseBar("CREATE", Eclipse.lcl.ER, timer, icon, color);
		end
	end
	
	if (spellId == 71023) then
		Eclipse.lcl.LA = spellName
		icon = "Interface\\Icons\\Spell_Nature_NatureTouchDecay";
		color = Eclipse.Colors.Languish;
		timer = 4;
		if (Eclipse.Opt.ECWLanguishCB == 1) then
			EclipseBar("CREATE", Eclipse.lcl.LA, timer, icon, color);
		end
	end

end

function Eclipse_UpdateMoonfire()

	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable
	local TargetExists = UnitExists("playertarget")
		
		if (TargetExists == 1) then
			local i
			for i=1,40 do 
				local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitDebuff("playertarget", i);
				
				if (name ==  nil) then
					break;
				end
				
				if (unitCaster == "player") and (name == Eclipse.lcl.MF) then
					local startTime = GetTime()
					timer = (expirationTime - startTime)
					local elapsed = (duration - timer)
					BarAllowed = Eclipse.Opt.ECWMoonfireCB
					if (BarAllowed == 1) then
						EclipseBar("UPDATE", name, duration, nil, nil, elapsed);
					end
				end
				
			end  -- end of loop
		end

end