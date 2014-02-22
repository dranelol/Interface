
do
	local NDT = NicheDevTools;
	if (NDT == nil) then
		NDT = {};
		NicheDevTools = NDT;
	end
	
	if (NDT.PARSING_TOOLTIP == nil) then
		local tooltip = CreateFrame("GameTooltip", "NicheDevTools_ParsingTooltip", WorldFrame, nil);
		NDT.PARSING_TOOLTIP = tooltip;
		
		local leftLines, rightLines = {}, {};
		tooltip.leftLines, tooltip.rightLines = leftLines, rightLines;
		local metatable = {
			__index = (function(self, key)
				if (type(key) == "number") then
					local line = _G["NicheDevTools_ParsingTooltipText" .. ((self == leftLines and "Left") or "Right") .. key];
					if (line ~= nil) then
						self[key] = line;
					end
					return line;
				else
					return rawget(self, key);
				end
			end);
		};
		setmetatable(leftLines, metatable);
		setmetatable(rightLines, metatable);
		-- The GameTooltip object seems to expect the first 8 lines to already be there, like with GameTooltipTemplate.
		for index = 1, 8, 1 do
			tooltip:AddFontStrings(
				tooltip:CreateFontString("NicheDevTools_ParsingTooltipTextLeft" .. index),
				tooltip:CreateFontString("NicheDevTools_ParsingTooltipTextRight" .. index)
			);
		end
		
		tooltip:SetScript("OnTooltipAddMoney", (function(self, money) self.currentMoneyValue = money; end));
	end
end
