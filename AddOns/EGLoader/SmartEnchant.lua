local _, common = ...

local name = "SmartEnchant"

common.funcs[name] = function(self)
	self.eventFrame:handler(name)
end

common.RegisterAddon(name)
