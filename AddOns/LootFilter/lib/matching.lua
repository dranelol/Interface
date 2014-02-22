function LootFilter.matchProperties(key, value, item, keep)
	local reason = "";
	_, _, item["rarity"], _, _, item["type"], item["subType"], _ = GetItemInfo(item["id"]);
	
--[[	if (LootFilter.openItemIfContainer(item)) then -- check if this is a container item we need to open
		return LootFilter.Locale.LocText["LTTryopen"];
	end; --]]
	
	if (string.match(key, "^QU")) then -- quality entry
		if (item["rarity"] == value) then
			reason = LootFilter.Locale.LocText["LTQualMatched"].." ("..value..")";
		elseif (value == -1) then
			if (string.lower(item["type"]) == LootFilter.Locale.LocText["LTQuest"]) then
				reason = LootFilter.Locale.LocText["LTQuestItem"];
			end;
		end;
	elseif (string.match(key, "^TY")) then -- type entry

		if (string.match(key, "^TY"..item["type"])) and (item["subType"] == value) then
			
			reason = LootFilter.Locale.LocText["LTTypeMatched"].." ("..value..")";
		end;
	elseif (string.match(key, "^VA")) then -- value entry
		if (GetSellValue) and (LootFilterVars[LootFilter.REALMPLAYER].novalue) and ((item["value"] == nil) or (item["value"] <= 0)) then
			reason = LootFilter.Locale.LocText["LTNoKnownValue"];
		elseif (GetSellValue) then
			local calculatedValue;
			if (LootFilterVars[LootFilter.REALMPLAYER].calculate == 1) then
				calculatedValue = tonumber(item["value"]);
			elseif (LootFilterVars[LootFilter.REALMPLAYER].calculate == 2) then
				calculatedValue = tonumber(item["value"]*item["amount"]);
			else
				calculatedValue = tonumber(item["value"]*item["stack"]);
			end;
			if (keep) and (LootFilterVars[LootFilter.REALMPLAYER].keepList["VAOn"]) then
				if (calculatedValue > tonumber(LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"])) then
					reason = LootFilter.Locale.LocText["LTValueHighEnough"].." ("..calculatedValue..")";
				end;
			elseif (not keep) and ((LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAOn"])) then
				if (calculatedValue < tonumber(LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"])) then
					reason= LootFilter.Locale.LocText["LTValueNotHighEnough"].." ("..calculatedValue..")";
				end;					
			end;
		end;
	elseif (key == "names") then
		for _, name in pairs(value) do
			if (LootFilter.matchItemNames(item, name)) then
				reason = LootFilter.Locale.LocText["LTNameMatched"].." ("..name..")";
				break;
			end;
		end;
	end;
	return reason;	
end;

-- match properties of item against keep properties that have been configured by the user
function LootFilter.matchKeepProperties(item)
	local reason = "";

	for key, value in pairs(LootFilterVars[LootFilter.REALMPLAYER].keepList) do -- cycle through the keep list
		reason = LootFilter.matchProperties(key, value, item, true);
		if (reason ~= "") then
			return reason;
		end;
	end;
	return reason;
end;

-- match properties of item against delete properties that have been configured by the user
function LootFilter.matchDeleteProperties(item)
	local reason = "";
	for key,value in pairs(LootFilterVars[LootFilter.REALMPLAYER].deleteList) do
		reason = LootFilter.matchProperties(key, value, item, false);
		if (reason ~= "") then
			return reason;
		end;
	end;
	return reason;
end;


-- scan bags for the item and return x (bag), y (slot)
function LootFilter.findItemInBags(item)
	local x, y;
	local containerItem = {};
	item["bag"] = -1;
	item["slot"] = -1;
	item["count"] = 0;
	
	for j=0 , 4 , 1 do
		if (LootFilterVars[LootFilter.REALMPLAYER].openbag[j]) then -- only search this bag if it has been selected
			x = GetContainerNumSlots(j);
			for i=0 , x , 1 do
				containerItem["link"]= GetContainerItemLink(j,i);
				if (containerItem["link"] ~= nil) then
					containerItem["name"] = LootFilter.getNameOfItem(containerItem["link"]);
					containerItem["id"] = LootFilter.getIdOfItem(containerItem["link"]);
					if (containerItem["id"] >= 1) then
						if (LootFilter.matchItemNames(item, containerItem["name"])) then
							item["bag"] = j;
							item["slot"] = i;
							return item;
							-- item["count"] = item["count"] + 1;
						end;
					end;
				end;
			end;
		end;
	end;
	return item;
end;

-- match item names (case insensitive)
function LootFilter.matchItemNames(item, searchName)
	if (item["name"] == nil) or (searchName == nil) then
		return false;
	end;
	local oldErr = geterrorhandler();
	local errH = function(msg)
		seterrorhandler(oldErr);
		error(string.format("Error: %s. searchName: %s item[\"name\"]: %s.", tostring(searchName), tostring(item["name"])), 3);
	end;
	seterrorhandler(errH);
	
	searchName, comment= LootFilter.stripComment(searchName);
	
	if (string.find(searchName, "##", 1, true) == 1) then
		if (item["info"] ~= nil) then
			if (string.find(string.lower(item["info"]), string.lower(string.sub(searchName, 3)))) then
				seterrorhandler(oldErr);
				return true;
			end;
		end;
	elseif (string.find(searchName, "#", 1, true) == 1) then
		if (string.find(string.lower(item["name"]), string.lower(string.sub(searchName, 2)))) then
			seterrorhandler(oldErr);
			return true;
		end;
	elseif (string.lower(item["name"]) == string.lower(searchName)) then
		seterrorhandler(oldErr);
		return true;
	end;
	seterrorhandler(oldErr);
	return false;
end;