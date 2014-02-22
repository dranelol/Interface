if (GetLocale() == "ruRU") then
	CT_RaidTracker_Translation_Complete = false;
	
	PlayerGroupsIndexes = {"а","б","в","г","д","е","ё","ж","з","и","й","к","л","м","н","о","п","р","с","т","у","ф","х","ц","ч","ш","щ","ъ","ы","ь","э","ю","я"};	


	CT_RaidTracker_lang_LeftGroup = "([^%s]+) покидает рейдовую группу";
	CT_RaidTracker_lang_JoinedGroup = "([^%s]+) присоединятся к рейдовой группе";
	CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) получает добычу: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot2 = "Ваша добыча: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) получает добычу: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLoot4 = "Ваша добыча: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLootYou = "Вы";
	
	CT_RaidTracker_ZoneTriggers = {
		["Око Вечности"] = "The Eye of Eternity",
		["Обсидиановое святилище"] = "The Obsidian Sanctum",
		["Склеп Аркавона"] = "Vault of Archavon",
		["Наксрамас"] = "Naxxramas",
		["Ульдуар"] = "Ulduar",
		["Испытание крестоносца"] = "Trial of the Crusader",
		["испытание великого крестоносца"] = "Trial of the Grand Crusader",
		["Логово Ониксии"] = "Onyxia's Lair",
		["Цитадель Ледяной Короны"] = "Icecrown Citadel",
	};
	
	CT_RaidTracker_BossUnitTriggers = {
		-- Eye of Eternity
		["Малигос"] = "Malygos",

		-- Obsidian Sanctum
		["Сартарион"] = "Sartharion",
				
		-- Vault of Archavon
		["Эмалон Созерцатель Бури"] = "Emalon the Storm Watcher",
		["Аркавон Каменный Страж"] = "Archavon the Stone Watcher",
		["Коралон Страж Огня"] = "Koralon the Flame Watcher",
		-- Vault of Archavon
		
		-- Naxxramas
		["Лоскутик"] = "Patchwerk",
		["Гроббулус"] = "Grobbulus",
		["Глут"] = "Gluth",
		["Таддиус"] = "Thaddius",
		["Инструктор Разувий"] = "Instructor Razuvious",
		["Готик Жнец"] = "Gothik the Harvester",
		["Нот Чумной"] = "Noth the Plaguebringer",
		["Хейган Нечестивый"] = "Heigan the Unclean",
		["Лотхиб"] = "Loatheb",
		["Ануб'Рекан"] = "Anub'Rekhan",
		["Великая вдова Фарлина"] = "Grand Widow Faerlina",
		["Мексна"] = "Maexxna",
		["Сапфирон"] = "Sapphiron",
		["Кел'Тузад"] = "Kel'Thuzad",
		["-- 4 Horsemen"] = "-- 4 Horsemen",
		["Барон Ривендер"] = "Baron Rivendare",
		["Тан Кортазз"] = "Thane Korth'azz",
		["Леди Бломе"] = "Lady Blaumeux",
		["Сэр Зелиек"] = "Sir Zeliek",
		-- Naxxramas
		
		-- Ulduar
		["Ходир"] = "Hodir",
		["Буревестник Брундир"] = "IGNORE", -- The Assembly of Iron
		["Торим"] = "Thorim",
		["Сталелом"] = "IGNORE", -- The Assembly of Iron
		["Фрейя"] = "Freya",
		["The Assembly of Iron"] = "The Assembly of Iron",
		["Мастер рун Молгейм"] = "IGNORE", -- The Assembly of Iron
		["Огненный Левиафан"] = "Flame Leviathan",
		["Повелитель Горнов Игнис"] = "Ignis the Furnace Master",
		["Острокрылая"] = "Razorscale",
		["Генерал Везакс"] = "General Vezax",
		["Йогг-Сарон"] = "Yogg-Saron",
		["Разрушитель XT-002"] = "XT-002 Deconstructor",
		["Ауриайя"] = "Auriaya",
		["Кологарн"] = "Kologarn",
		["Мимирон"] = "Mimiron",
		["Алгалон Наблюдатель"] = "Algalon the Observer",
		-- Ulduar


		-- Trial of the Crusader
		["Ледяной Рев"] = "Icehowl",
		["Лорд Джараксус"] = "Lord Jaraxxus",
		-- Yell Helper
		["Валь'киры-близнецы"] = "Twin Val'kyr",
		["Ануб'арак"] = "Anub'arak",
		["Чемпионы фракций"] = "Faction Champions",
		-- Trial of the Crusader

		-- Trial of the Grand Crusader
		["Ледяной Рев"] = "Icehowl",
		["Лорд Джараксус"] = "Lord Jaraxxus",
		-- Yell Helper
		["Валь'киры-близнецы"] = "Twin Val'kyr",
		["Ануб'арак"] = "Anub'arak",
		["Чемпионы фракций"] = "Faction Champions",
		-- Trial of the Grand Crusader

		-- Onyxia's Lair
		["Ониксия"] = "Onyxia",
		-- Onyxia's Lair

		-- Icecrown Citadel
    		-- Storming the Citadel
      		["Лорд Ребрад"] = "Lord Marrowgar",
      		["Леди Смертный Шепот"] = "Lady Deathwhisper",
        	["Воздушное Сражение"] = "Gunship Battle", -- Yell Helper
        	["Саурфанг Смертоносный"] = "Deathbringer Saurfang",

        	-- Adds in Lord Marrowgar Fight
        	["Костяной шип"] = "IGNORE",

        	-- Adds in Gunship Battle
        	-- Horde NPC (must be killed by Alliance)
        	["High Overlord Saurfang"] = "IGNORE",
        	["Horde Gunship Cannon"] = "IGNORE",
        	["Kor'kron Sergeant"] = "IGNORE",
        	["Kor'kron Rocketeer"] = "IGNORE",
        	["Kor'kron Reaver"] = "IGNORE",
        	["Kor'kron Battle-Mage"] = "IGNORE",
        	["Kor'kron Axethrower"] = "IGNORE",

        	-- Alliance NPC (must be killed by Horde)
        	["Muradin Bronzebeard"] = "IGNORE",
        	["Alliance Gunship Cannon"] = "IGNORE",
        	["Skybreaker Rifleman"] = "IGNORE",
        	["Skybreaker Marine"] = "IGNORE",
        	["Skybreaker Sergeant"] = "IGNORE",
        	["Skybreaker Sorcerer"] = "IGNORE",
        	["Skybreaker Mortar Soldier"] = "IGNORE",


        	-- Adds in Lady Deathbringer Fight
        	["Адепт культа"] = "IGNORE",
        	["Фанатик культа"] = "IGNORE",
        	["Воскрешенный адепт"] = "IGNORE",
        	["Воскрешенный фанатик"] = "IGNORE",


       		-- The Plagueworks
        	["Тухлопуз"] = "Festergut",
        	["Гниломорд"] = "Rotface",
        	["Профессор Мерзоцид"] = "Professor Putricide",

        	-- Adds in Rotface Fight
        	["Sticky Ooze"] = "IGNORE",
        	["Big Ooze"] = "IGNORE",
        	["Little Ooze"] = "IGNORE",

        	-- Adds in Professor Putricide Fight
        	["Mutated Slime"] = "IGNORE",
        	["Volatile Ooze"] = "IGNORE",
        	
		-- The Crimson Hall
        	["Совет Принцев Крови"] = "Blood Prince Council", -- Yell-Dummy / Not tested yet
        	["Королева Лана'Тель"] = "Queen Lana'thel", -- Not tested yet

        	-- The Frostwing Halls
        	["Синдрагоса"] = "Sindragosa",
        	["Валитрия Сновидица"] = "Valithria Dreamwalker", -- Yell-Dummy

        	-- Adds in Valintria Dreamwalker Fight
        	["Suppresser"] = "IGNORE",
        	["Blistering Zombie"] = "IGNORE",
        	["Gluttonous Abomination"] = "IGNORE",
        	["Rot Worms"] = "IGNORE",
        	["Blazing Skeleton"] = "IGNORE",
        	["Risen Archmage"] = "IGNORE",
        
		-- Adds in Sindragosa Fight
        	["Ледяная могила"] = "IGNORE",


        	-- The Frozen Throne
        	["Король-Лич Артас"] = "The Lich King", -- Not tested yet

		["DEFAULTBOSS"] = "Trash mob",
		["Track Members"] = "Track Members",
	};
	
	CT_RaidTracker_lang_BossKills = {
	-- Ulduar
    	["Очевидно, я совершил небольшую ошибку в расчетах. Пленный злодей затуманил мой разум и заставил меня отклониться от инструкций. Сейчас все системы в норме. Конец связи."] = "Мимирон", -- Mimiron
    	["Я… Проиграл."] = "Повелитель Горнов Игнис", -- Ignis the Furnace Master
    	["Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои."] = "Фрейя", -- Freya
    	["Придержите мечи! Я сдаюсь."] = "Торим", -- Thorim
    	["Наконец-то я... свободен от его оков…"] = "Ходир", -- Hodir
      	["Повелитель, они идут..."] = "Kologarn",
      	["Плохие... игрушки... очень... плохиеееее."] = "XT-002 Deconstructor",
     	["Какие ужасы вас ожидают..."] = "General Vezax",
    	["Вы обречены. Ни вы, никто другой НЕ В СИЛАХ избежать близящегося конца света. Уульви ифис халас гаг эрх'онг ушшш!"] = "Йогг-Сарон", -- Yogg-Saron
	["Невозможно..."] = "The Assembly of Iron", -- Iron Council Hardmode / Steelbreaker last
		["You rush headlong into the maw of madness!"] = "The Assembly of Iron", -- Iron Council Normalmode / Brundir last
		["What have you gained from my defeat? You are no less doomed, mortals!"] = "The Assembly of Iron", -- Iron Council Semimode / Molgeim last
    	-- Ulduar
	-- Trial of the Crusader
	["Плеть не остановить..."] = "Twin Val'kyr",
	["Я подвел тебя, господин..."] = "Anub'arak",
	["Пустая и горькая победа. После сегодняшних потерь мы стали слабее как целое. Кто ещё, кроме Короля-лича, выиграет от подобной глупости? Пали великие воины. И ради чего? Истинная опасность ещё впереди - нас ждет битва с Королем-личом."] = "Faction Champions",
	-- Trial of the Crusader
	-- Trial of the Grand Crusader
	["Плеть не остановить..."] = "Twin Val'kyr",
	["Я подвел тебя, господин..."] = "Anub'arak",
	["Пустая и горькая победа. После сегодняшних потерь мы стали слабее как целое. Кто ещё, кроме Короля-лича, выиграет от подобной глупости? Пали великие воины. И ради чего? Истинная опасность ещё впереди - нас ждет битва с Королем-личом."] = "Faction Champions",
	-- Trial of the Grand Crusader
	-- Icecrown Citadel
	["Альянс повержен. Вперед, к Королю-личу!"] = "Gunship Battle" -- Gunship Battle Horde
	-- Icecrown Citadel
	};


end;