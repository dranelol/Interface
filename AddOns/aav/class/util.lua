AAV_Util = {}
AAV_Util.__index = AAV_Util

----
-- skills will be shown additionally on the player's icon frame.
-- credits: gladius
AAV_IMPORTANTSKILLS = {	
	[64058]		= 3, 	-- Psychic Horror
	[137143]	= 3,	-- Blood Horror
	[6789]		= 3,	-- Mortal Coil
	[113792]	= 3,	-- Psychic Terror (Psyfiend)
	[105421] 	= 3,	-- Blinding Light
	[145067] 	= 3, 	-- Turn evil this one affects humanoids too
	[33786] 	= 3, 	-- Cyclone
	[2637] 		= 3,	-- Hibernate
	[3355]		= 3,	-- Freezing Trap
	[6770]		= 3, 	-- Sap
	[2094]		= 3, 	-- Blind
	[118699]	= 3, 	-- Fear
	[6358] 		= 3, 	-- Seduction
	[5484] 		= 3, 	-- Howl of Terror
	[5246] 		= 3, 	-- Intimidating Shout
	[8122] 		= 3,	-- Psychic Scream
	[118] 		= 3,	-- Polymorph
	[28272] 	= 3,	-- Polymorph pig
	[28271] 	= 3,	-- Polymorph turtle
	[61305] 	= 3,	-- Polymorph black cat
	[61025] 	= 3,	-- Polymorph serpent
	[51514]		= 3,	-- Hex
	[18647]		= 3,	-- Banish
	[87204] 	= 3, 	-- Sin and Punishment
	[605]		= 3, 	-- Dominate Mind
	
		
	-- Roots
	[102359]	= 2,	-- Mass Entanglement
	[111340]	= 2,	-- Ice Ward
	[102051]	= 2,	-- Frost Jaw
	[339] 		= 2, 	-- Entangling Roots
	[19975]		= 2,	-- Engangling Roots ( Nature's Grasp )
	[113770]	= 2,	-- Entangling Roots ( Force of Nature )
	[64695]		= 2,	-- Earthgrab ( Earthgrab totem )
	[122]		= 2,	-- Frost Nova
	[33395]	 	= 2,    -- Freeze ( Water Elemental nova)
	[16979] 	= 2, 	-- Feral Charge
	[64803] 	= 2, 	-- Entrapment ( Snake trap )
	[135373] 	= 2, 	-- Entrapment ( Frost trap )
	[107566] 	= 2, 	-- Staggering Shout
	[136634] 	= 2, 	-- Narrow Escape ( hunter roots on disengage )
	[114404] 	= 2, 	-- Void Tendril's Grasp
	[115197] 	= 2, 	-- Partial Paralysis ( Rogue shiv para )
	[63685] 	= 2, 	-- Frost Shock (Frozen Power talent)
	[96294] 	= 2, 	-- Chains of Ice
		
			

	-- Stuns and incapacitates
	[103131] 	= 3,	-- Axe Toss (Felguard)
	[22703] 	= 3,	-- Infernal Awakening
	[118345] 	= 3,	-- Pulverize (Primal Earth Elemental)
	[54934] 	= 3, 	-- TODO: Glyph of Blinding Light
	[122242] 	= 3, 	-- Clash
	[119392] 	= 3, 	-- Charging Ox Wave
	[7922] 		= 3,	-- Charge Stun
	[118895] 	= 3, 	-- Dragon Roar 	
	[77505]		= 3, 	-- Earthquake
	[20549] 	= 3, 	-- War Stomp	
	[19577] 	= 3,	-- Intimidation (stun)			
	[126246] 	= 3,	-- Lullaby (Crane Pet)
	[126423] 	= 3,	-- Petrifying Gaze (Basilisk Pet)
	[126355] 	= 3,	-- Paralyzing Quill(Porcupine Pet)
	[56626] 	= 3,	-- Sting (Wasp Pet)
	[50519] 	= 3,	-- Sonic Blast (Bat Pet)
	[96201] 	= 3,	-- Web Wrap (Spider-Pet Stun)
	[118271] 	= 3, 	-- Combustion Impact
	[102795] 	= 3, 	-- Bear Hug
	[113801] 	= 3, 	-- Bash ( dunno )
	[115001] 	= 3, 	-- Remorseless Winter
	[91797] 	= 3, 	-- Monstrous Blow
	[91800] 	= 3, 	-- Gnaw
	[118905]	= 3,	-- Capacitator Stun
	[88625]		= 3,	-- Holy Word: Chastise
	[113953] 	= 3,	-- Paralysis stun -- to verify
	[117526] 	= 3,	-- Binding Shot
	[30283]	 	= 3,	-- Shadowfury
	[120086] 	= 3, 	-- Fists of Fury
	[108194] 	= 3,	-- Asphixiate
	[115078] 	= 3,  	-- Paralysis
	[119381] 	= 3,	-- Leg Sweep
	[132168] 	= 3, 	-- Shockwave
	[132169] 	= 3,	-- Storm Bolt
	[99]    	= 3, 	-- Disorienting Roar
	[5211] 		= 3, 	-- Mighty Bash
	[1833] 		= 3,	-- Cheap Shot
	[408] 		= 3, 	-- Kidney Shot
	[1776]		= 3, 	-- Gouge
	[44572]		= 3, 	-- Deep Freeze
	[19386]		= 3, 	-- Wyvern Sting
	[19503] 	= 3, 	-- Scatter Shot
	[9005]		= 3, 	-- Pounce
	[22570]		= 3, 	-- Maim
	[853]		= 3, 	-- Hammer of Justice
	[20066] 	= 3, 	-- Repentance
	[90337]  	= 3, 	-- Bad Manner (monkey blind)
	[105593]	= 3, 	-- Fist of Justice
	[82691]  	= 3, 	-- Ring of Frost
	[31661] 	= 3, 	-- Dragon's Breath
	[1513] 		= 3, 	-- Scare Beast
		
		-- Silences
	[55021] 	= 1,	-- Improved Counterspell
	[15487] 	= 1, 	-- Silence
	[34490] 	= 1, 	-- Silencing Shot	
	[47476]		= 1,	-- Strangulate
	[96231]   	= 1,  	-- Rebuke                
	[80964]   	= 1,  	-- Skull Bash
	[1330]     	= 1,  	-- Garrote
	[78675]		= 1, 	-- Solar Beam
	[113286]	= 1,	-- Solar Beam ( Symbiosis )
	[137460]	= 1,	-- Silence (Ring of Peace)
	[116709] 	= 1, 	-- Spear Hand Strike
				
	-- Disarms
	[676] 	   	= 1, 	-- Disarm
	[51722] 	= 1,	-- Dismantle
	[117368]	= 1,	-- Grapple Weapon
						
	-- Buffs
	[1022] 		= 1,	-- Blessing of Protection
	[1044] 		= 1, 	-- Blessing of Freedom
	[33206] 	= 1, 	-- Pain Suppression
	[29166] 	= 1,	-- Innervate
	[54428]		= 1,	-- Divine Plea
	[31821]		= 1,	-- Aura mastery
	[104773]	= 1,	-- Unending Resolve
	[118009]	= 1, 	-- Desecrated Ground (DK lvl90 anti-CC)
	[12292] 	= 1, 	-- Death Wish
    [49016] 	= 1, 	-- Unholy Frenzy
	
		
	-- Turtling abilities
	[871]		= 1,	-- Shield Wall
	[48707]		= 1,	-- Anti-Magic Shell
	[31224]		= 1,	-- Cloak of Shadows
	[19263]		= 2,	-- Deterrence
	--[88611]   = 1, -- Smoke Bomb   Doesn't work because it has "0" as duration
	[74001]		= 1, 	-- Combat Readiness
	[49039]		= 1, 	-- Lichborn
	[47585] 	= 1, 	-- Dispersion
	[47788] 	= 1, 	-- Guardian Spirit
	[116849]	= 1, 	-- Life Cocoon
	[53480] 	= 1, 	-- Roar of Sacrifice
		
	-- Immunities
	[110696]	= 3,	-- Symbiosis Ice Block
	[34692]		= 3, 	-- The Beast Within
	[45438] 	= 3, 	-- Ice Block
	[642] 		= 3,	-- Divine Shield
	[110913] 	= 3,	-- Dark Bargain
	[125174]	= 1,	-- Touch of Karma
	
	--Others
	[51755] = 1, 	-- Camouflage
}

----
--
AAV_CCSKILS = {
	
	-- WARRIOR
	--[47486] = 6,	-- Mortal Strike
	--[6544]  = 45, -- Heroic Leap
	--[63325] = 30,	-- Heroic Leap Glyph
	[52174]	= 30,	-- Heroic Leap  ( strange but this spell-id works )
	[676]	= 60,	-- Disarm
	[5246]	= 90,	-- Intimidating Shout
	[871]	= 180,	-- Shield Wall
	[18499]	= 30,	-- Berserker Rage
	[6552]	= 15,	-- Pummel
	[11578]	= 12,	-- Charge
	[1719]	= 180, 	-- Recklessness
	[23920]	= 25,	-- Spell Reflection
	[3411]	= 30,	-- Safeguard	
	[12975]	= 180,	-- Rallying Cry
	[46968]	= 20,	-- Shockwave  40 or 20
	[107574]= 180,  -- Avatar
	[118038]= 120,	-- Die by the Sword
	[97462] = 180,	-- Rallying Cry
	[46924] = 60,	-- Blade Storm
	[107570]= 30, 	-- Storm Bolt

	-- Priest
	--[48113] = 10,	-- Prayer of Mending
	--[53007] = 8, 	-- Penance
	[6346]	= 180,	-- Fear Ward
	[8122]	= 27,	-- Psychic Scream
	[34433]	= 180,	-- Shadowfiend
	[64843]	= 180,	-- Divine Hymn
	[64901]	= 360,	-- Hymn of Hope
	[32379]	= 12,	-- Shadow Word: Death
	[33206]	= 180,	-- Pain Suppression
	[10060]	= 120,	-- Power Infusion
	[89485]	= 45,	-- Inner Focus
	[47585]	= 120,	-- Dispersion
	[15487]	= 45,	-- Silence
	[64044]	= 45,	-- Psychic Horror
	[88625] = 30,	-- Chastise
	[73325] = 90,	-- Leap of Faith
	[62618] = 180,	-- Power Word: Barrier
	
	-- DRUID
	[61336]	= 180,	-- Survival Instincts
	[50334]	= 180,	-- Berserk
	[16689]	= 60,	-- Nature's Grasp
	[22812]	= 60,	-- Barkskin
	[132158]= 60,	-- Nature's Swiftness
	[5211]	= 50,	-- Mighty Bash
	[106922]= 180,	-- Might of Ursoc
	[29166]	= 180,	-- Innervate
	[1850]	= 180,	-- Dash
	[48505]	= 90,	-- Starfall
	[132469]= 30,	-- Typhoon
	[18562]	= 13,	-- Swiftmend
	[80964] = 15,	-- Skull Bash
	[77761] = 120,	-- Stampeding Roar
	[22570] = 10,	-- Maim
	[5217]	= 30,	-- Tiger's Fury
	[106731]= 180,	-- Incarnation: ...
	[740]	= 480,	-- Tranquility

	-- WARLOCK
	[5484]	= 40,	-- Howl of Terror
	[6789]	= 45,	-- Mortal Coil
	[48020]	= 25,	-- Demonic Circle: Teleport
	[30283]	= 30,	-- Shadowfury
	[89766] = 30,	-- Axe Toss
	[113858]= 120,	-- Dark Soul destro
	[113860]= 120,	-- Dark Soul affly
	[113861]= 120,	-- Dark Soul demo
	[110913]= 180, -- Dark Bargain
	[104773]= 180,	-- Unending Resolve
	[108482]= 60,  -- Unbound Will

	-- MAGE
	[1953]	= 15,	-- Blink
	[45438]	= 300,	-- Ice Block
	[2139]	= 24,	-- Counterspell
	[12598]	= 24,	-- Improved Counterspell
	[66]	= 300,	-- Invisibility
	[122]	= 25,	-- Frost Nova
	[31661]	= 20,	-- Dragon's Breath
	[11426]	= 25,	-- Ice Barrier
	[55342]	= 180,	-- Mirror Image
	[12043]	= 90,	-- Presence of Mind
	[12042]	= 90,	-- Arcane Power
	[11129]	= 45,	-- Combustion
	[44572]	= 30,	-- Deep Freeze
	[31687]	= 60,	-- Summon Water Elemental
	[11958]	= 180,	-- Cold Snap
	[12472]	= 180,	-- Icy Veins
	[113724]= 45,	-- Ring of Frost
	[84714] = 60,	-- Frozen Orb
	
	-- PALADIN
	[498] 	= 60, 	-- Divine Protection
	[20271] = 6, 	-- Judgement of Light
	[1044] 	= 25, 	-- Hand of Freedom
	[642] 	= 300, 	-- Divine Shield
	[1022]  = 300, 	-- Hand of Protection
	[6940] 	= 120, 	-- Hand of Sacrifice
	[853]   = 60, 	-- Hammer of Justice
	[31884] = 180, 	-- Avenging Wrath
	[54428] = 120, 	-- Divine Plea
	[24275] = 6, 	-- Hammer of Wrath
	[31842] = 180, 	-- Divine Favor
	[31821] = 180, 	-- Aura Mastery
	[20066] = 15, 	-- Repentance
	[96231] = 15,	-- Rebuke
	[86698] = 180,	-- Guardian of Ancient Kings  retry
	[86669] = 180,	-- Guardian of Ancient Kings  holy
	[86659] = 180,	-- Guardian of Ancient Kings  prot
	[115750]= 120,	-- Blinding Light
	
	-- HUNTER
	--[51753] = 60,	-- Camouflage
	[781]	= 20,	-- Disengage
	[3045]	= 180,	-- Rapid Fire
	[5384]	= 30,	-- Feign Death
	[19263]	= 180,	-- Deterrence
	[53271]	= 45,	-- Master's Call
	[53351]	= 10,	-- Kill Shot
	[1499]	= 30,	-- Freezing Trap
	[13809]	= 30,	-- Ice Trap
	[19386]	= 45,	-- Wyvern Sting
	[19503]	= 30,	-- Scatter Shot
	[34490]	= 25,	-- Silencing Shot
	[53209]	= 9,	-- Chimera Shot
	[19574]	= 60,	-- Bestial Wrath
	[90337]	= 120,	-- Bad Manner (Pet Blind)
	[53480] = 60,	-- Roar of Sacrifice
	
	-- DEATHKNIGHT
	[49576]	= 25,	-- Death Grip
	[47476]	= 60,	-- Strangulate
	[48707]	= 45,	-- Anti-Magic Shell
	[51052]	= 120,	-- Anti-Magic Zone
	[48792]	= 180,	-- Icebound Fortitude
	[48743]	= 120,	-- Death Pact
	[47568]	= 300,	-- Empower Rune Weapon
	[49028]	= 90,	-- Dancing Rune Weapon
	[49039]	= 120,	-- Lichborne
	[49206]	= 180,	-- Summon Gargoyle
	[77606] = 60,	-- Dark Simulacrum
	[51271] = 60,	-- Pillar of Frost
	[91797] = 60,	-- Monstrous Blow
	[91802] = 30,	-- Shambling Rush
	
	-- ROGUE
	[1784]	= 6,	-- Stealth
	[1776]	= 10,	-- Gouge
	[1766]	= 15,	-- Kick
	[51722] = 60,	-- Dismantle
	[2094]	= 120,	-- Blind
	[5277]  = 120,	-- Evasion
	[408]	= 20,	-- Kidney Shot
	[2983]  = 60,	-- Sprint
	[1856]  = 120,	-- Vanish
	[31224] = 60,	-- Cloak of Shadows
	[57934] = 30,	-- Tricks of the Trade
	[13750] = 180,	-- Adrenaline Rush
	[51690] = 120,	-- Killing Spree
	[51713] = 60,	-- Shadow Dance
	[14185] = 300,	-- Preparation
	[36554] = 20,	-- Shadow Step
	[76577] = 180,	-- Smoke Bomb
	[74001] = 120,	-- Combat Readiness
	[73981] = 60,	-- Redirect
	
	-- SHAMAN
	[57994] = 12,	-- Wind Shear
	[8177] 	= 25,	-- Grounding Totem
	[8056] 	= 6,	-- Frost Shock
	[51514] = 35,	-- Hex
	[2484] 	= 30,	-- Earthbind Totem
	[51490] = 22.5,	-- Thunderstorm
	[16166] = 90,	-- Elemental Mastery
	[51533] = 120,	-- Feral Spirit
	[30823] = 60,	-- Shamanistic Rage
	[16188] = 90,	-- Nature's Swiftness
	[16190] = 180,	-- Mana Tide Totem
	[79206] = 120,	-- Spiritwalker's Grace
	[5394] 	= 30,	-- Healing Stream Totem
	[108280]= 180,	-- Healing Tide Totem
	[108285]= 180,	-- Call of the Elements
	[98008] = 180,	-- Spirit Link Totem
	[8143]	= 60,	-- Tremor Totem
	[114049]= 180,	-- Ascendance
	[108269]= 45, 	-- Capacitor Totem
	
	--MONK
	--[115078] = 15,	-- Paralysis
	[113656] = 25,		-- Fists of Fury
	[119392] = 30,		-- Charging Ox Wave
	[119381] = 45,		-- Leg Sweep
	[116705] = 15,		-- Spear Hand Strike
	[116844] = 45,		-- Ring of Peace
	[117368] = 60,		-- Grapple Weapon
	[116849] = 120,		-- Life Cocoon
	[137562] = 120,		-- Nimble Brew
	[123904] = 180,		-- Invoke Xuen, the White Tiger
	[116680] = 45,		-- Thunder Focus Tea ( Aura Mastery )
	[115310] = 180,		-- Revival
	[116841] = 30,		-- Tiger's Lust
	[115203] = 180,		-- Fortifying Brew
	[122783] = 90,		-- Diffuse
	[122278] = 90,		-- Dampen Harm
	[115176] = 180,		-- Zen Meditation
	[101643] = 45,		-- Trascendence
	[122470] = 90,		-- Touch of Karma
	
			
	-- GENERAL
	[59752]	= 120,	-- Every Man for Himself
	[42292]	= 120,	-- PvP Trinket
}
----
-- skills that are only visible as buffs, but should create a skill used.
AAV_BUFFSTOSKILLS = {
	[32645] = true,	-- Envenom
	--[53480] = true,	-- Roar of Sacrifice
	[5384]  = true, -- Feign Death
}


function AAV_Util:split(str, pat)
	if not str then return nil end
	local t = {}
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = string.find(str, fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = string.find(str, fpat, last_end)
	end
	if last_end <= #str then
		cap = string.sub(str, last_end)
		table.insert(t, cap)
	end
	return t
end

----
-- returns true if the omitted class is a mana user.
-- @param class string
-- @return true or false
function AAV_Util:determineManaUser(class)
	if (class == "PALADIN" or class == "PRIEST" or class == "DRUID" or class == "WARLOCK" or class == "MAGE" or class == "MONK" or class == "SHAMAN") then
		return true
	end
	return false
end

----
-- returns the color of the targetid
-- @param data player data
-- @param urgent use class colors
function AAV_Util:getTargetColor(data, urgent)
	
	if (not atroxArenaViewerData.defaults.profile.uniquecolor or urgent) then
	
		if (data.class == "DEATHKNIGHT") then
			return 0.77, 0.12, 0.23
		elseif (data.class == "DRUID") then
			return 1.00, 0.49, 0.04
		elseif (data.class == "HUNTER") then
			return 0.67, 0.83, 0.45
		elseif (data.class == "MAGE") then
			return 0.41, 0.80, 0.94
		elseif (data.class == "PALADIN") then
			return 0.96, 0.55, 0.73
		elseif (data.class == "PRIEST") then
			return 1.00, 1.00, 1.00
		elseif (data.class == "ROGUE") then
			return 1.00, 0.96, 0.41
		elseif (data.class == "SHAMAN") then
			return 0.14, 0.35, 1.00
		elseif (data.class == "WARLOCK") then
			return 0.58, 0.51, 0.79
		elseif (data.class == "WARRIOR") then
			return 0.78, 0.61, 0.43
		elseif (data.class == "MONK") then
			return 0.2, 1.00, 0.00
		end
		
	else
		local id = data.ID
		if (id == 0) then
			return 0, 0.2941176470588235, 1
		elseif (id == 1) then
			return 0.9098039215686275, 0.396078431372549, 0.7176470588235294
		elseif (id == 2) then
			return 0.1333333333333333, 0.9137254901960784, 0.7490196078431373
		elseif (id == 3) then
			return 0.6156862745098039, 0.6196078431372549, 0.6235294117647059
		elseif (id == 4) then
			return 0.3686274509803922, 0, 0.5411764705882353
		elseif (id == 5) then
			return 0.5294117647058824, 0.7725490196078431, 0.9529411764705882
		elseif (id == 6) then
			return 1, 0.992156862745098, 0.003921568627451
		elseif (id == 7) then
			return 0.0745098039215686, 0.3647058823529412, 0.2666666666666667
		elseif (id == 8) then
			return 1, 0.5764705882352941, 0.0705882352941176
		elseif (id == 9) then
			return 0.3450980392156863, 0.196078431372549, 0.0235294117647059
		elseif (id == 10) then
			return 0.3450980392156863, 0.196078431372549, 0.0235294117647059
		end
	end
	return 1, 1, 1
end

function AAV_Util:getImportskills()
	return importantskills
end