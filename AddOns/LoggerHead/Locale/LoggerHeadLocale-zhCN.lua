local ADDON_NAME, ADDON_TABLE = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhCN")
if not L then return end

L["Click to toggle combat logging"] = "点击开启/关闭记录战斗日志"
L["Enable Chat Logging"] = "启用聊天纪录"
L["Enable Chat Logging whenever the Combat Log is enabled"] = "无论战斗纪录是否启用都启用聊天纪录"
L["Instances"] = "副本"
L["Output"] = "输出提示"
L["Profiles"] = "配置文件"
L["Prompt on new zone?"] = "切换地区时询问?"
L["Prompt when entering a new zone?"] = "切换地区时询问是否记录战斗日志?"
L["Right-click to open the options menu"] = "右键点击打开选项菜单"
L["Show minimap icon"] = "显示小地图图标"
L["Toggle showing or hiding the minimap icon."] = "显示或隐藏小地图图标."
L["You have entered |cffd9d919%s %s|r. Enable logging for this area?"] = "你已经进入 |cffd9d919%s %s.|r 你想要为此地区/副本记录战斗日志吗？" -- Needs review

