local MessageQueue = {};
SGI.ForceStop = {};

CreateFrame("Frame", "SGI_MESSAGE_TIMER");
SGI_MESSAGE_TIMER.update = 0;
SGI_MESSAGE_TIMER:SetScript("OnUpdate", function()
	if (SGI_MESSAGE_TIMER.update < GetTime()) then
		
		for i = 1,5 do
			local key, messageToBeSent = next(MessageQueue);
		
			if (key and messageToBeSent) then
				if (SGI.ForceStop[messageToBeSent.receiver]) then
					MessageQueue[key] = nil;
					SGI.ForceStop[messageToBeSent.receiver] = nil;
					SGI:debug("Forced sendstop!");
					return;
				end
				SendAddonMessage(ID_MASSLOCK, messageToBeSent.msg, "WHISPER", messageToBeSent.receiver);
				MessageQueue[key] = nil;
				SGI:debug("Send AddonMessage ("..messageToBeSent.msg..") to "..messageToBeSent.receiver);
			
			end
		end
		SGI_MESSAGE_TIMER.update = GetTime() + 2;
	end
end)

local function AddMessage(message, receiver)
	local newMessage = {
		msg = message,
		receiver = receiver,
	};
	tinsert(MessageQueue, newMessage);
end

function SGI:StopMassShare(player)
	SGI.ForceStop[player] = true;
end

function SGI:IsSharing(player)
	for key, message in pairs(MessageQueue) do
		if (message[key].receiver == player) then
			return true;
		end
	end
end

local function RemoveLock(name)
	SGI_DATA.lock[name] = nil;
end

function SGI:IsLocked(name)
	return SGI_DATA.lock[name];
end

function SGI:LockPlayer(name)
	if (not SGI:IsLocked(name)) then
		SGI_DATA.lock[name] = tonumber(date("%m"));
	end
end

function SGI:UnlockPlayer(name)
	RemoveLock(name);
end

function SGI:ShareLocks(name)
	local part = ID_MASSLOCK;
	
	for k,_ in pairs(SGI_DATA.lock) do
		if (strlen(part..":"..k) > 250) then
			AddMessage(part, name);
			part = ID_MASSLOCK;
		end
		part = part..":"..k;
	end
	
	AddMessage(part, name);
end

function SGI:ReceivedNewLocks(rawLocks)
	local locks = SGI:divideString(rawLocks, ":");
	
	for k,_ in pairs(locks) do
		SGI:LockPlayer(locks[k]);
	end
	SGI:debug("Received locks!");
end

function SGI:RemoveOutdatedLocks()
	local month = tonumber(date("%m"));
	
	for k,_ in pairs(SGI_DATA.lock) do
		if (month - 1) > SGI_DATA.lock[k] or (month < SGI_DATA.lock[k] and month > 1) then
			RemoveLock(k);
		end
	end
	
end














SGI:debug(">> Blacklist.lua");