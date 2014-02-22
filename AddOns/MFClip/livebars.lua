local UnitGUID = UnitGUID;
local UnitAura = UnitAura;
local GetSpellInfo = GetSpellInfo;
local unpack = unpack;
local pairs = pairs;
local max = max;
local min = min;
local floor = floor;
local string_format = string.format;
local string_find = string.find;

-- local variables
local _;

function MFClip:OOCLBConf( str )
	if( not self.logData ) then
		-- not in combat
		self:SetLBConfig( str );
	end

	self.sdb.strLBooCconf = str;
end

function MFClip:INCLBConf( str )
	if( self.logData ) then
		-- in combat
		self:SetLBConfig( str );
	end

	self.sdb.strLBinCconf = str;
end

function MFClip:LBConf( ooc, inc )
	self:OOCLBConf( ooc );
	self:Print( "out of combat: " .. ooc );
	self:INCLBConf( inc );
	self:Print( "in combat: " .. inc );
end

function MFClip:SetLBConfig( conf, strOnError )
	if( not self:SetupLiveBars( conf ) ) then
		if( strOnError ) then self:Print( strOnError ); end
		self:Print( "reverting to default configuration" );
		self:SetupLiveBars( self.tDefaults.strLBconf );
	end
end

function MFClip:SetLButtonsConfig( conf )

	local bRow = false;
	local bOk = true;

	for key, value in pairs(self.buttons) do
		value.bIsActive = false;
		value:ClearAllPoints();
		value:Hide();
	end

	self.sdb.bLiveButtonsCombat = false;
	local curAnchor = self.buttons.anchor;
	local _, _, firstWord, restOfString = string_find( conf, "(%w+)[%s%p]*(.*)");
	while firstWord do
		if( firstWord == "row" ) then
			bRow = true;
		end

		_, _, firstWord, restOfString = string_find( restOfString, "(%w+)[%s%p]*(.*)");
	end

	_, _, firstWord, restOfString = string_find( conf, "(%w+)[%s%p]*(.*)");
	while firstWord do
		local bExists = false;
		local bEnF = false;

		local cBut = self.buttons[firstWord];
		if( cBut ) then
			if( cBut.bIsActive ) then
				bExists = true;
			else
				cBut.bIsActive = true;
				if( bRow ) then
					cBut:SetPoint( "TOPLEFT", curAnchor, "TOPRIGHT", self.sdb.fLBSpacing, 0 );
				else
					cBut:SetPoint( "TOPLEFT", curAnchor, "BOTTOMLEFT", 0, (-1) * self.sdb.fLBSpacing );
				end
				curAnchor = cBut;
			end
		elseif( firstWord == "combat" ) then
			self.sdb.bLiveButtonsCombat = true;
		elseif( firstWord == "row" ) then
			-- already processed
		else
			self:Print( "LiveButtons config: illegal command " .. firstWord .. ", cancel" );
			bOk = false;
		end

		if( bExists ) then
			self:Print( "LiveButtons config: bar " .. firstWord .. " already exists, cancel" );
			bOk = false;
		end

		_, _, firstWord, restOfString = string_find( restOfString, "(%w+)[%s%p]*(.*)");
		self:ShowLiveButtons( true );
	end

	if( MFClip.db.profile["buttonanchor"] ) then
		local s = MFClip.db.profile["buttonanchor"].s;
		self.buttons.anchor:SetPoint( "TOPLEFT", UIParent, "BOTTOMLEFT", MFClip.db.profile["buttonanchor"].x / s, MFClip.db.profile["buttonanchor"].y / s );
	else
		self.buttons.anchor:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 );
	end
end

function MFClip:SetupLiveBars( conf )
	local bOk = true;

	for key, value in pairs(self.bars) do
		value.bIsActive = false;
		value:ClearAllPoints();
		value:Hide();
	end

	self.sdb.bLiveBarsEnabled = true;
	self.sdb.bHideCastbarWNC = false;
	self.sdb.bLiveButtonsEnabled = false;
	local curAnchor = self.bars.anchor;
	local _, _, firstWord, restOfString = string_find( conf, "(%w+)[%s%p]*(.*)");
	while firstWord do
		local bExists = false;
		local cBar = (firstWord == "cast") and self.bars.mf or self.bars[firstWord];
		if( cBar ) then
			if( cBar.bIsActive ) then
				bExists = true;
			else
				cBar.bIsActive = true;
				cBar:SetPoint( "TOPLEFT", curAnchor, "BOTTOMLEFT", 0, (-1) * self.sdb.fLBSpacing );
				curAnchor = cBar;
			end
		elseif( firstWord == "on" ) then
			self.sdb.bLiveBarsEnabled = true;
		elseif( firstWord == "off" ) then
			self.sdb.bLiveBarsEnabled = false;
		elseif( firstWord == "hidecb" ) then
			self.sdb.bHideCastbarWNC = true;
		elseif( firstWord == "showcb" ) then
			self.sdb.bHideCastbarWNC = false;
		elseif( firstWord == "buttons" ) then
			self.sdb.bLiveButtonsEnabled = true;
		else
			self:Print( "LiveBars config: illegal command " .. firstWord .. ", cancel" );
			bOk = false;
		end

		if( bExists ) then
			self:Print( "LiveBars config: bar " .. firstWord .. " already exists, cancel" );
			bOk = false;
		end

		_, _, firstWord, restOfString = string_find( restOfString, "(%w+)[%s%p]*(.*)");
	end

	if( MFClip.db.profile["anchor"] ) then
		local s = MFClip.db.profile["anchor"].s;
		self.bars.anchor:SetPoint( "TOPLEFT", UIParent, "BOTTOMLEFT", MFClip.db.profile["anchor"].x / s, MFClip.db.profile["anchor"].y / s );
	else
		self.bars.anchor:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 );
	end

	MFClip:ResizeLBBars();
	if( self.sdb.bLiveBarsEnabled ) then
		MFClip:ShowLiveBars( true );
	else
		MFClip:ShowLiveBars( false );
	end

	self:ResizeLButtons();
	if( self.sdb.bLiveBarsEnabled and self.sdb.bLiveButtonsEnabled ) then
		self:ShowLiveButtons( true );
	else
		self:ShowLiveButtons( false );
	end

	return bOk;
end

function MFClip:UpdateLiveBars( fCurTime, bLogData )

	local targuid = UnitGUID( "target" );
	local focguid = UnitGUID( "focus" );

	-- castbar
	if( self.bars.mf.bIsActive ) then
		local fRemaining = (self.castend > fCurTime) and (self.castend - fCurTime) or 0.0;

		if( self.bIsActiveCB and fRemaining > 0.0 ) then
			self.bars.mf.cbs:Show();	-- prevents hidden castbar spark
			local fR, size = fRemaining / self.casttime, self.bars.mf.bar:GetWidth();
			if( self.channeling ) then
				self.bars.mf.bar:SetValue( fR * 100 );
				self.bars.mf.cbs:SetPoint( "CENTER", self.bars.mf.bar, "LEFT", fR * size, 0 );
			elseif( self.casting ) then
				self.bars.mf.bar:SetValue( (1-fR) * 100 );
				self.bars.mf.cbs:SetPoint( "CENTER", self.bars.mf.bar, "LEFT", (1-fR) * size, 0 );
			end

			if( self.castname == self.strMF or self.castname == self.strMFI ) then
				if( self.mfdata.td.pb > 0.0 ) then
					self.bars.mf.bltext:SetText( string_format( "|c00ff0000-%.2f|r", self.mfdata.td.pb / 1000.0 ) );
				end
				self.bars.mf.ctext:SetText( string_format( "%.1fs", fRemaining / 1000.0 ) );
				self:ShowMindFlayDataOnCastbar();
			else
				self.bars.mf.trtext:SetText( "" );
				self.bars.mf.brtext:SetText( "" );
				if( self.mfdata.td.pb > 0.0 ) then
					self.bars.mf.rtext:SetText( string_format( "|c00ff0000%+.2f|r  %.1f / %.2f", (-1)*self.mfdata.td.pb / 1000.0, fRemaining / 1000.0, self.casttime / 1000.0 ) );
				else
					self.bars.mf.rtext:SetText( string_format( "%.1f / %.2f", fRemaining / 1000.0, self.casttime / 1000.0 ) );
				end
			end
		else
			-- fade out bar
			if( self.bFadeoutCB ) then
				local fTime = fCurTime - self.fCleanupReqTime;

				if( fTime > 500 ) then
					self.bFadeoutCB = false;
					self.bars.mf:Hide();
					self:CleanUpCastbar();
				else
					self.bars.mf:SetAlpha( (500-fTime)/500 );
				end
			end
		end
	end

	if( bLogData ) then
			-- scan current target for dots
		if( targuid ) then
			for key, value in pairs(self.bars) do
				if( value.bIsDot and value.bIsActive ) then
					local fHaste = nil;

					-- generate dps and dot uptime data for bars
					local stguid = self.tDotsApplied[targuid]
					if( stguid and stguid.dots and stguid.dots[value.dotname] ) then
						local stguiddot = stguid.dots[value.dotname];
						local fAppliedTickTime, fDotDPS, fDotDPSLost, fDotUptime, fDotDPSmax, fAvgTick, fMaxTicks;
						fHaste = stguiddot.latesthaste;

						if( stguid.died ) then
							fAppliedTickTime = (stguid.died - stguiddot.applied);
						else
							fAppliedTickTime = (fCurTime - stguiddot.applied);
						end

						fAvgTick = stguiddot.totticktime / stguiddot.ticks;
						fMaxTicks = floor(fAppliedTickTime / fAvgTick);

						fDotUptime = floor(stguiddot.ticks * 100 / fMaxTicks + 0.5);
						fDotDPS = floor(stguiddot.dmg * 1000 / fAppliedTickTime);

						-- need stable value for at least 1.5s to print out
						--		below 1500ms uptime value tends to change alot when near 100% of possible uptime
						if( stguiddot.lasttickuptime and stguiddot.lasttickuptimecurtime < (fCurTime - 1500) and fDotUptime == stguiddot.lasttickuptime ) then
							value.trtext:SetText( fDotUptime .. "%" );
							value.brtext:SetText( fDotDPS .. " DPS" );
						end

						if( stguiddot.lasttickuptime == nil ) then
							stguiddot.lasttickuptime = fDotUptime;
							stguiddot.lasttickuptimecurtime = fCurTime;
						elseif( stguid.dots[value.dotname].lasttickuptime ~= fDotUptime ) then
							stguiddot.lasttickuptime = fDotUptime;
							stguiddot.lasttickuptimecurtime = fCurTime;
						end
					elseif( targuid ) then
						value.trtext:SetText( "0%" );
						value.brtext:SetText( "" );
					end

					-- dot timer information
					local name, _, _, _, _, duration, expirationTime = UnitAura( "target", value.dotname, nil, "PLAYER|HARMFUL" );
					if( name ) then
						-- found playerbuff
						duration, expirationTime = duration * 1000, expirationTime * 1000;

						-- new dot?
						if( duration ~= value.fLatestDuration ) then
							if( not fHaste ) then
								local _, _, _, _, _, _, casttimeMB = GetSpellInfo( self.bars.mb.dotname );
								fHaste = max( 1500/casttimeMB, 1.0 );
							end

							-- guess original ticks
							--local initTicks = floor( duration / 3000 + 0.35 );
							--local hastedTicks = floor( initTicks * fHaste + 0.5 );
							--value.fEstTickTime = duration / hastedTicks;

							--[[ guess original ticks, often guesses one tick too much
							which is not really bad for safer recasting,
							would need a database (including set bonus, ...) with
							initial tick counts for 100% correct value which I really
							do not want to implement into MFClip ]]
							local initTicks = floor( duration / 3000 + max(15000/duration,1.0) * 0.375);
							local hastedTicks = floor( initTicks * fHaste + 0.5 );
							value.fEstTickTime = duration / hastedTicks;
						end
						value.fLatestDuration = duration;

						local expIn = expirationTime - fCurTime;
						local expires = duration;
						if( self.sdb.iZoom > 0.0 and expIn <= (self.sdb.iZoom*1000) ) then
							expires = self.sdb.iZoom * 1000;
						end

						value.bar:SetValue( expIn / expires * 100 );

						if( self.sdb.bShowSparkForAll ) then
							value.cbs:Show();
							value.cbs:SetPoint( "CENTER", value.bar, "LEFT", expIn / expires * value.bar:GetWidth(), 0 );
						end

						if( expIn > 0 ) then
							value.ctext:SetText( string_format( "%.1fs", expIn / 1000 ) );
						end

						if( name == self.strVT ) then
							local _, _, _, _, _, _, castTime = GetSpellInfo( name );
							local ctlagTime = castTime + self.lag;

							if( expIn <= 0.1 ) then
								value.lb1:Hide();
							elseif( expIn < (ctlagTime) ) then
								r,g,b,a = unpack( self.sdb.lblagcolor );
								value.lb1:SetTexture( r,g,b,min(a+0.2,1.0) );
							else
								local ctlagSize = min( ctlagTime / expires, 1.0 );
								local esttickSize = min( value.fEstTickTime / expires, 1.0 - ctlagSize );
								value.lb1:SetPoint( "LEFT", ctlagSize * value.bar:GetWidth(), 0 );
								value.lb1:SetWidth( esttickSize * value.bar:GetWidth() );
								value.lb1:SetTexture( unpack( self.sdb.lblagcolor ) );
								value.lb1:Show();
							end
						else
							if( expIn <= 0.0 ) then
								value.lb1:Hide();
							else
								local lagSize = min( self.lag / expires, 1.0 );
								local esttickSize = min( value.fEstTickTime / expires, 1.0 - lagSize )
								value.lb1:SetPoint( "LEFT", lagSize * value.bar:GetWidth(), 0 );
								value.lb1:SetWidth( esttickSize * value.bar:GetWidth() );
								value.lb1:SetTexture( unpack( self.sdb.lblagcolor ) );
								value.lb1:Show();
							end
						end
					else
						value.lb1:Hide();
						value.bar:SetValue( 0 );
						value.ctext:SetText( "" );
						value.cbs:Hide();
					end
				end
			end
		end

		-- scan focus target for dots (by active buttons)
		if( self.sdb.bLiveButtonsEnabled ) then
			for key, value in pairs(self.buttons) do
				if( value.bIsDot and value.bIsActive ) then
					local name, _, _, _, _, duration, expirationTime = UnitAura( "focus", value.spell, nil, "PLAYER|HARMFUL" );
					if( name ) then
						duration, expirationTime = duration * 1000, expirationTime * 1000;

						-- found playerbuff
						local expIn = expirationTime - fCurTime;
						if( expIn > 9949 ) then
							value.text:SetText( string_format( "%.0f", floor(expIn / 1000) ) );
						elseif( expIn > 0 ) then
							value.text:SetText( string_format( "%.1f", expIn / 1000 ) );
						end
					else
						value.text:SetText( "" );
					end
				end
			end
		end
		
		-- mind blast statistics
		if( self.mbdata.bMB ) then
			local fLeft = self.mbdata.fMBCDend - fCurTime;
			local perc;
			if( fLeft <= 0.0 ) then
				fLeft = 0.0;
				perc = self.mbdata.fMBTotalCasttime / (fCurTime - self.mbdata.fFirstMBCasted) * 100.0;
			else
				perc = (self.mbdata.fMBTotalCasttime - fLeft) / (fCurTime - self.mbdata.fFirstMBCasted) * 100.0;
			end

			perc = floor(perc + 0.5);
			if( perc > 100.0 ) then perc = 100.0; end

			self.bars.mb.bar:SetValue( fLeft );
			if( self.sdb.bShowSparkForAll ) then
				self.bars.mb.cbs:Show();
				self.bars.mb.cbs:SetPoint( "CENTER", self.bars.mb.bar, "LEFT", fLeft / self.mbdata.fMBCD * self.bars.mb.bar:GetWidth(), 0 );
			end

			fLeft = fLeft / 1000.0;
			if( fLeft <= 0.0 ) then
				self.bars.mb.cbs:Hide();
				self.bars.mb.ctext:SetText( "" );
				self.buttons.mb.text:SetText( "" );
			else
				self.bars.mb.ctext:SetText( string_format( "%.1fs", fLeft ) );
				self.buttons.mb.text:SetText( string_format( "%.1f", fLeft ) );
			end

			if( perc == self.mbdata.fMBPriorVal ) then	-- minimum of 1000ms without change of value to have more constant output
				if( (self.mbdata.fMBPriorTime + 1000) < fCurTime ) then
					self.bars.mb.trtext:SetText( perc .. "%" );
					self.bars.mb.brtext:SetText( string_format( "%.0f DPS", self.mbdata.iMBDmg * 1000 / (fCurTime-self.mbdata.fFirstMBCasted) ) );
				end
			else
				self.mbdata.fMBPriorVal = perc;
				self.mbdata.fMBPriorTime = fCurTime;
			end

			if( fLeft <= 0.0 ) then
				self.bars.mb.lb1:Hide();
			else
				self.bars.mb.lb1:SetWidth( min( 0.2, self.lag / self.mbdata.fMBCD ) * self.bars.mb.bar:GetWidth() );
				self.bars.mb.lb1:SetTexture( unpack( self.sdb.lblagcolor ) );
				self.bars.mb.lb1:Show();
			end
		else
			self.bars.mb.bar:SetValue( 0 );
			self.bars.mb.ctext:SetText( "" );
			self.bars.mb.lb1:Hide();
			self.buttons.mb.text:SetText( "" );
			self.bars.mb.bltext:SetText( "" );
		end

		-- shadow word: death statistics
		if( self.swddata.bSWD ) then
			local fLeft = self.swddata.fSWDCDend - fCurTime;
			local perc;
			if( fLeft <= 0.0 ) then
				fLeft = 0.0;
				perc = self.swddata.fSWDTotalCasttime / (fCurTime - self.swddata.fFirstSWDCasted) * 100.0;
			else
				perc = (self.swddata.fSWDTotalCasttime - fLeft) / (fCurTime - self.swddata.fFirstSWDCasted) * 100.0;
			end

			perc = floor(perc + 0.5);
			if( perc > 100.0 ) then perc = 100.0; end

			self.bars.swd.bar:SetValue( fLeft );
			if( self.sdb.bShowSparkForAll ) then
				self.bars.swd.cbs:Show();
				self.bars.swd.cbs:SetPoint( "CENTER", self.bars.swd.bar, "LEFT", fLeft / self.swddata.fSWDCD * self.bars.swd.bar:GetWidth(), 0 );
			end

			fLeft = fLeft / 1000.0;
			if( fLeft <= 0.0 ) then
				self.bars.swd.cbs:Hide();
				self.bars.swd.ctext:SetText( "" );
				self.buttons.swd.text:SetText( "" );
			else
				self.bars.swd.ctext:SetText( string_format( "%.1fs", fLeft ) );
				self.buttons.swd.text:SetText( string_format( "%.1f", fLeft ) );
			end

			if( perc == self.swddata.fSWDPriorVal ) then	-- minimum of 1000ms without change of value to have more constant output
				if( (self.swddata.fSWDPriorTime + 1000) < fCurTime ) then
					self.bars.swd.trtext:SetText( perc .. "%" );
					self.bars.swd.brtext:SetText( string_format( "%.0f DPS", self.swddata.iSWDDmg * 1000 / (fCurTime-self.swddata.fFirstSWDCasted) ) );
				end
			else
				self.swddata.fSWDPriorVal = perc;
				self.swddata.fSWDPriorTime = fCurTime;
			end

			if( fLeft <= 0.0 ) then
				self.bars.swd.lb1:Hide();
			else
				self.bars.swd.lb1:SetWidth( min( 0.2, self.lag / self.swddata.fSWDCD ) * self.bars.swd.bar:GetWidth() );
				self.bars.swd.lb1:SetTexture( unpack( self.sdb.lblagcolor ) );
				self.bars.swd.lb1:Show();
			end
		else
			self.bars.swd.bar:SetValue( 0 );
			self.bars.swd.ctext:SetText( "" );
			self.bars.swd.lb1:Hide();
			self.buttons.swd.text:SetText( "" );
		end
	end
end

function MFClip:ResizeSingleBar( bar, width, height, scale )
	if( bar ) then
		bar:SetWidth( width + 3 * self.sdb.fLBBorder );
		bar:SetHeight( height + 2 * self.sdb.fLBBorder );

		bar.t:SetPoint( "TOPLEFT", bar, "TOPLEFT", 0, 0 );
		bar.t:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMLEFT", 2 * self.sdb.fLBBorder + height, 0 );
		bar.t2:SetPoint( "TOPLEFT", bar, "TOPLEFT", 2 * self.sdb.fLBBorder + height, 0 );
		bar.t2:SetPoint( "BOTTOMRIGHT", bar, "TOPLEFT", width + 3 * self.sdb.fLBBorder, (-1) * self.sdb.fLBBorder );
		bar.t3:SetPoint( "TOPLEFT", bar, "BOTTOMLEFT", 2 * self.sdb.fLBBorder + height, self.sdb.fLBBorder );
		bar.t3:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMLEFT", width + 3 * self.sdb.fLBBorder, 0 );
		bar.t4:SetPoint( "TOPLEFT", bar, "TOPRIGHT", (-1) * self.sdb.fLBBorder, 0 );
		bar.t4:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0 );
		bar.t5:SetPoint( "TOPLEFT", bar, "TOPLEFT", height + 2 * self.sdb.fLBBorder, (-1) * self.sdb.fLBBorder );
		bar.t5:SetPoint( "BOTTOMRIGHT", bar, "BOTTOMRIGHT", (-1) * self.sdb.fLBBorder, self.sdb.fLBBorder );

		local curFont = self.lsm:Fetch( "font", self.sdb.font );
		bar.trtext:SetFont( curFont, height/2 * 0.95 );
		bar.brtext:SetFont( curFont, height/2 * 0.95 );
		bar.tltext:SetFont( curFont, height/2 * 0.95 );
		bar.bltext:SetFont( curFont, height/2 * 0.95 );
		bar.ctext:SetFont( curFont, height * 0.65 );
		bar.rtext:SetFont( curFont, height * 0.55 );

		bar.bar:ClearAllPoints();
		bar.bar:SetPoint( "RIGHT", bar, "RIGHT", (-1) * self.sdb.fLBBorder, 0 );
		bar.bar:SetWidth( width - height );
		bar.bar:SetHeight( height );

		bar.icon:ClearAllPoints();
		bar.icon:SetPoint( "TOPLEFT", bar, "TOPLEFT", self.sdb.fLBBorder, self.sdb.fLBBorder * (-1) );
		bar.icon:SetPoint( "BOTTOMLEFT", bar, "BOTTOMLEFT", self.sdb.fLBBorder, self.sdb.fLBBorder );
		bar.icon:SetWidth( height );

		bar.lb1:SetHeight( height );
		bar.lb2:SetHeight( height );
		bar.lb3:SetHeight( height );
		bar.lb4:SetHeight( height );
		bar.lb5:SetHeight( height );

		bar.cbs:SetWidth( height * 0.35 * self.sdb.fSparkWidthMulti );
		bar.cbs:SetHeight( height * 1.5 * self.sdb.fSparkHeightMulti );
		bar.cbs:Hide();

		if( self.sdb.bHideLBDetails ) then
			bar.trtext:Hide();
			bar.brtext:Hide();
		else
			bar.trtext:Show();
			bar.brtext:Show();
		end

		bar:SetScale( scale );
	end
end

function MFClip:ResizeSingleButton( button, scale )
	if( button ) then
		button:SetScale( scale );
	end
end

function MFClip:ResizeLBBars()
	for key, value in pairs(self.bars) do
		self:ResizeSingleBar( value, self.sdb.fLBWidth, self.sdb.fLBHeight,  self.sdb.fLBScale );
	end
end

function MFClip:ResizeLButtons()
	for key, value in pairs(self.buttons) do
		self:ResizeSingleButton( value, self.sdb.fLButtonsScale );

		if( value.text ) then
			local curFont = GameFontNormal:GetFont();
			if( self.sdb.font ~= nil and self.sdb.font ~= "" and self.fonts and self.fonts[self.sdb.font] ) then
				curFont = self.fonts[self.sdb.font];
			end
			local _, height = value.text:GetFont();
			value.text:SetFont( curFont, height );
		end
	end
end

function MFClip:CFS( bar, height )
	local fs = bar:CreateFontString( nil, "OVERLAY", "GameFontHighlightSmallOutline" );

	local curFont = GameFontNormal:GetFont();
	if( self.sdb.font ~= nil and self.sdb.font ~= "" and self.fonts and self.fonts[self.sdb.font] ) then
		curFont = self.fonts[self.sdb.font];
	end
	fs:SetFont( curFont, height );

	return fs;
end

function MFClip:SetBarColors()
	for key, value in pairs(self.bars) do
		self:SetBarColor( value );
	end
end

function MFClip:SetBarColor( bar )
	bar.t:SetTexture( unpack( self.sdb.lbbordercolor ) );
	bar.t2:SetTexture( unpack( self.sdb.lbbordercolor ) );
	bar.t3:SetTexture( unpack( self.sdb.lbbordercolor ) );
	bar.t4:SetTexture( unpack( self.sdb.lbbordercolor ) );
	bar.t5:SetTexture( unpack( self.sdb.lbbarbgcolor ) );

	bar.bar:SetStatusBarTexture( self.lsm:Fetch( "statusbar", self.sdb.lbtexture ), "BORDER" );
	bar.bar:SetStatusBarColor( unpack( self.sdb.lbbarcolor ) );
	bar.lb1:SetTexture( unpack( self.sdb.lblagcolor ) );
	bar.lb2:SetTexture( unpack( self.sdb.lblagcolor ) );
	bar.lb3:SetTexture( unpack( self.sdb.lblagcolor ) );
	bar.lb4:SetTexture( unpack( self.sdb.lblagcolor ) );
	bar.lb5:SetTexture( unpack( self.sdb.lblagcolor ) );

	bar.trtext:SetTextColor( unpack( self.sdb.lbtextcolor ) );
	bar.brtext:SetTextColor( unpack( self.sdb.lbtextcolor ) );
	bar.tltext:SetTextColor( unpack( self.sdb.lbtextcolor ) );
	bar.bltext:SetTextColor( unpack( self.sdb.lbtextcolor ) );
	bar.ctext:SetTextColor( unpack( self.sdb.lbtextcolor ) );
	bar.rtext:SetTextColor( unpack( self.sdb.lbtextcolor ) );

	bar.cbs:SetVertexColor( unpack( self.sdb.sparkcolor ) );
end

function MFClip:CreateLiveButton( name, iconpath, width, height, infotext, spell, bIsDot )

	local f = CreateFrame( "Button", name, UIParent, "SecureActionButtonTemplate" );
	f:SetFrameStrata( "MEDIUM" );
	f:SetWidth( width + 3 * self.sdb.fLBBorder );
	f:SetHeight( height + 2 * self.sdb.fLBBorder );
	f.name = name;
	f.spell = spell;

	local t = f:CreateTexture( nil, "BACKGROUND" );
	t:SetPoint( "TOPLEFT", f, "TOPLEFT", 0, 0 );
	t:SetPoint( "BOTTOMRIGHT", f, "BOTTOMLEFT", 2 * self.sdb.fLBBorder + height, 0 );
	t:SetTexture( unpack( self.sdb.lbbordercolor ) );
	f.t = t;

	local icon = f:CreateTexture( nil, "ARTWORK" );
	icon:SetTexCoord( 0.09, 0.91, 0.09, 0.91 );
	icon:SetWidth( height );
	icon:SetPoint( "TOPLEFT", f, "TOPLEFT", self.sdb.fLBBorder, self.sdb.fLBBorder * (-1) );
	icon:SetPoint( "BOTTOMLEFT", f, "BOTTOMLEFT", self.sdb.fLBBorder, self.sdb.fLBBorder );
	icon:SetTexture( iconpath );
	icon:SetAlpha( 0.7 );
	icon:Show();
	f.icon = icon;

	local text = self:CFS( f, height * 0.65 );
	text:SetPoint( "CENTER", f, "CENTER", 0, 0 );
	f.text = text;
	f.text:SetTextColor( 1.0, 1.0, 1.0, 1.0 );

	f:Show();

	f:SetAttribute( "type", "spell" );
	f:SetAttribute( "unit", "focus" );
	f:SetAttribute( "spell", spell );
	f:RegisterForClicks( "AnyDown" );

	f.bIsDot = bIsDot;
	f.bIsActive = true;

	return f;
end

function MFClip:CreateLiveBar( name, iconpath, width, height, minval, maxval, curval, dotname, infotext, bIsDot )
	local f = CreateFrame( "Frame", name, UIParent );
	f:SetFrameStrata( "MEDIUM" );
	f:SetWidth( width + 3 * self.sdb.fLBBorder );
	f:SetHeight( height + 2 * self.sdb.fLBBorder );
	f.name = name;

	-- border textures
	local t, t2, t3, t4, t5 = f:CreateTexture( nil, "BACKGROUND" ), f:CreateTexture( nil, "BACKGROUND" ), f:CreateTexture( nil, "BACKGROUND" ), f:CreateTexture( nil, "BACKGROUND" ), f:CreateTexture( nil, "BACKGROUND" );
	t:SetPoint( "TOPLEFT", f, "TOPLEFT", 0, 0 );
	t:SetPoint( "BOTTOMRIGHT", f, "BOTTOMLEFT", 2 * self.sdb.fLBBorder + height, 0 );
	t2:SetPoint( "TOPLEFT", f, "TOPLEFT", 2 * self.sdb.fLBBorder + height, 0 );
	t2:SetPoint( "BOTTOMRIGHT", f, "TOPLEFT", width + 3 * self.sdb.fLBBorder, (-1) * self.sdb.fLBBorder );
	t3:SetPoint( "TOPLEFT", f, "BOTTOMLEFT", 2 * self.sdb.fLBBorder + height, self.sdb.fLBBorder );
	t3:SetPoint( "BOTTOMRIGHT", f, "BOTTOMLEFT", width + 3 * self.sdb.fLBBorder, 0 );
	t4:SetPoint( "TOPLEFT", f, "TOPRIGHT", width + 2 * self.sdb.fLBBorder, self.sdb.fLBBorder );
	t4:SetPoint( "BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0 );
	t5:SetPoint( "TOPLEFT", f, "TOPLEFT", width + 2 * self.sdb.fLBBorder, (-1) * self.sdb.fLBBorder );
	t5:SetPoint( "BOTTOMRIGHT", f, "BOTTOMRIGHT", (-1) * self.sdb.fLBBorder, self.sdb.fLBBorder );
	f.t, f.t2, f.t3, f.t4, f.t5 = t, t2, t3, t4, t5;

	local icon = f:CreateTexture( nil, "ARTWORK" );
	icon:SetTexCoord( 0.09, 0.91, 0.09, 0.91 );
	icon:SetWidth( height );
	icon:SetPoint( "TOPLEFT", f, "TOPLEFT", self.sdb.fLBBorder, self.sdb.fLBBorder * (-1) );
	icon:SetPoint( "BOTTOMLEFT", f, "BOTTOMLEFT", self.sdb.fLBBorder, self.sdb.fLBBorder );
	icon:SetTexture( iconpath );
	icon:Show();
	f.icon = icon;

	local bar = self:CreateStatusBar( f );
	bar:SetWidth( width - height );
	bar:SetHeight( height );
	bar:SetPoint( "RIGHT", f, "RIGHT", (-1) * self.sdb.fLBBorder, 0 );
	bar:SetStatusBarTexture( self.lsm:Fetch( "statusbar", self.sdb.lbtexture ), "BORDER" );
	bar:SetOrientation( "HORIZONTAL", false );
	bar:SetMinMaxValues( minval, maxval );
	bar:SetValue( curval );

	f.bar = bar;
	f:Show();

	-- latency bar 1
	local lb1 = f.bar:CreateTexture( nil, "ARTWORK" );
	lb1:SetPoint( "LEFT", 0, 0 );
	lb1:Hide();
	local lb2 = f.bar:CreateTexture( nil, "ARTWORK" );
	lb2:SetPoint( "LEFT", f.bar:GetWidth() * 0.333333, 0 );
	lb2:Hide();
	local lb3 = f.bar:CreateTexture( nil, "ARTWORK" );
	lb3:SetPoint( "LEFT", f.bar:GetWidth() * 0.4, 0 );
	lb3:Hide();
	local lb4 = f.bar:CreateTexture( nil, "ARTWORK" );
	lb4:SetPoint( "LEFT", f.bar:GetWidth() * 0.6, 0 );
	lb4:Hide();
	local lb5 = f.bar:CreateTexture( nil, "ARTWORK" );
	lb5:SetPoint( "LEFT", f.bar:GetWidth() * 0.8, 0 );
	lb5:Hide();

	f.lb1 = lb1;
	f.lb2 = lb2;
	f.lb3 = lb3;
	f.lb4 = lb4;
	f.lb5 = lb5;

	local trtext = self:CFS( f.bar, height/2*0.95 );
	trtext:SetPoint( "TOPRIGHT", f.bar, -1, -1 );
	f.trtext = trtext;
	local brtext = self:CFS( f.bar, height/2*0.95 );
	brtext:SetPoint( "BOTTOMRIGHT", f.bar, -1, 1 );
	f.brtext = brtext;
	local tltext = self:CFS( f.bar, height/2*0.95 );
	tltext:SetPoint( "TOPLEFT", f.bar, 1, -1 );
	f.tltext = tltext;
	local bltext = self:CFS( f.bar, height/2*0.95 );
	bltext:SetPoint( "BOTTOMLEFT", f.bar, 1, 1 );
	f.bltext = bltext;
	local ctext = self:CFS( f.bar, height*0.65 );
	ctext:SetPoint( "LEFT", f.bar, 3, 0 );
	ctext:SetPoint( "RIGHT", trtext, "LEFT", -5, 0 );
	f.ctext = ctext;
	local rtext = self:CFS( f.bar, height*0.55 );
	rtext:SetPoint( "RIGHT", f.bar, -4, 0 );
	f.rtext = rtext;

	f.dotname = dotname;

	f.ctext:SetText( dotname );
	f.trtext:SetText( infotext );

	local cbs = f.bar:CreateTexture( nil, "OVERLAY" );
	cbs:SetTexture( "Interface\\CastingBar\\UI-CastingBar-Spark" );
	cbs:SetBlendMode( "ADD" );
	cbs:SetWidth( height * 0.35 * self.sdb.fSparkWidthMulti );
	cbs:SetHeight( height * 1.5 * self.sdb.fSparkHeightMulti );
	cbs:Hide();
	f.cbs = cbs;

	f.bIsDot = bIsDot;
	f.fLatestDuration = 0;

	self:SetBarColor( f );

	return f;
end

local function OnDragStart( frame )
	frame:StartMoving();
end

local function OnDragStop( frame )
	frame:StopMovingOrSizing();
	local s = frame:GetEffectiveScale();

	if( frame.name == "anchor" ) then
		MFClip.sdb["anchor"] = {
			["x"] = frame:GetLeft() * s,
			["y"] = frame:GetTop() * s,
			["s"] = s,
		};
	elseif( frame.name == "buttonanchor" ) then
		MFClip.sdb["buttonanchor"] = {
			["x"] = frame:GetLeft() * s,
			["y"] = frame:GetTop() * s,
			["s"] = s,
		};
	end
end

function MFClip:MakeMovable( bar, status )
	if( status ) then
		bar:EnableMouse( status );
		bar:SetMovable( status );
		bar:RegisterForDrag( "LeftButton" );
		bar:SetScript( "OnDragStart", OnDragStart );
		bar:SetScript( "OnDragStop", OnDragStop );
	else
		bar:EnableMouse( status );
	end
end

function MFClip:ForceHideBars()
	for key, value in pairs(self.bars) do
		value:Hide();
	end
end

function MFClip:ForceHideButtons()
	for key, value in pairs(self.buttons) do
		if( value.bIsActive ) then
			value:Hide();
		end
	end
end

function MFClip:ForceShowBars()
	for key, value in pairs(self.bars) do
		if( key == "mf" ) then
			if( value.bIsActive and (self.bIsActiveCB or not self.sdb.bHideCastbarWNC) ) then
				value:Show();
				value:SetAlpha( 1 );
			end
		elseif( key ~= "anchor" ) then
			if( value.bIsActive ) then
				value:Show();
				value:SetAlpha( 1 );
			end
		end
	end
end

function MFClip:ForceShowButtons()
	for key, value in pairs(self.buttons) do
		if( value.bIsActive ) then
			value:Show();
		end
	end
end

function MFClip:ShowBars()
	self:ForceShowBars();
end

function MFClip:HideBars()
	self:ForceHideBars();
end

function MFClip:ShowAnchor( status )
	if( status ) then
		if( self.sdb.bLiveBarsEnabled ) then
			self.bars.anchor:Show();
		else
			self.bars.anchor:Hide();
		end
	else
		self.bars.anchor:Hide();
	end
end

function MFClip:ShowLiveButtons( status )
	if( status ) then
		if( self.sdb.bEnabled == false ) then
			self.buttons.anchor:Hide();
			self:ForceHideButtons();
		elseif( self.sdb.bLiveButtonsEnabled ) then
			if( self.sdb.bHideInVehicle and self.bVehicle ) then
				self:ForceHideButtons();
			else
				if( self.sdb.bShowAnchor ) then
					self.buttons.anchor:Show();
				else
					self.buttons.anchor:Hide();
				end

				if( (self.sdb.bLiveButtonsCombat and self.logData) or (not self.sdb.bLiveButtonsCombat) ) then
					self:ForceShowButtons();
				else
					self:ForceHideButtons();
				end
			end
		else
			self.buttons.anchor:Hide();
			self:ForceHideButtons();
		end
	else
		self.buttons.anchor:Hide();
		self:ForceHideButtons();
	end
end

function MFClip:ShowLiveBars( status )
	if( status ) then
		if( self.sdb.bEnabled == false ) then
			self.bars.anchor:Hide();
			self:ForceHideBars();
		elseif( self.sdb.bLiveBarsEnabled ) then
			if( self.sdb.bHideInVehicle and self.bVehicle ) then
				self:ForceHideBars();
			else
				if( self.sdb.bShowAnchor ) then
					self.bars.anchor:Show();
				else
					self.bars.anchor:Hide();
				end

				self:ShowBars();
			end
		else
			self.bars.anchor:Hide();
			self:ForceHideBars();
		end
	else
		self.bars.anchor:Hide();
		self:ForceHideBars();
	end
end
