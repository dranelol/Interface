local numaddons = GetNumAddOns();
local numloaded = 0;
local lines = 10;
local changes = {};
local numtobe = 0;

local addondb = {};
local dbinit = 0;
local lineplusoffset; -- an index into our data calculated from the scroll offset

function OomniMenu_OnClick() -- See note 1
  UIDropDownMenu_SetSelectedValue(this.owner, this.value);

  if (this.value == 0) then
    -- No addons
    for i = 1, numaddons do
      addondb[i] = "0";
    end
  elseif (this.value == 1) then
    -- Enable all
    for i = 1, numaddons do
      addondb[i] = "1";
    end
  end
  OomniBar_Update();
end

function OomniMenu_Initialise()
 level = level or 1 --drop down menus can have sub menus. The value of "level" determines the drop down sub menu tier.
 
 local info = UIDropDownMenu_CreateInfo();


 info.text = "No Addons";
 info.value = 0;
 info.func = function() OomniMenu_OnClick() end;
 info.owner = this:GetParent();
 info.checked = nil;
 info.icon = nil;
 UIDropDownMenu_AddButton(info, level);

 info.text = "All Addons";
 info.value = 1;
 info.func = function() OomniMenu_OnClick() end;
 info.owner = this:GetParent();
 info.checked = nil;
 info.icon = nil;
 UIDropDownMenu_AddButton(info, level);
end

function Oomni_Init()
  OomniBar:Show();

  -- drop down menu
  OomniMenu = CreateFrame("Frame", "OomniMenu", UIParent, "UIDropDownMenuTemplate");
  OomniMenu:SetPoint("TOPRIGHT","OomniMain",5,-8); --This is the only frame inherited method along with Frame:Show() and Frame:Hide();
  UIDropDownMenu_SetWidth(OomniMenu, 100);
  UIDropDownMenu_SetButtonWidth(OomniMenu, 20);
  UIDropDownMenu_Initialize(OomniMenu, OomniMenu_Initialise);

  -- options button
  OomniOptions = CreateFrame("Button", "OomniOptions", UIParent, "OptionsButtonTemplate");
  OomniOptions:SetPoint("TOP","GameMenuFrame",0,3); --This is the only frame inherited method along with Frame:Show() and Frame:Hide();
  OomniOptions:SetWidth(120);
  OomniOptions:SetText("Oomni Manager");
  OomniOptions:SetFrameStrata("TOOLTIP");
  OomniOptions:SetScript("OnClick", function(self) Oomni_InitDB() OomniMain:Show() OomniMenu:Show() HideUIPanel(GameMenuFrame) end);
  GameMenuFrame:SetScript("OnShow", function(self) OomniOptions:Show() end);
  GameMenuFrame:SetScript("OnHide", function(self) OomniOptions:Hide() end);
  OomniOptions:Hide();

  --UIDropDownMenu_SetWidth(OomniOptions, 100);
  --UIDropDownMenu_SetButtonWidth(OomniOptions, 20);
  --UIDropDownMenu_Initialize(OomniMenu, OomniMenu_Initialise);

  Oomni_UpdateChanges();
  OomniBar_Update();

  SLASH_OOMNI1 = "/oomni";
  SlashCmdList["OOMNI"] = Oomni_DoCmd;

  OomniMain:SetBackdropColor(1,1,1,1);

  OomniMain:Hide();
  OomniMenu:Hide();
end

function Oomni_UpdateChanges()
  local totalmem = 0;
  UpdateAddOnMemoryUsage();
  numloaded = 0;
  for i = 1,numaddons do
    local name,title = GetAddOnInfo(i);
    if (IsAddOnLoaded(i)) then
      totalmem = totalmem + floor(GetAddOnMemoryUsage(i));
      numloaded = numloaded + 1;
    end
  end
  Oomni_Stats1:SetJustifyH("LEFT");
  Oomni_Stats1:SetText("Addons\r" .. numloaded .. " of " .. numaddons .. " loaded\r" .. "Total memory: " .. totalmem .. "kb");
end

function Oomni_EnableDisable(row)
  local addonnum = lineplusoffset - (10 - row);
  local name,title = GetAddOnInfo(addonnum);
  if (addondb[addonnum] == "1") then
    addondb[addonnum] = "0";
  else
    addondb[addonnum] = "1";
  end
  OomniBar_Update();
end

function Oomni_ResetAll()
  for i = 1, numaddons do
    if (IsAddOnLoaded(i)) then
      addondb[i] = "1";
    else
      addondb[i] = "0";
    end
  end
  OomniBar_Update();
end

function Oomni_SaveReload()
  for i = 1, numaddons do
    if (addondb[i] == "1") then
      EnableAddOn(i);
    else
      DisableAddOn(i);
    end
  end
  ReloadUI();
end

function Oomni_InitDB()
  if (dbinit == 0) then
    -- init addondb
    for i = 1,numaddons do
      if (IsAddOnLoaded(i)) then
        addondb[i] = "1";
      else
        addondb[i] = "0";
      end
    end
    dbinit = 1;
  end
end

function Oomni_DoCmd()
  Oomni_InitDB();
  OomniMain:Show();
  OomniMenu:Show();
end

function Oomni_LoD()
  DEFAULT_CHAT_FRAME:AddMessage("Attempting LoadOnDemand Addons");
  local disaddons = "";
  for i = 1,numaddons do
    local name, title = GetAddOnInfo(i);
    if (addondb[i] == "1") then
      EnableAddOn(i);
      local loaded, reason = LoadAddOn(i);
      if not loaded then
        DEFAULT_CHAT_FRAME:AddMessage(title .. " failed to load. (" .. reason .. ")");
      end
    else
      if(IsAddOnLoaded(i)) then
        disaddons = disaddons .. title .. ",";
      end
      DisableAddOn(i);
    end
  end
  if (disaddons == "") then
  else
    DEFAULT_CHAT_FRAME:AddMessage("The following addons cannot be unloaded until you reload your UI: " .. disaddons);
  end
  OomniBar_Update();
end

function Oomni_NewPreset()
  DEFAULT_CHAT_FRAME:AddMessage("Presets currently disabled");
end

function OomniBar_Update()
  Oomni_UpdateChanges();

  local line; -- 1 through 5 of our window to scroll
  FauxScrollFrame_Update(OomniBar,numaddons,lines,16);
  for line=1,lines do
    lineplusoffset = line + FauxScrollFrame_GetOffset(OomniBar);
    if lineplusoffset <= numaddons then
	local name,title = GetAddOnInfo(lineplusoffset);
	local isloaded = IsAddOnLoaded(lineplusoffset);
	if (addondb[lineplusoffset] == "1") then
	  local memusage = floor(GetAddOnMemoryUsage(lineplusoffset));
          getglobal("OomniAddon"..line):SetChecked(1);
          if (IsAddOnLoaded(lineplusoffset)) then
	    getglobal("OomniAddon"..line.."Text"):SetText(title .. " (" .. memusage .. "kb)");
	  else
	    getglobal("OomniAddon"..line.."Text"):SetText(title .. " (|cff00ff00Will be enabled|r)");
	  end
	else
          getglobal("OomniAddon"..line):SetChecked(0);
	  if (IsAddOnLoaded(lineplusoffset)) then
            getglobal("OomniAddon"..line.."Text"):SetText(title .. " (|cffff0000Will be disabled|r)");
	  else
            getglobal("OomniAddon"..line.."Text"):SetText(title);
	  end
	end
        getglobal("OomniAddon"..line.."Text"):SetTextColor(1,1,1);
        getglobal("OomniAddon"..line):Show();
    else
      getglobal("OomniAddon"..line):Hide();
    end
  end
end
