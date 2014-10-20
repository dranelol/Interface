local _, AskMrRobot = ...
local L = AskMrRobot.L;

-- initialize the HelpTab class
AskMrRobot.HelpTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

function AskMrRobot.HelpTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)
	setmetatable(tab, { __index = AskMrRobot.HelpTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()

	local text = tab:CreateFontString("AmrHelpText1", "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetText(L.AMR_HELPTAB_TITLE)

	local text2 = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	text2:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -10)
	text2:SetPoint("RIGHT", tab, "RIGHT", -25, -8)
	text2:SetWidth(text2:GetWidth())
	text2:SetJustifyH("LEFT")
	text2:SetText(L.AMR_HELPTAB_LINK)

	local answer = text2
	for i = 1, 6 do
		text = AskMrRobot.FontString:new(tab, nil, "ARTWORK", "GameFontWhite")
		text:SetPoint("TOPLEFT", answer, "BOTTOMLEFT", 0, -11)
		text:SetPoint("RIGHT", -18, 0)
		text:SetWidth(text2:GetWidth())
		text:SetJustifyH("LEFT")
		text:SetText(L['AMR_HELPTAB_Q' .. i])
		text:IncreaseFontSize(1)
		text:SetTextColor(1,1,1)

		answer = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		answer:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -4)
		answer:SetPoint("RIGHT", tab, "RIGHT", -18, 0)
		answer:SetWidth(text2:GetWidth())
		answer:SetJustifyH("LEFT")
		answer:SetText(L['AMR_HELPTAB_A' .. i])
		answer:SetTextColor(0.7,0.7,0.7)
	end	

	return tab
end