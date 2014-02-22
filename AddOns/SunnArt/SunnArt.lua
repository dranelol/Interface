SunnArt = LibStub("AceAddon-3.0"):NewAddon("SunnArt", "AceConsole-3.0", "AceEvent-3.0")

function SunnArt:OnInitialize()
	self.options = { 
		name = "SunnArt",
		handler = SunnArt,
		type="group",
		args = {
		    artwork = {
				name = "Artwork",
				type = "toggle",
				desc = "Enable or Disable artwork in the panels",
				get = function(info)
					return self.db.profile.artwork
				end,
				set = function(info,a)
  					self:Disable()
					self.db.profile.artwork=a
					self:Enable()
				end,
				order = 1,
			},
			theme = {
				name = "Theme",
				type = "select",
				desc = "Graphical theme",
				get = function(info)
					return self.db.profile.Theme
				end,
				set = function(info,name)
  					self:Disable()
					self.db.profile.Theme=name
					self.db.profile.rotatetop=true
					self:Enable()
				end,
				values = {["SunnArt\\forsaken"] = "Forsaken", ["SunnArt\\tribal"] = "Tribal",["SunnArt\\royal"] = "Royal",["SunnArt\\rogue"] = "Rogue",["solid"] = "Solid colour"},
				style = "dropdown",
				order = 2,
			},
			colourselect = {
				type = "color",
				order = 3,
				name = "Solid colour",
				desc = "Colour of the Solid Colour theme",
				get = function(info)
					return self.db.profile.colourred,self.db.profile.colourgreen,self.db.profile.colourblue
				end,
				set = function(info,r,g,b)
  					self:Disable()
					self.db.profile.colourred = r
					self.db.profile.colourgreen = g
					self.db.profile.colourblue = b
					self.db.profile.Theme = "solid"
					self:Enable()
				end,
			},
			globalspacer = {
				order = 4,
				type = "header",
				name = "Viewport Settings",
			},
			horizviewport = {
				name = "Horizontal Viewport",
				type = "toggle",
				desc = "Enable or Disable the viewport Horizontally",
				get = function(info)
					return (self.db.profile.leftviewport and self.db.profile.rightviewport)
				end,
				set = function(info,v)
					self.db.profile.leftviewport=v
					self.db.profile.rightviewport=v
					self:UpdateViewport()
				end,
				order = 5,
			},
			vertviewport = {
				name = "Vertical Viewport",
				type = "toggle",
				desc = "Enable or Disable the viewport Vertically",
				get = function(info)
					return (self.db.profile.topviewport and self.db.profile.bottomviewport)
				end,
				set = function(info,v)
					self.db.profile.topviewport=v
					self.db.profile.bottomviewport=v
					self:UpdateViewport()
				end,
				order=6,
			},
		    spacer = {
				order = 10,
				type = "header",
				name = "Artwork Panels",
			},				
			top = {
				order = 11,
				type = "group",
				name = "Top panel",
				desc = "Top panel properties",
				args = {
					size = {
						order = 1,
						type = "range",
						name = "Top height",
						desc = "Change the height of the top area (percentage of screen)",
						min = 0,
						max = 100,
						step = 0.1,
						get = function(info)
							return self.db.profile.topbar
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.topbar=v
							self:Enable()
						end,
					},
					alpha = {
						order = 2,
						type = "range",
						name = "Top transparency",
						desc = "Change the transparency of the Top panel",
						min=0,
						max=1,
						step= 0.02,
						get = function(info)
							return self.db.profile.topalpha
						end,
						set = function(info,v)
							self.db.profile.topalpha=v
							self:UpdateAlpha()
						end,
					},
					resize = {
						order = 4,
						name = "Resize Viewport",
						type = "toggle",
						desc = "Toggle Overlay/Viewport mode for this bar",
						get = function(info)
							return (self.db.profile.topviewport)
						end,
						set = function(info,v)
							self.db.profile.topviewport=(v)
							self:UpdateViewport()
						end,
					},
					scale = {
						order = 3,
						type = "range",
						name = "Top artwork scale",
						desc = "Maximum scale of the artwork before stretching occurs",
						min = 0,
						max = 2,
						step = 0.02,
						get = function(info)
							return self.db.profile.topscale
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.topscale=v
							self:Enable()
						end,
					},
					rotate = {
						order = 5,
						type = "toggle",
						name = "Rotate Panel",
						desc = "Rotate the panel so the artwork appears upside down",
						get = function(info)
							return self.db.profile.rotatetop
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.rotatetop=v
							self:Enable()
						end,
					},
					reset = {
						order = 9,
						type = "execute",
						name = "Reset",
						desc = "Restore default values",
						func = function(info)
  							self:Disable()
							self.db.profile.topbar = 2.6
							self.db.profile.topalpha=1.0
							self.db.profile.topviewport = false
							self.db.profile.topscale = 0.58
							self.db.profile.autostretchtop = true
							self.db.profile.rotatetop = true
							self:Enable()
						end,
					},
				},
			},
			bottom = {
				order = 12,
				type = "group",
				name = "Bottom panel",
				desc = "Bottom panel properties",
				args = {
					size = {
						order = 1,
						type = "range",
						name = "Bottom height",
						desc = "Change the height of the bottom area (percentage of screen)",
						min = 0,
						max = 100,
						step = 0.1,
						get = function(info)
							return self.db.profile.bottombar
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.bottombar=v
							self:Enable()
						end,
					},
					alpha = {
						order = 2,
						type = "range",
						name = "Bottom transparency",
						desc = "Change the transparency of the bottom panel",
						min=0,
						max=1,
						step=0.02,
						get = function(info)
							return self.db.profile.bottomalpha
						end,
						set = function(info,v)
							self.db.profile.bottomalpha=v
							self:UpdateAlpha()
						end,
					},
					resize = {
						order = 4,
						name = "Resize Viewport",
						type = "toggle",
						desc = "Toggle Overlay/Viewport mode for this bar",
						get = function(info)
							return (self.db.profile.bottomviewport)
						end,
						set = function(info,v)
							self.db.profile.bottomviewport=(v)
							self:UpdateViewport()
						end,
					},
					scale = {
						order = 3,
						type = "range",
						name = "Bottom artwork scale",
						desc = "Maximum scale of the artwork before stretching occurs",
						min = 0,
						max = 2,
						step = 0.02,
						get = function(info)
							return self.db.profile.bottomscale
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.bottomscale=v
							self:Enable()
						end,
					},
					reset = {
						order = 9,
						type = "execute",
						name = "Reset",
						desc = "Restore default values",
						func = function(info)
  							self:Disable()
							self.db.profile.bottombar = 20
							self.db.profile.bottomalpha=1.0
							self.db.profile.bottomviewport = false
							self.db.profile.bottomscale = 1
							self.db.profile.autostretchbottom = true
							self:Enable()
						end,
					},
				},
			},
			left = {
				order = 13,
				type = "group",
				name = "Left panel",
				desc = "Left panel properties",
				args = {
					size = {
						order = 1,
						type = "range",
						name = "Left width",
						desc = "Change the width of the left area (percentage of screen)",
						min = 0,
						max = 100,
						step = 0.1,
						get = function(info)
							return self.db.profile.leftbar
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.leftbar=v
							self:Enable()
						end,
					},
					alpha = {
						order = 2,
						type = "range",
						name = "Left transparency",
						desc = "Change the transparency of the left panel",
						min=0,
						max=1,
						step=0.02,
						get = function(info)
							return self.db.profile.leftalpha
						end,
						set = function(info,v)
							self.db.profile.leftalpha=v
							self:UpdateAlpha()
						end,
					},
					resize = {
						order = 4,
						name = "Resize Viewport",
						type = "toggle",
						desc = "Toggle Overlay/Viewport mode for this bar",
						get = function(info)
							return (self.db.profile.leftviewport)
						end,
						set = function(info,v)
							self.db.profile.leftviewport=(v)
							self:UpdateViewport()
						end,
					},
					scale = {
						order = 3,
						type = "range",
						name = "Left artwork scale",
						desc = "Maximum scale of the artwork before stretching occurs",
						min = 0,
						max = 2,
						step = 0.02,
						get = function(info)
							return self.db.profile.leftscale
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.leftscale=v
							self:Enable()
						end,
					},
					reset = {
						order = 9,
						type = "execute",
						name = "Reset",
						desc = "Restore default values",
						func = function(info)
  							self:Disable()
							self.db.profile.leftbar = 0
							self.db.profile.leftalpha = 1.0
							self.db.profile.leftviewport = false
							self.db.profile.leftscale = 1
							self.db.profile.autostretchleft = true
							self:Enable()
						end,
					},
				},
			},
			right = {
				order = 14,
				type = "group",
				name = "Right panel",
				desc = "Right panel properties",
				args = {
					size = {
						order = 1,
						type = "range",
						name = "Right width",
						desc = "Change the width of the right area (percentage of screen)",
						min = 0,
						max = 100,
						step = 0.1,
						get = function(info)
							return self.db.profile.rightbar
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.rightbar=v
							self:Enable()
						end,
					},
					alpha = {
						order = 2,
						type = "range",
						name = "Right transparency",
						desc = "Change the transparency of the right panel",
						min=0,
						max=1,
						step=0.02,
						get = function(info)
							return self.db.profile.rightalpha
						end,
						set = function(info,v)
							self.db.profile.rightalpha=v
							self:UpdateAlpha()
						end,
					},
					resize = {
						order = 4,
						name = "Resize Viewport",
						type = "toggle",
						desc = "Toggle Overlay/Viewport mode for this bar",
						get = function(info)
							return (self.db.profile.rightviewport)
						end,
						set = function(info,v)
							self.db.profile.rightviewport=(v)
							self:UpdateViewport()
						end,
					},
					scale = {
						order = 3,
						type = "range",
						name = "Right artwork scale",
						desc = "Maximum scale of the artwork before stretching occurs",
						min = 0,
						max = 2,
						step = 0.02,
						get = function(info)
							return self.db.profile.rightscale
						end,
						set = function(info,v)
  							self:Disable()
							self.db.profile.rightscale=v
							self:Enable()
						end,
					},
					reset = {
						order = 9,
						type = "execute",
						name = "Reset",
						desc = "Restore default values",
						func = function(info)
  							self:Disable()
							self.db.profile.rightbar = 0
							self.db.profile.rightalpha = 1.0
							self.db.profile.rightviewport = false
							self.db.profile.rightscale = 1
							self.db.profile.autostretchright = true
							self:Enable()
						end,
					},
				},
			},
			advanced = {
				order = 15,
				type = "group",
				name = "Advanced",
				desc = "Advanced options",
				args = {					
					framelevels = {
						order = 1,
						type = "group",
						name = "Frame Levels",
						desc = "Frame Levels (Strata)",
						args = {
							framestrata = {
								order = 1,
								type = "select",
								name = "Frame Strata",
								desc = "Sets the strata (layer depth) of the frames",
								values = {["BACKGROUND"]="Background",["LOW"]="Low",["MEDIUM"]="Medium",["HIGH"]="High"},
								get = function(info)
									return self.db.profile.framestrata
								end,
								set = function(info,v)
									self.db.profile.framestrata = v
									self.frame1:SetFrameStrata(v)
									self.frame2:SetFrameStrata(v)
									self.frame3:SetFrameStrata(v)
									self.frame4:SetFrameStrata(v)
								end,
							},
							bfframestrata = {
							order = 2,
							type = "select",
							name = "Battlefield Frame Strata",
							desc = "Sets the strata (layer depth) of the battlefield frame",
							values = {["BACKGROUND"]="Background",["LOW"]="Low",["MEDIUM"]="Medium",["HIGH"]="High"},
							get = function(info)
								return self.db.profile.bfframestrata
							end,
							set = function(info,v)
								self.db.profile.bfframestrata = v
								if (BattlefieldMinimap) then 
									BattlefieldMinimap:SetFrameStrata(v)
								end
							end,
							},
						},
					},
					autostretch = {
						order = 15,
						type = "group",
						name = "Auto-Stretch",
						desc = "Auto-Stretch textures to the side of the screen if the panel is too narrow",
						args = {
							top = {
								order = 1,
								name = "Top",
								type = "toggle",
								desc = "Toggle auto-stretch for this bar",
								get = function(info)
									return self.db.profile.autostretchtop
								end,
								set = function(info,v)
									self.db.profile.autostretchtop = v
									self:Enable()
								end,
							},
							bottom = {
								order = 2,
								name = "Bottom",
								type = "toggle",
								desc = "Toggle auto-stretch for this bar",
								get = function(info)
									return self.db.profile.autostretchbottom
								end,
								set = function(info,v)
									self.db.profile.autostretchbottom = v
									self:Enable()
								end,
							},
							left = {
								order = 3,
								name = "Left",
								type = "toggle",
								desc = "Toggle auto-stretch for this bar",
								get = function(info)
									return self.db.profile.autostretchleft
								end,
								set = function(info,v)
									self.db.profile.autostretchleft = v
									self:Enable()
								end,
							},
							right = {
								order = 4,
								name = "Right",
								type = "toggle",
								desc = "Toggle auto-stretch for this bar",
								get = function(info)
									return self.db.profile.autostretchright
								end,
								set = function(info,v)
									self.db.profile.autostretchright = v
									self:Enable()
								end,
							},
						},
					},				
				},
			},
		},
	}
	SunnArt_DEFAULTS = {
		profile = {
			topbar = 2.6,
			bottombar = 20,
			leftbar = 0,
			rightbar = 0,
			topalpha = 1.0,
			bottomalpha = 1.0,
			leftalpha = 1.0,
			rightalpha = 1.0,
			topscale = 0.58,
			bottomscale = 1,
			leftscale = 1,
			rightscale = 1,
			topviewport = false,
			bottomviewport = false,
			leftviewport = false,
			rightviewport = false,
			Theme = "SunnArt\\royal",
			artwork = true,
			colourred = 0,
			colourgreen = 0,
			colourblue = 0,
			autostretchtop = true,
			autostretchbottom = true,
			autostretchleft = true,
			autostretchright = true,
			ol=0,
			rotatetop = true,
			framestrata = "BACKGROUND",
			bfframestrata = "LOW",
		}
	}

	self.db = LibStub("AceDB-3.0"):New("SunnArt3DB", SunnArt_DEFAULTS, "Default")
	
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SunnArt", self.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SunnArt", "SunnArt")
	self:RegisterChatCommand("SunnArt", "ChatCommand")
	self:RegisterChatCommand("sa", "ChatCommand")
	self:RegisterChatCommand("sunn", "ChatCommand")
	
	self.db.RegisterCallback(self, 'OnProfileChanged', 'Enable')
	self.db.RegisterCallback(self, 'OnProfileCopied', 'Enable')
	self.db.RegisterCallback(self, 'OnProfileReset', 'Enable')
	
    BINDING_HEADER_SUNNART = "Sunn - Viewport Art"
    BINDING_NAME_SUNNARTUI = "Toggle UI"
	
	self.overlap = {}

	self:CreateFrames()
	self.OnMenuRequest = self.options
	
	for themename,themefile in pairs(SunnCustomTheme) do
		SunnArt.options.args.theme.values[themename]=themefile
	end
	for themename,themeoverlap in pairs(SunnCustomOverlap) do
		SunnArt.overlap[themename]=themeoverlap
	end
	
	DEFAULT_CHAT_FRAME:AddMessage("|cFF0000FFSunnArt|r: Loaded")
end

function SunnArt:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(SunnArt, "sa", "SunnArt", input)
	end
end

function SunnArt:CreateFrames()
	testframe = null
	testframe = CreateFrame("Frame", "SunnTestFrame")
	testframe:SetFrameStrata("BACKGROUND")
	testframe:EnableMouse(false)
	testframe:SetMovable(false)

	testframe:ClearAllPoints()
	testframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	testframe:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",0,0)
	
	self.vertratio=testframe:GetHeight()/100
	self.horizratio=testframe:GetWidth()/100

	testframe = null
	
    if (not self.dummyframe) then
		self.dummyframe = CreateFrame("Frame", "SunnArtDummyFrame")
		self.dummyframe:SetFrameStrata("BACKGROUND")
		self.dummyframe:EnableMouse(false)
		self.dummyframe:SetMovable(false)
	end
	if (not self.frame1) then
		self.frame1 = CreateFrame("Frame", "SunnArtFrameBottom")
		self.frame1:SetFrameStrata(self.db.profile.framestrata)
		self.frame1:SetFrameLevel(1)
		self.frame1:EnableMouse(false)
		self.frame1:SetMovable(false)
		self["art11"] = self.frame1:CreateTexture("$parentArt1","BACKGROUND")
		self["art12"] = self.frame1:CreateTexture("$parentArt2","BACKGROUND")
		self["art13"] = self.frame1:CreateTexture("$parentArt3","BACKGROUND")
	end
	if (not self.frame2) then
		self.frame2 = CreateFrame("Frame", "SunnArtFrameTop")
		self.frame2:SetFrameStrata(self.db.profile.framestrata)
		self.frame2:SetFrameLevel(1)
		self.frame2:EnableMouse(false)
		self.frame2:SetMovable(false)
		self["art21"] = self.frame2:CreateTexture("$parentArt1","BACKGROUND")
		self["art22"] = self.frame2:CreateTexture("$parentArt2","BACKGROUND")
		self["art23"] = self.frame2:CreateTexture("$parentArt3","BACKGROUND")
	end
	if (not self.frame3) then
		self.frame3 = CreateFrame("Frame", "SunnArtFrameLeft")
		self.frame3:SetFrameStrata(self.db.profile.framestrata)
		self.frame3:EnableMouse(false)
		self.frame3:SetMovable(false)
		self["art31"] = self.frame3:CreateTexture("$parentArt1","BACKGROUND")
		self["art32"] = self.frame3:CreateTexture("$parentArt2","BACKGROUND")
		self["art33"] = self.frame3:CreateTexture("$parentArt3","BACKGROUND")
	end
	if (not self.frame4) then
		self.frame4 = CreateFrame("Frame", "SunnArtFrameRight")
		self.frame4:SetFrameStrata(self.db.profile.framestrata)
		self.frame4:EnableMouse(false)
		self.frame4:SetMovable(false)
		self["art41"] = self.frame4:CreateTexture("$parentArt1","BACKGROUND")
		self["art42"] = self.frame4:CreateTexture("$parentArt2","BACKGROUND")
		self["art43"] = self.frame4:CreateTexture("$parentArt3","BACKGROUND")
	end
end

function SunnArt:OnEnable()
	self:Enable()
end

function SunnArt:OnDisable()
    self:Disable()
end

function SunnArt:OnProfileDisable()
	self:Disable()
end

function SunnArt:OnProfileEnable()
	self:Enable()
end

function TextureMinHeight(Panelwidth,scale)
	local ret = 0
	ret=scale*Panelwidth/6
	return ret
end

function SunnArt:SetBars()
	local temp
	local texturepath
	
	self.frame1:ClearAllPoints()
	self.frame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -1, 0)
	self.frame1:SetPoint("TOPRIGHT",UIParent,"BOTTOMRIGHT",0,self.db.profile.bottombar*self.vertratio)
	
	self.frame2:ClearAllPoints()
	self.frame2:SetPoint("BOTTOMLEFT", UIParent, "TOPLEFT", -1, -self.db.profile.topbar*self.vertratio)
	self.frame2:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",0,0)
		
	actualheight=SunnArtFrameBottom:GetHeight()
	scaledheight=TextureMinHeight(SunnArtFrameBottom:GetWidth(),SunnArt.db.profile.bottomscale)
	if actualheight<scaledheight then bottomol=-(actualheight-scaledheight)*self:GetThemeOverlap()/100 else bottomol=0 end
	actualheight=SunnArtFrameTop:GetHeight()
	scaledheight=TextureMinHeight(SunnArtFrameTop:GetWidth(),SunnArt.db.profile.topscale)
	if actualheight<scaledheight then topol=-(actualheight-scaledheight)*self:GetThemeOverlap()/100 else topol=0 end
	
	self.frame3:ClearAllPoints()
	self.frame3:SetPoint("BOTTOMLEFT", self.frame1, "TOPLEFT", 0, -(self.frame1:GetHeight()*self:GetThemeOverlap()/100)-bottomol)
	self.frame3:SetPoint("TOPRIGHT",self.frame2,"BOTTOMLEFT",self.db.profile.leftbar*self.horizratio,(self.frame2:GetHeight()*self:GetThemeOverlap()/100)+topol)
	
	
	self.frame4:ClearAllPoints()
	self.frame4:SetPoint("BOTTOMLEFT", self.frame1, "TOPRIGHT", -self.db.profile.rightbar*self.horizratio, -(self.frame1:GetHeight()*self:GetThemeOverlap()/100)-bottomol)
	self.frame4:SetPoint("TOPRIGHT",self.frame2,"BOTTOMRIGHT",0,(self.frame2:GetHeight()*self:GetThemeOverlap()/100)+topol)
  
	for i=1,3 do
		texturepath="Interface\\Addons\\"..self.db.profile.Theme..i
		if not self.db.profile.rotatetop then
			if i==1 then texturepath2="Interface\\Addons\\"..self.db.profile.Theme.."3" end
			if i==2 then texturepath2="Interface\\Addons\\"..self.db.profile.Theme.."2" end
			if i==3 then texturepath2="Interface\\Addons\\"..self.db.profile.Theme.."1" end
		else
			texturepath2=texturepath
		end
		
		self["art1"..i]:SetWidth(SunnArtFrameBottom:GetWidth()/3)
		self["art1"..i]:SetHeight(SunnArtFrameBottom:GetHeight())
		if (self.db.profile.Theme ~= "solid") then self["art1"..i]:SetTexture(texturepath) else self["art1"..i]:SetTexture(self.db.profile.colourred,self.db.profile.colourgreen,self.db.profile.colourblue) end
		self["art1"..i]:ClearAllPoints()
		
		if self.db.profile.rotatetop then self["art2"..i]:SetTexCoord(1,1,1,0,0,1,0,0) else self["art2"..i]:SetTexCoord(0,0,0,1,1,0,1,1) end
		self["art2"..i]:SetWidth(SunnArtFrameTop:GetWidth()/3)
		self["art2"..i]:SetHeight(SunnArtFrameTop:GetHeight())
		if not self.db.profile.rotatetop then usetexture=texturepath2 else usetexture=texturepath end
		if (self.db.profile.Theme ~= "solid") then self["art2"..i]:SetTexture(usetexture) else self["art2"..i]:SetTexture(self.db.profile.colourred,self.db.profile.colourgreen,self.db.profile.colourblue) end
		self["art2"..i]:ClearAllPoints()
		
		self["art3"..i]:SetTexCoord(0,1,1,1,0,0,1,0)
		self["art3"..i]:SetWidth(SunnArtFrameLeft:GetWidth())
		self["art3"..i]:SetHeight(SunnArtFrameLeft:GetHeight()/3)
		if (self.db.profile.Theme ~= "solid") then self["art3"..i]:SetTexture(texturepath) else self["art3"..i]:SetTexture(self.db.profile.colourred,self.db.profile.colourgreen,self.db.profile.colourblue) end
		self["art3"..i]:ClearAllPoints()
		
		self["art4"..i]:SetTexCoord(1,0,0,0,1,1,0,1)
		self["art4"..i]:SetWidth(SunnArtFrameRight:GetWidth())
		self["art4"..i]:SetHeight(SunnArtFrameRight:GetHeight()/3)
		if (self.db.profile.Theme ~= "solid") then self["art4"..i]:SetTexture(texturepath) else self["art4"..i]:SetTexture(self.db.profile.colourred,self.db.profile.colourgreen,self.db.profile.colourblue) end
		self["art4"..i]:ClearAllPoints()
		
		if i == 1 then
			self["art1"..i]:SetPoint("TOPLEFT", self.frame1, "TOPLEFT", 0, 0)
			if self.db.profile.rotatetop then
				self["art2"..i]:SetPoint("BOTTOMRIGHT", self.frame2, "BOTTOMRIGHT", 0, 0)
			else
				actualheight=SunnArtFrameTop:GetHeight()
				scaledheight=TextureMinHeight(SunnArtFrameTop:GetWidth(),SunnArt.db.profile.topscale)
				if actualheight<scaledheight then topol=-(actualheight-scaledheight)*self:GetThemeOverlap()/100 else topol=0 end
				newtop=(self["art21"]:GetHeight()*self:GetThemeOverlap()/100)+topol
				if newtop<0 then newtop=0 end
				self["art2"..i]:SetPoint("BOTTOMRIGHT",self.frame2,"BOTTOMRIGHT",0,newtop)
			end
			self["art3"..i]:SetPoint("TOPRIGHT", self.frame3, "TOPRIGHT", 0, 0)
			self["art4"..i]:SetPoint("BOTTOMLEFT", self.frame4, "BOTTOMLEFT", 0, 0)
		else
			self["art1"..i]:SetPoint("TOPLEFT", self["art1"..i-1], "TOPRIGHT", 0, 0)
			self["art2"..i]:SetPoint("TOPRIGHT", self["art2"..i-1], "TOPLEFT", 0, 0)
			self["art3"..i]:SetPoint("TOPLEFT", self["art3"..i-1], "BOTTOMLEFT", 0, 0)
			self["art4"..i]:SetPoint("BOTTOMRIGHT", self["art4"..i-1], "TOPRIGHT", 0, 0)
		end
		
		temp=TextureMinHeight(SunnArtFrameBottom:GetWidth(),SunnArt.db.profile.bottomscale)
		if (SunnArtFrameBottom:GetHeight()<=temp or not self.db.profile.autostretchbottom) then self["art1"..i]:SetHeight(temp) end
		temp=TextureMinHeight(SunnArtFrameTop:GetWidth(),SunnArt.db.profile.topscale)
		if (SunnArtFrameTop:GetHeight()<=temp or not self.db.profile.autostretchtop) then self["art2"..i]:SetHeight(temp) end
		temp=TextureMinHeight(SunnArtFrameLeft:GetHeight(),SunnArt.db.profile.leftscale)
		if (SunnArtFrameLeft:GetWidth()<=temp or not self.db.profile.autostretchleft) then self["art3"..i]:SetWidth(temp) end
		temp=TextureMinHeight(SunnArtFrameRight:GetHeight(),SunnArt.db.profile.rightscale)
		if (SunnArtFrameRight:GetWidth()<=temp or not self.db.profile.autostretchright) then self["art4"..i]:SetWidth(temp) end
				
		if (SunnArtFrameBottom:GetHeight()~=0) then self["art1"..i]:Show() end
		if (SunnArtFrameTop:GetHeight()~=0) then self["art2"..i]:Show() end
		if (SunnArtFrameLeft:GetWidth()~=0) then self["art3"..i]:Show() end
		if (SunnArtFrameRight:GetWidth()~=0) then self["art4"..i]:Show() end
	end
	self.frame1:Hide()
	self.frame2:Hide()
	self.frame3:Hide()
	self.frame4:Hide()
	if (self.db.profile.artwork==true) then
		self.frame1:Show()
		self.frame2:Show()
		self.frame3:Show()
		self.frame4:Show()
	end
	self:UpdateAlpha()
end

function SunnArt:UpdateAlpha()
	SunnArtFrameBottom:SetAlpha(self.db.profile.bottomalpha)
	SunnArtFrameTop:SetAlpha(self.db.profile.topalpha)
	SunnArtFrameLeft:SetAlpha(self.db.profile.leftalpha)
	SunnArtFrameRight:SetAlpha(self.db.profile.rightalpha)
end

function SunnArt:SetViewport(topheight,bottomheight,leftwidth,rightwidth,olap)
	if (topheight==nil) then topheight=0 end
	if (bottomheight==nil) then bottomheight=0 end
	if (leftwidth==nil) then leftwidth=0 end
	if (rightwidth==nil) then rightwidth=0 end
	
	topheight=-topheight*self.vertratio
	bottomheight=bottomheight*self.vertratio
    leftwidth=leftwidth*self.horizratio
    rightwidth=-rightwidth*self.horizratio
	
	bottomheight=bottomheight-((self["art11"]:GetHeight()/100)*olap)
	topheight=topheight+((self["art21"]:GetHeight()/100)*olap)
	leftwidth=leftwidth-((self["art31"]:GetWidth()/100)*olap)
	rightwidth=rightwidth+((self["art41"]:GetWidth()/100)*olap)

	self.dummyframe:ClearAllPoints()
	self.dummyframe:SetPoint("TOPLEFT", leftwidth, topheight)
	self.dummyframe:SetPoint("BOTTOMRIGHT", rightwidth, bottomheight)
end

function SunnArt:UpdateViewport()
	local ULx,ULy
	local LRx,LRy
	
	if (self.db.profile.leftviewport)  then ULx=0 else ULx=-SunnArtFrameLeft:GetWidth() end
	if (self.db.profile.rightviewport) then LRx=0 else LRx=SunnArtFrameRight:GetWidth() end
	if (self.db.profile.topviewport)   then ULy=0 else ULy=SunnArtFrameTop:GetHeight() end
	if (self.db.profile.bottomviewport) then LRy=0 else LRy=-SunnArtFrameBottom:GetHeight() end

	WorldFrame:ClearAllPoints()	
	WorldFrame:SetPoint("TOPLEFT", self.dummyframe, "TOPLEFT", ULx, ULy)
	WorldFrame:SetPoint("BOTTOMRIGHT", self.dummyframe, "BOTTOMRIGHT", LRx, LRy)
end

function SunnArt:DisableViewport()
	WorldFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
	WorldFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT",0,0)
end

function SunnArt:Enable()
	local temp
	if (not(self.dummyframe or self.frame1 or self.frame2 or self.frame3 or self.frame4)) then self:CreateFrames() end
	temp=self.dummyframe:GetTop()
	temp=self.dummyframe:GetBottom()
	temp=self.dummyframe:GetLeft()
	temp=self.dummyframe:GetRight()
	self:SetBars()
	temp=self.dummyframe:GetTop()
	temp=self.dummyframe:GetBottom()
	temp=self.dummyframe:GetLeft()
	temp=self.dummyframe:GetRight()
	self:SetViewport(self.db.profile.topbar,self.db.profile.bottombar,self.db.profile.leftbar,self.db.profile.rightbar,self:GetThemeOverlap())
	temp=self.dummyframe:GetTop()
	temp=self.dummyframe:GetBottom()
	temp=self.dummyframe:GetLeft()
	temp=self.dummyframe:GetRight()
	if (self.db.profile.artwork) then
		self.frame1:Show()
		self.frame2:Show()
		self.frame3:Show()
		self.frame4:Show()
	end
	temp=self.dummyframe:GetTop()
	temp=self.dummyframe:GetBottom()
	temp=self.dummyframe:GetLeft()
	temp=self.dummyframe:GetRight()
	self:UpdateViewport()
	temp=self.dummyframe:GetTop()
	temp=self.dummyframe:GetBottom()
	temp=self.dummyframe:GetLeft()
	temp=self.dummyframe:GetRight()
	SAVisible=true;
    if (BattlefieldMinimap) then
		BattlefieldMinimap:SetFrameStrata(self.db.profile.bfframestrata)
	end
end

function SunnArt:Disable()
	if (self.frame1) then self.frame1:Hide() end
	if (self.frame2) then self.frame2:Hide() end
	if (self.frame3) then self.frame3:Hide() end
	if (self.frame4) then self.frame4:Hide() end
	
    if (self.db.profile.leftviewport or self.db.profile.rightviewport or self.db.profile.topviewport or self.db.profile.bottomviewport) then
		self:DisableViewport()
	end
	SAVisible=false;
end

function SunnArt:ToggleUI()
	if (UIParent:GetAlpha()~=0) then
		UIParent:SetAlpha(0)
		Minimap:Hide()
		SunnArt:Disable()
  	else
		UIParent:SetAlpha(1)
		Minimap:Show()
		SunnArt:Enable()
	end
end

function SunnArt:GetThemeOverlap()
	temp=0
	if self.overlap==nil then
		temp=0
	else
		for name,value in pairs(self.overlap) do
			if name==self.db.profile.Theme then temp=value end
		end
	end
	return temp
end