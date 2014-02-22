--------------------------------------------------------------------------
-- localization.lua 
-- Last Modified 1/1/2009
--------------------------------------------------------------------------

LootFilter.Locale = {
	-- weird looking keys for quality because we need to sort on them
	qualities= {
		["QUaGrey"]= 0,
		["QUbWhite"]= 1,
		["QUcGreen"]= 2,
		["QUdBlue"]= 3,
		["QUePurple"]= 4,
		["QUfOrange"]= 5,
		["QUgRed"]= 6,
		["QUhTan"] = 7,
		["QUhQuest"]= -1 
	},
	types = {
		["Armor"] = "Armor",
		["Consumables"] = "Consumable",
		["Containers"] = "Container",
		["Gems"] = "Gem",
		["Key"] = "Key",
		["Miscellaneous"] = "Miscellaneous",
		["Projectile"] = "Projectile",
		["Quest"] = "Quest",
		["Quiver"] = "Quiver",		
		["Recipe"] = "Recipe",
		["TradeGoods"] = "Trade Goods",
		["Weapons"] = "Weapon",
	},
	radioButtonsText= {
		["QUaGrey"]= "Poor (Grey)",
		["QUbWhite"]= "Common (White)",
		["QUcGreen"]= "Uncommon (Green)",
		["QUdBlue"]= "Rare (Blue)",
		["QUePurple"]= "Epic (Purple)",
		["QUfOrange"]= "Legendary (Orange)",
		["QUgRed"]= "Artifact (Red)",
		["QUhTan"] = "Heirloom (Tan)",
		["QUhQuest"]= "Quest",

		-- Armor
		["TYArmorMiscellaneous"]= "Miscellaneous",
		["TYArmorCloth"]= "Cloth",
		["TYArmorLeather"]= "Leather",
		["TYArmorMail"]= "Mail",
		["TYArmorPlate"]= "Plate",
		["TYArmorShields"]= "Shields",
		["TYArmorLibrams"]= "Librams",
		["TYArmorIdols"]= "Idols",
		["TYArmorTotems"]= "Totems",
		
		-- Consumable
		["TYConsumableFoodDrink"]= "Food & Drink",
		["TYConsumablePotion"]= "Potion",
		["TYConsumableElixir"]= "Elixir",
		["TYConsumableFlask"]= "Flask",
		["TYConsumableBandage"]= "Bandage",
		["TYConsumableItem Enhancement"]= "Item Enhancement",
		["TYConsumableScroll"]= "Scroll",
		["TYConsumableOther"]= "Other",
		["TYConsumableConsumable"]= "Consumable",
		
		-- Container
		["TYContainerBag"]= "Bag",
		["TYContainerEnchanting Bag"]= "Enchanting Bag",
		["TYContainerEngineering Bag"]= "Engineering Bag",
		["TYContainerGem Bag"]= "Gem Bag",
		["TYContainerHerb Bag"]= "Herb Bag",
		["TYContainerMining Bag"]= "Mining Bag",
		["TYContainerSoul Bag"]= "Soul Bag",
		["TYContainerLeatherworking Bag"]= "Leatherworking Bag",
		
		
		-- Miscellaneous
		["TYMiscellaneousJunk"]= "Junk",
		["TYMiscellaneousReagent"]= "Reagent",
		["TYMiscellaneousPet"]= "Pet",
		["TYMiscellaneousHoliday"]= "Holiday",
		["TYMiscellaneousOther"]= "Other",
		-- Gem
		["TYGemBlue"] = "Blue",
		["TYGemGreen"] = "Green",
		["TYGemOrange"] = "Orange",
		["TYGemMeta"] = "Meta",
		["TYGemPrismatic"] = "Prismatic",
		["TYGemPurple"] = "Purple",
		["TYGemRed"] = "Red",
		["TYGemSimple"] = "Simple",
		["TYGemYellow"] = "Yellow",
		
		
		-- Key
		["TYKeyKey"]= "Key",
		-- Projectile
		["TYProjectileArrow"]= "Arrow",
		["TYProjectileBullet"]= "Bullet",
		-- Quest
		["TYQuestQuest"]= "Quest",
		
		-- Quiver
		["TYQuiverAmmoPouch"]= "Ammo Pouch",
		["TYQuiverQuiver"]= "Quiver",				
		
		-- Recipe
		["TYRecipeAlchemy"]= "Alchemy",
		["TYRecipeBlacksmithing"]= "Blacksmithing",
		["TYRecipeBook"]= "Book",
		["TYRecipeCooking"]= "Cooking",
		["TYRecipeEnchanting"]= "Enchanting",
		["TYRecipeEngineering"]= "Engineering",
		["TYRecipeFirstAid"]= "First Aid",
		["TYRecipeLeatherworking"]= "Leatherworking",
		["TYRecipeTailoring"]= "Tailoring",
		
				
		-- Trade Goods
		["TYTrade GoodsElemental"] = "Elemental",
		["TYTrade GoodsCloth"] = "Cloth",
		["TYTrade GoodsLeather"] = "Leather",
		["TYTrade GoodsMetal & Stone"] = "Metal & Stone", 
		["TYTrade GoodsMeat"] = "Meat",
		["TYTrade GoodsHerb"] = "Herb",
		["TYTrade GoodsEnchanting"] = "Enchanting", 
		["TYTrade GoodsJewelcrafting"] = "Jewelcrafting",
		["TYTrade GoodsParts"]= "Parts",
		["TYTrade GoodsDevices"]= "Devices",
		["TYTrade GoodsExplosives"]= "Explosives",
		["TYTrade GoodsOther"]= "Other",
		["TYTrade GoodsTradeGoods"]= "Trade Goods",
		
		-- Weapon
		["TYWeaponBows"]= "Bows",
		["TYWeaponCrossbows"]= "Crossbows",
		["TYWeaponDaggers"]= "Daggers",
		["TYWeaponGuns"]= "Guns",
		["TYWeaponFishingPoles"]= "Fishing Poles",
		["TYWeaponFistWeapons"]= "Fist Weapons",
		["TYWeaponMiscellaneous"]= "Miscellaneous",
		["TYWeaponOneHandedAxes"]= "One-Handed Axes",
		["TYWeaponOneHandedMaces"]= "One-Handed Maces",
		["TYWeaponOneHandedSwords"]= "One-Handed Swords",
		["TYWeaponPolearms"]= "Polearms",
		["TYWeaponStaves"]= "Staves",
		["TYWeaponThrown"]= "Thrown",
		["TYWeaponTwoHandedAxes"]= "Two-Handed Axes",
		["TYWeaponTwoHandedMaces"]= "Two-Handed Maces",
		["TYWeaponTwoHandedSwords"]= "Two-Handed Swords",
		["TYWeaponWands"]= "Wands",
		
		["OPEnable"]= "Enable Loot Filter",
		["OPCaching"]= "Enable Loot Caching",
		["OPTooltips"]= "Show tooltips",
		["OPNotifyDelete"]= "Notify on delete",
		["OPNotifyKeep"]= "Notify on keep",
		["OPNotifyNoMatch"]= "Notify on no match",
		["OPNotifyOpen"]= "Notify on open",
		["OPNotifyNew"]= "Notify on new version",
		["OPConfirmDelete"] = "Confirm item delete",
		["OPValKeep"]= "Keep items worth more than",
		["OPValDelete"]= "Delete items worth less than",
		["OPOpenVendor"]= "Open when talking to vendor",
		["OPAutoSell"]= "Automatically start selling",
		["OPNoValue"]= "Keep items with no (known) value", 
		["OPMarketValue"]= "Use Auctioneer market prices instead of vendor prices",
		["OPBag0"]= "Backpack",
		["OPBag1"]= "Bag 1",
		["OPBag2"]= "Bag 2",
		["OPBag3"]= "Bag 3",
		["OPBag4"]= "Bag 4",
		["TYWands"]= "Wands"
	},
    LocText = {
        ["LTTryopen"] = "trying to open",
        ["LTNameMatched"] = "name matched",
        ["LTQualMatched"] = "quality matched",
        ["LTQuest"] = "quest",              -- Used to match Quest Item as Quality Value
        ["LTQuestItem"] = "quest item",
        ["LTTypeMatched"]= "type matched",
        ["LTKept"] = "was kept",
        ["LTNoKnownValue"] = "item has no known value",
        ["LTValueHighEnough"] = "value is high enough",
        ["LTValueNotHighEnough"] = "value not high enough",
        ["LTNoMatchingCriteria"] = "no matching criteria found",
        ["LTWasSold"] = "was sold",
        ["LTWasDeleted"] = "was deleted",
        ["LTNewVersion1"] = "A new version",
        ["LTNewVersion2"] = "of Loot Filter has been detected. Download it from http://www.lootfilter.com .",
        ["LTAddedCosQuest"] = "Added because of quest",
        ["LTDeleteItems"] = "Delete items",
        ["LTSellItems"] = "Sell items",
		["LTFinishedSC"] = "Finished selling/cleaning.",
        ["LTNoOtherCharacterToCopySettings"] = "You currently do not have any other characters to copy settings from.",
        ["LTTotalValue"] = "Total value",
		["LTSessionInfo"] = "Below are some item values that have been recorded this session.",
		["LTSessionTotal"] = "Total value",
		["LTSessionItemTotal"] = "Number of items",
		["LTSessionAverage"] = "Average / item",
		["LTSessionValueHour"] = "Average / hour",
        ["LTNoMatchingItems"] = "No matching items were found.",
        ["LTItemLowestValue"] = "item has lowest value",
        ["LTVendorWinClosedWhileSelling"] = "Vendor window closed while selling items.",
        ["LTTimeOutItemNotFound"] = "Timeout. One or more items in the list were not found.",
    },
    LocTooltip = {
        ["LToolTip1"] = "Any items listed here do not match any of the keep properties. You can choose to automatically sell or delete these items. Use shift-mouseclick to add an item to the keep list.",
        ["LToolTip2"] = "Select this if you do not care if an item has this property.",
        ["LToolTip3"] = "Select this if you want to KEEP items that have this property.",
        ["LToolTip4"] = "Select this if you want to DELETE items that have this property.",
        ["LToolTip5"] = "Items that match a name listed here are KEPT.\n\nEnter a new name on a new line. You can add comments after a name using ';'. You can use patterns by prefixing the pattern with a hash ('#') to match parts of a name. Some example of patterns are:\n#(.*)Potion$ ; Match names ending in potion\n#(.*)Scroll(.*) ; Match names containing 'scroll'\nUse the '##' prefix to match against text in an item tooltip.",
        ["LToolTip6"] = "Items that match a name listed here are DELETED.\n\nEnter a new name on a new line. You can add comments after a name using ';'. You can use patterns by prefixing the pattern with a hash ('#') to match parts of a name. Some example of patterns are:\n#(.*)Potion$ ; Match names ending in potion\n#(.*)Scroll(.*) ; Match names containing 'scroll'\nUse the '##' prefix to match against text in an item tooltip.",
        ["LToolTip7"] = "Items worth less than this value are DELETED.\n\nThe value entered is in gold. 0.1 gold equals 10 silver.",
        ["LToolTip8"] = "Items worth more than this value are KEPT.\n\nThe value entered is in gold. 0.1 gold equals 10 silver.",
        ["LToolTip9"] = "Enter the number of free bag slots you want to keep. Loot Filter will start replacing lower valued items with higher ones if the number of free slots is less than what you enter here.",
        ["LToolTip10"] = "Any items listed here do not match any of the keep properties. You can choose to automatically sell or delete these items. Use shift-mouseclick to add an item to the keep list.",
        ["LToolTip11"] = "Items that match a name listed here are automatically opened. Using this on scrolls and such will not work, and generate an error.\n\nEnter a new name on a new line. You can add comments after a name using ';'. You can use patterns by prefixing the pattern with a hash ('#') to match parts of a name. Some example of patterns are:\n#(.*)Clam$ ; Match names ending in 'Clam'\n#(.*)Clam(.*) ; Match names containing 'Clam'",
		["LToolTip12"] = "Select how you want to calculate the value of items (value * number_of_items). Number_of_items can be a single item, the current stack size or the maximum stack size."
    },
};

-- Interface (xml) localization
LFINT_BTN_GENERAL = "General" ;
LFINT_BTN_QUALITY = "Quality";
LFINT_BTN_TYPE = "Type";
LFINT_BTN_NAME = "Name";
LFINT_BTN_VALUE = "Value";
LFINT_BTN_CLEAN = "Clean";
LFINT_BTN_OPEN = "Open";
LFINT_BTN_COPY = "Copy";
LFINT_BTN_CLOSE = "Close";
LFINT_BTN_DELETEITEMS = "Delete items" ;
LFINT_BTN_YESSURE = "Yes, I am sure" ;
LFINT_BTN_COPYSETTINGS = "Copy settings";
LFINT_BTN_DELETESETTINGS = "Delete settings";
LFINT_BTN_RESET = "Reset";

LFINT_TXT_MOREINFO = "|n|nIf you have any questions or suggestions please visit the website at http://www.lootfilter.com|nor send an e-mail to meter@lootfilter.com .";
LFINT_TXT_SELECTBAGS = "Select the bags you wish to use Loot Filter on.";
LFINT_TXT_ITEMKEEP = "Items that you want to KEEP.";
LFINT_TXT_ITEMDELETE = "Items that you want to DELETE.";
LFINT_TXT_INSERTNEWNAME = "Insert a new name on a new line.";
LFINT_TXT_INFORMANTNEED = "If you want to filter items on item value you must have an addon installed that supports the GetSellValue API (eg. Informant, ItemPriceTooltip)." ;
LFINT_TXT_NUMFREEBAGSLOTS = "Number of free bag slots" ;
LFINT_TXT_SELLALLNOMATCH = "Use this to sell or delete all the items that do not match any keep properties." ;
LFINT_TXT_AUTOOPEN = "Items that you want to automatically open and loot (like clams)." ;
LFINT_TXT_SELECTCHARCOPY = "Select the character you wish to copy settings from." ;
LFINT_TXT_COPYSUCCESS = "Settings were copied succesfully." ;
LFINT_TXT_DELETESUCCESS = "Settings were deleted succesfully." ;
LFINT_TXT_SELECTTYPE = "Select a subtype: ";
LFINT_TXT_SIZETOCALCULATE = "To calculate item value use: ";
LFINT_TXT_SIZETOCALCULATE_TEXT1 = "a single item";
LFINT_TXT_SIZETOCALCULATE_TEXT2 = "current stack size";
LFINT_TXT_SIZETOCALCULATE_TEXT3 = "maximum stack size";


BINDING_NAME_LFINT_TXT_TOGGLE = "Toggle window";
BINDING_HEADER_LFINT_TXT_LOOTFILTER = "Loot Filter";


--[[
New entries to v3.9:
	OPConfirmDelete
--]]
