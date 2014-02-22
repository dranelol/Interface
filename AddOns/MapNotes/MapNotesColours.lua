--[[
  MapNotes: Adds a note system to the WorldMap and other AddOns that use the Plugins facility provided

  See the README file for more information.
]]


MN_PARTY_ICON = nil;  -- Replace with the Name of the icon's graphics file INCLUDING the Path from Interface\\ as per below
MN_TLOC_ICON  = nil;  -- Replace with the Name of the icon's graphics file INCLUDING the Path from Interface\\ as per below

MapNotes_Colours = {};
MapNotes_Colours[0] = {r = 1.0,  g = 0.82, b = 0.0};
MapNotes_Colours[1] = {r = 0.55, g = 0.46, b = 0.04};
MapNotes_Colours[2] = {r = 0.87, g = 0.06, b = 0.0};
MapNotes_Colours[3] = {r = 0.56, g = 0.0,  b = 0.0};
MapNotes_Colours[4] = {r = 0.18, g = 0.7,  b = 0.2};
MapNotes_Colours[5] = {r = 0.0,  g = 0.39, b = 0.05};
MapNotes_Colours[6] = {r = 0.42, g = 0.47, b = 0.87};
MapNotes_Colours[7] = {r = 0.25, g = 0.35, b = 0.66};
MapNotes_Colours[8] = {r = 1.0,  g = 1.0,  b = 1.0};
MapNotes_Colours[9] = {r = 0.65, g = 0.65, b = 0.65};


--[[

  In Order for another AddOn to replace the default Icons and colours they
  should take the following steps:

  Modification of colours is no longer fully supported - as users can now
  select their own. A Modified colour table can still be supplied above to
  modify the defaults, but no need to SetTextures. (If you do SetTextures they
  will be reset to by the program and the supplied colour table used anyway).

  1) Make MapNotes a Required Dependancy for their AddOn

  2) Provide their own graphics in their own AddOn's Library Path

  3) Include an OnEvent function in their AddOn which takes the following
     steps, once their "ADDON_LOADED" has occurred :

     - Replace the  _PATH  Constants above, with Directory Paths pointing to
       their own AddOn's graphics

     - Replace the  MapNotes_Colours  array above with their own colour
       choices

     - Include the following code snippet that has been commented out below :

       for i = 0, 9 do
         _G["MN_EditIcon"..i.."Texture"]:SetTexture(MAPNOTES_PATH.."POIIcons\\Icon"..i);
         _G["MapNotesOptionsIcon"..i.."Texture"]:SetTexture(MAPNOTES_PATH.."POIIcons\\Icon"..i);
       end
--]]
