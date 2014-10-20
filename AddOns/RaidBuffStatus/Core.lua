local addonName, vars = ...
local L = vars.L
local AceConfig = LibStub('AceConfigDialog-3.0')
local GI = LibStub("LibGroupInSpecT-1.0")

RaidBuffStatus = LibStub("AceAddon-3.0"):NewAddon("RaidBuffStatus", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0", "AceSerializer-3.0")
RBS_svnrev = {}
RBS_svnrev["Core.lua"] = select(3,string.find("$Revision: 679 $", ".* (.*) .*"))

local addon = RaidBuffStatus
local profile
addon.L = L
addon.GI = GI
addon.bars = {}

local band = _G.bit.band

local buttons = {}
local optionsbuttons = {}
local optionsiconbuttons = {}
local incombat = false
local dashwasdisplayed = true
local tankList = '|'
local nextscan = 0
addon.timer = false
local playerid = UnitGUID("player")
local playername = UnitName("player")
local playerclass = select(2,UnitClass("player"))
local xperltankrequest = false
local xperltankrequestt = 0
local nextdurability = 0
local nextitemcheck = 0
local currentsheep = {}
local currentsheepspell = {}
local lasthealerdrinking = 0
local maxdistance = 100000
addon.lasttobuf = ""
addon.version = ""
addon.revision = ""
addon.rbsversions = {}
local toldaboutnewversion = false
local toldaboutrbsuser = {}
addon.durability = {}
addon.broken = {}
addon.itemcheck = {}
addon.soulwelllastseen = 0
addon.rezerrezee = {}
addon.rezeetime = {}
addon.lastweapcheck = {}

-- babblespell replacement using GetSpellInfo(key)
local BSmeta = {}
local BS = setmetatable({}, BSmeta)
local BSI = setmetatable({}, BSmeta)
BSmeta.__index = function(self, key)
	local name, _, icon
	if type(key) == "number" then
		name, _, icon = GetSpellInfo(key)
	else
		geterrorhandler()(("Unknown spell key %q"):format(key))
	end
	if name then
		BS[key] = name
		BS[name] = name
		BSI[key] = icon
		BSI[name] = icon
	else
		BS[key] = false
		BSI[key] = false
		geterrorhandler()(("Unknown spell info key %q"):format(key))
	end
	return self[key]
end

local function SpellName(spellID)
	local name = GetSpellInfo(spellID)
	return name
end

-- List originally copied from BigBrother addon (Thanks BB)
local ccspells = {
--	BS[118], -- Polymorph (needs workaround)
	BS[9484], -- Shackle Undead
	BS[2637], -- Hibernate
	BS[3355], -- Freezing Trap (Effect)
	BS[6770], -- Sap
	BS[20066], -- Repentance
--	BS[5782], -- Fear (needs workaround)
	BS[2094], -- Blind
	BS[51514], -- Hex
--	BS[61305], -- Polymorph (Black Cat) (needs workaround)
--	BS[28272], -- Polymorph (Pig) (needs workaround)
--	BS[28271], -- Polymorph (Turtle) (needs workaround)
--	BS[61721], -- Polymorph (Rabbit) (needs workaround)
--	BS[61780], -- Polymorph (Turkey) (needs workaround)
	BS[76780], -- Bind Elemental
	BS[6358], -- Seduction
	BS[115268], -- Mesmerize
--	BS[339], -- Entangling Roots (needs workaround)
	BS[1513], -- Scare Beast
	BS[10326], -- Turn Evil
	BS[19386], -- Wyvern Sting
	BS[115078], -- Paralysis (Monk)
}
local ccspellshash = {} -- much faster matching than a loop
for _, spell in ipairs(ccspells) do
	ccspellshash[spell] = true
end

local workaroundbugccspells = {
	BS[118], -- Polymorph
	BS[61305], -- Polymorph (Black Cat)
	BS[28272], -- Polymorph (Pig)
	BS[28271], -- Polymorph (Turtle)
	BS[61721], -- Polymorph (Rabbit)
	BS[61780], -- Polymorph (Turkey)
	BS[5782], -- Fear
	BS[339], -- Entangling Roots
}
local workaroundbugccspellshash = {}
for _, spell in ipairs(workaroundbugccspells) do
	workaroundbugccspellshash[spell] = true
end

local rezspells = {
	BS[20484], -- Rebirth (Druid brez)
	BS[61999], -- Raise Ally (DK)
	BS[20707], -- Soulstone (Warlock)
	BS[7328], -- Redemption (Paladin)
	BS[2006], -- Resurrection (Priest)
	BS[2008], -- Ancestral Spirit (Shaman)
	BS[50769], -- Revive (Druid)
	BS[115178], -- Resuscitate (Monk)
	BS[8342], -- Defibrillate (Goblin Jumper Cables)
	BS[22999], -- Defibrillate (Goblin Jumper Cables XL)
	BS[54732], -- Defribillate (Gnomish Army Knife)
	BS[83968], -- Mass Resurrection
}
local rezspellshash = {}
for _, spell in ipairs(rezspells) do
	rezspellshash[spell] = true
end
local rezclasses = { DRUID=true, PALADIN=true, PRIEST=true, SHAMAN=true, MONK=true }

local taunts = {
	-- Death Knights
	56222, -- Dark Command
--	49576, -- Death Grip
	51399, -- Death Grip (taunted)
	-- Warrior
	1161, -- Challenging Shout
	355, -- Taunt
	21008, -- Mocking Blow
	-- Druid
	5209, -- Challenging Roar
	6795, -- Growl
	-- Paladin
	31790, -- Righteous Defense
	62124, -- Hand of Reckoning
	-- Monk
	116189, -- Provoke 
	-- Hunter
	20736, -- Distracting Shot
}
local taunthash = {}
for _, spell in ipairs(taunts) do
	taunthash[spell] = true
end

local utilinit = {
	-- cata food
	[57426] = { category="Feast", itemid=43015, limit=50, }, -- Fish Feast
	[87643] = { category="Feast", itemid=62289, limit=50, }, -- Broiled Dragon Feast
	[87915] = { category="Feast", itemid=60858, limit=50, }, -- Goblin Barbecue
	[87644] = { category="Feast", itemid=62290, limit=50, }, -- Seafood Magnifique Feast

	-- mop food
	[126503] = { category="Feast", itemid=87246, limit=10, },   -- Banquet of the Brew
	[126504] = { category="Feast", itemid=87248, limit=25, },   -- Great Banquet of the Brew
	[126492] = { category="Feast", itemid=87226, limit=10, bonus="STRENGTH" },  -- Banquet of the Grill
	[126494] = { category="Feast", itemid=87228, limit=25, bonus="STRENGTH" },  -- Great Banquet of the Grill
	[126501] = { category="Feast", itemid=87242, limit=10, bonus="STAMINA" },   -- Banquet of the Oven
	[126502] = { category="Feast", itemid=87244, limit=25, bonus="STAMINA" },   -- Great Banquet of the Oven
	[126497] = { category="Feast", itemid=87234, limit=10, bonus="INTELLECT" }, -- Banquet of the Pot
	[126498] = { category="Feast", itemid=87236, limit=25, bonus="INTELLECT" }, -- Great Banquet of the Pot
	[126499] = { category="Feast", itemid=87238, limit=10, bonus="SPIRIT" },    -- Banquet of the Steamer
	[126500] = { category="Feast", itemid=87240, limit=25, bonus="SPIRIT" },    -- Great Banquet of the Steamer
	[126495] = { category="Feast", itemid=87230, limit=10, bonus="AGILITY" },   -- Banquet of the Wok
	[126496] = { category="Feast", itemid=87232, limit=25, bonus="AGILITY" },   -- Great Banquet of the Wok
	[104958] = { category="Feast", itemid=74919, limit=10, },   -- Pandaren Banquet
	[105193] = { category="Feast", itemid=75016, limit=25, },   -- Great Pandaren Banquet

	[145166] = { category="Cart", itemid=101630, ungrouped=true },   -- Noodle Cart (duration 180 but can be cancelled)
	[145169] = { category="Cart", itemid=101661, ungrouped=true },   -- Deluxe Noodle Cart
	[145196] = { category="Cart", itemid=101662, ungrouped=true },   -- Pandaren Treasure Noodle Cart

	[92649]  = { category="Cauldron", itemid=62288, limit=10, slow=true, duration=600 }, -- Cauldron of Battle
	[92712]  = { category="Cauldron", itemid=65460, limit=30, slow=true, duration=600 }, -- Big Cauldron of Battle

	[43987]  = { category="Table", cast=true, slow=true, duration=180 }, -- Ritual of Refreshment 

	[29893]  = { category="Soulwell", itemid=5512, cast=true, slow=true, duration=120 },  -- Create Soulwell 

	[126459] = { category="Blingtron", itemid=87214, duration=600, ungrouped=true }, -- Blingtron 4000

	[54710]  = { category="Mailbox", item=40768, label=L["Mailbox"], duration=600, ungrouped=true }, 

	[22700]  = { category="Repair", itemid=18232, label=L["Repair Bot"], duration=600, ungrouped=true }, -- Field Repair Bot 74A
	[44389]  = { category="Repair", itemid=34113, label=L["Repair Bot"], duration=600, ungrouped=true }, -- Field Repair Bot 110G
	[54711]  = { category="Repair", itemid=40769, label=L["Repair Bot"], duration=600, ungrouped=true }, -- Scrapbot
	[67826]  = { category="Repair", itemid=49040, label=L["Repair Bot"], duration=600, ungrouped=true }, -- Jeeves

	[53142]  = { category="Portal", slow=true, cast=true }, -- Dalaran
	[11419]  = { category="Portal", slow=true, cast=true }, -- Darnassus
	[32266]  = { category="Portal", slow=true, cast=true }, -- Exodar
	[11416]  = { category="Portal", slow=true, cast=true }, -- Ironforge
	[11417]  = { category="Portal", slow=true, cast=true }, -- Orgrimmar
	[35717]  = { category="Portal", slow=true, cast=true }, -- Shattrath
	[33691]  = { category="Portal", slow=true, cast=true }, -- Shattrath
	[32267]  = { category="Portal", slow=true, cast=true }, -- Silvermoon
	[49361]  = { category="Portal", slow=true, cast=true }, -- Stonard
	[10059]  = { category="Portal", slow=true, cast=true }, -- Stormwind
	[49360]  = { category="Portal", slow=true, cast=true }, -- Theramore
	[11420]  = { category="Portal", slow=true, cast=true }, -- Thunder Bluff
	[88346]  = { category="Portal", slow=true, cast=true }, -- Tol Barad
	[88345]  = { category="Portal", slow=true, cast=true }, -- Tol Barad
	[11418]  = { category="Portal", slow=true, cast=true }, -- Undercity
	[132626] = { category="Portal", slow=true, cast=true }, -- Vale of Eternal Blossoms
	[132620] = { category="Portal", slow=true, cast=true }, -- Vale of Eternal Blossoms
	[120146] = { category="Portal", slow=true, cast=true }, -- Ancient Dalaran
}
local utildata = {}
function addon:UpdateUtilData()
  for id,info in pairs(utilinit) do
    local name = BS[id]
    utildata[id] = info
    if name then
	info.name = name
	info.id = id
	utildata[name] = info
    end
    if info.itemid then
	utildata["item:"..info.itemid] = info
	local iname = GetItemInfo(info.itemid)
	if iname then
	  utildata[iname] = info
	end
    end
  end
  addon.utildata = utildata
end
addon:UpdateUtilData()

local function AddTTFeastBonus(self, name)
  local info = name and utildata[name]
  if info and info.bonus and profile.FeastTT then
    local btext = _G["ITEM_MOD_"..info.bonus.."_SHORT"]
    if btext then
      self:AddDoubleLine(name,L["Bonus"].." "..btext)   
      self:Show()
     end
  end
end

local classes = CLASS_SORT_ORDER

local raid = { }
addon.raid = raid
raid.reset = function()
	raid.classes = raid.classes or {}
	for _,cl in ipairs(classes) do
	  raid.classes[cl] = raid.classes[cl] or {}
	  wipe(raid.classes[cl])
	end
	raid.ClassNumbers = raid.ClassNumbers or {}; wipe(raid.ClassNumbers)
	raid.BuffTimers = raid.BuffTimers or {}; wipe(raid.BuffTimers)
	raid.TankList = raid.TankList or {}; wipe(raid.TankList)
	raid.ManaList = raid.ManaList or {}; wipe(raid.ManaList)
	raid.DPSList = raid.DPSList or {}; wipe(raid.DPSList)
	raid.HealerList = raid.HealerList or {}; wipe(raid.HealerList)
	raid.guilds = raid.guilds or {}; wipe(raid.guilds)
	raid.LastDeath = raid.LastDeath or {}; wipe(raid.LastDeath)
	raid.israid = false
	raid.isparty = false
	raid.islfg = false
	raid.isbattle = false
	raid.readid = 0
	raid.size = 1
	raid.pug = false
	raid.leadername = ""
	for _,class in ipairs(classes) do
	  raid.ClassNumbers[class] = 0
	end
	if addon.CleanLockSoulStone then
	   addon:CleanLockSoulStone()
	end
end
addon.raid = raid
raid.reset()

local unknownicon = "Interface\\Icons\\INV_Misc_QuestionMark"
local specicons = {
	UNKNOWN = unknownicon,
}

local classicons = {}
for _,cl in ipairs(classes) do
  local m = cl:gsub("^(.)(.+)$",function(p,s) return p..s:lower() end) -- mixed case
  m = m:gsub("knight","Knight")
  classicons[cl] = "Interface\\Icons\\ClassIcon_"..m
end
classicons.UNKNOWN = unknownicon

local role_tex_file = "Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES"
local dps_icon = { file = role_tex_file, coords = {20/64,39/64,22/64,41/64} }
local roleicons = {
	--MeleeDPS =  "Interface\\Icons\\INV_Sword_04",
	--RangedDPS = "Interface\\Icons\\ability_marksmanship",
	MeleeDPS =  dps_icon,
	RangedDPS = dps_icon,
	Tank =      { file = role_tex_file, coords = {0,19/64,22/64,41/64} },
	Healer =    { file = role_tex_file, coords = {20/64,39/64,1/64,20/64} },
	UNKNOWN =   unknownicon,
}

local tfi = {
	namewidth = 210,
	classwidth = 55,
	specwidth = 55,
	rolewidth = 55,
	specialisationswidth = 210,
	gap = 2,
	edge = 5,
	inset = 3,
	topedge = 45,
	rowheight = 17,
	rowgap = 0,
	maxrows = 40,
	okbuttonheight = 55,
	rowdata = {},
	rowframes = {},
	buttonsize = 15,
	sort = "role",
	sortorder = 1,
}
addon.tfi = tfi
tfi.namex = tfi.edge
tfi.classx = tfi.namex + tfi.namewidth + tfi.gap
tfi.specx = tfi.classx + tfi.classwidth + tfi.gap
tfi.rolex = tfi.specx + tfi.specwidth + tfi.gap
tfi.specialisationsx = tfi.rolex + tfi.rolewidth + tfi.gap
tfi.framewidth = tfi.specialisationsx + tfi.specialisationswidth + tfi.edge
tfi.rowwidth = tfi.framewidth - tfi.edge - tfi.edge - tfi.inset - tfi.inset

-- diameter of the Minimap in game yards at
-- the various possible zoom levels
-- from Astrolabe
local MinimapSize = {
	indoor = {
		[0] = 300, -- scale -- this one is wrong but I don't know the correct value
		[1] = 240, -- 1.25
		[2] = 180, -- 5/3
		[3] = 120, -- 2.5
		[4] = 80,  -- 3.75
		[5] = 50,  -- 6
	},
	outdoor = {
		[0] = 466 + 2/3, -- scale
		[1] = 400,       -- 7/6
		[2] = 333 + 1/3, -- 1.4
		[3] = 266 + 2/6, -- 1.75
		[4] = 200,       -- 7/3
		[5] = 133 + 1/3, -- 3.5
	},
}

local report = {
	checking = {},
	RaidHealth = 100,
	RaidMana = 100,
	DPSMana = 100,
	HealerMana = 100,
	TankHealth = 100,
	Alive = 100,
	Dead = 0,
	TanksAlive = 100,
	HealersAlive = 100,
	HealersAliveCount = 0,
	HealersAliveCountNumber = 0,
	Range = 100,
	HealerManaIsDrinking = 0,
	HealerInRange = 0,
	raidhealthlist = {},
	raidmanalist = {},
	dpsmanalist = {},
	healermanalist = {},
	tankhealthlist = {},
	alivelist = {}, -- actually dead list
	tanksalivelist = {}, -- actually dead list
	healersalivelist = {}, -- actually dead list
	rangelist = {}, -- actually people out of range list
}
report.reset = function()
	for reportname,_ in pairs(report) do
		if type(report[reportname]) == "number" then
			report[reportname] = 0
		elseif type(report[reportname]) == "table" then
			wipe(report[reportname])
		end
	end
end
addon.report = report

-- End of inits

local profiledefaults
function addon:OnInitialize()
	profiledefaults = { profile = {
		options = {},
		TellWizard = true,
		ReportSelf = false,
		ReportChat = true,
		ReportOfficer = false,
		ShowMany = true,
		WhisperMany = true,
		HowMany = 4,
		HowOften = 3,
		foodlevel = 250,
		ignoreeating = false,
		OldFlasksElixirs = false,
		FeastTT = true,
--		ShowGroupNumber = false,
--		ShowMissingBlessing = true,
		whisperonlyone = true,
		abouttorunout = 3,
		preferstaticbuff = true,
		LockWindow = false,
		IgnoreLastThreeGroups = false,
		DisableInCombat = true,
		HideInCombat = true,
		LeftClick = "enabledisable",
		RightClick = "buff",
		ControlLeftClick = "whisper",
		ControlRightClick = "none",
		ShiftLeftClick = "report",
		ShiftRightClick = "none",
		AltLeftClick = "buff",
		AltRightClick = "none",
		onlyusetanklist = false,
		tankwarn = false,
		bossonly = false,
		failselfimmune = true,
		failsoundimmune = true,
		failrwimmune = false,
		failraidimmune = true,
		failpartyimmune = false,
		failselfresist = true,
		failsoundresist = true,
		failrwresist = false,
		failraidresist = true,
		failpartyresist = false,
		otherfailself = true,
		otherfailsound = true,
		otherfailrw = false,
		otherfailraid = false,
		otherfailparty = false,
		ninjaself = true,
		ninjasound = true,
		ninjarw = false,
		ninjaraid = false,
		ninjaparty = false,
		tauntself = true,
		tauntsound = true,
		tauntrw = false,
		tauntraid = false,
		tauntparty = false,
		tauntmeself = true,
		tauntmesound = true,
		tauntmerw = false,
		tauntmeraid = false,
		tauntmeparty = false,
		nontanktauntself = true,
		nontanktauntsound = true,
		nontanktauntrw = false,
		nontanktauntraid = false,
		nontanktauntparty = false,
		ccwarn = true,
		cconlyme = false,
		ccwarntankself = false,
		ccwarntanksound = false,
		ccwarntankrw = false,
		ccwarntankraid = false,
		ccwarntankparty = false,
		ccwarnnontankself = true,
		ccwarnnontanksound = true,
		ccwarnnontankrw = false,
		ccwarnnontankraid = false,
		ccwarnnontankparty = false,
		misdirectionwarn = false,
		misdirectionself = true,
		misdirectionsound = true,
		deathwarn = true,
		tankdeathself = true,
		tankdeathsound = true,
		tankdeathrw = false,
		tankdeathraid = false,
		tankdeathparty = false,
		rangeddpsdeathself = true,
		rangeddpsdeathsound = true,
		rangeddpsdeathrw = false,
		rangeddpsdeathraid = false,
		rangeddpsdeathparty = false,
		meleedpsdeathself = true,
		meleedpsdeathsound = true,
		meleedpsdeathrw = false,
		meleedpsdeathraid = false,
		meleedpsdeathparty = false,
		healerdeathself = true,
		healerdeathsound = true,
		healerdeathrw = false,
		healerdeathraid = false,
		healerdeathparty = false,
		RaidHealth = false,
		TankHealth = true,
		RaidMana = false,
		HealerMana = true,
		healerdrinkingsound = false,
		DPSMana = true,
		Alive = false,
		Dead = false,
		TanksAlive = false,
		HealersAlive = false,
		Range = true,
		bgr = 0,
		bgg = 0,
		bgb = 0,
		bga = 0.85,
		bbr = 0,
		bbg = 0,
		bbb = 0,
		bba = 1,
		x = 0,
		y = 0,
		MiniMap = true,
		AutoShowDashParty = true,
		AutoShowDashRaid = true,
		AutoShowDashBattle = false,
		MiniMapAngle = random(0, 359),
		dashcols = 6,
		dashscale = 1.0,
		optionsscale = 1.0,
		ShortenNames = false,
		HighlightMyBuffs = true,
		movewithaltclick = false,
		hidebossrtrash = false,
		TooltipNameColor = true,
		TooltipRoleIcons = true,
		Debug = false,

		announceFeast = true,
		announceCart = true,
		announceCauldron = true,
		announceTable = true,
		announceSoulwell = true,
		announceRepair = true,
		announceMailbox = true,
		announcePortal = true,
		announceBlingtron = true,

		antispam = true,
		nonleadspeak = false,
		announceExpiration = true,
		feastautowhisper = true,
		cauldronsautowhisper = false,
		wellautowhisper = false,

		versionannounce = true,
		userannounce = false,
		guildmembers = false,
		friends = false,
		bnfriends = false,
		aiwguildmembers = false,
		aiwfriends = false,
		aiwbnfriends = false,
		cooldowns = {
			soulstone = {},
		},
		statusbarpositioning = "onedown",
		groupsortstyle = "three",
		buffsort = {},
	}}
	local BF = addon.BF
	for buffcheck, info in pairs(BF) do
		if info.list then
			report[info.list] = {} -- add empty list to report
		end
		if info.default then  -- if default setting for buff check is enabled
			profiledefaults.profile[info.check] = true
		else
			profiledefaults.profile[info.check] = false
		end
		for _, defname in ipairs({"buff", "warning", "dash", "dashcombat", "boss", "trash"}) do
			if info["default" .. defname] then
				profiledefaults.profile[buffcheck .. defname] = true
			else
				profiledefaults.profile[buffcheck .. defname] = false
			end
		end
		profiledefaults.profile.buffsort[1] = "defaultorder"
		profiledefaults.profile.buffsort[2] = "defaultorder"
		profiledefaults.profile.buffsort[3] = "defaultorder"
		profiledefaults.profile.buffsort[4] = "defaultorder"
		profiledefaults.profile.buffsort[5] = "defaultorder"
		if info.itemcheck then
			info.itemcheck.list = info.itemcheck.list or info.list
			info.itemcheck.results = {}
			addon.itemcheck[buffcheck] = info.itemcheck
		end
	end
	RaidBuffStatusDefaultProfile = RaidBuffStatusDefaultProfile or {false, "Modders: In your SavedVars, replace the first argument of this table with the profile you want loaded by default, like 'Default'."}
	self.db = LibStub("AceDB-3.0"):New("RaidBuffStatusDB", profiledefaults, RaidBuffStatusDefaultProfile[1])
	addon.optFrame = AceConfig:AddToBlizOptions("RaidBuffStatus", "RaidBuffStatus")
	self.configOptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	profile = addon.db.profile
	addon:UpdateProfileConfig()
	addon:UpdateProfileBuffs()
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	GI.RegisterCallback(self, "GroupInSpecT_Update")
--	addon:Debug('Init, init?')
end

local function GameTooltip_Hide()
	GameTooltip:Hide()
end

-- credit for original code goes to Peragor and GridLayoutPlus
function addon:oRA_MainTankUpdate()
--	addon:Debug('oRA_MainTankUpdate()')
	-- oRa2 and CT raid integration: get list of unitids for configured tanks
	local tankTable = nil
	tankList = '|'
	if oRA and oRA.maintanktable then
		tankTable = oRA.maintanktable
		addon:Debug('Using ora')
	elseif XPerl_MainTanks then
		tankTable = {}
		for _,v in pairs(XPerl_MainTanks) do
			tankTable[v[2]] = v[2]
		end
		addon:Debug('Using xperl')
	elseif CT_RA_MainTanks then
		tankTable = CT_RA_MainTanks
		addon:Debug('Using ctra')
	end
	if tankTable then
		for key, val in pairs(tankTable) do
			local unit = addon:GetUnitFromName(val)
			if unit then
				local unitid = unit.unitid
				if unitid and UnitExists(unitid) and UnitPlayerOrPetInRaid(unitid) then
					tankList = tankList .. val .. '|'
				end
			end
		end
	end
end

function addon:ShowReportFrame()
	if (InCombatLockdown()) then
		return
	end
	ShowUIPanel(RBSFrame)
end

function addon:HideReportFrame()
	if (InCombatLockdown()) then
		return
	end
	HideUIPanel(RBSFrame)
end

function addon:ToggleOptionsFrame()
	if (InCombatLockdown()) then
		return
	end
	if addon.optionsframe:IsVisible() then
		HideUIPanel(RBSOptionsFrame)
	else
		addon:ShowOptionsFrame()
	end
end

function addon:ShowOptionsFrame()
	addon:UpdateOptionsButtons()
	ShowUIPanel(RBSOptionsFrame)
end

function addon:ToggleTalentsFrame()
	if addon.talentframe:IsVisible() then
		HideUIPanel(RBSTalentsFrame)
	else
		addon:ShowTalentsFrame()
	end
end

function addon:ShowTalentsFrame()
	addon:UpdateTalentsFrame()
	ShowUIPanel(RBSTalentsFrame)
end

function addon:UpdateMiniMapButton()
	if profile.MiniMap then
		RBSMinimapButton:UpdatePosition()
		RBSMinimapButton:Show()
	else
		RBSMinimapButton:Hide()
	end
end

function addon:UpdateTalentsFrame()
	local height = tfi.topedge + (raid.size * (tfi.rowheight + tfi.rowgap)) + tfi.okbuttonheight
	addon.talentframe:SetHeight(height)
	for i = 1, tfi.maxrows do
		tfi.rowframes[i].rowframe:Hide()
	end
	if not raid.israid and not raid.isparty then
		return
	end
	addon:GetTalentRowData()
	addon:SortTalentRowData(tfi.sort, tfi.sortorder)
	addon:CopyTalentRowDataToRowFrames()
	for i = 1, raid.size do
		tfi.rowframes[i].rowframe:Show()
	end
end

local function sortby_name_localized(a,b)
  return a.name_localized < b.name_localized
end

function addon:UnitRole(unit)
  local role = ""
  local roleicon = roleicons.UNKNOWN
  if unit.istank then
	role = L["Tank"]
	roleicon = roleicons.Tank
  elseif unit.ishealer then
	role = L["Healer"]
	roleicon = roleicons.Healer
  elseif unit.ismeleedps then
	role = L["Melee DPS"]
	roleicon = roleicons.MeleeDPS
  elseif unit.israngeddps then
	role = L["Ranged DPS"]
	roleicon = roleicons.RangedDPS
  end
  return role, roleicon
end

function addon:GetTalentRowData()
	tfi.rowdata = {}
	local majortmp = {}
	local minortmp = {}
	local row = 1
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			local unit = raid.classes[class][name]
			tfi.rowdata[row] = {}
			tfi.rowdata[row].name = name
			tfi.rowdata[row].class = class
			tfi.rowdata[row].role, tfi.rowdata[row].roleicon = addon:UnitRole(unit)
			tfi.rowdata[row].specialisations = {}
			tfi.rowdata[row].spec = unit.specname
			tfi.rowdata[row].specicon = unit.specicon
			if unit.talents and unit.tinfo and unit.tinfo.talents then
			  -- positions 1-6 are talents in descending tier order
			  for spellid, info in pairs(unit.tinfo.talents) do
			    local pos = 7-info.tier
			    tfi.rowdata[row].specialisations[pos] = info
			  end
			end
			-- position 7 is a spacer between talents and glyphs
			-- position 8-10 are major glyphs, 11-13 are minor glyphs
			wipe(majortmp)
			wipe(minortmp)
			if unit.talents and unit.tinfo and unit.tinfo.glyphs then
			  for spellid, info in pairs(unit.tinfo.glyphs) do
			    if info.glyph_type == GLYPH_TYPE_MAJOR then
			      table.insert(majortmp, info)
			    else
			      table.insert(minortmp, info)
			    end
			  end
			end
			table.sort(majortmp, sortby_name_localized)
			table.sort(minortmp, sortby_name_localized)
			for j = 1,3 do
			  tfi.rowdata[row].specialisations[7+j] = majortmp[j]
			  tfi.rowdata[row].specialisations[10+j] = minortmp[j]
			end
			row = row + 1
		end
	end
end

function addon:SortTalentRowData(sort, sortorder)
	tfi.sort = sort
	tfi.sortorder = sortorder
	if sort == "name" then
		table.sort(tfi.rowdata, function (a,b)
			return (addon:Compare(a.name, b.name, sortorder))
		end)
	elseif sort == "class" then
		table.sort(tfi.rowdata, function (a,b)
			if a.class == b.class then
				if a.specname == b.specname then
					return (addon:Compare(a.name, b.name, sortorder))
				end
				return (addon:Compare(a.specname, b.specname, sortorder))
			else
				return (addon:Compare(a.class, b.class, sortorder))
			end
		end)
	elseif sort == "spec" then
		table.sort(tfi.rowdata, function (a,b)
			if a.specname == b.specname then
				return (addon:Compare(a.class, b.class, sortorder))
			else
				return (addon:Compare(a.specname, b.specname, sortorder))
			end
		end)
	elseif sort == "role" then
		table.sort(tfi.rowdata, function (a,b)
			if a.role == b.role then
				return (addon:Compare(a.class, b.class, sortorder))
			else
				return (addon:Compare(a.role, b.role, sortorder))
			end
		end)
	elseif sort == "specialisations" then
		table.sort(tfi.rowdata, function (a,b)
			if #a.specialisations == #b.specialisations then
				return (addon:Compare(a.name, b.name, sortorder))
			end
			return (addon:Compare(#a.specialisations, #b.specialisations, sortorder))
		end)
	end
end

function addon:Compare(a, b, sortorder)
	if sortorder == 1 then
			return (a < b)
		else
			return (a > b)
	end
end

local function TalentButton_OnEnter(self)
     if self.spellid then
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetSpellByID(self.spellid)
	GameTooltip:Show()
     end
end

local function TalentButton_OnClick(self)
     if self.spellid then
        local link = GetSpellLink(self.spellid)
        if not link or #link == 0 then -- some glyphs cannot be linked as a spell
          return
          --local name = GetSpellInfo(self.spellid)
	  --link = "\124Hspell:"..self.spellid.."\124h["..(name or "unknown").."]\124h"
        end
        local activeEditBox = ChatEdit_GetActiveWindow();
        if activeEditBox then
           ChatEdit_InsertLink(link)
        else
          ChatFrame_OpenChat(link, DEFAULT_CHAT_FRAME)
        end
     end
end

function addon:CopyTalentRowDataToRowFrames()
	for i, _ in ipairs(tfi.rowdata) do
		local class = tfi.rowdata[i].class
		local name = tfi.rowdata[i].name
		local role = tfi.rowdata[i].role
		local roleicon = tfi.rowdata[i].roleicon
		local r = RAID_CLASS_COLORS[class].r
		local g = RAID_CLASS_COLORS[class].g
		local b = RAID_CLASS_COLORS[class].b
		tfi.rowframes[i].name:SetText(name)
		tfi.rowframes[i].name:SetTextColor(r,g,b)
		tfi.rowframes[i].class:SetNormalTexture(classicons[class] or classicons.UNKNOWN)
		tfi.rowframes[i].class:SetScript("OnEnter", function() 
			addon:Tooltip(tfi.rowframes[i].class, LOCALIZED_CLASS_NAMES_MALE[class], nil)
		end )
		tfi.rowframes[i].class:SetScript("OnLeave", GameTooltip_Hide)
		local f = tfi.rowframes[i].role
		f.tex = f.tex or f:CreateTexture()
		f.tex:SetAllPoints()
		if type(roleicon) == "table" then
		  f.tex:SetTexture(roleicon.file)
		  f.tex:SetTexCoord(unpack(roleicon.coords))
		else
		  f.tex:SetTexture(roleicon)
		  f.tex:SetTexCoord(0,1,0,1)
		end
		f:SetNormalTexture(f.tex)
		f:SetScript("OnEnter", function() addon:Tooltip(f, role, nil) end)
		f:SetScript("OnLeave", GameTooltip_Hide)
		if raid.classes[class][name].talents then
			local specname = raid.classes[class][name].specname
			local specicon = raid.classes[class][name].specicon
			tfi.rowframes[i].spec:SetScript("OnEnter", function()
				addon:Tooltip(tfi.rowframes[i].spec, specname)
			end )
			tfi.rowframes[i].spec:SetScript("OnLeave", GameTooltip_Hide)
			tfi.rowframes[i].spec:SetNormalTexture(specicon or specicons.UNKNOWN)
		else
			tfi.rowframes[i].spec:SetNormalTexture(specicons.UNKNOWN)
			tfi.rowframes[i].spec:SetScript("OnEnter", function()
				addon:Tooltip(tfi.rowframes[i].spec, "Unknown")
			end )
			tfi.rowframes[i].spec:SetScript("OnLeave", GameTooltip_Hide)
		end
		for j, v in ipairs (tfi.rowframes[i].specialisations) do
			v:Hide()
			v.spellid = nil
			local info = tfi.rowdata[i].specialisations[j]
			if info then
			        v.spellid = info.spell_id
				v:SetNormalTexture(info.icon)

				v:SetScript("OnEnter", TalentButton_OnEnter)
				v:SetScript("OnClick", TalentButton_OnClick)
				v:SetScript("OnLeave", GameTooltip_Hide)
				v:Show()
			end
		end
	end
end

function addon:DoReport(force)
	if force then
		nextdurability = 0
		nextitemcheck = 0
		wipe(addon.lastweapcheck)
		for check, info in pairs(addon.itemcheck) do
			info.next = 0
		end
	else -- not forced
		if nextscan > GetTime() then
			return  -- ensure we don't get called many times a second
		end
		if incombat and profile.DisableInCombat then
			return  -- no buff checking in combat
		end
		if raid.isbattle and not addon.frame:IsVisible() then
			return -- no buff checking in battlegrounds unless dashboard is shown
		end
	end
	nextscan = GetTime() + 1
	if xperltankrequest then
		if GetTime() > xperltankrequestt then
			addon:oRA_MainTankUpdate()
			xperltankrequest = false
		end
	end
	addon:CleanSheep()
	report:reset()
	addon:ReadRaid()
	if (not raid.israid) and (not raid.isparty) and (not raid.isbattle) then
		addon:UpdateButtons()
		return
	end
	addon:CalculateReport()
	addon:UpdateButtons()
	if addon.talentframe:IsVisible() then
		addon:UpdateTalentsFrame()
	end
	if addon.tooltipupdate then
		addon:tooltipupdate()
	end
	playerid = UnitGUID("player") -- this never changes but on logging in it may take time before it returns a value
	playername = UnitName("player") -- ditto
	playerclass = select(2,UnitClass("player")) -- ditto
	if not raid.isbattle and not incombat then
		if report.checking.durabilty and not _G.oRA3 and GetTime() > nextdurability then
			if #report.durabilitylist > 0 then
				nextdurability = GetTime() + 30 -- check more often if someone is broken
			else
				nextdurability = GetTime() + 60 * 5
			end
			addon:SendAddonMessage("CTRA", "DURC")
		end
		if GetTime() > nextitemcheck  then
			for check, info in pairs(addon.itemcheck) do
				if report.checking[check] and GetTime() > (info.next or 0) then
					nextitemcheck = GetTime() + 3
--					addon:Debug("Item:" .. info.item)
					addon:SendAddonMessage("CTRA", "ITMC " .. info.item)
					addon:SendAddonMessage("oRA3", addon:Serialize("InventoryCount", info.item))
					if #report[info.list] >= info.min then
						info.next = GetTime() + info.frequencymissing
					else
						info.next = GetTime() + info.frequency
					end
					break
				end
			end
		end
	end
end

function addon:CalculateReport()
	local BF = addon.BF
	-- PRE HERE
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].pre then
			if profile[BF[buffcheck].check] then
				if (not incombat) or (incombat and profile[buffcheck .. "dashcombat"]) then
					BF[buffcheck].pre(self, raid, report)
				end
			end
		end
	end

	-- MAIN HERE
	local thiszone = addon:GetMyZone()
	local maxspecage = GetTime() - 60 * 2
	local healthcount = 0
	local health = 0
	local manacount = 0
	local mana = 0
	local tankhealthcount = 0
	local tankhealth = 0
	local healermanacount = 0
	local healermana = 0
	local healerdrinking = 0
	local healerinrange = 0
	local dpsmanacount = 0
	local dpsmana = 0
	local alivecount = 0
	local alive = 0
	local tanksalivecount = 0
	local tanksalive = 0
	local healersalivecount = 0
	local healersalive = 0
	local rangecount = 0
	local range = 0
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			local unit = raid.classes[class][name]
			if unit.online then
				local zonedin = true
				local distance_thresh = 250 -- big enough to encompass nalak/galleon vicinity
				if not UnitIsVisible(unit.unitid) -- not in visible range
				   and (thiszone ~= unit.zone -- different subzone
				        or (unit.distance and unit.distance > distance_thresh))  -- or far in this world zone
				   and not (unit.distance and unit.distance < distance_thresh) -- not nearby in the world across subzone boundary
				   then
					zonedin = false
					if profile.checkzone then
						table.insert(report.zonelist, name)
					end
				end

				for buffcheck, _ in pairs(BF) do
					if profile[BF[buffcheck].check] then
						if zonedin or BF[buffcheck].checkzonedout then
							if (not incombat) or (incombat and profile[buffcheck .. "dashcombat"]) then
								if BF[buffcheck].main then
									BF[buffcheck].main(self, name, class, unit, raid, report)
								end
							end
						end
					end
				end
				if zonedin then
					alivecount = alivecount + 1
					if unit.isdead then
						report.alivelist[name] = L["Dead"]
						if unit.istank then
							report.tanksalivelist[name] = L["Dead"]
							tanksalivecount = tanksalivecount + 1
						elseif unit.ishealer then
							report.healersalivelist[name] = L["Dead"]
							healersalivecount = healersalivecount + 1
						end
					else
						alive = alive + 1
						local h = math.floor(UnitHealth(unit.unitid)/UnitHealthMax(unit.unitid)*100)
						local m = math.floor(UnitMana(unit.unitid)/UnitManaMax(unit.unitid)*100)
						health = health + h
						healthcount = healthcount + 1
						if h < 100 then
							report.raidhealthlist[name] = h
						end
						if unit.hasmana then
							mana = mana + m
							manacount = manacount + 1
							if m < 100 then
								report.raidmanalist[name] = m
							end
						end
						if unit.istank then
							tankhealth = tankhealth + h
							tankhealthcount = tankhealthcount + 1
							if h < 100 then
								report.tankhealthlist[name] = h
							end
							tanksalivecount = tanksalivecount + 1
							tanksalive = tanksalive + 1
						end
						if unit.ishealer then  -- all healers have mana
							healermana = healermana + m
							healermanacount = healermanacount + 1
							if m < 100 then
								if unit.hasbuff[BS[430]] and m < 95 then  -- Drink
									healerdrinking = healerdrinking + 1
									report.healermanalist[name .. "(" .. BS[14823] .. ")"] = m -- Drinking
								else
									report.healermanalist[name] = m
								end
							end
							healersalivecount = healersalivecount + 1
							healersalive = healersalive + 1
							if UnitInRange(unit.unitid) then
								healerinrange = healerinrange + 1
							end
						end
						if unit.hasmana and unit.isdps then
							dpsmana = dpsmana + m
							dpsmanacount = dpsmanacount + 1
							if m < 100 then
								report.dpsmanalist[name] = m
							end
						end
						rangecount = rangecount + 1
						if UnitInRange(unit.unitid) then
							range = range + 1
						else
							report.rangelist[name] = L["Out of range"]
						end
					end
				end
			else
				if profile.checkoffline then
					table.insert(report.offlinelist, name)  -- used by offline warning check
				end
			end
		end
	end

	if health < 1 then
		report.RaidHealth = 0
	else
		report.RaidHealth = math.floor(health / healthcount)
	end

	if manacount < 1 then
		report.RaidMana = L["n/a"]
	elseif mana < 1 then
		report.RaidMana = 0
	else
		report.RaidMana = math.floor(mana / manacount)
	end

	if tankhealthcount < 1 then
		report.TankHealth = L["n/a"]
	elseif tankhealth < 1 then
		report.TankHealth = 0
	else
		report.TankHealth = math.floor(tankhealth / tankhealthcount)
	end

	if healermanacount < 1 then
		report.HealerMana = L["n/a"]
	elseif healermana < 1 then
		report.HealerMana = 0
	else
		report.HealerMana = math.floor(healermana / healermanacount)
		if (report.HealerMana < 95 and healerdrinking > 0) or (report.HealerMana < 96 and healerdrinking > 1) or (report.HealerMana < 98 and healerdrinking > 2) then
			report.HealerManaIsDrinking = 1
		end
		report.HealerInRange = healerinrange
	end

	if dpsmanacount < 1 then
		report.DPSMana = L["n/a"]
	elseif dpsmana < 1 then
		report.DPSMana = 0
	else
		report.DPSMana = math.floor(dpsmana / dpsmanacount)
	end

	if alivecount < 1 then -- yes there may be no one in the raid for short time until they appear
		report.Alive = L["n/a"]
		report.AliveCount = ""
		report.Dead = 0
		report.DeadCount = 0
	else
		report.Alive = math.floor(alive / alivecount * 100)
		report.AliveCount = alivecount
		report.DeadCount = alivecount - alive
		report.Dead = math.floor(report.DeadCount / alivecount * 100)
	end
	
	if tanksalivecount < 1 then
		report.TanksAlive = L["n/a"]
		report.TanksAliveCount = ""
	else
		report.TanksAlive = math.floor(tanksalive / tanksalivecount * 100)
		report.TanksAliveCount = tanksalive
	end
	report.HealersAliveCountNumber = healersalivecount
	if healersalivecount < 1 then
		report.HealersAlive = L["n/a"]
		report.HealersAliveCount = ""
	else
		report.HealersAlive = math.floor(healersalive / healersalivecount * 100)
		report.HealersAliveCount = healersalivecount
	end
	if rangecount < 1 then
		report.Range = L["n/a"]
		report.RangeCount = ""
	else
		report.Range = math.floor(range / rangecount * 100)
		report.RangeCount = range
	end

	-- do timers
	local thetimenow = math.floor(GetTime())
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].timer then
			if not raid.BuffTimers[buffcheck .. "timerlist"] then
				raid.BuffTimers[buffcheck .. "timerlist"] = {}
			end
			for _, v in ipairs(report[BF[buffcheck].list]) do  -- first add those on the list to the timer list if not there
				local missing = true
				for n, t in pairs(raid.BuffTimers[buffcheck .. "timerlist"]) do
					if v == n then
						missing = false
						break
					end
				end
				if missing then
					raid.BuffTimers[buffcheck .. "timerlist"][v] = thetimenow
				end
			end
			for n, t in pairs(raid.BuffTimers[buffcheck .. "timerlist"]) do -- now remove those who are no longer on the list
				local missing = true
				for _, v in ipairs(report[BF[buffcheck].list]) do
					if v == n then
						missing = false
						break
					end
				end
				if missing then
					raid.BuffTimers[buffcheck .. "timerlist"][n] = nil
				end
			end
		end
	end

	-- sort names
	for buffcheck, _ in pairs(BF) do
		if # report[BF[buffcheck].list] > 1 then
			table.sort(report[BF[buffcheck].list])
		end
	end

	-- POST HERE
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].post then
			if profile[BF[buffcheck].check] and report.checking[buffcheck] then
				if (not incombat) or (incombat and profile[buffcheck .. "dashcombat"]) then
					BF[buffcheck].post(self, raid, report)
				end
			end
		end
	end
end

function addon:ReportToChat(boss, channel)
	local BF = addon.BF
	local warnings = 0
	local buffs = 0
	local canspeak = UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or raid.pug
	if not canspeak and profile.ReportChat and raid.israid then
		addon:OfficerWarning()
	end
	for buffcheck, _ in pairs(BF) do
		if # report[BF[buffcheck].list] > 0 then
			if (boss and profile[buffcheck .. "boss"]) or ((not boss) and profile[buffcheck .. "trash"]) then
				if profile[buffcheck .. "warning"] then
					warnings = warnings + # report[BF[buffcheck].list]
				end
				if profile[buffcheck .. "buff"] then
					buffs = buffs + # report[BF[buffcheck].list]
				end
			end
		end
	end
	if warnings > 0 then
		addon:Say(L["Warnings: "] .. warnings, nil, true, channel)
		for buffcheck, _ in pairs(BF) do
			if # report[BF[buffcheck].list] > 0 then
				if (boss and profile[buffcheck .. "boss"] ) or ((not boss) and profile[buffcheck .. "trash"]) then
					if profile[buffcheck .. "warning"] then
						if type(BF[buffcheck].chat) == "string" then
							if BF[buffcheck].timer then
								local timerlist = {}
								for _, n in ipairs(report[BF[buffcheck].list]) do
									if raid.BuffTimers[buffcheck .. "timerlist"][n] then
										table.insert(timerlist, n .. "(" .. addon:TimeSince(raid.BuffTimers[buffcheck .. "timerlist"][n]) .. ")")
									else
										table.insert(timerlist, n)
									end
								end
								addon:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(timerlist, ", "), nil, nil, channel)
							else
								if profile.ShowMany and BF[buffcheck].raidbuff and #report[BF[buffcheck].list] >= profile.HowMany then
									addon:Say("<" .. BF[buffcheck].chat .. ">: " .. L["MANY!"], nil, nil, channel)
								else
									addon:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(report[BF[buffcheck].list], ", "), nil, nil, channel)
								end
							end
						elseif type(BF[buffcheck].chat) == "function" then
							BF[buffcheck].chat(report, raid, nil, channel)
						end
					end
				end
			end
		end
	end
	if buffs > 0 then
		if boss then
			addon:Say(L["Missing buffs (Boss): "] .. buffs, nil, true, channel)
		else
			addon:Say(L["Missing buffs (Trash): "] .. buffs, nil, true, channel)
		end
		for buffcheck, _ in pairs(BF) do
			if # report[BF[buffcheck].list] > 0 then
				if (boss and profile[buffcheck .. "boss"] ) or ((not boss) and profile[buffcheck .. "trash"]) then
					if profile[buffcheck .. "buff"] then
						if type(BF[buffcheck].chat) == "string" then
							if profile.ShowMany and BF[buffcheck].raidbuff and #report[BF[buffcheck].list] >= profile.HowMany then
								addon:Say("<" .. BF[buffcheck].chat .. ">: " .. L["MANY!"], nil, nil, channel)
							else
								addon:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(report[BF[buffcheck].list], ", "), nil, nil, channel)
							end
						elseif type(BF[buffcheck].chat) == "function" then
							BF[buffcheck].chat(report, raid)
						end
					end
				end
			end
		end
	else
		if boss then
			addon:Say(L["No buffs needed! (Boss)"], nil, true, channel)
		else
			addon:Say(L["No buffs needed! (Trash)"], nil, true, channel)
		end
	end
end

function addon:ReportToWhisper(boss)
	local BF = addon.BF
	local prefix
	for buffcheck, _ in pairs(BF) do
		if # report[BF[buffcheck].list] > 0 then
			if (boss and profile[buffcheck .. "boss"]) or ((not boss) and profile[buffcheck .. "trash"]) then
				if profile[buffcheck .. "buff"] then
					prefix = L["Missing buff: "]
				else
					prefix = L["Warning: "]
				end
				addon:WhisperBuff(BF[buffcheck], report, raid, prefix)
			end
		end
	end
end



function addon:ReadRaid()
	raid.readid = raid.readid + 1
	wipe(raid.TankList)
	wipe(raid.ManaList)
	wipe(raid.DPSList)
	wipe(raid.HealerList)
	for _,class in ipairs(classes) do
		raid.ClassNumbers[class] = 0
	end
--	addon:Debug("tankList:" .. tankList)
	local it = select(2, IsInInstance())
	raid.isbattle = (it == "pvp") or (it == "arena") or 
	                (GetRealZoneText() == L["Wintergrasp"]) or
	                (GetRealZoneText() == L["Tol Barad"])
	local groupnum = GetNumGroupMembers()
	raid.size = groupnum
	if groupnum == 0 then -- not grouped
		raid.reset()
		return
	elseif not IsInRaid() then -- party group
		raid.isparty = true
		raid.israid = false
		addon:DistanceBegin()
		for i = 1, groupnum do
			local unitid = "party" .. i
			if i == groupnum then unitid = "player" end
			local name = addon:UnitNameRealm(unitid)
			local raidid
			for j = 1, groupnum do
			  if GetRaidRosterInfo(j) == name then
			    raidid = j
			    break
			  end
			end
			if raidid then
			   addon:ReadUnit(unitid, raidid)
			else
			   addon:Debug("MISSING RAIDID FOR: "..unitid.." "..(name or "unknown"))
			end
		end
		addon:DistanceEnd()
	else -- raid group
		if raid.isparty then -- Party has converted to Raid!
			if profile.AutoShowDashRaid then
				addon:ShowReportFrame()
			end
			addon:TriggerXPerlTankUpdate()
			raid.reset()
		end
		raid.isparty = false
		raid.israid = true

		addon:DistanceBegin()
		for i = 1, groupnum do
			addon:ReadUnit("raid" .. i, i)
		end
		addon:DistanceEnd()
	end
	raid.islfg = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	addon:DeleteOldUnits()
	if raid.israid then
		local minguildies = 0.75 * groupnum
		raid.pug = true
		for _,v in pairs(raid.guilds) do
			if v > minguildies then
				raid.pug = false
				break
			end
		end
	end
end

local spec_role = {
  MAGE          = "RDPS",
  WARLOCK       = "RDPS",
  HUNTER        = "RDPS",
  ROGUE         = "MDPS",
  PRIEST        = { [1] = "HEALER", [2] = "HEALER", [3] = "RDPS" },
  DEATHKNIGHT   = { [1] = "TANK",   [2] = "MDPS", [3] = "MDPS" },
  PALADIN       = { [1] = "HEALER", [2] = "TANK",   [3] = "MDPS" },
  WARRIOR       = { [1] = "MDPS", [2] = "MDPS", [3] = "TANK" },
  SHAMAN        = { [1] = "RDPS", [2] = "MDPS", [3] = "HEALER" },
  DRUID         = { [1] = "RDPS", [2] = "MDPS", [3] = "TANK", [4] = "HEALER" },
  MONK          = { [1] = "TANK", [2] = "HEALER", [3] = "MDPS" },
}

-- raid = { classes = { CLASS = { NAME = { readid, unitid, guid, group, zone, online, isdead, istank, hasmana, isdps, ishealer, class, 
--                                         hasbuff = {}, talents (boolean), spec (index), specname (localized name), specicon, tinfo = (library info) 
function addon:ReadUnit(unitid, unitindex)
	if not UnitExists(unitid) then
		return
	end
	local wellfed = GetSpellInfo(35272)-- Well Fed
	local eating = GetSpellInfo(104934) -- Food (eating)
	local name, realm = UnitName(unitid)
	local class = select(2, UnitClass(unitid))
	if name and name ~= UNKNOWNOBJECT and name ~= UKNOWNBEING and
	   class and raid.classes[class] then
		if realm and string.len(realm) > 0 then
			name = name .. "-" .. realm
		end
		local rank = 0
		local subgroup = 1
		local role = UnitGroupRolesAssigned(unitid)
		local zone = "UNKNOWN"
		local isML = false
		local istank = false
		local hasmana = false
		local isdps = false
		local ismeleedps = false
		local israngeddps = false
		local ishealer = false
		local spec = nil
		local guild = GetGuildInfo(unitid)
		if guild then
			if not raid.guilds[guild] then
				raid.guilds[guild] = 1
			else
				raid.guilds[guild] = raid.guilds[guild] + 1
			end
		end
		if UnitIsGroupLeader(unitid) then
			raid.leadername = name
		end
		if GetNumGroupMembers() > 0 then
		        local _,rrole
			_, rank, subgroup, _, _, _, zone, _, _, rrole, isML = GetRaidRosterInfo(unitindex)
			if (not role or role == "NONE") and 
			   (rrole == "MAINTANK" or string.find(tankList, '|' .. name .. '|')) then
			  role = "TANK"
			end
		end
		if profile.IgnoreLastThreeGroups then
			if subgroup > 5 and IsInInstance() then -- only ignore in instances, so 40-man world bosses work correctly
				raid.size = raid.size - 1
				return
			end
		end
		if raid.classes[class][name] == nil then
			raid.classes[class][name] = {}
		end
		raid.ClassNumbers[class] = raid.ClassNumbers[class] + 1
		local rcn = raid.classes[class][name]
		rcn.unitid = unitid
		rcn.guid = UnitGUID(unitid) or 0
		rcn.group = subgroup
		rcn.isdead = UnitIsDeadOrGhost(unitid) or false
		rcn.class = class
		rcn.level = UnitLevel(unitid)
		rcn.raceEn = select(2,UnitRace(unitid))
		rcn.online = UnitIsConnected(unitid)
		rcn.rank = rank
		rcn.guild = guild
		local hasbuff = rcn.hasbuff or {}
		rcn.hasbuff = hasbuff
		wipe(hasbuff)
		addon:UpdateSpec(rcn)
		spec = raid.classes[class][name] and raid.classes[class][name].spec
		local mintimeleft = profile.abouttorunout * 60
		local thetime = GetTime()
		for b = 1, 32 do
			local buffName, _, _, _, _, duration, expirationTime, unitCaster = UnitBuff(unitid, b)
--			if duration and expirationTime then
--				addon:Debug(buffName .. ":" .. duration .. ":" .. expirationTime .. ":")
--			end
			if duration and expirationTime and profile.checkabouttorunout and duration > mintimeleft and (expirationTime - thetime) < mintimeleft then
--				addon:Debug(buffName .. ":" .. duration .. ":" .. expirationTime .. ":")
--				addon:Debug("running out")
--				buffName = nil
			elseif buffName then
				if buffName == wellfed then
					RBSToolScanner:Reset()
					RBSToolScanner:SetUnitBuff(unitid, b)
					hasbuff["foodz"] = getglobal('RBSToolScannerTextLeft2'):GetText()
				elseif buffName == eating then
					hasbuff["eating"] = true
				end
				local hb = hasbuff[buffName] or {}
				hasbuff[buffName] = hb
--				hb.timeleft = expirationTime - thetime
				hb.duration = duration
				if unitCaster then
					local castername = addon:UnitNameRealm(unitCaster)
					if hb.caster then  -- stacked buffs from more than one person e.g. Beacon of Light
						if not hb.casterlist then
							hb.casterlist = {}
							table.insert(hb.casterlist, hb.caster)
						end
						table.insert(hb.casterlist, castername)
					end
					hb.caster = castername
				else
					hb.caster = ""
				end
--				addon:Debug(b .. buffName .. "duration:" .. duration .. " expire:" .. expirationTime .. " caster:" .. hasbuff[buffName].caster .. " timenow:" .. GetTime())
			else
				break
			end
		end
		local specrole = "NONE"
		if type(spec_role[class]) == "string" then
		  specrole = spec_role[class]
		elseif spec and spec > 0 then
		  specrole = spec_role[class][spec]
		end
		if class == "PALADIN" and specrole == "NONE" and hasbuff[BS[25780]] then -- Righteous Fury
		  specrole = "TANK"
                end
		if (not role or role == "NONE") then
		  if specrole == "MDPS" or specrole == "RDPS" then
		    role = "DAMAGER"
		  else
                    role = specrole
 		  end
		end
		if specrole == "MDPS" then
		  ismeleedps = true
		elseif specrole == "RDPS" then
		  israngeddps = true
		end
		if role == "DAMAGER" then
		  isdps = true
		elseif role == "TANK" then
		  istank = true
		elseif role == "HEALER" then
		  ishealer = true
		end

		if class == "PRIEST" or class == "PALADIN" or class == "MAGE" or class == "WARLOCK" or class == "SHAMAN" then
			hasmana = true
		elseif class == "DRUID" and (spec == 1 or spec == 4) then
			hasmana = true
		elseif class == "MONK" and spec == 2 then
			hasmana = true
		end

		if istank then
			table.insert(raid.TankList, name)
		end
		if hasmana then
			table.insert(raid.ManaList, name)
		end
		if isdps then
			table.insert(raid.DPSList, name)
		end
		if ishealer then
			table.insert(raid.HealerList, name)
		end
		
		rcn.readid = raid.readid
		rcn.zone = zone
		rcn.distance = addon:DistanceQuery(unitid)
		rcn.role = role
		rcn.istank = istank
		rcn.hasmana = hasmana
		rcn.isdps = isdps
		rcn.ismeleedps = ismeleedps
		rcn.israngeddps = israngeddps
		rcn.ishealer = ishealer
		rcn.realm = realm
		rcn.name = name
	end
end

function addon:DeleteOldUnits()
	for class,_ in pairs(raid.classes) do
		for name,_ in pairs(raid.classes[class]) do
			if raid.classes[class][name].readid < raid.readid then
				raid.classes[class][name] = nil
			end
		end
	end
end

function addon:DistanceBegin()
  if incombat or not profile.checkzone then return end
  addon.dist_info = addon.dist_info or {}
  local d = addon.dist_info
  local lvl = GetCurrentMapDungeonLevel()
  if lvl and lvl > 0 then
    d.disabled = true -- SetDungeonMapLevel doesn't correctly reset the map in many cases, 
                      -- and we don't really need distance info anyway while inside a dungeon
    return
  else
    d.disabled = nil
  end
  d.oldcont = GetCurrentMapContinent()
  d.oldmap = GetCurrentMapAreaID()
  if WorldMapFrame then -- prevent map flicker
    WorldMapFrame.blockWorldMapUpdate = true
  end
  SetMapZoom(0)  -- azeroth continent
  d.px,d.py = GetPlayerMapPosition("player")
  d.contscalex = 47714
  d.contscaley = 31809
  if d.px == 0 and d.py == 0 then
    SetMapZoom(3)  -- outland continent
    d.px,d.py = GetPlayerMapPosition("player")
    d.contscalex = 16321
    d.contscaley = 10854
  end
end

function addon:DistanceQuery(unitid) -- return approximate distance in yards between player and unit. 
                                     -- Results are only meaningful when both units are in the outside world on the same continent
  local d = addon.dist_info
  if incombat or not profile.checkzone or d.disabled then return nil end
  if d.px == 0 and d.py == 0 then -- i am not in the world, no answer
    return nil
  end
  local x,y = GetPlayerMapPosition(unitid)
  if (x == 0 and y == 0) then -- he is not in the world on my continent, inf distance
    return maxdistance
  end
  return math.sqrt(math.pow(d.contscalex*(d.px - x),2)+math.pow(d.contscaley*(d.py - y),2))
end

function addon:DistanceEnd()
  local d = addon.dist_info
  if incombat or not profile.checkzone or d.disabled then return end
  -- some addons (eg GatherMate2) foolishly assume the world map doesn't change via other addons, so unconditionally put it back
  if GetCurrentMapContinent() ~= d.oldcont then SetMapZoom(d.oldcont) end
  if GetCurrentMapAreaID() ~= d.oldmap then SetMapByID(d.oldmap) end
  if WorldMapFrame then
    WorldMapFrame.blockWorldMapUpdate = nil
  end
end

local linelimit = 150
function addon:Say(msg, player, prepend, channel)
	if not msg then
		msg = "nil"
	end
	local canspeak = UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or raid.pug
	while #msg > 0 do
	  local str = msg
	  if #str > linelimit then
            local bpt = linelimit
            for i = linelimit, linelimit-30, -1 do -- look for break characters near the end
              if string.match(string.sub(str,i), "^[%p%s]") then
                bpt = i
                break
              end
            end
            msg = str:sub(bpt+1)
            str = str:sub(1,bpt)
          else
            msg = ""
	  end
	  if prepend then
		str = "RBS::"..str
	  end
	  if player and type(player) == "number" then -- BNet ID
	  	BNSendWhisper(player, str)
	  elseif player then
	  	player = player:gsub("%s*%(.+%)$","")  -- remove note suffix
		SendChatMessage(str, "WHISPER", nil, player)
	  elseif channel then
		SendChatMessage(str, channel)
   	  else
	        if profile.ReportChat and not raid.isbattle then
		    if raid.islfg then SendChatMessage(str, "INSTANCE_CHAT")
		    elseif raid.isparty then SendChatMessage(str, "PARTY")
		    elseif raid.israid and canspeak then SendChatMessage(str, "RAID") 
		    end
	        end
		if profile.ReportSelf then addon:Print(str) end
		if profile.ReportOfficer then SendChatMessage(str, "officer") end
	  end
	end
end

function addon:Debug(msg)
	if not profile.Debug then
		return
	end
	local str = "RBS::"
	for _,s in pairs({strsplit(" ", msg)}) do
		if #str + #s >= 250 then
			addon:Print(str)
			str = "RBS::"
		end
		str = str .. " " .. s
	end
	addon:Print(str)
end


function addon:OnProfileChanged()
	profile = addon.db.profile
	addon:UpdateProfileConfig()
	addon:UpdateProfileBuffs()
	addon:LoadFramePosition()
	addon:AddBuffButtons()
	addon:SetFrameColours()
end

function addon:SetFrameColours()
	addon.frame:SetBackdropBorderColor(profile.bbr, profile.bbg, profile.bbb, profile.bba)
	addon.frame:SetBackdropColor(profile.bgr, profile.bgg, profile.bgb, profile.bga)
	addon.talentframe:SetBackdropBorderColor(profile.bbr, profile.bbg, profile.bbb, profile.bba)
	addon.talentframe:SetBackdropColor(profile.bgr, profile.bgg, profile.bgb, profile.bga)
	addon.optionsframe:SetBackdropBorderColor(profile.bbr, profile.bbg, profile.bbb, profile.bba)
	addon.optionsframe:SetBackdropColor(profile.bgr, profile.bgg, profile.bgb, profile.bga)
end

function addon:SetupFrames()
	local frame, button, fs -- temps used below
	-- main frame
	frame = CreateFrame("Frame", "RBSFrame", UIParent)
	addon.frame = frame
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("MEDIUM")
	frame:SetMovable(true)
	frame:SetToplevel(true)
	frame:SetWidth(128)
	frame:SetHeight(190)
	frame:SetScale(profile.dashscale)
	fs = frame:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText("RBS " .. addon.version)
	fs:SetPoint("TOP",0,-5)
	fs:SetTextColor(.9,0,0)
	fs:Show()
	frame:SetBackdrop( { 
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetScript("OnMouseDown",function(self, button)
		if ( button == "LeftButton" ) then
			if not profile.LockWindow then
				if not profile.movewithaltclick or (profile.movewithaltclick and IsAltKeyDown()) then
					self:StartMoving()
				end
			end
		end
	end)
	frame:SetScript("OnMouseUp",function(self, button)
		if ( button == "LeftButton" ) then
			self:StopMovingOrSizing()
			addon:SaveFramePosition()
		end
	end)
	frame:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)
	frame:SetClampedToScreen(true)
	addon:LoadFramePosition()

        
	button = CreateFrame("Button", "$parentBossButton", addon.frame, "OptionsButtonTemplate")
	addon.bossbutton = button
	button:SetText(L["Boss"])
	button:SetWidth(45)
	button:SetPoint("BOTTOMLEFT", addon.frame, "BOTTOMLEFT", 7, 5)
	button:SetScript("OnClick", function()
		if profile.abouttorunoutdash then
			profile.checkabouttorunout = true
		end
		addon:DoReport(true)
		addon:UpdateButtons()
		if IsControlKeyDown() then
			addon:ReportToWhisper(true)
		else
			if IsShiftKeyDown() then
				addon:ReportToChat(true, "officer")
			else
				addon:ReportToChat(true)
			end
		end
	end)
	button:Show()

	button = CreateFrame("Button", "$parentTrashButton", addon.frame, "OptionsButtonTemplate")
	addon.trashbutton = button
	button:SetText(L["Trash"])
	button:SetWidth(45)
	button:SetPoint("BOTTOMRIGHT", addon.frame, "BOTTOMRIGHT", -7, 5)
	button:SetScript("OnClick", function()
		profile.checkabouttorunout = false
		addon:DoReport(true)
		addon:UpdateButtons()
		if IsControlKeyDown() then
			addon:ReportToWhisper(false)
		else
			if IsShiftKeyDown() then
				addon:ReportToChat(false, "officer")
			else
				addon:ReportToChat(false)
			end
		end
	end)
	button:Show()

	button = CreateFrame("Button", "$parentReadyCheckButton", addon.frame, "OptionsButtonTemplate")
	addon.readybutton = button
	button:SetText(L["R"])
	button:SetWidth(22)
	button:SetPoint("BOTTOMRIGHT", addon.frame, "BOTTOM", 0, 5)
	button:SetScript("OnClick", function()
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			DoReadyCheck()
		else
			addon:OfficerWarning()
		end
	end)
	button:SetScript("OnEnter", function(owner)  
			GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["Ready Check"]) 
			GameTooltip:Show() 
		end)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:Show()

	button = CreateFrame("Button", "$parentPullButton", addon.frame, "OptionsButtonTemplate")
	addon.pullbutton = button
	button:SetText(L["P"])
	button:SetWidth(22)
	button:SetPoint("BOTTOMLEFT", addon.frame, "BOTTOM", 0, 5)
	button:SetScript("OnClick", function()
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			local func = SlashCmdList["DEADLYBOSSMODS"]
			if func then
				func("pull 10")
				return
			end
			func = SlashCmdList.BIGWIGSPULL
			if func then
				func("10")
				return
			end
		else
			addon:OfficerWarning()
		end
	end)
	button:SetScript("OnEnter", function(owner)  
			GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["Pull Timer"]) 
			GameTooltip:Show() 
		end)
	button:SetScript("OnLeave", GameTooltip_Hide)
	button:Show()

	button = CreateFrame("Button", "$parentTalentsButton", addon.frame, "SecureActionButtonTemplate")
	addon.talentsbutton = button
	button:SetWidth(20)
	button:SetHeight(20)
	button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down") 
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:ClearAllPoints()
	button:SetPoint("TOPLEFT", addon.frame, "TOPLEFT", 5, -5)
	button:SetScript("OnClick", function()
		addon:ToggleTalentsFrame()
	end
	)
	button:Show()

	button = CreateFrame("Button", "$parentOptionsButton", addon.frame, "SecureActionButtonTemplate")
	addon.optionsbutton = button
	button:SetWidth(20)
	button:SetHeight(20)
	button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down") 
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:ClearAllPoints()
	button:SetPoint("TOPRIGHT", addon.frame, "TOPRIGHT", -5, -5)
	button:SetScript("OnClick", function() addon:ToggleOptionsFrame() end)
	button:Show()

	-- Dashboard scan button
	button = CreateFrame("Button", "$parentScanButton", addon.frame, "OptionsButtonTemplate")
	addon.scanbutton = button
	button:SetText(L["Scan"])
	button:SetWidth(55)
	button:SetHeight(15)
	button:SetPoint("TOP", addon.frame, "TOP", 0, -18)
	button:SetScript("OnClick", function()
		addon:DoReport(true)
		addon:Debug("Scan button")
	end)
	button:Show()

	addon:AddBuffButtons()

	-- talents window frame

	local talentframe = CreateFrame("Frame", "RBSTalentsFrame", UIParent, "DialogBoxFrame")
	addon.talentframe = talentframe
	talentframe:Hide()
	talentframe:EnableMouse(true)
	talentframe:SetFrameStrata("MEDIUM")
	talentframe:SetMovable(true)
	talentframe:SetToplevel(true)
	talentframe:SetWidth(tfi.framewidth)
	talentframe:SetHeight(190)
	fs = talentframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText("RBS " .. addon.version .. " - " .. L["Talent Specialisations"])
	fs:SetPoint("TOP",0,-5)
	fs:SetTextColor(1,1,1)
	fs:Show()
	talentframe:SetBackdrop( { 
		bgFile = "Interface\\Buttons\\WHITE8X8", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	talentframe:ClearAllPoints()
	talentframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	talentframe:SetScript("OnMouseDown",function(self, button)
		if ( button == "LeftButton" ) then
			if not profile.LockWindow then
				self:StartMoving()
			end
		end
	end)
	talentframe:SetScript("OnMouseUp",function(self, button)
		if ( button == "LeftButton" ) then
			self:StopMovingOrSizing()
			addon:SaveFramePosition()
		end
	end)
	talentframe:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)
        -- button: sort by name
	button = CreateFrame("Button", nil, talentframe, "OptionsButtonTemplate")
	button:SetText(L["Name"])
	button:SetWidth(tfi.namewidth)
	button:SetPoint("TOPLEFT", talentframe, "TOPLEFT", tfi.namex, -20)
	button:SetScript("OnClick", function()
		tfi.sort = "name"
		tfi.sortorder = 0 - tfi.sortorder
		addon:ShowTalentsFrame()
	end)
	button:Show()
        -- button: sort by class
	button = CreateFrame("Button", nil, talentframe, "OptionsButtonTemplate")
	button:SetText(L["Class"])
	button:SetWidth(tfi.classwidth)
	button:SetPoint("TOPLEFT", talentframe, "TOPLEFT", tfi.classx, -20)
	button:SetScript("OnClick", function()
		tfi.sort = "class"
		tfi.sortorder = 0 - tfi.sortorder
		addon:ShowTalentsFrame()
	end)
        -- button: sort by spec
	button:Show()
	button = CreateFrame("Button", nil, talentframe, "OptionsButtonTemplate")
	button:SetText(L["Spec"])
	button:SetWidth(tfi.specwidth)
	button:SetPoint("TOPLEFT", talentframe, "TOPLEFT", tfi.specx, -20)
	button:SetScript("OnClick", function()
		tfi.sort = "spec"
		tfi.sortorder = 0 - tfi.sortorder
		addon:ShowTalentsFrame()
	end)
	button:Show()
        -- button: sort by role
	button = CreateFrame("Button", nil, talentframe, "OptionsButtonTemplate")
	button:SetText(L["Role"])
	button:SetWidth(tfi.specwidth)
	button:SetPoint("TOPLEFT", talentframe, "TOPLEFT", tfi.rolex, -20)
	button:SetScript("OnClick", function()
		tfi.sort = "role"
		tfi.sortorder = 0 - tfi.sortorder
		addon:ShowTalentsFrame()
	end)
	button:Show()
        -- button: sort by talents
	button = CreateFrame("Button", nil, talentframe, "OptionsButtonTemplate")
	button:SetText(L["Specialisations"])
	button:SetWidth(tfi.specialisationswidth)
	button:SetPoint("TOPLEFT", talentframe, "TOPLEFT", tfi.specialisationsx, -20)
	button:SetScript("OnClick", function()
		tfi.sort = "specialisations"
		tfi.sortorder = 0 - tfi.sortorder
		addon:ShowTalentsFrame()
	end)
	button:Show()
        -- button: refresh
	button = CreateFrame("Button", nil, talentframe, "OptionsButtonTemplate")
	button:SetText(L["Refresh"])
	button:SetWidth(90)
	button:SetPoint("BOTTOMRIGHT", addon.talentframe, "BOTTOMRIGHT", -5, 5)
	button:SetScript("OnClick", function() addon:RefreshTalents() end)
	button:Show()

	local rowy = 0 - tfi.topedge
	for i = 1, tfi.maxrows do
		tfi.rowframes[i] = {}
		local rowframe = CreateFrame("Frame", nil, talentframe)
		tfi.rowframes[i].rowframe = rowframe
		rowframe:SetWidth(tfi.rowwidth)
		rowframe:SetHeight(tfi.rowheight)
		rowframe:ClearAllPoints()
		rowframe:SetPoint("TOPLEFT", talentframe, "TOPLEFT", tfi.edge + tfi.inset, rowy)
		fs = rowframe:CreateFontString(nil,"ARTWORK","GameFontNormal")
		tfi.rowframes[i].name = fs
		fs:SetText("Must be in a party/raid")
		fs:SetPoint("TOPLEFT", rowframe, "TOPLEFT", 0, -2)
		fs:SetTextColor(.9,0,0)
		fs:Show()
		-- button: class
		button = CreateFrame("Button", nil, rowframe)
		tfi.rowframes[i].class = button
		button:SetWidth(tfi.buttonsize)
		button:SetHeight(tfi.buttonsize)
		button:SetNormalTexture("Interface\\Icons\\INV_ValentinesCandy")
		button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		button:SetPoint("TOPLEFT", rowframe, "TOPLEFT", tfi.classx + ((tfi.classwidth - 30) / 2), 0)
		button:Show()
		-- button: role
		button = CreateFrame("Button", nil, rowframe)
		tfi.rowframes[i].role = button
		button:SetWidth(tfi.buttonsize)
		button:SetHeight(tfi.buttonsize)
		button:SetNormalTexture("Interface\\Icons\\INV_ValentinesCandy")
		button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		button:SetPoint("TOPLEFT", rowframe, "TOPLEFT", tfi.rolex + ((tfi.rolewidth - 30) / 2), 0)
		button:Show()
		-- button: spec
		button = CreateFrame("Button", nil, rowframe)
		tfi.rowframes[i].spec = button
		button:SetWidth(tfi.buttonsize)
		button:SetHeight(tfi.buttonsize)
		button:SetNormalTexture("Interface\\Icons\\Ability_ThunderBolt")
		button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		button:SetPoint("TOPLEFT", rowframe, "TOPLEFT", tfi.specx + ((tfi.specwidth - 30) / 2), 0)
		button:Show()
		-- talent buttons, numbered ascending left-to-right, right-anchored
		tfi.rowframes[i].specialisations = {}
		for j = 13, 1, -1 do
			button = CreateFrame("Button", nil, rowframe)
			tfi.rowframes[i].specialisations[j] = button
			button:SetWidth(tfi.buttonsize)
			button:SetHeight(tfi.buttonsize)
			button:SetNormalTexture("Interface\\Icons\\Ability_ThunderBolt")
			button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
			if j == 13 then
			  button:SetPoint("TOPRIGHT", rowframe, "TOPRIGHT", 0 - tfi.inset, 0)
			else
			  button:SetPoint("TOPRIGHT", tfi.rowframes[i].specialisations[j + 1], "TOPLEFT", 0, 0)
			end
			button:Show()
		end
		rowy = rowy - tfi.rowheight - tfi.rowgap
	end


	-- options window frame
	local optionsframe = CreateFrame("Frame", "RBSOptionsFrame", UIParent, "DialogBoxFrame")
	addon.optionsframe = optionsframe
	optionsframe:Hide()
	optionsframe:EnableMouse(true)
	optionsframe:SetFrameStrata("MEDIUM")
	optionsframe:SetMovable(true)
	optionsframe:SetToplevel(true)
	optionsframe:SetWidth(300)
	optionsframe:SetHeight(228)
	optionsframe:SetScale(profile.optionsscale)
	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText("RBS " .. addon.version .. " - " .. L["Buff Options"])
	fs:SetPoint("TOP",0,-5)
	fs:SetTextColor(1,1,1)
	fs:Show()
	optionsframe:SetBackdrop( { 
		bgFile = "Interface\\Buttons\\WHITE8X8", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	optionsframe:ClearAllPoints()
	optionsframe:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	optionsframe:SetScript("OnMouseDown",function(self, button)
		if ( button == "LeftButton" ) then
			if not profile.LockWindow then
				self:StartMoving()
			end
		end
	end)
	optionsframe:SetScript("OnMouseUp",function(self, button)
		if ( button == "LeftButton" ) then
			self:StopMovingOrSizing()
			addon:SaveFramePosition()
		end
	end)
	optionsframe:SetScript("OnHide",function(self) self:StopMovingOrSizing() end)

	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText(L["Is a warning"] .. ":")
	fs:SetPoint("TOPLEFT",10,-53)
	fs:SetTextColor(1,1,1)
	fs:Show()
	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText(L["Is a buff"] .. ":")
	fs:SetPoint("TOPLEFT",10,-73)
	fs:SetTextColor(1,1,1)
	fs:Show()
	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText(L["Show on dashboard"] .. ":")
	fs:SetPoint("TOPLEFT",10,-93)
	fs:SetTextColor(1,1,1)
	fs:Show()
	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText(L["Show/Report in combat"] .. ":")
	fs:SetPoint("TOPLEFT",10,-113)
	fs:SetTextColor(1,1,1)
	fs:Show()
	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText(L["Report on Trash"] .. ":")
	fs:SetPoint("TOPLEFT",10,-133)
	fs:SetTextColor(1,1,1)
	fs:Show()
	fs = optionsframe:CreateFontString("$parentTitle","ARTWORK","GameFontNormal")
	fs:SetText(L["Report on Boss"] .. ":")
	fs:SetPoint("TOPLEFT",10,-153)
	fs:SetTextColor(1,1,1)
	fs:Show()

	button = CreateFrame("Button", nil, optionsframe, "OptionsButtonTemplate")
	button:SetText(L["Buff Wizard"])
	button:SetPoint("BOTTOMLEFT", optionsframe, "BOTTOMLEFT", 10, 25)
	button:SetScript("OnClick", function() addon:OpenBlizzAddonOptions() end)
	button:Show()

	local bufflist = {}
	local BF = addon.BF
	for buffcheck, _ in pairs(BF) do
		table.insert(bufflist, buffcheck)
	end
	table.sort(bufflist, function (a,b) return BF[a].order > BF[b].order end)

	local saveradio = function (self)
		local name = self.optname
		local group = self.optgroup
		if group then -- clear other radio buttons
			profile[group .. "warning"] = false
			profile[group .. "buff"] = false
		end
		local setting = self:GetChecked() and true or false
		profile[name] = setting
		addon:Debug(name.." set to: "..tostring(setting))
		if group then
			addon:UpdateOptionsButtons()
		end
		addon:AddBuffButtons()
		addon:UpdateButtons()
	end

	local currentx = 165
	for _, buffcheck in ipairs(bufflist) do
		addon:AddOptionsBuffButton(buffcheck, currentx, -25, BF[buffcheck].icon, BF[buffcheck].tip)
		addon:AddOptionsBuffRadioButton(buffcheck .. "warning", buffcheck, currentx, -50, saveradio, "Radio")
		addon:AddOptionsBuffRadioButton(buffcheck .. "buff",    buffcheck, currentx, -70, saveradio, "Radio")
		addon:AddOptionsBuffRadioButton(buffcheck .. "dash",       nil, currentx, -90, saveradio, "Check")
		addon:AddOptionsBuffRadioButton(buffcheck .. "dashcombat", nil, currentx, -110, saveradio, "Check")
		addon:AddOptionsBuffRadioButton(buffcheck .. "trash", 	   nil, currentx, -130, saveradio, "Check")
		addon:AddOptionsBuffRadioButton(buffcheck .. "boss",       nil, currentx, -150, saveradio, "Check")
		currentx = currentx + 22
	end
	optionsframe:SetWidth(currentx + 9)
	addon:SetFrameColours()
end


function addon:SaveFramePosition()
	profile.x = addon.frame:GetLeft()
	profile.y = addon.frame:GetTop()
end

function addon:LoadFramePosition()
	addon.frame:ClearAllPoints()
	if (profile.x ~= 0) or (profile.y ~= 0) then
		addon.frame:SetPoint("TOPLEFT", UIParent,"BOTTOMLEFT", profile.x, profile.y)
	else
		addon.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function addon:IconFix()
	addon:Debug("icon fix")
	local BF = addon.BF
	local needscallagain = false
	for buffcheck, _ in pairs(BF) do
		if BF[buffcheck].iconfix then
			if BF[buffcheck].iconfix(self) then
				needscallagain = true
			end
		end
	end
	for _, button in ipairs(optionsiconbuttons) do
		if BF[button.buffname].iconfix then
			button:SetNormalTexture(BF[button.buffname].icon)
		end
	end
	if needscallagain then
		addon:Debug("scheduling another icon fix")
		addon:ScheduleTimer(function()
			addon:IconFix()
		end, 15)  -- try again in 15 secs
	else
		addon:Debug("NOT scheduling another icon fix")
		addon:AddBuffButtons()
	end
end

function addon:AddBuffButtons()
	if (InCombatLockdown()) then
		return
	end
	addon:HideAllBars()
	local warnings = {}
	local buffs = {}
	local bosses = {}
	for _, v in ipairs(buttons) do
		v.free = true
		v:Hide()
	end
	local BF = addon.BF
	for buffcheck, _ in pairs(BF) do
		
		if not profile[buffcheck .. "dash"] and not profile[buffcheck .. "dashcombat"] and not profile[buffcheck .. "boss"] and not profile[buffcheck .. "trash"] then
			 profile[BF[buffcheck].check] = false -- if nothing using it then switch off
		end
		if not profile[buffcheck .. "dash"] and profile[buffcheck .. "dashcombat"] then
			 profile[BF[buffcheck].check] = true
		end

		if  (not incombat and profile[buffcheck .. "dash"]) or (incombat and profile[buffcheck .. "dashcombat"]) then
			if profile.groupsortstyle == "three" then
				if profile[buffcheck .. "boss"] and (not profile[buffcheck .. "trash"]) then
					table.insert(bosses, buffcheck)
				else
					if profile[buffcheck .. "warning"] then
						table.insert(warnings, buffcheck)
					end
					if profile[buffcheck .. "buff"] then
						table.insert(buffs, buffcheck)
					end
				end
			else
				if profile[buffcheck .. "boss"] or profile[buffcheck .. "warning"] or profile[buffcheck .. "buff"] then
					table.insert(warnings, buffcheck)
				end
			end
		end
		
	end
	addon:SortButtons(bosses)
	addon:SortButtons(buffs)
	addon:SortButtons(warnings)
	local currenty
	if incombat or profile.hidebossrtrash then
		currenty = -14
	else
		currenty = 8
	end
	if profile.dashcols < 6 then profile.dashcols = 6 end -- minimum raised from 5 to 6 in 5.9.2
	local maxcols = profile.dashcols
	local cols = { 10, 32, 54, 76, 98, 120, 142, 164, 186, 208, 230, 252, 274, 296, 318, 340, 362, 384, 402, 424, 446, 468, 490}
	if profile.statusbarpositioning == "bottom" then
		currenty = addon:AddBars(currenty)
	end
	if # bosses > 0 then
		currenty = addon:AddButtonType(bosses, maxcols, cols, currenty)
	end
	if profile.statusbarpositioning == "twodown" then
		currenty = addon:AddBars(currenty)
	end
	if # buffs > 0 then
		currenty = addon:AddButtonType(buffs, maxcols, cols, currenty)
	end
	if profile.statusbarpositioning == "onedown" then
		currenty = addon:AddBars(currenty)
	end
	if # warnings > 0 then
		currenty = addon:AddButtonType(warnings, maxcols, cols, currenty)
	end
	if profile.statusbarpositioning == "top" then
		currenty = addon:AddBars(currenty) + 2
	end
	if incombat or profile.hidebossrtrash then
		addon.bossbutton:Hide()
		addon.trashbutton:Hide()
		addon.readybutton:Hide()
		addon.pullbutton:Hide()
		if incombat then
			addon.talentsbutton:Hide()
			addon.optionsbutton:Hide()
		end
	else
		addon.bossbutton:Show()
		addon.trashbutton:Show()
		addon.readybutton:Show()
		addon.pullbutton:Show()
		addon.talentsbutton:Show()
		addon.optionsbutton:Show()
		addon.scanbutton:Show()
	end
	addon.frame:SetHeight(currenty + 50)
	addon.frame:SetWidth(maxcols * 22 + 18)
	addon:SetBarsWidth()
end

function addon:AddButtonType(buttonlist, maxcols, cols, currenty)
	local BF = addon.BF
	for i, v in ipairs(buttonlist) do
		local x = cols[((i - 1) % maxcols) + 1]
		local y = currenty + (22 * (math.ceil((# buttonlist)/maxcols) - math.floor((i - 1) / maxcols)))
		addon:AddBuffButton(v, x, y, BF[v].icon, BF[v].update, BF[v].click, BF[v].tip)
	end
	return (currenty + 6 + 22 * math.ceil((# buttonlist)/maxcols))
end

function addon:SortButtons(buttonlist)
	local BF = addon.BF
	table.sort(buttonlist, function (a,b)
		for _, sortmethod in ipairs(profile.buffsort) do
			if sortmethod == "defaultorder" then
				return (BF[a].order > BF[b].order)
			elseif sortmethod == "raid" then
				if BF[a].raidwidebuff ~= BF[b].raidwidebuff then
					if BF[a].raidwidebuff and not BF[b].raidwidebuff then
						return true
					else
						return false
					end
				end
			elseif sortmethod == "consumables" then
				if BF[a].consumable ~= BF[b].consumable then
					if BF[a].consumable and not BF[b].consumable then
						return true
					else
						return false
					end
				end
			elseif sortmethod == "self" then
				if BF[a].selfonlybuff ~= BF[b].selfonlybuff then
					if BF[a].selfonlybuff and not BF[b].selfonlybuff then
						return true
					else
						return false
					end
				end
			elseif sortmethod == "other" then
				if BF[a].other ~= BF[b].other then
					if BF[a].other and not BF[b].other then
						return true
					else
						return false
					end
				end
			elseif sortmethod == "single" then
				if BF[a].singletarget ~= BF[b].singletarget then
					if BF[a].singletarget and not BF[b].singletarget then
						return true
					else
						return false
					end
				end
			elseif sortmethod == "class" then
				local adic = BF[a].class or {}
				local bdic = BF[b].class or {}
				local alist = {}
				local blist = {}
				for class, _ in pairs(adic) do
					table.insert(alist, class)
				end
				for class, _ in pairs(bdic) do
					table.insert(blist, class)
				end
				if #alist == 1 and (#blist < 1 or #blist > 1) then
					return true
				elseif #alist < 1 or #alist > 1 then
					return false
				end
				if alist[1] ~= blist[1] then
					return (alist[1] > blist[1])
				end
			elseif sortmethod == "my" then
				local aclasslist = BF[a].class or {}
				local bclasslist = BF[b].class or {}
				if aclasslist[playerclass] ~= bclasslist[playerclass] then
					if aclasslist[playerclass] and not bclasslist[playerclass] then
						return true
					else
						return false
					end
				end
			end
		end
		return (BF[a].order > BF[b].order)
	end)
end


function addon:AddBuffButton(name, x, y, icon, update, click, tooltip)
	local button = nil
	for _, v in ipairs(buttons) do
		if v.free then
			button = v
			button.update = nil
			button:SetScript("PreClick", nil)
			button:SetScript("PostClick", nil)
			button:SetScript("OnEnter", nil)
			button:SetScript("OnLeave", nil)
			button:SetAttribute("type", nil)
			button:SetAttribute("spell", nil)
			button:SetAttribute("unit", nil)
			button:SetAttribute("name", nil)
			button:SetAttribute("item", nil)
			button.count:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			button.count:SetText("")
			break
		end
	end
	if not button then
		button = CreateFrame("Button", nil, addon.frame, "SecureActionButtonTemplate")
		button:RegisterForClicks("LeftButtonUp","RightButtonUp")
		table.insert(buttons, button)
		button:Hide()
		button:SetWidth(20)
		button:SetHeight(20)
		button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		button:SetAlpha(1)
		local count = button:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
		button.count = count
		count:SetWidth(25)
		count:SetHeight(20)
		count:SetFont(count:GetFont(),11,"OUTLINE")
		count:SetPoint("CENTER", button, "CENTER", 0, 0)
		count:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		count:SetText("X")
		count:Show()
	end
	button.free = false
	button:SetNormalTexture(icon)
	button:SetPoint("BOTTOMLEFT", addon.frame, "BOTTOMLEFT", x, y)
	if click then
		button:SetScript("PreClick", click)
	end
	if update then
		button.update = update
	end
	if tooltip then
		button:SetScript("OnEnter", function (self)
			tooltip(self)
			addon.tooltipupdate = function ()
				tooltip(self)
			end
		end)
		button:SetScript("OnLeave", function()
			addon.tooltipupdate = nil
			GameTooltip:Hide()
		end)
	end
	button:Show()
end

function addon:AddOptionsBuffButton(buffname, x, y, icon, tooltip)
	local button = CreateFrame("Button", nil, addon.optionsframe, "SecureActionButtonTemplate")
	button.buffname = buffname
	table.insert(optionsiconbuttons, button)
	button:Hide()
	button:SetWidth(20)
	button:SetHeight(20)
	button:SetNormalTexture(icon)
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	button:SetPoint("TOPLEFT", addon.optionsframe, "TOPLEFT", x, y)
	if tooltip then
		button:SetScript("OnEnter", tooltip)
		button:SetScript("OnLeave", GameTooltip_Hide)
	end
	button:Show()
end

function addon:AddOptionsBuffRadioButton(optname, optgroup, x, y, onclick, widgettype)
	local button = CreateFrame("CheckButton", nil, addon.optionsframe, "UI" .. widgettype .. "ButtonTemplate")
	button.optname = optname
	button.optgroup = optgroup
	table.insert(optionsbuttons, button)
	button:Hide()
	button:SetWidth(20)
	button:SetHeight(20)
	button:SetPoint("TOPLEFT", addon.optionsframe, "TOPLEFT", x, y)
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	if onclick then
		button:SetScript("OnClick", onclick)
	end
	button:Show()
end



function addon:ToggleCheck(...)
	if profile[...] then
		profile[...] = false
	else
		profile[...] = true
		addon:DoReport()
	end
	addon:UpdateButtons()
end


function addon:UpdateButtons()
	for _,v in ipairs(buttons) do
		if not v.free then
			if v.update then
				v:update(v)
			end
		end
	end
	if profile.TanksAlive then
		addon:SetPercent("TanksAlive", report.TanksAlive, report.TanksAliveCount)
	end
	if profile.HealersAlive then
		addon:SetPercent("HealersAlive", report.HealersAlive, report.HealersAliveCount)
	end
	if profile.Range then
		addon:SetPercent("Range", report.Range, report.RangeCount)
	end
	if profile.Alive then
		addon:SetPercent("Alive", report.Alive, report.AliveCount)
	end
	if profile.Dead then
		addon:SetPercent("Dead", report.Dead, report.DeadCount)
	end
	if profile.RaidHealth then
		addon:SetPercent("RaidHealth", report.RaidHealth)
	end
	if profile.TankHealth then
		addon:SetPercent("TankHealth", report.TankHealth)
	end
	if profile.RaidMana then
		addon:SetPercent("RaidMana", report.RaidMana)
	end
	if profile.DPSMana then
		addon:SetPercent("DPSMana", report.DPSMana)
	end
	if profile.HealerMana then
		addon:SetPercent("HealerMana", report.HealerMana)
		if report.HealerManaIsDrinking > 0 and report.HealersAliveCountNumber > 0 then
			addon.bars["HealerMana"].bartext:SetText(L["Healer drinking"])
			addon.bars["HealerMana"].bartext:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			if lasthealerdrinking < GetTime() then
				lasthealerdrinking = GetTime() + 60
				if profile.healerdrinkingsound then
					PlaySoundFile("Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Drinks01.ogg", "Master")
				end
			end
		elseif report.HealerInRange < 1 and report.HealersAliveCountNumber > 0 then
			addon.bars["HealerMana"].bartext:SetText(L["No healer close"])
			addon.bars["HealerMana"].bartext:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			addon.bars["HealerMana"].bartext:SetText(L["Healer mana"])
			addon.bars["HealerMana"].bartext:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			--addon.bars["HealerMana"].bartext:SetShadowColor(0, 0, 0, 1)
		end
	end
end

function addon:UpdateOptionsButtons()
	for _,v in ipairs(optionsbuttons) do
		v:SetChecked(profile[v.optname])
	end
end


function addon:OnProfileEnable()
	addon:LoadFramePosition()
	addon:DoReport(true)
end

function addon:JoinedPartyRaidChanged()
	local oldstatus = raid.isparty or raid.israid
	local oldbattle = raid.isbattle
	addon:DoReport(true)
	if oldstatus then  -- was a raid or party last check
		if raid.isparty or raid.israid then -- still is a raid or party
			addon:TriggerXPerlTankUpdate()
		else	-- no longer in raid or party
			addon:HideReportFrame()
			if addon.timer then
				addon:CancelTimer(addon.timer)
				addon.timer = false
			end
		end
	else
		if raid.isparty or raid.israid then -- newly entered raid or party
			addon:TriggerXPerlTankUpdate()
			addon.timer = addon:ScheduleRepeatingTimer(addon.DoReport, profile.HowOften)
			addon:SendVersion()
			if profile.TellWizard then
				addon:PopUpWizard()
			end
		end
		if (raid.isparty and profile.AutoShowDashParty) or (raid.israid and profile.AutoShowDashRaid) then
			addon:ShowReportFrame()
		end
	end
	if not oldbattle and raid.isbattle then -- just entered a pvp battle zone (not necessarily a raid/party transition, eg arenas)
		if profile.AutoShowDashBattle then
			addon:ShowReportFrame()
		else
			addon:HideReportFrame()
		end
	end
end


function addon:OnEnable()
	local svnrev = 0
        RBS_svnrev["X-Build"] = select(3,string.find(GetAddOnMetadata("RaidBuffStatus", "X-Build") or "", "(%d+)"))
        RBS_svnrev["X-Revision"] = select(3,string.find(GetAddOnMetadata("RaidBuffStatus", "X-Revision") or "", "(%d+)"))
	for _,v in pairs(RBS_svnrev) do -- determine highest file revision
	  local nv = tonumber(v)
	  if nv and nv > svnrev then
	    svnrev = nv
	  end
	end
	addon.revision = svnrev

        RBS_svnrev["X-Curse-Packaged-Version"] = GetAddOnMetadata("RaidBuffStatus", "X-Curse-Packaged-Version")
        RBS_svnrev["Version"] = GetAddOnMetadata("RaidBuffStatus", "Version")
	addon.version = RBS_svnrev["X-Curse-Packaged-Version"] or RBS_svnrev["Version"] or "@"
	if string.find(addon.version, "@") then -- dev copy uses "@.project-version.@"
           addon.version = "r"..svnrev
	end
	
	addon:SendVersion()
	addon.versiontimer = addon:ScheduleRepeatingTimer(addon.SendVersion, 5 * 60)
	addon:RegisterEvent("PLAYER_REGEN_ENABLED", "LeftCombat")
	if (InCombatLockdown()) then
		return
	end
	addon:DelayedEnable()
end

function addon:DelayedEnable()
	addon.delayedenablecalled = true
	addon:ValidateSpellIDs()
	addon:SetupFrames()
	addon:ScheduleTimer(function()
		addon:IconFix()
	end, 15) -- to handle icons not being downloaded from the server yet HORRIBLE CODING!!
	addon:ScheduleTimer(function()
		addon:UpdateUtilData()
	end, 15) -- handle cache delay on feast spellnames
	addon:JoinedPartyRaidChanged()
	addon:UpdateMiniMapButton()
	addon:RegisterEvent("GROUP_ROSTER_UPDATE", "JoinedPartyRaidChanged")
	addon:RegisterEvent("PLAYER_ENTERING_WORLD", "JoinedPartyRaidChanged")
	addon:RegisterEvent("PLAYER_REGEN_DISABLED", "EnteringCombat")
	addon:RegisterEvent("PET_BATTLE_OPENING_START", "EnteringPetCombat")
	addon:RegisterEvent("PET_BATTLE_CLOSE", "LeftPetCombat")
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "COMBAT_LOG_EVENT_UNFILTERED")
	addon:RegisterEvent("CHAT_MSG_ADDON", "CHAT_MSG_ADDON")
	addon:RegisterEvent("CHAT_MSG_RAID_WARNING",	 	"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_PARTY", 			"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_PARTY_LEADER", 		"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_RAID", 			"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_RAID_LEADER", 		"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_INSTANCE_CHAT", 		"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER", 	"CHAT_MSG_RAID_WARNING")
	addon:RegisterEvent("CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER")
	addon:RegisterEvent("CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_WHISPER")
	addon:RegisterEvent("PARTY_INVITE_REQUEST", "PARTY_INVITE_REQUEST")
	if not _G.oRA3 then
		addon:RegisterEvent("PLAYER_DEAD", "SendDurability")
		addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "SendDurability")
		addon:RegisterEvent("MERCHANT_CLOSED", "SendDurability")
	end
--	addon:Debug('Enabled!')
	if oRA then
		addon:Debug('Registering oRA tank event')
		addon.oRAEvent:RegisterForTankEvent(function() addon:oRA_MainTankUpdate() end)
	elseif XPerl_MainTanks then
		addon:Debug('XPerl_MainTanks')
	elseif CT_RA_MainTanks then
		addon:Debug('Registering CTRA event')
		hooksecurefunc("CT_RAOptions_UpdateMTs", function() addon:oRA_MainTankUpdate() end)
	end
	addon.Prefixes = {["RBS"]=1, ["oRA3"]=1, ["CTRA"]=1}
	for prefix,_ in pairs(addon.Prefixes) do
	  RegisterAddonMessagePrefix(prefix)
	end
	hooksecurefunc(StaticPopupDialogs["RESURRECT"], "OnShow", function()
		addon:SendRezMessage("RESSED")
	end)
	WorldMapFrame:Show()
	WorldMapFrame:Hide() 
        GameTooltip:HookScript   ("OnTooltipSetItem", function(self) AddTTFeastBonus(self, self:GetItem()) end)
        ItemRefTooltip:HookScript("OnTooltipSetItem", function(self) AddTTFeastBonus(self, self:GetItem()) end)
        GameTooltip:HookScript   ("OnShow", function(self) 
	  if self:NumLines() == 1 and GameTooltipTextLeft1 then AddTTFeastBonus(self, GameTooltipTextLeft1:GetText()) end end)
end

function addon:OnDisable()
	addon:Debug('Disabled!')
	addon:UnregisterAllEvents()
	addon.oRAEvent:UnRegisterForTankEvent()
end

function addon:EnteringCombat(force)
	incombat = true
	if (InCombatLockdown()) then
		return
	end
	addon.lasttobuf = ""
	if profile.HideInCombat or (force == true) then
		if addon.frame:IsVisible() then
			dashwasdisplayed = true
			addon:HideReportFrame()
		else
			dashwasdisplayed = false
		end
		return
	end
	addon:AddBuffButtons()
	addon:UpdateButtons()
end

function addon:LeftCombat(force)
	if not addon.delayedenablecalled then
		addon:DelayedEnable()
	end
	incombat = false
	addon:AddBuffButtons()
	addon:UpdateButtons()
	if (force == true or profile.HideInCombat) and dashwasdisplayed then
		addon:ShowReportFrame()	
	end
end

function addon:EnteringPetCombat()
	addon:EnteringCombat(true)
end
function addon:LeftPetCombat()
	addon:LeftCombat(true)
end

function addon:ClassColor(name)
    local unit = addon:GetUnitFromName(name)
    if unit and unit.class and profile.TooltipNameColor then
      local cstr = RAID_CLASS_COLORS[unit.class] and RAID_CLASS_COLORS[unit.class].colorStr
      if not unit.online then
        cstr = "ff808080" -- grey
      elseif unit.isdead then
        cstr = "ffff1919" -- red
      end 
      if cstr then
        name = "\124c"..cstr..name.."\124r"
      end
    end
    if unit and unit.class and profile.TooltipRoleIcons then
      local role, roleicon = addon:UnitRole(unit)
      if role and #role > 0 and roleicon then
        local rstr
	if type(roleicon) == "table" then
	  local a,b,c,d = unpack(roleicon.coords)
	  rstr = "\124T"..roleicon.file..":0:0:0:0:64:64:"..
	         (a*64)..":"..(b*64)..":"..(c*64)..":"..(d*64)..
		 "\124t"
	else
	  rstr = "\124T"..roleicon..":0:0\124t"
	end
	name = rstr..name
      end
    end
    return name
end

function addon:FormatNameList(list)
  local str = ""
  for _, name in ipairs(list) do
    local cname = addon:ClassColor(name)
    if #str > 0 then str = str .. ", " end
    str = str .. cname
  end
  return str
end

function addon:TooltipAddNames(list, timerlist)
  for _, name in ipairs(list) do
    local note = name:match("%((.+)%)$")
    if note then 
      name = name:gsub("%s*%(.+%)$","")  -- remove note suffix
    end
    local cname = addon:ClassColor(name)
    if timerlist and not note then
      note = timerlist[name] and "("..addon:TimeSince(timerlist[name])..")"
    end
    GameTooltip:AddDoubleLine(cname, note, nil, nil, nil, 1)
  end
end

function addon:Tooltip(self, title, list, tlist, blist, slist, messagelist, itemcountlist, unknownlist, gotitlist, zonelist, itemlist)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(title,1,1,1,1,1)
	local str = ""
	if list and #list > 0 then
	  if tlist or list[1]:match("%(.+%)$") or list.notes then
	    addon:TooltipAddNames(list, tlist)
	  else
	    GameTooltip:AddLine(addon:FormatNameList(list, tlist),nil,nil,nil,1)
	  end
	end
	if blist and #blist > 0 then
	  if GameTooltip:NumLines() > 1 then GameTooltip:AddLine(" ") end
	  GameTooltip:AddLine(L["Buffers: "]..addon:FormatNameList(blist),GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, 1)
	end
	if gotitlist then
		if #gotitlist > 0 then
	        	if GameTooltip:NumLines() > 1 then GameTooltip:AddLine(" ") end
	  		GameTooltip:AddLine(L["Has buff: "]..addon:FormatNameList(gotitlist),nil,nil,nil,1)
		elseif next(gotitlist) then
	        	if GameTooltip:NumLines() > 1 then GameTooltip:AddLine(" ") end
			GameTooltip:AddDoubleLine(L["Has buff: "], L["Cast by:"], nil, nil, nil, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
			for name, caster in pairs(gotitlist) do
				if gotitlist.invert_table then
					local tmp = name
					name = caster
					caster = tmp
				end
				if caster and caster:match("^\?") then
					caster = "???"
				end
				if caster ~= "invert_table" then
					GameTooltip:AddDoubleLine(addon:ClassColor(name), addon:ClassColor(caster), 
					                          nil, nil, nil, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
				end
			end
		end
	end
	if slist and #slist > 0 then
	        if GameTooltip:NumLines() > 1 then GameTooltip:AddLine(" ") end
		GameTooltip:AddLine(L["Slackers: "]..addon:FormatNameList(slist),RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, 1)
	end
	if itemcountlist then
		if #itemcountlist > 0 then
			GameTooltip:AddLine(L["Item count: "], 1, 0, 1, 1)
			for _,s in pairs(itemcountlist) do
				GameTooltip:AddLine(s, 1, 0, 1, 1)
			end
		end
	end
	if unknownlist and #unknownlist > 0 then
	        if GameTooltip:NumLines() > 1 then GameTooltip:AddLine(" ") end
		GameTooltip:AddLine(L["Missing or not working oRA or RBS: "]..
		                    addon:FormatNameList(unknownlist),RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, 1)
	end
	if zonelist then
		for _,name in ipairs(zonelist) do
			local cname = addon:ClassColor(name)
			local zone = ""
    			local unit = addon:GetUnitFromName(name)
			if unit and unit.zone then
				zone = unit.zone
			end
			GameTooltip:AddDoubleLine(cname, zone,nil,nil,nil,1,0,0)
		end
	end
	if itemlist then
		for name, num in pairs(itemlist) do
			GameTooltip:AddDoubleLine(name, num, nil, nil, nil, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		end
	end
	if messagelist then
	        if GameTooltip:NumLines() > 1 then GameTooltip:AddLine(" ") end
		if type(messagelist) == "table" then
			for message,_ in pairs(messagelist) do
				GameTooltip:AddLine(message)
			end
		else
				GameTooltip:AddLine(messagelist)
		end
	end
	GameTooltip:Show()
end

function addon:DefaultButtonUpdate(self, thosemissing, profcheck, checking, morework)
	if not profcheck then
		self.count:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		self.count:SetText("X")
		self:SetAlpha("0.5")
	else
		if checking then
			local r = NORMAL_FONT_COLOR.r
			local g = NORMAL_FONT_COLOR.g
			local b = NORMAL_FONT_COLOR.b
			if profile.HighlightMyBuffs then
				if #thosemissing > 0 then
					if morework and addon:AmIListed(morework) then
						r = RED_FONT_COLOR.r
						g = RED_FONT_COLOR.g
						b = RED_FONT_COLOR.b
					elseif addon:AmIListed(thosemissing) then
						r = 0
						g = 1
						b = 1
					end
				end
			end
			self.count:SetTextColor(r, g, b)
			self.count:SetText(#thosemissing)
			self:SetAlpha("1")
		else
			self.count:SetText("")
			self:SetAlpha("0.15")
		end
	end
end


function addon:ButtonClick(self, button, down, buffcheck, cheapspell, nonselfbuff, bagitem, itemslot)
        addon:Debug("button="..(button or "nil")..
	                     " buffcheck="..(buffcheck or "nil")..
	                     " cheapspell="..(cheapspell or "nil")..
	                     " nonselfbuff="..(nonselfbuff and "true" or "false")..
	                     " bagitem="..(bagitem or "nil")..
	                     " itemslot="..(itemslot or "nil"))
	local BF = addon.BF
	local check = BF[buffcheck].check
	local prefix
	if profile[buffcheck .. "buff"] then
		prefix = L["Missing buff: "]
	else
		prefix = L["Warning: "]
	end
	if profile[check] then
		local action = "none"
		if button == "LeftButton" then
			if IsAltKeyDown() then
				action = profile.AltLeftClick
			elseif IsShiftKeyDown() then
				action = profile.ShiftLeftClick
			elseif IsControlKeyDown() then
				action = profile.ControlLeftClick
			else
				action = profile.LeftClick
			end
		elseif button == "RightButton" then
			if IsAltKeyDown() then
				action = profile.AltRightClick
			elseif IsShiftKeyDown() then
				action = profile.ShiftRightClick
			elseif IsControlKeyDown() then
				action = profile.ControlRightClick
			else
				action = profile.RightClick
			end
		end
		if not InCombatLockdown() then
			self:SetAttribute("type", nil)
			self:SetAttribute("spell", nil)
			self:SetAttribute("unit", nil)
			self:SetScript("PostClick", nil)
			self:SetAttribute("item", nil)
		end
		if cheapspell and action == "buff" then
			addon:DoReport()
			if not InCombatLockdown() and # report[BF[buffcheck].list] > 0 then
				if nonselfbuff then
					if # report[BF[buffcheck].list] > 0 then
						local unitidtobuff, spelltobuff
						if BF[buffcheck].raidbuff then
							unitidtobuff, spelltobuff = addon:RaidBuff(report[BF[buffcheck].list], cheapspell)
						elseif BF[buffcheck].partybuff then
							unitidtobuff, spelltobuff = addon:PartyBuff(report[BF[buffcheck].list], cheapspell)
						elseif BF[buffcheck].singlebuff then
							unitidtobuff, spelltobuff = addon:SingleBuff(report[BF[buffcheck].list], cheapspell)
						end
						self:SetAttribute("type", "spell")
						self:SetAttribute("spell", spelltobuff)
						self:SetAttribute("unit", unitidtobuff)
						if unitidtobuff then  -- maybe none in range
							self:SetScript("PostClick", function(self)
								if rezspellshash[self:GetAttribute("spell")] then
									addon:SendRezMessage("RES " .. UnitName(self:GetAttribute("unit")))
								end
								self:SetAttribute("type", nil)
								self:SetAttribute("spell", nil)
								self:SetAttribute("unit", nil)
								self:SetScript("PostClick", nil)
							end)
						end
					end
				else
					self:SetAttribute("type", "spell")
					self:SetAttribute("spell", cheapspell)
					self:SetAttribute("target-slot", itemslot)
					self:SetAttribute("unit", "player") -- buff self to hit group, in case we're targetting a friendly NPC
					self:SetScript("PostClick", function(self)
						self:SetAttribute("spell", nil)
						self:SetAttribute("target-slot", nil)
					        self:SetAttribute("unit", nil)
						self:SetScript("PostClick", nil)
					end)					
				end
			end
		elseif bagitem and action == "buff" then
			addon:DoReport()
			if not InCombatLockdown() and # report[BF[buffcheck].list] > 0 then
				for _, name in ipairs(report[BF[buffcheck].list]) do
					local unit = addon:GetUnitFromName(name)
					if unit and unit.unitid and not unit.isdead and unit.online and UnitInRange(unit.unitid) then
						self:SetAttribute("type", "item")
						self:SetAttribute("item", bagitem)
						self:SetAttribute("target-slot", itemslot)
						self:SetScript("PostClick", function(self)
							self:SetAttribute("type", nil)
							self:SetAttribute("item", nil)
							self:SetAttribute("target-slot", nil)
							self:SetScript("PostClick", nil)
						end)
						break
					end
				end
			end
		elseif action == "buff" then -- not buffable, target cycle
			addon:DoReport()
			local list = report[BF[buffcheck].list]
			if not InCombatLockdown() and #list > 0 then
				addon.targetclickpos = addon.targetclickpos or {}
				local clickpos = addon.targetclickpos[buffcheck]
				local minid, minunit, newpos
				if buffcheck == "zone" then
				  local now = GetTime()
				  addon.zoneclickgen = addon.zoneclickgen or {}
				  newpos = clickpos or 0 -- generation
			  	  if now > (addon.lastzoneclick or 0) + 120 then -- reset zone traversal after inactivity
					newpos = 0
					wipe(addon.zoneclickgen)
				  end
				  addon.lastzoneclick = now
				  -- generational traversal of the list, favoring more distant or recently-added players
				  local mingen, maxdist, minname
				  for _, name in ipairs(list) do
					local unit = addon:GetUnitFromName(name)
					if unit and unit.unitid then
						local ugen = addon.zoneclickgen[name] or 0
						local udist = unit.distance or maxdistance
						if not minunit or   -- first seen
						   ugen < mingen or -- older gen or new to list
						   (ugen == mingen and udist > maxdist) or -- farthest
						   (ugen == mingen and udist == maxdist and name < minname) -- alphabetical name subkey
						then
						  mingen = ugen
						  maxdist = udist
						  minname = name
						  minunit = unit.unitid
						end
					end
				  end
				  if minunit then
				    if newpos < mingen then newpos = mingen end -- generation advance
				    addon.zoneclickgen[minname] = newpos + 1 -- place in next generation
				  end
				else
				  for _, name in ipairs(list) do
					local unit = addon:GetUnitFromName(name)
					if unit and unit.unitid then
						local id,cid
						if false then -- sort by unit, player last
						  if unit.unitid == "player" then
						    id = 0
						  else
						    id = tonumber(unit.unitid:match("(%d+)$"))
						  end
						  if id and clickpos and id <= clickpos then cid = id + 80 else cid = id end -- wraparound
						else -- sort by name
						  id = name
						  if id and clickpos and id <= clickpos then cid = "{"..id else cid = id end -- wraparound
						end
						if cid then
							if not minid or cid < minid then
								minid = cid
								newpos = id
								minunit = unit.unitid
							end
						end
					end
				  end
				end
				if minunit then
					addon.targetclickpos[buffcheck] = newpos
					self:SetAttribute("type", "target")
					self:SetAttribute("unit", minunit)
					self:SetScript("PostClick", function(self)
						self:SetAttribute("type", nil)
					        self:SetAttribute("unit", nil)
						self:SetScript("PostClick", nil)
					end)
				end
			end
		elseif action == "report" then
			addon:DoReport(true)
	                local canspeak = UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or raid.pug
			if not canspeak and profile.ReportChat and raid.israid then
				addon:OfficerWarning()
			end
			if type(BF[buffcheck].chat) == "string" then
				if # report[BF[buffcheck].list] > 0 then
					if BF[buffcheck].timer then
						local timerlist = {}
						for _, n in ipairs(report[BF[buffcheck].list]) do
							if raid.BuffTimers[buffcheck .. "timerlist"][n] then
								table.insert(timerlist, n .. "(" .. addon:TimeSince(raid.BuffTimers[buffcheck .. "timerlist"][n]) .. ")")
							else
								table.insert(timerlist, n)
							end
						end
						addon:Say("<" .. BF[buffcheck].chat .. ">: " .. table.concat(timerlist, ", "))
					else
						addon:Say(prefix .. "<" .. BF[buffcheck].chat .. ">: " .. table.concat(report[BF[buffcheck].list], ", "))
					end
				end
			elseif type(BF[buffcheck].chat) == "function" then
				BF[buffcheck].chat(report, raid, prefix)
			end
		elseif action == "whisper" then
			addon:DoReport(true)
			addon:WhisperBuff(BF[buffcheck], report, raid, prefix)
			
		elseif action == "enabledisable" then
			addon:ToggleCheck(check)
		end
	else
		addon:ToggleCheck(check)
	end
end

function addon:WhisperBuff(buff, report, raid, prefix)
	if buff.selfbuff then
		if type(buff.chat) == "string" then
			if # report[buff.list] > 0 then
				for _, v in ipairs(report[buff.list]) do
					addon:Say(prefix .. "<" .. buff.chat .. ">: " .. v, v)
				end
			end
		elseif type(buff.chat) == "function" then
			buff.chat(report, raid, prefix)
		end
	elseif buff.whispertobuff then
		if #report[buff.list] > 0 then
			buff.whispertobuff(report[buff.list], prefix, buff.buffinfo)
		end
	end
end

function addon:TitleCaps(str)
	str = string.lower(str)
	return str:gsub("%a", string.upper, 1)
end

function addon:TimeSince(thetimethen)
	local thedifference = math.floor(GetTime() - thetimethen)
	if thedifference < 60 then
		return (thedifference .. "s")
	end
	return (math.floor(thedifference / 60) .. "m" .. (thedifference % 60) .. "s")
end


function addon:GetUnitFromName(whom)
        whom = whom:gsub("%s*%(.+%)$","") -- remove any note suffix
	for class,cinfo in pairs(raid.classes) do
		local u = cinfo[whom]
		if u then return u end
	end
	return nil
end

function addon:RaidBuff(list, cheapspell) -- raid-wide buffs
	local usable, nomana = IsUsableSpell(cheapspell)
	if not usable and not nomana then
		return nil
	end
	local pb = {}
	local outofrange
	local thiszone = addon:GetMyZone()
	for _, v in ipairs(list) do
		local unit = addon:GetUnitFromName(v)
		if unit and unit.unitid and (not unit.isdead or rezspellshash[cheapspell]) and unit.online and (not raid.israid or unit.zone == thiszone) then
			table.insert(pb, unit)
		end
	end
--	addon:Debug("starting sort")
	table.sort(pb, function (a,b)
		if a == nil then
			addon:Debug("sort failing - a is nil")
			return false
		end
		if b == nil then
			addon:Debug("sort failing - b is nil")
			return true
		end
--		addon:Debug("comparing:" .. a.name .. "(" .. a.class .. ") " .. b.name .. "(" .. b.class .. ")")
		if a.unitid == addon.lasttobuf then
			return false
		end
		if b.unitid == addon.lasttobuf then
			return true
		end
		local arezeetime = addon.rezeetime[a.name] or 0
		local brezeetime = addon.rezeetime[b.name] or 0
		if arezeetime ~= brezeetime then
			return arezeetime < brezeetime
		end
		local foundb = false
		for _, name in pairs(addon.rezerrezee) do
			if name == a.name then
				return false
			end
			if name == b.name then
				foundb = true
			end
		end
		if foundb then
			return true
		end
		if rezclasses[a.class] and not rezclasses[b.class] then
			return true
		end
		if rezclasses[b.class] then
			return false
		end
		if raid.israid  then
			local myx, myy = GetPlayerMapPosition("player")
			local ax, ay = GetPlayerMapPosition(a.unitid)
			local bx, by = GetPlayerMapPosition(b.unitid)
			if (myx == 0 and myy == 0) or (ax == 0 and ay == 0) or (bx == 0 and by == 0) then
				return false
			end
			local adist = math.pow(myx-ax, 2) + math.pow(myy-ay, 2)
			local bdist = math.pow(myx-bx, 2) + math.pow(myy-by, 2)
--			addon:Debug(a.name .. " " .. adist)
--			addon:Debug(b.name .. " " .. bdist)
			return (bdist < adist)
		end
		return false
	end)
--	addon:Debug("finished sort")
	for _, v in ipairs(pb) do
		if IsSpellInRange(cheapspell, v.unitid) == 1 or rezspellshash[cheapspell] then
			addon.lasttobuf = v.unitid
--			if #pb >= profile.HowMany and reagentspell then
--				if addon:GotReagent(reagent) then
--					return v.unitid, reagentspell
--				end
--			end
			return v.unitid, cheapspell
		end
		outofrange = addon:UnitNameRealm(v.unitid)
	end
	if #pb == 0 then
		return nil
	end
	addon:Print("RBS: " .. L["Out of range"] .. ": " .. outofrange)
	UIErrorsFrame:AddMessage("RBS: " .. L["Out of range"] .. ": " .. outofrange, 0, 1.0, 1.0, 1.0, 1)
	return nil
end

function addon:PartyBuff(list, cheapspell) -- party-wide buffs
	local usable, nomana = IsUsableSpell(cheapspell)
	if not usable and not nomana then
		return nil
	end
	local pb = {{},{},{},{},{},{},{},{}}
	local outofrange
	for _, v in ipairs(list) do
		local unit = addon:GetUnitFromName(v)
		if unit and unit.unitid and not unit.isdead and unit.online then
			table.insert(pb[unit.group], unit.unitid)
		end
	end
	table.sort(pb, function (a,b)
		return(#a > #b)
	end)
	for i,_ in ipairs(pb) do
		for _, v in ipairs(pb[i]) do
			if IsSpellInRange(cheapspell, v) == 1 then
--				if #pb[i] >= profile.HowMany then
--					if addon:GotReagent(reagent) then
--						return v, reagentspell
--					end
--				end
--				return v, cheapspell
			end
			outofrange = v
		end
	end
	if #pb == 0 then
		return nil
	end
	addon:Print("RBS: " .. L["Out of range"] .. ": " .. outofrange)
	UIErrorsFrame:AddMessage("RBS: " .. L["Out of range"] .. ": " .. outofrange, 0, 1.0, 1.0, 1.0, 1)
	return nil
end

function addon:SingleBuff(list, cheapspell) -- single unit buffs
	local usable, nomana = IsUsableSpell(cheapspell)
	if not usable and not nomana then
		return nil
	end
	return addon:RaidBuff(list, cheapspell)
end

function addon:GotReagent(reagent)
	if reagent == nil then
		return true
	end
	for bag = 0, NUM_BAG_FRAMES do
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag, slot);
			if item then
				if string.find(item, "[" .. reagent .. "]", 1, true) then
					return true
				end
			end
		end
	end
	return false
end

function addon:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, subevent, hideCaster, 
	srcGUID, srcname, srcflags, srcRaidFlags, 
	dstGUID, dstname, dstflags, dstRaidFlags, 
	spellID, spellname, spellschool, extraspellID, extraspellname, extraspellschool, auratype)
	if not raid.israid and not raid.isparty then
		return
	end
	if not subevent then
		return
	end
	if (subevent == "UNIT_DIED" and band(dstflags,COMBATLOG_OBJECT_TYPE_PLAYER) > 0) or 
	   (spellID == 27827 and subevent == "SPELL_AURA_APPLIED") then -- Spirit of Redemption
		--addon:Debug(subevent .. " someone died:" .. dstname)
		local unit = addon:GetUnitFromName(dstname)
		if not unit then
			return
		end
		if subevent == "UNIT_DIED" and unit.spec == 2 then -- Holy
			addon:Debug("was a priest with spirit of redemption")
			return
		end
		addon:SomebodyDied(unit)
		return
	end
	if not spellID or not spellname then -- must come after UNIT_DIED, which has no spell
		return
	end
	if (spellID == 20707 or spellID == 6203) and 
	   (subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") then 
		addon:LockSoulStone(srcname)
		addon:Debug("Lock cast soulstone:" .. srcname .. " " .. subevent)
		return
	end
	if (spellID == 34477 or spellID == 57934) and
	   subevent == "SPELL_CAST_SUCCESS" and 
	   profile.misdirectionwarn and
	   addon:IsInRaid(srcname) then
		addon:MisdirectionEventLog(srcname, spellname, dstname)
		return
	end
	if not incombat then
			if not srcname then return end

			if rezspellshash[spellname] then
				if subevent == "SPELL_CAST_START" then
					addon:Debug(srcname .. " rezing someone")
				elseif subevent == "SPELL_CAST_FAILED" then
					addon:Debug(srcname .. " rezing someone failed")
					addon.rezerrezee[srcname] = nil
					if srcGUID == playerid then
						addon:SendRezMessage("RESNO")
					end
				elseif subevent == "SPELL_CAST_SUCCESS" then
					addon:Debug(srcname .. " rezing someone success")
					if addon.rezerrezee[srcname] then
						addon.rezeetime[addon.rezerrezee[srcname]] = GetTime()
					end
					addon.rezerrezee[srcname] = nil
					if srcGUID == playerid then
						addon:SendRezMessage("RESNO")
					end
				end
				return
			else
				addon.rezerrezee[srcname] = nil
			end
			if subevent == "SPELL_CAST_START" or 
			   subevent == "SPELL_CAST_SUCCESS" then
			   local info = utildata[spellID]
			   if info then
			   	if info.slow and subevent == "SPELL_CAST_START" then return end -- wait for completion of long casts

			   	if addon:IsInRaid(srcname) or 
				   (info.ungrouped and UnitFactionGroup(srcname)==UnitFactionGroup("player")) then
					addon:Announces(info.category, srcname, nil, spellID)
				end
			   end
			end
	end
	if not dstflags or band(dstflags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0 then
		return  -- the destination is a player and we only care about stuff to mobs
	end
	-- else do workaround for broken polymorph combat log
	if (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REMOVED") and 
	   workaroundbugccspellshash[spellname] and profile.ccwarn then
		if not srcname or not addon:IsInRaid(srcname) then
			return
		end
		addon:WorkAroundBugCCEvent(event, timestamp, subevent, 
			srcGUID, srcname, srcflags, srcRaidFlags, 
			dstGUID, dstname, dstflags, dstRaidFlags,
			spellID, spellname, spellschool, extraspellID, extraspellname)
	elseif dstGUID and currentsheep[dstGUID] and profile.ccwarn then
		addon:Debug("was sheeped")
--		if not srcname or not addon:IsInRaid(srcname) then
--			return
--		end
		if (GetTime() - currentsheep[dstGUID]) > 35 then
			currentsheep[dstGUID] = nil
			currentsheepspell[dstGUID] = nil
			return
		end
		if subevent:find("DAMAGE") then
			addon:Debug("got dmg")
			if spellID == 339 then -- Entangling Roots do dmg but don't break
				addon:Debug("but it was roots")
				return
			end
		else
			addon:Debug("returning")
			return
		end
		-- Fake a CC break event.
		addon:Debug("faking broken:" .. spellID .. " " .. spellname)
		if subevent == "SWING_DAMAGE" then
			spellname = L["Melee Swing"]
		end
		addon:CCEventLog(event, timestamp, "SPELL_AURA_BROKEN_SPELL", 
			srcGUID, srcname, srcflags, srcRaidFlags, 
			dstGUID, dstname, dstflags, dstRaidFlags,
			currentsheepspell[dstGUID], BS[currentsheepspell[dstGUID]], spellschool, spellID, spellname)
		currentsheep[dstGUID] = nil
		currentsheepspell[dstGUID] = nil
	elseif taunthash[spellID] and (subevent == "SPELL_MISSED" or subevent == "SPELL_AURA_APPLIED") and 
	       profile.tankwarn then
		if not srcname or not addon:IsInRaid(srcname) then
			return
		end
		addon:TauntEventLog(event, timestamp, subevent, 
			srcGUID, srcname, srcflags, srcRaidFlags, 
			dstGUID, dstname, dstflags, dstRaidFlags,
			spellID, spellname, spellschool, extraspellID, extraspellname)
	elseif (subevent == "SPELL_AURA_BROKEN" or subevent == "SPELL_AURA_BROKEN_SPELL" ) and 
	       ccspellshash[spellname] and profile.ccwarn then
		if not srcname or not addon:IsInRaid(srcname) then
			return
		end
		addon:CCEventLog(event, timestamp, subevent, 
			srcGUID, srcname, srcflags, srcRaidFlags, 
			dstGUID, dstname, dstflags, dstRaidFlags,
			spellID, spellname, spellschool, extraspellID, extraspellname)
	end
end

function addon:WorkAroundBugCCEvent(event, timestamp, subevent, 
	srcGUID, srcname, srcflags, srcRaidFlags, 
	dstGUID, dstname, dstflags, dstRaidFlags, 
	spellID, spellname, spellschool, extraspellID, extraspellname)
	if subevent == "SPELL_AURA_APPLIED" then
		currentsheep[dstGUID] = GetTime()
		currentsheepspell[dstGUID] = spellID
	else
		if currentsheep[dstGUID] and (GetTime() - currentsheep[dstGUID]) > 35 then -- likely just expired
			currentsheep[dstGUID] = nil
			currentsheepspell[dstGUID] = nil
		end
	end
end

function addon:MisdirectionEventLog(srcname, spellname, dstname)
	if profile.misdirectionself then
		UIErrorsFrame:AddMessage(L["%s cast %s on %s"]:format(srcname, spellname, dstname), 0, 1.0, 1.0, 1.0, 1)
		addon:Print(L["%s cast %s on %s"]:format(srcname, spellname, dstname))
	end
	if profile.misdirectionsound then
		PlaySoundFile("Sound\\Doodad\\ET_Cage_Close.wav", "Master")
	end
end


function addon:CCEventLog(event, timestamp, subevent, 
	srcGUID, srcname, srcflags, srcRaidFlags, 
	dstGUID, dstname, dstflags, dstRaidFlags, 
	spellID, spellname, spellschool, extraspellID, extraspellname)
	if not spellID or not dstGUID or not srcname then
		return
	end
	if band(tonumber(dstGUID:sub(0,5), 16), 0x00f) ~= 0x003 then
		return  -- the destination is not a creature
	end
	if profile.cconlyme and not srcGUID == playerid then
		return
	end
	local unit = addon:GetUnitFromName(srcname)
	if not unit then -- must be pet or someone outside the raid interferring
		unit = {}
	end
	local cctype = "ccwarnnontank"
	local prepend =  true
	if unit.istank then
		cctype = "ccwarntank"
		prepend = false
	end
	local dsticon = dstRaidFlags and addon:GetIcon(dstRaidFlags) or ""
	if dsticon ~= "" then
		dsticon = "{rt" .. dsticon .. "}"
	end
	if subevent == "SPELL_AURA_BROKEN" then
		if prepend then
			addon:CCBreakSay((L["Non-tank %s broke %s on %s%s%s"]):format(srcname, spellname, dsticon, dstname, dsticon), cctype)
		else
			addon:CCBreakSay((L["%s broke %s on %s%s%s"]):format(srcname, spellname, dsticon, dstname, dsticon), cctype)
		end
		
	elseif subevent == "SPELL_AURA_BROKEN_SPELL" then
		if prepend then
			addon:CCBreakSay((L["Non-tank %s broke %s on %s%s%s with %s"]):format(srcname, spellname, dsticon, dstname, dsticon, extraspellname), cctype)
		else
			addon:CCBreakSay((L["%s broke %s on %s%s%s with %s"]):format(srcname, spellname, dsticon, dstname, dsticon, extraspellname), cctype)
		end
	end
end


function addon:TauntEventLog(event, timestamp, subevent, 
	srcGUID, srcname, srcflags, srcRaidFlags, 
	dstGUID, dstname, dstflags, dstRaidFlags, 
	spellID, spellname, spellschool, misstype)
	if not taunthash[spellID] then
		return
	end
	local targetid = UnitGUID("target")
	local mytarget = true
	if dstGUID ~= targetid then
		if not profile.tauntmeself and not profile.tauntmesound and not profile.tauntmerw and not profile.tauntmeraid and not profile.tauntmeparty then
			return
		end
		if band(dstflags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0 then
			return  -- the destination is not a creature
		end
		mytarget = false
	end
	local boss = false
	if UnitLevel("target") == -1 then
		boss = true
	end
	if profile.bossonly and not boss then
		return
	end
	local dsticon = dstRaidFlags and addon:GetIcon(dstRaidFlags) or ""
	if dsticon ~= "" then
		dsticon = "{rt" .. dsticon .. "}"
	end
	local miss = ""
	if subevent == "SPELL_MISSED" then
		if misstype == "EVADE" or misstype == "IMMUNE" then
			miss = L["[IMMUNE]"]
		else
			miss = L["[RESIST]"]
		end
	end
	if srcGUID == playerid then
		if subevent ~= "SPELL_MISSED" then
			return
		end
		if misstype == "EVADE" or misstype == "IMMUNE" then
			if boss then
				addon:TauntSay(miss .. " " .. L["%s FAILED TO TAUNT their boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "failedtauntimmune")
			else
				addon:TauntSay(miss .. " " .. L["%s FAILED TO TAUNT their target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "failedtauntimmune")
			end
		else
			if boss then
				addon:TauntSay(miss .. " " .. L["%s FAILED TO TAUNT their boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "failedtauntresist")
			else
				addon:TauntSay(miss .. " " .. L["%s FAILED TO TAUNT their target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "failedtauntresist")
			end
		end
		return
	end
	if not mytarget then
		if subevent ~= "SPELL_AURA_APPLIED" then
			return -- only care about suceeding taunts to mobs targeting me
		end
		if UnitGUID(srcname .. "-target") == dstGUID and UnitGUID(srcname .. "-target-target") == playerid then
			if boss then
				addon:TauntSay(L["%s taunted my boss mob (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "tauntme")
			else
				addon:TauntSay(L["%s taunted my mob (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "tauntme")
			end
		end
		return
	end
	local ninja = false
	if UnitGUID("targettarget") == playerid then
		ninja = true
	end
	if subevent == "SPELL_AURA_APPLIED" then
		local unit = addon:GetUnitFromName(srcname)
		if not unit then
			return
		end
		if unit.istank then
			if ninja then
				if boss then
					addon:TauntSay(L["%s ninjaed my boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "ninjataunt")
				else
					addon:TauntSay(L["%s ninjaed my target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "ninjataunt")
				end
			else
				if boss then
					addon:TauntSay(L["%s taunted my boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "taunt")
				else
					addon:TauntSay(L["%s taunted my target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "taunt")
				end
			end
		else
			if boss then
				addon:TauntSay(L["NON-TANK %s taunted my boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "nontanktaunt")
			else
				addon:TauntSay(L["NON-TANK %s taunted my target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "nontanktaunt")
			end
		end
	else
		if ninja then
			if boss then
				addon:TauntSay(miss .. " " .. L["%s FAILED TO NINJA my boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "otherfail")
			else
				addon:TauntSay(miss .. " " .. L["%s FAILED TO NINJA my target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "otherfail")
			end
		else
			if boss then
				addon:TauntSay(miss .. " " .. L["%s FAILED TO TAUNT my boss target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "otherfail")
			else
				addon:TauntSay(miss .. " " .. L["%s FAILED TO TAUNT my target (%s%s%s) with %s"]:format(srcname, dsticon, dstname, dsticon, spellname), "otherfail")
			end
		end
	end
end

local function EventReport(msg, dorw, doraid, doparty, doself)
  if doself then
    local fancyicon = addon:MakeFancyIcon(msg)
    UIErrorsFrame:AddMessage(fancyicon, 0, 1.0, 1.0, 1.0, 1)
    addon:Print(fancyicon)
  end
  if raid.isbattle then return end
  local canspeak = UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
  if dorw and raid.israid then
    if not canspeak then
       addon:OfficerWarning()
    else
       SendChatMessage(msg, "RAID_WARNING")
    end
  end 
  if raid.islfg and (doraid or doparty) then
    SendChatMessage(msg, "INSTANCE_CHAT")
  elseif raid.israid and doraid then
    SendChatMessage(msg, "RAID")
  elseif raid.isparty and doparty then
    SendChatMessage(msg, "PARTY")
  end
end

function addon:TauntSay(msg, typeoftaunt)
	if typeoftaunt == "taunt" then
		if profile.tauntsound then
			PlaySoundFile("Sound\\interface\\PickUp\\PickUpMetalSmall.wav", "Master")
		end
		EventReport(msg, profile.tauntrw, profile.tauntraid, profile.tauntparty, profile.tauntself)
	elseif typeoftaunt == "failedtauntimmune" then
		if profile.failsoundimmune then
			PlaySoundFile("Sound\\Spells\\SimonGame_Visual_GameFailedLarge.wav", "Master")
		end
		EventReport(msg, profile.failrwimmune, profile.failraidimmune, profile.failpartyimmune, profile.failselfimmune)
	elseif typeoftaunt == "failedtauntresist" then
		if profile.failsoundresist then
			PlaySoundFile("Sound\\Spells\\SimonGame_Visual_GameFailedSmall.wav", "Master")
		end
		EventReport(msg, profile.failrwresist, profile.failraidresist, profile.failpartyresist, profile.failselfresist)
	elseif typeoftaunt == "ninjataunt" then
		if profile.ninjasound then
			PlaySoundFile("Sound\\Doodad\\G_NecropolisWound.wav", "Master")
		end
		EventReport(msg, profile.ninjarw, profile.ninjaraid, profile.ninjaparty, profile.ninjaself)
	elseif typeoftaunt == "nontanktaunt" then
		if profile.nontanktauntsound then
			PlaySoundFile("Sound\\Creature\\Voljin\\VoljinAggro01.wav", "Master")
		end
		EventReport(msg, profile.nontanktauntrw, profile.nontanktauntraid, profile.nontanktauntparty, profile.nontanktauntself)
	elseif typeoftaunt == "otherfail" then
		if profile.otherfailsound then
			PlaySoundFile("Sound\\Doodad\\ZeppelinHeliumA.wav", "Master")
		end
		EventReport(msg, profile.otherfailrw, profile.otherfailraid, profile.otherfailparty, profile.otherfailself)
	elseif typeoftaunt == "tauntme" then
		if profile.tauntmesound then
			PlaySoundFile("Sound\\interface\\MagicClick.wav", "Master")
		end
		EventReport(msg, profile.tauntmerw, profile.tauntmeraid, profile.tauntmeparty, profile.tauntmeself)
	end
end


function addon:CCBreakSay(msg, typeoftaunt)
	if typeoftaunt == "ccwarntank" then
		if profile.ccwarntanksound then
			PlaySoundFile("Sound\\Creature\\Ram\\RamPreAggro.wav", "Master")
		end
		EventReport(msg, profile.ccwarntankrw, profile.ccwarntankraid, profile.ccwarntankparty, profile.ccwarntankself)
	elseif typeoftaunt == "ccwarnnontank" then
		if profile.ccwarnnontanksound then
			PlaySoundFile("Sound\\Creature\\Sheep\\SheepDeath.wav", "Master")
		end
		EventReport(msg, profile.ccwarnnontankrw, profile.ccwarnnontankraid, profile.ccwarnnontankparty, profile.ccwarnnontankself)
	end
end

function addon:MakeFancyIcon(msg)
	if not msg then
		msg = "nil"
	end
	while (msg:find("{rt(%d)}")) do
		local pos,_,num = msg:find("{rt(%d)}")
		local path = COMBATLOG_OBJECT_RAIDTARGET1 * (num ^ (num - 1))
		msg = msg:sub(1, pos - 1) .. "|Hicon:"..path..":dest|h|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..num..".blp:0|t|h" .. msg:sub(pos + 5)
	end
	return msg
end


function addon:OfficerWarning()
	UIErrorsFrame:AddMessage("RBS: " .. L["You need to be leader or assistant to do this"], 0, 1.0, 1.0, 1.0, 1);
	addon:Print(L["You need to be leader or assistant to do this"])
end

function addon:TriggerXPerlTankUpdate()
	xperltankrequest = true
	xperltankrequestt = GetTime() + 5 -- wait for 5 seconds to allow message to be processed by other addons before reading tank list again
end

local listenchannels = { ["RAID"]=1, ["PARTY"]=1, ["INSTANCE_CHAT"]=1 }
function addon:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
	if not prefix or not addon.Prefixes[prefix] or not message or not distribution or not sender then
	  return
	end
	addon:Debug(prefix .." message:" .. message .. " sender:" .. sender .. " distribution:" .. distribution)
	if prefix == "RBS" then
	  if strsub(message, 1, 4) == "VER " then
		local _, _, revision, version = string.find(message, "^VER (.*) (.*)")
		addon.rbsversions[sender] = version .. " build-" .. revision
		if not toldaboutnewversion and profile.versionannounce and version and
		   tonumber(revision) and tonumber(revision) > addon.revision then
			toldaboutnewversion = true
			local releasetype = ""
			if string.find(version, "^r") then
				releasetype = L["alpha"]
			elseif string.find(version, "beta") then
				releasetype = L["beta"]
			end
			addon:Print(L["%s has a newer (%s) version of RBS (%s) than you (%s)"]:format(sender, releasetype, addon.rbsversions[sender], addon.version .. " build-" .. addon.revision))
		end
		if not toldaboutrbsuser[sender] and profile.userannounce then
			toldaboutrbsuser[sender] = true
			addon:Print(L["%s is running RBS %s"]:format(sender, addon.rbsversions[sender]))
		end
	  end
	end
	if not listenchannels[distribution] then 
	  return
	end
	if prefix == "oRA3" and message:find("SDurability") then
		local _, min, broken = select(3, message:find("SDurability%^N(%d+)%^N(%d+)%^N(%d+)"))
		if min == nil then
			return
		end
		addon.durability[sender] = 0 + min
		addon.broken[sender] = broken
		addon:Debug(prefix .." message:" .. message .. " sender:" .. sender)
		addon:Debug("got one" .. min .. " " .. broken)
	elseif prefix == "CTRA" and message:find("^DURC") then
		addon:Debug("Got DURC request")
		if nextdurability - GetTime() < 30 then
			nextdurability = GetTime() + 30  -- stops it calling again too often when another person or addon does a durability check
		end
		if not oRA then
			addon:Debug("Sending DURC reply")
			addon:SendDurability(nil, sender)
		end
	elseif prefix == "CTRA" and message:find("^DUR ") then
		local cur, max, broken, requestby = select(3, message:find("^DUR (%d+) (%d+) (%d+) ([^%s]+)$"))
		cur = tonumber(cur)
		max = tonumber(max)
		if cur and max and max > 0 and cur <= max and requestby then
			local p = math.floor(cur / max * 100)
			addon.durability[sender] = p
			addon.broken[sender] = broken
		end
		return
	elseif prefix == "CTRA" and message:find("^ITM ") then
		local numitems, itemname, requestby = message:match("^ITM ([-%d]+) (.+) ([^%s]+)$")
		addon:UpdateInventory(sender, itemname, numitems)
	elseif prefix == "oRA3" and message:find("SInventoryItem") then
		local itemname, numitems = select(3, message:find("SInventoryItem%^S(.+)%^N(%d+)^"))
		addon:UpdateInventory(sender, itemname, numitems)
	elseif prefix == "CTRA" and message:find("^ITMC ") then
		local itemname = select(3, message:find("^ITMC (.+)$"))
		if itemname then
			addon:SendAddonMessage("CTRA", "ITM " .. GetItemCount(itemname) .. " " .. itemname .. " " .. sender)
		end
	elseif prefix == "oRA3" and message:find("SInventoryCount") then
		local itemname = select(3, message:find("SInventoryCount%^S(.+)%^"))
		if itemname then
			addon:SendAddonMessage("oRA3", addon:Serialize("InventoryItem", itemname, GetItemCount(itemname)))
		end
	elseif prefix == "CTRA" and message:find("CD 3 ") then
		addon:Debug("Lock cast soulstone via ora2:" .. sender)
		addon:LockSoulStone(sender)
		return
	elseif prefix == "oRA3" and message:find("Cooldown") then
		local spellid = select(3, message:find("Cooldown%^N(%d+)"))
		addon:Debug("Got cool down:" .. sender .. " " .. spellid)
		spellid = 0 + spellid
		if spellid == 6203 or spellid == 20707 then
			addon:Debug("Lock cast soulstone via ora3:" .. sender)
			addon:LockSoulStone(sender)
		end
		return
	elseif XPerl_MainTanks and prefix == "CTRA" then
		if strsub(message, 1, 4) == "SET " or strsub(message, 1, 2) == "R " then
			addon:Debug("triggered xperl tank update")
			addon:TriggerXPerlTankUpdate()
		end
	elseif prefix == "CTRA" and message:find("RES") then
		addon:Debug(prefix .." message:" .. message .. " sender:" .. sender)
		if message == "RESSED" then  -- got rez but not accepted yet
			addon:Debug("RESSED from" .. sender)
			addon.rezeetime[sender] = GetTime()
		elseif message == "NORESSED" then -- accepted, declined or timed out rez
			addon:Debug("NORESSED from" .. sender)
			addon.rezeetime[sender] = nil
		elseif message == "RESNO" then
			addon:Debug("RESNO from" .. sender)
			-- do nothing - using combat log to guess if rez was successful instead
		elseif message:find("^RES ") then
			local _, _, rezee = message:find("^RES (.+)")
			if rezee and addon:GetUnitFromName(rezee) then
				addon.rezerrezee[sender] = rezee
			end
		end
	end
end

function addon:SendVersion()
	if raid.isbattle then
		return
	end
	addon:SendAddonMessage("RBS","VER " .. addon.revision .. " " .. addon.version, true)
end

function addon:SendAddonMessage(prefix, msg, allowguild)
	if raid.islfg then
		SendAddonMessage(prefix, msg, "INSTANCE_CHAT")
	elseif raid.israid then
		SendAddonMessage(prefix, msg, "RAID")
	elseif raid.isparty then
		SendAddonMessage(prefix, msg, "PARTY")
	elseif allowguild and IsInGuild() then
		SendAddonMessage(prefix, msg, "GUILD")
	end
end

function addon:CreateBar(currenty, name, text, r, g, b, a, tooltip, chat)
	if addon.bars[name] then
		addon.bars[name].barframe:SetPoint("BOTTOMLEFT", addon.frame, "BOTTOMLEFT", 10, currenty)
		addon.bars[name].barframe:Show()
		return
	end
	local barframe = CreateFrame("Button", nil, addon.frame)
	barframe:SetHeight(10)
	barframe:SetPoint("BOTTOMLEFT", addon.frame, "BOTTOMLEFT", 10, currenty)

	local bar = barframe:CreateTexture()
	bar:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	bar:SetPoint("TOPLEFT", barframe, "TOPLEFT", 0, 0)
	bar:SetHeight(10)
	bar:SetGradientAlpha("HORIZONTAL", r, g, b, a, 0.3, 0.3, 0.3, a)

	local bartext = barframe:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
	bartext:SetPoint("LEFT", barframe, "LEFT", 0, 1)
	bartext:SetFont(bartext:GetFont(), 9)
	bartext:SetShadowColor(0, 0, 0, 1)
	bartext:SetText(text)

	local barvalue = barframe:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
	barvalue:SetPoint("RIGHT", barframe, "RIGHT", 0, 1)
	barvalue:SetFont(barvalue:GetFont(), 8)
	barvalue:SetShadowColor(0, 0, 0, 1)
	barvalue:SetText("100%")

	local barvalueb = barframe:CreateFontString(nil, "ARTWORK","GameFontNormalSmall")
	barvalueb:SetPoint("RIGHT", barframe, "RIGHT", -35, 1)
	barvalueb:SetFont(barvalueb:GetFont(), 8)
	barvalueb:SetShadowColor(0, 0, 0, 1)
	barvalueb:SetText("")

	if tooltip then
		barframe:SetScript("OnEnter", function (self)
			tooltip(self)
			addon.tooltipupdate = function ()
				tooltip(self)
			end
		end)
		barframe:SetScript("OnLeave", function()
			addon.tooltipupdate = nil
			GameTooltip:Hide()
		end)
	end
	if chat then
		barframe:SetScript("OnClick", chat)
	end
	addon.bars[name] = {}
	addon.bars[name].barframe = barframe
	addon.bars[name].bar = bar
	addon.bars[name].bartext = bartext
	addon.bars[name].barvalue = barvalue
	addon.bars[name].barvalueb = barvalueb
end

function addon:SetBarsWidth()
	local width = addon.frame:GetWidth() - 20
	for _,v in pairs(addon.bars) do
		v.barframe:SetWidth(width)
		v.bar:SetWidth(width)
	end
end

function addon:SetPercent(name, percent, valueb)
	if not valueb then
		valueb = ""
	end
	local percentwidth
	if percent == L["n/a"] then
		percentwidth = 1
	elseif percent > 99 then
		percent = 100
		percentwidth = addon.bars[name].barframe:GetWidth()
	elseif percent < 1 then
		percentwidth = 1
		percent = 0
	else
		percentwidth = addon.bars[name].barframe:GetWidth() / 100 * percent
	end
	addon.bars[name].bar:SetWidth(percentwidth)
	addon.bars[name].barvalue:SetText(percent .. "%")
	addon.bars[name].barvalueb:SetText(valueb)
end

function addon:HideAllBars()
	for _,v in pairs(addon.bars) do
		v.barframe:Hide()
	end
end

function addon:BarTip(owner, title, list)
	GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
	GameTooltip:SetText(title,1,1,1,1,1)
	if list then
		for name, percent in pairs(list) do
			GameTooltip:AddDoubleLine(addon:ClassColor(name), percent)
		end
	end
	GameTooltip:Show()
end

function addon:BarChat(name, title)
	if not IsShiftKeyDown() or raid.isbattle then
		return
	end
	local percent = addon.bars[name].barvalue:GetText()
	if not percent or string.len(percent) < 1 then
		return
	end
	local number = addon.bars[name].barvalueb:GetText()
	local message = title .. ": " .. percent
	if number and string.len(number) > 0 then
		message = message .. " (" .. number .. ")"
	end
	addon:Say(message)
end

function addon:AmIListed(list)
	if not list then
		return
	end
	for _,v in ipairs(list) do
		if v == playername then
			return true
		end
	end
	return false
end

function addon:RefreshTalents()
	GI:Rescan()
	for class,_ in pairs(raid.classes) do
		for name,rcn in pairs(raid.classes[class]) do
			rcn.talents = nil
			rcn.specname = "UNKNOWN"
			rcn.specicon = "UNKNOWN"
		end
	end
	addon:UpdateTalentsFrame()
end

addon.lastannounce = {}
local function announcekey(category, spellid)
  local ret = category
  if category == "Feast" or category == "Cart" or category == "Portal" then
    ret = ret..":"..spellid
  end
  return ret
end

function addon:RecordAnnounce(category, spellid) -- record we saw an announce
	addon.lastannounce[announcekey(category, spellid)] = GetTime()
end

function addon:TimeToAnnounce(category, spellid) -- ask if it's time to announce, and if so record it
	local key = announcekey(category, spellid)
	local now = GetTime()
	-- use a 30 sec delay to prevent duplicate announces even under a max calcdelay()
	if now > (addon.lastannounce[key] or 0) + 30 then
		addon.lastannounce[key] = now	
		return true
	else
		return false
	end
end

function addon:Announces(message, who, callback, spellID)
	addon:Debug("Announces: " .. tostring(message)..":"..tostring(who)..":"..tostring(callback)..":"..tostring(spellID))
	local info = spellID and utildata[spellID]
	if not message or not who or not spellID or not info then
		addon:Debug("BOGUS call to :Announces")
		return
	end
	if message == "Soulwell" then
		addon.soulwelllastseen = GetTime() + 120
	end
	if raid.isbattle then
		addon:Debug("battle")
		return
	end
	if not callback or callback ~= "callback" then -- delay to ensure single announce
	  addon:ScheduleTimer(function()
	      addon:Announces(message, who, "callback", spellID)
	    end, addon:calcdelay())
          return
	end
	local isdead = UnitIsDeadOrGhost("player") or false

	local msg = ""
        local canspeak = UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")

	local expiring = message:find("Expiring")
	local setting = "announce"..message:gsub("Expiring","")
	if not profile[setting] then return end
	if expiring and (incombat or isdead or not profile.announceExpiration) then return end

	local shortwho = who:gsub("%-[^%-]+$","")
	local label
	local link = spellID and GetSpellLink(spellID)
	local linksuffix = (link and " ("..link..")") or ""
	if info.label then
		label = info.label
	elseif link then
		label = link
		linksuffix = ""
	else
		label = info.name
	end

	if message == "Feast" then
			if addon:TimeToAnnounce(message, spellID) then
				msg = shortwho .. " " .. (L["prepares a %s!"]):format(label)
				local zone = GetRealZoneText()
				if info.bonus then
				  local btext = _G["ITEM_MOD_"..info.bonus.."_SHORT"]
				  if btext then
				    msg = msg .. " ("..L["Bonus"].." "..btext..")" 
				  end
				end
				addon:ScheduleTimer(function()
					if zone ~= GetRealZoneText() then
						addon:Debug("Skipping expiration message due to zone change")
					else
						addon:Announces(message .. "Expiring", who, nil, spellID)
					end
				end, 180-20)
			end
			addon:PingMinimap(who)
			
	elseif message == "FeastExpiring" then
	        	local players = tonumber(addon.report.AliveCount) or raid.size
			local feeds = info.limit or 40
			if players > feeds then -- dont announce expiration if there's not enough for everyone
			  return
			end
			msg = (L["%s about to expire!"]):format(label)
			if report.foodlist then
				if #report.foodlist == 0 then
				  	msg = nil -- all buffed
				elseif canspeak and profile.feastautowhisper and 
				       addon:TimeToAnnounce("FeastWhisper", 0) then -- dont wsp about mult different feasts
					addon:DoReport()
					if report.foodlist and #report.foodlist > 0 then
						for _,name in ipairs(report.foodlist) do
							addon:Say("<" .. L["Not Well Fed"] .. ">: " .. name, name)
						end
					end
				end
			end
	elseif message == "CauldronExpiring" then
			msg = (L["%s about to expire!"]):format(label)
			if report.flasklist then
				if #report.flasklist == 0 then
				  	msg = nil -- all buffed
				elseif canspeak and profile.cauldronautowhisper then
					addon:DoReport()
					if report.flasklist and #report.flasklist > 0 then
						for _,name in ipairs(report.flasklist) do
							addon:Say("<" .. L["Missing a Flask or two Elixirs"] .. ">: " .. name, name)
						end
					end
				end
			end
	elseif message == "SoulwellExpiring" then
			msg = (L["%s about to expire!"]):format(label)
			if canspeak and profile.wellautowhisper then
				addon:DoReport()
				if report.healthstonelist and #report.healthstonelist > 0 then
					for _,name in ipairs(report.healthstonelist) do
						addon:Say("<" .. L["Missing "] .. BS[6262] .. ">: " .. name, name)
					end
				end
			end
	else -- General Utilities
		if expiring then
			if false and -- appears this is no long an issue
			   message == "Repair" and GetTime() - (raid.LastDeath[who] or 0) < info.duration then
				addon:Debug("Not announcing bot expire as bot person has died.")
				return
			end
			msg = string.format(L["%s about to expire!"],label)
		else
			addon:PingMinimap(who)
			if addon:TimeToAnnounce(message, spellID) then
				if info.cast then
					msg = shortwho.." "..string.format(L["casts %s"],label)..linksuffix
				else
					msg = shortwho.." "..string.format(L["sets up a %s"],label)..linksuffix
				end
				local zone = GetRealZoneText()
				if info.duration and profile.announceExpiration then
					addon:ScheduleTimer(function()
						if zone ~= GetRealZoneText() then
							addon:Debug("Skipping expiration message due to zone change")
						else
							addon:Announces(message.."Expiring", who, nil, spellID)
						end
					end, info.duration-20)
				end
			end
		end
	end

	if not msg or msg == "" then
		return
	end

	UIErrorsFrame:AddMessage(msg, 0, 1.0, 1.0, 1.0, 1)
	--addon:Print(msg)
	if not canspeak and not profile.nonleadspeak then
	   return 
	end

	msg = "RBS:: "..msg

	if raid.islfg then
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif raid.isparty then
		SendChatMessage(msg, "PARTY")
	elseif canspeak then
		SendChatMessage(msg, "RAID_WARNING")
	elseif IsInRaid() then -- might be false if we just left raid
		SendChatMessage(msg, "RAID")
	end
end

local feastpat = L["prepares a %s!"]:gsub("%%s","(.+)")
function addon:CHAT_MSG_RAID_WARNING(event, message, who)
	if not message or not who then return end

	local info
	-- first look for spell links
	local spellid = tonumber(message:match("\124Hspell:(%d+)\124h"))
	info = utildata[spellid]
	if not info then -- then look for item links
		local itemid = message:match("\124Hitem:(%d+)\124h")
		info = itemid and utildata["item:"..itemid]
	end

	if info then
		addon:RecordAnnounce(info.category, info.id)
		return
	end

	-- check messages from old RBS versions
	if message:find(L[" has set us up a Refreshment Table"]) then
		addon:RecordAnnounce("Table") ; return
	elseif message:find((L["prepares a %s!"]):format(BS[92649])) -- Cauldron of Battle
		or message:find((L["prepares a %s!"]):format(BS[92712])) then -- Big Cauldron of Battle
		addon:RecordAnnounce("Cauldron") ; return
	elseif message:find(L[" has set us up a Soul Well"]) then
		addon:RecordAnnounce("Soulwell") ; return
	elseif message:find(L[" has set us up a Repair Bot"]) then
		addon:RecordAnnounce("Repair") ; return
	elseif message:find(L[" has set us up a Blingtron"]) then
		addon:RecordAnnounce("Blingtron") ; return
	else -- old feast messages
		local m = message:match(feastpat)
		if m then
		  local id = utildata[m] and utildata[m].id
		  if id then
			addon:RecordAnnounce("Feast", id) ; return
		  end
		end
	end

	-- heuristic magic to try and notice other addons
	-- TODO: ignore expiration messages
	if message:match("^RSC") 
	  then
	    local m = message:lower() -- normalize case
	    -- XXX: both RBS and RSC currently misspell 'Soulwell' as 'Soul Well'
	    --      this will eventually be fixed in RBS and this normalization will need to be reversed
	    m = m:gsub("soulwell", "soul well") 
	    -- RSC uses locale-specific announces, eg english: (currently just these four)
	    -- rsctableused1 = "has set up a Food Feast!"
	    -- rsctableused2 = "has set up a Cauldron with Flasks!"
	    -- rsctableused3 = "has set up a Repair Bot!"
	    -- rsctableused4 = "is casting a Soul Well!"
	    for _,info in pairs(utildata) do
	      if (info.name and m:find(info.name:lower()))
	      or (info.label and m:find(info.label:lower()))
	      then
		addon:RecordAnnounce(info.category, info.id)
		return
	      end
	    end
	end
end

local unitlist = {}
local function unitsort(u1, u2)
  if UnitIsGroupLeader(u1.unitid) or UnitIsGroupLeader(u2.unitid) then
  	return UnitIsGroupLeader(u1.unitid)
  elseif UnitIsGroupAssistant(u1.unitid) ~= UnitIsGroupAssistant(u2.unitid) then
  	return UnitIsGroupAssistant(u1.unitid)
  else
  	return u1.guid < u2.guid
  end
end
function addon:calcdelay()
	if UnitIsGroupLeader("player") or not profile.antispam then
		return 0.5 -- don't wait when leader
	else
		wipe(unitlist)
		for class,_ in pairs(raid.classes) do
			for name,_ in pairs(raid.classes[class]) do
				table.insert(unitlist, raid.classes[class][name])
			end
		end
		table.sort(unitlist, unitsort)
		local pos = 40
		for i, u in ipairs(unitlist) do
			if u.guid == playerid then
				pos = i
				break
			end
		end
		return pos * 0.5 + 0.6
	end
end

function addon:PingMinimap(whom)
	if not Minimap:IsVisible() then
		return
	end
	if whom == playername then
		Minimap:PingLocation(0,0) -- it's me
		return
	end
	local myx, myy = GetPlayerMapPosition("player")
	local hisx, hisy = GetPlayerMapPosition(whom)
	local hisx = 0.280537
	local hisy = 0.698122
	if (myx == 0 and myy == 0) or (hisx == 0 and hisy == 0) then
		return -- can't get coords
	end
	
	if true then
		return -- does not work yet..... so return
	end

	local zoneheight = 527.6066263822604 -- Blizz PLEASE provide an API for reading this!
	local zonewidth = 790.625237342102

	myy =  myy * zoneheight
	hisy = hisy * zoneheight
	myx = myx * zonewidth
	hisx = hisx * zonewidth

	local pingx = hisx - myx -- now distance in yards
	local pingy = hisy - myy

	local mapWidth = Minimap:GetWidth()
	local mapHeight = Minimap:GetHeight()
	local minimapZoom = Minimap:GetZoom()
	local mapDiameter;
	local minimapOutside
	if ( GetCVar("minimapZoom") == Minimap:GetZoom() ) then
		mapDiameter = MinimapSize.outdoor[minimapZoom]
	else
		mapDiameter = MinimapSize.indoor[minimapZoom]
	end
	local xscale = mapDiameter / mapWidth
	local yscale = mapDiameter / mapHeight

	if GetCVar("rotateMinimap") ~= "0" then
		addon:Debug("rotated minimap")
		local minimapRotationOffset = GetPlayerFacing()
		local sinTheta = sin(minimapRotationOffset)
		local cosTheta = cos(minimapRotationOffset)
		local dx, dy = pingx, pingy
		pingx = (dx * cosTheta) - (dy * sinTheta)
		pingy = (dx * sinTheta) + (dy * cosTheta)
	end
	addon:Debug("minimapZoom:" .. minimapZoom)
	addon:Debug(pingx .. " " .. pingy)

	Minimap:PingLocation(pingx / xscale, -pingy / yscale)
end


function addon:GetIcon(flag)
	local val = band(flag, COMBATLOG_OBJECT_RAIDTARGET_MASK)
	if val == 0 then
		return
	end
	local v = COMBATLOG_OBJECT_RAIDTARGET1
	for i = 1, 8 do
		if v == val then
			return i
		end
		v = v * 2
	end
	return nil
end

function addon:SayMe(msg)
	addon:Print(msg)
	UIErrorsFrame:AddMessage(msg, 0, 1.0, 1.0, 1.0, 1)
end

function addon:SomebodyDied(unit)
	addon:Debug("SomebodyDied")
	if raid.isbattle then
		return
	end
	local unitid = unit.unitid
	local name = unit.name
	raid.LastDeath[name] = GetTime()
	addon.rezeetime[name] = nil
	if not profile.deathwarn then
		return
	end
	if unitid and not UnitIsFeignDeath(unitid) then
		if unit.istank then
--			addon:Debug(L["Tank %s has died!"]:format(name), "tank")
			addon:DeathSay(L["Tank %s has died!"]:format(name), "tank")
		elseif unit.ishealer then
--			addon:Debug(L["Healer %s has died!"]:format(name), "healer")
			addon:DeathSay(L["Healer %s has died!"]:format(name), "healer")
		elseif unit.ismeleedps then
--			addon:Debug(L["Melee DPS %s has died!"]:format(name), "meleedps")
			addon:DeathSay(L["Melee DPS %s has died!"]:format(name), "meleedps")
		elseif unit.israngeddps then
--			addon:Debug(L["Ranged DPS %s has died!"]:format(name), "rangeddps")
			addon:DeathSay(L["Ranged DPS %s has died!"]:format(name), "rangeddps")
		end
	end
end


function addon:DeathSay(msg, typeofdeath)
	if typeofdeath == "tank" then
		if profile.tankdeathsound then
			PlaySoundFile("Sound\\interface\\igQuestFailed.wav", "Master")
		end
		EventReport(msg, profile.tankdeathrw, profile.tankdeathraid, profile.tankdeathparty, profile.tankdeathself)
	elseif typeofdeath == "healer" then
		if profile.healerdeathsound then
			PlaySoundFile("Sound\\Event Sounds\\Wisp\\WispPissed1.wav", "Master")
		end
		EventReport(msg, profile.healerdeathrw, profile.healerdeathraid, profile.healerdeathparty, profile.healerdeathself)
	elseif typeofdeath == "meleedps" then
		if profile.meleedpsdeathsound then
			PlaySoundFile("Sound\\interface\\iCreateCharacterA.wav", "Master")
		end
		EventReport(msg, profile.meleedpsdeathrw, profile.meleedpsdeathraid, profile.meleedpsdeathparty, profile.meleedpsdeathself)
	elseif typeofdeath == "rangeddps" then
		if profile.rangeddpsdeathsound then
			PlaySoundFile("Sound\\interface\\iCreateCharacterA.wav", "Master")
		end
		EventReport(msg, profile.rangeddpsdeathrw, profile.rangeddpsdeathraid, profile.rangeddpsdeathparty, profile.rangeddpsdeathself)
	end
end

function addon:SelectSeal()
	if not raid.classes.PALADIN[playername] then
		return
	end
	if raid.classes.PALADIN[playername].spec == 1 then -- holy
		return BS[20165] -- Seal of Insight
	end
	return BS[31801] -- Seal of Truth
end

function addon:GroupInSpecT_Update(e, guid, unit, info)
        local class = select(2, UnitClass(unit))
	local name = addon:UnitNameRealm(unit)
	local rcn = class and name and raid.classes[class][name]
	if not rcn then return end
	rcn.tinfo = info
	addon:UpdateSpec(rcn)
	if addon.talentframe:IsVisible() then
		addon:UpdateTalentsFrame()
	end
end

function addon:UpdateSpec(rcn)
        local info = rcn.guid and GI:GetCachedInfo(rcn.guid)
	rcn.tinfo = info or rcn.tinfo
        local spec = rcn.tinfo and rcn.tinfo.spec_index
	if not spec or spec < 1 then
		rcn.talents = nil
		rcn.spec = 0
		rcn.specname = "UNKNOWN"
		rcn.specicon = "UNKNOWN"
	else
		rcn.spec = spec
		rcn.specname = rcn.tinfo.spec_name_localized or "UNKNOWN"
		rcn.specicon = rcn.tinfo.spec_icon or "UNKNOWN"
		rcn.talents = true
	end
end

function addon:UseDrumsKings(raid)
	if not profile.checkdrumskings then
		return false
	end
	if raid.ClassNumbers.DRUID > 0 or raid.ClassNumbers.MONK > 0 then -- these classes always bring stats
		return false
	end
	if raid.ClassNumbers.PALADIN > 1 then -- two pallies, can get might and kings
		return false
	end
	if raid.ClassNumbers.PALADIN == 1 and raid.ClassNumbers.SHAMAN > 0 then -- shaman brings might, pally should buff kings
		return false
	end
	return true
end


function addon:SetAllOptions(mode)
	local BF = addon.BF
	for buffcheck, _ in pairs(BF) do
		for _, defname in ipairs({"buff", "warning", "dash", "dashcombat", "boss", "trash"}) do
			if BF[buffcheck]["default" .. defname] then
				profile[buffcheck .. defname] = true
			else
				profile[buffcheck .. defname] = false
			end
		end
		local enable = false
		if mode == "justmybuffs" then
			if BF[buffcheck].class and BF[buffcheck].class[playerclass] then
				enable = true
				profile[buffcheck .. "dash"] = true
				profile[buffcheck .. "boss"] = true
				profile[buffcheck .. "trash"] = true
			end
		elseif mode == "raidleader" then
			if BF[buffcheck].default then
				enable = true
			end
		elseif mode == "coreraidbuffs" then
			if BF[buffcheck].core then
				enable = true
				profile[buffcheck .. "dash"] = true
--				profile[buffcheck .. "boss"] = true
--				profile[buffcheck .. "trash"] = true
			end
		end
		if enable then
			profile[BF[buffcheck].check] = true
		else
			profile[BF[buffcheck].check] = false
			profile[buffcheck .. "dash"] = false
		end
	end
	if mode == "justmybuffs" then
		profile.hidebossrtrash = true
		profile.RaidHealth = false
		profile.TankHealth = false
		profile.RaidMana = false
		profile.HealerMana = false
		profile.DPSMana = false
		profile.Alive = false
		profile.Dead = false
		profile.TanksAlive = false
		profile.HealersAlive = false
		profile.Range = false
	elseif mode == "raidleader" then
		profile.hidebossrtrash = profiledefaults.profile.hidebossrtrash
		profile.RaidHealth = profiledefaults.profile.RaidHealth
		profile.TankHealth = profiledefaults.profile.TankHealth
		profile.RaidMana = profiledefaults.profile.RaidMana
		profile.HealerMana = profiledefaults.profile.HealerMana
		profile.DPSMana = profiledefaults.profile.DPSMana
		profile.Alive = profiledefaults.profile.Alive
		profile.Dead = profiledefaults.profile.Dead
		profile.TanksAlive = profiledefaults.profile.TanksAlive
		profile.HealersAlive = profiledefaults.profile.HealersAlive
		profile.Range = profiledefaults.profile.Range
	elseif mode == "coreraidbuffs" then
		profile.hidebossrtrash = false
		profile.RaidHealth = false
		profile.TankHealth = false
		profile.RaidMana = false
		profile.HealerMana = false
		profile.DPSMana = false
		profile.Alive = false
		profile.Dead = false
		profile.TanksAlive = false
		profile.HealersAlive = false
		profile.Range = false
	end
	addon:AddBuffButtons()
	addon:UpdateButtons()
	addon:UpdateOptionsButtons()
end

function addon:PopUpWizard()
	StaticPopupDialogs["RBS_WIZARD"] = {
		text = L["This is the first time RaidBuffStatus has been activated since installation or settings were reset. Would you like to visit the Buff Wizard to help you get RBS buffs configured? If you are a raid leader then you can click No as the defaults are already set up for you."],
		button1 = L["Buff Wizard"],
		button2 = L["No"],
		button3 = L["Remind me later"],
		OnAccept = function()
			addon:OpenBlizzAddonOptions()
			profile.TellWizard = false
		end,
		OnCancel = function (_,reason)
			profile.TellWizard = false
		end,
		sound = "levelup2",
		timeout = 200,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3, -- reduce chance of taint
	}
	StaticPopup_Show("RBS_WIZARD")
end

function addon:OpenBlizzAddonOptions()
--	if addon.optionsframe:IsVisible() then
--		HideUIPanel(RBSOptionsFrame)
--	end
	InterfaceOptionsFrame_OpenToCategory("RaidBuffStatus")
end

function addon:GetMyZone()
  -- GetRealZoneText() is *usually* what we want here, but in some cases (eg Wyrmrest Summit in Dragon Soul)
  -- it will return different values that GetRaidRosterInfo which we use for raid members
  local myunit = addon:GetUnitFromName(playername)
  local zone = (myunit and myunit.zone) or GetRealZoneText()
  return zone 
end

function addon:InMyZone(whom)
	local thiszone = addon:GetMyZone()
	local unit = addon:GetUnitFromName(whom)
	if unit and unit.zone and thiszone == unit.zone then
		return true
	end
	return false
end

function addon:UnitNameRealm(unitid)
	local name, realm = UnitName(unitid)
	if realm and string.len(realm) > 0 then
		return (name .. "-" .. realm)
	end
	return name
end

function addon:LockSoulStone(lock)
	profile.cooldowns.soulstone[lock] = time() + (30 * 60) - 1
	addon:CleanLockSoulStone()
end

function addon:GetLockSoulStone(lock)
	return profile.cooldowns.soulstone[lock]
end

function addon:CleanLockSoulStone()
        if not profile.cooldowns then return end
	local timenow = time()
	for lock,t in pairs(profile.cooldowns.soulstone) do
		if timenow > t then
			profile.cooldowns.soulstone[lock] = nil
		end
	end
end

--function addon:GUIDToName(guid)
--	for class,_ in pairs(raid.classes) do
--		for name,rcn in pairs(raid.classes[class]) do
--			if guid == rcn.guid then
--				return name
--			end
--		end
--	end
--	return ""
--end

function addon:SendRezMessage(message)
	if not raid.isbattle and not incombat then
		addon:SendAddonMessage("CTRA", message)
		addon:Debug("sending rez message: " .. message)
	else
		addon:Debug("not sending rez message")
	end
end

function addon:UnitIsMounted(unitid)
  if not unitid then 
    return false
  elseif UnitInVehicle(unitid) then
    return true
  elseif UnitIsUnit(unitid, "player") then 
		return IsMounted()
  else -- hard case, WTB IsMounted for non-player
  	for b = 1, 32 do
      local buffName, buffRank, buffIcon, _, _, 
            duration, expirationTime, unitCaster,
            _, _, buffSpellId = UnitAura(unitid, b, "HELPFUL|CANCELABLE")
      if buffIcon then
        buffIcon = string.lower(buffIcon)
      end
      if not buffName then
        return false
      elseif buffSpellId == 13159 or buffSpellId == 5118 then -- aspect of the pack/cheetah
        -- skip
      elseif (expirationTime == 0 and duration == 0 and 
          (not unitCaster or (unitCaster and UnitIsUnit(unitid, unitCaster))) and
         ((buffIcon and string.find(buffIcon, "ability_mount_")) or -- most mounts
          (buffIcon and string.find(buffIcon, "misc_foot_centaur")) or -- talbuks
          (buffIcon and string.find(buffIcon, "pet_netherray")) or -- netherrays
          (buffIcon and string.find(buffIcon, "misc_key_")) or -- chopper/hog
          (buffIcon and string.find(buffIcon, "inv_misc_qirajicrystal")) or -- AQ mount
          (buffIcon and string.find(buffIcon, "deathknight_summondeathcharger")) or -- deathchargers
          (buffIcon and string.find(buffIcon, "inv_belt_12")) or -- headless horseman mnt (many spellIds)
          buffSpellId == 61996 or -- blue dragonhawk
          buffSpellId == 5784  or -- felsteed
          buffSpellId == 34769 or -- warhorse
          buffSpellId == 64731 or -- sea turtle
          buffSpellId == 63796 or -- mimiron's head
          buffSpellId == 43688 or -- amani war bear
          buffSpellId == 71342 or -- love rocket
          buffSpellId == 30174 or -- riding turtle
          buffSpellId == 41252 or -- raven lord
          buffSpellId == 47977    -- magic broom
         )) then -- looks mounted   
        -- SendChatMessage(UnitName(unitid).." is mounted on "..buffName.."   "..buffIcon,"PARTY")
  	    return true
      end
    end
  end
end

function addon:CHAT_MSG_BN_WHISPER(event, msg, sender,...)
  local pid = select(11,...)
  addon:CHAT_MSG_WHISPER(event, msg, pid)
end  
function addon:CanAutoInvite(whom)
	if addon:IsInBGQueue() then
		addon:Say(L["Sorry, I am queued for a battlefield."], whom, true)
		return false
	end
	local queued = nil
	for c,n in pairs(LFG_CATEGORY_NAMES) do
	  local party, isjoined, isqueued = GetLFGInfoServer(c)
	  if isjoined or isqueued then queued = n; break end
	end
	if queued then
		addon:Say(L["Sorry, I am queued for"].." "..queued, whom, true)
		return false
	end
	return true
end

function addon:FQname(name) -- make sure a toon name is fully qualified
	if not name then return nil end
	local nn, rn = name:match("^(.*)%s*-%s*([^-]*)$")
	if not rn or #rn == 0 then
		nn = name
		rn = GetRealmName()
	end
	rn = rn:gsub("%s","") 
	return nn.."-"..rn
end

local invstr = "%s*"..(L["invite"]):lower().."%s*"
function addon:CHAT_MSG_WHISPER(event, msg, whom)
	addon:Debug(":" .. msg .. ":" .. whom .. ":")
	if not msg:lower():match(invstr) or not whom then
		return
	end
	local fwhom = addon:FQname(tostring(whom)) -- might be a bnet pid
	if not addon:CanAutoInvite(whom) then return end
	if profile.aiwguildmembers and IsInGuild() then
		for i=1, GetNumGuildMembers() do
			local name = GetGuildRosterInfo(i)
			if addon:FQname(name) == fwhom then
				addon:SendInvite(whom)
				return
			end
		end
	end
	if profile.aiwfriends then
		for i=1, GetNumFriends() do
			local name = GetFriendInfo(i)
			if addon:FQname(name) == fwhom then
				addon:SendInvite(whom)
				return
			end
		end
	end
	if profile.aiwbnfriends and BNFeaturesEnabledAndConnected() then
		for i=1, BNGetNumFriends() do
		   local pID,pName,battletag,isBT,toonname,_,client,isOnline = BNGetFriendInfo(i)
		   if isOnline then
		     for j=1, BNGetNumFriendToons(i) do
			local _, toonName, client, realmName, realmId, faction = BNGetFriendToonInfo(i,j)
			if client == "WoW" and faction == UnitFactionGroup("player") then
				if fwhom == toonName.."-"..realmName:gsub("%s","") then -- regular wsp from local bnet friend
					addon:SendInvite(fwhom)
					return
				elseif whom == pID then -- CHAT_MSG_BN_WHISPER
  		                        FriendsFrame_BattlenetInvite(nil, pID)
					return
				end
			end
		     end
		   end
		end
	end
end

function addon:SendInvite(whom)
	if not ( UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or not (raid.isparty or raid.israid or raid.isbattle) ) then
		addon:Say(L["You need to whisper the leader instead: "] .. raid.leadername, whom, true)
		return
	end
	local isIn, instanceType = IsInInstance()
	if isIn and instanceType == "party" and raid.size == 5 then
		addon:Say(L["Sorry, the group is now full."], whom, true)
	elseif raid.isparty and raid.size == 5 then
		ConvertToRaid()
		addon:ScheduleTimer(function()
			addon:SendInvite(whom)
		end, 2)
	elseif raid.israid and raid.size == 40 then
			addon:Say(L["Sorry, the group is now full."], whom, true)
	else
		InviteUnit(whom)
	end
end

function addon:PARTY_INVITE_REQUEST(event, whom)
	if not whom then
		return
	end
	local fwhom = addon:FQname(whom)
	if profile.guildmembers and IsInGuild() then
		for i=1, GetNumGuildMembers() do
			local name = GetGuildRosterInfo(i)
			if addon:FQname(name) == fwhom then
	                        if not addon:CanAutoInvite(fwhom) then return end -- may send a whisper
				addon:Print((L["Invite auto-accepted from guild member %s."]):format(whom))
				addon:AcceptInvite()
				return
			end
		end
	end
	if profile.friends then
		for i=1, GetNumFriends() do
			local name = GetFriendInfo(i)
			if addon:FQname(name) == fwhom then
	                        if not addon:CanAutoInvite(whom) then return end -- may send a whisper
				addon:Print((L["Invite auto-accepted from friend %s."]):format(whom))
				addon:AcceptInvite()
				return
			end
		end
	end
	if profile.bnfriends and BNFeaturesEnabledAndConnected() then
		local myrealm = GetRealmName()
		for i=1, BNGetNumFriends() do
	  	   local pID,_,_,_,_,_,client,isOnline = BNGetFriendInfo(i)
		   if isOnline then
		     for j=1, BNGetNumFriendToons(i) do
		        local _, toonName, client, realmName, realmId, faction = BNGetFriendToonInfo(i,j)
			if client == "WoW" then
				--local _,name,_,realm = BNGetToonInfo(pID)
				if fwhom == toonName.."-"..realmName:gsub("%s","") then
	                                if not addon:CanAutoInvite(pID) then return end -- may send a whisper
					addon:Print((L["Invite auto-accepted from battle.net friend %s."]):format(fwhom))
					addon:AcceptInvite()
					return
				end
			end
		     end
		   end
		end
	end
end

function addon:AcceptInvite()
	for i=1, STATICPOPUP_NUMDIALOGS do
		local d = _G["StaticPopup"..i]
		if d:IsShown() and (d.which == "PARTY_INVITE" or d.which == "PARTY_INVITE_XREALM") then
		        _G["StaticPopup"..i.."Button1"]:Click()
			break
		end
	end
end

function addon:IsInRaid(whom)
	if addon:GetUnitFromName(whom) then
		--addon:Debug("Is in raid:" .. whom)
		return true
	end
	--addon:Debug("NOT in raid:" .. whom)
	return false
end

function addon:PrintOption(info, option)
	if type(option) == "number" or type(option) == "boolean" then
		addon:Print(info[2] .. ": " .. tostring(option))
	else
		addon:Print(info[2] .. ": " .. option)
	end
end


function addon:CleanSheep()
	for sheep,_ in pairs(currentsheep) do
		if (GetTime() - currentsheep[sheep]) > 35 then
			currentsheep[sheep] = nil
			currentsheepspell[sheep] = nil
		end
	end
end

function addon:deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function addon:SendDurability(event, sender)
	addon:Debug("SendDurability")
	if not raid.israid then
		return
	end
	local cur, max, broken, vmin = 0, 0, 0, 100
	for i = 1, 18 do
		local imin, imax = GetInventoryItemDurability(i)
		if imin and imax then
			vmin = math.min(math.floor(imin / imax * 100), vmin)
			if imin == 0 then broken = broken + 1 end
			cur = cur + imin
			max = max + imax
		end
	end
	if sender then
		addon:SendAddonMessage("CTRA", string.format("DUR %s %s %s %s", cur, max, broken, sender))
	else
		local perc = math.floor(cur / max * 100)
		addon:SendAddonMessage("oRA3", addon:Serialize("Durability", perc, vmin, broken))
	end
end

function addon:UpdateInventory(sender, itemname, numitems)
	for check, info in pairs(addon.itemcheck) do
		if itemname == info.item then
			info.results[sender] = tonumber(numitems)
			if (info.next or 0) - GetTime() < (info.frequencymissing - 15) then
				info.next = GetTime() + info.frequency
			end
			break
		end
	end
end

function addon:ItemQuery(check, name)
	local info = addon.itemcheck[check]
	if not info then return nil end
	return info.results[name] or info.results[name.."-"..GetRealmName()]
end

function addon:AddBars(currenty)
	if profile.TanksAlive then
		addon:CreateBar(currenty + 19, "TanksAlive", L["Tanks alive"], .3, .7, .7, 0.8, function() addon:BarTip(addon.bars.TanksAlive.barframe, L["Dead tanks"], report.tanksalivelist) end, function() addon:BarChat("TanksAlive", L["Tanks alive"]) end)
		currenty = currenty + 11
	end
	if profile.HealersAlive then
		addon:CreateBar(currenty + 19, "HealersAlive", L["Healers alive"], .9, .9, .9, 0.8, function() addon:BarTip(addon.bars.HealersAlive.barframe, L["Dead healers"], report.healersalivelist) end, function() addon:BarChat("HealersAlive", L["Healers alive"]) end)
		currenty = currenty + 11
	end
	if profile.Alive then
		addon:CreateBar(currenty + 19, "Alive", L["Alive"], .1, .2, .2, 0.8, function() addon:BarTip(addon.bars.Alive.barframe, L["I see dead people"], report.alivelist) end, function() addon:BarChat("Alive", L["Alive"]) end)
		currenty = currenty + 11
	end
	if profile.Dead then
		addon:CreateBar(currenty + 19, "Dead", L["Dead"], .1, .2, .2, 0.8, function() addon:BarTip(addon.bars.Dead.barframe, L["I see dead people"], report.alivelist) end, function() addon:BarChat("Dead", L["Dead"]) end)
		currenty = currenty + 11
	end
	if profile.DPSMana then
		addon:CreateBar(currenty + 19, "DPSMana", L["DPS mana"], RAID_CLASS_COLORS.WARLOCK.r, RAID_CLASS_COLORS.WARLOCK.g, RAID_CLASS_COLORS.WARLOCK.b, 0.8, function() addon:BarTip(addon.bars.DPSMana.barframe, L["DPS mana"] .. " %", report.dpsmanalist) end, function() addon:BarChat("DPSMana", L["DPS mana"]) end)
		currenty = currenty + 11
	end
	if profile.HealerMana then
		addon:CreateBar(currenty + 19, "HealerMana", L["Healer mana"], RAID_CLASS_COLORS.PALADIN.r, RAID_CLASS_COLORS.PALADIN.g, RAID_CLASS_COLORS.PALADIN.b, 0.8, function() addon:BarTip(addon.bars.HealerMana.barframe, L["Healer mana"] .. " %", report.healermanalist) end, function() addon:BarChat("HealerMana", L["Healer mana"]) end)
		currenty = currenty + 11
	end
	if profile.RaidMana then
		addon:CreateBar(currenty + 19, "RaidMana", L["Raid mana"], 0, 0, 1, 0.8, function() addon:BarTip(addon.bars.RaidMana.barframe, L["Raid mana"] .. " %", report.raidmanalist) end, function() addon:BarChat("RaidMana", L["Raid mana"]) end)
		currenty = currenty + 11
	end
	if profile.TankHealth then
		addon:CreateBar(currenty + 19, "TankHealth", L["Tank health"], RAID_CLASS_COLORS.WARRIOR.r, RAID_CLASS_COLORS.WARRIOR.g, RAID_CLASS_COLORS.WARRIOR.b, 0.8, function() addon:BarTip(addon.bars.TankHealth.barframe, L["Tank health"] .. " %", report.tankhealthlist) end, function() addon:BarChat("TankHealth", L["Tank health"]) end)
		currenty = currenty + 11
	end
	if profile.RaidHealth then
		addon:CreateBar(currenty + 19, "RaidHealth", L["Raid health"], 1, 0, 0, 0.8, function() addon:BarTip(addon.bars.RaidHealth.barframe, L["Raid health"], report.raidhealthlist) end, function() addon:BarChat("RaidHealth", L["Raid health"]) end)
		currenty = currenty + 11
	end
	if profile.Range then
		addon:CreateBar(currenty + 19, "Range", L["In range"], .5, .9, .5, 0.8, function() addon:BarTip(addon.bars.Range.barframe, L["Out of range"], report.rangelist) end, function() addon:BarChat("Range", L["In range"]) end)
		currenty = currenty + 11
	end
	return currenty
end

function addon:IsInBGQueue()
	for i = 1, GetMaxBattlefieldID() do
		local status = GetBattlefieldStatus(i)
		if status ~= "none" then
			return true
		end
	end
	return false
end
