-- Version : French (by Jimpunk)
-- Last Update : 22/04/2008
if ( GetLocale() == "frFR" ) then
LootFilter.Locale = {
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
			["QUhQuest"]= -1 
		},
		types = {
        ["Armor"] = "Armor",
		["Consumables"] = "Consumable",
		["Containers"] = "Container",
		["Gems"] = "Gem",
		["Key"] = "Key",
		["Miscellaneous"] = "Miscellaneous",
		["Projectile"] = "Projectile",
		["Quest"] = "Quest",
		["Quiver"] = "Quiver",		
		["Recipe"] = "Recipe",
		["TradeGoods"] = "Trade Goods",
		["Weapons"] = "Weapon",
		},
		radioButtonsText= {
			["QUaGrey"]= "Mauvais (Gris)",
			["QUbWhite"]= "Commun (Blanc)",
			["QUcGreen"]= "Inhabituel (vert)",
			["QUdBlue"]= "Rare (Bleu)",
			["QUePurple"]= "Epique (Violet)",
			["QUfOrange"]= "Legendaire (Orange)",
			["QUgRed"]= "Artefact (Rouge)",
			["QUhTan"] = "Heirloom (Tan)",
			["QUhQuest"]= "Quete",
	
			-- Armor
			["TYArmorMiscellaneous"]= "Divers",
			["TYArmorCloth"]= "Tissu",
			["TYArmorLeather"]= "Cuir",
			["TYArmorMail"]= "Maille",
			["TYArmorPlate"]= "Plaque",
			["TYArmorShields"]= "Bouclier",
			["TYArmorLibrams"]= "Librams",
			["TYArmorIdols"]= "Idoles",
			["TYArmorTotems"]= "Totems",
			
			-- Consumable
			["TYConsumableFoodDrink"]= "Nourritures et Boissons",
			["TYConsumablePotion"]= "Potions",
			["TYConsumableElixir"]= "Elixirs",
			["TYConsumableFlask"]= "Flacons",
			["TYConsumableBandage"]= "Bandages",
			["TYConsumableItem Enhancement"]= "Ameliorations d'objet",
			["TYConsumableScroll"]= "Parchemins",
			["TYConsumableOther"]= "Autres",
			["TYConsumableConsumable"]= "Consommable",
			
			-- Container
			["TYContainerBag"]= "Sac",
			["TYContainerEnchanting Bag"]= "Sac d'enchanteur",
			["TYContainerEngineering Bag"]= "Sac d'ingenieur",
			["TYContainerGem Bag"]= "Sac de joaillier",
			["TYContainerHerb Bag"]= "Sac d'herboriste",
			["TYContainerMining Bag"]= "Sac de mineur",
			["TYContainerSoul Bag"]= "Sac d'ames",
			["TYContainerLeatherworking Bag"]= "Sac de depeceur",
			
			
			-- Miscellaneous
			["TYMiscellaneousJunk"]= "Camelote",
			["TYMiscellaneousReagent"]= "Reactif",
			["TYMiscellaneousPet"]= "Animal de companie (inoffensif)",
			["TYMiscellaneousHoliday"]= "Holiday",
			["TYMiscellaneousOther"]= "Autres",
			-- Gem
			["TYGemBlue"] = "Bleu",
			["TYGemGreen"] = "Verte",
			["TYGemOrange"] = "Orange",
			["TYGemMeta"] = "Meta-Chasse",
			["TYGemPrismatic"] = "Prismatique",
			["TYGemPurple"] = "Violet",
			["TYGemRed"] = "Rouge",
			["TYGemSimple"] = "Simple",
			["TYGemYellow"] = "Jaune",
			
			
			-- Key
			["TYKeyKey"]= "Clefs",
			-- Projectile
			["TYProjectileArrow"]= "Fleches",
			["TYProjectileBullet"]= "Balles",
			-- Quest
			["TYQuestQuest"]= "Quetes",
			
			-- Quiver
			["TYQuiverAmmoPouch"]= "Giberne",
			["TYQuiverQuiver"]= "Carquois",				
			
			-- Recipe
			["TYRecipeAlchemy"]= "Recette d'alchimie",
			["TYRecipeBlacksmithing"]= "Plan de forge",
			["TYRecipeBook"]= "Livre",
			["TYRecipeCooking"]= "Recette de cuisine",
			["TYRecipeEnchanting"]= "Plan d'enchantement",
			["TYRecipeEngineering"]= "Plan d'ingenierie",
			["TYRecipeFirstAid"]= "Patron de premiers soins",
			["TYRecipeLeatherworking"]= "Patron de travailleur du cuir",
			["TYRecipeTailoring"]= "Patron de couture",
			
					
			-- Trade Goods
			["TYTrade GoodsElemental"] = "Elementaire",
			["TYTrade GoodsCloth"] = "Tissu",
			["TYTrade GoodsLeather"] = "Cuir",
			["TYTrade GoodsMetal & Stone"] = "Metal & pierres", 
			["TYTrade GoodsMeat"] = "Viande",
			["TYTrade GoodsHerb"] = "Plantes",
			["TYTrade GoodsEnchanting"] = "Enchantement", 
			["TYTrade GoodsJewelcrafting"] = "Joaillerie",
			["TYTrade GoodsParts"]= "Morceaux",
			["TYTrade GoodsDevices"]= "Devices",
			["TYTrade GoodsExplosives"]= "Explosifs",
			["TYTrade GoodsOther"]= "Autres",
			["TYTrade GoodsTradeGoods"]= "Composants",
			
			-- Weapon
			["TYWeaponBows"]= "Arcs",
			["TYWeaponCrossbows"]= "Arbaletes",
			["TYWeaponDaggers"]= "Dagues",
			["TYWeaponGuns"]= "Fusils",
			["TYWeaponFishingPoles"]= "Cannes a peche",
			["TYWeaponFistWeapons"]= "Armes de poing",
			["TYWeaponMiscellaneous"]= "Divers",
			["TYWeaponOneHandedAxes"]= "Haches une main",
			["TYWeaponOneHandedMaces"]= "Masses une main",
			["TYWeaponOneHandedSwords"]= "Epees une main",
			["TYWeaponPolearms"]= "Armes d'hast",
			["TYWeaponStaves"]= "Batons",
			["TYWeaponThrown"]= "Armes de jet",
			["TYWeaponTwoHandedAxes"]= "Haches à deux mains",
			["TYWeaponTwoHandedMaces"]= "Masses à deux mains",
			["TYWeaponTwoHandedSwords"]= "Epees à deux mains",
			["TYWeaponWands"]= "Baguettes",
			
			["OPEnable"]= "Activer Loot Filter",
			["OPCaching"]= "Activer Loot Caching",
			["OPTooltips"]= "Afficher les info-bulles",
			["OPNotifyDelete"]= "Notifier quand supprimer",
			["OPNotifyKeep"]= "Notifier quand garder",
			["OPNotifyNoMatch"]= "Notifier quand rien ne correspond",
			["OPNotifyOpen"]= "Notifier quand ouverture",
			["OPNotifyNew"]= "Notifier si nouvelle version",
			["OPValKeep"]= "Conserver les objets d'une |nvaleur de plus de (ex: 0.1po)",
			["OPValDelete"]= "Supprimer les objets d'une |nvaleur de moins de (ex: 0,1po)",
			["OPOpenVendor"]= "Ouvrir quand vous parlez a un vendeur",
			["OPAutoSell"]= "Vente Automatique",
			["OPNoValue"]= "Conserver les articles sans valeur connue", 
			["OPMarketValue"]= "Utiliser le prix du marche",
			["OPBag0"]= "Sac a dos",
			["OPBag1"]= "Sac 1",
			["OPBag2"]= "Sac 2",
			["OPBag3"]= "Sac 3",
			["OPBag4"]= "Sac 4",
			["TYWands"]= "Baguettes"
		},
		LocText = {
			["LTTryopen"] = "Ouverture...",
			["LTNameMatched"] = "Nom correspondant",
			["LTQualMatched"] = "Qualite correspondante",
			["LTQuest"] = "Quete",              -- Used to match Quest Item as Quality Value
			["LTQuestItem"] = "Objet de quete",
			["LTTypeMatched"]= "Type correspondant",
			["LTKept"] = "Conserve !",
			["LTNoKnownValue"] = "Objet de valeur inconnue",
			["LTValueHighEnough"] = "Valeur assez elevee",
			["LTValueNotHighEnough"] = "Valeur pas assez eleve",
			["LTNoMatchingCriteria"] = "Aucune correspondance trouvee",
			["LTWasSold"] = "A ete vendue",
			["LTWasDeleted"] = "A ete supprime",
			["LTNewVersion1"] = "Une nouvelle version",
			["LTNewVersion2"] = "de Loot Fliter a ete trouvee. Telechargez-la sur www.lootfilter.com .",
			["LTAddedCosQuest"] = "Ajoute a cause de quete",
			["LTDeleteItems"] = "Suppressions objets",
			["LTSellItems"] = "Ventes d'objets",
			["LTFinishedSC"] = "Fin de vente / nettoyage.",
			["LTNoOtherCharacterToCopySettings"] = "Aucun personnage disponible pour copie de parametres.",
	        ["LTTotalValue"] = "Valeur totale",
           ["LTSessionInfo"] = "En dessous se trouvent des valeurs enregistrees lors de la session.",
           ["LTSessionTotal"] = "Valeur totale",
           ["LTSessionItemTotal"] = "Nombre d'objets",
           ["LTSessionAverage"] = "Moyenne/objet",
           ["LTSessionValueHour"] = "Moyenne/heure",			
			["LTNoMatchingItems"] = "Aucun objet trouve.",
			["LTItemLowestValue"] = "Objet avec la plus faible valeur",
			["LTVendorWinClosedWhileSelling"] = "Fenetre vendeur fermee pendant la vente.",
			["LTTimeOutItemNotFound"] = "Timeout. Un ou plusieurs elements de la liste n'ont pas ete retrouves.",
		},
		LocTooltip = {
			["LToolTip1"] = "Les objets cites ici ne correspondent a aucune des proprietes enregistrees. Vous pouvez choisir de vendre ou supprimer automatiquement ces objets. Utilisez Shift+Clic pour ajouter a la liste des objets a garder.",
			["LToolTip2"] = "Selectionnez cette option si vous ne voulez pas attribuer de priorite pour les objets de ce type.",
			["LToolTip3"] = "Selectionnez cette option si vous voulez GARDER les objets de ce type.",
			["LToolTip4"] = "Selectionnez cette option si vous voulez SUPPRIMER les objets de ce type.",
			["LToolTip5"] = "Les objets qui correspond a cette liste sont GARDES.\n\nEntrer un nouveau nom a la ligne. Vous pouvez ajouter un commentaire apres le nom de l'objet suivi de ';'. Vous pouvez utiliser des modeles en commencant avec diese ('#') pour faire correspondre des morceaux de nom. Quelques exemples de modeles sont:\n#(.*)Potion ; Noms finissant par Potion\n#(.*)Parchemin(.*) ; Noms contenant 'parchemin'\nUtilisez le prefixe '##' si le mot se trouve dans la description de l'objet.",
			["LToolTip6"] = "Les objets qui correspond a cette liste sont SUPPRIMES.\n\nEntrer un nouveau nom a la ligne. Vous pouvez ajouter un commentaire apres le nom de l'objet suivi de ';'. Vous pouvez utiliser des modeles en commencant avec diese ('#') pour faire correspondre des morceaux de nom. Quelques exemples de modeles sont:\n#(.*)Potion ; Noms finissant par Potion\n#(.*)Parchemin(.*) ; Noms contenant 'parchemin'\nUtilisez le prefixe '##' si le mot se trouve dans la description de l'objet.",
			["LToolTip7"] = "Les objets de valeurs inferieures seront SUPPRIMES.\n\nLa valeur entree est en Or. 0.1 Or correspond a 10 Argent.",
			["LToolTip8"] = "Les objets de valeurs superieures seront GARDES.\n\nLa valeur entree est en Or. 0.1 Or correspond a 10 Argent.",
			["LToolTip9"] = "Entrez le nombre d'emplacements libres dans votre sac que vous devez conserver. Loot Filter devra remplacer les objets de valeur plus faible par ceux de plus forte valeur si le nombre d'emplacements libres est inferieur a ce qui a ete defini ici.",
			["LToolTip10"] = "Les objets cites ici ne correspondent a aucune propriete enregistree. Vous pouvez choisir de vendre ou supprimer automatiquement ces objets. Utilisez Shift+Clic pour ajouter a la liste des objet a garder.",
			["LToolTip11"] = "Les objets correspondants a une nom liste ici seront automatiquement ouverts . Utiliser ceci pour des parchemins ne fonctionnera pas, et generera une erreur.\n\nAjoutez un nouveau non sur une nouvelle ligne. Vous pouvez ajouter des commentaires apres le nom en utilisant ';'. Vous pouvez utiliser des modeles en commencant avec diese ('#') pour faire correspondre des morceaux de nom. Quelques exemples de modeles sont :\n#(.*)Clam$ ; Noms finissant par 'Palourde'\n#(.*)Palourde(.*) ; Noms contenant 'Palourde'",
			["LToolTip12"] = "Selectionnez comment calculer la valeur des objets (valeur * nombre_objets). Nombre_objets peut etre un objet seul, la taille actuelle de la pile ou la taille maximale de la pile."
		},
	};
	
	--- Interface (xml) localization
	LFINT_BTN_GENERAL = "General" ;
	LFINT_BTN_QUALITY = "Qualite";
	LFINT_BTN_TYPE = "Type";
	LFINT_BTN_NAME = "Nom";
	LFINT_BTN_VALUE = "Valeur";
	LFINT_BTN_CLEAN = "Nettoyage";
	LFINT_BTN_OPEN = "Ouvrir";
	LFINT_BTN_COPY = "Copier";
	LFINT_BTN_CLOSE = "Fermer";
	LFINT_BTN_DELETEITEMS = "Supprimer objets" ;
	LFINT_BTN_YESSURE = "Oui je suis sur" ;
	LFINT_BTN_COPYSETTINGS = "Copier parametres";
	LFINT_BTN_DELETESETTINGS = "Delete settings";
	
	LFINT_TXT_MOREINFO = "|n|nSi vous avez des questions ou des suggestions merci de visiter le site www.lootfilter.com|nou envoyez un mail a  meter@lootfilter.com|n|nTraduit par Jimpunk/Check par Cafeine .";
	LFINT_TXT_SELECTBAGS = "Selectionnez les sacs qui seront utilises pour Loot Filter.";
	LFINT_TXT_ITEMKEEP = "Objets a GARDER.";
	LFINT_TXT_ITEMDELETE = "Objets a SUPPRIMER.";
	LFINT_TXT_INSERTNEWNAME = "Utilisez une nouvelle ligne pour un nouveau nom.";
	LFINT_TXT_INFORMANTNEED = "Si vous voulez filtrer les objets par la valeur de ces derniers, il vous faut des addons GetSellValue API (exemple. Informant, ItemPriceTooltip)." ;
	LFINT_TXT_NUMFREEBAGSLOTS = "Nombre de places libres dans le sac" ;
	LFINT_TXT_SELLALLNOMATCH = "Objets a Supprimer ou Vendre ne faisant pas partie de la selection des objets a GARDER/SUPPRIMER |n(Clic+Shift pour garder)." ;
	LFINT_TXT_AUTOOPEN = "Les objets ci-dessous seront automatiquement ouverts et lootes (comme les palourdes)." ;
	LFINT_TXT_SELECTCHARCOPY = "Selectionnez le personnage duquel vous voulez copier les parametres." ;
	LFINT_TXT_COPYSUCCESS = "Les parametres ont ete copies avec succes." ;
	LFINT_TXT_SELECTTYPE = "Selectionnez un sous-type: ";
	
LFINT_TXT_SIZETOCALCULATE = "Utiliser pour calculer la valeur de l'objet:";
LFINT_TXT_SIZETOCALCULATE_TEXT1 = "d'un objet unique";
LFINT_TXT_SIZETOCALCULATE_TEXT2 = "taille actuelle de la pile";
LFINT_TXT_SIZETOCALCULATE_TEXT3 = "taille maximale de la pile";
	
	
	BINDING_NAME_LFINT_TXT_TOGGLE = "Toggle window";
	BINDING_HEADER_LFINT_TXT_LOOTFILTER = "Loot Filter";
end
