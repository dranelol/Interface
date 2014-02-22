local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleItemSet = AtlasLoot_GetLocaleLibBabble("LibBabble-ItemSet-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["SETMENU"] = {
		["Normal"] = {
			{
				{ 2, "ValorPoints", "inv_misc_cape_cataclysm_tank_d_01", "=ds="..AL["Valor Points"].." "..AL["Rewards"], "=q5="..AL["Cataclysm"]};
				{ 3, "JUSTICEPOINTSMENU", "inv_misc_necklacea10", "=ds="..AL["Justice Points"].." "..AL["Rewards"], "=q5="..AL["Cataclysm"]};
				{ 5, "WOTLKEMBLEMMENU", "inv_misc_frostemblem_01", "=ds="..AL["Justice Points"].." "..AL["Rewards"], "=q5="..AL["Wrath of the Lich King"]};
				{ 6, "70TOKENMENU", "inv_valentineperfumebottle", "=ds="..AL["Justice Points"].." "..AL["Rewards"], "=q5="..AL["Burning Crusade"]};
				{ 8, "WORLDEPICS", "INV_Sword_76", "=ds="..AL["BoE World Epics"], ""};
				{ 9, "Legendaries", "inv_hammer_unique_sulfuras", "=ds="..AL["Legendary Items"], ""};
				{ 10, "MOUNTMENU", "ability_hunter_pet_dragonhawk", "=ds="..BabbleInventory["Mounts"], ""};
				{ 11, "PETMENU", "INV_Box_PetCarrier_01", "=ds="..BabbleInventory["Companions"], ""};
				{ 12, "TABARDMENU", "inv_chest_cloth_30", "=ds="..BabbleInventory["Tabards"], ""};
				{ 13, "TransformationItems", "inv_misc_orb_03", "=ds="..AL["Transformation Items"], ""};
				{ 14, "CardGame", "inv_misc_ogrepinata", "=ds="..AL["TCG Items"], ""};
				{ 17, "SETSMISCMENU", "inv_misc_monsterscales_15", "=ds="..AL["Misc Sets"], ""};
				{ 19, "Heirloom", "INV_Sword_43", "=ds="..AL["Heirloom"], "=q5="..AL["Level 80"]};
				{ 20, "Heirloom85", "inv_helmet_04", "=ds="..AL["Heirloom"], "=q5="..AL["Level 85"]};
				{ 22, "T1T2T3SET", "INV_Pants_Mail_03", "=ds="..AL["Tier 1/2/3 Set"], "=q5="..AL["Classic WoW"]};
				{ 23, "T456SET", "INV_Gauntlets_63", "=ds="..AL["Tier 4/5/6 Set"], "=q5="..AL["Burning Crusade"]};
				{ 24, "T7T8SET", "INV_Chest_Chain_15", "=ds="..AL["Tier 7/8 Set"], "=q5="..AL["Wrath of the Lich King"]};
				{ 25, "T9SET", "inv_gauntlets_80", "=ds="..AL["Tier 9 Set"], "=q5="..AL["Wrath of the Lich King"]};
				{ 26, "T10SET", "inv_chest_plate_26", "=ds="..AL["Tier 10 Set"], "=q5="..AL["Wrath of the Lich King"]};
				{ 27, "T11SET", "inv_helm_robe_raidmage_i_01", "=ds="..AL["Tier 11 Set"], "=q5="..AL["Cataclysm"]};
			};
		};
		info = {
			name = AL["Collections"],
		};
	}

	AtlasLoot_Data["JUSTICEPOINTSMENU"] = {
		["Normal"] = {
			{
				{ 2, "JusticePoints", "inv_chest_robe_dungeonrobe_c_04", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "JusticePoints#3", "inv_chest_mail_dungeonmail_c_04", "=ds="..BabbleInventory["Mail"], ""};
				{ 5, "JusticePoints#5", "inv_misc_forestnecklace", "=ds="..AL["Accessories"].." & "..AL["Weapons"], ""};
				{ 17, "JusticePoints#2", "inv_helmet_193", "=ds="..BabbleInventory["Leather"], ""};
				{ 18, "JusticePoints#4", "inv_gauntlets_plate_dungeonplate_c_04", "=ds="..BabbleInventory["Plate"], ""};
				{ 20, "JusticePoints#6", "inv_misc_greateressence", "=ds="..AL["Other"], ""};
			};
		};
		info = {
			name = AL["Justice Points"].." "..AL["Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["WOTLKEMBLEMMENU"] = {
		["Normal"] = {
			{
				{ 2, "EmblemofFrost", "inv_misc_frostemblem_01", "=ds="..AL["Emblem of Frost"], "=q5="..BabbleInventory["Armor"].." & "..AL["Weapons"]};
				{ 4, "EmblemofTriumph", "spell_holy_summonchampion", "=ds="..AL["Emblem of Triumph"], "=q5="..BabbleInventory["Armor"]};
				{ 5, "EmblemofTriumph2", "spell_holy_summonchampion", "=ds="..AL["Emblem of Triumph"], "=q5="..AL["Accessories"].." & "..AL["Weapons"]};
				{ 7, "EmblemofConquest", "Spell_Holy_ChampionsGrace", "=ds="..AL["Emblem of Conquest"], "=q5="..BabbleInventory["Armor"]};
				{ 9, "EmblemofValor", "Spell_Holy_ProclaimChampion_02", "=ds="..AL["Emblem of Valor"], "=q5="..BabbleInventory["Armor"]};
				{ 11, "EmblemofHeroism", "Spell_Holy_ProclaimChampion", "=ds="..AL["Emblem of Heroism"], "=q5="..BabbleInventory["Armor"].." & "..AL["Weapons"]};
				{ 12, "EmblemofHeroism#3", "Spell_Holy_ProclaimChampion", "=ds="..AL["Emblem of Heroism"], "=q5="..BabbleInventory["Miscellaneous"]};
				{ 14, "PVP80SET", "INV_Boots_01", "=ds="..AL["PvP Armor Sets"], "=q5="..AL["Level 80"]};
				{ 17, "T10SET", "inv_misc_frostemblem_01", "=ds="..AL["Tier 10 Set"], "=q5="..AL["10/25 Man"]};
				{ 19, "T9SET", "spell_holy_summonchampion", "=ds="..AL["Tier 9 Set"], "=q5="..AL["10/25 Man"]};
				{ 22, "EmblemofConquest#2", "Spell_Holy_ChampionsGrace", "=ds="..AL["Emblem of Conquest"], "=q5="..AL["Accessories"]};
				{ 24, "EmblemofValor#2", "Spell_Holy_ProclaimChampion_02", "=ds="..AL["Emblem of Valor"], "=q5="..AL["Accessories"]};
				{ 26, "EmblemofHeroism#2", "Spell_Holy_ProclaimChampion", "=ds="..AL["Emblem of Heroism"], "=q5="..AL["Accessories"]};
			};
		};
		info = {
			name = AL["Emblem Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["70TOKENMENU"] = {
		["Normal"] = {
			{
				{ 2, "HardModeCloth", "inv_pants_cloth_15", "=ds="..BabbleInventory["Cloth"], ""};
				{ 3, "HardModeMail", "inv_pants_mail_26", "=ds="..BabbleInventory["Mail"], ""};
				{ 4, "HardModeResist", "inv_chest_cloth_18", "=ds="..AL["Fire Resistance Gear"], ""};
				{ 6, "HardModeRelic", "spell_nature_sentinal", "=ds="..BabbleInventory["Relic"], ""};
				{ 8, "HardModeWeapons", "inv_shield_33", "=ds="..AL["Weapons"], ""};
				{ 17, "HardModeLeather", "inv_shoulder_83", "=ds="..BabbleInventory["Leather"], ""};
				{ 18, "HardModePlate", "inv_belt_27", "=ds="..BabbleInventory["Plate"], ""};
				{ 19, "HardModeCloaks", "inv_misc_cape_06", "=ds="..BabbleInventory["Back"], ""};
				{ 21, "HardModeArena", "inv_bracer_07", "=ds="..AL["PvP Rewards"], ""};
				{ 23, "HardModeAccessories", "inv_valentineperfumebottle", "=ds="..AL["Accessories"], ""};
			};
		};
		info = {
			name = AL["Badge of Justice"].." "..AL["Rewards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["WORLDEPICS"] = {
		["Normal"] = {
			{
				{ 2, "WorldEpics85", "inv_misc_cape_cataclysm_caster_c_01", "=ds="..AL["Level 85"], ""};
				{ 3, "WorldEpics70", "INV_Sword_76", "=ds="..AL["Level 70"], ""};
				{ 4, "WorldEpics4049", "INV_Staff_29", "=ds="..AL["Level 40-49"], ""};
				{ 17, "WorldEpics80", "INV_Sword_109", "=ds="..AL["Level 80"], ""};
				{ 18, "WorldEpics5060", "INV_Jewelry_Amulet_01", "=ds="..AL["Level 50-60"], ""};
				{ 19, "WorldEpics3039", "INV_Jewelry_Ring_15", "=ds="..AL["Level 30-39"], ""};
			};
		};
		info = {
			name = AL["BoE World Epics"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["MOUNTMENU"] = {
		["Normal"] = {
			{
				{ 2, "MountsAlliance", "achievement_pvp_a_16", "=ds="..BabbleFaction["Darnassus"].." / "..BabbleFaction["Gnomeregan"], "=ec1="..AL["Alliance Mounts"]};
				{ 3, "MountsAlliance#2", "achievement_pvp_a_16", "=ds="..BabbleFaction["Ironforge"].." / "..BabbleFaction["Exodar"].." / "..BabbleFaction["Stormwind"], "=ec1="..AL["Alliance Mounts"]};
				{ 4, "MountsAlliance#3", "achievement_pvp_a_16", "=ds="..AL["Alliance Flying Mounts"].." / "..BabbleFaction["Kurenai"], "=ec1="..AL["Alliance Mounts"]};
				{ 5, "MountsAlliance#4", "achievement_pvp_a_16", "=ds="..BabbleZone["Dalaran"].." / "..AL["Misc"], "=ec1="..AL["Alliance Mounts"]};
				{ 7, "MountsFaction", "ability_mount_warhippogryph", "=ds="..AL["Neutral Faction Mounts"], ""};
				{ 8, "MountsRare", "ability_mount_drake_bronze", "=ds="..AL["Rare Mounts"], ""};
				{ 9, "MountsCraftQuest", "ability_mount_gyrocoptorelite", "=ds="..BabbleInventory["Quest"].." / "..AL["Crafted Mounts"], ""};
				{ 10, "MountsEvent", "achievement_halloween_witch_01", "=ds="..AL["World Events"], ""};
				{ 11, "MountsCata", "INV_Misc_Coin_01", "=ds="..AL["Cataclysm"], ""};
				{ 17, "MountsHorde", "achievement_pvp_h_16", "=ds="..BabbleFaction["Orgrimmar"].." / "..BabbleFaction["Silvermoon City"], "=ec1="..AL["Horde Mounts"]};
				{ 18, "MountsHorde#2", "achievement_pvp_h_16", "=ds="..BabbleFaction["Darkspear Trolls"].." / "..BabbleFaction["Thunder Bluff"].." / "..BabbleFaction["Undercity"], "=ec1="..AL["Horde Mounts"]};
				{ 19, "MountsHorde#3", "achievement_pvp_h_16", "=ds="..AL["Horde Flying Mounts"].." / "..BabbleFaction["The Mag'har"], "=ec1="..AL["Horde Mounts"]};
				{ 20, "MountsHorde#4", "achievement_pvp_h_16", "=ds="..BabbleZone["Dalaran"].." / "..AL["Misc"], "=ec1="..AL["Horde Mounts"]};
				{ 22, "MountsPvP", "ability_mount_netherdrakeelite", "=ds="..AL["PvP Mounts"], ""};
				{ 23, "MountsAchievement", "achievement_halloween_witch_01", "=ds="..AL["Achievement Reward"], ""};
				{ 24, "MountsCardGamePromotional", "ability_mount_bigblizzardbear", "=ds="..AL["Promotional & Card Game"], ""};
				{ 25, "MountsRemoved", "INV_Misc_QirajiCrystal_05", "=ds="..AL["Unobtainable Mounts"], ""};
			};
		};
		info = {
			name = BabbleInventory["Mounts"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["PETMENU"] = {
		["Normal"] = {
			{
				{ 2, "PetsMerchant", "spell_nature_polymorph", "=ds="..AL["Merchant Sold Companions"], ""};
				{ 3, "PetsCrafted", "inv_drink_19", "=ds="..AL["Crafted Companions"], ""};
				{ 4, "PetsRare", "spell_shaman_hex", "=ds="..AL["Rare Companions"], ""};
				{ 5, "PetsPromotionalCardGame", "inv_netherwhelp", "=ds="..AL["Promotional & Card Game"], ""};
				{ 6, "PetsRemoved", "inv_pet_babyblizzardbear", "=ds="..AL["Unobtainable Companions"], ""};
				{ 7, "PetsCata", "INV_Misc_Coin_01", "=ds="..AL["Cataclysm"], ""};
				{ 17, "PetsQuest", "inv_drink_19", "=ds="..AL["Quest Reward Companions"], ""};
				{ 18, "PetsAchievementFaction", "spell_shaman_hex", "=ds="..AL["Achievement & Faction Reward"], ""};
				{ 19, "PetsEvent", "inv_pet_egbert", "=ds="..AL["World Events"], ""};
				{ 20, "PetsPetStore", "INV_Misc_Coin_01", "=ds="..AL["Companion Store"], ""};
				{ 21, "PetsAccessories", "inv_misc_petbiscuit_01", "=ds="..AL["Companion Accessories"], ""};
			};
		};
		info = {
			name = BabbleInventory["Companions"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["TABARDMENU"] = {
		["Normal"] = {
			{
				{ 2, "TabardsAlliance", "achievement_pvp_a_16", "=ds="..AL["Alliance Tabards"], ""};
				{ 3, "TabardsNeutralFaction", "inv_chest_cloth_30", "=ds="..AL["Neutral Faction Tabards"], ""};
				{ 4, "TabardsCardGame", "inv_misc_tabardpvp_02", "=ds="..AL["Card Game Tabards"], ""};
				{ 17, "TabardsHorde", "achievement_pvp_h_16", "=ds="..AL["Horde Tabards"], ""};
				{ 18, "TabardsAchievementQuestRareMisc", "inv_shirt_guildtabard_01", "=ds="..AL["Achievement & Quest Reward Tabards"], ""};
				{ 19, "TabardsRemoved", "INV_Jewelry_Ring_15", "=ds="..AL["Unobtainable Tabards"], ""};
			};
		};
		info = {
			name = BabbleInventory["Tabards"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["SETSMISCMENU"] = {
		["Normal"] = {
			{
				{ 2, "SETSCLASSIC", "INV_Sword_43", "=ds="..AL["Classic WoW"].." "..AL["Sets"], ""};
				{ 3, "WOTLKSets", "inv_misc_monsterscales_15", "=ds="..AL["Wrath of the Lich King"].." "..AL["Sets"], ""};
				{ 5, "ZGSets", "achievement_boss_hakkar", "=ds="..BabbleZone["Zul'Gurub"].." "..AL["Set"], "=q5="..AL["Classic WoW"]};
				{ 6, "AQ20Sets", "achievement_boss_ossiriantheunscarred", "=ds="..BabbleZone["Ruins of Ahn'Qiraj"].." "..AL["Set"], "=q5="..AL["Classic WoW"]};
				{ 8, "T0SET", "INV_Chest_Chain_03", "=ds="..AL["Dungeon Set 1/2"], "=q5="..AL["Classic WoW"]};
				{ 17, "TBCSets", "INV_Weapon_Glave_01", "=ds="..AL["Burning Crusade"].." "..AL["Sets"], ""};
				{ 20, "AQ40Sets", "achievement_boss_cthun", "=ds="..BabbleZone["Temple of Ahn'Qiraj"].." "..AL["Set"], "=q5="..AL["Classic WoW"]};
				{ 23, "DS3SET", "INV_Helmet_15", "=ds="..AL["Dungeon Set 3"], "=q5="..AL["Burning Crusade"]};
			};
		};
		info = {
			name = AL["Misc Sets"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["SETSCLASSIC"] = {
		["Normal"] = {
			{
				{ 2, "VWOWSets#1", "INV_Pants_12", "=ds="..BabbleItemSet["Defias Leather"], "=q5="..BabbleZone["The Deadmines"]};
				{ 3, "VWOWSets#1", "INV_Shirt_16", "=ds="..BabbleItemSet["Embrace of the Viper"], "=q5="..BabbleZone["Wailing Caverns"]};
				{ 4, "VWOWSets#1", "INV_Gauntlets_19", "=ds="..BabbleItemSet["Chain of the Scarlet Crusade"], "=q5="..BabbleZone["Scarlet Monastery"]};
				{ 5, "VWOWSets#1", "INV_Helmet_01", "=ds="..BabbleItemSet["The Gladiator"], "=q5="..BabbleZone["Blackrock Depths"]};
				{ 6, "VWOWSets#2", "INV_Boots_Cloth_05", "=ds="..BabbleItemSet["Ironweave Battlesuit"], "=q5="..AL["Various Locations"]};
				{ 7, "VWOWSets#2", "INV_Boots_02", "=ds="..BabbleItemSet["The Postmaster"], "=q5="..BabbleZone["Stratholme"]};
				{ 8, "VWOWScholo", "INV_Shoulder_02", "=ds="..BabbleItemSet["Necropile Raiment"], "=q5="..BabbleZone["Scholomance"]};
				{ 9, "VWOWScholo", "INV_Belt_16", "=ds="..BabbleItemSet["Cadaverous Garb"], "=q5="..BabbleZone["Scholomance"]};
				{ 10, "VWOWScholo", "INV_Gauntlets_26", "=ds="..BabbleItemSet["Bloodmail Regalia"], "=q5="..BabbleZone["Scholomance"]};
				{ 11, "VWOWScholo", "INV_Belt_12", "=ds="..BabbleItemSet["Deathbone Guardian"], "=q5="..BabbleZone["Scholomance"]};
				{ 17, "VWOWSets#3", "INV_Weapon_ShortBlade_16", "=ds="..BabbleItemSet["Spider's Kiss"], "=q5="..BabbleZone["Lower Blackrock Spire"]};
				{ 18, "VWOWSets#3", "INV_Sword_43", "=ds="..BabbleItemSet["Dal'Rend's Arms"], "=q5="..BabbleZone["Upper Blackrock Spire"]};
				{ 19, "VWOWZulGurub", "INV_Bijou_Orange", "=ds="..AL["Zul'Gurub Rings"], "=q5="..BabbleZone["Zul'Gurub"]};
				{ 20, "VWOWZulGurub", "INV_Weapon_Hand_01", "=ds="..BabbleItemSet["Primal Blessing"], "=q5="..BabbleZone["Zul'Gurub"]};
				{ 21, "VWOWZulGurub", "INV_Sword_55", "=ds="..BabbleItemSet["The Twin Blades of Hakkari"], "=q5="..BabbleZone["Zul'Gurub"]};
				{ 22, "VWOWSets#3", "INV_Misc_MonsterScales_15", "=ds="..BabbleItemSet["Shard of the Gods"], "=q5="..AL["Various Locations"]};
				{ 23, "VWOWSets#3", "INV_Misc_MonsterClaw_04", "=ds="..BabbleItemSet["Spirit of Eskhandar"], "=q5="..AL["Various Locations"]};
			};
		};
		info = {
			name = AL["Classic WoW"].." "..AL["Sets"],
			menu = "SETSMISCMENU",
		};
	}

	AtlasLoot_Data["T0SET"] = {
		["Normal"] = {
			{
				{ 3, "T0Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], ""};
				{ 4, "T0Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 5, "T0Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], ""};
				{ 6, "T0Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], ""};
				{ 7, "T0Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], ""};
				{ 18, "T0Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 19, "T0Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], ""};
				{ 20, "T0Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 21, "T0Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
			};
		};
		info = {
			name = AL["Dungeon Set 1/2"],
			menu = "SETSMISCMENU",
		};
	}

	AtlasLoot_Data["DS3SET"] = {
		["Normal"] = {
			{
				{ 2, "DS3Cloth", "Spell_Holy_InnerFire", "=ds="..BabbleItemSet["Hallowed Raiment"], "=q5="..BabbleInventory["Cloth"]};
				{ 3, "DS3Cloth", "INV_Elemental_Mote_Nether", "=ds="..BabbleItemSet["Mana-Etched Regalia"], "=q5="..BabbleInventory["Cloth"]};
				{ 5, "DS3Leather", "Ability_Rogue_SinisterCalling", "=ds="..BabbleItemSet["Assassination Armor"], "=q5="..BabbleInventory["Leather"]};
				{ 6, "DS3Leather", "Ability_Hunter_RapidKilling", "=ds="..BabbleItemSet["Wastewalker Armor"], "=q5="..BabbleInventory["Leather"]};
				{ 8, "DS3Mail", "Ability_Hunter_Pet_Wolf", "=ds="..BabbleItemSet["Beast Lord Armor"], "=q5="..BabbleInventory["Mail"]};
				{ 9, "DS3Mail", "INV_Helmet_70", "=ds="..BabbleItemSet["Tidefury Raiment"], "=q5="..BabbleInventory["Mail"]};
				{ 11, "DS3Plate", "Spell_Fire_EnchantWeapon", "=ds="..BabbleItemSet["Bold Armor"], "=q5="..BabbleInventory["Plate"]};
				{ 12, "DS3Plate", "INV_Hammer_02", "=ds="..BabbleItemSet["Righteous Armor"], "=q5="..BabbleInventory["Plate"]};
				{ 17, "DS3Cloth", "Ability_Creature_Cursed_04", "=ds="..BabbleItemSet["Incanter's Regalia"], "=q5="..BabbleInventory["Cloth"]};
				{ 18, "DS3Cloth", "Ability_Creature_Cursed_03", "=ds="..BabbleItemSet["Oblivion Raiment"], "=q5="..BabbleInventory["Cloth"]};
				{ 20, "DS3Leather", "Spell_Holy_SealOfRighteousness", "=ds="..BabbleItemSet["Moonglade Raiment"], "=q5="..BabbleInventory["Leather"]};
				{ 23, "DS3Mail", "Ability_FiegnDead", "=ds="..BabbleItemSet["Desolation Battlegear"], "=q5="..BabbleInventory["Mail"]};
				{ 26, "DS3Plate", "INV_Helmet_08", "=ds="..BabbleItemSet["Doomplate Battlegear"], "=q5="..BabbleInventory["Plate"]};
			};
		};
		info = {
			name = AL["Dungeon Set 3"],
			menu = "SETSMISCMENU",
		};
	}

	AtlasLoot_Data["T1T2T3SET"] = {
		["Normal"] = {
			{
				{ 1, "T1T2Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Tier 1/2 Set"]};
				{ 2, "T3Druid", "ability_druid_maul", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Tier 3 Set"]};
				{ 4, "T1T2Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], "=q5="..AL["Tier 1/2 Set"]};
				{ 5, "T3Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], "=q5="..AL["Tier 3 Set"]};
				{ 7, "T1T2Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Tier 1/2 Set"]};
				{ 8, "T3Priest", "inv_staff_30", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Tier 3 Set"]};
				{ 10, "T1T2Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Tier 1/2 Set"]};
				{ 11, "T3Shaman", "spell_nature_bloodlust", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Tier 3 Set"]};
				{ 13, "T1T2Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Tier 1/2 Set"]};
				{ 14, "T3Warrior", "inv_sword_27", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Tier 3 Set"]};
				{ 17, "T1T2Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], "=q5="..AL["Tier 1/2 Set"]};
				{ 18, "T3Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], "=q5="..AL["Tier 3 Set"]};
				{ 20, "T1T2Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Tier 1/2 Set"]};
				{ 21, "T3Paladin", "ability_thunderbolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Tier 3 Set"]};
				{ 23, "T1T2Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], "=q5="..AL["Tier 1/2 Set"]};
				{ 24, "T3Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], "=q5="..AL["Tier 3 Set"]};
				{ 26, "T1T2Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Tier 1/2 Set"]};
				{ 27, "T3Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], "=q5="..AL["Tier 3 Set"]};
			};
		};
		info = {
			name = AL["Tier 1/2/3 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T456SET"] = {
		["Normal"] = {
			{
				{ 3, "T456DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 4, "T456DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 5, "T456DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 7, "T456Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 9, "T456Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 11, "T456PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 12, "T456PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 13, "T456PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T456PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T456PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T456Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T456ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T456ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T456ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T456Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T456WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T456WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 4/5/6 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T7T8SET"] = {
		["Normal"] = {
			{
				{ 2, "NaxxDeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "NaxxDeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "NaxxDruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "NaxxDruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "NaxxDruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "NaxxHunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "NaxxMage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "NaxxPaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "NaxxPaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "NaxxPaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "NaxxPriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "NaxxPriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "NaxxRogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "NaxxShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "NaxxShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "NaxxShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "NaxxWarlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "NaxxWarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "NaxxWarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 7/8 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T9SET"] = {
		["Normal"] = {
			{
				{ 2, "T9DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T9DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T9DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T9DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T9DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T9Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T9Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T9PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T9PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T9PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T9PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T9PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T9Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T9ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T9ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T9ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T9Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T9WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T9WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 9 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T10SET"] = {
		["Normal"] = {
			{
				{ 2, "T10DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T10DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T10DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T10DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T10DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T10Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T10Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T10PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T10PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T10PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T10PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T10PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T10Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T10ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T10ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T10ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T10Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T10WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T10WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 10 Set"],
			menu = "SETMENU",
		};
	}

	AtlasLoot_Data["T11SET"] = {
		["Normal"] = {
			{
				{ 2, "T11DeathKnightDPS", "spell_deathknight_frostpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["DPS"]};
				{ 3, "T11DeathKnightTank", "spell_deathknight_bloodpresence", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"], "=q5="..AL["Tanking"]};
				{ 5, "T11DruidBalance", "spell_nature_starfall", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Balance"]};
				{ 6, "T11DruidFeral", "ability_racial_bearform", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Feral"]};
				{ 7, "T11DruidRestoration", "spell_nature_healingtouch", "=ds="..LOCALIZED_CLASS_NAMES_MALE["DRUID"], "=q5="..AL["Restoration"]};
				{ 9, "T11Hunter", "inv_weapon_bow_07", "=ds="..LOCALIZED_CLASS_NAMES_MALE["HUNTER"], ""};
				{ 11, "T11Mage", "inv_staff_13", "=ds="..LOCALIZED_CLASS_NAMES_MALE["MAGE"], ""};
				{ 13, "T11PaladinHoly", "Spell_Holy_HolyBolt", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Holy"]};
				{ 14, "T11PaladinProtection", "spell_holy_devotionaura", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Protection"]};
				{ 15, "T11PaladinRetribution", "Spell_Holy_AuraOfLight", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PALADIN"], "=q5="..AL["Retribution"]};
				{ 17, "T11PriestHoly", "spell_holy_guardianspirit", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Holy"]};
				{ 18, "T11PriestShadow", "spell_shadow_shadowwordpain", "=ds="..LOCALIZED_CLASS_NAMES_MALE["PRIEST"], "=q5="..AL["Shadow"]};
				{ 20, "T11Rogue", "inv_throwingknife_04", "=ds="..LOCALIZED_CLASS_NAMES_MALE["ROGUE"], ""};
				{ 22, "T11ShamanElemental", "Spell_Nature_Lightning", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Elemental"]};
				{ 23, "T11ShamanEnhancement", "spell_nature_lightningshield", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Enhancement"]};
				{ 24, "T11ShamanRestoration", "spell_nature_magicimmunity", "=ds="..LOCALIZED_CLASS_NAMES_MALE["SHAMAN"], "=q5="..AL["Restoration"]};
				{ 26, "T11Warlock", "spell_nature_drowsy", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARLOCK"], ""};
				{ 28, "T11WarriorFury", "ability_warrior_innerrage", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["DPS"]};
				{ 29, "T11WarriorProtection", "ability_warrior_defensivestance", "=ds="..LOCALIZED_CLASS_NAMES_MALE["WARRIOR"], "=q5="..AL["Protection"]};
			};
		};
		info = {
			name = AL["Tier 11 Set"],
			menu = "SETMENU",
		};
	}