if (GetLocale() == "frFR") then
   CT_RaidTracker_Translation_Complete = false;

   CT_RaidTracker_lang_LeftGroup = "([^%s]+) a quitt\195\169 le groupe de raid";
   CT_RaidTracker_lang_JoinedGroup = "([^%s]+) a rejoint le group de raid";
   CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) re\195\167oit le butin.+: "..CT_ITEMREG..".";
   CT_RaidTracker_lang_ReceivesLoot2 = "Vous recevez le butin.+: "..CT_ITEMREG..".";
   CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) re\195\167oit le butin.+: "..CT_ITEMREG_MULTI..".";
   CT_RaidTracker_lang_ReceivesLoot4 = "Vous recevez le butin.+: "..CT_ITEMREG_MULTI..".";
   CT_RaidTracker_lang_ReceivesLootYou = "Vous";
   
   CT_RaidTracker_ZoneTriggers = {
      ["L'Œil de l'éternit\195\169"] = "The Eye of Eternity",
      ["Le sanctum Obsidien"] = "The Obsidian Sanctum",
      ["Caveau d'Archavon"] = "Vault of Archavon",
      ["Naxxramas"] = "Naxxramas",
      ["Ulduar"] = "Ulduar",
      ["L'\195\169preuve du crois\195\169"] = "Trial of the Crusader",
      ["L'\195\169preuve du grand crois\195\169"] = "Trial of the Grand Crusader",
      ["Repaire d'Onyxia"] = "Onyxia's Lair",
      ["Citadelle de la Couronne de glace"] = "Icecrown Citadel",
      };
   
   CT_RaidTracker_BossUnitTriggers = {
      -- Eye of Eternity
      ["Malygos"] = "Malygos",
   
      -- Obsidian Sanctum
      ["Sartharion"] = "Sartharion",
   
      -- Vault of Archavon
      ["Emalon le Guetteur d'orage"] = "Emalon the Storm Watcher",
      ["Archavon le Gardien des pierres"] = "Archavon the Stone Watcher",
      ["Koralon le Veilleur des flammes"] = "Koralon the Flame Watcher",
      -- Vault of Archavon
   
      -- Naxxramas
      ["Le Recousu"] = "Patchwerk",
      ["Grobbulus"] = "Grobbulus",
      ["Gluth"] = "Gluth",
      ["Thaddius"] = "Thaddius",
      ["Instructeur Razuvious"] = "Instructor Razuvious",
      ["Gothik le Moissonneur"] = "Gothik the Harvester",
      ["Noth le Porte-peste"] = "Noth the Plaguebringer",
      ["Heigan l'Impur"] = "Heigan the Unclean",
      ["Horreb"] = "Loatheb",
      ["Anub'Rekhan"] = "Anub'Rekhan",
      ["Grande veuve Faerlina"] = "Grand Widow Faerlina",
      ["Maexxna"] = "Maexxna",
      ["Saphiron"] = "Sapphiron",
      ["Kel'Thuzad"] = "Kel'Thuzad",
      ["-- 4 Horsemen"] = "-- 4 Horsemen",
      ["Baron Vaillefendre"] = "Baron Rivendare",
      ["Thane Korth'azz"] = "Thane Korth'azz",
      ["Dame Blaumeux"] = "Lady Blaumeux",
      ["Sire Zeliek"] = "Sir Zeliek",
      -- Naxxramas
   
      -- Ulduar
      ["Hodir"] = "Hodir",
      ["Mande-foudre Brundir"] = "IGNORE", -- The Assembly of Iron
      ["Thorim"] = "Thorim",
      ["Brise-acier"] = "IGNORE", -- The Assembly of Iron
      ["Freya"] = "Freya",
      ["The Assembly of Iron"] = "The Assembly of Iron",
      ["Ma\195\174tre des runes Molgeim"] = "The Assembly of Iron", -- The Assembly of Iron
      ["L\195\169viathan des flammes"] = "Flame Leviathan",
      ["Ignis le ma\195\174tre de la Fournaise"] = "Ignis the Furnace Master",
      ["Tranch\195\169caille"] = "Razorscale",
      ["G\195\169n\195\169ral Vezax"] = "General Vezax",
      ["Yogg-Saron"] = "Yogg-Saron",
      ["D\195\169constructeur XT-002"] = "XT-002 Deconstructor",
      ["Auriaya"] = "Auriaya",
      ["Kologarn"] = "Kologarn",
      ["Mimiron"] = "Mimiron",
      ["Algalon the Observer"] = "Algalon the Observer",
      -- Ulduar
      
      -- Trial of the Crusader
      ["Glace-hurlante"] = "Northrend Beasts",
      ["Seigneur Jaraxxus"] = "Lord Jaraxxus",
      ["Fjola Plaie-lumineuse"] = "Twin Val'kyr",
      ["Eydis Plaie-sombre"] = "Twin Val'kyr",
      ["Gorgrim Fend-les-ombres"] = "Faction Champions",
      ["Thrakgar"] = "Faction Champions",
      ["Narrhok Brise-acier"] = "Faction Champions",
      ["Broln Corne-rude"] = "Faction Champions",
      ["Erin Sabot-de-brume"] = "Faction Champions",
      ["Vivienne Murmenoir"] = "Faction Champions",
      
      -- Yell-Help
      ["Twin Val'kyr"] = "Twin Val'kyr",
      ["Anub'arak"] = "Anub'arak",
      ["Faction Champions"] = "Faction Champions",
      -- Trial of the Crusader

      -- Onyxia's Lair
      ["Onyxia"] = "Onyxia",
      ["Onyxian Warder"] = "IGNORE",
      ["Onyxian Whelp"] = "IGNORE",      
      -- Onyxia's Lair

      -- Icecrown Citadel
      -- Storming the Citadel
      ["Seigneur Gargamoelle"] = "Lord Marrowgar",
      ["Dame Murmemort"] = "Lady Deathwhisper",
      ["Gunship Battle"] = "Gunship Battle",
      ["Porte-mort Saurcroc"] = "Deathbringer Saurfang",

      -- Adds in Lord Marrowgar Fight
      ["Pointe d'os"] = "IGNORE",

      -- Adds in Gunship Battle
      -- Horde NPC (must be killed by Alliance)
      ["Haut seigneur Saurcroc"] = "IGNORE",
      ["Canon de la canonni\195\168re de la Horde"] = "IGNORE",
      ["Sergent kor'kron"] = "IGNORE",
      ["Missilier kor'kron"] = "IGNORE",
      ["Saccageur kor'kron"] = "IGNORE",
      ["Mage de bataille kor'kron"] = "IGNORE",
      ["Lanceur de hache kor'kron"] = "IGNORE",

      -- Alliance NPC (must be killed by Horde)
      ["Muradin Barbe-de-bronze"] = "IGNORE",
      ["Canon de la canonni\195\168re de l'Alliance"] = "IGNORE",
      ["Fusilier du Brise-ciel"] = "IGNORE",
      ["Soldat de marine du Brise-ciel"] = "IGNORE",
      ["Sergent du Brise-ciel"] = "IGNORE",
      ["Sorcier du Brise-ciel"] = "IGNORE",
      ["Soldat-artilleur du Brise-ciel"] = "IGNORE",



      -- Adds in Lady Deathbringer Fight
      ["Adh\195\169rent du culte"] = "IGNORE",
      ["Fanatique du culte"] = "IGNORE",
      ["Adh\195\169rent investi"] = "IGNORE",
      ["Fanatique d\195\169form\195\169"] = "IGNORE",



      -- The Plagueworks
      ["Festergut"] = "Festergut",
      ["Rotface"] = "Rotface",
      ["Professor Putricide"] = "Professor Putricide",  -- Not tested yet

      -- Adds in Rotface Fight
      ["Sticky Ooze"] = "IGNORE",
      ["Big Ooze"] = "IGNORE",
      ["Little Ooze"] = "IGNORE",

      -- Adds in Professor Putricide Fight
      ["Mutated Slime"] = "IGNORE",
      ["Volatile Ooze"] = "IGNORE",

      -- The Crimson Hall
      ["Blood Prince Council"] = "Blood Prince Council", -- Yell-Dummy / Not tested yet
      ["Queen Lana'thel"] = "Queen Lana'thel", -- Not tested yet

      -- The Frostwing Halls
      ["Sindragosa"] = "Sindragosa",
      ["Valithria Dreamwalker"] = "Valithria Dreamwalker", -- Yell-Dummy

      -- Adds in Valintria Dreamwalker Fight
      ["Suppresser"] = "IGNORE",
      ["Blistering Zombie"] = "IGNORE",
      ["Gluttonous Abomination"] = "IGNORE",
      ["Rot Worms"] = "IGNORE",
      ["Blazing Skeleton"] = "IGNORE",
      ["Risen Archmage"] = "IGNORE",

      -- Adds in Sindragosa Fight
      ["Ice Tomb"] = "IGNORE",


      -- The Frozen Throne
      ["The Lich King"] = "The Lich King", -- Not tested yet

      
      ["DEFAULTBOSS"] = "Trash mob",
      ["Track Members"] = "Track Members",
   };
   
   CT_RaidTracker_lang_BossKills = {
      -- citadelle
      ["Vous direz pas que j'vous avais pas prévenus, canailles ! Mes frères et sœurs, en avant !"] = "Gunship Battle",
      ["Vous direz pas que j'vous avais pas pr\195\169venus, canailles ! Mes fr\195\168res et sœurs, en avant !"] = "Gunship Battle",
      -- Ulduar
      ["Il semblerait que j'aie pu faire une minime erreur de calcul. J'ai permis \195\160 mon esprit de se laisser corrompre par ce d\195\169mon dans la prison qui a désactiv\195\169 ma directive principale. Tous les syst\195\168mes fonctionnent \195\160 nouveau. Termin\195\169."] = "Mimiron",
--      ["J'ai... \195\169chou\195\169..."] = "Ignis the Furnace Master",
      ["Son emprise sur moi se dissipe. J'y vois \195\160 nouveau clair. Merci, H\195\169ros."] = "Freya",
      ["Retenez vos coups ! Je me rends !"] = "Thorim",
      ["Je suis... lib\195\169r\195\169 de son emprise... enfin."] = "Hodir",
--      ["Master, they come..."] = "Kologarn",
--      ["You are bad... Toys... Very... Baaaaad!"] = "XT-002 Deconstructor",
--      ["Mwa-ha-ha-ha! Oh, what horrors await you?"] = "General Vezax",
--      ["Votre destin est scellé. La fin des temps est enfin arrivée pour vous et tous les habitants de ce misérable petit bourgeon. Uulwi ifis halahs gag erh'ongg w'ssh."] = "Yogg-Saron",
--      ["Impossible..."] = "The Assembly of Iron", -- Iron Council Hardmode / Steelbreaker last
--      ["You rush headlong into the maw of madness!"] = "The Assembly of Iron", -- Iron Council Normalmode / Brundir last
--      ["What have you gained from my defeat? You are no less doomed, mortals!"] = "The Assembly of Iron", -- Iron Council Semimode / Molgeim last
      -- Ulduar
      -- Trial of the Crusader
--      ["Personne ne peut arr\195\170ter le Fl\195\169au…"] = "Twin Val'kyr",
--      ["I have failed you, master..."] = "Anub'arak",
--      ["GLOIRE À L'ALLIANCE !"] = "Faction Champions",
--      ["Une victoire tragique et d\195\169pourvue de sens. La perte subie aujourd'hui nous affaiblira tous, car qui d'autre que le roi-liche pourrait b\195\169n\195\169ficier d'une telle folie ? De grands guerriers ont perdu la vie. Et pour quoi ? La vraie menace plane \195\160 l'horizon : le roi-liche nous attend, tous, dans la mort."] = "Faction Champions",
   };

end;