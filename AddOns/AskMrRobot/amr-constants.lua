local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- item link format:  |cffa335ee|Hitem:itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:upgradeId:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2...|h[item name]|h|r

-- get an object with all of the parts fo the item link format that we care about
function AskMrRobot.parseItemLink(itemLink)
    if not itemLink then return nil end
    
    local str = string.match(itemLink, "|Hitem:([\-%d:]+)|")
    if not str then return nil end
    
    local parts = { strsplit(":", str) }
    
    local item = {}
    item.id = tonumber(parts[1])
    item.enchantId = tonumber(parts[2])
    item.gemIds = { tonumber(parts[3]), tonumber(parts[4]), tonumber(parts[5]), tonumber(parts[6]) }
    item.suffixId = math.abs(tonumber(parts[7])) -- convert suffix to positive number, that's what we use in our code
    --item.uniqueId = tonumber(parts[8])
    --item.level = tonumber(parts[9])
    item.upgradeId = tonumber(parts[10])
    --item.difficultyId = tonumber(parts[11])
    
    local numBonuses = tonumber(parts[12])
    if numBonuses > 0 then
        item.bonusIds = {}
        for i = 13, 12 + numBonuses do
            table.insert(item.bonusIds, tonumber(parts[i]))
        end
    end
    
    return item
end

-- convenience to get just the item id (or 0 if not a valid link) from an item link
function AskMrRobot.getItemIdFromLink(itemLink)
	if not itemLink then return 0 end
    local parts = { strsplit(":", itemLink) }
    local id = tonumber(parts[2])
	return (id and id ~= 0 and id or 0)
end

function AskMrRobot.getItemUniqueId(item, noUpgrade)
    if item == nil then return "" end
    local ret = item.id .. ""
    if item.bonusIds then
        for i = 1, #item.bonusIds do
            ret = ret .. "b" .. item.bonusIds[i]
        end
    end
    if item.suffixId ~= 0 then
        ret = ret .. "s" .. item.suffixId
    end
    if not noUpgrade and item.upgradeId ~= 0 then
        ret = ret .. "u" .. item.upgradeId
    end
    return ret
end

AskMrRobot.instanceIds = {
	HeartOfFear = 1009,
	MogushanVaults = 1008,	
	SiegeOfOrgrimmar = 1136,
	TerraceOfEndlessSpring = 996,
	ThroneOfThunder = 1098
}

-- instances that we currently support logging for
AskMrRobot.supportedInstanceIds = {
	[1136] = true
}

-- returns true if currently in a supported instance
function AskMrRobot.IsSupportedInstance()

	local zone, _, difficultyIndex, _, _, _, _, instanceMapID = GetInstanceInfo()
	if AskMrRobot.supportedInstanceIds[tonumber(instanceMapID)] then
		return true
	else
		return false
	end
end

AskMrRobot.classIds = {
    ["NONE"] = 0,
    ["DEATHKNIGHT"] = 1,
    ["DRUID"] = 2,
    ["HUNTER"] = 3,
    ["MAGE"] = 4,
    ["MONK"] = 5,
    ["PALADIN"] = 6,
    ["PRIEST"] = 7,
    ["ROGUE"] = 8,
    ["SHAMAN"] = 9,
    ["WARLOCK"] = 10,
    ["WARRIOR"] = 11,
}

AskMrRobot.professionIds = {
    ["None"] = 0,
    ["Mining"] = 1,
    ["Skinning"] = 2,
    ["Herbalism"] = 3,
    ["Enchanting"] = 4,
    ["Jewelcrafting"] = 5,
    ["Engineering"] = 6,
    ["Blacksmithing"] = 7,
    ["Leatherworking"] = 8,
    ["Inscription"] = 9,
    ["Tailoring"] = 10,
    ["Alchemy"] = 11,
    ["Fishing"] = 12,
    ["Cooking"] = 13,
    ["First Aid"] = 14,
    ["Archaeology"] = 15
}

AskMrRobot.raceIds = {
    ["None"] = 0,
    ["BloodElf"] = 1,
    ["Draenei"] = 2,
    ["Dwarf"] = 3,
    ["Gnome"] = 4,
    ["Human"] = 5,
    ["NightElf"] = 6,
    ["Orc"] = 7,
    ["Tauren"] = 8,
    ["Troll"] = 9,
    ["Scourge"] = 10,
    ["Undead"] = 10,
    ["Goblin"] = 11,
    ["Worgen"] = 12,
    ["Pandaren"] = 13
}

AskMrRobot.factionIds = {
    ["None"] = 0,
    ["Alliance"] = 1,
    ["Horde"] = 2
}

AskMrRobot.specIds = {
    [250] = 1, -- DeathKnightBlood
    [251] = 2, -- DeathKnightFrost
    [252] = 3, -- DeathKnightUnholy
    [102] = 4, -- DruidBalance
    [103] = 5, -- DruidFeral
    [104] = 6, -- DruidGuardian
    [105] = 7, -- DruidRestoration
    [253] = 8, -- HunterBeastMastery
    [254] = 9, -- HunterMarksmanship
    [255] = 10, -- HunterSurvival
    [62] = 11, -- MageArcane
    [63] = 12, -- MageFire
    [64] = 13, -- MageFrost
    [268] = 14, -- MonkBrewmaster
    [269] = 15, -- MonkMistweaver
    [270] = 16, -- MonkWindwalker
    [65] = 17, -- PaladinHoly
    [66] = 18, -- PaladinProtection
    [70] = 19, -- PaladinRetribution
    [256] = 20, -- PriestDiscipline
    [257] = 21, -- PriestHoly
    [258] = 22, -- PriestShadow
    [259] = 23, -- RogueAssassination
    [260] = 24, -- RogueCombat
    [261] = 25, -- RogueSubtlety
    [262] = 26, -- ShamanElemental
    [263] = 27, -- ShamanEnhancement
    [264] = 28, -- ShamanRestoration
    [265] = 29, -- WarlockAffliction
    [266] = 30, -- WarlockDemonology
    [267] = 31, -- WarlockDestruction
    [71] = 32, -- WarriorArms
    [72] = 33, -- WarriorFury
    [73] = 34 -- WarriorProtection
}

-- reverse map of our spec ID to the game's spec ID
AskMrRobot.gameSpecIds = {}
for k,v in pairs(AskMrRobot.specIds) do
    AskMrRobot.gameSpecIds[v] = k
end

-- lookup from our socket color ID to string
AskMrRobot.socketColorIds = {
    [0] = "Prismatic",
    [1] = "Red",
    [2] = "Yellow",
    [3] = "Blue",
    [4] = "Meta",
    [5] = "Cogwheel",
    [6] = "ShaTouched"
}

-- map of game slot names to slot IDs (same both in our code and in-game)
AskMrRobot.slotNameToId = {
    ["HeadSlot"] = 1, 
    ["NeckSlot"] = 2, 
    ["ShoulderSlot"] = 3, 
    ["ChestSlot"] = 5, 
    ["WaistSlot"] = 6, 
    ["LegsSlot"] = 7, 
    ["FeetSlot"] = 8, 
    ["WristSlot"] = 9, 
    ["HandsSlot"] = 10, 
    ["Finger0Slot"] = 11, 
    ["Finger1Slot"] = 12, 
    ["Trinket0Slot"] = 13, 
    ["Trinket1Slot"] = 14, 
    ["BackSlot"] = 15, 
    ["MainHandSlot"] = 16, 
    ["SecondaryHandSlot"] = 17
}

-- map of slot ID to display text
AskMrRobot.slotDisplayText = {
    [1] = _G["HEADSLOT"],
    [2] = _G["NECKSLOT"],
    [3] = _G["SHOULDERSLOT"],
    [5] = _G["CHESTSLOT"],
    [6] = _G["WAISTSLOT"],
    [7] = _G["LEGSSLOT"],
    [8] = _G["FEETSLOT"],
    [9] = _G["WROSTSLOT"],
    [10] = _G["HANDSSLOT"],
    [11] = _G["FINGER0SLOT"],
    [12] = _G["FINGER1SLOT"],
    [13] = _G["TRINKET0SLOT"],
    [14] = _G["TRINKET1SLOT"],
    [15] = _G["BACKSLOT"],
    [16] = _G["MAINHANDSLOT"],
    [17] = _G["SECONDARYHANDSLOT"]
}

-- all slot IDs that we care about, ordered in our standard display order
AskMrRobot.slotIds = { 16, 17, 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14 }

-- cache slot orders to make slot sorting easier
local _slotIdToOrder = {}
for i = 1, #AskMrRobot.slotIds do
    _slotIdToOrder[AskMrRobot.slotIds[i]] = i
end

-- given a table where the keys are slot IDs, sort in the standard slot order
function AskMrRobot.sortSlots(t)
    return AskMrRobot.spairs(t, function(x, a, b)
        if a == nil and b == nil then return 0 end
        return _slotIdToOrder[a] < _slotIdToOrder[b]
    end)
end
