--Warnings---------------------------------------------------------------------------------
BalancePowerTracker = BalancePowerTracker or {} 
BalancePowerTracker.modules = BalancePowerTracker.modules or {}

local me = {};
me.loadedByDefault = true;
me.class = {}
me.class.DRUID = true
BalancePowerTracker.modules.warning_text = me;
local getEnv,reset;

local UIFrameFlash,PlaySoundFile,SpellActivationOverlay_OnEvent,SpellActivationOverlayFrame,abs = UIFrameFlash,PlaySoundFile,SpellActivationOverlay_OnEvent,SpellActivationOverlayFrame,abs

local getEclipseKey = {
	[-100] = {
		[0] = "RealLunarEclipse",
		[1] = "PredictedLunarEclipse",
	},
	[100] = {
		[0] = "RealSolarEclipse",
		[1] = "PredictedSolarEclipse",
	},
}

local defaults = { 
	RealLunarEclipse = {
		warnThis = true,
		MSBTThis = false,
		playThis = false,
		sound = "Interface\\Quiet.ogg",
		flashThis = false,
		color = { r = .05, g = .21, b =.73, a = 1,},
		text = GetSpellInfo(48518),
		showTexture = true,
		texture = select(3,GetSpellInfo(48518)),
	},
	PredictedLunarEclipse = {
		warnThis = true,
		MSBTThis = true,
		playThis = false,
		sound = "Interface\\Quiet.ogg",
		flashThis = false,
		color = { r = .12, g = .56, b =  1, a = 1,},
		text = GetSpellInfo(48518).." soon!",
		showTexture = true,
		texture = select(3,GetSpellInfo(48518)),
	},
	RealSolarEclipse = {
		warnThis = true,
		MSBTThis = false,
		playThis = false,
		sound = "Interface\\Quiet.ogg",
		flashThis = false,
		color = { r =   1, g = .55, b =  0, a = 1,},
		text = GetSpellInfo(48517),
		showTexture = true,
		texture = select(3,GetSpellInfo(48517)),
	},
	PredictedSolarEclipse = {
		warnThis = true,
		MSBTThis = true,
		playThis = false,
		sound = "Interface\\Quiet.ogg",
		flashThis = false,
		color = { r =   1, g = .66, b =.16, a = 1,},    
		text = GetSpellInfo(48517).." soon!",
		showTexture = true,
		texture = select(3,GetSpellInfo(48517)),
	},
}	

local function DrawUI()
	if not me.UIcreated then
		me.UIcreated = true
		--Text frame
		me.frame = me.frame or CreateFrame("Frame",nil,UIParent)
		
		local function savePosition(frame)
			local point,_,_,x,y = frame:GetPoint() 
			getEnv("point",point,true);
			getEnv("x",x,true);
			getEnv("y",y,true);
		end
		
		me.frame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
		me.frame:SetScript("OnMouseUp",   function(self) self:StopMovingOrSizing(); savePosition(self) end)
		me.frame:SetScript("OnDragStop",  function(self) self:StopMovingOrSizing(); savePosition(self) end)
	
		me.frame:SetClampedToScreen(true)
		me.frame:SetMovable(true)
		me.frame:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = nil,
			tile = false, tileSize = 0, edgeSize = 12,
			insets = {top =2, bottom=2, left =2, right =2,},
		})
	
		--Text
		me.text = me.text or me.frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
		me.text:ClearAllPoints();
		me.text:SetPoint("CENTER",0,0)
		
		--Frame alpha animation
		me.frameAnimation = me.frameAnimation or me.frame:CreateAnimationGroup()
		me.frameFadeIn = me.frameFadeIn or me.frameAnimation:CreateAnimation("Alpha")
		me.frameFadeIn:SetChange(1)
		me.frameFadeIn:SetDuration(0)
		me.frameFadeIn:SetEndDelay(2)
		me.frameFadeIn:SetOrder(1)
		me.frameFadeOut = me.frameFadeOut or me.frameAnimation:CreateAnimation("Alpha")
		me.frameFadeOut:SetChange(-1)
		me.frameFadeOut:SetDuration(0)
		me.frameFadeOut:SetOrder(2)
		
		--Flash frame
		me.flash = me.flash or CreateFrame("Frame", nil,UIParent)
		me.flash:SetToplevel(true)
		me.flash:SetFrameStrata("FULLSCREEN_DIALOG")
		me.flash:SetAllPoints(UIParent)
		me.flash:EnableMouse(false)
		me.flash:Hide()

		--Flash texture
		me.flashtexture = me.flashtexture or me.flash:CreateTexture(nil, "BACKGROUND")
		me.flashtexture:SetTexture(0.0,1.0,1.0,.15)
		me.flashtexture:SetAllPoints(UIParent)
		me.flashtexture:SetBlendMode("ADD")
	end
	
	me.text:SetFont(getEnv("font","Fonts\\FRIZQT__.TTF"),getEnv("fontSize",30))
	
	me.frame:ClearAllPoints();
	me.frame:SetPoint(getEnv("point","CENTER"),getEnv("x",0),getEnv("y",120));

	me.frame:SetScale(getEnv("scale",1))
	
	me.frame:SetFrameStrata(getEnv("strata","HIGH"))
	
	me.frame:SetWidth(getEnv("fontSize",30)*1.2)
	me.frame:SetHeight(getEnv("fontSize",30)*1.2);
	me.frame:Show()
		
	me.flashtexture:SetAlpha(getEnv("flashAlpha",.5))
	
	if getEnv("testing",false) then
		me.frame:EnableMouse(true)
		me.frame:SetBackdropColor(0, 0, 0, .5)
		me.text:SetText("Move Me!")
		me.text:SetTextColor(1, 1, 1, 1)
		me.frame:SetAlpha(1)
	else
		me.frame:EnableMouse(false)
		me.frame:SetBackdropColor(0, 0, 0, 0)
		me.frame:SetAlpha(0)
	end
	
	--Initialize other options
	for k in pairs(defaults) do
		getEnv(k,defaults[k])
	end
	getEnv("spellEffects",true)
	getEnv("MSBT_scrollArea",nil)
	getEnv("MSBT_sticky",true)
	getEnv("MSBT_fontSize",nil)
	getEnv("MSBT_font",nil)
	getEnv("MSBT_outlineIndex",0)
end

local function warnEclipse(eclipse,predicted)
	local eclipseKey = getEclipseKey[eclipse][predicted]
	local dataTable = getEnv(eclipseKey,defaults[eclipseKey])
	
	local color = dataTable.color
	local text = dataTable.text

	if dataTable.warnThis then
		me.text:SetText(text)
		me.text:SetTextColor(color.r,color.g,color.b,1)
		if getEnv("testing",false) then
			me.frame:SetAlpha(1)
		else
			me.frameAnimation:Stop()
			me.frameAnimation:Play()
		end
	end
	
	if dataTable.flashThis then
		me.flashtexture:SetTexture(color.r,color.g,color.b,me.flashtexture:GetAlpha())
		UIFrameFlash(me.flash, 0.20, 0.70, 1, false, 0.1, 0)
	end
	
	if dataTable.playThis then
		PlaySoundFile(dataTable.sound)
	end
	
	if dataTable.MSBTThis and MikSBT then
		MikSBT.DisplayMessage(text, getEnv("MSBT_scrollArea",nil), getEnv("MSBT_sticky",true), color.r*255,color.g*255,color.b*255, getEnv("MSBT_fontSize",nil), getEnv("MSBT_font",nil), getEnv("MSBT_outlineIndex",0), dataTable.showTexture and dataTable.texture) 
	end
end

local warnedEclipse = false;
local warnedVEclipse = false;
local function callback(energy,direction,vEnergy,vDirection,vEclipse)
	if vEclipse then
		if abs(energy) == 100 and direction == vDirection then
			--Real Eclipse
			if warnedEclipse ~= vEclipse then
				warnEclipse(vEclipse,0)
				warnedEclipse = vEclipse
				warnedVEclipse = false;
			end
		elseif abs(vEnergy) == 100 and energy ~= vEnergy and direction~=vDirection then
			--Predicted eclipse
			if warnedVEclipse ~= vEclipse then
				warnEclipse(vEclipse,1)
				warnedVEclipse = vEclipse
				
				if getEnv("spellEffects",true) then
					if vEclipse < 0 then
						SpellActivationOverlay_OnEvent(SpellActivationOverlayFrame,  "SPELL_ACTIVATION_OVERLAY_SHOW", 93431, "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ECLIPSE_MOON.BLP", "TopLeft", 1, 244, 244, 244)
					else
						SpellActivationOverlay_OnEvent(SpellActivationOverlayFrame,  "SPELL_ACTIVATION_OVERLAY_SHOW", 93430, "TEXTURES\\SPELLACTIVATIONOVERLAYS\\ECLIPSE_SUN.BLP", "TopRight", 1, 244, 244, 244)
					end
				end
			end
		end
	else
		if warnedVEclipse then
			if getEnv("spellEffects",true) then
				SpellActivationOverlay_OnEvent(SpellActivationOverlayFrame,  "SPELL_ACTIVATION_OVERLAY_HIDE", 93430)
				SpellActivationOverlay_OnEvent(SpellActivationOverlayFrame,  "SPELL_ACTIVATION_OVERLAY_HIDE", 93431)
			end
			if me.frameAnimation:IsPlaying() then
				me.frameAnimation:Stop()
			end
		end
		warnedEclipse = false;
		warnedVEclipse = false;
	end
end

function me.ReDraw()
	if not me.loaded then return end
	reset()
	DrawUI()
end
function me.LoadModule(getOptionValueFunction,r)
	if me.loaded then return end
	if not LibBalancePowerTracker then return "Warnings: LibBalancePowerTracker missing" end
	
	getEnv,reset = getOptionValueFunction,r
	
	DrawUI()
	
	me.callbackId = LibBalancePowerTracker:RegisterCallback(callback);
	me.loaded = true
end
function me.UnloadModule()
	if not me.loaded then return end
	me.loaded = false

	LibBalancePowerTracker:UnregisterCallback(me.callbackId)

	me.frame:Hide();
	me.flash:Hide();
end