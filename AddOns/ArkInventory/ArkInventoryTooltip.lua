local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local CreateFrame = _G.CreateFrame


function ArkInventory.TooltipInit( name )
	
	local tooltip = _G[name]
	assert( tooltip, string.format( "XML Frame [%s] not found", name ) )
	
	return tooltip
	
end

function ArkInventory.TooltipNumLines( tooltip )
	
	return tooltip:NumLines( ) or 0
	
end

function ArkInventory.TooltipSetHyperlink( tooltip, h )
	
	tooltip:ClearLines( )
	
	local class = ArkInventory.ObjectStringDecode( h )
	
	if h and ( class == "item" or class == "spell" ) then
		return tooltip:SetHyperlink( h )
	end
	
end

function ArkInventory.TooltipSetBagItem( tooltip, bag_id, slot_id )
	
	tooltip:ClearLines( )
	
	return tooltip:SetBagItem( bag_id, slot_id )
	
end

function ArkInventory.TooltipSetInventoryItem( tooltip, slot )
	
	tooltip:ClearLines( )
	
	return tooltip:SetInventoryItem( "player", slot )
	
end

function ArkInventory.TooltipSetGuildBankItem( tooltip, tab, slot )
	
	tooltip:ClearLines( )
	
	return tooltip:SetGuildBankItem( tab, slot )
	
end

function ArkInventory.TooltipSetItem( tooltip, bag_id, slot_id )
	
	-- not for offline mode, only direct online scanning of the current player
	
	if bag_id == BANK_CONTAINER then
		
		return ArkInventory.TooltipSetInventoryItem( tooltip, BankButtonIDToInvSlotID( slot_id ) )
		
	else
		
		return ArkInventory.TooltipSetBagItem( tooltip, bag_id, slot_id )
		
	end
	
end

function ArkInventory.TooltipSetBattlepet( tooltip, h, i )
	
	-- creates a basic text tooltip, then hooks via the hyperlink for the item counts
	-- mouseover pet items, and clicking pet links
	-- mouseover of pets is done at TooltipHookSetUnit
	
	local class, speciesID, level, rarity, fullHealth, power, speed = ArkInventory.ObjectStringDecode( h )
	
	if class ~= "battlepet" then return end
	
	--ArkInventory.Output( "[", class, " : ", speciesID, " : ", level, " : ", rarity, " : ", fullHealth, " : ", power, " : ", speed, "]" )
	
	if not ArkInventory.db.global.option.tooltip.battlepet.enable then
		BattlePetToolTip_Show( speciesID, level, rarity, fullHealth, power, speed, name )
		return
	end
	
	local sd = ArkInventory.PetJournal.GetSpeciesInfo( speciesID )
	if not sd then return end
	
	local name = sd.name
	local pd
	
	if i and i.pid then
		pd = ArkInventory.PetJournal.GetPetInfo( i.pid )
		if pd then
			if ( rarity == -1 ) then
				rarity = pd.rarity
			end
			name = pd.fullName
		end
	end
	
	tooltip:ClearLines( )
	
	if sd.isWild then
		name = string.format( "%s%s|r", select( 5, ArkInventory.GetItemQualityColor( rarity ) ), name )
	end
	
	tooltip:AddLine( string.format( "|T%s:32:32:-4:4:128:256:64:100:130:166|t %s", GetPetTypeTexture( sd.petType ), name ) )
	
	if ArkInventory.db.global.option.tooltip.battlepet.source then
		if ( sd.sourceText and sd.sourceText ~= "" ) then
			tooltip:AddLine( sd.sourceText, 1, 1, 1, true )
		end
	end
	
	if ( not sd.tradable ) then
		tooltip:AddLine( BATTLE_PET_NOT_TRADABLE, 1, 0.1, 0.1, true )
	end
	
	if sd.unique then
		tooltip:AddLine( ITEM_UNIQUE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true )
	end
	
	if sd.canBattle then
		
		tooltip:AddLine( " " )
		
		
		txt1 = LEVEL
		txt2 = string.format( "%s %s", level, "|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t" )
		if pd and pd.xp and pd.maxXp and pd.xp > 0 then
			
			local pc = pd.xp / pd.maxXp * 100
			if pc < 1 then
				pc = 1
			elseif pc > 99 then
				pc = 99
			end
			
			txt1 = string.format( "%s (%d%%)", txt1, pc )
			
		end
		tooltip:AddDoubleLine( txt1, txt2 )
		
		
		local iconPetAlive = "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:16:32|t"
		local iconPetDead = "|TInterface\\Scenarios\\ScenarioIcon-Boss:0|t"
		txt1 = PET_BATTLE_STAT_HEALTH
		if pd and pd.currentHealth and ( pd.currentHealth <= 0 ) then
			
			txt1 = string.format( "%s (%s)", txt1, DEAD )
			txt2 = string.format( "%s %s", fullHealth, iconPetDead )
			
		else
			
			if pd and ( pd.currentHealth ~= fullHealth ) then
				
				local pc = pd.currentHealth / fullHealth * 100
				if pc < 1 then
					pc = 1
				elseif pc > 99 then
					pc = 99
				end
				
				txt1 = string.format( "%s (%d%%)", txt1, pc )
				
			end
			
			txt2 = string.format( "%s %s", fullHealth, iconPetAlive )
			
		end
		tooltip:AddDoubleLine( txt1, txt2 )
		
		
		-- |TTexturePath:size1:size2:offset-x:offset-y:original-size-x:original-size-y:crop-x1:crop-x2:crop-y1:crop-y2|t
		tooltip:AddDoubleLine( PET_BATTLE_STAT_POWER, string.format( "%s %s", power, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:0:16|t" ) )
		
		
		tooltip:AddDoubleLine( PET_BATTLE_STAT_SPEED, string.format( "%s %s", speed, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:16:32|t" ) )
		
		
		if ( not sd.isWild ) and ( rarity ~= -1 ) then
			-- only need this for system pets as the wild pets have their names colour coded
			-- ignore the -1, those will be from other peoples links and we cant get at that data
			local c = select( 5, ArkInventory.GetItemQualityColor( rarity ) )
			tooltip:AddDoubleLine( PET_BATTLE_STAT_QUALITY, string.format( "%s%s %s", c, _G[string.format( "ITEM_QUALITY%d_DESC", rarity )], "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:0:16|t" ) )
		end

	else
		
		tooltip:AddLine( ArkInventory.Localise["PET_CANNOT_BATTLE"], 1.0, 0.1, 0.1, true )
		
	end
	
	if ArkInventory.db.global.option.tooltip.battlepet.description and ( description and description ~= "" ) then
		tooltip:AddLine( " " )
		tooltip:AddLine( description, nil, nil, nil, true )
	end
	
	tooltip:Show( )
	
	ArkInventory.TooltipAddBattlepetDetail( tooltip, speciesID, i )
	
end


function ArkInventory.TooltipGetMoneyFrame( tooltip )
	
	return _G[string.format( "%s%s", tooltip:GetName( ), "MoneyFrame1" )]
	
end

function ArkInventory.TooltipGetItem( tooltip )
	
	local itemName, ItemLink = tooltip:GetItem( )
	return itemName, ItemLink
	
end
	
function ArkInventory.TooltipFind( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive, maxDepth )
	
	if not TextToFind or string.trim( TextToFind ) == "" then
		return false
	end
	
	local IgnoreLeft = IgnoreLeft or false
	local IgnoreRight = IgnoreRight or false
	local CaseSensitive = CaseSensitive or false
	
	local obj, txt
	
	for i = 2, ArkInventory.TooltipNumLines( tooltip ) do
		
		if maxDepth and ( i > maxDepth ) then return end
		
		if not IgnoreLeft then
			obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
			if obj and obj:IsShown( ) then
				txt = obj:GetText( )
				if txt then
					
					--ArkInventory.Output( "L[", i, "] = [", txt, "]" )
					
					if not CaseSensitive then
						txt = string.lower( txt )
						TextToFind = string.lower( TextToFind )
					end
					if string.find( txt, TextToFind ) then
						return string.find( txt, TextToFind )
					end
					
				end
			end
		end
		
		if not IgnoreRight then
			obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
			if obj and obj:IsShown( ) then
				txt = obj:GetText( )
				if txt then
				
					--ArkInventory.Output( "R[", i, "] = [", txt, "]" )
					
					if not CaseSensitive then
						txt = string.lower( txt )
						TextToFind = string.lower( TextToFind )
					end
					if string.find( txt, TextToFind ) then
						return string.find( txt, TextToFind )
					end
					
				end
			end
		end
		
	end
	
	return
	
end

function ArkInventory.TooltipGetLine( tooltip, i )

	if not i or i < 1 or i > ArkInventory.TooltipNumLines( tooltip ) then
		return
	end
	
	local obj, txt1, txt2
	
	obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
	if obj and obj:IsShown( ) then
		txt1 = obj:GetText( )
	end
	
	obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
	if obj and obj:IsShown( ) then
		txt2 = obj:GetText( )
	end

	return txt1 or "", txt2 or ""
	
end
	
function ArkInventory.TooltipContains( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive )

	if ArkInventory.TooltipFind( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive ) then
		return true
	else
		return false
	end

end

function ArkInventory.TooltipCanUse( tooltip )

	local l = { "TextLeft", "TextRight" }
	
	local n = ArkInventory.TooltipNumLines( tooltip )
	
	local t1 = tooltip:GetItem( )
	local line1 = _G[string.format( "%sTextLeft1", tooltip:GetName( ) )]:GetText( )
	
	for i = 2, n do
		for _, v in pairs( l ) do
			
			local obj = _G[string.format( "%s%s%s", tooltip:GetName( ), v, i )]
			if obj and obj:IsShown( ) then
				
				local txt = obj:GetText( )
				
				if string.match( txt, "^%s+$" ) or string.match( txt, "^\n" ) then
					-- recipies and patterns have a blank line between the item and what it creates so check from the last line upwards now
					-- techniques have a newline character to break them up
					return ArkInventory.TooltipCanUseBackwards( tooltip )
				end
				
				local r, g, b = obj:GetTextColor( )
				local c = string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
				if ( c == "fe1f1f" ) then
					if not ( ( txt == ITEM_DISENCHANT_NOT_DISENCHANTABLE ) or ( txt == RETRIEVING_ITEM_INFO ) ) then
						--ArkInventory.Output( "line[", i, "]=[", txt, "] forwards" )
						return false
					end
				end

			end
		end
	end

	return true
	
end

function ArkInventory.TooltipCanUseBackwards( tooltip )

	local l = { "TextLeft", "TextRight" }
	
	local n = ArkInventory.TooltipNumLines( tooltip )
	
	for i = n, 2, -1 do
		for _, v in pairs( l ) do
			local obj = _G[string.format( "%s%s%s", tooltip:GetName( ), v, i )]
			if obj and obj:IsShown( ) then
				
				local txt = obj:GetText( )
				
				if string.match( txt, "^%s+$" ) or string.match( txt, "^\n" ) then
					-- recipies and patterns have a blank line between the pattern and the item it created, stop when we hit a blank line
					-- techniques have a newline character to break them up
					return true
				end
				
				local r, g, b = obj:GetTextColor( )
				local c = string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
				if ( c == "fe1f1f" ) then
					if not ( ( txt == ITEM_DISENCHANT_NOT_DISENCHANTABLE ) or ( txt == RETRIEVING_ITEM_INFO ) ) then
						--ArkInventory.Output( "line[", i, "]=[", txt, "] backwards" )
						return false
					end
				end

			end
		end
	end

	return true
	
end


function ArkInventory.TooltipHook( ... )
	
	if ArkInventory.Global.Mode.Combat then return end

	local tooltip, arg1, arg2, arg3, arg4 = ...
	
	if not tooltip then return end
	
	if not tooltip:IsVisible( ) then
		-- dont add stuff to tooltips until after they become visible for the first time
		return
	end
	
	tooltip.ARK_Data[1] = arg1
	tooltip.ARK_Data[2] = arg2
	tooltip.ARK_Data[3] = arg3
	tooltip.ARK_Data[4] = arg4
	
	local h = nil
	
	if not h and tooltip["GetItem"] then
		h = select( 2, tooltip:GetItem( ) )
		--ArkInventory.Output( "GetItem = ", h )
	end
	
	if not h and tooltip["GetSpell"] then
		h = select( 3, tooltip:GetSpell( ) )
		if h then
			h = GetSpellLink( h )
			--ArkInventory.Output( "GetSpell = ", h )
		end
	end
	
	if not h and arg1 then
		h = select( 2, ArkInventory.ObjectInfo( arg1 ) )
		--ArkInventory.Output( "arg1 = ", arg1, " / ", h )
	end
	
	if not h then
		--ArkInventory.Output( "nothing found" )
		return
	end
	
	if ArkInventory.db.global.option.tooltip.add.count then
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
	--ArkInventory.TooltipAddItemAge( tooltip, h, arg1, arg2 )
	
	tooltip:Show( )
	
end

function ArkInventory.TooltipHookSetCurrencyToken( ... )
	
	local tooltip, arg1 = ...
	
	if not tooltip then return end
	
	local h = GetCurrencyListLink( arg1 )
	
	ArkInventory.TooltipHook( tooltip, h )
	
end

function ArkInventory.TooltipHookSetMerchantCostItem( ... )
	
	local tooltip, arg1, arg2 = ...
	
	if not tooltip then return end
	
	local icon, amount, link, name, v1, v2, v3, v4, v5 = GetMerchantItemCostItem( arg1, arg2 )
	
	if link then
		ArkInventory.TooltipHook( tooltip, h )
	else
		--ArkInventory.Output( "GetMerchantItemCostItem = ", icon, " / ", amount, " / ", link, " / ", name )
	end
	
end

function ArkInventory.TooltipHookSetBackpackToken( ... )
	
	--if ( ArkInventory:IsEnabled( ) ) and ( ArkInventory.db.global.option.tooltip.battlepet.mouseover.enable ) then
	
	local tooltip, arg1 = ...
	
	if not tooltip then return end
	
	local name, count, icon, currencyID = GetBackpackCurrencyInfo( arg1 )
	local h = GetCurrencyLink( currencyID )
	
	ArkInventory.TooltipHook( tooltip, h )
	
end

function ArkInventory.TooltipHookSetUnit( ... )
	
	if ( ArkInventory:IsEnabled( ) ) and ( ArkInventory.db.global.option.tooltip.battlepet.mouseover.enable ) then
		
		local tooltip = ...
		
		local _, unit = tooltip:GetUnit( )
		
		if ( unit ) and ( UnitIsWildBattlePet( unit ) or UnitIsOtherPlayersBattlePet( unit ) or UnitIsBattlePetCompanion( unit ) ) then
			
			local guid = UnitGUID( unit )
			local speciesID = ArkInventory.PetJournal.GetSpeciesIDfromGUID( guid )
			
			--ArkInventory.Output( unit, " speciesID=", speciesID, " / ", guid )
			
			if speciesID then
				
				tooltip:Show( ) -- its a static tooltip, need to show it first to be able to add to it
				
				sd = ArkInventory.PetJournal.GetSpeciesInfo( speciesID )
				
				if sd then
					
					if ArkInventory.db.global.option.tooltip.battlepet.mouseover.source and sd.sourceText and ( sd.sourceText ~= "" ) then
						tooltip:AddLine( " " )
						tooltip:AddLine( sd.sourceText, nil, nil, nil, true )
					end
					
					if ArkInventory.db.global.option.tooltip.battlepet.mouseover.description and sd.description and ( sd.description ~= "" ) then
						tooltip:AddLine( " " )
						tooltip:AddLine( sd.description, nil, nil, nil, true )
					end
					
					if false then
						local level = UnitLevel( unit )
						local weak, strong, base = ArkInventory.PetJournal.AttackList( speciesID, level )
						tooltip:AddLine( " " )
						tooltip:AddDoubleLine( string.format( ArkInventory.Localise["BATTLEPET_OPPONENT_FORMAT_WEAK"], base, level ), string.format( "%s%s", GREEN_FONT_COLOR_CODE, weak ) )
						tooltip:AddDoubleLine( string.format( ArkInventory.Localise["BATTLEPET_OPPONENT_FORMAT_STRONG"], base, level ), string.format( "%s%s", RED_FONT_COLOR_CODE, strong ) )
					end
					
				end
				
				if ArkInventory.db.global.option.tooltip.add.count then
					ArkInventory.TooltipAddBattlepetDetail( tooltip, speciesID )
				end
				
			end
			
		end
		
	end
	
end

function ArkInventory.TooltipAddBattlepetDetail( tooltip, speciesID, i )
	
	local tt = { }
	local upgrade = false
	local count = 0
	
	for petID, pd in ArkInventory.PetJournal.IteratePetIDs( ) do
		if ( pd.sd.speciesID == speciesID ) then
			count = count + 1
			tt[count] = petID
		end
	end
	
	if ( count > 0 ) then
		local h = string.format( "battlepet:%s", speciesID )
		ArkInventory.TooltipHook( tooltip, h )
	end
	
	if ( i and count > 1 ) or ( not i and count > 0 ) then
		
		local info = ""
		
		for k, petID in pairs( tt ) do
			
			local pd = ArkInventory.PetJournal.GetPetInfo( petID )
			
			info = string.format( "%s:  ", ArkInventory.Localise["BATTLEPET_OPPONENT_KNOWN"] )
			
			local c = select( 5, ArkInventory.GetItemQualityColor( pd.rarity ) )
			info = string.format( "%s%s%s|r%s", info, c, _G[string.format( "ITEM_QUALITY%d_DESC", pd.rarity )], "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:0:16|t" )
			
			info = string.format( "%s  %s%s", info, pd.level, "|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t" )
			
			if pd.sd.canBattle then
				
				local iconPetAlive = "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:16:32:16:32|t"
				local iconPetDead = "|TInterface\\Scenarios\\ScenarioIcon-Boss:0|t"
				if ( pd.currentHealth <= 0 ) then
					info = string.format( "%s  %s%s", info, pd.fullHealth, iconPetDead )
				else
					info = string.format( "%s  %s%s", info, pd.fullHealth, iconPetAlive )
				end
		
				info = string.format( "%s  %s%s", info, pd.power, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:0:16|t" )
				info = string.format( "%s  %s%s", info, pd.speed, "|TInterface\\PetBattles\\PetBattle-StatIcons:0:0:0:0:32:32:0:16:16:32|t" )
				
				if ( k == 1 ) then
					tooltip:AddLine( " " )
				end
				if ( not i ) or ( i and i.pid ~= petID ) then
					tooltip:AddLine( info )
				end
				
			end
			
		end
		
	elseif ( i and count == 1 ) then
		
		-- we only have one of this and the stats are already in the tooltip so no point adding it again
		
	else
		
		ArkInventory.TooltipAddEmptyLine( tooltip )
		tooltip:AddLine( ArkInventory.Localise["BATTLEPET_OPPONENT_UNKNOWN"], 1.0, 0.1, 0.1 ) 
		
	end
	
	tooltip:Show( )

end


function ArkInventory.TooltipAddEmptyLine( tooltip )
	
	if ArkInventory.db.global.option.tooltip.add.empty then
		tooltip:AddLine( " ", 1, 1, 1, 0 )
	end
	
end

function ArkInventory.TooltipAddItemCount( tooltip, h )
	
	local tt = ArkInventory.TooltipObjectCountGet( h, tooltip )
	
	if tt and tt ~= "" then
		local tc = ArkInventory.db.global.option.tooltip.colour.count
		ArkInventory.TooltipAddEmptyLine( tooltip )
		tooltip:AddLine( tt, tc.r, tc.g, tc.b, 0 )
	end
	
end

function ArkInventory.TooltipAddItemAge( tooltip, h, blizzard_id, slot_id )
	
	if type( blizzard_id ) == "number" and type( slot_id ) == "number" then
		ArkInventory.TooltipAddEmptyLine( tooltip )
		local bag_id = ArkInventory.BagID_Internal( blizzard_id )
		tooltip:AddLine( tt, 1, 1, 1, 0 )
	end

end

function ArkInventory.TooltipObjectCountGet( search_id, tooltip )
	
	local search_id = ArkInventory.ObjectIDTooltip( search_id )
	local cp = ArkInventory.Global.Me
	
	if tooltip then
		tooltip = tooltip:GetOwner( )
		if tooltip and tooltip.ARK_Data and tooltip.ARK_Data.loc_id then
			cp = ArkInventory.LocationPlayerInfoGet( tooltip.ARK_Data.loc_id )
		end
	end
	
	if not ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id] then
		ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id] = { }
	end
	
	if ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id] then
		return ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id]
	end
	
	
	local tc = ArkInventory.ObjectCountGet( search_id, cp.info.player_id, ArkInventory.db.global.option.tooltip.me, not ArkInventory.db.global.option.tooltip.add.vault, ArkInventory.db.global.option.tooltip.faction, ArkInventory.db.global.option.tooltip.realm, ArkInventory.db.global.option.tooltip.crossrealm )
	if tc == nil then
		--ArkInventory.OutputDebug( "no count data" )
		ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id] = ""
		return ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id]
	end
	
	local paint = ArkInventory.db.global.option.tooltip.colour.class
	local colour = ""
	if paint then
		colour = HIGHLIGHT_FONT_COLOR_CODE
	end
	
	local item_count_total = 0
	
	local character_count = 0
	local character_entries = { }
	
	local guild_count = 0
	local guild_entries = { }
	
	for pid, td in ArkInventory.spairs( tc ) do
		
		local pd = ArkInventory.PlayerInfoGet( pid )
			
			local name = ArkInventory.DisplayName3( pd.info, paint, cp.info )
			
			local item_count_character = 0
			local item_count_guild = 0
			
			local location_entries = { }
			
			if td.location then
				
				for l, lc in pairs( td.location ) do
					
					if lc > 0 then
						
						if td.vault then
							if ArkInventory.db.global.option.tooltip.add.tabs then
								table.insert( location_entries, string.format( "%s %s", ArkInventory.Localise["TOOLTIP_VAULT_TABS"], td.tabs ) )
							else
								table.insert( location_entries, string.format( "%s", ArkInventory.Global.Location[l].Name ) )
							end
							item_count_guild = item_count_guild + lc
						else
							table.insert( location_entries, string.format( "%s %s%s|r", ArkInventory.Global.Location[l].Name, colour, lc ) )
							item_count_character = item_count_character + lc
						end
						
					end
					
				end
				
				if item_count_character > 0 then
					
					local me = ""
					if not ArkInventory.db.global.option.tooltip.me and pd.info.player_id == cp.info.player_id then
						me = ArkInventory.db.global.option.tooltip.highlight
					end
					
					table.insert( character_entries, string.format( "%s%s|r: %s%s|r (%s)", me, name, colour, item_count_character, table.concat( location_entries, ", " ) ) )
					character_count = character_count + 1
					item_count_total = item_count_total + item_count_character
					
				end
				
				if item_count_guild > 0 then
					table.insert( guild_entries, string.format( "%s|r: %s%s|r (%s)", name, colour, item_count_guild, table.concat( location_entries, ", " ) ) )
					guild_count = guild_count + 1
				end
				
			end
			
	end
	
	if item_count_total > 0 or guild_count > 0 then
		
		local c = table.concat( character_entries, "\n" )
		if character_count > 1 then
			c = string.format( "%s\n%s: %s%s|r", c, ArkInventory.Localise["TOTAL"], colour, item_count_total )
		end
		
		local g = ""
		
		if ArkInventory.db.global.option.tooltip.add.vault and guild_count > 0 then
			
			if character_count > 0 then
				g = "\n\n"
			end
			
			table.sort( guild_entries )
			g = string.format( "%s%s", g, table.concat( guild_entries, "\n" ) )
			
		end
		
		ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id] = string.format( "%s%s", c, g )
		
	else
		
		ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id] = ""
		
	end
	
	return ArkInventory.Global.Cache.ItemCountTooltip[cp.info.player_id][search_id]
	
end

function ArkInventory.TooltipSetMoneyCoin( frame, amount, txt, r, g, b )
	
	if not frame or not amount then
		return
	end
	
	frame:AddDoubleLine( txt or " ", " ", r or 1, g or 1, b or 1 )
	
	local numLines = frame:NumLines( )
	if not frame.numMoneyFrames then
		frame.numMoneyFrames = 0
	end
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 0
	end
	
	local name = string.format( "%s%s%s", frame:GetName( ), "MoneyFrame", frame.shownMoneyFrames + 1 )
	local moneyFrame = _G[name]
	if not moneyFrame then
		frame.numMoneyFrames = frame.numMoneyFrames + 1
		moneyFrame = CreateFrame( "Frame", name, frame, "TooltipMoneyFrameTemplate" )
		name = moneyFrame:GetName( )
		ArkInventory.MoneyFrame_SetType( moneyFrame, "STATIC" )
	end
	
	moneyFrame:SetPoint( "RIGHT", string.format( "%s%s%s", frame:GetName( ), "TextRight", numLines ), "RIGHT", 15, 0 )
	
	moneyFrame:Show( )
	
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 1
	else
		frame.shownMoneyFrames = frame.shownMoneyFrames + 1
	end
	
	MoneyFrame_Update( moneyFrame:GetName( ), amount )
	
	local leftFrame = _G[string.format( "%s%s%s", frame:GetName( ), "TextLeft", numLines )]
	local frameWidth = leftFrame:GetWidth( ) + moneyFrame:GetWidth( ) + 40
	
	if frame:GetMinimumWidth( ) < frameWidth then
		frame:SetMinimumWidth( frameWidth )
	end
	
	frame.hasMoney = 1

end

function ArkInventory.TooltipSetMoneyText( frame, money, txt, r, g, b )
	if not money then
		return
	elseif money == 0 then
		--frame:AddDoubleLine( txt or "missing text", ITEM_UNSELLABLE, r or 1, g or 1, b or 1, 1, 1, 1 )
		frame:AddDoubleLine( txt or "missing text", ArkInventory.MoneyText( money ), r or 1, g or 1, b or 1, 1, 1, 1 )
	else
		frame:AddDoubleLine( txt or "missing text", ArkInventory.MoneyText( money ), r or 1, g or 1, b or 1, 1, 1, 1 )
	end
end

function ArkInventory.TooltipShowCompare( ... )
	
	-- achievement comparison
	
	--if true then return end
	
	local self = ...
	
	if not self or not self.ARK_Data then return end
	
	local objectlink = self.ARK_Data[1]
	if ( not objectlink ) or ( type( objectlink ) ~= "string" ) then return end
	
	--ArkInventory.Output( self.ARK_Data[1], " / ", self.ARK_Data[2], " / ", self.ARK_Data[3], " / ", self.ARK_Data[4] )
	
	local objectlink = string.match( objectlink, "|H(.-)|h" ) or objectlink
	local class, id, extra = string.match( objectlink, "^(.-):(.-):(.+)$" )
	if not class or not id then return end
	
	local link = nil
	
	--ArkInventory.Output( class, " / ", id, " / ", extra )
	
	if class == "achievement" then
		link = GetAchievementLink( id )
--	elseif class == "instancelock" then
--		link = GetSavedInstanceChatLink(self:GetID())
	else
		return
	end
	
	if not link then return end
	
	-- sourced from GameTooltip.lua / GameTooltip_ShowCompareItem( )
	
	local shoppingTooltip1, shoppingTooltip2, shoppingTooltip3 = unpack(self.shoppingTooltips);

	local item1 = true;
	
	local side = "left";

	-- find correct side
	local rightDist = 0;
	local leftPos = self:GetLeft();
	local rightPos = self:GetRight();
	if ( not rightPos ) then
		rightPos = 0;
	end
	if ( not leftPos ) then
		leftPos = 0;
	end

	rightDist = GetScreenWidth() - rightPos;

	if (leftPos and (rightDist < leftPos)) then
		side = "left";
	else
		side = "right";
	end

	-- see if we should slide the tooltip
	if ( self:GetAnchorType() and self:GetAnchorType() ~= "ANCHOR_PRESERVE" ) then
		local totalWidth = 0;
		if ( item1  ) then
			totalWidth = totalWidth + shoppingTooltip1:GetWidth();
		end

		if ( (side == "left") and (totalWidth > leftPos) ) then
			self:SetAnchorType(self:GetAnchorType(), (totalWidth - leftPos), 0);
		elseif ( (side == "right") and (rightPos + totalWidth) >  GetScreenWidth() ) then
			self:SetAnchorType(self:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0);
		end
	end

	-- anchor the compare tooltips
	if ( item1 ) then
		shoppingTooltip1:SetOwner(self, "ANCHOR_NONE");
		shoppingTooltip1:ClearAllPoints();
		if ( side and side == "left" ) then
			shoppingTooltip1:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, -10);
		else
			shoppingTooltip1:SetPoint("TOPLEFT", self, "TOPRIGHT", 0, -10);
		end
		shoppingTooltip1:SetHyperlink(link);
		shoppingTooltip1:Show();
		
	end
	
end
