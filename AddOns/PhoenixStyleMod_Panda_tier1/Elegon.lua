psbossfilep35=1




function pscmrbossREPORTp351(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp35 and pswasonbossp35==1) then

	if pswasonbossp35==1 then
		pssetcrossbeforereport1=GetTime()
		

--проверяются на ком стаки остались
if pselegondeba1 and #pselegondeba1>0 then
  for i=1,#pselegondeba1 do
      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==pselegondeba1[i] then
            if pselegondeba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=pselegondeba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(pselegondeba1[i],pselegondeba2[i])
        vezaxsort2()
      end
  end
end


		if psraidoptionson[2][3][5][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id119722|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][5][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][3][5][2]==1 then
			strochkavezcrash=format(pszzpandaaddopttxt40,"|s4id117878|id").." ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][5][2]], true, vezaxname2, vezaxcrash2, 1)
		end




	end
	if pswasonbossp35==1 or (pswasonbossp35==2 and try==nil) then

		psiccsavinginf(psbossnames[2][3][5], try, pswasonbossp35)

		strochkavezcrash=psmainmdamagefrom.." |s4id119722|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=format(pszzpandaaddopttxt40,"|s4id117878|id").." ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp35=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp351(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp35=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

pselegmaxHPadd1=nil
psiccschet2=0

pselegondeba1=nil
pselegondeba2=nil
pselegondeba3=nil

pselegondebb1=nil
pselegondebb2=nil
pselegondebb3=nil
pselegondebb4=nil

pselegonwavenumber=nil

end
end





function pscombatlogbossp35(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==119722 then

  if pswasonbossp35==nil then
    pswasonbossp35=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp35~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][5],2)
  end
end



if arg2=="SPELL_AURA_APPLIED" and UnitName("boss1") and spellid==117870 then
  if pswasonbossp35==nil then
    pswasonbossp35=1
  end
end




--счет урона в аддов после 25%

if arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE" then
if arg12 then
local id=tonumber(string.sub(guid2,6,10),16)
if id==60793 then
  if pswasonbossp35==nil then
    pswasonbossp35=1
  end
    --получение инфо о хозяине если там пет, с учетом по маске
    local source=psgetpetownername(guid1, name1, flag1)
    pselegnamedamageadd1=name2
    pselegadddamage(1,source,guid2,arg12,arg13,spellid) --1 tip reporta
end
end
end


if arg2=="SWING_DAMAGE" then
if spellid then
local id=tonumber(string.sub(guid2,6,10),16)
if id==60793 then
    pselegnamedamageadd1=name2
    local source=psgetpetownername(guid1, name1, flag1)
    pselegadddamage(1,source,guid2,spellid,spellname,0)
end
end
end




if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==117878 and UnitName("boss1") then
  if pswasonbossp35==nil then
    pswasonbossp35=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp35~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    if pselegondeba1==nil then
      pselegondeba1={}--имя
      pselegondeba2={}--стаки
      pselegondeba3={}--время ласт обновления
    end
    local bil=0
    if #pselegondeba1>0 then
      for i=1,#pselegondeba1 do
        if pselegondeba1[i]==name2 then
          pselegondeba2[i]=arg13
          pselegondeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(pselegondeba1,name2)
      table.insert(pselegondeba2,arg13)
      table.insert(pselegondeba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==117878 and pselegondeba1 and UnitName("boss1") then
  for i=1,#pselegondeba1 do
    if pselegondeba1[i] and pselegondeba1[i]==name2 and pselegondeba2[i]>7 and pselegondeba3[i]+30>GetTime() then
      if pselegondebb1==nil then
        pselegondebb1={}--имя
        pselegondebb2={}--стаков
        pselegondebb3={}--время
        pselegondebb4={}--умер
      end

      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==pselegondeba1[i] then
            if pselegondeba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=pselegondeba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(pselegondeba1[i],pselegondeba2[i])
        vezaxsort2()
      end

      table.insert(pselegondebb1,pselegondeba1[i])
      table.insert(pselegondebb2,pselegondeba2[i])
      table.insert(pselegondebb3,GetTime()+1.5)
      table.insert(pselegondebb4,0)
      
      table.remove(pselegondeba1,i)
      table.remove(pselegondeba2,i)
      table.remove(pselegondeba3,i)
    end
  end
end      
      
if arg2=="UNIT_DIED" and pselegondebb1 and #pselegondebb1>0 then
  for i=1,#pselegondebb1 do
    if pselegondebb1[i]==name2 then
      pselegondebb4[i]=1
    end
  end
end

if arg2=="SPELL_AURA_APPLIED" and spellid==119387 then
  if pswasonbossp35==nil then
    pswasonbossp35=1
  end
  if pselegonwavenumber==nil then
    pselegonwavenumber=1
  end
end

if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==119387 then
  if pswasonbossp35==nil then
    pswasonbossp35=1
  end
  if pselegonwavenumber==nil then
    pselegonwavenumber=0
  end
  pselegonwavenumber=pselegonwavenumber+1
end


--урон в энергетический заряд
if pselegonwavenumber then
  if arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE" then
  pselegnamedamageadd2=name2
  if arg12 then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==60913 then
      --получение инфо о хозяине если там пет, с учетом по маске
      local source=psgetpetownername(guid1, name1, flag1)
      pselegadddamage(2,source,1000+pselegonwavenumber,arg12,arg13,spellid) --1 tip reporta
  end
  end
  end


  if arg2=="SWING_DAMAGE" then
  if spellid then
  pselegnamedamageadd2=name2
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==60913 then
      local source=psgetpetownername(guid1, name1, flag1)
      pselegadddamage(2,source,1000+pselegonwavenumber,spellid,spellname,0)
  end
  end
  end
end



end