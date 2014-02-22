


function Eclipse_2Boolean(var)

	if (var == 1) then
		var = "true"
	elseif (var == 0) or (var == nil) then
		var = "false"
	end
	
	return var
	
end


--/-------------\--
--| Check Boxes |--
--\-------------/--


function Eclipse_UpdateCheckBoxes()

	ECWEclipseCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWEclipseCB))
	ECWEclipseCooldownCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWEclipseCooldownCB))
	ECWMoonfireCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWMoonfireCB))
	ECWInsectswarmCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWInsectswarmCB))
	ECWEluneCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWEluneCB))
	ECWNGraceCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWNGraceCB))
	ECWRootsCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWRootsCB))
	ECWFaerieCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWFaerieCB))
	ECWSeperateBarsCB:SetChecked(Eclipse_2Boolean(Eclipse.Opt.ECWSeperateBarsCB))

end

function Eclipse_ButtonClick(spell)

	ColorPickerFrame:Show();
	ColorPickerFrame:ClearAllPoints(); 
	ColorPickerFrame:SetPoint("LEFT", EclipseGUIPanel, "RIGHT", 10, 0);
	ColorPickerFrame:SetToplevel("true");
	ColorPickerFrame:SetMovable("true");
	ECWcolor = Eclipse.Colors[spell]
	ColorPickerFrame:SetColorRGB(ECWcolor.r, ECWcolor.g, ECWcolor.b);

end

function Eclipse_MovableBarButtonClick()

	ECL.Bars:ShowMovableBar(true, false)

end

--/-------------\--
--| Color Funcs |--
--\-------------/--


function Eclipse_SlashCmd(msg)

	InterfaceOptionsFrame_OpenToCategory("Eclipse");
	
end


function Eclipse_CustomColor()

	local R, G, B = ColorPickerFrame:GetColorRGB();	
	local ref = Eclipse.CurrentEdit
	
	Eclipse.Colors[ref] = {r = R, g = G, b = B};
	EclipseGUIBarOptions[ref]:SetTexture(R, G, B);
	
end


--|-|-|------------------------------------|-|-|--
--|-|-|---------- Frame Creation ----------|-|-|--
--|-|-|------------------------------------|-|-|--


function Eclipse_FrameCreation()


EclipseGUIPanel = CreateFrame("Frame", "EclipseGUIPanel", UIParent)
EclipseGUIPanel.name = "Eclipse"
InterfaceOptions_AddCategory(EclipseGUIPanel)

		
	EclipseGUIPanelText1 = EclipseGUIPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	EclipseGUIPanelText1:SetFont("Fonts\\FRIZQT__.TTF", 18) 
	EclipseGUIPanelText1:SetText("Eclipse")
	EclipseGUIPanelText1:SetPoint("TOPLEFT", EclipseGUIPanel, "TOPLEFT", 15, -15)
	EclipseGUIPanelText1:SetTextColor(0, 0.7, 0.7, 1)
	
	EclipseGUIPanelText2 = EclipseGUIPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	EclipseGUIPanelText2:SetFont("Fonts\\FRIZQT__.TTF", 12) 
	EclipseGUIPanelText2:SetText("Author: Scruffles")
	EclipseGUIPanelText2:SetPoint("TOPLEFT", EclipseGUIPanel, "TOPLEFT", 15, -45)
	EclipseGUIPanelText2:SetTextColor(0, 0.7, 0.7, 1)
		


EclipseGUIBarOptions = CreateFrame("Frame", "EclipseGUIBarOptions", UIParent)
EclipseGUIBarOptions:EnableMouse("true")
EclipseGUIBarOptions.name = "Bar Options"
EclipseGUIBarOptions.parent = "Eclipse"
InterfaceOptions_AddCategory(EclipseGUIBarOptions)

		local k, v
		local t = {
			[-15]="Show Eclipse?",
			[-40]="Show Eclipse cooldown?",
			[-135]="Show Moonfire?",
			[-195]="Show Insect Swarm?",
			[-255]="Show Nature's Grace?",}
			
		for k, v in pairs(t) do
			EclipseGUIBarOptions[v] = EclipseGUIBarOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			EclipseGUIBarOptions[v]:SetFont("Fonts\\FRIZQT__.TTF", 10)
			EclipseGUIBarOptions[v]:SetText(v)
			EclipseGUIBarOptions[v]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 38, k-2)
		end
		
		local t = {
			[-15]="Show Faerie Fire?",
			[-75]="Show Entangling Roots?",
			[-135]="Show Elune's Wrath?",
			[-195]="Show Omen of Doom?",
			[-255]="Show Languish?",}
			
		for k, v in pairs(t) do
			EclipseGUIBarOptions[v] = EclipseGUIBarOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			EclipseGUIBarOptions[v]:SetFont("Fonts\\FRIZQT__.TTF", 10)
			EclipseGUIBarOptions[v]:SetText(v)
			EclipseGUIBarOptions[v]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 238, k-2)
		end
		
		
		local t = {
			[-65]="Wrath",
			[-100]="Starfire",
			[-160]="Moonfire",
			[-220]="Insectswarm",
			[-280]="NGrace",}
			
		for k, v in pairs(t) do
		
			local ECL_color_t = Eclipse.Colors[v]
			local R = ECL_color_t.r
			local G = ECL_color_t.g
			local B = ECL_color_t.b
			
			local name = v .. "BT"
			local hili = v .. "H"
		
			EclipseGUIBarOptions[v] = EclipseGUIBarOptions:CreateTexture(nil, "ARTWORK")
			EclipseGUIBarOptions[v]:SetSize(20, 20)
			EclipseGUIBarOptions[v]:SetTexture(R, G, B, 1)
			EclipseGUIBarOptions[v]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 40, k)
			
			EclipseGUIBarOptions[name] = CreateFrame("Button", nil, EclipseGUIBarOptions)
			EclipseGUIBarOptions[name]:SetSize(20, 20)
			EclipseGUIBarOptions[name]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 40, k)
			EclipseGUIBarOptions[name]:SetScript("OnClick", function()
				Eclipse.CurrentEdit = v;
				Eclipse_ButtonClick(v);
			end)
			
		end
		
		
		local t = {
			[-40]="Faerie",
			[-100]="Roots",
			[-160]="Elune",
			[-220]="OmenDoom",
			[-280]="Languish",}
			
		for k, v in pairs(t) do
		
			local ECL_color_t = Eclipse.Colors[v]
			local R = ECL_color_t.r
			local G = ECL_color_t.g
			local B = ECL_color_t.b
			
			local name = v .. "BT"
			local hili = v .. "H"
		
			EclipseGUIBarOptions[v] = EclipseGUIBarOptions:CreateTexture(nil, "ARTWORK")
			EclipseGUIBarOptions[v]:SetSize(20, 20)
			EclipseGUIBarOptions[v]:SetTexture(R, G, B, 1)	
			EclipseGUIBarOptions[v]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 240, k)
			
			EclipseGUIBarOptions[name] = CreateFrame("Button", nil, EclipseGUIBarOptions)
			EclipseGUIBarOptions[name]:SetSize(20, 20)
			EclipseGUIBarOptions[name]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 240, k)
			EclipseGUIBarOptions[name]:SetScript("OnClick", function()
				Eclipse.CurrentEdit = v;
				Eclipse_ButtonClick(v);
			end)
			
		end
		
		local t = {
			[-15]="ECWEclipseCB",
			[-40]="ECWEclipseCooldownCB",
			[-135]="ECWMoonfireCB",
			[-195]="ECWInsectswarmCB",
			[-255]="ECWNGraceCB",}
			
		for k, v in pairs(t) do
			EclipseGUIBarOptions[v] = CreateFrame("CheckButton", nil, EclipseGUIBarOptions, "OptionsCheckButtonTemplate")
			EclipseGUIBarOptions[v]:SetChecked(Eclipse.Opt[v])
			EclipseGUIBarOptions[v]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 12, k+5)
			EclipseGUIBarOptions[v]:SetScript("OnClick", function()
				Eclipse.Opt[v] = EclipseGUIBarOptions[v]:GetChecked()
			end)
			EclipseGUIBarOptions[v]:Show()
		end
		
		local t = {
			[-15]="ECWFaerieCB",
			[-75]="ECWRootsCB",
			[-135]="ECWEluneCB",
			[-195]="ECWOmenDoomCB",
			[-255]="ECWLanguishCB",}
			
		for k, v in pairs(t) do
			EclipseGUIBarOptions[v] = CreateFrame("CheckButton", nil, EclipseGUIBarOptions, "OptionsCheckButtonTemplate")
			EclipseGUIBarOptions[v]:SetChecked(Eclipse.Opt[v])
			EclipseGUIBarOptions[v]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 212, k+5)
			EclipseGUIBarOptions[v]:SetScript("OnClick", function()
				Eclipse.Opt[v] = EclipseGUIBarOptions[v]:GetChecked()
			end)
			EclipseGUIBarOptions[v]:Show()
		end
		
		local t = {
			[-65]="Wrath",
			[-100]="Starfire",
			[-160]="Moonfire",
			[-220]="Insect Swarm",
			[-280]="Nature's Grace",}
			
		for k, v in pairs(t) do
			
			local name = v .. "Text"
			
			EclipseGUIBarOptions[name] = EclipseGUIBarOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			EclipseGUIBarOptions[name]:SetFont("Fonts\\FRIZQT__.TTF", 12)
			EclipseGUIBarOptions[name]:SetText(v)
			EclipseGUIBarOptions[name]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 65, k-2)
			
		end
		
		local t = {
			[-40]="Faerie Fire",
			[-100]="Entangling Roots",
			[-160]="Elune's Grace",
			[-220]="Omen of Doom",
			[-280]="Languish",}
			
		for k, v in pairs(t) do
		
			local name = v .. "Text"
		
			EclipseGUIBarOptions[name] = EclipseGUIBarOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			EclipseGUIBarOptions[name]:SetFont("Fonts\\FRIZQT__.TTF", 12)
			EclipseGUIBarOptions[name]:SetText(v)
			EclipseGUIBarOptions[name]:SetPoint("TOPLEFT", EclipseGUIBarOptions, "TOPLEFT", 265, k-2)
			
		end
		
		
		
		
		
EclipseGUIAdditionalOptions = CreateFrame("Frame", "EclipseGUIAdditionalOptions", UIParent)
EclipseGUIAdditionalOptions.name = "More Options"
EclipseGUIAdditionalOptions.parent = "Eclipse"
InterfaceOptions_AddCategory(EclipseGUIAdditionalOptions)

	EclipseGUIAdditionalOptionsText = EclipseGUIAdditionalOptions:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	EclipseGUIAdditionalOptionsText:SetFont("Fonts\\FRIZQT__.TTF", 10)
	EclipseGUIAdditionalOptionsText:SetText("Seperate eclipse bars from the rest of DBM?")
	EclipseGUIAdditionalOptionsText:SetPoint("TOPLEFT", EclipseGUIAdditionalOptions, "TOPLEFT", 38, -15)

	EclipseGUIAdditionalOptionsCB = CreateFrame("CheckButton", "ECWSeperateBarsCB", EclipseGUIAdditionalOptions, "OptionsCheckButtonTemplate")
	EclipseGUIAdditionalOptionsCB:SetChecked(Eclipse.Opt.ECWSeperateBarsCB)
	EclipseGUIAdditionalOptionsCB:SetText("Seperate eclipse bars from the rest of DBM?");
	EclipseGUIAdditionalOptionsCB:SetScript("OnClick", function()
				Eclipse.Opt.ECWSeperateBarsCB = EclipseGUIAdditionalOptionsCB:GetChecked()
			end)
	EclipseGUIAdditionalOptionsCB:SetPoint("TOPLEFT", EclipseGUIAdditionalOptions, "TOPLEFT", 15, -15)

	EclipseGUIAdditionalOptionsB = CreateFrame("Button", "EclipseMovableBarButton", EclipseGUIAdditionalOptions, "UIPanelButtonTemplate")
			EclipseGUIAdditionalOptionsB:SetText("Movable Bar")
			EclipseGUIAdditionalOptionsB:SetSize(100, 20)
			EclipseGUIAdditionalOptionsB:SetPoint("TOPLEFT", EclipseGUIAdditionalOptions, "TOPLEFT", 40, -40)
			EclipseGUIAdditionalOptionsB:SetScript("OnClick", Eclipse_MovableBarButtonClick)

end
