--[[
	Filter structure:
	 = {
		nameFilter = "A",
		exclusiveFilter = true,
		maxLvl = 10,
		minLvL = 1,
		race = {
			["Tauren"] = true,
		},
		class = {
			["DEATHKNIGHT"] = true,
		},
	}




]]

local function AddFilter(filter)
	tinsert(SGI_DATA[SGI_DATA_INDEX].settings.filters, filter);
end

function SGI:CreateFilter(nameOfFilter,class, name, minLvl, maxLvl, race, maxVowels, maxConsonants, active)
	
	if (not nameOfFilter) then
		return;
	end
	
	local filter = {
		nameOfFilter = nameOfFilter,
		race = race,
		class = class,
		name = name,
		minLvl = minLvl,
		maxLvl = maxLvl,
		maxVowels = maxVowels,
		maxConsonants = maxConsonants,
		active = active,
	}
	
	AddFilter(filter);
end

function SGI:RemoveFilter(filterName)

end

local function GetMaxNumberConsequtiveVowels(word)
	
	local vowels = {
		["a"] = 1,
		["o"] = 1,
		["u"] = 1,
		["y"] = 1,
		["i"] = 1,
		["e"] = 1,
	}
	local c = 0;
	local max = 0;
	for i = 1, strlen(word) do
		if (vowels[strsub(word, i, i)]) then
			c = c + 1;
		else
			c = 0;
		end
		if (c > max) then
			max = c;
		end
	end
	
	return max;
	
end

local function GetMaxNumberConsequtiveConsonants(word)
	local vowels = {
		["a"] = 1,
		["o"] = 1,
		["u"] = 1,
		["y"] = 1,
		["i"] = 1,
		["e"] = 1,
	}
	local c = 0;
	local max = 0;
	for i = 1, strlen(word) do
		if (vowels[strsub(word, i, i)]) then
			c = 0;
		else
			c = c + 1;
		end
		if (c > max) then
			max = c;
		end
	end
	
	return max;
end

function SGI:TestCharacters(word)
	local V = GetMaxNumberConsequtiveVowels(word);
	local C = GetMaxNumberConsequtiveConsonants(word);
	
	SGI:print("Vowels: "..V.." Consonants: "..C);
end

local function debugPlayer(player)
	local text = "|cff"..SGI:GetClassColor(player.class)..player.name.."|r ("..player.level..") ("..player.race..")";
	return text
end

local function match(filter, player)
	
	--Is this filter for the players class/race?
	if (type(filter.race) == "table" and SGI:CountTable(filter.race) ~= 0) then
		if (not filter.race[player.race]) then
			return false;
		end
	end
	
	if (type(filter.class) == "table" and SGI:CountTable(filter.class) ~= 0) then
		if (not filter.class[player.class]) then
			return false;
		end
	end
	
	-- Is the player within the level range?
	if (type(filter.minLvl) == "number") then
		if (filter.minLvl > player.level) then
			return false;
		end
	end
	
	if (type(filter.maxLvl) == "number") then
		if (filter.maxLvl < player.level) then
			return false;
		end
	end
	
	if (type(filter.name) == "string" and filter.name ~= "") then
		if not (strfind(player.name,filter.name)) then
			return false;
		end
	end
	
	if (type(filter.maxVowels) == "number") then
		if (filter.maxVowels >= GetMaxNumberConsequtiveVowels(player.name)) then
			return false;
		end
	end
	
	if (type(filter.maxConsonants) == "number") then
		if (filter.maxConsonants >= GetMaxNumberConsequtiveConsonants(player.name)) then
			return false;
		end
	end
	
	SGI:debug("Filter: "..filter.nameOfFilter.." "..debugPlayer(player));
	return true;
	
end

local function GetActiveFilters()
	local filters, activeFilters = SGI_DATA[SGI_DATA_INDEX].settings.filters, {};
	if (type(filters) ~= "table") then 
		return {};
	end
	for k,_ in pairs(filters) do
		if (filters[k]["active"]) then
			activeFilters[k] = filters[k];
		end
	end
	return activeFilters;
end

function SGI:FilterPlayer(player)
	local filters = GetActiveFilters();--SGI_DATA[SGI_DATA_INDEX].settings.filters;
	
	if (type(filters) ~= "table" or type(player) ~= "table") then
		--if invalid parameter, return as filtered
		SGI:debug("Error: Filter or player is not a table!");
		return false;
	end
	
	for k,_ in pairs(filters) do
		if (match(filters[k], player)) then
			return false;
		end
	end

	return true;
	
end















SGI:debug(">> Filter.lua");