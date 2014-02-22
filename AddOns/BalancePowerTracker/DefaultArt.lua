--Default Art------------------------------------------------------------------------------
BalancePowerTracker = BalancePowerTracker or {} 
BalancePowerTracker.modules = BalancePowerTracker.modules or {}

local me = {};
me.loadedByDefault = false;
me.class = {}
me.class.DRUID = true
BalancePowerTracker.modules.default_art = me;
local getEnv,reset;
	
local UnitHasVehicleUI,IsWildBattle,GetShapeshiftFormID,UnitCastingInfo,UnitChannelInfo,GetTime,min = UnitHasVehicleUI,C_PetBattles.IsWildBattle,GetShapeshiftFormID,UnitCastingInfo,UnitChannelInfo,GetTime,min
local select,UnitBuff = select,UnitBuff

--Frame visibility && alpha
local showCustomTableDefaults={
	[CAT_FORM] = false, --cat
	[BEAR_FORM] = false, --bear
	[MOONKIN_FORM] = true, --moonkin
	[27] = false, -- swift flight form
	[29] = false, --flight form
	[3] = false, --travel
	[4] = false, --aquatic
	[0] = true, --humanoid
}
local function checkAddonVisibility(inVehicle,inPetBattle)
	if not me.frame then return end
	
	if inVehicle == nil then inVehicle = UnitHasVehicleUI("player") end
	if inPetBattle == nil then inPetBattle = IsWildBattle() end
	
	if inVehicle or inPetBattle then
		me.hframe:Hide();
		return
	end

	local custom = getEnv("custom",showCustomTableDefaults)
	if BalancePowerTracker.isBalance() and (getEnv("showInAllStances",true) or custom[GetShapeshiftFormID() or 0]) then
		me.hframe:Show();
	else
		me.hframe:Hide();
	end
end
do
	me.events = {}
	function me.events.PLAYER_REGEN_ENABLED() --Set alpha to Out of combat alpha
		if me.frame then me.hframe:SetAlpha(getEnv("alphaOOC",.6)); end
	end
	function me.events.PLAYER_REGEN_DISABLED() --Set alpha to Combat alpha
		if me.frame then me.hframe:SetAlpha(getEnv("alpha",1)); end
	end
	function me.events.PET_BATTLE_OPENING_START() -- hide in pet combat
		checkAddonVisibility(nil,true)
	end
	function me.events.UNIT_ENTERED_VEHICLE(unitId) -- hide in vehicle
		if unitId=="player" then checkAddonVisibility(true,nil) end
	end
	function me.events.UPDATE_SHAPESHIFT_FORM() -- hide/show background in forms
		checkAddonVisibility()
	end
	function me.events.PLAYER_SPECIALIZATION_CHANGED() -- hide/show changing talents
		checkAddonVisibility()
	end
	function me.events.PLAYER_LOGIN() -- check on login if it hasn't been done
		checkAddonVisibility()
	end
	function me.events.UNIT_EXITED_VEHICLE(unitId) -- show background out of vehicle
		if unitId=="player" then checkAddonVisibility(false,nil) end
	end
	function me.events.PET_BATTLE_CLOSE() -- show background out of pet battle
		checkAddonVisibility(nil,false)
	end
end

local eclipseMarkerCoords =  {
	none = { 0.922, 1.0, 0.82, 1.0 },
	sun	= { 0.914, 1.0, 0.641, 0.82 },
	moon = { 1.0, 0.914, 0.641, 0.82 },
}

local function setArrowTexture(direction,vertical)
	if direction ~= me.arrowdirection then
		local markerCoords = getEnv("eclipseMarkerCoords",eclipseMarkerCoords)
	
		me.arrow:SetTexCoord(unpack(markerCoords[direction]));
		me.arrowdirection = direction
	end
end
local function UpdateArrow(normEnergy,range,direction)
	me.arrow:SetPoint("CENTER",normEnergy*(range-2)+getEnv("arrowXOffset",0),getEnv("arrowYOffset",1))
	
	setArrowTexture(direction,vertical)
end
local function UpdateText(number,direction)
	if not me.text:IsShown() then return end
	
	if getEnv("moveTextOutOfTheWay",true) then
		me.text:ClearAllPoints();
		if number<0 or (number == 0 and direction =="moon")  then
			me.text:SetPoint("LEFT",me.frame,"CENTER",1,0)
		else
			me.text:SetPoint("RIGHT",me.frame,"CENTER",-1,0)
		end
	end

	if getEnv("absoluteText",true) then
		number = abs(number)
	end
	me.text:SetText(number)
end

-- Eclipse functions
local function EclipseBar_NoEclipse() 
	me.lframehighlight.In:Stop()
	me.sframehighlight.In:Stop()
	me.lframehighlight:SetAlpha(0)
	me.sframehighlight:SetAlpha(0)
	me.lenergy.Out:Play()
	me.benergy.Out:Play()
	me.senergy.Out:Play()
end
local function EclipseBar_LunarEclipse() 
	me.benergy:ClearAllPoints();
	local glowInfo = ECLIPSE_ICONS["moon"].big;
	me.benergy:SetPoint("CENTER", me.lframehighlight, "CENTER", 0, 0);
	me.benergy:SetWidth(glowInfo.x);
	me.benergy:SetHeight(glowInfo.y);
	me.benergy:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);
	
	me.senergy:SetAlpha(0);	
	me.lframehighlight:SetAlpha(0)
	if not me.benergy.pulse:IsPlaying() then me.benergy.In:Play() end
	me.sframehighlight.In:Play()
	me.lenergy.In:Play()
end
local function EclipseBar_SolarEclipse()
	me.benergy:ClearAllPoints();
	local glowInfo = ECLIPSE_ICONS["sun"].big;
	me.benergy:SetPoint("CENTER", me.sframehighlight, "CENTER", 0, 0);
	me.benergy:SetWidth(glowInfo.x);
	me.benergy:SetHeight(glowInfo.y);
	me.benergy:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);
	
	me.lenergy:SetAlpha(0);	
	me.sframehighlight:SetAlpha(0)
	if not me.benergy.pulse:IsPlaying() then me.benergy.In:Play() end
	me.lframehighlight.In:Play()
	me.senergy.In:Play()
end
local function warnEclipse(eclipse)
	if eclipse>0 then
		EclipseBar_SolarEclipse()
	elseif eclipse<0 then
		EclipseBar_LunarEclipse() 
	else
		EclipseBar_NoEclipse() 
	end
end

-- Recalc
local energy,direction,vEnergy,vDirection,vEclipse = 0,"none",0,"none",false
local range = 38
local warnedEclipse = false;
local warnedVEclipse = false;
local function recalc()
	if getEnv("predict",true) then
		UpdateArrow(vEnergy,range,vDirection);
		UpdateText(vEnergy*200,vDirection)
	else
		UpdateArrow(energy,range,direction)
		UpdateText(energy*200,direction)
	end
	
	--Eclipse
	if (direction == "sun" and energy<0) or (direction=="moon" and energy>0) then
		--Real Eclipse
		if warnedEclipse ~= direction then
			warnEclipse(energy)
			warnedEclipse = direction
			warnedVEclipse = false;
		end
	elseif vEclipse then
		--Predicted eclipse
		if getEnv("predict",true) and warnedVEclipse ~= vEclipse then
			warnEclipse(vEclipse)
			warnedVEclipse = vEclipse	
		end
	else
		if warnedEclipse or warnedVEclipse then
			warnEclipse(0)
		end
		warnedEclipse = false;
		warnedVEclipse = false;
	end
end

local function DrawUI()
	local scale = getEnv("scale",1)
	local height = getEnv("height",19)/19
	local width = getEnv("width",140)/140
	local alpha = getEnv("alpha",1)
	range = 76*width

	if not me.UIcreated then
		me.UIcreated = true
	
		--Holder frame
		me.hframe = me.hframe or CreateFrame("Frame",nil,UIParent)
		me.hframe:SetClampedToScreen(true)
		me.hframe:SetMovable(true)
		me.hframe:Show() 
		
		me.hframe:SetScript("OnEvent",function(_,event,...) me.events[event](...) end)
		local function savePosition(frame)
			local point,_,_,x,y = frame:GetPoint() 
			getEnv("point",point,true);
			getEnv("x",x,true);
			getEnv("y",y,true);
		end
		me.hframe:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		me.hframe:SetScript("OnMouseUp",   function(self) self:StopMovingOrSizing(); savePosition(self) end)
		me.hframe:SetScript("OnDragStop",  function(self) self:StopMovingOrSizing(); savePosition(self) end)
		
		--Frame
		me.frame = me.frame or CreateFrame("Frame",nil,me.hframe)
		me.frame:EnableMouse(false)
		me.frame:Show() 
	
		-- Background Texture
		me.backTexture = me.backTexture or me.frame:CreateTexture(nil, "BACKGROUND")
		me.backTexture = me.backTexture or me.frame:CreateTexture(nil, "ARTWORK")
		me.backTexture:SetDrawLayer( "ARTWORK" ,0)
		me.backTexture:SetPoint("CENTER") 
		me.backTexture:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.backTexture:SetTexCoord(0.00390625,0.55078125,0.63281250,0.92968750)
		me.backTexture:Show()
		
		-- Lunar Eclipse frame
		me.lframe = me.lframe or CreateFrame("Frame",nil,me.hframe)
		me.lframe:EnableMouse(false)
		me.lframe:SetFrameStrata("LOW")
		
		--Lunar eclipse textures
		me.lframetexture = me.lframetexture or me.lframe:CreateTexture(nil, "BACKGROUND",nil,0)
		me.lframetexture:SetPoint("CENTER") 
		me.lframetexture:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.lframetexture:SetTexCoord(0.55859375,0.64843750,0.57031250,0.75000000)
		
		me.lframehighlight = me.lframehighlight or me.lframe:CreateTexture(nil, "BACKGROUND",nil,1)
		me.lframehighlight:SetPoint("CENTER") 
		me.lframehighlight:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.lframehighlight:SetBlendMode("BLEND")
		me.lframehighlight:SetTexCoord(0.55859375,0.64843750,0.37500000,0.55468750)
	
		-- Solar Eclipse frame
		me.sframe = me.sframe or CreateFrame("Frame",nil,me.hframe)	
		me.sframe:EnableMouse(false)
		me.sframe:SetFrameStrata("LOW")

		-- Solar Eclipse textures
		me.sframetexture = me.sframetexture or me.sframe:CreateTexture(nil, "BACKGROUND",nil,0)
		me.sframetexture:SetPoint("CENTER") 
		me.sframetexture:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.sframetexture:SetTexCoord(0.65625000,0.74609375,0.37500000,0.55468750)
	
		me.sframehighlight = me.sframehighlight or me.sframe:CreateTexture(nil, "BACKGROUND",nil,1)
		me.sframehighlight:SetPoint("CENTER") 
		me.sframehighlight:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.sframehighlight:SetBlendMode("BLEND")
		me.sframehighlight:SetTexCoord(0.55859375,0.64843750,0.76562500,0.94531250)
		
		-- Solar Energy
		me.senergy = me.senergy or me.frame:CreateTexture(nil, "ARTWORK", nil, 1)
		me.senergy:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.senergy:SetTexCoord(0.00390625,0.55078125,0.32031250,0.61718750)
		me.senergy:SetPoint("CENTER") 
		
		-- Lunar Energy
		me.lenergy = me.lenergy or me.frame:CreateTexture(nil, "ARTWORK", nil, 1)
		me.lenergy:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.lenergy:SetPoint("CENTER") 
		me.lenergy:SetTexCoord(0.00390625,0.55078125,0.00781250,0.30468750)
		
		-- Pulse Energy
		me.benergy = me.benergy or me.frame:CreateTexture(nil, "OVERLAY")
		me.benergy:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.benergy:SetTexCoord(0.55859375,0.72656250,0.00781250,0.35937500)
		me.benergy:ClearAllPoints();
		me.benergy:SetPoint("CENTER") 
		
		--Text
		me.text = me.text or me.frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
		
		--Arrow
		me.arrow = me.arrow or me.frame:CreateTexture(nil, "OVERLAY")
		me.arrow:SetTexture("Interface\\PlayerFrame\\UI-DruidEclipse")
		me.arrow:SetBlendMode("ADD")
		me.arrow:SetTexCoord(1.0,0.914,0.82, 1.0)

		--Other animations
		me.benergy.pulse = me.benergy.pulse or me.benergy:CreateAnimationGroup("BPTpulse") 
		me.benergy.pulse:SetLooping("REPEAT")
		me.benergy.pulse.anim1=me.benergy.pulse:CreateAnimation("Scale")
		me.benergy.pulse.anim1:SetDuration(0.5)
		me.benergy.pulse.anim1:SetOrder(1)
		me.benergy.pulse.anim1:SetSmoothing("IN_OUT")
		me.benergy.pulse.anim1:SetScale(1.08, 1.08)
		me.benergy.pulse.anim2=me.benergy.pulse:CreateAnimation("Scale")
		me.benergy.pulse.anim2:SetDuration(0.5)
		me.benergy.pulse.anim2:SetOrder(2)
		me.benergy.pulse.anim2:SetSmoothing("IN_OUT")
		me.benergy.pulse.anim2:SetScale(0.9259, 0.9259)
		
		me.senergy.In = me.senergy:CreateAnimationGroup("BPTSunBarIn")
		me.senergy.In:SetScript("OnFinished", function() me.senergy:SetAlpha(1); end)
		me.senergy.In.a = me.senergy.In:CreateAnimation("Alpha")
		me.senergy.In.a:SetDuration(0.6)
		me.senergy.In.a:SetOrder(1)
		me.senergy.In.a:SetChange(1)
		
		me.benergy.In = me.benergy:CreateAnimationGroup("BPTGlowIn")
		me.benergy.In:SetScript("OnFinished", function()  me.benergy:SetAlpha(1);	me.benergy.pulse:Play(); end)
		me.benergy.In.a = me.benergy.In:CreateAnimation("Alpha")
		me.benergy.In.a:SetDuration(0.6)
		me.benergy.In.a:SetOrder(1)
		me.benergy.In.a:SetChange(1)

		me.lframehighlight.In = me.lframehighlight:CreateAnimationGroup("BPTDarkMoonIn")
		me.lframehighlight.In:SetScript("OnFinished", function() me.lframehighlight:SetAlpha(1); end)
		me.lframehighlight.In.a = me.lframehighlight.In:CreateAnimation("Alpha")
		me.lframehighlight.In.a:SetDuration(0.6)
		me.lframehighlight.In.a:SetOrder(1)
		me.lframehighlight.In.a:SetChange(1)
		
		me.lenergy.In = me.lenergy:CreateAnimationGroup("BPTMoonBarIn")
		me.lenergy.In:SetScript("OnFinished", function() me.lenergy:SetAlpha(1); end)
		me.lenergy.In.a = me.lenergy.In:CreateAnimation("Alpha")
		me.lenergy.In.a:SetDuration(0.6)
		me.lenergy.In.a:SetOrder(1)
		me.lenergy.In.a:SetChange(1)
		
		me.sframehighlight.In = me.lframehighlight:CreateAnimationGroup("BPTDarkSunIn")
		me.sframehighlight.In:SetScript("OnFinished", function() me.sframehighlight:SetAlpha(1); end)
		me.sframehighlight.In.a = me.sframehighlight.In:CreateAnimation("Alpha")
		me.sframehighlight.In.a:SetDuration(0.6)
		me.sframehighlight.In.a:SetOrder(1)
		me.sframehighlight.In.a:SetChange(1)
		
		me.lenergy.Out = me.lenergy:CreateAnimationGroup("BPTMoonBarOut")
		me.lenergy.Out:SetScript("OnFinished", function() me.lenergy:SetAlpha(0); end)
		me.lenergy.Out.a = me.lenergy.Out:CreateAnimation("Alpha")
		me.lenergy.Out.a:SetDuration(0.6)
		me.lenergy.Out.a:SetOrder(1)
		me.lenergy.Out.a:SetChange(-1)
		
		me.sframehighlight.Out = me.lframehighlight:CreateAnimationGroup("BPTDarkSunOut")
		me.sframehighlight.Out:SetScript("OnFinished", function() me.sframehighlight:SetAlpha(0); end)
		me.sframehighlight.Out.a = me.sframehighlight.Out:CreateAnimation("Alpha")
		me.sframehighlight.Out.a:SetDuration(0.6)
		me.sframehighlight.Out.a:SetOrder(1)
		me.sframehighlight.Out.a:SetChange(-1)
		
		me.senergy.Out = me.senergy:CreateAnimationGroup("BPTSunBarOut")
		me.senergy.Out:SetScript("OnFinished", function() me.senergy:SetAlpha(0); end)
		me.senergy.Out.a = me.senergy.Out:CreateAnimation("Alpha")
		me.senergy.Out.a:SetDuration(0.6)
		me.senergy.Out.a:SetOrder(1)
		me.senergy.Out.a:SetChange(-1)
		
		me.benergy.Out = me.benergy:CreateAnimationGroup("BPTGlowOut")
		me.benergy.Out:SetScript("OnFinished", function()  me.benergy:SetAlpha(0);	me.benergy.pulse:Stop(); end)
		me.benergy.Out.a = me.benergy.Out:CreateAnimation("Alpha")
		me.benergy.Out.a:SetDuration(0.6)
		me.benergy.Out.a:SetOrder(1)
		me.benergy.Out.a:SetChange(-1)

		me.lframehighlight.Out = me.lframehighlight:CreateAnimationGroup("BPTDarkMoonOut")
		me.lframehighlight.Out:SetScript("OnFinished", function() me.lframehighlight:SetAlpha(0); end)
		me.lframehighlight.Out.a = me.lframehighlight.Out:CreateAnimation("Alpha")
		me.lframehighlight.Out.a:SetDuration(0.6)
		me.lframehighlight.Out.a:SetOrder(1)
		me.lframehighlight.Out.a:SetChange(-1)
	else
		--Stop animations
		me.lframehighlight.In:Stop()
		me.sframehighlight.In:Stop()
		me.lframehighlight.Out:Stop()
		me.sframehighlight.Out:Stop()
		me.benergy.pulse:Stop()
		me.benergy.In:Stop()
		me.benergy.Out:Stop()
		me.senergy.In:Stop()
		me.senergy.Out:Stop()
		me.lenergy.In:Stop()
		me.lenergy.Out:Stop()
	end
	me.lframehighlight:SetAlpha(0)
	me.sframehighlight:SetAlpha(0)
	
	--Holder Frame
	me.hframe:SetFrameStrata(getEnv("strata","MEDIUM"))
	me.hframe:EnableMouse(getEnv("moving",false))
	me.hframe:ClearAllPoints();
	me.hframe:SetPoint(getEnv("point","CENTER"),getEnv("x",0),getEnv("y",-60)); 
	me.hframe:SetWidth(width*140)
	me.hframe:SetHeight(height*38)
	me.hframe:SetScale(scale)
	
	--Frame
	me.frame:SetAllPoints(me.hframe)
	if getEnv("showIconsOnly",false) then 
		me.frame:Hide()
		me.benergy:SetParent(me.sframe)
	else
		me.benergy:SetParent(me.frame)
		me.frame:Show() 
	end

	--Background texture
	me.backTexture:SetWidth(width*140)
	me.backTexture:SetHeight(height*38)
	
	--Lunar Eclipse Frame
	me.lframe:ClearAllPoints();
	me.lframe:SetPoint("CENTER",me.frame,"LEFT",17*width-getEnv("iconSeparation",0),1)
	me.lframe:SetWidth(23*width)
	me.lframe:SetHeight(23*height)
	me.lframe:Show();

	--Solar Eclipse Frame
	me.sframe:ClearAllPoints();
	me.sframe:SetPoint("CENTER",me.frame,"RIGHT",-17*width+getEnv("iconSeparation",0),1)
	me.sframe:SetWidth(23*width)
	me.sframe:SetHeight(23*height)
	me.sframe:Show();

	--Lunar Icon tex
	me.lframetexture:SetWidth(23*width)
	me.lframetexture:SetHeight(23*height)
	
	--Solar Icon tex
	me.sframetexture:SetWidth(23*width)
	me.sframetexture:SetHeight(23*height)
	
	--Lunar Icon Highlight
	me.lframehighlight:SetWidth(23*width)
	me.lframehighlight:SetHeight(23*height)

	--Solar Icon Highlight
	me.sframehighlight:SetWidth(23*width)
	me.sframehighlight:SetHeight(23*height)

	--Lunar energy
	me.lenergy:SetWidth(140*width)
	me.lenergy:SetHeight(38*height)
	me.lenergy:SetGradientAlpha("VERTICAL",1, 1, 1, 1, 1,1, 1, 1)
	me.lenergy:SetAlpha(0)
	me.lenergy:Show()

	--Solar energy
	me.senergy:SetWidth(140*width)
	me.senergy:SetHeight(38*height)
	me.senergy:SetGradientAlpha("VERTICAL",1, 1, 1,1,1,1, 1, 1)
	me.senergy:SetAlpha(0)
	me.senergy:Show()
	
	-- Text
	local autoFontSize = getEnv("autoFontSize",true)
	local fontSize = getEnv("fontSize",14)
	local textColor = getEnv("textColor",{r=1,g=1,b=1,a=1})
	local font = getEnv("font","Fonts\\FRIZQT__.TTF")
	if getEnv("showValue",true) then
		me.text:ClearAllPoints();
		me.text:SetPoint("CENTER",0,0)
		
		me.text:SetFont(font, (autoFontSize and max(height*0.9,14)*height) or (fontSize*height))
		me.text:SetText("0")
		me.text:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
		
		me.text:Show()
	else
		me.text:Hide()
	end	
	
	--Spark
	me.arrow:ClearAllPoints();
	me.arrow:SetPoint("CENTER",0,2) 
	me.arrow:SetHeight(20*getEnv("arrowScale",1)*height)
	me.arrow:SetWidth(20*getEnv("arrowScale",1)*width)
	me.arrowdirection = false
	
	--Glow energy
	me.benergy:SetWidth(45*width)
	me.benergy:SetHeight(43*height)
	me.benergy:SetGradientAlpha("VERTICAL",1, 1, 1,1,1,1, 1, 1)
	me.benergy:Show()
	me.benergy:SetAlpha(0)

	if not UnitAffectingCombat("player") then
		me.hframe:SetAlpha(getEnv("alphaOOC",.6));
	else
		me.hframe:SetAlpha(alpha);
	end	

	checkAddonVisibility()
end
	
function me.ReDraw()
	if not me.loaded then return end 
	reset()
	warnedEclipse = false;
	warnedVEclipse = false;
	DrawUI()
	recalc();
end
function me.LoadModule(getOptionValueFunction,r)
	if me.loaded then return end
	if not LibBalancePowerTracker then return "Bar: LibBalancePowerTracker missing" end
	
	getEnv,reset = getOptionValueFunction,r
	
	warnedEclipse = false;
	warnedVEclipse = false;
	DrawUI()
	
	for k,v in pairs(me.events) do
		me.hframe:RegisterEvent(k)
	end

	me.callbackId = LibBalancePowerTracker:RegisterCallback(function(e,d,ve,vd,vec)
		energy,direction,vEnergy,vDirection,vEclipse = e/200,d,ve/200,vd,vec;
		recalc();
	end);
	me.loaded = true
end
function me.UnloadModule()
	if not me.loaded then return end
	me.loaded = false
	
	me.frame:UnregisterAllEvents()

	LibBalancePowerTracker:UnregisterCallback(me.callbackId)

	me.hframe:Hide();
end