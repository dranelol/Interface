-- *******************************************************
-- **          Mizus RaidTracker - ruRU Local           **
-- **          <http://nanaki.affenfelsen.de>           **
-- *******************************************************
--
-- This localization is written by:
--  rinaline, YOti
--
-- Note: 
--  MRT requires a correct localization of RaidZones and Bossyells for working
--

----------------------
--  Are you local?  --
----------------------
if GetLocale() ~= "ruRU" then return end


-----------------
--  Bossyells  --
-----------------
MRT_L.Bossyells = {
    -- Naxxramas
    [535] = {
        ["I grow tired of these games. Proceed, and I will banish your souls to oblivion!"] = "Four Horsemen",  -- Four Horsemen
    },
    
    -- Ulduar
    [529] = {
        ["You rush headlong into the maw of madness!"] = "Железное собрание",  -- Normalmode - Stormcaller Brundir last
        ["What have you gained from my defeat? You are no less doomed, mortals!"] = "Железное собрание",  -- Semi-Hardmode - Runemaster Molgeim last
        ["Impossible..."] = "Железное собрание",  -- Hardmode - Steelbreaker last
        ["I... I am released from his grasp... at last."] = "Ходир",  -- Hodir
        ["Stay your arms! I yield!"] = "Торим",  -- Thorim
        ["His hold on me dissipates. I can see clearly once more. Thank you, heroes."] = "Фрейя",  -- Freya
        ["It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear."] = "Мимирон",  -- Mimiron
        ["I have seen worlds bathed in the Makers' flames, their denizens fading without as much as a whimper. Entire planetary systems born and razed in the time that it takes your mortal hearts to beat once. Yet all throughout, my own heart devoid of emotion... of empathy. I. Have. Felt. Nothing. A million-million lives wasted. Had they all held within them your tenacity? Had they all loved life as you do?"] = "Алгалон Наблюдатель",  -- Algalon
    },
    
    -- Trial of the Crusader    
    [543] = {
        ["A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death."] = "Чемпионы фракций",  -- Faction Champions
    },
    
    -- Icecrown Citadel
    [604] = {
        ["Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"] = "Бой на кораблях", -- Gunship Battle Muradin (A)
        ["The Alliance falter. Onward to the Lich King!"] = "Бой на кораблях", -- Gunship Battle Saurfang (H)
        ["I AM RENEWED! Ysera grant me the favor to lay these foul creatures to rest!"] = "Валитрия Сноходица", -- Dreamwalker
    },

    -- Ruby Sanctum
    [609] = {
        ["Relish this victory, mortals, for it will be your last. This world will burn with the master's return!"] = "Халион", -- Halion
    },
    
    -- Throne of the Four Winds
    [773] = {
        ["The Conclave of Wind has dissipated. Your honorable conduct and determination have earned you the right to face me in battle, mortals. I await your assault on my platform! Come!"] = "Conclave of Wind", -- Conclave of Wind
    },
    
    -- Firelands
    [800] = {
        ["Too soon! ... You have come too soon..."] = "Ragnaros",
    },
    
    -- Terrace of Endless Spring
    [886] = {
        --["No... the waters... I must... resist... I shall not... fear..."] = "Protectors of the Endless",
        ["Спасибо вам, незнакомцы. Я свободен."] = "Цулон", 
        ["Я... а... о! Я?.. Все было таким... мутным."] = "Лэй Ши",
    }, 
}


---------------------------------
--  Core frames local strings  --
---------------------------------
MRT_L.Core["DKP_Frame_Bank_Button"] = "Банк"
MRT_L.Core["DKP_Frame_Cancel_Button"] = "Отмена"
MRT_L.Core["DKP_Frame_Cost"] = "Стоимость"
MRT_L.Core["DKP_Frame_Delete_Button"] = "Удалить"
MRT_L.Core["DKP_Frame_Disenchanted_Button"] = "Распылено"
-- MRT_L.Core["DKP_Frame_EnterCostFor"] = "Enter cost for"
MRT_L.Core["DKP_Frame_LootetBy"] = "получает добычу |cFFFFFFFF%s|r."
MRT_L.Core["DKP_Frame_Note"] = "Примечание"
MRT_L.Core["DKP_Frame_OK_Button"] = "Ок"
MRT_L.Core["DKP_Frame_Title"] = "Введите стоимость."
--[==[ MRT_L.Core["Export_AttendanceNote"] = [=[In the Raid-Log-Import-Settings, please set the option
"Time in seconds, the loot belongs to the boss before."
to or below 180 seconds to avoid attendance issues.]=] ]==]
MRT_L.Core["Export_Attendees"] = "Участники"
MRT_L.Core["Export_Button"] = "Закрыть"
MRT_L.Core["Export_Explanation"] = "Нажмите Ctrl+C чтобы скопировать данные в буфер обмена. Нажмите Ctrl+V чтобы вставить данные в ваш браузер."
MRT_L.Core["Export_Frame_Title"] = "Экспорт данных"
MRT_L.Core["Export_Heroic"] = "Героик"
MRT_L.Core["Export_Loot"] = "Добыча"
MRT_L.Core["Export_Normal"] = "Нормал"
-- MRT_L.Core["GuildAttendanceAddNotice"] = "%s added %s to the boss attendee list."
MRT_L.Core["GuildAttendanceAnnounceText"] = "Шепните мне имя вашего мейна чтобы добавить в DKP список."
-- MRT_L.Core["GuildAttendanceAnnounceText2"] = "Whisper me with '%s' to be added to the DKP list."
MRT_L.Core["GuildAttendanceBossDownText"] = "%s повержен!"
MRT_L.Core["GuildAttendanceBossEntry"] = "Проверка участников"
-- MRT_L.Core["GuildAttendanceFailNotice"] = "%s failed to add %s to the boss attendee list."
MRT_L.Core["GuildAttendanceMsgBox"] = "%s повержен. Запустить проверку участников??"
MRT_L.Core["GuildAttendanceRemainingTimeText"] = "%d минут осталось."
MRT_L.Core["GuildAttendanceReply"] = "Добавлен %s в список DKP."
MRT_L.Core["GuildAttendanceReplyFail"] = "%s уже есть в списке DKP."
MRT_L.Core["GuildAttendanceTimeUpText"] = "если вы не шепнете мне сайчас, будет слишком поздно."
-- MRT_L.Core["LDB Left-click to toggle the raidlog browser"] = "Left-click to toggle the raidlog browser"
-- MRT_L.Core["LDB Right-click to open the options menu"] = "Right-click to open the options menu"
MRT_L.Core["MB_Cancel"] = "Отмена"
MRT_L.Core["MB_No"] = "Нет"
MRT_L.Core["MB_Ok"] = "Ок"
MRT_L.Core["MB_Yes"] = "Да"
MRT_L.Core["TakeSnapshot_CurrentRaidError"] = "Ошибка: Активный рейд в процессе. Снимок не сделан."
MRT_L.Core["TakeSnapshot_Done"] = "Снимок сделан."
MRT_L.Core["TakeSnapshot_NotInRaidError"] = "Ошибка: Вы не в рейде. Снимок не сделан."
-- MRT_L.Core["Trash Mob"] = "Trash Mob"



-----------------------------------
--  Option panels local strings  --
-----------------------------------
MRT_L.Options["AP_GroupRestriction"] = "Отслеживать только первые 2/5 группы"
MRT_L.Options["AP_GuildAttendance"] = "Включить проверку участников гильдии"
-- MRT_L.Options["AP_GuildAttendanceCustomTextTitle"] = "Custom guild attendance text:"
MRT_L.Options["AP_GuildAttendanceDuration"] = "Длительность получения участников"
MRT_L.Options["AP_GuildAttendanceNoAuto"] = "Спрашивать подтверждение"
-- MRT_L.Options["AP_GuildAttendanceTrigger"] = "Trigger"
-- MRT_L.Options["AP_GuildAttendanceUseCustomText"] = "Use custom guild attendance text"
-- MRT_L.Options["AP_GuildAttendanceUseTrigger"] = "Use trigger instead of character name"
MRT_L.Options["AP_Minutes"] = "минут"
MRT_L.Options["AP_Title"] = "Участники"
MRT_L.Options["AP_TitleText"] = "MRT - Опции участников"
MRT_L.Options["AP_TrackOfflinePlayers"] = "Отслеживать оффлайн игроков"
-- MRT_L.Options["EP_AllXMLExportsTitle"] = "All XML export formats"
MRT_L.Options["EP_BBCode"] = "BBCode форматированный текст"
-- MRT_L.Options["EP_BBCode_wowhead"] = "BBCode formatted Text with wowhead links"
-- MRT_L.Options["EP_ChooseExport_Title"] = "Export format"
--[==[ MRT_L.Options["EP_CTRT_AddPoorItem"] = [=[Enable boss encounter detection fix for the
EQdkp(-Plus) CT_RaidTrackerImport 1.16.x]=] ]==]
MRT_L.Options["EP_CTRT_compatible"] = "CT RaidTracker совместимый" -- Needs review
-- MRT_L.Options["EP_CTRT_IgnorePerBossAttendance"] = "Ignore per boss attendance"
--[==[ MRT_L.Options["EP_CTRT_RLIAttendanceFix"] = [=[Enable attendance fix for the 
EQdkp-Plus Raid-Log-Import 0.5.6.x]=] ]==]
MRT_L.Options["EP_CTRTTitleText"] = "CTRT совместимый, настройки экспорта"
-- MRT_L.Options["EP_Currency"] = "Currency"
-- MRT_L.Options["EP_DKPBoard"] = "DKPBoard"
-- MRT_L.Options["EP_EnglishExport"] = "Export zone names and boss names in english"
-- MRT_L.Options["EP_EQDKP_Plus_XML"] = "EQdkp-Plus XML"
-- MRT_L.Options["EP_EQDKPTitleText"] = "EQdkp-Plus XML settings"
-- MRT_L.Options["EP_HTML"] = "CSS based HTML with wowhead links"
-- MRT_L.Options["EP_MLDKP_15"] = "MLdkp 1.5"
-- MRT_L.Options["EP_Plain_Text"] = "Plain Text"
-- MRT_L.Options["EP_SetDateTimeFormat"] = "Set format of date and time"
-- MRT_L.Options["EP_TextExportTitleText"] = "Text export settings"
-- MRT_L.Options["EP_Title"] = "Export"
-- MRT_L.Options["EP_TitleText"] = "MRT - Export options"
-- MRT_L.Options["ITP_AutoFocus_Always"] = "Always"
-- MRT_L.Options["ITP_AutoFocus_Never"] = "Never"
-- MRT_L.Options["ITP_AutoFocus_NoCombat"] = "When not in combat"
-- MRT_L.Options["ITP_AutoFocus_Title"] = "AutoFocus on loot cost dialog"
-- MRT_L.Options["ITP_IgnoreEnchantingMats"] = "Ignore enchanting materials"
-- MRT_L.Options["ITP_IgnoreGems"] = "Ignore gems"
-- MRT_L.Options["ITP_Title"] = "Item tracking"
-- MRT_L.Options["ITP_TitleText"] = "MRT - Item tracking options"
-- MRT_L.Options["ITP_UseEPGP_GP_Values"] = "Use EPGP GP values"
-- MRT_L.Options["MP_AutoPrunning"] = "Automatically delete raids older than"
-- MRT_L.Options["MP_Days"] = "days"
-- MRT_L.Options["MP_Debug"] = "Enable debug messages"
-- MRT_L.Options["MP_Description"] = "Tracks raids, loot and attendance"
-- MRT_L.Options["MP_Enabled"] = "Enable automatic tracking"
-- MRT_L.Options["MP_MinimapIcon"] = "Show minimap icon"
-- MRT_L.Options["MP_ResetGuiPos"] = "Reset GUI position"
-- MRT_L.Options["MP_SlashCmd"] = "Slash command"
-- MRT_L.Options["TP_AskForDKPValue"] = "Ask for item cost"
-- MRT_L.Options["TP_CreateNewRaidOnNewZone"] = "Create new raid on new zone"
-- MRT_L.Options["TP_Log10MenRaids"] = "Track 10 player raids"
-- MRT_L.Options["TP_LogAVRaids"] = "Track PVP raids (VoA, BH)"
-- MRT_L.Options["TP_LogLFRRaids"] = "Track LFR raids"
-- MRT_L.Options["TP_LogWotLKRaids"] = "Track WotLK raids"
-- MRT_L.Options["TP_MinItemQualityToGetCost_Desc"] = "Min item quality to ask cost for"
-- MRT_L.Options["TP_MinItemQualityToLog_Desc"] = "Min item quality to log"
-- MRT_L.Options["TP_OnlyTrackItemsAbove"] = "Only track items equal or above Itemlevel"
-- MRT_L.Options["TP_OnlyTrackItemsBelow"] = "or equal or below Itemlevel"
-- MRT_L.Options["TP_Title"] = "Raid tracking"
-- MRT_L.Options["TP_TitleText"] = "MRT - Raid tracking options"
-- MRT_L.Options["TP_UseServerTime"] = "Use server time"
--[==[ MRT_L.Options["TT_AP_GA_CustomText"] = [=[Available variables:
<<BOSS>> - Name of the boss event
<<TIME>> - Remaining time of the guild attendance check
<<TRIGGER>> - The custom trigger command]=] ]==]
--[==[ MRT_L.Options["TT_EP_AddPoorItem"] = [=[This option changes the loot export a bit to fix the boss encounter detection 
of the CT_RaidTrackerImport. Use this, if you have boss events 
in your raid without loot associated to it. (e.g. attendance checks).]=] ]==]
--[==[ MRT_L.Options["TT_EP_DateTimeTT"] = [=[ %d - day of the month [01-31] 
 %m - month [01-12] 
 %y - two-digit year [00-99] 
 %Y - full year 

 %H - hour, using a 24-hour clock [00-23] 
 %I - hour, using a 12-hour clock [01-12] 
 %M - minute [00-59] 
 %S - second [00-59] 
 %p - either 'am' or 'pm']=] ]==]
--[==[ MRT_L.Options["TT_EP_RLIAttendanceFix"] = [=[This option changes the export of timestamps a bit to pass 
the 50% attendance threshold of the Raid-Log-Importer. 
Only use this option, if your DKP system is based on per boss attendance.]=] ]==]
--[==[ MRT_L.Options["TT_MP_SlashCmd"] = [=[Command without leading slash.
A relog after changing this value is recommended.]=] ]==]



-------------------
--  GUI strings  --
-------------------
MRT_L.GUI["Active raid found. End current one first."] = "Ошибка: Обнаружен активный рейд. Пожалуйста завершите активный рейд прежде чем создавать новый."
MRT_L.GUI["Add boss attendee"] = "Добавить участника на босса"
MRT_L.GUI["Add bosskill"] = "Добавить убийство босса"
MRT_L.GUI["Add loot data"] = "Добавить добычу"
MRT_L.GUI["Add raid attendee"] = "Добавить участника в рейд"
MRT_L.GUI["Bossname"] = "Имя босса"
MRT_L.GUI["Button_Add"] = "Добавить"
MRT_L.GUI["Button_Delete"] = "Удалить"
MRT_L.GUI["Button_EndCurrentRaid"] = "Закончить текущий рейд"
MRT_L.GUI["Button_Export"] = "Экспорт"
MRT_L.GUI["Button_ExportHeroic"] = "Экспорт Г"
MRT_L.GUI["Button_ExportNormal"] = "Экспорт Н"
-- MRT_L.GUI["Button_MakeGuildAttendanceCheck"] = "Make guild attendance check"
MRT_L.GUI["Button_Modify"] = "Изменить"
-- MRT_L.GUI["Button_ResumeLastRaid"] = "Resume last raid"
MRT_L.GUI["Button_StartNewRaid"] = "Начать новый рейд"
MRT_L.GUI["Button_TakeSnapshot"] = "Сделать снимок"
MRT_L.GUI["Can not delete current raid"] = "Ошибка: невозможно удалить текущий рейд."
MRT_L.GUI["Cell_Hard"] = "Героический"
MRT_L.GUI["Cell_Normal"] = "Нормальный"
MRT_L.GUI["Col_Cost"] = "Стоимость"
MRT_L.GUI["Col_Date"] = "Дата"
MRT_L.GUI["Col_Difficulty"] = "Режим"
MRT_L.GUI["Col_Join"] = "Присоединиться"
MRT_L.GUI["Col_Leave"] = "Покинуть"
MRT_L.GUI["Col_Looter"] = "Добычу получил"
MRT_L.GUI["Col_Name"] = "Имя"
-- MRT_L.GUI["Col_Num"] = "#"
MRT_L.GUI["Col_Size"] = "Размер"
MRT_L.GUI["Col_Time"] = "Время"
MRT_L.GUI["Col_Zone"] = "Зона"
MRT_L.GUI["Confirm boss attendee entry deletion"] = "Хотите удалить %s из списка участников на боссе?"
-- MRT_L.GUI["Confirm boss entry deletion"] = "Do you want to delete entry %d - %s - from the bosskill list?"
MRT_L.GUI["Confirm loot entry deletion"] = "Вы действительно хотите удалить предмет %s из списка добычи?"
-- MRT_L.GUI["Confirm raid attendee entry deletion"] = "Do you want to delete %s from the raid attendees list?"
MRT_L.GUI["Confirm raid entry deletion"] = "Вы действительно хотите удалить рейд %d?"
MRT_L.GUI["Difficulty N or H"] = "Сложность ('N' or 'H')"
-- MRT_L.GUI["End tracking of current raid before exporting it"] = "Error: Can't export active raid."
-- MRT_L.GUI["Entered join time is not before leave time"] = "Error: Entered join time is not before leave time."
MRT_L.GUI["Entered time is not between start and end of raid"] = "Введенное значение времени не находится в диапазоне времени рейда"
MRT_L.GUI["Header_Title"] = "MRT - Лог рейда"
MRT_L.GUI["Item cost invalid"] = "Ошибка: неправильная стоимость предмета"
MRT_L.GUI["Itemlink"] = "Ссылка на предмет или ID предмета или имя предмета"
-- MRT_L.GUI["Looter"] = "Looter"
-- MRT_L.GUI["Modify loot data"] = "Modify loot data"
-- MRT_L.GUI["No active raid."] = "Error: No active raid."
MRT_L.GUI["No active raid in progress. Please enter time."] = "Ошибка: нет активного рейда. Пожалуйста введите время."
-- MRT_L.GUI["No boss attendee selected"] = "Error: No boss attendee selected."
MRT_L.GUI["No boss name entered"] = "Ошибка: не введено имя босса"
MRT_L.GUI["No boss selected"] = "Ошибка: босс не выбран"
MRT_L.GUI["No itemLink found"] = "Ошибка: ссылка на предмет неверна"
MRT_L.GUI["No loot selected"] = "Ошибка: предмет не выбран"
-- MRT_L.GUI["No name entered"] = "Error: No name entered."
-- MRT_L.GUI["No raid attendee selected"] = "Error: No raid attendee selected."
MRT_L.GUI["No raid selected"] = "Ошибка: не выбран рейд"
-- MRT_L.GUI["Note"] = "Note"
MRT_L.GUI["No valid difficulty entered"] = "Ошибка: введена неправильная сложность"
-- MRT_L.GUI["No valid raid size"] = "Error: No valid raid size entered."
MRT_L.GUI["No valid time entered"] = "Ошибка: введено неправильное время"
-- MRT_L.GUI["Player not in raid."] = "Error: You are not in a raid."
-- MRT_L.GUI["Raid size"] = "Raid size"
-- MRT_L.GUI["Resuming last raid failed"] = "Error: Failed to resume last raid"
-- MRT_L.GUI["Resuming last raid successful"] = "Last raid successfully resumed."
-- MRT_L.GUI["Tables_BossAttendeesTitle"] = "Boss attendees"
-- MRT_L.GUI["Tables_BossLootTitle"] = "Boss loot"
-- MRT_L.GUI["Tables_RaidAttendeesTitle"] = "Raid attendees"
-- MRT_L.GUI["Tables_RaidBosskillsTitle"] = "Raid bosskills"
-- MRT_L.GUI["Tables_RaidLogTitle"] = "Raid list"
-- MRT_L.GUI["Tables_RaidLootTitle"] = "Raid loot"
-- MRT_L.GUI["Time"] = "Time"
--[==[ MRT_L.GUI["TT_Attendee_Add_JoinEB"] = [=[Format HH:MM 

If left blank, MRT will use 
the raid start time.]=] ]==]
--[==[ MRT_L.GUI["TT_Attendee_Add_LeaveEB"] = [=[Format HH:MM 

If left blank, MRT will use 
the raid end time or current time.]=] ]==]
-- MRT_L.GUI["TT_BA_Add"] = "Add an attendee to the boss attendee list."
-- MRT_L.GUI["TT_BA_Delete"] = "Delete selected boss attendee."
-- MRT_L.GUI["TT_Boss_Add"] = "Add a boss encounter."
--[==[ MRT_L.GUI["TT_Boss_Add_TimeEB"] = [=[Format HH:MM 

Leave blank, if you want to add a boss 
as the most recent of the current raid.]=] ]==]
-- MRT_L.GUI["TT_Boss_Delete"] = "Delete selected boss encounter."
-- MRT_L.GUI["TT_Boss_Export"] = "Export selected boss encounter."
-- MRT_L.GUI["TT_Loot_Add"] = "Add an item to the loot list."
-- MRT_L.GUI["TT_Loot_Delete"] = "Delete selected item."
-- MRT_L.GUI["TT_Loot_Modify"] = "Modify data of selected item."
-- MRT_L.GUI["TT_RA_Add"] = "Add an attendee to the raid attendee list."
-- MRT_L.GUI["TT_RA_Delete"] = "Delete selected raid attendee."
-- MRT_L.GUI["TT_Raid_Delete"] = "Delete selected raid."
-- MRT_L.GUI["TT_Raid_Export"] = "Export selected raid."
-- MRT_L.GUI["TT_Raid_ExportH"] = "Export all heroic mode encounters of selected raid."
-- MRT_L.GUI["TT_Raid_ExportN"] = "Export all normal mode encounters of selected raid."
-- MRT_L.GUI["TT_StartNewRaid_RaidSizeEB"] = "If left blank, MRT will use 25 as the default value."
-- MRT_L.GUI["TT_StartNewRaid_ZoneNameEB"] = "If left blank, MRT will use your current zone."
--[==[ MRT_L.GUI["TT_TakeSnapshot"] = [=[Make a snapshot of the current raidgroup. 
Doesn't work, if raidtracking is in progress. 
In that case, add a boss event.]=] ]==]
-- MRT_L.GUI["Value"] = "Value"
-- MRT_L.GUI["Zone name"] = "Zone name"

