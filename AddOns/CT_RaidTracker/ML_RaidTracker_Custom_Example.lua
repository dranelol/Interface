-- You have to rename this file to ML_RaidTracker_Custom.lua


--[[ This is a example configuration file
ML_RaidTracker_Custom_Options = {
	["LogGroup"] = 1,
	["24hFormat"] = 1,
	["AutoZone"] = 1,
	["SaveTooltips"] = 1,
	["AskCost"] = 5,
	["Timezone"] = 0,
	["AutoRaidCreation"] = 1,
	["GroupItems"] = 0,
	["AutoBossBoss"] = "Trash mob",
	["TimeSync"] = 1,
	["AutoBoss"] = 1,
	["GuildSnapshot"] = 0,
	["AutoGroup"] = 1,
	["LogBattlefield"] = 0,
	["GetDkpValue"] = 5,
	["WipeCoolDown"] = 120,
	["NextBoss"] = 1,
	["AutoBossChangeMinTime"] = 120,
	["LogAttendees"] = 0,
	["MinQuality"] = 3,
	["SaveExtendedPlayerInfo"] = 1,
	["OldFormat"] = 1,
	["WipePercent"] = 0.4899999797344208,
	["MLdkp"] = 1,
	["Wipe"] = 1,
	["MaxLevel"] = 70,
}
]]--



--[[ this is a example item price calculation based on the item level
function ML_RaidTracker_Custom_Price(sItem)
	local nameGIF, linkGIF, qualityGIF, iLevelGIF, minLevelGIF, classGIF, subclassGIF, maxStackGIF, invtypeGIV, iconGIF = GetItemInfo("item:"..sItem);
  return iLevelGIF * 2;
end;
]]--


--[[ this is a example item price based on a table

DKPValues = {
  ["12546"] = 10,
  ["34655"] = 11,
  ["52345"] = 10,
  ["67456"] = 40,
  ["42344"] = 10,
  ["11223"] = 20,
  ["33221"] = 10,
  ["55432"] = 10,
}

]]--