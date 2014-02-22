local AuctionProfitMaster = select(2, ...)
AuctionProfitMaster = LibStub("AceAddon-3.0"):NewAddon(AuctionProfitMaster, "AuctionProfitMaster", "AceEvent-3.0")
AuctionProfitMaster.status = {}
AuctionProfitMaster.L = LibStub("AceLocale-3.0"):GetLocale("AuctionProfitMaster")

local L = AuctionProfitMaster.L
local status = AuctionProfitMaster.status
local statusLog, logIDs, lastSeenLogID = {}, {}

--Keybinding Settings
BINDING_HEADER_APM_HEADER="Auction Profit Master"
_G["BINDING_NAME_CLICK APMStartPostButton:RightButton"]=L["Post"]
_G["BINDING_NAME_CLICK APMStartCancelButton:RightButton"]=L["Cancel"]
_G["BINDING_NAME_CLICK AuctionProfitMasterPostButton:RightButton"] = "Post Auction"
_G["BINDING_NAME_CLICK AuctionProfitMasterCancelButton:RightButton"] = "Cancel Auction"

-- Addon loaded
function AuctionProfitMaster:OnInitialize()
	self.defaults = {
		profile = {
			noCancel = {default = false},
			autoFallback = {default = false},
			undercut = {default = 1},
			postTime = {default = 12},
			bidPercent = {default = 1.0},
			fallback = {default = 50000},
			fallbackCap = {default = 5},
			threshold = {default = 10000},
			postCap = {default = 4},
			perAuction = {default = 1},
			perAuctionIsCap = {default = false},
			priceThreshold = {default = 10},
			ignoreStacks = {default = 1000},
			groupStatus = {},
			categories = {},
		},
		global = {
			summaryItems = {},
			groups = {},
			infoID = -1,
			hideUncraft = false,
			cancelBinding = "",
			showStatus = false,
			smartUndercut = false,
			smartCancel = true,
			cancelWithBid = false,
			superScan = false,
			hideHelp = false,
		},
		realm = {
			crafts = {},
			craftQueue = {},
		},
		factionrealm = {
			player = {},
			whitelist = {},
			mail = {},
		},
	}
	
	self.db = LibStub:GetLibrary("AceDB-3.0"):New("AuctionProfitMasterDB", self.defaults, true)
	self.Scan = self.modules.Scan
	self.Manage = self.modules.Manage
	self.Split = self.modules.Split
	self.Post = self.modules.Post
	self.Summary = self.modules.Summary
	self.Tradeskill = self.modules.Tradeskill
	self.Status = self.modules.Status
		
	-- Add this character to the alt list so it's not undercut by the player
	self.db.factionrealm.player[UnitName("player")] = true
	
	if not self.db.global.outdatedMsg then
		StaticPopupDialogs["APMOutdatedMsg"] = {
			text = "APM has officially been discontinued! Over the last few months we've been working on a new project, which combines (and greatly improves) the functionality of APM along with all sorts of other new awesome features! Check out TRADESKILLMASTER today at http://wow.curse.com/downloads/wow-addons/details/tradeskill-master.aspx",
			button1 = "Awesome!",
			timeout = 0,
			whileDead = true,
			hideOnEscape = false,
		}
		StaticPopup_Show("APMOutdatedMsg")
		self.db.global.outdatedMsg = true
	end
	
	-- Move to the global DB
	if( AuctionProfitMaster.db.profile.groups ) then
		AuctionProfitMaster.db.global.groups = CopyTable(AuctionProfitMaster.db.profile.groups)
		AuctionProfitMaster.db.profile.groups = nil
	end
	
	if( AuctionProfitMaster.db.global.warned ) then
		AuctionProfitMaster.db.global.infoID = 1
		AuctionProfitMaster.db.global.warned = nil
	end
	
	-- Reset settings
	if( AuctionProfitMasterDB.revision ) then
		for key in pairs(AuctionProfitMasterDB) do
			if( key ~= "profileKeys" and key ~= "profiles" ) then
				AuctionProfitMasterDB[key] = nil
			end
		end
	end

	-- Move the craft list from factionrealm to realm
	if( self.db.factionrealm.crafts ) then
		self.db.factionrealm.craftQueue = nil
		self.db.realm.crafts = CopyTable(self.db.factionrealm.crafts)
		self.db.factionrealm.crafts = nil
	end
	
	-- Wait for auction house to be loaded
	self:RegisterMessage("APM_AH_LOADED", "AuctionHouseLoaded")
	self:RegisterMessage("APM_START_SCAN", "LockButtons")
	--self:RegisterMessage("APM_STOP_SCAN", "UnlockButtons") test
	self:RegisterMessage("APM_AH_CLOSED", "UnlockButtons")
	self:RegisterEvent("ADDON_LOADED", function(event, addon)
		if( addon == "Blizzard_AuctionUI" ) then
			AuctionProfitMaster:UnregisterEvent("ADDON_LOADED")
			AuctionProfitMaster:SendMessage("APM_AH_LOADED")
		end
	end)
	
	if( IsAddOnLoaded("Blizzard_AuctionUI") ) then
		self:UnregisterEvent("ADDON_LOADED")
		self:SendMessage("APM_AH_LOADED")
	end
	
	for _, items in pairs(AuctionProfitMaster.db.global.groups) do
		for itemID in pairs(items) do
			itemID = AuctionProfitMaster:GetNewGem(itemID) or itemID
		end
	end
	
	self:ShowInfoPanel()
end

function AuctionProfitMaster:WipeLog()
	lastSeenLogID = 0
	
	-- This will force it to create new rows for any new logs without having to wipe all of them
	table.wipe(logIDs)
	
	if( #(statusLog) > 0 ) then
		self:Log("-------------------------------")
	else
		self:UpdateStatusLog()
	end
end

-- If you only pass message, it will assume the next line is going to be a new one
-- passing an ID will make it use that same line unless the ID changed, pretty much just an automated new line method
function AuctionProfitMaster:Log(id, msg)
	if( not id ) then return end
	if( not msg and id ) then msg = id end
	
	if( not logIDs[id] ) then
		logIDs[id] = #(statusLog) + 1
	end
	
	statusLog[logIDs[id]] = msg or ""
	
	-- Force the scroll bar to the bottom while posting, assuming they haven't scrolled within 10 seconds
	local scrollBar = APMLogScrollFrameScrollBar
	local maxValue = scrollBar and select(2, scrollBar:GetMinMaxValues())
	if( scrollBar and scrollBar:GetValue() < maxValue ) then
		scrollBar:SetValue(maxValue)
	else
		self:UpdateStatusLog()
	end
end

function AuctionProfitMaster:UpdateStatusLog()
	local self = AuctionProfitMaster
	local totalLogs = #(statusLog)
	if( not self.statusFrame or not self.statusFrame:IsVisible() ) then
		local waiting = totalLogs - (lastSeenLogID or 0)
		if( waiting > 0 ) then
			self.buttons.log:SetFormattedText(L["Log (%d)"], waiting)
			self.buttons.log.tooltip = string.format(L["%d log messages waiting"], waiting)
		else
			self.buttons.log:SetText(L["Log"])
			self.buttons.log.tooltip = self.buttons.log.startTooltip
		end
		return
	else
		self.buttons.log:SetText(L["Log"])
		self.buttons.log.tooltip = self.buttons.log.startTooltip

		lastSeenLogID = totalLogs
	end
	
	FauxScrollFrame_Update(self.statusFrame.scroll, totalLogs, #(self.statusFrame.rows) - 1, 16)
	
	local offset = FauxScrollFrame_GetOffset(self.statusFrame.scroll)
	for id, row in pairs(self.statusFrame.rows) do
		row.tooltip = statusLog[offset + id]
		row:SetText(row.tooltip)
		row:Show()
	end
	
	for i=totalLogs + 1, #(self.statusFrame.rows) do
		self.statusFrame.rows[i]:Hide()
	end
end

function AuctionProfitMaster:AuctionHouseLoaded()
	-- This hides the <player>'s Auctions text
	AuctionsTitle:Hide()
	
	-- Hook auction OnHide to interrupt scans if we have to
	AuctionFrame:HookScript("OnHide", function(self)
		AuctionProfitMaster:SendMessage("APM_AH_CLOSED")
	end)

	-- Block system messages for auctions being removed or posted
	local orig_ChatFrame_SystemEventHandler = ChatFrame_SystemEventHandler
	ChatFrame_SystemEventHandler = function(self, event, msg, ...)
		if( msg == ERR_AUCTION_REMOVED and status.isCancelling or msg == ERR_AUCTION_STARTED and status.isPosting ) then
			return true
		end
		
		return orig_ChatFrame_SystemEventHandler(self, event, msg, ...)
	end
	
	self.buttons = {}

	-- Tooltips!
	local function showTooltip(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end

	local function hideTooltip(self)
		GameTooltip:Hide()
	end
	
	-- Show log for posting
	local button = CreateFrame("Button", nil, AuctionFrameAuctions, "UIPanelButtonTemplate")
	button.tooltip = L["Displays the Auction Profit Master log describing what it's currently scanning, posting or cancelling."]
	button.startTooltip = button.tooltip
	button:SetPoint("TOPRIGHT", AuctionFrameAuctions, "TOPRIGHT", 51, -15)
	button:SetWidth(90)
	button:SetHeight(18)
	button:SetText(L["Log"])
	button:SetScript("OnEnter", showTooltip)
	button:SetScript("OnLeave", hideTooltip) 
	button:SetScript("OnShow", function(self)
		if( AuctionProfitMaster.db.global.showStatus ) then
			self:LockHighlight()

			AuctionProfitMaster:CreateStatus()
			AuctionProfitMaster.statusFrame:Show()
		end
	end)
	button:SetScript("OnClick", function(self)
		AuctionProfitMaster.db.global.showStatus = not AuctionProfitMaster.db.global.showStatus

		if( AuctionProfitMaster.db.global.showStatus ) then
			self:LockHighlight()

			AuctionProfitMaster:CreateStatus()
			AuctionProfitMaster.statusFrame:Show()
		else
			self:UnlockHighlight()
			
			if( AuctionProfitMaster.statusFrame ) then
				AuctionProfitMaster.statusFrame:Hide()
			end
		end
	end)
	
	self.buttons.log = button
	
	-- Scan our posted items
	local button = CreateFrame("Button", nil, AuctionFrameAuctions, "UIPanelButtonTemplate")
	button.tooltip = L["View a summary of what the highest selling of certain items is."]
	button:SetPoint("TOPRIGHT", self.buttons.log, "TOPLEFT", 0, 0)
	button:SetText(L["Summary"])
	button:SetWidth(90)
	button:SetHeight(18)
	button:SetScript("OnEnter", showTooltip)
	button:SetScript("OnLeave", hideTooltip) 
	button:SetScript("OnClick", function(self)
		AuctionProfitMaster.Summary:Toggle()
	end)
	
	self.buttons.summary = button
	
	-- Post inventory items
	local button = CreateFrame("Button", "APMStartPostButton", AuctionFrameAuctions, "UIPanelButtonTemplate")
	button.tooltip = L["Post items from your inventory into the auction house."]
	button:SetPoint("TOPRIGHT", self.buttons.summary, "TOPLEFT", -25, 0)
	button:SetText(L["Post"])
	button:SetWidth(90)
	button:SetHeight(18)
	button:SetScript("OnEnter", showTooltip)
	button:SetScript("OnLeave", hideTooltip)
	button:SetScript("OnClick", function(self)
		AuctionProfitMaster.Manage:PostScan()
	end)
	button.originalText = button:GetText()
	
	self.buttons.post = button

	-- Scan our posted items
	local button = CreateFrame("Button", "APMStartCancelButton", AuctionFrameAuctions, "UIPanelButtonTemplate")
	button.tooltip = L["Cancels any posted auctions that you were undercut on."]
	button:SetPoint("TOPRIGHT", self.buttons.post, "TOPLEFT", -10, 0)
	button:SetText(L["Cancel"])
	button:SetWidth(90)
	button:SetHeight(18)
	button:SetScript("OnEnter", showTooltip)
	button:SetScript("OnLeave", hideTooltip)
	button:SetScript("OnClick", function(self)
		AuctionProfitMaster.Manage:CancelScan()
	end)
	button.originalText = button:GetText()
	
	self.buttons.cancel = button

	-- Status scans what items we have in our inventory/auction
	local button = CreateFrame("Button", nil, AuctionFrameAuctions, "UIPanelButtonTemplate")
	button.tooltip = L["Does a status scan that helps to identify auctions you can buyout to raise the price of a group your managing.\n\nThis will NOT automatically buy items for you, all it tells you is the lowest price and how many are posted."]
	button:SetPoint("TOPRIGHT", self.buttons.cancel, "TOPLEFT", -10, 0)
	button:SetText(L["Status"])
	button:SetWidth(80)
	button:SetHeight(18)
	button:SetScript("OnEnter", showTooltip)
	button:SetScript("OnLeave", hideTooltip)
	button:SetScript("OnClick", function(self)
		AuctionProfitMaster.Status:Scan()
	end)
	button.originalText = button:GetText()
	
	self.buttons.status = button
end

function AuctionProfitMaster:GetSafeLink(link)
	if not link then return end
	local s, e = string.find(link, "|H(.-):([-0-9]+)")
	local fLink = string.sub(link, s+2, e)
	return AuctionProfitMaster:GetNewGem(fLink) or fLink
end

function AuctionProfitMaster:GetEnchantLink(link)
	return link and tonumber(string.match(link, "enchant:(%d+)"))
end

function AuctionProfitMaster:CreateStatus()
	if( self.statusFrame ) then return end
	
	-- Try and stop UIObjects from clipping the status frame
	local function fixFrame()
		local frame = AuctionProfitMaster.statusFrame
		if( AuctionsScrollFrame:IsVisible() ) then
			frame:SetParent(AuctionsScrollFrame)
		else
			frame:SetParent(AuctionFrameAuctions)
		end
		
		frame:SetFrameLevel(frame:GetParent():GetFrameLevel() + 10)
		for _, row in pairs(frame.rows) do
			row:SetFrameLevel(frame:GetFrameLevel() + 1)
		end
		
		-- Force it to be visible still
		if( AuctionProfitMaster.db.profile.showStatus ) then
			AuctionProfitMaster.statusFrame:Show()
		end
	end
	
	AuctionsScrollFrame:HookScript("OnHide", fixFrame)
	AuctionsScrollFrame:HookScript("OnShow", fixFrame)

	local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1}}

	local frame = CreateFrame("Frame", nil, AuctionsScrollFrame)
	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0, 0, 0.95)
	frame:SetBackdropBorderColor(0.60, 0.60, 0.60, 1)
	frame:SetHeight(1)
	frame:SetWidth(1)
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", AuctionsQualitySort, "BOTTOMLEFT", -2, -2)
	frame:SetPoint("BOTTOMRIGHT", AuctionsCloseButton, "TOPRIGHT", -5, 2)
	frame:SetScript("OnShow", function() AuctionProfitMaster:UpdateStatusLog() end)
	frame:EnableMouse(true)
	frame:Hide()

	frame.scroll = CreateFrame("ScrollFrame", "APMLogScrollFrame", frame, "FauxScrollFrameTemplate")
	frame.scroll:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -1)
	frame.scroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 1)
	frame.scroll:SetScript("OnVerticalScroll", function(self, value) FauxScrollFrame_OnVerticalScroll(self, value, 16, AuctionProfitMaster.UpdateStatusLog) end)

	frame.rows = {}

	-- Tooltips!
	local function showTooltip(self)
		if( type(self.tooltip) == "string" and self.tooltip ~= "" ) then
			GameTooltip:SetOwner(self:GetParent(), "ANCHOR_TOPLEFT")
			GameTooltip:SetText(self.tooltip, 1, 1, 1, nil, true)
			GameTooltip:Show()
		end
	end

	local function hideTooltip(self)
		GameTooltip:Hide()
	end

	for i=1, 21 do
		local button = CreateFrame("Button", nil, frame)
		button:SetWidth(1)
		button:SetHeight(16)
		button:SetPushedTextOffset(0, 0)
		button:SetScript("OnEnter", showTooltip)
		button:SetScript("OnLeave", hideTooltip)
		
		local text = button:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		text:SetFont(GameFontHighlight:GetFont(), 11)
		text:SetAllPoints(button)
		text:SetJustifyH("LEFT")
		text:SetTextColor(0.95, 0.95, 0.95, 1)
		button:SetFontString(text)
		
		if( i > 1 ) then
			button:SetPoint("TOPLEFT", frame.rows[i - 1], "BOTTOMLEFT", 0, 0)
			button:SetPoint("TOPRIGHT", frame.rows[i - 1], "BOTTOMRIGHT", 0, 0)
		else
			button:SetPoint("TOPLEFT", frame.scroll, "TOPLEFT", 2, 0)
			button:SetPoint("TOPRIGHT", frame.scroll, "TOPRIGHT", 0, 0)
		end

		frame.rows[i] = button
	end
	
	self.statusFrame = frame
	
	fixFrame()
end

function AuctionProfitMaster:LockButtons()
	self.buttons.post:Disable()
	self.buttons.cancel:Disable()
	self.buttons.status:Disable()
end

function AuctionProfitMaster:UnlockButtons()
	self.buttons.post:Enable()
	self.buttons.post:SetText(self.buttons.post.originalText)
	self.buttons.cancel:Enable()
	self.buttons.cancel:SetText(self.buttons.cancel.originalText)
	self.buttons.status:Enable()
	self.buttons.status:SetText(self.buttons.status.originalText)
end

function AuctionProfitMaster:SetButtonProgress(type, current, total)
	self.buttons[type]:SetFormattedText("%d/%d", current, total)
end

-- Change log warning to the user
local infoMessages = {
	L["Read me, important information below!\n\nAs of 3.3 Blizzard requires that you use a hardware event (key press or mouse click) to cancel auctions, currently there is a loophole that allows you to get around this by letting you cancel as many auctions as you need for one hardware event."],
}

function AuctionProfitMaster:ShowInfoPanel()
	local infoID = AuctionProfitMaster.db.global.infoID
	AuctionProfitMaster.db.global.infoID = #(infoMessages)
	if( infoID < 0 or infoID >= #(infoMessages) ) then return end
	
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:SetWidth(400)
	frame:SetHeight(285)
	frame:SetBackdrop({
		  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		  edgeSize = 26,
		  insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)

	frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	frame.titleBar:SetPoint("TOP", 0, 8)
	frame.titleBar:SetWidth(225)
	frame.titleBar:SetHeight(45)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", 0, 0)
	frame.title:SetText("Auction Profit Master")

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.text:SetText(infoMessages[AuctionProfitMaster.db.global.infoID])
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")
	frame:SetHeight(frame.text:GetHeight() + 70)

	frame.hide = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.hide:SetText(L["Ok"])
	frame.hide:SetHeight(20)
	frame.hide:SetWidth(100)
	frame.hide:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 8)
	frame.hide:SetScript("OnClick", function(self)
		self:GetParent():Hide()
	end)
end

-- Stolen from Tekkub!
local GOLD_TEXT = "|cffffd700g|r"
local SILVER_TEXT = "|cffc7c7cfs|r"
local COPPER_TEXT = "|cffeda55fc|r"

-- Truncate tries to save space, after 10g stop showing copper, after 100g stop showing silver
function AuctionProfitMaster:FormatTextMoney(money, truncate)
	local gold = math.floor(money / COPPER_PER_GOLD)
	local silver = math.floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = math.floor(math.fmod(money, COPPER_PER_SILVER))
	local text = ""
	
	-- Add gold
	if( gold > 0 ) then
		text = string.format("%d%s ", gold, GOLD_TEXT)
	end
	
	-- Add silver
	if( silver > 0 and ( not truncate or gold < 100 ) ) then
		text = string.format("%s%d%s ", text, silver, SILVER_TEXT)
	end
	
	-- Add copper if we have no silver/gold found, or if we actually have copper
	if( text == "" or ( copper > 0 and ( not truncate or gold <= 10 ) ) ) then
		text = string.format("%s%d%s ", text, copper, COPPER_TEXT)
	end
	
	return string.trim(text)
end

-- Makes sure this bag is an actual bag and not an ammo, soul shard, etc bag
function AuctionProfitMaster:IsValidBag(bag)
	if( bag == 0 or bag == -1 ) then return true end
	
	-- family 0 = bag with no type, family 1/2/4 are special bags that can only hold certain types of items
	local itemFamily = GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)))
	return itemFamily and ( itemFamily == 0 or itemFamily > 4 )
end

function AuctionProfitMaster:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff33ff99Auction Profit Master|r: %s", msg))
end

function AuctionProfitMaster:Echo(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

if( IsAddOnLoaded("TestCode") ) then
	AuctionProfitMaster.L = setmetatable(AuctionProfitMaster.L, {
		__index = function(tbl, value)
			rawset(tbl, value, value)
			return value
		end,
	})
	
	_G["AuctionProfitMaster"] = AuctionProfitMaster
end

function AuctionProfitMaster:IsOldGem(itemID)
	if not AuctionProfitMaster.oldGems then
		AuctionProfitMaster.oldGems = {}
		for sID, dataID in pairs(AuctionProfitMaster.gemData) do
			for _, dID in pairs(dataID) do
				if dID ~= sID then
					AuctionProfitMaster.oldGems[dID] = true
				end
			end
		end
	end
	
	return AuctionProfitMaster.oldGems[itemID]
end

function AuctionProfitMaster:GetNewGem(itemID)
	if not AuctionProfitMaster.newGems then
		AuctionProfitMaster.newGems = {}
		for sID, dataID in pairs(AuctionProfitMaster.gemData) do
			for _, dID in pairs(dataID) do
				AuctionProfitMaster.newGems[dID] = sID
			end
		end
	end
	
	return AuctionProfitMaster.newGems[itemID]
end

AuctionProfitMaster.gemData = {
	["item:40025"] = {"item:40025", "item:40085"},
	["item:40057"] = {"item:40057", "item:40056"},
	["item:40089"] = {"item:40089", "item:40031"},
	["item:40153"] = {"item:40153"},
	["item:25895"] = {"item:25895"},
	["item:32193"] = {"item:32193"},
	["item:32209"] = {"item:32209"},
	["item:32833"] = {"item:32833"},
	["item:40058"] = {"item:40058"},
	["item:40090"] = {"item:40090"},
	["item:40122"] = {"item:40122"},
	["item:40154"] = {"item:40154"},
	["item:40059"] = {"item:40059"},
	["item:40091"] = {"item:40091"},
	["item:40155"] = {"item:40155"},
	["item:25896"] = {"item:25896"},
	["item:32194"] = {"item:32194", "item:32197", "item:35487"},
	["item:24058"] = {"item:24058"},
	["item:23099"] = {"item:23099"},
	["item:23115"] = {"item:23115"},
	["item:40124"] = {"item:40124", "item:40117"},
	["item:41307"] = {"item:41307"},
	["item:41339"] = {"item:41339"},
	["item:40125"] = {"item:40125"},
	["item:40157"] = {"item:40157", "item:40131", "item:40137", "item:40148"},
	["item:25897"] = {"item:25897"},
	["item:23100"] = {"item:23100"},
	["item:23116"] = {"item:23116", "item:31860"},
	["item:40095"] = {"item:40095", "item:40096"},
	["item:40127"] = {"item:40127"},
	["item:25898"] = {"item:25898"},
	["item:23101"] = {"item:23101"},
	["item:42142"] = {"item:42142"},
	["item:40128"] = {"item:40128"},
	["item:40160"] = {"item:40160", "item:40161"},
	["item:41375"] = {"item:41375"},
	["item:40001"] = {"item:40001"},
	["item:42143"] = {"item:36766", "item:42143"},
	["item:40129"] = {"item:40129"},
	["item:41376"] = {"item:41376"},
	["item:52086"] = {"item:52086"},
	["item:24061"] = {"item:24061", "item:31865"},
	["item:40034"] = {"item:40034"},
	["item:23118"] = {"item:23118"},
	["item:42144"] = {"item:42144", "item:42148"},
	["item:40130"] = {"item:40130", "item:40136"},
	["item:40162"] = {"item:40162"},
	["item:41377"] = {"item:41377"},
	["item:39907"] = {"item:39907"},
	["item:45054"] = {"item:45054"},
	["item:40003"] = {"item:40003"},
	["item:42145"] = {"item:42145", "item:42146"},
	["item:40163"] = {"item:40163"},
	["item:41378"] = {"item:41378"},
	["item:32198"] = {"item:32198", "item:32208"},
	["item:39908"] = {"item:39908"},
	["item:39940"] = {"item:39940"},
	["item:23103"] = {"item:23103"},
	["item:23119"] = {"item:23119", "item:23121"},
	["item:40100"] = {"item:40100", "item:40099"},
	["item:40164"] = {"item:40132", "item:40164"},
	["item:33131"] = {"item:33131"},
	["item:41379"] = {"item:41379"},
	["item:52121"] = {"item:52121"},
	["item:39909"] = {"item:39909", "item:39914"},
	["item:40037"] = {"item:40037"},
	["item:40133"] = {"item:40133", "item:40134", "item:40170", "item:40175", "item:40151"},
	["item:40165"] = {"item:40165", "item:40140"},
	["item:25901"] = {"item:25901"},
	["item:52122"] = {"item:52122"},
	["item:39910"] = {"item:39910"},
	["item:39942"] = {"item:39961", "item:39942", "item:39944", "item:39953"},
	["item:40038"] = {"item:40038"},
	["item:23120"] = {"item:23120"},
	["item:40102"] = {"item:40103", "item:40102"},
	["item:40166"] = {"item:40166"},
	["item:41285"] = {"item:41285"},
	["item:33133"] = {"item:33133"},
	["item:34220"] = {"item:34220"},
	["item:39975"] = {"item:39975"},
	["item:40039"] = {"item:40039"},
	["item:42149"] = {"item:42149", "item:42153"},
	["item:40135"] = {"item:40135"},
	["item:40167"] = {"item:40167", "item:40138"},
	["item:33134"] = {"item:33134"},
	["item:41382"] = {"item:41382"},
	["item:52092"] = {"item:52092"},
	["item:52124"] = {"item:52124"},
	["item:39976"] = {"item:39938", "item:39976"},
	["item:40008"] = {"item:40008"},
	["item:40040"] = {"item:40040"},
	["item:42150"] = {"item:42150"},
	["item:40168"] = {"item:40168"},
	["item:33135"] = {"item:33135"},
	["item:35501"] = {"item:35501"},
	["item:40041"] = {"item:40041"},
	["item:42151"] = {"item:42151", "item:42157"},
	["item:40169"] = {"item:40169"},
	["item:32201"] = {"item:32201", "item:32202"},
	["item:35758"] = {"item:35758"},
	["item:24065"] = {"item:24057", "item:24065"},
	["item:39978"] = {"item:39978"},
	["item:42152"] = {"item:42152"},
	["item:32409"] = {"item:32409"},
	["item:41385"] = {"item:41385"},
	["item:35503"] = {"item:35503"},
	["item:40139"] = {"item:40139"},
	["item:40171"] = {"item:40171", "item:40176"},
	["item:24066"] = {"item:24066"},
	["item:40044"] = {"item:40030", "item:40044", "item:40053", "item:40024"},
	["item:42154"] = {"item:42154"},
	["item:32410"] = {"item:32410"},
	["item:40045"] = {"item:40045", "item:40054"},
	["item:42155"] = {"item:42155"},
	["item:40141"] = {"item:40141"},
	["item:40173"] = {"item:40173", "item:40178"},
	["item:33140"] = {"item:33140"},
	["item:23108"] = {"item:23108"},
	["item:42156"] = {"item:42156"},
	["item:40142"] = {"item:40142"},
	["item:35315"] = {"item:35315"},
	["item:40111"] = {"item:40111"},
	["item:40143"] = {"item:40143"},
	["item:31868"] = {"item:31868"},
	["item:32225"] = {"item:32225", "item:37503", "item:32216"},
	["item:39947"] = {"item:39947"},
	["item:52126"] = {"item:52126"},
	["item:24056"] = {"item:24056"},
	["item:52120"] = {"item:52120"},
	["item:52104"] = {"item:52104"},
	["item:52088"] = {"item:52088"},
	["item:32200"] = {"item:32200"},
	["item:25890"] = {"item:25890"},
	["item:23094"] = {"item:23094", "item:23113", "item:23096", "item:27777", "item:27812"},
	["item:40014"] = {"item:40014"},
	["item:31869"] = {"item:31869"},
	["item:23111"] = {"item:23111"},
	["item:42701"] = {"item:42701"},
	["item:24036"] = {"item:24036"},
	["item:24035"] = {"item:24037", "item:24035"},
	["item:39912"] = {"item:39911", "item:39912"},
	["item:24033"] = {"item:24033"},
	["item:23109"] = {"item:23106", "item:23109"},
	["item:32226"] = {"item:32226"},
	["item:42158"] = {"item:42158"},
	["item:40144"] = {"item:40144"},
	["item:39983"] = {"item:39983", "item:39989"},
	["item:39967"] = {"item:39967"},
	["item:39951"] = {"item:39951"},
	["item:39935"] = {"item:39935", "item:39937"},
	["item:33143"] = {"item:33143"},
	["item:39919"] = {"item:39919"},
	["item:39979"] = {"item:39941", "item:39943", "item:39979", "item:39984"},
	["item:52113"] = {"item:52113"},
	["item:52109"] = {"item:52109"},
	["item:52119"] = {"item:52119"},
	["item:52087"] = {"item:52087"},
	["item:52090"] = {"item:52090"},
	["item:52127"] = {"item:52127"},
	["item:52084"] = {"item:52084"},
	["item:52082"] = {"item:52082"},
	["item:42702"] = {"item:42702"},
	["item:52094"] = {"item:52094"},
	["item:31867"] = {"item:31867"},
	["item:52105"] = {"item:52105"},
	["item:24054"] = {"item:24054"},
	["item:40017"] = {"item:40017"},
	["item:40049"] = {"item:40049"},
	["item:24051"] = {"item:24051", "item:31861"},
	["item:40113"] = {"item:40123", "item:40113"},
	["item:40145"] = {"item:40145"},
	["item:40177"] = {"item:40172", "item:40177"},
	["item:24048"] = {"item:24048", "item:24050"},
	["item:52114"] = {"item:52114"},
	["item:52118"] = {"item:52118"},
	["item:33144"] = {"item:33144"},
	["item:35318"] = {"item:35318"},
	["item:40032"] = {"item:40032"},
	["item:40048"] = {"item:40048"},
	["item:40098"] = {"item:40101", "item:40098"},
	["item:23105"] = {"item:23105"},
	["item:39998"] = {"item:39998", "item:40012"},
	["item:40112"] = {"item:40114", "item:40112"},
	["item:39982"] = {"item:39982", "item:39988"},
	["item:39966"] = {"item:39966"},
	["item:39950"] = {"item:39950"},
	["item:39934"] = {"item:39934"},
	["item:39918"] = {"item:39918"},
	["item:32205"] = {"item:32205", "item:32207"},
	["item:24053"] = {"item:27679", "item:24053"},
	["item:39954"] = {"item:39962", "item:39954"},
	["item:23110"] = {"item:23110", "item:31862", "item:31864"},
	["item:23114"] = {"item:28290", "item:23114"},
	["item:39977"] = {"item:39977"},
	["item:40146"] = {"item:40146"},
	["item:24055"] = {"item:31863", "item:24055"},
	["item:32223"] = {"item:32223"},
	["item:32215"] = {"item:32215"},
	["item:32199"] = {"item:32199"},
	["item:24030"] = {"item:24047", "item:24029", "item:24030"},
	["item:24027"] = {"item:24027"},
	["item:41389"] = {"item:41389"},
	["item:40050"] = {"item:40050"},
	["item:39917"] = {"item:39917"},
	["item:31866"] = {"item:31866"},
	["item:39939"] = {"item:39939"},
	["item:39955"] = {"item:39963", "item:39955"},
	["item:40051"] = {"item:40047", "item:40051"},
	["item:39981"] = {"item:39981", "item:39986"},
	["item:40115"] = {"item:40126", "item:40115"},
	["item:40147"] = {"item:40156", "item:40147"},
	["item:40179"] = {"item:40174", "item:40179"},
	["item:24039"] = {"item:24039"},
	["item:41381"] = {"item:41381"},
	["item:25899"] = {"item:25899"},
	["item:39965"] = {"item:39964", "item:39965"},
	["item:39949"] = {"item:39949"},
	["item:39933"] = {"item:39933", "item:39974"},
	["item:32218"] = {"item:32218"},
	["item:41380"] = {"item:41380"},
	["item:40013"] = {"item:40013", "item:40002"},
	["item:39997"] = {"item:39999", "item:39997"},
	["item:32206"] = {"item:32206", "item:32210"},
	["item:32222"] = {"item:32222"},
	["item:39956"] = {"item:39956"},
	["item:23095"] = {"item:23095", "item:63697", "item:63696"},
	["item:40052"] = {"item:40043", "item:40052"},
	["item:39980"] = {"item:39980", "item:39985"},
	["item:40116"] = {"item:40116"},
	["item:40180"] = {"item:40180", "item:40181"},
	["item:39900"] = {"item:39900"},
	["item:41401"] = {"item:41401"},
	["item:41395"] = {"item:41395"},
	["item:39948"] = {"item:39948"},
	["item:52117"] = {"item:52117"},
	["item:52085"] = {"item:52085"},
	["item:49110"] = {"item:49110"},
	["item:23104"] = {"item:27785", "item:27786", "item:27820", "item:27809", "item:23104"},
	["item:32217"] = {"item:32217"},
	["item:40022"] = {"item:40022"},
	["item:40106"] = {"item:40106"},
	["item:23098"] = {"item:23098"},
	["item:39996"] = {"item:39996"},
	["item:39957"] = {"item:39957"},
	["item:41398"] = {"item:41398"},
	["item:40149"] = {"item:40158", "item:40149"},
	["item:24032"] = {"item:24052", "item:24032"},
	["item:32224"] = {"item:32224"},
	["item:52128"] = {"item:52128"},
	["item:35760"] = {"item:32219", "item:35760"},
	["item:32203"] = {"item:32203"},
	["item:24059"] = {"item:24059"},
	["item:40028"] = {"item:40028"},
	["item:25893"] = {"item:25893"},
	["item:39915"] = {"item:39915"},
	["item:39958"] = {"item:39958"},
	["item:39932"] = {"item:39932"},
	["item:40086"] = {"item:40033", "item:40086"},
	["item:40118"] = {"item:40118"},
	["item:40150"] = {"item:40159", "item:40150"},
	["item:40182"] = {"item:40182"},
	["item:41397"] = {"item:41397"},
	["item:41333"] = {"item:41333"},
	["item:24060"] = {"item:24060", "item:35316"},
	["item:32220"] = {"item:32214", "item:32220"},
	["item:52083"] = {"item:52083"},
	["item:52095"] = {"item:52095"},
	["item:35759"] = {"item:35759"},
	["item:41396"] = {"item:41396"},
	["item:24028"] = {"item:24028", "item:24031"},
	["item:41400"] = {"item:41400"},
	["item:40011"] = {"item:40011"},
	["item:28595"] = {"item:28360", "item:28361", "item:23097", "item:28595"},
	["item:35707"] = {"item:24062", "item:35707"},
	["item:39927"] = {"item:39920", "item:39927"},
	["item:39959"] = {"item:39946", "item:39959"},
	["item:39991"] = {"item:39991", "item:39990"},
	["item:40023"] = {"item:40029", "item:40023"},
	["item:40055"] = {"item:40046", "item:40055"},
	["item:40119"] = {"item:40119"},
	["item:52081"] = {"item:52081"},
	["item:36767"] = {"item:36767"},
	["item:35761"] = {"item:35761"},
	["item:39945"] = {"item:39945"},
	["item:40026"] = {"item:40026", "item:40027", "item:40092", "item:40094"},
	["item:40010"] = {"item:40009", "item:40010"},
	["item:25894"] = {"item:25894"},
	["item:40105"] = {"item:40105", "item:40104"},
	["item:33782"] = {"item:33782"},
	["item:32221"] = {"item:32221"},
	["item:52098"] = {"item:52098"},
	["item:32211"] = {"item:32211"},
	["item:39992"] = {"item:39992"},
	["item:32212"] = {"item:32213", "item:32212"},
	["item:40088"] = {"item:40088"},
	["item:40120"] = {"item:40121", "item:40120"},
	["item:40152"] = {"item:40152"},
	["item:32196"] = {"item:35488", "item:32195", "item:32196", "item:32204", "item:35489"},
	["item:32836"] = {"item:32836"},
	["item:24067"] = {"item:24067"},
	["item:41335"] = {"item:41335"},
	["item:39905"] = {"item:39906", "item:39905"},
	["item:40016"] = {"item:40016"},
	["item:40000"] = {"item:40015", "item:40000"},
	["item:39968"] = {"item:39936", "item:39968"},
	["item:39952"] = {"item:39952", "item:39960"},
}