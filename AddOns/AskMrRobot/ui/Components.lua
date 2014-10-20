local _, AskMrRobot = ...

local unresolvedItemIds = {}

-- Create a new class that inherits from a base class
function AskMrRobot.inheritsFrom( baseClass )

    -- The following lines are equivalent to the SimpleClass example:

    -- Create the table and metatable representing the class.
    local new_class = { }

    -- Note that this function uses class_mt as an upvalue, so every instance
    -- of the class will share the same metatable.
    --
  --   function new_class:create(o)
  --   	o = o or {}
		-- setmetatable( o, class_mt )
		-- return o
  --    end

    -- The following is the key to implementing inheritance:

    -- The __index member of the new class's metatable references the
    -- base class.  This implies that all methods of the base class will
    -- be exposed to the sub-class, and that the sub-class can override
    -- any of these methods.
    --
    if baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    return new_class
end

local itemInfoFrame = nil;

local function onGetItemInfoReceived(arg1, arg2, arg3)
	-- since wow is awesome, it doesn't tell us *which* item id was just resolved, so we have to look at them all
	for itemId, callbacks in pairs(unresolvedItemIds) do
		-- attempt to get the item info AGAIN
		local a, b, c, d, e, f, g, h, i, j, k = GetItemInfo(itemId)
		-- if we got item info...
		if a then
			-- remove the callbacks from the list
			unresolvedItemIds[itemId] = nil

			-- call each callback
			for i = 1, #callbacks do
				callbacks[i](a, b, c, d, e, f, g, h, i, j, k)
			end
		end
	end
end


function AskMrRobot.RegisterItemInfoCallback(itemId, callback)
	if not itemId then
		return
	end

	if not itemInfoFrame then
	    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
	    waitFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	    waitFrame:SetScript("OnEvent", onGetItemInfoReceived);
	end


	-- get the list of registered callbacks for this particular item
	local list = unresolvedItemIds[itemId]
	-- if there was a list, then just add the callback to the list
	if list then
		tinsert(list, callback)
	else
		-- there wasn't a list, so make a new one with this callback
		unresolvedItemIds[itemId] = { callback }
	end
end


-- initialize the Frame class (inherit from a dummy frame)
AskMrRobot.Frame = AskMrRobot.inheritsFrom(CreateFrame("Frame"))

-- Frame contructor
function AskMrRobot.Frame:new(name, parentFrame, inheritsFrame)
	-- create a new frame (if one isn't supplied)
	local o = CreateFrame("Frame", name, parentFrame, inheritsFrame)

	-- use the Frame class
	setmetatable(o, { __index = AskMrRobot.Frame })

	-- return the instance of the Frame
	return o
end
