-- local variables
local _;

function MFClip:SetupChannelSpellsTable()
	if (self.bIs40) then
		self:AddChanneledSpellById(15407, 3, 3); -- mind flay
		self:AddChanneledSpellById(129197, 3, 3); -- mind flay (insanity)
		self:AddChanneledSpellById(48045, 5, 5); -- mind sear
		self:AddChanneledSpellById(47540, 2, 2); -- penance
		--self:AddChanneledSpellById(64843, 4, 4); -- divine hymn, gains additional ticks
		--self:AddChanneledSpellById(64901, 4, 4); -- hymn of hope, gains additional ticks
			-- use Gnosis Castbars if you want to see ticks for channeled spells which
			-- gain additional ticks from haste
	else
		self:AddChanneledSpellById(48156, 3, 3); -- mind flay
		self:AddChanneledSpellById(53023, 5, 5); -- mind sear
		self:AddChanneledSpellById(52985, 2, 2); -- penance
		self:AddChanneledSpellById(64843, 4, 4); -- divine hymn
		self:AddChanneledSpellById(64901, 4, 4); -- hymn of hope
	end
end

function MFClip:SetStartupValues()
	self.strTitle = "MFClip";
	self.ver = 2.23;
	self.optver = 1.20;
	self.build = "v2.23";
	self.strVer = string.format( "v%.2f", self.ver );
	if( self.build == self.strVer ) then
		self.title = string.format( "%s %s", self.strTitle, self.strVer );
	else
		self.title = string.format( "%s %s (%s)", self.strTitle, self.strVer, self.build );
	end

	self.lbcast = "on hidecb cast";
	self.lbdef = "on showcb cast mb swd vt dp swp buttons";
	self.bartexnames = {};
	self.bartextures = {};
	self.fonts = {};
	self.fontnames = {};
	self.guid = nil;

	self.channeledspells = {};

	-- castbars (not yet implemented)
	self.castbars = {};

	-- castbar
	self.bIsActiveCB = false;
	self.bFadeoutCB = false;
	self.fCleanupReqTime = nil;

	self.strMF = nil;
	self.strMFI = nil;
	self.strMS = nil;
	self.strMB = nil;
	self.strVT = nil;
	self.strSWD = nil;
	self.strMFTexture = nil;

	self.bCleanup = false;
	self.logData = false;
	self.lastSpellSent = GetTime();
	self.fCurWFCL = 0.0;

	self.fEnteredCombat = 0;

	self.buttons = {};
	self.bars = {
		anchor = nil,
		mf = nil,
		mb = nil,
		vt = nil,
		swp = nil,
		dp = nil,
		swd = nil,
	};

	self.lag = 0;
	self.castend = 0;
	self.casting = false;
	self.channeling = false;
	self.castname = nil;
	self.casttime = 0;

	self.mfend = 0;
	self.mfdata = {
		bClipped = false,
		iTickCount = 0,
		iCritCount = 0,
		iHitCount = 0,
		iDmg = 0,
		bPriorCastMF = false,
		bClipTest = false,
		bResetWait = false,
		fReqTestTime = 0.0,
		fCastStart = 0.0,
		fTick = 0.0,
		fTickedCasttime = 0.0,
		td = { [1] = 0.0, [2] = 0.0, [3] = 0.0, [4] = 0.0, [5] = 0.0, ["pb"] = 0.0, ["ftick"] = 0.0, ["bValid"] = false },
		tt = { [1] = 0.0, [2] = 0.0, [3] = 0.0, [4] = 0.0, [5] = 0.0, ["pb"] = 0.0, ["ftick"] = 0.0, ["bValid"] = false },
		fLostCasttime = 0.0,
		iTotalMFCount = 0,
		iTotalMFCrit = 0,
		iTotalMFHit = 0,
		iTotalMFClipped = 0,
		iTotalMFDmg = 0,
	};

	self.bCheckMBCD = false;
	self.fMBCastStart = 0.0;
	self.mbdata = {
		bMB = false,
		fMBCDend = 0.0,
		fMBCD = 0.0,
		fMBTotalCasttime = 0,
		fMBCasttime = 0,
		fFirstMBCasted = nil,
		iMBDmg = 0,
		iMBCount = 0,
		fMBPriorVal = 0,
		fMBPriorTime = 0,
	};
	self.bCheckSWDCD = false;
	self.fSWDCastStart = 0.0;
	self.swddata = {
		bSWD = false,
		fSWDCDend = 0.0,
		fSWDCD = 0.0,
		fSWDTotalCasttime = 0,
		fSWDCasttime = 0,
		fFirstSWDCasted = nil,
		iSWDDmg = 0,
		iSWDCount = 0,
		fSWDPriorVal = 0,
		fSWDPriorTime = 0,
	};

	self.tDotsApplied = {};
	self.tDots = {};

	self.tDefaults = {
		bEnabled = true,
		iSpec1Cmd = 0,
		iSpec2Cmd = 0,
		bCT = true,
		bSound = true,
		fWFCL = 1000,
		fUCW = 300,
		fmFL = 30,
		bShowCombat = true,
		strSound = "MONEYFRAMEOPEN",
		strCT = "Blizzard",
		bfWFCLadj = true,
		bMFTS = true,
		bMFCE = true,
		bMFDS = true,
		fMinDotCount = 10,
		iFontsizeClip = 0,
		iFontsizeNonClip = 0,
		iFontoutlineClip = 0,
		iFontoutlineNonClip = 0,

		bSticky = true,
		bShowIcon = true,

		iTotalMFCount = 0,
		iTotalMFHit = 0,
		iTotalMFCrit = 0,
		iTotalMFClipped = 0,
		iTotalMFDmg = 0,

		strSelFirstDesc = "Spell damage",
		strSelFirstPre = "",
		strSelFirst = "Dmg",
		strSelFirstPost = "",
		strSelFirstFixed = "",
		strSelFirstColor = "|c00a000a0",

		strSelSecondDesc = "Spell name",
		strSelSecondPre = " (",
		strSelSecond = "Spell",
		strSelSecondPost = ")",
		strSelSecondFixed = "",
		strSelSecondColor = "|c00ffff00",

		strSelThirdDesc = "Number of hits & crits",
		strSelThirdPre = " [",
		strSelThird = "HitsCrits",
		strSelThirdPost = "]",
		strSelThirdFixed = "",
		strSelThirdColor = "|c00ffff00",

		strSelFourthDesc = "Clipped",
		strSelFourthPre = "",
		strSelFourth = "Clip",
		strSelFourthPost = "",
		strSelFourthFixed = " (clipped)",
		strSelFourthColor = "|c00ffffff",

		strSelFifthDesc = "Unused",
		strSelFifthPre = "",
		strSelFifth = "Static",
		strSelFifthPost = "",
		strSelFifthFixed = "",
		strSelFifthColor = "|c00ffffff",

		strSelSixthDesc = "Unused",
		strSelSixthPre = "",
		strSelSixth = "Static",
		strSelSixthPost = "",
		strSelSixthFixed = "",
		strSelSixthColor = "|c00ffffff",

		bShowAnchor = true,
		bLiveBarsEnabled = true,
		bHideCastbarWNC = false,
		bHideBlizzCB = true,
		fLBWidth = 250,
		fLBHeight = 18,
		fLBScale = 1.0,
		fLBmax = 0.10,
		iZoom = 5,
		fLBBorder = 1.0,
		fLBSpacing = -1.0,
		lbtexture = "Waterline",
		font = "",

		fLButtonsScale = 1.0,
		fSparkHeightMulti = 1.0,
		fSparkWidthMulti = 1.0,

		bShowButtonAnchor = true,
		bLiveButtonsEnabled = true,
		bShowSparkForAll = true,
		bLDBOutputOnly = false,
		bHideLBDetails = false,
		bHideInVehicle = false,
		bEnShOrbs = true,

		lbbarcolor = { 0.20, 0.30, 0.50, 0.70 },
		lblagcolor  = { 0.35, 0.65, 0.90, 0.65 },
		lbtextcolor = {  1.00, 1.00, 1.00, 1.00 },
		lbbarbgcolor = { 0.10, 0.10, 0.35, 0.40 },
		lbbordercolor = { 0.00, 0.00, 0.00, 0.75 },
		sparkcolor = {  1.00, 1.00, 1.00, 1.00 },
		shorbbgcolor = { 0.50, 0.50, 0.50, 0.70 },
		shorb3noescolor = { 0.45, 0.50, 0.35, 0.70 },
		castmbasapcolor = { 0.35, 0.60, 0.15, 0.70 },
		castmb4orbcolor = { 0.70, 0.70, 0.30, 0.70 },
		noempshcolor = { 0.70, 0.30, 0.20, 0.75 },

		strLButtons = "mf ms mb vt dp swp row",
		strLBconf = "on showcb cast mb vt dp swp buttons",
		strLBooCconf = "on showcb cast mb swd vt dp swp buttons",
		strLBinCconf = "on showcb cast mb swd vt dp swp buttons",
	}

	self.tCDs = {};
end
