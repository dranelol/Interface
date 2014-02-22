
local o = VendorValues;

if (o.Localization ~= nil) then return; end
-- This localization file is the fallback in case no others load, so the following line should remain commented out.
--if (GetLocale() ~= "enUS") then return; end


o.Localization = {
DEFAULT_PREFIX = ("Vendor value:");
DEFAULT_PREFIX_STACK = ("Vendor value for %d:");

SLASH_COMMANDS = {
	PREFIX = ("prefix <text> - Set the tooltip money line prefix text for non-stackable items. The default is \"Vendor value:\". Leave <text> blank to reset to default.");
	PREFIX_STACK = ("prefix-stack <text> - Set the tooltip money line prefix text for stackable items. The text should contain the token \"%d\" to represent the number of items in the stack. The default is \"Vendor value for %d:\". Leave <text> blank to reset to default.");
	HIDE_PREFIX = ("hide-prefix - Toggle whether the tooltip money line prefix text is completely hidden. By default it is shown.");
	HIDE_SEPARATOR = ("hide-separator - Toggle whether the separator line between the vendor price line and the rest of the tooltip will be hidden. By default it is shown.");
	RGB = ("rgb <r> <g> <b> - Set the RGB value for the color of the vendor price tooltip text. These should be numbers from 0.0 to 1.0. By default, the RGB is 1.0, 1.0, 1.0. Leave the values blank to reset to default.");
	UNKNOWN = ("Unknown or invalid slash command, \"%s\". Listing all slash commands...");
};

TYPE_RECIPE = ("Recipe");
};
