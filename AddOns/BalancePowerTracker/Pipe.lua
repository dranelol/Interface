--Pipe-------------------------------------------------------------------------------------
BalancePowerTracker = BalancePowerTracker or {} 
BalancePowerTracker.modules = BalancePowerTracker.modules or {}

local me = {};
me.loadedByDefault = false;
me.class = {}
me.class.DRUID = true
BalancePowerTracker.modules.pipe = me;
local getEnv,reset;

function me.ReDraw()
	reset()
end
function me.LoadModule(getOptionValueFunction,r)
	if me.loaded then return end 
	if not LibBalancePowerTracker then return "Pipe: LibBalancePowerTracker missing" end
	
	getEnv,reset = getOptionValueFunction,r
	
	me.frame = me.frame or CreateFrame("Frame",nil,UIParent);
	me.frame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
	me.frame:SetScript("OnEvent",function(_,_,culprit) getEnv("load",false,true) print("|c00a080ff"..BalancePowerTracker.name.."|r: Action blocked in "..culprit..": Pipe module disabled just in case.") me.UnloadModule() end)
	
	me.oldUnitPower = UnitPower
	me.oldGetEclipseDirection = GetEclipseDirection
	local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
	
	UnitPower = function(unit,powerType,ignore)
		if unit ~= "player" or powerType  ~= SPELL_POWER_ECLIPSE or ignore then
			return me.oldUnitPower(unit,powerType)
		end
	
		return select(3,LibBalancePowerTracker:GetEclipseEnergyInfo())
	end
	
	GetEclipseDirection = function()
		return select(4,LibBalancePowerTracker:GetEclipseEnergyInfo())
	end
	
	me.loaded = true
end
function me.UnloadModule()
	if not me.loaded then return end
	me.loaded = false

	me.frame:UnregisterAllEvents()
	
	GetEclipseDirection = me.oldGetEclipseDirection
	UnitPower = me.oldUnitPower
end