
local o;
do
	local VERSION = 20000;
	o = (EventsManager2 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		EventsManager2 = o;
		o.OLD_VERSION = o.VERSION;
		o.VERSION = VERSION;
	else
		return;
	end
end

-- GetVersion: minor, subminor = ()
--
-- DispatchEvent: (frame, event, ...)
-- DispatchCustomEvent: (event, ...)
--
-- IsCustomEventAvailable: isAvailable, oneTimeOnly = (event)
-- AddCustomEvent: (event, oneTimeOnly)
-- RemoveCustomEvent: (event)
--
-- RegisterForEvent: (funcObj[, funcKey], event[, sendFuncObj][, sendEvent])
-- IsRegisteredForEvent: isRegistered, funcKey, sendFuncObj, sendEvent = (funcObj, event)
-- UnregisterForEvent: (funcObj, event)
-- UnregisterForAllEvents: (funcObj)
--
-- IsDefaultEvent: isDefaultEvent = (event)
-- OnEvent_VARIABLES_LOADED: ()
-- OnEvent_PLAYER_LOGIN: ()

o.customEvents = (
	o.customEvents
	or {
		-- [event] = isOnceOnly;
		["EventsManager2_CUSTOM_EVENT_ADDED"] = false;
		["EventsManager2_CUSTOM_EVENT_REMOVED"] = false;
	}
);
-- [event] = { [funcObj] = handlerData; };
o.handlersByEvent = (o.handlersByEvent or {});
-- [event] = true/nil;
o.dispatching = (o.dispatching or {});
-- [event] = { [funcObj] = handlerData; };
o.toBeAdded = (o.toBeAdded or {});




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




do
	local pairs = pairs;
	local pcall = pcall;
	local stringmatch = string.match;
	
	-- frame is NEVER USED. It is here so that the OnEvent can call this function directly without a wasteful wrapper.
	function o.DispatchEvent(frame, event, ...)
		local handlers = o.handlersByEvent[event];
		if (handlers ~= nil) then
			o.dispatching[event] = true;
			
			local defaultFuncKey;
			local handlerType, funcKey, func;
			local success, errorText;
			for funcObj, handlerData in pairs(handlers) do
				if (#handlerData < 2) then
					-- Must be just a handlerType, no funcKey.
					handlerType = handlerData;
					func = funcObj;
				else
					handlerType, funcKey = stringmatch(handlerData, "^([\1\2\3]?)(.+)$");
					if (funcKey ~= "\4\4") then
						func = funcObj[funcKey];
					else
						if (defaultFuncKey == nil) then
							defaultFuncKey = ("OnEvent_" .. event);
						end
						func = funcObj[defaultFuncKey];
					end
				end
				if (handlerType == "") then
					success, errorText = pcall(func, ...);
				elseif (handlerType == "\1") then
					success, errorText = pcall(func, funcObj, ...);
				elseif (handlerType == "\2") then
					success, errorText = pcall(func, event, ...);
				else
					success, errorText = pcall(func, funcObj, event, ...);
				end
				if (success == false) then
					geterrorhandler()(("EventsManager2: Error during dispatch of event %s: %s"):format(event, errorText));
				end
			end
			
			o.dispatching[event] = nil;
			
			if (o.toBeAdded[event] ~= nil) then
				for funcObj, handlerData in pairs(o.toBeAdded[event]) do
					handlers[funcObj] = handlerData;
				end
				o.toBeAdded[event] = nil;
				-- Remember that if the last handler in the list unregistered itself as a result of the callback,
				-- then UnregisterForEvent() has nil'd o.handlersByEvent[event]. Set it again to be safe.
				o.handlersByEvent[event] = handlers;
			end
		end
	end
end

(EventsManager2_ScriptsFrame or CreateFrame("Frame", "EventsManager2_ScriptsFrame", WorldFrame, nil)):SetScript("OnEvent", o.DispatchEvent);


function o.DispatchCustomEvent(event, ...)
	local isOnceOnly = o.customEvents[event];
	if (isOnceOnly ~= nil) then
		o.DispatchEvent(nil, event, ...);
		if (isOnceOnly == true) then
			o.RemoveCustomEvent(event);
		end
	else
		error(("EventsManager2.DispatchCustomEvent: Unknown custom event name, \"%s\""):format(event), 2);
	end
end




function o.IsCustomEventAvailable(event)
	if (type(event) ~= "string") then
		error(("EventsManager2.IsCustomEventAvailable: Bad argument #1; expected string, received %s."):format(type(event)), 2);
	end
	if (o.IsDefaultEvent(event) == true) then
		error(("EventsManager2.IsCustomEventAvailable: %s is a default event."):format(event), 2);
	end
	
	local onceOnly = o.customEvents[event];
	return (onceOnly ~= nil), onceOnly;
end



function o.AddCustomEvent(event, isOnceOnly)
	if (type(event) ~= "string") then
		error(("EventsManager2.AddCustomEvent: Bad argument #1; expected string, received %s."):format(type(event)), 2);
	end
	if (o.IsDefaultEvent(event) == true) then
		error(("EventsManager2.AddCustomEvent: Cannot add a default event, %s, as a custom event."):format(event), 2);
	end
	isOnceOnly = ((isOnceOnly and true) or false);
	
	local existing = o.customEvents[event];
	if (existing ~= nil) then
		if (existing ~= isOnceOnly) then
			error(("EventsManager2.AddCustomEvent: Custom event named %s already exists."):format(event), 2);
		end
	else
		o.customEvents[event] = isOnceOnly;
		o.DispatchCustomEvent("EventsManager2_CUSTOM_EVENT_ADDED", event, isOnceOnly);
	end
end



function o.RemoveCustomEvent(event)
	if (type(event) ~= "string") then
		error(("EventsManager2.RemoveCustomEvent: Bad argument #1; expected string, received %s."):format(type(event)), 2);
	end
	if (event == "EventsManager2_CUSTOM_EVENT_ADDED" or event == "EventsManager2_CUSTOM_EVENT_REMOVED") then
		error(("EventsManager2.RemoveCustomEvent: Custom event \"%s\" cannot be removed."):format(event), 2);
	end
	
	local isOnceOnly = o.customEvents[event];
	if (isOnceOnly ~= nil) then
		o.customEvents[event] = nil;
		if (o.handlersByEvent[event] ~= nil) then
			for funcObj in pairs(o.handlersByEvent[event]) do
				o.UnregisterForEvent(funcObj, event);
			end
			o.handlersByEvent[event] = nil;
		end
		o.DispatchCustomEvent("EventsManager2_CUSTOM_EVENT_REMOVED", event, isOnceOnly);
	end
end




function o.RegisterForEvent(funcObj, funcKey, event, sendFuncObj, sendEvent)
	if (type(funcObj) ~= "table" and type(funcObj) ~= "function") then
		error(("EventsManager2.RegisterForEvent: Bad argument #1; expected table or function, received %s."):format(type(funcObj)), 2);
	end
	if (type(event) ~= "string") then
		error(("EventsManager2.RegisterForEvent: Bad argument #3; expected string, received %s."):format(type(event)), 2);
	end
	
	local isDefaultEvent = o.IsDefaultEvent(event);
	if (isDefaultEvent == false and o.customEvents[event] == nil) then
		error(("EventsManager2.RegisterForEvent: Unknown event name: %s."):format(tostring(event)), 2);
	end
	
	sendFuncObj = ((sendFuncObj and true) or false);
	sendEvent = ((sendEvent and true) or false);
	local handlerType;
	if (sendFuncObj == false) then
		if (sendEvent == false) then
			handlerType = ("");
		else
			handlerType = ("\2");
		end
	else
		if (sendEvent == false) then
			handlerType = ("\1");
		else
			handlerType = ("\3");
		end
	end
	
	if (type(funcObj) == "function") then
		if (funcKey == nil) then
			funcKey = ("");
		end
	else
		if (funcKey == nil or funcKey == ("OnEvent_" .. event)) then
			-- Use the default funcKey, "OnEvent_<event>". This needs to be two bytes so that the check during dispatch identifies it properly.
			funcKey = ("\4\4");
		end
	end
	if (type(funcKey) ~= "string") then
		error(("EventsManager2.RegisterForDelay: Invalid funcKey, %s; must be a string if not nil."):format(tostring(funcKey)), 2);
	end
	
	local handlersForEvent = o.handlersByEvent[event];
	if (handlersForEvent == nil) then
		handlersForEvent = {};
		o.handlersByEvent[event] = handlersForEvent;
		if (isDefaultEvent == true) then
			EventsManager2_ScriptsFrame:RegisterEvent(event);
		end
	end
	local toBeAddedForEvent = o.toBeAdded[event];
	
	local handlerData = (handlerType .. funcKey);
	if (
		(handlersForEvent[funcObj] ~= nil and handlersForEvent[funcObj] ~= handlerData)
		or (toBeAddedForEvent ~= nil and toBeAddedForEvent[funcObj] ~= nil and toBeAddedForEvent[funcObj] ~= handlerData)
	) then
		error(("EventsManager2.RegisterForDelay: Event %s trying to be registered for handlerData %s is already registered to a different handlerData, %s."):format(
			event, handlerData, handlersForEvent[funcObj]
		), 2);
	end
	
	if (o.dispatching[event] ~= true) then
		handlersForEvent[funcObj] = handlerData;
	else
		if (toBeAddedForEvent == nil) then
			toBeAddedForEvent = {};
			o.toBeAdded[event] = toBeAddedForEvent;
		end
		toBeAddedForEvent[funcObj] = handlerData;
	end
end



function o.IsRegisteredForEvent(funcObj, event)
	local handlerData = (
		(o.handlersByEvent[event] ~= nil and o.handlersByEvent[event][funcObj])
		or (o.toBeAdded[event] ~= nil and o.toBeAdded[event][funcObj])
	);
	local funcKey, sendFuncObj, sendEvent;
	if (handlerData ~= nil) then
		local handlerType, funcKey = handlerData:match("^([\1-\3]?)(.*)$");
		if (funcKey == "") then
			funcKey = nil;
		elseif (funcKey == "\4\4") then
			funcKey = ("OnEvent_" .. event);
		end
		if (handlerType == "") then
			sendFuncObj, sendEvent = false, false;
		elseif (handlerType == "\1") then
			sendFuncObj, sendEvent = true, false;
		elseif (handlerType == "\2") then
			sendFuncObj, sendEvent = false, true;
		elseif (handlerType == "\3") then
			sendFuncObj, sendEvent = true, true;
		end
	end
	return (handlerData ~= nil), funcKey, sendFuncObj, sendEvent;
end



function o.UnregisterForEvent(funcObj, event)
	if (type(funcObj) ~= "table" and type(funcObj) ~= "function") then
		error(("EventsManager2.UnregisterForEvent: Bad argument #1; expected table or function, received %s."):format(type(funcObj)), 2);
	end
	if (type(event) ~= "string") then
		error(("EventsManager2.UnregisterForEvent: Bad argument #2; expected string, received %s."):format(type(event)), 2);
	end
	
	local isDefaultEvent = o.IsDefaultEvent(event);
	if (isDefaultEvent == false and o.customEvents[event] == nil) then
		error(("EventsManager2.UnregisterForEvent: Unknown event name: %s."):format(tostring(event)), 2);
	end
	
	local handlersForEvent = o.handlersByEvent[event];
	if (handlersForEvent ~= nil) then
		handlersForEvent[funcObj] = nil;
		if (next(handlersForEvent) == nil) then
			o.handlersByEvent[event] = nil;
			if (isDefaultEvent == true) then
				EventsManager2_ScriptsFrame:UnregisterEvent(event);
			end
		end
	end
end


function o.UnregisterForAllEvents(funcObj)
	if (type(funcObj) ~= "table" and type(funcObj) ~= "function") then
		error(("EventsManager2.UnregisterForAllEvents: Bad argument #1; expected table or function, received %s."):format(type(funcObj)), 2);
	end
	
	for event, handlers in pairs(o.handlersByEvent) do
		if (handlers[funcObj] ~= nil) then
			o.UnregisterForEvent(funcObj, event);
		end
	end
end




function o.IsDefaultEvent(event)
	local frame = EventsManager2_ScriptsFrame;
	local isDefaultEvent = false;
	if (frame:IsEventRegistered(event) ~= nil) then
		isDefaultEvent = true;
	else
		-- Hack: Try to register the event with the scripts frame. If it takes, then the event has to be a default event, because only those will stick.
		frame:RegisterEvent(event);
		if (frame:IsEventRegistered(event) ~= nil) then
			isDefaultEvent = true;
			frame:UnregisterEvent(event);
		end
	end
	return isDefaultEvent;
end



-- Need to watch these two events so we can unregister their callbacks after login.
-- Nilling them during dispatch will not harm anything.
if (IsLoggedIn() == nil) then
	function o.OnEvent_VARIABLES_LOADED()
		o.OnEvent_VARIABLES_LOADED = nil;
		o.handlersByEvent["VARIABLES_LOADED"] = nil;
	end
	o.RegisterForEvent(o, nil, "VARIABLES_LOADED", false, false);
	
	function o.OnEvent_PLAYER_LOGIN()
		o.OnEvent_PLAYER_LOGIN = nil;
		o.handlersByEvent["PLAYER_LOGIN"] = nil;
	end
	o.RegisterForEvent(o, nil, "PLAYER_LOGIN", false, false);
else
	o.OnEvent_VARIABLES_LOADED = nil;
	o.UnregisterForEvent(o, "VARIABLES_LOADED");
	o.OnEvent_PLAYER_LOGIN = nil;
	o.UnregisterForEvent(o, "PLAYER_LOGIN");
end
