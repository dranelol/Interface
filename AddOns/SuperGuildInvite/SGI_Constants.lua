SGI = {};

-- General
SGI.LOGO = "|cffffff00<|r|cff16ABB5SGI|r|cffffff00>|r ";
SLASH_SUPERGUILDINVITE1 = "/sgi";
SLASH_SUPERGUILDINVITE2 = "/superguildinvite";
SGI_DATA_INDEX = UnitName("player").." - "..GetRealmName() or "?";
SGI.VERSION_ALERT_COOLDOWN = false;


-- Version realted
SGI.VERSION_MAJOR = "7.2";
SGI.VERSION_MINOR = ".2";
SGI.versionChanges = {
	version = "Version |cff55EE55"..SGI.VERSION_MAJOR..SGI.VERSION_MINOR.."|r",
	items = {
		"Mde SGI no longer ignore players from another Realm",
	},
}

SGI.CommonIssues = {
	"Test1",
	"Test2",
	"Test3",
}

local function defaultFunc(L,key)
	return "857C7C"
end



SGI_CLASS_COLORS = {
	["DEATHKNIGHT"] = "C41F3B",
	["DRUID"] = "FF7D0A",
	["HUNTER"] = "ABD473",
	["MAGE"] = "69CCF0",
	["MONK"] = "00FF96",
	["PALADIN"] = "F58CBA",
	["PRIEST"] = "FFFFFF",
	["ROGUE"] = "FFF569",
	["SHAMAN"] = "0070DE",
	["WARLOCK"] = "9482C9",
	["WARRIOR"] = "C79C6E",
}

SGI_CLASS_COLORS = setmetatable(SGI_CLASS_COLORS, {__index=defaultFunc})


local debugMode = false;
local old = print
function SGI:print(...)
	if (SGI_DATA_INDEX == "?" or type(SGI_DATA) ~= "table") then return end
	if (not SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_SGI_MUTE"]) then
		old("|cffffff00<|r|cff16ABB5SGI|r|cffffff00>|r|cffffff00",...,"|r")
	end
end
function SGI:debug(...)
	if (debugMode) then
		old("|cffffff00<|r|cff16ABB5SGI|r|cffffff00>|r|cffff3300",...,"|r")
	end
end

function SGI:DebugState(state)
	debugMode = state;
end

SGI:debug("Loading SGI files:");
SGI:debug(">> Constants.lua");