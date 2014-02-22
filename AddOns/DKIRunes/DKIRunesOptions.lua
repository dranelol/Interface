
--load slash commands
SlashCmdList["DKIRUNES"] = function()
	InterfaceOptionsFrame_OpenToCategory('DKIRunes')
end
SLASH_DKIRUNES1 = "/dkirunes"
SLASH_DKIRUNES2 = "/dki"

function DKIRunes_populateBlizzardOptions()
	local frame = CreateFrame("frame", "DKIRunes_BlizzardOptions", UIParent);
	frame.name = "DKIRunes";
	frame:SetWidth(300);
	frame:SetHeight(200);
	frame:Show();
	InterfaceOptions_AddCategory(frame);

	local reset = CreateFrame("Button", "DKIRunesReset", frame, "OptionsButtonTemplate");
	reset:SetText("Reset to Default")
	reset:SetScript('OnClick', DKIRunes_Reset)
	reset:SetWidth(130);
	reset:SetHeight(24);
	reset:GetFontString():SetPoint("TOP", reset, "TOP", 0, -6)
	reset:SetPoint("TOPLEFT", 10, -20)

	local lock = CreateFrame("CheckButton", "FrameLock", frame, "OptionsCheckButtonTemplate");
	_G[lock:GetName().."Text"]:SetText("Unlock Runes");
	lock:SetScript('OnShow', function(self) self:SetChecked(DKIRunesFrame:IsMouseEnabled()) end)
	lock:SetScript('OnClick', function(self) DKIRunes_Lock(self:GetChecked()) end)
	lock:SetPoint('LEFT', reset, 'RIGHT', 15, -2)

	local rotate = CreateFrame("Button", "RotateButton", frame, "OptionsButtonTemplate");
	rotate:SetText("Rotate")
	rotate:SetScript('OnClick', function() DKIRunes_Rotate(true) end)
	rotate:SetWidth(100);
	rotate:SetHeight(24);
	rotate:GetFontString():SetPoint("TOP", rotate, "TOP", 0, -6)
	rotate:SetPoint('LEFT', lock, 'RIGHT', 115, 2)

	local fade = CreateFrame("CheckButton", "AgroFade", frame, "OptionsCheckButtonTemplate");
	_G[fade:GetName().."Text"]:SetText("Fade out of Combat");
	fade:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.fade) end)
	fade:SetScript('OnClick', function(self) DKIRunes_Saved.fade = self:GetChecked() end)
	fade:SetPoint('TOPLEFT', reset, 'BOTTOMLEFT', 0, -10)

	local optionsTitle = frame:CreateFontString("optionsTitleString","ARTWORK","GameTooltipHeaderText");
	optionsTitle:SetText("Rune Options")
	optionsTitle:SetPoint('TOPLEFT', reset, 'BOTTOMLEFT', 0, -40)

	local empower = CreateFrame("CheckButton", "EmpowerCheck", frame, "OptionsCheckButtonTemplate");
	_G[empower:GetName().."Text"]:SetText("Runic Empowerment Animation");
	empower:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.empower) end)
	empower:SetScript('OnClick', function(self) DKIRunes_Saved.empower = self:GetChecked() end)
	empower:SetPoint('TOPLEFT', optionsTitle, 'BOTTOMLEFT', 20, -5)
	
	local rc_blur = CreateFrame("CheckButton", "BlurCheck", frame, "OptionsCheckButtonTemplate");
	_G[rc_blur:GetName().."Text"]:SetText("Runic Corruption Blur");
	rc_blur:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.rc_blur) end);
	rc_blur:SetScript('OnClick', function(self) DKIRunes_Saved.rc_blur = self:GetChecked() end);
	rc_blur:SetPoint('LEFT', empower, 'RIGHT', 210, 0)

	local gUholy = CreateFrame("CheckButton", "gUnholyCheck", frame, "OptionsCheckButtonTemplate");
	_G[gUholy:GetName().."Text"]:SetText("Green Unholy");
	gUholy:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.greenUnholy) end)
	gUholy:SetScript('OnClick', function(self) DKIRunes_Saved.greenUnholy = self:GetChecked();DKIRunes_UpdateArt(); end)
	gUholy:SetPoint('TOPLEFT', empower, 'BOTTOMLEFT', 0, 0)

	local pDeath = CreateFrame("CheckButton", "pDeathCheck", frame, "OptionsCheckButtonTemplate");
	_G[pDeath:GetName().."Text"]:SetText("Purple Death");
	pDeath:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.purpleDeath) end)
	pDeath:SetScript('OnClick', function(self) DKIRunes_Saved.purpleDeath = self:GetChecked();DKIRunes_UpdateArt(); end)
	pDeath:SetPoint('LEFT', gUholy, 'RIGHT', 100, 0)

	local graphicsTitle = frame:CreateFontString("graphicsTitleString","ARTWORK","GameTooltipHeaderText");
	graphicsTitle:SetText("Rune Frame Graphics")
	graphicsTitle:SetPoint('TOPLEFT', optionsTitle, 'BOTTOMLEFT', 0, -70)

	graphics = CreateFrame("Frame", "RuneFrameGraphics", frame, "UIDropDownMenuTemplate"); 
	graphics:SetPoint('TOPLEFT', graphicsTitle, 'BOTTOMLEFT', 5, -5)
	UIDropDownMenu_Initialize(graphics, Graphics_Initialise)

	local slider = CreateFrame("Slider", "ScaleSlider", frame, "OptionsSliderTemplate")
	slider:SetMinMaxValues(0.2, 2.0)
	slider:SetValueStep(0.05)
	slider:SetWidth(160)
	_G['ScaleSliderLow']:SetText("small")
	_G['ScaleSliderHigh']:SetText("large")
	slider:SetScript('OnShow', function(self) self:SetValue(DKIRunes_Saved.scale) end)
	slider:SetScript('OnValueChanged', Slider_ValueChanged)
	slider:SetPoint('TOPLEFT', graphics, 'BOTTOMLEFT', 18, -10)

	local slideTitle = frame:CreateFontString("slideTitleString","ARTWORK","GameFontNormal");
	slideTitle:SetText("Frame Scale")
	slideTitle:SetPoint('LEFT', slider, 'RIGHT', 10, 0)
	
	local layoutTitle = frame:CreateFontString("layoutTitleString","ARTWORK","GameTooltipHeaderText");
	layoutTitle:SetText("Rune Layout")
	layoutTitle:SetPoint('TOPLEFT', graphicsTitle, 'BOTTOMLEFT', 0, -90)

	br1 = CreateFrame("Frame", "BR1Slot", frame, "UIDropDownMenuTemplate"); 
	br1:SetPoint('TOPLEFT', layoutTitle, 'BOTTOMLEFT', -15, -20)
	UIDropDownMenu_SetWidth(br1, 50, 5)
	UIDropDownMenu_Initialize(br1, BR1_Initialise)
	
	local br1Title = frame:CreateFontString("br1TitleString","ARTWORK","GameFontNormal");
	br1Title:SetText("Blood")
	br1Title:SetPoint('BOTTOMLEFT', br1, 'TOPLEFT', 30, 0)

	br2 = CreateFrame("Frame", "BR2Slot", frame, "UIDropDownMenuTemplate"); 
	br2:SetPoint('LEFT', br1, 'RIGHT', 10, 0)
	UIDropDownMenu_SetWidth(br2, 50, 5)
	UIDropDownMenu_Initialize(br2, BR2_Initialise)
	
	local br2Title = frame:CreateFontString("br2TitleString","ARTWORK","GameFontNormal");
	br2Title:SetText("Blood")
	br2Title:SetPoint('BOTTOMLEFT', br2, 'TOPLEFT', 30, 0)

	fr1 = CreateFrame("Frame", "FR1Slot", frame, "UIDropDownMenuTemplate"); 
	fr1:SetPoint('LEFT', br2, 'RIGHT', 10, 0)
	UIDropDownMenu_SetWidth(fr1, 50, 5)
	UIDropDownMenu_Initialize(fr1, FR1_Initialise)
	
	local fr1Title = frame:CreateFontString("fr1TitleString","ARTWORK","GameFontNormal");
	fr1Title:SetText("Frost")
	fr1Title:SetPoint('BOTTOMLEFT', fr1, 'TOPLEFT', 30, 0)

	fr2 = CreateFrame("Frame", "FR2Slot", frame, "UIDropDownMenuTemplate"); 
	fr2:SetPoint('LEFT', fr1, 'RIGHT', 10, 0)
	UIDropDownMenu_SetWidth(fr2, 50, 5)
	UIDropDownMenu_Initialize(fr2, FR2_Initialise)
	
	local fr2Title = frame:CreateFontString("fr2TitleString","ARTWORK","GameFontNormal");
	fr2Title:SetText("Frost")
	fr2Title:SetPoint('BOTTOMLEFT', fr2, 'TOPLEFT', 30, 0)

	uh1 = CreateFrame("Frame", "UH1Slot", frame, "UIDropDownMenuTemplate"); 
	uh1:SetPoint('LEFT', fr2, 'RIGHT', 10, 0)
	UIDropDownMenu_SetWidth(uh1, 50, 5)
	UIDropDownMenu_Initialize(uh1, UH1_Initialise)
	
	local uh1Title = frame:CreateFontString("uh1TitleString","ARTWORK","GameFontNormal");
	uh1Title:SetText("Unholy")
	uh1Title:SetPoint('BOTTOMLEFT', uh1, 'TOPLEFT', 30, 0)

	uh2 = CreateFrame("Frame", "UH2Slot", frame, "UIDropDownMenuTemplate"); 
	uh2:SetPoint('LEFT', uh1, 'RIGHT', 10, 0)
	UIDropDownMenu_SetWidth(uh2, 50, 5)
	UIDropDownMenu_Initialize(uh2, UH2_Initialise)
	
	local uh2Title = frame:CreateFontString("uh2TitleString","ARTWORK","GameFontNormal");
	uh2Title:SetText("Unholy")
	uh2Title:SetPoint('BOTTOMLEFT', uh2, 'TOPLEFT', 30, 0)

	-- Runic Power Child Menu
	local rpFrame = CreateFrame("frame", "DKIRunes_RuneOptions", frame);
	rpFrame.parent = "DKIRunes";
	rpFrame.name = "Runic Power";
	rpFrame:SetWidth(300);
	rpFrame:SetHeight(200);
	rpFrame:Hide();
	InterfaceOptions_AddCategory(rpFrame);

	local rpTitle = rpFrame:CreateFontString("rpTitleString","ARTWORK","GameTooltipHeaderText");
	rpTitle:SetText("Runic Power")
	rpTitle:SetPoint("TOPLEFT", 10, -20)

	runicBar0 = CreateFrame("Frame", "RunicBar0", rpFrame, "UIDropDownMenuTemplate"); 
	runicBar0:SetPoint('TOPLEFT', rpTitle, 'BOTTOMLEFT', 5, -5)
	UIDropDownMenu_Initialize(runicBar0, RunicBar0_Initialise)

	local runicBar0Title = rpFrame:CreateFontString("runicBar0TitleString","ARTWORK","GameFontNormal");
	runicBar0Title:SetText("Port Side Bar")
	runicBar0Title:SetPoint('LEFT', runicBar0, 'RIGHT', 120, 0)

	runicBar1 = CreateFrame("Frame", "RunicBar1", rpFrame, "UIDropDownMenuTemplate"); 
	runicBar1:SetPoint('TOP', runicBar0, 'BOTTOM', 0, -5)
	UIDropDownMenu_Initialize(runicBar1, RunicBar1_Initialise)

	local runicBar1Title = rpFrame:CreateFontString("runicBar1TitleString","ARTWORK","GameFontNormal");
	runicBar1Title:SetText("Starboard Side Bar")
	runicBar1Title:SetPoint('LEFT', runicBar1, 'RIGHT', 120, 0)

	local rpCounterEnable = CreateFrame("CheckButton", "RPCounter", rpFrame, "OptionsCheckButtonTemplate");
	_G[rpCounterEnable:GetName().."Text"]:SetText("Numeric Display");
	rpCounterEnable:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.rpCounter) end)
	rpCounterEnable:SetScript('OnClick', function(self) DKIRunes_Saved.rpCounter = self:GetChecked() end)
	rpCounterEnable:SetPoint('TOP', runicBar1, 'BOTTOM', 10, -5)

	local counterSlider = CreateFrame("Slider", "CounterScaleSlider", rpFrame, "OptionsSliderTemplate")
	counterSlider:SetMinMaxValues(0.2, 3.0)
	counterSlider:SetValueStep(0.05)
	counterSlider:SetWidth(60)
	_G['CounterScaleSliderLow']:SetText("small")
	_G['CounterScaleSliderHigh']:SetText("large")
	counterSlider:SetScript('OnShow', function(self) self:SetValue(DKIRunes_Saved.counterScale) end)
	counterSlider:SetScript('OnValueChanged', CounterSlider_ValueChanged)
	counterSlider:SetPoint('LEFT', rpCounterEnable, 'RIGHT', 120, 0)

	-- Rune Cooldown Child Menu
	local rcFrame = CreateFrame("frame", "DKIRunes_RuneOptions", frame);
	rcFrame.parent = "DKIRunes";
	rcFrame.name = "Rune Cooldowns";
	rcFrame:SetWidth(300);
	rcFrame:SetHeight(200);
	rcFrame:Hide();
	InterfaceOptions_AddCategory(rcFrame);

	local cooldownTitle = rcFrame:CreateFontString("cooldownTitleString","ARTWORK","GameTooltipHeaderText");
	cooldownTitle:SetText("Rune Cooldown Options")
	cooldownTitle:SetPoint("TOPLEFT", 10, -20)

	local animate = CreateFrame("CheckButton", "AnimateCheck", rcFrame, "OptionsCheckButtonTemplate");
	_G[animate:GetName().."Text"]:SetText("Flame Animation");
	animate:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.animate) end)
	animate:SetScript('OnClick', function(self) DKIRunes_Saved.animate = self:GetChecked() end)
	animate:SetPoint('TOPLEFT', cooldownTitle, 'BOTTOMLEFT', 20, -5)

	local cooldown = CreateFrame("CheckButton", "CooldownCheck", rcFrame, "OptionsCheckButtonTemplate");
	_G[cooldown:GetName().."Text"]:SetText("OmniCC Support");
	cooldown:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.cooldown) end)
	cooldown:SetScript('OnClick', function(self) DKIRunes_Saved.cooldown = self:GetChecked() end)
	cooldown:SetPoint('LEFT', animate, 'RIGHT', 120, 0)

	local heroTitle = rcFrame:CreateFontString("heroTitleString","ARTWORK","GameTooltipHeaderText");
	heroTitle:SetText("Rune Slide")
	heroTitle:SetPoint("TOPLEFT", 10, -80)

	local heroEnable = CreateFrame("CheckButton", "HeroEnable", rcFrame, "OptionsCheckButtonTemplate");
	_G[heroEnable:GetName().."Text"]:SetText("Enabled");
	heroEnable:SetScript('OnShow', function(self) self:SetChecked(DKIRunes_Saved.hero) end)
	heroEnable:SetScript('OnClick', function(self) DKIRunes_Saved.hero = self:GetChecked() end)
	heroEnable:SetPoint('TOPLEFT', heroTitle, 'BOTTOMLEFT', 20, -5)

	heroOrigin = CreateFrame("Frame", "HeroOrigin", rcFrame, "UIDropDownMenuTemplate"); 
	heroOrigin:SetPoint('LEFT', heroEnable, 'RIGHT', 50, 0)
	UIDropDownMenu_Initialize(heroOrigin, HeroOrigin_Initialise)

	local heroOriginTitle = rcFrame:CreateFontString("heroOriginTitleString","ARTWORK","GameFontNormal");
	heroOriginTitle:SetText("Slide Origin")
	heroOriginTitle:SetPoint('LEFT', heroOrigin, 'RIGHT', 115, 0)

	local heroSliderBackground = CreateFrame("Slider", "HeroSliderBackground", rcFrame, "OptionsSliderTemplate")
	heroSliderBackground:SetMinMaxValues(0, 300)
	heroSliderBackground:SetValueStep(1)
	heroSliderBackground:SetWidth(225)
	_G['HeroSliderBackgroundLow']:SetText("0")
	_G['HeroSliderBackgroundHigh']:SetText(" ")
	heroSliderBackground:SetPoint('TOPLEFT', heroTitle, 'BOTTOMLEFT', 20, -35)
	heroSliderBackground:Disable()

	local heroSlider = CreateFrame("Slider", "HeroSlider", _G['HeroSliderBackground'], "OptionsSliderTemplate")
	heroSlider:SetMinMaxValues(50, 300)
	heroSlider:SetValueStep(1)
	heroSlider:SetWidth(175)
	_G['HeroSliderLow']:SetText("near")
	_G['HeroSliderHigh']:SetText("far")
	heroSlider:SetScript('OnShow', function(self) self:SetValue(DKIRunes_Saved.heroSlide) end)
	heroSlider:SetScript('OnValueChanged', HeroSlider_ValueChanged)
	heroSlider:SetPoint('TOPLEFT', heroTitle, 'BOTTOMLEFT', 70, -35)

	local heroSliderTitle = rcFrame:CreateFontString("heroSliderTitleString","ARTWORK","GameFontNormal");
	heroSliderTitle:SetText("Slide Distance")
	heroSliderTitle:SetPoint('LEFT', heroSlider, 'RIGHT', 6, 0)
	
	local deadRuneTitle = rcFrame:CreateFontString("deadRuneTitleString","ARTWORK","GameFontNormal");
	deadRuneTitle:SetText("Put dead rune slide distance")
	deadRuneTitle:SetPoint('TOPLEFT', heroTitle, 'BOTTOMLEFT', 0, -80)
	
	deadRune = CreateFrame("Frame", "DeadRune", rcFrame, "UIDropDownMenuTemplate"); 
	deadRune:SetPoint('LEFT', deadRuneTitle, 'RIGHT', -15, -3)
	UIDropDownMenu_SetWidth(deadRune, 210, 5)
	UIDropDownMenu_Initialize(deadRune, DeadRune_Initialise)

	local priorityTitle = rcFrame:CreateFontString("priorityTitle","ARTWORK","GameTooltipHeaderText");
	priorityTitle:SetText("Rune Priority")
	priorityTitle:SetPoint('TOPLEFT', heroTitle, 'BOTTOMLEFT', 0, -120)
	
	local swapTitle = rcFrame:CreateFontString("swapTitleString","ARTWORK","GameFontNormal");
	swapTitle:SetText("Runes with shorter cooldowns")
	swapTitle:SetPoint('TOPLEFT', priorityTitle, 'BOTTOMLEFT', 0, -10)
	
	swap = CreateFrame("Frame", "Swap", rcFrame, "UIDropDownMenuTemplate"); 
	swap:SetPoint('LEFT', swapTitle, 'RIGHT', -15, -3)
	UIDropDownMenu_SetWidth(swap, 195, 5)
	UIDropDownMenu_Initialize(swap, Swap_Initialise)

	DKIRunes_ConfigChange();
end


function DKIRunes_ConfigChange()
	DKIRunes_BlizzardOptions:Hide();
	DKIRunes_BlizzardOptions:Show();
end

function DKIRunes_Lock(checked)
	DKIRunesFrame:SetMovable(checked)
	DKIRunesFrame:EnableMouse(checked)
	DKIRunes_Saved.point, relativeTo, DKIRunes_Saved.parentPoint, DKIRunes_Saved.x, DKIRunes_Saved.y = DKIRunesFrame:GetPoint();
end


function Graphics_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "none"; 
	info.value = 0; 
	info.func = Graphics_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.artStyle == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Ebon Blade"; 
	info.value = 1; 
	info.func = Graphics_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.artStyle == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Simple Box"; 
	info.value = 2; 
	info.func = Graphics_OnClick;
	info.owner = self;
	info.checked = (DKIRunes_Saved.artStyle == 2); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(RuneFrameGraphics, DKIRunes_Saved.artStyle)
end

function Graphics_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.artStyle = self.value;
	DKIRunes_UpdateUI();
end

function RunicBar0_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "none"; 
	info.value = 0; 
	info.func = RunicBar0_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar0 == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Runic Power"; 
	info.value = 1; 
	info.func = RunicBar0_OnClick 
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar0 == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Health Points"; 
	info.value = 2; 
	info.func = RunicBar0_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar0 == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Anti-Health Points"; 
	info.value = 3; 
	info.func = RunicBar0_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar0 == 3); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(RunicBar0, DKIRunes_Saved.bar0)
end

function RunicBar0_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.bar0 = self.value;
	RunicBar0_Set(self.value)
	DKIRunes_UpdateUI();
end

function RunicBar0_Set(bar)
	if(bar == 0) then
		EbonBlade_Bar_0:Hide();
		Horizontal_Bar_0:Hide();
		Vertical_Bar_0:Hide();
	else
		EbonBlade_Bar_0:Show();
		Horizontal_Bar_0:Show();
		Vertical_Bar_0:Show();
	end
	if(bar == 2) then
		EbonBlade_Bar_0:SetTexture(0.0,1.0,0.0,0.75)
		Horizontal_Bar_0:SetTexture(0.0,1.0,0.0,0.1)
		Vertical_Bar_0:SetTexture(0.0,1.0,0.0,0.1)
	elseif(bar == 3) then
		EbonBlade_Bar_0:SetTexture(1.0,0.0,0.0,0.75)
		Horizontal_Bar_0:SetTexture(1.0,0.0,0.0,0.1)
		Vertical_Bar_0:SetTexture(1.0,0.0,0.0,0.1)
	else
		EbonBlade_Bar_0:SetTexture(0.0,0.82,1.0,0.75)
		Horizontal_Bar_0:SetTexture(0.0,0.82,1.0,0.1)
		Vertical_Bar_0:SetTexture(0.0,0.82,1.0,0.1)
	end
end

function RunicBar1_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "none"; 
	info.value = 0; 
	info.func = RunicBar1_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.bar1 == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Runic Power"; 
	info.value = 1; 
	info.func = RunicBar1_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar1 == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Health Points"; 
	info.value = 2;
	info.func = RunicBar1_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar1 == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Anti-Health Points"; 
	info.value = 3; 
	info.func = RunicBar1_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.bar1 == 3); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(RunicBar1, DKIRunes_Saved.bar1)
end

function RunicBar1_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.bar1 = self.value;
	RunicBar1_Set(self.value)
	DKIRunes_UpdateUI();
end

function RunicBar1_Set(bar)
	if(bar == 0) then
		EbonBlade_Bar_1:Hide();
		Horizontal_Bar_1:Hide();
		Vertical_Bar_1:Hide();
	else
		EbonBlade_Bar_1:Show();
		Horizontal_Bar_1:Show();
		Vertical_Bar_1:Show();
	end
	if(bar == 2) then
		EbonBlade_Bar_1:SetTexture(0.0,1.0,0.0,0.75)
		Horizontal_Bar_1:SetTexture(0.0,1.0,0.0,0.1)
		Vertical_Bar_1:SetTexture(0.0,1.0,0.0,0.1)
	elseif(bar == 3) then
		EbonBlade_Bar_1:SetTexture(1.0,0.0,0.0,0.75)
		Horizontal_Bar_1:SetTexture(1.0,0.0,0.0,0.1)
		Vertical_Bar_1:SetTexture(1.0,0.0,0.0,0.1)
	else
		EbonBlade_Bar_1:SetTexture(0.0,0.82,1.0,0.75)
		Horizontal_Bar_1:SetTexture(0.0,0.82,1.0,0.1)
		Vertical_Bar_1:SetTexture(0.0,0.82,1.0,0.1)
	end
end

function HeroOrigin_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "Port"; 
	info.value = -1; 
	info.func = HeroOrigin_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.heroOrigin == -1); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Starboard"; 
	info.value = 1; 
	info.func = HeroOrigin_OnClick
	info.owner = self;
	info.checked = (DKIRunes_Saved.heroOrigin == 1); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(HeroOrigin, DKIRunes_Saved.heroOrigin)
end

function HeroOrigin_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.heroOrigin = self.value;
	DKIRunes_UpdateUI();
end

function Slider_ValueChanged(self, value)
	DKIRunes_Saved.scale = value;
	DKIRunes_UpdateUI();
end

function HeroSlider_ValueChanged(self, value)
	DKIRunes_Saved.heroSlide = value;
	DKIRunes_UpdateUI();
end

function CounterSlider_ValueChanged(self, value)
	DKIRunes_Saved.counterScale = value;
	FixRPCounterLocation();
	DKIRunes_UpdateUI();
end

function BR1_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	for i=0, 5 do
		local offset = 60-i*24
		info.text = "Slot "..(i+1); 
		info.value = offset; 
		info.func = BR1_OnClick
		info.owner = self;
		info.checked = (DKIRunes_Saved.runeLayout[1] == offset); 
		UIDropDownMenu_AddButton(info, level); 
	end

	UIDropDownMenu_SetSelectedValue(BR1Slot, DKIRunes_Saved.runeLayout[1])
end

function BR1_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.runeLayout[1] = self.value;
	DKIRunes_UpdateUI();
end

function BR2_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	for i=0, 5 do
		local offset = 60-i*24
		info.text = "Slot "..(i+1); 
		info.value = offset; 
		info.func = BR2_OnClick
		info.owner = self;
		info.checked = (DKIRunes_Saved.runeLayout[2] == offset); 
		UIDropDownMenu_AddButton(info, level); 
	end

	UIDropDownMenu_SetSelectedValue(BR2Slot, DKIRunes_Saved.runeLayout[2])
end

function BR2_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.runeLayout[2] = self.value;
	DKIRunes_UpdateUI();
end

function FR1_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	for i=0, 5 do
		local offset = 60-i*24
		info.text = "Slot "..(i+1); 
		info.value = offset; 
		info.func = FR1_OnClick
		info.owner = self;
		info.checked = (DKIRunes_Saved.runeLayout[5] == offset); 
		UIDropDownMenu_AddButton(info, level); 
	end

	UIDropDownMenu_SetSelectedValue(FR1Slot, DKIRunes_Saved.runeLayout[5])
end

function FR1_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.runeLayout[5] = self.value;
	DKIRunes_UpdateUI();
end

function FR2_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	for i=0, 5 do
		local offset = 60-i*24
		info.text = "Slot "..(i+1); 
		info.value = offset; 
		info.func = FR2_OnClick
		info.owner = self;
		info.checked = (DKIRunes_Saved.runeLayout[6] == offset); 
		UIDropDownMenu_AddButton(info, level); 
	end

	UIDropDownMenu_SetSelectedValue(FR2Slot, DKIRunes_Saved.runeLayout[6])
end

function FR2_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.runeLayout[6] = self.value;
	DKIRunes_UpdateUI();
end

function UH1_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	for i=0, 5 do
		local offset = 60-i*24
		info.text = "Slot "..(i+1); 
		info.value = offset; 
		info.func = UH1_OnClick
		info.owner = self;
		info.checked = (DKIRunes_Saved.runeLayout[3] == offset); 
		UIDropDownMenu_AddButton(info, level); 
	end

	UIDropDownMenu_SetSelectedValue(UH1Slot, DKIRunes_Saved.runeLayout[3])
end

function UH1_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.runeLayout[3] = self.value;
	DKIRunes_UpdateUI();
end

function UH2_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	for i=0, 5 do
		local offset = 60-i*24
		info.text = "Slot "..(i+1); 
		info.value = offset; 
		info.func = UH2_OnClick
		info.owner = self;
		info.checked = (DKIRunes_Saved.runeLayout[4] == offset); 
		UIDropDownMenu_AddButton(info, level); 
	end

	UIDropDownMenu_SetSelectedValue(UH2Slot, DKIRunes_Saved.runeLayout[4])
end

function UH2_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.runeLayout[4] = self.value;
	DKIRunes_UpdateUI();
end

function DeadRune_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "at double cooldown distance"; 
	info.value = 0; 
	info.func = DeadRune_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.deadRune == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "at cooldown distance until cooldown"; 
	info.value = 1; 
	info.func = DeadRune_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.deadRune == 1); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "frozen until cooldown"; 
	info.value = 2;
	info.func = DeadRune_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.deadRune == 2); 
	UIDropDownMenu_AddButton(info, level); 

	UIDropDownMenu_SetSelectedValue(DeadRune, DKIRunes_Saved.deadRune)
end

function DeadRune_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.deadRune = self.value;
end

function Swap_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "stay in their slot"; 
	info.value = 0; 
	info.func = Swap_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.swap == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "move towards the lower slot"; 
	info.value = 1; 
	info.func = Swap_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.swap == 1); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "move towards the higher slot"; 
	info.value = 2;
	info.func = Swap_OnClick
	info.owner = self; 
	info.checked = (DKIRunes_Saved.swap == 2); 
	UIDropDownMenu_AddButton(info, level); 

	UIDropDownMenu_SetSelectedValue(Swap, DKIRunes_Saved.swap)
end

function Swap_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIRunes_Saved.swap = self.value;
end

