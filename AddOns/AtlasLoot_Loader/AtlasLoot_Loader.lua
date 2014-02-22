--[[
Atlasloot Enhanced
Author Hegarol
Loot browser associating loot with instance bosses
Can be integrated with Atlas (http://www.atlasmod.com)

Functions:
]]
AtlasLoot = LibStub("AceAddon-3.0"):NewAddon("AtlasLoot")

AtlasLootLoaderDB = {}

--Instance required libraries
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");

--List with Modules
AtlasLoot.Modules = {
	{"AtlasLootClassicWoW", "AtlasLoot_ClassicWoW", false, "", AL["Classic WoW"] },
	{"AtlasLootBurningCrusade", "AtlasLoot_BurningCrusade", false, "", AL["Burning Crusade"] },
	{"AtlasLootWotLK", "AtlasLoot_WrathoftheLichKing", false, "", AL["Wrath of the Lich King"] },
	{"AtlasLootCataclysm", "AtlasLoot_Cataclysm", false, "", AL["Cataclysm"] },
	{"AtlasLootCrafting", "AtlasLoot_Crafting", false, ""},
	{"AtlasLootWorldEvents", "AtlasLoot_WorldEvents", false, ""},
}


function AtlasLoot:OnInitialize()
	--[===[@debug@ 
	self:OnLoaderLoad()
	--@end-debug@]===]
	
	-- Warning if AtlasLootFu is enabled
	local _, _, _, enabled, _, reason = GetAddOnInfo("AtlasLootFu")
	if enabled or reason == "DISABLED" then
		DisableAddOn("AtlasLootFu")
		StaticPopupDialogs["ATLASLOOT_FU_ERROR"] = {
			text = AL["AtlasLootFu is no longer in use.\nDelete it from your AddOns folder"],
			button1 = OKAY,
			timeout = 0,
			exclusive = 1,
			whileDead = 1,
		}
		StaticPopup_Show("ATLASLOOT_FU_ERROR")
	end
	
	if not AtlasLootLoaderDB.MiniMapButton then
		AtlasLootLoaderDB.MiniMapButton = {
			hide = false,
		}
	end
	
	-- Bindings
	BINDING_HEADER_ATLASLOOT_TITLE = AL["AtlasLoot"]
	BINDING_NAME_ATLASLOOT_TOGGLE = AL["Toggle AtlasLoot"]
	
	-- Slash /al 
	self:CreateSlash()
	-- Options
	self:OptionsInitialize()
	-- MiniMap Button
	self:MiniMapButtonInitialize()
	
	
end


local allLoaded = false
local spamProtect = {}
local atlasLootIsLoaded = false

--- Loads a AtlasLoot module
-- @param module AtlasLootClassicWoW, AtlasLootBurningCrusade, AtlasLootWotLK, AtlasLootCataclysm, AtlasLootCrafting, AtlasLootWorldEvents, all
-- @usage AtlasLoot:LoadModule(module)
function AtlasLoot:LoadModule(module)
	if not module then return end
	if allLoaded then return true end
	local loadedRET,reasonRET = true, ""
	if module == "AtlasLoot" or not atlasLootIsLoaded then
		if not IsAddOnLoaded(module) then
			LoadAddOn("AtlasLoot")
			self:OnLoaderLoad()
			atlasLootIsLoaded = true
		end
		return loadedRET, reasonRET
	end
	
	for k,v in ipairs(self.Modules) do
		if not self.Modules[k][3] then
			if v[1] == module or module == "all" then
				local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v[2])
				if reason == "DISABLED" then
					if self.Modules[k][4] == "" then
						self:Print(string.format(AL["Module \"%s\" is disabled."], v[2]))
						self.Modules[k][4] = reason
						loadedRET = false
						reasonRET = reason
					end
				elseif reason == "MISSING" then
					if self.Modules[k][4] == "" then
						self:Print(string.format(AL["Module \"%s\" is missing."], v[2]))
						self.Modules[k][4] = reason
						loadedRET = false
						reasonRET = reason
					end
				else
					self.Modules[k][4] = ""
					if not IsAddOnLoaded(v[2]) then
						LoadAddOn(v[2])
						self.Modules[k][3] = true
					end
				end
			end
		end
	end
	if module == "all" then
		allLoaded = true
	else
		local checkVal = false
		for k,v in ipairs(self.Modules) do
			if v[3] == true then
				checkVal = true
			else
				checkVal = false
				break
			end
		end
		if checkVal == true then
			allLoaded = true
		end
	end
	if allLoaded then
		AtlasLoot_InstanceList_Loader = nil
		collectgarbage("collect")
		loadedRET = true
		reasonRET = nil
	end
	return loadedRET,reasonRET
end

-- This only loads the AtlasLoot Core
-- After first call this function is replaced
function AtlasLoot:SlashCommand(msg)
	self:LoadModule("AtlasLoot")
	self:SlashCommand(msg)
end

-- Create the Slashs /al and /atlasloot
function AtlasLoot:CreateSlash()
	--Enable the use of /al or /atlasloot to open the loot browser
	SLASH_ATLASLOOT1 = "/atlasloot";
	SLASH_ATLASLOOT2 = "/al";
	SlashCmdList["ATLASLOOT"] = function(msg)
		self:SlashCommand(msg);
	end
end

--- Check a dataID and loads module if needed
function AtlasLoot:CheckDataID(dataID)
	if AtlasLoot_Data and AtlasLoot_Data[dataID] then
		return true 
	elseif AtlasLoot_InstanceList_Loader and AtlasLoot_InstanceList_Loader[dataID] then
		return self:LoadModule(AtlasLoot_ModuleList_Loader[ AtlasLoot_InstanceList_Loader[dataID] ] )
	else
		local tLocation = self:GetTableLoaction(dataID)
		if tLocation and AtlasLoot_LootTableRegister[tLocation[1]][tLocation[2]]["Info"][2] then
			return self:LoadModule(AtlasLoot_LootTableRegister[tLocation[1]][tLocation[2]]["Info"][2])
		else
			return false, "MISSING"
		end
		return false, "MISSING"
	end
end

function AtlasLoot:CheckModule(module)
	if allLoaded then return true end
	for k,v in ipairs(self.Modules) do
		if v[1] == module or v[2] == module then
			local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v[2])
			if IsAddOnLoaded(v[2]) then
				return true
			else
				return reason
			end
		end
	end
end

--[===[@debug@ 
function AtlasLoot:CheckModule(module)
	return true
end
--@end-debug@]===]