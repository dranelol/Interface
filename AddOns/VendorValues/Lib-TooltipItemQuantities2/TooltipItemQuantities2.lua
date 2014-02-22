
local o;
do
	local VERSION = 20100;
	o = (TooltipItemQuantities2 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		TooltipItemQuantities2 = o;
		o.OLD_VERSION = o.VERSION;
		o.VERSION = VERSION;
	else
		return;
	end
end
local m = {};
local m_metatable = (o.METATABLE or {});
m_metatable.__index = m;

-- GetVersion: minor, subminor = ()
--
-- GetWrapperHandler: handler = ()
-- SetWrapperHandler: (newFunc)
--
-- RegisterTooltip: (tooltip)
--
-- m:GetItemQuantity: quantity, source = (self)
--
-- OnTooltipItemMethodCalled: (methodName, tooltip, ...)
--
-- QUANTITY_FUNCS_BY_METHOD.SetHyperlink[1]: quantity = ()
-- QUANTITY_FUNCS_BY_METHOD.SetInventoryItem[1]: quantity = (unit, slot)
-- QUANTITY_FUNCS_BY_METHOD.SetQuestLogItem[1]: quantity = (logType, ID)
-- QUANTITY_FUNCS_BY_METHOD.SetTradeSkillItem[1]: quantity = (selectedSkill, ID)

-- [method] = { function to get quantity, return index from that function which holds the quantity };
o.QUANTITY_FUNCS_BY_METHOD = {
	["SetAction"] = { GetActionCount };
	["SetAuctionItem"] = { GetAuctionItemInfo, 3 };
	["SetAuctionSellItem"] = { GetAuctionSellItemInfo, 3 };
	["SetBagItem"] = { GetContainerItemInfo, 2 };
	["SetBuybackItem"] = { GetBuybackItemInfo, 4 };
	["SetGuildBankItem"] = { GetGuildBankItemInfo, 2 };
	["SetHyperlink"] = {};
	["SetInboxItem"] = { GetInboxItem, 3 };
	["SetInventoryItem"] = {};
	["SetLootItem"] = { GetLootSlotInfo, 3 };
	["SetLootRollItem"] = { GetLootRollItemInfo, 3 };
	["SetMerchantItem"] = { GetMerchantItemInfo, 4 };
	["SetMerchantCostItem"] = { GetMerchantItemCostItem, 2 };
	["SetQuestItem"] = { GetQuestItemInfo, 3 };
	["SetQuestLogItem"] = {};
	["SetSendMailItem"] = { GetSendMailItem, 3 };
	["SetTradePlayerItem"] = { GetTradePlayerItemInfo, 3 };
	["SetTradeTargetItem"] = { GetTradeTargetItemInfo, 3 };
	["SetTradeSkillItem"] = {};
};

o.WRAPPERS = (o.WRAPPERS or {});
do
	local l_handler = ((o.GetWrapperHandler ~= nil and o.GetWrapperHandler()) or nil);
	for methodName in pairs(o.QUANTITY_FUNCS_BY_METHOD) do
		if (o.WRAPPERS[methodName] == nil) then
			o.WRAPPERS[methodName] = (function(...) return l_handler(methodName, ...); end);
		end
	end
	if (o.GetWrapperHandler == nil) then
		function o.GetWrapperHandler()
			return l_handler;
		end
		function o.SetWrapperHandler(newFunc)
			l_handler = newFunc;
		end
	end
end




function o.RegisterTooltip(tooltip)
	local instance = tooltip.TooltipItemQuantities2;
	if (instance == nil) then
		instance = {};
		tooltip.TooltipItemQuantities2 = instance;
	end
	
	for methodName, wrapper in pairs(o.WRAPPERS) do
		if (instance[methodName] == nil) then
			instance[methodName] = tooltip[methodName];
			tooltip[methodName] = wrapper;
		end
	end
	
	setmetatable(instance, m_metatable);
end




function m:GetItemQuantity()
	return self.quantity, self.sourceMethod;
end




function o.OnTooltipItemMethodCalled(methodName, tooltip, ...)
	local methodData = o.QUANTITY_FUNCS_BY_METHOD[methodName];
	local quantityFunc = methodData[1];
	local returnIndex = methodData[2];
	local quantity, _;
	if (returnIndex == 2) then
		_, quantity = quantityFunc(...);
	elseif (returnIndex == 3) then
		_, _, quantity = quantityFunc(...);
	elseif (returnIndex == 4) then
		_, _, _, quantity = quantityFunc(...);
	else
		quantity = quantityFunc(...);
	end
	
	local instance = tooltip.TooltipItemQuantities2;
	instance.quantity = (quantity or 0);
	instance.sourceMethod = methodName;
	return instance[methodName](tooltip, ...);
end

o.SetWrapperHandler(o.OnTooltipItemMethodCalled);




do
	local tonumber = tonumber;
	
	o.QUANTITY_FUNCS_BY_METHOD.SetHyperlink[1] = function()
		return (tonumber(this.count) or 1);
	end
end



do
	local GetInventoryItemCount = GetInventoryItemCount;
	
	o.QUANTITY_FUNCS_BY_METHOD.SetInventoryItem[1] = function(unit, slot)
		local quantity = nil;
		if (slot > 17 and slot < 24) then
			-- This is a bag. GetInventoryItemCount will return the number of slots instead of 1.
			quantity = 1;
		else
			quantity = GetInventoryItemCount(unit, slot);
		end
		return quantity;
	end
end



do
	local GetQuestLogRewardInfo = GetQuestLogRewardInfo;
	
	o.QUANTITY_FUNCS_BY_METHOD.SetQuestLogItem[1] = function(logType, ID)
		local _, _, quantity = GetQuestLogRewardInfo(ID);
		return quantity;
	end
end



do
	local mathceil = math.ceil;
	local GetTradeSkillReagentInfo = GetTradeSkillReagentInfo;
	local GetTradeSkillNumMade = GetTradeSkillNumMade;
	
	o.QUANTITY_FUNCS_BY_METHOD.SetTradeSkillItem[1] = function(selectedSkill, ID)
		local quantity = nil;
		if (ID ~= nil) then
			local _;
			_, _, quantity = GetTradeSkillReagentInfo(selectedSkill, ID);
		else
			local minMade, maxMade = GetTradeSkillNumMade(selectedSkill);
			quantity = mathceil(((minMade or 2) + (maxMade or 0)) / 2);
		end
		return quantity;
	end
end
