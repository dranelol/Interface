
if (WorldFrame.onVariablesLoadedHandlers == nil) then
	WorldFrame.onVariablesLoadedHandlers = {};
	WorldFrame:RegisterEvent("VARIABLES_LOADED");
	local orig = WorldFrame:GetScript("OnEvent");
	local new;
	new = function(self, event, ...)
		if (event == "VARIABLES_LOADED") then
			local success, errorText;
			for handlerObj, handlerKey in pairs(self.onVariablesLoadedHandlers) do
				if (handlerKey == true) then
					success, errorText = pcall(handlerObj);
				else
					success, errorText = pcall(handlerObj[handlerKey]);
				end
				if (success == false) then
					geterrorhandler()(errorText);
				end
			end
			self.onVariablesLoadedHandlers = nil;
			if (self:GetScript("OnEvent") == new) then
				self:UnregisterEvent("VARIABLES_LOADED");
				self:SetScript("OnEvent", orig);
			end
		end
		if (orig ~= nil) then
			return orig(self, event, ...);
		end
	end
	WorldFrame:SetScript("OnEvent", new);
end
-- WorldFrame.onVariablesLoadedHandlers[YOUR_FUNCTION_OR_TABLE] = (true or "KEY_IN_TABLE");
