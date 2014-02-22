
--[[
assert(NicheDevTools);
assert(NicheDevTools.PARSING_TOOLTIP);
--]]


InspectNameFrame:SetWidth(250);
InspectNameText:SetWidth(250);



do
	InspectPaperDollFrame_SetLevel = function()
		local unit = InspectFrame.unit;
		if (UnitExists(unit) == nil) then
			return;
		end
		
		local tooltip = NicheDevTools.PARSING_TOOLTIP;
		tooltip:SetOwner(UIParent, "ANCHOR_NONE");
		tooltip:SetUnit(unit);
		InspectNameText:SetText(tooltip.leftLines[1]:GetText());
		
		InspectLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel(unit), (UnitRace(unit)), (UnitClass(unit)));
		
		local guildName, guildTitle, guildRank = GetGuildInfo(unit);
		if (guildName ~= nil) then
			InspectTitleText:SetFormattedText(GUILD_TITLE_TEMPLATE, (guildTitle .. " (" .. (guildRank + 1) .. ")"), guildName);
			InspectTitleText:Show();
		else
			InspectTitleText:Hide();
		end
	end
end
