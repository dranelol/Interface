
--load slash commands
SlashCmdList["DKIDISEASES"] = function()
	InterfaceOptionsFrame_OpenToCategory('DKIDiseases')
end
SLASH_DKIDISEASES1 = "/dkidiseases"
SLASH_DKIDISEASES2 = "/dkid"

function DKIDiseases_populateBlizzardOptions()
	local frame = CreateFrame("frame", "DKIDiseases_BlizzardOptions", UIParent);
	frame.name = "DKIDiseases";
	frame:SetWidth(300);
	frame:SetHeight(200);
	frame:Show();
	InterfaceOptions_AddCategory(frame);

	local reset = CreateFrame("Button", "DKIDiseasesReset", frame, "OptionsButtonTemplate");
	reset:SetText("Reset to Default")
	reset:SetScript('OnClick', DKIDiseases_Reset)
	reset:SetWidth(130);
	reset:SetHeight(24);
	reset:GetFontString():SetPoint("TOP", reset, "TOP", 0, -6)
	reset:SetPoint("TOPLEFT", 10, -20)

	local lock = CreateFrame("CheckButton", "DKIDiseasesFrameLock", frame, "OptionsCheckButtonTemplate");
	_G[lock:GetName().."Text"]:SetText("Unlock Diseases");
	lock:SetScript('OnShow', function(self) self:SetChecked(diseaseIcon[0][0]:IsMouseEnabled()) end)
	lock:SetScript('OnClick', function(self) DKIDiseases_Lock(self:GetChecked()) end)
	lock:SetPoint('LEFT', reset, 'RIGHT', 15, -2)

	local rotate = CreateFrame("Button", "RotateButton", frame, "OptionsButtonTemplate");
	rotate:SetText("Rotate")
	rotate:SetScript('OnClick', DKIDiseases_Rotate)
	rotate:SetWidth(100);
	rotate:SetHeight(24);
	rotate:GetFontString():SetPoint("TOP", rotate, "TOP", 0, -6)
	rotate:SetPoint('LEFT', lock, 'RIGHT', 115, 2)

	local fade = CreateFrame("CheckButton", "DKIDAgroFade", frame, "OptionsCheckButtonTemplate");
	_G[fade:GetName().."Text"]:SetText("Fade out of Combat");
	fade:SetScript('OnShow', function(self) self:SetChecked(DKIDiseases_Saved.fade) end)
	fade:SetScript('OnClick', function(self) DKIDiseases_Saved.fade = self:GetChecked() end)
	fade:SetPoint('TOPLEFT', reset, 'BOTTOMLEFT', 0, -10)

	local demo0 = CreateFrame("Button", "Demo0Button", frame, "OptionsButtonTemplate");
	demo0:SetText("Disease Demo")
	demo0:SetScript('OnClick', function() DKIDiseases_Demo0() end)
	demo0:SetWidth(120);
	demo0:SetHeight(24);
	demo0:GetFontString():SetPoint("TOP", demo0, "TOP", 0, -6)
	demo0:SetPoint('LEFT', fade, 'RIGHT', 125, 2)

--[[	local demo1 = CreateFrame("Button", "Demo1Button", frame, "OptionsButtonTemplate");
	demo1:SetText("Pestilence Demo")
	demo1:SetScript('OnClick', function() DKIDiseases_Demo1() end)
	demo1:SetWidth(120);
	demo1:SetHeight(24);
	demo1:GetFontString():SetPoint("TOP", demo1, "TOP", 0, -6)
	demo1:SetPoint('LEFT', demo0, 'RIGHT', 0, 0)

	local optTitle = frame:CreateFontString("optTitleString","ARTWORK","GameTooltipHeaderText");
	optTitle:SetText("Optional Tracking")
	optTitle:SetPoint('TOPLEFT', DKIDiseasesReset, 'BOTTOMLEFT', 0, -40)

	local sfCheck = CreateFrame("CheckButton", "SFCheck", frame, "OptionsCheckButtonTemplate");
	_G[sfCheck:GetName().."Text"]:SetText("Weakened Blows");
	sfCheck:SetScript('OnShow', function(self) self:SetChecked(DKIDiseases_Saved.sf) end)
	sfCheck:SetScript('OnClick', function(self) DKIDiseases_Saved.sf = self:GetChecked();DKIDiseases_Talents_Check() end)
	sfCheck:SetPoint('TOPLEFT', optTitle, 'BOTTOMLEFT', 20, -5)
--]]

	local ringTitle = frame:CreateFontString("ringTitleString","ARTWORK","GameTooltipHeaderText");
	ringTitle:SetText("Disease Rings and Icons")
	ringTitle:SetPoint('TOPLEFT', DKIDiseasesReset, 'BOTTOMLEFT', 0, -90)

	local iconScaleTitle = frame:CreateFontString("IconScaleTitleString","ARTWORK","GameFontNormal");
	iconScaleTitle:SetText("Scale")
	iconScaleTitle:SetPoint('TOPLEFT', ringTitle, 'BOTTOMLEFT', 5, -15)

	local iconScale = CreateFrame("Slider", "IconScaleSlider", frame, "OptionsSliderTemplate")
	iconScale:SetMinMaxValues(0.2, 2.0)
	iconScale:SetValueStep(0.05)
	iconScale:SetWidth(60)
	_G['IconScaleSliderLow']:SetText("small")
	_G['IconScaleSliderHigh']:SetText("large")
	iconScale:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.iconScale) end)
	iconScale:SetScript('OnValueChanged', IconScaleSlider_ValueChanged)
	iconScale:SetPoint('LEFT', IconScaleTitleString, 'RIGHT', 10, 0)

	local ringTrackTitle = frame:CreateFontString("ringTrackTitleString","ARTWORK","GameFontNormal");
	ringTrackTitle:SetText("Ring\nTrack")
	ringTrackTitle:SetPoint('TOPLEFT', ringTitle, 'BOTTOMLEFT', 0, -45)

	ringTrack = CreateFrame("Frame", "RingTrack", frame, "UIDropDownMenuTemplate"); 
	ringTrack:SetPoint('LEFT', ringTrackTitleString, 'RIGHT', -10, -2)
	UIDropDownMenu_Initialize(ringTrack, RingTrack_Initialise)

	local ringTrackTitleSil = frame:CreateFontString("ringTrackTitleSil","ARTWORK","GameFontNormal");
	ringTrackTitleSil:SetText("Ring\nSilhouette")
	ringTrackTitleSil:SetPoint('LEFT', ringTrackTitleString, 'RIGHT', 145, 0)

	ringTrackSil = CreateFrame("Frame", "RingTrackSil", frame, "UIDropDownMenuTemplate"); 
	ringTrackSil:SetPoint('LEFT', ringTrackTitleSil, 'RIGHT', -10, -2)
	UIDropDownMenu_Initialize(ringTrackSil, RingTrackSil_Initialise)

	local iconTrackTitle = frame:CreateFontString("iconTrackTitleString","ARTWORK","GameFontNormal");
	iconTrackTitle:SetText("Icon\nTrack")
	iconTrackTitle:SetPoint('TOPLEFT', ringTitle, 'BOTTOMLEFT', 0, -75)

	iconTrack = CreateFrame("Frame", "IconTrack", frame, "UIDropDownMenuTemplate"); 
	iconTrack:SetPoint('LEFT', iconTrackTitle, 'RIGHT', -10, -2)
	UIDropDownMenu_Initialize(iconTrack, IconTrack_Initialise)

	local iconTrackTitleSil = frame:CreateFontString("iconTrackTitleSil","ARTWORK","GameFontNormal");
	iconTrackTitleSil:SetText("Icon\nSilhouette")
	iconTrackTitleSil:SetPoint('LEFT', iconTrackTitleString, 'RIGHT', 145, 0)

	iconTrackSil = CreateFrame("Frame", "IconTrackSil", frame, "UIDropDownMenuTemplate"); 
	iconTrackSil:SetPoint('LEFT', iconTrackTitleSil, 'RIGHT', -10, -2)
	UIDropDownMenu_Initialize(iconTrackSil, IconTrackSil_Initialise)

	local bladeTitle = frame:CreateFontString("bladeTitleString","ARTWORK","GameTooltipHeaderText");
	bladeTitle:SetText("Disease Blades and Bars")
	bladeTitle:SetPoint('TOPLEFT', iconTrackTitleString, 'BOTTOMLEFT', 0, -15)

	local barScaleTitle = frame:CreateFontString("BarScaleTitleString","ARTWORK","GameFontNormal");
	barScaleTitle:SetText("Scale")
	barScaleTitle:SetPoint('TOPLEFT', bladeTitle, 'BOTTOMLEFT', 5, -15)

	local barScale = CreateFrame("Slider", "BarScaleSlider", frame, "OptionsSliderTemplate")
	barScale:SetMinMaxValues(0.2, 2.0)
	barScale:SetValueStep(0.05)
	barScale:SetWidth(60)
	_G['BarScaleSliderLow']:SetText("small")
	_G['BarScaleSliderHigh']:SetText("large")
	barScale:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.barScale) end)
	barScale:SetScript('OnValueChanged', BarScaleSlider_ValueChanged)
	barScale:SetPoint('LEFT', BarScaleTitleString, 'RIGHT', 10, 0)

	local barLengthTitle = frame:CreateFontString("BarLengthTitleString","ARTWORK","GameFontNormal");
	barLengthTitle:SetText("Length")
	barLengthTitle:SetPoint('LEFT', BarScaleTitleString, 'RIGHT', 90, 0)

	local barLength = CreateFrame("Slider", "BarLengthSlider", frame, "OptionsSliderTemplate")
	barLength:SetMinMaxValues(30, 255)
	barLength:SetValueStep(5)
	barLength:SetWidth(60)
	_G['BarLengthSliderLow']:SetText("short")
	_G['BarLengthSliderHigh']:SetText("long")
	barLength:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.barLength) end)
	barLength:SetScript('OnValueChanged', BarLengthSlider_ValueChanged)
	barLength:SetPoint('LEFT', BarScaleSlider, 'RIGHT', 75, 0)

	local barOffsetTitle = frame:CreateFontString("BarOffsetTitleString","ARTWORK","GameFontNormal");
	barOffsetTitle:SetText("Offset")
	barOffsetTitle:SetPoint('LEFT', BarLengthTitleString, 'RIGHT', 95, 0)

	local barOffset = CreateFrame("Slider", "BarOffsetSlider", frame, "OptionsSliderTemplate")
	barOffset:SetMinMaxValues(0, 60)
	barOffset:SetValueStep(1)
	barOffset:SetWidth(60)
	_G['BarOffsetSliderLow']:SetText("center")
	_G['BarOffsetSliderHigh']:SetText("away")
	barOffset:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.barOffset) end)
	barOffset:SetScript('OnValueChanged', BarOffsetSlider_ValueChanged)
	barOffset:SetPoint('LEFT', BarLengthSlider, 'RIGHT', 70, 0)

	local bladeTrackTitle = frame:CreateFontString("bladeTrackTitleString","ARTWORK","GameFontNormal");
	bladeTrackTitle:SetText("Blade\nTrack")
	bladeTrackTitle:SetPoint('TOPLEFT', bladeTitle, 'BOTTOMLEFT', 0, -45)

	bladeTrack = CreateFrame("Frame", "BladeTrack", frame, "UIDropDownMenuTemplate"); 
	bladeTrack:SetPoint('LEFT', bladeTrackTitle, 'RIGHT', -10, -2)
	UIDropDownMenu_Initialize(bladeTrack, BladeTrack_Initialise)

	local bladeAlphaTitle = frame:CreateFontString("BladeAlphaTitleString","ARTWORK","GameFontNormal");
	bladeAlphaTitle:SetText("Blade\nAlpha")
	bladeAlphaTitle:SetPoint('LEFT', bladeTrackTitleString, 'RIGHT', 170, -2)

	local bladeAlpha = CreateFrame("Slider", "BladeAlphaSlider", frame, "OptionsSliderTemplate")
	bladeAlpha:SetMinMaxValues(0.1, 1.0)
	bladeAlpha:SetValueStep(0.1)
	bladeAlpha:SetWidth(60)
	_G['BladeAlphaSliderLow']:SetText("faded")
	_G['BladeAlphaSliderHigh']:SetText("solid")
	bladeAlpha:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.bladeAlpha) end)
	bladeAlpha:SetScript('OnValueChanged', BladeAlphaSlider_ValueChanged)
	bladeAlpha:SetPoint('LEFT', BladeAlphaTitleString, 'RIGHT', 10, 0)

	local barTrackTitle = frame:CreateFontString("barTrackTitleString","ARTWORK","GameFontNormal");
	barTrackTitle:SetText("Bar\nTrack")
	barTrackTitle:SetPoint('TOPLEFT', bladeTitle, 'BOTTOMLEFT', 3, -75)

	barTrack = CreateFrame("Frame", "BarTrack", frame, "UIDropDownMenuTemplate"); 
	barTrack:SetPoint('LEFT', barTrackTitle, 'RIGHT', -10, -2)
	UIDropDownMenu_Initialize(barTrack, BarTrack_Initialise)

	local barAlphaTitle = frame:CreateFontString("BarAlphaTitleString","ARTWORK","GameFontNormal");
	barAlphaTitle:SetText("Bar\nAlpha")
	barAlphaTitle:SetPoint('LEFT', barTrackTitleString, 'RIGHT', 173, -2)

	local barAlpha = CreateFrame("Slider", "BarAlphaSlider", frame, "OptionsSliderTemplate")
	barAlpha:SetMinMaxValues(0.1, 1.0)
	barAlpha:SetValueStep(0.1)
	barAlpha:SetWidth(60)
	_G['BarAlphaSliderLow']:SetText("faded")
	_G['BarAlphaSliderHigh']:SetText("solid")
	barAlpha:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.barAlpha) end)
	barAlpha:SetScript('OnValueChanged', BarAlphaSlider_ValueChanged)
	barAlpha:SetPoint('LEFT', BarAlphaTitleString, 'RIGHT', 10, 0)

	-- Timer Child Menu
	local timerFrame = CreateFrame("frame", "DKIDiseases_RuneOptions", frame);
	timerFrame.parent = "DKIDiseases";
	timerFrame.name = "Disease Timers";
	timerFrame:SetWidth(300);
	timerFrame:SetHeight(200);
	timerFrame:Hide();
	InterfaceOptions_AddCategory(timerFrame);

	local timerTitle = timerFrame:CreateFontString("timerTitleString","ARTWORK","GameTooltipHeaderText");
	timerTitle:SetText("Disease Timers")
	timerTitle:SetPoint('TOPLEFT', 10, -20)

	local diseaseTimerLocTitle = timerFrame:CreateFontString("diseaseTimerLocTitleString","ARTWORK","GameFontNormal");
	diseaseTimerLocTitle:SetText("Disease")
	diseaseTimerLocTitle:SetPoint('TOPLEFT', timerTitle, 'BOTTOMLEFT', 58, -12)

	diseaseTimerLoc = CreateFrame("Frame", "DKIDTimerLoc", timerFrame, "UIDropDownMenuTemplate"); 
	diseaseTimerLoc:SetPoint('TOPLEFT', timerTitle, 'BOTTOMLEFT', 99, -5)
	UIDropDownMenu_Initialize(diseaseTimerLoc, DKIDTimerLoc_Initialise)

	local timerScaleSliderTitle = timerFrame:CreateFontString("TimerScaleSliderString","ARTWORK","GameFontNormal");
	timerScaleSliderTitle:SetText("Timer Scale")
	timerScaleSliderTitle:SetPoint('LEFT', diseaseTimerLocTitleString, 'RIGHT', 170, 0)

	local timerScaleSlider = CreateFrame("Slider", "TimerScaleSlider", timerFrame, "OptionsSliderTemplate")
	timerScaleSlider:SetMinMaxValues(0.2, 3.0)
	timerScaleSlider:SetValueStep(0.05)
	timerScaleSlider:SetWidth(60)
	_G['TimerScaleSliderLow']:SetText("small")
	_G['TimerScaleSliderHigh']:SetText("large")
	timerScaleSlider:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.timerScale) end)
	timerScaleSlider:SetScript('OnValueChanged', TimerScaleSlider_ValueChanged)
	timerScaleSlider:SetPoint('LEFT', TimerScaleSliderString, 'RIGHT', 10, 0)

	local pestilenceTimerLocTitle = timerFrame:CreateFontString("pestilenceTimerLocTitle","ARTWORK","GameFontNormal");
	pestilenceTimerLocTitle:SetText("Disease Debuffs")
	pestilenceTimerLocTitle:SetPoint('TOPLEFT', timerTitle, 'BOTTOMLEFT', 4, -41)

	pestilenceTimerLoc = CreateFrame("Frame", "DKIPTimerLoc", timerFrame, "UIDropDownMenuTemplate"); 
	pestilenceTimerLoc:SetPoint('LEFT', pestilenceTimerLocTitle, 'RIGHT', -7, -3)
	UIDropDownMenu_Initialize(pestilenceTimerLoc, DKIPTimerLoc_Initialise)

	local timerOffsetSliderTitle = timerFrame:CreateFontString("TimerOffsetSliderString","ARTWORK","GameFontNormal");
	timerOffsetSliderTitle:SetText("Timer Offset")
	timerOffsetSliderTitle:SetPoint('TOPLEFT', timerScaleSliderTitle, 'BOTTOMLEFT', -5, -20)

	local timerOffsetSlider = CreateFrame("Slider", "TimerOffsetSlider", timerFrame, "OptionsSliderTemplate")
	timerOffsetSlider:SetMinMaxValues(-30, 30)
	timerOffsetSlider:SetValueStep(1)
	timerOffsetSlider:SetWidth(60)
	_G['TimerOffsetSliderLow']:SetText("small")
	_G['TimerOffsetSliderHigh']:SetText("large")
	timerOffsetSlider:SetScript('OnShow', function(self) self:SetValue(DKIDiseases_Saved.timerOffset) end)
	timerOffsetSlider:SetScript('OnValueChanged', TimerOffsetSlider_ValueChanged)
	timerOffsetSlider:SetPoint('LEFT', TimerOffsetSliderString, 'RIGHT', 10, 0)

	DKIDiseases_ConfigChange();
end


function DKIDiseases_ConfigChange()
	DKIDiseases_BlizzardOptions:Hide();
	DKIDiseases_BlizzardOptions:Show();
end

function DKIDiseases_Lock(checked)
	local relativeTo;
	for i=0, 3 do
		diseaseIcon[i][0]:SetMovable(checked)
		diseaseIcon[i][0]:EnableMouse(checked)
	end
end

function DKIDiseases_Demo0()
	DKIDiseases_UpdateDemoIconsAndBars(GetTime(), nil); 
end

--[[
function DKIDiseases_Demo1()
	DKIDiseases_UpdateDemoIconsAndBars(nil, GetTime()); 
end
--]]

function DKIDStrataSlider_ValueChanged(self, value)
	DKIDiseases_Saved.strata = value;
	DKIDiseases_UpdateUI();
end

function IconScaleSlider_ValueChanged(self, value)
	DKIDiseases_Saved.iconScale = value;
	DKIDiseases_UpdateUI();
end

function BarScaleSlider_ValueChanged(self, value)
	DKIDiseases_Saved.barScale = value;
	DKIDiseases_UpdateUI();
end

function BarLengthSlider_ValueChanged(self, value)
	DKIDiseases_Saved.barLength = value;
	DKIDiseases_UpdateUI();
end

function BarOffsetSlider_ValueChanged(self, value)
	DKIDiseases_Saved.barOffset = value;
	DKIDiseases_UpdateUI();
end

function RingTrack_Initialise(self)
	level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "nothing"; 
	info.value = 0; 
	info.func = RingTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringTrack == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Diseases"; 
	info.value = 1; 
	info.func = RingTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringTrack == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Debuffs"; 
	info.value = 2; 
	info.func = RingTrack_OnClick
	info.owner = self 
	info.checked = (DKIDiseases_Saved.ringTrack == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "DoT Attack Power"; 
	info.value = 3; 
	info.func = RingTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringTrack == 3); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Active"; 
	info.value = 4; 
	info.func = RingTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringTrack == 4); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Debuffs Active"; 
	info.value = 5; 
	info.func = RingTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringTrack == 5); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(RingTrack, DKIDiseases_Saved.ringTrack)
end

function RingTrack_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.ringTrack = self.value;
	DKIDiseases_UpdateUI();
end

function RingTrackSil_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "never"; 
	info.value = 0; 
	info.func = RingTrackSil_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringSil == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "While Tracking"; 
	info.value = 1; 
	info.func = RingTrackSil_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.ringSil == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Always"; 
	info.value = 2; 
	info.func = RingTrackSil_OnClick
	info.owner = self 
	info.checked = (DKIDiseases_Saved.ringSil == 2); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(RingTrackSil, DKIDiseases_Saved.ringSil)
end

function RingTrackSil_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.ringSil = self.value;
	DKIDiseases_UpdateUI();
end

function IconTrack_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "nothing"; 
	info.value = 0; 
	info.func = IconTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconTrack == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Diseases"; 
	info.value = 1; 
	info.func = IconTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconTrack == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Debuffs"; 
	info.value = 2; 
	info.func = IconTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconTrack == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "DoT Attack Power"; 
	info.value = 3; 
	info.func = IconTrack_OnClick 
	info.owner = self 
	info.checked = (DKIDiseases_Saved.iconTrack == 3); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Active"; 
	info.value = 4; 
	info.func = IconTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconTrack == 4); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Debuffs Active"; 
	info.value = 5; 
	info.func = IconTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconTrack == 5); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(IconTrack, DKIDiseases_Saved.iconTrack)
end

function IconTrack_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.iconTrack = self.value;
	DKIDiseases_UpdateUI();
end

function IconTrackSil_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "never"; 
	info.value = 0; 
	info.func = IconTrackSil_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconSil == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "While Tracking"; 
	info.value = 1; 
	info.func = IconTrackSil_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconSil == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Always"; 
	info.value = 2; 
	info.func = IconTrackSil_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.iconSil == 2); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(IconTrackSil, DKIDiseases_Saved.iconSil)
end

function IconTrackSil_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.iconSil = self.value;
	DKIDiseases_UpdateUI();
end

function BladeTrack_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "nothing"; 
	info.value = 0; 
	info.func = BladeTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.bladeTrack == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Diseases"; 
	info.value = 1; 
	info.func = BladeTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.bladeTrack == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Debuffs"; 
	info.value = 2; 
	info.func = BladeTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.bladeTrack == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "DoT Attack Power"; 
	info.value = 3; 
	info.func = BladeTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.bladeTrack == 3); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(BladeTrack, DKIDiseases_Saved.bladeTrack)
end

function BladeTrack_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.bladeTrack = self.value;
	DKIDiseases_UpdateUI();
end

function BladeAlphaSlider_ValueChanged(self, value)
	DKIDiseases_Saved.bladeAlpha = value;
	DKIDiseases_UpdateUI();
end

function BarTrack_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "nothing"; 
	info.value = 0; 
	info.func = BarTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.barTrack == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Diseases"; 
	info.value = 1; 
	info.func = BarTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.barTrack == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Disease Debuffs"; 
	info.value = 2; 
	info.func = BarTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.barTrack == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "DoT Attack Power"; 
	info.value = 3; 
	info.func = BarTrack_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.barTrack == 3); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(BarTrack, DKIDiseases_Saved.barTrack)
end

function BarTrack_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.barTrack = self.value;
	DKIDiseases_UpdateUI();
end

function BarAlphaSlider_ValueChanged(self, value)
	DKIDiseases_Saved.barAlpha = value;
	DKIDiseases_UpdateUI();
end

function DKIDTimerLoc_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "none"; 
	info.value = 0; 
	info.func = DKIDTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.diseaseTimerLoc == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Center"; 
	info.value = 1; 
	info.func = DKIDTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.diseaseTimerLoc == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Above"; 
	info.value = 2; 
	info.func = DKIDTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.diseaseTimerLoc == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Right"; 
	info.value = 3; 
	info.func = DKIDTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.diseaseTimerLoc == 3); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Below"; 
	info.value = 4; 
	info.func = DKIDTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.diseaseTimerLoc == 4); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Left"; 
	info.value = 5; 
	info.func = DKIDTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.diseaseTimerLoc == 5); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(DKIDTimerLoc, DKIDiseases_Saved.diseaseTimerLoc)
	FixDKIDTimerLocation(2, DKIDiseases_Saved.diseaseTimerLoc);
end

function DKIDTimerLoc_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.diseaseTimerLoc = self.value;
	FixDKIDTimerLocation(2, DKIDiseases_Saved.diseaseTimerLoc);
end

function DKIPTimerLoc_Initialise(self)
	local level = level or 1
	 
	local info = UIDropDownMenu_CreateInfo();
	 
	info.text = "none"; 
	info.value = 0; 
	info.func = DKIPTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.pestilenceTimerLoc == 0); 
	UIDropDownMenu_AddButton(info, level); 
	 
	info.text = "Center"; 
	info.value = 1; 
	info.func = DKIPTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.pestilenceTimerLoc == 1); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Above"; 
	info.value = 2; 
	info.func = DKIPTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.pestilenceTimerLoc == 2); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Right"; 
	info.value = 3; 
	info.func = DKIPTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.pestilenceTimerLoc == 3); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Below"; 
	info.value = 4; 
	info.func = DKIPTimerLoc_OnClick
	info.owner = self
	info.checked = (DKIDiseases_Saved.pestilenceTimerLoc == 4); 
	UIDropDownMenu_AddButton(info, level);
	 
	info.text = "Left"; 
	info.value = 5; 
	info.func = DKIPTimerLoc_OnClick
	info.owner =self
	info.checked = (DKIDiseases_Saved.pestilenceTimerLoc == 5); 
	UIDropDownMenu_AddButton(info, level);

	UIDropDownMenu_SetSelectedValue(DKIPTimerLoc, DKIDiseases_Saved.pestilenceTimerLoc);
	FixDKIDTimerLocation(3, DKIDiseases_Saved.pestilenceTimerLoc);
end

function DKIPTimerLoc_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	DKIDiseases_Saved.pestilenceTimerLoc = self.value;
	FixDKIDTimerLocation(3, DKIDiseases_Saved.pestilenceTimerLoc);
end

function TimerScaleSlider_ValueChanged(self, value)
	DKIDiseases_Saved.timerScale = value;
	FixDKIDTimerLocation(2, DKIDiseases_Saved.diseaseTimerLoc);
	FixDKIDTimerLocation(3, DKIDiseases_Saved.pestilenceTimerLoc);
end

function TimerOffsetSlider_ValueChanged(self, value)
	DKIDiseases_Saved.timerOffset = value;
	FixDKIDTimerLocation(2, DKIDiseases_Saved.diseaseTimerLoc);
	FixDKIDTimerLocation(3, DKIDiseases_Saved.pestilenceTimerLoc);
end