local clsaver = LibStub("AceAddon-3.0"):NewAddon(
  "clsaver", "AceEvent-3.0", "AceConsole-3.0")

function clsaver:OnInitialize()
  local defaults = {
    profile = {
      zone_overrides = {},
    }
  }
  self.db = LibStub("AceDB-3.0"):New("clsaver_DB", defaults, true)
  self.version = GetAddOnMetadata("clsaver", "Version")
  self:RegisterChatCommand("clsaver", "ProcessCommand")
end

function clsaver:PrintHelp()
  local help = {
    "CombatLog Saver - "..self.version,
    "   CombatLog logging is on when you are inside a raid instance, unless there is an override",
    "   list - Lists zones that have an override",
    "   override <on/off/none> - Sets an override for the current zone. none reverts to default which is logging when inside a raid instance",
  }
  self:Print(table.concat(help, "\n"))
end

function clsaver:ProcessCommand(str)
  local command, nextposition = self:GetArgs(str, 1)
  if command == "list" then
    self:ListZoneOverrides()
  elseif command == "override" then
    local arg = self:GetArgs(str, 1, nextposition)
    if arg == "on" then
      arg = true
    elseif arg == "off" then
      arg = false
    elseif arg == "none" then
      arg = nil
    else
      self:PrintHelp()
      return
    end
    self.db.profile.zone_overrides[GetRealZoneText()] = arg
    self:Reconfigure()
  else
    self:PrintHelp()
  end
end

local function Colorize(s, r, g, b, a)
  a = a or 1
  return string.format("|c%.2x%.2x%.2x%.2x%s|r",
                       a * 255, r * 255, g * 255, b * 255, s)
end

local function ColorizeBlizz(s, c)
  return Colorize(s, c.r, c.g, c.b)
end

local function TooltipOnUpdate(self)
  self:Clear()
  self:AddLine(ColorizeBlizz(clsaver:GetName(), NORMAL_FONT_COLOR))
  self:AddLine("Logging is enabled by default when you enter a raid instance")
  self:AddLine(" ")
  self:AddLine("Left-click to toggle logging")
  self:AddLine("Right-click to remove override")
  self:AddLine(" ")

  if not next(clsaver.db.profile.zone_overrides) then
    self:AddLine(ColorizeBlizz("No zone overrides", NORMAL_FONT_COLOR))
  else
    self:AddLine(ColorizeBlizz("Zone overrides", NORMAL_FONT_COLOR))
    for z,v in pairs(clsaver.db.profile.zone_overrides) do
      if v then
        self:AddLine(z, ColorizeBlizz("Enabled", GREEN_FONT_COLOR))
      else
        self:AddLine(z, ColorizeBlizz("Disabled", RED_FONT_COLOR))
      end
    end
  end
end

function GetColoredStatusText()
  if LoggingCombat() then
    return ColorizeBlizz("CombatLog Enabled", GREEN_FONT_COLOR)
  else
    return ColorizeBlizz("CombatLog Disabled", RED_FONT_COLOR)
  end
end

function GetIconPath()
  if LoggingCombat() then
    return "Interface\\RaidFrame\\ReadyCheck-Ready"
  else
    return "Interface\\RaidFrame\\ReadyCheck-NotReady"
  end
end

function clsaver:SetupLDB()
  local LDB = LibStub("LibDataBroker-1.1")
  if not LDB then return end
  if self.ldb then return end
  local QTip = LibStub("LibQTip-1.0")

  self.ldb = LDB:NewDataObject(
    "clsaver",
    {
      type = "data source",
      text = "clsaver",
      icon = GetIconPath(),
      OnClick = function(self, button)
                  val = clsaver.db.profile.zone_overrides[GetRealZoneText()]
                  if button == "RightButton" then
                    clsaver.db.profile.zone_overrides[GetRealZoneText()] = nil
                  elseif button == "LeftButton" then
                    val = not clsaver:IsZoneTracked()
                    clsaver.db.profile.zone_overrides[GetRealZoneText()] = val
                  end
                  clsaver:Reconfigure()
                end,
      OnEnter = function(self)
                  local tooltip =
                    QTip:Acquire("clsaver_Tooltip", 2, "LEFT", "RIGHT")
                  self.tooltip = tooltip
                  tooltip:SetScript("OnUpdate", TooltipOnUpdate)
                  tooltip:SmartAnchorTo(self)
                  tooltip:Show()
                end,
      OnLeave = function(self)
                  QTip:Release(self.tooltip)
                  self.tooltip = nil
                end,
    })
end

function clsaver:OnEnable()
  self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Reconfigure")
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "Reconfigure")
  self:SetupLDB()
  self:Reconfigure()
end

function clsaver:IsInRaidInstance()
  local inInstance, instanceType = IsInInstance()
  if not inInstance then
    return false
  end
  if not (instanceType == "party" or instanceType == "raid") then
    return false
  end
  return UnitInRaid("player")
end

function clsaver:IsZoneTracked()
  local override = self.db.profile.zone_overrides[GetRealZoneText()]
  if override ~= nil then
    return override
  else
    return self:IsInRaidInstance()
  end
end

function clsaver:ListZoneOverrides()
  if next(self.db.profile.zone_overrides) then
    self:Print("Zone overrides")
    for z,s in pairs(self.db.profile.zone_overrides) do
      self:Print(string.format("* %s %s", z, s and "on" or "off"))
    end
  else
    self:Print("No zone overrides")
  end
end

local function xor(a, b)
  return (a and not b) or (not a and b)
end

function clsaver:Reconfigure()
  if xor(self:IsZoneTracked(), LoggingCombat()) then
    LoggingCombat(not LoggingCombat())
    UIErrorsFrame:AddMessage(GetColoredStatusText())
    if self.ldb then
      self.ldb.icon = GetIconPath()
    end
  end
end
