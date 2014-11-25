local _, T = ...

local GetFollowerInfo, GetCounterInfo = T.Garrison.GetFollowerInfo, T.Garrison.GetCounterInfo

local Hide do
	local dungeon = CreateFrame("Frame")
	dungeon:Hide()
	function Hide(f, ...)
		if f then
			f:SetParent(dungeon)
			return Hide(...)
		end
	end
end

Hide(GarrisonMissionFrameMissionsTab1, GarrisonMissionFrameMissionsTab2)
local tab = CreateFrame("Button", "GarrisonMissionFrameTab3", GarrisonMissionFrame, "GarrisonMissionFrameTabTemplate", 1)
tab:SetScript("OnClick", function()
	if GarrisonMissionFrame.MissionTab.MissionPage:IsShown() then
		GarrisonMissionFrame.MissionTab.MissionPage.CloseButton:Click()
	end
	GarrisonMissionFrame_SelectTab(1)
	GarrisonMissionList_UpdateMissions()
	GarrisonMissionFrameMissionsTab2:Click()
	PanelTemplates_SetTab(GarrisonMissionFrame, 3)
end)
tab.Text:SetText("Active Missions")
GarrisonMissionFrameTab1:SetText("Available Missions")
tab:SetPoint("LEFT", GarrisonMissionFrameTab1, "RIGHT", -5, 0)
GarrisonMissionFrameTab2:SetPoint("LEFT", tab, "RIGHT", -5, 0)
PanelTemplates_DeselectTab(tab)
local function updateMissionCounts(useCachedData)
	if not useCachedData then
		C_Garrison.GetAvailableMissions(GarrisonMissionFrameMissions.availableMissions)
		C_Garrison.GetInProgressMissions(GarrisonMissionFrameMissions.inProgressMissions)
	end
	tab:SetFormattedText("Active Missions (%d)", #GarrisonMissionFrameMissions.inProgressMissions)
	GarrisonMissionFrameTab1:SetFormattedText("Available Missions (%d)", #GarrisonMissionFrameMissions.availableMissions)
	PanelTemplates_TabResize(tab, 10)
	PanelTemplates_TabResize(GarrisonMissionFrameTab1, 10)
	if #GarrisonMissionFrameMissions.inProgressMissions == 0 then
		PanelTemplates_SetDisabledTabState(tab)
	else
		(GarrisonMissionFrame.selectedTab == 3 and PanelTemplates_SelectTab or PanelTemplates_DeselectTab)(tab)
	end
end
hooksecurefunc("GarrisonMissionList_UpdateMissions", function() updateMissionCounts(true) end)
hooksecurefunc("PanelTemplates_UpdateTabs", function(frame)
	if frame == GarrisonMissionFrame then
		updateMissionCounts()
		if #GarrisonMissionFrameMissions.inProgressMissions == 0 then
			PanelTemplates_SetDisabledTabState(tab)
		else
			(frame.selectedTab == 3 and PanelTemplates_SelectTab or PanelTemplates_DeselectTab)(tab)
		end
	end
end)
GarrisonMissionFrameTab1:SetScript("OnClick", function()
	GarrisonMissionFrame_SelectTab(1)
	GarrisonMissionFrameMissionsTab1:Click()
end)
hooksecurefunc("GarrisonMissionList_SetTab", function(id)
	PanelTemplates_UpdateTabs(GarrisonMissionFrame)
end)

local remainingTimeSort do
	local units, midOrder, midExpire = {hr=3600, min=60, sec=1}, {}, {}
	local tt = setmetatable({}, {__index=function(self, k)
		local v = 0
		for n,u in k:gmatch("(%d+)%s+(%a+)") do
			v = v + tonumber(n)*(units[u] or 1)
		end
		self[k] = v
		return v
	end})
	local function cmp(a,b)
		local c = true
		if a.missionID > b.missionID then
			a, b, c = b, a, false
		end
		local ac, bc, aid, bid = tt[a.timeLeft], tt[b.timeLeft], a.missionID, b.missionID
		local ikey = aid * 1e6 + bid
		if ac ~= bc then
			midOrder[ikey], midExpire[ikey] = ac < bc, GetTime()+math.min(ac, bc)-60
			return (ac < bc) == c
		elseif midOrder[ikey] ~= nil and midExpire[ikey] > GetTime() then
			return midOrder[ikey] == c
		else
			return (aid < bid) == c
		end
	end
	function remainingTimeSort(t)
		table.sort(t, cmp)
		wipe(tt)
	end
end
hooksecurefunc(C_Garrison, "GetInProgressMissions", function(t)
	if t then
		remainingTimeSort(t)
	end
end)
local mitigatedThreatSort do
	local finfo, cinfo
	local function computeThreat(a)
		local ret, threats, lvl = 0, T.Garrison.GetMissionThreats(a.missionID), a.level
		for i=1,#threats do
			local c, quality = cinfo[threats[i]], 0
			for i=1,c and #c or 0 do
				local fi = finfo[c[i]]
				local ld, mt = fi.level - lvl, fi.missionTimeLeft
				if not fi.isCombat then
				elseif ld >= 0 then
					quality = math.max(quality, mt and 2 or 4)
				elseif ld >= -2 then
					quality = math.max(quality, mt and 1 or 3)
				end
				if quality == 4 then break end
			end
			ret = ret + (quality-4)*100
		end
		return ret, ret
	end
	local function cmp(a, b)
		local ac, bc = a.mitigatedThreatScore, b.mitigatedThreatScore
		if ac == nil then
			ac, a.mitigatedThreatScore = computeThreat(a)
		end
		if bc == nil then
			bc, b.mitigatedThreatScore = computeThreat(b)
		end
		if ac == bc or (ac == 0) == (bc == 0) then
			ac, bc = a.level, b.level
		end
		if ac == bc then
			ac, bc = a.iLevel, b.iLevel
		end
		if ac == bc then
			ac, bc = 0, strcmputf8i(a.name, b.name)
		end
		if ac == bc then
			ac, bc = a.missionID, b.missionID
		end
		return ac > bc
	end
	function mitigatedThreatSort(t)
		finfo, cinfo = GetFollowerInfo(), GetCounterInfo()
		table.sort(t, cmp)
		finfo, cinfo = nil, nil
	end
end
_G.Garrison_SortMissions = mitigatedThreatSort

local missionFollowerSort do
	local finfo, cinfo, tinfo, mlvl
	local statusPriority = {
	  [GARRISON_FOLLOWER_WORKING] = 5,
	  [GARRISON_FOLLOWER_ON_MISSION] = 4,
	  [GARRISON_FOLLOWER_EXHAUSTED] = 3,
	  [GARRISON_FOLLOWER_INACTIVE] = 2,
	  [""]=1,
	}
	local function cmp(a, b)
		local af, bf = finfo[a], finfo[b]
		local ac, bc = af.isCollected and 1 or 0, bf.isCollected and 1 or 0
		if ac == bc then
			ac, bc = statusPriority[af.status] or 6, statusPriority[bf.status] or 6
		end

		if ac == bc then
			ac, bc = cinfo[af.followerID] and (#cinfo[af.followerID])*100 or 0, cinfo[bf.followerID] and (#cinfo[bf.followerID])*100 or 0
			ac, bc = ac + (tinfo[af.followerID] and #tinfo[af.followerID] or 0), bc + (tinfo[bf.followerID] and #tinfo[bf.followerID] or 0)
			if (ac > 0) ~= (bc > 0) then
				return ac > 0
			elseif ac > 0 and ((af.level >= mlvl) ~= (bf.level >= mlvl)) then
				return af.level >= mlvl
			end
		end
		if ac == bc then
			ac, bc = af.level, bf.level
		end
		if ac == bc then
			ac, bc = af.iLevel, bf.iLevel
		end
		if ac == bc then
			ac, bc = af.quality, bf.quality
		end
		if ac == bc then
			ac, bc = 0, strcmputf8i(af.name, bf.name)
		end
		return ac > bc
	end
	function missionFollowerSort(t, followers, counters, traits, level)
		finfo, cinfo, tinfo, mlvl = followers, counters, traits, level
		table.sort(t, cmp)
		finfo, cinfo, tinfo, mlvl = nil
	end
end
local oldSortFollowers = GarrisonFollowerList_SortFollowers
function GarrisonFollowerList_SortFollowers(self)
   local followerCounters = GarrisonMissionFrame.followerCounters
   local followerTraits = GarrisonMissionFrame.followerTraits
   if followerCounters and followerTraits and GarrisonMissionFrame.MissionTab:IsVisible() then
		return missionFollowerSort(self.followersList, self.followers, followerCounters, followerTraits, GarrisonMissionFrame.MissionTab.MissionPage.missionInfo.level)
	end
	return oldSortFollowers(self)
end

local GetThreatColor do
	local threatColors={[0]={1,0,0}, {0.15, 0.45, 1}, {0.20, 0.45, 1}, {1, 0.55, 0}, {0,1,0}}
	function GetThreatColor(counters, missionLevel, finfo)
		if not missionLevel then return 1,1,1 end
		local finfo, quality = finfo or GetFollowerInfo(), 0
		for i=1,counters and #counters or 0 do
			local fi = finfo[counters[i]]
			local ld, mt = fi.level - missionLevel, fi.missionTimeLeft
			if not fi.isCombat then
			elseif ld >= 0 then
				quality = math.max(quality, mt and 2 or 4)
			elseif ld >= -2 then
				quality = math.max(quality, mt and 1 or 3)
			end
		end
		return unpack(threatColors[quality])
	end
end
hooksecurefunc("GarrisonMissionButton_AddThreatsToTooltip", function(mid)
	local missionLevel
	for k, v in pairs(C_Garrison.GetAvailableMissions()) do
		if v.missionID == mid then
			missionLevel = v.level
			break
		end
	end
	
	local threats, finfo, cinfo = GarrisonMissionListTooltipThreatsFrame.Threats, GetFollowerInfo(), GetCounterInfo()
	for i=1,#threats do
		local f = threats[i]
		if f:IsShown() then
			local c = cinfo[T.Garrison.GetMechanicInfo(f.Icon:GetTexture():lower())]
			f.Border:SetVertexColor(GetThreatColor(c, missionLevel, finfo))
		end
	end
end)
hooksecurefunc("GarrisonFollowerList_Update", function(self)
	local buttons, fl = self.FollowerList.listScroll.buttons, GetFollowerInfo()
	for i=1, #buttons do
		local f, fi = buttons[i], fl[buttons[i].id]
		if f:IsShown() and fi and fi.missionTimeLeft then
			f.Status:SetFormattedText("%s (%s)", f.Status:GetText(), fi.missionTimeLeft)
		end
	end
end)

GarrisonMissionMechanicTooltip:HookScript("OnShow", function(self)
	local finfo, cinfo = GetFollowerInfo(), GetCounterInfo()
	local c = cinfo[T.Garrison.GetMechanicInfo(self.Icon:GetTexture():lower())]
	if c then
		local t, mlvl = {}, GarrisonMissionMechanicTooltip.missionLevel or GarrisonMissionFrame.MissionTab.MissionPage.missionInfo and GarrisonMissionFrame.MissionTab.MissionPage.missionInfo.level
		T.Garrison.sortByFollowerLevels(c, finfo)
		for i=1,#c do
			t[#t+1] = T.Garrison.GetFollowerLevelDescription(c[i], mlvl, finfo[c[i]])
		end
		if #t > 0 then
			local height = self:GetHeight()-self.Description:GetHeight()
			self.Description:SetText(self.Description:GetText() .. NORMAL_FONT_COLOR_CODE .. "\n\nCountered by:\n" .. table.concat(t, "\n"))
			self:SetHeight(height + self.Description:GetHeight() + 4)
		end
	end
end)

local threatListMT = {} do
	local function HideTip(self)
		GarrisonMissionMechanicTooltip:Hide()
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
		self:GetParent():UnlockHighlight()
	end
	local function OnEnter(self)
		if self.info.isFollowers then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:AddLine(self.info.name)
			GameTooltip:Show()
		else
			GarrisonMissionMechanicTooltip.missionLevel = self.missionLevel
			GarrisonMissionMechanic_OnEnter(self)
			GarrisonMissionMechanicTooltip.missionLevel = nil
		end
		self:GetParent():LockHighlight()
	end
	local function SetThreat(self, info, level, counters, followers)
		if info then
			self.info, self.missionLevel = info, level
			self.Icon:SetTexture(info.icon)
			self.Border:SetShown(not (info.isEnvironment or info.isFollowers))
			self.Border:SetVertexColor(GetThreatColor(counters, level, followers))
			self.Count:SetText(info.count or "")
			self:Show()
		else
			self:Hide()
		end
	end
	function threatListMT:__index(k)
		if k == 0 then return nil end
		local sib = self[k-1]
		local b = CreateFrame("Button", nil, sib and sib:GetParent(), "GarrisonAbilityCounterTemplate")
		b.Count = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
		b.Count:SetPoint("BOTTOMRIGHT", 0, 2)
		if sib then
			b:SetPoint("LEFT", sib, "RIGHT", 10, 0)
		end
		b:SetScript("OnEnter", OnEnter)
		b:SetScript("OnLeave", HideTip)
		self[k], b.SetThreat = b, SetThreat
		return b
	end
end
local function MissionButton_OnEnter(self)
	if self.info.inProgress then
		GarrisonMissionButton_OnEnter(self)
	end
end
hooksecurefunc("GarrisonMissionButton_SetRewards", function(self, rewards, numRewards)
	local index = 1
	for id, reward in pairs(rewards) do
		local btn = self.Rewards[index]
		if reward.followerXP then
			btn.Quantity:SetText(reward.followerXP)
			btn.Quantity:Show()
		end
		index = index + 1
	end
	if not self.Threats then
		self.Threats = setmetatable({}, threatListMT)
		self.Threats[1]:SetParent(self)
		self.Threats[1]:SetPoint("TOPLEFT", self.Title, "BOTTOMLEFT", 0, -5)
		self.Threats[2]:SetPoint("LEFT", self.Threats[1], "RIGHT", 5, 0)
		self.Threats[3]:SetPoint("LEFT", self.Threats[2], "RIGHT", 7.5, 0)
		self:SetScript("OnEnter", MissionButton_OnEnter)
	end
		
	local nt, tt, mi = 1, self.Threats, self.info
	local cinfo, finfo = T.Garrison.GetCounterInfo(), T.Garrison.GetFollowerInfo()
	if not mi.inProgress then
		self.Title:SetPoint("LEFT", 165, 10)
		local _, _xp, ename, edesc, etex, _, _, enemies = C_Garrison.GetMissionInfo(mi.missionID)
		nt = nt + 1, tt[nt]:SetThreat({name=GARRISON_MISSION_TOOLTIP_NUM_REQUIRED_FOLLOWERS:format(mi.numFollowers), count="|cffffcc33".. mi.numFollowers, icon="Interface/Icons/INV_MISC_GroupLooking", isFollowers=true})
		nt = nt + 1, tt[nt]:SetThreat({name=ename, icon=etex, description=edesc, isEnvironment=true})
	
		for i=1,#enemies do
			for id, minfo in pairs(enemies[i].mechanics) do
				nt = nt + 1, tt[nt]:SetThreat(minfo, mi.level, cinfo[id], finfo)
			end
		end
	end
		
	for i=nt,#tt do
		tt[i]:Hide()
	end
end)