
local o = ItemTooltipIcons;

-- Tooltips_RegisterTooltip: (tooltip)
-- Tooltips_UnregisterTooltip: (tooltip)
--
-- Tooltips_h_OnTooltipSetItem: (tooltip)
-- Tooltips_h_OnHide: (tooltip)
-- Tooltips_h_SetHyperlink: (tooltip, hyperlink)
--
-- Tooltips_OnConfigChanged: ()
-- Tooltips_SetupIcon: (icon)




function o.Tooltips_RegisterTooltip(tooltip)
	if (not tooltip.ItemTooltipIcons_ICON) then
		if (tooltip.ItemTooltipIcons_ICON == nil) then
			tooltip.ItemTooltipIcons_orig_OnTooltipSetItem = tooltip:GetScript("OnTooltipSetItem");
			tooltip:SetScript("OnTooltipSetItem", o.Tooltips_h_OnTooltipSetItem);
			tooltip.ItemTooltipIcons_orig_OnHide = tooltip:GetScript("OnHide");
			tooltip:SetScript("OnHide", o.Tooltips_h_OnHide);
			tooltip.ItemTooltipIcons_orig_SetHyperlink = tooltip.SetHyperlink;
			tooltip.SetHyperlink = o.Tooltips_h_SetHyperlink;
		end
		
		local icon = tooltip:CreateTexture((tooltip:GetName() .. "ItemTooltipIconsIconTexture"), "ARTWORK", nil);
		tooltip.ItemTooltipIcons_ICON = icon;
		icon:Hide();
		o.Tooltips_SetupIcon(icon);
	end
end



function o.Tooltips_UnregisterTooltip(tooltip)
	if (tooltip.ItemTooltipIcons_ICON) then
		tooltip.ItemTooltipIcons_ICON:Hide();
		tooltip.ItemTooltipIcons_ICON = false;
	end
end




do
	local GetItemIcon = GetItemIcon;
	
	function o.Tooltips_h_OnTooltipSetItem(tooltip)
		local icon = tooltip.ItemTooltipIcons_ICON;
		if (icon ~= false) then
			local texture;
			local _, link = tooltip:GetItem();
			if (link ~= nil) then
				texture = GetItemIcon(link);
			end
			if (texture ~= nil) then
				icon:SetTexture(texture);
				icon:Show();
			else
				icon:Hide();
			end
		end
		
		local orig = tooltip.ItemTooltipIcons_orig_OnTooltipSetItem;
		if (orig) then orig(tooltip); end
	end
end



function o.Tooltips_h_OnHide(tooltip)
	if (tooltip.ItemTooltipIcons_ICON ~= false) then
		tooltip.ItemTooltipIcons_ICON:Hide();
	end
	
	local orig = tooltip.ItemTooltipIcons_orig_OnHide;
	if (orig) then orig(tooltip); end
end



function o.Tooltips_h_SetHyperlink(tooltip, hyperlink)
	if (tooltip.ItemTooltipIcons_ICON ~= false) then
		tooltip.ItemTooltipIcons_ICON:Hide();
	end
	
	tooltip.ItemTooltipIcons_orig_SetHyperlink(tooltip, hyperlink);
end




function o.Tooltips_OnConfigChanged()
	local _G = _G;
	local tooltip;
	for tooltipName in pairs(ItemTooltipIcons_Config) do
		tooltip = _G[tooltipName];
		if (tooltip ~= nil and tooltip.ItemTooltipIcons_ICON) then
			o.Tooltips_SetupIcon(tooltip.ItemTooltipIcons_ICON);
		end
	end
end



function o.Tooltips_SetupIcon(icon)
	local config = ItemTooltipIcons_Config;
	icon:SetWidth(config.size);
	icon:SetHeight(config.size);
	icon:ClearAllPoints();
	icon:SetPoint(config.iconPoint, icon:GetParent(), config.tooltipPoint, 0, 0);
end
