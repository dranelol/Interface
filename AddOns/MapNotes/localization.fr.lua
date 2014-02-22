--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.

    Special thanks to Vjeux for the French translation

--]]

-- À: C3 80
-- à: C3 A0
-- â: C3 A2
-- ç: C3 A7
-- è: C3 A8
-- é: C3 A9
-- ê: C3 AA
-- ë: C3 AB
-- î: C3 AE
-- ô: C3 B4
-- û: C3 BB
-- ': E2 80 99

if GetLocale() == "frFR" then

  -- General
  MAPNOTES_ADDON_DESCRIPTION = "Ajoute un système de note au WorldMap."
  MAPNOTES_DOWNLOAD_SITES = "Voir le dossier de README"

  -- Interface Configuration
  MAPNOTES_WORLDMAP_HELP_1 = "Bon Clic Sur La Carte À bourdonner Dehors"
  MAPNOTES_WORLDMAP_HELP_2 = "Clic Gauche Sur La Carte À bourdonner Dedans"
  MAPNOTES_WORLDMAP_HELP_3 = "<Commande>+Bon Clic Sur La Carte Pour ouvrir Le Menu De Notes De Carte"
  MAPNOTES_CLICK_ON_SECOND_NOTE = "|cFFFF0000MapNotes:|r Choisissez une Note pour tracer/effacer une ligne"

  MAPNOTES_NEW_MENU = "Notes De Carte"
  MAPNOTES_NEW_NOTE = "Créer une Note"
  MAPNOTES_MININOTE_OFF = "Désactiver MiniNotes"
  MAPNOTES_OPTIONS = "Options"
  MAPNOTES_CANCEL = "Annuler"

  MAPNOTES_POI_MENU = "Notes De Carte"
  MAPNOTES_EDIT_NOTE = "Modifier Note"
  MAPNOTES_MININOTE_ON = "Utiliser comme MiniNote"
  MAPNOTES_SPECIAL_ACTIONS = "Actions spéciales"
  MAPNOTES_SEND_NOTE = "Envoyer Note"

  MAPNOTES_SPECIALACTION_MENU = "Actions spéciales"
  MAPNOTES_TOGGLELINE = "Créer/Supprimer la ligne"
  MAPNOTES_DELETE_NOTE = "Supprimer la Note"

  MAPNOTES_EDIT_MENU = "Modifier une Note"
  MAPNOTES_SAVE_NOTE = "Sauvegarder"
  MAPNOTES_EDIT_TITLE = "Titre (requis):"
  MAPNOTES_EDIT_INFO1 = "Ligne D'Information 1 (optionel):"
  MAPNOTES_EDIT_INFO2 = "Ligne D'Information 2 (optionel):"
  MAPNOTES_EDIT_CREATOR = "Créateur (optionel):"

  MAPNOTES_SEND_MENU = "Envoyer Note"
  MAPNOTES_SLASHCOMMAND = "Changer de Mode"
  MAPNOTES_SEND_TITLE = "Envoyer Note:"
  MAPNOTES_SEND_TIP = "Les Notes peuvent être reçues par tous les utilisateurs de "..MAPNOTES_DISPLAY.."."
  MAPNOTES_SEND_PLAYER = "Nom du joueur :"
  MAPNOTES_SENDTOPLAYER = "Envoyer au joueur"
  MAPNOTES_SENDTOPARTY = "Envoyer au groupe/raid"
-- %%% MAPNOTES_SENDTOPARTY_TIP = "Claquement gauche - Partie\nClaquement droit - Raid";
  MAPNOTES_SHOWSEND = "Changer de Mode"
  MAPNOTES_SEND_SLASHTITLE = "Obtenir la /commande :"
  MAPNOTES_SEND_SLASHTIP = "Selectionnez ceci et utilisez CTRL+C pour la copier dans le presse-papier. (Vous pouvez ensuite l'envoyer sur un forum par exemple)"
  MAPNOTES_SEND_SLASHCOMMAND = "/Commande :"

  MAPNOTES_OPTIONS_MENU = "MapNotes Options"
  MAPNOTES_SAVE_OPTIONS = "Sauvegarder"
  MAPNOTES_OWNNOTES = "Afficher les notes créées par votre personnage."
  MAPNOTES_OTHERNOTES = "Afficher les Notes reçues des autres joueurs."
  MAPNOTES_HIGHLIGHT_LASTCREATED = "Mettre en évidence (en |cFFFF0000rouge|r) la dernière Note créée."
  MAPNOTES_HIGHLIGHT_MININOTE = "Mettre en évidence (en |cFF6666FFbleu|r) la Note selectionnée."
  MAPNOTES_ACCEPTINCOMING = "Accepter les Notes des autres utilisateurs."
  MAPNOTES_INCOMING_CAP = "Refuser une Note si vous avez moins de 5 Notes disponibles."
  MAPNOTES_AUTOPARTYASMININOTE = "Membres du groupe en MiniNote."

  MAPNOTES_CREATEDBY = "Créé par"
  MAPNOTES_CHAT_COMMAND_ENABLE_INFO = "Cette commande vous permet d'ajouter une Note trouvée sur une page web par exemple."
  MAPNOTES_CHAT_COMMAND_ONENOTE_INFO = "Autorise la réception de la prochaine Note."
  MAPNOTES_CHAT_COMMAND_MININOTE_INFO = "Mettre la prochaine Note reçue en tant que MiniNote (avec une copie sur la carte)."
  MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO = "Mettre la prochaine Note reçue en tant que MiniNote (seulement sur la minicarte)."
  MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO = "Désactiver MiniNote."
  MAPNOTES_CHAT_COMMAND_MNTLOC_INFO = "Ajoute une position sur la carte."
  MAPNOTES_CHAT_COMMAND_QUICKNOTE = "Créer une Note à votre position actuelle."
  MAPNOTES_CHAT_COMMAND_QUICKTLOC = "Créer une Note à la position donnée."
  MAPNOTES_MAPNOTEHELP = "Cette commande ne peut être utilisée que pour ajouter une Note."
  MAPNOTES_ONENOTE_OFF = "Autoriser une Note : Désactivé"
  MAPNOTES_ONENOTE_ON = "Autoriser une Note : Activé"
  MAPNOTES_MININOTE_SHOW_0 = "Prochaine Note en MiniNote: Désactivé"
  MAPNOTES_MININOTE_SHOW_1 = "Prochaine Note en MiniNote: Activé"
  MAPNOTES_MININOTE_SHOW_2 = "Prochaine Note en MiniNote: Seulement"
  MAPNOTES_DECLINE_SLASH = "Ajout impossible, trop de Notes dans la zone |cFFFFD100%s|r."
  MAPNOTES_DECLINE_SLASH_NEAR = "Ajout impossible, Note trop proche de |cFFFFD100%q|r dans |cFFFFD100%s|r."
  MAPNOTES_DECLINE_GET = "Réception impossible, trop de Notes dans la zone |cFFFFD100%s|r, ou la réception de Notes est désactivée."
  MAPNOTES_ACCEPT_SLASH = "Note ajouté dans |cFFFFD100%s|r."
  MAPNOTES_ACCEPT_GET = "Vous avez reçu la Note '|cFFFFD100%s|r dans |cFFFFD100%s|r."
  MAPNOTES_PARTY_GET = "|cFFFFD100%s|r utilisé comme Note de g'roupe dans |cFFFFD100%s|r."
  MAPNOTES_DECLINE_NOTETOONEAR = "|cFFFFD100%s|r a essayé de vous envoyer la Note |cFFFFD100%s|r, mais elle est trop proche de |cFFFFD100%q|r."
  MAPNOTES_QUICKNOTE_NOTETOONEAR = "Création impossible. Vous êtes trop proche de |cFFFFD100%s|r."
  MAPNOTES_QUICKNOTE_NOPOSITION = "Création impossible. Impossible de récupérer votre position actuelle."
  MAPNOTES_QUICKNOTE_DEFAULTNAME = "Quicknote"
  MAPNOTES_QUICKNOTE_OK = "Créé dans |cFFFFD100%s|r."
  MAPNOTES_QUICKNOTE_TOOMANY = "Il y a déja trop de Notes dans |cFFFFD100%s|r."
  MAPNOTES_DELETED_BY_NAME = "A supprimé tout le Notes de carte avec le créateur |cFFFFD100%s|r et le nom |cFFFFD100%s|r."
  MAPNOTES_DELETED_BY_CREATOR = "A supprimé tout le Notes de carte avec le créateur |cFFFFD100%s|r."
  MAPNOTES_QUICKTLOC_NOTETOONEAR = "Création impossible. Trop proche de |cFFFFD100%s|r."
  MAPNOTES_QUICKTLOC_NOZONE = "Création impossible. Impossible de récupérer la zone actuelle."
  MAPNOTES_QUICKTLOC_NOARGUMENT = "Utilisation: '/quicktloc xx,yy [icone] [titre]'."
  MAPNOTES_SETMININOTE = "Utiliser comme MiniNote"
  MAPNOTES_THOTTBOTLOC = "Thottbot Position"
  MAPNOTES_PARTYNOTE = "Note de groupe"

  MAPNOTES_CONVERSION_COMPLETE = MAPNOTES_VERSION.." - Changez complet. Veuillez vérifier vos notes."

  -- Drop Down Menu
  MAPNOTES_SHOWNOTES = "Montrez Les Notes"
  MAPNOTES_DROPDOWNTITLE = "Notes De Carte"
  MAPNOTES_DROPDOWNMENUTEXT = "Options"

  MAPNOTES_WARSONGGULCH = "Goulet des Warsong"
  MAPNOTES_ALTERACVALLEY = "Vallée d'Alterac"
  MAPNOTES_ARATHIBASIN = "Bassin d'Arathi"
  MAPNOTES_NETHERSTORMARENA = "L'Eil du Cyclone";
  MAPNOTES_STRANDOFTHEANCIENTS= "Rivage des anciens";
  MAPNOTES_SCARLETENCLAVE = "Maleterres : l'enclave Écarlate";

  MAPNOTES_COSMIC = "Carte cosmique";


  -- Coordinates
  MAPNOTES_MAP_COORDS = "Carte Coords";
  MAPNOTES_MINIMAP_COORDS = "Minimap Coords";


  -- MapNotes Target & Merging
  MAPNOTES_MERGED = "MapNote Merged for : ";
  MAPNOTES_MERGE_DUP = "MapNote already exists for : ";
  MAPNOTES_MERGE_WARNING = "You must have something targetted to merge notes.";

  BINDING_HEADER_MAPNOTES = "MapNotes";
  BINDING_NAME_MN_TARGET_NEW = "QuickNote/TargetNote";
  BINDING_NAME_MN_TARGET_MERGE = "Merge Target Note";

  MN_LEVEL = "Niveau";

  -- Magellan Style LandMarks
  MAPNOTES_LANDMARKS = "Landmarks";       -- Landmarks, as in POI, or Magellan
  MAPNOTES_LANDMARKS_CHECK = "Auto-MapNote "..MAPNOTES_LANDMARKS;
  MAPNOTES_DELETELANDMARKS = "Delete "..MAPNOTES_LANDMARKS;
  MAPNOTES_MAGELLAN = "(Magellan)";
  MAPNOTES_LM_CREATED = " MapNotes Created in ";
  MAPNOTES_LM_MERGED = " MapNotes Merged in ";
  MAPNOTES_LM_SKIPPED = " MapNotes not Noted in ";
  MAPNOTES_LANDMARKS_NOTIFY = MAPNOTES_LANDMARKS.." Noted in ";


end





