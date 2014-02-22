local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")
local moduleName = "AtlasLootCataclysm"

-- Index
--- Dungeons & Raids
---- Blackrock Caverns
---- Throne of the Tides
---- The Stonecore
---- Vortex Pinnacle
---- Lost City of Tol'vir
---- Grim Batol
---- Halls of Origination
---- The Deadmines
---- Shadowfang Keep
---- Bastion of Twilight
---- Blackwing Descent
---- Baradin Hold
--- Factions
---- Baradin's Wardens
---- Dragonmaw Clan
---- Hellscream's Reach
---- Ramkahen
---- The Earthen Ring
---- The Guardians of Hyjal
---- Therazane
---- Wildhammer Clan
--- PvP
---- PvP Armor Sets
---- Level 85 - Accessories
---- Level 85 - Trinkets
---- Level 85 - Non Set Epics
---- Level 85 - Weapons
--- Sets & Collections
---- Tier 11 Sets (T11)
---- Legendaries
---- Tabards
---- Trading Card Game Items
---- Companions
---- Mounts
---- Transformation Items
---- BoE World Epics
---- Heirloom Items
---- Justice Points Items
---- Valor Points Items

	------------------------
	--- Dungeons & Raids ---
	------------------------

		-------------------------
		--- Blackrock Caverns ---
		-------------------------

	AtlasLoot_Data["BlackrockCavernsRomogg"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55278, "", "=q3=Inquisition Robes", "=ds=#s5#, #a1#", ""};
				{ 3, 55279, "", "=q3=Manacles of Pain", "=ds=#s8#, #a3#", ""};
				{ 4, 55776, "", "=q3=Skullcracker Ring", "=ds=#s13#", ""};
				{ 5, 55777, "", "=q3=Torturer's Mercy", "=ds=#h3#, #w6#", ""};
				{ 6, 55778, "", "=q3=Shield of the Iron Maiden", "=ds=#w8#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56311, "", "=q3=Inquisition Robes", "=ds=#s5#, #a1#", ""};
				{ 18, 56313, "", "=q3=Manacles of Pain", "=ds=#s8#, #a3#", ""};
				{ 19, 56310, "", "=q3=Skullcracker Ring", "=ds=#s13#", ""};
				{ 20, 56312, "", "=q3=Torturer's Mercy", "=ds=#h3#, #w6#", ""};
				{ 21, 56314, "", "=q3=Shield of the Iron Maiden", "=ds=#w8#", ""};
			};
		};
		info = {
			name = BabbleBoss["Rom'ogg Bonecrusher"],
			module = moduleName, instance = "BlackrockCaverns",
		};
	};

	AtlasLoot_Data["BlackrockCavernsCorla"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55264, "", "=q3=Armbands of Change", "=ds=#s8#, #a2#", ""};
				{ 3, 55263, "", "=q3=Renouncer's Cowl", "=ds=#s1#, #a3#", ""};
				{ 4, 55265, "", "=q3=Signet of Transformation", "=ds=#s13#", ""};
				{ 5, 55266, "", "=q3=Grace of the Herald", "=ds=#s14#", ""};
				{ 6, 55267, "", "=q3=Corla's Baton", "=ds=#w12#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56297, "", "=q3=Armbands of Change", "=ds=#s8#, #a2#", ""};
				{ 18, 56298, "", "=q3=Renouncer's Cowl", "=ds=#s1#, #a3#", ""};
				{ 19, 56299, "", "=q3=Signet of Transformation", "=ds=#s13#", ""};
				{ 20, 56295, "", "=q3=Grace of the Herald", "=ds=#s14#", ""};--??
				{ 21, 56296, "", "=q3=Corla's Baton", "=ds=#w12#", ""};
			};
		};
		info = {
			name = BabbleBoss["Corla, Herald of Twilight"],
			module = moduleName, instance = "BlackrockCaverns",
		};
	};

	AtlasLoot_Data["BlackrockCavernsSteelbender"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55270, "", "=q3=Burned Gatherings", "=ds=#s4#", ""};
				{ 3, 55269, "", "=q3=Heat Wave Leggings", "=ds=#s11#, #a3#", ""};
				{ 4, 55268, "", "=q3=Bracers of Cooled Anger", "=ds=#s8#, #a4#", ""};
				{ 5, 55271, "", "=q3=Quicksilver Amulet", "=ds=#s2#", ""};
				{ 6, 55272, "", "=q3=Steelbender's Masterpiece", "=ds=#h1#, #w4#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56304, "", "=q3=Burned Gatherings", "=ds=#s4#", ""};
				{ 18, 56303, "", "=q3=Heat Wave Leggings", "=ds=#s11#, #a3#", ""};
				{ 19, 56301, "", "=q3=Bracers of Cooled Anger", "=ds=#s8#, #a4#", ""};
				{ 20, 56300, "", "=q3=Quicksilver Amulet", "=ds=#s2#", ""};
				{ 21, 56302, "", "=q3=Steelbender's Masterpiece", "=ds=#h1#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Karsh Steelbender"],
			module = moduleName, instance = "BlackrockCaverns",
		};
	};

	AtlasLoot_Data["BlackrockCavernsBeauty"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55275, "", "=q3=Beauty's Silken Ribbon", "=ds=#s10#, #a1#", ""};
				{ 3, 55273, "", "=q3=Beauty's Chew Toy", "=ds=#s11#, #a2#", ""};
				{ 4, 55274, "", "=q3=Beauty's Plate", "=ds=#s5#, #a4#", ""};
				{ 5, 55276, "", "=q3=Kibble", "=ds=#s13#", ""};
				{ 6, 55277, "", "=q3=Beauty's Favorite Bone", "=ds=#s15#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56305, "", "=q3=Beauty's Silken Ribbon", "=ds=#s10#, #a1#", ""};
				{ 18, 56309, "", "=q3=Beauty's Chew Toy", "=ds=#s11#, #a2#", ""};
				{ 19, 56308, "", "=q3=Beauty's Plate", "=ds=#s5#, #a4#", ""};
				{ 20, 56307, "", "=q3=Kibble", "=ds=#s13#", ""};
				{ 21, 56306, "", "=q3=Beauty's Favorite Bone", "=ds=#s15#", ""};
			};
		};
		info = {
			name = BabbleBoss["Beauty"],
			module = moduleName, instance = "BlackrockCaverns",
		};
	};

	AtlasLoot_Data["BlackrockCavernsLordObsidius"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55780, "", "=q3=Twitching Shadows", "=ds=#s4#", ""};
				{ 3, 55786, "", "=q3=Kyrstel Mantle", "=ds=#s3#, #a1#", ""};
				{ 4, 55785, "", "=q3=Willowy Crown", "=ds=#s1#, #a2#", ""};
				{ 5, 55779, "", "=q3=Raz's Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 6, 55784, "", "=q3=Clutches of Dying Light", "=ds=#s9#, #a4#", ""};
				{ 7, 55781, "", "=q3=Carrier Wave Pendant", "=ds=#s2#", ""};
				{ 8, 55787, "", "=q3=Witching Hourglass", "=ds=#s14#", ""};
				{ 9, 55783, "", "=q3=Sandshift Relic", "=ds=#s16#", ""};
				{ 10, 55782, "", "=q3=Amber Messenger", "=ds=#w2#", ""};
				{ 11, 55788, "", "=q3=Crepuscular Shield", "=ds=#w8#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56315, "", "=q3=Twitching Shadows", "=ds=#s4#", ""};
				{ 18, 56324, "", "=q3=Kyrstel Mantle", "=ds=#s3#, #a1#", ""};
				{ 19, 56321, "", "=q3=Willowy Crown", "=ds=#s1#, #a2#", ""};
				{ 20, 56318, "", "=q3=Raz's Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 21, 56323, "", "=q3=Clutches of Dying Light", "=ds=#s9#, #a4#", ""};
				{ 22, 56319, "", "=q3=Carrier Wave Pendant", "=ds=#s2#", ""};
				{ 23, 56320, "", "=q3=Witching Hourglass", "=ds=#s14#", ""};
				{ 24, 56316, "", "=q3=Sandshift Relic", "=ds=#s16#", ""};
				{ 25, 56317, "", "=q3=Amber Messenger", "=ds=#w2#", ""};
				{ 26, 56322, "", "=q3=Crepuscular Shield", "=ds=#w8#", ""};
			};
		};
		info = {
			name = BabbleBoss["Ascendant Lord Obsidius"],
			module = moduleName, instance = "BlackrockCaverns",
		};
	};

	AtlasLoot_Data["BlackrockCavernsTrash"] = {
		["Normal"] = {
			{
				{ 2, 55791, "", "=q3=Acanthia's Lost Pendant", "=ds=#s2#", ""};
				{ 3, 55790, "", "=q3=Toxidunk Dagger", "=ds=#h1#, #w4#", ""};
				{ 4, 55789, "", "=q3=Berto's Staff", "=ds=#w9#", ""};
--[[			{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56327, "", "=q3=Acanthia's Lost Pendant", "=ds=#s2#", ""};
				{ 18, 56326, "", "=q3=Toxidunk Dagger", "=ds=#h1#, #w4#", ""};
				{ 19, 56325, "", "=q3=Berto's Staff", "=ds=#w9#", ""};]]--
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "BlackrockCaverns",
		};
	};

		---------------------------
		--- Throne of the Tides ---
		---------------------------

	AtlasLoot_Data["ToTNazjar"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55202, "", "=q3=Periwinkle Cloak", "=ds=#s4#", ""};
				{ 3, 55198, "", "=q3=Aurelian Mitre", "=ds=#s1#, #a1#", ""};
				{ 4, 55195, "", "=q3=Wrasse Handwraps", "=ds=#s9#, #a3#", ""};
				{ 5, 55201, "", "=q3=Entwined Nereis", "=ds=#s13#", ""};
				{ 6, 55203, "", "=q3=Lightning Whelk Axe", "=ds=#h1#, #w1#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56267, "", "=q3=Periwinkle Cloak", "=ds=#s4#", ""};
				{ 18, 56269, "", "=q3=Aurelian Mitre", "=ds=#s1#, #a1#", ""};
				{ 19, 56268, "", "=q3=Wrasse Handwraps", "=ds=#s9#, #a3#", ""};
				{ 20, 56270, "", "=q3=Entwined Nereis", "=ds=#s13#", ""};
				{ 21, 56266, "", "=q3=Lightning Whelk Axe", "=ds=#h1#, #w1#", ""};
			};
		};
		info = {
			name = BabbleBoss["Lady Naz'jar"],
			module = moduleName, instance = "ThroneOfTheTides",
		};
	};

	AtlasLoot_Data["ToTUlthok"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55206, "", "=q3=Eagle Ray Cloak", "=ds=#s4#", ""};
				{ 3, 55204, "", "=q3=Caridean Epaulettes", "=ds=#s3#, #a2#", ""};
				{ 4, 55205, "", "=q3=Chromis Chestpiece", "=ds=#s5#, #a3#", ""};
				{ 5, 55207, "", "=q3=Harp Shell Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 6, 55228, "", "=q3=Cerith Spire Stuff", "=ds=#w9#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56275, "", "=q3=Eagle Ray Cloak", "=ds=#s4#", ""};
				{ 18, 56273, "", "=q3=Caridean Epaulettes", "=ds=#s3#, #a2#", ""};
				{ 19, 56274, "", "=q3=Chromis Chestpiece", "=ds=#s5#, #a3#", ""};
				{ 20, 56272, "", "=q3=Harp Shell Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 21, 56271, "", "=q3=Cerith Spire Stuff", "=ds=#w9#", ""};
			};
		};
		info = {
			name = BabbleBoss["Commander Ulthok"],
			module = moduleName, instance = "ThroneOfTheTides",
		};
	};

	AtlasLoot_Data["ToTStonespeaker"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55236, "", "=q3=Anthia's Ring", "=ds=#s13#", ""};
				{ 3, 55235, "", "=q3=Decapod Slippers", "=ds=#s12#, #a2#", ""};
				{ 4, 55229, "", "=q3=Anomuran Helm", "=ds=#s1#, #a4#", ""};
				{ 5, 55237, "", "=q3=Porcelain Crab", "=ds=#s14#", ""};
				{ 6, 55248, "", "=q3=Conch of Thundering Waves", "=ds=#s16#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56276, "", "=q3=Anthia's Ring", "=ds=#s13#", ""};
				{ 18, 56277, "", "=q3=Decapod Slippers", "=ds=#s12#, #a2#", ""};
				{ 19, 56278, "", "=q3=Anomuran Helm", "=ds=#s1#, #a4#", ""};
				{ 20, 56280, "", "=q3=Porcelain Crab", "=ds=#s14#", ""};
				{ 21, 56279, "", "=q3=Conch of Thundering Waves", "=ds=#s16#", ""};
			};
		};
		info = {
			name = BabbleBoss["Erunak Stonespeaker"].." & "..BabbleBoss["Mindbender Ghur'sha"],
			module = moduleName, instance = "ThroneOfTheTides",
		};
	};

	AtlasLoot_Data["ToTOzumat"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55255, "", "=q3=Mnemiopsis Gloves", "=ds=#s9#, #a1#", ""};
				{ 3, 55253, "", "=q3=Wentletrap Vest", "=ds=#s5#, #a3#", ""};
				{ 4, 55254, "", "=q3=Abalone Plate Armor", "=ds=#s5#, #a4#", ""};
				{ 5, 55249, "", "=q3=Triton Legplates", "=ds=#s11#, #a4#", ""};
				{ 6, 55258, "", "=q3=Pipefish Cord", "=ds=#s2#", ""};
				{ 7, 55250, "", "=q3=Nautilus Ring", "=ds=#s13#", ""};
				{ 8, 55251, "", "=q3=Might of the Ocean", "=ds=#s14#", ""};
				{ 9, 55256, "", "=q3=Sea Star", "=ds=#s14#", ""};
				{ 10, 55259, "", "=q3=Bioluminescent Lamp", "=ds=#s15#", ""};
				{ 11, 55252, "", "=q3=Whitefin Axe", "=ds=#h2#, #w1#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56286, "", "=q3=Mnemiopsis Gloves", "=ds=#s9#, #a1#", ""};
				{ 18, 56281, "", "=q3=Wentletrap Vest", "=ds=#s5#, #a3#", ""};
				{ 19, 56291, "", "=q3=Abalone Plate Armor", "=ds=#s5#, #a4#", ""};
				{ 20, 56283, "", "=q3=Triton Legplates", "=ds=#s11#, #a4#", ""};
				{ 21, 56288, "", "=q3=Pipefish Cord", "=ds=#s2#", ""};
				{ 22, 56282, "", "=q3=Nautilus Ring", "=ds=#s13#", ""};
				{ 23, 56285, "", "=q3=Might of the Ocean", "=ds=#s14#", ""};
				{ 24, 56290, "", "=q3=Sea Star", "=ds=#s14#", ""};
				{ 25, 56289, "", "=q3=Bioluminescent Lamp", "=ds=#s15#", ""};
				{ 26, 56284, "", "=q3=Whitefin Axe", "=ds=#h2#, #w1#", ""};
			};
		};
		info = {
			name = BabbleBoss["Ozumat"],
			module = moduleName, instance = "ThroneOfTheTides",
		};
	};

	AtlasLoot_Data["ToTTrash"] = {
		["Normal"] = {
			{
				{ 2, 55260, "", "=q3=Alpheus Legguards", "=ds=#s11#, #a4#", ""};
				{ 3, 55262, "", "=q3=Barnacle Pendant", "=ds=#s2#", ""};
				{ 4, 55261, "", "=q3=Ring of the Great Whale", "=ds=#s13#", ""};
--[[				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56294, "", "=q3=Alpheus Legguards", "=ds=#s11#, #a4#", ""};
				{ 18, 56292, "", "=q3=Barnacle Pendant", "=ds=#s2#", ""};
				{ 19, 56293, "", "=q3=Ring of the Great Whale", "=ds=#s13#", ""};--]]
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "ThroneOfTheTides",
		};
	};

		---------------------
		--- The Stonecore ---
		---------------------

	AtlasLoot_Data["StonecoreCorborus"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55793, "", "=q3=Dolomite Adorned Gloves", "=ds=#s9#, #a1#", ""};
				{ 3, 55792, "", "=q3=Cinnabar Shoulders", "=ds=#s3#, #a4#", ""};
				{ 4, 55794, "", "=q3=Phosphorescent Ring", "=ds=#s13#", ""};
				{ 5, 55795, "", "=q3=Key to the Endless Chamber", "=ds=#s14#", ""};
				{ 6, 55796, "", "=q3=Fist of Pained Senses", "=ds=#h3#, #w13#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56331, "", "=q3=Dolomite Adorned Gloves", "=ds=#s9#, #a1#", ""};
				{ 18, 56330, "", "=q3=Cinnabar Shoulders", "=ds=#s3#, #a4#", ""};
				{ 19, 56332, "", "=q3=Phosphorescent Ring", "=ds=#s13#", ""};
				{ 20, 56328, "", "=q3=Key to the Endless Chamber", "=ds=#s14#", ""};
				{ 21, 56329, "", "=q3=Fist of Pained Senses", "=ds=#h3#, #w13#", ""};
			};
		};
		info = {
			name = BabbleBoss["Corborus"],
			module = moduleName, instance = "TheStonecore",
		};
	};

	AtlasLoot_Data["StonecoreSlabhide"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 63043, "", "=q4=Reins of the Vitreous Stone Drake", "=ds=#e27#", "", "1%"};
				{ 3, 55798, "", "=q3=Deep Delving Gloves", "=ds=#s9#, #a2#", ""};
				{ 4, 55797, "", "=q3=Hematite Plate Gloves", "=ds=#s9#, #a4#", ""};
				{ 5, 55799, "", "=q3=Rose Quartz Band", "=ds=#s13#", ""};
				{ 6, 55800, "", "=q3=Stalagmite Dragon", "=ds=#s16#", ""};
				{ 7, 55801, "", "=q3=Quicksilver Blade", "=ds=#h1#, #w4#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63043, "", "=q4=Reins of the Vitreous Stone Drake", "=ds=#e27#", "", "1%"};
				{ 18, 56334, "", "=q3=Deep Delving Gloves", "=ds=#s9#, #a2#", ""};
				{ 19, 56336, "", "=q3=Hematite Plate Gloves", "=ds=#s9#, #a4#", ""};
				{ 20, 56333, "", "=q3=Rose Quartz Band", "=ds=#s13#", ""};
				{ 21, 56337, "", "=q3=Stalagmite Dragon", "=ds=#s16#", ""};
				{ 22, 56335, "", "=q3=Quicksilver Blade", "=ds=#h1#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Slabhide"],
			module = moduleName, instance = "TheStonecore",
		};
	};

	AtlasLoot_Data["StonecoreOzruk"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55802, "", "=q3=Elementium Scale Bracers", "=ds=#s8#, #a3#", ""};
				{ 3, 55803, "", "=q3=Belt of the Ringworm", "=ds=#s10#, #a4#", ""};
				{ 4, 55804, "", "=q3=Pendant of the Lightless Grotto", "=ds=#s2#", ""};
				{ 5, 55810, "", "=q3=Tendrils of Burrowing Dark", "=ds=#s14#", ""};
				{ 6, 55811, "", "=q3=Sword of the Bottomless Pit", "=ds=#h2#, #w10#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56340, "", "=q3=Elementium Scale Bracers", "=ds=#s8#, #a3#", ""};
				{ 18, 56341, "", "=q3=Belt of the Ringworm", "=ds=#s10#, #a4#", ""};
				{ 19, 56338, "", "=q3=Pendant of the Lightless Grotto", "=ds=#s2#", ""};
				{ 20, 56339, "", "=q3=Tendrils of Burrowing Dark", "=ds=#s14#", ""};
				{ 21, 56342, "", "=q3=Sword of the Bottomless Pit", "=ds=#h2#, #w10#", ""};
			};
		};
		info = {
			name = BabbleBoss["Ozruk"],
			module = moduleName, instance = "TheStonecore",
		};
	};

	AtlasLoot_Data["StonecoreAzil"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55817, "", "=q3=Slippers of the Twilight Prophet", "=ds=#s12#, #a1#", ""};
				{ 3, 55812, "", "=q3=Helm of Numberless Shadows", "=ds=#s1#, #a2#", ""};
				{ 4, 55818, "", "=q3=Cowl of the Unseen World", "=ds=#s1#, #a3#", ""};
				{ 5, 55816, "", "=q3=Leaden Despair", "=ds=#s14#", ""};
				{ 6, 55814, "", "=q3=Magnetite Mirror", "=ds=#s14#", ""};
				{ 7, 55819, "", "=q3=Tear of Blood", "=ds=#s14#", ""};
				{ 8, 55820, "", "=q3=Prophet's Scepter", "=ds=#s15#", ""};
				{ 9, 55821, "", "=q3=Book of Dark Prophecies", "=ds=#s16#", ""};
				{ 10, 55813, "", "=q3=Elementium Fang", "=ds=#h1#, #w10#", ""};
				{ 11, 55815, "", "=q3=Darkling Staff", "=ds=#w9#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56348, "", "=q3=Slippers of the Twilight Prophet", "=ds=#s12#, #a1#", ""};
				{ 18, 56344, "", "=q3=Helm of Numberless Shadows", "=ds=#s1#, #a2#", ""};
				{ 19, 56352, "", "=q3=Cowl of the Unseen World", "=ds=#s1#, #a3#", ""};
				{ 20, 56347, "", "=q3=Leaden Despair", "=ds=#s14#", ""};
				{ 21, 56345, "", "=q3=Magnetite Mirror", "=ds=#s14#", ""};
				{ 22, 56351, "", "=q3=Tear of Blood", "=ds=#s14#", ""};
				{ 23, 56349, "", "=q3=Prophet's Scepter", "=ds=#s15#", ""};
				{ 24, 56350, "", "=q3=Book of Dark Prophecies", "=ds=#s16#", ""};
				{ 25, 56346, "", "=q3=Elementium Fang", "=ds=#h1#, #w10#", ""};
				{ 26, 56343, "", "=q3=Darkling Staff", "=ds=#w9#", ""};
			};
		};
		info = {
			name = BabbleBoss["High Priestess Azil"],
			module = moduleName, instance = "TheStonecore",
		};
	};

	AtlasLoot_Data["StonecoreTrash"] = {
		["Normal"] = {
			{
				{ 2, 55824, "", "=q3=Skin of Stone", "=ds=#s4#", ""};
				{ 3, 55822, "", "=q3=Heavy Geode Mace", "=ds=#h1#, #w6#", ""};
				{ 4, 55823, "", "=q3=Wand of Dark Worship", "=ds=#w12#", ""};
--[[				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56355, "", "=q3=Skin of Stone", "=ds=#s4#", ""};
				{ 18, 56353, "", "=q3=Heavy Geode Mace", "=ds=#h1#, #w6#", ""};
				{ 19, 56354, "", "=q3=Wand of Dark Worship", "=ds=#w12#", ""};--]]
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "TheStonecore",
		};
	};

		-------------------------
		--- Vortex Pinnacle -----
		-------------------------

	AtlasLoot_Data["VPErtan"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55830, "", "=q3=Stratosphere Belt", "=ds=#s10#, #a1#", ""};
				{ 3, 55832, "", "=q3=Fallen Snow Shoulderguards", "=ds=#s3#, #a3#", ""};
				{ 4, 55831, "", "=q3=Headcover of Fog", "=ds=#s1#, #a4#", ""};
				{ 5, 55833, "", "=q3=Red Sky Pendant", "=ds=#s2#", ""};
				{ 6, 55834, "", "=q3=Biting Wind", "=ds=#h3#, #w4#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56356, "", "=q3=Stratosphere Belt", "=ds=#s10#, #a1#", ""};
				{ 18, 56359, "", "=q3=Fallen Snow Shoulderguards", "=ds=#s3#, #a3#", ""};
				{ 19, 56358, "", "=q3=Headcover of Fog", "=ds=#s1#, #a4#", ""};
				{ 20, 56360, "", "=q3=Red Sky Pendant", "=ds=#s2#", ""};
				{ 21, 56357, "", "=q3=Biting Wind", "=ds=#h3#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Grand Vizier Ertan"],
			module = moduleName, instance = "TheVortexPinnacle",
		};
	};

	AtlasLoot_Data["VPAltairus"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 63040, "", "=q4=Reins of the Drake of the North Wind", "=ds=#e27#", "", "1%"};
				{ 3, 55838, "", "=q3=Mantle of Bestilled Winds", "=ds=#s3#, #a2#", ""};
				{ 4, 55835, "", "=q3=Hail-Strung Belt", "=ds=#s10#, #a3#", ""};
				{ 5, 55840, "", "=q3=Amulet of Tender Breath", "=ds=#s2#", ""};
				{ 6, 55839, "", "=q3=Skyshard Ring", "=ds=#s13#", ""};
				{ 7, 55841, "", "=q3=Axe of the Eclipse", "=ds=#h1#, #w1#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63040, "", "=q4=Reins of the Drake of the North Wind", "=ds=#e27#", "", "1%"};
				{ 18, 56361, "", "=q3=Mantle of Bestilled Winds", "=ds=#s3#, #a2#", ""};
				{ 19, 56363, "", "=q3=Hail-Strung Belt", "=ds=#s10#, #a3#", ""};
				{ 20, 56362, "", "=q3=Amulet of Tender Breath", "=ds=#s2#", ""};
				{ 21, 56365, "", "=q3=Skyshard Ring", "=ds=#s13#", ""};
				{ 22, 56364, "", "=q3=Axe of the Eclipse", "=ds=#h1#, #w1#", ""};
			};
		};
		info = {
			name = BabbleBoss["Altairus"],
			module = moduleName, instance = "TheVortexPinnacle",
		};
	};

	AtlasLoot_Data["VPAsaad"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55847, "", "=q3=Billowing Cape", "=ds=#s4#", ""};
				{ 3, 55850, "", "=q3=Shadow of Perfect Bliss", "=ds=#s4#", ""};
				{ 4, 55849, "", "=q3=Leggings of Iridescent Clouds", "=ds=#s11#, #a1#", ""};
				{ 5, 55844, "", "=q3=Gloves of Haze", "=ds=#s9#, #a2#", ""};
				{ 6, 55848, "", "=q3=Lunar Halo", "=ds=#s1#, #a4#", ""};
				{ 7, 55842, "", "=q3=Legguards of Winnowing Wind", "=ds=#s11#, #a4#", ""};
				{ 8, 55851, "", "=q3=Ring of Frozen Rain", "=ds=#s13#", ""};
				{ 9, 55845, "", "=q3=Heart of Thunder", "=ds=#s14#", ""};
				{ 10, 55852, "", "=q3=Captured Lightning", "=ds=#s16#", ""};
				{ 11, 55846, "", "=q3=Lightningflash", "=ds=#w5#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56369, "", "=q3=Billowing Cape", "=ds=#s4#", ""};
				{ 18, 56371, "", "=q3=Shadow of Perfect Bliss", "=ds=#s4#", ""};
				{ 19, 56375, "", "=q3=Leggings of Iridescent Clouds", "=ds=#s11#, #a1#", ""};
				{ 20, 56368, "", "=q3=Gloves of Haze", "=ds=#s9#, #a2#", ""};
				{ 21, 56374, "", "=q3=Lunar Halo", "=ds=#s1#, #a4#", ""};
				{ 22, 56367, "", "=q3=Legguards of Winnowing Wind", "=ds=#s11#, #a4#", ""};
				{ 23, 56373, "", "=q3=Ring of Frozen Rain", "=ds=#s13#", ""};
				{ 24, 56370, "", "=q3=Heart of Thunder", "=ds=#s14#", ""};
				{ 25, 56372, "", "=q3=Captured Lightning", "=ds=#s16#", ""};
				{ 26, 56366, "", "=q3=Lightningflash", "=ds=#w5#", ""};
			};
		};
		info = {
			name = BabbleBoss["Asaad"],
			module = moduleName, instance = "TheVortexPinnacle",
		};
	};

	AtlasLoot_Data["VPTrash"] = {
		["Normal"] = {
			{
				{ 2, 55855, "", "=q3=Darksky Treads", "=ds=#s12#, #a4#", ""};
				{ 3, 55854, "", "=q3=Rainsong", "=ds=#s14#", ""};
				{ 4, 55853, "", "=q3=Thundercall", "=ds=#w5#", ""};
--[[				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56378, "", "=q3=Darksky Treads", "=ds=#s12#, #a4#", ""};
				{ 18, 56377, "", "=q3=Rainsong", "=ds=#s14#", ""};
				{ 19, 56376, "", "=q3=Thundercall", "=ds=#w5#", ""};--]]
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "TheVortexPinnacle",
		};
	};

		----------------------------
		--- Lost City of Tol'vir ---
		----------------------------

	AtlasLoot_Data["LostCityHusam"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55858, "", "=q3=Kaleki Cloak", "=ds=#s4#"};
				{ 3, 55857, "", "=q3=Ionic Gloves", "=ds=#s9#, #a3#"};
				{ 4, 55856, "", "=q3=Greaves of Wu the Elder", "=ds=#s12#, #a4#"};
				{ 5, 55859, "", "=q3=Spirit Creeper Ring", "=ds=#s13#"};
				{ 6, 55860, "", "=q3=Seliza's Spear", "=ds=#w7#"};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56379, "", "=q3=Kaleki Cloak", "=ds=#s4#"};
				{ 18, 56383, "", "=q3=Ionic Gloves", "=ds=#s9#, #a3#"};
				{ 19, 56381, "", "=q3=Greaves of Wu the Elder", "=ds=#s12#, #a4#"};
				{ 20, 56380, "", "=q3=Spirit Creeper Ring", "=ds=#s13#"};
				{ 21, 56382, "", "=q3=Seliza's Spear", "=ds=#w7#"};
			};
		};
		info = {
			name = BabbleBoss["General Husam"],
			module = moduleName, instance = "LostCityOfTolvir",
		};
	};

	AtlasLoot_Data["LostCityLockmaw"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55866, "", "=q3=Sand Silk Wristband", "=ds=#s8#, #a1#"};
				{ 3, 55867, "", "=q3=Sand Dune Belt", "=ds=#s10#, #a4#"};
				{ 4, 55869, "", "=q3=Veneficial Band", "=ds=#s13#"};
				{ 5, 55868, "", "=q3=Heart of Solace", "=ds=#s14#"};
				{ 6, 55870, "", "=q3=Barim's Main Gauche", "=ds=#h1#, #w4#"};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56389, "", "=q3=Sand Silk Wristband", "=ds=#s8#, #a1#"};
				{ 18, 56392, "", "=q3=Sand Dune Belt", "=ds=#s10#, #a4#"};
				{ 19, 56391, "", "=q3=Veneficial Band", "=ds=#s13#"};
				{ 20, 56393, "", "=q3=Heart of Solace", "=ds=#s14#"};
				{ 21, 56390, "", "=q3=Barim's Main Gauche", "=ds=#h1#, #w4#"};
			};
		};
		info = {
			name = BabbleBoss["Lockmaw"],
			module = moduleName, instance = "LostCityOfTolvir",
		};
	};

	AtlasLoot_Data["LostCityBarim"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55861, "", "=q3=Balkar's Waders", "=ds=#s11#, #a3#"};
				{ 3, 55862, "", "=q3=Greaves of Wu the Younger", "=ds=#s12#, #a4#"};
				{ 4, 55864, "", "=q3=Tauntka's Necklace", "=ds=#s2#"};
				{ 5, 55863, "", "=q3=Ring of the Darkest Day", "=ds=#s13#"};
				{ 6, 55865, "", "=q3=Resonant Kris", "=ds=#h1#, #w10#"};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56386, "", "=q3=Balkar's Waders", "=ds=#s11#, #a3#"};
				{ 18, 56387, "", "=q3=Greaves of Wu the Younger", "=ds=#s12#, #a4#"};
				{ 19, 56385, "", "=q3=Tauntka's Necklace", "=ds=#s2#"};
				{ 20, 56388, "", "=q3=Ring of the Darkest Day", "=ds=#s13#"};
				{ 21, 56384, "", "=q3=Resonant Kris", "=ds=#h1#, #w10#"};
			};
		};
		info = {
			name = BabbleBoss["High Prophet Barim"],
			module = moduleName, instance = "LostCityOfTolvir",
		};
	};

	AtlasLoot_Data["LostCitySiamat"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55872, "", "=q3=Geordan's Cloak", "=ds=#s4#"};
				{ 3, 55876, "", "=q3=Mantle of Master Cho", "=ds=#s3#, #a1#"};
				{ 4, 55878, "", "=q3=Evelyn's Belt", "=ds=#s10#, #a1#"};
				{ 5, 55877, "", "=q3=Leggings of the Path", "=ds=#s11#, #a2#"};
				{ 6, 55871, "", "=q3=Crafty's Gaiters", "=ds=#s12#, #a2#"};
				{ 7, 55873, "", "=q3=Ring of Three Lights", "=ds=#s13#"};
				{ 8, 55874, "", "=q3=Tia's Grace", "=ds=#s14#"};
				{ 9, 55879, "", "=q3=Sorrowsong", "=ds=#s14#"};
				{ 10, 55875, "", "=q3=Hammer of Sparks", "=ds=#h1#, #w6#"};
				{ 11, 55880, "", "=q3=Zora's Ward", "=ds=#w8#"};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56397, "", "=q3=Geordan's Cloak", "=ds=#s4#"};
				{ 18, 56399, "", "=q3=Mantle of Master Cho", "=ds=#s3#, #a1#"};
				{ 19, 56403, "", "=q3=Evelyn's Belt", "=ds=#s10#, #a1#"};
				{ 20, 56401, "", "=q3=Leggings of the Path", "=ds=#s11#, #a2#"};
				{ 21, 56395, "", "=q3=Crafty's Gaiters", "=ds=#s12#, #a2#"};
				{ 22, 56398, "", "=q3=Ring of Three Lights", "=ds=#s13#"};
				{ 23, 56394, "", "=q3=Tia's Grace", "=ds=#s14#"};
				{ 24, 56400, "", "=q3=Sorrowsong", "=ds=#s14#"};
				{ 25, 56396, "", "=q3=Hammer of Sparks", "=ds=#h1#, #w6#"};
				{ 26, 56402, "", "=q3=Zora's Ward", "=ds=#w8#"};
			};
		};
		info = {
			name = BabbleBoss["Siamat, Lord of South Wind"],
			module = moduleName, instance = "LostCityOfTolvir",
		};
	};

	AtlasLoot_Data["LostCityTrash"] = {
		["Normal"] = {
			{
				{ 2, 55882, "", "=q3=Oasis Bracers", "=ds=#s8#, #a2#"};
				{ 3, 55884, "", "=q3=Mirage Ring", "=ds=#s13#"};
				{ 4, 55881, "", "=q3=Impetuous Query", "=ds=#s14#"};
--[[				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56405, "", "=q3=Oasis Bracers", "=ds=#s8#, #a2#"};
				{ 18, 56404, "", "=q3=Mirage Ring", "=ds=#s13#"};
				{ 19, 56406, "", "=q3=Impetuous Query", "=ds=#s14#"};--]]
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "LostCityOfTolvir",
		};
	};

		------------------
		--- Grim Batol ---
		------------------

	AtlasLoot_Data["GBUmbriss"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 56113, "", "=q3=Cursed Skardyn Vest", "=ds=#s5#, #a2#", ""};
				{ 3, 56112, "", "=q3=Wildhammer Riding Helm", "=ds=#s1#, #a3#", ""};
				{ 4, 56114, "", "=q3=Umbriss Band", "=ds=#s13#", ""};
				{ 5, 56115, "", "=q3=Skardyn's Grace", "=ds=#s14#", ""};
				{ 6, 56116, "", "=q3=Modgud's Blade", "=ds=#h3#, #w4#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56442, "", "=q3=Cursed Skardyn Vest", "=ds=#s5#, #a2#", ""};
				{ 18, 56443, "", "=q3=Wildhammer Riding Helm", "=ds=#s1#, #a3#", ""};
				{ 19, 56444, "", "=q3=Umbriss Band", "=ds=#s13#", ""};
				{ 20, 56440, "", "=q3=Skardyn's Grace", "=ds=#s14#", ""};
				{ 21, 56441, "", "=q3=Modgud's Blade", "=ds=#h3#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["General Umbriss"],
			module = moduleName, instance = "GrimBatol",
		};
	};

	AtlasLoot_Data["GBThrongus"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 56119, "", "=q3=Dark Iron Chain Boots", "=ds=#s12#, #a3#", ""};
				{ 3, 56118, "", "=q3=Belt of the Forgemaster", "=ds=#s10#, #a4#", ""};
				{ 4, 56120, "", "=q3=Ring of Dun Algaz", "=ds=#s13#", ""};
				{ 5, 56121, "", "=q3=Throngus's Finger", "=ds=#s14#", ""};
				{ 6, 56122, "", "=q3=Wand of Untainted Power", "=ds=#w12#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56448, "", "=q3=Dark Iron Chain Boots", "=ds=#s12#, #a3#", ""};
				{ 18, 56447, "", "=q3=Belt of the Forgemaster", "=ds=#s10#, #a4#", ""};
				{ 19, 56445, "", "=q3=Ring of Dun Algaz", "=ds=#s13#", ""};
				{ 20, 56449, "", "=q3=Throngus's Finger", "=ds=#s14#", ""};
				{ 21, 56446, "", "=q3=Wand of Untainted Power", "=ds=#w12#", ""};
			};
		};
		info = {
			name = BabbleBoss["Forgemaster Throngus"],
			module = moduleName, instance = "GrimBatol",
		};
	};

	AtlasLoot_Data["GBDrahga"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 56126, "", "=q3=Azureborne Cloak", "=ds=#s4#", ""};
				{ 3, 56125, "", "=q3=Crimsonborne Bracers", "=ds=#s8#, #a1#", ""};
				{ 4, 56123, "", "=q3=Red Scale Boots", "=ds=#s12#, #a3#", ""};
				{ 5, 56124, "", "=q3=Earthshape Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 6, 56127, "", "=q3=Windwalker Blade", "=ds=#h1#, #w4#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56450, "", "=q3=Azureborne Cloak", "=ds=#s4#", ""};
				{ 18, 56453, "", "=q3=Crimsonborne Bracers", "=ds=#s8#, #a1#", ""};
				{ 19, 56451, "", "=q3=Red Scale Boots", "=ds=#s12#, #a3#", ""};
				{ 20, 56452, "", "=q3=Earthshape Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 21, 56454, "", "=q3=Windwalker Blade", "=ds=#h1#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Drahga Shodowburner"].." & "..BabbleBoss["Valiona"],
			module = moduleName, instance = "GrimBatol",
		};
	};

	AtlasLoot_Data["GBErudax"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 56133, "", "=q3=Crown of Enfeebled Bodies", "=ds=#s1#, #a1#", ""};
				{ 3, 56128, "", "=q3=Vest of Misshapen Hides", "=ds=#s5#, #a2#", ""};
				{ 4, 56135, "", "=q3=Bracers of Umbral Mending", "=ds=#s8#, #a4#", ""};
				{ 5, 56129, "", "=q3=Circle of Bone", "=ds=#s13#", ""};
				{ 6, 56136, "", "=q3=Corrupted Egg Shell", "=ds=#s14#", ""};
				{ 7, 56138, "", "=q3=Gale of Shadows", "=ds=#s14#", ""};
				{ 8, 56132, "", "=q3=Mark of Khardros", "=ds=#s14#", ""};
				{ 9, 56130, "", "=q3=Mace of Transformed Bone", "=ds=#h1#, #w6#", ""};
				{ 10, 56131, "", "=q3=Wild Hammer", "=ds=#h2#, #w6#", ""};
				{ 11, 56137, "", "=q3=Staff of Siphoned Essences", "=ds=#w9#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56460, "", "=q3=Crown of Enfeebled Bodies", "=ds=#s1#, #a1#", ""};
				{ 18, 56455, "", "=q3=Vest of Misshapen Hides", "=ds=#s5#, #a2#", ""};
				{ 19, 56464, "", "=q3=Bracers of Umbral Mending", "=ds=#s8#, #a4#", ""};
				{ 20, 56457, "", "=q3=Circle of Bone", "=ds=#s13#", ""};
				{ 21, 56463, "", "=q3=Corrupted Egg Shell", "=ds=#s14#", ""};
				{ 22, 56462, "", "=q3=Gale of Shadows", "=ds=#s14#", ""};
				{ 23, 56458, "", "=q3=Mark of Khardros", "=ds=#s14#", ""};
				{ 24, 56459, "", "=q3=Mace of Transformed Bone", "=ds=#h1#, #w6#", ""};
				{ 25, 56456, "", "=q3=Wild Hammer", "=ds=#h2#, #w6#", ""};
				{ 26, 56461, "", "=q3=Staff of Siphoned Essences", "=ds=#w9#", ""};
			};
		};
		info = {
			name = BabbleBoss["Erudax"],
			module = moduleName, instance = "GrimBatol",
		};
	};

	AtlasLoot_Data["GBTrash"] = {
		["Normal"] = {
			{
				{ 2, 56219, "", "=q3=Shroud of Dark Memories", "=ds=#s4#", ""};
				{ 3, 56218, "", "=q3=Curse-Tainted Leggings", "=ds=#s11#, #a1#", ""};
				{ 4, 56220, "", "=q3=Abandoned Dark Iron Ring", "=ds=#s13#", ""};
--[[				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56467, "", "=q3=Shroud of Dark Memories", "=ds=#s4#", ""};
				{ 18, 56466, "", "=q3=Curse-Tainted Leggings", "=ds=#s11#, #a1#", ""};
				{ 19, 56465, "", "=q3=Abandoned Dark Iron Ring", "=ds=#s13#", ""};--]]
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "GrimBatol",
		};
	};

		------------------------------
		--- Halls of Origination -----
		------------------------------

	AtlasLoot_Data["HoOAnhuur"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55886, "", "=q3=Poison Fang Bracers", "=ds=#s8#, #a2#", ""};
				{ 3, 55890, "", "=q3=Awakening Footfalls", "=ds=#s12#, #a2#", ""};
				{ 4, 55887, "", "=q3=Belt of Petrified Tears", "=ds=#s10#, #a3#", ""};
				{ 5, 55888, "", "=q3=Darkhowl Amulet", "=ds=#s2#", ""};
				{ 6, 55889, "", "=q3=Anhuur's Hymnal", "=ds=#s14#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56409, "", "=q3=Poison Fang Bracers", "=ds=#s8#, #a2#", ""};
				{ 18, 56408, "", "=q3=Awakening Footfalls", "=ds=#s12#, #a2#", ""};
				{ 19, 56410, "", "=q3=Belt of Petrified Tears", "=ds=#s10#, #a3#", ""};
				{ 20, 56411, "", "=q3=Darkhowl Amulet", "=ds=#s2#", ""};
				{ 21, 56407, "", "=q3=Anhuur's Hymnal", "=ds=#s14#", ""};
			};
		};
		info = {
			name = BabbleBoss["Temple Guardian Anhuur"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};

	AtlasLoot_Data["HoOPtah"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 56094, "", "=q3=Underworld Cord", "=ds=#s10#, #a2#", ""};
				{ 3, 56093, "", "=q3=Breastplate of the Risen Land", "=ds=#s5#, #a4#", ""};
				{ 4, 56095, "", "=q3=Mouth of the Earth", "=ds=#s2#", ""};
				{ 5, 56097, "", "=q3=Soul Releaser", "=ds=#w9#", ""};
				{ 6, 56096, "", "=q3=Bulwark of the Primordial Mound", "=ds=#w8#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56423, "", "=q3=Underworld Cord", "=ds=#s10#, #a2#", ""};
				{ 18, 56425, "", "=q3=Breastplate of the Risen Land", "=ds=#s5#, #a4#", ""};
				{ 19, 56422, "", "=q3=Mouth of the Earth", "=ds=#s2#", ""};
				{ 20, 56424, "", "=q3=Soul Releaser", "=ds=#w9#", ""};
				{ 21, 56426, "", "=q3=Bulwark of the Primordial Mound", "=ds=#w8#", ""};
			};
		};
		info = {
			name = BabbleBoss["Earthrager Ptah"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};

	AtlasLoot_Data["HoOAnraphet"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 57860, "", "=q3=Anraphet's Regalia", "=ds=#s5#, #a1#", ""};
				{ 3, 57858, "", "=q3=Mantle of Soft Shadows", "=ds=#s3#, #a2#", ""};
				{ 4, 57857, "", "=q3=Boots of Crumbling Ruin", "=ds=#s12#, #a3#", ""};
				{ 5, 57856, "", "=q3=Omega Breastplate", "=ds=#s5#, #a4#", ""};
				{ 6, 57855, "", "=q3=Alpha Bracers", "=ds=#s8#, #a4#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 57868, "", "=q3=Anraphet's Regalia", "=ds=#s5#, #a1#", ""};
				{ 18, 57866, "", "=q3=Mantle of Soft Shadows", "=ds=#s3#, #a2#", ""};
				{ 19, 57867, "", "=q3=Boots of Crumbling Ruin", "=ds=#s12#, #a3#", ""};
				{ 20, 57869, "", "=q3=Omega Breastplate", "=ds=#s5#, #a4#", ""};
				{ 21, 57870, "", "=q3=Alpha Bracers", "=ds=#s8#, #a4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Anraphet"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};

	AtlasLoot_Data["HoOIsiset"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55993, "", "=q3=Legwraps of Astral Rain", "=ds=#s11#, #a1#", ""};
				{ 3, 55992, "", "=q3=Armguards of Unearthly Light", "=ds=#s8#, #a4#", ""};
				{ 4, 55996, "", "=q3=Nova Band", "=ds=#s13#", ""};
				{ 5, 55994, "", "=q3=Ring of Blinding Stars", "=ds=#s13#", ""};
				{ 6, 55995, "", "=q3=Blood of Isiset", "=ds=#s14#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56413, "", "=q3=Legwraps of Astral Rain", "=ds=#s11#, #a1#", ""};
				{ 18, 56416, "", "=q3=Armguards of Unearthly Light", "=ds=#s8#, #a4#", ""};
				{ 19, 56415, "", "=q3=Nova Band", "=ds=#s13#", ""};
				{ 20, 56412, "", "=q3=Ring of Blinding Stars", "=ds=#s13#", ""};
				{ 21, 56414, "", "=q3=Blood of Isiset", "=ds=#s14#", ""};
			};
		};
		info = {
			name = BabbleBoss["Isiset"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};

	AtlasLoot_Data["HoOAmmunae"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 55998, "", "=q3=Robes of Rampant Growth", "=ds=#s5#, #a1#", ""};
				{ 3, 55997, "", "=q3=Bloodpetal Mantle", "=ds=#s3#, #a3#", ""};
				{ 4, 55999, "", "=q3=Seedling Pod", "=ds=#s2#", ""};
				{ 5, 56000, "", "=q3=Band of Life Energy", "=ds=#s13#", ""};
				{ 6, 56001, "", "=q3=Slashing Thorns", "=ds=#w11#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56417, "", "=q3=Robes of Rampant Growth", "=ds=#s5#, #a1#", ""};
				{ 18, 56419, "", "=q3=Bloodpetal Mantle", "=ds=#s3#, #a3#", ""};
				{ 19, 56421, "", "=q3=Seedling Pod", "=ds=#s2#", ""};
				{ 20, 56418, "", "=q3=Band of Life Energy", "=ds=#s13#", ""};
				{ 21, 56420, "", "=q3=Slashing Thorns", "=ds=#w11#", ""};
			};
		};
		info = {
			name = BabbleBoss["Ammunae"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};

	AtlasLoot_Data["HoOSetesh"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 57864, "", "=q3=Helm of the Typhonic Beast", "=ds=#s1#, #a1#", ""};
				{ 3, 57863, "", "=q3=Hieroglyphic Vest", "=ds=#s5#, #a2#", ""};
				{ 4, 57862, "", "=q3=Chaotic Wrappings", "=ds=#s11#, #a3#", ""};
				{ 5, 57861, "", "=q3=Helm of Setesh", "=ds=#s1#, #a4#", ""};
				{ 6, 57865, "", "=q3=Scepter of Power", "=ds=#h3#, #w6#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 57871, "", "=q3=Helm of the Typhonic Beast", "=ds=#s1#, #a1#", ""};
				{ 18, 57874, "", "=q3=Hieroglyphic Vest", "=ds=#s5#, #a2#", ""};
				{ 19, 57875, "", "=q3=Chaotic Wrappings", "=ds=#s11#, #a3#", ""};
				{ 20, 57873, "", "=q3=Helm of Setesh", "=ds=#s1#, #a4#", ""};
				{ 21, 57872, "", "=q3=Scepter of Power", "=ds=#h3#, #w6#", ""};
			};
		};
		info = {
			name = BabbleBoss["Setesh"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};

	AtlasLoot_Data["HoORajh"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 56107, "", "=q3=Solar Wind Cloak", "=ds=#s4#", ""};
				{ 3, 56105, "", "=q3=Hekatic Slippers", "=ds=#s12#, #a1#", ""};
				{ 4, 56098, "", "=q3=Red Beam Cord", "=ds=#s10#, #a2#", ""};
				{ 5, 56099, "", "=q3=Fingers of Light", "=ds=#s9#, #a4#", ""};
				{ 6, 56104, "", "=q3=Legguards of Noon", "=ds=#s11#, #a4#", ""};
				{ 7, 56106, "", "=q3=Band of Rays", "=ds=#s13#", ""};
				{ 8, 56102, "", "=q3=Left Eye of Rajh", "=ds=#s14#", ""};
				{ 9, 56100, "", "=q3=Right Eye of Rajh", "=ds=#s14#", ""};
				{ 10, 56108, "", "=q3=Blade of the Burning Sun", "=ds=#h3#, #w10#", ""};
				{ 11, 56101, "", "=q3=Sun Strike", "=ds=#h1#, #w10#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56434, "", "=q3=Solar Wind Cloak", "=ds=#s4#", ""};
				{ 18, 56436, "", "=q3=Hekatic Slippers", "=ds=#s12#, #a1#", ""};
				{ 19, 56429, "", "=q3=Red Beam Cord", "=ds=#s10# #a2#", ""};
				{ 20, 56428, "", "=q3=Fingers of Light", "=ds=#s9#, #a4#", ""};
				{ 21, 56435, "", "=q3=Legguards of Noon", "=ds=#s11#, #a4#", ""};
				{ 22, 56432, "", "=q3=Band of Rays", "=ds=#s13#", ""};
				{ 23, 56427, "", "=q3=Left Eye of Rajh", "=ds=#s14#", ""};
				{ 24, 56431, "", "=q3=Right Eye of Rajh", "=ds=#s14#", ""};
				{ 25, 56433, "", "=q3=Blade of the Burning Sun", "=ds=#h3#, #w10#", ""};
				{ 26, 56430, "", "=q3=Sun Strike", "=ds=#h1#, #w10#", ""};
			};
		};
		info = {
			name = BabbleBoss["Rajh"],
			module = moduleName, instance = "HallsOfOrigination",
		};
	};	

	AtlasLoot_Data["HoOTrash"] = {
		["Normal"] = {
			{
				{ 2, 56110, "", "=q3=Charm of the Muse", "=ds=#s2#", ""};
				{ 3, 56111, "", "=q3=Temple Band", "=ds=#s13#", ""};
				{ 4, 56109, "", "=q3=Book of Origination", "=ds=#s15#", ""};
--[[				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 56437, "", "=q3=Charm of the Muse", "=ds=#s2#", ""};
				{ 18, 56439, "", "=q3=Temple Band", "=ds=#s13#", ""};
				{ 19, 56438, "", "=q3=Book of Origination", "=ds=#s15#", ""};--]]
			};
		};
		info = {
			name = "trash",
			module = moduleName, instance = "HallsOfOrigination",
		};
	};


		---------------------
		--- The Deadmines ---
		---------------------

	AtlasLoot_Data["DeadminesGlubtok"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 5195, "", "=q3=Gold-Flecked Gloves", "=ds=#s9#, #a1#", "" };
				{ 3, 2169, "", "=q3=Buzzer Blade", "=ds=#h1#, #w4#", ""};
				{ 4, 5194, "", "=q3=Taskmaster Axe", "=ds=#h2#, #w1#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63467, "", "=q3=Shadow of the Past", "=ds=#s4#", ""};
				{ 18, 63468, "", "=q3=Defias Brotherhood Vest", "=ds=#s5#, #a2#", ""};
				{ 19, 63471, "", "=q3=Vest of the Curious Visitor", "=ds=#s5#, #a2#", ""};
				{ 20, 63470, "", "=q3=Missing Diplomat's Pauldrons", "=ds=#s3#, #a4#", ""};
				{ 21, 65163, "", "=q3=Buzzer Blade", "=ds=#h1#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Glubtok"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

	AtlasLoot_Data["DeadminesGearbreaker"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 5199, "", "=q3=Smelting Pants", "=ds=#s11#, #a2#", "" };
				{ 3, 5191, "", "=q3=Cruel Barb", "=ds=#h1#, #w10#", "" };
				{ 4, 5200, "", "=q3=Impaling Harpoon", "=ds=#w7#", "" };
				{ 5, 5443, "", "=q3=Gold-plated Buckler", "=ds=#w8#", "" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63473, "", "=q3=Cloak of Thredd", "=ds=#s4#", ""};
				{ 18, 63475, "", "=q3=Old Friend's Gloves", "=ds=#s9#, #a3#", ""};
				{ 19, 63476, "", "=q3=Gearbreaker's Bindings", "=ds=#s8#, #a4#", ""};
				{ 20, 63474, "", "=q3=Gear-Marked Gauntlets", "=ds=#s9#, #a4#", ""};
				{ 21, 65164, "", "=q3=Cruel Barb", "=ds=#h1#, #w10#", ""};
			};
		};
		info = {
			name = BabbleBoss["Helix Gearbreaker"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

	AtlasLoot_Data["DeadminesFoeReaper"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 1937, "", "=q3=Buzz Saw", "=ds=#h1#, #w10#", "", };
				{ 3, 5187, "", "=q3=Foe Reaper", "=ds=#h2#, #w6#", ""};
				{ 4, 5201, "", "=q3=Emberstone Staff", "=ds=#w9#", "" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 65166, "", "=q3=Buzz Saw", "=ds=#h1#, #w10#", ""};
				{ 18, 65165, "", "=q3=Foe Reaper", "=ds=#h2#, #w6#", ""};
				{ 19, 65167, "", "=q3=Emberstone Staff", "=ds=#w9#", ""};
			};
		};
		info = {
			name = BabbleBoss["Foe Reaper 5000"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

	AtlasLoot_Data["DeadminesRipsnarl"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 1156, "", "=q3=Lavishly Jeweled Ring", "=ds=#s13#", "", };
				{ 3, 5196, "", "=q3=Smite's Reaver", "=ds=#h1#, #w1#", ""};
				{ 4, 872, "", "=q3=Rockslicer", "=ds=#h2#, #w1#", ""};
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 65169, "", "=q3=Lavishly Jeweled Ring", "=ds=#s13#", ""};
				{ 18, 65170, "", "=q3=Smite's Reaver", "=ds=#h1#, #w1#", ""};
				{ 19, 65168, "", "=q3=Rockslicer", "=ds=#h2#, #w1#", ""};
			};
		};
		info = {
			name = BabbleBoss["Admiral Ripsnarl"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

	AtlasLoot_Data["DeadminesCookie"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 5193, "", "=q3=Cape of the Brotherhood", "=ds=#s4#", "" };
				{ 3, 5202, "", "=q3=Corsair's Overshirt", "=ds=#s5#, #a1#", "" };
				{ 4, 5192, "", "=q3=Thief's Blade", "=ds=#h1#, #w10#", ""};
				{ 5, 5197, "", "=q3=Cookie's Tenderizer", "=ds=#h1#, #w6#", "", };
				{ 6, 5198, "", "=q3=Cookie's Stirring Rod", "=ds=#w12#", "", };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 65177, "", "=q3=Cape of the Brotherhood", "=ds=#s4#", ""};
				{ 18, 65174, "", "=q3=Corsair's Overshirt", "=ds=#s5#, #a1#", ""};
				{ 19, 65173, "", "=q3=Thief's Blade", "=ds=#h1#, #w10#", ""};
				{ 20, 65171, "", "=q3=Cookie's Tenderizer", "=ds=#h1#, #w6#", ""};
				{ 21, 65172, "", "=q3=Cookie's Stirring Rod", "=ds=#w12#", ""};
			};
		};
		info = {
			name = BabbleBoss["\"Captain\" Cookie"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

	AtlasLoot_Data["DeadminesVanessa"] = {
		["Heroic"] = {
			{
				{ 1, 63484, "", "=q3=Armbands of Exiled Architects", "=ds=#s8#, #a1#", "" };
				{ 2, 63482, "", "=q3=Daughter's Hands", "=ds=#s9#, #a1#", "" };
				{ 3, 63485, "", "=q3=Cowl of Rebellion", "=ds=#s1#, #a2#", "" };
				{ 4, 65178, "", "=q3=VanCleef's Boots", "=ds=#s12#, #a2#", "" };
				{ 5, 63479, "", "=q3=Bracers of Some Consequence", "=ds=#s8#, #a3#", "" };
				{ 6, 63486, "", "=q3=Shackles of the Betrayed", "=ds=#s8#, #a3#", "" };
				{ 7, 63478, "", "=q3=Stonemason's Helm", "=ds=#s1#, #a4#", "" };
				{ 8, 63483, "", "=q3=Guildmaster's Greaves", "=ds=#s12#, #a4#", "" };
				{ 16, 63487, "", "=q3=Book of the Well Sung Song", "=ds=#s16#", "" };
				{ 17, 63480, "", "=q3=Record of the Brotherhood's End", "=ds=#s16#", "" };
				{ 19, 63477, "", "=q3=Wicked Dagger", "=ds=#h1#, #w4#", "" };
			};
		};
		info = {
			name = BabbleBoss["Vanessa VanCleef"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

	AtlasLoot_Data["DeadminesTrash"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 1930, "", "=q3=Stonemason Cloak", "=ds=#s4#", "", "0.01%"};
				{ 3, 1951, "", "=q3=Blackwater Cutlass", "=ds=#h1#, #w10#", "", "0.01%"};
				{ 4, 1926, "", "=q3=Weighted Sap", "=ds=#h1#, #w6#", "", "0.01%"};
			};
		};
		info = {
			name = AL["Trash Mobs"],
			module = moduleName, instance = "TheDeadminesEaI",
		};
	};

		-----------------------
		--- Shadowfang Keep ---
		-----------------------

	AtlasLoot_Data["ShadowfangAshbury"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 6314, "", "=q3=Wolfmaster Cape", "=ds=#s4#" };
				{ 3, 6324, "", "=q3=Robes of Arugal", "=ds=#s5#, #a1#" };
				{ 4, 6323, "", "=q3=Baron's Scepter", "=ds=#h1#, #w6#" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63433, "", "=q3=Robes of Arugal", "=ds=#s5#, #a1#" };
				{ 18, 63437, "", "=q3=Baron Ashbury's Cuffs", "=ds=#s8#, #a1#" };
				{ 19, 63435, "", "=q3=Boots of the Predator", "=ds=#s12#, #a2#" };
				{ 20, 63436, "", "=q3=Traitor's Grips", "=ds=#s9#, #a3#" };
				{ 21, 63434, "", "=q3=Gloves of the Greymane Wall", "=ds=#s9#, #a4#" };
			};
		};
		info = {
			name = BabbleBoss["Baron Ashbury"],
			module = moduleName, instance = "ShadowfangKeep",
		};
	};

	AtlasLoot_Data["ShadowfangSilverlaine"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 6321, "", "=q3=Silverlaine's Family Seal", "=ds=#s13#" };
				{ 3, 6323, "", "=q3=Baron's Scepter", "=ds=#h1#, #w6#" };
				{ 5, 60885, "", "=q1=Silverlaine Family Sword", "=ds=#m3#, =q1=#m1# =ds=#c9#", "", "100%" };
				{ 6, 60878, "", "=q1=Silverlaine's Enchanted Crystal", "=ds=#m3#, =q1=#m1# =ds=#c3#", "", "100%" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63440, "", "=q3=Boots of Lingering Sorrow", "=ds=#s12#, #a1#" };
				{ 18, 63439, "", "=q3=Gloves of the Uplifted Cup", "=ds=#s9#, #a2#" };
				{ 19, 63444, "", "=q3=Baron Silverlaine's Greaves", "=ds=#s12#, #a4#" };
				{ 20, 63438, "", "=q3=Baroness Silverlaine's Locket", "=ds=#s2#" };
				{ 21, 63441, "", "=q3=Pendant of the Keep", "=ds=#s2#" };
			};
		};
		info = {
			name = BabbleBoss["Baron Silverlaine"],
			module = moduleName, instance = "ShadowfangKeep",
		};
	};

	AtlasLoot_Data["ShadowfangSpringvale"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 3191, "", "=q3=Arced War Axe", "=ds=#h2#, #w1#" };
				{ 3, 6320, "", "=q3=Commander's Crest", "=ds=#w8#" };
				{ 5, 60879, "", "=q1=Commander's Holy Symbol", "=ds=#m3#, =q1=#m1# =ds=#c4#, =ds=#c5#", "", "100%" };
				{ 6, 60880, "", "=q1=Springvale's Sharpening Stone", "=ds=#m3#, =q1=#m1# =ds=#c6#", "", "100%" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63448, "", "=q3=Springvale's Cloak", "=ds=#s4#" };
				{ 18, 63449, "", "=q3=Thieving Spaulders", "=ds=#s3#, #a2#" };
				{ 19, 63447, "", "=q3=Breastplate of the Stilled Heart", "=ds=#s5#, #a3#" };
				{ 20, 63446, "", "=q3=Haunting Footfalls", "=ds=#s12#, #a3#" };
				{ 21, 63445, "", "=q3=Arced War Axe", "=ds=#h2#, #w1#" };
			};
		};
		info = {
			name = BabbleBoss["Commander Springvale"],
			module = moduleName, instance = "ShadowfangKeep",
		};
	};

	AtlasLoot_Data["ShadowfangWalden"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 3230, "", "=q3=Black Wolf Bracers", "=ds=#s8#, #a2#" };
				{ 3, 6642, "", "=q3=Phantom Armor", "=ds=#s5#, #a3#" };
				{ 4, 6341, "", "=q3=Eerie Stable Lantern", "=ds=#s15#" };
				{ 5, 1292, "", "=q3=Butcher's Cleaver", "=ds=#h1#, #w1#" };
				{ 7, 60876, "", "=q1=Walden's Elixirs", "=ds=#m3#, =q1=#m1# =ds=#c1#", "", "100%" };
				{ 8, 60881, "", "=q1=Walden's Talisman", "=ds=#m3#, =q1=#m1# =ds=#c7#", "", "100%" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63455, "", "=q3=Blinders of the Follower", "=ds=#s1#, #a1#" };
				{ 18, 63454, "", "=q3=Double Dealing Bracers", "=ds=#s8#, #a2#" };
				{ 19, 63452, "", "=q3=Burden of Lost Humanity", "=ds=#s3#, #a3#" };
				{ 20, 63450, "", "=q3=Phantom Armor", "=ds=#s5#, #a4#" };
				{ 21, 63453, "", "=q3=Iron Will Girdle", "=ds=#s10#, #a4#" };
			};
		};
		info = {
			name = BabbleBoss["Lord Walden"],
			module = moduleName, instance = "ShadowfangKeep",
		};
	};

	AtlasLoot_Data["ShadowfangGodfrey"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 3748, "", "=q3=Feline Mantle", "=ds=#s3#, #a1#" };
				{ 3, 6220, "", "=q3=Meteor Shard", "=ds=#h1#, #w4#" };
				{ 4, 6641, "", "=q3=Haunting Blade", "=ds=#h2#, #w10#" };
				{ 5, 6318, "", "=q3=Odo's Ley Staff", "=ds=#w9#" };
				{ 7, 60877, "", "=q1=Godfrey's Crystal Scope", "=ds=#m3#, =q1=#m1# =ds=#c2#", "", "100%" };
				{ 8, 60882, "", "=q1=Tenebrous Orb", "=ds=#m3#, =q1=#m1# =ds=#c8#", "", "100%" };
				{ 16, 0, "inv_box_04", "=q6=#j3#", ""};
				{ 17, 63465, "", "=q3=Mantle of Loss", "=ds=#s3#, #a1#" };
				{ 18, 63463, "", "=q3=Mantle of the Eastern Lords", "=ds=#s3#, #a1#" };
				{ 19, 63459, "", "=q3=Worgen Hunter's Helm", "=ds=#s1#, #a3#" };
				{ 20, 63462, "", "=q3=Helm of Untold Stories", "=ds=#s1#, #a4#" };
				{ 21, 63458, "", "=q3=Lord Walden's Breastplate", "=ds=#s5#, #a4#" };
				{ 22, 63457, "", "=q3=Shackles of Undeath", "=ds=#s8#, #a4#" };
				{ 23, 63464, "", "=q3=Greaves of the Misguided", "=ds=#s11#, #a4#" };
				{ 24, 63460, "", "=q3=Relic of Arathor", "=ds=#s14#" };
				{ 25, 63456, "", "=q3=Meteor Shard", "=ds=#h1#, #w4#" };
				{ 26, 63461, "", "=q3=Staff of Isolation", "=ds=#w9#" };
			};
		};
		info = {
			name = BabbleBoss["Lord Godfrey"],
			module = moduleName, instance = "ShadowfangKeep",
		};
	};

	AtlasLoot_Data["ShadowfangTrash"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#j1#", ""};
				{ 2, 1974, "", "=q3=Mindthrust Bracers", "=ds=#s8#, #a1#", "", "0.01%"};
				{ 3, 3194, "", "=q3=Black Malice", "=ds=#h2#, #w6#", "", "0.01%"};
				{ 4, 1483, "", "=q3=Face Smasher", "=ds=#h1#, #w6#", "", "0.01%"};
				{ 5, 2807, "", "=q3=Guillotine Axe", "=ds=#h1#, #w1#", "", "0.01%"};
				{ 6, 1318, "", "=q3=Night Reaver", "=ds=#h2#, #w1#", "", "0.01%"};
				{ 7, 1484, "", "=q3=Witching Stave", "=ds=#h2#, #w9#", "", "0.01%"};
				{ 17, 60977, "", "=q1=Orders from High Command", "=ds=#m3#"};
				{ 18, 60874, "", "=q1=Deathless Sinew", "=ds=#m3#", "", "100%"};
				{ 19, 60875, "", "=q1=Ghostly Essence", "=ds=#m3#", "", "100%"};
			};
		};
		info = {
			name = AL["Trash Mobs"],
			module = moduleName, instance = "ShadowfangKeep",
		};
	};

		-------------------------------
		--- The Bastion of Twilight ---
		-------------------------------

	AtlasLoot_Data["BoTWyrmbreaker"] = {
		["Normal"] = {
			{
				{ 1, 59482, "", "=q4=Robes of the Burning Acolyte", "=ds=#s5#, #a1#", ""};
				{ 2, 59475, "", "=q4=Bracers of the Bronze Flight", "=ds=#s8#, #a1#", ""};
				{ 3, 59469, "", "=q4=Storm Rider's Boots", "=ds=#s12#, #a2#", ""};
				{ 4, 59481, "", "=q4=Helm of the Nether Scion", "=ds=#s1#, #a3#", ""};
				{ 5, 59472, "", "=q4=Proto-Handler's Gauntlets", "=ds=#s9#, #a3#", ""};
				{ 6, 59471, "", "=q4=Pauldrons of the Great Ettin", "=ds=#s3#, #a4#", ""};
				{ 7, 59470, "", "=q4=Bracers of Impossible Strength", "=ds=#s8#, #a4#", ""};
				{ 8, 59476, "", "=q4=Legguards of the Emerald Brood", "=ds=#s11#, #a4#", ""};
				{ 16, 59483, "", "=q4=Wyrmbreaker's Amulet", "=ds=#s2#", ""};
				{ 17, 59473, "", "=q4=Essence of the Cyclone", "=ds=#s14#", ""};
				{ 18, 59484, "", "=q4=Book of Binding Will", "=ds=#s15#", ""};
				{ 20, 59474, "", "=q4=Malevolence", "=ds=#w9#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65135, "", "=q4=Robes of the Burning Acolyte", "=ds=#s5#, #a1#", ""};
				{ 2, 65138, "", "=q4=Bracers of the Bronze Flight", "=ds=#s8#, #a1#", ""};
				{ 3, 65144, "", "=q4=Storm Rider's Boots", "=ds=#s12#, #a2#", ""};
				{ 4, 65136, "", "=q4=Helm of the Nether Scion", "=ds=#s1#, #a3#", ""};
				{ 5, 65141, "", "=q4=Proto-Handler's Gauntlets", "=ds=#s9#, #a3#", ""};
				{ 6, 65142, "", "=q4=Pauldrons of the Great Ettin", "=ds=#s3#, #a4#", ""};
				{ 7, 65143, "", "=q4=Bracers of Impossible Strength", "=ds=#s8#, #a4#", ""};
				{ 8, 65137, "", "=q4=Legguards of the Emerald Brood", "=ds=#s11#, #a4#", ""};
				{ 10, 65134, "", "=q4=Wyrmbreaker's Amulet", "=ds=#s2#", ""};
				{ 11, 65140, "", "=q4=Essence of the Cyclone", "=ds=#s14#", ""};
				{ 12, 65133, "", "=q4=Book of Binding Will", "=ds=#s15#", ""};
				{ 16, 67423, "", "=q4=Chest of the Forlorn Conqueror", "=ds=#e15#, #m37# - #j4#"};
				{ 17, 67424, "", "=q4=Chest of the Forlorn Protector", "=ds=#e15#, #m37# - #j4#"};
				{ 18, 67425, "", "=q4=Chest of the Forlorn Vanquisher", "=ds=#e15#, #m37# - #j4#"};
				{ 20, 65139, "", "=q4=Malevolence", "=ds=#w9#", ""};
			};
		};
		info = {
			name = BabbleBoss["Halfus Wyrmbreaker"],
			module = moduleName, instance = "TheBastionOfTwilight",
		};
	};

	AtlasLoot_Data["BoTValionaTheralion"] = {
		["Normal"] = {
			{
				{ 1, 59516, "", "=q4=Drape of the Twins", "=ds=#s4#", ""};
				{ 2, 63534, "", "=q4=Helm of Eldritch Authority", "=ds=#s1#, #a1#", ""};
				{ 3, 63535, "", "=q4=Waistguard of Hatred", "=ds=#s10#, #a3#", ""};
				{ 4, 63531, "", "=q4=Daybreaker Helm", "=ds=#s1#, #a4#", ""};
				{ 6, 59517, "", "=q4=Necklace of Strife", "=ds=#s2#", ""};
				{ 7, 59512, "", "=q4=Valiona's Medallion", "=ds=#s2#", ""};
				{ 8, 59518, "", "=q4=Ring of Rivalry", "=ds=#s13#", ""};
				{ 9, 59519, "", "=q4=Theralion's Mirror", "=ds=#s14#", ""};
				{ 10, 59515, "", "=q4=Vial of Stolen Memories", "=ds=#s14#", ""};
				{ 16, 63533, "", "=q4=Fang of Twilight", "=ds=#h1#, #w10#", ""};
				{ 17, 63536, "", "=q4=Blade of the Witching Hour", "=ds=#h3#, #w4#", ""};
				{ 18, 63532, "", "=q4=Dragonheart Piercer", "=ds=#w3#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65108, "", "=q4=Drape of the Twins", "=ds=#s4#", ""};
				{ 2, 65093, "", "=q4=Helm of Eldritch Authority", "=ds=#s1#, #a1#", ""};
				{ 3, 65092, "", "=q4=Waistguard of Hatred", "=ds=#s10#, #a3#", ""};
				{ 4, 65096, "", "=q4=Daybreaker Helm", "=ds=#s1#, #a4#", ""};
				{ 6, 65107, "", "=q4=Necklace of Strife", "=ds=#s2#", ""};
				{ 7, 65112, "", "=q4=Valiona's Medallion", "=ds=#s2#", ""};
				{ 8, 65106, "", "=q4=Ring of Rivalry", "=ds=#s13#", ""};
				{ 9, 65105, "", "=q4=Theralion's Mirror", "=ds=#s14#", ""};
				{ 10, 65109, "", "=q4=Vial of Stolen Memories", "=ds=#s14#", ""};
				{ 16, 65094, "", "=q4=Fang of Twilight", "=ds=#h1#, #w10#", ""};
				{ 17, 65091, "", "=q4=Blade of the Witching Hour", "=ds=#h3#, #w4#", ""};
				{ 18, 65095, "", "=q4=Dragonheart Piercer", "=ds=#w3#", ""};
			};
		};
		info = {
			name = BabbleBoss["Valiona and Theralion"],
			module = moduleName, instance = "TheBastionOfTwilight",
		};
	};

	AtlasLoot_Data["BoTCouncil"] = {
		["Normal"] = {
			{
				{ 1, 59507, "", "=q4=Glittering Epidermis", "=ds=#s4#", ""};
				{ 2, 59508, "", "=q4=Treads of Liquid Ice", "=ds=#s12#, #a1#", ""};
				{ 3, 59511, "", "=q4=Hydrolance Gloves", "=ds=#s9#, #a2#", ""};
				{ 4, 59502, "", "=q4=Dispersing Belt", "=ds=#s10#, #a2#", ""};
				{ 5, 59504, "", "=q4=Arion's Crown", "=ds=#s1#, #a3#", ""};
				{ 6, 59510, "", "=q4=Feludius' Mantle", "=ds=#s3#, #a3#", ""};
				{ 7, 59509, "", "=q4=Glaciated Helm", "=ds=#s1#, #a4#", ""};
				{ 8, 59505, "", "=q4=Gravitational Pull", "=ds=#s9#, #a4#", ""};
				{ 9, 59503, "", "=q4=Terrastra's Legguards", "=ds=#s11#, #a4#", ""};
				{ 16, 59506, "", "=q4=Crushing Weight", "=ds=#s14#", ""};
				{ 17, 59514, "", "=q4=Heart of Ignacious", "=ds=#s14#", ""};
				{ 18, 59513, "", "=q4=Scepter of Ice", "=ds=#s15#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65117, "", "=q4=Glittering Epidermis", "=ds=#s4#", ""};
				{ 2, 65116, "", "=q4=Treads of Liquid Ice", "=ds=#s12#, #a1#", ""};
				{ 3, 65113, "", "=q4=Hydrolance Gloves", "=ds=#s9#, #a2#", ""};
				{ 4, 65122, "", "=q4=Dispersing Belt", "=ds=#s10#, #a2#", ""};
				{ 5, 65120, "", "=q4=Arion's Crown", "=ds=#s1#, #a3#", ""};
				{ 6, 65114, "", "=q4=Feludius' Mantle", "=ds=#s3#, #a3#", ""};
				{ 7, 65115, "", "=q4=Glaciated Helm", "=ds=#s1#, #a4#", ""};
				{ 8, 65119, "", "=q4=Gravitational Pull", "=ds=#s9#, #a4#", ""};
				{ 9, 65121, "", "=q4=Terrastra's Legguards", "=ds=#s11#, #a4#", ""};
				{ 16, 65118, "", "=q4=Crushing Weight", "=ds=#s14#", ""};
				{ 17, 65110, "", "=q4=Heart of Ignacious", "=ds=#s14#", ""};
				{ 18, 65111, "", "=q4=Scepter of Ice", "=ds=#s15#", ""};
			};
		};
		info = {
			name = BabbleBoss["Ascendant Council"],
			module = moduleName, instance = "TheBastionOfTwilight",
		};
	};

	AtlasLoot_Data["BoTChogall"] = {
		["Normal"] = {
			{
				{ 1, 59498, "", "=q4=Hands of the Twilight Council", "=ds=#s9#, #a1#", ""};
				{ 2, 59490, "", "=q4=Membrane of C'Thun", "=ds=#s1#, #a2#", ""};
				{ 3, 59495, "", "=q4=Treads of Hideous Transformation", "=ds=#s12#, #a2#", ""};
				{ 4, 59485, "", "=q4=Coil of Ten-Thousand Screams", "=ds=#s10#, #a3#", ""};
				{ 5, 59499, "", "=q4=Kilt of the Forgotten Battle", "=ds=#s11#, #a3#", ""};
				{ 6, 59487, "", "=q4=Helm of Maddening Whispers", "=ds=#s1#, #a4#", ""};
				{ 7, 59486, "", "=q4=Battleplate of the Apocalypse", "=ds=#s5#, #a4#", ""};
				{ 8, 59497, "", "=q4=Shackles of the End of Days", "=ds=#s8#, #a4#", ""};
				{ 10, 59501, "", "=q4=Signet of the Fifth Circle", "=ds=#s13#", ""};
				{ 11, 59500, "", "=q4=Fall of Mortality", "=ds=#s14#", ""};
				{ 16, 64315, "", "=q4=Mantle of the Forlorn Conqueror", "=ds=#e15#, #m37#"};
				{ 17, 64316, "", "=q4=Mantle of the Forlorn Protector", "=ds=#e15#, #m37#"};
				{ 18, 64314, "", "=q4=Mantle of the Forlorn Vanquisher", "=ds=#e15#, #m37#"};
				{ 20, 59494, "", "=q4=Uhn'agh Fash, the Darkest Betrayal", "=ds=#h1#, #w4#", ""};
				{ 21, 59330, "", "=q4=Shalug'doom, the Axe of Unmaking", "=ds=#h2#, #w1#", ""};
				{ 22, 63680, "", "=q4=Twilight's Hammer", "=ds=#h3#, #w6#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65126, "", "=q4=Hands of the Twilight Council", "=ds=#s9#, #a1#", ""};
				{ 2, 65129, "", "=q4=Membrane of C'Thun", "=ds=#s1#, #a2#", ""};
				{ 3, 65128, "", "=q4=Treads of Hideous Transformation", "=ds=#s12#, #a2#", ""};
				{ 4, 65132, "", "=q4=Coil of Ten-Thousand Screams", "=ds=#s10#, #a3#", ""};
				{ 5, 65125, "", "=q4=Kilt of the Forgotten Battle", "=ds=#s11#, #a3#", ""};
				{ 6, 65130, "", "=q4=Helm of Maddening Whispers", "=ds=#s1#, #a4#", ""};
				{ 7, 65131, "", "=q4=Battleplate of the Apocalypse", "=ds=#s5#, #a4#", ""};
				{ 8, 65127, "", "=q4=Shackles of the End of Days", "=ds=#s8#, #a4#", ""};
				{ 10, 65123, "", "=q4=Signet of the Fifth Circle", "=ds=#s13#", ""};
				{ 11, 65124, "", "=q4=Fall of Mortality", "=ds=#s14#", ""};
				{ 16, 65088, "", "=q4=Shoulders of the Forlorn Conqueror", "=ds=#e15#, #m37# - #j4#"};
				{ 17, 65087, "", "=q4=Shoulders of the Forlorn Protector", "=ds=#e15#, #m37# - #j4#"};
				{ 18, 65089, "", "=q4=Shoulders of the Forlorn Vanquisher", "=ds=#e15#, #m37# - #j4#"};
				{ 20, 68600, "", "=q4=Uhn'agh Fash, the Darkest Betrayal", "=ds=#h1#, #w4#", ""};
				{ 21, 65145, "", "=q4=Shalug'doom, the Axe of Unmaking", "=ds=#h2#, #w1#", ""};
				{ 22, 65090, "", "=q4=Twilight's Hammer", "=ds=#h3#, #w6#", ""};
			};
		};
		info = {
			name = BabbleBoss["Cho'gall"],
			module = moduleName, instance = "TheBastionOfTwilight",
		};
	};

	AtlasLoot_Data["BoTSinestra"] = {
		["Heroic"] = {
			{
				{ 1, 60232, "", "=q4=Shroud of Endless Grief", "=ds=#s4#", ""};
				{ 2, 60237, "", "=q4=Crown of the Twilight Queen", "=ds=#s1#, #a1#", ""};
				{ 3, 60238, "", "=q4=Bracers of the Dark Mother", "=ds=#s8#, #a1#", ""};
				{ 4, 60231, "", "=q4=Belt of the Fallen Brood", "=ds=#s10#, #a2#", ""};
				{ 5, 60236, "", "=q4=Nightmare Rider's Boots", "=ds=#s12#, #a2#", ""};
				{ 6, 60230, "", "=q4=Twilight Scale Leggings", "=ds=#s11#, #a3#", ""};
				{ 7, 60235, "", "=q4=Boots of Az'galada", "=ds=#s12#, #a3#", ""};
				{ 8, 60234, "", "=q4=Bindings of Bleak Betrayal", "=ds=#s8#, #a4#", ""};
				{ 9, 60228, "", "=q4=Bracers of the Mat'redor", "=ds=#s8#, #a4#", ""};
				{ 16, 60227, "", "=q4=Caelestrasz's Will", "=ds=#s2#", ""};
				{ 17, 60226, "", "=q4=Dargonax's Signet", "=ds=#s13#", ""};
				{ 18, 60233, "", "=q4=Shard of Woe", "=ds=#s14#", ""};
			};
		};
		info = {
			name = BabbleBoss["Sinestra"],
			module = moduleName, instance = "TheBastionOfTwilight",
		};
	};

	AtlasLoot_Data["BoTTrash"] = {
		["Normal"] = {
			{
				{ 1, 60211, "", "=q4=Bracers of the Dark Pool", "=ds=#s8#, #a1#", ""};
				{ 2, 60202, "", "=q4=Tsanga's Helm", "=ds=#s1#, #a2#", ""};
				{ 3, 60201, "", "=q4=Phase-Twister Leggings", "=ds=#s11#, #a3#", ""};
				{ 4, 59901, "", "=q4=Heaving Plates of Protection", "=ds=#s3#, #a4#", ""};
				{ 6, 59520, "", "=q4=Unheeded Warning", "=ds=#s14#", ""};
				{ 16, 59521, "", "=q4=Soul Blade", "=ds=#h1#, #w10#", ""};
				{ 17, 59525, "", "=q4=Chelley's Staff of Dark Mending", "=ds=#w9#", ""};
				{ 18, 60210, "", "=q4=Crossfire Carbine", "=ds=#w5#", ""};
				{ 19, 68608, "", "=q4=Dragonwreck Throwing Axe", "=ds=#w11#", ""};
			};
		};
		--[[ Commented out, as the heroic trash mobs drop normal loot
		["Heroic"] = {
			{
				{ 1, 65097, "", "=q4=Bracers of the Dark Pool", "=ds=#s8#, #a1#", ""};
				{ 2, 65100, "", "=q4=Phase-Twister Leggings", "=ds=#s11#, #a3#", ""};
				{ 3, 65101, "", "=q4=Heaving Plates of Protection", "=ds=#s3#, #a4#", ""};
				{ 5, 65104, "", "=q4=Unheeded Warning", "=ds=#s14#", ""};
				{ 16, 65103, "", "=q4=Soul Blade", "=ds=#h1#, #w10#", ""};
				{ 17, 65102, "", "=q4=Chelley's Staff of Dark Mending", "=ds=#w9#", ""};
				{ 18, 65098, "", "=q4=Crossfire Carbine", "=ds=#w5#", ""};
			};
		};
		]]--
		info = {
			name = "trash",
			module = moduleName, instance = "TheBastionOfTwilight",
		};
	};

		--------------------------
		--- Blackwing Descent ----
		--------------------------

	AtlasLoot_Data["BDMagmaw"] = {
		["Normal"] = {
			{
				{ 1, 59452, "", "=q4=Crown of Burning Waters", "=ds=#s1#, #a1#", ""};
				{ 2, 59336, "", "=q4=Flame Pillar Leggings", "=ds=#s11#, #a1#", ""};
				{ 3, 59335, "", "=q4=Scorched Wormling Vest", "=ds=#s5#, #a2#", ""};
				{ 4, 59329, "", "=q4=Parasitic Bands", "=ds=#s8#, #a2#", ""};
				{ 5, 59334, "", "=q4=Lifecycle Waistguard", "=ds=#s10#, #a3#", ""};
				{ 6, 59331, "", "=q4=Leggings of Lethal Force", "=ds=#s11#, #a3#", ""};
				{ 7, 59340, "", "=q4=Breastplate of Avenging Flame", "=ds=#s5#, #a4#", ""};
				{ 8, 59328, "", "=q4=Molten Tantrum Boots", "=ds=#s12#, #a4#", ""};
				{ 10, 59332, "", "=q4=Symbiotic Worm", "=ds=#s14#", ""};
				{ 16, 59333, "", "=q4=Lava Spine", "=ds=#h1#, #w10#", ""};
				{ 17, 59492, "", "=q4=Akirus the Worm-Breaker", "=ds=#h2#, #w6#", ""};
				{ 18, 59341, "", "=q4=Incineratus", "=ds=#h3#, #w4#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65020, "", "=q4=Crown of Burning Waters", "=ds=#s1#, #a1#", ""};
				{ 2, 65044, "", "=q4=Flame Pillar Leggings", "=ds=#s11#, #a1#", ""};
				{ 3, 65045, "", "=q4=Scorched Wormling Vest", "=ds=#s5#, #a2#", ""};
				{ 4, 65050, "", "=q4=Parasitic Bands", "=ds=#s8#, #a2#", ""};
				{ 5, 65046, "", "=q4=Lifecycle Waistguard", "=ds=#s10#, #a3#", ""};
				{ 6, 65049, "", "=q4=Leggings of Lethal Force", "=ds=#s11#, #a3#", ""};
				{ 7, 65042, "", "=q4=Breastplate of Avenging Flame", "=ds=#s5#, #a4#", ""};
				{ 8, 65051, "", "=q4=Molten Tantrum Boots", "=ds=#s12#, #a4#", ""};
				{ 10, 65048, "", "=q4=Symbiotic Worm", "=ds=#s14#", ""};
				{ 16, 67429, "", "=q4=Gauntlets of the Forlorn Conqueror", "=ds=#e15#, #m37# - #j4#"};
				{ 17, 67430, "", "=q4=Gauntlets of the Forlorn Protector", "=ds=#e15#, #m37# - #j4#"};
				{ 18, 67431, "", "=q4=Gauntlets of the Forlorn Vanquisher", "=ds=#e15#, #m37# - #j4#"};
				{ 20, 65047, "", "=q4=Lava Spine", "=ds=#h1#, #w10#", ""};
				{ 21, 65007, "", "=q4=Akirus the Worm-Breaker", "=ds=#h2#, #w6#", ""};
				{ 22, 65041, "", "=q4=Incineratus", "=ds=#h3#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Magmaw"],
			module = moduleName, instance = "BlackwingDescent",
		};
	};

	AtlasLoot_Data["BDOmnotron"] = {
		["Normal"] = {
			{
				{ 1, 59219, "", "=q4=Power Generator Hood", "=ds=#s1#, #a1#", ""};
				{ 2, 59217, "", "=q4=X-Tron Duct Tape", "=ds=#s10#, #a1#", ""};
				{ 3, 59218, "", "=q4=Passive Resistor Spaulders", "=ds=#s3#, #a2#", ""};
				{ 4, 59120, "", "=q4=Poison Protocol Pauldrons", "=ds=#s3#, #a2#", ""};
				{ 5, 63540, "", "=q4=Circuit Design Breastplate", "=ds=#s5#, #a3#", ""};
				{ 6, 59119, "", "=q4=Voltage Source Chestguard", "=ds=#s5#, #a3#", ""};
				{ 7, 59118, "", "=q4=Electron Inductor Coils", "=ds=#s8#, #a4#", ""};
				{ 8, 59117, "", "=q4=Jumbotron Power Belt", "=ds=#s10#, #a4#", ""};
				{ 9, 59216, "", "=q4=Life Force Chargers", "=ds=#s12#, #a4#", ""};
				{ 16, 59220, "", "=q4=Security Measure Alpha", "=ds=#s13#", ""};
				{ 17, 59121, "", "=q4=Lightning Conductor Band", "=ds=#s13#", ""};
				{ 19, 59122, "", "=q4=Organic Lifeform Inverter", "=ds=#h1#, #w4#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65077, "", "=q4=Power Generator Hood", "=ds=#s1#, #a1#", ""};
				{ 2, 65079, "", "=q4=X-Tron Duct Tape", "=ds=#s10#, #a1#", ""};
				{ 3, 65078, "", "=q4=Passive Resistor Spaulders", "=ds=#s3#, #a2#", ""};
				{ 4, 65083, "", "=q4=Poison Protocol Pauldrons", "=ds=#s3#, #a2#", ""};
				{ 5, 65004, "", "=q4=Circuit Design Breastplate", "=ds=#s5#, #a3#", ""};
				{ 6, 65084, "", "=q4=Voltage Source Chestguard", "=ds=#s5#, #a3#", ""};
				{ 7, 65085, "", "=q4=Electron Inductor Coils", "=ds=#s8#, #a4#", ""};
				{ 8, 65086, "", "=q4=Jumbotron Power Belt", "=ds=#s10#, #a4#", ""};
				{ 9, 65080, "", "=q4=Life Force Chargers", "=ds=#s12#, #a4#", ""};
				{ 16, 65076, "", "=q4=Security Measure Alpha", "=ds=#s13#", ""};
				{ 17, 65082, "", "=q4=Lightning Conductor Band", "=ds=#s13#", ""};
				{ 19, 65081, "", "=q4=Organic Lifeform Inverter", "=ds=#h1#, #w4#", ""};
			};
		};
		info = {
			name = BabbleBoss["Omnotron Defense System"],
			module = moduleName, instance = "BlackwingDescent",
		};
	};

	AtlasLoot_Data["BDMaloriak"] = {
		["Normal"] = {
			{
				{ 1, 59348, "", "=q4=Cloak of Biting Chill", "=ds=#s4#", ""};
				{ 2, 59349, "", "=q4=Belt of Arcane Storms", "=ds=#s10#, #a1#", ""};
				{ 3, 59351, "", "=q4=Legwraps of the Greatest Son", "=ds=#s11#, #a1#", ""};
				{ 4, 59343, "", "=q4=Aberration's Leggings", "=ds=#s11#, #a2#", ""};
				{ 5, 59353, "", "=q4=Leggings of Consuming Flames", "=ds=#s11#, #a2#", ""};
				{ 6, 59346, "", "=q4=Tunic of Failed Experiments", "=ds=#s5#, #a3#", ""};
				{ 7, 59350, "", "=q4=Treads of Flawless Creation", "=ds=#s12#, #a3#", ""};
				{ 8, 59344, "", "=q4=Dragon Bone Warhelm", "=ds=#s1#, #a4#", ""};
				{ 9, 59352, "", "=q4=Flash Freeze Gauntlets", "=ds=#s9#, #a4#", ""};
				{ 10, 59342, "", "=q4=Belt of Absolute Zero", "=ds=#s10#, #a4#", ""};
				{ 16, 59354, "", "=q4=Jar of Ancient Remedies", "=ds=#s14#", ""};
				{ 18, 59347, "", "=q4=Mace of Acrid Death", "=ds=#h1#, #w6#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65035, "", "=q4=Cloak of Biting Chill", "=ds=#s4#", ""};
				{ 2, 65034, "", "=q4=Belt of Arcane Storms", "=ds=#s10#, #a1#", ""};
				{ 3, 65032, "", "=q4=Legwraps of the Greatest Son", "=ds=#s11#, #a1#", ""};
				{ 4, 65039, "", "=q4=Aberration's Leggings", "=ds=#s11#, #a2#", ""};
				{ 5, 65030, "", "=q4=Leggings of Consuming Flames", "=ds=#s11#, #a2#", ""};
				{ 6, 65037, "", "=q4=Tunic of Failed Experiments", "=ds=#s5#, #a3#", ""};
				{ 7, 65033, "", "=q4=Treads of Flawless Creation", "=ds=#s12#, #a3#", ""};
				{ 8, 65038, "", "=q4=Dragon Bone Warhelm", "=ds=#s1#, #a4#", ""};
				{ 9, 65031, "", "=q4=Flash Freeze Gauntlets", "=ds=#s9#, #a4#", ""};
				{ 10, 65040, "", "=q4=Belt of Absolute Zero", "=ds=#s10#, #a4#", ""};
				{ 16, 67428, "", "=q4=Leggings of the Forlorn Conqueror", "=ds=#e15#, #m37# - #j4#"};
				{ 17, 67427, "", "=q4=Leggings of the Forlorn Protector", "=ds=#e15#, #m37# - #j4#"};
				{ 18, 67426, "", "=q4=Leggings of the Forlorn Vanquisher", "=ds=#e15#, #m37# - #j4#"};
				{ 20, 65029, "", "=q4=Jar of Ancient Remedies", "=ds=#s14#", ""};
				{ 22, 65036, "", "=q4=Mace of Acrid Death", "=ds=#h1#, #w6#", ""};
			};
		};
		info = {
			name = BabbleBoss["Maloriak"],
			module = moduleName, instance = "BlackwingDescent",
		};
	};

	AtlasLoot_Data["BDAtramedes"] = {
		["Normal"] = {
			{
				{ 1, 59325, "", "=q4=Mantle of Roaring Flames", "=ds=#s3#, #a1#", ""};
				{ 2, 59322, "", "=q4=Bracers of the Burningeye", "=ds=#s8#, #a1#", ""};
				{ 3, 59312, "", "=q4=Helm of the Blind Seer", "=ds=#s1#, #a2#", ""};
				{ 4, 59318, "", "=q4=Sark of the Unwatched", "=ds=#s5#, #a2#", ""};
				{ 5, 59324, "", "=q4=Gloves of Cacophony", "=ds=#s9#, #a3#", ""};
				{ 6, 59315, "", "=q4=Boots of Vertigo", "=ds=#s12#, #a3#", ""};
				{ 7, 59316, "", "=q4=Battleplate of Ancient Kings", "=ds=#s5#, #a4#", ""};
				{ 8, 59317, "", "=q4=Legguards of the Unseeing", "=ds=#s11#, #a4#", ""};
				{ 16, 59319, "", "=q4=Ironstar Amulet", "=ds=#s2#", ""};
				{ 17, 59326, "", "=q4=Bell of Enraging Resonance", "=ds=#s14#", ""};
				{ 18, 59320, "", "=q4=Themios the Darkbringer", "=ds=#w2#", ""};
				{ 19, 59327, "", "=q4=Kingdom's Heart", "=ds=#w8#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65054, "", "=q4=Mantle of Roaring Flames", "=ds=#s3#, #a1#", ""};
				{ 2, 65056, "", "=q4=Bracers of the Burningeye", "=ds=#s8#, #a1#", ""};
				{ 3, 65066, "", "=q4=Helm of the Blind Seer", "=ds=#s1#, #a2#", ""};
				{ 4, 65060, "", "=q4=Sark of the Unwatched", "=ds=#s5#, #a2#", ""};
				{ 5, 65055, "", "=q4=Gloves of Cacophony", "=ds=#s9#, #a3#", ""};
				{ 6, 65063, "", "=q4=Boots of Vertigo", "=ds=#s12#, #a3#", ""};
				{ 7, 65062, "", "=q4=Battleplate of Ancient Kings", "=ds=#s5#, #a4#", ""};
				{ 8, 65061, "", "=q4=Legguards of the Unseeing", "=ds=#s11#, #a4#", ""};
				{ 16, 65059, "", "=q4=Ironstar Amulet", "=ds=#s2#", ""};
				{ 17, 65053, "", "=q4=Bell of Enraging Resonance", "=ds=#s14#", ""};
				{ 18, 65058, "", "=q4=Themios the Darkbringer", "=ds=#w2#", ""};
				{ 19, 65052, "", "=q4=Kingdom's Heart", "=ds=#w8#", ""};
			};
		};
		info = {
			name = BabbleBoss["Atramedes"],
			module = moduleName, instance = "BlackwingDescent",
		};
	};

	AtlasLoot_Data["BDChimaeron"] = {
		["Normal"] = {
			{
				{ 1, 59313, "", "=q4=Brackish Gloves", "=ds=#s9#, #a1#", ""};
				{ 2, 59234, "", "=q4=Einhorn's Galoshes", "=ds=#s12#, #a1#", ""};
				{ 3, 59451, "", "=q4=Manacles of the Sleeping Beast", "=ds=#s8#, #a2#", ""};
				{ 4, 59223, "", "=q4=Double Attack Handguards", "=ds=#s9#, #a2#", ""};
				{ 5, 59310, "", "=q4=Chaos Beast Bracers", "=ds=#s8#, #a3#", ""};
				{ 6, 59355, "", "=q4=Chimaeron Armguards", "=ds=#s8#, #a3#", ""};
				{ 7, 59311, "", "=q4=Burden of Mortality", "=ds=#s3#, #a4#", ""};
				{ 8, 59225, "", "=q4=Plated Fists of Provocation", "=ds=#s9#, #a4#", ""};
				{ 9, 59221, "", "=q4=Massacre Treads", "=ds=#s12#, #a4#", ""};
				{ 16, 59233, "", "=q4=Bile-O-Tron Nut", "=ds=#s13#", ""};
				{ 17, 59224, "", "=q4=Heart of Rage", "=ds=#s14#", ""};
				{ 19, 59314, "", "=q4=Finkle's Mixer Upper", "=ds=#w12#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65065, "", "=q4=Brackish Gloves", "=ds=#s9#, #a1#", ""};
				{ 2, 65069, "", "=q4=Einhorn's Galoshes", "=ds=#s12#, #a1#", ""};
				{ 3, 65021, "", "=q4=Manacles of the Sleeping Beast", "=ds=#s8#, #a2#", ""};
				{ 4, 65073, "", "=q4=Double Attack Handguards", "=ds=#s9#, #a2#", ""};
				{ 5, 65068, "", "=q4=Chaos Beast Bracers", "=ds=#s8#, #a3#", ""};
				{ 6, 65028, "", "=q4=Chimaeron Armguards", "=ds=#s8#, #a3#", ""};
				{ 7, 65067, "", "=q4=Burden of Mortality", "=ds=#s3#, #a4#", ""};
				{ 8, 65071, "", "=q4=Plated Fists of Provocation", "=ds=#s9#, #a4#", ""};
				{ 9, 65075, "", "=q4=Massacre Treads", "=ds=#s12#, #a4#", ""};
				{ 16, 65070, "", "=q4=Bile-O-Tron Nut", "=ds=#s13#", ""};
				{ 17, 65072, "", "=q4=Heart of Rage", "=ds=#s14#", ""};
				{ 19, 65064, "", "=q4=Finkle's Mixer Upper", "=ds=#w12#", ""};
			};
		};
		info = {
			name = BabbleBoss["Chimaeron"],
			module = moduleName, instance = "BlackwingDescent",
		};
	};

	AtlasLoot_Data["BDNefarian"] = {
		["Normal"] = {
			{
				{ 1, 59457, "", "=q4=Shadow of Dread", "=ds=#s4#", ""};
				{ 2, 59337, "", "=q4=Mantle of Nefarius", "=ds=#s3#, #a1#", ""};
				{ 3, 59454, "", "=q4=Shadowblaze Robes", "=ds=#s5#, #a1#", ""};
				{ 4, 59321, "", "=q4=Belt of the Nightmare", "=ds=#s10#, #a2#", ""};
				{ 5, 59222, "", "=q4=Spaulders of the Scarred Lady", "=ds=#s3#, #a3#", ""};
				{ 6, 59356, "", "=q4=Pauldrons of the Apocalypse", "=ds=#s3#, #a4#", ""};
				{ 7, 59450, "", "=q4=Belt of the Blackhand", "=ds=#s10#, #a4#", ""};
				{ 9, 59442, "", "=q4=Rage of Ages", "=ds=#s2#", ""};
				{ 10, 59441, "", "=q4=Prestor's Talisman of Machination", "=ds=#s14#", ""};
				{ 16, 63683, "", "=q4=Helm of the Forlorn Conqueror", "=ds=#e15#, #m37#"};
				{ 17, 63684, "", "=q4=Helm of the Forlorn Protector", "=ds=#e15#, #m37#"};
				{ 18, 63682, "", "=q4=Helm of the Forlorn Vanquisher", "=ds=#e15#, #m37#"};
				{ 20, 59443, "", "=q4=Crul'korak, the Lightning's Arc", "=ds=#h1#, #w1#", ""};
				{ 21, 63679, "", "=q4=Reclaimed Ashkandi, Greatsword of the Brotherhood", "=ds=#h2#, #w10#", ""};
				{ 22, 59459, "", "=q4=Andoros, Fist of the Dragon King", "=ds=#h3#, #w6#", ""};
				{ 23, 59444, "", "=q4=Akmin-Kurai, Dominion's Shield", "=ds=#w8#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65018, "", "=q4=Shadow of Dread", "=ds=#s4#", ""};
				{ 2, 65043, "", "=q4=Mantle of Nefarius", "=ds=#s3#, #a1#", ""};
				{ 3, 65019, "", "=q4=Shadowblaze Robes", "=ds=#s5#, #a1#", ""};
				{ 4, 65057, "", "=q4=Belt of the Nightmare", "=ds=#s10#, #a2#", ""};
				{ 5, 65074, "", "=q4=Spaulders of the Scarred Lady", "=ds=#s3#, #a3#", ""};
				{ 6, 65027, "", "=q4=Pauldrons of the Apocalypse", "=ds=#s3#, #a4#", ""};
				{ 7, 65022, "", "=q4=Belt of the Blackhand", "=ds=#s10#, #a4#", ""};
				{ 9, 65025, "", "=q4=Rage of Ages", "=ds=#s2#", ""};
				{ 10, 65026, "", "=q4=Prestor's Talisman of Machination", "=ds=#s14#", ""};
				{ 16, 65001, "", "=q4=Crown of the Forlorn Conqueror", "=ds=#e15#, #m37# - #j4#"};
				{ 17, 65000, "", "=q4=Crown of the Forlorn Protector", "=ds=#e15#, #m37# - #j4#"};
				{ 18, 65002, "", "=q4=Crown of the Forlorn Vanquisher", "=ds=#e15#, #m37# - #j4#"};
				{ 20, 65024, "", "=q4=Crul'korak, the Lightning's Arc", "=ds=#h1#, #w1#", ""};
				{ 21, 65003, "", "=q4=Reclaimed Ashkandi, Greatsword of the Brotherhood", "=ds=#h2#, #w10#", ""};
				{ 22, 65017, "", "=q4=Andoros, Fist of the Dragon King", "=ds=#h3#, #w6#", ""};
				{ 23, 65023, "", "=q4=Akmin-Kurai, Dominion's Shield", "=ds=#w8#", ""};
			};
		};
		info = {
			name = BabbleBoss["Nefarian"],
			module = moduleName, instance = "BlackwingDescent",
		};
	};

	AtlasLoot_Data["BDTrash"] = {
		["Normal"] = {
			{
				{ 1, 59466, "", "=q4=Ironstar's Impenetrable Cover", "=ds=#s4#", ""};
				{ 2, 59468, "", "=q4=Shadowforge's Lightbound Smock", "=ds=#s5#, #a1#", ""};
				{ 3, 59467, "", "=q4=Hide of Chromaggus", "=ds=#s3#, #a2#", ""};
				{ 4, 59465, "", "=q4=Corehammer's Riveted Girdle", "=ds=#s10#, #a4#", ""};
				{ 5, 59464, "", "=q4=Treads of Savage Beatings", "=ds=#s12#, #a4#", ""};
				{ 7, 59461, "", "=q4=Fury of Angerforge", "=ds=#s14#", ""};
				{ 16, 59462, "", "=q4=Maimgor's Bite", "=ds=#h4#, #w1#", ""};
				{ 17, 59463, "", "=q4=Maldo's Sword Cane", "=ds=#h3#, #w10#", ""};
				{ 18, 63537, "", "=q4=Claws of Torment", "=ds=#h3#, #w13#", ""};
				{ 19, 63538, "", "=q4=Claws of Agony", "=ds=#h4#, #w13#", ""};
				{ 20, 68601, "", "=q4=Scaleslicer", "=ds=#h1#, #w4#", ""};
				{ 21, 59460, "", "=q4=Theresa's Booklight", "=ds=#w12#", ""};
			};
		};
		--[[ Commented out, as the heroic trash mobs drop normal loot
		["Heroic"] = {
			{
				{ 1, 65010, "", "=q4=Ironstar's Impenetrable Cover", "=ds=#s4#", ""};
				{ 2, 65008, "", "=q4=Shadowforge's Lightbound Smock", "=ds=#s5#, #a1#", ""};
				{ 3, 65009, "", "=q4=Hide of Chromaggus", "=ds=#s3#, #a2#", ""};
				{ 4, 65011, "", "=q4=Corehammer's Riveted Girdle", "=ds=#s10#, #a4#", ""};
				{ 5, 65012, "", "=q4=Treads of Savage Beatings", "=ds=#s12#, #a4#", ""};
				{ 16, 65014, "", "=q4=Maimgor's Bite", "=ds=#h4#, #w1#", ""};
				{ 17, 65013, "", "=q4=Maldo's Sword Cane", "=ds=#h3#, #w10#", ""};
				{ 18, 65006, "", "=q4=Claws of Torment", "=ds=#h3#, #w13#", ""};
				{ 19, 65005, "", "=q4=Claws of Agony", "=ds=#h4#, #w13#", ""};
				{ 20, 65016, "", "=q4=Theresa's Booklight", "=ds=#w12#", ""};
			};
		};
		]]--
		info = {
			name = "trash",
			module = moduleName, instance = "BlackwingDescent",
		};
	};

		---------------------
		--- Baradin Hold ----
		---------------------

	AtlasLoot_Data["Argaloth"] = {
		["Normal"] = {
			{
				{ 2, "PVP85SET", "INV_Boots_01", "=ds="..AL["PvP Armor Sets"], "=q5=#s9#, #s11#"};
				{ 3, "PVP85NonSet", "inv_bracer_mail_pvphunter_c_01", "=ds="..AL["PvP Non-Set Epics"], "=q5="..AL["Level 85"]};
				{ 4, "PVP85Trinkets", "inv_misc_token_argentdawn3", "=ds="..AL["PvP Trinkets"], "=q5="..AL["Level 85"]};
				{ 17, "T11SET", "inv_chest_plate_26", "=q6="..AL["Tier 11 Set"], "=q5=#s9#, #s11#"};
			};
		};
		info = {
			name = BabbleBoss["Argaloth"],
			module = moduleName, instance = "BaradinHold",
		};
	};

		---------------------------------
		--- Throne of the Four Winds ----
		---------------------------------

	AtlasLoot_Data["TFWConclave"] = {
		["Normal"] = {
			{
				{ 1, 63498, "", "=q4=Soul Breath Belt", "=ds=#s10#, #a1#", ""};
				{ 2, 63497, "", "=q4=Gale Rouser Belt", "=ds=#s10#, #a2#", ""};
				{ 3, 63493, "", "=q4=Wind Stalker Belt", "=ds=#s10#, #a2#", ""};
				{ 4, 63496, "", "=q4=Lightning Well Belt", "=ds=#s10#, #a3#", ""};
				{ 5, 63492, "", "=q4=Star Chaser Belt", "=ds=#s10#, #a3#", ""};
				{ 6, 63490, "", "=q4=Sky Strider Belt", "=ds=#s10#, #a4#", ""};
				{ 7, 63495, "", "=q4=Tempest Keeper Belt", "=ds=#s10#, #a4#", ""};
				{ 8, 63491, "", "=q4=Thunder Wall Belt", "=ds=#s10#, #a4#", ""};
				{ 16, 63488, "", "=q4=Mistral Circle", "=ds=#s13#", ""};
				{ 17, 63489, "", "=q4=Permafrost Signet", "=ds=#s13#", ""};
				{ 18, 63494, "", "=q4=Planetary Band", "=ds=#s13#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65376, "", "=q4=Soul Breath Belt", "=ds=#s10#, #a1#", ""};
				{ 2, 65374, "", "=q4=Gale Rouser Belt", "=ds=#s10#, #a2#", ""};
				{ 3, 65371, "", "=q4=Wind Stalker Belt", "=ds=#s10#, #a2#", ""};
				{ 4, 65377, "", "=q4=Lightning Well Belt", "=ds=#s10#, #a3#", ""};
				{ 5, 65368, "", "=q4=Star Chaser Belt", "=ds=#s10#, #a3#", ""};
				{ 6, 65369, "", "=q4=Sky Strider Belt", "=ds=#s10#, #a4#", ""};
				{ 7, 65375, "", "=q4=Tempest Keeper Belt", "=ds=#s10#, #a4#", ""};
				{ 8, 65370, "", "=q4=Thunder Wall Belt", "=ds=#s10#, #a4#", ""};
				{ 16, 65367, "", "=q4=Mistral Circle", "=ds=#s13#", ""};
				{ 17, 65372, "", "=q4=Permafrost Signet", "=ds=#s13#", ""};
				{ 18, 65373, "", "=q4=Planetary Band", "=ds=#s13#", ""};
			};
		};
		info = {
			name = BabbleBoss["Conclave of Wind"],
			module = moduleName, instance = "ThroneOfTheFourWinds",
		};
	};

	AtlasLoot_Data["TFWAlAkir"] = {
		["Normal"] = {
			{
				{ 1, 63507, "", "=q4=Soul Breath Leggings", "=ds=#s11#, #a1#", ""};
				{ 2, 63506, "", "=q4=Gale Rouser Leggings", "=ds=#s11#, #a2#", ""};
				{ 3, 63503, "", "=q4=Wind Stalker Leggings", "=ds=#s11#, #a2#", ""};
				{ 4, 63505, "", "=q4=Lightning Well Legguards", "=ds=#s11#, #a3#", ""};
				{ 5, 63502, "", "=q4=Star Chaser Legguards", "=ds=#s11#, #a3#", ""};
				{ 6, 63500, "", "=q4=Sky Strider Greaves", "=ds=#s11#, #a4#", ""};
				{ 7, 63504, "", "=q4=Tempest Keeper Leggings", "=ds=#s11#, #a4#", ""};
				{ 8, 63501, "", "=q4=Thunder Wall Greaves", "=ds=#s11#, #a4#", ""};
				{ 10, 63499, "", "=q4=Cloudburst Ring", "=ds=#s13#", ""};
				{ 16, 68127, "", "=q4=Stormwake, the Tempest's Reach", "=ds=#h3#, #w10#", ""};
				{ 17, 68128, "", "=q4=Stormwake, the Tempest's Reach", "=ds=#h3#, #w10#", ""};
				{ 19, 63041, "", "=q4=Reins of the Drake of the South Wind", "=ds=#e27#", ""};
			};
		};
		["Heroic"] = {
			{
				{ 1, 65383, "", "=q4=Soul Breath Leggings", "=ds=#s11#, #a1#", ""};
				{ 2, 65384, "", "=q4=Gale Rouser Leggings", "=ds=#s11#, #a2#", ""};
				{ 3, 65381, "", "=q4=Wind Stalker Leggings", "=ds=#s11#, #a2#", ""};
				{ 4, 65386, "", "=q4=Lightning Well Legguards", "=ds=#s11#, #a3#", ""};
				{ 5, 65378, "", "=q4=Star Chaser Legguards", "=ds=#s11#, #a3#", ""};
				{ 6, 65379, "", "=q4=Sky Strider Greaves", "=ds=#s11#, #a4#", ""};
				{ 7, 65385, "", "=q4=Tempest Keeper Leggings", "=ds=#s11#, #a4#", ""};
				{ 8, 65380, "", "=q4=Thunder Wall Greaves", "=ds=#s11#, #a4#", ""};
				{ 10, 65382, "", "=q4=Cloudburst Ring", "=ds=#s13#", ""};
				{ 16, 66998, "", "=q4=Essence of the Forlorn", "=ds=#e15#, #m37#"};
				{ 18, 68132, "", "=q4=Stormwake, the Tempest's Reach", "=ds=#h3#, #w10#", ""};
				{ 19, 68131, "", "=q4=Stormwake, the Tempest's Reach", "=ds=#h3#, #w10#", ""};
				{ 21, 63041, "", "=q4=Reins of the Drake of the South Wind", "=ds=#e27#", ""};
			};
		};
		info = {
			name = BabbleBoss["Al'Akir"],
			module = moduleName, instance = "ThroneOfTheFourWinds",
		};
	};

	----------------
	--- Factions ---
	----------------

		-------------------------
		--- Baradin's Wardens ---
		-------------------------

	AtlasLoot_Data["BaradinsWardens"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_baradinwardens", "=q6=#r1#", ""};
				{ 2, 68774, "", "=q4=Greater Inscription of Vicious Agility", "=ds=#s1# #e17#", "80 #tolbarad#"};
				{ 3, 68772, "", "=q4=Greater Inscription of Vicious Intellect", "=ds=#s1# #e17#", "80 #tolbarad#"};
				{ 4, 68773, "", "=q4=Greater Inscription of Vicious Strength", "=ds=#s1# #e17#", "80 #tolbarad#"};
				{ 5, 68769, "", "=q3=Arcanum of Vicious Agility", "=ds=#s3# #e17#", "40 #tolbarad#"};
				{ 6, 68770, "", "=q3=Arcanum of Vicious Intellect", "=ds=#s3# #e17#", "40 #tolbarad#"};
				{ 7, 68768, "", "=q3=Arcanum of Vicious Strength", "=ds=#s3# #e17#", "40 #tolbarad#"};
				{ 9, 0, "inv_misc_tabard_baradinwardens", "=q6=#r2#", ""};
				{ 10, 63517, "", "=q2=Baradin's Wardens Commendation", "=ds=", "10 #tolbarad#"};
				{ 11, 63391, "", "=q1=Baradin's Wardens Bandage", "=ds=#e5#", "5 #tolbarad#"};
				{ 12, 63144, "", "=q1=Baradin's Wardens Healing Potion", "=ds=#e2#", "2 #tolbarad#"};
				{ 13, 63145, "", "=q1=Baradin's Wardens Mana Potion", "=ds=#e2#", "2 #tolbarad#"};
				{ 16, 0, "inv_misc_tabard_baradinwardens", "=q6=#r3#", ""};
				{ 17, 63379, "", "=q3=Baradin's Wardens Tabard", "=ds=#s7#", "40 #tolbarad#"};
				{ 18, 65175, "", "=q3=Baradin Footman's Tags", "=ds=#s14#", "40 #tolbarad#"};
				{ 19, 63355, "", "=q3=Rustberg Gull", "=ds=#e13#", "50 #tolbarad#"};
				{ 20, 63141, "", "=q3=Tol Barad Searchlight", "=ds=", "40 #tolbarad#"};
			};
			{
				{ 1, 0, "inv_misc_tabard_baradinwardens", "=q6=#r4#", ""};
				{ 2, 62475, "", "=q3=Dagger of Restless Nights", "=ds=#h1#, #w4#", "85 #tolbarad#"};
				{ 3, 62473, "", "=q3=Blade of the Fearless", "=ds=#h2#, #w10#", "85 #tolbarad#"};
				{ 4, 62476, "", "=q3=Ravening Slicer", "=ds=#h1#, #w1#", "85 #tolbarad#"};
				{ 5, 68739, "", "=q3=Darkheart Hacker", "=ds=#h1#, #w1#", "85 #tolbarad#"};
				{ 6, 62478, "", "=q3=Shimmering Morningstar", "=ds=#h3#, #w6#", "85 #tolbarad#"};
				{ 7, 62474, "", "=q3=Spear of Trailing Shadows", "=ds=#w7#", "85 #tolbarad#"};
				{ 8, 62477, "", "=q3=Insidious Staff", "=ds=#w9#", "85 #tolbarad#"};
				{ 9, 62479, "", "=q3=Sky Piercer", "=ds=#w3#", "85 #tolbarad#"};
				{ 10, 63377, "", "=q3=Baradin's Wardens Battle Standard", "=ds=#e14#", "50 #tolbarad#"};
				{ 16, 0, "inv_misc_tabard_baradinwardens", "=q6=#r5#", ""};
				{ 17, 62469, "", "=q4=Impatience of Youth", "=ds=#s14#", "125 #tolbarad#"};
				{ 18, 62472, "", "=q4=Mandala of Stirring Patterns", "=ds=#s14#", "125 #tolbarad#"};
				{ 19, 62471, "", "=q4=Mirror of Broken Images", "=ds=#s14#", "125 #tolbarad#"};
				{ 20, 62470, "", "=q4=Stump of Time", "=ds=#s14#", "125 #tolbarad#"};
				{ 21, 62468, "", "=q4=Unsolvable Riddle", "=ds=#s14#", "125 #tolbarad#"};
				{ 22, 64998, "", "=q4=Reins of the Spectral Steed", "=ds=#e12#", "165 #tolbarad#"};
				{ 23, 63039, "", "=q4=Reins of the Drake of the West Wind", "=ds=#e27#", "200 #tolbarad#"};
			};
		};
		info = {
			name = BabbleFaction["Baradin's Wardens"],
			module = moduleName, menu = "REPMENU",
		};
	}

		----------------------
		--- Dragonmaw Clan ---
		----------------------

	AtlasLoot_Data["DragonmawClan"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_dragonmawclan", "=q6=#r2#", ""};
				{ 2, 65909, "", "=q1=Tabard of the Dragonmaw Clan", "=ds=#s7#"};
				{ 4, 0, "inv_misc_tabard_dragonmawclan", "=q6=#r3#", ""};
				{ 5, 62406, "", "=q3=Bone Fever Gloves", "=ds=#s9#, #a1#"};
				{ 6, 62404, "", "=q3=Spaulders of the Endless Plains", "=ds=#s3#, #a2#"};
				{ 7, 62405, "", "=q3=Leggings of the Impenitent", "=ds=#s11#, #a2#"};
				{ 8, 62407, "", "=q3=Helm of the Brown Lands", "=ds=#s1#, #a3#"};
				{ 10, 0, "inv_misc_tabard_dragonmawclan", "=q6=#r4#", ""};
				{ 11, 62409, "", "=q3=Snarling Helm", "=ds=#s1#, #a3#"};	
				{ 12, 62410, "", "=q3=Grinning Fang Helm", "=ds=#s1#, #a4#"};
				{ 13, 62408, "", "=q3=Gauntlets of Rattling Bones", "=ds=#s9#, #a4#"};
				{ 14, 62415, "", "=q3=Band of Lamentation", "=ds=#s13#"};
				{ 15, 62368, "", "=q7=Arcanum of the Dragonmaw", "=ds=#s1# #e17#", ""};
				{ 16, 0, "inv_misc_tabard_dragonmawclan", "=q6=#r5#", ""};
				{ 17, 62417, "", "=q4=Liar's Handwraps", "=ds=#s9#, #a2#"};
				{ 18, 62420, "", "=q4=Withered Dream Belt", "=ds=#s10#, #a2#"};
				{ 19, 62418, "", "=q4=Boots of Sullen Rock", "=ds=#s12#, #a4#"};
				{ 20, 62416, "", "=q4=Yellow Smoke Pendant", "=ds=#s2#"};
			};
		};
		info = {
			name = BabbleFaction["Dragonmaw Clan"],
			module = moduleName, menu = "REPMENU",
		};
	}

		--------------------------
		--- Hellscream's Reach ---
		--------------------------

	AtlasLoot_Data["HellscreamsReach"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_hellscream", "=q6=#r2#", ""};
				{ 2, 63518, "", "=q2=Hellscream's Reach Commendation", "=ds=", "10 #tolbarad#"};
				{ 3, 64995, "", "=q1=Hellscream's Reach Bandage", "=ds=#e5#", "5 #tolbarad#"};
				{ 4, 64994, "", "=q1=Hellscream's Reach Healing Potion", "=ds=#e2#", "2 #tolbarad#"};
				{ 5, 64993, "", "=q1=Hellscream's Reach Mana Potion", "=ds=#e2#", "2 #tolbarad#"};
				{ 7, 0, "inv_misc_tabard_hellscream", "=q6=#r3#", ""};
				{ 8, 63378, "", "=q3=Hellscream's Reach Tabard", "=ds=#s7#", "40 #tolbarad#"};
				{ 9, 65176, "", "=q3=Baradin Grunt's Talisman", "=ds=#s14#", "40 #tolbarad#"};
				{ 10, 64996, "", "=q3=Rustberg Gull", "=ds=#e13#", "50 #tolbarad#"};
				{ 11, 64997, "", "=q3=Tol Barad Searchlight", "=ds=", "40 #tolbarad#"};
				{ 16, 0, "inv_misc_tabard_hellscream", "=q6=#r4#", ""};
				{ 17, 62456, "", "=q3=Dagger of Restless Nights", "=ds=#h1#, #w4#", "85 #tolbarad#"};
				{ 18, 62454, "", "=q3=Blade of the Fearless", "=ds=#h2#, #w10#", "85 #tolbarad#"};
				{ 19, 62457, "", "=q3=Ravening Slicer", "=ds=#h1#, #w1#", "85 #tolbarad#"};
				{ 20, 68740, "", "=q3=Darkheart Hacker", "=ds=#h1#, #w1#", "85 #tolbarad#"};
				{ 21, 62459, "", "=q3=Shimmering Morningstar", "=ds=#h3#, #w6#", "85 #tolbarad#"};
				{ 22, 62455, "", "=q3=Spear of Trailing Shadows", "=ds=#w7#", "85 #tolbarad#"};
				{ 23, 62458, "", "=q3=Insidious Staff", "=ds=#w9#", "85 #tolbarad#"};
				{ 24, 62460, "", "=q3=Sky Piercer", "=ds=#w3#", "85 #tolbarad#"};
				{ 25, 63376, "", "=q3=Hellscream's Reach Battle Standard", "=ds=#e14#", "50 #tolbarad#"};
			};
			{
				{ 1, 0, "inv_misc_tabard_hellscream", "=q6=#r5#", ""};
				{ 2, 62464, "", "=q4=Impatience of Youth", "=ds=#s14#", "125 #tolbarad#"};
				{ 3, 62467, "", "=q4=Mandala of Stirring Patterns", "=ds=#s14#", "125 #tolbarad#"};
				{ 4, 62466, "", "=q4=Mirror of Broken Images", "=ds=#s14#", "125 #tolbarad#"};
				{ 5, 62465, "", "=q4=Stump of Time", "=ds=#s14#", "125 #tolbarad#"};
				{ 6, 62463, "", "=q4=Unsolvable Riddle", "=ds=#s14#", "125 #tolbarad#"};
				{ 7, 64999, "", "=q4=Reins of the Spectral Wolf", "=ds=#e12#", "165 #tolbarad#"};
				{ 8, 65356, "", "=q4=Reins of the Drake of the West Wind", "=ds=#e27#", "200 #tolbarad#"};
			};
		};
		info = {
			name = BabbleFaction["Hellscream's Reach"],
			module = moduleName, menu = "REPMENU",
		};
	}

		----------------
		--- Ramkahen ---
		----------------

	AtlasLoot_Data["Ramkahen"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_tolvir", "=q6=#r2#", ""};
				{ 2, 65904, "", "=q1=Tabard of Ramkahen", "=ds=#s7#"};
				{ 4, 0, "inv_misc_tabard_tolvir", "=q6=#r3#", ""};
				{ 5, 62437, "", "=q3=Shroud of the Dead", "=ds=#s4#", ""};
				{ 6, 62439, "", "=q3=Belt of the Stargazer", "=ds=#s10#, #a3#", ""};
				{ 7, 62438, "", "=q3=Drystone Greaves", "=ds=#s12#, #a4#", ""};
				{ 8, 62436, "", "=q3=Ammunae's Blessing", "=ds=#s13#", ""};
				{ 10, 0, "inv_misc_tabard_tolvir", "=q6=#r4#", ""};
				{ 11, 62441, "", "=q3=Robes of Orsis", "=ds=#s5#, #a1#", ""};
				{ 12, 62446, "", "=q3=Quicksand Belt", "=ds=#s10#, #a2#", ""};
				{ 13, 62445, "", "=q3=Sash of Prophecy", "=ds=#s10#, #a3#", ""};
				{ 14, 62440, "", "=q3=Red Rock Band", "=ds=#s13#", ""};
				{ 15, 62369, "", "=q7=Arcanum of the Ramkahen", "=ds=#s1# #e17#", ""};
				{ 16, 0, "inv_misc_tabard_tolvir", "=q6=#r5#", ""};
				{ 17, 62450, "", "=q4=Desert Walker Sandals", "=ds=#s12#, #a1#", ""};
				{ 18, 62449, "", "=q4=Sandguard Bracers", "=ds=#s8#, #a4#", ""};
				{ 19, 62448, "", "=q4=Sun King's Girdle", "=ds=#s10#, #a4#", ""};
				{ 20, 62447, "", "=q4=Gift of Nadun", "=ds=#s2#", ""};
				{ 21, 63044, "", "=q4=Reins of the Brown Riding Camel", "=ds=#e26#", ""};
				{ 22, 63045, "", "=q4=Reins of the Tan Riding Camel", "=ds=#e26#", ""};
			};
		};
		info = {
			name = BabbleFaction["Ramkahen"],
			module = moduleName, menu = "REPMENU",
		};
	}

		------------------------
		--- The Earthen Ring ---
		------------------------

	AtlasLoot_Data["EarthenRing"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_earthenring", "=q6=#r2#", ""};
				{ 2, 65905, "", "=q1=Tabard of the Earthen Ring", "=ds=#s7#"};
				{ 4, 0, "inv_misc_tabard_earthenring", "=q6=#r3#", ""};
				{ 5, 62356, "", "=q3=Helm of Temperance", "=ds=#s1#, #a1#", ""};
				{ 6, 62353, "", "=q3=Mantle of Moss", "=ds=#s3#, #a3#", ""};
				{ 7, 62355, "", "=q3=Stone-Wrapped Greaves", "=ds=#s11#, #a4#", ""};
				{ 8, 62354, "", "=q3=Pendant of Elemental Balance", "=ds=#s2#", ""};
				{ 10, 0, "inv_misc_tabard_earthenring", "=q6=#r4#", ""};
				{ 11, 62357, "", "=q3=Cloak of Ancient Wisdom", "=ds=#s4#", ""};
				{ 12, 62361, "", "=q3=Softwind Cape", "=ds=#s4#", ""};
				{ 13, 62358, "", "=q3=Leggings of Clutching Roots", "=ds=#s11#, #a2#", ""};
				{ 14, 62359, "", "=q3=Peacemaker's Breastplate", "=ds=#s5#, #a4#", ""};
				{ 15, 62366, "", "=q7=Arcanum of the Earthen Ring", "=ds=#s1# #e17#"};
				{ 16, 0, "inv_misc_tabard_earthenring", "=q6=#r5#", ""};
				{ 17, 62364, "", "=q4=Flamebloom Gloves", "=ds=#s9#, #a1#", ""};
				{ 18, 62363, "", "=q4=Earthmender's Boots", "=ds=#s12#, #a3#", ""};
				{ 19, 62365, "", "=q4=World Keeper's Gauntlets", "=ds=#s9#, #a4#", ""};
				{ 20, 62362, "", "=q4=Signet of the Elder Council", "=ds=#s13#", ""};
			};
		};
		info = {
			name = BabbleFaction["The Earthen Ring"],
			module = moduleName, menu = "REPMENU",
		};
	}

		------------------------------
		--- The Guardians of Hyjal ---
		------------------------------

	AtlasLoot_Data["GuardiansHyjal"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_guardiansofhyjal", "=q6=#r2#", ""};
				{ 2, 65906, "", "=q1=Tabard of the Guardians of Hyjal", "=ds=#s7#"};
				{ 4, 0, "inv_misc_tabard_guardiansofhyjal", "=q6=#r3#", ""};
				{ 5, 62377, "", "=q3=Cloak of the Dryads", "=ds=#s4#"};
				{ 6, 62374, "", "=q3=Sly Fox Jerkin", "=ds=#s5#, #a2#"};
				{ 7, 62376, "", "=q3=Mountain's Mouth", "=ds=#s2#"};
				{ 8, 62375, "", "=q3=Galrond's Band", "=ds=#s13#"};
				{ 10, 0, "inv_misc_tabard_guardiansofhyjal", "=q6=#r4#", ""};
				{ 11, 62381, "", "=q3=Aessina-Blessed Gloves", "=ds=#s9#, #a2#"};
				{ 12, 62380, "", "=q3=Wilderness Legguards", "=ds=#s11#, #a3#"};
				{ 13, 62382, "", "=q3=Waywatcher's Boots", "=ds=#s12#, #a4#"};
				{ 14, 62378, "", "=q3=Acorn of the Daughter Tree", "=ds=#s2#"};
				{ 15, 62367, "", "=q7=Arcanum of Hyjal", "=ds=#s1# #e17#"};
				{ 16, 0, "inv_misc_tabard_guardiansofhyjal", "=q6=#r5#", ""};
				{ 17, 62383, "", "=q4=Wrap of the Great Turtle", "=ds=#s4#"};
				{ 18, 62386, "", "=q4=Cord of Raven Queen", "=ds=#s10#, #a1#"};
				{ 19, 62385, "", "=q4=Treads of Malorne", "=ds=#s12#, #a3#"};
				{ 20, 62384, "", "=q4=Belt of the Ferocious Wolf", "=ds=#s10#, #a4#"};
			};
		};
		info = {
			name = BabbleFaction["Guardians of Hyjal"],
			module = moduleName, menu = "REPMENU",
		};
	}

		-----------------
		--- Therazane ---
		-----------------

	AtlasLoot_Data["Therazane"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_therazane", "=q6=#r2#", ""};
				{ 2, 65907, "", "=q1=Tabard of Therazane", "=ds=#s7#"};
				{ 4, 0, "inv_misc_tabard_therazane", "=q6=#r3#", ""};
				{ 5, 62342, "", "=q3=Lesser Inscription of Charged Lodestone", "=ds=#s3# #e17#"};
				{ 6, 62344, "", "=q3=Lesser Inscription of Jagged Stone", "=ds=#s3# #e17#"};
				{ 7, 62347, "", "=q3=Lesser Inscription of Shattered Crystal", "=ds=#s3# #e17#"};
				{ 8, 62321, "", "=q3=Lesser Inscription of Unbreakable Quartz", "=ds=#s3# #e17#"};
				{ 10, 0, "inv_misc_tabard_therazane", "=q6=#r4#", ""};
				{ 11, 62352, "", "=q3=Diamant's Ring of Temperance", "=ds=#s13#", ""};
				{ 12, 62351, "", "=q3=Felsen's Ring of Resolve", "=ds=#s13#", ""};
				{ 13, 62350, "", "=q3=Gorsik's Band of Shattering", "=ds=#s13#", ""};
				{ 14, 62348, "", "=q3=Terrath's Signet of Balance", "=ds=#s13#", ""};
				{ 16, 0, "inv_misc_tabard_therazane", "=q6=#r5#", ""};
				{ 17, 62343, "", "=q4=Greater Inscription of Charged Lodestone", "=ds=#s3# #e17#"};
				{ 18, 62345, "", "=q4=Greater Inscription of Jagged Stone", "=ds=#s3# #e17#"};
				{ 19, 62346, "", "=q4=Greater Inscription of Shattered Crystal", "=ds=#s3# #e17#"};
				{ 20, 62333, "", "=q4=Greater Inscription of Unbreakable Quartz", "=ds=#s3# #e17#"};
				{ 21, 68774, "", "=q4=Greater Inscription of Vicious Agility", "=ds=#s3# #e17#"};
				{ 22, 68772, "", "=q4=Greater Inscription of Vicious Intellect", "=ds=#s3# #e17#"};
				{ 23, 68773, "", "=q4=Greater Inscription of Vicious Strength", "=ds=#s3# #e17#"};
			};
		};
		info = {
			name = BabbleFaction["Therazane"],
			module = moduleName, menu = "REPMENU",
		};
	}

		-----------------------
		--- Wildhammer Clan ---
		-----------------------

	AtlasLoot_Data["WildhammerClan"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tabard_wildhammerclan", "=q6=#r2#", ""};
				{ 2, 65908, "", "=q1=Tabard of the Wildhammer Clan", "=ds=#s7#"};
				{ 4, 0, "inv_misc_tabard_wildhammerclan", "=q6=#r3#", ""};
				{ 5, 62424, "", "=q3=Gloves of Aetherial Rumors", "=ds=#s9#, #a1#"};
				{ 6, 62426, "", "=q3=Mantle of Wild Feathers", "=ds=#s3#, #a2#"};
				{ 7, 62425, "", "=q3=Swiftflight Leggings", "=ds=#s11#, #a2#"};
				{ 8, 62423, "", "=q3=Helm of the Skyborne", "=ds=#s1#, #a3#"};
				{ 10, 0, "inv_misc_tabard_wildhammerclan", "=q6=#r4#", ""};
				{ 11, 62429, "", "=q3=Windhome Helm", "=ds=#s1#, #a3#"};	
				{ 12, 62428, "", "=q3=Crown of Wings", "=ds=#s1#, #a4#"};
				{ 13, 62430, "", "=q3=Gryphon Talon Gauntlets", "=ds=#s9#, #a4#"};
				{ 14, 62427, "", "=q3=Band of Singing Grass", "=ds=#s13#"};
				{ 15, 62422, "", "=q7=Arcanum of the Wildhammer", "=ds=#s1# #e17#", ""};
				{ 16, 0, "inv_misc_tabard_wildhammerclan", "=q6=#r5#", ""};
				{ 17, 62433, "", "=q4=Stormbolt Gloves", "=ds=#s9#, #a2#"};
				{ 18, 62431, "", "=q4=Belt of the Untamed", "=ds=#s10#, #a2#"};
				{ 19, 62432, "", "=q4=Gryphon Rider's Boots", "=ds=#s12#, #a4#"};
				{ 20, 62434, "", "=q4=Lightning Flash Pendant", "=ds=#s2#"};
			};
		};
		info = {
			name = BabbleFaction["Wildhammer Clan"],
			module = moduleName, menu = "REPMENU",
		};
	}

	-----------
	--- PvP ---
	-----------

		----------------------
		--- PvP Armor Sets ---
		----------------------

	AtlasLoot_Data["PVP85DeathKnight"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_deathknight_classicon", "=q6=#arenas10#", ""};
				{ 2, 60410, "", "=q4=Vicious Gladiator's Dreadplate Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60412, "", "=q4=Vicious Gladiator's Dreadplate Shoulders", "=ds=", "1650 #conquest#"};
				{ 4, 60408, "", "=q4=Vicious Gladiator's Dreadplate Chestpiece", "=ds=", "2200 #conquest#"};
				{ 5, 60409, "", "=q4=Vicious Gladiator's Dreadplate Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60411, "", "=q4=Vicious Gladiator's Dreadplate Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_deathknight_classicon", "=q6=#arenas10#", ""};
				{ 9, 64737, "", "=q3=Bloodthirsty Gladiator's Dreadplate Helm", "=ds=", "2200 #honor#"};
				{ 10, 64739, "", "=q3=Bloodthirsty Gladiator's Dreadplate Shoulders", "=ds=", "1650 #honor#"};
				{ 11, 64735, "", "=q3=Bloodthirsty Gladiator's Dreadplate Chestpiece", "=ds=", "2200 #honor#"};
				{ 12, 64736, "", "=q3=Bloodthirsty Gladiator's Dreadplate Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64738, "", "=q3=Bloodthirsty Gladiator's Dreadplate Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85DruidBalance"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_starfall", "=q6=#arenas1_2#", ""};
				{ 2, 60454, "", "=q4=Vicious Gladiator's Wyrmhide Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60457, "", "=q4=Vicious Gladiator's Wyrmhide Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60456, "", "=q4=Vicious Gladiator's Wyrmhide Robes", "=ds=", "2200 #conquest#"};
				{ 5, 60453, "", "=q4=Vicious Gladiator's Wyrmhide Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60455, "", "=q4=Vicious Gladiator's Wyrmhide Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_nature_starfall", "=q6=#arenas1_2#", ""};
				{ 9, 64875, "", "=q3=Bloodthirsty Gladiator's Wyrmhide Helm", "=ds=", "2200 #honor#"};
				{ 10, 64878, "", "=q3=Bloodthirsty Gladiator's Wyrmhide Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64877, "", "=q3=Bloodthirsty Gladiator's Wyrmhide Robes", "=ds=", "2200 #honor#"};
				{ 12, 64874, "", "=q3=Bloodthirsty Gladiator's Wyrmhide Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64876, "", "=q3=Bloodthirsty Gladiator's Wyrmhide Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DRUID"].." - "..AL["Balance"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85DruidFeral"] = {
		["Normal"] = {
			{
				{ 1, 0, "ability_racial_bearform", "=q6=#arenas1_1#", ""};
				{ 2, 60444, "", "=q4=Vicious Gladiator's Dragonhide Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60447, "", "=q4=Vicious Gladiator's Dragonhide Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60446, "", "=q4=Vicious Gladiator's Dragonhide Robes", "=ds=", "2200 #conquest#"};
				{ 5, 60443, "", "=q4=Vicious Gladiator's Dragonhide Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60445, "", "=q4=Vicious Gladiator's Dragonhide Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "ability_racial_bearform", "=q6=#arenas1_1#", ""};
				{ 9, 64728, "", "=q3=Bloodthirsty Gladiator's Dragonhide Helm", "=ds=", "2200 #honor#"};
				{ 10, 64731, "", "=q3=Bloodthirsty Gladiator's Dragonhide Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64730, "", "=q3=Bloodthirsty Gladiator's Dragonhide Robes", "=ds=", "2200 #honor#"};
				{ 12, 64727, "", "=q3=Bloodthirsty Gladiator's Dragonhide Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64729, "", "=q3=Bloodthirsty Gladiator's Dragonhide Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DRUID"].." - "..AL["Feral"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85DruidRestoration"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_healingtouch", "=q6=#arenas1_3#", ""};
				{ 2, 60449, "", "=q4=Vicious Gladiator's Kodohide Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60452, "", "=q4=Vicious Gladiator's Kodohide Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60451, "", "=q4=Vicious Gladiator's Kodohide Robes", "=ds=", "2200 #conquest#"};
				{ 5, 60448, "", "=q4=Vicious Gladiator's Kodohide Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60450, "", "=q4=Vicious Gladiator's Kodohide Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_nature_healingtouch", "=q6=#arenas1_3#", ""};
				{ 9, 64765, "", "=q3=Bloodthirsty Gladiator's Kodohide Helm", "=ds=", "2200 #honor#"};
				{ 10, 64768, "", "=q3=Bloodthirsty Gladiator's Kodohide Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64767, "", "=q3=Bloodthirsty Gladiator's Kodohide Robes", "=ds=", "2200 #honor#"};
				{ 12, 64764, "", "=q3=Bloodthirsty Gladiator's Kodohide Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64766, "", "=q3=Bloodthirsty Gladiator's Kodohide Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DRUID"].." - "..AL["Restoration"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85Hunter"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_weapon_bow_07", "=q6=#arenas2#", ""};
				{ 2, 60425, "", "=q4=Vicious Gladiator's Chain Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60427, "", "=q4=Vicious Gladiator's Chain Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60423, "", "=q4=Vicious Gladiator's Chain Armor", "=ds=", "2200 #conquest#"};
				{ 5, 60424, "", "=q4=Vicious Gladiator's Chain Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60426, "", "=q4=Vicious Gladiator's Chain Leggings", "=ds=", "2200 #conquest#"};
				{ 8, 0, "inv_weapon_bow_07", "=q6=#arenas2#", ""};
				{ 9, 64710, "", "=q3=Bloodthirsty Gladiator's Chain Helm", "=ds=", "2200 #honor#"};
				{ 10, 64712, "", "=q3=Bloodthirsty Gladiator's Chain Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64708, "", "=q3=Bloodthirsty Gladiator's Chain Armor", "=ds=", "2200 #honor#"};
				{ 12, 64709, "", "=q3=Bloodthirsty Gladiator's Chain Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64711, "", "=q3=Bloodthirsty Gladiator's Chain Leggings", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["HUNTER"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85Mage"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_staff_13", "=q6=#arenas3#", ""};
				{ 2, 60464, "", "=q4=Vicious Gladiator's Silk Cowl", "=ds=", "2200 #conquest#"};
				{ 3, 60467, "", "=q4=Vicious Gladiator's Silk Amice", "=ds=", "1650 #conquest#"};
				{ 4, 60466, "", "=q4=Vicious Gladiator's Silk Robe", "=ds=", "2200 #conquest#"};
				{ 5, 60463, "", "=q4=Vicious Gladiator's Silk Handguards", "=ds=", "1650 #conquest#"};
				{ 6, 60465, "", "=q4=Vicious Gladiator's Silk Trousers", "=ds=", "2200 #conquest#"};
				{ 8, 0, "inv_staff_13", "=q6=#arenas3#", ""};
				{ 9, 64854, "", "=q3=Bloodthirsty Gladiator's Silk Cowl", "=ds=", "2200 #honor#"};
				{ 10, 64853, "", "=q3=Bloodthirsty Gladiator's Silk Amice", "=ds=", "1650 #honor#"};
				{ 11, 64856, "", "=q3=Bloodthirsty Gladiator's Silk Robe", "=ds=", "2200 #honor#"};
				{ 12, 64855, "", "=q3=Bloodthirsty Gladiator's Silk Handguards", "=ds=", "1650 #honor#"};
				{ 13, 64857, "", "=q3=Bloodthirsty Gladiator's Silk Trousers", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["MAGE"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85PaladinRetribution"] = {
		["Normal"] = {
			{
				{ 1, 0, "Spell_Holy_AuraOfLight", "=q6=#arenas4_2#", ""};
				{ 2, 60415, "", "=q4=Vicious Gladiator's Scaled Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60417, "", "=q4=Vicious Gladiator's Scaled Shoulders", "=ds=", "1650 #conquest#"};
				{ 4, 60413, "", "=q4=Vicious Gladiator's Scaled Chestpiece", "=ds=", "2200 #conquest#"};
				{ 5, 60414, "", "=q4=Vicious Gladiator's Scaled Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60416, "", "=q4=Vicious Gladiator's Scaled Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "Spell_Holy_AuraOfLight", "=q6=#arenas4_2#", ""};
				{ 9, 64845, "", "=q3=Bloodthirsty Gladiator's Scaled Helm", "=ds=", "2200 #honor#"};
				{ 10, 64847, "", "=q3=Bloodthirsty Gladiator's Scaled Shoulders", "=ds=", "1650 #honor#"};
				{ 11, 64843, "", "=q3=Bloodthirsty Gladiator's Scaled Chestpiece", "=ds=", "2200 #honor#"};
				{ 12, 64844, "", "=q3=Bloodthirsty Gladiator's Scaled Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64846, "", "=q3=Bloodthirsty Gladiator's Scaled Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PALADIN"].." - "..AL["Retribution"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85PaladinHoly"] = {
		["Normal"] = {
			{
				{ 1, 0, "Spell_Holy_HolyBolt", "=q6=#arenas4_3#", ""};
				{ 2, 60603, "", "=q4=Vicious Gladiator's Ornamented Headcover", "=ds=", "2200 #conquest#"};
				{ 3, 60605, "", "=q4=Vicious Gladiator's Ornamented Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 64802, "", "=q4=Vicious Gladiator's Ornamented Chestguard", "=ds=", "2200 #conquest#"};
				{ 5, 60602, "", "=q4=Vicious Gladiator's Ornamented Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60604, "", "=q4=Vicious Gladiator's Ornamented Legplates", "=ds=", "2200 #conquest#"};
				{ 8, 0, "Spell_Holy_HolyBolt", "=q6=#arenas4_2#", ""};
				{ 9, 64804, "", "=q3=Bloodthirsty Gladiator's Ornamented Headcover", "=ds=", "2200 #honor#"};
				{ 10, 64806, "", "=q3=Bloodthirsty Gladiator's Ornamented Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64843, "", "=q3=Bloodthirsty Gladiator's Ornamented Chestguard", "=ds=", "2200 #honor#"};
				{ 12, 64803, "", "=q3=Bloodthirsty Gladiator's Ornamented Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64805, "", "=q3=Bloodthirsty Gladiator's Ornamented Legplates", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PALADIN"].." - "..AL["Holy"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85PriestShadow"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_shadow_shadowwordpain", "=q6=#arenas5_1#", ""};
				{ 2, 60474, "", "=q4=Vicious Gladiator's Satin Hood", "=ds=", "2200 #conquest#"};
				{ 3, 60477, "", "=q4=Vicious Gladiator's Satin Mantle", "=ds=", "1650 #conquest#"};
				{ 4, 60473, "", "=q4=Vicious Gladiator's Satin Robe", "=ds=", "2200 #conquest#"};
				{ 5, 60476, "", "=q4=Vicious Gladiator's Satin Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60475, "", "=q4=Vicious Gladiator's Satin Leggings", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_shadow_shadowwordpain", "=q6=#arenas5_1#", ""};
				{ 9, 64839, "", "=q3=Bloodthirsty Gladiator's Satin Hood", "=ds=", "2200 #honor#"};
				{ 10, 64841, "", "=q3=Bloodthirsty Gladiator's Satin Mantle", "=ds=", "1650 #honor#"};
				{ 11, 64842, "", "=q3=Bloodthirsty Gladiator's Satin Robe", "=ds=", "2200 #honor#"};
				{ 12, 64838, "", "=q3=Bloodthirsty Gladiator's Satin Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64840, "", "=q3=Bloodthirsty Gladiator's Satin Leggings", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PRIEST"].." - "..AL["Shadow"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85PriestHoly"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_holy_powerwordshield", "=q6=#arenas5_2#", ""};
				{ 2, 60469, "", "=q4=Vicious Gladiator's Mooncloth Hood", "=ds=", "2200 #conquest#"};
				{ 3, 60472, "", "=q4=Vicious Gladiator's Mooncloth Mantle", "=ds=", "1650 #conquest#"};
				{ 4, 60471, "", "=q4=Vicious Gladiator's Mooncloth Robe", "=ds=", "2200 #conquest#"};
				{ 5, 60468, "", "=q4=Vicious Gladiator's Mooncloth Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60470, "", "=q4=Vicious Gladiator's Mooncloth Leggings", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_holy_powerwordshield", "=q6=#arenas5_2#", ""};
				{ 9, 64796, "", "=q3=Bloodthirsty Gladiator's Mooncloth Hood", "=ds=", "2200 #honor#"};
				{ 10, 64798, "", "=q3=Bloodthirsty Gladiator's Mooncloth Mantle", "=ds=", "1650 #honor#"};
				{ 11, 64799, "", "=q3=Bloodthirsty Gladiator's Mooncloth Robe", "=ds=", "2200 #honor#"};
				{ 12, 64795, "", "=q3=Bloodthirsty Gladiator's Mooncloth Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64797, "", "=q3=Bloodthirsty Gladiator's Mooncloth Leggings", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PRIEST"].." - "..AL["Holy"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85Rogue"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_throwingknife_04", "=q6=#arenas6#", ""};
				{ 2, 60460, "", "=q4=Vicious Gladiator's Leather Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60462, "", "=q4=Vicious Gladiator's Leather Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60458, "", "=q4=Vicious Gladiator's Leather Tunic", "=ds=", "2200 #conquest#"};
				{ 5, 60459, "", "=q4=Vicious Gladiator's Leather Gloves", "=ds=", "1650 #conquest#"};
				{ 6, 60461, "", "=q4=Vicious Gladiator's Leather Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "inv_throwingknife_04", "=q6=#arenas6#", ""};
				{ 9, 64770, "", "=q3=Bloodthirsty Gladiator's Leather Helm", "=ds=", "2200 #honor#"};
				{ 10, 64772, "", "=q3=Bloodthirsty Gladiator's Leather Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64773, "", "=q3=Bloodthirsty Gladiator's Leather Tunic", "=ds=", "2200 #honor#"};
				{ 12, 64769, "", "=q3=Bloodthirsty Gladiator's Leather Gloves", "=ds=", "1650 #honor#"};
				{ 13, 64771, "", "=q3=Bloodthirsty Gladiator's Leather Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["ROGUE"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85ShamanElemental"] = {
		["Normal"] = {
			{
				{ 1, 0, "Spell_Nature_Lightning", "=q6=#arenas7_2#", ""};
				{ 2, 60440, "", "=q4=Vicious Gladiator's Mail Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60442, "", "=q4=Vicious Gladiator's Mail Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60438, "", "=q4=Vicious Gladiator's Mail Armor", "=ds=", "2200 #conquest#"};
				{ 5, 60439, "", "=q4=Vicious Gladiator's Mail Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60441, "", "=q4=Vicious Gladiator's Mail Leggings", "=ds=", "2200 #conquest#"};
				{ 8, 0, "Spell_Nature_Lightning", "=q6=#arenas7_2#", ""};
				{ 9, 64786, "", "=q3=Bloodthirsty Gladiator's Mail Helm", "=ds=", "2200 #honor#"};
				{ 10, 64788, "", "=q3=Bloodthirsty Gladiator's Mail Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64784, "", "=q3=Bloodthirsty Gladiator's Mail Armor", "=ds=", "2200 #honor#"};
				{ 12, 64785, "", "=q3=Bloodthirsty Gladiator's Mail Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64787, "", "=q3=Bloodthirsty Gladiator's Mail Leggings", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"].." - "..AL["Elemental"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85ShamanEnhancement"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_lightningshield", "=q6=#arenas7_1#", ""};
				{ 2, 60435, "", "=q4=Vicious Gladiator's Linked Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60437, "", "=q4=Vicious Gladiator's Linked Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60433, "", "=q4=Vicious Gladiator's Linked Armor", "=ds=", "2200 #conquest#"};
				{ 5, 60434, "", "=q4=Vicious Gladiator's Linked Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60436, "", "=q4=Vicious Gladiator's Linked Leggings", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_nature_lightningshield", "=q6=#arenas7_1#", ""};
				{ 9, 64778, "", "=q3=Bloodthirsty Gladiator's Linked Helm", "=ds=", "2200 #honor#"};
				{ 10, 64780, "", "=q3=Bloodthirsty Gladiator's Linked Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64776, "", "=q3=Bloodthirsty Gladiator's Linked Armor", "=ds=", "2200 #honor#"};
				{ 12, 64777, "", "=q3=Bloodthirsty Gladiator's Linked Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64779, "", "=q3=Bloodthirsty Gladiator's Linked Leggings", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"].." - "..AL["Enhancement"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85ShamanRestoration"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_magicimmunity", "=q6=#arenas7_3#", ""};
				{ 2, 60430, "", "=q4=Vicious Gladiator's Ringmail Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60432, "", "=q4=Vicious Gladiator's Ringmail Spaulders", "=ds=", "1650 #conquest#"};
				{ 4, 60428, "", "=q4=Vicious Gladiator's Ringmail Armor", "=ds=", "2200 #conquest#"};
				{ 5, 60429, "", "=q4=Vicious Gladiator's Ringmail Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60431, "", "=q4=Vicious Gladiator's Ringmail Leggings", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_nature_magicimmunity", "=q6=#arenas7_3#", ""};
				{ 9, 64829, "", "=q3=Bloodthirsty Gladiator's Ringmail Helm", "=ds=", "2200 #honor#"};
				{ 10, 64831, "", "=q3=Bloodthirsty Gladiator's Ringmail Spaulders", "=ds=", "1650 #honor#"};
				{ 11, 64827, "", "=q3=Bloodthirsty Gladiator's Ringmail Armor", "=ds=", "2200 #honor#"};
				{ 12, 64828, "", "=q3=Bloodthirsty Gladiator's Ringmail Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64830, "", "=q3=Bloodthirsty Gladiator's Ringmail Leggings", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"].." - "..AL["Restoration"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85Warlock"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_drowsy", "=q6=#arenas8_2#", ""};
				{ 2, 60479, "", "=q4=Vicious Gladiator's Felweave Cowl", "=ds=", "2200 #conquest#"};
				{ 3, 60482, "", "=q4=Vicious Gladiator's Felweave Amice", "=ds=", "1650 #conquest#"};
				{ 4, 60481, "", "=q4=Vicious Gladiator's Felweave Raiment", "=ds=", "2200 #conquest#"};
				{ 5, 60478, "", "=q4=Vicious Gladiator's Felweave Handguards", "=ds=", "1650 #conquest#"};
				{ 6, 60480, "", "=q4=Vicious Gladiator's Felweave Trousers", "=ds=", "2200 #conquest#"};
				{ 8, 0, "spell_nature_drowsy", "=q6=#arenas8_2#", ""};
				{ 9, 64746, "", "=q3=Bloodthirsty Gladiator's Felweave Cowl", "=ds=", "2200 #honor#"};
				{ 10, 64745, "", "=q3=Bloodthirsty Gladiator's Felweave Amice", "=ds=", "1650 #honor#"};
				{ 11, 64748, "", "=q3=Bloodthirsty Gladiator's Felweave Raiment", "=ds=", "2200 #honor#"};
				{ 12, 64747, "", "=q3=Bloodthirsty Gladiator's Felweave Handguards", "=ds=", "1650 #honor#"};
				{ 13, 64749, "", "=q3=Bloodthirsty Gladiator's Felweave Trousers", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["WARLOCK"],
			module = moduleName, menu = "PVP85SET",
		};
	}

	AtlasLoot_Data["PVP85Warrior"] = {
		["Normal"] = {
			{
				{ 1, 0, "ability_warrior_savageblow", "=q6=#arenas9#", ""};
				{ 2, 60420, "", "=q4=Vicious Gladiator's Plate Helm", "=ds=", "2200 #conquest#"};
				{ 3, 60422, "", "=q4=Vicious Gladiator's Plate Shoulders", "=ds=", "1650 #conquest#"};
				{ 4, 60418, "", "=q4=Vicious Gladiator's Plate Chestpiece", "=ds=", "2200 #conquest#"};
				{ 5, 60419, "", "=q4=Vicious Gladiator's Plate Gauntlets", "=ds=", "1650 #conquest#"};
				{ 6, 60421, "", "=q4=Vicious Gladiator's Plate Legguards", "=ds=", "2200 #conquest#"};
				{ 8, 0, "ability_warrior_savageblow", "=q6=#arenas9#", ""};
				{ 9, 64813, "", "=q3=Bloodthirsty Gladiator's Plate Helm", "=ds=", "2200 #honor#"};
				{ 10, 64815, "", "=q3=Bloodthirsty Gladiator's Plate Shoulders", "=ds=", "1650 #honor#"};
				{ 11, 64811, "", "=q3=Bloodthirsty Gladiator's Plate Chestpiece", "=ds=", "2200 #honor#"};
				{ 12, 64812, "", "=q3=Bloodthirsty Gladiator's Plate Gauntlets", "=ds=", "1650 #honor#"};
				{ 13, 64814, "", "=q3=Bloodthirsty Gladiator's Plate Legguards", "=ds=", "2200 #honor#"};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["WARRIOR"],
			module = moduleName, menu = "PVP85SET",
		};
	}

		------------------------------
		--- Level 85 - Accessories ---
		------------------------------

	AtlasLoot_Data["PVP85Accessories"] = {
		["Normal"] = {
			{
				{ 1, 60783, "", "=q4=Vicious Gladiator's Cape of Cruelty", "=ds=#s4#", "1250 #conquest#" },
				{ 2, 60779, "", "=q4=Vicious Gladiator's Cape of Prowess", "=ds=#s4#", "1250 #conquest#" },
				{ 3, 60776, "", "=q4=Vicious Gladiator's Cloak of Alacrity", "=ds=#s4#", "1250 #conquest#" },
				{ 4, 60778, "", "=q4=Vicious Gladiator's Cloak of Prowess", "=ds=#s4#", "1250 #conquest#" },
				{ 5, 60786, "", "=q4=Vicious Gladiator's Drape of Diffusion", "=ds=#s4#", "1250 #conquest#" },
				{ 6, 60788, "", "=q4=Vicious Gladiator's Drape of Meditation", "=ds=#s4#", "1250 #conquest#" },
				{ 7, 60787, "", "=q4=Vicious Gladiator's Drape of Prowess", "=ds=#s4#", "1250 #conquest#" },
				{ 9, 60647, "", "=q4=Vicious Gladiator's Band of Accuracy", "=ds=#s13#", "1250 #conquest#"};
				{ 10, 60645, "", "=q4=Vicious Gladiator's Band of Cruelty", "=ds=#s13#", "1250 #conquest#"};
				{ 11, 60649, "", "=q4=Vicious Gladiator's Band of Dominance", "=ds=#s13#", "1250 #conquest#"};
				{ 12, 60651, "", "=q4=Vicious Gladiator's Signet of Accuracy", "=ds=#s13#", "1250 #conquest#"};
				{ 13, 60650, "", "=q4=Vicious Gladiator's Signet of Cruelty", "=ds=#s13#", "1250 #conquest#"};
				{ 14, 60658, "", "=q4=Vicious Gladiator's Ring of Accuracy", "=ds=#s13#", "1250 #conquest#"};
				{ 15, 60659, "", "=q4=Vicious Gladiator's Ring of Cruelty", "=ds=#s13#", "1250 #conquest#"};
				{ 16, 60673, "", "=q4=Vicious Gladiator's Choker of Accuracy", "=ds=#s2#", "1250 #conquest#" },
				{ 17, 60670, "", "=q4=Vicious Gladiator's Choker of Proficiency", "=ds=#s2#", "1250 #conquest#" },
				{ 18, 60669, "", "=q4=Vicious Gladiator's Necklace of Proficiency", "=ds=#s2#", "1250 #conquest#" },
				{ 19, 60668, "", "=q4=Vicious Gladiator's Necklace of Prowess", "=ds=#s2#", "1250 #conquest#" },
				{ 20, 60662, "", "=q4=Vicious Gladiator's Pendant of Alacrity", "=ds=#s2#", "1250 #conquest#" },
				{ 21, 60661, "", "=q4=Vicious Gladiator's Pendant of Diffusion", "=ds=#s2#", "1250 #conquest#" },
				{ 22, 60664, "", "=q4=Vicious Gladiator's Pendant of Meditation", "=ds=#s2#", "1250 #conquest#" },
			};
			{
				{ 1, 64706, "", "=q3=Bloodthirsty Gladiator's Cape of Cruelty", "=ds=", "1250 #honor#"};
				{ 2, 64707, "", "=q3=Bloodthirsty Gladiator's Cape of Prowess", "=ds=", "1250 #honor#"};
				{ 3, 64718, "", "=q3=Bloodthirsty Gladiator's Cloak of Alacrity", "=ds=", "1250 #honor#"};
				{ 4, 64719, "", "=q3=Bloodthirsty Gladiator's Cloak of Prowess", "=ds=", "1250 #honor#"};
				{ 5, 64732, "", "=q3=Bloodthirsty Gladiator's Drape of Diffusion", "=ds=", "1250 #honor#"};
				{ 6, 64733, "", "=q3=Bloodthirsty Gladiator's Drape of Meditation", "=ds=", "1250 #honor#"};
				{ 7, 64734, "", "=q3=Bloodthirsty Gladiator's Drape of Prowess", "=ds=", "1250 #honor#"};
				{ 9, 64690, "", "=q3=Bloodthirsty Gladiator's Band of Accuracy", "=ds=", "1250 #honor#"};
				{ 10, 64691, "", "=q3=Bloodthirsty Gladiator's Band of Cruelty", "=ds=", "1250 #honor#"};
				{ 11, 64692, "", "=q3=Bloodthirsty Gladiator's Band of Dominance", "=ds=", "1250 #honor#"};
				{ 12, 64832, "", "=q3=Bloodthirsty Gladiator's Signet of Accuracy", "=ds=", "1250 #honor#"};
				{ 13, 64833, "", "=q3=Bloodthirsty Gladiator's Signet of Cruelty", "=ds=", "1250 #honor#"};
				{ 14, 64851, "", "=q3=Bloodthirsty Gladiator's Ring of Accuracy", "=ds=", "1250 #honor#"};
				{ 15, 64852, "", "=q3=Bloodthirsty Gladiator's Ring of Cruelty", "=ds=", "1250 #honor#"};
				{ 16, 64713, "", "=q3=Bloodthirsty Gladiator's Choker of Accuracy", "=ds=#s2#", "1250 #honor#" },
				{ 17, 64714, "", "=q3=Bloodthirsty Gladiator's Choker of Proficiency", "=ds=#s2#", "1250 #honor#" },
				{ 18, 64800, "", "=q3=Bloodthirsty Gladiator's Necklace of Proficiency", "=ds=#s2#", "1250 #honor#" },
				{ 19, 64801, "", "=q3=Bloodthirsty Gladiator's Necklace of Prowess", "=ds=#s2#", "1250 #honor#" },
				{ 20, 64807, "", "=q3=Bloodthirsty Gladiator's Pendant of Alacrity", "=ds=#s2#", "1250 #honor#" },
				{ 21, 64808, "", "=q3=Bloodthirsty Gladiator's Pendant of Diffusion", "=ds=#s2#", "1250 #honor#" },
				{ 22, 64809, "", "=q3=Bloodthirsty Gladiator's Pendant of Meditation", "=ds=#s2#", "1250 #honor#" },
			};
		};
		info = {
			name = AL["PvP Accessories"],
			module = moduleName, menu = "PVPMENU",
		};
	}

		---------------------------
		--- Level 85 - Trinkets ---
		---------------------------

	AtlasLoot_Data["PVP85Trinkets"] = {
		["Normal"] = {
			{
				{ 1, 61033, "", "=q4=Vicious Gladiator's Badge of Conquest", "=ds=#s14#", "1650 #conquest#" },
				{ 2, 61035, "", "=q4=Vicious Gladiator's Badge of Dominance", "=ds=#s14#", "1650 #conquest#" },
				{ 3, 61034, "", "=q4=Vicious Gladiator's Badge of Victory", "=ds=#s14#", "1650 #conquest#" },
				{ 5, 61026, "", "=q4=Vicious Gladiator's Emblem of Cruelty", "=ds=#s14#", "1650 #conquest#" },
				{ 6, 61031, "", "=q4=Vicious Gladiator's Emblem of Meditation", "=ds=#s14#", "1650 #conquest#" },
				{ 7, 61032, "", "=q4=Vicious Gladiator's Emblem of Tenacity", "=ds=#s14#", "1650 #conquest#" },
				{
					{ 9, 60801, "", "=q4=Vicious Gladiator's Medallion of Cruelty", "=ds=#s14#", "1650 #conquest#" },
					{ 9, 60794, "", "=q4=Vicious Gladiator's Medallion of Cruelty", "=ds=#s14#", "1650 #conquest#" },
				};
				{
					{ 10, 60806, "", "=q4=Vicious Gladiator's Medallion of Meditation", "=ds=#s14#", "1650 #conquest#" },
					{ 10, 60799, "", "=q4=Vicious Gladiator's Medallion of Meditation", "=ds=#s14#", "1650 #conquest#" },
				};
				{
					{ 11, 60807, "", "=q4=Vicious Gladiator's Medallion of Tenacity", "=ds=#s14#", "1650 #conquest#" },
					{ 11, 60800, "", "=q4=Vicious Gladiator's Medallion of Tenacity", "=ds=#s14#", "1650 #conquest#" },
				};
				{ 13, 61047, "", "=q4=Vicious Gladiator's Insignia of Conquest", "=ds=#s14#", "1650 #conquest#" },
				{ 14, 61045, "", "=q4=Vicious Gladiator's Insignia of Dominance", "=ds=#s14#", "1650 #conquest#" },
				{ 15, 61046, "", "=q4=Vicious Gladiator's Insignia of Victory", "=ds=#s14#", "1650 #conquest#" },
				{ 16, 64687, "", "=q3=Bloodthirsty Gladiator's Badge of Conquest", "=ds=#s14#", "1650 #honor#" },
				{ 17, 64688, "", "=q3=Bloodthirsty Gladiator's Badge of Dominance", "=ds=#s14#", "1650 #honor#" },
				{ 18, 64689, "", "=q3=Bloodthirsty Gladiator's Badge of Victory", "=ds=#s14#", "1650 #honor#" },
				{ 20, 64740, "", "=q3=Bloodthirsty Gladiator's Emblem of Cruelty", "=ds=#s14#", "1650 #honor#" },
				{ 21, 64741, "", "=q3=Bloodthirsty Gladiator's Emblem of Meditation", "=ds=#s14#", "1650 #honor#" },
				{ 22, 64742, "", "=q3=Bloodthirsty Gladiator's Emblem of Tenacity", "=ds=#s14#", "1650 #honor#" },
				{
					{ 24, 64789, "", "=q3=Bloodthirsty Gladiator's Medallion of Cruelty", "=ds=#s14#", "1650 #honor#" },
					{ 24, 64790, "", "=q3=Bloodthirsty Gladiator's Medallion of Cruelty", "=ds=#s14#", "1650 #honor#" },
				};
				{
					{ 25, 64792, "", "=q3=Bloodthirsty Gladiator's Medallion of Meditation", "=ds=#s14#", "1650 #honor#" },
					{ 25, 64791, "", "=q3=Bloodthirsty Gladiator's Medallion of Meditation", "=ds=#s14#", "1650 #honor#" },
				};
				{
					{ 26, 64794, "", "=q3=Bloodthirsty Gladiator's Medallion of Tenacity", "=ds=#s14#", "1650 #honor#" },
					{ 26, 64793, "", "=q3=Bloodthirsty Gladiator's Medallion of Tenacity", "=ds=#s14#", "1650 #honor#" },
				};
				{ 28, 64761, "", "=q3=Bloodthirsty Gladiator's Insignia of Conquest", "=ds=#s14#", "1650 #honor#" },
				{ 29, 64762, "", "=q3=Bloodthirsty Gladiator's Insignia of Dominance", "=ds=#s14#", "1650 #honor#" },
				{ 30, 64763, "", "=q3=Bloodthirsty Gladiator's Insignia of Victory", "=ds=#s14#", "1650 #honor#" },
			};
		};
		info = {
			name = AL["PvP Trinkets"],
			module = moduleName, menu = "PVPMENU",
		};
	}

		--------------------------------
		--- Level 85 - Non Set Epics ---
		--------------------------------

	AtlasLoot_Data["PVP85NonSet"] = {
		["Normal"] = {
			{
				{ 1, 60628, "", "=q4=Vicious Gladiator's Cuffs of Accuracy", "=ds=", "1250 #conquest#"};
				{ 2, 60626, "", "=q4=Vicious Gladiator's Cord of Accuracy", "=ds=", "1650 #conquest#"};
				{ 3, 60630, "", "=q4=Vicious Gladiator's Treads of Alacrity", "=ds=", "1650 #conquest#"};
				{ 5, 60635, "", "=q4=Vicious Gladiator's Cuffs of Meditation", "=ds=", "1250 #conquest#"};
				{ 6, 60637, "", "=q4=Vicious Gladiator's Cord of Meditation", "=ds=", "1650 #conquest#"};
				{ 7, 60636, "", "=q4=Vicious Gladiator's Treads of Meditation", "=ds=", "1650 #conquest#"};
				{ 9, 60634, "", "=q4=Vicious Gladiator's Cuffs of Prowess", "=ds=", "1250 #conquest#"};
				{ 10, 60612, "", "=q4=Vicious Gladiator's Cord of Cruelty", "=ds=", "1650 #conquest#"};
				{ 11, 60613, "", "=q4=Vicious Gladiator's Treads of Cruelty", "=ds=", "1650 #conquest#"};
				{ 16, 64723, "", "=q3=Bloodthirsty Gladiator's Cuffs of Accuracy", "=ds=", "1250 #honor#"};
				{ 17, 64720, "", "=q3=Bloodthirsty Gladiator's Cord of Accuracy", "=ds=", "1650 #honor#"};
				{ 18, 64862, "", "=q3=Bloodthirsty Gladiator's Treads of Alacrity", "=ds=", "1650 #honor#"};
				{ 20, 64724, "", "=q3=Bloodthirsty Gladiator's Cuffs of Meditation", "=ds=", "1250 #honor#"};
				{ 21, 64722, "", "=q3=Bloodthirsty Gladiator's Cord of Meditation", "=ds=", "1650 #honor#"};
				{ 22, 64864, "", "=q3=Bloodthirsty Gladiator's Treads of Meditation", "=ds=", "1650 #honor#"};
				{ 24, 64725, "", "=q3=Bloodthirsty Gladiator's Cuffs of Prowess", "=ds=", "1250 #honor#"};
				{ 25, 64721, "", "=q3=Bloodthirsty Gladiator's Cord of Cruelty", "=ds=", "1650 #honor#"};
				{ 26, 64863, "", "=q3=Bloodthirsty Gladiator's Treads of Cruelty", "=ds=", "1650 #honor#"};
				extraText = ": "..BabbleInventory["Cloth"];
			};
			{
				{ 1, 60591, "", "=q4=Vicious Gladiator's Armwraps of Accuracy", "=ds=", "1250 #conquest#"};
				{ 2, 60589, "", "=q4=Vicious Gladiator's Waistband of Accuracy", "=ds=", "1650 #conquest#"};
				{ 3, 60587, "", "=q4=Vicious Gladiator's Boots of Cruelty", "=ds=", "1650 #conquest#"};
				{ 5, 60594, "", "=q4=Vicious Gladiator's Armwraps of Alacrity", "=ds=", "1650 #conquest#"};
				{ 6, 60586, "", "=q4=Vicious Gladiator's Waistband of Cruelty", "=ds=", "1650 #conquest#"};
				{ 7, 60593, "", "=q4=Vicious Gladiator's Boots of Alacrity", "=ds=", "1650 #conquest#"};
				{ 9, 60611, "", "=q4=Vicious Gladiator's Bindings of Prowess", "=ds=", "1250 #conquest#"};
				{ 10, 60583, "", "=q4=Vicious Gladiator's Belt of Cruelty", "=ds=", "1650 #conquest#"};
				{ 11, 60607, "", "=q4=Vicious Gladiator's Footguards of Alacrity", "=ds=", "1650 #conquest#"};
				{ 13, 60582, "", "=q4=Vicious Gladiator's Bindings of Meditation", "=ds=", "1250 #conquest#"};
				{ 14, 60580, "", "=q4=Vicious Gladiator's Belt of Meditation", "=ds=", "1650 #conquest#"};
				{ 15, 60581, "", "=q4=Vicious Gladiator's Footguards of Meditation", "=ds=", "1650 #conquest#"};
				{ 16, 64685, "", "=q3=Bloodthirsty Gladiator's Armwraps of Accuracy", "=ds=", "1250 #honor#"};
				{ 17, 64865, "", "=q3=Bloodthirsty Gladiator's Waistband of Accuracy", "=ds=", "1650 #honor#"};
				{ 18, 64703, "", "=q3=Bloodthirsty Gladiator's Boots of Cruelty", "=ds=", "1650 #honor#"};
				{ 20, 64686, "", "=q3=Bloodthirsty Gladiator's Armwraps of Alacrity", "=ds=", "1650 #honor#"};
				{ 21, 64866, "", "=q3=Bloodthirsty Gladiator's Waistband of Cruelty", "=ds=", "1650 #honor#"};
				{ 22, 64702, "", "=q3=Bloodthirsty Gladiator's Boots of Alacrity", "=ds=", "1650 #honor#"};
				{ 24, 64699, "", "=q3=Bloodthirsty Gladiator's Bindings of Prowess", "=ds=", "1250 #honor#"};
				{ 25, 64696, "", "=q3=Bloodthirsty Gladiator's Belt of Cruelty", "=ds=", "1650 #honor#"};
				{ 26, 64750, "", "=q3=Bloodthirsty Gladiator's Footguards of Alacrity", "=ds=", "1650 #honor#"};
				{ 28, 64698, "", "=q3=Bloodthirsty Gladiator's Bindings of Meditation", "=ds=", "1250 #honor#"};
				{ 29, 64697, "", "=q3=Bloodthirsty Gladiator's Belt of Meditation", "=ds=", "1650 #honor#"};
				{ 30, 64751, "", "=q3=Bloodthirsty Gladiator's Footguards of Meditation", "=ds=", "1650 #honor#"};
				extraText = ": "..BabbleInventory["Leather"];
			};
			{
				{ 1, 60535, "", "=q4=Vicious Gladiator's Armbands of Meditation", "=ds=", "1250 #conquest#"};
				{ 2, 60533, "", "=q4=Vicious Gladiator's Waistguard of Meditation", "=ds=", "1650 #conquest#"};
				{ 3, 60534, "", "=q4=Vicious Gladiator's Sabatons of Meditation", "=ds=", "1650 #conquest#"};
				{ 5, 60569, "", "=q4=Vicious Gladiator's Armbands of Prowess", "=ds=", "1250 #conquest#"};
				{ 6, 60536, "", "=q4=Vicious Gladiator's Waistguard of Cruelty", "=ds=", "1650 #conquest#"};
				{ 7, 60567, "", "=q4=Vicious Gladiator's Sabatons of Accuracy", "=ds=", "1650 #conquest#"};
				{ 9, 60559, "", "=q4=Vicious Gladiator's Wristguards of Alacrity", "=ds=", "1250 #conquest#"};
				{ 10, 60555, "", "=q4=Vicious Gladiator's Links of Cruelty", "=ds=", "1650 #conquest#"};
				{ 11, 60557, "", "=q4=Vicious Gladiator's Sabatons of Alacrity", "=ds=", "1650 #conquest#"};
				{ 13, 60565, "", "=q4=Vicious Gladiator's Wristguards of Accuracy", "=ds=", "1250 #conquest#"};
				{ 14, 60564, "", "=q4=Vicious Gladiator's Links of Accuracy", "=ds=", "1650 #conquest#"};
				{ 15, 60554, "", "=q4=Vicious Gladiator's Sabatons of Cruelty", "=ds=", "1650 #conquest#"};
				{ 16, 64681, "", "=q3=Bloodthirsty Gladiator's Armbands of Meditation", "=ds=", "1250 #honor#"};
				{ 17, 64868, "", "=q3=Bloodthirsty Gladiator's Waistguard of Meditation", "=ds=", "1650 #honor#"};
				{ 18, 64837, "", "=q3=Bloodthirsty Gladiator's Sabatons of Meditation", "=ds=", "1650 #honor#"};
				{ 20, 64682, "", "=q3=Bloodthirsty Gladiator's Armbands of Prowess", "=ds=", "1250 #honor#"};
				{ 21, 64867, "", "=q3=Bloodthirsty Gladiator's Waistguard of Cruelty", "=ds=", "1650 #honor#"};
				{ 22, 64835, "", "=q3=Bloodthirsty Gladiator's Sabatons of Accuracy", "=ds=", "1650 #honor#"};
				{ 24, 64873, "", "=q3=Bloodthirsty Gladiator's Wristguards of Alacrity", "=ds=", "1250 #honor#"};
				{ 25, 64782, "", "=q3=Bloodthirsty Gladiator's Links of Cruelty", "=ds=", "1650 #honor#"};
				{ 26, 64834, "", "=q3=Bloodthirsty Gladiator's Sabatons of Alacrity", "=ds=", "1650 #honor#"};
				{ 28, 64872, "", "=q3=Bloodthirsty Gladiator's Wristguards of Accuracy", "=ds=", "1250 #honor#"};
				{ 29, 64781, "", "=q3=Bloodthirsty Gladiator's Links of Accuracy", "=ds=", "1650 #honor#"};
				{ 30, 64836, "", "=q3=Bloodthirsty Gladiator's Sabatons of Cruelty", "=ds=", "1650 #honor#"};
				extraText = ": "..BabbleInventory["Mail"]
			};
			{
				{ 1, 60541, "", "=q4=Vicious Gladiator's Bracers of Meditation", "=ds=", "1250 #conquest#"};
				{ 2, 60539, "", "=q4=Vicious Gladiator's Clasp of Meditation", "=ds=", "1650 #conquest#"};
				{ 3, 60540, "", "=q4=Vicious Gladiator's Greaves of Meditation", "=ds=", "1650 #conquest#"};
				{ 5, 60523, "", "=q4=Vicious Gladiator's Armplates of Proficiency", "=ds=", "1250 #conquest#"};
				{ 6, 60521, "", "=q4=Vicious Gladiator's Girdle of Prowess", "=ds=", "1650 #conquest#"};
				{ 7, 60513, "", "=q4=Vicious Gladiator's Warboots of Accuracy", "=ds=", "1650 #conquest#"};
				{ 9, 60520, "", "=q4=Vicious Gladiator's Bracers of Prowess", "=ds=", "1250 #conquest#"};
				{ 10, 60505, "", "=q4=Vicious Gladiator's Clasp of Cruelty", "=ds=", "1650 #conquest#"};
				{ 11, 60516, "", "=q4=Vicious Gladiator's Greaves of Alacrity", "=ds=", "1650 #conquest#"};
				{ 13, 60512, "", "=q4=Vicious Gladiator's Armplates of Accuracy", "=ds=", "1250 #conquest#"};
				{ 14, 60508, "", "=q4=Vicious Gladiator's Girdle of Cruelty", "=ds=", "1650 #conquest#"};
				{ 15, 60509, "", "=q4=Vicious Gladiator's Warboots of Cruelty", "=ds=", "1650 #conquest#"};
				{ 16, 64704, "", "=q3=Bloodthirsty Gladiator's Bracers of Meditation", "=ds=", "1250 #honor#"};
				{ 17, 64716, "", "=q3=Bloodthirsty Gladiator's Clasp of Meditation", "=ds=", "1650 #honor#"};
				{ 18, 64757, "", "=q3=Bloodthirsty Gladiator's Greaves of Meditation", "=ds=", "1650 #honor#"};
				{ 20, 64684, "", "=q3=Bloodthirsty Gladiator's Armplates of Proficiency", "=ds=", "1250 #honor#"};
				{ 21, 64754, "", "=q3=Bloodthirsty Gladiator's Girdle of Prowess", "=ds=", "1650 #honor#"};
				{ 22, 64869, "", "=q3=Bloodthirsty Gladiator's Warboots of Accuracy", "=ds=", "1650 #honor#"};
				{ 24, 64705, "", "=q3=Bloodthirsty Gladiator's Bracers of Prowess", "=ds=", "1250 #honor#"};
				{ 25, 64715, "", "=q3=Bloodthirsty Gladiator's Clasp of Cruelty", "=ds=", "1650 #honor#"};
				{ 26, 64869, "", "=q3=Bloodthirsty Gladiator's Greaves of Alacrity", "=ds=", "1650 #honor#"};
				{ 28, 64683, "", "=q3=Bloodthirsty Gladiator's Armplates of Alacrity", "=ds=", "1250 #honor#"};
				{ 29, 64753, "", "=q3=Bloodthirsty Gladiator's Girdle of Cruelty", "=ds=", "1650 #honor#"};
				{ 30, 64870, "", "=q3=Bloodthirsty Gladiator's Warboots of Cruelty", "=ds=", "1650 #honor#"};
				extraText = ": "..BabbleInventory["Plate"];
			};
		};
		info = {
			name = AL["PvP Non-Set Epics"],
			module = moduleName, menu = "PVPMENU",
		};
	}

		--------------------------
		--- Level 85 - Weapons ---
		--------------------------

	AtlasLoot_Data["PVP85Weapons"] = {
		["Normal"] = {
			{
				{ 2, 61333, "", "=q4=Vicious Gladiator's Right Render", "=ds=#h3#, #w13#", "2450 #conquest#" },
				{ 1, 61332, "", "=q4=Vicious Gladiator's Left Render", "=ds=#h4#, #w13#", "950 #conquest#" },
				{ 4, 61330, "", "=q4=Vicious Gladiator's Right Ripper", "=ds=#h3#, #w13#", "2450 #conquest#" },
				{ 3, 61331, "", "=q4=Vicious Gladiator's Left Ripper", "=ds=#h4#, #w13#", "950 #conquest#" },
				{ 8, 61329, "", "=q4=Vicious Gladiator's Spellblade", "=ds=#h3#, #w4#", "2450 #conquest#" },
				{ 7, 61327, "", "=q4=Vicious Gladiator's Shanker", "=ds=#h1#, #w4#", "2450 #conquest#" },
				{ 6, 61328, "", "=q4=Vicious Gladiator's Shiv", "=ds=#h4#, #w4#", "950 #conquest#" },
				{ 10, 61345, "", "=q4=Vicious Gladiator's Quickblade", "=ds=#h1#, #w10#", "2450 #conquest#" },
				{ 11, 61344, "", "=q4=Vicious Gladiator's Slicer", "=ds=#h1#, #w10#", "2450 #conquest#" },
				{ 13, 61324, "", "=q4=Vicious Gladiator's Cleaver", "=ds=#h1#, #w1#", "2450 #conquest#" },
				{ 14, 61325, "", "=q4=Vicious Gladiator's Hacker", "=ds=#h1#, #w1#", "2450 #conquest#" },
				{ 17, 61338, "", "=q4=Vicious Gladiator's Gavel", "=ds=#h3#, #w6#", "2450 #conquest#" },
				{ 16, 61336, "", "=q4=Vicious Gladiator's Bonecracker", "=ds=#h1#, #w6#", "2450 #conquest#" },
				{ 18, 61335, "", "=q4=Vicious Gladiator's Pummeler", "=ds=#h1#, #w6#", "2450 #conquest#" },
				{ 20, 61346, "", "=q4=Vicious Gladiator's Greatsword", "=ds=#h2#, #w10#", "3400 #conquest#" },
				{ 21, 61326, "", "=q4=Vicious Gladiator's Decapitator", "=ds=#h2#, #w1#", "3400 #conquest#" },
				{ 22, 61339, "", "=q4=Vicious Gladiator's Bonegrinder", "=ds=#h2#, #w6#", "3400 #conquest#" },
				{ 24, 61340, "", "=q4=Vicious Gladiator's Pike", "=ds=#w7#", "3400 #conquest#" },
				{ 26, 61341, "", "=q4=Vicious Gladiator's Battle Staff", "=ds=#w7#", "3400 #conquest#" },
				{ 27, 61342, "", "=q4=Vicious Gladiator's Energy Staff", "=ds=#w7#", "3400 #conquest#" },
			};
			{
				{ 1, 61360, "", "=q4=Vicious Gladiator's Barrier", "=ds=#w8#", "950 #conquest#" },
				{ 2, 61361, "", "=q4=Vicious Gladiator's Redoubt", "=ds=#w8#", "950 #conquest#" },
				{ 3, 61359, "", "=q4=Vicious Gladiator's Shield Wall", "=ds=#w8#", "950 #conquest#" },
				{ 5, 61348, "", "=q4=Vicious Gladiator's Hatchet", "=ds=#w11#", "700 #conquest#" },
				{ 6, 61347, "", "=q4=Vicious Gladiator's War Edge", "=ds=#w11#", "700 #conquest#" },
				{ 8, 61353, "", "=q4=Vicious Gladiator's Longbow", "=ds=#w2#", "3400 #conquest#" },
				{ 9, 61355, "", "=q4=Vicious Gladiator's Heavy Crossbow", "=ds=#w3#", "3400 #conquest#" },
				{ 10, 61354, "", "=q4=Vicious Gladiator's Rifle", "=ds=#w5#", "3400 #conquest#" },
				{ 16, 61351, "", "=q4=Vicious Gladiator's Baton of Light", "=ds=#w12#", "700 #conquest#" },
				{ 17, 61350, "", "=q4=Vicious Gladiator's Touch of Defeat", "=ds=#w12#", "700 #conquest#" },
				{ 19, 61358, "", "=q4=Vicious Gladiator's Reprieve", "=ds=#s15#", "950 #conquest#" },
				{ 20, 61357, "", "=q4=Vicious Gladiator's Endgame", "=ds=#s15#", "950 #conquest#" }
    		};
		};
		info = {
			name = AL["PvP Weapons"], "=q5="..AL["Level 85"],
			module = moduleName, menu = "PVPMENU",
		};
	}

		--------------------------
		--- Level 85 - Misc ---
		--------------------------

	AtlasLoot_Data["PVP85Misc"] = {
		["Normal"] = {
			{
    			{ 2, 68774, "", "=q4=Greater Inscription of Vicious Agility", "=ds=#s3# #e17#", "2000 #honor#" },
    			{ 3, 68772, "", "=q4=Greater Inscription of Vicious Intellect", "=ds=#s3# #e17#", "2000 #honor#" },
    			{ 4, 68773, "", "=q4=Greater Inscription of Vicious Strength", "=ds=#s3# #e17#", "2000 #honor#" },
    			{ 5, 68769, "", "=q3=Arcanum of Vicious Agility", "=ds=#s1# #e17#", "1000 #honor#" },
    			{ 6, 68770, "", "=q3=Arcanum of Vicious Intellect", "=ds=#s1# #e17#", "1000 #honor#" },
    			{ 7, 68768, "", "=q3=Arcanum of Vicious Strength", "=ds=#s1# #e17#", "1000 #honor#" },
   				{ 17, 52555, "", "=q1=Hypnotic Dust", "=ds=", "200 #honor#" },
    			{ 18, 52719, "", "=q2=Greater Celestial Essence", "=ds=", "800 #honor#" },
    			{ 19, 52721, "", "=q3=Heavenly Shard", "=ds=", "1200 #honor#" },
    			{ 20, 52976, "", "=q1=Savage Leather", "=ds=", "750 #honor#" },
    			{ 21, 53010, "", "=q1=Embersilk Cloth", "=ds=", "2500 #honor#" },
    			{ 22, 52185, "", "=q1=Elementium Ore", "=ds=", "2000 #honor#" },
    			{ 23, 68813, "", "=q3=Satchel of Freshly-Picked Herbs", "=ds=", "3000 #honor#" },
			};
		};
		info = {
			name = AL["Misc"], "=q5="..AL["Level 85"],
			module = moduleName, menu = "PVPMENU",
		};
	}

	--------------------------
	--- Sets & Collections ---
	--------------------------

		--------------------------
		--- Tier 11 Sets (T11) ---
		--------------------------

	AtlasLoot_Data["T11DeathKnightDPS"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_deathknight_frostpresence", "=q6=#t11s10_1#", "=q5="..AL["Tier 11"]};
				{ 2, 60341, "", "=q4=Magma Plated Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60343, "", "=q4=Magma Plated Pauldrons", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60339, "", "=q4=Magma Plated Battleplate", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60340, "", "=q4=Magma Plated Gauntlets", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60342, "", "=q4=Magma Plated Legplates", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "spell_deathknight_frostpresence", "=q6=#t11s10_1#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65181, "", "=q4=Magma Plated Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65183, "", "=q4=Magma Plated Pauldrons", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65179, "", "=q4=Magma Plated Battleplate", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65180, "", "=q4=Magma Plated Gauntlets", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65182, "", "=q4=Magma Plated Legplates", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"].." - "..AL["DPS"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11DeathKnightTank"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_deathknight_bloodpresence", "=q6=#t11s10_2#", "=q5="..AL["Tier 11"]};
				{ 2, 60351, "", "=q4=Magma Plated Faceguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60353, "", "=q4=Magma Plated Shoulderguards", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60349, "", "=q4=Magma Plated Chestguard", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60350, "", "=q4=Magma Plated Handguards", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60352, "", "=q4=Magma Plated Legguards", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "spell_deathknight_bloodpresence", "=q6=#t11s10_2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65186, "", "=q4=Magma Plated Faceguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65188, "", "=q4=Magma Plated Shoulderguards", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65184, "", "=q4=Magma Plated Chestguard", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65185, "", "=q4=Magma Plated Handguards", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65187, "", "=q4=Magma Plated Legguards", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"].." - "..AL["Tanking"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11DruidRestoration"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_healingtouch", "=q6=#t11s1_1#", "=q5="..AL["Tier 11"]};
				{ 2, 60277, "", "=q4=Stormrider's Helm", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60279, "", "=q4=Stormrider's Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60276, "", "=q4=Stormrider's Robes", "=ds=#s5#, #a2#", "2200 #valor#"};
				{ 5, 60280, "", "=q4=Stormrider's Handwraps", "=ds=#s9#, #a2#", "1650 #valor#"};
				{ 6, 60278, "", "=q4=Stormrider's Legwraps", "=ds=#s11#, #a2#", "2200 #valor#"};
				{ 8, 0, "spell_nature_healingtouch", "=q6=#t11s1_1#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65195, "", "=q4=Stormrider's Helm", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65198, "", "=q4=Stormrider's Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65197, "", "=q4=Stormrider's Robes", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65194, "", "=q4=Stormrider's Handwraps", "=ds=#s9#, #a2#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65196, "", "=q4=Stormrider's Legwraps", "=ds=#s11#, #a2#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DRUID"].." - "..AL["Restoration"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11DruidFeral"] = {
		["Normal"] = {
			{
				{ 1, 0, "ability_racial_bearform", "=q6=#t11s1_2#", "=q5="..AL["Tier 11"]};
				{ 2, 60286, "", "=q4=Stormrider's Headpiece", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60289, "", "=q4=Stormrider's Spaulders", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60287, "", "=q4=Stormrider's Raiment", "=ds=#s5#, #a2#", "2200 #valor#"};
				{ 5, 60290, "", "=q4=Stormrider's Grips", "=ds=#s9#, #a2#", "1650 #valor#"};
				{ 6, 60288, "", "=q4=Stormrider's Legguards", "=ds=#s11#, #a2#", "2200 #valor#"};
				{ 8, 0, "ability_racial_bearform", "=q6=#t11s1_2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65190, "", "=q4=Stormrider's Headpiece", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65193, "", "=q4=Stormrider's Spaulders", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65192, "", "=q4=Stormrider's Raiment", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65189, "", "=q4=Stormrider's Grips", "=ds=#s9#, #a2#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65191, "", "=q4=Stormrider's Legguards", "=ds=#s11#, #a2#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DRUID"].." - "..AL["Feral"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11DruidBalance"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_starfall", "=q6=#t11s1_3#", "=q5="..AL["Tier 11"]};
				{ 2, 60282, "", "=q4=Stormrider's Cover", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60284, "", "=q4=Stormrider's Shoulderwraps", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60281, "", "=q4=Stormrider's Vestment", "=ds=#s5#, #a2#", "2200 #valor#"};
				{ 5, 60285, "", "=q4=Stormrider's Gloves", "=ds=#s9#, #a2#", "1650 #valor#"};
				{ 6, 60283, "", "=q4=Stormrider's Leggings", "=ds=#s11#, #a2#", "2200 #valor#"};
				{ 8, 0, "spell_nature_starfall", "=q6=#t11s1_3#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65200, "", "=q4=Stormrider's Cover", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65203, "", "=q4=Stormrider's Shoulderwraps", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65202, "", "=q4=Stormrider's Vestment", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65199, "", "=q4=Stormrider's Gloves", "=ds=#s9#, #a2#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65201, "", "=q4=Stormrider's Leggings", "=ds=#s11#, #a2#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["DRUID"].." - "..AL["Balance"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11Hunter"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_weapon_bow_07", "=q6=#t11s2#", "=q5="..AL["Tier 11"]};
				{ 2, 60303, "", "=q4=Lightning-Charged Headguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60306, "", "=q4=Lightning-Charged Spaulders", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60304, "", "=q4=Lightning-Charged Tunic", "=ds=#s5#, #a3#", "2200 #valor#"};
				{ 5, 60307, "", "=q4=Lightning-Charged Gloves", "=ds=#s9#, #a3#", "1650 #valor#"};
				{ 6, 60305, "", "=q4=Lightning-Charged Legguards", "=ds=#s11#, #a3#", "2200 #valor#"};
				{ 8, 0, "inv_weapon_bow_07", "=q6=#t11s2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65206, "", "=q4=Lightning-Charged Headguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65208, "", "=q4=Lightning-Charged Spaulders", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65204, "", "=q4=Lightning-Charged Tunic", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65205, "", "=q4=Lightning-Charged Gloves", "=ds=#s9#, #a3#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65207, "", "=q4=Lightning-Charged Legguards", "=ds=#s11#, #a3#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["HUNTER"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11Mage"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_staff_13", "=q6=#t11s3#", "=q5="..AL["Tier 11"]};
				{ 2, 60243, "", "=q4=Firelord's Hood", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60246, "", "=q4=Firelord's Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60244, "", "=q4=Firelord's Robes", "=ds=#s5#, #a1#", "2200 #valor#"};
				{ 5, 60247, "", "=q4=Firelord's Gloves", "=ds=#s9#, #a1#", "1650 #valor#"};
				{ 6, 60245, "", "=q4=Firelord's Leggings", "=ds=#s11#, #a1#", "2200 #valor#"};
				{ 8, 0, "inv_staff_13", "=q6=#t11s3#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65210, "", "=q4=Firelord's Hood", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65213, "", "=q4=Firelord's Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65212, "", "=q4=Firelord's Robes", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65209, "", "=q4=Firelord's Gloves", "=ds=#s9#, #a1#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65211, "", "=q4=Firelord's Leggings", "=ds=#s11#, #a1#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["MAGE"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11PaladinHoly"] = {
		["Normal"] = {
			{
				{ 1, 0, "Spell_Holy_HolyBolt", "=q6=#t11s4_1#", "=q5="..AL["Tier 11"]};
				{ 2, 60359, "", "=q4=Reinforced Sapphirium Headguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60362, "", "=q4=Reinforced Sapphirium Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60360, "", "=q4=Reinforced Sapphirium Breastplate", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60363, "", "=q4=Reinforced Sapphirium Gloves", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60361, "", "=q4=Reinforced Sapphirium Greaves", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "Spell_Holy_HolyBolt", "=q6=#t11s4_1#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65221, "", "=q4=Reinforced Sapphirium Headguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65223, "", "=q4=Reinforced Sapphirium Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65219, "", "=q4=Reinforced Sapphirium Breastplate", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65220, "", "=q4=Reinforced Sapphirium Gloves", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65222, "", "=q4=Reinforced Sapphirium Greaves", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PALADIN"].." - "..AL["Holy"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11PaladinProtection"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_holy_devotionaura", "=q6=#t11s4_2#", "=q5="..AL["Tier 11"]};
				{ 2, 60356, "", "=q4=Reinforced Sapphirium Faceguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60358, "", "=q4=Reinforced Sapphirium Shoulderguards", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60354, "", "=q4=Reinforced Sapphirium Chestguard", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60355, "", "=q4=Reinforced Sapphirium Handguards", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60357, "", "=q4=Reinforced Sapphirium Legguards", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "spell_holy_devotionaura", "=q6=#t11s4_2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65226, "", "=q4=Reinforced Sapphirium Faceguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65228, "", "=q4=Reinforced Sapphirium Shoulderguards", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65224, "", "=q4=Reinforced Sapphirium Chestguard", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65225, "", "=q4=Reinforced Sapphirium Handguards", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65227, "", "=q4=Reinforced Sapphirium Legguards", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PALADIN"].." - "..AL["Protection"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11PaladinRetribution"] = {
		["Normal"] = {
			{
				{ 1, 0, "Spell_Holy_AuraOfLight", "=q6=#t11s4_3#", "=q5="..AL["Tier 11"]};
				{ 2, 60346, "", "=q4=Reinforced Sapphirium Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60348, "", "=q4=Reinforced Sapphirium Pauldrons", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60344, "", "=q4=Reinforced Sapphirium Battleplate", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60345, "", "=q4=Reinforced Sapphirium Gauntlets", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60347, "", "=q4=Reinforced Sapphirium Legplates", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "Spell_Holy_AuraOfLight", "=q6=#t11s4_3#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65216, "", "=q4=Reinforced Sapphirium Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65218, "", "=q4=Reinforced Sapphirium Pauldrons", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65214, "", "=q4=Reinforced Sapphirium Battleplate", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65215, "", "=q4=Reinforced Sapphirium Gauntlets", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65217, "", "=q4=Reinforced Sapphirium Legplates", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PALADIN"].." - "..AL["Retribution"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11PriestShadow"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_shadow_shadowwordpain", "=q6=#t11s5_1#", "=q5="..AL["Tier 11"]};
				{ 2, 60256, "", "=q4=Mercurial Hood", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60253, "", "=q4=Mercurial Shoulderwraps", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60254, "", "=q4=Mercurial Vestment", "=ds=#s5#, #a1#", "2200 #valor#"};
				{ 5, 60257, "", "=q4=Mercurial Gloves", "=ds=#s9#, #a1#", "1650 #valor#"};
				{ 6, 60255, "", "=q4=Mercurial Leggings", "=ds=#s11#, #a1#", "2200 #valor#"};
				{ 8, 0, "spell_shadow_shadowwordpain", "=q6=#t11s5_1#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65235, "", "=q4=Mercurial Hood", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65238, "", "=q4=Mercurial Shoulderwraps", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65237, "", "=q4=Mercurial Vestment", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65234, "", "=q4=Mercurial Gloves", "=ds=#s9#, #a1#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65236, "", "=q4=Mercurial Leggings", "=ds=#s11#, #a1#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PRIEST"].." - "..AL["Shadow"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11PriestHoly"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_holy_guardianspirit", "=q6=#t11s5_2#", "=q5="..AL["Tier 11"]};
				{ 2, 60258, "", "=q4=Mercurial Cowl", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60262, "", "=q4=Mercurial Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60259, "", "=q4=Mercurial Robes", "=ds=#s5#, #a1#", "2200 #valor#"};
				{ 5, 60275, "", "=q4=Mercurial Handwraps", "=ds=#s9#, #a1#", "1650 #valor#"};
				{ 6, 60261, "", "=q4=Mercurial Legwraps", "=ds=#s11#, #a1#", "2200 #valor#"};
				{ 8, 0, "spell_holy_guardianspirit", "=q6=#t11s5_2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65230, "", "=q4=Mercurial Cowl", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65233, "", "=q4=Mercurial Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65232, "", "=q4=Mercurial Robes", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65229, "", "=q4=Mercurial Handwraps", "=ds=#s9#, #a1#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65231, "", "=q4=Mercurial Legwraps", "=ds=#s11#, #a1#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["PRIEST"].." - "..AL["Holy"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11Rogue"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_throwingknife_04", "=q6=#t11s6#", "=q5="..AL["Tier 11"]};
				{ 2, 60299, "", "=q4=Wind Dancer's Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60302, "", "=q4=Wind Dancer's Spaulders", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60301, "", "=q4=Wind Dancer's Tunic", "=ds=#s5#, #a2#", "2200 #valor#"};
				{ 5, 60298, "", "=q4=Wind Dancer's Gloves", "=ds=#s9#, #a2#", "1650 #valor#"};
				{ 6, 60300, "", "=q4=Wind Dancer's Legguards", "=ds=#s11#, #a2#", "2200 #valor#"};
				{ 8, 0, "inv_throwingknife_04", "=q6=#t11s6#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65241, "", "=q4=Wind Dancer's Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65243, "", "=q4=Wind Dancer's Spaulders", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65239, "", "=q4=Wind Dancer's Tunic", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65240, "", "=q4=Wind Dancer's Gloves", "=ds=#s9#, #a2#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65242, "", "=q4=Wind Dancer's Legguards", "=ds=#s11#, #a2#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["ROGUE"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11ShamanElemental"] = {
		["Normal"] = {
			{
				{ 1, 0, "Spell_Nature_Lightning", "=q6=#t11s7_3#", "=q5="..AL["Tier 11"]};
				{ 2, 60315, "", "=q4=Headpiece of the Raging Elements", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60317, "", "=q4=Shoulderwraps of the Raging Elements", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60313, "", "=q4=Hauberk of the Raging Elements", "=ds=#s5#, #a3#", "2200 #valor#"};
				{ 5, 60314, "", "=q4=Gloves of the Raging Elements", "=ds=#s9#, #a3#", "1650 #valor#"};
				{ 6, 60316, "", "=q4=Kilt of the Raging Elements", "=ds=#s11#, #a3#", "2200 #valor#"};
				{ 8, 0, "Spell_Nature_Lightning", "=q6=#t11s7_3#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65256, "", "=q4=Headpiece of the Raging Elements", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65258, "", "=q4=Shoulderwraps of the Raging Elements", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65254, "", "=q4=Hauberk of the Raging Elements", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65255, "", "=q4=Gloves of the Raging Elements", "=ds=#s9#, #a3#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65257, "", "=q4=Kilt of the Raging Elements", "=ds=#s11#, #a3#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"].." - "..AL["Elemental"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11ShamanEnhancement"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_lightningshield", "=q6=#t11s7_2#", "=q5="..AL["Tier 11"]};
				{ 2, 60320, "", "=q4=Helmet of the Raging Elements", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60322, "", "=q4=Spaulders of the Raging Elements", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60318, "", "=q4=Culrass of the Raging Elements", "=ds=#s5#, #a3#", "2200 #valor#"};
				{ 5, 60319, "", "=q4=Grips of the Raging Elements", "=ds=#s9#, #a3#", "1650 #valor#"};
				{ 6, 60321, "", "=q4=Legguards of the Raging Elements", "=ds=#s11#, #a3#", "2200 #valor#"};
				{ 8, 0, "spell_nature_lightningshield", "=q6=#t11s7_2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65251, "", "=q4=Helmet of the Raging Elements", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65253, "", "=q4=Spaulders of the Raging Elements", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65249, "", "=q4=Culrass of the Raging Elements", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65250, "", "=q4=Grips of the Raging Elements", "=ds=#s9#, #a3#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65252, "", "=q4=Legguards of the Raging Elements", "=ds=#s11#, #a3#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"].." - "..AL["Enhancement"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11ShamanRestoration"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_magicimmunity", "=q6=#t11s7_1#", "=q5="..AL["Tier 11"]};
				{ 2, 60308, "", "=q4=Faceguard of the Raging Elements", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60311, "", "=q4=Mantle of the Raging Elements", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60309, "", "=q4=Tunic of the Raging Elements", "=ds=#s5#, #a3#", "2200 #valor#"};
				{ 5, 60312, "", "=q4=Handwraps of the Raging Elements", "=ds=#s9#, #a3#", "1650 #valor#"};
				{ 6, 60310, "", "=q4=Legwraps of the Raging Elements", "=ds=#s11#, #a3#", "2200 #valor#"};
				{ 8, 0, "spell_nature_magicimmunity", "=q6=#t11s7_1#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65246, "", "=q4=Faceguard of the Raging Elements", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65248, "", "=q4=Mantle of the Raging Elements", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65244, "", "=q4=Tunic of the Raging Elements", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65245, "", "=q4=Handwraps of the Raging Elements", "=ds=#s9#, #a3#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65247, "", "=q4=Legwraps of the Raging Elements", "=ds=#s11#, #a3#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["SHAMAN"].." - "..AL["Restoration"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11Warlock"] = {
		["Normal"] = {
			{
				{ 1, 0, "spell_nature_drowsy", "=q6=#t11s8#", "=q5="..AL["Tier 11"]};
				{ 2, 60249, "", "=q4=Shadowflame Hood", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60252, "", "=q4=Shadowflame Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60251, "", "=q4=Shadowflame Robes", "=ds=#s5#, #a1#", "2200 #valor#"};
				{ 5, 60248, "", "=q4=Shadowflame Handwraps", "=ds=#s9#, #a1#", "1650 #valor#"};
				{ 6, 60250, "", "=q4=Shadowflame Leggings", "=ds=#s11#, #a1#", "2200 #valor#"};
				{ 8, 0, "spell_nature_drowsy", "=q6=#t11s8#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65260, "", "=q4=Shadowflame Hood", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65263, "", "=q4=Shadowflame Mantle", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65262, "", "=q4=Shadowflame Robes", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65259, "", "=q4=Shadowflame Handwraps", "=ds=#s9#, #a1#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65261, "", "=q4=Shadowflame Leggings", "=ds=#s11#, #a1#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["WARLOCK"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11WarriorFury"] = {
		["Normal"] = {
			{
				{ 1, 0, "ability_warrior_innerrage", "=q6=#t11s9_1#", "=q5="..AL["Tier 11"]};
				{ 2, 60325, "", "=q4=Earthen Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60327, "", "=q4=Earthen Pauldrons", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60323, "", "=q4=Earthen Battleplate", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60326, "", "=q4=Earthen Gauntlets", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60324, "", "=q4=Earthen Legplates", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "ability_warrior_innerrage", "=q6=#t11s9_1#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65266, "", "=q4=Earthen Helmet", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 10, 65268, "", "=q4=Earthen Pauldrons", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65264, "", "=q4=Earthen Battleplate", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65265, "", "=q4=Earthen Gauntlets", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65267, "", "=q4=Earthen Legplates", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["WARRIOR"].." - "..AL["DPS"],
			module = moduleName, menu = "T11SET",
		};
	}

	AtlasLoot_Data["T11WarriorProtection"] = {
		["Normal"] = {
			{
				{ 1, 0, "ability_warrior_defensivestance", "=q6=#t11s9_2#", "=q5="..AL["Tier 11"]};
				{ 2, 60328, "", "=q4=Earthen Faceguard", "", "=ds="..BabbleBoss["Nefarian"]};
				{ 3, 60331, "", "=q4=Earthen Shoulderguards", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 4, 60329, "", "=q4=Earthen Chestguard", "=ds=#s5#, #a4#", "2200 #valor#"};
				{ 5, 60332, "", "=q4=Earthen Handguards", "=ds=#s9#, #a4#", "1650 #valor#"};
				{ 6, 60330, "", "=q4=Earthen Legguards", "=ds=#s11#, #a4#", "2200 #valor#"};
				{ 8, 0, "ability_warrior_defensivestance", "=q6=#t11s9_2#", "=q5="..AL["Tier 11"].." - "..AL["Heroic"]};
				{ 9, 65271, "", "=q4=Earthen Faceguard", "=ds="..BabbleBoss["Nefarian"], ""};
				{ 10, 65273, "", "=q4=Earthen Shoulderguards", "", "=ds="..BabbleBoss["Cho'gall"]};
				{ 11, 65269, "", "=q4=Earthen Chestguard", "", "=ds="..BabbleBoss["Halfus Wyrmbreaker"]};
				{ 12, 65270, "", "=q4=Earthen Handguards", "=ds=#s9#, #a4#", "=ds="..BabbleBoss["Maloriak"]};
				{ 13, 65272, "", "=q4=Earthen Legguards", "=ds=#s11#, #a4#", "=ds="..BabbleBoss["Magmaw"]};
			};
		};
		info = {
			name = LOCALIZED_CLASS_NAMES_MALE["WARRIOR"].." - "..AL["Protection"],
			module = moduleName, menu = "T11SET",
		};
	}

		-------------------
		--- Legendaries ---
		-------------------

	AtlasLoot_Data["Legendaries"] = {
		["Normal"] = {
			{
				{ 1, 49623, "", "=q5=Shadowmourne", "=ds=#h2# #w1#", "" };
				{ 2, 46017, "", "=q5=Val'anyr, Hammer of Ancient Kings", "=ds=#h3# #w6#", "" };
				{ 4, 34334, "", "=q5=Thori'dal, the Stars' Fury", "=ds=#w2#"};
				{ 5, 32837, "", "=q5=Warglaive of Azzinoth", "=ds=#h3#, #w10#, =q1=#m1# =ds=#c9#, #c6#"};
				{ 6, 32838, "", "=q5=Warglaive of Azzinoth", "=ds=#h4#, #w10#, =q1=#m1# =ds=#c9#, #c6#"};
				{ 8, 19019, "", "=q5=Thunderfury, Blessed Blade of the Windseeker", "=ds=#h1#, #w10#"};
				{ 9, 17182, "", "=q5=Sulfuras, Hand of Ragnaros", "=ds=#h2#, #w6#"};
				{ 10, 21176, "", "=q5=Black Qiraji Resonating Crystal", "=ds=#e26#"};
				{ 16, 22632, "", "=q5=Atiesh, Greatstaff of the Guardian", "=ds=#w9#, =q1=#m1# =ds=#c1#"};
				{ 17, 22589, "", "=q5=Atiesh, Greatstaff of the Guardian", "=ds=#w9#, =q1=#m1# =ds=#c3#"};
				{ 18, 22631, "", "=q5=Atiesh, Greatstaff of the Guardian", "=ds=#w9#, =q1=#m1# =ds=#c5#"};
				{ 19, 22630, "", "=q5=Atiesh, Greatstaff of the Guardian", "=ds=#w9#, =q1=#m1# =ds=#c8#"};
			};
		};
		info = {
			name = AL["Legendary Items"],
			module = moduleName, menu = "SETMENU",
		};
	}

		---------------
		--- Tabards ---
		---------------

	AtlasLoot_Data["TabardsAlliance"] = {
		["Normal"] = {
			{
				{ 1, 63379, "", "=q3=Baradin's Wardens Tabard", "=ds=#s7#"};
				{ 2, 45579, "", "=q1=Darnassus Tabard", "=ds=#s7#"};
				{ 3, 45580, "", "=q1=Exodar Tabard", "=ds=#s7#"};
				{ 4, 64882, "", "=q1=Gilneas Tabard", "=ds=#s7#"};
				{ 5, 45578, "", "=q1=Gnomeregan Tabard", "=ds=#s7#"};
				{ 6, 23999, "", "=q1=Honor Hold Tabard", "=ds=#s7#"};
				{ 7, 45577, "", "=q1=Ironforge Tabard", "=ds=#s7#"};
				{ 8, 31774, "", "=q1=Kurenai Tabard", "=ds=#s7#"};
				{ 9, 46817, "", "=q1=Silver Covenant Tabard", "=ds=#s7#"};
				{ 10, 45574, "", "=q1=Stormwind Tabard", "=ds=#s7#"};
				{ 11, 65908, "", "=q1=Tabard of the Wildhammer Clan", "=ds=#s7#"};
				{ 16, 0, "INV_BannerPVP_02", "=q6="..AL["PvP Tabards"], ""};
				{ 17, 15196, "", "=q1=Private's Tabard", "=ds=#s7#"};
				{ 18, 15198, "", "=q1=Knight's Colors", "=ds=#s7#"};
				{ 19, 20132, "", "=q1=Arathor Battle Tabard", "=ds=#s7#, =q1=#m4#"};
				{ 20, 19506, "", "=q1=Silverwing Battle Tabard", "=ds=#s7#"};
				{ 21, 19032, "", "=q1=Stormpike Battle Tabard", "=ds=#s7#"};
			};
		};
		info = {
			name = AL["Alliance Tabards"],
			module = moduleName, menu = "TABARDMENU",
		};
	}

	AtlasLoot_Data["TabardsHorde"] = {
		["Normal"] = {
			{
				{ 1, 63378, "", "=q3=Hellscream's Reach Tabard", "=ds=#s7#"};
				{ 2, 64884, "", "=q1=Bilgewater Cartel Tabard", "=ds=#s7#"};
				{ 3, 45582, "", "=q1=Darkspear Tabard", "=ds=#s7#"};
				{ 4, 31773, "", "=q1=Mag'har Tabard", "=ds=#s7#"};
				{ 5, 45581, "", "=q1=Orgrimmar Tabard", "=ds=#s7#"};
				{ 6, 45585, "", "=q1=Silvermoon City Tabard", "=ds=#s7#"};
				{ 7, 46818, "", "=q1=Sunreaver Tabard", "=ds=#s7#"};
				{ 8, 65909, "", "=q1=Tabard of the Dragonmaw Clan", "=ds=#s7#"};
				{ 9, 24004, "", "=q1=Thrallmar Tabard", "=ds=#s7#"};
				{ 10, 45584, "", "=q1=Thunder Bluff Tabard", "=ds=#s7#"};
				{ 11, 45583, "", "=q1=Undercity Tabard", "=ds=#s7#"};
				{ 16, 0, "INV_BannerPVP_01", "=q6="..AL["PvP Tabards"], ""};
				{ 17, 15197, "", "=q1=Scout's Tabard", "=ds=#s7#"};
				{ 18, 15199, "", "=q1=Stone Guard's Herald", "=ds=#s7#"};
				{ 19, 20131, "", "=q1=Battle Tabard of the Defilers", "=ds=#s7#, =q1=#m4#"};
				{ 20, 19031, "", "=q1=Frostwolf Battle Tabard", "=ds=#s7#"};
				{ 21, 19505, "", "=q1=Warsong Battle Tabard", "=ds=#s7#"};
			};
		};
		info = {
			name = AL["Horde Tabards"],
			module = moduleName, menu = "TABARDMENU",
		};
	}

	AtlasLoot_Data["TabardsNeutralFaction"] = {
		["Normal"] = {
			{
				{ 1, 46874, "", "=q3=Argent Crusader's Tabard", "=ds=#s7#"};
				{ 2, 31779, "", "=q1=Aldor Tabard", "=ds=#s7#"};
				{ 3, 31804, "", "=q1=Cenarion Expedition Tabard", "=ds=#s7#"};
				{ 4, 31776, "", "=q1=Consortium Tabard", "=ds=#s7#"};
				{ 5, 31777, "", "=q1=Keepers of Time Tabard", "=ds=#s7#"};
				{ 6, 31778, "", "=q1=Lower City Tabard", "=ds=#s7#"};
				{ 7, 32828, "", "=q1=Ogri'la Tabard", "=ds=#s7#"};
				{ 8, 31781, "", "=q1=Sha'tar Tabard", "=ds=#s7#"};
				{ 9, 31775, "", "=q1=Sporeggar Tabard", "=ds=#s7#"};
				{ 10, 31780, "", "=q1=Scryers Tabard", "=ds=#s7#"};
				{ 11, 32445, "", "=q1=Skyguard Tabard", "=ds=#s7#"};
				{ 12, 65904, "", "=q1=Tabard of Ramkahen", "=ds=#s7#"};
				{ 13, 43154, "", "=q1=Tabard of the Argent Crusade", "=ds=#s7#"};
				{ 14, 65905, "", "=q1=Tabard of the Earthen Ring", "=ds=#s7#"};
				{ 15, 43155, "", "=q1=Tabard of the Ebon Blade", "=ds=#s7#"};
				{ 16, 65906, "", "=q1=Tabard of the Guardians of Hyjal", "=ds=#s7#"};
				{ 17, 43157, "", "=q1=Tabard of the Kirin Tor", "=ds=#s7#"};
				{ 18, 35221, "", "=q1=Tabard of the Shattered Sun", "=ds=#s7#"};
				{ 19, 43156, "", "=q1=Tabard of the Wyrmrest Accord", "=ds=#s7#"};
				{ 20, 65907, "", "=q1=Tabard of Therazane", "=ds=#s7#"};
			};
		};
		info = {
			name = AL["Neutral Faction Tabards"],
			module = moduleName, menu = "TABARDMENU",
		};
	}

	AtlasLoot_Data["TabardsAchievementQuestRareMisc"] = {
		["Normal"] = {
			{
				{ 1, 0, "achievement_guildperk_honorablemention_rank2", "=q6="..AL["Achievement Reward"], ""};
				{ 2, 43349, "", "=q4=Tabard of Brute Force", "#ACHIEVEMENTID:876#"};
				{ 3, 40643, "", "=q4=Tabard of the Achiever", "#ACHIEVEMENTID:1021#"};
				{ 4, 43348, "", "=q4=Tabard of the Explorer", "#ACHIEVEMENTID:45#"};
				{
					{ 5, 43300, "", "=q4=Loremaster's Colors", "#ACHIEVEMENTID:1682#, =ec1="..BabbleFaction["Horde"]};
					{ 5, 43300, "", "=q4=Loremaster's Colors", "#ACHIEVEMENTID:1681#, =ec1="..BabbleFaction["Alliance"]};
				};
				{ 6, 49052, "", "=q3=Tabard of Conquest", "#ACHIEVEMENTID:3857#, =ec1="..BabbleFaction["Alliance"]};
				{ 7, 49054, "", "=q3=Tabard of Conquest", "#ACHIEVEMENTID:3957#, =ec1="..BabbleFaction["Horde"]};
				{ 9, 0, "INV_BannerPVP_02", "=q6="..AL["Misc"], ""}; ---different icon
				{ 10, 23192, "", "=q2=Tabard of the Scarlet Crusade", "=ds=#s7#", "", "0.48%"};
				{ 11, 5976, "", "=q1=Guild Tabard", "=ds=#s7#"};
				{ 16, 0, "achievement_guildperk_honorablemention", "=q6="..AL["Quest Reward"], ""};
				{ 17, 52252, "", "=q4=Tabard of the Lightbringer", "=q1=#m4#: #QUESTID:24919#"};
				{ 18, 35280, "", "=q3=Tabard of Summer Flames", "=q1=#m4#: #QUESTID:11972#"};
				{ 19, 35279, "", "=q3=Tabard of Summer Skies", "=q1=#m4#: #QUESTID:11972#"};
				{ 20, 31404, "", "=q2=Green Trophy Tabard of the Illidari", "=q1=#m4#: #QUESTID:10781#"};
				{ 21, 31405, "", "=q2=Purple Trophy Tabard of the Illidari", "=q1=#m4#: #QUESTID:10781#"};
				{ 22, 25549, "", "=q1=Blood Knight Tabard", "=q1=#m4#: #QUESTID:9737#, =ec1="..BabbleFaction["Horde"]};
				{ 23, 24344, "", "=q1=Tabard of the Hand", "=q1=#m4#: #QUESTID:9762#, =ec1="..BabbleFaction["Alliance"]};
			};
		};
		info = {
			name = AL["Achievement & Quest Reward Tabards"],
			module = moduleName, menu = "TABARDMENU",
		};
	}

	AtlasLoot_Data["TabardsCardGame"] = {
		["Normal"] = {
			{
				{ 1, 38312, "", "=q4=Tabard of Brilliance", "=ds=#s7#, =q1=#m24#"};
				{ 2, 23705, "", "=q4=Tabard of Flame", "=ds=#s7#, =q1=#m24#"};
				{ 3, 23709, "", "=q4=Tabard of Frost", "=ds=#s7#, =q1=#m24#"};
				{ 4, 38313, "", "=q4=Tabard of Fury", "=ds=#s7#, =q1=#m24#"};
				{ 5, 38309, "", "=q4=Tabard of Nature", "=ds=#s7#, =q1=#m24#"};
				{ 6, 38310, "", "=q4=Tabard of the Arcane", "=ds=#s7#, =q1=#m24#"};
				{ 7, 38314, "", "=q4=Tabard of the Defender", "=ds=#s7#, =q1=#m24#"};
				{ 8, 38311, "", "=q4=Tabard of the Void", "=ds=#s7#, =q1=#m24#"};
			};
		};
		info = {
			name = AL["Card Game Tabards"],
			module = moduleName, menu = "TABARDMENU",
		};
	}

	AtlasLoot_Data["TabardsRemoved"] = {
		["Normal"] = {
			{
				{ 1, 36941, "", "=q3=Competitor's Tabard", "=ds=#s7#"};
				{ 2, 22999, "", "=q1=Tabard of the Argent Dawn", "=ds=#s7#, =q1=#m4#"};
				{ 3, 28788, "", "=q1=Tabard of the Protector", "=ds=#s7#, =q1=#m4#"};
				{ 4, 19160, "", "=q1=Contest Winner's Tabard", "=ds=#s7#"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Arena Reward"], ""};
				{ 17, 45983, "", "=q4=Furious Gladiator's Tabard", "=ds="..AL["Season 6"]};
				{ 18, 49086, "", "=q4=Relentless Gladiator's Tabard", "=ds="..AL["Season 7"]};
				{ 19, 51534, "", "=q4=Wrathful Gladiator's Tabard", "=ds="..AL["Season 8"]};
			};
		};
		info = {
			name = AL["Unobtainable Tabards"],
			module = moduleName, menu = "TABARDMENU",
		};
	}

		-------------------------------
		--- Trading Card Game Items ---
		-------------------------------

	AtlasLoot_Data["CardGame"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Worldbreaker"]};
				{ 2, 68008, "", "=q4=Mottled Drake", "=ds="..AL["Mottled Drake"] };
				{ 3, 67097, "", "=q3=Grim Campfire", "=ds="..AL["Grim Campfire"] };
				{ 4, 67128, "", "=q3=Landro's Lil' XT", "=ds="..AL["Landro's Lil' XT"] };
				{ 6, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Icecrown"]};
				{ 7, 54068, "", "=q4=Wooly White Rhino", "=ds="..AL["Wooly White Rhino"]};
				{ 8, 54452, "", "=q3=Ethereal Portal", "=ds="..AL["Ethereal Portal"]};
				{ 9, 54455, "", "=q1=Paint Bomb", "=ds="..AL["Paint Bomb"]};
				{ 11, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Wrathgate"]};
				{ 12, 54069, "", "=q4=Blazing Hippogryph", "=ds="..AL["Blazing Hippogryph"]};
				{ 13, 54212, "", "=q3=Instant Statue Pedestal", "=ds="..AL["Statue Generator"]};
				{ 14, 54218, "", "=q1=Landro's Gift Box", "=ds="..AL["Landro's Gift"]};
				{ 16, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Scourgewar"]};
				{ 17, 49287, "", "=q4=Tuskarr Kite", "=ds="..AL["Tuskarr Kite"]};
				{ 18, 49343, "", "=q3=Spectral Tiger Cub", "=ds="..AL["Spectral Kitten"]};
				{ 19, 49289, "", "=q2=Little White Stallion Bridle", "=ds="..AL["Tiny"]};
				{ 20, 49288, "", "=q2=Little Ivory Raptor Whistle", "=ds="..AL["Tiny"]};
				{ 22, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Fields of Honor"]};
				{ 23, 49290, "", "=q4=Magic Rooster Egg", "=ds="..AL["El Pollo Grande"]};
				{ 24, 46780, "", "=q3=Ogre Pinata", "=ds="..AL["Pinata"]};
				{ 25, 46779, "", "=q1=Path of Cenarius", "=ds="..AL["Path of Cenarius"]};
				{ 27, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Blood of Gladiators"]};
				{ 28, 45037, "", "=q4=Epic Purple Shirt", "=ds="..AL["Center of Attention"]};
				{ 29, 45063, "", "=q3=Foam Sword Rack", "=ds="..AL["Foam Sword Rack"]};
				{ 30, 45047, "", "=q3=Sandbox Tiger", "=ds="..AL["Sandbox Tiger"]};

			};
			{
				{ 1, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Drums of War"]};
				{ 2, 49282, "", "=q4=Big Battle Bear", "=ds="..AL["The Red Bearon"]};
				{ 3, 38578, "", "=q3=The Flag of Ownership", "=ds="..AL["Owned!"]};
				{ 4, 38577, "", "=q1=Party G.R.E.N.A.D.E.", "=ds="..AL["Slashdance"]};
				{ 6, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Hunt for Illidan"]};
				{ 7, 38050, "", "=q3=Soul-Trader Beacon", "=ds="..AL["Ethereal Plunderer"]};
				{ 8, 38301, "", "=q3=D.I.S.C.O", "=ds="..AL["Disco Inferno!"]};
				{ 9, 38233, "", "=q1=Path of Illidan", "=ds="..AL["The Footsteps of Illidan"]};
				{ 11, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Servants of the Betrayer"]};
				{ 12, 35227, "", "=q4=Goblin Weather Machine - Prototype 01-B", "=ds="..AL["Personal Weather Machine"]};
				{ 13, 49286, "", "=q4=X-51 Nether-Rocket X-TREME", "=ds="..AL["X-51 Nether-Rocket"]};
				{ 14, 49285, "", "=q3=X-51 Nether-Rocket", "=ds="..AL["X-51 Nether-Rocket"]};
				{ 15, 35223, "", "=q3=Papa Hummel's Old-Fashioned Pet Biscuit", "=ds="..AL["Papa Hummel's Old-fashioned Pet Biscuit"]};
				{ 16, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["March of the Legion"]};
				{ 17, 34493, "", "=q4=Dragon Kite", "=ds="..AL["Kiting"]};
				{ 18, 34492, "", "=q3=Rocket Chicken", "=ds="..AL["Robotic Homing Chicken"]};
				{ 19, 34499, "", "=q3=Paper Flying Machine Kit", "=ds="..AL["Paper Airplane"]};
				{ 21, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Fires of Outland"]};
				{ 22, 49284, "", "=q4=Reins of the Swift Spectral Tiger", "=ds="..AL["Spectral Tiger"]};
				{ 23, 49283, "", "=q3=Reins of the Spectral Tiger", "=ds="..AL["Spectral Tiger"]};
				{ 24, 33223, "", "=q3=Fishing Chair", "=ds="..AL["Gone Fishin'"]};
				{ 25, 33219, "", "=q3=Goblin Gumbo Kettle", "=ds="..AL["Goblin Gumbo"]};
				{ 27, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Through The Dark Portal"]};
				{ 28, 32588, "", "=q3=Banana Charm", "=ds="..AL["King Mukla"]};
				{ 29, 32566, "", "=q3=Picnic Basket", "=ds="..AL["Rest and Relaxation"]};
				{ 30, 32542, "", "=q3=Imp in a Ball", "=ds="..AL["Fortune Telling"]};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6=#ud1#", "=q1="..AL["Heroes of Azeroth"]};
				{ 2, 23705, "", "=q4=Tabard of Flame", "=ds="..AL["Landro Longshot"]};
				{ 3, 23713, "", "=q4=Hippogryph Hatchling", "=ds="..AL["Thunderhead Hippogryph"]};
				{ 4, 23720, "", "=q4=Riding Turtle", "=ds="..AL["Saltwater Snapjaw"]};	
				{ 16, 0, "INV_Box_01", "=q6="..AL["UDE Items"], ""};
				{ 17, 38312, "", "=q4=Tabard of Brilliance", "=ds=#s7#"};
				{ 18, 23709, "", "=q4=Tabard of Frost", "=ds=#s7#"};
				{ 19, 38313, "", "=q4=Tabard of Fury", "=ds=#s7#"};
				{ 20, 38309, "", "=q4=Tabard of Nature", "=ds=#s7#"};
				{ 21, 38310, "", "=q4=Tabard of the Arcane", "=ds=#s7#"};
				{ 22, 38314, "", "=q4=Tabard of the Defender", "=ds=#s7#"};
				{ 23, 38314, "", "=q4=Tabard of the Defender", "=ds=#s7#"};
				{ 24, 38311, "", "=q4=Tabard of the Void", "=ds=#s7#"};
				{ 25, 49704, "", "=q4=Carved Ogre Idol", "=ds="};
				{ 26, 49703, "", "=q4=Perpetual Purple Firework", "=ds="};
			};
		};
		info = {
			name = AL["TCG Items"],
			module = moduleName, menu = "SETMENU",
		};
	}

		------------------
		--- Companions ---
		------------------

	AtlasLoot_Data["PetsMerchant"] = {
		["Normal"] = {
			{
				{ 1, 44984, "", "=q3=Ammen Vale Lashling", "=ds="..BabbleZone["Icecrown"]};
				{ 2, 54436, "", "=q3=Blue Clockwork Rocket Bot", "=ds="..BabbleZone["Dalaran"]};
				{ 3, 44970, "", "=q3=Dun Morogh Cub", "=ds="..BabbleZone["Icecrown"]};
				{ 4, 44973, "", "=q3=Durotar Scorpion", "=ds="..BabbleZone["Icecrown"]};
				{ 5, 44974, "", "=q3=Elwynn Lamb", "=ds="..BabbleZone["Icecrown"]};
				{ 6, 44982, "", "=q3=Enchanted Broom", "=ds="..BabbleZone["Icecrown"]};
				{ 7, 39973, "", "=q3=Ghostly Skull", "=ds="..BabbleZone["Dalaran"]};
				{ 8, 45002, "", "=q3=Mechanopeep", "=ds="..BabbleZone["Icecrown"]};
				{ 9, 44980, "", "=q3=Mulgore Hatchling", "=ds="..BabbleZone["Icecrown"]};
				{ 10, 45606, "", "=q3=Sen'jin Fetish", "=ds="..BabbleZone["Icecrown"]};
				{ 11, 44965, "", "=q3=Teldrassil Sproutling", "=ds="..BabbleZone["Icecrown"]};
				{ 12, 44971, "", "=q3=Tirisfal Batling", "=ds="..BabbleZone["Icecrown"]};
				{ 13, 44822, "", "=q1=Albino Snake", "=ds="..BabbleZone["Dalaran"]};
				{ 14, 11023, "", "=q1=Ancona Chicken", "=ds="..BabbleZone["Thousand Needles"]};
				{ 15, 10360, "", "=q1=Black Kingsnake", "=ds="..BabbleZone["Orgrimmar"]};
				{ 16, 10361, "", "=q1=Brown Snake", "=ds="..BabbleZone["Orgrimmar"]};
				{ 17, 29958, "", "=q1=Blue Dragonhawk Hatchling", "=ds="..BabbleZone["Netherstorm"]};
				{ 18, 29901, "", "=q1=Blue Moth Egg", "=ds="..BabbleZone["The Exodar"]};
				{ 19, 29364, "", "=q1=Brown Rabbit Crate", "=ds="..BabbleZone["Netherstorm"]};
				{ 20, 46398, "", "=q1=Calico Cat", "=ds="..BabbleZone["Dalaran"]};
				{ 21, 8485, "", "=q1=Cat Carrier (Bombay)", "=ds="..BabbleZone["Elwynn Forest"]};
				{ 22, 8486, "", "=q1=Cat Carrier (Cornish Rex)", "=ds="..BabbleZone["Elwynn Forest"]};
				{ 23, 8487, "", "=q1=Cat Carrier (Orange Tabby)", "=ds="..BabbleZone["Elwynn Forest"]};
				{ 24, 8490, "", "=q1=Cat Carrier (Siamese)", "=ds="..BabbleZone["Netherstorm"]};
				{ 25, 8488, "", "=q1=Cat Carrier (Silver Tabby)", "=ds="..BabbleZone["Elwynn Forest"]};
				{ 26, 8489, "", "=q1=Cat Carrier (White Kitten)", "=ds="..BabbleZone["Stormwind City"]};
				{ 27, 10393, "", "=q1=Cockroach", "=ds="..BabbleZone["Netherstorm"].." / "..BabbleZone["Undercity"]};
				{ 28, 10392, "", "=q1=Crimson Snake", "=ds="..BabbleZone["Netherstorm"].." / "..BabbleZone["Orgrimmar"]};
				{ 29, 29953, "", "=q1=Golden Dragonhawk Hatchling", "=ds="..BabbleZone["Eversong Woods"]};
				{ 30, 8500, "", "=q1=Great Horned Owl", "=ds="..BabbleZone["Darnassus"]};
			};
			{
				{ 1, 8501, "", "=q1=Hawk Owl", "=ds="..BabbleZone["Darnassus"]};
				{ 2, 29363, "", "=q1=Mana Wyrmling", "=ds="..BabbleZone["Netherstorm"]};
				{ 3, 48120, "", "=q1=Obsidian Hatchling", "=ds="..BabbleZone["Dalaran"]};
				{ 4, 8496, "", "=q1=Parrot Cage (Cockatiel)", "=ds="..BabbleZone["Booty Bay"]};
				{ 5, 8492, "", "=q1=Parrot Cage (Green Wing Macaw)", "=ds="..BabbleZone["The Deadmines"]};
				{ 6, 8495, "", "=q1=Parrot Cage (Senegal)", "=ds="..BabbleZone["Netherstorm"].." / "..BabbleZone["Booty Bay"]};
				{ 7, 10394, "", "=q1=Prairie Dog Whistle", "=ds="..BabbleZone["Thunder Bluff"]};
				{ 8, 8497, "", "=q1=Rabbit Crate (Snowshoe)", "=ds="..BabbleZone["Dun Morogh"]};
				{ 9, 29956, "", "=q1=Red Dragonhawk Hatchling", "=ds="..BabbleZone["Silvermoon City"]};
				{ 10, 29902, "", "=q1=Red Moth Egg", "=ds="..BabbleZone["Netherstorm"]};
				{ 11, 29957, "", "=q1=Silver Dragonhawk Hatchling", "=ds="..BabbleZone["Silvermoon City"]};
				{ 12, 11026, "", "=q1=Tree Frog Box", "=ds="..BabbleZone["Darkmoon Faire"]};
				{ 13, 29904, "", "=q1=White Moth Egg", "=ds="..BabbleZone["The Exodar"]};
				{ 14, 11027, "", "=q1=Wood Frog Box", "=ds="..BabbleZone["Darkmoon Faire"]};
				{ 15, 29903, "", "=q1=Yellow Moth Egg", "=ds="..BabbleZone["The Exodar"]};
			};
		};
		info = {
			name = AL["Merchant Sold Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsQuest"] = {
		["Normal"] = {
			{
				{
					{ 1, 45022, "", "=q3=Argent Gruntling", "=ds=#e13# =ec1=#m6#"};
					{ 1, 44998, "", "=q3=Argent Squire", "=ds=#e13# =ec1=#m7#"};
				};
				{ 2, 35350, "", "=q3=Chuck's Bucket", "=q1="..AL["Fishing Daily Reward"]..": "..BabbleZone["Terokkar Forest"]};
				{ 3, 33818, "", "=q3=Muckbreath's Bucket", "=q1="..AL["Fishing Daily Reward"]..": "..BabbleZone["Terokkar Forest"]};
				{ 4, 12529, "", "=q3=Smolderweb Carrier", "=q1=#m4#: #QUESTID:4862#"};
				{ 5, 35349, "", "=q3=Snarly's Bucket", "=q1="..AL["Fishing Daily Reward"]..": "..BabbleZone["Terokkar Forest"]};
				{ 6, 44983, "", "=q3=Strand Crawler", "=q1="..AL["Fishing Daily Reward"]..": "..BabbleZone["Dalaran"]};
				{ 7, 33816, "", "=q3=Toothy's Bucket", "=q1="..AL["Fishing Daily Reward"]..": "..BabbleZone["Terokkar Forest"]};
				{ 8, 12264, "", "=q3=Worg Carrier", "=q1=#m4#: #QUESTID:4729#"};
				{ 9, 19450, "", "=q1=A Jubling's Tiny Home", "=q1=#m4#: #QUESTID:7946#"};
				{ 10, 65661, "", "=q1=Blue Mini Jouster", "=q1=#m4#: #QUESTID:25560#"};
				{ 11, 66067, "", "=q1=Brazie's Sunflower Seeds", "=q1=#m4#: #QUESTID:28748#"};
				{ 12, 11110, "", "=q1=Chicken Egg", "=q1=#m4#: #QUESTID:3861#"};
				{ 13, 65662, "", "=q1=Gold Mini Jouster", "=q1=#m4#: #QUESTID:25560#"};
				{ 14, 10398, "", "=q1=Mechanical Chicken", "=q1=#m4#: #QUESTID:3721#"};
				{ 15, 31760, "", "=q1=Miniwing", "=q1=#m4#: #QUESTID:10898#"};
				{ 16, 11474, "", "=q1=Sprite Darter Egg", "=q1=#m4#: #QUESTID:4298#"};
				{ 17, 66080, "", "=q1=Tiny Flamefly", "=q1=#m4#: #QUESTID:28415#"};
				{ 18, 46325, "", "=q1=Withers", "=q1=#m4#: #QUESTID:13570#"};
			};
		};
		info = {
			name = AL["Quest Reward Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsCrafted"] = {
		["Normal"] = {
			{
				{ 1, 60847, "", "=q4=Crawling Claw", "=q2=#p25#"};
				{ 2, 64372, "", "=q3=Clockwork Gnome", "=q2=#p25#"};
				{ 3, 60216, "", "=q3=De-Weaponized Mechanical Companion", "=q2=#p5#"};
				{ 4, 67282, "", "=q3=Elementium Geode", "=q2=#p23#"};
				{ 5, 67274, "", "=q3=Enchanted Lantern", "=q2=#p4#"};
				{ 6, 60955, "", "=q3=Fossilized Hatchling", "=q2=#p25#"};
				{ 7, 67275, "", "=q3=Magic Lamp", "=q2=#p4#"};
				{ 8, 59597, "", "=q3=Personal World Destroyer", "=q2=#p5#"};
				{ 9, 15996, "", "=q1=Lifelike Mechanical Toad", "=q2=#p5#"};
				{ 10, 11826, "", "=q1=Lil' Smoky", "=q2=#p5#"};
				{ 11, 4401, "", "=q1=Mechanical Squirrel Box", "=q2=#p5#"};
				{ 12, 11825, "", "=q1=Pet Bombling", "=q2=#p5#"};
				{ 13, 21277, "", "=q1=Tranquil Mechanical Yeti", "=q2=#p5#"};
			};
		};
		info = {
			name = AL["Crafted Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsAchievementFaction"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Achievement Reward"], ""};
				{ 2, 63398, "", "=q3=Armadillo Pup", "#ACHIEVEMENTID:5144#"};
				{ 3, 63138, "", "=q3=Dark Phoenix Hatchling", "#ACHIEVEMENTID:5125#"};
				{
					{ 4, 65364, "", "=q3=Guild Herald", "#ACHIEVEMENTID:5201#, =ec1="..BabbleFaction["Horde"]};
					{ 4, 65363, "", "=q3=Guild Herald", "#ACHIEVEMENTID:5201#, =ec1="..BabbleFaction["Alliance"]};
				};
				{
					{ 5, 65362, "", "=q3=Guild Page", "#ACHIEVEMENTID:5179#, =ec1="..BabbleFaction["Horde"]};
					{ 5, 65361, "", "=q3=Guild Page", "#ACHIEVEMENTID:5031#, =ec1="..BabbleFaction["Alliance"]};
				};
				{ 6, 44738, "", "=q3=Kirin Tor Familiar", "#ACHIEVEMENTID:1956#"};
				{ 7, 44841, "", "=q3=Little Fawn's Salt Lick", "#ACHIEVEMENTID:2516#"};
				{ 8, 49912, "", "=q3=Perky Pug", "#ACHIEVEMENTID:4478#"};
				{ 9, 40653, "", "=q3=Reeking Pet Carrier", "#ACHIEVEMENTID:1250#"};
				{
					{ 10, 44810, "", "=q3=Turkey Cage", "#ACHIEVEMENTID:3656#, =ec1="..BabbleFaction["Horde"]};
					{ 10, 44810, "", "=q3=Turkey Cage", "#ACHIEVEMENTID:3478#, =ec1="..BabbleFaction["Alliance"]};
				};
				{ 11, 60869, "", "=q1=Pebble", "#ACHIEVEMENTID:5449#"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Faction"], ""};
				{ 17, 38628, "", "=q3=Nether Ray Fry", "=ds="..BabbleFaction["Sha'tari Skyguard"]};
				{ 18, 44723, "", "=q3=Nurtured Penguin Egg", "=ds="..BabbleFaction["The Kalu'ak"]};
				{
					{ 19, 64996, "", "=q3=Rustberg Gull", "=ds="..BabbleFaction["Hellscream's Reach"].."  =ec1="..BabbleFaction["Horde"]};
					{ 19, 63355, "", "=q3=Rustberg Gull", "=ds="..BabbleFaction["Baradin's Wardens"].."  =ec1="..BabbleFaction["Alliance"]};
				};
				{
					{ 20, 46821, "", "=q3=Shimmering Wyrmling", "=ds="..BabbleFaction["The Sunreavers"].."  =ec1="..BabbleFaction["Horde"]};
					{ 20, 46820, "", "=q3=Shimmering Wyrmling", "=ds="..BabbleFaction["The Silver Covenant"].."  =ec1="..BabbleFaction["Alliance"]};
				};
				{ 21, 34478, "", "=q3=Tiny Sporebat", "=ds="..BabbleFaction["Sporeggar"]};
				{ 22, 39898, "", "=q1=Cobra Hatchling", "=ds="..BabbleFaction["The Oracles"]};
				{ 23, 44721, "", "=q1=Proto-Drake Whelp", "=ds="..BabbleFaction["The Oracles"]};
				{ 24, 39896, "", "=q1=Tickbird Hatchling", "=ds="..BabbleFaction["The Oracles"]};
				{ 25, 39899, "", "=q1=White Tickbird Hatchling", "=ds="..BabbleFaction["The Oracles"]};
			};
		};
		info = {
			name = AL["Achievement & Faction Reward Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsRare"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6=#z17#", ""};
				{ 2, 8494, "", "=q4=Parrot Cage (Hyacinth Macaw)", "=ds="..BabbleZone["Stranglethorn Vale"]};
				{ 3, 64403, "", "=q3=Fox Kit", "=ds="..BabbleZone["Tol Barad Peninsula"]};
				{ 4, 43698, "", "=q3=Giant Sewer Rat", "#ACHIEVEMENTID:1958#, =q1="..BabbleZone["Dalaran"]};
				{ 5, 34535, "", "=q1=Azure Whelpling", "=ds="..BabbleZone["Winterspring"]};
				{ 6, 29960, "", "=q1=Captured Firefly", "=ds="..BabbleZone["Zangarmarsh"]};
				{ 7, 8491, "", "=q1=Cat Carrier (Black Tabby)", "=ds="..BabbleZone["Silverpine Forest"]};
				{ 8, 10822, "", "=q1=Dark Whelpling", "=ds="..BabbleZone["Wetlands"].." / "..BabbleZone["Badlands"].." / "..BabbleZone["Burning Steppes"]};
				{ 9, 48112, "", "=q1=Darting Hatchling", "=ds="..BabbleZone["Dustwallow Marsh"]};
				{ 10, 20769, "", "=q1=Disgusting Oozeling", "=ds=#e13#"};
				{ 11, 48116, "", "=q1=Gundrak Hatchling", "=ds="..BabbleZone["Zul'Drak"]};
				{ 12, 48118, "", "=q1=Leaping Hatchling", "=ds="..BabbleZone["Northern Barrens"]};
				{ 13, 27445, "", "=q1=Magical Crawdad Box", "=ds="..BabbleZone["Terokkar Forest"]};
				{ 14, 66076, "", "=q1=Mr. Grubbs", "=q2="..AL["Hidden Stash"]..", =q1="..BabbleZone["Eastern Plaguelands"]};
				{ 15, 48122, "", "=q1=Ravasaur Hatchling", "=ds="..BabbleZone["Un'Goro Crater"]};
				{ 16, 48124, "", "=q1=Razormaw Hatchling", "=ds="..BabbleZone["Wetlands"]};
				{ 17, 48126, "", "=q1=Razzashi Hatchling", "=ds="..BabbleZone["Northern Stranglethorn"].." / "..BabbleZone["The Cape of Stranglethorn"]};
				{ 18, 8499, "", "=q1=Tiny Crimson Whelpling", "=ds="..BabbleZone["Wetlands"]};
				{ 19, 8498, "", "=q1=Tiny Emerald Whelpling", "=ds="..BabbleZone["Feralas"]};
				{ 20, 64494, "", "=q1=Tiny Shale Spider", "=q2="..AL["Jadefang"]..", =q1="..BabbleZone["Deepholm"]};	
				{ 22, 0, "INV_Box_01", "=q6="..AL["Dungeon/Raid"], ""};
				{ 23, 33993, "", "=q3=Mojo", "=q1="..BabbleZone["Zul'Aman"]};
				{ 24, 35504, "", "=q3=Phoenix Hatchling", "=q2="..BabbleBoss["Kael'thas Sunstrider"]..", =q1="..BabbleZone["Magisters' Terrace"]};
				{ 25, 48114, "", "=q1=Deviate Hatchling", "=q2="..AL["Deviate Ravager/Deviate Guardian"]..", =q1="..BabbleZone["Wailing Caverns"]};
			};
		};
		info = {
			name = AL["Rare Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsEvent"] = {
		["Normal"] = {
			{
				{ 1, 23083, "", "=q3=Captured Flame", "=ds="..AL["Midsummer Fire Festival"]};
				{ 2, 46545, "", "=q3=Curious Oracle Hatchling", "=ds="..AL["Children's Week"]};
				{ 3, 46544, "", "=q3=Curious Wolvar Pup", "=ds="..AL["Children's Week"]};
				{ 4, 32616, "", "=q3=Egbert's Egg", "=ds="..AL["Children's Week"]};
				{ 5, 32622, "", "=q3=Elekk Training Collar", "=ds="..AL["Children's Week"]};
				{ 6, 53641, "", "=q3=Ice Chip", "=ds="..AL["Midsummer Fire Festival"]};
				{ 7, 46707, "", "=q3=Pint-Sized Pink Pachyderm", "=ds="..AL["Brewfest"]};
				{ 8, 34955, "", "=q3=Scorched Stone", "=ds="..AL["Midsummer Fire Festival"]};
				{ 9, 33154, "", "=q3=Sinister Squashling", "=ds="..AL["Hallow's End"]};
				{ 10, 32617, "", "=q3=Sleepy Willy", "=ds="..AL["Children's Week"]};
				{ 11, 44794, "", "=q3=Spring Rabbit's Foot", "=ds="..AL["Noblegarden"]};
				{ 12, 32233, "", "=q3=Wolpertinger's Tankard", "=ds="..AL["Brewfest"]};
				{ 13, 50446, "", "=q3=Toxic Wasteling", "=ds="..AL["Love is in the Air"]};
				{ 16, 21301, "", "=q1=Green Helper Box", "=ds="..AL["Feast of Winter Veil"]};
				{ 17, 21308, "", "=q1=Jingling Bell", "=ds="..AL["Feast of Winter Veil"]};
				{ 18, 23007, "", "=q1=Piglet's Collar", "=ds="..AL["Children's Week"]};
				{ 19, 23015, "", "=q1=Rat Cage", "=ds="..AL["Children's Week"]};
				{ 20, 21305, "", "=q1=Red Helper Box", "=ds="..AL["Feast of Winter Veil"]};
				{ 21, 21309, "", "=q1=Snowman Kit", "=ds="..AL["Feast of Winter Veil"]};
				{ 22, 22235, "", "=q1=Truesilver Shafted Arrow", "=ds="..AL["Love is in the Air"]};
				{ 23, 23002, "", "=q1=Turtle Box", "=ds="..AL["Children's Week"]};
			};
		};
		info = {
			name = BabbleInventory["Companions"].." - "..AL["World Events"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsPromotionalCardGame"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Promotional Companions"], ""};
				{ 2, 20371, "", "=q3=Blue Murloc Egg", "#ACHIEVEMENTID:411#"};
				{ 3, 49646, "", "=q3=Core Hound Pup", "=ds=#e13#"};
				{ 4, 13584, "", "=q3=Diablo Stone", "#ACHIEVEMENTID:662#"};
				{ 5, 39286, "", "=q3=Frosty's Collar", "#ACHIEVEMENTID:683#"};
				{ 6, 46802, "", "=q3=Heavy Murloc Egg", "#ACHIEVEMENTID:3536#"};
				{ 7, 62540, "", "=q3=Lil' Deathwing", "#ACHIEVEMENTID:5377#"};
				{ 8, 30360, "", "=q3=Lurky's Egg", "=q2="..AL["Collector's Edition"]};
				{ 9, 56806, "", "=q3=Mini Thor", "#ACHIEVEMENTID:4824#"};
				{ 10, 45180, "", "=q3=Murkimus' Little Spear", "#ACHIEVEMENTID:3618#"};
				{ 11, 25535, "", "=q3=Netherwhelp's Collar", "#ACHIEVEMENTID:665#"};
				{ 12, 13583, "", "=q3=Panda Collar", "#ACHIEVEMENTID:663#"};
				{ 13, 22114, "", "=q3=Pink Murloc Egg", "=ds=#e13#"};
				{ 14, 67418, "", "=q3=Smoldering Murloc Egg", "#ACHIEVEMENTID:5378#"};
				{ 15, 39656, "", "=q3=Tyrael's Hilt", "#ACHIEVEMENTID:414#"};
				{ 16, 13582, "", "=q3=Zergling Leash", "#ACHIEVEMENTID:664#"};
				{ 18, 0, "INV_Box_01", "=q6="..AL["Card Game Companions"], ""};
				{ 19, 34493, "", "=q4=Dragon Kite", "=q2="..AL["Card Game Item"]};
				{ 20, 23713, "", "=q4=Hippogryph Hatchling", "=q2="..AL["Card Game Item"]};
				{ 21, 49287, "", "=q4=Tuskarr Kite", "=q2="..AL["Card Game Item"]};
				{ 22, 32588, "", "=q3=Banana Charm", "=q2="..AL["Card Game Item"]};
				{ 23, 67128, "", "=q3=Landro's Lil' XT", "=q2="..AL["Card Game Item"]};
				{ 24, 34492, "", "=q3=Rocket Chicken", "=q2="..AL["Card Game Item"]};
				{ 25, 38050, "", "=q3=Soul-Trader Beacon", "=q2="..AL["Card Game Item"]};
				{ 26, 49343, "", "=q3=Spectral Tiger Cub", "=q2="..AL["Card Game Item"]};
			};
		};
		info = {
			name = AL["Promotional Companions"].." / "..AL["Card Game Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsRemoved"] = {
		["Normal"] = {
			{
				{ 1, 34425, "", "=q3=Clockwork Rocket Bot", "#ACHIEVEMENTID:1705#"};
				{ 2, 37297, "", "=q3=Gold Medallion", "=ds=#e13#"};
				{ 3, 41133, "", "=q3=Unhatched Mr. Chilly", "=ds=#e13#"};
				{ 4, 38658, "", "=q3=Vampiric Batling", "#ACHIEVEMENTID:2456#, =q1="..BabbleZone["Karazhan"]};
				{ 5, 46767, "", "=q3=Warbot Ignition Key", "=ds=#e13#"};
				{ 6, 44819, "", "=q1=Baby Blizzard Bear", "#ACHIEVEMENTID:2398#"};
				{ 7, 49362, "", "=q1=Onyxian Whelpling", "#ACHIEVEMENTID:4400#"};
			};
		};
		info = {
			name = AL["Unobtainable Companions"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsPetStore"] = {
		["Normal"] = {
			{
				{ 1, 49662, "", "=q3=Gryphon Hatchling", "=ds=#e13#"};
				{ 2, 49693, "", "=q3=Lil' Phylactery", "=ds=#e13#"};
				{ 3, 68385, "", "=q3=Lil' Ragnaros", "=ds=#e13#"};
				{ 4, 54847, "", "=q3=Lil' XT", "=ds=#e13#"};
				{
					{ 5, 68619, "", "=q3=Moonkin Hatchling", "=ds=#e13#"};
					{ 5, 68618, "", "=q3=Moonkin Hatchling", "=ds=#e13#"};
				};
				{ 6, 49665, "", "=q3=Pandaren Monk", "=ds=#e13#"};
				{ 7, 49663, "", "=q3=Wind Rider Cub", "=ds=#e13#"};
			};
		};
		info = {
			name = AL["Companion Store"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsAccessories"] = {
		["Normal"] = {
			{
				{ 1, 47541, "", "=q3=Argent Pony Bridle", "=ds="};
				{ 2, 38291, "", "=q3=Ethereal Mutagen", "=ds="};
				{ 3, 35223, "", "=q3=Papa Hummel's Old-Fashioned Pet Biscuit", "=ds="};
				{ 4, 37431, "", "=q2=Fetch Ball", "=ds="};
				{ 5, 43626, "", "=q2=Happy Pet Snack", "=ds="};
				{ 6, 43352, "", "=q2=Pet Grooming Kit", "=ds="};
				{ 7, 44820, "", "=q1=Red Ribbon Pet Leash", "=ds="};
				{ 8, 37460, "", "=q1=Rope Pet Leash", "=ds="};
			};
		};
		info = {
			name = AL["Companion Accessories"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

	AtlasLoot_Data["PetsCata"] = {
		["Normal"] = {
			{
				{ 1, 60847, "", "=q4=Crawling Claw", "=q2=#p25#"};
				{ 2, 63398, "", "=q3=Armadillo Pup", "#ACHIEVEMENTID:5144#"};
				{ 3, 64372, "", "=q3=Clockwork Gnome", "=q2=#p25#"};
				{ 4, 63138, "", "=q3=Dark Phoenix Hatchling", "#ACHIEVEMENTID:5125#"};
				{ 5, 60216, "", "=q3=De-Weaponized Mechanical Companion", "=q2=#p5#"};
				{ 6, 67282, "", "=q3=Elementium Geode", "=q2=#p23#"};
				{ 7, 67274, "", "=q3=Enchanted Lantern", "=q2=#p4#"};
				{ 8, 60955, "", "=q3=Fossilized Hatchling", "=q2=#p25#"};
				{ 9, 64403, "", "=q3=Fox Kit", "=ds="..BabbleZone["Tol Barad Peninsula"]};
				{
					{ 10, 65364, "", "=q3=Guild Herald", "#ACHIEVEMENTID:5201#, =ec1="..BabbleFaction["Horde"]};
					{ 10, 65363, "", "=q3=Guild Herald", "#ACHIEVEMENTID:5201#, =ec1="..BabbleFaction["Alliance"]};
				};
				{
					{ 11, 65362, "", "=q3=Guild Page", "#ACHIEVEMENTID:5179#, =ec1="..BabbleFaction["Horde"]};
					{ 11, 65361, "", "=q3=Guild Page", "#ACHIEVEMENTID:5031#, =ec1="..BabbleFaction["Alliance"]};
				};
				{ 12, 62540, "", "=q3=Lil' Deathwing", "#ACHIEVEMENTID:5377#"};
				{ 13, 67275, "", "=q3=Magic Lamp", "=q2=#p4#"};
				{ 14, 59597, "", "=q3=Personal World Destroyer", "=q2=#p5#"};
				{
					{ 15, 64996, "", "=q3=Rustberg Gull", "=ds="..BabbleFaction["Hellscream's Reach"].."  =ec1="..BabbleFaction["Horde"]};
					{ 15, 63355, "", "=q3=Rustberg Gull", "=ds="..BabbleFaction["Baradin's Wardens"].."  =ec1="..BabbleFaction["Alliance"]};
				};
				{ 16, 67418, "", "=q3=Smoldering Murloc Egg", "#ACHIEVEMENTID:5378#"};
				{ 17, 65661, "", "=q1=Blue Mini Jouster", "=q1=#m4#: #QUESTID:25560#"};
				{ 18, 66067, "", "=q1=Brazie's Sunflower Seeds", "=q1=#m4#: #QUESTID:28748#"};
				{ 19, 65662, "", "=q1=Gold Mini Jouster", "=q1=#m4#: #QUESTID:25560#"};
				{ 20, 66076, "", "=q1=Mr. Grubbs", "=q2="..AL["Hidden Stash"]..", =q1="..BabbleZone["Eastern Plaguelands"]};
				{ 21, 60869, "", "=q1=Pebble", "#ACHIEVEMENTID:5449#"};
				{ 22, 64494, "", "=q1=Tiny Shale Spider", "=q2="..AL["Jadefang"]..", =q1="..BabbleZone["Deepholm"]};
				{ 23, 46325, "", "=q1=Withers", "=q1="..AL["Quest Reward"]..": "..BabbleZone["Darkshore"]};
			};
		};
		info = {
			name = BabbleInventory["Companions"].." - "..AL["Cataclysm"],
			module = moduleName, menu = "PETMENU", instance = "Pets",
		};
	}

		--------------
		--- Mounts ---
		--------------

	AtlasLoot_Data["MountsAlliance"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tournaments_symbol_nightelf", "=q6="..BabbleFaction["Darnassus"].." #j30#", "=ec1=#m7#"};
				{ 2, 18766, "", "=q4=Reins of the Swift Frostsaber", "=ds=#e26#"};
				{ 3, 18767, "", "=q4=Reins of the Swift Mistsaber", "=ds=#e26#"};
				{ 4, 18902, "", "=q4=Reins of the Swift Stormsaber", "=ds=#e26#"};
				{ 5, 8632, "", "=q3=Reins of the Spotted Frostsaber", "=ds=#e26#"};
				{ 6, 47100, "", "=q3=Reins of the Striped Dawnsaber", "=ds=#e26#"};
				{ 7, 8631, "", "=q3=Reins of the Striped Frostsaber", "=ds=#e26#"};
				{ 8, 8629, "", "=q3=Reins of the Striped Nightsaber", "=ds=#e26#"};
				{ 16, 0, "inv_misc_tournaments_symbol_gnome", "=q6="..BabbleFaction["Gnomeregan"].." #j30#", "=ec1=#m7#"};
				{ 17, 18772, "", "=q4=Swift Green Mechanostrider", "=ds=#e26#"};
				{ 18, 18773, "", "=q4=Swift White Mechanostrider", "=ds=#e26#"};
				{ 19, 18774, "", "=q4=Swift Yellow Mechanostrider", "=ds=#e26#"};
				{ 20, 8595, "", "=q3=Blue Mechanostrider", "=ds=#e26#"};
				{ 21, 13321, "", "=q3=Green Mechanostrider", "=ds=#e26#"};
				{ 22, 8563, "", "=q3=Red Mechanostrider", "=ds=#e26#"};
				{ 23, 13322, "", "=q3=Unpainted Mechanostrider", "=ds=#e26#"};
			};
			{
				{ 1, 0, "inv_misc_tournaments_symbol_dwarf", "=q6="..BabbleFaction["Ironforge"].." #j30#", "=ec1=#m7#"};
				{ 2, 18786, "", "=q4=Swift Brown Ram", "=ds=#e26#"};
				{ 3, 18787, "", "=q4=Swift Gray Ram", "=ds=#e26#"};
				{ 4, 18785, "", "=q4=Swift White Ram", "=ds=#e26#"};
				{ 5, 5872, "", "=q3=Brown Ram", "=ds=#e26#"};
				{ 6, 5864, "", "=q3=Gray Ram", "=ds=#e26#"};
				{ 7, 5873, "", "=q3=White Ram", "=ds=#e26#"};
				{ 9, 0, "inv_misc_tournaments_symbol_draenei", "=q6="..BabbleFaction["Exodar"].." #j30#", "=ec1=#m7#"};
				{ 10, 29745, "", "=q4=Great Blue Elekk", "=ds=#e26#"};
				{ 11, 29746, "", "=q4=Great Green Elekk", "=ds=#e26#"};
				{ 12, 29747, "", "=q4=Great Purple Elekk", "=ds=#e26#"};
				{ 13, 28481, "", "=q3=Brown Elekk", "=ds=#e26#"};
				{ 14, 29744, "", "=q3=Gray Elekk", "=ds=#e26#"};
				{ 15, 29743, "", "=q3=Purple Elekk", "=ds=#e26#"};
				{ 16, 0, "inv_misc_tournaments_symbol_human", "=q6="..BabbleFaction["Stormwind"].." #j30#", "=ec1=#m7#"};
				{ 17, 18777, "", "=q4=Swift Brown Steed", "=ds=#e26#"};
				{ 18, 18776, "", "=q4=Swift Palomino", "=ds=#e26#"};
				{ 19, 18778, "", "=q4=Swift White Steed", "=ds=#e26#"};
				{ 20, 2411, "", "=q3=Black Stallion Bridle", "=ds=#e26#"};
				{ 21, 5656, "", "=q3=Brown Horse Bridle", "=ds=#e26#"};
				{ 22, 5655, "", "=q3=Chestnut Mare Bridle", "=ds=#e26#"};
				{ 23, 2414, "", "=q3=Pinto Bridle", "=ds=#e26#"};
			};
			{
				{ 1, 0, "INV_BannerPVP_02", "=q6="..AL["Alliance Flying Mounts"], "=ec1=#m7#"};
				{ 2, 25473, "", "=q4=Swift Blue Gryphon", "=ds=#e27#"};
				{ 3, 25528, "", "=q4=Swift Green Gryphon", "=ds=#e27#"};
				{ 4, 25529, "", "=q4=Swift Purple Gryphon", "=ds=#e27#"};
				{ 5, 25527, "", "=q4=Swift Red Gryphon", "=ds=#e27#"};
				{ 6, 25471, "", "=q3=Ebon Gryphon", "=ds=#e27#"};
				{ 7, 25470, "", "=q3=Golden Gryphon", "=ds=#e27#"};
				{ 8, 25472, "", "=q3=Snowy Gryphon", "=ds=#e27#"};
				{ 16, 0, "INV_BannerPVP_02", "=q6="..BabbleFaction["Kurenai"].." #j30#", "=ec1=#m7#"};
				{ 17, 29227, "", "=q4=Reins of the Cobalt War Talbuk", "=ds=#e26#"};
				{ 18, 29229, "", "=q4=Reins of the Silver War Talbuk", "=ds=#e26#"};
				{ 19, 29230, "", "=q4=Reins of the Tan War Talbuk", "=ds=#e26#"};
				{ 20, 29231, "", "=q4=Reins of the White War Talbuk", "=ds=#e26#"};
				{ 21, 31830, "", "=q4=Reins of the Cobalt Riding Talbuk", "=ds=#e26#"};
				{ 22, 31832, "", "=q4=Reins of the Silver Riding Talbuk", "=ds=#e26#"};
				{ 23, 31834, "", "=q4=Reins of the Tan Riding Talbuk", "=ds=#e26#"};
				{ 24, 31836, "", "=q4=Reins of the White Riding Talbuk", "=ds=#e26#"};
			};
			{
				{ 1, 0, "INV_BannerPVP_02", "=q6="..BabbleZone["Dalaran"], "=ec1=#m7#"};
				{ 2, 44225, "", "=q4=Reins of the Armored Brown Bear", "=ds=#e26#"};
				{ 3, 44230, "", "=q4=Reins of the Wooly Mammoth", "=ds=#e26#"};
				{ 4, 44235, "", "=q4=Reins of the Traveler's Tundra Mammoth", "=ds=#e26#"};
				{ 5, 44689, "", "=q4=Armored Snowy Gryphon", "=ds=#e27#"};
				{ 16, 0, "INV_BannerPVP_02", "=q6="..BabbleFaction["Wintersaber Trainers"].." #j30#", "=ec1=#m7#"};
				{ 17, 13086, "", "=q4=Reins of the Winterspring Frostsaber", "=ds=#e26#"};
				{ 19, 0, "INV_BannerPVP_02", "=q6="..BabbleFaction["The Silver Covenant"].." #j30#", "=ec1=#m7#"};
				{ 20, 46815, "", "=q4=Quel'dorei Steed", "=ds=#e26#"};
				{ 21, 46813, "", "=q4=Silver Covenant Hippogryph", "=ds=#e27#"};
			};
		};
		info = {
			name = AL["Alliance Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsHorde"] = {
		["Normal"] = {
			{
				{ 1, 0, "inv_misc_tournaments_symbol_orc", "=q6="..BabbleFaction["Orgrimmar"].." #j30#", "=ec1=#m6#"};
				{ 2, 18796, "", "=q4=Horn of the Swift Brown Wolf", "=ds=#e26#"};
				{ 3, 18798, "", "=q4=Horn of the Swift Gray Wolf", "=ds=#e26#"};
				{ 4, 18797, "", "=q4=Horn of the Swift Timber Wolf", "=ds=#e26#"};
				{ 5, 46099, "", "=q3=Horn of the Black Wolf", "=ds=#e26#"};
				{ 6, 5668, "", "=q3=Horn of the Brown Wolf", "=ds=#e26#"};
				{ 7, 5665, "", "=q3=Horn of the Dire Wolf", "=ds=#e26#"};
				{ 8, 1132, "", "=q3=Horn of the Timber Wolf", "=ds=#e26#"};
				{ 10, 0, "inv_misc_tournaments_symbol_orc", "=q6="..BabbleFaction["Bilgewater Cartel"].." #j30#", "=ec1=#m6#"};
				{ 11, 62462, "", "=q4=Goblin Turbo-Trike Key", "=ds=#e26#"};
				{ 12, 62461, "", "=q3=Goblin Trike Key", "=ds=#e26#"};
				{ 16, 0, "inv_misc_tournaments_symbol_bloodelf", "=q6="..BabbleFaction["Silvermoon City"].." #j30#", "=ec1=#m6#"};
				{ 17, 29223, "", "=q4=Swift Green Hawkstrider", "=ds=#e26#"};
				{ 18, 28936, "", "=q4=Swift Pink Hawkstrider", "=ds=#e26#"};
				{ 19, 29224, "", "=q4=Swift Purple Hawkstrider", "=ds=#e26#"};
				{ 20, 29221, "", "=q3=Black Hawkstrider", "=ds=#e26#"};
				{ 21, 29220, "", "=q3=Blue Hawkstrider", "=ds=#e26#"};
				{ 22, 29222, "", "=q3=Purple Hawkstrider", "=ds=#e26#"};
				{ 23, 28927, "", "=q3=Red Hawkstrider", "=ds=#e26#"};
			};
			{
				{ 1, 0, "inv_misc_tournaments_symbol_troll", "=q6="..BabbleFaction["Darkspear Trolls"].." #j30#", "=ec1=#m6#"};
				{ 2, 18788, "", "=q4=Swift Blue Raptor", "=ds=#e26#"};
				{ 3, 18789, "", "=q4=Swift Olive Raptor", "=ds=#e26#"};
				{ 4, 18790, "", "=q4=Swift Orange Raptor", "=ds=#e26#"};
				{ 5, 8588, "", "=q3=Whistle of the Emerald Raptor", "=ds=#e26#"};
				{ 6, 8591, "", "=q3=Whistle of the Turquoise Raptor", "=ds=#e26#"};
				{ 7, 8592, "", "=q3=Whistle of the Violet Raptor", "=ds=#e26#"};
				{ 9, 0, "inv_misc_tournaments_symbol_tauren", "=q6="..BabbleFaction["Thunder Bluff"].." #j30#", "=ec1=#m6#"};
				{ 10, 18794, "", "=q4=Great Brown Kodo", "=ds=#e26#"};
				{ 11, 18795, "", "=q4=Great Gray Kodo", "=ds=#e26#"};
				{ 12, 18793, "", "=q4=Great White Kodo", "=ds=#e26#"};
				{ 13, 15290, "", "=q3=Brown Kodo", "=ds=#e26#"};
				{ 14, 15277, "", "=q3=Gray Kodo", "=ds=#e26#"};
				{ 15, 46100, "", "=q3=White Kodo", "=ds=#e26#"};
				{ 16, 0, "inv_misc_tournaments_symbol_scourge", "=q6="..BabbleFaction["Undercity"].." #j30#", "=ec1=#m6#"};
				{ 17, 13334, "", "=q4=Green Skeletal Warhorse", "=ds=#e26#"};
				{ 18, 47101, "", "=q4=Ochre Skeletal Warhorse", "=ds=#e26#"};
				{ 19, 18791, "", "=q4=Purple Skeletal Warhorse", "=ds=#e26#"};
				{ 20, 46308, "", "=q3=Black Skeletal Horse", "=ds=#e26#"};
				{ 21, 13332, "", "=q3=Blue Skeletal Horse", "=ds=#e26#"};
				{ 22, 13333, "", "=q3=Brown Skeletal Horse", "=ds=#e26#"};
				{ 23, 13331, "", "=q3=Red Skeletal Horse", "=ds=#e26#"};
			};
			{
				{ 1, 0, "INV_BannerPVP_01", "=q6="..AL["Horde Flying Mounts"], "=ec1=#m6#"};
				{ 2, 25531, "", "=q4=Swift Green Wind Rider", "=ds=#e27#"};
				{ 3, 25533, "", "=q4=Swift Purple Wind Rider", "=ds=#e27#"};
				{ 4, 25477, "", "=q4=Swift Red Wind Rider", "=ds=#e27#"};
				{ 5, 25532, "", "=q4=Swift Yellow Wind Rider", "=ds=#e27#"};
				{ 6, 25475, "", "=q3=Blue Wind Rider", "=ds=#e27#"};
				{ 7, 25476, "", "=q3=Green Wind Rider", "=ds=#e27#"};
				{ 8, 25474, "", "=q3=Tawny Wind Rider", "=ds=#e27#"};
				{ 16, 0, "INV_BannerPVP_01", "=q6="..BabbleFaction["The Mag'har"].." #j30#", "=ec1=#m6#"};
				{ 17, 29102, "", "=q4=Reins of the Cobalt War Talbuk", "=ds=#e26#"};
				{ 18, 29104, "", "=q4=Reins of the Silver War Talbuk", "=ds=#e26#"};
				{ 19, 29105, "", "=q4=Reins of the Tan War Talbuk", "=ds=#e26#"};
				{ 20, 29103, "", "=q4=Reins of the White War Talbuk", "=ds=#e26#"};
				{ 21, 31829, "", "=q4=Reins of the Cobalt Riding Talbuk", "=ds=#e26#"};
				{ 22, 31831, "", "=q4=Reins of the Silver Riding Talbuk", "=ds=#e26#"};
				{ 23, 31833, "", "=q4=Reins of the Tan Riding Talbuk", "=ds=#e26#"};
				{ 24, 31835, "", "=q4=Reins of the White Riding Talbuk", "=ds=#e26#"};
			};
			{
				{ 1, 0, "INV_BannerPVP_01", "=q6="..BabbleZone["Dalaran"], "=ec1=#m6#"};
				{ 2, 44226, "", "=q4=Reins of the Armored Brown Bear", "=ds=#e26#"};
				{ 3, 44231, "", "=q4=Reins of the Wooly Mammoth", "=ds=#e26#"};
				{ 4, 44234, "", "=q4=Reins of the Traveler's Tundra Mammoth", "=ds=#e26#"};
				{ 5, 44690, "", "=q4=Armored Blue Wind Rider", "=ds=#e27#"};
				{ 16, 0, "INV_BannerPVP_01", "=q6="..AL["Quest Reward"].." #j30#", "=ec1=#m6#"};
				{ 17, 46102, "", "=q4=Whistle of the Venomhide Ravasaur", "=ds=#e26#"};
				{ 19, 0, "INV_BannerPVP_01", "=q6="..BabbleFaction["The Sunreavers"].." #j30#", "=ec1=#m6#"};
				{ 20, 46816, "", "=q4=Sunreaver Hawkstrider", "=ds=#e26#"};
				{ 21, 46814, "", "=q4=Sunreaver Dragonhawk", "=ds=#e27#"};
			};
		};
		info = {
			name = AL["Horde Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsFaction"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..BabbleFaction["Netherwing"].." #j30#", "=q1="..BabbleZone["Shadowmoon Valley"]};
				{ 2, 32858, "", "=q4=Reins of the Azure Netherwing Drake", "=ds=#e27#"};
				{ 3, 32859, "", "=q4=Reins of the Cobalt Netherwing Drake", "=ds=#e27#"};
				{ 4, 32857, "", "=q4=Reins of the Onyx Netherwing Drake", "=ds=#e27#"};
				{ 5, 32860, "", "=q4=Reins of the Purple Netherwing Drake", "=ds=#e27#"};
				{ 6, 32861, "", "=q4=Reins of the Veridian Netherwing Drake", "=ds=#e27#"};
				{ 7, 32862, "", "=q4=Reins of the Violet Netherwing Drake", "=ds=#e27#"};
				{ 9, 0, "INV_Box_01", "=q6="..BabbleFaction["Sha'tari Skyguard"].." #j30#", "=q1="..BabbleZone["Terokkar Forest"]};
				{ 10, 32319, "", "=q4=Blue Riding Nether Ray", "=ds=#e27#"};
				{ 11, 32314, "", "=q4=Green Riding Nether Ray", "=ds=#e27#"};
				{ 12, 32317, "", "=q4=Red Riding Nether Ray", "=ds=#e27#"};
				{ 13, 32316, "", "=q4=Purple Riding Nether Ray", "=ds=#e27#"};
				{ 14, 32318, "", "=q4=Silver Riding Nether Ray", "=ds=#e27#"};
				{ 16, 0, "INV_Box_01", "=q6="..BabbleFaction["Cenarion Expedition"].." #j30#", "=q1="..BabbleZone["Zangarmarsh"]};
				{ 17, 33999, "", "=q4=Cenarion War Hippogryph", "=ds=#e27#"};
				{ 19, 0, "INV_Box_01", "=q6="..BabbleFaction["The Sons of Hodir"].." #j30#", "=q1="..BabbleZone["The Storm Peaks"]};
				{
					{ 20, 44080, "", "=q4=Reins of the Ice Mammoth", "=ds=#e26#"};
					{ 20, 43958, "", "=q4=Reins of the Ice Mammoth", "=ds=#e26#"};
				};
				{
					{ 21, 44086, "", "=q4=Reins of the Grand Ice Mammoth", "=ds=#e26#"};
					{ 21, 43961, "", "=q4=Reins of the Grand Ice Mammoth", "=ds=#e26#"};
				};
				{ 23, 0, "INV_Box_01", "=q6="..BabbleFaction["The Wyrmrest Accord"].." #j30#", "=q1="..BabbleZone["Dragonblight"]};
				{ 24, 43955, "", "=q4=Reins of the Red Drake", "=ds=#e27#"};
				{ 26, 0, "INV_Box_01", "=q6="..BabbleFaction["The Oracles"].." #j30#", "=q1="..BabbleZone["Sholazar Basin"]};
				{ 27, 44707, "", "=q4=Reins of the Green Proto-Drake", "=q2="..AL["Mysterious Egg"], ""};
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..BabbleFaction["Ramkahen"].." #j30#", "=q1="..BabbleZone["Uldum"]};
				{ 2, 63044, "", "=q4=Reins of the Brown Riding Camel", "=ds=#e26#", ""};
				{ 3, 63045, "", "=q4=Reins of the Tan Riding Camel", "=ds=#e26#", ""};
			};
		};
		info = {
			name = AL["Neutral Faction Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsPvP"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Alliance PvP Mounts"], ""};
				{ 2, 29465, "", "=q4=Black Battlestrider", "=ds=#e26# =ec1=#m7#"};
				{ 3, 29467, "", "=q4=Black War Ram", "=ds=#e26# =ec1=#m7#"};
				{ 4, 29468, "", "=q4=Black War Steed Bridle", "=ds=#e26# =ec1=#m7#"};
				{ 5, 35906, "", "=q4=Reins of the Black War Elekk", "=ds=#e26# =ec1=#m7#"};
				{ 6, 29471, "", "=q4=Reins of the Black War Tiger", "=ds=#e26# =ec1=#m7#"};
				{ 7, 19030, "", "=q4=Stormpike Battle Charger", "=ds=#e26# =ec1=#m7#"};
				{ 8, 43956, "", "=q4=Reins of the Black War Mammoth", "=ds=#e26# =ec1=#m7#"};
				{ 9, 64998, "", "=q4=Reins of the Spectral Steed", "=ds=#e12#"};--Baradin's Wardens - Alliance
				{ 10, 63039, "", "=q4=Reins of the Drake of the West Wind", "=ds=#e27#"};--Baradin's Wardens - Alliance
				{ 12, 0, "INV_Box_01", "=q6="..AL["Halaa PvP Mounts"], "=q1="..BabbleZone["Nagrand"]};
				{ 13, 28915, "", "=q4=Reins of the Dark Riding Talbuk", "=ds=#e26#"};
				{ 14, 29228, "", "=q4=Reins of the Dark War Talbuk", "=ds=#e26#"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Horde PvP Mounts"], ""};
				{ 17, 29466, "", "=q4=Black War Kodo", "=ds=#e26# =ec1=#m6#"};
				{ 18, 29469, "", "=q4=Horn of the Black War Wolf", "=ds=#e26# =ec1=#m6#"};
				{ 19, 29470, "", "=q4=Red Skeletal Warhorse", "=ds=#e26# =ec1=#m6#"};
				{ 20, 34129, "", "=q4=Swift Warstrider", "=ds=#e26# =ec1=#m6#"};
				{ 21, 29472, "", "=q4=Whistle of the Black War Raptor", "=ds=#e26# =ec1=#m6#"};
				{ 22, 19029, "", "=q4=Horn of the Frostwolf Howler", "=ds=#e26# =ec1=#m6#"};
				{ 23, 44077, "", "=q4=Reins of the Black War Mammoth", "=ds=#e26# =ec1=#m6#"};
				{ 24, 64999, "", "=q4=Reins of the Spectral Wolf", "=ds=#e12#"};--Hellscrean's Reach - Horde
				{ 25, 65356, "", "=q4=Reins of the Drake of the West Wind", "=ds=#e27#"};--Hellscrean's Reach - Horde
			};
		};
		info = {
			name = AL["PvP Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsRare"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Dungeon/Raid"], ""};
				{ 2, 32458, "", "=q4=Ashes of Al'ar", "#ACHIEVEMENTID:885#"};
				{ 3, 13335, "", "=q4=Deathcharger's Reins", "#ACHIEVEMENTID:729#", "", "0.10%"};
				{ 4, 30480, "", "=q4=Fiery Warhorse's Reins", "#ACHIEVEMENTID:882#", "", "0.25%"};
				{ 5, 50818, "", "=q4=Invincible's Reins", "#ACHIEVEMENTID:4584#, =q1="..BabbleZone["Icecrown Citadel"], "", ""};
				{ 6, 45693, "", "=q4=Mimiron's Head", "#ACHIEVEMENTID:4626#, =q1="..BabbleZone["Ulduar"], "", ""};
				{ 7, 43986, "", "=q4=Reins of the Black Drake", "#ACHIEVEMENTID:2051#, =q1=#z38#", ""};
				{ 8, 43954, "", "=q4=Reins of the Twilight Drake", "#ACHIEVEMENTID:2054#, =q1=#z38#", ""};
				{ 9, 43953, "", "=q4=Reins of the Blue Drake", "=q2="..BabbleBoss["Malygos"]..", =q1="..BabbleZone["The Eye of Eternity"], ""};
				{ 10, 43952, "", "=q4=Reins of the Azure Drake", "=q2="..BabbleBoss["Malygos"]..", =q1="..BabbleZone["The Eye of Eternity"], ""};
				{ 11, 44151, "", "=q4=Reins of the Blue Proto-Drake", "=q2="..BabbleBoss["Skadi the Ruthless"]..", =q1="..AL["Heroic"].." "..BabbleZone["Utgarde Pinnacle"], ""};
				{ 12, 43951, "", "=q4=Reins of the Bronze Drake", "#ACHIEVEMENTID:1817#, =q1="..BabbleZone["The Culling of Stratholme"], ""};
				{ 13, 63040, "", "=q4=Reins of the Drake of the North Wind", "=q2="..BabbleBoss["Altairus"]..", =q1="..BabbleZone["The Vortex Pinnacle"]};
				{ 14, 63041, "", "=q4=Reins of the Drake of the South Wind", "=q2="..BabbleBoss["Al'Akir"]..", =q1="..BabbleZone["Throne of the Four Winds"]};
				{
					{ 15, 44083, "", "=q4=Reins of the Grand Black War Mammoth", "=q2="..BabbleZone["Vault of Archavon"]..", =ec1="..BabbleFaction["Horde"], "", ""};
					{ 15, 43959, "", "=q4=Reins of the Grand Black War Mammoth", "=q2="..BabbleZone["Vault of Archavon"]..", =ec1="..BabbleFaction["Alliance"], "", ""};
				};
				{ 16, 49636, "", "=q4=Reins of the Onyxian Drake", "=q2="..BabbleBoss["Onyxia"]..", =q1="..BabbleZone["Onyxia's Lair"], ""};
				{ 17, 32768, "", "=q4=Reins of the Raven Lord", "#ACHIEVEMENTID:883#"};
				{ 18, 63043, "", "=q4=Reins of the Vitreous Stone Drake", "=q2="..BabbleBoss["Slabhide"]..", =q1="..BabbleZone["The Stonecore"]};
				{ 19, 35513, "", "=q4=Swift White Hawkstrider", "#ACHIEVEMENTID:884#"};
				{ 20, 21218, "", "=q3=Blue Qiraji Resonating Crystal", "=q2="..AL["Trash Mobs"]..", =q1="..BabbleZone["Temple of Ahn'Qiraj"], "", "10.91%"};
				{ 21, 21323, "", "=q3=Green Qiraji Resonating Crystal", "=q2="..AL["Trash Mobs"]..", =q1="..BabbleZone["Temple of Ahn'Qiraj"], "", "11.77%"};
				{ 22, 21321, "", "=q3=Red Qiraji Resonating Crystal", "=q2="..AL["Trash Mobs"]..", =q1="..BabbleZone["Temple of Ahn'Qiraj"], "", "1.32%"};
				{ 23, 21324, "", "=q3=Yellow Qiraji Resonating Crystal", "=q2="..AL["Trash Mobs"]..", =q1="..BabbleZone["Temple of Ahn'Qiraj"], "", "12.64%"};
				{ 25, 0, "INV_Box_01", "=q6="..AL["Rare Mounts"], ""};
				{ 26, 63046, "", "=q4=Reins of the Grey Riding Camel", "=q2="..AL["Dormus the Camel-Hoarder"], ""};
				{ 27, 63042, "", "=q4=Reins of the Phosphorescent Stone Drake", "=q2="..AL["Aeonaxx"]..", =q1="..BabbleZone["Deepholm"]};
				{ 28, 44168, "", "=q4=Reins of the Time-Lost Proto-Drake", "=q2="..AL["Time-Lost Proto Drake"]..", =q1="..BabbleZone["The Storm Peaks"]};
				{ 29, 46109, "", "=q3=Sea Turtle", "#ACHIEVEMENTID:3218#", ""};
			};
		};
		info = {
			name = AL["Rare Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsAchievement"] = {
		["Normal"] = {
			{
				{ 1, 44843, "", "=q4=Blue Dragonhawk Mount", "#ACHIEVEMENTID:2536#, =ec1="..BabbleFaction["Alliance"]};
				{ 2, 44842, "", "=q4=Red Dragonhawk Mount", "#ACHIEVEMENTID:2537#, =ec1="..BabbleFaction["Horde"]};
				{ 3, 44178, "", "=q4=Reins of the Albino Drake", "#ACHIEVEMENTID:2143#"};
				{ 4, 51954, "", "=q4=Reins of the Bloodbathed Frostbrood Vanquisher", "#ACHIEVEMENTID:4602#"};
				{ 5, 63125, "", "=q4=Reins of the Dark Phoenix", "#ACHIEVEMENTID:4988#"};
				{ 6, 62901, "", "=q4=Reins of the Drake of the East Wind", "#ACHIEVEMENTID:4853#"};
				{ 7, 51955, "", "=q4=Reins of the Icebound Frostbrood Vanquisher", "#ACHIEVEMENTID:4603#"};
				{ 8, 45801, "", "=q4=Reins of the Ironbound Proto-Drake", "#ACHIEVEMENTID:2958#"};
				{ 9, 44160, "", "=q4=Reins of the Red Proto-Drake", "#ACHIEVEMENTID:2136#"};
				{ 10, 45802, "", "=q4=Reins of the Rusted Proto-Drake", "#ACHIEVEMENTID:2957#"};
				{ 11, 44177, "", "=q4=Reins of the Violet Proto-Drake", "#ACHIEVEMENTID:2145#"};
				{ 12, 62900, "", "=q4=Reins of the Volcanic Stone Drake", "#ACHIEVEMENTID:4845#"};
				{
					{ 16, 44224, "", "=q4=Reins of the Black War Bear", "#ACHIEVEMENTID:619#, =ec1="..BabbleFaction["Horde"]};
					{ 16, 44223, "", "=q4=Reins of the Black War Bear", "#ACHIEVEMENTID:614#, =ec1="..BabbleFaction["Alliance"]};
				};
				{ 17, 62298, "", "=q4=Reins of the Golden King", "#ACHIEVEMENTID:4912#, =ec1="..BabbleFaction["Alliance"]};
				{ 18, 67107, "", "=q4=Reins of the Kor'kron Annihilator", "#ACHIEVEMENTID:5492#, =ec1="..BabbleFaction["Horde"]};
			};
		};
		info = {
			name = AL["Achievement Reward"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsCraftQuest"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Crafted Mounts"], ""};
				{ 2, 60954, "", "=q4=Fossilized Raptor", "=ds=#e26# =q2=#p25#"};
				{ 3, 44413, "", "=q4=Mekgineer's Chopper", "=ds=#e26# =q2=#p5# =ec1=#m7#"};
				{ 4, 41508, "", "=q4=Mechano-Hog", "=ds=#e26# =q2=#p5# =ec1=#m6#"};
				{ 5, 64883, "", "=q4=Scepter of Azj'Aqir", "=ds=#e26# =q2=#p25#"};
				{ 7, 54797, "", "=q4=Frosty Flying Carpet", "=ds=#e27# =q2=#p8#"};
				{ 8, 44558, "", "=q4=Magnificent Flying Carpet", "=ds=#e27# =q2=#p8#"};
				{ 9, 34061, "", "=q4=Turbo-Charged Flying Machine Control", "=ds=#e27# =q2=#p5#"};
				{ 10, 65891, "", "=q4=Vial of the Sands", "=ds=#e27# =q2=#p1#"};
				{ 11, 44554, "", "=q3=Flying Carpet", "=ds=#e27# =q2=#p8#"};
				{ 12, 34060, "", "=q3=Flying Machine Control", "=ds=#e27# =q2=#p5#"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Quest Reward"], ""};
				{ 17, 52200, "", "=q4=Reins of the Crimson Deathcharger", "=q1=#m4#: #QUESTID:24915#"};
				{ 18, 43962, "", "=q4=Reins of the White Polar Bear", "=q1=#m4#: "..AL["Hyldnir Spoils"], ""};
				{ 19, 54465, "", "=q3=Subdued Abyssal Seahorse", "=q1=#m4#: #QUESTID:25371#"};
			};
		};
		info = {
			name = AL["Quest Reward"].." / "..AL["Crafted Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsCardGamePromotional"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Card Game Mounts"], ""};
				{ 2, 49282, "", "=q4=Big Battle Bear", "=ds=#e26#"};
				{ 3, 49290, "", "=q4=Magic Rooster Egg", "=ds=#e26#"};
				{ 4, 49284, "", "=q4=Reins of the Swift Spectral Tiger", "=ds=#e26#"};
				{ 5, 23720, "", "=q4=Riding Turtle", "=ds=#e26#"};
				{ 6, 54068, "", "=q4=Wooly White Rhino ", "=ds=#e26#"};
				{ 7, 49286, "", "=q4=X-51 Nether-Rocket X-TREME", "=q2=#m24#"};
				{ 8, 49283, "", "=q3=Reins of the Spectral Tiger", "=ds=#e26#"};
				{ 9, 49285, "", "=q3=X-51 Nether-Rocket", "=q2=#m24#"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Promotional Mounts"], ""};
				{ 17, 54860, "", "=q4=X-53 Touring Rocket", "#ACHIEVEMENTID:4832#"};
				{ 18, 43599, "", "=q3=Big Blizzard Bear", "#ACHIEVEMENTID:415#"};
				{ 20, 0, "INV_Box_01", "=q6="..AL["Companion Store"], ""};
				{ 21, 54811, "", "=q4=Celestial Steed", "=ds=#e12#"};
			};
		};
		info = {
			name = AL["Promotional Mounts"].." / "..AL["Card Game Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsEvent"] = {
		["Normal"] = {
			{
				{ 1, 0, "INV_BannerPVP_02", "=q6=#m7#", ""};
				{ 2, 45591, "", "=q4=Darnassian Nightsaber", "=ds=#e26#", "100 #champseal#"};
				{ 3, 45590, "", "=q4=Exodar Elekk", "=ds=#e26#", "100 #champseal#"};
				{ 4, 45589, "", "=q4=Gnomeregan Mechanostrider", "=ds=#e26#", "100 #champseal#"};
				{ 5, 45586, "", "=q4=Ironforge Ram", "=ds=#e26#", "100 #champseal#"};
				{ 6, 45125, "", "=q4=Stormwind Steed", "=ds=#e26#", "100 #champseal#"};
				{ 8, 46745, "", "=q4=Great Red Elekk", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 9, 46752, "", "=q4=Swift Gray Steed", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 10, 46744, "", "=q4=Swift Moonsaber", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 11, 46748, "", "=q4=Swift Violet Ram", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 12, 46747, "", "=q4=Turbostrider", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 14, 47179, "", "=q4=Argent Charger", "=ds=#e26#", "100 #champseal#"};
				{ 15, 47180, "", "=q4=Argent Warhorse", "=ds=#e26#", "100 #champseal#"};
				{ 16, 0, "INV_BannerPVP_01", "=q6=#m6#", ""};
				{ 17, 45593, "", "=q4=Darkspear Raptor", "=ds=#e26#", "100 #champseal#"};
				{ 18, 45597, "", "=q4=Forsaken Warhorse", "=ds=#e26#", "100 #champseal#"};
				{ 19, 45595, "", "=q4=Orgrimmar Wolf", "=ds=#e26#", "100 #champseal#"};
				{ 20, 45596, "", "=q4=Silvermoon Hawkstrider", "=ds=#e26#", "100 #champseal#"};
				{ 21, 45592, "", "=q4=Thunder Bluff Kodo", "=ds=#e26#", "100 #champseal#"};
				{ 23, 46750, "", "=q4=Great Golden Kodo", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 24, 46749, "", "=q4=Swift Burgundy Wolf", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 25, 46743, "", "=q4=Swift Purple Raptor", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 26, 46751, "", "=q4=Swift Red Hawkstrider", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 27, 46746, "", "=q4=White Skeletal Warhorse", "=ds=#e26#", "500 #gold# 5 #champseal#"};
				{ 29, 45725, "", "=q4=Argent Hippogryph", "=ds=#e27#", "150 #champseal#"};
				extraText = " - "..AL["Argent Tournament"]
			};
			{
				{ 1, 0, "INV_Box_01", "=q6="..AL["Brewfest"], ""};
				{ 2, 37828, "", "=q4=Great Brewfest Kodo", "=q2=#n150#"};
				{ 3, 33977, "", "=q4=Swift Brewfest Ram", "=q2=#n150#"};
				{ 5, 0, "INV_Box_01", "=q6="..AL["Hallow's End"], ""};
				{ 6, 37012, "", "=q4=The Horseman's Reins", "#ACHIEVEMENTID:980#"};
				{ 7, 37011, "", "=q3=Magic Broom", "=q2=#n136#"};
				{ 16, 0, "INV_Box_01", "=q6="..AL["Love is in the Air"], ""};
				{ 17, 50250, "", "=q4=Big Love Rocket", "#ACHIEVEMENTID:4627#"};
			};
		};
		info = {
			name = AL["World Events"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsCata"] = {
		["Normal"] = {
			{
				{ 1, 62298, "", "=q4=Reins of the Golden King", "#ACHIEVEMENTID:4912#, =ec1="..BabbleFaction["Alliance"]};
				{ 2, 67107, "", "=q4=Reins of the Kor'kron Annihilator", "#ACHIEVEMENTID:5492#, =ec1="..BabbleFaction["Horde"]};
				{ 3, 64883, "", "=q4=Scepter of Azj'Aqir", "=ds=#e26# =q2=#p25#"};
				{ 4, 60954, "", "=q4=Fossilized Raptor", "=ds=#e26# =q2=#p25#"};
				{ 5, 62462, "", "=q4=Goblin Turbo-Trike Key", "=ds=#e26#"};
				{ 6, 64998, "", "=q4=Reins of the Spectral Steed", "=ds=#e12#"};
				{ 7, 64999, "", "=q4=Reins of the Spectral Wolf", "=ds=#e12#"};
				{ 8, 63044, "", "=q4=Reins of the Brown Riding Camel", "=ds=#e26#", ""};
				{ 9, 63046, "", "=q4=Reins of the Grey Riding Camel", "=ds=#e26#", ""};
				{ 10, 63045, "", "=q4=Reins of the Tan Riding Camel", "=ds=#e26#", ""};
				{ 11, 63125, "", "=q4=Reins of the Dark Phoenix", "#ACHIEVEMENTID:4988#"};
				{ 12, 62901, "", "=q4=Reins of the Drake of the East Wind", "#ACHIEVEMENTID:4853#"};
				{ 13, 63040, "", "=q4=Reins of the Drake of the North Wind", "=q2="..BabbleBoss["Altairus"]..", =q1="..BabbleZone["The Vortex Pinnacle"]};
				{ 14, 63041, "", "=q4=Reins of the Drake of the South Wind", "=q2="..BabbleBoss["Al'Akir"]..", =q1="..BabbleZone["Throne of the Four Winds"]};
				{ 15, 63039, "", "=q4=Reins of the Drake of the West Wind", "=ds=#e27#"};
				{ 16, 65356, "", "=q4=Reins of the Drake of the West Wind", "=ds=#e27#"};
				{ 17, 63042, "", "=q4=Reins of the Phosphorescent Stone Drake", "=q2="..AL["Aeonaxx"]..", =q1="..BabbleZone["Deepholm"]};
				{ 18, 63043, "", "=q4=Reins of the Vitreous Stone Drake", "=q2="..BabbleBoss["Slabhide"]..", =q1="..BabbleZone["The Stonecore"]};
				{ 19, 62900, "", "=q4=Reins of the Volcanic Stone Drake", "#ACHIEVEMENTID:4845#"};
				{ 20, 65891, "", "=q4=Vial of the Sands", "=ds=#e27# =q2=#p1#"};
				{ 21, 62461, "", "=q3=Goblin Trike Key", "=ds=#e26#"};
				{ 22, 54465, "", "=q3=Subdued Abyssal Seahorse", "=q1=#m4#: #QUESTID:25371#"};
			};
		};
		info = {
			name = AL["Cataclysm"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

	AtlasLoot_Data["MountsRemoved"] = {
		["Normal"] = {
			{

				{ 1, 0, "INV_Box_01", "=q6="..AL["Dungeon/Raid"], ""};
				{ 2, 33809, "", "=q4=Amani War Bear", "=q2="..AL["Timed Reward Chest 4"]..", =q1="..BabbleZone["Zul'Aman"]};
				{ 3, 19872, "", "=q4=Swift Razzashi Raptor", "#ACHIEVEMENTID:881#", "", "0.43%"};
				{ 4, 19902, "", "=q4=Swift Zulian Tiger", "#ACHIEVEMENTID:880#", "", " 0.70%"};
				{ 6, 0, "INV_Box_01", "=q6="..AL["Achievement Reward"], ""};
				{ 7, 49098, "", "=q4=Crusader's Black Warhorse", "#ACHIEVEMENTID:4079#, =ec1="..BabbleFaction["Horde"]};
				{ 8, 49096, "", "=q4=Crusader's White Warhorse", "#ACHIEVEMENTID:4156#, =ec1="..BabbleFaction["Alliance"]};
				{ 9, 49044, "", "=q4=Swift Alliance Steed", "#ACHIEVEMENTID:3810#, =ec1="..BabbleFaction["Alliance"]};
				{ 10, 49046, "", "=q4=Swift Horde Wolf", "#ACHIEVEMENTID:3810#, =ec1="..BabbleFaction["Horde"]};
				{ 11, 44164, "", "=q4=Reins of the Black Proto-Drake", "#ACHIEVEMENTID:2138#"};
				{ 12, 44175, "", "=q4=Reins of the Plagued Proto-Drake", "#ACHIEVEMENTID:2137#"};
				{ 16, 0, "INV_Box_01", "=q6=Other", ""};--no idea what to call this section
				{ 17, 21176, "", "=q5=Black Qiraji Resonating Crystal", "=q1=#m4#: #QUESTID:8743#"};
				{ 18, 37719, "", "=q4=Swift Zhevra", "#ACHIEVEMENTID:1436#"};
				{ 19, 33976, "", "=q3=Brewfest Ram", "=ds=#e26#"};
				{ 21, 0, "INV_Box_01", "=q6="..AL["Arena Reward"], ""};
				{ 22, 30609, "", "=q4=Swift Nether Drake", "=ds="..AL["Season 1"]};
				{ 23, 34092, "", "=q4=Merciless Nether Drake", "=ds="..AL["Season 2"]};
				{ 24, 37676, "", "=q4=Vengeful Nether Drake", "=ds="..AL["Season 3"]};
				{ 25, 43516, "", "=q4=Brutal Nether Drake", "=ds="..AL["Season 4"]};
				{ 26, 46708, "", "=q4=Deadly Gladiator's Frost Wyrm", "=ds="..AL["Season 5"]};
				{ 27, 46171, "", "=q4=Furious Gladiator's Frost Wyrm", "=ds="..AL["Season 6"]};
				{ 28, 47840, "", "=q4=Relentless Gladiator's Frost Wyrm", "=ds="..AL["Season 7"]};
				{ 29, 50435, "", "=q4=Wrathful Gladiator's Frost Wyrm", "=ds="..AL["Season 8"]};
			};
		};
		info = {
			name = AL["Unobtainable Mounts"],
			module = moduleName, menu = "MOUNTMENU",
		};
	}

		----------------------------
		--- Transformation Items ---
		----------------------------

	AtlasLoot_Data["TransformationItems"] = {
		["Normal"] = {
			{
				{ 1, 49704, "", "=q4=Carved Ogre Idol", "=q2=#m24#"};
				{ 2, 52201, "", "=q4=Muradin's Favor", "=q1=#m4#: #QUESTID:24917#"};
				{ 3, 37254, "", "=q4=Super Simian Sphere", "=ds=#z17#"};
				{ 4, 54653, "", "=q3=Darkspear Pride", "=q1=#m4#: #QUESTID:25480#"};
				{ 5, 44719, "", "=q3=Frenzyheart Brew", "=q2="..BabbleFaction["Frenzyheart Tribe"].." "..BabbleFaction["Revered"]};
				{ 6, 54651, "", "=q3=Gnomeregan Pride", "=q1=#m4#: #QUESTID:25286#"};
				{ 7, 1973, "", "=q3=Orb of Deception", "=ds=#z17#"};
				{ 8, 35275, "", "=q3=Orb of the Sin'dorei", "=q2="..AL["Various Locations"]..", =q1="..BabbleZone["Magisters' Terrace"]};
				{ 9, 45850, "", "=q3=Rituals of the New Moon", "=q2=#p26#"};
				{ 10, 45851, "", "=q3=Rituals of the New Moon", "=q2=#p26#"};
				{ 11, 45852, "", "=q3=Rituals of the New Moon", "=q2=#p26#"};
				{ 12, 45853, "", "=q3=Rituals of the New Moon", "=q2=#p26#"};
				{ 13, 32782, "", "=q3=Time-Lost Figurine", "=q2="..AL["Terokk"]..", =q1="..BabbleZone["Terokkar Forest"]};
				{ 14, 5462, "", "=q1=Dartol's Rod of Transformation", "=q1=#m4#: #QUESTID:1028#"};
				{
					{ 15, 43499, "", "=q1=Iron Boot Flask", "=q2="..BabbleZone["The Storm Peaks"]};--Horde / - Olut Alegut
					{ 15, 43499, "", "=q1=Iron Boot Flask", "=q2="..BabbleZone["The Storm Peaks"]};--Alliance / - Rork Sharpchin
				};
			};
		};
		info = {
			name = AL["Transformation Items"],
			module = moduleName, menu = "SETMENU",
		};
	}

		-----------------------
		--- BoE World Epics ---
		-----------------------

	AtlasLoot_Data["WorldEpics85"] = {
		["Normal"] = {
			{
				{ 1, 67134, "", "=q4=Dory's Finery", "=ds=#s4#"};
				{ 2, 67140, "", "=q4=Drape of Inimitable Fate", "=ds=#s4#"};
				{ 3, 67131, "", "=q4=Ritssyn's Ruminous Drape", "=ds=#s4#"};
				{ 4, 67142, "", "=q4=Zom's Electrostatic Cloak", "=ds=#s4#"};
				{ 5, 67147, "", "=q4=Je'Tze's Sparkling Tiara", "=ds=#s1#, #a1#"};
				{ 6, 67133, "", "=q4=Dizze's Whirling Robe", "=ds=#s5#, #a1#"};
				{ 7, 67132, "", "=q4=Grips of the Failed Immortal", "=ds=#s9#, #a1#"};
				{ 8, 67146, "", "=q4=Woundsplicer Handwraps", "=ds=#s9#, #a1#"};
				{ 9, 67135, "", "=q4=Morrie's Waywalker Wrap", "=ds=#s5#, #a2#"};
				{ 10, 67150, "", "=q4=Arrowsinger Legguards", "=ds=#s11#, #a3#"};
				{ 11, 67148, "", "=q4=Kilt of Trollish Dreams", "=ds=#s11#, #a3#"};
				{ 12, 67144, "", "=q4=Pauldrons of Edward the Odd", "=ds=#s3#, #a4#"};
				{ 13, 67143, "", "=q4=Icebone Hauberk", "=ds=#s5#, #a4#"};
				{ 14, 67141, "", "=q4=Corefire Legplates", "=ds=#s11#, #a4#"};
				{ 16, 67138, "", "=q4=Buc-Zakai Choker", "=ds=#s2#"};
				{ 17, 67137, "", "=q4=Don Rodrigo's Fabulous Necklace", "=ds=#s2#"};
				{ 18, 67130, "", "=q4=Dorian's Lost Necklace", "=ds=#s2#"};
				{ 20, 67139, "", "=q4=Blauvelt's Family Crest", "=ds=#s13#"};
				{ 21, 67136, "", "=q4=Gilnean Ring of Ruination", "=ds=#s13#"};
				{ 22, 67129, "", "=q4=Signet of High Arcanist Savor", "=ds=#s13#"};
				{ 24, 67145, "", "=q4=Blockade's Lost Shield", "=ds=#w8#"};
				{ 25, 67149, "", "=q4=Heartbound Tome", "=ds=#s15#"};
			};
		};
		info = {
			name = AL["BoE World Epics"].." "..AL["Level 85"],
			module = moduleName, menu = "WORLDEPICS", instance = "WorldEpics",
		};
	}

		----------------------
		--- Heirloom Items ---
		----------------------

	AtlasLoot_Data["Heirloom85"] = {
		["Normal"] = {
			{
				{ 1, 62040, "", "=q7=Ancient Bloodmoon Cloak", "=ds=#s4#", ""};
				{ 2, 62039, "", "=q7=Inherited Cape of the Black Baron", "=ds=#s4#", ""};
				{ 3, 62038, "", "=q7=Worn Stoneskin Gargoyle Cape", "=ds=#s4#", ""};
				{ 4, 61958, "", "=q7=Tattered Dreadmist Mask", "=ds=#s1#, #a1#", ""};
				{ 5, 61942, "", "=q7=Preened Tribal War Feathers", "=ds=#s1#, #a2#", ""};
				{ 6, 61937, "", "=q7=Stained Shadowcraft Cap", "=ds=#s1#, #a2#", ""};
				{ 7, 61936, "", "=q7=Mystical Coif of Elements", "=ds=#s1#, #a3#", ""};
				{ 8, 61935, "", "=q7=Tarnished Raging Berserker's Helm", "=ds=#s1#, #a3#", ""};
				{ 9, 61931, "", "=q7=Polished Helm of Valor", "=ds=#s1#, #a4#", ""};
			};
		};
		info = {
			name = AL["Heirloom"],
			module = moduleName, menu = "SETMENU",
		};
	}

		----------------------------
		--- Justice Points Items ---
		----------------------------

	AtlasLoot_Data["JusticePoints"] = {
		["Normal"] = {
			{
				{ 2, 58155, "", "=q3=Cowl of Pleasant Gloom", "=ds=#s1#, #a1#", "2200 #justice#" },
				{ 3, 58157, "", "=q3=Meadow Mantle", "=ds=#s3#, #a1#", "1650 #justice#" },
				{ 4, 58153, "", "=q3=Robes of Embalmed Darkness", "=ds=#s5#, #a1#", "2200 #justice#" },
				{ 5, 58158, "", "=q3=Gloves of the Painless Midnight", "=ds=#s9#, #a1#", "1650 #justice#" },
				{ 6, 57921, "", "=q3=Incense Infused Cumberbund", "=ds=#s10#, #a1#", "1650 #justice#" },
				{ 7, 58154, "", "=q3=Pensive Legwraps", "=ds=#s11#, #a1#", "2200 #justice#" },
				{ 17, 58161, "", "=q3=Mask of New Snow", "=ds=#s1#, #a1#", "2200 #justice#" },
				{ 18, 58162, "", "=q3=Summer Song Shoulderwraps", "=ds=#s3#, #a1#", "1650 #justice#" },
				{ 19, 58159, "", "=q3=Musk Rose Robes", "=ds=#s5#, #a1#", "2200 #justice#" },
				{ 20, 58163, "", "=q3=Gloves of Purification", "=ds=#s9#, #a1#", "1650 #justice#" },
				{ 21, 57922, "", "=q3=Belt of the Falling Rain", "=ds=#s10#, #a1#", "1650 #justice#" },
				{ 22, 58160, "", "=q3=Leggings of Charity", "=ds=#s11#, #a1#", "2200 #justice#" },
				extraText = ": "..BabbleInventory["Cloth"];
			};
			{
				{ 2, 58150, "", "=q3=Cluster of Stars", "=ds=#s1#, #a2#", "2200 #justice#" },
				{ 3, 58151, "", "=q3=Somber Shawl", "=ds=#s3#, #a2#", "1650 #justice#" },
				{ 4, 58139, "", "=q3=Robes of Forgetfulness", "=ds=#s5#, #a2#", "2200 #justice#" },
				{ 5, 58152, "", "=q3=Blessed Hands of Elune", "=ds=#s9#, #a2#", "1650 #justice#" },
				{ 6, 57919, "", "=q3=Thatch Eave Vines", "=ds=#s10#, #a2#", "1650 #justice#" },
				{ 7, 58140, "", "=q3=Leggings of Late Blooms", "=ds=#s11#, #a2#", "2200 #justice#" },
				{ 17, 58133, "", "=q3=Mask of Vines", "=ds=#s1#, #a2#", "2200 #justice#" },
				{ 18, 58134, "", "=q3=Embrace of the Night", "=ds=#s3#, #a2#", "1650 #justice#" },
				{ 19, 58131, "", "=q3=Tunic of Sinking Envy", "=ds=#s5#, #a2#", "2200 #justice#" },
				{ 20, 58138, "", "=q3=Sticky Fingers", "=ds=#s9#, #a2#", "1650 #justice#" },
				{ 21, 57918, "", "=q3=Sash of Musing", "=ds=#s10#, #a2#", "1650 #justice#" },
				{ 22, 58132, "", "=q3=Leggings of the Burrowing Mole", "=ds=#s11#, #a2#", "2200 #justice#" },
				extraText = ": "..BabbleInventory["Leather"];
			};
			{
				{ 2, 58128, "", "=q3=Helm of the Inward Eye", "=ds=#s1#, #a3#", "2200 #justice#" },
				{ 3, 58129, "", "=q3=Seafoam Mantle", "=ds=#s3#, #a3#", "1650 #justice#" },
				{ 4, 58126, "", "=q3=Vest of the Waking Dream", "=ds=#s5#, #a3#", "2200 #justice#" },
				{ 5, 58130, "", "=q3=Gleaning Gloves", "=ds=#s9#, #a3#", "1650 #justice#" },
				{ 6, 57917, "", "=q3=Belt of the Still Stream", "=ds=#s10#, #a3#", "1650 #justice#" },
				{ 7, 58127, "", "=q3=Leggings of Soothing Silence", "=ds=#s11#, #a3#", "2200 #justice#" },
				{ 17, 58123, "", "=q3=Willow Mask", "=ds=#s1#, #a3#", "2200 #justice#" },
				{ 18, 58124, "", "=q3=Wrap of the Valley Glades", "=ds=#s3#, #a3#", "1650 #justice#" },
				{ 19, 58121, "", "=q3=Vest of the True Companion", "=ds=#s5#, #a3#", "2200 #justice#" },
				{ 20, 58125, "", "=q3=Gloves of the Passing Night", "=ds=#s9#, #a3#", "1650 #justice#" },
				{ 21, 57916, "", "=q3=Belt of the Dim Forest", "=ds=#s10#, #a3#", "1650 #justice#" },
				{ 22, 58122, "", "=q3=Hillside Striders", "=ds=#s11#, #a3#", "2200 #justice#" },
				extraText = ": "..BabbleInventory["Mail"];
			};
			{
				{ 1, 58108, "", "=q3=Crown of the Blazing Sun", "=ds=#s1#, #a4#", "2200 #justice#" },
				{ 2, 58109, "", "=q3=Pauldrons of the Forlorn", "=ds=#s3#, #a4#", "1650 #justice#" },
				{ 3, 58106, "", "=q3=Chestguard of Dancing Waves", "=ds=#s5#, #a4#", "2200 #justice#" },
				{ 4, 58110, "", "=q3=Gloves of Curious Conscience", "=ds=#s9#, #a4#", "1650 #justice#" },
				{ 5, 57915, "", "=q3=Belt of Barred Clouds", "=ds=#s10#, #a4#", "1650 #justice#" },
				{ 6, 58107, "", "=q3=Legguards of the Gentle", "=ds=#s11#, #a4#", "2200 #justice#" },
				{ 8, 58103, "", "=q3=Helm of the Proud", "=ds=#s1#, #a4#", "2200 #justice#" },
				{ 9, 58104, "", "=q3=Sunburnt Pauldrons", "=ds=#s3#, #a4#", "1650 #justice#" },
				{ 10, 58101, "", "=q3=Chestplate of the Steadfast", "=ds=#s5#, #a4#", "2200 #justice#" },
				{ 11, 58105, "", "=q3=Numbing Handguards", "=ds=#s9#, #a4#", "1650 #justice#" },
				{ 12, 57914, "", "=q3=Girdle of the Mountains", "=ds=#s10#, #a4#", "1650 #justice#" },
				{ 13, 58102, "", "=q3=Greaves of Splendor", "=ds=#s11#, #a4#", "2200 #justice#" },
				{ 16, 58098, "", "=q3=Helm of Easeful Death", "=ds=#s1#, #a4#", "2200 #justice#" },
				{ 17, 58100, "", "=q3=Pauldrons of the High Requiem", "=ds=#s3#, #a4#", "1650 #justice#" },
				{ 18, 58096, "", "=q3=Breastplate of Raging Fury", "=ds=#s5#, #a4#", "2200 #justice#" },
				{ 19, 58099, "", "=q3=Reaping Gauntlets", "=ds=#s9#, #a4#", "1650 #justice#" },
				{ 20, 57913, "", "=q3=Beech Green Belt", "=ds=#s10#, #a4#", "1650 #justice#" },
				{ 21, 58097, "", "=q3=Greaves of Gallantry", "=ds=#s11#, #a4#", "2200 #justice#" },
				extraText = ": "..BabbleInventory["Plate"];
			};
			{
				{ 1, 57931, "", "=q3=Amulet of Dull Dreaming", "=ds=#s2#", "1250 #justice#" },
				{ 2, 57934, "", "=q3=Celadon Pendant", "=ds=#s2#", "1250 #justice#" },
				{ 3, 57930, "", "=q3=Pendant of Quiet Breath", "=ds=#s2#", "1250 #justice#" },
				{ 4, 57933, "", "=q3=String of Beaded Bubbles", "=ds=#s2#", "1250 #justice#" },
				{ 5, 57932, "", "=q3=The Lustrous Eye", "=ds=#s2#", "1250 #justice#" },
				{ 6, 57924, "", "=q3=Apple-Bent Bough", "=ds=#s15#", "950 #justice#" },
				{ 7, 57923, "", "=q3=Hermit's Lamp", "=ds=#s15#", "950 #justice#" },
				{ 16, 57929, "", "=q3=Dawnblaze Blade", "=ds=#h4#, #w10#", "950 #justice#" },
				{ 17, 57928, "", "=q3=Windslicer", "=ds=#h4#, #w1#", "950 #justice#" },
				{ 18, 57927, "", "=q3=Throat Slasher", "=ds=#h4#, #w4#", "950 #justice#" },
				{ 19, 57926, "", "=q3=Shield of the Four Grey Towers", "=ds=#w8#", "950 #justice#" },
				{ 20, 57925, "", "=q3=Shield of the Mists", "=ds=#w8#", "950 #justice#" },
				extraText = ": "..AL["Accessories"].." & "..AL["Weapons"];
			};
			{
   				{ 2, 52555, "", "=q1=Hypnotic Dust", "=ds=", "200 #justice#" },
    			{ 3, 52719, "", "=q2=Greater Celestial Essence", "=ds=", "800 #justice#" },
    			{ 4, 52721, "", "=q3=Heavenly Shard", "=ds=", "1200 #justice#" },
    			{ 5, 52976, "", "=q1=Savage Leather", "=ds=", "750 #justice#" },
    			{ 17, 53010, "", "=q1=Embersilk Cloth", "=ds=", "2500 #justice#" },
    			{ 18, 52185, "", "=q1=Elementium Ore", "=ds=", "2000 #justice#" },
    			{ 19, 68813, "", "=q3=Satchel of Freshly-Picked Herbs", "=ds=", "3000 #justice#" },
    			extraText = ": "..AL["Other"]
			};
		};
		info = {
			name = AL["Justice Points"],
			module = moduleName, menu = "JUSTICEPOINTSMENU",
		};
	}

		--------------------------
		--- Valor Points Items ---
		--------------------------

	AtlasLoot_Data["ValorPoints"] = {
		["Normal"] = {
			{
				{ 1, 58190, "", "=q4=Floating Web", "=ds=#s4#", "1250 #valor#" },
				{ 2, 58192, "", "=q4=Gray Hair Cloak", "=ds=#s4#", "1250 #valor#" },
				{ 3, 58193, "", "=q4=Haunt of Flies", "=ds=#s4#", "1250 #valor#" },
				{ 4, 58194, "", "=q4=Heavenly Breeze", "=ds=#s4#", "1250 #valor#" },
				{ 5, 58191, "", "=q4=Viewless Wings", "=ds=#s4#", "1250 #valor#" },
				{ 7, 58486, "", "=q4=Slippers of Moving Waters", "=ds=#s12#, #a1#", "1650 #valor#" },
				{ 8, 58485, "", "=q4=Melodious Slippers", "=ds=#s12#, #a1#", "1650 #valor#" },
				{ 9, 58484, "", "=q4=Fading Violet Sandals", "=ds=#s12#, #a2#", "1650 #valor#" },
				{ 10, 58482, "", "=q4=Treads of Fleeting Joy", "=ds=#s12#, #a2#", "1650 #valor#" },
				{ 11, 58481, "", "=q4=Boots of the Perilous Seas", "=ds=#s12#, #a3#", "1650 #valor#" },
				{ 12, 58199, "", "=q4=Moccasins of Verdurous Glooms", "=ds=#s12#, #a3#", "1650 #valor#" },
				{ 13, 58198, "", "=q4=Eternal Pathfinders", "=ds=#s12#, #a4#", "1650 #valor#" },
				{ 14, 58197, "", "=q4=Rock Furrow Boots", "=ds=#s12#, #a4#", "1650 #valor#" },
				{ 15, 58195, "", "=q4=Woe Breeder's Boots", "=ds=#s12#, #a4#", "1650 #valor#" },
				{ 16, 58185, "", "=q4=Band of Bees", "=ds=#s13#", "1250 #valor#" },
				{ 17, 58188, "", "=q4=Band of Secret Names", "=ds=#s13#", "1250 #valor#" },
				{ 18, 68812, "", "=q4=Hornet-Sting Band", "=ds=#s13#", "1250 #valor#" },
				{ 19, 58187, "", "=q4=Ring of the Battle Anthem", "=ds=#s13#", "1250 #valor#" },
				{ 20, 58189, "", "=q4=Twined Band of Flowers", "=ds=#s13#", "1250 #valor#" },
				{ 21, 58184, "", "=q4=Core of Ripeness", "=ds=#s14#", "1650 #valor#" },
				{ 22, 58182, "", "=q4=Bedrock Talisman", "=ds=#s14#", "1650 #valor#" },
				{ 23, 58181, "", "=q4=Fluid Death", "=ds=#s14#", "1650 #valor#" },
				{ 24, 58180, "", "=q4=License to Slay", "=ds=#s14#", "1650 #valor#" },
				{ 25, 58183, "", "=q4=Soul Casket", "=ds=#s14#", "1650 #valor#" },
				{ 26, 64674, "", "=q4=Relic of Aggramar", "=ds=#s16#", "700 #valor#" },
				{ 27, 64673, "", "=q4=Relic of Eonar", "=ds=#s16#", "700 #valor#" },
				{ 28, 64671, "", "=q4=Relic of Golganneth", "=ds=#s16#", "700 #valor#" },
				{ 29, 64676, "", "=q4=Relic of Khaz'goroth", "=ds=#s16#", "700 #valor#" },
				{ 30, 64672, "", "=q4=Relic of Norgannon", "=ds=#s16#", "700 #valor#" },
			};
		};
		info = {
			name = AL["Valor Points"],
			module = moduleName, menu = "SETMENU",
		};
	}