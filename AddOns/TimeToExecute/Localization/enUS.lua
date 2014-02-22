-- English localization file for enUS and enGB.
local L = LibStub("AceLocale-3.0"):NewLocale("TimeToExecute", "enUS", true)
if not L then return end

-- Configuration Settings
L["MaxHistory"] = "Maximum History"
L["MaxHistoryDesc"] = "Maximum number of data points to record. Can be used to throttle performance on slow computers. Recommended setting is 4 * Maximum Time."
L["MaxTime"] = "Maximum Time"
L["MaxTimeDesc"] = "Maximum length in seconds of data points to record. Setting this longer will result in less erratic estimates, but the estimates will react slower to changes in DPS."
L["ExecutePercentage"] = "Execute Percentage"
L["ExecutePercentageDesc"] = "Percentage health to consider 'execute range'."
L["TrackFocus"] = "Track Focus"
L["TrackFocusDesc"] = "Track hitpoints of the focussed enemy mob instead of the target, where applicable"
L["PositionLocked"] = "Lock Position"
L["PositionLockedDesc"] = "Prevents draggable movement of the user interface"
L["TimerWidth"] = "Timer Width"
L["TimerWidthDesc"] = "Adjusts the width of each individual timer frame"
L["TimerHeight"] = "Timer Height"
L["TimerHeightDesc"] = "Adjusts the height of each individual timer frame"
L["FontSize"] = "Font Size"
L["FontSizeDesc"] = "Adjusts the size of the timer text"
L["HideInactive"] = "Hide When Inactive"
L["HideInactiveDesc"] = "Hides the TTE frame when not tracking anything"
L["Visible"] = "Addon visible"
L["VisibleDesc"] = "Determines whether or not the addon is ever visible. If disabled, this overrides all other visibility settings. Addon continues to function and provide data updates internally."