
local o = VendorValues;

-- Config_t_Init: ()
-- Config_OnEvent_VARIABLES_LOADED: ()
-- Config_HandleSlashCmd_SetRGB: (args)
--
-- Config_SetPrefixText: (text)
-- Config_SetPrefixStackText: (text)
-- Config_ToggleHidePrefix: (enabled)
-- Config_ToggleHideSeparator: (enabled)
-- Config_SetRGB: (r, g, b)

-- config = VendorValues_Config;




function o.Config_t_Init()
	o.Config_t_Init = nil;
	
	WorldFrame.onVariablesLoadedHandlers[o.Config_OnEvent_VARIABLES_LOADED] = true;
	
	local cmds = o.Localization.SLASH_COMMANDS;
	local slashInfo = {
		[cmds.PREFIX:match("^(%S+)")] = o.Config_SetPrefixText;
		[cmds.PREFIX_STACK:match("^(%S+)")] = o.Config_SetPrefixStackText;
		[cmds.HIDE_PREFIX:match("^(%S+)")] = o.Config_ToggleHidePrefix;
		[cmds.HIDE_SEPARATOR:match("^(%S+)")] = o.Config_ToggleHideSeparator;
		[cmds.RGB:match("^(%S+)")] = o.Config_HandleSlashCmd_SetRGB;
		[false] = {
			cmds.UNKNOWN;
			cmds.PREFIX;
			cmds.PREFIX_STACK;
			cmds.HIDE_PREFIX;
			cmds.HIDE_SEPARATOR;
			cmds.RGB;
		};
	};
	NicheDevTools.RegisterSlashCommand("VendorValues", slashInfo, "/veva");
end



do
	local loc_DEFAULT_PREFIX = o.Localization.DEFAULT_PREFIX;
	local loc_DEFAULT_PREFIX_STACK = o.Localization.DEFAULT_PREFIX_STACK;
	
	function o.Config_OnEvent_VARIABLES_LOADED()
		o.Config_OnEvent_VARIABLES_LOADED = nil;
		
		local config = VendorValues_Config;
		if (config == nil) then
			config = {
				prefix = nil;
				prefixStack = nil;
				hidePrefix = nil;
				hideSeparator = nil;
				textR = nil;
				textG = nil;
				textB = nil;
			};
			VendorValues_Config = config;
		else
			config.addSeparator = nil;
			if (config.textR == 1.0 and config.textG == 1.0 and config.textB == 1.0) then
				config.textR, config.textG, config.textB = nil, nil, nil;
			end
			if (config.prefix == loc_DEFAULT_PREFIX) then
				config.prefix = nil;
			end
			if (config.prefixStack == loc_DEFAULT_PREFIX_STACK) then
				config.prefixStack = nil;
			end
		end
		o.config = config;
	end
end



function o.Config_HandleSlashCmd_SetRGB(args)
	if (args ~= nil) then
		o.Config_SetRGB(args:match("^(%S+) (%S+) (%S+)$"));
	else
		o.Config_SetRGB(nil, nil, nil);
	end
end




function o.Config_SetPrefixText(text)
	o.config.prefix = ((text ~= nil and tostring(text)) or nil);
end


function o.Config_SetPrefixStackText(text)
	o.config.prefixStack = ((text ~= nil and tostring(text)) or nil);
end



function o.Config_ToggleHidePrefix(enable)
	if (enable == nil) then
		enable = (not o.config.hidePrefix);
	end
	enable = ((enable and true) or nil);
	o.config.hidePrefix = enable;
end



function o.Config_ToggleHideSeparator(enable)
	if (enable == nil) then
		enable = (not o.config.hideSeparator);
	end
	enable = ((enable and true) or nil);
	o.config.hideSeparator = enable;
end



function o.Config_SetRGB(r, g, b)
	if (r == nil and g == nil and b == nil) then
		o.config.textR, o.config.textG, o.config.textB = nil, nil, nil;
	else
		r, g, b = tonumber(r), tonumber(g), tonumber(b);
		if (r == nil or r < 0.0 or r > 1.0 or g == nil or g < 0.0 or g > 1.0 or b == nil or b < 0.0 or b > 1.0) then
			error("numbers must be between 0.0 and 1.0");
		else
			o.config.textR, o.config.textG, o.config.textB = r, g, b;
		end
	end
end
