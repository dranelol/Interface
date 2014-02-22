--[[
Atlasloot Enhanced
Author Hegarol
Loot browser associating loot with instance bosses
Can be integrated with Atlas (http://www.atlasmod.com)
]]

--Invoke libraries
local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");

--Make an LDB object
local MiniMapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("AtlasLoot", {
    type = "launcher",
	text = AL["AtlasLoot"],
    icon = "Interface\\Icons\\INV_Box_01",
})

local MiniMapIcon = LibStub("LibDBIcon-1.0")

function MiniMapLDB:OnClick(button,down)
	if IsShiftKeyDown() then
		AtlasLoot:OptionsToggle()
	else
		AtlasLoot:ShowFrame_MiniMap()
	end
end

function AtlasLoot:MiniMapButtonInitialize()
	MiniMapIcon:Register("AtlasLoot", MiniMapLDB, self.db.profile.MiniMapButton)
end

function AtlasLoot:MiniMapButtonHideShow()
	AtlasLoot.db.profile.MiniMapButton.hide = not AtlasLoot.db.profile.MiniMapButton.hide
	if AtlasLoot.db.profile.MiniMapButton.hide then
		MiniMapIcon:Hide("AtlasLoot")
	else
		MiniMapIcon:Show("AtlasLoot")
	end

end
-- Overwrite this in ../AtlasLoot/Modules/DefaultFrame.lua
function AtlasLoot:ShowFrame_MiniMap()

end
--[[
function MiniMapLDB:OnEnter(motion)
end

function MiniMapLDB:OnLeave()
end
]]--