--local L = AceLibrary("AceLocale-2.2"):new("Quartz_Eclipse")
--
--
--[[

--
--]]

local Quartz = Quartz
if Quartz:HasModule('Eclipse') then
	return
end

local _, curClass = UnitClass("player")

if (curClass ~= "DRUID") then return end


local QuartzCustomTimer = Quartz:NewModule('Eclipse', 'AceHook-2.1')
local self = QuartzCustomTimer

local m = Quartz:GetModule('Mirror')
local ex = m.ExternalTimers
local new, del = Quartz.new, Quartz.del

local db = Quartz:AcquireDBNamespace("Eclipse")

local procs_List

procs_List = {
		[48517] = { -- Wrath Eclipse
			--Wrath
			name = GetSpellInfo(48461),
			-- Wrath + Eclipse
			displayname = GetSpellInfo(48461) .. " ".. GetSpellInfo(48517),
			color = {1, 0.5, 0}, -- orange-ish
			length = 15,
			cooldown = 30,
		},
		[48518] = { -- Starfire Eclipse
			--Starfire
			name = GetSpellInfo(48465),
			-- Starfire + Eclipse		
			displayname = GetSpellInfo(48465) .. " ".. GetSpellInfo(48518),
			color = {0, 0.5, 1}, -- blue-ish
			length = 15,
			cooldown = 30,
		},
		[64823] = { -- Elune's Wrath (Balance T8 4pc bonus proc)
			name = GetSpellInfo(64823),
			color = {0, 0, 1}, -- blue
			length = 10,
		},
		
		[32182] = { -- Heroism
			name = GetSpellInfo(32182),
			length = 40,
			color = {1, 0.65, 0}, -- orange
		},
		[2825] = { -- Bloodlust (untested)
			name = GetSpellInfo(2825),
			length = 40,
			color = {1, 0.65, 0}, -- orange
		},
	
}



function QuartzCustomTimer:OnInitialize()
	Quartz:RegisterDefaults("Eclipse", "profile", {
		active = true,
		--Wrath Eclipse
		[48517] = {
			enabled = true,
			color = procs_List[48517].color
		},
		--Starfire Eclipse
		[48518] = {
			enabled = true,
			color = procs_List[48518].color
		},
		--Elune's Wrath
		[64823] = {
			enabled = true,
			color = procs_List[64823].color
		},
		--Heroism
		[32182] = {
			enabled = true,
			color = procs_List[32182].color
		},
		--Bloodlust
		[2825] = {
			enabled = true,
			color = procs_List[2825].color
		},
	})
end

function QuartzCustomTimer:OnEnable()
	if db.profile["active"] then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function QuartzCustomTimer:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function QuartzCustomTimer:Enable(doenable)
	if doenable then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	db.profile["active"] = doenable
end


do
	local function set(field, value)
		if value ~= nil then
			db.profile[field].enabled = value
		else
			db.profile[field].enabled = false
		end
		--Quartz.ApplySettings()
	end
	local function get(field)
		if (db.profile[field] ~= nil) and (db.profile[field].enabled ~= nil) then
			return db.profile[field].enabled
		else
			return true
		end
	end
	local function setcolor(field, ...)
		db.profile[field].color = {...}
		--Quartz.ApplySettings()
	end
	local function getcolor(field)
		if (db.profile[field] ~= nil) and (db.profile[field].color ~= nil) then
			return unpack(db.profile[field].color)
		elseif procs_List[field] then
			return unpack(procs_List[field].color)
		else
			error(field.." is nil")
		end
	end
	

	Quartz.options.args.Eclipse = {
		type = 'group',
		name = "Eclipse",
		desc = "Eclipse",
		args = {
			--Starfire Eclipse
			StarFireEclipseToggle = {
				type = 'toggle',
				name = "Starfire Eclipse",
				desc = 'Enable/Disable',
				get = get,
				set = set,
				order = 1,
				passValue = 48518,
			},
			StarFireEclipseColor = {
				type = 'color',
				name = "Starfire Eclipse Color",
				desc = 'Change Color',
				get = getcolor,
				set = setcolor,
				order = 2,
				passValue = 48518,
			},
			
			--Wrath Eclipse
			WrathEclipseToggle = {
				type = 'toggle',
				name = "Wrath Eclipse",
				desc = 'Enable/Disable',
				get = get,
				set = set,
				order = 3,
				passValue = 48517,
			},
			WrathEclipseColor = {
				type = 'color',
				name = "Wrath Eclipse Color",
				desc = 'Change Color',
				get = getcolor,
				set = setcolor,
				order = 4,
				passValue = 48517,
			},
			
			--T8 Proc
			EluneWrathToggle = {
				type = 'toggle',
				name = "Elune's Wrath (T8 Proc)",
				desc = 'Enable/Disable',
				get = get,
				set = set,
				order = 5,
				passValue = 64823,
			},
			EluneWrathColor = {
				type = 'color',
				name = "Elune's Wrath Color",
				desc = 'Change Color',
				get = getcolor,
				set = setcolor,
				order = 6,
				passValue = 64823,
			},
			
			--Heroism
			HeroismToggle = {
				type = 'toggle',
				name = "Heroism",
				desc = 'Enable/Disable',
				get = get,
				set = set,
				order = 7,
				passValue = 32182,
			},
			HeroismColor = {
				type = 'color',
				name = "Heroism Color",
				desc = 'Change Color',
				get = getcolor,
				set = setcolor,
				order = 8,
				passValue = 32182,
			},
			
			--Bloodlust
			BloodlustToggle = {
				type = 'toggle',
				name = "Bloodlust",
				desc = 'Enable/Disable',
				get = get,
				set = set,
				order = 9,
				passValue = 2825,
			},
			BloodlustColor = {
				type = 'color',
				name = "Bloodlust Color",
				desc = 'Change Color',
				get = getcolor,
				set = setcolor,
				order = 10,
				passValue = 2825,
			},
			
		}
	}
end




function QuartzCustomTimer:createCustomTimer(sName, sLength, sID, sColor, isCooldown)
	if (db.profile[sID] ~= nil) and (db.profile[sID].enabled ~= nil) then
		if (db.profile[sID].enabled == true) then
			local sIcon = ''
			if (sID > 0) and (isCooldown == false) then
				_,_,sIcon = GetSpellInfo(sID)
			end
			local spellColor = sColor
			if (db.profile[sID].color ~= nil) and (isCooldown == false) then
				spellColor = db.profile[sID].color
			end
			
			ex[sName] = {
				startTime = GetTime(),
				endTime = GetTime() + sLength,
				icon = sIcon,
				color = spellColor,
			}
			m:TriggerEvent("QuartzMirror_UpdateCustom")	
		end
	else
		local sIcon = ''
		if (sID > 0) and (isCooldown == false) then
			_,_,sIcon = GetSpellInfo(sID)
		end
		local spellColor = sColor
		if (db.profile[sID] ~= nil) and (db.profile[sID].color ~= nil) and (isCooldown == false) then
			spellColor = db.profile[sID].color
		end
		
		ex[sName] = {
			startTime = GetTime(),
			endTime = GetTime() + sLength,
			icon = sIcon,
			color = spellColor,
		}
		m:TriggerEvent("QuartzMirror_UpdateCustom")		
	end
end

-- Checks each buff when Aura changes
--[[
function QuartzCustomTimer:UNIT_AURA(unit)
	if unit ~= "player" then return end

	for i=1,40 do
		local name,rank,icon,count,dtype,dur,expr,caster,isStealable=UnitAura(unit,i)
		if name and dur and expr then
			--for k,v in pairs(procs_AuraSpells) do
			for k,v in pairs(spellsWatch) do
				if (v.isAura) and (name == v.name) then
					if (expr ~= v.expires) then -- create the timer						
						--print("Spell: '"..name.."' duration: "..dur.." expires in: "..(expr - GetTime()).." secs")						
						self:createCustomTimer(name, dur, k, v.color, false)
						v.expires = expr
					end
				end
			end				
		end
	end
end
]]--

function QuartzCustomTimer:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if (destGUID == UnitGUID("player")) then --check if the player is receiving the buff
		local spellID = select(1,...)
		
		if (event == "SPELL_AURA_APPLIED") or (event == "SPELL_AURA_REFRESH") then
			if (procs_List ~= nil) and (procs_List[spellID] ~= nil) then
				local d_name = procs_List[spellID].displayname or procs_List[spellID].name
				
				self:createCustomTimer(d_name, procs_List[spellID].length, spellID, procs_List[spellID].color, false)
				
				if (procs_List[spellID].cooldown) then
					local cd_name = procs_List[spellID].name or procs_List[spellID].displayname
					--TODO: translate this
					cd_name = cd_name .. " Cooldown"
					self:createCustomTimer(cd_name, procs_List[spellID].cooldown, spellID, {1,0,0}, true)
				end
			end
			
		-- Use this to remove procs that can be consumed/dispelled/clicked off
		elseif (event == "SPELL_AURA_REMOVED") then
			if (procs_List ~= nil) and (procs_List[spellID] ~= nil) then
				local d_name = procs_List[spellID].name
				if ex[d_name] ~= nil then
					ex[d_name] = del(ex[d_name])
					m:TriggerEvent("QuartzMirror_UpdateCustom")
				end
			end
		end
	end
	
end
