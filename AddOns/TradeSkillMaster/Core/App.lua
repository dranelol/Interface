-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains all the code for the new tooltip options

local TSM = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster") -- loads the localization table
local App = TSM:NewModule("App", "AceHook-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

local private = {}
TSMAPI:RegisterForTracing(private, "TradeSkillMaster.App_private")


function App:LoadData()
	if not TSM.AppData then return end -- can happen if something is wrong with the file
	
	-- reset the index field in the history
	for key, data in pairs(TSM.db.global.groupImportHistory) do
		data.index = nil
	end
	
	-- load new entries into TSM.db.global.groupImportHistory
	for index, data in ipairs(TSM.AppData.groupImports) do
		local words = {}
		for i=1, floor(#data.import/4) do
			words[i] = 0;
			for j=0, 3 do
				words[i] = bit.lshift(words[i], 8)
				words[i] = bit.bor(words[i], strbyte(data.import, i*4+j) or 0)
			end
		end
		data.key = format("%x", bit.bxor(unpack(words))).."-"..data.time
		TSM.db.global.groupImportHistory[data.key] = TSM.db.global.groupImportHistory[data.key] or {imported=false, prompted=false}
		if (time()-data.time) < 24*60*60 then
			TSM.db.global.groupImportHistory[data.key].index = index
		end
	end
	
	-- remove old entries
	local toRemove = {}
	for key, data in pairs(TSM.db.global.groupImportHistory) do
		if not data.index then
			tinsert(toRemove, key)
		end
	end
	for _, key in ipairs(toRemove) do
		TSM.db.global.groupImportHistory[key] = nil
	end
	
	-- show the popup for new entries if necessary
	local doPrompt = false
	for key, data in pairs(TSM.db.global.groupImportHistory) do
		doPrompt = doPrompt or not data.prompted
		data.prompted = true
	end
	
	if doPrompt then
		StaticPopupDialogs["TSM_APP_GROUP_IMPORT"] = StaticPopupDialogs["TSM_APP_GROUP_IMPORT"] or {
			text = "You have pending group imports from the TSM Application. Would you like to view them now?",
			button1 = YES,
			button2 = NO,
			timeout = 0,
			OnAccept = function()
				TSMAPI:OpenFrame()
				TSMAPI:SelectIcon("TradeSkillMaster", "TSM Application")
			end,
		}
		TSMAPI:ShowStaticPopupDialog("TSM_APP_GROUP_IMPORT")
	end
	
	-- process great deal data
	local shoppingTemp = TSM.AppData.shoppingSearches
	TSM.AppData.shoppingSearches = nil
	for key, data in pairs(shoppingTemp) do
		if strlower(key) == strlower(GetRealmName() or "") and time() - data.downloadTime < 24*60*60 then
			TSM.AppData.shoppingSearches = data
			break
		end
	end
end

function App:LoadTSMAppOptions(parent)
	local tabGroup = AceGUI:Create("TSMTabGroup")
	tabGroup:SetLayout("Fill")
	tabGroup:SetTabs({{text="Pending Group Imports", value=1}})
	tabGroup:SetCallback("OnGroupSelected", function(_, _, value)
		tabGroup:ReleaseChildren()
		if value == 1 then
			private:DrawGroupImport(tabGroup)
		end
	end)
	parent:AddChild(tabGroup)
	tabGroup:SelectTab(1)
end

function private:DrawGroupImport(container)
	local checkedImports = {}
	local page = {
		{
			type = "ScrollFrame", -- simple group didn't work here for some reason
			fullHeight = true,
			layout = "Flow",
			children = {
				{
					type = "InlineGroup",
					title = "Help",
					layout = "Flow",
					children = {
						{
							type = "Label",
							text = "Below is a list of pending imports. They will be removed after 1 day if they aren't imported before then. Check the box next to the one(s) which you want to import and then select the group you want to import them into using the box below.",
							relativeWidth = 1,
						},
						{
							type = "HeadingLine",
						},
						{
							type = "GroupBox",
							label = "Import Selected Strings to Group",
							relativeWidth = 0.5,
							callback = function(self, _, groupPath)
								local didImport = false
								for key, import in pairs(checkedImports) do
									local num = TSM:ImportGroup(import, groupPath)
									if num then
										didImport = true
										TSM:Printf(L["Successfully imported %d items to %s."], num, TSMAPI:FormatGroupPath(groupPath, true))
										TSMAPI:FireEvent("TSM:GROUPS:ADDITEMS", {num=num, group=groupPath, isImport=true})
									else
										TSM:Print(L["Invalid import string."].." \""..import.."\"")
									end
									TSM.db.global.groupImportHistory[key].imported = true
								end
								if didImport then
									container:ReloadTab()
								else
									TSM:Print("No group import strings were selected.")
								end
							end,
						},
						{
							type = "CheckBox",
							label = L["Move Already Grouped Items"],
							relativeWidth = 0.49,
							settingInfo = {TSM.db.profile, "moveImportedItems"},
							callback = function() container:ReloadTab() end,
							tooltip = L["If checked, any items you import that are already in a group will be moved out of their current group and into this group. Otherwise, they will simply be ignored."],
						},
					},
				},
				{
					type = "InlineGroup",
					title = "Pending Imports",
					layout = "Flow",
					children = {
					},
				},
			},
		},
	}
	
	local pendingImportContainer = page[1].children[2].children
	
	for key, data in pairs(TSM.db.global.groupImportHistory) do
		if not data.imported then
			local import = TSM.AppData.groupImports[data.index].import
			tinsert(pendingImportContainer, {type="CheckBox", relativeWidth=1, label=import, callback=function(_, _, value) checkedImports[key] = value and import or nil end})
		end
	end
	
	if #pendingImportContainer == 0 then
		tinsert(pendingImportContainer, {type="Label", relativeWidth=1, text="No pending group imports from the TSM desktop application."})
	end

	TSMAPI:BuildPage(container, page)
end

function TSMAPI:GetAppData(key)
	return TSM.AppData[key]
end