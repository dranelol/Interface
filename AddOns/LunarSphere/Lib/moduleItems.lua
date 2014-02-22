-- /***********************************************
--  * Lunar Items Module
--  *********************
--
--  Author	: Moongaze (Twisting Nether)
--  Description	: Locates and builds a database of every piece of food, drink, mana potion,
--                health potion, mount, and hearthstone of the player, without relying
--                on a table of pre-defined information. Is able to do away with having to
--                localize item names and keep memory usage down.
--
--  ***********************************************/

-- Notes:
-- First aid bandages, all cast spell "First Aid" , the higher the item id, the more powerful
-- the bandage (for now)
-- If I can find the "required First Aid" level, that would be more accurate in case Blizzard
-- screws the order in the future

--
-- http://thottbot.com/wotlk/s43180
-- I need to add filters for the new item level 75 foods... grrr! They need +1 strength...

-- Apprentice Riding = 33388
-- Journerman Riding = 33391
-- Expert Riding = 34090

-- /***********************************************
--  * Module Setup
--  *********************
local _;

-- Create our Lunar object if it's not made
if (not Lunar) then
	Lunar = {};
end

-- Add our Items module to Lunar
if (not Lunar.Items) then
	Lunar.Items = {};
end

-- Set our current version for the module (used for version checking later on)
Lunar.Items.version = 1.11;

-- Create our database settings
Lunar.Items.RunInitialize = false;
Lunar.Items.reagentString = nil;

-- Temp fix for German (and possibly other) locale item charge searching
Lunar.Items.chargesText = string.gsub(ITEM_SPELL_CHARGES, "%d%$", "");
Lunar.Items.chargesText = string.gsub(Lunar.Items.chargesText, "%%d", "(%%d+)");

Lunar.Items.itemSkillText = string.gsub(ITEM_MIN_SKILL, "%%s", "(.*)");
Lunar.Items.itemSkillText = string.gsub(Lunar.Items.itemSkillText, "%%1$s", "(.*)");
Lunar.Items.itemSkillText = string.gsub(Lunar.Items.itemSkillText, "%%2$d", "%(%%d%)");
Lunar.Items.itemSkillText = string.gsub(Lunar.Items.itemSkillText, "%(%%d%)", "%%((%%d+)%%)");

Lunar.Items.itemMinLevel = string.gsub(ITEM_MIN_LEVEL, "%%d", "(%%d+)");

--"Benötigt %1$s (%2$d)"

--Lunar.Items.itemSkillText2 = string.gsub("%s (%d) requies", "%%s", "(.*)");
--Lunar.Items.itemSkillText2 = string.gsub(Lunar.Items.itemSkillText2, "%(%%d%)", "%%((%%d+)%%)");
--/script local a, b = string.match("mount (300) requies", Lunar.Items.itemSkillText2);
--ITEM_MIN_LEVEL = "Requires Level %d"; -- Required level to use the item
--ITEM_MIN_SKILL
-- Create the item database to be used by the Item module
local itemData = {
	drink		= {},
	food		= {},
	potionHealing	= {},
	potionMana	= {},
	energyDrink	= {},
	ragePotion	= {},
	bandage		= {},
	mount		= {},
	companion	= {},
	hearthstone	= {},
	charges		= {},
--	healthStone	= {},
--	manaStone	= {},
};

-- Create the search database which will store localized search strings
-- generated during initialization
local searchData = {
	drink		= nil,
	food		= nil,
	potionHealing	= nil,
	potionMana	= nil,
	energyDrink	= nil,
	bandage		= nil,
	hearthstone	= nil,
	manaStone	= nil,
	healthStone	= nil,
	weapon		= nil,
	armor		= nil,
	consume		= nil,
	misc		= nil,
	junk		= nil,
	reagent		= nil,
	charges		= nil,
--	poisonAnest	= nil,
--	poisonDeadly	= nil,
--	poisonInstant	= nil,
--	poisonWound	= nil;
--	smallPet	= nil,
};

-- Create our list of low and high indexes for the item database
local itemStrength = {
	drink		= {},
	food		= {},
	potionHealing	= {},
	potionMana	= {},
	energyDrink	= {},
	bandage		= {},
	hearthstone	= {},
	mount		= {},
	ragePotion	= {},
	charges		= {},
	companion	= {},
--	smallPet	= {},
--	healthStone	= {},
--	manaStone	= {},
};

-- Create a list of our item table names
local itemTableNames = {
	"drink",
	"food",
	"potionHealing",
	"potionMana",
	"energyDrink",
	"ragePotion",
	"bandage",
	"mount",
	"hearthstone",
	"charges",
	"companion",
--	"smallPet",
--	"healthStone",
--	"manaStone",
};

-- Create a table that will store bag information. Will store empty slots and total slots
--Lunar.Items.bagSlots = {};

-- Create a list of several items that fit the item spell we might be looking for
-- This list is made of most of the common items the player might have seen. Other
-- items that are not in this list that use the same spells can be found, increasing
-- the total amount of items found.
local itemSpellID = {
	drink		= "00159-01179-01205-01708-01645-08766-28399-27860-05350-03772-08077-08078-08079-02136-30703-22018-02288-",
	food		= "04540-04541-04542-04544-04601-08950-08952-27854-29451-05349-01113-01114-22895-22019-01487-08075-08076-",
	potionHealing	= "00118-00858-00929-01710-03928-13446-22829-",
	potionMana	= "02455-03385-03827-06149-13443-13444-22832-28101-",
	hearthstone	= "06948-",
	energyDrink	= "07676-",
	bandage		= "03530-06450-14529-21990-08544-01251-03531-06451-14530-21991-08545-02581-",
	manaStone	= "05514-05513-08007-08008-22004-",
	healthStone	= "05512-19004-19005-05511-19006-19007-05509-19008-19009-05510-19010-19011-09421-19012-19013-22103-22104-22105-36889-36890-36891-36892-36893-36894",
--	healthStone	= "05509-05510-05511-05512-09421-22103-22104-22105-19004-19005-19006-19007-19008-19009-19010-19011-19012-19013-",
	undersporePod	= "28112-",
	ragePotion	= "05631-13442-05633-",
};

-- Create a list of special items. These all require special locations (PVP battlegrounds, instances, etc)
-- These items will be checked for locations if they are selected as the "best" item in the item
-- database. That way, if we're not in that location, the item is skipped)
local specialUseID = {
	drink		= "00000-",
	food		= "19060-19061-19062-20062-20063-20064-",
	potionHealing	= "32904-32905-",
	potionMana	= "32902-32903-",
	hearthstone	= "00000-",
	energyDrink	= "00000-",
	bandage		= "19066-19067-19068-19307-20065-20066-20067-20232-20234-20235-20237-20243-20244-",
	manaStone	= "00000-",
	healthStone	= "00000-",
	undersporePod	= "00000-",
	ragePotion	= "00000-",
	pvp		= "17348-17349-17351-17352-",
};

-- Create a list of spell types to scan for (if we're missing some)
local itemSpellScan = {};

-- Notate how many item types we're tracking
Lunar.Items.totalItemTypes = table.getn(itemTableNames);

-- Poison images for poison button types
Lunar.Items.poisonImages = {"Spell_Nature_SlowPoison", "Ability_Rogue_DualWeild", "Ability_Poisons", "INV_Misc_Herb_16"};

-- Create a list of our ground and flying mounts, for the random feature
local groundMounts = {};
local flyingMounts = {};
local swimmingMounts = {};
local allMounts = {};
--#local groundMountsEpic = {};
--#local flyingMountsEpic = {};
--#local flyingMountsEpic300 = {};
--#local allMountsEpic = {};
--#local groundMountsNormal = {};

--#local has310Mounts = false;
--#local hasEpicFlyingMounts = false;
--#local hasEpicGroundMounts = false;

-- Table of spell mount icons. (pally/warlock, pally, warlock, druid);
local spellMounts = {[0] = "Interface\\Icons\\Spell_Nature_Swiftness", [1] = "Interface\\Icons\\Ability_Mount_Charger", [2] = "Interface\\Icons\\Ability_Mount_Dreadsteed", [3] = "Interface\\Icons\\Ability_Druid_FlightForm"};

local smallPetType;

--[[
Lunar.Items.updateButton = {
	drink		= {},
	food		= {},
	potionHealing	= {},
	potionMana	= {},
	energyDrink	= {},
	ragePotion	= {},
	bandage		= {},
	mount		= {},
	hearthstone	= {},
};
--]]

-- Create our tooltip sniffer
Lunar.Items.tooltip = CreateFrame("GameTooltip", "LunarItemsTooltip", UIParent, "GameTooltipTemplate");
Lunar.Items.tooltip:SetOwner(UIParent, "ANCHOR_NONE");
Lunar.Items.tooltip:ClearAllPoints();
Lunar.Items.tooltip:SetPoint("Center");
Lunar.Items.tooltip:Hide();

-- /***********************************************
--  * Functions
--  *********************

-- /***********************************************
--  * Initialize
--  * ========================
--  *
--  * Sets up the module
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:Initialize()

	-- Create our event frame
	Lunar.Items.eventFrame = CreateFrame("Frame", "LunarItemsEvents", UIParent);

	-- Register the events we'll be tracking, and then set our frame's scripting
--	Lunar.Items.eventFrame:RegisterEvent("PLAYER_LOGIN");
	Lunar.Items.eventFrame:RegisterEvent("UPDATE_INSTANCE_INFO");
	Lunar.Items.eventFrame:SetScript("OnEvent",	function(self, event, ...) Lunar.Items:OnEvent(event, ...)	 end);
	Lunar.Items.eventFrame:SetScript("OnUpdate",	function(self, elapsed, ...) Lunar.Items:OnUpdate(elapsed, ...) end);

end

-- /***********************************************
--  * OnEvent
--  * ========================
--  *
--  * Handles events for the module
--  *
--  * Accepts: event (passed by OnEvent)
--  * Returns: None
--  *********************
function Lunar.Items:OnEvent(event, arg1)

	-- If the player just logged in, we turn on the initialize flag (removed due to issues with
	-- loading after a patch, when user data takes a little longer to reload)
--	if (event == "PLAYER_LOGIN") then

	-- While the player is loading, the "meeting stone changed" event fires pretty late in the
	-- process, so we use that as the trigger to start scanning our items
	if (event == "UPDATE_INSTANCE_INFO") then
		Lunar.Items.RunInitialize = true;
	end

	-- If there was a bag update, we will take a count of all items in our database, and then
	-- we will scan the updated bag, in case there is a new item that was added. Afterwards,
	-- update the high-low values of our items. This is only ran while out of combat. If you're
	-- in combat, you might be picking up items or using them and these counts don't really
	-- matter much until AFTER combat.
	if (event == "BAG_UPDATE") then

		-- if the arg is 0 (backpack) ... we must also consider that an item with
		-- a charge might have been used. So, set all containers to be scanned.
		-- Otherwise, just do the arg1 container.
		if (arg1 == 0) then
			local index;
			for index = 0, 4 do 
				Lunar.Items["updateContainer" .. index] = true;
--				Lunar.Items["updateContainer" .. index .. "Slot"] = nil;
			end
		elseif (arg1 > 0) then
			Lunar.Items["updateContainer" .. arg1] = true;
--			Lunar.Items["updateContainer" .. arg1 .. "Slot"] = nil;
		end

		if (Lunar.combatLockdown == true) then
			Lunar.Items.combatUpdate = true;
		else
			Lunar.Items.bagUpdateTimer = 0.3;
		end
	end
	
	if (event == "LEARNED_SPELL_IN_TAB") or (event == "COMPANION_LEARNED") then
		Lunar.Items.scanSpellMounts = true;
		Lunar.Items.bagUpdateTimer = 0.2;
	end
end

-- /***********************************************
--  * OnUpdate
--  * ========================
--  *
--  * Handles the initialization of the module when the player's data
--  * is fully loaded into the game.
--  *
--  * Accepts: elapsed (passed by OnUpdate)
--  * Returns: None
--  *********************
function Lunar.Items:OnUpdate(elapsed)

	-- Wait for the initialize instruction...
	if (Lunar.Items.RunInitialize == false) then
		return;		
	end

	-- Now make sure the buttons are loaded:
	if not (Lunar.Button.Loaded) then
		return;
	end
	Lunar.Button.Loaded = nil;
	
	-- Okay, time to set everything up (because the player is loaded and their
	-- BAGS are loaded...)

	-- Turn off the initialize instruction.
	Lunar.Items.RunInitialize = false;

	-- Build our table of localized search strings, and then build our
	-- item data table. After we're done, destroy the functions.
	Lunar.Items:BuildLookupStrings();
--	Lunar.Items:BuildData();

	-- We also stop watching our original events. We're done with those
	Lunar.Items.eventFrame:UnregisterEvent("PLAYER_LOGIN");
	Lunar.Items.eventFrame:UnregisterEvent("UPDATE_INSTANCE_INFO");

	-- Add support for spell mounts (when you learn a new one ... very rare)
	Lunar.Items.eventFrame:RegisterEvent("LEARNED_SPELL_IN_TAB");
	Lunar.Items.eventFrame:RegisterEvent("COMPANION_LEARNED");
	Lunar.Items:ScanForSpellMounts();

	-- Now, setup bag watching functions, so we can check our counts when we receive a new
	-- item or lose one
	Lunar.Items.eventFrame:RegisterEvent("BAG_UPDATE");

	Lunar.Items.bagUpdateTimer = 0.3
	Lunar.Items["updateContainer0"] = true;
	Lunar.Items["updateContainer1"] = true;
	Lunar.Items["updateContainer2"] = true;
	Lunar.Items["updateContainer3"] = true;
	Lunar.Items["updateContainer4"] = true;

	-- Show the startup dialog if it exists (needs to do it here, since everything is loaded)
	if (Lunar.Settings.StartupDialog) then
		Lunar.Settings.StartupDialog:Show();
	end

	-- We're done with this function. Update it to a new version that places a throttle
	-- on the bag updating code.
	Lunar.Items.eventFrame:SetScript("OnUpdate", function (self, arg1)
		if not (Lunar.Items.bagUpdateTimer) then
			return;
		end
		Lunar.Items.bagUpdateTimer = Lunar.Items.bagUpdateTimer - arg1;
		if (Lunar.Items.bagUpdateTimer <= 0) then
			if (Lunar.Items.scanSpellMounts) then
				Lunar.Items.scanSpellMounts = nil;
				Lunar.Items:ScanForSpellMounts();
				Lunar.Items:UpdateLowHighItems();
			end
			if (Lunar.combatLockdown == true) then
				Lunar.Items.combatUpdate = true;
			else
				local bagID;
				for bagID = 0, 4 do 
					if (Lunar.Items["updateContainer" .. bagID] == true) then
						Lunar.Items:UpdateBagContents(bagID, "exists");
--						Lunar.Items.updatedItems = true;
						if (Lunar.Items["updateContainer" .. bagID .. "Slot"] == nil) then
							Lunar.Items["updateContainer" .. bagID] = nil;	
						end
						break;
					end
					if (bagID == 4) then
						Lunar.Items:UpdateItemCounts();
						Lunar.Items.bagUpdateTimer = nil;
						Lunar.Items:UpdateLowHighItems();
						if (Lunar.Button) then
							local buttonID;
							for buttonID = 1, Lunar.Button.buttonCount do 
								if not (LunarSphereSettings.buttonData[buttonID].empty) then
									if (buttonID > 10) then
										Lunar.Button:UpdateCount(getglobal("LunarSub" .. buttonID .. "Button"));
									else
										Lunar.Button:UpdateCount(getglobal("LunarMenu" .. buttonID .. "Button"));
									end	
								end
							end
						end
					end
				end
			end
		end
		
	end);

	if not (LunarSphereSettings.memoryDisableDefaultUI) then
		Lunar.API:HideMinimapTime(LunarSphereSettings.hideTime, true);
	end

	-- Destory these functions, we're done with them.
	Lunar.Debug("LunarSphere memory usage (before memory dump): " .. Lunar.API:MemoryUsage());
	Lunar.Items.BuildLookupStrings = nil;
	Lunar.Items.BuildData = nil;
	Lunar.Items.OnUpdate = nil;
	collectgarbage();
	Lunar.Debug("LunarSphere memory usage (after memory dump): " .. Lunar.API:MemoryUsage());
--	Lunar.API:SupportForDrDamage();
end

-- /***********************************************
--  * DebugPrint
--  * ========================
--  *
--  * Dumps the entire database of recognized items
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:DebugPrint()

	-- Announce who we are
	DEFAULT_CHAT_FRAME:AddMessage("LunarItems Module Debug Mode");
	DEFAULT_CHAT_FRAME:AddMessage("============================");

	-- Announce what we are doing
	DEFAULT_CHAT_FRAME:AddMessage("List of recognized potions, food, drink, mounts, bandages, and hearthstone...");
	DEFAULT_CHAT_FRAME:AddMessage("============================");

	-- Announce our data
	for nameIndex = 1, Lunar.Items.totalItemTypes do 

		if (itemData[itemTableNames[nameIndex]][1]) then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00Catagory: " .. itemTableNames[nameIndex]);
			if (itemStrength[itemTableNames[nameIndex]][0]) then
				DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00Lowest item from '" .. itemTableNames[nameIndex] .. "' catagory: " .. itemData[itemTableNames[nameIndex]][itemStrength[itemTableNames[nameIndex]][0]].name);
				DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00Highest item from '" .. itemTableNames[nameIndex] .. "' catagory: " .. itemData[itemTableNames[nameIndex]][itemStrength[itemTableNames[nameIndex]][1]].name);
			end
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00All items of this type found so far that is or was in inventory:");
			for index = 1, table.getn(itemData[itemTableNames[nameIndex]]) do 
				DEFAULT_CHAT_FRAME:AddMessage(itemData[itemTableNames[nameIndex]][index].name .. ": found " .. itemData[itemTableNames[nameIndex]][index].count);
			end
			DEFAULT_CHAT_FRAME:AddMessage(" ");
		end
	end

	-- Drop our ending line
	DEFAULT_CHAT_FRAME:AddMessage("============================");
end

-- /***********************************************
--  * BuildLookupStrings
--  * ========================
--  *
--  * Stores localized item info into the search database
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:BuildLookupStrings()

	-- Populate the search tables with localized information to be used
	-- for checking items in inventory to see if they are the types of
	-- items we need.

	-- Create our locals
	local key, value, index;
	
	-- First, if we have a saved table of data, load it. While we're doing this, also
	-- delete the itemSpellID data, since we won't be searching for it anymore.
	if (LunarSphereGlobal) then
		if (LunarSphereGlobal.searchData) then
			if (LunarSphereGlobal.searchData[GetLocale()]) then
				for key, value in pairs(LunarSphereGlobal.searchData[GetLocale()]) do
					searchData[key] = value;
					itemSpellID[key] = nil;
				end
			end
		end
	end

	searchData.drink	 = GetSpellInfo(430);
	searchData.food		 = GetSpellInfo(433);
	searchData.potionHealing = GetSpellInfo(441);
	searchData.potionMana	 = GetSpellInfo(2023);
	searchData.energyDrink	 = GetSpellInfo(9512);
	searchData.bandage	 = GetSpellInfo(746);
	searchData.manaStone	 = GetSpellInfo(5405);
	searchData.healthStone	 = GetSpellInfo(6262); --GetSpellInfo(5720);
	searchData.refreshment	 = GetSpellInfo(44166);
	searchData.poisonAnesthetic	= "removed_spell?" --GetSpellInfo(26785);
	searchData.poisonDeadly		= GetSpellInfo(2823);
	searchData.poisonInstant	= GetSpellInfo(8679);
--	searchData.poisonWound		= GetSpellInfo(13219);
	searchData.poisonCatagory	= select(8, GetAuctionItemSubClasses(4));

	Lunar.Locale["_SUMMON"] = select(2, GetSpellInfo(688))

	-- Now, run through each entry in the search data and make sure it has a spell attached to it.
	-- Make sure we skip mount, rage potion, and charges
	for index = 1, Lunar.Items.totalItemTypes do

		if ((itemTableNames[index] ~= "mount") and (itemTableNames[index] ~= "ragePotion") and (itemTableNames[index] ~= "charges") and (itemTableNames[index] ~= "healthStone") and (itemTableNames[index] ~= "companion")) then
			if (searchData[itemTableNames[index]] == nil) then

--				if (itemTableNames[index] == "smallPet") then
--					searchData[itemTableNames[index]] = select(3, GetAuctionItemSubClasses(11));
--				else

					-- Add our current item spell type to the search table
					table.insert(itemSpellScan, itemTableNames[index]);

					-- Grab our spell if it exists. If it does exist, remove it from the search table
					searchData[itemTableNames[index]] = Lunar.Items:GetItemSpell(itemTableNames[index]);
					if (searchData[itemTableNames[index]] ~= nil) then
						table.remove(itemSpellScan);
					end
--				end
			end
		end
	end

	-- Next, make sure we have spells for the mana stones
	if (searchData["manaStone"] == nil) then

		-- Add our current item spell type to the search table
		table.insert(itemSpellScan, "manaStone");

		-- Grab our spell if it exists. If it does exist, remove it from the search table
		searchData.manaStone = Lunar.Items:GetItemSpell("manaStone");
		if (searchData.manaStone ~= nil) then
			table.remove(itemSpellScan);
		end
	end

	-- If there is nothing left for us to search for later on, destroy the search table and the
	-- item spell function.
	if (itemSpellScan) then
		if (table.getn(itemSpellScan) == 0) then
			itemSpellScan = nil;
			Lunar.Items.GetItemSpell = nil;
		end
	end

	local tempWeapon,tempArmor,_,tempConsume = GetAuctionItemClasses()
	local _, tempReagent = GetAuctionItemSubClasses(10);

	if (not searchData.weapon) or (searchData.weapon == "") then
		searchData.weapon = tempWeapon;
		if (not searchData.weapon) or (searchData.weapon == "") then
			_,_,_,_,_,searchData.weapon = GetItemInfo(2139); -- Dirk
		end
	end

	if (not searchData.armor) or (searchData.armor == "") then
		searchData.armor = tempArmor;
		if (not searchData.armor) or (searchData.armor == "") then
			_,_,_,_,_,searchData.armor = GetItemInfo(2960); -- Journeyman's Gloves
		end
	end

	if (not searchData.consume) or (searchData.consume == "") then
		searchData.consume = tempConsume;
		if (not searchData.consume) or (searchData.consume == "") then
			_,_,_,_,_,searchData.consume = GetItemInfo(159); -- Refreshing spring water
		end
	end

	if (not searchData.reagent) or (searchData.reagent == "") then
		searchData.reagent = tempReagent;
		if (not searchData.reagent) or (searchData.reagent == "") then
			_,_,_,_,_,_,searchData.reagent = GetItemInfo(4470); -- Simple Wood
		end
	end

	_,_,_,_,_,searchData.misc,searchData.junk,_ = GetItemInfo(6948);  -- Item: Hearthstone

	-- Store the reagent string as part of the Item module table as well
	Lunar.Items.reagentString = searchData.reagent;

	-- Now, if any of our search data came up nil, let's check if the player has seen other varieties of those
	-- items types and populate our data that way.

	-- Save our searchData to the global variables
	if (not LunarSphereGlobal) then
		LunarSphereGlobal = {};
	end
	if (not LunarSphereGlobal.searchData) then
		LunarSphereGlobal.searchData = {};
	end
	if (not LunarSphereGlobal.searchData[GetLocale()]) then
		LunarSphereGlobal.searchData[GetLocale()] = {};
	end

	-- Save our standard data
	for index = 1, Lunar.Items.totalItemTypes - 2 do
		LunarSphereGlobal.searchData[GetLocale()][itemTableNames[index]] = searchData[itemTableNames[index]];
	end

	-- Now save our mana stone data
	LunarSphereGlobal.searchData[GetLocale()].manaStone = searchData.manaStone;

end

function Lunar.Items:GetItemSpell(itemCatagory)

	local index, itemSpell;

	for index = 1, (string.len(itemSpellID[itemCatagory]) / 6) do 
		itemSpell = GetItemSpell(tonumber(string.sub(itemSpellID[itemCatagory], (index - 1) * 6 + 1, index * 6 - 1)));
		if (itemSpell) then
			break;
		end
	end

	return itemSpell;

end

-- /***********************************************
--  * BuildData
--  * ========================
--  *
--  * Stores localized item into the search database
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:BuildData()

	-- Safety code, to ensure that we have the search lookup data before we
	-- continue. This would only happen if the module was created improperly
	-- (i.e., not initialized)
	if (searchData.drink == nil) then
		Lunar.Items:BuildLookupStrings();
	end

	-- Create our local variables
--	local container;

	-- Start scanning our containers
--	for container = 0, 4 do
--		Lunar.Items:UpdateBagContents(container, "add");
--	end

	-- Now, turn off our debug print. Ew.
	Lunar.Items.debugItemPrint = nil;

	-- Now update our high-low values for the items
--	Lunar.Items:UpdateLowHighItems();

end

-- /***********************************************
--  * UpdateItemCounts
--  * ========================
--  *
--  * Crawls through the item database and refreshes each item's count
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:UpdateItemCounts()

	-- Create our locals
	local nameIndex, index;

	-- Scan each name catagory
	for nameIndex = 1, Lunar.Items.totalItemTypes do 

		if (itemTableNames[nameIndex] ~= "mount") then
		-- If there are items in this catagory ...
			if (itemData[itemTableNames[nameIndex]][1]) then

				-- Cycle through each item and assign its count.
				for index = 1, table.getn(itemData[itemTableNames[nameIndex]]) do 
					itemData[itemTableNames[nameIndex]][index].count = GetItemCount(itemData[itemTableNames[nameIndex]][index].name);
					itemData[itemTableNames[nameIndex]][index].count = GetItemCount(itemData[itemTableNames[nameIndex]][index].name, nil, true);
				end
			end
		end
	end
end

-- /***********************************************
--  * UpdateLowHighItems
--  * ========================
--  *
--  * Crawls through the item database and updates the lowest and highest
--  * leveled item per catagory
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:UpdateLowHighItems()

	-- Create our locals
	local nameIndex, index, low, high, lowSpecial, highSpecial, lowCombo, highCombo, itemType
	local lowCooldown, highCooldown, lowNoCooldown, highNoCooldown, usableItem, bestRange;
	local cooldown;
--	local hasEpicGroundMount, hasEpicFlyingMount, hasEpicFlyingMount310;
	local canFly = Lunar.API:CanFly(); 
	local inAQ = Lunar.API:IsInAQ();

	local playerLevel = UnitLevel("player");
	bestRange = 100;
	if (playerLevel < 40) then
		bestRange = 1;
	end


	-- Wipe our ground and flying mounts table
	for index = 1, table.getn(groundMounts) do 
		groundMounts[index] = nil;
	end
	for index = 1, table.getn(flyingMounts) do 
		flyingMounts[index] = nil;
	end
	for index = 1, table.getn(swimmingMounts) do 
		swimmingMounts[index] = nil;
	end
--	for index = 1, table.getn(allMounts) do 
--		allMounts[index] = nil;
--	end


	-- Scan each name catagory
	for nameIndex = 1, Lunar.Items.totalItemTypes do 

		-- Reset our highest and lowest values
		lowCombo = nil;
		highCombo = nil;
		low = nil;
		high = nil;
		lowSpecial = nil;
		highSpecial = nil;
		lowNoCooldown = nil;
		highNoCooldown = nil;
		itemType = itemTableNames[nameIndex];

		-- If there are items in this catagory ...
		if (itemType ~= "companion") and (itemType ~= "energyDrink") and (itemData[itemTableNames[nameIndex]][1]) then

			-- Cycle through each item and assign its count.
			for index = 1, table.getn(itemData[itemType]) do 
			
				-- If the item is within level range and has a count, continue
				if ((itemData[itemType][index].level <= playerLevel) and ((itemData[itemType][index].count > 0) or (itemData[itemType][index].spell))) then

					if Lunar.Items:CheckItemUseStatus(itemData[itemType][index].itemID, itemType) then

						-- If our lowest and highest haven't been set, set them to the current index
						if (low == nil) and (itemData[itemType][index].strength < 2000) then
							low = index;
							high = index;
							if (not lowCombo) then
								lowCombo = index;
								highCombo = index;
							end
						end

						-- If our lowest and highest specials don't exists, set them to the current index
						if (lowSpecial == nil) and (itemData[itemType][index].strength > 2000) then 
							lowSpecial = index;
							highSpecial = index;
							if (not lowCombo) then
								lowCombo = index;
								highCombo = index;
							end
						end

-- Mount Stuff is Here.
						if (itemType == "mount") then -- Sets up the various mount databases
							local MountType = itemData[itemType][index].count;

							if (bit.band(MountType, 8) == 8) then -- 8
								table.insert(swimmingMounts, index);
							end

							-- flying and Ground Mounts only
							if (bit.band(MountType, 2) == 2) then -- Only when CanFly
								table.insert(flyingMounts, index);
							elseif (bit.band(MountType, 1) == 1) then -- Ground Mounts Only.
								table.insert(groundMounts, index);
							end

--							table.insert(allMounts, index);
-- Abysmal seahorse = 75207

						end

						-- If we have the high or low index already found, continue
						if (high) then

							-- If we found an item that's higher than or equal to the current highest, make it the new highest
							if (itemData[itemType][index].strength >= itemData[itemType][high].strength) and (itemData[itemType][index].strength < 2000) then
								high = index;
							end

							-- If we found an item that's lower than or equal to the current lowest, and this item is
							-- not already set as the highest item, make it the new lowest
							if (itemData[itemType][index].strength <= itemData[itemType][low].strength) and (itemData[itemType][index].strength < 2000) then
								if (high ~= index) then
									low = index;
								end
							end

						end

						-- If we have the high or low combos found, continue
						if (highCombo) then

							-- If we found an item that's higher than or equal to the current combo highest, make it the new highest
							if (itemData[itemType][index].strength >= itemData[itemType][highCombo].strength) then
								if ((select(2, Lunar.API:GetItemCooldown(itemData[itemType][index].name))) or (0)) <= 1 then
--								if (Lunar.API:GetItemCooldown(itemData[itemType][index].name) or (0)) == 0 then
									highNoCooldown = index;
								end
								highCombo = index;
							end

							-- If we found an item that's lower than or equal to the current combo lowest, and this item is
							-- not already set as the highest item, make it the new lowest
							if (itemData[itemType][index].strength <= itemData[itemType][lowCombo].strength) then
								if (highCombo ~= index) then
									if ((select(2, Lunar.API:GetItemCooldown(itemData[itemType][index].name))) or (0)) <= 1 then
--									if (Lunar.API:GetItemCooldown(itemData[itemType][index].name) or (0)) == 0 then
										lowNoCooldown = index;
									end
									lowCombo = index;
								end
							end
							
						end

						-- If we have the high or low special found, continue
						if (highSpecial) then

							-- If we found a special item that's higher than or equal to the current highest, make it the new highest
							if (highSpecial) then
								if (itemData[itemType][index].strength >= itemData[itemType][highSpecial].strength) and (itemData[itemType][index].strength > 2000) then
									highSpecial = index;
								end
							end

							-- If we found a special item that's lower than or equal to the current lowest, and this item is
							-- not already set as the highest item, make it the new lowest
							if (highSpecial) then
								if (itemData[itemType][index].strength <= itemData[itemType][lowSpecial].strength) and (itemData[itemType][index].strength > 2000) then
									if (highSpecial ~= index) then
										lowSpecial = index;
									end
								end
							end
						end

					end
				end
			end

		-- The energy drink section contains energy drinks and poisons, so I made this section a little odd...
		elseif (itemType == "energyDrink") then

			local itemStrength;

			-- Cycle through each item and assign its count.
			for index = 1, table.getn(itemData[itemType]) do 
			
				-- If the item is within level range and has a count, continue
				if (itemData[itemType][index].level <= playerLevel) and (itemData[itemType][index].count > 0) then

					if Lunar.Items:CheckItemUseStatus(itemData[itemType][index].itemID, itemType) then
						
						itemStrength = itemData[itemType][index].strength;

						-- Deal with the energy drinks
						if (itemStrength < 1000) then
							
							-- Initialize our data
							if (low == nil) then
								low = index;
								high = index;

							-- Or work with existing data
							else

								-- If we found an item that's higher than or equal to the current highest, make it the new highest
								if (itemStrength >= itemData[itemType][high].strength) then
									high = index;
								end

								-- If we found an item that's lower than or equal to the current lowest, and this item is
								-- not already set as the highest item, make it the new lowest
								if (itemStrength <= itemData[itemType][low].strength) then
									if (high ~= index) then
										low = index;
									end
								end
							end

						-- Anesthetic poisons
						elseif (itemStrength >= 1000) and (itemStrength < 2000)  then

							-- Initialize our data
							if (lowSpecial == nil) then
								lowSpecial = index;
							
							-- Or work with existing data and if we found a higher strength, set it.
							else
								if (itemStrength >= itemData[itemType][lowSpecial].strength) then
									lowSpecial = index;
								end
							end

						-- Deadly poisons
						elseif (itemStrength >= 2000) and (itemStrength < 3000)  then
							
							-- Initialize our data
							if (highSpecial == nil) then
								highSpecial = index;
							
							-- Or work with existing data and if we found a higher strength, set it.
							else
								if (itemStrength >= itemData[itemType][highSpecial].strength) then
									highSpecial = index;
								end
							end
						
						-- Instant poisons
						elseif (itemStrength >= 3000) and (itemStrength < 4000)  then
							
							-- Initialize our data
							if (lowCombo == nil) then
								lowCombo = index;
							
							-- Or work with existing data and if we found a higher strength, set it.
							else
								if (itemStrength >= itemData[itemType][lowCombo].strength) then
									lowCombo = index;
								end
							end
						
						-- Wound poisons
						elseif (itemStrength >= 4000) and (itemStrength < 5000)  then
							
							-- Initialize our data
							if (highCombo == nil) then
								highCombo = index;
							
							-- Or work with existing data and if we found a higher strength, set it.
							else
								if (itemStrength >= itemData[itemType][highCombo].strength) then
									highCombo = index;
								end
							end
						end

					end
				end
			end

		end

-- Mount Stuff is Here.
		-- Assign our new higher and lower values. We do things differently if it's
		-- the mount catagory though...
		if (itemType == "mount") then

			RndGround = nil;
			RndFly = nil;
			RndSwim = nil;
			RndMount = nil;


			if (table.getn(groundMounts) > 0) then
				RndGround = groundMounts[math.random(table.getn(groundMounts))];
			end
			
			if (table.getn(flyingMounts) > 0) then
				RndFly = flyingMounts[math.random(table.getn(flyingMounts))];
			end
			
			if (table.getn(swimmingMounts) > 0) and (IsSwimming()) then
				RndSwim = swimmingMounts[math.random(table.getn(swimmingMounts))];
			end
			
			if (table.getn(allMounts) > 0) then
				RndMount = allMounts[math.random(table.getn(allMounts))];
			end

			if (canFly) then
				itemStrength[itemType][0] = RndFly;		-- Random Flying Mount
			elseif (IsSwimming()) then
				itemStrength[itemType][0] = RndSwim;		-- Or Swimming Mount
			else
				itemStrength[itemType][0] = RndGround;		-- Otherwise a Ground Mount
			end
			itemStrength[itemType][1] = RndGround;			-- ground mounts
			itemStrength[itemType][2] = RndFly;			-- flying mounts
			itemStrength[itemType][3] = RndSwim;			-- Swimming mounts

		else

			-- Now, if the highCombo is different than the highNoCooldown, we use the item
			-- with no cooldown. The same for lowCombo/lowNoCooldown
			if (highCombo ~= highNoCooldown) and (highNoCooldown ~= nil) then
				highCombo = highNoCooldown
			end
			if (lowCombo ~= lowNoCooldown) and (lowNoCooldown ~= nil) then
				lowCombo = lowNoCooldown
			end

			itemStrength[itemType][0] = lowCombo;
			itemStrength[itemType][1] = highCombo;
			itemStrength[itemType][2] = low;
			itemStrength[itemType][3] = high;
			itemStrength[itemType][4] = lowSpecial;
			itemStrength[itemType][5] = highSpecial;
		end
	end

	-- Now, the healing and mana items need to be ordered some more, by type.
	-- The index ranges are as follows:
	-- 0 = lowest item
	-- 1 = highest item
	-- 2 = lowest potion
	-- 3 = highest potion
	-- 4 = lowest stone
	-- 5 = highest stone
	-- First, copy over the 0 and 1 strengths to the 2 and 3 (since these are just potions)
	-- Then, copy over the 0 and 1 strengths from the healthstones to this table
	-- Lastly, we check the strength of the potion against the healthstone. The strongest
	-- and weakest of the two become the 0 and 1 index again.
--	if (itemStrength[itemTableNames[3]]) then
--		local lowPotionIndex, lowStoneIndex, highPotionIndex, highStoneIndex;
--		local lowPotionStr, lowStoneStr, highPotionStr, highStoneStr;
--
--		lowPotionIndex = itemStrength[itemTableNames[3]][0];
--		highPotionIndex = itemStrength[itemTableNames[3]][1];
--		
--		itemStrength[itemTableNames[3]][2] = lowPotionIndex;
--		itemStrength[itemTableNames[3]][3] = highPotionIndex;
--		lowStoneIndex = itemStrength[itemTableNames[11]][0];
--		highStoneIndex = itemStrength[itemTableNames[11]][1];
--		if (itemStrength[itemTableNames[11]]) and (lowStoneIndex) then
--
--			itemStrength[itemTableNames[3]][4] = lowStoneIndex;
--			itemStrength[itemTableNames[3]][5] = highStoneIndex;
--			lowStoneStr = itemData[itemTableNames[11]][lowStoneIndex].strength or (999) 
--			highStoneStr = itemData[itemTableNames[11]][highStoneIndex].strength or (0) 
--			lowPotionStr = itemData[itemTableNames[3]][lowPotionIndex].strength or (999) 
--			highPotionStr = itemData[itemTableNames[3]][highPotionIndex].strength or (0)
--
--			if (lowStoneStr <= lowPotionStr) then
--				itemStrength[itemTableNames[3]][0] = lowStoneIndex;
--			end
--			if (highStoneStr >= highPotionStr) then
--				itemStrength[itemTableNames[3]][1] = highStoneIndex;
--			end

--		end
--	end


	-- Now, update any button that needs updating
	if (Lunar.combatLockdown == true) then
		Lunar.Items.combatUpdate = true;
	else
		Lunar.Items:UpdateSpecialButtons();
	end

end

function Lunar.Items:CheckItemUseStatus(itemID, itemType)

	local usable = true;

	-- Specific location item check
	if string.find((specialUseID[itemType] or ("00000/")), itemID) then --and (itemID ~= "spellMount") then

		usable = nil;

		-- Set our tooltip up
		
		Lunar.Items.tooltip:ClearLines();
		Lunar.Items.tooltip:SetOwner(UIParent, "ANCHOR_NONE");
		Lunar.Items.tooltip:SetHyperlink("item:" .. itemID);

		-- Scan each line until all have been scanned or a match was found

		local searchText, textContainer, textLine;
		
		for textLine = 2, Lunar.Items.tooltip:NumLines() do
							
			searchText = nil;
			textContainer = getglobal(Lunar.Items.tooltip:GetName() .. "TextLeft" .. textLine);
			if (textContainer) then
				searchText = textContainer:GetText();
			end

			if (searchText) then
				if string.find(searchText, GetRealZoneText()) then
					usable = true;
					break;
				end
			end
		end
	end
	-- Generic PVP battleground item check

	if string.find(specialUseID.pvp, itemID) then
		usable = nil;
		if ((GetNumBattlefieldStats() or (0)) > 0) then
			usable = true;
		end
	end

	return usable;

end

function Lunar.Items:UpdateSpecialButtons()

	local index, clickType, buttonType, stance, button, lastUsedUpdate, objectTexture;
	local actionType, state

	-- Clear the cursor update information, since we don't need 'em.
	Lunar.Button.updateType, Lunar.Button.updateID, Lunar.Button.updateData = nil, nil, nil;

	-- Cycle through all buttons that have content
	for index = 0, 130 do

		if not (LunarSphereSettings.buttonData[index].empty) then

			if (index > 10) then
				button = getglobal("LunarSub" .. index .. "Button")
			elseif (index == 0) then
				button = getglobal("LSmain")
			else							
				button = getglobal("LunarMenu" .. index .. "Button")
			end

			editFound = nil;

			if (button) then

			-- Cycle through all stances we could use
			for stance = 0, GetNumShapeshiftForms() do 
				
				for clickType = 1, 3 do 
					buttonType = Lunar.Button:GetButtonType(index, stance, clickType) or (0);

					lastUsedUpdate = nil;
					if (buttonType == 3) and (button.subButtonType) then
						lastUsedUpdate = buttonType;
						buttonType = button.subButtonType;
					end

--					buttonType = Lunar.Button:GetButtonType(index, stance, clickType);

--					if (buttonType) then
					if (buttonType >= 10) then
--						if ((buttonType >= 10) and (buttonType < 80)) or ((buttonType >= 120) and (buttonType < 130)) then
--							if (index > 10) then
--								Lunar.Button:AssignByType(getglobal("LunarSub" .. index .. "Button"), clickType, buttonType, stance);
--							else
--								Lunar.Button:AssignByType(getglobal("LunarMenu" .. index .. "Button"), clickType, buttonType, stance);
--							end
--						end
--
						if ((buttonType >= 10) and (buttonType < 90)) or ((buttonType >= 110) and (buttonType < 130)) or (buttonType == 132) then
--here
							Lunar.Button:AssignByType(button, clickType, buttonType, stance, lastUsedUpdate);
							if (index > 10) then
								state = getglobal("LunarMenu" .. button.parentID .. "ButtonHeader"):GetAttribute("state");
							elseif (index == 0) then
								state = getglobal("LunarSphereMainButtonHeader"):GetAttribute("state");
							else
								state = getglobal("LunarMenu" .. index .. "ButtonHeader"):GetAttribute("state");
							end

							if (tonumber(state) == stance) then
								
								actionType = button:GetAttribute("*type-S" .. state .. clickType);
								button:SetAttribute("*spell" .. clickType, "");
								button:SetAttribute("*action" .. clickType, "");
								button:SetAttribute("*item" .. clickType, "");
								button:SetAttribute("*macro" .. clickType, "");
								button:SetAttribute("*macrotext" .. clickType, "");
								if (LunarSphereSettings.buttonEditMode ~= true) and (actionType) and (actionType ~= "none") then
									actionName = button:GetAttribute("*" .. actionType .. "-S" .. state .. clickType);
									actionName2 = button:GetAttribute("*" .. actionType .. "2-S" .. state .. clickType);
									if (actionType == "macrotext") then
										button:SetAttribute("*type" .. clickType, "macro");
									else
										button:SetAttribute("*type" .. clickType, actionType);
									end
									if (actionName2) then
										button:SetAttribute("*" .. actionType .. clickType, actionName2);
									else
										button:SetAttribute("*" .. actionType .. clickType, actionName);
									end
								else
									button:SetAttribute("*type" .. clickType, "spell");
								end
							end

						
						-- Bag buttons!
						elseif (buttonType >= 90) and (buttonType <= 95) and (stance == button.currentStance) then
							objectTexture = Lunar.Button:GetBagTexture(buttonType);
							if (Lunar.Button:GetButtonSetting(index, stance, LUNAR_GET_SHOW_ICON) == clickType) then
								if (button.texture) then
									button.texture:SetTexture(objectTexture);
									SetPortraitToTexture(button.texture, objectTexture);
								elseif (index == 0) then
									Lunar.Sphere:SetSphereTexture();
								end
							end
							
							if (Lunar.Button:GetButtonSetting(index, stance, LUNAR_GET_SHOW_COUNT) == clickType) then
								Lunar.Button:UpdateBagDisplay(button, stance, clickType);
							end
						end
					end
				end
			end
			end -- end the  if (button) then
		end
	end

--	for index = 1, 10 do 
--		getglobal("LunarMenu" .. index .. "ButtonHeader"):SetAttribute("state-state", getglobal("LunarMenu" .. index .. "ButtonHeader"):GetAttribute("state"));
--	end

--	getglobal("LunarSphereMainButtonHeader"):SetAttribute("state-state", getglobal("LunarSphereMainButtonHeader"):GetAttribute("state"));

	if (Lunar.Button.currentMouseOverFrame ~= nil) then
		Lunar.Button.tooltipStance = nil;
		Lunar.Button:SetTooltip(Lunar.Button.currentMouseOverFrame);
	end

end

function Lunar.Items:GetItem(catagory, subIndex, onlyConjured)

	local returnedItem = "";
	local catagory1, catagory2, catagory3;
--	if (catagory <= 7) then
--	if (not itemStrength[catagory]) then
--		return "";
--	end

	if (catagory == "companion") then
		if (itemData[catagory][1]) then
			-- Pick a random companion
			returnedItem = itemData[catagory][math.random(1, table.getn(itemData[catagory]))].name
		end
	else
		if (itemStrength[catagory][subIndex]) then
			if (itemData[catagory][itemStrength[catagory][subIndex]]) then
				returnedItem = itemData[catagory][itemStrength[catagory][subIndex]].name;

				if (onlyConjured == true) and (itemData[catagory][itemStrength[catagory][subIndex]].strength < 1000) then
					returnedItem = "";
				end
			end
		end
	end

-- Idea. If the itemStrength is a string, do a search for (1)::(2) where 1 will be the
-- catagory to pull the data from, and 2 will be the index.


--		if (itemStrength[catagory][0]) then
--			returnedItem = itemData[catagory][itemStrength[catagory][0] ].name;
--		end
--	else
--		if (itemStrength[catagory][1]) then
--			returnedItem = itemData[catagory][itemStrength[catagory][1] ].name;
--		end
--	end

	return returnedItem;
	
end

function Lunar.Items:GetCatagoryName(index)
	return itemTableNames[index];
end

function Lunar.Items:GetItemType(index)
	return searchData[index];
end

function Lunar.Items:FindItemInCatagory(catagory, itemName)
	local index, found;

	if (catagory == "mount") then
		for index = 1, table.getn(allMounts) do 
			if (itemName == itemData["mount"][allMounts[index]].spell) then
				found = true;
				break;
			end
		end
	elseif (catagory == "flyingMount") then
		for index = 1, table.getn(flyingMounts) do 
			if (itemName == itemData["mount"][flyingMounts[index]].spell) then
				found = true;
				break;
			end
		end
	elseif (catagory == "swimmingMount") then
		for index = 1, table.getn(swimmingMounts) do 
			if (itemName == itemData["mount"][swimmingMounts[index]].spell) then
				found = true;
				break;
			end
		end
	elseif (catagory == "groundMount") then
		for index = 1, table.getn(groundMounts) do 
			if (itemName == itemData["mount"][groundMounts[index]].spell) then
				found = true;
				break;
			end
		end
	elseif (catagory == "companion") then
		for index = 1, table.getn(itemData["companion"]) do 
			if (itemName == itemData["companion"][index].spell) then
				found = true;
				break;
			end
		end
	else
		for index = 1, table.getn(itemData[catagory]) do 
			if (itemName == itemData[catagory][index].name) then
				found = true;
				break;
			end
		end
	end
	return found;
end

function Lunar.Items:CompareItemSpellCatagory(compareSpell, itemCatagory)

	-- Set our locals
	local index, itemSpell;
	itemSpell = nil;

	-- Search though all items of the item catagory and see if we found a match. If there is a match, return
	-- the spell name that was matched. Otherwise, it will be nil.
	for index = 1, (string.len(itemSpellID[itemCatagory]) / 6) do 
		if (compareSpell == GetItemSpell(tonumber(string.sub(itemSpellID[itemCatagory], (index - 1) * 6 + 1, index * 6 - 1)))) then
			itemSpell = compareSpell;
			break;
		end
	end

	return itemSpell;

end

function Lunar.Items:BuildSpellMountData()

	local locale = string.sub(GetLocale(), 1, 2);
	local db = Lunar.Items;
	
	-- Translations from google and some comparisons of tooltips found
	-- on wowhead.com. Various google translations to try and fine the
	-- korean and chinese translations that will hopefully work...

	Lunar.Items.BuildSpellMountData = nil;

end

function Lunar.Items:ScanForSpellMounts()

	local index, spellID, textLine, searchText, textContainer, speed, itemLevel, mountType, spellName, spellTexture;
	local _, Usable, NoMana, String1;

	local locKalimdor, locEastern, locOutland, locNorthrend, locMaelstrom, locPandaren = GetMapContinents();

	local LunarProfValue = Lunar.API:UserGetProfession();

-- Mount Stuff is Here.
	for index = 1, GetNumCompanions("mount") do 
		_, spellName, spellID, spellTexture, _, mountType = GetCompanionInfo("mount", index);

		Usable, _ = IsUsableSpell(spellID);

		speed = 60;
		itemLevel = 20;

		if (Usable) then
--[[			-- Blizzcon mounts
			if (spellID == 58983) then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 5, 20, "spellMount");
			-- Headless horseman, Love rocket, arthas mount, and celestial steed mount (these scale with riding)
			elseif (spellID == 48025) or (spellID == 71342) or (spellID == 72286) or (spellID == 75614) then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 6, 20, "spellMount");
			-- DK flying mount (these scale with riding)
			elseif (spellID == 54729) then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 7, 60, "spellMount");
			-- AQ mounts
			elseif (spellID == 26056) or (spellID == 25953) or (spellID == 26054) or (spellID == 26055)  then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 8, 40, "spellMount");
			-- Sea Turtle mount... is slow
			elseif (spellID == 64731) then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 20 + 60, 20, "spellMount");
			-- Mechano-Hog and Mekgineer's Chopper motorcycle
			elseif (spellID == 60424) or (spellID == 55531) then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 40 + 100, 40, "spellMount");
			-- Violet Proto-Drake, new Onyxia mount, and Mimiron's Head (freaking tooltip...)
			elseif (spellID == 60024) or (spellID == 69395) or (spellID == 63796) then
				Lunar.Items:ModifyItemDataTable("mount", "exists", "**" .. spellID, mountType, 70 + 2310, 70, "spellMount");
			else]]--


			spellName = "**" .. spellID --.. "~" .. spellName .. "~" .. spellTexture; 



			-- flying machines (engineering)
			if ((spellID == 44151) or (spellID == 44153)) then
				if (Lunar.API:UserHasProfession(LunarProfValue, 128)) then
					Lunar.Items:ModifyItemDataTable("mount", "exists", spellName, mountType, 1, 60, "spellMount");
				end
			-- flying Carpets (Tailor)
			elseif ((spellID == 61309) or (spellID == 61451) or (spellID == 75596)) then
				if (Lunar.API:UserHasProfession(LunarProfValue, 8)) then
					Lunar.Items:ModifyItemDataTable("mount", "exists", spellName, mountType, 1, 60, "spellMount");
				end
			--  Jeweled Panthers (Jewelcrafting)
			elseif ((spellID == 82543) or (spellID == 83087) or (spellID == 83088) or (spellID == 83089) or (spellID == 83090)) then
				if (Lunar.API:UserHasProfession(LunarProfValue, 32)) then
					Lunar.Items:ModifyItemDataTable("mount", "exists", spellName, mountType, 1, 20, "spellMount");
				end
			-- All other mounts
			else
				Lunar.Items:ModifyItemDataTable("mount", "exists", spellName, mountType, 1, 20, "spellMount");
			end
		end
	end

--	for index = 1, C_PetJournal.GetNumPets(false) do -- GetNumCompanions("critter") do 
--		_, spellName, spellID, spellTexture = GetCompanionInfo("critter", index);
--		_, _, _, _, _, _, _, spellName, spellTexture, _, spellID = C_PetJournal.GetPetInfoByIndex(index);
--		spellID, _, _, _, _, _, _, spellName, spellTexture  = C_PetJournal.GetPetInfoByIndex(index);
--		spellName = "**" .. spellID
--
--		Lunar.Items:ModifyItemDataTable("companion", "exists", spellName, 1, 1, 1, "spellMount");
--	end

end

-- /***********************************************
--  * UpdateBagContents
--  * ========================
--  *
--  * Searches a bag and update the item data table with any new contents found
--  *
--  * Accepts: bagID, updateType ("add" or "exists")
--  * Returns: None
--  *********************
function Lunar.Items:UpdateBagContents(bagID, updateType)

	-- We only care about the bags of the player. If it's a bank bag, abort now
	if (bagID > 4) then
		return;
	end
	
	local userLocale = GetLocale();

	-- Create our local variables
	local slot, itemCount, itemSpell, spellRank, locIndex;
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemID;
	local searchText, textLine, textContainer, startLoc, endLoc, itemCharges;
	local key, value;
	local mountType, mountFound;

--	if not (Lunar.Items.bagSlots[bagID]) then
--		Lunar.Items.bagSlots[bagID] = 0;
--	end

	local scanSize = 8;
	local startSlot = 1;
	local endSlot = GetContainerNumSlots(bagID);
	if (Lunar.Items["updateContainer" .. bagID .. "Slot"]) then
		startSlot = Lunar.Items["updateContainer" .. bagID .. "Slot"];
		if (startSlot > endSlot) then
			Lunar.Items["updateContainer" .. bagID .. "Slot"] = nil;
			return;
		end
	else
		Lunar.Items["updateContainer" .. bagID .. "Slot"] = startSlot + scanSize;
	end

	if ((startSlot + scanSize - 1) <= endSlot) then
		endSlot = startSlot + scanSize - 1;
		Lunar.Items["updateContainer" .. bagID .. "Slot"] = endSlot + 1;
	else
		Lunar.Items["updateContainer" .. bagID .. "Slot"] = nil;
	end

--	if (startSlot == 1) then
--		Lunar.Items.bagSlots[bagID] = 0;
--	end

	-- If we're scanning slot #1, we run through our item charges database and if any data is stored
	-- for this particular bag, destory it. The counts will be rebuilt with these scans.
	if (startSlot == 1) then

		-- Next, check to see if we have item spells that need to be grabbed
		if (itemSpellScan) then

			-- Set our locals and our start and end positions
			local index, spellCount;
			index = 1;
			spellCount = table.getn(itemSpellScan)

			-- loop until we checked each table entry
			while (index <= spellCount) do 

				-- Grab the spell data. If it exists, remove the current item from the search table and
				-- add the new data to the saved global settings. Otherwise, increase the index and try
				-- another item spell
				searchData[itemSpellScan[index]] = Lunar.Items:GetItemSpell(itemSpellScan[index]);
				if (searchData[itemSpellScan[index]] ~= nil) then
					LunarSphereGlobal.searchData[userLocale][itemSpellScan[index]] = searchData[itemSpellScan[index]];
					table.remove(itemSpellScan, index);
					spellCount = spellCount - 1;
				else
					index = index + 1;
				end
			end

			-- If there is nothing left for us to search for later on, destroy the search table
			-- and the item spell function
			if (table.getn(itemSpellScan) == 0) then
				itemSpellScan = nil;
				Lunar.Items.GetItemSpell = nil;
			end
		end

	end

	-- Start scanning the slots of the current container
	for slot = startSlot, endSlot do

		-- Grab the slot's item link
		itemLink = GetContainerItemLink(bagID, slot);

		-- If the slot was not empty, then we have an item link, which means
		-- we are currently looking at an item. Continue.
		if (itemLink) then
			
--			Lunar.Items.bagSlots[bagID] = Lunar.Items.bagSlots[bagID] + 1;

			-- With our new link, grab all of the item's details
			itemName, _, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount = GetItemInfo(itemLink);

			-- Set our tooltip up
			Lunar.Items.tooltip:ClearLines();
			Lunar.Items.tooltip:SetOwner(UIParent, "ANCHOR_NONE");
			Lunar.Items.tooltip:SetBagItem(bagID, slot);

			-- Grab the item ID 
			itemID = Lunar.API:GetItemID(itemLink);

			mountType = nil;
			mountFound = nil;

--			if (itemSubType == searchData.smallPet) then
--				Lunar.Items:ModifyItemDataTable("smallPet", updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);
--			end
--[[
			if (itemStackCount) then

				-- If this is not a piece of armor, a weapon, or stacks more than 1, continue with the scan
				if (not ((itemType == searchData.weapon) or (itemType == searchData.armor)) and not (itemStackCount > 1)) then

--[ [
					-- Mount scanning
					if (itemType == searchData.misc) or (itemID == 34060) or (itemID == 34061) then

						-- Scan each line until all have been scanned or a match was found
						for textLine = 2, Lunar.Items.tooltip:NumLines() do
							
							searchText = nil;
							textContainer = getglobal(Lunar.Items.tooltip:GetName() .. "TextLeft" .. textLine);
							if (textContainer) then
								searchText = textContainer:GetText();
							end

							if (searchText) then

								-- Assuming that conjured items don't have charges,
								-- if the item has the conjured text in it, we end now
								if string.find(searchText, ITEM_CONJURED) then
									break;
								end
--[ [
								-- Search for mount data
								if (itemType == searchData.misc) or (itemID == 34060) or (itemID == 34061) then
									if (string.find(searchText, Lunar.Items.itemMinLevel)) then
										mountType = 0;
									elseif (string.find(searchText, Lunar.Items.itemSkillText)) and (mountType == 0)  then
										if (itemRarity) then
											if (itemRarity > 2) then
												mountType = string.match(searchText, "(%d+)");
												mountType = tonumber(mountType);

												-- Flying mount
												if (mountType > 150) then
													mountType = mountType + 2000;
												end

												-- Epics are faster than normal
												if (itemRarity > 3) and (mountType > 75) then
													itemLevel = itemLevel + 1;
												end

												mountFound = true;
												break;
											end
										end
									end
								end
--] ]
							end
						end
					end
--] ]
				end
			end
--]]
			-- Now, if this item is a consumable item ... (or the broken Mana Agate which thinks
			-- it is ARMOR (wtf?!)
			if (itemType == searchData.consume) or (itemID == 5514) or (itemID == 32578)  then

				-- Figure out what spell it casts, if any.
				itemSpell, spellRank = GetItemSpell(itemName);

				if (itemSpell) then
-- Already done at the top
--					itemID = Lunar.API:GetItemID(itemLink);

					-- If we found a spell, we'll grab how many of that item is in the slot.
					-- That way, we can populate the item database with a count of said item.
					_, itemCount = GetContainerItemInfo(bagID, slot);

					-- Check if it is a poison (quick check for "Item Enchancement")
					if (itemSubType == searchData.poisonCatagory) then
						-- itemMinLevel = 2;
						if string.find(itemSpell, searchData.poisonAnesthetic) then
							Lunar.Items:ModifyItemDataTable("energyDrink", updateType, itemName, itemCount, itemLevel + 1000, itemMinLevel, itemLink);
							itemSpell = nil;
						elseif string.find(itemSpell, searchData.poisonDeadly) then
							Lunar.Items:ModifyItemDataTable("energyDrink", updateType, itemName, itemCount, itemLevel + 2000, itemMinLevel, itemLink);
							itemSpell = nil;
						elseif string.find(itemSpell, searchData.poisonInstant) then
							Lunar.Items:ModifyItemDataTable("energyDrink", updateType, itemName, itemCount, itemLevel + 3000, itemMinLevel, itemLink);
							itemSpell = nil;
--						elseif string.find(itemSpell, searchData.poisonWound) then
--							Lunar.Items:ModifyItemDataTable("energyDrink", updateType, itemName, itemCount, itemLevel + 4000, itemMinLevel, itemLink);
--							itemSpell = nil;
						end
					end

					if (itemSpell) then

						-- Search through all of our search strings to see if we found a match
						-- for a type of item we search for.
						for nameIndex = 1, Lunar.Items.totalItemTypes do 

							-- If the item spell is the same as one of our search data types,
							-- we add the item to our item data table and stop our search.
							if (itemSpell == searchData[itemTableNames[nameIndex]]) then

								-- Bandage strength is based on bandage item number, so change the
								-- itemLevel to reflect that
								if (itemSpell == searchData.bandage) then
									itemLevel = itemID;

								-- Edible Fern item has an itemLevel and itemMinLevel of 0. Change them
								-- to something more suitible
								elseif (itemID == 24540) then
									itemLevel = 55;
									itemMinLevel = 45;

								-- Some level 55 food provide more health than others. Since they are
								-- more powerful, we need to raise the strength a little bit.
								elseif ((itemID >= 27657) and (itemID <= 27660)) or ((itemID >= 27664) and (itemID <= 27667)) or (itemID == 31672) or (itemID == 31673) or (itemID == 33935) or (itemID == 33934) then
									itemLevel = itemLevel + 1;

								-- Super Combat health and mana potions need to be taken down to the proper level (was 70, now 60)
								elseif ((itemID >= 31838) and (itemID <= 31841)) or ((itemID >= 31852) and (itemID <= 31855)) then
									itemLevel = 60;	

								-- Endless healing/mana potions, requires level 80, but restore like a level 68, so smack it down to
								-- itemLevel 69 (so it is favored over all level 68 potions which restore the same, but this
								-- one is ENDLESS).
								elseif ((itemID == 43569) or (itemID == 43570)) then
									itemLevel = 69;	
								end

								Lunar.Items:ModifyItemDataTable(itemTableNames[nameIndex], updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);
								itemSpell = nil;
								break;
							end

						end
					end

					if (itemSpell) then

						local updateMulti, itemStr1, itemStr2;

						-- If we haven't found a match yet, check if it is a mana agate. If so, add it to the mana potions
						-- section
							
						if (itemSpell == searchData.manaStone) then
							Lunar.Items:ModifyItemDataTable("potionMana", updateType, itemName, itemCount, itemLevel+2000, itemMinLevel, itemLink);

						-- Check for refreshment types. These go as food and drink
						elseif (itemSpell == searchData.refreshment) then
							Lunar.Items:ModifyItemDataTable("food", updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);

							-- All refreshment spells have mana restoration, except for Succulent Orca Stew and Wyrm Delight
							if (itemID ~= 39691) and (itemID ~= 34750)  then
								Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);
							end

						-- If we haven't found a match yet, check if it is a healthstone. If so, add it to the health potions
						-- section
--						elseif (itemSpell == Lunar.Items:CompareItemSpellCatagory(itemSpell, "healthStone")) then
						elseif (string.find(itemSpell, searchData.healthStone)) then
							
							-- Calculate strength of stone, if it is improved
--							local stoneStr = math.fmod(math.floor(string.find(itemSpellID.healthStone, itemID) /  6), 3);
							local stoneStr = string.match((spellRank or ""), "(%d+)") or (0);


							Lunar.Items:ModifyItemDataTable("potionHealing", updateType, itemLink, itemCount, itemLevel + 2000 + stoneStr, itemMinLevel, itemLink);

						-- Okay, we're still going, so check if it is a rage potion of some kind
						elseif (itemSpell == Lunar.Items:CompareItemSpellCatagory(itemSpell, "ragePotion")) then
							Lunar.Items:ModifyItemDataTable("ragePotion", updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);

						-- Underspore Pod can be used as a drink and a food item, so let's add that too. We artificially increase the
						-- strength so these are used first (as well as other summoned items), before real items :)
						elseif (itemID == 28112) then
							Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, 67, itemMinLevel, itemLink);
							Lunar.Items:ModifyItemDataTable("food", updateType, itemName, itemCount, 67, itemMinLevel, itemLink);

						-- Enriched Mana Biscuit can be used as a drink and a food item, so let's add that too.
						elseif (itemID == 13724) then
							Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, 66, itemMinLevel, itemLink);
							Lunar.Items:ModifyItemDataTable("food", updateType, itemName, itemCount, 56, itemMinLevel, itemLink);

						-- Conjured Manna Biscuit can be used as a drink and a food item, so let's add that too.
						elseif (itemID == 34062) then
							Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, 77, itemMinLevel, itemLink);
							Lunar.Items:ModifyItemDataTable("food", updateType, itemName, itemCount, 77, itemMinLevel, itemLink);

--[[ Not fixed, need to do research on this, since it uses "refreshment" and might get caught before this part

						-- Conjured Mana Strudel can be used as a drink and a food item, so let's add that too.
						elseif (itemID == 43523) then
							Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, 86, itemMinLevel, itemLink);
							Lunar.Items:ModifyItemDataTable("food", updateType, itemName, itemCount, 86, itemMinLevel, itemLink);
--]]
						-- Naaru Ration can be used as a drink and a food item, so let's add that too.
						elseif (itemID == 34780) then
							Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, 76, itemMinLevel, itemLink);
							Lunar.Items:ModifyItemDataTable("food", updateType, itemName, itemCount, 76, itemMinLevel, itemLink);

						-- Noah's Special Brew support (tiny bit weaker than the level 55 equivalent health pot).
						elseif (itemID == 39327) then
							Lunar.Items:ModifyItemDataTable("potionHealing", updateType, itemName, itemCount, 64, itemMinLevel, itemLink);

						-- Runic and regular Healing Potion injectors
						elseif ((itemID == 41166) or (itemID == 33092))  then
							Lunar.Items:ModifyItemDataTable("potionHealing", updateType, itemName, itemCount, itemLevel+1, itemMinLevel, itemLink);

						-- Runic and regular Mana Potion injectors
						elseif ((itemID == 42545) or (itemID == 33093))  then
							Lunar.Items:ModifyItemDataTable("potionMana", updateType, itemName, itemCount, itemLevel+1, itemMinLevel, itemLink);
							
						-- Rejuvenation and Alchemist's Potion checking

							-- Minor Rejuvenation Potion
							elseif (itemID == 2456) then
								updateMulti = true;
								itemLevel = 10
							-- Major Rejuvenation Potion
							elseif (itemID == 18253) then
								updateMulti = true;
								itemLevel = 61
							-- Super Rejuvenation Potion
							elseif (itemID == 22850) then
								updateMulti = true;
								itemLevel = 78
							-- Powerful Rejuvenation Potion
							elseif (itemID == 40087) then
								updateMulti = true;
								itemLevel = 79
							-- Mad Alchemist's Potion
							elseif (itemID == 34440) then
								updateMulti = true;
								itemLevel = 78
							-- Crazy Alchemist's Potion
							elseif (itemID == 40077) then
								updateMulti = true;
								itemLevel = 79

						-- Charged Crystal Focus (We want it in the same catagory of health stones, so we make its
						-- item level 2000. Since it's less powerful that the item level 70 Master Healthstone, but more
						-- powerful than the item level 58 Major Healthstone, we dump it in between, hence, level 2060).
						elseif (itemID == 32578) then
							Lunar.Items:ModifyItemDataTable("potionHealing", updateType, itemName, itemCount, 2060, itemMinLevel, itemLink);

						-- Whipper Root Tuber
						elseif (itemID == 11951) then
							Lunar.Items:ModifyItemDataTable("potionHealing", updateType, itemName, itemCount, 50, itemMinLevel, itemLink);
						end

						if (updateMulti) then
							Lunar.Items:ModifyItemDataTable("potionHealing", updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);
							Lunar.Items:ModifyItemDataTable("potionMana", updateType, itemName, itemCount, itemLevel, itemMinLevel, itemLink);
						end

	--					if (itemID == 20744) then
	--						Lunar.Items:ModifyItemDataTable("drink", updateType, itemName, itemCount, 50, itemMinLevel, itemLink);
	--					end

					end

				end

			-- Now, if the item is a Misc item, and the item level is the same as the minimum item level
			-- needed to use the item, the stack count is only 1, and the item level is >= 20 (WOW TCG
			-- Turtle Mount is level 20) ... it's safe to assume that the item is a mount. Add it
			-- (This doesn't account for the halloween mounts I guess, since their item level is 1 ...)
--			elseif (mountFound) or (itemID == 23720) then
--				Lunar.Items:ModifyItemDataTable("mount", updateType, itemName, 1, itemLevel + (mountType or (0)), itemMinLevel, itemLink);
				
			-- Next on the search: Hearthstone. 
			elseif (itemSpell == searchData.hearthstone) then
				Lunar.Items:ModifyItemDataTable("hearthstone", updateType, itemName, 1, itemLevel, itemMinLevel, itemLink);
			end
		end
	end
end

-- /***********************************************
--  * ModifyItemDataTable
--  * ========================
--  *
--  * Modifies the item table with a (Add|Remove|Wipe|Exists) command. Other arguments are used for
--  * the selected operation as well.
--  *
--  * Accepts:	tableName:	name of table to modify
--  *		modifyType:	type of modification ("add", "remove", "wipe", or "exists"). Anything else, does nothing
--  *		itemName:	name of item to (Add|Remove|Exists)
--  *		itemCount:	amount of said item to (Add|Remove|Exists)
--  *		itemLevel:	strength or potency of said item (higher number means stronger potion/food/etc)
--  *		itemMinLevel:	level said item needs in order to be used
--  *           itemLink:	itemLink of the item
--  *		
--  * Returns:	on modifyType "add":	true if the item existed, false if it had to be added
--  *		on modifyType "remove":	true if the player has more of said item, false if they have 0 left
--  *		on modifyType "wipe":	always returns true
--  *           on modifyType "exists": false if it was a new item (and added), true if it already exists (not added)
--  *********************
function Lunar.Items:ModifyItemDataTable(tableName, modifyType, itemName, itemCount, itemLevel, itemMinLevel, itemLink)

	-- Set our locals
	local index, dataDump, modified;
	modified = false;

	-- If the table name or modify type is not declared, end now.
	if (tableName == nil) or (modifyType == nil)  then
		return false;		
	end

	-- If we're adding, make sure we have the proper information, otherwise we exit.
	if (modifyType == "add") or (modifyType == "exists")  then
		if (itemName == nil) or (itemCount == nil) or (itemLevel == nil) or (itemMinLevel == nil) or (itemLink == nil)  then
			return false;
		end
	end

	-- If we're removing, make sure we have the proper information, otherwise we exit.
	if (modifyType == "remove") then
		if (itemName == nil) or (itemCount == nil) then
			return false;
		end
	end

	-- Okay, now make sure the table we're messing with exists. If so, we continue.
	if (itemData[tableName]) then

		-- If we're adding an existing item ("add") or adding a new item ("exists"), we go down path #1
		if (modifyType == "add") or (modifyType == "exists") then

			-- First, check all of the specified table and see if our item exists
			for index, dataDump in ipairs(itemData[tableName]) do 

				-- If the name matches our table data, we have a match. 
				if (dataDump.name == itemName) then

					modified = true;

					-- If we're adding, update the total count of that item by the specified
					-- itemCount, state that we found a match, and exit the loop
					if (modifyType == "add") then
						dataDump.count = dataDump.count + itemCount;
						break;
					end

					-- We don't do anything for "exists" because it was already
					-- in the table and the count was updated with an Update Count function
					-- before calling this function with "exists"
							
				end
			end

			-- If no match was found, we need to create a new entry and populate its data
			if not (modified) then

				-- Check the item to see if it is summoned. First, grab the item link. Then, clear
				-- our hidden tooltip and set the new data. Next, grab the second line of the tooltip
				-- (where it would say "Conjured Item" if it existed and check if the localized
				-- text exists. If it is, we need to increase the strength by 1000 (to use it first,
				-- if need be).

--				_, itemLink = GetItemInfo(itemName);
				if (itemLink) and (itemLink ~= "spellMount") then
					Lunar.Items.tooltip:ClearLines();
					Lunar.Items.tooltip:SetOwner(UIParent, "ANCHOR_NONE");
					Lunar.Items.tooltip:SetHyperlink(itemLink);
					searchText = getglobal(Lunar.Items.tooltip:GetName() .. "TextLeft2"):GetText();
					if (searchText) then
						if string.find(searchText, ITEM_CONJURED) then
							itemLevel = itemLevel + 1000;
						end
					end
				end

--				if (tableName == "mount") then -- Retrieve MountType value and revert count to 1
--					mountType = itemCount;
--					itemCount = 1;
--				end

				-- Populate the data table
				table.insert(itemData[tableName], {
					name = itemName,
					count = itemCount,
					strength = itemLevel,
					level = itemMinLevel,
					itemID = Lunar.API:GetItemID(itemLink)});

				-- If a mount is being added, also save the spell name of the
				-- mount (the spell name is different than the mount name for
				-- some mounts).

				if (tableName == "mount") then
					if (itemLink ~= "spellMount") then
						itemData[tableName][table.getn(itemData[tableName])].spell = GetItemSpell(itemName);
					else
						itemData[tableName][table.getn(itemData[tableName])].spell = GetSpellInfo(string.sub(itemName, 3));
						itemData[tableName][table.getn(itemData[tableName])].spellMount = true;
						itemData[tableName][table.getn(itemData[tableName])].itemID = "spellMount";
					end
				end

				if (tableName == "companion") then
					itemData[tableName][table.getn(itemData[tableName])].spell = GetSpellInfo(string.sub(itemName, 3));
					itemData[tableName][table.getn(itemData[tableName])].itemID = "spellMount";
				end

			end

		-- If we're removing, we go down path #2
		elseif (modifyType == "remove") then

			-- First, check all of the specified table and see if our item exists
			for index, dataDump in ipairs(itemData[tableName]) do 

				-- If the name matches our table data, we have a match. State that
				-- we found a match and update the total count of that item by
				-- removing the specified itemCount and then exit the loop.
				if (dataDump.name == itemName) then
					dataDump.count = dataDump.count - itemCount;
					modified = true;

					-- Prevent the possibility of going into the negatives...
					-- as well as state that there are no more items left
					if (dataDump.count <= 0) then
						dataDump.count = 0;
						modified = false;
					end
					break;
				end
			end

		-- If we're wiping, we need to go down path #3 and burn some bridges
		elseif (modifyType == "wipe") then

			-- Start at the first entry and cycle through n times, till
			-- we removed everything
			for index = 1, table.getn(itemData[tableName]) do 
				table.remove(itemData[tableName]);
			end
		end
	end

	-- Return our results
	return modified;

	-- Take a nap

end

-- /***********************************************
--  * WipeItemDataTable
--  * ========================
--  *
--  * Wipes every entry in the item database
--  *
--  * Accepts: None
--  * Returns: None
--  *********************
function Lunar.Items:WipeItemDataTable()

	-- Set a local
	local nameIndex;

	-- Run through each table name in the itemData tables and wipe it off the face of the planet!
	for nameIndex = 1, table.getn(itemTableNames) do 
		Lunar.Items:ModifyItemDataTable(itemTableNames[nameIndex], "wipe");
	end

end