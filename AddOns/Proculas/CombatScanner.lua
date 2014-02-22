--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Korvo on US Proudmoore
--  - Idunnô, Clorell, Mcstabin on US Hellscream
--

-------------------------------------------------------
-- The Proc scanner, scans the combat log for proc spells
-- This sweet little Proc Tracker here is Copyright (c) Xocide

local untrackedTypes = {
	SPELL_AURA_REMOVED = true,
}

function Proculas:COMBAT_LOG_EVENT_UNFILTERED(event,...)
	--local msg,type,msg2,name,msg3,msg4,name2 = select(1, ...)
	--local spellId, spellName, spellSchool = select(9, ...)
  --    timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool = select(1, ...)
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = select(1, ...) --, missType, amountMissed
	if not hideCaster then
		hideCaster = nil
	end

	-- Check if the type is SPELL_AURA_APPLIED
	local isaura = false
	if(event == "SPELL_AURA_APPLIED") then
		isaura = true
	end

	if self.optpc.tracked[spellId] and untrackedTypes[event] == nil then
		-- Fetch procInfo
		local procInfo = self.optpc.tracked[spellId]
		local procData = self.optpc.procs[procInfo.procId]

		self:debug("Tracked proc found: "..procInfo.name)
		self:debug("Event not in untracked list ("..event..")")

		if sourceName == playerName
		or (sourceName ~= nil and sourceName == UNKNOWN and destName == playerName)
		or (sourceName == nil and destName ~= nil and destName == playerName) then
			self:debug("Event is related to player ("..playerName..")")
			if (procInfo.onSelfOnly == 0 or procInfo.onSelfOnly == false) then
				self:debug("Sending tracked proc to processProc(): "..procInfo.name)
				self:processProc(spellId,isaura)
			elseif(procInfo.onSelfOnly and destName == playerName) then
				self:debug("Sending tracked proc to processProc(): "..procInfo.name)
				self:processProc(spellId,isaura)
			end
		end
	end

	-- Aura Removed/Expired
	if self.optpc.tracked[spellId] and event == "SPELL_AURA_REMOVED" then
		local procInfo = self.optpc.tracked[spellId]
		if sourceName == playerName and self.active[procInfo.procId] then
			local procData = self.optpc.procs[procInfo.procId]
			for index,spID in pairs(self.active) do
				procData.started = 0
				self.active[procInfo.procId] = nil
			end
		end
	end
end
