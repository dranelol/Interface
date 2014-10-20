local addonName, vars = ...
local L = vars.L
local addon = RaidBuffStatus
local report = addon.report
local raid = addon.raid
RBS_svnrev["Buffs.lua"] = select(3,string.find("$Revision: 675 $", ".* (.*) .*"))

local profile
function addon:UpdateProfileBuffs()
	profile = addon.db.profile
end

local BSmeta = {}
local BS = setmetatable({}, BSmeta)
local BSI = setmetatable({}, BSmeta)
BSmeta.__index = function(self, key)
	local name, _, icon
	if type(key) == "number" then
		name, _, icon = GetSpellInfo(key)
	else
		geterrorhandler()(("Unknown spell key %q"):format(key))
	end
	if name then
		BS[key] = name
		BS[name] = name
		BSI[key] = icon
		BSI[name] = icon
	else
		BS[key] = false
		BSI[key] = false
		geterrorhandler()(("Unknown spell info key %q"):format(key))
	end
	return self[key]
end

local function SpellName(spellID)
	local name = GetSpellInfo(spellID)
	return name
end

local ITmeta = {}
local ITN = setmetatable({}, ITmeta)
local ITT = setmetatable({}, ITmeta)
ITN.unknown = L["Please relog or reload UI to update the item cache."]
ITT.unknown = "Interface\\Icons\\INV_Misc_QuestionMark"
ITmeta.__index = function(self, key)
	local name, _, icon
	if type(key) == "number" then
		name, _, _, _, _, _, _, _, _, icon = GetItemInfo(key)
		if not name then
			GameTooltip:SetHyperlink("item:"..key..":0:0:0:0:0:0:0")  -- force server to send item info
			GameTooltip:ClearLines();
			name, _, _, _, _, _, _, _, _, icon = GetItemInfo(key)  -- info might not be in the cache yet but worth trying again
		end
	else
		geterrorhandler()(("Unknown item key %q"):format(key))
	end
	if name then
		ITN[key] = name
		ITN[name] = name
		ITT[key] = icon
		ITT[name] = icon
		return self[key]
	end
	return self.unknown
end

local tbcflasks = {
	SpellName(17626), -- Flask of the Titans
	SpellName(17627), -- [Flask of] Distilled Wisdom
	SpellName(17628), -- [Flask of] Supreme Power
	SpellName(17629), -- [Flask of] Chromatic Resistance
	SpellName(28518), -- Flask of Fortification
	SpellName(28519), -- Flask of Mighty Restoration
	SpellName(28520), -- Flask of Relentless Assault
	SpellName(28521), -- Flask of Blinding Light
	SpellName(28540), -- Flask of Pure Death
	SpellName(33053), -- Mr. Pinchy's Blessing
	SpellName(42735), -- [Flask of] Chromatic Wonder
	SpellName(40567), -- Unstable Flask of the Bandit
	SpellName(40568), -- Unstable Flask of the Elder
	SpellName(40572), -- Unstable Flask of the Beast
	SpellName(40573), -- Unstable Flask of the Physician
	SpellName(40575), -- Unstable Flask of the Soldier
	SpellName(40576), -- Unstable Flask of the Sorcerer
	SpellName(41608), -- Relentless Assault of Shattrath
	SpellName(41609), -- Fortification of Shattrath
	SpellName(41610), -- Mighty Restoration of Shattrath
	SpellName(41611), -- Supreme Power of Shattrath
	SpellName(46837), -- Pure Death of Shattrath
	SpellName(46839), -- Blinding Light of Shattrath
	SpellName(67019), -- Flask of the North (WotLK 3.2)
	SpellName(62380), -- Lesser Flask of Resistance  -- pathetic flask
}

local wotlkflasks = {
	SpellName(53755), -- Flask of the Frost Wyrm
	SpellName(53758), -- Flask of Stoneblood
	SpellName(54212), -- Flask of Pure Mojo
	SpellName(53760), -- Flask of Endless Rage
	SpellName(79639), -- Enhanced Agility  - Cata but not as good as other flasks.  Like Flask of the North.
	SpellName(79640), -- Enhanced Intellect  - Cata but not as good as other flasks.  Like Flask of the North.
	SpellName(79638), -- Enhanced Strength  - Cata but not as good as other flasks.  Like Flask of the North.

}

local cataflasks = {
	SpellName(79469), -- Flask of Steelskin
	SpellName(79470), -- Flask of the Draconic Mind
	SpellName(79471), -- Flask of the Winds
	SpellName(79472), -- Flask of Titanic Strength
	SpellName(94160), -- Flask of Flowing Water
	SpellName(105617), -- Alchemist's Flask - MoP but not as good as other flasks
	SpellName(127230), -- Crystal of Insanity - MoP but not as good as other flasks
}

local mopflasks = {
	SpellName(105689), -- Flask of Spring Blossoms
	SpellName(105691), -- Flask of the Warm Sun
	SpellName(105693), -- Flask of Falling Leaves
	SpellName(105694), -- Flask of the Earth
	SpellName(105696), -- Flask of Winter\'s Bite
} 

local tbcbelixirs = {
	SpellName(11390),-- Arcane Elixir
	SpellName(17538),-- Elixir of the Mongoose
	SpellName(17539),-- Greater Arcane Elixir
	SpellName(28490),-- Major Strength
	SpellName(28491),-- Healing Power
	SpellName(28493),-- Major Frost Power
	SpellName(54494),-- Major Agility
	SpellName(28501),-- Major Firepower
	SpellName(28503),-- Major Shadow Power
	SpellName(38954),-- Fel Strength Elixir
	SpellName(33720),-- Onslaught Elixir
	SpellName(54452),-- Adept's Elixir
	SpellName(33726),-- Elixir of Mastery
	SpellName(26276),-- Elixir of Greater Firepower
	SpellName(45373),-- Bloodberry - only works on Sunwell Plateau
	SpellName(48100),-- Intellect - from scroll (not TBC but less good than WotLK elixirs)
	SpellName(58449),-- Strength - from scroll (not TBC but less good than WotLK elixirs)
	SpellName(48104),-- Spirit - from scroll (not TBC but less good than WotLK elixirs)
	SpellName(58451),-- Agility - from scroll (not TBC but less good than WotLK elixirs)
	
}
local tbcgelixirs = {
	SpellName(11348),-- Greater Armor/Elixir of Superior Defense
	SpellName(11396),-- Greater Intellect
	SpellName(24363),-- Mana Regeneration/Mageblood Potion
	SpellName(28502),-- Major Armor/Elixir of Major Defense
	SpellName(28509),-- Greater Mana Regeneration/Elixir of Major Mageblood
	SpellName(28514),-- Empowerment
	SpellName(29626),-- Earthen Elixir
	SpellName(39625),-- Elixir of Major Fortitude
	SpellName(39627),-- Elixir of Draenic Wisdom
	SpellName(39628),-- Elixir of Ironskin
	SpellName(58453),-- Armor - from scroll (not TBC but less good than WotLK elixirs)
	SpellName(48102),-- Stamina - from scroll (not TBC but less good than WotLK elixirs)
}

local wotlkbelixirs = {
	SpellName(28497), -- Mighty Agility
	SpellName(53748), -- Mighty Strength
	SpellName(53749), -- Guru's Elixir
	SpellName(33721), -- Spellpower Elixir
	SpellName(53746), -- Wrath Elixir
	SpellName(60345), -- Armor Piercing
	SpellName(60340), -- Accuracy
	SpellName(60344), -- Expertise
	SpellName(60341), -- Deadly Strikes
	SpellName(60346), -- Lightning Speed
}
local wotlkgelixirs = {
	SpellName(60347), -- Mighty Thoughts
	SpellName(53751), -- Mighty Fortitude
	SpellName(53747), -- Elixir of Spirit
	SpellName(60343), -- Mighty Defense
	SpellName(53763), -- Elixir of Protection
	SpellName(53764), -- Mighty Mageblood
}

local catabelixirs = {
	SpellName(79477), -- Elixir of the Cobra
	SpellName(79481), -- Elixir of Impossible Accuracy
	SpellName(79632), -- Elixir of Mighty Speed
	SpellName(79635), -- Elixir of the Master
	SpellName(79468), -- Ghost Elixir
	SpellName(79474), -- Elixir of the Naga
}

local catagelixirs = {
	SpellName(79480), -- Elixir of Deep Earth
	SpellName(79631), -- Prismatic Elixir
}

local mopbelixirs = {
	SpellName(105682), -- Mad Hozen Elixir
	SpellName(105683), -- Elixir of Weaponry
	SpellName(105684), -- Elixir of the Rapids
	SpellName(105685), -- Elixir of Peace
	SpellName(105686), -- Elixir of Perfection
	SpellName(105688), -- Monk\'s Elixir
}

local mopgelixirs = {
	SpellName(105681), -- Mantid Elixir
	SpellName(105687), -- Elixir of Mirrors
}

-- all old flixirs
local oldflasks = {}
local oldbelixirs = {}
local oldgelixirs = {}
for _,t in pairs({tbcflasks,wotlkflasks,cataflasks}) do
   for _,v in ipairs (t) do
	table.insert(oldflasks,v)
   end
end
for _,t in pairs({tbcbelixirs,wotlkbelixirs,catabelixirs}) do
   for _,v in ipairs (t) do
	table.insert(oldbelixirs,v)
   end
end
for _,t in pairs({tbcgelixirs,wotlkgelixirs,catagelixirs}) do
   for _,v in ipairs (t) do
	table.insert(oldgelixirs,v)
   end
end

-- last expansion flixirs
local lastflasks   = cataflasks
local lastbelixirs = catabelixirs
local lastgelixirs = catagelixirs

-- current expansion flixirs
local currflasks   = mopflasks
local currbelixirs = mopbelixirs
local currgelixirs = mopgelixirs

-- current and last expansion
local recentflasks   = {}
local recentbelixirs = {}
local recentgelixirs = {}

for _,t in pairs({lastflasks, currflasks}) do
  for _,v in ipairs (t) do
	table.insert(recentflasks,v)
  end
end
for _,t in pairs({lastbelixirs, currbelixirs}) do
  for _,v in ipairs (t) do
	table.insert(recentbelixirs,v)
  end
end
for _,t in pairs({lastgelixirs, currgelixirs}) do
  for _,v in ipairs (t) do
	table.insert(recentgelixirs,v)
  end
end

local allclasses = {}
for _,c in pairs(CLASS_SORT_ORDER) do
  allclasses[c] = true
end

local foods = {
	SpellName(35272), -- Well Fed
}

local allfoods = {
	SpellName(35272), -- Well Fed
	SpellName(44106), -- "Well Fed" from Brewfest
	SpellName(43730), -- Electrified
	SpellName(43722), -- Enlightened
	SpellName(25661), -- Increased Stamina
	SpellName(25804), -- Rumsey Rum Black Label
}

local fortitude = {
	SpellName(21562), 	-- Prayer of Fortitude
        SpellName(109773), 	-- Dark Intent
	SpellName(469),     	-- Commanding Shout
        SpellName(90364),   	-- Qiraji Fortitude
}

local statbuff = {
	SpellName(1126), 	-- Mark of the Wild
	SpellName(20217), 	-- Blessing of Kings
        SpellName(117666), 	-- Legacy of the Emperor
        SpellName(90363),   	-- Embrace of the Shale Spider
}

local masterybuff = { 
        SpellName(19740),           -- Blessing of Might
        SpellName(116956),          -- Grace of Air
        SpellName(93435),           -- Roar of Courage
        SpellName(128997),          -- Spirit Beast Blessing        
} 

local spbuff = { 
	SpellName(1459), 	-- Arcane Intellect
	SpellName(61316), 	-- Dalaran Brilliance
        SpellName(109773), 	-- Dark Intent
        SpellName(77747), 	-- Burning Wrath
        SpellName(126309), 	-- Still Water
}

local critbuff = {
        SpellName(116781),	-- Legacy of the White Tiger
        SpellName(17007), 	-- Leader of the Pack
        SpellName(1459), 	-- Arcane Brilliance
        SpellName(61316),	-- Dalaran Brilliance
        SpellName(24604), 	-- Furious Howl
        SpellName(90309), 	-- Terrifying Roar
        SpellName(97229), 	-- Bellowing Roar
        SpellName(126373),	-- Fearless Roar
        SpellName(126309),	-- Still Water        
}

local aspects = {
	SpellName(13165), -- Aspect of the Hawk
	SpellName(109260), -- Aspect of the Iron Hawk
	SpellName(5118), -- Aspect of the Cheetah
	SpellName(13159), -- Aspect of the Pack
}

local badaspects = {
	SpellName(5118), -- Aspect of the Cheetah
	SpellName(13159), -- Aspect of the Pack
}

local magearmors = {
	SpellName(6117), -- Mage Armor
	SpellName(7302), -- Frost Armor
	SpellName(30482), -- Molten Armor
}

local blood_presence = SpellName(48263) -- Blood Presence
local dkpresences = {
	blood_presence,   -- Blood Presence
	SpellName(48266), -- Frost Presence
	SpellName(48265), -- Unholy Presence
}

local seals = {
	SpellName(20165), -- Seal of Insight
	SpellName(20164), -- Seal of Justice
	SpellName(31801), -- Seal of Truth
	SpellName(20154), -- Seal of Righteousness	
}

local scrollofagility = {
	BS[8115], -- Agility
}
scrollofagility.name = BS[8115] -- Agility
scrollofagility.shortname = L["Agil"]

local scrollofstrength = {
	BS[8118], -- Strength
}
scrollofstrength.name = BS[8118] -- Strength
scrollofstrength.shortname = L["Str"]

local scrollofintellect = {
	BS[8096], -- Intellect
}
scrollofintellect.name = BS[8096] -- Intellect
scrollofintellect.shortname = L["Int"]

local scrollofprotection = {
	BS[42206], -- Protection
}
scrollofprotection.name = BS[42206] -- Protection
scrollofprotection.shortname = L["Prot"]

local roguewepbuffs = {
	BS[2818],  -- Deadly
	BS[3409],  -- Crippling
	BS[8679],  -- Wound 
	BS[5760],  -- Mind-numbing
}

local shamanwepbuffs = {
	L["(Flametongue)"], -- Shaman self buff
	L["(Earthliving)"], -- Resto Shaman self buff
	L["(Frostbrand)"], -- Shaman self buff
	L["(Rockbiter)"], -- Shaman self buff
	L["(Windfury)"], -- Shaman self buff
}

local function initreporttable(tablename)
  report[tablename] = report[tablename] or {}
  wipe(report[tablename])
end

local function getbuffinfo(buffinfo_or_checkname)
  local r = buffinfo_or_checkname
  if r and type(r) == "string" then
    local check = addon.BF[r]
    if not check then
      geterrorhandler()("Bad checkname specified for buffinfo: "..r)
    end
    r = check.buffinfo
  end
  if not r then
     geterrorhandler()("missing buffinfo")
  end
  return r
end

local function player_spell(buffinfo)
  local _, class = UnitClass("player")
  for _,info in ipairs(getbuffinfo(buffinfo)) do
    if info[1] == class then
       return BS[info[2]]
    end
  end
  return nil
end

local function unithasbuff(unit, bufflist, staticfavored)
  for _, v in pairs(bufflist) do
    local b = unit.hasbuff[v]
    if b then
      if staticfavored and profile.preferstaticbuff and -- looking for a static buff
         UnitIsVisible(unit.unitid) then -- duration is only available when unit is visible
         if b.duration and b.duration > 5*60 then -- this is the static buff
	   return v,b
	 end
      else
        return v,b
      end
    end
  end
  return nil
end

-- generic buffinfo struct: 1=CLASSNAME, 2=spellid, 3=priority, 4=spec, 5=conflicting_spellid

local wsptmp = {}
local _generic_buffer_cache = {}
local function generic_buffers(buffinfo)
  local ret = _generic_buffer_cache[buffinfo] or {}
  _generic_buffer_cache[buffinfo] = ret
  wipe(ret)
  for _,info in ipairs(getbuffinfo(buffinfo)) do
    for name,unit in pairs(raid.classes[info[1]]) do
       if (info[4] == nil) or (info[4] == unit.spec) then  -- spec-specific buff
         table.insert(ret, name)
       end
    end
  end
  return ret
end

local function generic_whispertobuff(reportl, prefix, buffinfo, buffers, buffname)
  local targets
  if profile.WhisperMany and #reportl >= profile.HowMany then
    targets = L["MANY!"]
  else
    targets = table.concat(reportl, ", ")
  end

  if buffers then
    for _, name in ipairs(buffers) do
      local unit = addon:GetUnitFromName(name)
      if unit and addon:InMyZone(unit.name) and unit.online and not unit.isdead then
         addon:Say(prefix .. "<" .. buffname .. ">: " .. targets, unit.name)
         if profile.whisperonlyone then
            return
         end
      end
    end
    return
  end

  local priority 
  for _,info in ipairs(getbuffinfo(buffinfo)) do -- for each class
    local bname = (buffname or BS[info[2]])
    local cbuff = info[5] and BS[info[5]]
    if priority and (info[3] ~= priority) then
        return -- already whispered a higher priority class
    end
    wipe(wsptmp)
    for name,unit in pairs(raid.classes[info[1]]) do  -- foreach unit of that class
    --for name,unit in bi_pairs(raid.classes[info[1]], info[2], info[5]) do  -- foreach unit of that class, sorted by autoguess best buff candidate
        if addon:InMyZone(name) and unit.online and not unit.isdead 
	   and ((info[4] == nil) or (info[4] == unit.spec)) then
	   local code = 5
	   if unit.hasbuff[bname] and unit.hasbuff[bname].caster == name then
	      code = 1 -- already self-buffed, top priority
	   elseif cbuff and unit.hasbuff[cbuff] and unit.hasbuff[cbuff].caster == name then -- self buffed with conflicting
	      code = 9
	   end
	   table.insert(wsptmp, code.."#"..name)
	end
    end
    table.sort(wsptmp)
    for _,codedname in ipairs(wsptmp) do
    	   local _,name = strsplit("#",codedname)
           addon:Say(prefix .. "<" .. bname .. ">: " .. targets, name)
           if profile.whisperonlyone then
              return
           else
              priority = info[3]
           end
    end
  end
end

function addon:ValidateSpellIDs()
  for checkname, info in pairs(addon.BF) do
    local buffinfo = info.buffinfo
    if buffinfo then
      for _, info in ipairs(buffinfo) do
        if not info[1] or not allclasses[info[1]] or 
	   (info[3] and type(info[3]) ~= "number") then
	  geterrorhandler()("bad buffinfo entry in check: "..checkname)
	end
	local spell = BS[info[2]] -- this throws error if spellid is bad
      end
    end
  end
end

local BF = {
	pvp = {											-- button name
		order = 1000,
		list = "pvplist",								-- list name
		check = "checkpvp",								-- check name
		default = false,									-- default state enabled
		defaultbuff = false,								-- default state report as buff missing
		defaultwarning = true,								-- default state report as warning
		defaultdash = false,								-- default state show on dash
		defaultdashcombat = false,							-- default state show on dash when in combat
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = true,								-- check when unit is not in this zone
		selfbuff = true,								-- is it a buff the player themselves can fix
		timer = true,									-- rbs will count how many minutes this buff has been missing/active
		chat = L["PVP On"],								-- chat report
		pre = nil,
		main = function(self, name, class, unit, raid, report)				-- called in main loop
			if UnitIsPVP(unit.unitid) then
				table.insert(report.pvplist, name)
			end
		end,
		post = nil,									-- called after main loop
		icon = "Interface\\Icons\\INV_BannerPVP_02",					-- icon
		update = function(self)								-- icon text
			addon:DefaultButtonUpdate(self, report.pvplist, profile.checkpvp, true, report.pvplist)
		end,
		click = function(self, button, down)						-- button click
			addon:ButtonClick(self, button, down, "pvp")
		end,
		tip = function(self)								-- tool tip
			addon:Tooltip(self, L["PVP is On"], report.pvplist, raid.BuffTimers.pvptimerlist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},

	health = {
		order = 970,
		list = "healthlist",
		check = "checkhealth",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		class = allclasses,
		chat = L["Health less than 80%"],
		main = function(self, name, class, unit, raid, report)
			if not unit.isdead then
				if UnitHealth(unit.unitid)/UnitHealthMax(unit.unitid) < 0.8 then
					table.insert(report.healthlist, name)
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_131",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.healthlist, profile.checkhealth, true, report.healthlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "health")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Player has health less than 80%"], report.healthlist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},

	mana = {
		order = 960,
		list = "manalist",
		check = "checkmana",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		class = { PRIEST = true, DRUID = true, PALADIN = true, MAGE = true, WARLOCK = true, SHAMAN = true, MONK = true },
		chat = L["Mana less than 80%"],
		main = function(self, name, class, unit, raid, report)
			if unit.isdead then return end
			if not unit.hasmana then return end
			if UnitMana(unit.unitid)/UnitManaMax(unit.unitid) < 0.8 then
				table.insert(report.manalist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_137",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.manalist, profile.checkmana, true, report.manalist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "mana")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Player has mana less than 80%"], report.manalist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},
	zone = {
		order = 950,
		list = "zonelist",
		check = "checkzone",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true, -- actually has no effect
		selfbuff = false,
		timer = false,
		core = true,
		chat = L["Different Zone"],
		main = nil, -- done by main code
		post = nil,
		icon = "Interface\\Icons\\INV_Misc_QuestionMark",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.zonelist, profile.checkzone, true)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "zone")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Player is in a different zone"], 
			              nil, nil, nil, nil, 
				      (#report.zonelist > 0) and not InCombatLockdown() and L["Right-click to target"], 
				      nil, nil, nil, report.zonelist)
		end,
		whispertobuff = function(reportl, prefix)
			if not raid.leader or #reportl < 1 then
				return
			end
			if profile.WhisperMany and #reportl >= profile.HowMany then
				addon:Say(prefix .. "<" .. addon.BF.zone.chat .. ">: " .. L["MANY!"], raid.leader)
			else
				addon:Say(prefix .. "<" .. addon.BF.zone.chat .. ">: " .. table.concat(reportl, ", "), raid.leader)
			end
		end,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},

	offline = {
		order = 940,
		list = "offlinelist",
		check = "checkoffline",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true, -- actualy has no effect
		selfbuff = false,
		timer = true,
		core = true,
		chat = L["Offline"],
		main = nil, -- done by main code
		post = nil,
		icon = "Interface\\Icons\\INV_Gizmo_FelStabilizer",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.offlinelist, profile.checkoffline, true, nil)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "offline")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Player is Offline"], report.offlinelist, raid.BuffTimers.offlinetimerlist)
		end,
		whispertobuff = function(reportl, prefix)
			if not raid.leader or #reportl < 1 then
				return
			end
			if profile.WhisperMany and #reportl >= profile.HowMany then
				addon:Say(prefix .. "<" .. addon.BF.offline.chat .. ">: " .. L["MANY!"], raid.leader)
			else
				addon:Say(prefix .. "<" .. addon.BF.offline.chat .. ">: " .. table.concat(reportl, ", "), raid.leader)
			end
		end,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},

	afk = {
		order = 930,
		list = "afklist",
		check = "checkafk",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true,
		selfbuff = true,
		timer = true,
		chat = L["AFK"],
		main = function(self, name, class, unit, raid, report)
			if UnitIsAFK(unit.unitid) then
				table.insert(report.afklist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\Trade_Fishing",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.afklist, profile.checkafk, true, report.afklist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "afk")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Player is AFK"], report.afklist, raid.BuffTimers.afktimerlist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},

	dead = {
		order = 920,
		list = "deadlist",
		check = "checkdead",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true,
		selfbuff = false,
		timer = true,
		class = allclasses,
		buffinfo = { { "PRIEST", 2006 }, { "DRUID", 50769 }, { "PALADIN", 7328 }, { "SHAMAN", 2008 }, { "MONK", 115178 } },
		chat = L["Dead"],
		main = function(self, name, class, unit, raid, report)
			if unit.isdead then
				table.insert(report.deadlist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\Spell_Holy_SenseUndead",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.deadlist, profile.checkdead, true, generic_buffers("dead"))
		end,
		click = function(self, button, down)
			local rezspell
			if not InCombatLockdown() then
			  rezspell = player_spell("dead") or BS[83968] -- mass resurrection
			end
			addon:ButtonClick(self, button, down, "dead", rezspell, true)
		end,
		tip = function(self)
			addon:Tooltip(self, L["Player is Dead"], report.deadlist, raid.BuffTimers.deadtimerlist, generic_buffers("dead"))
		end,
		singlebuff = true,
		partybuff = false,
		raidbuff = false,
		whispertobuff = function (reportl, prefix) generic_whispertobuff(reportl, prefix, "dead", nil, L["Dead"]) end,
		other = true,
	},
	durability = {
		order = 910,
		list = "durabilitylist",
		check = "checkdurability",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = true,
		selfbuff = true,
		timer = false,
		chat = L["Low durability"],
		main = function(self, name, class, unit, raid, report)
			if not raid.israid or raid.isbattle then
				return
			end
			report.checking.durabilty = true
			local broken = addon.broken[name]
			if broken ~= nil and broken ~= "0" then
				table.insert(report.durabilitylist, name .. "(0)")
			else
				local dura = addon.durability[name]
				if dura ~= nil and dura < 36 then
					table.insert(report.durabilitylist, name .. "(" .. dura .. ")")
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Chest_Cloth_61",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.durabilitylist, profile.checkdurability, report.checking.durabilty or false, report.durabilitylist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "durability")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Low durability (35% or less)"], report.durabilitylist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		other = true,
	},

	cheetahpack = {
		order = 900,
		list = "cheetahpacklist",
		check = "checkcheetahpack",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { HUNTER = true, },
		chat = L["Aspect Cheetah/Pack On"],
		main = function(self, name, class, unit, raid, report)
			if class == "HUNTER" then
				report.checking.cheetahpack = true
				for _, v in ipairs(badaspects) do
					if unit.hasbuff[v] then
						local caster = unit.hasbuff[v].caster
						if not caster or #caster == 0 then
						   caster = name -- caster is nil when out of range
						end
						-- only report each caster once
						report.cheetahpacklist[caster] = caster.."("..v..")"
					end
				end
			end
		end,
		post = function(self, raid, report)
		        local l = report.cheetahpacklist
			local gotone = true
			while gotone do
			  gotone = false
		          for k,v in pairs(l) do -- convert to numeric list for sorting
			    if type(k) ~= "number" then
			      l[k] = nil
			      table.insert(l,v) 
			      gotone = true
			      break
			    end
			  end
			end
			table.sort(l)
		end,
		icon = BSI[5118], -- Aspect of the Cheetah
		update = function(self)
			addon:DefaultButtonUpdate(self, report.cheetahpacklist, profile.checkcheetahpack, report.checking.cheetahpack or false, report.cheetahpacklist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "cheetahpack")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Aspect of the Cheetah or Pack is on"], report.cheetahpacklist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
	},

	oldflixir = {
		order = 895,
		list = "oldflixirlist",
		check = "checkoldflixir",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Flasked or Elixired but slacking"],
		main = nil, -- set in flask check
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_91",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.oldflixirlist, profile.checkoldflixir, true, report.oldflixirlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "oldflixir")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Flasked or Elixired but slacking"], report.oldflixirlist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
		consumable = true,
	},

	slackingfood = {
		order = 894,
		list = "slackingfoodlist",
		check = "checkslackingfood",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		chat = L["Well Fed but slacking"],
		main = nil, -- handled in food check
		post = nil,
		icon = "Interface\\Icons\\INV_Misc_Food_67",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.slackingfoodlist, profile.checkslackingfood, true, report.slackingfoodlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "slackingfood")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Well Fed but slacking"], report.slackingfoodlist)
		end,
		partybuff = nil,
		consumable = true,
	},

	righteousfury = {
		order = 310,
		list = "righteousfurylist",
		check = "checkrighteousfury",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		core = true,
		class = { PALADIN = true, },
		chat = BS[25780], -- Righteous Fury
		main = function(self, name, class, unit, raid, report)
			if class == "PALADIN" and raid.classes.PALADIN[name].spec == 2 then
					report.checking.righteousfury = true
					if not unit.hasbuff[BS[25780]] then -- Righteous Fury
						table.insert(report.righteousfurylist, name)
					end
			end
		end,
		post = nil,
		icon = BSI[25780], -- Righteous Fury
		update = function(self)
			addon:DefaultButtonUpdate(self, report.righteousfurylist, profile.checkrighteousfury, report.checking.righteousfury or false, report.righteousfurylist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "righteousfury", BS[25780]) -- Righteous Fury
		end,
		tip = function(self)
			addon:Tooltip(self, L["Protection Paladin with no Righteous Fury"], report.righteousfurylist)
		end,
		whispertobuff = nil,
		singlebuff = nil,
		partybuff = nil,
		raidbuff = nil,
	},


	earthshield = {
		order = 875,
		list = "earthshieldslackers",
		check = "checkearthshield",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		class = { SHAMAN = true, },
--		chat = BS[974],  -- Earth Shield
		chat = function(report, raid, prefix, channel)
			prefix = prefix or ""
			if report.checking.earthshield then
				if # report.earthshieldslackers > 0 then
					addon:Say(prefix .. "<" .. L["Missing "] .. BS[974] .. ">: " .. table.concat(report.tanksneedingearthshield, ", "), nil, nil, channel)  -- Earth Shield
					addon:Say(L["Slackers: "] .. table.concat(report.earthshieldslackers, ", "))
				end
			end
		end,
		pre = function(self, raid, report)
			initreporttable("tanksneedingearthshield")
			initreporttable("tanksgotearthshield")
			initreporttable("shamanwithearthshield")
			initreporttable("haveearthshield")
			initreporttable("earthshieldslackers")
		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.SHAMAN < 1 then
				return
			end
			if class == "SHAMAN" then
				if raid.classes.SHAMAN[name].spec == 3 then
					table.insert(report.shamanwithearthshield, name)
				end
			end
			local hasbuff = unit.hasbuff[BS[974]] -- Earth Shield
			if hasbuff then
				report.haveearthshield[name] = hasbuff.caster
			end
			if unit.istank or
			       GetPartyAssignment("MAINTANK",unit.unitid) then -- allow earthshield on non-traditional tanks
					report.checking.earthshield = true
					if hasbuff then
						table.insert(report.tanksgotearthshield, name)
					else
						table.insert(report.tanksneedingearthshield, name)
					end
			end
		end,
		post = function(self, raid, report)
			local numberneeded = #report.tanksneedingearthshield
			local numberavailable = #report.shamanwithearthshield - #report.tanksgotearthshield
			if #report.tanksneedingearthshield > 0 and #report.shamanwithearthshield > 0 then
				report.checking.earthshield = true
			end
			if numberneeded > 0 and numberavailable > 0 then
				for _, name in ipairs(report.shamanwithearthshield) do
					local found = false
					for _, caster in pairs(report.haveearthshield) do
						if caster == name then
							found = true
							break
						end
					end
					if not found then
						table.insert(report.earthshieldslackers, name)
					end
				end
			else
				wipe(report.tanksneedingearthshield)
			end
		end,
		icon = BSI[974],  -- Earth Shield
		update = function(self)
			addon:DefaultButtonUpdate(self, report.tanksneedingearthshield, profile.checkearthshield, report.checking.earthshield or false, addon.BF.earthshield:buffers())
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "earthshield", BS[974], true)  -- Earth Shield
		end,
		tip = function(self)
			addon:Tooltip(self, L["Tank missing Earth Shield"], report.tanksneedingearthshield, nil, addon.BF.earthshield:buffers(), report.earthshieldslackers, nil, nil, nil, report.haveearthshield)
		end,
		singlebuff = true,
		partybuff = false,
		raidbuff = false,
		whispertobuff = function(reportl, prefix)
			for _,name in pairs(report.earthshieldslackers) do
				addon:Say(prefix .. "<" .. L["Missing "] .. BS[974] .. ">: " .. table.concat(report.tanksneedingearthshield, ", "), name)  -- Earth Shield
			end
		end,
		buffers = function()
			local theshamans = {}
			for name,rcn in pairs(raid.classes.SHAMAN) do
				if rcn.spec == 3 then
					table.insert(theshamans, name)
				end
			end
			return theshamans
		end,
		singletarget = true,
	},

	soulstone = {
		order = 860,
		list = "nosoulstonelist",
		check = "checksoulstone",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = true,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = true,
		selfbuff = false,
		timer = false,
		class = { WARLOCK = true, },
		chat = function(report, raid, prefix, channel)
			prefix = prefix or ""
			if report.checking.soulstone then
				if # report.soulstonelist < 1 and addon.BF.soulstone:lockwithnocd() then
					addon:Say(prefix .. "<" .. L["No Soulstone detected"] .. ">", nil, nil, channel)
				end
			end
		end,
		pre = function(self, raid, report)
			initreporttable("soulstonelist")
			initreporttable("havesoulstonelist")
		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.WARLOCK > 0 then
				report.checking.soulstone = true
				if unit.hasbuff[BS[20707]] then -- Soulstone Resurrection
					table.insert(report.soulstonelist, name)
					report.havesoulstonelist[name] = unit.hasbuff[BS[20707]].caster -- Soulstone Resurrection
				end
			end
		end,
		post = function(self, raid, report)
			if # report.soulstonelist < 1 and addon.BF.soulstone:lockwithnocd() then
				table.insert(report.nosoulstonelist, "raid")
			end
		end,
		icon = "Interface\\Icons\\Spell_Shadow_SoulGem",
		update = function(self)
			if profile.checksoulstone then
				if report.checking.soulstone then
					self:SetAlpha(1)
					if # report.soulstonelist > 0 or not addon.BF.soulstone:lockwithnocd() then
						self.count:SetText("0")
					else
						self.count:SetText("1")
					end
				else
					self:SetAlpha(0.15)
					self.count:SetText("")
				end
			else
				self:SetAlpha(0.5)
				self.count:SetText("X")
			end
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "soulstone")
		end,
		tip = function(self)
			if not report.soulstonelist then  -- fixes error when tip being called from option window when not in a party/raid
				addon:Tooltip(self, L["Someone has a Soulstone or not"])
			else
				if #report.soulstonelist < 1 then
					addon:Tooltip(self, L["Someone has a Soulstone or not"], {L["No Soulstone detected"]}, nil, addon.BF.soulstone:buffers())
				else
					addon:Tooltip(self, L["Someone has a Soulstone or not"], nil, nil, addon.BF.soulstone:buffers(), nil, nil, nil, nil, report.havesoulstonelist)
				end
			end
		end,
		partybuff = nil,
		whispertobuff = function(reportl, prefix)
			local lock = addon.BF.soulstone:lockwithnocd()
			if lock then
				addon:Say(prefix .. "<" .. L["No Soulstone detected"] .. ">", lock)
			end
		end,
		buffers = function()
			local thelocks = {}
			local thetime = time()
			for name,_ in pairs(raid.classes.WARLOCK) do
				if addon:GetLockSoulStone(name) then
--					addon:Debug(name .. " is on ss cd")
					local thedifference = addon:GetLockSoulStone(name) - thetime
					if thedifference > 0 then
						name = name .. "(" ..  math.floor(thedifference / 60) .. "m" .. (thedifference % 60) .. "s)"
					end
				end
				table.insert(thelocks, name)
			end
			return thelocks
		end,
		lockwithnocd = function()
			for name,_ in pairs(raid.classes.WARLOCK) do
				if not addon:GetLockSoulStone(name) or (addon:GetLockSoulStone(name) and time() > addon:GetLockSoulStone(name)) then
					return name
				end
			end
			return nil
		end,
		singletarget = true,
	},

	healthstone = {
		order = 850,
		list = "healthstonelist",
		check = "checkhealthstone",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = ITN[5512], -- Healthstone
		itemcheck = {
			item = "5512", -- Healthstone
			min = 1,
			frequency = 60 * 3,
			frequencymissing = 30,
		},
		pre = function(self, raid, report)
			if raid.ClassNumbers.WARLOCK < 1 or not raid.israid or raid.isbattle then
				return
			end
			initreporttable("healthstonelistunknown")
			initreporttable("healthstonelistgotone")
		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.WARLOCK < 1 or not raid.israid or raid.isbattle then
				return
			end
			report.checking.healthstone = true
			local stones = addon:ItemQuery("healthstone", name)
			if stones == nil then
				table.insert(report.healthstonelistunknown, name)
			elseif stones < addon.itemcheck.healthstone.min then
				table.insert(report.healthstonelist, name)
			else
				table.insert(report.healthstonelistgotone, name)
			end
		end,
		icon = BSI[34130], -- Healthstone
		update = function(self)
			addon:DefaultButtonUpdate(self, report.healthstonelist, profile.checkhealthstone, report.checking.healthstone or false, addon.BF.healthstone:buffers())
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "healthstone")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. ITN[5512], report.healthstonelist, nil, addon.BF.healthstone:buffers(), nil, nil, nil, report.healthstonelistunknown, report.healthstonelistgotone) -- Healthstone
		end,
		partybuff = nil,
		whispertobuff = function(reportl, prefix)
			if addon.soulwelllastseen > GetTime() then -- whisper the slackers instead of the locks as a soul well is up
				if #reportl > 0 then
					for _, v in ipairs(reportl) do
						addon:Say(prefix .. "<" .. L["Missing "] .. ITN[5512] .. ">: " .. v, v) -- Healthstone
					end
				end
			else
				local thelocks = addon.BF.healthstone:buffers()
				for _,name in pairs(thelocks) do
					if profile.WhisperMany and #reportl >= profile.HowMany then
						addon:Say(prefix .. "<" .. L["Missing "] .. ITN[5512] .. ">: " .. L["MANY!"], name) -- Healthstone
					else
						addon:Say(prefix .. "<" .. L["Missing "] .. ITN[5512] .. ">: " .. table.concat(reportl, ", "), name) -- Healthstone
					end
				end
			end
		end,
		buffers = function()
			local thelocks = {}
			for name,rcn in pairs(raid.classes.WARLOCK) do
				table.insert(thelocks, name)
			end
			return thelocks
		end,
		consumable = true,
	},

	flaskofbattle = {
		order = 840,
		list = "flaskofbattlelist",
		check = "checkflaskofbattle",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = nil,
		itemcheck = {
			item = "65455", -- Flask of Battle
			min = 0,
			frequency = 60 * 3,
			frequencymissing = 60 * 3,
		},
		pre = function(self, raid, report)
			if not raid.israid then
				return
			end
			initreporttable("flaskofbattlelistunknown")
			initreporttable("flaskofbattlelistgotone")
		end,
		main = function(self, name, class, unit, raid, report)
			if not raid.israid then
				return
			end
			report.checking.flaskofbattle = true
			local flasks = addon:ItemQuery("flaskofbattle", name)
			if flasks == nil then
				table.insert(report.flaskofbattlelistunknown, name)
			elseif flasks >= 1 then
				report.flaskofbattlelistgotone[name] = flasks
			end
		end,
		icon = ITT[65455], -- Flask of Battle
		iconfix = function(self) -- to handle when server is slow to get the icon
			if addon.BF.flaskofbattle.icon == "Interface\\Icons\\INV_Misc_QuestionMark" then
				addon.BF.flaskofbattle.icon = ITT[65455] -- Flask of Battle
				if addon.BF.flaskofbattle.icon == "Interface\\Icons\\INV_Misc_QuestionMark" then
					return true
				end
			end
			return false
		end,
		update = function(self)
			addon:DefaultButtonUpdate(self, report.flaskofbattlelist, profile.checkflaskofbattle, report.checking.flaskofbattle or false)
			if self.count:GetText() ~= "X" then
				self.count:SetText("")
			end
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "flaskofbattle")
		end,
		tip = function(self)
			addon:Tooltip(self, ITN[65455] .. L[" in their bags"], nil, nil, nil, nil, nil, nil, report.flaskofbattlelistunknown, nil, nil, report.flaskofbattlelistgotone) -- Flask of Battle
		end,
		partybuff = nil,
		whispertobuff = nil,
		buffers = nil,
		consumable = true,
	},

	food = {
		order = 500,
		list = "foodlist",
		check = "checkfood",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		core = true,
		class = allclasses,
		chat = BS[35272], -- Well Fed
		main = function(self, name, class, unit, raid, report)
			local missingbuff = true
			local foodz = unit.hasbuff["foodz"]
			local eating = unit.hasbuff["eating"]
			if foodz then
			   local statval = 0
			   for v in string.gmatch(foodz, "%d+") do  -- assume largest number in tooltip is the statval
			      statval = math.max(statval,tonumber(v)) 
			   end
			   if select(2,UnitRace(unit.unitid)) == "Pandaren" then -- normalize for Epicurean racial
			      statval = statval / 2
			   end
			   if statval >= 100 and string.find(foodz, ITEM_MOD_STAMINA_SHORT) then -- normalize for MoP stam bonus
			      statval = statval * 300 / 450
			   end
			   if statval >= profile.foodlevel or
			      select(11,UnitBuff(unit.unitid, foods[1])) == 66623 then -- bountiful feast
			      missingbuff = false
			   elseif statval > 0 then -- try to detect the stat on the slacking food
			      addon.foodstats = addon.foodstats or {
			        ITEM_MOD_STRENGTH_SHORT,
			        ITEM_MOD_AGILITY_SHORT,
			        ITEM_MOD_INTELLECT_SHORT,
			        ITEM_MOD_PARRY_RATING_SHORT,
			        ITEM_MOD_DODGE_RATING_SHORT,
			        ITEM_MOD_CRIT_RATING_SHORT,
			        ITEM_MOD_HASTE_RATING_SHORT,
			        ITEM_MOD_MASTERY_RATING_SHORT,
			        ITEM_MOD_EXPERTISE_RATING_SHORT,
			        ITEM_MOD_HIT_RATING_SHORT,
			        ITEM_MOD_ATTACK_POWER_SHORT,
			        ITEM_MOD_SPELL_POWER_SHORT,
			        ITEM_MOD_MANA_REGENERATION_SHORT,
			        ITEM_MOD_SPIRIT_SHORT,  -- sometimes is secondary
			        ITEM_MOD_STAMINA_SHORT, -- should come last, as often appears as secondary stat
			      }
			      local statstr = "" 
			      foodz = " "..foodz.." "
			      for _,stat in ipairs(addon.foodstats) do
			        if foodz:upper():find(" "..stat:upper().." ") then
				  statstr = " "..stat
				  break
				end
			      end
			      name = name.."("..statval..statstr..")"
			   end
			end
                        
			if missingbuff then
				for _, v in ipairs(foods) do
					if unit.hasbuff[v] then
						missingbuff = false
			                        table.insert(report.slackingfoodlist, name)
						break
					end
				end
			end

			if missingbuff and eating and profile.ignoreeating then
				missingbuff = false -- assume they are eating acceptable food
			end

			if missingbuff then
				if eating then
					name = name.."("..L["Eating"]..")"
					report.foodlist.notes = true
				end
				table.insert(report.foodlist, name)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Misc_Food_74",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.foodlist, profile.checkfood, true, report.foodlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "food")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Not Well Fed"], report.foodlist)
		end,
		partybuff = nil,
		consumable = true,
	},
	
	flask = {
		order = 490,
		list = "flasklist",
		check = "checkflaskir",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		core = true,
		class = allclasses,
		chat = L["Flask or two Elixirs"],
		pre = function(self, raid, report)
			initreporttable("belixirlist")
			initreporttable("gelixirlist")
		end,
		main = function(self, name, class, unit, raid, report)
			report.checking.flaskir = true
			local cflasks = currflasks
			local cbelixirs = currbelixirs
			local cgelixirs = currgelixirs
			if profile.OldFlasksElixirs then
				cflasks = recentflasks
				cbelixirs = recentbelixirs
				cgelixirs = recentgelixirs
			end
			if not unithasbuff(unit, cflasks) then
			  	for _, v in ipairs(oldflasks) do
					if unit.hasbuff[v] then -- slacking flask
						table.insert(report.oldflixirlist, name .. "(" .. v .. ")")
						break
					end
			  	end
				local numbbelixir = 0
				local numbgelixir = 0
				for _, v in ipairs(cbelixirs) do
					if unit.hasbuff[v] then
						numbbelixir = 1
						break
					end
				end
				if numbbelixir == 0 then
			  	  for _, v in ipairs(oldbelixirs) do
					if unit.hasbuff[v] then -- slacking elixir
						table.insert(report.oldflixirlist, name .. "(" .. v .. ")")
						break
					end
				  end
			  	end
				for _, v in ipairs(cgelixirs) do
					if unit.hasbuff[v] then
						numbgelixir = 1
						break
					end
				end
				if numbgelixir == 0 then
			  	  for _, v in ipairs(oldgelixirs) do
					if unit.hasbuff[v] then -- slacking elixir
						table.insert(report.oldflixirlist, name .. "(" .. v .. ")")
						break
					end
				  end
			  	end
				local totalelixir = numbbelixir + numbgelixir
				if totalelixir == 0 then
					table.insert(report.flasklist, name) -- no flask or elixir
				elseif totalelixir == 1 then
					if numbbelixir == 0 then
						table.insert(report.belixirlist, name)
					else
						table.insert(report.gelixirlist, name)
					end
				end
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_119",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.flasklist, profile.checkflaskir, true, report.flasklist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "flask")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing a Flask or two Elixirs"], report.flasklist)
		end,
		partybuff = nil,
		consumable = true,
	},
	belixir = {
		order = 480,
		list = "belixirlist",
		check = "checkflaskir",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		core = true,
		class = allclasses,
		chat = L["Battle Elixir"],
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_111",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.belixirlist, profile.checkflaskir, true, report.belixirlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "flask")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing a Battle Elixir"], report.belixirlist)
		end,
		partybuff = nil,
		consumable = true,
	},
	
	gelixir = {
		order = 470,
		list = "gelixirlist",
		check = "checkflaskir",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		core = true,
		class = allclasses,
		chat = L["Guardian Elixir"],
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_158",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.gelixirlist, profile.checkflaskir, true, report.gelixirlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "flask")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing a Guardian Elixir"], report.gelixirlist)
		end,
		partybuff = nil,
		consumable = true,
	},

	wepbuff = {
		order = 410,
		list = "wepbufflist",
		check = "checkwepbuff",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		class = { ROGUE = true, SHAMAN = true, },
		chat = L["Weapon buff"],
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if class == "ROGUE" then
                                report.checking.wepbuff = true
                                if not unithasbuff(unit, roguewepbuffs) then
                                        table.insert(report.wepbufflist, name)
                                end
				return
			elseif class ~= "SHAMAN" then
 				return
                        elseif not UnitIsUnit(unit.unitid, "player") then
				return -- XXX
			end
			local bufflist = false
			local dualw = false
			bufflist = shamanwepbuffs
			if raid.classes.SHAMAN[name].spec == 2 then
				dualw = true
			end
			if _G.InspectFrame and _G.InspectFrame:IsShown() then
				return -- can't inspect at same time as UI
			end
			if not CanInspect(unit.unitid) then
				return
			end
			report.checking.wepbuff = true
			local missingbuffmh = true
			local missingbuffoh = true
			local notified
			RBSToolScanner:Reset()
			RBSToolScanner:SetInventoryItem(unit.unitid, 16)
			if RBSToolScanner:NumLines() < 1 then
				if not UnitIsUnit(unit.unitid, "player") then
				   local lastcheck = addon.lastweapcheck[unit.guid] or 0
				   local failed = lastcheck and lastcheck < 0
				   if failed then lastcheck = -lastcheck end
				   if GetTime() < lastcheck + 5*60 then
					addon:Debug("skipping weapcheck for:" .. unit.unitid)
					if failed then
					  table.insert(report.wepbufflist, name)
				        end	
				        return
				   else
					addon:Debug("having to call notifyinspect for:" .. unit.unitid)
					NotifyInspect(unit.unitid)
					notified = unit.unitid
					addon.lastweapcheck[unit.guid] = GetTime()
				   end
				else
					addon:Debug("skipping call notifyinspect for:" .. unit.unitid)
				end
				RBSToolScanner:ClearLines()
				RBSToolScanner:SetInventoryItem(unit.unitid, 16)
				if RBSToolScanner:NumLines() < 1 then
					addon:Debug("NotifyInspect failed")
					return
				end
			end
			for _,buff in ipairs(bufflist) do
				if RBSToolScanner:Find(buff) then
					missingbuffmh = false
					break
				end
			end
			if dualw then
				RBSToolScanner:Reset()
				RBSToolScanner:SetInventoryItem(unit.unitid, 17)
				if RBSToolScanner:NumLines() > 1 then
					for _,buff in ipairs(bufflist) do
						if RBSToolScanner:Find(buff) then
							missingbuffoh = false
							break
						end
					end
				else
					missingbuffoh = false -- nothing equipped
				end
			end
			if missingbuffmh or (dualw and missingbuffoh) then
				table.insert(report.wepbufflist, name)
			        addon.lastweapcheck[unit.guid] = -GetTime()
			end
			if notified then
			  ClearInspectPlayer(notified)
			end
		end,
		post = nil,
		icon = "Interface\\Icons\\INV_Potion_101",
		update = function(self)
			addon:DefaultButtonUpdate(self, report.wepbufflist, profile.checkwepbuff, report.checking.wepbuff or false, report.wepbufflist)
		end,
		click = function(self, button, down)
			local class = select(2, UnitClass("player"))
			local buffspell = nil
			local itemslot = nil
			if class == "ROGUE" then
			  buffspell = BS[2823]
			elseif class == "SHAMAN" then
			  local spec = GetSpecialization()
			  if spec == 1 then -- elemental 
			    buffspell = BS[8024]
                          elseif spec == 2 then -- resto
			    buffspell = BS[51730]
			  elseif spec == 3 then -- enh
			    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, 
                                  hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
			    if not hasMainHandEnchant or mainHandExpiration < 15*60*1000 then
			  	itemslot = GetInventorySlotInfo("MainHandSlot")
			        buffspell = BS[8232]
			    elseif not hasOffHandEnchant or offHandExpiration < 15*60*1000 then
				itemslot = GetInventorySlotInfo("SecondaryHandSlot")
			        buffspell = BS[8024]
			    end
                          end
			end
			addon:ButtonClick(self, button, down, "wepbuff", buffspell, nil, nil, itemslot)
                end,
		tip = function(self)
			addon:Tooltip(self, L["Missing a temporary weapon buff"], report.wepbufflist)
		end,
		partybuff = nil,
		consumable = true,
	},

	spbuff = {
		order = 430,
		list = "spbufflist",
		check = "checkspbuff",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		core = true,
		class = { MAGE = true, WARLOCK = true },
		chat = L["Spellpower Buff"],
		pre = nil,
		buffinfo = { { "MAGE", 1459, 1 }, { "WARLOCK", 109773, 2 } },
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.MAGE > 0 or  raid.ClassNumbers.WARLOCK > 0 then
				report.checking.spbuff = true
				if class ~= "ROGUE" and class ~= "WARRIOR" and class ~= "DEATHKNIGHT" and class ~= "HUNTER" then
					if not unithasbuff(unit, spbuff, true) then
						table.insert(report.spbufflist, name)
					end
				end
			end
		end,
		post = function(self, raid, report)
			table.sort(report.spbufflist)
		end,
		icon = BSI[109773], -- Dark Intent
		update = function(self)
			addon:DefaultButtonUpdate(self, report.spbufflist, profile.checkspbuff, report.checking.spbuff or false, generic_buffers("spbuff"))
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "spbuff", player_spell("spbuff"))
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. L["Spellpower Buff"], report.spbufflist, nil, generic_buffers("spbuff"))
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = generic_whispertobuff,
	},

	statbuff = {
		order = 450,
		list = "statbufflist",
		check = "checkstatbuff",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		core = true,
		class = { DRUID = true, PALADIN = true, MONK = true },
		buffinfo = { { "DRUID", 1126, 1 }, { "MONK", 117666, 1 }, { "PALADIN", 20217, 2, nil, 19740 } },
		chat = L["Stat Buff"], 
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.DRUID > 0 or 
			   raid.ClassNumbers.MONK > 0 or
			   raid.ClassNumbers.PALADIN > 0 then
				report.checking.statbuff = true
				if not unithasbuff(unit, statbuff) then
					table.insert(report.statbufflist, name)
				end
			end
		end,
		post = function(self, raid, report)
			table.sort(report.statbufflist)
		end,
		icon = BSI[1126], -- Mark of the Wild
		update = function(self)
			addon:DefaultButtonUpdate(self, report.statbufflist, profile.checkstatbuff, report.checking.statbuff or false, generic_buffers("statbuff"))
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "statbuff", player_spell("statbuff"))
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. L["Stat Buff"], report.statbufflist, nil, generic_buffers("statbuff"))
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = generic_whispertobuff,
	},
	
	masterybuff = {
		order = 435,
		list = "masterybufflist",
		check = "checkmasterybuff",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		core = true,
		class = { PALADIN = true },
		buffinfo = { { "PALADIN", 19740, 1, nil, 20217 } },
		chat = L["Mastery Buff"], 
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PALADIN > 1 or
                           (raid.ClassNumbers.PALADIN == 1 and
                            (raid.ClassNumbers.DRUID > 0 or raid.ClassNumbers.MONK > 0))
                        then
				report.checking.masterybuff = true
				if not unithasbuff(unit, masterybuff, true) then
					table.insert(report.masterybufflist, name)
				end
			end
		end,
		post = function(self, raid, report)
			table.sort(report.masterybufflist)
		end,
		icon = BSI[19740], -- Blessing of Might
		update = function(self)
			addon:DefaultButtonUpdate(self, report.masterybufflist, profile.checkmasterybuff, report.checking.masterybuff or false, generic_buffers("masterybuff"))
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "masterybuff", player_spell("masterybuff"))
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. L["Mastery Buff"], report.masterybufflist, nil, generic_buffers("masterybuff"))
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = generic_whispertobuff,
	},
	
	fortitude = {
		order = 440,
		list = "fortitudelist",
		check = "checkfortitude",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		core = true,
		class = { PRIEST = true, WARLOCK = true },
		buffinfo = { { "PRIEST", 21562 }, { "WARLOCK", 109773 } },
		chat = BS[21562], -- Prayer of Fortitude
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PRIEST > 0 or
			   raid.ClassNumbers.WARLOCK > 0 then
				report.checking.fortitude = true
				if not unithasbuff(unit, fortitude, true) then
					table.insert(report.fortitudelist, name)
				end
			end
		end,
		post = function(self, raid, report)
			table.sort(report.fortitudelist)
		end,
		icon = BSI[21562], -- Prayer of Fortitude
		update = function(self)
			addon:DefaultButtonUpdate(self, report.fortitudelist, profile.checkfortitude, report.checking.fortitude or false, generic_buffers("fortitude"))
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "fortitude", player_spell("fortitude"))
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[21562], report.fortitudelist, nil, generic_buffers("fortitude")) -- Prayer of Fortitude
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = generic_whispertobuff,
	},

	critbuff = {
		order = 420,
		list = "critbufflist",
		check = "checkcritbuff",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		core = true,
		buffinfo = { { "MAGE", 1459 }, { "MONK", 116781, nil, 3 } }, -- monk buff is windwalker only
		class = { MAGE = true, MONK = true },
		chat = L["Crit Buff"], 
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if report.checking.critbuff == nil then -- only scan once per report
			  local buffers = generic_buffers("critbuff")
			  report.checking.critbuff = ((next(buffers) and true) or false)
			end
			if report.checking.critbuff then
				if not unithasbuff(unit, critbuff, true) then
					table.insert(report.critbufflist, name)
				end
			end
		end,
		post = function(self, raid, report)
			table.sort(report.critbufflist)
		end,
		icon = BSI[116781], -- Legacy of the White Tiger
		update = function(self)
			addon:DefaultButtonUpdate(self, report.critbufflist, profile.checkcritbuff, report.checking.critbuff or false, generic_buffers("critbuff"))
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "critbuff", player_spell("critbuff"))
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. L["Crit Buff"], report.critbufflist, nil, generic_buffers("critbuff"))
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = generic_whispertobuff,
	},

	runescrollfortitude = {
		order = 425,
		list = "runescrollfortitudelist",
		check = "checkrunescrollfortitude",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		chat = BS[69377], -- Fortitude
		iconfix = function(self) -- to handle when server is slow to get the icon
			if addon.BF.runescrollfortitude.icon == "Interface\\Icons\\INV_Misc_QuestionMark" then
				addon.BF.runescrollfortitude.icon = ITT[79257] -- Runescroll of Fortitude
				if addon.BF.runescrollfortitude.icon == "Interface\\Icons\\INV_Misc_QuestionMark" then
					return true
				end
			end
			return false
		end,
		itemcheck = {
			item = "79257", -- Runescroll of Fortitude
			min = 0,
			frequency = 60 * 5,
			frequencymissing = 60 * 5,
		},
		pre = function(self, raid, report)
			if raid.ClassNumbers.PRIEST > 0 or 
			   raid.ClassNumbers.WARLOCK > 0 or 
			   not raid.israid or raid.isbattle then
				return
			end
		end,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PRIEST > 0 or
			   raid.ClassNumbers.WARLOCK > 0 
			   then
				return
			end
			report.checking.runescrollfortitude = true
			local missing = true
			for _,f in pairs(fortitude) do
			  if unit.hasbuff[f] then
			    missing = false
			    break
			  end
			end
			if unit.hasbuff[BS[111922]] or    -- Fortitude III
			   unit.hasbuff[BS[86507]]  or    -- Fortitude II
			   unit.hasbuff[BS[69377]]  then  -- Fortitude I
		 	  missing = false 
			end
			if missing then
				table.insert(report.runescrollfortitudelist, name)
			end
		end,
		post = nil,
		icon = ITT[79257], -- Runescroll of Fortitude
		update = function(self)
			addon:DefaultButtonUpdate(self, report.runescrollfortitudelist, profile.checkrunescrollfortitude, report.checking.runescrollfortitude or false, addon.BF.runescrollfortitude:buffers())
		end,
		click = function(self, button, down)
			local scroll = ITN[79257] -- Runescroll of Fortitude III
			if not addon:GotReagent(scroll) then -- use the best available
			  scroll = ITN[62251] -- Runescroll of Fortitude II
			end
			if not addon:GotReagent(scroll) then -- use the best available
			  scroll = ITN[49632] -- Runescroll of Fortitude
			end
			addon:ButtonClick(self, button, down, "runescrollfortitude", nil, nil, scroll)
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. ITN[49632], report.runescrollfortitudelist, nil, addon.BF.runescrollfortitude:buffers()) -- Runescroll of Fortitude
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = function(reportl, prefix)
			local thebuffers = addon.BF.runescrollfortitude:buffers()
			if thebuffers then
			   generic_whispertobuff(reportl, prefix, nil, thebuffers, ITN[49632])
			end
		end,
		buffers = function()
			local thebuffers = {}
			for _,rc in pairs(raid.classes) do
				for name,_ in pairs(rc) do
					local items = addon:ItemQuery("runescrollfortitude", name) or 0
					if items > 0 then
						table.insert(thebuffers, name .. "(" .. items .. ")")
					end
				end
			end
			return thebuffers
		end,
		consumable = true,
	},

	levitate = {
		order = 320,
		list = "levitatelist",
		check = "checklevitate",
		default = false,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = false,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		core = true,
		buffinfo = { { "PRIEST", 1706, 1 }, { "MAGE", 130, 2 } },
		class = { PRIEST = true, MAGE = true },
		chat = BS[1706], -- Levitate
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if raid.ClassNumbers.PRIEST > 0 or raid.ClassNumbers.MAGE > 0 then
				report.checking.levitate = true
				if not unit.hasbuff[BS[1706]] and not unit.hasbuff[BS[130]] then
					table.insert(report.levitatelist, name)
				end
			end
		end,
		post = function(self, raid, report)
			table.sort(report.levitatelist)
		end,
		icon = BSI[1706], -- Levitate
		update = function(self)
			addon:DefaultButtonUpdate(self, report.levitatelist, profile.checklevitate, report.checking.levitate or false, generic_buffers("levitate"))
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "levitate", player_spell("levitate"), true)
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[1706], report.levitatelist, nil, generic_buffers("levitate"))
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = generic_whispertobuff,
		singletarget = true,
	},

	noaspect = {
		order = 400,
		list = "noaspectlist",
		check = "checknoaspect",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { HUNTER = true, },
		chat = L["Hunter Aspect"],
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if class == "HUNTER" then
				report.checking.noaspect = true
				if not unithasbuff(unit, aspects) then
					table.insert(report.noaspectlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[13165], -- Aspect of the Hawk
		update = function(self)
			addon:DefaultButtonUpdate(self, report.noaspectlist, profile.checknoaspect, report.checking.noaspect or false, report.noaspectlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "noaspect")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Hunter has no aspect at all"], report.noaspectlist)
		end,
		partybuff = nil,
	},

	dkpresence = {
		order = 394,
		list = "dkpresencelist",
		check = "checkdkpresence",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { DEATHKNIGHT = true, },
		chat = L["Death Knight Presence"],
		main = function(self, name, class, unit, raid, report)
			if class ~= "DEATHKNIGHT" then
				return
			end
			report.checking.dkpresence = true
			local presence = unithasbuff(unit, dkpresences)
			if not presence then
				table.insert(report.dkpresencelist, name)
			elseif (unit.istank and presence ~= blood_presence) or
			       (not unit.istank and presence == blood_presence) then
				table.insert(report.dkpresencelist, name.."("..presence..")")
			end
		end,
		post = nil,
		icon = BSI[48266], -- Blood presence
		update = function(self)
			addon:DefaultButtonUpdate(self, report.dkpresencelist, profile.checkdkpresence, report.checking.dkpresence or false, report.dkpresencelist)
		end,
		click = function(self, button, down)
                        local name = UnitName("player")
                        local spec = raid.classes.DEATHKNIGHT[name] and raid.classes.DEATHKNIGHT[name].spec
			addon:ButtonClick(self, button, down, "dkpresence", spec and dkpresences[spec])
		end,
		tip = function(self)
			addon:Tooltip(self, L["Death Knight Presence"], report.dkpresencelist)
		end,
		partybuff = nil,
	},


	symbiosis = {
		order = 392,
		list = "symbiosislist",
		check = "checksymbiosis",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { DRUID = true, },
		chat = BS[110309], -- Symbiosis
		pre = function(self, raid, report)
			initreporttable("havesymbiosis")
			initreporttable("gavesymbiosis")
		end,
		main = function(self, name, class, unit, raid, report)
			-- Symbiosis is supposed to persist through death and only be "cancelled if the druid and target become too far apart"
			-- in reality this cancellation often happens at zone boundaries (releasing upon death from inside an instance)
			-- but more importantly it sometimes only cancels the buff on one of the two players (can happen either direction)
			-- So we need to check every druid has the buff on themselves and a (non-druid) target
			if class == "DRUID" then
				report.checking.symbiosis = true
				if unit.hasbuff[BS[110309]] then -- druid has the buff
					report.gavesymbiosis[name] = true
				else -- druid missing the buff
					table.insert(report.symbiosislist, name)
				end
			elseif unit.hasbuff[BS[110309]] then -- non-druid received the buff
				report.havesymbiosis[name] = unit.hasbuff[BS[110309]].caster or true
			end
		end,
		post = function(self, raid, report)
			local havecnt,gavecnt = 0,0
			for _ in pairs(report.havesymbiosis) do havecnt = havecnt + 1 end
			for _ in pairs(report.gavesymbiosis) do gavecnt = gavecnt + 1 end
			if gavecnt ~= havecnt then -- a buff connection broke
				for nondruid, druid in pairs(report.havesymbiosis) do
					report.gavesymbiosis[druid] = nil -- remove druids accounted for
				end
				for druid in pairs(report.gavesymbiosis) do -- druids whose target lost it (or are not in zone)
					table.insert(report.symbiosislist, druid.."("..L["Broken Link"]..")")
				end
			end
		end,
		icon = BSI[110309], -- Symbiosis
		update = function(self)
			addon:DefaultButtonUpdate(self, report.symbiosislist, profile.checksymbiosis, report.checking.symbiosis or false, report.symbiosislist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "symbiosis")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[110309], report.symbiosislist, -- Symbiosis
						nil, nil, nil, nil, nil, nil,
						report.havesymbiosis)
		end,
		partybuff = nil,
	},

	beacon = {
		order = 393,
		list = "beaconlist",
		check = "checkbeacon",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { PALADIN = true, },
		buffinfo = { { "PALADIN", 53563, 1, 1 } },
		chat = BS[53563], -- Beacon of light
		pre = function(self, raid, report)
			initreporttable("gavebeacon")
			report.gavebeacon.invert_table = true
			report.hpallys = generic_buffers("beacon")
			report.beaconunknown = 0
			if next(report.hpallys) then
				report.checking.beacon = true
			end
		end,
		recordcaster = function(caster, name)
			if not caster or #caster == 0 then
				report.beaconunknown = (report.beaconunknown or 0) + 1
				caster = "?"..report.beaconunknown
			end
			report.gavebeacon[caster] = name
		end,
		main = function(self, name, class, unit, raid, report)
			-- beacon is particularly gross becuse one unit can have multiple beacons
			-- also when targets are ranged/phased we can't tell who cast their beacon buff
			local hasbuff = unit.hasbuff[BS[53563]]
			if hasbuff then
			   if hasbuff.casterlist then
				for _,caster in pairs(hasbuff.casterlist) do
					addon.BF.beacon.recordcaster(caster, name)
				end
			   else
				addon.BF.beacon.recordcaster(hasbuff.caster, name)
			   end
			end
		end,
		post = function(self, raid, report)
			for _, caster in pairs(report.hpallys) do
				if not report.gavebeacon[caster] then
					table.insert(report.beaconlist, caster)
				end
			end
			if report.beaconunknown == #report.beaconlist then -- we see the right number of beacons
				if report.beaconunknown == 1 then -- fixup report list if we can
					report.gavebeacon[report.beaconlist[1]] = report.gavebeacon["?1"]
					report.gavebeacon["?1"] = nil
				end
				wipe(report.beaconlist)
			end
		end,
		icon = BSI[53563], -- Beacon of light
		update = function(self)
			addon:DefaultButtonUpdate(self, report.beaconlist, profile.checkbeacon, report.checking.beacon or false, report.beaconlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "beacon")
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[53563], report.beaconlist, 
						nil, nil, nil, nil, nil, nil,
						report.gavebeacon)
		end,
		partybuff = nil,
	},

	innerfire = {
		order = 390,
		list = "innerfirelist",
		check = "checkinnerfire",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { PRIEST = true, },
		chat = BS[588] .. "/" .. BS[73413], -- Inner Fire/Inner Will
		main = function(self, name, class, unit, raid, report)
			if class == "PRIEST" then
				report.checking.innerfire = true
				if not unit.hasbuff[BS[588]] and not unit.hasbuff[BS[73413]] then -- Inner Fire and Inner Will
					table.insert(report.innerfirelist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[588], -- Inner Fire
		update = function(self)
			addon:DefaultButtonUpdate(self, report.innerfirelist, profile.checkinnerfire, report.checking.innerfire or false, report.innerfirelist)
		end,
		click = function(self, button, down)
			local buffspell = BS[588]  -- Inner Fire
                        local name = UnitName("player")
                        local spec = raid.classes.PRIEST[name] and raid.classes.PRIEST[name].spec
                        if spec == 1 then  -- disc
                           buffspell = BS[73413] -- Inner Will
                        end
			addon:ButtonClick(self, button, down, "innerfire", buffspell)
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[588] .. "/" .. BS[73413], report.innerfirelist) -- Inner Fire/Inner Will
		end,
		partybuff = nil,
	},

	shadowform = {
		order = 387,
		list = "shadowformlist",
		check = "checkshadowform",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { PRIEST = true, },
		chat = BS[15473], -- Shadowform
		main = function(self, name, class, unit, raid, report)
			if class == "PRIEST" then
				if raid.classes.PRIEST[name].spec == 3 then -- Shadowform
					report.checking.shadowform = true
					if not unit.hasbuff[BS[15473]] then -- Shadowform
						table.insert(report.shadowformlist, name)
					end
				end
			end
		end,
		post = nil,
		icon = BSI[15473], -- Shadowform
		update = function(self)
			addon:DefaultButtonUpdate(self, report.shadowformlist, profile.checkshadowform, report.checking.shadowform or false, report.shadowformlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "shadowform", BS[15473]) -- Shadowform
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[15473], report.shadowformlist)
		end,
		partybuff = nil,
	},

	boneshield = {
		order = 385,
		list = "boneshieldlist",
		check = "checkboneshield",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { DEATHKNIGHT = true, },
		chat = BS[49222], -- Bone Shield
		main = function(self, name, class, unit, raid, report)
			if class == "DEATHKNIGHT" then
				if raid.classes.DEATHKNIGHT[name].spec == 1 then
					report.checking.boneshield = true
					if not unit.hasbuff[BS[49222]] then -- Bone Shield
						table.insert(report.boneshieldlist, name)
					end
				end
			end
		end,
		post = nil,
		icon = BSI[49222], -- Bone Shield
		update = function(self)
			addon:DefaultButtonUpdate(self, report.boneshieldlist, profile.checkboneshield, report.checking.boneshield or false, report.boneshieldlist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "boneshield", BS[49222]) -- Bone Shield
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[49222], report.boneshieldlist) -- Bone Shield
		end,
		partybuff = nil,
	},

	soullink = {
		order = 375,
		list = "soullinklist",
		check = "checksoullink",
		default = false,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = false,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { WARLOCK = true, },
		chat = BS[108415], -- Soul Link
		main = function(self, name, class, unit, raid, report)
			if class ~= "WARLOCK" then
				return
			end
			report.checking.soullink = true
			if not unit.hasbuff[BS[108415]] then -- Soul Link
				table.insert(report.soullinklist, name)
			end
		end,
		post = nil,
		icon = BSI[108415], -- Soul Link
		update = function(self)
			addon:DefaultButtonUpdate(self, report.soullinklist, profile.checksoullink, report.checking.soullink or false, report.soullinklist)
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "soullink", BS[108415]) -- Soul Link
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[108415], report.soullinklist) -- Soul Link
		end,
		partybuff = nil,
	},
	magearmor = {
		order = 370,
		list = "magearmorlist",
		check = "checkmagearmor",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { MAGE = true, },
		chat = BS[6117], -- Mage Armor
		pre = nil,
		main = function(self, name, class, unit, raid, report)
			if class == "MAGE" then
				report.checking.magearmor = true
				if not unithasbuff(unit, magearmors) then
					table.insert(report.magearmorlist, name)
				end
			end
		end,
		post = nil,
		icon = BSI[30482], -- Molten Armor
		update = function(self)
			addon:DefaultButtonUpdate(self, report.magearmorlist, profile.checkmagearmor, report.checking.magearmor or false, report.magearmorlist)
		end,
		click = function(self, button, down)
		        local buffspell
                        local name = UnitName("player")
			local spec = raid.classes.MAGE[name] and raid.classes.MAGE[name].spec
                        if spec == 1 then  -- arcane
			   buffspell = BS[6117] -- Mage Armor
                        elseif spec == 2 then  -- fire
			   buffspell = BS[30482] -- Molten Armor
			elseif spec == 3 then
			   buffspell = BS[7302] -- Frost Armor
			else -- no spec, favor lowest lvl spell
			   buffspell = BS[30482] -- Molten Armor
			end
			addon:ButtonClick(self, button, down, "magearmor", buffspell)
		end,
		tip = function(self)
			addon:Tooltip(self, L["Mage is missing a Mage Armor"], report.magearmorlist)
		end,
		partybuff = nil,
	},

	shamanshield = {
		order = 355,
		list = "shamanshieldlist",
		check = "checkshamanshield",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		timer = false,
		class = { SHAMAN = true, },
		chat = BS[52127] .. "/" .. BS[324], -- Water Shield/Lightning Shield
		main = function(self, name, class, unit, raid, report)
			if class ~= "SHAMAN" then
				return
			end
			report.checking.shamanshield = true

			local missing = true
			if unit.hasbuff[BS[52127]] then -- Water Shield
				missing = false
			elseif unit.hasbuff[BS[324]] then -- Lightning Shield
				missing = false
			end
			if missing then
				table.insert(report.shamanshieldlist, name)
			end
		end,
		post = nil,
		icon = BSI[52127], -- Water Shield 
		update = function(self)
			addon:DefaultButtonUpdate(self, report.shamanshieldlist, profile.checkshamanshield, report.checking.shamanshield or false, report.shamanshieldlist)
		end,
		click = function(self, button, down)
			local buffspell
			local name = UnitName("player")
			local spec = raid.classes.SHAMAN[name] and raid.classes.SHAMAN[name].spec
			if spec == 1 or spec == 2 then
			  buffspell = 324 -- Lightning Shield
			elseif spec == 3 then
			  buffspell = 52127 -- Water Shield
			end
			addon:ButtonClick(self, button, down, "shamanshield", buffspell)
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[52127] .. "/" .. BS[324], report.shamanshieldlist) -- Water Shield/Lightning Shield
		end,
		partybuff = nil,
		singletarget = true,
	},

	drumskings = {
		order = 345,
		list = "drumskingslist",
		check = "checkdrumskings",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		chat = BS[69378], -- Blessing of Forgotten Kings
		iconfix = function(self)  -- to handle when server is slow to get the icon
			if addon.BF.drumskings.icon == "Interface\\Icons\\INV_Misc_QuestionMark" then
				addon.BF.drumskings.icon = ITT[49633] -- Drums of Forgotten Kings
				if addon.BF.drumskings.icon == "Interface\\Icons\\INV_Misc_QuestionMark" then
					return true
				end
			end
			return false
		end,
		itemcheck = {
			item = "49633", -- Drums of Forgotten Kings
			min = 0,
			frequency = 60 * 5,
			frequencymissing = 60 * 5,
		},
		pre = function(self, raid, report)
			if not addon:UseDrumsKings(raid) or raid.isbattle then
				return
			end
		end,
		main = function(self, name, class, unit, raid, report)
			if not addon:UseDrumsKings(raid) then
				return
			end
			report.checking.drumskings = true
			if not unit.hasbuff[BS[69378]] and not unithasbuff(unit, statbuff) then -- forgotten kings
				table.insert(report.drumskingslist, name)
			end
		end,
		post = nil,
		icon = ITT[49633], -- Drums of Forgotten Kings
		update = function(self)
			addon:DefaultButtonUpdate(self, report.drumskingslist, profile.checkdrumskings, report.checking.drumskings or false, addon.BF.drumskings:buffers())
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "drumskings", nil, nil, ITN[49633]) -- Drums of Forgotten Kings
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[69378], report.drumskingslist, nil, addon.BF.drumskings:buffers()) -- Blessing of Forgotten Kings, Blessing of Kings
		end,
		singlebuff = false,
		partybuff = false,
		raidbuff = true,
		raidwidebuff = true,
		whispertobuff = function(reportl, prefix)
			local thebuffers = addon.BF.drumskings:buffers()
			if thebuffers then
			   generic_whispertobuff(reportl, prefix, nil, thebuffers, BS[69378])
			end
		end,
		buffers = function()
			local thebuffers = {}
			for _,rc in pairs(raid.classes) do
				for name,_ in pairs(rc) do
					local items = addon:ItemQuery("drumskings", name) or 0
					if items > 0 then
						table.insert(thebuffers, name .. "(" .. items .. ")")
					end
				end
			end
			return thebuffers
		end,
		consumable = true,
	},

	checkpet = {
		order = 330,
		list = "petlist",
		check = "checkpet",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = true,
		selfonlybuff = true,
		timer = false,
		class = { WARLOCK = true, HUNTER = true, DEATHKNIGHT = true, MAGE = true, },
		chat = BS[883]:gsub("%s*%d+$",""), -- Call Pet
		main = function(self, name, class, unit, raid, report)
			local needspet = false
			local haspet = false
			if class == "HUNTER" then
			needspet = true
			elseif class == "WARLOCK" then
				needspet = not unit.hasbuff[BS[108503]] -- Grimoire of Sacrifice
			elseif class == "DEATHKNIGHT" then
				if raid.classes.DEATHKNIGHT[name].spec == 3 then -- unholy
					needspet = true
				else
					needspet = false
				end
			elseif class == "MAGE" then
				if raid.classes.MAGE[name].spec == 3 then -- frost
					needspet = true
				else
					needspet = false
				end			
			else
				needspet = false
			end
			 
			if needspet and UnitIsVisible(unit.unitid) then
				if UnitIsUnit(unit.unitid, "player") then 
					haspet = SecureCmdOptionParse("[target=pet,dead] false; [mounted] true ; [nopet] false; true")
					haspet = (haspet == "true")
				else -- non-player
					if UnitExists(unit.unitid.."pet") then -- pet visible
						haspet = true
					elseif GetUnitSpeed(unit.unitid) > 10 or  -- mounted and moving, so cannot check (pets dont exist when mounted)
						UnitInVehicle(unit.unitid) then -- in vehicle (actually multi-passenger mnt), same thing
						haspet = true	
					elseif not IsOutdoors() then -- cannot be mounted in my zone, pet is missing
						haspet = false 
					else -- outside not moving, check for a mounted buff
						haspet = addon:UnitIsMounted(unit.unitid)
					end
				end
				report.checking.pet = true
				if not haspet then 
					table.insert(report.petlist, name)
				end
			end
			-- print(name.." needs:"..(needspet == true and "true" or "false").." has:"..(haspet == true and "true" or "false"))
		end,
		post = nil,
		icon = BSI[883], -- Call Pet
		update = function(self)
			addon:DefaultButtonUpdate(self, report.petlist, profile.checkpet, report.checking.pet or false, report.petlist)
		end,
		click = function(self, button, down)
			local class = select(2, UnitClass("player"))
			local summonspell = nil
			if class == "HUNTER" then
			  --  SecureCmdOptionParse("[target=pet,dead] Revive Pet; [nopet] Call Pet; Mend Pet")
				summonspell = SecureCmdOptionParse("[target=pet,dead] 982; [nopet] 883; 48990")
				summonspell = tonumber(summonspell)
				summonspell = BS[summonspell] 
			elseif class == "WARLOCK" then
				local spec = raid.classes.WARLOCK[UnitName("player")].spec
				if spec == 2 then -- Demo
					summonspell = BS[30146] -- Summon Felguard
				elseif spec == 3 then -- Destro
					summonspell = BS[688] -- Summon Imp
				elseif spec == 1 then -- Affliction
					summonspell = BS[691] -- Summon Felhunter
	      			else -- shrug?
					summonspell = BS[712] -- Summon Succubus	      
				end	        
			elseif class == "DEATHKNIGHT" then
				summonspell = BS[46584] -- Raise Dead
			elseif class == "MAGE" then
				summonspell = BS[31687] -- summon water elemental
			end
			addon:ButtonClick(self, button, down, "checkpet", summonspell) 
		end,
		tip = function(self)
			addon:Tooltip(self, L["Missing "] .. BS[883]:gsub("%s*%d+$",""), report.petlist) -- Call Pet
		end,
		partybuff = nil,
	},

	abouttorunout = {
		order = 100,
		list = "none",
		check = "checkabouttorunout",
		default = false,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = nil,
		pre = function(self, raid, report)
			if profile.abouttorunout > 0 and profile.checkabouttorunout then
				report.checking.abouttorunout = true
			end
		end,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\Ability_Mage_Timewarp",
		update = function(self)
			addon:DefaultButtonUpdate(self, {}, profile.checkabouttorunout, report.checking.abouttorunout or false)
			if self.count:GetText() ~= "X" then
				self.count:SetText("")
			end
		end,
		click = function(self, button, down)
			addon:ButtonClick(self, button, down, "abouttorunout")
		end,
		tip = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["Min remaining buff duration"],1,1,1)
			GameTooltip:AddLine((L["%s minutes"]):format(profile.abouttorunout),nil,nil,nil)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["Minimum remaining buff duration in minutes. Buffs with less than this will be considered as missing.  This option only takes affect when the corresponding 'buff' button is enabled on the dashboard."],nil,nil,nil, 1)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["To set this option go to the addon configuration.  This button is automatically enabled when the Boss button is pressed and automatically disabled when the Trash button is pressed.  To permanently disable, choose 0 seconds as the min remaining buff duration."],nil,nil,nil,1)
			GameTooltip:Show()
		end,
		partybuff = nil,
		other = true,
	},

	tanklist = {
		order = 20,
		list = "none",
		check = "checktanklist",
		default = true,
		defaultbuff = false,
		defaultwarning = true,
		defaultdash = false,
		defaultdashcombat = false,
		defaultboss = false,
		defaulttrash = true,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = nil,
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\Ability_Defend",
		update = function(self)
			self.count:SetText("")
			if #raid.TankList > 0 then
				self:SetAlpha("1")
			else
				self:SetAlpha("0.15")
			end
		end,
		click = nil,
		tip = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["RBS Tank List"],1,1,1)
			for _,v in ipairs(raid.TankList) do
				local class = "WARRIOR"
				local unit = addon:GetUnitFromName(v)
				if unit then
					class = unit.class
				end
				GameTooltip:AddLine(v,RAID_CLASS_COLORS[class].r,RAID_CLASS_COLORS[class].g,RAID_CLASS_COLORS[class].b,nil)
			end
			GameTooltip:Show()
		end,
		partybuff = nil,
		other = true,
	},
	help20090704 = {
		order = 10,
		list = "none",
		check = "checkhelp20090704",
		default = true,
		defaultbuff = true,
		defaultwarning = false,
		defaultdash = true,
		defaultdashcombat = false,
		defaultboss = true,
		defaulttrash = false,
		checkzonedout = false,
		selfbuff = false,
		timer = false,
		chat = nil,
		pre = nil,
		main = nil,
		post = nil,
		icon = "Interface\\Icons\\Mail_GMIcon",
		update = function(self)
			self.count:SetText("")
		end,
		click = nil,
		tip = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["RBS Dashboard Help"],1,1,1)
			GameTooltip:AddLine(L["Click buffs to disable and enable."],nil,nil,nil)
			GameTooltip:AddLine(L["Shift-Click buffs to report on only that buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Ctrl-Click buffs to whisper those who need to buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Alt-Click on a self buff will renew that buff."],nil,nil,nil)
			GameTooltip:AddLine(L["Alt-Click on a party buff will cast on someone missing that buff."],nil,nil,nil)
			GameTooltip:AddLine(" ",nil,nil,nil)
			GameTooltip:AddLine(L["Remove this button from this dashboard in the buff options window."],nil,nil,nil)
			GameTooltip:AddLine(" ",nil,nil,nil)
			GameTooltip:AddLine(L["The above default button actions can be reconfigured."],nil,nil,nil)
			GameTooltip:AddLine(L["Press Escape -> Interface -> AddOns -> RaidBuffStatus for more options."],nil,nil,nil)
			GameTooltip:AddLine(" ",nil,nil,nil)
			GameTooltip:AddLine(L["Ctrl-Click Boss or Trash to whisper all those who need to buff."],nil,nil,nil)
			GameTooltip:Show()
		end,
		partybuff = nil,
		other = true,
	},
}

addon.BF = BF
