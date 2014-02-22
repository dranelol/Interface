-- French translation provided by Pelion of ri.gametraveler.ch.  Thanks Pelion!

if (GetLocale() == "frFR") then

WHOHAS_SUBTEXT = "These options allow you to control what information WhoHas includes in your tooltips.";

WhoHas.support = {
   ["none"]                     = "WhoHas: Pas d'inventaire addon trouv\195\169",
   ["SizPoss"]                  = "WhoHas: Utilise les donn\195\169es de Possessions",
   ["LSPoss"]                   = "WhoHas: Utilise les donn\195\169es de Lauchsuppe's Possessions",
   ["CP"]                       = "WhoHas: Utilise les donn\195\169es de CharacterProfiler",
   ["Armory"]                   = "WhoHas: Utilise les donn\195\169es de l'Armurerie",
   ["Altoholic"]                = "WhoHas: Utilise les donn\195\169es de Altoholic",
   ["Bagnon"]                   = "WhoHas: Utilise les donn\195\169es de Bagnon",
}

WhoHas.text = {
   ["WhoHasConfigFrame"]        = "WhoHas Config.",
   ["WhoHasCloseButton"]        = "Fermer",
   ["WhoHasEnableButton"]       = "Activer WhoHas",
   ["WhoHasTotalsButton"]       = "Montrez les totaux",
   ["WhoHasStackSizeButton"]    = "Montrez les tailles de pile",
   ["WhoHasInboxButton"]        = "Incluez le bo\195\174te aux lettre",
   ["WhoHasVoidStoreButton"]    = "Incluez le chambre du vire",
   ["WhoHasEquipmentButton"]    = "Incluez les objets \195\169quip\195\169s",
   ["WhoHasBagsButton"]         = "Incluez les sacs \195\169quip\195\169s",
   ["WhoHasVaultButton"]        = "Incluez le coffre-fort de guilde",
   ["WhoHasWorldButton"]        = "D\195\169sactiver les tooltip mondiaux",
   ["WhoHasMinesButton"]        = "Montrez les comptes de minerai pour des mines",
   ["WhoHasOresButton"]         = "Montrez les comptes de barres, primordials et essences",
   ["WhoHasAllGuildsButton"]    = "Montrez les coffre-forts de guildes alternatives",
   ["WhoHasTabsButton"]         = "Montrez les sujets bancaire dans le coffre-forte de guilde",
   ["WhoHasFactionsButton"]     = "Include both factions",
   ["WhoHasRealmsButton"]       = "Include all realms",

   ["WhoHasBackendSelection"]   = "Use data from addon:",

   ["ignore"]                   = "ignore",
   ["usage"]                    = "usage: /whohas [ignore ARTICLE]",

   ["auto"]                     = "Auto-detect",
   ["armory"]                   = "Armory",
   ["possess"]                  = "Possessions",
   ["charprof"]                 = "CharacterProfiler",
   ["altoholic"]                = "Altoholic",
   ["bagnon"]                   = "Bagnon",
}

WHOHAS_BACKEND_TEXT = WhoHas.text.WhoHasBackendSelection;

WhoHas.formats = {
   ["inventory"]                = "%u dans %s's Inventaire",
   ["bank"]                     = "%u sur %s's Banque",
   ["inbox"]                    = "%u dans %s's Bo\195\174te aux lettre",
   ["keyring"]                  = "%u \195\160 %s's Porte-cl\195\169s",
   ["equipment"]                = "%u dans %s's Objets \195\169quip\195\169s",
   ["invbags"]                  = "%u dans %s's Sacs \195\169quip\195\169s",
   ["bankbags"]                 = "%u dans %s's Sacs bancaires",
   ["vault"]                    = "%u dans le coffre-fort de guilde",
   ["multivault"]               = "%u dans %s's coffre-fort de guilde",
   ["vaulttab"]                 = "%u dans le coffre-fort de guilde dans le sujet bancaire %u",
   ["multivaulttab"]            = "%u dans %s's coffre-fort de guilde dans le sujet bancaire %u",
   ["voidstore"]                = "%u dans %s's Chambre du Vide",

   ["total"]                    = "Totaux: %u",
   ["stack"]                    = "Tailles de pile: %u",

   ["ignore"]                   = "WhoHas: Ignorer \"%s\"",
   ["noitem"]                   = "WhoHas: Pas d'article \"%s\" connu",
}

WhoHas.mines = {
   ["Gisement d'adamantite"]                   = "Minerai d'adamantite",     -- adamantite deposit
   ["Filon de cuivre"]                         = "Minerai de cuivre",        -- copper vein
   ["Gisement de sombrefer"]                   = "Minerai de sombrefer",     -- dark iron deposit
   ["Gisement de gangrefer"]                   = "Minerai de gangrefer",     -- fel iron deposit
   ["Filon d'or"]                              = "Minerai d'or",             -- gold vein
   ["Filon de thorium Hakkari"]                = "Minerai de thorium",       -- Hakkari Thorium Vein
   ["Gisement de fer"]                         = "Minerai de fer",           -- iron deposit
   ["Filon de khorium"]                        = "Minerai de khorium",       -- khorium vein
   ["Gisement de mithril"]                     = "Minerai de mithril",       -- mithril deposit
   ["Filon d'or couvert de vase"]              = "Minerai d'or",             -- ooze covered gold vein
   ["Gisement de mithril couvert de vase"]     = "Minerai de mithril",       -- ooze covered mithril deposit
   ["Riche filon de thorium couvert de vase"]  = "Minerai de thorium",       -- ooze covered rich thorium vein
   ["Filon d'argent couvert de vase"]          = "Minerai d'argent",         -- ooze covered silver vein
   ["Filon de thorium couvert de vase"]        = "Minerai de thorium",       -- ooze covered thorium vein
   ["Gisement de vrai-argent couvert de vase"] = "Minerai de vrai-argent",   -- ooze covered truesilver deposit
   ["Riche gisement d'adamantite"]             = "Minerai d'adamantite",     -- rich adamantite deposit
   ["Riche filon de thorium"]                  = "Minerai de thorium",       -- rich thorium vein
   ["Filon d'argent"]                          = "Minerai d'argent",         -- silver vein
   ["Petite filon de thorium"]                 = "Minerai de thorium",       -- small thorium vein
   ["Filon d'\195\169tain"]                    = "Minerai d'\195\169tain",   -- tin vein
   ["Gisement de vrai-argent"]                 = "Minerai de vrai-argent",   -- truesilver deposit
   ["Gisement de cobalt"]                      = "Minerai de cobalt",        -- cobalt deposit
   ["Riche gisement de cobalt"]                = "Minerai de cobalt",        -- rich cobalt deposit
   ["Gisement de saronite"]                    = "Minerai de saronite",      -- saronite deposit
   ["Riche gisement de saronite"]              = "Minerai de saronite",      -- rich saronite deposit
   ["Filon de titane"]                         = "Minerai de titane",        -- titanium vein
   -- translate these
   ["Gisement d'obsidium"]                = "Obsidium Ore",
   ["Rich Obsidium Deposit"]           = "Obsidium Ore",
   ["Elementium Vein"]                 = "Elementium Ore",
   ["Rich Elementium Vein"]            = "Elementium Ore",
   ["Pyrite Deposit"]                  = "Pyrite Ore",
   ["Rich Pyrite Deposit"]             = "Pyrite Ore",
   ["Ghost Iron Deposit"]              = "Ghost Iron Ore",
   ["Rich Ghost Iron Deposit"]         = "Ghost Iron Ore",
   -- these aren't going to work right - fix it
   ["Trillium Vein"]                   = "Black Trillium Ore",
   ["Trillium Vein"]                   = "White Trillium Ore",
   ["Rich Trillium Vein"]              = "Black Trillium Ore",
   ["Rich Trillium Vein"]              = "White Trillium Ore",
   ["Kyparite Deposit"]                = "Kyparite",
   ["Rich Kyparite Deposit"]           = "Kyparite",

   ["Gisement de pierre de sang inf\195\169rieure"] = "Minerai de pierre de sang inf\195\169rieur", -- lesser bloodstone deposit
   ["Filon d'incendicite"]                          = "Minerai d'incendicite",                      -- incendicite mineral vein
   ["Filon d'indurium"]                             = "Minerai d'indurium",                         -- indurium mineral vein
   ["Gisement de n\195\169anticite"]                = "Minerai de n\195\169anticite",               -- nethercite deposit
}

WhoHas.xlat = {
   ["Granule d'air"]              = "Air primordial",     -- mote of air
   ["Granule d'ombre"]            = "Ombre primordiale",  -- mote of shadow
   ["Granule d'eau"]              = "Eau primordiale",    -- mote of water
   ["Granule de feu"]             = "Feu primordial",     -- mote of fire
   ["Granule de mana"]            = "Mana primordial",    -- mote of mana
   ["Granule de vie"]             = "Vie primordiale",    -- mote of life
   ["Granule de terre"]           = "Terre primordiale",  -- mote of earth

   ["Minerai d'adamantite"]       = "Barre d'adamantite",       -- adamantite ore
   ["Minerai de gangrefer"]       = "Barre de gangrefer",       -- fel iron ore
   ["Minerai d'\195\169ternium"]  = "Barre d'\195\169ternium",  -- eternium ore
   ["Minerai de khorium"]         = "Barre de khorium",         -- khorium ore
   ["Minerai de thorium"]         = "Barre de thorium",         -- thorium ore
   ["Minerai de vrai-argent"]     = "Barre de vrai-argent",     -- truesilver ore
   ["Minerai de mithril"]         = "Barre de mithril",         -- mithril ore
   ["Minerai d'or"]               = "Barre d'or",               -- gold ore
   ["Minerai d'\195\169tain"]     = "Barre d'\195\169tain",     -- tin ore
   ["Minerai de cuivre"]          = "Barre de cuivre",          -- copper ore
   ["Minerai d'argent"]           = "Barre d'argent",           -- silver ore
   ["Minerai de fer"]             = "Barre de fer",             -- iron ore
   ["Minerai sombrefer"]          = "Barre sombrefer",          -- dark iron ore
   ["Minerai d'\195\169l\195\169mentium"] = "Barre d'\195\169l\195\169mentium", -- elementium ore
   ["Minerai de titane"]          = "Barre de titane",          -- titanium ore
   ["Minerai de cobalt"]          = "Barre de cobalt",          -- cobalt ore
   ["Minerai de saronite"]        = "Barre de saronite",        -- saronite ore

   ["Barre d'adamantite"]         = "Barre d'adamantite tremp\195\169", -- adamantite bar
   ["Barre de gangrefer"]         = "Barre de gangracier",              -- fel iron bar
   ["Barre d'\195\169ternium"]    = "Barre de gangracier",              -- eternium bar
   ["Barre de fer"]               = "Barre d'acier",                    -- iron bar
   ["Barre d'\195\169tain"]       = "Barre de bronze",                  -- tin bar
   ["Barre de cuivre"]            = "Barre de bronze",                  -- copper bar
   ["Barre de khorium"]           = "Khorium tremp\195\169",            -- khorium bar
   ["Barre d'adamantite tremp\195\169"]  = "Khorium tremp\195\169",     -- hardened adamantite bar
   ["Barre de titane"]              = "Barre d'acier-titan",            -- titanium bar

   -- translate these
   ["Thorium Bar"]              = "Enchanted Thorium Bar",
   --["Thorium Bar"]              = "Arcanite Bar",
   ["Elementium Ingot"]         = "Enchanted Elementium Bar",
   ["Arcanite Bar"]             = "Enchanted Elementium Bar",
   ["Obsidium Ore"]             = "Obsidium Bar",
   ["Obsidium Bar"]             = "Folded Obsidium",
   ["Elementium Ore"]           = "Elementium Bar",
   ["Elementium Bar"]           = "Hardened Elementium Bar",
   ["Pyrite Ore"]               = "Pyrium Bar",
   ["Pyrium Bar"]               = "Truegold",

   ["Ghost Iron Ore"]           = "Ghost Iron Bar",
   ["Ghost Iron Bar"]           = "Folded Ghost Iron",
   ["Black Trillium Ore"]       = "Trillium Bar",
   ["White Trillium Ore"]       = "Trillium Bar",
   --["Ghost Iron Bar"]           = "Trillium Bar",
   ["Trillium Bar"]             = "Living Steel",

   ["Eau cristallisée"]        = "Eau \195\169ternelle",     -- crystallized water
   ["Terre cristallisée"]      = "Terre \195\169ternelle",   -- crystallized earth
   ["Feu cristallisé"]         = "Feu \195\169ternel",       -- crystallized fire
   ["Air cristallisé"]         = "Air \195\169ternel",       -- crystallized air
   ["Ombre cristallisée"]      = "Ombre \195\169ternelle",   -- crystallized shadow
   ["Vie cristallisée"]        = "Vie \195\169ternelle",     -- crystallized life
}

WhoHas.enchant = {
   ["Essence de magie inf\195\169rieure"]         = "Essence de magie sup\195\169rieure",         -- Lesser Magic Essence
   ["Essence astrale inf\195\169rieure"]          = "Essence astrale sup\195\169rieure",          -- Lesser Astral Essence
   ["Essence mystique inf\195\169rieure"]         = "Essence mystique sup\195\169rieure",         -- Lesser Mystic Essence
   ["Essence du n\195\169ant inf\195\169rieure"]  = "Essence du n\195\169ant sup\195\169rieure",  -- Lesser Nether Essence
   ["Essence \195\169ternelle inf\195\169rieure"] = "Essence \195\169ternelle sup\195\169rieure", -- Lesser Eternal Essence
   ["Essence planaire inf\195\169rieure"]         = "Essence planaire sup\195\169rieure",         -- Lesser Planar Essence
   -- translate these
   ["Lesser Cosmic Essence"]      = "Greater Cosmic Essence",
   ["Lesser Celestial Essence"]   = "Greater Celestial Essence",
   ["Lesser Mysterious Essence"]  = "Greater Mysterious Essence",

   ["Essence de magie sup\195\169rieure"]         = "Essence de magie inf\195\169rieure",         -- Greater Magic Essence
   ["Essence astrale sup\195\169rieure"]          = "Essence astrale inf\195\169rieure",          -- Greater Astral Essence
   ["Essence mystique sup\195\169rieure"]         = "Essence mystique inf\195\169rieure",         -- Greater Mystic Essence
   ["Essence du n\195\169ant sup\195\169rieure"]  = "Essence du n\195\169ant inf\195\169rieure",  -- Greater Nether Essence
   ["Essence \195\169ternelle sup\195\169rieure"] = "Essence \195\169ternelle inf\195\169rieure", -- Greater Eternal Essence
   ["Essence planaire sup\195\169rieure"]         = "Essence planaire inf\195\169rieure",         -- Greater Planar Essence
   -- translate these
   ["Greater Cosmic Essence"]     = "Lesser Cosmic Essence",
   ["Greater Celestial Essence"]  = "Lesser Celestial Essence",
   ["Greater Mysterious Essence"] = "Lesser Mysterious Essence",

   ["Small Dream Shard"]          = "Dream Shard",
   ["Small Heavenly Shard"]       = "Heavenly Shard",
   ["Small Ethereal Shard"]       = "Ethereal Shard",
}

end
