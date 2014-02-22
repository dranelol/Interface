function LootFilter.sortByValue(a, b)
	if ( not a ) then return true;	elseif ( not b ) then return false; end
	
	if (LootFilterVars[LootFilter.REALMPLAYER].calculate == 1) then
		a = tonumber(a["value"]);
		b = tonumber(b["value"]);
	elseif (LootFilterVars[LootFilter.REALMPLAYER].calculate == 2) then
		a = tonumber(a["value"]*a["amount"]);
		b = tonumber(b["value"]*b["amount"]);
	else
		a = tonumber(a["value"]*a["stack"]);
		b = tonumber(b["value"]*b["stack"]);
	end;	
	
	return tonumber(a) < tonumber(b);
end;


function LootFilter.processCaching()
	if LootFilter.inDialog then
		return;
	end
	if (GetTime() > LootFilter.LOOT_MAXTIME) then -- if we have exceded maxtime quit and clear the stack
		return;
	end;
			
	slots = LootFilter.constructCleanList();
	
	if (slots < LootFilterVars[LootFilter.REALMPLAYER].freebagslots) and (table.getn(LootFilter.cleanList) > 0)  then
		local needSlots = LootFilterVars[LootFilter.REALMPLAYER].freebagslots-slots;
		
		table.sort(LootFilter.cleanList, LootFilter.sortByValue);
		if (LootFilter.deleteItemFromBag(LootFilter.cleanList[1])) then
			local calculatedValue;
			if (LootFilter.cleanList[1]["value"] < 0) then -- item matched a delete property
				LootFilter.cleanList[1]["value"]  = LootFilter.round(LootFilter.cleanList[1]["value"] + 1000, 4); -- restore its original value and use our rounding because blizzard/lua cant calculate properly
			end;
			if (LootFilterVars[LootFilter.REALMPLAYER].calculate == 1) then
				calculatedValue = tonumber(LootFilter.cleanList[1]["value"]);
			elseif (LootFilterVars[LootFilter.REALMPLAYER].calculate == 2) then
				calculatedValue = tonumber(LootFilter.cleanList[1]["value"]*LootFilter.cleanList[1]["amount"]);
			else
				calculatedValue = tonumber(LootFilter.cleanList[1]["value"]*LootFilter.cleanList[1]["stack"]);
			end;
			LootFilter.print(LootFilter.cleanList[1]["link"].." "..LootFilter.Locale.LocText["LTWasDeleted"]..": "..LootFilter.Locale.LocText["LTItemLowestValue"].." ("..calculatedValue..")");
			table.remove(LootFilter.cleanList, 1);
		end;
		LootFilter.schedule(LootFilter.LOOT_PARSE_DELAY, LootFilter.processCaching);				
	end;	
end;


function LootFilter.deleteItems(timeout, delete)
	if (delete) then
		LootFilter.constructCleanList();
	end;
	if (LootFilter.lastCleanListCount ~= table.getn(LootFilter.cleanList)) then
		LootFilter.lastCleanListCount = table.getn(LootFilter.cleanList);
	end;
	
	LootFilterButtonDeleteItems:Enable();
	LootFilterButtonIWantTo:Disable();
	if (not delete) and (LootFilterButtonDeleteItems:GetText() ~= LootFilter.Locale.LocText["LTSellItems"]) then  -- cancel if vendor window is closed while selling
		LootFilter.initClean();
		local cleanLine = getglobal("cleanLine1");
		cleanLine:SetText(LootFilter.Locale.LocText["LTVendorWinClosedWhileSelling"]);
		cleanLine:Show();
		LootFilter.schedule(2, LootFilter.processCleaning);
		return;
	end;

	if (timeout < GetTime()) then -- item could not be found and resulted in a timeout

		LootFilter.initClean();
		local cleanLine = getglobal("cleanLine1");
		cleanLine:SetText(LootFilter.Locale.LocText["LTTimeOutItemNotFound"]);
		cleanLine:Show();
		LootFilter.schedule(2, LootFilter.processCleaning);
		return;
	end;
	
	if (table.getn(LootFilter.cleanList) >= 1) then -- if we have one or more items on the list start selling/deleting
		local interval = 0;
		local item = table.remove(LootFilter.cleanList, 1);
		if (LootFilterButtonDeleteItems:GetText() == LootFilter.Locale.LocText["LTSellItems"]) then -- sell items
			while LootFilter.sellQueue < LootFilter.SELL_QUEUE do
				LootFilter.sellQueue = LootFilter.sellQueue + 1;
				LootFilter.schedule(LootFilter.SELL_INTERVAL, LootFilter.deleteItems, GetTime()+LootFilter.SELL_TIMEOUT, false);
			end;
						
			
			UseContainerItem(item["bag"], item["slot"]);
			if (LootFilter.questUpdateToggle == 1) then
				LootFilter.lastDeleted = item["name"]; 
			end;
			
			-- give the client time to actually sell the item
			LootFilter.schedule(LootFilter.SELL_INTERVAL, LootFilter.checkIfItemSold, GetTime()+LootFilter.SELL_ITEM_TIMEOUT, item);
			
			return;
		else -- delete items
			if (LootFilter.deleteItemFromBag(item)) then
				if (LootFilter.questUpdateToggle == 1) then
					LootFilter.lastDeleted = item["name"]; 
				end;				
				table.remove(LootFilter.cleanList, 1);
			end;
			interval = LootFilter.LOOT_PARSE_DELAY;
			LootFilter.CleanScrollBar_Update(true);
			LootFilter.schedule(interval, LootFilter.deleteItems, timeout, delete);
		end;		
		
	else
		LootFilter.sellQueue = 0;
		LootFilter.initClean();
		local cleanLine = getglobal("cleanLine1");
		cleanLine:SetText(LootFilter.Locale.LocText["LTFinishedSC"]);
		cleanLine:Show();		
		LootFilter.schedule(2, LootFilter.processCleaning);
	end;
end;

function LootFilter.checkIfItemSold(timeout, item)
	
	if (timeout < GetTime()) or (GetContainerItemLink(item["bag"], item["slot"]) == nil) then -- item sold or could not be sold (timeout)
		LootFilter.schedule(LootFilter.SELL_INTERVAL, LootFilter.deleteItems, GetTime()+LootFilter.SELL_TIMEOUT, false);
		LootFilter.CleanScrollBar_Update(true);
	else
		UseContainerItem(item["bag"], item["slot"]);
		LootFilter.schedule(LootFilter.SELL_INTERVAL, LootFilter.checkIfItemSold, timeout, item);
	end;
	
end;

