local QuickAuctions = select(2, ...)
local Post = QuickAuctions:NewModule("Post", "AceEvent-3.0")
local L = QuickAuctions.L
local status = QuickAuctions.status
local postQueue, overallTotal, queueLeft, scanRunning, hardware = {}, 0, 0, nil, nil
local POST_TIMEOUT = 20
local frame = CreateFrame("Frame")
frame:Hide()

function Post:OnInitialize()
	self:RegisterMessage("QA_AH_CLOSED", "AuctionHouseClosed")
	self:RegisterMessage("QA_START_SCAN", "ScanStarted")
	self:RegisterMessage("QA_STOP_SCAN", "ScanStopped")
end

function Post:AuctionHouseClosed()
	if( status.isPosting ) then
		self:Stop()
	end
end

function Post:ScanStarted()
	scanRunning = true
end

function Post:ScanStopped()
	scanRunning = nil
	
	if( #(postQueue) == 0 and overallTotal >= status.totalPostQueued ) then
		self:Stop()
	end
end

function Post:Start()
	if( not status.isPosting ) then
		overallTotal = 0
		status.isPosting = true
		self:RegisterEvent("CHAT_MSG_SYSTEM")
		
		frame.timeElapsed = POST_TIMEOUT
		frame:Show()
	end
end

function Post:Stop()
	if( not status.isPosting ) then return end
	
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	if( overallTotal > 0 ) then
		QuickAuctions:Log(string.format(L["Finished posting |cfffed000%d|r items"], overallTotal))
	else
		QuickAuctions:Log(L["No auctions posted"])
	end
	
	QuickAuctions:UnlockButtons()
	
	table.wipe(postQueue)
	
	overallTotal = 0
	status.isPosting = nil
	frame:Hide()
end

function Post:ReadyToPost(queue)
	QuickAuctions:LockButtons()
	
	if( self.postFrame ) then
		self.postFrame.item:SetFormattedText(L["Posting %s x %d (%d times)"], select(2, GetItemInfo(queue.link)), queue.stackSize, queue.numStacks) 
		self.postFrame:Show()
		return
	end

	local function showTooltip(self)
		if( self.tooltip ) then
			GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOPLEFT")
			GameTooltip:SetText(self.tooltip, 1, 1, 1, nil, true)
			GameTooltip:Show()
		end
	end

	local function hideTooltip(self)
		GameTooltip:Hide()
	end

	local function formatTime(seconds)
		if( seconds >= 3600 ) then
			return seconds / 3600, L["hours"]
		elseif( seconds >= 60 ) then
			return seconds / 60, L["minutes"]
		end

		return seconds, L["seconds"]
	end
	
	local scanFinished
	local soundElapsed = 0
	local function OnUpdate(self, elapsed)
		-- Remind them once every 60 seconds that it's ready
		if( QuickAuctions.db.global.playPostSound ) then
			soundElapsed = soundElapsed + elapsed
			if( soundElapsed >= 60 ) then
				soundElapsed = soundElapsed - 60
				
				PlaySound("ReadyCheck")
			end
		end
	end
	
	local frame = CreateFrame("Frame", nil, AuctionFrame)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:SetWidth(300)
	frame:SetHeight(115)
	frame:SetBackdrop({
		  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		  edgeSize = 26,
		  insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
	frame:Hide()
	frame:SetScript("OnUpdate", OnUpdate)
	frame:SetScript("OnShow", function(self)
		if( QuickAuctions.db.global.postBinding ~= "" ) then
			SetOverrideBindingClick(self, true, QuickAuctions.db.global.postBinding, self.post:GetName())
		end
		
		if( QuickAuctions.db.global.playPostSound ) then
			PlaySound("ReadyCheck")
		end
		
		-- Setup initial data + update
		scanFinished = GetTime()
		soundElapsed = 0
		OnUpdate(self, 1)
	end)
	frame:SetScript("OnHide", function(self)
		if( not self.wasClicked ) then
			Post:Stop()
		end
		
		self.wasClicked = nil
		ClearOverrideBindings(self)
	end)
	
	frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	frame.titleBar:SetPoint("TOP", 0, 8)
	frame.titleBar:SetWidth(225)
	frame.titleBar:SetHeight(45)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", 0, 0)
	frame.title:SetText("Quick Auctions")

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.text:SetText(L["Auctions ready to post."])
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")
	
	frame.item = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.item:SetText("")
	frame.item:SetPoint("TOPLEFT", 12, -60)
	frame.item:SetWidth(frame:GetWidth() - 20)
	frame.item:SetJustifyH("LEFT")

	frame.post = CreateFrame("Button", "QuickAuctionsPostButton", frame, "UIPanelButtonTemplate")
	frame.post:SetText(L["Post"])
	frame.post:SetHeight(20)
	frame.post:SetWidth(100)
	frame.post:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 8)
	frame.post.tooltip = L["Clicking this will post the auctions."]
	frame.post:SetScript("OnClick", function(self)
		self:GetParent().wasClicked = true
		self:GetParent():Hide()
		
		Post:PostAuction(table.remove(postQueue, 1))
	end)
	
	self.postFrame = frame
	self.postFrame.item:SetFormattedText(L["Posting %s x %d (%d times)"], select(2, GetItemInfo(queue.link)), queue.stackSize, queue.numStacks) 

	frame:Show()
end


-- Tells the poster that nothing new has happened long enough it can shut off
frame.timeElapsed = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	self.timeElapsed = self.timeElapsed - elapsed
	if( self.timeElapsed <= 0 and not scanRunning ) then
		self:Hide()
		Post:Stop()
	end
end)

-- Check if an auction was posted and move on if so
function Post:CHAT_MSG_SYSTEM(event, msg)
	if( msg == ERR_AUCTION_STARTED ) then
		queueLeft = queueLeft - 1
		overallTotal = overallTotal + 1
		QuickAuctions:SetButtonProgress("post", overallTotal, status.totalPostQueued)
		
		if( overallTotal >= status.totalPostQueued and not scanRunning ) then
			self:Stop()
			return
		-- Time to move onto our next queue!
		elseif( queueLeft <= 0 and #(postQueue) > 0 ) then
			self:Start()
			self:ReadyToPost(postQueue[1])
		end
		
		-- Also set our timeout so it knows if it can fully stop
		frame.timeElapsed = POST_TIMEOUT
		frame:Show()
	end
end

function Post:FindItemSlot(findLink)
	for bag=0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			local link = QuickAuctions:GetSafeLink(GetContainerItemLink(bag, slot))
			if( link and link == findLink ) then
				return bag, slot
			end
		end
	end
end

function Post:PostAuction(queue)
	if( not queue ) then return end
	
	local itemID, bag, slot = queue.link, self:FindItemSlot(queue.link)
	local name, itemLink = GetItemInfo(itemID)
	local lowestBuyout, lowestBid, lowestOwner, isWhitelist, isPlayer = QuickAuctions.Scan:GetLowestAuction(itemID)
	
	-- Set our initial costs
	local fallbackCap, buyoutTooLow, bidTooLow, autoFallback, bid, buyout, differencedPrice, buyoutThresholded
	local fallback = QuickAuctions.Manage:GetConfigValue(itemID, "fallback")
	local threshold = QuickAuctions.Manage:GetConfigValue(itemID, "threshold")
	local priceThreshold = QuickAuctions.Manage:GetConfigValue(itemID, "priceThreshold")
	local priceDifference = QuickAuctions.Scan:CompareLowestToSecond(itemID, lowestBuyout)
	
	-- Difference between lowest that we have and second lowest is too high, undercut second lowest instead
	if( isPlayer and priceDifference and priceDifference >= priceThreshold ) then
		differencedPrice = true
		lowestBuyout, lowestBid = QuickAuctions.Scan:GetSecondLowest(itemID, lowestBuyout)
	end
	
	-- No other auctions up, default to fallback
	if( not lowestOwner ) then
		buyout = QuickAuctions.Manage:GetConfigValue(itemID, "fallback")
		bid = buyout * QuickAuctions.Manage:GetConfigValue(itemID, "bidPercent")
	-- Item goes below the threshold price, default it to fallback
	elseif( QuickAuctions.Manage:GetBoolConfigValue(itemID, "autoFallback") and lowestBuyout <= threshold ) then
		autoFallback = true
		buyout = QuickAuctions.Manage:GetConfigValue(itemID, "fallback")
		bid = buyout * QuickAuctions.Manage:GetConfigValue(itemID, "bidPercent")
	-- Either we already have one up or someone on the whitelist does
	elseif( ( isPlayer or isWhitelist ) and not differencedPrice ) then
		buyout = lowestBuyout
		bid = lowestBid
	-- We got undercut :(
	else
		local goldTotal = lowestBuyout / COPPER_PER_GOLD
		-- Smart undercutting is enabled, and the auction is for at least 1 gold, round it down to the nearest gold piece
		-- the math.floor(blah) == blah check is so we only do a smart undercut if the price isn't a whole gold piece and not a partial
		if( QuickAuctions.db.global.smartUndercut and lowestBuyout > COPPER_PER_GOLD and goldTotal ~= math.floor(goldTotal) ) then
			buyout = math.floor(goldTotal) * COPPER_PER_GOLD
		else
			buyout = lowestBuyout - QuickAuctions.Manage:GetConfigValue(itemID, "undercut")
		end
		
		-- Check if we're posting something too high
		if( buyout > (fallback * QuickAuctions.Manage:GetConfigValue(itemID, "fallbackCap")) ) then
			buyout = fallback
			fallbackCap = true
		end
		
		-- Check if we're posting too low!
		if( buyout < threshold ) then
			buyout = threshold
			buyoutThresholded = true
		end
		
		bid = math.floor(buyout * QuickAuctions.Manage:GetConfigValue(itemID, "bidPercent"))

		-- Check if the bid is too low
		if( bid < threshold ) then
			bid = threshold
			bidTooLow = true
		end
	end
	
	local quantityText = queue.stackSize > 1 and " x " .. queue.stackSize or ""
	
	-- Increase the bid/buyout based on how many items we're posting
	bid = math.floor(bid * queue.stackSize)
	buyout = math.floor(buyout * queue.stackSize)
	
	if( buyoutThresholded ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Increased buyout price due to going below thresold)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	elseif( buyoutTooLow ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Buyout went below zero, undercut by 1 copper instead)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	elseif( autoFallback ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, market below threshold)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	elseif( differencedPrice ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Price difference too high, used second lowest price intead)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	elseif( fallbackCap ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, lowest price was too high)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	elseif( bidTooLow ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Increased bid price due to going below thresold)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	elseif( not lowestOwner ) then
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (No other auctions up)"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	else
		QuickAuctions:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s"], itemLink, quantityText, QuickAuctions.Manage.stats[itemID] or 0, QuickAuctions:FormatTextMoney(bid), QuickAuctions:FormatTextMoney(buyout)))
	end
	
	queueLeft = queue.numStacks
	
	local time = QuickAuctions.Manage:GetConfigValue(itemID, "postTime")
	time = time == 48 and 3 or time == 24 and 2 or 1
		
	PickupContainerItem(bag, slot)
	ClickAuctionSellItemButton()
	
	StartAuction(bid, buyout, time, queue.stackSize, queue.numStacks)
end

-- This looks a bit odd I know, not sure if I want to keep it like this (or if I even can) where it posts something as soon as it can
-- I THINK it will work fine, but if it doesn't I'm going to change it back to post once, wait for event, post again, repeat
function Post:QueueItem(link, stackSize, numStacks)
	table.insert(postQueue, {link = link, stackSize = stackSize, numStacks = numStacks})
	
	if( queueLeft <= 0 and ( not self.postFrame or not self.postFrame:IsVisible() ) ) then
		self:Start()
		Post:ReadyToPost(postQueue[1])
	end
end






