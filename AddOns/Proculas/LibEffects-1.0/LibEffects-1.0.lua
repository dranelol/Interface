--[[
   LibEffects-1.0
   Revision: $Rev: 3 $
   Description: Allows you to easily add effects to your addon.
   Dependencies: LibStub
   Copyright (c) 2008 Clorell
]]

local MAJOR,MINOR = "LibEffects-1.0", tonumber(("$Rev: 3 $"):match("(%d+)")) or 0
if not LibStub then error(MAJOR .. " requires LibStub.") end
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local type = type
local pcall = pcall
local pairs = pairs
local assert = assert
local concat = table.concat
local loadstring = loadstring
local next = next
local select = select
local type = type
local xpcall = xpcall

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function CreateDispatcher(argCount)
	local code = [[
	local next, xpcall, eh = ...

	local method, ARGS
	local function call() method(ARGS) end

	local function dispatch(handlers, ...)
		local index
		index, method = next(handlers)
		if not method then return end
		local OLD_ARGS = ARGS
		ARGS = ...
		repeat
			xpcall(call, eh)
			index, method = next(handlers, index)
		until not method
		ARGS = OLD_ARGS
	end

	return dispatch
	]]

	local ARGS, OLD_ARGS = {}, {}
	for i = 1, argCount do ARGS[i], OLD_ARGS[i] = "arg"..i, "old_arg"..i end
	code = code:gsub("OLD_ARGS", concat(OLD_ARGS, ", ")):gsub("ARGS", concat(ARGS, ", "))
	return assert(loadstring(code, "safecall Dispatcher["..argCount.."]"))(next, xpcall, errorhandler)
end

local Dispatchers = setmetatable({}, {__index=function(self, argCount)
	local dispatcher = CreateDispatcher(argCount)
	rawset(self, argCount, dispatcher)
	return dispatcher
end})

lib.embeds = lib.embeds or {}

do
	local mixins = { "Flash", "Shake", "AddSound", "PlaySound", "UpdateSound" }
	function lib:Embed(target)
		for k, v in pairs( mixins ) do
			target[v] = self[v]
		end
		lib.embeds[target] = true
		return target
	end
end

--[[
   AddSound(unique name, file location)
   use :AddSound() to add sounds to the sound array for easy access later.
]]
function lib:AddSound(name,location)
	if not self.sounds then self.sounds = {} end
	if(self.sounds[name]) then print("|cffff0000"..MAJOR.." Error:|r the sound name '"..name.."' is already in use.") end
	self.sounds[name] = location
end

--[[
   PlaySound(unique name)
   use :PlaySound() to play the sound with the unique name in the sounds array.
]]
function lib:PlaySound(name)
	PlaySoundFile(self.sounds[name])
end

--[[
   UpdateSound(unique name)
   use :UpdateSound() to update the sound file location.
]]
function lib:UpdateSound(name,location)
	self.sounds[name] = location
end

--[[
   Flash()
   use :Flash() to flash the screen border.
]]
function lib:Flash()
	if not self.FlashFrame then
		local flasher = CreateFrame("Frame", "LibEffectsFlashFrame")
		flasher:SetToplevel(true)
		flasher:SetFrameStrata("FULLSCREEN_DIALOG")
		flasher:SetAllPoints(UIParent)
		flasher:EnableMouse(false)
		flasher:Hide()
		flasher.texture = flasher:CreateTexture(nil, "BACKGROUND")
		flasher.texture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
		flasher.texture:SetAllPoints(UIParent)
		flasher.texture:SetBlendMode("ADD")
		flasher:SetScript("OnShow", function(self)
			self.elapsed = 0
			self:SetAlpha(0)
		end)
		flasher:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed < 2.6 then
				local alpha = elapsed % 1.3
				if alpha < 0.15 then
					self:SetAlpha(alpha / 0.15)
				elseif alpha < 0.9 then
					self:SetAlpha(1 - (alpha - 0.15) / 0.6)
				else
					self:SetAlpha(0)
				end
			else
				self:Hide()
			end
			self.elapsed = elapsed
		end)
		self.FlashFrame = flasher
	end
	self.FlashFrame:Show()
end

--[[
   Shake()
   use :Shake() to shake the screen.
]]
function lib:Shake()
	local shaker = self.ShakerFrame
	if not shaker then
		shaker = CreateFrame("Frame", "LibEffectsShakerFrame", UIParent)
		shaker:Hide()
		shaker:SetScript("OnUpdate", function(self, elapsed)
			elapsed = self.elapsed + elapsed
			local x, y = 0, 0 -- Resets to original position if we're supposed to stop.
			if elapsed >= 0.8 then
				self:Hide()
			else
				x, y = random(-8, 8), random(-8, 8)
			end
			if WorldFrame:IsProtected() and InCombatLockdown() then
				if not shaker.fail then
					print("|cffff0000"..MAJOR.." Error:|r cannot use shake effects if you have turned on nameplates at least once since logging in.")
					shaker.fail = true
				end
				self:Hide()
			else
				WorldFrame:ClearAllPoints()
				for i = 1, #self.originalPoints do
					local v = self.originalPoints[i]
					WorldFrame:SetPoint(v[1], v[2], v[3], v[4] + x, v[5] + y)
				end
			end
			self.elapsed = elapsed
		end)
		shaker:SetScript("OnShow", function(self)
			-- Store old worldframe positions as we need them all,
			-- some people have frame modifiers for it
			if not self.originalPoints then
				self.originalPoints = {}
				for i = 1, WorldFrame:GetNumPoints() do
					tinsert(self.originalPoints, {WorldFrame:GetPoint(i)})
				end
			end
			self.elapsed = 0
		end)
		self.ShakerFrame = shaker
	end

	shaker:Show()
end
