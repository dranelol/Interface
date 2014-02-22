--[[
Callback events  

OPTIONS_UPDATE 
	args:  nil
		
	Fired when ever the GUI options are changed
		
]]
local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
GUI = PetBattleTeams:NewModule("GUI")
local _

local eventFrame = CreateFrame("frame")

local function OnEvent(self,event,...)
	if event == "PET_JOURNAL_LIST_UPDATE" then
		if not IsAddOnLoaded("Blizzard_PetJournal") then
			LoadAddOn("Blizzard_PetJournal")
		end
		if not GUI.delayedInit then
			GUI:InitializeGUI()
		end
		self:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")		
	end
	
	if event == "PLAYER_REGEN_ENABLED" or event == "PET_BATTLE_CLOSE"  then
		if GUI.delayedInit then
			GUI:InitializeGUI()
		end
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PET_BATTLE_CLOSE")
	end
end

eventFrame:SetScript("OnEvent",OnEvent)
eventFrame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PET_BATTLE_CLOSE")


function GUI:OnInitialize()
	self.callbacks = LibStub("CallbackHandler-1.0"):New(self)
	
	local db = LibStub("AceDB-3.0"):New("PetBattleTeamsDB", {} , true)
	local name = self:GetName()
	
	local defaults = {
		global = {
			attached = true,
			locked = false,
			hideInCombat = true,
			x = 0,
			y = 0,
			h = 606,
			showSelectedTeam =true,
			showControls = true,
			showRoster = true,
		}
	}
	
	self.db = db:RegisterNamespace(name, defaults)
	
	
	if UnitAffectingCombat("player") then
		self.delayedInit = true
	end
	--local pos = self.db.global
	--self.mainFrame:SetPosition(pos.x,pos.y,pos.h)
end

function GUI:InitializeGUI()
	if not self.mainFrame then
		self.mainFrame =  GUI:CreateMainFrame()
		
		
		self.mainFrame:SetLocked(self:GetLocked())
		self.mainFrame:Hide()
		
		if not UnitAffectingCombat("player") then
			self.mainFrame:SetAttached(self:GetAttached())
			self.mainFrame:SetComponentPoints(GUI:GetComponentPoints())
			self.mainFrame:Show()
		end
	end
end

function GUI:SetAttached(enabled)
	if UnitAffectingCombat("player") then print("PetBattleTeams: Can't change attachment during combat") return end
	self.db.global.attached = enabled
	if self.mainFrame then 
		self.mainFrame:SetAttached(enabled)
	end
end

function GUI:SetHideInCombat(enabled )
	self.db.global.hideInCombat = enabled
end

function GUI:SetLocked(enabled)
	self.db.global.locked = enabled
	if self.mainFrame then 
		self.mainFrame:SetLocked(enabled)
	end
	self.callbacks:Fire("OPTIONS_UPDATE")
end

function GUI:GetAttached()
	return self.db.global.attached
end

function GUI:GetLocked()
	return self.db.global.locked
end

function GUI:GetHideInCombat()
	return self.db.global.hideInCombat
end

function GUI:GetPosition()
	local db = self.db.global
	return db.x,db.y,db.h
end

function GUI:SetPosition(x,y,h)
	local db = self.db.global
	db.x,db.y,db.h = x,y,h
end

function GUI:ResetUI()
	self:SetLocked(false)
	self:SetAttached(true)
	self:SetHideInCombat(true)
end

function GUI:ResetScrollBar()
	if self.mainFrame then 
		self.mainFrame.rosterFrame:ResetScrollBar()
	end
end

function GUI:SetComponentPoints(showSelectedTeam,showControls,showRoster)
	if showSelectedTeam ~= nil then self.db.global.showSelectedTeam = showSelectedTeam end
	if showControls ~= nil then self.db.global.showControls = showControls end
	if showRoster ~= nil then self.db.global.showRoster = showRoster end
	if self.mainFrame then 
		self.mainFrame:SetComponentPoints(GUI:GetComponentPoints())
		self:ResetScrollBar()
	end
end

function GUI:GetComponentPoints()
	return self.db.global.showSelectedTeam,self.db.global.showControls,self.db.global.showRoster
end





