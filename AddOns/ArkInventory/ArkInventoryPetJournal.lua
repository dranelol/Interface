local UNLOCK_REQUIREMENTS = {
	[1] = {requirement = "SPELL", id = "119467"},
	[2] = {requirement = "ACHIEVEMENT", id = "7433"},
	[3] = {requirement = "ACHIEVEMENT", id = "6566"}
}

local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table
local C_PetJournal = _G.C_PetJournal
local C_PetBattles = _G.C_PetBattles

local filter = {
	ignore = false,
	searchBox = nil,
	collected = true,
	favourites = false,
	notcollected = true,
	family = { },
	source = { },
}

ArkInventory.PetJournal = {
	data = {
		loaded = false,
		total = 0, -- number of total pets
		owned = 0, -- number of owned pets
		pet = { },	-- [petID] = { } - owned pets only
		species = { }, -- [speciesID] = { } - all pet types
		ability = { }, -- [abilityID] = { } - all pet types
		creature = { },	-- [creatureID] = speciesID
	},
}

function ArkInventory.PetJournal.OnHide( )
	filter.ignore = false
	ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", "RESCAN" )
end

PetJournal:HookScript( "OnHide", ArkInventory.PetJournal.OnHide )

function ArkInventory.PetJournal.FilterClear( )
	
	-- /run ArkInventory.PetJournal.FilterClear( )
	
	--ArkInventory.Output( "FilterClear - start" )
	
	PetJournal:UnregisterEvent( "PET_JOURNAL_LIST_UPDATE" )
	filter.ignore = true
	
	C_PetJournal.SetSearchFilter( "" )
	
	C_PetJournal.SetFlagFilter( LE_PET_JOURNAL_FLAG_COLLECTED, true )
	C_PetJournal.SetFlagFilter( LE_PET_JOURNAL_FLAG_FAVORITES, false )
	C_PetJournal.SetFlagFilter( LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true )
	
	for i = 1, C_PetJournal.GetNumPetTypes( ) do
		C_PetJournal.SetPetTypeFilter( i, true )
	end
	
	for i = 1, C_PetJournal.GetNumPetSources( ) do
		C_PetJournal.SetPetSourceFilter( i, true )
	end
	
	--filter.ignore = false
	PetJournal:RegisterEvent( "PET_JOURNAL_LIST_UPDATE" )
	
	--ArkInventory.Output( "FilterClear - end" )
	
end
	
function ArkInventory.PetJournal.FilterSave( )
	
	-- /run ArkInventory.PetJournal.FilterSave( )
	
	--ArkInventory.Output( "FilterSave - start" )
	
	if filter.ignore then
		--ArkInventory.Output( "FilterSave - ignore" )
		return
	end
	
	filter.search = PetJournal.searchBox:GetText( )
	--ArkInventory.Output( "SEARCH = ", filter.search )
	
	filter.collected = not C_PetJournal.IsFlagFiltered( LE_PET_JOURNAL_FLAG_COLLECTED )
	--ArkInventory.Output( "COLLECTED = ", filter.collected )
	
	filter.favourite = not C_PetJournal.IsFlagFiltered( LE_PET_JOURNAL_FLAG_FAVORITES )
	--ArkInventory.Output( "FAVOURITE = ", filter.favourite )
	
	filter.notcollected = not C_PetJournal.IsFlagFiltered( LE_PET_JOURNAL_FLAG_NOT_COLLECTED )
	--ArkInventory.Output( "NOT COLLECTED = ", filter.notcollected )
	
	for i = 1, C_PetJournal.GetNumPetTypes( ) do
		filter.family[i] = not C_PetJournal.IsPetTypeFiltered( i )
		--ArkInventory.Output( "FAMILY[", i, "] = ", filter.family[i] )
	end
	
	for i = 1, C_PetJournal.GetNumPetSources( ) do
		filter.source[i] = not C_PetJournal.IsPetSourceFiltered( i )
		--ArkInventory.Output( "SOURCE[", i, "] = ", filter.source[i] )
	end
	
	--ArkInventory.Output( "FilterSave - end" )
	
end

function ArkInventory.PetJournal.FilterRestore( )
	
	-- /run ArkInventory.PetJournal.FilterRestore( )
	
	--ArkInventory.Output( "FilterRestore - start" )
	
	PetJournal:UnregisterEvent( "PET_JOURNAL_LIST_UPDATE" )
	filter.ignore = true
	
	PetJournal.searchBox:SetText( filter.search )
	
	C_PetJournal.SetFlagFilter( LE_PET_JOURNAL_FLAG_COLLECTED, filter.collected )
	
	C_PetJournal.SetFlagFilter( LE_PET_JOURNAL_FLAG_FAVORITES, filter.favourite )
	
	C_PetJournal.SetFlagFilter( LE_PET_JOURNAL_FLAG_NOT_COLLECTED, filter.notcollected )
	
	for i = 1, C_PetJournal.GetNumPetTypes( ) do
		C_PetJournal.SetPetTypeFilter( i, filter.family[i] )
	end

	for i = 1, C_PetJournal.GetNumPetSources( ) do
		C_PetJournal.SetPetSourceFilter( i, filter.source[i] )
	end
	
	--filter.ignore = false
	PetJournal:RegisterEvent( "PET_JOURNAL_LIST_UPDATE" )
	
	--ArkInventory.Output( "FilterRestore - end" )
	
end




function ArkInventory.PetJournal.Scan( )
	
	if ( ArkInventory.Global.Mode.Combat ) then
		-- set to scan when leaving combat
		ArkInventory.Global.LeaveCombatRun.PetJournal = true
		return
	end
	
	local pj = ArkInventory.PetJournal.data
	
	ArkInventory.PetJournal.FilterSave( )
	ArkInventory.PetJournal.FilterClear( )
	
	local total, owned = C_PetJournal.GetNumPets( false )
	
	if ( total == 0 ) and ( owned == 0 ) then
		ArkInventory.PetJournal.FilterRestore( )
		return
	end
	
	local update = false
	
	if ( pj.total ~= total ) or ( not pj.loaded ) then
		
		pj.total = total
		update = true
		
--		wipe( pj.species )
--		wipe( pj.ability )
--		wipe( pj.creature )
		
	end
		
	if ( pj.owned ~= owned ) or ( not pj.loaded ) then
		
		pj.loaded = true
		
		pj.owned = owned
		update = true
		
		wipe( pj.pet )
		
	end
	
	local check = true
	
   for i = 1, total do
		
		if ( ArkInventory.Global.Mode.Combat ) then
			-- set to scan when leaving combat
			ArkInventory.Global.LeaveCombatRun.PetJournal = true
			return
		end
		
		local petID, speciesID, isOwned = C_PetJournal.GetPetInfoByIndex( i, false )
		--ArkInventory.Output( petID )
		
		-- species data (all pets)
		local sd = ArkInventory.PetJournal.ScanSpecies( speciesID )
		if not sd then
			ArkInventory.PetJournal.FilterRestore( )
			ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", "RESCAN" )
			return false
		end

		-- creatureid to speciesid lookup (all pets)
		if not pj.creature[sd.creatureID] then
			pj.creature[sd.creatureID] = speciesID
		end
		
		
		-- pet data (owned pets)
		if isOwned then
			local pd, upd = ArkInventory.PetJournal.ScanPet( petID, update )
			if not pd then
				ArkInventory.Output( "journal not ready at ", i, " / ", petID )
				ArkInventory.PetJournal.FilterRestore( )
				ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", "RESCAN" )
				return false
			end
			if not update and upd then
				update = true
			end
		end
		
	end
	
	ArkInventory.PetJournal.FilterRestore( )
	
	if update then
		ArkInventory.ScanBattlePet( )
	end
	
	return true
	
end


-- OnLoad

ArkInventory.PetJournal.FilterSave( )

function ArkInventory.PetJournal.GetSpeciesIDForCreatureID( creatureID )
	return ArkInventory.PetJournal.data.creature[creatureID]
end

function ArkInventory.PetJournal.GetSpeciesIDfromGUID( guid )
	
	-- breaks apart a guid and returns the battlepet speciesid
	
	local unitType = tonumber( string.format( "0x%s", string.sub( guid, 3, 5 ) ) )
	unitType = bit.band( unitType, 0x00f )
	
	if ( unitType == 0x003 ) then
		local creatureID = tonumber( string.format( "0x%s", string.sub( guid, 6, 10 ) ) )
		return ArkInventory.PetJournal.GetSpeciesIDForCreatureID( creatureID )
	end
	
end

function ArkInventory.PetJournal.IteratePetIDs( )
    local t = ArkInventory.PetJournal.data.pet
	return ArkInventory.spairs( t, function( a, b ) return ( t[a].fullName or "" ) < ( t[b].fullName or "" ) end )
end

function ArkInventory.PetJournal.NumPets( )
	return ArkInventory.PetJournal.data.owned, ArkInventory.PetJournal.data.total
end

function ArkInventory.PetJournal.ScanPet( petID, update )
	
	if ( not petID ) or ( type( petID ) ~= "string" ) or ( string.len( petID ) ~= 18 ) or ( string.match( petID, "(^0x[0-9a-f]*$)" ) ) then
		error( "invalid petID" )
		return
	end
	
	local pd = ArkInventory.PetJournal.data.pet
	local update = update
	
	local speciesID, customName, level, xp, maxXp, displayID, favorite, name, icon, petType, creatureID = C_PetJournal.GetPetInfoByPetID( petID )
	if ( not name ) then
		ArkInventory.Output( "no name for ", petID )
		return
	end
	
	local sd = ArkInventory.PetJournal.GetSpeciesInfo( speciesID )
	if ( not sd ) then
		ArkInventory.Output( "no species data for ", petID, " / ", speciesID )
		return
	end
	
	local currentHealth, fullHealth, power, speed, rarity = C_PetJournal.GetPetStats( petID )
	rarity = rarity - 1 -- back down to item colour
	
	if ( not update ) and ( ( not pd[petID] ) or ( pd[petID].rarity ~= rarity ) or ( pd[petID].customName ~= customName ) or ( pd[petID].level ~= level ) or ( pd[petID].favorite ~= favorite ) or ( pd[petID].xp ~= xp ) or ( pd[petID].fullHealth ~= fullHealth ) ) then
		update = true
	end
	
	
	local link = C_PetJournal.GetBattlePetLink( petID )
	local isSummonable = C_PetJournal.PetIsSummonable( petID )
	local isRevoked = C_PetJournal.PetIsRevoked( petID )
	local isLockedForConvert = C_PetJournal.PetIsLockedForConvert( petID )
	
	pd[petID] = {
		petID = petID,
		creatureID = creatureID,
		link = link,
		customName = customName,
		level = level,
		favorite = favorite,
		xp = xp,
		maxXp = maxXp,
		currentHealth = currentHealth,
		fullHealth = fullHealth,
		power = power,
		speed = speed,
		rarity = rarity, -- actual pet quality (standard item colour)
		displayID = displayID, -- displayid for the loadout frame
		isSummonable = isSummonable,
		isRevoked = isRevoked, -- being used by another toon on your account
		isLockedForConvert = isLockedForConvert,
		sd = ArkInventory.PetJournal.data.species[speciesID], -- species data for this pet
	}
	
	if customName and customName ~= "" then
		pd[petID].fullName = string.format( "%s (%s)", sd.name, customName )
	else
		pd[petID].fullName = sd.name
	end
	
	if ( level == 25 ) then
		pd[petID].maxHealth = fullHealth
		pd[petID].maxPower = power
		pd[petID].maxSpeed = speed
	else
		pd[petID].maxHealth = ( fullHealth - 100 ) / level * 25
		pd[petID].maxPower = power / level * 25
		pd[petID].maxSpeed = speed / level * 25
	end
	
	return pd[petID], update
	
end

function ArkInventory.PetJournal.GetPetInfo( petID )
	return ArkInventory.PetJournal.data.pet[petID]
end

local PET_STRONG = { 2, 6, 9, 1, 4, 3, 10, 5, 7, 8 }
--[[
	HUMANOID vs DRAGONKIN
	DRAGONKIN vs MAGIC
	FLYING vs AQUATIC
	UNDEAD vs HUMANOID
	CRITTER vs UNDEAD
	MAGIC vs FLYING
	ELEMENTAL vs MECHANICAL
	BEAST vs CRITTER
	AQUATIC vs ELEMENTAL
	MECHANICAL vs BEAST
]]--

local PET_WEAK = { 8, 4, 2, 8, 1, 10, 5, 3, 6, 7 }
--[[
	HUMANOID vs BEAST
	DRAGONKIN vs UNDEAD
	FLYING vs DRAGONKIN
	UNDEAD vs AQUATIC
	CRITTER vs HUMANOID
	MAGIC vs MECHANICAL
	ELEMENTAL vs CRITTER
	BEAST vs FLYING
	AQUATIC vs MAGIC
	MECHANICAL vs ELEMENTAL
]]--

function ArkInventory.PetJournal.ScanSpecies( speciesID )
	
	if ( not speciesID ) or ( type( speciesID ) ~= "number" ) or ( speciesID <= 0 ) then
		error( "invalid speciesID" )
		return
	end
	
	local data = ArkInventory.PetJournal.data.species
	
	if ( not data[speciesID] ) then
		
		local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoBySpeciesID( speciesID )
		
--		if name and ( name ~= "" ) then
			
			data[speciesID] = {
				speciesID = speciesID,
				name = name or ArkInventory.Localise["UNKNOWN"],
				icon = icon,
				petType = petType,
				strong = PET_STRONG[petType],
				weak = PET_WEAK[petType],
				creatureID = creatureID,
				sourceText = sourceText,
				description = description,
				isWild = isWild,
				canBattle = canBattle,
				tradable = tradable,
				unique = unique,
				abilityID = { },
				abilityLevel = { },
			}
			
			if canBattle then
				
				C_PetJournal.GetPetAbilityList( speciesID, data[speciesID].abilityID, data[speciesID].abilityLevel )
				--ArkInventory.Output( "id = ", data[speciesID].abilityID )
				--ArkInventory.Output( "level = ", data[speciesID].abilityLevel )
				
				for i, abilityID in ipairs( data[speciesID].abilityID ) do
					ArkInventory.PetJournal.ScanAbility( abilityID )
				end
				
			end
			
--		end
		
	end
	
	return data[speciesID]
	
end

function ArkInventory.PetJournal.GetSpeciesInfo( speciesID )
	return ArkInventory.PetJournal.data.species[speciesID]
end

function ArkInventory.PetJournal.ScanAbility( abilityID )
	
	if ( not abilityID ) or ( type( abilityID ) ~= "number" ) or ( abilityID <= 0 ) then
		error( "invalid abilityID" )
		return
	end
	
	local data = ArkInventory.PetJournal.data.ability
	
	if ( not data[abilityID] ) then
		
		local id, name, icon, maxCooldown, unparsedDescription, numTurns, petType, noStrongWeakHints = C_PetBattles.GetAbilityInfoByID( abilityID )
		
		data[abilityID] = {
			name = name,
			icon = icon,
			petType = petType,
			noStrongWeakHints = noStrongWeakHints,
			strong = PET_STRONG[petType],
			weak = PET_WEAK[petType],
		}
		
	end
	
	return data[abilityID]
	
end

function ArkInventory.PetJournal.GetAbilityInfo( abilityID )
	return ArkInventory.PetJournal.data.ability[abilityID]
end

function ArkInventory.PetJournal.IsReady( )
	return ArkInventory.PetJournal.data.loaded
end


function ArkInventory.PetJournal.AttackList( speciesID, level )
	
	local sd = ArkInventory.PetJournal.GetSpeciesInfo( speciesID )
	
	local weak = { }
	local strong = { }
	
	local base = ArkInventory.PetJournal.PetTypeName( sd.petType )
	
	for i, abilityType in ipairs( sd.abilityType ) do
		if ( sd.abilityLevel[i] <= level ) and ( PET_WEAK[abilityType] ~= sd.weak ) then
--			ArkInventory.Output( ArkInventory.PetJournal.PetTypeName( abilityType ), " ability weak against ", ArkInventory.PetJournal.PetTypeName( PET_WEAK[abilityType] ) )
			weak[PET_WEAK[abilityType]] = true
		end
	end
	
--	ArkInventory.Output( "-- -- -- -- -- -- --" )

	for i, abilityType in ipairs( sd.abilityType ) do
		
		if ( sd.abilityLevel[i] <= level ) and ( PET_STRONG[abilityType] ~= PET_STRONG[sd.petType] ) then
			
--			ArkInventory.Output( ArkInventory.PetJournal.PetTypeName( abilityType ), " ability strong against ", ArkInventory.PetJournal.PetTypeName( PET_STRONG[abilityType] ) )
			
			weak[PET_STRONG[abilityType]] = nil
			strong[PET_STRONG[abilityType]] = true
			
--			if PET_STRONG[abilityType] == sd.petType then
--				weak[PET_STRONG[abilityType]] = true
--				strong[PET_STRONG[abilityType]] = nil
--			end
			
		end
	end
	
--	ArkInventory.Output( "-- -- -- -- -- -- --" )
	
	
	local info = ArkInventory.PetJournal.PetTypeName( PET_WEAK[sd.petType] )
	local pos = 1
	for abilityType in pairs( weak ) do
--		ArkInventory.Output( "weak ", ArkInventory.PetJournal.PetTypeName( abilityType ) )
		if ( pos == 1 ) then
			info = string.format( "%s or %s", info, ArkInventory.PetJournal.PetTypeName( abilityType ) )
			pos = pos + 1
		else
			info = string.format( "%s, %s", info, ArkInventory.PetJournal.PetTypeName( abilityType ) )
		end
	end
	weak = info
	
	info = ArkInventory.PetJournal.PetTypeName( PET_STRONG[sd.petType] )
	pos = 1
	for abilityType in pairs( strong ) do
--		ArkInventory.Output( "strong ", ArkInventory.PetJournal.PetTypeName( abilityType ) )
		
		if ( pos == 1 ) then
			info = string.format( ArkInventory.Localise["BATTLEPET_OPPONENT_FORMAT_ABILITY1"], info, ArkInventory.PetJournal.PetTypeName( abilityType ) )
			pos = pos + 1
		else
			info = string.format( ArkInventory.Localise["BATTLEPET_OPPONENT_FORMAT_ABILITY2"], info, ArkInventory.PetJournal.PetTypeName( abilityType ) )
		end
		
	end
	strong = info
	
	
	
	
	return weak, strong, base
	
--[[

	for petID, pd in ArkInventory.PetJournal.IteratePetIDs( ) do
		
		if ( pd.level >= level ) and ( weak[pd.sd.petType] ) then
			--ArkInventory.Output( pd.link )
			attackResult[petID] = true
		end
		
	end
]]--
	
end

function ArkInventory.PetJournal.PetTypeName( petType )
	return _G[string.format( "BATTLE_PET_NAME_%d", petType )]
end

function ArkInventory.PetJournal.BattlePetInfoTarget( )
	
	local unit = "target"
	
	if ( unit ) and ( UnitIsWildBattlePet( unit ) or UnitIsOtherPlayersBattlePet( unit ) or UnitIsBattlePetCompanion( unit ) ) then
		
		local guid = UnitGUID( unit )
		local speciesID = ArkInventory.PetJournal.GetSpeciesIDfromGUID( guid )
		
		if speciesID then
			-- cant get level from targeted battlepets
			ArkInventory.PetJournal.PetBattleHelp( speciesID )
		end
		
	end
	
end

function ArkInventory.PetJournal.PetBattleHelp( speciesID, level )
	
	local enemy = ArkInventory.PetJournal.ScanSpecies( speciesID )
	if not enemy then
		ArkInventory.Output( "no data returned for speciesID:", speciesID )
		return
	end
	
	local level = level or 25
	
	local strong = { }
	
	local ad
	for i, abilityID in ipairs( enemy.abilityID ) do
		ad = ArkInventory.PetJournal.ScanAbility( abilityID )
		--ArkInventory.Output( "strong ability ", i, " = ", ad )
		if not ad.noStrongWeakHints then
			strong[ad.strong] = true
		end
	end
	
	local weak = { }
	weak[enemy.weak] = true
	for i, abilityID in ipairs( enemy.abilityID ) do
		ad = ArkInventory.PetJournal.ScanAbility( abilityID )
		--ArkInventory.Output( "weak ability ", i, " = ", ad )
		if not ad.noStrongWeakHints then
			weak[ad.weak] = true
		end
	end
	
	for x in pairs( strong ) do
		weak[strong[x]] = nil
	end
	
--	ArkInventory.Output( "-- -- -- -- -- -- --" )
--	ArkInventory.Output( "name = ", enemy.name )
--	ArkInventory.Output( "level = ", level )
	
--	for x in pairs( strong ) do
--		ArkInventory.Output( "strong = ", ArkInventory.PetJournal.PetTypeName( x ) )
--	end
--	for x in pairs( weak ) do
--		ArkInventory.Output( "weak = ", ArkInventory.PetJournal.PetTypeName( x ) )
--	end
	
	local result, count, bad, good, modifier
	local species = { }
	
	for v = 3, 1, -1 do
		
		result = false
		
		for petID, pd in ArkInventory.PetJournal.IteratePetIDs( ) do
			
			if ( pd.sd.canBattle ) and ( not species[pd.sd.speciesID] ) and ( pd.level >= ( level - 5 ) ) and ( pd.sd.petType == enemy.weak ) and ( not strong[pd.sd.PetType] ) then
				
				-- must be battle capable
				-- cant have been reported already
				-- within 5 levels
				-- pets the enemy is weak against
				
	--			ArkInventory.Output( "checking ", pd.link )
				
				bad = false
				good = false
				count = 0
				modifier = 1.0
				
				--ArkInventory.Output( "pd.sd = ", pd.sd )
				
				for i = 1, 3 do
					
					-- first row abilities
					
					if ( pd.sd.abilityLevel[i] <= level ) then
						
						ad = ArkInventory.PetJournal.ScanAbility( pd.sd.abilityID[i] )
						--ArkInventory.Output( "ability ", i, " = ", ad )
						modifier = C_PetBattles.GetAttackModifier( ad.petType, enemy.petType )
						
						if ( ad.noStrongWeakHints or modifier == 1 ) then
							-- neutral ability, dont care
						elseif ( modifier < 1 ) then
							-- weak ability, ignore this pet
							bad = true
						elseif ( modifier > 1 ) then
							-- strong ability, possibly include this pet
							good = true
							count = count + 1
						end
						
					end
					
					-- second row abilities
					if ( ( not good ) or ( bad ) ) and ( pd.sd.abilityLevel[i+3] <= level ) then
						
						ad = ArkInventory.PetJournal.ScanAbility( pd.sd.abilityID[i+3] )
						--ArkInventory.Output( "ability ", i, " = ", ad )
						modifier = C_PetBattles.GetAttackModifier( ad.petType, enemy.petType )
						
						if ( ad.noStrongWeakHints or modifier == 1 ) then
							-- neutral ability, dont care
						elseif ( modifier < 1 ) then
							-- weak ability, ignore this pet
							bad = true
						elseif ( modifier > 1 ) then
							-- strong ability, possibly include this pet
							bad = false
							count = count + 1
						end
						
					end
					
				end
				
				if ( not bad ) and ( count >= v ) then
					species[pd.sd.speciesID] = true
					ArkInventory.Output( pd.link, " (", count, ")" )
					result = true
				end
				
			end
			
		end
		
		if result then
			return
		end
		
	end
	
	-- there are no base weak pets
	
	for v = 3, 1, -1 do
		
		result = false
		
		for petID, pd in ArkInventory.PetJournal.IteratePetIDs( ) do
			
			if ( pd.sd.canBattle ) and ( not species[pd.sd.speciesID] ) and ( pd.level >= ( level - 5 ) ) and ( not strong[pd.sd.petType] ) then
				
				-- must be battle capable
				-- cant have been reported already
				-- within 5 levels
				-- pets where the enemy attacks are not strong
				
	--			ArkInventory.Output( "checking ", pd.link )
				
				bad = false
				good = false
				count = 0
				modifier = 1.0
				
				--ArkInventory.Output( "pd.sd = ", pd.sd )
				
				for i = 1, 3 do
					
					-- first row abilities
					
					if ( pd.sd.abilityLevel[i] <= level ) then
						
						ad = ArkInventory.PetJournal.ScanAbility( pd.sd.abilityID[i] )
						--ArkInventory.Output( "ability ", i, " = ", ad )
						modifier = C_PetBattles.GetAttackModifier( ad.petType, enemy.petType )
						
						if ( ad.noStrongWeakHints or modifier == 1 ) then
							-- neutral ability, dont care
						elseif ( modifier < 1 ) then
							-- weak ability, ignore this pet
							bad = true
						elseif ( modifier > 1 ) then
							-- strong ability, possibly include this pet
							good = true
							count = count + 1
						end
						
					end
					
					-- second row abilities
					if ( ( not good ) or ( bad ) ) and ( pd.sd.abilityLevel[i+3] <= level ) then
						
						ad = ArkInventory.PetJournal.ScanAbility( pd.sd.abilityID[i+3] )
						--ArkInventory.Output( "ability ", i, " = ", ad )
						modifier = C_PetBattles.GetAttackModifier( ad.petType, enemy.petType )
						
						if ( ad.noStrongWeakHints or modifier == 1 ) then
							-- neutral ability, dont care
						elseif ( modifier < 1 ) then
							-- weak ability, ignore this pet
							bad = true
						elseif ( modifier > 1 ) then
							-- strong ability, possibly include this pet
							bad = false
							count = count + 1
						end
						
					end
					
				end
				
				if ( not bad ) and ( count >= v ) then
					species[pd.sd.speciesID] = true
					ArkInventory.Output( pd.link, " (", count, ")" )
					result = true
				end
				
			end
			
		end
		
		if result then
			return
		end
		
	end
	
end

function ArkInventory:LISTEN_PET_BATTLE_OPENING_DONE( event, ... )
	
	--ArkInventory.Output( "LISTEN_PET_BATTLE_OPENING_DONE" )
	-- /run ArkInventory:LISTEN_PET_BATTLE_OPENING_DONE( "MANUAL" )
	if not ArkInventory.db.global.option.message.battlepet.opponent then return end
	
	local help = ...
	local player = 2
	local isnpc = C_PetBattles.IsPlayerNPC( player )
	local opponents = C_PetBattles.GetNumPets( player )
	
--	if opponents > 1 then
		ArkInventory.Output( "--- --- --- --- --- --- ---" )
--	end
	
	for i = 1, opponents do
		
		local name = C_PetBattles.GetName( player, i )
		
		local speciesID = C_PetBattles.GetPetSpeciesID( player, i )
		local level = C_PetBattles.GetLevel( player, i )
		local fullHealth = C_PetBattles.GetMaxHealth( player, i )
		local power = C_PetBattles.GetPower( player, i )
		local speed = C_PetBattles.GetSpeed( player, i )
		
		local rarity = C_PetBattles.GetBreedQuality( player, i )
		rarity = ( rarity and ( rarity - 1 ) ) or -1
		
		local maxHealth, maxPowerm, maxSpeed
		
		if ( level == 25 ) then
			maxHealth = fullHealth
			maxPower = power
			maxSpeed = speed
		else
			maxHealth = ( fullHealth - 100 ) / level * 25
			maxPower = power / level * 25
			maxSpeed = speed / level * 25
		end
		
		local info = ""
		local count
		
		local sd = ArkInventory.PetJournal.ScanSpecies( speciesID, i )
		
		if C_PetBattles.IsWildBattle( ) then
			
			--ArkInventory.Output( "wild battle" )
			
			if ( not sd.canBattle ) then
				-- opponent cannot battle (and yet it is), its one of the secondary non-capturabe opponents
				info = string.format( "%s- %s", YELLOW_FONT_COLOR_CODE, ArkInventory.Localise["BATTLEPET_OPPONENT_IMMUNE"] )
			else
				count = true
			end
			
		elseif isnpc then
			
			--ArkInventory.Output( "trainer battle" )
			
		else
			
			--ArkInventory.Output( "pvp battle" )
			
			count = true
			
		end
		
		if help and ( type( help ) == "string" ) and ( help == "PET_BATTLE_HELP" ) then
			--local good, bad = ArkInventory.PetJournal.AttackList( speciesID, level )
			--info = string.format( " vs %s", good )
			ArkInventory.PetJournal.PetBattleHelp( speciesID, level )
		end
		
		local h = string.format( "%s|Hbattlepet:%s:%s:%s:%s:%s:%s:%s|h[%s]|h|r", select( 5, ArkInventory.GetItemQualityColor( rarity ) ), speciesID, level, rarity, fullHealth, power, speed, name, name )
		
		if ( not count ) then
			
			-- dont do anything
			
		else
			
			count = ArkInventory.ObjectCountGet( h )
			
			if ArkInventory.Table.IsEmpty( count ) then
				
				info = string.format( "%s- %s", RED_FONT_COLOR_CODE, ArkInventory.Localise["BATTLEPET_OPPONENT_UNKNOWN"] )
				
			else
				
				local acn = ArkInventory.PlayerIDAccount( ) 
				count = ( count[acn] and count[acn].location and count[acn].location[ArkInventory.Const.Location.Pet] ) or 0
				
				if count >= ArkInventory.Const.MAX_PET_SAVED_SPECIES then
					
					info = string.format( "- %s", ArkInventory.Localise["BATTLEPET_OPPONENT_KNOWN_MAX"] )
					
				elseif C_PetBattles.IsWildBattle( ) then
					
					local upgrade = false
					
					for petID, pd in ArkInventory.PetJournal.IteratePetIDs( ) do
						
						if ( pd.sd.speciesID == speciesID ) then
							local q = pd.rarity
							--ArkInventory.Output( "s=[", speciesID, "], ", h, ", [", rarity, "] / ", pd.link, " [", q, "]" )
							if ( rarity >= q ) and ( ( fullHealth > pd.maxHealth ) or ( maxPower > pd.maxPower ) or ( maxSpeed > pd.maxSpeed ) ) then
								upgrade = true
							end
							
							if string.len( info ) < 2 then
								info = string.format( "- %s ", ArkInventory.Localise["BATTLEPET_OPPONENT_UPGRADE"] )
								--info = string.format( "- " )
							end
							
							info = string.format( "%s%s", info, pd.link )
							
						end
					end
					
					if not upgrade then
						info = ""
					end
					
				end
				
			end
			
		end
		
		--ArkInventory.Output( YELLOW_FONT_COLOR_CODE, ArkInventory.Localise["BATTLEPET"], " #", i, ": ", h, " ", YELLOW_FONT_COLOR_CODE, info )
		ArkInventory.Output( YELLOW_FONT_COLOR_CODE, "#", i, ": ", h, " ", YELLOW_FONT_COLOR_CODE, info )
	
	end
	
end

function ArkInventory:LISTEN_BATTLEPET_UPDATE( )
	
	--ArkInventory.Output( "LISTEN_BATTLEPET_UPDATE" )
	
	local loc_id = ArkInventory.Const.Location.Pet
	ArkInventory.ScanLocation( loc_id )
	--ArkInventory.Frame_Main_Generate( loc_id, ArkInventory.Const.Window.Draw.Recalculate )
	
	ArkInventory.LDB.Pets:Update( )
	ArkInventory.MountDataUpdate( )
	
end

function ArkInventory:LISTEN_PETJOURNAL_RELOAD( event, ... )
	
	--ArkInventory.Output( "LISTEN_PETJOURNAL_RELOAD( ", event, " )" )
	--ArkInventory.Output( event )
	
	if ( event == "PET_JOURNAL_LIST_UPDATE" ) then
		
		ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", event )
		
	elseif ( event == "COMPANION_UPDATE" ) then
		
		local c = ...
		if ( c == "CRITTER" ) then
			ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", event )
		end
		
	else
		
		ArkInventory:SendMessage( "LISTEN_PETJOURNAL_RELOAD_BUCKET", event )
		
	end
	
end

function ArkInventory:LISTEN_PETJOURNAL_RELOAD_BUCKET( events )
	
	--ArkInventory.Output( "LISTEN_PETJOURNAL_RELOAD_BUCKET" )
	--ArkInventory.Output( events )
	
	if PetJournal:IsVisible( ) then
		--ArkInventory.Output( "IGNORED (JOURNAL OPEN)" )
		return
	end
	
	if filter.ignore then
		--ArkInventory.Output( "IGNORED (FILTER CHANGED BY ME)" )
		filter.ignore = false
		return
	end
	
	ArkInventory.PetJournal.Scan( )
	
end
