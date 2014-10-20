
local function onClickTester(self)
	if self then
		SGI:print("Click on "..self:GetName());
	end
end

local function CreateButton(name, parent, width, height, label, anchor, onClick)
	local f = CreateFrame("Button", name, parent, "UIPanelButtonTemplate");
	f:SetWidth(width);
	f:SetHeight(height);
	f.label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
	f.label:SetText(label);
	f.label:SetPoint("CENTER");
	f:SetWidth(width - 10);
	
	if (type(anchor) == "table") then
		f:SetPoint(anchor.point,parent,anchor.relativePoint,anchor.xOfs,anchor.yOfs);
	end
	
	f:SetScript("OnClick", onClick);
	return f;
end

local function CreateCheckbox(name, parent, label, anchor)
	local f = CreateFrame("CheckButton", name, parent, "OptionsBaseCheckButtonTemplate");
	f.label = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	f.label:SetText(label);
	f.label:SetPoint("LEFT", f, "RIGHT", 5, 1);
	
	if (type(anchor) == "table") then
		f:SetPoint(anchor.point,parent,anchor.relativePoint,anchor.xOfs,anchor.yOfs);
	end
	
	f:HookScript("OnClick", function(self)
		SGI_DATA[SGI_DATA_INDEX].settings.checkBox[name] = self:GetChecked()
	end)
	if SGI_DATA[SGI_DATA_INDEX].settings.checkBox[name] then
		f:SetChecked()
	end
	return f;
end

local function CreateDropDown(name, parent, label, items, anchor)
	local f = CreateFrame("Button", name, parent, "UIDropDownMenuTemplate");
	f:ClearAllPoints();
	f:SetPoint(anchor.point,parent,anchor.relativePoint,anchor.xOfs,anchor.yOfs)
	f:Show()
	
	f.label = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	f.label:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 20, 5);
	f.label:SetText(label);
	
	local function OnClick(self)
		UIDropDownMenu_SetSelectedID(f, self:GetID());
		SGI_DATA[SGI_DATA_INDEX].settings.dropDown[name] = self:GetID();
	end
	
	local function initialize(self, level)
		local info = UIDropDownMenu_CreateInfo();
		for k,v in pairs(items) do 
			info = UIDropDownMenu_CreateInfo();
			info.text = v;
			info.value = v;
			info.func = OnClick;
			UIDropDownMenu_AddButton(info, level);
		end
	end
	
	UIDropDownMenu_Initialize(f, initialize)
	UIDropDownMenu_SetWidth(f, 100);
	UIDropDownMenu_SetButtonWidth(f, 124)
	SGI_DATA[SGI_DATA_INDEX].settings.dropDown[name] = SGI_DATA[SGI_DATA_INDEX].settings.dropDown[name] or 1
	UIDropDownMenu_SetSelectedID(f, SGI_DATA[SGI_DATA_INDEX].settings.dropDown[name] or 1)
	UIDropDownMenu_JustifyText(f, "LEFT")
	return f
end

local function SetFramePosition(frame)
	if (type(SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()]) ~= "table") then
		if (frame:GetName() == "SGI_MiniMapButton") then
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()] = {point = "CENTER", relativePoint = "CENTER", xOfs = -71, yOfs = -31};
		else
			frame:SetPoint("CENTER");
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()] = {point = "CENTER", relativePoint = "CENTER", xOfs = 0, yOfs = 0};
			return;
		end
	end
	if (frame:GetName() == "SGI_MiniMapButton") then
		frame:SetPoint(
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].point,
			Minimap, 
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].relativePoint,
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].xOfs,
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].yOfs
		);
	else
		frame:SetPoint(
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].point,
			UIParent, 
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].relativePoint,
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].xOfs,
			SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()].yOfs
		);
	end
end

local function SaveFramePosition(frame)
	if (type(SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()]) ~= "table") then
		SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()] = {};
	end
	local point, parent, relativePoint, xOfs, yOfs = frame:GetPoint();
	SGI_DATA[SGI_DATA_INDEX].settings.frames[frame:GetName()] = {point = point, relativePoint = relativePoint, xOfs = xOfs, yOfs = yOfs};
end


local function CreateInviteListFrame()
	CreateFrame("Frame","SGI_Invites")
	local SGI_QUEUE = SGI:GetInviteQueue();
	SGI_Invites:SetWidth(300)
	SGI_Invites:SetHeight(20*SGI:CountTable(SGI_QUEUE) + 40)
	SGI_Invites:SetMovable()
	SetFramePosition(SGI_Invites)
	SGI_Invites:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SGI_Invites:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(SGI_Invites)
	end)
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SGI_Invites:SetBackdrop(backdrop)

	SGI_Invites.text = SGI_Invites:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Invites.text:SetPoint("TOP",SGI_Invites,"TOP",-15,-15)
	SGI_Invites.text:SetText(SGI.L["Click on the players you wish to invite"])
	SGI_Invites.tooltip = CreateFrame("Frame","InviteTime",SGI_Invites,"GameTooltipTemplate")
	SGI_Invites.tooltip.text = SGI_Invites.tooltip:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Invites.tooltip:SetPoint("TOP",SGI_Invites,"BOTTOM",0,-2)
	SGI_Invites.tooltip.text:SetText("Unknown")
	SGI_Invites.tooltip.text:SetPoint("CENTER")
	
	local close = CreateFrame("Button",nil,SGI_Invites,"UIPanelCloseButton")
	close:SetPoint("TOPRIGHT",SGI_Invites,"TOPRIGHT",-4,-4)
	
	SGI_Invites.items = {}
	local update = 0
	local toolUpdate = 0
	SGI_Invites:SetScript("OnUpdate",function()
		if (not SGI_Invites:IsShown() or GetTime() < update) then return end
		
		SGI_QUEUE = SGI:GetInviteQueue();
		
		for k,_ in pairs(SGI_Invites.items) do
			SGI_Invites.items[k]:Hide()
		end
		
		local i = 0
		local x,y = 10,-30
		for i = 1,30 do
			if not SGI_Invites.items[i] then
				SGI_Invites.items[i] = CreateFrame("Button","InviteBar"..i,SGI_Invites)
				SGI_Invites.items[i]:SetWidth(280)
				SGI_Invites.items[i]:SetHeight(20)
				SGI_Invites.items[i]:EnableMouse(true)
				SGI_Invites.items[i]:SetPoint("TOP",SGI_Invites,"TOP",0,y)
				SGI_Invites.items[i].text = SGI_Invites.items[i]:CreateFontString(nil,"OVERLAY","GameFontNormal")
				SGI_Invites.items[i].text:SetPoint("LEFT",SGI_Invites.items[i],"LEFT",3,0)
				SGI_Invites.items[i].text:SetJustifyH("LEFT")
				SGI_Invites.items[i].player = "unknown"
				SGI_Invites.items[i]:RegisterForClicks("LeftButtonDown","RightButtonDown")
				SGI_Invites.items[i]:SetScript("OnClick",SGI.SendGuildInvite)
				
				SGI_Invites.items[i].highlight = SGI_Invites.items[i]:CreateTexture()
				SGI_Invites.items[i].highlight:SetAllPoints()
				SGI_Invites.items[i].highlight:SetTexture(1,1,0,0.2)
				SGI_Invites.items[i].highlight:Hide()
				
				SGI_Invites.items[i]:SetScript("OnEnter",function()
					SGI_Invites.items[i].highlight:Show()
					SGI_Invites.tooltip:Show()
					SGI_Invites.items[i]:SetScript("OnUpdate",function()
						if GetTime() > toolUpdate and SGI_QUEUE[SGI_Invites.items[i].player] then
							SGI_Invites.tooltip.text:SetText("Found |cff"..SGI:GetClassColor(SGI_QUEUE[SGI_Invites.items[i].player].classFile)..SGI_Invites.items[i].player.."|r "..SGI:FormatTime(floor(GetTime()-SGI_QUEUE[SGI_Invites.items[i].player].found)).." ago")
							local h,w = SGI_Invites.tooltip.text:GetHeight(),SGI_Invites.tooltip.text:GetWidth()
							SGI_Invites.tooltip:SetWidth(w+20)
							SGI_Invites.tooltip:SetHeight(h+20)
							toolUpdate = GetTime() + 0.1
						end
					end)
				end)
				SGI_Invites.items[i]:SetScript("OnLeave",function() 
					SGI_Invites.items[i].highlight:Hide()
					SGI_Invites.tooltip:Hide()
					SGI_Invites.items[i]:SetScript("OnUpdate",nil)
				end)
			end
			y = y - 20
		end
		i = 0
		for k,_ in pairs(SGI_QUEUE) do
			i = i + 1
			local level,classFile,race,class,found = SGI_QUEUE[k].level, SGI_QUEUE[k].classFile, SGI_QUEUE[k].race, SGI_QUEUE[k].class, SGI_QUEUE[k].found
			local Text = i..". |cff"..SGI:GetClassColor(classFile)..k.."|r Lvl "..level.." "..race.." |cff"..SGI:GetClassColor(classFile)..class.."|r"
			SGI_Invites.items[i].text:SetText(Text)
			SGI_Invites.items[i].player = k
			SGI_Invites.items[i]:Show()
			if i >= 30 then break end
		end
		SGI_Invites:SetHeight(i * 20 + 40)
		update = GetTime() + 0.5
	end)
end
		

function SGI:ShowInviteList()
	if (not SGI_Invites) then
		CreateInviteListFrame();
	end
	SGI_Invites:Show();
end

function SGI:HideInviteList()
	if (SGI_Invites) then
		SGI_Invites:Hide();
	end
end


local function SSBtn3_OnClick(self)
	if (SGI:IsScanning()) then
		SGI:StopSuperScan();
		self:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
	else
		SGI:StartSuperScan();
		self:SetNormalTexture("Interface\\TimeManager\\PauseButton");
	end
end

function SGI:CreateSmallSuperScanFrame()
	CreateFrame("Frame", "SuperScanFrame");
	SuperScanFrame:SetWidth(130);
	SuperScanFrame:SetHeight(30);
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SetFramePosition(SuperScanFrame)
	SuperScanFrame:SetMovable()
	SuperScanFrame:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SuperScanFrame:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(self)
	end)
	SuperScanFrame:SetBackdrop(backdrop)
	
	local close = CreateFrame("Button",nil,SuperScanFrame,"UIPanelCloseButton")
	close:SetPoint("LEFT",SuperScanFrame,"RIGHT",-5,0)
	
	SuperScanFrame.time = SuperScanFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SuperScanFrame.time:SetPoint("CENTER")
	SuperScanFrame.time:SetText(format("|cff00ff00%d%%|r|cffffff00 %s|r",0,SGI:GetSuperScanETR()))
	
	SuperScanFrame.progressTexture = SuperScanFrame:CreateTexture();
	SuperScanFrame.progressTexture:SetPoint("LEFT", 5, 0);
	SuperScanFrame.progressTexture:SetHeight(18);
	SuperScanFrame.progressTexture:SetWidth(120);
	SuperScanFrame.progressTexture:SetTexture(1,0.5,0,0.4);
	
	local anchor = {
		point = "TOPLEFT",
		relativePoint = "BOTTOMLEFT",
		xOfs = 0,
		yOfs = 0,
	}
	
	SuperScanFrame.button1 = CreateButton("SGI_INVITE_BUTTON2", SuperScanFrame, 70, 30, format("Invite: %d",SGI:GetNumQueued()), anchor, SGI.SendGuildInvite)
		anchor.xOfs = 85;
	SuperScanFrame.button2 = CreateButton("SGI_PURGE_QUEUE", SuperScanFrame, 55, 30, "Purge", anchor, SGI.PurgeQueue);
		anchor.xOfs = 57;
	SuperScanFrame.button2 = CreateButton("SGI_SUPERSCAN_PLAYPAUSE", SuperScanFrame, 40,30,"",anchor,SSBtn3_OnClick);
	SGI_SUPERSCAN_PLAYPAUSE:SetNormalTexture("Interface\\TimeManager\\PauseButton");
	
	SuperScanFrame.nextUpdate = 0;
	SuperScanFrame:SetScript("OnUpdate", function()
		if (SuperScanFrame.nextUpdate < GetTime()) then

			SuperScanFrame.button1.label:SetText(format("Invite: %d",SGI:GetNumQueued()));
			
			if (SGI:IsScanning() and SuperScanFrame.ETR and SuperScanFrame.lastETR) then
				local remainingTime = SuperScanFrame.ETR - (GetTime() - SuperScanFrame.lastETR);
				local totalScanTime = SGI:GetTotalScanTime();
				local percentageDone = (totalScanTime - remainingTime) / totalScanTime;
				SuperScanFrame.time:SetText(format("|cff00ff00%d%%|r|cffffff00 %s|r",100*(percentageDone > 1 and 1 or percentageDone),SGI:FormatTime(remainingTime)))
				SuperScanFrame.progressTexture:SetWidth(120 * (percentageDone > 1 and 1 or percentageDone));
			end
			
			SuperScanFrame.nextUpdate = GetTime() + 0.2;
		end
	end)
	
		
	SuperScanFrame:Hide();
	-- Interface\Buttons\UI-SpellbookIcon-NextPage-Up
	-- Interface\TimeManager\PauseButton
end

function SGI:GetPercentageDone()
	if (SGI:IsScanning() and SuperScanFrame.ETR and SuperScanFrame.lastETR) then
		local remainingTime = SuperScanFrame.ETR - (GetTime() - SuperScanFrame.lastETR);
		local totalScanTime = SGI:GetTotalScanTime();
		local percentageDone = (totalScanTime - remainingTime) / totalScanTime;
		return percentageDone * 100;
	end
	return 0;
end

function SGI:GetSuperScanTimeLeft()
	if (SGI:IsScanning() and SuperScanFrame.ETR and SuperScanFrame.lastETR) then
		return SGI:FormatTime(SuperScanFrame.ETR - (GetTime() - SuperScanFrame.lastETR));
	end
	return 0;
end
	

function SGI:ShowSuperScanFrame()
	if (SuperScanFrame and not (SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_BACKGROUND_MODE"])) then
		SuperScanFrame:Show();
	else
		if (SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_BACKGROUND_MODE"]) then
			SGI:CreateSmallSuperScanFrame();
			SuperScanFrame:Hide();
			return;
		else
			SGI:CreateSmallSuperScanFrame();
			SuperScanFrame:Show();
		end
		
	end
end

function SGI:HideSuperScanFrame()
	if (SuperScanFrame) then
		SuperScanFrame:Hide();
	end
end

local function CreateWhisperDefineFrame()

end




local KeyHarvestFrame = CreateFrame("Frame", "SGI_KeyHarvestFrame");
KeyHarvestFrame:SetPoint("CENTER",0,200);
KeyHarvestFrame:SetWidth(10);
KeyHarvestFrame:SetHeight(10);
KeyHarvestFrame.text = KeyHarvestFrame:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont");
KeyHarvestFrame.text:SetPoint("CENTER");
KeyHarvestFrame.text:SetText("|cff00ff00Press the KEY you wish to bind now!|r");
KeyHarvestFrame:Hide();

function KeyHarvestFrame:GetNewKeybindKey()
	KeyHarvestFrame:Show();
	self:SetScript("OnKeyDown", function(self, key)
		if (SetBindingClick(key, "SGI_INVITE_BUTTON2")) then
			Alerter:SendAlert("|cff00ff00Successfully bound "..key.." to InviteButton!|r",1.5);
			SGI:print("Successfully bound "..key.." to InviteButton!");
			SGI_DATA[SGI_DATA_INDEX].keyBind = key;
			BUTTON_KEYBIND.label:SetText("Set Keybind ("..key..")");
		else
			Alerter:SendAlert("|cffff0000Error binding "..key.." to InviteButton!|r",1.5);
			SGI:print("Error binding "..key.." to InviteButton!");
		end
		self:EnableKeyboard(false);
		KeyHarvestFrame:Hide();
	end)
	self:EnableKeyboard(true);
	
end

local function CreateWhisperDefineFrame()
	CreateFrame("Frame","SGI_Whisper")
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SGI_Whisper:SetWidth(500)
	SGI_Whisper:SetHeight(365)
	SGI_Whisper:SetBackdrop(backdrop)
	SetFramePosition(SGI_Whisper)
	SGI_Whisper:SetMovable()
	SGI_Whisper:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SGI_Whisper:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(SGI_Whisper)
	end)
	
	local close = CreateFrame("Button",nil,SGI_Whisper,"UIPanelCloseButton")
	close:SetPoint("TOPRIGHT",SGI_Whisper,"TOPRIGHT",-4,-4)
	
	SGI_Whisper.title = SGI_Whisper:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Whisper.title:SetText(SGI.L["SuperGuildInvite Custom Whisper"])
	SGI_Whisper.title:SetPoint("TOP",SGI_Whisper,"TOP",0,-20)
	
	SGI_Whisper.info = SGI_Whisper:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Whisper.info:SetPoint("TOPLEFT",SGI_Whisper,"TOPLEFT",33,-55)
	SGI_Whisper.info:SetText(SGI.L["WhisperInstructions"])
	SGI_Whisper.info:SetWidth(450)
	SGI_Whisper.info:SetJustifyH("LEFT")
	
	SGI_Whisper.edit = CreateFrame("EditBox",nil,SGI_Whisper)
	SGI_Whisper.edit:SetWidth(450)
	SGI_Whisper.edit:SetHeight(65)
	SGI_Whisper.edit:SetMultiLine(true)
	SGI_Whisper.edit:SetPoint("TOPLEFT",SGI_Whisper,"TOPLEFT",35,-110)
	SGI_Whisper.edit:SetFontObject("GameFontNormal")
	SGI_Whisper.edit:SetTextInsets(10,10,10,10)
	SGI_Whisper.edit:SetMaxLetters(256)
	SGI_Whisper.edit:SetBackdrop(backdrop)
	SGI_Whisper.edit:SetText(SGI_DATA[SGI_DATA_INDEX].settings.whispers[SGI_DATA[SGI_DATA_INDEX].settings.dropDown["SGI_WHISPER_DROP"] or 1] or "")
	SGI_Whisper.edit:SetScript("OnHide",function()
		SGI_Whisper.edit:SetText(SGI_DATA[SGI_DATA_INDEX].settings.whispers[SGI_DATA[SGI_DATA_INDEX].settings.dropDown["SGI_WHISPER_DROP"] or 1] or "")
	end)
	SGI_Whisper.edit.text = SGI_Whisper.edit:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Whisper.edit.text:SetPoint("TOPLEFT",SGI_Whisper.edit,"TOPLEFT",10,13)
	SGI_Whisper.edit.text:SetText(SGI.L["Enter your whisper"])
	
	local yOfs = -20
	SGI_Whisper.status = {}
	for i = 1,6 do
		SGI_Whisper.status[i] = {}
		SGI_Whisper.status[i].box = CreateFrame("Frame",nil,SGI_Whisper)
		SGI_Whisper.status[i].box:SetWidth(170)
		SGI_Whisper.status[i].box:SetHeight(18)
		SGI_Whisper.status[i].box:SetFrameStrata("HIGH")
		SGI_Whisper.status[i].box.index = i
		SGI_Whisper.status[i].box:SetPoint("LEFT",SGI_Whisper,"CENTER",50,yOfs)
		SGI_Whisper.status[i].box:SetScript("OnEnter",function(self)
			if SGI_DATA[SGI_DATA_INDEX].settings.whispers[self.index] then
				GameTooltip:SetOwner(self,"ANCHOR_CURSOR")
				GameTooltip:SetText(SGI:FormatWhisper(SGI_DATA[SGI_DATA_INDEX].settings.whispers[self.index],UnitName("Player")))
			end
		end)
		SGI_Whisper.status[i].box:SetScript("OnLeave",function(self)
			GameTooltip:Hide()
		end)
		SGI_Whisper.status[i].text = SGI_Whisper:CreateFontString(nil,nil,"GameFontNormal")
		SGI_Whisper.status[i].text:SetText("Whisper #"..i.." status: ")
		SGI_Whisper.status[i].text:SetWidth(200)
		SGI_Whisper.status[i].text:SetJustifyH("LEFT")
		SGI_Whisper.status[i].text:SetPoint("LEFT",SGI_Whisper,"CENTER",50,yOfs)
		yOfs = yOfs - 18
	end
	local whispers = {
		"Whisper #1",
		"Whisper #2",
		"Whisper #3",
		"Whisper #4",
		"Whisper #5",
		"Whisper #6",
	}
	
	anchor = {}
		anchor.point = "BOTTOMLEFT"
		anchor.relativePoint = "BOTTOMLEFT"
		anchor.xOfs = 50
		anchor.yOfs = 120
		
	--CreateDropDown(name, parent, label, items, anchor)
	SGI_Whisper.drop = CreateDropDown("SGI_WHISPER_DROP",SGI_Whisper,SGI.L["Select whisper"],whispers,anchor)

		anchor.xOfs = 100
		anchor.yOfs = 20
	--CreateButton(name, parent, width, height, label, anchor, onClick)
	CreateButton("SGI_SAVEWHISPER",SGI_Whisper,120,30,SGI.L["Save"],anchor,function()
		local text = SGI_Whisper.edit:GetText()
		local ID = SGI_DATA[SGI_DATA_INDEX].settings.dropDown["SGI_WHISPER_DROP"]
		SGI_DATA[SGI_DATA_INDEX].settings.whispers[ID] = text
		SGI_Whisper.edit:SetText("")
	end)
	anchor.xOfs = 280
	CreateButton("SGI_CANCELWHISPER",SGI_Whisper,120,30,SGI.L["Cancel"],anchor,function()
		SGI_Whisper:Hide()
	end)
	
	SGI_Whisper.update = 0
	SGI_Whisper.changed = false
	SGI_Whisper:SetScript("OnUpdate",function()
		if GetTime() > SGI_Whisper.update then
			for i = 1,6 do
				if type(SGI_DATA[SGI_DATA_INDEX].settings.whispers[i]) == "string" then
					SGI_Whisper.status[i].text:SetText("Whisper #"..i.." status: |cff00ff00Good|r")
				else
					SGI_Whisper.status[i].text:SetText("Whisper #"..i.." status: |cffff0000Undefined|r")
				end
			end
			local ID = SGI_DATA[SGI_DATA_INDEX].settings.dropDown["SGI_WHISPER_DROP"]
			SGI_Whisper.status[ID].text:SetText("Whisper #"..ID.." status: |cffff8800Editing...|r")
			
			if ID ~= SGI_Whisper.changed then
				SGI_Whisper.changed = ID
				SGI_Whisper.edit:SetText(SGI_DATA[SGI_DATA_INDEX].settings.whispers[SGI_DATA[SGI_DATA_INDEX].settings.dropDown["SGI_WHISPER_DROP"] or 1] or "")
			end
			
			SGI_Whisper.update = GetTime() + 0.5
		end
	end)
	
	SGI_Whisper:HookScript("OnHide", function() if (SGI_Options.showAgain) then SGI:ShowOptions() SGI_Options.showAgain = false end end)
end

local function ShowWhisperFrame()
	if SGI_Whisper then
		SGI_Whisper:Show()
	else
		CreateWhisperDefineFrame()
		SGI_Whisper:Show()
	end
end

local function HideWhisperFrame()
	if SGI_Whisper then
		SGI_Whisper:Hide()
	end
end

local function CreateFilterFrame()
	CreateFrame("Frame","SGI_Filters")
	SGI_Filters:SetWidth(550)
	SGI_Filters:SetHeight(380)
	SetFramePosition(SGI_Filters)
	SGI_Filters:SetMovable()
	SGI_Filters:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SGI_Filters:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(SGI_Filters)
	end)
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SGI_Filters:SetBackdrop(backdrop)
	local close = CreateFrame("Button",nil,SGI_Filters,"UIPanelCloseButton")
	close:SetPoint("TOPRIGHT",SGI_Filters,"TOPRIGHT",-4,-4)
	
	SGI_Filters.title = SGI_Filters:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	SGI_Filters.title:SetPoint("TOP", SGI_Filters, "TOP", 0, -15);
	SGI_Filters.title:SetText("Edit filters");
	SGI_Filters.underTitle = SGI_Filters:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.underTitle:SetPoint("TOP", SGI_Filters, "TOP", 0, -38);
	SGI_Filters.underTitle:SetText("|cffff3300Any textbox left empty, except \"Filter name\" will be excluded from the filter|r");
	SGI_Filters.underTitle:SetWidth(400);
	SGI_Filters.bottomText = SGI_Filters:CreateFontString(nil, "OVERLAY", "GameFOntNormal");
	SGI_Filters.bottomText:SetPoint("BOTTOM", SGI_Filters, "BOTTOM", 0, 60);
	SGI_Filters.bottomText:SetText("|cff00ff00In order to be filtered, a player has to match |r|cffFF3300ALL|r |cff00ff00criterias|r");
	
	SGI_Filters.tooltip = CreateFrame("Frame", "FilterTooltip", SGI_Filters.tooltip, "GameTooltipTemplate");
	SGI_Filters.tooltip:SetWidth(150);
	SGI_Filters.tooltip.text = SGI_Filters.tooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.tooltip.text:SetPoint("CENTER", SGI_Filters.tooltip, "CENTER", 0, 0);
	SGI_Filters.tooltip.text:SetJustifyH("LEFT");
	
	SGI_Filters.editBoxName = CreateFrame("EditBox", "SGI_EditBoxName", SGI_Filters);
	SGI_Filters.editBoxName:SetWidth(150);
	SGI_Filters.editBoxName:SetHeight(30);
	SGI_Filters.editBoxName:SetPoint("TOPRIGHT", SGI_Filters, "TOPRIGHT", -40, -90);
	SGI_Filters.editBoxName:SetFontObject("GameFontNormal");
	SGI_Filters.editBoxName:SetMaxLetters(65);
	SGI_Filters.editBoxName:SetBackdrop(backdrop);
	SGI_Filters.editBoxName:SetText("");
	SGI_Filters.editBoxName:SetTextInsets(10,10,10,10);
	SGI_Filters.editBoxName:SetScript("OnHide",function(self)
		self:SetText("");
	end)
	SGI_Filters.editBoxName.title = SGI_Filters.editBoxName:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.editBoxName.title:SetPoint("BOTTOMLEFT", SGI_Filters.editBoxName,"TOPLEFT", 0, 5);
	SGI_Filters.editBoxName.title:SetText("Filter name");
	
	SGI_Filters.editBoxNameFilter = CreateFrame("EditBox", "SGI_EditBoxNameFilter", SGI_Filters);
	SGI_Filters.editBoxNameFilter:SetWidth(150);
	SGI_Filters.editBoxNameFilter:SetHeight(30);
	SGI_Filters.editBoxNameFilter:SetPoint("TOPRIGHT", SGI_Filters, "TOPRIGHT", -40, -150);
	SGI_Filters.editBoxNameFilter:SetFontObject("GameFontNormal");
	SGI_Filters.editBoxNameFilter:SetMaxLetters(65);
	SGI_Filters.editBoxNameFilter:SetBackdrop(backdrop);
	SGI_Filters.editBoxNameFilter:SetText("");
	SGI_Filters.editBoxNameFilter:SetTextInsets(10,10,10,10);
	SGI_Filters.editBoxNameFilter:SetScript("OnHide",function(self)
		self:SetText("");
	end)
	SGI_Filters.editBoxNameFilter:SetScript("OnEnter", function(self)
		SGI_Filters.tooltip.text:SetText(SGI.L["Enter a phrase which you wish to include in the filter. If a player's name contains the phrase, they will not be queued"]);
		SGI_Filters.tooltip.text:SetWidth(135);
		SGI_Filters.tooltip:SetHeight(SGI_Filters.tooltip.text:GetHeight() + 12);
		SGI_Filters.tooltip:SetPoint("TOP", self, "BOTTOM", 0, -5);
		SGI_Filters.tooltip:Show();
	end)
	SGI_Filters.editBoxNameFilter:SetScript("OnLeave", function()
		SGI_Filters.tooltip:Hide()
	end)
	
	SGI_Filters.editBoxNameFilter.title = SGI_Filters.editBoxNameFilter:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.editBoxNameFilter.title:SetPoint("BOTTOMLEFT", SGI_Filters.editBoxNameFilter,"TOPLEFT", 0, 5);
	SGI_Filters.editBoxNameFilter.title:SetText("Name exceptions");
	
	SGI_Filters.editBoxLvl = CreateFrame("EditBox", "SGI_EditBoxLvl", SGI_Filters);
	SGI_Filters.editBoxLvl:SetWidth(150);
	SGI_Filters.editBoxLvl:SetHeight(30);
	SGI_Filters.editBoxLvl:SetPoint("TOPRIGHT", SGI_Filters, "TOPRIGHT", -40, -210);
	SGI_Filters.editBoxLvl:SetFontObject("GameFontNormal");
	SGI_Filters.editBoxLvl:SetMaxLetters(65);
	SGI_Filters.editBoxLvl:SetBackdrop(backdrop);
	SGI_Filters.editBoxLvl:SetText("");
	SGI_Filters.editBoxLvl:SetTextInsets(10,10,10,10);
	SGI_Filters.editBoxLvl:SetScript("OnHide",function(self)
		self:SetText("");
	end)
	SGI_Filters.editBoxLvl:SetScript("OnEnter", function(self)
		SGI_Filters.tooltip.text:SetText(SGI.L["Enter the level range for the filter. \n\nExample: |cff00ff0055|r:|cff00A2FF58|r \n\nThis would result in only matching players that range from level |cff00ff0055|r to |cff00A2FF58|r (inclusive)"]);
		SGI_Filters.tooltip.text:SetWidth(135);
		SGI_Filters.tooltip:SetHeight(SGI_Filters.tooltip.text:GetHeight() + 12);
		SGI_Filters.tooltip:SetPoint("TOP", self, "BOTTOM", 0, -5);
		SGI_Filters.tooltip:Show();
	end)
	SGI_Filters.editBoxLvl:SetScript("OnLeave", function()
		SGI_Filters.tooltip:Hide()
	end)
	
	SGI_Filters.editBoxLvl.title = SGI_Filters.editBoxLvl:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.editBoxLvl.title:SetPoint("BOTTOMLEFT", SGI_Filters.editBoxLvl,"TOPLEFT", 0, 5);
	SGI_Filters.editBoxLvl.title:SetText("Level range (Min:Max)");
	
	SGI_Filters.editBoxVC = CreateFrame("EditBox", "SGI_EditBoxVC", SGI_Filters);
	SGI_Filters.editBoxVC:SetWidth(150);
	SGI_Filters.editBoxVC:SetHeight(30);
	SGI_Filters.editBoxVC:SetPoint("TOPRIGHT", SGI_Filters, "TOPRIGHT", -40, -270);
	SGI_Filters.editBoxVC:SetFontObject("GameFontNormal");
	SGI_Filters.editBoxVC:SetMaxLetters(65);
	SGI_Filters.editBoxVC:SetBackdrop(backdrop);
	SGI_Filters.editBoxVC:SetText("");
	SGI_Filters.editBoxVC:SetTextInsets(10,10,10,10);
	SGI_Filters.editBoxVC:SetScript("OnHide",function(self)
		self:SetText("");
	end)
	
	SGI_Filters.editBoxVC:SetScript("OnEnter", function(self)
		SGI_Filters.tooltip.text:SetText(SGI.L["Enter the maximum amount of consecutive vowels and consonants a player's name can contain.\n\nExample: |cff00ff003|r:|cff00A2FF5|r\n\nThis would cause players with more than |cff00ff003|r vowels in a row or more than |cff00A2FF5|r consonants in a row not to be queued."]);
		SGI_Filters.tooltip.text:SetWidth(135);
		SGI_Filters.tooltip:SetHeight(SGI_Filters.tooltip.text:GetHeight() + 12);
		SGI_Filters.tooltip:SetPoint("TOP", self, "BOTTOM", 0, -5);
		SGI_Filters.tooltip:Show();
	end)
	SGI_Filters.editBoxVC:SetScript("OnLeave", function()
		SGI_Filters.tooltip:Hide()
	end)
	
	SGI_Filters.editBoxVC.title = SGI_Filters.editBoxVC:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.editBoxVC.title:SetPoint("BOTTOMLEFT", SGI_Filters.editBoxVC,"TOPLEFT", 0, 5);
	SGI_Filters.editBoxVC.title:SetText("Max Vowels/Cons (V:C)");
	
	SGI_EditBoxName:SetScript("OnEnterPressed", function()
		SGI_EditBoxNameFilter:SetFocus();
	end);
	SGI_EditBoxNameFilter:SetScript("OnEnterPressed", function()
		SGI_EditBoxLvl:SetFocus();
	end);
	SGI_EditBoxLvl:SetScript("OnEnterPressed", function()
		SGI_EditBoxVC:SetFocus();
	end);
	SGI_EditBoxVC:SetScript("OnEnterPressed", function()
		SGI_EditBoxName:SetFocus();
	end);
	SGI_EditBoxName:SetScript("OnTabPressed", function()
		SGI_EditBoxNameFilter:SetFocus();
	end);
	SGI_EditBoxNameFilter:SetScript("OnTabPressed", function()
		SGI_EditBoxLvl:SetFocus();
	end);
	SGI_EditBoxLvl:SetScript("OnTabPressed", function()
		SGI_EditBoxVC:SetFocus();
	end);
	SGI_EditBoxVC:SetScript("OnTabPressed", function()
		SGI_EditBoxName:SetFocus();
	end);
	
	local CLASS = {
			[SGI.L["Death Knight"]] = "DEATHKNIGHT",
			[SGI.L["Druid"]] = "DRUID",
			[SGI.L["Hunter"]] = "HUNTER",
			[SGI.L["Mage"]] = "MAGE",
			[SGI.L["Monk"]] = "MONK",
			[SGI.L["Paladin"]] = "PALADIN",
			[SGI.L["Priest"]] = "PRIEST",
			[SGI.L["Rogue"]] = "ROGUE",
			[SGI.L["Shaman"]] = "SHAMAN",
			[SGI.L["Warlock"]] = "WARLOCK",
			[SGI.L["Warrior"]] = "WARRIOR"
	}
	local Classes = {
			SGI.L["Ignore"],
			SGI.L["Death Knight"],
			SGI.L["Druid"],
			SGI.L["Hunter"],
			SGI.L["Mage"],
			SGI.L["Monk"],
			SGI.L["Paladin"],
			SGI.L["Priest"],
			SGI.L["Rogue"],
			SGI.L["Shaman"],
			SGI.L["Warlock"],
			SGI.L["Warrior"],
	}
	local Races = {}
	if UnitFactionGroup("player") == "Horde" then
		Races = {
			SGI.L["Ignore"],
			SGI.L["Orc"],
			SGI.L["Blood Elf"],
			SGI.L["Undead"],
			SGI.L["Troll"],
			SGI.L["Goblin"],
			SGI.L["Tauren"],
			SGI.L["Pandaren"],
		}
	else
		Races = {
			SGI.L["Ignore"],
			SGI.L["Human"],
			SGI.L["Dwarf"],
			SGI.L["Worgen"],
			SGI.L["Draenei"],
			SGI.L["Night Elf"],
			SGI.L["Gnome"],
			SGI.L["Pandaren"],
		}
	end
	
	SGI_Filters.classText = SGI_Filters:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_Filters.raceText = SGI_Filters:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	
	SGI_Filters.classCheckBoxes = {};
	local anchor = {
		point = "TOPLEFT",
		relativePoint = "TOPLEFT",
		xOfs = 40,
		yOfs = -90,
	}
	for k,_ in pairs(Classes) do
		SGI_Filters.classCheckBoxes[k] = CreateCheckbox("CHECKBOX_FILTERS_CLASS_"..Classes[k], SGI_Filters, Classes[k], anchor)
		
		anchor.yOfs = anchor.yOfs - 18;
	end
	SGI_Filters.classText:SetPoint("BOTTOM", SGI_Filters.classCheckBoxes[1], "TOP", -5, 3);
	SGI_Filters.classText:SetText(SGI.L["Classes:"]);
	
	if (SGI_Filters.classCheckBoxes[1]:GetChecked()) then
		for i = 2,12 do
			SGI_Filters.classCheckBoxes[i]:Hide();
		end
	else
		for i = 2,12 do
			SGI_Filters.classCheckBoxes[i]:Show();
		end
	end
	
	SGI_Filters.classCheckBoxes[1]:HookScript("PostClick", function()
		if (SGI_Filters.classCheckBoxes[1]:GetChecked()) then
			for i = 2,12 do
				SGI_Filters.classCheckBoxes[i]:Hide();
			end
		else
			for i = 2,12 do
				SGI_Filters.classCheckBoxes[i]:Show();
			end
		end
	end)
	
	
	SGI_Filters.raceCheckBoxes = {};
	anchor = {
		point = "TOPLEFT",
		relativePoint = "TOPLEFT",
		xOfs = 160,
		yOfs = -90,
	}
	for k,_ in pairs(Races) do
		SGI_Filters.raceCheckBoxes[k] = CreateCheckbox("CHECKBOX_FILTERS_RACE_"..Races[k], SGI_Filters, Races[k], anchor)
		anchor.yOfs = anchor.yOfs - 18;
	end
		
	SGI_Filters.raceText:SetPoint("BOTTOM", SGI_Filters.raceCheckBoxes[1], "TOP", -5, 3);
	SGI_Filters.raceText:SetText(SGI.L["Races:"]);
	
	if (SGI_Filters.raceCheckBoxes[1]:GetChecked()) then
		for i = 2,8 do
			SGI_Filters.raceCheckBoxes[i]:Hide();
		end
	else
		for i = 2,8 do
			SGI_Filters.raceCheckBoxes[i]:Show();
		end
	end
	
	SGI_Filters.raceCheckBoxes[1]:HookScript("PostClick", function()
		if (SGI_Filters.raceCheckBoxes[1]:GetChecked()) then
			for i = 2,8 do
				SGI_Filters.raceCheckBoxes[i]:Hide();
			end
		else
			for i = 2,8 do
				SGI_Filters.raceCheckBoxes[i]:Show();
			end
		end
	end)
	
		
	local function GetFilterData()
		local FilterName = SGI_EditBoxName:GetText();
		SGI_EditBoxName:SetText("");
		if (not FilterName or strlen(FilterName) < 1) then
			return;
		end
		SGI:debug("Filter name: "..FilterName);
		local V,C = SGI_EditBoxVC:GetText();
		if (V and strlen(V) > 1) then
			V,C = strsplit(":", V);
			V = tonumber(V);
			C = tonumber(C);
			if (V == "") then V = nil end
			if (C == "") then C = nil end
			SGI:debug("Max Vowels: "..(V or "N/A")..", Max Consonants: "..(C or "N/A"));
		end
		SGI_EditBoxVC:SetText("");
		local Min,Max = SGI_EditBoxLvl:GetText();
		if (Min and strlen(Min) > 1) then
			Min, Max = strsplit(":",Min);
			Min = tonumber(Min);
			Max = tonumber(Max);
			SGI:debug("Level range: "..Min.." - "..Max);
		end
		SGI_EditBoxLvl:SetText("");
		
		local ExceptionName = SGI_EditBoxNameFilter:GetText()
		if (ExceptionName == "") then
			ExceptionName = nil;
		end
		SGI_EditBoxNameFilter:SetText("");
		
		
		
		local classes = {};
		if (not SGI_Filters.classCheckBoxes[1]:GetChecked()) then
			for k,_ in pairs(SGI_Filters.classCheckBoxes) do
				if (SGI_Filters.classCheckBoxes[k]:GetChecked()) then
					classes[CLASS[SGI_Filters.classCheckBoxes[k].label:GetText()]] = true;
					SGI:debug(CLASS[SGI_Filters.classCheckBoxes[k].label:GetText()]);
					SGI_Filters.classCheckBoxes[k]:SetChecked(false);
				end
			end
		end
		
		local races = {}
		if (not SGI_Filters.raceCheckBoxes[1]:GetChecked()) then
			for k,_ in pairs(SGI_Filters.raceCheckBoxes) do
				if (SGI_Filters.raceCheckBoxes[k]:GetChecked()) then
					races[SGI_Filters.raceCheckBoxes[k].label:GetText()] = true;
					SGI:debug(SGI_Filters.raceCheckBoxes[k].label:GetText());
					SGI_Filters.raceCheckBoxes[k]:SetChecked(false);
				end
			end
		end
		SGI:CreateFilter(FilterName,classes,ExceptionName,Min,Max,races,V,C);
		SGI_FilterHandle.needRedraw = true;
		return true;
	end
	
	anchor = {
		point = "BOTTOM",
		relativePoint = "BOTTOM",
		xOfs = -60,
		yOfs = 20,
	}
	
	
	SGI_Filters.button1 = CreateButton("BUTTON_SAVE_FILTER", SGI_Filters, 120, 30, SGI.L["Save"], anchor, GetFilterData);
		anchor.xOfs = 60;
	SGI_Filters.button2 = CreateButton("BUTTON_CANCEL_FILTER", SGI_Filters, 120, 30, SGI.L["Back"], anchor, function() SGI_Filters:Hide() end);
	
	SGI_Filters:HookScript("OnHide", function() SGI:ShowFilterHandle() SGI_FilterHandle.showOpt = true end);
	
end

local function ShowFilterFrame()
	if (not SGI_Filters) then
		CreateFilterFrame();
	end
	SGI_Filters:Show();
end


local function CreateFilterHandleFrame()
	CreateFrame("Frame","SGI_FilterHandle")
	SGI_FilterHandle:SetWidth(450)
	SGI_FilterHandle:SetHeight(350)
	SetFramePosition(SGI_FilterHandle)
	SGI_FilterHandle:SetMovable()
	SGI_FilterHandle:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SGI_FilterHandle:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(SGI_FilterHandle)
	end)
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SGI_FilterHandle:SetBackdrop(backdrop)
	local close = CreateFrame("Button",nil,SGI_FilterHandle,"UIPanelCloseButton")
	close:SetPoint("TOPRIGHT",SGI_FilterHandle,"TOPRIGHT",-4,-4)
	
	SGI_FilterHandle.title = SGI_FilterHandle:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_FilterHandle.title:SetText("Filters")
	SGI_FilterHandle.title:SetPoint("TOP",SGI_FilterHandle,"TOP",0,-15)
	SGI_FilterHandle.underTitle = SGI_FilterHandle:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_FilterHandle.underTitle:SetText("Click to toggle");
	SGI_FilterHandle.underTitle:SetPoint("TOP", SGI_FilterHandle, "TOP", 0, -35);
	
	local anchor = {}
			anchor.point = "BOTTOM"
			anchor.relativePoint = "BOTTOM"
			anchor.xOfs = -60
			anchor.yOfs = 30
	
	SGI_FilterHandle.button1 = CreateButton("BUTTON_EDIT_FILTERS", SGI_FilterHandle, 120, 30, SGI.L["Add filters"], anchor, function() ShowFilterFrame() SGI_FilterHandle.showOpt = false SGI_FilterHandle.showSelf = true SGI_FilterHandle:Hide() end);
		anchor.xOfs = 60
	SGI_FilterHandle.button2 = CreateButton("BUTTON_EDIT_FILTERS", SGI_FilterHandle, 120, 30, SGI.L["Back"], anchor, function() close:Click() end);
	
	
	SGI_FilterHandle.tooltip = CreateFrame("Frame", "SGI_HandleTooltip", SGI_FilterHandle, "GameTooltipTemplate");
	SGI_FilterHandle.tooltip:SetWidth(150);
	SGI_FilterHandle.tooltip.text = SGI_FilterHandle.tooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	SGI_FilterHandle.tooltip.text:SetPoint("CENTER", SGI_FilterHandle.tooltip, "CENTER", 0, 0);
	SGI_FilterHandle.tooltip.text:SetJustifyH("LEFT");
	
	local function FormatTooltipFilterText(filter)
		local text = "Filter name: "..filter.nameOfFilter.."\n";
		
		if (filter.active) then
			text = text.."|cff00ff00[ACTIVE]|r\n";
		else
			text = text.."|cffff0000[INACTIVE]|r\n";
		end
		
		if (filter.class) then
			for k,v in pairs(filter.class) do
				text = text.."|cff"..(SGI:GetClassColor(k)..k).."|r\n";
			end
		end
		
		if (filter.race) then
			for k,v in pairs(filter.race) do
				text = text.."|cff16ABB5"..k.."|r\n";
			end
		end
		
		if (filter.minLvl and filter.minLvl ~= "") then
			text = text.."|cff00ff00"..filter.minLvl.."|r - ";
			if (filter.maxLvl) then
				text = text.."|cffff0000"..filter.maxLvl.."|r\n";
			else
				text = text.."\n";
			end
		end
		
		if (filter.maxVowels and filter.maxVowels ~= "") then
			text = text.."Vowels: |cff16ABB5"..filter.maxVowels.."|r\n";
		end
		
		if (filter.maxConsonants and filter.maxVowels ~= "") then
			text = text.."Consonants: |cff16ABB5"..filter.maxConsonants.."|r\n";
		end
		
		if (filter.name and filter.name ~= "") then
			text = text.."Name exception: |cff16ABB5"..filter.name.."|r";
		end
		
		return text;
	end
	
	SGI_FilterHandle.filterFrames = {}
	SGI_FilterHandle.update = 0;
	SGI_FilterHandle.needRedraw = false;
	SGI_FilterHandle:SetScript("OnUpdate", function(self)
		if (SGI_FilterHandle.update < GetTime()) then
			
			local anchor = {}
				anchor.xOfs = -175
				anchor.yOfs = 110
			
			local F = SGI_DATA[SGI_DATA_INDEX].settings.filters;
			
			if (SGI_FilterHandle.needRedraw) then
				for k,_ in pairs(SGI_FilterHandle.filterFrames) do
					SGI_FilterHandle.filterFrames[k]:Hide();
				end
				SGI_FilterHandle.filterFrames = {};
				SGI_FilterHandle.needRedraw = false;
			end
			
			for k,_ in pairs(F) do
				if (not SGI_FilterHandle.filterFrames[k]) then
					SGI_FilterHandle.filterFrames[k] = CreateFrame("Button", "FilterFrame"..k, SGI_FilterHandle);
					SGI_FilterHandle.filterFrames[k]:SetWidth(80)
					SGI_FilterHandle.filterFrames[k]:SetHeight(25);
					SGI_FilterHandle.filterFrames[k]:EnableMouse(true);
					SGI_FilterHandle.filterFrames[k]:SetPoint("CENTER", SGI_FilterHandle, "CENTER", anchor.xOfs, anchor.yOfs);
					if mod(k,5) == 0 then
						anchor.xOfs = -175
						anchor.yOfs = anchor.yOfs - 30
					else
						anchor.xOfs = anchor.xOfs + 85
					end
					SGI_FilterHandle.filterFrames[k].text = SGI_FilterHandle.filterFrames[k]:CreateFontString(nil, "OVERLAY", "GameFontNormal");
					SGI_FilterHandle.filterFrames[k].text:SetPoint("LEFT", SGI_FilterHandle.filterFrames[k], "LEFT", 3, 0);
					SGI_FilterHandle.filterFrames[k].text:SetJustifyH("LEFT");
					SGI_FilterHandle.filterFrames[k].text:SetWidth(75);
					SGI_FilterHandle.filterFrames[k]:EnableMouse(true);
					SGI_FilterHandle.filterFrames[k]:RegisterForClicks("LeftButtonDown","RightButtonDown");
					SGI_FilterHandle.filterFrames[k].highlight = SGI_FilterHandle.filterFrames[k]:CreateTexture();
					SGI_FilterHandle.filterFrames[k].highlight:SetAllPoints();
					if (SGI_DATA[SGI_DATA_INDEX].settings.filters[k].active) then
						SGI_FilterHandle.filterFrames[k].highlight:SetTexture(0,1,0,0.2);
					else
						SGI_FilterHandle.filterFrames[k].highlight:SetTexture(1,0,0,0.2);
					end
					SGI_FilterHandle.filterFrames[k]:SetScript("OnEnter", function(self)
						self.highlight:SetTexture(1,1,0,0.2);
						SGI:debug("Enter: YELLOW");
						 
						SGI_FilterHandle.tooltip.text:SetText(FormatTooltipFilterText(F[k]));
						SGI_FilterHandle.tooltip:SetPoint("TOP", self, "BOTTOM", 0, -3);
						SGI_FilterHandle.tooltip:SetHeight(SGI_FilterHandle.tooltip.text:GetHeight() + 12);
						SGI_FilterHandle.tooltip:SetWidth(SGI_FilterHandle.tooltip.text:GetWidth() + 10);
						SGI_FilterHandle.tooltip:Show();
					end)
					SGI_FilterHandle.filterFrames[k]:SetScript("OnLeave", function(self)
						if (F[k] and F[k].active) then--SGI_FilterHandle.filterFrames[k].state) then
							SGI_FilterHandle.filterFrames[k].highlight:SetTexture(0,1,0,0.2);
							SGI:debug("Leave: GREEN");
							
						else
							SGI_FilterHandle.filterFrames[k].highlight:SetTexture(1,0,0,0.2);
							SGI:debug("Leave: RED");
						end
						
						SGI_FilterHandle.tooltip:Hide();
					end)
				end
				
				SGI_FilterHandle.filterFrames[k].filter = F[k];
				SGI_FilterHandle.filterFrames[k].text:SetText(F[k].nameOfFilter);
				SGI_FilterHandle.filterFrames[k]:Show();
				
				SGI_FilterHandle.filterFrames[k]:SetScript("OnClick", function(self, button)
					SGI:debug(button);
					if (button == "LeftButton") then
						if (SGI_DATA[SGI_DATA_INDEX].settings.filters[k].active) then
							SGI_DATA[SGI_DATA_INDEX].settings.filters[k].active = nil;
							SGI_FilterHandle.filterFrames[k].highlight:SetTexture(1,0,0,0.2);
							SGI:debug("Click: RED");
						else
							SGI_DATA[SGI_DATA_INDEX].settings.filters[k].active = true;
							SGI_FilterHandle.filterFrames[k].highlight:SetTexture(0,1,0,0.2);
							SGI:debug("Click: GREEN");
						end
						
						SGI_FilterHandle.tooltip.text:SetText(FormatTooltipFilterText(F[k]));
						SGI_FilterHandle.tooltip:SetPoint("TOP", self, "BOTTOM", 0, -3);
						SGI_FilterHandle.tooltip:SetHeight(SGI_FilterHandle.tooltip.text:GetHeight() + 12);
						SGI_FilterHandle.tooltip:SetWidth(SGI_FilterHandle.tooltip.text:GetWidth() + 10);
						SGI_FilterHandle.tooltip:Show();
					else
						SGI_DATA[SGI_DATA_INDEX].settings.filters[k] = nil;
						SGI_FilterHandle.needRedraw = true;
					end
					
				end)
				
			end
			
			SGI_FilterHandle.update = GetTime() + 1;
		end
	end)
	SGI_FilterHandle.showOpt = true;
	SGI_FilterHandle:HookScript("OnHide", function() if SGI_FilterHandle.showOpt then SGI:ShowOptions() end end)
end

function SGI:ShowFilterHandle()
	if (not SGI_FilterHandle) then
		CreateFilterHandleFrame();
	end
	SGI_FilterHandle:Show()
end

local function ChangeLog()
	CreateFrame("Frame","SGI_ChangeLog")
	SGI_ChangeLog:SetWidth(550)
	SGI_ChangeLog:SetHeight(350)
	SGI_ChangeLog:SetBackdrop(
	{
		bgFile = "Interface/ACHIEVEMENTFRAME/UI-Achievement-Parchment-Horizontal", 
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
		tile = false,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	)
	SetFramePosition(SGI_ChangeLog)
	
	local anchor = {}
			anchor.point = "BOTTOMRIGHT"
			anchor.relativePoint = "BOTTOMRIGHT"
			anchor.xOfs = -210
			anchor.yOfs = 10
	
	SGI_ChangeLog.check1 = CreateCheckbox("SGI_CHANGES",SGI_ChangeLog,SGI.L["Don't show this after new updates"],anchor)
		anchor.xOfs = -300
	SGI_ChangeLog.button1 = CreateButton("SGI_CLOSE_CHANGES",SGI_ChangeLog,120,30,SGI.L["Close"],anchor,function() SGI_ChangeLog:Hide() SGI_DATA.showChanges = SGI.VERSION_MAJOR end)
	
	SGI_ChangeLog.title = SGI_ChangeLog:CreateFontString()
	SGI_ChangeLog.title:SetFont("Fonts\\FRIZQT__.TTF",22,"OUTLINE")
	SGI_ChangeLog.title:SetText("|cffffff00<|r|cff16ABB5SuperGuildInvite|r|cff00ff00 Recent Changes|r|cffffff00>|r|cffffff00")
	SGI_ChangeLog.title:SetPoint("TOP",SGI_ChangeLog,"TOP",0,-12)
	
	SGI_ChangeLog.version = SGI_ChangeLog:CreateFontString()
	SGI_ChangeLog.version:SetFont("Fonts\\FRIZQT__.TTF",16,"OUTLINE")
	SGI_ChangeLog.version:SetPoint("TOPLEFT",SGI_ChangeLog,"TOPLEFT",15,-40)
	SGI_ChangeLog.version:SetText("")
	
	SGI_ChangeLog.items = {}
	local y = -65
	for i = 1,10 do
		SGI_ChangeLog.items[i] = SGI_ChangeLog:CreateFontString()
		SGI_ChangeLog.items[i]:SetFont("Fonts\\FRIZQT__.TTF",14,"OUTLINE")
		SGI_ChangeLog.items[i]:SetPoint("TOPLEFT",SGI_ChangeLog,"TOPLEFT",30,y)
		SGI_ChangeLog.items[i]:SetText("")
		SGI_ChangeLog.items[i]:SetJustifyH("LEFT")
		SGI_ChangeLog.items[i]:SetSpacing(3)
		y = y - 17
	end
	SGI_ChangeLog.SetChange = function(changes)
		local Y = -65
		SGI_ChangeLog.version:SetText("|cff16ABB5"..changes.version.."|r")
		for k,_ in pairs(changes.items) do
			SGI_ChangeLog.items[k]:SetText("|cffffff00"..changes.items[k].."|r")
			SGI_ChangeLog.items[k]:SetWidth(490)
			SGI_ChangeLog.items[k]:SetPoint("TOPLEFT",SGI_ChangeLog,"TOPLEFT",30,Y)
			Y = Y - SGI_ChangeLog.items[k]:GetHeight() - 5
		end
	end
end

function SGI:ShowChanges()
	if ( SGI_ChangeLog ) then
		SGI_ChangeLog:Show()
	else
		ChangeLog()
		SGI_ChangeLog:Show()
	end
	SGI_ChangeLog.SetChange(SGI.versionChanges);
end


local function CreateTroubleShooter()
	CreateFrame("Frame","SGI_TroubleShooter")
	SGI_TroubleShooter:SetWidth(300)
	SGI_TroubleShooter:SetHeight(100)
	SetFramePosition(SGI_TroubleShooter)
	SGI_TroubleShooter:SetMovable()
	SGI_TroubleShooter:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SGI_TroubleShooter:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(SGI_TroubleShooter)
	end)
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SGI_TroubleShooter:SetBackdrop(backdrop)
	local close = CreateFrame("Button",nil,SGI_TroubleShooter,"UIPanelCloseButton")
	close:SetPoint("TOPRIGHT",SGI_TroubleShooter,"TOPRIGHT",-4,-4)
	
	SGI_TroubleShooter.title = SGI_TroubleShooter:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_TroubleShooter.title:SetPoint("TOP",SGI_TroubleShooter,"TOP",0,-10)
	SGI_TroubleShooter.title:SetText("Common issues")
	
	
	local update = 0;
	
	SGI_TroubleShooter.items = {};
	SGI_TroubleShooter:SetScript("OnUpdate", function()
		if (update < GetTime()) then
			
			
			
			
			update = GetTime() + 0.5;
		end
	end)
	
	
	SGI_TroubleShooter:HookScript("OnHide", function() if (SGI_Options.showAgain) then SGI_Options:Show() SGI_Options.showAgain = false end end);
end

function SGI:ShowTroubleShooter()
	if (not SGI_TroubleShooter) then
		CreateTroubleShooter();
	end
	SGI_TroubleShooter:Show();
end


local function OptBtn2_OnClick()
	SGI:ShowSuperScanFrame();
	SSBtn3_OnClick(SGI_SUPERSCAN_PLAYPAUSE2);
end


local function CreateOptions()
	CreateFrame("Frame","SGI_Options")
	SGI_Options:SetWidth(550)
	SGI_Options:SetHeight(350)
	SetFramePosition(SGI_Options)
	SGI_Options:SetMovable()
	SGI_Options:SetScript("OnMouseDown",function(self)
		self:StartMoving()
	end)
	SGI_Options:SetScript("OnMouseUp",function(self)
		self:StopMovingOrSizing()
		SaveFramePosition(SGI_Options)
	end)
	local backdrop = 
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background", 
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", 
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	SGI_Options:SetBackdrop(backdrop)
	local close = CreateFrame("Button",nil,SGI_Options,"UIPanelCloseButton")
	close:SetPoint("TOPRIGHT",SGI_Options,"TOPRIGHT",-4,-4)
	
	SGI_Options.title = SGI_Options:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.title:SetText("SuperGuildInvite "..SGI.VERSION_MAJOR..SGI.VERSION_MINOR.." Options")
	SGI_Options.title:SetPoint("TOP",SGI_Options,"TOP",0,-15)
	SGI_Options.bottom = SGI_Options:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.bottom:SetText("Written by Janniie - Stormreaver EU")
	SGI_Options.bottom:SetPoint("BOTTOM",SGI_Options,"BOTTOM",0,20)
	
	local anchor = {}
			anchor.point = "TOPLEFT"
			anchor.relativePoint = "TOPLEFT"
			anchor.xOfs = 7
			anchor.yOfs = -50
	
	local WhisperMode = {
		SGI.L["Invite only"],
		SGI.L["Invite, then whisper"],
		SGI.L["Whisper only"],
	}
	
	local spacing = 25;
	
	SGI_Options.dropDown1 = CreateDropDown("DROPDOWN_INVITE_MODE", SGI_Options, SGI.L["Invite Mode"], WhisperMode, anchor);
		anchor.yOfs = anchor.yOfs - spacing - 7;
		anchor.xOfs = anchor.xOfs + 13;
	SGI_Options.checkBox1 = CreateCheckbox("CHECKBOX_SGI_MUTE", SGI_Options, SGI.L["Mute SGI"], anchor);
		anchor.yOfs = anchor.yOfs - spacing;
	SGI_Options.checkBox2 = CreateCheckbox("CHECKBOX_ADV_SCAN", SGI_Options, SGI.L["Advanced scan options"], anchor);
		anchor.yOfs = anchor.yOfs - spacing;
	SGI_Options.checkBox3 = CreateCheckbox("CHECKBOX_HIDE_SYSTEM", SGI_Options, SGI.L["Hide system messages"], anchor);
		anchor.yOfs = anchor.yOfs - spacing;
	SGI_Options.checkBox7 = CreateCheckbox("CHECKBOX_HIDE_WHISPER", SGI_Options, SGI.L["Hide outgoing whispers"], anchor);
		anchor.yOfs = anchor.yOfs - spacing;
	SGI_Options.checkBox4 = CreateCheckbox("CHECKBOX_HIDE_MINIMAP", SGI_Options, SGI.L["Hide minimap button"], anchor);
		anchor.yOfs = anchor.yOfs - spacing;
	SGI_Options.checkBox5 = CreateCheckbox("CHECKBOX_BACKGROUND_MODE", SGI_Options, SGI.L["Run SuperScan in the background"], anchor);
		anchor.yOfs = anchor.yOfs - spacing;
	SGI_Options.checkBox6 = CreateCheckbox("CHECKBOX_ENABLE_FILTERS", SGI_Options, SGI.L["Enable filtering"], anchor);
	
	SGI_Options.checkBox3:HookScript("PostClick", function(self) ChatIntercept:StateSystem(self:GetChecked()) end);
	SGI_Options.checkBox7:HookScript("PostClick", function(self) ChatIntercept:StateWhisper(self:GetChecked()) end);
		
		anchor.point = "BOTTOMLEFT"
		anchor.relativePoint = "BOTTOMLEFT"
		anchor.xOfs = 20
		anchor.yOfs = 45
		
	--onClickTester
	SGI_Options.button1 = CreateButton("BUTTON_CUSTOM_WHISPER", SGI_Options, 120, 30, SGI.L["Customize whisper"], anchor, function(self) ShowWhisperFrame() SGI_Options:Hide() SGI_Options.showAgain = true end);
		anchor.xOfs = anchor.xOfs + 125;
	SGI_Options.button2 = CreateButton("BUTTON_SUPER_SCAN", SGI_Options, 120, 30, SGI.L["SuperScan"], anchor, OptBtn2_OnClick);
		anchor.xOfs = anchor.xOfs + 125;
	SGI_Options.button3 = CreateButton("BUTTON_INVITE", SGI_Options, 120, 30, format(SGI.L["Invite: %d"],SGI:GetNumQueued()), anchor, SGI.SendGuildInvite);
		anchor.xOfs = anchor.xOfs + 125;
	SGI_Options.button4 = CreateButton("BUTTON_CHOOSE_INVITES", SGI_Options, 120, 30, SGI.L["Choose invites"], anchor, SGI.ShowInviteList);
		anchor.yOfs = 80;
	SGI_Options.button5 = CreateButton("BUTTON_EDIT_FILTERS", SGI_Options, 120, 30, SGI.L["Filters"], anchor, function() SGI:ShowFilterHandle() SGI_Options:Hide() end);
		anchor.xOfs = anchor.xOfs - 125;
	--SGI_Options.button6 = CreateButton("BUTTON_HELP", SGI_Options, 120, 30, SGI.L["Help"],anchor, function() SGI:ShowTroubleShooter() SGI_Options:Hide() SGI_Options.showAgain = true end);
		--anchor.xOfs = anchor.xOfs - 125;
	SGI_Options.button7 = CreateButton("BUTTON_KEYBIND", SGI_Options, 120, 30, SGI.L["Set Keybind ("..(SGI_DATA[SGI_DATA_INDEX].keyBind and SGI_DATA[SGI_DATA_INDEX].keyBind or "NONE")..")"], anchor, KeyHarvestFrame.GetNewKeybindKey);
		anchor.xOfs = anchor.xOfs - 125;
	--SGI_Options.button8 = CreateButton("BUTTON_FILTER", SGI_Options, 120, 30, SGI.L["Filters"], anchor, onClickTester);
	
	
	SGI_Options.limitLow = CreateFrame("Frame","SGI_LowLimit",SGI_Options)
	SGI_Options.limitLow:SetWidth(40)
	SGI_Options.limitLow:SetHeight(40)
	SGI_Options.limitLow:SetPoint("CENTER",SGI_Options,"CENTER",20,80)
	SGI_Options.limitLow.text = SGI_Options.limitLow:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.limitLow.text:SetPoint("CENTER")
	SGI_Options.limitLow.texture = SGI_Options.limitLow:CreateTexture()
	SGI_Options.limitLow.texture:SetAllPoints()
	SGI_Options.limitLow.texture:SetTexture(1,1,0,0.2)
	SGI_Options.limitLow.texture:Hide()
	SGI_Options.limitTooltip = CreateFrame("Frame","LimitTool",SGI_Options.limitLow,"GameTooltipTemplate")
	
	SGI_Options.limitTooltip:SetPoint("TOP",SGI_Options.limitLow,"BOTTOM")
	SGI_Options.limitTooltip.text = SGI_Options.limitTooltip:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.limitTooltip.text:SetPoint("LEFT",SGI_Options.limitTooltip,"LEFT",12,0)
	SGI_Options.limitTooltip.text:SetJustifyH("LEFT")
	SGI_Options.limitTooltip.text:SetText(SGI.L["Highest and lowest level to search for"])
	SGI_Options.limitTooltip.text:SetWidth(115)
	SGI_Options.limitTooltip:SetWidth(130)
	SGI_Options.limitTooltip:SetHeight(SGI_Options.limitTooltip.text:GetHeight() + 12)
	
	SGI_Options.limitLow:SetScript("OnEnter",function()
		SGI_Options.limitLow.texture:Show()
		SGI_Options.limitTooltip:Show()
	end)
	SGI_Options.limitLow:SetScript("OnLeave",function()
		SGI_Options.limitLow.texture:Hide()
		SGI_Options.limitTooltip:Hide()
	end)
	
	SGI_Options.limitHigh = CreateFrame("Frame","SGI_HighLimit",SGI_Options)
	SGI_Options.limitHigh:SetWidth(40)
	SGI_Options.limitHigh:SetHeight(40)
	SGI_Options.limitHigh:SetPoint("CENTER",SGI_Options,"CENTER",60,80)
	SGI_Options.limitHigh.text = SGI_Options.limitHigh:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.limitHigh.text:SetPoint("CENTER")
	SGI_Options.limitHigh.texture = SGI_Options.limitHigh:CreateTexture()
	SGI_Options.limitHigh.texture:SetAllPoints()
	SGI_Options.limitHigh.texture:SetTexture(1,1,0,0.2)
	SGI_Options.limitHigh.texture:Hide()
	
	SGI_Options.limitHigh:SetScript("OnEnter",function()
		SGI_Options.limitHigh.texture:Show()
		SGI_Options.limitTooltip:Show()
	end)
	SGI_Options.limitHigh:SetScript("OnLeave",function()
		SGI_Options.limitHigh.texture:Hide()
		SGI_Options.limitTooltip:Hide()
	end)
	
	SGI_Options.limitLow.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.lowLimit.."  - ")
	SGI_Options.limitLow:SetScript("OnMouseWheel",function(self,delta)
		if delta == 1 and SGI_DATA[SGI_DATA_INDEX].settings.lowLimit + 1 <= SGI_DATA[SGI_DATA_INDEX].settings.highLimit then
			SGI_DATA[SGI_DATA_INDEX].settings.lowLimit = SGI_DATA[SGI_DATA_INDEX].settings.lowLimit + 1
			SGI_Options.limitLow.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.lowLimit.." - ")
		elseif delta == -1 and SGI_DATA[SGI_DATA_INDEX].settings.lowLimit - 1 > 0 then
			SGI_DATA[SGI_DATA_INDEX].settings.lowLimit = SGI_DATA[SGI_DATA_INDEX].settings.lowLimit - 1
			SGI_Options.limitLow.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.lowLimit.." - ")
		end
	end)
	
	SGI_Options.limitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.highLimit)
	SGI_Options.limitHigh:SetScript("OnMouseWheel",function(self,delta)
		if delta == 1 and SGI_DATA[SGI_DATA_INDEX].settings.highLimit + 1 <= 90 then
			SGI_DATA[SGI_DATA_INDEX].settings.highLimit = SGI_DATA[SGI_DATA_INDEX].settings.highLimit + 1
			SGI_Options.limitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.highLimit)
		elseif delta == -1 and SGI_DATA[SGI_DATA_INDEX].settings.highLimit > SGI_DATA[SGI_DATA_INDEX].settings.lowLimit then
			SGI_DATA[SGI_DATA_INDEX].settings.highLimit = SGI_DATA[SGI_DATA_INDEX].settings.highLimit - 1
			SGI_Options.limitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.highLimit)
		end
	end)
	
	SGI_Options.limitText = SGI_Options.limitLow:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.limitText:SetPoint("BOTTOM",SGI_Options.limitLow,"TOP",16,3)
	SGI_Options.limitText:SetText(SGI.L["Level limits"])
	
	SGI_Options.raceLimitHigh = CreateFrame("Frame","SGI_RaceLimitHigh",SGI_Options)
	SGI_Options.raceLimitHigh:SetWidth(40)
	SGI_Options.raceLimitHigh:SetHeight(40)
	SGI_Options.raceLimitHigh:SetPoint("CENTER",SGI_Options,"CENTER",150,80)
	SGI_Options.raceLimitHigh.text = SGI_Options.raceLimitHigh:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.raceLimitHigh.text:SetPoint("CENTER")
	SGI_Options.raceLimitHigh.texture = SGI_Options.raceLimitHigh:CreateTexture()
	SGI_Options.raceLimitHigh.texture:SetAllPoints()
	SGI_Options.raceLimitHigh.texture:SetTexture(1,1,0,0.2)
	SGI_Options.raceLimitHigh.texture:Hide()
	SGI_Options.raceTooltip = CreateFrame("Frame","LimitTool",SGI_Options.raceLimitHigh,"GameTooltipTemplate")
	
	SGI_Options.raceTooltip:SetPoint("TOP",SGI_Options.raceLimitHigh,"BOTTOM")
	SGI_Options.raceTooltip.text = SGI_Options.raceTooltip:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.raceTooltip.text:SetPoint("LEFT",SGI_Options.raceTooltip,"LEFT",12,0)
	SGI_Options.raceTooltip.text:SetJustifyH("LEFT")
	SGI_Options.raceTooltip.text:SetText(SGI.L["The level you wish to start dividing the search by race"])
	SGI_Options.raceTooltip.text:SetWidth(110)
	SGI_Options.raceTooltip:SetWidth(125)
	SGI_Options.raceTooltip:SetHeight(SGI_Options.raceTooltip.text:GetHeight() + 12)
	
	SGI_Options.raceLimitText = SGI_Options.raceLimitHigh:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.raceLimitText:SetPoint("BOTTOM",SGI_Options.raceLimitHigh,"TOP",0,3)
	SGI_Options.raceLimitText:SetText(SGI.L["Racefilter Start:"])
	
	SGI_Options.raceLimitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.raceStart)
	SGI_Options.raceLimitHigh:SetScript("OnMouseWheel",function(self,delta)
		if delta == -1 and SGI_DATA[SGI_DATA_INDEX].settings.raceStart > 1 then
			SGI_DATA[SGI_DATA_INDEX].settings.raceStart = SGI_DATA[SGI_DATA_INDEX].settings.raceStart - 1
			SGI_Options.raceLimitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.raceStart)
		elseif delta == 1 and SGI_DATA[SGI_DATA_INDEX].settings.raceStart < 91 then
			SGI_DATA[SGI_DATA_INDEX].settings.raceStart = SGI_DATA[SGI_DATA_INDEX].settings.raceStart + 1
			SGI_Options.raceLimitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.raceStart)
			if SGI_DATA[SGI_DATA_INDEX].settings.raceStart == 91 then
				SGI_Options.raceLimitHigh.text:SetText(SGI.L["OFF"])
			end
		end
	end)
	
	SGI_Options.raceLimitHigh:SetScript("OnEnter",function()
		SGI_Options.raceLimitHigh.texture:Show()
		SGI_Options.raceTooltip:Show()
	end)
	SGI_Options.raceLimitHigh:SetScript("OnLeave",function()
		SGI_Options.raceLimitHigh.texture:Hide()
		SGI_Options.raceTooltip:Hide()
	end)
	
	SGI_Options.classLimitHigh = CreateFrame("Frame","SGI_ClassLimitHigh",SGI_Options)
	SGI_Options.classLimitHigh:SetWidth(40)
	SGI_Options.classLimitHigh:SetHeight(40)
	SGI_Options.classLimitHigh:SetPoint("CENTER",SGI_Options,"CENTER",150,10)
	SGI_Options.classLimitHigh.text = SGI_Options.classLimitHigh:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.classLimitHigh.text:SetPoint("CENTER")
	SGI_Options.classLimitHigh.texture = SGI_Options.classLimitHigh:CreateTexture()
	SGI_Options.classLimitHigh.texture:SetAllPoints()
	SGI_Options.classLimitHigh.texture:SetTexture(1,1,0,0.2)
	SGI_Options.classLimitHigh.texture:Hide()
	SGI_Options.classTooltip = CreateFrame("Frame","LimitTool",SGI_Options.classLimitHigh,"GameTooltipTemplate")
	
	SGI_Options.classTooltip:SetPoint("TOP",SGI_Options.classLimitHigh,"BOTTOM")
	SGI_Options.classTooltip.text = SGI_Options.classTooltip:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.classTooltip.text:SetPoint("LEFT",SGI_Options.classTooltip,"LEFT",12,0)
	SGI_Options.classTooltip.text:SetJustifyH("LEFT")
	SGI_Options.classTooltip.text:SetText(SGI.L["The level you wish to divide the search by class"])
	SGI_Options.classTooltip.text:SetWidth(110)
	
	SGI_Options.classTooltip:SetWidth(125)
	SGI_Options.classTooltip:SetHeight(SGI_Options.classTooltip.text:GetHeight() + 12)
	
	SGI_Options.classLimitText = SGI_Options.classLimitHigh:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.classLimitText:SetPoint("BOTTOM",SGI_Options.classLimitHigh,"TOP",0,3)
	SGI_Options.classLimitText:SetText(SGI.L["Classfilter Start:"])
	
	SGI_Options.classLimitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.classStart)
	SGI_Options.classLimitHigh:SetScript("OnMouseWheel",function(self,delta)
		if delta == -1 and SGI_DATA[SGI_DATA_INDEX].settings.classStart > 1 then
			SGI_DATA[SGI_DATA_INDEX].settings.classStart = SGI_DATA[SGI_DATA_INDEX].settings.classStart - 1
			SGI_Options.classLimitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.classStart)
		elseif delta == 1 and SGI_DATA[SGI_DATA_INDEX].settings.classStart < 91 then
			SGI_DATA[SGI_DATA_INDEX].settings.classStart = SGI_DATA[SGI_DATA_INDEX].settings.classStart + 1
			SGI_Options.classLimitHigh.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.classStart)
			if SGI_DATA[SGI_DATA_INDEX].settings.classStart == 91 then
				SGI_Options.classLimitHigh.text:SetText(SGI.L["OFF"])
			end
		end
	end)
	
	SGI_Options.classLimitHigh:SetScript("OnEnter",function()
		SGI_Options.classLimitHigh.texture:Show()
		SGI_Options.classTooltip:Show()
	end)
	SGI_Options.classLimitHigh:SetScript("OnLeave",function()
		SGI_Options.classLimitHigh.texture:Hide()
		SGI_Options.classTooltip:Hide()
	end)
	
	SGI_Options.Interval = CreateFrame("Frame","SGI_Interval",SGI_Options)
	SGI_Options.Interval:SetWidth(40)
	SGI_Options.Interval:SetHeight(40)
	SGI_Options.Interval:SetPoint("CENTER",SGI_Options,"CENTER",40,10)
	SGI_Options.Interval.text = SGI_Options.Interval:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
	SGI_Options.Interval.text:SetPoint("CENTER")
	SGI_Options.Interval.texture = SGI_Options.Interval:CreateTexture()
	SGI_Options.Interval.texture:SetAllPoints()
	SGI_Options.Interval.texture:SetTexture(1,1,0,0.2)
	SGI_Options.Interval.texture:Hide()
	SGI_Options.intervalTooltip = CreateFrame("Frame","LimitTool",SGI_Options.Interval,"GameTooltipTemplate")
	
	SGI_Options.intervalTooltip:SetPoint("TOP",SGI_Options.Interval,"BOTTOM")
	SGI_Options.intervalTooltip.text = SGI_Options.intervalTooltip:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.intervalTooltip.text:SetPoint("LEFT",SGI_Options.intervalTooltip,"LEFT",12,0)
	SGI_Options.intervalTooltip.text:SetJustifyH("LEFT")
	SGI_Options.intervalTooltip.text:SetText(SGI.L["Amount of levels to search every 7 seconds (higher numbers increase the risk of capping the search results)"])
	SGI_Options.intervalTooltip.text:SetWidth(130)
	SGI_Options.intervalTooltip:SetHeight(120)
	SGI_Options.intervalTooltip:SetWidth(135)
	SGI_Options.intervalTooltip:SetHeight(SGI_Options.intervalTooltip.text:GetHeight() + 12)
	
	SGI_Options.intervalText = SGI_Options.Interval:CreateFontString(nil,"OVERLAY","GameFontNormal")
	SGI_Options.intervalText:SetPoint("BOTTOM",SGI_Options.Interval,"TOP",0,3)
	SGI_Options.intervalText:SetText(SGI.L["Interval:"])
	
	SGI_Options.Interval.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.interval)
	SGI_Options.Interval:SetScript("OnMouseWheel",function(self,delta)
		if delta == -1 and SGI_DATA[SGI_DATA_INDEX].settings.interval > 1 then
			SGI_DATA[SGI_DATA_INDEX].settings.interval = SGI_DATA[SGI_DATA_INDEX].settings.interval - 1
			SGI_Options.Interval.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.interval)
		elseif delta == 1 and SGI_DATA[SGI_DATA_INDEX].settings.interval < 30 then
			SGI_DATA[SGI_DATA_INDEX].settings.interval = SGI_DATA[SGI_DATA_INDEX].settings.interval + 1
			SGI_Options.Interval.text:SetText(SGI_DATA[SGI_DATA_INDEX].settings.interval)
		end
	end)
	
	SGI_Options.Interval:SetScript("OnEnter",function()
		SGI_Options.Interval.texture:Show()
		SGI_Options.intervalTooltip:Show()
	end)
	SGI_Options.Interval:SetScript("OnLeave",function()
		SGI_Options.Interval.texture:Hide()
		SGI_Options.intervalTooltip:Hide()
	end)
	
	anchor = {
		point = "BOTTOMLEFT",
		relativePoint = "BOTTOMLEFT",
		xOfs = 4,
		yOfs = 4,
	}
	SGI_Options.superScanText = SGI_Options:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
	SGI_Options.superScanText:SetPoint("BOTTOMLEFT", SGI_Options, "BOTTOMLEFT", 35, 10);
	SGI_Options.superScanText:SetText("SuperScan");
	SGI_Options.buttonPlayPause = CreateButton("SGI_SUPERSCAN_PLAYPAUSE2", SGI_Options, 40,30,"",anchor,SSBtn3_OnClick);
	SGI_SUPERSCAN_PLAYPAUSE2:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up");
	SGI_SUPERSCAN_PLAYPAUSE2:Hide();
	SGI_Options.superScanText:Hide();
	
	SGI_Options.nextUpdate = 0;
	SGI_Options:SetScript("OnUpdate", function()
		if (SGI_Options.nextUpdate < GetTime()) then
			
			if SGI_DATA[SGI_DATA_INDEX].settings.classStart == 91 then
				SGI_Options.classLimitHigh.text:SetText(SGI.L["OFF"])
			end
			
			if SGI_DATA[SGI_DATA_INDEX].settings.raceStart == 91 then
				SGI_Options.raceLimitHigh.text:SetText(SGI.L["OFF"])
			end
			
			if (SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_BACKGROUND_MODE"]) then
				SGI_SUPERSCAN_PLAYPAUSE2:Show();
				SGI_Options.superScanText:Show();
				if SuperScanFrame then SuperScanFrame:Hide() end;
			else
				SGI_SUPERSCAN_PLAYPAUSE2:Hide();
				SGI_Options.superScanText:Hide();
				if (SGI:IsScanning()) then
					SGI:ShowSuperScanFrame();
				end
			end
			
			if (SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_ADV_SCAN"]) then
				if (not SGI_Options.Interval:IsShown()) then
					SGI_Options.Interval:Show();
				end
				if (not SGI_Options.classLimitHigh:IsShown()) then
					SGI_Options.classLimitHigh:Show();
				end
				if (not SGI_Options.raceLimitHigh:IsShown()) then
					SGI_Options.raceLimitHigh:Show();
				end
			else
				SGI_Options.Interval:Hide();
				SGI_Options.classLimitHigh:Hide();
				SGI_Options.raceLimitHigh:Hide();
			end
			
			BUTTON_INVITE.label:SetText(format(SGI.L["Invite: %d"],SGI:GetNumQueued()));
			BUTTON_KEYBIND.label:SetText(SGI.L["Set Keybind ("..(SGI_DATA[SGI_DATA_INDEX].keyBind and SGI_DATA[SGI_DATA_INDEX].keyBind or "NONE")..")"]);
			
			if (SGI_DATA[SGI_DATA_INDEX].debug) then
				SGI_Options.title:SetText("|cffff3300(DEBUG MODE) |rSuperGuildInvite "..SGI.VERSION_MAJOR..SGI.VERSION_MINOR.." Options")
			else
				SGI_Options.title:SetText("SuperGuildInvite "..SGI.VERSION_MAJOR..SGI.VERSION_MINOR.." Options")
			end
			
			if (not SGI_DATA[SGI_DATA_INDEX].settings.checkBox["CHECKBOX_HIDE_MINIMAP"]) then
				SGI:ShowMinimapButton();
			else
				SGI:HideMinimapButton();
			end
			
			SGI_Options.nextUpdate = GetTime() + 1;
		end
	end)
	
end

function SGI:ShowOptions()
	if (not SGI_Options) then
		CreateOptions();
	end
	SGI_Options:Show();
end

function SGI:HideOptions()
	if (SGI_Options) then
		SGI_Options:Hide();
	end
end


local function CreateMinimapButton()
	local f = CreateFrame("Button","SGI_MiniMapButton",Minimap)
	f:SetWidth(32)
	f:SetHeight(32)
	f:SetFrameStrata("MEDIUM")
	f:SetMovable(true)
	SetFramePosition(f)
	
	f:SetNormalTexture("Interface\\AddOns\\SuperGuildInvite\\media\\SGI_MiniMapButton")
	f:SetPushedTexture("Interface\\AddOns\\SuperGuildInvite\\media\\SGI_MiniMapButtonPushed")
	f:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	
	local tooltip = CreateFrame("Frame","SGI_TooltTipMini",f,"GameTooltipTemplate")
	tooltip:SetPoint("BOTTOMRIGHT",f,"TOPLEFT",0,-3)
	local toolstring = tooltip:CreateFontString(nil,"OVERLAY","GameFontNormal")
	toolstring:SetPoint("TOPLEFT",tooltip,"TOPLEFT",5,-7)
	
	local toolstring2 = tooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	local toolstring3 = tooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	toolstring2:SetPoint("TOPLEFT",tooltip,"TOPLEFT",7,-33);
	toolstring3:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 7, -46);
	toolstring2:SetText(format("ETR: %s",SGI:GetSuperScanTimeLeft()));
	toolstring3:SetText(format("%d%% done",floor(SGI:GetPercentageDone())));
	
	local tUpdate = 0;
	local function UpdateTooltip()
		if (tUpdate < GetTime()) then
			toolstring:SetText(SGI.LOGO..format("|cff88aaffSuperGuildInvite|r\n|cff16ABB5Queue: %d|r",SGI:GetNumQueued()))
			toolstring2:SetText(format("ETR: %s",SGI:GetSuperScanTimeLeft()));
			toolstring3:SetText(format("%d%% done",floor(SGI:GetPercentageDone())));
			--SGI:debug(format("ETR: %s",SGI:GetSuperScanETR()));
			--SGI:debug(format("%d%% done",floor(SGI:GetPercentageDone())));
			tUpdate = GetTime() + 0.2;
		end
	end
	
	toolstring:SetText(SGI.LOGO..format("|cff88aaffSuperGuildInvite|r\n|cff16ABB5Queue: |r|cffffff00%d|r",SGI:GetNumQueued()))
	toolstring:SetJustifyH("LEFT");
	tooltip:SetWidth(max(toolstring:GetWidth(),toolstring2:GetWidth(),toolstring3:GetWidth())+ 20)
	tooltip:SetHeight(toolstring:GetHeight() + toolstring2:GetHeight() + toolstring3:GetHeight() + 15)
	tooltip:Hide()
	f:SetScript("OnEnter",function()
		toolstring:SetText(SGI.LOGO..format("|cff88aaffSuperGuildInvite|r\n|cff16ABB5Queue: %d|r",SGI:GetNumQueued()))
		tooltip:Show()
		tooltip:SetScript("OnUpdate",UpdateTooltip);
	end)
	f:SetScript("OnLeave",function()
		tooltip:Hide()
		tooltip:SetScript("OnUpdate", nil);
	end)
	
	
	local function moveButton(self)
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		centerX, centerY = math.abs(x), math.abs(y)
		centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2)) * 85, (centerY / sqrt(centerX^2 + centerY^2)) * 85
		centerX = x < 0 and -centerX or centerX
		centerY = y < 0 and -centerY or centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", centerX, centerY)
	end
	
	f:SetScript("OnMouseDown",function(self,button)
		if button == "RightButton" then
			self:SetScript("OnUpdate",moveButton)
		end
	end)
	f:SetScript("OnMouseUp",function(self,button)
		self:SetScript("OnUpdate",nil)
		SaveFramePosition(self)
	end)
	f:SetScript("OnClick",function(self,button)
		if SGI_Options and SGI_Options:IsShown() then
			SGI:HideOptions()
		else
			SGI:ShowOptions()
		end
	end)
end

function SGI:ShowMinimapButton()
	if (not SGI_MiniMapButton) then
		CreateMinimapButton();
	end
	SGI_MiniMapButton:Show();
end

function SGI:HideMinimapButton()
	if (SGI_MiniMapButton) then
		SGI_MiniMapButton:Hide();
	end
end








SGI:debug(">> GUI.lua");




