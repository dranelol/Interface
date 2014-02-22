--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.
--]]

local addonName, addonTable = ...;

MAPNOTES_VERSION = "6.09.50001";
MAPNOTES_EDITION = "Mists of Pandaria";

--[[
  Examine a stack trace to get the path to the MapNotes addon. The path is
  everything up to and including the first backslash, while the addon's name is
  the name of the containing directory - i.e. whatever is between the last two
  backslashes. I see no reason why the path should ever be anything other than
  'Interface\AddOns\MapNotes\'
--]]

MAPNOTES_PATH = debugstack():match('.+\\');
-- MAPNOTES_NAME = MAPNOTES_PATH:match('.*\\(.*)\\');
MAPNOTES_NAME = addonName;
MAPNOTES_DISPLAY = format('%s (%s)', MAPNOTES_NAME, MAPNOTES_EDITION);

-- Anchor Points
CENTER      = 'CENTER';
TOP         = 'TOP';
BOTTOM      = 'BOTTOM';
LEFT        = 'LEFT';
RIGHT       = 'RIGHT';
TOPLEFT     = 'TOPLEFT';
TOPRIGHT    = 'TOPRIGHT';
BOTTOMLEFT  = 'BOTTOMLEFT';
BOTTOMRIGHT = 'BOTTOMRIGHT';

MN_DEFAULT_FRAMESCALE = 75;
MN_DEFAULT_ICONSIZE = 16;
MN_DEFAULT_ICONALPHA = 100;

-- Commands
MAPNOTES_MAPNOTES_COMMANDS =          { "/mapnote", "/mapnotes", "/mn" };
MAPNOTES_MNOPTIONS_COMMANDS =         { "/mnoptions", "/mnopt" };
MAPNOTES_ONENOTE_COMMANDS =           { "/onenote", "/allowonenote", "/aon", "/mn1" };
MAPNOTES_NEXTMININOTE_COMMANDS =      { "/nextmininote", "/nmn", "/mnmn" };
MAPNOTES_NEXTMININOTEONLY_COMMANDS =  { "/nextmininoteonly", "/nmno", "/mnmn1" };
MAPNOTES_MININOTEOFF_COMMANDS =       { "/mininoteoff", "/mno", "/mnmn0" };
MAPNOTES_MNTLOC_COMMANDS =            { "/mntloc" }
MAPNOTES_QUICKNOTE_COMMANDS =         { "/quicknote", "/qnote", "/mnq" };
MAPNOTES_QUICKTLOC_COMMANDS =         { "/quicktloc", "/qtloc", "/mnqtloc" };
MAPNOTES_MNSEARCH_COMMANDS =          { "/mnsearch", "/mns" };
MAPNOTES_MNHIGHLIGHT_COMMANDS =       { "/mnhighlight", "/mnhl" };
MAPNOTES_MNMINICOORDS_COMMANDS =      { "/mnminicoords", "/mnminic" };
MAPNOTES_MNMAPCOORDS_COMMANDS =       { "/mnmapcoords", "/mnmapc" };
MAPNOTES_MNTARGET_COMMANDS =          { "/mntarget", "/mnt" };
MAPNOTES_MNMERGE_COMMANDS =           { "/mnmerge", "/mnm" };
MAPNOTES_THOTTBOTLOC_COMMANDS =       { "/thottbotloc", "/tloc" };
-- Import Commands
MAPNOTES_IMPORT_METAMAP_COMMANDS =    { "/MapNotes_Import_MetaMap" };       --Telic_4
MAPNOTES_IMPORT_ALPHAMAP_COMMANDS =   { "/MapNotes_Import_AlphaMap" };       --Telic_4
MAPNOTES_IMPORT_ALPHAMAPBG_COMMANDS = { "/MapNotes_Import_AlphaMapBG" };     --Telic_4
MAPNOTES_IMPORT_CTMAP_COMMANDS =      { "/MapNotes_Import_CTMap" };       --Telic_4

MAPNOTES_DFLT_ICONSIZE = 18;
MAPNOTES_BORDER = 46;

MapNotes_Mininote_UpdateRate = 0.01;  -- Update rate required when a 'child' of Minimap, is less than 0.03 !!!
                    -- so moved the parent of the OnUpdate Function to the UI - buttons still
                    -- children of Minimap obviously
                    -- 5.60 - To provide for sufficient performance for Rotating Minimap support
                    -- this has been put back to a Minimap level OnUpdate, and a value of similar
                    -- magnitude to the original
MapNotes_WorldMap_UpdateRate = 0.02;
MapNotes_MinDiff = 7;
MAPNOTES_MAXLINES = 100;
MAPNOTES_TOGGLELINE_TIMEOUT = 2;

MN_COORD_FS = {
  [0] = '%.0f, %.0f',
  [1] = '%.1f, %.1f',
  [2] = '%.2f, %.2f',
  [3] = '%.3f, %.3f',
};
MN_COORD_F  = 1;

MAPNOTES_BASEKEYS = {
	DEFAULT = {
		miniData = {
			scale = 0.15,
			xOffset = 0.4,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Ironforge"] = {
		miniData = {
			scale = 0.02239988344354512,
			xOffset = 0.47481923366335,
			yOffset = 0.51289242617182,
		},
	},
	["WM Ogrimmar"] = {
		miniData = {
			scale = 0.03811449638057,
			xOffset = 0.56378554142668,
			yOffset = 0.42905218646258,
		},
	},
	["WM BlastedLands"] = {
		miniData = {
			scale = 0.1037141885823384,
			xOffset = 0.48982154167011,
			yOffset = 0.7684651998651,
		},
	},
	["WM AzuremystIsle"] = {
		miniData = {
			scale = 0.1097053339824185,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM TerokkarForest"] = {
		miniData = {
			scale = 0.1529165010506832,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM Ghostlands"] = {
		miniData = {
			scale = 0.09344898834353604,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM BladesEdgeMountains"] = {
		miniData = {
			scale = 0.1536244404791699,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM Barrens"] = {
		miniData = {
			scale = 0.1548394314301264,
			xOffset = 0.3924934733345,
			yOffset = 0.45601063260257,
		},
	},
	["WM Badlands"] = {
		miniData = {
			scale = 0.08692995123372375,
			xOffset = 0.51361415033147,
			yOffset = 0.56915717993261,
		},
	},
	["WM VashjirDepths"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1153953207257285,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Moonglade"] = {
		miniData = {
			scale = 0.06221364193414381,
			xOffset = 0.50130287793373,
			yOffset = 0.17560823085517,
		},
	},
	["WM ZulDrak"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1414123646748503,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM StormwindCity"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.04920229330756805,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM WesternPlaguelands"] = {
		miniData = {
			scale = 0.1217668410447157,
			xOffset = 0.44270955019641,
			yOffset = 0.17471356786018,
		},
	},
	["WM Felwood"] = {
		miniData = {
			scale = 0.1633581866761797,
			xOffset = 0.41995800144849,
			yOffset = 0.23097545880609,
		},
	},
	["WM HillsbradFoothills"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.137695644974883,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM IcecrownGlacier"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1775913971671411,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM HrothgarsLanding"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1041419301518098,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Nagrand"] = {
		miniData = {
			scale = 0.1564562335710108,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM Tirisfal"] = {
		miniData = {
			scale = 0.1279613738059787,
			xOffset = 0.36837217317549,
			yOffset = 0.15464954319582,
		},
	},
	["WM VashjirRuins"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1373416620816988,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Darnassus"] = {
		miniData = {
			scale = 0.04149914940890921,
			xOffset = 0.38392150175204,
			yOffset = 0.10441296545475,
		},
	},
	["WM StonetalonMountains"] = {
		miniData = {
			scale = 0.1589795206794401,
		},
	},
	["WM Desolace"] = {
		miniData = {
			scale = 0.1211573242884183,
		},
	},
	["WM GilneasCity"] = {
		miniData = {
			scale = 0.024897,
		},
	},
	["WM Gilneas"] = {
		miniData = {
			scale = 0.0880446,
		},
	},
	["WM Sunwell"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.09423067405312556,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Orgrimmar1"] = {
	  miniData = {
	    scale = 0.04686864977397699,
	  }
	},
	["WM Orgrimmar2"] = {
	  miniData = {
	    scale = 0.009756694725395565,
	  }
	},
	["WM SilvermoonCity"] = {
		miniData = {
			scale = 0.03428750768926585,
			xOffset = 0.56378554142668,
			yOffset = 0.42905218646258,
		},
	},
	["WM Westfall"] = {
		miniData = {
			scale = 0.0991125388714859,
			xOffset = 0.36884571674582,
			yOffset = 0.71874918595783,
		},
	},
	["WM Hinterlands"] = {
		miniData = {
			scale = 0.1090238023511751,
			xOffset = 0.49929119700867,
			yOffset = 0.25567971676068,
		},
	},
	["WM Wetlands"] = {
		miniData = {
			scale = 0.1170914460213157,
			xOffset = 0.46561438951659,
			yOffset = 0.40971063365152,
		},
	},
	["WM TheLostIsles"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1278581315090868,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Winterspring"] = {
		miniData = {
			scale = 0.1657159454027054,
			xOffset = 0.47237382938446,
			yOffset = 0.17390990272233,
		},
	},
	["WM WarsongGulch"] = {
		miniData = {
			scale = 0.03246232389497016,
			xOffset = 0.41757282062541,
			yOffset = 0.33126468682991,
		},
	},
	["WM SearingGorge"] = {
		miniData = {
			scale = 0.0631842370599279,
			xOffset = 0.46372051266487,
			yOffset = 0.5781237938250901,
		},
	},
	["WM ThousandNeedles"] = {
		miniData = {
			scale = 0.1185609920754555,
			xOffset = 0.47554411191734,
			yOffset = 0.6834235638965001,
		},
	},
	["WM Deepholm"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1444211376006921,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Ashenvale"] = {
		miniData = {
			scale = 0.1553727276283544,
			xOffset = 0.41757282062541,
			yOffset = 0.33126468682991,
		},
	},
	["WM Silverpine"] = {
		miniData = {
			scale = 0.1189350520037788,
			xOffset = 0.3565350229009,
			yOffset = 0.24715695496522,
		},
	},
	["WM Mulgore"] = {
		miniData = {
			scale = 0.1468539644007323,
			xOffset = 0.40811854919226,
			yOffset = 0.53286226907346,
		},
	},
	["WM ThunderBluff"] = {
		miniData = {
			scale = 0.02812455482029047,
			xOffset = 0.44972878210917,
			yOffset = 0.55638479002362,
		},
	},
	["WM BoreanTundra"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1632554680236128,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Aszhara"] = {
		miniData = {
			scale = 0.1486082478882055,
			xOffset = 0.5528203691804901,
			yOffset = 0.30400571307545,
		},
	},
	["WM Alterac"] = {
		miniData = {
			scale = 0.07954563533736,
			xOffset = 0.43229874660542,
			yOffset = 0.25425926375262,
		},
	},
	["WM TolBarad"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.05706343275149997,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Teldrassil"] = {
		miniData = {
			scale = 0.1583058777959551,
			xOffset = 0.36011098024729,
			yOffset = 0.0394832297921,
		},
	},
	["WM Hellfire"] = {
		miniData = {
			scale = 0.1462647453671818,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM TheStormPeaks"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.2014108382265377,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Durotar"] = {
		miniData = {
			scale = 0.142475288536189,
			xOffset = 0.5170978270910001,
			yOffset = 0.44802818134926,
		},
	},
	["WM RuinsofGilneasCity"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.02520584687804419,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM DeadwindPass"] = {
		miniData = {
			scale = 0.07079468346192604,
			xOffset = 0.47822105868635,
			yOffset = 0.7386355504851601,
		},
	},
	["WM Stormwind"] = {
		miniData = {
			scale = 0.03819701270887,
			xOffset = 0.41531450060561,
			yOffset = 0.67097280492581,
		},
	},
	["WM DunMorogh"] = {
		miniData = {
			scale = 0.1386838132701996,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM Uldum"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1668948140758477,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM TheMaelstrom"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.04389269826741177,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM AlteracValley"] = {
		miniData = {
			scale = 0.1199969636306089,
			xOffset = 0.41757282062541,
			yOffset = 0.33126468682991,
		},
	},
	["WM LakeWintergrasp"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.0842456626641948,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Arathi"] = {
		miniData = {
			scale = 0.09847834056199707,
			xOffset = 0.47916793249546,
			yOffset = 0.32386170078419,
		},
	},
	["WM StranglethornVale"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1855557940810365,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Dragonblight"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1588308058517587,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM NetherstormArena"] = {
		miniData = {
			scale = 0.0643199354850591,
			xOffset = 0.47916793249546,
			yOffset = 0.32386170078419,
		},
	},
	["WM StrandoftheAncients"] = {
		miniData = {
			scale = 0.04937928027421441,
			xOffset = 0.47916793249546,
			yOffset = 0.32386170078419,
		},
	},
	["WM StranglethornJungle"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1161032623146971,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM LochModan"] = {
		miniData = {
			scale = 0.07812486511738646,
			xOffset = 0.51118749188138,
			yOffset = 0.50940913489577,
		},
	},
	["WM AhnQirajTheFallenKingdom"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1091300116478518,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Stranglethorn"] = {
		miniData = {
			scale = 0.18128603034401,
			xOffset = 0.39145470225916,
			yOffset = 0.79412224886668,
		},
	},
	["WM ShadowmoonValley"] = {
		miniData = {
			scale = 0.1557482842583184,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM EasternPlaguelands"] = {
		miniData = {
			scale = 0.1141564147352012,
			xOffset = 0.51663255550387,
			yOffset = 0.15624753972085,
		},
	},
	["WM Duskwood"] = {
		miniData = {
			scale = 0.07645825074138987,
			xOffset = 0.43087243362495,
			yOffset = 0.73224350550454,
		},
	},
	["WM Tanaris"] = {
		miniData = {
			scale = 0.1943457215413046,
			xOffset = 0.46971301480866,
			yOffset = 0.76120931364891,
		},
	},
	["WM ScarletEnclave"] = {
		miniData = {
			scale = 0.08955519634455611,
			xOffset = 0.47916793249546,
			yOffset = 0.32386170078419,
		},
	},
	["WM Dustwallow"] = {
		miniData = {
			scale = 0.1414648287337048,
			xOffset = 0.49026338351379,
			yOffset = 0.60461876174686,
		},
	},
	["WM Silithus"] = {
		miniData = {
			scale = 0.1093685836090158,
			xOffset = 0.33763582469211,
			yOffset = 0.7581522495192899,
		},
	},
	["WM SholazarBasin"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1233597219346433,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM HowlingFjord"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1712198662388139,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM TheCapeOfStranglethorn"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1117523442196874,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM EversongWoods"] = {
		miniData = {
			scale = 0.1394654973704639,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM BloodmystIsle"] = {
		miniData = {
			scale = 0.08791027456648698,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM Feralas"] = {
		miniData = {
			scale = 0.1872724831369132,
			xOffset = 0.31589651244686,
			yOffset = 0.61820581746798,
		},
	},
	["WM ArathiBasin"] = {
		miniData = {
			scale = 0.04973325897087805,
			xOffset = 0.41757282062541,
			yOffset = 0.33126468682991,
		},
	},
	["WM Netherstorm"] = {
		miniData = {
			scale = 0.1578721277133948,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM TheExodar"] = {
		miniData = {
			scale = 0.02847891594500644,
			xOffset = 0.56378554142668,
			yOffset = 0.42905218646258,
		},
	},
	["WM Redridge"] = {
		miniData = {
			scale = 0.07274152931303674,
			xOffset = 0.49917278340928,
			yOffset = 0.68359285304999,
		},
	},
	["WM Darkshore"] = {
		miniData = {
			scale = 0.1742066306861243,
			xOffset = 0.38383175154516,
			yOffset = 0.18206216123156,
		},
	},
	["WM Vashjir"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1967059471649653,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Hilsbrad"] = {
		miniData = {
			scale = 0.09090931690055,
			xOffset = 0.4242436124746,
			yOffset = 0.30113436864162,
		},
	},
	["WM UngoroCrater"] = {
		miniData = {
			scale = 0.09969901929665205,
			xOffset = 0.4492759445152,
			yOffset = 0.7649457362940501,
		},
	},
	["WM Hyjal_terrain1"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1144209056856183,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM SouthernBarrens"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1997348709307465,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM VashjirKelpForest"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.07936378236157161,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Zangarmarsh"] = {
		miniData = {
			scale = 0.1423710458675096,
			xOffset = 0.40335096278072,
			yOffset = 0.48339696712179,
		},
	},
	["WM BurningSteppes"] = {
		miniData = {
			scale = 0.08923077405690838,
			xOffset = 0.04621224670174,
			yOffset = 0.61780780524905,
		},
	},
	["WM Dalaran1"] = {
		miniData = {
			scale = 0.02350420605953961,
			xOffset = 0.4297399924566,
			yOffset = 0.23815358517831,
		},
	},
	["WM Dalaran2"] = {
		miniData = {
			scale = 0.015949427667576,
			xOffset = 0.4297399924566,
			yOffset = 0.23815358517831,
		},
	},
	["WM SwampOfSorrows"] = {
		miniData = {
			scale = 0.07104540933294659,
			xOffset = 0.5176979527207,
			yOffset = 0.7281597470161501,
		},
	},
	["WM TolBaradDailyArea"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.05203407444725473,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM RuinsofGilneas"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.08909804936079759,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM TwilightHighlands"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1492735148516716,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM GrizzlyHills"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.1486688182454466,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Undercity"] = {
		miniData = {
			scale = 0.02717851644280123,
			xOffset = 0.4297399924566,
			yOffset = 0.23815358517831,
		},
	},
	["WM Elwynn"] = {
		miniData = {
			scale = 0.09830135019420898,
			xOffset = 0.41092682316676,
			yOffset = 0.65651531970162,
		},
	},
	["WM CrystalsongForest"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.07709244502234915,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM Kezan"] = {
		miniData = {
			xOffset = 0.4,
			scale = 0.03825862057691693,
			cont = 2,
			yOffset = 0.4,
		},
	},
	["WM ShattrathCity"] = {
		miniData = {
			scale = 0.03699021981226409,
			xOffset = 0.56378554142668,
			yOffset = 0.42905218646258,
		},
	},
};

--[[

	diameter of the Minimap in game yards at the various possible zoom levels

  These figures were taken from the Astrolabe addon. They are the yards
--]]
MinimapSize = {
	indoor = {
		[0] = 300, -- scale
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
};

--[[

  These are the original minimap scale values
  Erroneously there was a different scale per continent
--]]
MapNotes_IndoorsScale = {
  [0] = 1.565,
  [1] = 1.687,
  [2] = 1.882,
  [3] = 2.210,
  [4] = 2.575,
  [5] = 2.651,
};

MapNotes_MiniConst = {
  [1] = {   -- Kalimdor
    [0] = { xScale = 11016.6, yScale =  7399.9 },
    [1] = { xScale = 12897.3, yScale =  8638.1 },
    [2] = { xScale = 15478.8, yScale = 10368.0 },
    [3] = { xScale = 19321.8, yScale = 12992.7 },
    [4] = { xScale = 25650.4, yScale = 17253.2 },
    [5] = { xScale = 38787.7, yScale = 26032.1 },
  },
  [2] = {   -- Eastern Kingdoms
    [0] = { xScale = 10448.3, yScale =  7072.7 },
    [1] = { xScale = 12160.5, yScale =  8197.8 },
    [2] = { xScale = 14703.1, yScale =  9825.0 },
    [3] = { xScale = 18568.7, yScale = 12472.2 },
    [4] = { xScale = 24390.3, yScale = 15628.5 },
    [5] = { xScale = 37012.2, yScale = 25130.6 },
  },
  [3] = {   -- Outland
    [0] = { xScale = 10448.3, yScale =  7072.7 },
    [1] = { xScale = 12160.5, yScale =  8197.8 },
    [2] = { xScale = 14703.1, yScale =  9825.0 },
    [3] = { xScale = 18568.7, yScale = 12472.2 },
    [4] = { xScale = 24390.3, yScale = 15628.5 },
    [5] = { xScale = 37012.2, yScale = 25130.6 },
  },
  [4] = {   -- Northrend
    [0] = { xScale = 10448.3, yScale =  7072.7 },
    [1] = { xScale = 12160.5, yScale =  8197.8 },
    [2] = { xScale = 14703.1, yScale =  9825.0 },
    [3] = { xScale = 18568.7, yScale = 12472.2 },
    [4] = { xScale = 24390.3, yScale = 15628.5 },
    [5] = { xScale = 37012.2, yScale = 25130.6 },
  },
  [5] = {   -- The Maelstrom
    [0] = { xScale = 10448.3, yScale =  7072.7 },
    [1] = { xScale = 12160.5, yScale =  8197.8 },
    [2] = { xScale = 14703.1, yScale =  9825.0 },
    [3] = { xScale = 18568.7, yScale = 12472.2 },
    [4] = { xScale = 24390.3, yScale = 15628.5 },
    [5] = { xScale = 37012.2, yScale = 25130.6 },
  },
};

MN_MINIMAP_STYLES = {
   [1] =  "SQUARE",
   [2] =  "CORNER-TOPRIGHT",
   [3] =  "CORNER-BOTTOMRIGHT",
   [4] =  "CORNER-BOTTOMLEFT",
   [5] =  "CORNER-TOPLEFT",
   [6] =  "SIDE-RIGHT",
   [7] =  "SIDE-BOTTOM",
   [8] =  "SIDE-LEFT",
   [9] =  "SIDE-TOP",
  [10] =  "TRICORNER-TOPRIGHT",
  [11] =  "TRICORNER-BOTTOMRIGHT",
  [12] =  "TRICORNER-BOTTOMLEFT",
  [13] =  "TRICORNER-TOPLEFT",
  [14] =  "CIRCULAR",
};

MN_AUTO_MINIMAPS = {
  SQUARE          = { true, true, true, true },

  ["CORNER-TOPRIGHT"]     = { false, true, true, true },
  ["CORNER-BOTTOMRIGHT"]    = { true, false, true, true },
  ["CORNER-BOTTOMLEFT"]   = { true, true, true, false },
  ["CORNER-TOPLEFT"]      = { true, true, false, true },

  ["SIDE-RIGHT"]        = { false, false, true, true },
  ["SIDE-BOTTOM"]       = { true, false, true, false },
  ["SIDE-LEFT"]       = { true, true, false, false },
  ["SIDE-TOP"]        = { false, true, false, true },

  ["TRICORNER-TOPRIGHT"]    = { true, false, false, false },
  ["TRICORNER-BOTTOMRIGHT"] = { false, true, false, false },
  ["TRICORNER-BOTTOMLEFT"]  = { false, false, false, true },
  ["TRICORNER-TOPLEFT"]   = { false, false, true, false },

  CIRCULAR       = { false, false, false, false },
};


