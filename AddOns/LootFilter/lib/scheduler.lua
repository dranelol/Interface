local schedStack = {};
local ScheduleFrame = CreateFrame("Frame", "LootFilterScheduleFrame");
local Schedule = nil; -- Handle to scheduler coroutine

function LootFilter.schedule(delay, func, ...)
	if type(func) ~= "function" and type(func) ~= "string" then
		error("LootFilter.schedule: expected function or string as 2nd parameter, recieved `" .. type(func) .. "`");
	end
	table.insert(schedStack, {Time = (GetTime() + delay), Func = func, Args = {...}});
	table.sort(schedStack, function(a, b) -- Ensure the stack is properly sorted
		return a.Time < b.Time;
	end);
end

local function Scheduler(errorHandler)
--	seterrorhandler(errorHandler()); -- Use the parent's error handler
	local addon = LootFilter; -- Bind to a local variable to reduce lookup times
	local StartTime, MaxTime = 0, .005; -- Started current object, amount of time per frame to spend processing events
	local function Yield(force)
		if force or (StartTime + MaxTime) > GetTime() then
			coroutine.yield();
		end
	end
	local stack = schedStack;
	local event = nil;
	Yield(true); -- Force a yield after setting up the scheduler
	while true do
		StartTime = GetTime();
		stack = schedStack; -- Make sure we have the correct stack
		if table.getn(stack) > 0 then
			event = stack[1];
			if event.Time < StartTime then
				if type(event.Func) == "function" then
					event.Func(unpack(event.Args));
				elseif type(event.Func) == "string" then
					addon[event.Func](unpack(event.Args));
				end
				table.remove(stack, 1);
			end
			Yield();
		else
			Yield(true);
		end
	end
end

function OnUpdate(...)
	if not Schedule then
		Schedule = coroutine.wrap(Scheduler);
	end
	xpcall(Schedule, geterrorhandler())
--[[	if not good then -- An error occured in the scheduler coroutine. Call default error handler
		error("LootFilter: Error in Schedule coroutine: " .. msg, 2);
	end --]]
end

ScheduleFrame:SetScript("OnUpdate", OnUpdate);