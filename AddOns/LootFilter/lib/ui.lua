function LootFilter.getNames()
	local result= '';
	table.sort(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]);
	for key, value in ipairs(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]) do
		result= result..value.."\n";	
	end;
	LootFilterEditBox1:SetText(result);
end;

function LootFilter.getNamesDelete()
	local result= "";
	table.sort(LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"]);
	for key, value in ipairs(LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"]) do
		result= result..value.."\n";
	end;
	LootFilterEditBox2:SetText(result);
end;


function LootFilter.setNames()
	LootFilterVars[LootFilter.REALMPLAYER].keepList["names"]= {};
	local result= LootFilterEditBox1:GetText().."\n";
	if (result ~= nil) then
		for w in string.gmatch(result, "[^\n]+\n") do
			w = string.gsub(w, "\n", "");
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].keepList["names"], w);
		end;
	end;
end;

function LootFilter.setNamesDelete()
	LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"]= {};
	local result= LootFilterEditBox2:GetText().."\n";
	if (result ~= nil) then
		for w in string.gmatch(result, "[^\n]+\n") do
			w = string.gsub(w, "\n", "");
			table.insert(LootFilterVars[LootFilter.REALMPLAYER].deleteList["names"], w);
		end;
	end;
end;


function LootFilter.showTooltip(area, text)
	if (LootFilterVars[LootFilter.REALMPLAYER].tooltips) then
		GameTooltip:SetOwner(LootFilterOptions, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(LootFilter.Locale.LocTooltip[text], 1, 1, 1, 0.75, 1);
		GameTooltip:Show();
	end;
end;

function LootFilter.setRadioButtonsValue(button)
	local name = LootFilter.trim(button:GetParent():GetName());
	if (LootFilterVars[LootFilter.REALMPLAYER].keepList[name] ~= nil) then
		LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= nil;
	end;
	if (LootFilterVars[LootFilter.REALMPLAYER].deleteList[name] ~= nil) then
		LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= nil;
	end;

	local children = { button:GetParent():GetChildren() };
	local i = 0;
	for _, child in ipairs(children) do
		if (child ~= button) then
			child:SetChecked(false);
		else
			button:SetChecked(true);
			if (i == 1) then
				if (string.match(name, "^QU")) then
					LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= LootFilter.Locale.qualities[name];
				elseif (string.match(name, "^TY")) then
					LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= LootFilter.Locale.radioButtonsText[name];
				else
					LootFilterVars[LootFilter.REALMPLAYER].keepList[name]= true;
				end;
			elseif (i == 2) then
				if (string.match(name, "^QU")) then
					LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= LootFilter.Locale.qualities[name];
				elseif (string.match(name, "^TY")) then
					LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= LootFilter.Locale.radioButtonsText[name];
				else
					LootFilterVars[LootFilter.REALMPLAYER].deleteList[name]= true;
				end;
			end;
		end;
		i = i + 1;
	end;
end;

function LootFilter.getRadioButtonsValue(button)
	
	local name = LootFilter.trim(button:GetName());
	local fontString = getglobal(button:GetName().."_Text");
	local radioButton = getglobal(button:GetName().."_Default");
	
	getglobal(button:GetName().."_Default"):SetChecked(false);
	getglobal(button:GetName().."_Keep"):SetChecked(false);
	getglobal(button:GetName().."_Delete"):SetChecked(false);
	fontString:SetText(LootFilter.Locale.radioButtonsText[name]);
	if (LootFilterVars[LootFilter.REALMPLAYER].keepList[name] ~= nil) then
		radioButton = getglobal(button:GetName().."_Keep");
	elseif (LootFilterVars[LootFilter.REALMPLAYER].deleteList[name] ~= nil) then
		radioButton = getglobal(button:GetName().."_Delete");
	end;
	radioButton:SetChecked(true);
	
end;

function LootFilter.setRadioButtonValue(button)
	local name = LootFilter.trim(button:GetParent():GetName());
	local checked = false;
	if (button:GetChecked()) then
		checked = true;
	end;

	if (name == "OPEnable") then
		LootFilterVars[LootFilter.REALMPLAYER].enabled = checked;
	elseif (name == "OPCaching") then
		LootFilterVars[LootFilter.REALMPLAYER].caching = checked;
		if (checked) then
			LootFilterEditBox5:Show();
			LootFilterTextBackground5:Show();
			LootFilterFreeSlotsText:Show();
		else
			LootFilterEditBox5:Hide();
			LootFilterTextBackground5:Hide();
			LootFilterFreeSlotsText:Hide();
		end;
	elseif (name == "OPNoValue") then
		LootFilterVars[LootFilter.REALMPLAYER].novalue = checked;
 	elseif (name == "OPMarketValue") then
		LootFilterVars[LootFilter.REALMPLAYER].marketvalue = checked;
	elseif (name == "OPTooltips") then
		LootFilterVars[LootFilter.REALMPLAYER].tooltips = checked;
	elseif (name == "OPNotifyDelete") then
		LootFilterVars[LootFilter.REALMPLAYER].notifydelete = checked;
	elseif (name == "OPNotifyKeep") then
		LootFilterVars[LootFilter.REALMPLAYER].notifykeep = checked;
	elseif (name == "OPNotifyNoMatch") then
		LootFilterVars[LootFilter.REALMPLAYER].notifynomatch = checked;
	elseif (name == "OPNotifyOpen") then
		LootFilterVars[LootFilter.REALMPLAYER].notifyopen = checked;
	elseif (name == "OPNotifyNew") then
		LootFilterVars[LootFilter.REALMPLAYER].notifynew = checked;
	elseif (name == "OPValKeep") then
		LootFilterVars[LootFilter.REALMPLAYER].keepList["VAOn"] = checked;
	elseif (name == "OPValDelete") then
		LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAOn"] = checked;
	elseif (name == "OPOpenVendor") then
		LootFilterVars[LootFilter.REALMPLAYER].openvendor = checked;
	elseif (name == "OPAutoSell") then
		LootFilterVars[LootFilter.REALMPLAYER].autosell = checked;	
	elseif (name == "OPBag0") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[0] = checked;
	elseif (name == "OPBag1") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[1] = checked;
	elseif (name == "OPBag2") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[2] = checked;
	elseif (name == "OPBag3") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[3] = checked;
	elseif (name == "OPBag4") then
		LootFilterVars[LootFilter.REALMPLAYER].openbag[4] = checked;
	elseif (name == "OPConfirmDelete") then
		LootFilterVars[LootFilter.REALMPLAYER].confirmdel = checked;
	end;
end;

function LootFilter.getRadioButtonValue(button)
	local name = LootFilter.trim(button:GetName());
	local fontString = getglobal(button:GetName().."_Text");
	local radioButton = getglobal(button:GetName().."_Button");
	fontString:SetText(LootFilter.Locale.radioButtonsText[name]);
	if (name == "OPEnable") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].enabled);
	elseif (name == "OPCaching") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].caching);
	elseif (name == "OPNoValue") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].novalue);
	elseif (name == "OPMarketValue") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].marketvalue);				
	elseif (name == "OPTooltips") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].tooltips);
	elseif (name == "OPNotifyDelete") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifydelete);
	elseif (name == "OPNotifyKeep") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifykeep);
	elseif (name == "OPNotifyOpen") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifyopen);
	elseif (name == "OPNotifyNew") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifynew);
	elseif (name == "OPNotifyNoMatch") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].notifynomatch);
	elseif (name == "OPValKeep") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].keepList["VAOn"]);
	elseif (name == "OPValDelete") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAOn"]);
	elseif (name == "OPOpenVendor") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openvendor);
	elseif (name == "OPAutoSell") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].autosell);	
	elseif (name == "OPBag0") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[0]);
	elseif (name == "OPBag1") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[1]);
	elseif (name == "OPBag2") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[2]);
	elseif (name == "OPBag3") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[3]);
	elseif (name == "OPBag4") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].openbag[4]);
	elseif (name == "OPConfirmDelete") then
		radioButton:SetChecked(LootFilterVars[LootFilter.REALMPLAYER].confirmdel);
	end;
end;

function LootFilter.setItemValue()
	local value= tonumber(LootFilterEditBox3:GetText());
	if (value == nil) or (value == "") then
		value= "0";
	end;
	LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"]= value;

	local value= tonumber(LootFilterEditBox4:GetText());
	if (value == nil) or (value == "") then
		value= "0";
	end;
	LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"]= value;

	local value= tonumber(LootFilterEditBox5:GetText());
	if (value == nil) or (value == "") then
		value= "0";
	end;
	LootFilterVars[LootFilter.REALMPLAYER].freebagslots= value;
end;

function LootFilter.getItemValue()
	local value= "";
	if (LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"] ~= nil) and (LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"] ~= "") then
		value= LootFilterVars[LootFilter.REALMPLAYER].deleteList["VAValue"];
	else
		value= "0";
	end;
	LootFilterEditBox3:SetText(value);
	local value= "";
	if (LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"] ~= nil) and (LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"] ~= "") then
		value= LootFilterVars[LootFilter.REALMPLAYER].keepList["VAValue"];
	else
		value= "0";
	end;
	LootFilterEditBox4:SetText(value);
	local value= "";
	if (LootFilterVars[LootFilter.REALMPLAYER].freebagslots ~= nil) and (LootFilterVars[LootFilter.REALMPLAYER].freebagslots ~= "") then
		value= LootFilterVars[LootFilter.REALMPLAYER].freebagslots;
	else
		value= "0";
	end;
	LootFilterEditBox5:SetText(value);
end;

function LootFilter.selectButton(button, frame)
	LootFilter.setNames();
	LootFilter.setNamesDelete();
	

	LootFilterButtonGeneral:UnlockHighlight();
	LootFilterButtonQuality:UnlockHighlight();
	LootFilterButtonType:UnlockHighlight();
	LootFilterButtonName:UnlockHighlight();
	LootFilterButtonValue:UnlockHighlight();
	LootFilterButtonClean:UnlockHighlight();
	LootFilterButtonCopy:UnlockHighlight();

	LootFilterFrameGeneral:Hide();
	LootFilterFrameQuality:Hide();
	LootFilterFrameType:Hide();
	LootFilterFrameName:Hide();
	LootFilterFrameValue:Hide();
	LootFilterFrameClean:Hide();
	LootFilterFrameCopy:Hide();

	button:LockHighlight();
	frame:Show();
end;

function LootFilter.updateFocus(self, num, value)
	if (value) then
		self:SetFocus();
		LootFilter.hasFocus= num;
	else
		self:ClearFocus();
		LootFilter.hasFocus= 0;
	end;
end;

function LootFilter.iWantTo()
	LootFilterButtonIWantTo:Enable();
end;

function LootFilter.initClean()
	LootFilterButtonDeleteItems:Enable();
	LootFilterButtonIWantTo:Disable();
	for line=1,19 do
		cleanLine = getglobal("cleanLine"..line);
		cleanLine:SetText("");
		cleanLine:Hide();
	end
	FauxScrollFrame_SetOffset(LootFilterScrollFrameClean, 0);
end;

function LootFilter.setTitle()
	LootFilterFrameTitleText:SetText("Loot Filter v"..LootFilter.VERSION);
end;

function LootFilter.CleanScrollBar_Update()
	local line; 
	local cleanLine;
	local lineplusoffset; 
	local numitems = table.getn(LootFilter.cleanList);
	if numitems < 20 then
		numitems = 20;
	end;
	FauxScrollFrame_Update(LootFilterScrollFrameClean,numitems,19,16);
	for line=1,19 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(LootFilterScrollFrameClean);
		cleanLine = getglobal("cleanLine"..line);
		if lineplusoffset <= table.getn(LootFilter.cleanList) then
			cleanLine:SetText(LootFilter.cleanList[lineplusoffset]["link"]);
			cleanLine:Show();
		else
			cleanLine:Hide();
		end
	end
end;

function LootFilter.SelectDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	
end;

function LootFilter.SelectDropDown_Initialize()
	local i = 1;
	local realm, player;
	local parent = LootFilterSelectDropDown;
	for key, value in LootFilter.sortedPairs(LootFilterVars) do
		if (key ~= LootFilter.REALMPLAYER and key:find("%s -") ~= nil) then
			local info = UIDropDownMenu_CreateInfo(); 

			info.text = key; --the text of the'menu item 
			info.value = i; -- the value of the menu item. This can be a string also. 
			info.func = LootFilter.SelectDropDown_OnClick; --sets the function to execute when this item is clicked 
			info.owner = parent; --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues. 
			info.checked = nil; --initially set the menu item to being unchecked with a yellow tick 
			info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text 
			UIDropDownMenu_AddButton(info, level);

			if (UIDropDownMenu_GetSelectedValue(LootFilterSelectDropDown) == nil) then
				UIDropDownMenu_SetSelectedID(LootFilterSelectDropDown, i);
				UIDropDownMenu_SetSelectedValue(LootFilterSelectDropDown, i);
				UIDropDownMenu_SetText(LootFilterSelectDropDown, key);
			end;
			i = i + 1;
		end;
	end;
end;

function LootFilter.SelectDropDownType_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	LootFilter.hideTypeTabs();
	local f = getglobal("LootFilterDKDType"..UIDropDownMenu_GetText(LootFilterSelectDropDownType))
	f:Show();
end;

function LootFilter.SelectDropDownType_Initialize()
	local i = 1;
	local parent = LootFilterSelectDropDownType;
	for key, value in LootFilter.sortedPairs(LootFilter.Locale.types) do
		local info = UIDropDownMenu_CreateInfo(); 

		info.text = value; --the text of the'menu item 
		info.value = i; -- the value of the menu item. This can be a string also. 
		info.func = LootFilter.SelectDropDownType_OnClick; --sets the function to execute when this item is clicked 
		info.owner = parent; --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues. 
		info.checked = nil; --initially set the menu item to being unchecked with a yellow tick 
		info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text 
		UIDropDownMenu_AddButton(info, level);

		if (UIDropDownMenu_GetSelectedValue(LootFilterSelectDropDownType) == nil) then
			UIDropDownMenu_SetSelectedID(LootFilterSelectDropDownType, i);
			UIDropDownMenu_SetSelectedValue(LootFilterSelectDropDownType, i);
			UIDropDownMenu_SetText(LootFilterSelectDropDownType, value);
			local f = getglobal("LootFilterDKDType"..value);
			if (f ~= nil) then
				f:Show();
			end;
		end;
		i = i + 1;
	end;
end;

function LootFilter.SelectDropDownCalculate_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	LootFilterVars[LootFilter.REALMPLAYER].calculate = self.value;
end;

function LootFilter.SelectDropDownCalculate_Initialize()
	local i = 1;
	local text = {};
	text[1] = LFINT_TXT_SIZETOCALCULATE_TEXT1;
	text[2] = LFINT_TXT_SIZETOCALCULATE_TEXT2;
	text[3] = LFINT_TXT_SIZETOCALCULATE_TEXT3;
	local parent = LootFilterSelectDropDownCalculate;
	for key, value in LootFilter.sortedPairs(text) do
		local info = UIDropDownMenu_CreateInfo(); 

		info.text = value; --the text of the'menu item 
		info.value = i; -- the value of the menu item. This can be a string also. 
		info.func = LootFilter.SelectDropDownCalculate_OnClick; --sets the function to execute when this item is clicked 
		info.owner = parent; --binds the drop down menu as the parent of the menu item. This is very important for dynamic drop down menues. 
		info.checked = nil; --initially set the menu item to being unchecked with a yellow tick 
		info.icon = nil; --we can use this to set an icon for the drop down menu item to accompany the text 
		UIDropDownMenu_AddButton(info, level);

		if (LootFilterVars[LootFilter.REALMPLAYER].calculate == i) then
			UIDropDownMenu_SetSelectedID(LootFilterSelectDropDownCalculate, i);
			UIDropDownMenu_SetSelectedValue(LootFilterSelectDropDownCalculate, i);
			UIDropDownMenu_SetText(LootFilterSelectDropDownCalculate, value);
		end;

		i = i + 1;
	end;
end;

function LootFilter.checkDependencies()
	if (GetSellValue ~= nil) then
		LootFilterOPCaching:Show();
		if (LootFilterVars[LootFilter.REALMPLAYER].caching) then
			LootFilterEditBox5:Show();
			LootFilterTextBackground5:Show();
			LootFilterFreeSlotsText:Show();
		end;
		LootFilterOPValKeep:Show();
		LootFilterOPValDelete:Show();
		LootFilterEditBox3:Show();
		LootFilterEditBox4:Show();
		LootFilterTextBackground3:Show();
		LootFilterTextBackground4:Show();
		LootFilterOPNoValue:Show();
		LootFilterSelectDropDownCalculate:Show();
		LootFilterSizeToCalculate:Show();
		LootFilterButtonReset:Show();
		
		LootFilterNeedAddon:Hide();
		if (((AucAdvanced) and (AucAdvanced.API) and (AucAdvanced.API.GetMarketValue))) then -- Auctioneer advanced
			LootFilterOPMarketValue:Show();
			LootFilter.marketValue = true;
		end;		
	end;
	
end;

function LootFilter.hideTypeTabs()
	for key, typeName in pairs(LootFilter.Locale.types) do
		local f = getglobal("LootFilterDKDType"..typeName);
		f:Hide();
	end;
end;

function LootFilter.sortedPairs(t,comparator)
	local sortedKeys = {};
	table.foreach(t, function(k,v) table.insert(sortedKeys,k) end);
	table.sort(sortedKeys,comparator);
	local i = 0;
	local function _f(_s,_v)
		i = i + 1;
		local k = sortedKeys[i];
		if (k) then
			return k,t[k];
		end
	end
	return _f,nil,nil;
end

-- type tab, don't forget to sort, lua is stupid that way
function LootFilter.initTypeTab()
	
	for key, typeName in LootFilter.sortedPairs(LootFilter.Locale.types) do
		local f = CreateFrame("Frame", "LootFilterDKDType"..typeName, LootFilterFrameType);
		y = -100;
		for key2, subtypeName in LootFilter.sortedPairs(LootFilter.Locale.radioButtonsText) do
			if (string.match(key2, "^TY"..typeName)) then
				local g = CreateFrame("Frame","LootFilter"..key2, getglobal("LootFilterDKDType"..typeName), "LootFilterDKDOptionsTemplate");
				g:ClearAllPoints();
				g:SetPoint("TOP", "LootFilterOptions", "TOP", -297, y);
				g:Show();
				y = y - 18;			
			end;
		end;
		f:Hide();
	end;
end;

function LootFilter.initQualityTab()
	local y = -100;
	for key, typeName in LootFilter.sortedPairs(LootFilter.Locale.radioButtonsText) do
		if (string.match(key, "^QU")) then
			local g = CreateFrame("Frame","LootFilter"..key, LootFilterFrameQuality, "LootFilterDKDOptionsTemplate");
			g:ClearAllPoints();
			g:SetPoint("TOP", "LootFilterOptions", "TOP", -297, y);
			g:Show();
			y = y - 18;		
		end;	
	end;
end;


function LootFilter.initCopyTab()
	if (LootFilter.varCount() <= 1) then
		LootFilterButtonRealCopy:Hide();
		LootFilterSelectDropDown:Hide();
		LootFilterButtonRealDelete:Hide();
		LootFilterEditBoxTitleCopy3:SetText(LootFilter.Locale.LocText["LTNoOtherCharacterToCopySettings"]);
		LootFilterEditBoxTitleCopy4:Hide();
		LootFilterEditBoxTitleCopy5:Hide();
	end;
end;

