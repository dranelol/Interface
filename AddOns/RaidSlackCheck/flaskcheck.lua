function rsccreateframeflasks()
if rsccreateframebafsvar2==nil then
rsccreateframebafsvar2=1

--txt main
	rscmaintxt1 = rscframetoshowall4:CreateFontString()
	rscmaintxt1:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	rscmaintxt1:SetText(rscflasktext1)
	rscmaintxt1:SetWidth(705)
	rscmaintxt1:SetHeight(60)
	rscmaintxt1:SetJustifyH("LEFT")
	rscmaintxt1:SetJustifyV("TOP")
	rscmaintxt1:SetPoint("TOPLEFT",15,-12)

--txt flaskinfo
	rscflaskout = rscframetoshowall4:CreateFontString()
	rscflaskout:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	rscflaskout:SetText(" ")
	rscflaskout:SetWidth(545)
	rscflaskout:SetHeight(255)
	rscflaskout:SetJustifyH("LEFT")
	rscflaskout:SetJustifyV("TOP")
	rscflaskout:SetPoint("TOPLEFT",180,-220)

--txt flask time info
	rscflaskout2 = rscframetoshowall4:CreateFontString()
	rscflaskout2:SetFont(GameFontNormal:GetFont(), 14)
	rscflaskout2:SetText(" ")
	rscflaskout2:SetJustifyH("CENTER")
	rscflaskout2:SetJustifyV("TOP")
	rscflaskout2:SetWidth(150)
	rscflaskout2:SetPoint("TOPLEFT",14,-242)

--txt autocheck
	local tt2 = rscframetoshowall4:CreateFontString()
	tt2:SetFont(GameFontNormal:GetFont(), 12)
	tt2:SetText(rscflasktext2)
	--tt2:SetWidth(705)
	--tt2:SetHeight(60)
	tt2:SetJustifyH("LEFT")
	tt2:SetJustifyV("TOP")
	tt2:SetPoint("TOPLEFT",30,-295) --82

--txt manual report
	local tt22 = rscframetoshowall4:CreateFontString()
	tt22:SetFont(GameFontNormal:GetFont(), 12)
	tt22:SetText(rscmanualsend)
	tt22:SetWidth(200)
	tt22:SetHeight(60)
	tt22:SetJustifyH("LEFT")
	tt22:SetJustifyV("BOTTOM")
	tt22:SetPoint("TOPLEFT",30,-350) --82

--txt not in some zones
	local tt3 = rscframetoshowall4:CreateFontString()
	tt3:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
	tt3:SetText("|cff00ff00"..rscaddonnotworkinz.."|r")
	--tt2:SetWidth(555)
	--tt2:SetHeight(60)
	tt3:SetJustifyH("LEFT")
	tt3:SetJustifyV("TOP")
	tt3:SetPoint("TOPLEFT",475,-116)


if psversion then
PSFrscflask_Button1:SetPoint("TOPLEFT",20,-260)
PSFrscflask_Button1:SetText(rscreloadbutton)
PSFrscflask_Button2:SetPoint("TOPLEFT",20,-445)
PSFrscflask_Button2:SetText(rscsend)
PSFrscflask_Buttonz1:SetText(rscbuttonztext1)
PSFrscflask_Buttonz2:SetText(rscbuttonztext2)
PSFrscflask_Buttonz3:SetText(rscbuttonztext3)
PSFrscflask_Buttonz4:SetText(rscbuttonztext4)
else
rscmain4_Button1:SetPoint("TOPLEFT",20,-260)
rscmain4_Button2:SetPoint("TOPLEFT",20,-445)
rscmain4_Button1:SetText(rscreloadbutton)
rscmain4_Button2:SetText(rscsend)
rscmain4_Buttonz1:SetText(rscbuttonztext1)
rscmain4_Buttonz2:SetText(rscbuttonztext2)
rscmain4_Buttonz3:SetText(rscbuttonztext3)
rscmain4_Buttonz4:SetText(rscbuttonztext4)
end

--sliders
	if psversion then
getglobal("PSFrscflask_minHigh"):SetText("10")
getglobal("PSFrscflask_minLow"):SetText("0")
PSFrscflask_min:SetMinMaxValues(0, 10)
PSFrscflask_min:SetValueStep(1)
PSFrscflask_min:SetValue(rscminflaskgood)

	else
getglobal("rscmain4_minHigh"):SetText("10")
getglobal("rscmain4_minLow"):SetText("0")
rscmain4_min:SetMinMaxValues(0, 10)
rscmain4_min:SetValueStep(1)
rscmain4_min:SetValue(rscminflaskgood)
	end

--3 chechbox and text
	local pii=-393
	local txttt={rsctablereptxt1,rsctablereptxt2,rsctablereptxt3,rsctablereptxt4}
	for hhb=1,4 do
		local rsccheckboxhhb = CreateFrame("CheckButton", nil, rscframetoshowall4, "OptionsCheckButtonTemplate")
		rsccheckboxhhb:SetWidth("25")
		rsccheckboxhhb:SetHeight("25")
		rsccheckboxhhb:SetPoint("TOPLEFT", 230, pii)
		rsccheckboxhhb:SetScript("OnClick", function(self) if rsctableannounce[hhb]==1 then rsctableannounce[hhb]=0 else rsctableannounce[hhb]=1 end end )
		if rsctableannounce[hhb]==1 then
			rsccheckboxhhb:SetChecked()
		else
			rsccheckboxhhb:SetChecked(false)
		end
	local t1 = rscframetoshowall4:CreateFontString()
	t1:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t1:SetText(txttt[hhb])
	t1:SetJustifyH("LEFT")
	t1:SetPoint("TOPLEFT",254,pii-6)
		pii=pii-20
	end


--7 checkbox
	rscflaskcheckbox3={}

	local pii=-72
	for ii=1,7 do
	local rsccheckbox1 = CreateFrame("CheckButton", nil, rscframetoshowall4, "OptionsCheckButtonTemplate")
	rsccheckbox1:SetWidth("25")
	rsccheckbox1:SetHeight("25")
	rsccheckbox1:SetPoint("TOPLEFT", 20, pii)
	rsccheckbox1:SetScript("OnClick", function(self) rsccheckflaskbutchanged3(ii) end )
		if rscflaskcheckb[ii]==1 then
			rsccheckbox1:SetChecked()
		else
			rsccheckbox1:SetChecked(false)
		end
	table.insert(rscflaskcheckbox3,rsccheckbox1)


		pii=pii-20

	end
	
	
	
	
	local rsccheckbox8 = CreateFrame("CheckButton", nil, rscframetoshowall4, "OptionsCheckButtonTemplate")
	rsccheckbox8:SetWidth("25")
	rsccheckbox8:SetHeight("25")
	rsccheckbox8:SetPoint("TOPLEFT", 370, -192)
	rsccheckbox8:SetScript("OnClick", function(self)
            	if rscflaskcheckfoodadd==1 then
                rscflaskcheckfoodadd=0
              else
                rscflaskcheckfoodadd=1
              end
            rscupdateflask()
         end )
		if rscflaskcheckfoodadd==1 then
			rsccheckbox8:SetChecked()
		else
			rsccheckbox8:SetChecked(false)
		end
	
	local rsccheckbox9 = CreateFrame("CheckButton", nil, rscframetoshowall4, "OptionsCheckButtonTemplate")
	rsccheckbox9:SetWidth("25")
	rsccheckbox9:SetHeight("25")
	rsccheckbox9:SetPoint("TOPLEFT", 560, -192)
	rsccheckbox9:SetScript("OnClick", function(self)
            	if rscflaskcheckfoodadd2==1 then
                rscflaskcheckfoodadd2=0
              else
                rscflaskcheckfoodadd2=1
              end
            rscupdateflask()
         end )
		if rscflaskcheckfoodadd2==1 then
			rsccheckbox9:SetChecked()
		else
			rsccheckbox9:SetChecked(false)
		end




--7 text

local atx={rscflasktextc11,rscflasktextc12,rscflasktextc13,rscflasktextc14,rscpartanons35}
for as=1,5 do
	local t1 = rscframetoshowall4:CreateFontString()
	t1:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	t1:SetText(atx[as])
	t1:SetJustifyH("LEFT")
	t1:SetPoint("TOPLEFT",44,-58-20*as)
end

	rscflaskt6 = rscframetoshowall4:CreateFontString()
	rscflaskt6:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	rscflaskt6:SetText(rscflasktextc15)
if rscflaskcheckb[6]==0 then
	rscflaskt6:SetText("|cffff0000"..rscflasktextc15.."|r")
end
	rscflaskt6:SetJustifyH("LEFT")
	rscflaskt6:SetPoint("TOPLEFT",44,-178)

	rscflaskt7 = rscframetoshowall4:CreateFontString()
	rscflaskt7:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	rscflaskt7:SetText(rscpartanons36)
if rscflaskcheckb[7]==0 then
	rscflaskt7:SetText("|cffff0000"..rscpartanons36.."|r")
end
	rscflaskt7:SetJustifyH("LEFT")
	rscflaskt7:SetPoint("TOPLEFT",44,-198)
	
	
	
	
	rscflasktfoodadd = rscframetoshowall4:CreateFontString()
	rscflasktfoodadd:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	rscflasktfoodadd:SetText(format(rscpartanonsfoodadd,"+275"))
	rscflasktfoodadd:SetJustifyH("LEFT")
	rscflasktfoodadd:SetPoint("TOPLEFT",394,-200)
	
	rscflasktfoodadd2 = rscframetoshowall4:CreateFontString()
	rscflasktfoodadd2:SetFont(GameFontNormal:GetFont(), rscfontsset[1])
	rscflasktfoodadd2:SetText(format(rscpartanonsfoodadd,"+250"))
	rscflasktfoodadd2:SetJustifyH("LEFT")
	rscflasktfoodadd2:SetPoint("TOPLEFT",584,-200)

openmenuflask1()
openmenuflask3()


end

rscsliderflaskchan()
rscupdateflask()

end

function rscsliderflaskchan()
	if psversion then
rscminflaskgood=math.floor(PSFrscflask_min:GetValue())
	else
rscminflaskgood=math.floor(rscmain4_min:GetValue())
	end

rscflaskout2:SetText("|cffff0000< "..rscminflaskgood.." "..rscmin.."|r")
if rscminflaskgood==0 then
rscmaintxt1:SetText(rscflasktext1)
else
rscmaintxt1:SetText(rscflasktext1.." "..format(rscflasktext1part2,rscminflaskgood))
end

end

function rsccheckflaskbutchanged3(nr)
if rscflaskcheckb[nr]==1 then rscflaskcheckb[nr]=0 else rscflaskcheckb[nr]=1 end

if rscflaskcheckb[nr]==1 then
rscflaskcheckbox3[nr]:SetChecked()
else
rscflaskcheckbox3[nr]:SetChecked(false)
end

if nr==6 then
	if rscflaskcheckb[6]==1 then
		rscflaskt6:SetText(rscflasktextc15)
	else
		rscflaskt6:SetText("|cffff0000"..rscflasktextc15.."|r")
	end
rscupdateflask()
end
if nr==7 then
	if rscflaskcheckb[7]==1 then
		rscflaskt7:SetText(rscpartanons36)
	else
		rscflaskt7:SetText("|cffff0000"..rscpartanons36.."|r")
	end
rscupdateflask()
end

end

function openmenuflask1()

if not DropDownMenuflask1 then
CreateFrame("Frame", "DropDownMenuflask1", rscframetoshowall4, "UIDropDownMenuTemplate")
end

DropDownMenuflask1:ClearAllPoints()
DropDownMenuflask1:SetPoint("TOPLEFT", 14, -311)--98
DropDownMenuflask1:Show()

local items = bigmenuchatlistrsc

if psversion then
items = bigmenuchatlist
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenuflask1, self:GetID())

if psversion then

if self:GetID()>8 then
rscflaskchat[1]=psfchatadd[self:GetID()-8]
else
rscflaskchat[1]=bigmenuchatlisten[self:GetID()]
end

else
	if self:GetID()>8 then
	bigmenuchatrsc(1)
	else
	bigmenuchatrsc(self:GetID())
	end
rscflaskchat[1]=wherereporttempbigma
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

bigmenuchat2(rscflaskchat[1])
if bigma2num==0 then
rscflaskchat[1]=bigmenuchatlisten[1]
bigma2num=1
end

else

bigmenuchatrsc2(rscflaskchat[1])
if bigma2num==0 then
rscflaskchat[1]="raid"
bigma2num=1
end

end

UIDropDownMenu_Initialize(DropDownMenuflask1, initialize)
UIDropDownMenu_SetWidth(DropDownMenuflask1, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenuflask1, 125)
UIDropDownMenu_SetSelectedID(DropDownMenuflask1,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenuflask1, "LEFT")
end


function openmenuflask3()

if not DropDownMenuflask3 then
CreateFrame("Frame", "DropDownMenuflask3", rscframetoshowall4, "UIDropDownMenuTemplate")
end

DropDownMenuflask3:ClearAllPoints()
DropDownMenuflask3:SetPoint("TOPLEFT", 14, -415)
DropDownMenuflask3:Show()

local items = bigmenuchatlistrsc

if psversion then
items = bigmenuchatlist
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenuflask3, self:GetID())

if psversion then

if self:GetID()>8 then
rscflaskchat[2]=psfchatadd[self:GetID()-8]
else
rscflaskchat[2]=bigmenuchatlisten[self:GetID()]
end

else
	if self:GetID()>8 then
	bigmenuchatrsc(1)
	else
	bigmenuchatrsc(self:GetID())
	end
rscflaskchat[2]=wherereporttempbigma
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

bigmenuchat2(rscflaskchat[2])
if bigma2num==0 then
rscflaskchat[2]=bigmenuchatlisten[1]
bigma2num=1
end

else

bigmenuchatrsc2(rscflaskchat[2])
if bigma2num==0 then
rscflaskchat[2]="raid"
bigma2num=1
end

end

UIDropDownMenu_Initialize(DropDownMenuflask3, initialize)
UIDropDownMenu_SetWidth(DropDownMenuflask3, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenuflask3, 125)
UIDropDownMenu_SetSelectedID(DropDownMenuflask3,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenuflask3, "LEFT")
end






--апрейд инфо о фласках

function rscupdateflask()
if GetNumGroupMembers() > 0 and UnitInRaid("player") then
local rscgropcheck=2
if select(3,GetInstanceInfo())==7 or select(3,GetInstanceInfo())==14 or GetRaidDifficultyID()==4 or GetRaidDifficultyID()==6 then
rscgropcheck=5
end

rscwillnotbechecked={} --не проверять ники!
rscwillcheckthem={} --проверять эти ники!
rscnofoodbuff={} --кто БЕЗ еды
rscnoflask={} --кто без фласок (среди них проверяем эли)
rsconlyoneelixir={}
--ыытест
rscoldflask={} --кто со старыми фласками

rscfoodexpitealmost=0 --чтобы не писало у кого есть еда, если у многих она заканчивается


local rscelixtabl1={}
local rscelixtabl2={}



--кого проверяю кого нет, делю по таблицам
for ii = 1,GetNumGroupMembers() do local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(ii)
	if (subgroup <= rscgropcheck) then
		if (online==nil or isDead or UnitIsDeadOrGhost(name)) then
			table.insert(rscwillnotbechecked,name)
		else
			table.insert(rscwillcheckthem,name)
		end
	end
end


--проверяю на еду
if #rscwillcheckthem>0 and rscflaskcheckb[6]==1 then
	for yy=1,#rscwillcheckthem do
		local byl=0

		for uu=1,#rscfoodtable do
			if UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscfoodtable[uu])) then
				local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscfoodtable[uu]))
				if spell_id==rscfoodtable[uu] then
          if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
            byl=100
            uu=100
          end
          if expirationTime and expirationTime-GetTime()<=rscminflaskgood*60 and expirationTime-GetTime()>60 then
            byl=math.ceil((expirationTime-GetTime())/60)
          end
        end
			end
		end
    --доп еда если активно
    if byl==0 and rscflaskcheckfoodadd and rscflaskcheckfoodadd==1 then
      for uu=1,#rscfoodtable_additional do
        if UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscfoodtable_additional[uu])) then
          local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscfoodtable_additional[uu]))
          if spell_id==rscfoodtable_additional[uu] then
            if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
              byl=100
              uu=100
            end
            if expirationTime and expirationTime-GetTime()<=rscminflaskgood*60 and expirationTime-GetTime()>60 then
              byl=math.ceil((expirationTime-GetTime())/60)
            end
          end
        end
      end
    end
    --доп еда если активно 2
    if byl==0 and rscflaskcheckfoodadd2 and rscflaskcheckfoodadd2==1 then
      for uu=1,#rscfoodtable_additional2 do
        if UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscfoodtable_additional2[uu])) then
          local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscfoodtable_additional2[uu]))
          if spell_id==rscfoodtable_additional2[uu] then
            if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
              byl=100
              uu=100
            end
            if expirationTime and expirationTime-GetTime()<=rscminflaskgood*60 and expirationTime-GetTime()>60 then
              byl=math.ceil((expirationTime-GetTime())/60)
            end
          end
        end
      end
    end
	if byl==0 and byl~=100 then
		if UnitAura(rscwillcheckthem[yy],GetSpellInfo(430)) or UnitAura(rscwillcheckthem[yy],GetSpellInfo(433)) then
			--персонаж ест
			byl=99
		end
	end
		if byl==0 then
			table.insert(rscnofoodbuff,rscwillcheckthem[yy])
		elseif byl==99 then
			table.insert(rscnofoodbuff,rscwillcheckthem[yy].." ("..rsceating..")")
		elseif byl~=100 then
			rscfoodexpitealmost=rscfoodexpitealmost+1
			table.insert(rscnofoodbuff,rscwillcheckthem[yy].." ("..byl..")")
		end
	end
end


--проверяю на фласки
if #rscwillcheckthem>0 then
	for yy=1,#rscwillcheckthem do
		local byl=0
		for uu=1,#rscflasktable do
			if UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscflasktable[uu])) then
				local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscflasktable[uu]))
				if spell_id==rscflasktable[uu] then
          if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
            byl=100
            uu=100
          end
          if expirationTime and expirationTime-GetTime()<=rscminflaskgood*60 and expirationTime-GetTime()>60 then
            byl=math.ceil((expirationTime-GetTime())/60)
          end
        end
			end
		end
		--ыытест
		local old=0
		if byl==0 then
		for uu2=1,#rscflasktableold do
			if UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscflasktableold[uu2])) then
				local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscwillcheckthem[yy],GetSpellInfo(rscflasktableold[uu2]))
				if spell_id==rscflasktableold[uu2] then
          if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
            old=100
            byl=100
          end
          if expirationTime and expirationTime-GetTime()<=rscminflaskgood*60 and expirationTime-GetTime()>60 then
            old=math.ceil((expirationTime-GetTime())/60)
            byl=100
          end
        end
			end
		end
		end
		if old>0 and old<100 then
			table.insert(rscoldflask,rscwillcheckthem[yy].." ("..old..")")
		elseif old==100 then
			table.insert(rscoldflask,rscwillcheckthem[yy])
		end

		if byl==0 then
			table.insert(rscnoflask,rscwillcheckthem[yy])
		elseif byl~=100 then
			table.insert(rscnoflask,rscwillcheckthem[yy].." ("..byl..")")
		end
	end
end

--проверяю на 1ый эль, тех кто без фласки
if #rscnoflask>0 then
	for yy=1,#rscnoflask do
		local byl=0
		for uu=1,#rscelixirtable1 do
			if UnitAura(rscnoflask[yy],GetSpellInfo(rscelixirtable1[uu])) then
				local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscnoflask[yy],GetSpellInfo(rscelixirtable1[uu]))
				if spell_id==rscelixirtable1[uu] then
          if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
            byl=1
            uu=100
          end
        end
			end
		end
		if byl==1 then
			table.insert(rscelixtabl1,rscnoflask[yy])
			table.insert(rscelixtabl2,1)
		end
	end
end

--проверяю на 2ый эль, тех кто без фласки
if #rscnoflask>0 then
	for yy=1,#rscnoflask do
		local byl=0
		for uu=1,#rscelixirtable2 do
			if UnitAura(rscnoflask[yy],GetSpellInfo(rscelixirtable2[uu])) then
				local _, _, _, _, _, _, expirationTime,_, _,_,spell_id = UnitAura(rscnoflask[yy],GetSpellInfo(rscelixirtable2[uu]))
				if spell_id==rscelixirtable2[uu] then
          if expirationTime==nil or (expirationTime and expirationTime-GetTime()>rscminflaskgood*60) or expirationTime==0 then
            byl=1
            uu=100
          end
        end
			end
		end
		if byl==1 then
			if #rscelixtabl1>0 then
				local byl2=0
				for rr=1,#rscelixtabl1 do
					if rscelixtabl1[rr]==rscnoflask[yy] then
						rscelixtabl2[rr]=2
						byl2=1
						rr=100
					end
				end
				if byl2==0 then
					table.insert(rscelixtabl1,rscnoflask[yy])
					table.insert(rscelixtabl2,1)
				end
			else
				table.insert(rscelixtabl1,rscnoflask[yy])
				table.insert(rscelixtabl2,1)
			end
		end
	end
end


--проверяю локал таблицы елей, у кого 2 - убираю с табл. без фласки, у кого 1 - в табл. только 1 эль
--rsconlyoneelixir
if #rscelixtabl2>0 then
	for gg=1,#rscelixtabl2 do
		if rscelixtabl2[gg] and (rscelixtabl2[gg]==2 or rscelixtabl2[gg]==1) then
			--ищем и удаляем игрока без фласки
			for pp=1,#rscnoflask do
				if rscnoflask[pp] and rscnoflask[pp]==rscelixtabl1[gg] then
					table.remove(rscnoflask,pp)
				end
			end
		end
		if rscelixtabl2[gg] and rscelixtabl2[gg]==1 then
			table.insert(rsconlyoneelixir,rscelixtabl1[gg])
		end
	end
end



table.sort(rscwillnotbechecked)
table.sort(rscnofoodbuff)
table.sort(rscnoflask)
table.sort(rscoldflask)
table.sort(rsconlyoneelixir)



--отображение инфо
if rscflaskout and rscframetoshowall4:IsShown() then
local stringa=""
local slak=0
local sringamode=rscflasktext3.." "..rscgropcheck.." "..rscflasktxtgroup2.."."
if rscgropcheck==5 then
sringamode=rscflasktext3.." "..rscgropcheck.." "..rscflasktxtgroup5.."."
end

--только 1 элик
if rscflaskcheckb[7]==1 then
if #rsconlyoneelixir>0 then
	stringa=stringa.."|cffff0000"..rscflasktext4.."|r ("..#rsconlyoneelixir.."): "
	for eda=1,#rsconlyoneelixir do
		if eda>1 then
			stringa=stringa..", "
		end
		rsccoloraddfunc(rsconlyoneelixir[eda])
		stringa=stringa..rsccolor1..rsconlyoneelixir[eda]..rsccolor2
	end
stringa=stringa.."\r\n"
end
end

--нет фласок
if #rscnoflask>0 then

if #rscnoflask==#rscwillcheckthem and #rscnoflask>6 then
stringa=stringa.."|cffff0000"..rscflasktext5.."|r ("..#rscnoflask.."): "..string.upper(rscflasktext6).."!\r\n"
else
	stringa=stringa.."|cffff0000"..rscflasktext5.."|r ("..#rscnoflask.."): "
	for eda=1,#rscnoflask do
		if eda>1 then
			stringa=stringa..", "
		end
		rsccoloraddfunc(rscnoflask[eda])

		local rname=""
		local rname2=""
		if string.find(rscnoflask[eda],"%(") then
			rname=string.sub(rscnoflask[eda],1,string.find(rscnoflask[eda],"%(")-2)
			rname2=string.sub(rscnoflask[eda],string.find(rscnoflask[eda],"%(")-1)
		else
			rname=rscnoflask[eda]
		end

		stringa=stringa..rsccolor1..rname..rsccolor2..rname2
	end
stringa=stringa.."\r\n"
end
end

--ыытест
--старые фласки
if #rscoldflask>0 then

	stringa=stringa.."|cffff0000"..rscflasktext555.."|r ("..#rscoldflask.."): "
	for eda=1,#rscoldflask do
		if eda>1 then
			stringa=stringa..", "
		end
		rsccoloraddfunc(rscoldflask[eda])

		local rname=""
		local rname2=""
		if string.find(rscoldflask[eda],"%(") then
			rname=string.sub(rscoldflask[eda],1,string.find(rscoldflask[eda],"%(")-2)
			rname2=string.sub(rscoldflask[eda],string.find(rscoldflask[eda],"%(")-1)
		else
			rname=rscoldflask[eda]
		end

		stringa=stringa..rsccolor1..rname..rsccolor2..rname2
	end
stringa=stringa.."\r\n"
end

--еда
if #rscwillcheckthem==#rscnofoodbuff and #rscwillcheckthem>6 then
--ни у кого нет еды
stringa=stringa.."|cffff0000"..rscflasktext7.."|r ("..#rscnofoodbuff.."): "..rscflasktext6.."!\r\n"

elseif #rscwillcheckthem-#rscnofoodbuff+rscfoodexpitealmost<=3 and #rscwillcheckthem>6 then
--зеленым есть еда
if #rscnofoodbuff>0 and rscflaskcheckb[6]==1 then
	local ukogoeda={}
	for gv=1,#rscwillcheckthem do
		table.insert(ukogoeda,rscwillcheckthem[gv])
	end
		for jj=1,#rscnofoodbuff do
			for kk=1,#ukogoeda do
				if ukogoeda[kk] and ukogoeda[kk]==rscnofoodbuff[jj] then
					table.remove(ukogoeda,kk)
					kk=100
				end
			end
		end

	stringa=stringa.."|cff00ff00"..rscflasktext8.."|r ("..#ukogoeda.."): "
	for eda=1,#ukogoeda do
		if eda>1 then
			stringa=stringa..", "
		end
		rsccoloraddfunc(ukogoeda[eda])
		stringa=stringa..rsccolor1..ukogoeda[eda]..rsccolor2
	end
stringa=stringa.."\r\n"
end
else
--красные нет еды
if #rscnofoodbuff>0 and rscflaskcheckb[6]==1 then
	stringa=stringa.."|cffff0000"..rscflasktext7.."|r ("..#rscnofoodbuff.."): "
	for eda=1,#rscnofoodbuff do
		if eda>1 then
			stringa=stringa..", "
		end
		rsccoloraddfunc(rscnofoodbuff[eda])

		local rname=""
		local rname2=""
		if string.find(rscnofoodbuff[eda],"%(") then
			rname=string.sub(rscnofoodbuff[eda],1,string.find(rscnofoodbuff[eda],"%(")-2)
			rname2=string.sub(rscnofoodbuff[eda],string.find(rscnofoodbuff[eda],"%(")-1)
		else
			rname=rscnofoodbuff[eda]
		end

		stringa=stringa..rsccolor1..rname..rsccolor2..rname2
	end
stringa=stringa.."\r\n"
end
end

--был ли слак
if string.len(stringa)>2 then
slak=1
end

--кого не проверяли
if #rscwillnotbechecked>0 then
	stringa=stringa.."|cffff0000"..rscflasktext9.."|r ("..#rscwillnotbechecked.."): "
	for eda=1,#rscwillnotbechecked do
		if eda>1 then
			stringa=stringa..", "
		end
		rsccoloraddfunc(rscwillnotbechecked[eda])
		stringa=stringa..rsccolor1..rscwillnotbechecked[eda]..rsccolor2
	end
end


if slak==0 then
if #rscwillcheckthem==0 then

else
	if rscflaskcheckb[6]==1 then
		stringa=rscflasktext10.."\r\n"..stringa
	else
		stringa=rscflasktext11.."\r\n"..stringa
	end
end
end

if #rscwillnotbechecked>4 and (#rscwillnotbechecked>=#rscwillcheckthem or #rscwillnotbechecked>10) then
rscflaskout:SetText(sringamode.."\r\n"..rscflasktext12)
else
rscflaskout:SetText(sringamode.."\r\n"..stringa)
end

end --if rscflaskout then

else --нет рейда
	if rscflaskout then
		rscflaskout:SetText(" ")
	end
end
end





function rscsendflaskmanual()
rscreportslackwithflask("manual", rscflaskchat[2])
end



function rscreportslackwithflask(manual,chat)
if GetNumGroupMembers() > 0 and UnitInRaid("player") then
rscupdateflask()

local stringa1=""
local stringa11=""
local stringa2=""
local stringa21=""
local stringa22=""
--ыытест
local stringatemp2=""
local stringatemp21=""
--
local stringa3=""
local stringa31=""
local stringa32=""
local stringa4=""
local stringa41=""
local slak=0

local whisper1={}
local whisper2={}

--еда

if #rscnofoodbuff>0 then
	for hv=1,#rscnofoodbuff do
		table.insert(whisper1,rscnofoodbuff[hv])
		if string.find(rscnofoodbuff[hv],"%(") then
			table.insert(whisper2,11)
		else
			table.insert(whisper2,1)
		end
	end
end



if #rscwillcheckthem==#rscnofoodbuff and #rscwillcheckthem>6 then
--ни у кого нет еды
stringa3=stringa3..rscflasktext7.." ("..#rscnofoodbuff.."): "..rscflasktext6.."!"
elseif #rscwillcheckthem-#rscnofoodbuff+rscfoodexpitealmost<=3 and #rscwillcheckthem>6 then
--есть еда
if #rscnofoodbuff>0 and rscflaskcheckb[6]==1 then
	local ukogoeda={}
	for gv=1,#rscwillcheckthem do
		table.insert(ukogoeda,rscwillcheckthem[gv])
	end
		for jj=1,#rscnofoodbuff do
			for kk=1,#ukogoeda do
				if ukogoeda[kk] and ukogoeda[kk]==rscnofoodbuff[jj] then
					table.remove(ukogoeda,kk)
					kk=100
				end
			end
		end

	stringa3=stringa3..rscflasktext8.." ("..#ukogoeda.."): "
	for eda=1,#ukogoeda do
		if eda>1 then
			stringa3=stringa3..", "
		end
		stringa3=stringa3..ukogoeda[eda]
	end
end
else
--нет еды
if #rscnofoodbuff>0 and rscflaskcheckb[6]==1 then
	stringa3=stringa3..rscflasktext7.." ("..#rscnofoodbuff.."): "
	for eda=1,#rscnofoodbuff do
		if string.len(stringa31)>230 then
			if eda>1 and string.len(stringa32)<2 then
				stringa31=stringa31..", "
			else
				stringa32=stringa32..", "
			end
			stringa32=stringa32..rscnofoodbuff[eda]
		elseif string.len(stringa3)>230 then
			if eda>1 and string.len(stringa31)<2 then
				stringa3=stringa3..", "
			else
				stringa31=stringa31..", "
			end
			stringa31=stringa31..rscnofoodbuff[eda]
		else
			if eda>1 then
				stringa3=stringa3..", "
			end
			stringa3=stringa3..rscnofoodbuff[eda]
		end
	end
end
end


--только 1 элик
if rscflaskcheckb[7]==1 then
if #rsconlyoneelixir>0 then
	stringa1=stringa1..rscflasktext4.." ("..#rsconlyoneelixir.."): "
	for eda=1,#rsconlyoneelixir do
		--whisper add
		if #whisper1>0 then
			byyl=0
			local nnnam=rsconlyoneelixir[eda]
if string.find(nnnam,"%(") then
nnnam=string.sub(nnnam,1,string.find(nnnam,"%(")-2)
end
			for qa=1,#whisper1 do
				if whisper1[qa]==nnnam then
					if whisper2[qa]==1 then
						whisper2[qa]=4
					elseif whisper2[qa]==11 then
						whisper2[qa]=44
					end
					byyl=1
					qa=100
				end
			end
			if byyl==0 then
				table.insert(whisper1,rsconlyoneelixir[eda])
				table.insert(whisper2,2)
			end
		else
				table.insert(whisper1,rsconlyoneelixir[eda])
				table.insert(whisper2,2)
		end


		if string.len(stringa1)>230 then
			if eda>1 and string.len(stringa11)<2 then
				stringa1=stringa1..", "
			else
				stringa11=stringa11..", "
			end
			stringa11=stringa11..rsconlyoneelixir[eda]
		else
			if eda>1 then
				stringa1=stringa1..", "
			end
			stringa1=stringa1..rsconlyoneelixir[eda]
		end
	end
end
end

--нет фласок
if #rscnoflask>0 then

	--whisper
	for ttt=1,#rscnoflask do
		if #whisper1>0 then
			byyl=0
			local nnnam=rscnoflask[ttt]
if string.find(nnnam,"%(") then
nnnam=string.sub(nnnam,1,string.find(nnnam,"%(")-2)
end

			for qa=1,#whisper1 do
				if whisper1[qa]==nnnam then
					if string.find(rscnoflask[ttt],"%(") then
						if whisper2[qa]==1 then
							whisper2[qa]=40
						elseif whisper2[qa]==11 then
							whisper2[qa]=56
						end
					else
						if whisper2[qa]==1 then
							whisper2[qa]=5
						elseif whisper2[qa]==11 then
							whisper2[qa]=55
						end
					end

					byyl=1
					qa=100
				end
			end
			if byyl==0 then
				table.insert(whisper1,rscnoflask[ttt])
				if string.find(rscnoflask[ttt],"%(") then
					table.insert(whisper2,33)
				else
					table.insert(whisper2,3)
				end
			end
		else
				table.insert(whisper1,rscnoflask[ttt])
				if string.find(rscnoflask[ttt],"%(") then
					table.insert(whisper2,33)
				else
					table.insert(whisper2,3)
				end
		end
	end


if #rscnoflask==#rscwillcheckthem and #rscnoflask>6 then
stringa1=stringa1..rscflasktext5.." ("..#rscnoflask.."): "..string.upper(rscflasktext6).."!"
else
	stringa2=stringa2..rscflasktext5.." ("..#rscnoflask.."): "
	for eda=1,#rscnoflask do
		if string.len(stringa21)>230 then
			if eda>1 and string.len(stringa22)<2 then
				stringa21=stringa21..", "
			else
				stringa22=stringa22..", "
			end
			stringa22=stringa22..rscnoflask[eda]
		elseif string.len(stringa2)>230 then
			if eda>1 and string.len(stringa21)<2 then
				stringa2=stringa2..", "
			else
				stringa21=stringa21..", "
			end
			stringa21=stringa21..rscnoflask[eda]
		else
			if eda>1 then
				stringa2=stringa2..", "
			end
			stringa2=stringa2..rscnoflask[eda]
		end
	end
end
end



--ыытест
--СТАРЫЕ ФЛАСКИ
if #rscoldflask>0 then

	stringatemp2=stringatemp2..rscflasktext555.." ("..#rscoldflask.."): "
	for eda=1,#rscoldflask do
		if string.len(stringatemp2)>230 then
			if eda>1 and string.len(stringatemp21)<2 then
				stringatemp2=stringatemp2..", "
			else
				stringatemp21=stringatemp21..", "
			end
			stringatemp21=stringatemp21..rscoldflask[eda]
		else
			if eda>1 then
				stringatemp2=stringatemp2..", "
			end
			stringatemp2=stringatemp2..rscoldflask[eda]
		end
	end
end
--


--был ли слак
if string.len(stringa1)>2 or string.len(stringa2)>2 or string.len(stringa3)>2 then
slak=1
end

--кого не проверяли
if #rscwillnotbechecked>0 then
	stringa4=stringa4..rscflasktext9.." ("..#rscwillnotbechecked.."): "
	for eda=1,#rscwillnotbechecked do
		if string.len(stringa4)>230 then
			if eda>1 and string.len(stringa41)<2 then
				stringa4=stringa4..", "
			else
				stringa41=stringa41..", "
			end
			stringa41=stringa41..rscwillnotbechecked[eda]
		else
			if eda>1 then
				stringa4=stringa4..", "
			end
			stringa4=stringa4..rscwillnotbechecked[eda]
		end
	end
end


if slak==0 then
if rscflaskcheckb[6]==1 then
stringa1=rscflasktext10
else
stringa1=rscflasktext11
end
end

if string.len(stringa1)>2 then
stringa1="RSC > "..stringa1
elseif string.len(stringa2)>2 then
stringa2="RSC > "..stringa2
elseif string.len(stringa3)>3 then
stringa3="RSC > "..stringa3
end


if manual=="manual" or (manual=="auto" and ((UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) or rscflaskcheckb[5]==1 or psfnopromrep) and (GetTime()>rscflaskdelayrep[2] or (GetTime()>rscflaskdelayrep[2]-37 and GetTime()<rscwasyellpull+4))) then
if manual=="auto" then
rscflaskdelayrep[2]=GetTime()+50
end

local canreport=0
if manual=="manual" then
canreport=1
end



	local byyyl=0
	if rscflaskchat[1]=="raid" or rscflaskchat[1]=="raid_warning" then
		if GetTime()-rscflaskimportchat2[2]>100 then
			byyyl=1
		end
	else
		local chatfound=0
		for t=1,#rscflaskimportchat1 do
			if rscflaskimportchat1[t]==rscflaskchat[1] then
				if GetTime()-rscflaskimportchat2[t]>100 then
					byyyl=1
				end
				chatfound=1
			end
		end
		if chatfound==0 then
			byyyl=1
		end
	end

	if byyyl==1 then
		canreport=1
	end



if canreport==1 then

if slak==0 and rscwasyellpull and GetTime()<rscwasyellpull+4 then
else
if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
SendAddonMessage("RSCaddon", "a50", "Instance_CHAT")
else
SendAddonMessage("RSCaddon", "a50", "RAID")
end
	if #rscwillnotbechecked>4 and (#rscwillnotbechecked>=#rscwillcheckthem or #rscwillnotbechecked>10) then
	rscchatsendreports(chat,"RSC > "..rscflasktext12)
	else
	--ыытест
	rscchatsendreports(chat,stringa1, stringa11, stringa2, stringa21, stringa22, stringatemp2, stringatemp21, stringa3, stringa31, stringa32, stringa4, stringa41)
	end
end

end
end

--whisper send
if rscflaskcheckb[4]==1 and GetTime()-rscflaskimportchat2[1]>100 and #whisper1>0 and manual=="auto" and ((UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) or rscflaskcheckb[5]==1 or psfnopromrep) and (GetTime()>rscflaskdelayrep[1] or (GetTime()>rscflaskdelayrep[1]-37 and GetTime()<rscwasyellpull+4)) then
rscflaskdelayrep[1]=GetTime()+50
rscchatfiltimefunc()

if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
SendAddonMessage("RSCaddon", "b50", "Instance_CHAT")
else
SendAddonMessage("RSCaddon", "b50", "RAID")
end
	for i=1,#whisper1 do

local name2=whisper1[i]

if string.find(name2,"%(") then
name2=string.sub(name2,1,string.find(name2,"%(")-2)
end


		if whisper2[i]==1 then
			local a=""
			if rsctableoffoodbegin and GetTime()<rsctableoffoodbegin+150 then
				a=" ("..rscfoodstillthere..")"
			end
			SendChatMessage(rscflaskwhisptxt1..a, "WHISPER", nil, name2)
		end
		if whisper2[i]==2 then
			SendChatMessage(rscflaskwhisptxt2, "WHISPER", nil, name2)
		end
		if whisper2[i]==3 then
			SendChatMessage(rscflaskwhisptxt3, "WHISPER", nil, name2)
		end
		if whisper2[i]==4 then
			SendChatMessage(rscflaskwhisptxt4, "WHISPER", nil, name2)
		end
		if whisper2[i]==5 then
			SendChatMessage(rscflaskwhisptxt5, "WHISPER", nil, name2)
		end
		if whisper2[i]==11 then
			local a=""
			if rsctableoffoodbegin and GetTime()<rsctableoffoodbegin+150 then
				a=" ("..rscfoodstillthere..")"
			end
			SendChatMessage(rscflaskwhisptxt11..a, "WHISPER", nil, name2)
		end
		if whisper2[i]==33 then
			SendChatMessage(rscflaskwhisptxt33, "WHISPER", nil, name2)
		end
		if whisper2[i]==40 then
			SendChatMessage(rscflaskwhisptxt40, "WHISPER", nil, name2)
		end
		if whisper2[i]==44 then
			SendChatMessage(rscflaskwhisptxt44, "WHISPER", nil, name2)
		end
		if whisper2[i]==55 then
			SendChatMessage(rscflaskwhisptxt55, "WHISPER", nil, name2)
		end
		if whisper2[i]==56 then
			SendChatMessage(rscflaskwhisptxt56, "WHISPER", nil, name2)
		end
	end
end


end
end

function rscflaskcheckgo(rscjustfortest)
--works ONLY IN THE RAID-INSTANCE! in white list and NOT IN LFR
local a1,a2=IsInInstance()
if select(3,GetInstanceInfo())==7 and rscjustfortest==nil then
--nothing
elseif a1 and a2 and a2=="raid" then

local mojn=1

SetMapToCurrentZone()
if #rscignorezone6[1]>0 then
	for ug=1,#rscignorezone6[1] do
		if rscignorezone6[1][ug]==GetCurrentMapAreaID() then
			rscignorezone6[2][ug]=GetRealZoneText()
			mojn=0
		end
	end
end

if mojn==0 then

local tttxt=UnitName("player")
	if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" or UnitName("player")=="Шурш" then
		tttxt="0"..tttxt
	end
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..tttxt
	end

local strtosend=""

if (GetTime()>rscflaskdelayrep[2] or (GetTime()>rscflaskdelayrep[2]-37 and GetTime()<rscwasyellpull+4)) and ((UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) or rscflaskcheckb[5]==1 or psfnopromrep) then

	local byl=0
	if rscflaskchat[1]=="raid" or rscflaskchat[1]=="raid_warning" then
		if GetTime()-rscflaskimportchat2[2]>100 then
			byl=1
		end
	else
		local chatfound=0
		for t=1,#rscflaskimportchat1 do
			if rscflaskimportchat1[t]==rscflaskchat[1] then
				if GetTime()-rscflaskimportchat2[t]>100 then
					byl=1
				end
				chatfound=1
			end
		end
		if chatfound==0 then
			byl=1
		end
	end


if byl==1 then
strtosend=strtosend.."wchat"..rscflaskchat[1].."+"
end
end


if (GetTime()>rscflaskdelayrep[1] or (GetTime()>rscflaskdelayrep[1]-37 and GetTime()<rscwasyellpull+4)) and ((UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) or rscflaskcheckb[5]==1 or psfnopromrep) and rscflaskcheckb[4]==1 then
	if GetTime()-rscflaskimportchat2[1]>100 then
		strtosend=strtosend.."whisp:yes!"
	end
end

if string.len(strtosend)>1 then
SendAddonMessage("RSCaddon", "1"..strtosend.."nyyyck"..tttxt, "RAID")
end

end
end
end


function rsccoloraddfunc(name)
if name then

if string.find(name,"%(") then
name=string.sub(name,1,string.find(name,"%(")-2)
end

local mnam=name
if string.len (mnam)>42 and string.find(mnam,"%-") then
  mnam=string.sub(mnam,1,string.find(mnam,"%-")-1)
end
local _, klass=UnitClass(mnam)
rsccolor1=""
rsccolor2=""
if rsccolornick and klass then
klass=string.lower(klass)

if klass=="warrior" then rsccolor1="|CFFC69B6D"
elseif klass=="deathknight" then rsccolor1="|CFFC41F3B"
elseif klass=="paladin" then rsccolor1="|CFFF48CBA"
elseif klass=="priest" then rsccolor1="|CFFFFFFFF"
elseif klass=="shaman" then rsccolor1="|CFF1a3caa"
elseif klass=="druid" then rsccolor1="|CFFFF7C0A"
elseif klass=="rogue" then rsccolor1="|CFFFFF468"
elseif klass=="mage" then rsccolor1="|CFF68CCEF"
elseif klass=="warlock" then rsccolor1="|CFF9382C9"
elseif klass=="hunter" then rsccolor1="|CFFAAD372"
elseif klass=="monk" then rsccolor1="|CFF00FF96"
end
rsccolor2="|r"


end
end
end

function rsczoneflaskch(nn)
--add
SetMapToCurrentZone()
if nn==1 then
	local rrr=0
	if #rscignorezone6[1]>0 then
		for i=1,#rscignorezone6[1] do
			if rscignorezone6[1][i]==GetCurrentMapAreaID() then
				rscignorezone6[2][i]=GetRealZoneText()
				rrr=1
			end
		end
	end
	if rrr==0 then
		table.insert(rscignorezone6[2],GetRealZoneText())
		table.insert(rscignorezone6[1],GetCurrentMapAreaID())
		out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport2.."|cff00ff00"..GetRealZoneText().."|r")
	else
		out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport7)
	end
end

--remove
if nn==2 then
	local rrr=0
	if #rscignorezone6[1]>0 then
		for i=1,#rscignorezone6[1] do
			if rscignorezone6[1][i]==GetCurrentMapAreaID() then
				rrr=1
				out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport3.."|cffff0000"..GetRealZoneText().."|r")
				table.remove(rscignorezone6[1],i)
				table.remove(rscignorezone6[2],i)
				i=1000
			end
		end
	end
	if rrr==0 then
		out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport8)
	end
end

--show
if nn==3 then
	local txt=""
	if #rscignorezone6[2]>0 then
		for i=1,#rscignorezone6[2] do
			txt=txt.."|cff00ff00"..rscignorezone6[2][i].."|r"
			if #rscignorezone6[2]>i then
				txt=txt..", "
			end
		end
	end
	if #rscignorezone6[2]==0 then
		out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport1.."|cffff0000"..rsczonereport6.."|r")
	else
		out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport1..txt)
	end
end

--remove all
if nn==4 then
if rscquickclicktimer and GetTime()<rscquickclicktimer+10 then
--удаляю
out ("|cff99ffffRaidSlackCheck|r - |cff00ff00 "..rsczonereport5.."|r")
table.wipe(rscignorezone6[1])
table.wipe(rscignorezone6[2])
else
--тыкни еще раз!
rscquickclicktimer=GetTime()
out ("|cff99ffffRaidSlackCheck|r - "..rsczonereport9)
end
end
end