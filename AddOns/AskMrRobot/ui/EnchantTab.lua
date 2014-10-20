local _, AskMrRobot = ...
local L = AskMrRobot.L;
-- initialize the EnchantTab class
AskMrRobot.EnchantTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

function AskMrRobot.EnchantTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)
	setmetatable(tab, { __index = AskMrRobot.EnchantTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()


	local text = tab:CreateFontString("AmrEnchantsText1", "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetText(L.AMR_ENCHANTTAB_ENCHANTS)

	tab.stamp = AskMrRobot.RobotStamp:new(nil, tab)
	tab.stamp:Hide()
	tab.stamp.smallText:SetText(L.AMR_ENCHANTTAB_100_OPTIMAL)
	tab.stamp:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 2, -15)
	tab.stamp:SetPoint("RIGHT", tab, "RIGHT", -20, 0)

	tab.slotHeader = tab:CreateFontString("AmrBadEnchantSlotHeader", "ARTWORK", "GameFontNormal")
	tab.slotHeader:SetPoint("TOPLEFT", "AmrEnchantsText1", "BOTTOMLEFT", 0, -20)
	tab.slotHeader:SetText(L.AMR_ENCHANTTAB_SLOT)
	tab.slotHeader:SetWidth(90)
	tab.slotHeader:SetJustifyH("LEFT")

	tab.currentHeader = tab:CreateFontString("AmrBadEnchantCurrentHeader", "ARTWORK", "GameFontNormal")
	tab.currentHeader:SetText(L.AMR_ENCHANTTAB_CURRENT)
	tab.currentHeader:SetPoint("TOPLEFT", "AmrBadEnchantSlotHeader", "TOPLEFT", 100, 0)
	tab.currentHeader:SetWidth(120)
	tab.currentHeader:SetJustifyH("LEFT")

	tab.optimizedHeader = tab:CreateFontString("AmrBadEnchantOptimizedHeader", "ARTWORK", "GameFontNormal")
	tab.optimizedHeader:SetPoint("TOPLEFT", "AmrBadEnchantCurrentHeader", "TOPLEFT", 140, 0)
	tab.optimizedHeader:SetPoint("RIGHT", -30, 0)
	tab.optimizedHeader:SetText(L.AMR_ENCHANTTAB_OPTIMIZED)
	tab.optimizedHeader:SetJustifyH("LEFT")

	tab.badEnchantSlots = {}
	tab.badEnchantCurrent = {}
	tab.badEnchantOptimized = {}

	for i = 1, #AskMrRobot.slotIds do
		local itemText = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		itemText:SetPoint("TOPLEFT", "AmrBadEnchantSlotHeader", "TOPLEFT", 0, -26 * i)
		itemText:SetPoint("BOTTOMRIGHT", "AmrBadEnchantSlotHeader", "BOTTOMRIGHT", 0, -26 * i)
		itemText:SetJustifyH("LEFT")
		itemText:SetText(L.AMR_ENCHANTTAB_TESTSLOT)
		tinsert(tab.badEnchantSlots, itemText)

		itemText = AskMrRobot.EnchantLinkText:new(nil, tab)
		itemText:SetPoint("TOPLEFT", "AmrBadEnchantCurrentHeader", "TOPLEFT", 0, -26 * i)
		itemText:SetPoint("BOTTOMRIGHT", "AmrBadEnchantCurrentHeader", "BOTTOMRIGHT", 0,  -26 * i)
		tinsert(tab.badEnchantCurrent, itemText)

		itemText = AskMrRobot.EnchantLinkIconAndText:new(nil, tab)
		itemText:SetPoint("TOPLEFT", "AmrBadEnchantOptimizedHeader", "TOPLEFT", 0,  -26 * i)
		itemText:SetPoint("BOTTOMRIGHT", "AmrBadEnchantOptimizedHeader", "BOTTOMRIGHT", 0,  -26 * i)
		tinsert(tab.badEnchantOptimized, itemText)
	end

	return tab
end

function AskMrRobot.EnchantTab:Update()

	local i = 1

	-- for all the bad items
	if AskMrRobot.ComparisonResult.enchants then
		for iSlot = 1, #AskMrRobot.slotIds do
			local slotId = AskMrRobot.slotIds[iSlot]
			local badEnchant = AskMrRobot.ComparisonResult.enchants[slotId]
			if badEnchant ~= nil then
				self.badEnchantSlots[i]:SetText(AskMrRobot.slotDisplayText[slotId])
				self.badEnchantSlots[i]:Show()

				self.badEnchantCurrent[i]:SetEnchantId(badEnchant.current)

				self.badEnchantOptimized[i]:SetEnchantId(badEnchant.optimized)
				i = i + 1
			end
		end

	end

	-- hide / show the headers
	if i == 1 then
		self.optimizedHeader:Hide()
		self.currentHeader:Hide()
		self.slotHeader:Hide()
		self.stamp:Show()
	else
		self.optimizedHeader:Show()
		self.currentHeader:Show()
		self.slotHeader:Show()
		self.stamp:Hide()
	end

	-- hide the remaining slots
	while i <= #self.badEnchantSlots do
		self.badEnchantSlots[i]:Hide()
		self.badEnchantCurrent[i]:SetEnchantId(nil)
		self.badEnchantOptimized[i]:SetEnchantId(nil)
		i = i + 1
	end		
end