--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.
]]

-- Generic Dialogues for getting mass delete criteria
StaticPopupDialogs.MN_DELETE_FILTER = {

  text = TEXT("___"),
  button1 = ACCEPT,
  button2 = CANCEL,
  hasEditBox = 1,
  maxLetters = 28,
  whileDead = true,
  hideOnEscape = true,
  --sound = 'igPlayerInvite',

  OnShow = function(self)
    _G[self:GetName().."Text"]:SetText( MN_DELETE_TITLE_TEXT );
  end,

  OnAccept = function(self, data)
    local name = self:GetName();
    local del = _G[name.."EditBox"]:GetText();
    if del and del ~= "" then
      if MapNotes.delFilter.type == "text" then
        MapNotes_DeleteNotesWithText(del, MapNotes.delFilter.key);
      elseif MapNotes.delFilter.type == "creator" then
        MapNotes.DeleteNotesByCreatorAndName(del, nil, MapNotes.delFilter.key);
      end
      self:Hide();
    end
  end,

  EditBoxOnEnterPressed = function(self)
    local parent = self:GetParent();
    local del = _G[parent:GetName().."EditBox"]:GetText();
    if del and del ~= "" then
      if MapNotes.delFilter.type == "text" then
        MapNotes_DeleteNotesWithText(del, MapNotes.delFilter.key);
      elseif MapNotes.delFilter.type == "creator" then
        MapNotes.DeleteNotesByCreatorAndName(del, nil, MapNotes.delFilter.key);
      end
      parent:Hide();
    end
  end,

  EditBoxOnEscapePressed = function(self)
    self:GetParent():Hide();
  end,

  OnHide = function(self)
    MapNotes.delFilter = nil;
  end,

  timeout = 0,
  hideOnEscape = 1,
};


local addonName, addonTable = ...;

_G.MapNotes = addonTable;
MapNotes.AddonName = addonName;

setmetatable(MapNotes, { __index = _G } );

_G.MN = MapNotes;

-- Drop Down Menu stuff
-- NOTE This makes MapNotes.DropDown a synonym for the dropdown frame MapNotes_DropDown
-- The frame is used to hold auxiliary fields key, id, x, y, pFrame, info

MapNotes.DropDown = CreateFrame("Frame", "MapNotes_DropDown", nil, "UIDropDownMenuTemplate");

MapNotes.pluginKeys = {};

MapNotes.scaleFrames = {
  [1] = MapNotesOptionsFrame,
  [2] = MapNotesEditFrame,
  [3] = MapNotesSendFrame,
};


function MapNotes.PointyPointyPointy()

  local text, ignore = MN_WAYPOINT, true;

  MapNotes.pointy = nil;
  MapNotes.pointyP = {};

  local Plugin = MapNotes.pluginKeys[ MapNotes.DropDown.key ];
  if not Plugin or Plugin.wmflag then

    local note = MapNotes_Data_Notes[MapNotes.DropDown.key];
    if note then
      note = note[MapNotes.DropDown.id];
      if note then
        if PointyPointy then    -- in development
          MapNotes.pointy = PP.Set;
          MapNotes.pointyP[1] = MapNotes.DropDown.key;
          MapNotes.pointyP[2] = MapNotes.DropDown.id;
          MapNotes.pointyP[3] = MapNotes.DropDown.x;
          MapNotes.pointyP[4] = MapNotes.DropDown.y;
          text = "PointyPointy";
          ignore = nil;

        elseif Cartographer_Waypoints and type(Cartographer_Waypoints.AddLHWaypoint) == "function" then
          MapNotes.pointy = Cartographer_Waypoints.AddLHWaypoint;
          local c, z = MapNotes_Keys[MapNotes.DropDown.key].c, MapNotes_Keys[MapNotes.DropDown.key].z;
          if c and z then
            MapNotes.pointyP[1] = Cartographer_Waypoints;
            MapNotes.pointyP[2] = c;
            MapNotes.pointyP[3] = z;
            MapNotes.pointyP[4] = MapNotes.DropDown.x;
            MapNotes.pointyP[5] = MapNotes.DropDown.y;
            MapNotes.pointyP[6] = note.name;
            text = "Cartographer: "..MN_WAYPOINT;
            ignore = nil;
          end

        elseif TomTom then
          MapNotes.pointy = TomTom.AddZWaypoint;
          local c, z = MapNotes_Keys[MapNotes.DropDown.key].c, MapNotes_Keys[MapNotes.DropDown.key].z;
          if c and z then
            MapNotes.pointyP[1] = TomTom; -- pass 'self' as first parameter
            MapNotes.pointyP[2] = c;
            MapNotes.pointyP[3] = z;
            MapNotes.pointyP[4] = MapNotes.DropDown.x*100;
            MapNotes.pointyP[5] = MapNotes.DropDown.y*100;
            MapNotes.pointyP[6] = note.name;
            text = "TomTom: "..MN_WAYPOINT;
            ignore = nil;
          end
        end
      end
    end
  end

  return text, nil, nil, ignore;

end


local function MN_Wasted()
  if MapNotes_Undelete_Info and MapNotes_Undelete_Info.key then
    return;
  else
    return nil, nil, true;
  end
end


local function MN_Copied()
  if MapNotes.clipBoard then
    return;
  else
    return nil, nil, true;
  end
end


local function MN_Copy(andCut)
  -- only route is through DropDown menus and that is where the information is stored
  local note = MapNotes_Data_Notes[MapNotes.DropDown.key];
  if note then
    note = note[MapNotes.DropDown.id];
    if note then
      MapNotes.clipBoard = {};
      -- Now,
      --  we are NOT copying the specific ID; Nor are we copying the x or y value of the note - ONLY the text, colours, and icon
      --  if pasted in the future, a new ID will be assigned, and x and y will depend on where it has been pasted (needless to say the key will also be determined at that time)
      -- also going to allow the creator to change based on who is doing the pasting...
      MapNotes.clipBoard.name     = note.name;
      MapNotes.clipBoard.ncol     = note.ncol;
      MapNotes.clipBoard.inf1     = note.inf1;
      MapNotes.clipBoard.in1c     = note.in1c;
      MapNotes.clipBoard.inf2     = note.inf2;
      MapNotes.clipBoard.in2c     = note.in2c;
      MapNotes.clipBoard.icon     = note.icon;
      MapNotes.clipBoard.mininote   = note.mininote;
      MapNotes.clipBoard.customIcon   = note.customIcon;

      -- if Cutting a note, then we now also need to delete it
      if andCut then
        MapNotes_DeleteNote(MapNotes.DropDown.id, MapNotes.DropDown.key);
      end
    end
  end
end

local function MN_Paste()

  if not MapNotes.clipBoard then return end

  MapNotes_HideAll();

  local key, x, y = MapNotes.DropDown.key, MapNotes.DropDown.x, MapNotes.DropDown.y;
  local currentNotes = MapNotes_Data_Notes[key];

  local checknote = MapNotes_CheckNearbyNotes(key, x, y);
  if checknote then
    MapNotes.StatusPrint(format(MAPNOTES_QUICKNOTE_NOTETOONEAR, currentNotes[checknote].name ) );
    return;
  end

  local Plugin = MapNotes.pluginKeys[key];
  local nid = #currentNotes + 1;
  MapNotes_TempNote.Id = nid;

  currentNotes[nid] = {
    name        = MapNotes.clipBoard.name;
    ncol        = MapNotes.clipBoard.ncol;
    inf1        = MapNotes.clipBoard.inf1;
    in1c        = MapNotes.clipBoard.in1c;
    inf2        = MapNotes.clipBoard.inf2;
    in2c        = MapNotes.clipBoard.in2c;
    icon        = MapNotes.clipBoard.icon;
    mininote    = MapNotes.clipBoard.mininote;
    customIcon  = MapNotes.clipBoard.customIcon;
    xPos        = MapNotes.DropDown.x;
    yPos        = MapNotes.DropDown.y;
    creator     = UnitName("player");
  };

  if Plugin then
    MapNotes_PlugInsDrawNotes(Plugin);
  else
    MapNotes_MapUpdate();
  end

  MapNotes.StatusPrint( format(MAPNOTES_ACCEPT_SLASH, MapNotes_GetMapDisplayName(key, Plugin)) );

end


local function MN_Status()
  if MapNotes_Options.shownotes then
    return MAPNOTES_SHOWNOTES, true;
  else
    return MAPNOTES_SHOWNOTES;
  end
end

--[[
  The following drop-down data structures are declared here:

      MapNotes.base_dd_info
        ctrl-rightclick on WorldMapButton
        rightclick on plugin MapNotes overlay frame
        modified by MapNotesBrowser to append 'MapNotes Browser' option

      MapNotes.mininote_dd_info
        ctrl-rightclick or ctrl-shift-rightclick on minimap notes - normal or party/tloc
        rightclick on one of the MapNotes Browser scroll buttons (each list item is a scroll button)

      MapNotes.note_dd_info
        rightclick without alt on WorldMap note

      MapNotes.temp_dd_info
        rightclick on party/tloc note on World Map with anything except alt or shift alone or with ctrl

      MapNotes.coords_dd_info
        any click on the minimap coords frame
--]]

MapNotes.base_dd_info = {
  -- Define level one elements here
  [1] = {
    { -- Title
      text = MAPNOTES_NAME,
      isTitle = 1,
    },
    { -- Create new note
      text = MAPNOTES_NEW_NOTE,
      func = function()
        MapNotesEditFrame:SetParent(MapNotes.DropDown.pFrame);
        MapNotes_TempNote.xPos = MapNotes.DropDown.x;
        MapNotes_TempNote.yPos = MapNotes.DropDown.y;
        MapNotes_TempNote.Id = nil;
        MapNotesEditFrame.k = MapNotes.DropDown.key;
        MapNotesEditFrame.miniMe = IsControlKeyDown();
        MapNotes_OpenEditForNewNote();
      end,
      tooltipTitle = MN_TT_MINITITLE;
      tooltipText = MN_TT_MINITEXT;
    },
    { -- QuickNote for quick creation without editing
      text = MAPNOTES_QUICKNOTE_DEFAULTNAME,
      func = function()
        local Plugin = MapNotes.pluginKeys[ MapNotes.DropDown.key ];
        local lNote = MapNotes_ShortCutNote(MapNotes.DropDown.x, MapNotes.DropDown.y, Plugin, IsControlKeyDown(), MapNotes.DropDown.key);
        if not Plugin or Plugin.wmflag then
          MapNotes_MapUpdate();
        else
          MapNotes_PlugInsDrawNotes(Plugin);
        end
        if lNote then
          lNote = _G["MapNotesPOI" .. lNote];
          if lNote then
            lNote:SetFrameLevel( MapNotes.DropDown.pFrame:GetFrameLevel() + 1 );
          end
        end
      end,
      tooltipTitle = MN_TT_MINITITLE;
      tooltipText = MN_TT_MINITEXT;
    },
    { -- Group Note
      text = MAPNOTES_PARTYNOTE,
      func = function()
        MapNotes_SetPartyNote(MapNotes.DropDown.x, MapNotes.DropDown.y);
        MapNotes_MapUpdate();
      end,
    },
    { -- Special Actions
      text = MAPNOTES_SPECIAL_ACTIONS,
      hasArrow = true,
      value = "special",
    },
    { -- Mass Delete Options
      text = MN_MDELETE,
      hasArrow = true,
      value = "delete",
    },
    { -- Options
      text = MAPNOTES_OPTIONS,
      func = function()
        MapNotes_HideAll();
        MapNotesOptionsFrame:SetParent(MapNotes.DropDown.pFrame);
        local pScale = MapNotes.DropDown.pFrame:GetEffectiveScale();
        MapNotesOptionsFrame:SetScale( 0.8 / pScale );
        MapNotesOptionsFrame:Show();
        MapNotesOptionsFrame:SetAlpha(1);
      end,
    },
    { -- Cancel
      text = CANCEL,
      func = function()
        HideDropDownMenu(1);
      end,
    },
  },
  [2] = {
    special = {
      { -- Show (/Hide) All MapNotes
        dynamicFunc = MN_Status,
        func = function()
          if MapNotes_Options.shownotes then
            MapNotes_Options.shownotes = false;
          else
            MapNotes_Options.shownotes = true;
          end
          HideDropDownMenu(1);
          local Plugin = MapNotes.pluginKeys[ MapNotes.DropDown.key ];
          if not Plugin or Plugin.wmflag then
            MapNotes_MapUpdate();
          else
            MapNotes_PlugInsDrawNotes(Plugin);
          end
        end
      },
      { -- Paste a Copied/Cut note
        dynamicFunc = MN_Copied,
        text = MN_PASTE,
        func = function()
          MN_Paste();
          HideDropDownMenu(1);
        end,
      },
      { -- Undelete if possible...
        dynamicFunc = MN_Wasted,
        text = MAPNOTES_CHAT_COMMAND_UNDELETE,
        func = function()
          MapNotes_Undelete();
          HideDropDownMenu(1);
        end
      },
    },
    delete = {
      { -- containing Text
        text = MN_TEXT,
        func = function()
          local lName = MapNotes_GetMapDisplayName(MapNotes.DropDown.key);
          MN_DELETE_TITLE_TEXT = MN_MDELETE .. MN_TEXT .. " (" .. lName .. ")";
          MapNotes.delFilter = {};
          MapNotes.delFilter.type = "text";
          MapNotes.delFilter.key = MapNotes.DropDown.key;
          StaticPopup_Show("MN_DELETE_FILTER");
          HideDropDownMenu(1);
        end,
      },
      { -- by Creator
        text = MN_CREATOR,
        func = function()
          local lName = MapNotes_GetMapDisplayName(MapNotes.DropDown.key);
          MN_DELETE_TITLE_TEXT = MN_MDELETE .. MN_CREATOR .. " (" .. lName .. ")";
          MapNotes.delFilter = {};
          MapNotes.delFilter.type = "creator";
          MapNotes.delFilter.key = MapNotes.DropDown.key;
          StaticPopup_Show("MN_DELETE_FILTER");
          HideDropDownMenu(1);
        end,
      },
    },
  },
};

local function MN_GetMiniNoteToggleText()
  if string.find(MapNotes.DropDown.key, "^WM %a+") then
    if not MapNotes.DropDown.id then
      return nil, nil, true, nil;

    elseif MapNotes.DropDown.id == 0 then
      if MapNotes_MiniNote_Data.icon == "tloc" then
        return MAPNOTES_MININOTE_OFF;
      else
        return MAPNOTES_MININOTE_ON;
      end

    elseif MapNotes.DropDown.id == -1 then
      if MapNotes_MiniNote_Data.icon == "party" then
        return MAPNOTES_MININOTE_OFF;
      else
        return MAPNOTES_MININOTE_ON;
      end

    elseif MapNotes_Data_Notes[MapNotes.DropDown.key][MapNotes.DropDown.id].mininote then
      return MAPNOTES_MININOTE_OFF;

    else
      return MAPNOTES_MININOTE_ON;
    end

  else
    return nil, nil, nil, true;
  end
end


MapNotes.mininote_dd_info = {
  -- Define level one elements here
  [1] = {
    { -- Title
      text = MAPNOTES_NAME,
      isTitle = 1,
    },
    { -- Edit Note
      text = MAPNOTES_EDIT_NOTE,
      func = function()
        MapNotesEditFrame.k = MapNotes.DropDown.key;
        MapNotes_OpenEditForExistingNote(MapNotes.DropDown.key, MapNotes.DropDown.id);
      end,
    },
    { -- Delete Note
      text = MAPNOTES_DELETE_NOTE,
      func = function()
        MapNotes_DeleteNote(MapNotes.DropDown.id, MapNotes.DropDown.key);
      end,
    },
    { -- Mininote Toggle
      text = nil,
      dynamicFunc = MN_GetMiniNoteToggleText;
      func = function()
        if not MapNotes.DropDown.id then
          -- Doh !!!

        elseif MapNotes_Data_Notes[MapNotes.DropDown.key][MapNotes.DropDown.id].mininote then
          local note = {};
          note.key = MapNotes.DropDown.key
          note.id  = MapNotes.DropDown.id;
          MapNotes_ClearMiniNote(nil, note);
        else
          MapNotes_SetAsMiniNote(MapNotes.DropDown.id);
        end
      end,
    },
    { -- PointyPointy
      text = MN_WAYPOINT,
      dynamicFunc = MapNotes.PointyPointyPointy;
      func = function()
        MapNotes.pointy( unpack(MapNotes.pointyP) );
      end,
    },
    { -- Options
      text = MAPNOTES_OPTIONS,
      func = function()
        MapNotes_HideAll();
        MapNotesOptionsFrame:SetParent(MapNotes.DropDown.pFrame);
        local pScale = MapNotes.DropDown.pFrame:GetEffectiveScale();
        MapNotesOptionsFrame:SetScale( 0.8 / pScale );
        MapNotesOptionsFrame:Show();
        MapNotesOptionsFrame:SetAlpha(1);
      end,
    },
    { -- Cancel
      text = CANCEL,
      func = function()
        HideDropDownMenu(1);
      end,
    },
  },
};

MapNotes.note_dd_info = {
  -- Define level one elements here
  [1] = {
    { -- Title
      text = MAPNOTES_NAME,
      isTitle = 1,
    },
    {
      -- Edit Note
      text = MAPNOTES_EDIT_NOTE,
      func = function()
        MapNotesEditFrame.k = MapNotes.DropDown.key;
        MapNotes_OpenEditForExistingNote(MapNotes.DropDown.key, MapNotes.DropDown.id);
      end,
    },
    {
      -- Delete Note
      text = MAPNOTES_DELETE_NOTE,
      func = function()
        MapNotes_DeleteNote(MapNotes.DropDown.id, MapNotes.DropDown.key);
      end,
    },
    { -- Mininote Toggle
      text = nil,
      dynamicFunc = MN_GetMiniNoteToggleText;
      func = function()
        if not MapNotes.DropDown.id then
          -- Doh !!!

        elseif MapNotes_Data_Notes[MapNotes.DropDown.key][MapNotes.DropDown.id].mininote then
          local note = {};
          note.key = MapNotes.DropDown.key
          note.id  = MapNotes.DropDown.id;
          MapNotes_ClearMiniNote(nil, note);
        else
          MapNotes_SetAsMiniNote(MapNotes.DropDown.id);
        end
      end,
    },
    { -- PointyPointy
      text = MN_WAYPOINT,
      dynamicFunc = MapNotes.PointyPointyPointy;
      func = function()
        MapNotes.pointy( unpack(MapNotes.pointyP) );
      end,
    },
    { -- Special Actions
      text = MAPNOTES_SPECIAL_ACTIONS,
      hasArrow = true,
      value = "special",
    },
    { -- Send to ...
      text = MAPNOTES_SEND_NOTE;
      hasArrow = true,
      value = "send",
    },
    { -- Options
      text = MAPNOTES_OPTIONS,
      func = function()
        MapNotes_HideAll();
        MapNotesOptionsFrame:SetParent(MapNotes.DropDown.pFrame);
        local pScale = MapNotes.DropDown.pFrame:GetEffectiveScale();
        MapNotesOptionsFrame:SetScale( 0.8 / pScale );
        MapNotesOptionsFrame:Show();
        MapNotesOptionsFrame:SetAlpha(1);
      end,
    },
    { -- Cancel
      text = CANCEL,
      func = function()
        HideDropDownMenu(1);
      end,
    },
  },
  [2] = {
    special = {
      { -- Cut Note
        text = MN_CUT,
        func = function()
          -- have to write this functionality
          MN_Copy(true);
          HideDropDownMenu(1);
        end,
      },
      { -- Copy Note
        text = MN_COPY,
        func = function()
          -- have to write this functionality
          MN_Copy();
          HideDropDownMenu(1);
        end,
      },
      { -- Draw... from/to?
        text = MAPNOTES_TOGGLELINE,
        func = function()
          -- printf('ToggleLine - key %q', MapNotes.DropDown.key);
          MapNotes_StartGUIToggleLine(MapNotes.DropDown.key, MapNotes.DropDown.id);
          HideDropDownMenu(1);
        end,
      },
    },
    send = {
      { -- Whisper
        text = WHISPER .. " / " .. MAPNOTES_SEND_SLASHTITLE,
        func = function()
          MapNotesSendFrame.key = MapNotes.DropDown.key;
          MapNotes_ShowSendFrame(1);
          HideDropDownMenu(1);
        end,
      },
      { -- Party
        text = PARTY,
        func = function()
          MapNotesSendFrame.key = MapNotes.DropDown.key;
          MapNotes_SendNote(2);
          HideDropDownMenu(1);
        end
      },
      { -- Raid
        text = RAID,
        func = function()
          MapNotesSendFrame.key = MapNotes.DropDown.key;
          MapNotes_SendNote(3);
          HideDropDownMenu(1);
        end
      },
      { -- Battleground
        text = BATTLEGROUND,
        func = function()
          MapNotesSendFrame.key = MapNotes.DropDown.key;
          MapNotes_SendNote(4);
          HideDropDownMenu(1);
        end
      },
      { -- Guild
        text = GUILD,
        func = function()
          MapNotesSendFrame.key = MapNotes.DropDown.key;
          MapNotes_SendNote(5);
          HideDropDownMenu(1);
        end
      },
    },
  },
};

MapNotes.temp_dd_info = {
  -- Define level one elements here
  [1] = {
    { -- Title
      text = MAPNOTES_NAME,
      isTitle = 1,
    },
    { -- Convert to Permanent Note without opening Edit Frame... i.e. delete temporary, and create quick note(?)
      text = MN_CONVERT,
      func = function()
        local Plugin = MapNotes_DeleteNote(MapNotes.DropDown.id, MapNotes.DropDown.key, true);
        local storeN = MAPNOTES_QUICKNOTE_DEFAULTNAME;
        if MapNotes.DropDown.id == 0 then
          MAPNOTES_QUICKNOTE_DEFAULTNAME = tostring(MAPNOTES_THOTTBOTLOC );
        elseif MapNotes.DropDown.id == -1 then
          MAPNOTES_QUICKNOTE_DEFAULTNAME = tostring(MAPNOTES_PARTYNOTE);
        end

        local lNote = MapNotes_ShortCutNote(MapNotes.DropDown.x, MapNotes.DropDown.y, Plugin, true, MapNotes.DropDown.key);
        if not Plugin or Plugin.wmflag then
          MapNotes_MapUpdate();
        else
          MapNotes_PlugInsDrawNotes(Plugin);
        end
        if lNote then
          lNote = _G["MapNotesPOI" .. lNote];
          if lNote then
            lNote:SetFrameLevel( MapNotes.DropDown.pFrame:GetFrameLevel() + 1 );
          end
        end

        MAPNOTES_QUICKNOTE_DEFAULTNAME = storeN;
      end,
    },
    { -- Toggle as Mininote
      text = nil,
      dynamicFunc = MN_GetMiniNoteToggleText;
      func = function()
        if not MapNotes.DropDown.id then
          -- Doh !!!

        elseif MapNotes.DropDown.id == 0 then
          if MapNotes_MiniNote_Data.icon == "tloc" then
            MapNotes_ClearMiniNote(nil, "tloc");
          else
            MapNotes_SetAsMiniNote(0);
          end

        elseif MapNotes.DropDown.id == -1 then
          if MapNotes_MiniNote_Data.icon == "party" then
            MapNotes_ClearMiniNote(nil, "party");
          else
            MapNotes_SetAsMiniNote(-1);
          end
        end
      end,
    },
    { -- PointyPointy
      text = MN_WAYPOINT,
      dynamicFunc = MapNotes.PointyPointyPointy;
      func = function()
        MapNotes.pointy( unpack(MapNotes.pointyP) );
      end,
    },
    { -- Delete
      text = MAPNOTES_DELETE_NOTE,
      func = function()
        MapNotes_DeleteNote(MapNotes.DropDown.id, MapNotes.DropDown.key);
      end,
    },
    { -- Options
      text = MAPNOTES_OPTIONS,
      func = function()
        MapNotes_HideAll();
        MapNotesOptionsFrame:SetParent(MapNotes.DropDown.pFrame);
        local pScale = MapNotes.DropDown.pFrame:GetEffectiveScale();
        MapNotesOptionsFrame:SetScale( 0.8 / pScale );
        MapNotesOptionsFrame:Show();
        MapNotesOptionsFrame:SetAlpha(1);
      end,
    },
    { -- Cancel
      text = CANCEL,
      func = function()
        HideDropDownMenu(1);
      end,
    },
  },
};

MapNotes.coords_dd_info = {
  -- Define level one elements here
  [1] = {
    { -- Title
      text = MAPNOTES_NAME,
      isTitle = 1,
    },
    { -- Quick Note
      text = MAPNOTES_QUICKNOTE_DEFAULTNAME,
      func = function()
        MapNotes_Slash_QuickNote(nil, nil, nil, nil, IsControlKeyDown());
      end,
      tooltipTitle = MN_TT_MINITITLE;
      tooltipText = MN_TT_MINITEXT;
    },
    { -- Target Note
      text = BINDING_NAME_MN_TARGET_NEW,
      func = function()
        MapNotes_Slash_MNTarget("");
      end,
      tooltipTitle = MN_TT_MINITITLE;
      tooltipText = MN_TT_MINITEXT;
    },
    { -- Merge Note
      text = BINDING_NAME_MN_TARGET_MERGE,
      func = function()
        MapNotes_Slash_MNMerge("");
      end,
      tooltipTitle = MN_TT_MINITITLE;
      tooltipText = MN_TT_MINITEXT;
    },
    { -- Undelete if possible...
      dynamicFunc = MN_Wasted,
      text = MAPNOTES_CHAT_COMMAND_UNDELETE,
      func = function()
        MapNotes_Undelete();
        HideDropDownMenu(1);
      end,
    },
    { -- Mass Delete Options
      text = MN_MDELETE,
      hasArrow = true,
      value = "delete",
    },
    { -- Options
      text = MAPNOTES_OPTIONS,
      func = function()
        MapNotes_HideAll();
        MapNotesOptionsFrame:SetParent(MapNotes.DropDown.pFrame);
        local pScale = MapNotes.DropDown.pFrame:GetEffectiveScale();
        MapNotesOptionsFrame:SetScale( 0.8 / pScale );
        MapNotesOptionsFrame:Show();
        MapNotesOptionsFrame:SetAlpha(1);
      end,
    },
    { -- Cancel
      text = CANCEL,
      func = function()
        HideDropDownMenu(1);
      end,
    },
  },
  [2] = {
    delete = {
      { -- containing Text
        text = MN_TEXT,
        func = function()
          MN_DELETE_TITLE_TEXT = MN_MDELETE .. MN_TEXT .. " (" .. MN_ALLZONES .. ")";
          MapNotes.delFilter = {};
          MapNotes.delFilter.type = "text";
          StaticPopup_Show("MN_DELETE_FILTER");
          HideDropDownMenu(1);
        end,
      },
      { -- by Creator
        text = MN_CREATOR,
        func = function()
          MN_DELETE_TITLE_TEXT = MN_MDELETE .. MN_CREATOR .. " (" .. MN_ALLZONES .. ")";
          MapNotes.delFilter = {};
          MapNotes.delFilter.type = "creator";
          StaticPopup_Show("MN_DELETE_FILTER");
          HideDropDownMenu(1);
        end,
      },
    },
  },
};


local function MN_Init_DD(self, level)
  -- Make sure level is set to 1, if not supplied
  level = level or 1

  -- Get the current level from the info table
  local info = MapNotes.DropDown.info[level]

  -- If a value has been set, try to find it at the current level
  if level > 1 and UIDROPDOWNMENU_MENU_VALUE then
    if info[UIDROPDOWNMENU_MENU_VALUE] then
      info = info[UIDROPDOWNMENU_MENU_VALUE]
    end
  end

  -- Add the buttons to the menu
  for idx, entry in ipairs(info) do
    if entry.dynamicFunc then
      local text, checked, disabled, ignore = entry.dynamicFunc();
      if text then entry.text = text; end
      entry.checked = checked;
      entry.disabled = disabled;
      if ignore then entry.text = nil; end
    else
      entry.checked = nil;
    end

    if entry.text then
      UIDropDownMenu_AddButton(entry, level);
    end
  end
end

function MapNotes:InitialiseDropdown(pFrame, x, y, info, key, id)
  MapNotes.DropDown.pFrame = pFrame;
  MapNotes.DropDown.x = x;
  MapNotes.DropDown.y = y;
  MapNotes.DropDown.info = info;
  MapNotes.DropDown.key = key;
  MapNotes.DropDown.id = id;
  UIDropDownMenu_Initialize(MapNotes.DropDown, MN_Init_DD, "MENU");
end

-- Purloined from the Astrolabe library

local function MNassert(level,condition,message)
  if not condition then
    error(message,level)
  end
end

function MapNotes.argcheck(value, num, ...)
  MNassert(1, type(num) == "number", "Bad argument #2 to 'argcheck' (number expected, got " .. type(level) .. ")")
  
  for i = 1,select("#", ...) do
    if type(value) == select(i, ...) then return end
  end
  
  local types = strjoin(", ", ...)
  local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
  error(string.format("Bad argument #%d to 'Astrolabe.%s' (%s expected, got %s)", num, name, types, type(value)), 3)
end


if not printf then
  printf = function(...) print(format(...)) end
end

-- Extract x and y coordinates from text with optional comma/space separators allowing for decimal points

function MapNotes_ExtractCoords(data)

  if not (MapNotes_Started) then return end

  local tS, tE, tX, tY = string.find(data, "(%d%d?%.%d*)%.%.*(%d%d?%.%d*)");

  if not (tX and tY) then
    tS, tE, tX, tY = string.find(data, "(%d%d?%.?%d*)[^0-9^%.]+%.*[^0-9^%.]*(%d%d?%.?%d*)");
  end

  if not (tX and tY) then
    tS, tE, tX, tY = string.find(data, "(%d%d?)%.+(%d%d?)");
  end

  if tX and tY then
    tX = tonumber(tX);
    tY = tonumber(tY);
  end

  if tX and tY then
    local restText = string.sub(data, tE + 1);
    if not (restText) then
      restText = "";
    end
    local msgStart = string.find(restText, "%S");
    if msgStart and msgStart < string.len(restText) then
      restText = string.sub(restText, msgStart);
    end
    return tX, tY, restText;
  end

  MapNotes.StatusPrint(MAPNOTES_COORDINATE_FORMATTING_ERROR1);
  MapNotes.StatusPrint(MAPNOTES_COORDINATE_FORMATTING_ERROR2);
  MapNotes.StatusPrint(MAPNOTES_COORDINATE_FORMATTING_ERROR3);

  return nil, nil, nil;
end


-- Telic_1 Functions

function MapNotes_GetAdjustedMapXY(lclFrame, x, y)

  local normalisingFactor;

  if MapNotes_Options and MapNotes_Options.nFactor then
    normalisingFactor = MapNotes_Options.nFactor;
  else
    normalisingFactor = MN_DEFAULT_FRAMESCALE;
  end

  normalisingFactor = normalisingFactor / 100.0;

  local eScale = 1 / (normalisingFactor / lclFrame:GetEffectiveScale());
  local xAdjustment, yAdjustment = 125, 60;
  local width = lclFrame:GetWidth() * eScale;
  local height = lclFrame:GetHeight() * eScale;
  local adjustedX, adjustedY;

  if x and y then
    adjustedX, adjustedY = x, y;
  else
    adjustedX, adjustedY = MapNotes_GetMouseXY(lclFrame);
  end

  local xOff, yOff = 0, 0;

  if adjustedX < 0.5 then
    xOff = xAdjustment;
  else
    xOff = -xAdjustment;
  end

  if adjustedY < 0.5 then
    yOff = -yAdjustment;
  else
    yOff = yAdjustment;
  end

  adjustedX = math.floor(width * adjustedX + xOff);
  adjustedY = math.floor(-height * adjustedY + yOff);

  return adjustedX, adjustedY;

end

function MapNotes_GetMouseXY(lclFrame)

  local width = lclFrame:GetWidth();
  local height = lclFrame:GetHeight();

  local x, y = GetCursorPosition();

  x = x / lclFrame:GetEffectiveScale();
  y = y / lclFrame:GetEffectiveScale();

  local centerX, centerY = lclFrame:GetCenter();

  x = (x - (centerX - (width/2))) / width;
  y = (centerY + (height/2) - y ) / height;

  return x, y;

end



function MapNotes_NormaliseScale(theFrame, toScale)

  local normalisingFactor;

  if MapNotes_Options and MapNotes_Options.nFactor then
    normalisingFactor = MapNotes_Options.nFactor;
  else
    normalisingFactor = MN_DEFAULT_FRAMESCALE;
  end

  normalisingFactor = normalisingFactor / 100.0;

  local anchorFrame = theFrame:GetParent();

  if anchorFrame then

    toScale = toScale or normalisingFactor;

    local eScale = anchorFrame:GetEffectiveScale();
    eScale =  toScale / eScale;
    theFrame:SetScale( eScale );

    return eScale;
  end
end



-- Telic_2 Functions

-- Probably need the ability to create Note Buttons for each AddOn that wants
-- them as won't be able to show MapNotes on the World map and Alpha Map at the
-- same time if they are trying to display the exact same XML components... If
-- Plugin is left nil, then this function can be called to generate the default
-- MapNotes POI buttons Could therefore be used to create them dynamically as
-- needed instead of having a fixed maximum...

function MapNotes_AssignPOI(index, Plugin)
  local POI;

  if Plugin then
    local lclFrame = _G[Plugin.frame];
    local POIname = Plugin.frame..'POI'..index;
    POI = _G[POIname];

    if not POI then
      POI = CreateFrame("Button", POIname, lclFrame, "MapNotesPOIButtonTemplate");
      POI:SetID(index);
    end

    POI.Plugin = Plugin;    -- Associate Plugin Data with each Note (nil for original WorldMap Notes)
                  -- Useful for distinguishing between types of note; Also, useful for
                  --  other AddOns that want to remain compatible (i.e. NotesUNeed)

  else

    local lclFrame = WorldMapButton;
    local POIname = 'MapNotesPOI'..index;
    POI = _G[POIname];

    if not (POI) then
      POI = CreateFrame("Button", POIname, WorldMapButton, "MapNotesPOIButtonTemplate");
      POI:SetID(index);
    end

    POI.Plugin = nil;   -- Just to be explicit
  end

  return POI;
end

function MapNotes_AssignLine(index, Plugin)
  local Line;

  if Plugin then
    local lclFrame = _G[Plugin.frame .. "_MNLinesFrame"];
    Line = _G[lclFrame:GetName() .. "Lines_" .. index];
    if not Line then
      Line = lclFrame:CreateTexture( (lclFrame:GetName() .. "Lines_" .. index), "ARTWORK" );
    end

  else
    Line = _G["MapNotesLines_"..index];
    if not Line then
      Line = MapNotesLinesFrame:CreateTexture( ("MapNotesLines_"..index), "ARTWORK");
    end
  end

  return Line;
end




-- Telic_10 Functions
-------------------------------------------------------------------------------------------------
-- Make MapNotes independant of Localisation (ZoneShifting) Errors
-- (i.e. future proofed. It doesn't fix errors already present in the notes when upgrading.)
-------------------------------------------------------------------------------------------------

MapNotes_Keys = {};     -- MapNotes Keys with Localised name details
MapNotes_OldKeys = {};    -- Mapping of old [Continent][Zone] to New Key values (for this localisation)
MapNotes_MetaKeys = {};   -- Mapping of MetaMaps new (but still not global?) Map Keys

-- Basically adding Localised names to the the 'constants' now used as note keys

function MapNotes_LoadMapData()

  MapNotes_BuildKeyList();    -- Other Addons that want to use the same keys should look here

  MapNotes_Undelete_Info = MapNotes_Undelete_Info or {};

  -- The metatable on MapNotes_Data_Notes and MapNotes_Data_Lines avoids
  -- the need to default all entries to an empty table

  if not MapNotes_Options.Edition then
    MapNotes_Options.Edition = MAPNOTES_EDITION;
  end

  MapNotes_Options.Version = MAPNOTES_VERSION;

end


local function NewKey(key)

  local name = 'MAPNOTES_'..key:match('^WM (.*)'):upper();

  assert(MAPNOTES_BASEKEYS[key].miniData, format('Base miniData not found for key %s', key))
  assert(_G[name], format('Area name %s not found', name));

  MapNotes_Keys[key] = {
    miniData = MAPNOTES_BASEKEYS[key].miniData;
    name = _G[name];
    longName = _G[name];
  };

  return MapNotes_Keys[key];

end


function SetMapKey(cont, zone, floor)

  local suffix = floor;

  if floorDetails.terrain then
    suffix = suffix - 1;
  end
  local floorname = _G["DUNGEON_FLOOR_" .. mapUpper .. suffix] or format(FLOOR_NUMBER, floor);
  local key = "WM " .. map .. floor;

  if not MapNotes_Keys[key] then
    MapNotes_Keys[key] = {};
  end

  if MAPNOTES_BASEKEYS[key] and MAPNOTES_BASEKEYS[key].miniData then
    MapNotes_Keys[key].miniData = MAPNOTES_BASEKEYS[key].miniData;
  else
    MapNotes_Keys[key].miniData = MAPNOTES_BASEKEYS.DEFAULT.miniData;
  end

  MapNotes_Keys[key].name = zoneNames[j] .. ": " .. floorname;
  MapNotes_Keys[key].longName = continentNames[i].." - "..zoneNames[j] .. ": " .. floorname;
  MapNotes_Keys[key].c = floorDetails.c;
  MapNotes_Keys[key].z = floorDetails.z;
  MapNotes_Keys[key].f = floor;

  if not MapNotes_OldKeys[i][j] then
    MapNotes_OldKeys[i][j] = map;
  end

end




function table.deepcopy(val)

  if type(val) ~= 'table' then
    return val;
  end

  local copy = {};

  for k, v in pairs(val) do
    copy[k] = table.deepcopy(v);
  end

  return copy;

end


function MN.printtable(t, indent)

  indent = indent or 0;

  local keys = {};

  for k in pairs(t) do
    table.insert(keys, k);
  end
  
  table.sort(keys, function(a, b)
    local ta, tb = type(a), type(b);
    if ta ~= tb then
      return ta < tb;
    elseif ta == 'string' and a:len() ~= b:len() then
      return a:len() < b:len();
    else
      return a < b;
    end
  end);

  print(string.rep('  ', indent)..'{');
  indent = indent + 1;
  for i, k in ipairs(keys) do
  
    local v = t[k];

    local key = k;
    if type(key) == 'string' then
      if not (string.match(key, '^[A-Za-z_][0-9A-Za-z_]*$')) then
        key = "['"..key.."']";
      end
    elseif type(key) == 'number' then
      key = "["..key.."]";
    end

    if type(v) == 'table' then
      if next(v) then
        printf("%s%s =", string.rep('  ', indent), tostring(key));
        MN.printtable(v, indent);
      else
        printf("%s%s = {},", string.rep('  ', indent), tostring(key));
      end 
    elseif type(v) == 'string' then
      printf("%s%s = %s,", string.rep('  ', indent), tostring(key), "'"..v.."'");
    else
      printf("%s%s = %s,", string.rep('  ', indent), tostring(key), tostring(v));
    end
  end
  indent = indent - 1;
  print(string.rep('  ', indent)..'}');
end

function MN_vardump(value, depth, key)

  local linePrefix = "";
  local spaces = "";
  
  if key ~= nil then
    linePrefix = "["..key.."] = ";
  end
  
  if depth == nil then
    depth = 0;
  else
    depth = depth + 1;
    for i=1, depth do spaces = spaces .. "  " end
  end
  
  if type(value) == 'table' then
    mTable = getmetatable(value);
    if mTable == nil then
      print(spaces ..linePrefix.."(table) ");
    else
      print(spaces .."(metatable) ");
        value = mTable;
    end   
    for tableKey, tableValue in pairs(value) do
      MN_vardump(tableValue, depth, tableKey);
    end
  elseif type(value) == 'function' or 
      type(value) == 'thread' or 
      type(value) == 'userdata' or
      value == nil
  then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
  end
end

function MN_split(str, sep)

  sep = sep or '%s+';

  local list = {};
  local init = 1;

  while true do

    if init > str:len() then break end

    local sepstart, sepend = str:find(sep, init);

    if not sepstart then
      tinsert(list, str:sub(init));
      break;
    end

    if sepstart > 1 then
      tinsert(list, str:sub(init, sepstart - 1));
    end

    init = sepend + 1;

  end

  return list;

end

--Other Addons that want to use the same keys should look here
--World Map Keys are basically  "WM "..GetMapInfo()
--Localised names are all fetched from game info, except for Battlegrounds - these need to be provided in the localisation files
function MapNotes_BuildKeyList()

  local continentNames = { GetMapContinents() };

  MapNotes_Keys['WM Cosmic'] = {      -- Burning Crusade Support
    name = MAPNOTES_COSMIC;
    longName = MAPNOTES_COSMIC;
    c = -1;
  };


  local key = "WM WorldMap";      -- Manually set when GetMapInfo() returns nil
  MapNotes_Keys['WM WorldMap'] = {
    name = WORLD_MAP;    -- Blizzard provided constant
    longName = WORLD_MAP;
    c = 0;
  };


  NewKey('WM AlteracValley');
  NewKey('WM ArathiBasin');
  NewKey('WM WarsongGulch');
  NewKey('WM NetherstormArena');
  NewKey('WM StrandoftheAncients');
  NewKey('WM ScarletEnclave');

  for i in ipairs(continentNames) do

    SetMapZoom(i);
    local mapID = GetCurrentMapAreaID();

    local map = 'WM '..GetMapInfo();

    if not MapNotes_Keys[map] then
      MapNotes_Keys[map] = {};
--printf('Adding key %s', map);
    end
    MapNotes_Keys[map].name = continentNames[i];
    MapNotes_Keys[map].longName = continentNames[i];
    MapNotes_Keys[map].c = i;

    if not MapNotes_OldKeys[i] then
      MapNotes_OldKeys[i] = {};
    end

    local zoneNames = { GetMapZones(i) };
    local floored = {};

    for j in ipairs(zoneNames) do

      SetMapZoom(i, j);
      map = GetMapInfo();
      local numLevels = GetNumDungeonMapLevels();
      local floored = {};

      if numLevels > 0 then
        floored[map] = {
          floors = numLevels;
          terrain = DungeonUsesTerrainMap();
          c = i;
          z = j;
        };

--if DungeonUsesTerrainMap() then print(format( "map %s uses terrain map", map )) end

      else

        map = "WM "..map;

        if not MapNotes_Keys[map] then
          MapNotes_Keys[map] = {};
--printf('Adding key %s', map);
        end

        MAPNOTES_BASEKEYS[map] = MAPNOTES_BASEKEYS[map] or {};
        if not (MAPNOTES_BASEKEYS[map].miniData) then
          MAPNOTES_BASEKEYS[map].miniData = table.deepcopy(MAPNOTES_BASEKEYS.DEFAULT.miniData);
        end
        MapNotes_Keys[map].miniData = MAPNOTES_BASEKEYS[map].miniData;

        MapNotes_Keys[map].name = zoneNames[j];
        MapNotes_Keys[map].longName = continentNames[i].." - "..zoneNames[j];
        MapNotes_Keys[map].c = i;
        MapNotes_Keys[map].z = j;

        if not MapNotes_OldKeys[i][j] then
          MapNotes_OldKeys[i][j] = map;
        end

        if MetaMap_ZoneIDToName then
          local metaKey = MetaMap_ZoneIDToName(i, j);
          if metaKey then
            MapNotes_MetaKeys[metaKey] = map;
          end
        end
      end

      for map, floorDetails in pairs(floored) do

        local mapUpper = strupper(map);

        for floor = 1, floorDetails.floors do

          local suffix = floor;
          if floorDetails.terrain then
            suffix = suffix - 1;
          end
          local floorname = _G["DUNGEON_FLOOR_" .. mapUpper .. suffix] or format(FLOOR_NUMBER, floor);
          local key = "WM " .. map .. floor;

          if not MapNotes_Keys[key] then
            MapNotes_Keys[key] = {};
--printf('Adding key %s', key);
          end

          MAPNOTES_BASEKEYS[key] = MAPNOTES_BASEKEYS[key] or {};
          if not (MAPNOTES_BASEKEYS[key].miniData) then
            MAPNOTES_BASEKEYS[key].miniData = table.deepcopy(MAPNOTES_BASEKEYS.DEFAULT.miniData);
          end
          MapNotes_Keys[key].miniData = MAPNOTES_BASEKEYS[key].miniData;

          MapNotes_Keys[key].name = zoneNames[j] .. ": " .. floorname;
          MapNotes_Keys[key].longName = continentNames[i].." - "..zoneNames[j] .. ": " .. floorname;
          MapNotes_Keys[key].c = floorDetails.c;
          MapNotes_Keys[key].z = floorDetails.z;
          MapNotes_Keys[key].f = floor;

          if not MapNotes_OldKeys[i][j] then
            MapNotes_OldKeys[i][j] = map;
          end

        end
      end
    end
  end

end


function MapNotes.UpdateMapInfo(...)
MapNotes.MapKey_()

  local map = GetMapInfo();

  if map then
    map = map:gsub('_terrain%d$', ''); -- Account for phased areas

  elseif GetCurrentMapContinent() == WORLDMAP_COSMIC_ID then
    map = "Cosmic";

  else
    map = "WorldMap";

  end

  local level = GetCurrentMapDungeonLevel();

  if level > 0 then
    map = "WM "..map..level;
  else
    map = "WM "..map;
  end

  return map;

end


function MapNotes_GetMapDisplayName(key, Plugin)
  if not Plugin then
    Plugin = MapNotes.pluginKeys[key];
  end

  if Plugin then
    if Plugin.lclFnc then
      local subber = Plugin.name .. " ";
      local basicKey, subbed = string.gsub(key, subber, "");
      if basicKey and subbed and subbed > 0 then
        local localiser = _G[Plugin.lclFnc];
        if localiser and type(localiser) == "function" then
          local name = localiser(basicKey);
          if name then
            lName = Plugin.name .. " - " .. name;
            return name, lName, Plugin.name;
          end
        end
      end
    end

  else
    if MapNotes_Keys[key] then
      return MapNotes_Keys[key].name, MapNotes_Keys[key].longName, WORLD_MAP;
    end
  end

-- Failing all else, generate a map name from the map key, which is in CamelCase
-- and may have a digit at the end. Put spaces in so it looks nice

  local map = key:match('(%S+)$'); -- remove WM or whatever from the front

  repeat
    local count;
    map, count = map:gsub('(%a)(%u)', function(a, u) return a..' '..u end);
  until count < 1;

  map = map:gsub('(%a)(%d)', function(a, d) return a..' '..d end);

  return map, map, WORLD_MAP;
end


-------------------------------------------------------------------------------------------------
-- Scaling functions for note
-------------------------------------------------------------------------------------------------

local MN_SCALE_MIN = 0.65;
local MN_SCALE_MAX = 1.2;

function MN_ScaleMe(self, minum, maxum, dflt)
  local gScale = UIParent:GetScale();
  local lScale = self:GetParent():GetScale();
  local eScale = self:GetParent():GetEffectiveScale();

  if not minum then
    minum = MN_SCALE_MIN;
  end
  if not maxum then
    maxum = MN_SCALE_MAX;
  end
  if not dflt then
    dflt = 1;
  end

  eScale = eScale * dflt;

  if eScale < minum then
    return ( ( minum / gScale ) / lScale );
  elseif eScale > maxum then
    return ( ( maxum / gScale ) / lScale );
  end

  return dflt;
end


-- Telic_4 Functions
-------------------------------------------------------------------------------------------------
-- Import from other Noting AddOns
--  NOTE : Not Importing any "Lines" at the moment...
-------------------------------------------------------------------------------------------------

-- METAMAP IMPORT

local numberImported;

function MapNotes_ImportMetaMap()
  local key;

  numberImported = 0;
  if MetaMap_Notes then
    for index, records in pairs(MetaMap_Notes) do
      if index == METAMAP_WARSONGGULCH then
        key = "WM WarsongGulch";
        MapNotes_ImportZoneNotes(records, MapNotes_Data_Notes[key]);

      elseif index == METAMAP_ALTERACVALLEY then
        key = "WM AlteracValley";
        MapNotes_ImportZoneNotes(records, MapNotes_Data_Notes[key]);

      elseif index == METAMAP_ARATHIBASIN then
        key = "WM ArathiBasin";
        MapNotes_ImportZoneNotes(records, MapNotes_Data_Notes[key]);

--      elseif  -- MetaMap Instances
        -- Nowhere to display Instance notes in basic version of MapNotes
        -- (Can import AlphaMap's Instance notes and use alongside AlphaMap)

      elseif MapNotes_MetaKeys[index] then
        local key = MapNotes_MetaKeys[index];
        MapNotes_ImportZoneNotes(records, MapNotes_Data_Notes[key]);
      end
    end
  end

  MapNotes.StatusPrint(numberImported..MAPNOTES_IMPORT_REPORT);
end

function MapNotes_ImportZoneNotes(sourceData, targetData)
  for index, record in ipairs(sourceData) do
    targetData[index] = sourceData[index];
    numberImported = numberImported + 1;
  end
end




-- ALPHAMAP IMPORT

function MapNotes_ImportAlphaMap(bgOnly)

  local key;

  numberImported = 0;

  if AM_ALPHAMAP_LIST then
    for index, map in pairs(AM_ALPHAMAP_LIST) do
      if bgOnly == "OnlyBGs" and map.type == AM_TYP_BG
          or bgOnly ~= "OnlyBGs" and map.type ~= AM_TYP_BG then

        local key = "AlphaMap "..(map.filename);
        local targetData = MapNotes_Data_Notes[key];
        local index = 0;

        table.sort(map);
        for detailName, details in pairs(map) do
          if ( type(details) == "table" ) and ( details.coords ) then
            for point, coordinates in ipairs(details.coords) do
              numberImported = numberImported + 1;
              index = index + 1;
              local imported = MapNotes_CreateAlphaNote(details, targetData, index, coordinates);
              if not imported then
                numberImported = numberImported - 1;
                index = index - 1;
              end
            end
          end
        end
      end
    end
  end

  MapNotes.StatusPrint(numberImported..MAPNOTES_IMPORT_REPORT);
end

function MapNotes_ImportAlphaMapBG()
  MapNotes_ImportAlphaMap("OnlyBGs");
end

function MapNotes_CreateAlphaNote(noteDetails, targetData, index, coords)
  if ( coords[1] == 0 ) and ( coords[2] == 0 ) then
    return nil;
  end

  targetData[index] = {};
  targetData[index].name = noteDetails.text;
  targetData[index].inf1 = noteDetails.tooltiptxt;
  if noteDetails.special then
    targetData[index].inf2 = noteDetails.special;
  else
    targetData[index].inf2 = "";
  end
  targetData[index].creator = "AlphaMap";
  targetData[index].xPos = coords[1] / 100;
  targetData[index].yPos = coords[2] / 100;
  targetData[index].in2c = 8;

  if noteDetails.colour == AM_RED then
    targetData[index].icon = 6;
    targetData[index].ncol = 2;
    targetData[index].in1c = 0;

  elseif noteDetails.colour == AM_GREEN then
    targetData[index].icon = 0;
    targetData[index].ncol = 4;
    targetData[index].in1c = 0;

  elseif noteDetails.colour == AM_BLUE then
    targetData[index].icon = 2;
    targetData[index].ncol = 6;
    targetData[index].in1c = 0;

  elseif noteDetails.colour == AM_GOLD then
    targetData[index].icon = 0;
    targetData[index].ncol = 0;
    targetData[index].in1c = 0;

  elseif noteDetails.colour == AM_PURPLE then
    targetData[index].icon = 7;
    targetData[index].ncol = 7;
    targetData[index].in1c = 7;

  elseif noteDetails.colour == AM_ORANGE then
    targetData[index].icon = 5;
    targetData[index].ncol = 1;
    targetData[index].in1c = 1;

  elseif noteDetails.colour == AM_YELLOW then
    targetData[index].icon = 5;
    targetData[index].ncol = 0;
    targetData[index].in1c = 0;
  end

  -- For possible Future Development
  if noteDetails.lootid then
    targetData[index].lootid = noteDetails.lootid;
  end

  return true;
end

-- /script MapNotes_ImportCarto()
-- Wibble
function MapNotes_ImportCarto()

  local rIcons = {};
  local rIconsIndex = 0;

  local colours = {
    [16771840] = 0,
    [16421120] = 1,
    [16727339] = 2,
    [16752278] = 3,
    [717312] = 4,
    [45568] = 5,
    [65535] = 6,
    [46591] = 7,
    [99999] = 8,
    [13421772] = 9,
  };

  local icons = {
    ["Moon"]    = 1,
    ["Skull"]   = 2,
    ["Square"]    = 3,
    ["Cross"]   = 4,
    ["Triangle"]  = 5,
    ["Circle"]    = 6,
    ["Diamond"]   = 7,
    ["Star"]    = 8,
  };

  local cIcons = {
    ["Moon"]    = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidCrescentMoon",
    ["Skull"]   = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidSkull",
    ["Square"]    = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidBlueSquared",
    ["Cross"]   = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidRedCross",
    ["Triangle"]  = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidGreenTriangle",
    ["Circle"]    = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidOrangeCircle",
    ["Diamond"]   = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidPurpleDiamond",
    ["Star"]    = "Interface\\AddOns\\MapNotesIconLib\\Icons\\Blizzard\\RaidYellowStarDiamond",
  };

  local cNotes = CartographerDB.namespaces.Notes.account.pois;
  local currentNotes, nNote;
  local count = 0;

  for locale, lNotes in pairs(cNotes) do
    -- get key from locale
    currentNotes = nil;

    for key, data in pairs(MapNotes_Keys) do
      if data.name == locale then
        currentNotes = MapNotes_Data_Notes[key];
        if currentNotes then
          break;
        end
      end
    end

    if not currentNotes then
      currentNotes = MapNotes_Data_Notes[locale];
    end

    if currentNotes then
      for id, details in pairs(lNotes) do
        nNote = {};
        nNote.xPos, nNote.yPos = ( (id % 10001)/10000), ( math.floor(id / 10001)/10000 );
        nNote.name = ( details.title or "" );
        nNote.ncol = 8;
        if ( details.titleCol ) and ( colours[details.titleCol] ) then
          nNote.nol = colours[details.titleCol];
        end
        nNote.inf1 = ( details.info or "" );
        nNote.in1c = 4;
        if ( details.infoCol ) and ( colours[details.infoCol] ) then
          nNote.in1c = colours[details.infoCol];
        end
        nNote.inf2 = ( details.info2 or "" );
        nNote.in2c = 0;
        if ( details.info2Col ) and ( colours[details.info2Col] ) then
          nNote.in2c = colours[details.info2Col];
        end
        nNote.creator = ( details.creator or "Cartographer" );
        if icons[details.icon] then
          nNote.icon = icons[details.icon];
        else
          if not rIcons[details.icon] then
            rIcons[details.icon] = rIconsIndex;
            rIconsIndex = rIconsIndex + 1;
            if rIconsIndex > 9 then
              rIconsIndex = 0;
            end
          end
          nNote.icon = rIcons[details.icon];
        end
        nNote.customIcon = ( cIcons[details.icon] or "" );

        --table.insert( currentNotes, nNote );
        currentNotes[#currentNotes+1] = nNote;
        count = count + 1;
      end
    end
  end

  MapNotes.StatusPrint(count..MAPNOTES_IMPORT_REPORT);
end


-- CTMapMod

function MapNotes_ImportCTMap()

  numberImported = 0;

  if CT_UserMap_Notes then

    for mnKey, values in pairs(MapNotes_Keys) do

      local ctKey = values.name;
      local mnIndex = 0;

      if CT_UserMap_Notes[ctKey] then
        for ctNoteIndex, ctNote in ipairs(CT_UserMap_Notes[ctKey]) do
          if ctNote.set < 7 then
            mnIndex = mnIndex + 1;
            numberImported = numberImported + 1;
            local targetData = MapNotes_Data_Notes[mnKey];
            MapNotes_CreateCTNote(ctNote, targetData, mnIndex);
          end
        end
      end

    end

  end

  MapNotes.StatusPrint(numberImported..MAPNOTES_IMPORT_REPORT);
end

function MapNotes_CreateCTNote(noteDetails, targetData, index)

  local newNote = {
    name = noteDetails.name;
    ncol = 0;
    inf1 = noteDetails.descript;
    in1c = 0;
    inf2 = "";
    in2c = 0;
    creator = "CTMapMod";
    xPos = noteDetails.x;
    yPos = noteDetails.y;
  };

  if noteDetails.set == 1 then
    newNote.icon = 0;
    newNote.ncol = 0;
    newNote.in1c = 0;

  elseif noteDetails.set == 2 then
    newNote.icon = 2;
    newNote.ncol = 7;
    newNote.in1c = 7;

  elseif noteDetails.set == 3 then
    newNote.icon = 1;
    newNote.ncol = 2;
    newNote.in1c = 2;

  elseif noteDetails.set == 4 then
    newNote.icon = 4;
    newNote.ncol = 8;
    newNote.in1c = 8;

  elseif noteDetails.set == 5 then
    newNote.icon = 3;
    newNote.ncol = 4;
    newNote.in1c = 4;

  elseif noteDetails.set == 6 then
    newNote.icon = 6;
    newNote.ncol = 3;
    newNote.in1c = 3;
  end

  targetData[index] = newNote;
end



-- Data Fix for people who have gaps in notes, making it seem as though many notes are missing

function MN_DataCheck(report)
  MapNotes_Data_Notes = MN_DataCheck_Sort(MapNotes_Data_Notes, report);
  MapNotes_Data_Lines = MN_DataCheck_Sort(MapNotes_Data_Lines, report);
end

function MN_DataCheck_Sort(data, report)

  local holdingArray = {};
  local errors = 0;


  if report then
    report = 0;
  end

  for key, currentNotes in pairs(data) do

    holdingArray[key] = {};

    local counter = 0;

    for id, note in pairs(currentNotes) do
      if note.name then
        if not note.icon then
          errors = errors + 1;
          note.icon = 0;
        end
        if not note.inf1 then
          errors = errors + 1;
          note.inf1 = "";
        end
        if not note.inf2 then
          errors = errors + 1;
          note.inf2 = "";
        end
        if not note.xPos then
          errors = errors + 1;
          note.xPos = 0;
        end
        if not note.yPos then
          errors = errors + 1;
          note.yPos = 0;
        end
      end
      counter = counter + 1;
      holdingArray[key][counter] = note;
    end

    if report then
      report = report + counter;
    end

  end

  if report then
    DEFAULT_CHAT_FRAME:AddMessage("MapNotes -> "..report, 0.9, 0.1, 0.1);
  end

  if errors > 0 then
    DEFAULT_CHAT_FRAME:AddMessage("MapNotes -> |cffff0000"..errors.."|r Errors Self Corrected", 0.9, 0.1, 0.1);
  end

  local mt = getmetatable(data);
  setmetatable(holdingArray, mt);

  return holdingArray;

end



-- Temporary include a fix function for Stormwind map adjustments
function Stormwindy()
  local x, y;
  local moved = 0;

  for i, n in ipairs(MapNotes_Data_Notes["WM Stormwind"]) do
    x = n.xPos*.76+.203;
    if x > 0.9999 then x = 0.9999; end
    y = n.yPos*.76+.253;
    if y > 0.9999 then y = 0.9999; end

    n.xPos = x;
    n.yPos = y;
    moved = moved + 1;
  end

  DEFAULT_CHAT_FRAME:AddMessage("MapNotes -> "..moved, 0.9, 0.1, 0.1);
  MapNotes_WorldMapButton_OnUpdate();
end

function MN_IntegrityCheck()
  local totNotes, totFixed = 0, 0;

  for key, notes in pairs(MapNotes_Data_Notes) do
    for note, details in ipairs(notes) do
      totNotes = totNotes + 1;
      if type(details.inf1) == "table" then
        details.inf1 = "";
        totFixed = totFixed + 1;
      end
    end
  end

  MapNotes_mntloc();

  DEFAULT_CHAT_FRAME:AddMessage("MapNotes -> "..totFixed, 0.9, 0.1, 0.1);
end


--print('Utilities loaded');

