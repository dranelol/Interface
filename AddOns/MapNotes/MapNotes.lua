--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.
--]]

local assert, type = assert, type;
local ipairs, rawget, print, setmetatable = ipairs, rawget, print, setmetatable;
local table, math, string = table, math, string;
local tconcat = table.concat;

local Minimap, WorldMapFrame, WorldMapButton = Minimap, WorldMapFrame, WorldMapButton;

local hooksecurefunc = hooksecurefunc;

local argcheck = MN.argcheck;

-- if LibDebug then LibDebug() end

_G.ValidMinimapShapes = {
  --                          { TOPLEFT, BOTTOMLEFT, TOPRIGHT, BOTTOMRIGHT}
  ['SQUARE']                = { false, false, false, false },

  ['CORNER-TOPLEFT']        = { true,  false, false, false },
  ['CORNER-BOTTOMLEFT']     = { false, true,  false, false },
  ['CORNER-TOPRIGHT']       = { false, false, true,  false },
  ['CORNER-BOTTOMRIGHT']    = { false, false, false, true  },

  ['SIDE-LEFT']             = { true,  true,  false, false },
  ['SIDE-RIGHT']            = { false, false, true,  true  },
  ['SIDE-TOP']              = { true,  false, true,  false },
  ['SIDE-BOTTOM']           = { false, true,  false, true  },

  ['TRICORNER-TOPLEFT']     = { true,  true,  true,  false },
  ['TRICORNER-BOTTOMLEFT']  = { true,  true,  false, true  },
  ['TRICORNER-TOPRIGHT']    = { true,  false, true,  true  },
  ['TRICORNER-BOTTOMRIGHT'] = { false, true,  true,  true  },

  ['CIRCULAR']              = { true,  true,  true,  true  },
}

-- This stuff is for the defunct myAddOns addon
MapNotes_Details = {
  name = MAPNOTES_NAME,
  description = MAPNOTES_ADDON_DESCRIPTION,
  version = MAPNOTES_VERSION,
  releaseDate = '4 November 2012',
  author = 'Cortello',
  email = 'cortello@gmx.com',
  website = MAPNOTES_DOWNLOAD_SITES,
  category = MYADDONS_CATEGORY_MAP or nil,
  frame = 'MapNotesOptionsFrame',
  optionsframe = 'MapNotesOptionsFrame',
};

MapNotes_MiniNote_Data = {};

MapNotes_SetNextAsMiniNote = 0;
MapNotes_AllowOneNote = false;
MapNotes_LastReceivedNote_xPos = 0;
MapNotes_LastReceivedNote_yPos = 0;
MapNotes_ZoneNames = {};
MapNotes.LastLineClick = { time = 0 };

MapNotes_TempNote = {
  Id = '';
  Creator = '';
  xPos = 0;
  yPos = 0;
  Icon = '';
  TextColor = '';
  Info1Color = '';
  Info2Color = '';
  miniNote = nil;
};

_G.MapNotes_PartyNoteData = {};
MapNotes_tloc_xPos = nil;
MapNotes_tloc_yPos = nil;
MapNotes_tloc_name = nil;
MapNotes_tloc_key = nil;

_G.MapNotes_Started = false;
MN_toggleClosed = nil;
MapNotes_HighlightedNote = '';

local highlightedNotes = {};
local id = 0;
local MapNotesFU_Drawing = nil;
local MapNotesWorldMapTimeSinceLastUpdate = 0;
local MapNotes_DoubleClick_Timer = 0;
local MapNotes_DoubleClick_Key = '';
local MapNotes_DoubleClick_Id = 0;
MapNotes_TargetInfo_Proceed = nil;

--[[
    Hooked Functions
--]]
local orig_MapNotes_WorldMapButton_OnClick; -- MapNotes hides WorldMapButton_OnClick on right-clicks
local orig_ChatFrame_MessageEventHandler;
local orig_Minimap_OnClick;

local MN_DefaultCoordsX = 4  ;
local MN_DefaultCoordsY = -4;

local MN_MOFFSET_X = 0.0022;
local MN_MOFFSET_Y = 0.0;
local MN_cUpdate = 0.0;
local MN_cUpdateLimit = 0.05;
local MN_miniRadius = 66;
local MN_minimapZoom = 0;

-- Library
local LibMapData = LibStub:GetLibrary('LibMapData-1.0');
assert(LibMapData, 'MapNotes depends on LibMapData');

local Astrolabe = DongleStub('Astrolabe-1.0');


function MapNotes.KeyStates()
  return IsControlKeyDown() and 'CTRL', IsShiftKeyDown() and 'SHIFT', IsAltKeyDown() and 'ALT';
end


local function Modifiers(key)
  local list = { MN.KeyStates() };
  if key then tinsert(list, key) end
  return table.concat(list, '-');
end

-- Take the gaps out of a table to make it contiguous

function MapNotes.CompactTable(t)
  assert(type(t) == 'table', 'Incorrect parameter type');

  local max = table.maxn(t);
  if max == 0 then return end

  local gap;
  local count = 0;

  for i = 1, max do
     if t[i] then
        if gap then
           t[gap] = t[i];
           t[i] = nil;
           gap = gap + 1;
        end
        count = count + 1;
     else
        gap = gap or i;
     end
  end

  assert(count == table.maxn(t), 'Problem with table size in MapNotes.CompactTable');
  
end


-- Remove any notes that have a name and a pair of valid coordinates

function MapNotes.SanitizeNotes(zoneData)

  if table.maxn(zoneData) == 0 then return end

  MapNotes.CompactTable(zoneData);

  local function ValidCoord(xy)
    return type(xy) == 'number' and xy >= 0.0 and xy <= 1.0;
  end

  for i, note in ipairs(zoneData) do

    if note.name and ValidCoord(note.xPos) and ValidCoord(note.yPos) then
      i = i + 1;
    else
      tremove(zoneData, i);
    end

  end

end


function MapNotes_Hooker()

  -- WorldMapButton_OnClick -- not secure, but couldn't find any Taint of Pet Bars when making notes in combat, etc.
  orig_MapNotes_WorldMapButton_OnClick = WorldMapButton_OnClick;
  WorldMapButton_OnClick = MapNotes_WorldMapButton_OnClick;

  -- ToggleWorldMap
  -- Secure Hook
  hooksecurefunc('ToggleFrame', MapNotes.ToggleFrame);
  --  hooksecurefunc('ToggleWorldMap', MapNotes.ToggleWorldMap);

  WorldMapFrame:HookScript('OnShow', MapNotes.ToggleWorldMap);
  WorldMapFrame:HookScript('OnHide', MapNotes.ToggleWorldMap);
--[[
  GameTooltip:HookScript('OnAttributeChanged', function(...)
    print('GameTooltip_OnAttributeChanged', strjoin(', ', tostringall(...)));
  end);

  GameTooltip:HookScript('OnEnable', function(...)
    print('GameTooltip_OnEnable', strjoin(', ', tostringall(...)));
  end);

  GameTooltip:HookScript('OnEvent', function(...)
    print('GameTooltip_OnEvent', strjoin(', ', tostringall(...)));
  end);

  GameTooltip:HookScript('OnTooltipSetFrameStack', function(...)
    print('OnTooltipSetFrameStack', strjoin(', ', tostringall(...)));
  end);

  local timer = 0;
  local count = 0;
  local start;
  local previousText;
  local previousX, previousY;
  GameTooltip:HookScript('OnUpdate', function(self, elapsed)

    local point = { GameTooltip:GetPoint(1) };
    local parent = GameTooltip:GetParent();

    print('parent = '..parent:GetName());
    print('owner = '..GameTooltip:GetOwner():GetName());
    if type(point[2]) == 'table' and point[2].GetName then
      point[2] = point[2]:GetName();
    end
    print(unpack(point));

    local text = GameTooltipTextLeft1:GetText();

    if text == nil or text == previousText then return end
    previousText = text;

    for line in text:gmatch('[^\n]+') do
      if line == 'Mailbox' then
        local own = GameTooltip:GetOwner();
        print(own:GetName());
        for i = 1, GameTooltip:GetNumPoints() do
          print(GameTooltip:GetPoint(i));
        end
      end
    end

  end);
--]]

 -- ChatFrame_MessageEventHandler
  orig_ChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler;
  ChatFrame_MessageEventHandler = MapNotes_ChatFrame_MessageEventHandler;

  -- Create notes from Minimap clicks
--  orig_Minimap_OnClick = Minimap_OnClick;
  orig_Minimap_OnClick = Minimap:GetScript('OnMouseUp');
--  Minimap_OnClick = MapNotes_Minimap_OnClick;
  Minimap:SetScript('OnMouseUp', MapNotes_Minimap_OnClick);

end


local function AddSlashCommand(action, handler)

  assert(not SlashCmdList[action], format('Slash command %s already registered', action));

  local listName = format('MAPNOTES_%s_COMMANDS', action);
  local cmdList = _G[listName];
  assert(cmdList, format('Command list %s not found', listName));

  SlashCmdList[action] = handler;
  for i, command in ipairs(cmdList) do
    _G['SLASH_'..action..i] = command;
  end

end


function MapNotes_OnLoad()
--print('MapNotes_OnLoad()');

  -- WorldMapMagnifyingGlassButton:SetText(MAPNOTES_WORLDMAP_HELP_1..'\n'..MAPNOTES_WORLDMAP_HELP_2..'\n'..MAPNOTES_WORLDMAP_HELP_3);

  AddSlashCommand('MAPNOTES', MapNotes_Slash_MapNotes);

  AddSlashCommand('MNOPTIONS', MapNotes_Slash_MNOptions);

  AddSlashCommand('ONENOTE', MapNotes_Slash_OneNote);

  AddSlashCommand('NEXTMININOTE', MapNotes_Slash_NextMiniNote);

  AddSlashCommand('NEXTMININOTEONLY', MapNotes_Slash_NextMiniNoteOnly);

  AddSlashCommand('MININOTEOFF', MapNotes_Slash_MiniNoteOff);

  AddSlashCommand('MNTLOC', function(msg, editbox) MapNotes_Slash_MNTloc(msg) end);

  AddSlashCommand('QUICKNOTE', function(msg, editbox) MapNotes_Slash_QuickNote(msg) end);

  AddSlashCommand('QUICKTLOC', function(msg, editbox) MapNotes_Slash_QuickTLoc(msg) end);

  AddSlashCommand('MNSEARCH', MapNotes_Slash_MNSearch);

  AddSlashCommand('MNHIGHLIGHT', MapNotes_Slash_MNHighlight);

  AddSlashCommand('MNMINICOORDS', MapNotes_Slash_MNMiniCoords);

  AddSlashCommand('MNMAPCOORDS', MapNotes_Slash_MNMapCoords);

  AddSlashCommand('MNTARGET', MapNotes_Slash_MNTarget);

  AddSlashCommand('MNMERGE', MapNotes_Slash_MNMerge);

  AddSlashCommand('THOTTBOTLOC', MapNotes_Slash_ThottbotLoc);

  AddSlashCommand('IMPORT_METAMAP', MapNotes_Slash_ImportMetaMap);

  AddSlashCommand('IMPORT_ALPHAMAP', MapNotes_Slash_ImportAlphaMap);

  AddSlashCommand('IMPORT_ALPHAMAPBG', MapNotes_Slash_ImportAlphaMapBG);

  AddSlashCommand('IMPORT_CTMAP', MapNotes_Slash_ImportCTMap);

end


function default(key, val)
  if MapNotes_Options[key] == nil then
    MapNotes_Options[key] = val;
  end
end


function MapNotes_AddonLoaded(self)

  local name = self;
  if self and self.GetName then
    name = self:GetName();
  end
  -- print(format('MapNotes_AddonLoaded(%s)', tostring(name)));

  MapNotes_MiniNote_Data = {};
  _G.MapNotes_Options = _G.MapNotes_Options or {};

  for icon = 0, 9 do
    default(icon, true);
  end

  -- MapNotesOptionsCheckbox10     - Show notes created by your character
  default(10, true);
  -- MapNotesOptionsCheckbox11     - Show notes received from other characters
  default(11, true);
  -- MapNotesOptionsCheckbox12     - Highlight last created note in red
  default(12, false);
  -- MapNotesOptionsCheckbox13     - Highlight note selected for MiniNote
  default(13, true);
  -- MapNotesOptionsCheckbox14     - Accept incoming notes from other players
  default(14, true);

  -- MapNotesOptionsCheckbox16     - Automatically set party notes as MiniNote
  default(16, true);

  -- MapNotesOptionsCheckboxMapC   - World Map Coordinates enabled
  default('mapC', true);
  -- MapNotesOptionsCheckboxMiniC  - Minimap Coordinates enabled
  default('miniC', true);
  -- MapNotesOptionsCheckboxLM     - Auto-MapNote landmarks
  default('landMarks', false);
  

  -- MN_FrameSlider
  default('nFactor', MN_DEFAULT_FRAMESCALE);
  -- MN_IconSlider
  default('iFactor', MN_DEFAULT_ICONSIZE);
  -- MN_AlphaSlider
  default('aFactor', MN_DEFAULT_ICONALPHA);
  -- MN_CoordSlider
  default('coordF', 1);
  MN_COORD_F = MapNotes_Options.coordF;
  MN_CoordsSizingText:SetText(format(MN_COORD_FS[MN_COORD_F], 100, 100));


  -- The following options aren't acccessible through the Options dialogue

  -- colourT[1], [2] and [3] are lists of ten RGB colours for a note's title,
  -- nfo1 and info2 respectively. The ten colours are indexed 0..9

  default('colourT', {});
  for i = 1, 3 do
    MapNotes_Options.colourT[i] = MapNotes_Options.colourT[i] or {};
  end

  default('shownotes', true);

  -- Set default position for WorldMap coordinates
  default('coordsLocX', MN_DefaultCoordsX);
  default('coordsLocY', MN_DefaultCoordsY);
  MN_SetCoordsPos();

  if MapNotes_MiniNote_Data.icon ~= nil then

    MN_MiniNotePOITexture:SetTexture(nil);

    if MapNotes_MiniNote_Data.icon == 'party' and MNIL and MN_PARTY_ICON then
      MN_MiniNotePOITexture:SetTexture(MN_PARTY_ICON);
    elseif MapNotes_MiniNote_Data.icon == 'tloc' and MNIL and MN_TLOC_ICON then
      MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
    end

    local txtr = MN_MiniNotePOITexture:GetTexture();
    if not txtr then
      MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
    end

  end

  if myAddOnsFrame_Register then
    myAddOnsFrame_Register(MapNotes_Details);
  end

  MapNotes_Hooker();
  MapNotes_LoadMapData();

  MapNotes_LoadPlugIns();

  if MapNotes_Options.miniC then
    MN_MinimapCoordsFrame:Show();
  end



--  No more quick options so no more need to do this
--  WorldMapZoneMinimapDropDown:ClearAllPoints();
--  WorldMapZoneMinimapDropDown:SetPoint('TOPLEFT', WorldMapPositioningGuide, 'TOP', -394, -35);

  MN_DataCheck(nil);

  -- Sanitize all the notes on loading instead of at multiple points in the code
  -- Note that this also compacts the zone tables
  for key, zoneNotes in pairs(MapNotes_Data_Notes) do
    MapNotes.SanitizeNotes(zoneNotes);
  end

  for key, currentLines in pairs(MapNotes_Data_Lines) do
    MN.CompactTable(currentLines);
  end

  local version, build, reldate, tocversion = GetBuildInfo();

  -- Change the release date 'Mmm dd yyyy' to 'dd-Mmm-yyyy'. The day is space-
  -- padded to two characters, so there may be two spaces between the month and
  -- the day
  do
    local release = {};
    gsub(reldate, '%S+', function(string) tinsert(release, string) end);
    reldate = strjoin('-', release[2], release[1], release[3]);
  end

  DEFAULT_CHAT_FRAME:AddMessage(format(
  [[-- World of Warcraft Client --
  |cFF22DD22Version:|r %s
  |cFF22DD22Build:|r %s
  |cFF22DD22Release:|r %s
  |cFF22DD22TOC Version:|r %s]], version, build, reldate, tocversion));

  local msg = format('|cFFA335EE%s |c0000FF00%s|r', MAPNOTES_DISPLAY, MAPNOTES_VERSION);
  DEFAULT_CHAT_FRAME:AddMessage(msg);

end


function MapNotes_ScaleFrames()
  for i, frame in ipairs(MapNotes.scaleFrames) do
    MapNotes_NormaliseScale(frame);
  end
end


function MapNotes_CheckNearbyNotes(key, xPos, yPos)

  assert(type(key) == 'string', 'Invalid key parameter'..tostring(key));
  assert(xPos and xPos >= 0 and xPos <= 1, 'Invalid xPos parameter '..tostring(xPos));
  assert(yPos and yPos >= 0 and yPos <= 1, 'Invalid yPos parameter '..tostring(yPos));

  local currentNotes = MapNotes.CurrentNotes;

  for i, note in ipairs(currentNotes) do

    local dX = (note.xPos - xPos) * MapNotes.ZoneWidthYards;
    local dY = (note.yPos - yPos) * MapNotes.ZoneHeightYards;
    local distance = sqrt(dX*dX + dY*dY);

    if distance < MapNotes_MinDiff then
      return i;
    end
  end

  return false;

end


function MapNotes.StatusPrint(msg)
  msg = '<'..MAPNOTES_NAME..'>: '..msg;
  if DEFAULT_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage(msg, 1.0, 0.5, 0.25);
  end
end


function MapNotes_Slash_MNOptions(msg, name)
  MapNotesOptionsFrame:Show();
end


function MapNotes_Slash_MNTloc(msg, name)

  if not (msg and msg:match('%S')) then
    MapNotes_tloc_xPos = nil;
    MapNotes_tloc_yPos = nil;
    MapNotes_tloc_name = nil;
    MapNotes_tloc_key = nil;
    if MapNotes_MiniNote_Data.icon == 'tloc' then
      MapNotes_ClearMiniNote(true, 'tloc');
    end
  else
    -- SetMapToCurrentZone();
    local x, y = MapNotes_ExtractCoords(msg);
    if x and y then

      if not name then
        name = MAPNOTES_THOTTBOTLOC;
      end

      MapNotes_tloc_xPos = x / 100;
      MapNotes_tloc_yPos = y / 100;
      MapNotes_tloc_name = name;
      MapNotes_tloc_key = MapNotes.MapKey;
      MapNotes_MiniNote_Data.id = 0;
      MapNotes_MiniNote_Data.key = MapNotes_tloc_key;
      MapNotes_MiniNote_Data.xPos = MapNotes_tloc_xPos;
      MapNotes_MiniNote_Data.yPos = MapNotes_tloc_yPos;
      MapNotes_MiniNote_Data.name = MapNotes_tloc_name;
      MapNotes_MiniNote_Data.color = 0;
      MapNotes_MiniNote_Data.icon = 'tloc';

      MN_MiniNotePOITexture:SetTexture(nil);

      if MNIL and MN_TLOC_ICON then
        MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
      end

      local txtr = MN_MiniNotePOITexture:GetTexture();





      if not txtr then
        MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
      end

    end
  end

  MapNotes_MapUpdate();

end

local function trimall(...)
  local strings = { ... };
  for i, v in ipairs(strings) do
    if type(v) == 'string' then
      v = gsub(v, '^%s+', '');
      v = gsub(v, '%s+$', '');
      strings[i] = v;
    end
  end
  return unpack(strings);
end


function MapNotes_GetNoteFromChat(note, who)

  do return end

  if who == UnitName('player') then return end

  -- printf('MapNotes_GetNoteFromChat(%q, %q)', tostringall(note, who));

  _G.msg = note;

  local fields = {};

  gsub(note, '%a%w*%b<>', function(field)
    local k, v = field:match('(.+)<(.*)>');
    k, v = trimall(k, v);
    fields[k] = v;
  end);

  MN.printtable(fields);

  if fields.p == '1' then -- Party Note

    local key = fields.k;
    local xPos = fields.x;
    local yPos = fields.y;
    local lKey = fields.l;

    MapNotes_PartyNoteData.key = key;
    MapNotes_PartyNoteData.xPos = xPos;
    MapNotes_PartyNoteData.yPos = yPos;

    if lKey then
      MapNotes.StatusPrint( format( MAPNOTES_PARTY_GET, who, lKey ) );
    else
      MapNotes.StatusPrint( format( MAPNOTES_PARTY_GET, who, MapNotes_GetMapDisplayName(key) ) );
    end

    local worldMapTest = string.sub(key, 1, 3);

    if strmatch(key, '^WM ') and
      (MapNotes_MiniNote_Data.icon == 'party' or MapNotes_Options[16]) then

      MapNotes_MiniNote_Data.id = -1;
      MapNotes_MiniNote_Data.key = key;
      MapNotes_MiniNote_Data.xPos = xPos;
      MapNotes_MiniNote_Data.yPos = yPos;
      MapNotes_MiniNote_Data.name = MAPNOTES_PARTYNOTE;
      MapNotes_MiniNote_Data.color = 0;
      MapNotes_MiniNote_Data.icon = 'party';
      MN_MiniNotePOITexture:SetTexture(nil);

      if MNIL and MN_PARTY_ICON then
        MN_MiniNotePOITexture:SetTexture(MN_PARTY_ICON);
      end

      local txtr = MN_MiniNotePOITexture:GetTexture();
      if not txtr then
        MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
      end

    end

  else

    local key = fields.k;
    local xPos = tonumber(fields.x);
    local yPos = tonumber(fields.y);
    local title = fields.t;
    local info1 = fields.i1;
    local info2 = fields.i2;
    local creator = fields.cr;
    local icon = tonumber(fields.i);
    local tcolor = tonumber(fields.tf);
    local i1color = tonumber(fields.i1f);
    local i2color = tonumber(fields.i2f);
    local miniN = fields.mn;

    local same_location =
        MapNotes_LastReceivedNote_xPos == xPos and
        MapNotes_LastReceivedNote_yPos == yPos;
      -- do nothing, because the previous note is exactly the same as the current note

    if not same_location then

      local currentNotes = MapNotes.CurrentNotes;

      local checknote = MapNotes_CheckNearbyNotes(key, xPos, yPos);
      MapNotes_LastReceivedNote_xPos = xPos;
      MapNotes_LastReceivedNote_yPos = yPos;

      if checknote then
        MapNotes.StatusPrint(format(MAPNOTES_DECLINE_NOTETOONEAR, who, MapNotes_GetMapDisplayName(key), currentNotes[checknote].name ) );
        return;
      end

      local id = #currentNotes + 1;

      if MapNotes_SetNextAsMiniNote ~= 2 then
        -- Accept incoming notes from other players?
        if MapNotes_AllowOneNote or MapNotes_Options[14] then
          MapNotes_TempNote.Id = id;
          currentNotes[id] = {
            name = title;
            ncol = tcolor;
            inf1 = info1;
            in1c = i1color;
            inf2 = info2;
            in2c = i2color;
            creator = creator;
            icon = icon;
            xPos = xPos;
            yPos = yPos;
          };

          if MapNotes_SetNextAsMiniNote ~= 0 or miniN and miniN == '1' then
            currentNotes[id].mininote = true;
          end

          MapNotes.StatusPrint(format(MAPNOTES_ACCEPT_GET, who, MapNotes_GetMapDisplayName(key) ) );

        else
          MapNotes.StatusPrint(format(MAPNOTES_DECLINE_GET, who, MapNotes_GetMapDisplayName(key) ) );
        end
      end

      if MapNotes_SetNextAsMiniNote == 2 then -- next mininote ONLY

        MapNotes_MiniNote_Data.xPos = xPos;
        MapNotes_MiniNote_Data.yPos = xPos;
        MapNotes_MiniNote_Data.key = key;
        MapNotes_MiniNote_Data.id = id;
        MapNotes_MiniNote_Data.name = title;
        MapNotes_MiniNote_Data.color = tcolor;
        MapNotes_MiniNote_Data.icon = 'tloc';
        MN_MiniNotePOITexture:SetTexture(nil);

        if MNIL and MN_TLOC_ICON then
          MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
        end

        local txtr = MN_MiniNotePOITexture:GetTexture();

        if not txtr then
          MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
        end

        MapNotes.StatusPrint(MAPNOTES_SETMININOTE);
      end


      MapNotes_AllowOneNote = false;

    end
  end

  MapNotes_MapUpdate();

end


function MapNotes_Slash_MapNotes(msg)
--printf('<%s>', msg);

  local returnValue = false;
  local cmd, prms;

  if not (msg and msg:match('%S')) then
    MapNotes_Help();
    return false;
  end

  if msg:match('^[-?]') then

    local sep = strfind(msg, ' ');

    if sep then
      prms = string.sub(msg, sep + 1);
      cmd = strsub(msg, 1, sep - 1);
    else
      cmd = strsub(msg, 1);
      prms = '';
    end

    if cmd and prms then
      cmd = strlower(cmd);
      MapNotes_MainCommandHandler(cmd, prms);
    else
      MapNotes_Help();
      returnValue = false;
    end

  elseif msg:find('k<') and msg:find('x<') then -- If the message has a key and an xPos...

    msg = '<M_N> '..msg;

    local key = gsub(msg,'.*<M_N+> k<([^>]*)>.*','%1', 1);
    local xPos = gsub(msg,'.*<M_N+>%s+%w+.*x<([^>]*)>.*','%1', 1) + 0;
    local yPos = gsub(msg,'.*<M_N+>%s+%w+.*y<([^>]*)>.*','%1', 1) + 0;
    local title = gsub(msg,'.*<M_N+>%s+%w+.*t<([^>]*)>.*','%1', 1);
    local info1 = gsub(msg,'.*<M_N+>%s+%w+.*i1<([^>]*)>.*','%1', 1);
    local info2 = gsub(msg,'.*<M_N+>%s+%w+.*i2<([^>]*)>.*','%1', 1);
    local creator = gsub(msg,'.*<M_N+>%s+%w+.*cr<([^>]*)>.*','%1', 1);
    local icon = gsub(msg,'.*<M_N+>%s+%w+.*i<([^>]*)>.*','%1', 1)+0;
    local tcolor = gsub(msg,'.*<M_N+>%s+%w+.*tf<([^>]*)>.*','%1', 1)+0;
    local i1color = gsub(msg,'.*<M_N+>%s+%w+.*i1f<([^>]*)>.*','%1', 1)+0;
    local i2color = gsub(msg,'.*<M_N+>%s+%w+.*i2f<([^>]*)>.*','%1', 1)+0;
    local miniN = gsub(msg,'.*<M_N+>%s+%w+.*mn<([^>]*)>.*','%1', 1);

    local checknote = MapNotes_CheckNearbyNotes(key, xPos, yPos);

    if MapNotes_SetNextAsMiniNote == 2 then -- Only next note is mininote

      MapNotes_MiniNote_Data.xPos = xPos;
      MapNotes_MiniNote_Data.yPos = yPos;
      MapNotes_MiniNote_Data.key = key;
      MapNotes_MiniNote_Data.id = 0;
      MapNotes_MiniNote_Data.name = title;
      MapNotes_MiniNote_Data.color = tcolor;
      MapNotes_MiniNote_Data.icon = 'tloc';
      MN_MiniNotePOITexture:SetTexture(nil);

      if MNIL and MN_TLOC_ICON then
        MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
      end

      local txtr = MN_MiniNotePOITexture:GetTexture();

      if not txtr then
        MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
      end

      MapNotes.StatusPrint(MAPNOTES_SETMININOTE);

    else -- Mininote is either on or off - 1 or 0

      local currentNotes = MapNotes.CurrentNotes;

      local checknote = MapNotes_CheckNearbyNotes(key, xPos, yPos);

      if checknote then
        MapNotes.StatusPrint(format(MAPNOTES_DECLINE_SLASH_NEAR, currentNotes[checknote].name, MapNotes_GetMapDisplayName(key) ) );
      else

        local newnote = {
          name = title,
          ncol = tcolor,
          inf1 = info1,
          in1c = i1color,
          inf2 = info2,
          in2c = i2color,
          creator = creator,
          icon = icon,
          xPos = xPos,
          yPos = yPos,
          mininote = false,
        };

        if MapNotes_SetNextAsMiniNote ~= 0 or (miniN and miniN == '1') then
          newnote.mininote = true;
        end

        local id = #currentNotes + 1;
        MapNotes_TempNote.Id = id;
        currentNotes[id] = newnote;

        MapNotes.StatusPrint(format(MAPNOTES_ACCEPT_SLASH, MapNotes_GetMapDisplayName(key) ) );
        returnValue = true;
      end
    end
  else
    MapNotes_Help();
    returnValue = false;
  end

  if returnValue then
    MapNotes_MapUpdate();
  end

  return returnValue;
end


function MapNotes_MainCommandHandler(cmd, prms)

  if cmd == '-allow' or cmd == '-a' then
    MapNotes_Slash_OneNote(prms);

  elseif cmd == '-opt' then
    MapNotes_Slash_MNOptions();

  elseif cmd == '-allmini' then
    MapNotes_TotallyMini();

  elseif cmd == '-automini' then
    MapNotes_Slash_NextMiniNote(prms);

  elseif cmd == '-nextmini' then
    MapNotes_Slash_NextMiniNote(prms);

  elseif cmd == '-minionly' then
    MapNotes_Slash_NextMiniNoteOnly(prms);

  elseif cmd == '-minioff' then
    MapNotes_Slash_MiniNoteOff();

  elseif cmd == '-tloc' then
    MapNotes_Slash_MNTloc(prms);

  elseif cmd == '-q' then
    MapNotes_Slash_QuickNote(prms);

  elseif cmd == '-qtloc' then
    MapNotes_Slash_QuickTLoc(prms);

  elseif cmd == '-mapc' then
    MapNotes_Slash_MNMapCoords();

  elseif cmd == '-minic' then
    MapNotes_Slash_MNMiniCoords();

  elseif cmd == '-s' then
    MapNotes_Slash_MNSearch(prms);

  elseif cmd == '-hl' then
    MapNotes_Slash_MNHighlight(prms);

  elseif cmd == '-t' then
    MapNotes_Slash_MNTarget(prms);

  elseif cmd == '-m' then
    MapNotes_Slash_MNMerge(prms);

  elseif cmd == '-datacheck' then
    MN_DataCheck(true);

  elseif cmd == '-scale' then

    local nFactor = tonumber(prms);

    if nFactor and nFactor >= 50 and nFactor <= 150 then
      MapNotes_Options.nFactor = nFactor;
    else
      local msg = '|c0000FF00/mn -scale [50 - 150] |r';
      MapNotes.StatusPrint(msg);
    end

    MN_FrameSlider:SetValue(MapNotes_Options.nFactor);

  elseif cmd == '-undelete' then
    MapNotes_Undelete();

  elseif cmd == '-clearicons' then
    MapNotes_ClearIcons();

  elseif cmd == '-mstyle' then
    MN_CustomMinimapCycler(tonumber(prms));

  else
    MapNotes_Help();
  end
end


function MapNotes_Help()

  local msg = MAPNOTES_DISPLAY.. ' |c0000FF00'..MAPNOTES_VERSION..'|r';

  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn k<WM txt> x<#> y<#> t<txt> i1<txt> i2<#> cr<txt> i<#> tf<#> i1f<#> i2f<#> mn<boolean> |r: ' .. MAPNOTES_CHAT_COMMAND_ENABLE_INFO;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -allow  |r: ' .. MAPNOTES_CHAT_COMMAND_ONENOTE_INFO;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -nextmini  |r: ' .. MAPNOTES_CHAT_COMMAND_MININOTE_INFO;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -minionly  |r: ' .. MAPNOTES_CHAT_COMMAND_MININOTEONLY_INFO;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -minioff  |r: ' .. MAPNOTES_CHAT_COMMAND_MININOTEOFF_INFO;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -tloc xx,yy  |r: ' .. MAPNOTES_CHAT_COMMAND_MNTLOC_INFO;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -q [icon] [title]  |r: ' .. MAPNOTES_CHAT_COMMAND_QUICKNOTE;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -qtloc xx,yy [icon] [title]  |r: ' .. MAPNOTES_CHAT_COMMAND_QUICKTLOC;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -mapc  |r: ' .. MAPNOTES_MAP_COORDS;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -minic  |r: ' .. MAPNOTES_MINIMAP_COORDS;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -s  |r: ' .. MAPNOTES_CHAT_COMMAND_SEARCH;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -hl  |r: ' .. MAPNOTES_CHAT_COMMAND_HIGHLIGHT;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -t  |r: ' .. BINDING_NAME_MN_TARGET_NEW;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -m  |r: ' .. BINDING_NAME_MN_TARGET_MERGE;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -scale [0.5 - 1.5] |r: ' .. MAPNOTES_CHAT_COMMAND_SCALE;
  MapNotes.StatusPrint(msg);
  msg = '|c0000FF00/mn -undelete |r: ' .. MAPNOTES_CHAT_COMMAND_UNDELETE;
  MapNotes.StatusPrint(msg);
end


function MapNotes_Slash_QuickTLoc(msg, MN_creatorOverride, MN_mininoteOverride)

  if not strfind(msg, '%S') then
    MapNotes.StatusPrint(MAPNOTES_QUICKTLOC_NOARGUMENT);
    return;
  end

  local x, y, msg = MapNotes_ExtractCoords(msg);

  local coords_ok =
      type(x) == 'number' and x >= 0 and x <= 100 and
      type(y) == 'number' and y >= 0 and y <= 100;

  if not x and y then return end

  x = x / 100;
  y = y / 100;

  local key = MapNotes.MapKey;
  local currentNotes = MapNotes.CurrentNotes;
  local checknote = MapNotes_CheckNearbyNotes(key, x, y);

  if checknote then
    MapNotes.StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETOONEAR,
             currentNotes[checknote].name ));
    return
  end

  local icon = 0;
  local name = MAPNOTES_THOTTBOTLOC;

  if msg and msg:find('%S') then

    local icheck = msg:match('^(%d)%s');
    if icheck then
      icon = tonumber(icheck);
      msg = strsub(msg, 3);
    end

    if msg and msg:find('%S') then
      local msgStart = msg:find('%S');
      local msgBack = 80;
      if msgStart then
        msgBack = msgStart + 80;
      else
        msgStart = 1;
      end
      msg = strsub(msg, msgStart, msgBack);
      if msg and msg:find('%S') then
        name = msg;
      end
    end

  end

  if MapNotes_SetNextAsMiniNote ~= 2 then

    local newnote = {
      name = name,
      ncol = 0,
      inf1 = '',
      in1c = 0,
      inf2 = '',
      in2c = 0,
      creator = UnitName('player'),
      icon = icon,
      xPos = x,
      yPos = y,
      mininote = false,
    };

    if MN_creatorOverride then
      newnote.creator = MN_creatorOverride;
      MN_creatorOverride = nil;
    end

    if MapNotes_SetNextAsMiniNote ~= 0 or MN_mininoteOverride then
      newnote.mininote = true;
    end

    local id = #currentNotes + 1;
    MapNotes_TempNote.Id = id;
    currentNotes[id] = newnote;

    MapNotes.StatusPrint(format(MAPNOTES_QUICKNOTE_OK, MapNotes_GetMapDisplayName(key) ) );

  elseif MapNotes_SetNextAsMiniNote == 2 then

    MapNotes_MiniNote_Data.xPos = x;
    MapNotes_MiniNote_Data.yPos = y;
    MapNotes_MiniNote_Data.key = key;
    MapNotes_MiniNote_Data.id = 0;
    MapNotes_MiniNote_Data.name = name;
    MapNotes_MiniNote_Data.color = 0;
    MapNotes_MiniNote_Data.icon = 'tloc';
    MN_MiniNotePOITexture:SetTexture(nil);

    if MNIL and MN_TLOC_ICON then
      MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
    end

    local txtr = MN_MiniNotePOITexture:GetTexture();
    if not txtr then
      MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
    end

    MapNotes.StatusPrint(MAPNOTES_SETMININOTE);
  end

  MapNotes_MapUpdate();

end


function MapNotes_ShortCutNote(x, y, Plugin, mininote, key)

  if not x or not y then return end

  if not key then
    if Plugin then
      key = MapNotes_PlugInsGetKey(Plugin);
    else
      key = MapNotes.MapKey;
    end
  end

  local currentNotes = MapNotes.CurrentNotes;

  local checkDist = MapNotes_CheckNearbyNotes(key, x, y);
  if checkDist then
    local msg = format(MAPNOTES_DECLINE_SLASH_NEAR,
        currentNotes[checkDist].name, MapNotes_GetMapDisplayName(key) ) 
    MapNotes.StatusPrint(msg);
    currentNotes[checkDist].mininote = true;
    return;
  end

  if MapNotes_SetNextAsMiniNote == 2 then

    MapNotes_MiniNote_Data.xPos = x;
    MapNotes_MiniNote_Data.yPos = y;
    MapNotes_MiniNote_Data.key = key;
    MapNotes_MiniNote_Data.id = 0;
    MapNotes_MiniNote_Data.name = MAPNOTES_QUICKNOTE_DEFAULTNAME;
    MapNotes_MiniNote_Data.color = 0;
    MapNotes_MiniNote_Data.icon = 'tloc';

    MN_MiniNotePOITexture:SetTexture(nil);

    if MNIL and MN_TLOC_ICON then
      MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
    end

    local txtr = MN_MiniNotePOITexture:GetTexture();
    if not txtr then
      MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
    end

    MapNotes.StatusPrint(MAPNOTES_SETMININOTE);

  else

    local newnote = {
      name = MAPNOTES_QUICKNOTE_DEFAULTNAME, ncol = 0,
      inf1 = '',                             in1c = 0,
      inf2 = '',                             in2c = 0,
      creator = UnitName('player'),
      icon = 0,
      xPos = x, yPos = y,
      mininote = false,
    }

    if MapNotes_SetNextAsMiniNote ~= 0 or mininote and
        (not Plugin or Plugin.wmflag) then

      newnote.mininote = true;
      MapNotes.StatusPrint(MAPNOTES_SETMININOTE);
    end

    local id = #currentNotes + 1;
    MapNotes_TempNote.Id = id;
    currentNotes[id] = newnote;

    if Plugin then
      MapNotes.StatusPrint( format( MAPNOTES_QUICKNOTE_OK, MapNotes_GetMapDisplayName(key, Plugin) ) );
    else
      MapNotes.StatusPrint( format( MAPNOTES_QUICKNOTE_OK, MapNotes_GetMapDisplayName(key) ) );
    end

    return MapNotes_TempNote.Id;
  end


end


function MapNotes_Slash_QuickNote(msg, msg2, msg3, shouldMerge, mininote)

  local x, y = GetPlayerMapPosition('player');

  if x == 0 and y == 0 then
    SetMapToCurrentZone();
    x, y = GetPlayerMapPosition('player');
  end

  local key = MapNotes.MapKey;
  local currentNotes = MapNotes.CurrentNotes;
  
  local toonear = MapNotes_CheckNearbyNotes(key, x, y);
  if toonear then
    if shouldMerge then
      MapNotes_Merge(key, toonear, msg, msg2, msg3);
    else
      MapNotes.StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETOONEAR, MapNotes_Data_Notes[key][toonear].name ) );
    end
    return;
  end

  local icon = 0;
  local l_zone, m_zone = GetMinimapZoneText(), GetRealZoneText();

  if l_zone == m_zone then
    m_zone = nil;
  end

  local name = '';

  if msg and msg ~= '' then

    local icheck = strsub(msg, 1, 2);

    if strfind(icheck, '%d%s') then
      icon = tonumber( string.sub(msg, 1, 1) );
      msg = strsub(msg, 3);
    end

    if msg and msg ~= '' then

      local msgStart = strfind(msg, '%S');
      local msgBack = 80;

      if msgStart then
        msgBack = msgStart + 80;
      else
        msgStart = 1;
      end

      msg = strsub(msg, msgStart, msgBack);

      if msg and msg ~= '' then
        name = msg;
      end

    end

  end

  if name == '' then
    name = l_zone;
  end

  if not msg2 or msg2 == '' then
    msg2 = '';
    if name ~= l_zone then
      msg2 = l_zone;
    elseif m_zone then
      msg2 = m_zone;
    else
      msg2 = MAPNOTES_QUICKNOTE_DEFAULTNAME;
    end
  end

  if ( not msg3 ) or ( msg3 == '' ) then
    msg3 = '';
    if ( name ~= l_zone ) and ( msg2 ~= l_zone ) then
      msg3 = l_zone;
    elseif ( m_zone ) and ( msg2 ~= m_zone ) then
      msg3 = m_zone;
    elseif msg2 ~= MAPNOTES_QUICKNOTE_DEFAULTNAME then
      msg3 = MAPNOTES_QUICKNOTE_DEFAULTNAME;
    end
  end

  if MapNotes_SetNextAsMiniNote == 2 then

    MapNotes_MiniNote_Data.xPos  = x;
    MapNotes_MiniNote_Data.yPos  = y;
    MapNotes_MiniNote_Data.key   = key;
    MapNotes_MiniNote_Data.id    = 0;
    MapNotes_MiniNote_Data.name  = name;
    MapNotes_MiniNote_Data.color = 0;
    MapNotes_MiniNote_Data.icon  = 'tloc';
    MN_MiniNotePOITexture:SetTexture(nil);

    if MNIL and MN_TLOC_ICON then
      MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
    end

    local txtr = MN_MiniNotePOITexture:GetTexture();

    if not txtr then
      MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
    end

    MapNotes.StatusPrint(MAPNOTES_SETMININOTE);

  else

    local newnote = {
      name = name,
      ncol = 0,
      inf1 = msg2,
      in1c = 0,
      inf2 = msg3,
      in2c = 0,
      creator = UnitName('player'),
      icon = icon,
      xPos = x,
      yPos = y,
      mininote = false,
    };

    if mininote or MapNotes_SetNextAsMiniNote ~= 0 then
      newnote.mininote = true;
      MapNotes.StatusPrint(MAPNOTES_SETMININOTE);
    end

    local id = #currentNotes + 1;
    MapNotes_TempNote.Id = id;
    currentNotes[id] = newnote;

    MapNotes.StatusPrint(format(MAPNOTES_QUICKNOTE_OK, GetRealZoneText()));

  end

end


function MapNotes_Slider_OnMouseWheel(self, delta)
	local value = self:GetValue() + delta * self:GetValueStep();
	local lolim, hilim = self:GetMinMaxValues();
	self:SetValue(min(max(value, lolim), hilim));
end


-- This is the handler for OnClick events for anything based on the
-- WorldMapMapNotesMiscTemplate Button template. That is the MapNotesPOItloc and
-- MapNotesPOIparty World Map note buttons, plus the corresponding plugin PartyNote
-- and tlocNote buttons

function MapNotes_Misc_OnClick(self, button, down)

-- printf('MapNotes_Misc_OnClick(%s)',
--     strjoin(', ', tostringall(self:GetName(), button, down)));

  if not MapNotes_FramesHidden() then return end

  local lclFrame = self:GetParent();
  local Plugin = self.Plugin;
  local key;

  MapNotes.ClearGUI();

  if Plugin then
    key = MapNotes_PlugInsGetKey(Plugin);
    lclFrame = lclFrame or Plugin.frame;
  else
    key = MapNotes.MapKey;
    lclFrame = lclFrame or WorldMapButton;
  end

  local ax, ay = MapNotes_GetMouseXY(lclFrame);

  local note = 'party';
  local theID = -1;
  if self:GetID() == 0 then
    note = 'tloc';
    theID = 0;
  end

  -- printf('lclFrame, note, theID = %s, %d', lclFrame:GetName(), note, theID);

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  if button ~= 'RightButton' then return end

  if SHIFT and not ALT then -- shift or ctrl-shift

    if note == 'party' then

      MapNotes_DeleteNote(-1);
      if self.Plugin then
        MapNotes_PlugInsDrawNotes(self.Plugin);
      end

    else        -- also allow Shift-Right deletion of tloc
      MapNotes_DeleteNote(0);
      if self.Plugin then
        MapNotes_PlugInsDrawNotes(self.Plugin);
      end
    end

    return;

  elseif ALT and not SHIFT then -- alt or ctrl-alt

    if note == 'party' then

      if strmatch(MapNotes_PartyNoteData.key, '^WM ') then
        MapNotes_SetAsMiniNote(-1); -- Should 'Toggle' Party Mininote
        MapNotes_MapUpdate();
        return;
      end

    else
      MapNotes_SetAsMiniNote(0);  -- Should 'Toggle' tloc Mininote
      MapNotes_MapUpdate();
      return;
    end
  end

  local xOffset, yOffset = MapNotes_GetAdjustedMapXY(lclFrame, ax, ay);

  -- Needs to be Misc Note info...
  MapNotes:InitialiseDropdown(lclFrame, ax, ay, MapNotes.temp_dd_info, key, theID);
  ToggleDropDownMenu(1, nil, MapNotes.DropDown, 'cursor', 0, 0);

  WorldMapTooltip:Hide();
  MapNotes_WorldMapTooltip:Hide();
  GameTooltip:Hide();

  if note == 'party' and MapNotes_MiniNote_Data.icon == 'party' then
    MapNotes_TempNote.Id = -1;
  elseif note == 'party' then
    MapNotes_TempNote.Id = -1;
  elseif MapNotes_MiniNote_Data.icon == 'tloc' then
    MapNotes_TempNote.Id = 0;
  else
    MapNotes_TempNote.Id = 0;
  end

end


function MapNotes_Slash_NextMiniNote(msg)
  msg = string.lower(msg);
  if msg == 'on' then
    MapNotes_SetNextAsMiniNote = 1;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_1);
  elseif msg == 'off' then
    MapNotes_SetNextAsMiniNote = 0;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_0);
  elseif MapNotes_SetNextAsMiniNote == 1 then
    MapNotes_SetNextAsMiniNote = 0;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_0);
  else
    MapNotes_SetNextAsMiniNote = 1;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_1);
  end
end


function MapNotes_Slash_NextMiniNoteOnly(msg)
  msg = string.lower(msg);
  if msg == 'on' then
    MapNotes_SetNextAsMiniNote = 2;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_2);
  elseif msg == 'off' then
    MapNotes_SetNextAsMiniNote = 0;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_0);
  elseif MapNotes_SetNextAsMiniNote == 2 then
    MapNotes_SetNextAsMiniNote = 0;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_0);
  else
    MapNotes_SetNextAsMiniNote = 2;
    MapNotes.StatusPrint(MAPNOTES_MININOTE_SHOW_2);
  end
end


function MapNotes_Slash_OneNote(msg)
  msg = string.lower(msg);
  if msg == 'on' then
    MapNotes_AllowOneNote = true;
    MapNotes.StatusPrint(MAPNOTES_ONENOTE_ON);
  elseif msg == 'off' then
    MapNotes_AllowOneNote = false;
    MapNotes.StatusPrint(MAPNOTES_ONENOTE_OFF);
  elseif MapNotes_AllowOneNote then
    MapNotes_AllowOneNote = false;
    MapNotes.StatusPrint(MAPNOTES_ONENOTE_OFF);
  else
    MapNotes_AllowOneNote = true;
    MapNotes.StatusPrint(MAPNOTES_ONENOTE_ON);
  end
end


-- Sets MapNotes.MapName, MapNotes.Continent and MapNotes.MapKey
-- Needs MapNotes.MapLevel
function MapNotes.GetMapKey()

  local info = { GetMapInfo() };
  local texture, w, h, isCave, caveName = GetMapInfo()

  setfenv(1, MapNotes);

  MapName, MicroDungeon, DungeonName = info[1], info[4], info[5];

  if MapName then
    MapName = MapName:gsub('_terrain%d$', ''); -- Account for phased areas
  elseif (Continent == WORLDMAP_COSMIC_ID) then
      MapName = 'Cosmic';
  else
    MapName = 'WorldMap';
  end

  if (MapLevel > 0) then
    MapKey = format('WM %s%d', MapName, MapLevel);
  else
    MapKey = format('WM %s', MapName);
  end

  CurrentNotes = MapNotes_Data_Notes[MapKey];
  CurrentLines = MapNotes_Data_Lines[MapKey];

  return MapKey;

end


function MapNotes.UpdateMapInfo(...)
-- printf('MapNotes.UpdateMapInfo(%s)', strjoin(', ', tostringall(...)));

  if not MapNotes_Started then return end

  if WorldMapFrame:IsVisible() then
  end

  -- do
  --   local x, y = GetPlayerMapPosition('player');
  --   if x == 0 and y == 0 then return end
  -- end

  -- The parameters are either (event, map, floor, w, h) if this is a result of
  -- the LibMapData 'MapChanged' callback, or (self, button, down) if it is
  -- the hooked 'OnClick' handler for MinimapZoomIn or MiniMapZoomOut

  -- local event, map, floor, w, h;
  -- local self, button, down;

  -- local p1 = ...;
  -- if (type(p1) == 'table') then
  --   self, button, down = ...;
  --   print(format('MapNotes.UpdateMapInfo(self=%s, button=%s, down=%s)',
  --         self:GetName(), button, down));
  -- elseif (type(p1) == 'string') then
  --   event, map, floor, w, h = ...;
  --   print(format('MapNotes.UpdateMapInfo(event=%s, map=%s, floor=%d, width=%.3f, height=%.3f)',
  --       tostringall(event, map, floor, w, h)));
  -- else
  --   print(format('MapNotes.UpdateMapInfo(%s)', strjoin(', ', tostringall(...))));
  -- end

  setfenv(1, MapNotes);

  Continent  = GetCurrentMapContinent();
  Zone = GetCurrentMapZone();
  MapID = GetCurrentMapAreaID();
  MapLevel = GetCurrentMapDungeonLevel(); -- Not being set on map change between two indoors locations

  GetMapKey();

  if MapID <= 0 then
    ZoneWidthYards, ZoneHeightYards = 0, 0;
  else
    local width, height = LibMapData:MapArea(MapName, MapLevel);
    if width == 0 and height == 0 then
      -- printf('MapID = %s', tostring(MapID));
      local info = { Astrolabe:GetMapInfo(MapID, MapLevel) };
      width, height = info[3], info[4];
    end
    ZoneWidthYards, ZoneHeightYards = width, height;
  end

  UpdateMinimapZoom(); -- Set MapNotes.MinimapZoom and MapNotes.Indoors

  if MapNotes_Options.landMarks then
    MapNotes_IterateLandMarks(false);
  end

  return MapKey;

end

-- Sets MapNotes.MinimapZoom
--      MapNotes.Indoors
--      MapNotes.MinimapYards
--      MapNotes.MinimapPixelsPerYard

function MapNotes.UpdateMinimapZoom()

  setfenv(1, MapNotes);

  MinimapZoom = Minimap:GetZoom();
  local outZoom = tonumber(GetCVar('minimapZoom'));
  local inZoom = tonumber(GetCVar('minimapInsideZoom'));

  if (MinimapZoom ~= outZoom) then
    Indoors = true;
  elseif (MinimapZoom ~= inZoom) then
    Indoors = false;
  else

    local testZoom;
    if (MinimapZoom == 0) then
      testZoom = 1;
    else
      testZoom = MinimapZoom - 1;
    end

    Minimap:SetZoom(testZoom);

    inZoom = tonumber(GetCVar('minimapInsideZoom'));
    Indoors = (inZoom == testZoom);

    Minimap:SetZoom(MinimapZoom);

  end

  if (Indoors) then
    MinimapYards = MinimapSize.indoor[MinimapZoom];
  else
    MinimapYards = MinimapSize.outdoor[MinimapZoom];
  end

  MinimapPixelsPerYard = Minimap:GetWidth() / MinimapYards;

  XCoordsFactor = ZoneWidthYards * MinimapPixelsPerYard;
  YCoordsFactor = ZoneHeightYards * MinimapPixelsPerYard;

end


function MapNotes_MinimapPing(self, event, unit, x, y)

  MapNotes_Ping = MapNotes_Ping or {};
  MapNotes_Ping.x, MapNotes_Ping.y = x, y;
  MapNotes_Ping.playerX, MapNotes_Ping.playerY = GetPlayerMapPosition('player');

end


-- Handle CHAT_MSG_WHISPER and CHAT_MSG_WHISPER_INFORM

function MapNotes_ChatFrame_MessageEventHandler(...)

  do
    local params = { ... };
    params[1] = params[1]:GetName();
    for i, v in ipairs(params) do
      if type(v) == 'string' then
        params[i] = format('%q', params[i]);
      else
        params[i] = tostring(params[i]);
      end
    end
    -- printf('MapNotes_ChatFrame_MessageEventHandler(%s)', tconcat(params, ', '));
  end

  local self, event, author = ...;

  if event:match('^CHAT_MSG_WHISPER') and author:match('^<M_N>') then

    local message, sender = ...;

    if event:match('_INFORM$') then
      MapNotes_GetNoteFromChat(message, sender);
    end

  else
    orig_ChatFrame_MessageEventHandler(...);
  end

end


function MapNotes_WorldMap_OnUpdate(self, elapsed)

  -- printf('MapNotes_WorldMap_OnUpdate(%s, %f)', tostring(self:GetName()), elapsed);

  local mapID = GetCurrentMapAreaID();
  if mapID ~= MapNotes.MapID then
    MapNotes.UpdateMapInfo();
  end

  MapNotesWorldMapTimeSinceLastUpdate = MapNotesWorldMapTimeSinceLastUpdate + elapsed;

  local eScale = self:GetEffectiveScale();
  if self.eScale ~= eScale then
    self.eScale = eScale;
    MapNotes_WorldMapButton_OnUpdate();
  end

  self.oTimer = (self.oTimer or 0) + elapsed;

  if self.oTimer > 0.02 and self.oTimer < 0.12 then
    MapNotes_WorldMapButton_OnUpdate();
  end

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  if CTRL or SHIFT then
    if WorldMapFrameAreaLabel:IsVisible() then
      WorldMapFrameAreaLabel:Hide();
    end
  else
    if not WorldMapFrameAreaLabel:IsVisible() then
      WorldMapFrameAreaLabel:Show();
    end
  end

  if MapNotesWorldMapTimeSinceLastUpdate > MapNotes_WorldMap_UpdateRate then

    MapNotesWorldMapTimeSinceLastUpdate = 0;

    if CTRL then

      if not MapNotes_WorldMapButton:IsVisible() then
        MapNotes_WorldMapButton:Show();
      end

    elseif SHIFT then
      if MapNotes_WorldMapButton:IsVisible() then
        MapNotes_WorldMapButton:Hide();
      end

    else
      if MapNotes_WorldMapButton:IsVisible() then
        MapNotes_WorldMapButton:Hide();
      end
    end

  end

end


function MN_CustomMinimapCycler(style)
--printf('MN_CustomMinimapCycler(%s)', tostring(style));

  if ( style ) and ( type(style) == 'number' ) then
    if style == 0 then
      MapNotes_Options.customMinimap = nil;
    else
      MapNotes_Options.customMinimap = style;
    end

  elseif not MapNotes_Options.customMinimap then
    MapNotes_Options.customMinimap = 1;

  else
    MapNotes_Options.customMinimap = MapNotes_Options.customMinimap + 1;
    if not MN_MINIMAP_STYLES[ MapNotes_Options.customMinimap ] then
      MapNotes_Options.customMinimap = nil;
    end
  end

  if MapNotes_Options.customMinimap then
    MapNotes.StatusPrint( MapNotes_Options.customMinimap .. ' : ' .. MN_AUTO_DESCRIPTIONS[ MN_MINIMAP_STYLES[MapNotes_Options.customMinimap] ] );

  else
    MapNotes.StatusPrint( '0 : ' .. MN_STYLE_AUTOMATIC );
  end
end


function MN_GetMinimapShape()
  if MapNotes_Options.customMinimap then
    return MN_AUTO_MINIMAPS[ MN_MINIMAP_STYLES[MapNotes_Options.customMinimap] ];

  elseif GetMinimapShape then
    return MN_AUTO_MINIMAPS[ GetMinimapShape() ];
  end

  return nil;
end


local visibilityUpdate = 0;
local MN_zoneData, MN_key;
local MN_playerX, MN_playerY, MN_dist = 0, 0, 0;
local MN_noteX, MN_noteY = 0, 0;

function MapNotes_OnUpdate(self, elapsed)

  if not MapNotes.MapKey then return end

  visibilityUpdate = visibilityUpdate + elapsed;

  if MapNotes_TargetInfo_Proceed and GameTooltip:IsVisible() then
    MapNotes_TargetInfo_Proceed.func();
    return;
  end

  -- Update Rate = 0.1 as of 9-JAN-2011
  -- Update Rate = 0.02 as of 24-Sep-2012 for Mists of Pandaria
  if visibilityUpdate < MapNotes_WorldMap_UpdateRate then return end

  if not Minimap:IsVisible() then return end

  visibilityUpdate = 0;

  if MapNotes.SetMap then
    SetMapToCurrentZone();
    MapNotes.SetMap = false;
  end

  MN_playerX, MN_playerY = GetPlayerMapPosition('player');

  -- NOTE: GetPlayerMapPosition returns zeros if the wrong world map is on display
  -- If we have no player position then we can't calculate the notes' positions

  if MN_playerX == 0 and MN_playerY == 0 then
    MN_MiniNotePOI:Hide();
    MapNotes_HideMiniNotes(1);
    return;
  end

  -- check for Minimap shape change via SimpleMinimap in this OnUpdate function
  local minimapShape = MN_GetMinimapShape();

  MN_zoneData = false;  -- reset & use as control for individual OnUpdates

  local mapName  = MapNotes.MapName;
  local mapID = MapNotes.MapID;
  local mapLevel = MapNotes.MapLevel;
  local mapKey = MapNotes.MapKey;
  local zoom = MapNotes.MinimapZoom;
  
  -- Draw the party note if it's in this zone

  if MapNotes_MiniNote_Data.key == mapKey
      and MapNotes_MiniNote_Data.xPos and MapNotes_MiniNote_Data.yPos then
    
    MN_noteX = (MapNotes_MiniNote_Data.xPos - MN_playerX) * MapNotes.XCoordsFactor;
    MN_noteY = (MapNotes_MiniNote_Data.yPos - MN_playerY) * MapNotes.YCoordsFactor;

    MN_MiniNotePOI.key = mapKey;
    MN_MiniNotePOI.nid = MapNotes_MiniNote_Data.id;
    MN_MiniNotePOI.xPos = MN_noteX;
    MN_MiniNotePOI.yPos = MN_noteY;
    MN_MiniNotePOI.ref = MapNotes_MiniNote_Data.id;
    MN_MiniNotePOI.dist = sqrt( MN_noteX*MN_noteX + MN_noteY*MN_noteY );

    -- MN_MiniNotePOI is shown only through this routine now and there is no
    -- explicit Show() anywhere else, so the expected values for POI should be
    -- managed from here so that it can be treated in exactly the same way
    -- as a normal MapNote Mininote detailed below
    if not MN_MiniNotePOI:IsShown() then
      MN_MiniNotePOI.timeSinceLastUpdate = 99; -- Force immediate OnUpdate
      MN_MiniNotePOI:Show();
    end

  else
    MN_MiniNotePOI:Hide();
  end

  --[[

    Now plot the normal MapNote Mininotes

    We keep a set of POI buttons available for all World Map frames and recycle
    them between maps. They are called MapNotes_MiniNote1 etc.

    Look through all of the notes for the current zone, and assign a POI button
    for each one that is flagged (mininote == true) to be shown on the minimap

  --]]
  local currentNotes = MapNotes.CurrentNotes;

  local n = 0; -- Counter of live POI buttons

  for id, note in ipairs(currentNotes) do

    if note.mininote then

      n = n + 1;

      local POIName = 'MN_MiniNotePOI'..n;
      local POI = _G[POIName] or CreateFrame('Button', POIName, Minimap, 'MN_MiniNotePOITemplate');

      MN_noteX = (note.xPos - MN_playerX) * MapNotes.XCoordsFactor
      MN_noteY = (note.yPos - MN_playerY) * MapNotes.YCoordsFactor

      POI.ref = id;
      POI.key = mapKey;
      POI.nid = id;
      POI.xPos = MN_noteX;
      POI.yPos = MN_noteY;
      POI.dist = sqrt(MN_noteX * MN_noteX + MN_noteY * MN_noteY);

      POI.timeSinceLastUpdate = 0;

      -- Add icon texture - standard 0..9 or custom
      local POITexture = _G[POIName..'Texture'];
      POITexture:SetTexture(nil);

      if MNIL and note.customIcon then
        POITexture:SetTexture(note.customIcon);
      else
        POITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..note.icon);
      end

      POI:Show();

    end
  end

  MapNotes_HideMiniNotes(n + 1);    -- hide remaining Mininotes

end


function MapNotes.RotatingMinimap()
  return GetCVar('rotateMinimap') == '1';
end


--[[
  Basically the design here is to keep as many of the 'traditional' required
  variables in the main OnUpdate because they don't need to be calculated SO
  frequently -- If possible, the only variable that needs Frequent updating is
  the Rotation Angle -- but I move the test of the 'if Rotation turned on'
  test in to the Main OnUpdate also, and only do a boolean test here. In other
  words I'm assuming you don't move SO quickly that changes in distance
  'stutter', but changes in orientation need to be reflected very quickly
]]

local pi = math.pi;
local sin = math.sin;
local cos = math.cos;
local atan2 = math.atan2;

function POI_OnUpdate(POI, elapsed)

  elapsed = elapsed or 1;

  POI.timeSinceLastUpdate = POI.timeSinceLastUpdate + elapsed;

  if POI.timeSinceLastUpdate < MapNotes_Mininote_UpdateRate then return end
  if MN_playerX == 0 and MN_playerY == 0 then return end
  POI.timeSinceLastUpdate = 0;


  -- xPos and yPos increase east and south. Invert the yPos so that we can calculate
  -- angles relative to north
  MN_noteX, MN_noteY = POI.xPos, - POI.yPos;
  MN_dist = POI.dist;

  -- Recalculate the angle and convert from Polar coordinates back to cartesian coordinates if necessary
  -- i.e. if Minimap Rotation needs to be accounted for
  if MapNotes.RotatingMinimap() then

    -- GetPlayerFacing returns a value from zero (north) to 2*pi, increasing
    -- in an anticlockwise direction. Convert it to ± π, zero still north,
    -- increasing clockwise

    local playerFacing = 2 * pi - GetPlayerFacing();
    if playerFacing > pi then playerFacing = playerFacing - 2 * pi end

    local theta = atan2(MN_noteX, MN_noteY) - playerFacing;

    MN_noteX = sin(theta) * MN_dist;
    MN_noteY = cos(theta) * MN_dist;

    -- if POI == MN_MiniNotePOI1 then
    --   print('');
    --   printf('POI.xPos, POI.yPos = %f, %f', POI.xPos, POI.yPos);
    --   printf('MN_noteX, MN_noteY = %f, %f', MN_noteX, MN_noteY);
    --   printf('MN_dist = %f', MN_dist);
    --   printf('Note bearing = %f', atan2(MN_noteX, MN_noteY));
    --   printf('Player facing = %f', playerFacing);
    --   printf('theta = %f', theta);
    -- end

  end

  -- Squared map ?
  if false and minimapShape then

    local squared = 1;

    if MN_noteX < 0 then squared = squared + 2 end
    if MN_noteY > 0 then squared = squared + 1 end
    squared = minimapShape[squared];

    if squared then

      local p, q = abs(MN_noteX), abs(MN_noteY);
      if q > p then p = q; end

      if p > MN_miniRadius then
        MN_dist = p;
      else
        MN_dist = 0;
      end

    end
  end

  local scaling = 1;
  if MN_dist > MN_miniRadius then
    scaling = MN_miniRadius / MN_dist;
  end

  POI:SetPoint('CENTER', MN_noteX * scaling, MN_noteY * scaling);
  POI:SetSize(16, 16);
  POI:Show();

end


function MapNotes_HideMiniNotes(from)
--printf('MapNotes_HideMiniNotes(%s)', tostring(from));
  while (true) do
    local POI = _G['MN_MiniNotePOI'..from];
    if not POI then break end
    POI:Hide();
    POI.key = nil;
    from = from + 1;
  end
end


function MapNotes_Edit_SetIcon(iconNum)
  MapNotes_TempNote.Icon = iconNum;
  MN_IconOverlay:SetPoint('TOPLEFT', 'MN_EditIcon'..iconNum, 'TOPLEFT', -3, 3);
end


function MapNotes_Edit_SetTextColor(colourNum, mBttn)

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  if not mBttn or mBttn == 'LeftButton' then
    MapNotes_TempNote.TextColor = colourNum;
    local rgb = MapNotes_Options.colourT[1][colourNum] or MapNotes_Colours[colourNum];
    MapNotes_TitleWideEditBox:SetTextColor(rgb.r, rgb.g, rgb.b);
    MN_TextColorOverlay:SetPoint('TOPLEFT', 'MN_TextColor'..colourNum, 'TOPLEFT', -3, 3);
  else
    if ALT then
      MapNotes_Options.colourT[1][colourNum] = nil;
      MN_InitialiseTextColours();
    else
      ColorPickerFrame.strata = ColorPickerFrame:GetFrameStrata();
      ColorPickerFrame:SetParent(MapNotesEditFrame);
      if MapNotesEditFrame:GetParent() == WorldMapButton then
        ColorPickerFrame.forceHide = true;
      end
      MN_SetUpColourPicker(1, colourNum);
      ColorPickerFrame:SetFrameStrata('TOOLTIP');
      ColorPickerFrame:SetFrameLevel(MapNotesEditFrame:GetFrameLevel() + 3);
      ColorPickerOkayButton:SetFrameLevel(ColorPickerFrame:GetFrameLevel() + 1);
      ColorPickerCancelButton:SetFrameLevel(ColorPickerFrame:GetFrameLevel() + 1);
    end
  end
end


function MapNotes_Edit_SetInfo1Color(colourNum, mBttn)

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  if not mBttn or mBttn == 'LeftButton' then
    MapNotes_TempNote.Info1Color = colourNum;
    local rgb = MapNotes_Options.colourT[2][colourNum] or MapNotes_Colours[colourNum];
    MN_Info1WideEditBox:SetTextColor(rgb.r, rgb.g, rgb.b);
    MN_Info1ColorOverlay:SetPoint('TOPLEFT', 'MN_Info1Color'..colourNum, 'TOPLEFT', -3, 3);
  else
    if ALT then
      MapNotes_Options.colourT[2][colourNum] = nil;
      MN_InitialiseTextColours();
    else
      ColorPickerFrame.strata = ColorPickerFrame:GetFrameStrata();
      ColorPickerFrame:SetParent(MapNotesEditFrame);
      if MapNotesEditFrame:GetParent() == WorldMapButton then
        ColorPickerFrame.forceHide = true;
      end
      MN_SetUpColourPicker(2, colourNum);
      ColorPickerFrame:SetFrameStrata('TOOLTIP');
      ColorPickerFrame:SetFrameLevel(MapNotesEditFrame:GetFrameLevel() + 3);
      ColorPickerOkayButton:SetFrameLevel( ColorPickerFrame:GetFrameLevel() + 1 );
      ColorPickerCancelButton:SetFrameLevel( ColorPickerFrame:GetFrameLevel() + 1 );
    end
  end
end


function MapNotes_Edit_SetInfo2Color(colourNum, mBttn)

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  if ( not mBttn ) or ( mBttn == 'LeftButton' ) then
    MapNotes_TempNote.Info2Color = colourNum;
    local rgb = MapNotes_Options.colourT[3][colourNum] or MapNotes_Colours[colourNum];
    MN_Info2WideEditBox:SetTextColor(rgb.r, rgb.g, rgb.b);
    MN_Info2ColorOverlay:SetPoint('TOPLEFT', 'MN_Info2Color'..colourNum, 'TOPLEFT', -3, 3);
  else
    if ALT then
      MapNotes_Options.colourT[3][colourNum] = nil;
      MN_InitialiseTextColours();
    else
      ColorPickerFrame.strata = ColorPickerFrame:GetFrameStrata();
      ColorPickerFrame:SetParent(MapNotesEditFrame);
      if MapNotesEditFrame:GetParent() == WorldMapButton then
        ColorPickerFrame.forceHide = true;
      end
      MN_SetUpColourPicker(3, colourNum);
      ColorPickerFrame:SetFrameStrata('TOOLTIP');
      ColorPickerFrame:SetFrameLevel(MapNotesEditFrame:GetFrameLevel() + 3);
      ColorPickerOkayButton:SetFrameLevel( ColorPickerFrame:GetFrameLevel() + 1 );
      ColorPickerCancelButton:SetFrameLevel( ColorPickerFrame:GetFrameLevel() + 1 );
    end
  end
end


function MapNotes_OpenEditForExistingNote(key, nid)

  MapNotes_HideAll();

  local currentNotes = MapNotes.CurrentNotes;
  local note = currentNotes[nid];
  local lclFrame = UIParent;
  local Plugin = MapNotes.pluginKeys[key];

  if Plugin and not Plugin.wmflag then
    lclFrame = _G[Plugin.frame];
  elseif WorldMapButton:IsVisible() then
    lclFrame = WorldMapButton;
  end

  MapNotes_TempNote.Id = nid;
  MapNotes_TempNote.Creator = note.creator;
  MapNotes_TempNote.xPos = note.xPos;
  MapNotes_TempNote.yPos = note.yPos;
  MapNotes_TempNote.miniNote = note.mininote;

  if not note.icon then
    note.icon = 0;
  end

  MapNotes_Edit_SetIcon(note.icon);

  MapNotes_TitleWideEditBox:SetText(note.name);
  MapNotes_Edit_SetTextColor(note.ncol);

  MN_Info1WideEditBox:SetText(note.inf1);
  MapNotes_Edit_SetInfo1Color(note.in1c);

  MapNotes_Edit_SetInfo2Color(note.in2c);
  MN_Info2WideEditBox:SetText(note.inf2);

  MN_CreatorWideEditBox:SetText(note.creator);

  MapNotesEditFrame:SetParent(lclFrame);
  MapNotesEditFrame.miniMe = note.mininote;
  MapNotesEditFrame.k = key;
  MapNotesEditFrame:Show();
end


function MapNotes_ShowSendFrame(number)
  local Plugin = MapNotes.pluginKeys[ MapNotesSendFrame.key ];
  local lclFrame = WorldMapButton;

  if Plugin then
    lclFrame = _G[Plugin.frame];
  end

  if number == 1 then
    MapNotesSendPlayer:Enable();

    MapNotesChangeSendFrame:SetText(MAPNOTES_SLASHCOMMAND);
    MapNotes_SendWideEditBox:SetText('');
    if UnitCanCooperate('player', 'target') then
      MapNotes_SendWideEditBox:SetText(UnitName('target'));
    end
    MapNotes_SendFrame_Title:SetText(MAPNOTES_SEND_TITLE);
    MapNotes_SendFrame_Tip:SetText(MAPNOTES_SEND_TIP);
    MapNotes_SendFrame_Player:SetText(MAPNOTES_SEND_PLAYER);
    MapNotes_ToggleSendValue = 2;

  elseif number == 2 then
    MapNotesSendPlayer:Disable();
    MapNotesChangeSendFrame:SetText(MAPNOTES_SHOWSEND);
    MapNotes_SendWideEditBox:SetText('/mapnote '..MapNotes_GenerateSendString(2));
    MapNotes_SendFrame_Title:SetText(MAPNOTES_SEND_SLASHTITLE);
    MapNotes_SendFrame_Tip:SetText(MAPNOTES_SEND_SLASHTIP);
    MapNotes_SendFrame_Player:SetText(MAPNOTES_SEND_SLASHCOMMAND);
    MapNotes_ToggleSendValue = 1;
  end

  if not MapNotesSendFrame:IsVisible() then
    MapNotes_HideAll();
    MapNotesSendFrame:SetParent(lclFrame);
    MapNotesSendFrame:Show();
  end
end


function MapNotes_GenerateSendString(version)

-- e.g. "<M_N> k<1> x<0.123123> y<0.123123> t<> i1<> i2<> cr<> i<8> tf<3> i1f<5> i2f<6>"

  local upperLimit = 164;   -- SendAddonMessage with combined Prefix..Text of over 254 = Disconnect

  local text;
  if version == 1 then
    text = '<M_N> ';
  else
    text = '';
  end

  local key = MapNotesSendFrame.key;
  local currentNotes = MapNotes.CurrentNotes;
  local id = MapNotes_TempNote.Id;
  local note = currentNotes[MapNotes_TempNote.Id];

  local keyLen = string.len(key);
  upperLimit = upperLimit - keyLen;
  local t1 = MapNotes_EliminateUsedChars(note.name);
  local t2 = MapNotes_EliminateUsedChars(note.inf1);
  local t3 = MapNotes_EliminateUsedChars(note.inf2);
  if not note.creator then
    note.creator = UnitName('player');
  end
  local cr = MapNotes_EliminateUsedChars(note.creator);
  local truncated;
  t1, t2, t3, cr, truncated = MapNotes_CheckLength(t1, t2, t3, cr, upperLimit);

  text = text..format(
      'k<%s> x<%.6f> y<%.6f> t<%s> i1<%s> i2<%s> cr<%s> i<%d> tf<%d> i1f<%d> i2f<%d>',
      key,
      tonumber(note.xPos), tonumber(note.yPos),
      t1, t2, t3, cr,
      tonumber(note.icon),
      tonumber(note.ncol), tonumber(note.in1c), tonumber(note.in1c));

  if ( version == 1 ) and ( truncated ) then
    MapNotes.StatusPrint(MAPNOTES_TRUNCATION_WARNING);
  end

  text = string.gsub(text, '|', '\124\124');

  return text;

end


function MapNotes_CheckLength(t1, t2, t3, cr, upperLimit)
  local l1 = string.len(t1);
  local l2 = string.len(t2);
  local l3 = string.len(t3);
  local l4 = string.len(cr);
  local truncated;

  if l1 > upperLimit then
    t1 = string.sub(t1, 1, upperLimit);
    t2 = '';
    t3 = '';
    cr = '';
    truncated = true;

  elseif (l1+l2) > upperLimit then
    t2 = string.sub(t2, 1, (upperLimit-l1));
    t3 = '';
    cr = '';
    truncated = true;

  elseif (l1+l2+l3) > upperLimit then
    t3 = string.sub(t3, 1, (upperLimit-l1-l2));
    cr = '';
    truncated = true;

  elseif (l1+l2+l3+l4) > upperLimit then
    cr = string.sub(cr, 1, (upperLimit-l1-l2-l3));
    truncated = true;
  end

  return t1, t2, t3, cr, truncated;
end


function MapNotes_EliminateUsedChars(text)
  text = string.gsub(text, '<', '');
  text = string.gsub(text, '>', '');
  return text;
end


function MapNotes_SendNote(type)

  if type == 2 then
    local msg = MapNotes_GenerateSendString(1);
    SendAddonMessage( 'MapNotes', msg, 'PARTY' );

  elseif type == 3 then
    local msg = MapNotes_GenerateSendString(1);
    SendAddonMessage( 'MapNotes', msg, 'RAID' );

  elseif type == 4 then
    local msg = MapNotes_GenerateSendString(1);
    SendAddonMessage( 'MapNotes', msg, 'BATTLEGROUND' );

  elseif type == 5 then
    local msg = MapNotes_GenerateSendString(1);
    SendAddonMessage('MapNotes', msg, 'GUILD');
  end

end


function MapNotes_OpenOptionsFrame()

  local n = 0;
  while true do
    local checkbox = _G['MapNotesOptionsCheckbox'..n];
    if not checkbox then break end
    if MapNotes_Options[n] then
      checkbox:SetChecked(1);
    else
      checkbox:SetChecked(0);
    end
    n = n + 1;
  end

  if MapNotes_Options.mapC then
    MapNotesOptionsCheckboxMapC:SetChecked(1);
  else
    MapNotesOptionsCheckboxMapC:SetChecked(0);
  end

  if MapNotes_Options.miniC then
    MapNotesOptionsCheckboxMiniC:SetChecked(1);
  else
    MapNotesOptionsCheckboxMiniC:SetChecked(0);
  end

  if MapNotes_Options.landMarks then
    MapNotesOptionsCheckboxLM:SetChecked(1);
  else
    MapNotesOptionsCheckboxLM:SetChecked(0);
  end

  MN_FrameSlider:SetValue(MapNotes_Options.nFactor);

  MN_IconSlider:SetValue(MapNotes_Options.iFactor);

  MN_AlphaSlider:SetValue(MapNotes_Options.aFactor);

end


function MapNotes_WriteOptions()

  for i = 0, 16 do
    local checkbox = _G['MapNotesOptionsCheckbox'..i];
    if checkbox:GetChecked() then
      MapNotes_Options[i] = true;
    else
      MapNotes_Options[i] = false;
    end
  end

  MapNotes_PlugInsRefresh();
  MapNotes_MapUpdate();
end


function MapNotes_SetAsMiniNote(nid)
--printf('MapNotes_SetAsMiniNote(%s)', tostring(nid))

  local key = MapNotes.MapKey;
  local currentNotes;
  local note;

  if nid and nid > 0 then
    currentNotes = MapNotes.CurrentNotes;
    note = currentNotes[nid];
  end

  if nid == 0 and MapNotes_MiniNote_Data.icon == 'tloc' then
    MapNotes_ClearMiniNote(true, 'tloc');

  elseif nid == -1 and MapNotes_MiniNote_Data.icon == 'party' then
    MapNotes_ClearMiniNote(true, 'party');

  elseif note and note.mininote then
    note.mininote = nil;

  else

    MapNotes_MiniNote_Data.key = key;
    MapNotes_MiniNote_Data.id = nid; -- able to show, because there wasn't a delete and its not received for showing on Minimap only

    if nid == 0 then

      MapNotes_MiniNote_Data.xPos = MapNotes_tloc_xPos;
      MapNotes_MiniNote_Data.yPos = MapNotes_tloc_yPos;
      MapNotes_MiniNote_Data.key = key;
      MapNotes_MiniNote_Data.name = MAPNOTES_THOTTBOTLOC;
      MapNotes_MiniNote_Data.color = 0;
      MapNotes_MiniNote_Data.icon = 'tloc';

      MN_MiniNotePOITexture:SetTexture(nil);

      if MNIL and MN_TLOC_ICON then
        MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
      end

      local txtr = MN_MiniNotePOITexture:GetTexture();
      if not txtr then
        MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
      end

    elseif nid == -1 then

      MapNotes_MiniNote_Data.xPos = MapNotes_PartyNoteData.xPos;
      MapNotes_MiniNote_Data.yPos = MapNotes_PartyNoteData.yPos;
      MapNotes_MiniNote_Data.key = key;
      MapNotes_MiniNote_Data.name = MAPNOTES_PARTYNOTE;
      MapNotes_MiniNote_Data.color = 0;
      MapNotes_MiniNote_Data.icon = 'party';

      MN_MiniNotePOITexture:SetTexture(nil);

      if MNIL and MN_PARTY_ICON then
        MN_MiniNotePOITexture:SetTexture(MN_PARTY_ICON);
      end

      local txtr = MN_MiniNotePOITexture:GetTexture();
      if not txtr then
        MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
      end

    elseif note then
      note.mininote = true;
    end
  end

  MapNotes_MapUpdate();
end


function MapNotes_Slash_MiniNoteOff()
  MapNotes_ClearMiniNote(nil, nil);
end


function MapNotes_ClearMiniNote(skipMapUpdate, typ)
  if typ and (typ == 'party' or typ == 'tloc') then
    if typ == 'party' then
      MapNotesPOIparty:SetAlpha(MapNotes_Options.aFactor / 100.0);
    else
      MapNotesPOItloc:SetAlpha(MapNotes_Options.aFactor / 100.0);
    end
    MapNotes_MiniNote_Data.xPos = nil;
    MapNotes_MiniNote_Data.yPos = nil;
    MapNotes_MiniNote_Data.key = nil;
    MapNotes_MiniNote_Data.id = nil; -- nothing to show on the zone map
    MapNotes_MiniNote_Data.name = nil;
    MapNotes_MiniNote_Data.color = nil;
    MapNotes_MiniNote_Data.icon = nil;
    MN_MiniNotePOI:Hide();

  elseif typ.ref then
    MapNotes_Data_Notes[typ.key][typ.ref].mininote = nil;
    typ:Hide();

  elseif typ.id then
    MapNotes_Data_Notes[typ.key][typ.id].mininote = nil;

  else

    MapNotes_MiniNote_Data.xPos = nil;
    MapNotes_MiniNote_Data.yPos = nil;
    MapNotes_MiniNote_Data.key = nil;
    MapNotes_MiniNote_Data.id = nil; -- nothing to show on the zone map
    MapNotes_MiniNote_Data.name = nil;
    MapNotes_MiniNote_Data.color = nil;
    MapNotes_MiniNote_Data.icon = nil;

    MN_MiniNotePOI:Hide();
  end

  if not skipMapUpdate then MapNotes_MapUpdate() end

end


function MapNotes_WriteNote()

  MapNotes_HideAll();

  local key = MapNotesEditFrame.k;
  local Plugin = MapNotes.pluginKeys[key];
  local currentNotes = MapNotes.CurrentNotes;
  local id = MapNotes_TempNote.Id;

  currentNotes[id] = {
    icon     = MapNotes_TempNote.Icon;
    name     = MapNotes_TitleWideEditBox:GetText();
    ncol     = MapNotes_TempNote.TextColor;
    inf1     = MN_Info1WideEditBox:GetText();
    in1c     = MapNotes_TempNote.Info1Color;
    inf2     = MN_Info2WideEditBox:GetText();
    in2c     = MapNotes_TempNote.Info2Color;
    creator  = MN_CreatorWideEditBox:GetText();
    xPos     = MapNotes_TempNote.xPos;
    yPos     = MapNotes_TempNote.yPos;
    mininote = MapNotes_TempNote.miniNote;
  };

  local note = currentNotes[id];

  if MapNotesEditFrame.miniMe then
    note.mininote = true;

  elseif key == MapNotes_MiniNote_Data.key
      and MapNotes_MiniNote_Data.id == MapNotes_TempNote.Id then
    note.mininote = true;
  end

  if Plugin then
    MapNotes_PlugInsDrawNotes(Plugin);
  else
    MapNotes_MapUpdate();
  end

end


function MapNotes_MapUpdate()
--  if WorldMapButton:IsVisible() then
    MapNotes_WorldMapButton_OnUpdate();
--  end
--  if Minimap:IsVisible() then
--    Minimap_OnUpdate(Minimap, 0.0);         --Telic_* (Lack of argument can cause error in Minimap.lua)
--  end
end


function MapNotes_HideAll()
  -- dialogs
  MapNotesEditFrame:Hide();
  MapNotesOptionsFrame:Hide();
  MapNotesSendFrame:Hide();

  MapNotes.ClearGUI();
end


function MapNotes_HideFrames()
  MapNotesEditFrame:Hide();
  MapNotesOptionsFrame:Hide();
  MapNotesSendFrame:Hide();
  MapNotes.ClearGUI();
end


function MapNotes_FramesHidden()

  local visible = 
      MapNotesEditFrame:IsVisible() or
      MapNotesSendFrame:IsVisible() or
      MapNotesOptionsFrame:IsVisible();

  return not visible;

end


function MapNotes_DeleteNote(nid, key, suppress)

  argcheck(nid, 1, 'number');
  argcheck(key, 2, 'string', 'table', 'nil');
  argcheck(suppress, 3, 'nil', 'boolean');

  local Plugin;

  if type(key) == 'string' then
    Plugin = MapNotes.pluginKeys[key];

  elseif type(key) == 'table' and key.frame then
    Plugin = key;
    key = MapNotes_PlugInsGetKey(key);

  elseif not key then
    key = MapNotes.MapKey;
  end

  if nid == 0 then -- tloc note

    MapNotes_tloc_xPos = nil;
    MapNotes_tloc_yPox = nil;
    MapNotes_tloc_name = nil;
    MapNotes_tloc_key  = nil;

    if MapNotes_MiniNote_Data.icon == 'tloc' then
      MapNotes_ClearMiniNote(true, 'tloc');
    end

    MapNotes_MapUpdate();

    return;

  elseif nid == -1 then -- party note

    MapNotes_PartyNoteData.xPos = nil;
    MapNotes_PartyNoteData.yPos = nil;
    MapNotes_PartyNoteData.key  = nil;

    if MapNotes_MiniNote_Data.icon == 'party' then
      MapNotes_ClearMiniNote(true, 'party');
    end

    if Plugin then
      MapNotes_PlugInsDrawNotes(Plugin)
    else
      MapNotes_MapUpdate();
    end

    return Plugin;

  end

  local currentNotes = MapNotes_Data_Notes[key];
  local note = currentNotes[nid];

  MapNotes_DeleteLines(key, note.xPos, note.yPos);

  if nid > 0 then
    
    MapNotes_Undelete_Info = currentNotes[nid];
    MapNotes_Undelete_Info.key = key;

    if Plugin then
      MapNotes_Undelete_Info.plugin = Plugin.name;  -- Plugin itself is a table reference which won't survive relog - so store name, and retrieve plugin based on it
    else                        -- If Plugin not loaded, then delete the undelete info...
      MapNotes_Undelete_Info.plugin = nil;
    end

    tremove(currentNotes, nid);

  end

  if not suppress then
    if Plugin then
      MapNotes_PlugInsDrawNotes(Plugin);
    else
      MapNotes_MapUpdate();
    end
  end

  return Plugin;

end


function MapNotes_Undelete()

  if not MapNotes_Undelete_Info then return end

  local key = MapNotes_Undelete_Info.key;
  if not key then return end

  local x, y = MapNotes_Undelete_Info.xPos, MapNotes_Undelete_Info.yPos;

  local currentNotes = MapNotes.CurrentNotes;

  local checknote = MapNotes_CheckNearbyNotes(key, x, y);

  if checknote then
    MapNotes.StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETOONEAR, currentNotes[checknote].name ) );
    return;
  end

  local nid = #currentNotes + 1;
  MapNotes_TempNote.Id = nid;
  currentNotes[nid] = MapNotes_Undelete_Info;

  local note = currentNotes[nid];

  local Plugin;

  if note.plugin then
    for p, details in pairs(MAPNOTES_PLUGINS_LIST) do
      if note.plugin == details.name then
        Plugin = details;
      end
    end
    if Plugin then MapNotes_PlugInsDrawNotes(Plugin); end
  else
    MapNotes_MapUpdate();
  end

  note.key = nil;
  note.plugin = nil;
  MapNotes_Undelete_Info = nil;

  MapNotes.StatusPrint( format(MAPNOTES_ACCEPT_SLASH, MapNotes_GetMapDisplayName(key, Plugin)) );

end


function MapNotes_DeleteNotesWithText(text, key)

  if not text then
    return;
  end

  local count, cText, Plugin = 0;

  if key and MapNotes_Data_Notes[key] then

    local records = MapNotes_Data_Notes[key];

    for n_id = #records, 1, -1 do
      cText = records[n_id].name .. records[n_id].inf1 .. records[n_id].inf2;
      if strfind(cText, text) then
        Plugin = MapNotes_DeleteNote(n_id, key, true);
        count = count + 1;
      end
    end

  else

    for key, records in pairs(MapNotes_Data_Notes) do

      for n_id = #records, 1, -1 do
        cText = records[n_id].name .. records[n_id].inf1 .. records[n_id].inf2;
        if strfind(cText, text) then
          Plugin = MapNotes_DeleteNote(n_id, key, true);
          count = count + 1;
        end
      end

    end

  end

  if text then
    MapNotes.StatusPrint(format(TEXT(MN_DELETED_WITH_TEXT), text) .. ' (' .. count .. ')');
  end

  if Plugin then
    MapNotes_PlugInsDrawNotes(Plugin);
  else
    MapNotes_MapUpdate();
  end

end


function MapNotes.DeleteNotesByCreatorAndName(creator, name, key)

  if not creator then return end

  local region = MN_ALLZONES;
  local count, Plugin = 0;

  local currentNotes;
  if key then
    currentNotes = MapNotes_Data_Notes[key];
  end

  if currentNotes then

    for id = #currentNotes, 1, -1 do
      local note = currentNotes[id];
      if note.creator == creator and ( name == nil or note.name == name ) then
        Plugin = MapNotes_DeleteNote(id, key, true);
        count = count + 1;
      end
    end

  else -- No key provided. Delete from all zones

    for key, currentNotes in pairs(MapNotes_Data_Notes) do
      for id = #currentNotes, 1, -1 do
        local note = currentNotes[id];
        if creator == note.creator and (name == note.name or name == nil) then
          Plugin = MapNotes_DeleteNote(id, key, true);
          count = count + 1;
        end
      end
    end
  end

  if name then
    MapNotes.StatusPrint(format(TEXT(MAPNOTES_DELETED_BY_NAME), creator, name) .. ' (' .. count .. ')');
  else
    MapNotes.StatusPrint(format(TEXT(MAPNOTES_DELETED_BY_CREATOR), creator) .. ' (' .. count .. ')');
  end

  if Plugin then
    MapNotes_PlugInsDrawNotes(Plugin);
  else
    MapNotes_MapUpdate();
  end

end


local function CoordinatesMatch(...)
  local x1, y1, x2, y2 = ...;
  return x1 == x2 and y1 == y2;
end


function MapNotes_ClearMiniNotesByCreator(creator)

  if not creator then return end

  for key, currentNotes in pairs(MapNotes_Data_Notes) do
    local id = 1;
    while id <= #currentNotes do
      if currentNotes[n_id].creator == creator then
        tremove(currentNotes, id);
      else
        id = id + 1;
      end
    end
  end

end


--[[

  This is the OnClick event handler for all WorldMap POI buttons

--]]
function MapNotes_Note_OnClick(self, button, down)

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  local lclFrame = self:GetParent();
  local Plugin = self.Plugin;
  local key = self.key;
  assert(key, 'No key defined for clicked WorldMap note');
  local nid = self.nid;
  assert(key, 'No nid defined for clicked WorldMap note');

  CloseDropDownMenus();   -- test to see if this can taint ? %%%

  if not MapNotes_FramesHidden() then
    return;
  end

  local currentNotes = MapNotes_Data_Notes[key];
  local note = currentNotes[nid];

  if MapNotes.LastLineClick.GUIactive then

    local ax = note.xPos;
    local ay = note.yPos;

    -- print('MapNotes.LastLineClick.GUIactive found true');
    -- printf('%q vs %q', key, tostring(MapNotes.LastLineClick.key));
    -- printf('(%.4f, %.4f) vs (%.4f, %.4f)', ax, ay, MapNotes.LastLineClick.x, MapNotes.LastLineClick.y);

    -- If this click is on the same map but at different coordinates then toggle the line
    if (key == MapNotes.LastLineClick.key
    		and not (CoordinatesMatch(ax, ay, MapNotes.LastLineClick.x, MapNotes.LastLineClick.y))) then

      MapNotes.ToggleLine(key, ax, ay, MapNotes.LastLineClick.x, MapNotes.LastLineClick.y, Plugin);
    end

    MapNotes.ClearGUI();

  elseif button == 'RightButton' then

    MapNotes_TempNote.Id = nil;       -- Doh!   *** DO NOT DELETE ***

    if CTRL and ALT then -- ctrl-alt-rightclick or ctrl-shift-alt-rightclick edits the note

      MapNotes_OpenEditForExistingNote(key, nid);
      MapNotes_TitleWideEditBox:SetFocus();
      MapNotes_TitleWideEditBox:HighlightText();

    elseif ALT then -- alt or alt-shift

      if SHIFT then -- alt-shift double-rightclick deletes the note

        local lTime = GetTime() - 0.6;

        if MapNotes_DoubleClick_Timer > lTime and MapNotes_DoubleClick_Id == nid and MapNotes_DoubleClick_Key == key then
          MapNotes_DeleteNote(nid, key);
          MapNotes_DoubleClick_Id = -2;
          MapNotes_DoubleClick_Key = '';
          MapNotes_DoubleClick_Timer = lTime - 2;

        else
          MapNotes_DoubleClick_Id = nid;
          MapNotes_DoubleClick_Key = key;
          MapNotes_DoubleClick_Timer = GetTime() - 0.1; -- paranoid in case 2 clicks can fetch same time ;P
        end

      
      elseif not Plugin or Plugin.wmflag then -- alt-rightclick toggles the mininote flag

        if note.mininote then
          note.mininote = nil;
        else
          note.mininote = true;
        end

        MapNotes_MapUpdate();
      end

    else -- ctrl or shift or ctrl-shift or nothing rightclick opens menu

--[[ This stuff seems to do nothing?

      local xOffset, yOffset = MapNotes_GetAdjustedMapXY(lclFrame);
      WorldMapTooltip:Hide();
      GameTooltip:Hide();
--]]
      MapNotes:InitialiseDropdown(lclFrame, note.xPos, note.yPos, MapNotes.note_dd_info, key, nid);
      ToggleDropDownMenu(1, nil, MapNotes.DropDown, 'cursor', 0, 0);
      WorldMapTooltip:Hide();
      MapNotes_WorldMapTooltip:Hide();
      GameTooltip:Hide();
    end

  elseif button == 'LeftButton' and ALT and not CTRL then

    local ax = note.xPos;
    local ay = note.yPos;

    -- If it's less than two seconds since the last alt-click, and this click
    -- is on the same map but at different coordinates then toggle the line
    if GetTime() - MapNotes.LastLineClick.time < MAPNOTES_TOGGLELINE_TIMEOUT then
    	if key == MapNotes.LastLineClick.key
    		  and not CoordinatesMatch(ax, ay, MapNotes.LastLineClick.x, MapNotes.LastLineClick.y) then

        MapNotes.ToggleLine(key, ax, ay, MapNotes.LastLineClick.x, MapNotes.LastLineClick.y, Plugin);
      end
    end

    MapNotes.LastLineClick.x = ax;
    MapNotes.LastLineClick.y = ay;
    MapNotes.LastLineClick.key = key;
    MapNotes.LastLineClick.time = GetTime();

  end
end


function MapNotes_StartGUIToggleLine(key, nid)
-- printf('MapNotes_StartGUIToggleLine(%s, %d)', key, nid);


  local currentNotes = MapNotes_Data_Notes[key];
  assert(currentNotes, format('Invalid current zone %q', tostring(key)));
  local note = currentNotes[nid];
  assert(note, format('Invalid note number %s', tostring(nid)));

  MapNotes.LastLineClick.x = note.xPos;
  MapNotes.LastLineClick.y = note.yPos;
  MapNotes.LastLineClick.key = key;
  MapNotes.LastLineClick.id = nid;

  MapNotes.LastLineClick.GUIactive = true;

end


function MapNotes.ClearGUI()

--  WorldMapMagnifyingGlassButton:SetText(MAPNOTES_WORLDMAP_HELP_1..'\n'..MAPNOTES_WORLDMAP_HELP_2..'\n'..MAPNOTES_WORLDMAP_HELP_3);

  MapNotes.LastLineClick.GUIactive = false;
end


function MapNotes_DrawLine(n_id, x1, y1, x2, y2, Plugin)          --Telic_2 (Added Plugin parameter)

  assert(
      type(x1) == 'number' and x1 >= 0 and x1 <= 1 and
      type(y1) == 'number' and y1 >= 0 and y1 <= 1 and
      type(x2) == 'number' and x2 >= 0 and x2 <= 1 and
      type(y2) == 'number' and y2 >= 0 and y2 <= 1,
      format('Invalid coordinates for DrawLine: %s, %s, %s, %s', tostringall(x1, y1, x2, y2)));

  local MapNotesLine = MapNotes_AssignLine(n_id, Plugin);

  local lineFrame = WorldMapDetailFrame;

  if Plugin then
    lineFrame = _G[Plugin.frame .. '_MNLinesFrame'];
  end

  local positiveSlopeTexture = MAPNOTES_PATH..'MiscGFX\\LineTemplatePositive256';
  local negativeSlopeTexture = MAPNOTES_PATH..'MiscGFX\\LineTemplateNegative256';
  local width = lineFrame:GetWidth();
  local height = lineFrame:GetHeight();

  local deltax = ( abs((x1 - x2) * width)  );
  local deltay = ( abs((y1 - y2) * height) );

  local xOffset = ( (math.min(x1,x2) * width ) );
  local yOffset = (-(math.min(y1,y2) * height) );
  local lowerpixel = math.min(deltax, deltay);

  lowerpixel = lowerpixel / 256;

  if lowerpixel > 1 then
    lowerpixel = 1;
  end

  if deltax == 0 then
    deltax = 2;
    MapNotesLine:SetTexture(0, 0, 0);
    MapNotesLine:SetTexCoord(0, 1, 0, 1);
  elseif deltay == 0 then
    deltay = 2;
    MapNotesLine:SetTexture(0, 0, 0);
    MapNotesLine:SetTexCoord(0, 1, 0, 1);
  elseif x1 - x2 < 0 then
    if y1 - y2 < 0 then
      MapNotesLine:SetTexture(negativeSlopeTexture);
      MapNotesLine:SetTexCoord(0, lowerpixel, 0, lowerpixel);
    else
      MapNotesLine:SetTexture(positiveSlopeTexture);
      MapNotesLine:SetTexCoord(0, lowerpixel, 1-lowerpixel, 1);
    end
  else
    if y1 - y2 < 0 then
      MapNotesLine:SetTexture(positiveSlopeTexture);
      MapNotesLine:SetTexCoord(0, lowerpixel, 1-lowerpixel, 1);
    else
      MapNotesLine:SetTexture(negativeSlopeTexture);
      MapNotesLine:SetTexCoord(0, lowerpixel, 0, lowerpixel);
    end
  end

  MapNotesLine:SetPoint('TOPLEFT', lineFrame, 'TOPLEFT', xOffset, yOffset);
  MapNotesLine:SetWidth(deltax);
  MapNotesLine:SetHeight(deltay);
  MapNotesLine:Show();
end


function MapNotes_DeleteLines(key, x, y)

  assert(key, format('Invalid key parameter %q', tostring(key)));
  assert(x and x >= 0 and x <= 1, format('Invalid x parameter %q', tostring(x)));
  assert(y and y >= 0 and y <= 1, format('Invalid y parameter %q', tostring(y)));

  local currentLines = MapNotes_Data_Lines[key];
  local lineCount = #currentLines;
  local offset = 0;

  local i = 1
  while i <= #currentLines do

    local line = currentLines[i];

    if line.x1 == x and line.y1 == y
        or line.x2 == x and line.y2 == y then
      tremove(currentLines, i);
    else
      i = i + 1;
    end
  end

  MapNotes.LastLineClick.key = 'nil';

end


function MapNotes.ToggleLine(mapKey, x1, y1, x2, y2, Plugin)
  -- printf('local function ToggleLine(%q, %f, %f, %f, %f, %s)',
  --       mapKey, x1, y1, x2, y2, tostring(Plugin));

  local currentLines = MapNotes_Data_Lines[mapKey];
  local new_line = true;

  for i = 1, #currentLines do

    local line = currentLines[i];

		if line then
		  if CoordinatesMatch(x1, y1, line.x1, line.y1) and CoordinatesMatch(x2, y2, line.x2, line.y2) or
				CoordinatesMatch(x1, y1, line.x2, line.y2) and CoordinatesMatch(x2, y2, line.x1, line.y1) then

			  tremove(currentLines, i);
			  MapNotes.CompactTable(currentLines); -- Shouldn't be necessary

	      PlaySound('igMainMenuOption');
	      new_line = false;
	      break;
      end
    end
  end

  if new_line then
  	-- print('Line not found - adding');
    tinsert(currentLines, { x1 = x1, x2 = x2, y1 = y1, y2 = y2 });
  end

  MapNotes.LastLineClick.key = 'nil';

  if Plugin then
    MapNotes_PlugInsDrawNotes(Plugin);
  else
    MapNotes_MapUpdate();
  end

end


function MapNotes_OpenEditForNewNote()

  if MapNotes_TempNote.Id == 0 then
    MapNotes_tloc_xPos = nil;
    MapNotes_tloc_yPos = nil;
    MapNotes_tloc_name = nil;
    MapNotes_tloc_key = nil;
  end

  local key = MapNotesEditFrame.k;
  local currentNotes = MapNotes_Data_Notes[key];
  local nid = #currentNotes + 1;

  MapNotes_TempNote.Id = nid;
  MapNotes_TempNote.Creator = UnitName('player');

  MapNotes_Edit_SetIcon(0);
  MapNotes_Edit_SetTextColor(0);
  MapNotes_Edit_SetInfo1Color(0);
  MapNotes_Edit_SetInfo2Color(0);
  MapNotes_TitleWideEditBox:SetText('');

  MN_Info1WideEditBox:SetText('');
  MN_Info2WideEditBox:SetText('');

  MN_CreatorWideEditBox:SetText(MapNotes_TempNote.Creator);

  MapNotes_HideAll();
  MapNotes_TempNote.miniNote = nil;

  if MapNotes_SetNextAsMiniNote == 1 or MapNotes_SetNextAsMiniNote == 2 then
    MapNotes_TempNote.miniNote = true;
  end

  MapNotesEditFrame:Show();

end


function MapNotes_SetPartyNote(xPos, yPos, pKey)
-- printf('MapNotes_SetPartyNote(%s, %s, %s)', tostringall(xPos, yPos, pKey));
--[[
  if not pKey and (GetCurrentMapZone() == 0 or GetCurrentMapContinent() == 0) then

    return;
  end
--]]

  local key, lKey;

  if pKey then
    key = pKey;
    _, lKey = MapNotes_GetMapDisplayName(key);
  else
    key = MapNotes.MapKey;
    lKey = MapNotes_GetMapDisplayName(key);

    -- if not (MapNotes_Keys[key] and MapNotes_Keys[key].miniData and MapNotes_Keys[key].miniData.scale) then
    --   return;
    -- end

  end

  MapNotes_PartyNoteData.key = key;
  MapNotes_PartyNoteData.xPos = xPos;
  MapNotes_PartyNoteData.yPos = yPos;

  local fmt = '<M_N> k<%s> x<%f> y<%f> l<%s> p<1>';
  local msg = format(fmt, key, xPos, yPos, lKey);

  if IsInRaid() then
    SendAddonMessage('MapNotes', msg, 'RAID');
    -- print('Party message sent');
  elseif IsInGroup() then
    SendAddonMessage('MapNotes', msg, 'PARTY');
    -- print('Party message sent');
  else
    SendAddonMessage('MapNotes', msg, 'WHISPER', UnitName('player'));
    -- print('Whisper message sent');
  end

  -- Option 16 == Automatically set party notes as MiniNote

  if not pKey and ( MapNotes_MiniNote_Data.icon == 'party' or MapNotes_Options[16] ) then

    MapNotes_MiniNote_Data.id = -1;
    MapNotes_MiniNote_Data.key = key;
    MapNotes_MiniNote_Data.xPos = xPos;
    MapNotes_MiniNote_Data.yPos = yPos;
    MapNotes_MiniNote_Data.name = MAPNOTES_PARTYNOTE;
    MapNotes_MiniNote_Data.color = 0;
    MapNotes_MiniNote_Data.icon = 'party';
    MN_MiniNotePOITexture:SetTexture(nil);

    if MNIL and MN_PARTY_ICON then
      MN_MiniNotePOITexture:SetTexture(MN_PARTY_ICON);
    end

    local txtr = MN_MiniNotePOITexture:GetTexture();

    if not txtr then
      MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
    end

  elseif pKey and MapNotes_MiniNote_Data.icon == 'party' then
    MapNotes_ClearMiniNote(true, 'party');
  end

  MapNotes_MapUpdate();

end


-- This function handles the OnClick event for all buttons based on the MN_MiniNotePOITemplate
-- template. This is all the MN_MiniNotePOIn notes on the Minimap

function MapNotes_MiniNote_OnClick(self, button, down)

-- printf('MapNotes_MiniNote_OnClick(%s)',
--     strjoin(', ', tostringall(self:GetName(), Modifiers(button), down)));
-- print('self.ref = ', self.ref);

  local CTRL, ALT, SHIFT = MapNotes.KeyStates();

  if button == 'RightButton' and self.ref and self.ref > 0 then

    if CTRL and not ALT then -- ctrl or ctrl-shift

      local x, y = GetPlayerMapPosition('player');

      if (x ~= 0 or y ~= 0)  and self.key == MapNotes.MapKey then
        MapNotes:InitialiseDropdown(UIParent, nil, nil, MapNotes.mininote_dd_info, MapNotes.MapKey, self.ref);
        ToggleDropDownMenu(1, nil, MapNotes.DropDown, 'cursor', 0, 0);
        return;
      end

    elseif SHIFT and ALT then -- shift-alt or ctrl-shift-alt

      local lTime = GetTime() - 0.7;        -- allow 1 second for the second click
      if MapNotes_DoubleClick_Timer > lTime and MapNotes_DoubleClick_Id == self.ref and MapNotes_DoubleClick_Key == self.key then
        MapNotes_HideFrames();
        MapNotes_DeleteNote(self.ref, self.key);
        MapNotes.StatusPrint(MAPNOTES_DELETE_NOTE);
        MapNotes_DoubleClick_Id = -2;
        MapNotes_DoubleClick_Key = '';
        MapNotes_DoubleClick_Timer = lTime - 2;

      else
        MapNotes_DoubleClick_Id = self.ref;
        MapNotes_DoubleClick_Key = self.key;
        MapNotes_DoubleClick_Timer = GetTime() - 0.1; -- paranoid in case 2 clicks can fetch same time ;P
      end

      return;

    elseif CTRL and ALT then -- ctrl-alt

      -- ctrl/alt

      if MapNotesEditFrame:IsVisible() then
        MapNotesEditFrame:Hide();
      else
        MapNotes_OpenEditForExistingNote(self.key, self.ref);
        MapNotes_TitleWideEditBox:SetFocus();
        MapNotes_TitleWideEditBox:HighlightText();
      end

      return;

    elseif ALT then -- alt

      -- alt

      local currentNotes = MapNotes_Data_Notes[self.key];
      local note = currentNotes[self.ref];

      if note then
        note.mininote = nil;
      end

      MapNotes_MapUpdate();

      return;

    end

    -- shift or none do nothing

  -- This appears to be legacy code that handles clicks on the part/tloc notes. Now
  -- handled separately by MapNotes_Misc_OnClick

  elseif button == 'RightButton' and self.ref <= 0 then

    if CTRL and not ALT then

      -- ctrl or ctrl/shift

      -- SetMapToCurrentZone();
      local x, y = GetPlayerMapPosition('player');

      if x > 0 or y > 0 then

        local key = MapNotes.MapKey;

        if self.key == key then
          MapNotes:InitialiseDropdown(UIParent, MapNotes_MiniNote_Data.xPos, MapNotes_MiniNote_Data.yPos, MapNotes.temp_dd_info, key, self.ref);
          ToggleDropDownMenu(1, nil, MapNotes.DropDown, 'cursor', 0, 0);
          return;
        end
      end

    elseif SHIFT and not (ALT or CTRL) then

      -- shift

      MapNotes_DeleteNote(self.ref, self.key);

    elseif ALT and not (CTRL or SHIFT) then

      --alt

      if self.ref == 0 then
        MapNotes_ClearMiniNote(nil, 'tloc');
      elseif self.ref == -1 then
        MapNotes_ClearMiniNote(nil, 'party');
      end
    end

    -- alt alt/shift ctrl/alt ctrl/alt/shift none do nothing

    return;

  end

  Minimap_OnClick(Minimap, button);

end


function MapNotes_Minimap_OnClick(...)

  local self, button, down = ...;

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  local hook = CTRL and ALT and button == 'RightButton';

  if not hook then
    return orig_Minimap_OnClick(...);
  end

  -- printf('MapNotes_Minimap_OnClick(%s)', strjoin(', ', tostringall(self, button, ...)) );

  local x, y = GetCursorPosition();
  x = x / self:GetEffectiveScale();
  y = y / self:GetEffectiveScale();

  local cx, cy = self:GetCenter();
  x = x - cx;
  y = 1 - ( y - cy );
  local dist = sqrt(x * x + y * y);

  if dist < self:GetWidth() / 2 then

    -- SetMapToCurrentZone();
    local playerX, playerY = GetPlayerMapPosition('player');
    local zone, continent = GetCurrentMapZone(), GetCurrentMapContinent();

    if playerX == 0 and playerY == 0 then return end

    local currentConst, currentZoom, facing, xScale, yScale, mapX, mapY;
    local key = MapNotes.MapKey;

    if MapNotes_Keys[key] and MapNotes_Keys[key].miniData then

      if MapNotes_Keys[key] and MapNotes_Keys[key].miniData then
        currentConst = MapNotes_Keys[key].miniData;
      else
        currentConst = MAPNOTES_BASEKEYS.DEFAULT.miniData;
      end

      currentZoom = MapNotes.MinimapZoom;

      if MapNotes.RotatingMinimap() then
        facing = - GetPlayerFacing();
      end

      if facing then
        local theta = atan2(x, y);
        theta = theta - facing;
        x = sin(theta) * dist;
        y = cos(theta) * dist;
      end

      if zone > 0 then
        xScale = MapNotes_MiniConst[continent][currentZoom].xScale;
        yScale = MapNotes_MiniConst[continent][currentZoom].yScale;
      else
        xScale = MapNotes_MiniConst[MAPNOTES_BASEKEYS.DEFAULT.miniData.cont][currentZoom].xScale;
        yScale = MapNotes_MiniConst[MAPNOTES_BASEKEYS.DEFAULT.miniData.cont][currentZoom].yScale;
      end

      if MapNotes.Indoors then
        xScale = xScale * MapNotes_IndoorsScale[currentZoom].indoorsScale;
        yScale = yScale * MapNotes_IndoorsScale[currentZoom].indoorsScale;
      end

      playerX = playerX * currentConst.scale;
      playerY = playerY * currentConst.scale;

      x = (x / xScale + playerX) / currentConst.scale;
      y = (y / yScale + playerY) / currentConst.scale;

      MapNotes_ShortCutNote(x, y, nil, true);
    end
  end

  MapNotes_MapUpdate();

end


-- Create the note in the Players current Map if not in an Instance
function MN_ThottInterface_Local(x, y, desc, creator)
  -- No need to reset to a previous map - if not current then they're probably viewing a map,
  -- and presumably would want to see it change and the marker placed on it...
  -- SetMapToCurrentZone();

  -- Get MapKey if valid coordinate system for current map...
  local pX, pY = GetPlayerMapPosition('player');
  if pX <= 0 and pY <= 0 then
    return;
  end
  local key = MapNotes.MapKey;

  MN_ThottInterface(key, x, y, desc, creator);
end


-- Create the note on a specified map using legacy keying system
-- This may suffer from the old zone shift problems associated with this keying system on different clients, depending on other AddOn calling it
function MN_ThottInterface_Legacy(c, z, x, y, desc, creator)
  -- Translate Continent/Zone to key
  local key = MapNotes_OldKeys[c][z];

  -- Could do some testing for inside Instances where note creation is possible.... ???

  if key then
--    SetMapZoom(c, z);               -- ???
    MN_ThottInterface(key, x, y, desc, creator);
  end
end


function MN_ThottInterface(key, x, y, desc, creator)

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  local msg;

--  if ALT then            -- Must hold down <Alt> if wanting a temporary Thott marker
  if ( creator == 'AlphaMobMap' ) or ( not CTRL ) then
    if not desc then
      desc = MAPNOTES_THOTTBOTLOC;
    end
    MapNotes_tloc_xPos = x / 100;
    MapNotes_tloc_yPos = y / 100;
    MapNotes_tloc_name = desc;
    MapNotes_tloc_key = MapNotes.MapKey;
    MapNotes_MiniNote_Data.id = 0;
    MapNotes_MiniNote_Data.key = MapNotes_tloc_key;
    MapNotes_MiniNote_Data.xPos = MapNotes_tloc_xPos;
    MapNotes_MiniNote_Data.yPos = MapNotes_tloc_yPos;
    MapNotes_MiniNote_Data.name = MapNotes_tloc_name;
    MapNotes_MiniNote_Data.color = 4;
    MapNotes_MiniNote_Data.icon = 'tloc';
    MN_MiniNotePOITexture:SetTexture(nil);
    if ( MNIL ) and ( MN_TLOC_ICON ) then
      MN_MiniNotePOITexture:SetTexture(MN_TLOC_ICON);
    end
    local txtr = MN_MiniNotePOITexture:GetTexture();
    if not txtr then
      MN_MiniNotePOITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..MapNotes_MiniNote_Data.icon);
    end
    MapNotes_MapUpdate();

  elseif CTRL then        -- else hold down <Ctrl> if wanting a permanent marker
    -- Hide other frames
    -- Set Creator to Lightheaded
    -- Use Red Cross marker
    MapNotes_HideFrames();
    local MN_creatorOverride, MN_mininoteOverride = creator, true;
    if ( not MN_creatorOverride ) and ( Lightheaded ) then
      MN_creatorOverride = 'Lightheaded';
   -- else
   --   MN_creatorOverride = '';
    end

    if SHIFT then
      MN_mininoteOverride = nil;
    end

    MapNotes_Slash_QuickTLoc( x .. ', ' .. y .. ' 6 '..desc, MN_creatorOverride, MN_mininoteOverride );
  end
end


-- This function hooks the existing WorldMapButton OnClick handler directly. It
-- completely replaces it, so if the original handler needs to be called then
-- this function must do so explicitly by calling orig_MapNotes_WorldMapButton_OnClick
-- For some reason this hook doesn't see any clicks that are done without the control
-- key held down

function MapNotes_WorldMapButton_OnClick(...)
  local self, button, down = ...;
  -- printf('MapNotes_WorldMapButton_OnClick(%s)', strjoin(', ',
  --     self:GetName(), Modifiers()..'-'..button, tostring(down)));

  CloseDropDownMenus();

  if not MapNotes_FramesHidden() then return end

  MapNotes.ClearGUI();

  local key = MapNotes.MapKey;
  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  local hooked =
      MapNotes.ZoneWidthYards > 0 and
      MapNotes.ZoneHeightYards > 0 and
      button == 'RightButton' and (CTRL or SHIFT);
  -- printf('hooked = %s', tostring(hooked));

  -- if we are viewing a continent or continents or it was left-click call the original handler
  if not hooked then
    -- print('Passing click through to WorldMapButton');
    orig_MapNotes_WorldMapButton_OnClick(...);
    return;
  end

  -- <control> right-click is used to bring up the main menu when viewing a particular zone/city
  -- <shift> right-click is used to set the party note at the click location

  self = self or WorldMapButton;

  local adjustedX, adjustedY = MapNotes_GetMouseXY(self);

  if SHIFT then -- shift or ctrl-shift or shift-alt or ctrl-shift-alt 

    if MapNotes.MapID > 0 then
      MapNotes_SetPartyNote(adjustedX, adjustedY);
      MapNotes_MapUpdate();
    else
      orig_MapNotes_WorldMapButton_OnClick(...);
    end

  elseif ALT then -- ctrl-alt

    -- print('ShortCutNote');

    local lNote = MapNotes_ShortCutNote(adjustedX, adjustedY);
    MapNotes_MapUpdate();
    if lNote then
      lNote = _G['MapNotesPOI' .. lNote];
      if lNote then
        lNote:SetFrameLevel( MapNotes_WorldMapButton:GetFrameLevel() + 1 );
      end
    end

  elseif CTRL then --ctrl

    MapNotes:InitialiseDropdown(self, adjustedX, adjustedY, MapNotes.base_dd_info, key);
    ToggleDropDownMenu(1, nil, MapNotes.DropDown, 'cursor', 0, 0);

  end

end


-- %%% THE CORE %%%
function MapNotes_WorldMapButton_OnUpdate()

--  if not WorldMapFrame:IsVisible() then
--    return;
--  end

  MapNotesFU_Drawing = true;

  local key = MapNotes.MapKey;

  if not key then return end

  local border  = (MapNotes_Options.iFactor / MAPNOTES_DFLT_ICONSIZE ) * MAPNOTES_BORDER;
  local lBorder = (MapNotes_Options.iFactor / MAPNOTES_DFLT_ICONSIZE ) * (MAPNOTES_BORDER / 2);
  local width, height = WorldMapButton:GetSize();
  local currentNotes = MapNotes.CurrentNotes;
  local currentLines = MapNotes.CurrentLines;
  local xOffset, yOffset = 0, 0;
  local nNotes, nLines = 1, 1;
  local scalingFactor = MN_ScaleMe(WorldMapButton);

  if not MapNotes_Keys[key] then
  end

  if currentNotes and MapNotes_Options.shownotes then 

    for i, note in ipairs(currentNotes) do

      -- Data Validity Checks : Set Defaults for missing mandatory data

      if not note.icon then
        note.icon = 0;
      end

      local POI = MapNotes_AssignPOI(i);
      POI.key = key;
      POI.nid = i;

      local POIName = POI:GetName();

      POI:SetScale(scalingFactor);

      local xOffset = ( note.xPos * width ) / scalingFactor;
      local yOffset = ( -note.yPos * height ) / scalingFactor;

      POI:SetUserPlaced(false);
      POI:ClearAllPoints();
      POI:SetPoint('CENTER', 'WorldMapDetailFrame', 'TOPLEFT', xOffset, yOffset);

      local POITexture = _G[POIName..'Texture'];
      local POIMininote = _G[POIName..'Mininote'];
      local POILastnote = _G[POIName..'Lastnote'];
      local POIHighlight = _G[POIName..'Highlight'];

      -- Custom
      POITexture:SetTexture(nil);

      if MNIL and note.customIcon then
        POITexture:SetTexture(note.customIcon);
      end
      if not POITexture:GetTexture() then
        POITexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icon'..note.icon);
      end

      local noteName = strlower(note.name);
      if MapNotes_HighlightedNote ~= '' and noteName:find(MapNotes_HighlightedNote) then
        POIHighlight:Show();
        -- Custom
        if noteName == MapNotes_HighlightedNote and MapNotes_Options[13] then
          POIMininote:Show();
        end
      -- Custom
      elseif note.mininote and MapNotes_Options[13] then
        POIMininote:Show();
        POIHighlight:Hide();
      else
        POIMininote:Hide();
        POIHighlight:Hide();
      end

      -- Check whether notes with this icon are enabled
      if not MapNotes_Options[note.icon] then
        POI:Hide();
      elseif MapNotes_Options[10] and note.creator == UnitName('player') or
          MapNotes_Options[11] and note.creator ~= UnitName('player') then

        POI:SetWidth( MapNotes_Options.iFactor );
        POIMininote:SetWidth( border );
        POI:SetHeight( MapNotes_Options.iFactor );
        POIMininote:SetHeight( border );
        POI:SetAlpha( MapNotes_Options.aFactor / 100.0);
        POILastnote:Hide();
        POI:Show();
      end

      -- If this is the last note in the zone, then put a red border around it
      -- if this facility is enabled

      if i == #currentNotes and MapNotes_Options[12] then
        if POI and POI:IsVisible() then
          -- Custom
          POILastnote:SetWidth(lBorder);
          POILastnote:SetHeight(lBorder);
          POILastnote:Show();
        end
      end

      nNotes = nNotes + 1;

    end

    if currentLines then
      for i, line in ipairs(currentLines) do
        MapNotes_DrawLine(i, line.x1, line.y1, line.x2, line.y2);
        nLines = nLines + 1;
      end
    end

  end

  -- Hide all of the POI buttons and line textures that are unused in this zone

  local otherPOI = _G['MapNotesPOI'..nNotes];
  while (otherPOI) do
    otherPOI:Hide();
    nNotes = nNotes + 1;
    otherPOI = _G['MapNotesPOI'..nNotes];
  end

  local otherLines = _G['MapNotesLines_'..nLines];
  while (otherLines) do
    otherLines:Hide();
    nLines = nLines + 1;
    otherLines = _G['MapNotesLines_'..nLines];
  end

  if currentNotes then
    -- tloc button
    if MapNotes_tloc_xPos and MapNotes_tloc_key == key then

      MapNotesPOItlocTexture:SetTexture(nil);

      if MNIL and MN_TLOC_ICON then
        MapNotesPOItlocTexture:SetTexture(MN_TLOC_ICON);
      end

      if not MapNotesPOItlocTexture:GetTexture() then
        MapNotesPOItlocTexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Icontloc');
      end

      if MapNotes_Options[13] and MapNotes_MiniNote_Data.icon == 'tloc' then
        MapNotesPOItlocMininote:SetWidth( border );
        MapNotesPOItlocMininote:SetHeight( border );
        MapNotesPOItlocMininote:Show();
        MapNotesPOItlocMininote.key = key;
        MapNotesPOItlocMininote.nid = 0;
      else
        MapNotesPOItlocMininote:Hide();
      end

      MapNotesPOItloc:SetScale( scalingFactor );

      xOffset = ( MapNotes_tloc_xPos * width ) / scalingFactor;
      yOffset = ( -MapNotes_tloc_yPos * height ) / scalingFactor;

      MapNotesPOItloc:SetPoint('CENTER', 'WorldMapDetailFrame', 'TOPLEFT', xOffset, yOffset);
      MapNotesPOItloc:SetWidth(MapNotes_Options.iFactor );
      MapNotesPOItloc:SetHeight(MapNotes_Options.iFactor );
      MapNotesPOItloc:SetAlpha(MapNotes_Options.aFactor / 100.0);
      MapNotesPOItloc:Show();
      MapNotesPOItloc.key = key;
      MapNotesPOItloc.nid = 0;
    else
      MapNotesPOItloc:Hide();
    end

    -- party note
    if MapNotes_PartyNoteData.xPos and key == MapNotes_PartyNoteData.key then

      MapNotesPOIpartyTexture:SetTexture(nil);

      if MNIL and MN_PARTY_ICON then
        MapNotesPOIpartyTexture:SetTexture(MN_PARTY_ICON);
      end

      if not MapNotesPOIpartyTexture:GetTexture() then
        MapNotesPOIpartyTexture:SetTexture(MAPNOTES_PATH..'POIIcons\\Iconparty');
      end

      if MapNotes_Options[13] and MapNotes_MiniNote_Data.icon == 'party' then
        MapNotesPOIpartyMininote:SetWidth( border );
        MapNotesPOIpartyMininote:SetHeight( border );
        MapNotesPOIpartyMininote:Show();
        MapNotesPOIpartyMininote.key = key;
        MapNotesPOIpartyMininote.nid = -1;
      else
        MapNotesPOIpartyMininote:Hide();
      end

      MapNotesPOIparty:SetScale(scalingFactor);

      xOffset = (MapNotes_PartyNoteData.xPos * width) / scalingFactor;
      yOffset = (-MapNotes_PartyNoteData.yPos * height) / scalingFactor;

      MapNotesPOIparty:SetPoint('CENTER', 'WorldMapDetailFrame', 'TOPLEFT', xOffset, yOffset);
      MapNotesPOIparty:SetWidth( MapNotes_Options.iFactor );
      MapNotesPOIparty:SetHeight( MapNotes_Options.iFactor );
      MapNotesPOIparty:SetAlpha(MapNotes_Options.aFactor / 100.0);
      MapNotesPOIparty:Show();
      MapNotesPOIparty.key = key;
      MapNotesPOIparty.nid = -1;
    else
      MapNotesPOIparty:Hide();
    end

  else
    MapNotesPOItloc:Hide();
    MapNotesPOIparty:Hide();
  end

  for pluginName, Plugin in pairs(MAPNOTES_PLUGINS_LIST) do
    if Plugin.wmflag then
      local plugInFrame = _G[Plugin.frame];
      if plugInFrame and plugInFrame:IsVisible() then
        MapNotes_PlugInsDrawNotes(Plugin);
      end
    end
  end

  MapNotesFU_Drawing = nil;
end


-- This function hooks the OnShow and OnHide handlers for WorldMapFrame

function MapNotes.ToggleWorldMap(frame)

  local frameName = frame:GetName();

  -- For some reason a call to SetMapToCurrentZone here doesn't have an effect
  -- Instead we set a flag and do it later in MapNotes_OnUpdate

  if WorldMapFrame:IsVisible() then
    -- print(frameName.. ' shown');
  else
    -- print(frameName.. ' hidden');
    MapNotes.SetMap = true;
    -- SetMapToCurrentZone();
    MapNotes.UpdateMapInfo();
  end

  MapNotes_HideAll();
  ColorPickerFrame:Hide();

end


function MapNotes.ToggleFrame(frame)

  local frameName = frame:GetName();
  -- printf('MapNotes.ToggleFrame(%s)', frameName);

  if frameName ~= 'WorldMapFrame' then return end

  if frame:IsVisible() then
    -- print(frameName.. ' toggled on');
  else
    -- print(frameName.. ' toggled off');
    SetMapToCurrentZone();
    MapNotes.UpdateMapInfo();
  end

  MapNotes_HideAll();
  ColorPickerFrame:Hide();

end


function MapNotes_RememberPosition(self)

  local n_id = self:GetID();
  local Plugin = self.Plugin;
  local key;

  if Plugin then
    key = MapNotes_PlugInsGetKey(Plugin);
  else
    key = MapNotes.MapKey;
  end

  self.lastXPos = MapNotes_Data_Notes[key][n_id].xPos;
  self.lastYPos = MapNotes_Data_Notes[key][n_id].yPos;
end


function MapNotes_RepositionNote(self)

  local n_id = self:GetID();
  local pFrame = self:GetParent();
  local Plugin = self.Plugin;

  if MouseIsOver(pFrame) then

--  local x, y = MapNotes_GetMouseXY(pFrame);

    local x, y = self:GetCenter();
    local l, b, w, h = self:GetParent():GetRect();
    local t = b + h;
    x, y = (x - l) / w, (t - y) / h;

    local key;
    if Plugin then
      key = MapNotes_PlugInsGetKey(Plugin);
    else
      key = MapNotes.MapKey;
    end

    MapNotes_Data_Notes[key][n_id].xPos = x;
    MapNotes_Data_Notes[key][n_id].yPos = y;

    -- Update Lines using this Note as a Vertex
    local lX = self.lastXPos;
    local lY = self.lastYPos;
    for i, line in ipairs(MapNotes_Data_Lines[key]) do
      if line.x1 == lX and line.y1 == lY then
        line.x1 = x;
        line.y1 = y;

      elseif line.x2 == lX and line.y2 == lY then
        line.x2 = x;
        line.y2 = y;
      end
    end
  end

  if Plugin then
    MapNotes_PlugInsDrawNotes(Plugin);
  else
    MapNotes_MapUpdate();
  end

end

-- MapNotes Global Search
function MapNotes_Slash_MNSearch(fTxt)

  if fTxt and fTxt ~= '' then
    local foundArray = {};

    fTxt = string.lower(fTxt);
    for key, map in pairs(MapNotes_Data_Notes) do
      for index, note in ipairs(map) do
        local sTxt = string.lower( note.name .. note.inf1 .. note.inf2 .. note.creator );
        if sTxt:find(fTxt) then
          local name, lName, cat;
          if string.sub(key, 1, 3) == 'WM ' then
            name, lName, cat = MapNotes_GetMapDisplayName(key);

          else
            for index, Plugin in pairs(MAPNOTES_PLUGINS_LIST) do
              if key:find(Plugin.name) then
                name, lName, cat = MapNotes_GetMapDisplayName(key, Plugin);
                break;
              end
            end
          end
          if not foundArray[cat] then
            foundArray[cat] = {};
            foundArray[cat].counter = 1;
          end
          if not foundArray[cat][lName] then
            foundArray[cat][lName] = {};
            foundArray[cat][lName].counter = 1;
          else
            foundArray[cat][lName].counter = foundArray[cat][lName].counter + 1;
          end
        end
      end
    end

    local counter = 0;
    MapNotes.StatusPrint(' ');
    for type, noteTypes in pairs(foundArray) do
      MapNotes.StatusPrint('----------');
      MapNotes.StatusPrint(type);
      for key, note in pairs(noteTypes) do
        if key ~= 'counter' then
          MapNotes.StatusPrint(key .. ' : ' .. note.counter .. MAPNOTES_NOTESFOUND);
          counter = counter + 1;
        end
      end
    end
    MapNotes.StatusPrint('----------');
    MapNotes.StatusPrint(counter.. ' ' .. ZONE);
    MapNotes.StatusPrint(' ');
  end
end


function MapNotes_Slash_MNHighlight(hName)
  if hName and hName ~= '' then
    hName = string.lower(hName);
    MapNotes_HighlightedNote = hName;
    MapNotes_TrackHighlights(hName, true);
  else
    MapNotes_HighlightedNote = '';
    MapNotes_TrackHighlights(hName);
  end
  MapNotes_PlugInsRefresh();
  MapNotes_MapUpdate();
end


function MapNotes_TrackHighlights(hName, hlVal)
  MapNotes_ClearTrackHighlights();
  if hlVal then
    highlightedNotes = {};
    for dat, val in pairs(MapNotes_Data_Notes) do
      for note, noteA in pairs(val) do
        local dataName = string.lower(noteA.name);
        if dataName == hName then
          if ( hlVal ) and ( not noteA.mininote ) then
            noteA.mininote = 'HL';
            if not highlightedNotes[dat] then
              highlightedNotes[dat] = {};
            end
            if not highlightedNotes[dat][note] then
              highlightedNotes[dat][note] = true;
            end
          end
        end
      end
    end
  end
end


function MapNotes_ClearTrackHighlights()
  for dat, val in pairs(MapNotes_Data_Notes) do
    if highlightedNotes[dat] then
      for note, noteA in pairs(val) do
        if highlightedNotes[dat][note] then
          noteA.mininote = nil;
        end
      end
    end
  end
end


function MapNotes_ResetHighlightsOnLoad()
  for dat, val in pairs(MapNotes_Data_Notes) do
    for note, noteA in pairs(val) do
      if ( noteA.mininote ) and ( noteA.mininote == 'HL' ) then
        noteA.mininote = nil;
      end
    end
  end
end


function MapNotes_Slash_MNMiniCoords()
  if MN_MinimapCoordsFrame:IsVisible() then
    MN_MinimapCoordsFrame:Hide();
    MapNotesOptionsCheckboxMiniC:SetChecked(0);
    MapNotes_Options.miniC = false;
  else
    MN_MinimapCoordsFrame:ClearAllPoints();
    MN_MinimapCoordsFrame:SetUserPlaced(0);
    MN_MinimapCoordsFrame:SetPoint('TOP', 'MinimapCluster', 'BOTTOM', 8, 16);
    MN_MinimapCoordsFrame:Show();
    MapNotesOptionsCheckboxMiniC:SetChecked(1);
    MapNotes_Options.miniC = true;
  end
end


function MapNotes_Slash_MNMapCoords()

  if MN_MapCoords:IsVisible() then
    MapNotes_Options.mapC = false;
    MapNotesOptionsCheckboxMapC:SetChecked(0);
  else
    MapNotes_Options.mapC = true;
    MapNotesOptionsCheckboxMapC:SetChecked(1);
  end

  MN_SetCoordsPos();

end


function MN_SetCoordsPos()

  local x, y = MapNotes_Options.coordsLocX, MapNotes_Options.coordsLocY;

--  MN_MapCoords:ClearAllPoints();
  MN_MapCoords:SetUserPlaced(0);
--  MN_MapCoords:SetParent(WorldMapButton);
--  MN_MapCoords:SetPoint('BOTTOMLEFT', 'WorldMapButton', 'BOTTOMLEFT', x, y);
  MN_MapCoords:SetPoint('TOPLEFT', x, y);
  MN_MapCoords:SetFrameLevel(WorldMapButton:GetFrameLevel() + 3);

  if MapNotes_Options.mapC then
    MN_MapCoords:Show();
  else
    MN_MapCoords:Hide();
  end

end


-- Fix this to use actual frame position instead of mouse position

function MN_RememberCoordsPos()


--  local point, relativeTo, relativePoint, xOfs, yOfs = GetPoint(MN_MapCoords);

  if MN_MapCoords.isMoving then

    if MouseIsOver(WorldMapFrame) then
      MN_MapCoords.startingX, MN_MapCoords.startingY = MN_GetRelativeCoords(MN_MapCoords, WorldMapButton);
    else
      MN_MapCoords.startingX, MN_MapCoords.startingY = MN_DefaultCoordsX, MN_DefaultCoordsY;
    end

  else

    local x, y;

    if MouseIsOver(WorldMapFrame) then
      x, y = MN_GetRelativeCoords(MN_MapCoords, WorldMapButton);
    else
      x, y = MN_MapCoords.startingX, MN_MapCoords.startingY;
    end

    MapNotes_Options.coordsLocX, MapNotes_Options.coordsLocY = x, y;
    MN_SetCoordsPos();

  end

end

-- %%% Corrected positioning function ???
function MN_GetRelativeCoords(pFrame, rFrame)

    local pL, pB, pW, pH = pFrame:GetRect();
    local pT = pB + pH;

    local rL, rB, rW, rH = rFrame:GetRect();
    local rT = rB + rH;

    return pL - rL, pT - rT;
--[[

    local x, y = pFrame:GetCenter();
    local centerX, centerY = rFrame:GetCenter();
    local width = rFrame:GetWidth();
    local height = rFrame:GetHeight();

    x = (x - (centerX - (width/2)));
    y = height - (centerY + (height/2) - y );

    return x, y;
--]]
end

-- £££1
function MN_MinimapCoords_OnUpdate(self)
  local x,y = GetPlayerMapPosition('player');
  if recordingData then

  end
  if ( x ) and ( y ) then
    x = x*100;
    y = y*100;
    MN_MinimapCoordsFrameText:SetText( format(MN_COORD_FS[MN_COORD_F], x, y) );
    MN_MinimapCoordsFrame:SetWidth(MN_MinimapCoordsFrameText:GetWidth() + 12);
  end
end


function MN_MapCoords_OnUpdate(self, elapsed)

  local CTRL, SHIFT, ALT = MapNotes.KeyStates();

  if CTRL then
    if not MN_MapCoordsMovementFrame:IsVisible() then
      MN_MapCoordsMovementFrame:Show();
    end
  else
    if MN_MapCoordsMovementFrame:IsVisible() then
      if MN_MapCoords.isMoving then
        MN_MapCoords:StopMovingOrSizing();
        MN_MapCoords.isMoving = false;
        MN_RememberCoordsPos();
      end
      MN_MapCoordsMovementFrame:Hide();
    end
  end

  MN_cUpdate = MN_cUpdate + elapsed;
  if MN_cUpdate < MN_cUpdateLimit then
    return;
  end

  local pLoc, cLoc = '', nil;
  local x,y = GetPlayerMapPosition('player');
  local cX, cY = nil, nil;

  if x and y then
    x = x * 100;
    y = y * 100;
    pLoc = '|c0000FF00'..( format(MN_COORD_FS[MN_COORD_F], x, y) )..'|r';
  end

  if MouseIsOver(WorldMapButton) then

    local centerX, centerY = WorldMapButton:GetCenter();
    local width = WorldMapButton:GetWidth();
    local height = WorldMapButton:GetHeight();

    cX, cY = GetCursorPosition();
    cX = cX / WorldMapButton:GetEffectiveScale();
    cY = cY / WorldMapButton:GetEffectiveScale();

    local adjustedY = (centerY + height/2 - cY) / height;
    local adjustedX = (cX - (centerX - width/2)) / width;

    cX = 100 * ( adjustedX + MN_MOFFSET_X );
    cY = 100 * ( adjustedY + MN_MOFFSET_Y );

  end

  local sizeX = MN_CoordsSizingText:GetWidth();
  local sizeY = MN_CoordsSizingText:GetHeight();

  local h = sizeY * 2;
  if cX and cY then
    cLoc = '\n|c00FFFF00'..( format(MN_COORD_FS[MN_COORD_F], cX, cY) )..'|r';
    h = h + sizeY;
  end

  MN_MapCoordsText:SetText( pLoc .. ( cLoc or '' ) );
  MN_cUpdate = 0;

  local w = sizeX;

  -- This is a hack for now. When the coords frame is moved it acquires
  -- a second anchor point. That causes it to be stretched across the
  -- screen instead of using the calculated width. Will do it properly
  -- when I understand more about how it's happening.
  local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1);
  self:ClearAllPoints();
  self:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs);

  self:SetWidth(w);
  self:SetHeight(h);

end


function MN_MinimapCoords_OnClick()
  MapNotes:InitialiseDropdown(UIParent, nil, nil, MapNotes.coords_dd_info);
  ToggleDropDownMenu(1, nil, MapNotes.DropDown, 'cursor', 0, 0);
end


function MapNotes_Slash_MNTarget(inf2)

  inf2 = inf2 or '';

  local t = UnitName('target');

  if not t then
    MapNotes_Slash_QuickNote(inf2);
    return;
  end

  if not MapNotes_TargetInfo_Proceed then

    local x, y = GetPlayerMapPosition('player');

    if x == 0 and y == 0 then
      SetMapToCurrentZone();
      x, y = GetPlayerMapPosition('player');
      if x == 0 and y == 0 then
        MapNotes.StatusPrint(MAPNOTES_QUICKNOTE_NOPOSITION);
        return;
      end
    end

    local tstIcon, newinf = inf2:match('^(%d+)%s+(.+)');
    if tstIcon then
      inf2 = newinf;
    end

    GameTooltip:Hide();

    GameTooltip:SetOwner(UIParent, 'ANCHOR_CURSOR');
    GameTooltip:SetUnit('target');
    GameTooltip:SetFrameStrata('TOOLTIP');
    GameTooltip:Show();

    MapNotes_TargetInfo_Proceed = {};
    MapNotes_TargetInfo_Proceed.tstIcon = tstIcon;
    MapNotes_TargetInfo_Proceed.inf2 = inf2;
    MapNotes_TargetInfo_Proceed.func = MapNotes_Slash_MNTarget;

  else
    MapNotes_TargetInfo_Proceed.name, MapNotes_TargetInfo_Proceed.inf1 = MapNotes_TargetInfo();
    if MapNotes_TargetInfo_Proceed.tstIcon then
      MapNotes_TargetInfo_Proceed.name = MapNotes_TargetInfo_Proceed.tstIcon .. string.sub(MapNotes_TargetInfo_Proceed.name, 3);
    end
    MapNotes_Slash_QuickNote(MapNotes_TargetInfo_Proceed.name, MapNotes_TargetInfo_Proceed.inf1, MapNotes_TargetInfo_Proceed.inf2);
    MapNotes_TargetInfo_Proceed = nil;
    GameTooltip:Hide();
  end
end


function MapNotes_Slash_MNMerge(inf2)
  if not MapNotes_TargetInfo_Proceed then

    local x, y = GetPlayerMapPosition('player');

    if x == 0 and y == 0 then
      SetMapToCurrentZone();
      x, y = GetPlayerMapPosition('player');
      if x == 0 and y == 0 then
        MapNotes.StatusPrint(MAPNOTES_QUICKNOTE_NOPOSITION);
        return;
      end
    end

    if not UnitExists('target') then
      MapNotes.StatusPrint(MAPNOTES_MERGE_WARNING);
      return;
    end

    local tstIcon = string.sub(inf2, 1, 2);
    if ( tstIcon ) and ( type(tstIcon) == 'string' ) and ( tstIcon ~= '' ) and ( strfind(tstIcon, '%d%s') ) then
      inf2 = string.sub(inf2, 3);
    else
      tstIcon = nil;
    end

    if not inf2 then
      inf2 = '';
    end

    GameTooltip:Hide();

    GameTooltip:SetOwner(UIParent, 'ANCHOR_CURSOR');
    GameTooltip:SetUnit('target');
    GameTooltip:SetFrameStrata('TOOLTIP');
    GameTooltip:Show();

    MapNotes_TargetInfo_Proceed = {};
    MapNotes_TargetInfo_Proceed.tstIcon = tstIcon;
    MapNotes_TargetInfo_Proceed.inf2 = inf2;
    MapNotes_TargetInfo_Proceed.func = MapNotes_Slash_MNMerge;

  else
    MapNotes_TargetInfo_Proceed.name, MapNotes_TargetInfo_Proceed.inf1 = MapNotes_TargetInfo();
    if MapNotes_TargetInfo_Proceed.tstIcon then
      MapNotes_TargetInfo_Proceed.name = MapNotes_TargetInfo_Proceed.tstIcon .. string.sub(MapNotes_TargetInfo_Proceed.name, 3);
    end
    MapNotes_Slash_QuickNote(MapNotes_TargetInfo_Proceed.name, MapNotes_TargetInfo_Proceed.inf1, MapNotes_TargetInfo_Proceed.inf2, 'true');
    MapNotes_TargetInfo_Proceed = nil;
    GameTooltip:Hide();
  end
end


function MapNotes_TargetInfo()
  local icon = 8;
  local text = UnitName('target');
  local text2 = '';

  if ( text ) and ( text ~= '' ) then
    local unitReact = UnitReaction('player', 'target');
    if unitReact then
      if unitReact < 4 then
        -- hostile, get level, classification, type, and class
        text2 = text2..' '..MN_LEVEL..' '..UnitLevel('target');
        icon = 6;
        if UnitClassification('target') ~= 'normal' then
        text2 = text2..' '..UnitClassification('target');
        end
        text2 = text2..' '..UnitCreatureType('target')..' '..UnitClass('target');
      elseif unitReact == 4 then
        -- neutral, assume critter, use yellow icon
              icon = 5;
      else
        -- add profession
        local profession = GameTooltipTextLeft2:GetText();
        -- set profession to nil if it's the target's level or empty
        if ( profession ) and ( ( strfind(profession, MN_LEVEL) ) or ( profession == '' ) ) then
          profession = nil;
        end
        if profession then
          text2 = text2..' <'..profession..'>';
        end
      end
    end
    text = icon..' '..text;
  else
    text = '';
  end

  return text, text2;
end


function MapNotes_Merge(key, n_id, name, inf1, inf2)
  name = string.sub(name, 3);
  if ( name ) and ( name ~= '' ) then
    local tstIcon = string.sub(name, 1, 2);
    if strfind(tstIcon, '%d%s') then
      name = string.sub(name, 3);
    end

    if not inf1 then
      inf1 = '';
    end
    if not inf2 then
      inf2 = '';
    end

    if strfind( MapNotes_Data_Notes[key][n_id].name, UnitName('target') ) then
      MapNotes.StatusPrint( MAPNOTES_MERGE_DUP..UnitName('target') );
    else
      MapNotes_Data_Notes[key][n_id].name = MapNotes_Data_Notes[key][n_id].name ..' \124\124 '.. name;  -- ' | '
      MapNotes_Data_Notes[key][n_id].inf1 = MapNotes_Data_Notes[key][n_id].inf1 ..' \124\124 '.. inf1;  -- ' | '
      MapNotes_Data_Notes[key][n_id].inf2 = MapNotes_Data_Notes[key][n_id].inf2 ..' \124\124 '.. inf2;  -- ' | '
      MapNotes.StatusPrint( MAPNOTES_MERGED..UnitName('target') );
    end
  end
end


function MapNotes_IterateLandMarks(report)

  local nCreated, nMerged, nSkipped = 0, 0, 0;

  local map = GetMapInfo();
  if not map and GetCurrentMapZone() > 0 then
    return;
  end

  for k = 1, GetNumMapLandmarks() do

    local name, desc, textureIndex, x, y = GetMapLandmarkInfo(k);
    local created = MapNotes_CreateLandMarkNote(name, desc, textureIndex, x, y);

    if created == 'Created' then
      nCreated = nCreated + 1;
    elseif created == 'Merged' then
      nMerged = nMerged + 1;
    else
      nSkipped = nSkipped + 1;
    end
  end

  local tot = nCreated + nMerged;
  if report or tot > 0 then
    local key = MapNotes.MapKey;
    MapNotes.StatusPrint( tot..' '..MAPNOTES_LANDMARKS_NOTIFY..(MapNotes_GetMapDisplayName(key)) );
  end

  MapNotes_MapUpdate();

end


function MapNotes_CreateLandMarkNote(name, desc, textureIndex, x, y)

  -- If the landmark has a non-zero texture index then the game client is already
  -- displaying an icon for it so don't duplicate
  if textureIndex > 0 then return end

  local key = MapNotes.MapKey;
  if not key then return end

  MapNotes_Data_Notes[key] = MapNotes_Data_Notes[key] or {};
  local currentNotes = MapNotes_Data_Notes[key];
  local checknote = MapNotes_CheckNearbyNotes(key, x, y);

  desc = desc or '';

  if checknote then

    if currentNotes[checknote].name == name or strfind( currentNotes[checknote].name, name ) then
      return 'Duplicate';
    else
      currentNotes[checknote].name = currentNotes[checknote].name ..' \124\124 '.. name;  -- ' | '
      currentNotes[checknote].inf1 = currentNotes[checknote].inf1 ..' \124\124 '.. desc;  -- ' | '
      return 'Merged';
    end

  else
    MapNotes_TempNote.Id = #currentNotes + 1;
    currentNotes[MapNotes_TempNote.Id] = currentNotes[MapNotes_TempNote.Id] or {};
    currentNotes[MapNotes_TempNote.Id] = {
      name = name;
      ncol = 7;
      inf1 = '';
      in1c = 6;
      inf2 = '';
      in2c = 0;
      creator = 'MapNotesLandMark';
      icon = 7;
      xPos = x;
      yPos = y;
    };
    return 'Created';
  end

end


function MapNotes_DeleteLandMarks()

  local key = MapNotes.MapKey;
  local currentNotes = MapNotes_Data_Notes[key];

  for i = #currentNotes, 1, -1 do
    if currentNotes[i].creator == 'MapNotesLandMark' then
      MapNotes_DeleteNote(i, key, nil);
    end
  end

  MapNotes_MapUpdate();
end


function MapNotes_Slash_ThottbotLoc(thisParms)
  MapNotes.StatusPrint(MAPNOTES_MINIMAP_COORDS);
  MapNotes.StatusPrint(MAPNOTES_WFC_WARN);
  MapNotes_Slash_MNMiniCoords();
end


function MapNotes_ClearIcons()
  for area, areaNotes in pairs(MapNotes_Data_Notes) do
    for note, noteData in pairs(areaNotes) do
      noteData.customIcon = nil;
    end
  end
end


local totallyMini = nil;
function MapNotes_TotallyMini()
  if totallyMini then
    totallyMini = nil;
  else
    totallyMini = true;
  end
  for area, areaNotes in pairs(MapNotes_Data_Notes) do
    for note, noteData in pairs(areaNotes) do
      noteData.mininote = totallyMini;
    end
  end
end


function MapNotes_ImportDataSet(extData)
  local areas, notes, clashes = 0, 0, 0;
  MapNotes.StatusPrint(MN_STARTED_IMPORTING .. '...');

  if type(extData) == 'table' then
    for extKey, extNotes in pairs(extData) do
      if type(extNotes) == 'table' then
        if not MapNotes_Data_Notes[extKey] then
          extKey = 'WM ' .. extKey;
        end
        if MapNotes_Data_Notes[extKey] then
          local nextNote = #MapNotes_Data_Notes[extKey];
          areas = areas + 1;

          for extNote, extDetails in pairs(extNotes) do
            local checkNearNote = MapNotes_CheckNearbyNotes(extKey, extDetails.xPos, extDetails.yPos);
            if checkNearNote then
              clashes = clashes + 1;

            else
              notes = notes + 1;
              nextNote = nextNote + 1;
              MapNotes_Data_Notes[extKey][nextNote] = extDetails;
            end
          end

        else
          MapNotes.StatusPrint(MN_INVALID_KEY .. extKey);
        end
      end
    end
  end

  MapNotes.StatusPrint('...' .. MN_FINISHED_IMPORTING);
  MapNotes.StatusPrint( format(MN_AREANOTES, areas, notes) );
  MapNotes.StatusPrint(clashes .. ' ' .. MN_DUPS_IGNORED);
end


function MN_InitialiseTextColours(setTextures)

  local textT, inf1T, inf2T;
  local colours = {};

  for i = 0, 9 do

    textT = _G['MN_TextColor'..i..'Texture'];
    inf1T = _G['MN_Info1Color'..i..'Texture'];
    inf2T = _G['MN_Info2Color'..i..'Texture'];

    if setTextures then
      textT:SetTexture('Interface\\AddOns\\MapNotes\\POIIcons\\TextColourTemplate');
      inf1T:SetTexture('Interface\\AddOns\\MapNotes\\POIIcons\\TextColourTemplate');
      inf2T:SetTexture('Interface\\AddOns\\MapNotes\\POIIcons\\TextColourTemplate');
    end

    colours = MapNotes_Colours[i];
    if MapNotes_Options.colourT[1][i] then
      colours = MapNotes_Options.colourT[1][i];
    end
    textT:SetVertexColor(colours.r, colours.g, colours.b);

    colours = MapNotes_Colours[i];
    if MapNotes_Options.colourT[2][i] then
      colours = MapNotes_Options.colourT[2][i];
    end
    inf1T:SetVertexColor(colours.r, colours.g, colours.b);

    colours = MapNotes_Colours[i];
    if MapNotes_Options.colourT[3][i] then
      colours = MapNotes_Options.colourT[3][i];
    end
    inf2T:SetVertexColor(colours.r, colours.g, colours.b);

  end
end


function MN_SetUpColourPicker(row, id)


  ColorPickerFrame.row = row;
  ColorPickerFrame.bttnId = id;
  ColorPickerFrame.hasOpacity = false;
  ColorPickerFrame.func = MN_AcceptColour;
  ColorPickerFrame.cancelFunc = MN_CancelColourPicker;

  local col;
  if MapNotes_Options.colourT[row][id] then
    col = MapNotes_Options.colourT[row][id];
  else
    col = MapNotes_Colours[id];
  end
  ColorPickerFrame.previousValues = {col.r, col.g, col.b};
  ColorPickerFrame:SetFrameStrata('FULLSCREEN_DIALOG');
  ColorPickerFrame.opacity = 1.0;
  ColorPickerFrame:SetColorRGB(col.r, col.g, col.b);
  ColorPickerFrame:Show();
end


function MN_AcceptColour()
  local r, g, b = ColorPickerFrame:GetColorRGB();
  MN_UpdateButtonColour(ColorPickerFrame.row, ColorPickerFrame.bttnId, r, g, b);
end


function MN_CancelColourPicker(cols)
  MN_UpdateButtonColour(ColorPickerFrame.row, ColorPickerFrame.bttnId, cols[1], cols[2], cols[3]);
  ColorPickerFrame.row = nil;
  ColorPickerFrame.bttnId = nil;
end


function MN_UpdateButtonColour(row, id, r, g, b)

  MapNotes_Options.colourT[row] = {};
  MapNotes_Options.colourT[row][id] = {};

  MapNotes_Options.colourT[row][id].r = r;
  MapNotes_Options.colourT[row][id].g = g;
  MapNotes_Options.colourT[row][id].b = b;

  local textureName = format('MN_%sColor%dTexture', select(row, 'Text', 'Info1', 'Info2'), id);
  local texture = _G[textureName];
  assert(texture, format('Texture %s not found', textureName));
  texture:SetVertexColor(r, g, b);

end

MN.AddonMessages = {};
MN.Events = {};

function MapNotes_OnEvent(self, event, ...)

  -- printf('MapNotes_OnEvent(%q, %q)', self:GetName(), event);
  
  local arg1 = ...;
  if arg1 then
    tinsert(MN.Events, format('%s - %s', event, tostring(arg1)));
  elseif event ~= 'WORLD_MAP_UPDATE' then
    tinsert(MN.Events, event);
  end

  if event == 'ADDON_LOADED' then

    local addon = ...;

    if addon == 'libdebug' then
      LibDebug();
    end

    if addon == MAPNOTES_NAME then

      MapNotes_OnLoad(); -- Used to be called by the MapNotesSendFrame OnLoad handler in XML

      MinimapZoomIn:HookScript('OnClick', MapNotes.UpdateMinimapZoom);
      MinimapZoomOut:HookScript('OnClick', MapNotes.UpdateMinimapZoom);
      LibMapData:RegisterCallback('MapChanged', MapNotes.UpdateMapInfo);

      RegisterAddonMessagePrefix('MapNotes');

      local autovivify = function(t, k)
        local v = {};
        t[k] = v;
        return v;
      end

      _G.MapNotes_Data_Notes = _G.MapNotes_Data_Notes or {};
      setmetatable(MapNotes_Data_Notes, { __index = autovivify });

      _G.MapNotes_Data_Lines = _G.MapNotes_Data_Lines or {};
      setmetatable(MapNotes_Data_Lines, { __index = autovivify });

      MapNotes_ResetHighlightsOnLoad();

      MapNotes_AddonLoaded(self);

      _G.MapNotes_Loaded = true;

    end

  elseif event == 'PLAYER_LOGIN' then

    assert(_G.MapNotes_Loaded, 'MapNotes not loaded');

    local mt = getmetatable(_G.MapNotes_Data_Notes);
    assert(mt.__index,'No metatable set for MapNotes_Data_Notes');

    local mt = getmetatable(_G.MapNotes_Data_Lines);
    assert(mt.__index,'No metatable set for MapNotes_Data_Lines');

  elseif event == 'PLAYER_ENTERING_WORLD' then

    -- Trying to do this any earlier results in the metatable being removed
    -- from saved tables.

    MapNotes.UpdateMapInfo();

    _G.MapNotes_Started = true;

  -- LibMapData will only fire our callback when it sees that the current
  -- map or floor have changed. This doesn't happen in some places (notably
  -- the Argent Tournament Pavilions) so we have to force it to fire
  elseif event == 'MINIMAP_UPDATE_ZOOM' or event:match('^ZONE_CHANGED') then

    MapNotes.UpdateMapInfo();

    --LibMapData:ZoneChanged(true);

  elseif event == 'MINIMAP_PING' then

    MapNotes_MinimapPing(self, event, ...);

  elseif event == 'WORLD_MAP_UPDATE' then

    -- if _G.MapNotes_Started and MapNotes_Options.landMarks then
    --   MapNotes_IterateLandMarks(false);
    -- end

    MapNotes.UpdateMapInfo();
    MapNotes_MapUpdate();

  elseif event == 'CHAT_MSG_ADDON' then

    local prefix, message, channel, sender = ...;

    do
      -- printf('CHAT_MSG_ADDON - %q, %q, %q, %q', ...);
      -- printf('CHAT_MSG_ADDON');
      tinsert(MN.AddonMessages, {...});
    end

    if prefix == 'MapNotes' then
      MapNotes_GetNoteFromChat(message, sender);
    end

  end
end


local angleInc = 0.25; -- %%% Fancy Mininote highlighting on the map... instead
-- of the static blue circle background - a circling highlight would be good...

function MN_NoteUpdate(self, elapsed)

  local miniNote = _G[self:GetName() .. 'Mininote'];

  self.timer = self.timer + elapsed;
  if self.timer < 0.05 then return end

--printf('MN_NoteUpdate(%s, %s)', self:GetName(), tostring(elapsed));

  local tt = MapNotes_WorldMapTooltip;

-- Now's the time to update the coordinates in the tooltip if this POI is being dragged

  if tt:IsVisible() and GetMouseFocus() == self then

    local parent = self:GetParent();

    local x, y = self:GetCenter();
    local l, b, w, h = parent:GetRect();
    local t = parent:GetTop();
    x, y = (x - l) / w, (t - y) / h;
    local xy = string.format(MN_COORD_FS[MN_COORD_F], x * 100, y * 100);

    local textName = tt:GetName()..'TextLeft'..tt:NumLines();
    local textReg = _G[textName];
    textReg:SetText(xy);
  end

  self.hAngle = self.hAngle - angleInc;
  self.s = sin(self.hAngle);
  self.c = cos(self.hAngle);
  miniNote:SetTexCoord(
      0.5-self.s, 0.5+self.c,
      0.5+self.c, 0.5+self.s,
      0.5-self.c, 0.5-self.s,
      0.5+self.s, 0.5-self.c);

  self.timer = 0;

end


-- This function is called when the mouse pointer enters either the World Map or
-- Minimap notes - MapNotesPOIn or MN_MiniNotesPOIn

function MN_NoteOnEnter(note)
--printf('function MN_NoteOnEnter(%s)', note:GetName());

  local key, id = note.key, note.nid;
  local Plugin = MapNotes.pluginKeys[key];
  local loc, lLoc = MapNotes_GetMapDisplayName(key, Plugin);
  local pFrame = note:GetParent();

  local tt;
  if pFrame == WorldMapButton then
    tt = MapNotes_WorldMapTooltip;
  else
    tt = GameTooltip;
  end

  local x, y = note:GetCenter();
  local x2, y2 = pFrame:GetCenter();
  local anchor;
  if x > x2 then
    anchor = 'ANCHOR_LEFT';
  else
    anchor = 'ANCHOR_RIGHT';
  end

  tt:SetOwner(note, anchor);

  if id == 0 then -- Thottbot Note

    if MapNotes_tloc_name then
      tt:AddLine(MapNotes_tloc_name);
    else
      tt:AddLine(MAPNOTES_THOTTBOTLOC);
    end

    if lLoc then
      tt:AddLine(lLoc, 1, 1, 1);
    end

    local x, y = MapNotes_tloc_xPos * 100, MapNotes_tloc_yPos * 100;
    local xy = string.format(MN_COORD_FS[MN_COORD_F], x, y);
    tt:AddLine(xy, 0, 1, 0);

    MN_TestTexture:SetTexture( MN_TLOC_ICON );
    local t = MN_TestTexture:GetTexture();
    if not t then
      t = MAPNOTES_PATH..'POIIcons\\Icontloc';
    end
    tt:AddTexture( t );
    tt:Show();

  elseif id == -1 then -- Party Note

    tt:AddLine(MAPNOTES_PARTYNOTE);

    if lLoc then
      tt:AddLine(lLoc, 1, 1, 1);
    end

    local x, y = MapNotes_PartyNoteData.xPos * 100, MapNotes_PartyNoteData.yPos * 100;
    local xy = string.format(MN_COORD_FS[MN_COORD_F], x, y);
    tt:AddLine(xy, 0, 1, 0);

    MN_TestTexture:SetTexture( MN_PARTY_ICON );
    local t = MN_TestTexture:GetTexture();
    if not t then
      t = MAPNOTES_PATH..'POIIcons\\Iconparty';
    end
    tt:AddTexture( t );
    tt:Show();

  else -- Normal Map Notes

    local noteDetails = MapNotes_Data_Notes[key][id];

    local cRef = noteDetails.ncol;
    local colours = MapNotes_Options.colourT[1][cRef] or MapNotes_Colours[cRef];
    tt:AddLine(noteDetails.name, colours.r, colours.g, colours.b);

    if noteDetails.inf1 ~= nil and noteDetails.inf1 ~= '' then
      cRef = noteDetails.in1c;
      colours = MapNotes_Options.colourT[2][cRef] or MapNotes_Colours[cRef];
      tt:AddLine(noteDetails.inf1, colours.r, colours.g, colours.b);
    end

    if noteDetails.inf2 ~= nil and noteDetails.inf2 ~= '' then
      cRef = noteDetails.in2c;
      colours = MapNotes_Options.colourT[3][cRef] or MapNotes_Colours[cRef];
      tt:AddLine(noteDetails.inf2, colours.r, colours.g, colours.b);
    end

    if noteDetails.creator and noteDetails.creator ~= '' then
      tt:AddDoubleLine(MAPNOTES_CREATEDBY, noteDetails.creator, 0.79, 0.69, 0.0, 0.79, 0.69, 0.0)
    end

    if lLoc then
      tt:AddLine(lLoc, 1, 1, 1);
    end

    local x, y = noteDetails.xPos * 100, noteDetails.yPos * 100;
    local xy = string.format(MN_COORD_FS[MN_COORD_F], x, y);
    tt:AddLine(xy, 0, 1, 0);

    local t = noteDetails.customIcon;
    MN_TestTexture:SetTexture(nil);
    if MNIL and t then
      MN_TestTexture:SetTexture(t);
    end

    if not (MN_TestTexture:GetTexture()) then
      t = MAPNOTES_PATH..'POIIcons\\Icon'..noteDetails.icon;
    end
    tt:AddTexture(t);

    tt:SetFrameStrata('TOOLTIP');
    tt:SetFrameLevel(note:GetFrameLevel() + 2);
    tt:Show();
  end
end

-- Dynamic frame creation
do
  local frame = CreateFrame('Button', 'MapNotes_WorldMapButton', WorldMapButton);
  frame:SetAllPoints(WorldMapButton);
  frame:RegisterForClicks('LeftButtonDown', 'RightButtonDown');

  frame:SetScript('OnShow', function()
    local index = 1;
    local note = _G['MapNotesPOI' .. index];
    local targetLevel = MapNotes_WorldMapButton:GetFrameLevel() + 1;

    while ( note ) do
      -- Should probably break out of here early if not Visible...      -- 29/07/2007
      note:SetFrameLevel( targetLevel );
      index = index + 1;
      note = _G['MapNotesPOI' .. index];
    end

    MapNotesPOItloc:SetFrameLevel( targetLevel );   -- 29/07/2007
    MapNotesPOIparty:SetFrameLevel( targetLevel );    -- 29/07/2007
  end);

  frame:SetScript('OnClick', function(self, button, down)
--printf('>> MapNotes_WorldMapButton_OnClick(%s, %s, %s)', WorldMapButton:GetName(), tostring(button), tostring(down));

    MapNotes_WorldMapButton_OnClick(WorldMapButton, button, down);

  end);
  frame:Hide();
end

do
  local tooltip = CreateFrame('GameTooltip', 'MapNotes_WorldMapTooltip', WorldMapFrame, 'GameTooltipTemplate');
  tooltip:SetFrameStrata('TOOLTIP');
  tooltip:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
  tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
  tooltip:Hide();
end

do
  local frame = CreateFrame('Frame', 'MapNotes_EventFrame');

	frame:CreateTexture('MN_TestTexture', 'BACKGROUND');

  frame:SetScript('OnEvent', MapNotes_OnEvent);
  frame:SetScript('OnUpdate', MapNotes_OnUpdate);

  frame:RegisterEvent('ADDON_LOADED');
  frame:RegisterEvent('PLAYER_LOGIN');
  frame:RegisterEvent('PLAYER_ENTERING_WORLD');
  frame:RegisterEvent('PLAYER_ALIVE');

  frame:RegisterEvent('MINIMAP_UPDATE_ZOOM');
  frame:RegisterEvent('ZONE_CHANGED');
  frame:RegisterEvent('ZONE_CHANGED_NEW_AREA');
  frame:RegisterEvent('ZONE_CHANGED_INDOORS');
  frame:RegisterEvent('MINIMAP_PING');
  frame:RegisterEvent('WORLD_MAP_UPDATE');
  frame:RegisterEvent('CHAT_MSG_ADDON');

  --[[]
  watchFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
  watchFrame:RegisterEvent('ZONE_CHANGED')
  watchFrame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
  watchFrame:RegisterEvent('ZONE_CHANGED_INDOORS')
  --]]


end

do
  local frame = CreateFrame('Frame', nil, WorldMapFrame);
  frame:Show();
  frame:SetScript('OnUpdate', MapNotes_WorldMap_OnUpdate);
  frame:SetScript('OnShow',
    function(frame)
      frame.oTimer = 0;
    end
  );
end

do
  CreateFrame('Frame', 'MapNotesLinesFrame', WorldMapDetailFrame);
end


