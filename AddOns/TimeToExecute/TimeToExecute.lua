-- TimeToExecute
-- ver. 0.2.7
-- Author: Tifordin
-- http://www.wowace.com/projects/timetoexecute/


------------
-- Locals --
------------

local hpHistory = {}
local hpTotal = 0
-- local inCombat = false
local lastRefresh
local lastReset
local active = false
local lastGetTime
local debugMode = false
local saved_a = 0
local saved_b = 0
local trackingId = "target"
local trackingGuid = nil

-- UI values for smoothing and refresh interval
local lastKillValue = 0
local lastExecuteValue = 0
local uiLastUpdate = 0
local ldbLastUpdate = 0

-- Initial positioning
local bottom = 200
local left = 200


---------------
-- Constants --
---------------

-- UI settings, shouldn't need to be changed
local uiUpdateInterval = 0.05
local ldbUpdateInterval = 0.2
local uiSmoothFactor = 0.7 
	-- High value means the timer adjusts to estimate changes faster
	-- Low value (<1) results in a smoother output
local uiCreated = false


---------
-- Ace --
---------

local L = LibStub("AceLocale-3.0"):GetLocale("TimeToExecute", true)
TimeToExecute = LibStub("AceAddon-3.0"):NewAddon("TimeToExecute", "AceEvent-3.0")


---------
-- LDB --
---------

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local ldbObjKill = ldb:NewDataObject("TTE_KillTime", {type = "data source", text = "K: 0.0", icon = "Interface\\Icons\\INV_Sword_48",})
local ldbObjExecute = ldb:NewDataObject("TTE_ExecuteTime", {type = "data source", text = "E: 0.0", icon = "Interface\\Icons\\INV_Sword_48",})


--------------------
-- User Interface --
--------------------

-- Frames
local frame
local executeFrame
local killFrame
local eventFrame

-- UI text
local executeFS
local killFS

-- Show UI
-- CreateFrames is called on AddOn startup, and
-- whenever a UI configuration is changed
function TimeToExecute:CreateFrames()
	TimeToExecute:ResetLDB()
	
	local executePercent = TimeToExecute:GetExecutePercentage()
	local timerWidth = TimeToExecute:GetTimerWidth()
	local timerHeight = TimeToExecute:GetTimerHeight()
	local fontSize = TimeToExecute:GetFontSize()
	local parentHeight
	
	if (executePercent == 0) then
		parentHeight = timerHeight + 4
	else
		parentHeight = 2 * timerHeight + 6
	end
	
	if (frame == nil) then frame = CreateFrame("Frame", "TTEFrame", UIParent) end
	frame:SetFrameStrata("BACKGROUND")
	frame:SetWidth(timerWidth + 4)
	frame:SetHeight(parentHeight)
	frame:SetPoint("BOTTOMLEFT", left, bottom)
	frame:SetBackdrop({bgFile = "Interface/Buttons/WHITE8X8", 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
					tile = true, tileSize = 8, edgeSize = 1, 
					insets = { left = 1, right = 1, top = 1, bottom = 1 }});
	frame:SetBackdropColor(0.05, 0.05, 0.05, 1)
	
	if (executePercent ~= 0) then
		if (executeFrame == nil) then executeFrame = CreateFrame("Frame", "TTEExecuteFrame", frame) end
		executeFrame:SetWidth(timerWidth)
		executeFrame:SetHeight(timerHeight)
		executeFrame:SetPoint("TOPLEFT", 2, -2)
		executeFrame:SetBackdrop({bgFile = "Interface/Buttons/WHITE8X8", 
						edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
						tile = true, tileSize = 8, edgeSize = 1, 
						insets = { left = 1, right = 1, top = 1, bottom = 1 }});
	end
	
	if (killFrame == nil) then killFrame = CreateFrame("Frame", "TTEKillFrame", frame) end
	killFrame:SetWidth(timerWidth)
	killFrame:SetHeight(timerHeight)
	killFrame:SetPoint("BOTTOMLEFT", 2, 2)
	killFrame:SetBackdrop({bgFile = "Interface/Buttons/WHITE8X8", 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
					tile = true, tileSize = 8, edgeSize = 1, 
					insets = { left = 1, right = 1, top = 1, bottom = 1 }});
	
	-- UI text
	if (executePercent ~= 0) then
		if (executeFS == nil) then executeFS = executeFrame:CreateFontString("TTEExecuteFS", "OVERLAY") end
		executeFS:SetTextHeight(fontSize)
		executeFS:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
		executeFS:SetText("EXEC")
		executeFS:SetPoint("CENTER")
	end
	
	if (killFS == nil) then killFS = killFrame:CreateFontString("TTEKillFS", "OVERLAY") end
	killFS:SetTextHeight(fontSize)
	killFS:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
	killFS:SetText("KILL")
	killFS:SetPoint("CENTER")

	-- Setup movement/location
	local win = LibStub("LibWindow-1.1")
	win.RegisterConfig(frame, TimeToExecute:GetProfile())
	win.RestorePosition(frame)

	if (not TimeToExecute:GetPositionLocked()) then
		win.MakeDraggable(frame)
		frame:EnableMouse(true)
	end

	uiCreated = true
	TimeToExecute:UpdateVisibleStatus()
end

function TimeToExecute:UpdateVisibleStatus()
	if not uiCreated then return end
	
	local hideInactive = TimeToExecute:GetHideInactive()
	local visible = TimeToExecute:GetVisible()
	
	if (not visible) then
		if (frame:IsVisible()) then
			frame:Hide()
		end
	else
		if (active and not frame:IsVisible()) then
			frame:Show()
		elseif (not active and hideInactive and frame:IsVisible()) then
			frame:Hide()
		elseif (not active and not hideInactive and not frame:IsVisible()) then
			frame:Show()
		end
	end
end


-------------------
-- Configuration --
-------------------

local options = {
    name = "TimeToExecute",
    handler = TimeToExecute,
    type = 'group',
    args = {
        MaxHistory = {
            type = 'range',
            name = L["MaxHistory"],
            desc = L["MaxHistoryDesc"],
			min = 20,
			max = 500,
			step = 1,
			bigStep = 20,
            set = 'SetMaxHistory',
            get = 'GetMaxHistory',
        },
		MaxTime = {
			type = 'range', 
			name = L["MaxTime"],
			desc = L["MaxTimeDesc"],
			min = 5,
			max = 120,
			step = 1,
			bigStep = 5,
			set = 'SetMaxTime',
			get = 'GetMaxTime',
		},
		ExecutePercentage = {
			type = 'select',
			name = L["ExecutePercentage"],
			desc = L["ExecutePercentageDesc"],
			values = { [0.0]='0%', [0.20]='20%', [0.25]='25%', [0.35]='35%' },
			get = 'GetExecutePercentage',
			set = 'SetExecutePercentage',
		},
		TrackFocus = {
			type = 'toggle',
			name = L["TrackFocus"],
			desc = L["TrackFocusDesc"],
			get = 'GetTrackFocus',
			set = 'SetTrackFocus',
		},
		PositionLocked = {
			type = 'toggle',
			name = L["PositionLocked"],
			desc = L["PositionLockedDesc"],
			get = 'GetPositionLocked',
			set = 'SetPositionLocked',
		},
		TimerWidth = {
			type = 'range',
			name = L["TimerWidth"],
			desc = L["TimerWidthDesc"],
			min = 10,
			max = 70,
			step = 1,
			bigStep = 5,
			get = 'GetTimerWidth',
			set = 'SetTimerWidth',
		},
		TimerHeight = {
			type = 'range',
			name = L["TimerHeight"],
			desc = L["TimerHeightDesc"],
			min = 5,
			max = 40,
			step = 1,
			bigStep = 5,
			get = 'GetTimerHeight',
			set = 'SetTimerHeight',
		},
		FontSize = {
			type = 'range',
			name = L["FontSize"],
			desc = L["FontSizeDesc"],
			min = 8,
			max = 20,
			step = 1,
			bigStep = 2,
			get = 'GetFontSize',
			set = 'SetFontSize',
		},
		HideInactive = {
			type = 'toggle',
			name = L["HideInactive"],
			desc = L["HideInactiveDesc"],
			get = 'GetHideInactive',
			set = 'SetHideInactive',
		},
		Visible = {
			type = 'toggle',
			name = L["Visible"],
			desc = L["VisibleDesc"],
			get = 'GetVisible',
			set = 'SetVisible',
		},
    },
}

local defaults = {
	profile = {
		["MaxHistory"] = 120, 
		["MaxTime"] = 30.0, 
		["ExecutePercentage"] = 0.35,
		["TrackFocus"] = true,
		["PositionLocked"] = false,
		["TimerWidth"] = 50,
		["TimerHeight"] = 25,
		["FontSize"] = 14,
		["HideInactive"] = true,
		["Visible"] = true,
	},
}


--------------------
-- Initialisation --
--------------------

function TimeToExecute:OnInitialize()
	-- Setup configuration / database
	self.db = LibStub("AceDB-3.0"):New("TimeToExecuteDB", defaults)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("TimeToExecute", options, {"tte", "timetoexecute"})
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TimeToExecute", "TimeToExecute")
	
	-- Setup OnUpdate
	eventFrame = CreateFrame("Frame")
	eventFrame:SetScript("OnUpdate", TimeToExecute_OnUpdate)
	eventFrame:Show()

	-- Setup UI
	TimeToExecute:CreateFrames()
end

function TimeToExecute:GetProfile()
	return self.db.profile
end

function TimeToExecute:OnEnable()
	-- Register the events we want to handle
	self:RegisterEvent("UNIT_HEALTH");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("PLAYER_FOCUS_CHANGED");
	
	lastRefresh = GetTime()
	lastGetTime = GetTime()
end

function TimeToExecute:OnDisable()
	self:UnregisterAllEvents()
end


---------------
-- UI Update --
---------------

function TimeToExecute_OnUpdate()
	local frameTime = GetTime() - uiLastUpdate
	local executePercent = TimeToExecute:GetExecutePercentage()

	if (frameTime >= uiUpdateInterval) then
		if (active and #hpHistory > 1) then
			-- Get new estimates
			local executeTime = 0
			if (executePercent ~= 0) then
				executeTime = TimeToExecute:GetTime_Target(executePercent)
			end
			local killTime = TimeToExecute:GetTime_Target(0.0)
			
			-- Smoothing
			local newFactor = math.min(uiSmoothFactor * frameTime, 1)
			local oldFactor = math.max(1 - uiSmoothFactor * frameTime, 0)
			
			executeTime = (lastExecuteValue - frameTime) * oldFactor + executeTime * newFactor
			killTime = (lastKillValue - frameTime) * oldFactor + killTime * newFactor
			
			-- Update UI elements
			if (executePercent ~= 0) then
				if (hpHistory[1][2] / hpTotal < executePercent) then
					executeFS:SetText("EXEC!")
					executeFrame:SetBackdropColor(0.8, 0.2, 0.2, 1)
				else 
					executeFS:SetText(TimeToExecute:TimeString(executeTime))
					executeFrame:SetBackdropColor(1.0, 1.0, 1.0, 1)
				end
			end
			killFS:SetText(TimeToExecute:TimeString(killTime))
			
			-- Save values
			lastExecuteValue = executeTime
			lastKillValue = killTime
		else
			if (executePercent ~= 0) then
				executeFS:SetText("EXEC")
				executeFrame:SetBackdropColor(1.0, 1.0, 1.0, 1)
			end
			killFS:SetText("KILL")
		end
		
		uiLastUpdate = GetTime()
	end
	
	if (GetTime() - ldbLastUpdate >= ldbUpdateInterval) then
		ldbObjKill.text = "K: " .. TimeToExecute:TimeString(lastKillValue)
		
		if (executePercentage ~= 0) then
			ldbObjExecute.text = "E: " .. TimeToExecute:TimeString(lastExecuteValue)
		end
		
		ldbLastUpdate = GetTime()
	end
end

function TimeToExecute:TimeString(timeVal)
	if timeVal == nil then return "0.0" end
	if timeVal <= 60 then
		return ('%.1f'):format(timeVal)
	else
		return ('%d:%02d'):format(timeVal / 60, timeVal % 60)
	end
end

---------------------------
-- Core Estimation Maths --
---------------------------

-- This function does the number crunching, and should be called by any
-- external addon wishing to get information from TimeToExecute
-- executePercent is the percentage hp which the addon should attempt
-- to estimate for. Suggested values are 0 or 0.35. Will default to whatever
-- is set in the configuration if none supplied
function TimeToExecute:GetTime_Target(executePercent)
	lastGetTime = GetTime()
	
	-- If no percentage is supplied then default to configured percentage
	if (executePercent == nil) then
		executePercent = TimeToExecute:GetExecutePercentage()
	end
	
	local n = # hpHistory
	
	-- Simple linear regression for now
	-- ( E(x^2)   E(x) )  ( a )   ( E(xy) )
	-- ( E(x)       n  )  ( b ) = ( E(y)   )
	-- Format of the above: ( 2x2 Matrix ) * ( 2x1 Vector ) = ( 2x1 Vector )
	-- Solve to find a and b, satisfying y = a + bx
	-- Matrix arithmetic has been expanded and solved to make the following operation as fast as possible
	if (n > 1 and (saved_a == 0 or saved_b == 0)) then
		local Ex2 = 0
		local Ex = 0
		local Exy = 0
		local Ey = 0
		
		for i,p in pairs(hpHistory) do
			local x = p[1]
			local y = p[2]
			Ex2 = Ex2 + x*x
			Ex = Ex + x
			Exy = Exy + x*y
			Ey = Ey + y
		end
		
		-- Invariant to find matrix inverse
		local invar = Ex2*n - Ex*Ex
		
		-- Solve for a and b
		saved_a = - Ex*Exy/invar + Ex2*Ey/invar
		saved_b =    n*Exy/invar - Ex*Ey/invar
	end
	
	local estKillTime = 0.0
	
	-- Stop divide by 0
	if (saved_b ~= 0) then
		-- Use best fit line to calculate estimated time to reach target hp
		estKillTime = (executePercent * hpTotal - saved_a) / saved_b
		-- Subtract current time to obtain "time remaining"
		estKillTime = estKillTime - (GetTime() - lastReset)
	end
	
	return estKillTime
end


--------------------
-- Event Handling --
--------------------

function TimeToExecute:UNIT_HEALTH(event, firstArg, secondArg)
	if (firstArg == TimeToExecute:GetTrackingId()) then
		TimeToExecute_DoUpdate()
	end
end
function TimeToExecute:PLAYER_TARGET_CHANGED()
	if (TimeToExecute:GetTrackFocus()) then
		-- Need to check if the focus is being tracked
		if (TimeToExecute:GetTrackingId() ~= "focus" or UnitHealth("focus") == 0) then
			TimeToExecute:SetTrackingId("target")
		end
	else
		TimeToExecute:SetTrackingId("target")
	end
end
function TimeToExecute:PLAYER_FOCUS_CHANGED()
	-- Ignore if we're not supposed to be tracking the focus
	if (TimeToExecute:GetTrackFocus()) then
		-- If it doesn't make sense to track the focus, then track target instead
		-- Should only happen if clearing the focus? Might not be needed...
		if (UnitHealthMax("focus") == 0 or UnitIsFriend("player", "focus")) then
			if (TimeToExecute:GetTrackingId() ~= "target") then
				TimeToExecute:SetTrackingId("target")
			end
		else
			TimeToExecute:SetTrackingId("focus")
		end
	end
end


---------------------
-- Utility Methods --
---------------------

-- Sets things back to their defaults, clears data
function TimeToExecute:ResetMob()
	hpTotal = UnitHealthMax(TimeToExecute:GetTrackingId())
	hpHistory = {}
	lastRefresh = GetTime()
	lastGetTime = GetTime()
	lastReset = GetTime()
	
	lastKillValue = 0
	lastExecuteValue = 0
	
	currentGuid = UnitGUID(TimeToExecute:GetTrackingId())
	
	TimeToExecute:ResetLDB()
	
	if (hpTotal == 0 or UnitIsFriend("player", TimeToExecute:GetTrackingId())) then
		TimeToExecute:SetActive(false)
	else
		TimeToExecute:SetActive(true)
	end
end

-- This function is called on the UNIT_HEALTH event
-- to store the new target hitpoint value
function TimeToExecute_DoUpdate()
	if (not active) then return end
	
	-- The mob's hp has changed - record the new value
	local currenthp = UnitHealth(TimeToExecute:GetTrackingId())
	lastRefresh = GetTime()
	local currenttime = lastRefresh - lastReset
	
	if (currenthp <= 0) then
		if (TimeToExecute:GetTrackingId() == "focus") then
			TimeToExecute:SetTrackingId("target")
		else
			TimeToExecute:ResetMob()
		end
		return
	end
	
	-- Insert at start
	table.insert(hpHistory, 1, {lastRefresh - lastReset, currenthp})
	
	-- Invalidate last regression
	saved_a = 0
	saved_b = 0
	
	-- Trim history - maximum history records
	while (#hpHistory > TimeToExecute:GetMaxHistory()) do
		table.remove(hpHistory)
	end
	
	-- Trim history - maximum time
	while (currenttime - hpHistory[#hpHistory][1] > TimeToExecute:GetMaxTime()) do
		table.remove(hpHistory)
	end
end

function TimeToExecute:ResetLDB()
	ldbObjKill.text = "K: 0.0"
	ldbObjExecute.text = "E: 0.0"
end

function TimeToExecute:GetTrackingId()
	return trackingId
end

function TimeToExecute:SetTrackingId(input)
	newGuid = UnitGUID(input)
	
	trackingId = input
	
	if (currentGuid ~= newGuid or currentGuid == nil or newGuid == nil) then
		TimeToExecute:ResetMob()
	end
end

-- Active helper
function TimeToExecute:SetActive(input)
	active = input
	TimeToExecute:UpdateVisibleStatus()
end

-------------------------
-- Setters and Getters --
-------------------------

function TimeToExecute:GetMaxHistory(info)
	if self.db.profile.maxHistory == nil then
		self.db.profile.maxHistory = defaults.profile.MaxHistory
	end
	return self.db.profile.maxHistory
end
function TimeToExecute:SetMaxHistory(info, input)
	self.db.profile.maxHistory = input
end

function TimeToExecute:GetMaxTime(info)
	if self.db.profile.maxTime == nil then
		self.db.profile.maxTime = defaults.profile.MaxTime
	end
	return self.db.profile.maxTime
end
function TimeToExecute:SetMaxTime(info, input)
	self.db.profile.maxTime = input
end

function TimeToExecute:GetExecutePercentage(info)
	if self.db.profile.executePercentage == nil then
		self.db.profile.executePercentage = defaults.profile.ExecutePercentage
	end
	return self.db.profile.executePercentage
end
function TimeToExecute:SetExecutePercentage(info, input)
	self.db.profile.executePercentage = input
	-- Rebuild frames, in case we need to add/remove the Execute frame
	TimeToExecute:CreateFrames()
end
function TimeToExecute:GetTrackFocus(info)
	if self.db.profile.trackFocus == nil then
		self.db.profile.trackFocus = defaults.profile.TrackFocus
	end
	return self.db.profile.trackFocus
end
function TimeToExecute:SetTrackFocus(info, input)
	self.db.profile.trackFocus = input
end
function TimeToExecute:GetPositionLocked(info)
	if self.db.profile.positionLocked == nil then
		self.db.profile.positionLocked = defaults.profile.PositionLocked
	end
	return self.db.profile.positionLocked
end
function TimeToExecute:SetPositionLocked(info, input)
	self.db.profile.positionLocked = input
	TimeToExecute:CreateFrames()
end
function TimeToExecute:GetTimerWidth(info)
	if self.db.profile.timerWidth == nil then
		self.db.profile.timerWidth = defaults.profile.TimerWidth
	end
	return self.db.profile.timerWidth
end
function TimeToExecute:SetTimerWidth(info, input)
	self.db.profile.timerWidth = input
	TimeToExecute:CreateFrames()
end
function TimeToExecute:GetTimerHeight(info)
	if self.db.profile.timerHeight == nil then
		self.db.profile.timerHeight = defaults.profile.TimerHeight
	end
	return self.db.profile.timerHeight
end
function TimeToExecute:SetTimerHeight(info, input)
	self.db.profile.timerHeight = input
	TimeToExecute:CreateFrames()
end
function TimeToExecute:GetFontSize(info)
	if self.db.profile.fontSize == nil then
		self.db.profile.fontSize = defaults.profile.FontSize
	end
	return self.db.profile.fontSize
end
function TimeToExecute:SetFontSize(info, input)
	self.db.profile.fontSize = input
	TimeToExecute:CreateFrames()
end
function TimeToExecute:GetHideInactive(info)
	if self.db.profile.hideInactive == nil then
		self.db.profile.hideInactive = defaults.profile.HideInactive
	end
	return self.db.profile.hideInactive
end
function TimeToExecute:SetHideInactive(info, input)
	self.db.profile.hideInactive = input
	TimeToExecute:UpdateVisibleStatus()
end
function TimeToExecute:GetVisible(info)
	if self.db.profile.visible == nil then
		self.db.profile.visible = defaults.profile.Visible
	end
	return self.db.profile.visible
end
function TimeToExecute:SetVisible(info, input)
	self.db.profile.visible = input
	TimeToExecute:UpdateVisibleStatus()
end