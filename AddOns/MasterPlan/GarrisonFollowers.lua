local icons, _, T = {}, ...

local function Mechanic_OnEnter(self)
	local id, name = T.Garrison.GetMechanicInfo(self.id)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:AddLine(name)
	local ci, fi = T.Garrison.GetCounterInfo()[id], T.Garrison.GetFollowerInfo()
	if ci then
		GameTooltip:AddLine("Countered by:", 1,1,1)
		T.Garrison.sortByFollowerLevels(ci, fi)
		for i=1,#ci do
			GameTooltip:AddLine(T.Garrison.GetFollowerLevelDescription(ci[i], nil, fi[ci[i]]), 1,1,1)
		end
	else
		GameTooltip:AddLine("You have no followers to counter this mechanic.", 1,0.50,0)
	end
	GameTooltip:Show()
	
end
local function Mechanic_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function CreateMechanicFrame(parent)
	local f = CreateFrame("Button", nil, parent, "GarrisonAbilityCounterTemplate")
	f.Count = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
	f.Count:SetPoint("BOTTOMRIGHT", 0, 2)
	f.Border:Hide()
	f:SetScript("OnEnter", Mechanic_OnEnter)
	f:SetScript("OnLeave", Mechanic_OnLeave)
	return f
end
local function countFreeFollowers(f, finfo)
	local ret = 0
	for i=1,#f do
		local st = finfo[f[i]].status
		if not (st == GARRISON_FOLLOWER_INACTIVE or st == GARRISON_FOLLOWER_WORKING) then
			ret = ret + 1
		end
	end
	return ret
end

local function syncTotals()
	local finfo, i, ico = T.Garrison.GetFollowerInfo(), 1
	for k, f in pairs(T.Garrison.GetCounterInfo()) do
		ico = icons[i] or CreateMechanicFrame(GarrisonMissionFrame.FollowerTab)
		ico:SetPoint("LEFT", icons[i-1] or GarrisonMissionFrame.FollowerTab.NumFollowers, "RIGHT", i == 1 and 15 or 4, 0)
		ico.Icon:SetTexture((select(3,T.Garrison.GetMechanicInfo(k))))
		ico.Count:SetText(countFreeFollowers(f, finfo))
		ico:Show()
		ico.id, icons[i], i = k, ico, i + 1
	end
	for i=i,#icons do
		icons[i]:Hide()
	end
end
GarrisonMissionFrame.FollowerTab:HookScript("OnShow", syncTotals)