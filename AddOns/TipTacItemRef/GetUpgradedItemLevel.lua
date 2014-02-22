-- GetUpgradedItemLevelFromItemLink() -- REV-04 -- Modified: 13.09.21
-- Until Blizzard adds an easier solution, this function is supposed to be portable between addons, and is placed in the global namespace.
-- REV-04: Patch 5.4: Added IDs 491 to 498 to the table.
-- REV-03: Patch 5.3: Added the 465/466/467 IDs (0/4/8 lvls) to the table.
-- REV-02: Patch 5.2: Added the 470 ID (8 lvls) to the table.

-- Make sure we do not override a newer revision.
local REVISION = 4;
if (type(GET_UPGRADED_ITEM_LEVEL_REV) == "number") and (GET_UPGRADED_ITEM_LEVEL_REV >= REVISION) then
	return;
end
GET_UPGRADED_ITEM_LEVEL_REV = REVISION;

-- ItemLink pattern
local ITEMLINK_PATTERN = "(item:[^|]+)";
-- Finds the last and 11th parameter of an itemLink, which is the upgradeId
local ITEMLINK_PATTERN_UPGRADE = ":(%d+)$";
-- Table for adjustment of levels due to upgrade -- Source: http://www.wowinterface.com/forums/showthread.php?t=45388
local UPGRADED_LEVEL_ADJUST = {
	[001] = 8, -- 1/1
	-- Patch 5.1 --
	[373] = 4, -- 1/2
	[374] = 8, -- 2/2
	[375] = 4, -- 1/3
	[376] = 4, -- 2/3
	[377] = 4, -- 3/3
	[379] = 4, -- 1/2
	[380] = 4, -- 2/2
--	[445] = 0, -- 0/2
	[446] = 4, -- 1/2
	[447] = 8, -- 2/2
--	[451] = 0, -- 0/1
	[452] = 8, -- 1/1
--	[453] = 0, -- 0/2
	[454] = 4, -- 1/2
	[455] = 8, -- 2/2
--	[456] = 0, -- 0/1
	[457] = 8, -- 1/1
--	[458] = 0, -- 0/4
	[459] = 4, -- 1/4
	[460] = 8, -- 2/4
	[461] = 12, -- 3/4
	[462] = 16, -- 4/4
	-- Patch 5.3 --
--	[465] = 0,
	[466] = 4,
	[467] = 8,
	-- Patch ?? --
--	[468] = 0,
	[469] = 4,
	[470] = 8,
	[471] = 12,
	[472] = 16,
	-- Patch 5.4 --
--	[491] = 0,
	[492] = 4,
	[493] = 8,
--	[494] = 0,
	[495] = 4,
	[496] = 8,
	[497] = 12,
	[498] = 16,
};

-- Analyses the itemLink and checks for upgrades that affects itemLevel -- Only itemLevel 450 and above will have this
function GetUpgradedItemLevelFromItemLink(itemLink)
	-- Make certain we only have the raw itemLink, and not the full itemString
	itemLink = itemLink:match(ITEMLINK_PATTERN);
	local _, _, _, itemLevel = GetItemInfo(itemLink);
	local upgradeId = tonumber(itemLink:match(ITEMLINK_PATTERN_UPGRADE));
	if (itemLevel) and (itemLevel >= 450) and (upgradeId) and (UPGRADED_LEVEL_ADJUST[upgradeId]) then
		return itemLevel + UPGRADED_LEVEL_ADJUST[upgradeId];
	else
		return itemLevel;
	end
end