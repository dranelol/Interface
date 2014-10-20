local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the GearComparisonTab class
AskMrRobot.GearComparisonTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- stores the results of the last gear comparison
AskMrRobot.ComparisonResult = {
    items = {},
    gems = {},
    enchants = {}
}

local function createTabButton(tab, text, index)
    local button = CreateFrame("Button", "GearComparisonTab" .. index, tab, "TabButtonTemplate")
    if  index == 1 then
        button:SetPoint("TOPLEFT")
    else
        button:SetPoint("LEFT", "GearComparisonTab" .. (index - 1), "RIGHT")
    end
    
    button:SetText(text)
    button:SetWidth(50)
    button:SetHeight(20)
    button:SetID(index)
    button:SetScript("OnClick", AskMrRobot.GearComparisonTab.tabButtonClick)
    return button
end

function AskMrRobot.GearComparisonTab:tabButtonClick()
    local tab = self:GetParent()
    local id = self:GetID()
    PanelTemplates_SetTab(tab, id)
    for i = 1, #tab.tabs do
        local t = tab.tabs[i]
        if t:GetID() == id then
            t:Show()
        else
            t:Hide()
        end
    end
end

function AskMrRobot.GearComparisonTab:new(parent)

	local tab = AskMrRobot.Frame:new("GearComparison", parent)	
	setmetatable(tab, { __index = AskMrRobot.GearComparisonTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()
    
    tab.initialized = false

    tab.tabButtons = {
        createTabButton(tab, L.AMR_UI_BUTTON_IMPORT, 1),
        createTabButton(tab, L.AMR_UI_BUTTON_SUMMARY, 2),
        createTabButton(tab, L.AMR_UI_BUTTON_GEMS, 3),
        createTabButton(tab, L.AMR_UI_BUTTON_ENCHANTS, 4),
        createTabButton(tab, L.AMR_UI_BUTTON_SHOPPING_LIST, 5)
    }

    PanelTemplates_SetNumTabs(tab, 5)
    PanelTemplates_SetTab(tab, 1)
    for i = 1, #tab.tabButtons do
        PanelTemplates_TabResize(tab.tabButtons[i], 0)
    end
   
    PanelTemplates_DisableTab(tab, 2)
    PanelTemplates_DisableTab(tab, 3)
    PanelTemplates_DisableTab(tab, 4)
    PanelTemplates_DisableTab(tab, 5)

    -- create the import tab
    tab.importTab = AskMrRobot.ImportTab:new(tab)
    tab.importTab:SetID(1)

    -- set the tab left of the tab
    tab.importTab:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -30)

    tab.summaryTab = AskMrRobot.SummaryTab:new(tab)
    tab.summaryTab:SetID(2)
    tab.summaryTab:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -30)

    tab.gemTab = AskMrRobot.GemTab:new(tab)
    tab.gemTab:SetID(3)
    tab.gemTab:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -30)

    tab.enchantTab = AskMrRobot.EnchantTab:new(tab)
    tab.enchantTab:SetID(4)
    tab.enchantTab:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -30)

    tab.shoppingTab = AskMrRobot.ShoppingListTab:new(tab)
    tab.shoppingTab:SetID(5)
    tab.shoppingTab:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -30)

    tab.tabs = {tab.importTab, tab.summaryTab, tab.gemTab, tab.enchantTab, tab.shoppingTab}

    -- show the first tab
    tab.importTab:Show()

    -- setup the import button to run the import
    tab.importTab.button:SetScript("OnClick", function()
        tab:Import()
        tab.tabButtonClick(tab.tabButtons[2])
    end)
    
    tab:SetScript("OnShow", AskMrRobot.GearComparisonTab.OnShow)
    
    --tab:RegisterEvent("ITEM_PUSH")
    --tab:RegisterEvent("DELETE_ITEM_CONFIRM")
    tab:RegisterEvent("SOCKET_INFO_CLOSE")
    tab:RegisterEvent("SOCKET_INFO_UPDATE")
    tab:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    tab:RegisterEvent("BAG_UPDATE")

    tab:SetScript("OnEvent", AskMrRobot.GearComparisonTab.OnEvent)

	return tab
end

function AskMrRobot.GearComparisonTab:On_SOCKET_INFO_CLOSE()
    self:Import()
end

function AskMrRobot.GearComparisonTab:On_SOCKET_INFO_UPDATE()
    self:Import()
end

function AskMrRobot.GearComparisonTab:On_PLAYER_SPECIALIZATION_CHANGED()
    self:Import()
end

function AskMrRobot.GearComparisonTab:On_BAG_UPDATE()
    self:Import()
end

function AskMrRobot.GearComparisonTab:On_ITEM_PUSH()
    self:Import()
end

function AskMrRobot.GearComparisonTab:On_DELETE_ITEM_CONFIRM()
    self:Import()
end

function AskMrRobot.GearComparisonTab:OnShow()
    if not self.initialized then
        self.initialized = true

        -- on first show, load the last import
        if AmrDb.LastCharacterImport and AmrDb.LastCharacterImport ~= "" then
            self.importTab:SetImportText(AmrDb.LastCharacterImport)
            self:Import()
        else
            self:Update()
        end
    else
        self:Update()
    end        
end

function AskMrRobot.GearComparisonTab:Import()

    -- example string
    -- $2;Brill (EU);Yellowfive;Twisted Legion;11;2;90;7:600,9:600;1;s1;34;2123320;68164,47782,7833;q1;99195s7u493x4647y0c22e4823;1s3u0x0y0c11e90;6s10u0x0y0c11e-481;1s1u0x383y-383c41;3047s15u12x0c1e-8;3109s5u-12x0y0z0c112e445;55s8u12x0c1e-442;5371s16u0b450x0c1e18;1691s13u-14b-1;238s11u0b0x-60c3;28s2u0b0;21s6u2b0x60y0z0c130;29s14u0b0;1s9u-2b0e-30;62s12u0b0x0c1;95s17u2b0x0c1$g\4647\76697\76631,76697,83146\20 _CriticalStrike_@g\5030\95344\\Indomitable@g\4587\76636\76570,76636,83144\20 _CriticalStrike_@e\4823\83765\122388\19 _Strength_, 11 _CriticalStrike_\72163=1,76061=1@e\4913\87585\113047\20 _Strength_, 5 _CriticalStrike_\39354=1,79254=3@e\4432\74721\104419\11 _Strength_\74249=3,74250=1,74247=1@e\4424\74713\104404\12 _CriticalStrike_\74250=1@e\4869\85559\124091\9 _Stamina_\72120=4@e\4427\74716\104408\11 _CriticalStrike_\74249=2,74250=1@e\4445\74727\104440\Colossus\74247=3@e\4415\74704\104390\18 _Strength_\74248=3 
    
    local err = AskMrRobot.ImportCharacter(self.importTab:GetImportText())
    -- goto the summary tab
    self.summaryTab:showImportError(err)
    PanelTemplates_EnableTab(self, 2)
    if err then
        PanelTemplates_DisableTab(self, 3)
        PanelTemplates_DisableTab(self, 4)
        PanelTemplates_DisableTab(self, 5)
    else
        PanelTemplates_EnableTab(self, 3)
        PanelTemplates_EnableTab(self, 4)
        PanelTemplates_EnableTab(self, 5)
        self:Update()
    end
end

-- update the panel and state
function AskMrRobot.GearComparisonTab:Update()
    -- update the comparison
    if self.summaryTab then
        AskMrRobot.GearComparisonTab.Compare()   
        self.summaryTab:showBadItems()
        self.gemTab:Update()
        self.enchantTab:Update()
        self.shoppingTab:Update()
    end
end


-- Helper for checking for swapped items, returns a number indicating how different two items are (0 means the same, higher means more different)
local function countItemDifferences(item1, item2)
    if item1 == nil and item2 == nil then return 0 end
    
    -- different items (id + bonus ids + suffix, constitutes a different physical drop)
    if AskMrRobot.getItemUniqueId(item1, true) ~= AskMrRobot.getItemUniqueId(item2, true) then
        if item1 == nil or item2 == nil then return 1000 end        
        -- do a check to deal with SoO item variants, see if we have duplicate ID information
        local info = AskMrRobot.ExtraItemData[item2.id]
        if info == nil then
            info = AskMrRobot.ExtraItemData[item1.id]
            if info == nil or info.duplicateId ~= item2.id then
                return 1000
            end
        elseif info.duplicateId ~= item1.id then
            return 1000
        end
    end
    
    -- different upgrade levels of the same item (only for older gear, player has control over upgrade level)
    if item1.upgradeId ~= item2.upgradeId then
        return 100
    end
    
    -- different gems
    local gemDiffs = 0
    for i = 1, 3 do
        if item1.gemIds[i] ~= item2.gemIds[i] then
            gemDiffs = gemDiffs + 1
        end
    end
    
    local enchantDiff = 0
    if item1.enchantId ~= item2.enchantId then
        enchantDiff = 1
    end
    
    return gemDiffs + enchantDiff
end

function AskMrRobot.GearComparisonTab:OnEvent(event, ...)
    local handler = self["On_" .. event]
    if handler then
        handler(self, ...)
    end
end

-- modifies data2 such that differences between data1 and data2 in the two specified slots is the smallest
local function checkSwappedItems(data1, data2, slot1, slot2)
    local diff = countItemDifferences(data1[slot1], data2[slot1]) + countItemDifferences(data1[slot2], data2[slot2])
    local swappedDiff
    if diff > 0 then
        swappedDiff = countItemDifferences(data1[slot1], data2[slot2]) + countItemDifferences(data1[slot2], data2[slot1])
        if swappedDiff < diff then
            local temp = data2[slot1]
            data2[slot1] = data2[slot2]
            data2[slot2] = temp
        end
    end
end

-- compare the last import data to the player's current state
function AskMrRobot.GearComparisonTab.Compare()
    if not AskMrRobot.ImportData then return end
    
    AskMrRobot.SaveAll()
    
    -- first parse the player's equipped gear into item objects
    local equipped = {}
    for k, v in pairs(AmrDb.Equipped[AmrDb.ActiveSpec]) do
        equipped[k] = AskMrRobot.parseItemLink(v)
    end
    
    -- swap finger/trinket in AskMrRobot.ImportData such that the number of differences is the smallest
    checkSwappedItems(equipped, AskMrRobot.ImportData, INVSLOT_FINGER1, INVSLOT_FINGER2)
    checkSwappedItems(equipped, AskMrRobot.ImportData, INVSLOT_TRINKET1, INVSLOT_TRINKET2)
    
    -- clear previous comparison result
    AskMrRobot.ComparisonResult = {
        items = {},
        gems = {},
        enchants = {}
    }
    
    local result = {
        items = {},
        gems = {},
        enchants = {}
    }
    
    -- determine specific differences
    for i,slotId in ipairs(AskMrRobot.slotIds) do
        local itemEquipped = equipped[slotId]
        local itemImported = AskMrRobot.ImportData[slotId]
        
        local itemsDifferent = AskMrRobot.getItemUniqueId(itemEquipped) ~= AskMrRobot.getItemUniqueId(itemImported)
        if itemsDifferent and itemEquipped ~= nil and itemImported ~= nil then
            -- do an extra check for old versions of SoO items, our server code always converts to new, equivalent version, but need to check backwards for the addon
            local info = AskMrRobot.ExtraItemData[itemImported.id]            
            if info and info.duplicateId == itemEquipped.id then
                itemsDifferent = false
            end
        end
        
        if itemsDifferent then
            -- the items are different
            local needsUpgrade = false
            if itemEquipped and itemImported and itemEquipped.id == itemImported.id and itemImported.upgradeId > itemEquipped.upgradeId then
                needsUpgrade = true
            end
            result.items[slotId] = {
                current = itemEquipped,
                optimized = itemImported,
                needsUpgrade = needsUpgrade
            }
        elseif itemEquipped then
            if AskMrRobot.ExtraItemData[itemEquipped.id] and AskMrRobot.ExtraItemData[itemEquipped.id].socketColors then
            -- items are same, check for gem/enchant differences
            --   NOTE: we used to do a bunch of fancy gem checks, but we can ditch all that logic b/c WoD gems are much simpler (no socket bonuses, gem/socket colors to worry about)
                local hasBadGems = false
                for g = 1, #AskMrRobot.ExtraItemData[itemEquipped.id].socketColors do
                    if not AskMrRobot.AreGemsCompatible(itemEquipped.gemIds[g], itemImported.gemIds[g]) then
                        hasBadGems = true
                        break
                    end
                end

                if hasBadGems then
                    result.gems[slotId] = {                    
                        current = {},
                        optimized = {}
                    }

                    for g = 1, #AskMrRobot.ExtraItemData[itemEquipped.id].socketColors do
                        result.gems[slotId].current[g] = itemEquipped.gemIds[g]
                        result.gems[slotId].optimized[g] = itemImported.gemIds[g]
                    end
                end
            end
            
            if itemEquipped.enchantId ~= itemImported.enchantId then
                result.enchants[slotId] = {
                    current = itemEquipped.enchantId,
                    optimized = itemImported.enchantId
                }
            end
        end
    end
    
    -- only set the new result if it is completely successful
    AskMrRobot.ComparisonResult = result
end

-- checks our extra gem information to see if the two gems are functionally equivalent
function AskMrRobot.AreGemsCompatible(gemId1, gemId2)
    if gemId1 == gemId2 then return true end
    
    -- see if we have extra gem information
    local extraInfo = AskMrRobot.ExtraGemData[gemId1]
    if not extraInfo then
        extraInfo = AskMrRobot.ExtraGemData[gemId2]
    end
    if extraInfo == nil or extraInfo.identicalGroup == nil then return false end
    
    -- if identicalGroup contains both gem ids, they are equivalent
    return extraInfo.identicalGroup[gemId1] and extraInfo.identicalGroup[gemId2]
end