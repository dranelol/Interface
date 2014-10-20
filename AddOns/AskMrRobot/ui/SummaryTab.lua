local _, AskMrRobot = ...
local L = AskMrRobot.L;

AskMrRobot.SummaryTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

function AskMrRobot.SummaryTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)
	setmetatable(tab, { __index = AskMrRobot.SummaryTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()

	
	tab.importDate = ""

	local text = tab:CreateFontString("AmrSummaryText1", "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetFormattedText(L.AMR_SUMMARYTAB_TITLE)

	-- error text
	tab.errorText1 = tab:CreateFontString("AmrSummaryErrorText1", "ARTWORK", "GameFontRedLarge")
	tab.errorText1:SetPoint("TOPLEFT", "AmrSummaryText1", "BOTTOMLEFT", 0, -20)
	tab.errorText1:SetText(L.AMR_SUMMARYTAB_NO_IMPORT)
	tab.errorText1:SetPoint("RIGHT", -20, 0)
	tab.errorText1:SetWidth(tab.errorText1:GetWidth())
	tab.errorText1:SetWordWrap(true)
	tab.errorText1:SetJustifyH("LEFT")

	tab.errorText2 = tab:CreateFontString("AmrSummaryErrorText2", "ARTWORK", "GameFontWhite")
	tab.errorText2:SetPoint("TOPLEFT", "AmrSummaryErrorText1", "BOTTOMLEFT", 0, -15)
	tab.errorText2:SetPoint("RIGHT", -20, 0)
	tab.errorText2:SetWidth(tab.errorText2:GetWidth())
	tab.errorText2:SetJustifyH("LEFT")
	tab.errorText2:SetText(L.AMR_SUMMARYTAB_GET_STARTED)

	-- bad items
	tab.badItemSlots = {}
	tab.badItemNames = {}

	local itemText = tab:CreateFontString("AmrBadItemSlot0", "ARTWORK", "GameFontNormal")
	itemText:SetPoint("TOPLEFT", "AmrSummaryErrorText2", "BOTTOMLEFT", 0, -20)
	itemText:SetText("Slot")
	itemText:SetWidth(100)
	itemText:SetJustifyH("LEFT")
	itemText:Hide()
	tinsert(tab.badItemSlots, itemText)

	itemText = tab:CreateFontString("AmrBadItemName0", "ARTWORK", "GameFontNormal")
	itemText:SetPoint("TOPLEFT", "AmrBadItemSlot0", "TOPLEFT", 120, 0)
	itemText:SetPoint("RIGHT", -30, 0)
	itemText:SetText("Item Name")
	itemText:SetJustifyH("LEFT")
	itemText:Hide()
	tinsert(tab.badItemNames, itemText)

	itemText = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	itemText:SetPoint("LEFT", 0, 0)
	itemText:SetPoint("RIGHT", -30, 0)
	itemText:SetPoint("TOP", "AmrBadItemSlot0", "TOP", 0, 0 )
	itemText:SetText(L.AMR_SUMMARYTAB_GO_UPGRADE)
	itemText:SetJustifyH("LEFT")
	itemText:Hide()
	tab.upgradeInstructions = itemText

	itemText = tab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	itemText:SetPoint("LEFT", "AmrBadItemSlot0", "LEFT", 0, -20)
	itemText:SetPoint("RIGHT", "AmrBadItemSlot0", "RIGHT", 0, -20)
	itemText:SetPoint("TOP", tab.upgradeInstructions, "BOTTOM", 0, -10 )
	itemText:SetHeight(20)
	itemText:SetText(L.AMR_SUMMARYTAB_SLOT)
	itemText:SetJustifyH("LEFT")
	itemText:Hide()
	tab.upgradeSlotHeader = itemText

	itemText = tab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	itemText:SetPoint("LEFT", "AmrBadItemName0", "LEFT", 0, 0)
	itemText:SetPoint("RIGHT", "AmrBadItemName0", "RIGHT", 0, 0)
	itemText:SetPoint("TOP", tab.upgradeSlotHeader, "TOP", 0, 0)
	itemText:SetPoint("BOTTOM", tab.upgradeSlotHeader, "BOTTOM", 0, 0)
	itemText:SetText(L.AMR_SUMMARYTAB_ITEM_NAME)
	itemText:SetJustifyH("LEFT")
	itemText:Hide()
	tab.upgradeItemHeader = itemText

	for i = 1, #AskMrRobot.slotIds do
		local itemText = tab:CreateFontString("AmrBadItemSlot" .. i, "ARTWORK", "GameFontWhite")
		itemText:SetPoint("TOPLEFT", "AmrBadItemSlot" .. (i-1), "BOTTOMLEFT", 0, -5)
		itemText:SetPoint("TOPRIGHT", "AmrBadItemSlot" .. (i-1), "BOTTOMRIGHT", 0, -5)
		itemText:SetJustifyH("LEFT")
		itemText:Hide()
		tinsert(tab.badItemSlots, itemText)

		itemText = AskMrRobot.ItemLinkText:new(nil, tab)
		itemText:SetPoint("LEFT", "AmrBadItemName0", "TOPLEFT", 0, 0)
		itemText:SetPoint("RIGHT", "AmrBadItemName0", "BOTTOMRIGHT", 0, 0)
		itemText:SetPoint("TOP", "AmrBadItemSlot" .. i, 0, 0)
		itemText:SetPoint("BOTTOM", "AmrBadItemSlot" .. i, 0, 0)
		itemText:Hide()
		tinsert(tab.badItemNames, itemText)
	end

	tab.upgradeItemSlots = {}
	tab.upgradeItemNames = {}
	for i = 1, #AskMrRobot.slotIds do
		local itemText = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		if i == 1 then
			itemText:SetPoint("TOPLEFT", tab.upgradeSlotHeader, "BOTTOMLEFT", 0, -5)
			itemText:SetPoint("TOPRIGHT", tab.upgradeSlotHeader, "BOTTOMRIGHT", 0, -5)
		else
			itemText:SetPoint("TOPLEFT", tab.upgradeItemSlots[i-1], "BOTTOMLEFT", 0, -5)
			itemText:SetPoint("TOPRIGHT", tab.upgradeItemSlots[i-1], "BOTTOMRIGHT", 0, -5)
		end
		itemText:SetJustifyH("LEFT")
		itemText:Hide()
		tinsert(tab.upgradeItemSlots, itemText)

		itemText = AskMrRobot.ItemLinkText:new(nil, tab)
		itemText:SetFormat("|cff00ff00Upgrade|r %s")
		itemText:SetPoint("LEFT", tab.upgradeItemHeader, "LEFT", 0, 0)
		itemText:SetPoint("RIGHT", tab.upgradeItemHeader, "RIGHT", 0, 0)
		itemText:SetPoint("TOP", tab.upgradeItemSlots[i], 0, 0)
		itemText:SetPoint("BOTTOM", tab.upgradeItemSlots[i], 0, 0)
		itemText:Hide()
		tinsert(tab.upgradeItemNames, itemText)
	end

	tab.importInfo = tab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	tab.importInfo:SetText(L.AMR_SUMMARYTAB_LAST_IMPORT)
	tab.importInfo:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -20)
	tab.importInfo:SetJustifyH("LEFT")
	tab.importInfo:Hide()

	tab.specIcon = tab:CreateTexture(nil, "BACKGROUND")
	tab.specIcon:SetPoint("TOPLEFT")
	tab.specIcon:SetWidth(64)
	tab.specIcon:SetHeight(64)
	tab.specIcon:SetPoint("TOPLEFT", tab.importInfo, "BOTTOMLEFT", 0, -10)
	tab.specIcon:Hide()

	tab.stamp = AskMrRobot.RobotStamp:new(nil, tab)
	tab.stamp:Hide()
	tab.stamp.smallText:SetText(L.AMR_SUMMARYTAB_OPTIMAL)
	tab.stamp:SetPoint("TOPLEFT", tab.specIcon, "BOTTOMLEFT", 2, -25)
	tab.stamp:SetPoint("RIGHT", tab, "RIGHT", -20, 0)
	tab.stamp:Hide()

	tab.specText = tab:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	local Path, Size, Flags = tab.specText:GetFont()
	tab.specText:SetFont(Path, 24, Flags);
	tab.specText:SetPoint("LEFT", tab.specIcon, "RIGHT", 10, 0)
	tab.specText:SetText("?")
	tab.specText:Hide()

	tab.optimizationSummary = tab:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	tab.optimizationSummary:SetPoint("TOPLEFT", tab.specIcon, "BOTTOMLEFT", 0, -15)
	tab.optimizationSummary:SetText(L.AMR_SUMMARYTAB_OPTIMIZATIONS_TO_GO)
	tab.optimizationSummary:Hide()

	tab.gemCount = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	tab.gemCount:SetPoint("TOPLEFT", tab.optimizationSummary, "BOTTOMLEFT", 0, -15)
	tab.gemCount:SetText(L.AMR_SUMMARYTAB_GEMS_TO_GO)
	tab.gemCount:Hide()

	tab.enchantCount = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	tab.enchantCount:SetPoint("TOPLEFT", tab.gemCount, "BOTTOMLEFT", 0, -5)
	tab.enchantCount:SetText(L.AMR_SUMMARYTAB_ENCHANTS_TO_GO)
	tab.enchantCount:Hide()

	tab.instructions = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	tab.instructions:SetPoint("TOPLEFT", tab.enchantCount, "BOTTOMLEFT", 0, -15)
	tab.instructions:SetText(L.AMR_SUMMARYTAB_VIEW_TABS)
	tab.instructions:Hide()

	return tab
end

function AskMrRobot.SummaryTab:getSpecIcon(specId)
	for i = 1, GetNumSpecializations() do
		local id, _, _, icon = GetSpecializationInfo(i)
		if id == specId then
			return icon
		end
	end
	return nil
end

function AskMrRobot.SummaryTab:showBadItems()
	local i = 2

	-- for all slots
	for iSlot = 1, #AskMrRobot.slotIds do
		local slotId = AskMrRobot.slotIds[iSlot]
		local badItem = AskMrRobot.ComparisonResult.items[slotId]
		if badItem ~= nil and not badItem.needsUpgrade then
			self.badItemSlots[i]:SetText(AskMrRobot.slotDisplayText[slotId])
			self.badItemSlots[i]:Show()
			if badItem.optimized then
				self.badItemNames[i]:SetItemId(badItem.optimized.id, badItem.optimized.upgradeId, badItem.optimized.suffixId)
			else
				self.badItemNames[i]:SetItemId(nil, 0, 0)
			end
			self.badItemNames[i]:Show()
			i = i + 1
		end
	end

    -- for all the upgrade items
    local j = 1
	for iSlot = 1, #AskMrRobot.slotIds do
		local slotId = AskMrRobot.slotIds[iSlot]
		local badItem = AskMrRobot.ComparisonResult.items[slotId]
		if badItem ~= nil and badItem.needsUpgrade then
			self.upgradeItemSlots[j]:SetText(AskMrRobot.slotDisplayText[slotId])
			self.upgradeItemSlots[j]:Show()
			if badItem.optimized then
				self.upgradeItemNames[j]:SetItemId(badItem.optimized.id, badItem.optimized.upgradeId, badItem.optimized.suffixId)
			else
				self.upgradeItemNames[j]:SetItemId(nil, 0, 0)
			end
			self.upgradeItemNames[j]:Show()
			j = j + 1
		end
	end

	-- hide / show the headers
	if i == 2 and j == 1 then
		self.badItemSlots[1]:Hide()
		self.badItemNames[1]:Hide()
		self:showImportError(nil)
		self.importInfo:Show()
		self.specIcon:Show()
		self.optimizationSummary:Show()
		self.gemCount:Show()
		self.enchantCount:Show()
		self.instructions:Show()
		self.specText:Show()

		local gemCount = 0
		for slotNum, badGems in pairs(AskMrRobot.ComparisonResult.gems) do
			--for k, v in pairs(badGems.badGems) do
				--gemCount = gemCount + 1
			--end
			for g = 1, 3 do
				if not AskMrRobot.AreGemsCompatible(badGems.current[g], badGems.optimized[g]) then
					gemCount = gemCount + 1
				end
			end
		end

		self.gemCount:SetFormattedText(L.AMR_SUMMARYTAB_GEMCOUNT, gemCount)

		local enchantCount = 0
		for slotNum, badEnchant in pairs(AskMrRobot.ComparisonResult.enchants) do
			enchantCount = enchantCount + 1
		end

		self.enchantCount:SetFormattedText(L.AMR_SUMMARYTAB_ENCHANTCOUNT, enchantCount)

		self.optimizationSummary:SetFormattedText(L.AMR_SUMMARYTAB_OPTIMIZATIONCOUNT, gemCount + enchantCount)

		if gemCount + enchantCount == 0 then
			self.stamp:Show()
			self.optimizationSummary:Hide()
			self.enchantCount:Hide()
			self.instructions:Hide()
			self.gemCount:Hide()
		else
			self.stamp:Hide()
			self.optimizationSummary:Show()
			self.enchantCount:Show()
			self.instructions:Show()
			self.gemCount:Show()
		end

		local activeSpecGroup = GetActiveSpecGroup()

		if activeSpecGroup == nil then
			self.importInfo:SetFormattedText(L.AMR_SUMMARYTAB_LAST_IMPORT_1, AmrDb.LastCharacterImportDate, UnitName("player"))
		else
			self.importInfo:SetFormattedText(L.AMR_SUMMARYTAB_LAST_IMPORT_2, AmrDb.LastCharacterImportDate, UnitName("player"))
			local spec = GetSpecialization(false, false, group);
			if spec then
				local _, name, _, icon = GetSpecializationInfo(spec);
				if activeSpecGroup == 1 then
					self.specText:SetFormattedText(L.AMR_SUMMARYTAB_LAST_IMPORT_PSPEC, name)
				else
					self.specText:SetFormattedText(L.AMR_SUMMARYTAB_LAST_IMPORT_SSPEC, name)
				end
				self.specIcon:SetTexture(icon)
			end
		end


		--local currentSpec = GetAmrSpecialization(GetActiveSpecGroup())
		--return (not currentSpec and not spec) or tostring(currentSpec) == spec
	else
		self.importInfo:Hide()
		self.specIcon:Hide()
		self.optimizationSummary:Hide()
		self.gemCount:Hide()
		self.enchantCount:Hide()
		self.instructions:Hide()
		self.specText:Hide()		
	end

	if i == 2 then
		self.badItemSlots[1]:Hide()
		self.badItemNames[1]:Hide()
	else
		self.badItemSlots[1]:Show()
		self.badItemNames[1]:Show()
		local warnings = {}
		if self.badRealm then
			tinsert(warnings, L.AMR_SUMMARYTAB_DIFF_REALM:format(self.badRealm))
		end
		if self.badTalents then
			tinsert(warnings, L.AMR_SUMMARYTAB_DIFF_TALENT)
		end
		if self.badGlyphs then
			tinsert(warnings, L.AMR_SUMMARYTAB_DIFF_GLYPHS)
		end
		local message = L.AMR_SUMMARYTAB_DIFF_GEAR
		if #warnings > 0 then
			message = message .. " (".. L.AMR_SUMMARYTAB_DIFF_AND.." "
			for k = 1, #warnings do
				if k > 1 then
					message = message .. ', '
				end
				message = message .. warnings[k]
			end
			message = message .. ")"
		end
		message = message .. L.AMR_SUMMARYTAB_DIFF_PLEASE_EQ
		self:showImportWarning(L.AMR_SUMMARYTAB_DIFF_CHECK_CHAR, message)
	end

	if j == 1 then
		self.upgradeItemHeader:Hide()
		self.upgradeSlotHeader:Hide()
		self.upgradeInstructions:Hide()
	else
		if i == 2 then
			local warnings = {}
			if self.badRealm then
				tinsert(warnings, L.AMR_SUMMARYTAB_DIFF_REALM:format(self.badRealm))
			end
			if self.badTalents then
				tinsert(warnings, L.AMR_SUMMARYTAB_DIFF_TALENT)
			end
			if self.badGlyphs then
				tinsert(warnings, L.AMR_SUMMARYTAB_DIFF_GLYPHS)
			end
			local message = nil
			if #warnings > 0 then 
				message = L.AMR_SUMMARYTAB_DIFF_OPTIMIZED_FOR
				for k = 1, #warnings do
					if k > 1 then
						message = message .. ', '
					end
					message = message .. warnings[k]
				end
				message = message .. "."
			end
			self:showImportWarning(L.AMR_SUMMARYTAB_DIFF_CHECK_CHAR, message)
		end
		self.upgradeItemHeader:Show()
		self.upgradeSlotHeader:Show()
		self.upgradeInstructions:Show()
		if i == 2 then
			self.upgradeInstructions:SetPoint("TOP", self.badItemSlots[1], "TOP", 0, 0)
			self.errorText2:Hide()
		else
			self.upgradeInstructions:SetPoint("TOP", self.badItemSlots[i], "BOTTOM", 0, -20)
		end		
	end

	-- hide the remaining slots
	while i <= #self.badItemSlots do
		self.badItemSlots[i]:Hide()
		self.badItemNames[i]:Hide()
		i = i + 1
	end

	-- hide the remaining slots
	while j <= #self.upgradeItemSlots do
		self.upgradeItemSlots[j]:Hide()
		self.upgradeItemNames[j]:Hide()
		j = j + 1
	end
end


function AskMrRobot.SummaryTab:showImportError(text, text2)
	self.stamp:Hide()
	self.gemCount:Hide()
	self.instructions:Hide()
	self.enchantCount:Hide()
	self.optimizationSummary:Hide()
	if text then
		self.errorText1:Show()
		self.errorText1:SetText(L.AMR_SUMMARYTAB_IMPORT_NOT_WORK:format(text))
		self.errorText1:Show()
		self.errorText2:SetText(text2)
		self.errorText2:Show()
		self.importInfo:Hide()
		self.upgradeSlotHeader:Hide()
		self.upgradeItemHeader:Hide()
		self.upgradeInstructions:Hide()
		self.specIcon:Hide()
		self.specText:Hide()
	else
		self.errorText1:Hide()
		self.errorText2:Hide()
		self.importInfo:Show()
	end
	for i = 1, #self.badItemSlots do
		self.badItemSlots[i]:Hide()
		self.badItemNames[i]:Hide()
	end
	for i = 1, #self.upgradeItemSlots do
		self.upgradeItemSlots[i]:Hide()
		self.upgradeItemNames[i]:Hide()
	end	
end

function AskMrRobot.SummaryTab:showImportWarning (text, text2)
	self.stamp:Hide()
	self.hasImportError = false
	self.gemCount:Hide()
	self.instructions:Hide()
	self.enchantCount:Hide()
	self.specIcon:Hide()
	self.specText:Hide()
	self.optimizationSummary:Hide()
	if text then
		self.errorText1:SetText(text)
		self.errorText1:Show()
		self.errorText2:SetText(text2)
		self.errorText2:Show()		
	else			
		self.errorText1:Hide()
		self.errorText2:Hide()
	end
end
