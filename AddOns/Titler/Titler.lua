local enabled = 0;
local name = UnitName("player");
local lastcheck = 0;
local curtime = 0;
local interval = 3;
local numtitles = GetNumTitles();
local titledb = {};
local lines = 10;
local mytitles = 0;
local curtitle = 0;

local lineplusoffset; -- An index to hold our tables

function Titler_Track()
  if (enabled == 1) then
    curtime = floor(GetTime() * 1000);
    if (curtime - lastcheck >= (interval * 1000)) then
      curtitle = curtitle + 1;
      if (curtitle > mytitles) then
        curtitle = 0;
      end

      local settitle = 0;
      for i=curtitle,mytitles do
        if(savedb[i] == 1) then
          settitle = 1;
          SetCurrentTitle(titledb[i]);
          curtitle = i;
          break;
        end
      end

      -- Set to blank if all fails
      if (settitle == 0) then
        curtitle = -1;
      else
        lastcheck = curtime;
      end
    end
  end
end

function Titler_EnableDisable(row)
  local titlenum = lineplusoffset - (10 - row);
  if (savedb[titlenum-1] == 1) then
    savedb[titlenum-1] = 0;
  else
    savedb[titlenum-1] = 1;
  end
  TitlerBar_Update();
end

function UpdateDB()
  mytitles = 0;
  titledb[0] = "-1";
  numtitles = GetNumTitles();

  if(savedb[0] == nil) then
    savedb[0] = 1;
  end
  for i=1,numtitles do
    if (IsTitleKnown(i) > 0) then
      mytitles = mytitles + 1;
      titledb[mytitles] = i;
      if(savedb[mytitles] == nil) then
        savedb[mytitles] = 1;
      end
    end
  end
  TitlerBar_Update();
  Titler_Stats:SetText("You have " .. mytitles .. " of " .. numtitles .. " titles!");
end

function Titler_DisableAll()
  for i=0,mytitles do
    savedb[i] = 0;
  end
  TitlerBar_Update();
end

function Titler_EnableAll()
  for i=0,mytitles do
    savedb[i] = 1;
  end
  TitlerBar_Update();
end

function Titler_Run()
  if (enabled == 1) then
    Titler_StartStop:SetText("Start");
    enabled = 0;
  else
    Titler_StartStop:SetText("Stop");
    enabled = 1;
  end
end

function Titler_Init()
  -- Inits the database
  if(savedb == nil) then
    savedb = {};
    savedb[0] = 1;
    local titlecnt = 0;
    for i=1,numtitles do
      if(IsTitleKnown(i) > 0) then
        titlecnt = titlecnt + 1;
        savedb[titlecnt] = 1;
      end
    end
  end

  -- Creates the interval slider
  local MySlider = CreateFrame("Slider", "TitlerInterval", TitlerMain, 'OptionsSliderTemplate');
  MySlider:SetPoint('TOPLEFT', 20, -45);
  MySlider:SetWidth(260);
  getglobal(MySlider:GetName() .. "Low"):SetText('1');
  getglobal(MySlider:GetName() .. "High"):SetText('30');
  getglobal(MySlider:GetName() .. "Text"):SetText("3 seconds");
  MySlider.tooltipText = 'The interval of which your titles are displayed';
  MySlider:SetMinMaxValues(1, 30);
  MySlider:SetValue(3);
  MySlider:SetValueStep(1);
  MySlider:SetScript("OnValueChanged", function(self, value)
    getglobal(MySlider:GetName() .. "Text"):SetText(value .. " seconds");
    interval = getglobal("TitlerInterval"):GetValue();
    TitlerInt = interval;
  end);

  TitlerMain:SetBackdropColor(1,1,1,1);
  TitlerMain:Hide();

  getglobal("Titler_AutorunText"):SetText("Autorun");

  -- first time addon is run
  if(TitlerAuto == nil) then
    Titler_StartStop:SetText("Start");
    TitlerAuto = 0;
  elseif (TitlerAuto == 1) then
    enabled = 1;
    Titler_StartStop:SetText("Stop");
    Titler_Autorun:SetChecked(1);
  end
  if(TitlerInt == nil) then
    TitlerInt = 3;
  else
    interval = TitlerInt;
    TitlerInterval:SetValue(interval);
  end

  UpdateDB();
end

-- Debug print
function DPrint(msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function TitlerBar_Update()
  local line;
  local titleid = 0;
  FauxScrollFrame_Update(TitlerBar,mytitles,lines,16);
  for line=1,lines do
    lineplusoffset = line + FauxScrollFrame_GetOffset(TitlerBar);
    if lineplusoffset <= mytitles + 1 then
      titleid = titledb[lineplusoffset-1];
      if(titleid) then
        getglobal("Title"..line):SetChecked(savedb[lineplusoffset-1]);
        if(lineplusoffset-1 == 0) then
          getglobal("Title"..line.."Text"):SetText("None");
        else
          getglobal("Title"..line.."Text"):SetText(GetTitleName(titleid));
        end
        getglobal("Title"..line):Show();
      end
    else
      getglobal("Title"..line):Hide();
    end
  end
end

function SetAutorun()
  if(TitlerAuto == 1) then
    TitlerAuto = 0;
  else
    TitlerAuto = 1;
  end
end


-- Sets up the event registering
local f = CreateFrame("Frame", "TitlerFrame");
f:SetScript("OnUpdate", Titler_Track);

-- Sets up the slash command
SlashCmdList['TITLER_SLASHCMD'] = function(msg)
  if (msg == "") then
    UpdateDB();
    TitlerMain:Show();
  elseif (msg == "help") then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Titler|r Help");
    DEFAULT_CHAT_FRAME:AddMessage("|cff6666ffUsage:|r |cffAAAAFF/titler|r |cff00FF00[options]|r");
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00/enable|r - Enables the timer");
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00/disable|r - Disables the timer");
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00/interval num|r - Sets the timer interval where 'num' is seconds.");
  elseif (msg == "enable" or msg == "e") then
    enabled = 1;
    DEFAULT_CHAT_FRAME:AddMessage("Titler enabled")
  elseif (msg == "disable" or msg == "d") then
    enabled = 0;
    DEFAULT_CHAT_FRAME:AddMessage("Titler disabled")
  elseif (string.sub(msg,1,8) == "interval" or string.sub(msg,1,2) == "i " or msg == "i") then
    if (string.len(msg) == 8 or msg == "i") then
      DEFAULT_CHAT_FRAME:AddMessage("Interval is currently " .. interval .. " seconds");
    else
      if(string.sub(msg,1,2) == "i ") then
        interval = string.sub(msg,3);
        DEFAULT_CHAT_FRAME:AddMessage("Interval set to " .. interval .. " seconds");
      else
        interval = string.sub(msg,9);
        DEFAULT_CHAT_FRAME:AddMessage("Interval set to " .. interval .. " seconds");
      end
    end
  else
    DEFAULT_CHAT_FRAME:AddMessage("Unknown command: " .. msg);
    DEFAULT_CHAT_FRAME:AddMessage(string.sub(msg,1,8));
  end
end
SLASH_TITLER_SLASHCMD1 = '/titler'

-- Announces it's loaded
DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Titler loaded!|r Type /titler for more options");