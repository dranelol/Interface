
local L = LibStub("AceLocale-3.0"):GetLocale("atroxArenaViewer", true)

AAV_PlayStub = {}
AAV_PlayStub.__index = AAV_PlayStub

function AAV_PlayStub:new()
	local self = {}
	setmetatable(self, AAV_PlayStub)
	
	self.data = nil
	self.seeker = nil
	self.player = nil
	self.maptext = nil
	self.loading = nil
	self.tick = 1
	self.pool = {}
	self.pool.list = {}
	self.pool.list[1] = {} -- team left
	self.pool.list[2] = {} -- team right
	self.pool.cbt = {} -- combat texts
	self.pool.stats = {} -- stat frames
	self.cooldowns = {}
	self.usedskills = {} -- keep track of skills in combat texts
	self.interrupts = {} -- for Xs used
	self.ccs = {} -- ccs aka crowdcontrols
	self.auras = {} -- buffs and debuffs
	self.entities = {}
	self.index = {}
	self.startTime = 0
	self.matchTime = 0
	self.viewdetail = true
	self.cclist = {} -- used for preventing multiple ccs on same icon
	self.indexCycle = CreateFrame("FRAME") -- used for splitted index creation
	self.cycleTime = 0.0333 -- duration how much time is used for each frame (30 fps)
	self.currentCycle = 0 -- index id of data
	self.calc = {}
	self.calc.buff = {}
	self.calc.debuff = {}
	self.calc.cc = {}
	self.calc.cd = {}
	
	----
	-- these skills won't be shown.
	self.exceptskills = {
		32727,	-- Arena Preparation
	}
	
	return self
end

function AAV_PlayStub:onUpdate(elapsed)
	
	-- combat text update
	for k,v in pairs(self.pool.cbt) do
		if (not v:isDead()) then
			v:moveText(elapsed, GetFramerate())
		end
	end
	
	-- skills update
	for k,v in pairs(self.usedskills) do
		if (not v:isDead()) then
			v:moveSkill(elapsed, GetFramerate())
		end
	end
	
	-- resetting cc preventing list
	for k,v in pairs(self.cclist) do
		self.cclist[k] = nil
	end
	
	-- ccs update
	local lastCc = nil
	for k,v in pairs(self.ccs) do
		if (not v:isDead()) then
			v:update(elapsed, GetFramerate(), not self.cclist[v.id]) -- prevents overlaying ccs
			--v:update(elapsed, GetFramerate())
			self.cclist[v.id] = true
		end
	end
	
	-- cooldown update
	for k,v in pairs(self.cooldowns) do
		if (not v:isDead()) then
			v:update(elapsed, GetFramerate())
		else
			v.frame:Hide()
			self.entities[v.entity]:removeCooldown(v)
			self.entities[v.entity]:arrangeCooldowns()
		end
	end
	
end


function AAV_PlayStub:hideMovingObjects()
	-- hide combattexts
	for k,v in pairs(self.pool.cbt) do
		if (v) then
			v:hide()
		end
	end
	
	-- hide skills
	for k,v in pairs(self.usedskills) do
		if (v) then
			v:hide()
		end
	end
end

----
-- hides the current player and handles all running events.
function AAV_PlayStub:hidePlayer(frame)
	if (frame) then
		self:handleTimer("stop")
		self:setOnUpdate("stop")
		
		for k,v in pairs(self.pool.list) do
			for c,w in pairs(self.pool.list[k]) do
				if (w) then
					w:hide()
					w:hideAllAura()
					w:setOpacity(1)
				end
			end
		end
		
		frame:Hide()
	end
end

----
function AAV_PlayStub:setOnUpdate(val)
	if (val == "start") then
		AAV_GUI_UPDATEFRAME:SetScript("OnUpdate", function(s, elapsed) atroxArenaViewer:onUpdate(elapsed) end)
	elseif (val == "stop") then
		AAV_GUI_UPDATEFRAME:SetScript("OnUpdate", function() end)
	end
end

----
-- sets the map text on top of the player and adjusts the width.
-- @param mapid map name id
function AAV_PlayStub:setMapText(mapid)
	if (type(mapid)=="number") then
		self.maptext:SetText(AAV_COMM_MAPS[mapid])
	else
		self.maptext:SetText(mapid)
	end
	
	self.maptext:GetParent():SetWidth(self.maptext:GetStringWidth() + 25)
end

----
-- sets match data.
-- @param data whole match data
function AAV_PlayStub:setMatchData(id)
	self.data = nil
	self.data = atroxArenaViewerData.data[id]
end

----
-- returns the whole data of a match.
-- @return match data
function AAV_PlayStub:getMatch()
	return self.data
end

----
-- returns specific event entry in match data.
-- @param id match index
-- @return data
function AAV_PlayStub:getMatchData(id)
	return self.data.data[id]
end

----
-- returns the match data of the current tick (self.tick).
-- @return current match data of index tick
function AAV_PlayStub:getCurrentMatchData()
	return self.data.data[self.tick]
end

----
-- returns all match member data.
-- @return dudes
function AAV_PlayStub:getDudesData()
	if (self.data and self.data.combatans and self.data.combatans.dudes) then
		return self.data.combatans.dudes
	end
end

function AAV_PlayStub:resetData()
	self.data = nil
end

function AAV_PlayStub:resetDudeData()
	if (self.data and self.data.combatans and self.data.combatans.dudes) then
		self.data.combatans.dudes = {}
	end
end

function AAV_PlayStub:addDudeData(key, table)
	if (not self.data) then self.data = {} end
	if (not self.data.combatans) then self.data.combatans = {} end
	if (not self.data.combatans.dudes) then self.data.combatans.dudes = {} end
	self.data.combatans.dudes[key] = {}
	self.data.combatans.dudes[key] = table
end

----
-- returns current tick of running match
-- @return tick
function AAV_PlayStub:getTick()
	return self.tick
end

----
-- returns current tick of running match
-- @param value tick value
function AAV_PlayStub:setTick(value)
	self.tick = value
end

----
-- creates on the basis of the match member data the GUI bars.
-- @param f frame parent
function AAV_PlayStub:newEntities(f)
	local b, c, cr, n, s, txt
	local dir = {[1]=0, [2]=0}
	
	for k,v in pairs(self:getDudesData()) do
		if (v.player) then -- only players
			
			if (not self.pool.list[v.team][dir[v.team]]) then
				
				local entity = AAV_PlayerEntity:new(f, v, dir[v.team], v.starthpmax, v)
				
				self.pool.list[v.team][dir[v.team]] = entity
				self.entities[v.ID] = entity
			else
				self.pool.list[v.team][dir[v.team]]:setValue(v.class, v.name, v.starthpmax, v)
				self.entities[v.ID] = self.pool.list[v.team][dir[v.team]]
				self.entities[v.ID]:transferAuras(self.pool.list[v.team][dir[v.team]])
			end
			
			self.entities[v.ID]:show()
			self.entities[v.ID]:getVisibleNum(1)
			
			-- color adjustment
			self.entities[v.ID].bar:SetStatusBarColor(AAV_Util:getTargetColor(v, false))
			
			
			dir[v.team] = dir[v.team] + 1
		end
	end
end

function AAV_PlayStub:updateHealthtext()
	for k,v in pairs(self.entities) do
		v:setHealthBarText()
	end
end

----
-- sets health bar value.
-- @param id affected bar
-- @param value health
function AAV_PlayStub:setBar(id, value)
	if (not self.entities[id]) then return end
	
	self.entities[id].bar:SetValue(value)
	self.entities[id]:setHealthBarText()
	--self.entities[id].text:SetText(self:getHealthBarText(id))
end

----
-- sets max health bar value.
-- @param id affected bar
-- @param value max health
function AAV_PlayStub:setMaxBar(id, value)
	if (not self.entities[id]) then return end
	
	self.entities[id].bar:SetMinMaxValues(0, value)
	self.entities[id]:setHealthBarText();
	--self.entities[id].text:SetText(self:getHealthBarText(id, value, nil))
end

----
-- sets the mana bar to a percent value.
function AAV_PlayStub:setMana(id, value)
	if (not self.entities[id]) then return end
	self.entities[id].mana:SetValue(value)
end

----
-- sets visibility of a target e.g. coming out of stealth.
-- @param id player id
-- @param type 1 = unseen, 2 = seen, 3 = arena leave
function AAV_PlayStub:setVisibility(id, type)
	if (not self.entities[id]) then return end
	
	if (type == 1) then
		self.entities[id]:setOpacity(0.5)
	elseif (type == 2) then
		self.entities[id]:setOpacity(1)
	elseif (type == 3) then
		--
	end
end

----
-- sets the health bar text. 
-- according to certain configuration, it can be shown as percentage or absolute value.
-- @param id affected bar
-- @param value max health
-- @return full text for health bar, default = ???
--[[
function AAV_PlayStub:getHealthBarText(id, max)
	if (not self.entities[id]) then return end
	
	local txt = "???"
	local min, max = self.entities[id].bar:GetMinMaxValues()
	local value = self.entities[id].bar:GetValue()
	
	-- check for percentage or aboslute values
	if (value == 0) then
		txt = "Dead"
	else
		if (atroxArenaViewerData.defaults.profile.healthdisplay == 1) then
			local a = (value/max)*100*10
			local i = string.find(a,"[\.]",1)
			if (i) then a = tonumber(string.sub(a,1, string.find(a,"[\.]",1)-1)) end
			txt = (a / 10) .. "%"
		elseif (atroxArenaViewerData.defaults.profile.healthdisplay == 2) then
			txt = value .. " / " .. max
		elseif (atroxArenaViewerData.defaults.profile.healthdisplay == 3) then
			txt = (value - max) .. " / " .. max
		end
	
		
	end
	
	return txt
end
--]]

----
--
-- 
function AAV_PlayStub:getTickTime()
	return self.tickTime
end

----
--
--
function AAV_PlayStub:setTickTime(value)
	self.tickTime = value
end

----
-- returns a given time into "00:00,0".
-- @param time accurate to a tenth
-- @return formatted time string
function AAV_PlayStub:getFormatTime(time)
	local a, b = "0", "0"
	if (math.floor(time/60) >= 10) then a = "" end
	if (math.floor(time%60) >= 10) then b = "" end
	return a .. math.floor(time/60) .. ":" .. b .. math.floor(time%60) .. "." .. math.floor(time%60*10%10)
end

function AAV_PlayStub:updatePlayerTick()
	local format = self:getFormatTime(self:getTickTime())
	
	--self.seeker.tick:SetText(a .. math.floor(tick/60) .. ":" .. b .. math.floor(tick%60) .. "." .. math.floor(tick%60*10%10))
	self.seeker.tick:SetText(format)
	self.seeker.bar:SetValue(self:getTickTime())
end


function AAV_PlayStub:setSeekerTooltip()
	local elapsed = function()
		
		local current = math.floor(GetCursorPosition()) - (math.floor(self.seeker.bar:GetLeft() * self.seeker.bar:GetEffectiveScale()))
		local width = math.floor(self.seeker.bar:GetWidth() * self.seeker.bar:GetEffectiveScale())
		local percent = current / width * 100
		return math.floor(self.data.elapsed * percent/100)
	end
	
	self.seeker.bar:EnableMouse(true)
	self.seeker.bar:SetScript("OnEnter", function() 
		self.seeker.bar:SetScript("OnUpdate", function()
			AAV_Gui:SetGameTooltip("Jump to " .. self:getFormatTime(elapsed()) , 0, self.seeker.bar)
		end)
		
	end)
	
	self.seeker.bar:SetScript("OnLeave", function() 
		GameTooltip:FadeOut()
		self.seeker.bar:SetScript("OnUpdate", nil)
	end)
	
	self.seeker.bar:SetScript("OnMouseDown", function() 
		local elap = elapsed()
		local done = false
		
		if (not atroxArenaViewer:TimeLeft(timer)) then
			self:handleTimer("start")
		end
		
		self:setTickTime(elap)
		self:setTick(1)
		
		while (not done) do
			local post = AAV_Util:split(self:getCurrentMatchData(), ',')
			if (not self:getCurrentMatchData() or (tonumber(post[1]) >= self:getTickTime())) then
				done = true
			else
				self:setTick(self:getTick() + 1)
			end
		end
		
		self:reAdjustTypes()
		--self:hideMovingObjects()
		
		AAV_Gui:SetGameTooltip("Jump to " .. self:getFormatTime(elap) , 0, self.seeker.bar)
	end)
end

----
-- starts or stops the timer.
-- @param value operation
function AAV_PlayStub:handleTimer(value)
	if (value == "stop" and timer and atroxArenaViewer:TimeLeft(timer)) then
		atroxArenaViewer:CancelTimer(timer)
		timer = nil
	elseif (value == "start" and (not timer or (timer and not atroxArenaViewer:TimeLeft(timer)))) then
		timer = atroxArenaViewer:ScheduleRepeatingTimer("evaluateMatchData", atroxArenaViewerData.defaults.profile.update)
	end
end

----
-- after a seeker jump the values of the entities must be readjusted.
function AAV_PlayStub:reAdjustTypes()
	-- hp, maxhp
	local val, cval
	local events = {1, 2, 17}
	
	self:removeAllCC()
	self:removeAllCooldowns()
	
	for c,w in pairs(self:getDudesData()) do
		if (w.player) then
			for k,v in pairs(events) do
				val = self:getIndexValue(self:getTick(), w.ID, v)
				
				if (val) then
					if (v == 1) then
						self:setBar(w.ID, val)
					elseif (v == 2) then
						self:setMaxBar(w.ID, val)
					elseif (v == 17) then
						self:setMana(w.ID, val)
					end
				end
			end
			
			-- buffs
			self.entities[w.ID]:hideAllAura()
			self.entities[w.ID]:removeAllAuras(w.ID)
			self.entities[w.ID]:setOpacity(1)
			
			val = AAV_Util:split(self:getIndexValue(self:getTick(), w.ID, "buff"), ',')
			if (val) then 
				for a,b in pairs(val) do
					if (not atroxArenaViewerData.defaults.profile.shortauras or (atroxArenaViewerData.defaults.profile.shortauras and #self.entities[w.ID].buffs <= AAV_MAX_AURASVISIBLE)) then
						self:addAura(w.ID, tonumber(b), 1)
					end
				end
			end
			
			val = AAV_Util:split(self:getIndexValue(self:getTick(), w.ID, "debuff"), ',')
			if (val) then
				for a,b in pairs(val) do
					if (not atroxArenaViewerData.defaults.profile.shortauras or (atroxArenaViewerData.defaults.profile.shortauras and #self.entities[w.ID].buffs <= AAV_MAX_AURASVISIBLE)) then
						self:addAura(w.ID, tonumber(b), 2)
					end
				end
			end
			
			val = AAV_Util:split(self:getIndexValue(self:getTick(), w.ID, "cc"), ',')
			if (val) then 
				for k,v in pairs(val) do 
					cval = AAV_Util:split(v, ':')
					if (AAV_IMPORTANTSKILLS[tonumber(cval[1])]) then
						self:addCC(w.ID, tonumber(cval[1]), tonumber(cval[2]), 3)
					end
				end
			end
			
			val = AAV_Util:split(self:getIndexValue(self:getTick(), w.ID, "cd"), ',')
			if (val) then 
				for k,v in pairs(val) do 
					cval = AAV_Util:split(v, ':')
					if (AAV_CCSKILS[tonumber(cval[1])]) then
						self:addCooldown(w.ID, tonumber(cval[1]), tonumber(cval[2]))
					end
				end
			end
		end
	end
	
	self:hideMovingObjects()
end

----
-- @param id playerid
-- @param amount healing or damage number
-- @param crit whether critical or not
-- @param type 1 = damage, 2 = heal
function AAV_PlayStub:addFloatingCombatText(id, amount, crit, type)
	if (not self.entities[id]) then return end
	
	local found = false
	if (#self.pool.cbt <= AAV_GUI_MAXCOMBATTEXTOBJECTS) then
		table.insert(self.pool.cbt, AAV_CombatText:new(self.entities[id].crange, self.entities[id].team, type, amount, crit))
	else
		for k,v in pairs(self.pool.cbt) do
			if (v:isDead()) then
				v:setValue(self.entities[id].crange, type, amount, crit)
				found = true
				break
			end
		end
		if (not found) then -- just insert it on any slot
			self.pool.cbt[math.random(1, AAV_GUI_MAXCOMBATTEXTOBJECTS)]:setValue(self.entities[id].crange, type, amount, crit)
		end
	end
end

----
-- adds a cooldown on the cooldown bar vertically.
-- @param id player id
-- @param spellid
-- @param duration cooldown in seconds
function AAV_PlayStub:addCooldown(id, spellid, duration)
	if (not self.entities[id]) then return end
	
	local _name = GetSpellInfo(spellid)
	local found = false
	
	for k,v in pairs(self.cooldowns) do
		if (v:isDead() or (v.spellid == spellid and v.entity == id)) then
		
			-- reuse
			if (v.spellid == spellid and v.entity == id) then 
				self.entities[v.entity]:removeCooldown(v)
			end
			
			v:setValue(self.entities[id].cdrange, spellid, duration, id, #self.entities[id].cooldowns)
			self.entities[id]:addCooldown(v)
			found = true
			break
		end
	end
	
	if (not found) then
		-- create new
		local cd = AAV_Cooldown:new(self.entities[id].cdrange, spellid, duration, id, #self.entities[id].cooldowns)
		self.entities[id]:addCooldown(cd)
		table.insert(self.cooldowns, cd)
	end
	
	for k,v in pairs(self.entities) do
		v:arrangeCooldowns()
	end
	--self.entities[id]:arrangeCooldowns()
end

----
-- let the skill bar slide to the right.
-- @param id playerid
function AAV_PlayStub:noticeToSlide(id)
	if (not self.entities[id]) then return end

	for k,v in pairs(self.entities[id].skills) do
		v:slideRight()
	end
end

----
-- @param id source
-- @param spellid
-- @param cast casting spell
-- @param targetid target, when -1 then unfilled (AE spells without target)
-- @param casttime time of cast
function AAV_PlayStub:addSkillIcon(id, spellid, cast, targetid, casttaim)
	
	if (not self.entities[id]) then return end
	casttime = casttaim
	--if (not casttime) then _, _, _, _, _, _, casttime = GetSpellInfo(spellid) end
	
	local target
	if (targetid == -1) then targetid = nil end
	if (not self.entities[targetid]) then target = nil else target = self.entities[targetid].data end
	
	--check if already exist UsedSkills
	local found = false
	
	if (#self.entities[id].skills < AAV_GUI_MAXUSEDSKILLSOBJECTS) then
		
		local us = AAV_UsedSkill:new(self.entities[id].srange, spellid, cast, #self.entities[id].skills, target)
		self:noticeToSlide(id)
		table.insert(self.usedskills, us)
		table.insert(self.entities[id].skills, us)
	else
		
		for k,v in pairs(self.entities[id].skills) do
			if (v:isDead()) then
				self:noticeToSlide(id)
				v:setValue(self.entities[id].srange, spellid, cast, #self.entities[id].skills, target)
				found = true
				break
			end
		end
		if (not found) then
			self:noticeToSlide(id)
			self.entities[id].skills[math.random(1, AAV_GUI_MAXUSEDSKILLSOBJECTS)]:setValue(self.entities[id].srange, spellid, cast, #self.entities[id].skills, target)
		end
	end
end

----
-- interrupts a casting cast.
-- @param source player id
-- @param dest target id
-- @param spellid skill that interrupted
-- @param interrupted the interrupted spell id
function AAV_PlayStub:interruptSkill(source, dest, spellid, interrupted)
	
	if (not self.entities[dest]) then return end
	
	local target, rupt = nil, nil
	
	-- check if destination is actually casting a spell
	for k,v in pairs(self.entities[dest].skills) do
		if (v:isCasting()) then
			target = v
			target.cast = false
			break
		end
	end
	if (not target) then return end
	
	-- reuse X texture on skill
	for k,v in pairs(self.interrupts) do
		if (not v:IsShown()) then
			rupt = v
			break
		end
	end
	
	if (not rupt) then 
		rupt = AAV_Gui:createInterruptFrame(target.frame)
		table.insert(self.interrupts, rupt)
	end
	
	AAV_Gui:setInterruptOnBar(target.frame, rupt)
	
	target.interrupt = rupt
	target.interrupt:Show()
	
end

----
-- adds a specific aura.
-- @param id playerid
-- @param spellid
-- @param type buff = 1, debuff = 2
function AAV_PlayStub:addAura(id, spellid, type, duration)
	if (not self.entities[id]) then return end
	
	local aura = nil
	
	--don't add if it's in the exceptskills table
	for k,v in pairs(self.exceptskills) do
		if (v == spellid) then return end
	end
	
	-- check if there are unused objects to retake
	for k,v in pairs(self.auras) do
		if (not v.frame:IsShown()) then
			aura = v
			break
		end
	end
	
	-- create new
	if (not aura) then
		aura = self.entities[id]:addAura(spellid, type, duration)
		table.insert(self.auras, aura)
		
		
	else
		aura = self.entities[id]:addAura(spellid, type, duration)
	end
end

----
-- removes a specific aura.
-- @param id playerid
-- @param spellid
-- @param type buff = 1, debuff = 2
function AAV_PlayStub:removeAura(id, spellid, type)
	if (not self.entities[id]) then return end
	
	if (self.entities[id]) then self.entities[id]:removeAura(spellid, type) end
end

----
-- removes all existing buffs and debuffs.
-- @param id playerid
function AAV_PlayStub:removeAllAuras(id)
	if (not self.entities[id]) then return end
	
	if (self.entities[id]) then self.entities[id]:removeAllAuras() end
end

----
-- returns the current bracket size according to the dudes data.
-- @return bracket size
function AAV_PlayStub:getCurrentBracket()
	local bracket = 0
	if (self.data and self.data.combatans and self.data.combatans.dudes) then
		for k,v in pairs(self.data.combatans.dudes) do
			if (v.player == 1 and v.team == 1) then
				bracket = bracket + 1
			end
		end
	end
	return bracket
end

----
-- creates or take existing gui elements.
-- @param num match id
-- @param elapsed time
-- @param broadcast true = watches a broadcasts, false = local playing
function AAV_PlayStub:createPlayer(bracket, elapsed, broadcast)
	
	if (not self.player) then 
		self.origin, self.player, self.maptext, self.loading = AAV_Gui:createPlayerFrame(self, bracket)
		self.detail = AAV_Gui:createButtonDetail(self.origin)
		self.seeker = {}
		
		self.seeker.bar, self.seeker.back, self.seeker.slide, self.seeker.speedval, self.seeker.speed = AAV_Gui:createSeekerBar(self.player, elapsed)
		self.seeker.status = AAV_Gui:createStatusText(self.origin)
		self.seeker.tick = AAV_Gui:createSeekerText(self.seeker.bar)
		self.stats = AAV_Gui:createStatsFrame(self.origin)
		
		self.stats:Hide()
		self.viewdetail = true
		
		self.seeker.speedval:SetText(L.SPEED .. ":")
		
		self.detail:SetText(L.VIEW_STATS)
		self.detail:SetScript("OnClick", function() 
			self.viewdetail = not self.viewdetail
			
			if (self.viewdetail) then
				self.player:Show()
				self.detail:SetText(L.VIEW_STATS)
				self.stats:Hide()
				-- go timer
			else
				self.player:Hide()
				self.detail:SetText(L.VIEW_MATCH)
				self.stats:Show()
				-- stop timer
			end
		end)
		
		if (broadcast) then
			self.seeker.status:Show()
			self:handleSeeker("hide")
		end
	else
		-- reset values
		if (not broadcast) then
			self.seeker.bar:SetMinMaxValues(0, elapsed)
			self.seeker.bar:SetValue(0)
			self:setTick(1)
			self.seeker.status:Hide()
			self:handleSeeker("show")
		else
			self.seeker.status:Show()
			self:handleSeeker("hide")
		end
		
		AAV_Gui:setPlayerFrameSize(self.player, bracket)
		AAV_Gui:setPlayerFrameSize(self.origin, bracket)
		
	end

	self.origin:Show()
	
	self.stats:Hide()
	self.viewdetail = true
	
	for k,v in pairs(self.pool.stats) do
		v:hideAll()
	end

	if (not broadcast) then
		self:newEntities(self.player)
		self:handleIndexCreation("start")
		self:setSeekerTooltip()
		self.detail:Show()
		
		self:createStats(self:getMatch()["teams"], self:getMatch()["combatans"]["dudes"], bracket)
		
	else
		self.detail:Hide()
		self.loading:Hide()
		self.player:Show()
		
	end
	
	-- self.player:Show()

	
end

----
-- handles the function of the index creation frame, that is used for
-- splitting the index calculation process in several frames.
-- @param val "start" or "stop"
function AAV_PlayStub:handleIndexCreation(val)
	
	if (val == "start") then
		currentCycle = 1
		--self:createIndex()
		self.loading:Show()
		self.indexCycle:SetScript("OnUpdate", function()
			self:createIndexCycle()
		end)
		
	elseif (val == "stop") then
		self.indexCycle:SetScript("OnUpdate", function() end)
		self:handleTimer("start")
		self.loading:Hide()
	end
end

function AAV_PlayStub:createStats(teamdata, matchdata, bracket)
	local num = 1
	if (#self.pool.stats == 0) then -- if empty
		for k,v in pairs(teamdata) do		
			local stat = AAV_TeamStats:new(self.stats, v, matchdata, k+1, bracket)
			self.pool.stats[num] = stat
			table.insert(self.pool.stats, stat)
			num = num + 1
		end
	else
		for k,v in pairs(teamdata) do
			self.pool.stats[num]:setValue(self.stats, v, matchdata, k+1, bracket)
			num = num + 1
		end
	end
end

function AAV_PlayStub:handleSeeker(val)
	if (val == "show") then
		self.seeker.bar:Show()
		self.seeker.back:Show()
		self.seeker.tick:Show()
		self.seeker.slide:Show()
		self.seeker.slide:SetValue(100)
		self.seeker.speed:Show()
		self.seeker.speedval:Show()
		atroxArenaViewerData.current.interval = 0.1
	elseif (val == "hide") then
		self.seeker.bar:Hide()
		self.seeker.back:Hide()
		self.seeker.tick:Hide()
		self.seeker.slide:Hide()
		self.seeker.speed:Hide()
		self.seeker.speedval:Hide()
	end
end

----
-- sets the status text of the broadcaster's.
-- @param status current state
function AAV_PlayStub:setStatus(status)
	if (status == 1) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_IDLE)
	elseif (status == 2) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_QUEUE)
	elseif (status == 3) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_ENTER)
	elseif (status == 4) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_BOX_60)
	elseif (status == 5) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_BOX_45)
	elseif (status == 6) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_BOX_30)
	elseif (status == 7) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_BOX_15)
	elseif (status == 8) then
		self.seeker.status:SetText(L.STATUS .. ": " .. L.STATUS_FIGHT)
	end
end

----
-- checks if the omitted spellid is a CC and adds it to the player's frame.
-- @param id playerid
-- @param spellid
function AAV_PlayStub:addCC(id, spellid, time, lvl)
	if (not self.entities[id]) then return end
	
	local cc, icon
	_, _, icon = GetSpellInfo(spellid)
	
	-- check for unused cc
	for k,v in pairs(self.ccs) do
		if (v:isDead()) then
			cc = v
			break
		end
	end
	if (not cc) then
		cc = AAV_Crowd:new(self.entities[id].icon, #self.ccs)
		table.insert(self.ccs, cc)
	end
	
	cc:setValue(spellid, id, icon, self.entities[id].icon, time, lvl)
end


----
-- removes a cc if it's been removed before expiring.
-- @param id userid
-- @param spellid
function AAV_PlayStub:removeCC(id, spellid)
	for k,v in pairs(self.ccs) do
		if (not v:isDead() and v.spellid == spellid and v.id == id) then
			v:setDead()
			break
		end
	end
end

----
-- removes all active ccs.
function AAV_PlayStub:removeAllCC()
	for k,v in pairs(self.ccs) do
		if (not v:isDead()) then
			v:setDead()
		end
	end
end

function AAV_PlayStub:removeAllCooldowns()
	for k,v in pairs(self.cooldowns) do
		v.dead = true
		v.frame:Hide()
	end
	for k,v in pairs(self.entities) do
		v:removeAllCooldowns()
	end
end

----
-- creates all index related things into a table.
-- in index table on index field 0 will be saved the first occured value of every event.
function AAV_PlayStub:createIndex()
	local s, ss
	local events = {1, 2, 13}
	self.index = {} -- resets previous indexi
	
	for ik,iv in pairs(events) do
		for ic, iw in pairs(self:getDudesData()) do
			if (iw.player) then -- if player
				ss = nil
				for f,g in pairs(self.data.data) do
					if (g) then
						s = AAV_Util:split(g, ',')
						
						if (tonumber(iw.ID) == tonumber(s[3]) and tonumber(s[2]) == iv) then
							
							if (iv == 1) then ss = s[4] end
							if (iv == 2) then ss = s[5] end
							if (iv == 13) then ss = s[4] end
							break
						end
					end
				end
				if (ss) then
					if (not self.index[iw.ID]) then self.index[iw.ID] = {} end
					if (not self.index[iw.ID][0]) then self.index[iw.ID][0] = {} end
					self.index[iw.ID][0][iv] = ss
				end
			end
		end
	end

end

function AAV_PlayStub:createIndexCycle()

	local id, event, i, j, lastticktime = 0, 0, 0, 0, 0
	local k, v, time = 0, 0, GetTime()
	
	-- resetting buff, debuff, cc and cd tables
	for k,v in pairs(self.calc) do
		wipe(v)
	end
	
	--local resetcc = function(c) for k,v in pairs(c) do c.k = nil end end
	--print(#self.data.data)
	
	while (self.data.data[currentCycle] and (GetTime() - time < self.cycleTime)) do
	--for k,v in pairs(self.data.data) do
		k = currentCycle
		v = self.data.data[currentCycle]
	
		if (v) then
			s = AAV_Util:split(v, ',')
			id = tonumber(s[3])
			event = tonumber(s[2])
			
			--resetcc(cc)
			if (not self.index[id]) then self.index[id] = {} end
			
			-- index only hp related events
			if (event == 1 or event == 2) then
				if (not self.index[id][k]) then self.index[id][k] = {} end -- c = tick
				self.index[id][k][event] = tonumber(s[4]) -- s[2] = event, s[4] = value
			
			elseif (event == 0) then
				if (not self.calc.buff[id]) then self.calc.buff[id] = {} end
				local bf = AAV_Util:split(s[6], ";")
				if (bf) then
					self.calc.buff[id] = {}
					table.foreach(bf, function(a,b) table.insert(self.calc.buff[id], tonumber(b)) end)
				end
				
				if (not self.calc.debuff[id]) then self.calc.debuff[id] = {} end
				local df = AAV_Util:split(s[7], ";")
				if (df) then
					self.calc.debuff[id] = {}
					table.foreach(df, function(a,b) table.insert(self.calc.debuff[id], tonumber(b)) end)
				end
			
			elseif (event == 10) then
				if (not self.calc.cd[id]) then self.calc.cd[id] = {} end
				if (tonumber(s[6]) and AAV_CCSKILS[tonumber(s[5])]) then
					self.calc.cd[id][tonumber(s[5])] = AAV_CCSKILS[tonumber(s[5])]
				end
				
			elseif (event == 13) then
			
				-- buff
				if (tonumber(s[5]) == 1) then
					if (not self.calc.buff[id]) then self.calc.buff[id] = {} end
					table.insert(self.calc.buff[id], tonumber(s[4]))
					
				-- debuff
				elseif (tonumber(s[5]) == 2) then
					if (not self.calc.debuff[id]) then self.calc.debuff[id] = {} end
					table.insert(self.calc.debuff[id], tonumber(s[4]))
				end
				
				if ((tonumber(s[5]) == 1 or tonumber(s[5]) == 2) and tonumber(s[6]) > 0) then
					if (not self.calc.cc[id]) then self.calc.cc[id] = {} end
					self.calc.cc[id][tonumber(s[4])] = tonumber(s[6])
				end
			elseif (event == 14) then
			
				-- buff
				if (tonumber(s[5]) == 1 and self.calc.buff[id]) then
					for c,w in pairs(self.calc.buff[id]) do
						if (tonumber(s[4]) == w) then
							table.remove(self.calc.buff[id], c)
							break
						end
					end
					
				-- debuff
				elseif (tonumber(s[5]) == 2 and self.calc.debuff[id]) then
					for c,w in pairs(self.calc.debuff[id]) do
						if (tonumber(s[4]) == w) then
							table.remove(self.calc.debuff[id], c)
							break
						end
					end
				end
				
				if ((tonumber(s[5]) == 1 or tonumber(s[5]) == 2) and self.calc.cc[id]) then
					if (self.calc.cc[id] and self.calc.cc[id][tonumber(s[4])]) then
						self.calc.cc[id][tonumber(s[4])] = nil
					end
				end
				
				
			elseif (event == 17) then
				-- mana
				if (not self.index[id][k]) then self.index[id][k] = {} end -- c = tick
				self.index[id][k][event] = tonumber(s[4]) -- s[2] = event, s[4] = value
			end
			
			-- save to index
			if (k % AAV_AURAFULLINDEXSTEP == 0) then
				
				if (not self.index[id][k]) then 
					self.index[id][k] = {} 
				end
				
				if (self.calc.buff[id] and #self.calc.buff[id] > 0) then 
					self.index[id][k]["buff"] = table.concat(self.calc.buff[id], ',')
				end
				
				if (self.calc.debuff[id] and #self.calc.debuff[id] > 0) then
					self.index[id][k]["debuff"] = table.concat(self.calc.debuff[id], ',')
				end
				
				if (self.calc.cc[id]) then
					local concatcc = ""
					for c,w in pairs(self.calc.cc[id]) do
						concatcc = concatcc .. c .. ":" .. w .. ","
					end
					self.index[id][k]["cc"] = concatcc
					
				end
				
				if (self.calc.cd[id]) then
					local concatcd = ""
					for c,w in pairs(self.calc.cd[id]) do
						concatcd = concatcd .. c .. ":" .. w .. ","
					end
					self.index[id][k]["cd"] = concatcd
					
				end
				
				
			end
				
			for c,w in pairs(self.calc.cc) do
				if (w) then
					for d,x in pairs(w) do
						local t = x - (tonumber(s[1])-lastticktime)
						self.calc.cc[c][d] = tonumber(math.floor(t * 10)/10)
					end
				end
			end
			
			for c,w in pairs(self.calc.cd) do
				if (w) then
					for d,x in pairs(w) do
						self.calc.cd[c][d] = x - (tonumber(s[1])-lastticktime)
					end
				end
			end
			
			lastticktime = tonumber(s[1])
			
		end
	
		currentCycle = currentCycle + 1
	
	end
	
	if (not self.data.data[currentCycle]) then
		self:handleIndexCreation("stop")
		self.player:Show()
	end
	
	self.loading:SetValue((currentCycle / #self.data.data) * 100)

end
	


----
-- returns the last happened value of a passed event.
-- @param tick from what match tick time
-- @param playerid id of target player
-- @param type typeid of wanted event information
-- @return last happened value of passed event
function AAV_PlayStub:getIndexValue(tick, playerid, type)
	local value, i
	
	if (self.index[playerid]) then
		for i = tick, 0, -1 do
			if (self.index[playerid][i] and self.index[playerid][i][type]) then
				value = self.index[playerid][i][type]
				break
			end
		end
	end
	return value
end
