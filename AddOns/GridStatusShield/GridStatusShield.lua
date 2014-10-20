--[[
	Name: GridStatusShield
	Revision: $Revision: 82146 $
	Developed by: Julith @ Perenolde-EU (billgatesgut@web.de)
	Description: Publishes the sremaining value of the players power word shield on a unit.
]]

--{{{ Libraries
--local ShieldLeft = LibStub:GetLibrary("LibShieldLeft-1.0", true)
--if not ShieldLeft then return end
local L = LibStub("AceLocale-3.0"):GetLocale("GridStatusShield")

--}}}

local LOCALISATIONS = {
    ["zhTW"] = "可吸收.- (%d+) .-點傷害",
    ["ruRU"] = "[пП]оглощ.- (%d+) .-урона",
}

local SHIELD_AMOUNT_PATTERN = LOCALISATIONS[GetLocale()] or L["[aA]bsorbs.- (%d+) .-damage"]

local GridRoster = Grid:GetModule("GridRoster")
local GridFrame= Grid:GetModule("GridFrame")
local GridStatusShield = Grid:GetModule("GridStatus"):NewModule("GridStatusShield")
local GridStatusHeals = Grid:GetModule("GridStatus"):GetModule("GridStatusHeals")
GridStatusShield.menuName = L["Shield left"]


--{{{ AceDB defaults

local BLIZZARD_API_TRACKING = 0;
local AURA_BASED_TRACKING = 1;
local COMBAT_LOG_BASED_TRACKING = 2;

GridStatusShield.defaultDB = {
	unitShieldLeft = {
		enable = true,
		priority = 90,
		color = { r = 1, g = 0, b = 0, a = 1 },
        aegisTolerance = 0.3,
        mark1Color = { r = 1, g = 0, b = 0, a = 1 },
        mark1Threshold = 500,
        mark2Color = { r = 1, g = 1, b = 0, a = 1 },
        mark2Threshold = 1000,
        trackingMethod = BLIZZARD_API_TRACKING,
        
	},
    unitShieldedHealth = {
        enable = true,
        priority = 60,
        color = {r = 1, g = 1, b = 0, a = 1 },
        incColor = {r = 0.5, g = 1, b = 0, a = 1},
        overflowColor = {r = 0, g = 1, b = 1, a = 1},
    },
}

--}}}

local settings

--{{{ Options
local healthOptions = {
    ["shieldIncHealColor"] = {
        type = "color",
        name = L["Shielded incoming heal color"],
        desc = L["Color for the shield+incoming heal health."],
        order = 90,
        hasAlpha = true,
        get = function ()
                  local color = settings.unitShieldedHealth.incColor
                  return color.r, color.g, color.b, color.a
              end,
        set = function (_, r, g, b, a)
                  local color = settings.unitShieldedHealth.incColor
                  color.r = r
                  color.g = g
                  color.b = b
                  color.a = a or 1
              end,
    },
--[[
    ["shieldOverflowColor"] = {
        type = "color",
        name = L["Shield overflow color"],
        desc = L["Color for the shield if bigger than max HP of unit."],
        order = 90,
        hasAlpha = true,
        get = function ()
                  local color = settings.unitShieldedHealth.overflowColor
                  return color.r, color.g, color.b, color.a
              end,
        set = function (_, r, g, b, a)
                  local color = settings.unitShieldedHealth.overflowColor
                  color.r = r
                  color.g = g
                  color.b = b
                  color.a = a or 1
              end,
    },
]]
}

local amountOptions = {
    ["trackingMethod"] = {
        type = "select",
        name = L["Tracking method"],
        desc = L["Select the tracking method to use. Blizzard API will be the best in almost any case but if you are missing some absorbs you can try chaning this option."],
        get = function ()
            return settings.unitShieldLeft.trackingMethod
        end,
        set = function(_, v)
            GridStatusShield:ChangeTrackingMethod(v)
        end,
        values = { [BLIZZARD_API_TRACKING] = L["Blizzard API"], [AURA_BASED_TRACKING] = L["Aura based"], [COMBAT_LOG_BASED_TRACKING] = L["Combat log based"] },
        order = 142,
    },
    ["mark1color"] = {
        type = "color",
        name = L["Low shield color"],
        desc = L["Color for shield amount below the low shield threshold."],
        order = 90,
        hasAlpha = true,
        get = function ()
                  local color = settings.unitShieldLeft.mark1Color
                  return color.r, color.g, color.b, color.a
              end,
        set = function (_, r, g, b, a)
                  local color = settings.unitShieldLeft.mark1Color
                  color.r = r
                  color.g = g
                  color.b = b
                  color.a = a or 1
              end,
    },
    ["mark2color"] = {
        type = "color",
        name = L["Medium shield color"],
        desc = L["Color for shield amount below the medium shield threshold."],
        order = 90,
        hasAlpha = true,
        get = function ()
                  local color = settings.unitShieldLeft.mark2Color
                  return color.r, color.g, color.b, color.a
              end,
        set = function (_, r, g, b, a)
                  local color = settings.unitShieldLeft.mark2Color
                  color.r = r
                  color.g = g
                  color.b = b
                  color.a = a or 1
              end,
    },
    ["mark1threshold"] = {
		type = "range",
		name = L["Low shield threshold"],
		desc = L["The threshold below which a shield is considered low."],
        max = 200000,
        min = 50,
        step = 1,
		get = function()
			return settings.unitShieldLeft.mark1Threshold
		end,
		set = function(_, v)
			settings.unitShieldLeft.mark1Threshold = v
		end,
	},
    ["mark2threshold"] = {
		type = "range",
		name = L["Medium shield threshold"],
		desc = L["The threshold below which a shield is considered medium."],
        max = 400000,
        min = 100,
        step = 1,
		get = function()
			return settings.unitShieldLeft.mark2Threshold
		end,
		set = function(_, v)
			settings.unitShieldLeft.mark2Threshold = v
		end,
	},
}
--}}}

GridFrame.db.profile.statusmap.healingBar.unitShieldedHealth = true

local BlizzardAPIBasedTracking = {}
local AuraBasedTracking = {}
local CombatLogBasedTracking = {}

function GridStatusShield:OnInitialize()
	self.super.OnInitialize(self)    
    
	self:RegisterStatus("unitShieldLeft", L["Shield left"], amountOptions, true)
    self:RegisterStatus("unitShieldedHealth", L["Shielded Health"], healthOptions, true)
    settings = GridStatusShield.db.profile
    
    --clean up old config    
    if settings.unitShieldLeft.useCombatLog ~= nil then
        settings.unitShieldLeft.trackingMethod = BLIZZARD_API_TRACKING
        settings.unitShieldLeft.useCombatLog = nil
    end
    
    self:ChangeTrackingMethod(settings.unitShieldLeft.trackingMethod)
end

function GridStatusShield:OnStatusEnable(status)
    if status == "unitShieldLeft" then
        self:RegisterMessage("Grid_UnitJoined")        
        
        self.currentTracker.Enable(self.UpdateByGUID)
    elseif status == "unitShieldedHealth" then
        self:RegisterEvent("UNIT_HEALTH", "UpdateUnit")
		self:RegisterEvent("UNIT_MAXHEALTH", "UpdateUnit")
        self:RegisterEvent("UNIT_HEAL_PREDICTION", "UpdateUnit")
    end
end

function GridStatusShield:OnStatusDisable(status)
    for guid, unitid in GridRoster:IterateRoster() do
        self:Clear(guid)
    end  
    if status == "unitShieldLeft" then
        self:UnregisterMessage("Grid_UnitJoined")
        
        self.currentTracker.Disable()
    elseif status == "unitShieldedHealth" then
        self:UnregisterEvent("UNIT_HEALTH")
		self:UnregisterEvent("UNIT_MAXHEALTH")
        self:UnregisterEvent("UNIT_HEAL_PREDICTION")
    end
end

function GridStatusShield:Reset()
    self.super.Reset(self)
    
    -- like resetting your router: just unplug and replug it...
    self:OnStatusDisable("unitShieldLeft")
    self:OnStatusEnable("unitShieldLeft")
end


function GridStatusShield:ChangeTrackingMethod(method)
    -- reset with new method
    if self.currentTracker then
        self:OnStatusDisable("unitShieldLeft")
    end
    
    settings.unitShieldLeft.trackingMethod = method
    if settings.unitShieldLeft.trackingMethod == COMBAT_LOG_BASED_TRACKING then
        self.currentTracker = CombatLogBasedTracking
    elseif settings.unitShieldLeft.trackingMethod == AURA_BASED_TRACKING then
        self.currentTracker = AuraBasedTracking
    else
        self.currentTracker = BlizzardAPIBasedTracking
    end
    
    self:OnStatusEnable("unitShieldLeft")
end

function GridStatusShield:Print(msg)
    --print("GridStatusShield: "..msg)
end

function GridStatusShield:Grid_UnitJoined(_, unitGUID, unitid)
    self:Clear(unitGUID)
end


function GridStatusShield:Clear(unitGUID)
    self.core:SendStatusLost(unitGUID, "unitShieldLeft")
    self.core:SendStatusLost(unitGUID, "unitShieldedHealth")
end

function GridStatusShield:FormatShieldText(amount)
	local shieldText
	if amount > 999 then
		shieldText = string.format("%.1fk", amount/1000.0)
	else
		shieldText = string.format("%3.0f", amount)
	end
	return shieldText
end

function GridStatusShield:UpdateUnit(unit)
    local guid = UnitGUID(unit)
    GridStatusShield.UpdateByGUID(guid)
end

function GridStatusShield.UpdateByGUID(unitGUID)
    if not GridRoster:IsGUIDInRaid(unitGUID) then return end
    GridStatusShield:SendShieldStatus(unitGUID)
end


function GridStatusShield:SendShieldStatus(unitGUID)
    local amount = self.currentTracker.UnitShieldLeft(unitGUID)
    
    if amount > 0 then    
        local color = settings.unitShieldLeft.color
        if amount < settings.unitShieldLeft.mark1Threshold then
            color = settings.unitShieldLeft.mark1Color
        elseif amount < settings.unitShieldLeft.mark2Threshold then
            color = settings.unitShieldLeft.mark2Color
        end
        
        if settings.unitShieldedHealth.enable then
            local unit = GridRoster:GetUnitidByGUID(unitGUID)
            assert(unit)
            local health = UnitHealth(unit)
            local healthMax = UnitHealthMax(unit)
            
            local incoming = UnitGetIncomingHeals(unit) or 0
            if incoming > 0 and GridStatusHeals.db.profile.alert_heals.ignore_self then
                incoming = incoming - (UnitGetIncomingHeals(unitid, "player") or 0)
            end
            
            local shieldedColor = settings.unitShieldedHealth.color
            if incoming > 0 then
                shieldedColor = settings.unitShieldedHealth.incColor
            end
            
            
            local shieldHealth = health+amount+incoming
            
            local val = shieldHealth
            local maxVal = healthMax
            
            

            self.core:SendStatusGained(unitGUID, "unitShieldedHealth",
                        settings.unitShieldedHealth.priority,
                        nil,
                        shieldedColor,
                        nil,
                        val,
                        maxVal)
        end
        
        self.core:SendStatusGained(unitGUID, "unitShieldLeft",
                    settings.unitShieldLeft.priority,
                    nil,
                    color,
                    self:FormatShieldText(amount))
    else
        self.core:SendStatusLost(unitGUID, "unitShieldLeft")
        self.core:SendStatusLost(unitGUID, "unitShieldedHealth")
    end
end



-------------------------------
-- Blizzard API based tracking --
-------------------------------
------------------------------
-- API to GridStatusShield

function BlizzardAPIBasedTracking.Enable(callbackMethod)
    assert(callbackMethod and type(callbackMethod) == "function")
    
    BlizzardAPIBasedTracking.callback = callbackMethod
        
    --listen for combat log
    GridStatusShield.RegisterEvent(BlizzardAPIBasedTracking, "UNIT_ABSORB_AMOUNT_CHANGED")
    
    --initial scan of units
    for guid, unitid in GridRoster:IterateRoster() do
        BlizzardAPIBasedTracking.UNIT_ABSORB_AMOUNT_CHANGED(_,_, unitid)
    end
end

function BlizzardAPIBasedTracking.Disable()
    GridStatusShield.UnregisterEvent(BlizzardAPIBasedTracking, "UNIT_ABSORB_AMOUNT_CHANGED")
end

function BlizzardAPIBasedTracking.UnitShieldLeft(unitGUID)
    local unitid = GridRoster:GetUnitidByGUID(unitGUID)
    if not unitid then 
        return 
    end
    
    return UnitGetTotalAbsorbs(unitid)
end

-------------------------------
--Internal stuff

function BlizzardAPIBasedTracking.UNIT_ABSORB_AMOUNT_CHANGED(_, _, unitid)
    local guid = UnitGUID(unitid)
    assert(guid)
    BlizzardAPIBasedTracking.callback(guid)
end



-------------------------------
-- Auratooltip based tracking--
-------------------------------

------------------------------
-- API to GridStatusShield

function AuraBasedTracking.Enable(callbackMethod)
    assert(callbackMethod and type(callbackMethod) == "function")
    
    AuraBasedTracking.callback = callbackMethod
    AuraBasedTracking.ShieldAmountTable = {}
    
    -- caches if a buff with a certain id is a shield and if yes stores the tooltip line where the absorb value
    -- is found
    AuraBasedTracking.shieldCache = {}
    
    --create Tooltip
    AuraBasedTracking.Tooltip = CreateFrame("GameTooltip")
    AuraBasedTracking.Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    for i = 1, 5 do
        AuraBasedTracking["TooltipTextLeft" .. i] = AuraBasedTracking.Tooltip:CreateFontString()
        AuraBasedTracking["TooltipTextRight" .. i] = AuraBasedTracking.Tooltip:CreateFontString()
        AuraBasedTracking.Tooltip:AddFontStrings(AuraBasedTracking["TooltipTextLeft" .. i], AuraBasedTracking["TooltipTextRight" .. i])
    end
    
    --listen for AURA changes
    GridStatusShield.RegisterEvent(AuraBasedTracking, "UNIT_AURA")
    
    --initial scan of units
    for guid, unitid in GridRoster:IterateRoster() do
        AuraBasedTracking.UNIT_AURA(_,_, unitid)
    end
end

function AuraBasedTracking.Disable()
    GridStatusShield.UnregisterEvent(AuraBasedTracking, "UNIT_AURA")
end

function AuraBasedTracking.UnitShieldLeft(unitGUID)
    return AuraBasedTracking.ShieldAmountTable[unitGUID] or 0
end



-------------------------------
--Internal stuff

function AuraBasedTracking.SetUnitShieldLeft(unitGuid, amount)
    AuraBasedTracking.ShieldAmountTable[unitGuid] = amount
    AuraBasedTracking.callback(unitGuid)
end

function AuraBasedTracking.ScanBuffToolTip(unit, buffIndex, id, isDebuff)
    local cacheEntry = AuraBasedTracking.shieldCache[id]
    if isDebuff then
        AuraBasedTracking.Tooltip:SetUnitDebuff(unit, buffIndex)
    else
        AuraBasedTracking.Tooltip:SetUnitBuff(unit, buffIndex)
    end
    if cacheEntry == nil then 
        -- find the tooltip line and determine absorb 
        local tooltipLine = AuraBasedTracking.TooltipTextLeft2
        local tooltipText = tooltipLine:GetText()
        if tooltipText then
            local _,_,shieldSize = string.find(tooltipText, SHIELD_AMOUNT_PATTERN)
            
            if shieldSize then
                AuraBasedTracking.shieldCache[id] = tooltipLine --cache line
                return tonumber(shieldSize)        
            end
        end
        tooltipLine = AuraBasedTracking.TooltipTextLeft3
        tooltipText = tooltipLine:GetText()
        if tooltipText then
            local _,_,shieldSize = string.find(tooltipText, SHIELD_AMOUNT_PATTERN)
            
            if shieldSize then
                AuraBasedTracking.shieldCache[id] = tooltipLine
                return tonumber(shieldSize)        
            end
        end
        AuraBasedTracking.shieldCache[id] = false --not a shield
    elseif cacheEntry then
        local tooltipLine = cacheEntry
        
        -- Determine absorb            
        local _,_,shieldSize = string.find(tooltipLine:GetText(), SHIELD_AMOUNT_PATTERN)

        -- although we had a cache hit it might be that there exist shields which do not always absorb things
        if shieldSize then
            return tonumber(shieldSize)
        end
    end
    
    return nil
end 

function AuraBasedTracking.UNIT_AURA(_,_, unit)
    local unitGUID = UnitGUID(unit)
    if not unitGUID then
        return
    end
    
    if not GridRoster:IsGUIDInRaid(unitGUID) then
        return
    end
    
    local sum = 0
    local i = 1
    local name, rank, icon, count, buffType, duration, expirationTime, source, isStealable, _, id = UnitBuff(unit, i)
    while name do        
        local absorb = AuraBasedTracking.ScanBuffToolTip(unit, i, id)
        --print(name..": "..tostring(absorb))
        if absorb and absorb > 0 then
            sum = sum + absorb
        end
        i = i + 1
        name, rank, icon, count, buffType, duration, expirationTime, source, isStealable, _, id  = UnitBuff(unit, i)
    end
    i = 1
    name, rank, icon, count, buffType, duration, expirationTime, source, isStealable, _, id = UnitDebuff(unit, i)
    while name do        
        local absorb = AuraBasedTracking.ScanBuffToolTip(unit, i, id, true)   
        --print(name..": "..tostring(absorb))
        if absorb and absorb > 0 then            
            sum = sum + absorb
        end
        i = i + 1
        name, rank, icon, count, buffType, duration, expirationTime, source, isStealable, _, id  = UnitDebuff(unit, i)
    end
    

    if sum > 0 then
        AuraBasedTracking.SetUnitShieldLeft(unitGUID, sum)
    else
        AuraBasedTracking.SetUnitShieldLeft(unitGUID)
    end
end



-------------------------------
-- Combat log based tracking --
-------------------------------
------------------------------
-- API to GridStatusShield

function CombatLogBasedTracking.Enable(callbackMethod)
    assert(callbackMethod and type(callbackMethod) == "function")
    
    CombatLogBasedTracking.callback = callbackMethod
    CombatLogBasedTracking.ShieldAmountTable = {}
    
    CombatLogBasedTracking.activeShields = {}
        
    --listen for combat log
    GridStatusShield.RegisterEvent(CombatLogBasedTracking, "COMBAT_LOG_EVENT_UNFILTERED")
end

function CombatLogBasedTracking.Disable()
    GridStatusShield.UnregisterEvent(CombatLogBasedTracking, "COMBAT_LOG_EVENT_UNFILTERED")
end

function CombatLogBasedTracking.UnitShieldLeft(unitGUID)
    return CombatLogBasedTracking.ShieldAmountTable[unitGUID] or 0
end

-------------------------------
--Internal stuff

function CombatLogBasedTracking.SetUnitShieldLeft(unitGuid, amount)
    CombatLogBasedTracking.ShieldAmountTable[unitGuid] = amount
    CombatLogBasedTracking.callback(unitGuid)
end

function CombatLogBasedTracking.getUnitShields(guid)
    local shields = CombatLogBasedTracking.activeShields[guid]
    if not shields then
        shields = {total = 0, count = 0}
        CombatLogBasedTracking.activeShields[guid] = shields
    end
    return shields
end

function CombatLogBasedTracking.UpdateCLShield(shieldId, unitGUID, amount)
    local shields = CombatLogBasedTracking.getUnitShields(unitGUID)
    
    if shields[shieldId] and shields[shieldId] > 0 then
        shields.total = shields.total + (amount - shields[shieldId])
        shields[shieldId] = amount
    else
        shields[shieldId] = amount
        shields.total = shields.total + amount
        shields.count = shields.count + 1
    end
    
    CombatLogBasedTracking.SetUnitShieldLeft(unitGUID, shields.total)
end

function CombatLogBasedTracking.RemoveShield(shieldId, unitGUID)
    local shields = CombatLogBasedTracking.getUnitShields(unitGUID)
    if shields[shieldId] then
        shields.total = shields.total - shields[shieldId]
        shields[shieldId] = nil
        shields.count = shields.count - 1
        
        if shields.count > 0 then
            CombatLogBasedTracking.SetUnitShieldLeft(unitGUID, shields.total)
        else
            CombatLogBasedTracking.SetUnitShieldLeft(unitGUID)
        end
    end
end

function CombatLogBasedTracking.AuraApplied(srcGUID, dstGUID, spellId, spellName, spellSchool, auraType, amount)  
    if amount and amount > 0 then          
        CombatLogBasedTracking.UpdateCLShield(spellId, dstGUID, amount)
    end
end

function CombatLogBasedTracking.AuraRefresh(srcGUID, dstGUID, spellId, spellName, spellSchool, auraType, amount)    
    if amount and amount > 0 then          
        CombatLogBasedTracking.UpdateCLShield(spellId, dstGUID, amount)
    end
end

function CombatLogBasedTracking.AuraRemoved(srcGUID, dstGUID, spellId)  
    CombatLogBasedTracking.RemoveShield(spellId, dstGUID) 
end

function CombatLogBasedTracking.AuraBroken(srcGUID, dstGUID, spellId)    
    CombatLogBasedTracking.RemoveShield(spellId, dstGUID)  
end

function CombatLogBasedTracking.AuraBrokenSpell(srcGUID, dstGUID, spellId)    
    CombatLogBasedTracking.RemoveShield(spellId, dstGUID) 
end

local EventParse = {}
EventParse["SPELL_AURA_APPLIED"] = CombatLogBasedTracking.AuraApplied
EventParse["SPELL_AURA_REFRESH"] = CombatLogBasedTracking.AuraRefresh
EventParse["SPELL_AURA_REMOVED"] = CombatLogBasedTracking.AuraRemoved 
EventParse["SPELL_AURA_BROKEN"] = CombatLogBasedTracking.AuraBroken
EventParse["SPELL_AURA_BROKEN_SPELL"] = CombatLogBasedTracking.AuraBrokenSpell

function CombatLogBasedTracking.COMBAT_LOG_EVENT_UNFILTERED(_, _, timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, ...)   
    if not GridRoster:IsGUIDInRaid(dstGUID) then
        return
    end
    
	local parsefunc = EventParse[eventtype]
	
    --print("Event: "..eventtype)
	if parsefunc then  
--        print(eventtype)
		parsefunc(srcGUID, dstGUID, ...)
	end
end



