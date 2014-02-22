psbossfilep52=1




function pscmrbossREPORTp521(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp52 and pswasonbossp52==1) then

	if pswasonbossp52==1 then
		pssetcrossbeforereport1=GetTime()


--проверяются на ком стаки остались
if pshorrideba1 and #pshorrideba1>0 then
  for i=1,#pshorrideba1 do
      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==pshorrideba1[i] then
            if pshorrideba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=pshorrideba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(pshorrideba1[i],pshorrideba2[i])
        vezaxsort2()
      end
  end
end

		if psraidoptionson[2][5][2][2]==1 then
			strochkavezcrash=format(pszzpandattaddopttxt2,"|s4id136767|id").." ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][2][2]], true, vezaxname2, vezaxcrash2, 1)
		end

		if psraidoptionson[2][5][2][3]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id136739|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][2][2]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][5][2][4]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id136723|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][2][4]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][5][2][5]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id136646|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][2][5]], true, vezaxname4, vezaxcrash4, 1)
		end
		if psraidoptionson[2][5][2][6]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id136490|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][2][6]], true, vezaxname5, vezaxcrash5, 1)
		end



	end
	if pswasonbossp52==1 or (pswasonbossp52==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][2], try, pswasonbossp52)

		strochkavezcrash=psmainmgot.." |s4id119414|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)

		strochkavezcrash=psmainmdamagefrom.." |s4id136739|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id136723|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id136646|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id136490|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname5, vezaxcrash5, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp52=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp521(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp52=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)
table.wipe(vezaxname5)
table.wipe(vezaxcrash5)


pshorridondeba1=nil
pshorridondeba2=nil
pshorridondeba3=nil



end
end



function pscombatlogbossp52(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)




if arg2=="SPELL_DAMAGE" and (spellid==136739 or spellid==136740) then
  if pswasonbossp52==nil then
    pswasonbossp52=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp52~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

        local tt2=""
        tt2=", "..psdamageceil(arg12)
        if arg13 and arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][2],2)
  end
end



if arg2=="SPELL_DAMAGE" and spellid==136723 then
  if pswasonbossp52==nil then
    pswasonbossp52=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp52~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()

        local tt2=""
        tt2=", "..psdamageceil(arg12)
        if arg13 and arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][2],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==136646 then
  if pswasonbossp52==nil then
    pswasonbossp52=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp52~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables4(name2)
    vezaxsort4()

        local tt2=""
        tt2=", "..psdamageceil(arg12)
        if arg13 and arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][2],2)
  end
end



--стаки спадение
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==136767 and UnitName("boss1") then
  if pswasonbossp52==nil then
    pswasonbossp52=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp52~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if pshorrideba1==nil then
      pshorrideba1={}--имя
      pshorrideba2={}--стаки
      pshorrideba3={}--время ласт обновления
    end
    local bil=0
    if #pshorrideba1>0 then
      for i=1,#pshorrideba1 do
        if pshorrideba1[i]==name2 then
          pshorrideba2[i]=arg13
          pshorrideba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(pshorrideba1,name2)
      table.insert(pshorrideba2,arg13)
      table.insert(pshorrideba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==136767 and pshorrideba1 and UnitName("boss1") then
  for i=1,#pshorrideba1 do
    if pshorrideba1[i] and pshorrideba1[i]==name2 and pshorrideba2[i]>2 then --pshorrideba3[i]+30>GetTime() --90 сек но смысл?
      if pshorridebb1==nil then
        pshorridebb1={}--имя
        pshorridebb2={}--стаков
        pshorridebb3={}--время
        pshorridebb4={}--умер
      end

      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==pshorrideba1[i] then
            if pshorrideba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=pshorrideba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(pshorrideba1[i],pshorrideba2[i])
        vezaxsort2()
      end

      table.insert(pshorridebb1,pshorrideba1[i])
      table.insert(pshorridebb2,pshorrideba2[i])
      table.insert(pshorridebb3,GetTime()+1.5)
      table.insert(pshorridebb4,0)
      
      table.remove(pshorrideba1,i)
      table.remove(pshorrideba2,i)
      table.remove(pshorrideba3,i)
    end
  end
end      
      
if arg2=="UNIT_DIED" and pshorridebb1 and #pshorridebb1>0 then
  for i=1,#pshorridebb1 do
    if pshorridebb1[i]==name2 then
      pshorridebb4[i]=1
    end
  end
end


--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==136465 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][2])
end

if arg2=="SPELL_CAST_START" and spellid==136480 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 92, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][2])
end


if arg2=="SPELL_CAST_SUCCESS" and spellid==136797 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 30, guid1, 93, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][2])
end

if arg2=="SPELL_CAST_SUCCESS" and spellid==136587 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 94, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][2])
end



if arg2=="SPELL_DAMAGE" and spellid==136490 and UnitName("boss1") then
  if pswasonbossp52==nil then
    pswasonbossp52=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp52~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables5(name2)
    vezaxsort5()

        local tt2=""
        tt2=", "..psdamageceil(arg12)
        if arg13 and arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][2],2)
  end
end


if arg2=="SPELL_CAST_SUCCESS" and spellid==136769 and UnitName("boss1") then
if ps_saoptions[2][5][2][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 6, nil, nil)
end
end

end