rscspisokid={{20217,1126,115921},{21562},{1459,109773},{19740,116781}}

function rsccreateframebafs()
if rsccreateframebafsvar==nil then
rsccreateframebafsvar=1

rsccheckbuttable={} --таблица чекбаттонов

--editbox
rsceditboxtable={}

local rscebf1 = CreateFrame("EditBox", "rsceb1", rscframetoshowall5,"InputBoxTemplate")
rsceditframecreat(rscebf1,-225,1)
local rscebf2 = CreateFrame("EditBox", "rsceb2", rscframetoshowall5,"InputBoxTemplate")
rsceditframecreat(rscebf2,-245,2)
local rscebf3 = CreateFrame("EditBox", "rsceb3", rscframetoshowall5,"InputBoxTemplate")
rsceditframecreat(rscebf3,-265,3)
local rscebf4 = CreateFrame("EditBox", "rsceb4", rscframetoshowall5,"InputBoxTemplate")
rsceditframecreat(rscebf4,-285,4)
--local rscebf5 = CreateFrame("EditBox", "rsceb5", rscframetoshowall5,"InputBoxTemplate")
--rsceditframecreat(rscebf5,-305,5)
--local rscebf6 = CreateFrame("EditBox", "rsceb6", rscframetoshowall5,"InputBoxTemplate")
--rsceditframecreat(rscebf6,-325,6)
--local rscebf7 = CreateFrame("EditBox", "rsceb7", rscframetoshowall5,"InputBoxTemplate")
--rsceditframecreat(rscebf7,-345,7)
--local rscebf8 = CreateFrame("EditBox", "rsceb8", rscframetoshowall5,"InputBoxTemplate")
--rsceditframecreat(rscebf8,-365,8)
--local rscebf9 = CreateFrame("EditBox", "rsceb9", rscframetoshowall5,"InputBoxTemplate")
--rsceditframecreat(rscebf9,-385,9)

--txt main
	rsctxttitlemain = rscframetoshowall5:CreateFontString()
	rsctxttitlemain:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	rsctxttitlemain:SetText(rscbuffspart1.." |cff00ff00"..rscbufftimers[1].." "..rscsec.."|r "..rscbuffspart2.." |cff00ff00"..rscbufftimers[2].." "..rscsec.."|r "..rscbuffspart3)
	rsctxttitlemain:SetWidth(705)
	rsctxttitlemain:SetHeight(60)
	rsctxttitlemain:SetJustifyH("LEFT")
	rsctxttitlemain:SetJustifyV("TOP")
	rsctxttitlemain:SetPoint("TOPLEFT",15,-12)

	local tt = rscframetoshowall5:CreateFontString()
	tt:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	tt:SetText("|cff00ff00"..rscpartwhobuff1.."|r")
	tt:SetWidth(570)
	tt:SetHeight(20)
	tt:SetJustifyH("LEFT")
	tt:SetPoint("TOPLEFT",15,-207)

--5 checkbox

	rsccheckboxtabl5={}

	local pii=-72
	for ii=1,5 do
	local rsccheckbox1 = CreateFrame("CheckButton", nil, rscframetoshowall5, "OptionsCheckButtonTemplate")
	rsccheckbox1:SetWidth("25")
	rsccheckbox1:SetHeight("25")
	rsccheckbox1:SetPoint("TOPLEFT", 20, pii)
	rsccheckbox1:SetScript("OnClick", function(self) rsccheckbutchanged5(ii) end )
		if rscbuffcheckb2[ii]==1 then
			rsccheckbox1:SetChecked()
		else
			rsccheckbox1:SetChecked(false)
		end
	table.insert(rsccheckboxtabl5,rsccheckbox1)
	if ii~=4 then
		pii=pii-25
	else
		pii=pii-20
	end
	end


--1 add checkbox
	local rsccheckbox1 = CreateFrame("CheckButton", nil, rscframetoshowall5, "OptionsCheckButtonTemplate")
	rsccheckbox1:SetWidth("25")
	rsccheckbox1:SetHeight("25")
	rsccheckbox1:SetPoint("TOPLEFT", 144, -72)
	rsccheckbox1:SetScript("OnClick", function(self) rsccheckbutchanged5(6) end )
		if rscbuffcheckb2[6]==1 then
			rsccheckbox1:SetChecked()
		else
			rsccheckbox1:SetChecked(false)
		end
	table.insert(rsccheckboxtabl5,rsccheckbox1)


--5 text
	rsctextaddnon = rscframetoshowall5:CreateFontString()
	rsctextaddnon:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	if rscbuffcheckb2[1]==1 then
		rsctextaddnon:SetText("|cff00ff00"..rscparton3.."|r")
	else
		rsctextaddnon:SetText("|cffff0000"..rscparton3.."|r")
	end
	rsctextaddnon:SetJustifyH("LEFT")
	rsctextaddnon:SetPoint("TOPLEFT",43,-78)

	local t2 = rscframetoshowall5:CreateFontString()
	t2:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t2:SetText(rscpartanons31)
	t2:SetJustifyH("LEFT")
	t2:SetPoint("TOPLEFT",168,-103)

	local t3 = rscframetoshowall5:CreateFontString()
	t3:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t3:SetText(rscpartanons32)
	t3:SetJustifyH("LEFT")
	t3:SetPoint("TOPLEFT",168,-128)

	local t4 = rscframetoshowall5:CreateFontString()
	t4:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t4:SetText(rscpartanons33)
	t4:SetJustifyH("LEFT")
	t4:SetPoint("TOPLEFT",43,-153)

	local t5 = rscframetoshowall5:CreateFontString()
	t5:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t5:SetText(rscpartanons34)
	t5:SetJustifyH("LEFT")
	t5:SetPoint("TOPLEFT",43,-173)

	local t6 = rscframetoshowall5:CreateFontString()
	t6:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t6:SetText(rscpartanons35)
	t6:SetJustifyH("LEFT")
	t6:SetPoint("TOPLEFT",168,-78)



openmenubuff1()
openmenubuff2()

--sliders
	if psversion then
getglobal("PSFrscbuff_Timer1High"):SetText("19")
getglobal("PSFrscbuff_Timer1Low"):SetText("5")
PSFrscbuff_Timer1:SetMinMaxValues(5, 19)
PSFrscbuff_Timer1:SetValueStep(1)
PSFrscbuff_Timer1:SetValue(rscbufftimers[1])

getglobal("PSFrscbuff_Timer2High"):SetText("60")
getglobal("PSFrscbuff_Timer2Low"):SetText("20")
PSFrscbuff_Timer2:SetMinMaxValues(20, 60)
PSFrscbuff_Timer2:SetValueStep(1)
PSFrscbuff_Timer2:SetValue(rscbufftimers[2])
	else
getglobal("rscmain5_Timer1High"):SetText("19")
getglobal("rscmain5_Timer1Low"):SetText("5")
rscmain5_Timer1:SetMinMaxValues(5, 19)
rscmain5_Timer1:SetValueStep(1)
rscmain5_Timer1:SetValue(rscbufftimers[1])

getglobal("rscmain5_Timer2High"):SetText("60")
getglobal("rscmain5_Timer2Low"):SetText("20")
rscmain5_Timer2:SetMinMaxValues(20, 60)
rscmain5_Timer2:SetValueStep(1)
rscmain5_Timer2:SetValue(rscbufftimers[2])
	end


for i=1,#rscspisokid do

	--checkbuttons
	local c = CreateFrame("CheckButton", nil, rscframetoshowall5, "OptionsCheckButtonTemplate")
	c:SetWidth("25")
	c:SetHeight("25")
	c:SetPoint("TOPLEFT", 220, -203-i*20)
	c:SetScript("OnClick", function(self) rsccheckbutchanged(i) end )
	table.insert(rsccheckbuttable, c)
	if rscbuffwhichtrack2[i]==1 then
		rsccheckbuttable[i]:SetChecked()
	else
		rsccheckbuttable[i]:SetChecked(false)
	end

	--image & text
	local ll=0
	local aaname=""

	for as=1,#rscspisokid[i] do
		local aaname2, _, aaicon2=GetSpellInfo(rscspisokid[i][as])
		if aaname2 then
		aaname=aaname..aaname2
		if as~=#rscspisokid[i] then
			aaname=aaname.." / "
		end


		local m = rscframetoshowall5:CreateTexture(nil,"OVERLAY")
		m:SetTexture(aaicon2)
		m:SetWidth(20)
		m:SetHeight(20)
		m:SetPoint("TOPLEFT",250+ll,-204-i*20)

		ll=ll+22
		end
	end
	ll=ll-22

	local t = rscframetoshowall5:CreateFontString()
	t:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	t:SetText(aaname)
	t:SetJustifyH("LEFT")
	t:SetPoint("TOPLEFT",275+ll,-209-i*20)



end --for i=1,#rscspisokid







end --рисования

rscshownicks3()
rscslider51()
rscslider52()

end

function rsceditframecreat(a,b,nr)
a:SetAutoFocus(false)
a:SetHeight(20)
a:SetWidth(190)
a:SetPoint("TOPLEFT", 20, b)
a:Show()
table.insert(rsceditboxtable,a)
a:SetScript("OnTabPressed", function(self) rscsavenicks3() if rsceditboxtable[nr+1] then rsceditboxtable[nr+1]:SetFocus() rsceditboxtable[nr+1]:HighlightText() else rsceditboxtable[1]:SetFocus() rsceditboxtable[1]:HighlightText() end end )
a:SetScript("OnEnterPressed", function(self) rscsavenicks3() rsceditboxtable[nr]:ClearFocus() end )
end


function rsccheckbutchanged(nr)
if rscbuffwhichtrack2[nr]==1 then rscbuffwhichtrack2[nr]=0 else rscbuffwhichtrack2[nr]=1 end
if rscbuffwhichtrack2[nr]==1 then
rsccheckbuttable[nr]:SetChecked()
else
rsccheckbuttable[nr]:SetChecked(false)
end
end

function rsccheckbutchanged5(nr)
if rscbuffcheckb2[nr]==1 then rscbuffcheckb2[nr]=0 else rscbuffcheckb2[nr]=1 end
if rscbuffcheckb2[nr]==1 then
rsccheckboxtabl5[nr]:SetChecked()
else
rsccheckboxtabl5[nr]:SetChecked(false)
end
	if nr==1 then
	if rscbuffcheckb2[1]==1 then
		rsctextaddnon:SetText("|cff00ff00"..rscparton3.."|r")
	else
		rsctextaddnon:SetText("|cffff0000"..rscparton3.."|r")
	end
	end
end


function openmenubuff1()

if not DropDownMenubuff1 then
CreateFrame("Frame", "DropDownMenubuff1", rscframetoshowall5, "UIDropDownMenuTemplate")
end

DropDownMenubuff1:ClearAllPoints()
DropDownMenubuff1:SetPoint("TOPLEFT", 23, -95)
DropDownMenubuff1:Show()

local items = bigmenuchatlistrsc

if psversion then
items = bigmenuchatlist
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenubuff1, self:GetID())

if psversion then

if self:GetID()>8 then
rscbuffschat[1]=psfchatadd[self:GetID()-8]
else
rscbuffschat[1]=bigmenuchatlisten[self:GetID()]
end

else
	if self:GetID()>8 then
	bigmenuchatrsc(1)
	else
	bigmenuchatrsc(self:GetID())
	end
rscbuffschat[1]=wherereporttempbigma
end

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

if psversion then

bigmenuchat2(rscbuffschat[1])
if bigma2num==0 then
rscbuffschat[1]=bigmenuchatlisten[1]
bigma2num=1
end

else

bigmenuchatrsc2(rscbuffschat[1])
if bigma2num==0 then
rscbuffschat[1]="raid"
bigma2num=1
end

end

UIDropDownMenu_Initialize(DropDownMenubuff1, initialize)
UIDropDownMenu_SetWidth(DropDownMenubuff1, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenubuff1, 125)
UIDropDownMenu_SetSelectedID(DropDownMenubuff1,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenubuff1, "LEFT")
end


function openmenubuff2()

if not DropDownMenubuff2 then
CreateFrame("Frame", "DropDownMenubuff2", rscframetoshowall5, "UIDropDownMenuTemplate")
end

DropDownMenubuff2:ClearAllPoints()
DropDownMenubuff2:SetPoint("TOPLEFT", 23, -120)
DropDownMenubuff2:Show()

local items = bigmenuchatlistrsc

if psversion then
items = bigmenuchatlist
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenubuff2, self:GetID())

if psversion then

if self:GetID()>8 then
rscbuffschat[2]=psfchatadd[self:GetID()-8]
else
rscbuffschat[2]=bigmenuchatlisten[self:GetID()]
end

else
	if self:GetID()>8 then
	bigmenuchatrsc(1)
	else
	bigmenuchatrsc(self:GetID())
	end
rscbuffschat[2]=wherereporttempbigma
end

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

if psversion then

bigmenuchat2(rscbuffschat[2])
if bigma2num==0 then
rscbuffschat[2]=bigmenuchatlisten[1]
bigma2num=1
end

else

bigmenuchatrsc2(rscbuffschat[2])
if bigma2num==0 then
rscbuffschat[2]="raid"
bigma2num=1
end

end

UIDropDownMenu_Initialize(DropDownMenubuff2, initialize)
UIDropDownMenu_SetWidth(DropDownMenubuff2, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenubuff2, 125)
UIDropDownMenu_SetSelectedID(DropDownMenubuff2,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenubuff2, "LEFT")
end

function rscslider51()
	if psversion then
rscbufftimers[1] = PSFrscbuff_Timer1:GetValue()
	else
rscbufftimers[1] = rscmain5_Timer1:GetValue()
	end
rsctxttitlemain:SetText(rscbuffspart1.." |cff00ff00"..rscbufftimers[1].." "..rscsec.."|r "..rscbuffspart2.." |cff00ff00"..rscbufftimers[2].." "..rscsec.."|r "..rscbuffspart3)
end

function rscslider52()
	if psversion then
rscbufftimers[2] = PSFrscbuff_Timer2:GetValue()
	else
rscbufftimers[1] = rscmain5_Timer1:GetValue()
	end
rsctxttitlemain:SetText(rscbuffspart1.." |cff00ff00"..rscbufftimers[1].." "..rscsec.."|r "..rscbuffspart2.." |cff00ff00"..rscbufftimers[2].." "..rscsec.."|r "..rscbuffspart3)
end


function rscsavenicks3()
--saving names
for q=1,#rscspisokid do
	local rsctemptext2=""
	if rsceditboxtable[q]:GetText() and string.len(rsceditboxtable[q]:GetText())>1 then
		local rsctemptext=rsceditboxtable[q]:GetText().." "
		while string.len(rsctemptext)>1 do
			if (string.find(rsctemptext," ") and string.find(rsctemptext," ")==1) or (string.find(rsctemptext,"%.") and string.find(rsctemptext,"%.")==1) or (string.find(rsctemptext,",") and string.find(rsctemptext,",")==1) then

				rsctemptext=string.sub(rsctemptext,2)

			else
				local a1=string.find(rsctemptext," ")
				local a2=string.find(rsctemptext,",")
				local a3=string.find(rsctemptext,"%.")
				local min=1000
				if a1 and a1<min then
				min=a1
				end
				if a2 and a2<min then
				min=a2
				end
				if a3 and a3<min then
				min=a3
				end
				if min==1000 then
					rsctemptext=""
				else
					if string.len(rsctemptext2)>1 then
						rsctemptext2=rsctemptext2..", "
					end
					rsctemptext2=rsctemptext2..string.sub(rsctemptext,1,min-1)
					rsctemptext=string.sub(rsctemptext,min)

				end
			end
		end
	end
	rscwhomustbufflist[q]=rsctemptext2
end
rscshownicks3()
end

function rscshownicks3()
--show names
if rsceditboxtable then
for w=1,#rscspisokid do
	rsceditboxtable[w]:SetText(rscwhomustbufflist[w])
end
end
end


function rscbuffcheckprioritylist(nrbuf,whobuff,whatbuf,time,classs)
local nicktable={}
rscprioritytemp=nil
if rscwhomustbufflist[nrbuf] and string.len(rscwhomustbufflist[nrbuf])>1 then
local mystring=rscwhomustbufflist[nrbuf]..", ."
while string.len(mystring)>1 do
	if string.find(mystring, ", ") then
		table.insert(nicktable,string.sub(mystring,1,string.find(mystring, ", ")-1))
		mystring=string.sub(mystring,string.find(mystring, ", ")+2)
	else
		mystring=""
	end
end

if #nicktable>0 then
	for yyy=1,#nicktable do
		if UnitExists(nicktable[yyy]) then
local mnam=nicktable[yyy]
if string.len (mnam)>42 and string.find(mnam,"%-") then
  mnam=string.sub(mnam,1,string.find(mnam,"%-")-1)
end
		local _, englishClass = UnitClass(mnam)
		local bill=0
		if classs then
			if #classs>0 then
				for tr=1,#classs do
					if englishClass and englishClass==classs[tr] then
						bill=1
					end
				end
			end
		end

		if UnitInRaid(nicktable[yyy]) and UnitIsDeadOrGhost(nicktable[yyy])==nil and UnitAffectingCombat(nicktable[yyy]) and bill==0 then
			rscchatfiltimefunc()
				if classs then
			if UnitSex(whobuff) and UnitSex(whobuff)==3 then
				SendChatMessage("{rt4}"..whobuff.." - "..time.." "..rscsec..", "..rscreleasedtxt6f..": "..whatbuf.."!", "WHISPER", nil, nicktable[yyy])
			else
				SendChatMessage("{rt4}"..whobuff.." - "..time.." "..rscsec..", "..rscreleasedtxt6..": "..whatbuf.."!", "WHISPER", nil, nicktable[yyy])
			end
			rscprioritytemp=1
				else
			if UnitSex(whobuff) and UnitSex(whobuff)==3 then
				SendChatMessage("{rt3}"..whobuff.." "..rscreleasedtxt1f.." "..time.." "..rscsec.." "..rscreleasedtxt2..", "..rscreleasedtxt7f..": "..whatbuf.."!", "WHISPER", nil, nicktable[yyy])
			else
				SendChatMessage("{rt3}"..whobuff.." "..rscreleasedtxt1.." "..time.." "..rscsec.." "..rscreleasedtxt2..", "..rscreleasedtxt7..": "..whatbuf.."!", "WHISPER", nil, nicktable[yyy])
			end
			rscprioritytemp=1
				end
		end
		end
	end
end


end
end


function rscreportchatnobufs(chart,ttext)
rscchatsendreports(chart,ttext, " ", " ", " ", " ")
end

function rscreportchatbyname(name1,name2,time,buff,nr)
rscchatfiltimefunc()
if nr==1 then
if UnitSex(name1) and UnitSex(name1)==3 then
	SendChatMessage("{rt3}"..name1.." "..rscreleasedtxt1f.." "..time.." "..rscsec.." "..rscreleasedtxt2..", "..rscreleasedtxt7f..": "..buff.."!", "WHISPER", nil, name2)
else
	SendChatMessage("{rt3}"..name1.." "..rscreleasedtxt1.." "..time.." "..rscsec.." "..rscreleasedtxt2..", "..rscreleasedtxt7..": "..buff.."!", "WHISPER", nil, name2)
end
end
if nr==2 then
if UnitSex(name1) and UnitSex(name1)==3 then
	SendChatMessage("{rt4}"..name1.." - "..time.." "..rscsec..", "..rscreleasedtxt6f..": "..buff.."!", "WHISPER", nil, name2)
else
	SendChatMessage("{rt4}"..name1.." - "..time.." "..rscsec..", "..rscreleasedtxt6..": "..buff.."!", "WHISPER", nil, name2)
end
end
end