local function ProcessSystemMsg(msg)
	local place = strfind(ERR_GUILD_INVITE_S,"%s",1,true)
	if (place) then
		local n = strsub(msg,place)
		local name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_INVITE_S,name) == msg then
			return "invite",name
		end
	end
	
	place = strfind(ERR_GUILD_DECLINE_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_DECLINE_S,name) == msg then
			return "decline",name
		end
	end
	
	place = strfind(ERR_ALREADY_IN_GUILD_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_ALREADY_IN_GUILD_S,name) == msg then
			return "guilded",name
		end
	end
	
	place = strfind(ERR_ALREADY_INVITED_TO_GUILD_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_ALREADY_INVITED_TO_GUILD_S,name) == msg then
			return "already",name
		end
	end
	
	place = strfind(ERR_GUILD_DECLINE_AUTO_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_DECLINE_AUTO_S,name) == msg then
			return "auto",name
		end
	end
	
	place = strfind(ERR_GUILD_JOIN_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-1)
		if format(ERR_GUILD_JOIN_S,name) == msg then
			return "join",name
		end
	end
	
	place = strfind(ERR_GUILD_PLAYER_NOT_FOUND_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-2)
		if format(ERR_GUILD_PLAYER_NOT_FOUND_S,name) == msg then
			return "miss",name
		end
	end
	
	place = strfind(ERR_CHAT_PLAYER_NOT_FOUND_S,"%s",1,true)
	if (place) then
		n = strsub(msg,place)
		name = strsub(n,1,(strfind(n,"%s") or 2)-2)
		if format(ERR_CHAT_PLAYER_NOT_FOUND_S,name) == msg then
			return "out",name
		end
	end
	
	return "unregistered message", "N/A";
end

function SGI:SystemMessage(event,_,message,...)

	local type, name = ProcessSystemMsg(message);
	SGI:debug("Type: "..type.." Name: "..name);
	
	if (type == "invite") then
		if (SGI:IsRegisteredForWhisper(name)) then
			SGI:SendWhisper(SGI:FormatWhisper(SGI:PickRandomWhisper(), name), name, 1);
		end
	elseif (type == "decline") then
		SGI:UnregisterForWhisper(name);
	elseif (type == "auto") then
		SGI:LockPlayer(name);
		SGI:UnregisterForWhisper(name);
	elseif (type == "guilded") then
		SGI:LockPlayer(name);
		SGI:UnregisterForWhisper(name);
	elseif (type == "already") then
		SGI:LockPlayer(name);
		SGI:UnregisterForWhisper(name);
	elseif (type == "join") then
		
		if (CanEditOfficerNote()) then
			for i = 1,GetNumGuildMembers() do
				local n = GetGuildRosterInfo(i);
				if (n == name) then
					GuildRosterSetOfficerNote(i, date());
				end
			end
		elseif (CanEditPublicNote()) then
			for i = 1,GetNumGuildMembers() do
				local n = GetGuildRosterInfo(i);
				if (n == name) then
					GuildRosterSetPublicNote(i, date());
				end
			end
		end
		
	elseif (type == "miss") then
		if (SGI:IsSharing(name)) then
			SGI:StopMassShare(name);
			debug("Stopped mass share!");
		end
		SGI:print(format(SGI.L["Unable to invite %s. They will not be locked."],name));
		SGI:UnlockPlayer(name);
		SGI:UnregisterForWhisper(name);
	elseif (type == "out") then
		-- hmm...
		if (SGI:IsSharing(name)) then
			SGI:StopMassShare(name);
			debug("Stopped mass share!");
		end
		SGI:RemoveQueued(name);
	end

end

SGI:debug(">> System_Message.lua");