LootFilterVars = LootFilterVars or {};
 
LootFilter = {
	VERSION = GetAddOnMetadata("LootFilter", "X-Version"),
	LOOT_TIMEOUT = 30,
	LOOT_PARSE_DELAY = 0.5,
	LOOT_MAXTIME = 0,
	SCHEDULE_INTERVAL = 0.5;
	SELL_INTERVAL = 0.3;
	SELL_TIMEOUT = 30;
	SELL_ITEM_TIMEOUT = 10;
	SELL_QUEUE = 5;
	REALMPLAYER= "",
	NUMLINES = 10,
	REALMPLAYER = "",

	timerArr= {},
	hooked= false,
	lastUpdate= 0,
	hasFocus= 0;
	cleanList = {};
	marketValue = false;
};







