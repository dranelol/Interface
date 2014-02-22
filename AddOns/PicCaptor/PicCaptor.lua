-- Local variables
local enabled = 0;
local npcnames = 0;
local ownname = 0;
local playernames = 0;
local fpetnames = 0;
local ftotemnames = 0;
local fguardiannames = 0;
local eplayernames = 0;
local epetnames = 0;
local eguardiannames = 0;
local etotemnames = 0;
local vanitynames = 0;
local guildnames = 0;
local screenshotting = 0;

-- Bindings variables
BINDING_HEADER_PicCaptor = "PicCaptor";
BINDING_NAME_PICCAPTOR1 = "PicCaptor Capture #1";
BINDING_NAME_PICCAPTOR2 = "PicCaptor Capture #2";
BINDING_NAME_PICCAPTOR3 = "PicCaptor Capture #3";

function PicCaptor_Capture1()
  screenshotting = 1;
  npcnames = GetCVar("UnitNameNPC");
  ownname = GetCVar("UnitNameOwn");
  playernames = GetCVar("UnitNameFriendlyPlayerName");
  fpetnames = GetCVar("UnitNameFriendlyPetName");
  ftotemnames = GetCVar("UnitNameFriendlyTotemName");
  fguardiannames = GetCVar("UnitNameFriendlyGuardianName");
  eplayernames = GetCVar("UnitNameEnemyPlayerName");
  epetnames = GetCVar("UnitNameEnemyPetName");
  etotemnames = GetCVar("UnitNameEnemyTotemName");
  eguardiannames = GetCVar("UnitNameEnemyGuardianName");
  guildnames = GetCVar("UnitNamePlayerGuild");
  vanitynames = GetCVar("UnitNameNonCombatCreatureName");
  DEFAULT_CHAT_FRAME:AddMessage("Capturing #1");
  SetCVar("UnitNameNPC", 0);
  SetCVar("UnitNameOwn", 0);
  SetCVar("UnitNameNonCombatCreatureName", 0);
  SetCVar("UnitNameFriendlyPlayerName", 0);
  SetCVar("UnitNameFriendlyPetName", 0);
  SetCVar("UnitNameFriendlyTotemName", 0);
  SetCVar("UnitNameFriendlyGuardianName", 0);
  SetCVar("UnitNameEnemyPlayerName", 0);
  SetCVar("UnitNameEnemyPetName", 0);
  SetCVar("UnitNameEnemyTotemName", 0);
  SetCVar("UnitNameEnemyGuardianName", 0);
  SetCVar("UnitNamePlayerGuild", 0);
  RunBinding("TOGGLEUI");
  Screenshot();
end

function PicCaptor_Capture2()
  screenshotting = 1;
  npcnames = GetCVar("UnitNameNPC");
  ownname = GetCVar("UnitNameOwn");
  playernames = GetCVar("UnitNameFriendlyPlayerName");
  fpetnames = GetCVar("UnitNameFriendlyPetName");
  ftotemnames = GetCVar("UnitNameFriendlyTotemName");
  fguardiannames = GetCVar("UnitNameFriendlyGuardianName");
  eplayernames = GetCVar("UnitNameEnemyPlayerName");
  epetnames = GetCVar("UnitNameEnemyPetName");
  etotemnames = GetCVar("UnitNameEnemyTotemName");
  eguardiannames = GetCVar("UnitNameEnemyGuardianName");
  guildnames = GetCVar("UnitNamePlayerGuild");
  vanitynames = GetCVar("UnitNameNonCombatCreatureName");
  DEFAULT_CHAT_FRAME:AddMessage("Capturing #2");
  SetCVar("UnitNameNPC", 1);
  SetCVar("UnitNameOwn", 1);
  SetCVar("UnitNameFriendlyPlayerName", 1);
  SetCVar("UnitNameFriendlyPetName", 1);
  SetCVar("UnitNameFriendlyTotemName", 1);
  SetCVar("UnitNameFriendlyGuardianName", 1);
  SetCVar("UnitNameEnemyPlayerName", 1);
  SetCVar("UnitNameEnemyPetName", 1);
  SetCVar("UnitNameEnemyTotemName", 1);
  SetCVar("UnitNameEnemyGuardianName", 1);
  SetCVar("UnitNamePlayerGuild", 1);
  SetCVar("UnitNameNonCombatCreatureName", 1);
  RunBinding("TOGGLEUI");
  Screenshot();
end

function PicCaptor_Capture3()
  DEFAULT_CHAT_FRAME:AddMessage("Capturing #3 -- currently disabled");
end

function PicCaptor_OnEvent(this, event, arg1, arg2)
  if (screenshotting == 1) then
    DEFAULT_CHAT_FRAME:AddMessage(event);
    RunBinding("TOGGLEUI");
    SetCVar("UnitNameNPC", npcnames);
    SetCVar("UnitNameOwn", ownname);
    SetCVar("UnitNameFriendlyPlayerName", playernames);
    SetCVar("UnitNameFriendlyPetName", fpetnames);
    SetCVar("UnitNameFriendlyTotemName", ftotemnames);
    SetCVar("UnitNameFriendlyGuardianName", fguardiannames);
    SetCVar("UnitNameEnemyPlayerName", eplayernames);
    SetCVar("UnitNameEnemyPetName", epetnames);
    SetCVar("UnitNameEnemyGuardianName", eguardiannames);
    SetCVar("UnitNameEnemyTotemName", etotemnames);
    SetCVar("UnitNamePlayerGuild", guildnames); 
    SetCVar("UnitNameNonCombatCreatureName", vanitynames);
    screenshotting = 0;
  end
end

-- Set up events
local f = CreateFrame("Frame", "PicCaptorFrame");
f:SetScript("OnEvent", PicCaptor_OnEvent);
f:RegisterEvent("SCREENSHOT_FAILED");
f:RegisterEvent("SCREENSHOT_SUCCEEDED");

-- Sets up the slash command
SlashCmdList['PicCaptor_SLASHCMD'] = function(msg)
  DEFAULT_CHAT_FRAME:AddMessage("/picc currently not working. Will work in future versions");
end
SLASH_PicCaptor_SLASHCMD1 = '/picc'

-- Announces it's loaded
DEFAULT_CHAT_FRAME:AddMessage("|cffff0000PicCaptor loaded!|r Type /picc for more options");

-- Hide UI messages
ActionStatus.Show = function() end;