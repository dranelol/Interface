-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--          http://www.curse.com/addons/wow/tradeskillmaster_warehousing          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains various utility related to connected realms

local TSM = select(2, ...)
local lib = TSMAPI

local CONNECTED_REALMS = {
	US = {
		{"Aegwynn","Bonechewer","Daggerspine","Gurubashi","Hakkar"},
		{"Agamaggan","Archimonde","Jaedenar","The Underbog"},
		{"Aggramar","Fizzcrank"},
		{"Akama","Dragonmaw","Mug'thol"},
		{"Alexstrasza","Terokkar"},
		{"Alleria","Khadgar"},
		{"Altar of Storms","Anetheron","Magtheridon","Ysondre"},
		{"Alterac Mountains","Balnazzar","Gorgonnash","The Forgotten Coast","Warsong"},
		{"Andorhal","Scilla","Ursin"},
		{"Antonidas","Uldum"},
		{"Anub'arak","Chromaggus","Crushridge","Garithos","Nathrezim","Smolderthorn"},
		{"Anvilmar","Undermine","Xavius"},
		{"Arathor","Drenden"},
		{"Arygos","Llane"},
		{"Auchindoun","Cho'gall","Laughing Skull"},
		{"Azgalor","Azshara","Destromath","Thunderlord"},
		{"Azjol-Nerub","Khaz Modan"},
		{"Azuremyst","Staghelm"},
		{"Black Dragonflight","Gul'dan","Skullcrusher"},
		{"Blackhand","Galakrond"},
		{"Blackwater Raiders","Shadow Council"},
		{"Blackwing Lair","Dethecus","Detheroc","Haomarush","Lethon"},
		{"Blade's Edge","Thunderhorn"},
		{"Bladefist","Kul Tiras"},
		{"Blood Furnace","Mannoroth","Nazjatar"},
		{"Bloodhoof","Duskwood"},
		{"Bloodscalp","Boulderfist","Dunemaul","Maiev","Stonemaul"},
		{"Borean Tundra","Shadowsong"},
		{"Bronzebeard","Shandris"},
		{"Burning Blade","Lightning's Blade","Onyxia"},
		{"Caelestrasz","Nagrand"},
		{"Cairne","Perenolde"},
		{"Coilfang","Dalvengyr","Dark Iron","Demon Soul"},
		{"Darrowmere","Windrunner"},
		{"Dath'Remar","Khaz'goroth"},
		{"Dentarg","Whisperwind"},
		{"Draenor","Echo Isles"},
		{"Dragonblight","Fenris"},
		{"Drak'Tharon","Firetree","Malorne","Rivendare","Spirestone","Stormscale"},
		{"Drak'thul","Skywall"},
		{"Draka","Suramar"},
		{"Dreadmaul","Thaurissan"},
		{"Eitrigg","Shu'halo"},
		{"Eldre'Thalas","Korialstrasz"},
		{"Eonar","Velen"},
		{"Eredar","Gorefiend","Spinebreaker","Wildhammer"},
		{"Executus","Kalecgos","Shattered Halls"},
		{"Exodar","Medivh"},
		{"Farstriders","Silver Hand","Thorium Brotherhood"},
		{"Feathermoon","Scarlet Crusade"},
		{"Frostmane","Ner'zhul","Tortheldrin"},
		{"Frostwolf","Vashj"},
		{"Ghostlands","Kael'thas"},
		{"Gnomeregan","Moonrunner"},
		{"Greymane","Tanaris"},
		{"Grizzly Hills","Lothar"},
		{"Gundrak","Jubei'Thos"},
		{"Hellscream","Zangarmarsh"},
		{"Hydraxis","Terenas"},
		{"Icecrown","Malygos"},
		{"Kargath","Norgannon"},
		{"Kilrogg","Winterhoof"},
		{"Kirin Tor","Sentinels","Steamwheedle Cartel"},
		{"Misha","Rexxar"},
		{"Mok'Nathal","Silvermoon"},
		{"Muradin","Nordrassil"},
		{"Nazgrel","Nesingwary","Vek'nilash"},
		{"Quel'dorei","Sen'jin"},
		{"Ravencrest","Uldaman"},
		{"Runetotem","Uther"}
	},
	EU = {
		{"Agamaggan","Bloodscalp","Crushridge","Emeriss","Hakkar"},
		{"Aggramar","Hellscream"},
		{"Ahn'Qiraj","Balnazzar","Boulderfist","Chromaggus","Daggerspine","Laughing Skull","Shattered Halls","Sunstrider","Talnivarr","Trollbane"},
		{"Alexstrasza","Nethersturm"},
		{"Ambossar","Kargath"},
		{"Anetheron","Gul'dan","Rajaxx","Festung der Stürme"},
		{"Arak-arahm","Rashgarroth","Throk'Feroth"},
		{"Arathi","Illidan","Naxxramas","Temple noir"},
		{"Arathor","Hellfire"},
		{"Area 52","Sen'jin","Un'Goro"},
		{"Arthas","Blutkessel","Vek'lor"},
		{"Auchindoun","Dunemaul","Jaedenar"},
		{"Azjol-Nerub","Quel'Thalas"},
		{"Bladefist","Frostwhisper","Zenedar"},
		{"Bloodfeather","Burning Steppes","Executus","Kor'gall","Shattered Hand"},
		{"Burning Blade","Drak'thul"},
		{"Cho'gall","Eldre'Thalas","Sinstralis"},
		{"Colinas Pardas","Los Errantes","Tyrande"},
		{"Conseil des Ombres","Culte de la Rive noire","La Croisade écarlate"},
		{"Dalaran","Marécage de Zangar"},
		{"Dalvengyr","Nazjatar"},
		{"Darkmoon Faire","Earthen Ring"},
		{"Darksorrow","Genjuros","Neptulon"},
		{"Das Syndikat","Der Abyssische Rat","Die Arguswacht","Die Todeskrallen"},
		{"Deathwing","Karazhan","Lightning's Blade"},
		{"Deepholm","Razuvious"},
		{"Dethecus","Mug'thol","Terrordar","Theradras"},
		{"Dragonblight","Ghostlands"},
		{"Dragonmaw","Haomarush","Spinebreaker","Stormreaver","Vashj"},
		{"Echsenkessel","Mal'Ganis","Taerar"},
		{"Eitrigg","Krasus"},
		{"Elune","Varimathras","Caduta dei Draghi"},
		{"Exodar","Minahonda"},
		{"Garona","Ner'zhul"},
		{"Garrosh","Nozdormu","Shattrath"},
		{"Gilneas","Ulduar"},
		{"Grim Batol","Aggra(Português)"},
		{"Kilrogg","Nagrand","Runetotem"},
		{"Les Clairvoyants","Confrérie du Thorium"},
		{"Malfurion","Malygos"},
		{"Malorne","Ysera"},
		{"Medivh","Suramar"},
		{"Moonglade","The Sha'tar"},
		{"Ravenholdt","Scarshield Legion","Sporeggar","The Venture Co"},
		{"Sanguino","Shen'dralar","Uldum","Zul'jin"},
		{"Skullcrusher","Xavius"},
		{"Thunderhorn","Wildhammer"}
	},
}

function TSMAPI:GetConnectedRealms()
	local region = GetCVar("portal") == "public-test" and "PTR" or GetCVar("portal")
	if not CONNECTED_REALMS[region] then return end
	local currentRealm = GetRealmName()
	
	for _, realms in ipairs(CONNECTED_REALMS[region]) do
		for i, realm in ipairs(realms) do
			if realm == currentRealm then
				local result = CopyTable(realms)
				tremove(result, i)
				return result
			end
		end
	end
end