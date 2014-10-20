local _, AskMrRobot = ...
local L = AskMrRobot.L;

AskMrRobot.eventListener = CreateFrame("FRAME") -- Need a frame to respond to events
AskMrRobot.eventListener:RegisterEvent("ADDON_LOADED") -- Fired when saved variables are loaded
AskMrRobot.eventListener:RegisterEvent("ITEM_PUSH")
AskMrRobot.eventListener:RegisterEvent("DELETE_ITEM_CONFIRM")
AskMrRobot.eventListener:RegisterEvent("UNIT_INVENTORY_CHANGED")
AskMrRobot.eventListener:RegisterEvent("BANKFRAME_OPENED")
--AskMrRobot.eventListener:RegisterEvent("BANKFRAME_CLOSED");
AskMrRobot.eventListener:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
AskMrRobot.eventListener:RegisterEvent("CHARACTER_POINTS_CHANGED")
AskMrRobot.eventListener:RegisterEvent("CONFIRM_TALENT_WIPE")
AskMrRobot.eventListener:RegisterEvent("PLAYER_TALENT_UPDATE")
AskMrRobot.eventListener:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
AskMrRobot.eventListener:RegisterEvent("PLAYER_ENTERING_WORLD")
--AskMrRobot.eventListener:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
--AskMrRobot.eventListener:RegisterEvent("PLAYER_LEVEL_UP")
--AskMrRobot.eventListener:RegisterEvent("GET_ITEM_INFO_RECEIVED")
AskMrRobot.eventListener:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
AskMrRobot.eventListener:RegisterEvent("SOCKET_INFO_UPDATE")
AskMrRobot.eventListener:RegisterEvent("SOCKET_INFO_CLOSE")
AskMrRobot.eventListener:RegisterEvent("BAG_UPDATE")
AskMrRobot.eventListener:RegisterEvent("ITEM_UNLOCKED")
AskMrRobot.eventListener:RegisterEvent("PLAYER_REGEN_DISABLED")
--AskMrRobot.eventListener:RegisterEvent("ENCOUNTER_START")
AskMrRobot.eventListener:RegisterEvent("CHAT_MSG_ADDON")
AskMrRobot.eventListener:RegisterEvent("UPDATE_INSTANCE_INFO")
AskMrRobot.eventListener:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")

AskMrRobot.AddonName = ...
AskMrRobot.ChatPrefix = "_AMR"

-- the main user interface window
AskMrRobot.mainWindow = nil

local _amrLDB
local _minimapIcon

function AskMrRobot.eventListener:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
        local addon = select(1, ...)
        if (addon == "AskMrRobot") then
            --print(L.AMR_ON_EVENT_LOADED:format(GetAddOnMetadata(AskMrRobot.AddonName, "Version")))
            
            AskMrRobot.InitializeSettings()
            AskMrRobot.InitializeMinimap()
            
            -- listen for messages from other AMR addons
            RegisterAddonMessagePrefix(AskMrRobot.ChatPrefix)            

            AskMrRobot.mainWindow = AskMrRobot.AmrUI:new()
        end
    
    elseif event == "UNIT_INVENTORY_CHANGED" then
        AskMrRobot.ScanEquipped()
        
	elseif event == "ITEM_PUSH" or event == "DELETE_ITEM_CONFIRM" or event == "SOCKET_INFO_CLOSE" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "BAG_UPDATE" then
		--if AskMrRobot_ReforgeFrame then
		--	AskMrRobot_ReforgeFrame:OnUpdate()
		--end
		--AskMrRobot.SaveBags();
		--AskMrRobot.SaveEquiped();
		--AskMrRonot.GetCurrencies();
		--AskMrRobot.GetGold();
        
	elseif event == "BANKFRAME_OPENED" or event == "PLAYERBANKSLOTS_CHANGED" then 
		AskMrRobot.ScanBank();
        
	elseif event == "CHARACTER_POINTS_CHANGED" or event == "CONFIRM_TALENT_WIPE" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		--AskMrRobot.GetAmrSpecializations();
		--if AskMrRobot_ReforgeFrame then
		--	AskMrRobot_ReforgeFrame:OnUpdate()
		--end
        
	elseif event == "ITEM_UNLOCKED" then
		--AskMrRobot.On_ITEM_UNLOCKED()

    elseif event == "PLAYER_ENTERING_WORLD" then
        AskMrRobot.RecordLogin()

    elseif event == "PLAYER_REGEN_DISABLED" then
        -- send data about this character when a player enters combat in a supported zone
		if AskMrRobot.IsSupportedInstance() then
			local t = time()
			AskMrRobot.SaveAll()
			AskMrRobot.ExportToAddonChat(t)
			AskMrRobot.CombatLogTab.SaveExtras(t)
		end

    elseif event == "CHAT_MSG_ADDON" then
        local chatPrefix, message = select(1, ...)
        local isLogging = AskMrRobot.CombatLogTab.IsLogging()
        if (isLogging and chatPrefix == AskMrRobot.ChatPrefix) then
            AskMrRobot.mainWindow.combatLogTab:ReadAddonMessage(message)
        end
        
    elseif event == "UPDATE_INSTANCE_INFO" or event == "PLAYER_DIFFICULTY_CHANGED" then
    	AskMrRobot.mainWindow.combatLogTab:UpdateAutoLogging()
        
	end
 
end

AskMrRobot.eventListener:SetScript("OnEvent", AskMrRobot.eventListener.OnEvent)


SLASH_AMR1 = "/amr";
function SlashCmdList.AMR(msg)

	if msg == 'toggle' then
		AskMrRobot.mainWindow:Toggle()
	elseif msg == 'show' then
		AskMrRobot.mainWindow:Show()
	elseif msg == 'hide' then
		AskMrRobot.mainWindow:Hide()
	elseif msg == 'export' then
		AskMrRobot.mainWindow.exportTab:Show()
	elseif msg == 'wipe' then
		AskMrRobot.mainWindow.combatLogTab:LogWipe()
	elseif msg == 'unwipe' then
		AskMrRobot.mainWindow.combatLogTab:LogUnwipe()
	else
		print(L.AMR_SLASH_COMMAND_TEXT_1 .. L.AMR_SLASH_COMMAND_TEXT_2 .. L.AMR_SLASH_COMMAND_TEXT_3 .. L.AMR_SLASH_COMMAND_TEXT_4 .. L.AMR_SLASH_COMMAND_TEXT_5 .. L.AMR_SLASH_COMMAND_TEXT_6 .. L.AMR_SLASH_COMMAND_TEXT_7)
	end
end

-- initialize settings when the addon loads
function AskMrRobot.InitializeSettings()

    -- global settings
    if not AmrSettings then AmrSettings = {} end
    if not AmrSettings.Logins then AmrSettings.Logins = {} end
    
    -- per-character settings
    if not AmrDb then AmrDb = {} end
    
    -- addon stuff
    if not AmrDb.IconInfo then AmrDb.IconInfo = {} end
    if not AmrDb.Options then AmrDb.Options = {} end
    if not AmrDb.LastCharacterImport then AmrDb.LastCharacterImport = "" end
    if not AmrDb.LastCharacterImportDate then AmrDb.LastCharacterImportDate = "" end
    
    if not AmrDb.SendSettings then
        AmrDb.SendSettings = {
            SendGems = true,
            SendEnchants = true,
            SendEnchantMaterials = true,
            SendToType = "a friend",
            SendTo = ""
        }
    end
    
    -- character stuff
    AskMrRobot.ScanCharacter()    
    if not AmrDb.BankItems then AmrDb.BankItems = {} end
    if not AmrDb.BagItems then AmrDb.BagItems = {} end
    if not AmrDb.Currencies then AmrDb.Currencies = {} end
    if not AmrDb.Reps then AmrDb.Reps = {} end
    -- data saved for both specs
    if not AmrDb.Specs then AmrDb.Specs = {} end
    if not AmrDb.Glyphs then AmrDb.Glyphs = {} end
    if not AmrDb.Talents then AmrDb.Talents = {} end
    if not AmrDb.Equipped then AmrDb.Equipped = {} end
    
    -- combat log specific settings
    AskMrRobot.CombatLogTab.InitializeVariable()
end

-- record logins when the addon starts up, used to help figure out which character logged which parts of a log file
function AskMrRobot.RecordLogin()

    -- delete entries that are more than 10 days old to prevent the table from growing indefinitely
    if AmrSettings.Logins and #AmrSettings.Logins > 0 then
        local now = time()
        local oldDuration = 60 * 60 * 24 * 10
        local entryTime
        repeat
            -- parse entry and get time
            local parts = {}
            for part in string.gmatch(AmrSettings.Logins[1], "([^;]+)") do
                tinsert(parts, part)
            end
            entryTime = tonumber(parts[3])

            -- entries are in order, remove first entry if it is old
            if difftime(now, entryTime) > oldDuration then
                tremove(AmrSettings.Logins, 1)
            end
        until #AmrSettings.Logins == 0 or difftime(now, entryTime) <= oldDuration
    end

    -- record the time a player logs in, used to figure out which player logged which parts of their log file
    local key = AmrDb.RealmName .. ";" .. AmrDb.CharacterName .. ";"
    local loginData = key .. time()
    if AmrSettings.Logins and #AmrSettings.Logins > 0 then
        local last = AmrSettings.Logins[#AmrSettings.Logins]
        if string.len(last) >= string.len(key) and string.sub(last, 1, string.len(key)) ~= key then
            table.insert(AmrSettings.Logins, loginData)
        end
    else
        table.insert(AmrSettings.Logins, loginData)
    end
end

function AskMrRobot.InitializeMinimap()

    -- minimap icon and data broker icon plugin thingy
    _amrLDB = LibStub("LibDataBroker-1.1"):NewDataObject("AskMrRobot", {
        type = "launcher",
        text = "Ask Mr. Robot",
        icon = "Interface\\AddOns\\AskMrRobot\\Media\\icon",
        OnClick = function()            
            if IsControlKeyDown() then
                AskMrRobot.mainWindow.combatLogTab:LogWipe()
            elseif IsModifiedClick("CHATLINL") then
                AskMrRobot.mainWindow.exportTab:Show()
            else
                AskMrRobot.mainWindow:Toggle()
            end
        end,
        OnTooltipShow = function(tt)
            tt:AddLine("Ask Mr. Robot", 1, 1, 1);
            tt:AddLine(" ");
            tt:AddLine(L.AMR_ON_EVENT_TOOLTIP)
        end	
    });

    AskMrRobot.AmrUpdateMinimap()
end

function AskMrRobot.AmrUpdateMinimap()	
	if AmrDb.Options.hideMapIcon then
		if _minimapIcon then
			_minimapIcon:Hide("AskMrRobot")
		end
	else
		if not _minimapIcon then 
			_minimapIcon = LibStub("LibDBIcon-1.0")
            _minimapIcon:Register("AskMrRobot", _amrLDB, AmrDb.IconInfo)
		end
		
		if AskMrRobot.CombatLogTab.IsLogging() then
			_amrLDB.icon = 'Interface\\AddOns\\AskMrRobot\\Media\\icon_green'
		else
			_amrLDB.icon = 'Interface\\AddOns\\AskMrRobot\\Media\\icon'
		end
        
		_minimapIcon:Show("AskMrRobot")
	end
end


function AskMrRobot.SaveAll()
    AskMrRobot.ScanCharacter()
	AskMrRobot.ScanBank()
	AskMrRobot.ScanBags()
	AskMrRobot.ScanEquipped()
	AskMrRobot.GetCurrencies()
    AskMrRobot.GetReputations()
	AskMrRobot.GetSpecs()
end

-- gets all basic character properties
function AskMrRobot.ScanCharacter()
    AmrDb.RealmName = GetRealmName()
    AmrDb.CharacterName = UnitName("player")
	AmrDb.Guild = GetGuildInfo("player")
    AmrDb.ActiveSpec = GetActiveSpecGroup()
    AmrDb.Level = UnitLevel("player");
    
    local cls, clsEn = UnitClass("player")
    AmrDb.Class = clsEn;
    
    local race, raceEn = UnitRace("player")
	AmrDb.Race = raceEn;
	AmrDb.Faction = UnitFactionGroup("player")
    
    AskMrRobot.GetAmrProfessions()
end

function AskMrRobot.GetAmrProfessions()

	local profMap = {
		[794] = "Archaeology",
		[171] = "Alchemy",
		[164] = "Blacksmithing",
		[185] = "Cooking",
		[333] = "Enchanting",
		[202] = "Engineering",
		[129] = "First Aid",
		[356] = "Fishing",
		[182] = "Herbalism",
		[773] = "Inscription",
		[755] = "Jewelcrafting",
		[165] = "Leatherworking",
		[186] = "Mining",
		[393] = "Skinning",
		[197] = "Tailoring"
	}

	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
	AmrDb.Professions = {};
	if prof1 then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(prof1);
		if profMap[skillLine] ~= nil then
			AmrDb.Professions[profMap[skillLine]] = skillLevel;
		end
	end
	if prof2 then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(prof2);
		if profMap[skillLine] ~= nil then
			AmrDb.Professions[profMap[skillLine]] = skillLevel;
		end
	end
	if archaeology then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(archaeology);
		if profMap[skillLine] ~= nil then
			AmrDb.Professions[profMap[skillLine]] = skillLevel;
		end
	end
	if fishing then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(fishing);
		if profMap[skillLine] ~= nil then
			AmrDb.Professions[profMap[skillLine]] = skillLevel;
		end
	end
	if cooking then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(cooking);
		if profMap[skillLine] ~= nil then
			AmrDb.Professions[profMap[skillLine]] = skillLevel;
		end
	end
	if firstAid then
		local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier = GetProfessionInfo(firstAid);
		if profMap[skillLine] ~= nil then
			AmrDb.Professions[profMap[skillLine]] = skillLevel;
		end
	end
end


-- use some local variables to deal with the fact that a user can close the bank before a scan completes
local _lastBankBagId = nil
local _lastBankSlotId = nil
local BACKPACK_CONTAINER = 0
local BANK_CONTAINER = -1

local function scanBag(bagId, isBank, bagTable, bagItemsWithCount)
	local numSlots = GetContainerNumSlots(bagId)
	for slotId = 1, numSlots do
		local _, itemCount, _, _, _, _, itemLink = GetContainerItemInfo(bagId, slotId)
        -- we skip any stackable item, as far as we know, there is no equippable gear that can be stacked
		if itemLink ~= nil then
			local itemData = AskMrRobot.parseItemLink(itemLink)
			if itemData ~= nil then			
				if itemCount == 1 then
	                if isBank then
                    	_lastBankBagId = bagId
                    	_lastBankSlotId = slotId
                	end                	
                	tinsert(bagTable, itemLink)
                end
                if bagItemsWithCount then
                	if bagItemsWithCount[itemData.id] then
                		bagItemsWithCount[itemData.id] = bagItemsWithCount[itemData.id] + itemCount
                	else
                		bagItemsWithCount[itemData.id] = itemCount
                	end
                end
            end
		end
	end
end
		
function AskMrRobot.ScanBank(bankItemsWithCount)
	local bankItems = {}
	local bankItemsAndCounts = {}

	scanBag(BANK_CONTAINER, true, bankItems, bankItemsAndCounts)
	for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
		scanBag(bagId, true, bankItems, bankItemsAndCounts)
	end
	
	-- see if the scan completed before the window closed, otherwise we don't overwrite with partial data
	if _lastBankBagId ~= nil then
		local itemLink = GetContainerItemLink(_lastBankBagId, _lastBankSlotId)
		if itemLink ~= nil then --still open
            AmrDb.BankItems = bankItems
            AmrDb.BankItemsAndCounts = bankItemsAndCounts
		end
	end
end

function AskMrRobot.ScanBags(bagItemsWithCount)
	local bagItems = {}
	scanBag(BACKPACK_CONTAINER, false, bagItems, bagItemsWithCount) -- backpack
	for bagId = 1, NUM_BAG_SLOTS do
		scanBag(bagId, false, bagItems, bagItemsWithCount)
	end
	AmrDb.BagItems = bagItems
end

function AskMrRobot.ScanEquipped()
    local equippedItems = {};
	for slotNum = 1, #AskMrRobot.slotIds do
		local slotId = AskMrRobot.slotIds[slotNum];
		local itemLink = GetInventoryItemLink("player", slotId);
		if (itemLink ~= nil) then
			equippedItems[slotId] = itemLink;
		end
	end
    
    -- store last-seen equipped gear for each spec
	AmrDb.Equipped[GetActiveSpecGroup()] = equippedItems
end


local function getCurrencyAmount(index)
	local localized_label, amount, icon_file_name = GetCurrencyInfo(index);
	return amount;
end

function AskMrRobot.GetCurrencies()
    local currencies = {};
    currencies[-1] = GetMoney()
    
    local currencyList = {61, 81, 241, 361, 384, 394, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 416, 515, 614, 615, 676, 679}
	for i, currency in pairs(currencyList) do
		local amount = getCurrencyAmount(currency)
		if amount ~= 0 then
			currencies[currency] = amount
		end
	end
    
    AmrDb.Currencies = currencies
end


local function getRepStanding(factionId)
    local name, description, standingId, _ = GetFactionInfoByID(factionId)
    return standingId - 1; -- our rep enum correspond to what the armory returns, are 1 less than what the game returns
end

function AskMrRobot.GetReputations()
    local reps = {}
    
    local repList = {1375,1376,1270,1269,1341,1337,1387,1388,1435}
    for i, repId in pairs(repList) do
        local standing = getRepStanding(repId)
        if standing >= 0 then
            reps[repId] = standing
        end
    end
    
    AmrDb.Reps = reps;
end


local function getSpecId(specGroup)
	local spec = GetSpecialization(false, false, specGroup);
	return spec and GetSpecializationInfo(spec);
end

local function getTalents(specGroup)	
    local talentInfo = {}
    local maxTiers = 7
    for tier = 1, maxTiers do
        for col = 1, 3 do
            local id, name, texture, selected, available = GetTalentInfo(tier, col, specGroup)
            if selected then
                talentInfo[tier] = col
            end
        end
    end
    
    local str = ""
    for i = 1, maxTiers do
    	if talentInfo[i] then
    		str = str .. talentInfo[i]
    	else
    		str = str .. '0'
    	end
    end    	

	return str
end

local function getGlyphs(specGroup)
	local glyphs = {}
	for i = 1,  NUM_GLYPH_SLOTS do
		local _, _, _, glyphSpellID, _, glyphID = GetGlyphSocketInfo(i, specGroup)
		if (glyphID) then
			tinsert(glyphs, glyphSpellID)
		end
	end
	return glyphs;
end

-- get specs, talents, and glyphs
function AskMrRobot.GetSpecs()

    AmrDb.Specs = {}
    AmrDb.Talents = {}
    AmrDb.Glyphs = {}
    
    for group = 1, GetNumSpecGroups() do
        -- spec, convert game spec id to one of our spec ids
        local specId = getSpecId(group)
        if specId then
            AmrDb.Specs[group] = AskMrRobot.specIds[specId]
        else
            AmrDb.Specs[group] = 0
        end
        
        AmrDb.Talents[group] = getTalents(group)
        AmrDb.Glyphs[group] = getGlyphs(group)
	end
end

----------------------------------------------------------------------------
-- Export
----------------------------------------------------------------------------

function AskMrRobot.toCompressedNumberList(list)
    -- ensure the values are numbers, sorted from lowest to highest
    local nums = {}
    for i, v in ipairs(list) do
        table.insert(nums, tonumber(v))
    end
    table.sort(nums)
    
    local ret = {}
    local prev = 0
    for i, v in ipairs(nums) do
        local diff = v - prev
        table.insert(ret, diff)
        prev = v
    end
    
    return table.concat(ret, ",")
end

-- appends a list of items to the export
local function appendItemsToExport(fields, itemObjects)

    -- sort by item id so we can compress it more easily
    table.sort(itemObjects, function(a, b) return a.id < b.id end)
    
    -- append to the export string
    local prevItemId = 0
    local prevGemId = 0
    local prevEnchantId = 0
    local prevUpgradeId = 0
    local prevBonusId = 0
    for i, itemData in ipairs(itemObjects) do
        local itemParts = {}
        
        table.insert(itemParts, itemData.id - prevItemId)
        prevItemId = itemData.id
        
        if itemData.slot ~= nil then table.insert(itemParts, "s" .. itemData.slot) end
        if itemData.suffixId ~= 0 then table.insert(itemParts, "f" .. itemData.suffixId) end
        if itemData.upgradeId ~= 0 then 
            table.insert(itemParts, "u" .. (itemData.upgradeId - prevUpgradeId))
            prevUpgradeId = itemData.upgradeId
        end
        if itemData.bonusIds then
            for bIndex, bValue in ipairs(itemData.bonusIds) do
                table.insert(itemParts, "b" .. (bValue - prevBonusId))
                prevBonusId = bValue
            end
        end        
        if itemData.gemIds[1] ~= 0 then 
            table.insert(itemParts, "x" .. (itemData.gemIds[1] - prevGemId))
            prevGemId = itemData.gemIds[1]
        end
        if itemData.gemIds[2] ~= 0 then 
            table.insert(itemParts, "y" .. (itemData.gemIds[2] - prevGemId))
            prevGemId = itemData.gemIds[2]
        end
        if itemData.gemIds[3] ~= 0 then 
            table.insert(itemParts, "z" .. (itemData.gemIds[3] - prevGemId))
            prevGemId = itemData.gemIds[3]
        end
        if itemData.enchantId ~= 0 then 
            table.insert(itemParts, "e" .. (itemData.enchantId - prevEnchantId))
            prevEnchantId = itemData.enchantId
        end
    
        table.insert(fields, table.concat(itemParts, ""))
    end
end

-- create a compact string representing this player
--  if complete is true, exports everything (inventory, both specs)
--  otherwise only exports the player's active gear, spec, etc.
function AskMrRobot.ExportToCompressedString(complete)
    local fields = {}
    
    -- compressed string uses a fixed order rather than inserting identifiers
    table.insert(fields, GetAddOnMetadata(AskMrRobot.AddonName, "Version"))
    table.insert(fields, AmrDb.RealmName)
    table.insert(fields, AmrDb.CharacterName)

	-- guild name
	local guildName = GetGuildInfo("player")
	if guildName == nil then
		table.insert(fields, "")
	else
		table.insert(fields, guildName)
    end

    -- race, default to pandaren if we can't read it for some reason
    local raceval = AskMrRobot.raceIds[AmrDb.Race]
    if raceval == nil then raceval = 13 end
    table.insert(fields, raceval)
    
    -- faction, default to alliance if we can't read it for some reason
    raceval = AskMrRobot.factionIds[AmrDb.Faction]
    if raceval == nil then raceval = 1 end
    table.insert(fields, raceval)
    
    table.insert(fields, AmrDb.Level)
    
    local profs = {}
    local noprofs = true
    if AmrDb.Professions then
	    for k, v in pairs(AmrDb.Professions) do
	        local profval = AskMrRobot.professionIds[k]
	        if profval ~= nil then
	            noprofs = false
	            table.insert(profs, profval .. ":" .. v)
	        end
	    end
	end
    
    if noprofs then
        table.insert(profs, "0:0")
    end
    
    table.insert(fields, table.concat(profs, ","))
    
    -- export specs
    table.insert(fields, AmrDb.ActiveSpec)
    for spec = 1, 2 do
        if AmrDb.Specs[spec] and (complete or spec == AmrDb.ActiveSpec) then
            table.insert(fields, ".s" .. spec) -- indicates the start of a spec block
            table.insert(fields, AmrDb.Specs[spec])
            table.insert(fields, AmrDb.Talents[spec])
            table.insert(fields, AskMrRobot.toCompressedNumberList(AmrDb.Glyphs[spec]))
        end
    end
    
    -- export equipped gear
    if AmrDb.Equipped then
        for spec = 1, 2 do
            if AmrDb.Equipped[spec] and (complete or spec == AmrDb.ActiveSpec) then
                table.insert(fields, ".q" .. spec) -- indicates the start of an equipped gear block
                
                local itemObjects = {}
                for k, v in pairs(AmrDb.Equipped[spec]) do
                    local itemData = AskMrRobot.parseItemLink(v)
                    itemData.slot = k
                    table.insert(itemObjects, itemData)
                end
                
                appendItemsToExport(fields, itemObjects)
            end
        end
	end
    
    -- if doing a complete export, include reputations and bank/bag items too
    if complete then
    
        -- export reputations
        local reps = {}
        local noreps = true
        if AmrDb.Reps then
            for k, v in pairs(AmrDb.Reps) do
                noreps = false
                table.insert(reps, k .. ":" .. v)
            end
        end
        if noreps then
            table.insert(reps, "_")
        end
        
        table.insert(fields, ".r")
        table.insert(fields, table.concat(reps, ","))    
    
        -- export bag and bank
        local itemObjects = {}
    	if AmrDb.BagItems then
	        for i, v in ipairs(AmrDb.BagItems) do
	            local itemData = AskMrRobot.parseItemLink(v)
	            if itemData ~= nil then
	                table.insert(itemObjects, itemData)
	            end
	        end
	    end
	    if AmrDb.BankItems then
	        for i, v in ipairs(AmrDb.BankItems) do
	            local itemData = AskMrRobot.parseItemLink(v)
	            if itemData ~= nil then
	                table.insert(itemObjects, itemData)
	            end
	        end
	    end
        
        table.insert(fields, ".inv")
        appendItemsToExport(fields, itemObjects)
    end

    return "$" .. table.concat(fields, ";") .. "$"
end

function AskMrRobot.ExportToAddonChat(timestamp)
    local msg = AskMrRobot.ExportToCompressedString(false)
    local msgPrefix = timestamp .. "\n" .. AmrRealmName .. "\n" .. AmrCharacterName .. "\n"
    
    -- break the data into 250 character chunks (to deal with the short limit on addon message size)
    local chunks = {}
    local i = 1
    local length = string.len(msg)
    local chunkLen = 249 - string.len(msgPrefix)
    while (i <= length) do
        local endpos = math.min(i + chunkLen, length)
        table.insert(chunks, msgPrefix .. string.sub(msg, i, endpos))
        i = endpos + 1
    end
    
    for i, v in ipairs(chunks) do
        SendAddonMessage(AskMrRobot.ChatPrefix, v, "RAID")
    end
    
    -- send a completion message
    SendAddonMessage(AskMrRobot.ChatPrefix, msgPrefix .. "done", "RAID")
end

-- Create an export string that can be copied to the website
function AskMrRobot.ExportToString()
    return AskMrRobot.ExportToCompressedString(true)
end


----------------------------------------------------------------------------
-- Import
----------------------------------------------------------------------------

-- imports will give us extra information about items, gems, and enchants
AskMrRobot.ExtraItemData = {}     -- keyed by item id
AskMrRobot.ExtraGemData = {}      -- keyed by gem enchant id
AskMrRobot.ExtraEnchantData = {}  -- keyed by enchant id

-- the data that was last imported
AskMrRobot.ImportData = nil       -- keyed by slot id

local MIN_IMPORT_VERSION = 2

--
-- Import a character, returning nil on success, otherwise an error message, import result stored in AskMrRobot.ImportData
--
function AskMrRobot.ImportCharacter(data)

    -- make sure all data is up to date before importing
    AskMrRobot.SaveAll()
    
    if data == nil or string.len(data) == 0 then
        return L.AMR_IMPORT_ERROR_EMPTY
    end
    
    local data1 = { strsplit("$", data) }
    if #data1 ~= 3 then
        return L.AMR_IMPORT_ERROR_FORMAT
    end
    
    local parts = { strsplit(";", data1[2]) }
    
    -- require a minimum version
    local ver = tonumber(parts[1])
    if ver < MIN_IMPORT_VERSION then
        return L.AMR_IMPORT_ERROR_VERSION
    end
    
    -- require realm/name match
    local realm = parts[2]
    local name = parts[3]
    if realm ~= AmrDb.RealmName or name ~= AmrDb.CharacterName then
        local badPers = name .. " (" .. realm .. ")"
        local goodPers = AmrDb.CharacterName .. " (" .. AmrDb.RealmName .. ")"
        return L.AMR_IMPORT_ERROR_CHAR:format(badPers, goodPers)
    end
    
    -- require race match
    local race = tonumber(parts[5])
    if race ~= AskMrRobot.raceIds[AmrDb.Race] then
        return L.AMR_IMPORT_ERROR_RACE
    end
    
    -- require faction match
    local faction = tonumber(parts[6])
    if faction ~= AskMrRobot.factionIds[AmrDb.Faction] then
        return L.AMR_IMPORT_ERROR_FACTION
    end
    
    -- require level match
    local level = tonumber(parts[7])
    if level ~= AmrDb.Level then
        return L.AMR_IMPORT_ERROR_LEVEL
    end

    -- require spec match
    local spec = tonumber(parts[11])
    if spec ~= AmrDb.Specs[AmrDb.ActiveSpec] then
        print(AmrDb.ActiveSpec)
        print(spec)
        print(AmrDb.Specs[AmrDb.ActiveSpec])
        local _, specName = GetSpecializationInfoByID(AskMrRobot.gameSpecIds[spec])
        return L.AMR_IMPORT_ERROR_SPEC:format(specName)
    end
    
    -- require talent match
    local talents = parts[12]
    if talents ~= AmrDb.Talents[AmrDb.ActiveSpec] then
        return L.AMR_IMPORT_ERROR_TALENT
    end
    
    -- require glyph match
    -- TODO: re-enable this check when glyphs are more consistent
    --local glyphs = parts[13]
    --if glyphs ~= AskMrRobot.toCompressedNumberList(AmrDb.Glyphs[AmrDb.ActiveSpec]) then
    --    return L.AMR_IMPORT_ERROR_GLYPH
    --end
    
    -- if we make it this far, the data is valid, so read item information
    local importData = {}

    local itemInfo = {}
    local gemInfo = {}
    local enchantInfo = {}
    
    local prevItemId = 0
    local prevGemId = 0
    local prevEnchantId = 0
    local prevUpgradeId = 0
    local prevBonusId = 0
    local digits = {
        ["-"] = true,
        ["0"] = true,
        ["1"] = true,
        ["2"] = true,
        ["3"] = true,
        ["4"] = true,
        ["5"] = true,
        ["6"] = true,
        ["7"] = true,
        ["8"] = true,
        ["9"] = true,
    }
    for i = 15, #parts do
        local itemString = parts[i]
        if itemString ~= "" and itemString ~= "_" then
            local tokens = {}
            local bonusIds = {}
            local hasBonuses = false
            local token = ""
            local prop = "i"
            local tokenComplete = false
            for j = 1, string.len(itemString) do
                local c = string.sub(itemString, j, j)
                if digits[c] == nil then
                    tokenComplete = true
                else
                    token = token .. c
                end
                
                if tokenComplete or j == string.len(itemString) then
                    local val = tonumber(token)
                    if prop == "i" then
                        val = val + prevItemId
                        prevItemId = val
                    elseif prop == "u" then
                        val = val + prevUpgradeId
                        prevUpgradeId = val
                    elseif prop == "b" then
                        val = val + prevBonusId
                        prevBonusId = val
                    elseif prop == "x" or prop == "y" or prop == "z" then
                        val = val + prevGemId
                        prevGemId = val
                    elseif prop == "e" then
                        val = val + prevEnchantId
                        prevEnchantId = val
                    end
                    
                    if prop == "b" then
                        table.insert(bonusIds, val)
                        hasBonuses = true
                    else
                        tokens[prop] = val
                    end
                    
                    token = ""
                    tokenComplete = false
                    
                    -- we have moved on to the next token
                    prop = c
                end
            end
            
            local obj = {}
            importData[tonumber(tokens["s"])] = obj
            
            obj.id = tokens["i"]
            obj.suffixId = tokens["f"] or 0
            obj.upgradeId = tokens["u"] or 0
            obj.enchantId = tokens["e"] or 0
            
            obj.gemIds = {}
            table.insert(obj.gemIds, tokens["x"] or 0)
            table.insert(obj.gemIds, tokens["y"] or 0)
            table.insert(obj.gemIds, tokens["z"] or 0)
            table.insert(obj.gemIds, 0)
            
            if hasBonuses then
                obj.bonusIds = bonusIds
            end
            
            local itemObj = {}
            itemObj.id = obj.id
            itemInfo[obj.id] = itemObj
            
            -- look for any socket color information, add to our extra data
            if tokens["c"] then
                itemObj.socketColors = {}
                for j = 1, string.len(tokens["c"]) do
                    table.insert(itemObj.socketColors, tonumber(string.sub(tokens["c"], j, j)))
                end
            end
            
            -- look for item ID duplicate info, deals with old SoO items
            if tokens["d"] then
                itemObj.duplicateId = tonumber(tokens["d"])
            end
            
        end
    end
    
    -- now read any extra display information
    parts = { strsplit("@", data1[3]) }
    for i = 1, #parts do
        local infoParts = { strsplit("\\", parts[i]) }
        
        if infoParts[1] == "g" then
        
            local gemObj = {}            
            gemObj.enchantId = tonumber(infoParts[2])
            gemObj.id = tonumber(infoParts[3])
            
            local identicalGems = infoParts[4]
            if string.len(identicalGems) > 0 then
                gemObj.identicalGroup = {}
                identicalGems = { strsplit(",", identicalGems) }
                for j = 1, #identicalGems do
                    gemObj.identicalGroup[tonumber(identicalGems[j])] = true
                end
            end
            
            gemObj.text = string.gsub(infoParts[5], "_(%a+)_", function(s) return L.AMR_STAT_SHORT_STRINGS[s] end)
            if infoParts[6] == nil or string.len(infoParts[6]) == 0 then
            	gemObj.identicalItemGroup = {[gemObj.id]=true}
            else
            	local identicalIds = { strsplit(',', infoParts[6]) }
            	gemObj.identicalItemGroup = {}
            	for j = 1, #identicalIds do
            		gemObj.identicalItemGroup[tonumber(identicalIds[j])] = true
            	end            	
            end            

            gemInfo[gemObj.enchantId] = gemObj
            
        elseif infoParts[1] == "e" then
        
            local enchObj = {}
            enchObj.id = tonumber(infoParts[2])
            enchObj.itemId = tonumber(infoParts[3])
            enchObj.spellId = tonumber(infoParts[4])
            enchObj.text = string.gsub(infoParts[5], "_(%a+)_", function(s) return L.AMR_STAT_SHORT_STRINGS[s] end)
            
            local mats = infoParts[6]
            if string.len(mats) > 0 then
                enchObj.materials = {}
                mats = { strsplit(",", mats) }
                for j = 1, #mats do
                    local kv = { strsplit("=", mats[j]) }
                    enchObj.materials[tonumber(kv[1])] = tonumber(kv[2])
                end
            end
            
            enchantInfo[enchObj.id] = enchObj
            
        end
    end
    
    -- we have succeeded, record the result
    AskMrRobot.ImportData = importData
    AskMrRobot.ExtraItemData = itemInfo
    AskMrRobot.ExtraGemData = gemInfo
    AskMrRobot.ExtraEnchantData = enchantInfo    
    
    AmrDb.LastCharacterImport = data
    AmrDb.LastCharacterImportDate = date()    
end
