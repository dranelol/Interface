--Hide default EclipseBar------------------------------------------------------------------
BalancePowerTracker = BalancePowerTracker or {} 
BalancePowerTracker.modules = BalancePowerTracker.modules or {}

local me = {};
me.loadedByDefault = true;
me.class = {}
me.class.DRUID = true
BalancePowerTracker.modules.hide_default = me;

local EclipseBarFrame,MOONKIN_FORM,GetShapeshiftFormID = EclipseBarFrame,MOONKIN_FORM,GetShapeshiftFormID

function me.ReDraw()
end
function me.LoadModule()
	if me.loaded then return end	
	if not EclipseBarFrame then return "Hide Default Eclipse bar: Original Eclipse bar frame missing ?!" end

	me.functBlizzOnEvent = me.functBlizzOnEvent or EclipseBarFrame:GetScript("OnEvent")
	me.functBlizzOnShow = me.functBlizzOnShow or EclipseBarFrame:GetScript("OnShow")
	
	EclipseBarFrame:SetScript("OnEvent", nil)
	EclipseBarFrame:SetScript("OnShow", function()	EclipseBarFrame:Hide() end)

	EclipseBarFrame:Hide();
	me.loaded = true
end
function me.UnloadModule()
	if not me.loaded then return end
	me.loaded = false

	EclipseBarFrame:SetScript("OnEvent", me.functBlizzOnEvent)
	EclipseBarFrame:SetScript("OnShow", me.functBlizzOnShow)

	if  BalancePowerTracker.isBalance() and (GetShapeshiftFormID() == MOONKIN_FORM or not GetShapeshiftFormID()) then
		EclipseBarFrame:Show();
	end
end