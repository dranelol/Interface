--LOADER-----------------------------------------------------------------------------------
BalancePowerTracker = BalancePowerTracker or {}
BalancePowerTracker.modules = BalancePowerTracker.modules or {}

local BalancePowerTracker = BalancePowerTracker
local GetSpellCooldown,type,pairs,select,print,GetSpellInfo = GetSpellCooldown,type,pairs,select,print,GetSpellInfo
BalancePowerTracker.name = "BalancePowerTracker"

local options = nil;
local loaded = false;
local class = select(2,UnitClass("player"))
local resetScheduled = false --TODO change to false to avoid reseting options

local function deepCopy(something)
	if type(something) ~= "table" then
		return something
	end
	
	local ret = {}
	for k,v in pairs(something) do
		ret[k]=deepCopy(v)
	end
	return ret;
end

local function greaterOrEqualThan (t1,t2)
	for i,v in ipairs(t2) do
		local value1 = tonumber(t1[i]) or 0
		local value2 = tonumber(v)
		if value1 ~= value2 then
			return value1 > value2
		end
	end
	return true
end

local function createFunctionToSearchOptions(moduleKey)
	local local_options = options[moduleKey];
	local global_options = options.global

	return function(nameVar,value,set)
		if set then
			local_options[nameVar] = deepCopy(value);
			return local_options[nameVar]
		else
			if local_options.get_global and global_options[nameVar]~=nil then
				return global_options[nameVar]
			end

			if local_options[nameVar]~=nil then
				return local_options[nameVar];
			end

			local_options[nameVar] = deepCopy(value);
			return local_options[nameVar]
		end
	end,
	function()
		local_options = options[moduleKey];
		global_options = options.global
	end
end

-- Masque -------------------------------------------
local Masque
local function Masque_Init()
	Masque = LibStub and LibStub("Masque",true)
end

local function Masque_CreateGroup(name,frames)
	if not Masque then return end
	
	local Group = Masque:Group(BalancePowerTracker.name,name)
	for k,v in pairs(frames) do
		Group:AddButton(v.frame,v.buttonData)
	end
end
function Masque_Reskin(name)
	if not Masque then return end
	Masque:Group(BalancePowerTracker.name,name):ReSkin()
end
-----------------------------------------------------

local frame = CreateFrame("Frame",nil,UIParent);
frame:RegisterEvent("PLAYER_LOGIN");
frame:SetScript("OnEvent",function()
	local text = "|c00a080ff"..BalancePowerTracker.name.." v"..GetAddOnMetadata(BalancePowerTracker.name, "Version") .."|r: "
	
	Masque_Init()
	loaded = true
	
	local err = BalancePowerTracker.CheckAll()
	
	if err then 
		print(text..err)
		return
	end
	
	text = text.."Loaded."
	
	if not options.global.slashShown then
		text = text.." (Config: /bpt )"
		options.global.slashShown = true
	end

	if not options.global.muted then
		print(text);
	end
end)

function BalancePowerTracker.CheckAll(fromOptions)
	if not loaded then return "Not loaded" end
	
	local ACR = (not fromOptions) and LibStub and LibStub("AceConfigRegistry-3.0",true)
	if ACR then ACR:NotifyChange(BalancePowerTracker.name) end	

	do 	--Check options
		local hasBeenReset = BalancePowerTracker_Options == nil
		local version = {strmatch(GetAddOnMetadata(BalancePowerTracker.name, "Version"),"^(.*)%.(.*)%.(.*)$")}
		
		BalancePowerTracker_Options = BalancePowerTracker_Options or {}
		options = BalancePowerTracker_Options
		options.global = options.global or {enabled = true}
		
		if resetScheduled and (not hasBeenReset) and not (options.global.version and greaterOrEqualThan(options.global.version, version)) then
			BalancePowerTracker_Options = {global = {enabled = true, version = version}}
			options.old = nil
			
			BalancePowerTracker_Options.old = options
			options = BalancePowerTracker_Options
			
			print("|c00a080ff"..BalancePowerTracker.name.."|r: Settings reset required: Done. Old settings stored in BalancePowerTracker_Options.old")	
		end
		options.global.version = options.global.version or version
		
		LBPT_WILD_BATTLE_PET_LOCALIZED_TRY = (BalancePowerTracker.WILDBATTLEPET_LOCALIZED and BalancePowerTracker.WILDBATTLEPET_LOCALIZED[GetLocale()]) or LBPT_WILD_BATTLE_PET_LOCALIZED_TRY
		LBPT_CRITTER_LOCALIZED_TRY = (BalancePowerTracker.CRITTER_LOCALIZED and BalancePowerTracker.CRITTER_LOCALIZED[GetLocale()]) or LBPT_CRITTER_LOCALIZED_TRY
	end
	
	if not (options and BalancePowerTracker.modules and type(BalancePowerTracker.modules)=="table" ) then 
		return "Critical error."
	end
	
	for k,v in pairs(BalancePowerTracker.modules) do
		if (not v.class) or v.class[class] then 
			if options.global.profile and BalancePowerTracker.profiles and BalancePowerTracker.profiles.getProfileOptions then
				options[k] = BalancePowerTracker.profiles.getProfile(options.global.profile,k)
			else
				options[k] = options[k] or {}
			end
		
			if options[k].load == nil then 
				options[k].load = v.loadedByDefault 
			end
		
			if (not v.loaded) and options[k].load and options.global.enabled then 
				local err = v.LoadModule(createFunctionToSearchOptions(k))
				if err then
					print("|c00a080ff"..BalancePowerTracker.name.."|r: Error loading module "..err)
					options[k].load = false
				else
					if v.masque then
						if not v.masque.created then
							Masque_CreateGroup(v.masque.name,v.masque.frames)
							v.masque.created = true
						end
						Masque_Reskin(v.masque.name)
					end
				end
			elseif v.loaded then
				if not (options[k].load and options.global.enabled) then
					v.UnloadModule()
				else
					v.ReDraw()
					if v.masque then
						Masque_Reskin(v.masque.name)
					end
				end
			end	
		
		
		end
	end
end

function BalancePowerTracker.isBalance()
	return GetSpellCooldown(GetSpellInfo(78674))~=nil 
end

--/slash command
SLASH_BALANCEPOWERTRACKER1,SLASH_BALANCEPOWERTRACKER2= '/balancepowertracker','/bpt';
function SlashCmdList.BALANCEPOWERTRACKER(msg, editbox) --Slash command function
	local reason = select(6,GetAddOnInfo("BalancePowerTracker_Options"));
	local loaded;
			
	if not reason then
		loaded,reason = LoadAddOn("BalancePowerTracker_Options") 
	end
			
	if loaded ~= 1 then
		local msg = "|c00a080ff"..BalancePowerTracker.name.."|r: Couldn't load: ".."BalancePowerTracker_Options"
		
		local localizedReason = _G["ADDON_"..reason]
		
		if localizedReason then
			msg = msg..": "..localizedReason..".";
		else
			msg = msg.."."
		end
		print(msg);
		return
	end
	
	InterfaceOptionsFrame_OpenToCategory(BalancePowerTracker.name)
end



