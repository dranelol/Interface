if( GetLocale() ~= "zhCN" ) then return end
local L = {}
L[ [=[

%d in inventory
%d on the Auction House]=] ] = [=[

背包中%d
拍卖行中%d]=] -- Needs review
L["/qa config - Toggles the configuration"] = "/qa config - 打开/关闭配置" -- Needs review
L["12 hours"] = "12 小时" -- Needs review
L["24 hours"] = "24 小时" -- Needs review
L["48 hours"] = "48 小时" -- Needs review
L["Add group"] = "添加类别" -- Needs review
L["Add items"] = "添加物品" -- Needs review
L["Add items/groups"] = "添加物品/类别" -- Needs review
L["Add player"] = "添加玩家" -- Needs review
L["Are you SURE you want to delete this group?"] = "确定要删除此类别？" -- Needs review
L["Auction settings"] = "拍卖行设置" -- Needs review
L["Auto mail"] = "自动邮件" -- Needs review
L["Delete"] = "删除" -- Needs review
L["Delete group"] = "删除类别" -- Needs review
L["Delete this group, this cannot be undone!"] = "删除此类别，不可恢复！" -- Needs review

local QuickAuctions = select(2, ...)
QuickAuctions.L = setmetatable(L, {__index = QuickAuctions.L})
