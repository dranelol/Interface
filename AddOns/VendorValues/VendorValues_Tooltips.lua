
local o = VendorValues;
local m = {};
local m_metatable = { __index = m; };

-- Tooltips_RegisterTooltip: (tooltip)
	-- Tooltips_h_OnTooltipSetItem: (self)
--
-- Tooltips_CreatePrefixText: prefixText = (itemID, quantity)
--
-- m:AddVendorValue: (itemID, quantity)
-- m:AddMoneyLine: ()
-- m:SetupMoneyLineInfo: (money, prefixText)

-- config = VendorValues_Config;




function o.Tooltips_RegisterTooltip(tooltip)
	if (tooltip.VendorValues ~= nil) then
		return;
	end
	
	TooltipItemQuantities2.RegisterTooltip(tooltip);
	
	local instance = {
		parent = tooltip;
		orig_OnTooltipSetItem = tooltip:GetScript("OnTooltipSetItem");
	};
	setmetatable(instance, m_metatable);
	tooltip:SetScript("OnTooltipSetItem", o.Tooltips_h_OnTooltipSetItem);
	tooltip.VendorValues = instance;
end



do
	local MerchantFrame = MerchantFrame;
	local GetItemInfo = GetItemInfo;
	local tonumber = tonumber;
	local loc_RECIPE = o.Localization.TYPE_RECIPE;
	
	function o.Tooltips_h_OnTooltipSetItem(self)
		local instance = self.VendorValues;
		local orig = instance.orig_OnTooltipSetItem;
		if (orig ~= nil) then orig(self); end
		
		local name, link = self:GetItem();
		if (name == nil or name == "") then
			-- This either isn't an item (nil) or isn't yet cached ("").
			-- If it's not cached, the tooltip will be manipulating itself as the item becomes cached. Do not set up yet if so.
			return;
		end
		local itemID = tonumber(link:match("item:(%d+)"));
		
		-- Most Recipe-type items call OnTooltipSetItem twice, both with the same itemID. This must be stopped.
		if (instance.lastItemID == itemID) then
			local _, _, _, _, _, itemType = GetItemInfo(itemID);
			if (itemType == loc_RECIPE) then
				if (instance.separatorLine ~= nil) then
					instance.separatorLine:SetText("");
				end
				if (instance.moneyLine ~= nil) then
					instance.moneyLine:SetText("");
				end
				if (instance.currMoneyFrame ~= nil) then
					instance.currMoneyFrame:Hide();
					local newNum = self.shownMoneyFrames;
					if (newNum ~= nil) then
						newNum = (newNum - 1);
						self.shownMoneyFrames = ((newNum ~= 0 and newNum) or nil);
					end
				end
			end
		end
		
		local quantity, source = self.TooltipItemQuantities2:GetItemQuantity();
		if ((source == "SetAction" or source == "SetBagItem" or source == "SetBuybackItem") and MerchantFrame:IsShown() ~= nil) then
			return;
		end
		
		instance:AddVendorValue(itemID, quantity);
	end
end




do
	local loc_DEFAULT_PREFIX = o.Localization.DEFAULT_PREFIX;
	local loc_DEFAULT_PREFIX_STACK = o.Localization.DEFAULT_PREFIX_STACK;
	
	function o.Tooltips_CreatePrefixText(itemID, quantity)
		local prefix = nil;
		
		if (o.config.hidePrefix ~= true) then
			local _, _, _, _, _, _, _, maxStack = GetItemInfo(itemID);
			if (maxStack == 1 or maxStack == nil) then
				prefix = (o.config.prefix or loc_DEFAULT_PREFIX);
			else
				prefix = (o.config.prefixStack or loc_DEFAULT_PREFIX_STACK):format(quantity);
			end
		else
			prefix = (" ");
		end
		
		return prefix;
	end
end




function m:AddVendorValue(itemID, quantity)
	if (quantity == nil or quantity == 0) then
		quantity = 1;
	end
	
	local parent = self.parent;
	
	if (o.config.hideSeparator ~= true) then
		parent:AddLine("-=-=-=-=-=-=-=-=-", (o.config.textR or 1.0), (o.config.textG or 1.0), (o.config.textB or 1.0));
		self.separatorLine = _G[parent:GetName() .. "TextLeft" .. parent:NumLines()];
	else
		self.separatorLine = nil;
	end
	
	self:AddMoneyLine();
	local price;
	if (self.lastItemID == itemID) then
		-- Avoid a database lookup.
		price = self.cachedPrice;
	else
		price = GetSellValue(itemID);
		self.lastItemID = itemID;
		self.cachedPrice = price;
	end
	if (price ~= nil) then
		price = (price * quantity);
	end
	self:SetupMoneyLineInfo(price, o.Tooltips_CreatePrefixText(itemID, quantity));
	
	parent:Show();
end




function m:AddMoneyLine()
	local tooltip = self.parent;
	local tooltipName = tooltip:GetName();
	SetTooltipMoney(tooltip, 0);
	
	local moneyLine = _G[tooltipName .. "TextLeft" .. tooltip:NumLines()];
	self.moneyLine = moneyLine;
	moneyLine:SetTextColor((o.config.textR or 1.0), (o.config.textG or 1.0), (o.config.textB or 1.0));
	
	local moneyFrame = _G[tooltipName .. "MoneyFrame" .. tooltip.shownMoneyFrames];
	self.currMoneyFrame = moneyFrame;
	moneyFrame:SetPoint("LEFT", moneyLine, "RIGHT", 4, 0);
end



do
	local loc_VALUE_NONE = NONE:lower();
	local loc_VALUE_UNKNOWN = UNKNOWN:lower();
	
	function m:SetupMoneyLineInfo(money, prefixText)
		local lineText = prefixText;
		local minWidth = -10;
		
		local moneyFrame = self.currMoneyFrame;
		if (money ~= nil) then
			if (money ~= 0) then
				moneyFrame:Show();
				MoneyFrame_Update(moneyFrame:GetName(), money);
				minWidth = (minWidth + moneyFrame:GetWidth());
			else
				moneyFrame:Hide();
				lineText = (lineText .. " " .. loc_VALUE_NONE);
			end
		else
			moneyFrame:Hide();
			lineText = (lineText .. " " .. loc_VALUE_UNKNOWN);
		end
		
		local moneyLine = self.moneyLine;
		moneyLine:SetText(lineText);
		minWidth = (minWidth + moneyLine:GetWidth());
		
		self.parent:SetMinimumWidth(minWidth);
	end
end

