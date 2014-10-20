--[[
	Replacement library for SetBackDrop
	Blizzard decided they want to deprecate SetBackDrop, so this library is intended as a replacement for simple table drop
	and decorate a given frame with a backdrop.
	Credits to Lilsparky for doing the math for cutting up the quadrants
--]]
local MAJOR, MINOR = "LibBackdrop-1.0", 3
local Backdrop, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not Backdrop then return end -- No upgrade needed

local MakeFrame = CreateFrame

local edgePoints = {
	TOPLEFTCORNER = "TOPLEFT",
	TOP = "TOP",
	TOPRIGHTCORNER = "TOPRIGHT",
	LEFT = "LEFT",
	RIGHT = "RIGHT",
	BOTLEFTCORNER = "BOTTOMLEFT",
	BOT = "BOTTOM",
	BOTRIGHTCORNER = "BOTTOMRIGHT"
}

--- API
-- This method will embed the new backdrop functionality onto your frame
-- This will replace the standard SetBackdropxxx functions and will add
-- the following functions to your frame.
-- SetBackdropGradient(orientation,minR,minG,minB,maxR,maxG,maxB) setup a gradient on the bg texture
-- SetBackdropGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA) setup a gradient on the bg texture
-- SetBackdropBorderGradient(orientation,minR,minG,minB,maxR,maxG,maxB) setup a gradient on the border texture
-- SetBackdropBorderGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA) setup a gradient on the border texture
-- @param frame to enhance

function Backdrop:EnhanceBackdrop(frame)
	if frame._backdrop then return end

	-- Create our enhancement frame we will use to create the backdrop
	frame._backdrop = MakeFrame("Frame",nil,frame)
	frame._backdrop.bgTexture = frame:CreateTexture(nil,"BACKGROUND")
	frame._backdrop.edgeTextures = {}
	for point in pairs(edgePoints) do
		local texture = frame:CreateTexture(nil,"BORDER")
		frame._backdrop.edgeTextures[point] = texture
	end

	-- Save original methods
	frame._SetBackdrop = frame.SetBackdrop
	frame._GetBackdrop = frame.GetBackdrop
	frame._SetBackdropColor = frame.SetBackdropColor
	frame._GetBackdropColor = frame.GetBackdropColor
	frame._SetBackdropBorderColor = frame.SetBackdropBorderColor
	frame._GetBackdropBorderColor = frame.GetBackdropBorderColor

	-- Replace original API methods
	Backdrop:EnableEnhancements(frame)

	-- Add custom API methods that aren't present on existing frames
	frame.SetBackdropGradient = Backdrop.SetBackdropGradient
	frame.SetBackdropGradientAlpha = Backdrop.SetBackdropGradientAlpha
	frame.SetBackdropBorderGradient = Backdrop.SetBackdropBorderGradient
	frame.SetBackdropBorderGradientAlpha = Backdrop.SetBackdropBorderGradientAlpha
	frame.GetBackdropBackground = Backdrop.GetBackdropBackground
	frame.GetBackdropBorderSection = Backdrop.GetBackdropBorderSection
	frame.BorderTextureFunction = Backdrop.BorderTextureFunction
end

function Backdrop:IsEnhanced(frame)
	return frame._backdrop ~= nil
end

function Backdrop:DisableEnhancements(frame)
	if not frame._backdrop then return end
	local alreadyDisabled = not frame._backdrop:IsShown()

	frame._backdrop:Hide()
	frame._backdrop.bgTexture:Hide()
	for point, texture in pairs(frame._backdrop.edgeTextures) do
		texture:Hide()
	end

	if alreadyDisabled then return end

	-- Restore the original API methods:
	frame.SetBackdrop = frame._SetBackdrop
	frame.GetBackdrop = frame._GetBackdrop
	frame.SetBackdropColor = frame._SetBackdropColor
	frame.GetBackdropColor = frame._GetBackdropColor
	frame.SetBackdropBorderColor = frame._SetBackdropBorderColor
	frame.GetBackdropBorderColor = frame._GetBackdropBorderColor

	frame:SetBackdrop(frame._backdrop_options)
end
Backdrop.DisableEhancements = Backdrop.DisableEnhancements -- backwards compat in case any addons were using the typo'd name

function Backdrop:EnableEnhancements(frame)
	if not frame._backdrop then return end
	local alreadyEnabled = frame._backdrop:IsShown()

	frame._backdrop:Show()
	frame._backdrop.bgTexture:Show()
	for point, texture in pairs(frame._backdrop.edgeTextures) do
		texture:Show()
	end

	if alreadyEnabled then return end
	-- Need this check because kgPanels uses this function
	-- as a shortcut to re-showing all the edge textures,
	-- and other addons may be doing the same thing.

	local orig_backdrop = frame:GetBackdrop()
	local orig_backdrop_r, orig_backdrop_g, orig_backdrop_b, orig_backdrop_a = frame:GetBackdropColor()
	local orig_border_r, orig_border_g, orig_border_b, orig_border_a = frame:GetBackdropBorderColor()
	frame:SetBackdrop(nil)

	-- Override the original API methods:
	frame.SetBackdrop = Backdrop.SetBackdrop -- Set the backdrop of the frame according to the specification provided.
	frame.GetBackdrop = Backdrop.GetBackdrop -- Get the backdrop of the frame for use in SetBackdrop
	frame.SetBackdropColor = Backdrop.SetBackdropColor --(r, g, b[, a]) - Set the frame's backdrop color.
	frame.GetBackdropColor = Backdrop.GetBackdropColor -- Get the backdrop color
	frame.SetBackdropBorderColor = Backdrop.SetBackdropBorderColor --(r, g, b[, a]) - Set the frame's backdrop's border's color.
	frame.GetBackdropBorderColor = Backdrop.GetBackdropBorderColor -- Get the frame's backdrop's border's color.

	-- Reapply any previous backdrop using the new API
	if orig_backdrop then
		frame:SetBackdrop(orig_backdrop)
		frame:SetBackdropColor(orig_backdrop_r, orig_backdrop_g, orig_backdrop_b, orig_backdrop_a)
		frame:SetBackdropBorderColor(orig_border_r, orig_border_g, orig_border_b, orig_border_a)
	end
end

--- API
-- Convience method to mass execute a given function and params across
-- all border segments
function Backdrop:BorderTextureFunction(func,...)
	-- check to see the function exists for a texture object
	if not self._backdrop.bgTexture[func] then return end
	for point, texture in pairs(self._backdrop.edgeTextures) do
		texture[func](texture,...)
	end
end

--- API
-- This method allows you to get a reference to the backdrop itself
-- @return a reference to the backdrop background texture
function Backdrop:GetBackdropBackground()
	return self._backdrop.bgTexture
end

--- API
-- this method allows you to get a reference to given border section
-- @param section [Valid values are: TOPLEFTCORNER,TOP,TOPRIGHTCORNER,LEFT,RIGHT,BOTLEFTCORNER,BOT,BOTRIGHTCORNER]
-- @return the section texture or nil
function Backdrop:GetBackdropBorderSection(section)
	section = strupper(section)
	return self._backdrop.edgeTextures[section]
end

--[[
	FUTURE, once blizz removes SetBackdrop, we should hook CreateFrame and automatically embed ourselves
	to allow for backwards compat
--]]

--[[
	{
	  bgFile = "bgFile",
	  edgeFile = "edgeFile", tile = false, tileSize = 0, edgeSize = 32,
	  insets = { left = 0, right = 0, top = 0, bottom = 0
	}
	Alternatily you can use the new blizz style of borders
	where you have a corner file and 1 file for each side. To build those style of borders
	be sure each quadrant is 32x32 blocks. See Interface\DialogFrame\DialogFrame-Corners and Interface\DialogFrame\DialogFrame-Top
	for examples. To pass those style borders in, setup the edge file as follows
	edgeFile = {
		["TOPLEFTCORNER"] = "Interface/DialogFrame/DialogFrame-Corners",
		["TOPRIGHTCORNER"] = "Interface/DialogFrame/DialogFrame-Corners",
		["BOTLEFTCORNER"] = "Interface/DialogFrame/DialogFrame-Corners",
		["BOTRIGHTCORNER"] = "Interface/DialogFrame/DialogFrame-Corners",
		["LEFT"] = "Interface/DialogFrame/DialogFrame-Left",
		["TOP"] = "Interface/DialogFrame/DialogFrame-Top",
		["BOT"] = "Interface/DialogFrame/DialogFrame-Bot",
		["RIGHT"] = "Interface/DialogFrame/DialogFrame-Right",
	}
--]]

local tilingOptions = {
	["LEFT"] = true,
	["RIGHT"] = true,
	["TOP"] = true,
	["BOT"] = true,
	["TOPLEFTCORNER"] = false,
	["TOPRIGHTCORNER"] = false,
	["BOTLEFTCORNER"] = false,
	["BOTRIGHTCORNER"] = false,
}
local tilingOptionsV = {
	["LEFT"] = true,
	["RIGHT"] = true,
	["TOP"] = true,
	["BOT"] = true,
	["TOPLEFTCORNER"] = false,
	["TOPRIGHTCORNER"] = false,
	["BOTLEFTCORNER"] = false,
	["BOTRIGHTCORNER"] = false,
}

-- Corners and their quadrant positions
local corners = {
	TOPLEFTCORNER = 4,
	TOPRIGHTCORNER = 5,
	BOTLEFTCORNER = 6,
	BOTRIGHTCORNER = 7,
}
-- Sides and their quadrant positions
local vSides = {
	LEFT = 0,
	RIGHT = 1,
}
local hSides = {
	TOP = 2,
	BOT = 3,
}

local NaN = { -- TODO: unused, remove?
	["nan"] = true,
	["-1.#IND"] = true,
	["-1.#INF"] = true,
	["1.#IND"] = true,
	["1.#INF"] = true,
	["nil"] = true,
	["inf"] = true,
}

-- Resizing hook to keep them aligned
local function Resize(frame)
	if not frame then
		return
	end
	if frame.bgEdgeSize == 0 then
		return
	end
	local w,h = frame:GetWidth()-frame.bgEdgeSize*2, frame:GetHeight()-frame.bgEdgeSize*2
	if w-1 == w or h-1 == h then
		-- frame was resized to nothing.
		return
	end
	if (w-1 < w) and (h-1 < h) and h > 0 and w > 0 then
		for k,v in pairs(vSides) do
			local t = frame.edgeTextures[k]
			local y = 0
			if frame.bgEdgeSize > 0 then
				y = h/frame.bgEdgeSize
			end
			t:SetTexCoord(v*.125, v*.125+.125, 0, y)
		end
		for k,v in pairs(hSides) do
			local t = frame.edgeTextures[k]
			local y = 0
			if frame.bgEdgeSize > 0 then
				y = w/frame.bgEdgeSize
			end
			local x1 = v*.125
			local x2 = v*.125+.125
			t:SetTexCoord(x1,0, x2,0, x1,y, x2, y)
		end
		if frame.tile and frame.tileSize > 0 then
			frame.bgTexture:SetTexCoord(0,w/frame.tileSize, 0,h/frame.tileSize)
		end
	end
end

-- Attach the corner textures
local function AttachCorners(frame,options)
	local nudge = 0
	if options.edgeSize >= 32 then
		nudge = options.edgeSize/32
	end
	if options.edgeSize <= 16 then
		nudge = options.edgeSize/16
	end
	for k,v in pairs(corners) do
		local texture = frame.edgeTextures[k]
		texture:ClearAllPoints()
		texture:SetWidth(options.edgeSize)
		texture:SetHeight(options.edgeSize)
		texture:SetTexCoord(v*.125,v*.125+.125, 0,1)
	end
	frame.edgeTextures["TOPLEFTCORNER"]:SetPoint(edgePoints["TOPLEFTCORNER"],frame,0,nudge)
	frame.edgeTextures["BOTLEFTCORNER"]:SetPoint(edgePoints["BOTLEFTCORNER"],frame,0,-nudge)
	frame.edgeTextures["TOPRIGHTCORNER"]:SetPoint(edgePoints["TOPRIGHTCORNER"],frame,0,nudge)
	frame.edgeTextures["BOTRIGHTCORNER"]:SetPoint(edgePoints["BOTRIGHTCORNER"],frame,0,-nudge)

end
local nk = {
	["TOPLEFTCORNER"] = { l = 0, r = 0.5, t= 0, b=0.5},
	["TOPRIGHTCORNER"] = { l = 0.5, r = 1, t= 0, b=0.5},
	["BOTLEFTCORNER"] = { l = 0, r = 0.5, t= 0.5, b=1},
	["BOTRIGHTCORNER"] = { l = 0.5, r = 1, t= 0.5, b=1},
}
-- Attach new style corners
local function AttachNewCorners(frame)
	for k,v in pairs(corners) do
		local texture = frame.edgeTextures[k]
		texture:SetPoint(edgePoints[k], frame)
		texture:SetWidth(frame.bgEdgeSize)
		texture:SetHeight(frame.bgEdgeSize)
		texture:SetTexCoord(nk[k].l,nk[k].r,nk[k].t,nk[k].b)
	end
end
-- Attach new style sdes
local function AttachNewSides(frame,w,h)
	local offset = 1
	offset = frame.bgEdgeSize /32
	-- Left and Right
	frame.edgeTextures["LEFT"]:SetPoint("TOPLEFT",frame.edgeTextures["TOPLEFTCORNER"],"BOTTOMLEFT",offset,0)
	frame.edgeTextures["LEFT"]:SetPoint("BOTTOMLEFT",frame.edgeTextures["BOTLEFTCORNER"],"TOPLEFT",offset,0)
	frame.edgeTextures["LEFT"]:SetWidth(frame.bgEdgeSize/2)
	frame.edgeTextures["LEFT"]:SetVertTile(true)
	frame.edgeTextures["LEFT"]:SetHorizTile(false)
	frame.edgeTextures["RIGHT"]:SetPoint("TOPRIGHT",frame.edgeTextures["TOPRIGHTCORNER"],"BOTTOMRIGHT")
	frame.edgeTextures["RIGHT"]:SetPoint("BOTTOMRIGHT",frame.edgeTextures["BOTRIGHTCORNER"],"TOPRIGHT")
	frame.edgeTextures["RIGHT"]:SetWidth(frame.bgEdgeSize/2)
	frame.edgeTextures["RIGHT"]:SetVertTile(true)
	frame.edgeTextures["RIGHT"]:SetHorizTile(false)
	-- Top and Bottom
	frame.edgeTextures["TOP"]:SetPoint("TOPLEFT",frame.edgeTextures["TOPLEFTCORNER"],"TOPRIGHT",0,-offset)
	frame.edgeTextures["TOP"]:SetPoint("TOPRIGHT",frame.edgeTextures["TOPRIGHTCORNER"],"TOPLEFT",0,-offset)
	frame.edgeTextures["TOP"]:SetHeight(frame.bgEdgeSize/2)
	frame.edgeTextures["TOP"]:SetVertTile(false)
	frame.edgeTextures["TOP"]:SetHorizTile(true)
	frame.edgeTextures["BOT"]:SetPoint("BOTTOMLEFT",frame.edgeTextures["BOTLEFTCORNER"],"BOTTOMRIGHT")
	frame.edgeTextures["BOT"]:SetPoint("BOTTOMRIGHT",frame.edgeTextures["BOTRIGHTCORNER"],"BOTTOMLEFT")
	frame.edgeTextures["BOT"]:SetHeight(frame.bgEdgeSize/2)
	frame.edgeTextures["BOT"]:SetVertTile(false)
	frame.edgeTextures["BOT"]:SetHorizTile(true)
end
-- Attach the side textures
local function AttachSides(frame,w,h,options)
	local nudge = 0.125
	if options.edgeSize >= 32 then
		nudge = nudge * (options.edgeSize/32)
	end
	if options.edgeSize <= 16 then
		if options.edgeSize > 0 then
			nudge = nudge / (16/options.edgeSize)
		else
			nudge = 0
		end
	end
	local offset = 0
	if options.edgeSize >= 32 then
		offset = options.edgeSize/32
	end
	if options.edgeSize <= 16 then
		offset = options.edgeSize/16
	end
	-- SOOOO Issue here is when resetting an existing border the top area gets jacked up
	-- Left and Right
	for k,v in pairs(vSides) do
		local texture = frame.edgeTextures[k]
		texture:ClearAllPoints()
		if k == "RIGHT" then
			texture:SetPoint(edgePoints[k], frame, nudge,0)
			texture:SetPoint("BOTTOM", frame, "BOTTOM", 0, options.edgeSize-offset)
			texture:SetPoint("TOP", frame, "TOP", 0, -options.edgeSize+offset)
		else
			texture:SetPoint(edgePoints[k], frame, nudge,0)
			texture:SetPoint("BOTTOM", frame, "BOTTOM", 0, options.edgeSize-offset)
			texture:SetPoint("TOP", frame, "TOP", 0, -options.edgeSize+offset)
		end
		texture:SetWidth(options.edgeSize)
		local y = 0
		if options.edgeSize > 0 then
			y = h/options.edgeSize
		end
		texture:SetTexCoord(v*.125, v*.125+.125, 0, y)
	end
	-- Top and Bottom
	for k,v in pairs(hSides) do
		local texture = frame.edgeTextures[k]
		texture:ClearAllPoints()
		-- Adjusments for placement
		if k == "TOP" then
			texture:SetPoint(edgePoints[k], frame, nudge, offset)
			texture:SetPoint("LEFT", frame, "LEFT", options.edgeSize, 0)
			texture:SetPoint("RIGHT", frame, "RIGHT", -options.edgeSize, 0)
		else
			texture:SetPoint(edgePoints[k], frame,-nudge,-offset)
			texture:SetPoint("LEFT", frame, "LEFT", options.edgeSize, 1)
			texture:SetPoint("RIGHT", frame, "RIGHT", -options.edgeSize, 1)
		end
		texture:SetHeight(options.edgeSize)
		local y = 0
		if options.edgeSize > 0 then
			y = w/options.edgeSize
		end
		local x1 = v*.125
		local x2 = v*.125+.125
		--if k == "TOP" then -- Flip
		--	x1,x2 = x2, x1
		--end
		texture:SetTexCoord(x1,0, x2,0, x1,y, x2, y)
	end
end

--- API
-- Setup the backdrop see normal wow api for table options
function Backdrop:SetBackdrop(options)
	if not options then
		-- Clear any options that were previously set
		self._backdrop.bgTexture:SetTexture(nil)
		for k,v in pairs(edgePoints) do
			self._backdrop.edgeTextures[k]:SetTexture(nil)
		end
		table.wipe(self._backdrop_options)
		return
	end
	-- Set textures
	local vTile = false
	local hTile = not not options.tile

	local reset = false
	if self._backdrop_options then
		table.wipe(self._backdrop_options)
		reset = true
	else
		self._backdrop_options = {}
	end

	-- Insert defaults for missing values
	if options.tile and not options.tileSize then
		-- @PHANX: need to check how the default UI handles this case
		options.tile = false
	end
	if options.edgeFile == "" then
		options.edgeFile = nil
	end
	if not options.edgeFile or not options.edgeSize then
		options.edgeSize = 0
	end
	options.insets = options.insets or {}
	options.insets.left = options.insets.left or 0
	options.insets.right = options.insets.right or 0
	options.insets.top = options.insets.top or 0
	options.insets.bottom = options.insets.bottom or 0

	-- Copy backdrop options
	self._backdrop_options.bgFile = options.bgFile
	self._backdrop_options.edgeFile = options.edgeFile
	self._backdrop_options.tile = options.tile
	self._backdrop_options.tileSize = options.tileSize
	self._backdrop_options.edgeSize = options.edgeSize
	self._backdrop_options.insets = {}
	self._backdrop_options.insets.left = options.insets.left
	self._backdrop_options.insets.right = options.insets.right
	self._backdrop_options.insets.top = options.insets.top
	self._backdrop_options.insets.bottom = options.insets.bottom

	if type(options.edgeFile) == "table" then
		Backdrop.SetNewBackdrop(self,options)
	else
		self._backdrop.bgTexture:SetTexture(options.bgFile,hTile,vTile)
		for k,v in pairs(edgePoints) do
			self._backdrop.edgeTextures[k]:SetTexture(options.edgeFile,tilingOptions[k])
		end
		-- Copy options
		self._backdrop.tileSize = options.tileSize
		self._backdrop.tile = options.tile
		self._backdrop.bgEdgeSize = options.edgeSize
		-- Setup insets
		self._backdrop:ClearAllPoints()
		self._backdrop:SetAllPoints(self)
		local w,h = self:GetWidth()-(options.edgeSize*2), self:GetHeight()-(options.edgeSize*2)
		if options.edgeSize > 0 then
			-- Attach croners
			AttachCorners(self._backdrop, self._backdrop_options)
			-- Attach sides
			AttachSides(self._backdrop,w,h, self._backdrop_options)
		end
		-- Attach Background
		self._backdrop.bgTexture:ClearAllPoints()
		self._backdrop.bgTexture:SetPoint("TOPLEFT", self._backdrop, "TOPLEFT", options.insets.left, -options.insets.top)
		self._backdrop.bgTexture:SetPoint("BOTTOMRIGHT", self._backdrop, "BOTTOMRIGHT", -options.insets.right, options.insets.bottom)
		if options.tile then
			self._backdrop.bgTexture:SetTexCoord(0,w/options.tileSize, 0,h/options.tileSize)
		end
		self._backdrop:SetScript("OnSizeChanged", Resize)
	end
	if reset then
		Resize(self._backdrop)
	end
end

-- replace std api call
function Backdrop:GetBackdrop()
	return self._backdrop_options
end

-- replace std api call
function Backdrop:GetBackdropColor()
	return self._backdrop.bgTexture:GetVertexColor()
end

-- repalce std api call
function Backdrop:GetBackdropBorderColor()
	return self._backdrop.edgeTextures["TOP"]:GetVertexColor()
end

--- API
-- change the backdrop border color
-- @params r,g,b[,a]
function Backdrop:SetBackdropBorderColor(...)
	for k,v in pairs(edgePoints) do
		self._backdrop.edgeTextures[k]:SetVertexColor(...)
	end
end
--- API
-- set the backdrop color
-- @params r,g,b[,a]
function Backdrop:SetBackdropColor(...)
	self._backdrop.bgTexture:SetVertexColor(...)
end

--- API
-- set the backdrop gradient color
-- @params "orientation", minR, minG, minB, maxR, maxG, maxB
function Backdrop:SetBackdropGradient(...)
	self._backdrop.bgTexture:SetGradient(...)
end

--- API
-- set the backdrop gradient with alpha
-- @params "orientation", minR, minG, minB, minA, maxR, maxG, maxB, maxA
function Backdrop:SetBackdropGradientAlpha(...)
	self._backdrop.bgTexture:SetGradientAlpha(...)
end

--- API
-- set the border gradient color
-- @params "orientation", minR, minG, minB, maxR, maxG, maxB
function Backdrop:SetBackdropBorderGradient(orientation,minR,minG,minB,maxR,maxG,maxB)
	orientation = strupper(orientation)
	if orientation == "HORIZONTAL" then
		self._backdrop.edgeTextures["TOPLEFTCORNER"]:SetGradient(orientation,minR,minG,minB,minR,minG,minB)
		self._backdrop.edgeTextures["BOTLEFTCORNER"]:SetGradient(orientation,minR,minG,minB,minR,minG,minB)
		self._backdrop.edgeTextures["LEFT"]:SetGradient(orientation,minR,minG,minB,minR,minG,minB)
		self._backdrop.edgeTextures["BOT"]:SetGradient(orientation,minR,minG,minB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["TOP"]:SetGradient(orientation,minR,minG,minB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["TOPRIGHTCORNER"]:SetGradient(orientation,maxR,maxG,maxB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["BOTRIGHTCORNER"]:SetGradient(orientation,maxR,maxG,maxB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["RIGHT"]:SetGradient(orientation,maxR,maxG,maxB,maxR,maxG,maxB)
	else
		self._backdrop.edgeTextures["TOPLEFTCORNER"]:SetGradient(orientation,maxR,maxG,maxB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["BOTLEFTCORNER"]:SetGradient(orientation,minR,minG,minB,minR,minG,minB)
		self._backdrop.edgeTextures["LEFT"]:SetGradient(orientation,minR,minG,minB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["BOT"]:SetGradient(orientation,minR,minG,minB,minR,minG,minB)
		self._backdrop.edgeTextures["TOP"]:SetGradient(orientation,maxR,maxG,maxB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["TOPRIGHTCORNER"]:SetGradient(orientation,maxR,maxG,maxB,maxR,maxG,maxB)
		self._backdrop.edgeTextures["BOTRIGHTCORNER"]:SetGradient(orientation,minR,minG,minB,minR,minG,minB)
		self._backdrop.edgeTextures["RIGHT"]:SetGradient(orientation,minR,minG,minB,maxR,maxG,maxB)
	end
end

--- API
-- set the border gradient alpha color
-- @params "orientation", minR, minG, minB, minA, maxR, maxG, maxB, maxA
function Backdrop:SetBackdropBorderGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA)
	orientation = strupper(orientation)
	if orientation == "HORIZONTAL" then
		self._backdrop.edgeTextures["TOPLEFTCORNER"]:SetGradientAlpha(orientation,minR,minG,minB,minA,minR,minG,minB,minA)
		self._backdrop.edgeTextures["BOTLEFTCORNER"]:SetGradientAlpha(orientation,minR,minG,minB,minA,minR,minG,minB,minA)
		self._backdrop.edgeTextures["LEFT"]:SetGradientAlpha(orientation,minR,minG,minB,minA,minR,minG,minB,minA)
		self._backdrop.edgeTextures["BOT"]:SetGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["TOP"]:SetGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["TOPRIGHTCORNER"]:SetGradientAlpha(orientation,maxR,maxG,maxB,maxA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["BOTRIGHTCORNER"]:SetGradientAlpha(orientation,maxR,maxG,maxB,maxA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["RIGHT"]:SetGradientAlpha(orientation,maxR,maxG,maxB,maxA,maxR,maxG,maxB,maxA)
	else
		self._backdrop.edgeTextures["TOPLEFTCORNER"]:SetGradientAlpha(orientation,maxR,maxG,maxB,maxA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["BOTLEFTCORNER"]:SetGradientAlpha(orientation,minR,minG,minB,minA,minR,minG,minB,minA)
		self._backdrop.edgeTextures["LEFT"]:SetGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["BOT"]:SetGradientAlpha(orientation,minR,minG,minB,minA,minR,minG,minB,minA)
		self._backdrop.edgeTextures["TOP"]:SetGradientAlpha(orientation,maxR,maxG,maxB,maxA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["TOPRIGHTCORNER"]:SetGradientAlpha(orientation,maxR,maxG,maxB,maxA,maxR,maxG,maxB,maxA)
		self._backdrop.edgeTextures["BOTRIGHTCORNER"]:SetGradientAlpha(orientation,minR,minG,minB,minA,minR,minG,minB,minA)
		self._backdrop.edgeTextures["RIGHT"]:SetGradientAlpha(orientation,minR,minG,minB,minA,maxR,maxG,maxB,maxA)
	end
end

--- API
-- New Backdrop function, for use with the new table layout defined above.
-- called when you pass a new table layout to SetBackdrop
function Backdrop:SetNewBackdrop(options)
	self._backdrop.bgTexture:SetTexture(options.bgFile,hTile,vTile)
	for k,v in pairs(edgePoints) do
		self._backdrop.edgeTextures[k]:SetTexture(options.edgeFile[k],tilingOptions[k])
	end
	-- Copy options
	self._backdrop.tileSize = options.tileSize
	self._backdrop.tile = options.tile
	self._backdrop.bgEdgeSize = options.edgeSize
	-- Setup insets
	self._backdrop:SetPoint("TOPLEFT",self,"TOPLEFT",-options.insets.left, options.insets.top)
	self._backdrop:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT", options.insets.right, -options.insets.bottom)
	local w,h = self:GetWidth()-options.edgeSize*2, self:GetHeight()-options.edgeSize*2
	if options.edgeSize > 0 then
		-- Attach croners
		AttachNewCorners(self._backdrop)
		-- Attach sides
		AttachNewSides(self._backdrop,w,h)
	end
	-- Attach Background
	self._backdrop.bgTexture:SetPoint("TOPLEFT", self._backdrop, "TOPLEFT", options.insets.left, -options.insets.top)
	self._backdrop.bgTexture:SetPoint("BOTTOMRIGHT", self._backdrop, "BOTTOMRIGHT", -options.insets.right, options.insets.bottom)
	if options.tile and options.tileSize > 0 then
		self._backdrop.bgTexture:SetTexCoord(0,w/options.tileSize, 0,h/options.tileSize)
	end
end