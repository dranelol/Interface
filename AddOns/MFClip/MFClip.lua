-- Ace3
MFClip = LibStub( "AceAddon-3.0" ):NewAddon( "MFClip", "AceConsole-3.0", "AceEvent-3.0" );

-- LibSharedMedia
MFClip.lsm = LibStub( "LibSharedMedia-3.0", 1 );
MFClip.smw = LibStub( "AceGUISharedMediaWidgets-1.0" );

if( MFClip.lsm ) then
	MFClip.lsm:Register( "statusbar", "Waterline", "Interface\\Addons\\MFClip\\Textures\\Waterline" );
	MFClip.lsm:Register( "font", "Desyrel", "Interface\\Addons\\MFClip\\Fonts\\DESYREL_.ttf" );
end

-- local functions
local GetTime = GetTime;
local GetSpellInfo = GetSpellInfo;
local GetSpellCooldown = GetSpellCooldown;
local UnitCastingInfo = UnitCastingInfo;
local UnitChannelInfo = UnitChannelInfo;
local UnitName = UnitName;
local UnitIsDead = UnitIsDead;
local tonumber = tonumber;
local pairs = pairs;
local type = type;
local min = min;
local string_format = string.format;
local string_sub = string.sub;
local string_len = string.len;
local string_match = string.match;
local table_remove = table.remove;
local table_insert = table.insert;

-- local variables
local _;

-- castbar events (taken over from Gnosis)
MFClip.tCastbarEvents = {
	"UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_CHANNEL_STOP",
	"UNIT_SPELLCAST_CHANNEL_UPDATE",
	"UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_STOP",
	"UNIT_SPELLCAST_DELAYED",
	"UNIT_SPELLCAST_INTERRUPTIBLE",
	"UNIT_SPELLCAST_NOT_INTERRUPTIBLE",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_FAILED_QUIET",
	"UNIT_SPELLCAST_SUCCEEDED"
};

MFClip.tMiscEvents = {
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"UNIT_SPELLCAST_SENT",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_FOCUS_CHANGED",
	"PLAYER_TARGET_CHANGED",
};

function MFClip:Enable( val )
	if( val == true ) then
		self:Print( "Addon enabled" );
		self:RegisterCastEvents();
		self:ShowLiveBars( true );
		self:ShowLiveButtons( true );

		if( self.sdb.bHideBlizzCB ) then
			MFClip:HideBlizzardCastbar( true );
		end

		LibStub("AceConfig-3.0"):RegisterOptionsTable( "MFClip", self.options, "mfclip" );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip CombatText", self.options_ct );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip Statistics", self.options_stats );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveBars", self.options_lb );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveButtons", self.options_lbuttons );
	else
		MFClip:Print( "Addon disabled" );
		MFClip:UnregisterCastEvents();
		MFClip:ShowLiveBars( false );
		self:ShowLiveButtons( false );

		if( self.sdb.bHideBlizzCB ) then
			MFClip:HideBlizzardCastbar( false );
		end

		LibStub("AceConfig-3.0"):RegisterOptionsTable( "MFClip", self.optdisabled, "mfclip" );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip CombatText", self.optempty );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip Statistics", self.optempty );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveBars", self.optempty );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveButtons", self.optempty );
	end
end

function MFClip:OnInitialize()
	-- cataclysm?
	local _, _, _, toc = GetBuildInfo();
	self.bIs40 = (toc >= 40000);

	-- set init values
	self:SetStartupValues();

	-- setup channeled spells table
	self:SetupChannelSpellsTable();

	self.db = LibStub("AceDB-3.0"):New( "MFClipDB", defaults );
	self.sdb = self.db.profile;

	self.optionsFrame = LibStub( "AceConfigDialog-3.0" ):AddToBlizOptions( "MFClip", "MFClip" );
	LibStub( "AceConfigDialog-3.0" ):AddToBlizOptions( "MFClip CombatText", "CombatText", "MFClip" );
	LibStub( "AceConfigDialog-3.0" ):AddToBlizOptions( "MFClip Statistics", "Statistics", "MFClip" );
	self.LBoptionsFrame = LibStub( "AceConfigDialog-3.0" ):AddToBlizOptions( "MFClip LiveBars", "LiveBars", "MFClip" );

	if( self.sdb.bEnabled == nil ) then
		self.sdb.optver = self.optver;
	end

	for key, value in pairs(self.tDefaults) do
		if( self.sdb[key] == nil ) then
			self.sdb[key] = value;
		end
	end

	self.fCurWFCL = self.sdb.fWFCL;

	-- events registered to blizzard castbar
	self.blizzcastbar = {};

	if( self.sdb.bEnabled == true ) then
		self:Print( self.title .. " loaded (enabled)" );
		if( self.sdb.bHideBlizzCB ) then
			self:HideBlizzardCastbar( true );
		end

		LibStub("AceConfig-3.0"):RegisterOptionsTable( "MFClip", self.options, "mfclip" );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip CombatText", self.options_ct );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip Statistics", self.options_stats );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveBars", self.options_lb );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveButtons", self.options_lbuttons );
	else
		self:Print( self.title .. " loaded (disabled)" );

		LibStub("AceConfig-3.0"):RegisterOptionsTable( "MFClip", self.optdisabled, "mfclip" );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip CombatText", self.optempty );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip Statistics", self.optempty );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveBars", self.optempty );
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MFClip LiveButtons", self.optempty );
	end

	if( not self.sdb.optver or self.sdb.optver < self.optver ) then
		self:Print( "old configuration data found, call /mfclip reset if you experience problems" );
	end
end

function MFClip:RegisterCastEvents()
	self:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" );
	self:RegisterEvent( "UNIT_SPELLCAST_CHANNEL_START" );
	self:RegisterEvent( "UNIT_SPELLCAST_CHANNEL_UPDATE" );
	self:RegisterEvent( "UNIT_SPELLCAST_SENT" );
	self:RegisterEvent( "UNIT_SPELLCAST_START" );
	self:RegisterEvent( "UNIT_SPELLCAST_STOP" );
	self:RegisterEvent( "UNIT_SPELLCAST_CHANNEL_STOP" );
	self:RegisterEvent( "UNIT_SPELLCAST_DELAYED" );
	self:RegisterEvent( "UNIT_SPELLCAST_SUCCEEDED" );

	self:RegisterEvent( "PLAYER_REGEN_DISABLED" );
	self:RegisterEvent( "PLAYER_REGEN_ENABLED" );

	-- vehicle enter/exit
	self:RegisterEvent( "UNIT_ENTERED_VEHICLE" );
	self:RegisterEvent( "UNIT_EXITED_VEHICLE" );
	self:RegisterEvent( "PLAYER_ENTERING_WORLD" );
end

function MFClip:UnregisterCastEvents()
	self:UnregisterEvent( "COMBAT_LOG_EVENT_UNFILTERED" );
	self:UnregisterEvent( "UNIT_SPELLCAST_CHANNEL_START" );
	self:UnregisterEvent( "UNIT_SPELLCAST_CHANNEL_UPDATE" );
	self:UnregisterEvent( "UNIT_SPELLCAST_SENT" );
	self:UnregisterEvent( "UNIT_SPELLCAST_START" );
	self:UnregisterEvent( "UNIT_SPELLCAST_STOP" );
	self:UnregisterEvent( "UNIT_SPELLCAST_CHANNEL_STOP" );
	self:UnregisterEvent( "UNIT_SPELLCAST_DELAYED" );
	self:UnregisterEvent( "UNIT_SPELLCAST_SUCCEEDED" );

	self:UnregisterEvent( "PLAYER_REGEN_DISABLED" );
	self:UnregisterEvent( "PLAYER_REGEN_ENABLED" );

	-- vehicle enter/exit
	self:UnregisterEvent( "UNIT_ENTERED_VEHICLE" );
	self:UnregisterEvent( "UNIT_EXITED_VEHICLE" );
	self:UnregisterEvent( "PLAYER_ENTERING_WORLD" );
end

function MFClip:AddChanneledSpellById( id, tickcount, bars )
	local name = GetSpellInfo( id );

	if( name ) then
		self.channeledspells[name] = {
			["ticks"] = tickcount,
			["bars"] = bars,
		};
	end
end

function MFClip:OnEnable()
	if( self.sdb.bEnabled == true ) then
		MFClip:RegisterCastEvents();
	end

	-- get unique player identifier
	self.guid = UnitGUID( "player" );

	local name, icon;

	-- create bars
	-- create anchor
	self.bars.anchor = self:CreateLiveBar( "anchor", nil, 200, 20, 0, 100, 0, "MFClip Live Info", "", false );
	self.buttons.anchor = self:CreateLiveBar( "buttonanchor", nil, 20, 20, 0, 100, 0, "", "", false );
	self:MakeMovable( self.bars.anchor, true );
	self:MakeMovable( self.buttons.anchor, true );

	-- get spell info (for Mind Flay)
	self.strMF, _, self.strMFTexture = GetSpellInfo( self.bIs40 and 15407 or 48156 );
	self.bars.mf = self:CreateLiveBar( "MFClip_Bar_MF", self.strMFTexture, 200, 20, 0, 100, 0, self.strMF, "0%", false );
	self.buttons.mf = self:CreateLiveButton( "MFClip_Button_MF", self.strMFTexture, 20, 20, "", self.strMF, true );

	-- Mind Flay (Insanity)
	self.strMFI, _, self.strMFITexture = GetSpellInfo(129197);
	
	-- mb
	self.strMB, _, icon =  GetSpellInfo( self.bIs40 and 8092 or 48127 );
	self.bars.mb = self:CreateLiveBar( "MFClip_Bar_MB", icon, 200, 20, 0, 100, 0, self.strMB, "0%", false );
	self.buttons.mb = self:CreateLiveButton( "MFClip_Button_MB", icon, 20, 20, "", self.strMB, false );
	-- vt
	self.strVT, _, icon =  GetSpellInfo( self.bIs40 and 34914 or 48160 );
	self.tDots[self.strVT] = { icon = icon, abbr = "VT" };
	self.bars.vt = self:CreateLiveBar( "MFClip_Bar_VT", icon, 200, 20, 0, 100, 0, self.strVT, "0%", true );
	self.buttons.vt = self:CreateLiveButton( "MFClip_Button_VT", icon, 20, 20, "", self.strVT, true );
	-- dp
	name, _, icon = GetSpellInfo( self.bIs40 and 2944 or 48300 );
	self.tDots[name] = { icon = icon, abbr = "DP" };
	self.bars.dp = self:CreateLiveBar( "MFClip_Bar_DP", icon, 200, 20, 0, 100, 0, name, "0%", true );
	self.buttons.dp = self:CreateLiveButton( "MFClip_Button_DP", icon, 20, 20, "", name, true );
	-- sw:p
	name, _, icon = GetSpellInfo( self.bIs40 and 589 or 48125 );
	self.tDots[name] = { icon = icon, abbr = "SWP" };
	self.bars.swp = self:CreateLiveBar( "MFClip_Bar_SWP", icon, 200, 20, 0, 100, 0, name, "0%", true );
	self.buttons.swp = self:CreateLiveButton( "MFClip_Button_SWP", icon, 20, 20, "", name, true );

	-- mind sear
	self.strMS, _, icon = GetSpellInfo( self.bIs40 and 48045 or 53023 );
	self.buttons.ms = self:CreateLiveButton( "MFClip_Button_MS", icon, 20, 20, "", self.strMS, true );

	-- sw:d
	self.strSWD, _, icon = GetSpellInfo( self.bIs40 and 32379 or 48158 );
	self.bars.swd = self:CreateLiveBar( "MFClip_Bar_SWD", icon, 200, 20, 0, 100, 0, self.strSWD, "0%", false );
	self.buttons.swd = self:CreateLiveButton( "MFClip_Button_SWD", icon, 20, 20, "", self.strSWD, false );

	-- shackle undead
	self.strSU, _, icon = GetSpellInfo( self.bIs40 and 9484 or 10955 );
	self.buttons.su = self:CreateLiveButton( "MFClip_Button_SU", icon, 20, 20, "", self.strSU, true );

	-- setup bars
	self:SetLBConfig( self.sdb.strLBooCconf );

	-- setup buttons
	self:SetLButtonsConfig( self.sdb.strLButtons );

	-- dual spec talent change event
	self:RegisterEvent( "PLAYER_TALENT_UPDATE" );
	self:SetStatusByTalents();

	-- LibDataBroker
	self.ldb = LibStub( "LibDataBroker-1.1" );
	self.ldbdata = self.ldb:NewDataObject( self.strTitle, {
			type = "launcher",
			label = self.strTitle,
			icon = self.strMFTexture,
		}
	)

	function self.ldbdata:OnClick( button )
		InterfaceOptionsFrame_OpenToCategory( MFClip.optionsFrame );
	end

	self.strFightInfo = "No fight data yet.";
	function self.ldbdata:OnTooltipShow()
		self:AddLine( MFClip.strFightInfo );
	end
end

function MFClip:ResetOptions()
	self:Enable( false );

	self.db:ResetProfile();
	self.sdb = self.db.profile;

	for key, value in pairs(self.tDefaults) do
		self.sdb[key] = value;
	end

	self:Print( "options reset" );

	if( self.logData ) then
		-- in combat
		self:SetLBConfig( self.sdb.strLBinCconf );
	else
		self:SetLBConfig( self.sdb.strLBooCconf );
	end

	self:SetLButtonsConfig( self.sdb.strLButtons );

	self.sdb["optver"] = self.optver;
	self:Enable( true );
	self:SetBarColors();
end

function MFClip:GenerateCombatText( strPre, strType, strPost, strFixed, strCol, iTickCount, iCritCount, iHitCount, iDmg, bClipped )

	local mfname = self.strMF;

	if( string_len( strFixed ) > 0 and (strType == "Static" or strType == "Spell" or strType == "Ticks" or strType == "Dmg" or (strType == "Clip" and bClipped == true) ) ) then
		return strCol .. strFixed .. "|r";
	elseif( strType == "Spell" ) then
		return strCol .. strPre .. mfname .. strPost .. "|r";
	elseif( strType == "Ticks" and iTickCount > 1 ) then
		return strCol .. strPre .. iTickCount .. strPost .. "|r";
	elseif( strType == "HitsCrits" and iTickCount > 0 and iHitCount > 0 and iCritCount > 0 ) then
		return strCol .. strPre .. iTickCount .. " Hits, " .. iCritCount .. " Crits" .. strPost .. "|r";
	elseif( strType == "HitsCrits" and iTickCount > 0 and iHitCount > 0 ) then
		return strCol .. strPre .. iTickCount .. " Hits"  .. strPost .. "|r";
	elseif( strType == "HitsCrits" and iTickCount > 0 and iCritCount > 0 ) then
		return strCol .. strPre .. iCritCount .. " Crits" .. strPost .. "|r";
	elseif( strType == "Hits" ) then
		return strCol .. strPre .. iHitCount .. strPost .. "|r";
	elseif( strType == "Crits" ) then
		return strCol .. strPre .. iCritCount .. strPost .. "|r";
	elseif( strType == "Dmg" ) then
		return strCol .. strPre .. iDmg .. strPost .. "|r";
	elseif( strType == "Clip" and bClipped == true ) then
		return strCol .. strPre .. "clipped" .. strPost .. "|r";
	end

	return "";
end

function MFClip:Output( iTickCount, iCritCount, iHitCount, iDmg, bClipped )
	if( iTickCount > 0 ) then
		-- update statistics
		self.mfdata.iTotalMFCount = self.mfdata.iTotalMFCount + iTickCount;
		self.mfdata.iTotalMFCrit = self.mfdata.iTotalMFCrit + iCritCount;
		self.mfdata.iTotalMFHit = self.mfdata.iTotalMFHit + iHitCount;
		self.mfdata.iTotalMFDmg = self.mfdata.iTotalMFDmg + iDmg;

		if( bClipped == true ) then
			self.mfdata.bLastClipped = true;
			self.mfdata.iTotalMFClipped = self.mfdata.iTotalMFClipped + 1;
		else
			self.mfdata.bLastClipped = nil;
		end

		local sdp = self.sdb;

		if( sdp.bSound == true and bClipped == true and sdp.strSound and sdp.strSound ~= "" ) then
			PlaySound( sdp.strSound );
		end

		if( sdp.bCT == true ) then
			-- generate combat text string
			local str = MFClip:GenerateCombatText( sdp.strSelFirstPre, sdp.strSelFirst, sdp.strSelFirstPost, sdp.strSelFirstFixed,
													sdp.strSelFirstColor, iTickCount, iCritCount, iHitCount, iDmg, bClipped ) ..
							MFClip:GenerateCombatText( sdp.strSelSecondPre, sdp.strSelSecond, sdp.strSelSecondPost, sdp.strSelSecondFixed,
													sdp.strSelSecondColor, iTickCount, iCritCount, iHitCount, iDmg, bClipped ) ..
							MFClip:GenerateCombatText( sdp.strSelThirdPre, sdp.strSelThird, sdp.strSelThirdPost, sdp.strSelThirdFixed,
													sdp.strSelThirdColor, iTickCount, iCritCount, iHitCount, iDmg, bClipped ) ..
							MFClip:GenerateCombatText( sdp.strSelFourthPre, sdp.strSelFourth, sdp.strSelFourthPost, sdp.strSelFourthFixed,
													sdp.strSelFourthColor, iTickCount, iCritCount, iHitCount, iDmg, bClipped ) ..
							MFClip:GenerateCombatText( sdp.strSelFifthPre, sdp.strSelFifth,	sdp.strSelFifthPost, sdp.strSelFifthFixed,
													sdp.strSelFifthColor, iTickCount, iCritCount, iHitCount, iDmg, bClipped ) ..
							MFClip:GenerateCombatText( sdp.strSelSixthPre, sdp.strSelSixth, sdp.strSelSixthPost, sdp.strSelSixthFixed,
													sdp.strSelSixthColor, iTickCount, iCritCount, iHitCount, iDmg, bClipped );

			local strTex = nil;
			local bSticky = nil;
			if( sdp.bShowIcon == true ) then strTex = self.strMFTexture; end
			if( sdp.bSticky == true and bClipped == true ) then bSticky = true; end

			-- font size
			local fs = nil;
			if( bClipped and self.sdb.iFontsizeClip > 0 ) then
				fs = self.sdb.iFontsizeClip;
			elseif( not bClipped and self.sdb.iFontsizeNonClip > 0 ) then
				fs = self.sdb.iFontsizeNonClip;
			end

			local fo = nil;
			if( bClipped and self.sdb.iFontoutlineClip > 0 ) then
				fo = self.sdb.iFontoutlineClip;
			elseif( not bClipped and self.sdb.iFontoutlineNonClip > 0 ) then
				fo = self.sdb.iFontoutlineNonClip;
			end

			if( sdp.strCT == "MSBT" and MikSBT and MikSBT.IsModDisabled() == nil ) then
				MikSBT.DisplayMessage( str, MikSBT.DISPLAYTYPE_OUTGOING, bSticky, nil, nil, nil, fs, nil, fo, strTex );
			elseif( sdp.strCT == "SCT" and SCT and SCTD ) then
				SCT:DisplayText( str, color, bSticky, "damage", SCT.FRAME3, nil, nil, strTex );
			elseif( sdp.strCT == "Parrot" and Parrot ) then
				Parrot:ShowMessage( str, "Outgoing", bSticky, 1, 1, 1, nil, fs, nil, strTex );
			elseif( sdp.strCT == "Blizzard" and tostring(SHOW_COMBAT_TEXT) ~= "0" ) then
				CombatText_AddMessage( str, CombatText_StandardScroll, 1, 1, 1, bSticky, false );
			end
		end
	end
end

function MFClip:HideBlizzardCastbar( status )
	-- code taken over from Gnosis
	if( status ) then	-- hide castbar
		for key, value in pairs(self.tCastbarEvents) do
			if( CastingBarFrame:IsEventRegistered( value ) ) then
				table_insert( self.blizzcastbar, value );
			end
			CastingBarFrame:UnregisterEvent( value );
		end
		for key, value in pairs(self.tMiscEvents) do
			if( CastingBarFrame:IsEventRegistered( value ) ) then
				table_insert( self.blizzcastbar, value );
			end
			CastingBarFrame:UnregisterEvent( value );
		end
		if( #self.blizzcastbar > 0 ) then
			self:Print( "disabled blizzard castbar (see LiveBars options)" );
		else
			self:Print( "blizzard castbar already hidden by another addon" );
		end
	else				-- restore castbar events, it might not actually enable the blizzard castbar if another addon hides it
		for key, value in pairs(self.blizzcastbar) do
			CastingBarFrame:RegisterEvent( value );
		end
		if( #self.blizzcastbar > 0 ) then
			self:Print( "blizzard castbar restored (see LiveBars options)" );
		end
		self.blizzcastbar = {};
	end
end

function MFClip:OnUpdate()
	if( not self.sdb.bEnabled ) then
		return;
	end

	local fCurTime = GetTime() * 1000;
	self:ClipTest( fCurTime );

	-- update LiveBars & LiveButtons
	if( self.sdb.bLiveBarsEnabled ) then
		self:UpdateLiveBars( fCurTime, self.logData );
	end

	-- divine insight bandaid
	local s, d = GetSpellCooldown( self.strMB );
	if( d and d == 0 ) then
		self.mbdata.fMBCDend = fCurTime;
	end
	
	-- spell cooldowns
	while( #self.tCDs > 0 ) do
		self:UpdateCooldown( self.tCDs[#self.tCDs], fCurTime );
		table_remove( self.tCDs, #self.tCDs );
	end
end

function MFClip:UpdateCooldown( spell, fCurTime )
	local start, duration = GetSpellCooldown( spell );

	if( duration and duration > 0.1 ) then -- make sure duration is not 0
		if( spell == self.strMB ) then
			start, duration = start * 1000, duration * 1000;
			self.bars.mb.bar:SetMinMaxValues( 0, duration );
			self.mbdata.fMBCD = duration;
			self.mbdata.fMBCDend = start + duration;
			self.bars.mb.bar:SetValue( duration );
			self.mbdata.fMBTotalCasttime = self.mbdata.fMBTotalCasttime + self.mbdata.fMBCasttime + duration;

			if( not self.mbdata.bMB ) then
				self.mbdata.bMB = true;
				self.mbdata.fFirstMBCasted = fCurTime;
			end
		elseif( spell == self.strSWD ) then
			start, duration = start * 1000, duration * 1000;
			self.bars.swd.bar:SetMinMaxValues( 0, duration );
			self.swddata.fSWDCD = duration;
			self.swddata.fSWDCDend = start + duration;
			self.bars.swd.bar:SetValue( duration );
			self.swddata.fSWDTotalCasttime = self.swddata.fSWDTotalCasttime + duration;

			if( not self.swddata.bSWD ) then
				self.swddata.bSWD = true;
				self.swddata.fFirstSWDCasted = fCurTime;
			end
		end
	end
end

function MFClip:UNIT_SPELLCAST_SENT()
	self.lastSpellSent = GetTime() * 1000;
end

function MFClip:UNIT_SPELLCAST_DELAYED( event, unit )
	local fCurTime = GetTime() * 1000;

	if( unit == "player" ) then
		spell, _, _, _, startTime, endTime = UnitCastingInfo( "player" );
		self:Spellcast_Update( spell, startTime, endTime );
	end
end

function MFClip:UNIT_SPELLCAST_CHANNEL_UPDATE( event, unit )
	local fCurTime = GetTime() * 1000;

	if( unit == "player" ) then
		local spell, _, _, _, startTime, endTime = UnitChannelInfo( "player" );
		self:Spellcast_Update( spell, startTime, endTime );

		-- clip test
		local cc, nc = self.curchannel, self.nextchannel;
		local fspb;
		if( nc and nc.spell == spell ) then
			fspb = nc.endtime - endTime;
			nc.pushback = nc.pushback + fspb;
			nc.testtime = nc.testtime - fspb;
			nc.endtime = endTime;
		elseif( cc and cc.spell == spell ) then
			fspb = cc.endtime - endTime;
			cc.pushback = cc.pushback + fspb;
			cc.testtime = cc.testtime - fspb;
			cc.endtime = endTime;
		end
	end
end

function MFClip:UNIT_SPELLCAST_START( event, unit, spell, rank, id )
	local fCurTime = GetTime() * 1000.0;

	if( unit == "player" ) then
		self:Latency( fCurTime );	-- calculate current latency
		self:CastbarSetInitial( false, fCurTime );
	end
end

function MFClip:UNIT_SPELLCAST_CHANNEL_START( event, unit, spell, rank, id )
	local fCurTime = GetTime() * 1000;
	local cc = {};

	if( unit == "player" ) then
		self:Latency( fCurTime );	-- calculate current latency
		self:CastbarSetInitial( true, fCurTime );

		-- clip test
		if( spell == self.strMF or spell == self.strMFI ) then
			-- generate new clip test data
			local name, rank, displayName, texture, startTime, endTime = UnitChannelInfo( unit );

			local fTick = (endTime - startTime) / 3;
			cc.spell = name;
			cc.ftick = fTick;
			cc.endtime = endTime;
			cc.starttime = startTime;
			cc.duration = endTime - startTime;
			cc.maxticks = 3;
			cc.testtime = endTime + self.sdb.fWFCL;
			cc.pushback = 0;
			cc.dmg = 0;
			cc.ticks = 0;
			cc.hits = 0;
			cc.crits = 0;

			if( self.curchannel ) then
				self.nextchannel = cc;
			else
				self.curchannel = cc;
			end
		end
	end
end

function MFClip:UNIT_SPELLCAST_STOP( event, unit )
	local fCurTime = GetTime() * 1000;

	if( unit == "player" ) then
		self.casting = false;
		self.bIsActiveCB = false;
		if( self.sdb.bHideCastbarWNC ) then
			self.bFadeoutCB = true;
			self.fCleanupReqTime = GetTime() * 1000;
		else
			self.bFadeoutCB = false;
			self:CleanUpCastbar();
		end
	end
end

function MFClip:UNIT_SPELLCAST_CHANNEL_STOP( event, unit )
	local fCurTime = GetTime() * 1000;

	if( unit == "player" ) then
		-- clip test
		-- request unintentional clipping test
		self:RequestClipTest( fCurTime );

		self.channeling = false;
		self.bIsActiveCB = false;
		if( self.sdb.bHideCastbarWNC ) then
			self.bFadeoutCB = true;
			self.fCleanupReqTime = GetTime() * 1000;
		else
			self.bFadeoutCB = false;
			self:CleanUpCastbar();
		end
	end
end

function MFClip:RequestClipTest( fCurTime )
	local cc, nc = self.curchannel, self.nextchannel;
	if( cc ) then
		if( nc and cc.spell == nc.spell ) then
			-- same spell, make sure ticks of spells don't overlap cliptest
			cc.freqtest = cc.freqtest and min(cc.freqtest,fCurTime) or fCurTime;
			cc.fforcedtest = cc.fforcedtest and min(cc.fforcedtest,nc.starttime + min( self.sdb.fWFCL, nc.ftick )) or (nc.starttime + min( self.sdb.fWFCL, nc.ftick ));
		else
			cc.freqtest = cc.freqtest and min(cc.freqtest,fCurTime) or fCurTime;
			cc.fforcedtest = cc.fforcedtest and min(cc.fforcedtest,fCurTime + self.sdb.fWFCL) or (fCurTime + self.sdb.fWFCL);
		end
	end
end

function MFClip:ClipTest( fCurTime )
	local cc, nc = self.curchannel, self.nextchannel;

	if( cc ) then
		local bClip, bOutput = false, false;

		if( cc.ticks == cc.maxticks or fCurTime >= cc.testtime ) then
			-- check spell out, no clipping
			bOutput = true;
		elseif( cc.fforcedtest and fCurTime >= cc.fforcedtest ) then	-- clip test requested
			-- test for clipping
		 	if( (((cc.ticks+1) * cc.ftick + cc.starttime) - cc.freqtest) <= self.sdb.fUCW ) then
		 		-- probably unintentional clip, test for spell pushback
		 		if( ((cc.ticks+1) * cc.ftick) > (cc.duration - cc.pushback) ) then
		 			-- clipping impossible due to spell pushback
		 		else
		 			-- unintentional clipping detected, do not output as clip if player had no target when clip test was requested
					local tarname = UnitName( "target" );
					if( tarname and not UnitIsDead( "target" ) ) then
						bClip = true;
					end
		 		end
		 	end
		 	bOutput = true;
 		end

		if( bOutput ) then
			-- statistics
			self.mfdata.fTickedCasttime = self.mfdata.fTickedCasttime + cc.ftick * cc.ticks;

			-- combat text output!
			self:Output( cc.ticks, cc.crits, cc.hits, cc.dmg, bClip );

		 	-- done, next channeled spell in queue
		 	self.curchannel = nil;
		 	self.curchannel = self.nextchannel;
		 	self.nextchannel = nil;
		end
	elseif( nc ) then
		self.curchannel = nil;
		self.curchannel = self.nextchannel;
		self.nextchannel = nil;
	end
end

function MFClip:Spellcast_Update( spell, startTime, endTime )
	if( spell ) then
		local fSPB = endTime - self.castend;
		
		if( fSPB > 0 ) then
			self.mfdata.td.addtick = 1;
			
			if( spell == self.strMF or spell == self.strMFI ) then
				self.bars.mf.lb4:Show();
			end
		end
		
		self.mfdata.td.pb = self.mfdata.td.pb - ((fSPB > 0) and 0 or fSPB);
		self.castend = endTime;
		self.casttime = endTime - startTime;
		
		if( self.channeledspells[spell] ) then
			local te = self.channeledspells[spell];
			local onedivticks = 1 / (te.ticks + self.mfdata.td.addtick);
			local bars = te.bars + self.mfdata.td.addtick;

			if( bars > 4 ) then
				self.mfdata.td[5] = self.mfdata.td[5] - ((fSPB > 0) and fSPB or 0);
				if( self.mfdata.td[5] > endTime ) then
					self.bars.mf.lb5:Hide();
				else
					self.bars.mf.lb5:SetPoint( "LEFT", (4 * onedivticks - self.mfdata.td.pb / self.casttime) *  self.sdb.fLBWidth, 0 );
				end
			end
			if( bars > 3 ) then
				self.mfdata.td[4] = self.mfdata.td[4] - ((fSPB > 0) and fSPB or 0);
				if( self.mfdata.td[4] > endTime ) then
					self.bars.mf.lb4:Hide();
				else
					self.bars.mf.lb4:SetPoint( "LEFT", (3 * onedivticks - self.mfdata.td.pb / self.casttime) *  self.sdb.fLBWidth, 0 );
				end
			end
			if( bars > 2 ) then
				self.mfdata.td[3] = self.mfdata.td[3] - ((fSPB > 0) and fSPB or 0);
				if( self.mfdata.td[3] > endTime ) then
					self.bars.mf.lb3:Hide();
				else
					self.bars.mf.lb3:SetPoint( "LEFT", (2 * onedivticks - self.mfdata.td.pb / self.casttime) *  self.sdb.fLBWidth, 0 );
				end
			end
			if( bars > 1 ) then
				self.mfdata.td[2] = self.mfdata.td[2] - ((fSPB > 0) and fSPB or 0);
				if( self.mfdata.td[2] > endTime ) then
					self.bars.mf.lb2:Hide();
				else
					self.bars.mf.lb2:SetPoint( "LEFT", (onedivticks - self.mfdata.td.pb / self.casttime) *  self.sdb.fLBWidth, 0 );
				end
			end
			if( bars > 0 ) then
				self.mfdata.td[1] = self.mfdata.td[1] - ((fSPB > 0) and fSPB or 0);
				if( self.mfdata.td[1] > endTime ) then
					self.bars.mf.lb1:Hide();
				end
			end
		end
	end
end

function MFClip:SetupCastbarForChannel( spell, startTime, endTime )
	if( self.channeledspells[spell] ) then
		-- spell found, setting up castbar
		local te = self.channeledspells[spell];
		local onedivticks = 1 / te.ticks;

		self.mfdata.fCastStart = startTime;
		self.mfdata.fTick = (endTime-startTime) * onedivticks;
		self.mfdata.td.ftick = self.mfdata.fTick;

		self.mfdata.td[1] = endTime;
		self.mfdata.td.bValid = true;
		self.mfdata.td.addtick = 0;

		self.bars.mf.lb2:Hide();
		self.bars.mf.lb3:Hide();
		self.bars.mf.lb4:Hide();
		self.bars.mf.lb5:Hide();
	
		if( te.ticks > 1 ) then
			self.mfdata.td[2] = self.mfdata.td[1] - self.mfdata.fTick;
			if( te.bars > 1 ) then
				self.bars.mf.lb2:SetPoint( "LEFT", self.bars.mf.bar:GetWidth() * onedivticks, 0 );
				self.bars.mf.lb2:Show();
			end
		end
		if( te.ticks > 2 ) then
			self.mfdata.td[3] = self.mfdata.td[2] - self.mfdata.fTick;
			if( te.bars > 2 ) then
				self.bars.mf.lb3:SetPoint( "LEFT", self.bars.mf.bar:GetWidth() * 2 * onedivticks, 0 );
				self.bars.mf.lb3:Show();
			end
		end
		if( te.ticks > 3 ) then
			self.mfdata.td[4] = self.mfdata.td[3] - self.mfdata.fTick;
			if( te.bars > 3 ) then
				self.bars.mf.lb4:SetPoint( "LEFT", self.bars.mf.bar:GetWidth() * 3 * onedivticks, 0 );
				self.bars.mf.lb4:Show();
			end
		end
		if( te.ticks > 4 ) then
			self.mfdata.td[5] = self.mfdata.td[4] - self.mfdata.fTick;
			if( te.bars > 4 ) then
				self.bars.mf.lb5:SetPoint( "LEFT", self.bars.mf.bar:GetWidth() * 4 * onedivticks, 0 );
				self.bars.mf.lb5:Show();
			end
		end
	end
end

function MFClip:CastbarSetInitial( bIsChannel, fCurTime )
	-- setup clip test
	self:PrepareClipTest( fCurTime );

	local name, rank, displayName, texture, startTime, endTime = (bIsChannel and UnitChannelInfo or UnitCastingInfo)( "player" );

	if( ((not self.sdb.bLiveBarsEnabled) or (not self.bars.mf.bIsActive)) and name ) then
		if( name == self.strMF or name == self.strMFI ) then
			self.mfdata.td.pb = 0.0;
			self.mfdata.td.addtick = 0;
			
			if( bIsChannel ) then
				self:SetupCastbarForChannel( name, startTime, endTime );
			end

			-- store current cast information
			self.casting, self.channeling = not bIsChannel, bIsChannel
			self.castname, self.castend, self.casttime  = name, endTime, endTime - startTime;

			-- setup mind flay clip test vars
			self.mfdata.bPriorCastMF = true;
			self.mfdata.bResetWait = true;

			-- adjust wait for combat log if enabled
			if( self.sdb.bfWFCLadj == true and (self.mfdata.fTick-25) < self.sdb.fWFCL ) then
				self.fCurWFCL = self.mfdata.fTick - 25;		-- subtract another 25ms
			end
		elseif( name == self.strMB ) then
			self.fMBCastStart = startTime;
			self.mbdata.fMBCasttime = endTime - startTime;
		end
	end

	if( self.sdb.bLiveBarsEnabled ) then
		if( name == self.strMB ) then
			self.fMBCastStart = startTime;
			self.mbdata.fMBCasttime = endTime - startTime;
		end

		if( self.bars.mf.bIsActive and name ) then
			-- set castbar as active
			self.bIsActiveCB = true;

			if( self.bFadeoutCB ) then
				-- not yet faded out
				self.bFadeoutCB = false;
				self:CleanUpCastbar();
			end

			-- store current cast information
			self:Latency( fCurTime );	-- calculate current latency
			self.casting, self.channeling = not bIsChannel, bIsChannel
			self.castname, self.castend, self.casttime  = name, endTime, endTime - startTime;

			local sSide, iLat = bIsChannel and "LEFT" or "RIGHT", min( self.sdb.fLBmax, self.lag / self.casttime ) * self.sdb.fLBWidth;
			self.bars.mf.lb1:SetWidth( iLat );
			self.bars.mf.lb2:SetWidth( iLat );
			self.bars.mf.lb3:SetWidth( iLat );
			self.bars.mf.lb4:SetWidth( iLat );
			self.bars.mf.lb5:SetWidth( iLat );
			self.bars.mf.bar:SetValue( bIsChannel and 100 or 0 );
			self.bars.mf.icon:SetTexture( texture );

			self.bars.mf.lb1:ClearAllPoints();
			self.bars.mf.lb1:SetPoint( sSide );

			self.bars.mf.lb1:Show();
			self.bars.mf.cbs:Show();

			self.bars.mf.trtext:SetText( "" );
			self.bars.mf.brtext:SetText( "" );
			self.bars.mf.bltext:SetText( "" );

			self.mfdata.td.pb = 0.0;
			if( bIsChannel ) then
				self:SetupCastbarForChannel( name, startTime, endTime );
			end

			if( name == self.strMF or name == self.strMFI ) then
				self.bars.mf.rtext:SetText( "" );
				self.bars.mf.ctext:SetJustifyH( "CENTER" );
				self.bars.mf.ctext:SetText( string_format( "%.1fs", self.casttime / 1000.0 ) );

				-- setup mind flay clip test vars
				self.mfdata.bPriorCastMF = true;
				self.mfdata.bResetWait = true;

				-- adjust wait for combat log if enabled
				if( self.sdb.bfWFCLadj == true and (self.mfdata.fTick-25) < self.sdb.fWFCL ) then
					self.fCurWFCL = self.mfdata.fTick - 25;		-- subtract another 25ms
				end
			else
				self.bars.mf.ctext:SetText( name .. ((rank ~= "") and (" (" .. rank .. ")") or "") );
				self.bars.mf.ctext:SetJustifyH( "LEFT" );
				self.bars.mf.trtext:SetText( "" );
				self.bars.mf.brtext:SetText( "" );
			end

			-- show bar
			self.bars.mf:Show();
			self.bars.mf:SetAlpha( 1.0 );
		else
			self.casting, self.channeling = false, false;
		end
	end
end

function MFClip:ShowMindFlayDataOnCastbar()
	if( self.mfdata.fTickedCasttime > 0.0 ) then
		local fCastTimeLoss = 100 - floor( self.mfdata.fLostCasttime/(self.mfdata.fLostCasttime+self.mfdata.fTickedCasttime)*100.0 + 0.5 );
		self.bars.mf.trtext:SetText( fCastTimeLoss .. "%" );
		self.bars.mf.brtext:SetText( floor( self.mfdata.iTotalMFDmg/((self.mfdata.fLostCasttime+self.mfdata.fTickedCasttime)/1000.0 ) ) .. " DPS" );
		self.bars.mf.rtext:SetText( "" );
	else
		self.bars.mf.trtext:SetText(  "0%" );
	end
end

function MFClip:CleanUpCastbar()
	self.bCleanupCB = false;
	self.bars.mf.bar:SetValue( 0 );
	self.bars.mf.ctext:SetText( "" );
	self.bars.mf.rtext:SetText( "" );
	self.bars.mf.bltext:SetText( "" );
	self.bars.mf.lb1:Hide();
	self.bars.mf.lb2:Hide();
	self.bars.mf.lb3:Hide();
	self.bars.mf.lb4:Hide();
	self.bars.mf.lb5:Hide();
	self.bars.mf.ctext:SetJustifyH( "CENTER" );

	self.bars.mf.cbs:Hide();
	self.bars.mf.icon:SetTexture( self.strMFTexture );

	self:ShowMindFlayDataOnCastbar();

	if( not self.logData ) then -- out of combat
		self.bars.mf.ctext:SetText( self.bars.mf.dotname );
	end
end

function MFClip:PrepareClipTest( fCurTime )
	if( self.mfdata.bPriorCastMF ) then
		self.mfdata.bPriorCastMF = false;
		self.mfdata.bClipTest = true;

		for key, value in pairs(self.mfdata.td) do
			self.mfdata.tt[key] = value;
		end

		self.mfdata.td.bValid = false;
		self.mfdata.tt.bValid = true;

		self.mfdata.fReqTestTime = fCurTime;

		-- statistics
		local fLost = 0.0;
		if( fCurTime > self.mfdata.tt[1] ) then
			fLost = fCurTime - self.mfdata.tt[1];
		elseif( fCurTime > self.mfdata.tt[2] ) then
			fLost = fCurTime - self.mfdata.tt[2];
		elseif( fCurTime > self.mfdata.tt[3] ) then
			fLost = fCurTime - self.mfdata.tt[3];
		end

		-- arbitrarily chosen values of 800ms and fTick+500ms
		if( (fCurTime > self.mfdata.tt[1] and fLost < 800) or fLost < (self.mfdata.tt.ftick + 500) ) then
			self.mfdata.fLostCasttime = self.mfdata.fLostCasttime + fLost;
		end
		-- end statistics
	end
end

function MFClip:Latency( fCurTime )
	self.lag = fCurTime - self.lastSpellSent;
end

function MFClip:UNIT_SPELLCAST_SUCCEEDED( event, unit, spell )
	if( unit == "player" ) then
		table_insert( MFClip.tCDs, spell );
	end
end

function MFClip:COMBAT_LOG_EVENT_UNFILTERED( _, ts, event, _, sguid, _, _, _, dguid, dname, _, _, _, spellname, _, dmg, oh, _, _, _, _, bcrit )
	local fCurTime = GetTime() * 1000;

	if( event == "UNIT_DIED" and self.tDotsApplied[dguid] ) then
		self.tDotsApplied[dguid].died = fCurTime;
	end

	if( not(sguid == self.guid) or self.logData == false ) then
		return;
	end

	if( spellname == self.strMB ) then
		if( event == "SPELL_DAMAGE" or event == "SPELL_MISSED" ) then
			self.mbdata.iMBCount = self.mbdata.iMBCount + 1;

			if( event == "SPELL_DAMAGE" ) then
				self.mbdata.iMBDmg = self.mbdata.iMBDmg + dmg;
			end
		end
	elseif( spellname == self.strSWD ) then
		if( event == "SPELL_DAMAGE" or event == "SPELL_MISSED" ) then
			self.swddata.iSWDCount = self.swddata.iSWDCount + 1;

			self.fSWDCastStart = startTime;

			if( event == "SPELL_DAMAGE" ) then
				self.swddata.iSWDDmg = self.swddata.iSWDDmg + dmg;
			end
		end
	end

	-- mind flay
	if( (event == "SPELL_CAST_SUCCESS" and spellname ~= self.strMF and spellname ~= self.strMFI) or event == "SPELL_MISSED" ) then
		-- instant casts, spell misses
		self:PrepareClipTest( fCurTime );
	end
	
	-- "SPELL_DAMAGE" for WotLK, "SPELL_PERIODIC_DAMAGE" for Cataclysm
	if( (spellname == self.strMF or spellname == self.strMFI) and (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE") ) then
		-- ticks from channeled spell?
		local cc, nc = self.curchannel, self.nextchannel;
		local selcc = cc and cc or (nc and nc or nil);
		local selccnext = cc and false or (nc and true or false);

		if( selcc ) then
			-- tick
			local dmgdone = (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE") and dmg or 0;
			selcc.dmg = selcc.dmg + dmgdone;
			selcc.ticks = selcc.ticks + 1;
			selcc.hits = (bcrit or (event == "SPELL_MISSED" or event == "SPELL_PERIODIC_MISSED")) and selcc.hits or (selcc.hits + 1);
			selcc.crits = (bcrit and (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE")) and (selcc.crits + 1) or selcc.crits;

			if( (not selccnext and (cc and nc)) or selcc.ticks == selcc.maxticks ) then
				-- max ticks or last tick for current channel
				-- check channe3led spell out at once
				selcc.freqtest = selcc.freqtest and min(selcc.freqtest,fCurTime) or fCurTime;
				selcc.fforcedtest = selcc.fforcedtest and min(selcc.fforcedtest,fCurTime) or fCurTime;
			end
		else
			-- not channeling -> tick registered too late -> combat log screwed up -> thx blizz
			local dmgdone = (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE") and dmg or 0;
			self.mfdata.iTotalMFCount = self.mfdata.iTotalMFCount + 1;
			self.mfdata.iTotalMFCrit = (bcrit and (event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE")) and (self.mfdata.iTotalMFCrit + 1) or self.mfdata.iTotalMFCrit;
			self.mfdata.iTotalMFHit = (bcrit or (event == "SPELL_MISSED" or event == "SPELL_PERIODIC_MISSED")) and self.mfdata.iTotalMFHit or (self.mfdata.iTotalMFHit + 1);
			self.mfdata.iTotalMFDmg = self.mfdata.iTotalMFDmg + dmgdone;

			if( self.mfdata.bLastClipped ) then
				-- unintential clip was a false positive, remove from statistic
				self.mfdata.iTotalMFClipped = self.mfdata.iTotalMFClipped - 1;
				self.mfdata.bLastClipped = nil;
			end
		end
	end

	-- dot handling (rewritten for v1.23, simpler handling of dots to account for hasted ticks)
	if( self.tDots[spellname] ) then
		if( event == "SPELL_AURA_APPLIED" or event == "SPELL_PERIODIC_DAMAGE" ) then
			-- append unit
			if( not self.tDotsApplied[dguid] ) then
				self.tDotsApplied[dguid] = {
					name = dname,
					died = nil,
					dots = {},
				}
			end
			-- append dot
			if( not self.tDotsApplied[dguid].dots[spellname] ) then
				self.tDotsApplied[dguid].dots[spellname] = {
					applied = fCurTime,
					lasttick = nil,
					totticktime = 0.0,
					ticks = 0,
					dmg = 0,
					latesthaste = nil,
				}
			end
		end

		-- cataclysm dot handling
		if( self.tDotsApplied[dguid] and self.tDotsApplied[dguid].dots[spellname] ) then
			if( event == "SPELL_AURA_APPLIED" ) then
				self.tDotsApplied[dguid].dots[spellname].lasttick = fCurTime;
				local _, _, _, _, _, _, casttimeMB = GetSpellInfo( self.bars.mb.dotname );
				self.tDotsApplied[dguid].dots[spellname].latesthaste = max(1500/casttimeMB,1.0);	-- ignore negative haste
			elseif( event == "SPELL_AURA_REFRESH" ) then
				local _, _, _, _, _, _, casttimeMB = GetSpellInfo( self.bars.mb.dotname );
				self.tDotsApplied[dguid].dots[spellname].latesthaste = max(1500/casttimeMB,1.0);	-- ignore negative haste
			elseif( event == "SPELL_PERIODIC_DAMAGE" ) then
				if( self.tDotsApplied[dguid].dots[spellname].lasttick ) then
					self.tDotsApplied[dguid].dots[spellname].totticktime = self.tDotsApplied[dguid].dots[spellname].totticktime + fCurTime - self.tDotsApplied[dguid].dots[spellname].lasttick;
				else
					self.tDotsApplied[dguid].dots[spellname].totticktime = fCurTime - self.tDotsApplied[dguid].dots[spellname].applied;
				end
				self.tDotsApplied[dguid].dots[spellname].ticks = self.tDotsApplied[dguid].dots[spellname].ticks + 1;
				self.tDotsApplied[dguid].dots[spellname].dmg = self.tDotsApplied[dguid].dots[spellname].dmg + dmg;
				self.tDotsApplied[dguid].dots[spellname].lasttick = fCurTime;
			end
		end
	end
end

function MFClip:PLAYER_REGEN_DISABLED()
	local fCurTime = GetTime() * 1000;

	self.mfdata.iTotalMFCount, self.mfdata.iTotalMFCrit, self.mfdata.iTotalMFHit, self.mfdata.iTotalMFClipped,
	self.mfdata.iTotalMFDmg, self.mfdata.fTickedCastTime = 0, 0, 0, 0, 0, 0.0;
	self.mfdata.fTickedCasttime, self.mfdata.fLostCasttime = 0.0, 0.0;

	self.fEnteredCombat = fCurTime;
	self.logData = true;

	self.mbdata.iMBCount = 0;
	self.mbdata.iMBDmg = 0;
	self.mbdata.fMBTotalCasttime = 0.0;

	self.swddata.iSWDCount = 0;
	self.swddata.iSWDDmg = 0;
	self.swddata.fSWDTotalCasttime = 0.0;

	self:ShowLiveBars( true );
	self:ShowLiveButtons( true );

	for key, value in pairs(self.bars) do
		-- reset bar information
		value.bar:SetValue( 0 );
		value.tltext:SetText( "" );
		value.bltext:SetText( "" );
		value.trtext:SetText( "0%" );
		value.brtext:SetText( "" );
		value.rtext:SetText( "" );
		value.ctext:SetText( value.dotname );
		value.fLatestDuration = 0;
	end

	-- setup bars
	self:SetLBConfig( self.sdb.strLBinCconf, "error activating in combat config" );
end

function MFClip:PLAYER_REGEN_ENABLED()
	local fEOF = GetTime() * 1000;
	self.logData = false;

	local strTT = "", curStr;
	if( (fEOF - self.fEnteredCombat) >= (self.sdb.fmFL * 1000) ) then
		if( self.sdb.bShowCombat ) then
			if( self.mfdata.iTotalMFCount > 0 ) then
				if( self.sdb.bMFTS ) then
					curStr = "Mind Flay |cffeee8aatick statistics|r\n" .. MFClip:GenerateTickInfoString( self.mfdata.iTotalMFCount, self.mfdata.iTotalMFHit, self.mfdata.iTotalMFCrit, self.mfdata.iTotalMFClipped, self.mfdata.iTotalMFDmg );
					strTT = strTT .. curStr;

					if( not self.sdb.bLDBOutputOnly ) then
						self:Print( curStr );
					end
				end
				if( self.sdb.bMFCE ) then
					curStr = "Mind Flay |cffeee8aacasting estimations|r\n" .. MFClip:GenerateCastingInfoString( self.mfdata.fTickedCasttime, self.mfdata.iTotalMFDmg, self.mfdata.fLostCasttime, fEOF );
					if( strTT ~= "" ) then
						strTT = strTT .. "\n\n";
					end
					strTT = strTT .. curStr;

					if( not self.sdb.bLDBOutputOnly ) then
						self:Print( curStr );
					end
				end
			end
			if( self.sdb.bMFDS ) then
				curStr = self:ShowDotStatisticsLastFight( fEOF );
				if( curStr ~= "" ) then
					if( strTT ~= "" ) then
						strTT = strTT .. "\n\n";
					end
					strTT = strTT .. curStr;
				end
			end
		end
	end

	if( strTT ~= "" ) then
		self.strFightInfo = strTT;
	end

	self:ShowLiveButtons( true );

	self.tDotsApplied = {};
	self.mbdata.bMB = false;
	self.swddata.bSWD = false;

	for key, value in pairs(self.bars) do
		-- reset bar information
		value.bar:SetValue( 0 );
		value.lb1:Hide();
		value.lb2:Hide();
		value.lb3:Hide();
		value.lb4:Hide();
		value.lb5:Hide();
		value.ctext:SetText( value.dotname );
		value.rtext:SetText( "" );
	end

	for key, value in pairs(self.buttons) do
		if( value.text ) then
			value.text:SetText( "" );
		end
	end

	-- setup bars
	self:SetLBConfig( self.sdb.strLBooCconf, "error activating out of combat config" );
end

function MFClip:UNIT_ENTERED_VEHICLE( event, unit )
	if( unit == "player" ) then
		self.bVehicle = true;

		self:ShowLiveBars( true );
		self:ShowLiveButtons( true );
	end
end

function MFClip:UNIT_EXITED_VEHICLE( event, unit )
	if( unit == "player" ) then
		self.bVehicle = false;

		self:ShowLiveBars( true );
		self:ShowLiveButtons( true );
	end
end

function MFClip:PLAYER_ENTERING_WORLD()
	if( UnitInVehicle( "player" ) ) then
		self.bVehicle = true;
	else
		self.bVehicle = false;
	end

	self:ShowLiveBars( true );
	self:ShowLiveButtons( true );
end

function MFClip:GetRGBA( str )
	-- str looks like: "|c00rrggbb"
	local r, g, b, a;

	a = 1.0;
	r = floor( tonumber( "00" .. string_sub( str, 5 ), 16 ) / (256*256) ) / 255.0;
	g = floor( tonumber( "0000" .. string_sub( str, 7 ), 16 ) / (256) ) / 255.0;
	b = floor( tonumber( "000000" .. string_sub( str, 9 ), 16 ) ) / 255.0;

	return r,g,b,a;
end

function MFClip:SetRGBA( r, g, b, a )
	local strCol = string_format( "%x", floor(r*255)*256*256+floor(g*255)*256+floor(b*255) );
	strCol = string_sub( "00000000", string_len(strCol)+1 ) .. strCol;
	return "|c" .. strCol;
end

function MFClip:ShowDotStatisticsLastFight( fCurTime )
	local strRet = "";

	-- generate dot statistics
	for key, value in pairs(self.tDotsApplied) do
		local bOutput = false;
		local strOut = "Dot statistics for |cffeee8aa" .. value.name .. "|r";

		for key2, value2 in pairs(value.dots) do
			local fAppliedTickTime, fDotDPS, fDotDPSLost, fDotUptime, fDotDPSmax, fAvgTick, fMaxTicks;

			if( value.died ) then
				fAppliedTickTime = (value.died - value2.applied);
			else
				fAppliedTickTime = (fCurTime - value2.applied);
			end

			fAvgTick = value2.totticktime / value2.ticks;
			fMaxTicks = floor(fAppliedTickTime / fAvgTick);

			fDotUptime = value2.ticks / fMaxTicks;
			if( fDotUptime > 1.0 ) then
				fDotUptime = 1.0;
			end
			fDotDPS = floor(value2.dmg * 1000 / fAppliedTickTime);
			fDotDPSmax = fDotDPS / fDotUptime;
			fDotDPSLost = fDotDPSmax - fDotDPS;

			if( value2.ticks >= self.sdb.fMinDotCount ) then
				strOut = strOut .. string_format( "\n  |cffeee8aa%s|r (%s), %.0f DPS, %.0f DPS lost (max %.0f DPS)", self.tDots[key2].abbr, self:GenColPerc( fDotUptime ), fDotDPS, fDotDPSLost, fDotDPSmax );
				bOutput = true;	-- output threshold of fMinDotCount reached at least once
			end
		end

		if( bOutput == true ) then
			strRet = strRet .. strOut .. "\n";

			if( not self.sdb.bLDBOutputOnly ) then
				self:Print( strOut );
			end
		end
	end

	return strRet;
end

function MFClip:GenColPerc( fVal )
	local strCol;
	if( fVal >= 0.9 ) then
		strCol = "|cffbce937";
	elseif( fVal >= 0.8 ) then
		strCol = "|cffe3cf57";
	elseif( fVal >= 0.7 ) then
		strCol = "|cffdd7500";
	else
		strCol = "|cffff4500";
	end

	strCol = strCol .. string_format( "%.1f%%", fVal * 100 ) .. "|r";
	return strCol;
end

function MFClip:GenerateTickInfoString( mfcount, mfhit, mfcrit, mfclipped, mfdmg )
	str = string_format( "  %.0f Ticks (%.0f Hits, %.0f Crits -> %.1f%% crit rate)", mfcount, mfhit, mfcrit, mfcrit*100.0/mfcount );
	if( mfclipped > 0 ) then
		str = str .. string_format( "\n  %.0f Clipped (%.1f%% of possible Ticks)", mfclipped, mfclipped*100/(mfcount+mfclipped) );
	end
	str = str .. string_format( "\n  %.0f Dmg done by MF (%.0f est. dmg lost due to clipping)", mfdmg, mfdmg*mfclipped/mfcount );

	return str;
end

function MFClip:GenerateCastingInfoString( tickedcasttime, mftotaldmg, wastedcasttime, fEOF )
	str = "  |cffeee8aaChanneling:|r " .. string_format( "%.1fs ", (tickedcasttime)/1000.0 ) .. "(" .. math.floor(mftotaldmg/((tickedcasttime)/1000.0)) .. " DPS)";
	str = str .. "\n  |cffeee8aaEffective casting:|r " .. string_format( "%.1fs ", (wastedcasttime+tickedcasttime)/1000.0 ) .. "(" .. math.floor( mftotaldmg/((wastedcasttime+tickedcasttime)/1000.0)) .. " DPS)";
	str = str .. "\n  |cffeee8aaCast time loss:|r " .. string_format( "%.1fs, ", (wastedcasttime)/1000.0 ) .. string_format( "%.1f%% of Total", wastedcasttime/(wastedcasttime+tickedcasttime)*100.0 );

	if( self.mbdata.iMBDmg and self.mbdata.iMBDmg > 0 and self.mbdata.fFirstMBCasted) then
		local fMinCast = self.mbdata.fMBTotalCasttime/(self.mbdata.iMBCount*1000);
		local fCurCast = (fEOF-self.mbdata.fFirstMBCasted)/(self.mbdata.iMBCount*1000);

		if( fCurCast < fMinCast ) then
			fCurCast = fMinCast;
		end

		local fPerc = fMinCast / fCurCast;
		local iDPS = self.mbdata.iMBDmg * 1000 / (fEOF-self.mbdata.fFirstMBCasted);

		str = str .. "\n  |cffeee8aaMind Blast casting:|r " .. string_format( "%.2fs/%.2fs (%s)", fMinCast, fCurCast, self:GenColPerc(fPerc) );
		str = str .. "\n  |cffeee8aaMind Blast dps:|r " .. string_format( "%.0f of possible %.0f DPS", iDPS, iDPS / fPerc );
	end

	if( self.swddata.iSWDDmg and self.swddata.iSWDDmg > 0 and self.swddata.fFirstSWDCasted) then
		local fMinCast = self.swddata.fSWDTotalCasttime/(self.swddata.iSWDCount*1000);
		local fCurCast = (fEOF-self.swddata.fFirstSWDCasted)/(self.swddata.iSWDCount*1000);

		if( fCurCast < fMinCast ) then
			fCurCast = fMinCast;
		end

		local fPerc = fMinCast / fCurCast;
		local iDPS = self.swddata.iSWDDmg * 1000 / (fEOF-self.swddata.fFirstSWDCasted);

		str = str .. "\n  |cffeee8aaSW:Death casting:|r " .. string_format( "%.2fs/%.2fs (%s)", fMinCast, fCurCast, self:GenColPerc(fPerc) );
		str = str .. "\n  |cffeee8aaSW:Death dps:|r " .. string_format( "%.0f of possible %.0f DPS", iDPS, iDPS / fPerc );
	end

	return str;
end

function MFClip:CreateColorString( r, g, b, a )
	if( not (tonumber( r ) and tonumber( g ) and tonumber( b ) and tonumber ( a )) ) then
		return "";
	end

	local str = string_format( "%.2f, %.2f, %.2f, %.2f", r, g, b, a );
	return str;
end

function MFClip:GetColorsFromString( str, dst )
	str = str .. ",1.0,1.0,1.0,1.0";	-- append safety net (also default if illegal r,g,b values given
	local r, g, b, a = string_match( str, ".-([%+%-%.%d]+).-([%+%-%.%d]+).-([%+%-%.%d]+).-([%+%-%.%d]+)" );

	if( not (tonumber( r ) and tonumber( g ) and tonumber( b ) and tonumber ( a )) ) then
		r, g, b, a = nil, nil, nil, nil;
	else
		r, g, b, a = tonumber( r ), tonumber( g ), tonumber( b ), tonumber( a );
	end

	if( dst and r ) then
		dst.r, dst.g, dst.b, dst.a = r, g, b, a;
	end

	return r, g, b, a;
end

function MFClip:SetStatusByTalents()
	local iSpec = GetActiveSpecGroup();
	local iSpecCmd = (iSpec == 1) and MFClip.sdb.iSpec1Cmd or MFClip.sdb.iSpec2Cmd;

	if( iSpecCmd ) then
		if( iSpecCmd == 1 and self.sdb.bEnabled == false ) then
			-- addon disabled, enable for current spec
			self.sdb.bEnabled = true;
			self:Enable( true );
		elseif( iSpecCmd == 2 and self.sdb.bEnabled == true ) then
			-- addon enabled, disable for current spec
			self.sdb.bEnabled = false;
			self:Enable( false );
		end
	end
end

function MFClip:PLAYER_TALENT_UPDATE()
	self:SetStatusByTalents();
end
