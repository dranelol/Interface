
local o = {};
ItemTooltipIcons = o;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(NicheDevTools);
	assert(NicheDevTools.RegisterSlashCommand);
	assert(WorldFrame.onVariablesLoadedHandlers);
	--]]
	
	o.Config_t_Init();
	
	o.Localization = nil;
end
