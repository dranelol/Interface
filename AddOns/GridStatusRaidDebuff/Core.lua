
local AceAddon = LibStub("AceAddon-3.0")

GridStatusRaidDebuff = AceAddon:NewAddon("GridStatusRaidDebuff",
				"AceConsole-3.0",
				"AceEvent-3.0")

StaticPopupDialogs["GridStatusRaidDebuff"] = {
  text = "GridStatusRaidDebuff has moved to GridStatusRaidDebuff MoP.\n" ..
         "http://www.curse.com/addons/wow/gridstatusraiddebuff-mop\n" ..
         "Please switch to the new addon.",
  button1 = "Close",
  OnAccept = function() end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

function GridStatusRaidDebuff:OnInitialize()
	self:Print("GridStatusRaidDebuff has moved to GridStatusRaidDebuff MoP.")
	self:Print("http://www.curse.com/addons/wow/gridstatusraiddebuff-mop")
	self:Print("Please switch to the new addon.")
	self:Print("Sorry for the inconvenience.")
end

function GridStatusRaidDebuff:OnEnable()
	-- self.msgFrame = CreateFrame("MessageFrame")
	-- self.msgFrame.owner = self
	-- self.msgFrame:ClearAllPoints()
	-- self.msgFrame:SetWidth(400)
	-- self.msgFrame:SetHeight(200)
	-- self.msgFrame:SetPoint("TOP", self.dragButton, "TOP", 0, 0)
	-- self.msgFrame:SetInsertMode("TOP")
	-- self.msgFrame:SetFrameStrata("HIGH")
	-- self.msgFrame:SetToplevel(true)

	-- self.msgFrame:Show()

	self:UnregisterAllEvents()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function GridStatusRaidDebuff:PLAYER_ENTERING_WORLD()
	-- self:Print("Player entering world.")
	self:Print("GridStatusRaidDebuff has moved to GridStatusRaidDebuff MoP.")
	self:Print("http://www.curse.com/addons/wow/gridstatusraiddebuff-mop")
	self:Print("Please switch to the new addon.")
	self:Print("Sorry for the inconvenience.")

	StaticPopup_Show("GridStatusRaidDebuff")

	-- local r = 1
        -- local g = 0.5
        local b = 0.5

	-- self.msgFrame:SetTimeVisible(60)
	-- self.msgFrame:AddMessage("GridStatusRaidDebuff has moved to GridStatusRaidDebuff MoP.", r, g, b, 1, 60)
	-- self.msgFrame:AddMessage("http://www.curse.com/addons/wow/gridstatusraiddebuff-mop", r, g, b, 1, 60)
	-- self.msgFrame:AddMessage("Please switch to the new addon.", r, g, b, 1, 60)
end

function GridStatusRaidDebuff:OnDisable()
end

function GridStatusRaidDebuff:BossName(en_zone, order, en_boss)
	-- Too spammy
	-- self:Print("GridStatusRaidDebuff has moved to GridStatusRaidDebuff MoP.")
end

function GridStatusRaidDebuff:Debuff(en_zone, first, second, icon_priority, color_priority, timer, stackable, color, default_disable, noicon)
	-- Too spammy
	-- self:Print("GridStatusRaidDebuff has moved to GridStatusRaidDebuff MoP.")
end

