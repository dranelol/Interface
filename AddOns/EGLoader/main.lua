local name, common = ...

common.addons = {}
common.funcs = {}

common.eventFrame = CreateFrame('Frame')
common.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

common.eventFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

common.eventFrame.PLAYER_ENTERING_WORLD = function(self, event, ...)
	for addon in pairs(common.addons) do
		local _, _, _, _, loadable, _, _ = GetAddOnInfo(addon)
		local loaded = IsAddOnLoaded(addon)
		if loadable and not loaded then
			common.funcs[addon](common)
		end
	end
end

common.RegisterAddon = function(addon)
	common.addons[addon] = 1
end

local version = GetAddOnMetadata(name, "Version")
common.debug = version:match("project%-version")

if common.debug then
	print("Loading " .. name)
end

common.eventFrame.handler = function(self, addon, event, ...)
	LoadAddOn(addon)
	if event then
		self:UnregisterEvent(event)
	end
end
