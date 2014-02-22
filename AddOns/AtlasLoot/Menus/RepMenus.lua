local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")

	AtlasLoot_Data["REPMENU"] = {
		["Normal"] = {
			{
				{ 2, "REPMENU_ORIGINALWOW", "INV_Helmet_66", "=ds="..AL["Classic WoW"], ""};
				{ 3, "REPMENU_WOTLK", "achievement_reputation_kirintor", "=ds="..AL["Wrath of the Lich King"], ""};
				{ 17, "REPMENU_BURNINGCRUSADE", "INV_Misc_Ribbon_01", "=ds="..AL["Burning Crusade"], ""};
				{ 5, "BaradinsWardens", "inv_misc_tabard_baradinwardens", "=ds="..BabbleFaction["Baradin's Wardens"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Tol Barad"]};
				{ 20, "DragonmawClan", "inv_misc_tabard_dragonmawclan", "=ds="..BabbleFaction["Dragonmaw Clan"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Twilight Highlands"]};
				{ 6, "EarthenRing", "inv_misc_tabard_earthenring", "=ds="..BabbleFaction["The Earthen Ring"], "=q5="..BabbleZone["Vashj'ir"].." / "..BabbleZone["Deepholm"]};
				{ 21, "GuardiansHyjal", "inv_misc_tabard_guardiansofhyjal", "=ds="..BabbleFaction["Guardians of Hyjal"], "=q5="..BabbleZone["Mount Hyjal"]};
				{ 7, "HellscreamsReach", "inv_misc_tabard_hellscream", "=ds="..BabbleFaction["Hellscream's Reach"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Tol Barad"]};
				{ 22, "Ramkahen", "inv_misc_tabard_tolvir", "=ds="..BabbleFaction["Ramkahen"], "=q5="..BabbleZone["Uldum"]};
				{ 8, "Therazane", "inv_misc_tabard_therazane", "=ds="..BabbleFaction["Therazane"], "=q5="..BabbleZone["Deepholm"]};
				{ 23, "WildhammerClan", "inv_misc_tabard_wildhammerclan", "=ds="..BabbleFaction["Wildhammer Clan"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Twilight Highlands"]};
			};
		};
		info = {
			name = AL["Factions"],
		};
	}

	AtlasLoot_Data["REPMENU_ORIGINALWOW"] = {
		["Normal"] = {
			{
				{ 1, "ArgentDawn", "inv_jewelry_talisman_07", "=ds="..BabbleFaction["Argent Dawn"], "=q5="..BabbleZone["Eastern Plaguelands"]}; 
				{ 2, "AQBroodRings", "inv_misc_head_dragon_bronze", "=ds="..BabbleFaction["Brood of Nozdormu"], "=q5="..BabbleZone["Temple of Ahn'Qiraj"].." / "..BabbleZone["Caverns of Time"]};
				{ 3, "MiscFactions", "spell_shadow_psychichorrors", "=ds="..BabbleFaction["The Defilers"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Arathi Basin"]}; 
				{ 4, "MiscFactions", "INV_Misc_Head_Centaur_01", "=ds="..BabbleFaction["Gelkis Clan Centaur"], "=q5="..BabbleZone["Desolace"]};
				{ 5, "MiscFactions", "ability_warrior_rallyingcry", "=ds="..BabbleFaction["The League of Arathor"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Arathi Basin"]};
				{ 6, "AlteracFactions", "inv_jewelry_stormpiketrinket_05", "=ds="..BabbleFaction["Stormpike Guard"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Alterac Valley"]};
				{ 7, "Timbermaw", "achievement_reputation_timbermaw", "=ds="..BabbleFaction["Timbermaw Hold"], ""};
				--{ 8, "Zandalar", "inv_bijou_green", "=ds="..BabbleFaction["Zandalar Tribe"], "=q5="..BabbleZone["Zul'Gurub"]};
				{ 10, "Darnassus", "inv_misc_tournaments_symbol_nightelf", "=ds="..BabbleFaction["Darnassus"], "=q5="..BabbleFaction["Alliance"]};
				{ 11, "Exodar", "inv_misc_tournaments_symbol_draenei", "=ds="..BabbleFaction["Exodar"], "=q5="..BabbleFaction["Alliance"]};
				{ 12, "Gilneas", "achievement_win_gilneas", "=ds="..BabbleFaction["Gilneas"], "=q5="..BabbleFaction["Alliance"]};
				{ 13, "GnomereganRep", "inv_misc_tournaments_symbol_gnome", "=ds="..BabbleFaction["Gnomeregan"], "=q5="..BabbleFaction["Alliance"]};
				{ 14, "Ironforge", "inv_misc_tournaments_symbol_dwarf", "=ds="..BabbleFaction["Ironforge"], "=q5="..BabbleFaction["Alliance"]};
				{ 15, "Stormwind", "inv_misc_tournaments_symbol_human", "=ds="..BabbleFaction["Stormwind"], "=q5="..BabbleFaction["Alliance"]};
				{ 16, "BloodsailHydraxian", "INV_Helmet_66", "=ds="..BabbleFaction["Bloodsail Buccaneers"], "=q5="..BabbleZone["Stranglethorn Vale"]};
				{ 17, "CenarionCircle", "ability_racial_ultravision", "=ds="..BabbleFaction["Cenarion Circle"], ""};
				{ 18, "AlteracFactions", "inv_jewelry_frostwolftrinket_05", "=ds="..BabbleFaction["Frostwolf Clan"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Alterac Valley"]};
				{ 19, "BloodsailHydraxian", "Spell_Frost_SummonWaterElemental_2", "=ds="..BabbleFaction["Hydraxian Waterlords"], "=q5="..BabbleZone["Molten Core"]};
				{ 20, "MiscFactions", "INV_Misc_Head_Centaur_01", "=ds="..BabbleFaction["Magram Clan Centaur"], "=q5="..BabbleZone["Desolace"]};
				{ 21, "ThoriumBrotherhood", "INV_Ingot_Mithril", "=ds="..BabbleFaction["Thorium Brotherhood"], "=q5="..BabbleZone["Searing Gorge"]};
				{ 22, "MiscFactions", "Ability_Mount_PinkTiger", "=ds="..BabbleFaction["Wintersaber Trainers"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Winterspring"]};
				{ 25, "BilgewaterCartel", "inv_misc_tournaments_symbol_nightelf", "=ds="..BabbleFaction["Bilgewater Cartel"], "=q5="..BabbleFaction["Horde"]};
				{ 26, "DarkspearTrolls", "inv_misc_tournaments_symbol_troll", "=ds="..BabbleFaction["Darkspear Trolls"], "=q5="..BabbleFaction["Horde"]};
				{ 27, "Orgrimmar", "inv_misc_tournaments_symbol_orc", "=ds="..BabbleFaction["Orgrimmar"], "=q5="..BabbleFaction["Horde"]};
				{ 28, "SilvermoonCity", "inv_misc_tournaments_symbol_bloodelf", "=ds="..BabbleFaction["Silvermoon City"], "=q5="..BabbleFaction["Horde"]};
				{ 29, "ThunderBluff", "inv_misc_tournaments_symbol_tauren", "=ds="..BabbleFaction["Thunder Bluff"], "=q5="..BabbleFaction["Horde"]};
				{ 30, "Undercity", "inv_misc_tournaments_symbol_scourge", "=ds="..BabbleFaction["Undercity"], "=q5="..BabbleFaction["Horde"]};
			};
		};
		info = {
			name = AL["Factions"].." - "..AL["Classic WoW"],
			menu = "REPMENU",
		};
	}
	
	AtlasLoot_Data["REPMENU_BURNINGCRUSADE"] = {
		["Normal"] = {
			{
				{ 2, "Aldor", "INV_Jewelry_Talisman_08", "=ds="..BabbleFaction["The Aldor"], ""};
				{ 3, "CExpedition", "INV_Misc_Ammo_Arrow_02", "=ds="..BabbleFaction["Cenarion Expedition"], "=q5="..BabbleZone["Zangarmarsh"]};
				{ 4, "HonorHold", "INV_BannerPVP_02", "=ds="..BabbleFaction["Honor Hold"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Hellfire Peninsula"]};
				{ 5, "Kurenai", "INV_Misc_Foot_Centaur", "=ds="..BabbleFaction["Kurenai"], "=q5="..BabbleFaction["Alliance"].." - "..BabbleZone["Nagrand"]};
				{ 6, "Maghar", "INV_Misc_Foot_Centaur", "=ds="..BabbleFaction["The Mag'har"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Nagrand"]};
				{ 7, "Ogrila", "inv_misc_apexis_crystal", "=ds="..BabbleFaction["Ogri'la"], "=q5="..BabbleZone["Blade's Edge Mountains"]};
				{ 8, "Scryer", "INV_Misc_Foot_Centaur", "=ds="..BabbleFaction["The Scryers"], ""};
				{ 9, "Skyguard", "ability_hunter_pet_netherray", "=ds="..BabbleFaction["Sha'tari Skyguard"], "=q5="..BabbleZone["Terokkar Forest"].." / "..BabbleZone["Blade's Edge Mountains"]};
				{ 10, "Sporeggar", "inv_mushroom_11", "=ds="..BabbleFaction["Sporeggar"], "=q5="..BabbleZone["Zangarmarsh"]};
				{ 11, "Tranquillien", "INV_Misc_Bandana_03", "=ds="..BabbleFaction["Tranquillien"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Ghostlands"]};
				{ 17, "Ashtongue", "achievement_reputation_ashtonguedeathsworn", "=ds="..BabbleFaction["Ashtongue Deathsworn"], "=q5="..BabbleZone["Shadowmoon Valley"].." / "..BabbleZone["Black Temple"]};
				{ 18, "Consortium", "inv_enchant_shardprismaticlarge", "=ds="..BabbleFaction["The Consortium"], ""};
				{ 19, "KeepersofTime", "Ability_Warrior_VictoryRush", "=ds="..BabbleFaction["Keepers of Time"], "=q5="..BabbleZone["Caverns of Time"]};
				{ 20, "LowerCity", "Spell_Holy_ChampionsBond", "=ds="..BabbleFaction["Lower City"], ""};
				{ 21, "Netherwing", "Ability_Mount_Netherdrakepurple", "=ds="..BabbleFaction["Netherwing"], "=q5="..BabbleZone["Shadowmoon Valley"]};
				{ 22, "ScaleSands", "inv_enchant_dustillusion", "=ds="..BabbleFaction["The Scale of the Sands"], "=q5="..BabbleZone["Hyjal Summit"]};
				{ 23, "Shatar", "Ability_Warrior_ShieldMastery", "=ds="..BabbleFaction["The Sha'tar"], ""};
				{ 24, "SunOffensive", "inv_shield_48", "=ds="..BabbleFaction["Shattered Sun Offensive"], "=q5="..BabbleZone["Isle of Quel'Danas"]};
				{ 25, "Thrallmar", "INV_BannerPVP_01", "=ds="..BabbleFaction["Thrallmar"], "=q5="..BabbleFaction["Horde"].." - "..BabbleZone["Hellfire Peninsula"]};
				{ 26, "VioletEye", "spell_holy_mindsooth", "=ds="..BabbleFaction["The Violet Eye"], "=q5="..BabbleZone["Karazhan"]};
			};
		};
		info = {
			name = AL["Factions"].." - "..AL["Burning Crusade"],
			menu = "REPMENU",
		};
	}

	AtlasLoot_Data["REPMENU_WOTLK"] = {
		["Normal"] = {
			{
				{ 2, "AllianceVanguard", "spell_misc_hellifrepvphonorholdfavor", "=ds="..BabbleFaction["Alliance Vanguard"], "=q5="..BabbleFaction["Alliance"]};
				{ 3, "WinterfinRetreat", "INV_Misc_Shell_04", "=ds="..BabbleFaction["Winterfin Retreat"], "=q5="..BabbleZone["Borean Tundra"]};
				{ 4, "TheWyrmrestAccord", "achievement_reputation_wyrmresttemple", "=ds="..BabbleFaction["The Wyrmrest Accord"], "=q5="..BabbleZone["Dragonblight"]};
				{ 5, "KnightsoftheEbonBlade", "achievement_reputation_knightsoftheebonblade", "=ds="..BabbleFaction["Knights of the Ebon Blade"], "=q5="..BabbleZone["Zul'Drak"].." / "..BabbleZone["Icecrown"]};
				{ 6, "TheOracles", "inv_misc_head_murloc_01", "=ds="..BabbleFaction["The Oracles"], "=q5="..BabbleZone["Sholazar Basin"]};
				{ 7, "TheSonsofHodir", "Spell_Holy_DivinePurpose", "=ds="..BabbleFaction["The Sons of Hodir"], "=q5="..BabbleZone["The Storm Peaks"]};
				{ 8, "TheSilverCovenant", "inv_misc_tabardpvp_01", "=ds="..BabbleFaction["The Silver Covenant"], "=q5="..BabbleZone["Icecrown"].." / "..BabbleZone["Dalaran"]};
				{ 17, "HordeExpedition", "spell_misc_hellifrepvpthrallmarfavor", "=ds="..BabbleFaction["Horde Expedition"], "=q5="..BabbleFaction["Horde"]};
				{ 18, "TheKaluak", "achievement_reputation_tuskarr", "=ds="..BabbleFaction["The Kalu'ak"], "" };
				{ 19, "KirinTor", "achievement_reputation_kirintor", "=ds="..BabbleFaction["Kirin Tor"], "=q5="..BabbleZone["Borean Tundra"].." / "..BabbleZone["Dalaran"]};
				{ 20, "ArgentCrusade", "INV_Jewelry_Talisman_08", "=ds="..BabbleFaction["Argent Crusade"], "=q5="..BabbleZone["Zul'Drak"].." / "..BabbleZone["Icecrown"]};
				{ 21, "FrenzyheartTribe", "ability_mount_whitedirewolf", "=ds="..BabbleFaction["Frenzyheart Tribe"], "=q5="..BabbleZone["Sholazar Basin"]};
				{ 22, "TheAshenVerdict", "INV_Jewelry_Ring_85", "=ds="..BabbleFaction["The Ashen Verdict"], "=q5="..BabbleZone["Icecrown"]};
				{ 23, "TheSunreavers", "inv_misc_tabardpvp_02", "=ds="..BabbleFaction["The Sunreavers"], "=q5="..BabbleZone["Icecrown"].." / "..BabbleZone["Dalaran"]};
			};
		};
		info = {
			name = AL["Factions"].." - "..AL["Wrath of the Lich King"],
			menu = "REPMENU",
		};
	}
