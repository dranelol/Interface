CreateFrame("Frame","SGI_EVENT_HANDLER");
SGI_EVENTS = {};

function SGI_EVENTS:PLAYER_LOGIN()
	
	
	
	-- Index used to separate settings for different characters.
	SGI_DATA_INDEX = UnitName("player").." - "..GetRealmName();
	
	-- Make sure the saved variables are correct.
	--General settings:
	if (type(SGI_DATA) ~= "table") then
		SGI_DATA = {};
	end
	
	-- Fix transition from 6.x to 7.x
	SGI:ResetFix()
	
	if (type(SGI_DATA.lock) ~= "table") then
		SGI_DATA.lock = {};
	end
	if (type(SGI_DATA.guildList) ~= "table") then
		SGI_DATA.guildList = {}
	end
	if (type(SGI_DATA.guildList[GetRealmName()]) ~= "table") then
		SGI_DATA.guildList[GetRealmName()] = {};
	end
	
	--Character based settings.
	if type(SGI_DATA[SGI_DATA_INDEX]) ~= "table" then
		SGI_DATA[SGI_DATA_INDEX] = {}
	end
	if type(SGI_DATA[SGI_DATA_INDEX].settings) ~= "table" then
		SGI_DATA[SGI_DATA_INDEX].settings = {
			inviteMode = 1,
			lowLimit = 1,
			highLimit = 90,
			raceStart = 90,
			classStart = 90,
			interval = 5,
			checkBox = {},
			dropDown = {},
			frames = {},
			filters = {},
		}
	end
	if type(SGI_DATA[SGI_DATA_INDEX].settings.whispers) ~= "table" then
		SGI_DATA[SGI_DATA_INDEX].settings.whispers = {}
	end
	if type(SGI_BACKUP) ~= "table" then
		SGI_BACKUP = SGI_DATA.lock
	end
	
	-- If there is a saved keybind, activate it.
	if (SGI_DATA[SGI_DATA_INDEX].keyBind) then
		SetBindingClick(SGI_DATA[SGI_DATA_INDEX].keyBind,"SGI_INVITE_BUTTON");
	end
	
	-- Anti spam. Users of the AddOn GuildShield are ignored.
	GuildShield:Initiate(SGI.RemoveShielded);
	-- Load locale
	SGI:LoadLocale();
	-- Load the minimap button
	if (not SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_HIDE_MINIMAP"]) then
		SGI:ShowMinimapButton();
	end
	-- Activate the keybind, if any.
	if (SGI_DATA[SGI_DATA_INDEX].keyBind) then	
		SetBindingClick(SGI_DATA[SGI_DATA_INDEX].keyBind, "SGI_INVITE_BUTTON2");
	end
	--Debugging, used for development
	SGI:DebugState(SGI_DATA[SGI_DATA_INDEX].debug);
	--Tell guildies what version you're running
	SGI:BroadcastVersion("GUILD");
	--Request lock sync from guildies
	SGI:RequestSync();
	--Remove locks that are > 2 months old
	SGI:RemoveOutdatedLocks();
	--Chat Intercept
	ChatIntercept:StateSystem(SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_HIDE_SYSTEM"]);
	ChatIntercept:StateWhisper(SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_HIDE_WHISPER"]);
	ChatIntercept:StateRealm(true);
	--Show changes, if needed
	SGI:debug((SGI_DATA[SGI_DATA_INDEX].settings.checkBox["SGI_CHANGES"] or "nil").." "..(SGI_DATA.showChanges or "nil"));
	if (not SGI_DATA[SGI_DATA_INDEX].settings.checkBox["SGI_CHANGES"] and SGI_DATA.showChanges ~= SGI.VERSION_MAJOR) then
		SGI:ShowChanges();
		SGI_DATA.showChanges = SGI.VERSION_MAJOR;
		SGI:debug("Show changes");
	end
	--Need to load the SuperScan frame for certain functions
	SGI:CreateSmallSuperScanFrame();
	SuperScanFrame:Hide();
end

function SGI_EVENTS:UPDATE_MOUSEOVER_UNIT()
	-- Create a list of players and their guild (if any).
	-- Used to prevent false positives.
	if (UnitIsPlayer("mouseover")) then
		local name = UnitName("mouseover");
		local guild = GetGuildInfo("mouseover");
		local realm = GetRealmName();
		
		if (not guild or guild == "") then return end
		
		if (type(SGI_DATA.guildList[realm][guild]) ~= "table") then
			SGI_DATA.guildList[realm][guild] = {};
		end
		for k,v in pairs(SGI_DATA.guildList[realm][guild]) do
			if (v == name) then
				return;
			end
		end
		tinsert(SGI_DATA.guildList[realm][guild], name);
		--SGI_DATA.guildList[realm][name] = guild;
	end
end

function SGI_EVENTS:PLAYER_LOGOUT()
	SendAddonMessage("SGI_STOP", "", "GUILD");
end

function SGI_EVENTS:CHAT_MSG_ADDON(event, ...)
	SGI:AddonMessage(event, ...);
end

function SGI_EVENTS:CHAT_MSG_SYSTEM(event, ...)
	SGI:SystemMessage(event,message,...)
end


for event,_ in pairs(SGI_EVENTS) do 
	SGI_EVENT_HANDLER:RegisterEvent(event);
end


SGI_EVENT_HANDLER:SetScript("OnEvent", function(self,event,...)
	SGI_EVENTS[event](self, event, ...);
end)

SGI:debug(">> Events.lua");