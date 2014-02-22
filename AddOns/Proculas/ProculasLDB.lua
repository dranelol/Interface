--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Korvo on US Proudmoore
--  - Idunnô, Clorell, Mcstabin on US Hellscream
--

local Proculas = LibStub("AceAddon-3.0"):GetAddon("Proculas")
local L = LibStub("AceLocale-3.0"):GetLocale("Proculas", false)
local tooltip = nil
local LibQTip = LibStub:GetLibrary( "LibQTip-1.0")
ProculasLDB = Proculas:NewModule("ProculasLDB")

if not Proculas.enabled then
	return nil
end

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("Proculas", {
		type = "data source",
		icon = "Interface\\Icons\\Spell_Holy_Aspiration",
		text = "Proculas",
	})

function ProculasLDB:OnInitialize()
	self.opt = Proculas.opt
	self.icon = LibStub("LibDBIcon-1.0")
	self.icon:Register("Proculas", dataobj, self.opt.minimapButton)
end

function ProculasLDB:ToggleMMButton(value)
	if value then
		self.icon:Hide("Proculas")
	else
		self.icon:Show("Proculas")
	end
end

local function wtfIsThis(wtfisit)
	if type(wtfisit) == table then
		for a,b in pairs(procId) do
			if a then
				print(a)
			end
			if b then
				print(b)
			end
			print("------------------")
		end
	else
		print(wtfisit)
	end
end

local function StatsToChat(crapola, stats)
	local procInfo = Proculas.optpc.procs[stats.procId]

	ChatFrame_OpenChat("[Proculas]: "..procInfo.name.." - "..stats.ppm.." PPM, "..stats.cd.." CD, "..stats.uptime.." UT", SELECTED_DOCK_FRAME)
end

local function Yellow(text) return "|cffffd200"..text.."|r" end
local function Green(text) return "|cff00ff00"..text.."|r" end
function dataobj:OnEnter()
	if tooltip then
		LibQTip:Release(tooltip)
	end
	tooltip = LibQTip:Acquire("ProculasProcStats", 5, "LEFT", "CENTER", "CENTER", "CENTER","RIGHT")
	tooltip:SetAutoHideDelay(0.1, self)
	--tooltip:Hide()
	--tooltip:Clear()

	tooltip:AddHeader(L["Proculas"])
	tooltip:AddLine(" ")

	--Proculas:procStatsTooltip(tooltip)
	local lineCount = 3
	tooltip:AddLine(Yellow(L["Proc"].." "),Yellow(" "..L["Total"].." "),Yellow(" "..L["PPM"].." "),Yellow(" "..L["CD"].." "),Yellow(" "..L["Uptime"]))
	for a,proc in pairs(Proculas.optpc.procs) do


		if not proc.enabled then
			break
		end
		if(proc.name) then
			if proc.count > 0 then
				lineCount = lineCount+1

				-- Proc Count
				if proc.count > 0 then
					procCount = proc.count
				else
					procCount = L["NA"]
				end

				-- Proc Cooldown
				if proc.cooldown > 0 then
					if proc.cooldown > 60 then
						procCooldown = string.format("%.2f", proc.cooldown / 60).."m" --proc.cooldown
					else
						procCooldown = proc.cooldown.."s"
					end
				elseif proc.cooldown == 0 and proc.count > 1 then
					procCooldown = "0s"
				else
					procCooldown = L["NA"]
				end

				-- Procs Per Minute
				local ppm = 0
				if proc.count > 0 then
					ppm = proc.count / (proc.time / 60)
				end
				if ppm > 0 then
					procPPM = string.format("%.2f", ppm)
				else
					procPPM = L["NA"]
				end

				-- Proc Uptime
				if not proc.uptime then
					proc.uptime = 0
				end
				local uptime = 0
				if proc.uptime > 0 and proc.time > 0 then
					uptime = proc.uptime / proc.time * 100
				end
				if(uptime > 0) then
					procUptime = string.format("%.2f", uptime).."%";
				else
					procUptime = L["NA"]
				end

				-- Proc Name
				if not proc.rank == "" then
					procName = proc.name.." "..proc.rank
				else
					procName = proc.name
				end
				tooltip:AddLine(Green(procName), procCount, procPPM, procCooldown, procUptime)

				-- Proc stats to chat link
				local procStats = {
					procId = proc.procId,
					ppm = procPPM,
					cd = procCooldown,
					uptime = procUptime,
				}
				if proc.count > 0 then
					tooltip:SetLineScript(lineCount, "OnMouseUp", StatsToChat, procStats)
				end
			end
		end
	end
	tooltip:AddLine(" ")

	local lineNumA = tooltip:AddLine("a")
	tooltip:SetCell(lineNumA, 1, Green(L["Right click to open config"]), "LEFT", 4)
	local lineNumB = tooltip:AddLine("b")
	tooltip:SetCell(lineNumB, 1, Green(L["Alt click to reset stats"]), "LEFT", 4)

	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function dataobj:oldOnLeave()
	tooltip:Hide()
	LibQTip:Release(tooltip)
	tooltip = nil
end


local configMenu = CreateFrame("Frame", "ProculasLDB_Menu")
configMenu.displayMode = "MENU"
configMenu.initialize = function(self, level)
	if not level then return end

	tooltip:Hide()

	local title = UIDropDownMenu_CreateInfo()
	title.text = "Proculas"
	title.isTitle = true
	title.notCheckable = true
	UIDropDownMenu_AddButton(title, level)

	local openConfig = UIDropDownMenu_CreateInfo()
	openConfig.text = L["Config"]
	openConfig.notCheckable = true
	openConfig.func = function() Proculas:ShowConfig() end
	UIDropDownMenu_AddButton(openConfig, level)
end

function dataobj:OnClick(button)
	if button == "LeftButton" and IsAltKeyDown() then
		Proculas:resetProcStats()
	elseif button == "RightButton" then
		Proculas:ShowConfig()
		--configMenu.scale = UIParent:GetScale()
		--ToggleDropDownMenu(1, nil, configMenu, self, 0, 0)
	end
end
