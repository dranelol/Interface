local AuctionProfitMaster = select(2, ...)
local Status = AuctionProfitMaster:NewModule("Status", "AceEvent-3.0")
local L = AuctionProfitMaster.L
local status = AuctionProfitMaster.status
local statusList, scanList, tempList = {}, {}, {}

local function sortByGroup(a, b)
	return AuctionProfitMaster.Manage.reverseLookup[a] < AuctionProfitMaster.Manage.reverseLookup[b]
end

function Status:OutputResults()
	table.sort(statusList, sortByGroup)
	
	for _, itemID in pairs(statusList) do
		local itemLink = select(2, GetItemInfo(itemID))
		local lowestBuyout, lowestBid, lowestOwner = AuctionProfitMaster.Scan:GetLowestAuction(itemID)
		if( lowestBuyout ) then
			local quantity = AuctionProfitMaster.Scan:GetTotalItemQuantity(itemID)
			local playerQuantity = AuctionProfitMaster.Scan:GetPlayerItemQuantity(itemID)
			
			AuctionProfitMaster:Log(itemID .. "statusres", string.format(L["%s lowest buyout %s (threshold %s), total posted |cfffed000%d|r (%d by you)"], itemLink, AuctionProfitMaster:FormatTextMoney(lowestBuyout, true), AuctionProfitMaster:FormatTextMoney(AuctionProfitMaster.Manage:GetConfigValue(itemID, "threshold"), true), quantity, playerQuantity))
		else
			AuctionProfitMaster:Log(itemID .. "statusres", string.format(L["Cannot find data for %s."], itemLink or itemID))
		end
	end
	
	AuctionProfitMaster:Log("statusresdone", L["Finished status report"])
	AuctionProfitMaster:UnlockButtons()
end

function Status:StartLog()
	self:RegisterMessage("APM_QUERY_UPDATE")
	self:RegisterMessage("APM_START_SCAN")
	self:RegisterMessage("APM_STOP_SCAN")
end

function Status:StopLog()
	self:UnregisterMessage("APM_QUERY_UPDATE")
	self:UnregisterMessage("APM_START_SCAN")
	self:UnregisterMessage("APM_STOP_SCAN")
end

function Status:Scan()
	self:StartLog()
	
	table.wipe(statusList)
	table.wipe(scanList)
	table.wipe(tempList)
	
	AuctionProfitMaster.Manage:UpdateReverseLookup()
	
	for bag=0, 4 do
		if( AuctionProfitMaster:IsValidBag(bag) ) then
			for slot=1, GetContainerNumSlots(bag) do
				local link = AuctionProfitMaster:GetSafeLink(GetContainerItemLink(bag, slot))
				if( link and AuctionProfitMaster.Manage.reverseLookup[link] ) then
					tempList[link] = true
				end
			end
		end
	end
	
	-- Add a scan based on items in the AH that match
	for i=1, GetNumAuctionItems("owner") do
		if( select(13, GetAuctionItemInfo("owner", i)) == 0 ) then
			local link = AuctionProfitMaster:GetSafeLink(GetAuctionItemLink("owner", i))
			if( link and AuctionProfitMaster.Manage.reverseLookup[link] ) then
				tempList[link] = true
			end
		end
	end
	
	for itemID in pairs(tempList) do
		table.insert(statusList, itemID)
	end
	
	if( #(statusList) == 0 ) then
		AuctionProfitMaster:Log("statusstatusmushroommushroom", L["No auctions or inventory items found that are managed by Auction Profit Master that can be scanned."])
		return
	end
		
	for _, itemID in pairs(statusList) do
		table.insert(scanList, (GetItemInfo(itemID)))
	end
	
	AuctionProfitMaster.Scan:StartItemScan(scanList)
end

function Status:Stop()
	table.wipe(statusList)
	self:StopLog()
end

-- Log handler
function Status:APM_QUERY_UPDATE(event, type, filter, ...)
	if( not filter ) then return end
	
	if( type == "retry" ) then	
		local page, totalPages, retries, maxRetries = ...
		AuctionProfitMaster:Log(filter .. "query", string.format(L["Retry |cfffed000%d|r of |cfffed000%d|r for %s"], retries, maxRetries, filter))
	elseif( type == "page" ) then
		local page, totalPages = ...
		AuctionProfitMaster:Log(filter .. "query", string.format(L["Scanning page |cfffed000%d|r of |cfffed000%d|r for %s"], page, totalPages, filter))
	elseif( type == "done" ) then
		local page, totalPages = ...
		AuctionProfitMaster:Log(filter .. "query", string.format(L["Scanned page |cfffed000%d|r of |cfffed000%d|r for %s"], page, totalPages, filter))
	elseif( type == "next" ) then
		AuctionProfitMaster:Log(filter .. "query", string.format(L["Scanning %s"], filter))
	end
end

function Status:APM_START_SCAN(event, type, total)
	AuctionProfitMaster:WipeLog()
	AuctionProfitMaster:Log("scanstatus", string.format(L["Scanning |cfffed000%d|r items..."], total or 0))
end

function Status:APM_STOP_SCAN(event, interrupted)
	self:StopLog()

	if( interrupted ) then
		AuctionProfitMaster:Log("scaninterrupt", L["Scan interrupted before it could finish"])
		return
	end

	AuctionProfitMaster:Log("scandone", L["Scan finished!"], true)
	
	self:OutputResults()
end