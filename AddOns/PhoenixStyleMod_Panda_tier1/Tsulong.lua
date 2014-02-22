psbossfilep42=1




function pscmrbossREPORTp421(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp42 and pswasonbossp42==1) then

	if pswasonbossp42==1 then
		pssetcrossbeforereport1=GetTime()
		
		
		
--проверяются на ком стаки остались
if pstsulondeba1 and #pstsulondeba1>0 then
      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==pstsulondeba1[i] then
            if pstsulondeba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=pstsulondeba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(pstsulondeba1[i],pstsulondeba2[i])
        vezaxsort2()
      end
end
      

		if psraidoptionson[2][4][2][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122777|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][4][2][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][4][2][3]==1 then
			strochkavezcrash=format(pszzpandaaddopttxt40,"|s4id122768|id").." ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][4][2][3]], true, vezaxname2, vezaxcrash2, 1)
		end




	end
	if pswasonbossp42==1 or (pswasonbossp42==2 and try==nil) then

		psiccsavinginf(psbossnames[2][4][2], try, pswasonbossp42)

		strochkavezcrash=psmainmdamagefrom.." |s4id122777|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=format(pszzpandaaddopttxt40,"|s4id122768|id").." ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp42=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp421(wipe,try,reset,checkforwipe)

pstempblizzfix=GetTime()+60

if reset or wipe==nil then
pswasonbossp42=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

pstsulong1=nil
pstsulong2=nil
pstsulong3=nil
pstsulong4=nil


end
end



function pscombatlogbossp42(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==122777 then

  if pswasonbossp42==nil then
    pswasonbossp42=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp42~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    

    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][4][2],2)
  end
end





--мрачные тени
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==122768 and UnitName("boss1") then
  if pswasonbossp42==nil then
    pswasonbossp42=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp42~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    if pstsulondeba1==nil then
      pstsulondeba1={}--имя
      pstsulondeba2={}--стаки
      pstsulondeba3={}--время ласт обновления
    end
    local bil=0
    if #pstsulondeba1>0 then
      for i=1,#pstsulondeba1 do
        if pstsulondeba1[i]==name2 then
          pstsulondeba2[i]=arg13
          pstsulondeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(pstsulondeba1,name2)
      table.insert(pstsulondeba2,arg13)
      table.insert(pstsulondeba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==122768 and pstsulondeba1 and UnitName("boss1") then
  for i=1,#pstsulondeba1 do
    if pstsulondeba1[i] and pstsulondeba1[i]==name2 and pstsulondeba2[i]>4 and pstsulondeba3[i]+30>GetTime() then
      if pstsulondebb1==nil then
        pstsulondebb1={}--имя
        pstsulondebb2={}--стаков
        pstsulondebb3={}--время
        pstsulondebb4={}--умер
      end

      table.insert(pstsulondebb1,pstsulondeba1[i])
      table.insert(pstsulondebb2,pstsulondeba2[i])
      table.insert(pstsulondebb3,GetTime()+1.5)
      table.insert(pstsulondebb4,0)
      
      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==pstsulondeba1[i] then
            if pstsulondeba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=pstsulondeba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(pstsulondeba1[i],pstsulondeba2[i])
        vezaxsort2()
      end
      
      table.remove(pstsulondeba1,i)
      table.remove(pstsulondeba2,i)
      table.remove(pstsulondeba3,i)
    end
  end
end      

if arg2=="UNIT_DIED" and pstsulondebb1 and #pstsulondebb1>0 then
  for i=1,#pstsulondebb1 do
    if pstsulondebb1[i]==name2 then
      pstsulondebb4[i]=1
    end
  end
end


--запугивание
if arg2=="SPELL_AURA_APPLIED" and spellid==123012 then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62442 then
    pstsulong1=GetTime() --время начала
    pstsulong2=0 --конец
    pstsulong3=0 --урона нанесено
    pstsulong4=0 --кто снял
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==123012 and pstsulong2 then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62442 then
    pstsulong2=GetTime()
  end
end

if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==123012 and pstsulong2 then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62442 then
    pstsulong3=pstsulong3+(arg12-arg13)
  end
end

if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and arg12==123012 and pstsulong2 then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62442 then
    pstsulong4=name1
  end
end


end