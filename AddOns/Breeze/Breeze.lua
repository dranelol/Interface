local frame = CreateFrame("Frame")

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("GARRISON_MISSION_FINISHED")
frame:RegisterEvent("GARRISON_MISSION_COMPLETE")

function init(self, event, arg1, ...)

  if event == "ADDON_LOADED" and arg1 == "Blizzard_GarrisonUI" then
    -- print("Addon loaded: " .. arg1)
    
    Orig_Initialize = GarrisonMissionComplete_BeginAnims;
    GarrisonMissionComplete_BeginAnims = function(...)
        local self = ...
        self.NextMissionButton:Disable();
        self.BonusRewards.ChestModel.OpenAnim:Stop();
        self.BonusRewards.ChestModel.LockBurstAnim:Stop();
        self.BonusRewards.ChestModel:SetAlpha(1);
        for i = 1, #self.BonusRewards.Rewards do
            self.BonusRewards.Rewards[i]:Hide();
        end
        self.BonusRewards.ChestModel.LockBurstAnim:Stop();
        self.ChanceFrame.SuccessAnim:Stop();
        self.ChanceFrame.FailureAnim:Stop();
		self.BonusRewards.Saturated:Show();
		self.BonusRewards.ChestModel.Lock:Hide();
		self.BonusRewards.ChestModel:SetAnimation(0, 0);
		self.BonusRewards.ChestModel.ClickFrame:Show();
		self.ChanceFrame.ChanceText:SetAlpha(0);
		self.ChanceFrame.FailureText:SetAlpha(0);
		self.ChanceFrame.SuccessText:SetAlpha(1);
		self.ChanceFrame.Banner:SetAlpha(1);
		self.ChanceFrame.Banner:SetWidth(GARRISON_MISSION_COMPLETE_BANNER_WIDTH);
        
        self.encounterIndex = 1;
        self.animIndex = animIndex or 0;
        self.animTimeLeft = 0;
        self:SetScript("OnUpdate", GarrisonMissionComplete_OnUpdate);
        
    end
    
    GARRISON_ANIMATION_LENGTH = 0;

    local Or_GarrisonMissionComplete_AnimLine = GarrisonMissionComplete_AnimLine;
    GarrisonMissionComplete_AnimLine = function(...)
        GarrisonMissionComplete_PreloadEncounterModels(self);
     
        local iconWidth = 64;           -- size of portrait icon
        local iconEdgeSpace = 6;        -- empty space on either side of the portrait
        local lineAnimDuration = 0;  -- total time for line to animate from one end to another
        local modelWaitTime = 0;        -- extra time to wait for models to load
         
        local encounters = self.Stage.Encounters;
        local lineStart = encounters.EncounterBarFill:GetLeft();
        local lineEnd = encounters["Encounter"..self.encounterIndex]:GetLeft() + iconEdgeSpace;
        local duration = lineAnimDuration / #self.animInfo;
        entry.duration = duration;
        local barFill = encounters.EncounterBarFill;
        barFill.finalWidth = lineEnd - lineStart;
        barFill:SetWidth(barFill:GetWidth() + iconWidth - iconEdgeSpace * 2);
        local barSpark = encounters.EncounterBarSpark;
        barSpark.Anim.Translation:SetDuration(duration);
        barSpark.Anim.Translation:SetOffset(barFill.finalWidth - barFill:GetWidth(), 0);
        barSpark:Show();
    end

    local Orig_GarrisonMissionComplete_OpenChest = GarrisonMissionComplete_OpenChest;
function GarrisonMissionComplete_OpenChest(self)
    if ( C_Garrison.CanOpenMissionChest(GarrisonMissionFrame.MissionComplete.currentMission.missionID) ) then
        -- hide the click frame
        self:Hide();
 
        local bonusRewards = GarrisonMissionFrame.MissionComplete.BonusRewards;
        bonusRewards.waitForEvent = false;
        bonusRewards.waitForTimer = false;
        bonusRewards:RegisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE");
        bonusRewards.ChestModel:SetAnimation(154);
        bonusRewards.ChestModel.OpenAnim:Play();
        C_Timer.After(1.1, GarrisonMissionComplete_OnRewardTimer);
        C_Garrison.MissionBonusRoll(GarrisonMissionFrame.MissionComplete.currentMission.missionID);
        PlaySoundKitID(43504);      -- chest opened
    end
end
    
  elseif event == "GARRISON_MISSION_FINISHED" then
    -- print("A mission has completed!")
       
    local completeMissions = C_Garrison.GetCompleteMissions();
    
    if ( #completeMissions > 0 ) then
        -- print("We actually have missions completed!")
        C_Garrison.MarkMissionComplete(completeMissions[1].missionID)
        completeMissions[1].state = 0 
    end
    
  else
    -- print("Event triggered: " .. event)
  end
   
end

frame:SetScript("OnEvent", init)