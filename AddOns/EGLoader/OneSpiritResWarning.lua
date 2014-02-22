local _, common = ...

local name = "OneSpiritResWarning"

-- LoadAddOn() silently fails if the addon isn't installed.

common.funcs[name] = function()
	common.eventFrame:RegisterEvent('CONFIRM_XP_LOSS')
	common.eventFrame.CONFIRM_XP_LOSS = function(self, event, ...)
		self:handler(name, event, ...)
	end
	
	ChatFrame1:AddMessage(name .. " standing by.")
end

common.RegisterAddon(name)
