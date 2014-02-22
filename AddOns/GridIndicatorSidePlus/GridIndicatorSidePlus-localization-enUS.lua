-- -------------------------------------------------------------------------- --
-- GridIndicatorSidePlus DEFAULT (english) Localization                       --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --

GridIndicatorSidePlus_Locales =

{
	["Side Plus"] = true,
	["Options for Side Plus."] = true,
	["Side Plus Space"] = true,
	["Adjust the space between the Side Plus indicators."] = true,
	["Side Plus Offset"] = true,
	["Adjust the offset for the Side Plus indicators."] = true,
	["Same size as Grid standard"] = true,
	["If enabled, the size of the Side Plus indicator is adjustable with the standard Grid corner option. If deactivated, you can set an individual size for the Side Plus indicators."] = true,
	["Side Plus Size"] = true,
	["Adjust the size of the Side Plus indicators."] = true,

	["Top Side"] = true,
	["Options for Top Side indicators."] = true,
	["Top Side (left)"] = true,
	["Top Side (center)"] = true,
	["Top Side (right)"] = true,

	["Bottom Side"] = true,
	["Options for Bottom Side indicators."] = true,
	["Bottom Side (left)"] = true,
	["Bottom Side (center)"] = true,
	["Bottom Side (right)"] = true,

	["Left Side"] = true,
	["Options for Left Side indicators."] = true,
	["Left Side (top)"] = true,
	["Left Side (center)"] = true,
	["Left Side (bottom)"] = true,

	["Right Side"] = true,
	["Options for Right Side indicators."] = true,
	["Right Side (top)"] = true,
	["Right Side (center)"] = true,
	["Right Side (bottom)"] = true,

	["Configuration Mode"] = true,
	["Shows all Side Plus indicators."] = true,
}

function GridIndicatorSidePlus_Locales:CreateLocaleTable(t)
	for k,v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

GridIndicatorSidePlus_Locales:CreateLocaleTable(GridIndicatorSidePlus_Locales)