if not IsAddOnLoaded("ButtonFacade") then return end
 
local BFGP = CreateFrame("Frame")
local self = BFGP
BFGP:SetScript("OnEvent", function(this, event, ...)
	this[event](this, ...)
end)

local LBF = LibStub("LibButtonFacade")
local GP = "GupPet"

local db = {}


BFGP:RegisterEvent("PLAYER_ENTERING_WORLD")
function BFGP:PLAYER_ENTERING_WORLD()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	BFGPSettingsDB = BFGPSettingsDB or {}
	db = BFGPSettingsDB

	if db.dbinit ~= 1 then
		local defaults = {
			groups = {
				 
				["Action Buttons"] = {
					skin = "Blizzard",
					gloss = false,
					backdrop = false,
					colors = {},
				},
			},
			dbinit = 1,
		}
		db = defaults
		BFGPSettingsDB = db
	end
	self.db = db

	
	local lbfgroup = LBF:Group(GP, "Action Buttons")
	lbfgroup:Skin(self.db.groups["Action Buttons"].skin, self.db.groups["Action Buttons"].gloss, self.db.groups["Action Buttons"].backdrop, self.db.groups["Action Buttons"].colors)
 
 
	 LBF:Group(GP, "Action Buttons"):AddButton(getglobal("GupPet_IngameFrameTemplateAuto"));
	 LBF:Group(GP, "Action Buttons"):AddButton(getglobal("GupPet_IngameFrameTemplateGround"));
	 LBF:Group(GP, "Action Buttons"):AddButton(getglobal("GupPet_IngameFrameTemplateFly"));
	 LBF:Group(GP, "Action Buttons"):AddButton(getglobal("GupPet_IngameFrameTemplateCompanion"));
	
	 
	LBF:RegisterSkinCallback(GP, function(_, SkinID, Gloss, Backdrop, Group, Button, Colors)
		if not Group then return end
		self.db.groups[Group].skin = SkinID
		self.db.groups[Group].gloss = Gloss
		self.db.groups[Group].backdrop = Backdrop
		self.db.groups[Group].colors = Colors
	end, self)


end




