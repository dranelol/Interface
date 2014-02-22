KifogasTxt = LibStub("AceAddon-3.0"):NewAddon("KifogasTxt", "AceConsole-3.0", "AceEvent-3.0")

local db
local defaultDb = {
	profile = {
		KeepAccents = true
	},
}

function KifogasTxt:OnInitialize()
	-- create about pane
	LibStub("tekKonfig-AboutPanel").new(nil, "KifogasTxt")

	-- create default db
 	self.db = LibStub("AceDB-3.0"):New("KifogasTxtDB", defaultDb)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")

	-- cache
	db = self.db.profile

	-- create options table
	local options = {
			name = "KifogasTxt",
			handler = KifogasTxt,
			type = 'group',
			args = {
				enable = {
				name = "Enable",
				desc = "Enables / disables the addon",
				type = "toggle",
				set = function(info,val) if (val) then KifogasTxt:Enable() else KifogasTxt:Disable() end end,
				get = function(info) return KifogasTxt.enabledState end
				},
				
				KeepAccents = {
					name = "Accents",
					desc = "keep accents in text?",
					type = "toggle",
					set = "_GenericSetter",
					get = function() return db.KeepAccents end
				},

				say = {
					name = "Say",
					desc = "Say random",
					type = "execute",
					func = function() KifogasTxt:SayRandom() end,
				},

				sayguild = {
					name = "sayguild",
					desc = "Say in guild",
					type = "execute",
					func = function() KifogasTxt:SayRandom("GUILD") end,
				},
			},
		}

	-- mix in the profile settings
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	-- register slash commands
	LibStub("AceConfig-3.0"):RegisterOptionsTable("KifogasTxt", options, {"kft", "kifogas", "kifogastxt"})
	
	if (db["Disabled"]) then
		KifogasTxt:Disable();
	end
end

function KifogasTxt:COMBAT_LOG_EVENT_UNFILTERED(skip, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)

--print (event .. " " .. UnitGUID("player") .. " " .. destGUID)
	if ((KifogasTxt.enabledState) 
			and (event == "UNIT_DIED")
			and (UnitGUID("player") == destGUID)) then
	
		KifogasTxt:SayRandom()
	end
end

function KifogasTxt:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
end

function KifogasTxt:_GenericSetter(info, value)
	db[info[#info]] = value
	KifogasTxt:Print(info[#info] .. " was set to: [|cff00ff00" .. tostring(value) .."|r]")
end

function KifogasTxt:OnEnable()
	db["Disabled"] = false
	KifogasTxt:Print("KifogasTxt is [|cff00ff00enabled|r]");

	KifogasTxt:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function KifogasTxt:OnDisable()
	db["Disabled"] = true
	KifogasTxt:Print("KifogasTxt is [|cff00ff00disabled|r]");

	KifogasTxt:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function KifogasTxt:SayRandom(target)

	local rnd = KifogasTxt.prefixes[math.random(KifogasTxt.prefixesLength)]..
						" "..KifogasTxt.suffixes[math.random(KifogasTxt.suffixesLength)]
	local channel

	if (target) then channel = target
	else
		if (GetNumRaidMembers() > 0) then channel = "RAID"
			elseif (GetNumPartyMembers() > 0) then channel = "PARTY"
			else return
		end
	end
	
	if (not db.KeepAccents) then
		rnd = KifogasTxt:Unaccent(rnd)
	end
	
	rnd = string.format(rnd, KifogasTxt:RandomName())

	local lines = { strsplit("\n", rnd) }

	for i=1,#lines do
		SendChatMessage(lines[i], channel)
	end

end

local accents = {["ö"] = "o",["ü"] = "u",["ó"] = "o",["ő"] = "o",["ú"] = "u",["é"] = "e",["á"] = "a",["ű"] = "u",["í"] = "i",["Ö"] = "O",["Ü"] = "U",["Ó"] = "O",["Ő"]= "O",["Ú"] = "U",["É"] = "E",["Á"] = "A",["Ű"] = "U",["Í"] = "I"}

function KifogasTxt:Unaccent(value)

	for from,to in pairs(accents) do 
		value = gsub(value, from, to)
	end
	
	return value
end

function KifogasTxt:RandomName()

	local unitid, max
	local name = GetUnitName("target")
	
	if (name) then return name end
	
	max = GetNumRaidMembers()

	if (max > 0) then unitid = "raid"
	else
		max = GetNumPartyMembers()
		if (max > 0) then unitid = "party"
		else return GetUnitName("player")
		end
	end

	unitid = unitid..math.random(max)

 	return GetUnitName(unitid, false)
end
