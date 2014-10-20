-- Format: ["SYSTEM"] = { pattern1, pattern2, pattern3, ...}
local messagesToHide = {
	ERR_GUILD_INVITE_S,
	ERR_GUILD_DECLINE_S,
	ERR_ALREADY_IN_GUILD_S,
	ERR_ALREADY_INVITED_TO_GUILD_S,
	ERR_GUILD_DECLINE_AUTO_S,
	ERR_GUILD_PLAYER_NOT_FOUND_S,
	ERR_CHAT_PLAYER_NOT_FOUND_S,
}

local RealmCleanup = {
	ERR_CHAT_PLAYER_NOT_FOUND_S,
}

local chatFilters = {}
local OnInt = {}
local WhisperFilterActive = false;

local function check(msg)
	local place
	local n
	local name
	for k,_ in pairs(messagesToHide) do
		place = strfind(messagesToHide[k],"%s",1,true)
		if place then
			name = strfind(msg," ",place,true)
			if name then
				n = strsub(msg,place,name-1)
				if format(messagesToHide[k],n) == msg then
					return true
				else
					n = strsub(msg,place,name-2)
					if format(messagesToHide[k],n) == msg then
						return true
					end
				end
			end
		end
	end
end

local function check2(msg)
	local place
	local n
	local name
	for k,_ in pairs(RealmCleanup) do
		place = strfind(RealmCleanup[k],"%s",1,true)
		if place then
			name = strfind(msg," ",place,true)
			if name then
				n = strsub(msg,place,name-1)
				if format(RealmCleanup[k],n) == msg then
					return true
				else
					n = strsub(msg,place,name-2)
					if format(RealmCleanup[k],n) == msg then
						return true
					end
				end
			end
		end
	end
end

local function HideOutWhispers(self, event, msg, sender)
	if (sender == UnitName("player")) then
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
		SGI:debug("Blocked outgoing whisper!");
		return true;
	end
end

local function HideSystemMessage(self, event, msg)
	if (check(msg)) then
		SGI:debug("Blocked message: "..msg);
		return true;
	end
end

local function HideRealmConflictMessage(self, event, msg)
	if (check2(msg)) then
		SGI:debug("Blocked message: "..msg.." from check2()");
		return true;
	end
end

ChatIntercept = {}
function ChatIntercept:StateSystem(on)
	if (on) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", HideSystemMessage);
		print("|cffffff00ChatIntercept [|r|cff16ABB5System Messages|r|cffffff00] is now |r|cff00ff00ACTIVE|r");
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", HideSystemMessage);
		print("|cffffff00ChatIntercept [|r|cff16ABB5System Messages|r|cffffff00] is now |r|cffff0000INACTIVE|r");
	end
end

function ChatIntercept:StateRealm(state)
	if (state) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", HideRealmConflictMessage);
		SGI:debug("Blocking realm conflict messages");
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM",HideRealmConflictMessage);
		SGI:debug("Not blocking realm conflict messages");
	end
end

function ChatIntercept:StateWhisper(on)
	WhisperFilterActive = on;
	if (on) then
		--ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
		print("|cffffff00ChatIntercept [|r|cff16ABB5Whispers|r|cffffff00] is now |r|cff00ff00ACTIVE|r");
	else
		--ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
		print("|cffffff00ChatIntercept [|r|cff16ABB5Whispers|r|cffffff00] is now |r|cffff0000INACTIVE|r");
	end
end

function ChatIntercept:InterceptNextWhisper()
	if (WhisperFilterActive) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", HideOutWhispers);
	end
end