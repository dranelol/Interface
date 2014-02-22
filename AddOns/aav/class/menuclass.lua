MenuClass = {}
MenuClass.__index = MenuClass;

function MenuClass:New()
    local ret = {}
    
    -- set the defaults
    ret.menuItems = {};
    ret.anchor = 'cursor'; -- default at the cursor
    ret.x = nil;
    ret.y = nil;
    ret.displayMode = 'MENU'; -- default
    ret.autoHideDelay = nil;
    ret.menuFrame = nil; -- If not defined, :Show() will create a generic menu frame
    ret.uniqueID = 1

    -- import the functions
    for k,v in pairs(self) do
        ret[k] = v
    end
    
    -- return a copy of the class
    return ret
end

--[[
    Add menu items
    ; text : The display text.
    ; func : The function to execute OnClick.
    ; isTitle : 1 if this is a header (usually the first one)
--]]
function MenuClass:AddItem(text, func, isTitle)
    table.insert(self.menuItems, {
        ["text"] = text,
        ["func"] = func,
        ["isTitle"] = isTitle,
    })
end

--[[
    Remove the first item matching "text"
    ; text : The text to search for.
--]]
function MenuClass:RemoveItem(text)
    for k,v in pairs(self.menuItems) do
        if v.text == text then
            table.remove(self.menuItems, k)
            return
        end
    end
end

--[[
    ; anchor : Set the anchor point. 
--]]
function MenuClass:SetAnchor(anchor)
    if anchor ~= 'cursor' then
        self.x = 0
        self.y = 0
    end
    self.anchor = anchor
end

--[[
    ; displayMode : "MENU"
--]]
function MenuClass:SetDisplayMode(displayMode)
    self.displayMode = displayMode
end

--[[
    ; autoHideDelay : How long, without a click, before the menu goes away.
--]]
function MenuClass:SetAutoHideDelay(autoHideDelay)
    self.autoHideDelay = tonumber(autoHideDelay)
end

--[[
    ; menuFrame : Should inherit a Drop Down Menu template.
--]]
function MenuClass:SetMenuFrame(menuFrame)
    self.menuFrame = menuFrame
end

--[[
    ; x : X position
    ; save : When not nil, will add to the current value rather than replace it
--]]
function MenuClass:SetX(x, save)
    if save then
        self.x = self.x + x
    else
        self.x = x
    end
end

--[[
    ; y : Y position
    ; save : When not nil, will add to the current value rather than replace it
--]]
function MenuClass:SetY(y, save)
    if save then
        self.y = self.y + y
    else
        self.y = y
    end
end

--[[
    Show the menu.
--]]
function MenuClass:Show()
    if not self.menuFrame then
        while _G['GenericMenuClassFrame'..self.uniqueID] do -- ensure that there's no namespace collisions
            self.uniqueID = self.uniqueID + 1
        end
        -- the frame must be named for some reason
        self.menuFrame = CreateFrame('Frame', 'GenericMenuClassFrame'..self.uniqueID, UIParent, "UIDropDownMenuTemplate")
    end
    EasyMenu(self.menuItems, self.menuFrame, self.anchor, self.x, self.y, self.displayMode, self.autoHideDelay)
end