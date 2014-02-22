local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")


	AtlasLoot_Data["WORLDEVENTMENU"] = {
		["Normal"] = {
			{
				{ 1, "ARGENTMENU", "Ability_Paladin_ArtofWar", "=ds="..AL["Argent Tournament"], "=q5="..BabbleZone["Icecrown"]};
				{ 3, "Brewfest", "achievement_worldevent_brewmaster", "=ds="..AL["Brewfest"], "=q5="..AL["Various Locations"]};
				{ 4, "DayoftheDead", "inv_misc_bone_humanskull_02", "=ds="..AL["Day of the Dead"], "=q5="..AL["Various Locations"]};
				{ 5, "Halloween", "achievement_halloween_witch_01", "=ds="..AL["Hallow's End"], "=q5="..AL["Various Locations"]};
				{ 6, "Valentineday", "achievement_worldevent_valentine", "=ds="..AL["Love is in the Air"], "=q5="..AL["Various Locations"]};
				{ 7, "MidsummerFestival", "inv_summerfest_symbol_high", "=ds="..AL["Midsummer Fire Festival"], "=q5="..AL["Various Locations"]};
				{ 8, "PilgrimsBounty", "inv_thanksgiving_turkey", "=ds="..AL["Pilgrim's Bounty"], "=q5="..AL["Various Locations"]};
				{ 10, "BashirLanding", "INV_Trinket_Naxxramas02", "=ds="..AL["Bash'ir Landing Skyguard Raid"], "=q5="..BabbleZone["Blade's Edge Mountains"]};
				{ 11, "GurubashiArena", "inv_misc_armorkit_04", "=ds="..AL["Gurubashi Arena Booty Run"], "=q5="..BabbleZone["Stranglethorn Vale"]};
				{ 13, "ABYSSALMENU", "INV_Staff_13", "=ds="..AL["Abyssal Council"], "=q5="..BabbleZone["Silithus"]};
				{ 14, "SKETTISMENU", "Spell_Nature_NaturesWrath", "=ds="..AL["Skettis"], "=q5="..BabbleZone["Terokkar Forest"]};
				{ 16, "DARKMOONMENU", "INV_Misc_Ticket_Tarot_Madness", "=ds="..BabbleFaction["Darkmoon Faire"], "=q5="..AL["Various Locations"]};
				{ 18, "ChildrensWeek", "inv_misc_toy_04", "=ds="..AL["Children's Week"], "=q5="..AL["Various Locations"]};
				{ 19, "Winterviel", "achievement_worldevent_merrymaker", "=ds="..AL["Feast of Winter Veil"], "=q5="..AL["Various Locations"]};
				{ 20, "HarvestFestival", "INV_Misc_Food_33", "=ds="..AL["Harvest Festival"], "=q5="..AL["Various Locations"]};
				{ 21, "LunarFestival", "achievement_worldevent_lunar", "=ds="..AL["Lunar Festival"], "=q5="..AL["Various Locations"]};
				{ 22, "Noblegarden", "inv_egg_09", "=ds="..AL["Noblegarden"], "=q5="..AL["Various Locations"]};
				{ 25, "ElementalInvasion", "INV_DataCrystal03", "=ds="..AL["Elemental Invasion"], "=q5="..AL["Various Locations"]};
				{ 26, "FishingExtravaganza", "inv_misc_fish_06", "=ds="..AL["Stranglethorn Fishing Extravaganza"], "=q5="..BabbleZone["Stranglethorn Vale"]};
				{ 28, "ETHEREUMMENU", "INV_Misc_PunchCards_Prismatic", "=ds="..AL["Ethereum Prison"], ""};
			};
		};
		info = {
			name = AL["World Events"],
		};
	}

	AtlasLoot_Data["ARGENTMENU"] = {
		["Normal"] = {
			{
				{ 2, "ArgentTournament", "inv_scroll_11", "=ds="..BabbleInventory["Miscellaneous"], ""};
				{ 3, "ArgentTournament#3", "inv_boots_plate_09", "=ds="..BabbleInventory["Armor"], ""};
				{ 4, "ArgentTournament#5", "achievement_reputation_argentchampion", "=ds="..BabbleInventory["Companions"], ""};
				{ 5, "ArgentTournament#8", "inv_jewelry_talisman_01", "=ds="..AL["Heirloom"], ""};
				{ 17, "ArgentTournament#2", "inv_misc_tournaments_tabard_human", "=ds="..BabbleInventory["Tabards"].." / "..AL["Banner"], ""};
				{ 18, "ArgentTournament#4", "inv_mace_29", "=ds="..AL["Weapons"], ""};
				{ 19, "ArgentTournament#6", "ability_mount_charger", "=ds="..BabbleInventory["Mounts"], ""};
			};
		};
		info = {
			name = AL["Argent Tournament"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["DARKMOONMENU"] = {
		["Normal"] = {
			{
				{ 2, 62046, "", "=q4=Earthquake Deck", "=ds=#m2#"};
				{ 3, 62048, "", "=q4=Darkmoon Card: Earthquake", "=q1=#m4#: =ds=#s14#"};
				{ 5, 62045, "", "=q4=Hurricane Deck", "=ds=#m2#"};
				{ 6, 62049, "", "=q4=Darkmoon Card: Hurricane", "=q1=#m4#: =ds=#s14#"};
				{ 7, 62051, "", "=q4=Darkmoon Card: Hurricane", "=q1=#m4#: =ds=#s14#"};
				{ 9, 62044, "", "=q4=Tsunami Deck", "=ds=#m2#"};
				{ 10, 62050, "", "=q4=Darkmoon Card: Tsunami", "=q1=#m4#: =ds=#s14#"};
				{ 12, 62021, "", "=q4=Volcanic Deck", "=ds=#m2#"};
				{ 13, 62047, "", "=q4=Darkmoon Card: Volcano", "=q1=#m4#: =ds=#s14#"};
				{ 17, "Darkmoon", "INV_Misc_Ticket_Darkmoon_01", "=ds="..AL["Darkmoon Faire Rewards"], ""};
				{ 18, "Darkmoon#2", "INV_Misc_Ticket_Tarot_Furies", "=ds="..AL["Low Level Decks"], ""};
				{ 19, "Darkmoon#3", "INV_Misc_Ticket_Tarot_Madness", "=ds="..AL["Level 60 & 70 Trinkets"], ""};
				{ 20, "Darkmoon#4", "INV_Inscription_TarotGreatness", "=ds="..AL["Level 80 Trinkets"], ""};
			};
		};
		info = {
			name = BabbleFaction["Darkmoon Faire"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["ABYSSALMENU"] = {
		["Normal"] = {
			{
				{ 2, "Templars", "INV_Jewelry_Talisman_05", "=ds="..AL["Abyssal Council"].." - "..AL["Templars"], ""};
				{ 3, "HighCouncil", "INV_Staff_13", "=ds="..AL["Abyssal Council"].." - "..AL["High Council"], ""};
				{ 17, "Dukes", "INV_Jewelry_Ring_36", "=ds="..AL["Abyssal Council"].." - "..AL["Dukes"], ""};
			};
		};
		info = {
			name = AL["Abyssal Council"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["ETHEREUMMENU"] = {
		["Normal"] = {
			{
				{ 2, "ArmbreakerHuffaz", "INV_Jewelry_Ring_59", "=ds="..AL["Armbreaker Huffaz"], ""};
				{ 3, "Forgosh", "INV_Boots_05", "=ds="..AL["Forgosh"], ""};
				{ 4, "MalevustheMad", "INV_Boots_Chain_04", "=ds="..AL["Malevus the Mad"], ""};
				{ 5, "WrathbringerLaztarash", "INV_Misc_Orb_01", "=ds="..AL["Wrathbringer Laz-tarash"], ""};
				{ 17, "FelTinkererZortan", "INV_Boots_Chain_08", "=ds="..AL["Fel Tinkerer Zortan"], ""};
				{ 18, "Gulbor", "INV_Jewelry_Necklace_29Naxxramas", "=ds="..AL["Gul'bor"], ""};
				{ 19, "PorfustheGemGorger", "INV_Boots_Cloth_01", "=ds="..AL["Porfus the Gem Gorger"], ""};
				{ 20, "BashirStasisChambers", "INV_Trinket_Naxxramas02", "=ds="..AL["Bash'ir Landing Stasis Chambers"], ""};
			};
		};
		info = {
			name = AL["Ethereum Prison"],
			menu = "WORLDEVENTMENU",
		};
	}

	AtlasLoot_Data["SKETTISMENU"] = {
		["Normal"] = {
			{
				{ 2, "DarkscreecherAkkarai", "INV_Misc_Rune_07", "=ds="..AL["Darkscreecher Akkarai"], ""};
				{ 3, "GezzaraktheHuntress", "INV_Misc_Rune_07", "=ds="..AL["Gezzarak the Huntress"], ""};
				{ 4, "Terokk", "INV_Misc_Rune_07", "=ds="..AL["Terokk"], ""};
				{ 17, "Karrog", "INV_Misc_Rune_07", "=ds="..AL["Karrog"], ""};
				{ 18, "VakkiztheWindrager", "INV_Misc_Rune_07", "=ds="..AL["Vakkiz the Windrager"], ""};
			};
		};
		info = {
			name = AL["Skettis"],
			menu = "WORLDEVENTMENU",
		};
	}