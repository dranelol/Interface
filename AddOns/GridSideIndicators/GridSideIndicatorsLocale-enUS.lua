-- Please make sure to save this file as UTF-8. ¶

GridSideIndicators_Locales =

{
	["Top Side"] = true,
	["Right Side"] = true,
	["Bottom Side"] = true,
	["Left Side"] = true,
}

function GridSideIndicators_Locales:CreateLocaleTable(t)
	for k,v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

GridSideIndicators_Locales:CreateLocaleTable(GridSideIndicators_Locales)