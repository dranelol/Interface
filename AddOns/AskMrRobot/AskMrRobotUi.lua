local _, AskMrRobot = ...
local L = AskMrRobot.L;

AskMrRobot.AmrUI = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

local _menuIds = {
	export = 1,
	gear = 2,
	combatLog = 3,
	help = 4    
}

function AskMrRobot.AmrUI:new()
	local o = AskMrRobot.Frame:new("AskMrRobot_Dialog", nil, "BasicFrameTemplateWithInset")

	-- use the AmrUI class
	setmetatable(o, { __index = AskMrRobot.AmrUI })

	o:RegisterForDrag("LeftButton");
	o:SetWidth(615)
	o:SetHeight(550)
	o.InsetBg:SetPoint("TOPLEFT", 140, -24)

	o:SetParent("UIParent")
	o:SetPoint("CENTER")
	o:Hide()
	o:EnableMouse(true)
	o:EnableKeyboard(true)
	o.hideOnEscape = 1
	o:SetMovable(true)
	o:SetToplevel(true)

	o:SetScript("OnDragStart", AskMrRobot.AmrUI.OnDragStart)
	o:SetScript("OnDragStop", AskMrRobot.AmrUI.OnDragStop)
	o:SetScript("OnHide", AskMrRobot.AmrUI.OnHide)
	o:SetScript("OnShow", AskMrRobot.AmrUI.OnShow)

	o:RegisterEvent("AUCTION_HOUSE_CLOSED")
	o:RegisterEvent("AUCTION_HOUSE_SHOW")
	o:RegisterEvent("SOCKET_INFO_UPDATE")
	o:RegisterEvent("SOCKET_INFO_CLOSE")

	o:SetScript("OnEvent", function(...)
		o:OnEvent(...)
	end)

	tinsert(UISpecialFrames, o:GetName())

    -- initialize some fields
    o.initialized = false
    o.visible = false

	-- title
	o.TitleText:SetText("--BETA-- Ask Mr. Robot v" .. GetAddOnMetadata(AskMrRobot.AddonName, "Version"))

	-- create the main menu
	o.menu = o:createMainMenu()

	local tabArea = AskMrRobot.Frame:new(nil, o)
	tabArea:SetPoint("TOPLEFT", 155, -30)
	tabArea:SetPoint("BOTTOMRIGHT")	

	o.exportTab = AskMrRobot.ExportTab:new(tabArea)
	o.menu[_menuIds["export"]].element = o.exportTab
    
    o.gearComparisonTab = AskMrRobot.GearComparisonTab:new(tabArea)
    o.menu[_menuIds["gear"]].element = o.gearComparisonTab
    
    o.combatLogTab = AskMrRobot.CombatLogTab:new(tabArea)
    o.menu[_menuIds["combatLog"]].element = o.combatLogTab

    o.helpTab = AskMrRobot.HelpTab:new(tabArea)
    o.menu[_menuIds["help"]].element = o.helpTab
    
	o:Hide()
	o:ShowMenu("export")	
    
	return o
end

function AskMrRobot.AmrUI:createMainMenu()
	local buttons = {}

	local function onTabButtonClick(clickedButton, event, ...)
		for i = 1, #buttons do
			local button = buttons[i]
			if clickedButton == button then
				button.highlight:SetVertexColor(1, 1, 0)
				button:LockHighlight()
                if button.element then
                    button.element:Show()
                end
			else
				button.highlight:SetVertexColor(.196, .388, .8)
				button:UnlockHighlight()
				if button.element then
					button.element:Hide()
				end
			end
		end
	end

	local function createButton(text, spacing)
		local lastButton = #buttons
		local i = lastButton + 1
		local tabButton = CreateFrame("Button", "AmrTabButton" .. i, self, "OptionsListButtonTemplate")
		tabButton:SetText(text)
		tabText = tabButton:GetFontString()
		tabText:SetPoint("LEFT", 6, 0)
		if i == 1 then
			tabButton:SetPoint("TOPLEFT", 2, spacing)
		else
			tabButton:SetPoint("TOPLEFT", "AmrTabButton" .. lastButton, "BOTTOMLEFT", 0, spacing)
		end
		tabButton:SetWidth(140)
		tabButton:SetHeight(20)
		tinsert(buttons, tabButton)
		tabButton:SetScript("OnClick", onTabButtonClick)
	end

	createButton(L.AMR_UI_MENU_EXPORT, -35)
	createButton(L.AMR_UI_MENU_GEAR, -20)
	createButton(L.AMR_UI_MENU_COMBAT_LOG, 0)
	createButton(L.AMR_UI_MENU_HELP, 0)

	return buttons
end

function AskMrRobot.AmrUI:ShowMenu(menu)
	local id = _menuIds[menu]
	if id then
		self.menu[id]:Click()
	end
end

function AskMrRobot.AmrUI:Toggle()
	if self.visible then
		self:Hide()
	else
		self.visible = true
        self:Show()
	end
end

function AskMrRobot.AmrUI:OnShow()

end

function AskMrRobot.AmrUI:OnDragStart()
	if not self.isLocked then
		self:StartMoving();
	end
end

function AskMrRobot.AmrUI:OnDragStop()
	self:StopMovingOrSizing()
end

function AskMrRobot.AmrUI:OnHide()
	self.visible = false
	self:StopMovingOrSizing()
end

function AskMrRobot.AmrUI:OnEvent(frame, event, ...)
	local handler = self["On_" .. event]
	if handler then
		handler(self, ...)
	end
end
