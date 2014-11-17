local ADDON_NAME, private = ...

local _G = getfenv(0)
local LibStub = _G.LibStub

local Garrison = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)

local SECONDS_PER_HOUR = 60 * 60
local SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR

local pairs, tonumber, string, print, table, math, assert, loadstring, tostring = _G.pairs, _G.tonumber, _G.string, _G.print, _G.table, _G.math, _G.assert, _G.loadstring, _G.tostring
local sort, select, format, type, setmetatable, getmetatable, next = table.sort, _G.select, string.format, _G.type, _G.setmetatable, _G.getmetatable, _G.next

local GetAtlasInfo = _G.GetAtlasInfo

local garrisonDb, globalDb, configDb
local charInfo = Garrison.charInfo

function Garrison.tableSize(T)
	local count = 0
	if T then
		for _ in pairs(T) do count = count + 1 end
	end
	return count
end

local function deepcopy(o, seen)
  seen = seen or {}
  if o == nil then return nil end
  if seen[o] then return seen[o] end

  local no
  if type(o) == 'table' then
    no = {}
    seen[o] = no

    for k, v in next, o, nil do
      no[deepcopy(k, seen)] = deepcopy(v, seen)
    end
    setmetatable(no, deepcopy(getmetatable(o), seen))
  else -- number, string, boolean, etc
    no = o
  end
  return no
end
Garrison.deepcopy = deepcopy

function Garrison.round(num, idp)
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

local function debugPrint(text)
	if(configDb.debugPrint) then
		if type(text) == 'table' then
			local i = 0
			for k,v in pairs(text) do
				i = i + 1
				print(("%s: (%i) %s = %s"):format(ADDON_NAME, i, k, tostring(v or 'nil')))
			end
		else
			print(("%s: %s"):format(ADDON_NAME, tostring(text or 'nil')))
		end
	end
end

if AdiDebug then
	AdiDebug:Embed(Garrison, ADDON_NAME)
else
	Garrison.Debug = debugPrint
end
Garrison.debugPrint = Garrison.Debug

--Garrison.debugPrint = 

function Garrison.pairsByKeys(t,f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
	return iter
end

local unitColor = {}
local lexcmps = {}
local lexsort
do
	local function sortByValue(t,f)
		local a = {}
			for k,v in pairs(t) do table.insert(a, { key = k, value = v })
			end
			table.sort(a, f)
			local i = 0      -- iterator variable
			local iter = function ()   -- iterator function
				i = i + 1
				if a[i] == nil then return nil
				else return a[i].key, a[i].value
				end
			end
		return iter
	end

 	local function lexcmp(...)
		local code = {"local lhs, rhs = ..."}
		local cnt = select('#', ...)
	 	for i = 1, cnt do
	  		local k = select(i, ...)
	 		local key,v = string.match(k, '([%a.]*),?([ad]?)')
	 		code[#code+1] = format("local lv, rv, key, desc = lhs.value.%s, rhs.value.%s, '%s', %s", key, key, key, tostring(v == '' or v == 'd'))
			--de[#code+1] = "print(('%s/%s - %s: %s <> %s = %s'):format(lname, rname, key, lv or '-', rv or '-', 'ret'))"
			code[#code+1] = "if lv == nil and rv ~= nil then return false end"
			code[#code+1] = "if lv ~= nil and rv == nil then return true end"
			code[#code+1] = "if lv ~= nil and rv ~= nil then"
			code[#code+1] = "  if type(lv) == 'boolean' and type(rv) == 'boolean' then"
			code[#code+1] = "		lv, rv = (lv == true and 1 or 0), (rv == true and 1 or 0)"
			code[#code+1] = "  end"
			code[#code+1] = "  if desc and (lv > rv) then return true end"
			code[#code+1] = "  if desc and (lv < rv) then return false end"
			code[#code+1] = "  if not desc and (lv < rv) then return true end"
			code[#code+1] = "  if not desc and (lv > rv) then return false end"
			code[#code+1] = "end"
			if i == cnt then
	 			code[#code+1] = "return false"
			end
		end
		local retCode = table.concat(code, "\n")
		--print(retCode)
		return assert(loadstring(retCode))
	end
	function lexsort(t, ...)
		local key = table.concat({n=select('#',...),...}, "\0")
		local cmp = lexcmps[key]
		if not cmp then
 			cmp = lexcmp(...)
			lexcmps[key] = cmp
		end
		return sortByValue(t, cmp)
	end
end

function Garrison.GetIconPath(name) 
	local iconPath = Garrison.ICON_REPLACEMENT[name]

	if iconPath ~= nil then
		return iconPath
	else
		return name
	end
end

function Garrison.getIconString(name, size, isAtlas, ...)
	local icon

	if size and size == 0 then
		return ""
	end

	if name and size then
		local key = name.."-"..size

		if Garrison.iconCache[key] == nil then
			if isAtlas then
				local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(name);

				if filename then
					local atlasWidth = width / (txRight - txLeft);
					local atlasHeight = height / (txBottom - txTop);

					local pxLeft	= atlasWidth	* txLeft;
					local pxRight	= atlasWidth	* txRight;
					local pxTop		= atlasHeight	* txTop;
					local pxBottom	= atlasHeight	* txBottom;

					Garrison.iconCache[key] = string.format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, size, size, atlasWidth, atlasHeight, pxLeft, pxRight, pxTop, pxBottom);
				end

			else				
				local iconZoom = ...
				if iconZoom then			
					Garrison.iconCache[key] = string.format("\124T%s:%d:%d:1:0:64:64:4:60:4:60\124t", Garrison.GetIconPath(name), size, size)
				else
					Garrison.iconCache[key] = string.format("\124T%s:%d:%d:1:0\124t", Garrison.GetIconPath(name), size, size)
				end
			end
		end
		
		icon = Garrison.iconCache[key]
	end	
	
	if not icon then
		icon = string.format("\124T%s:%d:%d:1:0\124t", "Interface\\Icons\\INV_Misc_QuestionMark", size, size)
	end

	return icon
end

function Garrison.getColoredUnitName (name, class)
	local colorUnitName

	if(not unitColor[name]) then
		local classColor = Garrison.COLOR_TABLE[class]

		if not classColor then
			classColor = Garrison.colors.white
		end

		colorUnitName = string.format("|cff%02x%02x%02x%s|r",classColor.r*255,classColor.g*255,classColor.b*255,name)

		unitColor[name] = colorUnitName
	else
		colorUnitName = unitColor[name]
	end
	return colorUnitName
end

function Garrison.getColoredTooltipString(text, conditionTable)
	local retText = text

	for name, val in pairs(conditionTable) do
		if (val.condition) then
			retText = string.format("|cff%02x%02x%02x%s|r",val.color.r*255,val.color.g*255,val.color.b*255, text)
		end
	end

	return retText
end

function Garrison.getColoredString(text, color)
	return string.format("|cff%02x%02x%02x%s|r",color.r*255,color.g*255,color.b*255, text)
end

function Garrison.isCurrentChar(paramCharInfo)
	return paramCharInfo and charInfo and paramCharInfo.playerName == charInfo.playerName and paramCharInfo.realmName == charInfo.realmName
end

function Garrison.formattedSeconds(seconds)
	local negative = ""

	if not seconds then
		seconds = 0
	end

	if seconds < 0 then
		negative = "-"
		seconds = -seconds
	end
	local L_DAY_ONELETTER_ABBR = _G.DAY_ONELETTER_ABBR:gsub("%s*%%d%s*", "")

	if not seconds or seconds >= SECONDS_PER_DAY * 36500 then -- 100 years
		return ("%s**%s **:**"):format(negative, L_DAY_ONELETTER_ABBR)
	elseif seconds >= SECONDS_PER_DAY then
		return ("%s%d%s %d:%02d"):format(negative, seconds / SECONDS_PER_DAY, L_DAY_ONELETTER_ABBR, math.fmod(seconds / SECONDS_PER_HOUR, 24), math.fmod(seconds / 60, 60))
	else
		return ("%s%d:%02d:%02d"):format(negative, seconds / SECONDS_PER_HOUR, math.fmod(seconds / 60, 60), math.fmod(seconds, 60))
	end
end

function Garrison.formatRealmPlayer(paramCharInfo, colored)
	if not paramCharInfo then return "" end

	if colored then
		return ("%s (%s)"):format(Garrison.getColoredUnitName(paramCharInfo.playerName, paramCharInfo.playerClass), paramCharInfo.realmName)
	else
		return ("%s-%s"):format(paramCharInfo.playerName, paramCharInfo.realmName)
	end
end

function Garrison.getTableValue(data, ...) 
	if data then

		local cnt = select('#', ...)

		local cur = data

 		for i = 1, cnt do
	  		local k = select(i, ...)

	  		if cur[k] == nil and i == cnt then
	  			cur = nil
	  		elseif cur[k] then
				cur = cur[k]
			end			
		end

		if cur ~= nil then
			return cur
		end
	end
	
	return nil
end

function Garrison.replaceVariables(text, data)
	local returnText = ""
	if text then
		returnText = text:gsub("%%(%w+)|?([^%%]*)%%", function (s, default)
			local key = tostring(s)
			local textFun = Garrison.ldbVars[key]

			if textFun and textFun.data then
				return textFun.data(data) or default
			else				
				return ("[noval:%s]"):format(key)
	    	end
		end)
	end

	return returnText
end

function Garrison.getSortOptions(paramType, default)
	local sortConfig = configDb.tooltip[paramType].sort
	local groupConfig = configDb.tooltip[paramType].group

	local sortArray = {}
	local groupBy = {}

	local i = 1

	if groupConfig and groupConfig[1] then
		local configValue = Garrison.tooltipConfig[groupConfig[1].value]
		if configValue and configValue.value then
			sortArray[1] = ("%s,%s"):format(configValue.value, "a")

			for w in (configValue.value .. "."):gmatch("([^.]*).") do 
   				table.insert(groupBy, w) 
			end

			i = i + 1
		end
	end
	
	for k, v in pairs(sortConfig) do
		if k ~= '-' and Garrison.tooltipConfig[v.value] then

			local value = Garrison.tooltipConfig[v.value].value

			if value then
				sortArray[i] = ("%s,%s"):format(value, v.ascending and "a" or "d")
				i = i + 1
			end
		end
	end

	--debugPrint(sortArray)
	--debugPrint(groupBy)

	if #sortArray == 0 then
		sortArray[1] = default
	end

	return sortArray, groupBy
end


function Garrison:InitHelper()
	garrisonDb = self.DB
	configDb = garrisonDb.profile
	globalDb = garrisonDb.global

	Garrison.sort = lexsort
end