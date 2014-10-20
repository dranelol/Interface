SGI.superScan = {};
SGI.libWho = {};


CreateFrame("Frame", "SGI_SUPER_SCAN");
CreateFrame("Frame", "SGI_ANTI_SPAM_FRAME");
CreateFrame("Frame", "SGI_WHISPER_QUEUE_FRAME");

LibStub:GetLibrary("LibWho-2.0"):Embed(SGI.libWho);

local start-- = SGI_DATA[SGI_DATA_INDEX].settings.lowLimit;
local stop-- = SGI_DATA[SGI_DATA_INDEX].settings.highLimit;
local race-- = SGI_DATA[SGI_DATA_INDEX].settings.raceStart;
local class-- = SGI_DATA[SGI_DATA_INDEX].settings.classStart;
local interval-- = SGI_DATA[SGI_DATA_INDEX].settings.interval;

local superScanIntervalTime = 8;
local superScanLast = 0;
local superScanProgress = 1;
local whoQueryList;
local whoSent = false;
local whoMaster = false;
local scanInProgress = false;
local shouldHideFriendsFrame = false;
local SGI_QUEUE = {};
local SGI_ANTI_SPAM = {};
local SGI_TEMP_BAN = {};
local whisperWaiting = {};
local whisperQueue = {};
local sessionTotal = 0;
local amountScanned = 0;
local amountGuildless = 0;
local amountQueued = 0;
local superScanLap = 1;

local raceClassCombos = {
	["Alliance"] = {
		["Human"] = {
			"Paladin",
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Warrior",
			"Warlock",
			"Death Knight",
			"Monk",
		},
		["Draenei"] = {
			"Hunter",
			"Mage",
			"Paladin",
			"Priest",
			"Shaman",
			"Death Knight",
			"Warrior",
			"Monk",
		},
		["Gnome"] = {
			"Mage",
			"Priest",
			"Rogue",
			"Warlock",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Dwarf"] = {
			"Hunter",
			"Mage",
			"Paladin",
			"Priest",
			"Rogue",
			"Shaman",
			"Warlock",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Night Elf"] = {
			"Druid",
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Worgen"] = {
			"Druid",
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Warlock",
			"Warrior",
			"Death Knight",
		},
		["Pandaren"] = {
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Shaman",
			"Warrior",
			"Monk",
		},
	},
	["Horde"] = {
		["Blood Elf"] = {
			"Paladin",
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Warlock",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Orc"] = {
			"Hunter",
			"Mage",
			"Rogue",
			"Shaman",
			"Warlock",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Goblin"] = {
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Shaman",
			"Warlock",
			"Warrior",
			"Death Knight",
		},
		["Tauren"] = {
			"Druid",
			"Hunter",
			"Paladin",
			"Priest",
			"Shaman",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Troll"] = {
			"Druid",
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Shaman",
			"Warlock",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Undead"] = {
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Warlock",
			"Warrior",
			"Death Knight",
			"Monk",
		},
		["Pandaren"] = {
			"Hunter",
			"Mage",
			"Priest",
			"Rogue",
			"Shaman",
			"Warrior",
			"Monk",
		},	
	},
}

local GetTime = GetTime;
local strfind = strfind;
local strsub = strsub;
local tonumber = tonumber;

local L = SGI.L;

function SGI:PickRandomWhisper()
	local i = 0
	local tbl = {}
	for k,_ in pairs(SGI_DATA[SGI_DATA_INDEX].settings.whispers) do
		i = i + 1
		tbl[i] = SGI_DATA[SGI_DATA_INDEX].settings.whispers[k]
	end
	if #tbl == 0 then
		return SGI_DATA[SGI_DATA_INDEX].settings.whisper
	end
	return tbl[random(#tbl)]
end

function SGI:FormatWhisper(msg, name)
	local whisper = msg
	if not msg then SGI:print("You have not set your whispers!") msg = "<NO WHISPER SET>" whisper = "<NO WHISPER SET>" end
	if not name then name = "ExampleName" end
	local guildName,guildLevel = GetGuildInfo(UnitName("Player")),GetGuildLevel()
	if not guildName then guildName = "<InvalidName>" end
	if not guildLevel then guildLevel = "<InvalidLevel>" end
	if strfind(msg,"PLAYER") then
		whisper = strsub(msg,1,strfind(msg,"PLAYER")-1)..name..strsub(msg,strfind(msg,"PLAYER")+6)
	end
	if strfind(whisper,"NAME") then
		whisper = strsub(whisper,1,strfind(whisper,"NAME")-1)..guildName..strsub(whisper,strfind(whisper,"NAME")+4)
	end
	if strfind(whisper,"LEVEL") then
		whisper = strsub(whisper,1,strfind(whisper,"LEVEL")-1)..guildLevel..strsub(whisper,strfind(whisper,"LEVEL")+5)
	end
	return whisper
end

local function QueueInvite(name,level,classFile,race,class,found)
	SGI_QUEUE[name] = {
		level = level,
		class = class,
		classFile = classFile,
		race = race,
		found = found,
	}
	GuildShield:IsShielded(name)
end

local function PutOnHold(name,level,classFile,race,class,found)
	SGI_ANTI_SPAM[name] = {
		level = level,
		class = class,
		classFile = classFile,
		race = race,
		found = found,
	}
	GuildShield:IsShielded(name)
end

SGI_ANTI_SPAM_FRAME.t = 0;
SGI_ANTI_SPAM_FRAME:SetScript("OnUpdate", function()
	if (SGI_ANTI_SPAM_FRAME.t < GetTime()) then
		for k,_ in pairs(SGI_ANTI_SPAM) do
			if (SGI_ANTI_SPAM[k].found + 4 < GetTime()) then
				SGI_QUEUE[k] = SGI_ANTI_SPAM[k];
				SGI_ANTI_SPAM[k] = nil;
				amountQueued = amountQueued + 1;
			end
		end
		SGI_ANTI_SPAM_FRAME.t = GetTime() + 0.5;
	end
end)

SGI_WHISPER_QUEUE_FRAME.t = 0;
SGI_WHISPER_QUEUE_FRAME:SetScript("OnUpdate", function()
	if (SGI_WHISPER_QUEUE_FRAME.t < GetTime()) then
	
		for k,_ in pairs(whisperQueue) do
			if (whisperQueue[k].t < GetTime()) then
				ChatIntercept:InterceptNextWhisper();
				SendChatMessage(whisperQueue[k].msg, "WHISPER", nil, k);
				whisperQueue[k] = nil;
			end
		end
	
		SGI_WHISPER_QUEUE_FRAME.t = GetTime() + 0.5;
		
	end
end)

local function ValidateName(player)
	--Check:
	-- Lock
	-- filter
	-- guild list
	
	if (SGI_DATA.lock[player.name]) then
		return false;
	end
	
	if (SGI_DATA.guildList[GetRealmName()][player.name]) then
		return false;
	end
	
	if (SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_ENABLE_FILTERS"] and not SGI:FilterPlayer(player)) then
		return false;
	end
	
	return true;
end

local function TrimRealmName(name)
	if (type(name) ~= "string") then SGI:debug("TrimRealmName: No name!") return end
	
	local myRealm = GetRealmName();
	
	if (type(myRealm) ~= "string") then SGI:debug("TrimRealmName: No realmName!") return end
	
	if (strfind(name, myRealm)) then
		if (strfind(name, "-")) then
			local n = strsub(name,1,strfind(name,"-")-1);
			return n;
		end
	end
	return name;
end

local function WhoResultCallback(query, results, complete)
	if (whoSent) then
		whoSent = false;
		SGI:debug("...got reply");
		
		superScanProgress = superScanProgress + 1;
		local ETR = (#whoQueryList - superScanProgress + 1) * superScanIntervalTime;
		if (SuperScanFrame) then
			SuperScanFrame.ETR = ETR;
			SuperScanFrame.lastETR = GetTime();
		end
		
		local numResults = 0;
		
		for _, result in pairs(results) do
			amountScanned = amountScanned + 1;
			numResults = numResults + 1;
			
			result.Name = TrimRealmName(result.Name);
			
			SGI:BroadcastVersion(result.Name)
			
			if (result.Guild == "") then
				local player = {
					name = result.Name,
					level = result.Level,
					race = result.Race,
					class = result.NoLocaleClass,
				}
				amountGuildless = amountGuildless + 1;
				if (ValidateName(player)) then
					PutOnHold(result.Name, result.Level, result.NoLocaleClass, result.Race, result.Class, GetTime());
				end
			end
		end
		SGI:debug("Scan result: "..numResults);
	end
end

local function SuperScan()
	if (GetTime() > superScanLast + superScanIntervalTime) then
		if (superScanProgress == (#whoQueryList + 1)) then
			superScanProgress = 1;
			superScanLast = GetTime();
			amountGuildless = 0;
			sessionTotal = sessionTotal + amountScanned;
			amountScanned = 0;
		else
			SGI.libWho:Who(tostring(whoQueryList[superScanProgress]),{queue = SGI.libWho.WHOLIB_QUERY_QUIET, callback = WhoResultCallback});
			whoSent = true;
			superScanLast = GetTime();
			SGI:debug("Sent query: "..whoQueryList[superScanProgress].."...");
		end
	end
end

local function CreateSuperScanQuery(start, stop, interval, class, race)

	if (not SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_ADV_SCAN"]) then
		interval = 5;
		class = 999;
		race = 999;
	end
	
	whoQueryList = {};
	local current = start;
	local Classes = {
			SGI.L["Death Knight"],
			SGI.L["Druid"],
			SGI.L["Hunter"],
			SGI.L["Mage"],
			SGI.L["Monk"],
			SGI.L["Paladin"],
			SGI.L["Priest"],
			SGI.L["Rogue"],
			SGI.L["Shaman"],
			SGI.L["Warlock"],
			SGI.L["Warrior"],
	}
	local Races = {}
	if UnitFactionGroup("player") == "Horde" then
		Races = {
			SGI.L["Orc"],
			SGI.L["Blood Elf"],
			SGI.L["Undead"],
			SGI.L["Troll"],
			SGI.L["Goblin"],
			SGI.L["Tauren"],
			SGI.L["Pandaren"],
		}
	else
		Races = {
			SGI.L["Human"],
			SGI.L["Dwarf"],
			SGI.L["Worgen"],
			SGI.L["Draenei"],
			SGI.L["Night Elf"],
			SGI.L["Gnome"],
			SGI.L["Pandaren"],
		}
	end
	
	if (start < 85) then
		while (current + interval < ( (85 > stop) and stop or 85)) do
		
			if (current + interval >= race and current + interval >= class) then
				for k,_ in pairs(raceClassCombos[UnitFactionGroup("player")]) do
					for j,_ in pairs(raceClassCombos[UnitFactionGroup("player")][k]) do
						tinsert(whoQueryList, current.."- -"..(current + interval - 1).." r-"..SGI.L[k].." c-"..SGI.L[raceClassCombos[UnitFactionGroup("player")][k][j]]);
					end
				end
			elseif (current + interval >= race) then
				for k, _ in pairs(Races) do 
					tinsert(whoQueryList, current.."- -"..(current + interval - 1).." r-"..Races[k]);
				end
			elseif (current + interval >= class) then
				for k, _ in pairs(Classes) do
					tinsert(whoQueryList, current.."- -"..(current + interval - 1).." c-"..Classes[k]);
				end
			else
				tinsert(whoQueryList, current.."- -"..(current + interval - 1));
			end
			
			current = current + interval;
		end
		
		if ( current < ( (85 > stop) and stop or 85 ) ) then
			local t_stop = (85 > stop) and stop or 85;
			if (t_stop >= race and t_stop >= class) then
				for k,_ in pairs(raceClassCombos[UnitFactionGroup("player")]) do
					for j,_ in pairs(raceClassCombos[UnitFactionGroup("player")][k]) do
						tinsert(whoQueryList, current.."- -"..(t_stop).." r-"..SGI.L[k].." c-"..SGI.L[raceClassCombos[UnitFactionGroup("player")][k][j]]);
					end
				end
			elseif (t_stop >= race) then
				for k, _ in pairs(Races) do 
					tinsert(whoQueryList, current.."- -"..(t_stop).." r-"..Races[k]);
				end
			elseif (t_stop >= class) then
				for k, _ in pairs(Classes) do
					tinsert(whoQueryList, current.."- -"..(t_stop).." c-"..Classes[k]);
				end
			else
				tinsert(whoQueryList, current.."- -"..(t_stop));
			end
			current = t_stop + 1;
		end
	end
	if (stop < current) then return end;
	
	while (current <= stop) do 
		if (current >= race and current >= class) then
			for k,_ in pairs(raceClassCombos[UnitFactionGroup("player")]) do
				for j,_ in pairs(raceClassCombos[UnitFactionGroup("player")][k]) do
					tinsert(whoQueryList, current.." r-"..SGI.L[k].." c-"..SGI.L[raceClassCombos[UnitFactionGroup("player")][k][j]]);
				end
			end
		elseif (current >= race) then
			for k,_ in pairs(Races) do
				tinsert(whoQueryList, current.." r-"..Races[k]);
			end
		elseif (current >= class) then
			for k,_ in pairs(Classes) do 
				tinsert(whoQueryList, current.." c-"..Classes[k]);
			end
		else
			tinsert(whoQueryList, current);
		end
		current = current + 1;
	end
end

local function CanResume()
	local s = SGI_DATA[SGI_DATA_INDEX].settings;
	return (start == s.lowLimit and stop == s.highLimit and race == s.raceStart and class == s.classStart and interval == s.interval);
end

local function ResetSuperScan()
	start = SGI_DATA[SGI_DATA_INDEX].settings.lowLimit;
	stop = SGI_DATA[SGI_DATA_INDEX].settings.highLimit;
	race = SGI_DATA[SGI_DATA_INDEX].settings.raceStart;
	class = SGI_DATA[SGI_DATA_INDEX].settings.classStart;
	interval = SGI_DATA[SGI_DATA_INDEX].settings.interval;
	
	amountGuildless = 0;
	sessionTotal = sessionTotal + amountScanned;
	amountScanned = 0;
	superScanProgress = 1;
	CreateSuperScanQuery(start, stop, interval, class, race);
end

function SGI:StartSuperScan()
	if (not CanResume()) then
		ResetSuperScan();
	end
	
	if (SuperScanFrame) then
		SuperScanFrame.lastETR = GetTime();
	end
	
	scanInProgress = true;
	SGI_SUPER_SCAN:SetScript("OnUpdate", SuperScan);
end

function SGI:StopSuperScan()
	
	scanInProgress = false;
	SGI_SUPER_SCAN:SetScript("OnUpdate", nil);
	SGI:debug(FriendsFrame:IsShown());
	--FriendsMicroButton:Click();
	--FriendsFrameCloseButton:Click();
end

function SGI:RemoveQueued(name)
	SGI:LockPlayer(name);
	SGI_QUEUE[name] = nil;
	SGI_ANTI_SPAM[name] = nil;
	
	local nameTrim = TrimRealmName(name);
	
	SGI_ANTI_SPAM[nameTrim] = nil
	SGI_QUEUE[nameTrim] = nil;
	
	SGI:debug("RemoveQueued(name) removed "..nameTrim);
end

function SGI:UnregisterForWhisper(name)
	whisperWaiting[name] = nil;
	whisperQueue[name] = nil;
end

function SGI:SendWhisper(message, name, delay)
	whisperQueue[name] = {msg = message, t = delay + GetTime()};
	whisperWaiting[name] = nil;
end

function SGI:RegisterForWhisper(name)
	whisperWaiting[name] = true;
end

function SGI:IsRegisteredForWhisper(name)
	return whisperWaiting[name];
end



function SGI:SendGuildInvite(button)
	local name = self.player
	if not name then name = next(SGI_QUEUE) button = "LeftButton" end
	if not name then return end
	
	if (SGI:IsLocked(name)) then
		SGI:RemoveQueued(name);
		return;
	end
	
	if (UnitIsInMyGuild(name)) then
		SGI:LockPlayer(name);
		SGI:RemoveQueued(name);
		return;
	end
	
	if (button == "LeftButton") then
		
		if (SGI_DATA[SGI_DATA_INDEX].settings.dropDown["DROPDOWN_INVITE_MODE"] == 1) then
			
			GuildInvite(name);
			SGI:LockPlayer(name);
			--SGI:print("Only Invite: "..name);
			
		elseif (SGI_DATA[SGI_DATA_INDEX].settings.dropDown["DROPDOWN_INVITE_MODE"] == 2) then
			
			GuildInvite(name);
			SGI:RegisterForWhisper(name);
			SGI:LockPlayer(name);
			--SGI:print("Invite, then whisper: "..name);
		
		elseif (SGI_DATA[SGI_DATA_INDEX].settings.dropDown["DROPDOWN_INVITE_MODE"] == 3) then
			
			SGI:SendWhisper(SGI:FormatWhisper(SGI:PickRandomWhisper(), name), name, 4);
			SGI:LockPlayer(name);
			--SGI:print("Only whisper: "..name);
		
		else
			SGI:print(SGI.L["You need to specify the mode in which you wish to invite"])
			SGI:print(SGI.L["Go to Options and select your Invite Mode"])
		end
		GuildShield:IsShielded(name);
		SGI:LiveSync(name)
	end
	
	SGI:RemoveQueued(name);
end

function SGI:RemoveShielded(player)
	SGI:debug(player);
	if (not player) then  SGI:debug("Error: No player name provided!") return end
	
	local playerTrim = TrimRealmName(player);
	
	SGI_ANTI_SPAM[playerTrim] = nil
	SGI_QUEUE[playerTrim] = nil;
	SGI:LockPlayer(playerTrim);
	
	SGI_ANTI_SPAM[player] = nil
	SGI_QUEUE[player] = nil;
	SGI:LockPlayer(player);
	SGI:print("|cffffff00Removed |r|cff00A2FF"..player.."|r|cffffff00 because they are shielded.|r")
end

function SGI:GetNumQueued()
	return SGI:CountTable(SGI_QUEUE);
end

function SGI:PurgeQueue()
	SGI_QUEUE = {};
	SGI_ANTI_SPAM = {};
end

function SGI:GetSuperScanETR()
	if (whoQueryList) then
		return SGI:FormatTime((#whoQueryList - superScanProgress + 1) * superScanIntervalTime);
	else
		return 0;
	end
end

function SGI:GetSuperScanProgress()
	return floor((superScanProgress - 1) / #whoQueryList);
end

function SGI:GetTotalScanTime()
	return ((#whoQueryList - 1) * superScanIntervalTime);
end

function SGI:IsScanning()
	return scanInProgress;
end

function SGI:GetInviteQueue()
	return SGI_QUEUE;
end

function SGI:GetSuperScanStats()
	return amountScanned, amountGuildless, amountQueued, sessionTotal;
end



SGI:debug(">> SuperScan.lua");