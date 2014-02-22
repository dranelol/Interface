local AuctionProfitMaster = select(2, ...)
local Post = AuctionProfitMaster:NewModule("Post", "AceEvent-3.0")
local L = AuctionProfitMaster.L
local status = AuctionProfitMaster.status
local postQueue, overallTotal, queueLeft, scanRunning = {}, 0, 0, nil
local POST_TIMEOUT = 20
local frame = CreateFrame("Frame")
frame:Hide()
local postList, alreadyPosted = {}, {}
local postTotal = 0
Post.isPosting = false
Post.isPosting2 = false

local post = CreateFrame("Frame", nil, AuctionFrame)
post:SetClampedToScreen(true)
post:SetFrameStrata("HIGH")
post:SetToplevel(true)
post:SetWidth(300)
post:SetHeight(105)
post:SetBackdrop({
	  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	  edgeSize = 13,
	  insets = {left = 5, right = 5, top = 5, bottom = 5},
})
post:SetBackdropColor(0, 0, 0, 0.85)
post:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
post:Hide()
post.num = 1
post:SetScript("OnShow", function()
		Post:RegisterEvent("CHAT_MSG_SYSTEM")
	end)
post:SetScript("OnHide", function()
		table.wipe(postList)
		ClearCursor()
		post.num = 0
		postTotal = 0
		Post:AuctionHouseClosed()
		Post:Stop()
		for _, k in pairs(alreadyPosted) do k=nil end
		AuctionProfitMaster.Scan:AuctionHouseClosed(true)
		AuctionProfitMaster:UnlockButtons()
	end)
Post.post = post
Post:RegisterMessage("APM_START_SCAN", function() postTotal = 0 end)

local function ItemHyperlink_OnEnter(self, motion)
	if self.link then 
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink(self.link)
		GameTooltip:Show()
	end
end

local function ItemHyperlink_OnLeave(self, motion)
   GameTooltip:Hide()
end

local iconButton = CreateFrame("Button",nil, post, "ItemButtonTemplate")
iconButton:SetPoint("TOPLEFT", post, "TOPLEFT", 12, -36)
iconButton:SetScript("OnEnter", ItemHyperlink_OnEnter)
iconButton:SetScript("OnLeave", ItemHyperlink_OnLeave)
iconButton:GetNormalTexture():SetWidth(36)
iconButton:GetNormalTexture():SetHeight(36)
iconButton:SetHeight(36)
iconButton:SetWidth(36)
Post.post.iconButton = iconButton

local iconFrame = CreateFrame("Frame", nil, post)
iconFrame:SetPoint("TOPLEFT", post, "TOPLEFT", 12, -36)
iconFrame:SetHeight(32)
iconFrame:SetWidth(32)
Post.post.iconFrame = iconFrame

local label = post:CreateFontString(nil, "BACKGROUND", "SystemFont_Tiny")
label:SetPoint("TOPLEFT", iconFrame, "TOPRIGHT", -2, 0)
label:SetJustifyH("CENTER")
label:SetJustifyV("TOP")
label:SetTextColor(1, 1, 1)
label:SetHeight(32)
label:SetWidth(250)
post.label = label

local button = CreateFrame("Button", nil, post, "UIPanelButtonTemplate")
button:SetHeight(10)
button:SetWidth(144)
button:SetPoint("TOPLEFT", post, "TOPLEFT", 6, -85)
button:SetText("Skip Item")
post.skipButton = button
button:SetScript("OnClick", function()
		queueLeft = queueLeft - 1
		overallTotal = overallTotal + 1
		AuctionProfitMaster:SetButtonProgress("status", post.num, postTotal)
		
		if(queueLeft <= 0 and postTotal > 0) then
			post.num = post.num + 1
		end
		
		table.remove(postList, 1)
		if #(postList) ~= 0 then
			Post:UpdatePostFrame()
		else
			for _, k in pairs(alreadyPosted) do k=nil end
			ClearCursor()
			if not Post.isPosting then
				post.postButton:Disable()
				post:Hide()
			else
				post.postButton:Disable()
			end
		end
	end)

local button = CreateFrame("Button", nil, post, "UIPanelButtonTemplate")
button:SetHeight(10)
button:SetWidth(144)
button:SetPoint("TOPLEFT", post, "TOPLEFT", 150, -85)
button:SetText("Cancel Posting")
post.cancelButton = button
button:SetScript("OnClick", function()
		table.wipe(postList)
		ClearCursor()
		post.num = 0
		postTotal = 0
		Post:AuctionHouseClosed()
		Post:Stop()
		for _, k in pairs(alreadyPosted) do k=nil end
		AuctionProfitMaster.Scan:AuctionHouseClosed(true)
		AuctionProfitMaster:UnlockButtons()
	end)

post.postButton = CreateFrame("Button", "AuctionProfitMasterPostButton", post, "UIPanelButtonTemplate")
post.postButton:SetHeight(30)
post.postButton:SetWidth(294)
post.postButton:SetPoint("TOPLEFT", post, "TOPLEFT", 3, -5)
post.postButton.tooltip = L["Clicking this will post auctions based on the data scanned."]
post.postButton:SetScript("OnShow", function(self)
		self:Enable()
		Post:UpdatePostFrame()
	end)
post.postButton:SetScript("OnDisable", function()
		post.skipButton:Disable()
	end)
post.postButton:SetScript("OnEnable", function()
		post.skipButton:Enable()
		Post:UpdatePostFrame()
	end)
post.postButton:SetScript("OnClick", function(self)
		if #(postList) ~= 0 then
			Post:FinalPost()
		end
		if #(postList) == 0 then
			for _, k in pairs(alreadyPosted) do k=nil end
			ClearCursor()
			if not Post.isPosting then
				post:Hide()
			else
				self:Disable()
			end
		end
	end)

post.frame = CreateFrame("Frame")
post.frame:Hide()
post.frame:SetScript("OnUpdate", function(self)
		if #(postList) == 0 then
			for _, k in pairs(alreadyPosted) do k=nil end
			post:Hide()
			Post:Stop()
			self:Hide()
		end
	end)

function Post:OnInitialize()
	self:RegisterMessage("APM_AH_CLOSED", "AuctionHouseClosed")
end

function Post:AuctionHouseClosed()
	if( status.isPosting ) then
		self:Stop()
	end
	Post.post:Hide()
	postList = {}
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

function Post:Stop()
	Post.isPosting = false
	Post.isPosting2 = false
	table.wipe(alreadyPosted)
	
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	if( overallTotal > 0 ) then
		AuctionProfitMaster:Log(string.format(L["Finished posting |cfffed000%d|r items"], overallTotal))
	end
	
	AuctionProfitMaster:UnlockButtons()
	
	table.wipe(postQueue)
	
	overallTotal = 0
	status.isPosting = nil
	frame:Hide()
end

-- Tells the poster that nothing new has happened long enough it can shut off
frame.timeElapsed = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	self.timeElapsed = self.timeElapsed - elapsed
	if( self.timeElapsed <= 0 and not scanRunning ) then
		self:Hide()
		Post:Stop()
		Post.post:Hide()
	end
end)

-- Check if an auction was posted and move on if so
function Post:CHAT_MSG_SYSTEM(event, msg)
	if( msg == ERR_AUCTION_STARTED ) then
		queueLeft = queueLeft - 1
		overallTotal = overallTotal + 1
		AuctionProfitMaster:SetButtonProgress("status", post.num, postTotal)
		
		if(queueLeft <= 0 and postTotal > 0) then
			post.num = post.num + 1
			Post:UpdatePostFrame()
		end
		
		-- Also set our timeout so it knows if it can fully stop
		frame.timeElapsed = POST_TIMEOUT
		frame:Show()
	end
end

function Post:FindItemSlot(findLink)
	for bag=0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local itemID = AuctionProfitMaster:GetSafeLink(link)
			if( itemID and itemID == findLink ) then
				return bag, slot
			end
		end
	end
end

function Post:PostAuction(queue)
	if( not queue ) then return end
	
	local itemID, bag, slot = queue.link, self:FindItemSlot(queue.link)
	local name, itemLink = GetItemInfo(itemID)
	local lowestBuyout, lowestBid, lowestOwner, isWhitelist, isPlayer = AuctionProfitMaster.Scan:GetLowestAuction(itemID)
	
	-- Set our initial costs
	local fallbackCap, buyoutTooLow, bidTooLow, autoFallback, bid, buyout, differencedPrice, buyoutThresholded
	local fallback = AuctionProfitMaster.Manage:GetConfigValue(itemID, "fallback")
	local threshold = AuctionProfitMaster.Manage:GetConfigValue(itemID, "threshold")
	local priceThreshold = AuctionProfitMaster.Manage:GetConfigValue(itemID, "priceThreshold")
	local priceDifference = AuctionProfitMaster.Scan:CompareLowestToSecond(itemID, lowestBuyout)
	
	-- Difference between lowest that we have and second lowest is too high, undercut second lowest instead
	if( isPlayer and priceDifference and priceDifference >= priceThreshold ) then
		differencedPrice = true
		lowestBuyout, lowestBid = AuctionProfitMaster.Scan:GetSecondLowest(itemID, lowestBuyout)
	end
	
	-- No other auctions up, default to fallback
	if( not lowestOwner ) then
		buyout = AuctionProfitMaster.Manage:GetConfigValue(itemID, "fallback")
		bid = buyout * AuctionProfitMaster.Manage:GetConfigValue(itemID, "bidPercent")
	-- Item goes below the threshold price, default it to fallback
	elseif( AuctionProfitMaster.Manage:GetBoolConfigValue(itemID, "autoFallback") and lowestBuyout <= threshold ) then
		autoFallback = true
		buyout = AuctionProfitMaster.Manage:GetConfigValue(itemID, "fallback")
		bid = buyout * AuctionProfitMaster.Manage:GetConfigValue(itemID, "bidPercent")
	-- Either we already have one up or someone on the whitelist does
	elseif( ( isPlayer or isWhitelist ) and not differencedPrice ) then
		buyout = lowestBuyout
		bid = lowestBid
	-- We got undercut :(
	else
		local goldTotal = lowestBuyout / COPPER_PER_GOLD
		-- Smart undercutting is enabled, and the auction is for at least 1 gold, round it down to the nearest gold piece
		-- the math.floor(blah) == blah check is so we only do a smart undercut if the price isn't a whole gold piece and not a partial
		if( AuctionProfitMaster.db.global.smartUndercut and lowestBuyout > COPPER_PER_GOLD and goldTotal ~= math.floor(goldTotal) ) then
			buyout = math.floor(goldTotal) * COPPER_PER_GOLD
		else
			buyout = lowestBuyout - AuctionProfitMaster.Manage:GetConfigValue(itemID, "undercut")
		end
		
		-- Check if we're posting something too high
		if( buyout > (fallback * AuctionProfitMaster.Manage:GetConfigValue(itemID, "fallbackCap")) ) then
			buyout = fallback
			fallbackCap = true
		end
		
		-- Check if we're posting too low!
		if( buyout < threshold ) then
			buyout = threshold
			buyoutThresholded = true
		end
		
		bid = math.floor(buyout * AuctionProfitMaster.Manage:GetConfigValue(itemID, "bidPercent"))

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
	
	if not AuctionProfitMaster.Post.isPosting then AuctionProfitMaster.Post.isPosting = true end
	if not AuctionProfitMaster.Post.isPosting2 then AuctionProfitMaster.Post.isPosting2 = true end
	if( buyoutThresholded ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Increased buyout price due to going below thresold)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	elseif( buyoutTooLow ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Buyout went below zero, undercut by 1 copper instead)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	elseif( autoFallback ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, market below threshold)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	elseif( differencedPrice ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Price difference too high, used second lowest price intead)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	elseif( fallbackCap ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, lowest price was too high)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	elseif( bidTooLow ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (Increased bid price due to going below thresold)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	elseif( not lowestOwner ) then
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s (No other auctions up)"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	else
		AuctionProfitMaster:Log(name, string.format(L["Posting %s%s (%d) bid %s, buyout %s"], itemLink, quantityText, AuctionProfitMaster.Manage.stats[itemID] or 0, AuctionProfitMaster:FormatTextMoney(bid), AuctionProfitMaster:FormatTextMoney(buyout)))
	end
	
	local time = AuctionProfitMaster.Manage:GetConfigValue(itemID, "postTime")
	time = time == 48 and 3 or time == 24 and 2 or 1
	if AuctionProfitMaster.gemData[itemID] or AuctionProfitMaster:IsOldGem(itemID) then
		local locations = {}
		local used = {}
		for bag=0, 4 do
			for slot=1, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				local sID = AuctionProfitMaster:GetSafeLink(link)
				if AuctionProfitMaster.gemData[sID] or AuctionProfitMaster:IsOldGem(sID) then
					for _, fID in pairs({itemID, unpack(AuctionProfitMaster.gemData[itemID])}) do
						if sID and sID == fID and not used[bag.."@"..slot] then
							tinsert(locations, {bag=bag, slot=slot})
							used[bag.."@"..slot] = true
						end
					end
				end
			end
		end
		for i=1, queue.numStacks do
			if i > #locations then break end
			tinsert(postList, {bag=locations[i].bag, slot=locations[i].slot, bid=bid, buyout=buyout, time=time, stackSize=1, numStacks=1, itemID=itemID})
			postTotal = postTotal + 1
		end
	else
		tinsert(postList, {bag=bag, slot=slot, bid=bid, buyout=buyout, time=time, stackSize=queue.stackSize, numStacks=queue.numStacks, itemID=itemID})
		postTotal = postTotal + 1
	end
	if(queueLeft <= 0) then
		Post:UpdatePostFrame()
	end
end

function Post:FinalPost()
	local auc = postList[1]
	queueLeft = auc.numStacks
	PickupContainerItem(auc.bag, auc.slot)
	ClickAuctionSellItemButton()
	StartAuction(auc.bid, auc.buyout, auc.time, auc.stackSize, auc.numStacks)
	table.remove(postList, 1)
	Post.post.postButton:Disable()
end

-- This looks a bit odd I know, not sure if I want to keep it like this (or if I even can) where it posts something as soon as it can
-- I THINK it will work fine, but if it doesn't I'm going to change it back to post once, wait for event, post again, repeat
function Post:QueueItem(link, stackSize, numStacks)
	if not Post.isPosting then
		Post.isPosting = true
		self:RegisterEvent("CHAT_MSG_SYSTEM")
	end
	table.insert(postQueue, {link = (AuctionProfitMaster:GetNewGem(link) or link), stackSize = stackSize, numStacks = numStacks})
	for _, data in pairs(postQueue) do
		Post:PostAuction(table.remove(postQueue, 1))
	end
end

function Post:UpdatePostFrame()
	if postTotal == 0 then return end
	local data = postList[1]
	ClearCursor()
	if post.num > postTotal then post.num = postTotal end
	post.postButton:SetText("Post Auction " .. post.num .. " / " .. postTotal)
	if data then
		local _,link,_,_,_,_,_,_,_,texture = GetItemInfo(data.itemID)
		local stackText = "stacks"
		post.postButton:Enable()
		if data.numStacks == 1 then
			stackText = "stack"
		end
		post.label:SetText("Post " .. link .. "x" .. data.stackSize .. "\n (" .. data.numStacks .. " " .. stackText .. ") bid " .. AuctionProfitMaster:FormatTextMoney(data.bid) .. ", buyout " .. AuctionProfitMaster:FormatTextMoney(data.buyout))
		
		if texture then
			post.iconButton:SetNormalTexture(texture)
		end
		post.iconButton.link = link
	end
end