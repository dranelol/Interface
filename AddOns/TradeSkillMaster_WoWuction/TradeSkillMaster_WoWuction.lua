-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_WoWuction                           --
--           http://www.curse.com/addons/wow/tradeskillmaster_wowuction           --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_WoWuction", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_WoWuction") -- loads the localization table
local private = {}
TSMAPI:RegisterForTracing(private, "TradeSkillMaster_WoWuction_private")

local savedDBDefaults = {
	profile = {
		tooltip = true,
		marketValue = true,
		medianPrice = true,
		dailySold = true,
		regionMarketValue = true,
		regionMedianPrice = true,
		regionDailyAvg = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_WoWuctionDB", savedDBDefaults, true)
	-- register this module with TSM
	TSM:RegisterModule()
end

-- registers this module with TSM by first setting all fields and then calling TSMAPI:NewModule().
function TSM:RegisterModule()
	TSM.priceSources = {
		{ key = "wowuctionMarket", label = L["WoWuction Realm Market Value"], callback = private.GetData, arg = "marketValue" },
		{ key = "wowuctionMedian", label = L["WoWuction Realm Median Price"], callback = private.GetData, arg = "medianPrice" },
		{ key = "wowuctionRegionMarket", label = L["WoWuction Region Market Value"], callback = private.GetData, arg = "regionMarketValue" },
		{ key = "wowuctionRegionMedian", label = L["WoWuction Region Median Price"], callback = private.GetData, arg = "regionMedianPrice" },
	}
	TSM.moduleAPIs = {
		{ key = "wowuctionLastScan", callback = "GetLastCompleteScan" },
		{ key = "wowuctionLastScanTime", callback = "GetLastScanTime" },
	}
	TSM.tooltipOptions = { callback = "LoadTooltipOptions" }

	TSMAPI:NewModule(TSM)
end

function TSM:OnEnable()
	local realms = { GetRealmName(), "region" }
	local realm = strlower(GetRealmName())
	local faction = strlower(UnitFactionGroup("player") or "")
	local extractedData = {}
	local hasData = false
	
	if TSM.AppData then
		local temp = {}
		for key, data in pairs(TSM.AppData) do
			if key ~= "lastUpdate" then
				temp[strlower(key)] = data
			else
				temp[key] = data
			end
			TSM.AppData = temp
		end
	end

	if TSM.AppData and (TSM.AppData[faction] or TSM.AppData[realm]) then
		hasData = true
		local sets = {faction, realm}
		for _, set in ipairs(sets) do
			if TSM.AppData[set] then
				local fields = TSM.AppData[set].fields
				for _, itemData in ipairs(TSM.AppData[set].data) do
					local itemID = itemData[1]
					extractedData[itemID] = extractedData[itemID] or {}
					for i=2, #itemData do
						local key = fields[i]
						if key == "regionAvgDailyQuantityX100" then
							key = "regionAvgDailyQuantity"
							itemData[i] = itemData[i] / 100
						elseif key == "dailySoldX100" then
							key = "dailySold"
							itemData[i] = itemData[i] / 100
						end
						extractedData[itemID][key] = itemData[i]
					end
				end
			end
		end
		extractedData.lastUpdate = TSM.AppData.lastUpdate
	elseif TSM.data then
		for _, realm in ipairs(realms) do
			if TSM.data[realm] and TSM.data[realm][faction] then
				extractedData.lastUpdate = extractedData.lastUpdate or TSM.data[realm].lastUpdate
				if #TSM.data[realm][faction] > 0 then
					for _, itemData in ipairs(TSM.data[realm][faction]) do
						local itemID = itemData[1] -- itemID always in the first slot
						extractedData[itemID] = extractedData[itemID] or {}
						for i = 2, #itemData do
							local key = TSM.data[realm].fields[i]
							if key == "regionAvgDailyQuantityX100" then
								key = "regionAvgDailyQuantity"
								itemData[i] = itemData[i] / 100
							elseif key == "dailySoldX100" then
								key = "dailySold"
								itemData[i] = itemData[i] / 100
							end
							extractedData[itemID][key] = itemData[i]
						end
						hasData = true
					end
				else
					hasData = true
					extractedData = CopyTable(TSM.data[realm][faction])
				end
			end
		end
		wipe(TSM.data)
	end
	if not hasData then
		TSM:Print(L["No wowuction data found. Go to the \"Data Export\" page for your realm on wowuction.com to download data."])
	end

	TSM.data = nil
	private.data = extractedData
end

function TSM:GetTooltip(itemString)
	if not TSM.db.profile.tooltip then return end
	if not strfind(itemString, "item:") then return end
	local itemID = TSMAPI:GetItemID(itemString)
	if not itemID then return end
	local data = private.GetData(itemID)
	local moneyCoinsTooltip = TSMAPI:GetMoneyCoinsTooltip()

	local text = {}
	if not data then return end
	if TSM.db.profile.marketValue then
		if data.marketValue and data.marketValue > 0 then
			if moneyCoinsTooltip then
				tinsert(text, { left = "  " .. L["Realm Market Value:"], right = TSMAPI:FormatTextMoneyIcon(data.marketValue, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoneyIcon(data.marketValueErr, "|cffffffff", true) .. ")" })
			else
				tinsert(text, { left = "  " .. L["Realm Market Value:"], right = TSMAPI:FormatTextMoney(data.marketValue, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoney(data.marketValueErr, "|cffffffff", true) .. ")" })
			end
		end
	end
	if TSM.db.profile.medianPrice then
		if data.medianPrice and data.medianPrice > 0 then
			if moneyCoinsTooltip then
				tinsert(text, { left = "  " .. L["Realm Median Price:"], right = TSMAPI:FormatTextMoneyIcon(data.medianPrice, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoneyIcon(data.medianPriceErr, "|cffffffff", true) .. ")" })
			else
				tinsert(text, { left = "  " .. L["Realm Median Price:"], right = TSMAPI:FormatTextMoney(data.medianPrice, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoney(data.medianPriceErr, "|cffffffff", true) .. ")" })
			end
		end
	end
	if TSM.db.profile.dailySold then
		if data.dailySold and data.dailySold > 0 then
			tinsert(text, { left = "  " .. L["Realm Avg Daily Sold Qty:"], right = "|cffffffff" .. data.dailySold })
		end
	end
	if TSM.db.profile.regionMarketValue then
		if data.regionMarketValue and data.regionMarketValue > 0 then
			if moneyCoinsTooltip then
				tinsert(text, { left = "  " .. L["Region Market Value:"], right = TSMAPI:FormatTextMoneyIcon(data.regionMarketValue, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoneyIcon(data.regionMarketValueErr, "|cffffffff", true) .. ")" })
			else
				tinsert(text, { left = "  " .. L["Region Market Value:"], right = TSMAPI:FormatTextMoney(data.regionMarketValue, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoney(data.regionMarketValueErr, "|cffffffff", true) .. ")" })
			end
		end
	end
	if TSM.db.profile.regionMedianPrice then
		if data.regionMedianPrice and data.regionMedianPrice > 0 then
			if moneyCoinsTooltip then
				tinsert(text, { left = "  " .. L["Region Median Price:"], right = TSMAPI:FormatTextMoneyIcon(data.regionMedianPrice, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoneyIcon(data.regionMedianPriceErr , "|cffffffff", true) .. ")" })
			else
				tinsert(text, { left = "  " .. L["Region Median Price:"], right = TSMAPI:FormatTextMoney(data.regionMedianPrice, "|cffffffff", true) .. " (+/-" .. TSMAPI:FormatTextMoney(data.regionMedianPriceErr, "|cffffffff", true) .. ")" })
			end
		end
	end
	if TSM.db.profile.regionDailyAvg then
		if data.regionAvgDailyQuantity and data.regionAvgDailyQuantity > 0 then
			tinsert(text, { left = "  " .. L["Region Avg Daily Qty:"], right = "|cffffffff" .. data.regionAvgDailyQuantity })
		end
	end

	if #text > 0 then
		local lastScan = TSM:GetLastScanTime()
		if lastScan then
			local timeDiff = SecondsToTime(time() - lastScan)
			tinsert(text, 1, { left = "|cffffff00" .. "TSM WoWuction:", right = "|cffffffff" .. format(L["%s ago"], timeDiff) })
		else
			tinsert(text, 1, { left = "|cffffff00" .. "TSM WoWuction:", right = "|cffffffff" .. L["Not Scanned"] })
		end
		return text
	end
end

function private.GetData(itemID, key)
	if type(itemID) ~= "number" then itemID = TSMAPI:GetItemID(itemID) end

	local data
	if not (private.data and private.data[itemID] and (not key or private.data[itemID][key])) then return end

	data = private.data[itemID]

	if key then
		return data[key] > 0 and data[key]
	else
		return data
	end
end

function TSM:GetLastCompleteScan()
	if not private.data then return end

	local lastScan = {}
	for itemID, data in pairs(private.data) do
		if itemID ~= "lastUpdate" and data.marketValue and data.minBuyout then
			lastScan[itemID] = { marketValue = data.marketValue, minBuyout = data.minBuyout }
		end
	end

	return lastScan
end

function TSM:GetLastScanTime()
	return private.data and private.data.lastUpdate
end

function TSM:LoadTooltipOptions(container)
	local page = {
		{
			type = "SimpleGroup",
			layout = "Flow",
			fullHeight = true,
			children = {
				{
					type = "CheckBox",
					label = L["Enable display of WoWuction data in tooltip."],
					relativeWidth = 1,
					settingInfo = { TSM.db.profile, "tooltip" },
					callback = function(_, _, value)
						container:ReloadTab()
					end,
				},
				{
					type = "CheckBox",
					label = L["Display realm market price in tooltip."],
					disabled = not TSM.db.profile.tooltip,
					settingInfo = { TSM.db.profile, "marketValue" },
					tooltip = L["If checked, the market value of the item will be shown"],
				},
				{
					type = "CheckBox",
					label = L["Display realm median price in tooltip."],
					disabled = not TSM.db.profile.tooltip,
					settingInfo = { TSM.db.profile, "medianPrice" },
					tooltip = L["If checked, the median price of the item will be shown."],
				},
				{
					type = "CheckBox",
					label = L["Display realm average daily sold quantity in tooltip."],
					disabled = not TSM.db.profile.tooltip,
					settingInfo = { TSM.db.profile, "dailySold" },
					tooltip = L["If checked, the average daily sold quantity for your realm will be shown."],
				},
				{
					type = "CheckBox",
					label = L["Display region market value in tooltip."],
					disabled = not TSM.db.profile.tooltip,
					settingInfo = { TSM.db.profile, "regionMarketValue" },
					tooltip = L["If checked, the market value across the region of the item will be shown."],
				},
				{
					type = "CheckBox",
					label = L["Display region median price in tooltip."],
					disabled = not TSM.db.profile.tooltip,
					settingInfo = { TSM.db.profile, "regionMedianPrice" },
					tooltip = L["If checked, the median price across the region of the item will be shown."],
				},
				{
					type = "CheckBox",
					label = L["Display region average daily quantity in tooltips."],
					disabled = not TSM.db.profile.tooltip,
					settingInfo = { TSM.db.profile, "regionDailyAvg" },
					tooltip = L["If checked, the average daily quantity across the region will be shown."],
				},
			},
		},
	}

	TSMAPI:BuildPage(container, page)
end