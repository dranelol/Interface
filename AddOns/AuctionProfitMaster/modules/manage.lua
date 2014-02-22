local AuctionProfitMaster = select(2, ...)
local Manage = AuctionProfitMaster:NewModule("Manage", "AceEvent-3.0")
local L = AuctionProfitMaster.L
local status = AuctionProfitMaster.status
local reverseLookup, postQueue, scanList, tempList, stats = {}, {}, {}, {}, {}
local totalToCancel, totalCancelled = 0, 0
local cancelList = {}

Manage.reverseLookup = reverseLookup
Manage.stats = stats

function Manage:OnInitialize()
	self:RegisterMessage("APM_AH_CLOSED", "AuctionHouseClosed")
end

function Manage:AuctionHouseClosed()
	if( self.cancelFrame and self.cancelFrame:IsShown() ) then
		AuctionProfitMaster:Print(L["Cancelling interrupted due to Auction House being closed."])
		AuctionProfitMaster:Log("cancelstatus", L["Auction House closed before you could tell Auction Profit Master to cancel."])
		
		self:StopCancelling()
		self.cancelFrame:Hide()
	elseif( status.isCancelling and status.isScanning ) then
		self:StopCancelling()
	elseif( status.isManaging and not status.isCancelling ) then
		self:StopPosting()
	end
end

function Manage:GetBoolConfigValue(itemID, key)
	local val = reverseLookup[itemID] and AuctionProfitMaster.db.profile[key][reverseLookup[itemID]]
	if( val ~= nil ) then
		return val
	end
	
	return AuctionProfitMaster.db.profile[key].default
end

function Manage:IsNotDefault(itemID, key)
	return reverseLookup[itemID] and AuctionProfitMaster.db.profile[key][reverseLookup[itemID]]
end

function Manage:GetConfigValue(itemID, key)
	return reverseLookup[itemID] and AuctionProfitMaster.db.profile[key][reverseLookup[itemID]] or AuctionProfitMaster.db.profile[key].default
end

function Manage:UpdateReverseLookup()
	table.wipe(reverseLookup)
	
	for group, items in pairs(AuctionProfitMaster.db.global.groups) do
		if( not AuctionProfitMaster.db.profile.groupStatus[group] ) then
			for itemID in pairs(items) do
				reverseLookup[string.gsub(itemID, ":0:([-0-9]+):([-0-9]+):([-0-9]+):([-0-9]+):([-0-9]+):([-0-9]+)", "")] = group
			end
		end
	end
end

function Manage:StartLog()
	self:RegisterMessage("APM_QUERY_UPDATE")
	self:RegisterMessage("APM_START_SCAN")
	self:RegisterMessage("APM_STOP_SCAN")
end

function Manage:StopLog()
	self:UnregisterMessage("APM_QUERY_UPDATE")
	self:UnregisterMessage("APM_START_SCAN")
	self:UnregisterMessage("APM_STOP_SCAN")
end

function Manage:StopCancelling()
	self:StopLog()
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	AuctionProfitMaster:UnlockButtons()
	
	status.isCancelling = nil
	totalCancelled = 0
	totalToCancel = 0
end

function Manage:CancelScan()
	self:StartLog()
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:UpdateReverseLookup()
	AuctionProfitMaster:LockButtons()
	
	table.wipe(scanList)
	table.wipe(tempList)
	table.wipe(status)
	
	-- Add a scan based on items in the AH that match
	for i=1, GetNumAuctionItems("owner") do
		if( select(13, GetAuctionItemInfo("owner", i)) == 0 ) then
			local link = AuctionProfitMaster:GetSafeLink(GetAuctionItemLink("owner", i))
			if( reverseLookup[link] ) then
				tempList[GetAuctionItemInfo("owner", i)] = true
			end
		end
	end
	
	for name in pairs(tempList) do
		table.insert(scanList, name)
	end
	
	if( #(scanList) == 0 ) then
		AuctionProfitMaster:Log("cancelstatus", L["Nothing to cancel, you have no unsold auctions up."])
		AuctionProfitMaster:UnlockButtons()
		return
	end

	status.isCancelling = true
	status.totalScanQueue = #(scanList)
	status.queueTable = scanList
	AuctionProfitMaster.Scan:StartItemScan(scanList)
end

function Manage:CHAT_MSG_SYSTEM(event, msg)
	if msg == ERR_AUCTION_REMOVED then
		
		if( totalToCancel <= 0 ) then
			self:StopCancelling()
		else
			AuctionProfitMaster:Log("cancelprogress", string.format(L["Cancelling |cfffed000%d|r of |cfffed000%d|r"], totalCancelled - totalToCancel, totalCancelled))
		end
	end
end

function Manage:CancelMatch(match)
	AuctionProfitMaster:WipeLog()
	AuctionProfitMaster:LockButtons()
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	
	table.wipe(tempList)
	table.wipe(status)
	status.isCancelling = true
	
	local itemID = tonumber(string.match(match, "item:(%d+)"))
	if( itemID ) then
		match = GetItemInfo(itemID)
	end
	
	for i=1, GetNumAuctionItems("owner") do
		local name, _, _, _, _, _, _, _, buyout, _, _, _, wasSold = GetAuctionItemInfo("owner", i)     
		local itemLink = GetAuctionItemLink("owner", i)
		if( wasSold == 0 and string.match(string.lower(name), string.lower(match)) ) then
			if( not tempList[name] ) then
				tempList[name] = true
				AuctionProfitMaster:Log(name, string.format(L["Cancelled %s"], itemLink))
			end
			
			totalToCancel = totalToCancel + 1
			totalCancelled = totalCancelled + 1
			tinsert(cancelList, {index=i, name=name, buyout=buyout})
		end
	end
	
	if( totalToCancel == 0 ) then
		AuctionProfitMaster:Log("cancelstatus", string.format(L["Nothing to cancel, no matches found for \"%s\""], match))
		self:StopCancelling()
	else
		self:FinalCancel()
	end
end

function Manage:CancelAll(group, duration, price)
	AuctionProfitMaster:WipeLog()
	AuctionProfitMaster:LockButtons()
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:UpdateReverseLookup()

	table.wipe(tempList)
	table.wipe(status)

	status.isCancelling = true
	
	if( duration ) then
		AuctionProfitMaster:Log("masscancel", string.format(L["Mass cancelling posted items with less than %d hours left"], duration == 3 and 12 or 2))
	elseif( group ) then
		AuctionProfitMaster:Log("masscancel", string.format(L["Mass cancelling posted items in the group |cfffed000%s|r"], group))
	elseif( money ) then
		AuctionProfitMaster:Log("masscancel", string.format(L["Mass cancelling posted items below %s"], AuctionProfitMaster:FormatTextMoney(money)))
	else
		AuctionProfitMaster:Log("masscancel", L["Mass cancelling posted items"])
	end
	
	for i=1, GetNumAuctionItems("owner") do
		local name, _, _, _, _, _, _, _, buyoutPrice, _, _, _, wasSold = GetAuctionItemInfo("owner", i)     
		local timeLeft = GetAuctionItemTimeLeft("owner", i)
		local itemLink = GetAuctionItemLink("owner", i)
		local itemID = AuctionProfitMaster:GetSafeLink(itemLink)
		if( wasSold == 0 and ( group and reverseLookup[itemID] == group or not group ) and ( duration and timeLeft <= duration or not duration ) and ( price and buyoutPrice <= price or not price ) ) then
			if( name and not tempList[name] ) then
				tempList[name] = true
				AuctionProfitMaster:Log(name, string.format(L["Cancelled %s"], itemLink))
			end
			
			totalToCancel = totalToCancel + 1
			totalCancelled = totalCancelled + 1
			tinsert(cancelList, {index=i, name=name, buyout=buyoutPrice})
		end
	end
	
	if( totalToCancel == 0 ) then
		AuctionProfitMaster:Log("cancelstatus", L["Nothing to cancel"])
		AuctionProfitMaster:Print(L["Nothing to cancel"])
		self:StopCancelling()
	else
		self:FinalCancel()
	end
end

function Manage:Cancel(isTest)
	table.wipe(tempList)
	
	for i=1, GetNumAuctionItems("owner") do
		local name, _, quantity, _, _, _, bid, _, buyout, activeBid, highBidder, _, wasSold = GetAuctionItemInfo("owner", i)     
		local itemLink = GetAuctionItemLink("owner", i)
		local itemID = AuctionProfitMaster:GetSafeLink(itemLink)
		local lowestBuyout, lowestBid, lowestOwner, isWhitelist, isPlayer = AuctionProfitMaster.Scan:GetLowestAuction(itemID)
		
		-- The item is in a group that's not supposed to be cancelled
		if( wasSold == 0 and lowestOwner and self:GetBoolConfigValue(itemID, "noCancel") ) then
			if( not tempList[name] and not isTest ) then
				AuctionProfitMaster:Log(name .. "notcancel", string.format(L["Skipped cancelling %s flagged to not be canelled."], itemLink))
				tempList[name] = true
			end
		elseif( wasSold == 0 and lowestOwner and self:GetBoolConfigValue(itemID, "autoFallback") and lowestBuyout <= self:GetConfigValue(itemID, "threshold") ) then
			if( not tempList[name] and not isTest ) then
				AuctionProfitMaster:Log(name .. "notcancel", string.format(L["Skipped cancelling %s flagged to post at fallback when market is below threshold."], itemLink))
				tempList[name] = true
			end
		-- It is supposed to be cancelled!
		elseif( wasSold == 0 and lowestOwner ) then
			buyout = buyout / quantity
			bid = bid / quantity
			
			local threshold = self:GetConfigValue(itemID, "threshold")
			local fallback = self:GetConfigValue(itemID, "fallback")
			local priceDifference = AuctionProfitMaster.Scan:CompareLowestToSecond(itemID, lowestBuyout)
			local priceThreshold = self:GetConfigValue(itemID, "priceThreshold")
			
			-- Lowest is the player, and the difference between the players lowest and the second lowest are too far apart
			if( isPlayer and priceDifference and priceDifference >= priceThreshold ) then
				-- The item that the difference is too high is actually on the tier that was too high as well
				-- so cancel it, the reason this check is done here is so it doesn't think it undercut itself.
				local undercut = AuctionProfitMaster.Manage:GetConfigValue(itemID, "undercut")
				if( math.floor(lowestBuyout) == math.floor(buyout) and undercut ~= 0) then
					if( isTest ) then return true end
					
					if( not tempList[name] ) then
						tempList[name] = true
						AuctionProfitMaster:Log(name .. "diffcancel", string.format(L["Price threshold on %s at %s, second lowest is |cfffed000%d%%|r higher and above the |cfffed000%d%%|r threshold, cancelling"], itemLink, AuctionProfitMaster:FormatTextMoney(lowestBuyout, true), priceDifference * 100, priceThreshold * 100))
					end
	
					totalToCancel = totalToCancel + 1
					totalCancelled = totalCancelled + 1
					tinsert(cancelList, {index=i, name=name, buyout=buyout*quantity})
				end
				
			-- They aren't us (The player posting), or on our whitelist so easy enough
			-- They are on our white list, but they undercut us, OR they matched us but the bid is lower
			-- The player is the only one with it on the AH and it's below the threshold
			elseif( ( not isPlayer and not isWhitelist ) or
				( isWhitelist and ( buyout > lowestBuyout or ( buyout == lowestBuyout and lowestBid < bid ) ) ) or
				( AuctionProfitMaster.db.global.smartCancel and AuctionProfitMaster.Scan:IsPlayerOnly(itemID) and buyout < fallback ) ) then
				
				local undercutBuyout, undercutBid, undercutOwner
				if( AuctionProfitMaster.db.factionrealm.player[lowestOwner] ) then
					undercutBuyout, undercutBid, undercutOwner = AuctionProfitMaster.Scan:GetSecondLowest(itemID, lowestBuyout)
				end

				undercutBuyout = undercutBuyout or lowestBuyout
				undercutBid = undercutBid or lowestBid
				undercutOwner = undercutOwner or lowestOwner
				
				-- Don't cancel if the buyout is equal, or below our threshold
				if( AuctionProfitMaster.db.global.smartCancel and lowestBuyout <= threshold and not AuctionProfitMaster.Scan:IsPlayerOnly(itemID)) then
					if( not tempList[name] ) then
						tempList[name] = true
						
						AuctionProfitMaster:Log(name .. "notcancel", string.format(L["Undercut on %s by |cfffed000%s|r, their buyout %s, yours %s (per item), threshold is %s not cancelling"], itemLink, undercutOwner, AuctionProfitMaster:FormatTextMoney(undercutBuyout, true), AuctionProfitMaster:FormatTextMoney(buyout, true), AuctionProfitMaster:FormatTextMoney(threshold, true)))
					end
				-- Don't cancel an auction if it has a bid and we're set to not cancel those
				elseif( not AuctionProfitMaster.db.global.cancelWithBid and activeBid > 0 ) then
					if( not isTest ) then
						AuctionProfitMaster:Log(name .. "bid", string.format(L["Undercut on %s by |cfffed000%s|r, but %s placed a bid of %s so not cancelling"], itemLink, undercutOwner, highBidder, AuctionProfitMaster:FormatTextMoney(activeBid, true)))
					end
				else
					if( isTest ) then return true end
					if( not tempList[name] ) then
						tempList[name] = true
						if( AuctionProfitMaster.Scan:IsPlayerOnly(itemID) and buyout < fallback ) then
							AuctionProfitMaster:Log(name .. "cancel", string.format(L["You are the only one posting %s, the fallback is %s (per item), cancelling so you can relist it for more gold"], itemLink, AuctionProfitMaster:FormatTextMoney(fallback)))
						else
							AuctionProfitMaster:Log(name .. "cancel", string.format(L["Undercut on %s by |cfffed000%s|r, buyout %s, yours %s (per item)"], itemLink, undercutOwner, AuctionProfitMaster:FormatTextMoney(undercutBuyout, true), AuctionProfitMaster:FormatTextMoney(buyout, true)))
						end
					end
					
					totalToCancel = totalToCancel + 1
					totalCancelled = totalCancelled + 1
					tinsert(cancelList, {index=i, name=name, buyout=buyout})
				end
			end
		end
	end
	
	if( totalToCancel == 0 ) then
		AuctionProfitMaster:Log("cancelstatus", L["Nothing to cancel"])
		AuctionProfitMaster:Print(L["Nothing to cancel"])
		self:StopCancelling()
	end
end

-- Makes sure that the items that stack the lowest are posted first to free up space for items
-- that stack higher
local function sortByStack(a, b)
	local aStack = select(8, GetItemInfo(a)) or 20
	local bStack = select(8, GetItemInfo(b)) or 20
	
	if( aStack == bStack ) then
		return Manage:GetNumInBags(a) < Manage:GetNumInBags(b)
	end
	
	return aStack < bStack
end

function Manage:PostScan()
	self:StartLog()
	self:UpdateReverseLookup()
	AuctionProfitMaster:LockButtons()
	
	table.wipe(postQueue)
	table.wipe(scanList)
	table.wipe(tempList)
	table.wipe(status)
	
	for bag=0, 4 do
		if( AuctionProfitMaster:IsValidBag(bag) ) then
			for slot=1, GetContainerNumSlots(bag) do
				local link = AuctionProfitMaster:GetSafeLink(GetContainerItemLink(bag, slot))
				if( link and reverseLookup[link] ) then
					tempList[link] = true
				end
			end
		end
	end
	
	for itemID in pairs(tempList) do
		table.insert(postQueue, itemID)
	end
	
	table.sort(postQueue, sortByStack)
	if( #(postQueue) == 0 ) then
		AuctionProfitMaster:Log("poststatus", L["You do not have any items to post"])
		return
	end
		
	for _, itemID in pairs(postQueue) do
		table.insert(scanList, (GetItemInfo(itemID)))
	end
	
	
	status.isManaging = true
	status.totalPostQueued = 0
	status.totalScanQueue = #(postQueue)
	status.queueTable = postQueue
	AuctionProfitMaster.Post:ScanStarted()
	AuctionProfitMaster.Scan:StartItemScan(scanList)
end

function Manage:StopPosting()
	table.wipe(postQueue)
	
	status.isManaging = nil
	status.totalPostQueued = 0
	status.totalScanQueue = 0
	self:StopLog()
	
	AuctionProfitMaster.Post:Stop()
	AuctionProfitMaster.Post.post:Hide()
	AuctionProfitMaster:UnlockButtons()
end

function Manage:GetNumInBags(itemID)
	local num = GetItemCount(itemID)
	for sID, data in pairs(AuctionProfitMaster.gemData) do
		if sID == itemID then
			for _, item in pairs(data) do
				if item ~= sID then
					num = num + GetItemCount(item)
				end
			end
		end
	end
	
	return num
end

function Manage:PostItems(itemID)
	if not AuctionProfitMaster.Post.isPosting then AuctionProfitMaster.Post.isPosting = true end
	if not itemID then return end
	
	local name, itemLink, _, _, _, _, _, stackCount = GetItemInfo(itemID)
	local perAuction = math.min(stackCount, self:GetConfigValue(itemID, "perAuction"))
	local maxCanPost = math.floor(Manage:GetNumInBags(itemID) / perAuction)
	local postCap = self:GetConfigValue(itemID, "postCap")
	local threshold = self:GetConfigValue(itemID, "threshold")
	local auctionsCreated, activeAuctions = 0, 0
	
	AuctionProfitMaster:Log(name, string.format(L["Queued %s to be posted"], itemLink))
	
	local perAuctionIsCap = self:GetBoolConfigValue(itemID, "perAuctionIsCap")
	
	if( maxCanPost == 0 ) then
		if perAuctionIsCap then
			perAuction = Manage:GetNumInBags(itemID)
			maxCanPost = 1
		else
			AuctionProfitMaster:Log(name, string.format(L["Skipped %s need |cff20ff20%d|r for a single post, have |cffff2020%d|r"], itemLink, perAuction, Manage:GetNumInBags(itemID)))
			return
		end
	end

	local buyout, bid, _, isPlayer, isWhitelist = AuctionProfitMaster.Scan:GetLowestAuction(itemID)
	
	-- Check if we're going to go below the threshold
	if( buyout and not self:GetBoolConfigValue(itemID, "autoFallback") ) then
		-- Smart undercutting is enabled, and the auction is for at least 1 gold, round it down to the nearest gold piece
		local testBuyout = buyout
		if( AuctionProfitMaster.db.global.smartUndercut and testBuyout > COPPER_PER_GOLD ) then
			testBuyout = math.floor(buyout / COPPER_PER_GOLD) * COPPER_PER_GOLD
		else
			testBuyout = testBuyout - self:GetConfigValue(itemID, "undercut")
		end
		
		if( testBuyout < threshold and buyout <= threshold ) then
			AuctionProfitMaster:Log(name, string.format(L["Skipped %s lowest buyout is %s threshold is %s"], itemLink, AuctionProfitMaster:FormatTextMoney(buyout, true), AuctionProfitMaster:FormatTextMoney(threshold, true)))
			return
		end
	end

	-- Auto fallback is on, and lowest buyout is below threshold, instead of posting them all
	-- use the post count of the fallback tier
	if( self:GetBoolConfigValue(itemID, "autoFallback") and buyout and buyout <= threshold ) then	
		local fallbackBuyout = AuctionProfitMaster.Manage:GetConfigValue(itemID, "fallback")
		local fallbackBid = fallbackBuyout * AuctionProfitMaster.Manage:GetConfigValue(itemID, "bidPercent")
		activeAuctions = AuctionProfitMaster.Scan:GetPlayerAuctionCount(itemID, fallbackBuyout, fallbackBid)
			
	-- Either the player or a whitelist person is the lowest teir so use this tiers quantity of items
	elseif( isPlayer or isWhitelist ) then
		activeAuctions = AuctionProfitMaster.Scan:GetPlayerAuctionCount(itemID, buyout or 0, bid or 0)
	end
	
	-- If we have a post cap of 20, and 10 active auctions, but we can only have 5 of the item then this will only let us create 5 auctions
	-- however, if we have 20 of the item it will let us post another 10
	auctionsCreated = math.min(postCap - activeAuctions, maxCanPost)
	if( auctionsCreated <= 0 ) then
		AuctionProfitMaster:Log(name, string.format(L["Skipped %s posted |cff20ff20%d|r of |cff20ff20%d|r already"], itemLink, activeAuctions, postCap))
		return
	end
	
	-- Warn that they don't have enough to post
	if( maxCanPost < postCap ) then
		AuctionProfitMaster:Log(name, string.format(L["Queued %s to be posted (Cap is |cffff2020%d|r, only can post |cffff2020%d|r need to restock)"], itemLink, postCap, maxCanPost))
	end

	-- The splitter will automatically pass items to the post queuer, meaning if an item doesn't even stack it will handle that just fine
	stats[itemID] = (stats[itemID] or 0) + auctionsCreated
	status.totalPostQueued = status.totalPostQueued + auctionsCreated
	AuctionProfitMaster.Post:QueueItem(itemID, perAuction, auctionsCreated)
	AuctionProfitMaster.Post.post:Show()
end

-- Log handler
function Manage:APM_QUERY_UPDATE(event, type, filter, ...)
	if( not filter ) then return end
	
	if( type == "retry" ) then	
		local page, totalPages, retries, maxRetries = ...
		AuctionProfitMaster:Log(filter, string.format(L["Retry |cfffed000%d|r of |cfffed000%d|r for %s"], retries, maxRetries, filter))
	elseif( type == "page" ) then
		local page, totalPages = ...
		AuctionProfitMaster:Log(filter, string.format(L["Scanning page |cfffed000%d|r of |cfffed000%d|r for %s"], page, totalPages, filter))
	elseif( type == "done" ) then
		local page, totalPages = ...
		AuctionProfitMaster:Log(filter, string.format(L["Scanned page |cfffed000%d|r of |cfffed000%d|r for %s"], page, totalPages, filter))
		if not AuctionProfitMaster.Post.isPosting then
				AuctionProfitMaster:SetButtonProgress("status", status.totalScanQueue - #(status.queueTable), status.totalScanQueue)
		end

		-- Do everything we need to get it splitted/posted
		for i=#(postQueue), 1, -1 do
			if( GetItemInfo(postQueue[i]) == filter ) then
				self:PostItems(table.remove(postQueue, i))
			end
		end
	elseif( type == "next" ) then
		AuctionProfitMaster:Log(filter, string.format(L["Scanning %s"], filter))
	end
end

function Manage:APM_START_SCAN(event, type, total)
	AuctionProfitMaster:WipeLog()
	AuctionProfitMaster.Post.post.num = 1
	AuctionProfitMaster:Log("scanstatus", string.format(L["Scanning |cfffed000%d|r items..."], total or 0))
	
	status.totalPostQueued = 0
	table.wipe(stats)
end

function Manage:APM_STOP_SCAN(event, interrupted)
	self:StopLog()
	status.isManaging = nil

	if( interrupted ) then
		AuctionProfitMaster:Log("scaninterrupt", L["Scan interrupted before it could finish"])
		return
	end

	AuctionProfitMaster:Log("scandone", L["Scan finished!"], true)
	if AuctionProfitMaster.Post.isPosting then
		AuctionProfitMaster.Post.post.frame:Show()
	else
		Manage:Cancel()
		Manage:FinalCancel()
	end
	
	if( #cancelList > 0 ) then
		AuctionProfitMaster:Log("cancelstatus", L["Starting to cancel..."])
		AuctionProfitMaster.Post.isPosting = false
		AuctionProfitMaster.Post.isPosting2 = false
	else
		AuctionProfitMaster:UnlockButtons()
	end
end

function Manage:FinalCancel()
	local frame = CreateFrame("Frame", nil, AuctionFrame)
	local startNum, numCancelled = GetNumAuctionItems("owner"), #cancelList

	local throttle = CreateFrame("Frame")
	throttle:Hide()
	throttle:SetScript("OnUpdate", function(self, elapsed)
			self.timeLeft = self.timeLeft - elapsed
			if self.timeLeft <= 0 then
				frame.cancel:Enable()
				self:Hide()
			end
		end)
	
	local test = CreateFrame("Frame")
	test:Hide()
	test:SetScript("OnUpdate", function(self, elapsed)
			if GetNumAuctionItems("owner") <= (startNum - numCancelled) then
				AuctionProfitMaster:Log("cancelprogress", string.format(L["Finished cancelling |cfffed000%d|r auctions"], numCancelled))
			
				-- Unlock posting, cancelling doesn't require the auction house to be open meaning we can cancel everything
				-- then go run to the mailbox while it cancels just fine
				AuctionProfitMaster:Print(string.format(L["Finished cancelling |cfffed000%d|r auctions"], numCancelled))
				self:Hide()
			end
		end)

	local cancelTotal = 0
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:SetWidth(170)
	frame:SetHeight(35)
	frame:SetBackdrop({
		  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		  edgeSize = 26,
		  insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	frame:Hide()
	frame:SetScript("OnShow", function() cancelTotal = #(cancelList) end)
	frame:SetScript("OnHide", function(self) Manage:StopCancelling() self.cancel:Disable() end)

	frame.cancel = _G["AuctionProfitMasterCancelButton"] or CreateFrame("Button", "AuctionProfitMasterCancelButton", frame, "UIPanelButtonTemplate")
	frame.cancel:SetHeight(20)
	frame.cancel:SetWidth(160)
	frame.cancel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 8)
	frame.cancel.tooltip = L["Clicking this will cancel auctions based on the data scanned."]
	frame.cancel:SetScript("OnShow", function() cancelTotal = #(cancelList) frame.cancel:SetText("Cancel Auction 1 /" .. cancelTotal) end)
	frame.cancel:SetScript("OnClick", function(self)
		sort(cancelList, function(a, b) return (a.index>b.index) end)
		test:Show()
		local item = cancelList[1]
		if (not item) or (not item.index) then return end
		
		-- make sure the index values are still correct so we don't cancel the wrong item
		local name, _, quantity, _, _, _, _, _, buyout = GetAuctionItemInfo("owner", item.index)
		if name ~= item.name or buyout ~= item.buyout*quantity then
			item.index = nil
			for i=1, GetNumAuctionItems("owner") do
				local name, _, quantity, _, _, _, _, _, buyout = GetAuctionItemInfo("owner", i)
				if name == item.name and buyout == item.buyout*quantity then
					item.index = i
				end
			end
		end
		if not item.index then 
			AuctionProfitMaster:Print("Failed to cancel: " .. name .. " with buyout " .. buyout)
		else
			CancelAuction(item.index)
		end
		table.remove(cancelList, 1)
		totalToCancel = totalToCancel - 1
		
		frame.cancel:SetText("Cancel Auction " .. (cancelTotal + 1 - #cancelList) .. " / " .. cancelTotal)
		if #(cancelList) == 0 then
			Manage:CHAT_MSG_SYSTEM(_, ERR_AUCTION_REMOVED)
			frame:Hide()
		else
			frame.cancel:Disable()
			throttle.timeLeft = 0.1
			throttle:Show()
		end
	end)
	
	if #cancelList > 0 then
		frame:Show()
	end
end