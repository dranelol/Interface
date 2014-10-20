local _, AskMrRobot = ...

local MAX_GEMS_PER_SLOT = 3

-- make the JewelPanel inherit from a dummy frame
AskMrRobot.JewelPanel = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- JewelPanel constructor
function AskMrRobot.JewelPanel:new (name, parent)
	-- create a new frame if one isn't supplied
	local o = AskMrRobot.Frame:new(name, parent)

	-- make the object a JewelPanel instanct
	setmetatable(o, { __index = AskMrRobot.JewelPanel})

	-- set the height and border of the newly created jewel frame
	o:SetHeight(95)
	o:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16})

	-- setup the slot name
	o._slotName = o:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	o._slotName:SetPoint("TOPLEFT", 11, -10)
	o._slotName:SetWidth(80)
	o._slotName:SetJustifyH("LEFT")

	-- setup the item icon frame
	o._itemIcon = AskMrRobot.ItemIcon:new()
	o._itemIcon:SetParent(o)
	o._itemIcon:SetRoundBorder()
	o._itemIcon:SetPoint("TOPLEFT", 9, -32)
	o._itemIcon:SetWidth(48)
	o._itemIcon:SetHeight(48)

	-- initialize the current gems array
	o._currentGems = {}
	o._optimizedGemText = {}
	o._optimizedGemIcons = {}
	-- for each row of gems
	for i = 1, MAX_GEMS_PER_SLOT do
		-- create an item icon for the currently equiped gem
		local gemIcon = AskMrRobot.GemIcon:new(nil, o)
		gemIcon:SetPoint("TOPLEFT", 100, 18 - 27 * i)
		gemIcon:SetWidth(24)
		gemIcon:SetHeight(24)
		gemIcon:SetRoundBorder()
		o._currentGems[i] = gemIcon

		-- create an item icon for the optimized gem
		gemIcon = AskMrRobot.GemIcon:new(nil, o)
		gemIcon:SetPoint("TOPLEFT", 170, 18 - 27 * i)
		gemIcon:SetWidth(24)
		gemIcon:SetHeight(24)
		gemIcon:SetRoundBorder()
		o._optimizedGemIcons[i] = gemIcon		

		-- create the optimized gem text
		local gemText = o:CreateFontString(nil, "ARTWORK", "GameFontWhite")		
		gemText:SetPoint("TOPLEFT", 200, 12 - 27 * i)
		gemText:SetPoint("RIGHT", -30)
		gemText:SetJustifyH("LEFT")
		o._optimizedGemText[i] = gemText
	end	

	-- return the JewelPanel instance
	return o
end

-- set the item link for this JewelPanel
-- this updates the item icon, the slot name, and the tooltip
function AskMrRobot.JewelPanel:SetItemLink(slotName, itemLink)
	-- set the item icon and the tooltip
	self._itemIcon:SetItemLink(itemLink)

	if itemLink then
		local _, _, rarity = GetItemInfo(itemLink)
		if rarity then
			local r,g,b = GetItemQualityColor(rarity)
			self._itemIcon:SetBackdropBorderColor(r,g,b,1)
		else
			self._itemIcon:SetBackdropBorderColor(1,1,1,1)
		end
	else
		self._itemIcon:SetBackdropBorderColor(1,1,1,1)
	end

	-- set the slot name
	self._slotName:SetText(slotName)
end

-- set the optimized gem information (array of {id, color, enchantId})
-- SetItemLink must be called first
function AskMrRobot.JewelPanel:SetOptimizedGems(optimizedGems, showGems)

	-- get the item link
	local itemLink = self._itemIcon.itemLink

	if not itemLink then return end

	-- for all of the gem rows in this control
	local itemId = AskMrRobot.getItemIdFromLink(itemLink)

	local gemCount = 0

	for i = 1, MAX_GEMS_PER_SLOT do
		-- get the optimized text, optimized icon, and current icon for the row
		local text = self._optimizedGemText[i]
		local optimizedIcon = self._optimizedGemIcons[i]
		local currentIcon = self._currentGems[i]

		-- get the current gem in the specified slot
		local currentGemLink = select(2, GetItemGem(itemLink, i))

		-- if there is a gem to add (or remove)
		--if i <= #optimizedGems or currentGemLink then
		if i <= #optimizedGems or currentGemLink then
			local optimizedGemId = 0
			if optimizedGems[i] > 0 then
				optimizedGemId = AskMrRobot.ExtraGemData[optimizedGems[i]].id
			end
			--local currentGemId = AskMrRobot.ExtraGemData[showGems[i]].id

			-- set the current gem icon / tooltip
			currentIcon:SetItemLink(currentGemLink)

			local currentGemId = AskMrRobot.getItemIdFromLink(currentGemLink)

			local optimizedGemLink = nil
			if i <= #optimizedGems then
				-- make a link for the optimized gem
				optimizedGemLink = select(2, GetItemInfo(optimizedGemId))

				if not optimizedGemLink and optimizedGemId and itemId then
					AskMrRobot.RegisterItemInfoCallback(optimizedGemId, function(name, link)
						optimizedIcon:SetItemLink(link)
					end)
				end
			end
			

			local mismatched = not AskMrRobot.AreGemsCompatible(optimizedGems[i], showGems[i])

			--if showGems[i] and optimizedGems[i] and optimizedGems[i].color then
			--if test and optimizedGems[i] and optimizedGems[i].color then
			if mismatched and optimizedGems[i] > 0 then
				gemCount = gemCount + 1
				-- set the optimized gem text
				text:SetTextColor(1,1,1)
				--text:SetText(AskMrRobot.alternateGemName[optimizedGemId] or (optimizedGems[i] ~= 0 and AskMrRobot.getEnchantName(optimizedGems[i])) or GetItemInfo(optimizedGemId))

				text:SetText(AskMrRobot.ExtraGemData[optimizedGems[i]].text)

				currentIcon:Show()

				-- load the item image / tooltip
				optimizedIcon:SetItemLink(optimizedGemLink)
				optimizedIcon:Show()
				optimizedIcon:SetBackdropBorderColor(1,1,1)
				currentIcon:SetBackdropBorderColor(1,1,1)
			else
				--if optimizedGems[i] and optimizedGems[i].color then
				if optimizedGems[i] then
					text:SetText("no change")
					text:SetTextColor(0.5,0.5,0.5)
					currentIcon:Show()
					gemCount = gemCount + 1
				else
					text:SetText('')
					currentIcon:Hide()
				end
				optimizedIcon:SetItemLink(nil)
				optimizedIcon:Hide()
			end

			-- TODO highlight the socket color
			local socketColorId = AskMrRobot.ExtraItemData[itemId].socketColors[i]
			local socketName = AskMrRobot.socketColorIds[socketColorId];
			currentIcon:SetGemColor(optimizedGems[i] and socketName)
			optimizedIcon:SetGemColor(optimizedGems[i] and socketName)

			-- show the gem row
			text:Show()			
		else
			-- hide the gem row
			text:Hide()
			optimizedIcon:Hide()
			currentIcon:Hide()
		end		
	end

	local y1 = 0
	local y2 = 0
	if gemCount == 1 then
		y1 = 27
	elseif gemCount == 2 then
		y1 = 9
		y2 = 4
	end

	for i = 1, MAX_GEMS_PER_SLOT do
		self._optimizedGemText[i]:SetPoint("TOPLEFT", 200, 12 - (27 + y2) * i - y1)
		self._optimizedGemIcons[i]:SetPoint("TOPLEFT", 170, 18 - (27 + y2) * i - y1)
		self._currentGems[i]:SetPoint("TOPLEFT", 100, 18 - (27 + y2) * i - y1)
	end
end
