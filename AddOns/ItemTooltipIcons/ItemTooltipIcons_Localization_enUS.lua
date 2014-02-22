
local o = ItemTooltipIcons;

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
SLASH_COMMANDS = {
	SIZE = ("size <number> - Sets the width and height of the icon to <number>, a size in pixels. Defaults to 36.");
	ICON_POINT = ("icon-point <point> - Sets the point on the icon which will be ancohred to the relative point on the tooltip to <point>. Valid values are any combination of [TOP / BOTTOM][LEFT / RIGHT]. Defaults to TOPLEFT.");
	TOOLTIP_POINT = ("tooltip-point <point> - Sets the point on the tooltip to which the icon will be attached to <point>. Valid values are any combination of [TOP / BOTTOM][LEFT / RIGHT]. Defaults to TOPRIGHT.");
	TOGGLE_TOOLTIP = ("toggle-tooltip <tooltip name> - Toggles whether the tooltip named <tooltip name> will have an icon for items. By default only the two default UI tooltips, \"GameTooltip\" and \"ItemRefTooltip\", have this. This is case sensitive.");
	UNKNOWN = ("Unknown or invalid slash command, \"%s\". Listing all slash commands...");
};
};
