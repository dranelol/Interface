ParryHaste = LibStub("AceAddon-3.0"):NewAddon("ParryHaste", "AceConsole-3.0", "AceEvent-3.0")

local channels = {
 [1] = "SAY",
 [2] = "YELL",
 [3] = "GUILD",
 [4] = "EMOTE",
 [5] = "RAID",
 [6] = "RAID_WARNING",
 [7] = "PARTY",
 [8] = "Chat Pannel"
}

local function defaulttable()
	local tabl = {
		add = {
			type = "input",
			name = "Add a monster",
			set = function(info, value)
					ParryHaste.db.realm.monsters[value] = 1; 
					ParryHaste:SetupMonsters();
				end,
			order = 0,
		},	
	}
	return tabl
end

local globalchannels = {
	[0] = "Disabled"}

local options = { 
    name = "ParryHaste",
    handler = ParryHaste,
    type = "group",
    args = {
        toggle = {
            type = "toggle",
            name = "On/Off",
            desc = "Enable or disable announcing in this addon.",
            --usage = "<Your message>",
            get = "GetEnabled",
            set = "SetEnabled",
        },
        omsg = {
        	type = "group",
        	name = "Output Message",
        	order = 1,
        	args = { 
				msg = {
					type = "input",
					name = "Output Message",
					desc = "Put your output message here.",
					get = "GetMessage",
					set = "SetMessage",
					width = "full",
					multiline = true;
				},
				text = {
					type = "description",
					name = "This is the message that will be outputted to chat. MONSTER is replaced by the monster's name, and PLAYER is replaced with the player who got parried.",
				},					
			},
		},
        channels = {
        	type = "group",
        	name = "Output Channels",
        	order = 2,
        	args = {
        		gchannels = {
        			type = "select",
        			name = "Global Channel",
        			values = globalchannels,
        			get = "GetGChannel",
        			set = "SetGChannel",
        			order = 99
        			}
        		},
        	},
        monsters = {
        	type = "group",
        	name = "Monsters to Watch",
        	order = 3,
        	args = defaulttable()
        },
    },
}

local monsters = {
			["Halion"] = 1,
}

local defaults = {
   realm = {
		enabled = true,
		parrymsg = "<<PARRY>> MONSTER parried PLAYER!",
		chans = {
			["SAY"] = false,
			["YELL"] = false,
			["GUILD"] = false,
			["EMOTE"] = false,
			["RAID"] = false,
			["RAID_WARNING"] = false,
			["PARTY"] = false,
			["Chat Pannel"] = true,
		},
		gchannel = 0,
		monsters = {},
    },
}

local curchanlist = {};

function ParryHaste:UpdateChatChannels()
    local list = {GetChannelList()}
    --GetChannelList returns a table with the number of a channel in one
    --key/value pair, and the name of that channel in the next key/num
    --pair. It's really annoying.
    tempnum = 0;
    curchanlist = nil
    curchanlist = {}
	for i,v in ipairs(list) do
		if i%2 == 1 then
			tempnum = v
		else
			globalchannels[tempnum] = tempnum .. ": " .. v;
			curchanlist[tempnum] = true;
		end
	end
end

function ParryHaste:GetMessage(info)
	return ParryHaste.db.realm.parrymsg
end

function ParryHaste:GetGChannel(info)
	return ParryHaste.db.realm.gchannel
end

function ParryHaste:SetGChannel(info, v)
	self.db.realm.gchannel = v
end

function ParryHaste:SetMessage(info, newmsg)
	self.db.realm.parrymsg = newmsg
end

function ParryHaste:GetEnabled(info)
    return ParryHaste.db.realm.enabled
end

function ParryHaste:SetEnabled(info)
    self.db.realm.enabled = not self.db.realm.enabled
end

function ParryHaste:SetupMonsters()
	options.args.monsters.args = defaulttable();
	for k,v in pairs(ParryHaste.db.realm.monsters) do
		if v == 1 then
			options.args.monsters.args[k] = {
				type = "group",
				name = k,
				args = {
					name = {
						type = "header",
						name = k,
						order = 1,
					},
					delete = {
						name = "Delete",
						type = "execute",
						func =  function() 
							ParryHaste.db.realm.monsters[k] = 0; 
							ParryHaste:SetupMonsters();
							end,
						order = 2
					}
				},
			}
		end
	end
end

function ParryHaste:OnInitialize()

    self.db = LibStub("AceDB-3.0"):New("PHasteDB", defaults, "Default");
    self.UpdateChatChannels()
    
    for i,s in ipairs(channels) do 
		options.args.channels.args[s] = {
        	type = "toggle",
        	name = s,
        	get = function(info) 
        		return self.db.realm.chans[s];
        	end,
        	set = function(info)
        		self.db.realm.chans[s] = not self.db.realm.chans[s];
        	end,
        	order = i
        }
	end
	if self.db.realm.monsters["Halion"] == nil then
		self.db.realm.monsters = monsters;
	end
--	self:SetupMonsters()

    LibStub("AceConfig-3.0"):RegisterOptionsTable("ParryHaste", options, {"ParryHaste", "ph"});
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ParryHaste", "ParryHaste");

end

function ParryHaste:CHANNEL_UI_UPDATE()
    self:UpdateChatChannels()
end

function ParryHaste:OnEnable()
    self:Print("Hi! :o)");
    self:UpdateChatChannels()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("CHANNEL_UI_UPDATE")
	self.SetupMonsters()
end

function ParryHaste:OnDisable()
    self:Print("Disabled");
end

function ParryHaste:COMBAT_LOG_EVENT_UNFILTERED(...)--arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg10, arg12, arg13)
	local event, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = select(1, ...)

	if eventType == "SWING_MISSED" or eventType == "SPELL_MISSED" or eventType == "SPELL_PERIODIC_MISSED" then
		local missType = select(13, ...)
		if self.GetEnabled() then
			if missType == "PARRY" and self.db.realm.monsters[destName] == 1 then
				pmsg = string.gsub(self.db.realm.parrymsg, "MONSTER", destName)
				pmsg = string.gsub(pmsg, "PLAYER", sourceName)
				for i,c in ipairs(channels) do
					skip = false;
					if c == "GUILD" and IsInGuild() == nil then
						skip = true;
					end
					if c == "RAID_WARNING" and IsRaidLeader() == nil then
						skip = true;
					end
					if c == "RAID" and GetNumRaidMembers() == 0 then
						skip = true;
					end
					if c == "PARTY" and GetNumRaidMembers() == 0 and GetNumPartyMembers() == 0 then
						skip = true;
					end
					if c == "Chat Pannel" and self.db.realm.chans[c] then
						self:Print(pmsg);
						skip = true;
					end
					if self.db.realm.chans[c] and not skip then
						SendChatMessage(pmsg,c,nil,nil)
					end
				end
				if self.db.realm.gchannel ~= 0 and curchanlist[self.db.realm.gchannel] then
					SendChatMessage(pmsg,"CHANNEL",nil,self.db.realm.gchannel)
				end
			end
		end
	end
end 
