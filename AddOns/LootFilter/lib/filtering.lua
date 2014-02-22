-- process the items that have been looted
function LootFilter.processItemStack()
	if LootFilter.inDialog then
		return;
	end
	if (table.getn(LootFilterVars[LootFilter.REALMPLAYER].itemStack) == 0) then -- if no more items on stack we are done
		return;
	end;

	if (GetTime() > LootFilter.LOOT_MAXTIME) then -- if we have exceeded maxtime quit and clear the stack
		LootFilterVars[LootFilter.REALMPLAYER].itemStack = {};
		return;
	end;
		
	local item = LootFilterVars[LootFilter.REALMPLAYER].itemStack[1];
	
	item = LootFilter.findItemInBags(item);
	
	if (item["bag"] ~= -1) then -- check if we found the item in our bag
		item["amount"] = LootFilter.getStackSizeOfItem(item);
		
		local reason = LootFilter.matchKeepProperties(item); -- lets match the keep properties
		if (reason == "") then 
			reason = LootFilter.matchDeleteProperties(item); -- lets match the delete properties
			if (reason == "") then -- item did not match any properties and is kept
				if (LootFilterVars[LootFilter.REALMPLAYER].notifynomatch) then
					LootFilter.print(item["link"].." "..LootFilter.Locale.LocText["LTKept"]..": "..LootFilter.Locale.LocText["LTNoMatchingCriteria"]);
				end;
				table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);	
			else -- item matched a delete property
				if (LootFilter.deleteItemFromBag(item)) then -- delete the item
					if (LootFilterVars[LootFilter.REALMPLAYER].notifydelete) then
						LootFilter.print(item["link"].." "..LootFilter.Locale.LocText["LTWasDeleted"]..": "..reason);
						if (LootFilter.questUpdateToggle == 1) then
							LootFilter.lastDeleted = item["name"]; 
						end;					
					end;
					table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
				else -- if delete failed pop and push (cycle)
					reason = "";
					if (table.getn(LootFilterVars[LootFilter.REALMPLAYER].itemStack) > 1) then -- only do it when we have more then 1 item
						table.insert(LootFilterVars[LootFilter.REALMPLAYER].itemStack, item);
						table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
					end;				
				end;			
			end;
		else -- remove item from stack and display message
			if (LootFilterVars[LootFilter.REALMPLAYER].notifykeep) then
				LootFilter.print(item["link"].." "..LootFilter.Locale.LocText["LTKept"]..": "..reason);
			end;
			table.remove(LootFilterVars[LootFilter.REALMPLAYER].itemStack, 1);
		end;
	end;
	LootFilter.schedule(LootFilter.SCHEDULE_INTERVAL, LootFilter.processItemStack);	
end;