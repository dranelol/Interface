---------------------------------------------------------------------------------------------------------------
--[[	Gup_MountData				 																		]]--
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--[[
	The Mounts are split in speeds/type by there spellid for less cpu power then extract it out of the tooltip.
	
	--GROUND--		--FLY--		--AQUATIC--		--SPECIAL--
	1 				10 			20 				30 
		
	21 = SeaLegs
	2  = Aq40
	
]]			
			 
if Gup_MountDataVersion == nil or Gup_MountDataVersion < 1.13  then
			 
Gup_MountDataVersion = 1.13 ;
Gup_MountData = {

-- GROUND MOUNTS ----------------------------------------------------------
[48778]={[1]=true},--Acherus Deathcharger
[98204]={[1]=true},--Amani Battle Bear
[43688]={[1]=true},--Amani War Bear
[16056]={[1]=true},--Ancient Frostsaber
[66906]={[1]=true},--Argent Charger
[67466]={[1]=true},--Argent Warhorse
[66907]={[1]=true},--Argent Warhorse
[60116]={[1]=true},--Armored Brown Bear
[60114]={[1]=true},--Armored Brown Bear
[96491]={[1]=true},--Armored Razzashi Raptor
[51412]={[1]=true},--Big Battle Bear
[58983]={[1]=true},--Big Blizzard Bear
[22719]={[1]=true},--Black Battlestrider
[35022]={[1]=true},--Black Hawkstrider
[16055]={[1]=true},--Black Nightsaber
[26656]={[1]=true},--Black Qiraji Battle Tank
[17461]={[1]=true},--Black Ram
[64977]={[1]=true},--Black Skeletal Horse
[470]={[1]=true},--Black Stallion
[60118]={[1]=true},--Black War Bear
[60119]={[1]=true},--Black War Bear
[48027]={[1]=true},--Black War Elekk
[22718]={[1]=true},--Black War Kodo
[59785]={[1]=true},--Black War Mammoth
[59788]={[1]=true},--Black War Mammoth
[22720]={[1]=true},--Black War Ram
[22721]={[1]=true},--Black War Raptor
[22717]={[1]=true},--Black War Steed
[22723]={[1]=true},--Black War Tiger
[22724]={[1]=true},--Black War Wolf
[64658]={[1]=true},--Black Wolf
[35020]={[1]=true},--Blue Hawkstrider
[10969]={[1]=true},--Blue Mechanostrider
[25953]={[1]=true,[2]=true},--Blue Qiraji Battle Tank
[17463]={[1]=true},--Blue Skeletal Horse
[64656]={[1]=true},--Blue Skeletal Warhorse
[50869]={[1]=true},--Brewfest Kodo
[43899]={[1]=true},--Brewfest Ram
[34406]={[1]=true},--Brown Elekk	
[458]={[1]=true},--Brown Horse
[18990]={[1]=true},--Brown Kodo
[6899]={[1]=true},--Brown Ram
[88748]={[1]=true},--Brown Riding Camel
[17464]={[1]=true},--Brown Skeletal Horse
[6654]={[1]=true},--Brown Wolf
[6648]={[1]=true},--Chestnut Mare
[39315]={[1]=true},--Cobalt Riding Talbuk
[34896]={[1]=true},--Cobalt War Talbuk
[73313]={[1]=true},--Crimson Deathcharger
[68188]={[1]=true},--Crusader's Black Warhorse
[68187]={[1]=true},--Crusader's White Warhorse
[39316]={[1]=true},--Dark Riding Talbuk
[34790]={[1]=true},--Dark War Talbuk
[103081]={[1]=true},--Darkmoon Dancing Bear
[63635]={[1]=true},--Darkspear Raptor
[63637]={[1]=true},--Darnassian Nightsaber
[6653]={[1]=true},--Dire Wolf
[23161]={[1]=true},--Dreadsteed
[8395]={[1]=true},--Emerald Raptor
[63639]={[1]=true},--Exodar Elekk
[5784]={[1]=true},--Felsteed
[36702]={[1]=true},--Fiery Warhorse
[101542]={[1]=true},--Flametalon of Alyzrazor
[63643]={[1]=true},--Forsaken Warhorse
[84751]={[1]=true},--Fossilized Raptor
[17460]={[1]=true},--Frost Ram
[23509]={[1]=true},--Frostwolf Howler
[63638]={[1]=true},--Gnomeregan Mechanostrider
[89520]={[1]=true},--Goblin Mini Hotrod
[87090]={[1]=true},--Goblin Trike 
[87091]={[1]=true},--Goblin Turbo-Trike 
[90621]={[1]=true},--Golden King
[61465]={[1]=true,[30]=true},--Grand Black War Mammoth
[61467]={[1]=true,[30]=true},--Grand Black War Mammoth
[61469]={[1]=true,[30]=true},--Grand Ice Mammoth
[61470]={[1]=true,[30]=true},--Grand Ice Mammoth
[35710]={[1]=true},--Gray Elekk
[18989]={[1]=true},--Gray Kodo
[6777]={[1]=true},--Gray Ram
[35713]={[1]=true},--Great Blue Elekk
[49379]={[1]=true},--Great Brewfest Kodo
[23249]={[1]=true},--Great Brown Kodo
[65641]={[1]=true},--Great Golden Kodo
[23248]={[1]=true},--Great Gray Kodo
[35712]={[1]=true},--Great Green Elekk
[35714]={[1]=true},--Great Purple Elekk
[65637]={[1]=true},--Great Red Elekk
[23247]={[1]=true},--Great White Kodo
[18991]={[1]=true},--Green Kodo
[17453]={[1]=true},--Green Mechanostrider
[26056]={[1]=true,[2]=true},--Green Qiraji Battle Tank
[17465]={[1]=true},--Green Skeletal Warhorse
[88750]={[1]=true},--Grey Riding Camel
[59797]={[1]=true},--Ice Mammoth
[59799]={[1]=true},--Ice Mammoth
[17459]={[1]=true},--Icy Blue Mechanostrider Mod A
[63636]={[1]=true},--Ironforge Ram
[17450]={[1]=true},--Ivory Raptor
[93644]={[1]=true},--Kor'kron Annihilator
[65917]={[1]=true},--Magic Rooster 
[55531]={[1]=true,[30]=true},--Mechano-hog
[60424]={[1]=true,[30]=true},--Mekgineer's Chopper		
[16084]={[1]=true},--Mottled Red Raptor
[103195]={[1]=true},--Mountain Horse
[66846]={[1]=true},--Ochre Skeletal Warhorse
[63640]={[1]=true},--Orgrimmar Wolf
[16082]={[1]=true},--Palomino
[472]={[1]=true},--Pinto
[35711]={[1]=true},--Purple Elekk
[35018]={[1]=true},--Purple Hawkstrider
[23246]={[1]=true},--Purple Skeletal Warhorse
[66090]={[1]=true},--Quel'dorei Steed
[41252]={[1]=true},--Raven Lord
[34795]={[1]=true},--Red Hawkstrider
[10873]={[1]=true},--Red Mechanostrider
[26054]={[1]=true,[2]=true},--Red Qiraji Battle Tank
[17462]={[1]=true},--Red Skeletal Horse
[22722]={[1]=true},--Red Skeletal Warhorse
[16080]={[1]=true},--Red Wolf
[17481]={[1]=true},--Rivendare's Deathcharger
[97581]={[1]=true},--Savage Raptor
[39317]={[1]=true},--Silver Riding Talbuk
[34898]={[1]=true},--Silver War Talbuk
[63642]={[1]=true},--Silvermoon Hawkstrider
[92231]={[1]=true},--Spectral Steed
[42776]={[1]=true},--Spectral Tiger
[92232]={[1]=true},--Spectral Wolf
[10789]={[1]=true},--Spotted Frostsaber
[23510]={[1]=true},--Stormpike Battle Charger
[63232]={[1]=true},--Stormwind Steed
[66847]={[1]=true},--Striped Dawnsaber
[8394]={[1]=true},--Striped Frostsaber
[10793]={[1]=true},--Striped Nightsaber
[23214]={[1]=true},--Summon Charger
[34767]={[1]=true},--Summon Charger
[73629]={[1]=true},--Summon Exarch's Elekk
[73630]={[1]=true},--Summon Great Exarch's Elekk
[69826]={[1]=true},--Summon Great Sunwalker Kodo
[69820]={[1]=true},--Summon Sunwalker Kodo
[34769]={[1]=true},--Summon Warhorse
[13819]={[1]=true},--Summon Warhorse
[66091]={[1]=true},--Sunreaver Hawkstrider
[68057]={[1]=true},--Swift Alliance Steed
[23241]={[1]=true},--Swift Blue Raptor
[43900]={[1]=true},--Swift Brewfest Ram	
[23238]={[1]=true},--Swift Brown Ram
[23229]={[1]=true},--Swift Brown Steed
[23250]={[1]=true},--Swift Brown Wolf
[65646]={[1]=true},--Swift Burgundy Wolf
[102346]={[1]=true},--Swift Forest Strider
[23221]={[1]=true},--Swift Frostsaber
[23239]={[1]=true},--Swift Gray Ram
[65640]={[1]=true},--Swift Gray Steed
[23252]={[1]=true},--Swift Gray Wolf	
[35025]={[1]=true},--Swift Green Hawkstrider
[23225]={[1]=true},--Swift Green Mechanostrider
[68056]={[1]=true},--Swift Horde Wolf
[102350]={[1]=true},--Swift Lovebird
[23219]={[1]=true},--Swift Mistsaber
[65638]={[1]=true},--Swift Moonsaber
[103196]={[1]=true},--Swift Mountain Horse
[23242]={[1]=true},--Swift Olive Raptor
[23243]={[1]=true},--Swift Orange Raptor
[23227]={[1]=true},--Swift Palomino
[33660]={[1]=true},--Swift Pink Hawkstrider
[35027]={[1]=true},--Swift Purple Hawkstrider
[65644]={[1]=true},--Swift Purple Raptor
[24242]={[1]=true},--Swift Razzashi Raptor	
[65639]={[1]=true},--Swift Red Hawkstrider
[101573]={[1]=true},--Swift Shorestrider
[42777]={[1]=true},--Swift Spectral Tiger
[102349]={[1]=true},--Swift Springstrider
[23338]={[1]=true},--Swift Stormsaber
[23251]={[1]=true},--Swift Timber Wolf
[65643]={[1]=true},--Swift Violet Ram
[35028]={[1]=true},--Swift Warstrider
[46628]={[1]=true},--Swift White Hawkstrider
[23223]={[1]=true},--Swift White Mechanostrider
[23240]={[1]=true},--Swift White Ram
[23228]={[1]=true},--Swift White Steed
[23222]={[1]=true},--Swift Yellow Mechanostrider
[49322]={[1]=true},--Swift Zhevra
[96499]={[1]=true},--Swift Zulian Panther
[24252]={[1]=true},--Swift Zulian Tiger
[88749]={[1]=true},--Tan Riding Camel
[39318]={[1]=true},--Tan Riding Talbuk
[34899]={[1]=true},--Tan War Talbuk
[18992]={[1]=true},--Teal Kodo
[63641]={[1]=true},--Thunder Bluff Kodo
[580]={[1]=true},--Timber Wolf
[61425]={[1]=true,[30]=true},--Traveler's Tundra Mammoth
[61447]={[1]=true,[30]=true},--Traveler's Tundra Mammoth
[65642]={[1]=true},--Turbostrider
[10796]={[1]=true},--Turquoise Raptor
[92155]={[1]=true},--Ultramarine Qiraji Battle Tank
[17454]={[1]=true},--Unpainted Mechanostrider
[64659]={[1]=true},--Venomhide Ravasaur
[100332]={[1]=true},--Vicious War Steed
[100333]={[1]=true},--Vicious War Wolf
[10799]={[1]=true},--Violet Raptor
[64657]={[1]=true},--White Kodo 
[15779]={[1]=true},--White Mechanostrider Mod B
[54753]={[1]=true},--White Polar Bear
[6898]={[1]=true},--White Ram
[39319]={[1]=true},--White Riding Talbuk
[65645]={[1]=true},--White Skeletal Warhorse
[16083]={[1]=true},--White Stallion
[34897]={[1]=true},--White War Talbuk
[16081]={[1]=true},--Winter Wolf
[17229]={[1]=true},--Winterspring Frostsaber
[59791]={[1]=true},--Wooly Mammoth
[59793]={[1]=true},--Wooly Mammoth
[74918]={[1]=true},--Wooly White Rhino
[26055]={[1]=true,[2]=true},--Yellow Qiraji Battle Tank
-- Not listed in Wowhead under mounts --
[15781]={[1]=true},--Steel Mechanostrider
[17455]={[1]=true},--Purple Mechanostrider
[17456]={[1]=true},--Red and Blue Mechanostrider
[17458]={[1]=true},--Fluorescent Green Mechanostrider
[16058]={[1]=true},--Primal Leopard
[16059]={[1]=true},--Tawny Sabercat
[16060]={[1]=true},--Golden Sabercat
[18363]={[1]=true},--Riding Kodo
[49378]={[1]=true},--Brewfest Riding Kodo
[23220]={[1]=true},--Swift Dawnsaber
[34407]={[1]=true},--Great Elite Elekk
[47037]={[1]=true},--Swift War Elekk
[59572]={[1]=true},--Black Polar Bear
[59573]={[1]=true},--Brown Polar Bear
[63234]={[1]=true},--Trusty Stormwind Charger
[60136]={[1]=true,[30]=true},--Grand Caravan Mammoth
[60140]={[1]=true,[30]=true},--Grand Caravan Mammoth
[61466]={[1]=true,[30]=true},--Grand Black War Mammoth
-- FLYING MOUNTS ----------------------------------------------------------
[60025]={[10]=true},--Albino Drake
[96503]={[10]=true},--Amani Dragonhawk
[63844]={[10]=true},--Argent Hippogryph
[61230]={[10]=true},--Armored Blue Wind Rider
[61229]={[10]=true},--Armored Snowy Gryphon
[40192]={[10]=true},--Ashes of Al'ar
[59567]={[10]=true},--Azure Drake
[41514]={[10]=true},--Azure Netherwing Drake
[71342]={[1]=true,[10]=true},--Big Love Rocket
[59650]={[10]=true},--Black Drake
[59976]={[10]=true},--Black Proto-Drake
[74856]={[10]=true},--Blazing Hippogryph
[72808]={[10]=true},--Bloodbathed Frostbrood Vanquisher
[61996]={[10]=true},--Blue Dragonhawk
[59568]={[10]=true},--Blue Drake
[59996]={[10]=true},--Blue Proto-Drake
[39803]={[10]=true},--Blue Riding Nether Ray
[32244]={[10]=true},--Blue Wind Rider
[59569]={[10]=true},--Bronze Drake
[58615]={[10]=true},--Brutal Nether Drake
[75614]={[1]=true,[10]=true},--Celestial Steed
[43927]={[10]=true},--Cenarion War Hippogryph
[41515]={[10]=true},--Cobalt Netherwing Drake
[97560]={[10]=true},--Corrupted Fire Hawk
[88990]={[10]=true},--Dark Phoenix <-- Flying Guild Mount
[64927]={[1]=true,[10]=true},--Deadly Gladiator's Frost Wyrm
[88335]={[10]=true},--Drake of the East Wind
[88742]={[10]=true},--Drake of the North Wind
[88744]={[10]=true},--Drake of the South Wind
[88741]={[10]=true},--Drake of the West Wind
[32239]={[10]=true},--Ebon Gryphon
[110039]={[10]=true},--Experiment 12-B
[97359]={[1]=true,[10]=true},--Flameward Hippogryph
[61451]={[10]=true},--Flying Carpet
[44153]={[1]=true,[10]=true},--Flying Machine
[75596]={[1]=true,[10]=true},--Frosty Flying Carpet
[65439]={[10]=true},--Furious Gladiator's Frost Wyrm
[32235]={[10]=true},--Golden Gryphon
[97501]={[10]=true},--Green Fire Hawk
[61294]={[10]=true},--Green Proto-Drake
[39798]={[10]=true},--Green Riding Nether Ray
[32245]={[10]=true},--Green Wind Rider
[48025]={[1]=true,[10]=true},--Headless Horseman's Mount	
[110051]={[10]=true},--Heart of the Aspects
[72807]={[10]=true},--Icebound Frostbrood Vanquisher
[72286]={[1]=true,[10]=true},--Invincible
[63956]={[10]=true},--Ironbound Proto-Drake
[107845]={[10]=true},--Life-Binder's Handmaiden
[61309]={[1]=true,[10]=true},--Magnificent Flying Carpet
[44744]={[10]=true},--Merciless Nether Drake
[63796]={[10]=true},--Mimiron's Head
[93623]={[10]=true},--Mottled Drake
[41513]={[10]=true},--Onyx Netherwing Drake
[69395]={[10]=true},--Onyxian Drake
[32345]={[10]=true},--Peep the Phoenix Mount
[88718]={[10]=true},--Phosphorescent Stone Drake
[60021]={[10]=true},--Plagued Proto-Drake
[97493]={[10]=true},--Pureblood Fire Hawk
[41516]={[10]=true},--Purple Netherwing Drake
[39801]={[10]=true},--Purple Riding Nether Ray
[121820]={[1]=true,[10]=true,[30]=true},--Obsidian Nightwing
[61997]={[10]=true},--Red Dragonhawk
[59570]={[10]=true},--Red Drake
[59961]={[10]=true},--Red Proto-Drake
[39800]={[10]=true},--Red Riding Nether Ray
[67336]={[10]=true},--Relentless Gladiator's Frost Wyrm
[63963]={[10]=true},--Rusted Proto-Drake
[101821]={[10]=true},--Ruthless Gladiator's Twilight Drake
[93326]={[10]=true,[30]= true},--Sandstone Drake
[66087]={[10]=true},--Silver Covenant Hippogryph
[39802]={[10]=true},--Silver Riding Nether Ray
[107516]={[10]=true},--Spectral Gryphon
[107517]={[10]=true},--Spectral Wind Rider
[32240]={[10]=true},--Snowy Gryphon
[66088]={[10]=true},--Sunreaver Dragonhawk
[32242]={[10]=true},--Swift Blue Gryphon
[32290]={[10]=true},--Swift Green Gryphon
[32295]={[10]=true},--Swift Green Wind Rider
[37015]={[10]=true},--Swift Nether Drake
[32292]={[10]=true},--Swift Purple Gryphon
[32297]={[10]=true},--Swift Purple Wind Rider
[32289]={[10]=true},--Swift Red Gryphon
[32246]={[10]=true},--Swift Red Wind Rider
[32296]={[10]=true},--Swift Yellow Wind Rider
[32243]={[10]=true},--Tawny Wind Rider
[60002]={[10]=true},--Time-Lost Proto-Drake
[44151]={[1]=true,[10]=true},--Turbo-Charged Flying Machine
[59571]={[10]=true},--Twilight Drake
[107844]={[10]=true},--Twilight Harbinger
[107203]={[1]=true,[10]=true},--Tyrael's Charger
[49193]={[10]=true},--Vengeful Nether Drake
[41517]={[10]=true},--Veridian Netherwing Drake
[101282]={[10]=true},--Vicious Gladiator's Twilight Drake
[41518]={[10]=true},--Violet Netherwing Drake
[60024]={[10]=true},--Violet Proto-Drake
[88746]={[10]=true},--Vitreous Stone Drake
[88331]={[10]=true},--Volcanic Stone Drake
[98727]={[1]=true,[10]=true},--Winged Guardian
[54729]={[10]=true},--Winged Steed of the Ebon Blade
[71810]={[10]=true},--Wrathful Gladiator's Frost Wyrm
[46197]={[1]=true,[10]=true},--X-51 Nether-Rocket
[46199]={[1]=true,[10]=true},--X-51 Nether-Rocket X-TREME
[75973]={[1]=true,[10]=true,[30]= true},--X-53 Touring Rocket
-- Not listed in Wowhead under mounts --
[62048]={[10]=true},--Black Dragonhawk Mount
[43810]={[10]=true},--Frost Wyrm
[51960]={[10]=true},--Frostwyrm Mount
[44221]={[10]=true},--Loaned Gryphon Reins
[44229]={[10]=true},--Loaned Wind Rider Reins
[44317]={[10]=true},--Merciless Nether Drake
[3363]={[10]=true}, --Nether Drake
[28828]={[10]=true},--Nether Drake
[61442]={[10]=true},--Swift Mooncloth Carpet
[61444]={[10]=true},--Swift Shadoweave Carpet
[55164]={[10]=true},--Swift Spectral Gryphon
[61446]={[10]=true},--Swift Spellfire Carpet	
-- AQUATIC MOUNTS ---------------------------------------------------------
[75207]={[20]=true,[21]=true},--Abyssal Manta
[30174]={[20]=true},--Riding Turtle
[64731]={[20]=true},--Sea Turtle
[98718]={[20]=true},--Subdued Seahorse
---------------------------------------------------------------------------	
	
}	;

end



