
local o = {};
VendorValues = o;


function o.t_Init()
	o.t_Init = nil;
	
	--[[
	assert(GetSellValue);
	assert(TooltipItemQuantities2);
	assert(NicheDevTools);
	assert(NicheDevTools.RegisterSlashCommand);
	--]]
	
	o.Config_t_Init();
	
	o.Tooltips_RegisterTooltip(GameTooltip);
	o.Tooltips_RegisterTooltip(ItemRefTooltip);
	
	o.Localization = nil;
end
