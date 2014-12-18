local ToyPlus = LibStub("AceAddon-3.0"):NewAddon("ToyPlus", "AceConsole-3.0", "AceEvent-3.0")
local icon = LibStub("LibDBIcon-1.0")
local LibQTip = LibStub('LibQTip-1.0')
local skipToys

local ToyPlusLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ToyPlusLDB", {
	type = "data source",
	text = "ToyPlus",
	icon = "Interface\\Icons\\INV_Misc_Toy_09",
	OnClick = function(self, button)
		if button == "LeftButton" then
			ToyPlus:Launch()
		elseif button == "RightButton" then
			InterfaceOptionsFrame_OpenToCategory("ToyPlus")
		end
	end,
	OnEnter = function(self) ToyPlus:Broker(self) end,
})

function ToyPlus:Broker(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
	if InCombatLockdown() then return end

	ToyPlus:RefreshToys()
	for i = 1, #ToyPlus.db.global.toyName do
		local toyBtn = _G["brokerBtn"..i]
		if toyBtn then toyBtn:Hide() end
	end
	local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
	self.tooltip = tooltip
	tooltip:AddHeader('ToyPlus')
	tooltip:SetLineTextColor(1,0,0.7,1)
	tooltip:AddSeparator(1,0,0.5,1)
	tooltip:AddLine('Left-Click to toggle the toy icons bars.')
	tooltip:AddLine('Right-Click to open the configuration.')
	tooltip:AddSeparator(1,0,0.5,1)
	if not C_ToyBox.GetIsFavorite(ToyPlus.db.global.itemID[1]) then
		tooltip:AddLine('No favourites found. Add some via the toy list.')
	else
		tooltip:AddLine('Click a toy below to use:')
		tooltip:AddSeparator(1,0,0.5,1)
		for i = 1, #ToyPlus.db.global.toyName do
			if C_ToyBox.GetIsFavorite(ToyPlus.db.global.itemID[i]) then
				local toyName, itemID = ToyPlus.db.global.toyName[i], ToyPlus.db.global.itemID[i]
				local start, duration = GetItemCooldown(itemID)
				local tRow = i+7
				tooltip:AddLine(toyName)
				if start == 0 then tooltip:SetLineTextColor(tRow,0,0.7,1)
				else tooltip:SetLineTextColor(tRow,1,0,0) end
				tooltip:SetLineScript(tRow, "OnEnter", function(tt)
					local toyBtn = _G["brokerBtn"..i]
					if not toyBtn then
						toyBtn = CreateFrame("Button","brokerBtn"..i,self,"SecureActionButtonTemplate") 
						toyBtn:SetFrameStrata(tt:GetFrameStrata())
						toyBtn:SetFrameLevel(tt:GetFrameLevel()+1)
					end
					toyBtn:SetAllPoints(tt)
					toyBtn:Show()
					toyBtn:SetAttribute("type", "item")
					toyBtn:SetAttribute("item", toyName)
					toyBtn:SetScript("OnEnter", function()
						local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
						if tooltip:IsShown() then
							tooltip:SetLineTextColor(tRow,1,1,0)
						end
					end)
					toyBtn:SetScript("OnLeave", function()
						local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
						if tooltip:IsShown() then
							local start, duration = GetItemCooldown(itemID)
							if start == 0 then tooltip:SetLineTextColor(tRow,0,0.7)
							else tooltip:SetLineTextColor(tRow,1,0,0) end
						end
					end)
					toyBtn:RegisterUnitEvent("ACTIONBAR_UPDATE_COOLDOWN"); toyBtn:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE")
					toyBtn:SetScript("OnEvent", function(self, event)
						if event == "ACTIONBAR_UPDATE_COOLDOWN" or "LOSS_OF_CONTROL_UPDATE" then
							local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
							if tooltip:IsShown() then
								local start, duration = GetItemCooldown(itemID)
								if start == 0 then tooltip:SetLineTextColor(tRow,0,0.7)
								else tooltip:SetLineTextColor(tRow,1,0,0) end
							end
						end
					end)
				end, tt)
			end
		end
	end
	tooltip:SetAutoHideDelay(1)
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function ToyPlus:SkipList()
	if UnitFactionGroup("player") == "Horde" then skipToys = {119217,45021,89999,119144,45011,45018,45019,45020,95589,63141,54651} --Faction Toys
	else skipToys = {54653,90000,53057,119145,95590,119218,45013,45014,45015,45016,45017,115468,64997,64997,54653} end

	local levelToys = {[119432]=100,[119145]=100,[119421]=100,[116122]=95,[108743]=94,[113670]=94,[118221]=92,[118222]=92,[113570]=90,[115503]=90,[108735]=90,[118716]=90,[87528]=90,[113631]=90,[118244]=90,[88531]=90,[116125]=90,[120276]=90,[111476]=90,[117573]=90,[70159]=85,[116115]=85,[71259]=85,[104331]=85,[52253]=80}
	for k,v in pairs(levelToys) do --Level Req Toys
		if UnitLevel("player") < v then tinsert(skipToys, k) end
	end

	local engiToys = {[40895]=350,[17716]=190,[18660]=1,[109183]=1}--Engineering Toys
	local hasEngi, engiSkill = false, 0
	local prof1, prof2 = GetProfessions()
	if prof1 then
		local profName, profIcon, profSkill = GetProfessionInfo(prof1)
		if profName == "Engineering" then hasEngi = true; engiSkill = profSkill end
	end
	if prof2 then
		local profName, profIcon, profSkill = GetProfessionInfo(prof2)
		if profName == "Engineering" then hasEngi = true; engiSkill = profSkill end
	end
	if hasEngi == true then
		for k,v in pairs(engiToys) do 
			if engiSkill < v then tinsert(skipToys, k) end 
		end
	else
		for k,v in pairs(engiToys) do tinsert(skipToys, k) end
	end

	local repToys = {["Sha'tari Defense"]=21000,["Sunreaver Onslaught"]=42000,["Kirin Tor Offensive"]=42000,["Order of the Cloud Serpent"]=21000,["Baradin's Wardens"]=9000,["Hellscream's Reach"]=9000,["Sha'tari Defense"]=9000,["The Tillers"]=21000,["The Tillers"]=42000,["Emperor Shaohao"]=21000,["Frostwolf Orcs"]=9000,["Laughing Skull Orcs"]=9000,["Timbermaw Hold"]=42000}
	local repToysID = {["Sha'tari Defense"]=119421,["Sunreaver Onslaught"]=95590,["Kirin Tor Offensive"]=95589,["Order of the Cloud Serpent"]=89222,["Baradin's Wardens"]=63141,["Hellscream's Reach"]=64997,["Sha'tari Defense"]=119182,["The Tillers"]=89869,["The Tillers"]=90175,["Emperor Shaohao"]=103685,["Frostwolf Orcs"]=115468,["Laughing Skull Orcs"]=119160,["Timbermaw Hold"]=66888}
	local repToysCheck = {["Sha'tari Defense"]=false,["Sunreaver Onslaught"]=false,["Kirin Tor Offensive"]=false,["Order of the Cloud Serpent"]=false,["Baradin's Wardens"]=false,["Hellscream's Reach"]=false,["Sha'tari Defense"]=false,["The Tillers"]=false,["The Tillers"]=false,["Emperor Shaohao"]=false,["Frostwolf Orcs"]=false,["Laughing Skull Orcs"]=false,["Timbermaw Hold"]=false}
	for k,v in pairs(repToys) do --Reputation Toys
		for i = 1, 150 do
			local name, description, standingID, barMin, barMax, barValue = GetFactionInfo(i)
			if not name then break
			elseif name == k then
				if barValue < v then tinsert(skipToys, repToysID[k]) end
				repToysCheck[k]=true--Tag as checked
			end
		end
	end
	for k,v in pairs(repToysCheck) do --Final check if faction not yet encountered
		if v == false then tinsert(skipToys, repToysID[k]) end
	end
end

function ToyPlus:OnInitialize()
	local defaults = {
		profile = {
			minimap = {
				hide = false,
			},
			rows = 2,
			columns = 5,
			scale = 26
		},
	}
	self.db = LibStub("AceDB-3.0"):New("ToyPlusDB", defaults)
	icon:Register("ToyPlus", ToyPlusLDB, self.db.profile.minimap)
	ToyPlus:RegisterChatCommand("toyplus", "Launch")
	ToyPlus:RegisterOptions()
	self.db.global.toyName = self.db.global.toyName or {}
	self.db.global.toyIcon = self.db.global.toyIcon or {}
	self.db.global.itemID = self.db.global.itemID or {}
	self:SkipList()
	if #ToyPlus.db.global.toyName > 0 and self.db.profile.shown then ToyPlus:CreateFrame() end
end

function ToyPlus:RegisterOptions()-- Blizzard Options
	local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable("ToyPlus", {
		type = 'group',
		args = {
			togglebutton = {
				type = 'toggle',
				order = 1,
				name = "Show Minimap Icon",
				get = function()
					return not ToyPlus.db.profile.minimap.hide
				end,
				set = ToyPlus.ToggleLDBIcon,
			},
			toyCols = {
				type = 'range',
				order = 2,
				name = "Columns",
				get = function(info)
					return ToyPlus.db.profile.columns
				end,
				set = function(info, key)
					if not InCombatLockdown() then ToyPlus.db.profile.columns = key
					ToyPlus:ToggleRows() end
				end,
				min = 3, max = 10, step = 1,
			},
			toyRows = {
				type = 'range',
				order = 3,
				name = "Rows",
				get = function(info)
					return ToyPlus.db.profile.rows
				end,
				set = function(info, key)
					if not InCombatLockdown() then ToyPlus.db.profile.rows = key
					ToyPlus:ToggleRows() end
				end,
				min = 1, max = 10, step = 1,
			},
			toyScale = {
				type = 'range',
				order = 4,
				name = "Scale",
				get = function(info)
					return ToyPlus.db.profile.scale
				end,
				set = function(info, key)
					if not InCombatLockdown() then ToyPlus.db.profile.scale = key
					ToyPlus:ToggleRows() end
				end,
				min = 25, max = 30, step = 1,
			},

		},
	})
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ToyPlus")
end

function ToyPlus:ToggleLDBIcon()-- Toggle Minimap Icon
	ToyPlus.db.profile.minimap.hide = not ToyPlus.db.profile.minimap.hide
	if ToyPlus.db.profile.minimap.hide then
		icon:Hide("ToyPlus")
	else
		icon:Show("ToyPlus")
	end
end

function ToyPlus:ToysUpdated()
	if InCombatLockdown() then return end
	local toyFrame = _G["ToyPlusFrame"]
	local toyPopout = _G["ToyPlus_Popout"]
	if toyFrame then ToyPlus:RefreshIcons() end
	if toyPopout then ToyPlus:RefreshList(0, false) end
	if C_ToyBox.GetNumLearnedDisplayedToys() > #ToyPlus.db.global.toyName then
		ToyPlus:RefreshToys()
		f = _G["ToyPlus_Popout"]
		if f then ToyPlus:RefreshList(0, false) end
	end
end
ToyPlus:RegisterEvent("TOYS_UPDATED", "ToysUpdated")

function ToyPlus:ToggleRows()-- Toggle Icon Rows
	local fra = _G["ToyPlusFrame"]
	if fra then
		local toyRows = ToyPlus.db.profile.rows
		local toyCols = ToyPlus.db.profile.columns
		local toyScale = ToyPlus.db.profile.scale
		local toyTotal = toyRows*toyCols
		local prevToy
		for i = 1, toyTotal do
			local toyIcon = _G["ToyPlus_Icon"..i]
			if toyIcon then
				if i == 1 then
					toyIcon:SetPoint("TOPLEFT",fra,"TOPLEFT",7,-27)
					prevToy = toyIcon
				elseif i == (toyCols+1) or i == ((toyCols*2)+1) or i == ((toyCols*3)+1) or i == ((toyCols*4)+1) or i == ((toyCols*5)+1)	 
				or i == ((toyCols*6)+1) or i == ((toyCols*7)+1) or i == ((toyCols*8)+1) or i == ((toyCols*9)+1) then 
					toyIcon:SetPoint("TOPLEFT",prevToy,"BOTTOMLEFT",0,-7)
					prevToy = toyIcon
				else
					toyIcon:SetPoint("TOPLEFT",_G["ToyPlus_Icon"..(i-1)],"TOPRIGHT",7,0) 
				end
				toyIcon:SetSize(toyScale,toyScale)
				toyIcon.texture:SetAllPoints()
			end
		end
		local startNum, endNum = 1, toyTotal
		for i = startNum, endNum do --Make icons visible
			local toyIcon = _G["ToyPlus_Icon"..i]
			if toyIcon then toyIcon:Show() end
		end
		startNum = endNum+1
		endNum = 100
		for i = startNum, endNum do --Hide the rest
			local toyIcon = _G["ToyPlus_Icon"..i]
			if toyIcon then toyIcon:Hide() end
		end

		local fraH = 27+(toyRows*(toyScale+7))
		fraH=floor(fraH)
		if fraH%2 ~= 0 then fraH=fraH-1 end
		fra:SetHeight(fraH)

		local fraW = 8+(toyCols*(toyScale+6.8))
		fraW=floor(fraW)
		if fraW%2 ~= 0 then fraW=fraW+1 end
		fra:SetWidth(fraW)

		local btnAddRow = _G["ToyPlusFrame_AddRow"]
		local btnLessRow = _G["ToyPlusFrame_LessRow"]
		local toyRows = ToyPlus.db.profile.rows
		if toyRows == 1 then btnLessRow:Hide(); btnAddRow:Show()
		elseif toyRows > 1 and toyRows < 10 then btnLessRow:Show(); btnAddRow:Show()
		elseif toyRows == 10 then btnLessRow:Show(); btnAddRow:Hide() end
		if toyCols > 4 then _G["ToyPlusFrame_Label"]:Show() else _G["ToyPlusFrame_Label"]:Hide() end
	end
end

function ToyPlus:RefreshToys() -- Add Toys to DB
	C_ToyBox.SetFilterCollected(true)
	C_ToyBox.ClearAllSourceTypesFiltered()--Load ToyBox and ensure proper filtering
	local toyTotal = C_ToyBox.GetNumTotalDisplayedToys()
	local toyTotalLearned = C_ToyBox.GetNumLearnedDisplayedToys()
	local toyNum = 1
	local skipToy
	if toyTotalLearned > 0 then
		wipe(ToyPlus.db.global.toyName); wipe(ToyPlus.db.global.itemID); wipe(ToyPlus.db.global.toyIcon)
		for i = 1, toyTotal do
			local itemNo = C_ToyBox.GetToyFromIndex(i)
			local itemID, toyName, toyIcon, toyFave = C_ToyBox.GetToyInfo(itemNo)
			skipToy = false
			for i = 1, #skipToys do
				if skipToys[i] == itemID then skipToy = true end
			end
			if PlayerHasToy(itemID) and not skipToy then
				ToyPlus.db.global.toyName[toyNum] = toyName
				ToyPlus.db.global.itemID[toyNum] = itemID
				ToyPlus.db.global.toyIcon[toyNum] = toyIcon
				toyNum=toyNum+1
			end
		end
	end
end

function ToyPlus:Launch()
	if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
	if C_ToyBox.GetToyFromIndex(1) ~= -1 then
		ToyPlus:RefreshToys()
		local toyFrame = _G["ToyPlusFrame"]
		local toyPopout = _G["ToyPlus_Popout"]
		if not toyFrame then
			ToyPlus:CreateFrame()
		else
			if toyFrame:IsVisible() then
				local btnPopout = _G["ToyPlusFrame_Popout"]
				toyFrame:Hide()
				ToyPlus.db.profile.shown = false
				btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
				if toyPopout then toyPopout:Hide() end
			else
				toyFrame:Show() 
				ToyPlus.db.profile.shown = true
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffToy Box hasn't been loaded or no toys found.", 0, 0.7, 1)
	end
end

function ToyPlus:ShowList()
	local toyPopout = _G["ToyPlus_Popout"]
	local toyFrame = _G["ToyPlusFrame"]
	ToyPlus:RefreshToys()
	if not toyPopout then
		toyPopout = CreateFrame("Frame", "ToyPlus_Popout", UIParent)
		toyPopout:SetFrameStrata("BACKGROUND")
		toyPopout:EnableMouse(true)
		toyPopout:RegisterForDrag("LeftButton")
		toyPopout:SetPoint("BOTTOMLEFT", toyFrame, "BOTTOMRIGHT",-1,0)
		toyPopout:SetSize(286,204)
		toyPopout.texture = toyPopout:CreateTexture()--Background
		toyPopout.texture:SetPoint("TOPLEFT", toyPopout, 2, -2)
		toyPopout.texture:SetPoint("BOTTOMRIGHT", toyPopout, -2, 2)
		toyPopout.texture:SetTexture(0,0,0)
		toyPopout.texture:SetAlpha(0.8)
		toyPopout:Show()
		local scrFra = CreateFrame("ScrollFrame", "ToyPlus_ScrollFrame", toyPopout)
		scrFra:SetPoint("TOPLEFT", 2, -2)
		scrFra:SetPoint("BOTTOMRIGHT", -2, 2)
		toyPopout.scrollframe = scrFra
		local scrBar = CreateFrame("Slider", "ToyPlus_Slider", scrFra, "UIPanelScrollBarTemplate")
		scrBar:SetPoint("TOPLEFT", toyPopout, "TOPRIGHT", -19, -19)
		scrBar:SetPoint("BOTTOMLEFT", toyPopout, "BOTTOMRIGHT", 19, 19)
		scrBar:SetMinMaxValues(1, 100)
		scrBar:SetValueStep(46)
		scrBar:SetValue(0)
		scrBar:SetWidth(16)
		scrBar:SetScript("OnValueChanged", function (self, value) self:GetParent():SetVerticalScroll(value) end)
		toyPopout.scrollbar = scrBar 
		scrFra:EnableMouseWheel(true)
		scrFra:SetScript("OnMouseWheel",
			function(self, delta) 
				local x = scrBar:GetValue(); local y = scrBar:GetValueStep()
				if delta == 1 then scrBar:SetValue(x-y)
				else scrBar:SetValue(x+y) end 
		end)
		local scrContent = CreateFrame("Frame", "ToyPlus_Content", scrFra)
		scrContent:SetSize(128,128)
		scrFra.content = scrContent 
		scrFra:SetScrollChild(scrContent)
		local backdrop = { -- Border
		  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		  tile = false, tileSize = 8, edgeSize = 8,
		  insets = { left = 2, right = 2, top = 2, bottom = 2 } }
		toyPopout:SetBackdrop(backdrop)
		toyPopout:SetBackdropBorderColor(0,0.564,1,1)
		--Checkboxes
		local x, y = 1, 1
		for i = 1, #ToyPlus.db.global.toyName do
			local itemNo = ToyPlus.db.global.itemID[i]
			local itemID, toyName, toyIconStr, toyFave = C_ToyBox.GetToyInfo(itemNo)
			local chkbox = CreateFrame("CheckButton", "ToyPlus_Check"..i, scrContent, "UICheckButtonTemplate")
			local chktxt =  _G[chkbox:GetName().."Text"]
			chkbox:SetSize(25, 25)
			chktxt:SetJustifyH("Left")
			if C_ToyBox.GetIsFavorite(itemID) then chkbox:SetChecked(true) else chkbox:SetChecked(false) end
			chktxt:SetText(toyName)
			chkbox:SetPoint("TOPLEFT",scrContent,"TOPLEFT",1, y)
			chkbox:SetScript("OnClick", function(self, button)
				if button == "LeftButton" then
					if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error:\124cffffffffCan't do that while in combat.", 0, 0.7, 1) return end
					if chkbox:GetChecked(true) then ToyPlus:RefreshList(itemID, true)
					else ToyPlus:RefreshList(itemID, false) end
				end
			end)
			chkbox:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetToyByItemID(itemID)
			end)
			chkbox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			y=y-18
		end
		if #ToyPlus.db.global.toyName > 11 then
			x = (#ToyPlus.db.global.toyName*18)-196
			scrBar:SetMinMaxValues(1, x)
			scrBar:SetValueStep((x/10)-1)
		else scrBar:Hide() end
	else
		if toyPopout:IsVisible() then toyPopout:Hide() else toyPopout:Show() end
	end
end

function ToyPlus:RefreshList(itemID, toyFave)
	if itemID ~= 0 then C_ToyBox.SetIsFavorite(itemID, toyFave) end
	ToyPlus:RefreshToys()
	local chkID = 1
	for i = 1, #ToyPlus.db.global.toyName do
		local itemNo = ToyPlus.db.global.itemID[i]
		local itemID, toyName, toyIconStr, toyFave = C_ToyBox.GetToyInfo(itemNo)
		local chkbox = _G["ToyPlus_Check"..i]
		if not chkbox then-- Create Checkbox
			local scrContent = _G["ToyPlus_Content"]
			if not scrContent then break end
			local chkbox = CreateFrame("CheckButton", "ToyPlus_Check"..i, scrContent, "UICheckButtonTemplate")
			local chktxt =  _G[chkbox:GetName().."Text"]
			chkbox:SetSize(25, 25)
			chktxt:SetJustifyH("Left")
			if C_ToyBox.GetIsFavorite(itemID) then chkbox:SetChecked(true) else chkbox:SetChecked(false) end
			chktxt:SetText(toyName)
			local y = 19
			y=y-(18*i)
			chkbox:SetPoint("TOPLEFT",scrContent,"TOPLEFT",1, y)
			chkbox:SetScript("OnClick", function(self, button)
				if button == "LeftButton" then 
					if chkbox:GetChecked(true) then ToyPlus:RefreshList(itemID, true)
					else ToyPlus:RefreshList(itemID, false) end
				end
			end)
			chkbox:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetToyByItemID(itemID)
			end)
			chkbox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		else
			local chktxt =  _G[chkbox:GetName().."Text"]
			if itemID then if C_ToyBox.GetIsFavorite(itemID) then chkbox:SetChecked(true) else chkbox:SetChecked(false) end end
			chktxt:SetText(toyName)
			chkbox:SetScript("OnClick", function(self, button)
				if button == "LeftButton" then 
					if chkbox:GetChecked(true) then ToyPlus:RefreshList(itemID, true)
					else ToyPlus:RefreshList(itemID, false) end
				end
			end)
			chkbox:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetToyByItemID(itemID)
			end)
			chkbox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		end
		local scrBar = _G["ToyPlus_Slider"]
		if scrBar then
			if #ToyPlus.db.global.toyName > 11 then
				x = (#ToyPlus.db.global.toyName*18)-196
				scrBar:SetMinMaxValues(1, x)
				scrBar:SetValueStep((x/10)-1)
			else scrBar:Hide() end
		end
	end
	ToyPlus:RefreshIcons()
end

function ToyPlus:RefreshIcons()
	ToyPlus:RefreshToys()
	local toyRows = ToyPlus.db.profile.rows
	local toyCols = ToyPlus.db.profile.columns
	local toyTotal = toyRows*toyCols
	for i = 1, toyTotal do
		if ToyPlus.db.global.itemID[i] then
			local itemID, toyName, toyIconStr = ToyPlus.db.global.itemID[i], ToyPlus.db.global.toyName[i], ToyPlus.db.global.toyIcon[i]
			local toyIcon = _G["ToyPlus_Icon"..i]
			local toyCD = _G["ToyPlus_Icon"..i.."_CD"]
			local start, duration = GetItemCooldown(itemID) --Update CD
			if toyCD then toyCD:SetCooldown(start, duration) end
			toyIcon.texture:SetTexture(toyIconStr)
			toyIcon:SetAttribute("item", toyName)
			toyIcon:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetToyByItemID(itemID)
			end)
			toyIcon:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			toyIcon:SetScript("OnDragStart", function(self)
				C_ToyBox.PickupToyBoxItem(itemID)
			end)
			toyIcon:SetScript("OnEvent", function(self, event, ...)
				if event == "ACTIONBAR_UPDATE_COOLDOWN" then
					local start, duration
					start, duration = GetItemCooldown(itemID)
					if start ~= 0 then toyCD:SetCooldown(start, duration) end
				end
			end)
		end
	end
end

function ToyPlus:CreateFrame()
	local toyFrame = CreateFrame("Frame", "ToyPlusFrame", UIParent)--Toy Icons Frame
	toyFrame:SetFrameStrata("BACKGROUND")
	toyFrame:SetMovable(true); toyFrame:EnableMouse(true)
	toyFrame:RegisterForDrag("LeftButton")
	toyFrame:SetScript("OnDragStart", toyFrame.StartMoving)
	toyFrame:SetScript("OnDragStop", toyFrame.StopMovingOrSizing)
	toyFrame:SetPoint("CENTER") 
	toyFrame:SetSize(185,96)
	toyFrame:SetUserPlaced(true)
	toyFrame.texture = toyFrame:CreateTexture()
	toyFrame.texture:SetPoint("TOPLEFT", toyFrame, 2, -2)
	toyFrame.texture:SetPoint("BOTTOMRIGHT", toyFrame, -2, 2)
	toyFrame.texture:SetTexture(0,0,0,0.8)
	toyFrame:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then InterfaceOptionsFrame_OpenToCategory("ToyPlus") end
	end)
	toyFrame:Show()
	local backdrop = {
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	  tile = false, tileSize = 8, edgeSize = 8,
	  insets = { left = 2, right = 2, top = 2, bottom = 2 }
	}
	toyFrame:SetBackdrop(backdrop)
	toyFrame:SetBackdropBorderColor(0,0.564,1,1)
	local label = toyFrame:CreateFontString("$parent_Label","OVERLAY","GameFontNormal")--ToyList Label
	label:SetPoint("TOPRIGHT",toyFrame,"TOPRIGHT",-26,-7)
	label:SetText("Toy List")
	label:Hide()
	local btn = CreateFrame("BUTTON", "$parent_Close", toyFrame, "UIPanelCloseButton")-- Close Button
	btn:SetPoint("TOPLEFT", toyFrame, "TOPLEFT", -1, 2)
	btn:SetSize(30,30)
	btn:Show(); btn:Enable()
	btn:SetScript("OnClick", function (self, button, down) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
			toyFrame:Hide()
			ToyPlus.db.profile.shown = false
			local fra2 = _G["ToyPlus_Popout"]
			if fra2 then
				fra2:Hide(); _G["ToyPlusFrame_Popout"].texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			end
		end 
	end)
	local btnAddRow = CreateFrame("BUTTON", "$parent_AddRow", toyFrame)-- Add Row Button
	btnAddRow:SetPoint("TOPLEFT", toyFrame, "TOPLEFT", 32, -6)
	btnAddRow:SetAlpha(1); btnAddRow:Show(); btnAddRow:Enable()
	btnAddRow:SetSize(14,14)
	btnAddRow.texture = btnAddRow:CreateTexture()
	btnAddRow.texture:SetAllPoints(btnAddRow)
	btnAddRow.texture:SetDrawLayer("ARTWORK", -1)
	btnAddRow.texture:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus")
	btnAddRow:SetScript("OnClick", function (self, button) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't adjust rows in combat.", 0, 0.7, 1) return end
			ToyPlus.db.profile.rows = ToyPlus.db.profile.rows + 1
			ToyPlus:ToggleRows()
		end
	end)
	local btnLessRow = CreateFrame("BUTTON", "$parent_LessRow", toyFrame)-- Remove Row Button
	btnLessRow:SetPoint("TOPLEFT", toyFrame, "TOPLEFT", 51, -6)
	btnLessRow:SetAlpha(1); btnLessRow:Show(); btnLessRow:Enable()
	btnLessRow:SetSize(16,16)
	btnLessRow.texture = btnLessRow:CreateTexture()
	btnLessRow.texture:SetAllPoints(btnLessRow)
	btnLessRow.texture:SetDrawLayer("ARTWORK", -1)
	btnLessRow.texture:SetTexture("Interface\\WorldMap\\Dash_64")
	btnLessRow:SetScript("OnClick", function (self, button) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't adjust rows in combat.", 0, 0.7, 1) return end
			ToyPlus.db.profile.rows = ToyPlus.db.profile.rows - 1
			ToyPlus:ToggleRows()
		end
	end)
	local btnPopout = CreateFrame("BUTTON", "$parent_Popout", toyFrame)-- Popout List Button
	btnPopout:SetPoint("TOPRIGHT", toyFrame, "TOPRIGHT", 0, 0)
	btnPopout:SetAlpha(1); btnPopout:Show(); btnPopout:Enable()
	btnPopout:SetSize(26,26)
	btnPopout.texture = btnPopout:CreateTexture()
	btnPopout.texture:SetTexCoord(0,1,0,1)
	btnPopout.texture:SetAllPoints(btnPopout)
	btnPopout.texture:SetDrawLayer("ARTWORK", -1)
	btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
	btnPopout:SetScript("OnClick", function (self, button) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
			local fra = _G["ToyPlus_Popout"]
			if not fra then	btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
			elseif fra:IsVisible() then btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			else btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up") end
			ToyPlus:ShowList() 
		end
	end)
	local iconH = 6
	local iconV = -27
	for i = 1, 100 do -- Toy Buttons
		if ToyPlus.db.global.toyName[i] then
			local toyName = ToyPlus.db.global.toyName[i]
			local toyIconStr = ToyPlus.db.global.toyIcon[i]
			local itemID = ToyPlus.db.global.itemID[i]
			toyIcon = CreateFrame("BUTTON","ToyPlus_Icon"..i,toyFrame, "SecureActionButtonTemplate,ActionButtonTemplate")--Icons
			toyIcon:RegisterUnitEvent("ACTIONBAR_UPDATE_COOLDOWN"); toyIcon:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE")
			toyIcon:SetAttribute("type1", "item")
			toyIcon:SetAttribute("item", toyName)
			toyIcon:RegisterForDrag("LeftButton")
			toyIcon:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			toyIcon:SetSize(30,30)
			toyIcon:SetPoint("TOPLEFT",toyFrame,"TOPLEFT",6,-27)
			toyIcon.texture = toyIcon:CreateTexture()
			toyIcon.texture:SetTexCoord(0.1,0.9,0.1,0.9)
			toyIcon.texture:SetAllPoints(toyIcon)
			toyIcon.texture:SetDrawLayer("BACKGROUND")
			toyIcon.texture:SetTexture(toyIconStr)
			local border = _G["ToyPlus_Icon"..i.."NormalTexture"]
			border:SetVertexColor(0,0.6,1,1)
			local toyCD = CreateFrame("Cooldown","$parent_CD",toyIcon, "CooldownFrameTemplate")
			toyCD:SetAllPoints(toyIcon)
			local start, duration = GetItemCooldown(itemID)
			if start ~= 0 then toyCD:SetCooldown(start, duration) end
			toyIcon:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetToyByItemID(itemID)
			end)
			toyIcon:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			toyIcon:SetScript("OnDragStart", function(self)
				C_ToyBox.PickupToyBoxItem(itemID)
			end)
			toyIcon:SetScript("OnEvent", function(self, event, ...)
				if event == "ACTIONBAR_UPDATE_COOLDOWN" or "LOSS_OF_CONTROL_UPDATE" then
					local start, duration = GetItemCooldown(itemID)
					if start ~= 0 then toyCD:SetCooldown(start, duration) end
				end
			end)
			toyIcon:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then
					if ToyPlus.db.global.itemID[i] then
						local isFavorite = C_ToyBox.GetIsFavorite(ToyPlus.db.global.itemID[i])
						if isFavorite then
							local menu = {
							    { text = "Remove Favorite", func = function()
							       if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
							       C_ToyBox.SetIsFavorite(ToyPlus.db.global.itemID[i], false); ToyPlus:RefreshList(0, false)
							     end },
							}
							local menuFrame = CreateFrame("Frame", "ToyPlus_FaveMenu", UIParent, "UIDropDownMenuTemplate")
							EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
						else
							local menu = {
							    { text = "Add Favorite", func = function()
								if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
								C_ToyBox.SetIsFavorite(ToyPlus.db.global.itemID[i], true); ToyPlus:RefreshList(0, false) 
							     end },
							}
							local menuFrame = CreateFrame("Frame", "ToyPlus_FaveMenu", UIParent, "UIDropDownMenuTemplate")
							EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
						end
					end
				end
			end)
			toyIcon:Hide()
		end
	end
	ToyPlus:ToggleRows()
	ToyPlus.db.profile.shown = true
end