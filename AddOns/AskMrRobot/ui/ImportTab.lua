local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the ImportTab class
AskMrRobot.ImportTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

function AskMrRobot.ImportTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)
	setmetatable(tab, { __index = AskMrRobot.ImportTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()

	local text = tab:CreateFontString("AmrImportText1", "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetFormattedText(L.AMR_IMPORTTAB_TITLE)

	text = tab:CreateFontString("AmrImportText2", "ARTWORK", "GameFontWhite")
	text:SetPoint("TOPLEFT", "AmrImportText1", "BOTTOMLEFT", 0, -20)
	text:SetPoint("RIGHT", -15, 0)
	text:SetWidth(text:GetWidth())
	text:SetJustifyH("LEFT")
	text:SetText(L.AMR_IMPORTTAB_INSTRUCTIONS_1)

	text = tab:CreateFontString("AmrImportText3", "ARTWORK", "GameFontWhite")
	text:SetPoint("TOPLEFT", "AmrImportText2", "BOTTOMLEFT", 0, -10)
	text:SetPoint("RIGHT", -15, 0)
	text:SetWidth(text:GetWidth())
	text:SetJustifyH("LEFT")
	text:SetText(L.AMR_IMPORTTAB_INSTRUCTIONS_2)

	local scrollFrame = CreateFrame("ScrollFrame", "AmrImportScrollFrame", tab, "InputScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 5, -10)
	scrollFrame:SetPoint("RIGHT", -30, 0)
	scrollFrame:SetWidth(430)
	scrollFrame:SetHeight(60);
	scrollFrame.EditBox:SetWidth(scrollFrame:GetWidth())
	scrollFrame.EditBox:SetMaxLetters(2400)
	scrollFrame.CharCount:Hide()
	scrollFrame.EditBox:SetFocus()
	scrollFrame.EditBox:HighlightText()
	tab.scrollFrame = scrollFrame

	tab.button = CreateFrame("Button", "AmrImportButton", tab, "UIPanelButtonTemplate")	
	tab.button:SetText(L.AMR_IMPORTTAB_BUTTON)
	tab.button:SetWidth(100)
	tab.button:SetHeight(20)
	tab.button:SetPoint("BOTTOM", tab, "BOTTOM", 0, 20)
	scrollFrame:SetPoint("BOTTOM", tab.button, "TOP", 0, 15)

	tab:SetScript("OnShow", function()
		tab.scrollFrame.EditBox:HighlightText()
		tab.scrollFrame.EditBox:SetFocus()
		tab:Update()
	end)

	return tab	
end

function AskMrRobot.ImportTab:GetImportText()
	return self.scrollFrame.EditBox:GetText()
end

function AskMrRobot.ImportTab:SetImportText(text)
	self.scrollFrame.EditBox:SetText(text)
	self.scrollFrame.EditBox:HighlightText()
end

-- update the panel and state
function AskMrRobot.ImportTab:Update()
end