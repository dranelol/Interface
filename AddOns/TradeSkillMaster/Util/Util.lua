-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains various utility APIs

local TSM = select(2, ...)
local lib = TSMAPI

local delays = {}
local events = {}
local private = {} -- registers for tracing at the end of this file
private.bagUpdateCallbacks = {}
private.bankUpdateCallbacks = {}
private.bagState = {}
private.bankState = {}
private.frames = {}

TSM.GOLD_TEXT = "|cffffd700g|r"
TSM.SILVER_TEXT = "|cffc7c7cfs|r"
TSM.COPPER_TEXT = "|cffeda55fc|r"
local GOLD_ICON = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
local SILVER_ICON = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"
local COPPER_ICON = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t"

--- Attempts to get the itemID from a given itemLink/itemString.
-- @param itemLink The link or itemString for the item.
-- @param ignoreGemID If true, will not attempt to get the equivalent id for the item (ie for old gems where there are multiple ids for a single item).
-- @return Returns the itemID as the first parameter. On error, will return nil as the first parameter and an error message as the second.
function TSMAPI:GetItemID(itemLink)
	if not itemLink or type(itemLink) ~= "string" then return nil, "invalid args" end
	
	local test = select(2, strsplit(":", itemLink))
	if not test then return nil, "invalid link" end
	
	local s, e = strfind(test, "[0-9]+")
	if not (s and e) then return nil, "not an itemLink" end
	
	local itemID = tonumber(strsub(test, s, e))
	if not itemID then return nil, "invalid number" end
	
	return itemID
end

local function PadNumber(num, pad)
	if num < 10 and pad then
		return format("%02d", num)
	end
	
	return tostring(num)
end

--- Creates a formatted money string from a copper value.
-- @param money The money value in copper.
-- @param color The color to make the money text (minus the 'g'/'s'/'c'). If nil, will not add any extra color formatting.
-- @param pad If true, the formatted string will be left padded.
-- @param trim If true, will remove any 0 valued tokens. For example, "1g" instead of "1g0s0c". If money is zero, will return "0c".
-- @param disabled If true, the g/s/c text will not be colored.
-- @return Returns the formatted money text according to the parameters.
function TSMAPI:FormatTextMoney(money, color, pad, trim, disabled)
	local money = tonumber(money)
	if not money then return end
	
	local isNegative = money < 0
	money = abs(money)
	local gold = floor(money / COPPER_PER_GOLD)
	local silver = floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = floor(money%COPPER_PER_SILVER)
	local text = ""
	local isFirst = true
	
	-- Trims 0 silver and/or 0 copper from the text
	if trim then
	    if gold > 0 then
			if color then
				text = format("%s%s ", color..PadNumber(gold, pad and not isFirst).."|r", disabled and "g" or TSM.GOLD_TEXT)
			else
				text = format("%s%s ", PadNumber(gold, pad and not isFirst), disabled and "g" or TSM.GOLD_TEXT)
			end
			isFirst = false
		end
		if silver > 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(silver, pad and not isFirst).."|r", disabled and "s" or TSM.SILVER_TEXT)
			else
				text = format("%s%s%s ", text, PadNumber(silver, pad and not isFirst), disabled and "s" or TSM.SILVER_TEXT)
			end
			isFirst = false
		end
		if copper > 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(copper, pad and not isFirst).."|r", disabled and "c" or TSM.COPPER_TEXT)
			else
				text = format("%s%s%s ", text, PadNumber(copper, pad and not isFirst), disabled and "c" or TSM.COPPER_TEXT)
			end
			isFirst = false
		end
		if money == 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(copper, pad and not isFirst).."|r", disabled and "c" or TSM.COPPER_TEXT)
			else
				text = format("%s%s%s ", text, PadNumber(copper, pad  and not isFirst), disabled and "c" or TSM.COPPER_TEXT)
			end
			isFirst = false
		end
	else
		-- Add gold
		if gold > 0 then
			if color then
				text = format("%s%s ", color..PadNumber(gold, pad  and not isFirst).."|r", disabled and "g" or TSM.GOLD_TEXT)
			else
				text = format("%s%s ", PadNumber(gold, pad  and not isFirst), disabled and "g" or TSM.GOLD_TEXT)
			end
			isFirst = false
		end
	
		-- Add silver
		if gold > 0 or silver > 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(silver, pad  and not isFirst).."|r", disabled and "s" or TSM.SILVER_TEXT)
			else
				text = format("%s%s%s ", text, PadNumber(silver, pad  and not isFirst), disabled and "s" or TSM.SILVER_TEXT)
			end
			isFirst = false
		end
	
		-- Add copper
		if color then
			text = format("%s%s%s ", text, color..PadNumber(copper, pad  and not isFirst).."|r", disabled and "c" or TSM.COPPER_TEXT)
		else
			text = format("%s%s%s ", text, PadNumber(copper, pad  and not isFirst), disabled and "c" or TSM.COPPER_TEXT)
		end
	end
	
	if isNegative then
		if color then
			return color .. "-|r" .. text:trim()
		else
			return "-" .. text:trim()
		end
	else
		return text:trim()
	end
end

--- Creates a formatted money string from a copper value and uses coin icon.
-- @param money The money value in copper.
-- @param color The color to make the money text (minus the coin icons). If nil, will not add any extra color formatting.
-- @param pad If true, the formatted string will be left padded.
-- @param trim If true, will not remove any 0 valued tokens. For example, "1g" instead of "1g0s0c". If money is zero, will return "0c".
-- @return Returns the formatted money text according to the parameters.
function TSMAPI:FormatTextMoneyIcon(money, color, pad, trim)
	local money = tonumber(money)
	if not money then return end
	local isNegative = money < 0
	money = abs(money)
	local gold = floor(money / COPPER_PER_GOLD)
	local silver = floor((money - (gold * COPPER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = floor(money%COPPER_PER_SILVER)
	local text = ""
	local isFirst = true
	
	-- Trims 0 silver and/or 0 copper from the text
	if trim then
	    if gold > 0 then
			if color then
				text = format("%s%s ", color..PadNumber(gold, pad  and not isFirst).."|r", GOLD_ICON)
			else
				text = format("%s%s ", PadNumber(gold, pad  and not isFirst), GOLD_ICON)
			end
			isFirst = false
		end
		if silver > 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(silver, pad  and not isFirst).."|r", SILVER_ICON)
			else
				text = format("%s%s%s ", text, PadNumber(silver, pad  and not isFirst), SILVER_ICON)
			end
			isFirst = false
		end
		if copper > 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(copper, pad  and not isFirst).."|r", COPPER_ICON)
			else
				text = format("%s%s%s ", text, PadNumber(copper, pad  and not isFirst), COPPER_ICON)
			end
			isFirst = false
		end
		if money == 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(copper, pad  and not isFirst).."|r", COPPER_ICON)
			else
				text = format("%s%s%s ", text, PadNumber(copper, pad  and not isFirst), COPPER_ICON)
			end
			isFirst = false
		end
	else
		-- Add gold
		if gold > 0 then
			if color then
				text = format("%s%s ", color..PadNumber(gold, pad  and not isFirst).."|r", GOLD_ICON)
			else
				text = format("%s%s ", PadNumber(gold, pad  and not isFirst), GOLD_ICON)
			end
			isFirst = false
		end
	
		-- Add silver
		if gold > 0 or silver > 0 then
			if color then
				text = format("%s%s%s ", text, color..PadNumber(silver, pad  and not isFirst).."|r", SILVER_ICON)
			else
				text = format("%s%s%s ", text, PadNumber(silver, pad  and not isFirst), SILVER_ICON)
			end
			isFirst = false
		end
	
		-- Add copper
		if color then
			text = format("%s%s%s ", text, color..PadNumber(copper, pad  and not isFirst).."|r", COPPER_ICON)
		else
			text = format("%s%s%s ", text, PadNumber(copper, pad  and not isFirst), COPPER_ICON)
		end
	end
	
	if isNegative then
		if color then
			return color .. "-|r" .. text:trim()
		else
			return "-" .. text:trim()
		end
	else
		return text:trim()
	end
end

-- Converts a formated money string back to the copper value
function TSMAPI:UnformatTextMoney(value)
	-- remove any colors
	value = gsub(value, "|cff([0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])", "")
	value = gsub(value, "|r", "")
	
	-- extract gold/silver/copper values
	local gold = tonumber(string.match(value, "([0-9]+)g"))
	local silver = tonumber(string.match(value, "([0-9]+)s"))
	local copper = tonumber(string.match(value, "([0-9]+)c"))
		
	if gold or silver or copper then
		-- Convert it all into copper
		copper = (copper or 0) + ((gold or 0) * COPPER_PER_GOLD) + ((silver or 0) * COPPER_PER_SILVER)
	end

	return copper
end

--- Shows a popup dialog with the given name and ensures it's visible over the TSM frame by setting the frame strata to TOOLTIP.
-- @param name The name of the static popup dialog to be shown.
function TSMAPI:ShowStaticPopupDialog(name)
	StaticPopupDialogs[name].preferredIndex = 3
	StaticPopup_Show(name)
	for i=1, 100 do
		if _G["StaticPopup" .. i] and _G["StaticPopup" .. i].which == name then
			_G["StaticPopup" .. i]:SetFrameStrata("TOOLTIP")
			break
		end
	end
end

function TSMAPI:GetCharacters()
	return CopyTable(TSM.db.factionrealm.characters)
end


-- OnUpdate script handler for delay frames
local function DelayFrameOnUpdate(self, elapsed)
	if self.inUse == "repeat" then
		self.callback()
	elseif self.inUse == "delay" then
		self.timeLeft = self.timeLeft - elapsed
		if self.timeLeft <= 0 then
			if self.repeatDelay then
				self.timeLeft = self.repeatDelay
			else
				lib:CancelFrame(self)
			end
			if self.callback then
				self.callback()
			end
		end
	end
end

-- Helper function for creating delay frames
local function CreateDelayFrame()
	local delay = CreateFrame("Frame")
	delay:Hide()
	delay:SetScript("OnUpdate", DelayFrameOnUpdate)
	return delay
end

--- Creates a time-based delay. The callback function will be called after the specified duration.
-- Use TSMAPI:CancelFrame(label) to cancel delays (usually just used for repetitive delays).
-- @param label An arbitrary label for this delay. If a delay with this label has already been started, the request will be ignored.
-- @param duration How long before the callback should be called. This is generally accuate within 50ms (depending on frame rate).
-- @param callback The function to be called after the duration expires.
-- @param repeatDelay If you want this delay to repeat until canceled, after the initial duration expires, will restart the callback with this duration. Passing nil means no repeating.
-- @return Returns an error message as the second return value on error.
function TSMAPI:CreateTimeDelay(...)
	local label, duration, callback, repeatDelay
	if type(select(1, ...)) == "number" then
		-- use unique string as placeholder label if none specified
		label = tostring({})
		duration, callback, repeatDelay = ...
	else
		label, duration, callback, repeatDelay = ...
	end
	if not label or type(duration) ~= "number" or type(callback) ~= "function" then return nil, "invalid args", label, duration, callback, repeatDelay end

	local frameNum
	for i, frame in ipairs(delays) do
		if frame.label == label then return end
		if not frame.inUse then
			frameNum = i
		end
	end
	
	if not frameNum then
		-- all the frames are in use, create a new one
		tinsert(delays, CreateDelayFrame())
		frameNum = #delays
	end
	
	local frame = delays[frameNum]
	frame.inUse = "delay"
	frame.repeatDelay = repeatDelay
	frame.label = label
	frame.timeLeft = duration
	frame.callback = callback
	frame:Show()
end

--- The passed callback function will be called once every OnUpdate until canceled via TSMAPI:CancelFrame(label).
-- @param label An arbitrary label for this delay. If a delay with this label has already been started, the request will be ignored.
-- @param callback The function to be called every OnUpdate.
-- @return Returns an error message as the second return value on error.
function TSMAPI:CreateFunctionRepeat(label, callback)
	if not label or label == "" or type(callback) ~= "function" then return nil, "invalid args", label, callback end

	local frameNum
	for i, frame in ipairs(delays) do
		if frame.label == label then return end
		if not frame.inUse then
			frameNum = i
		end
	end
	
	if not frameNum then
		-- all the frames are in use, create a new one
		tinsert(delays, CreateDelayFrame())
		frameNum = #delays
	end
	
	local frame = delays[frameNum]
	frame.inUse = "repeat"
	frame.label = label
	frame.callback = callback
	frame:Show()
end

--- Cancels a frame created through TSMAPI:CreateTimeDelay() or TSMAPI:CreateFunctionRepeat().
-- Frames are automatically recycled to avoid memory leaks.
-- @param label The label of the frame you want to cancel.
function TSMAPI:CancelFrame(label)
	if label == "" then return end
	local delayFrame
	if type(label) == "table" then
		delayFrame = label
	else
		for i, frame in ipairs(delays) do
			if frame.label == label then
				delayFrame = frame
			end
		end
	end
	
	if delayFrame then
		delayFrame:Hide()
		delayFrame.label = nil
		delayFrame.inUse = nil
		delayFrame.validate = nil
		delayFrame.timeLeft = nil
	end
end


local function EventFrameOnUpdate(self)
	for event, data in pairs(self.events) do
		if data.eventPending and GetTime() > (data.lastCallback + data.bucketTime) then
			data.eventPending = nil
			data.lastCallback = GetTime()
			data.callback()
		end
	end
end

local function EventFrameOnEvent(self, event)
	self.events[event].eventPending = true
end

local function CreateEventFrame()
	local event = CreateFrame("Frame")
	event:Show()
	event:SetScript("OnEvent", EventFrameOnEvent)
	event:SetScript("OnUpdate", EventFrameOnUpdate)
	event.events = {}
	return event
end

function TSMAPI:CreateEventBucket(event, callback, bucketTime)
	local eventFrame
	for _, frame in ipairs(events) do
		if not frame.events[event] then
			eventFrame = frame
			break
		end
	end
	if not eventFrame then
		eventFrame = CreateEventFrame()
		tinsert(events, eventFrame)
	end
	
	eventFrame:RegisterEvent(event)
	eventFrame.events[event] = {callback=callback, bucketTime=bucketTime, lastCallback=0}
end


local orig = ChatFrame_OnEvent
function ChatFrame_OnEvent(self, event, ...)
	local msg = select(1, ...)
	if (event == "CHAT_MSG_SYSTEM") then
		if (msg == ERR_AUCTION_STARTED) then -- absorb the Auction Created message
			return
		end
		if (msg == ERR_AUCTION_REMOVED) then -- absorb the Auction Cancelled message
			return
		end
	end
	return orig(self, event, ...)
end

function TSMAPI:SafeTooltipLink(link)
	if strmatch(link, "battlepet") then
		local _, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID = strsplit(":", link)
		BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed), gsub(gsub(link, "^(.*)%[", ""), "%](.*)$", ""))
	else
		GameTooltip:SetHyperlink(link)
	end
end


function TSMAPI:GetItemString(item)
	if type(item) == "string" then
		item = item:trim()
	end
	
	if type(item) ~= "string" and type(item) ~= "number" then
		return nil, "invalid arg type"
	end
	item = select(2, TSMAPI:GetSafeItemInfo(item)) or item
	if tonumber(item) then
		return "item:"..item..":0:0:0:0:0:0"
	end
	
	local itemInfo = {strfind(item, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")}
	if not itemInfo[11] then return nil, "invalid link" end
	itemInfo[11] = tonumber(itemInfo[11]) or 0
	
	if itemInfo[4] == "item" then
		for i=6, 10 do itemInfo[i] = 0 end
		return table.concat(itemInfo, ":", 4, 11)
	else
		return table.concat(itemInfo, ":", 4, 7)
	end
end

function TSMAPI:GetBaseItemString(itemString, doGroupLookup)
	if type(itemString) ~= "string" then return end
	if strsub(itemString, 1, 2) == "|c" then
		-- this is an itemLink so get the itemString first
		itemString = TSMAPI:GetItemString(itemString)
		if not itemString then return end
	end
	
	local parts = {(":"):split(itemString)}
	for i=3, #parts do
		parts[i] = 0
	end
	local baseItemString = table.concat(parts, ":")
	if not doGroupLookup then return baseItemString end
	
	if TSM.db.profile.items[itemString] and TSM.db.profile.items[baseItemString] then
		return itemString
	elseif TSM.db.profile.items[baseItemString] then
		return baseItemString
	else
		return itemString
	end
end

local itemInfoCache = {}
local PET_CAGE_ITEM_INFO = {isDefault=true, 0, "Battle Pets", "", 1, "", "", 0}
function TSMAPI:GetSafeItemInfo(link)
	if type(link) ~= "string" then return end
	
	if not itemInfoCache[link] then
		if strmatch(link, "battlepet:") then
			local _, speciesID, level, quality, health, power, speed, petID = strsplit(":", link)
			if not tonumber(speciesID) then return end
			level, quality, health, power, speed, petID = level or 0, quality or 0, health or 0, power or 0, speed or 0, petID or "0"
			
			local name, texture = C_PetJournal.GetPetInfoBySpeciesID(tonumber(speciesID))
			if name == "" then return end
			level, quality = tonumber(level), tonumber(quality)
			petID = strsub(petID, 1, (strfind(petID, "|") or #petID)-1)
			link = ITEM_QUALITY_COLORS[quality].hex.."|Hbattlepet:"..speciesID..":"..level..":"..quality..":"..health..":"..power..":"..speed..":"..petID.."|h["..name.."]|h|r"
			if PET_CAGE_ITEM_INFO.isDefault then
				local data = {select(5, GetItemInfo(82800))}
				if #data > 0 then
					PET_CAGE_ITEM_INFO = data
				end
			end
			local minLvl, iType, _, stackSize, _, _, vendorPrice = unpack(PET_CAGE_ITEM_INFO)
			local subType, equipLoc = 0, ""
			itemInfoCache[link] = {name, link, quality, level, minLvl, iType, subType, stackSize, equipLoc, texture, vendorPrice}
		elseif strmatch(link, "item:") then
			itemInfoCache[link] = {GetItemInfo(link)}
		end
		if itemInfoCache[link] and #itemInfoCache[link] == 0 then itemInfoCache[link] = nil end
	end
	if not itemInfoCache[link] then return end
	return unpack(itemInfoCache[link])
end


function private:OnBagUpdate()
	local newState = {}
	local didChange
	for bag, slot, itemString, quantity in TSMAPI:GetBagIterator() do
		newState[itemString] = (newState[itemString] or 0) + quantity
		if not private.bagState[itemString] then
			didChange = true
		elseif private.bagState[itemString] then
			if private.bagState[itemString] ~= quantity then
				didChange = true
			end
			private.bagState[itemString] = nil
		end
	end
	didChange = didChange or (next(private.bagState) and true)
	private.bagState = newState

	if didChange then
		for _, callback in ipairs(private.bagUpdateCallbacks) do
			callback(private.bagState)
		end
	end
end

function private:OnBankUpdate()
	if not private.bankOpened then return end
	local newState = {}
	local didChange
	for bag, slot, itemString, quantity in TSMAPI:GetBankIterator() do
		newState[itemString] = (newState[itemString] or 0) + quantity
		if not private.bankState[itemString] then
			didChange = true
		elseif private.bankState[itemString] then
			if private.bankState[itemString] ~= quantity then
				didChange = true
			end
			private.bankState[itemString] = nil
		end
	end
	didChange = didChange or (next(private.bankState) and true)
	private.bankState = newState

	if didChange then
		for _, callback in ipairs(private.bankUpdateCallbacks) do
			callback(private.bankState)
		end
	end
end

function TSMAPI:RegisterForBagChange(callback)
	assert(type(callback) == "function", format("Expected function, got %s.", type(callback)))
	tinsert(private.bagUpdateCallbacks, callback)
end

function TSMAPI:RegisterForBankChange(callback)
	assert(type(callback) == "function", format("Expected function, got %s.", type(callback)))
	tinsert(private.bankUpdateCallbacks, callback)
end


-- check if an item is soulbound or not
local function GetTooltipCharges(tooltip)
	for id=1, tooltip:NumLines() do
		local text = _G["TSMSoulboundScanTooltipTextLeft" .. id]
		if text and text:GetText() then
			local maxCharges = strmatch(text:GetText(), "^([0-9]+) Charges?$")
			if maxCharges then
				return maxCharges
			end
		end
	end
end
local scanTooltip
local resultsCache = {lastClear=GetTime()}
function TSMAPI:IsSoulbound(bag, slot)
	if GetTime() - resultsCache.lastClear > 0.5 then
		resultsCache = {lastClear=GetTime()}
	end
	
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", "TSMSoulboundScanTooltip", UIParent, "GameTooltipTemplate")
		scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	scanTooltip:ClearLines()
	
	local slotID
	if type(bag) == "string" then
		if strfind(bag, "battlepet") then return end
		slotID = bag
		scanTooltip:SetHyperlink(slotID)
	elseif bag and slot then
		slotID = bag.."@"..slot
		local itemID = GetContainerItemID(bag, slot)
		local maxCharges
		if itemID then
			scanTooltip:SetItemByID(itemID)
			maxCharges = GetTooltipCharges(scanTooltip)
		end
		scanTooltip:SetBagItem(bag, slot)
		if maxCharges then
			if GetTooltipCharges(scanTooltip) ~= maxCharges then
				resultsCache[slotID] = true
				return resultsCache[slotID]
			end
		end
	else
		return
	end
	
	if resultsCache[slotID] ~= nil then return resultsCache[slotID] end
	resultsCache[slotID] = false
	for id=1, scanTooltip:NumLines() do
		local text = _G["TSMSoulboundScanTooltipTextLeft" .. id]
		if text and ((text:GetText() == ITEM_BIND_ON_PICKUP and id < 4) or text:GetText() == ITEM_SOULBOUND or text:GetText() == ITEM_BIND_QUEST) then
			resultsCache[slotID] = true
			break
		end
	end
	return resultsCache[slotID]
end

-- Makes sure this bag is an actual bag and not an ammo, soul shard, etc bag
local function IsValidBag(bag)
	if bag == 0 then return true end
	
	-- family 0 = bag with no type, family 1/2/4 are special bags that can only hold certain types of items
	local itemFamily = GetItemFamily(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)))
	return itemFamily and (itemFamily == 0 or itemFamily > 4)
end

function TSMAPI:GetBagIterator(autoBaseItems, includeSoulbound)
	local bags, b, s = {}, 1, 0
	for bag=0, NUM_BAG_SLOTS do
		if IsValidBag(bag) then
			tinsert(bags, bag)
		end
	end

	local iter
	iter = function()
		if bags[b] then
			if s < GetContainerNumSlots(bags[b]) then
				s = s + 1
			else
				s = 1
				b = b + 1
				if not bags[b] then return end
			end
			
			local link = GetContainerItemLink(bags[b], s)
			if not link then
				return iter()
			end
			local itemString
			if autoBaseItems then
				itemString = TSMAPI:GetBaseItemString(link, true)
			else
				itemString = TSMAPI:GetItemString(link)
			end
			if not itemString or (not includeSoulbound and TSMAPI:IsSoulbound(bags[b], s)) then
				return iter()
			else
				local _, quantity, locked = GetContainerItemInfo(bags[b], s)
				return bags[b], s, itemString, quantity, locked
			end
		end
	end
	
	return iter
end

function TSMAPI:GetBankIterator(autoBaseItems, includeSoulbound)
	local bags, b, s = {}, 1, 0
	tinsert(bags, -1)
	for bag=NUM_BAG_SLOTS+1, NUM_BAG_SLOTS+NUM_BANKBAGSLOTS do
		if IsValidBag(bag) then
			tinsert(bags, bag)
		end
	end

	local iter
	iter = function()
		if bags[b] then
			if s < GetContainerNumSlots(bags[b]) then
				s = s + 1
			else
				s = 1
				b = b + 1
				if not bags[b] then return end
			end
			local link = GetContainerItemLink(bags[b], s)
			local itemString
			if autoBaseItems then
				itemString = TSMAPI:GetBaseItemString(link, true)
			else
				itemString = TSMAPI:GetItemString(link)
			end
			if not itemString or (not includeSoulbound and TSMAPI:IsSoulbound(bags[b], s)) then
				return iter()
			else
				local _, quantity, locked = GetContainerItemInfo(bags[b], s)
				return bags[b], s, itemString, quantity, locked
			end
		end
	end
	
	return iter
end

function TSMAPI:ItemWillGoInBag(link, bag)
	if not link or not bag then return end
	if bag == 0 then return true end
	local itemFamily = GetItemFamily(link)
	local bagFamily = GetItemFamily(GetBagName(bag))
	if not bagFamily then return end
	return bagFamily == 0 or bit.band(itemFamily, bagFamily) > 0
end


local MAGIC_CHARACTERS = {'[', ']', '(', ')', '.', '+', '-', '*', '?', '^', '$'}
function TSMAPI:StrEscape(str)
	str = gsub(str, "%%", "\001")
	for _, char in ipairs(MAGIC_CHARACTERS) do
		str = gsub(str, "%"..char, "%%"..char)
	end
	str = gsub(str, "\001", "%%%%")
	return str
end



do
	local BUCKET_TIME = 0.5
	local function EventHandler(event, bag)
		if event == "BANKFRAME_OPENED" then
			private.bankOpened = true
		elseif event == "BANKFRAME_CLOSED" then
			private.bankOpened = nil
		end
		if event == "BAG_UPDATE" then
			if bag > NUM_BAG_SLOTS then
				TSMAPI:CreateTimeDelay("bankStateUpdate", BUCKET_TIME, private.OnBankUpdate)
			else
				TSMAPI:CreateTimeDelay("bagStateUpdate", BUCKET_TIME, private.OnBagUpdate)
			end
		elseif event == "PLAYER_ENTERING_WORLD" then
			TSMAPI:CreateTimeDelay("bagStateUpdate", BUCKET_TIME, private.OnBagUpdate)
			TSMAPI:CreateTimeDelay("bankStateUpdate", BUCKET_TIME, private.OnBankUpdate)
		elseif event == "BANKFRAME_OPENED" or event == "PLAYERBANKSLOTS_CHANGED" then
			TSMAPI:CreateTimeDelay("bankStateUpdate", BUCKET_TIME, private.OnBankUpdate)
		end
	end

	TSM.RegisterEvent(private, "BAG_UPDATE", EventHandler)
	TSM.RegisterEvent(private, "BANKFRAME_OPENED", EventHandler)
	TSM.RegisterEvent(private, "BANKFRAME_CLOSED", EventHandler)
	TSM.RegisterEvent(private, "PLAYER_ENTERING_WORLD", EventHandler)
	TSM.RegisterEvent(private, "PLAYERBANKSLOTS_CHANGED", EventHandler)
end


-- Registers a movable/resizable frame which TSM will keep track of and persistently store its position / size.
-- The frame must be named for this function to work.
-- Required defaults
--          x  -  x position
--          y  -  y position
--      width  -  width
--     height  -  height
--      scale  -  scale
function TSMAPI:CreateMovableFrame(name, defaults, parent)
	local options = TSM.db.global.frameStatus[name] or CopyTable(defaults)
	options.defaults = defaults
	TSM.db.global.frameStatus[name] = options
	
	local frame = CreateFrame("Frame", name, parent)
	frame:Hide()
	frame:SetHeight(options.height)
	frame:SetWidth(options.width)
	frame:SetScale(UIParent:GetScale()*options.scale)
	frame:SetPoint("CENTER", frame:GetParent())
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:SetClampRectInsets(options.width-50, -(options.width-50), -(options.height-50), options.height-50)
	frame:SetScript("OnMouseDown", frame.StartMoving)
	frame:SetScript("OnMouseUp", function(self)
			self:StopMovingOrSizing()
			options.x = self:GetLeft()
			options.y = self:GetBottom()
		end)
	frame:SetScript("OnSizeChanged", function(self)
			options.width = self:GetWidth()
			options.height = self:GetHeight()
			self:SetClampRectInsets(options.width-50, -(options.width-50), -(options.height-50), options.height-50)
		end)
	frame.RefreshPosition = function(self)
		self:SetScale(UIParent:GetScale()*options.scale)
		self:SetFrameLevel(0)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", UIParent, options.x, options.y)
		self:SetWidth(options.width)
		self:SetHeight(options.height)
	end
	frame:SetScript("OnShow", frame.RefreshPosition)
	frame.options = options
	tinsert(private.frames, frame)
	
	return frame
end

function TSM:ResetFrames()
	for _, frame in ipairs(private.frames) do
		-- reset all fields to the default values without breaking any table references
		local options = TSM.db.global.frameStatus[frame:GetName()]
		local defaults = options.defaults
		for i, v in pairs(defaults) do options[i] = v end
		if frame and frame:IsVisible() then
			frame:RefreshPosition()
		end
	end
	
	-- explicitly reset bankui since it can't easily use TSMAPI:CreateMovableFrame
	TSM:ResetBankUIFramePosition()
end


-- A more versitile replacement for lua's select() function
-- If a list of indices is passed as the first parameter, only
-- those values will be returned, otherwise, the default select()
-- behavior will be followed.
function private:SelectHelper(positions, ...)
	if #positions == 0 then return end
	return select(tremove(positions), ...), private:SelectHelper(positions, ...)
end
function TSMAPI:Select(positions, ...)
	if type(positions) == "number" then
		return select(positions, ...)
	elseif type(positions) == "table" then
		-- reverse the list and make a copy of it
		local newPositions = {}
		for i=#positions, 1, -1 do
			tinsert(newPositions, positions[i])
		end
		return private:SelectHelper(newPositions, ...)
	else
		error(format("Bad argument #1. Expected number or table, got %s", type(positions)))
	end
	if type(positions) == "table" then
	elseif type(positions) == "number" then
	
	end
end

-- custom string splitting function that doesn't stack overflow
function TSMAPI:SafeStrSplit(str, sep)
	local parts = {}
	local s = 1
	while true do
		local e = strfind(str, sep, s)
		if not e then
			tinsert(parts, strsub(str, s))
			break
		end
		tinsert(parts, strsub(str, s, e-1))
		s = e + 1
	end
	return parts
end


-- This MUST be at the end for this file since RegisterForTracing uses some function defined in this file.
TSMAPI:RegisterForTracing(private, "TradeSkillMaster.Util_private")