local PetBattleTeams = LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams")
local Config = PetBattleTeams:NewModule("Config","AceConsole-3.0")
local TeamManager = PetBattleTeams:GetModule("TeamManager")
local GUI = PetBattleTeams:GetModule("GUI")
local Tooltip = PetBattleTeams:GetModule("Tooltip")
local _

Config.options = {
    name = "PetBattle Teams",
    handler = self,
    type = 'group',
    args = {
			TeamFrameHeading = {
				order = 1,
				name = "Teams and Pets",
				width = "double",
				type = "header",
			},
			showXpInLevel = {
				order = 2,
				name = "Display pets xp as part of the pets level",
				width = "double",
				type = "toggle",
				set = function(info,val) 
					TeamManager:SetShowXpInLevel(val)
				end,
				get = function(info) return TeamManager:GetShowXpInLevel() end
			},
			showXpInHealth = {
				order = 3,
				name = "Display pets xp instead of the health bar ",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					TeamManager:SetShowXpInHealthBar(val)
				end,
				get = function(info) return TeamManager:GetShowXpInHealthBar() end
			},
			ShowTeamName = {
				order = 4,
				name = "Display team name above the team",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					TeamManager:SetShowTeamName(val)
				end,
				get = function(info) return TeamManager:GetShowTeamName()  end
			},
				SelectedTeamScrolling = {
				order = 5,
				name = "Enable mouse wheel scrolling for the selected team",
				type = "toggle",
				width = "double",
				desc = "When enabled allows you to change the selected team by using the mouse wheel on the selected team (above the roster)",
				set = function(info,val) 
					GUI:SetSelectedTeamScrolling(val)
				end,
				get = function(info) return GUI:GetSelectedTeamScrolling()  end
			},
			MainFrameHeading = {
				order = 50,
				name = "Main",
				width = "double",
				type = "header",
				
			},
			AttachToPetJournal = {
				order = 51,
				name = "Attach PetBattle Teams to Pet Journal",
				desc = "When attached, PetBattle Teams will only be usable from the Pet Journal.",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					GUI:SetAttached(val)
				end,
				get = function(info) return GUI:GetAttached() end
			},
			HideInCombat = {
				order = 52,
				name = "Hide PetBattle Teams while in combat or in a Pet Battle",
				desc = "Hides PetBattle Teams while in combat or in a Pet Battle.",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					GUI:SetHideInCombat(val)
				end,
				get = function(info) return GUI:GetHideInCombat() end
			},
			LockPosition = {
				order = 53,
				name = "Lock PetBattle Teams Position",
				type = "toggle",
				width = "double",
				desc = "When the team frame is not attached to the Pet Journal then if the frame is locked it cannot be moved.",
				set = function(info,val) 
					GUI:SetLocked(val)
				end,
				get = function(info) return GUI:GetLocked() end
			},
			showSelectedTeam = {
				order = 60,
				name = "Show the selected team indicator",
				type = "toggle",
				width = "double",
				desc = "",
				set = function(info,val) 
					GUI:SetComponentPoints(val,nil,nil)
				end,
				get = function(info) return select(1,GUI:GetComponentPoints()) end
			},
			showControls = {
				order = 61,
				name = "Show control buttons",
				type = "toggle",
				width = "double",
				desc = "",
				set = function(info,val) 
					GUI:SetComponentPoints(nil,val,nil)
				end,
				get = function(info) return select(2,GUI:GetComponentPoints()) end
			},
			showRoster = {
				order = 62,
				name = "Show the team roster",
				type = "toggle",
				width = "double",
				desc = "",
				set = function(info,val) 
					GUI:SetComponentPoints(nil,nil,val)
				end,
				get = function(info) return select(3,GUI:GetComponentPoints()) end
			},
			
			
			TooltipHeading = {
				order = 75,
				name = "Tooltip",
				width = "double",
				type = "header",
				
			},
			ShowHelperText = {
				order = 80,
				name = "Show keybinding helper text in tooltip",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					Tooltip:SetShowHelpText(val)
				end,
				get = function(info) return Tooltip:GetShowHelpText() end
			},
			ShowBreedInfo = {
				order = 81,
				name = "Show breed information in tooltip",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					Tooltip:SetShowBreedInfo(val)
				end,
				get = function(info) return Tooltip:GetShowBreedInfo() end
			},
			
			
			TeamFunctionsHeading = {
				order = 98,
				name = "Team Management",
				width = "double",
				type = "header",
				
			},
			IgnoreEmptyPets = {
				order = 99,
				name = "Ignore Empty or invalid pets when setting teams",
				desc = "When enabled:|nWhen selecting a team, empty or invalid pets will no longer clear battlepet slots and will instead leave which ever pet was there prior to switching teams. If the team is unlocked then leftover valid pet(s) will join the selected team if that pets settings are changed.",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					TeamManager:SetIgnoreEmptyPets(val)
				end,
				get = function(info) return TeamManager:GetIgnoreEmptyPets() end
			},
			SaveTeams = {
				order = 100,
				name = "Automatically Save Teams",
				desc = "When enabled:|nThe currently selected team will have its pets updated to match the pet journal at all times unless the selected team is locked.|n|nNewly created teams will be created using the currently selected pets.",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					TeamManager:SetAutomaticallySaveTeams(val)
				end,
				get = function(info) return TeamManager:GetAutomaticallySaveTeams() end
			},
			DismissPet = {
				order = 101,
				name = "Automatically Dismiss pet after team changes",
				desc = "When enabled, Your active pet will be dismissed when switching teams",
				type = "toggle",
				width = "double",
				set = function(info,val) 
					TeamManager:SetDismissPet(val)
				end,
				get = function(info) return TeamManager:GetDismissPet(val) end
			},
			ImportTeams = {
				order = 102,
				name = "Reconstruct teams",
				width = "double",
				type = "execute",
				desc = "Attempts to reconstuct teams with invalid pets",
				func = function() 
					TeamManager:ReconstructTeams()
				end,
			},
			
			UnlockTeams = {
				order = 103,
				name = "Unlock all existing teams",
				width = "double",
				type = "execute",
				desc = "This does not prevent you from locking individual teams.",
				func = function() 
					TeamManager:SetLockStateAllTeams(false)
					print("PetBattle Teams: Teams Unlocked")
				end,
			},
			LockAllTeams = {
				order = 103,
				name = "Lock all existing teams",
				width = "double",
				type = "execute",
				desc = "This does not lock newly created teams or prevent you from unlocking individual teams.",
				func = function() 
					TeamManager:SetLockStateAllTeams(true)
					print("PetBattle Teams: Teams locked")
				end,
				
			},
			ResetTeams = {
				order = 110,
				name = "Delete all teams",
				type = "execute",
				width = "double",
				desc= "Permanently deletes all teams. There is no confirmation for this action.",
				func = function() 
					TeamManager:ResetTeams()
					GUI:ResetScrollBar()
					print("PetBattle Teams: Teams Reset")
				end,
			},
			
			ResetUI = {
				order = 120,
				name = "Reset UI",
				type = "execute",
				width = "double",
				desc= "Resets the UI to its default settings. There is no confirmation for this action.",
				func = function() 
					GUI:ResetUI()
					TeamManager:ResetUI()
					print("PetBattle Teams: UI Reset")
				end,
			},
		},
}

function Config:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PetBattleTeams", Config.options,"/pbt")
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PetBattleTeams","PetBattle Teams")
end



function Config:GetEasyMenu()
	--bad bubble sort hack
	local function GetNextOptions(options,lastOrder)
		if not lastOrder or not options then return end
		local option
		local minOrder = 10000
		for k,v in pairs(options) do
			if v.order > lastOrder and v.order < minOrder then
				option = k
				minOrder = v.order
			end
		end
		return option,minOrder
	end
	
	local menu = {}
	local v,i = _,0
	while(true) do
		v,i = GetNextOptions(self.options.args,i)
		
		if not v then break end
		v = self.options.args[v]
		local option = {}
		
		if v.type == "toggle" then
			option.text = v.name
			option.notCheckable = false
			option.isNotRadio = true
			option.keepShownOnClick = true
			local func = v.set
			option.func =  function(self, arg1, arg2, checked) func(nil,checked) end
			option.checked = v.get
		end
		
		if v.type == "header" then
			option.isTitle = true 
			option.text = v.name
			option.notCheckable = true
			option.isNotRadio = true
			option.keepShownOnClick = true
		end
		
		table.insert(menu,option)
	end
	return menu
end


