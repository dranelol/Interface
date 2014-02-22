if (GetLocale() == "esES" or (GetLocale() == "esMX")) then
	CT_RaidTracker_lang_LeftGroup = "([^%s]+) se ha marchado de la banda."; 
	CT_RaidTracker_lang_JoinedGroup = "([^%s]+) se ha unido a la banda."; 
	CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) recibe el bot\195\173n: "..CT_ITEMREG.."."; 
	CT_RaidTracker_lang_ReceivesLoot2 = "Recibes bot\195\173n: "..CT_ITEMREG.."."; 
	CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) recibe el bot\195\173n: "..CT_ITEMREG_MULTI.."."; 
	CT_RaidTracker_lang_ReceivesLoot4 = "Recibes bot\195\173n: "..CT_ITEMREG_MULTI.."."; 
	CT_RaidTracker_lang_ReceivesLootYou = "Recibes";	
	
	CT_RaidTracker_ZoneTriggers = {
		["El Ojo de la Eternidad"] = "The Eye of Eternity",
		["El Sagrario Obsidiana"] = "The Obsidian Sanctum",
		["La C\195\161mara de Archavon"] = "Vault of Archavon",
		["Naxxramas"] = "Naxxramas",
		["Ulduar"] = "Ulduar",
		["Prueba del Cruzado"] = "Trial of the Crusader",
		["Prueba del Gran cruzado"] = "Trial of the Grand Crusader",
		["Guarida de Onyxia"] = "Onyxia's Lair",
		["Ciudadela de la Corona de Hielo"] = "Icecrown Citadel",	
	};
	
	CT_RaidTracker_BossUnitTriggers = {
		-- Eye of Eternity
		["Malygos"] = "Malygos",
	
		-- Obsidian Sanctum
		["Sartharion"] = "Sartharion",
			
		-- Vault of Archavon
		["Emalon el Vig\195\173a de la Tormenta"] = "Emalon the Storm Watcher",
		["Archavon el Vig\195\173a de Piedra"] = "Archavon the Stone Watcher",
		["Koralon el Vig\195\173a de las Llamas"] = "Koralon the Flame Watcher",
		-- Vault of Archavon

		-- Naxxramas
		["Remendejo"] = "Patchwerk",
		["Grobbulus"] = "Grobbulus",
		["Gluth"] = "Gluth",
		["Thaddius"] = "Thaddius",
		["Instructor Razuvious"] = "Instructor Razuvious",
		["Gothik el Cosechador"] = "Gothik the Harvester",
		["Noth el Pesteador"] = "Noth the Plaguebringer",
		["Heigan el Impuro"] = "Heigan the Unclean",
		["Loatheb"] = "Loatheb",
		["Anub'Rekhan"] = "Anub'Rekhan",
		["Gran Viuda Faerlina"] = "Grand Widow Faerlina",
		["Maexxna"] = "Maexxna",
		["Sapphiron"] = "Sapphiron",
		["Kel'Thuzad"] = "Kel'Thuzad",
		["-- 4 Horsemen"] = "-- 4 Horsemen",
		["Bar\195\179n Osahendido"] = "Baron Rivendare",
		["Se\195\177or feudal Korth'azz"] = "Thane Korth'azz",
		["Lady Blaumeux"] = "Lady Blaumeux",
		["Sir Zeliek"] = "Sir Zeliek",
		-- Naxxramas

		-- Ulduar
		["Hodir"] = "Hodir",
		["Clamatormentas Brundir"] = "IGNORE", -- The Assembly of Iron
		["Thorim"] = "Thorim",
		["Rompeacero"] = "IGNORE", -- The Assembly of Iron
		["Freya"] = "Freya",
		["The Assembly of Iron"] = "The Assembly of Iron",
		["Maestro de runas Molgeim"] = "IGNORE", -- The Assembly of Iron
		["Leviat\195\161n de llamas"] = "Flame Leviathan",
		["Ignis el Maestro de la Caldera"] = "Ignis the Furnace Master",
		["Tajoescama"] = "Razorscale",
		["General Vezax"] = "General Vezax",
		["Yogg-Saron"] = "Yogg-Saron",
		["Desarmador XA-002"] = "XT-002 Deconstructor",
		["Auriaya"] = "Auriaya",
		["Kologarn"] = "Kologarn",
		["Mimiron"] = "Mimiron",
		["Algalon the Observer"] = "Algalon the Observer",
		-- Ulduar

		-- Trial of the Crusader
		-- Northern Beasts:
		-- Phase 1: Gormok the Impaler
		["Gormok el Empalador"] = "IGNORE",
		["Vasallo Sn\195\179bold"] = "IGNORE",
		-- Phase 2: Acidmaw & Dreadscale
		["Fauce\195\161cida"] = "IGNORE",
		["Aterraescama"] = "IGNORE",
		-- Phase 3: Icehowl
		["Aullahielo"] = "Northrend Beasts",

		-- Lord Jaraxxus
		["Lord Jaraxxus"] = "Lord Jaraxxus",
		-- Adds
		["Maestra de Dolor"] = "IGNORE",
		["Infernal llama vil "] = "IGNORE",

		-- Twin Val'kyr
		["Fjola Pen\195\173vea"] = "IGNORE",
		["Eydis Penaumbra"] = "IGNORE",
		-- Yell-Help
		["Gemelas Val'kyr"] = "Twin Val'kyr",

		-- Anub'arak
		["Anub'arak"] = "Anub'arak",
		-- Adds
		["Perforador Nerubiano"] = "IGNORE",
		["Esfera de escarcha"] = "IGNORE",
		["Escarabajo de enjambre"] = "IGNORE",

		-- Faction Champions
		-- When you are Alliance you have to kill:
		-- These are the Horde NPCs
		["Gorgrim Rajasombra"] = "IGNORE", -- Deathknight
		["Birana Pezu\195\177a Tempestuosa"] = "IGNORE",  -- Druid
		["Erin Pezu\195\177a de Niebla"] = "IGNORE",  -- Druid
		["Ruh'kah"] = "IGNORE",  -- Hunter
		["Ginselle Lanzaa\195\177ublo"] = "IGNORE",  -- Mage
		["Liandra Clamasol"] = "IGNORE",  -- Paladin
		["Malithas Hoja Brillante"] = "IGNORE",  -- Paladin
		["Caiphus el Austero"] = "IGNORE",  -- Priest
		["Vivienne Susurro Oscuro"] = "IGNORE",  -- Priest
		["Maz'dinah"] = "IGNORE",  -- Rogue
		["Thrakgar"] = "IGNORE",  -- Shaman
		["Broln Cuernorrecio"] = "IGNORE",  -- Shaman
		["Harkzog"] = "IGNORE",  -- Warlock
		["Narrhok Rompeacero"] = "IGNORE",  -- Warrior
		-- Adds
		["Zhaagrym"] = "IGNORE", -- Felhunter of Warlock
		["Felino"] = "IGNORE", -- Lioness of Hunter

		-- When you are Horde you have to kill:
		-- These are the Alliance NPCs
		["Tyrius Hoja Umbr\195\173a "] = "IGNORE", -- Deathknight
		["Kavina Canto Arboleda"] = "IGNORE",  -- Druid
		["Melador Caminavalles"] = "IGNORE",  -- Druid
		["Alyssia Acechalunas"] = "IGNORE",  -- Hunter
		["Noozle Varapalo"] = "IGNORE",  -- Mage
		["Baelnor Portador de la Luz"] = "IGNORE",  -- Paladin
		["Velanaa"] = "IGNORE",  -- Paladin
		["Anthar Ensalmaforja"] = "IGNORE",  -- Priest
		["Brienna Talanoche"] = "IGNORE",  -- Priest
		["Irieth Paso Sombr\195\173o"] = "IGNORE",  -- Rogue
		["Shaamul"] = "IGNORE",  -- Shaman
		["Shaabad"] = "IGNORE",  -- Shaman
		["Serissa Desventura"] = "IGNORE",  -- Warlock
		["Shocuul"] = "IGNORE",  -- Warrior
		-- Adds
		["Zhaagrym"] = "IGNORE", -- Felhunter of Warlock
		["Felino"] = "IGNORE", -- Lioness of Hunter

		-- Yell-Help
		["Campeones de Facci\195\179n"] = "Faction Champions",
		-- Trial of the Crusader
		
		-- Onyxia's Lair
		["Onyxia"] = "Onyxia",
		["Guardia de la Guarida de Onyxia"] = "IGNORE",
		["Cr\195\173a de Onyxia"] = "IGNORE",		
		-- Onyxia's Lair
		
		--	Icecrown Citadel
		["Lord Tu\195\169tano"] = "Lord Marrowgar",
		["Lady Susurramuerte"] = "Lady Deathwhisper",
		["Batalla Naval"] = "Gunship Battle",
		["Libramorte Colmillosauro"] = "Deathbringer Saurfang",
		["Panzachancro"] = "Festergut",
		["Carap\195\186trea"] = "Rotface",
		["Profesor Putricidio"] = "Professor Putricide",
		["Pr\195\173ncipes de Sangre"] = "Blood Princes",
		["Reina de Sangre Lana'thel"] = "Blood-Queen Lana'thel",
		["Valithria Caminasue\195\177os"] = "Valithria Dreamwalker",
		["Sindragosa"] = "Sindragosa",
		["El Rey Ex\195\161nime"] = "The Lich King",
		-- Icecrown Citadel

		["DEFAULTBOSS"] = "Trash mob",
		["Track Members"] = "Track Members",
	};
	
	CT_RaidTracker_lang_BossKills = {
		-- Ulduar
		[" Parece que he cometido un leve error de c\195\161lculo. He permitido que mi mente se corrompiera demonio en la preision, sobrescribiendo mi directiva principal. Todos mis sistemas parecen funcionar de nuevo. Evidente."] = "Mimiron",
		["He...fallado"] = "Ignis the Furnace Master",
		["Su control sobre mi se ha terminado. Puedo ver claramente una vez m\195\161s. Gracias, heroes."] = "Freya",
		["Detener vuestras manos! Yo cedo!"] = "Thorim",
		["Yo...Yo he sido liberado de su alcance! Finalmente!"] = "Hodir",
--      ["Maestro, ya vienen..."] = "Kologarn",
--      ["Juguetes... Malos... Muy... Maaaalos!"] = "XT-002 Deconstructor",
--      ["Mwa-ha-ha-ha! Oh, qu\195\169 horrores os esperan?"] = "General Vezax",
		["Tu destino est\195\161 sellado. El final de los d\195\173as finalmente ha llegado sobre ti y todos los que habitan esta miserable tierra!"] = "Yogg-Saron",
		["Habeis derrotado a la Asamblea de Hierro y desbloqueado el Archivum! Bien hecho, chicos!"] = "The Assembly of Iron",
		-- Ulduar
		-- Trial of the Crusader
		["El Azote no puede ser detenido..."] = "Twin Val'kyr",
		["Te he fallado, maestro..."] = "Anub'arak",
		["Campeones de Facci\195\179n GRITAN"] = "Faction Champions", -- Yell for faction champions still missing
		-- Trial of the Crusader
		-- Icecrown Citadel
		["The Alliance falter. Onward to the Lich King!"] = "Gunship Battle", -- Gunship Battle Horde yell, unknown.
		["\194\161No dig\195\161is que no lo avis\195\169, sinverg\195\188enzas! Adelante, hermanos."] = "Gunship Battle",
		["Yo... Soy... Libre"] = "Deathbringer Saurfang", -- Not confirmed.
		-- Icecrown Citadel
	};

end;