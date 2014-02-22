-- Version : Deutsch (by dasbanane@hotmail.com)
-- Last Update : 27/01/2008
if ( GetLocale() == "deDE" ) then
	LootFilter.Locale = {
		-- Bitte noch verbessern
		-- weird looking keys for quality because we need to sort on them
		qualities= {
			["QUaGrey"]= 0,
			["QUbWhite"]= 1,
			["QUcGreen"]= 2,
			["QUdBlue"]= 3,
			["QUePurple"]= 4,
			["QUfOrange"]= 5,
			["QUgRed"]= 6,
			["QUhTan"] = 7,
			["QUhQuest"]= -1,
		},
		types = {
			["Armor"] = "R\195\188stung",
			["Consumables"] = "Verbrauchsmaterial",
			["Containers"] = "Beh\195\164lter",
			["Gems"] = "Edelsteine",
			["Key"] = "Schl\195\188ssel",
			["Miscellaneous"] = "Verschiedenes",
			["Projectile"] = "Projektile",
			["Quest"] = "Quest's",
			["Quiver"] = "K\195\182cher",
			["Recipe"] = "Rezepte",
			["TradeGoods"] = "Handelsware",
			["Weapons"] = "Waffen",
		},
		radioButtonsText= {
			["QUaGrey"]= "Schlecht (Grau)",
			["QUbWhite"]= "Verbreitet (Weiss)",
			["QUcGreen"]= "Selten (Gr\195\188n)",
			["QUdBlue"]= "Rar (Blau)",
            ["QUePurple"]= "Episch (Lila)",
			["QUfOrange"]= "Legend\195\164r (Orange)",
			["QUgRed"]= "Artefakt (Rot)",
			["QUhTan"] = "Heirloom (Tan)",
			["QUhQuest"]= "Quest",

			-- Armor
			["TYArmorMiscellaneous"] = "Verschiedenes",
			["TYArmorCloth"] = "Stoff",
			["TYArmorLeather"] = "Leder",
			["TYArmorMail"] = "Leichte R\195\188stung ",
			["TYArmorPlate"] = "Platte",
			["TYArmorShields"] = "Schild",
			["TYArmorLibrams"] = "Buchb\195\164nde",
			["TYArmorIdols"] = "G\195\182tzen",
			["TYArmorTotems"] = "Totem",

			-- Consumable
			["TYConsumableFoodDrink"] = "Essen & Trinken",
			["TYConsumablePotion"] = "Gifte",
			["TYConsumableElixir"] = "Elixire",
			["TYConsumableFlask"] = "Flaschen",
			["TYConsumableBandage"] = "Bandagen",
			["TYConsumableItem Enhancement"] = "Entzauberungen",
			["TYConsumableScroll"] = "Schriftrollen",
			["TYConsumableOther"] = "Andere",
			["TYConsumableConsumable"] = "Verbrauchsmaterial",

			-- Container
			["TYContainerBag"] = "Taschen",
			["TYContainerEnchanting Bag"] = "Verzauberertasche",
			["TYContainerEngineering Bag"] = "Ingeneurstasche",
			["TYContainerGem Bag"] = "Edelsteintasche",
			["TYContainerHerb Bag"] = "Kr\195\164utertasche",
			["TYContainerMining Bag"] = "Bergbautasche",
			["TYContainerSoul Bag"] = "Seelenbeutel",
			["TYContainerLeatherworking Bag"] = "Lederertasche",

			-- Miscellaneous
			["TYMiscellaneousJunk"] = "M\195\188ll",
			["TYMiscellaneousReagent"] = "Reagenzien",
			["TYMiscellaneousPet"] = "Tier",
			["TYMiscellaneousHoliday"] = "Holiday",
			["TYMiscellaneousOther"] = "Andere",

			-- Gem
			["TYGemBlue"] = "Blau",
			["TYGemGreen"] = "Gr\195\188n",
			["TYGemOrange"] = "Orange",
			["TYGemMeta"] = "Meta",
			["TYGemPrismatic"] = "Prisma",
			["TYGemPurple"] = "Violet",
			["TYGemRed"] = "Rot",
			["TYGemSimple"] = "Simple",
			["TYGemYellow"] = "Gelb",

			-- Key
			["TYKeyKey"] = "Schl\195\188ssel",

			-- Projektilwaffen
			["TYProjectileArrow"] = "Pfeile",
			["TYProjectileBullet"] = "Wurfwaffen",

			-- Quest
			["TYQuestQuest"] = "Quest",

			-- Quiver
			["TYQuiverAmmoPouch"] = "Munitions Beutel",
			["TYQuiverQuiver"] = "K\195\182cher",

			-- Recipe
			["TYRecipeAlchemy"] = "Alchemie",
			["TYRecipeBlacksmithing"] = "Schmiedekunst",
			["TYRecipeBook"] = "Buch",
			["TYRecipeCooking"] = "Kochen",
			["TYRecipeEnchanting"] = "Verzaubern",
			["TYRecipeEngineering"] = "Ingeneurskunst",
			["TYRecipeFirstAid"] = "Erste Hilfe",
			["TYRecipeLeatherworking"] = "Lederverarbeitung",
			["TYRecipeTailoring"] = "Schneiderei",

			-- Trade Goods
			["TYTrade GoodsElemental"] = "Elementare",
			["TYTrade GoodsCloth"] = "Stoff",
			["TYTrade GoodsLeather"] = "Leder",
			["TYTrade GoodsMetal & Stone"] = "Metalle & Steine",
			["TYTrade GoodsMeat"] = "Fleisch",
			["TYTrade GoodsHerb"] = "Kr\195\164uter",
			["TYTrade GoodsEnchanting"] = "Verzaubern",
			["TYTrade GoodsJewelcrafting"] = "Juwelenschleifen",
			["TYTrade GoodsParts"] = "Bauteile",
			["TYTrade GoodsDevices"] = "Ger\195\164te",
			["TYTrade GoodsExplosives"] = "Explosives",
			["TYTrade GoodsOther"] = "Andere",
			["TYTrade GoodsTradeGoods"] = "Handelsware",

			-- Weapon
			["TYWeaponBows"] = "B\195\182gen",
			["TYWeaponCrossbows"] = "Armbr\195\188ste",
			["TYWeaponDaggers"] = "Dolche",
			["TYWeaponGuns"] = "Schiesseisen",
			["TYWeaponFishingPoles"] = "Angeln",
			["TYWeaponFistWeapons"] = "Faustwaffen",
			["TYWeaponMiscellaneous"] = "Verschiedenes",
			["TYWeaponOneHandedAxes"] = "Einhand \195\132xte",
			["TYWeaponOneHandedMaces"] = "Einhand Streitkolben",
			["TYWeaponOneHandedSwords"] = "Einhand Schwerter",
			["TYWeaponPolearms"] = "Stangenwaffen",
			["TYWeaponStaves"] = "St\195\164be",
			["TYWeaponThrown"] = "Wurfwaffen",
			["TYWeaponTwoHandedAxes"] = "Zweihand \195\132xte",
			["TYWeaponTwoHandedMaces"] = "Zweihand Streitkolben",
			["TYWeaponTwoHandedSwords"] = "Zweihand Schwerter",
			["TYWeaponWands"] = "Zauberst\195\164be",

			["OPEnable"] = "Aktiviere Loot Filter",
			["OPCaching"] = "Aktiviere freizuhaltende Taschenpl\195\164tze",
			["OPTooltips"] = "Tooltipps anzeigen",
			["OPNotifyDelete"] = "Benachr.: Gel\195\182scht",
			["OPNotifyKeep"] = "Benachr.: Aufegnommen",
			["OPNotifyNoMatch"] = "Benachr.: Nicht gefunden",
			["OPNotifyOpen"] = "Benachr.: \195\150ffnen",
			["OPNotifyNew"] = "Benachr. \195\188ber neue Version" ,
			["OPValKeep"] = "Behalte Gegenst. mit mehr Wert als:",
			["OPValDelete"] = "L\195\182sche Gegenst. mit weniger Wert als:",
			["OPOpenVendor"] = "Fenster beim H\195\164ndler \195\182\ffnen",
			["OPAutoSell"] = "Automatisches verkaufen",
			["OPNoValue"] = "Behalte Gegenst\195\164nde mit nicht bekanntem Wert",
			["OPMarketValue"] = "Benutze Versteigerungspreise statt H\195\164ndlerreise",
			["OPBag0"] = "Rucksack",
			["OPBag1"] = "1te Tasche",
			["OPBag2"] = "2te Tasche",
			["OPBag3"] = "3te Tasche",
			["OPBag4"] = "4te Tasche",
			["TYWands"] = "Zauberst\195\164be",
        },
        LocText = {
			["LTTryopen"] = "versuche Gegenstand zu \195\182\ffnen",
			["LTNameMatched"] = "Name gefunden",
			["LTQualMatched"] = "Qualit\195\164t abgestimmt",
			["LTQuest"] = "Quest",				-- Used to match Quest Item as Quality Value
			["LTQuestItem"] = "Questgegenstand",
			["LTTypeMatched"] = "Typ passend",
			["LTKept"] = "aufgenommen",
			["LTNoKnownValue"] = "Gegenstand hat keinen bekannten Wert",
			["LTValueHighEnough"] = "Preis ist hoch genug",
			["LTValueNotHighEnough"] = "Preis ist nicht hoch genug",
			["LTNoMatchingCriteria"] = "keine Kriterien gefunden",
			["LTWasSold"] = "wurde verkauft",
			["LTWasDeleted"] = "wurde gel\195\182scht",
			["LTNewVersion1"] = "Eine neue Version von",
			["LTNewVersion2"] = "Loot Filter, wurde erkannt. Download von http://www.lootfilter.com.",
			["LTAddedCosQuest"] = "hinzugef\195\188gt, da der Gegenstand ein Questitem ist.",
			["LTDeleteItems"] = "L\195\182sche Gegenst\195\164nde",
			["LTSellItems"] = "Verkaufe Gegenst\195\164nde",
			["LTFinishedSC"] = "Fertig verkauft / gel\195\182scht.",
			["LTNoOtherCharacterToCopySettings"] = "Kein anderer Charakter verf\195\188gbar um Einstellungen zu \195\188bernehmen.",
			["LTTotalValue"] = "Gesamtwert",
			["LTSessionInfo"] = "Below are some item values that have been recorded this session.",
			["LTSessionTotal"] = "Total value",
			["LTSessionItemTotal"] = "Number of items",
			["LTSessionAverage"] = "Average / item",
			["LTSessionValueHour"] = "Average / hour",
			["LTNoMatchingItems"] = "kein passender Gegenstand gefunden.",
			["LTItemLowestValue"] = "Der Gegenstand der den niedrigsten Wert hat",
			["LTVendorWinClosedWhileSelling"] = "H\195\164ndlerfenster wurde geschlossen, w\195\164hrend Gegenst\195\164nde verkauft wurden.",
			["LTTimeOutItemNotFound"] = "Timeout. Einer oder mehrere Gegenst\195\164nde in der Liste wurden nicht gefunden.",
        },
		LocTooltip = {
			["LToolTip1"] = "Alle hier aufgef\195\188hrten Gegenst\195\164nde haben mit keinem Behaltenkriterium \195\188bereingestimmt. Du kannst w\195\164hlen, ob du die Gegenst\195\164nde automatisch zu verkaufen oder l\195\182schen m\195\182chtest. Verwende Shift-Klick auf einen Gegenstand, um ihn zur BEHALTEN-Liste hinzuzuf\195\188gen.",
			["LToolTip2"] = "W\195\164hlen dies, wenn du NICHTS tun willst, was jedoch die Eigenschaften erf\195\188llen w\195\188rde.",
			["LToolTip3"] = "W\195\164hlen dies, wenn du diesen Gegenstan BEHALTEN willst, der die Eigenschaften erf\195\188llt.",
			["LToolTip4"] = "W\195\164hlen dies, wenn du diesen Gegenstan L\195\150SCHEN willst, der die Eigenschaften erf\195\188llt.",
			["LToolTip5"] = "Gegenst\195\164nde die hier aufgef\195\188hrten sind, werden BEHALTEN.\n\nGieb einen Namen in eine neue Zeile ein. Du kannst auch Kommentare hinzuf\195\188gen, nachdem du nach dem Namen  ein ';' eingegeben hast. Du kannst auch nur Namensteile eingeben mit ('#') voran. Ein Beispiel ist:\n#(.*)Trank$ ; W\195\182rter mit der Endung Trank\n#(.*)Rolle(.*) ; W\195\182rter die Rolle beinhalten\nUse the '##' prefix to match against text in an item tooltip.",
			["LToolTip6"] = "Gegenst\195\164nde die hier aufgef\195\188hrten sind, werden GEL\195\150SCHT.\n\nGieb einen Namen in eine neue Zeile ein. Du kannst auch Kommentare hinzuf\195\188gen, nachdem du nach dem Namen  ein ';' eingegeben hast. Du kannst auch nur Namensteile eingeben mit ('#') voran. Ein Beispiel ist:\n#(.*)Trank$ ; W\195\182rter mit der Endung Trank\n#(.*)Rolle(.*) ; W\195\182rter die Rolle beinhalten\nUse the '##' prefix to match against text in an item tooltip.",
			["LToolTip7"] = "Gegenst\195\164nde die kleiner als dieser Wert sind werden GEL\195\150SCHT.\n\nDie eingegebene Preise sind in Gold. Gold 0,1 entspricht also 10 Silber.",
			["LToolTip8"] = "Gegenst\195\164nde die gr\195\182sser als dieser Wert sind werden BEHALTEN.\n\nDie eingegebene Preise sind in Gold. Gold 0,1 entspricht also 10 Silber.",
			["LToolTip9"] = "Gieb die Anzahl der freizuhaltenden Taschenpl\195\164tze ein. Loot Filter ersetzt niederpreisige Gegenst\195\164nde mit h\195\182herpreisigen Gegenst\195\164nden, wenn die angegebnen Taschenpl\195\164tze nicht verf\195\188gbar sind.",
			["LToolTip10"] = "Alle hier aufgef\195\188hrten Gegenst\195\164nde haben mit keinem Behaltenkriterium \195\188bereingestimmt. Du kannst w\195\164hlen, ob du die Gegenst\195\164nde automatisch zu verkaufen oder l\195\182schen m\195\182chtest. Verwende Shift-Klick auf einen Gegenstand, um ihn zur BEHALTEN-Liste hinzuzuf\195\188gen.",
			["LToolTip11"] = "Gegenst\195\164nde, die hier aufgef\195\188hrt sind, werden automatisch ge\195\182ffnet. Benutze diese Funktion NICHT f\195\188r Schriftrollen. Es wird nicht funktionieren, und generiert einen Fehler. \n\nGieb einen Namen in eine neue Zeile ein. Du kannst auch Kommentare hinzuf\195\188gen, nachdem du nach dem Namen  ein ';' eingegeben hast. Du kannst auch nur Namensteile eingeben mit ('#') voran. Ein Beispiel ist:\n#(.*)Muschel$ ; W\195\182rter mit der Endung Muschel\n#(.*)Muschel(.*) ; W\195\182rter die Muschel beinhalten",
			["LToolTip12"] = "W\195\164hlen, wie du es berechnet haben willst (Wert * Anzahl Gegenst\195\164nde). Ein einzelner Gegenstand, die aktuelle Stockgr\195\182sse oder die maximale Stockgr\195\182sse."
		},
	};

	-- Interface (xml) Lokalisation
	LFINT_BTN_GENERAL = "Allgemein";
	LFINT_BTN_QUALITY = "Qualit\195\164t";
	LFINT_BTN_TYPE = "Typ";
	LFINT_BTN_NAME = "Name";
	LFINT_BTN_VALUE = "Preis";
	LFINT_BTN_CLEAN = "L\195\182schen";
	LFINT_BTN_OPEN = "\195\150ffnen";
	LFINT_BTN_COPY = "Kopieren";
	LFINT_BTN_CLOSE = "Schliessen";
	LFINT_BTN_DELETEITEMS = "L\195\182sche Gegenst\195\164nde";
	LFINT_BTN_YESSURE = "Ja, ich bin sicher";
	LFINT_BTN_COPYSETTINGS = "Kopiere Einstellungen";
	LFINT_BTN_DELETESETTINGS = "Delete settings";
	LFINT_BTN_RESET = "Reset";

	LFINT_TXT_MOREINFO = "|n|nWenn du Fragen oder \195\132nregungen hast, besuche die Website unter http://www.lootfilter.com|noder senden eine E-Mail an meter@lootfilter.com.";
	LFINT_TXT_SELECTBAGS = "W\195\164hle die Tasche, in denen du Loot Filter verwenden m\195\182chtest.";
	LFINT_TXT_ITEMKEEP = "Gegenst\195\164nde, die du BEHALTEN m\195\182chtest.";
	LFINT_TXT_ITEMDELETE = "Gegenst\195\164nde, die du L\195\150SCHEN m\195\182chtest.";
	LFINT_TXT_INSERTNEWNAME = "Gieb den Namen in eine neue Zeile ein.";
	LFINT_TXT_INFORMANTNEED = "Wenn du diesen Filter nutzen m\195\182chtest, ben\195\182\tigst du ein Addon das die GetSellValue API unterst\195\188tzen. zB. Informant, ItemPriceTooltip.";
	LFINT_TXT_NUMFREEBAGSLOTS = "Freizuhaltenden Taschepl\195\164tze";
	LFINT_TXT_SELLALLNOMATCH = "Alle Gegenst\195\164nde die du verkaufen oder l\195\182schen willst, die nicht die gew\195\188nschten Eigenschaften haben.";
	LFINT_TXT_AUTOOPEN = "Gegenst\195\164nde die du automatisch \195\182ffnen willst wie z.B. Muscheln.";
	LFINT_TXT_SELECTCHARCOPY = "W\195\164hle den Charakter, von dem du die Einstellungen kopieren m\195\182chtest.";
	LFINT_TXT_COPYSUCCESS = "Einstellungen wurden erfolgreich kopiert.";
	LFINT_TXT_SELECTTYPE = "W\195\164hle eine Untergruppe:";
	LFINT_TXT_SIZETOCALCULATE = "Anzahl Gegenst\195\164nde f\195\188r die Wertberechnung:";
	LFINT_TXT_SIZETOCALCULATE_TEXT1 = "ein einzelner Gegenstand";
	LFINT_TXT_SIZETOCALCULATE_TEXT2 = "aktuellen Stackgr\195\182sse";
	LFINT_TXT_SIZETOCALCULATE_TEXT3 = "maximale Stackgr\195\182sse";

	BINDING_NAME_LFINT_TXT_TOGGLE = "Wechsle Fenster";
	BINDING_HEADER_LFINT_TXT_LOOTFILTER = "Loot Filter";
end;
