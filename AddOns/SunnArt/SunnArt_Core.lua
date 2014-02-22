SunnArt = LibStub("AceAddon-3.0"):NewAddon("SunnArt", "AceConsole-3.0", "AceEvent-3.0")

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("SunnArt", true)
local f = {} --Frame
local MaxArtSections = 5
local SunnArtVisible = true
local SunnArt_MESSAGECOLOR = "FF0000FF"
local SunnArtVersion = "3.48"
local wr -- World Ratio

SunnArt_OptionsTable = {}
SunnArt_Optionstable2 = {}
SunnArt.ThemeDB = {index={}, overlap={}, panels={}, length={}}
SunnArt.overlap = SunnArt.ThemeDB.overlap

function SunnArt:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("SunnArt3DB", SunnArt_DEFAULTS, "Default")
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfileUpdate")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfileUpdate")
	
	self.options = SunnArt_Options
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SunnArt", self.options, {"sunnart","sa"})
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SunnArt", "SunnArt")
	
	self:RegisterChatCommand("SunnArt", "ChatCommand")
	self:RegisterChatCommand("sa", "ChatCommand")
	
	UIParent:SetScript("OnHide", function() self:ToggleUI() end)
	UIParent:SetScript("OnShow", function() self:ToggleUI() end)

	print("|c"..SunnArt_MESSAGECOLOR, L["SunnArt"], "|r: ", L["Loaded"], " - ", L["Type \"/sa\" to open options or \"/sa help\" for console commands"])
end

function SunnArt:ChatCommand(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	else
		if input:trim() == "help" then input = "" end
		if input:trim() == "fixvp" then
			SunnArt:FixVP()
		else
			LibStub("AceConfigCmd-3.0").HandleCommand(self, "sa", "SunnArt", input)
		end
	end
end

function SunnArt:OnEnable() self:Enable() end
function SunnArt:OnDisable() self: Disable() end

function SunnArt:ProfileUpdate()
	if self:IsOldVersion() then self:UpgradeVersion() end;
	self:SetViewport()
end

function SunnArt:Enable()
	if SunnArt:IsOldVersion() then SunnArt:UpgradeVersion() end;
	SunnArt:GetThemeList()
	if (not f[0]) then SunnArt:CreateFrames() end
	SunnArt:SetViewport()
end

function SunnArt:Disable()
	SunnArt:UpdatePanelVisibility(false)
	SunnArt:DisableViewport()
	SAVisible=false;
end

function SunnArt:GetThemeList()
	if #self.ThemeDB.index > 0 then return self.ThemeDB.index end
	local themefile, themename, themeindex
	local function f(tf, tn)
		local ti = self:GetThemeIndex(tf)
		if ti == nil then
			self.ThemeDB[tf] = tn
			table.insert(self.ThemeDB.index, tn)
		else
			self.ThemeDB[tf] = tn
			self.ThemeDB.index[ti] = tn
		end
	end
	self.ThemeDB.index = {}
	if SunnArtPack then table.foreach(SunnArtPack.theme, f) end
	if SunnCustomTheme then table.foreach(SunnCustomTheme, f) end
	table.foreach(self.options.args.theme.values, f)
	table.foreach(self.db.global.themes, f)
	table.sort(self.ThemeDB.index)
	SunnArt:ImportThemes()
	return self.ThemeDB.index
end

function SunnArt:ImportThemes()
	local themefile, var
	for themefile, var in pairs(self.db.global.overlaps) do
		self.ThemeDB.overlap[themefile] = var
	end
	for themefile, var in pairs(self.db.global.panels) do
		self.ThemeDB.panels[themefile] = var
	end
	for themefile, var in pairs(self.db.global.lengths) do
		self.ThemeDB.length[themefile] = var
	end
	if SunnArtPack then
		for themefile, var in pairs (SunnArtPack.overlap) do
			self.ThemeDB.overlap[themefile] = var
		end
		for themefile, var in pairs (SunnArtPack.panels) do
			self.ThemeDB.panels[themefile] = var
		end
		for themefile, var in pairs (SunnArtPack.length) do
			self.ThemeDB.length[themefile] = var
		end
	end
end

function SunnArt:CreateFrames()
	local framelevel

	f[0] = CreateFrame("Frame", "SunnArt_DummyFrame", UIParent)
	f[0]:SetFrameStrata("BACKGROUND")
	f[0]:EnableMouse(false)
	f[0]:SetMovable(false)

	f[1] = CreateFrame("Frame", "SunnArt_BottomFrame", f[0])
	f[2] = CreateFrame("Frame", "SunnArt_TopFrame", f[0])
	f[3] = CreateFrame("Frame", "SunnArt_LeftFrame", f[0])
	f[4] = CreateFrame("Frame", "SunnArt_RightFrame", f[0])

	for i = 1,4 do
		f[i]:SetFrameStrata(strsub(self.db.profile.framestrata,3))
		f[i]:EnableMouse(false)
		f[i]:SetMovable(false)

		framelevel = (i > 2) and 0 or 1
		f[i]:SetFrameLevel(framelevel)
		for j = 1, MaxArtSections do f[i]["art"..j] = f[i]:CreateTexture() end
	end
end

function SunnArt:SetViewport(bh, th, lw, rw)
	local vr = UIParent:GetHeight() / 100 -- Screen ratio's (vertical & horizontal) to
	local hr = UIParent:GetWidth() / 100	-- convert from percentages to actual sizes
	
	bh = bh or self.db.profile.bar[1].size
	th = th or self.db.profile.bar[2].size
	lw = lw or self.db.profile.bar[3].size
	rw = rw or self.db.profile.bar[4].size

	bh = self.db.profile.bar[1].enabled and bh or 0
	th = self.db.profile.bar[2].enabled and th or 0
	lw = self.db.profile.bar[3].enabled and lw or 0
	rw = self.db.profile.bar[4].enabled and rw or 0

	th = -th * vr
	bh = bh * vr
	lw = lw * hr
	rw = -rw * hr

	f[0]:ClearAllPoints()
	f[0]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", lw, th)
	f[0]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", rw, bh)

	self:SetBars()
	self:UpdateViewport()
	self:UpdateStrata()
end

function SunnArt:SetBars()
	self:UpdatePanelSizes()
	self:UpdatePanelVisibility()
	self:UpdateAlpha()
end

function SunnArt:UpdatePanelSizes()
	local vl, vr, vt, vb --Viewport left, right, top, bottom
	local fittop = {}
	local fitbottom = {}
	local fitleft = {}
	local fitright = {}

	vl = f[0]:GetLeft()
	vr = UIParent:GetWidth() - f[0]:GetRight()
	vt = UIParent:GetHeight() - f[0]:GetTop()
	vb = f[0]:GetBottom()

	for i=1,4 do
		if self.db.profile.bar[i].fit == true then
			fitleft[i] = 0
			fitright[i] = 0
			fittop[i] = 0
			fitbottom[i] = 0
		else
			fitleft[i] = vl
			fitright[i] = vr
			fittop[i] = vt
			fitbottom[i] = vb
		end
	end

	-- Bottom panel
	f[1]:ClearAllPoints()
	f[1]:SetPoint("TOPLEFT", f[0], "BOTTOMLEFT", -fitleft[1]-1, 1)
	f[1]:SetPoint("BOTTOMRIGHT", f[0], "BOTTOMRIGHT", fitright[1], -vb)

	-- Top panel
	f[2]:ClearAllPoints()
	f[2]:SetPoint("TOPLEFT", f[0], "TOPLEFT", -fitleft[2]-1, vt+1)
	f[2]:SetPoint("BOTTOMRIGHT", f[0], "TOPRIGHT", fitright[2]+1, 1)

	-- Left panel
	f[3]:ClearAllPoints()
	f[3]:SetPoint("TOPLEFT", f[0], "TOPLEFT", -vl-1, fittop[3]+1)
	f[3]:SetPoint("BOTTOMRIGHT", f[0], "BOTTOMLEFT", 0, -fitbottom[3]+1)

	-- Right panel
	f[4]:ClearAllPoints()
	f[4]:SetPoint("TOPLEFT", f[0], "TOPRIGHT", 0, fittop[4]+1)
	f[4]:SetPoint("BOTTOMRIGHT", f[0], vr, -fitbottom[4]+1)

	self:UpdateArtwork()
end

function SunnArt:UpdateArtwork()
	local olr, elr -- Overlap and Extralength ratio
	local h, w
	local minh, minw
	local anchor = {}
	local i
	
	for i = 1, 4 do
		olr = 100 / (100 - self.db.profile.bar[i].overlap)
		elr = 1 + (self.db.profile.bar[i].length / 100)

		if (i == 1 or i == 2) then
			w = f[i]:GetWidth() / self.db.profile.bar[i].panels * elr
			h = w * self.db.profile.bar[i].scale / 2
			minh = h / olr
		else
			h = f[i]:GetHeight() / self.db.profile.bar[i].panels * elr
			w = h * self.db.profile.bar[i].scale / 2
			minw = w / olr
		end

		if i == 1 then anchor = {"TOPLEFT", "TOPRIGHT", 0, h - (h / olr), {0,0,0,1,1,0,1,1}} end
		if i == 1 and self.db.profile.bar[i].flip then anchor = {"TOPRIGHT", "TOPLEFT", 0, h-(h/olr), {1,0,1,1,0,0,0,1}} end
		if i == 2 then anchor = {"BOTTOMLEFT", "BOTTOMRIGHT", 0, 0, {0,0,0,1,1,0,1,1}} end
		if i == 2 and self.db.profile.bar[i].rotate then anchor = {"BOTTOMRIGHT", "BOTTOMLEFT", 0, -1 * (h - (h / olr)), {1,1,1,0,0,1,0,0}} end
		if i == 2 and self.db.profile.bar[i].flip then anchor = {"BOTTOMRIGHT", "BOTTOMLEFT", 0, 0, {1,0,1,1,0,0,0,1}} end
		if i == 2 and self.db.profile.bar[i].flip and self.db.profile.bar[i].rotate then anchor = {"BOTTOMLEFT", "BOTTOMRIGHT", 0, -1 * (h - (h / olr)), {0,1,0,0,1,1,1,0}} end
		if i == 3 then anchor = {"TOPRIGHT", "BOTTOMRIGHT", w - (w / olr), 0, {0,1,1,1,0,0,1,0}} end
		if i == 3 and self.db.profile.bar[i].flip then anchor = {"BOTTOMRIGHT", "TOPRIGHT", w - (w / olr), 0, {1,1,0,1,1,0,0,0}} end
		if i == 4 then anchor = {"BOTTOMLEFT", "TOPLEFT", -1 * (w - (w / olr)), 0, {1,0,0,0,1,1,0,1}} end
		if i == 4 and self.db.profile.bar[i].flip then anchor = {"TOPLEFT", "BOTTOMLEFT", -1 * (w - (w / olr)), 0, {0,0,1,0,0,1,1,1}} end
		
		for art = 1, MaxArtSections do
			f[i]["art"..art]:ClearAllPoints()

			if self.db.profile.bar[i].autostretch then
				if i == 1 or i == 2 then
					if minh < f[i]:GetHeight() then
						h = f[i]:GetHeight() * olr
						if i == 1 then anchor[4] = h - (h / olr) end
						if i == 2 and self.db.profile.bar[2].rotate then anchor[4] = -1 * (h - (h / olr)) end
					end
				else
					if minw < f[i]:GetWidth() then
						w = f[i]:GetWidth() * olr
						if i == 3 then anchor[3] = w - (w / olr) end
						if i == 4 then anchor[3] = -1 * (w - (w / olr)) end
					end
				end
			end

			if (h == 0 or w == 0 or not self.db.profile.bar[i].enabled) then f[i]["art"..art]:Hide() else f[i]["art"..art]:Show() end

			f[i]["art"..art]:SetTexture("")
			
			if self.db.profile.bar[i].theme == "solid" then
				f[i]["art"..art]:SetTexture(self.db.profile.bar[i].red, self.db.profile.bar[i].green, self.db.profile.bar[i].blue)
			else
				f[i]["art"..art]:SetTexture("Interface\\Addons\\"..self.db.profile.bar[i].theme..art, false)
			end
			
			f[i]["art"..art]:SetWidth(w)
			f[i]["art"..art]:SetHeight(h)

			if art == 1 then
				f[i]["art"..art]:SetPoint(anchor[1], f[i], anchor[1], anchor[3], anchor[4])
			else
				f[i]["art"..art]:SetPoint(anchor[1], f[i]["art"..art-1], anchor[2])
			end
				
			f[i]["art"..art]:SetTexCoord(unpack(anchor[5]))
		end
	end
end

function SunnArt:UpdatePanelVisibility(vis)
	if vis == nil then vis=self.db.profile.artwork end
	for i = 1, 4 do
		if vis then f[i]:Show() else f[i]:Hide() end
	end
	SunnArtVisible = vis
end

function SunnArt:UpdateAlpha()
	for i = 1, 4 do f[i]:SetAlpha(self.db.profile.bar[i].alpha) end
end

function SunnArt:UpdateViewport()
	local top, bottom
	local left, right
   	
	if (self.db.profile.bar[1].resize) then bottom = f[1]:GetHeight() else bottom = 0 end
	if (self.db.profile.bar[2].resize) then top = f[2]:GetHeight() else top = 0 end
	if (self.db.profile.bar[3].resize) then left = f[3]:GetWidth() else left = 0 end
	if (self.db.profile.bar[4].resize) then right = f[4]:GetWidth() else right = 0 end
	
	if not wr then
		WorldFrame:ClearAllPoints()
		WorldFrame:SetPoint("TOPLEFT", 0, 0)
		WorldFrame:SetPoint("BOTTOMRIGHT", 0, 0)
		wr = WorldFrame:GetWidth() / UIParent:GetWidth()
	end
	
	if not InCombatLockdown() then
		WorldFrame:ClearAllPoints()
		WorldFrame:SetPoint("TOPLEFT", left * wr, -top * wr)
		WorldFrame:SetPoint("BOTTOMRIGHT", -right * wr, bottom * wr)
		self:CheckVPCompatibility()
	end
end

function SunnArt:DisableViewport()
	if not InCombatLockdown() then
		WorldFrame:ClearAllPoints()
		WorldFrame:SetPoint("TOPLEFT", 0, 0)
		WorldFrame:SetPoint("BOTTOMRIGHT", 0, 0)
	end
end

function SunnArt:ToggleUI()
	if (not UIParent:IsShown()) then
		self:DisableViewport()
	else
		self:UpdateViewport()
	end
end

function SunnArt:UpdateStrata()
	for i = 1, 4 do
		f[i]:SetFrameStrata(strsub(self.db.profile.framestrata,3))
	end
	if BattlefieldMinimap then
		if BattlefieldMinimap:GetFrameLevel() < 2 then BattlefieldMinimap:SetFrameLevel(2) end
	end
	if PlayerFrame then
		if PlayerFrame:GetFrameLevel() < 2 then PlayerFrame:SetFrameLevel(2) end
	end
	if MinimapCluster then
		if MinimapCluster:GetFrameLevel() < 2 then MinimapCluster:SetFrameLevel(2) end
	end
end

function SunnArt:GetThemeIndex(themefile)
	local ti, tn, match
	for ti, tn in ipairs(self.ThemeDB.index) do
		if tn == self.ThemeDB[themefile] then match = ti end
	end
	return match
end

function SunnArt:IsOldVersion()
	local s = self.db.profile
	local t = {"bottom", "top", "left", "right"}
	
	if s.Theme or s.overlap or s.bfframestrata or s.colourred or s.colourgreen or s.colourblue or s.battlefieldshow or s.battlefieldx or s.battlefieldy or GetBindingKey("SUNNARTUI") then return true end
	for i = 1,4 do
		bar = t[i]
		if s[bar.."bar"] or s[bar.."alpha"] or s[bar.."scale"] or s[bar.."viewport"] or s["autostretch"..bar] or s["rotate"..bar] then return true end
	end
	return false
end

function SunnArt:UpgradeVersion()
	local bar
	local t = {"bottom", "top", "left", "right"}
	local s = self.db.profile
	
	for i = 1, 4 do
		bar = t[i]

		s.bar[i].theme = s.Theme or s.bar[i].theme
		s.bar[i].overlap = s.overlap or s.bar[i].overlap
		s.bar[i].panels = self.db.global.panels[s.bar[i].theme] or s.bar[i].panels
		s.bar[i].red = s.colourred or s.bar[i].red
		s.bar[i].green = s.colourgreen or s.bar[i].green
		s.bar[i].blue = s.colourblue or s.bar[i].blue
		s.bar[i].enabled = s[bar.."bar"] and (s[bar.."bar"] > 0) or s.bar[i].enabled
		s.bar[i].size = s[bar.."bar"] or s.bar[i].size
		s.bar[i].alpha = s[bar.."alpha"] or s.bar[i].alpha
		s.bar[i].scale = s[bar.."scale"] or s.bar[i].scale
		s.bar[i].resize = s[bar.."viewport"] or s.bar[i].resize
		s.bar[i].autostretch = s["autostretch"..bar] or s.bar[i].autostretch
		s.bar[i].rotate = s["rotate"..bar] or s.bar[i].rotate
		
		s.overlap = nil
		s[bar.."bar"] = nil
		s[bar.."alpha"] = nil
		s[bar.."scale"] = nil
		s[bar.."viewport"] = nil
		s["autostretch"..bar] = nil
		s["rotate"..bar] = nil
	end
	
	local tempstrata = {["BACKGROUND"]="1-BACKGROUND",["LOW"]="2-LOW",["MEDIUM"]="3-MEDIUM",["HIGH"]="4-HIGH"}
	s.framestrata = tempstrata[s.framestrata] or s.framestrata or d.framestrata
	
	local BlizzKey = GetBindingKey("TOGGLEUI")
	local SunnKey = GetBindingKey("SUNNARTUI")
	
	if SunnKey and not BlizzKey then
		print("|c"..SunnArt_MESSAGECOLOR, L["SunnArt"], "|r: ", L["Toggle UI key binding set to"],": ",SunnKey)
		SetBinding(SunnKey, "TOGGLEUI")
	end
	
	s.bfframestrata = nil
	s.colourred = nil
	s.colourgreen = nil
	s.colourblue = nil
	s["Theme"] = nil	
	s.battlefieldshow = nil
	s.battlefieldx = nil
	s.battlefieldy = nil

	if SunnKey then SetBinding("SUNNARTUI") end
	
	s.version = SunnArtVersion
	
	print("|c"..SunnArt_MESSAGECOLOR, L["SunnArt"], "|r: ", L["Profile Upgraded"])
end

function SunnArt:CheckVPCompatibility()
	local bottombarvp = self.db.profile.bar[1].enabled and self.db.profile.bar[1].resize
	local topbarvp = self.db.profile.bar[2].enabled and self.db.profile.bar[2].resize
	local leftbarvp = self.db.profile.bar[3].enabled and self.db.profile.bar[3].resize
	local rightbarvp = self.db.profile.bar[4].enabled and self.db.profile.bar[4].resize
	
	local wfresized = bottombarvp or topbarvp or leftbarvp or rightbarvp
	local _, build = GetBuildInfo()
	local watereffectson = GetCVar("waterDetail") > "1" and tonumber(build) < 13195
	local sunshaftson = GetCVar("sunShafts") > "0"
	local errormessage = ""
		
	if wfresized then
		if watereffectson then errormessage = errormessage .. L["VPWaterIncompatible"] end
		if sunshaftson then
			if watereffectson then errormessage = errormessage .. " and " end
			errormessage = errormessage .. L["VPSunshaftsIncompatible"]
		end
		if watereffectson or sunshaftson then errormessage = errormessage .. " " .. L["VPIncompatible"] end
	end
	
	if errormessage ~= "" then print("|c"..SunnArt_MESSAGECOLOR, L["SunnArt"], "|r: ", errormessage) end
end

function SunnArt:FixVP()
	local _, build = GetBuildInfo()
	if GetCVar("waterDetail") > "1" and tonumber(build) < 13195 then
		SetCVar("waterDetail", "1")
		SetCVar("rippleDetail", "1")
		SetCVar("reflectionMode", "0")
		print("|c"..SunnArt_MESSAGECOLOR, L["SunnArt"], "|r: ", L["Liquid Detail set to Fair"])
	end
	if GetCVar("sunShafts") > "0" then
		SetCVar("sunShafts")
		print("|c"..SunnArt_MESSAGECOLOR, L["SunnArt"], "|r: ", L["SunShafts Disabled"])
	end
end