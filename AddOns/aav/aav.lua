
atroxArenaViewer = LibStub("AceAddon-3.0"):NewAddon("atroxArenaViewer", "AceComm-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceSerializer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("atroxArenaViewer", false)

local M -- AAV_MatchStub
local T -- AAV_PlayStub
local timer -- playback timer
local queuetimer -- queue timer
local newversion = 0 -- prevent version check spam
local queue = {} -- messages at issue
local broadcasters = {} -- all broadcasters
local spectators = {} -- all spectators
local versions = {} -- all aav users
local initbroadcast = false -- whether a lookup has been sent
local currentstate = 1
local exportnum = 0
local currentbracket = nil
local tempbuffs = {} -- used for determining new buffs
local tempdebuffs = {} -- used for determining new debuffs
local exceptauras = { -- these auras won't be tracked
	32727,	-- Arena Preparation
}
----
-- reused for packet sending
local message = {
	["std"] = {}, -- used for standard sending
	["dude"] = {}, -- used for single dude data
	["dudes"] = {}, -- used for multiple dude data
	["stats"] = {}, -- used for end match stats
}


-------------------------
-- GLOBALS
-------------------------
AAV_VERSIONMAJOR = 1
AAV_VERSIONMINOR = 2
AAV_VERSIONBUGFIX = 6
AAV_UPDATESPEED = 60
AAV_AURAFULLINDEXSTEP = 1
AAV_INITOFFTIME = 0.5
AAV_QUEUESENDTIME = 0.1
AAV_MANATRESHOLD = 5
AAV_MINIMUM_COOLDOWN = 5
AAV_AURA_LONGLASTING = 180
AAV_MAX_AURASVISIBLE = 11

AAV_GUI_VERTICALFRAMEDISTANCE = 110
AAV_GUI_MAXCOMBATTEXTOBJECTS = 25
AAV_GUI_MAXUSEDSKILLSOBJECTS = 12
AAV_GUI_HEALTHBARHEIGHT = 16
AAV_GUI_MANABARHEIGHT = 5
AAV_GUI_UPDATEFRAME = CreateFrame("Frame")

AAV_COMBATTEXT_PERSISTENCE = 2.0
AAV_COMBATTEXT_FADETIME = 0.8
AAV_COMBATTEXT_CRITTIME = 0.5
AAV_COMBATTEXT_FRAMESPEED = 40
AAV_COMBATTEXT_ALPHASPEED = 3
AAV_COMBATTEXT_CRITSPEED = 30
AAV_COMBATTEXT_SCROLLINGTEXTFONTSIZE = 12
AAV_COMBATTEXT_SCROLLINGTEXTCRITPLUS = 26

AAV_USEDSKILL_PERSISTENCE = 6.0
AAV_USEDSKILL_FRAMESPEED = 60
AAV_USEDSKILL_ICONSPEED = 150
AAV_USEDSKILL_FADEINSPEED = 10
AAV_USEDSKILL_FADEOUTSPEED = 0.5
AAV_USEDSKILL_FADEOUTTIME = 2.0
AAV_USEDSKILL_FADEINTIME = 1
AAV_USEDSKILL_ICONSIZE = 25
AAV_USEDSKILL_ICONMARGIN = 3
AAV_USEDSKILL_ICONBUFFSIZE = 15

AAV_CROWD_FADEOUTTIME = 0.2
AAV_CROWD_FADEOUTSPEED = 10
AAV_CROWD_FADEINTIME = 0.5
AAV_CROWD_FADEINSPEED = 10

AAV_CC_ICONSIZE = 15
AAV_CC_ICONMARGIN = 1
AAV_CC_ICONSPEED = 150
AAV_CC_FADEINTIME = 0.5
AAV_CC_FADEINSPEED = 10
AAV_CC_FADEOUTTIME = 0.25
AAV_CC_FADEOUTSPEED = 10
AAV_CC_MAXLISTING = 5

AAV_DETAIL_ENTRYHEIGHT = 20
AAV_DETAIL_ENTRYWIDTH = 560

AAV_COMM_LOOKUPBROADCAST = "AAVLookup"
AAV_COMM_HANDLEMATCHDATA = "AAVHandle"

AAV_COMM_EVENT = {
	["cmd_versioncheck"]		= 1,
	["cmd_broadcaststart"]		= 2,
	["cmd_broadcaststop"]		= 3,
	["cmd_status"]				= 4,
	["cmd_connect"]				= 5,
	["cmd_accept"]				= 6,
	["cmd_matchend"]			= 7,
	["cmd_newmatch"]			= 8,
	["cmd_updateplayer"]		= 9,
	["cmd_updateallplayers"]	= 10,
	["cmd_spectatorstop"]		= 11,
}

AAV_COMM_MAPS = {
	[0] = L.ARENA_UNKNOWN,
	[1] = L.ARENA_NAGRAND,
	[2] = L.ARENA_LORDAERON,
	[3] = L.ARENA_BLADEEDGE,
	[4] = L.ARENA_DALARAN,
	[5] = L.ARENA_VALOR,
	[6] = L.ARENA_TOLVIR,
}

StaticPopupDialogs["AAV_EXPORT_DIALOG"] = {
	text = "Copy this export string.",
	button1 = "OK",
	hasEditBox = true,
	OnShow = function (s, d)
		s.editBox:SetText(atroxArenaViewer:getExportString(exportnum))
		s.editBox:HighlightText(0)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

StaticPopupDialogs["AAV_PLAYOLDMATCHES_DIALOG"] = {
	text = L.ERROR_OLDMATCHES,
	button1 = "Ok",
	timeout = 0,
	hideOnEscape = true,
}



function atroxArenaViewer:OnInitialize()
	
	atroxArenaViewerData = atroxArenaViewerData or {
		defaults = {
			profile = {
				update = 0.1,
				interval = 0.1,
				minimapx = -54.6,
				minimapy = 58.8,
				hpbartexture = "oCB",
				manabartexture = "oCB",
				broadcastannounce = true, --broadcast announce
				healthdisplay = 3, -- deficit percentage
				shortauras = true, -- don't exceed debuff buff bar
				uniquecolor = false, -- use class color as hp bar
			}
		}
	}
	atroxArenaViewerData.current = {
		inArena = false,
		inFight = false,
		entered = 0,
		time = 0,
		move = 0,
		broadcast = false,
		record = true,
		listening = "",
		interval = 0.1,
		update = 0.1,
		communication = "GUILD",
	}
    
    local minimap = AAV_Gui:createMinimapIcon(self)
    
    print("AAV v"..AAV_VERSIONMAJOR.."."..AAV_VERSIONMINOR.."."..AAV_VERSIONBUGFIX.. " " .. L.AAV_LOADED)
    
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
    
end


function atroxArenaViewer:OnEnable()

	RegisterAddonMessagePrefix(AAV_COMM_LOOKUPBROADCAST)
    RegisterAddonMessagePrefix(AAV_COMM_HANDLEMATCHDATA)

    self:RegisterComm(AAV_COMM_LOOKUPBROADCAST, "lookupBroadcast")
    self:RegisterComm(AAV_COMM_HANDLEMATCHDATA, "handleMatchData")
    
    local msg = {
		event = AAV_COMM_EVENT["cmd_versioncheck"],
		major = AAV_VERSIONMAJOR,
		minor = AAV_VERSIONMINOR,
		bugfix = AAV_VERSIONBUGFIX,
    }
    
    self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(msg), self:getCommMethod(), nil)
    
end

function atroxArenaViewer:getBroadcasters()
	return broadcasters
end

----
-- searches for running broadcasts over the guild distribution.
function atroxArenaViewer:lookup()
	for k,v in pairs(broadcasters) do
		self:giveBroadcasterFound(k, v.version)
	end
end

----
-- returns the method which the communication is chosen to.
-- @return "GUILD" or "RAID"
function atroxArenaViewer:getCommMethod()
	return atroxArenaViewerData.current.communication
end

----
-- used for broadcasts. if message contains the player's name, then stream will be listed.
-- @param prefix addon prefix
-- @param msg delivered msg
-- @param dist channel
-- @param sender player
function atroxArenaViewer:lookupBroadcast(prefix, msg, dist, sender)
	local b, sd = self:Deserialize(msg)
	
	if (b and sd.event == AAV_COMM_EVENT["cmd_versioncheck"]) then
	-- VERSION CHECK
		
		local version = nil
		versions[sender] = sd
		
		if (sd.major > AAV_VERSIONMAJOR) then 
			version = sd.major .. "." .. sd.minor .. "." .. sd.bugfix
		else
			if (sd.minor > AAV_VERSIONMINOR and sd.major >= AAV_VERSIONMAJOR) then
				version = AAV_VERSIONMAJOR .. "." .. sd.minor .. "." .. sd.bugfix
			else
				if (sd.bugfix > AAV_VERSIONBUGFIX and sd.major >= AAV_VERSIONMAJOR and sd.minor >= AAV_VERSIONMINOR) then
					version = AAV_VERSIONMAJOR .. "." .. AAV_VERSIONMINOR .. "." .. sd.bugfix
				end
			end
		end
		if (version and version ~= newversion) then
			newversion = version
			print("|cffe392c5<AAV>|r " .. L.AAV_VERSION_OUTDATED)
		end
		
		if (atroxArenaViewerData.current.broadcast) then
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_broadcaststart"],
				target = nil,
				version = AAV_VERSIONMAJOR.."."..AAV_VERSIONMINOR.."."..AAV_VERSIONBUGFIX,
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
		end
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_broadcaststart"]) then
	-- BROADCAST START
	
		if (not broadcasters[sender]) then
			broadcasters[sender] = sd
			if (atroxArenaViewerData.defaults.profile.broadcastannounce) then
				print("|cffe392c5<AAV>|r Broadcasting started: " .. sender)
			end
		end
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_broadcaststop"]) then
	-- BROADCAST STOP
	
		broadcasters[sender] = nil
		if (atroxArenaViewerData.current.listening == sender) then
			print("|cffe392c5<AAV>|r " .. sender .. " stopped broadcasting")
		end
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_status"] and atroxArenaViewerData.current.listening == sender) then
	-- STATUS
	
		if (T and sd.state) then
			T:setStatus(sd.state)
		end
		if (sd.map and sd.map ~= 0) then
			T:setMapText(sender .. ": " .. AAV_COMM_MAPS[sd.map])
		end
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_connect"] and string.lower(sd.target) == string.lower(UnitName("player")) and atroxArenaViewerData.current.broadcast) then
	-- CONNECT
		
		table.insert(spectators, sender)
		print("|cffe392c5<AAV>|r New spectator connected: " .. sender .. " (total: " .. #atroxArenaViewer:getSpectators() .. ")")
		
		message["std"] = {
			event = AAV_COMM_EVENT["cmd_accept"],
			target = sender,
			version = nil,
			state = currentstate,
		}
		
		self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
		message["std"].state = nil
		
		-- if match is running, send match data
		if (M and atroxArenaViewerData.current.inFight) then
			self:sendAllPlayerInfo(sender)
		end
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_connect"] and atroxArenaViewerData.current.broadcast) then
	-- REMOVE SPECTATOR
		
		for k,v in pairs(spectators) do
			if (string.lower(v) == string.lower(sender)) then
				spectators[k] = nil
			end
		end
	
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_accept"] and sd.target == UnitName("player")) then
	-- ACCEPT
		
		atroxArenaViewerData.current.listening = sender
		
		if (not T) then T = AAV_PlayStub:new() end
		
		T:resetData()
		T:hidePlayer(T.player)
		T:removeAllCooldowns()
		T:createPlayer(1, 1, true)
		T:setMapText(sender .. ": " .. L.CONNECT_WAITING_DATA)
		T:handleSeeker("hide")
		
		T:setStatus(sd.state)
		
		print("|cffe392c5<AAV>|r " .. L.CONNECT_CONNECTED_TO .. sender .. ". " .. L.CONNECT_WAITING_DATA)
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_matchend"] and atroxArenaViewerData.current.listening == sender) then
	-- MATCH END
		
		if (not T) then return end
		T.player:Hide()
		T:createStats(sd.match, sd.dudes, T:getCurrentBracket())
		T.stats:Show()
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_newmatch"] and atroxArenaViewerData.current.listening == sender) then
	-- NEW MATCH
		
		if (not T) then print("error") return end -- should never happen cough
		
		T:hidePlayer(T.player)
		T:resetDudeData()
		T:removeAllCC()
		T:removeAllCooldowns()
		T:createPlayer(T:getCurrentBracket(), 1, true)
		--T:setMapText(sender .. ": " .. AAV_COMM_MAP[sd.map])
		T:handleSeeker("hide")
		T:setOnUpdate("start")
	
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_updateplayer"] and atroxArenaViewerData.current.listening == sender) then
	-- UPDATE PLAYER
	
		T:addDudeData(sd.guid, sd.dude)
		AAV_Gui:setPlayerFrameSize(T.origin, T:getCurrentBracket())
		AAV_Gui:setPlayerFrameSize(T.player, T:getCurrentBracket())
		
		T:newEntities(T.player) -- redraw
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_updateallplayers"] and atroxArenaViewerData.current.listening == sender and sd.target == UnitName("player")) then
	-- UPDATE ALL PLAYERS
	
		if (not T) then print("Error: PlayerStub not initialized.") return end -- should never happen cough
		
		T:hidePlayer(T.player)
		T:resetDudeData()
		
		for k,v in pairs(sd.dudes) do
			T:addDudeData(k, v)
		end
		
		AAV_Gui:setPlayerFrameSize(T.origin, T:getCurrentBracket())
		AAV_Gui:setPlayerFrameSize(T.player, T:getCurrentBracket())
		
		T:createPlayer(T:getCurrentBracket(), 1, true)
		T:setMapText(sender .. ": " .. AAV_COMM_MAPS[sd.map])
		T:handleSeeker("hide")
		
		T:setOnUpdate("start")
		
		T:newEntities(T.player) -- redraw
		
	elseif (b and sd.event == AAV_COMM_EVENT["cmd_spectatorstop"] and atroxArenaViewerData.current.broadcast and sd.target == UnitName("player")) then
	-- SPECTATOR CLOSES
		
		for k,v in pairs(spectators) do
			if (sender == v) then
				spectators[k] = nil
			end	
		end
	end
end

----
-- players stops listening to a broadcaster and sends a stop message.
function atroxArenaViewer:stopListening()
	
	message["std"] = {
		event = AAV_COMM_EVENT["cmd_spectatorstop"],
		target = atroxArenaViewerData.current.listening,
		version = AAV_VERSIONMAJOR.."."..AAV_VERSIONMINOR.."."..AAV_VERSIONBUGFIX,
	}
	
	self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
	
	atroxArenaViewerData.current.listening = ""
end

----
-- prints locally broadcaster with version.
-- @param sender broadcaster
-- @param version
function atroxArenaViewer:giveBroadcasterFound(sender, version)
	print("|cffe392c5<AAV>|r Broadcaster found: " .. sender .. " (v" .. version .. ")")
end

----
-- handles the use of enabling or disabling broadcasting and sends it to everyone in the channel.
-- @param val start or stop broadcasting
function atroxArenaViewer:handleBroadcasting(val)
	message["std"] = {
		event = AAV_COMM_EVENT["cmd_broadcast" .. val],
		target = nil,
		version = AAV_VERSIONMAJOR.."."..AAV_VERSIONMINOR.."."..AAV_VERSIONBUGFIX,
	}
	
	if (val == "start") then
		print(L.CMD_ENABLE_BROADCAST)
		atroxArenaViewerData.current.broadcast = true
		for k,v in pairs(spectators) do spectators[k] = nil end
		
		if (atroxArenaViewerData.current.inFight) then
			self:handleQueueTimer("start")
		end
	elseif (val == "stop") then
		print(L.CMD_DISABLE_BROADCAST)
		atroxArenaViewerData.current.broadcast = false
		
		-- broadcasting that you're broadcasting
		
		if (atroxArenaViewerData.current.inFight) then
			self:handleQueueTimer("stop")
		end
	end
	
	self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
end

----
-- connects someone to a broadcaster.
-- @param name broadcaster's name
function atroxArenaViewer:connectToBroadcast(name)
	message["std"] = {
		target = name,
		event = AAV_COMM_EVENT["cmd_connect"],
		version = AAV_VERSIONMAJOR.."."..AAV_VERSIONMINOR.."."..AAV_VERSIONBUGFIX
	}
	self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
end

----
-- incoming match data.
function atroxArenaViewer:handleMatchData(prefix, msg, dist, sender)
	local message = AAV_Util:split(msg, '^')
	if (atroxArenaViewerData.current.listening == sender) then
		for k,v in pairs(message) do
			local post = AAV_Util:split("0," .. v, ',')
			self:executeMatchData(0, post)
		end
	end
end

----
-- sends an info about a single player
-- @param data serialized data
function atroxArenaViewer:sendPlayerInfo(key, data)
	if (atroxArenaViewerData.current.broadcast) then
		message["dude"] = {
			event = AAV_COMM_EVENT["cmd_updateplayer"],
			--bracket = self:getCurrentBracket(),
			guid = key,
			dude = data,
		}
		self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["dude"]), self:getCommMethod(), nil)
	end
end

---- 
-- sendMatchInfo
function atroxArenaViewer:sendAllPlayerInfo(sender)
	message["dudes"] = {
		target = sender,
		event = AAV_COMM_EVENT["cmd_updateallplayers"],
		--bracket = self:getCurrentBracket(),
		dudes = M:getDudesData(),
		map = self:getCurrentMapId(),
	}

	self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["dudes"]), self:getCommMethod(), nil)
	message["dudes"].map = nil
end

function atroxArenaViewer:sendNewMatchInfo()
	message["std"] = {
		event = AAV_COMM_EVENT["cmd_newmatch"],
		target = nil,
		version = nil,
		--bracket = self:getCurrentBracket(),
		--map = M:getCurrentMap(),
	}
	
	self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
	message["std"].bracket = nil
	--message["std"].map = nil
end

function atroxArenaViewer:changeBroadcast()
	if (atroxArenaViewerData.current.broadcast == true) then
		self:handleBroadcasting("stop")
		
	elseif (atroxArenaViewerData.current.broadcast == false) then
		self:handleBroadcasting("start")
	end
end

function atroxArenaViewer:changeRecording()
	if (atroxArenaViewerData.current.record == true) then
		if (atroxArenaViewerData.current.inArena == false) then
			atroxArenaViewerData.current.record = false
			print(L.CMD_DISABLE_RECORDING)
		else
			print("Aktion in der Arena nicht möglich.")
		end
		--if (atroxArenaViewerData.current.inArena == true) then self:handleEvents("stop") end -- [#18] removed
	else
		atroxArenaViewerData.current.record = true
		--if (atroxArenaViewerData.current.inArena == true) then self:handleEvents("start") end -- [#18] removed
		print(L.CMD_ENABLE_RECORDING)
	end
end

function atroxArenaViewer:OnDisable()
    
end

function atroxArenaViewer:onUpdate(elapsed)
	-- update combat text movements
	if (T) then
		T:onUpdate(elapsed * (atroxArenaViewerData.current.interval * 10))
	end
	
	return
end


----
-- status 1 = in queue, in arena: message board; 2 = entered
function atroxArenaViewer:UPDATE_BATTLEFIELD_STATUS(event, status)
	
	if (atroxArenaViewerData.current.broadcast or atroxArenaViewerData.current.record and M) then
		--[[
		if (atroxArenaViewerData.current.broadcast and status == 1 and currentstate == 2) then
		-- unqueue
			currentstate = 1
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
		elseif (atroxArenaViewerData.current.broadcast and status == 1 and not atroxArenaViewerData.current.inArena) then
			currentstate = 2
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
		--]]
		if (atroxArenaViewerData.current.broadcast and status == 1 and currentstate ~= 2) then
			currentstate = 2
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
			
		elseif (status == 1 and atroxArenaViewerData.current.inArena) then
			
			local found
			for i=0,1 do
				found = false
				local teamName, oldRating, newRating, teamSkill = GetBattlefieldTeamInfo(i)
				if (teamName ~= "") then
					for j=1,3 do
						local name = GetArenaTeam(j)
						if (name == teamName) then
							M:setTeams(0, teamName, newRating, newRating - oldRating, teamSkill)
							found = true
							break
						end
					end
				end
				if not (found) then
					--local teamName, oldRating, newRating, teamSkill = GetBattlefieldTeamInfo(i)
					if (teamName ~= "") then
						M:setTeams(1, teamName, newRating, newRating - oldRating, teamSkill)
					else
						M:setTeams(i, "Team " .. (i+1), 0, 0, 0)
					end
				end
				
				if (atroxArenaViewerData.current.broadcast) then
					message["stats"] = {
						event = AAV_COMM_EVENT["cmd_matchend"],
						match = M:getTeams(),
						dudes = M:getDudesData(),
						--bracket = self:getCurrentBracket(),
					}
					self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["stats"]), self:getCommMethod(), nil)
				end
			end
			
		elseif (atroxArenaViewerData.current.broadcast and status == 2) then
			currentstate = 3
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
				map = self:getCurrentMapId(),
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
			message["std"].map = nil
			
		end
	end
	
end

----
-- event to track the start of the arena match.
-- @param event
-- @param msg message to compare
function atroxArenaViewer:CHAT_MSG_BG_SYSTEM_NEUTRAL(event, msg)
	if (string.upper(msg) == string.upper(L.ARENA_START)) then
		if (atroxArenaViewerData.current.record == true) then
			atroxArenaViewerData.current.entered = self:getCurrentTime()
			atroxArenaViewerData.current.time = GetTime()
			
			self:sendNewMatchInfo() -- match starts
			
			for i = 1, 5 do
				if (UnitExists("raid" .. i)) then
					local key, player = M:updateMatchPlayers(1, "raid" .. i)
					self:sendPlayerInfo(key, player)
				end
			end
			
			M:setBracket() -- sets the bracket size according to dudes data
			
			self:handleEvents("register")
			self:handleQueueTimer("start")
		end
		currentstate = 8
		if (atroxArenaViewerData.current.broadcast) then
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
		end
		
	elseif (msg == L.ARENA_60) then
		currentstate = 4
		if (atroxArenaViewerData.current.broadcast) then
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
				map = self:getCurrentMapId(),
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
			message["std"].map = nil
		end
	elseif (msg == L.ARENA_45) then
		currentstate = 5
		if (atroxArenaViewerData.current.broadcast) then
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
				map = self:getCurrentMapId(),
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
			message["std"].map = nil
		end
	elseif (msg == L.ARENA_30) then
		currentstate = 6
		if (atroxArenaViewerData.current.broadcast) then
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
				map = self:getCurrentMapId(),
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
			message["std"].map = nil
		end
	elseif (msg == L.ARENA_15) then
		currentstate = 7
		if (atroxArenaViewerData.current.broadcast) then
			message["std"] = {
				event = AAV_COMM_EVENT["cmd_status"],
				target = nil,
				version = nil,
				state = currentstate,
				map = self:getCurrentMapId(),
			}
			self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
			message["std"].state = nil
			message["std"].map = nil
		end
	end
end


function atroxArenaViewer:ZONE_CHANGED_NEW_AREA(event, unit)
	
	CombatLogClearEntries() -- fixes combat log parse overflow problem
	
	if (GetZonePVPInfo() == "arena") then
	
		self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
		
		atroxArenaViewerData.current.inArena = true
		atroxArenaViewerData.current.entered = self:getCurrentTime()
		atroxArenaViewerData.current.time = GetTime()
		
		M = AAV_MatchStub:new()
		
	else --save match
		if (atroxArenaViewerData.current.inArena) then
			
			self:handleEvents("unregister")
			self:handleQueueTimer("stop")
			self:UnregisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
			
			if (atroxArenaViewerData.current.record) then
				atroxArenaViewerData.data = atroxArenaViewerData.data or {}
				local matchid = self:getNewMatchID()
				
				atroxArenaViewerData.data[matchid] = atroxArenaViewerData.data[matchid] or {}
				
				M:setMatchEnd()
				M:saveToVariable(matchid)
			end
			
			if (atroxArenaViewerData.current.broadcast) then
				currentstate = 1
				message["std"] = {
					event = AAV_COMM_EVENT["cmd_status"],
					target = nil,
					version = nil,
					state = currentstate,
				}
				self:SendCommMessage(AAV_COMM_LOOKUPBROADCAST, self:Serialize(message["std"]), self:getCommMethod(), nil)
				message["std"].state = nil
			end
			
			atroxArenaViewerData.current.inArena = false
			atroxArenaViewerData.current.entered = 0
			atroxArenaViewerData.current.time = 0
			atroxArenaViewerData.current.move = 0
			
		end
	end
end

-----
function atroxArenaViewer:handleEvents(val)
	if (val == "register") then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("UNIT_HEALTH")
		--self:RegisterEvent("UNIT_MANA") -- deprecated
		self:RegisterEvent("UNIT_POWER") -- new in 4.0.3
		self:RegisterEvent("ARENA_OPPONENT_UPDATE")
		--self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
		self:RegisterEvent("UNIT_NAME_UPDATE")
		self:RegisterEvent("UNIT_AURA")
		atroxArenaViewerData.current.inFight = true
		
		
		--print("[debug] registering all events")
	elseif (val == "unregister") then
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("UNIT_HEALTH")
		--self:UnregisterEvent("UNIT_MANA") -- deprecated
		self:UnregisterEvent("UNIT_POWER") -- new in 4.0.3
		self:UnregisterEvent("ARENA_OPPONENT_UPDATE")
		--self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
		self:UnregisterEvent("UNIT_NAME_UPDATE")
		self:UnregisterEvent("UNIT_AURA")
		atroxArenaViewerData.current.inFight = false
		
	end
end

----
-- returns the player, null if not initialized.
-- @return T playstub
function atroxArenaViewer:getPlayer()
	return T
end

----
-- used to initialize the visible units when match starts.
-- @param val "raid" or "arena" specified
-- @param side 1 = left (self), 2 = right (enemies)
function atroxArenaViewer:initArenaMatchUnits(arr)
	local unit, side = arr[1], arr[2]
	local hp, hpmax, guid
	local buffs, debuffs = {}, {}
	local i, n = 1, 1
	
	if (UnitName(unit) == L.UNKNOWN or UnitClass(unit) == nil) then return end
	
	guid = M:getGUIDtoNumber(UnitGUID(unit))
	if (not guid) then return end
	
	-- BUFFS
	for n = 1, 40 do
		local _, _, icon, _, _, _, _, _, _, _, b = UnitBuff(unit, n) --spellid
		if (b and not self:isExcludedAura(spellId)) then
			if (string.find(string.lower(icon), "_mount_") == nil and string.lower(icon) ~= "inv_misc_key_14" and string.lower(icon) ~= "inv_misc_key_06") then
				table.insert(buffs, b)
			end
		else
			break
		end
	end
	
	-- DEBUFFS
	for n = 1, 40 do
		_, _, _, _, _, _, _, _, _, _, b = UnitDebuff(unit, n) --spellid
		if (b and not self:isExcludedAura(spellId)) then
			table.insert(debuffs, b)
		else
			break
		end
	end
	
	for k,v in pairs(buffs) do
		M:getBuffs(guid)[k] = true
	end
	for k,v in pairs(debuffs) do
		M:getDebuffs(guid)[k] = true
	end
	
	self:createMessage(self.getDiffTime(), "0," .. guid .. "," .. UnitHealth(unit) .. "," .. UnitHealthMax(unit) .. "," .. table.concat(buffs, ";") .. "," .. table.concat(debuffs, ";"))
end

function atroxArenaViewer:createMessage(tick, msg)
	if (atroxArenaViewerData.current.record) then
		M:createMessage(tick .. "," .. msg)
	end
	
	-- broadcasting
	if (atroxArenaViewerData.current.broadcast) then
		table.insert(queue, msg)
	end
end

function atroxArenaViewer:handleQueueTimer(val)
	if (val == "start" and not self:TimeLeft(queuetimer)) then
		queuetimer = self:ScheduleRepeatingTimer("queueMatchData", AAV_QUEUESENDTIME)
	elseif (val == "stop" and self:TimeLeft(queuetimer)) then
		self:CancelTimer(queuetimer)
		queuetimer = nil
	end
end

----
-- repeated function that sends all collected data in a defined period.
function atroxArenaViewer:queueMatchData()
	if (#queue > 0) then
	--print(table.concat(queue, "^"))
		self:SendCommMessage(AAV_COMM_HANDLEMATCHDATA, table.concat(queue, "^"), self:getCommMethod(), nil)
		
		-- empty queue
		for k,v in pairs(queue) do
			queue[k] = nil
		end
	end
end

----
-- queries the current zone and compares the text with the ones in the AAV_COMM_MAPS.
-- @return map id
function atroxArenaViewer:getCurrentMapId()
	for k,v in pairs(AAV_COMM_MAPS) do
		if (GetZoneText() == v) then
			return k
		end
	end
	return 0
end

----
-- monitors the change of mana in consideration of mana treshold (AAV_MANATRESHOLD).
-- @param event
-- @param unit
-- @param type resource changed (mana, ragem ...)
--function atroxArenaViewer:UNIT_MANA(event, unit)
function atroxArenaViewer:UNIT_POWER(event, unit, type)
	if (type ~= "MANA") then
		return
	end
	
	local player = M:getDudesData()[UnitGUID(unit)]
	if (player) then --and (player.mana > (UnitMana(unit)/UnitManaMax(unit))) then
		
		local mana = math.floor((UnitMana(unit)/UnitManaMax(unit))*100)
		if not (mana > player.mana - AAV_MANATRESHOLD and mana < player.mana + AAV_MANATRESHOLD) then
			player.mana = mana
			local u = M:getGUIDtoNumber(UnitGUID(unit))
			if (u) then self:createMessage(self:getDiffTime(), "17," .. u .. "," .. mana) end
		end
	end
end

----
-- monitors the change of Health, inclusive Max HP.
-- Currently limited to raid and arena targets (no pets).
-- @param event
-- @param unit
function atroxArenaViewer:UNIT_HEALTH(event, unit)
	local sub = string.sub(unit,1,4)
	if (sub == "raid" or sub == "aren") then
		local target = M:getChangeInHealthFlags(unit)
		local u = M:getGUIDtoNumber(UnitGUID(unit))
		
		if (bit.band(target, 0x1) ~= 0 and u) then
			self:createMessage(self:getDiffTime(), "1," .. u .. "," .. UnitHealth(unit))
		end
		if (bit.band(target,0x2) ~= 0 and u) then
			self:createMessage(self:getDiffTime(), "2," .. u .. "," .. UnitHealthMax(unit))
		end
	end
end

function atroxArenaViewer:UNIT_AURA(event, unit)
	local n, m = 1, 1
	local sub = string.sub(unit,1,4)
	if (sub ~= "raid" and sub ~= "aren") then return end
	
	local id = M:getGUIDtoNumber(UnitGUID(unit))
	if (not id) then return end
	
	for n = 1, 40 do
		local _, _, _, _, _, btime, _, _, _, _, bspellid = UnitBuff(unit, n)
		local _, _, _, _, _, dtime, _, _, _, _, dspellid = UnitDebuff(unit, n)
		
		if (not bspellid and not dspellid) then break end
		
		if (bspellid) then tempbuffs[bspellid] = true end
		if (dspellid) then tempdebuffs[dspellid] = true end
		
		if (bspellid and not M:getBuffs(id)[bspellid]) then
			-- create new buff
			M:getBuffs(id)[bspellid] = true
			
			if (not btime) then btime = 0 end
			self:createMessage(self:getDiffTime(), "13," .. id .. "," .. bspellid .. ",1," .. btime)
		end
		if (dspellid and not M:getDebuffs(id)[dspellid]) then
			-- create new debuff
			M:getDebuffs(id)[dspellid] = true
			
			if (not dtime) then dtime = 0 end
			self:createMessage(self:getDiffTime(), "13," .. id .. "," .. dspellid .. ",2," .. dtime)
		end
	end
	
	for k,v in pairs(M:getBuffs(id)) do
		if (not tempbuffs[k]) then
			--remove
			self:createMessage(self:getDiffTime(), "14," .. id .. "," .. k .. ",1")
			M:getBuffs(id)[k] = nil
		end
	end
	for k,v in pairs(M:getDebuffs(id)) do
		if (not tempdebuffs[k]) then
			--remove
			self:createMessage(self:getDiffTime(), "14," .. id .. "," .. k .. ",2")
			M:getDebuffs(id)[k] = nil
		end
	end
	
	for k,v in pairs(tempbuffs) do
		tempbuffs[k] = nil
	end
	for k,v in pairs(tempdebuffs) do
		tempdebuffs[k] = nil
	end
	
end

function atroxArenaViewer:UNIT_NAME_UPDATE(event, unit)
	if (UnitIsPlayer(unit)) then
		if (not M) then return end
		local sourceGUID = UnitGUID(unit)
		
		M:getDudesData()[sourceGUID].name = UnitName(unit)
		self:sendPlayerInfo(sourceGUID, M:getDudesData()[sourceGUID])
	end
end

function atroxArenaViewer:ARENA_OPPONENT_UPDATE(event, unit, type)
	local u = M:getGUIDtoNumber(UnitGUID(unit))
	
	if (type == "seen") then
		if (not u) then
			local key, player = M:updateMatchPlayers(2, unit)
			self:sendPlayerInfo(key, player)
			
			--self:ScheduleTimer("initArenaMatchUnits", AAV_INITOFFTIME, {unit, 2})
			--self:initArenaMatchUnits({unit, 2})
		else
			-- if character vanishes and reappears
			--self:initArenaMatchUnits({unit, 2})
			self:createMessage(self:getDiffTime(), "18," .. u .. ",2")
		end
		
	elseif (type == "unseen") then
		-- lost track (stealth)
		if (u) then self:createMessage(self:getDiffTime(), "18," .. u .. ",1") end
		
	elseif (type == "destroyed") then
		-- has left the arena
		if (u) then self:createMessage(self:getDiffTime(), "18," .. u .. ",3") end
		
	end
end

----
-- triggered, when an arena match ended (3 times).
--[[
function atroxArenaViewer:UPDATE_BATTLEFIELD_SCORE(event, unit)
	--self:handleEvents("unregister")
	
end
--]]

function atroxArenaViewer:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	--local timestamp, type, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
	local timestamp, type, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical
	local eventType, msg
	
	type, _, sourceGUID, _, _, _, destGUID = select(2, ...)
	
	local source = M:getGUIDtoNumber(sourceGUID)
	local dest = M:getGUIDtoNumber(destGUID)
	
	-- check if name is unknown
	--[[
	if (source and M:getDudesData()[sourceGUID].name == L.UNKNOWN) then
		M:getDudesData()[sourceGUID].name = UnitName(M:getGUIDtoTarget(sourceGUID))
		self:sendPlayerInfo(sourceGUID, M:getDudesData()[sourceGUID])
		
	end
	if (dest and M:getDudesData()[destGUID].name == L.UNKNOWN) then
		M:getDudesData()[destGUID].name = UnitName(M:getGUIDtoTarget(destGUID))
		self:sendPlayerInfo(destGUID, M:getDudesData()[destGUID])
	end
	--]]
	
	if (type == "SWING_DAMAGE") then
		eventType = 3
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
		if (not critical) then critical = 0 end
		if (not absorbed) then absorbed = 0 end
		if (source and dest and amount) then -- dont track damage from unknown sources and destinations
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. amount .. "," .. critical)
			M:addStats(1, sourceGUID, amount + absorbed)
		end
	elseif (type == "SPELL_DAMAGE") then
		eventType = 4
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
		if (not critical) then critical = 0 end
		if (not absorbed) then absorbed = 0 end
		if (source and dest and amount) then -- dont track damage from unknown sources and destinations
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. amount .. "," .. critical)
			M:addStats(1, sourceGUID, amount + absorbed)
		end
	elseif (type == "SPELL_PERIODIC_DAMAGE") then
		eventType = 5
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
		if (not critical) then critical = 0 end
		if (not absorbed) then absorbed = 0 end
		if (source and dest and amount) then -- dont track damage from unknown sources and destinations
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. amount .. "," .. critical)
			M:addStats(1, sourceGUID, amount + absorbed)
		end
	elseif (type == "RANGE_DAMAGE") then
		eventType = 6
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical = select(1, ...)
		if (not critical) then critical = 0 end
		if (not absorbed) then absorbed = 0 end
		if (source and dest and amount) then -- dont track damage from unknown sources and destinations
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. amount .. "," .. critical)
			M:addStats(1, sourceGUID, amount + absorbed)
		end
	elseif (type == "SPELL_HEAL") then
		eventType = 7
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, overkill, critical, _= select(1, ...)
		if (not critical) then critical = 0 end
		if (source and dest and amount) then -- dont track damage from unknown sources and destinations
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. amount .. "," .. critical)
			M:addStats(2, sourceGUID, amount - overkill)
		end
	elseif (type == "SPELL_PERIODIC_HEAL") then
		eventType = 8
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, overkill, critical, _= select(1, ...)
		if (not critical) then critical = 0 end
		if (source and dest and amount) then -- dont track damage from unknown sources and destinations
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. amount .. "," .. critical)
			M:addStats(2, sourceGUID, amount - overkill)
		end
	elseif (type == "SPELL_CAST_START") then
		eventType = 9
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool = select(1, ...)
		if (source) then
			local target, destTarget = M:getGUIDtoTarget(sourceGUID), ""
			if (target) then destTarget = M:getGUIDtoNumber(UnitGUID(target .. "target")) end
			if (not destTarget) then destTarget = source end
			local _, _, _, _, _, _, casttime = GetSpellInfo(spellId)
			local _, duration, _ = GetSpellCooldown(spellId)
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. destTarget .. "," .. spellId .. "," .. casttime .. "," .. duration)
		end
	elseif (type == "SPELL_CAST_SUCCESS") then
		eventType = 10
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool = select(1, ...)
		if (source) then
			if (not dest) then dest = -1 end
			local time = 0
			GetSpellCooldown(spellId)
			--M:getGUIDtoTarget(sourceGUID)
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. spellId .. "," .. time)
		end
	elseif (type == "SPELL_CAST_FAILED") then
		-- cant be tracked from others
		
	elseif (type == "SPELL_INTERRUPT") then
		eventType = 12
		timestamp, type, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellId, spellName, spellSchool, amount, _, _, _ = select(1, ...) -- counteredSpellid, counteredSpellName, counteredSpellSchool
		if (source and dest) then
			self:createMessage(self:getDiffTime(), eventType .. "," .. source .. "," .. dest .. "," .. spellId .. "," .. amount)
		end
	elseif (type == "SPELL_AURA_APPLIED") then
		--[[
		eventType = 13
		if (source and dest) then
			local time = 0
			local target
			if (amount == "BUFF") then amount = 1 else amount = 2 end -- buffs = 1, debuffs = 2
			
			if (AAV_IMPORTANTSKILLS[spellId]) then -- check importantskill
				local target = M:getGUIDtoTarget(destGUID)
				if (target) then 
					for i=1,40 do
						spid = 0
						if (amount == 1) then 
							_, _, _, _, _, time, _, _, _, _, spid = UnitBuff(target, i)
						elseif (amount == 2) then
							_, _, _, _, _, time, _, _, _, _, spid = UnitDebuff(target, i)
						end
						if (spid == spellId) then break end -- spell found
					end
				end
			end
			
			if (not time) then time = 0 end
			self:createMessage(self:getDiffTime(), eventType .. "," .. dest .. "," .. spellId .. "," .. amount .. "," .. time)
		end
		--]]
	elseif (type == "SPELL_AURA_REMOVED") then
		--[[
		eventType = 14
		if (source and dest) then
			if (amount == "BUFF") then amount = 1 else amount = 2 end -- buffs = 1, debuffs = 2
			self:createMessage(self:getDiffTime(), eventType .. "," .. dest .. "," .. spellId .. "," .. amount)
		end
		--]]
	elseif (type == "SPELL_AURA_REFRESH") then
		eventType = 15
		--[[
		if (source and dest) then
			if (amount == "BUFF") then amount = 1 else amount = 2 end -- buffs = 1, debuffs = 2
			self:createMessage(self:getDiffTime(), eventType .. "," .. dest .. "," .. spellId .. "," .. amount)
		end
		--]]
	elseif (type == "UNIT_DIED") then
		eventType = 16
		-- 17 MANA
	end
	
end

----
-- check function whether omitted spellid is in the exceptauras table.
-- @param spellid
-- @return true if it's excluded and unwanted spell
function atroxArenaViewer:isExcludedAura(spellid)
	for k,v in pairs(exceptauras) do
		if (spellId == v) then 
			return true
		end
	end
	return false
end

function atroxArenaViewer:getNewMatchID()
	local max = 0
	for k,v in pairs(atroxArenaViewerData.data) do
		if (tonumber(k) > max) then
			max = k
		end
	end
	return max + 1
end

--[[
-- removed in 4.0.3
function atroxArenaViewer:getCurrentBracket()
	currentbracket = nil
	for i=1,2 do
		local status, _, _, _, _, teamSize = GetBattlefieldStatus(i)
		if (status == "active" and teamSize > 0) then
			currentbracket = teamSize
			break
		end
	end
	return currentbracket
end
--]]

function atroxArenaViewer:getCurrentTime()
	return date("%m/%d/%y %H:%M:%S")
end

function atroxArenaViewer:getDiffTime()
	return math.ceil((GetTime() - atroxArenaViewerData.current.time)*100)/100
end


----
-- creates the player
-- as of 1.1.7 if bracket isnt available by data it'll be calculated.
-- @param num data entry
function atroxArenaViewer:createPlayer(num)
	local i = 1
	
	if (not T) then T = AAV_PlayStub:new() end
	
	T:hidePlayer(T.player)
	T:setOnUpdate("start")
	
	T:setMatchData(num)
	
	if (not T:getMatchData(1)) then
		return
	end
	
	
	-- check if bracket is available
	if (atroxArenaViewerData.data[num].bracket == nil) then
		atroxArenaViewerData.data[num].bracket = 0
		for k,v in pairs(atroxArenaViewerData.data[num].combatans.dudes) do
			if (v.player == 1 and v.team == 1) then
				atroxArenaViewerData.data[num].bracket = atroxArenaViewerData.data[num].bracket + 1
			end
		end
	end
	
	T:createPlayer(atroxArenaViewerData.data[num].bracket, atroxArenaViewerData.data[num].elapsed, false)
	
	print("|cffe392c5<AAV>|r Start playing: " .. AAV_COMM_MAPS[atroxArenaViewerData.data[num].map] .. " at " .. atroxArenaViewerData.data[num].startTime)
end

function atroxArenaViewer:deleteMatch(num)
	table.remove(atroxArenaViewerData.data, num)
end

function atroxArenaViewer:exportMatch(num)
	exportnum = num
end

----
-- recursive function for export.
-- @param tab table
-- @param input if set then add skill legend
function atroxArenaViewer:getRecursiveExport(tab, input)
	local str = "{"
	local first = true
	for k,v in pairs(tab) do
		if (not first) then str = str .. "," end
		if (type(v) == "table") then
			str = str .. '"' .. k .. '":' .. self:getRecursiveExport(v)
		else
			str = str .. '"' .. k .. '":"' .. v .. '"'
		end
		first = false
	end
	
	if (input) then
		str = str .. self:getSkillLegend(tab.data)
	end
	
	str = str .. "}"
	return str
end

----
-- exports all used skills in the match.
-- @param tab table
function atroxArenaViewer:getSkillLegend(tab)
	local str = ""
	local tmp
	local db = {}
	
	for k,v in pairs(tab) do 
		
		tmp = AAV_Util:split(v, ',')
		
		if (tmp[2] == "9" or tmp[2] == "10" or tmp[2] == "11" or tmp[2] == "12") then
			if (not db[tonumber(tmp[5])]) then
				db[tonumber(tmp[5])] = true
			end
		elseif (tmp[2] == "13" or tmp[2] == "14") then
			if (not db[tonumber(tmp[4])]) then
				db[tonumber(tmp[4])] = true
			end
		end
	end
	
	str = ',"legend":['
	
	local first = true
	for k,v in pairs(db) do
		local name, rank, icon = GetSpellInfo(tonumber(k))
		icon = string.gsub(string.lower(icon), "interface\\icons\\", "")
		if (not first) then str = str .. "," end
		str = str .. '{"id":' .. k .. ',"icon":"' .. icon .. '","name":"' .. name .. '"}'
		first = false
	end
	
	str = str .. ']'
	
	return str
end

----
-- returns all spectators to own broadcasted match.
-- @return spectator list
function atroxArenaViewer:getSpectators()
	return spectators
end

----
-- exports the match data.
-- @param num match id
function atroxArenaViewer:getExportString(num)
	local str = "["
	str = str .. self:getRecursiveExport(atroxArenaViewerData.data[num], true) 	
	str = str .. "]"
	return str
end

function atroxArenaViewer:getMatch()
	return T:getMatch()
end

----
-- plays the given match.
-- @param num matchid
function atroxArenaViewer:playMatch(num)
	local pre
	
	if (T:getCurrentMatchData()) then
		pre = AAV_Util:split(T:getCurrentMatchData(), ',')
		T:removeAllCC()
		T:removeAllCooldowns()
		T:setTickTime(tonumber(pre[1]))
		T:setMapText(T:getMatch()["map"])
		
		-- check if older matches
		local vmajor, vminor, vbugfix = strsplit(".", T:getMatch()["version"])
		vmajor = tonumber(vmajor)
		vminor = tonumber(vminor)
		vbugfix = tonumber(vbugfix)
		if ((vmajor < AAV_VERSIONMAJOR) or (vmajor == AAV_VERSIONMAJOR and vminor < AAV_VERSIONMINOR) or (vmajor == AAV_VERSIONMAJOR and vminor == AAV_VERSIONMINOR and vbugfix < AAV_VERSIONBUGFIX)) then
			StaticPopup_Show("AAV_PLAYOLDMATCHES_DIALOG")
		end
		
		--T:handleTimer("start")
	else
		print("Error - bad match data.")
	end
end

function atroxArenaViewer:evaluateMatchData()
	local done = false
	local post
	
	T:setTickTime(T:getTickTime() + atroxArenaViewerData.current.interval)
	T:updatePlayerTick()
	
	while not done do
		if (not T:getCurrentMatchData()) then
			T:handleTimer("stop")
			done = true
		else
			post = AAV_Util:split(T:getCurrentMatchData(), ',')
			if (not T:getCurrentMatchData() or (tonumber(post[1]) >= T:getTickTime())) then
				done = true
			else
				self:executeMatchData(T:getTick(), post)
				T:setTick(T:getTick() + 1)
			end
		end
	end
end


function atroxArenaViewer:commEvaluateBroadcastData(prefix, msg, dist, sender)
	if (atroxArenaViewerData.current.listening == sender) then
		
	end
end


function atroxArenaViewer:executeMatchData(tick, data)
	local t = tonumber(data[2])
	
	-- init
	if (t == 0) then
		
		T:setBar(tonumber(data[3]), tonumber(data[4]))
		T:setMaxBar(tonumber(data[3]), tonumber(data[5]))
		--[[
		T:removeAllAuras(tonumber(data[3]))
		
		local buffs = AAV_Util:split(data[6], ";")
		
		if (buffs) then
			for k,v in pairs(buffs) do
				for c,w in pairs(buffs) do
					-- sexx
					T.entities[id]
				end
				T:addAura(tonumber(data[3]), tonumber(v), 1)
			end
		end
		
		local debuffs = AAV_Util:split(data[7], ";")
		if (debuffs) then
			for k,v in pairs(debuffs) do
				T:addAura(tonumber(data[3]), tonumber(v), 2)
			end
		end
		--]]
	-- current HP
	elseif (t == 1) then
		T:setBar(tonumber(data[3]), tonumber(data[4]))
		
	-- max HP
	elseif (t == 2) then
		T:setMaxBar(tonumber(data[3]), tonumber(data[4]))
		
	-- damage
	elseif (t == 3 or t == 4 or t == 5 or t == 6) then	
		T:addFloatingCombatText(tonumber(data[4]), tonumber(data[5]), tonumber(data[6]), 1)
		--T:addDamage(tonumber(data[4]), tonumber(data[5]))
		
	-- heal	
	elseif (t == 7 or t == 8) then
		T:addFloatingCombatText(tonumber(data[4]), tonumber(data[5]), tonumber(data[6]), 2)
		--T:addHeal(tonumber(data[4]), tonumber(data[5]))
		
	-- cast starts
	elseif (t == 9) then
		T:addSkillIcon(tonumber(data[3]), tonumber(data[5]), true, tonumber(data[4]), tonumber(data[6]))
		
	-- cast success
	elseif (t == 10) then
		T:addSkillIcon(tonumber(data[3]), tonumber(data[5]), false, tonumber(data[4]))
		
		if (tonumber(data[6]) and AAV_CCSKILS[tonumber(data[5])]) then
			T:addCooldown(tonumber(data[3]), tonumber(data[5]), AAV_CCSKILS[tonumber(data[5])])
		end
		
	elseif (t == 11) then
		-- cast interrupt, not implemented
		
	elseif (t == 12) then
		-- spell_interrupt
		T:interruptSkill(tonumber(data[3]), tonumber(data[4]), tonumber(data[5]), tonumber(data[6]))
		
	elseif (t == 13) then
		-- spell_aura_applied
		T:addAura(tonumber(data[3]), tonumber(data[4]), tonumber(data[5]))
		if (data[6] and tonumber(data[6]) > 0 and AAV_IMPORTANTSKILLS[tonumber(data[4])]) then
			T:addCC(tonumber(data[3]), tonumber(data[4]), tonumber(data[6]), AAV_IMPORTANTSKILLS[tonumber(data[4])])
		end
		
		if (AAV_BUFFSTOSKILLS[tonumber(data[4])]) then
			T:addSkillIcon(tonumber(data[3]), tonumber(data[4]), false, nil)
		end
		
	elseif (t == 14) then
		-- spell_aura_removed
		T:removeAura(tonumber(data[3]), tonumber(data[4]), tonumber(data[5]))
		if (AAV_IMPORTANTSKILLS[tonumber(data[4])]) then
			T:removeCC(tonumber(data[3]), tonumber(data[4]))
		end
		
	elseif (t == 15) then
		-- spell_aura_refreshed
		
	elseif (t == 16) then
		-- died
		
	elseif (t == 17) then
		-- mana changes
		T:setMana(tonumber(data[3]), tonumber(data[4]))
		
	elseif (t == 18) then
		-- visibility changes
		T:setVisibility(tonumber(data[3]), tonumber(data[4]))
		
	end
	
end
