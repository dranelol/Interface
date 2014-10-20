local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the ShoppingListTab class
AskMrRobot.ShoppingListTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

StaticPopupDialogs["SHOPPING_TAB_PLEASE_OPEN"] = {
	text = L.AMR_SHOPPINGLISTTAB_OPEN_MAIL,
	button1 = L.AMR_SHOPPINGLISTTAB_BUTTON_OK,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

function AskMrRobot.ShoppingListTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)
	setmetatable(tab, { __index = AskMrRobot.ShoppingListTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()
	tab:RegisterEvent("AUCTION_HOUSE_CLOSED")
	tab:RegisterEvent("AUCTION_HOUSE_SHOW")
	tab:RegisterEvent("MAIL_SHOW")
	tab:RegisterEvent("MAIL_CLOSED")

	tab.isAuctionHouseVisible = false

	tab:SetScript("OnEvent", function(...)
		tab:OnEvent(...)
	end)

	tab.shoppingListHeader = AskMrRobot.FontString:new(tab, nil, "ARTWORK", "GameFontNormalLarge")
	tab.shoppingListHeader:SetPoint("TOPLEFT", 0, -5)
	tab.shoppingListHeader:SetText(L.AMR_SHOPPINGLISTTAB_TITLE)

	tab.shoppingPanel = AskMrRobot.Frame:new(nil, tab)
	tab.shoppingPanel:SetPoint("TOPLEFT", tab.shoppingListHeader, "BOTTOMLEFT", 0, -10)
	tab.shoppingPanel:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -20, 17)


	tab.sendButton = CreateFrame("Button", "AmrSendButton", tab.shoppingPanel, "UIPanelButtonTemplate")
	tab.sendButton:SetText(L.AMR_SHOPPINGLISTTAB_BUTTON_SEND)
	tab.sendButton:SetPoint("BOTTOMLEFT", 0, 0)
	tab.sendButton:SetHeight(25)
	tab.sendButton:SetNormalFontObject("GameFontNormalLarge")
	tab.sendButton:SetHighlightFontObject("GameFontHighlightLarge")
	tab.sendButton:SetWidth(150)
	tab.sendButton:SetScript("OnClick", function()
		tab:Send()
	end)

	tab.enchantMaterialsCheckbox = CreateFrame("CheckButton", "AmrEnchantMaterialsCheckbox", tab.shoppingPanel, "ChatConfigCheckButtonTemplate");
	tab.enchantMaterialsCheckbox:SetChecked(AmrDb.SendSettings.SendEnchantMaterials)
	tab.enchantMaterialsCheckbox:SetScript("OnClick", function () AmrDb.SendSettings.SendEnchantMaterials = tab.enchantMaterialsCheckbox:GetChecked() end)
	tab.enchantMaterialsCheckbox:SetPoint("TOPLEFT", tab.sendButton, "TOPLEFT", 0, 25)
	local text3 = getglobal(tab.enchantMaterialsCheckbox:GetName() .. 'Text')
	text3:SetFontObject("GameFontHighlightLarge")
	text3:SetText(L.AMR_SHOPPINGLISTTAB_ENCHANT_MATERIALS)
	text3:SetWidth(150)
	text3:SetPoint("TOPLEFT", tab.enchantMaterialsCheckbox, "TOPRIGHT", 2, -4)


	tab.enchantsCheckbox = CreateFrame("CheckButton", "AmrEnchantsCheckbox", tab.shoppingPanel, "ChatConfigCheckButtonTemplate");
	tab.enchantsCheckbox:SetChecked(AmrDb.SendSettings.SendEnchants)
	tab.enchantsCheckbox:SetScript("OnClick", function () AmrDb.SendSettings.SendEnchants = tab.enchantsCheckbox:GetChecked() end)
	tab.enchantsCheckbox:SetPoint("TOPLEFT", tab.sendButton, "TOPLEFT", 0, 50)
	local text2 = getglobal(tab.enchantsCheckbox:GetName() .. 'Text')
	text2:SetFontObject("GameFontHighlightLarge")
	text2:SetText(L.AMR_SHOPPINGLISTTAB_ENCHANTS)
	text2:SetWidth(150)
	text2:SetPoint("TOPLEFT", tab.enchantsCheckbox, "TOPRIGHT", 2, -4)



	tab.gemsCheckbox = CreateFrame("CheckButton", "AmrGemsCheckbox", tab.shoppingPanel, "ChatConfigCheckButtonTemplate");
	tab.gemsCheckbox:SetPoint("TOPLEFT", tab.sendButton, "TOPLEFT", 0, 75)
	tab.gemsCheckbox:SetChecked(AmrDb.SendSettings.SendGems)
	tab.gemsCheckbox:SetScript("OnClick", function () AmrDb.SendSettings.SendGems = tab.gemsCheckbox:GetChecked() end)
	local text = getglobal(tab.gemsCheckbox:GetName() .. 'Text')
	text:SetFontObject("GameFontHighlightLarge")
	text:SetText(L.AMR_SHOPPINGLISTTAB_GEMS)
	text:SetWidth(150)
	text:SetPoint("TOPLEFT", tab.gemsCheckbox, "TOPRIGHT", 2, -4)


	tab.sendMessage4 = AskMrRobot.FontString:new(tab.shoppingPanel, nil, "ARTWORK", "GameFontHighlightLarge")
	tab.sendMessage4:SetText(L.AMR_SHOPPINGLISTTAB_INCLUDE)
	tab.sendMessage4:SetPoint("TOPLEFT", tab.gemsCheckbox, "TOPLEFT", 0, 20)


	tab.sendMessage3 = AskMrRobot.FontString:new(tab.shoppingPanel, nil, "ARTWORK", "GameFontHighlightLarge")
	tab.sendMessage3:SetText(L.AMR_SHOPPINGLISTTAB_SEND_LIST_TO)
	tab.sendMessage3:SetPoint("TOPLEFT", tab.sendMessage4, "TOPLEFT", 0, 25)


	tab.sendMessage2 = AskMrRobot.FontString:new(tab.shoppingPanel, nil, "ARTWORK", "GameFontNormal")
	tab.sendMessage2:SetTextColor(.5,.5,.5)
	tab.sendMessage2:SetText(L.AMR_SHOPPINGLISTTAB_WHISPER_CHANNEL)
	tab.sendMessage2:SetPoint("TOPLEFT", tab.sendMessage3, "TOPLEFT", 0, 25)


	tab.sendMessage1 = AskMrRobot.FontString:new(tab.shoppingPanel, nil, "ARTWORK", "GameFontNormalLarge")
	tab.sendMessage1:SetTextColor(0,1,0)
	tab.sendMessage1:SetText(L.AMR_SHOPPINGLISTTAB_SEND_JEWELCRAFT_ENCHANTER)
	tab.sendMessage1:SetPoint("TOPLEFT", tab.sendMessage2, "TOPLEFT", 0, 25)


	tab.scrollFrame = CreateFrame("ScrollFrame", "AmrScrollFrame", tab.shoppingPanel, "UIPanelScrollFrameTemplate")
	tab.scrollFrame:SetPoint("TOPLEFT", 0, 0)
	tab.scrollFrame:SetPoint("RIGHT", -20, 0)
	tab.scrollFrame:SetPoint("BOTTOM", tab.sendMessage1, "TOP", 0, 10)

	tab.scrollParent = AskMrRobot.Frame:new(nil, tab.shoppingPanel)
	tab.scrollParent:SetPoint("TOPLEFT", 0, 0)
	tab.scrollParent:SetWidth(tab:GetWidth() - 20)
	tab.scrollParent:SetHeight(500)
	tab.scrollFrame:SetScrollChild(tab.scrollParent)

	-- magic to get the scrollbar to work with the scrollwheel...
	tab.scrollFrame:SetScript("OnMouseWheel", function(arg1, arg2)
	 	ScrollFrameTemplate_OnMouseWheel(arg1, arg2, arg1.ScrollBar)
	end)

	tab.gemsHeader = AskMrRobot.FontString:new(tab.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
	tab.gemsHeader:SetText(L.AMR_SHOPPINGLISTTAB_GEMS)
	tab.gemsHeader:SetPoint("TOPLEFT", tab.scrollParent, "TOPLEFT", 0, 0)

	tab.gemsQuantityHeader = AskMrRobot.FontString:new(tab.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
	tab.gemsQuantityHeader:SetText(L.AMR_SHOPPINGLISTTAB_TOTAL)
	tab.gemsQuantityHeader:SetPoint("TOPLEFT", tab.scrollParent, "TOPLEFT", 370, 0)

	tab.enchantsHeader = AskMrRobot.FontString:new(tab.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
	tab.enchantsHeader:SetText(L.AMR_SHOPPINGLISTTAB_ENCHANTS)

	tab.enchantsQuantityHeader = AskMrRobot.FontString:new(tab.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
	tab.enchantsQuantityHeader:SetText(L.AMR_SHOPPINGLISTTAB_TOTAL)
	tab.enchantsQuantityHeader:SetPoint("TOPLEFT", tab.enchantsHeader, "TOPLEFT", 370, 0)

	tab.enchantMaterialsHeader = AskMrRobot.FontString:new(tab.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
	tab.enchantMaterialsHeader:SetText(L.AMR_SHOPPINGLISTTAB_ENCHANT_MATERIALS)

	tab.enchantMaterialsQuantityHeader = AskMrRobot.FontString:new(tab.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
	tab.enchantMaterialsQuantityHeader:SetText(L.AMR_SHOPPINGLISTTAB_TOTAL)
	tab.enchantMaterialsQuantityHeader:SetPoint("TOPLEFT", tab.enchantMaterialsHeader, "TOPLEFT", 370, 0)

	tab.stamp = AskMrRobot.RobotStamp:new(nil, tab)
	tab.stamp:Hide()
	tab.stamp.bigText:SetText(L.AMR_SHOPPINGLISTTAB_DONE)
	tab.stamp.smallText:SetText(L.AMR_SHOPPINGLISTTAB_A_ROBOTS_WISHLIST)
	tab.stamp:SetPoint("TOPLEFT", tab.shoppingListHeader, "BOTTOMLEFT", 2, -15)
	tab.stamp:SetPoint("RIGHT", tab, "RIGHT", -30, 0)
	tab.stamp:SetHeight(92)

	tab.gemIcons = {}
	tab.gemLinks = {}
	tab.gemQuantity = {}
	tab.enchantIcons = {}
	tab.enchantLinks = {}
	tab.enchantQuantity = {}
	tab.enchantMaterialIcons = {}
	tab.enchantMaterialLinks = {}
	tab.enchantMaterialQuantity = {}

	-- Create the dropdown, and configure its appearance
	tab.dropDown = CreateFrame("FRAME", "AmrSendType", tab.shoppingPanel, "UIDropDownMenuTemplate")
	tab.dropDown:SetPoint("TOPLEFT", tab.sendMessage3, "TOPRIGHT", 0, 5)
	UIDropDownMenu_SetWidth(tab.dropDown, 140)
	UIDropDownMenu_SetText(tab.dropDown, AmrDb.SendSettings.SendToType)

	local text = getglobal(tab.dropDown:GetName() .. 'Text')
	text:SetFontObject("GameFontHighlightLarge")

	local AddButton = function(list, optionText)
		local info = UIDropDownMenu_CreateInfo()
		info.justifyH = "RIGHT"
		info.text = optionText
		info.checked = AmrDb.SendSettings.SendToType == optionText
		info.arg1 = optionText
		info.func = list.SetValue
		info.owner = list
		info.fontObject = "GameFontHighlightLarge"
		info.minWidth = 140
		return info
	end

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(tab.dropDown, function(self, level, menuList)
	 UIDropDownMenu_AddButton(AddButton(self, L.AMR_SHOPPINGLISTTAB_DROPDOWN_FRIEND))
	 UIDropDownMenu_AddButton(AddButton(self, L.AMR_SHOPPINGLISTTAB_DROPDOWN_PARTY))
	 UIDropDownMenu_AddButton(AddButton(self, L.AMR_SHOPPINGLISTTAB_DROPDOWN_RAID))
	 UIDropDownMenu_AddButton(AddButton(self, L.AMR_SHOPPINGLISTTAB_DROPDOWN_GUILD))
	 UIDropDownMenu_AddButton(AddButton(self, L.AMR_SHOPPINGLISTTAB_DROPDOWN_CHANNEL))
	 UIDropDownMenu_AddButton(AddButton(self, L.AMR_SHOPPINGLISTTAB_DROPDOWN_MAIL))
	end)

	function tab.dropDown:SetValue(newValue)
		AmrDb.SendSettings.SendToType = newValue
		-- Update the text; if we merely wanted it to display newValue, we would not need to do this
		UIDropDownMenu_SetText(tab.dropDown, AmrDb.SendSettings.SendToType)
		-- Because this is called from a sub-menu, only that menu level is closed by default.
		-- Close the entire menu with this next call
		CloseDropDownMenus()
	end

	tab.sendTo = CreateFrame("EditBox", "AmrSendTo", tab.shoppingPanel, "InputBoxTemplate" )
	tab.sendTo:SetPoint("TOPLEFT", tab.dropDown, "TOPRIGHT", 0, 0)
	tab.sendTo:SetPoint("RIGHT", 0, 0)
	tab.sendTo:SetHeight(30)
	tab.sendTo:SetText(AmrDb.SendSettings.SendTo or "")
	tab.sendTo:SetFontObject("GameFontHighlightLarge")
	tab.sendTo:SetAutoFocus(false)
	tab.sendTo:SetScript("OnChar", function()
		AmrDb.SendSettings.SendTo = tab.sendTo:GetText()
	end)

	tab.messageQueue = {}
	return tab
end

-- display a gem icon in a row
-- gemInfo is {id, enchantId, color, count }
function AskMrRobot.ShoppingListTab:SetGemIcon(row, gemInfo)
	-- get gem icon for the row
	local gemIcon = self.gemIcons[row]

	-- if we don't have one
	if gemIcon == nil then
		-- make one
		gemIcon = AskMrRobot.GemIcon:new(nil, self.scrollParent)
		self.gemIcons[row] = gemIcon
		gemIcon:SetScript("OnMouseDown", function()
			self:SearchForGem(row)
		end)

		-- position it
		local previous = self.gemsHeader
		if row > 1 then
			previous = self.gemIcons[row - 1]
		end
		gemIcon:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -7)

		-- size it
		gemIcon:SetWidth(24)
		gemIcon:SetHeight(24)

		-- give it a nice border
		gemIcon:SetRoundBorder()
	end

	gemIcon:Show()

	-- make a link for the optimized gem
	gemLink = select(2, GetItemInfo(gemInfo.id))

	-- set the link (tooltip + icon)
	gemIcon:SetItemLink(gemLink)
	--gemIcon:SetGemColor(gemInfo.color)
	gemIcon:SetGemColor('Prismatic')

	-- if we didn't get one, its because WoW is slow
	if not gemLink and gemInfo.id then
		-- when WoW finally returns the link, set the icon / tooltip
		AskMrRobot.RegisterItemInfoCallback(gemInfo.id, function(name, link)
			gemIcon:SetItemLink(link)
		end)
	end

end


-- display a gem icon in a row
-- gemInfo is {id, enchantId, color, count }
function AskMrRobot.ShoppingListTab:SetGemText(row, gemInfo)
	-- get gem icon for the row
	local gemText = self.gemLinks[row]

	-- if we don't have one
	if gemText == nil then
		-- make one
		gemText = AskMrRobot.ItemLinkText:new(nil, self.scrollParent)
		self.gemLinks[row] = gemText
		gemText:SetScript("OnMouseDown", function()
			self:SearchForGem(row)
		end)	

		-- position it
		local previous = self.gemsHeader
		if row > 1 then
			previous = self.gemIcons[row - 1]
		end
		gemText:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 30, -8)
		gemText:SetPoint("RIGHT", self, "RIGHT", -70, 0)
		gemText:SetHeight(18)
		gemText:SetFontSize(15)
	end

	gemText:Show()

	gemText:SetItemId(gemInfo.id)
end

-- display a gem icon in a row
-- gemInfo is {id, enchantId, color, count }
function AskMrRobot.ShoppingListTab:SetGemQuantity(row, qty, total)
	if qty > total then qty = total end

	-- get gem icon for the row
	local gemText = self.gemQuantity[row]

	-- if we don't have one
	if gemText == nil then
		-- make one
		gemText = AskMrRobot.FontString:new(self.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
		self.gemQuantity[row] = gemText

		-- position it
		local previous = self.gemsHeader
		if row > 1 then
			previous = self.gemIcons[row - 1]
		end
		gemText:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 370, -8)
		gemText:SetHeight(18)
		gemText:SetFontSize(15)
	end

	gemText:SetText('' .. qty .. '/' .. total)
	if qty == total then
		gemText:SetTextColor(0,1,0)
	else
		gemText:SetTextColor(1,0,0)
	end
	gemText:Show()
end


-- display an enchant icon in a row
function AskMrRobot.ShoppingListTab:SetEnchantIcon(row, enchantId)

	-- get enchant icon for the row
	local enchantIcon = self.enchantIcons[row]

	-- if we don't have one
	if enchantIcon == nil then
		-- make one
		enchantIcon = AskMrRobot.EnchantLinkIconAndText:new(nil, self.scrollParent)
		self.enchantIcons[row] = enchantIcon
		enchantIcon:SetScript("OnMouseDown", function()
			self:SearchForEnchant(row)
		end)			

		-- position it
		if row == 1 then
			enchantIcon:SetPoint("TOPLEFT", self.enchantsHeader, "BOTTOMLEFT", 0, -12)
			enchantIcon:SetPoint("RIGHT", self.scrollParent, "RIGHT", -30, 0)
		else
			enchantIcon:SetPoint("TOPLEFT", self.enchantIcons[row - 1], "BOTTOMLEFT", 0, -7)
			enchantIcon:SetPoint("RIGHT", self.scrollParent, "RIGHT", -30, 0)
		end
		
		-- size it
		enchantIcon:SetWidth(24)
		enchantIcon:SetHeight(24)
		enchantIcon:SetFontSize(15)

		-- give it a nice border
		enchantIcon:SetRoundBorder()

		enchantIcon:UseSpellName()
	end

	enchantIcon:SetEnchantId(enchantId)

	enchantIcon:Show()
end

-- display a gem icon in a row
-- gemInfo is {id, enchantId, color, count }
function AskMrRobot.ShoppingListTab:SetEnchantQuantity(row, qty, total)
	if qty > total then qty = total end

	-- get gem icon for the row
	local enchantText = self.enchantQuantity[row]

	-- if we don't have one
	if enchantText == nil then
		-- make one
		enchantText = AskMrRobot.FontString:new(self.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
		self.enchantQuantity[row] = enchantText

		-- position it
		local previous = self.enchantsHeader
		if row > 1 then
			previous = self.enchantIcons[row - 1]
		end
		enchantText:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 370, -8)
		enchantText:SetHeight(18)
		enchantText:SetFontSize(15)
	end

	enchantText:SetText('' .. qty .. '/' .. total)
	if qty == total then
		enchantText:SetTextColor(0,1,0)
	else
		enchantText:SetTextColor(1,0,0)
	end
	enchantText:Show()
end

function AskMrRobot.ShoppingListTab:SearchForItem(itemName)
	if self.isAuctionHouseVisible then
		QueryAuctionItems(itemName, nil, nil, 0, 0, 0, 0, 0, 0, 0)
	end
end

function AskMrRobot.ShoppingListTab:SearchForGem(row)
	self:SearchForItem(self.gemLinks[row].itemName)
end

function AskMrRobot.ShoppingListTab:SearchForEnchant(row)
	self:SearchForItem(self.enchantIcons[row].itemName)
end

function AskMrRobot.ShoppingListTab:SearchForEnchantMaterial(row)
	self:SearchForItem(self.enchantMaterialLinks[row].itemName)
end


-- display an enchant material icon in a row
function AskMrRobot.ShoppingListTab:SetEnchantMaterialIcon(row, itemId)
	-- get enchant material icon for the row
	local materialIcon = self.enchantMaterialIcons[row]

	-- if we don't have one
	if materialIcon == nil then
		-- make one
		materialIcon = AskMrRobot.ItemIcon:new(nil, self.scrollParent)
		self.enchantMaterialIcons[row] = materialIcon
		materialIcon:SetScript("OnMouseDown", function()
			self:SearchForEnchantMaterial(row)
		end)

		-- position it
		local previous = self.enchantMaterialsHeader
		if row > 1 then
			previous = self.enchantMaterialIcons[row - 1]
		end
		materialIcon:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -7)

		-- size it
		materialIcon:SetWidth(24)
		materialIcon:SetHeight(24)

		-- give it a nice border
		materialIcon:SetRoundBorder()
	end

	materialIcon:Show()

	-- make a link for the optimized gem
	local itemLink = select(2, GetItemInfo(itemId))

	materialIcon:SetItemLink(itemLink)

	-- if we didn't get one, its because WoW is slow
	if not itemLink and itemId then
		-- when WoW finally returns the link, set the icon / tooltip
		AskMrRobot.RegisterItemInfoCallback(itemId, function(name, link)
			materialIcon:SetItemLink(link)
		end)
	end
end


-- display an enchant material link in a row
function AskMrRobot.ShoppingListTab:SetEnchantMaterialLink(row, itemId)
	-- get gem icon for the row
	local materialLink = self.enchantMaterialLinks[row]

	-- if we don't have one
	if materialLink == nil then
		-- make one
		materialLink = AskMrRobot.ItemLinkText:new(nil, self.scrollParent)
		self.enchantMaterialLinks[row] = materialLink
		materialLink:SetScript("OnMouseDown", function()
			self:SearchForEnchantMaterial(row)
		end)

		-- position it
		local previous = self.enchantMaterialsHeader
		if row > 1 then
			previous = self.enchantMaterialIcons[row - 1]
		end
		materialLink:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 30, -8)
		materialLink:SetPoint("RIGHT", self, "RIGHT", -30, 0)
		materialLink:SetHeight(18)
		materialLink:SetFontSize(15)
	end

	materialLink:Show()

	materialLink:SetItemId(itemId)
	materialLink.itemId = itemId
end

-- display a gem icon in a row
-- gemInfo is {id, enchantId, color, count }
function AskMrRobot.ShoppingListTab:SetEnchantMaterialQuantity(row, qty, total)
	if qty > total then qty = total end

	-- get gem icon for the row
	local enchantText = self.enchantMaterialQuantity[row]

	-- if we don't have one
	if enchantText == nil then
		-- make one
		enchantText = AskMrRobot.FontString:new(self.scrollParent, nil, "ARTWORK", "GameFontNormalLarge")
		self.enchantMaterialQuantity[row] = enchantText

		-- position it
		local previous = self.enchantMaterialsHeader
		if row > 1 then
			previous = self.enchantMaterialIcons[row - 1]
		end
		enchantText:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 370, -8)
		enchantText:SetHeight(18)
		enchantText:SetFontSize(15)
	end

	enchantText:SetText('' .. qty .. '/' .. total)
	if qty == total then
		enchantText:SetTextColor(0,1,0)
	else
		enchantText:SetTextColor(1,0,0)
	end
	enchantText:Show()
end

function AskMrRobot.ShoppingListTab:HasStuffToBuy()

	local gemList, enchantList, enchantMaterials = self:CalculateItems()

	local count = 0
	for gemId, gemInfo in AskMrRobot.spairs(gemList) do
		count = count + gemInfo.total - gemInfo.count
	end
	for slot, enchant in AskMrRobot.spairs(enchantList) do
		count = count + enchant.total - enchant.count
	end

	return count > 0
end

function AskMrRobot.ShoppingListTab:CalculateItems()
	-- build a map of missing gem-enchant-ids -> {id, enchantid, count, total}
	local gemList = {}

	-- for each piece of gear that needs at least 1 gem changed
	for _, badGems in pairs(AskMrRobot.ComparisonResult.gems) do
		-- for each specified gem
		for g = 1, #badGems.optimized do
			local goodGemEnchantId = badGems.optimized[g]
			-- if AMR says to optimized this gem AND it does *NOT* match matches the current gem		
			if goodGemEnchantId ~= 0 and not AskMrRobot.AreGemsCompatible(goodGemEnchantId, badGems.current[g]) then
				-- see if this gem is in our list of gems to optimize
				local gem = gemList[goodGemEnchantId]
				if gem == nil then
					-- if not, add it
					gemList[goodGemEnchantId] = {id = AskMrRobot.ExtraGemData[goodGemEnchantId].id, enchantId = goodGemEnchantId, count = 0, total = 1, compatibleGemIds = AskMrRobot.ExtraGemData[goodGemEnchantId].identicalItemGroup}
				else
					-- if so, increase the total requested for this 
					gem.total = gem.total + 1
				end
			end
		end
	end

	local enchantList = {}
	for slot, enchantData in AskMrRobot.sortSlots(AskMrRobot.ComparisonResult.enchants) do
		local extraData = AskMrRobot.ExtraEnchantData[enchantData.optimized]
		local id = extraData and extraData.itemId or enchantData.optimized
		local qty = enchantList[id]
		if qty then
			qty.total = qty.total + 1
		else
			qty = { count = 0, total = 1, optimized = enchantData.optimized }
			enchantList[id] = qty
		end
	end

	local enchantMaterials = {}
	for slot, enchantData in pairs(AskMrRobot.ComparisonResult.enchants) do
		local extraData = AskMrRobot.ExtraEnchantData[enchantData.optimized]
		if extraData and extraData.materials then
			local itemId
			local count
			for itemId, count in pairs(extraData.materials) do
				if enchantMaterials[itemId] then
					enchantMaterials[itemId].total = enchantMaterials[itemId].total + count
				else
					enchantMaterials[itemId] = { count = 0, total = count }
				end
			end
		end

	end
	
	local bagItemsWithCounts = {}
	-- copy the bank items into a new table so we don't alter them
	if (AmrDb.BankItemsAndCounts) then
		for id, count in pairs(AmrDb.BankItemsAndCounts) do
			bagItemsWithCounts[id] = count
		end
	end

	-- add the items from the players bags
	AskMrRobot.ScanBags(bagItemsWithCounts)

	--substract any inventory we already have in bags/bank
	for itemId, count in pairs(bagItemsWithCounts) do
		for _, gem in pairs(gemList) do
			if gem.compatibleGemIds[itemId] and gem.count < gem.total then
				local needed = gem.total - gem.count
				if count > needed then
					gem.count = gem.total
					-- only consume the number needed (subtract in case this is compatible with a different gem)
					count = count - needed
				else
					gem.count = gem.count + count
					count = 0
				end
			end
		end
		local material = enchantMaterials[itemId]
		if material then
			material.count = material.count + count
		end
		local enchant = enchantList[itemId]
		if enchant then
			enchant.count = enchant.count + count
		end
	end

	return gemList, enchantList, enchantMaterials
end

function AskMrRobot.ShoppingListTab:Update()
	
	local gemList, enchantList, enchantMaterials = self:CalculateItems()

	-- update the UI
	local lastControl = nil
	local row = 1
	for gemId, gemInfo in AskMrRobot.spairs(gemList) do
		self:SetGemIcon(row, gemInfo)
		self:SetGemText(row, gemInfo)
		self:SetGemQuantity(row, gemInfo.count, gemInfo.total)
		lastControl = self.gemIcons[row]
		row = row + 1
	end

	-- hide any extra gem icons
	for i = row, #self.gemIcons do
		self.gemIcons[i]:Hide()
		self.gemLinks[i]:Hide()
		self.gemQuantity[i]:Hide()
	end

	-- hide / show the gems header, and position the enchant headers
	if row > 1 then
		self.gemsHeader:Show()
		self.gemsQuantityHeader:Show()
		self.enchantsHeader:SetPoint("TOPLEFT", self.gemIcons[row - 1], "BOTTOMLEFT", 0, -15)
	else
		self.gemsHeader:Hide()
		self.gemsQuantityHeader:Hide()
		self.enchantsHeader:SetPoint("TOPLEFT", self.scrollParent, "TOPLEFT", 0, 0)
	end

	row = 1
	for slot, enchant in AskMrRobot.spairs(enchantList) do
		self:SetEnchantIcon(row, enchant.optimized)
		self:SetEnchantQuantity(row, enchant.count, enchant.total)
		lastControl = self.enchantIcons[row]
		row = row + 1
	end

	-- hide any extra enchant icons
	for i = row, #self.enchantIcons do
		self.enchantIcons[i]:Hide()
		self.enchantQuantity[i]:Hide()
	end

	-- hide / show the enchants header, and position the enchant materials headers
	if row > 1 then
		self.enchantsHeader:Show()
		self.enchantsQuantityHeader:Show()
		self.enchantMaterialsHeader:SetPoint("TOPLEFT", self.enchantIcons[row - 1], "BOTTOMLEFT", 0, -15)
	else
		self.enchantsHeader:Hide()
		self.enchantsQuantityHeader:Hide()
		self.enchantMaterialsHeader:SetPoint("TOPLEFT", self.scrollParent, "TOPLEFT", 0, 0)
	end

	row = 1
	for itemId, count in AskMrRobot.spairs(enchantMaterials) do
		self:SetEnchantMaterialIcon(row, itemId)
		self:SetEnchantMaterialLink(row, itemId)
		self:SetEnchantMaterialQuantity(row, count.count, count.total)
		lastControl = self.enchantMaterialIcons[row]
		row = row + 1
	end

	for i = row, #self.enchantMaterialIcons do
		self.enchantMaterialIcons[i]:Hide()
		self.enchantMaterialLinks[i]:Hide()
		self.enchantMaterialQuantity[i]:Hide()
	end

	if row == 1 then
		self.enchantMaterialsHeader:Hide()
		self.enchantMaterialsQuantityHeader:Hide()
	else
		self.enchantMaterialsHeader:Show()
		self.enchantMaterialsQuantityHeader:Show()
	end

	-- fix up the scrollbar length
	if lastControl then
		local height = self.scrollParent:GetTop() - lastControl:GetBottom()
		self.scrollParent:SetHeight(height)
		if height < self.scrollFrame:GetHeight() then
			self.scrollFrame.ScrollBar:Hide()
		else
			self.scrollFrame:Show()
			self.scrollFrame.ScrollBar:Show()
		end
		self.stamp:Hide()
		self.shoppingPanel:Show()
	else
		self.scrollFrame.ScrollBar:Hide()
		self.shoppingPanel:Hide()
		self.stamp:Show()
	end
end


function AskMrRobot.ShoppingListTab:OnEvent(frame, event, ...)
	local handler = self["On_" .. event]
	if handler then
		handler(self, ...)
	end
end

function AskMrRobot.ShoppingListTab:On_MAIL_SHOW()
	self.mailOpen = true
end

function AskMrRobot.ShoppingListTab:On_MAIL_CLOSED()
	self.mailOpen = nil
end

function AskMrRobot.ShoppingListTab:On_AUCTION_HOUSE_SHOW()
	self.isAuctionHouseVisible = true
end

function AskMrRobot.ShoppingListTab:On_AUCTION_HOUSE_CLOSED()
	self.isAuctionHouseVisible = false
end

function AskMrRobot.ShoppingListTab:sendMail()

	-- need mail window to be open for this to work
	if not self.mailOpen then
		StaticPopup_Show("SHOPPING_TAB_PLEASE_OPEN")
		return
	end

	local message = L.AMR_SHOPPINGLISTTAB_MAIL_ROBOT_MESSAGE

	local gemList, enchantList, enchantMaterials = self:CalculateItems()

	if AmrDb.SendSettings.SendGems then
		for k,v in pairs(gemList) do
			--exclude jewelcrafter gems
			--if not AskMrRobot.JewelcrafterGems[k] then
				local needed = v.total - v.count
				if needed > 0 then
					local itemName = GetItemInfo(v.id)
					if itemName then
						message = message .. "\n" .. needed .. "x " .. itemName
					end
				end
			--end
		end
	end

	if AmrDb.SendSettings.SendEnchants then
		for k,v in pairs(enchantList) do
			local needed = v.total - v.count
			if needed > 0 then
				local itemName = GetItemInfo(k)
				if itemName then
					message = message .. "\n" .. needed .. "x " .. itemName
				end
			end
		end
	end

	if AmrDb.SendSettings.SendEnchantMaterials then
		for k,v in pairs(enchantMaterials) do
			local needed = v.total - v.count
			if needed > 0 then
				local itemName = GetItemInfo(k)
				if itemName then
					message = message .. "\n" .. needed .. "x " .. itemName
				end
			end
		end
	end

	MailFrameTab_OnClick(nil, 2)
	if AmrDb.SendSettings.SendGems then
		if AmrDb.SendSettings.SendEnchants then
			SendMailSubjectEditBox:SetText(L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_GE)
		else
			SendMailSubjectEditBox:SetText(L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_G)
		end
	else
		SendMailSubjectEditBox:SetText(L.AMR_SHOPPINGLISTTAB_MAIL_SUBJECT_E)
	end
	SendMailNameEditBox:SetText(AmrDb.SendSettings.SendTo)
	SendMailBodyEditBox:SetText(message)
end

function AskMrRobot.ShoppingListTab:Send()	
	local chatType = nil
	if AmrDb.SendSettings.SendToType == L.AMR_SHOPPINGLISTTAB_DROPDOWN_PARTY then
		chatType = "PARTY"
	elseif AmrDb.SendSettings.SendToType == L.AMR_SHOPPINGLISTTAB_DROPDOWN_GUILD then
		chatType = "GUILD"
	elseif AmrDb.SendSettings.SendToType == L.AMR_SHOPPINGLISTTAB_DROPDOWN_RAID then
		chatType = "RAID"
	elseif AmrDb.SendSettings.SendToType == L.AMR_SHOPPINGLISTTAB_DROPDOWN_CHANNEL then
		chatType = "CHANNEL"
	elseif AmrDb.SendSettings.SendToType == L.AMR_SHOPPINGLISTTAB_DROPDOWN_MAIL then
		self:sendMail()
		return
	else
		chatType = "WHISPER"
	end

	local message = L.AMR_SHOPPINGLISTTAB_CHAT_ROBOT_MESSAGE
	local count = 0


	local gemList, enchantList, enchantMaterials = self:CalculateItems()

	local items = {}
	if AmrDb.SendSettings.SendGems then
		for k,v in pairs(gemList) do
			--if not AskMrRobot.JewelcrafterGems[k] then
				local needed = v.total - v.count
				if needed > 0 then
					tinsert(items, {id = v.id, needed = needed})
				end
			--end
		end
	end

	if AmrDb.SendSettings.SendEnchants then
		for k,v in pairs(enchantList) do
			local needed = v.total - v.count
			if needed > 0 then
				tinsert(items, {id = k, needed = needed})
			end
		end
	end

	if AmrDb.SendSettings.SendEnchantMaterials then
		for k,v in pairs(enchantMaterials) do
			local needed = v.total - v.count
			if needed > 0 then
				tinsert(items, {id = k, needed = needed})
			end
		end
	end

	for i, entry in ipairs(items) do
		local _, link = GetItemInfo(entry.id)
		if link then
			message = message .. " " .. entry.needed .. "x " .. link
			count = count + 1
			if count == 2 then
				tinsert(self.messageQueue, {message = message, chatType = chatType, chatChannel = AmrDb.SendSettings.SendTo})
				count = 0
				message = L.AMR_SHOPPINGLISTTAB_CHAT_ROBOT_MESSAGE
			end
		end
	end

	if count > 0 then
		tinsert(self.messageQueue, {message = message, chatType = chatType, chatChannel = AmrDb.SendSettings.SendTo})
	end

	self:SendNextMessage()
end

function AskMrRobot.ShoppingListTab:SendNextMessage()
	while #self.messageQueue > 0 do
		local entry = self.messageQueue[1]
		table.remove(self.messageQueue, 1)
		SendChatMessage(entry.message, entry.chatType, nil, entry.chatChannel)
	end
end