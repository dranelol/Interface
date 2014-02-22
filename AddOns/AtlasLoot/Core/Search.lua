local AtlasLoot = LibStub("AceAddon-3.0"):GetAddon("AtlasLoot")

local GREY = "|cff999999";
local RED = "|cffff0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff1eff00";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";

local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");
local modules = { "AtlasLoot_BurningCrusade", "AtlasLoot_Crafting", "AtlasLoot_OriginalWoW", "AtlasLoot_WorldEvents", "AtlasLoot_WrathoftheLichKing" };
local currentPage = 1;
local SearchResult = nil;
local lootTableTypes = {"Normal", "Heroic", "25Man", "25ManHeroic"}
local searchCache = ""
local searchTableSort
AtlasLoot_Data["SearchResult"] = {
	
}

function AtlasLoot:ShowSearchResult()
	if AtlasLoot.db.profile.LastSearch ~= "" then
		AtlasLoot.SearchBox:SetText(AtlasLoot.db.profile.LastSearch)
		AtlasLoot.SearchBox:ClearFocus() 
		AtlasLoot:Search(AtlasLoot.db.profile.LastSearch)
	end
end

function AtlasLoot:Search(Text)
	if not Text then return end
	if Text then
		--print("AtlasLoot search is temporary disabled")
		--return
	end
	Text = strtrim(Text);
	if Text == "" then return end
	if string.lower(Text) == string.lower(searchCache) then return end
	searchCache = Text
	local searchResult = {}
	AtlasLoot.db.profile.LastSearch = Text
	-- Decide if we need load all modules or just specified ones
	AtlasLoot:LoadModule("all")
	
	---if AtlasLoot_Data["SearchResult"] then
	--	wipe(AtlasLoot_Data["SearchResult"])
	--else
	--	AtlasLoot_Data["SearchResult"] = {}
	--end
	--AtlasLootCharDB.LastSearchedText = Text;
    
	local text = string.lower(Text);
	text = gsub(text, "-", "")
    --[[if not self.db.profile.SearchOn.All then
        local module = AtlasLoot_GetLODModule(dataSource);
        if not module or self.db.profile.SearchOn[module] ~= true then return end
    end]]
	for dataID, data in pairs(AtlasLoot_Data) do
		for _,tableType in ipairs(lootTableTypes) do
			if data[tableType] and not AtlasLoot.IgnoreList[dataID] then
				for _,itemTable in ipairs(data[tableType]) do
					for itemNum,item in ipairs(itemTable) do
						if type(item[2]) == "number" and item[2] > 0 then
							local itemName = GetItemInfo(item[2]);
							if not itemName then itemName = gsub(item[4], "=q%d=", "") end
							itemName = gsub(itemName, "-", "")
							local found = string.find(string.lower(itemName), text)
							if found then
								local heroicCheckNumber = AtlasLoot:CheckHeroic(itemTable)
								if heroicCheckNumber and heroicCheckNumber < itemNum then
									tableType = "Heroic"
								end
								table.insert(searchResult, { 0, item[2], item[3], item[4], item[5], dataID.."#"..tableType })
							end
						elseif (item[2] ~= nil) and (item[2] ~= "") and type(item[2]) == "string" and (string.sub(item[2], 1, 1) == "s") then 
							local spellName = GetSpellInfo(string.sub(item[2], 2))
							if not spellName then
								if (string.sub(item[4], 1, 2) == "=d") then  
									spellName = gsub(item[4], "=ds=", "");
								else
									spellName = gsub(item[4], "=q%d=", ""); 
								end
							end
							spellName = gsub(spellName, "-", "")
							local found = string.find(string.lower(spellName), text)
							if found then
								local spellID = string.sub(item[2], 2)
								local found = string.find(string.lower(spellName), text)
								table.insert(searchResult, { 0, tonumber(spellID), item[3], item[4], item[5], dataID.."#"..tableType })
							end
						end
					end
				end
			end
		end
	end
	
	if #searchResult < 0 then
		DEFAULT_CHAT_FRAME:AddMessage(RED..AL["AtlasLoot"]..": "..WHITE..AL["No match found for"].." \""..Text.."\".");
	else
		if not searchTableSort then
			searchTableSort = AtlasLoot:AddLootTableSort("ATLASLOOT_SEARCH")
			--searchTableSort:SetConfigTable()
		end
		searchTableSort:ShowSortedTable(Text, searchResult)
		--AtlasLoot:CreateFormatedLootPage(searchResult)
	end
	searchResult = nil
	collectgarbage("collect")
end