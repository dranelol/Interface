local L = LibStub("AceLocale-3.0"):GetLocale("SunnArt", true)
local i, j, k
local Strata = {["1-BACKGROUND"]="Background",["2-LOW"]="Low",["3-MEDIUM"]="Medium",["4-HIGH"]="High"}

SunnArt_Options = {
	name = L["Sunn - Viewport Art"],
	type = "group",
	handler = SunnArt,
	childGroups = "tab",
	func = "ResetBar",
	get = "GetValue",
	set = "SetValue",
	args = {
		theme = {
			order =0,
			name = "Hidden themes",
			type = "select",
			hidden = true,
			values = {},
		},			
		global = {
			order = 0,
			name = L["Global options"],
			type = "group",
			get = "GetGlobal",
			set = "SetGlobal",
			args = {
				artwork = {
					order = 1,
					name = L["Artwork"],
					type = "toggle",
					desc = L["Enable or Disable artwork in the panels"],
					get = "GetValue",
					set = "SetValue",
				},
				colour = {
					order = 2,
					name = L["Solid colour"],
					desc = L["Colour of the Solid Colour theme"],
					type = "color",
				},
				theme = {
					order = 3,
					name = L["Theme"],
					desc = L["Graphical theme"],
					type = "select",
					values = "GetThemeList",
					style = "dropdown",
				},
				panels = {
					order = 4,
					name = L["Sections"],
					desc = L["Number of slices that the artwork is split into (default is 3, some addons use 4 or 5)"],
					type = "range",
					min = 1,
					max = 5,
					step = 1,
					disabled = function(info) return not SunnArt:GetAll("panels") end,
				},
				overlap = {
					order = 5,
					name = L["Artwork Overlap"],
					desc = L["Percentage of artwork that will overlap the game world"],
					type = "range",
					min = 0,
					max = 100,
					step = 0.01,
					disabled = function(info) return not SunnArt:GetAll("overlap") end,
				},
				length = {
					order = 6,
					name = L["Length Adjust"],
					desc = L["Adds extra length to the panel to move unwanted artwork off-screen"],
					type = "range",
					min = 0,
					max = 100,
					step = 0.01,
					disabled = function(info) return not SunnArt:GetAll("length") end,
				},
				globalspacer = {
					order = 7,
					name = L["Viewport Settings"],
					type = "header",
				},
				horizviewport = {
					order = 8,
					name = L["Horizontal Viewport"],
					desc = L["Enable or Disable the viewport Horizontally"],
					type = "toggle",
					get = function(info) return (SunnArt.db.profile.bar[3].resize and SunnArt.db.profile.bar[4].resize) end,
					set = function(info,v) 
						SunnArt.db.profile.bar[3].resize = v
						SunnArt.db.profile.bar[4].resize = v
						SunnArt:UpdateViewport()
					end,
				},
				vertviewport = {
					order = 9,
					name = L["Vertical Viewport"],
					desc = L["Enable or Disable the viewport Vertically"],
					type = "toggle",
					get = function(info) return (SunnArt.db.profile.bar[1].resize and SunnArt.db.profile.bar[2].resize) end,
					set = function(info,v)
						SunnArt.db.profile.bar[1].resize = v
						SunnArt.db.profile.bar[2].resize = v
						SunnArt:UpdateViewport()
					end,
				},
				globalspacer2 = {
					order = 10,
					name = L["Frame Strata"],
					type = "header",
				},
				framestrata = {
					order = 11,
					name = L["Frame Strata"],
					desc = L["Sets the strata (layer depth) of the frames"],
					type = "select",
					values = Strata,
					get = "GetValue",
					set = "SetValue",
				},
			},
		},
		panels = {
			order = 1,
			name = "Panels",
			type = "group",
			args = {
				bottom = {
					order = 12,
					name = L["Bottom panel"],
					desc = L["Bottom panel properties"],
					type = "group",
					args = {
						enabled = {
							order = 1,
							name = L["Enable"], 
							desc = L["Enable this panel"],
							type = "toggle",
						},
						size = {
							order = 2,
							name = L["Panel thickness"],
							desc = L["Change the thickness of this panel (percentage of screen)"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						alpha = {
							order = 3,
							name = L["Artwork transparency"],
							desc = L["Transparency of the panel artwork"],
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							hidden = "isHidden",
						},
						scale = {
							order = 4,
							name = L["Artwork scale"],
							desc = L["Maximum scale of the artwork before stretching occurs"],
							type = "range",
							min = 0,
							max = 2,
							step = 0.01,
							hidden = "isHidden",
						},
						resize = {
							order = 5,
							name = L["Resize Viewport"],
							desc = L["Toggle Overlay/Viewport mode for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						flip = {
							order = 6,
							name = L["Flip"],
							desc = L["Flip the artwork"],
							type = "toggle",
							hidden = "isHidden",
						},
						fit = {
							order = 7,
							name = L["Resize to fit"],
							desc = L["Resize to match left and right frames"],
							type = "toggle",
							hidden = "isHidden",
						},
						autostretch = {
							order = 8,
							name = L["Auto-Stretch"],
							desc = L["Toggle auto-stretch for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						reset = {
							order = -1,
							name = L["Reset"],
							desc = L["Restore default values"],
							type = "execute",
							hidden = "isHidden",
						},
						advanced = {
							order = 10,
							name = L["Advanced"],
							desc = L["Advanced options"],
							type = "header",
							hidden = "isHidden",
						},
						colour = {
							order = 11,
							name = L["Solid colour"],
							desc = L["Colour of the Solid Colour theme"],
							type = "color",
							hidden = "isHidden",
						},
						theme = {
							order = 12,
							name = L["Theme"],
							desc = L["Graphical theme"],
							type = "select",
							values = "GetThemeList",
							style = "dropdown",
							hidden = "isHidden",
						},
						panels = {
							order = 13,
							name = L["Sections"],
							desc = L["Number of slices that the artwork is split into (default is 3, some addons use 4 or 5)"],
							type = "range",
							min = 1,
							max = 5,
							step = 1,
							hidden = "isHidden",
						},
						overlap = {
							order = 14,
							name = L["Artwork Overlap"],
							desc = L["Percentage of artwork that will overlap the game world"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						length = {
							order = 15,
							name = L["Length Adjust"],
							desc = L["Adds extra length to the panel to move unwanted artwork off-screen"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
					},
				},
				top = {
					order = 11,
					name = L["Top panel"],
					desc = L["Top panel properties"],
					type = "group",
					args = {
						enabled = {
							order = 1,
							name = L["Enable"], 
							desc = L["Enable this panel"],
							type = "toggle",
						},
						size = {
							order = 2,
							name = L["Panel thickness"],
							desc = L["Change the thickness of this panel (percentage of screen)"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						alpha = {
							order = 3,
							name = L["Artwork transparency"],
							desc = L["Transparency of the panel artwork"],
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							hidden = "isHidden",
						},
						scale = {
							order = 4,
							name = L["Artwork scale"],
							desc = L["Maximum scale of the artwork before stretching occurs"],
							type = "range",
							min = 0,
							max = 2,
							step = 0.01,
							hidden = "isHidden",
						},
						resize = {
							order = 5,
							name = L["Resize Viewport"],
							desc = L["Toggle Overlay/Viewport mode for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						flip = {
							order = 6,
							name = L["Flip"],
							desc = L["Flip the artwork"],
							type = "toggle",
							hidden = "isHidden",
						},
						rotate = {
							order = 7,
							name = L["Rotate Panel"],
							desc = L["Rotate the panel so the artwork appears upside down"],
							type = "toggle",
							hidden = "isHidden",
						},
						fit = {
							order = 8,
							name = L["Resize to fit"],
							desc = L["Resize to match left and right frames"],
							type = "toggle",
							hidden = "isHidden",
						},
						autostretch = {
							order = 9,
							name = L["Auto-Stretch"],
							desc = L["Toggle auto-stretch for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						reset = {
							order = -1,
							name = L["Reset"],
							desc = L["Restore default values"],
							type = "execute",
							hidden = "isHidden",
						},
						advanced = {
							order = 10,
							name = L["Advanced"],
							desc = L["Advanced options"],
							type = "header",
							hidden = "isHidden",
						},
						colour = {
							order = 11,
							name = L["Solid colour"],
							desc = L["Colour of the Solid Colour theme"],
							type = "color",
							hidden = "isHidden",
						},
						theme = {
							order = 12,
							name = L["Theme"],
							desc = L["Graphical theme"],
							type = "select",
							values = "GetThemeList",
							style = "dropdown",
							hidden = "isHidden",
						},
						panels = {
							order = 13,
							name = L["Sections"],
							desc = L["Number of slices that the artwork is split into (default is 3, some addons use 4 or 5)"],
							type = "range",
							min = 1,
							max = 5,
							step = 1,
							hidden = "isHidden",
						},
						overlap = {
							order = 14,
							name = L["Artwork Overlap"],
							desc = L["Percentage of artwork that will overlap the game world"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						length = {
							order = 15,
							name = L["Length Adjust"],
							desc = L["Adds extra length to the panel to move unwanted artwork off-screen"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
					},
				},
				left = {
					order = 13,
					name = L["Left panel"],
					desc = L["Left panel properties"],
					type = "group",
					--width = "half",
					args = {
						enabled = {
							order = 1,
							name = L["Enable"], 
							desc = L["Enable this panel"],
							type = "toggle",
						},
						size = {
							order = 2,
							name = L["Panel thickness"],
							desc = L["Change the thickness of this panel (percentage of screen)"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						alpha = {
							order = 3,
							name = L["Artwork transparency"],
							desc = L["Transparency of the panel artwork"],
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							hidden = "isHidden",
						},
						scale = {
							order = 4,
							name = L["Artwork scale"],
							desc = L["Maximum scale of the artwork before stretching occurs"],
							type = "range",
							min = 0,
							max = 2,
							step = 0.01,
							hidden = "isHidden",
						},
						resize = {
							order = 5,
							name = L["Resize Viewport"],
							desc = L["Toggle Overlay/Viewport mode for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						flip = {
							order = 6,
							name = L["Flip"],
							desc = L["Flip the artwork"],
							type = "toggle",
							hidden = "isHidden",
						},
						fit = {
							order = 7,
							name = L["Resize to fit"],
							desc = L["Resize to match top and bottom frames"],
							type = "toggle",
							hidden = "isHidden",
						},
						autostretch = {
							order = 8,
							name = L["Auto-Stretch"],
							desc = L["Toggle auto-stretch for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						reset = {
							order = -1,
							name = L["Reset"],
							desc = L["Restore default values"],
							type = "execute",
							hidden = "isHidden",
						},
						advanced = {
							order = 10,
							name = L["Advanced"],
							desc = L["Advanced options"],
							type = "header",
							hidden = "isHidden",
						},
						colour = {
							order = 11,
							name = L["Solid colour"],
							desc = L["Colour of the Solid Colour theme"],
							type = "color",
							hidden = "isHidden",
						},
						theme = {
							order = 12,
							name = L["Theme"],
							desc = L["Graphical theme"],
							type = "select",
							values = "GetThemeList",
							style = "dropdown",
							hidden = "isHidden",
						},
						panels = {
							order = 13,
							name = L["Sections"],
							desc = L["Number of slices that the artwork is split into (default is 3, some addons use 4 or 5)"],
							type = "range",
							min = 1,
							max = 5,
							step = 1,
							hidden = "isHidden",
						},
						overlap = {
							order = 14,
							name = L["Artwork Overlap"],
							desc = L["Percentage of artwork that will overlap the game world"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						length = {
							order = 15,
							name = L["Length Adjust"],
							desc = L["Adds extra length to the panel to move unwanted artwork off-screen"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
					},
				},
				right = {
					order = 14,
					name = L["Right panel"],
					desc = L["Right panel properties"],
					type = "group",
					--width = "half",
					args = {
						enabled = {
							order = 1,
							name = L["Enable"], 
							desc = L["Enable this panel"],
							type = "toggle",
						},
						size = {
							order = 2,
							name = L["Panel thickness"],
							desc = L["Change the thickness of this panel (percentage of screen)"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						alpha = {
							order = 3,
							name = L["Artwork transparency"],
							desc = L["Transparency of the panel artwork"],
							type = "range",
							min = 0,
							max = 1,
							step = 0.01,
							hidden = "isHidden",
						},
						scale = {
							order = 4,
							name = L["Artwork scale"],
							desc = L["Maximum scale of the artwork before stretching occurs"],
							type = "range",
							min = 0,
							max = 2,
							step = 0.01,
							hidden = "isHidden",
						},
						resize = {
							order = 5,
							name = L["Resize Viewport"],
							desc = L["Toggle Overlay/Viewport mode for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						flip = {
							order = 6,
							name = L["Flip"],
							desc = L["Flip the artwork"],
							type = "toggle",
							hidden = "isHidden",
						},
						fit = {
							order = 6,
							name = L["Resize to fit"],
							desc = L["Resize to match left and right frames"],
							type = "toggle",
							hidden = "isHidden",
						},
						autostretch = {
							order = 7,
							name = L["Auto-Stretch"],
							desc = L["Toggle auto-stretch for this panel"],
							type = "toggle",
							hidden = "isHidden",
						},
						reset = {
							name = L["Reset"],
							desc = L["Restore default values"],
							type = "execute",
							hidden = function(info) return not SunnArt.db.profile.bar[4].enabled end,
							order = -1,
						},
						advanced = {
							order = 10,
							name = L["Advanced"],
							desc = L["Advanced options"],
							type = "header",
							hidden = "isHidden",
						},
						colour = {
							order = 11,
							name = L["Solid colour"],
							desc = L["Colour of the Solid Colour theme"],
							type = "color",
							hidden = "isHidden",
						},
						theme = {
							order = 12,
							name = L["Theme"],
							desc = L["Graphical theme"],
							type = "select",
							values = "GetThemeList",
							style = "dropdown",
							hidden = "isHidden",
						},
						panels = {
							order = 13,
							name = L["Sections"],
							desc = L["Number of slices that the artwork is split into (default is 3, some addons use 4 or 5)"],
							type = "range",
							min = 1,
							max = 5,
							step = 1,
							hidden = "isHidden",
						},
						overlap = {
							order = 14,
							name = L["Artwork Overlap"],
							desc = L["Percentage of artwork that will overlap the game world"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
						length = {
							order = 15,
							name = L["Length Adjust"],
							desc = L["Adds extra length to the panel to move unwanted artwork off-screen"],
							type = "range",
							min = 0,
							max = 100,
							step = 0.01,
							hidden = "isHidden",
						},
					},
				},
			},
		},
		customart = {
			order = 2,
			name = L["Custom theme"],
			type = "group",
			get = "GetGlobal",
			set = "SetGlobal",
			args = {
				customart = {
					order = 1,
					name = L["Custom Artwork"],
					desc = L["Path to artwork theme from your addons folder eg. SunnArt\\royal  (do not include the section number or file extension)"],
					type = "input",
					get = function(info) return SunnArt:GetAll("theme") end,
					set = function(info, v)
						SunnArt:SetAll("theme", v)
						SunnArt:UpdateArtwork()
					end,
				},
				panels = {
					order = 2,
					name = L["Sections"],
					desc = L["Number of slices that the artwork is split into (default is 3, some addons use 4 or 5)"],
					type = "range",
					min = 1,
					max = 5,
					step = 1,
					disabled = function(info) return not SunnArt:GetAll("panels") end,
				},
				overlap = {
					order = 3,
					name = L["Artwork Overlap"],
					desc = L["Percentage of artwork that will overlap the game world"],
					type = "range",
					min = 0,
					max = 100,
					step = 0.01,
					disabled = function(info) return not SunnArt:GetAll("overlap") end,
				},
				length = {
					order = 4,
					name = L["Length Adjust"],
					desc = L["Adds extra length to the panel to move unwanted artwork off-screen"],
					type = "range",
					min = 0,
					max = 100,
					step = 0.01,
					disabled = function(info) return not SunnArt:GetAll("length") end,
				},
				themename = {
					order = 5,
					name = L["Theme name"],
					type = "input",
					get = function(info) return SunnArt.ThemeDB[SunnArt:GetAll("theme")] end,
					set = function(info, v)
						if v then SunnArt.ThemeDB[SunnArt:GetAll("theme")] = v end
					end,
				},
				save = {
					order = 7,
					name = L["Save theme"],
					type = "execute",
					func = "SaveTheme",
				},
				delete = {
					order = 8,
					name = L["Delete theme"],
					type = "execute",
					func = "DeleteTheme",
				},
				h1 = { order = 12, type = "header", name = L["Instructions for use"],},
				p1 = { order = 13, type = "description", name = L["INSTRUCTIONS_P1"].."\n\n"..L["INSTRUCTIONS_P2"].."\n\n"..L["INSTRUCTIONS_P3"].."\n\n"..L["INSTRUCTIONS_P4"].."\n\n"..L["INSTRUCTIONS_P5"],},
				h2 = { order = 14, type = "header", name = L["Example"],},
				p2 = { order = 15, type = "description", name = L["INSTRUCTIONS_P6"].."\n\n"..L["INSTRUCTIONS_P7"].."\n\n"..L["INSTRUCTIONS_P8"].."\n\n"..L["INSTRUCTIONS_P9"],},
			},
		},
	},
}

function SunnArt:DeleteTheme()
	local themefile = self:GetAll("theme")
	if (self.db.global.themes[themefile] == nil and SunnArt_DEFAULTS.global.themes[themefile] ~= nil) or themefile == nil then
		message("You cannot delete this theme")
	else
		self.db.global.themes[themefile] = nil
		self.db.global.overlaps[themefile] = nil
		self.db.global.lengths[themefile] = nil
		self.db.global.panels[themefile] = nil
		self.ThemeDB.overlap[themefile] = nil
		self.ThemeDB.panels[themefile] = nil
		self.ThemeDB.length[themefile] = nil
		self.ThemeDB = {index={}, overlap={}, panels={}, length={}}
		self:GetThemeList()
		self:SetTheme(0, self.ThemeDB[themefile] and themefile or SunnArt_DEFAULTS.profile.bar[1].theme)
		self:SetViewport()
		if self.ThemeDB[themefile] then
			message(L["Theme restored to original settings"])
		else
			message(L["Theme deleted"])
		end
	end
end

function SunnArt:SaveTheme()
	local themefile,themename,overlap,panels,length
	
	themefile = self:GetAll("theme") or self.db.profile.bar[1].theme
	themename = self.ThemeDB[themefile] or "Custom Theme"
	overlap = self:GetAll("overlap") or self.ThemeDB.overlap[themefile] or 0
	panels = self:GetAll("panels") or self.ThemeDB.panels[themefile] or 3
	length = self:GetAll("length") or self.ThemeDB.length[themefile] or 0
	
	self.db.global.themes[themefile] = themename
	self.db.global.overlaps[themefile] = overlap
	self.db.global.lengths[themefile] = length
	self.db.global.panels[themefile] = panels

	self.ThemeDB = {index={}, overlap={}, panels={}, length={}}
	self:GetThemeList()
	message(L["Theme saved"])
end

function SunnArt:ResetBar(info)
	local currtheme = self:GetAll("theme")
	local barnums = {["bottom"]=1,["top"]=2,["left"]=3,["right"]=4}
	for i, j in pairs(SunnArt_DEFAULTS.profile.bar[barnums[info[#info-1]]]) do self.db.profile.bar[barnums[info[#info-1]]][i] = j end
	if currtheme then
		self.db.profile.bar[barnums[info[#info-1]]].theme = currtheme
		self.db.profile.bar[barnums[info[#info-1]]].enabled = true
		if self.ThemeDB.overlap[currtheme] then self.db.profile.bar[barnums[info[#info-1]]].overlap = self.ThemeDB.overlap[currtheme] end
		if self.ThemeDB.panels[currtheme] then self.db.profile.bar[barnums[info[#info-1]]].panels = self.ThemeDB.panels[currtheme] end
		if self.ThemeDB.length[currtheme] then self.db.profile.bar[barnums[info[#info-1]]].length = self.ThemeDB.length[currtheme] end
	end
	self:SetViewport()
end

function SunnArt:SetAll(name, value)
	for x = 1, 4 do
		self.db.profile.bar[x][name] = value
	end
end

function SunnArt:GetAll(name)
	return self.db.profile.bar[1][name] == self.db.profile.bar[2][name] and self.db.profile.bar[1][name] == self.db.profile.bar[3][name] and self.db.profile.bar[1][name] == self.db.profile.bar[4][name] and self.db.profile.bar[1][name] or nil
end

function SunnArt:SetColour(panel, r, g, b, a)
	if panel == 0 then
		self:SetAll("red", r)
		self:SetAll("green", g)
		self:SetAll("blue", b)
		self:SetAll("theme", "solid")
	else
		self.db.profile.bar[panel].red = r
		self.db.profile.bar[panel].green = g
		self.db.profile.bar[panel].blue = b
		self.db.profile.bar[panel].theme = "solid"
	end
end

function SunnArt:SetTheme(panel, ThemeFile)
	if panel == 0 then
		if ThemeFile ~= nil then self:SetAll("theme", ThemeFile) end
		self:SetAll("overlap", self.ThemeDB.overlap[ThemeFile] or 0)
		self:SetAll("panels", self.ThemeDB.panels[ThemeFile] or 3)
		self:SetAll("length", self.ThemeDB.length[ThemeFile] or 0)
	else
		self.db.profile.bar[panel].theme = ThemeFile
		self.db.profile.bar[panel].overlap = self.ThemeDB.overlap[ThemeFile] or 0
		self.db.profile.bar[panel].panels = self.ThemeDB.panels[ThemeFile] or 3
		self.db.profile.bar[panel].length = self.ThemeDB.length[ThemeFile] or 0
	end
end

function SunnArt:GetGlobal(info)
	local this = info[#info]
	if this == "colour" then
		return self:GetAll("red"), self:GetAll("green"), self:GetAll("blue")
	elseif this == "theme" then
		return self:GetThemeIndex(self:GetAll(this))
	else
		return self:GetAll(this)
	end
end

function SunnArt:GetValue(info)
	local this = info[#info]
	local parent = info[#info-1]
	local parentparent = info[#info-2]
	local bars = {["bottom"]=1,["top"]=2,["left"]=3,["right"]=4}
	if this == "colour" then
		return self.db.profile.bar[bars[parent]].red, self.db.profile.bar[bars[parent]].green, self.db.profile.bar[bars[parent]].blue
	elseif this == "theme" then
		return self:GetThemeIndex(self.db.profile.bar[bars[parent]].theme)
	else
		if bars[parent] then
			return self.db.profile.bar[bars[parent]][this]
		elseif parentparent == "SunnArt" or parentparent == nil or parent == "global" then
			return self.db.profile[this]
		else
			return self.db.profile[parent][this]
		end
	end
end

function SunnArt:SetGlobal(info,...)
	local this = info[#info]
	local args = {}
	for i = 1, select("#", ...) do args[i] = select(i, ...) end
	if this == "colour" then
		self:SetColour(0, ...)
	elseif this == "theme" then
		self:SetTheme(0, self:GetThemeFile(self.ThemeDB.index[args[1]]))
	else
		self:SetAll(this,args[1])
	end
	self:SetViewport()
end

function SunnArt:SetValue(info, ...)
	local this = info[#info]
	local parent = info[#info-1]
	local parentparent = info[#info-2]
	local bars = {["bottom"]=1,["top"]=2,["left"]=3,["right"]=4}
	local args = {}
	local bar
	local i
	for i = 1, select("#",...) do args[i] = select(i,...) end
	
	if this == "colour" then 
		self:SetColour(bars[parent], ...);
	elseif this == "theme" then
		self:SetTheme(bars[parent], self:GetThemeFile(self.ThemeDB.index[args[1]]));
	else
		if bars[parent] then
			self.db.profile.bar[bars[parent]][this] = args[1]
		elseif parentparent == "SunnArt" or parentparent == nil or parent == "global" then
			self.db.profile[this] = args[1]
		else
			self.db.profile[parent][this] = args[1]
		end
	end
	self:SetViewport()
end

function SunnArt:isHidden(info)
	local bars = {["bottom"] = 1, ["top"] = 2, ["left"] = 3, ["right"] = 4}
	local bar = bars[info[#info-1]]
	if bar then
		return not SunnArt.db.profile.bar[bar].enabled
	else
		return false
	end
end

function SunnArt:GetThemeFile(themename)
	local tf, tn, match
	
	for tf,tn in pairs(self.ThemeDB) do
		if tn == themename then match = tf end
	end
	return match
end