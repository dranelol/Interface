

LootFilterVars = {
};

 
LootFilter = {
	VERSION = "3.0",
	LOOT_TIMEOUT = 30,
	LOOT_PARSE_DELAY = 1,
	LOOT_MAXTIME = 0,
	SCHEDULE_INTERVAL = 1;
	REALMPLAYER= "",
	NUMLINES = 10,

	timerArr= {},
	hooked= false,
	lastUpdate= 0,
	hasFocus= 0;
	spellCast = false;
	cleanList = {};
};

function LootFilter.print(value)
	if (value == nil) then
		value= "";
	end;
	DEFAULT_CHAT_FRAME:AddMessage("Loot Filter - "..value, 1.0, 1.0, 1.0);	
end;

function LootFilter.debug(value)
	if (value == nil) then
		value= "";
	end;
	DEFAULT_CHAT_FRAME:AddMessage("Loot Filter - DEBUG: "..value, 1.0, 1.0, 1.0);
end;

function LootFilter.report(value)
	if (LootFilterVars[LootFilter.REALMPLAYER].report) then
		LootFilter.print(value);
	end;
end;

function LootFilter.schedule(delay, func, ...)
	local args = {};
	for i = 1, select("#", ...) do
		args[i] = select(i, ...);
	end;
	table.insert(LootFilter.timerArr, {time=time()+delay, func=func, args=args});
	if (not LootFilter.hooked) then
		LootFilter.hook();
	end;
end;

-- borrowed from Informant (local function)
function LootFilter.split(str, at)
	if (not (type(str) == "string")) then
		return
	end

	if (not str) then
		str = ""
	end

	if (not at) then
		return {str}
	else
		return {strsplit(at, str)};
	end
end


function LootFilter.WorldFrame_OnUpdate()
	Original_WorldFrame_OnUpdate();
	local curtime= time();
	if (LootFilter.lastUpdate < curtime) then
		if (table.getn(LootFilter.timerArr) == 0) then
			LootFilter.unhook();
			return;
		end;
		for i=1, table.getn(LootFilter.timerArr), 1 do
			if (LootFilter.timerArr[i].time <= curtime) then
				func= LootFilter.timerArr[i].func;
				args= LootFilter.timerArr[i].args;
				table.remove(LootFilter.timerArr,i);

				if (table.getn(args) == 0) then
					func();
				elseif (table.getn(args) == 1) then
					func(args[1]);
				elseif (table.getn(args) == 2) then
					func(args[1], args[2]);
				end;
				return;
			end;
		end;
		LootFilter.lastUpdate= curtime+1;
	end;
end;

function LootFilter.hook()
	Original_WorldFrame_OnUpdate= WorldFrame_OnUpdate;
	WorldFrame_OnUpdate= LootFilter.WorldFrame_OnUpdate;
	LootFilter.hooked= true;
end;

function LootFilter.unhook()
	WorldFrame_OnUpdate= Original_WorldFrame_OnUpdate;
	LootFilter.hooked= false;
end;

function LootFilter.setTitle()
	LootFilterFrameTitleText:SetText("Loot Filter v"..LootFilter.VERSION);
end;

function LootFilter.stripComment(searchName)
	local commentPos = string.find(searchName, ";", 1, true);
	if (commentPos ~= nil) and (commentPos > 0) then -- comment found
		searchName= string.sub(searchName, 0, commentPos-1);
		searchName= strtrim(searchName);
	end;
	return searchName;
end;

function LootFilter.matches(itemName, searchName)
	if (itemName == nil) or (searchName == nil) then
		return false;
	end;
	searchName= LootFilter.stripComment(searchName);
	if (string.find(searchName, "#", 1, true) == 1) then
		if (string.find(string.lower(itemName), string.lower(string.sub(searchName, 2)))) then
			return true;
		end;
	elseif (string.lower(itemName) == string.lower(searchName)) then
		return true;
	end;
	return false;
end;

function LootFilter.openIfContainer(j, i, itemlink)
	local itemName = LootFilter.getItemName(itemlink);
	for key,value in pairs(LootFilterVars[LootFilter.REALMPLAYER].openList) do
		if (LootFilter.matches(itemName, value)) then
			if (not LootFilter.spellCast) then	
				if (LootFilterVars[LootFilter.REALMPLAYER].notifyopen) then
					LootFilter.print(LootFilterLocale.LocText["LTTryopen"].." "..itemlink.." : "..LootFilterLocale.LocText["LTNameMatched"].." ("..value..")");
				end;
				UseContainerItem(j, i);
				return true;
			end;
			LootFilter.LOOT_MAXTIME = time() + LootFilter.LOOT_TIMEOUT;
			return true;
		end;
	end;
	return false;
end;

function LootFilter.getValueOfItem(itemid)
	local itemValue = -1;
	if (GetSellValue) then
		itemValue = GetSellValue(itemid);
		if (itemValue == nil) then
			itemValue = -1;
		end;
	end;
	if (itemValue ~= -1) then
		local _, _, _, _, _, _, _, sc = GetItemInfo(itemid)
		if (sc ~= nil) then
			itemValue = tonumber(sc) * tonumber(itemValue);
		end;
	end;
	return itemValue;
end;

function LootFilter.getItemId(itemLink)
	return tonumber(string.match(itemLink, ":(%d+)"));
end;

function LootFilter.getItemName(itemLink)
	return string.match(itemLink, "%[(.*)%]");
end;

function LootFilter.deleteItemFromInventory(searchItem, search, deleteItem)
	local searchName= LootFilter.getItemName(searchItem);
	for j=0 , 4 , 1 do
		if (LootFilterVars[LootFilter.REALMPLAYER].openbag[j]) then
			x = GetContainerNumSlots(j);
			for i=0 , x , 1 do
				local itemlink= GetContainerItemLink(j,i);
				if (itemlink ~= nil) then
					local itemName = LootFilter.getItemName(itemlink);
					local itemid = LootFilter.getItemId(itemlink);
					if (itemid >= 1) then
						if LootFilter.matches(itemName, searchName, "") then
							local reason = "";
							if (deleteItem == "") then
								if (LootFilter.openIfContainer(j, i, itemlink)) and (not search) then
									return false;
								end;
								local _, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount = GetItemInfo(itemid)
								local keep = false;
								for key,value in pairs(LootFilterVars[LootFilter.REALMPLAYER].keepList) do
									if (string.match(key, "^QU")) then -- quality entry
										if (itemRarity == value) then
											reason = ""..LootFilterLocale.LocText["LTQualMatched"].." ("..value..")";
											keep = true;
										elseif (value == -1) then
											if (string.lower(itemType) == LootFilterLocale.LocText["LTQuest"]) then
												reason= LootFilterLocale.LocText["LTQuestItem"];
												keep = true;
											end;
										end;
									elseif (string.match(key, "^TY")) then -- type entry
										if (itemSubType == value) then
											reason= LootFilterLocale.LocText["LTTypeMatched"].." ("..value..")";
											keep = true;
										end;
									elseif (string.match(key, "^VA")) then -- value entry
										if (GetSellValue) and (LootFilterVars[LootFilter.REALMPLAYER].keepList["VAOn"]) then
											local itemValue = LootFilter.getValueOfItem(itemid);

											if ((itemValue == nil) or (itemValue <= 0)) then
												reason= LootFilterLocale.LocText["LTNoKnownValue"];
												keep= true;
											elseif (itemValue ~= nil) and (itemValue > 0) then
												itemValue= tonumber(itemValue / 10000);
												if (tonumber(itemValue) > tonumber(LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"])) then
													reason= LootFilterLocale.LocText["LTValueHighEnough"].." ("..tonumber(itemValue)..")";
													keep = true;
												end;
											end;	
										end;
									elseif (key == "names") then
										for _, name in pairs(value) do
											if (LootFilter.matches(searchName, name)) then
												reason= LootFilterLocale.LocText["LTNameMatched"].." ("..name..")";
												keep = true;
												break;
											end;
										end;
									end;
									if (keep) then
										if (not search) then
											if (LootFilterVars[LootFilter.REALMPLAYER].notifykeep) then
												LootFilter.print(itemlink.." "..LootFilterLocale.LocText["LTKept"]..": "..reason);
											end;
											table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
											return true;
										else
											return false;
										end;
									end;
								end;
								
								if (LootFilterVars[LootFilter.REALMPLAYER].caching) and (not search) then
									table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
									return;
								end;

								local delete = false;
								for key,value in pairs(LootFilterVars[LootFilter.REALMPLAYER].deleteList) do
									if (string.match(key, "^QU")) then -- quality entry
										if (itemRarity == value) then
											reason= LootFilterLocale.LocText["LTQualMatched"].." ("..value..")";
											delete = true;
										elseif (value == -1) then
											if (string.lower(itemType) == LootFilterLocale.LocText["LTQuest"]) then
												reason= LootFilterLocale.LocText["LTQuestItem"];
												delete = true;
											end;
										end;
									elseif (string.match(key, "^TY")) then -- type entry
									if (itemSubType == value) then
											reason= LootFilterLocale.LocText["LTTypeMatched"].." ("..value..")";
											delete = true;
										end;
									elseif (string.match(key, "^VA")) then -- value entry
										if (GetSellValue) and (LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAOn"]) then
											local itemValue = LootFilter.getValueOfItem(itemid);

											if ((itemValue == nil) or (itemValue <= 0)) then
												reason= LootFilterLocale.LocText["LTNoKnownValue"];
												break;
											elseif (itemValue ~= nil) and (itemValue > 0) then
												itemValue= tonumber(itemValue / 10000);
												if (tonumber(itemValue) < tonumber(LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"])) then
													reason= LootFilterLocale.LocText["LTValueNotHighEnough"].." ("..tonumber(itemValue)..")";
													delete = true;
												end;
											end;	
										end;
									elseif (key == "names") then
										for _, name in pairs(value) do
											if (LootFilter.matches(searchName, name)) then
												reason= LootFilterLocale.LocText["LTNameMatched"].." ("..name..")";
												delete = true;
												break;
											end;
										end;
									end;
									if (delete) then
										break;
									end;
								end;

								if (search) then
									return delete;
								end;

								if (not delete) then
									if (reason == "") then
										if (LootFilterVars[LootFilter.REALMPLAYER].notifynomatch) then
											LootFilter.print(itemlink.." "..LootFilterLocale.LocText["LTKept"]..": "..LootFilterLocale.LocText["LTNoMatchingCriteria"]);
										end;
									else
										if (LootFilterVars[LootFilter.REALMPLAYER].notifykeep) then
											LootFilter.print(itemlink.." "..LootFilterLocale.LocText["LTKept"]..": "..reason);
										end;
									end;
									table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
									return true;
								end;
							else
								reason = deleteItem;
							end;

							if (not search) then
								if (deleteItem == "cleaning") and (LootFilterButtonDeleteItems:GetText() == "Sell items") then
									UseContainerItem(j,i);
									table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
									if (LootFilterVars[LootFilter.REALMPLAYER].notifydelete) then
										LootFilter.print(itemlink.." "..LootFilterLocale.LocText["LTWasSold"]..": "..reason);
										if (LootFilter.questUpdateToggle == 1) then
											LootFilter.lastDeleted = itemName; 
										end;
									end;
									return true;
								else
									PickupContainerItem(j, i);
									if (CursorHasItem()) then
										DeleteCursorItem();
										table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
										if (LootFilterVars[LootFilter.REALMPLAYER].notifydelete) then
											LootFilter.print(itemlink.." "..LootFilterLocale.LocText["LTWasDeleted"]..": "..reason);
											if (LootFilter.questUpdateToggle == 1) then
												LootFilter.lastDeleted = itemName; 
											end;
										end;
										return true;
									else
										return false;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
	return false;
end

function LootFilter.findItems()
	numitems= table.getn(LootFilterVars[LootFilter.REALMPLAYER].itemStack);
	if (numitems == 0) then
		return;
	end;

	if (time() > LootFilter.LOOT_MAXTIME) then
		LootFilterVars[LootFilter.REALMPLAYER].itemStack = {};
		return;
	end;

	if (not LootFilter.deleteItemFromInventory(LootFilterVars[LootFilter.REALMPLAYER].itemStack[1], false, "")) then
		if (table.getn(LootFilterVars[LootFilter.REALMPLAYER].itemStack) > 1) then
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].itemStack, LootFilterVars[LootFilter.REALMPLAYER].itemStack[1]);
			table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
		end;
	end;
	LootFilter.schedule(LootFilter.SCHEDULE_INTERVAL, LootFilter.findItems);
end

function LootFilter.getNames()
	local result= '';
	table.sort(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]);
	for key, value in ipairs(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]) do
		result= result..value.."\n";	
	end;
	LootFilterEditBox1:SetText(result);
end;

function LootFilter.getNamesDelete()
	local result= "";
	table.sort(LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"]);
	for key, value in ipairs(LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"]) do
		result= result..value.."\n";
	end;
	LootFilterEditBox2:SetText(result);
end;

function LootFilter.getOpenNames()
	local result= "";
	table.sort(LootFilterVars[LootFilter.REALMPLAYER].openList);
	for key, value in ipairs(LootFilterVars[LootFilter.REALMPLAYER].openList) do
		result= result..value.."\n";	
	end;
	LootFilterEditBoxOpen:SetText(result);
end;

function LootFilter.setNames()
	LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]= {};
	local result= LootFilterEditBox1:GetText().."\n";
	if (result ~= nil) then
		for w in string.gmatch(result, "[^\n]+\n") do
			w = string.gsub(w, "\n", "");
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"], w);
		end;
	end;
end;

function LootFilter.setNamesDelete()
	LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"]= {};
	local result= LootFilterEditBox2:GetText().."\n";
	if (result ~= nil) then
		for w in string.gmatch(result, "[^\n]+\n") do
			w = string.gsub(w, "\n", "");
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"], w);
		end;
	end;
end;

function LootFilter.setOpenNames()
	LootFilterVars[LootFilter.REALMPLAYER].openList= {};
	local result= LootFilterEditBoxOpen:GetText().."\n";
	if (result ~= nil) then
		for w in string.gmatch(result, "[^\n]+\n") do
			w = string.gsub(w, "\n", "");
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].openList, w);
		end;
	end;
end;

function LootFilter.setItemValue()
	local value= tonumber(LootFilterEditBox3:GetText());
	if (value == nil) or (value == "") then
		value= "0";
	end;
	LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"]= value;

	local value= tonumber(LootFilterEditBox4:GetText());
	if (value == nil) or (value == "") then
		value= "0";
	end;
	LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"]= value;

	local value= tonumber(LootFilterEditBox5:GetText());
	if (value == nil) or (value == "") then
		value= "0";
	end;
	LootFilterVars[LootFilter.REALMPLAYER].freebagslots= value;
end;

function LootFilter.getItemValue()
	local value= "";
	if (LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"] ~= nil) and (LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"] ~= "") then
		value= LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"];
	else
		value= "0";
	end;
	LootFilterEditBox3:SetText(value);
	local value= "";
	if (LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"] ~= nil) and (LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"] ~= "") then
		value= LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"];
	else
		value= "0";
	end;
	LootFilterEditBox4:SetText(value);
	local value= "";
	if (LootFilterVars[LootFilter.REALMPLAYER].freebagslots ~= nil) and (LootFilterVars[LootFilter.REALMPLAYER].freebagslots ~= "") then
		value= LootFilterVars[LootFilter.REALMPLAYER].freebagslots;
	else
		value= "0";
	end;
	LootFilterEditBox5:SetText(value);
end;

function LootFilter.command(cmd)
	args= {};
	i= 1;
	for w in string.gmatch(cmd, "%w+") do
		args[i]= w;
		i= i + 1;
	end;

	if (table.getn(args) == 0) then
		if (not LootFilterOptions:IsShown()) then
			LootFilterOptions:Show();
		else
			LootFilterOptions:Hide();
		end;
		return;
	end;
end;

function LootFilter.updateFocus(num, value)
	if (value) then
		this:SetFocus();
		LootFilter.hasFocus= num;
	else
		this:ClearFocus();
		LootFilter.hasFocus= 0;
	end;
end;

function LootFilter.findItemWithLock()
	for j=0 , 4 , 1 do
		x = GetContainerNumSlots(j);
		for i=0 , x , 1 do
			local _, _, locked = GetContainerItemInfo(j,i);
			if (locked) then
				local itemlink= GetContainerItemLink(j,i);
				if (itemlink ~= nil) then
					local itemName = GetItemInfo(itemlink);
					return itemName;
				end;
			end;
		end;
	end;
	return "";
end;

function LootFilter.OnEvent()
	if (event == "RAID_ROSTER_UPDATE") then
		if (LootFilter.versionUpdate == false) then
			LootFilter.versionUpdate = true;
			math.randomseed(math.random(0,2147483647)+(GetTime()*1000)+string.len(LootFilter.REALMPLAYER));
			LootFilter.schedule(math.random(10, 60), LootFilter.sendAddonMessage, "VERSION:"..LootFilter.newVersion, 2);
		end;
		return;
	end;

	if (event == "CHAT_MSG_ADDON") then
		if (arg1 == "LootFilter") then
			local name = string.match(arg2, "(%a+):");
			local version = string.match(arg2, ":(.*)");
			if (name == "VERSION") then
				if (((arg3 == "RAID") or (arg3 == "PARTY")) and (LootFilter.versionUpdate == true)) then
					LootFilter.versionUpdate = false;
				end;
				if (tonumber(version) > tonumber(LootFilter.newVersion)) then
					LootFilter.newVersion = version;
					if (LootFilterVars[LootFilter.REALMPLAYER].notifynew) then
						LootFilter.print(LootFilterLocale.LocText["LTNewVersion1"].." ("..version..") "..LootFilterLocale.LocText["LTNewVersion2"]);
					end;
				end;
			end;
		end;
		return;
	end;

	if (event == "UNIT_SPELLCAST_START") then
		LootFilter.spellCast = true;
	end;
	if (event == "UNIT_SPELLCAST_STOP") then
		LootFilter.spellCast = false;
	end;

	if (event == "UI_INFO_MESSAGE") then
		if (LootFilterVars[LootFilter.REALMPLAYER].deleteList["QUQuest"] == nil) then
			if (string.find(arg1, "slain: ") ~= nil) and (string.find(arg1, "slain: ") > 0) then
				return;
			end;
			local itemName = gsub(arg1,"(.*): %s*([-%d]+)%s*/%s*([-%d]+)%s*$","%1",1);
			if (itemName ~= arg1) then
				for index,name in pairs(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]) do
					if (LootFilter.matches(itemName, name)) then
						return;
					end;
				end;

				for index, itemLink in pairs(LootFilterVars[LootFilter.REALMPLAYER].itemStack) do
					local name = string.match(itemLink, "%[(.*)%]");
					if (string.lower(name) == string.lower(itemName)) then
						table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, index);
						if (LootFilterVars[LootFilter.REALMPLAYER].notifykeep) then
							LootFilter.print(itemLink.." "..LootFilterLocale.LocText["LTKept"]..": "..LootFilterLocale.LocText["LTQuestItem"]);
						end;
						local _, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount = GetItemInfo(itemLink);
						if (string.lower(itemType) ~= LootFilterLocale.LocText["LTQuest"]) and (string.lower(itemSubType) ~= LootFilterLocale.LocText["LTQuest"]) then
							table.insert(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"], itemName.."  ; "..LootFilterLocale.LocText["LTAddedCosQuest"]);
						end;
						return;
					end;
				end;


				-- ***** should not ever get here if an item was looted, but keeping it in just in case i have to put it back *****
				-- table.insert(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"], itemName.."  ; Added because of quest");
				-- if (LootFilterVars[LootFilter.REALMPLAYER].notifykeep) then
				-- 	LootFilter.print(itemName.." was kept: quest item");
				-- end;
			end;
		end;
	end;
	

	if (event == "LOOT_OPENED") and (LootFilterVars[LootFilter.REALMPLAYER].enabled) then
		numitems= GetNumLootItems();
		for i=1, numitems, 1 do
			if (not LootSlotIsCoin(i)) then
				icon, name, quantity, quality= GetLootSlotInfo(i);
				if (icon ~= nil) then
					table.insert(LootFilterVars[LootFilter.REALMPLAYER].itemStack, GetLootSlotLink(i));
				end;
			end;
		end;
	end;

	if (event == "LOOT_CLOSED") then
		LootFilter.LOOT_MAXTIME = time() + LootFilter.LOOT_TIMEOUT;
		if (table.getn(LootFilter.timerArr) == 0) then
			if (LootFilterVars[LootFilter.REALMPLAYER].caching) then
				LootFilterVars[LootFilter.REALMPLAYER].itemStack = {};
				LootFilter.schedule(LootFilter.LOOT_PARSE_DELAY, LootFilter.scanBags, false);
			else
				LootFilter.schedule(LootFilter.LOOT_PARSE_DELAY, LootFilter.findItems);
			end;
		end;
	end;

	if (event == "ITEM_LOCK_CHANGED") then
		if (LootFilter.hasFocus > 0) then
			itemName= LootFilter.findItemWithLock();
			if (itemName ~= nil) and (itemName ~= "") then
				if (LootFilter.hasFocus == 1) then
					LootFilterEditBox1:SetText(LootFilterEditBox1:GetText()..itemName.."\n");
				elseif (LootFilter.hasFocus == 2) then
					LootFilterEditBox2:SetText(LootFilterEditBox2:GetText()..itemName.."\n");
				end;
			end;
		end;
	end;

	if (event == "MERCHANT_CLOSED") then
		LootFilterButtonDeleteItems:SetText(LootFilterLocale.LocText["LTDeleteItems"]);
	end;

	if (event == "MERCHANT_SHOW") then
		LootFilterButtonDeleteItems:SetText(LootFilterLocale.LocText["LTSellItems"]);
		LootFilter.scanBags(true);
		if (table.getn(LootFilter.cleanList) > 0) then
			if (LootFilterVars[LootFilter.REALMPLAYER].openvendor) then
				LootFilterOptions:Show();
			end;
			LootFilter.selectButton(LootFilterButtonClean, LootFilterFrameClean); 
		end;
	end;

	if (event == "ADDON_LOADED") then

		if (arg1 == "LootFilter") then
			LootFilter.REALMPLAYER= GetCVar("realmName")..UnitName("player");
			if (LootFilterVars[LootFilter.REALMPLAYER] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER]= {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openList == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openList= {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].keepList == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].keepList= {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].keepList["names"] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].keepList["names"] = {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].deleteList == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].deleteList= {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"] = {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].itemStack == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].itemStack= {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].enabled == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].enabled= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].tooltips == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].tooltips= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].notifydelete == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].notifydelete= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].notifykeep == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].notifykeep= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].notifynomatch == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].notifynomatch= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].notifyopen == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].notifyopen= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].notifynew == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].notifynew= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].caching == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].caching= false;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].freebagslots == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].freebagslots= 5;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openvendor == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openvendor= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openbag == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openbag= {};
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openbag[0] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openbag[0]= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openbag[1] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openbag[1]= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openbag[2] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openbag[2]= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openbag[3] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openbag[3]= true;
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].openbag[4] == nil) then
				LootFilterVars[LootFilter.REALMPLAYER].openbag[4]= true;
			end;

			LootFilterButtonGeneral:LockHighlight();
			LootFilter.getNames();
			LootFilter.getNamesDelete();
			LootFilter.getOpenNames();
			LootFilter.getItemValue();
			LootFilter.versionUpdate = false;

			if (LootFilter.tcount(LootFilterVars) <= 1) then
				LootFilterButtonRealCopy:Hide();
				LootFilterSelectDropDown:Hide();
				LootFilterEditBoxTitleCopy3:SetText(LootFilterLocale.LocText["LTNoOtherCharacterToCopySettings"]);
			end;
			LootFilterSelectDropDown_Initialize();
		end;
		LootFilter.checkDepencies();
	end;
end;

function LootFilter.checkDepencies()
	if (GetSellValue) then
		LootFilterOPCaching:Show();
		if (LootFilterVars[LootFilter.REALMPLAYER].caching) then
			LootFilterEditBox5:Show();
			LootFilterTextBackground5:Show();
			LootFilterFreeSlotsText:Show();
		end;
		LootFilterOPValKeep:Show();
		LootFilterOPValDelete:Show();
		LootFilterEditBox3:Show();
		LootFilterEditBox4:Show();
		LootFilterTextBackground3:Show();
		LootFilterTextBackground4:Show();
		
		LootFilterNeedAddon:Hide();
	end;
end;

function LootFilter.OnLoad()
	SLASH_LOOTFILTER1= "/lootfilter";
	SLASH_LOOTFILTER2= "/lf";
	SLASH_LOOTFILTER3= "/lfr";
	SlashCmdList["LOOTFILTER"] = LootFilter.command;

	this:RegisterEvent("LOOT_OPENED");
	this:RegisterEvent("LOOT_CLOSED");
	this:RegisterEvent("ADDON_LOADED");
	this:RegisterEvent("ITEM_LOCK_CHANGED");
	this:RegisterEvent("UI_INFO_MESSAGE");
	this:RegisterEvent("UNIT_SPELLCAST_START");
	this:RegisterEvent("UNIT_SPELLCAST_STOP");
	this:RegisterEvent("MERCHANT_CLOSED");
	this:RegisterEvent("MERCHANT_SHOW");
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("RAID_ROSTER_UPDATE");
	LootFilter.newVersion = LootFilter.VERSION;
	LootFilter.schedule(5, LootFilter.sendAddonMessage, "VERSION:"..LootFilter.newVersion, 1);
end;

function LootFilter.sendAddonMessage()
	if (channel == 1) then
		local guild = GetGuildInfo("player");
		if (nil ~= nil) then
			SendAddonMessage("LootFilter", value, "GUILD", "");
		end;
	elseif (channel == 2) then
		if (LootFilter.versionUpdate == true) then
			SendAddonMessage("LootFilter", value, "RAID", "");
		end;
	end;
end;

function LootFilter.selectButton(button, frame)
	LootFilter.setNames();
	LootFilter.setNamesDelete();
	LootFilter.setOpenNames();

	LootFilterButtonGeneral:UnlockHighlight();
	LootFilterButtonQuality:UnlockHighlight();
	LootFilterButtonType:UnlockHighlight();
	LootFilterButtonName:UnlockHighlight();
	LootFilterButtonValue:UnlockHighlight();
	LootFilterButtonClean:UnlockHighlight();
	LootFilterButtonOpen:UnlockHighlight();
	LootFilterButtonCopy:UnlockHighlight();

	LootFilterFrameGeneral:Hide();
	LootFilterFrameQuality:Hide();
	LootFilterFrameType:Hide();
	LootFilterFrameName:Hide();
	LootFilterFrameValue:Hide();
	LootFilterFrameClean:Hide();
	LootFilterFrameOpen:Hide();
	LootFilterFrameCopy:Hide();

	button:LockHighlight();
	frame:Show();
end;

function LootFilter.trim(name)
	return string.gsub(name, "LootFilter", "");	
end;

function LootFilter.setRadioButtonsValue(button)
	local name = LootFilter.trim(button:GetParent():GetName());
	if (LootFilterVars[LootFilter.REALMPLAYER].keepList[name] ~= nil) then
		LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= nil;
	end;
	if (LootFilterVars[LootFilter.REALMPLAYER].deleteList[name] ~= nil) then
		LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= nil;
	end;
	local children = { this:GetParent():GetChildren() };
	local i = 0;
	for _, child in ipairs(children) do
		if (child ~= button) then
			child:SetChecked(false);
		else
			button:SetChecked(true);
			if (i == 1) then
				if (string.match(name, "^QU")) then
					LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= LootFilterLocale.qualities[name];
				elseif (string.match(name, "^TY")) then
					LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= LootFilterLocale.radioButtonsText[name];
				else
					LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= true;
				end;
			elseif (i == 2) then
				if (string.match(name, "^QU")) then
					LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= LootFilterLocale.qualities[name];
				elseif (string.match(name, "^TY")) then
					LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= LootFilterLocale.radioButtonsText[name];
				else
					LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= true;
				end;
			end;
		end;
		i = i + 1;
	end;
end;

function LootFilter.getRadioButtonsValue(button)
	local name = LootFilter.trim(button:GetName());
	local fontString = getglobal(button:GetName().."_Text");
	local radioButton = getglobal(button:GetName().."_Default");
	getglobal(button:GetName().."_Default"):SetChecked(false);
	getglobal(button:GetName().."_Keep"):SetChecked(false);
	getglobal(button:GetName().."_Delete"):SetChecked(false);
	fontString:SetText(LootFilterLocale.radioButtonsText[name]);
	if (LootFilterVars[LootFilter.REALMPLAYER].keepList[name] ~= nil) then
		radioButton = getglobal(button:GetName().."_Keep");
	elseif (LootFilterVars[LootFilter.REALMPLAYER].deleteList[name] ~= nil) then
		radioButton = getglobal(button:GetName().."_Delete");
	end;
	radioButton:SetChecked(true);
end;

function LootFilter.setRadioButtonValue(button)
	local name = LootFilter.trim(button:GetParent():GetName());
	local checked = false;
	if (button:GetChecked()) then
		checked = true;
	end;

	if (name == "OPEnable") then
		LootFilterVars[LootFilter.REALMPLAYER].enabled = checked;
	elseif (name == "OPCaching") then
		LootFilterVars[LootFilter.REALMPLAYER].caching = checked;
		if (checked) then
			LootFilterEditBox5:Show();
			LootFilterTextBackground5:Show();
			LootFilterFreeSlotsText:Show();
		else
			LootFilterEditBox5:Hide();
			LootFilterTextBackground5:Hide();
			LootFilterFreeSlotsText:Hide();
		end;

	elseif (name == "OPTooltips") then
		LootFilterVars[LootFilter.REALMPLAYER].tooltips = checked;
	elseif (name == "OPNotifyDelete") then
		LootFilterVars[LootFilter.REALMPLAYER].notifydelete = checked;
	elseif (name == "OPNotifyKeep") then
		LootFilterVars[LootFilter.REALMPLAYER].notifykeep = checked;
	elseif (name == "OPNotifyNoMatch") then
		LootFilterVars[LootFilter.REALMPLAYER].notifynomatch = checked;
	elseif (name == "OPNotifyOpen") then
		LootFilterVars[LootFilter.REALMPLAYER].notifyopen = checked;
	elseif (name == "OPNotifyNew") then
		LootFilterVars[LootFilter.REALMPLAYER].notifynew = checked;
	elseif (name == "OPValKeep") then
		LootFilterVars[LootFilter.REALMPLAYER].keepList["VAOn"] = checked;
	elseif (name == "OPValDelete") then
		LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAOn"] = checked;
	elseif (name == "OPOpenVendor") then
		LootFilterVars[LootFilter.REALMPLAYER].openvendor = checked;
	elseif (name == "OPBag0") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[0] = checked;
	elseif (name == "OPBag1") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[1] = checked;
	elseif (name == "OPBag2") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[2] = checked;
	elseif (name == "OPBag3") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[3] = checked;
	elseif (name == "OPBag4") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[4] = checked;
	end;
end;

function LootFilter.getRadioButtonValue(button)
	local name = LootFilter.trim(button:GetName());
	local fontString = getglobal(button:GetName().."_Text");
	local radioButton = getglobal(button:GetName().."_Button");
	fontString:SetText(LootFilterLocale.radioButtonsText[name]);
	if (name == "OPEnable") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].enabled);
	elseif (name == "OPCaching") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].caching);
	elseif (name == "OPTooltips") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].tooltips);
	elseif (name == "OPNotifyDelete") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifydelete);
	elseif (name == "OPNotifyKeep") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifykeep);
	elseif (name == "OPNotifyOpen") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifyopen);
	elseif (name == "OPNotifyNew") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifynew);
	elseif (name == "OPNotifyNoMatch") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifynomatch);
	elseif (name == "OPValKeep") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].keepList["VAOn"]);
	elseif (name == "OPValDelete") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAOn"]);
	elseif (name == "OPOpenVendor") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openvendor);
	elseif (name == "OPBag0") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[0]);
	elseif (name == "OPBag1") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[1]);
	elseif (name == "OPBag2") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[2]);
	elseif (name == "OPBag3") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[3]);
	elseif (name == "OPBag4") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[4]);
	end;
end;

function LootFilter.showTooltip(area, text)
	if (LootFilterVars[LootFilter.REALMPLAYER].tooltips) then
		GameTooltip:SetOwner(LootFilterOptions, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(LootFilterLocale.LocTooltip[text], 1, 1, 1, 0.75, 1);
		GameTooltip:Show();
	end;
end;

function LootFilter.copySettings()
	local realmPlayer = UIDropDownMenu_GetText(LootFilterSelectDropDown);
	realmPlayer = string.gsub(realmPlayer, " %p ", "");
	LootFilterVars[LootFilter.REALMPLAYER] = LootFilterVars[realmPlayer];
	LootFilter.getNames();
	LootFilter.getNamesDelete();
	LootFilter.getOpenNames();
	LootFilter.getItemValue();
	LootFilterEditBoxTitleCopy4:Show();
	return;
end;

function LootFilter.sortByLink(a, b)
	if ( not a ) then return true;	elseif ( not b ) then return false; end
	return string.lower(LootFilter.getItemName(a)) < string.lower(LootFilter.getItemName(b));
end;

function LootFilter.sortByValye(a, b)
	if ( not a ) then return true;	elseif ( not b ) then return false; end
	return tonumber(LootFilter.getValueOfItem(LootFilter.getItemId(a))) < tonumber(LootFilter.getValueOfItem(LootFilter.getItemId(b)));
end;

function LootFilter.scanBags(display)
	if (display) then
		LootFilterButtonDeleteItems:Disable();
		LootFilterButtonIWantTo:Disable();
	end;
	LootFilter.cleanList = {};
	local z = 1;
	local slots = 0;
	local totalValue = 0;
	
	for j=0 , 4 , 1 do
		if (LootFilterVars[LootFilter.REALMPLAYER].openbag[j]) then
			x = GetContainerNumSlots(j);
			for i=1 , x , 1 do
				local itemlink= GetContainerItemLink(j,i);
				if (itemlink ~= nil) then
					local itemName = LootFilter.getItemName(itemlink);
					local itemid = LootFilter.getItemId(itemlink);
					if (LootFilter.deleteItemFromInventory(itemlink, true, "")) then
						LootFilter.cleanList[z] = itemlink;
						totalValue = totalValue + LootFilter.getValueOfItem(itemid);
						z = z + 1;
					end;
				else
					slots = slots + 1;
				end;
			end;
		end;
	end;
	if (totalValue > 0) then
		-- Copied from Quick Repair
		LootFilterTextCleanTotalValue:SetText(LootFilterLocale.LocText["LTTotalValue"]..": "..string.format("|c00FFFF66 %2dg" , totalValue / 10000)..string.format("|c00C0C0C0 %2ds" , string.sub(totalValue,-4)/100)..string.format("|c00CC9900 %2dc" , string.sub(totalValue,-2)));
	end;
	if (display) then
		table.sort(LootFilter.cleanList, LootFilter.sortByLink);
		if (table.getn(LootFilter.cleanList) > 0) then
			LootFilterButtonDeleteItems:Enable();
			LootFilter.CleanScrollBar_Update();
		else
			local cleanLine = getglobal("cleanLine1");
			cleanLine:SetText(LootFilterLocale.LocText["LTNoMatchingItems"]);
			LootFilterTextCleanTotalValue:SetText("");
			cleanLine:Show();
		end;
	else
		if (slots < LootFilterVars[LootFilter.REALMPLAYER].freebagslots) and (table.getn(LootFilter.cleanList) > 0)  then
			local needSlots = LootFilterVars[LootFilter.REALMPLAYER].freebagslots-slots;
			if (needSlots > table.getn(LootFilter.cleanList)) then
				needSlots = table.getn(LootFilter.cleanList);
			end;
			table.sort(LootFilter.cleanList, LootFilter.sortByValue);
			for i=1,needSlots do
				LootFilter.deleteItemFromInventory(LootFilter.cleanList[i], false, LootFilterLocale.LocText["LTItemLowestValue"]);
			end;
			LootFilter.cleanList = {};
		end;
	end;
end;

function LootFilter.iWantTo()
	LootFilterButtonIWantTo:Enable();
end;

function LootFilter.initClean()
	LootFilterButtonDeleteItems:Enable();
	LootFilterButtonIWantTo:Disable();
	for line=1,19 do
		cleanLine = getglobal("cleanLine"..line);
		cleanLine:SetText("");
		cleanLine:Hide();
	end
	FauxScrollFrame_SetOffset(LootFilterScrollFrameClean, 0);
end;

function LootFilter.CleanScrollBar_Update()
	local line; 
	local cleanLine;
	local lineplusoffset; 
	local numitems = table.getn(LootFilter.cleanList);
	if numitems < 20 then
		numitems = 20;
	end;
	FauxScrollFrame_Update(LootFilterScrollFrameClean,numitems,19,16);
	for line=1,19 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(LootFilterScrollFrameClean);
		cleanLine = getglobal("cleanLine"..line);
		if lineplusoffset <= table.getn(LootFilter.cleanList) then
			cleanLine:SetText(LootFilter.cleanList[lineplusoffset]);
			cleanLine:Show();
		else
			cleanLine:Hide();
		end
	end
end;

function LootFilter.deleteItems(timeout, delete)
	LootFilterButtonDeleteItems:Enable();
	LootFilterButtonIWantTo:Disable();
	if (not delete) and (LootFilterButtonDeleteItems:GetText() ~= "Sell items") then
		LootFilter.initClean();
		local cleanLine = getglobal("cleanLine1");
		cleanLine:SetText(LootFilterLocale.LocText["LTVendorWinClosedWhileSelling"]);
		cleanLine:Show();
		LootFilter.schedule(2, LootFilter.scanBags, true);
		return;
	end;

	if (timeout < time()) then
		LootFilter.initClean();
		local cleanLine = getglobal("cleanLine1");
		cleanLine:SetText(LootFilterLocale.LocText["LTTimeOutItemNotFound"]);
		cleanLine:Show();
		LootFilter.schedule(2, LootFilter.scanBags, true);
		return;
	end;
	if (table.getn(LootFilter.cleanList) >= 1) then
		LootFilter.deleteItemFromInventory(LootFilter.cleanList[1], false, "cleaning");
		table.remove(LootFilter.cleanList, 1);
		LootFilter.CleanScrollBar_Update(true);
		LootFilter.schedule(1, LootFilter.deleteItems, time()+LootFilter.LOOT_TIMEOUT, delete);
	else
		LootFilter.scanBags(true);
	end;
end;

function LootFilter.setItemRef(frame)
	fontString = getglobal("cleanLine"..string.match(frame:GetName(), "(%d+)"));
	value = fontString:GetText();
	if (value ~= nil) and (value ~= "") then
		if (IsShiftKeyDown()) then
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"], LootFilter.getItemName(value));
			LootFilterEditBox1:SetText(LootFilterEditBox1:GetText()..LootFilter.getItemName(value).."\n");
			LootFilter.scanBags(true);
		else
			SetItemRef(value);
		end;
	end;
end;

function LootFilter.splitRealmPlayer(realmPlayer)
	local i;
	for i = string.len(realmPlayer), 0, -1 do
		index = string.find(realmPlayer, "%u", i);
		if (index ~= nil) then
			return string.sub(realmPlayer, 0, i-1), string.sub(realmPlayer, i);
		end;
	end;
end;

function LootFilter.SelectDropDown_OnClick()
	UIDropDownMenu_SetSelectedValue(this.owner, this.value);
end;

function LootFilter.SelectDropDown_Initialize()
	local i = 1;
	for key, value in pairs(LootFilterVars) do
		if (key ~= LootFilter.REALMPLAYER) then
			realm, player = LootFilter.splitRealmPlayer(key);
			local info = UIDropDownMenu_CreateInfo(); 

			info.text = realm.." - "..player; --the text of the'menu item 
			info.value = i; -- the value of the menu item. This can be a string also. 
			info.func = LootFilter.SelectDropDown_OnClick; --sets the function to execute when this item is clicked 
			info.owner = this:GetParent(); --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues. 
			info.checked = nil; --initially set the menu item to being unchecked with a yellow tick 
			info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text 
			UIDropDownMenu_AddButton(info, level);

			if (UIDropDownMenu_GetSelectedValue(LootFilterSelectDropDown) == nil) then
				UIDropDownMenu_SetSelectedID(LootFilterSelectDropDown, i);
				UIDropDownMenu_SetSelectedValue(LootFilterSelectDropDown, i);
				UIDropDownMenu_SetText(realm.." - "..player, LootFilterSelectDropDown);
			end;
			i = i + 1;
		end;
	end;

end;

-- i hate lua
function LootFilter.tcount(table)
	local n=0;
	for _ in pairs(table) do
		n=n+1;
	end
	return n;
end

