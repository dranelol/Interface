local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local BabbleBoss = AtlasLoot_GetLocaleLibBabble("LibBabble-Boss-3.0")
local BabbleFaction = AtlasLoot_GetLocaleLibBabble("LibBabble-Faction-3.0")
local BabbleInventory = AtlasLoot_GetLocaleLibBabble("LibBabble-Inventory-3.0")
local BabbleItemSet = AtlasLoot_GetLocaleLibBabble("LibBabble-ItemSet-3.0")
local BabbleZone = AtlasLoot_GetLocaleLibBabble("LibBabble-Zone-3.0")

AtlasLoot_TextParsing = {

	-- Classes
	{ "#c1#", LOCALIZED_CLASS_NAMES_MALE["DRUID"] },
	{ "#c2#", LOCALIZED_CLASS_NAMES_MALE["HUNTER"] },
	{ "#c3#", LOCALIZED_CLASS_NAMES_MALE["MAGE"] },
	{ "#c4#", LOCALIZED_CLASS_NAMES_MALE["PALADIN"] },
	{ "#c5#", LOCALIZED_CLASS_NAMES_MALE["PRIEST"] },
	{ "#c6#", LOCALIZED_CLASS_NAMES_MALE["ROGUE"] },
	{ "#c7#", LOCALIZED_CLASS_NAMES_MALE["SHAMAN"] },
	{ "#c8#", LOCALIZED_CLASS_NAMES_MALE["WARLOCK"] },
	{ "#c9#", LOCALIZED_CLASS_NAMES_MALE["WARRIOR"] },
	{ "#c10#", LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"] },

	-- Professions
	{ "#p1#", GetSpellInfo(2259) },		-- Alchemy
	{ "#p2#", GetSpellInfo(2018) },		-- Blacksmithing
	{ "#p3#", GetSpellInfo(2550) },		-- Cooking
	{ "#p4#", GetSpellInfo(7411) },		-- Enchanting
	{ "#p5#", GetSpellInfo(4036) },		-- Engineering
	{ "#p6#", GetSpellInfo(3273) },		-- First Aid
	{ "#p7#", GetSpellInfo(2108) },		-- Leatherworking
	{ "#p8#", GetSpellInfo(3908) },		-- Tailoring
	{ "#p9#", GetSpellInfo(10656) },	-- Dragonscale Leatherworking
	{ "#p10#", GetSpellInfo(10660) },	-- Tribal Leatherworking
	{ "#p11#", GetSpellInfo(10658) },	-- Elemental Leatherworking
	{ "#p12#", GetSpellInfo(25229) },	-- Jewelcrafting
	{ "#p13#", GetSpellInfo(9788) },	-- Armorsmith
	{ "#p14#", GetSpellInfo(17041) },	-- Master Axesmith
	{ "#p15#", GetSpellInfo(17039) },	-- Master Swordsmith
	{ "#p16#", GetSpellInfo(9787) },	-- Weaponsmith
	{ "#p17#", GetSpellInfo(20220) },	-- Gnomish Engineering
	{ "#p18#", GetSpellInfo(20221) },	-- Goblin Engineering
	{ "#p19#", GetSpellInfo(26798) },	-- Mooncloth Tailoring
	{ "#p20#", GetSpellInfo(26801) },	-- Shadoweave Tailoring
	{ "#p21#", GetSpellInfo(26797) },	-- Spellfire Tailoring
	{ "#p22#", GetSpellInfo(17040) },	-- Master Hammersmith
	{ "#p23#", GetSpellInfo(2575) },	-- Mining
	{ "#p24#", GetSpellInfo(63275) },	-- Fishing
	{ "#p25#", GetSpellInfo(78670) },	-- Archaeology
	{ "#p26#", GetSpellInfo(45357) },	-- Inscription
	
	-- Reputation
	{ "#r1#", BabbleFaction["Neutral"] },
	{ "#r2#", BabbleFaction["Friendly"] },
	{ "#r3#", BabbleFaction["Honored"] },
	{ "#r4#", BabbleFaction["Revered"] },
	{ "#r5#", BabbleFaction["Exalted"] },

	-- Armour Class
	{ "#a1#", BabbleInventory["Cloth"] },
	{ "#a2#", BabbleInventory["Leather"] },
	{ "#a3#", BabbleInventory["Mail"] },
	{ "#a4#", BabbleInventory["Plate"] },

	-- Body Slot
	{ "#s1#", BabbleInventory["Head"] },
	{ "#s2#", BabbleInventory["Neck"] },
	{ "#s3#", BabbleInventory["Shoulder"] },
	{ "#s4#", BabbleInventory["Back"] },
	{ "#s5#", BabbleInventory["Chest"] },
	{ "#s6#", BabbleInventory["Shirt"] },
	{ "#s7#", BabbleInventory["Tabard"] },
	{ "#s8#", BabbleInventory["Wrist"] },
	{ "#s9#", BabbleInventory["Hands"] },
	{ "#s10#", BabbleInventory["Waist"] },
	{ "#s11#", BabbleInventory["Legs"] },
	{ "#s12#", BabbleInventory["Feet"] },
	{ "#s13#", BabbleInventory["Ring"] },
	{ "#s14#", BabbleInventory["Trinket"] },
	{ "#s15#", BabbleInventory["Held in Off-Hand"] },
	{ "#s16#", BabbleInventory["Relic"] },

	-- Weapon Weilding
	{ "#h1#", BabbleInventory["One-Hand"] },
	{ "#h2#", BabbleInventory["Two-Hand"] },
	{ "#h3#", BabbleInventory["Main Hand"] },
	{ "#h4#", BabbleInventory["Off Hand"] },

	-- Weapon Type
	{ "#w1#", BabbleInventory["Axe"] },
	{ "#w2#", BabbleInventory["Bow"] },
	{ "#w3#", BabbleInventory["Crossbow"] },
	{ "#w4#", BabbleInventory["Dagger"] },
	{ "#w5#", BabbleInventory["Gun"] },
	{ "#w6#", BabbleInventory["Mace"] },
	{ "#w7#", BabbleInventory["Polearm"] },
	{ "#w8#", BabbleInventory["Shield"] },
	{ "#w9#", BabbleInventory["Staff"] },
	{ "#w10#", BabbleInventory["Sword"] },
	{ "#w11#", BabbleInventory["Thrown"] },
	{ "#w12#", BabbleInventory["Wand"] },
	{ "#w13#", BabbleInventory["Fist Weapon"] },

	-- Misc Inventory related words
	{ "#e1#", BabbleInventory["Bag"] },
	{ "#e2#", BabbleInventory["Potion"] },
	{ "#e3#", BabbleInventory["Food"] },
	{ "#e4#", BabbleInventory["Drink"] },
	{ "#e5#", BabbleInventory["Bandage"] },
	{ "#e6#", BabbleInventory["Trade Goods"] },
	{ "#e7#", BabbleInventory["Gem"] },
	{ "#e8#", BabbleInventory["Reagent"] },
	{ "#e9#", BabbleInventory["Key"] },
	{ "#e10#", BabbleInventory["Book"] },
	{ "#e11#", AL["Scope"] },
	{ "#e12#", BabbleInventory["Mount"] },
	{ "#e13#", BabbleInventory["Companion"] },
	{ "#e14#", AL["Banner"] },
	{ "#e15#", AL["Token"] },
	{ "#e16#", AL["Darkmoon Faire Card"] },
	{ "#e17#", BabbleInventory["Enchant"] },
	{ "#e18#", AL["Skinning Knife"] },
	{ "#e20#", BabbleInventory["Fishing Pole"] },
	{ "#e21#", BabbleInventory["Fish"] },
	{ "#e22#", AL["Combat Pet"] },
	{ "#e23#", AL["Fireworks"] },
	{ "#e24#", BabbleInventory["Fishing Lure"] },
	{ "#e25#", AL["Transformation Item"] },
	{ "#e26#", BabbleInventory["Ground Mount"] },
	{ "#e27#", BabbleInventory["Flying Mount"] },

	-- Labels for Loot Descriptions
	{ "#m1#", AL["Classes:"] },
	{ "#m2#", AL["This Item Begins a Quest"] },
	{ "#m3#", AL["Quest Item"] },
	{ "#m4#", AL["Quest Reward"] },
	{ "#m5#", AL["Shared"] },
	{ "#m6#", BabbleFaction["Horde"] },
	{ "#m7#", BabbleFaction["Alliance"] },
	{ "#m8#", AL["Unique"] },
	{ "#m9#", AL["Right Half"] },
	{ "#m10#", AL["Left Half"] },
	{ "#m11#", AL["28 Slot Soul Shard"] },--Is this still an item?
	{ "#m12#", AL["10 Slot"] },
	{ "#m13#", AL["16 Slot"] },
	{ "#m14#", AL["18 Slot"] },
	{ "#m15#", AL["20 Slot"] },
	{ "#m17#", AL["Currency"] },
	{ "#m20#", AL["Misc"] },
	{ "#m21#", AL["Tier 4"] },
	{ "#m22#", AL["Tier 5"] },
	{ "#m23#", AL["Tier 6"] },
	{ "#m24#", AL["Card Game Item"] },
	{ "#m26#", AL["Conjured Item"] },
	{ "#m27#", AL["Used to summon boss"] },
	{ "#m28#", AL["Feast of Winter Veil"] },
	{ "#m29#", AL["Tradable for sunmote + item above"] },
	{ "#m30#", AL["Tier 1"] },
	{ "#m31#", AL["Tier 2"] },
	{ "#m32#", AL["Achievement Reward"] },
	{ "#m34#", AL["Old Quest Reward"] },
	{ "#m35#", AL["Tier 3"] },
	{ "#m36#", AL["NOT AVAILABLE ANYMORE"]},
	{ "#m37#", AL["Tier 11"] },

	-- Misc
	{ "#j1#", AL["Normal Mode"] },
	{ "#j2#", AL["Raid"] },
	{ "#j3#", AL["Heroic Mode"] },
	{ "#j4#", AL["Heroic"] },
	{ "#j6#", AL["Dungeon Set 1"] },
	{ "#j7#", AL["Dungeon Set 2"] },
	{ "#j8#", AL["Token Hand-Ins"] },
	{ "#j9#", AL["Level 60"] },
	{ "#j10#", AL["Level 70"] },
	{ "#j11#", AL["Fire Resistance Gear"] },
	{ "#j12#", AL["Arcane Resistance Gear"] },
	{ "#j13#", AL["Nature Resistance Gear"] },
	{ "#j16#", AL["Phase 1"] },
	{ "#j17#", AL["Phase 2"] },
	{ "#j18#", AL["Phase 3"] },
	{ "#j19#", AL["Fire"] },
	{ "#j20#", AL["Water"] },
	{ "#j21#", AL["Wind"] },
	{ "#j22#", AL["Earth"] },
	{ "#j23#", AL["Master Angler"] },
	{ "#j24#", AL["First Prize"] },
	{ "#j25#", AL["Rare Fish Rewards"] },
	{ "#j26#", AL["Rare Fish"] },
	{ "#j27#", AL["Additional Heroic Loot"] },
	{ "#j28#", AL["Entrance"] },
	{ "#j30#", BabbleInventory["Mounts"] },
	{ "#j37#", AL["10 Man"] },
	{ "#j38#", AL["25 Man"] },
	{ "#j46#", AL["Hard Mode"] },
	{ "#j53#", AL["Hard Mode"] },
	{ "#j54#", AL["Level 80"] },

	-- Upper Deck Card Game
	{ "#ud1#", AL["Loot Card Items"] },

	-- ZG Tokens
	{ "#zgt1#", AL["Primal Hakkari Kossack"] },
	{ "#zgt2#", AL["Primal Hakkari Shawl"] },
	{ "#zgt3#", AL["Primal Hakkari Bindings"] },
	{ "#zgt4#", AL["Primal Hakkari Sash"] },
	{ "#zgt5#", AL["Primal Hakkari Stanchion"] },
	{ "#zgt6#", AL["Primal Hakkari Aegis"] },
	{ "#zgt7#", AL["Primal Hakkari Girdle"] },
	{ "#zgt8#", AL["Primal Hakkari Armsplint"] },
	{ "#zgt9#", AL["Primal Hakkari Tabard"] },

	-- AQ20 Tokens
	{ "#aq20t1#", AL["Qiraji Ornate Hilt"] },
	{ "#aq20t2#", AL["Qiraji Martial Drape"] },
	{ "#aq20t3#", AL["Qiraji Magisterial Ring"] },
	{ "#aq20t4#", AL["Qiraji Ceremonial Ring"] },
	{ "#aq20t5#", AL["Qiraji Regal Drape"] },
	{ "#aq20t6#", AL["Qiraji Spiked Hilt"] },

	-- AQ40 Tokens
	{ "#aq40t1#", AL["Qiraji Bindings of Dominance"] },
	{ "#aq40t2#", AL["Vek'nilash's Circlet"] },
	{ "#aq40t3#", AL["Ouro's Intact Hide"] },
	{ "#aq40t4#", AL["Husk of the Old God"] },
	{ "#aq40t5#", AL["Qiraji Bindings of Command"] },
	{ "#aq40t6#", AL["Vek'lor's Diadem"] },
	{ "#aq40t7#", AL["Skin of the Great Sandworm"] },
	{ "#aq40t8#", AL["Carapace of the Old God"] },

	-- Battleground Factions
	{ "#b1#", BabbleFaction["Stormpike Guard"] },
	{ "#b2#", BabbleFaction["Frostwolf Clan"] },
	{ "#b3#", BabbleFaction["Silverwing Sentinels"] },
	{ "#b4#", BabbleFaction["Warsong Outriders"] },
	{ "#b5#", BabbleFaction["The League of Arathor"] },
	{ "#b6#", BabbleFaction["The Defilers"] },

	-- BRD Arena Mini Bosses
	{ "#brd1#", BabbleBoss["Anub'shiah"] },
	{ "#brd2#", BabbleBoss["Eviscerator"] },
	{ "#brd3#", BabbleBoss["Gorosh the Dervish"] },
	{ "#brd4#", BabbleBoss["Grizzle"] },
	{ "#brd5#", BabbleBoss["Hedrum the Creeper"] },
	{ "#brd6#", BabbleBoss["Ok'thor the Breaker"] },

	-- Chests, Boxes, etc.
	{ "#x1#", AL["Timed Reward Chest 4"] },

	-- NPC Names
	{ "#n11#", AL["Trash Mobs"] },
	{ "#n17#", AL["Theldren"] },
	{ "#n18#", AL["Sothos and Jarien"] },
	{ "#n54#", AL["Nexus Stalker"] },
	{ "#n55#", AL["Auchenai Monk"] },
	{ "#n56#", AL["Cabal Fanatic"] },
	{ "#n57#", AL["Unchained Doombringer"] },
	{ "#n82#", AL["Raging Skeleton"] },
	{ "#n83#", AL["Ethereal Priest"] },
	{ "#n84#", AL["Sethekk Ravenguard"] },
	{ "#n85#", AL["Time-Lost Shadowmage"] },
	{ "#n86#", AL["Coilfang Sorceress"] },
	{ "#n87#", AL["Coilfang Oracle"] },
	{ "#n88#", AL["Shattered Hand Centurion"] },
	{ "#n89#", AL["Eredar Deathbringer"] },
	{ "#n90#", AL["Arcatraz Sentinel"] },
	{ "#n91#", AL["Gargantuan Abyssal"] },
	{ "#n92#", AL["Sunseeker Botanist"] },
	{ "#n93#", AL["Sunseeker Astromage"] },
	{ "#n94#", AL["Durnholde Rifleman"] },
	{ "#n95#", AL["Rift Keeper/Rift Lord"] },
	{ "#n96#", AL["Crimson Templar"] },
	{ "#n97#", AL["Azure Templar"] },
	{ "#n98#", AL["Hoary Templar"] },
	{ "#n99#", AL["Earthen Templar"] },
	{ "#n100#", AL["The Duke of Cynders"] },
	{ "#n101#", AL["The Duke of Fathoms"] },
	{ "#n102#", AL["The Duke of Zephyrs"] },
	{ "#n103#", AL["The Duke of Shards"] },
	{ "#n104#", BabbleBoss["Prince Skaldrenox"] },
	{ "#n105#", BabbleBoss["Lord Skwol"] },
	{ "#n106#", BabbleBoss["High Marshal Whirlaxis"] },
	{ "#n107#", BabbleBoss["Baron Kazum"] },
	{ "#n108#", BabbleBoss["Baron Charr"] },
	{ "#n109#", BabbleBoss["Princess Tempestria"] },
	{ "#n110#", BabbleBoss["Avalanchion"] },
	{ "#n111#", BabbleBoss["The Windreaver"] },
	{ "#n112#", AL["Aether-tech Assistant"] },
	{ "#n113#", AL["Aether-tech Adept"] },
	{ "#n114#", AL["Aether-tech Master"] },
	{ "#n118#", AL["Trelopades"] },
	{ "#n119#", AL["King Dorfbruiser"] },
	{ "#n120#", AL["Gorgolon the All-seeing"] },
	{ "#n121#", AL["Matron Li-sahar"] },
	{ "#n122#", AL["Solus the Eternal"] },
	{ "#n129#", AL["Smokywood Pastures Vendor"] },
	{ "#n131#", AL["Barleybrew Brewery"] },
	{ "#n132#", AL["Thunderbrew Brewery"] },
	{ "#n133#", AL["Gordok Brewery"] },
	{ "#n134#", AL["Drohn's Distillery"] },
	{ "#n135#", AL["T'chali's Voodoo Brewery"] },
	{ "#n136#", BabbleBoss["Headless Horseman"] },
	{ "#n137#", BabbleBoss["Illidan Stormrage"] },
	{ "#n138#", BabbleBoss["Vexallus"] },
	{ "#n139#", BabbleBoss["Aeonus"] },
	{ "#n150#", BabbleBoss["Coren Direbrew"] },

	-- Zone Names
	{ "#z1#", BabbleZone["The Deadmines"] },
	{ "#z2#", BabbleZone["Wailing Caverns"] },
	{ "#z3#", BabbleZone["Scarlet Monastery"] },
	{ "#z4#", BabbleZone["Blackrock Depths"] },
	{ "#z5#", BabbleZone["Scholomance"] },
	{ "#z6#", BabbleZone["Stratholme"] },
	{ "#z7#", AL["Various Locations"] },
	{ "#z8#", BabbleZone["Zul'Gurub"] },
	{ "#z9#", BabbleZone["Upper Blackrock Spire"] },
	{ "#z10#", BabbleZone["Lower Blackrock Spire"] },
	{ "#z12#", BabbleZone["Karazhan"] },
	{ "#z13#", BabbleZone["Dire Maul (East)"] },
	{ "#z14#", BabbleZone["Molten Core"] },
	{ "#z15#", BabbleZone["Onyxia's Lair"] },
	{ "#z17#", AL["World Drop"] },
	{ "#z18#", BabbleZone["Black Temple"] },
	{ "#z20#", BabbleZone["Un'Goro Crater"] },
	{ "#z21#", BabbleZone["Winterspring"] },
	{ "#z22#", BabbleZone["Azshara"] },
	{ "#z23#", BabbleZone["Silithus"] },
	{ "#z24#", BabbleZone["Azeroth"] },
	{ "#z25#", BabbleZone["Outland"] },
	{ "#z29#", BabbleZone["Zul'Aman"] },
	{ "#z30#", BabbleZone["Magisters' Terrace"] },
	{ "#z31#", BabbleZone["Shattrath City"] },
	{ "#z32#", BabbleZone["Isle of Quel'Danas"] },
	{ "#z33#", BabbleZone["The Black Morass"] },
	{ "#z34#", BabbleZone["Hyjal Summit"] },
	{ "#z38#", BabbleZone["The Obsidian Sanctum"] },
	{ "#z40#", BabbleZone["Northrend"] },

	-- Factions
	{ "#f1#", BabbleFaction["Lower City"] },
	{ "#f2#", BabbleFaction["The Sha'tar"] },
	{ "#f4#", BabbleFaction["Honor Hold"] },
	{ "#f5#", BabbleFaction["Keepers of Time"] },
	{ "#f6#", BabbleFaction["Cenarion Expedition"] },

	-- Blacksmithing Crafted Mail Sets
	{ "#craftbm1#", BabbleItemSet["Bloodsoul Embrace"] },
	{ "#craftbm2#", BabbleItemSet["Fel Iron Chain"] },

	-- Blacksmithing Crafted Plate Sets
	{ "#craftbp1#", BabbleItemSet["Imperial Plate"] },
	{ "#craftbp2#", BabbleItemSet["The Darksoul"] },
	{ "#craftbp3#", BabbleItemSet["Fel Iron Plate"] },
	{ "#craftbp4#", BabbleItemSet["Adamantite Battlegear"] },
	{ "#craftbp5#", BabbleItemSet["Flame Guard"] },
	{ "#craftbp6#", BabbleItemSet["Enchanted Adamantite Armor"] },
	{ "#craftbp7#", BabbleItemSet["Khorium Ward"] },
	{ "#craftbp8#", BabbleItemSet["Faith in Felsteel"] },
	{ "#craftbp9#", BabbleItemSet["Burning Rage"] },
	{ "#craftbp10#", BabbleItemSet["Ornate Saronite Battlegear"] },
	{ "#craftbp11#", BabbleItemSet["Savage Saronite Battlegear"] },

	-- Leatherworking Crafted Leather Sets
	{ "#craftlwl1#", BabbleItemSet["Volcanic Armor"] },
	{ "#craftlwl2#", BabbleItemSet["Ironfeather Armor"] },
	{ "#craftlwl3#", BabbleItemSet["Stormshroud Armor"] },
	{ "#craftlwl4#", BabbleItemSet["Devilsaur Armor"] },
	{ "#craftlwl5#", BabbleItemSet["Blood Tiger Harness"] },
	{ "#craftlwl6#", BabbleItemSet["Primal Batskin"] },
	{ "#craftlwl7#", BabbleItemSet["Wild Draenish Armor"] },
	{ "#craftlwl8#", BabbleItemSet["Thick Draenic Armor"] },
	{ "#craftlwl9#", BabbleItemSet["Fel Skin"] },
	{ "#craftlwl10#", BabbleItemSet["Strength of the Clefthoof"] },
	{ "#craftlwe1#", BabbleItemSet["Primal Intent"] },
	{ "#craftlwt1#", BabbleItemSet["Windhawk Armor"] },
	{ "#craftlwl11#", BabbleItemSet["Borean Embrace"] },
	{ "#craftlwl12#", BabbleItemSet["Iceborne Embrace"] },
	{ "#craftlwl13#", BabbleItemSet["Eviscerator's Battlegear"] },
	{ "#craftlwl14#", BabbleItemSet["Overcaster Battlegear"] },

	-- Leatherworking Crafted Mail Sets
	{ "#craftlwm1#", BabbleItemSet["Green Dragon Mail"] },
	{ "#craftlwm2#", BabbleItemSet["Blue Dragon Mail"] },
	{ "#craftlwm3#", BabbleItemSet["Black Dragon Mail"] },
	{ "#craftlwm4#", BabbleItemSet["Scaled Draenic Armor"] },
	{ "#craftlwm5#", BabbleItemSet["Felscale Armor"] },
	{ "#craftlwm6#", BabbleItemSet["Felstalker Armor"] },
	{ "#craftlwm7#", BabbleItemSet["Fury of the Nether"] },
	{ "#craftlwd1#", BabbleItemSet["Netherscale Armor"] },
	{ "#craftlwd2#", BabbleItemSet["Netherstrike Armor"] },
	{ "#craftlwm8#", BabbleItemSet["Frostscale Binding"] },
	{ "#craftlwm9#", BabbleItemSet["Nerubian Hive"] },
	{ "#craftlwm10#", BabbleItemSet["Stormhide Battlegear"] },
	{ "#craftlwm11#", BabbleItemSet["Swiftarrow Battlegear"] },

	-- Tailoring Crafted Sets
	{ "#craftt1#", BabbleItemSet["Bloodvine Garb"] },
	{ "#craftt2#", BabbleItemSet["Netherweave Vestments"] },
	{ "#craftt3#", BabbleItemSet["Imbued Netherweave"] },
	{ "#craftt4#", BabbleItemSet["Arcanoweave Vestments"] },
	{ "#craftt5#", BabbleItemSet["The Unyielding"] },
	{ "#craftt6#", BabbleItemSet["Whitemend Wisdom"] },
	{ "#craftt7#", BabbleItemSet["Spellstrike Infusion"] },
	{ "#craftt8#", BabbleItemSet["Battlecast Garb"] },
	{ "#craftt9#", BabbleItemSet["Soulcloth Embrace"] },
	{ "#crafttm1#", BabbleItemSet["Primal Mooncloth"] },
	{ "#crafttsh1#", BabbleItemSet["Shadow's Embrace"] },
	{ "#crafttsf1#", BabbleItemSet["Wrath of Spellfire"] },
	{ "#craftt10#", BabbleItemSet["Frostwoven Power"] },
	{ "#craftt11#", BabbleItemSet["Duskweaver"] },
	{ "#craftt12#", BabbleItemSet["Frostsavage Battlegear"] },

	-- Vanilla WoW Sets
	{ "#pre60s1#", BabbleItemSet["Defias Leather"] },
	{ "#pre60s2#", BabbleItemSet["Embrace of the Viper"] },
	{ "#pre60s3#", BabbleItemSet["Chain of the Scarlet Crusade"] },
	{ "#pre60s4#", BabbleItemSet["The Gladiator"] },
	{ "#pre60s5#", BabbleItemSet["Ironweave Battlesuit"] },
	{ "#pre60s6#", BabbleItemSet["Necropile Raiment"] },
	{ "#pre60s7#", BabbleItemSet["Cadaverous Garb"] },
	{ "#pre60s8#", BabbleItemSet["Bloodmail Regalia"] },
	{ "#pre60s9#", BabbleItemSet["Deathbone Guardian"] },
	{ "#pre60s10#", BabbleItemSet["The Postmaster"] },
	{ "#pre60s15#", BabbleItemSet["Shard of the Gods"] },
	{ "#pre60s16#", BabbleItemSet["Major Mojo Infusion"] },
	{ "#pre60s17#", BabbleItemSet["Overlord's Resolution"] },
	{ "#pre60s18#", BabbleItemSet["Prayer of the Primal"] },
	{ "#pre60s19#", BabbleItemSet["Zanzil's Concentration"] },
	{ "#pre60s20#", BabbleItemSet["Spirit of Eskhandar"] },
	{ "#pre60s21#", BabbleItemSet["The Twin Blades of Hakkari"] },
	{ "#pre60s22#", BabbleItemSet["Primal Blessing"] },
	{ "#pre60s23#", BabbleItemSet["Dal'Rend's Arms"] },
	{ "#pre60s24#", BabbleItemSet["Spider's Kiss"] },

	-- The Burning Crusade Sets
	{ "#bcs1#", BabbleItemSet["The Twin Stars"] },
	{ "#bcs2#", BabbleItemSet["The Twin Blades of Azzinoth"] },
	{ "#bcs3#", BabbleItemSet["Latro's Flurry"] },
	{ "#bcs4#", BabbleItemSet["The Fists of Fury"] },

	-- Wrath Of The Lich King Sets
	{ "#wotlk1#", BabbleItemSet["Raine's Revenge"] },
	{ "#wotlk2#", BabbleItemSet["Purified Shard of the Gods"] },
	{ "#wotlk3#", BabbleItemSet["Shiny Shard of the Gods"] },

	-- ZG Sets
	{ "#zgs1#", BabbleItemSet["Haruspex's Garb"] },
	{ "#zgs2#", BabbleItemSet["Predator's Armor"] },
	{ "#zgs3#", BabbleItemSet["Illusionist's Attire"] },
	{ "#zgs4#", BabbleItemSet["Freethinker's Armor"] },
	{ "#zgs5#", BabbleItemSet["Confessor's Raiment"] },
	{ "#zgs6#", BabbleItemSet["Madcap's Outfit"] },
	{ "#zgs7#", BabbleItemSet["Augur's Regalia"] },
	{ "#zgs8#", BabbleItemSet["Demoniac's Threads"] },
	{ "#zgs9#", BabbleItemSet["Vindicator's Battlegear"] },

	-- AQ20 Sets
	{ "#aq20s1#", BabbleItemSet["Symbols of Unending Life"] },
	{ "#aq20s2#", BabbleItemSet["Trappings of the Unseen Path"] },
	{ "#aq20s3#", BabbleItemSet["Trappings of Vaulted Secrets"] },
	{ "#aq20s4#", BabbleItemSet["Battlegear of Eternal Justice"] },
	{ "#aq20s5#", BabbleItemSet["Finery of Infinite Wisdom"] },
	{ "#aq20s6#", BabbleItemSet["Emblems of Veiled Shadows"] },
	{ "#aq20s7#", BabbleItemSet["Gift of the Gathering Storm"] },
	{ "#aq20s8#", BabbleItemSet["Implements of Unspoken Names"] },
	{ "#aq20s9#", BabbleItemSet["Battlegear of Unyielding Strength"] },

	-- AQ40 Sets
	{ "#aq40s1#", BabbleItemSet["Genesis Raiment"] },
	{ "#aq40s2#", BabbleItemSet["Striker's Garb"] },
	{ "#aq40s3#", BabbleItemSet["Enigma Vestments"] },
	{ "#aq40s4#", BabbleItemSet["Avenger's Battlegear"] },
	{ "#aq40s5#", BabbleItemSet["Garments of the Oracle"] },
	{ "#aq40s6#", BabbleItemSet["Deathdealer's Embrace"] },
	{ "#aq40s7#", BabbleItemSet["Stormcaller's Garb"] },
	{ "#aq40s8#", BabbleItemSet["Doomcaller's Attire"] },
	{ "#aq40s9#", BabbleItemSet["Conqueror's Battlegear"] },

	-- Dungeon 1 Sets
	{ "#t0s1#", BabbleItemSet["Wildheart Raiment"] },
	{ "#t0s2#", BabbleItemSet["Beaststalker Armor"] },
	{ "#t0s3#", BabbleItemSet["Magister's Regalia"] },
	{ "#t0s4#", BabbleItemSet["Lightforge Armor"] },
	{ "#t0s5#", BabbleItemSet["Vestments of the Devout"] },
	{ "#t0s6#", BabbleItemSet["Shadowcraft Armor"] },
	{ "#t0s7#", BabbleItemSet["The Elements"] },
	{ "#t0s8#", BabbleItemSet["Dreadmist Raiment"] },
	{ "#t0s9#", BabbleItemSet["Battlegear of Valor"] },

	-- Dungeon 2 Sets
	{ "#t05s1#", BabbleItemSet["Feralheart Raiment"] },
	{ "#t05s2#", BabbleItemSet["Beastmaster Armor"] },
	{ "#t05s3#", BabbleItemSet["Sorcerer's Regalia"] },
	{ "#t05s4#", BabbleItemSet["Soulforge Armor"] },
	{ "#t05s5#", BabbleItemSet["Vestments of the Virtuous"] },
	{ "#t05s6#", BabbleItemSet["Darkmantle Armor"] },
	{ "#t05s7#", BabbleItemSet["The Five Thunders"] },
	{ "#t05s8#", BabbleItemSet["Deathmist Raiment"] },
	{ "#t05s9#", BabbleItemSet["Battlegear of Heroism"] },

	-- Dungeon 3 Sets
	{ "#ds3s1#", BabbleItemSet["Hallowed Raiment"] },
	{ "#ds3s2#", BabbleItemSet["Incanter's Regalia"] },
	{ "#ds3s3#", BabbleItemSet["Mana-Etched Regalia"] },
	{ "#ds3s4#", BabbleItemSet["Oblivion Raiment"] },
	{ "#ds3s5#", BabbleItemSet["Assassination Armor"] },
	{ "#ds3s6#", BabbleItemSet["Moonglade Raiment"] },
	{ "#ds3s7#", BabbleItemSet["Wastewalker Armor"] },
	{ "#ds3s8#", BabbleItemSet["Beast Lord Armor"] },
	{ "#ds3s9#", BabbleItemSet["Desolation Battlegear"] },
	{ "#ds3s10#", BabbleItemSet["Tidefury Raiment"] },
	{ "#ds3s11#", BabbleItemSet["Bold Armor"] },
	{ "#ds3s12#", BabbleItemSet["Doomplate Battlegear"] },
	{ "#ds3s13#", BabbleItemSet["Righteous Armor"] },

	-- Tier 1 Sets
	{ "#t1s1#", BabbleItemSet["Cenarion Raiment"] },
	{ "#t1s2#", BabbleItemSet["Giantstalker Armor"] },
	{ "#t1s3#", BabbleItemSet["Arcanist Regalia"] },
	{ "#t1s4#", BabbleItemSet["Lawbringer Armor"] },
	{ "#t1s5#", BabbleItemSet["Vestments of Prophecy"] },
	{ "#t1s6#", BabbleItemSet["Nightslayer Armor"] },
	{ "#t1s7#", BabbleItemSet["The Earthfury"] },
	{ "#t1s8#", BabbleItemSet["Felheart Raiment"] },
	{ "#t1s9#", BabbleItemSet["Battlegear of Might"] },

	-- Tier 2 Sets
	{ "#t2s1#", BabbleItemSet["Stormrage Raiment"] },
	{ "#t2s2#", BabbleItemSet["Dragonstalker Armor"] },
	{ "#t2s3#", BabbleItemSet["Netherwind Regalia"] },
	{ "#t2s4#", BabbleItemSet["Judgement Armor"] },
	{ "#t2s5#", BabbleItemSet["Vestments of Transcendence"] },
	{ "#t2s6#", BabbleItemSet["Bloodfang Armor"] },
	{ "#t2s7#", BabbleItemSet["The Ten Storms"] },
	{ "#t2s8#", BabbleItemSet["Nemesis Raiment"] },
	{ "#t2s9#", BabbleItemSet["Battlegear of Wrath"] },

	-- Tier 3 Sets
	{ "#t3s1#", BabbleItemSet["Dreamwalker Raiment"] },
	{ "#t3s2#", BabbleItemSet["Cryptstalker Armor"] },
	{ "#t3s3#", BabbleItemSet["Frostfire Regalia"] },
	{ "#t3s4#", BabbleItemSet["Redemption Armor"] },
	{ "#t3s5#", BabbleItemSet["Vestments of Faith"] },
	{ "#t3s6#", BabbleItemSet["Bonescythe Armor"] },
	{ "#t3s7#", BabbleItemSet["The Earthshatterer"] },
	{ "#t3s8#", BabbleItemSet["Plagueheart Raiment"] },
	{ "#t3s9#", BabbleItemSet["Dreadnaught's Battlegear"] },

	-- Tier 4 Sets
	{ "#t4s1_1#", BabbleItemSet["Malorne Harness"] },
	{ "#t4s1_2#", BabbleItemSet["Malorne Raiment"] },
	{ "#t4s1_3#", BabbleItemSet["Malorne Regalia"] },
	{ "#t4s2#", BabbleItemSet["Demon Stalker Armor"] },
	{ "#t4s3#", BabbleItemSet["Aldor Regalia"] },
	{ "#t4s4_1#", BabbleItemSet["Justicar Armor"] },
	{ "#t4s4_2#", BabbleItemSet["Justicar Battlegear"] },
	{ "#t4s4_3#", BabbleItemSet["Justicar Raiment"] },
	{ "#t4s5_1#", BabbleItemSet["Incarnate Raiment"] },
	{ "#t4s5_2#", BabbleItemSet["Incarnate Regalia"] },
	{ "#t4s6#", BabbleItemSet["Netherblade"] },
	{ "#t4s7_1#", BabbleItemSet["Cyclone Harness"] },
	{ "#t4s7_2#", BabbleItemSet["Cyclone Raiment"] },
	{ "#t4s7_3#", BabbleItemSet["Cyclone Regalia"] },
	{ "#t4s8#", BabbleItemSet["Voidheart Raiment"] },
	{ "#t4s9_1#", BabbleItemSet["Warbringer Armor"] },
	{ "#t4s9_2#", BabbleItemSet["Warbringer Battlegear"] },

	-- Tier 5 Sets
	{ "#t5s1_1#", BabbleItemSet["Nordrassil Harness"] },
	{ "#t5s1_2#", BabbleItemSet["Nordrassil Raiment"] },
	{ "#t5s1_3#", BabbleItemSet["Nordrassil Regalia"] },
	{ "#t5s2#", BabbleItemSet["Rift Stalker Armor"] },
	{ "#t5s3#", BabbleItemSet["Tirisfal Regalia"] },
	{ "#t5s4_1#", BabbleItemSet["Crystalforge Armor"] },
	{ "#t5s4_2#", BabbleItemSet["Crystalforge Battlegear"] },
	{ "#t5s4_3#", BabbleItemSet["Crystalforge Raiment"] },
	{ "#t5s5_1#", BabbleItemSet["Avatar Raiment"] },
	{ "#t5s5_2#", BabbleItemSet["Avatar Regalia"] },
	{ "#t5s6#", BabbleItemSet["Deathmantle"] },
	{ "#t5s7_1#", BabbleItemSet["Cataclysm Harness"] },
	{ "#t5s7_2#", BabbleItemSet["Cataclysm Raiment"] },
	{ "#t5s7_3#", BabbleItemSet["Cataclysm Regalia"] },
	{ "#t5s8#", BabbleItemSet["Corruptor Raiment"] },
	{ "#t5s9_1#", BabbleItemSet["Destroyer Armor"] },
	{ "#t5s9_2#", BabbleItemSet["Destroyer Battlegear"] },

	-- Tier 6 Sets
	{ "#t6s1_1#", BabbleItemSet["Thunderheart Harness"] },
	{ "#t6s1_2#", BabbleItemSet["Thunderheart Raiment"] },
	{ "#t6s1_3#", BabbleItemSet["Thunderheart Regalia"] },
	{ "#t6s2#", BabbleItemSet["Gronnstalker's Armor"] },
	{ "#t6s3#", BabbleItemSet["Tempest Regalia"] },
	{ "#t6s4_1#", BabbleItemSet["Lightbringer Armor"] },
	{ "#t6s4_2#", BabbleItemSet["Lightbringer Battlegear"] },
	{ "#t6s4_3#", BabbleItemSet["Lightbringer Raiment"] },
	{ "#t6s5_1#", BabbleItemSet["Vestments of Absolution"] },
	{ "#t6s5_2#", BabbleItemSet["Absolution Regalia"] },
	{ "#t6s6#", BabbleItemSet["Slayer's Armor"] },
	{ "#t6s7_1#", BabbleItemSet["Skyshatter Harness"] },
	{ "#t6s7_2#", BabbleItemSet["Skyshatter Raiment"] },
	{ "#t6s7_3#", BabbleItemSet["Skyshatter Regalia"] },
	{ "#t6s8#", BabbleItemSet["Malefic Raiment"] },
	{ "#t6s9_1#", BabbleItemSet["Onslaught Armor"] },
	{ "#t6s9_2#", BabbleItemSet["Onslaught Battlegear"] },

	-- Tier 7 Sets
	{ "#t7s1_1#", BabbleItemSet["Dreamwalker Garb"] },
	{ "#t7s1_2#", BabbleItemSet["Dreamwalker Battlegear"] },
	{ "#t7s1_3#", BabbleItemSet["Dreamwalker Regalia"] },
	{ "#t7s2#", BabbleItemSet["Cryptstalker Battlegear"] },
	{ "#t7s3#", BabbleItemSet["Frostfire Garb"] },
	{ "#t7s4_1#", BabbleItemSet["Redemption Regalia"] },
	{ "#t7s4_2#", BabbleItemSet["Redemption Battlegear"] },
	{ "#t7s4_3#", BabbleItemSet["Redemption Plate"] },
	{ "#t7s5_1#", BabbleItemSet["Regalia of Faith"] },
	{ "#t7s5_2#", BabbleItemSet["Garb of Faith"] },
	{ "#t7s6#", BabbleItemSet["Bonescythe Battlegear"] },
	{ "#t7s7_1#", BabbleItemSet["Earthshatter Garb"] },
	{ "#t7s7_2#", BabbleItemSet["Earthshatter Battlegear"] },
	{ "#t7s7_3#", BabbleItemSet["Earthshatter Regalia"] },
	{ "#t7s8#", BabbleItemSet["Plagueheart Garb"] },
	{ "#t7s9_1#", BabbleItemSet["Dreadnaught Battlegear"] },
	{ "#t7s9_2#", BabbleItemSet["Dreadnaught Plate"] },
	{ "#t7s10_1#", BabbleItemSet["Scourgeborne Battlegear"] },
	{ "#t7s10_2#", BabbleItemSet["Scourgeborne Plate"] },

	-- Tier 8 Sets
	{ "#t8s1_1#", BabbleItemSet["Nightsong Garb"] },
	{ "#t8s1_2#", BabbleItemSet["Nightsong Battlegear"] },
	{ "#t8s1_3#", BabbleItemSet["Nightsong Regalia"] },
	{ "#t8s2#", BabbleItemSet["Scourgestalker Battlegear"] },
	{ "#t8s3#", BabbleItemSet["Kirin Tor Garb"] },
	{ "#t8s4_1#", BabbleItemSet["Aegis Regalia"] },
	{ "#t8s4_2#", BabbleItemSet["Aegis Battlegear"] },
	{ "#t8s4_3#", BabbleItemSet["Aegis Plate"] },
	{ "#t8s5_1#", BabbleItemSet["Sanctification Regalia"] },
	{ "#t8s5_2#", BabbleItemSet["Sanctification Garb"] },
	{ "#t8s6#", BabbleItemSet["Terrorblade Battlegear"] },
	{ "#t8s7_1#", BabbleItemSet["Worldbreaker Garb"] },
	{ "#t8s7_2#", BabbleItemSet["Worldbreaker Battlegear"] },
	{ "#t8s7_3#", BabbleItemSet["Worldbreaker Regalia"] },
	{ "#t8s8#", BabbleItemSet["Deathbringer Garb"] },
	{ "#t8s9_1#", BabbleItemSet["Siegebreaker Battlegear"] },
	{ "#t8s9_2#", BabbleItemSet["Siegebreaker Plate"] },
	{ "#t8s10_1#", BabbleItemSet["Darkruned Battlegear"] },
	{ "#t8s10_2#", BabbleItemSet["Darkruned Plate"] },

	-- Tier 9 Sets
	{ "#t9s1_1a#", BabbleItemSet["Malfurion's Garb"] },
	{ "#t9s1_1h#", BabbleItemSet["Runetotem's Garb"] },
	{ "#t9s1_2a#", BabbleItemSet["Malfurion's Battlegear"] },
	{ "#t9s1_2h#", BabbleItemSet["Runetotem's Battlegear"] },
	{ "#t9s1_3a#", BabbleItemSet["Malfurion's Regalia"] },
	{ "#t9s1_3h#", BabbleItemSet["Runetotem's Regalia"] },
	{ "#t9s2_a#", BabbleItemSet["Windrunner's Battlegear"] },
	{ "#t9s2_h#", BabbleItemSet["Windrunner's Pursuit"] },
	{ "#t9s3_a#", BabbleItemSet["Khadgar's Regalia"] },
	{ "#t9s3_h#", BabbleItemSet["Sunstrider's Regalia"] },
	{ "#t9s4_1a#", BabbleItemSet["Turalyon's Garb"] },
	{ "#t9s4_1h#", BabbleItemSet["Liadrin's Garb"] },
	{ "#t9s4_2a#", BabbleItemSet["Turalyon's Battlegear"] },
	{ "#t9s4_2h#", BabbleItemSet["Liadrin's Battlegear"] },
	{ "#t9s4_3a#", BabbleItemSet["Turalyon's Plate"] },
	{ "#t9s4_3h#", BabbleItemSet["Liadrin's Plate"] },
	{ "#t9s5_1a#", BabbleItemSet["Velen's Regalia"] },
	{ "#t9s5_1h#", BabbleItemSet["Zabra's Regalia"] },
	{ "#t9s5_2a#", BabbleItemSet["Velen's Raiment"] },
	{ "#t9s5_2h#", BabbleItemSet["Zabra's Raiment"] },
	{ "#t9s6_a#", BabbleItemSet["VanCleef's Battlegear"] },
	{ "#t9s6_h#", BabbleItemSet["Garona's Battlegear"] },
	{ "#t9s7_1a#", BabbleItemSet["Nobundo's Garb"] },
	{ "#t9s7_1h#", BabbleItemSet["Thrall's Garb"] },
	{ "#t9s7_2a#", BabbleItemSet["Nobundo's Battlegear"] },
	{ "#t9s7_2h#", BabbleItemSet["Thrall's Battlegear"] },
	{ "#t9s7_3a#", BabbleItemSet["Nobundo's Regalia"] },
	{ "#t9s7_3h#", BabbleItemSet["Thrall's Regalia"] },
	{ "#t9s8_a#", BabbleItemSet["Kel'Thuzad's Regalia"] },
	{ "#t9s8_h#", BabbleItemSet["Gul'dan's Regalia"] },
	{ "#t9s9_1a#", BabbleItemSet["Wrynn's Battlegear"] },
	{ "#t9s9_1h#", BabbleItemSet["Hellscream's Battlegear"] },
	{ "#t9s9_2a#", BabbleItemSet["Wrynn's Plate"] },
	{ "#t9s9_2h#", BabbleItemSet["Hellscream's Plate"] },
	{ "#t9s10_1a#", BabbleItemSet["Thassarian's Plate"] },
	{ "#t9s10_1h#", BabbleItemSet["Koltira's Plate"] },
	{ "#t9s10_2a#", BabbleItemSet["Thassarian's Battlegear"] },
	{ "#t9s10_2h#", BabbleItemSet["Koltira's Battlegear"] },

	-- Tier 10 Sets
	{ "#t10s1_1#", BabbleItemSet["Lasherweave Garb"] },
	{ "#t10s1_2#", BabbleItemSet["Lasherweave Battlegear"] },
	{ "#t10s1_3#", BabbleItemSet["Lasherweave Regalia"] },
	{ "#t10s2#", BabbleItemSet["Ahn'Kahar Blood Hunter's Battlegear"] },
	{ "#t10s3#", BabbleItemSet["Bloodmage's Regalia"] },
	{ "#t10s4_1#", BabbleItemSet["Lightsworn Garb"] },
	{ "#t10s4_2#", BabbleItemSet["Lightsworn Plate"] },
	{ "#t10s4_3#", BabbleItemSet["Lightsworn Battlegear"] },
	{ "#t10s5_1#", BabbleItemSet["Crimson Acolyte's Regalia"] },
	{ "#t10s5_2#", BabbleItemSet["Crimson Acolyte's Raiment"] },
	{ "#t10s6#", BabbleItemSet["Shadowblade's Battlegear"] },
	{ "#t10s7_1#", BabbleItemSet["Frost Witch's Garb"] },
	{ "#t10s7_2#", BabbleItemSet["Frost Witch's Battlegear"] },
	{ "#t10s7_3#", BabbleItemSet["Frost Witch's Regalia"] },
	{ "#t10s8#", BabbleItemSet["Dark Coven's Regalia"] },
	{ "#t10s9_1#", BabbleItemSet["Ymirjar Lord's Battlegear"] },
	{ "#t10s9_2#", BabbleItemSet["Ymirjar Lord's Plate"] },
	{ "#t10s10_1#", BabbleItemSet["Scourgelord's Battlegear"] },
	{ "#t10s10_2#", BabbleItemSet["Scourgelord's Plate"] },

	-- Tier 11 Sets
	{ "#t11s1_1#", BabbleItemSet["Stormrider's Vestments"] },
	{ "#t11s1_2#", BabbleItemSet["Stormrider's Battlegarb"] },
	{ "#t11s1_3#", BabbleItemSet["Stormrider's Regalia"] },
	{ "#t11s2#", BabbleItemSet["Lightning-Charged Battlegear"] },
	{ "#t11s3#", BabbleItemSet["Firelord's Vestments"] },
	{ "#t11s4_1#", BabbleItemSet["Reinforced Sapphirium Regalia"] },
	{ "#t11s4_2#", BabbleItemSet["Reinforced Sapphirium Battlearmor"] },
	{ "#t11s4_3#", BabbleItemSet["Reinforced Sapphirium Battleplate"] },
	{ "#t11s5_1#", BabbleItemSet["Mercurial Regalia"] },
	{ "#t11s5_2#", BabbleItemSet["Mercurial Vestments"] },
	{ "#t11s6#", BabbleItemSet["Wind Dancer's Regalia"] },
	{ "#t11s7_1#", BabbleItemSet["Vestments of the Raging Elements"] },
	{ "#t11s7_2#", BabbleItemSet["Battlegear of the Raging Elements"] },
	{ "#t11s7_3#", BabbleItemSet["Regalia of the Raging Elements"] },
	{ "#t11s8#", BabbleItemSet["Shadowflame Regalia"] },
	{ "#t11s9_1#", BabbleItemSet["Earthen Warplate"] },
	{ "#t11s9_2#", BabbleItemSet["Earthen Battleplate"] },
	{ "#t11s10_1#", BabbleItemSet["Magma Plated Battlegear"] },
	{ "#t11s10_2#", BabbleItemSet["Magma Plated Battlearmor"] },

	-- Arathi Basin Sets - Alliance
	{ "#absa1#", BabbleItemSet["The Highlander's Intent"] },
	{ "#absa2#", BabbleItemSet["The Highlander's Purpose"] },
	{ "#absa3#", BabbleItemSet["The Highlander's Will"] },
	{ "#absa4#", BabbleItemSet["The Highlander's Determination"] },
	{ "#absa5#", BabbleItemSet["The Highlander's Fortitude"] },
	{ "#absa6#", BabbleItemSet["The Highlander's Resolution"] },
	{ "#absa7#", BabbleItemSet["The Highlander's Resolve"] },

	-- Arathi Basin Sets - Horde
	{ "#absh1#", BabbleItemSet["The Defiler's Intent"] },
	{ "#absh2#", BabbleItemSet["The Defiler's Purpose"] },
	{ "#absh3#", BabbleItemSet["The Defiler's Will"] },
	{ "#absh4#", BabbleItemSet["The Defiler's Determination"] },
	{ "#absh5#", BabbleItemSet["The Defiler's Fortitude"] },
	{ "#absh6#", BabbleItemSet["The Defiler's Resolution"] },

	-- PvP Level 60 Rare Sets - Alliance 
	{ "#pvpra1#", BabbleItemSet["Lieutenant Commander's Refuge"] },
	{ "#pvpra2#", BabbleItemSet["Lieutenant Commander's Pursuance"] },
	{ "#pvpra3#", BabbleItemSet["Lieutenant Commander's Arcanum"] },
	{ "#pvpra4#", BabbleItemSet["Lieutenant Commander's Redoubt"] },
	{ "#pvpra5#", BabbleItemSet["Lieutenant Commander's Investiture"] },
	{ "#pvpra6#", BabbleItemSet["Lieutenant Commander's Guard"] },
	{ "#pvpra7#", BabbleItemSet["Lieutenant Commander's Dreadgear"] },
	{ "#pvpra8#", BabbleItemSet["Lieutenant Commander's Battlearmor"] },
	{ "#pvpra9#", BabbleItemSet["Lieutenant Commander's Earthshaker"] }, -- This set should be "Lieutenant Commander's Earthshaker", not "Lieutenant Commander's Stormcaller"

	-- PvP Level 60 Rare Sets - Horde
	{ "#pvprh1#", BabbleItemSet["Champion's Refuge"] },
	{ "#pvprh2#", BabbleItemSet["Champion's Pursuance"] },
	{ "#pvprh3#", BabbleItemSet["Champion's Arcanum"] },
	{ "#pvprh4#", BabbleItemSet["Champion's Investiture"] },
	{ "#pvprh5#", BabbleItemSet["Champion's Guard"] },
	{ "#pvprh6#", BabbleItemSet["Champion's Stormcaller"] },
	{ "#pvprh7#", BabbleItemSet["Champion's Dreadgear"] },
	{ "#pvprh8#", BabbleItemSet["Champion's Battlearmor"] },
	{ "#pvprh9#", BabbleItemSet["Champion's Redoubt"] },

	-- PvP Level 60 Epic Sets - Alliance
	{ "#pvpea1#", BabbleItemSet["Field Marshal's Sanctuary"] },
	{ "#pvpea2#", BabbleItemSet["Field Marshal's Pursuit"] },
	{ "#pvpea3#", BabbleItemSet["Field Marshal's Regalia"] },
	{ "#pvpea4#", BabbleItemSet["Field Marshal's Aegis"] },
	{ "#pvpea5#", BabbleItemSet["Field Marshal's Raiment"] },
	{ "#pvpea6#", BabbleItemSet["Field Marshal's Vestments"] },
	{ "#pvpea7#", BabbleItemSet["Field Marshal's Threads"] },
	{ "#pvpea8#", BabbleItemSet["Field Marshal's Battlegear"] },
	{ "#pvpea9#", BabbleItemSet["Field Marshal's Earthshaker"] },

	-- PvP Level 60 Epic Sets - Horde
	{ "#pvpeh1#", BabbleItemSet["Warlord's Sanctuary"] },
	{ "#pvpeh2#", BabbleItemSet["Warlord's Pursuit"] },
	{ "#pvpeh3#", BabbleItemSet["Warlord's Regalia"] },
	{ "#pvpeh4#", BabbleItemSet["Warlord's Raiment"] },
	{ "#pvpeh5#", BabbleItemSet["Warlord's Vestments"] },
	{ "#pvpeh6#", BabbleItemSet["Warlord's Earthshaker"] },
	{ "#pvpeh7#", BabbleItemSet["Warlord's Threads"] },
	{ "#pvpeh8#", BabbleItemSet["Warlord's Battlegear"] },
	{ "#pvpeh9#", BabbleItemSet["Warlord's Aegis"] },

	-- Outland Faction Reputation PvP Sets
	{ "#pvprep701_1#", BabbleItemSet["Dragonhide Battlegear"] },
	{ "#pvprep701_2#", BabbleItemSet["Wyrmhide Battlegear"] },
	{ "#pvprep701_3#", BabbleItemSet["Kodohide Battlegear"] },
	{ "#pvprep702#", BabbleItemSet["Stalker's Chain Battlegear"] },
	{ "#pvprep703#", BabbleItemSet["Evoker's Silk Battlegear"] },
	{ "#pvprep704_1#", BabbleItemSet["Crusader's Scaled Battlegear"] },
	{ "#pvprep704_2#", BabbleItemSet["Crusader's Ornamented Battlegear"] },
	{ "#pvprep705_1#", BabbleItemSet["Satin Battlegear"] },
	{ "#pvprep705_2#", BabbleItemSet["Mooncloth Battlegear"] },
	{ "#pvprep706#", BabbleItemSet["Opportunist's Battlegear"] },
	{ "#pvprep707_1#", BabbleItemSet["Seer's Linked Battlegear"] },
	{ "#pvprep707_2#", BabbleItemSet["Seer's Mail Battlegear"] },
	{ "#pvprep707_3#", BabbleItemSet["Seer's Ringmail Battlegear"] },
	{ "#pvprep708#", BabbleItemSet["Dreadweave Battlegear"] },
	{ "#pvprep709#", BabbleItemSet["Savage Plate Battlegear"] },

	-- Arena Epic Sets
	{ "#reqrating#", AL["Rating:"] },
	{ "#arenas1_1#", BabbleItemSet["Gladiator's Sanctuary"] },
	{ "#arenas1_2#", BabbleItemSet["Gladiator's Wildhide"] },
	{ "#arenas1_3#", BabbleItemSet["Gladiator's Refuge"] },
	{ "#arenas2#", BabbleItemSet["Gladiator's Pursuit"] },
	{ "#arenas3#", BabbleItemSet["Gladiator's Regalia"] },
	{ "#arenas4_1#", BabbleItemSet["Gladiator's Aegis"] },
	{ "#arenas4_2#", BabbleItemSet["Gladiator's Vindication"] },
	{ "#arenas4_3#", BabbleItemSet["Gladiator's Redemption"] },
	{ "#arenas5_1#", BabbleItemSet["Gladiator's Raiment"] },
	{ "#arenas5_2#", BabbleItemSet["Gladiator's Investiture"] },
	{ "#arenas6#", BabbleItemSet["Gladiator's Vestments"] },
	{ "#arenas7_1#", BabbleItemSet["Gladiator's Earthshaker"] },
	{ "#arenas7_2#", BabbleItemSet["Gladiator's Thunderfist"] },
	{ "#arenas7_3#", BabbleItemSet["Gladiator's Wartide"] },
	{ "#arenas8_1#", BabbleItemSet["Gladiator's Dreadgear"] },
	{ "#arenas8_2#", BabbleItemSet["Gladiator's Felshroud"] },
	{ "#arenas9#", BabbleItemSet["Gladiator's Battlegear"] },
	{ "#arenas10#", BabbleItemSet["Gladiator's Desecration"] },

	-- Crafting
	{ "#sr#", AL["Skill Required:"] },
	{ "#sk#", AL["Skill"] },

	-- Misc PvP Set Text
	{ "#pvps1#", AL["Epic Set"] },
	{ "#pvps2#", AL["Rare Set"] },

	-- Text Colouring
	{ "=q0=", "|cff9d9d9d" },	-- Gray
	{ "=q1=", "|cffFFFFFF" },	-- White
	{ "=q2=", "|cff1eff00" },	-- Green
	{ "=q3=", "|cff0070dd" },	-- Blue
	{ "=q4=", "|cffa335ee" },	-- Purple
	{ "=q5=", "|cffFF8000" },	-- Orange
	{ "=q6=", "|cffFF0000" },	-- Red 
	{ "=q7=", "|cffe6cc80" },	-- Beige
	{ "=ec1=", "|cffFF8400" },	-- Orange
	{ "=ds=", "|cffFFd200" },	-- Yellow

	-- Months
	{ "#month1#", AL["January"] },
	{ "#month2#", AL["February"] },
	{ "#month3#", AL["March"] },
	{ "#month4#", AL["April"] },
	{ "#month5#", AL["May"] },
	{ "#month6#", AL["June"] },
	{ "#month7#", AL["July"] },
	{ "#month8#", AL["August"] },
	{ "#month9#", AL["September"] },
	{ "#month10#", AL["October"] },
	{ "#month11#", AL["November"] },
	{ "#month12#", AL["December"] },

	-- Currency Icons
	{ "#gold#", "|TInterface\\AddOns\\AtlasLoot\\Images\\gold:0|t" },
	{ "#silver#", "|TInterface\\AddOns\\AtlasLoot\\Images\\silver:0|t" },
	{ "#copper#", "|TInterface\\AddOns\\AtlasLoot\\Images\\bronze:0|t" },

	-- Currency Icons - PvP
	{ "#arena#", "|TInterface\\PVPFrame\\PVP-ArenaPoints-Icon:0|t" },
	{ "#markthrallmar#", "|TInterface\\Icons\\INV_Misc_Token_Thrallmar:0|t" },
	{ "#markhhold#", "|TInterface\\Icons\\INV_Misc_Token_HonorHold:0|t" },
	{ "#halaabattle#", "|TInterface\\Icons\\INV_Misc_Rune_08:0|t" },
	{ "#halaaresearch#", "|TInterface\\Icons\\INV_Misc_Rune_09:0|t" },
	{ "#spiritshard#", "|TInterface\\Icons\\INV_Jewelry_FrostwolfTrinket_04:0|t" },
	{ "#wintergrasp#", "|TInterface\\Icons\\INV_Misc_Platnumdisks:0|t" },
	{ "#tolbarad#", "|TInterface\\Icons\\achievement_zone_tolbarad:0|t" },

	-- Currency Icons - PvE
	{ "#t10mark#", "|TInterface\\Icons\\ability_paladin_shieldofthetemplar:0|t"},
	{ "#trophyofthecrusade#", "|TInterface\\Icons\\INV_Misc_Trophy_Argent:0|t" },
	{ "#justice#", "|TInterface\\Icons\\pvecurrency-justice:0|t"},
	{ "#valor#", "|TInterface\\Icons\\pvecurrency-valor:0|t"},

	-- Currency Icons - Events
	{ "#darkmoon#", "|TInterface\\Icons\\INV_Misc_Ticket_Darkmoon_01:0|t" },
	{ "#noblegarden#", "|TInterface\\Icons\\Achievement_Noblegarden_Chocolate_Egg:0|t" },
	{ "#brewfest#", "|TInterface\\Icons\\INV_Misc_Coin_01:0|t" },
	{ "#valentineday#", "|TInterface\\Icons\\inv_valentinescard01:0|t"},
	{ "#valentineday2#", "|TInterface\\Icons\\inv_jewelry_necklace_43:0|t"},

	-- Currency Icons - Factions
	{ "#ccombat#", "|TInterface\\Icons\\INV_Jewelry_Talisman_06:0|t" },
	{ "#champseal#", "|TInterface\\Icons\\Ability_Paladin_ArtofWar:0|t" },
	{ "#champwrit#", "|TInterface\\Icons\\INV_Scroll_11:0|t" },
	{ "#ctactical#", "|TInterface\\Icons\\INV_Jewelry_Amulet_02:0|t" },
	{ "#clogistics#", "|TInterface\\Icons\\INV_Jewelry_Necklace_16:0|t" },
	{ "#cremulos#", "|TInterface\\Icons\\INV_Jewelry_Necklace_14:0|t" },
	{ "#ccenarius#", "|TInterface\\Icons\\INV_Jewelry_Necklace_12:0|t" },
	{ "#zandalar#", "|TInterface\\Icons\\INV_Misc_Coin_08:0|t" },
	{ "#glowcap#", "|TInterface\\Icons\\INV_Mushroom_02:0|t" },
	{ "#ogrilashard#", "|TInterface\\Icons\\INV_Misc_Apexis_Shard:0|t" },
	{ "#ogrilacrystal#", "|TInterface\\Icons\\INV_Misc_Apexis_Crystal:0|t" },
	{ "#winterfinclam#", "|TInterface\\Icons\\INV_Misc_Shell_03:0|t" },
	{ "#fireflower#", "|TInterface\\Icons\\INV_SummerFest_FireFlower:0|t" },

	-- Currency Icons - Crafting Recipes
	{ "#cookingaward#", "|TInterface\\Icons\\inv_misc_ribbon_01:0|t"},
	{ "#chefaward#", "|TInterface\\Icons\\achievement_profession_chefhat:0|t"},
	{ "#elementiumbar#", "|TInterface\\Icons\\inv_misc_pyriumbar:0|t"},
	{ "#hardenedelementiumbar#", "|TInterface\\Icons\\inv_misc_ebonsteelbar:0|t"},
	{ "#pyriumbar#", "|TInterface\\Icons\\inv_misc_pyriumbar_02:0|t"},
	{ "#heavenlyshard#", "|TInterface\\Icons\\inv_misc_largeshard_superior:0|t"},
	{ "#hypnoticdust#", "|TInterface\\Icons\\inv_enchant_dust:0|t"},
	{ "#maelstromcrystal#", "|TInterface\\Icons\\inv_misc_crystalepic:0|t"},
	{ "#embersilkboltl#", "|TInterface\\Icons\\inv_misc_emberweavecloth_01:0|t"},
	{ "#dreamcloth#", "|TInterface\\Icons\\inv_chest_cloth_57:0|t"},
	{ "#heavysavageleather#", "|TInterface\\Icons\\item_savageleatherhide:0|t"},
}

--------------------------------------------------------------------------------
-- Text replacement function
--------------------------------------------------------------------------------
function AtlasLoot:FixText(text)
	if not text or text == "" then return "" end
	for k,_ in pairs(AtlasLoot_TextParsing) do
		text = gsub(text, AtlasLoot_TextParsing[k][1], AtlasLoot_TextParsing[k][2]);
	end

    englishFaction, _ = UnitFactionGroup("player")
    if englishFaction == "Horde" then
		text = gsub(text, "#honor#", "|TInterface\\Icons\\pvpcurrency-honor-horde:0|t");
		text = gsub(text, "#conquest#", "|TInterface\\Icons\\pvpcurrency-conquest-horde:0|t");
		text = gsub(text, "#factionoutlandPvP#", "|TInterface\\AddOns\\AtlasLoot\\Images\\Horde:0|t");
		text = gsub(text, "#markthrallmarhhold#", "|TInterface\\Icons\\INV_Misc_Token_Thrallmar:0|t");
    else
		text = gsub(text, "#honor#", "|TInterface\\Icons\\pvpcurrency-honor-alliance:0|t");
		text = gsub(text, "#conquest#", "|TInterface\\Icons\\pvpcurrency-conquest-alliance:0|t");
		text = gsub(text, "#factionoutlandPvP#", "|TInterface\\AddOns\\AtlasLoot\\Images\\Alliance:0|t");
		text = gsub(text, "#markthrallmarhhold#", "|TInterface\\Icons\\INV_Misc_Token_HonorHold:0|t");
    end

    return text;
end

function AtlasLoot:FixTextBack(text)
	if not text or text == "" then return "" end
	
	text = gsub(text, "Miscellaneous", "#m20#");
	for k,_ in pairs(AtlasLoot_TextParsing) do
		text = gsub(text, AtlasLoot_TextParsing[k][2], AtlasLoot_TextParsing[k][1]);
	end

    return text;
end