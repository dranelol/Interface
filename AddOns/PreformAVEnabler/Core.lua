--[[

Preform AV Enabler (c) Torrid of torridreflections.com

AUTHOR CONTACT INFORMATION

I can be reached at torrid@torridreflections.com, or user name Torrid at curse.com.


SOFTWARE LICENSE

You MAY:

* Run this software in your World of Warcraft client.
* Distribute this software PRIVATELY to individuals so long that it remains UNALTERED and free of charge.

You MAY NOT:

* Upload this software or derivatives of it to PUBLIC websites.
* Distribute altered copies of this file to ANYBODY.

]]

if ( not PreformAVEnabler ) then
	PreformAVEnabler = {};
end
local pave = PreformAVEnabler;
if ( not pave.events ) then
	pave.events = {};
end


---------------------------------------------------------------------------------
--	Core Vars
---------------------------------------------------------------------------------

pave.version = tonumber(GetAddOnMetadata("PreformAVEnabler", "Version"));
pave.playerName = UnitName("player");
pave.playerStatus = nil;
pave.memberStatus = {};
pave.memberList = {};
pave.raidLeader = "";
pave.isInRaid = false;
pave.isEntireRaidV3 = true;
pave.anywhereQueueBG = nil;
pave.newGroup = true;		-- send status update when joing new group
pave.sendStatusNextRoster = true;-- flag to send status after next roster update
pave.skipRosterUpdate = true;	-- send updates after the second roster update, since the first one seems to lie
pave.lastStatus = "";		-- prevent redundant status sending
pave.lastStatusTime = 0;	--
pave.waitUntilReady = false;	-- to prevent leave queue spam
pave.lastCheck = 0;		-- prevent redundant status updates
pave.neverUpdated = 0;		-- state var to determine if a status update was ever seen between the time player got member data and
				-- player opened status window (don't request status update if player has everybody's status)
pave.lastQueued = 0;		-- the last BG ID the leader raid queued


---------------------------------------------------------------------------------
--	Startup Function
---------------------------------------------------------------------------------

function pave.CoreOnLoad(frame)
	SlashCmdList["PREFORMAV"] = pave.CmdLine;
	SLASH_PREFORMAV1 = PREFORM_AV_ENABLER_CMD;

	frame:RegisterEvent("CHAT_MSG_ADDON");
	frame:RegisterEvent("GROUP_ROSTER_UPDATE");
	frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	--frame:RegisterEvent("PVPQUEUE_ANYWHERE_UPDATE_AVAILABLE");		-- doesn't seem to ever trigger in game?
	frame:RegisterEvent("PVPQUEUE_ANYWHERE_SHOW");
	frame:RegisterEvent("UNIT_NAME_UPDATE");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	frame:RegisterEvent("PARTY_INVITE_REQUEST");
	frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	frame:RegisterEvent("UNIT_CONNECTION");
	frame:RegisterEvent("VARIABLES_LOADED");

	frame:SetScript("OnEvent", function(self, event, ...)
		pave.events[event](...);
	end);

	if ( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00"..PREFORM_AV_ENABLER_SELF.."|r v|c0000ffff"..pave.version.."|r loaded.  |c0000ff00"..PREFORM_AV_ENABLER_CMD.."|r to use");
	end
end



---------------------------------------------------------------------------------
--	Popups
---------------------------------------------------------------------------------

StaticPopupDialogs["PREFORM_LEAVE_CONFIRM"] = {
	text = PREFORM_AV_ENABLER_LEAVE_THIS,
	button1 = OKAY,
	button2 = nil,
	OnAccept = function(self, data)
		if ( not AcceptBattlefieldPort(data) ) then
			return 1;
		end
	end,
	timeout = 90,
	showAlert = 1,
	whileDead = 1,
	hideOnEscape = 1,
	multiple = 1
};
StaticPopupDialogs["PREFORM_CONFIRM_BATTLEFIELD_ENTRY"] = {
	text = PREFORM_AV_ENABLER_JOIN_THIS,
	button1 = ENTER_BATTLE,
	OnAccept = function(self, data)
		if ( not AcceptBattlefieldPort(data, 1) ) then
			return 1;
		end
		if( StaticPopup_Visible( "DEATH" ) ) then
			StaticPopup_Hide( "DEATH" );
		end
	end,
	timeout = 90,
	whileDead = 1,
	hideOnEscape = nil,
	noCancelOnEscape = 1,
	noCancelOnReuse = 1,
	multiple = 1,
	showAlert = 1,
};

function pave.HidePopup(qid)
	if ( qid == "all" ) then
		for queueId = 1, GetMaxBattlefieldID() do
			StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY", queueId);
		end
	elseif ( type(qid) == "number" ) then
		StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY", qid);
	end
end

function pave.HidePopupsExcept(bg)

	local _, qid;

	for i = 1, pave.NUM_BGS do
		
		_, _, qid = pave.BGStatus(i);

		if ( qid > 0 and bg ~= i ) then
			pave.HidePopup(qid);
		end
	end
end

function pave.ShowEntryPopup(bg)

	local _, _, qid = pave.BGStatus(bg);

	PlaySound("ReadyCheck");

	StaticPopup_Show("PREFORM_CONFIRM_BATTLEFIELD_ENTRY", pave.BG_NAME[bg], "", qid);
end

function pave.ShowLeavePopup(bg)

	local _, _, qid = pave.BGStatus(bg);
	
	pave.HidePopup(qid);
	
	PlaySound("LFG_Denied");

	StaticPopup_Show("PREFORM_LEAVE_CONFIRM", pave.BG_NAME[bg], "", qid);
end



---------------------------------------------------------------------------------
--	BG Status Functions
---------------------------------------------------------------------------------

function pave.BGStatus(bg)

	if ( not pave.BG_NAME[bg] ) then
		return "none", 0, 0;
	end

	local bgName, status, instanceId;

	for queueId = 1, GetMaxBattlefieldID() do
		status, bgName, instanceId = GetBattlefieldStatus(queueId);

		if ( bgName == pave.BG_NAME[bg] ) then
			return status, instanceId, queueId;
		end
	end

	return "none", 0, 0;
end

function pave.IsInsideBG()
	local instance, instanceType = IsInInstance();
	if ( instance and instanceType == "pvp" ) then
		return true;
	end
	return false;
end



---------------------------------------------------------------------------------
--	Member Status Functions
---------------------------------------------------------------------------------

--[[	PreformAVEnabler.memberStatus = {
		[name] = {
			index,
			realm,
			battlegroup,
			version,
			online,
			offlineTime,
			role,
			class,
			spec,
			avgiLevel,
			resilience,
			rating,
			deserter,
			lastUpdate,
			queues = {
				[BG ID] = {
					state,
					time,
					isLeaderQueued,
				},
				...
			},
		},
		...
	}
]]
function pave.SetMemberStatus(index, unit, name, realm)
	
	if ( UnitIsGroupLeader(unit) ) then
		pave.raidLeader = name;

	elseif ( name == pave.playerName ) then
		pave.lastQueued = 0;
	end

	if ( not realm ) then
		realm = GetRealmName();
	end

	if ( not pave.memberStatus[name] ) then
		
		local _, class = UnitClass(unit);

		pave.memberStatus[name] = {
			index = index,
			realm = realm or "",
			-- no idea why you removed the spaces in the realm list
			battlegroup = pave.BATTLEGROUP[realm:gsub(" ","")] or UNKNOWN,
			version = -1,
			online = UnitIsConnected(unit),
			offlineTime = 0,
			role = UnitGroupRolesAssigned(unit),
			class = class or UNKNOWN,
			--spec = "",
			avgiLevel = "?",
			resilience = "?",
			rating = "?",
			deserter = 0,
			lastUpdate = GetTime();
			queues = {},
		};
		for i = 1, pave.NUM_BGS do
			pave.memberStatus[name].queues[i] = { state = 0, time = 0 };
		end
	else
		local status = pave.memberStatus[name];
		
		status.index = index;
		status.role = UnitGroupRolesAssigned(unit);
		status.lastUpdate = GetTime();
		status.online = UnitIsConnected(unit);
		if ( status.online ) then
			status.offlineTime = 0;
		elseif ( status.offlineTime == 0 ) then
			status.offlineTime = GetTime();
		end

		if ( status.version < 3 and status.version > 0 ) then
			pave.isEntireRaidV3 = false;
		end
	end
end

-- call this instead of UnitName() for any unit ids that might be from cross realm
function pave.UnitName(unit)
	local name, realm = UnitName(unit);
	if ( realm == "" ) then
		realm = nil;
	end
	if ( realm ) then
		return name.."-"..realm, realm;
	end
	return name, realm;
end

-- this should never get called inside a bg
function pave.GetMembers()

	pave.memberList = {};
	pave.raidLeader = "";
	pave.isEntireRaidV3 = true;

	local numRaidMembers = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME);
	local _, name, realm, unit, unknownUnit;

	if ( not IsInRaid(LE_PARTY_CATEGORY_HOME) ) then

		pave.isInRaid = false;

		for i=1, MAX_PARTY_MEMBERS do
			if ( UnitExists("party"..i) ) then
				unit = "party"..i;
				name, realm = pave.UnitName(unit);

				if ( name ~= UNKNOWN ) then
					pave.SetMemberStatus(i, unit, name, realm);
					pave.memberList[i] = name;
				else
					unknownUnit = true;
				end
			end
		end

		unit = "player";
		name, realm = UnitName(unit);

		pave.SetMemberStatus(#pave.memberList + 1, unit, name, realm);
		pave.memberList[#pave.memberList + 1] = name;
	else
		pave.isInRaid = true;

		-- Raid
		for i=1, MAX_RAID_MEMBERS do
			name = GetRaidRosterInfo(i);	-- this gives the hyphenated name

			if ( name ) then
				if ( name ~= UNKNOWN ) then

					unit = "raid"..i;
					_, realm = pave.UnitName(unit);

					pave.SetMemberStatus(i, unit, name, realm);
					pave.memberList[i] = name;
				else
					unknownUnit = true;
				end
			end
		end
	end
	pave.playerStatus = pave.memberStatus[pave.playerName];

	pave.setMemberFramesPending = true;
	pave.SetMemberFrames();

	-- set widgets if group/raid disbanded (members == 1)
	-- or if thresholder slider visible and player is not leader
	-- or is threshold slider not visible and player leader
	-- bit of a kludge, but I don't want to call SetWidets unnecessarily
	if (	#pave.memberStatus == 1 
		or (PreformAVEnablerThresholdSlider:IsShown() and pave.raidLeader ~= pave.playerName ) 
		or (not PreformAVEnablerThresholdSlider:IsShown() and pave.raidLeader == pave.playerName ) 
	) then
		pave.SetWidgets();
	end

	-- 1 == have member data but never requested status before.  2 == have member data and have requested data before
	if ( pave.neverUpdated ~= 2 ) then
		pave.neverUpdated = 1;
	end

	-- send status if new to the group
	-- if a member has a name of UNKNOWN, then they won't get the status update
	if ( pave.newGroup and not unknownUnit ) then
		pave.SendStatus();
		pave.newGroup = false;
	end

	-- if player is newly deserter (check put here because PLAYER_ENTERING_WORLD seems to fire before client gets the icon
	-- and if members > 1.  There is a period of time after a player zones out of a BG that the game considers him out of a group/raid before rejoining it
	if ( pave.playerStatus.deserter == 0 and pave.CheckDeserter() > 0 and #pave.memberList > 1 ) then
		pave.playerStatus.deserter = pave.CheckDeserter();
		pave.SendStatus();
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("I am now a deserter", 0, 1, 1);
		end
	end

	pave.Update();
	pave.DeleteOldMemberStatus();
end

function pave.DeleteOldMemberStatus()

	local statusNames = {};
	for name in pairs(pave.memberStatus) do
		statusNames[name] = pave.memberStatus[name];
	end

	local now = GetTime();

	for name, status in pairs(statusNames) do
		if ( (now - status.lastUpdate) > 3600 and pave.memberList[status.index] ~= name ) then

			pave.memberStatus[name] = nil;
			if ( pave.config.debug ) then
				DEFAULT_CHAT_FRAME:AddMessage("Deleting status for old member: "..name..".  If he is in your raid, then this is a bug", 0, 1, 1);
			end
		end
	end
end

function pave.CheckDeserter()
	local _, name, expirationTime;

	for i=1, MAX_PARTY_DEBUFFS do
		--  name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitDebuff("unit", [index] or ["name", "rank"]) 
		name, _, _, _, _, _, expirationTime = UnitDebuff("player", i);
		if ( name == PREFORM_AV_ENABLER_DESERTER ) then
			return math.ceil( expirationTime - GetTime() );
		end
	end

	return 0;
end

function pave.IsLeader(name)
	local i, unit;

	if ( name == pave.raidLeader ) then
		return true;
	end
	if ( UnitIsGroupLeader(name) ) then
		return true;
	end
end

function pave.SetPlayerQueueStatus()
	local status;

	if ( not pave.playerStatus ) then
		pave.SetMemberStatus(1, "player", UnitName("player"));
		pave.playerStatus = pave.memberStatus[pave.playerName];
		pave.memberList[1] = pave.playerName;
	end

	for i = 1, pave.NUM_BGS do
		status = pave.BGStatus(i);

		if ( status == "queued" ) then
			pave.playerStatus.queues[i].state = 1;

		elseif ( status == "confirm" ) then
			pave.playerStatus.queues[i].state = 2;

		elseif ( status == "active" ) then
			pave.playerStatus.queues[i].state = 3;
		else
			pave.playerStatus.queues[i].state = 0;
		end
	end
end

function pave.Tally(bg)
	-- returns:
	-- num unqueued
	-- num queued
	-- num confirm
	-- num inside
	-- averaged time since confirmation

	local unqueued = 0;
	local queued = 0;
	local confirms = 0;
	local insides = 0;
	local avgConfirmTime = 0;
	local highestTime = 0;
	local status;

	for i, memberName in pairs(pave.memberList) do

		status = pave.memberStatus[memberName];

		if (	status.online and
			status.deserter < ( GetTime() + 1 )		-- add one extra second for good measure
		) then

			if ( status.queues[bg].state == 0 ) then
				unqueued = unqueued + 1;

			elseif ( status.queues[bg].state == 1 ) then
				queued = queued + 1;

			elseif ( status.queues[bg].state == 2 ) then
				confirms = confirms + 1;
				avgConfirmTime = avgConfirmTime + status.queues[bg].time;
				if ( highestTime < status.queues[bg].time ) then
					highestTime = status.queues[bg].time;
				end

			elseif ( status.queues[bg].state == 3 ) then
				insides = insides + 1;
			end

		end
	end

	return unqueued, queued, confirms, insides, (avgConfirmTime / confirms), highestTime;
end

function pave.ShowLeader()
	DEFAULT_CHAT_FRAME:AddMessage(pave.raidLeader);
end



---------------------------------------------------------------------------------
--	Queue Functions
---------------------------------------------------------------------------------

function pave.SoloLeaveQueue(bg)

	local status, id, qid = pave.BGStatus(bg);

	if ( status == "confirm" or status == "queued" ) then
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Leaving "..pave.BG_NAME[bg].." queue", 0, 1, 1);
		end

		if ( pave.raidLeader ~= pave.playerName ) then	-- leader's leave queue button leaves it for him

			pave.ShowLeavePopup(bg);
		end
	end
end

function pave.RaidLeaveQueue(bg)

	if ( bg == pave.automateBG ) then
		pave.waitUntilReady = true;				-- so automate doesn't try to get people to join games until ready
	end

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("Sending signal to LEAVE "..pave.BG_NAME[bg], 0, 1, 1);
	end

	pave.SendOpCode(pave.opCodes["l"].output(bg));

	if ( not pave.isEntireRaidV3 ) then
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Sending signal to LEAVE for 2.x users", 0, 1, 1);
		end
		pave.SendOpCode("leavequeue,"..bg);
	end

	local status, id, qid = pave.BGStatus(bg);

	if ( status == "confirm" or status == "queued" ) then
		AcceptBattlefieldPort(qid);
	end
end

function pave.SoloQueue(bg)

	if ( not pave.BG_NAME[bg] ) then
		return
	end

	PVPHonorFrame.selectedHonorButton = bg;

	for id = 1, GetNumBattlegroundTypes() do
	   
		if ( GetBattlegroundInfo(id) == pave.BG_NAME[bg] ) then

			if ( pave.config.debug ) then
				DEFAULT_CHAT_FRAME:AddMessage("RequestBattlegroundInstanceInfo("..id..");  bg == "..bg, 0, 1, 1);
			end

			RequestBattlegroundInstanceInfo(id);

			pave.anywhereQueueBG = id;
			pave.playerStatus.queues[bg].isLeaderQueued = true;
			break;
		end
	end
end

function pave.RaidQueue(bg)

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("Sending signal to QUEUE for "..pave.BG_NAME[bg], 0, 1, 1);
	end

	pave.SendOpCode(pave.opCodes["q"].output(bg));

	pave.lastQueued = bg;

	if ( not pave.isEntireRaidV3 ) then
		pave.SendOpCode("queue,"..bg);

		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Sending signal to QUEUE for 2.x users", 0, 1, 1);
		end
	end
end

function pave.Join(bg)

	if ( pave.raidLeader ~= pave.playerName or not PreformAVEnablerFrame:IsVisible() ) then
		DEFAULT_CHAT_FRAME:AddMessage(format(PREFORM_AV_ENABLER_JOIN_THIS, pave.BG_NAME[bg], ""));
	end

	pave.HidePopup("all");

	local status, id, qid = pave.BGStatus(bg);

	if ( status == "confirm" ) then

		pave.ShowEntryPopup(bg);
	else
		pave.playerStatus.queues[bg].isLeaderQueued = nil;	-- to unhide Blizzard's BG popup if we get a later confirm
	end

end

function pave.RaidJoin(bg)

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("Sending signal to JOIN "..pave.BG_NAME[bg], 0, 1, 1);
	end
	pave.SendOpCode(pave.opCodes["j"].output(bg));

	if ( not pave.isEntireRaidV3 ) then
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Sending signal to JOIN for 2.x users", 0, 1, 1);
		end
		pave.SendOpCode("enter,"..bg..",0");
	end

	local status, _, qid = pave.BGStatus(bg);

	if ( status == "confirm" ) then
		AcceptBattlefieldPort(qid, 1);
	end
end

function pave.Automate()

	if ( UnitIsGroupLeader("player") or pave.raidLeader == pave.playerName ) then

		if ( pave.automateBG < 1 ) then
			return	-- no bg's automate checked
		end

		local unqueued, queued, confirms, insides = pave.Tally(pave.automateBG);

		if ( queued == 0 and confirms == 0 and unqueued > 0 ) then
			-- put this here so checking automate right after manually queueing will work
			pave.waitUntilReady = false;
		end

		if ( pave.automating ) then

			if ( queued == 0 and confirms == 0 and unqueued > 0 ) then
				pave.RaidQueue(pave.automateBG);
				return
			end

			-- prevent leave queue spam, and prevent unwanted behavior if automate is quickly checked after user hits leave queue
			if ( pave.waitUntilReady ) then
				return
			end

			-- any confirms at all?
			if ( confirms > 0 ) then
				-- check if threshold met or everybody has a confirm
				if ( confirms >= pave.config.threshold or (unqueued == 0 and queued == 0) ) then
					-- send join signal
					pave.automating = false;
					_G["PreformAVEnablerAutomateCheckButton"..pave.automateBG]:SetChecked(0);

					if ( pave.config.debug ) then
						DEFAULT_CHAT_FRAME:AddMessage(" -- Sending signal to join "..pave.BG_NAME[pave.automateBG], 0, 1, 1);
						DEFAULT_CHAT_FRAME:AddMessage(" -- Automate disengaged", 0, 1, 1);
					end
					pave.RaidJoin(pave.automateBG);
				end
			end -- if there are confirms

		end -- if automate checked
	end -- if group/raid leader
end



---------------------------------------------------------------------------------
--	Events
---------------------------------------------------------------------------------

function pave.events.CHAT_MSG_ADDON(arg1, arg2, arg3, arg4)

	if ( arg1 ~= "PreformAVEnabler" ) then
		return
	end

	--[[
	if ( string.find(arg4, "-", 1, true) ) then
		arg4 = arg4:match("([^%-]+)");
	end
	]]

	local opCode = string.sub(arg2, 1, 1);
	if ( pave.opCodes[opCode] ) then
		pave.opCodes[opCode].input(arg4, string.sub(arg2, 2));
	end

	if ( arg4 == pave.playerName ) then
		pave.sendStatusNextRoster = false;		-- set this false after we receive our own msg to help ensure transmission
		pave.skipRosterUpdate = true;
	end
end

function pave.events.PLAYER_ENTERING_WORLD()

	RegisterAddonMessagePrefix("PreformAVEnabler");

	pave.SetPlayerQueueStatus();
	pave.Update();

	if ( pave.IsInsideBG() ) then

		if ( pave.config.debug ) then
			local status, id, qid;
			for i in ipairs(pave.BG_NAME) do
				status, id, qid = pave.BGStatus(i);
				DEFAULT_CHAT_FRAME:AddMessage(pave.BG_NAME[i].." status: "..status..";  ID: "..id..";  QID: "..qid, 0, 1, 1);
			end
		end

		StaticPopup_Hide("PREFORM_CONFIRM_BATTLEFIELD_ENTRY");
		pave.SendStatus();

		if ( PreformAVEnablerMember1Button ) then
			for i = 1, 40 do
				_G["PreformAVEnablerMember"..i.."Button"]:Disable();
			end
		end

		return;		-- don't want to GetMembers() inside a bg
	else
		pave.sendStatusNextRoster = true;
	end

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("PLAYER_ENTERING_WORLD", 0, 1, 1);
	end

	if ( PreformAVEnablerMember1Button ) then
		for i = 1, 40 do
			_G["PreformAVEnablerMember"..i.."Button"]:Enable();
		end
	end

end

function pave.events.GROUP_ROSTER_UPDATE()

	if ( pave.IsInsideBG() ) then
		return
	end

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("GROUP_ROSTER_UPDATE", 0, 1, 1);
	end

	pave.GetMembers();

	if ( pave.sendStatusNextRoster ) then
		if ( pave.skipRosterUpdate ) then
			pave.skipRosterUpdate = false;
		else
			pave.SendStatus();
		end
		--pave.sendStatusNextRoster = false;		-- set this false after we receive our own msg to help ensure transmission
	end
end

function pave.events.UPDATE_BATTLEFIELD_STATUS()

	local status, id, qid;

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("UPDATE_BATTLEFIELD_STATUS event", 0, 1, 1);
	end

	for i = 1, pave.NUM_BGS do
		status, id, qid = pave.BGStatus(i);

		pave.playerStatus.queues[i].id = id;

		if ( status == "confirm" ) then
			--DEFAULT_CHAT_FRAME:AddMessage("got BG "..id);
			if ( pave.playerStatus.queues[i].state ~= 2 ) then
				pave.playerStatus.queues[i].state = 2;
				pave.playerStatus.queues[i].time = GetTime();

				pave.CompactColumn(i);
			end

			if ( pave.playerStatus.queues[i].isLeaderQueued ) then
				pave.HidePopup(qid);
			end

			pave.SendStatus("bg", i);

		elseif ( status == "queued" ) then

			if ( pave.playerStatus.queues[i].state ~= 1 ) then
				pave.playerStatus.queues[i].time = GetTime();
				pave.playerStatus.queues[i].state = 1;
				pave.SendStatus("bg", i);

				pave.CompactColumn(i);
			end

			if ( pave.config.hideColumn[i] and pave.playerStatus.queues[i].isLeaderQueued ) then
				pave.ShowBGColumn(i);
			end

		elseif ( status == "active" ) then
			if ( pave.config.debug ) then
				DEFAULT_CHAT_FRAME:AddMessage(pave.BG_NAME[i].." ACTIVE", 0, 1, 1);
			end
			if ( pave.playerStatus.queues[i].state ~= 3 ) then
				pave.playerStatus.queues[i].time = GetTime();
				pave.playerStatus.queues[i].state = 3;
				pave.SendStatus("bg", i);

				pave.CompactColumn(i);
			end

		elseif ( status == "none" ) then
			-- this qid not queued for or inside a BG

			if ( pave.playerStatus.queues[i].state ~= 0 ) then
				if ( pave.config.debug ) then
					DEFAULT_CHAT_FRAME:AddMessage(pave.BG_NAME[i].." status == none", 0, 1, 1);
				end
				pave.playerStatus.queues[i].state = 0;
				pave.playerStatus.queues[i].time = 0;
				pave.playerStatus.queues[i].isLeaderQueued = nil;
				pave.SendStatus("bg", i);

				pave.CompactColumn(i);

				StaticPopup_Hide("PREFORM_LEAVE_CONFIRM", qid);
			end
		end
	end
end

function pave.events.PVPQUEUE_ANYWHERE_SHOW()

	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("PVPQUEUE_ANYWHERE_SHOW", 0, 1, 1);
	end

	if ( pave.anywhereQueueBG ) then

		JoinBattlefield(0);

		pave.anywhereQueueBG = nil;
	end
end

function pave.events.PLAYER_REGEN_ENABLED()
	pave.SetMemberFrames();
end

function pave.events.PARTY_INVITE_REQUEST()
	pave.newGroup = true;
	if ( pave.config.debug ) then
		DEFAULT_CHAT_FRAME:AddMessage("PARTY_INVITE_REQUEST", 0, 1, 1);
	end
end

function pave.events.UNIT_CONNECTION(unit)

	name = pave.UnitName(unit);

	if ( pave.memberStatus[name] ) then

		local online = UnitIsConnected(unit);

		if ( pave.memberStatus[name].online and not online ) then

			-- newly offline
			pave.memberStatus[name].offlineTime = GetTime();

		elseif ( not pave.memberStatus[name].online and online ) then

			-- newly online
			pave.memberStatus[name].offlineTime = 0;
		end

		pave.memberStatus[name].online = online;
	end
end

function pave.events.UNIT_NAME_UPDATE(unit)

	if ( (not UnitInRaid(unit) and not UnitInParty(unit)) or pave.IsInsideBG() ) then
		return
	end

	pave.GetMembers();
end


---------------------------------------------------------------------------------
--	Command Line
---------------------------------------------------------------------------------

function pave.CmdLine(param)

	local args = {};

	for arg in string.gmatch( param, "(%S+)") do
		table.insert(args, arg);
	end

	if ( args[1] == "debug" ) then
		if ( pave.config.debug ) then
			pave.config.debug = false;
			DEFAULT_CHAT_FRAME:AddMessage("Debug mode off");
		else
			pave.config.debug = true;
			DEFAULT_CHAT_FRAME:AddMessage("Debug mode on");
		end

	elseif ( args[1] == "reset" ) then
		PreformAVEnablerFrame:ClearAllPoints();
		PreformAVEnablerFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 200, -100);

	elseif ( args[1] == "autocompact" ) then
		if ( pave.config.autoCompact ) then
			pave.config.autoCompact = false;
			DEFAULT_CHAT_FRAME:AddMessage("Autocompact off");
		else
			pave.config.autoCompact = true;
			DEFAULT_CHAT_FRAME:AddMessage("Autocompact on");
		end

	elseif ( args[1] == "help" or param == "?" ) then
		DEFAULT_CHAT_FRAME:AddMessage("/preformav -- display the window");
		DEFAULT_CHAT_FRAME:AddMessage("/preformav reset -- reset the position of the window");
		DEFAULT_CHAT_FRAME:AddMessage("/preformav redraw <number> -- set the redraw rate of the window.  Possible values are 0.1 to 10 (current value: "..pave.config.redrawRate..")");
		DEFAULT_CHAT_FRAME:AddMessage("/preformav debug -- toggle the display of debug information");
		DEFAULT_CHAT_FRAME:AddMessage("/preformav autocompact -- toggle the autocompacting of columns");


	elseif ( args[1] == "redraw" ) then
		if (	tonumber(args[2] or "")
			and tonumber(args[2]) >= 0.1 and tonumber(args[2]) <= 10
		) then
			pave.config.redrawRate = tonumber(args[2]);
			DEFAULT_CHAT_FRAME:AddMessage("Redraw rate set to "..pave.config.redrawRate);
		else
			DEFAULT_CHAT_FRAME:AddMessage("Enter a value between 0.1 and 10");
		end
	else
		pave.ShowMasterFrame();
	end
end
