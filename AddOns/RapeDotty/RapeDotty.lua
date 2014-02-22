-- 
-- RapeDotty by Eggsampler
-- 
-- Usage: /RapeDotty [start/stop/min/max/msg] (level/msg)
-- 

local minLevel = 1;
local msgInvite = "";

local levelStart = minLevel;
local levelEnd = 80;
local searching = false;
local lastSearchTime = 0;
local levelIncrement = 1;

local longSearch = false;
local uberLongSearch = false;

local lastClass = 1;
local classes = { "Priest", "Warrior", "Warlock", "Druid", "Rogue", "Mage", "Hunter", "Paladin", "Shaman", "Death Knight" };

local lastRace = 1;
local racesA = { "Gnome", "Human", "Night Elf", "Draenei", "Dwarf" };
local racesH = { "Undead", "Orc", "Troll", "Blood Elf", "Tauren" };

function RapeDotty_Message(thing)
	DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFRapeDotty: |cFFFFFFFF" .. thing);
end

function RapeDotty_Command(args)
	if (args == "stop") then
		RapeDotty_Message("Stopping");
		RapeDotty_StopSearch();
		return;
	elseif (args == "start") then
		if (not CanGuildInvite()) then
			RapeDotty_Message("You can't ginvite you fkn downs.");
			return;
		end;
		levelStart = minLevel;
		longSearch = false;
		uberLongSearch = false;
		RapeDotty_Message("Starting, min: " .. levelStart .. " max: " .. levelEnd);
		if (msgInvite == "") then
			RapeDotty_Message("Invite message is off");
		else
			RapeDotty_Message("Invite message: " .. msgInvite);
		end
		RapeDotty_SendSearch();
		return;
	end
	local arg1, arg2 = strsplit(" ", string.lower(args), 2)
	if (arg1 == "min") or (arg1 == "max") then
		if (searching) then
			RapeDotty_Message("Stop searching before setting " .. arg1 .. " level!");
			return;
		elseif (arg2 == nil) or (strtrim(arg2) == "") then
			RapeDotty_Message("Current " .. arg1 .. " level is: " .. (arg1 == "min" and minLevel or levelEnd));
			return;
		end
		local level = tonumber(strtrim(arg2));
		if (level == nil) then
			RapeDotty_Message("Please enter a valid number!");
		else
			if (arg1 == "min") then
				minLevel = level;
			else
				levelEnd = level;
			end
			RapeDotty_Message(arg1 .. " invite level set to: " .. level);
		end
	elseif (arg1 == "msg") then
		if (searching) then
			RapeDotty_Message("Stop searching before setting");
			return;
		elseif (arg2 == nil) or (strtrim(arg2) == "") then
			if (msgInvite == "") then
				RapeDotty_Message("Invite message is off");
			else
				RapeDotty_Message("Current invite msg: " .. msgInvite);
				RapeDotty_Message("To turn off use /rapedotty msg off");
			end
			return;
		end
		if (strtrim(arg2) == "off") then
			msgInvite = "";
		else
			msgInvite = strtrim(arg2);
		end
		if (msgInvite == "") then
			RapeDotty_Message("Not messaging players before invite");
		else
			RapeDotty_Message("Invite message: " .. msgInvite);
		end
	else
		RapeDotty_Message("RapeDotty by Eggsampler");
		RapeDotty_Message("Usage: /RapeDotty [start/stop/min/max/msg] (level/msg)");
	end
end

function RapeDotty_OnEvent(args)
	if (not searching) then return; end
	local numWhos = GetNumWhoResults();
	if (longSearch) then
		if (uberLongSearch) then
			lastRace = lastRace + 1;
			if (racesH[lastRace] == nil) then
				uberLongSearch = false;
				lastClass = lastClass + 1;
				if (classes[lastClass] == nil) then
					longSearch = false;
					levelStart = levelStart + levelIncrement;
				end
			end
		else
			if (numWhos >= 50) then
				lastRace = 1;
				uberLongSearch = true;
				return;
			end
			lastClass = lastClass + 1;
			if (classes[lastClass] == nil) then
				longSearch = false;
				levelStart = levelStart + levelIncrement;
			end
		end
	else
		if (numWhos >= 50) then
			lastClass = 1;
			longSearch = true;
			return;
		else
			longSearch = false;
			levelStart = levelStart + levelIncrement;
		end
	end
	RapeDotty_InviteWhoResults();
end

function RapeDotty_OnUpdate(args)
	if (searching and time() > lastSearchTime + 5) then
		if (not CanGuildInvite()) then
			RapeDotty_Message("You can't invite anymore, stopping.");
			RapeDotty_StopSearch();
		elseif (levelStart <= levelEnd) then
			RapeDotty_SendSearch();
		else
			RapeDotty_StopSearch();
			RapeDotty_Message("Finished.");
		end
	end
end

function RapeDotty_SendSearch()
	SetWhoToUI(1);
	FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE");
	local whoString = "g-\"\" " .. levelStart .. "-" .. levelStart + levelIncrement - 1;
	if (longSearch) then
		whoString = whoString .. " c-\"" .. classes[lastClass] .. "\"";
	end
	if (uberLongSearch) then
		whoString = whoString .. " r-\"";
		if (UnitFactionGroup("player") == "Horde") then
			whoString = whoString .. racesH[lastRace];
		else
			whoString = whoString .. racesA[lastRace];
		end
		whoString = whoString ..  "\""; 
	end
	RapeDotty_Message("who: " .. whoString);
	searching = true;
	lastSearchTime = time();
	SendWho(whoString);
end

function RapeDotty_StopSearch()
	searching = false;
	FriendsFrame:RegisterEvent("WHO_LIST_UPDATE");
	SetWhoToUI(0);
	RapeDotty_Message("Stopped");
end

function RapeDotty_InviteWhoResults()
	local numWhos = GetNumWhoResults();
	for index = 1, numWhos, 1 do
		charname, guildname, level, race, class, zone, classFileName = GetWhoInfo(index);
		if (guildname == "") then
			if (msgInvite ~= "") then
				SendChatMessage(msgInvite, "WHISPER", nil, charname)
			end
			GuildInvite(charname);
		end
	end
end

SLASH_RapeDotty1 = "/rapedotty";
SLASH_RapeDotty2 = "/rd";
SlashCmdList["RapeDotty"] = RapeDotty_Command;

local dummy = CreateFrame("Frame", nil);
dummy:SetScript("OnEvent", RapeDotty_OnEvent);
dummy:SetScript("OnUpdate", RapeDotty_OnUpdate);
dummy:RegisterEvent("WHO_LIST_UPDATE");