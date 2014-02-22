
local l_cachedLinks = {};


UIPanelWindows["InspectFrame"].whileDead = true;
InspectFrame:SetScript("OnUpdate", nil);




local function l_CacheData(linksTable, unit)
	local GetInventoryItemLink = GetInventoryItemLink;
	for index = 1, 19, 1 do
		linksTable[index] = GetInventoryItemLink(unit, index);
	end
end




do
	local l_orig_InspectFrame_Show = InspectFrame_Show;
	
	InspectFrame_Show = function(unit)
		l_orig_InspectFrame_Show(unit);
		
		if (CanInspect(unit) ~= nil) then
			l_CacheData(l_cachedLinks, unit);
		end
	end
end



do
	local l_orig_InspectFrame_OnEvent = InspectFrame_OnEvent;
	
	InspectFrame_OnEvent = function(self, event, ...)
		if (self:IsShown() == nil) then
			return;
		end
		
		if (event == "PLAYER_TARGET_CHANGED" or event == "PARTY_MEMBERS_CHANGED") then
			if (
				(event == "PLAYER_TARGET_CHANGED" and self.unit == "target")
				or (event == "PARTY_MEMBERS_CHANGED" and self.unit ~= "target")
			) then
				if (CanInspect(self.unit) ~= nil) then
					InspectFrame_UnitChanged(self);
				else
					-- If we can't inspect, but the unit exists, then close the window.
					if (UnitExists(self.unit) ~= nil) then
						HideUIPanel(self);
					end
				end
			end
		else
			l_orig_InspectFrame_OnEvent(self, event, ...);
		end
	end
end



do
	local l_orig_InspectFrame_UnitChanged = InspectFrame_UnitChanged;
	
	InspectFrame_UnitChanged = function(self)
		l_orig_InspectFrame_UnitChanged(self);
		l_CacheData(l_cachedLinks, self.unit);
	end
end



do
	local l_orig_InspectPaperDollFrame_OnShow = InspectPaperDollFrame_OnShow;
	
	InspectPaperDollFrame_OnShow = function()
		if (CanInspect(InspectFrame.unit) ~= nil) then
			l_orig_InspectPaperDollFrame_OnShow();
		end
	end
end



do
	local replacement = function(self)
		local ID = self:GetID();
		local link = (GetInventoryItemLink(InspectFrame.unit, ID) or l_cachedLinks[ID]);
		if (link ~= nil) then
			HandleModifiedItemClick(link);
		end
	end
	InspectHeadSlot:SetScript("OnClick", replacement);
	InspectNeckSlot:SetScript("OnClick", replacement);
	InspectShoulderSlot:SetScript("OnClick", replacement);
	InspectBackSlot:SetScript("OnClick", replacement);
	InspectChestSlot:SetScript("OnClick", replacement);
	InspectShirtSlot:SetScript("OnClick", replacement);
	InspectTabardSlot:SetScript("OnClick", replacement);
	InspectWristSlot:SetScript("OnClick", replacement);
	InspectHandsSlot:SetScript("OnClick", replacement);
	InspectWaistSlot:SetScript("OnClick", replacement);
	InspectLegsSlot:SetScript("OnClick", replacement);
	InspectFeetSlot:SetScript("OnClick", replacement);
	InspectFinger0Slot:SetScript("OnClick", replacement);
	InspectFinger1Slot:SetScript("OnClick", replacement);
	InspectTrinket0Slot:SetScript("OnClick", replacement);
	InspectTrinket1Slot:SetScript("OnClick", replacement);
	InspectMainHandSlot:SetScript("OnClick", replacement);
	InspectSecondaryHandSlot:SetScript("OnClick", replacement);
	InspectRangedSlot:SetScript("OnClick", replacement);
end



do
	local _G = _G;
	local InspectFrame = InspectFrame;
	local GameTooltip = GameTooltip;
	
	InspectPaperDollItemSlotButton_OnEnter = function(self)
		local unit = InspectFrame.unit;
		local invID = self:GetID();
		
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		
		if (GameTooltip:SetInventoryItem(unit, invID) == nil) then
			local link = l_cachedLinks[invID];
			if (link ~= nil) then
				GameTooltip:SetHyperlink(link:match("item:[^|]+", 13));
			else
				local text;
				if (self.checkRelic == nil or UnitHasRelicSlot(unit) == nil) then
					text = _G[self:GetName():sub(8, -1):upper()];
				else
					text = RELICSLOT;
				end
				GameTooltip:SetText(text);
			end
		end
		
		CursorUpdate(self);
	end
end
