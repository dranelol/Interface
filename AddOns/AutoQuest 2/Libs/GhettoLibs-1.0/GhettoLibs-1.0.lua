local MAJOR = "GhettoLibs-1.0"
local MINOR = 3

if not LibStub then return; end
local GhettoLibs = LibStub:NewLibrary(MAJOR, MINOR)
if not GhettoLibs then return end

if not GhettoLibs.frame then
    GhettoLibs.frame = CreateFrame("Frame")
end
local lib = GhettoLibs
---------------------------------------------------------------------------------------------------
-- Embed --
---------------------------------------------------------------------------------------------------
local mixins = {
    --"MinimapButtonCreate",
    "RegisterVersionCheck",
    "EnableAllModules",
    "DisableAllModules",
    "ToggleEnabled",
    "VerboseStatus",
    "UpdateOptions",
    "OptionToString",
    "SetupOptions",
    "Verbose",
    "Print",
    "newT",
}
function lib:Embed(target)
    for k, v in pairs(mixins) do
        target[v] = self[v]
    end
    return target
end
---------------------------------------------------------------------------------------------------
-- General Functions --
---------------------------------------------------------------------------------------------------
function lib:ToggleEnabled(object, value)
    --local object = LibStub:GetLibrary("AceAddon-3.0"):GetAddon(target.name)
    if ( value == true ) then object:Enable() else object:Disable() end
end
function lib:EnableAllModules(object)
    for name, module in object:IterateModules() do
        module:Enable()
    end
end
function lib:DisableAllModules(object)
    for name, module in object:IterateModules() do
        module:Disable()
    end
end
function lib:tobool(data)
    if type(data) == "number" then
        if data > 0 then
            return true;
        else
            return false;
        end
    elseif type(data) == "boolean" then
        return data;
    end
end
function lib:Print(object, text)
    DEFAULT_CHAT_FRAME:AddMessage(format("|cFFFFFF00%s: |r%s", object.name, text))
end
function lib:Verbose(object, text, option)
    if ( object.db.profile[option] ) then
        option = "Now";
    else
        option = "No Longer";
    end
    object:Print(object, string.format(text, option))
end
function lib:VerboseStatus(object, text, option)
    if ( object.db.profile[option] ) then
        option = "Enabled";
    else
        option = "Disabled";
    end
    print(string.format(text, option))
end
function lib:OptionToString(object, option)
    if ( option:find("modifier") ) then
        return object.optionValues["modifier"][object.db.profile[option]]
    end
end
---------------------------------------------------------------------------------------------------
-- Version Check --
---------------------------------------------------------------------------------------------------
function lib:RegisterVersionCheck(object)
    local versionCheck = LibStub:GetLibrary("LibVersionCheck-1.0")
    versionCheck:RegisterVersion(object.name, GetAddOnMetadata(object.name, "Version"), function(sender, identifier, version)
        if ( identifier == object.name and version ) then
            if ( GetAddOnMetadata(object.name, "Version") < version ) then
                if ( object.warnedUpdate ) then
                    return;
                end
                object:Print(object, string.format("A Newer Version (%s) Is Available. Please Update.", version))
                object.warnedUpdate = true
            end
        end
    end)
end
---------------------------------------------------------------------------------------------------
-- Configuration --
---------------------------------------------------------------------------------------------------
local function ManageCustomDefaults(object, key, val)
    local savedVars = object.nickName.."DB"
    
    if ( not savedVars.newDefaults ) then
        savedVars.newDefaults = {}
    end
    for k, v in pairs(object.defaults.profile) do
        savedVars.newDefaults[k] = v
    end
    
end
function lib:SetupOptions(object)
    local AceDB = LibStub:GetLibrary("AceDB-3.0")
    local AceConfig = LibStub:GetLibrary("AceConfig-3.0")
    local AceConfigDialog = LibStub:GetLibrary("AceConfigDialog-3.0")
    local AceConsole = LibStub:GetLibrary("AceConsole-3.0")
    local AceDBOptions = LibStub:GetLibrary("AceDBOptions-3.0")
    local savedVars = object.nickname.."_DB"
    local blizOptions = {};
    
    
    --Setup Config
    object.bucket = object:RegisterBucketEvent({"PLAYER_ENTERING_WORLD", "PLAYER_ALIVE"}, 0.1, "WelcomeMessage")
    object.db = LibStub:GetLibrary("AceDB-3.0"):New(savedVars, object.defaults)
    --object.db:RegisterDefaults(object.db.profile.default)
    object.db.RegisterCallback(object, "OnProfileChanged", "RefreshConfig" )
    object.db.RegisterCallback(object, "OnProfileCopied", "RefreshConfig")
    object.db.RegisterCallback(object, "OnProfileReset", "RefreshConfig")

    for k, v in object.options:opairs() do
        local parent;
        if ( k ~= object.name ) then
            parent = object.name;
        end
        AceConfig:RegisterOptionsTable(k, v)
        blizOptions[#blizOptions+1] = AceConfigDialog:AddToBlizOptions(k, k, parent)
    end
    AceConfig:RegisterOptionsTable("Profiles", AceDBOptions:GetOptionsTable(object.db))
    blizOptions[#blizOptions+1] = AceConfigDialog:AddToBlizOptions("Profiles", "Profiles", object.name)
    
    for i, _ in pairs(blizOptions) do
        blizOptions[i].default = function()
            object:ResetConfig()
        end
    end
    
    hooksecurefunc("InterfaceOptionsListButton_OnClick", function()
        if not object.db.profile.autoExpand then return; end
        local buttons = InterfaceOptionsFrameAddOns.buttons
        local selection = InterfaceOptionsFrameAddOns.selection
        local i = 1;
        while i <= #buttons do
            if ( buttons[i].element.name == object.name ) then
                if not selection then return; end
                if ( not buttons[i].element.collapsed ) then
                    if ( selection.name == object.name or selection.parent == object.name ) then
                        return;
                    end
                elseif ( selection.name ~= object.name ) then
                    return;
                end
                object.internal = false;
                OptionsListButtonToggle_OnClick( _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"] )
                return;
            end
            i = i + 1;
        end
    end)
    
    for _, slash in pairs(object.slashCom) do
        AceConsole:RegisterChatCommand(slash, object.optFunc)
    end
    
    self:UpdateOptions(object)
end
---------------------------------------------------------------------------------------------------
-- Update Options --
---------------------------------------------------------------------------------------------------
function lib:UpdateOptions(object)
    object.currentProfile = object.db:GetCurrentProfile()
    local newKey, newVal
    for k, v in pairs(object.db.profile) do
        if ( object.oldOptions[k] ) then
            newKey = object.oldOptions[k].newKey
            if ( object.oldOptions[k].newVal ) then
                newVal = object.oldOptions[k].newVal[v]
            end
            if ( newKey ) then
                object.db.profile[newKey] = newVal or object.db.profile[k]
                object.db.profile[k] = nil
            elseif ( newVal ) then
                object.db.profile[k] = newVal
            end
        end
    end
end
---------------------------------------------------------------------------------------------------
-- Minimap Buttons --
---------------------------------------------------------------------------------------------------
--[[function lib:MinimapButtonCreate(object)
    
    local frameName = object.nickname.."MinimapButton"
    local frame = CreateFrame("Button", frameName, Minimap)
    frame:SetWidth(31)
    frame:SetHeight(31)
    frame:SetFrameStrata("LOW")
    frame:SetToplevel(1)
    frame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    frame:SetPoint("TOPLEFT", MInimap, "TOPLEFT")
    local icon = frame:CreateTexture(frameName.."Icon", "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetWidth(20)
    icon:SetHeight(20)
    icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, -5)
    
    local overlay = frame:CreateTexture(frameName.."Overlay", "OVERLAY")
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetWidth(53)
    overlay:SetHeight(53)
    overlay:SetPoint("TOPLEFT",frame,"TOPLEFT")
    
    frame:RegisterForClicks("LeftButtonUp","RightButtonUp")
    frame:SetScript("OnClick",object.OnClick)
    
    frame:SetScript("OnMouseDown",object.OnMouseDown)
    frame:SetScript("OnMouseUp",object.OnMouseUp)
    frame:SetScript("OnEnter",object.OnEnter)
    frame:SetScript("OnLeave",object.OnLeave)
    
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart",object.OnDragStart)
    frame:SetScript("OnDragStop",object.OnDragStop)
    
    frame.tooltipTitle = modName
    frame.leftClick = initSettings.left
    frame.rightClick = initSettings.right
    frame.tooltipText = initSettings.tooltip
    local firstUse = 1
    for i, _ in pairs(modSettings) do
        firstUse = nil -- modSettings has been populated before
    end
    if firstUse then
        -- define modSettings from initSettings or default
        modSettings.drag = initSettings.drag or "CIRCLE"
        modSettings.enabled = initSettings.enabled or 1
        modSettings.position = initSettings.position or object:GetDefaultPosition()
        modSettings.locked = initSettings.locked or nil
    end
    frame.modSettings = modSettings
    
    table.insert(object.Buttons,modName)
    object:SetEnable(modName,modSettings.enabled)
end]]
---------------------------------------------------------------------------------------------------
-- Ordered Tables --
---------------------------------------------------------------------------------------------------
--[[
   LUA 5.1 compatible
   
   Ordered Table
   keys added will be also be stored in a metatable to recall the insertion oder
   metakeys can be seen with for i,k in ( <this>:ipairs()  or ipairs( <this>._korder ) ) do
   ipairs( ) is a bit faster
   
   variable names inside __index shouldn't be added, if so you must delete these again to access the metavariable
   or change the metavariable names, except for the 'del' command. thats the reason why one cannot change its value
]]--
function lib:newT( t )
   local mt = {}
   -- set methods
   mt.__index = {
      -- set key order table inside __index for faster lookup
      _korder = {},
      -- traversal of hidden values
      hidden = function() return pairs( mt.__index ) end,
      -- traversal of table ordered: returning index, key
      ipairs = function( self ) return ipairs( self._korder ) end,
      -- traversal of table
      pairs = function( self ) return pairs( self ) end,
      -- traversal of table ordered: returning key,value
      opairs = function( self )
         local i = 0
         local function iter( self )
            i = i + 1
            local k = self._korder[i]
            if k then
               return k,self[k]
            end
         end
         return iter,self
      end,
      -- to be able to delete entries we must write a delete function
      del = function( self,key )
         if self[key] then
            self[key] = nil
            for i,k in ipairs( self._korder ) do
               if k == key then
                  table.remove( self._korder, i )
                  return
               end
            end
         end
      end,
   }
   -- set new index handling
   mt.__newindex = function( self,k,v )
      if k ~= "del" and v then
         rawset( self,k,v )
         table.insert( self._korder, k )
      end      
   end
   return setmetatable( t or {},mt )
end
-- CHILLCODE™

