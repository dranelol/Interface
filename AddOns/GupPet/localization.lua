--[[ 	GupPet by Gup 	]]--

GUPPET_S = {} ;
GUPPET_L = {} ;
GUPPET_Z = {} ;
GUPPET_C = {} ;
GUPPET_T = {} ;

-------------------------------------------------------------------------------
-- English localization (Default)
-------------------------------------------------------------------------------

	-- For the key bind interface
	BINDING_HEADER_GUPPET = "GupPet";
	BINDING_NAME_GUPPET_AUTO = "Auto select";
	BINDING_NAME_GUPPET_AUTOFLY = "Auto select fly";
	BINDING_NAME_GUPPET_AUTOGROUND = "Auto select ground";
	BINDING_NAME_GUPPET_SLOWGROUNDMOUNT = "Slow ground mount";
	BINDING_NAME_GUPPET_FASTGROUNDMOUNT = "Fast ground mount";
	BINDING_NAME_GUPPET_MULTIGROUNDMOUNT = "Multi ground mount";
	BINDING_NAME_GUPPET_SLOWFLYMOUNT = "Slow fly mount";
	BINDING_NAME_GUPPET_FASTFLYMOUNT = "Fast fly mount";
	BINDING_NAME_GUPPET_CALLCOMPANION = "Call companion";
	BINDING_NAME_GUPPET_AQUATICMOUNT = "Aquatic mount";

	-- Slash Commands
	GUPPET_S["SLASH"] = "The start command is '/GP' or '/GupPet'. ( The slashcommands in GupPet dont support shapeshift abilities. )" ;
	GUPPET_S["USE"] = " or " ;
	GUPPET_S["MULTIGROUNDMOUNT"] = { "mgm" , "multigroundmount"	, "Selects random a multi mount" } ;
	GUPPET_S["AQUATICMOUNT"]	= { "aqm" , "aquaticmount" 		, "Selects random a aquatic mount" } ;  
	GUPPET_S["AUTOMOUNT"] 		= { "am"  , "automount" 		, "Selects automatic a random mount depending on the location if you can fly" } ;
	GUPPET_S["AUTOGROUNDMOUNT"] = { "agm" , "autogroundmount" 	, "Selects random a ground mount" } ;
	GUPPET_S["AUTOFLYMOUNT"]	= { "afm" , "autoflymount" 		, "Selects random a fly mount" } ;
	GUPPET_S["CALLCOMPANION"] 	= { "cc"  , "callcompanion" 	, "Selects random a companion" } ;
	GUPPET_S["DEBUG"] 			= { "debug" , "debug" , "" } ;
	GUPPET_S["OPTIONMENU"] 		= { "om"  , "optionmenu" 		, "Shortcut to the optionmenu" } ;
	GUPPET_S["TOGGLEINCONSIS"]	= { "ti"  , "toggleinconsistent" , "" } ;
	
	GUPPET_S["SLASH_T_OM_RESET"] = "reset" ;

	
	
	-- Other
	GUPPET_L["OPTIONS"]	= "Options";
	GUPPET_L["MOUNTSCOMPANIONS"]	= "Mounts + Companions";
	GUPPET_L["CLOSE"]	= "Close";
	GUPPET_L["HELP"]	= "Help";
		
	GUPPET_L["ADD"]				= { "Add" , "Adds the current location" };
	GUPPET_L["REMOVE"]			= { "Remove" , "Removes the selected location" };
	GUPPET_L["ALLAQUATICMOUNT"]	= { "Aquatic" , "" };
	GUPPET_L["ALLGROUNDMOUNT"]	= { "Ground" , "" };
	GUPPET_L["ALLFLYMOUNT"]		= { "Fly" , "" };
	GUPPET_L["ALLCOMPANION"]	= { "Companion" , "" };
	
	GUPPET_L["ENABLE"]		= { "Enable" , "" };
	GUPPET_L["DISABLE"]		= { "Disable" , "" };
	GUPPET_L["SHOW"]		= { "Show" , "" };
	GUPPET_L["LOCKED"]		= { "Locked" , "" };
	GUPPET_L["SCALE"]		= { "Scale" , "Small", "Big" };
	GUPPET_L["COMPANIONBUTTONSHOW"]		= { "Show companion button" , "" };
	GUPPET_L["RESTORE"]		= { "Restore" , "Restore the position of the actionbuttons to the center of the screen" };
	GUPPET_L["ICON"]		= { "Icon" , "Show a menu to change the look of the buttons"};

	GUPPET_L["BUTTONMODE"]	= { "Mount button auto" , "Change the amount of buttons from one to two", "If you are seeing this message your client language is not supported" };
	GUPPET_L["EXPERTMODE"]	= { "Expert Mode" , "Change the mode to expert user where you can set even more vars to random your pets" };
	GUPPET_L["BUTTONALIGNMENT"]	= { "Alignment" , "Toggle the button alignment from horizontal to vertical" };
	GUPPET_L["HIDEKEYBINDTEXT"] = { "Hide keybind" , "Hides the keybind text on the buttons when checked"  }
	
	GUPPET_L["AQUATICMOUNT"]	= { "" , "" };
	GUPPET_L["SLOWGROUNDMOUNT"]	= { "Slow" , "" };
	GUPPET_L["FASTGROUNDMOUNT"]	= { "Fast" , "" };
	GUPPET_L["MULTIDMOUNT"]		= { "Multi" , "" };
	GUPPET_L["SLOWFLYMOUNT"]	= { "Slow" , "" };
	GUPPET_L["FASTFLYMOUNT"]	= { "Fast" , "" };
	GUPPET_L["COMPANION"]		= { "" , "" };
	
	GUPPET_L["AUTOCALLCOMPANION"]	= "Companion" ;
	GUPPET_L["AUTOCALLCOMPANION_ENABLE"] 	= { "Enable Auto Call" , "" };
	GUPPET_L["AUTOCALLCOMPANION_CITY"] 	= { "City" , "" };
	GUPPET_L["AUTOCALLCOMPANION_OUTSIDE"] = { "Outside" , "" };
	GUPPET_L["AUTOCALLCOMPANION_ARENA"] 	= { "Arena" , "" };
	GUPPET_L["AUTOCALLCOMPANION_PARTY"] = { "Party" , "" };
	GUPPET_L["AUTOCALLCOMPANION_RAID"] = { "Raid" , "" };
	GUPPET_L["AUTOCALLCOMPANION_BATTLEGROUND"] = { "BattleGround" , "" };
	GUPPET_L["AUTOCALLCOMPANION_DELAY"] 	= { "Delay" , "The time the auto call function waits in seconds from 2 to 10" };
	GUPPET_L["AUTOCALLCOMPANION_AUTODISMISSMOUNTED"] 	= { "Dismiss while mounted" , "" };
	GUPPET_L["AUTOCALLCOMPANION_RESUMMON"] 	= { "Recall Delay" , "The time the auto recall function waits in seconds to recall a companion when in a city.|nOn 0 (Most left) disables this function." };
	GUPPET_L["AUTOCALLCOMPANION_RESUMMONCITYONLY"] = {"Recall in City/Inn only",""};
	GUPPET_L["AUTOCALLCOMPANION_PETOFTHEDAY"] = {"Enable 'Pet of the day'", "Keeps summoning the same companion the entire day. (You can overrule it by pressing the ingame button) "} ;	
		
	GUPPET_L["SLASHCOMMANDS"]		= { "Slashcommands" , "" };
	GUPPET_L["EXTRA"]				= { "Extra" , "" };
	GUPPET_L["CLASS"]				= { "Class" , "" };
	GUPPET_L["AUTODISMOUNT"]		= { "Auto dismount" , "Automatically dismount when you receive the 'You are mounted' error if you are not flying" };
	GUPPET_L["INGAMEBUTTONS"]		= { "Ingame Buttons" , "" };
	
	GUPPET_L["PREVIEWFRAME"] 		= { "Preview Screen" , "" };
	GUPPET_L["PREVIEWFRAMESPEED"] 	= { "Rotate speed" , "-1", "1" };
	GUPPET_L["PREVIEWFRAMESTARTPOS"] = { "Start position" , "-180" , "180"};
	
	GUPPET_L["MINIMAPBUTTONFRAME"] = { "Minimap Button"};
	
	GUPPET_L["DRUID_Fly"]		= { "Use Fly form" , "" };
	GUPPET_L["DRUID_Aquatic"]	= { "Use Aquatic form" , "" };
	GUPPET_L["DRUID_Travel"]	= { "Use Travel form while moving" , "" };
	GUPPET_L["DRUID_Cat"]		= { "Use Cat form while indoors" , "" };
	GUPPET_L["CLASSFRAME_DRUID_Inconsistent"] = "Instant form leaving and mounting";
	
	GUPPET_L["SHAMAN_Ghost"]	= { "Use GhostWolf while moving" , "" };
	GUPPET_L["SHAMAN_WaterWalking"]	= { "Use WaterWalking if swimming" , "" };
	
	GUPPET_L["MAGE_SlowFall"] 	= { "Use SlowFall if falling" , ""}
	
	GUPPET_L["DEATHKNIGHT_PathOfFrost"] 	= { "Use Path of Frost if swimming" , ""}
	 
	
	GUPPET_L["INTERFACE_REMOVE"] = { "Are you sure you want to remove %s" , "Yes", "No" };
	GUPPET_L["INTERFACE_CHANGEMODE"] = { "This action requers a reload. Continue ?" , "Yes", "No" };
	
	GUPPET_L["INGAMEBUTTONS_AUTO"]		= { "Auto Select" , " +Shift to force a ground type |n +Ctrl for a multi type" , " +Alt to use TravelFrom / GhostWolf" };
	GUPPET_L["INGAMEBUTTONS_GROUND"]	= { "Auto Ground" , "" };
	GUPPET_L["INGAMEBUTTONS_FLY"]		= { "Auto Fly" , "" };
	GUPPET_L["INGAMEBUTTONS_COMPANION"]	= { "Random Companion" , " +Shift to dismiss" };
	
	GUPPET_L["INGAMEBUTTONS_MOVE"] 		= { "Move Buttons" , "Right Click to lock"};
	
	-- Texts for in chat
	GUPPET_T["UNKNOWNMOUNTFOUND"] = "An unknown mount has been found.  Please report this so that it can be added to future versions."	;
	GUPPET_T["NEWVERSIONFOUND"] = "A NEW version has been found. The new version is v." ;
	GUPPET_T["CANTCALLCOMPANION"] = "No companion can be called ( None Enabled )" ;
	GUPPET_T["CANTCALLCOMPANIONNOSNOWBALL"] = "No companion can be called. All enabled use snowballs and you have none with you." ;
	GUPPET_T["CANTCALLCOMPANIONONEINTHETABLE"] = "Only one companion is in the random rotation and is already out.";
	
	GUPPET_T["CANTCALLGROUNDMOUNT"] = "No ground mount can be called ( None Enabled )" ;
	GUPPET_T["CANTCALLFLYMOUNT"] = "No fly mount can be called ( None Enabled )" ;
	GUPPET_T["CANTCALLAQUATICMOUNT"] = "No aquatic mount can be called ( None Enabled )" ;
	GUPPET_T["DEBUGMODEON"] = "Debug mode ON";
	GUPPET_T["DEBUGMODEOFF"] = "Debug mode OFF";
	GUPPET_T["LOADED"] = "Loaded";
	GUPPET_T["NOTSUPPORTED"] = "|cffee4400 Your language is not yet implemented. So the autodetection is disabled. ";
	GUPPET_T["UNKNOWNSLASHCOMMAND"] = "|cffee4400 The slashcommand you entered is not correct.";
	
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"] = {};

	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][1] = "|cffee4400".. GUPPET_S["AUTOMOUNT"][2] .."|r -> ".. GUPPET_S["AUTOMOUNT"][3]  ;
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][2] = "|cffee4400".. GUPPET_S["AQUATICMOUNT"][2] .."|r -> ".. GUPPET_S["AQUATICMOUNT"][3] ;
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][3] = "|cffee4400".. GUPPET_S["AUTOGROUNDMOUNT"][2] .."|r -> ".. GUPPET_S["AUTOGROUNDMOUNT"][3]  ;
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][4] = "|cffee4400".. GUPPET_S["AUTOFLYMOUNT"][2] .."|r -> ".. GUPPET_S["AUTOFLYMOUNT"][3]  ;
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][5] = "|cffee4400".. GUPPET_S["MULTIGROUNDMOUNT"][2] .."|r -> ".. GUPPET_S["MULTIGROUNDMOUNT"][3]  ;
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][6] = "|cffee4400".. GUPPET_S["CALLCOMPANION"][2] .."|r -> ".. GUPPET_S["CALLCOMPANION"][3]  ;
	GUPPET_T["UNKNOWNSLASHCOMMAND_COMMANDS"][7] = "|cffee4400".. GUPPET_S["OPTIONMENU"][2] .."|r -> ".. GUPPET_S["OPTIONMENU"][3]  ;
	
	
	
	-- Categories
	GUPPET_C["GLOBALWORLD"]	=	"Global World" ;
	GUPPET_C["CITIES"]		=	"Cities" ;
	GUPPET_C["INSTANCES"]	=	"Instances" ;
	GUPPET_C["ARENAS"]		=	"Arenas" ;
	GUPPET_C["BATTLEGROUNDS"]	=	"BattleGrounds" ;
	
	-- Zones ( For autodetection system )
	GUPPET_Z["SUPPORT"] = true ;
	GUPPET_Z["WINTERGRASP"] = "Wintergrasp";
	GUPPET_Z["CRYSTALSONGFOREST"] = "Crystalsong Forest";
	GUPPET_Z["DALARAN"] = "Dalaran";
	GUPPET_Z["SUB_THEUNDERBELLY"] = "The Underbelly";
	GUPPET_Z["SUB_KRASUSLANDING"] = "Krasus' Landing";
	GUPPET_Z["SUB_THEVIOLETCITADEL"] = "The Violet Citadel";
	GUPPET_Z["SUB_CANTRIPSCROWS"] = "Cantrips & Crows";
	GUPPET_Z["SUB_THEPURPLEPARLOR"] = "The Purple Parlor";
	
-------------------------------------------------------------------------------
-- French localization by "Morwen from Kirin Tor" 
-------------------------------------------------------------------------------
if (GetLocale() == "frFR") then
	
	
	-- For the key bind interface
	BINDING_HEADER_GUPPET = "GupPet";
	BINDING_NAME_GUPPET_AUTO = "Sélection automatique";
	BINDING_NAME_GUPPET_AUTOFLY = "Sélect. auto. de vol";
	BINDING_NAME_GUPPET_AUTOGROUND = "Sélect. auto. terrestre";
	BINDING_NAME_GUPPET_SLOWGROUNDMOUNT = "Montures terrestres normales";
	BINDING_NAME_GUPPET_FASTGROUNDMOUNT = "Montures terrestres rapides";
	BINDING_NAME_GUPPET_SLOWFLYMOUNT = "Montures volantes normales";
	BINDING_NAME_GUPPET_FASTFLYMOUNT = "Montures volantes rapides";
	BINDING_NAME_GUPPET_CALLCOMPANION = "Invoquer une mascotte";
	BINDING_NAME_GUPPET_AQUATICMOUNT = "Montures aquatiques";


	-- Slash Commands
	GUPPET_S["SLASH"] = "La commande de lancement est « /GP » ou « /GupPet » (les commandes « / » de GupPet ne comprennent pas les capacités de changement de forme)." ;
	GUPPET_S["USE"] = " ou " ;
	GUPPET_S["SLOWGROUNDMOUNT"] = { "sgm" , "slowgroundmount"	, "Invoque une monture terrestre normale aléatoire" } ;
	GUPPET_S["FASTGROUNDMOUNT"] = { "fgm" , "fastgroundmount"	, "Invoque une monture terrestre rapide aléatoire" } ;
	GUPPET_S["SLOWFLYMOUNT"] 	= { "sfm" , "slowflymount" 		, "Invoque une monture volante normale aléatoire" } ;
	GUPPET_S["FASTFLYMOUNT"] 	= { "ffm" , "fastflymount" 		, "Invoque une monture volante rapide aléatoire" } ;
	GUPPET_S["AQUATICMOUNT"]	= { "aqm" , "aquaticmount" 		, "Invoque une monture aquatique aléatoire" } ;  
	GUPPET_S["AUTOMOUNT"] 		= { "am"  , "automount" 		, "Invoque une monture aléatoire, volante si votre zone le permet" } ;
	GUPPET_S["AUTOGROUNDMOUNT"] = { "agm" , "autogroundmount" 	, "Invoque une monture terrestre aléatoire" } ;
	GUPPET_S["AUTOFLYMOUNT"]	= { "afm" , "autoflymount" 		, "Invoque une monture volante aléatoire" } ;
	GUPPET_S["CALLCOMPANION"] 	= { "cc"  , "callcompanion" 	, "Invoque une mascotte aléatoire" } ;
	GUPPET_S["DEBUG"] 			= { "debug" , "debug" , "Fonction de résolution de problèmes" } ;
	GUPPET_S["OPTIONMENU"] 		= { "om"  , "optionmenu" 		, "Raccourci pour afficher le menu d'options" } ;
	GUPPET_S["TOGGLEINCONSIS"]	= { "ti"  , "toggleinconsistent" , "" } ;
	
	
	-- Other
	GUPPET_L["OPTIONS"]	= "Options";
	GUPPET_L["MOUNTSCOMPANIONS"]	= "Montures + mascottes";
	GUPPET_L["CLOSE"]	= "Fermer";
	GUPPET_L["HELP"]	= "Aide";

	GUPPET_L["ADD"]				= { "Ajouter" , "Ajoute votre zone actuelle au menu" };
	GUPPET_L["REMOVE"]			= { "Supprimer" , "Supprime votre zone actuelle du menu" };
	GUPPET_L["ALLAQUATICMOUNT"]	= { "Aquatiques" , "" };
	GUPPET_L["ALLGROUNDMOUNT"]	= { "Terrestres" , "" };
	GUPPET_L["ALLFLYMOUNT"]		= { "Volantes" , "" };
	GUPPET_L["ALLCOMPANION"]	= { "Mascottes" , "" };
	
	 
	GUPPET_L["ENABLE"]		= { "Tout" , "" };
	GUPPET_L["DISABLE"]		= { "Aucune" , "" };
	GUPPET_L["SHOW"]		= { "Affiché" , "" };
	GUPPET_L["LOCKED"]		= { "Verrouillé" , "" };
	GUPPET_L["SCALE"]		= { "Échelle" , "Petite", "Grande" };
	GUPPET_L["COMPANIONBUTTONSHOW"]		= { "Afficher le bouton des mascottes" , "" };
	GUPPET_L["RESTORE"]		= { "Réinitialiser" , "Réinitialiser la position par défaut des boutons d'action au centre de l'écran" };
		
	GUPPET_L["BUTTONMODE"]	= { "Monture volante par défaut" , "Affiche un seul bouton de monture qui choisit automatiquement le type de monture selon votre zone.", "If you are seeing this message your client language is not supported" };
	GUPPET_L["EXPERTMODE"]	= { "Mode expert" , "Basculer en mode expert afin d'accéder à des options avancées de personnalisation de vos mascottes" };
	GUPPET_L["BUTTONALIGNMENT"]	= { "Alignement horizontal" , "Affiche les boutons de façon horizontale ou verticale" };
	
	
	GUPPET_L["AQUATICMOUNT"]	= { "" , "" };
	GUPPET_L["SLOWGROUNDMOUNT"]	= { "Normales" , "(60%)" };
	GUPPET_L["FASTGROUNDMOUNT"]	= { "Rapides" , "(100%)" };
	GUPPET_L["SLOWFLYMOUNT"]	= { "Normales" , "(150%)" };
	GUPPET_L["FASTFLYMOUNT"]	= { "Rapides" , "(280% + 310%)" };
	GUPPET_L["COMPANION"]		= { "" , "" };
	
	GUPPET_L["AUTOCALLCOMPANION"]	= "Mascottes" ;
	GUPPET_L["AUTOCALLCOMPANION_ENABLE"] 	= { "Invocation automatique" , "" };
	GUPPET_L["AUTOCALLCOMPANION_CITY"] 	= { "Capitale" , "" };
	GUPPET_L["AUTOCALLCOMPANION_OUTSIDE"] = { "Plein air" , "" };
	GUPPET_L["AUTOCALLCOMPANION_ARENA"] 	= { "Arène" , "" };
	GUPPET_L["AUTOCALLCOMPANION_PARTY"] = { "Groupe" , "" };
	GUPPET_L["AUTOCALLCOMPANION_RAID"] = { "Raid" , "" };
	GUPPET_L["AUTOCALLCOMPANION_BATTLEGROUND"] = { "Champ de bataille" , "" };
	GUPPET_L["AUTOCALLCOMPANION_DELAY"] 	= { "Délai" , "La durée en seconde du temps d'attente avant invocation, de 2 à 10 s." };
	GUPPET_L["AUTOCALLCOMPANION_AUTODISMISSMOUNTED"] 	= { "Renvoi en monture" , "Votre mascotte sera renvoyée quand vous chevaucherez une monture." };
	GUPPET_L["AUTOCALLCOMPANION_RESUMMON"] 	= { "Délai avant rappel" , "Le délai d'attente en secondes avant le rappel automatique d'une mascotte lorsque vous êtes en ville.|nPour désactiver cette fonction, réglez le curseur sur 0 (tout à gauche)." };
	GUPPET_L["AUTOCALLCOMPANION_RESUMMONCITYONLY"] = {"Rappel uniquement dans |n les capitales et les auberges",""};

	GUPPET_L["SLASHCOMMANDS"]		= { "Commandes /" , "" };
	GUPPET_L["EXTRA"]				= { "Divers" , "" };
	GUPPET_L["CLASS"]				= { "Classe" , "" };
	GUPPET_L["AUTODISMOUNT"]		= { "Renvoi de monture auto." , "Vous désarçonne automatiquement en cas d'erreur « Vous êtes sur une monture », si vous n'êtes pas en vol." };
	GUPPET_L["INGAMEBUTTONS"]		= { "Boutons de l'interface" , "" };
	
	GUPPET_L["PREVIEWFRAME"] 		= { "Écran d'aperçu" , "" };
	GUPPET_L["PREVIEWFRAMESPEED"] 	= { "Vitesse de rotation" , "-1", "1" };
	GUPPET_L["PREVIEWFRAMESTARTPOS"] = { "Position de départ" , "-180" , "180"};
	
	GUPPET_L["MINIMAPBUTTONFRAME"] = { "Bouton sur la mini-carte"};

	GUPPET_L["DRUID_Fly"]		= { "Forme de vol" , "" };
	GUPPET_L["DRUID_Aquatic"]	= { "Forme aquatique" , "" };
	GUPPET_L["DRUID_Travel"]	= { "Forme de vol en se déplaçant" , "" };
	GUPPET_L["DRUID_Cat"]		= { "Forme de félin en intérieur" , "" };
	
	GUPPET_L["SHAMAN_Ghost"]	= { "Forme de loup-fantôme auto." , "" };
	GUPPET_L["SHAMAN_WaterWalking"]	= { "Lancer Marche sur l'eau si vous nagez" , "" };
	
	GUPPET_L["MAGE_SlowFall"] 	= { "Chute lente automatique" , ""}
	
	GUPPET_L["DEATHKNIGHT_PathOfFrost"] 	= { "Lancer Passage de givre si vous nagez" , ""}
	 
	GUPPET_L["INTERFACE_REMOVE"] = { "Êtes-vous certain de vouloir supprimer %s" , "Oui", "Non" };
	GUPPET_L["INTERFACE_CHANGEMODE"] = { "Cette action requiert un redémarrage. Continuer ?" , "Oui", "Non" };
	
	GUPPET_L["INGAMEBUTTONS_AUTO"]		= { "Sélection auto." , " +Maj pour invoquer une monture terrestre" , " +Alt pour passer en forme de voyage / loup fantôme" };
	GUPPET_L["INGAMEBUTTONS_GROUND"]	= { "Terrestre automatique" , "" };
	GUPPET_L["INGAMEBUTTONS_FLY"]		= { "Vol automatique" , "" };
	GUPPET_L["INGAMEBUTTONS_COMPANION"]	= { "Mascotte aléatoire" , " +Maj pour renvoyer" };
	
	
	-- Texts for in chat
	GUPPET_T["UNKNOWNMOUNTFOUND"] = "Une monture inconnue a été trouvée. Veuillez nous en faire part pour que nous puissions l'inclure à la prochaine version de l'add-on."	;
	GUPPET_T["NEWVERSIONFOUND"] = "Une nouvelle version a été détectée. Il s'agit de la version v." ;
	GUPPET_T["CANTCALLCOMPANION"] = "Aucune mascotte ne peut être invoquée (toutes sont désactivées)" ;
	GUPPET_T["CANTCALLCOMPANIONNOSNOWBALL"] = "Aucune mascotte ne peut être invoquée. Les seules activées nécessitent une boule de neige, et vous n'en avez aucune dans votre inventaire" ;
	GUPPET_T["CANTCALLGROUNDMOUNT"] = "Aucune monture ne peut être invoquée (toutes sont désactivées)" ;
	GUPPET_T["CANTCALLFLYMOUNT"] = "Aucune monture volante ne peut être invoquée (toutes sont désactivées)" ;
	GUPPET_T["CANTCALLAQUATICMOUNT"] = "Aucune monture aquatique ne peut être invoquée (toutes sont désactivées)" ;
	GUPPET_T["DEBUGMODEON"] = "Mode de débug ON";
	GUPPET_T["DEBUGMODEOFF"] = "Mode de débug OFF";
	GUPPET_T["LOADED"] = "Chargé";
	GUPPET_T["NOTSUPPORTED"] = "|cffee4400 Votre langue n'est pas encore implémentée. La détection automatique a été désactivée. ";
	GUPPET_T["UNKNOWNSLASHCOMMAND"] = "|cffee4400 La commande « / » saisie n'existe pas. Consultez les commandes existantes dans menu d'options. |r ( /GupPet om )";

	
	-- Categories
	GUPPET_C["GLOBALWORLD"] = "Zones du jeu";
	GUPPET_C["CITIES"]	= "Capitales";
	GUPPET_C["INSTANCES"] = "Donjons";
	GUPPET_C["ARENAS"] = "Arènes";
	GUPPET_C["BATTLEGROUNDS"] = "Champs de bataille";
	
	-- Zones ( For autodetection system )
	GUPPET_Z["SUPPORT"] = true ;
	GUPPET_Z["WINTERGRASP"] = "Joug-d'hiver";
	GUPPET_Z["CRYSTALSONGFOREST"] = "Forêt du Chant de cristal";
	GUPPET_Z["DALARAN"] = "Dalaran";
	GUPPET_Z["SUB_THEUNDERBELLY"] = "Les Entrailles";
	GUPPET_Z["SUB_KRASUSLANDING"] = "Aire de Krasus";
	GUPPET_Z["SUB_THEVIOLETCITADEL"] = "La citadelle Pourpre";
	GUPPET_Z["SUB_CANTRIPSCROWS"] = "Caboulot des corbeaux"; 
	GUPPET_Z["SUB_THEPURPLEPARLOR"] = "Le salon Violet";

end

-------------------------------------------------------------------------------
-- German localization
-------------------------------------------------------------------------------
if (GetLocale() == "deDE") then
	
	-- Zones ( For autodetection system )
	GUPPET_Z["SUPPORT"] = true ;
	GUPPET_Z["WINTERGRASP"] = "Tausendwintersee";
	GUPPET_Z["CRYSTALSONGFOREST"] = "Kristallsangwald";
	GUPPET_Z["DALARAN"] = "Dalaran";
	GUPPET_Z["SUB_THEUNDERBELLY"] = "Die Schattenseite";
	GUPPET_Z["SUB_KRASUSLANDING"] = "Krasus' Landeplatz";
	GUPPET_Z["SUB_THEVIOLETCITADEL"] = "Die Violette Zitadelle";
	GUPPET_Z["SUB_CANTRIPSCROWS"] = "Zur Zauberkrähe";
	GUPPET_Z["SUB_THEPURPLEPARLOR"] = "Der Purpursalon";
end

-------------------------------------------------------------------------------
-- Spanish (Spain) localization
-------------------------------------------------------------------------------

if (GetLocale() == "esES") then	

	-- Zones ( For autodetection system )
	GUPPET_Z["SUPPORT"] = true ;
	GUPPET_Z["WINTERGRASP"] = "Conquista del Invierno";
	GUPPET_Z["CRYSTALSONGFOREST"] = "Bosque Canto de Cristal";
	GUPPET_Z["DALARAN"] = "Dalaran";
	GUPPET_Z["SUB_THEUNDERBELLY"] = "Los Bajos Fondos";
	GUPPET_Z["SUB_KRASUSLANDING"] = "Alto de Krasus";
	GUPPET_Z["SUB_THEVIOLETCITADEL"] = "La Ciudadela Violeta";
	GUPPET_Z["SUB_CANTRIPSCROWS"] = "Taberna de los Cuervos";
	GUPPET_Z["SUB_THEPURPLEPARLOR"] = "El Salón Púrpura";
end

-------------------------------------------------------------------------------
-- Spanish (Mexico) localization
-------------------------------------------------------------------------------

if (GetLocale() == "esMX") then
	
	GUPPET_Z["SUPPORT"] = false;
end

-------------------------------------------------------------------------------
-- Russian localization
-------------------------------------------------------------------------------

if (GetLocale() == "ruRU") then
 
	-- For the key bind interface
	BINDING_HEADER_GUPPET = "GupPet";
	BINDING_NAME_GUPPET_AUTO = "Авто выбор";
	BINDING_NAME_GUPPET_AUTOFLY = "Авто выбор летающего";
	BINDING_NAME_GUPPET_AUTOGROUND = "Авто выбор наземного";
	BINDING_NAME_GUPPET_SLOWGROUNDMOUNT = "Медленный-наземный";
	BINDING_NAME_GUPPET_FASTGROUNDMOUNT = "Быстрый-наземный";
	BINDING_NAME_GUPPET_MULTIGROUNDMOUNT = "Multi ground mount";
	BINDING_NAME_GUPPET_SLOWFLYMOUNT = "Медленный-летающий";
	BINDING_NAME_GUPPET_FASTFLYMOUNT = "Быстрый-летающий";
	BINDING_NAME_GUPPET_CALLCOMPANION = "Вызвать спутника";
	BINDING_NAME_GUPPET_AQUATICMOUNT = "Водный";

	-- Slash Commands
	GUPPET_S["SLASH"] = "Начальная команда '/GP' или '/GupPet'" ;
	GUPPET_S["USE"] = " или " ;
	GUPPET_S["SLOWGROUNDMOUNT"] = { "sgm" , "slowgroundmount"	, "выбирает случайный медленный-наземный транспорт" } ;
	GUPPET_S["FASTGROUNDMOUNT"] = { "fgm" , "fastgroundmount"	, "выбирает случайный быстрый-наземный транспорт" } ;
	GUPPET_S["MULTIGROUNDMOUNT"] = { "mgm" , "multigroundmount"	, "Selects random a multi ground mount" } ;
	GUPPET_S["SLOWFLYMOUNT"] 	= { "sfm" , "slowflymount" 		, "выбирает случайный медленный-летающий транспорт" } ;
	GUPPET_S["FASTFLYMOUNT"] 	= { "ffm" , "fastflymount" 		, "выбирает случайный быстрый-летающий транспорт" } ;
	GUPPET_S["AQUATICMOUNT"]	= { "aqm" , "aquaticmount" 		, "выбирает случайный водяной транспорт/форму" } ;  
	GUPPET_S["AUTOMOUNT"] 		= { "am"  , "automount" 		, "автоматически выбирает случайный транспорт в зависимости от локации и возможности летать" } ;
	GUPPET_S["AUTOGROUNDMOUNT"] = { "agm" , "autogroundmount" 	, "выбирает случайный наземный транспорт" } ;
	GUPPET_S["AUTOFLYMOUNT"]	= { "afm" , "autoflymount" 		, "выбирает случайный летающий транспорт" } ;
	GUPPET_S["CALLCOMPANION"] 	= { "cc"  , "callcompanion" 	, "выбирает случайного спутника" } ;
	GUPPET_S["DEBUG"] 			= { "debug" , "debug" , "" } ;
	GUPPET_S["OPTIONMENU"] 		= { "om"  , "optionmenu" 		, "ярлык в меню настроек" } ;
	GUPPET_S["TOGGLEINCONSIS"]	= { "ti"  , "toggleinconsistent" , "" } ;
	
	
	
	-- Other
	GUPPET_L["OPTIONS"]	= "Настройки";
	GUPPET_L["MOUNTSCOMPANIONS"]	= "Транспорт + Спутники";
	GUPPET_L["CLOSE"]	= "Закрыть";
	GUPPET_L["HELP"]	= "Справка";
		
	GUPPET_L["ADD"]				= { "Добавить" , "Добавить текущую локацию" };
	GUPPET_L["REMOVE"]			= { "Удалить" , "Удалить выбранную локацию" };
	GUPPET_L["ALLAQUATICMOUNT"]	= { "Водный" , "" };
	GUPPET_L["ALLGROUNDMOUNT"]	= { "Наземный" , "" };
	GUPPET_L["ALLFLYMOUNT"]		= { "Летающий" , "" };
	GUPPET_L["ALLCOMPANION"]	= { "Спутник" , "" };
		
	GUPPET_L["ENABLE"]		= { "Включить" , "" };
	GUPPET_L["DISABLE"]		= { "Отключить" , "" };
	GUPPET_L["SHOW"]		= { "Показать" , "" };
	GUPPET_L["LOCKED"]		= { "Фиксировать" , "" };
	GUPPET_L["SCALE"]		= { "Масштаб" , "Маленький", "Большой" };
	GUPPET_L["COMPANIONBUTTONSHOW"]		= { "Показать кнопку спутника" , "" };
	GUPPET_L["RESTORE"]		= { "Возврат" , "Восстановить позицию кнопок действия на стандартную, по центру экрана" };
	GUPPET_L["ICON"]		= { "Иконка" , "Показать меню, чтобы изменить внешний вид кнопок"};
	--
	GUPPET_L["BUTTONMODE"]	= { "Авто кнопри транспорта" , "Изменяет число кнопок от одной до двух", "Если вы видите это сообщение, язык вашего клиента не поддерживается" };
	GUPPET_L["EXPERTMODE"]	= { "Режим мастера" , "Переход в режим для опытного пользователя, где можно изменить приоритеты ваших случайных спутников/транспорта" };
	GUPPET_L["BUTTONALIGNMENT"]	= { "Выравнивание" , "Переключение выравнивания кнопок с горизонтального на вертикальный" };
		GUPPET_L["HIDEKEYBINDTEXT"] = { "Скрыть назначения" , "Если отмечено, скрывает текст назначения клавиш на кнопках"  };
	
	GUPPET_L["AQUATICMOUNT"]	= { "" , "" };
	GUPPET_L["SLOWGROUNDMOUNT"]	= { "Медленные" , "(60%)" };
	GUPPET_L["FASTGROUNDMOUNT"]	= { "Быстрые" , "(100%)" };
	GUPPET_L["MULTIGROUNDMOUNT"]= { "Multi" , "" };
	GUPPET_L["SLOWFLYMOUNT"]	= { "Медленные" , "(150%)" };
	GUPPET_L["FASTFLYMOUNT"]	= { "Быстрые" , "(280% + 310%)" };
	GUPPET_L["COMPANION"]		= { "" , "" };
	
	GUPPET_L["AUTOCALLCOMPANION"]	= "Спутник" ;
	GUPPET_L["AUTOCALLCOMPANION_ENABLE"] 	= { "Включить авто вызов спутника" , "" };
	GUPPET_L["AUTOCALLCOMPANION_CITY"] 	= { "В городе" , "" };
	GUPPET_L["AUTOCALLCOMPANION_OUTSIDE"] = { "Внешний мир" , "" };
	GUPPET_L["AUTOCALLCOMPANION_ARENA"] 	= { "На арене" , "" };
	GUPPET_L["AUTOCALLCOMPANION_PARTY"] = { "В группе" , "" };
	GUPPET_L["AUTOCALLCOMPANION_RAID"] = { "В рейде" , "" };
	GUPPET_L["AUTOCALLCOMPANION_BATTLEGROUND"] = { "На поле боя" , "" };
	GUPPET_L["AUTOCALLCOMPANION_DELAY"] 	= { "Задержка" , "Задержка в секундах до авто вызова от 2 до 10 сек" };
	GUPPET_L["AUTOCALLCOMPANION_AUTODISMISSMOUNTED"] 	= { "Отпустить когда на транспорте" , "" };
	GUPPET_L["AUTOCALLCOMPANION_RESUMMON"] 	= { "Задержка вызова" , "Время (в секундах) задержки повторного авто вызова спутника когда вы находитесь в городе.|nOn 0 отключает функцию." };
	GUPPET_L["AUTOCALLCOMPANION_RESUMMONCITYONLY"] = {"Вызов только в городе/таверне",""};	
	
	GUPPET_L["SLASHCOMMANDS"]		= { "Слэш команды" , "" };
	GUPPET_L["EXTRA"]				= { "Дополнительно" , "" };
	GUPPET_L["CLASS"]				= { "Класс" , "" };
	GUPPET_L["AUTODISMOUNT"]		= { "Авто спешивание" , "Автоматическое спешивание когда вы получаете ошибку 'Вы находитесь на средстве передвижения' если вы не летите" };
	GUPPET_L["INGAMEBUTTONS"]		= { "Игровые кнопки" , "" };
	
	GUPPET_L["PREVIEWFRAME"] 		= { "Экран предпросмотра" , "" };
	GUPPET_L["PREVIEWFRAMESPEED"] 	= { "Скорость вращения" , "-1", "1" };
	GUPPET_L["PREVIEWFRAMESTARTPOS"] = { "Начальная позиция" , "-180" , "180"};
	
	GUPPET_L["MINIMAPBUTTONFRAME"] = { "Кнопку у мини-карты"};
	
	GUPPET_L["DRUID_Fly"]		= { "Исп летающую форму" , "" };
	GUPPET_L["DRUID_Aquatic"]	= { "Исп водный облик" , "" };
	GUPPET_L["DRUID_Travel"]	= { "Исп Походный облик при движении" , "" };
	GUPPET_L["DRUID_Cat"]		= { "Исп Облик кошки в помещениях" , "" };
	
	GUPPET_L["SHAMAN_Ghost"]	= { "Использовать облик\nПризрачного волка\nпри перемещении" , "" };
	GUPPET_L["SHAMAN_WaterWalking"]	= { "Исп Хождение по воде во время плавания" , "" };
	
	GUPPET_L["MAGE_SlowFall"] 	= { "Исп Замедленное падение при падении" , ""}
	
	GUPPET_L["DEATHKNIGHT_PathOfFrost"] 	= { "Исп Льдистый путь во время плавания" , ""}
	
	
	GUPPET_L["INTERFACE_REMOVE"] = { "Вы уверены что хатите удалить %s" , "Да", "Нет" };
	GUPPET_L["INTERFACE_CHANGEMODE"] = { "Ваши действия требуют перезагрузки. Продолжить ?" , "Да", "Нет" };
	
	GUPPET_L["INGAMEBUTTONS_AUTO"]		= { "Авто выбор" , " +Shift сесть на наземный транспорт" , " +Alt использовать Походный облик / Призрачный волк" };
	GUPPET_L["INGAMEBUTTONS_GROUND"]	= { "Авто наземный" , "" };
	GUPPET_L["INGAMEBUTTONS_FLY"]		= { "Авто летающий" , "" };
	GUPPET_L["INGAMEBUTTONS_COMPANION"]	= { "Случайный спутник" , " +Shift отпустить" };
	
	GUPPET_L["INGAMEBUTTONS_MOVE"] 		= { "Двигать кнопки" , "Правый клик - фиксирует их"};
	
	-- Texts for in chat
	GUPPET_T["UNKNOWNMOUNTFOUND"] = "Обнаружен неизвестный транспорт.  Пожалуйста, сообщите об этом, возможно он добавиться в будущих версиях."	;
	GUPPET_T["NEWVERSIONFOUND"] = "Найдена новая версия. Новая версия - v." ;
	GUPPET_T["CANTCALLCOMPANION"] = "Невозможно вызвать спутника ( нету включенных )" ;
	GUPPET_T["CANTCALLCOMPANIONNOSNOWBALL"] = "Невозможно вызвать спутника. Все включенне используют снежки, и у вас их нет с собою" ;
	GUPPET_T["CANTCALLGROUNDMOUNT"] = "Невозможно вызвать наземный траспорт ( нету включенных )" ;
	GUPPET_T["CANTCALLFLYMOUNT"] = "Невозможно вызвать летучий траспорт ( нету включенных )" ;
	GUPPET_T["CANTCALLAQUATICMOUNT"] = "Невозможно вызвать водный траспорт ( нету включенных )" ;
	GUPPET_T["DEBUGMODEON"] = "Режим отладки ВКЛ";
	GUPPET_T["DEBUGMODEOFF"] = "Режим отладки ВЫКЛ";
	GUPPET_T["LOADED"] = "Загружен";
	GUPPET_T["NOTSUPPORTED"] = "|cffee4400 Ваш язык пока еще не реализован. Поэтому авто-определение отключено. ";
	GUPPET_T["UNKNOWNSLASHCOMMAND"] = "|cffee4400 Слэш команду которую вы ввели не существует. Проверьте меню настроек на наличие доступных команд.";
	
	-- Categories
	GUPPET_C["GLOBALWORLD"]	=	"Мир" ;
	GUPPET_C["CITIES"]		=	"Города" ;
	GUPPET_C["INSTANCES"]	=	"Подземелья" ;
	GUPPET_C["ARENAS"]		=	"Арены" ;
	GUPPET_C["BATTLEGROUNDS"]	=	"Поля сражений" ;

	-- Zones ( For autodetection system )
	GUPPET_Z["SUPPORT"] = true ;
	GUPPET_Z["WINTERGRASP"] = "Озеро Ледяных Оков";
	GUPPET_Z["CRYSTALSONGFOREST"] = "Лес Хрустальной Песни";
	GUPPET_Z["DALARAN"] = "Даларан";
	GUPPET_Z["SUB_THEUNDERBELLY"] = "Клоака";
	GUPPET_Z["SUB_KRASUSLANDING"] = "Площадка Краса";
	GUPPET_Z["SUB_THEVIOLETCITADEL"] = "Аметистовая цитадель";
	GUPPET_Z["SUB_CANTRIPSCROWS"] = "Ведьма и Ворон";
	GUPPET_Z["SUB_THEPURPLEPARLOR"] = "Лиловая гостиная";
end

-------------------------------------------------------------------------------
-- Korean localization
-------------------------------------------------------------------------------
if (GetLocale() == "koKR") then

	GUPPET_Z["SUPPORT"] = false ;
end

-------------------------------------------------------------------------------
-- Chinese (simplified) localization
-------------------------------------------------------------------------------
if (GetLocale() == "zhCN") then
	
	GUPPET_Z["SUPPORT"] = false ;
end

-------------------------------------------------------------------------------
-- Chinese (traditional) localization
-------------------------------------------------------------------------------
if (GetLocale() == "zhTW") then

	GUPPET_Z["SUPPORT"] = false ;
end





-------------------------------------------------------------------------------
-- Localization undipendet --- DO NOT CHANGE ----
-------------------------------------------------------------------------------
	-- Categories
	GUPPET_C["M_GLOBALWORLD"]	=	"Global World" ;
	GUPPET_C["M_CITIES"]		=	"Cities" ;
	GUPPET_C["M_INSTANCES"]		=	"Instances" ;
	GUPPET_C["M_ARENAS"]		=	"Arenas" ;
	GUPPET_C["M_BATTLEGROUNDS"]	=	"BattleGrounds" ;

