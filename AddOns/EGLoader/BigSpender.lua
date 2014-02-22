local _, common = ...

local name = "BigSpender"

-- LoadAddOn() silently fails if the addon isn't installed.

common.funcs[name] = function()
	common.eventFrame:RegisterEvent('MERCHANT_SHOW')
	common.eventFrame.MERCHANT_SHOW = function(self, event, ...)
		self:handler(name, event, ...)
	end
	ChatFrame1:AddMessage(name .. " standing by.")
end

common.RegisterAddon(name)
