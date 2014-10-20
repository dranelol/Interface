local L;


function SGI:LoadLocale()
	local Locale = GetLocale()
	if SGI_Locale[Locale] then 
		SGI.L = SGI_Locale[Locale]
		L = SGI.L;
		SGI:print(L["English Locale loaded"]..L["Author"])
		return true
	else
		SGI.L = SGI_Locale["enGB"]
		SGI:print("|cffffff00Locale missing! Loaded English.|r")
		return false
	end

end

function SGI:FormatTime2(T)
	local R,S,M,H = ""
	T = floor(T)
	H = floor(T/3600)
	M = floor((T-3600*H)/60)
	S = T-(3600*H + 60*M)
		
	if T <= 0 then
		return L[" < 1 sec"]
	end
		
	if H ~= 0 then
		R =  R..H..L["h "]
	end
	if M ~= 0 then
		R = R..M..L["m "]
	end
	if S ~= 0 then
		R = R..S..L["s"]
	end
	
	return R
end

function SGI:FormatTime(T)
	local R,S,M,H = ""
	T = floor(T);
	H = floor(T/3600)
	M = floor((T-3600*H)/60)
	S = T-(3600*H + 60*M)
	
	if (T <= 0) then
		return SGI.L[" < 1 sec"];
	end
	
	if (H > 0) then
		R = R..H..":";
	end
	if (M > 9) then
		R = R..M..":";
	elseif (M > 0) then
		R = R.."0"..M..":";
	elseif (M == 0) then
		R = R.."00:";
	end
	if (S > 9) then
		R = R..S;
	elseif (S > 0) then
		R = R.."0"..S;
	elseif (S == 0) then
		R = R.."00";
	end
	
	return R;
end
		

function SGI:CountTable(T)
	local i = 0
	if type(T) ~= "table" then
		return i
	end
	for k,_ in pairs(T) do
		i = i + 1
	end
	return i
end

function SGI:GetClassColor(classFileName)
	return SGI_CLASS_COLORS[classFileName];
end

function SGI:CompareVersions(V1, V2)
	local p11 = tonumber(strsub(V1,1,strfind(V1,".",1,true)-1));
	local p12 = tonumber(strsub(V1,strfind(V1,".",1,true)+1));
	local p21 = tonumber(strsub(V2,1,strfind(V2,".",1,true)-1));
	local p22 = tonumber(strsub(V2,strfind(V2,".",1,true)+1));
	
	if (p11 == p21) then
		if (p22 > p12) then
			return V2;
		else 
			return V1;
		end
	elseif (p21 > p11) then
		return V2;
	else
		return V1;
	end
end

function SGI:ResetFix()
	if (not SGI_DATA.resetFix) then
		SGI_DATA = {};
		SGI_DATA.resetFix = true;
	end
end

function SGI:divideString(str,div)
	local out = {}
	local i = 0
	while strfind(str,div) do
		i = i + 1
		out[i] = strsub(str,1,strfind(str,div)-1)
		str = strsub(str,strfind(str,div)+1)
	end
	out[i+1] = str
	return out
end

local function FrameReset()
	SGI_DATA[SGI_DATA_INDEX].settings.frames = {}
	ReloadUI();
end

local reloadWarning = true;
local reloadWarning2 = true;
function SlashCmdList.SUPERGUILDINVITE(msg)

	msg = strlower(msg);

	if msg == "reset" then
		local lock = SGI_DATA.lock
		SGI_DATA = nil
		SGI_EVENTS["PLAYER_LOGIN"]()
		SGI_DATA.lock = lock
	elseif (msg == "framereset") then
		if (reloadWarning) then
			SGI:print("WARNING: Reseting your frames requires a reload of the User Interface! If you wish to proceed, type \"/sgi framereset\" again!");
			reloadWarning = false;
		else
			FrameReset();
		end
	elseif (msg == "opt" or msg == "options" or msp == "config" or msg == "settings" or msg == "show") then
		SGI:ShowOptions();
	elseif (msg == "debug") then
		SGI_DATA[SGI_DATA_INDEX].debug = not SGI_DATA[SGI_DATA_INDEX].debug;
		if (SGI_DATA[SGI_DATA_INDEX].debug) then
			SGI:print("Activated debugging!");
		else
			SGI:print("Deactivated debugging!");
		end
		SGI:DebugState(SGI_DATA[SGI_DATA_INDEX].debug);
	elseif (msg == "changes") then
		SGI:ShowChanges();
	elseif (msg == "stats") then
		local amountScanned, amountGuildless, amountQueued, sessionTotal = SGI:GetSuperScanStats();
		SGI:print("Scanned players this scan: |r|cff0062FF"..amountScanned.."|r");
		SGI:print("Guildless players this scan: |r|cff0062FF"..amountGuildless.."|r");
		SGI:print("Queued players this scan: |r|cff0062FF"..amountQueued.."|r");
		SGI:print("Total players scanned this session: |r|cff0062FF"..sessionTotal.."|r");
	elseif (msg == "unbind" or msg == "removekeybind") then
		SGI:print("Cleared SGI invite keybind");
		SGI_DATA[SGI_DATA_INDEX].keyBind = nil;
	elseif (strfind(msg, "lock")) then
		local name = strsub(msg, 6);
		if (name) then
			SGI:LockPlayer(name);
		end
	else
		local temp = SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_SGI_MUTE"];
		SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_SGI_MUTE"] = false;
		SGI:print("|cffffff00Commands: |r|cff00A2FF/sgi or /superguildinvite|r")
		SGI:print("|cff00A2FFreset |r|cffffff00to reset all data except locks|r")
		SGI:print("|cff00A2FFframereset|r|cffffff00 resets the positions of the frames |r")
		SGI:print("|cff00A2FFunbind|r|cffffff00 removes the saved keybind|r");
		SGI:print("|cff00A2FFoptions|r|cffffff00 shows the options. Same effect as clicking the minimap button|r")
		SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_SGI_MUTE"] = temp;
	end
end

SGI:debug(">> Core.lua");