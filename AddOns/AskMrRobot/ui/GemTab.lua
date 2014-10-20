local _, AskMrRobot = ...
local L = AskMrRobot.L;

StaticPopupDialogs["AUTOGEM_FINISHED"] = {
	text = L.AMR_GEMTAB_FINISHED,
	button1 = L.AMR_GEMTAB_BUTTON_OK,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

StaticPopupDialogs["AUTOGEM_ONCE"] = {
	text = L.AMR_GEMTAB_AUTOGEMMING_IN_PROGRESS,
	button1 = L.AMR_GEMTAB_BUTTON_OK,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

-- initialize the GemTab class
AskMrRobot.GemTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

local MAX_SLOTS = 4

-- GemTab contructor
function AskMrRobot.GemTab:new(parent)
	-- create a new frame (if one isn't supplied)
	local tab = AskMrRobot.Frame:new(nil, parent)
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	-- use the GemTab class
	setmetatable(tab, { __index = AskMrRobot.GemTab })
	tab:Hide()

	local text = tab:CreateFontString("AmrGemsText1", "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetText(L.AMR_GEMTAB_GEMS)

	tab.stamp = AskMrRobot.RobotStamp:new(nil, tab)
	tab.stamp:Hide()
	tab.stamp.smallText:SetText(L.AMR_GEMTAB_OPTIMAL)
	tab.stamp:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 2, -15)
	tab.stamp:SetPoint("RIGHT", tab, "RIGHT", -20, 0)

	text = tab:CreateFontString("AmrGemsText2", "ARTWORK", "GameFontWhite")
	text:SetText(L.AMR_GEMTAB_X_OPTIMIZE)
	text:SetPoint("TOPLEFT", "AmrGemsText1", "BOTTOMLEFT", 0, -20)
	text:SetWidth(200)
	text:SetJustifyH("LEFT")
	tab.gemsTextToOptimize = text

	-- autogem button
	tab.button = CreateFrame("Button", "AmrAutoGemButton", tab, "UIPanelButtonTemplate")	
	tab.button:SetPoint("TOP", "AmrGemsText1", "BOTTOM", 0, -16)
	tab.button:SetPoint("RIGHT", -40, 0)
	tab.button:SetText(L.AMR_GEMTAB_AUTOGEM_BUTTON)
	tab.button:SetWidth(150)
	tab.button:SetHeight(20)
	tab.button:SetScript("OnClick", function() tab:startAutoGem() end)
	tab.button:Hide()

	-- autogem checkbox button
	tab.usePerfectButton = CreateFrame("CheckButton", "AmrUsePerfectButton", tab, "ChatConfigCheckButtonTemplate")	
	tab.preferPerfects = true
	tab.usePerfectButton:SetChecked(tab.preferPerfects)
	tab.usePerfectButton:SetPoint("TOPLEFT", "AmrAutoGemButton", "BOTTOMLEFT", 0, -4)
	tab.usePerfectButton:SetScript("OnClick", function () tab.preferPerfects = tab.usePerfectButton:GetChecked() end)
	local text3 = getglobal(tab.usePerfectButton:GetName() .. 'Text')
	text3:SetText(L.AMR_GEMTAB_PREFER_PERFECT)
	text3:SetWidth(150)
	text3:SetPoint("TOPLEFT", tab.usePerfectButton, "TOPRIGHT", 2, -4)
	tab.usePerfectButton:Hide()

	tab.gemSlotHeader = tab:CreateFontString("AmrBadGemSlot0", "ARTWORK", "GameFontNormal")
	tab.gemSlotHeader:SetPoint("TOPLEFT", "AmrGemsText2", "BOTTOMLEFT", 0, -20)
	tab.gemSlotHeader:SetText(L.AMR_GEMTAB_SLOT)
	tab.gemSlotHeader:SetWidth(90)
	tab.gemSlotHeader:SetJustifyH("LEFT")
	tab.gemSlotHeader:Hide()
	tab.gemCurrentHeader = tab:CreateFontString("AmrBadGemCurrent0_1", "ARTWORK", "GameFontNormal")
	tab.gemCurrentHeader:SetPoint("TOPLEFT", "AmrBadGemSlot0", "TOPLEFT", 88, 0)
	tab.gemCurrentHeader:SetWidth(110)
	tab.gemCurrentHeader:SetText(L.AMR_GEMTAB_CURRENT)
	tab.gemCurrentHeader:SetJustifyH("LEFT")
	tab.gemCurrentHeader:Hide()
	tab.gemOptimizedHeader = tab:CreateFontString("AmrBadGemOptimized0_1", "ARTWORK", "GameFontNormal")
	tab.gemOptimizedHeader:SetPoint("TOPLEFT", "AmrBadGemCurrent0_1", "TOPLEFT", 70, 0)
	tab.gemOptimizedHeader:SetPoint("RIGHT", -30, 0)
	tab.gemOptimizedHeader:SetText(L.AMR_GEMTAB_OPTIMIZED)
	tab.gemOptimizedHeader:SetJustifyH("LEFT")
	tab.gemOptimizedHeader:Hide()

	tab.fauxScroll = CreateFrame("ScrollFrame", "testme", tab, "FauxScrollFrameTemplate")
	tab.fauxScroll:SetPoint("BOTTOMRIGHT", -40, 15)
	tab.fauxScroll:SetPoint("TOPLEFT", "AmrBadGemSlot0", "BOTTOMLEFT", -12, -5)
	tab.fauxScroll.parent = tab
	tab.fauxScroll:SetScript("OnVerticalScroll", AskMrRobot.GemTab.OnVerticalScroll)

	tab.jewelPanels = {}
	for i = 1, MAX_SLOTS do

		tab.jewelPanels[i] = AskMrRobot.JewelPanel:new("AmrBadGemSlot" .. i, tab)
		if i == 1 then
			tab.jewelPanels[i]:SetPoint("TOPLEFT", "AmrBadGemSlot" .. (i-1), "BOTTOMLEFT", -12, -5)
			--tab.jewelPanels[i]:SetPoint("TOPLEFT")
		else
			tab.jewelPanels[i]:SetPoint("TOPLEFT", "AmrBadGemSlot" .. (i-1), "BOTTOMLEFT", 0, -5)
		end
		tab.jewelPanels[i]:SetPoint("RIGHT", -40, 0)
	end

	return tab
end

function AskMrRobot.GemTab:startAutoGem()
	if AskMrRobot.AutoGem(self.preferPerfects) == false then 
		StaticPopup_Show("AUTOGEM_ONCE")
	end
end

function AskMrRobot.GemTab:Update()
	self.count = 0

	local i = 1
	local badGemTotal = 0

	if AskMrRobot.ComparisonResult.gems then
		for iSlot = 1, #AskMrRobot.slotIds do
			local slotId = AskMrRobot.slotIds[iSlot]
			local badGems = AskMrRobot.ComparisonResult.gems[slotId]
			if badGems ~= nil then
				self.count = self.count + 1
				if i <= MAX_SLOTS then
					self.jewelPanels[i]:Show()
				end
				for g = 1, #badGems.optimized do
					if not AskMrRobot.AreGemsCompatible(badGems.optimized[g], badGems.current[g]) then
						badGemTotal = badGemTotal + 1
					end
				end
				i = i + 1
			end
		end
	end

	self.gemsTextToOptimize:SetFormattedText(L.AMR_GEMTAB_TO_OPTIMIZE, badGemTotal)

	--hide/show the headers, depending on if we have any bad gems
	if self.count == 0 then
		self.gemSlotHeader:Hide()
		self.gemCurrentHeader:Hide()
		self.gemOptimizedHeader:Hide()
		self.gemsTextToOptimize:Hide()
		self.button:Hide()
		self.usePerfectButton:Hide()
		self.stamp:Show()
	else
		self.gemSlotHeader:Show()
		self.gemCurrentHeader:Show()
		self.gemOptimizedHeader:Show()
		self.gemsTextToOptimize:Show()
		--self.button:Show()
		--self.usePerfectButton:Show()
		self.stamp:Hide()
	end	

	for i = self.count + 1, MAX_SLOTS do
		self.jewelPanels[i]:Hide()
		i = i + 1
	end

	AskMrRobot.GemTab.OnUpdate(self.fauxScroll, self.count, #self.jewelPanels, self.jewelPanels[1]:GetHeight())
end

function AskMrRobot.GemTab.OnVerticalScroll(scrollframe, offset)
	local self = scrollframe.parent
	FauxScrollFrame_OnVerticalScroll(self.fauxScroll, offset, self.jewelPanels[1]:GetHeight(), AskMrRobot.GemTab.OnUpdate)
end

function AskMrRobot.GemTab.OnUpdate(scrollframe)	
	local self = scrollframe.parent
	FauxScrollFrame_Update(self.fauxScroll, self.count, #self.jewelPanels, self.jewelPanels[1]:GetHeight())
	local offset = FauxScrollFrame_GetOffset(scrollframe)

	local i = 1
	if AskMrRobot.ComparisonResult.gems then
		for iSlot = 1, #AskMrRobot.slotIds do
			local slotId = AskMrRobot.slotIds[iSlot]
			local badGems = AskMrRobot.ComparisonResult.gems[slotId]
			if badGems ~= nil then
				if offset > 0 then
					offset = offset - 1
				else

					if i > MAX_SLOTS then
						break
					end

					self.jewelPanels[i]:SetItemLink(AskMrRobot.slotDisplayText[slotId], AmrDb.Equipped[AmrDb.ActiveSpec][slotId])
					self.jewelPanels[i]:SetOptimizedGems(badGems.optimized, badGems.current)
					i = i + 1
				end
			end
		end
	end
end