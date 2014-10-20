-- ------------------------------------------------------------------------------ --
--                          TradeSkillMaster_ItemTracker                          --
--          http://www.curse.com/addons/wow/tradeskillmaster_itemtracker          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- TradeSkillMaster_ItemTracker Locale - ruRU
-- Please use the localization app on CurseForge to update this
-- http://wow.curseforge.com/addons/TradeSkillMaster_ItemTracker/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("TradeSkillMaster_ItemTracker", "ruRU")
if not L then return end

L["AH"] = "Аукцион"
L["Bags"] = "Сумки"
L["Bank"] = "Банк"
L["Characters"] = "Персонажи"
L["Delete Character:"] = "Удалить персонажа:"
L["Full"] = "Полный"
L["GBank"] = "Гильдбанк"
L["Guilds"] = "Гильдии"
L["Guilds (Guild Banks) to Ignore:"] = "Игнорировать гильдии (банки гильдий):"
L["Here, you can choose what ItemTracker info, if any, to show in tooltips. \"Simple\" will only show totals for bags/banks and for guild banks. \"Full\" will show detailed information for every character and guild."] = "Выбор вида отображения данных ItemTracker (если они есть) в подсказках. \"Простой\" покажет информацию о сумках / банке, банке гильдии этого персонажа. \"Полный\" покажет детальную информацию для всех персонажей на аккаунте и их гильдий."
L["If you rename / transfer / delete one of your characters, use this dropdown to remove that character from ItemTracker. There is no confirmation. If you accidentally delete a character that still exists, simply log onto that character to re-add it to ItemTracker."] = "Без подтверждения! Если вы переименуете / перенесёте / удалите одного из ваших персонажей, используйте этот список для удаления данного персонажа из модуля ItemTracker. Если вы случайно удалили персонажа, то просто зайдите этим персонажем в игру для добавления его в модуль."
L["Inventory Viewer"] = "Просмотр инвентаря"
L["Item Name"] = "Название предмета"
L["Item Search"] = "Поиск предмета"
L["Mail"] = "Почта"
L["Market Value Price Source"] = "Источник рыночной цены"
L["No Tooltip Info"] = "Без подсказок"
L["Options"] = "Настройки"
L["Select guilds to ingore in ItemTracker. Inventory will still be tracked but not displayed or taken into consideration by Itemtracker."] = "Выберите гильдию для игнорирования в ItemTracker. Инвентарь все еще будете отслеживаться, но не будет учитываться Itemtracker."
L["Simple"] = "Простой"
L["%s in guild bank"] = "%s в банке гильдии"
L["%s item(s) total"] = "Всего %s предметов"
L["Specifies the market value price source used for \"Total Market Value\" in the Inventory Viewer."] = "Указывает источник рыночной цены, используемой для расчета \"Общей рыночной стоимости\" в просмотре инвентаря"
L["(%s player, %s alts, %s guild banks, %s AH)"] = "(%s игрок, %s твинки, %s банки гильдий, %s аукцион)"
L["\"%s\" removed from ItemTracker."] = "\"%s\" удалено из ItemTracker."
L["%s (%s bags, %s bank, %s AH, %s mail)"] = "%s (%s сумки, %s банк, %s аукцион, %s почта)"
L["Total"] = "Всего"
L["Total Value"] = "Общая стоимость"
