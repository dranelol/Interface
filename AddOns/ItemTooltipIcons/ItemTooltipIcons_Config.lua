
local o = ItemTooltipIcons;

-- Config_t_Init: ()
-- Config_OnEvent_VARIABLES_LOADED: ()
--
-- Config_SetSize: (size)
-- Config_SetIconPoint: (point)
-- Config_SetTooltipPoint: (point)
-- Config_ToggleTooltip: (tooltipName)




function o.Config_t_Init()
	o.Config_t_Init = nil;
	
	WorldFrame.onVariablesLoadedHandlers[o.Config_OnEvent_VARIABLES_LOADED] = true;
	
	local cmds = o.Localization.SLASH_COMMANDS;
	local slashInfo = {
		[cmds.SIZE:match("^(%S+)")] = o.Config_SetSize;
		[cmds.ICON_POINT:match("^(%S+)")] = o.Config_SetIconPoint;
		[cmds.TOOLTIP_POINT:match("^(%S+)")] = o.Config_SetTooltipPoint;
		[cmds.TOGGLE_TOOLTIP:match("^(%S+)")] = o.Config_ToggleTooltip;
		[false] = {
			cmds.UNKNOWN;
			cmds.SIZE;
			cmds.ICON_POINT;
			cmds.TOOLTIP_POINT;
			cmds.TOGGLE_TOOLTIP;
		};
	};
	NicheDevTools.RegisterSlashCommand("ItemTooltipIcons", slashInfo, "/iti");
end



function o.Config_OnEvent_VARIABLES_LOADED()
	o.Config_OnEvent_VARIABLES_LOADED = nil;
	
	local config = ItemTooltipIcons_Config;
	if (config == nil or config.tooltips == nil) then
		config = {
			size = 36;
			iconPoint = ("TOPLEFT");
			tooltipPoint = ("TOPRIGHT");
			tooltips = { ["GameTooltip"] = true; ["ItemRefTooltip"] = true; };
		};
		ItemTooltipIcons_Config = config;
	end
	
	local tooltip;
	for tooltipName in pairs(config.tooltips) do
		tooltip = _G[tooltipName];
		if (tooltip ~= nil) then
			o.Tooltips_RegisterTooltip(tooltip);
		end
	end
end




function o.Config_SetSize(size)
	size = tonumber(size);
	if (size ~= nil and size > 0) then
		ItemTooltipIcons_Config.size = size;
		o.Tooltips_OnConfigChanged();
	else
		error("Invalid size. Must be a number greater than 0.", 2);
	end
end



function o.Config_SetIconPoint(point)
	ItemTooltipIcons_Config.iconPoint = point:upper();
	o.Tooltips_OnConfigChanged();
end



function o.Config_SetTooltipPoint(point)
	ItemTooltipIcons_Config.tooltipPoint = point:upper();
	o.Tooltips_OnConfigChanged();
end



function o.Config_ToggleTooltip(tooltipName)
	if (ItemTooltipIcons_Config.tooltips[tooltipName] == true) then
		ItemTooltipIcons_Config.tooltips[tooltipName] = nil;
		o.Tooltips_UnregisterTooltip(_G[tooltipName]);
	else
		local tooltip = _G[tooltipName];
		if (tooltip ~= nil) then
			ItemTooltipIcons_Config.tooltips[tooltipName] = true;
			o.Tooltip_RegisterTooltip(tooltip);
		else
			error("Given tooltip name does not correspond to a tooltip.", 2);
		end
	end
end
