--[[
AtlasLoot_GetLocaleLibBabble(typ)
Get english translations for non translated things. (Combines Locatet and English table)
Only Useable with LibBabble
]]
function AtlasLoot_GetLocaleLibBabble(typ)
	local tab = LibStub(typ):GetBaseLookupTable()
	local loctab = LibStub(typ):GetUnstrictLookupTable()
	local rettab = {}
	
	setmetatable(rettab, {
		__index = tab or loctab
	})
	
	return rettab
end

