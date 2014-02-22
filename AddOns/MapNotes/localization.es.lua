--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.

    This was a copy of the English localization. I have made an attempt at a proper Spanish
    localization using Google translate. Anyone who knows Spanish well, please let me know if there
    are any errors or omissions.

    Cortello  1-Feb-2011
--]]

-- English is the default localization for MapNotes
if (GetLocale() == "esES") then

  -- General
  MAPNOTES_ADDON_DESCRIPTION = "Agrega un sistema de notas para el Mapa del Mundo.";
  MAPNOTES_DOWNLOAD_SITES = "Ver README para los sitios de descarga";

	-- Interface Configuration
  MAPNOTES_WORLDMAP_HELP_1 = "Haga clic en el mapa para Alejar";
  MAPNOTES_WORLDMAP_HELP_2 = "Left-Haga clic en el mapa para Captura De";
  MAPNOTES_WORLDMAP_HELP_3 = "<Control> + Haga clic en el mapa para abrir" .. MAPNOTES_NAME .. "Menú";
  MAPNOTES_CLICK_ON_SECOND_NOTE = "|cFFFF0000" .. MAPNOTES_NAME .. ":|r Nota Elija Segunda Dibujar/Borrar una línea ";

  MAPNOTES_NEW_MENU = MAPNOTES_NAME;
  MAPNOTES_NEW_NOTE = "Crear nota";
  MAPNOTES_MININOTE_OFF = "Apagar MiniNote";
  MAPNOTES_OPTIONS = "Opciones";
  MAPNOTES_CANCEL = "Cancelar";

  MAPNOTES_POI_MENU = MAPNOTES_NAME;
  MAPNOTES_EDIT_NOTE = "Editar nota";
  MAPNOTES_MININOTE_ON = "Establecer como MiniNote";
  MAPNOTES_SPECIAL_ACTIONS = "acciones especiales";
  MAPNOTES_SEND_NOTE = "Enviar nota";

  MAPNOTES_SPECIALACTION_MENU = "acciones especiales";
  MAPNOTES_TOGGLELINE = "Activar la línea";
  MAPNOTES_DELETE_NOTE = "Borrar Nota";

  MAPNOTES_EDIT_MENU = "Editar nota";
  MAPNOTES_SAVE_NOTE = "Guardar";
  MAPNOTES_EDIT_TITLE = "Título (requerido):";
  MAPNOTES_EDIT_INFO1 = "Información de la Línea 1 (opcional):";
  MAPNOTES_EDIT_INFO2 = "Información de la Línea 2 (opcional):";
  MAPNOTES_EDIT_CREATOR = "Creador (opcional):";

  MAPNOTES_SEND_MENU = "Enviar nota";
  MAPNOTES_SLASHCOMMAND = "Cambiar el modo";
  MAPNOTES_SEND_TITLE = "Enviar Nota:";
  MAPNOTES_SEND_TIP = "Estas notas pueden ser recibidos por todos los MapNotes (Actualización de los admiradores de) los usuarios.";
  MAPNOTES_SEND_PLAYER = "Introduzca el nombre del jugador:";
  MAPNOTES_SENDTOPLAYER = "Enviar a jugador";
  MAPNOTES_SENDTOPARTY = "Enviar a la fiesta / banda";
-- %%% MAPNOTES_SENDTOPARTY_TIP = "Clic Izquierdo - Parte\nClic Derecha - Banda";
  MAPNOTES_SHOWSEND = "Cambiar el modo";
  MAPNOTES_SEND_SLASHTITLE = "Obtener barra de comandos:";
  MAPNOTES_SEND_SLASHTIP = "Resaltar este y el uso de CTRL + C para copiar al portapapeles (lo puedes escribir en un foro por ejemplo)";
  MAPNOTES_SEND_SLASHCOMMAND = "/Comando:";

  MAPNOTES_OPTIONS_MENU = "MapNotes Opciones";
  MAPNOTES_SAVE_OPTIONS = "Guardar";
  MAPNOTES_OWNNOTES = "Mostrar notas creadas por su carácter";
  MAPNOTES_OTHERNOTES = "Mostrar notas recibidas de otros personajes";
  MAPNOTES_HIGHLIGHT_LASTCREATED = "Resaltar la última nota creada en |cFFFF0000red|r";
  MAPNOTES_HIGHLIGHT_MININOTE = "Resaltar nota seleccionada para MiniNote en |cFF6666FFblue|r";
  MAPNOTES_ACCEPTINCOMING = "Aceptar las notas entrantes de otros jugadores";
  MAPNOTES_INCOMING_CAP = "toma nota de decadencia si dejaría a menos de 5 notas libres";
  MAPNOTES_AUTOPARTYASMININOTE = "Establecer automáticamente Parte señala como MiniNote.";

  MAPNOTES_CREATEDBY = "Creado por";
  MAPNOTES_CHAT_COMMAND_ENABLE_INFO = "Este comando le permite instert notas conseguido por una página web por ejemplo.";
  MAPNOTES_CHAT_COMMAND_ONENOTE_INFO = "Omitir las opciones de configuración, de modo que la siguiente nota que usted recibe es aceptado.";
  MAPNOTES_CHAT_COMMAND_MININOTE_INFO = "Muestra la siguiente nota recibida directamente como MiniNote (y insterts que en el mapa):";
  MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO = "Muestra la siguiente nota recibida como MiniNote (no se inserta en el mapa).";
  MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO = "Activa el MiniNote fuera.";
  MAPNOTES_CHAT_COMMAND_MNTLOC_INFO = "Establece un marcador Thottbot en el mapa.";
  MAPNOTES_CHAT_COMMAND_QUICKNOTE = "Crea una nota en la posición actual en el mapa.";
  MAPNOTES_CHAT_COMMAND_QUICKTLOC = "Crea una cuenta en la propuesta coordinar la posición en el mapa en la zona actual.";

  MAPNOTES_CHAT_COMMAND_SEARCH = "Buscar notas con [el texto]";
  MAPNOTES_CHAT_COMMAND_HIGHLIGHT = "Resaltar MapNotes con el [título] siguiente";

  MAPNOTES_CHAT_COMMAND_IMPORT_METAMAP =
      [[Importaciones MetaMapNotes. Destinado a personas que emigran a MapNotes.\n]]..
      [[MetaMap debe ser instalado y habilitado para el comando de trabajar Entonces Desinstale MetaMap.\n]]..
      [[ADVERTENCIA: Destinado a los nuevos usuarios de mayo de sobre-escribir las notas existentes.]]; -- Telic_4
  MAPNOTES_CHAT_COMMAND_IMPORT_ALPHAMAP = "Notas AlphaMap importación de Instancia: Requiere AlphaMap (Actualización Fan) para ser instalado y habilitado"; -- Telic_4

  MAPNOTES_MAPNOTEHELP = "Este comando sólo se puede utilizar para insertar una nota";
  MAPNOTES_ONENOTE_OFF = "Permitir una nota: OFF";
  MAPNOTES_ONENOTE_ON = "Permitir una nota: ON";
  MAPNOTES_MININOTE_SHOW_0 = "Siguiente MiniNote como: OFF";
  MAPNOTES_MININOTE_SHOW_1 = "Siguiente MiniNote como: ON";
  MAPNOTES_MININOTE_SHOW_2 = "Siguiente MiniNote como: SÓLO";
  MAPNOTES_DECLINE_SLASH = "No se puede agregar también muchas notas en |cFFFFD100%s|r";
  MAPNOTES_DECLINE_SLASH_NEAR = "No se puede agregar, esta nota es demasiado cerca de |cFFFFD100% q|r |cFFFFD100%s|r";
  MAPNOTES_DECLINE_GET = "No se pudo recibir la nota de |cFFFFD100%s|r:. También muchas notas en |cFFFFD100%s|r, o la recepción con discapacidad en las opciones";
  MAPNOTES_ACCEPT_SLASH = "Nota añadida para el mapa de |cFFFFD100%s|r";
  MAPNOTES_ACCEPT_GET = "Has recibido una nota de |cFFFFD100%s|r en |cFFFFD100%s|r";
  MAPNOTES_PARTY_GET = "|cFFFFD100% s|r establecer un nuevo partido en nota |cFFFFD100%s|r";
  MAPNOTES_DECLINE_NOTETOONEAR = "|cFFFFD100%s|r tratado de enviar una nota en |cFFFFD100%s|r, pero ya era demasiado cerca de |cFFFFD100% q|r";
  MAPNOTES_QUICKNOTE_NOTETOONEAR = "No se puede crear la nota que está demasiado cerca de |cFFFFD100% s | derecho.";
  MAPNOTES_QUICKNOTE_NOPOSITION = "No se puede crear la nota: no se pudo recuperar la posición actual.";
  MAPNOTES_QUICKNOTE_DEFAULTNAME = "Quicknote";
  MAPNOTES_QUICKNOTE_OK = "nota de creación en el mapa de |cFFFFD100%s|r";
  MAPNOTES_QUICKNOTE_TOOMANY = "Ya hay también muchas notas sobre el mapa de |cFFFFD100%s|r";
  MAPNOTES_DELETED_BY_NAME = "eliminado todos los" .. MAPNOTES_NAME .. "con el creador |cFFFFD100% s|r y el nombre |cFFFFD100% s|r";
  MAPNOTES_DELETED_BY_CREATOR = "eliminado todos los" .. MAPNOTES_NAME .. "con el creador |cFFFFD100%s|r";
  MAPNOTES_QUICKTLOC_NOTETOONEAR = "No se puede crear la nota de la ubicación es muy cerca a la nota |cFFFFD100%s|r.";
  MAPNOTES_QUICKTLOC_NOZONE = "No se puede crear la nota: no se pudo recuperar la zona actual.";
  MAPNOTES_QUICKTLOC_NOARGUMENT = "Uso: '/quicktloc xx,yy [icono] [título]'.";
  MAPNOTES_SETMININOTE = "Establecer como MiniNote cuenta nueva";
  MAPNOTES_THOTTBOTLOC = "El Thottbot ubicación";
  MAPNOTES_PARTYNOTE = "Nota del Partido";
  MAPNOTES_WFC_WARN = "Uso |c0000FF00'/mn -tloc xx,yy'|r O |c0000FF00'/mntloc xx,yy'|r para mostrar el resultado de una ubicación en el mapa.";

  MAPNOTES_CONVERSION_COMPLETE = MAPNOTES_VERSION .. " - Conversión completa. Por favor, revise sus notas.."; --??

  MAPNOTES_TRUNCATION_WARNING = "la nota de texto enviados se tuvo que truncar"; --?

  MAPNOTES_IMPORT_REPORT = "Notas importados"; --?
  MAPNOTES_NOTESFOUND = "Nota(s) encontrados"; --?

-- Drop Down Menu
  MAPNOTES_SHOWNOTES = "Mostrar notas";
  MAPNOTES_DROPDOWNTITLE = MAPNOTES_NAME;
  MAPNOTES_DROPDOWNMENUTEXT = "Opciones rápidas";

  MAPNOTES_WARSONGGULCH = "Garganta Grito de Guerra";
  MAPNOTES_ALTERACVALLEY = "Valle de Alterac";
  MAPNOTES_ARATHIBASIN = "Cuenca de Arathi";
  MAPNOTES_NETHERSTORMARENA = "El Ojo de la Tormenta";
  MAPNOTES_STRANDOFTHEANCIENTS= "Strand of the Ancients";
  MAPNOTES_SCARLETENCLAVE = "The Scarlet Enclave";

  MAPNOTES_COSMIC = "Cósmica";

  -- Coordinates
  MAPNOTES_MAP_COORDS = "Coordenadas de mapa";
  MAPNOTES_MINIMAP_COORDS = "Coordenadas minimapa";

  -- MapNotes Target & Merging
  MAPNOTES_MERGED = "MapNote combinados de:";
  MAPNOTES_MERGE_DUP = "MapNote ya existe para:";
  MAPNOTES_MERGE_WARNING = "Usted debe tener algo blanco para combinar notas.";

  BINDING_HEADER_MAPNOTES = "MapNotes";
  BINDING_NAME_MN_TARGET_NEW = "QuickNote / TargetNote";
  BINDING_NAME_MN_TARGET_MERGE = "Combinar Nota de destino";

  MN_LEVEL = "Nivel";


  MN_AUTO_DESCRIPTIONS = {
    ["SQUARE"]          = "Full Square";

    ["CORNER-TOPRIGHT"]       = "Redondeado la esquina superior derecha";
    ["CORNER-BOTTOMRIGHT"]    = "Redondeado la esquina inferior derecha";
    ["CORNER-BOTTOMLEFT"]     = "Redondeado la esquina inferior izquierda ";
    ["CORNER-TOPLEFT"]        = "Redondeado la esquina superior izquierda";

    ["SIDE-RIGHT"]            = "Esquinas redondeadas lado derecho";
    ["SIDE-BOTTOM"]           = "Esquinas redondeadas de fondo";
    ["SIDE-LEFT"]             = "Esquinas redondeadas izquierda Side ";
    ["SIDE-TOP"]              = "Esquinas redondeadas Top";

    ["TRICORNER-TOPRIGHT"]    = "Cuadrado ángulo superior derecho";
    ["TRICORNER-BOTTOMRIGHT"] = "Cuadrado esquina inferior derecha";
    ["TRICORNER-BOTTOMLEFT"]  = "Cuadrado esquina inferior izquierda";
    ["TRICORNER-TOPLEFT"]     = "Cuadrado esquina superior izquierda";

    ["CIRCULAR"]              = "Circular";
  };

  MN_STYLE_AUTOMATIC = "Automático";

  -- Magellan Style LandMarks
  MAPNOTES_LANDMARKS = "Monumentos";
  MAPNOTES_LANDMARKS_CHECK = "Auto-MapNote" .. MAPNOTES_LANDMARKS;
  MAPNOTES_DELETELANDMARKS = "Eliminar" .. MAPNOTES_LANDMARKS;
  MAPNOTES_MAGELLAN = "(~Magellan)";
  MAPNOTES_LM_CREATED = "MapNotes Creado en";
  MAPNOTES_LM_MERGED = "MapNotes Fusionado en";
  MAPNOTES_LM_SKIPPED = "No se MapNotes Tomó nota de";
  MAPNOTES_LANDMARKS_NOTIFY = MAPNOTES_LANDMARKS .. "Tomó nota de";

  MN_STARTED_IMPORTING = "comenzó a importar";
  MN_INVALID_KEY = "Mapa de claves no válido";
  MN_FINISHED_IMPORTING = "Finalizar importación";
  MN_AREANOTES = "%d Notas de %d Áreas";
  MN_DUPS_IGNORED = "Duplicados ignorados";


  MN_TT_MINITITLE = "Mininote";
  MN_TT_MINITEXT = "Mantenga presionada la tecla <Ctrl> establecer como Mininote";

  MN_COPY = "Copiar";
  MN_CUT = "Cortar";
  MN_PASTE = "Pegar";
  MN_CONVERT = "Hacer Permanente";
  MN_CODEC_FMT = "Lugares decimales Coord:";
  MN_MDELET = "Eliminar Misa por:";
  MN_TEXT = "Texto";
  MN_CREATOR = "Creador";
  MN_ALLZONES = "Todos los Mapas";

  MN_DELETED_WITH_TEXT = "Eliminado todos los" .. MAPNOTES_NAME .. "con el texto |cFFFFD100%s|r";

  MN_WAYPOINT = "Aaypoint Flecha";

end

