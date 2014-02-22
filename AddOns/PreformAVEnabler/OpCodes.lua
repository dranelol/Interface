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
--	Operation Codes
---------------------------------------------------------------------------------

pave.opCodes = {
	["a"] = {
		output = function(...)
			local msg = "a";
			local opCode;

			for i = 1, select("#", ...) do
				if ( msg ~= "a" ) then
					msg = msg.."|";
				end
				opCode = select(i, ...);
				msg = msg..pave.opCodes[opCode].output();
			end

			return msg;
		end,
		input = function(sender, data)

			if ( pave.config.debug and #pave.memberList < 4 ) then
				DEFAULT_CHAT_FRAME:AddMessage("<<< Status from "..sender..": "..data, 0, 1, 1);
			end

			local opCode;
			for piece in string.gmatch(data, "[^|]+") do
				opCode = string.sub(piece, 1, 1);
				if ( pave.opCodes[opCode] ) then
					pave.opCodes[opCode].input(sender, string.sub(piece, 2));
				end
			end
		end,
	},
	["d"] = {
		output = function()
			return "d"..pave.CheckDeserter();
		end,
		input = function(sender, arg)
			arg = tonumber(arg);
			if ( not arg ) then
				return
			end
			local status = pave.memberStatus[sender];
			if ( status ) then
				if ( arg == 0 ) then
					status.deserter = 0;
				else
					status.deserter = arg + GetTime();
				end
			end
		end,
	},
	["j"] = {
		output = function(bgID)
			return "j"..bgID;
		end,
		input = function(sender, arg)
			arg = tonumber(arg);
			if ( not arg or not pave.BG_NAME[arg] ) then
				return
			end

			if ( pave.IsLeader(sender) ) then

				if ( pave.BG_NAME[arg] ) then
					if ( pave.config.debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("Join "..pave.BG_NAME[arg].." signal seen", 0, 1, 1);
					end
					pave.Join(arg);
				end
			end
		end,
	},
	["k"] = {
		output = function()
			return "k";
		end,
		input = function(sender)
			if ( pave.config.debug ) then
				DEFAULT_CHAT_FRAME:AddMessage("Status check requested from "..sender, 0, 1, 1);
			end

			-- if got raid member data, but never a status update
			if ( pave.neverUpdated == 1 ) then
				-- 2 == do not request status update when we open the status window to reduce redundancy
				pave.neverUpdated = 2;
			end

			pave.SetPlayerQueueStatus();
			pave.SendStatus();
			pave.lastCheck = GetTime() + 3;		-- prevent spam
		end,
	},
	["l"] = {
		output = function(bg)
			return "l"..bg;
		end,
		input = function(sender, bg)

			if ( pave.IsLeader(sender) ) then

				if ( not bg ) then
					return;
				else
					bg = tonumber(bg);
				end

				if ( pave.BG_NAME[bg] ) then
					if ( pave.config.debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("Leave "..pave.BG_NAME[bg].." queue signal seen", 0, 1, 1);
					end

					pave.SoloLeaveQueue(bg);
				end
			end

		end,
	},
	["q"] = {
		output = function(bgID)
			return "q"..bgID;
		end,
		input = function(sender, bgID)

			bgID = tonumber(bgID);
			if ( not bgID or not pave.BG_NAME[bgID] ) then
				return;
			end

			if ( pave.IsLeader(sender) ) then

				if ( pave.BG_NAME[bgID] ) then
					if ( pave.config.debug ) then
						DEFAULT_CHAT_FRAME:AddMessage("Queue "..pave.BG_NAME[bgID].." signal seen", 0, 1, 1);
					end
					pave.SoloQueue(bgID);
				end
			end
		end,
	},
	["r"] = {
		output = function()
			return "r"..GetCombatRating(16)..","..GetPersonalRatedBGInfo()..","..floor(GetAverageItemLevel());
		end,
		input = function(sender, data)
			local args = {};
			for arg in string.gmatch( data, "([^,]+)") do
				table.insert(args, arg);
			end

			local status = pave.memberStatus[sender];
			if ( not status ) then
				return;
			end

			if ( args[1] ) then
				status.resilience = args[1];
			end
			if ( args[2] ) then
				status.rating = args[2];
			end
			if ( args[3] ) then
				status.avgiLevel = args[3];
			end
		end,
	},
	["s"] = {
		output = function()
			return;
		end,
		input = function(sender, msg)
			
			-- status from a 2.x user
			local bg;
			local args = {};
			for arg in string.gmatch( string.sub(msg, 2), "([^,]+)") do
				table.insert(args, arg);
			end

			if ( args[1] == "atuscheck" ) then
				return;
			end

			if ( pave.config.debug and #pave.memberList < 4 ) then
				DEFAULT_CHAT_FRAME:AddMessage("--> Status from 2.x user: "..sender.."; "..msg, 0, 1, 1);
			end

			if ( not args[2] or not args[3] ) then
				return
			end
			for i = 1, #args do
				args[i] = tonumber(args[i]);
			end

			if ( not pave.memberStatus[sender] ) then
				return;
			end

			pave.memberStatus[sender].version = args[1]; -- version
			pave.isEntireRaidV3 = false;

			if ( args[3] > 0 ) then
				pave.memberStatus[sender].deserter = args[3] + GetTime(); -- deserter
			end

			-- status of every BG
			for i = 4, (4 + pave.NUM_BGS * 3), 3 do
				if ( args[i] and args[i+1] and args[i+2] and pave.memberStatus[sender].queues[args[i]] ) then
					pave.memberStatus[sender].queues[args[i]].state = args[i+1];
					pave.memberStatus[sender].queues[args[i]].time = GetTime();
				end
			end

			pave.PaintWindow();
			pave.Automate();
		end,
	},
	--[[
	["c"] = {
		output = function()
			return "c"..();
		end,
		input = function(sender, arg)
			arg = tonumber(arg);
			if ( not arg ) then
				return
			end
			local status = pave.memberStatus[sender];
			if ( status ) then
				status.spec = arg;
			end
		end,
	},
	]]
	["u"] = {
		output = function(bg)
			if ( bg ) then
				return "u"..bg..","..pave.playerStatus.queues[bg].state;
			else
				local msg = "";
				for i = 1, pave.NUM_BGS do
					if ( i > 1 ) then
						msg = msg.."|";
					end
					msg = msg.."u"..i..","..pave.playerStatus.queues[i].state;
				end
				return msg;
			end
		end,
		input = function(sender, data)

			-- is this from a 2.x user?
			if ( string.sub(data, 2, 1) == "," ) then
				data = string.sub(data, 2);
			end

			local bgID, state = string.match( data, "(%d+),(%d+)");
			local status = pave.memberStatus[sender];

			if ( not status ) then
				if ( pave.config.debug ) then
					DEFAULT_CHAT_FRAME:AddMessage("Error: Player "..sender.." not in memberStatus list", 0, 1, 1);
				end
				return;
			end
			
			bgID = tonumber(bgID);
			state = tonumber(state);

			if ( not status.queues[bgID] ) then
				if ( pave.config.debug ) then
					DEFAULT_CHAT_FRAME:AddMessage("Error: Player "..sender.." sent invalid u opCode msg: "..data, 0, 1, 1);
				end
				return
			end
			if ( not state or state < 0 or state > 3 ) then
				if ( pave.config.debug ) then
					DEFAULT_CHAT_FRAME:AddMessage("Error: Player "..sender.." sent invalid u opCode msg: "..data, 0, 1, 1);
				end
				return
			end

			-- if state change; do nothing otherwise
			if ( status.queues[bgID].state ~= state ) then

				status.queues[bgID].state = state;
				status.queues[bgID].time = GetTime();

				if ( pave.config.debug and #pave.memberList < 4 ) then
					DEFAULT_CHAT_FRAME:AddMessage("<< "..sender.."'s queue state for "..pave.BG_NAME[bgID]..": "..state, 0, 1, 1);
				end

				pave.CompactColumn(bgID);
			end
			status.lastUpdate = GetTime();

			pave.PaintWindow();
			-- set leader buttons and handle automate if player is leader
			pave.Automate();
		end
	},
	["v"] = {
		output = function()
			return "v"..pave.version;
		end,
		input = function(sender, arg)
			arg = tonumber(arg);
			if ( not arg ) then
				return
			end
			local status = pave.memberStatus[sender];
			if ( status ) then
				status.version = arg;
				if ( arg < 3 and arg > 0 ) then
					pave.isEntireRaidV3 = false;
				end
			end
		end,
	},
};

function pave.SendOpCode(msg)

	--[[
	if ( GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 ) then
		SendAddonMessage("PreformAVEnabler", msg, "RAID");
	else
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Error: GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0 while trying to transmit to raid", 0, 1, 1);
		end
	end
	]]

	if ( GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0 ) then

		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Error: GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0 while trying to transmit to raid", 0, 1, 1);
		end

		return
	end

	if ( pave.isInRaid ) then
		SendAddonMessage("PreformAVEnabler", msg, "RAID");
	else
		SendAddonMessage("PreformAVEnabler", msg, "PARTY");
	end
end

function pave.SendStatus(type, bg)

	if ( not pave.playerStatus ) then
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("Error: SendStatus() before .playerStatus set", 0, 1, 1);
		end
		return;
	end

	local msg;

	if ( type == "bg" and bg ) then
		msg = pave.opCodes["u"].output(bg);
	else
		-- full status

		pave.playerStatus.deserter = pave.CheckDeserter();

		msg = pave.opCodes["a"].output( "v", "d", "r", "u" );
	end

	-- if this status message is the same as the last one sent, and not two seconds have passed, then don't send
	if ( pave.lastStatus == msg and pave.lastStatusTime > GetTime() ) then
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage("SendStatus() failed: duplicate msg within 2 seconds", 0, 1, 1);
		end
		return
	end

	pave.lastStatusTime = GetTime() + 2;	-- do not send redundant messages within two seconds
	pave.lastStatus = msg;

	if ( pave.config.debug ) then
		local debugMsg;

		if ( type == "bg" ) then
			debugMsg = " >>> Sending "..pave.BG_NAME[bg].." status: "..msg;
		elseif ( type == "frame" ) then
			debugMsg = " >>> Sending frame status: "..msg;
		else
			debugMsg = " >>> Sending my status: "..msg;
		end
		DEFAULT_CHAT_FRAME:AddMessage(debugMsg, 0, 1, 1);
	end

	pave.SendOpCode(msg);
end

function pave.RequestStatus()

	pave.SendOpCode(pave.opCodes["k"].output());

	-- check for people in the raid who may be 2.x users and send its version of a status request
	for _, name in ipairs(pave.memberList) do

		if ( pave.memberStatus[name].version == -1 or not pave.isEntireRaidV3 ) then

			pave.SendOpCode("statuscheck");
			return;
		end
	end
end
