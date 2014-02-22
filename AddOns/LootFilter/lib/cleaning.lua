function LootFilter.sortByLink(a, b)
	if ( not a ) then return true;	elseif ( not b ) then return false; end
	return string.lower(a["name"]) < string.lower(b["name"]);
end;

function LootFilter.processCleaning() -- display the cleanList in the Clean tab
	LootFilterButtonDeleteItems:Disable();
	LootFilterButtonIWantTo:Disable();
	LootFilter.constructCleanList();
	totalValue = LootFilter.calculateCleanListValue()
	if (totalValue > 0) then
		-- Copied from Quick Repair
		totalValue = LootFilter.round(totalValue * 10000);
		
		LootFilterTextCleanTotalValue:SetText(LootFilter.Locale.LocText["LTTotalValue"]..": "..string.format("|c00FFFF66 %2dg" , totalValue / 10000)..string.format("|c00C0C0C0 %2ds" , string.sub(totalValue,-4)/100)..string.format("|c00CC9900 %2dc" , string.sub(totalValue,-2)));
	else 
		LootFilterTextCleanTotalValue:SetText(LootFilter.Locale.LocText["LTTotalValue"]..": "..string.format("|c00FFFF66 %2dg" , 0)..string.format("|c00C0C0C0 %2ds" , 0)..string.format("|c00CC9900 %2dc" , 0));
	end;
	table.sort(LootFilter.cleanList, LootFilter.sortByValue);
	if (table.getn(LootFilter.cleanList) > 0) then
		LootFilterButtonDeleteItems:Enable();
		LootFilter.CleanScrollBar_Update();
	else
		local cleanLine = getglobal("cleanLine1");
		cleanLine:SetText(LootFilter.Locale.LocText["LTNoMatchingItems"]);
		LootFilterTextCleanTotalValue:SetText("");
		cleanLine:Show();
	end;	
end;

function LootFilter.showItemTooltip(frame) -- show itemTooltip
	fontString = getglobal("cleanLine"..string.match(frame:GetName(), "(%d+)"));
	value = fontString:GetText();
	if (LootFilter.cleanList ~= nil) and (table.getn(LootFilter.cleanList) > 0) and (value ~= nil) and (value ~= "") then
		local item = LootFilter.getBasicItemInfo(value);

		item = LootFilter.findItemInBags(item);
		
		GameTooltip:SetOwner(frame, "ANCHOR_LEFT");
		GameTooltip:SetBagItem(item["bag"], item["slot"]);
		GameTooltip:Show();
	end;
end;

function LootFilter.addItemToKeepList(frame) -- add items to the keep list if user shift-clicks
	fontString = getglobal("cleanLine"..string.match(frame:GetName(), "(%d+)"));
	value = fontString:GetText();
	if (value ~= nil) and (value ~= "") then
		if (IsShiftKeyDown()) then
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"], LootFilter.getNameOfItem(value));
			LootFilterEditBox1:SetText(LootFilterEditBox1:GetText()..LootFilter.getNameOfItem(value).."\n");
			LootFilter.initClean();
			LootFilter.processCleaning();
			LootFilter.showItemTooltip(frame);
		end;
	end;
end;

