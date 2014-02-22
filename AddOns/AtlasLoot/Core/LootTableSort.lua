--[[ Table format

]]--
local AtlasLoot = LibStub("AceAddon-3.0"):GetAddon("AtlasLoot")

local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");


local LootTableSort = {}
local lastDataID
local cacheTable = {}
local lootTableTypes = {"Normal", "Heroic", "25Man", "25ManHeroic"}
local lootTableTypesIndex = {}
local sortFunctions = {
	tableSortIndex = {
		{ "SortByInstance", AL["Sort by Instance"], AL["Sort loottable by Instance"] },
		{ "SortByBoss", AL["Sort by Boss"], AL["Sort loottable by Boss"] },
		{ "SortByNone", "|cff999999<"..NONE..">", NONE },
	},
	tableSort = {},
	itemSort = {},
	itemSortIndex = {
		{ "ItemName", AL["Item Name"], itemSubSort = { "ItemQuality" } },
		--{ "ItemSlot", AL["Item Slot"] },
		--{ "ItemNameItemQuality", AL["Item Name"].." + "..AL["Item Quality"] },
		--{ "ItemSlotItemQuality", AL["Item Slot"].." + "..AL["Item Quality"] },
	},
	itemSubSort = {},
	itemSubSortIndex = {
		{ "ItemQuality", AL["Item Quality"] },
	},
}
do 
	for k,v in ipairs(sortFunctions.itemSortIndex) do
		sortFunctions.itemSort[v[1]] = { v[2], index = k }
	end
	for k,v in ipairs(sortFunctions.tableSortIndex) do
		sortFunctions.tableSort[v[1]] = { v[2], v[3], index = k }
	end
	for k,v in ipairs(lootTableTypes) do
		lootTableTypesIndex[v] = k
	end
	for k,v in ipairs(sortFunctions.itemSubSortIndex) do
		sortFunctions.itemSubSort[v[1]] = { v[2], index = k }
	end
end
local configTableDefault = {
	tableSort = "SortByInstance", itemSort = "ItemName", itemSubSort = { ["ItemQuality"] = true },
}

-- Loottable format
do
	local mt = {__index = LootTableSort}
	local tableSortIndex = 1
	
	--- Adds a table sort 
	-- Sorts loottables
	-- @param name Enter a name allows to call a loottable with AtlasLoot_Data["SortedTable"..name]
	function AtlasLoot:AddLootTableSort(name)
		if not name then
			name = "cache"..tableSortIndex
			tableSortIndex = tableSortIndex + 1
		else
			name = "SortedTable"..name
		end

		local lootTableSortMeta = setmetatable(
			{
				name = name,
			},
			mt
		)
		
		lootTableSortMeta:SetConfigTable()
		lootTableSortMeta:Preparing_SortTable()
		
		return lootTableSortMeta
	end
end

-- Sets config table
-- Can use SavedVariables or a local table
function LootTableSort:SetConfigTable(config)
	self.config = config or {}
end

function LootTableSort:GetConfigValue(key)
	local tabLink = { string.split(".", key) }
	local saveTab = self.config
	local saveDefaultTab = configTableDefault
	for k,v in ipairs(tabLink) do
		if saveTab[v] == nil then
			saveTab = saveDefaultTab[v]
		else
			saveTab = saveTab[v]
		end
		saveDefaultTab = saveDefaultTab[v]
	end
	return saveTab
--	return self.config[key] or configTableDefault[key]
end

function LootTableSort:SetConfigValue(key, value)
	local tabLink = { string.split(".", key) }
	local saveTab = self.config
	local numTab = #tabLink
	for k,v in ipairs(tabLink) do
		if k == #tabLink then
			saveTab[v] = value
		else
			if saveTab[v] == nil then saveTab[v] = {} end
			saveTab = saveTab[v]
		end
	end
end

-- Gets a Optionstable for AceConfigDialog Options 
function LootTableSort:GetOptionsTable(order)
	local tab = {
		sortOpt = {						
			type = "group",
			inline = true,
			name = AL["Table Sort"],
			order = order,
			args = {
			},
		},
	}
	local curOrder = 1
	
	tab.sortOpt.args.TableSort = {
		type = "select",
		name = AL["Table Sort:"],
		--desc = ,
		values = {},
		order = curOrder,
		width = "full",
		get = function(info)
			if not sortFunctions.tableSort[self:GetConfigValue("tableSort")] then
				self:SetConfigValue("tableSort", configTableDefault.tableSort)
			end
			return sortFunctions.tableSort[self:GetConfigValue("tableSort")].index
		end,
		set = function(info, value)
			self:SetConfigValue("tableSort", sortFunctions.tableSortIndex[value][1])
			return value
		end,
	}
	curOrder = curOrder + 1
	for k,v in ipairs(sortFunctions.tableSortIndex) do
		tab.sortOpt.args.TableSort.values[k] = v[2]
	end
	--[=[
	for k,v in ipairs(sortFunctions.tableSortIndex) do
		tab.sortOpt.args[v[1]] = {
			type = "toggle",
			name = v[2],--
			desc = v[3],
			order = curOrder,
			get = function(info)
				return self:GetConfigValue(v[1])
			end,
			set = function(info, value)
				self:SetConfigValue(v[1], value)
				return self:GetConfigValue(v[1])
			end,
			--width = "full",
		}
		curOrder = curOrder + 1
	end
	]=]
	tab.sortOpt.args.ItemSort = {
		type = "select",
		name = AL["Item Sort:"],
		--desc = ,
		values = {},
		order = curOrder,
		width = "full",
		get = function(info)
			return sortFunctions.itemSort[self:GetConfigValue("itemSort")].index
		end,
		set = function(info, value)
			self:SetConfigValue("itemSort", sortFunctions.itemSortIndex[value][1])
			return value
		end,
	}
	curOrder = curOrder + 1
	for k,v in ipairs(sortFunctions.itemSortIndex) do
		tab.sortOpt.args.ItemSort.values[k] = v[2]
		if self:GetConfigValue("itemSort") == v[1] then
			if v.itemSubSort then
				local optTab = self:GetConfigValue("itemSubSort")
				for k2,v2 in ipairs(v.itemSubSort) do
					if sortFunctions.itemSubSort[v2] then
						tab.sortOpt.args[v[2].."-"..v2] = {
							type = "toggle",
							name = sortFunctions.itemSubSort[v2][1],
							--desc = v2[2],
							order = curOrder,
							get = function(info)
								return self:GetConfigValue("itemSubSort."..v2)
							end,
							set = function(info, value)
								self:SetConfigValue("itemSubSort."..v2, value)
								return self:GetConfigValue("itemSubSort."..v2, value)
							end,
							--width = "full",
						}
						curOrder = curOrder + 1
					end
				end
			end
		end
	end
	
	return tab.sortOpt
end

-- creats/resets the AtlasLoot_Data[name] loottable
function LootTableSort:Preparing_SortTable()
	if not AtlasLoot_Data[self.name] then AtlasLoot_Data[self.name] = {} end
	if not self.lootpage then self.lootpage = AtlasLoot_Data[self.name] end
	wipe(AtlasLoot_Data[self.name])
	cacheTable = {}
	AtlasLoot_Data[self.name]["Normal"] = {{}}
	AtlasLoot_Data[self.name].info = {
		name = self.name,
	}
	return AtlasLoot_Data[self.name]
end

local function SortTableIni(t, f)
	local a = {}
	local a2 = {}
	for k,v in pairs(t) do 
		if not a2[v[2]] then
			a[#a + 1] = v[2]
			a2[v[2]] = k
		end
	end
	
	table.sort(a, f)
	local i = 0
	return function()
		i = i + 1
		return a2[a[i]], t[a[i]]
	end
end

local function SortTableBoss(t, f)
	local a = {}
	local a2 = {}
	for k,v in pairs(t) do 
		if not a2[v[1]] then
			a[#a + 1] = v[1]
			a2[v[1]] = k
		end
	end
	table.sort(a, function(n1,n2)
		return lootTableTypesIndex[gsub(a2[n1], "(.+)#", "")] < lootTableTypesIndex[gsub(a2[n2], "(.+)#", "")]
	end)
	table.sort(a, function(n1,n2)
		return gsub(n1, " %((.+)%)", "") < gsub(n2, " %((.+)%)", "")
	end)
	
	local i = 0
	return function()
		i = i + 1
		return a2[a[i]], t[a[i]]
	end
end

local function SortTableItems(t, f)
	local a = {}
	local a2 = {}
	for k,v in ipairs(t) do 
		if k ~= "INFO" then
			local itemName = ""
			if type(v[2]) == "string" then
				itemName = GetSpellInfo(v[3])
			else
				itemName = GetItemInfo(v[2])
			end
			if itemName then
				itemName = itemName
			elseif not itemName and v[4] then
				itemName = string.sub(v[4], 1, 4)
			elseif not itemName and not v[4] then
				itemName = "ERROR"..k
			end
			itemName = itemName..v[2]..k
			a[#a + 1] = itemName
			a2[itemName] = k
			
		end
	end
	table.sort(a, f)
	local i = 0
	return function()
		i = i + 1
		return a2[a[i]], t[a2[a[i]]]
	end
end
---------------------------------------
local function GetItemPriceFromTable(itemTable, itemID)
	if not itemTable or not itemID then return end
	if type(itemTable) == "string" then
		local dataID, instancePage = AtlasLoot:FormatDataID(itemTable)
		local lootTableType = AtlasLoot:GetLootTableType(itemTable)
		if AtlasLoot_Data[dataID] and AtlasLoot_Data[dataID][lootTableType] and AtlasLoot_Data[dataID][lootTableType][instancePage] then
			itemTable = AtlasLoot_Data[dataID][lootTableType][instancePage]
		end
	end
	
	if itemTable and type(itemTable) == "table" then
		local price
		for k,v in ipairs(itemTable) do
			if v[2] == itemID or v[3] == itemID then
				price = v[6]
				break
			end
		end
	end
	return price or ""
end

function LootTableSort:ShowSortedTable(name, tab, itemType)
	self.lootpage = self:Preparing_SortTable()
	self.lootpage.info.name = name or self.name
	-- Menü button
	-- { 18, "CraftedWeapons", "INV_Sword_1H_Blacksmithing_02", AL["Crafted Epic Weapons"], ""};
	-- Item button
	-- { 2, 27410, "", "=q3=Collar of Command", "=ds=#s1#, #a1#", "", "13.00%"};
	-- Wishlist entry
	-- {0, 53114, "", "=q4=Gloaming Sark", "=ds=#s5#, #a2#", "Halion", "Normal", }, -- [1]
	cacheTable["INFO"] = {
		tableInfos = {},
		iniSortOrder = {},
		bossSortOrder = {},
		itemSortOrder = {},
	}
	cacheTable.lootTable = {}
	-- Setup table infos, get bossName, instanceName from dataID
	for index,item in ipairs(tab) do
		local bossName, instanceName = AtlasLoot:GetTableInfo(item[6], false, true, false, true)
		local bossNameOnly = AtlasLoot:GetTableInfo(item[6])
		if string.find(item[6], "#Heroic") and not string.find(bossName, AtlasLoot:GetLocInstanceType("Heroic")) then
			bossName = bossName.." ("..AtlasLoot:GetLocInstanceType("Heroic")..")"
		end
		cacheTable["INFO"].tableInfos[item[6]] = { bossName or "", instanceName or "", bossNameOnly }
	end
	
	-- Instance sort
	for ini in SortTableIni(cacheTable["INFO"].tableInfos) do
		cacheTable["INFO"].iniSortOrder[#cacheTable["INFO"].iniSortOrder + 1] = ini
	end
	-- Boss sort
	for boss in SortTableBoss(cacheTable["INFO"].tableInfos) do
		cacheTable["INFO"].bossSortOrder[#cacheTable["INFO"].bossSortOrder + 1] = boss
	end
	-- Item sort
	for item in SortTableItems(tab) do
		cacheTable["INFO"].itemSortOrder[#cacheTable["INFO"].itemSortOrder + 1] = item
	end
	-- PreSort all
	if self[self:GetConfigValue("tableSort")] then
		self[self:GetConfigValue("tableSort")](self, tab)
	else
		self:SetConfigValue("tableSort", nil)
		if self[self:GetConfigValue("tableSort")] then
			self[self:GetConfigValue("tableSort")](self, tab)
		else
			return
		end
	end
	
	local tablePage, tablePos = 1, 1
	for iniSort,ini in ipairs(cacheTable.lootTable) do
		for bossSort,boss in ipairs(ini) do
			if boss["INFO"] and boss["INFO"][1] and boss["INFO"][2] and boss["INFO"][3] then
				if tablePos > 1 then
					tablePos = tablePos + 1
				end
				if tablePos+#boss+2 > 15 and tablePos < 16 then
					tablePos = 16
				end
				if tablePos+#boss+2 > 30 then
					tablePos = 1
					tablePage = tablePage + 1
					if not self.lootpage["Normal"][tablePage] then self.lootpage["Normal"][tablePage] = {} end
				end
				self.lootpage["Normal"][tablePage][#self.lootpage["Normal"][tablePage] + 1] = { tablePos, boss["INFO"][3], "INV_Box_01", boss["INFO"][2], "=q5="..boss["INFO"][1], ""}
				tablePos = tablePos + 1
			end
			for itemSort,item in ipairs(boss) do
				if tab[item] and tab[item][3] and type(tab[item][3]) == "string" and tab[item][3] ~= "" then
					spell = "s"..tab[item][3]
					self.lootpage["Normal"][tablePage][#self.lootpage["Normal"][tablePage] + 1] = { tablePos, spell, tab[item][2], tab[item][4], tab[item][5], GetItemPriceFromTable(boss["INFO"][3], tab[item][2]), type = itemType}
				elseif tab[item] and tab[item][2] and type(tab[item][2]) == "string" and tab[item][2] ~= "" then
					spell = "s"..tab[item][3]
					self.lootpage["Normal"][tablePage][#self.lootpage["Normal"][tablePage] + 1] = { tablePos, spell, tab[item][2], tab[item][4], tab[item][5], GetItemPriceFromTable(boss["INFO"][3], tab[item][2]), type = itemType}
				elseif tab[item] and tab[item][2] then
					self.lootpage["Normal"][tablePage][#self.lootpage["Normal"][tablePage] + 1] = { tablePos, tab[item][2], "", tab[item][4], tab[item][5], GetItemPriceFromTable(boss["INFO"][3], tab[item][2]), type = itemType}
				end
				tablePos = tablePos + 1
				if tablePos > 30 then
					tablePos = 1
					tablePage = tablePage + 1
					if not self.lootpage["Normal"][tablePage] then self.lootpage["Normal"][tablePage] = {} end
				end	
			end
		end
	end
	
	cacheTable = nil
	AtlasLoot:ShowLootPage(self.name)
end

--[[ cacheTable.lootTable format
	cacheTable.lootTable = {
		{
			{
				item1,
				item2,
				...
				["INFO"] = { BossName, loottable },
			}
			["INFO"] = iniName,
		},
	
	
	}
]]--
--local iniSort, bossSort, itemSort = 0, 0, 0

function LootTableSort:SortByInstance(tab)
	if not cacheTable then return end
	local iniSort, bossSort, itemSort = 0, 0, 0
	
	for _,ini in ipairs(cacheTable["INFO"].iniSortOrder) do
		iniSort = #cacheTable.lootTable + 1
		bossSort = 0
		cacheTable.lootTable[iniSort] = {
			["INFO"] = cacheTable["INFO"].tableInfos[ini][2],
		}
		for _,boss in ipairs(cacheTable["INFO"].bossSortOrder) do
			if cacheTable["INFO"].tableInfos[ini][2] == cacheTable["INFO"].tableInfos[boss][2] then
				itemSort = 0
				bossSort = #cacheTable.lootTable[iniSort] + 1
				cacheTable.lootTable[iniSort][bossSort] = {
					["INFO"] = { cacheTable["INFO"].tableInfos[ini][2], cacheTable["INFO"].tableInfos[boss][1], boss },
				}
				for itemOrdOr,item in ipairs(cacheTable["INFO"].itemSortOrder) do
					if tab[item][6] == boss then
						itemSort = #cacheTable.lootTable[iniSort][bossSort] + 1
						cacheTable.lootTable[iniSort][bossSort][itemSort] = item --tab[item]-
					end
				end
			end
		end
	end
	
end

function LootTableSort:SortByBoss(tab)
	if not cacheTable then return end
	local bossSort, itemSort = 0, 0
	
	cacheTable.lootTable[1] = {}
	for _,boss in ipairs(cacheTable["INFO"].bossSortOrder) do
		bossSort = #cacheTable.lootTable[1] + 1
		itemSort = 0
		cacheTable.lootTable[1][bossSort] = {
			["INFO"] = { cacheTable["INFO"].tableInfos[boss][2], cacheTable["INFO"].tableInfos[boss][1], boss },
		}
		for _,item in ipairs(cacheTable["INFO"].itemSortOrder) do
			if tab[item][6] == boss then
				itemSort = #cacheTable.lootTable[1][bossSort] + 1
				cacheTable.lootTable[1][bossSort][itemSort] = item --tab[item]
			end
		end
	end
end

function LootTableSort:SortByNone(tab)
	if not cacheTable then return end
	local bossSort, itemSort = 0, 0
	
	cacheTable.lootTable[1] = {
		{
			["INFO"] = { nil, nil, nil },
		}
	}
	for _,item in ipairs(cacheTable["INFO"].itemSortOrder) do
		itemSort = #cacheTable.lootTable[1][1] + 1
		cacheTable.lootTable[1][1][itemSort] = item --tab[item]
	end

end








