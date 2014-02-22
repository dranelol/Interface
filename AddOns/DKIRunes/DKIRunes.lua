
local RUNETYPE_BLOOD = 1;
local RUNETYPE_UNHOLY = 2;
local RUNETYPE_UNHOLY2 = 22;	--Alternate Green Runes
local RUNETYPE_FROST = 3;
local RUNETYPE_DEATH = 4;
local RUNETYPE_DEATH2 = 42; --Alternate Purple Runes

local DKIRunes = {
	[RUNETYPE_BLOOD] = "Interface\\AddOns\\DKIRunes\\Blood_Runes",
	[RUNETYPE_FROST] = "Interface\\AddOns\\DKIRunes\\Frost_Runes",
	[RUNETYPE_UNHOLY] = "Interface\\AddOns\\DKIRunes\\Unholy_Runes",
	[RUNETYPE_DEATH] = "Interface\\AddOns\\DKIRunes\\Death_Runes",
};

local altDKIRunes = {
	[RUNETYPE_UNHOLY] = "Interface\\AddOns\\DKIRunes\\Unholy_Runes",
	[RUNETYPE_UNHOLY2] = "Interface\\AddOns\\DKIRunes\\Green_Unholy_Runes",
	[RUNETYPE_DEATH] = "Interface\\AddOns\\DKIRunes\\Death_Runes",
	[RUNETYPE_DEATH2] = "Interface\\AddOns\\DKIRunes\\Purple_Death_Runes",
};

local runeEnergizeTextures = {
	[RUNETYPE_BLOOD] = "Interface\\PlayerFrame\\Deathknight-Energize-Blood",
	[RUNETYPE_FROST] = "Interface\\PlayerFrame\\Deathknight-Energize-Frost",
	[RUNETYPE_UNHOLY] = "Interface\\PlayerFrame\\Deathknight-Energize-Unholy",
	[RUNETYPE_DEATH] = "Interface\\PlayerFrame\\Deathknight-Energize-White",
};

local DKIRuneLengths = {
	[RUNETYPE_BLOOD] = 69,
	[RUNETYPE_FROST] = 49,
	[RUNETYPE_UNHOLY] = 65,
	[RUNETYPE_DEATH] = 67,
};

local DKIRuneColors = {
	[RUNETYPE_BLOOD]	= {1, 0, 0},
	[RUNETYPE_FROST] = {0, 1, 1},
	[RUNETYPE_UNHOLY] = {0, 0.5, 0},
	[RUNETYPE_DEATH] = {0.8, 0.1, 1},
};

local altDKIRuneColors = {
	[RUNETYPE_UNHOLY2] = {0.06, 0.43, 0.12},
	[RUNETYPE_DEATH2] = {0.65, 0.11, 0.82},		
};

--HANZO: the array order is mixed up for readability: in-game, the rune order from left to right is 1,2,5,6,3,4 = blood, blood, frost, frost, unholy, unholy
local runeOffset = {
	[1] = 60,
	[2] = 36,
	[5] = 12,
	[6] = -12,
	[3] = -36,
	[4] = -60,
}

local runeBurst = {
	[1] = true,
	[2] = true,
	[5] = true,
	[6] = true,
	[3] = true,
	[4] = true,
};

local inCombat = 0;

DKIRunes_isRunicCorruptionOn = false;

-- Saved Variable
DKIRunes_Saved = {
	artStyle = 1;
	animate = true;
	cooldown = false;
	parent = "UIParent";
	point = "TOPLEFT";
	parentPoint = "TOPLEFT";
	x = -73;
	y = 25;
	scale = 0.8;
	rotate = 0;
	hero = false;
	heroSlide = 150;
	heroOrigin = 1;
	bar0 = 1;
	bar1 = 1;
	rpCounter = true;
	counterScale = 1;
	fade = false;
	empower = true;
	rc_blur = true;
};

function DKIRunes_LoadNewSavedVariables()
	if(DKIRunes_Saved.artStyle == nil) then
		DKIRunes_Saved.artStyle = 1;
	end
	if(DKIRunes_Saved.parent == nil) then
		DKIRunes_Saved.parent = "UIParent";
	end
	if(DKIRunes_Saved.point == nil) then
		DKIRunes_Saved.point = "TOPLEFT";
	end
	if(DKIRunes_Saved.parentPoint == nil) then
		DKIRunes_Saved.parentPoint = "TOPLEFT";
	end
	if(DKIRunes_Saved.x == nil) then
		DKIRunes_Saved.x = -73;
	end
	if(DKIRunes_Saved.y == nil) then
		DKIRunes_Saved.y = 25;
	end
	if(DKIRunes_Saved.scale == nil) then
		DKIRunes_Saved.scale = 0.8;
	end
	if(DKIRunes_Saved.rotate == nil) then
		DKIRunes_Saved.rotate = 0;
	end
	if(DKIRunes_Saved.heroSlide == nil) then
		DKIRunes_Saved.heroSlide = 150;
	end
	if(DKIRunes_Saved.heroOrigin == nil) then
		DKIRunes_Saved.heroOrigin = 1;
	end
	if(DKIRunes_Saved.bar0 == nil) then
		DKIRunes_Saved.bar0 = 1;
	end
	if(DKIRunes_Saved.bar1 == nil) then
		DKIRunes_Saved.bar1 = 1;
	end
	if(DKIRunes_Saved.counterScale == nil) then
		DKIRunes_Saved.counterScale = 1;
	end	
	if(DKIRunes_Saved.runeLayout == nil) then
		DKIRunes_Saved.runeLayout = {};
	end	
	if(DKIRunes_Saved.runeLayout[1] == nil) then
		DKIRunes_Saved.runeLayout[1] = 60;
	end	
	if(DKIRunes_Saved.runeLayout[2] == nil) then
		DKIRunes_Saved.runeLayout[2] = 36;
	end		
	if(DKIRunes_Saved.runeLayout[5] == nil) then
		DKIRunes_Saved.runeLayout[5] = 12;
	end	
	if(DKIRunes_Saved.runeLayout[6] == nil) then
		DKIRunes_Saved.runeLayout[6] = -12;
	end		
	if(DKIRunes_Saved.runeLayout[3] == nil) then
		DKIRunes_Saved.runeLayout[3] = -36;
	end	
	if(DKIRunes_Saved.runeLayout[4] == nil) then
		DKIRunes_Saved.runeLayout[4] = -60;
	end	
	if(DKIRunes_Saved.deadRune == nil) then
		DKIRunes_Saved.deadRune = 0;
	end	
	if(DKIRunes_Saved.swap == nil) then
		DKIRunes_Saved.swap = 0;
	end
	if(DKIRunes_Saved.empower == nil) then
		DKIRunes_Saved.empower = true;
	end
	if(DKIRunes_Saved.rc_blur == nil) then
		DKIRunes_Saved.rc_blur = true;
	end
end

function DKIRunes_Rune_OnLoad(self)
	self.fill = _G[self.GetName().."Fill"];
	self.shine = _G[self.GetName().."ShineTexture"];
	self.colorOrb = _G[self.GetName().."RuneColorGlow"];
end

function DKIRunes_OnLoad(self)
	
	self.runes = {};
		
	-- Disable rune frame if not a death knight.
	local _, class = UnitClass("player");
	
	if ( class ~= "DEATHKNIGHT" ) then
		self:Hide();
	else
		--Hide the default runes on the UI
		RuneButtonIndividual1:Hide();
		RuneButtonIndividual2:Hide();
		RuneButtonIndividual3:Hide();
		RuneButtonIndividual4:Hide();
		RuneButtonIndividual5:Hide();
		RuneButtonIndividual6:Hide();
	
		if ( GetCVarBool("predictedPower") and frequentUpdates ) then
			self:RegisterEvent("UNIT_RUNIC_POWER");
		end

		self:RegisterEvent("RUNE_POWER_UPDATE");
		self:RegisterEvent("RUNE_TYPE_UPDATE");
		self:RegisterEvent("RUNE_REGEN_UPDATE");
		self:RegisterEvent("PLAYER_ENTERING_WORLD");
		self:RegisterEvent("VARIABLES_LOADED");
		self:RegisterEvent("PLAYER_ENTER_COMBAT");
		self:RegisterEvent("PLAYER_LEAVE_COMBAT");
		self:RegisterEvent("PLAYER_DEAD");
		self:RegisterEvent("UNIT_AURA");

		self:SetScript("OnEvent", DKIRunes_OnEvent);
	end
	
end

function DKIRunes_OnEvent (self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Rune1:SetFrameLevel(4);
		Rune2:SetFrameLevel(4);

		Rune3Rune:SetTexture(DKIRunes[RUNETYPE_UNHOLY]);
		Rune4Rune:SetTexture(DKIRunes[RUNETYPE_UNHOLY]);
		Rune3:SetFrameLevel(4);
		Rune4:SetFrameLevel(4);

		Rune5Rune:SetTexture(DKIRunes[RUNETYPE_FROST]);
		Rune6Rune:SetTexture(DKIRunes[RUNETYPE_FROST]);
		Rune5:SetFrameLevel(4);
		Rune6:SetFrameLevel(4);

		DKIRunesHorizontalBackdrop:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
		DKIRunesHorizontalBackdrop:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
		DKIRunesVerticalBackdrop:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
		DKIRunesVerticalBackdrop:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);

		DKIRunicPower:SetFontObject(CombatLogFont)
		DKIRunicPower:SetTextColor(0.0,1.0,1.0,1.0)
		DKIRunesRunicPower:Show();

	elseif ( event == "VARIABLES_LOADED" ) then
		DKIRunes_LoadNewSavedVariables();
		DKIRunes_Rotate(false);
		RunicBar0_Set(DKIRunes_Saved.bar0)
		RunicBar1_Set(DKIRunes_Saved.bar1)
		DKIRunes_BarUpdate();
		DKIRunes_UpdateUI();
		DKIRunes_populateBlizzardOptions();
		DKIRunesFrame:SetAlpha(0.3);
		DKIRunes_inCombat2 = 0;
	
		DKIRunesFrame:EnableMouse(false)

	--Fires when the availability of one of the player's rune resources changes
	elseif ( event == "RUNE_POWER_UPDATE" ) then
		local runeIndex, isEnergize = ...;
		
		if(isEnergize and DKIRunes_Saved.empower) then
			_G["Rune"..runeIndex].energize:Play();
		end
		
	elseif ( event == "UNIT_AURA" ) then
		local name = UnitAura("player", "Runic Corruption");
		
		--ChatFrame1:AddMessage(" rc: "..tostring(name) );		
		
		-- gained runic corruption
		if  ( name ~= nil ) then
		
			if ( DKIRunes_isRunicCorruptionOn == false and DKIRunes_Saved.rc_blur ) then
				DKIRunes_isRunicCorruptionOn = true;
			end
		
		-- lost runic corruption
		else
		
			if ( DKIRunes_isRunicCorruptionOn == true ) then
				DKIRunes_isRunicCorruptionOn = false;
			end

		end
	
	elseif ( event == "PLAYER_ENTER_COMBAT" ) then
		inCombat = 1;
		DKIRunes_inCombat2 = 1;

	elseif ( event == "PLAYER_LEAVE_COMBAT" ) then
		inCombat = 0;
		DKIRunes_inCombat2 = 0;
		DKIRunes_isRunicCorruptionOn = false; -- HANZO; I'll put this safety here in the off-chance you disable it in the middle of runic corruption actually running.
		
	elseif ( event == "PLAYER_DEAD" ) then
		inCombat = 0;
		DKIRunes_inCombat2 = 0;
		DKIRunes_isRunicCorruptionOn = false; -- HANZO; I'll put this safety here in the off-chance you disable it in the middle of runic corruption actually running.

	end
	
end

-- Update All
function DKIRunes_UpdateUI()
	DKIRunes_SetLocation();
	DKIRunes_UpdateArt();
	DKIRunes_SetRuneOffsets();
end

-- Set Art
function DKIRunes_UpdateArt()
	DKIRunesFrame:SetScale(DKIRunes_Saved.scale);
	DKIRunesRunicPower:SetScale(DKIRunes_Saved.counterScale);
	DKIRunesEbonBlade:Hide();
	DKIRunesHorizontalBackdrop:Hide();
	DKIRunesVerticalBackdrop:Hide();

	if ( DKIRunes_Saved.artStyle == 1 ) then
		DKIRunesEbonBlade:Show();
		DKIRunesFrame:SetFrameLevel(0);
	elseif ( DKIRunes_Saved.artStyle == 2 ) then
		DKIRunesFrame:SetFrameLevel(2);
		if ( DKIRunes_Saved.rotate % 2 == 0 ) then
			DKIRunesHorizontalBackdrop:Show();
		else 
			DKIRunesVerticalBackdrop:Show();
		end
	else
		DKIRunesFrame:SetFrameLevel(2);
	end
	
	if ( DKIRunes_Saved.greenUnholy ) then
		DKIRunes[RUNETYPE_UNHOLY] = altDKIRunes[RUNETYPE_UNHOLY2]
	else
		DKIRunes[RUNETYPE_UNHOLY] = altDKIRunes[RUNETYPE_UNHOLY]
	end

	if ( DKIRunes_Saved.purpleDeath ) then
		DKIRunes[RUNETYPE_DEATH] = altDKIRunes[RUNETYPE_DEATH2]
	else
		DKIRunes[RUNETYPE_DEATH] = altDKIRunes[RUNETYPE_DEATH]
	end

end

--set blur direction
function DKIRunes_UpdateBlurDirection()

	for rune = 1, 6 do
		local frame = _G["Rune"..rune];
		if ( DKIRunes_Saved.rotate == 0 ) then
			_G["Rune"..rune.."RuneTrail1"]:SetPoint( 'CENTER', frame, 'CENTER', 0, 3 );
			_G["Rune"..rune.."RuneTrail2"]:SetPoint( 'CENTER', frame, 'CENTER', 0, 6 );
			_G["Rune"..rune.."RuneTrail3"]:SetPoint( 'CENTER', frame, 'CENTER', 0, 9 );
			_G["Rune"..rune.."RuneTrail4"]:SetPoint( 'CENTER', frame, 'CENTER', 0, 12 );
		elseif ( DKIRunes_Saved.rotate == 1 ) then
			_G["Rune"..rune.."RuneTrail1"]:SetPoint( 'CENTER', frame, 'CENTER', 3, 0 );
			_G["Rune"..rune.."RuneTrail2"]:SetPoint( 'CENTER', frame, 'CENTER', 6, 0 );
			_G["Rune"..rune.."RuneTrail3"]:SetPoint( 'CENTER', frame, 'CENTER', 9, 0 );
			_G["Rune"..rune.."RuneTrail4"]:SetPoint( 'CENTER', frame, 'CENTER', 12, 0 );
		elseif ( DKIRunes_Saved.rotate == 2 ) then
			_G["Rune"..rune.."RuneTrail1"]:SetPoint( 'CENTER', frame, 'CENTER', 0, -3 );
			_G["Rune"..rune.."RuneTrail2"]:SetPoint( 'CENTER', frame, 'CENTER', 0, -6 );
			_G["Rune"..rune.."RuneTrail3"]:SetPoint( 'CENTER', frame, 'CENTER', 0, -9 );
			_G["Rune"..rune.."RuneTrail4"]:SetPoint( 'CENTER', frame, 'CENTER', 0, -12 );
		else 
			_G["Rune"..rune.."RuneTrail1"]:SetPoint( 'CENTER', frame, 'CENTER', -3, 0 );
			_G["Rune"..rune.."RuneTrail2"]:SetPoint( 'CENTER', frame, 'CENTER', -6, 0 );
			_G["Rune"..rune.."RuneTrail3"]:SetPoint( 'CENTER', frame, 'CENTER', -9, 0 );
			_G["Rune"..rune.."RuneTrail4"]:SetPoint( 'CENTER', frame, 'CENTER', -12, 0 );
		end
	end

end

function DKIRunes_BarUpdate()
	DKIRunicPower:Hide();
	DKIRunesFrame:SetAlpha(1.0);
	EbonBlade_Bar_0:Hide();
	EbonBlade_Bar_1:Hide();
	Horizontal_Bar_0:Hide();
	Horizontal_Bar_1:Hide();
	Vertical_Bar_0:Hide();
	Vertical_Bar_1:Hide();
	local runicPower = UnitMana("player") / UnitManaMax("player") ;
	local healthPoints = UnitHealth("player") / UnitHealthMax("player") ;
	local deathPoints = ( UnitHealthMax("player") - UnitHealth("player") ) / UnitHealthMax("player");

	if (DKIRunes_Saved.bar0 > 0) then
		local power0Value;
		if(DKIRunes_Saved.bar0 == 2) then
			power0Value = healthPoints;
		elseif(DKIRunes_Saved.bar0 == 3) then
			power0Value = deathPoints;
		else
			power0Value = runicPower;
		end
		if (DKIRunes_Saved.rotate % 2 == 1) then
			EbonBlade_Bar_0:SetHeight(181 * power0Value);
			Vertical_Bar_0:SetHeight(150 * power0Value);
		else
			EbonBlade_Bar_0:SetWidth(181 * power0Value);
			Horizontal_Bar_0:SetWidth(150 * power0Value);
		end
		if(power0Value > 0) then
			EbonBlade_Bar_0:Show();
			Vertical_Bar_0:Show();
			Horizontal_Bar_0:Show();
		end
	end

	if (DKIRunes_Saved.bar1 > 0) then
		local power1Value;
		if(DKIRunes_Saved.bar1 == 2) then
			power1Value = healthPoints;
		elseif(DKIRunes_Saved.bar1 == 3) then
			power1Value = deathPoints;
		else
			power1Value = runicPower;
		end
		if (DKIRunes_Saved.rotate % 2 == 1) then
			EbonBlade_Bar_1:SetHeight(181 * power1Value);
			Vertical_Bar_1:SetHeight(150 * power1Value);
		else
			EbonBlade_Bar_1:SetWidth(181 * power1Value);
			Horizontal_Bar_1:SetWidth(150 * power1Value);
		end
		if(power1Value > 0) then
			EbonBlade_Bar_1:Show();
			Vertical_Bar_1:Show();
			Horizontal_Bar_1:Show();
		end
	end

	if(DKIRunes_Saved.rpCounter and UnitMana("player") > 0) then
		DKIRunicPower:SetText(UnitMana("player"));
		DKIRunicPower:Show();
	end

	if(DKIRunes_Saved.fade and UnitMana("player") == 0 and DKIRunes_inCombat2 == 0) then
		DKIRunesFrame:SetAlpha(0.3);
		EbonBlade_Bar_0:Hide();
		EbonBlade_Bar_1:Hide();
		Horizontal_Bar_0:Hide();
		Horizontal_Bar_1:Hide();
		Vertical_Bar_0:Hide();
		Vertical_Bar_1:Hide();
	end
end

function DKIRunes_SetLocation()
	DKIRunesFrame:ClearAllPoints()
	DKIRunesFrame:SetPoint(DKIRunes_Saved.point, DKIRunes_Saved.parent, DKIRunes_Saved.parentPoint, DKIRunes_Saved.x, DKIRunes_Saved.y);
end

function DKIRunes_SetRuneOffsets()
	for rune=1, 6 do
		runeOffset[rune] = DKIRunes_Saved.runeLayout[rune];
	end
end

function DKIRunes_OnUpdate(self, update)

	if(DKIRunesFrame:IsMouseEnabled()) then
		DKIRunes_Saved.point, relativeTo, DKIRunes_Saved.parentPoint, DKIRunes_Saved.x, DKIRunes_Saved.y = DKIRunesFrame:GetPoint();
	end

	for i=1, 6 do
		local runeType = GetRuneType( i );
		local runeLength = DKIRuneLengths[runeType];
		local maxFrameX = math.fmod( runeLength, 8 );
		local maxFrameY = math.floor( runeLength / 8 );
		DKIRunes_AnimateRune( i, runeLength - 2, maxFrameX, maxFrameY );
	end

	DKIRunes_BarUpdate()

end

function DKIRunes_AnimateRune(rune, animationStart, maxFrameX, maxFrameY)
	local frameX, frameY = maxFrameX, maxFrameY;
	local start, duration, runeReady = GetRuneCooldown(rune);
	local percent = 1 - ((GetTime() - start)/duration);

	if(DKIRunes_Saved.swap > 0 and rune % 2 == 0) then
		DKIRunes_DetermineRuneSwap(rune, percent);
	end
	
	if ( runeReady or percent <= 0 ) then

		runeBurst[rune] = true;

		if (DKIRunes_Saved.rotate % 2 == 1) then
			_G["Rune"..rune]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[rune] ) 
		else
			_G["Rune"..rune]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[rune], 0 ) 
		end

	else
		
		local heroValue = percent * DKIRunes_Saved.heroSlide * DKIRunes_Saved.heroOrigin;

		if(percent >= 1) then

			_G["Rune"..rune].energize:Stop();

			if(DKIRunes_Saved.deadRune == 1) then
				heroValue = DKIRunes_Saved.heroSlide * DKIRunes_Saved.heroOrigin;
			elseif(DKIRunes_Saved.deadRune == 2) then
				heroValue = 0;
			end

		end

		local rawframe;

		if(runeBurst[rune]) then
			runeBurst[rune] = false;
			rawFrame = animationStart + 1;
		else
			rawFrame = math.floor( percent * animationStart);
			if ((DKIRunes_Saved.animate == nil and rawFrame > 0) or rawFrame > animationStart) then 
				rawFrame = animationStart;
			end
		end
		
		frameY = math.floor( rawFrame / 8 );
		frameX = math.fmod( rawFrame, 8);

		if ( frameY <= 0 ) then
			frameY = 0;
		end

		if ( percent <= 0 ) then
			frameX = 0;
		end

		if (DKIRunes_Saved.hero) then
			if (DKIRunes_Saved.rotate == 1 or DKIRunes_Saved.rotate == 2) then
				heroValue = -heroValue;
			end
			if (DKIRunes_Saved.rotate % 2 == 1) then
				_G["Rune"..rune]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', heroValue, runeOffset[rune] )
			else
				_G["Rune"..rune]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[rune], -heroValue ) 
			end
		else
			if (DKIRunes_Saved.rotate % 2 == 1) then
				_G["Rune"..rune]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[rune] ) 
			else
				_G["Rune"..rune]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[rune], 0 ) 
			end
		end

	end

	if(DKIRunes_Saved.cooldown) then
		local cooldown = _G["Rune"..rune.."Cooldown"];
		local displayCooldown = 1;
		CooldownFrame_SetTimer(cooldown, start, duration, displayCooldown);
	end

	DKIRunes_Rune_SetFrame(rune, frameX, frameY);

--	ChatFrame1:AddMessage("Start: "..start.." percent: "..tostring(percent).." aStart: "..animationStart.." x: "..tostring(frameX).." y: "..tostring(frameY).." maxx: "..tostring(maxFrameX).." maxy: "..tostring(maxFrameY) );


end

function DKIRunes_DetermineRuneSwap(rune, percent)
	local altRune = rune - 1;
	local start, duration, runeReady = GetRuneCooldown(altRune);
	local altPercent = 1 - ((GetTime() - start)/duration);
	local swap = false
	
	if(DKIRunes_Saved.swap == 1 and ((runeOffset[rune] < runeOffset[altRune] and percent < altPercent) or (runeOffset[rune] > runeOffset[altRune] and percent > altPercent))) then
		swap = true;
	elseif(DKIRunes_Saved.swap == 2 and ((runeOffset[rune] < runeOffset[altRune] and percent > altPercent) or (runeOffset[rune] > runeOffset[altRune] and percent < altPercent))) then
		swap = true;
	end
	
	if(swap) then
		local temp = runeOffset[rune];
		runeOffset[rune] = runeOffset[altRune];
		runeOffset[altRune] = temp;
	end
end

function DKIRunes_Rune_SetFrame(rune, frameX, frameY)
	--ChatFrame1:AddMessage(string.format("%s: (%s, %s)", rune, frameX, frameY));
	local width = 0.125;
	local height = 0.0625;
	local runeType = GetRuneType(rune);	
	local texture = DKIRunes[runeType];
	
	--ChatFrame1:AddMessage(string.format("FrameX: %s, FrameY: %s, Rune: %s", frameX, frameY, rune));

	_G["Rune"..rune]:Show();
	_G["Rune"..rune.."Cooldown"]:SetAlpha(0);
	_G["Rune"..rune.."Rune"]:Show();
	_G["Rune"..rune.."Rune"]:SetTexture(texture);
	_G["Rune"..rune.."Rune"]:SetTexCoord(width * frameX, width * frameX + width, height * frameY, height * frameY + height);
	
	-- HANZO: New functionality to handle the "blurring" of runes during Runic Corruption
	DKIRunes_SetBlur(rune, frameX, frameY);

	--_G["Rune"..rune.."RuneColorGlow"]:SetTexture(retexture);
end

function DKIRunes_SetBlur(rune, frameX, frameY)
	local width = 0.125;
	local height = 0.0625;
	local shadow = 0;
	local runeType = GetRuneType(rune);	
	local texture = DKIRunes[runeType];
	
	--ChatFrame1:AddMessage("is runic corruption on: "..tostring(DKIRunes_isRunicCorruptionOn) );	

	if (DKIRunes_isRunicCorruptionOn) then
		for shadow = 1,4 do
			local shadowAlpha = (10 - (shadow * 2)) / 10;

			_G["Rune"..rune.."RuneTrail"..shadow]:Show();
			_G["Rune"..rune.."RuneTrail"..shadow]:SetAlpha(shadowAlpha);
			_G["Rune"..rune.."RuneTrail"..shadow]:SetTexture(texture);		
			_G["Rune"..rune.."RuneTrail"..shadow]:SetTexCoord(width * frameX, width * frameX + width, height * frameY, height * frameY + height);	
		end
	else
		for shadow = 1,4 do
			_G["Rune"..rune.."RuneTrail"..shadow]:SetAlpha(0);
		end
	end
end

function DKIRunes_Rotate(spin)
	
	if(spin) then
		DKIRunes_Saved.rotate = DKIRunes_Saved.rotate + 1;
	end

	if (DKIRunes_Saved.rotate > 3) then 
		DKIRunes_Saved.rotate = 0;
	end

	EbonBlade_Bar_0:ClearAllPoints()
	EbonBlade_Bar_1:ClearAllPoints()

	if (DKIRunes_Saved.rotate == 1) then
		EbonBlade_Base:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
		EbonBlade_Bar_0:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
		EbonBlade_Bar_0:SetPoint('TOPLEFT', DKIRunesFrame, 'CENTER', 0, 86)
		EbonBlade_Bar_1:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
		EbonBlade_Bar_1:SetPoint('TOPRIGHT', DKIRunesFrame, 'CENTER', 0, 86)
		EbonBlade_Top:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
	elseif (DKIRunes_Saved.rotate == 2) then
		EbonBlade_Base:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
		EbonBlade_Bar_0:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
		EbonBlade_Bar_0:SetPoint('TOPRIGHT', DKIRunesFrame, 'CENTER', 86, 0)
		EbonBlade_Bar_1:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
		EbonBlade_Bar_1:SetPoint('BOTTOMRIGHT', DKIRunesFrame, 'CENTER', 86, 0)
		EbonBlade_Top:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
	elseif (DKIRunes_Saved.rotate == 3) then
		EbonBlade_Base:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1);
		EbonBlade_Bar_0:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1);
		EbonBlade_Bar_0:SetPoint('BOTTOMRIGHT', DKIRunesFrame, 'CENTER', 0, -86)
		EbonBlade_Bar_1:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1);
		EbonBlade_Bar_1:SetPoint('BOTTOMLEFT', DKIRunesFrame, 'CENTER', 0, -86)
		EbonBlade_Top:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1);
	else
		EbonBlade_Base:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1);
		EbonBlade_Bar_0:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1);
		EbonBlade_Bar_0:SetPoint('BOTTOMLEFT', DKIRunesFrame, 'CENTER', -86, 0)
		EbonBlade_Bar_1:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1);
		EbonBlade_Bar_1:SetPoint('TOPLEFT', DKIRunesFrame, 'CENTER', -86, 0)
		EbonBlade_Top:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1);
	end

	if (DKIRunes_Saved.rotate % 2 == 1) then
		EbonBlade_Base:SetWidth(256);
		EbonBlade_Base:SetHeight(512);
		EbonBlade_Bar_0:SetWidth(17);
		EbonBlade_Bar_1:SetWidth(17);
		EbonBlade_Top:SetWidth(256);
		EbonBlade_Top:SetHeight(512);
		_G["Rune1"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[1])
		_G["Rune2"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[2])
		_G["Rune5"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[5])
		_G["Rune6"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[6])
		_G["Rune3"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[3])
		_G["Rune4"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 0, runeOffset[4])
	else
		EbonBlade_Base:SetWidth(512);
		EbonBlade_Base:SetHeight(256);
		EbonBlade_Bar_0:SetHeight(17);
		EbonBlade_Bar_1:SetHeight(17);
		EbonBlade_Top:SetWidth(512);
		EbonBlade_Top:SetHeight(256);
		_G["Rune1"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[1], 0)
		_G["Rune2"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[2], 0)
		_G["Rune5"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[5], 0)
		_G["Rune6"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[6], 0)
		_G["Rune3"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[3], 0)
		_G["Rune4"]:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -runeOffset[4], 0)
	end

	DKIRunes_BarUpdate();
	FixRPCounterLocation()
	DKIRunes_UpdateArt();
	DKIRunes_UpdateUI();
	DKIRunes_UpdateBlurDirection();
end

function DKIRunes_Reset(frame)
	DKIRunes_Saved.artStyle = 1;
	DKIRunes_Saved.animate = true;
	DKIRunes_Saved.cooldown = false;
	DKIRunes_Saved.parent = "UIParent";
	DKIRunes_Saved.point = "TOPLEFT";
	DKIRunes_Saved.parentPoint = "TOPLEFT";
	DKIRunes_Saved.x = -73;
	DKIRunes_Saved.y = 25;
	DKIRunes_Saved.scale = 0.8;
	DKIRunes_Saved.rotate = 0;
	DKIRunes_Rotate(false);
	DKIRunes_Saved.hero = false;
	DKIRunes_Saved.heroSlide = 150;
	DKIRunes_Saved.heroOrigin = 1;
	DKIRunes_Saved.bar0 = 1;
	RunicBar0_Set(DKIRunes_Saved.bar0)
	DKIRunes_Saved.bar1 = 1;
	RunicBar1_Set(DKIRunes_Saved.bar1)
	DKIRunes_Saved.rpCounter = true;
	DKIRunes_Saved.counterScale = 1;
	DKIRunes_Saved.fade = false;
	DKIRunes_Saved.runeLayout[1] = 60;
	DKIRunes_Saved.runeLayout[2] = 36;
	DKIRunes_Saved.runeLayout[5] = 12;
	DKIRunes_Saved.runeLayout[6] = -12;
	DKIRunes_Saved.runeLayout[3] = -36;
	DKIRunes_Saved.runeLayout[4] = -60;
	DKIRunes_Saved.deadRune = 0;
	DKIRunes_Saved.swap = 0;
	DKIRunes_Saved.empower = true;
	DKIRunes_Saved.greenUnholy = false;
	DKIRunes_Saved.purpleDeath = false;
	DKIRunes_Saved.rc_blur = true;

	DKIRunesFrame:SetMovable(false)
	DKIRunesFrame:EnableMouse(false)

	DKIRunes_ConfigChange();
	DKIRunes_UpdateUI();

	UIDropDownMenu_Initialize(_G["RuneFrameGraphics"], Graphics_Initialise)
	UIDropDownMenu_Initialize(_G["HeroOrigin"], HeroOrigin_Initialise)
	UIDropDownMenu_Initialize(_G["RunicBar0"], RunicBar0_Initialise)
	UIDropDownMenu_Initialize(_G["RunicBar1"], RunicBar1_Initialise)
	UIDropDownMenu_Initialize(_G["DeadRune"], DeadRune_Initialise)
	UIDropDownMenu_Initialize(_G["Swap"], Swap_Initialise)
	UIDropDownMenu_Initialize(_G["BR1Slot"], BR1_Initialise)
	UIDropDownMenu_Initialize(_G["BR2Slot"], BR2_Initialise)
	UIDropDownMenu_Initialize(_G["FR1Slot"], FR1_Initialise)
	UIDropDownMenu_Initialize(_G["FR2Slot"], FR2_Initialise)
	UIDropDownMenu_Initialize(_G["UH1Slot"], UH1_Initialise)
	UIDropDownMenu_Initialize(_G["UH2Slot"], UH2_Initialise)
	

end

function FixRPCounterLocation()
	if (DKIRunes_Saved.rotate == 1) then
		DKIRunicPower:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -1, 101 / DKIRunes_Saved.counterScale)
	elseif (DKIRunes_Saved.rotate == 2) then
		DKIRunicPower:SetPoint('CENTER', DKIRunesFrame, 'CENTER', 100 / DKIRunes_Saved.counterScale, 0)
	elseif (DKIRunes_Saved.rotate == 3) then
		DKIRunicPower:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -1, -101 / DKIRunes_Saved.counterScale)
	else
		DKIRunicPower:SetPoint('CENTER', DKIRunesFrame, 'CENTER', -101 / DKIRunes_Saved.counterScale, 0)
	end
end

function DKIRunes_Debug()
	DKIRunes_BarUpdate()
--	ChatFrame1:AddMessage(" style: "..tostring(DKIRunes_Saved.artStyle).." x: "..tostring(DKIRunes_Saved.x).." style: "..tostring(DKIRunes_Saved.y) );
end
