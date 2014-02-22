function GetSellValue(id)
	local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(id);
	return value;
end

function LootFilter.confirmDelete(item)
	if not StaticPopupDialogs["LOOTFILTER_CONFIRMDELETE"] then -- Build on demand
		local info = {
			text = DELETE_ITEM, -- Use default localized string
			button1 = YES,
			button2 = NO,
			OnShow = function(data)
				LootFilter.inDialog = true;
			end,
			OnHide = function(data)
				LootFilter.inDialog = false;
				if (LootFilterVars[LootFilter.REALMPLAYER].caching) then -- Restart item processing after dialog is hidden
					LootFilterVars[LootFilter.REALMPLAYER].itemStack = {};
					LootFilter.schedule(LootFilter.LOOT_PARSE_DELAY, LootFilter.processCaching);
				else
					LootFilter.schedule(LootFilter.LOOT_PARSE_DELAY, LootFilter.processItemStack);
				end;
			end,
			OnAccept = function(data)
				if not CursorHasItem() then
					if not data["bag"] or not data["slot"] then
						geterrorhandler(("Invalid item position. %s, %s, %s"):format(tostring(data["name"]), tostring(data["bag"]), tostring(data["slot"])));
						return false;
					end
					PickupContainerItem(data["bag"], data["slot"]);
				end
				DeleteCursorItem();
			end,
			OnCancel = function (data)
				ClearCursor();
			end,
			OnUpdate = function (data)
				if ( not CursorHasItem() ) then
					StaticPopup_Hide("DELETE_ITEM");
				end
			end,
			timeout = 30,
			whileDead = 1,
			exclusive = 1,
			showAlert = 1,
			hideOnEscape = 1,
		};
		StaticPopupDialogs["LOOTFILTER_CONFIRMDELETE"] = info;
	end
	local dialog = StaticPopup_Show("LOOTFILTER_CONFIRMDELETE", item["link"]);
	dialog.data = item;
end

function LootFilter.deleteItemFromBag(item)
	if (item ~= nil) then
		if LootFilterVars[LootFilter.REALMPLAYER].confirmdel then
			LootFilter.confirmDelete(item);
		else
			PickupContainerItem(item["bag"], item["slot"]);
			if CursorHasItem() then
				DeleteCursorItem();
			end
			myTime = GetTime();
			return true;
		end
	end;
	return false;	
end;


-- get the current amount of items
function LootFilter.getStackSizeOfItem(item)
	local amount;
	_, amount, _, _, _ = GetContainerItemInfo(item["bag"], item["slot"]);
	return amount;
end;

-- get id of an item
function LootFilter.getIdOfItem(itemLink)
	return tonumber(string.match(itemLink, ":(%d+)"));
end;

-- get name of an item
function LootFilter.getNameOfItem(itemLink)
	return string.match(itemLink, "%[(.*)%]");
end;

-- get stack size of an item
function LootFilter.getMaxStackSizeOfItem(item)
	local _, _, _, _, _, _, _, stackSize = GetItemInfo(item["id"])
	return tonumber(stackSize);
end;

-- get value of an item
function LootFilter.getValueOfItem(item)
	local itemValue;
	local itemValueAuctioneer;
	
	-- try and get marketvalue
	if (LootFilter.marketValue) and (LootFilterVars[LootFilter.REALMPLAYER].marketvalue) then
		itemValueAuctioneer = AucAdvanced.API.GetMarketValue(item["id"]);
	end
	if (itemValueAuctioneer == nil) then
		itemValueAuctioneer = 0;
	end;
	itemValueAuctioneer = tonumber(itemValueAuctioneer);

	-- try and get vendor value
	if (GetSellValue) then
		itemValue = GetSellValue(item["id"]);
	end;
 	if (itemValue == nil) then
		itemValue = 0;
	end;
	itemValue = tonumber(itemValue);
	
	-- use the highest value available
	if (itemValue < itemValueAuctioneer) then
		itemValue = itemValueAuctioneer;
	end;
	
	if (itemValue ~= 0) then
		itemValue = tonumber(itemValue/10000);
	end;

	return itemValue;	
end;


-- determine if an item is a container
function LootFilter.openItemIfContainer(item)
	if (LootFilter.itemOpen == nil) or (LootFilter.itemOpen == false) then -- only try and open something once after looting because it locks up if you don't
		for key,value in pairs(LootFilterVars[LootFilter.REALMPLAYER].openList) do
			if (LootFilter.matchItemNames(item, value)) then
				if (LootFilterVars[LootFilter.REALMPLAYER].notifyopen) then
					LootFilter.print(LootFilter.Locale.LocText["LTTryopen"].." "..item["link"].." : "..LootFilter.Locale.LocText["LTNameMatched"].." ("..value..")");
				end;
			
				LootFilter.itemOpen = true;
				UseContainerItem(item["bag"], item["slot"]);
				
				return true;
			end;
		end;
	end;
	return false;
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

-- requires 'link' to be present
function LootFilter.getBasicItemInfo(link)
	local item = nil;
	if (link ~= nil) then
		item = {};
		item["link"] = link;
		item["id"] = LootFilter.getIdOfItem(item["link"]);
		item["name"] = LootFilter.getNameOfItem(item["link"]);
		item["value"] = LootFilter.getValueOfItem(item);
		item["stack"] = LootFilter.getMaxStackSizeOfItem(item);
		item["info"] = LootFilter.getExtendedItemInfo(item);
	end;
	return item;
end;

function LootFilter.getExtendedItemInfo(item)
	if (item["info"] ~= nil) then
		return item["info"];
	end;
	LootFilterScanningTooltip:ClearLines();
	LootFilterScanningTooltip:SetHyperlink(item["link"]);
	local result = "";
	local line = "";
	for i=1,LootFilterScanningTooltip:NumLines() do
		line = getglobal("LootFilterScanningTooltipTextLeft" .. i);
		if (line ~= nil) and (line:GetText() ~= nil) then
			result = result..line:GetText().."\n";
	   	end;
		line = getglobal("LootFilterScanningTooltipTextRight" .. i);
	  	if (line ~= nil) and (line:GetText() ~= nil) then
	  		result = result..line:GetText().."\n";
	  	end;
	end
	return result;
end;














