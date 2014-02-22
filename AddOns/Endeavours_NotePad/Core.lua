
-- Just a nice looking and simplistic NotePad. 

EndeNPad = LibStub("AceAddon-3.0"):NewAddon("EndeNPad", "AceConsole-3.0")
EndeNPad.name = "Endeavour's NotePad" 
local CurrentPage=1

local function Items()
	PlaySoundFile("Sound\\Item\\Weapons\\Ethereal\\Ethereal2H2.wav")
	DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Endeavour's NotePad Item List:|r")
	local temp={}
	for item in string.gmatch(EndeNPad.db.global.pages[CurrentPage], "|c(.-)|r") do
		if not temp[item] then
			DEFAULT_CHAT_FRAME:AddMessage("|c"..item.."|r")
			temp[item]=true
		end
	end
	if temp=={} then DEFAULT_CHAT_FRAME:AddMessage("|cffff0000No items found on current page.|r") end
end

local function SetPage(arg1)
	EndeNPad.editbox:SetText(EndeNPad.db.global.pages[CurrentPage])
	EndeNPad.pagtext:SetText("Page "..CurrentPage)
	if not arg1 then PlaySoundFile("Sound\\Interface\\iAbilitiesTurnPageC.wav") end
end

local function ConfirmDel()
	StaticPopupDialogs["EndeNPad_Confirmation"] = {
		text = "Do you really want to delete the current page?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			if #EndeNPad.db.global.pages < 2 then EndeNPad.db.global.pages[1] = "Endeavour's NotePad\nby Endeavour / Nevermore / Yvaine [EU] Arthas\n\nJust delete this message and enter your notes.\nYou can scroll up and down using the mouse wheel.\n\Insert items just as you would do in the chatframe's editbox.\nThe corners of the main window serve as buttons, see their functionality below.\nPress the \"Escape\" button if you want to save your\nnotes and hide this window.\n\nButtons:\n   * Upper left corner: Post all items on the current page in the chat frame (use this if you want to post items to someone else)\n   * Upper right corner: Create a new page\n   * Lower left corner: Previous page \n   * Lower right corner: Next Page\n   * Bottom Button(Page): Delete current Page" CurrentPage=1 SetPage() StaticPopup_Hide ("EndeNPad_Confirmation") return end
			for i = CurrentPage, #EndeNPad.db.global.pages-1 do
				EndeNPad.db.global.pages[i]=EndeNPad.db.global.pages[i+1]
			end
			EndeNPad.db.global.pages[#EndeNPad.db.global.pages] = nil
			if CurrentPage ~= 1 then 
				CurrentPage=CurrentPage-1
			end
			SetPage()
			PlaySoundFile("Sound\\Interface\\PickUp\\PutDownRocks_Ore01.wav")
			StaticPopup_Hide ("EndeNPad_Confirmation")			
			return
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	}
	StaticPopup_Show("EndeNPad_Confirmation")
end

function EndeNPad:OnInitialize()
	EndeNPad.db = LibStub('AceDB-3.0'):New('EndeNPadDB')
	EndeNPad.db:RegisterDefaults({global = {pages = {[1]="Endeavour's NotePad\nby Endeavour / Nevermore / Yvaine [EU] Arthas\n\nJust delete this message and enter your notes.\nYou can scroll up and down using the mouse wheel.\n\Insert items just as you would do in the chatframe's editbox.\nThe corners of the main window serve as buttons, see their functionality below.\nPress the \"Escape\" button if you want to save your\nnotes and hide this window.\n\nButtons:\n   * Upper left corner: Post all items on the current page in the chat frame (use this if you want to post items to someone else)\n   * Upper right corner: Create a new page\n   * Lower left corner: Previous page \n   * Lower right corner: Next Page\n   * Bottom Button(Page): Delete current Page",},},})
	-- backward compability
	if EndeNPad.db.global.text then
		EndeNPad.db.global.pages[1] = EndeNPad.db.global.text
		EndeNPad.db.global.text = nil
	end
end

local function SetStandard(button)
    button:SetNormalTexture("Interface\\AchievementFrame\\UI-Achievement-WoodBorder-Corner.blp")
    button:SetHighlightTexture("Interface\\AchievementFrame\\UI-Achievement-WoodBorder-Corner.blp")
    button:SetWidth(32)
    button:SetHeight(32)
    button:GetHighlightTexture():SetVertexColor(0.5, 0.5, 0, 1)    
    button:SetScript('OnLeave', function() GameTooltip:Hide(); end)
end		
	
function EndeNPad:OnEnable()

	local t=CreateFrame("Frame","EndeNPadFrame")
	t:Hide()
	t:SetHeight(400)
	t:SetWidth(500)
	t:SetPoint("CENTER")
    t:SetBackdrop({bgFile = "Interface/AchievementFrame/UI-Achievement-StatsBackground", edgeFile = "Interface/AchievementFrame/UI-Achievement-WoodBorder", tile = false, tileSize = 16, edgeSize = 32, insets = { left = 4, right = 4, top = 4, bottom = 4 }})
    t:SetMovable(true)
    t:SetClampedToScreen(true)
    t:SetFrameStrata("DIALOG")
    
    local pag = CreateFrame("Button", "EndeNPadDelButton", t)
    pag:SetNormalTexture("Interface\\AchievementFrame\\UI-Achievement-Category-Background.blp")
    pag:SetHighlightTexture("Interface\\AchievementFrame\\UI-Achievement-Category-Highlight.blp", "ADD")
    pag:SetWidth(130*0.7)
    pag:SetHeight(34*0.7)
    pag:SetPoint('TOP', t, 'BOTTOM', 0, 4)
    pag:GetNormalTexture():SetTexCoord(0,0.6640625,0,1)
    pag:GetHighlightTexture():SetTexCoord(0,0.6640625,0,1)
    pag:SetText("Page "..CurrentPage) 
    pag:SetScript('OnClick', ConfirmDel)
    pag:SetScript('OnEnter', function() 
    	GameTooltip:SetOwner(pag, "ANCHOR_CURSOR")
    	GameTooltip:AddLine("Delete current page")	
    	GameTooltip:Show()
    end)
    pag:SetScript('OnLeave', function() GameTooltip:Hide(); end)
     		
    EndeNPad.pagtext = pag:CreateFontString(nil, 'OVERLAY')		
    EndeNPad.pagtext:SetTextColor(0.8,0.8,0.25,0.9)		
    EndeNPad.pagtext:SetPoint("CENTER", ((EndeNPad.pagtext:GetParent()):GetName()), "CENTER", 0, 2)
    EndeNPad.pagtext:SetWidth(((EndeNPad.pagtext:GetParent()):GetWidth()))
    EndeNPad.pagtext:SetHeight(((EndeNPad.pagtext:GetParent()):GetHeight()))
    EndeNPad.pagtext:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    EndeNPad.pagtext:SetText("Page "..CurrentPage)   
   
    local header = t:CreateTexture(nil, "OVERLAY")
    header:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background.blp")
    header:SetWidth(300*0.7)
    header:SetHeight(88*0.7)
    header:SetPoint('BOTTOM', t, 'TOP', 0, -20)
    header:SetTexCoord(0,0.605,0,0.703)    
    
    local mover = CreateFrame("Frame",nil,t)
    mover:SetAllPoints(header)
    mover:EnableMouse(true)
    mover:RegisterForDrag("LeftButton")
    mover:SetScript("OnDragStart", function()		
    	if(arg1 == "LeftButton") then			
       		t:StartMoving();
       	end
    end)
    mover:SetScript("OnDragStop", function()
    	t:StopMovingOrSizing()
    end) 
       
    local text = t:CreateFontString(nil, 'OVERLAY')		
    text:SetTextColor(1,1,0.3,1)		
    text:SetPoint("BOTTOM", header, 3, 25)
    text:SetFont("Fonts\\MORPHEUS.TTF",14,"OUTLINE")
    text:SetText(EndeNPad.name)    	  
     
    local LeftBorder = t:CreateTexture(nil, "ARTWORK")
    LeftBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalBorder-Left.blp")
    LeftBorder:SetWidth(9)
    LeftBorder:SetHeight(427)
    LeftBorder:SetPoint('TOPLEFT', t, 'TOPLEFT', 7, -11)

    local RightBorder = t:CreateTexture(nil, "ARTWORK")
    RightBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalBorder-Left.blp")
    RightBorder:SetWidth(9)
    RightBorder:SetHeight(427)
    RightBorder:SetPoint('TOPRIGHT', t, 'TOPRIGHT', -3, -11)
    
    local BottomBorder = t:CreateTexture(nil, "ARTWORK")
    BottomBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalBorder-Top.blp")
    BottomBorder:SetWidth(547)
    BottomBorder:SetHeight(9)
    BottomBorder:SetPoint('BOTTOMLEFT', t, 'BOTTOMLEFT', 8, 3)

    local TopBorder = t:CreateTexture(nil, "ARTWORK")
    TopBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalBorder-Top.blp")
    TopBorder:SetWidth(547)
    TopBorder:SetHeight(9)
    TopBorder:SetPoint('TOPLEFT', t, 'TOPLEFT', 8, -6)    
    
    local TopLeftCorner = CreateFrame("Button", nil, t)
    TopLeftCorner:SetPoint('TOPLEFT', t, 'TOPLEFT', 2, -1)
    TopLeftCorner:SetScript('OnClick', function() Items() end)
    TopLeftCorner:SetScript('OnEnter', function() 
    	GameTooltip:SetOwner(TopLeftCorner, "ANCHOR_CURSOR")
    	GameTooltip:AddLine("Show items")	
    	GameTooltip:Show()
    end)
    TopLeftCorner:SetHitRectInsets(0, 15, 0, 15)
    SetStandard(TopLeftCorner)
    
    local TopRightCorner = CreateFrame("Button", nil, t)   
    TopRightCorner:SetPoint('TOPRIGHT', t, 'TOPRIGHT', -2, -1) 
    SetStandard(TopRightCorner)
    TopRightCorner:GetNormalTexture():SetTexCoord(1,0,0,1) 
    TopRightCorner:GetHighlightTexture():SetTexCoord(1,0,0,1)
    local function newP()
     	GameTooltip:SetOwner(TopRightCorner, "ANCHOR_CURSOR")
     	GameTooltip:AddLine("Create new page (Page "..tonumber(#EndeNPad.db.global.pages+1)..")")	
        GameTooltip:Show()
    end 
    TopRightCorner:SetScript('OnClick', function() EndeNPad.db.global.pages[#EndeNPad.db.global.pages+1] ="" CurrentPage=#EndeNPad.db.global.pages SetPage() newP() PlaySoundFile("Sound\\Interface\\SheathWood.wav") EndeNPad:Print("New page created: Page "..CurrentPage) end)
    TopRightCorner:SetScript('OnEnter', newP)
    TopRightCorner:SetHitRectInsets(15, 0, 0, 15)  

    local BottomLeftCorner = CreateFrame("Button", nil, t)
    BottomLeftCorner:SetPoint('BOTTOMLEFT', t, 'BOTTOMLEFT', 2, 2)
	SetStandard(BottomLeftCorner)        
    BottomLeftCorner:GetNormalTexture():SetTexCoord(0,1,1,0)
    BottomLeftCorner:GetHighlightTexture():SetTexCoord(0,1,1,0)
    BottomLeftCorner:SetScript('OnClick', function() CurrentPage=CurrentPage-1 if CurrentPage==0 then CurrentPage=#EndeNPad.db.global.pages end SetPage() end)
    BottomLeftCorner:SetScript('OnEnter', function() 
    	GameTooltip:SetOwner(BottomLeftCorner, "ANCHOR_CURSOR")
    	GameTooltip:AddLine("Previous page")	
    	GameTooltip:Show()
    end)
    BottomLeftCorner:SetHitRectInsets(0, 15, 15, 0)
    
    local BottomRightCorner = CreateFrame("Button", nil, t)
    BottomRightCorner:SetPoint('BOTTOMRIGHT', t, 'BOTTOMRIGHT', -2, 2)
    SetStandard(BottomRightCorner)     
	BottomRightCorner:GetNormalTexture():SetTexCoord(1,0,1,0)
	BottomRightCorner:GetHighlightTexture():SetTexCoord(1,0,1,0)
	BottomRightCorner:SetScript('OnClick', function() CurrentPage=CurrentPage+1 if CurrentPage==#EndeNPad.db.global.pages+1 then CurrentPage=1 end SetPage() end)
	BottomRightCorner:SetScript('OnEnter', function() 
	   	GameTooltip:SetOwner(BottomRightCorner, "ANCHOR_CURSOR")
	   	GameTooltip:AddLine("Next page")	
	  	GameTooltip:Show()
	end)
	BottomRightCorner:SetHitRectInsets(15, 0, 15, 0)    

    local scroll = CreateFrame("ScrollFrame", "EndeNPadScrollFrame", t, "UIPanelScrollFrameTemplate")
	EndeNPad.editbox = CreateFrame("EditBox", "EndeNPadEdit", scroll)
	scroll:SetScrollChild(EndeNPad.editbox)	
	scroll:SetPoint("TOPLEFT", t, "TOPLEFT", 12, -11)
	EndeNPad.editbox:SetFontObject(GameFontNormal)
	EndeNPad.editbox:SetTextColor(1,1,.3)
	scroll:SetWidth(460)  
	scroll:SetHeight(378) 
	EndeNPad.editbox:SetWidth(452)
	scroll:EnableMouse(true)		
	EndeNPad.editbox:SetAutoFocus(true)
	EndeNPad.editbox:SetMultiLine(true)	
	EndeNPad.editbox:SetTextInsets(13, 1, 13, 1)
	EndeNPad.editbox:SetScript('OnEscapePressed', function() EndeNPad.editbox:ClearFocus() t:Hide() end)
	EndeNPad.editbox:SetScript('OnTextChanged', function() EndeNPad.db.global.pages[CurrentPage]=EndeNPad.editbox:GetText() end)
	EndeNPadScrollFrameScrollBar:SetScale(0.7)
	-- Support for Item Links, Player Links and so on
	local savedSetItemRef = SetItemRef
	local savedInsertLink = ChatEdit_InsertLink
	t:SetScript('OnShow', function()
		PlaySoundFile("Sound\\Interface\\AchievementMenuClose.wav") 
		SetPage(true)
		ChatEdit_InsertLink = function(link) 
			if ChatFrameEditBox:IsVisible() then
				ChatFrameEditBox:Insert(link)
			else
				EndeNPad.editbox:Insert(" "..link.." ")
			end 
		end
		SetItemRef = function(link, text, button)
			if IsShiftKeyDown() then 
				if ChatFrameEditBox:IsVisible() then
					if string.find(text,"|Hplayer") ~= nil then return end
					ChatFrameEditBox:Insert(text)
				else
					EndeNPad.editbox:Insert(" "..text.." ")
				end				
			else
				savedSetItemRef(link, text, button)
			end
		end				
	end)
	t:SetScript('OnHide', function() 
		PlaySoundFile("Sound\\Interface\\AchievementMenuOpen.wav")
		SetItemRef = savedSetItemRef 
		ChatEdit_InsertLink = savedInsertLink 
	end)
	EndeNPad:RegisterChatCommand("edit", function() t:Show() end)

end

























