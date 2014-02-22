


KillTheHealer = {}
KillTheHealer.Size = 50
KillTheHealer.Path = "Interface\\LFGFrame\\UI-LFG-ICON-RoleS"
KillTheHealer.left = 0.26171875
KillTheHealer.right = 0.5234375
KillTheHealer.top = 0
KillTheHealer.bottom = 0.26171875


local heallist = {}

local exclass = {}


local testing = nil

exclass.WARRIOR = true
exclass.DEATHKNIGHT = true
exclass.MAGE = true
exclass.WARLOCK = true
exclass.ROGUE = true


local function UpdatePlate(self)

	
	if testing then
		self.HPHeal:Show()
	else
		if heallist[self.HPname:GetText()] then
			if exclass[heallist[self.HPname:GetText()]] then
				self.HPHeal:Hide()
			else
				self.HPHeal:Show()
			end
		else
			self.HPHeal:Hide()
		end
	end
end

local function IsValidFrame (frame)
	if not( frame:GetName() and strsub(frame:GetName(), 1, 9 ) == "NamePlate" ) then 
		return
	end
	if frame.aloftData then 
		return true
	end
	if frame.done then
		return true
	end
	
	if frame.HPHeal then
		return true
	end
	local overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
end


local function CreatePlate(frame)
	if frame.HPHeal then
		return
	end

	local nameTextRegion = select( 4, frame:GetRegions() ) 
	
	frame.HPname = nameTextRegion
	
	frame.HPHeal = frame:CreateTexture()
	frame.HPHeal:SetHeight(KillTheHealer.Size)
	frame.HPHeal:SetWidth(KillTheHealer.Size)
	frame.HPHeal:SetPoint("BOTTOM", frame, "TOP", 0, 10)	
	
	frame.HPHeal:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-RoleS")
	frame.HPHeal:SetTexCoord(KillTheHealer.left,KillTheHealer.right,KillTheHealer.top,KillTheHealer.bottom)
	

	UpdatePlate(frame)
	frame:HookScript("OnShow", UpdatePlate)
	--frame:SetScript("OnShow", UpdatePlate)

end

local numKids = 0
local lastUpdate = 0

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed

	if lastUpdate > 5 then
		lastUpdate = 0
		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids + 1, newNumKids do
				local frame = select(i, WorldFrame:GetChildren())
				if IsValidFrame(frame) then
					CreatePlate(frame)
				end
			end
			numKids = newNumKids
		end
	end
end)



local lastcheck = 0
local t = CreateFrame("Frame")


local function CheckHealers(self, elapsed)	
	lastcheck = lastcheck + elapsed
	if lastcheck > 30 then
		lastcheck = 0
		heallist = {}
		for i = 1, GetNumBattlefieldScores() do
					local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange = GetBattlefieldScore(i);
				if (healingDone > damageDone*1.2) and faction == 1 then
					name = name:match("(.+)%-.+") or name
					heallist[name] = classToken
				end
		end
	end
end

local function checkloc(self, event)
	if (event == "PLAYER_ENTERING_WORLD") or (event == "PLAYER_ENTERING_BATTLEGROUND") then
				local isin, instype = IsInInstance()
				if isin and instype == "pvp" then
					t:SetScript("OnUpdate", CheckHealers)
				else
					heallist = {}
					t:SetScript("OnUpdate", nil)
				end
				
	end
end
t:RegisterEvent("PLAYER_ENTERING_WORLD")
t:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
t:SetScript("OnEvent", checkloc)



local function TestIt()
testing = not testing

end

SLASH_KHeal1 = "/KHT";
SlashCmdList["KHeal"] = TestIt;



--======================== OPTIONS ==================================
--===================================================================





local options = CreateFrame("Frame")

local Icon = options:CreateTexture()
			Icon:SetHeight(KillTheHealer.Size)
			Icon:SetWidth(KillTheHealer.Size)
			Icon:SetPoint("CENTER", options, "TOP", 0, -130)
			Icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-RoleS")
			Icon:SetTexCoord(GetTexCoordsForRole("HEALER"))

local function CheckEditBox(self)
	local msg = self:GetText()
	local oldtex = Icon:GetTexture()
	
	Icon:SetTexture(msg)
	local visible = Icon:GetTexture()
	if visible then
		KillTheHealer.Path = msg
		self:SetTextColor(0,1,0)
	else
		Icon:SetTexture(oldtex)
		self:SetTextColor(1,0,0)
	end
	options.update()
end





local Title = options:CreateFontString("BSTitle", "OVERLAY", "GameFontNormal")
Title:SetText("KillTheHealer Configuration:")
Title:SetWidth(200)
Title:SetHeight(20)
Title:SetPoint("TOP", options, "TOP", 0, -20)

local WidthText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
WidthText:SetText("Border Size:")
WidthText:SetWidth(100)
WidthText:SetHeight(20)
WidthText:SetPoint("TOP", options, "TOP", -140, -200)

local PathText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
PathText:SetText("Path:")
PathText:SetWidth(100)
PathText:SetHeight(20)
PathText:SetPoint("TOP", options, "TOP", -140, -250)

local CoordsText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CoordsText:SetText("Texture Coordinates (Advanced):")
CoordsText:SetWidth(250)
CoordsText:SetHeight(20)
CoordsText:SetPoint("TOP", options, "TOP", -50, -300)

local LeftText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
LeftText:SetText("Left:")
LeftText:SetWidth(100)
LeftText:SetHeight(20)
LeftText:SetPoint("TOP", options, "TOP", -100, -340)

local RightText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
RightText:SetText("Right:")
RightText:SetWidth(100)
RightText:SetHeight(20)
RightText:SetPoint("TOP", options, "TOP", -100, -380)

local TopText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TopText:SetText("Top")
TopText:SetWidth(100)
TopText:SetHeight(20)
TopText:SetPoint("TOP", options, "TOP", -100, -420)

local BottomText = options:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BottomText:SetText("Bottom:")
BottomText:SetWidth(100)
BottomText:SetHeight(20)
BottomText:SetPoint("TOP", options, "TOP", -100, -460)

local PathBox = CreateFrame("EditBox", "KTHPathEB", options, "InputBoxTemplate")
			PathBox:SetSize(250, 20)
			PathBox:SetPoint("TOP", options, "TOP", 25, -250)
			PathBox:SetAutoFocus(false)
			PathBox:SetScript("OnShow", options.update)
			PathBox:SetScript("OnEnterPressed", CheckEditBox)
			
local coords = {}

local function UpdateCoords()
local l,r,t,b = coords.left:GetText(), coords.right:GetText(), coords.top:GetText(), coords.bottom:GetText()

	KillTheHealer.left = l
	KillTheHealer.right = r
	KillTheHealer.top = t
	KillTheHealer.bottom = b
	
	options.update()

end

 coords.left = CreateFrame("EditBox", "KTHEBleft", options, "InputBoxTemplate")
	--coords.left:SetNumeric(true)
			coords.left:SetSize(80, 20)
			coords.left:SetPoint("TOP", options, "TOP", 30, -340)
			coords.left:SetAutoFocus(false)
			coords.left:SetScript("OnShow", options.update)
			coords.left:SetScript("OnEnterPressed", UpdateCoords)

 coords.right = CreateFrame("EditBox", "KTHEBright", options, "InputBoxTemplate")
 
			coords.right:SetSize(80, 20)
			coords.right:SetPoint("TOP", options, "TOP", 30, -380)
			coords.right:SetAutoFocus(false)
			coords.right:SetScript("OnShow", options.update)
			coords.right:SetScript("OnEnterPressed", UpdateCoords)
			
 coords.top = CreateFrame("EditBox", "KTHEBtop", options, "InputBoxTemplate")
 
			coords.top:SetSize(80, 20)
			coords.top:SetPoint("TOP", options, "TOP", 30, -420)
			coords.top:SetAutoFocus(false)
			coords.top:SetScript("OnEnterPressed", UpdateCoords)
			
 coords.bottom = CreateFrame("EditBox", "KTHEBbottom", options, "InputBoxTemplate")

			coords.bottom:SetSize(80, 20)
			coords.bottom:SetPoint("TOP", options, "TOP", 30, -460)
			coords.bottom:SetAutoFocus(false)
			coords.bottom:SetScript("OnShow",options.update)
			coords.bottom:SetScript("OnEnterPressed", UpdateCoords)


local sizeslide = CreateFrame("Slider", "KTHHealSlide", options, "OptionsSliderTemplate")

				sizeslide:SetMinMaxValues(20,100)
				sizeslide:SetValueStep(1)
				sizeslide:SetValue(0)
				_G["KTHHealSlide".."Low"]:SetText("20")
				_G["KTHHealSlide".."High"]:SetText("100")
				sizeslide:SetScript("OnValueChanged",
							function(self)
								KillTheHealer.Size = self:GetValue()
								options.update() end)
						
				sizeslide:SetWidth(200)
				sizeslide:SetHeight(20)
				sizeslide:SetPoint("TOP", options, "TOP", 40, -200)
					
local ResetButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
ResetButton:SetPoint("BOTTOM", options, "BOTTOM", 0, 40)
ResetButton:SetText("Reset")
ResetButton:SetSize(80, 25)
ResetButton:SetScript("OnClick", function(self) 
																	KillTheHealer.Size = 50
																	KillTheHealer.Path = "Interface\\LFGFrame\\UI-LFG-ICON-RoleS"
																	KillTheHealer.left = 0.26171875
																	KillTheHealer.right = 0.5234375
																	KillTheHealer.top = 0
																	KillTheHealer.bottom = 0.26171875
																	sizeslide:SetValue(50)
																	options.update()
																	end)
			
--=====================
function options.update(self)
	
	
						
	
	Icon:SetSize(KillTheHealer.Size, KillTheHealer.Size)
	Icon:SetTexCoord(KillTheHealer.left,KillTheHealer.right,KillTheHealer.top,KillTheHealer.bottom)
			
	
	PathBox:SetText(KillTheHealer.Path)
	
	coords.left:SetText(KillTheHealer.left)
	coords.right:SetText(KillTheHealer.right)
	coords.top:SetText(KillTheHealer.top)
	coords.bottom:SetText(KillTheHealer.bottom)

	
						
	
	
local numkids = WorldFrame:GetNumChildren()
	for i = 1, numkids do
		local frame = select(i, WorldFrame:GetChildren())
		if IsValidFrame(frame) then
			if frame.HPHeal then
				frame.HPHeal:SetTexCoord(KillTheHealer.left,KillTheHealer.right,KillTheHealer.top,KillTheHealer.bottom)
				frame.HPHeal:SetHeight(KillTheHealer.Size)
			  frame.HPHeal:SetWidth(KillTheHealer.Size)
			  frame.HPHeal:SetTexture(KillTheHealer.Path)
		end
		end
	end
	
end

options:SetScript("OnShow", function(self) 
															sizeslide:SetValue(KillTheHealer.Size) 
															options.update()
															end)

--=====================

options.name = "KillTheHealer"
InterfaceOptions_AddCategory(options)


