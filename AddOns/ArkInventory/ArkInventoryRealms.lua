local portal = GetCVar( "Portal" )

local ConnectedRealms

if portal == "US" then
	ArkInventory.Output( "Loading US Connected Realm Data" )
	ConnectedRealms = {
		{ ["Aegwynn"]=true, ["Bonechewer"]=true, ["Daggerspine"]=true, ["Gurubashi"]=true, ["Hakkar"]=true },
		{ ["Agamaggan"]=true, ["Archimonde"]=true, ["Jaedenar"]=true, ["The Underbog"]=true },
		{ ["Aggramar"]=true, ["Fizzcrank"]=true },
		{ ["Akama"]=true, ["Dragonmaw"]=true, ["Mug'thol"]=true },
		{ ["Alleria"]=true, ["Khadgar"]=true },
		{ ["Alexstrasza"]=true, ["Terokkar"]=true },
		{ ["Altar of Storms"]=true, ["Anetheron"]=true, ["Magtheridon"]=true, ["Ysondre"]=true },
		{ ["Alterac Mountains"]=true, ["Balnazzar"]=true, ["Gorgonnash"]=true, ["The Forgotten Coast"]=true, ["Warsong"]=true },
		{ ["Andorhal"]=true, ["Scilla"]=true, ["Ursin"]=true, ["Zuluhed"]=true },
		{ ["Antonidas"]=true, ["Uldum"]=true },
		{ ["Anub'arak"]=true, ["Chromaggus"]=true, ["Chrushridge"]=true, ["Garithos"]=true, ["Nathrezim"]=true, ["Smolderthorn"]=true },
		{ ["Anvilmar"]=true, ["Undermine"]=true },
		{ ["Arygos"]=true, ["Llane"]=true },
		{ ["Auchindoun"]=true, ["Cho'gall"]=true, ["Laughing Skull"]=true },
		{ ["Azgalor"]=true, ["Azshara"]=true, ["Destromath"]=true, ["Thunderlord"]=true },
		{ ["Azjol-Nerub"]=true, ["Khaz Modan"]=true },
		{ ["Azuremyst"]=true, ["Staghelm"]=true },
		{ ["Black Dragonflight"]=true, ["Gul'dan"]=true, ["Skullcrusher"]=true },
		{ ["Blackhand"]=true, ["Galakrond"]=true },
		{ ["Blackwater Raiders"]=true, ["Shadow Council"]=true },
		{ ["Blackwing Lair"]=true, ["Dethecus"]=true, ["Detheroc"]=true, ["Lethon"]=true, ["Haomarush"]=true },
		{ ["Bladefist"]=true, ["Kul Tiras"]=true },
		{ ["Blade's Edge"]=true, ["Thunderhorn"]=true },
		{ ["Blood Furnace"]=true, ["Mannaroth"]=true, ["Nazjatar"]=true },
		{ ["Bloodscalp"]=true, ["Boulderfist"]=true, ["Dunemaul"]=true, ["Maiev"]=true, ["Stonemaul"]=true },
		{ ["Borean Tundra"]=true, ["Shadowsong"]=true },
		{ ["Bronzebeard"]=true, ["Shandris"]=true },
		{ ["Burning Blade"]=true, ["Lightning's Blade"]=true, ["Onyxia"]=true },
		{ ["Cairne"]=true, ["Perenolde"]=true },
		{ ["Coilfang"]=true, ["Dark Iron"]=true, ["Dalvengyr"]=true, ["Demon Soul"]=true },
		{ ["Dawnbringer"]=true, ["Madoran"]=true },
		{ ["Darrowmere"]=true, ["Windrunner"]=true },
		{ ["Dath'Remar"]=true, ["Khaz'goroth"]=true },
		{ ["Dentarg"]=true, ["Whisperwind"]=true },
		{ ["Draenor"]=true, ["Echo Isles"]=true },
		{ ["Draka"]=true, ["Suramar"]=true },
		{ ["Drak'Tharon"]=true, ["Firetree"]=true, ["Malorne"]=true, ["Rivendare"]=true, ["Spirestone"]=true, ["Stormscale"]=true },
		{ ["Drak'thul"]=true, ["Skywall"]=true },
		{ ["Dreadmaul"]=true, ["Thaurissan"]=true },
		{ ["Drenden"]=true, ["Arathor"]=true },
		{ ["Duskwood"]=true, ["Bloodhoof"]=true },
		{ ["Durotan"]=true, ["Ysera"]=true },
		{ ["Eitrigg"]=true, ["Shu'halo"]=true },
		{ ["Eldre'Thalas"]=true, ["Korialstrasz"]=true },
		{ ["Eonar"]=true, ["Velen"]=true },
		{ ["Eredar"]=true, ["Gorefiend"]=true, ["Spinebreaker"]=true, ["Wildhammer"]=true },
		{ ["Executus"]=true, ["Kalecgos"]=true, ["Shattered Halls"]=true },
		{ ["Exodar"]=true, ["Medivh"]=true },
		{ ["Farstriders"]=true, ["Silver Hand"]=true, ["Thorium Brotherhood"]=true },
		{ ["Fenris"]=true, ["Dragonblight"]=true },
		{ ["Frostmane"]=true, ["Ner'zhul"]=true, ["Tortheldrin"]=true },
		{ ["Frostwolf"]=true, ["Vashj"]=true },
		{ ["Ghostlands"]=true, ["Kael'thas"]=true },
		{ ["Gnomeregan"]=true, ["Moonrunner"]=true },
		{ ["Grizzly Hills"]=true, ["Lothar"]=true },
		{ ["Gundrak"]=true, ["Jubei'Thos"]=true },
		{ ["Hellscream"]=true, ["Zangarmarsh"]=true },
		{ ["Hydraxis"]=true, ["Terenas"]=true },
		{ ["Icecrown"]=true, ["Malygos"]=true },
		{ ["Kargath"]=true, ["Norgannon"]=true },
		{ ["Kilrogg"]=true, ["Winterhoof"]=true },
		{ ["Kirin Tor"]=true, ["Sentinels"]=true, ["Steamwheedle Cartel"]=true },
		{ ["Misha"]=true, ["Rexxar"]=true },
		{ ["Mok'Nathal"]=true, ["Silvermoon"]=true },
		{ ["Nagrand"]=true, ["Caelestrasz"]=true },
		{ ["Nazgrel"]=true, ["Nesingwary"]=true, ["Vek'nilash"]=true },
		{ ["Nordrassil"]=true, ["Muradin"]=true },
		{ ["Quel'dorei"]=true, ["Sen'jin"]=true },
		{ ["Runetotem"]=true, ["Uther"]=true },
		{ ["Scarlet Crusade"]=true, ["Feathermoon"]=true },
		{ ["Tanaris"]=true, ["Greymane"]=true },
		{ ["Uldaman"]=true, ["Ravencrest"]=true },
	}
end

if portal == "EU" then
	ArkInventory.Output( "Loading EU Connected Realm Data" )
	ConnectedRealms = {
		--ENGLISH
		{ ["Wildhammer"]=true, ["Thunderhorn"]=true },
		{ ["Kilrogg"]=true, ["Runetotem"]=true, ["Nagrand"]=true },
		{ ["Aggramar"]=true, ["Hellscream"]=true },
		{ ["Hellfire"]=true, ["Arathor"]=true },
		{ ["Kor'gall"]=true, ["Bloodfeather"]=true, ["Executus"]=true, ["Burning Steppes"]=true, ["Shattered Hand"]=true },
		{ ["Azjol-Nerub"]=true, ["Quel'Thalas"]=true },
		{ ["Ghostlands"]=true, ["Dragonblight"]=true },
		{ ["Darkspear"]=true, ["Terokkar"]=true },
		{ ["Aszune"]=true, ["Shadowsong"]=true },
		{ ["Shattered Halls"]=true, ["Balnazzar"]=true, ["Ahn'Qiraj"]=true, ["Trollbane"]=true, ["Talnivarr"]=true, ["Chromaggus"]=true, ["Boulderfist"]=true, ["Daggerspine"]=true, ["Laughing Skull"]=true, ["Sunstrider"]=true },
		{ ["Emeriss"]=true, ["Agamaggan"]=true, ["Hakkar"]=true, ["Crushridge"]=true, ["Bloodscalp"]=true },
		{ ["Grim Batol"]=true, ["Aggra"]=true },
		{ ["Karazhan"]=true, ["Lightning's Blade"]=true, ["Deathwing"]=true, ["The Maelstrom"]=true },
		{ ["Auchindoun"]=true, ["Dunemaul"]=true, ["Jaedenar"]=true },
		{ ["Dragonmaw"]=true, ["Spinebreaker"]=true, ["Haomarush"]=true, ["Vashj"]=true, ["Stormreaver"]=true },
		{ ["Zenedar"]=true, ["Bladefist"]=true, ["Frostwhisper"]=true },
		{ ["Xavius"]=true, ["Skullcrusher"]=true },
		{ ["Darksorrow"]=true, ["Genjuros"]=true, ["Neptulon"]=true },
		{ ["Drak'thul"]=true, ["Burning Blade"]=true },
		{ ["Moonglade"]=true, ["The Sha'tar"]=true },
		{ ["Darkmoon Faire"]=true, ["Earthen Ring"]=true },
		{ ["Scarshield Legion"]=true, ["Ravenholdt"]=true, ["The Venture Co"]=true, ["Sporeggar"]=true },
		-- FRENCH
		{ ["Elune"]=true, ["Varimathras"]=true },
		{ ["Marécage de Zangar"]=true, ["Dalaran"]=true },
		{ ["Eitrigg"]=true, ["Krasus"]=true },
		{ ["Suramar"]=true, ["Medivh"]=true },
		{ ["Arak-arahm"]=true, ["Throk'Feroth"]=true, ["Rashgarroth"]=true },
		{ ["Naxxramas"]=true, ["Arathi"]=true, ["Temple Noir"]=true, ["Illidan"]=true },
		{ ["Garona"]=true, ["Ner'zhul"]=true },
		{ ["Eldre'Thalas"]=true, ["Cho'gall"]=true, ["Sinstralis"]=true },
		{ ["Confrerie du Thorium"]=true, ["Les Clairvoyants"]=true },
		{ ["La Croisade écarlate"]=true, ["Culte de la Rive noire"]=true, ["Conseil des Ombres"]=true },
		-- GERMAN
		{ ["Gilneas"]=true, ["Ulduar"]=true },
		{ ["Garrosh"]=true, ["Shattrath"]=true, ["Nozdormu"]=true },
		{ ["Nethersturm"]=true, ["Alexstrasza"]=true },
		{ ["Un'Goro"]=true, ["Area 52"]=true, ["Sen'jin"]=true },
		{ ["Ambossar"]=true, ["Kargath"]=true },
		{ ["Ysera"]=true, ["Malorne"]=true },
		{ ["Malygos"]=true, ["Malfurion"]=true },
		{ ["Nazjatar"]=true, ["Dalvengyr"]=true },
		{ ["Arthas"]=true, ["Vek'lor"]=true, ["Blutkessel"]=true },
		{ ["Dethecus"]=true, ["Terrordar"]=true, ["Mug'thol"]=true, ["Theradras"]=true },
		{ ["Echsenkessel"]=true, ["Taerar"]=true, ["Mal'Ganis"]=true },
		{ ["Anetheron"]=true, ["Festung der Stürme"]=true, ["Rajaxx"]=true, ["Gul'dan"]=true },
		{ ["Die Arguswacht"]=true, ["Die Todeskrallen"]=true, ["Das Syndikat"]=true, ["Der Abyssische Rat"]=true },
		-- SPANISH
		{ ["Exodar"]=true, ["Minahonda"]=true },
		{ ["Colinas Pardas"]=true, ["Tyrande"]=true, ["Los Errantes"]=true },
		{ ["Zul'jin"]=true, ["Sanguino"]=true, ["Shen'dralar"]=true, ["Uldum"]=true },
		-- RUSSIAN
		{ ["Подземье"]=true, ["Разувий"]=true },
	}
end


function ArkInventory.IsConnectedRealm( a, b )
	return ArkInventory.Const.Realm[a] and ArkInventory.Const.Realm[a][b]
end

if ConnectedRealms then
	for k, v in pairs( ConnectedRealms ) do
		for x in pairs( v ) do
			if ArkInventory.Const.Realm[x] then
				ArkInventory.OutputWarning( "duplicate connected realm data found for ", x )
			else
				ArkInventory.Const.Realm[x] = ConnectedRealms[k]
			end
		end
	end
end

