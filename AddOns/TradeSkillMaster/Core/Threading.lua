-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains code for running stuff in a pseudo-thread

local TSM = select(2, ...)
local private = {threads={}, context=nil}
TSMAPI:RegisterForTracing(private, "TradeSkillMaster.Threading_private")
TSMAPI.Threading = {}
local THREAD_STATUS_ENUM = {
	READY = {str="READY"},
	SLEEPING = {str="SLEEPING"},
	WAITING_FOR_MSG = {str="WAITING_FOR_MSG"},
	RUNNING = {str="RUNNING"},
	DONE = {str="DONE"},
	DEAD = {str="DEAD"},
	KILLED = {str="KILLED"},
}
local VALID_THREAD_STATUSES = {
	[THREAD_STATUS_ENUM.READY] = true,
	[THREAD_STATUS_ENUM.SLEEPING] = true,
	[THREAD_STATUS_ENUM.WAITING_FOR_MSG] = true,
	[THREAD_STATUS_ENUM.RUNNING] = true,
	[THREAD_STATUS_ENUM.DONE] = false,
	[THREAD_STATUS_ENUM.DEAD] = false,
	[THREAD_STATUS_ENUM.KILLED] = false,
}
local SCHEDULER_CONTEXT = {}
local MAX_QUANTUM_MS = 50
local RETURN_VALUE = {}



local ThreadPrototype = {
	GetThreadId = function(self)
		assert(private.context == self, "Attempted to get threadId from outside thread context.")
		for threadId, thread in pairs(private.threads) do
			if thread == self then
				return threadId
			end
		end
		assert(false, "Well this is bad. We couldn't find the threadId!")
	end,
	
	Yield = function(self, force)
		assert(private.context == self, "Attempted to yield from outside thread context.")
		if force or self._status ~= THREAD_STATUS_ENUM.RUNNING or debugprofilestop() > self._endTime then
			-- only change the status if it's currently set to RUNNING
			if self._status == THREAD_STATUS_ENUM.RUNNING then
				self._status = THREAD_STATUS_ENUM.READY
			end
			coroutine.yield(RETURN_VALUE)
		end
		assert(self._status == THREAD_STATUS_ENUM.RUNNING)
	end,
	
	Sleep = function(self, seconds)
		assert(private.context == self, "Attempted to sleep from outside thread context.")
		self._status = THREAD_STATUS_ENUM.SLEEPING
		self._sleeping = seconds
		self:Yield()
	end,
	
	ReceiveMsg = function(self)
		assert(private.context == self, "Attempted to ReceiveMsg from outside thread context.")
		if #self._messages == 0 then
			-- Yield if there's no messages pending
			self._status = THREAD_STATUS_ENUM.WAITING_FOR_MSG
			self:Yield()
		end
		assert(#self._messages > 0)
		return tremove(self._messages, 1)
	end,
}


function private:SafeAssert(cond, err)
	if not cond then
		TSMAPI:CreateTimeDelay(0, function() assert(cond, err) end)
	end
end

function private.RunScheduler(_, elapsed)
	-- deal with sleeping threads and try and assign requested quantums
	private.context = SCHEDULER_CONTEXT
	local totalTime = min(elapsed * 1000, MAX_QUANTUM_MS)
	local usedTime = 0
	for _, thread in pairs(private.threads) do
		assert(thread._status)
		-- check what the thread status is
		if thread._status == THREAD_STATUS_ENUM.SLEEPING then
			thread._sleeping = thread._sleeping - elapsed
			if thread._sleeping <= 0 then
				thread._sleeping = nil
				thread._status = THREAD_STATUS_ENUM.READY
			end
		elseif thread._status == THREAD_STATUS_ENUM.WAITING_FOR_MSG then
			if #thread._messages > 0 then
				thread._status = THREAD_STATUS_ENUM.READY
			end
		elseif thread._status ~= THREAD_STATUS_ENUM.KILLED then
			-- if not waiting for a message or sleeping, it should be ready
			private:SafeAssert(thread._status == THREAD_STATUS_ENUM.READY, "Thread in invalid state.")
		end
		
		-- if it's ready to run, assign it a quantum
		if thread._status == THREAD_STATUS_ENUM.READY then
			thread._quantum = thread._percent * totalTime
		else
			thread._quantum = 0
		end
		usedTime = usedTime + thread._quantum
	end
	
	-- scale everything down if the total is > the total time
	if usedTime > totalTime then
		for _, thread in pairs(private.threads) do
			thread._quantum = thread._quantum * (totalTime / usedTime)
		end
	end
	
	-- run the threads that are ready
	local deadThreads = {}
	for threadId, thread in pairs(private.threads) do
		if thread._status == THREAD_STATUS_ENUM.READY then
			-- resume running thread for its given quantum
			thread._endTime = debugprofilestop() + thread._quantum
			thread._status = THREAD_STATUS_ENUM.RUNNING
			private.context = thread
			local noErr, returnVal = coroutine.resume(thread._co, thread)
			private.context = SCHEDULER_CONTEXT
			if noErr then
				-- check the returnVal
				private:SafeAssert(returnVal == RETURN_VALUE, "Illegal yield.")
			else
				private:SafeAssert(false, returnVal)
				thread._status = THREAD_STATUS_ENUM.DEAD
			end
			if not TSMAPI.Threading:IsValid(threadId) then
				tinsert(deadThreads, threadId)
			end
		end
	end
	
	-- remove dead threads and call their callback if necessary
	for _, threadId in ipairs(deadThreads) do
		local thread = private.threads[threadId]
		private.threads[threadId] = nil
		if thread._callback and thread._status == THREAD_STATUS_ENUM.DONE then thread._callback() end
	end
	private.context = nil
end

function private:GetNewThreadFunction(func)
	local function ThreadFunctionWrapper(self)
		func(self, self._param)
		self._status = THREAD_STATUS_ENUM.DONE
		return RETURN_VALUE
	end
	return ThreadFunctionWrapper
end

function TSMAPI.Threading:Start(func, percent, callback, param)
	assert(func and percent, "Missing required parameter")
	assert(percent <= 1 and percent > 0, "Percentage must be > 0 and <= 1")
	
	local thread = CopyTable(ThreadPrototype)
	thread._co = coroutine.create(private:GetNewThreadFunction(func))
	thread._percent = percent
	thread._callback = callback
	thread._param = param
	
	-- set default thread variables
	thread._nextMsgId = 1
	thread._quantum = 0
	thread._sleeping = nil
	thread._messages = {}
	thread._status = THREAD_STATUS_ENUM.READY
	
	local threadId = {} -- use table references as unique threadIds
	private.threads[threadId] = thread
	return threadId
end

function TSMAPI.Threading:SendMessage(threadId, data)
	assert(TSMAPI.Threading:IsValid(threadId), "No thread with the given threadId exists.")
	tinsert(private.threads[threadId]._messages, data)
end

function TSMAPI.Threading:Kill(threadId)
	assert(TSMAPI.Threading:IsValid(threadId), "No thread with the given threadId exists.")
	private.threads[threadId]._status = THREAD_STATUS_ENUM.KILLED
end

function TSMAPI.Threading:IsValid(threadId)
	return private.threads[threadId] and VALID_THREAD_STATUSES[private.threads[threadId]._status]
end

do
	local frame = CreateFrame("Frame")
	frame:SetScript("OnUpdate", private.RunScheduler)
end

-- -- EXAMPLE USAGE:

-- local function TestRecv(self, letter)
	-- while true do
		-- local data = self:ReceiveMsg()
		-- print(format("[TestRecv] Got Message \"%s\" after %fms", data.msg, debugprofilestop()-data.sendTime))
	-- end
-- end

-- local function TestSend(self, recvThreadId)
	-- TSMAPI.Threading:SendMessage(recvThreadId, {msg="MSG 1 SENT AT ", sendTime=debugprofilestop()})
	-- self:Sleep(5)
	-- TSMAPI.Threading:SendMessage(recvThreadId, {msg="MSG 2 SENT AT ", sendTime=debugprofilestop()})
	-- self:Sleep(1)
	-- TSMAPI.Threading:Kill(recvThreadId)
	-- assert(not TSMAPI.Threading:IsValid(recvThreadId))
-- end

-- function TSMThreadingTest()
	-- print("TSMTest() START")
	-- local start = debugprofilestop()
	
	-- -- start receiver thread
	-- local recvThreadId = TSMAPI.Threading:Start(TestRecv, 1)
	-- -- start sender thread
	-- TSMAPI.Threading:Start(TestSend, 1, function() print("SENDER DONE", debugprofilestop()-start) end, recvThreadId)
	-- -- send a message to the receiver
	-- TSMAPI.Threading:SendMessage(recvThreadId, {msg="MSG 0 SENT AT ", sendTime=debugprofilestop()})
	
	-- print("TSMTest() END", debugprofilestop()-start)
-- end

-- function TSMThreadingDump()
	-- local temp = CopyTable(private.threads)
	-- for _, data in pairs(temp) do
		-- data._co = nil
		-- data._status = data._status and data._status.str or "UNKNOWN"
	-- end
	-- TSMAPI.Debug:DumpTable(temp)
-- end