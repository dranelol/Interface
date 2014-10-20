-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_AuctionDB                           --
--           http://www.curse.com/addons/wow/tradeskillmaster_auctiondb           --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_AuctionDB", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_AuctionDB") -- loads the localization table

TSM.MAX_AVG_DAY = 1
local SECONDS_PER_DAY = 60 * 60 * 24

TSM.GLOBAL_PRICE_INFO = {
	{
		source = "DBGlobalMarketAvg",
		sourceLabel = L["AuctionDB - Global Market Value Average (via TSM App)"],
		sourceArg = "globalMarketValue",
		tooltipText = L["Global Market Value Avg:"],
		tooltipText2 = L["Global Market Value Avg x%s:"],
		tooltipKey = "globalMarketValueAvgTooltip",
	},
	{
		source = "DBGlobalMinBuyoutAvg",
		sourceLabel = L["AuctionDB - Global Minimum Buyout Average (via TSM App)"],
		sourceArg = "globalMinBuyout",
		tooltipText = L["Global Min Buyout Avg:"],
		tooltipText2 = L["Global Min Buyout Avg x%s:"],
		tooltipKey = "globalMinBuyoutAvgTooltip",
	},
	{
		source = "DBGlobalSaleAvg",
		sourceLabel = L["AuctionDB - Global Sale Average (via TSM App)"],
		sourceArg = "globalSale",
		tooltipText = L["Global Sale Average:"],
		tooltipText2 = L["Global Sale Average x%s:"],
		tooltipKey = "globalSaleAvgTooltip",
	},
}

local savedDBDefaults = {
	realm = {
		scanData = "",
		time = 0,
		lastCompleteScan = 0,
		appDataUpdate = 0,
	},
	profile = {
		tooltip = true,
		resultsPerPage = 50,
		resultsSortOrder = "ascending",
		resultsSortMethod = "name",
		hidePoorQualityItems = true,
		marketValueTooltip = true,
		minBuyoutTooltip = true,
		globalMarketValueAvgTooltip = true,
		globalMinBuyoutAvgTooltip = true,
		globalSaleAvgTooltip = true,
		showAHTab = true,
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- just blow away old factionrealm data for 6.0.1
	if TradeSkillMaster_AuctionDBDB then
		if TradeSkillMaster_AuctionDBDB.factionrealm then
			TradeSkillMaster_AuctionDBDB.factionrealm = nil
		end
	end

	-- load the savedDB into TSM.db
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_AuctionDBDB", savedDBDefaults, true)

	-- make easier references to all the modules
	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end

	-- register this module with TSM
	TSM:RegisterModule()
	--TSM.db.realm.time = 10 -- because AceDB won't save if we don't do this...

	TSM.scanData = {}
	TSM.data = TSM.scanData
	TSM:Deserialize(TSM.db.realm.scanData, TSM.scanData)
end

-- registers this module with TSM by first setting all fields and then calling TSMAPI:NewModule().
function TSM:RegisterModule()
	TSM.priceSources = {
		{ key = "DBMarket", label = L["AuctionDB - Market Value"], callback = "GetMarketValue" },
		{ key = "DBMinBuyout", label = L["AuctionDB - Minimum Buyout"], callback = "GetMinBuyout" },
	}
	for _, info in pairs(TSM.GLOBAL_PRICE_INFO) do
		tinsert(TSM.priceSources, { key = info.source, label = info.sourceLabel, callback = "GetGlobalPrice", arg = info.sourceArg })
	end
	TSM.icons = {
		{ side = "module", desc = "AuctionDB", slashCommand = "auctiondb", callback = "Config:Load", icon = "Interface\\Icons\\Inv_Misc_Platnumdisks" },
	}
	if TSM.db.profile.showAHTab then
		TSM.auctionTab = { callbackShow = "GUI:Show", callbackHide = "GUI:Hide" }
	end
	TSM.slashCommands = {
		{ key = "adbreset", label = L["Resets AuctionDB's scan data"], callback = "Reset" },
	}
	TSM.moduleAPIs = {
		{ key = "lastCompleteScan", callback = TSM.GetLastCompleteScan },
		{ key = "lastCompleteScanTime", callback = TSM.GetLastCompleteScanTime },
		{ key = "adbScans", callback = TSM.GetScans },
	}
	TSM.tooltipOptions = { callback = "Config:LoadTooltipOptions" }
	TSMAPI:NewModule(TSM)
end

function TSM:LoadAuctionData()
	local function LoadDataThread(self, itemIDs)
		local currentDay = TSM.Data:GetDay()
		for _, itemID in ipairs(itemIDs) do
			TSM:DecodeItemData(itemID)
			if type(TSM.scanData[itemID].scans) == "table" then
				local temp = {}
				for i = 0, 14 do
					if i <= TSM.MAX_AVG_DAY then
						temp[currentDay - i] = TSM.Data:ConvertScansToAvg(TSM.scanData[itemID].scans[currentDay - i])
					else
						local dayScans = TSM.scanData[itemID].scans[currentDay - i]
						if type(dayScans) == "table" then
							if dayScans.avg then
								temp[currentDay - i] = dayScans.avg
							else
								-- old method
								temp[currentDay - i] = TSM.Data:GetAverage(dayScans)
							end
						elseif type(dayScans) == "number" then
							temp[currentDay - i] = dayScans
						end
					end
				end
				TSM.scanData[itemID].scans = temp
			end
			TSM:EncodeItemData(itemID)
			self:Yield()
		end
	end

	local itemIDs = {}
	for itemID in pairs(TSM.scanData) do
		tinsert(itemIDs, itemID)
	end
	TSMAPI.Threading:Start(LoadDataThread, 0.1, nil, itemIDs)
end

function TSM:OnEnable()
	if TSM.AppData2 then
		local temp = {}
		for key, data in pairs(TSM.AppData2) do
			temp[strlower(key)] = data
		end
		TSM.AppData2 = temp
		local realm = strlower(GetRealmName() or "")
		if TSM.AppData2[realm] then
			TSM.db.realm.appDataUpdate = TSM.AppData2[realm].downloadTime
			TSM.db.realm.lastCompleteScan = TSM.AppData2[realm].downloadTime
			local fields = TSM.AppData2[realm].fields
			TSM.appData = {}
			for _, data in ipairs(TSM.AppData2[realm].data) do
				local temp = {}
				local itemID
				for i, key in ipairs(fields) do
					if key == "itemId" then
						itemID = data[i]
					else
						temp[key] = data[i]
					end
				end
				if itemID then
					TSM.appData[itemID] = temp
				else
					error("Invalid import data.")
				end
			end
			TSM.data = TSM.appData
		end
		if TSM.AppData2.global then
			local fields = TSM.AppData2.global.fields
			TSM.appData = TSM.appData or {}
			for _, data in ipairs(TSM.AppData2.global.data) do
				local temp = {}
				local itemID
				for i, key in ipairs(fields) do
					if key == "itemId" then
						itemID = data[i]
					else
						temp[key] = data[i]
					end
				end
				if itemID then
					TSM.appData[itemID] = TSM.appData[itemID] or {}
					for key, value in pairs(temp) do
						TSM.appData[itemID][key] = value
					end
				else
					error("Invalid import data.")
				end
			end
			TSM.data = TSM.appData
		end
		TSM.AppData2 = nil
	end
	if TSM.appData then
		TSM.scanData = {}
	else
		TSM:LoadAuctionData()
	end
end

function TSM:OnTSMDBShutdown()
	TSM:Serialize(TSM.scanData)
end

function TSM:GetTooltip(itemString, quantity)
	if not TSM.db.profile.tooltip then return end
	if not strfind(itemString, "item:") then return end
	local itemID = TSMAPI:GetItemID(itemString)
	if not itemID or not TSM.data[itemID] then return end
	local text = {}
	local moneyCoinsTooltip = TSMAPI:GetMoneyCoinsTooltip()
	quantity = quantity or 1

	local function InsertValueText(str, strAlt, value)
		if not value then return end
		if moneyCoinsTooltip then
			if IsShiftKeyDown() then
				tinsert(text, { left = "  " .. format(strAlt, quantity), right = TSMAPI:FormatTextMoneyIcon(value * quantity, "|cffffffff", true) })
			else
				tinsert(text, { left = "  " .. str, right = TSMAPI:FormatTextMoneyIcon(value, "|cffffffff", true) })
			end
		else
			if IsShiftKeyDown() then
				tinsert(text, { left = "  " .. format(strAlt, quantity), right = TSMAPI:FormatTextMoney(value * quantity, "|cffffffff", true) })
			else
				tinsert(text, { left = "  " .. str, right = TSMAPI:FormatTextMoney(value, "|cffffffff", true) })
			end
		end
	end

	-- add market value info
	if TSM.db.profile.marketValueTooltip then
		InsertValueText(L["Market Value:"], L["Market Value x%s:"], TSM:GetMarketValue(itemID))
	end

	-- add min buyout info
	if TSM.db.profile.minBuyoutTooltip then
		InsertValueText(L["Min Buyout:"], L["Min Buyout x%s:"], TSM:GetMinBuyout(itemID))
	end

	-- add global price info
	for _, info in ipairs(TSM.GLOBAL_PRICE_INFO) do
		if TSM.db.profile[info.tooltipKey] then
			InsertValueText(info.tooltipText, info.tooltipText2, TSM:GetGlobalPrice(itemID, info.sourceArg))
		end
	end

	-- add heading and last scan time info
	if #text > 0 then
		local lastScan = TSM:GetLastScanTime(itemID)
		if lastScan then
			local timeDiff = SecondsToTime(time() - lastScan)
			tinsert(text, 1, { left = "|cffffff00" .. "TSM AuctionDB:", right = "|cffffffff" .. format(L["%s ago"], timeDiff) })
		else
			tinsert(text, 1, { left = "|cffffff00" .. "TSM AuctionDB:", right = "|cffffffff" .. L["Not Scanned"] })
		end
		return text
	end
end

function TSM:Reset()
	-- Popup Confirmation Window used in this module
	StaticPopupDialogs["TSMAuctionDBClearDataConfirm"] = StaticPopupDialogs["TSMAuctionDBClearDataConfirm"] or {
		text = L["Are you sure you want to clear your AuctionDB data?"],
		button1 = YES,
		button2 = CANCEL,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		OnAccept = function()
			TSM.db.realm.appDataUpdate = TSM.db.realm.appDataUpdate or 0
			TSM.db.realm.lastCompleteScan = TSM.db.realm.appDataUpdate
			for i in pairs(TSM.scanData) do
				TSM.scanData[i] = nil
			end
			TSM:Print(L["Reset Data"])
		end,
		OnCancel = false,
	}

	StaticPopup_Show("TSMAuctionDBClearDataConfirm")
	for i = 1, 10 do
		local popup = _G["StaticPopup" .. i]
		if popup and popup.which == "TSMAuctionDBClearDataConfirm" then
			popup:SetFrameStrata("TOOLTIP")
			break
		end
	end
end

local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_="
local base = #alpha
local alphaTable = {}
local alphaTableLookup = {}
for i = 1, base do
	local char = strsub(alpha, i, i)
	tinsert(alphaTable, char)
	alphaTableLookup[char] = i
end

local function decode(h)
	if strfind(h, "~") then return end
	local result = 0

	local len = #h
	for j = len - 1, 0, -1 do
		if not alphaTableLookup[strsub(h, len - j, len - j)] then error(h .. " at index " .. len - j) end
		result = result + (alphaTableLookup[strsub(h, len - j, len - j)] - 1) * (base ^ j)
		j = j - 1
	end

	return result
end

local function encode(d)
	d = tonumber(d)
	if not d or not (d < math.huge and d > 0) then -- this cannot be simplified since 0/0 is neither less than nor greater than any number
		return "~"
	end

	local r = d % base
	local diff = d - r
	if diff == 0 then
		return alphaTable[r + 1]
	else
		return encode(diff / base) .. alphaTable[r + 1]
	end
end

local function encodeScans(scans)
	local tbl, tbl2 = {}, {}
	for day, data in pairs(scans) do
		if type(data) == "table" and data.count and data.avg then
			data = encode(data.avg) .. "@" .. encode(data.count)
		elseif type(data) == "table" then
			-- Old method of encoding scans
			for i = 1, #data do
				tbl2[i] = encode(data[i])
			end
			data = table.concat(tbl2, ";", 1, #data)
		else
			data = encode(data)
		end
		tinsert(tbl, encode(day) .. ":" .. data)
	end
	return table.concat(tbl, "!")
end

local function decodeScans(rope)
	if rope == "A" then return end
	local scans = {}
	local days = { ("!"):split(rope) }
	local currentDay = TSM.Data:GetDay()
	for _, data in ipairs(days) do
		local day, marketValueData = (":"):split(data)
		day = decode(day)
		scans[day] = {}
		if strfind(marketValueData, "@") then
			local avg, count = ("@"):split(marketValueData)
			avg = decode(avg)
			count = decode(count)
			if avg ~= "~" and count ~= "~" then
				if abs(currentDay - day) <= TSM.MAX_AVG_DAY then
					scans[day].avg = avg
					scans[day].count = count
				else
					scans[day] = avg
				end
			end
		else
			-- Old method of decoding scans
			for _, value in ipairs({ (";"):split(marketValueData) }) do
				local decodedValue = decode(value)
				if decodedValue ~= "~" then
					tinsert(scans[day], tonumber(decodedValue))
				end
			end
			if day ~= currentDay then
				scans[day] = TSM.Data:GetAverage(scans[day])
			end
		end
	end

	return scans
end

function TSM:Serialize()
	local results = {}
	for itemID, data in pairs(TSM.scanData) do
		if not data.encoded then
			-- should never get here, but just in-case
			TSM:EncodeItemData(itemID)
		end
		if data.encoded then
			tinsert(results, "?" .. encode(itemID) .. "," .. data.encoded)
		end
	end
	TSM.db.realm.scanData = table.concat(results)
end

function TSM:Deserialize(data, resultTbl, fullyDecode)
	if strsub(data, 1, 1) ~= "?" then return end

	for k, a, b, c, d, e, f in gmatch(data, "?([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^?]+)") do
		local itemID = decode(k)
		resultTbl[itemID] = { encoded = strjoin(",", a, b, c, d, e, f) }
		if fullyDecode then
			TSM:DecodeItemData(itemID, resultTbl)
		end
	end
end

function TSM:EncodeItemData(itemID, tbl)
	tbl = tbl or TSM.scanData
	local data = tbl[itemID]
	if data and data.marketValue then
		data.encoded = strjoin(",", encode(0), encode(data.marketValue), encode(data.lastScan), encode(0), encode(data.minBuyout), encodeScans(data.scans))
	end
end

function TSM:DecodeItemData(itemID, tbl)
	tbl = tbl or TSM.scanData
	local data = tbl[itemID]
	if data and data.encoded and not data.marketValue then
		local a, b, c, d, e, f = (","):split(data.encoded)
		data.marketValue = decode(b)
		data.lastScan = decode(c)
		data.minBuyout = decode(e)
		data.scans = decodeScans(f)
	end
end

function TSM:GetLastCompleteScan()
	local lastScan = {}
	for itemID, data in pairs(TSM.data) do
		if TSM.data == TSM.scanData then
			TSM:DecodeItemData(itemID)
		end
		if data.lastScan == TSM.db.realm.lastCompleteScan or (not data.lastScan and data.minBuyout) then
			lastScan[itemID] = { marketValue = data.marketValue, minBuyout = data.minBuyout }
		end
	end

	return lastScan
end

function TSM:GetLastCompleteScanTime()
	return TSM.db.realm.lastCompleteScan
end

function TSM:GetScans(link)
	if not link then return end
	link = select(2, GetItemInfo(link))
	if not link then return end
	local itemID = TSMAPI:GetItemID(link)
	if not TSM.scanData[itemID] then return end
	TSM:DecodeItemData(itemID)

	return CopyTable(TSM.scanData[itemID].scans)
end

function TSM:GetMarketValue(itemID)
	if itemID and not tonumber(itemID) then
		itemID = TSMAPI:GetItemID(itemID)
	end
	if not itemID or not TSM.data[itemID] then return end
	if TSM.data == TSM.scanData then
		TSM:DecodeItemData(itemID)
		if not TSM.scanData[itemID].marketValue or TSM.scanData[itemID].marketValue == 0 then
			TSM.scanData[itemID].marketValue = TSM.Data:GetMarketValue(TSM.scanData[itemID].scans)
		end
	end
	return TSM.data[itemID].marketValue ~= 0 and TSM.data[itemID].marketValue or nil
end

function TSM:GetGlobalPrice(itemID, key)
	if TSM.data == TSM.scanData then return end
	if itemID and not tonumber(itemID) then
		itemID = TSMAPI:GetItemID(itemID)
	end
	if not itemID or not TSM.data[itemID] then return end
	return TSM.data[itemID][key] and TSM.data[itemID][key] ~= 0 and TSM.data[itemID][key] or nil
end

function TSM:GetLastScanTime(itemID)
	if TSM.data == TSM.scanData then
		TSM:DecodeItemData(itemID)
		return itemID and TSM.scanData[itemID].lastScan
	else
		return TSM.db.realm.appDataUpdate
	end
end

function TSM:GetMinBuyout(itemID)
	if itemID and not tonumber(itemID) then
		itemID = TSMAPI:GetItemID(itemID)
	end
	if not itemID or not TSM.data[itemID] then return end
	if TSM.data == TSM.scanData then
		TSM:DecodeItemData(itemID)
	end
	local minBuyout = TSM.data[itemID].minBuyout
	return minBuyout and minBuyout > 0 and minBuyout or nil
end