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
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries
local lib = TSMAPI
local tooltipLib = LibStub("LibExtraTip-1")
local moduleObjects = TSM.moduleObjects
local moduleNames = TSM.moduleNames

local private = {}
TSMAPI:RegisterForTracing(private, "TradeSkillMaster.Tooltips_private")
private.tooltipInfo = {}

-- **************************************************************************
--                            LibExtraTip Functions
-- **************************************************************************

function TSM:SetupTooltips()
	tooltipLib:AddCallback({type = "battlepet", callback = private.LoadTooltip})
	tooltipLib:AddCallback({type = "item", callback = private.LoadTooltip})
	tooltipLib:RegisterTooltip(GameTooltip)
	tooltipLib:RegisterTooltip(ItemRefTooltip)
	tooltipLib:RegisterTooltip(BattlePetTooltip)
	local orig = OpenMailAttachment_OnEnter
	OpenMailAttachment_OnEnter = function(self, index)
		private.lastMailTooltipUpdate = private.lastMailTooltipUpdate or 0
		if private.lastMailTooltipIndex ~= index or private.lastMailTooltipUpdate + 0.1 < GetTime() then
			private.lastMailTooltipUpdate = GetTime()
			private.lastMailTooltipIndex = index
			orig(self, index)
		end
	end
end

local tooltipLines = {lastUpdate = 0}
local function GetTooltipLines(itemString, quantity)
	if tooltipLines.itemString ~= itemString or tooltipLines.quantity ~= quantity or (tooltipLines.lastUpdate + 0.5) < GetTime() then
		wipe(tooltipLines)
		for _, moduleName in ipairs(moduleNames) do
			if moduleObjects[moduleName].GetTooltip then
				local moduleLines = moduleObjects[moduleName]:GetTooltip(itemString, quantity)
				if type(moduleLines) ~= "table" then moduleLines = {} end
				for _, line in ipairs(moduleLines) do
					tinsert(tooltipLines, line)
				end
			end
		end
		tooltipLines.itemString = itemString
		tooltipLines.quantity = quantity
		tooltipLines.lastUpdate = GetTime()
	end
	return tooltipLines
end

function private.LoadTooltip(tipFrame, link, quantity)
	local itemString = TSMAPI:GetItemString(link)
	if not itemString then return end
	local lines = GetTooltipLines(itemString, quantity)
	if #lines > 0 then
		tooltipLib:AddLine(tipFrame, " ", 1, 1, 0, true)
		local r, g, b = unpack(TSM.db.profile.design.inlineColors.tooltip or { 130, 130, 250 })

		for i = 1, #lines do
			if type(lines[i]) == "table" then
				tooltipLib:AddDoubleLine(tipFrame, lines[i].left, lines[i].right, r / 255, g / 255, b / 255, r / 255, g / 255, b / 255, true)
			else
				tooltipLib:AddLine(tipFrame, lines[i], r / 255, g / 255, b / 255, true)
			end
		end
		tooltipLib:AddLine(tipFrame, " ", 1, 1, 0, true)
	end
end


-- **************************************************************************
--                             TSM Tooltip Options
-- **************************************************************************

function TSM:RegisterTooltipInfo(module, info)
	info = CopyTable(info)
	info.module = module
	tinsert(private.tooltipInfo, info)
end

function TSMAPI:GetMoneyCoinsTooltip()
	return TSM.db.profile.moneyCoinsTooltip
end

local loadTooltipOptionsTab
function TSM:LoadTooltipOptions(parent)
	local tabs = {}
	local next = next

	for _, info in ipairs(private.tooltipInfo) do
		tinsert(tabs, { text = info.module, value = info.module })
	end

	if next(tabs) then
		sort(tabs, function(a, b)
			return a.text < b.text
		end)
	end

	tinsert(tabs, 1, { text = L["Help / Options"], value = L["Help"] })

	local tabGroup = AceGUI:Create("TSMTabGroup")
	tabGroup:SetLayout("Fill")
	tabGroup:SetTabs(tabs)
	tabGroup:SetCallback("OnGroupSelected", function(_, _, value)
		tabGroup:ReleaseChildren()
		if value == "Help" then
			private:DrawTooltipHelp(tabGroup)
		else
			for _, info in ipairs(private.tooltipInfo) do
				if info.module == value then
					info.callback(tabGroup, loadTooltipOptionsTab and loadTooltipOptionsTab.tooltip)
				end
			end
		end
	end)
	parent:AddChild(tabGroup)

	tabGroup:SelectTab(loadTooltipOptionsTab and loadTooltipOptionsTab.module or "Help")
end

function private:DrawTooltipHelp(container)
	local priceSources = TSMAPI:GetPriceSources()
	priceSources["Crafting"] = nil
	priceSources["VendorBuy"] = nil
	priceSources["VendorSell"] = nil
	priceSources["Disenchant"] = nil
	local page = {
		{
			-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					title = L["Help"],
					layout = "List",
					children = {
						{
							type = "Label",
							relativeWidth = 1,
							text = L["Use the tabs above to select the module for which you'd like to configure tooltip options."],
						},
					},
				},
				{
					type = "InlineGroup",
					layout = "flow",
					title = L["General Options"],
					children = {
						{
							type = "Label",
							text = L["Display prices in tooltips as:"],
							relativeWidth = 0.25,
						},
						{
							type = "CheckBox",
							label = L["Coins:"],
							relativeWidth = 0.1,
							settingInfo = {TSM.db.profile, "moneyCoinsTooltip"},
							callback = function(_, _, value)
								if value == true then
									TSM.db.profile.moneyTextTooltip = false
								end
								container:ReloadTab()
							end,
						},
						{
							type = "Label",
							relativeWidth = 0.15,
							text = TSMAPI:FormatTextMoneyIcon(3451267, "|cffffffff", false, true),
						},
						{
							type = "CheckBox",
							label = L["Text:"],
							relativeWidth = 0.1,
							settingInfo = {TSM.db.profile, "moneyTextTooltip"},
							callback = function(_, _, value)
								if value == true then
									TSM.db.profile.moneyCoinsTooltip = false
								end
								container:ReloadTab()
							end,
						},
						{
							type = "Label",
							text = TSMAPI:FormatTextMoney(3451267, "|cffffffff", false, true),
						},
						{
							type = "HeadingLine",
						},
						{
							type = "CheckBox",
							label = L["Display Group / Operation Info in Tooltips"],
							relativeWidth = 1,
							settingInfo = {TSM.db.profile, "tooltip"},
						},
						{
							type = "CheckBox",
							label = L["Display disenchant value in tooltip."],
							settingInfo = { TSM.db.profile, "deTooltip" },
							tooltip = L["If checked, the disenchant value of the item will be shown. This value is calculated using the average market value of materials the item will disenchant into."],
						},
						{
							type = "Dropdown",
							label = L["Disenchant source:"],
							settingInfo = {TSM.db.profile, "deValueSource"},
							list = priceSources,
							relativeWidth = 0.49,
							tooltip = L["Select the price source for calculating disenchant value."],
						},
						{
							type = "CheckBox",
							label = L["Display vendor buy price in tooltip."],
							relativeWidth = 1,
							settingInfo = { TSM.db.profile, "vendorBuyTooltip" },
							tooltip = L["If checked, the price of buying the item from a vendor is displayed."],
						},
						{
							type = "CheckBox",
							label = L["Display vendor sell price in tooltip."],
							relativeWidth = 1,
							settingInfo = { TSM.db.profile, "vendorSellTooltip" },
							tooltip = L["If checked, the price of selling the item to a vendor displayed."],
						},
					},
				},
			},
		},
	}
	
	if next(TSM.db.global.customPriceSources) then
		local inlineGroup = {
			type = "InlineGroup",
			layout = "flow",
			title = L["Custom Price Sources"],
			children = {
				{
					type = "Label",
					text = L["Custom price sources to display in item tooltips:"],
					relativeWidth = 1,
				},
			},
		}
		for name in pairs(TSM.db.global.customPriceSources) do
			local checkbox = {
				type = "CheckBox",
				label = name,
				relativeWidth = 0.5,
				settingInfo = { TSM.db.global.customPriceTooltips, name },
				tooltip = L["If checked, this custom price will be displayed in item tooltips."],
			}
			tinsert(inlineGroup.children, checkbox)
		end
		tinsert(page[1].children, inlineGroup)
	end

	TSMAPI:BuildPage(container, page)
end