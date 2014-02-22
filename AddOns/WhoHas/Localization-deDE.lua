-- German translation originally provided by Pelion of ri.gametraveler.ch.
-- Additional translations provided by TorenAltair.

if (GetLocale() == "deDE") then

WHOHAS_SUBTEXT = "Diese Optionen erlauben Dir zu kontrollieren welche Informationen WhoHas in Deinen Tooltips anzeigt.";

WhoHas.support = {
   ["none"]                     = "WhoHas: Kein Inventar-AddOn gefunden",
   ["SizPoss"]                  = "WhoHas: Verwende Possessions Daten",
   ["LSPoss"]                   = "WhoHas: Verwende Lauchsuppe's Possessions Daten",
   ["CP"]                       = "WhoHas: Verwende CharacterProfiler Daten",
   ["Armory"]                   = "WhoHas: Verwende Arsenal Daten",
   ["Altoholic"]                = "WhoHas: Verwende Altoholic Daten",
   ["Bagnon"]                   = "WhoHas: Verwende Bagnon Daten",
}

WhoHas.text = {
   ["WhoHasConfigFrame"]        = "WhoHas Konfiguration",
   ["WhoHasCloseButton"]        = "Fertig",
   ["WhoHasEnableButton"]       = "Aktiviere WhoHas",
   ["WhoHasTotalsButton"]       = "Total anzeigen",
   ["WhoHasStackSizeButton"]    = "Stapelgr\195\182\195\159e anzeigen",
   ["WhoHasInboxButton"]        = "Briefkasteninhalt einbeziehen",
   ["WhoHasVoidStoreButton"]    = "Leerenlager einbeziehen",
   ["WhoHasEquipmentButton"]    = "Ausr\195\188stung einbeziehen",
   ["WhoHasBagsButton"]         = "Zusatztaschen einbeziehen",
   ["WhoHasVaultButton"]        = "Gildentresor einbeziehen",
   ["WhoHasWorldButton"]        = "Weltweite Tooltips ausschalten",
   ["WhoHasMinesButton"]        = "Zeige Erzanzahl in Minen",
   ["WhoHasOresButton"]         = "Zeige Barren-, Elementar- und Essenzanzahl",
   ["WhoHasAllGuildsButton"]    = "Zeige alternative Gildentresore",
   ["WhoHasTabsButton"]         = "Zeige Gildenbankf\195\164cher",
   ["WhoHasFactionsButton"]     = "Beide Fraktionen einbinden",
   ["WhoHasRealmsButton"]       = "Alle Realms einbinden",

   ["WhoHasBackendSelection"]   = "Nutze Daten von Addon:",

   ["ignore"]                   = "ignore",
   ["usage"]                    = "Befehl: /whohas [ignore ITEM]",

   ["auto"]                     = "Auto-detect",
   ["armory"]                   = "Armory",
   ["possess"]                  = "Possessions",
   ["charprof"]                 = "CharacterProfiler",
   ["altoholic"]                = "Altoholic",
   ["bagnon"]                   = "Bagnon",
}

WHOHAS_BACKEND_TEXT = WhoHas.text.WhoHasBackendSelection;

WhoHas.formats = {
   ["inventory"]                = "%u in %s's Inventar",
   ["bank"]                     = "%u auf %s's Bank",
   ["inbox"]                    = "%u in %s's Briefkasten",
   ["keyring"]                  = "%u an %s's Schl\195\188sselbund",
   ["equipment"]                = "%u in %s's Ausr\195\188stung",
   ["invbags"]                  = "%u in %s's Zusatztaschen",
   ["bankbags"]                 = "%u in %s's Banktaschen",
   ["vault"]                    = "%u im Gildentresor",
   ["multivault"]               = "%u in %s's Gildentresor",
   ["vaulttab"]                 = "%u im Gildenbankfach %u", -- guildbank!
   ["multivaulttab"]            = "%u in %s's Gildenbankfach %u", -- guildbank!
   ["voidstore"]                = "%u in %s's Leerenlager",

   ["total"]                    = "Total: %u",
   ["stack"]                    = "Stapelgr\195\182\195\159e: %u",

   ["ignore"]                   = "WhoHas: Ignoriere \"%s\"",
   ["noitem"]                   = "WhoHas: Kein Item namens \"%s\"",
}

WhoHas.mines = {
   ["Adamantitablagerung"]                                  = "Adamantiterz",    -- adamantite deposit
   ["Kupfervorkommen"]                                      = "Kupfererz",       -- copper vein
   ["Dunkeleisenablagerung"]                                = "Dunkeleisenerz",  -- dark iron deposit
   ["Teufelseisenablagerung"]                               = "Teufelseisenerz", -- fel iron deposit
   ["Goldvorkommen"]                                        = "Golderz",         -- gold vein
   ["Hakkari Thoriumvorkommen"]                             = "Thoriumerz",      -- Hakkari thorium vein
   ["Eisenablagerung"]                                      = "Eisenerz",        -- iron deposit
   ["Khoriumvorkommen"]                                     = "Khoriumerz",      -- khorium vein
   ["Mithrilablagerung"]                                    = "Mithrilerz",      -- mithril deposit
   ["Br\195\188hschlammbedecktes Goldvorkommen"]            = "Golderz",         -- ooze covered gold vein
   ["Br\195\188hschlammbedecktes Mithrilablagerung"]        = "Mithrilerz",      -- ooze covered mitril deposit
   ["Br\195\188hschlammbedecktes reiches Thoriumvorkommen"] = "Thoriumerz",      -- ooze covered rich thorium vein
   ["Br\195\188hschlammbedecktes Silbervorkommen"]          = "Silbererz",       -- ooze covered silver vein
   ["Br\195\188hschlammbedecktes Thoriumvorkommen"]         = "Thoriumerz",      -- ooze overed thorium vein
   ["Br\195\188hschlammbedecktes Echtsilberablagerung"]     = "Echtsilbererz",   -- ooze covered truesilver deposit
   ["Reiche Adamantitablagerung"]                           = "Adamantiterz",    -- rich adamantite deposit
   ["Reiches Thoriumvorkommen"]                             = "Thoriumerz",      -- rich thorium vein
   ["Silbervorkommen"]                                      = "Silbererz",       -- silver vein
   ["Kleines Thoriumvorkommen"]                             = "Thoriumerz",      -- small thorium vein
   ["Zinnvorkommen"]                                        = "Zinnerz",         -- tin vein
   ["Echtsilberablagerung"]                                 = "Echtsilbererz",   -- truesilver deposit
   ["Kobaltablagerung"]                                     = "Kobalterz",       -- cobalt deposit
   ["Reiche Kobaltablagerung"]                              = "Kobalterz",       -- rich cobalt deposit
   ["Saronitablagerung"]                                    = "Saroniterz",      -- saronite deposit
   ["Reiche Saronitablagerung"]                             = "Saroniterz",      -- rich saronite deposit
   ["Titanvorkommen"]                                       = "Titanerz",        -- titanium vein
   ["Obsidiumvorkommen"]                                    = "Obsidiumerz",
   ["Reiches Obsidiumvorkommen"]                            = "Obsidiumerz",
   ["Elementiumader"]                                       = "Elementiumerz",
   ["Reiche Elementiumader"]                                = "Elementiumerz",
   ["Pyritvorkommen"]                                       = "Pyriterz",
   ["Reiches Pyritvorkommen"]                               = "Pyriterz",

   -- fix these after MoP release
   ["Ghost Iron Deposit"]              = "Geistereisenerz",
   ["Rich Ghost Iron Deposit"]         = "Geistereisenerz",
   -- these aren't going to work right - fix it
   ["Trillium Vein"]                   = "Schwarzes Trilliumerz",
   ["Trillium Vein"]                   = "Wei\195\159es Trilliumerz",
   ["Rich Trillium Vein"]              = "Schwarzes Trilliumerz",
   ["Rich Trillium Vein"]              = "Wei\195\159es Trilliumerz",
   ["Kyparite Deposit"]                = "Kyparit",
   ["Rich Kyparite Deposit"]           = "Kyparit",

   ["Geringe Blutsteinablagerung"] = "Geringes Blutsteinerz", -- lesser bloodstone deposit
   ["Pyrophormineralvorkommen"]    = "Pyrophorerz",           -- incendicite mineral vein
   ["Induriummineralvorkommen"]    = "Induriumerz",           -- indurium mineral vein
   ["Netheritablagerung"]          = "Netheriterz",           -- nethercide deposit
}

WhoHas.xlat = {
   ["Luftpartikel"]             = "Urluft",     -- mote of air
   ["Schattenpartikel"]         = "Urschatten", -- mote of shadow
   ["Wasserpartikel"]           = "Urwasser",   -- mote of water
   ["Feuerpartikel"]            = "Urfeuer",    -- mote of fire
   ["Manapartikel"]             = "Urmana",     -- mote of mana
   ["Lebenspartikel"]           = "Urleben",    -- mote of life
   ["Erdpartikel"]              = "Urerde",     -- mote of earth

   ["Adamantiterz"]             = "Adamantitbarren",    -- adamantite ore
   ["Teufelseisenerz"]          = "Teufelseisenbarren", -- fel iron ore
   ["Eterniumerz"]              = "Eterniumbarren",     -- eternium ore
   ["Khoriumerz"]               = "Khoriumbarren",      -- khorium ore
   ["Thoriumerz"]               = "Thoriumbarren",      -- thorium ore
   ["Echtsilbererz"]            = "Echtsilberbarren",   -- truesilver ore
   ["Mithrilerz"]               = "Mithrilbarren",      -- mithril ore
   ["Golderz"]                  = "Goldbarren",         -- gold ore
   ["Zinnerz"]                  = "Zinnbarren",         -- tin ore
   ["Kupfererz"]                = "Kupferbarren",       -- copper ore
   ["Silbererz"]                = "Silberbarren",       -- silver ore
   ["Eisenerz"]                 = "Eisenbarren",        -- iron ore
   ["Dunkeleisenerz"]           = "Dunkeleisenbarren",  -- dark iron ore
   ["Elementiumerz"]            = "Elementiumbarren",   -- elementium ore
   ["Titanerz"]                 = "Titanbarren",        -- titanium ore
   ["Kobalterz"]                = "Kobaltbarren",       -- cobalt ore
   ["Saroniterz"]               = "Saronitbarren",      -- saronite ore

   ["Adamantitbarren"]          = "Geh\195\164rteter Adamantitbarren", -- adamantite bar
   ["Teufelseisenbarren"]       = "Teufelsstahlbarren",                -- fel iron bar
   ["Eterniumbarren"]           = "Teufelsstahlbarren",                -- eternium bar
   ["Eisenbarren"]              = "Stahlbarren",                       -- iron bar
   ["Zinnbarren"]               = "Bronzebarren",                      -- tin bar
   ["Kupferbarren"]             = "Bronzebarren",                      -- copper bar
   ["Khoriumbarren"]            = "Geh\195\164rtetes Khorium",         -- khorium bar
   ["Geh\195\164rteter Adamantitbarren"]  = "Geh\195\164rtetes Khorium",	-- hardened adamantite bar
   ["Titanbarren"]              = "Titanstahlbarren",                  -- titanium bar

   ["Thoriumbarren"]            = "Verzauberter Thoriumbarren",
   --["Thoriumbarren"]            = "Arkanitbarren",
   ["Elementiumblock"]          = "Verzauberter Elementiumbarren",
   ["Arkanitbarren"]            = "Verzauberter Elementiumbarren",
   ["Obsidiumerz"]              = "Obsidiumbarren",
   ["Obsidiumbarren"]           = "Gefaltetes Obsidium",
   ["Elementiumerz"]            = "Elementiumbarren",
   ["Elementiumbarren"]         = "Geh\195\164rteter Elementiumbarren",
   ["Pyriterz"]                 = "Pyriumbarren",
   ["Pyriumbarren"]             = "Echtgold",

   ["Geistereisenerz"]          = "Geistereisenbarren",
   ["Geistereisenbarren"]       = "Gefaltetes Geistereisen",
   ["Schwarzes Trilliumerz"]    = "Trilliumbarren",
   ["Wei\195\159es Trilliumerz"]= "Trilliumbarren",
   --["Geistereisenbarren"]     = "Trilliumbarren",
   ["Trilliumbarren"]           = "Lebendiger Stahl",

   ["Kristallisierte Wasser"]        = "\195\132onenwasser",     -- crystallized water
   ["Kristallisierte Erde"]          = "\195\132onenerde",       -- crystallized earth
   ["Kristallisiertes Feuer"]        = "\195\132onenfeuer",      -- crystallized fire
   ["Kristallisierte Luft"]          = "\195\132onenluft",       -- crystallized air
   ["Kristallisierte Schatten"]      = "\195\132onenschatten",   -- crystallized shadow
   ["Kristallisiertes Leben"]        = "\195\132onenleben",      -- crystallized life
}

WhoHas.enchant = {
   ["Geringe Magieessenz"]              = "Gro\195\159e Magieessenz",    -- Lesser Magic Essence
   ["Geringe Astralessenz"]             = "Gro\195\159e Astralessenz",   -- Lesser Astral Essence
   ["Geringe Mystikeressenz"]           = "Gro\195\159e Mystikeressenz", -- Lesser Mystic Essence
   ["Geringe Netheressenz"]             = "Gro\195\159e Netheressenz",   -- Lesser Nether Essence
   ["Geringe ewige Essenz"]             = "Gro\195\159e ewige Essenz",   -- Lesser Eternal Essence
   ["Geringe Planaressenz"]             = "Gro\195\159e Planaressenz",   -- Lesser Planar Essence
   ["Geringe kosmische Essenz"]         = "Gro\195\159e kosmische Essenz",
   ["Geringe himmlische Essenz"]        = "Gro\195\159e himmlische Essenz",
   ["Geringe mysteri\195\182se Essenz"] = "Gro\195\159e mysteri\195\182se Essenz",

   ["Gro\195\159e Magieessenz"]              = "Geringe Magieessenz",         -- Greater Magic Essence
   ["Gro\195\159e Astralessenz"]             = "Geringe Astralessenz",        -- Greater Astral Essence
   ["Gro\195\159e Mystikeressenz"]           = "Geringe Mystikeressenz",      -- Greater Mystic Essence
   ["Gro\195\159e Netheressenz"]             = "Geringe Netheressenz",        -- Greater Nether Essence
   ["Gro\195\159e ewige Essenz"]             = "Geringe ewige Essenz",        -- Greater Eternal Essence
   ["Gro\195\159e Planaressenz"]             = "Geringe Planaressenz",        -- Greater Planar Essence
   ["Gro\195\159e kosmische Essenz"]         = "Geringe kosmische Essenz",
   ["Gro\195\159e himmlische Essenz"]        = "Geringe himmlische Essenz",
   ["Gro\195\159e mysteri\195\182se Essenz"] = "Geringe mysteri\195\182se Essenz",

   ["Kleiner Traumsplitter"]                 = "Traumsplitter",
   ["Kleiner himmlischer Splitter"]          = "Himmlischer Splitter",
   ["Kleiner \195\164therischer Splitter"]   = "\195\132therischer Splitter",
}

end
