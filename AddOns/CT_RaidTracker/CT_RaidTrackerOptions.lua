function CT_RaidTracker_OptionsFrame_OnShow()
    CT_RaidTrackerOptionsFrameMinQualitySlider:SetValue(CT_RaidTracker_Options["MinQuality"]);
    CT_RaidTrackerOptionsFrameAskCostSlider:SetValue(CT_RaidTracker_Options["AskCost"]);
    CT_RaidTrackerOptionsFrameGetDKPValueSlider:SetValue(CT_RaidTracker_Options["GetDkpValue"]);
    CT_RaidTrackerOptionsFrameMinItemLevelSlider:SetValue(CT_RaidTracker_Options["MinItemLevel"]/1000);
    CT_RaidTrackerOptionsFrameAutoCreateRaidCB:SetChecked(CT_RaidTracker_Options["AutoRaidCreation"]);
    CT_RaidTrackerOptionsFrameMinPlayerSlider:SetValue((CT_RaidTracker_Options["MinPlayer"]+1)/1000);
    CT_RaidTrackerOptionsFrameLogGroupCB:SetChecked(CT_RaidTracker_Options["LogGroup"]);
    CT_RaidTrackerOptionsFrameAutoGroupCB:SetChecked(CT_RaidTracker_Options["AutoGroup"]);
    CT_RaidTrackerOptionsFrameLogBattlefieldCB:SetChecked(CT_RaidTracker_Options["LogBattlefield"]);
    CT_RaidTrackerOptionsFrameAskWipeCB:SetChecked(CT_RaidTracker_Options["Wipe"]);
    CT_RaidTrackerOptionsFrameAskWipeSlider:SetValue(CT_RaidTracker_Options["WipePercent"]);
    CT_RaidTrackerOptionsFrameAskNextBossCB:SetChecked(CT_RaidTracker_Options["NextBoss"]);
    CT_RaidTrackerOptionsFrameGroupItemsSlider:SetValue(CT_RaidTracker_Options["GroupItems"]);
    CT_RaidTrackerOptionsFrameAutoZoneCB:SetChecked(CT_RaidTracker_Options["AutoZone"]);
    CT_RaidTrackerOptionsFrameNewRaidOnNewZoneCB:SetChecked(CT_RaidTracker_Options["NewRaidOnNewZone"]);
    CT_RaidTrackerOptionsFrameSaveExtendedPlayerInfoCB:SetChecked(CT_RaidTracker_Options["SaveExtendedPlayerInfo"]);
    CT_RaidTrackerOptionsFrameSaveTooltipsCB:SetChecked(CT_RaidTracker_Options["SaveTooltips"]);
    CT_RaidTrackerOptionsFrameAutoBossSlider:SetValue(CT_RaidTracker_Options["AutoBoss"]);
    CT_RaidTrackerOptionsFrameAutoBossChangeMinTimeSlider:SetValue(CT_RaidTracker_Options["AutoBossChangeMinTime"]/1000);
    CT_RaidTrackerOptionsFrameNewRaidOnBossKillCB:SetChecked(CT_RaidTracker_Options["NewRaidOnBossKill"]);
    CT_RaidTrackerOptionsFrameLogAttendeesSlider:SetValue(CT_RaidTracker_Options["LogAttendees"]);
    CT_RaidTrackerOptionsFrameWhisperLogTextBox:SetText(CT_RaidTracker_Options["WhisperLog"]);
    CT_RaidTrackerOptionsFrameTimeSyncCB:SetChecked(CT_RaidTracker_Options["TimeSync"]);
    CT_RaidTrackerOptionsFrameTimeZoneSlider:SetValue(CT_RaidTracker_Options["Timezone"]);
    CT_RaidTrackerOptionsFrameUse24hFormat:SetChecked(CT_RaidTracker_Options["24hFormat"]);
    CT_RaidTrackerOptionsFrameMaxLevelSlider:SetValue(CT_RaidTracker_Options["MaxLevel"]);
    CT_RaidTrackerOptionsFrameGuildSnapshotCB:SetChecked(CT_RaidTracker_Options["GuildSnapshot"]);
    CT_RaidTrackerOptionsFrameExportFormatSlider:SetValue(CT_RaidTracker_Options["ExportFormat"]);
end

function CT_RaidTracker_OptionsFrame_Save()
    CT_RaidTracker_Options["MinQuality"] = CT_RaidTrackerOptionsFrameMinQualitySlider:GetValue();
    CT_RaidTracker_Options["AskCost"] = CT_RaidTrackerOptionsFrameAskCostSlider:GetValue();
    CT_RaidTracker_Options["GetDkpValue"] = CT_RaidTrackerOptionsFrameGetDKPValueSlider:GetValue();
    CT_RaidTracker_Options["MinItemLevel"] = CT_RaidTrackerOptionsFrameMinItemLevelSlider:GetValue()*1000;
    
    if(CT_RaidTrackerOptionsFrameAutoCreateRaidCB:GetChecked() == 1) then
        CT_RaidTracker_Options["AutoRaidCreation"] = 1;
    else
        CT_RaidTracker_Options["AutoRaidCreation"] = 0;
    end
    CT_RaidTracker_Options["MinPlayer"] = (CT_RaidTrackerOptionsFrameMinPlayerSlider:GetValue()*1000)-1;
    if(CT_RaidTrackerOptionsFrameLogGroupCB:GetChecked() == 1) then
        CT_RaidTracker_Options["LogGroup"] = 1;
    else
        CT_RaidTracker_Options["LogGroup"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameAutoGroupCB:GetChecked() == 1) then
        CT_RaidTracker_Options["AutoGroup"] = 1;
    else
        CT_RaidTracker_Options["AutoGroup"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameLogBattlefieldCB:GetChecked() == 1) then
        CT_RaidTracker_Options["LogBattlefield"] = 1;
    else
        CT_RaidTracker_Options["LogBattlefield"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameAskWipeCB:GetChecked() == 1) then
        CT_RaidTracker_Options["Wipe"] = 1;
    else
        CT_RaidTracker_Options["Wipe"] = 0;
    end
    CT_RaidTracker_Options["WipePercent"] = CT_RaidTrackerOptionsFrameAskWipeSlider:GetValue();
    if(CT_RaidTrackerOptionsFrameAskNextBossCB:GetChecked() == 1) then
        CT_RaidTracker_Options["NextBoss"] = 1;
    else
        CT_RaidTracker_Options["NextBoss"] = 0;
    end
    CT_RaidTracker_Options["GroupItems"] = CT_RaidTrackerOptionsFrameGroupItemsSlider:GetValue();
    if(CT_RaidTrackerOptionsFrameAutoZoneCB:GetChecked() == 1) then
        CT_RaidTracker_Options["AutoZone"] = 1;
    else
        CT_RaidTracker_Options["AutoZone"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameNewRaidOnNewZoneCB:GetChecked() == 1) then
        CT_RaidTracker_Options["NewRaidOnNewZone"] = 1;
    else
        CT_RaidTracker_Options["NewRaidOnNewZone"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameSaveExtendedPlayerInfoCB:GetChecked() == 1) then
        CT_RaidTracker_Options["SaveExtendedPlayerInfo"] = 1;
    else
        CT_RaidTracker_Options["SaveExtendedPlayerInfo"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameSaveTooltipsCB:GetChecked() == 1) then
        CT_RaidTracker_Options["SaveTooltips"] = 1;
    else
        CT_RaidTracker_Options["SaveTooltips"] = 0;
    end
    CT_RaidTracker_Options["AutoBoss"] = CT_RaidTrackerOptionsFrameAutoBossSlider:GetValue();
    CT_RaidTracker_Options["AutoBossChangeMinTime"] = CT_RaidTrackerOptionsFrameAutoBossChangeMinTimeSlider:GetValue()*1000;
    if(CT_RaidTrackerOptionsFrameNewRaidOnBossKillCB:GetChecked() == 1) then
        CT_RaidTracker_Options["NewRaidOnBossKill"] = 1;
    else
        CT_RaidTracker_Options["NewRaidOnBossKill"] = 0;
    end
    
    CT_RaidTracker_Options["LogAttendees"] = CT_RaidTrackerOptionsFrameLogAttendeesSlider:GetValue();
    CT_RaidTracker_Options["WhisperLog"] = CT_RaidTrackerOptionsFrameWhisperLogTextBox:GetText();
    
    if(CT_RaidTrackerOptionsFrameTimeSyncCB:GetChecked() == 1) then
        CT_RaidTracker_Options["TimeSync"] = 1;
    else
        CT_RaidTracker_Options["TimeSync"] = 0;
    end
    if(CT_RaidTrackerOptionsFrameUse24hFormat:GetChecked() == 1) then
        CT_RaidTracker_Options["24hFormat"] = 1;
    else
        CT_RaidTracker_Options["24hFormat"] = 0;
    end
    CT_RaidTracker_Options["Timezone"] = CT_RaidTrackerOptionsFrameTimeZoneSlider:GetValue();
    CT_RaidTracker_GetGameTimeOffset();
    CT_RaidTracker_Options["MaxLevel"] = CT_RaidTrackerOptionsFrameMaxLevelSlider:GetValue();
    if(CT_RaidTrackerOptionsFrameGuildSnapshotCB:GetChecked() == 1) then
        CT_RaidTracker_Options["GuildSnapshot"] = 1;
    else
        CT_RaidTracker_Options["GuildSnapshot"] = 0;
    end
    CT_RaidTracker_Options["ExportFormat"] = CT_RaidTrackerOptionsFrameExportFormatSlider:GetValue();
end
