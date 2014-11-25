-- Relevant Events
-- GARRISON_MISSION_COMPLETE_RESPONSE: missionID, requestCompleted, succeeded; happens after C_Garrison.MarkMissionComplete
-- GARRISON_FOLLOWER_XP_CHANGED: followerID, xpGained, xpToNextLevel?, newLevel?, quality?
-- GARRISON_MISSION_BONUS_ROLL_COMPLETE: missionID, requestCompleted; happens after C_Garrison.MissionBonusRoll

-- Useful functions
-- local location, xp, environment, environmentDesc, environmentTexture, locPrefix, isExhausting, enemies = C_Garrison.GetMissionInfo(missionInfo.missionID)
-- good for base xp from 2nd arg and the isExhausting arg (can't find either in rewards output for completed missions)
-- local totalTimeString, totalTimeSeconds, isMissionTimeImproved, successChance, partyBuffs, isEnvMechanicCountered, xpBonus, materialMultiplier = C_Garrison.GetPartyMissionInfo(MISSION_PAGE_FRAME.missionInfo.missionID);
-- good for getting successChance and xpBonus (what does this mean exactly?) and maybe materialMultiplier (same question)

--local quality = C_Garrison.GetFollowerQuality(self.data);
--local name = ITEM_QUALITY_COLORS[quality].hex .. C_Garrison.GetFollowerName(self.data) .. FONT_COLOR_CODE_CLOSE;

-- Success is marked by arg3 of GARRISON_MISSION_COMPLETE_RESPONSE
-- Rewards are in a table called 'rewards'
-- If it is Currency, the title is "Currency Reward". Other useful fields are currencyID and quantity.
-- If it is Money, the title is "Money Reward". currencyID is always 0. Quantity is (example) 475000. Icon is another field but not useful.
-- If it is an Item, there is no title. Useful fields are itemID and quantity.
-- If it is XP, the title is "Bonus Follower XP". Useful fields are followerXP, which is (example) 300. Other fields are icon, name, and tooltip.

-- Localized data
local next = _G.next
local format = _G.string.format
local tostring = _G.tostring
local C_Garrison = _G.C_Garrison
local NewTicker = _G.C_Timer.NewTicker
local GARRISON_CURRENCY = _G.GARRISON_CURRENCY
local GetMoneyString = _G.GetMoneyString
local GetCurrencyLink = _G.GetCurrencyLink
local GetItemInfo = _G.GetItemInfo

-- Addon-wide variables
local missions, mission_index, timer, manage_missions

-- Saved variable defaults
MC_Variables = {
    DEBUGGING = false,
    UPDATE_FREQUENCY = (1/10),
}

local function MCDebug(...)
    if MC_Variables.DEBUGGING then
        print("MissionComplete:", ...)
    end
end

local function RestoreMissionUI()
    if not manage_missions then return end

    -- Hide Blizzard UI
    GarrisonMissionFrame.MissionTab.MissionList.CompleteDialog:Hide()
    GarrisonMissionFrame.MissionComplete:Hide()
    GarrisonMissionFrame.MissionCompleteBackground:Hide()
    GarrisonMissionFrame.MissionComplete.currentIndex = nil
    GarrisonMissionFrame.MissionTab:Show()
    GarrisonMissionList_UpdateMissions()

    -- Re-enable "view" button
    GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SetEnabled(true)
end

local function AdvanceMissionStage()
    if not manage_missions then
        MCDebug("Cancelling timer; it is not time to handle missions.")

        -- Reset timer data
        timer:Cancel()
        timer = nil

        -- Reset mission data
        missions = nil
        mission_index = 1
        return
    end

    -- Send request to server based on known mission state
    if missions[mission_index] and missions[mission_index].state and (missions[mission_index].state < 0) then
        MCDebug("Sent mark mission complete request for missionID " .. missions[mission_index].missionID .. ", at index " .. mission_index .. ".")
        C_Garrison.MarkMissionComplete(missions[mission_index].missionID)
    elseif missions[mission_index] and missions[mission_index].state then
        MCDebug("Sent bonus roll request for missionID " .. missions[mission_index].missionID .. ", at index " .. mission_index .. ".")
        C_Garrison.MissionBonusRoll(missions[mission_index].missionID)
    else
        MCDebug("Cancelling timer; it had invalid data.")

        -- Reset timer data
        timer:Cancel()
        timer = nil

        -- Reset mission data
        missions = nil
        mission_index = 1
    end
end

local function SetUpAdvanceMissionStage()
    if not manage_missions then return end

    if timer then
        timer:Cancel()
        timer = nil
    end

    --MCDebug("Timer started!")
    timer = NewTicker(MC_Variables.UPDATE_FREQUENCY, AdvanceMissionStage, 10)
end

local function PrintCurrentMissionOutcome()
    if not manage_missions then return end

    -- Local shortcut
    local m = missions[mission_index]

    -- Set up strings
    local strMissionNumberName = format("Mission %d/%d", mission_index, #missions)
    local strIsRare = m.isRare and " (Rare): " or ": "
    local strName = format("%s (lvl %d", m.name, m.level)
    local strItemLevel = (not (m.iLevel == 0)) and tostring(m.iLevel) or ""
    local strSuccess = m.success and ") - Succeeded! " or ") - Failed! "
    local strXP = m.xp and ("Gained " .. m.xp .. " base XP. ") or ""
    local strRewards = ""

    -- Stringbuilder
    if m.success then
        -- Build rewards string
        strRewards = "Bonus Rewards: "
        local rewardCount = 0
        for x, y in next, m.rewards do
            if m.rewards[x].currencyID then
                if m.rewards[x].currencyID == 0 then
                    -- Money reward
                    strRewards = strRewards .. GetMoneyString(m.rewards[x].quantity) 
                elseif m.rewards[x].currencyID == GARRISON_CURRENCY then
                    -- Garrison currency reward (uses materialMultiplier)
                    strRewards = strRewards .. GetCurrencyLink(m.rewards[x].currencyID)  .. " x " .. tostring(m.rewards[x].quantity * m.materialMultiplier)
                else
                    -- Other currency reward
                    strRewards = strRewards .. GetCurrencyLink(m.rewards[x].currencyID)  .. " x " .. tostring(m.rewards[x].quantity)
                end
            elseif m.rewards[x].itemID then
                -- Item reward
                local _, link = GetItemInfo(m.rewards[x].itemID)
                strRewards = strRewards .. (link and tostring(link) or ("item ID " .. tostring(m.rewards[x].itemID))) .. " x " .. tostring(m.rewards[x].quantity)
            else
                -- Follower XP reward
                strRewards = strRewards .. tostring(m.rewards[x].followerXP) .. " follower XP"
            end

            -- Find out if we need to stop adding semicolons and spaces to the end
            rewardCount = rewardCount + 1
            if rewardCount < #m.rewards then
                strRewards = strRewards .. "; "
            end
        end
    end

    -- Output
    print(strMissionNumberName .. strIsRare .. strName .. strItemLevel .. strSuccess .. strXP .. strRewards)

    -- Increment to next mission (or restore UI because we're done)
    mission_index = mission_index + 1
    if (#missions < mission_index) then
        RestoreMissionUI()
    else
        SetUpAdvanceMissionStage()
    end
end

local function CompleteMissions()
    if not manage_missions then return end

    -- Block the view button from being active
    GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SetEnabled(false)

    -- Get standard completion data for the missions
    missions = nil
    missions = C_Garrison.GetCompleteMissions()
    mission_index = 1

    if missions and (#missions > 0) then

        -- Prevent taint from this loop statement
        local _
        for m_index, result_table in next, missions do
            -- Get general mission data
            _, missions[m_index].xp = C_Garrison.GetMissionInfo(missions[m_index].missionID)
            _, _, _, missions[m_index].successChance, _, _, missions[m_index].xpBonus, missions[m_index].materialMultiplier = C_Garrison.GetPartyMissionInfo(missions[m_index].missionID)
            MCDebug("Mission data for mission ID #" .. tostring(missions[m_index].missionID) .. ": ", missions[m_index].xp, missions[m_index].successChance, missions[m_index].xpBonus, missions[m_index].materialMultiplier)
        end

        -- Advance mission
        SetUpAdvanceMissionStage()
    end
end

local function MissionComplete_OnEvent(self, event, arg1, arg2, arg3)
    -- Hook function securely
    if event == "ADDON_LOADED" then
        -- Hook if Blizzard_GarrisonUI is already loaded
        if arg1 == "MissionComplete" then
            -- Set default saved variables for old installs
            if not MC_Variables then
                MC_Variables = {}
            end
            if not MC_Variables.UPDATE_FREQUENCY then
                MC_Variables.UPDATE_FREQUENCY = (1/10)
            end

            local _, _, _, loaded = GetAddOnInfo("Blizzard_GarrisonUI")
            if loaded then
                --GarrisonMissionFrame:UnregisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE")
                --GarrisonMissionFrame:UnregisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE")
                GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SetScript("OnClick", CompleteMissions)
                MissionCompleteFrame:UnregisterEvent("ADDON_LOADED")
            end
        -- Hook when Blizzard_GarrisonUI is loaded
        elseif arg1 == "Blizzard_GarrisonUI" then
            --GarrisonMissionFrame:UnregisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE")
            --GarrisonMissionFrame:UnregisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE")
            GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SetScript("OnClick", CompleteMissions)
            MissionCompleteFrame:UnregisterEvent("ADDON_LOADED")
        end
    elseif event == "GARRISON_MISSION_NPC_CLOSED" then
        manage_missions = false
    elseif event == "GARRISON_MISSION_NPC_OPENED" then
        manage_missions = true
    -- Record success
    elseif manage_missions and (event == "GARRISON_MISSION_COMPLETE_RESPONSE") then
        MCDebug(event, arg1, arg2, arg3)
        -- If the server returns a failure, try the request again
        if not arg2 then
            if not timer then
                SetUpAdvanceMissionStage()
            end
            return
        -- If we succeeded but we have a timer running...
        elseif timer then
            timer:Cancel()
            timer = nil
        end

        -- Store success so we can properly output rewards
        for m_index, result_table in next, missions do
            if arg1 == missions[m_index].missionID then
                missions[m_index].success = arg3
                break
            end
        end

        -- If we succeeded, do a bonus roll, otherwise show output
        if arg3 then
            missions[mission_index].state = 0
            SetUpAdvanceMissionStage()
        else
            PrintCurrentMissionOutcome()
        end
    elseif manage_missions and (event == "GARRISON_MISSION_BONUS_ROLL_COMPLETE") then
        MCDebug(event, arg1, arg2, arg3)

        -- If the server returns a failure, try the request again
        if not arg2 then
            if not timer then
                SetUpAdvanceMissionStage()
            end
            return
        -- If we succeeded but we have a timer running...
        elseif timer then
            timer:Cancel()
            timer = nil
        end

        PrintCurrentMissionOutcome()
    end
end

local MC_Frame = CreateFrame("Frame", "MissionCompleteFrame")
MC_Frame:SetScript("OnEvent", MissionComplete_OnEvent)
MC_Frame:RegisterEvent("ADDON_LOADED")
MC_Frame:RegisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE")
MC_Frame:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE")
MC_Frame:RegisterEvent("GARRISON_MISSION_NPC_CLOSED")
MC_Frame:RegisterEvent("GARRISON_MISSION_NPC_OPENED")
