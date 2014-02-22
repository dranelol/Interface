--[[

Preform AV Enabler (c) Torrid of torridreflections.com

AUTHOR CONTACT INFORMATION

I can be reached at torrid@torridreflections.com, or user name Torrid at curse.com.


SOFTWARE LICENSE

You MAY:

* Run this software in your World of Warcraft client.
* Distribute this software PRIVATELY to individuals so long that it remains UNALTERED and free of charge.

You MAY NOT:

* Upload this software or derivatives of it to PUBLIC websites.
* Distribute altered copies of this file to ANYBODY.

]]

PreformAVEnablerConfig = {};

if ( not PreformAVEnabler ) then
	PreformAVEnabler = {};
end
local pave = PreformAVEnabler;
pave.config = PreformAVEnablerConfig;
local config = pave.config;
if ( not pave.events ) then
	pave.events = {};
end

---------------------------------------------------------------------------------
--	Default Configuration
---------------------------------------------------------------------------------
pave.configDefaults =
{
	hideColumn = {},		-- which columns are hidden/minimized
	hideInfoColumn = false,
	sizeLimit = false,		-- maximum window size set by user click dragging the bottom of the frame
	buttonize = false,		-- create raid unit buttons or not
	debug = false,
	threshold = 30;
	redrawRate = 1,
	autoCompact = true,
};
for i = 1, pave.NUM_BGS do
	pave.configDefaults.hideColumn[i] = false;
end



---------------------------------------------------------------------------------
--	Configuration Functions
---------------------------------------------------------------------------------

-- ensure user has all config variables set or reset to defaults
function pave.CheckConfig(defaults, config, restoreDefaults)

	for k, v in pairs(defaults) do
		if ( type(v) == "table" ) then
			if ( not config[k] ) then
				config[k] = {};
			end
			pave.CheckConfig(v, config[k], restoreDefaults);

		elseif ( type(config[k]) == "nil" or restoreDefaults ) then
			config[k] = v;
		end
	end
end
pave.CheckConfig(pave.configDefaults, config);

function pave.ApplyConfig()
	for i = 1, pave.NUM_BGS do
		if ( config.hideColumn[i] or config.autoCompact ) then
			pave.HideBGColumn(i);
		end
	end

	if ( config.hideInfoColumn ) then
		pave.HideInfoColumn();
	end

	if ( config.buttonize ) then
		pave.EnableRaidButtons();
	end

	pave.SetMasterFrameHeight();

	if ( config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("Preform AV Enabler Debug output is on.  Type "..PREFORM_AV_ENABLER_CMD.." debug to turn it off.", 0, 1, 1);
	end
end

function pave.events.VARIABLES_LOADED()

	pave.config = PreformAVEnablerConfig;
	config = pave.config;

	pave.CheckConfig(pave.configDefaults, config);
	pave.ApplyConfig();
end
