local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the ExportTab class
AskMrRobot.ExportTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- helper to create text for this tab
local function CreateText(tab, font, relativeTo, xOffset, yOffset, text)
    local t = tab:CreateFontString(nil, "ARTWORK", font)
	t:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", xOffset, yOffset)
	t:SetPoint("RIGHT", tab, "RIGHT", -25, 0)
	t:SetWidth(t:GetWidth())
	t:SetJustifyH("LEFT")
	t:SetText(text)
    
    return t
end

function AskMrRobot.ExportTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)	
	setmetatable(tab, { __index = AskMrRobot.ExportTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()
    
	local text = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetText(L.AMR_EXPORTTAB_EXPORT_TITLE)  
        
    -- copy/paste
    local text2 = CreateText(tab, "GameFontWhite", text, 0, -15, L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_1)
    text = CreateText(tab, "GameFontWhite", text2, 0, -15, L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_2)

	local txtExportString = CreateFrame("ScrollFrame", "AmrScrollFrame", tab, "InputScrollFrameTemplate")
	txtExportString:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 12, -10)
	txtExportString:SetPoint("RIGHT", -25, 0)
	txtExportString:SetWidth(txtExportString:GetWidth())
	txtExportString:SetHeight(50)
	txtExportString.EditBox:SetWidth(txtExportString:GetWidth())
    txtExportString.EditBox:SetMaxLetters(0)
	txtExportString.CharCount:Hide()
	tab.txtExportString = txtExportString
    
    txtExportString.EditBox:SetScript("OnEscapePressed", function()
        AskMrRobot.mainWindow:Hide()
    end)
    
    text = CreateText(tab, "GameFontWhite", txtExportString, -12, -20, L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_3)
 
    text = CreateText(tab, "GameFontWhite", text, 0, -10, L.AMR_EXPORTTAB_COPY_PASTE_EXPORT_NOTE)
    
    btn = CreateFrame("Button", "AmrUpdateExportString", tab, "UIPanelButtonTemplate")
	btn:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -2, -10)
	btn:SetText("Update")
	btn:SetWidth(110)
	btn:SetHeight(30)
    
    btn:SetScript("OnClick", function()
        tab:Update()
    end)

    tab:SetScript("OnShow", function()
        tab:Update()
	end)
    
	return tab
end

-- update the panel and state
function AskMrRobot.ExportTab:Update()
    AskMrRobot.SaveAll()
    self.txtExportString.EditBox:SetText(AskMrRobot.ExportToString())
    self.txtExportString.EditBox:HighlightText()
    self.txtExportString.EditBox:SetFocus()
end
