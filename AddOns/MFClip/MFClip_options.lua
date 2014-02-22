-- local variables
local _;

MFClip.optempty = {
	cmdHidden = true,
    name = "MFClip",
    type = "group",
    args = {
    	disabled = {
    		type = "description",
    		name = "Addon disabled, enable to access current config tab.",
    	},
    },
}

MFClip.optdisabled = {
	name = "MFClip",
    type = "group",
	args = {
		enable = {
			order = 1,
			name = "Enable Addon",
			desc = "Toggle MFClip",
			type = "toggle",
			get = function(info) return MFClip.sdb.bEnabled; end,
			set = function(info,val)
				MFClip.sdb.bEnabled = val;
				MFClip:Enable( val );
			end,
			width = "full",
		},
		spec1 = {
			cmdHidden = true,
			order = 2,
			name = "Talent spec 1",
			type = "select",
			values = {
				[0] = "Do nothing",
				[1] = "Enable MFClip",
				[2] = "Disable MFClip",
			},
			get = function(info) return MFClip.sdb.iSpec1Cmd and MFClip.sdb.iSpec1Cmd or 0; end,
			set = function(info,val) MFClip.sdb.iSpec1Cmd = val; MFClip:SetStatusByTalents(); end,
			style = "dropdown",
		},
		spec2 = {
			cmdHidden = true,
			order = 3,
			name = "Talent spec 2",
			type = "select",
			values = {
				[0] = "Do nothing",
				[1] = "Enable MFClip",
				[2] = "Disable MFClip",
			},
			get = function(info) return MFClip.sdb.iSpec2Cmd and MFClip.sdb.iSpec2Cmd or 0; end,
			set = function(info,val) MFClip.sdb.iSpec2Cmd = val; MFClip:SetStatusByTalents(); end,
			style = "dropdown",
		},
		config = {
			guiHidden = true,
			order = 15,
			name = "Configure MFClip",
			desc = "Configure MFClip (GUI)",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory( MFClip.optionsFrame ); end,
		},
		configlb = {
			guiHidden = true,
			order = 16,
			name = "Configure MFClip LiveBars",
			desc = "Configure MFClip LiveBars (GUI)",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory( MFClip.LBoptionsFrame ); end,
		},
		reset = {
			guiHidden = true,
			order = 17,
			name = "Reset config",
			desc = "Reset configuratin options",
			type = "execute",
			func = function() MFClip:ResetOptions(); end,
		}
	},
}

MFClip.options = {
    name = "MFClip",
    type = 'group',
    args = {
		enable = {
			order = 1,
			name = "Enable Addon",
			desc = "Toggle MFClip",
			type = "toggle",
			get = function(info) return MFClip.sdb.bEnabled; end,
			set = function(info,val)
				MFClip.sdb.bEnabled = val;
				MFClip:Enable( val );
			end,
			width = "full",
		},
		spec1 = {
			cmdHidden = true,
			order = 2,
			name = "Talent spec 1",
			type = "select",
			values = {
				[0] = "Do nothing",
				[1] = "Enable MFClip",
				[2] = "Disable MFClip",
			},
			get = function(info) return MFClip.sdb.iSpec1Cmd and MFClip.sdb.iSpec1Cmd or 0; end,
			set = function(info,val) MFClip.sdb.iSpec1Cmd = val; MFClip:SetStatusByTalents(); end,
			style = "dropdown",
		},
		spec2 = {
			cmdHidden = true,
			order = 3,
			name = "Talent spec 2",
			type = "select",
			values = {
				[0] = "Do nothing",
				[1] = "Enable MFClip",
				[2] = "Disable MFClip",
			},
			get = function(info) return MFClip.sdb.iSpec2Cmd and MFClip.sdb.iSpec2Cmd or 0; end,
			set = function(info,val) MFClip.sdb.iSpec2Cmd = val; MFClip:SetStatusByTalents(); end,
			style = "dropdown",
		},
		ct = {
			cmdHidden = true,
			order = 10,
			name = "Generate Combat Text",
			desc = "Generate Combat Text (SCT/MSBT)",
			type = "toggle",
			get = function(info) return MFClip.sdb.bCT; end,
			set = function(info,val) MFClip.sdb.bCT = val; end,
		},
		sound = {
			cmdHidden = true,
			order = 9,
			name = "Play Sound",
			desc = "Play sound when clipping",
			type = "toggle",
			get = function(info) return MFClip.sdb.bSound; end,
			set = function(info,val) MFClip.sdb.bSound = val; end,
		},
		desc1 = {
			order = 4,
			name = "WfCL adjusts the time MFClip waits for still expected Combat Log Data (Mind Flay ticks). Can be auto adjusted (which is necessary for high haste situations). Adjust the clipping warning if needed.",
			type = "description",
		},
		waitcl = {
			cmdHidden = true,
			order = 5,
			name = "Wait for Combat Log [ms]",
			desc = "Wait for remaining Mind Flay tick [ms]",
			type = "range",
			min = 0,
			max = 1500,
			step = 20,
			bigStep = 20,
			get = function(info) return MFClip.sdb.fWFCL; end,
			set = function(info,val) MFClip.sdb.fWFCL = val; end,
			isPercent = false,
		},
		clipwarn = {
			cmdHidden = true,
			order = 6,
			name = "Clipping warning [ms]",
			desc = "Warn when clipping before Mind Flay tick [ms]",
			type = "range",
			min = 0,
			max = 500,
			step = 20,
			bigStep = 20,
			get = function(info) return MFClip.sdb.fUCW; end,
			set = function(info,val) MFClip.sdb.fUCW = val; end,
			isPercent = false,
		},
		desc2 = {
			order = 8,
			name = "Settings for clipping warning sound and combat text output.",
			type = "description",
		},
		soundname = {
			cmdHidden = true,
			order = 11,
			name = "Sound file",
			desc = "Set sound file to be played on MF Clip",
			type = "input",
			get = function(info) return MFClip.sdb.strSound; end,
			set = function(info,val) MFClip.sdb.strSound = val; end,
		},
		ctsel = {
			cmdHidden = true,
			order = 12,
			name = "Select Combat Text",
			desc = "Select Combat Text to be used for MF ticks",
			type = "select",
			values = {
				["Blizzard"] = "Blizzard's Floating Combat Text",
				["MSBT"] = "Mik's Scrolling Battle Text",
				["SCT"] = "Scrolling Combat Text",
				["Parrot"] = "Parrot",
			},
			get = function(info) return MFClip.sdb.strCT; end,
			set = function(info,val) MFClip.sdb.strCT = val; end,
			style = "dropdown",
		},
		config = {
			guiHidden = true,
			order = 15,
			name = "Configure MFClip",
			desc = "Configure MFClip (GUI)",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory( MFClip.optionsFrame ); end,
		},
		configlb = {
			guiHidden = true,
			order = 16,
			name = "Configure MFClip LiveBars",
			desc = "Configure MFClip LiveBars (GUI)",
			type = "execute",
			func = function() InterfaceOptionsFrame_OpenToCategory( MFClip.LBoptionsFrame ); end,
		},
		reset = {
			guiHidden = true,
			order = 17,
			name = "Reset config",
			desc = "Reset configuratin options",
			type = "execute",
			func = function() MFClip:ResetOptions(); end,
		},
	},
}

MFClip.seltab = {
	["Spell"] = "Spellname",
	["Ticks"] = "Number of ticks",
	["Hits"] = "Number of hits",
	["Crits"] = "Number of crits",
	["HitsCrits"] = "Count of hits&crits",
	["Dmg"] = "Damage done",
	["Clip"] = "Clipped",
	["Static"] = "Static text",
}

MFClip.options_stats = {
	name = "Statistics",
	type = "group",
	cmdHidden = true,
	args = {
		comdata = {
			cmdHidden = true,
			order = 1,
			name = "Generate combat data",
			desc = "Generate combat data at end of fight",
			type = "toggle",
			get = function(info) return MFClip.sdb.bShowCombat; end,
			set = function(info,val) MFClip.sdb.bShowCombat = val; end,
		},
		minfightlen = {
			cmdHidden = true,
			order = 2,
			name = "Minimum fight length for Combat Data [s]",
			desc = "Set the time you must be infight for Combat Data to be generated [s]",
			type = "range",
			min = 10,
			max = 120,
			step = 1,
			bigStep = 5,
			get = function(info) return MFClip.sdb.fmFL; end,
			set = function(info,val) MFClip.sdb.fmFL = val; end,
			isPercent = false,
		},
		desc3 = {
			order = 3,
			name = "Select combat data to be generated.",
			type = "description",
		},
		mfts = {
			cmdHidden = true,
			order = 4,
			name = "Mind Flay tick statistics",
			desc = "Generate Mind Flay tick statistics containing hit, crit and clipped ticks",
			type = "toggle",
			get = function(info) return MFClip.sdb.bMFTS; end,
			set = function(info,val) MFClip.sdb.bMFTS = val; end,
		},
		mfce = {
			cmdHidden = true,
			order = 5,
			name = "Mind Flay casting estimations",
			desc = "Generate ouput containing Mind Flay channeling time, effective Mind Flay casting and DPS estimations for Mind Flay casting only",
			type = "toggle",
			get = function(info) return MFClip.sdb.bMFCE; end,
			set = function(info,val) MFClip.sdb.bMFCE = val; end,
		},
		mfclipds = {
			cmdHidden = true,
			order = 6,
			name = "Generate Dot statistics",
			desc = "Containing Uptime (after first application) and DPS estimations, also for DPS loss due to lower than 100% uptime (Multi Mob)",
			type = "toggle",
			get = function(info) return MFClip.sdb.bMFDS; end,
			set = function(info,val) MFClip.sdb.bMFDS = val; end,
		},
		mindotcount = {
			cmdHidden = true,
			order = 7,
			name = "Minimum amount of dot ticks to show",
			desc = "Set the minimum amount of dot ticks required for dot statistics",
			type = "range",
			min = 5,
			max = 50,
			step = 1,
			bigStep = 5,
			get = function(info) return MFClip.sdb.fMinDotCount; end,
			set = function(info,val) MFClip.sdb.fMinDotCount = val; end,
			isPercent = false,
		},
		outldbonly = {
			cmdHidden = true,
			order = 8,
			name = "Output to LibDataBroker only",
			desc = "Generate only LibDataBroker output, prevents MFClip from writing statistics to your chatframe.",
			type = "toggle",
			get = function(info) return MFClip.sdb.bLDBOutputOnly; end,
			set = function(info,val) MFClip.sdb.bLDBOutputOnly = val; end,
			width = "full",
		},
	}
}

MFClip.options_lbuttons = {
	name = "LiveButtons",
	type = "group",
	cmdHidden = true,
	args = {

	}
}

MFClip.options_lb = {
	name = "LiveBars",
	type = "group",
	cmdHidden = true,
	args = {
		lboocconf = {
			order = 1,
			name = "Out of combat config",
			desc = "Out of combat LiveBars configuration.\n\nOptions:\non|off...enables|disables LiveBars\ncast...enables castbar\nmb|swd...enables MB|SW:D cooldown bar\nvt|dp|swp...enables VT|DP|SW:P dottimer\nhidecb|showcb...hides|shows castbar when not casting\nbuttons...activates LiveButtons",
			type = "input",
			get = function(info) return MFClip.sdb.strLBooCconf; end,
			set = function(info,val)
				MFClip.sdb.strLBooCconf = val;
				if( not MFClip.logData ) then MFClip:SetLBConfig( MFClip.sdb.strLBooCconf ); end
			end,
			width = "full",
		},
		lbincconf = {
			order = 2,
			name = "In combat config",
			desc = "In combat LiveBars configuration.\n\nOptions:\non|off...enables|disables LiveBars\ncast...enables castbar\nmb|swd...enables MB|SW:D cooldown bar\nvt|dp|swp...enables VT|DP|SW:P dottimer\nhidecb|showcb...hides|shows castbar when not casting\nbuttons...activates LiveButtons",
			type = "input",
			get = function(info) return MFClip.sdb.strLBinCconf; end,
			set = function(info,val)
				MFClip.sdb.strLBinCconf = val;
				if( MFClip.logData ) then MFClip:SetLBConfig( MFClip.sdb.strLBinCconf ); end
			end,
			width = "full",
		},
		lbanchor = {
			cmdHidden = true,
			order = 3,
			name = "Show movable anchor",
			desc = "Show movable anchor to move bars around",
			type = "toggle",
			get = function(info) return MFClip.sdb.bShowAnchor; end,
			set = function(info,val)
				MFClip.sdb.bShowAnchor = val;
				MFClip:ShowAnchor( val );
				MFClip:ShowLiveButtons( true );
			end,
		},
		lbhideblizz = {
			cmdHidden = true,
			order = 5,
			name = "Hide Blizzard castbar",
			desc = "Hide Blizzard castbar.",
			type = "toggle",
			get = function(info) return MFClip.sdb.bHideBlizzCB; end,
			set = function(info,val)
				MFClip.sdb.bHideBlizzCB = val;
				MFClip:HideBlizzardCastbar( val );
			end,
		},
		lbhidevehicle = {
			cmdHidden = true,
			order = 6,
			name = "Hide Livebars while in vehicle",
			type = "toggle",
			get = function(info) return MFClip.sdb.bHideInVehicle; end,
			set = function(info,val)
				MFClip.sdb.bHideInVehicle = val;
			end,
			width = "full",
		},
		lbhideuptime = {
			cmdHidden = true,
			order = 7,
			name = "Hide LiveBars Uptime & DPS details",
			type = "toggle",
			get = function(info) return MFClip.sdb.bHideLBDetails; end,
			set = function(info,val)
				MFClip.sdb.bHideLBDetails = val;
				MFClip:ResizeLBBars();
			end,
			width = "full",
		},
		lbheight = {
			cmdHidden = true,
			order = 8,
			name = "Height of LiveBars",
			desc = "Set height of LiveBars",
			type = "range",
			min = 0,
			max = 100,
			step = 2,
			bigStep = 2,
			get = function(info) return MFClip.sdb.fLBHeight; end,
			set = function(info,val)
				MFClip.sdb.fLBHeight = val;
				MFClip:ResizeLBBars();
			end,
			isPercent = false,
		},
		lbwidth = {
			cmdHidden = true,
			order = 9,
			name = "Width of LiveBars",
			desc = "Set width of LiveBars",
			type = "range",
			min = 0,
			max = 1000,
			step = 2,
			bigStep = 10,
			get = function(info) return MFClip.sdb.fLBWidth; end,
			set = function(info,val)
				MFClip.sdb.fLBWidth = val;
				MFClip:ResizeLBBars();
			end,
			isPercent = false,
		},
		lbscale = {
			cmdHidden = true,
			order = 10,
			name = "Scale of LiveBars",
			desc = "Set scale of LiveBars",
			type = "range",
			min = 0.1,
			max = 3,
			step = 0.05,
			bigStep = 0.1,
			get = function(info) return MFClip.sdb.fLBScale; end,
			set = function(info,val)
				MFClip.sdb.fLBScale = val;
				MFClip:ResizeLBBars();
			end,
			isPercent = false,
		},
		lblat = {
			cmdHidden = true,
			order = 11,
			name = "Latency bar length",
			desc = "Maximum length of latency bar in % of total castbar.",
			type = "range",
			min = 0.05,
			max = 0.5,
			step = 0.01,
			bigStep = 0.01,
			get = function(info) return MFClip.sdb.fLBmax; end,
			set = function(info,val) MFClip.sdb.fLBmax = val; end,
			isPercent = true,
		},
		lbzoom = {
			cmdHidden = true,
			order = 12,
			name = "Zoom dot timer [s]",
			desc = "Zoom dot timer when remaining dot uptime falls below given value. (0=no zoom)",
			type = "range",
			min = 0,
			max = 10,
			step = 1,
			bigStep = 1,
			get = function(info) return MFClip.sdb.iZoom; end,
			set = function(info,val) MFClip.sdb.iZoom = val; end,
			isPercent = false,
		},
		lbbordersize = {
			cmdHidden = true,
			order = 13,
			name = "Border size",
			desc = "LiveBars border size",
			type = "range",
			min = 0,
			max = 5,
			step = 0.1,
			bigStep = 0.1,
			get = function(info) return MFClip.sdb.fLBBorder; end,
			set = function(info,val)
				MFClip.sdb.fLBBorder = val;
				MFClip:ResizeLBBars();
			end,
			isPercent = false,
		},
		lbspacing = {
			cmdHidden = true,
			order = 14,
			name = "Spacing",
			desc = "Spacing, i.e. distance between bars.",
			type = "range",
			min = -5,
			max = 20,
			step = 1,
			bigStep = 1,
			get = function(info) return MFClip.sdb.fLBSpacing; end,
			set = function(info,val)
				MFClip.sdb.fLBSpacing = val;
				MFClip:INCLBConf( MFClip.sdb.strLBinCconf );
				MFClip:OOCLBConf( MFClip.sdb.strLBooCconf );
			end,
			isPercent = false,
		},
		showsparkforall = {
			cmdHidden = true,
			order = 15,
			name = "Show castbar spark for all bars (otherwise castbar only)",
			type = "toggle",
			get = function(info) return MFClip.sdb.bShowSparkForAll and MFClip.sdb.bShowSparkForAll or false; end,
			set = function(info,val)
				MFClip.sdb.bShowSparkForAll = val;
				MFClip:ResizeLBBars();
			end,
			width = "full",
		},
		sparkheight = {
			order = 16,
			name = "Height of castbar spark",
			type = "range",
			min = 0, max = 5,
			step = 0.05, bigStep = 0.05,
			get = function(info) return MFClip.sdb.fSparkHeightMulti; end,
			set = function(info,val)
				MFClip.sdb.fSparkHeightMulti = val;
				MFClip:ResizeLBBars();
			end,
			isPercent = true,
		},
		sparkwidth = {
			order = 17,
			name = "Width of castbar spark",
			type = "range",
			min = 0, max = 5,
			step = 0.05, bigStep = 0.05,
			get = function(info) return MFClip.sdb.fSparkWidthMulti; end,
			set = function(info,val)
				MFClip.sdb.fSparkWidthMulti = val;
				MFClip:ResizeLBBars();
			end,
			isPercent = true,
		},
		lbbartexture = {
			cmdHidden = true,
			order = 18,
			name = "Bar texture",
			desc = "LiveBars bar texture (using LibSharedMedia if available)",
			type = "select",
			dialogControl = "LSM30_Statusbar",
			values = AceGUIWidgetLSMlists.statusbar,
			get = function(info) return MFClip.sdb.lbtexture; end,
			set = function(info,val)
				if( val and val ~= "" ) then
					MFClip.sdb.lbtexture = val;
					MFClip:SetBarColors();
				end
			end,
			style = "dropdown",
			width = "full",
		},
		font = {
			order = 19,
			name = "Font",
			type = "select",
			dialogControl = "LSM30_Font",
			values = AceGUIWidgetLSMlists.font,
			get = function(info) return MFClip.sdb.font; end,
			set = function(info,val) MFClip.sdb.font = val; MFClip:ResizeLBBars(); MFClip:ResizeLButtons(); end,
			style = "dropdown",
			width = "full",
		},
		lbbarbgcolor = {
			cmdHidden = true,
			order = 20,
			name = "Bar background color",
			desc = "LiveBars bar background color",
			type = "color",
			get = function(info) return unpack( MFClip.sdb.lbbarbgcolor ); end,
			set = function(info,r,g,b,a)
				MFClip.sdb.lbbarbgcolor = { r, g, b, a };
				MFClip:SetBarColors();
			end,
			hasAlpha = true,
		},
		lbbarbgcolor_text = {
			order = 21,
			name = "",
			type = "input",
			get = function(info) return MFClip:CreateColorString( unpack( MFClip.sdb.lbbarbgcolor ) ) end,
			set = function(info,val)
				local r, g, b, a = MFClip:GetColorsFromString( val );
				if( r ) then
					MFClip.sdb.lbbarbgcolor = { r, g, b, a };
					MFClip:SetBarColors();
				end
			end,
		},
		lbbarcolor = {
			cmdHidden = true,
			order = 22,
			name = "Bar color",
			desc = "LiveBars bar color",
			type = "color",
			get = function(info) return unpack( MFClip.sdb.lbbarcolor ); end,
			set = function(info,r,g,b,a)
				MFClip.sdb.lbbarcolor = { r, g, b, a };
				MFClip:SetBarColors();
			end,
			hasAlpha = true,
		},
		lbbarcolor_text = {
			order = 23,
			name = "",
			type = "input",
			get = function(info) return MFClip:CreateColorString( unpack( MFClip.sdb.lbbarcolor ) ) end,
			set = function(info,val)
				local r, g, b, a = MFClip:GetColorsFromString( val );
				if( r ) then
					MFClip.sdb.lbbarcolor = { r, g, b, a };
					MFClip:SetBarColors();
				end
			end,
		},
		lbbordercolor = {
			cmdHidden = true,
			order = 24,
			name = "Border color",
			desc = "LiveBars border color",
			type = "color",
			get = function(info) return unpack( MFClip.sdb.lbbordercolor ); end,
			set = function(info,r,g,b,a)
				MFClip.sdb.lbbordercolor = { r, g, b, a };
				MFClip:SetBarColors();
			end,
			hasAlpha = true,
		},
		lbbordercolor_text = {
			order = 25,
			name = "",
			type = "input",
			get = function(info) return MFClip:CreateColorString( unpack( MFClip.sdb.lbbordercolor ) ) end,
			set = function(info,val)
				local r, g, b, a = MFClip:GetColorsFromString( val );
				if( r ) then
					MFClip.sdb.lbbordercolor = { r, g, b, a };
					MFClip:SetBarColors();
				end
			end,
		},
		lblagcolor = {
			cmdHidden = true,
			order = 26,
			name = "Bar latency color",
			desc = "LiveBars bar latency color",
			type = "color",
			get = function(info) return unpack( MFClip.sdb.lblagcolor ); end,
			set = function(info,r,g,b,a)
				MFClip.sdb.lblagcolor = { r, g, b, a };
				MFClip:SetBarColors();
			end,
			hasAlpha = true,
		},
		lblagcolor_text = {
			order = 27,
			name = "",
			type = "input",
			get = function(info) return MFClip:CreateColorString( unpack( MFClip.sdb.lblagcolor ) ) end,
			set = function(info,val)
				local r, g, b, a = MFClip:GetColorsFromString( val );
				if( r ) then
					MFClip.sdb.lblagcolor = { r, g, b, a };
					MFClip:SetBarColors();
				end
			end,
		},
		lbtextcolor = {
			cmdHidden = true,
			order = 28,
			name = "Text color",
			desc = "LiveBars text color",
			type = "color",
			get = function(info) return unpack( MFClip.sdb.lbtextcolor ); end,
			set = function(info,r,g,b,a)
				MFClip.sdb.lbtextcolor = { r, g, b, a };
				MFClip:SetBarColors();
			end,
			hasAlpha = true,
		},
		lbtextcolor_text = {
			order = 29,
			name = "",
			type = "input",
			get = function(info) return MFClip:CreateColorString( unpack( MFClip.sdb.lbtextcolor ) ) end,
			set = function(info,val)
				local r, g, b, a = MFClip:GetColorsFromString( val );
				if( r ) then
					MFClip.sdb.lbtextcolor = { r, g, b, a };
					MFClip:SetBarColors();
				end
			end,
		},
		sparkcolor = {
			cmdHidden = true,
			order = 30,
			name = "Spark color",
			desc = "LiveBars castbar spark color",
			type = "color",
			get = function(info) return unpack( MFClip.sdb.sparkcolor ); end,
			set = function(info,r,g,b,a)
				MFClip.sdb.sparkcolor = { r, g, b, a };
				MFClip:SetBarColors();
			end,
			hasAlpha = true,
		},
		sparkcolor_text = {
			order = 31,
			name = "",
			type = "input",
			get = function(info) return MFClip:CreateColorString( unpack( MFClip.sdb.sparkcolor ) ) end,
			set = function(info,val)
				local r, g, b, a = MFClip:GetColorsFromString( val );
				if( r ) then
					MFClip.sdb.sparkcolor = { r, g, b, a };
					MFClip:SetBarColors();
				end
			end,
		},
		lbuttonsconf = {
			order = 43,
			name = "LiveButtons configuration",
			desc = "LiveButtons configuration.\n\nOptions:\ncombat: shows buttons in combat only\nmf|mb|vt|dp|swp|swd|su: enables MF|MB|VT|DP|SW:P|SW:D|Shackle Undead button\n\nrow: show buttons as row",
			type = "input",
			get = function(info) return MFClip.sdb.strLButtons; end,
			set = function(info,val)
				MFClip.sdb.strLButtons = val;
				MFClip:SetLButtonsConfig( MFClip.sdb.strLButtons );
			end,
			width = "full",
		},
		lbuttonsscale = {
			cmdHidden = true,
			order = 44,
			name = "Scale of LiveButtons",
			desc = "Set scale of LiveButtons",
			type = "range",
			min = 0.1,
			max = 3,
			step = 0.05,
			bigStep = 0.1,
			get = function(info) return MFClip.sdb.fLButtonsScale; end,
			set = function(info,val)
				MFClip.sdb.fLButtonsScale = val;
				MFClip:ResizeLButtons();
			end,
			isPercent = false,
		},
	}
}
MFClip.options_ct = {
	name = "CombatText",
	type = "group",
	cmdHidden = true,
	args = {
		general = {
			order = 1,
			name = "General",
			type = "group",
			args = {
				sticky = {
					order = 1,
					name = "Sticky clips",
					type = "toggle",
					get = function(info) return MFClip.sdb.bSticky; end,
					set = function(info,val) MFClip.sdb.bSticky = val; end,
				},
				showicon = {
					order = 2,
					name = "Show spell icon",
					type = "toggle",
					get = function(info) return MFClip.sdb.bShowIcon; end,
					set = function(info,val) MFClip.sdb.bShowIcon = val; end,
				},
				fontsizec = {
					order = 3,
					name = "Font size (clip)",
					desc = "Font size (0=default)",
					type = "range",
					min = 0,
					max = 50,
					step = 1,
					bigStep = 1,
					get = function(info) return MFClip.sdb.iFontsizeClip; end,
					set = function(info,val) MFClip.sdb.iFontsizeClip = val; end,
					isPercent = false,
				},
				fontsizenc = {
					order = 4,
					name = "Font size (non clip)",
					desc = "Font size (0=default)",
					type = "range",
					min = 0,
					max = 50,
					step = 1,
					bigStep = 1,
					get = function(info) return MFClip.sdb.iFontsizeNonClip; end,
					set = function(info,val) MFClip.sdb.iFontsizeNonClip = val; end,
					isPercent = false,
				},
				fontoutlinec = {
					order = 5,
					name = "Font outline (clip)",
					desc = "Font outline (clip). MSBT only.",
					type = "select",
					values = {
						[0] = "Default",
						[1] = "None",
						[2] = "Thin",
						[3] = "Thick",
					},
					get = function(info) return MFClip.sdb.iFontoutlineClip; end,
					set = function(info,val) MFClip.sdb.iFontoutlineClip = val; end,
					style = "dropdown",
				},
				fontoutlinenc = {
					order = 6,
					name = "Font outline (non clip)",
					desc = "Font outline (non clip). MSBT only.",
					type = "select",
					values = {
						[0] = "Default",
						[1] = "None",
						[2] = "Thin",
						[3] = "Thick",
					},
					get = function(info) return MFClip.sdb.iFontoutlineNonClip; end,
					set = function(info,val) MFClip.sdb.iFontoutlineNonClip = val; end,
					style = "dropdown",
				},
			},
		},
		firstarg = {
			order = 2,
			name = "1st",
			type = "group",
			args = {
				descript = {
					order = 1,
					name = "Description",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFirstDesc; end,
					set = function(info,val) MFClip.sdb.strSelFirstDesc = val; end,
				},
				presel = {
					order = 2,
					name = "Display",
					desc = "Display text/type/text",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFirstPre; end,
					set = function(info,val) MFClip.sdb.strSelFirstPre = val; end,
				},
				sel = {
					order = 3,
					name = "",
					type = "select",
					values = MFClip.seltab,
					get = function(info) return MFClip.sdb.strSelFirst; end,
					set = function(info,val) MFClip.sdb.strSelFirst = val; end,
					style = "dropdown",
				},
				postsel = {
					order = 4,
					name = "",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFirstPost; end,
					set = function(info,val) MFClip.sdb.strSelFirstPost = val; end,
				},
				fixedsel = {
					order = 5,
					name = "Static string",
					desc = "Display static string for (any) selected type",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFirstFixed; end,
					set = function(info,val) MFClip.sdb.strSelFirstFixed = val; end,
				},
				colorsel = {
					order = 6,
					name = "Textcolor",
					type = "color",
					get = function(info) return MFClip:GetRGBA( MFClip.sdb.strSelFirstColor ); end,
					set = function(info,r,g,b,a) MFClip.sdb.strSelFirstColor = MFClip:SetRGBA(r,g,b,a); end,
					hasAlpha = false,
				},
			},
		},
		secondarg = {
			order = 3,
			name = "2nd",
			type = "group",
			args = {
				descript = {
					order = 1,
					name = "Description",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSecondDesc; end,
					set = function(info,val) MFClip.sdb.strSelSecondDesc = val; end,
				},
				presel = {
					order = 2,
					name = "Display",
					desc = "Display text/type/text",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSecondPre; end,
					set = function(info,val) MFClip.sdb.strSelSecondPre = val; end,
				},
				sel = {
					order = 3,
					name = "",
					type = "select",
					values = MFClip.seltab,
					get = function(info) return MFClip.sdb.strSelSecond; end,
					set = function(info,val) MFClip.sdb.strSelSecond = val; end,
					style = "dropdown",
				},
				postsel = {
					order = 4,
					name = "",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSecondPost; end,
					set = function(info,val) MFClip.sdb.strSelSecondPost = val; end,
				},
				fixedsel = {
					order = 5,
					name = "Static string",
					desc = "Display static string for (any) selected type",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSecondFixed; end,
					set = function(info,val) MFClip.sdb.strSelSecondFixed = val; end,
				},
				colorsel = {
					order = 6,
					name = "Textcolor",
					type = "color",
					get = function(info) return MFClip:GetRGBA( MFClip.sdb.strSelSecondColor ); end,
					set = function(info,r,g,b,a) MFClip.sdb.strSelSecondColor = MFClip:SetRGBA(r,g,b,a); end,
					hasAlpha = false,
				},
			},
		},
		thirdarg = {
			order = 4,
			name = "3rd",
			type = "group",
			args = {
				descript = {
					order = 1,
					name = "Description",
					type = "input",
					get = function(info) return MFClip.sdb.strSelThirdDesc; end,
					set = function(info,val) MFClip.sdb.strSelThirdDesc = val; end,
				},
				presel = {
					order = 2,
					name = "Display",
					desc = "Display text/type/text",
					type = "input",
					get = function(info) return MFClip.sdb.strSelThirdPre; end,
					set = function(info,val) MFClip.sdb.strSelThirdPre = val; end,
				},
				sel = {
					order = 3,
					name = "",
					type = "select",
					values = MFClip.seltab,
					get = function(info) return MFClip.sdb.strSelThird; end,
					set = function(info,val) MFClip.sdb.strSelThird = val; end,
					style = "dropdown",
				},
				postsel = {
					order = 4,
					name = "",
					type = "input",
					get = function(info) return MFClip.sdb.strSelThirdPost; end,
					set = function(info,val) MFClip.sdb.strSelThirdPost = val; end,
				},
				fixedsel = {
					order = 5,
					name = "Static string",
					desc = "Display static string for (any) selected type",
					type = "input",
					get = function(info) return MFClip.sdb.strSelThirdFixed; end,
					set = function(info,val) MFClip.sdb.strSelThirdFixed = val; end,
				},
				colorsel = {
					order = 6,
					name = "Textcolor",
					type = "color",
					get = function(info) return MFClip:GetRGBA( MFClip.sdb.strSelThirdColor ); end,
					set = function(info,r,g,b,a) MFClip.sdb.strSelThirdColor = MFClip:SetRGBA(r,g,b,a); end,
					hasAlpha = false,
				},
			},
		},
		fourtharg = {
			order = 5,
			name = "4th",
			type = "group",
			args = {
				descript = {
					order = 1,
					name = "Description",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFourthDesc; end,
					set = function(info,val) MFClip.sdb.strSelFourthDesc = val; end,
				},
				presel = {
					order = 2,
					name = "Display",
					desc = "Display text/type/text",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFourthPre; end,
					set = function(info,val) MFClip.sdb.strSelFourthPre = val; end,
				},
				sel = {
					order = 3,
					name = "",
					type = "select",
					values = MFClip.seltab,
					get = function(info) return MFClip.sdb.strSelFourth; end,
					set = function(info,val) MFClip.sdb.strSelFourth = val; end,
					style = "dropdown",
				},
				postsel = {
					order = 4,
					name = "",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFourthPost; end,
					set = function(info,val) MFClip.sdb.strSelFourthPost = val; end,
				},
				fixedsel = {
					order = 5,
					name = "Static string",
					desc = "Display static string for (any) selected type",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFourthFixed; end,
					set = function(info,val) MFClip.sdb.strSelFourthFixed = val; end,
				},
				colorsel = {
					order = 6,
					name = "Textcolor",
					type = "color",
					get = function(info) return MFClip:GetRGBA( MFClip.sdb.strSelFourthColor ); end,
					set = function(info,r,g,b,a) MFClip.sdb.strSelFourthColor = MFClip:SetRGBA(r,g,b,a); end,
					hasAlpha = false,
				},
			},
		},
		fiftharg = {
			order = 6,
			name = "5th",
			type = "group",
			args = {
				descript = {
					order = 1,
					name = "Description",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFifthDesc; end,
					set = function(info,val) MFClip.sdb.strSelFifthDesc = val; end,
				},
				presel = {
					order = 2,
					name = "Display",
					desc = "Display text/type/text",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFifthPre; end,
					set = function(info,val) MFClip.sdb.strSelFifthPre = val; end,
				},
				sel = {
					order = 3,
					name = "",
					type = "select",
					values = MFClip.seltab,
					get = function(info) return MFClip.sdb.strSelFifth; end,
					set = function(info,val) MFClip.sdb.strSelFifth = val; end,
					style = "dropdown",
				},
				postsel = {
					order = 4,
					name = "",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFifthPost; end,
					set = function(info,val) MFClip.sdb.strSelFifthPost = val; end,
				},
				fixedsel = {
					order = 5,
					name = "Static string",
					desc = "Display static string for (any) selected type",
					type = "input",
					get = function(info) return MFClip.sdb.strSelFifthFixed; end,
					set = function(info,val) MFClip.sdb.strSelFifthFixed = val; end,
				},
				colorsel = {
					order = 6,
					name = "Textcolor",
					type = "color",
					get = function(info) return MFClip:GetRGBA( MFClip.sdb.strSelFifthColor ); end,
					set = function(info,r,g,b,a) MFClip.sdb.strSelFifthColor = MFClip:SetRGBA(r,g,b,a); end,
					hasAlpha = false,
				},
			},
		},
		sixtharg = {
			order = 7,
			name = "6th",
			type = "group",
			args = {
				descript = {
					order = 1,
					name = "Description",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSixthDesc; end,
					set = function(info,val) MFClip.sdb.strSelSixthDesc = val; end,
				},
				presel = {
					order = 2,
					name = "Display",
					desc = "Display text/type/text",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSixthPre; end,
					set = function(info,val) MFClip.sdb.strSelSixthPre = val; end,
				},
				sel = {
					order = 3,
					name = "",
					type = "select",
					values = MFClip.seltab,
					get = function(info) return MFClip.sdb.strSelSixth; end,
					set = function(info,val) MFClip.sdb.strSelSixth = val; end,
					style = "dropdown",
				},
				postsel = {
					order = 4,
					name = "",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSixthPost; end,
					set = function(info,val) MFClip.sdb.strSelSixthPost = val; end,
				},
				fixedsel = {
					order = 5,
					name = "Static string",
					desc = "Display static string for (any) selected type",
					type = "input",
					get = function(info) return MFClip.sdb.strSelSixthFixed; end,
					set = function(info,val) MFClip.sdb.strSelSixthFixed = val; end,
				},
				colorsel = {
					order = 6,
					name = "Textcolor",
					type = "color",
					get = function(info) return MFClip:GetRGBA( MFClip.sdb.strSelSixthColor ); end,
					set = function(info,r,g,b,a) MFClip.sdb.strSelSixthColor = MFClip:SetRGBA(r,g,b,a); end,
					hasAlpha = false,
				},
			},
		},
	},
}
