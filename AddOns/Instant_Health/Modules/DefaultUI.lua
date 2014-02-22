local healthBar = {}

-- Copy of blizzards function with 2 commented changes
function IH_UnitFrameHealthBar_Update(statusbar, unit)
	if ( not statusbar ) then
		return;
	end
	
	if ( unit == statusbar.unit ) then
	
		-- Remembers what healthbar belongs to what unit, not strictly needed updating it here, but it's the easiest way to catch any changes
		-- such as when the party or raid changes or the user pulls out a new raid group
		healthBar[unit] = statusbar
		
		local currValue = IH_UnitHealth(unit); -- Replaced UnitHealth(unit) with IH_UnitHealth(unit)
		local maxValue = UnitHealthMax(unit);

		statusbar.showPercentage = nil;
		
		-- Safety check to make sure we never get an empty bar.
		statusbar.forceHideText = false;
		if ( maxValue == 0 ) then
			maxValue = 1;
			statusbar.forceHideText = true;
		elseif ( maxValue == 100 ) then
			--This should be displayed as percentage.
			statusbar.showPercentage = true;
		end

		statusbar:SetMinMaxValues(0, maxValue);

		if ( not UnitIsConnected(unit) ) then
			statusbar:SetStatusBarColor(0.5, 0.5, 0.5);
			statusbar:SetValue(maxValue);
		else
			statusbar:SetStatusBarColor(0.0, 1.0, 0.0);
			statusbar:SetValue(currValue);
		end
	end
	TextStatusBar_UpdateTextString(statusbar);
end

-- calls the modified blizzard function providing the healthBar belonging to this unitID if it's known
function IH_FindHealthBar(unit)
	IH_UnitFrameHealthBar_Update(healthBar[unit], unit)
end

-- To minimize conflicts with other 3rd party addons this addon makes a secure post hook to blizzards function and upates
-- the health again after rather then unregestering any events. The performance impact should be minimal.
hooksecurefunc("UnitFrameHealthBar_Update", IH_UnitFrameHealthBar_Update)

IH_Register("Blizzard", IH_FindHealthBar, true) -- Register function to be called when a units health changes