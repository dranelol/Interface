
local o = ItemVendorPricesDB2; if (o.SHOULD_LOAD == nil) then return; end

-- DataManip_t_Init: ()
--
-- GetVersion: minor, subminor = ()
--
-- GetDBSize: size = ()
--
-- OnEvent_MERCHANT_SHOW: ()
-- ParsePrices: ()
--
-- GetData: data = (itemID)
	-- GetSellValue: value = (itemID | itemLink)
-- SetData: oldData, newData = (itemID, newPrice)

do
	local pattern = ITEM_SPELL_CHARGES:gsub("%%d", "%%d+", 1);
	local before, singular, plural, after = pattern:match("^(.*)|4(.+):(.+);(.*)$");
	o.CHARGES_PATTERN_SINGULAR = ("^" .. before .. singular .. after .. "$");
	o.CHARGES_PATTERN_PLURAL = ("^" .. before .. plural .. after .. "$");
end

o.activeDB = nil;
-- activeDBSize = 0;
-- errata = ItemVendorPricesDB2_Errata;




function o.DataManip_t_Init()
	o.DataManip_t_Init = nil;	
	
	o.EventsManager2.RegisterForEvent(o, "ParsePrices", "MERCHANT_SHOW", false, false);
	
	local ACE = EventsManager2.AddCustomEvent;
	ACE("ItemVendorPricesDB2_DB_SIZE_CHANGED", false);
	ACE("ItemVendorPricesDB2_PRICE_CHANGED", false);
	
	local errata = ItemVendorPricesDB2_Errata;
	if (errata == nil) then
		errata = {};
		ItemVendorPricesDB2_Errata = errata;
	end
	o.errata = errata;
	
	local count = o.ItemPrice:GetPriceCount();
	local staticData;
	for itemID, data in pairs(errata) do
		staticData = o.ItemPrice:GetPriceById(itemID);
		if (staticData ~= nil) then
			-- There's an entry for it in the DB, but does it match?
			if (data == false) then
				errata[itemID] = 0;
				data = 0;
			end
			if (staticData == data) then
				-- It does match. Delete from the errata.
				errata[itemID] = nil;
			--else
				-- It doesn't match, but we shouldn't do anything because the errata needs to keep this entry and the
				-- count has already included this entry.
			end
		else
			-- There's no entry. Increment the count.
			count = (count + 1);
		end
	end
	
	local oldCount = (o.activeDBSize or 0);
	if (oldCount ~= count) then
		o.activeDBSize = count;
		o.EventsManager2.DispatchCustomEvent("ItemVendorPricesDB2_DB_SIZE_CHANGED", oldCount, count);
	end
end




function o.GetVersion()
	return math.floor((o.VERSION % 10000) / 100), (o.VERSION % 100);
end




function o.GetDBSize()
	return o.activeDBSize;
end




function o.ParsePrices()
	local tonumber = tonumber;
	local GetContainerNumSlots = GetContainerNumSlots;
	local GetContainerItemLink = GetContainerItemLink;
	local GetContainerItemInfo = GetContainerItemInfo;
	local GetData = o.GetData;
	local SetData = o.SetData;
	local tooltip = NicheDevTools.PARSING_TOOLTIP;
	tooltip:SetOwner(UIParent, "ANCHOR_NONE");
	local leftLines = tooltip.leftLines;
	local CHARGES_PATTERN_SINGULAR = o.CHARGES_PATTERN_SINGULAR;
	local CHARGES_PATTERN_PLURAL = o.CHARGES_PATTERN_PLURAL;
	
	local link, _, repairCost, itemID, value, oldValue, quantity, index, maxIndex, text;
	for bag = 0, 4, 1 do
		for slot = 1, GetContainerNumSlots(bag), 1 do
			link = GetContainerItemLink(bag, slot);
			
			if (link ~= nil) then
				itemID = tonumber(link:match("[^:]+", 18));
				
				tooltip.currentMoneyValue = nil;
				_, repairCost = tooltip:SetBagItem(bag, slot);
				-- Read the value now that the OnTooltipAddMoney script has had the chance to set it.
				value = (tooltip.currentMoneyValue or 0);
				
				if (value ~= 0) then
					-- Item is sellable, so now check repair cost and possibly charges to avoid storing damaged or used items,
					-- unless there is no previous price associated with the item.
					oldValue = GetData(itemID);
					if (oldValue ~= nil and oldValue > value) then
						-- This might be an item with charges which has fewer charges than when we last saw it. Have to check the whole tooltip.
						maxIndex = tooltip:NumLines();
						index = 1;
						while (index <= maxIndex and value ~= nil) do
							text = leftLines[index]:GetText();
							if (text:find(CHARGES_PATTERN_PLURAL) == nil and text:find(CHARGES_PATTERN_SINGULAR) == nil) then
								index = (index + 1);
							else
								-- It is a charged item. Ignore this value since it is less than what we have already.
								value = nil;
							end
						end
					else
						if (repairCost == 0 or oldValue == nil) then
							-- Item is valid for storage, so divide the value by the stack count to get the price for a single item.
							_, quantity = GetContainerItemInfo(bag, slot);
							value = (value / quantity);
						else
							-- Item is damaged and already has an entry in the database. Do not store this price.
							value = nil;
						end
					end
				end
				
				if (value ~= nil) then
					SetData(itemID, value);
				end
			end
		end
	end
end


if (o.OLD_VERSION == nil) then
	local l_orig_RepairAllItems = RepairAllItems;
	RepairAllItems = function()
		l_orig_RepairAllItems();
		o.ParsePrices();
	end
end




-- Generic function in the style of the Blizzard API, per http://www.wowwiki.com/API_GetSellValue
if (o.OLD_VERSION == nil) then
	local type = type;
	local tonumber = tonumber;
	local GetItemInfo = GetItemInfo;
	local l_orig_GetSellValue = GetSellValue;
	
	GetSellValue = function(link)
		local itemID;
		if (link ~= nil) then
			if (type(link) == "number") then
				itemID = link;
			else
				local numberLink = tonumber(link);
				if (numberLink ~= nil) then
					itemID = numberLink;
				else
					itemID = tonumber(link:match("item:(%d+):"));
					if (itemID == nil) then
						local _;
						_, link = GetItemInfo(link);
						if (link ~= nil) then
							itemID = tonumber(link:match("item:(%d+):"));
						end
					end
				end
			end
		end
		
		local value = nil;
		if (itemID ~= nil) then
			value = o.GetData(itemID);
			if (value == nil) then
				if (l_orig_GetSellValue ~= nil) then
					value = l_orig_GetSellValue(itemID);
				end
			end
		end
		return value;
	end
end




do
	local tonumber = tonumber;
	
	function o.GetData(itemID)
		itemID = tonumber(itemID);
		local data = o.errata[itemID];
		if (data == nil) then
			data = o.ItemPrice:GetPriceById(itemID);
		end
		return data;
	end
end



function o.SetData(itemID, newPrice)
	itemID = tonumber(itemID);
	if (itemID == nil) then
		error("ItemVendorPricesDB2.SetData: itemID is nil.", 2);
	end
	if (newPrice ~= nil) then
		newPrice = tonumber(newPrice);
		if (newPrice == nil or newPrice < 0) then
			error("ItemVendorPricesDB2.SetData: Invalid price.", 2);
		end
	end
	
	local oldData = o.GetData(itemID);
	local newData = newPrice;
	
	if (oldData ~= newData) then
		o.errata[itemID] = newData;
		
		local change = ((oldData == nil and newData ~= nil and 1) or (oldData ~= nil and newData == nil and -1) or 0);
		if (change ~= 0) then
			local oldSize = o.activeDBSize;
			local newSize = (oldSize + change);
			o.activeDBSize = newSize;
			o.EventsManager2.DispatchCustomEvent("ItemVendorPricesDB2_DB_SIZE_CHANGED", oldSize, newSize);
		end
		
		o.EventsManager2.DispatchCustomEvent("ItemVendorPricesDB2_PRICE_CHANGED", itemID, oldData, newData);
		return oldData, newData;
	else
		return oldData, oldData;
	end
end
