--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.

    Special thanks to OlegKR for the Russian translation
]]

-- English is the default localization for MapNotes

if GetLocale() == "ruRU" then
  
  -- General
  MAPNOTES_ADDON_DESCRIPTION = "Добавляет систему заметок для WorldMap.";
  MAPNOTES_DOWNLOAD_SITES = "Смотри адреса сайтов для загрузки в README";
  
  -- Interface Configuration
  MAPNOTES_WORLDMAP_HELP_1 = "Правый клик по Карте, чтобы увеличить масштаб";
  MAPNOTES_WORLDMAP_HELP_2 = "Левый клик по Карте, чтобы уменьшить масштаб";
  MAPNOTES_WORLDMAP_HELP_3 = "<Control>+Правый клик по Карте чтобы открыть "..MAPNOTES_NAME.." меню";
  MAPNOTES_CLICK_ON_SECOND_NOTE = "|cFFFF0000"..MAPNOTES_NAME..":|r Выберите Вторую Заметку чтобы Создать/Удалить линию";
  
  MAPNOTES_NEW_MENU = MAPNOTES_NAME;
  MAPNOTES_NEW_NOTE = "Создать Заметку";
  MAPNOTES_MININOTE_OFF = "Отключить MiniNote";
  MAPNOTES_OPTIONS = "Опции";
  MAPNOTES_CANCEL = "Отмена";
  
  MAPNOTES_POI_MENU = MAPNOTES_NAME;
  MAPNOTES_EDIT_NOTE = "Редактировать Заметку";
  MAPNOTES_MININOTE_ON = "Сделать как MiniNote";
  MAPNOTES_SPECIAL_ACTIONS = "Специальные действия";
  MAPNOTES_SEND_NOTE = "Отправить Заметку";
  
  MAPNOTES_SPECIALACTION_MENU = "Специальные действия";
  MAPNOTES_TOGGLELINE = "Созд./Удал. Линию";
  MAPNOTES_DELETE_NOTE = "Удалить Заметку";
  
  MAPNOTES_EDIT_MENU = "Редактирование Заметки";
  MAPNOTES_SAVE_NOTE = "Сохранить";
  MAPNOTES_EDIT_TITLE = "Название (обязательно):";
  MAPNOTES_EDIT_INFO1 = "Инфо Строка 1 (дополнительно):";
  MAPNOTES_EDIT_INFO2 = "Инфо Строка 2 (дополнительно):";
  MAPNOTES_EDIT_CREATOR = "Создал (дополнительно):";
  
  MAPNOTES_SEND_MENU = "Отправить Заметку";
  MAPNOTES_SLASHCOMMAND = "Сменить режим";
  MAPNOTES_SEND_TITLE = "Отправить Заметку:";
  MAPNOTES_SEND_TIP = "Эту заметку могут получить все пользователи "..MAPNOTES_DISPLAY..".";
  MAPNOTES_SEND_PLAYER = "Введите имя игрока:";
  MAPNOTES_SENDTOPLAYER = "Отправить игроку";
  MAPNOTES_SENDTOPARTY = "Отправить Группе/Рейду";
  
  -- %%% MAPNOTES_SENDTOPARTY_TIP = "Left Click - Party\nRight Click - Raid";
  MAPNOTES_SHOWSEND = "Сменить режим";
  MAPNOTES_SEND_SLASHTITLE = "Получить слеш комманду:";
  MAPNOTES_SEND_SLASHTIP = "Выделите текст и нажмите CTRL+C, чтобы скопировать его в буфер обмена (тогда, Вы сможете использовать этот текст, например на форуме)";
  MAPNOTES_SEND_SLASHCOMMAND = "/Command:";
  
  MAPNOTES_OPTIONS_MENU = "Опции";
  MAPNOTES_SAVE_OPTIONS = "Сохранить";
  MAPNOTES_OWNNOTES = "Показывать Заметки созданные вашим персонажем";
  MAPNOTES_OTHERNOTES = "Показывать Заметки полученные от других персонажей";
  MAPNOTES_HIGHLIGHT_LASTCREATED = "Подсвечивать последнию созданную Заметку |cFFFF0000красным|r";
  MAPNOTES_HIGHLIGHT_MININOTE = "Подсвечивать заметку созданную как MiniNote";
  MAPNOTES_ACCEPTINCOMING = "Принимать входящие Заметки от других игроков";
  MAPNOTES_INCOMING_CAP = "Отказываться от заметок, если ли есть меньше чем 5 пустых заметок?";
  MAPNOTES_AUTOPARTYASMININOTE = "Автоматически создавать групповые заметки как MiniNote.";
  
  MAPNOTES_CREATEDBY = "Создал";
  MAPNOTES_CHAT_COMMAND_ENABLE_INFO = "Эта команда позволит вам вставлять заметки, полученные с веб-страниц, например.";
  MAPNOTES_CHAT_COMMAND_ONENOTE_INFO = "Переопределяет параметры настройки, так что вы сможете получить следующию заметку.";
  MAPNOTES_CHAT_COMMAND_MININOTE_INFO = "Показывает следующию заметку, полученную как MiniNote (и вставляет её на карту):";
  MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO = "Показывает следующию заметку, полученную как MiniNote (но не вставляет её на карту).";
  MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO = "Выключает MiniNote.";
  MAPNOTES_CHAT_COMMAND_MNTLOC_INFO = "Устанавлиает маркер Thottbott на карте.";
  MAPNOTES_CHAT_COMMAND_QUICKNOTE = "Создаёт заметку в текущей позиции на карте.";
  MAPNOTES_CHAT_COMMAND_QUICKTLOC = "Создаёт заметку с полученными координатами позиции на карте в текущей зоне.";
  
  MAPNOTES_CHAT_COMMAND_SEARCH = "Поиск заметки, содержащий [текст]";
  MAPNOTES_CHAT_COMMAND_HIGHLIGHT = "Подсвечивает MapNotes со следующим [название]";
  
  MAPNOTES_CHAT_COMMAND_IMPORT_METAMAP = "Импортирование MetaMapNotes. Предназначен для людей, мигрирующих на MapNotes.\nMetaMap должен быть установлен и включен в работу. После импортирования деинсталлируйте MetaMap.\nВНИМАНИЕ: Предупреждение для новых пользователей. Возможна замена существующих заметок."; --Telic_4
  MAPNOTES_CHAT_COMMAND_IMPORT_ALPHAMAP = "Импорт AlphaMap's Instance Notes : Требуется установленный и включённый AlphaMap (Fan's Update)";        --Telic_4
  
  MAPNOTES_CHAT_COMMAND_SCALE = "Размер окна";
  MAPNOTES_CHAT_COMMAND_ISCALE = "Размер иконок";
  MAPNOTES_CHAT_COMMAND_ICONALPHA = "Прозрачность иконок";
  
  MAPNOTES_CHAT_COMMAND_UNDELETE = "Восстановить последние удаленные заметки";
  
  MAPNOTES_MAPNOTEHELP = "Эта команда только для вставки заметок";
  MAPNOTES_ONENOTE_OFF = "Эту заметку: Выкл.";
  MAPNOTES_ONENOTE_ON = "Эту заметку: Вкл.";
  MAPNOTES_MININOTE_SHOW_0 = "Следующию MiniNote: Выкл.";
  MAPNOTES_MININOTE_SHOW_1 = "Следующию MiniNote: Вкл.";
  MAPNOTES_MININOTE_SHOW_2 = "Следующию MiniNote: Только";
  MAPNOTES_DECLINE_SLASH = "Не удалось добавить, слишком много заметок в |cFFFFD100%s|r.";
  MAPNOTES_DECLINE_SLASH_NEAR = "Не удалось добавить, эта заметка слишком близко к |cFFFFD100%q|r в |cFFFFD100%s|r.";
  MAPNOTES_DECLINE_GET = "Не могут получить сведения из |cFFFFD100%s|r: слишком много заметок |cFFFFD100%s|r, или выключён приём в опциях.";
  MAPNOTES_ACCEPT_SLASH = "Заметка добавлена на карту |cFFFFD100%s|r.";
  MAPNOTES_ACCEPT_GET = "Вы получили заметку от |cFFFFD100%s|r в |cFFFFD100%s|r.";
  MAPNOTES_PARTY_GET = "|cFFFFD100%s|r установить новую групповую заметку в |cFFFFD100%s|r.";
  MAPNOTES_DECLINE_NOTETOONEAR = "|cFFFFD100%s|r пытался отправить вам записку в |cFFFFD100%s|r, но она слишком близко к |cFFFFD100%q|r.";
  MAPNOTES_QUICKNOTE_NOTETOONEAR = "Не удалось создать заметку. Вы слишком близко к |cFFFFD100%s|r.";
  MAPNOTES_QUICKNOTE_NOPOSITION = "Не удалось создать заметку: не удалось получить текущую позицию.";
  MAPNOTES_QUICKNOTE_DEFAULTNAME = "Быстрая Заметка";
  MAPNOTES_QUICKNOTE_OK = "Создана заметка на карте |cFFFFD100%s|r.";
  MAPNOTES_QUICKNOTE_TOOMANY = "Уже слишком много заметок на карте |cFFFFD100%s|r.";
  MAPNOTES_DELETED_BY_NAME = "Удалить все "..MAPNOTES_NAME.." созданные |cFFFFD100%s|r и названные |cFFFFD100%s|r.";
  MAPNOTES_DELETED_BY_CREATOR = "Удалить все "..MAPNOTES_NAME.." созданные |cFFFFD100%s|r.";
  MAPNOTES_QUICKTLOC_NOTETOONEAR = "Не удалось создать заметку. Она слишком близко расположена к заметке |cFFFFD100%s|r.";
  MAPNOTES_QUICKTLOC_NOZONE = "Не удалось создать заметку: не удалось получить текущую зону.";
  MAPNOTES_QUICKTLOC_NOARGUMENT = "Используйте: '/quicktloc xx,yy [icon] [title]'.";
  MAPNOTES_SETMININOTE = "Установить заметку как новую MiniNote";
  MAPNOTES_THOTTBOTLOC = "Thottbot Location";
  MAPNOTES_PARTYNOTE = "Групповая Заметка";
  MAPNOTES_WFC_WARN = "Используйте |c0000FF00'/mn -tloc xx,yy'|r ИЛИ |c0000FF00'/mntloc xx,yy'|r для показа местоположения на карте.";
  
  MAPNOTES_CONVERSION_COMPLETE = MAPNOTES_VERSION.." - Конвертирование завершено. Пожалуйста, проверьте ваши заметки.";        -- ??
  
  MAPNOTES_TRUNCATION_WARNING = "Текст заметки для отправки нужно сократить";                -- ??
  
  MAPNOTES_IMPORT_REPORT = " Импортирование заметок";                                -- ??
  MAPNOTES_NOTESFOUND = " Найдена Заметк(а,и)";                                    -- ??
  
  -- Drop Down Menu
  MAPNOTES_SHOWNOTES = "Показать Заметки";
  MAPNOTES_DROPDOWNTITLE = MAPNOTES_NAME;
  MAPNOTES_DROPDOWNMENUTEXT = "Быстрые Опции";
  
  MAPNOTES_WARSONGGULCH = "Ущелье Песни Войны";
  MAPNOTES_ALTERACVALLEY = "Альтеракская долина";
  MAPNOTES_ARATHIBASIN = "Низина Арати";
  MAPNOTES_NETHERSTORMARENA = "Око Бури";
  MAPNOTES_STRANDOFTHEANCIENTS= "Берег Древних";
  MAPNOTES_SCARLETENCLAVE = "Чумные земли: Анклав Алого ордена";
  
  MAPNOTES_COSMIC = "Карта Вселенной";
  
  -- Coordinates
  MAPNOTES_MAP_COORDS = "Координаты на Карте";
  MAPNOTES_MINIMAP_COORDS = "Координаты на МиниКарте";
  MAPNOTES_COORDINATE_FORMATTING_ERROR1 = "MapNotes не мог интерпретировать полученные координаты";
  MAPNOTES_COORDINATE_FORMATTING_ERROR2 = "Необходимый формат : x,y    например 55,9";
  MAPNOTES_COORDINATE_FORMATTING_ERROR3 = "Подробно о формате смотри в Readme.txt";
  
  -- MapNotes Target & Merging
  MAPNOTES_MERGED = "MapNote объединить с : ";
  MAPNOTES_MERGE_DUP = "MapNote уже существует для : ";
  MAPNOTES_MERGE_WARNING = "Должно быть нескольно целей, чтобы объединить заметки.";
  
  BINDING_HEADER_MAPNOTES = "MapNotes";
  BINDING_NAME_MN_TARGET_NEW = "QuickNote/TargetNote";
  BINDING_NAME_MN_TARGET_MERGE = "Merge Target Note";
  BINDING_NAME_MN_TOGGLE_MINIS = "Global Mininotes Toggle";
  BINDING_NAME_MN_MINIMAP_STYLE = "Cycle through Minimap Styles";
  
  MN_LEVEL = "Уровень";
  
  MN_AUTO_DESCRIPTIONS = {
      ["SQUARE"]                    = "Квадрат",
  
      ["CORNER-TOPRIGHT"]            = "Скруглить Верхний Правый угол",
      ["CORNER-BOTTOMRIGHT"]        = "Скруглить Нижний Правый угол",
      ["CORNER-BOTTOMLEFT"]        = "Скруглить Нижний Левый угол",
      ["CORNER-TOPLEFT"]            = "Скруглить Верхний Левый угол",
  
      ["SIDE-RIGHT"]                = "Скруглить углы Справа",
      ["SIDE-BOTTOM"]                = "Скруглить Нижние углы",
      ["SIDE-LEFT"]                = "Скруглить углы Слева",
      ["SIDE-TOP"]                = "Скруглить Верхние углы",
  
      ["TRICORNER-TOPRIGHT"]        = "Выпрямить Верхний Правый угол",
      ["TRICORNER-BOTTOMRIGHT"]    = "Выпрямить Нижний Правый угол",
      ["TRICORNER-BOTTOMLEFT"]    = "Выпрямить Нижний Левый угол",
      ["TRICORNER-TOPLEFT"]        = "Выпрямить Верхний Левый угол",
      
      ["CIRCULAR"]                = "Круг";
  };
  
  MN_STYLE_AUTOMATIC = "Авто";
  
  -- Magellan Style LandMarks
  MAPNOTES_LANDMARKS = "Landmarks";                -- Landmarks, as in POI, or Magellan
  MAPNOTES_LANDMARKS_CHECK = "Auto-MapNote "..MAPNOTES_LANDMARKS;
  MAPNOTES_DELETELANDMARKS = "Удалить "..MAPNOTES_LANDMARKS;
  MAPNOTES_MAGELLAN = "(~Magellan)";
  MAPNOTES_LM_CREATED = " MapNotes создана в ";
  MAPNOTES_LM_MERGED = " MapNotes объедена в ";
  MAPNOTES_LM_SKIPPED = " MapNotes нет Заметок в ";
  MAPNOTES_LANDMARKS_NOTIFY = MAPNOTES_LANDMARKS.." Заметок в ";
  
  MN_STARTED_IMPORTING = "Старт Импорта";
  MN_INVALID_KEY = "Неправильный Map Key : ";
  MN_FINISHED_IMPORTING = "Завершение Импорта";
  MN_AREANOTES = "%d Замет(ка,ки,ок) в %d Зон(е,ах)";
  MN_DUPS_IGNORED = "Игнорировать дубликаты";
  
  MN_TT_MINITITLE = "Mininote";
  MN_TT_MINITEXT = "Удерживайте <Ctrl> чтобы сделать как Mininote";
  
  MN_COPY = "Копировать";
  MN_CUT = "Вырезать";
  MN_PASTE = "Вставить";
  MN_CONVERT = "Сделать постоянной";
  MN_CODEC_FMT = "Десятичных знаков : ";
  MN_MDELETE = "Удалить все Заметки содер. : ";
  MN_TEXT = "Текст";
  MN_CREATOR = "Создатель";
  MN_ALLZONES = "Все карты";
  
  MN_DELETED_WITH_TEXT = "Удалить все "..MAPNOTES_NAME.." содер. текст |cFFFFD100%s|r.";
  
  MN_WAYPOINT = "Массив WayPoint";

end


