
local o;
do
	local VERSION = 20200;
	o = (ItemVendorPricesDB2 or {});
	if (o.VERSION == nil or o.VERSION < VERSION) then
		assert(EventsManager2, "ItemVendorPricesDB2 requires EventsManager2.");
		assert((NicheDevTools and NicheDevTools.PARSING_TOOLTIP), "ItemVendorPricesDB2 requires NicheDevTools.PARSING_TOOLTIP.");
		ItemVendorPricesDB2 = o;
		o.OLD_VERSION = o.VERSION;
		o.VERSION = VERSION;
		o.SHOULD_LOAD = true;
	else
		return;
	end
end

o.EventsManager2 = EventsManager2;
o.ItemPrice = LibStub:GetLibrary("ItemPrice-1.1");


function o.t_Init()
	o.t_Init = nil;
	
	local success, reason = LoadAddOn("Lib-ItemVendorPricesDB2_SavedVariables");
	
	o.DataManip_t_Init();
	
	o.SHOULD_LOAD = nil;
	
	if (success == nil) then
		error(("ItemVendorPricesDB2: Failed to load saved variables stub Lib-ItemVendorPricesDB2_SavedVariables, for the following reason: %s. The addon will attempt to continue operating normally, but errata cannot be saved."):format(tostring(getglobal(reason) or reason)));
	end
end
