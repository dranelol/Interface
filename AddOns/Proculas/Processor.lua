--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Korvo on US Proudmoore
--  - Idunnô, Clorell, Mcstabin on US Hellscream
--

local LSM = LibStub("LibSharedMedia-3.0")

-------------------------------------------------------
-- Proc processor.
-- Handles posting and updating stats of procs.

function Proculas:postProc(spellID)
	local procInfo = self.optpc.tracked[spellID]
	--local procData = self.optpc.procs[procInfo.name..procInfo.rank]
	local procData = self.optpc.procs[procInfo.procId]

	-- Sink
	local pourBefore = ""
	if(self.opt.sinkOptions.sink20OutputSink == "Channel") then
		pourBefore = "[Proculas]: "
	end
	if procData.postProc or (self.opt.postProcs and (procData.postProc ~= false or procData.postProc == nil)) then
		local procMessage
		if procData.customMessage then
			procMessage = procData.message
		else
			procMessage = self.opt.announce.message
		end
		local color = nil
		if not procData.color then
			color = self.opt.announce.color
		else
			color = procData.color
		end
		self:Pour(pourBefore..procMessage:format(procData.name),color.r,color.g,color.b);
	end
end

function Proculas:processProc(spellID,isAura)
	local procInfo = self.optpc.tracked[spellID]
	--local procData = self.optpc.procs[procInfo.name..procInfo.rank]
	local procData = self.optpc.procs[procInfo.procId]

	if isAura then
		self.active[procInfo.procId] = spellID
	end

	self:debug("Processing proc: "..procInfo.name)

	-- Post Proc
	self:postProc(spellID)

	-- Check Cooldown
	if procData.updateCD and procData.lastProc > 0 and ((procData.cooldown == 0) or (time() - procData.lastProc < procData.cooldown)) then
		local proccd = time() - procData.lastProc
		if(proccd == 0) then
			procData.zeroCD = true
		end
		if(procData.zeroCD) then
			procData.cooldown = 0
		else
			procData.cooldown = time() - procData.lastProc
		end
	end

	-- Uptime Calculation
	if isAura and procData.started == 0 then
			procData.started = time()
			self.active[procInfo.procId] = spellID
	end

	-- Reset cooldown bar
	if (procData.cooldown or (self.opt.cooldowns.cooldowns and (procData.cooldown ~= false or procData.cooldown == nil))) and procData.cooldown > 0 then
		local bar = self.procCooldowns:GetBar(procData.name..procData.rank)
		if not bar then
			bar = self.procCooldowns:NewTimerBar(procData.name..procData.rank, procData.name, procData.cooldown, procData.cooldown, procData.icon, self.opt.cooldowns.flashTimer)
		end
		bar:SetTimer(procData.cooldown, procData.cooldown)
	end

	-- Sound
	if procData.soundFile ~= nil then
		PlaySoundFile(LSM:Fetch("sound", procData.soundFile), "Master")
	elseif self.opt.sound.soundFile and self.opt.sound.playSound then
		PlaySoundFile(LSM:Fetch("sound", self.opt.sound.soundFile), "Master")
	end

	-- Flash Screen
	if procData.flash or (self.opt.effects.flash and (procData.flash ~= false or procData.flash == nil)) then
		self:Flash()
	end

	-- Shake Screen
	if procData.shake or (self.opt.effects.shake and (procData.shake ~= false or procData.shake == nil)) then
		--self:Shake()
	end

	-- Count
	procData.count = procData.count+1
	procData.lastProc = time()
end
