local ID_REQUEST = "SGI_REQ";
ID_MASSLOCK = "SGI_MASS";
local ID_LOCK = "SGI_LOCK";
local ID_SHIELD = "I_HAVE_SHIELD";
local ID_VERSION = "SGI_VERSION";
local ID_LIVE_SYNC = "SGI_LIVE_SYNC";
local ID_PING = "SGI_PING";
local ID_PONG = "SGI_PONG";
local ID_STOP = "SGI_STOP";
RegisterAddonMessagePrefix(ID_REQUEST);
RegisterAddonMessagePrefix(ID_LOCK);
RegisterAddonMessagePrefix(ID_SHIELD);
RegisterAddonMessagePrefix(ID_MASSLOCK);
RegisterAddonMessagePrefix(ID_VERSION);
RegisterAddonMessagePrefix(ID_LIVE_SYNC);
RegisterAddonMessagePrefix(ID_PING);
RegisterAddonMessagePrefix(ID_STOP);


function SGI:AddonMessage(event,...)
	local ID, msg, channel, sender = ...;
	if (not SGI_DATA[SGI_DATA_INDEX].debug and sender == UnitName("player")) then return end
	
	
	if (ID == ID_SHIELD) then
		SGI:LockPlayer(sender);
		SGI:RemoveShielded(sender);
		SGI:debug("SHIELD: "..ID.." "..msg.." "..sender);
	elseif (ID == ID_LOCK) then
		SGI:LockPlayer(sender);
		SGI:debug("LOCKING: "..ID.." "..msg.." "..sender);
	elseif (ID == ID_REQUEST) then
		SGI:ShareLocks(sender);
		SGI:debug("SHARING: "..ID.." "..msg.." "..sender);
	elseif (ID == ID_MASSLOCK) then
		SGI:ReceivedNewLocks(msg);
		SGI:debug("RECEIVING: "..ID.." "..msg.." "..sender);
	elseif (ID == ID_VERSION) then
		SGI:debug("VERSION: "..ID.." "..msg.." "..sender);
		local receivedVersion = msg;
		
		if (new == SGI:CompareVersions(SGI.VERSION_MAJOR, receivedVersion)) then
			SGI:print("|cffffff00A new version (|r|cff00A2FF"..new.."|r|cffffff00) of |r|cff16ABB5SuperGuildInvite|r|cffffff00 is available at curse.com!");
			if Alerter and not SGI.VERSION_ALERT_COOLDOWN then
				Alerter:SendAlert("|cffffff00A new version (|r|cff00A2FF"..new.."|r|cffffff00) of |r|cff16ABB5SuperGuildInvite|r|cffffff00 is available at curse.com!",1.5)
				SGI.VERSION_ALERT_COOLDOWN = true;
			end
		end
		
	elseif (ID == ID_LIVE_SYNC) then
		SGI:debug("LIVESYNC: "..ID.." "..msg.." "..sender);
		SGI:RemoveQueued(msg);
	elseif (ID == ID_STOP) then
		
	elseif (ID == ID_PING) then
		SGI:PingedByJanniie(sender);
	end
end

function SGI:LiveSync(player)
	SendAddonMessage(ID_LIVE_SYNC, player, "GUILD");
end

function SGI:BroadcastVersion(target)
	if (target == "GUILD") then
		SendAddonMessage(ID_VERSION, SGI.VERSION_MAJOR, "GUILD");
	else
		SendAddonMessage(ID_VERSION, SGI.VERSION_MAJOR, "WHISPER", target);
	end
end

function SGI:PingedByJanniie(sender)
	SendAddonMessage("SGI_PONG", SGI.VERSION_MAJOR, "WHISPER", sender);
end

function SGI:RequestSync()
	SendAddonMessage(ID_REQUEST, "", "GUILD");
end


SGI:debug(">> AddOn_Message.lua");
