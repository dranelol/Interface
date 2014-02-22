
if (GetLocale() == "deDE") then
	CT_RaidTracker_Translation_Complete = false;

	CT_RaidTracker_lang_LeftGroup = "([^%s]+) hat die Schlachtgruppe verlassen.";
	CT_RaidTracker_lang_JoinedGroup = "([^%s]+) hat sich der Schlachtgruppe angeschlossen.";
	CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) bekommt Beute: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot2 = "Ihr erhaltet Beute: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) erh\195\164lt Beute: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLoot4 = "Ihr erhaltet Beute: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLootYou = "Ihr";
	
	CT_RaidTracker_ZoneTriggers = {
		-- WotlK
		["Das Auge der Ewigkeit"] = "The Eye of Eternity",
		["Das Obsidiansanktum"] = "The Obsidian Sanctum",
		["Archavons Kammer"] = "Vault of Archavon",
		["Naxxramas"] = "Naxxramas",
		["Ulduar"] = "Ulduar",
		["Pr\195\188fung des Kreuzfahrers"]="Trial of the Crusader",
		["Pr\195\188fung des Obersten Kreuzfahrers"]="Trial of the Grand Crusader",
		["Onyxias Hort"]="Onyxia's Lair",
		["Eiskronenzitadelle"] = "Icecrown Citadel",		
		
	};
		
	CT_RaidTracker_BossUnitTriggers = {
		--Wotlk
		--Naxx
		["Flickwerk"] = "Patchwerk",
		["Grobbulus"] = "Grobbulus",
		["Gluth"] = "Gluth",
		["Thaddius"] = "Thaddius",
		["Instrukteur Razuvious"] = "Instructor Razuvious",
		["Gothik der Ernter"] = "Gothik the Harvester",
		["Noth der Seuchenf\195\188rst"] = "Noth the Plaguebringer",
		["Heigan der Unreine"] = "Heigan the Unclean",
		["Loatheb"] = "Loatheb",
		["Anub'Rekhan"] = "Anub'Rekhan",
		["Gro\195\159witwe Faerlina"] = "Grand Widow Faerlina",
		["Maexxna"] = "Maexxna",
		["Saphiron"] = "Sapphiron",
		["Kel'Thuzad"] = "Kel'Thuzad",
		-- 4 Horsemen
		["Baron Totenschwur"] = "Four Horsemen",
		["Thane Korth'azz"] = "Four Horsemen",
		["Lady Blaumeux"] = "Four Horsemen",
		["Sir Zeliek"] = "Four Horsemen",
	
		-- Eye of Eternity
		["Malygos"] = "Malygos",

		-- Obsidian Sanctum
		["Sartharion"] = "Sartharion",

		-- Vault of Archavon
		["Archavon der Steinw\195\164chter"] = "Archavon the Stone Watcher",		
		["Emalon der Sturmw\195\164chter"] = "Emalon the Storm Watcher",
		["Koralon der Flammenw\195\164chter"] = "Koralon the Flame Watcher",
		["Toravon der Eisw\195\164chter"] = "Toravon the Ice Watcher",
		["Sturmdiener"] = "IGNORE",	
		-- Vault of Archavon
		
		-- Ulduar
		["Hodir"] = "Hodir",
		["Sturmrufer Brundir"] = "IGNORE", -- The Assembly of Iron
		["Thorim"] = "Thorim",
		["Stahlbrecher"] = "IGNORE", -- The Assembly of Iron
		["Freya"] = "Freya",
		["Runenmeister Molgeim"] = "IGNORE", -- The Assembly of Iron
		["Der eiserne Rat"] = "The Assembly of Iron",
		["Flammenleviathan"] = "Flame Leviathan",
		["Ignis, Meister des Eisenwerks"] = "Ignis the Furnace Master",
		["Klingenschuppe"] = "Razorscale",
		["General Vezax"] = "General Vezax",
		["Yogg-Saron"] = "Yogg-Saron",
		["XT-002 Dekonstruktor"] = "XT-002 Deconstructor",
		["Auriaya"] = "Auriaya",
		["Kologarn"] = "Kologarn",
		["Mimiron"] = "Mimiron",
		["Algalon der Beobachter"] = "Algalon the Observer",
		["Zweigeistiger Ent"] = "Algalon the Observer",
		-- Ulduar

 -- Trial of the Crusader
		-- Nordendbestien
               --Phase 1
		["Gormok der Pf\195\164hler"] = "IGNORE",
                ["Schneeboldvasall"] = "IGNORE",
               --Phase 2
                ["\195\164tzschlund"] = "IGNORE",
                ["Schreckensmaul"] = "IGNORE",
               --Phase 3
                ["Eisheuler"] = "Northrend Beasts",
--
		["Lord Jaraxxus"] = "Lord Jaraxxus",
               -- Adds
		["Herrin des Schmerzes"] = "IGNORE",
                ["Teuflische H\195\182llenbestie"] = "IGNORE",
--
		["Faction Champions"] = "Faction Champions",
--		["Champions der Allianz"] = "Faction Champions",
--		["Anthar Schmiedenformer"] = "Faction Champions",
--		["Irieth Schattenschritt"] = "Faction Champions",
--		["Kavina Haineslied"] = "Faction Champions",
--		["Noozle Zischelstock"] = "Faction Champions",
--		["Shaabad"] = "Faction Champions",
--		["Brienna Tiefnacht"] = "Faction Champions",
--		["Melador Talwanderer"] = "Faction Champions",
--		["Tyrius Dämmerklinge"] = "Faction Champions",
--		["Alyssia Mondpirscher"] = "Faction Champions",
--		["Saamul"] = "Faction Champions",
--		["Shocuul"] = "Faction Champions",
--		["Tyrius Dämmerklinge"] = "Faction Champions",
--		["Velanaa"] = "Faction Champions",
      -- Yell Helper
		["Twin Val'kyr"] = "Twin Val'kyr",
--		["Eydis Nachtbann"] = "Twin Val'kyr",
--		["Fjola Lichtbann"] = "Twin Val'kyr",
--		
		["Anub'arak"] = "Anub'arak",
		["Huschender Skarab\195\164us"] = "IGNORE",
		["Nerubischer Gr\195\164ber"] = "IGNORE",
		["Schwarmskarab\195\164us"] = "IGNORE",
		["Frostsph\195\164re"] = "IGNORE",

	-- Onyxia
		["Onyxia"] = "Onyxia",
	-- Onyxia

    -- Eiskronenzitadelle
    ["Lord Mark'gar"] = "Lord Marrowgar",
    ["Lady Todeswisper"] = "Lady Deathwhisper",
    ["Gunship Battle"] = "Gunship Battle",
    ["Todesbringer Saurfang"] = "Deathbringer Saurfang",
    ["Fauldarm"] = "Festergut",
    ["Modermiene"] = "Rotface",
    ["Professor Seuchenmord"] = "Professor Putricide",
    ["Blood Prince Council"] = "Blood Prince Council", -- Yellhelper NICHT VERÄNDERN
    ["Blutk\195\182nigin Lana'thel"] = "Blood-Queen Lana'thel",
    ["Valithria Traumwandler"] = "Valithria Dreamwalker", -- Yellhelper NICHT VERÄNDERN
    ["Sindragosa"] = "Sindragosa",
    ["The Lich King"] = "The Lich King",



    -- Eiskronenzitadelle

		-- Wotlk

		["DEFAULTBOSS"] = "Trash mob",
		["Track Members"] = "Track Members",

		--Test
		["Zweigeistiger Ent"] = "Trash mob",

	};

	CT_RaidTracker_lang_BossKills = {
		-- Ulduar
		["Es scheint, als w\195\164re mir eine klitzekleine Fehlkalkulation unterlaufen. Ich habe zugelassen, dass das Scheusal im Gef\195\164ngnis meine Prim\195\164rdirektive \195\188berschreibt. Alle Systeme nun funktionst\195\188chtig."] = "Mimiron",
--		["I...have...failed..."] = "Ignis the Furnace Master",
		["Seine Macht \195\188ber mich beginnt zu schwinden. Endlich kann ich wieder klar sehen. Ich danke Euch, Helden."] = "Freya",
		["Senkt Eure Waffen! Ich ergebe mich!"] = "Thorim",
		["Ich... bin von ihm befreit... endlich."] = "Hodir",
--		["Meister, sie kommen..."] = "Kologarn",
--		["Ihr seid b\195\182se... Spielzeuge... b\195\182\195\182\195\182\195\182\195\182se..."] = "XT-002 Deconstructor",
--		["Mwa-ha-ha-ha! Oh, what horrors await you?"] = "General Vezax",
		["Your fate is sealed. The end of days is finally upon you and ALL who inhabit this miserable little seedling! Uulwi ifis halahs gag erh'ongg w'ssh."] = "Yogg-Saron",
		["Ihr habt den Eisernen Rat besiegt und das Archivum ge\195\182ffnet! Gut gemacht, Leute!"] = "Der eiserne Rat",
		["Ihr habt den Eisernen Rat besiegt und das Archivum ge\195\182ffnet!  Gut gemacht, Leute!"] = "Der eiserne Rat",
		["Unm\195\182glich..."] = "Der eiserne Rat", -- Iron Council Hardmode / Steelbreaker last
		["Ihr lauft geradewegs in den Schlund des Wahnsinns!"] = "Der eiserne Rat", -- Iron Council Normalmode / Brundir last
		["What have you gained from my defeat? You are no less doomed, mortals!"] = "Der eiserne Rat", -- Iron Council Semimode / Molgeim last
		["Ich sah Welten umh\195\188llt von den Flammen der Sch\195\182pfer, sah ohne einen Hauch von Trauer ihre Bewohner vergehen. Ganze Planetensysteme geboren und vernichtet, w\195\164hrend Eure sterblichen Herzen nur einmal schlagen. Doch immer war mein Herz kalt... ohne Mitgef\195\188hl. Ich - habe - nichts - gef\195\188hlt. Millionen, Milliarden Leben verschwendet. Trugen sie alle dieselbe Beharrlichkeit in sich, wie Ihr? Liebten sie alle das Leben so sehr, wie Ihr es tut?"] = "Algalon the Observer",
		-- Ulduar
		-- Trial of the Crusader
		["Die Gei\195\159el kann nicht aufgehalten werden..."] = "Twin Val'kyr",
		["Ich habe Euch entt\195\164uscht, Meister..."] = "Anub'arak", ---notwork
		["Champions der Allianz"] = "Faction Champions",
		["EHRE DER ALLIANZ!"] = "Faction Champions",
		["Ein tragischer Sieg. Wir wurden schw\195\164cher durch die heutigen Verluste. Wer au\195\159er dem Lichk\195\182nig profitiert von solchen Torheiten? Gro\195\159e Krieger gaben ihr Leben. Und wof\195\188r? Die wahre Bedrohung erwartet uns noch - der Lichk\195\182nig erwartet uns alle im Tod."] = "Faction Champions",
		-- Trial of the Crusader

		-- Icecrown Citadel
   	["Sagt nicht, ich h\195\164tte Euch nicht gewarnt, Ihr Schurken! Vorw\195\164rts, Br\195\188der und Schwestern!"] = "Gunship Battle",
		["Die Allianz wankt. Vorw\195\164rts zum Lichk\195\182nig!"] = "Gunship Battle", -- Gunship Horde
		["Meine K\195\182nigin, sie... kommen."] = "Blood Prince Council", -- Blood Prince Council
		["ICH BIN GEHEILT! Ysera, erlaubt mir, diese \195\188blen Kreaturen zu beseitigen!"] = "Valithria Dreamwalker",
    -- Icecrown Citadel
};

end;

		
