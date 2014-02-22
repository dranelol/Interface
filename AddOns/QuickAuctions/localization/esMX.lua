if( GetLocale() ~= "esMX" ) then return end
local L = {}

local QuickAuctions = select(2, ...)
QuickAuctions.L = setmetatable(L, {__index = QuickAuctions.L})
