--[[
Interface: 5.0.1
Title: LibBalancePowerTracker
Version: 1.1.3
Author: Kurohoshi (EU-Minahonda)

--INFO
	LibBalancePowerTracker is a library designed to provide the foresee energy feature to Balance Druids.
	CPU is only used when required, so the CPU usage is very low (busy waitting forbidden, always on demand).
	
	FORESEE ENERGY:
	Foresee Energy is a feature that analizes the spells you are casting but are yet to be finished and and computes 
	the energy of them. This allows the library to distinguish between two kinds of energy and Eclipse direction: One real, 
	the one you have at the moment and other virtual, the one you'll have when you finish your cast.
	All the features with the 'virtual' tag (virtual Energy, virtual Eclipse ...) rely on Foresee Energy.
	
--API
	There are 5 variables related to Eclipse energy used in this addon:
		energy: The energy you have at the moment. Int = [-100,100]
		direction: The direction of the arrow. String = {"none","sun","moon"}
		virtual_energy: The energy you will have when the spell you're casting and all the flying spells land. Int = [-100,100]
		virtual_direction: The direction of the arrow when the spell you're casting and all the flying spells land. String = {"none","sun","moon"}
		virtual_eclipse: -100 if lunar, 100 if solar, false otherwise.

	FUNCTIONS:

	id = LibBalancePowerTracker:RegisterCallback(function(energy, direction, virtual_energy, virtual_direction, virtual_eclipse))
	These callbacks will be fired when there is a change in one of the Eclipse energy variables, usually twice per WR/SF/SS.
	NOTE: When registering a callback, that callback will be fired once.
		
	failed = LibBalancePowerTracker:UnregisterCallback(id)
	Tries to unregister the callback with identifier id (id is returned only when you register the callback).
	
	energy, direction, virtual_energy, virtual_direction, virtual_eclipse = LibBalancePowerTracker:GetEclipseEnergyInfo()
	Gets the current state of the variables.
	
	version,subversion,revision = LibBalancePowerTracker:GetVersion()
	Gets the current working version of the library.	

--Must keep an eye on this:
	AoE silence ----------------------------------------------- Working in 4.1
	Critters and wild pets don't give energy ------------------ True in 5.0.3
	While changing from 2nd spec to 1st, UnitPower is wrong --- True in 5.0.4

--CHANGELOG
v 1.1.3	Cast failed detection improved
		Included LICENSE.txt in Lib
		CPU usage by critter detection recalculated
		Fixed bug in loading check

v 1.1.2	Astral empowerment removed
		Euphoria now has 100% chance
		Astral Communion updated	
		Tried to not count energy if the target is a wild pet or a critter, let's see how it goes
		Fixed 0 bug when spellcast delayed by hit
		Fixed AC ticks left when delayed by hit
		Fixed bug where BPT would show no direction after gaining a eclipse immediately after zoning
		Recast AC fixed
		4pT12 tested

v 1.1.1 SotF energy prediction while in neutral state fixed
		Fixed interaction between CA and PvP bonus
		Added WoW v check on load
		Added 'select' to locals
		Celestial Aligment & Astral Empowerment check when changing talents
		Added Astral Empowerment mechanics
		Fixed double call on log
		Added debug function
		Fixed AC not erasing as soon as reching 100 energy
		Fixed failed prediction when reaching eclipse and then spending a talent point
		Talent reset/spent correctly handled, even with buffs
		Cancel buffs (AE & CA) support

v 1.1.0 Many changes to update LBPT for WoW 5.0, including new spell mechanics

v 1.0.13 Renamed SpellQueueADT to LBPT_SpellQueueADT

v 1.0.12 Changes in UnitByName(Name)
		 Changed _Sent to account for spell number
		 Fixed not reseting eclipse direction when entering arena (this was fixed in 4.3 by Blizz)
		 PVP 4p bug workaround isn't needed anymore
		 Increased SS and WR autodelete timers to 5s (so it works at max distance on Ragnaros figth)
		 Updated SpellQueueADT-1.1
		 Memory usage no longer increases in combat (Memory leak fixed)
		 Added support to UNIT_DESTROYED event, but commented till it's necessary
		 .toc updated

v 1.0.11 Updated code to handle Euphoria & 4T12 bonus hotfix

v 1.0.10 Simplified some code
		 Sync even when not Balance
		 Checking for tier12 even when not Balance

v 1.0.9 Increased WR and SS autodelete timers by 1s, SF's by .5s
		Fixed advanced settings bugs
		Eclipse stat rewritten (less CPU used)

v 1.0.8 SpellQueueADT updated

v 1.0.7 Tier12 fully supported
		Handling specialWR now here
		Updated SpellQueueADT
		Some code improvements
		Changed reachEnd to virtualEclipse

v 1.0.6	WoW 4.2 fix
		SF autodelete timer increased by .5s
		Updated SpellQueueADT-1.1
		Interrupted spell bug fixed
		Fixed DoTs' energy for 4.2
		Early support for 4t12 bonus
		Included tier set
		Removed some unnecessary functions (RmoveFirsto0...)
		Minor bug in Advanced settings fixed.
		Minor bug causing to fire two callbacks when crossing 0 fixed.

v 1.0.5 Moved UpdateEuphoria into ReCheck
		4.1 fix
		Now shouldn´t load when not a druid succeesfully
		Future log compatibility functions
		The mark shouldn´t 'dance' at 0,100 and -100 energy anymore.
		Extra functions to avoid letting a spell remain in the queue when it must be erased.
		
v 1.0.4 Changed Euphoria chance based on Hamlet's findings on www.elitistjerks.com 
		Added target of target to the unit check.
		Fixed casting glyph of SS counting as casting SS
		Use spellId instead of names
		
v 1.0.3 Changed to use propperly SpellQueueADT 1.1.2
		Now erases flying spells when teleporting.
		FEATURE: Eclipse chance calculation.
		FEATURE: Energy statistically calculation.

v 1.0.2 Fixed sometimes not fetching the direction properly. 
		Fixed PvP bonus

v 1.0.1 Reduced the number of callbacks fired.

v 1.0.0 Release
--]]

local version = {1,1,3};
if (LibBalancePowerTracker and LibBalancePowerTracker.CompareVersion and LibBalancePowerTracker:CompareVersion(version)) then return; end;
if select(4, GetBuildInfo())<50001 then return; end;

--Initialize Global Lib
LibBalancePowerTracker = {};
function LibBalancePowerTracker:CompareVersion(versionTable) 
	-- if mine is equal or better than versionTable, return true
	for i,v in ipairs(versionTable) do
		if version[i] ~= v then
			return version[i] > v;
		end;
	end;
	return true;
end;

--Locals
----GLOBALS TO LOCALS-------------------------------------------------------------------
local GetEclipseDirection,UnitPower,SPELL_FAILED_NOT_READY,SPELL_FAILED_SPELL_IN_PROGRESS = GetEclipseDirection,UnitPower,SPELL_FAILED_NOT_READY,SPELL_FAILED_SPELL_IN_PROGRESS;
local UnitGUID,UnitBuff,GetTalentInfo,GetSpellInfo = UnitGUID,UnitBuff,GetTalentInfo,GetSpellInfo
local GetInventoryItemID,abs,pairs,ipairs,tonumber,GetSpellCooldown,GetTime,select = GetInventoryItemID,abs,pairs,ipairs,tonumber,GetSpellCooldown,GetTime,select
local LibBalancePowerTracker = LibBalancePowerTracker;
local SPELL_POWER_ECLIPSE,UnitCastingInfo,UnitChannelInfo = SPELL_POWER_ECLIPSE,UnitCastingInfo,UnitChannelInfo;
----DATA--------------------------------------------------------------------------------
------STATIC----------------------------------------------------------------------------
local data ={
	WR  = {name = GetSpellInfo(5176)  , energy = 15, energize_events = 1, spellId=5176  }, -- name & energy Wrath
	SF  = {name = GetSpellInfo(2912)  , energy = 20, energize_events = 1, spellId=2912  }, -- name & energy Starfire
	SS  = {name = GetSpellInfo(78674) , energy = 20, energize_events = 1, spellId=78674 }, -- name & energy StarSurge
	AC	= {name = GetSpellInfo(127663), energy = 25, energize_events = 4, ms_btwn_events = 1000, spellId=127663}, -- name & energy Astral Comunion
	
	EE  			= {spellId = 89265}, -- Eclipse Energy spell
	
	--Buffs
	CA				= {name = GetSpellInfo(112071), spellId = 112071}, -- Celestial Aligment buff id
	LunarEclipse  	= {name = GetSpellInfo(48518) , spellId = 48518 }, -- Lunar eclipse buff id
	SolarEclipse  	= {name = GetSpellInfo(48517) , spellId = 48517 }, -- Solar eclipse buff id
	
	SoulOfTheForest = {talentIndex = 10, bonus = 20},
	balanceTiersItemId ={ --Pieces of bonus that change things
		[12]={
			[1]={ [71108]="n",[71497]="h"},--head
			[3]={ [71111]="n",[71500]="h"},--shoulders
			[5]={ [71110]="n",[71499]="h"},--chest
			[7]={ [71109]="n",[71498]="h"},--trousers
			[10]={[71107]="n",[71496]="h"},--gloves
			bonus4p = true,
			tested4p = true,
		},
	},
}
------VARS------------------------------------------------------------------------------
local vars = {
	isDruid = nil,
	isBalance = nil,
	
	spell_casting = 0,
	spell_num = 0,
	energize_events_remaining = 0,
	--next_energize_at = 0,
	last_energize_at = 0,
	
	celestial_lockout_end = 0,
	
	energy = 0,
	vEnergy = 0,
	eclipse = false,
	vEclipse = false,
	direction = "none",
	vDirection = "none",
	
	bug0ToBeWorkarounded = false,

	tiers = {
		[1]=false,--head
		[3]=false,--shoulders
		[5]=false,--chest
		[7]=false,--trousers
		[10]=false,--gloves
		tierPieceCount = setmetatable({}, {__index = function () return 0 end}),
	}
}
local playerGUID,lastCallback,callbacks,number_callbacks = false,0,{},0;
------ENERGY FUNCTIONS------------------------------------------------------------------
--[[If dir == none then
----index is side of bar
--else
----index is eclipse 
--I realize there are some combinations that aren't going to happen]] 
local energyFromSpell={
	[data.SF.spellId]={
		moon	= {
			[-100] = 0,
			[ 000] = 0,
			[ 100] = 0,
		},
		sun		= {
			[-100] = data.SF.energy,
			[ 000] = 2*data.SF.energy,
			[ 100] = 2*data.SF.energy,
		},
		none 	= {
			[-100] = 2*data.SF.energy,
			[ 000] = 2*data.SF.energy,
			[ 100] = 2*data.SF.energy,
		},
	},
	[data.WR.spellId]={
		moon	= {
			[-100] = -2*data.WR.energy,
			[ 000] = -2*data.WR.energy,
			[ 100] = -data.WR.energy,
		},
		sun		= {
			[-100] = 0,
			[ 000] = 0,
			[ 100] = 0,
		},
		none 	= {
			[-100] = -2*data.WR.energy,
			[ 000] = -2*data.WR.energy,
			[ 100] = -2*data.WR.energy,
		},
	},
	[data.SS.spellId]={
		moon	= {
			[-100] = -2*data.SS.energy,
			[ 000] = -2*data.SS.energy,
			[ 100] = -data.SS.energy,
		},
		sun		= {
			[-100] = data.SS.energy,
			[ 000] = 2*data.SS.energy,
			[ 100] = 2*data.SS.energy,
		},
		none 	= {
			[-100] = -2*data.SS.energy,
			[ 000] = 2*data.SS.energy,
			[ 100] = 2*data.SS.energy,
		},
	},
	[data.AC.spellId]={
		moon	= {
			[-100] = -data.AC.energy,
			[ 000] = -data.AC.energy,
			[ 100] = -data.AC.energy,
		},
		sun		= {
			[-100] = data.AC.energy,
			[ 000] = data.AC.energy,
			[ 100] = data.AC.energy,
		},
		none 	= {
			[-100] = -data.AC.energy,
			[ 000] = data.AC.energy,
			[ 100] = data.AC.energy,
		},
	},
}
local energizeEventsFromSpell={
	[data.SF.spellId]={
		moon	= 0,
		sun		= data.SF.energize_events,
		none 	= data.SF.energize_events,
	},
	[data.WR.spellId]={
		moon	= data.WR.energize_events,
		sun		= 0,
		none 	= data.WR.energize_events,
	},
	[data.SS.spellId]={
		moon	= data.SS.energize_events,
		sun		= data.SS.energize_events,
		none 	= data.SS.energize_events,
	},
	[data.AC.spellId]={
		moon	= data.AC.energize_events,
		sun		= data.AC.energize_events,
		none 	= data.AC.energize_events,
	},
}
----TIMERS-------------------------------------------------------------------------------
local timers={holder 	= CreateFrame("Frame",nil,UIParent);}
timers.broadcastTier 	= CreateFrame("Cooldown",nil,timers.holder)
timers.delayedUpdate 	= CreateFrame("Cooldown",nil,timers.holder)
----FRAME--------------------------------------------------------------------------------
local frame = CreateFrame("Frame",nil,UIParent); --(loading events & workaround)
local combatFrame = CreateFrame("Frame",nil,UIParent); --Combat events
local LBPT = {};
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--Aux functions
local spellsUsed = {
	[data.WR.name] = tonumber(data.WR.spellId),
	[data.SS.name] = tonumber(data.SS.spellId),
	[data.SF.name] = tonumber(data.SF.spellId),
	[data.AC.name] = tonumber(data.AC.spellId),
	[data.WR.spellId] = tostring(data.WR.name),
	[data.SS.spellId] = tostring(data.SS.name),
	[data.SF.spellId] = tostring(data.SF.name),
	[data.AC.spellId] = tostring(data.AC.name),
}
local function deleteSpell()
	vars.spell_casting = 0;
	vars.spell_num = 0;
	vars.energize_events_remaining = 0;
	LBPT.RecalcEnergy()
end
local function CheckEcplipseBuff() 
	vars.eclipse = (UnitBuff('player',data.SolarEclipse.name) and 100) or (UnitBuff('player',data.LunarEclipse.name) and -100)
	return vars.eclipse
end
local function checkCelestialAligmentBuff()
	local tim_end = select(7,UnitBuff('player',data.CA.name)) or 0; 
	vars.celestial_lockout_end = tim_end*1000;
	return vars.celestial_lockout_end;
end
local function isBalance()
	return GetSpellCooldown(data.SS.name)~=nil
end
local function UpdateEnergizeAt(channeled)
	if channeled then
		vars.last_energize_at = select(6,UnitChannelInfo("player"))
		--vars.next_energize_at = vars.last_energize_at - data.AC.ms_btwn_events * (vars.energize_events_remaining-1)
	else
		vars.last_energize_at = select(6,UnitCastingInfo("player"))
		--vars.next_energize_at = vars.last_energize_at
	end
end

do --Loading
	frame:SetScript("OnEvent",  function(_, event, ...) LBPT[event](...) end);
	frame:RegisterEvent("PLAYER_LOGIN");
	LBPT.postLogin = false;
	
	function LBPT.PLAYER_LOGIN()
		LBPT.postLogin = true;		
		vars.isDruid = select(2,UnitClass("player"))=="DRUID"; 
		if vars.isDruid and number_callbacks ~= 0 then 
			LBPT.load()
		end 
	end;
	
	--[[loading:
	energia ok on login
	
	con info sin desconectar (apagando red)
		load
			direction,eclipse ok on ECLIPSE_DIRECTION_CHANGE
	
	con info desconectando
		load
			con eclipse -> ok on login, dos ECLIPSE_DIRECTION_CHANGE y gana y pierde eclipse
			sin eclipse -> ok on login, dos ECLIPSE_DIRECTION_CHANGE
		
	sin info deconectando
		load
			all ok on login --sin eventos raros
	
	reloading 
		all ok on login 
	]]
	
	function LBPT.load()
		--on reload, info working ok
		--on load, no
		playerGUID=UnitGUID("player");

		frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED"); 
			
		--Check tier
		frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
		for k in pairs(vars.tiers) do if tonumber(k) then LBPT.PLAYER_EQUIPMENT_CHANGED(k,GetInventoryItemID("player", k)) end end
		
		vars.isBalance = isBalance()
		LBPT.RegisterCombatEvents(vars.isBalance)
		LBPT.Reset(vars.isBalance)
		
		if vars.isBalance and (not vars.eclipse) and vars.direction == "none" then --balance, Login & no conseguimos los valores actualizados 
			frame:RegisterEvent("ECLIPSE_DIRECTION_CHANGE"); --not fired when /reload, used to check eclipse & dir on load

			timers.delayedUpdate:SetScript("OnHide",function() frame:UnregisterEvent("ECLIPSE_DIRECTION_CHANGE"); end)
			timers.delayedUpdate:SetCooldown(GetTime(),0) 
		end
	end
	
	function LBPT.unload()
		frame:UnregisterAllEvents();
		combatFrame:UnregisterAllEvents();
	end
	
	function LBPT.ECLIPSE_DIRECTION_CHANGE()
		LBPT.Reset(true)
		timers.delayedUpdate:SetCooldown(GetTime(),0) 
	end; 

	function LBPT.RegisterCombatEvents(balanceNow)
		if balanceNow then
			for k in pairs(LBPT.combat) do
				combatFrame:RegisterEvent(k);
			end
		else 
			for k in pairs(LBPT.combat) do
				combatFrame:UnregisterEvent(k);
			end
		end
	end
	
	function LBPT.Reset(balanceNow)
		--Reset values
		vars.energy = 0
		vars.vEnergy = 0
		vars.eclipse = false
		vars.vEclipse = false
		vars.direction = "none"
		vars.vDirection = "none"
		vars.bug0ToBeWorkarounded = false;
		vars.celestial_lockout_end = 0;
		
		--Propagate values
		if balanceNow then 	
			vars.direction = GetEclipseDirection() or vars.direction --accurate when changing talents
			CheckEcplipseBuff() --accurate when changing talents 
			checkCelestialAligmentBuff()
			LBPT.RecalcEnergy(); --energy is not accurate when changing talents --Need to avoid not updating it
		else
			LBPT.FireCallbacks()
		end
	end
end

do --Talent check/change events
	local frequentFiredOnce = false;
	
	function LBPT.PLAYER_SPECIALIZATION_CHANGED()
		local balanceNow = isBalance()
		
		if vars.isBalance and balanceNow and GetEclipseDirection() then 
			--GetEclipseDirection is nil on teleport, handled by its own event, put here to avoid firing this event when portaling
			LBPT.Reset(balanceNow)
			
			if (UnitPower("player",SPELL_POWER_ECLIPSE) ~= 0)  then
				--Si al pasar de pollo a pollo tenemos energia, retrasar un evento para actualizar cuando vuelva a 0
				--Only interesting when switching specs from boomkin to boomkin, to reset the energy
				--It not very interesting having a FREQUENT event free for more time than needed, so the delayed unregister of the event
				
				frequentFiredOnce = false;
				frame:RegisterEvent("UNIT_POWER_FREQUENT");
				timers.delayedUpdate:SetScript("OnHide",function() frame:UnregisterEvent("UNIT_POWER_FREQUENT"); end)
				timers.delayedUpdate:SetCooldown(GetTime(),0) 
			end
		end
		
		if vars.isBalance ~= balanceNow then --Si cambiamos de pollo a chopo o viceversa, hemos de actualizar los eventos y resetear los valores
			vars.isBalance = balanceNow
			LBPT.RegisterCombatEvents(balanceNow)
			LBPT.Reset(balanceNow)
		end
	end

	function LBPT.UNIT_POWER_FREQUENT(unit,power) 
		if unit == "player" and power == "ECLIPSE" then
			vars.bug0ToBeWorkarounded = false;
			local e = UnitPower("player",SPELL_POWER_ECLIPSE)
			local d = GetEclipseDirection() --REMOVE when (7) is removed 
			if (vars.energy ~= e or vars.direction ~= d) then
				vars.direction = d
				LBPT.RecalcEnergy(e)
				frequentFiredOnce = true;
			end
			
			if frequentFiredOnce then 
				frame:UnregisterEvent("UNIT_POWER_FREQUENT");
			end
			frequentFiredOnce = true;
		end
	end
end

do --Combat events-------------
	LBPT.combat = {};
	
	do --Combat frame script creation
		local combatTable = LBPT.combat;
		combatFrame:SetScript("OnEvent",  function(_, event, ...) combatTable[event](...) end);
	end
	
	local function startSpell(unit,num,id,channeled)
		if unit == "player" and spellsUsed[id] then 
			if LBPT.Critter and LBPT.Critter(num) then return end -- Energy not given by critters
		
			if channeled and vars.energize_events_remaining>0 and vars.spell_casting == id then
				vars.energize_events_remaining = energizeEventsFromSpell[id][vars.direction] + 1;
			else
				vars.energize_events_remaining = energizeEventsFromSpell[id][vars.direction];
				vars.spell_casting = id;
			end
			vars.spell_num = num;
			
			vars.started_in_CA = vars.celestial_lockout_end ~= 0 --To math events left in AC by time
			UpdateEnergizeAt(channeled)
			
			if vars.bug0ToBeWorkarounded then --need to avoid 0bug 
				LBPT.RecalcEnergy(vars.energy) 
			else
				LBPT.RecalcEnergy()
			end
		end
	end
	
	function LBPT.combat.UNIT_SPELLCAST_START(unit,_,_,num,id)			startSpell(unit,num,id,false)	end
	function LBPT.combat.UNIT_SPELLCAST_CHANNEL_START(unit,_,_,num,id)	startSpell(unit,num,id,true )	end
	
	local function delaySpell(unit,num,id,channeled)
		if unit == "player" and spellsUsed[id] and vars.celestial_lockout_end ~= 0 and vars.spell_num == num and vars.spell_casting == id then
			UpdateEnergizeAt(channeled)
			if vars.bug0ToBeWorkarounded then --need to avoid 0bug 
				LBPT.RecalcEnergy(vars.energy) 
			else
				LBPT.RecalcEnergy()
			end
		end
	end
	
	function LBPT.combat.UNIT_SPELLCAST_DELAYED(unit,_,_,num,id)		delaySpell(unit,num,id,false) end
	function LBPT.combat.UNIT_SPELLCAST_CHANNEL_UPDATE(unit,_,_,num,id)	delaySpell(unit,num,id,true ) end
	
	local function finishSpell(unit,num,id)
		if unit == "player" and spellsUsed[id] and vars.spell_num == num and vars.spell_casting == id then
			deleteSpell()
		end
	end
		
	function LBPT.combat.UNIT_SPELLCAST_SUCCEEDED(unit,_,_,num,id)		finishSpell(unit,num,id) end
	function LBPT.combat.UNIT_SPELLCAST_FAILED(unit,_,_,num,id)			finishSpell(unit,num,id) end
	function LBPT.combat.UNIT_SPELLCAST_CHANNEL_STOP(unit,_,_,num,id)	finishSpell(unit,num,id) end
	function LBPT.combat.UNIT_SPELLCAST_INTERRUPTED(unit,_,_,num,id)	if not UnitCastingInfo("player") then finishSpell(unit,num,id) end end

	function LBPT.combat.PLAYER_DEAD() --Reset queue & clear energy upon death
		vars.direction = GetEclipseDirection() or "none"; 
		deleteSpell()
	end
	
	function LBPT.UNIT_POWER(unit,power) --Scheduled energy recheck by combat events (0bug & AC energy update)
		if unit == "player" and power == "ECLIPSE" then
			frame:UnregisterEvent("UNIT_POWER");
			vars.bug0ToBeWorkarounded = false;
			local e = UnitPower("player",SPELL_POWER_ECLIPSE)
			local d = GetEclipseDirection() --REMOVE when (7) is removed 
			if vars.isBalance and (vars.energy ~= e or vars.direction ~= d) then
				vars.direction = d
				LBPT.RecalcEnergy(e)
			end
		end
	end
	
	do --COMBAT LOG HANDLER -------------------------------------------------------		
		local auraLossFunctionTable = {
			[data.LunarEclipse.spellId] = 	function() if vars.eclipse then vars.eclipse = false vars.direction = GetEclipseDirection() or "none";  LBPT.RecalcEnergy() end end,
			[data.SolarEclipse.spellId] = 	function() if vars.eclipse then vars.eclipse = false vars.direction = GetEclipseDirection() or "none";  LBPT.RecalcEnergy() end end,
			[data.CA.spellId] 			= 	function() if vars.celestial_lockout_end ~=0 then vars.celestial_lockout_end = 0; LBPT.RecalcEnergy() end end,
		}
		
		local function UpdateACTicksLeft()
			--Only fired by energize
			-- if SOFT, soft is discounted, so don't worry about it
			-- only need to recalc the events left once, 
			--	It's not perfect, but the only thing that scrambles it is lag, 
			--  and if you're laggy, you probably have lag for more than 1s
			-- However, it's only fired for AC when cast during CA, something very unlikely
			
			if vars.started_in_CA then 
				vars.energize_events_remaining = math.floor((vars.last_energize_at - GetTime()*1000)/data.AC.ms_btwn_events + .5) 
				vars.started_in_CA = false;
			end 
			return vars.energize_events_remaining 
		end
		
		local unfilteredCombatLogTable = {
			SPELL_ENERGIZE 		= function(id,amount,typeEnergy)	
									if (typeEnergy == SPELL_POWER_ECLIPSE) then
										local energy = UnitPower("player" , SPELL_POWER_ECLIPSE);
										
										if (vars.energy == energy) then
											--If there's no real energy gain, there is no update (7)
											return
										end
										
										if id == data.EE.spellId then
											if vars.celestial_lockout_end == 0 then 
												--SOTF interaction with CA, 
												--to not to erase spells when the energy is CA's
												
												vars.energize_events_remaining = vars.energize_events_remaining -1;
												if vars.energize_events_remaining <=0 or (UpdateACTicksLeft() <= 0) or (abs(energy)==100) then
													--Updating ticks on AC using time due to not having energize events during CA
													--A lot of things (abs(energy)...) rely on the fact that AC is the only spell with more than 1 energize event
													
													vars.spell_casting = 0;
													vars.spell_num = 0;
													vars.energize_events_remaining = 0;
												--else
													--UpdateEnergizeAt(true)
												end
											else
												--Only remove CA if gained by this spell, since CA only prevents gaining energy from this spell
												vars.celestial_lockout_end = 0 --CA no more
											end
										end
										
										if energy ==100 then 
											vars.direction = "moon"; 		
											vars.eclipse = 100
										elseif energy == -100 then 
											vars.direction = "sun";	
											vars.eclipse = -100
										elseif (vars.direction == "moon" and energy <=0) or (vars.direction == "sun"  and energy >=0) or (vars.direction == "none") then
											vars.eclipse=false; 
										end
										
										if (energy == 0 and vars.energy+amount ~= 0) or vars.bug0ToBeWorkarounded then --need to check 0bug (and SS)
											vars.bug0ToBeWorkarounded = true;
											frame:RegisterEvent("UNIT_POWER"); --Schedule energy check
											LBPT.RecalcEnergy(vars.energy+amount)  --predict with the energy we have
										else
											LBPT.RecalcEnergy(energy) 
										end
									end
								end,
			--[[SPELL_CAST_FAILED 	= function(id,msg) --Handled with other events, left in case something goes wrong
									if vars.spell_casting == id and msg ~= SPELL_FAILED_NOT_READY and msg ~= SPELL_FAILED_SPELL_IN_PROGRESS then 
										deleteSpell()
									end 
								end,]]
			SPELL_AURA_APPLIED 	= function(id)
									if id == data.CA.spellId then
										checkCelestialAligmentBuff()
										
										if UnitPower("player",SPELL_POWER_ECLIPSE) ~= 0 then
											frame:RegisterEvent("UNIT_POWER"); --Schedule energy check
										end
										LBPT.RecalcEnergy(0) 
									end
								end,
			SPELL_AURA_REMOVED 	= function(id)
									local f = auraLossFunctionTable[id]
									if f then f(); end
								end,
		}
		function LBPT.combat.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,gUIDor,_,_,_,destGUID,_,_,_,spellId,_,_,amountEnergy,typeEnergy)
			if (gUIDor == playerGUID) then 
				event = unfilteredCombatLogTable[event] 
				if event then event(spellId,amountEnergy,typeEnergy) end
			elseif (destGUID == playerGUID) and event=="SPELL_INTERRUPT" and vars.spell_casting == amountEnergy then 
				deleteSpell()
			end
		end
	end

	do --Direction & energy when teleporting  
		function LBPT.combat.PLAYER_ENTERING_WORLD()
			vars.direction = GetEclipseDirection() or "none";
			deleteSpell()
		end; 
	end
end

do --Recalc Energy function	
	local SotFIndex = data.SoulOfTheForest.talentIndex;
	local SotFBonus = data.SoulOfTheForest.bonus;
	local function ExtraEnergy(energy,direction) --computes extra energy
		local eclipse = vars.eclipse
		local newEnergy;
		local newDirection;
		
		--Get spell energy
		if vars.energize_events_remaining > 0 and vars.last_energize_at >= vars.celestial_lockout_end then
			newEnergy = energy + energyFromSpell[vars.spell_casting][direction][((direction == "none") and ((energy>=0 and 100) or -100)) or (eclipse or 0) ];
		else
			newEnergy = energy;
		end
		
		--Add SOTF energy
		if select(5,GetTalentInfo(SotFIndex)) then --SOTF
			if vars.celestial_lockout_end ~= 0 then --CA 
				if direction == "moon" then
					newEnergy = newEnergy -SotFBonus;
				else
					newEnergy = newEnergy +SotFBonus;
				end
			elseif energy > 0 and newEnergy <=0 then
				newEnergy = newEnergy -SotFBonus;
			elseif energy < 0 and newEnergy >=0 then
				newEnergy = newEnergy +SotFBonus;
			end
		end
		
		--Set energy boundaries
		if newEnergy>=100 then 
			newEnergy,newDirection,eclipse = 100,"moon",100;
		elseif newEnergy<=-100 then 
			newEnergy,newDirection,eclipse = -100,"sun",-100;
		elseif (direction == "moon" and newEnergy <=0) or (direction == "sun"  and newEnergy >=0) or (direction == "none") then
			eclipse = false;
			newDirection = direction
		else
			newDirection = direction
		end
		
		if energy ~= newEnergy then 
			--if there's no change in energy, prediction shouln't change eclipse or direction
			--It should be here, because if you can only get 0 energy from spell, due to being already
			--at max energy, you won't get eclipse.
			--Test by reaching eclipse and then spend a "talent point"
			--CPU effect: 
				-- +1 asingación
				-- +2 asignación /ciclo
				-- +1 comprobación
			---- total: +2 instrucciones: incremento irrelevante
			return newEnergy,newDirection,eclipse;
		else
			return energy,direction,vars.eclipse;
		end
	end
	
	function LBPT.RecalcEnergy(energy)
		if not energy then  energy = UnitPower("player" , SPELL_POWER_ECLIPSE); end
		vars.energy = energy;
		vars.vEnergy,vars.vDirection,vars.vEclipse = ExtraEnergy(energy,vars.direction)	
		LBPT.FireCallbacks()
	end
end

do --Calling callbacks functions
	function LBPT.FireCallbacks()
		for k,v in pairs(callbacks) 		
			do v(vars.energy,vars.direction,vars.vEnergy,vars.vDirection,vars.vEclipse); 	
		end; 
	end;
end

do --Called functions (API)
	function LibBalancePowerTracker:RegisterCallback(callback)
		if number_callbacks==0 and LBPT.postLogin and vars.isDruid then
			LBPT.load();
		end
		
		number_callbacks=number_callbacks+1

		lastCallback=lastCallback+1
		callbacks[lastCallback]=callback;

		callback(vars.energy,vars.direction,vars.vEnergy,vars.vDirection,vars.vEclipse)
		return lastCallback
	end
	function LibBalancePowerTracker:UnregisterCallback(id)
		if callbacks[id] then
			callbacks[id]=nil;
		else
			return true;
		end
		
		number_callbacks=number_callbacks-1
		
		if number_callbacks==0 then
			LBPT.unload();
		end
	end
	function LibBalancePowerTracker:GetVersion()	return version[1],version[2],version[3]; end;
	
	-- Only used when AC was cast in CA (Who would want to...?, begins to fail when being hit after CA ends but before a energize event fires, pretty low chance, but taken care of anyway)
	--[[	time	0		1		2		3		4
			cast	[		|		|		|		|]
			ev.left	444444443333333322222222111111110
			happens        ( )     {-}                  
	]]
	local returned = data.AC.energize_events
	local ac_end_time = 0;
	function LibBalancePowerTracker.GetEnergizeEventsRemaining()
		if vars.started_in_CA then 
			--It's not an energize event, it it were, it should be handled before with the other function
			--Assumes it will be called every time spell cast is delayed
			
			local end_time = select(6,UnitChannelInfo("player"))
			local msGetTime = GetTime()*1000
			local events_left = min(math.floor((end_time - msGetTime)/data.AC.ms_btwn_events)+1,data.AC.energize_events)
			
			if ac_end_time > msGetTime then
				events_left = min(events_left,returned)
			end
			
			returned = events_left
			ac_end_time = end_time
			
			return events_left
		end 
		return vars.energize_events_remaining 
	end

	
	do --GetEclipseEnergyInfo
		--If called once, it would be called again, so I create a callback inside this do-end block
		local e,d,vE,vD,vEc;
		local callbackId = nil
		
		function LibBalancePowerTracker:GetEclipseEnergyInfo()
			if not callbackId then
				callbackId = self:RegisterCallback(
					function(energy,direction,vEnergy,vDirection,vEclipse) 
						e,d,vE,vD,vEc = energy,direction,vEnergy,vDirection,vEclipse 
					end 
				)
			end
		
			return e,d,vE,vD,vEc
		end
	end
end

do --Energy not gained by critters or wild pets
	-- DOESN'T WORK IN ALL LOCALIZATIONS -> TRIES TO WORK -> USES GLOBALS
	-- UnitIsBattlePet without having learned pet training -> always nil -> rely in UnitCreatureType
	-- CPU increase: 
	--		Worst case: 80% minimal LBPT CPU increase 		(critter focused and switching mouseover targets like crazy)
	--		Normal: 0										(no critter focused and moving the mouse avg)
	--	Well, it uses a lot of CPU compared to LBPT, but that's because LBPT is fairly low on CPU, so even with this enabled,
	--	addon CPU is still very low, however, if you want to deactivate it, call LibBalancePowerTracker.DisableCritterFiltering()
	--	you will need to /reload to enable it again (just reload and don't call the function)
	
	local UnitIsWildBattlePet,UnitCreatureType,UnitName = UnitIsWildBattlePet,UnitCreatureType,UnitName;
	LBPT_WILD_BATTLE_PET_LOCALIZED_TRY = strmatch(TOOLTIP_WILDBATTLEPET_LEVEL,"^.*%%s (.*)$");
	LBPT_CRITTER_LOCALIZED_TRY = BATTLE_PET_NAME_5
	
	local combatTable = LBPT.combat
	local isCritterOrWildPet = {
		mouseover = false,
		target = false,
		focus = false,
	}
	local count = 0;
	local sendTo = {}

	local function Critter(num) 
		local name = sendTo[num]
		if not name then return false; end

		for k,v in pairs(isCritterOrWildPet) do
			if v and UnitName(k) == name then return true end
		end
		
		return false
	end
	
	local function check(unit)
		local local_type = UnitCreatureType(unit)
		if (UnitIsWildBattlePet(unit) or (local_type and (local_type == LBPT_CRITTER_LOCALIZED_TRY or local_type == LBPT_WILD_BATTLE_PET_LOCALIZED_TRY))) then
			if not isCritterOrWildPet[unit] then
				isCritterOrWildPet[unit] = true;
				count = count+1;
				if count == 1 then
					sendTo = {}
					combatFrame:RegisterEvent("UNIT_SPELLCAST_SENT");
					combatTable.UNIT_SPELLCAST_SENT = LBPT.spellcast_sent
					LBPT.Critter = Critter
				end
			end
		else
			if isCritterOrWildPet[unit] then
				isCritterOrWildPet[unit] = nil
				count = count-1;
				if count == 0 then
					combatFrame:UnregisterEvent("UNIT_SPELLCAST_SENT");
					combatTable.UNIT_SPELLCAST_SENT = nil
					LBPT.Critter = nil
				end
			end
		end
	end
	
	function combatTable.PLAYER_TARGET_CHANGED()	check("target");	end
	function combatTable.PLAYER_FOCUS_CHANGED()		check("focus");		end
	function combatTable.UPDATE_MOUSEOVER_UNIT()	check("mouseover");	end

	function LBPT.spellcast_sent(unit,_,_,target,num)
		if unit ~= "player" then return end
		if isCritterOrWildPet.mouseover and not UnitExists("mouseover") then check("mouseover")	end
		if count>0 then sendTo[num] = target end
	end
	
	local critterFilterEnabled = true
	function LibBalancePowerTracker.DisableCritterFiltering()
		combatTable.PLAYER_TARGET_CHANGED = nil
		combatTable.PLAYER_FOCUS_CHANGED = nil
		combatTable.UPDATE_MOUSEOVER_UNIT = nil
		combatTable.UNIT_SPELLCAST_SENT = nil
		combatFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
		combatFrame:UnregisterEvent("PLAYER_FOCUS_CHANGED");
		combatFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
		combatFrame:UnregisterEvent("UNIT_SPELLCAST_SENT");
		LBPT.Critter = nil
		critterFilterEnabled = false
	end
	function LibBalancePowerTracker.GetCritterFilteringEnabled()
		return critterFilterEnabled;
	end
end

----TIER MODIFIER FUCNTION (At the end, so it sees and can modify all locals, sometimes I'll need to remove do-end blocks)
do --Tier bonus check
	local broadcasted = {}
	setmetatable(broadcasted, {__index = function () return 0 end})
	timers.broadcastTier:SetScript("OnHide",function() 
		for k,v in pairs(vars.tiers.tierPieceCount) do
			if broadcasted[k] ~= v then --broadcast
				if broadcasted[k] < v then --gained bonus
					for i = broadcasted[k]+1,v do
						if data.balanceTiersItemId[k]["bonus"..i.."p"] then 
							if data.balanceTiersItemId[k]["tested"..i.."p"] then
								print("|c00a080ffLibBalancePowerTracker|r: Tier"..k.." "..i.."p bonus detected.") 
							else
								print("|c00a080ffLibBalancePowerTracker|r: Tier"..k.." "..i.."p bonus detected (Untested).") 
							end
						end
					end
				else --lost bonus
					for i = v+1,broadcasted[k] do
						if data.balanceTiersItemId[k]["bonus"..i.."p"] then 
							print("|c00a080ffLibBalancePowerTracker|r: No tier"..k.." "..i.."p bonus detected.") 
						end
					end
				end
				broadcasted[k] = v
			end
		end
	end)
	
	function LBPT.PLAYER_EQUIPMENT_CHANGED(slot,hasItem)
		local setInSlot = vars.tiers[slot]
		if setInSlot then						--print("retirado objeto de "..slot)
			vars.tiers[slot]=false;
			
			local num_p_tier = vars.tiers.tierPieceCount[setInSlot]-1
			vars.tiers.tierPieceCount[setInSlot]= num_p_tier --print("Tienes "..vars.tiers.tierPieceCount[setInSlot].." piezas de tier "..setInSlot)
			
			if data.balanceTiersItemId[setInSlot]["bonus"..(num_p_tier+1).."p"] and LBPT.BonusTier[setInSlot][num_p_tier+1].Off() then 
				timers.broadcastTier:SetCooldown(GetTime(),0)  
			end	
		end
		
		if hasItem and setInSlot ~= nil then 				--print("se intenta poner una pieza en "..slot)
			local id = GetInventoryItemID("player", slot)	--print("el id de la pieza es "..tostring(id))
			for k,v in pairs(data.balanceTiersItemId) do	--print("buscando en tier "..k)
				if v[slot] and v[slot][id] then				--print("encontrado en tier "..k)
					vars.tiers[slot]=k;
					
					local num_p_tier = vars.tiers.tierPieceCount[k]+1
					vars.tiers.tierPieceCount[k]= num_p_tier --print("Tienes "..vars.tiers.tierPieceCount[k].." piezas de tier "..k);
					
					if v["bonus"..num_p_tier.."p"] and LBPT.BonusTier[k][num_p_tier].On() then 
						timers.broadcastTier:SetCooldown(GetTime(),0)
					end
					
					return
				end
			end
		end
	end
end

LBPT.BonusTier={
	[12]={
		[4]={
			On  = 	function()
						energyFromSpell[data.SF.spellId].sun[100]  = 2*(data.SF.energy+5)
						energyFromSpell[data.SF.spellId].sun[000]  = 2*(data.SF.energy+5)
						
						energyFromSpell[data.SF.spellId].none[-100] = 2*(data.SF.energy+5)
						energyFromSpell[data.SF.spellId].none[ 000] = 2*(data.SF.energy+5)
						energyFromSpell[data.SF.spellId].none[ 100] = 2*(data.SF.energy+5)

						energyFromSpell[data.WR.spellId].moon[-100] = 2*(-data.WR.energy-3)
						energyFromSpell[data.WR.spellId].moon[ 000] = 2*(-data.WR.energy-3)
						
						energyFromSpell[data.WR.spellId].none[-100] = 2*(-data.WR.energy-3)
						energyFromSpell[data.WR.spellId].none[ 000] = 2*(-data.WR.energy-3)
						energyFromSpell[data.WR.spellId].none[ 100] = 2*(-data.WR.energy-3)

						return true;
					end,
			Off = 	function() 
						energyFromSpell[data.SF.spellId].sun[100]  = 2*data.SF.energy
						energyFromSpell[data.SF.spellId].sun[000]  = 2*data.SF.energy
						
						energyFromSpell[data.SF.spellId].none[-100] = 2*data.SF.energy
						energyFromSpell[data.SF.spellId].none[ 000] = 2*data.SF.energy
						energyFromSpell[data.SF.spellId].none[ 100] = 2*data.SF.energy

						energyFromSpell[data.WR.spellId].moon[-100] = -2*data.WR.energy
						energyFromSpell[data.WR.spellId].moon[ 000] = -2*data.WR.energy
						
						energyFromSpell[data.WR.spellId].none[-100] = -2*data.WR.energy
						energyFromSpell[data.WR.spellId].none[ 000] = -2*data.WR.energy
						energyFromSpell[data.WR.spellId].none[ 100] = -2*data.WR.energy
						
						return true;
					end,
		},
	},
}

do ----DEBUG---------------------
	local debug_on_load --= true; 
	------------------------------
	local dbug = false;
	local dbug_init = false;
	local ev;
	if BalancePowerTracker_Options then BalancePowerTracker_Options.debug_event_list = nil end
	
	function LibBalancePowerTracker:ToogleDebug()
		dbug = not dbug;
		print("|c00a080ffLibBalancePowerTracker|r: Debug:",dbug)

		LBPT_DEBUG_EVENT_LIST = {}
		LBPT_DEBUG_EVENT_LIST.insertAt = 1;
			
		if BalancePowerTracker_Options then BalancePowerTracker_Options.debug_event_list = LBPT_DEBUG_EVENT_LIST end
				
		if not dbug_init then
			local function insert(...)
				LBPT_DEBUG_EVENT_LIST[LBPT_DEBUG_EVENT_LIST.insertAt] = {UnitPower("player",SPELL_POWER_ECLIPSE),GetEclipseDirection(),CheckEcplipseBuff(),GetTime(),...}
				LBPT_DEBUG_EVENT_LIST.insertAt = LBPT_DEBUG_EVENT_LIST.insertAt+1
			end
			
			function LibBalancePowerTracker.PrintDebugEvents(i)
				if (not i) or type(i) ~= "number" or i<=0 then i = 50 end
			
				for i = max(LBPT_DEBUG_EVENT_LIST.insertAt-i,1),LBPT_DEBUG_EVENT_LIST.insertAt do
					print(unpack(LBPT_DEBUG_EVENT_LIST[i] or {}))
				end
			end
			
			function LBPT.FireCallbacks()
				if dbug then
					insert("CALLBACKS_FIRED",vars.energy,vars.direction,vars.vEnergy,vars.vDirection,vars.vEclipse,ev) 
				end
				for k,v in pairs(callbacks) 		
					do v(vars.energy,vars.direction,vars.vEnergy,vars.vDirection,vars.vEclipse); 	
				end; 
			end;
			
			combatFrame:SetScript("OnEvent",  function(_, event, ...) ev=event insert(event,...) LBPT.combat[event](...)	end);
			frame:SetScript("OnEvent",  function(_, event, ...) ev=event insert(event,...) LBPT[event](...)  end);
			
			function LibBalancePowerTracker:mySearch(s,t,n,l)
				if not n then n = 0; end
				if not l then l = "" end
				if not t then t = _G end

				for k,v in pairs(t) do
					k = tostring(k)
					if type(v) == "string" and string.find(v,s) then 
						print(l,k,v)
					elseif type(v)=="table" and k ~= "_G" then
						if n>10 then return end
						self:mySearch(s,v,n+1,l.." "..k)
					elseif string.find(k,s) then
						print(l,k,v)
					end
				end
			end
		end
		dbug_init = true;
	end
	if debug_on_load then
		LibBalancePowerTracker:ToogleDebug()
	end
end