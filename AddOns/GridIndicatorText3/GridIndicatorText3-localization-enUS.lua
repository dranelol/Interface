-- -------------------------------------------------------------------------- --
-- GridIndicatorText3 DEFAULT (english) Localization                          --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --

GridIndicatorText3_Locales =

{
	["Center Text 3 (Middle)"] = true,
	["Options for Center Text 3 (Middle)."] = true,

	["Offset"] = true,
	["Adjust the offset for Center Text 3 (Middle)."] = true,

	["Same font and font size as Grid standard"] = true,
	["If enabled, the font and font size of the Text 3 indicator is adjustable with the standard Grid font options. If deactivated, you can set an individual font and font size for the Text 3 indicator."] = true,

	["Font Size"] = true,
	["Adjust the font size for Center Text 3 (Middle)."] = true,

	["Font"] = true,
	["Adjust the font setting for Center Text 3 (Middle)."] = true,
	
	["Configuration Mode"] = true,
}

function GridIndicatorText3_Locales:CreateLocaleTable(t)
	for k,v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

GridIndicatorText3_Locales:CreateLocaleTable(GridIndicatorText3_Locales)