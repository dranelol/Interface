--------------------------------------------------------------------------
-- ru.lua 
-- Last Modified 10/16/2010
-- Translated by Пашуля on EU Черный Шрам
--------------------------------------------------------------------------

if ( GetLocale() == "ruRU" ) then
LootFilter.Locale = {
	qualities= {
		["QUaGrey"]= 0,
		["QUbWhite"]= 1,
		["QUcGreen"]= 2,
		["QUdBlue"]= 3,
		["QUePurple"]= 4,
		["QUfOrange"]= 5,
		["QUgRed"]= 6,
		["QUhTan"] = 7,
		["QUhQuest"]= -1 
	},
	types = {
		["Armor"] = "Броня",
		["Consumables"] = "Расходуемое",
		["Containers"] = "Контейнер",
		["Gems"] = "Самоцвет",
		["Key"] = "Ключ",
		["Miscellaneous"] = "Разное",
		["Projectile"] = "Боеприпасы",
		["Quest"] = "Квестовые",
		["Quiver"] = "Амуниция",		
		["Recipe"] = "Рецепт",
		["TradeGoods"] = "Хозяйственные товары",
		["Weapons"] = "Оружие",
	},
	radioButtonsText= {
		["QUaGrey"]= "Мусор (Серое)",
		["QUbWhite"]= "Обычное (Белое)",
		["QUcGreen"]= "Необычное (Зеленое)",
		["QUdBlue"]= "Редкое (Синее)",
		["QUePurple"]= "Превосходное (Фиолетовое)",
		["QUfOrange"]= "Легендарное (Оранжевое)",
		["QUgRed"]= "Артефакт (Красное)",
		["QUhTan"] = "Фамильное (Коричневое)",
		["QUhQuest"]= "Квестовое",

		-- Armor
		["TYArmorMiscellaneous"]= "Разное",
		["TYArmorCloth"]= "Ткань",
		["TYArmorLeather"]= "Кожа",
		["TYArmorMail"]= "Кольчуга",
		["TYArmorPlate"]= "Латы",
		["TYArmorShields"]= "Щиты",
		["TYArmorLibrams"]= "Манускрипты",
		["TYArmorIdols"]= "Идолы",
		["TYArmorTotems"]= "Тотемы",
		
		-- Consumable
		["TYConsumableFoodDrink"]= "Еда и напитки",
		["TYConsumablePotion"]= "Зелье",
		["TYConsumableElixir"]= "Эликсир",
		["TYConsumableFlask"]= "Настой",
		["TYConsumableBandage"]= "Бинт",
		["TYConsumableItem Enhancement"]= "Улучшение",
		["TYConsumableScroll"]= "Свиток",
		["TYConsumableOther"]= "Другое",
		["TYConsumableConsumable"]= "Расходуемое",
		
		-- Container
		["TYContainerBag"]= "Сумка",
		["TYContainerEnchanting Bag"]= "Сумка зачаровывателя",
		["TYContainerEngineering Bag"]= "Сумка инженера",
		["TYContainerGem Bag"]= "Сумка ювелира",
		["TYContainerHerb Bag"]= "Сумка травника",
		["TYContainerMining Bag"]= "Сумка шахтера",
		["TYContainerSoul Bag"]= "Сумка душ",
		["TYContainerLeatherworking Bag"]= "Сумка кожевника",
		--------------------------------------------------------------------
		-- Here also should be present Inscription Bag, something like this:
		["TYContainerInscription Bag"]= "Сумка начертателя",
		--------------------------------------------------------------------
		
		-- Miscellaneous
		["TYMiscellaneousJunk"]= "Хлам",
		["TYMiscellaneousReagent"]= "Реагент",
		["TYMiscellaneousPet"]= "Питомец",
		["TYMiscellaneousHoliday"]= "Праздничный",
		["TYMiscellaneousOther"]= "Другое",
		-- Gem
		["TYGemlue"] = "Синий",
		["TYGemGreen"] = "Зеленый",
		["TYGemOrange"] = "Оранжевый",
		["TYGemMeta"] = "Особый",
		["TYGemPrismatic"] = "Радужный",
		["TYGemPurple"] = "Фиолетовый",
		["TYGemRed"] = "Красный",
		["TYGemSimple"] = "Простой",
		["TYGemYellow"] = "Желтый",
		
		
		-- Key
		["TYKeyKey"]= "Ключ",
		-- Projectile
		["TYProjectileArrow"]= "Стрела",
		["TYProjectileBullet"]= "Пуля",
		-- Quest
		["TYQuestQuest"]= "Квестовый",
		
		-- Quiver
		["TYQuiverAmmoPouch"]= "Подсумок",
		["TYQuiverQuiver"]= "Колчан",				
		
		-- Recipe
		["TYRecipeAlchemy"]= "Алхимия",
		["TYRecipeBlacksmithing"]= "Кузнечное дело",
		["TYRecipeBook"]= "Книга",
		["TYRecipeCooking"]= "Кулинария",
		["TYRecipeEnchanting"]= "Наложение чар",
		["TYRecipeEngineering"]= "Инженерное дело",
		["TYRecipeFirstAid"]= "Первая помощь",
		["TYRecipeLeatherworking"]= "Кожевничество",
		["TYRecipeTailoring"]= "Портняжное дело",
		
				
		-- Trade Goods
		["TYTrade GoodsElemental"] = "Стихии",
		["TYTrade GoodsCloth"] = "Ткань",
		["TYTrade GoodsLeather"] = "Кожа",
		["TYTrade GoodsMetal & Stone"] = "Металл и камень", 
		["TYTrade GoodsMeat"] = "Мясо",
		["TYTrade GoodsHerb"] = "Трава",
		["TYTrade GoodsEnchanting"] = "Наложение чар", 
		["TYTrade GoodsJewelcrafting"] = "Ювелирное дело",
		["TYTrade GoodsParts"]= "Детали",
		["TYTrade GoodsDevices"]= "Устройства",
		["TYTrade GoodsExplosives"]= "Взрывчатка",
		["TYTrade GoodsOther"]= "Другое",
		["TYTrade GoodsTradeGoods"]= "Хозяйственные товары",
		
		-- Weapon
		["TYWeaponBows"]= "Луки",
		["TYWeaponCrossbows"]= "Арбалеты",
		["TYWeaponDaggers"]= "Кинжалы",
		["TYWeaponGuns"]= "Огнестрельное",
		["TYWeaponFishingPoles"]= "Удочки",
		["TYWeaponFistWeapons"]= "Кистевое",
		["TYWeaponMiscellaneous"]= "Разное",
		["TYWeaponOneHandedAxes"]= "Одноручные топоры",
		["TYWeaponOneHandedMaces"]= "Одноручное дробящее",
		["TYWeaponOneHandedSwords"]= "Одноручные мечи",
		["TYWeaponPolearms"]= "Древковое",
		["TYWeaponStaves"]= "Посохи",
		["TYWeaponThrown"]= "Метательное",
		["TYWeaponTwoHandedAxes"]= "Двуручные топоры",
		["TYWeaponTwoHandedMaces"]= "Двуручное дробящее",
		["TYWeaponTwoHandedSwords"]= "Двуручные мечи",
		["TYWeaponWands"]= "Жезлы",
		
		["OPEnable"]= "Включить Loot Filter",
		["OPCaching"]= "Включить кеширование лута",
		["OPTooltips"]= "Показывать подсказки",
		["OPNotifyDelete"]= "Уведомлять при удалении",
		["OPNotifyKeep"]= "Уведомлять при сохранении",
		["OPNotifyNoMatch"]= "Уведомлять при несовпадении",
		["OPNotifyOpen"]= "Уведомлять при открытии",
		["OPNotifyNew"]= "Уведомлять при новой версии",
		["OPConfirmDelete"] = "Подтверждать удаление предмета",
		["OPValKeep"]= "Сохранять предметы стоимостью больше",
		["OPValDelete"]= "Удалять предметы стоимостью меньше",
		["OPOpenVendor"]= "Открывать при разговоре с вендором",
		["OPAutoSell"]= "Автоматически начать продажу",
		["OPNoValue"]= "Сохранять предметы с неизвестной стоимостью", 
		["OPMarketValue"]= "Использовать рыночные цены Auctioneer вместо цен вендора",
		["OPBag0"]= "Рюкзак",
		["OPBag1"]= "Сумка 1",
		["OPBag2"]= "Сумка 2",
		["OPBag3"]= "Сумка 3",
		["OPBag4"]= "Сумка 4",
		["TYWands"]= "Жезлы"
	},
    LocText = {
        ["LTTryopen"] = "попытка открыть",
        ["LTNameMatched"] = "совпадение имени",
        ["LTQualMatched"] = "совпадение качества",
        ["LTQuest"] = "квест",              -- Used to match Quest Item as Quality Value
        ["LTQuestItem"] = "квестовый предмет",
        ["LTTypeMatched"]= "совпадение типа",
        ["LTKept"] = "сохранено",
        ["LTNoKnownValue"] = "предмет с неизвестной стоимостью",
        ["LTValueHighEnough"] = "стоимость достаточно высока",
        ["LTValueNotHighEnough"] = "стоимость недостаточно высока",
        ["LTNoMatchingCriteria"] = "не найдено критерия для совпадения",
        ["LTWasSold"] = "продано",
        ["LTWasDeleted"] = "удалено",
        ["LTNewVersion1"] = "Новая версия",
        ["LTNewVersion2"] = "Loot Filter доступна. Скачать можно с http://www.lootfilter.com .",
        ["LTAddedCosQuest"] = "Добавлено из-за квеста",
        ["LTDeleteItems"] = "Удалять предметы",
        ["LTSellItems"] = "Продавать предметы",
		["LTFinishedSC"] = "Окончена продажа/очистка.",
        ["LTNoOtherCharacterToCopySettings"] = "У Вас неоткуда копировать настройки.",
        ["LTTotalValue"] = "Общая стоимость",
		["LTSessionInfo"] = "Ниже показаны некоторые стоимости предметов, записанные в текущей сессии.",
		["LTSessionTotal"] = "Итого",
		["LTSessionItemTotal"] = "Количество предметов",
		["LTSessionAverage"] = "Среднее за предмет",
		["LTSessionValueHour"] = "Среднее в час",
        ["LTNoMatchingItems"] = "Не найдено совпадений среди предметов.",
        ["LTItemLowestValue"] = "предмет имеет наименьшую цену",
        ["LTVendorWinClosedWhileSelling"] = "Окно вендора было закрыто во время продажи предметов.",
        ["LTTimeOutItemNotFound"] = "Таймаут. Один или более предметов из списка не найдено.",
    },
    LocTooltip = {
        ["LToolTip1"] = "Ни один из предметов в этом списке не удовлетворяет настройкам сохранения. Вы можете автоматически продать или удалить данные предметы. Используйте Shift+клик для добавления предмета в список сохранения.",
        ["LToolTip2"] = "Выберите этот пункт если вам всё равно, что будет с этим предметом.",
        ["LToolTip3"] = "Выберите этот пункт если вы хотите СОХРАНИТЬ предметы с этой характеристикой.",
        ["LToolTip4"] = "Выберите этот пункт если вы хотите УДАЛИТЬ предметы с этой характеристикой.",
        ["LToolTip5"] = "Предметы в этом списке СОХРАНЯЮТСЯ.\n\nВводите новое название предмета в новой строке. Вы можете добавить комментарии после имени используя ';'. Вы можете использовать образец ('#') для совпадения части имени. Вот парочка примеров:\n#Зелье(.*) Совпадение имен, начинающихся с 'Зелье' ; \n#(.*)Свиток(.*) ; Совпадение имен, содержащих 'Свиток'\nИспользуйте префикс '##' для имен, не содержащих искомую часть.",
        ["LToolTip6"] = "Предметы в этом списке УДАЛЯЮТСЯ.\n\nВводите новое название предмета в новой строке. Вы можете добавить комментарии после имени используя ';'. Вы можете использовать образец ('#') для совпадения части имени. Вот парочка примеров:\n#Зелье(.*) Совпадение имен, начинающихся с 'Зелье' ; \n#(.*)Свиток(.*) ; Совпадение имен, содержащих 'Свиток'\nИспользуйте префикс '##' для имен, не содержащих искомую часть.",
        ["LToolTip7"] = "Предметы со стоимостью меньше этого значения УДАЛЯЮТСЯ.\n\nЗначение в золотых. 0.1 золотого соответствует 10 серебра.",
        ["LToolTip8"] = "Предметы со стоимостью выше этого значения СОХРАНЯЮТСЯ.\n\nЗначение в золотых. 0.1 золотого соответствует 10 серебра.",
        ["LToolTip9"] = "Введите количество ячеек в сумках, которое нужно обязательно оставить пустыми. Loot Filter начнет замещать предметы с меньшей стоимостью предметами с большей стоимостью если количество свободных ячеек в сумках будет меньше введенного Вами.",
        ["LToolTip10"] = "Ни один из предметов в этом списке не удовлетворяет настройкам сохранения. Вы можете автоматически продать или удалить данные предметы. Используйте Shift+клик для добавления предмета в список сохранения.",
        ["LToolTip11"] = "Предметы в этом списке автоматически подвергаются попытке их открыть. Использование этого на свитках и т.п. не будет работать и сгенерит ошибку.\n\nВводите новое название предмета в новой строке. Вы можете добавить комментарии после имени используя ';'. Вы можете использовать образец ('#') для совпадения части имени. Вот примеро:\n#(.*)ящик$ Совпадение имен, оканчивающихся на 'ящик'",
	["LToolTip12"] = "Выберите, как вы хотите считать стоимость предмета (<цена> * <количество>). <количество> может быть единичным предметом, текущим размером стака или максимальным размером стака."
    },
};

-- Interface (xml) localization
LFINT_BTN_GENERAL = "Общее" ;
LFINT_BTN_QUALITY = "Качество";
LFINT_BTN_TYPE = "Тип";
LFINT_BTN_NAME = "Имя";
LFINT_BTN_VALUE = "Стоимость";
LFINT_BTN_CLEAN = "Очистка";
LFINT_BTN_OPEN = "Открытие";
LFINT_BTN_COPY = "Копирование";
LFINT_BTN_CLOSE = "Закрыть";
LFINT_BTN_DELETEITEMS = "Удалить предметы" ;
LFINT_BTN_YESSURE = "Да, я уверен" ;
LFINT_BTN_COPYSETTINGS = "Копировать настройки";
LFINT_BTN_DELETESETTINGS = "Удалить настройки";
LFINT_BTN_RESET = "Сброс";

LFINT_TXT_MOREINFO = "|n|nЕсли у Вас есть какие-либо вопросы или замечания - заходите на наш сайт http://www.lootfilter.com|nили шлите электроные письма на meter@lootfilter.com .";
LFINT_TXT_SELECTBAGS = "Выберите с какими сумками будет работать Loot Filter.";
LFINT_TXT_ITEMKEEP = "Предметы, которые Вы хотите СОХРАНИТЬ.";
LFINT_TXT_ITEMDELETE = "Предметы, которые Вы хотите УДАЛИТЬ.";
LFINT_TXT_INSERTNEWNAME = "Вводите новое имя с новой строки.";
LFINT_TXT_INFORMANTNEED = "Если Вы хотите фильтровать предметы по стоимости у Вас должен быть установлен аддон, поддерживающий GetSellValue API (напр. Informant, ItemPriceTooltip)." ;
LFINT_TXT_NUMFREEBAGSLOTS = "Количество свободных слотов в сумках" ;
LFINT_TXT_SELLALLNOMATCH = "Используйте это для сохранения или удаления предметов, не попадающих ни под один критерий сохранения." ;
LFINT_TXT_AUTOOPEN = "Предметы, которые Вы хотите автоматически открывать и лутать (типа ящиков и моллюсков)." ;
LFINT_TXT_SELECTCHARCOPY = "Выберите персонажа, с которого скопировать настройки." ;
LFINT_TXT_COPYSUCCESS = "Настройки успешно скопированы." ;
LFINT_TXT_DELETESUCCESS = "Настройки успешно удалены." ;
LFINT_TXT_SELECTTYPE = "Выберите подтип: ";
LFINT_TXT_SIZETOCALCULATE = "Для вычисления стоимости предмета использовать: ";
LFINT_TXT_SIZETOCALCULATE_TEXT1 = "единичный предмет";
LFINT_TXT_SIZETOCALCULATE_TEXT2 = "текущий размер стака";
LFINT_TXT_SIZETOCALCULATE_TEXT3 = "максимальный размер стака";


BINDING_NAME_LFINT_TXT_TOGGLE = "Переключит состояние окна";
BINDING_HEADER_LFINT_TXT_LOOTFILTER = "Loot Filter";


--[[
New entries to v3.9:
	OPConfirmDelete
--]]
end;