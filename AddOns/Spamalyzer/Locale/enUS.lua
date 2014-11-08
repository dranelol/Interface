local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local ADDON_NAME = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true, debug)

if not L then return end

L["Bytes"] = true
L["ChatFrame1"] = true
L["ChatFrame2"] = true
L["ChatFrame3"] = true
L["ChatFrame4"] = true
L["ChatFrame5"] = true
L["ChatFrame6"] = true
L["ChatFrame7"] = true
L["Display Known"] = true
L["Display messages from known AddOns in the ChatFrame."] = true
L["Display messages from unknown AddOns in the ChatFrame."] = true
L["Display Unknown"] = true
L["Draws the icon on the minimap."] = true
L["Hide Hint Text"] = true
L["Hides the hint text at the bottom of the tooltip."] = true
L["Input"] = true
L["Left-click to change datafeed type."] = true
L["Messages"] = true
L["Middle-click to change tooltip mode."] = true
L["Minimap Icon"] = true
L["Move the slider to adjust the scale of the tooltip."] = true
L["Move the slider to adjust the tooltip fade time."] = true
L["Output"] = true
L["Received"] = true
L["Right-click for options."] = true
L["Scale"] = true
L["Secondary location to display AddOn messages."] = true
L["Sent"] = true
L["Shift+Left-click to clear data."] = true
L["Show traffic statistics at the bottom of the tooltip."] = true
L["Timer"] = true
L["Toggle recording of %s AddOn messages."] = true
L["Tooltip"] = true
L["Tracking"] = true
