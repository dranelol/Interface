local addonName, AskMrRobot = ...
local L = AskMrRobot.L

local wow_ver = select(4, GetBuildInfo())
local wow_500 = wow_ver >= 50000
local UIPanelButtonTemplate = wow_500 and "UIPanelButtonTemplate" or "UIPanelButtonTemplate2"

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = addonName
frame:Hide()

-- Credits to Ace3, Tekkub, cladhaire and Tuller for some of the widget stuff.

local function newCheckbox(label, tooltipTitle, description, onClick)
	local check = CreateFrame("CheckButton", "AmrCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		onClick(self, self:GetChecked() and true or false)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = tooltipTitle
	check.tooltipRequirement = description
	return check
end

frame:SetScript("OnShow", function(frame)
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(addonName)

	local subTitleWrapper = CreateFrame("Frame", nil, frame)
	subTitleWrapper:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subTitleWrapper:SetPoint("RIGHT", -16, 0)
	local subtitle = subTitleWrapper:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", subTitleWrapper)
	subtitle:SetWidth(subTitleWrapper:GetRight() - subTitleWrapper:GetLeft())
	subtitle:SetJustifyH("LEFT")
	subtitle:SetNonSpaceWrap(false)
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(L.AMR_CONFIG_EXIMPORT)
	subTitleWrapper:SetHeight(subtitle:GetHeight())

    -- hide minimap icon
	local autoPopup = newCheckbox(
		L.AMR_CONFIG_CHECKBOX_MINIMAP_LABEL,
		L.AMR_CONFIG_CHECKBOX_MINIMAP_TOOLTIP_TITLE,
		L.AMR_CONFIG_CHECKBOX_MINIMAP_DESCRIPTION,
		function(self, value) 
			if AmrDb.Options.hideMapIcon then
				AmrDb.Options.hideMapIcon = false
			else
				AmrDb.Options.hideMapIcon = true
			end
			AskMrRobot.AmrUpdateMinimap();
		end
	)
	autoPopup:SetChecked(not AmrDb.Options.hideMapIcon)
	autoPopup:SetPoint("TOPLEFT", subTitleWrapper, "BOTTOMLEFT", -2, -16)


    -- auto-show at auction house
	local autoAh = newCheckbox(
		L.AMR_CONFIG_CHECKBOX_AUTOAH_LABEL,
		L.AMR_CONFIG_CHECKBOX_AUTOAH_TOOLTIP_TITLE,
		L.AMR_CONFIG_CHECKBOX_AUTOAH_DESCRIPTION,
		function(self, value) 
			if AmrDb.Options.manualShowShop then
				AmrDb.Options.manualShowShop = false
			else
				AmrDb.Options.manualShowShop = true
			end
		end
	)
	autoAh:SetChecked(not AmrDb.Options.manualShowShop)
	autoAh:SetPoint("TOPLEFT", subTitleWrapper, "BOTTOMLEFT", -2, -58)

	frame:SetScript("OnShow", nil)
end)
InterfaceOptions_AddCategory(frame)

