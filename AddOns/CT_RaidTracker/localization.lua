-- Version 17330
CT_ITEMREG = "(|c(%x+)|Hitem:([-%d:]+)|h%[(.-)%]|h|r)%";
CT_ITEMREG_MULTI = "(|c(%x+)|Hitem:([-%d:]+)|h%[(.-)%]|h|r)x(%d+)%";
PlayerGroupsIndexes = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
CT_RaidTracker_Translation_Complete = false;

CT_RaidTracker_Zones = {

-- WotLK
	"Naxxramas",
	"The Eye of Eternity",
	"The Obsidian Sanctum",
	"Ulduar",
	"Vault of Archavon",
	"Trial of the Crusader",
	"Trial of the Grand Crusader",
	"Onyxia's Lair",
	"Icecrown Citadel",	
    
--	"Worldboss", 
};

CT_RaidTracker_Bosses = {
--	["Worldboss"] = {
--		"N/A",
--	},
-- WotLK
	["The Eye of Eternity"] = {
		"Malygos",
	},	
    
	["The Obsidian Sanctum"] = {
		"Sartharion",
		"Sartharion + 1 Drake",
		"Sartharion + 2 Drakes",
		"Sartharion + 3 Drakes",
	},

	["Vault of Archavon"] = {
		"Archavon the Stone Watcher",
		"Emalon the Storm Watcher",
		"Koralon the Flame Watcher",
		"Toravon the Ice Watcher",
	},

	["Naxxramas"] = {
		"Anub'Rekhan",
		"Four Horsemen",
		"Gluth",
		"Gothik the Harvester",
		"Grand Widow Faerlina",
		"Grobbulus",
		"Heigan the Unclean",
		"Instructor Razuvious",
		"Kel'Thuzad",
		"Loatheb",
		"Maexxna",
		"Noth the Plaguebringer",
		"Patchwerk",
		"Sapphiron",
		"Thaddius",
	},
	["Ulduar"] = {
		"Algalon the Observer",
		"Auriaya",
		"Flame Leviathan",
		"Freya",
		"General Vezax",
		"Hodir",
		"Ignis the Furnace Master",
		"Kologarn",
		"Mimiron",
		"Razorscale",
		"The Assembly of Iron",
		"Thorim",
		"XT-002 Deconstructor",
		"Yogg-Saron",
	},
	["Trial of the Crusader"] = {
		"Anub'arak",
		"Faction Champions",
		"Lord Jaraxxus",
		"Northrend Beasts",
		"Twin Val'kyr",
	},
	["Trial of the Grand Crusader"] = {
		"Anub'arak",
		"Faction Champions",
		"Lord Jaraxxus",
		"Northrend Beasts",
		"Twin Val'kyr",
	},
	["Onyxia's Lair"] = {
		"Onyxia",
	},
	["Icecrown Citadel"] = {
		"Lord Marrowgar",
		"Lady Deathwhisper",
		"Gunship Battle",
		"Deathbringer Saurfang",
		"Festergut",
		"Rotface",
		--"Lady Todeswisper",
		"Professor Putricide",
		"Blood Prince Council",
		"Blood-Queen Lana'thel",
		"Valithria Dreamwalker",
		"Sindragosa",
		"The Lich King",
	},	
-- WotLK


	["Administration"] = {
		"Track Members",
		"Punctuality",
		"Fault",
	},
	--Trash	
	["Trash mob"] = 1,
};

CT_RaidTracker_lang_LeftGroup = "([^%s]+) has left the raid group";
CT_RaidTracker_lang_JoinedGroup = "([^%s]+) has joined the raid group";
CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) receives loot: "..CT_ITEMREG..".";
CT_RaidTracker_lang_ReceivesLoot2 = "You receive loot: "..CT_ITEMREG..".";
CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) receives loot: "..CT_ITEMREG_MULTI..".";
CT_RaidTracker_lang_ReceivesLoot4 = "You receive loot: "..CT_ITEMREG_MULTI..".";
CT_RaidTracker_lang_ReceivesLootYou = "You";

CT_RaidTracker_ZoneTriggers = {
-- WotLK
	["The Eye of Eternity"] = "The Eye of Eternity",
	["The Obsidian Sanctum"] = "The Obsidian Sanctum",
	["Vault of Archavon"] = "Vault of Archavon",
	["Naxxramas"] = "Naxxramas",
	["Ulduar"] = "Ulduar",
	["Trial of the Crusader"] = "Trial of the Crusader",
	["Trial of the Grand Crusader"] = "Trial of the Grand Crusader",
	["Onyxia's Lair"] = "Onyxia's Lair",
	["Icecrown Citadel"] = "Icecrown Citadel",
-- WotLK
};

CT_RaidTracker_BossUnitTriggers = {
-- Wotlk
		
	-- Eye of Eternity
	["Malygos"] = "Malygos",

	-- Obsidian Sanctum
	["Sartharion"] = "Sartharion",

	-- Vault of Archavon
	["Archavon the Stone Watcher"] = "Archavon the Stone Watcher",
	["Emalon the Storm Watcher"] = "Emalon the Storm Watcher",
	["Koralon the Flame Watcher"] = "Koralon the Flame Watcher",
	["Toravon the Ice Watcher"] = "Toravon the Ice Watcher",
	-- Vault of Archavon


		-- Naxxramas
	["Patchwerk"] = "Patchwerk",
	["Grobbulus"] = "Grobbulus",
	["Gluth"] = "Gluth",
	["Thaddius"] = "Thaddius",
	["Instructor Razuvious"] = "Instructor Razuvious",
	["Gothik the Harvester"] = "Gothik the Harvester",

	["Noth the Plaguebringer"] = "Noth the Plaguebringer",
	["Heigan the Unclean"] = "Heigan the Unclean",
	["Loatheb"] = "Loatheb",
	["Anub'Rekhan"] = "Anub'Rekhan",
	["Grand Widow Faerlina"] = "Grand Widow Faerlina",
	["Maexxna"] = "Maexxna",
	["Sapphiron"] = "Sapphiron",
	["Kel'Thuzad"] = "Kel'Thuzad",
		["Fangnetz"] = "IGNORE",
		["Verstrahlter Br\195\188hschleimer"] = "IGNORE",
		
	["Crypt Guard"] = "IGNORE",
	["Grobbulus Cloud"] = "IGNORE",
	["Deathknight Understudy"] = "IGNORE",
	["Maggot"] = "IGNORE",
	["Maexxna Spiderling"] = "IGNORE",
	["Plagued Warrior"] = "IGNORE",
	["Zombie Chow"] = "IGNORE",
	["Corpse Scarab"] = "IGNORE",
	["Naxxramas Follower"] = "IGNORE",
	["Naxxramas Worshipper"] = "IGNORE",
	["Web Wrap"] = "IGNORE",
	["Fallout Slime"] = "IGNORE",
	["Diseased Maggot"] = "IGNORE",
	["Rotting Maggot"] = "IGNORE",
	["Living Poison"] = "IGNORE",
	["Spore"] = "IGNORE",
		-- 4 Horsemen
		--["Highlord Mograine"] = "Four Horsemen", -- From old Naxx
		["Baron Rivendare"] = "IGNORE",
		["Thane Korth'azz"] = "IGNORE",
		["Lady Blaumeux"] = "IGNORE",
		["Sir Zeliek"] = "IGNORE",		
	["Four Horsemen"] = "Four Horsemen",

	-- Ulduar
	["Hodir"] = "Hodir",
	["Stormcaller Brundir"] = "IGNORE", -- The Assembly of Iron
	["Thorim"] = "Thorim",
	["Steelbreaker"] = "IGNORE", -- The Assembly of Iron
	["Freya"] = "Freya",
	["Runemaster Molgeim"] = "IGNORE", -- The Assembly of Iron
	["The Assembly of Iron"] = "The Assembly of Iron", -- Dummy
	["Flame Leviathan"] = "Flame Leviathan",
	["Ignis the Furnace Master"] = "Ignis the Furnace Master",
	["Razorscale"] = "Razorscale",
	["General Vezax"] = "General Vezax",
	["Yogg-Saron"] = "Yogg-Saron",
	["XT-002 Deconstructor"] = "XT-002 Deconstructor",
	["Auriaya"] = "Auriaya",
	["Kologarn"] = "Kologarn",
	["Mimiron"] = "Mimiron",
	["Algalon the Observer"] = "Algalon the Observer",
	-- Ulduar
	
	-- Trial of the Crusader
	["Icehowl"] = "Northrend Beasts",
	["Lord Jaraxxus"] = "Lord Jaraxxus",
	["Fjola Lightbane"] = "IGNORE",
	["Edyis Darkbane"] = "IGNORE",
	-- Yell Helper
	["Twin Val'kyr"] = "Twin Val'kyr",
	["Anub'arak"] = "Anub'arak",
	["Faction Champions"] = "Faction Champions",
	-- Trial of the Crusader
	
	-- Onyxia's Lair
	["Onyxia"] = "Onyxia",
--	["Onyxian Warder"] = "IGNORE",
--	["Onyxian Whelp"] = "IGNORE",
	-- Onyxia's Lair

  -- Icecrown Citadel"
 	 ["Lord Marrowgar"] = "Lord Marrowgar",
 	 ["Lady Deathwhisper"] = "Lady Deathwhisper",
 	 ["Gunship Battle"] = "Gunship Battle",
 	 ["Deathbringer Saurfang"] = "Deathbringer Saurfang",
  	 ["Festergut"] = "Festergut",
  	 ["Rotface"] = "Rotface",
  	 ["Professor Putricide"] = "Professor Putricide",
 	 ["Blood Prince Council"] = "Blood Prince Council",
 	 ["Blood-Queen Lana'thel"] = "Blood-Queen Lana'thel",
 	 ["Valithria Dreamwalker"] = "Valithria Dreamwalker",
 	 ["Sindragosa"] = "Sindragosa",
 	 ["The Lich King"] = "The Lich King",
   -- Icecrown Citadel"

-- Wotlk

--	["DEFAULTBOSS"] = "Trash mob",
	["Track Members"] = "Track Members",
};

CT_RaidTracker_lang_BossKills = {
	["I grow tired of these games. Proceed, and I will banish your souls to oblivion!"] = "Four Horsemen", -- Four Horsemen
	["It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear."] = "Mimiron",
	["I...have...failed..."] = "Ignis the Furnace Master",
	["His hold on me dissipates. I can see clearly once more. Thank you, heroes."] = "Freya",
	["Stay your arms! I yield!"] = "Thorim",
	["I... I am released from his grasp... at last."] = "Hodir",
--	["Master, they come..."] = "Kologarn",
--	["You are bad... Toys... Very... Baaaaad!"] = "XT-002 Deconstructor",
--	["Mwa-ha-ha-ha! Oh, what horrors await you?"] = "General Vezax",
	["Your fate is sealed. The end of days is finally upon you and ALL who inhabit this miserable little seedling! Uulwi ifis halahs gag erh'ongg w'ssh."] = "Yogg-Saron",
--	["Impossible..."] = "The Assembly of Iron", -- Iron Council Hardmode / Steelbreaker last
	["You rush headlong into the maw of madness!"] = "The Assembly of Iron", -- Iron Council Normalmode / Brundir last
	["What have you gained from my defeat? You are no less doomed, mortals!"] = "The Assembly of Iron", -- Iron Council Semimode / Molgeim last
	-- Ulduar
	-- Trial of the Crusader
	["The Scourge cannot be stopped..."] = "Twin Val'kyr",
 	["I have failed you, master..."] = "Anub'arak",
 	["A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death."] = "Faction Champions",
	-- Trial of the Crusader
	-- Icecrown Citadel
	["The Alliance falter. Onward to the Lich King!"] = "Gunship Battle", -- Gunship Battle Horde
	["Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"] = "Gunship Battle", -- Gunship Alliance

	["My queen, they... come."] = "Blood Prince Council", -- Blood Prince Council
	["I AM RENEWED! Ysera grant me the favor to lay these foul creatures to rest!"] = "Valithria Dreamwalker", -- Valithria Dreamwalker
  ["They cannot fear..."] = "The Lich King", -- Lich King
  ["Is it truly righteousness that drives you? I wonder..."] = "The Lich King", -- Lich King
	-- Icecrown Citadel
};

