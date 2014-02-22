psbossfilep41=1




function pscmrbossREPORTp411(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp41 and pswasonbossp41==1) then

	if pswasonbossp41==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][4][1][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id118003|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][4][1][1]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp41==1 or (pswasonbossp41==2 and try==nil) then

		psiccsavinginf(psbossnames[2][4][1], try, pswasonbossp41)

		strochkavezcrash=psmainmdamagefrom.." |s4id118003|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp41=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp411(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp41=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)

pspretectbufftodispell1=nil
pspretectbufftodispell2=nil
pspretectbufftodispell3=nil
pspretectbufftodispell4=nil
pspretectbufftodispell5=nil


end
end



function pscombatlogbossp41(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==118003 then

  if pswasonbossp41==nil then
    pswasonbossp41=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp41~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    

    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][4][1],2)
  end
end



if arg2=="SPELL_AURA_APPLIED" and spellid==111850 then
--сей анонсер
--if psiccinst and string.find(psiccinst,psiccheroic) then
if ps_saoptions[2][4][1][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
--end
end


--тюрьма!
if arg2=="SPELL_DAMAGE" and spellid==117398 and name1~=name2 then
  if pswasonbossp41==nil then
    pswasonbossp41=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp41~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][4][1],2)
  end
end


--сбсивание кастов
if arg2=="SPELL_CAST_START" and spellid==117187 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2.5, guid1, 3, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][4][1])
end

if arg2=="SPELL_CAST_START" and spellid==118312 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2.5, guid1, 4, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][4][1])
end



--бафф что нада диспелить
if arg2=="SPELL_AURA_APPLIED" and spellid==117283 and UnitName("boss1") then
  local id=tonumber(string.sub(guid2,6,10),16)
  if (id==60585 or id==60586 or id==60583) then
    --получаем ИД босса с минимальным ХП
    local bossid=0
    local hp=0
    if UnitName("boss1") then
      hp=UnitHealth("boss1")/UnitHealthMax("boss1")
      bossid=tonumber(string.sub(UnitGUID("boss1"),6,10),16)
    end
    if UnitName("boss2") then
      if hp~=0 and UnitHealth("boss2")/UnitHealthMax("boss2")<hp then
        hp=UnitHealth("boss2")/UnitHealthMax("boss2")
        bossid=tonumber(string.sub(UnitGUID("boss2"),6,10),16)
      end
    end
    if UnitName("boss3") then
      if hp~=0 and UnitHealth("boss3")/UnitHealthMax("boss3")<hp then
        hp=UnitHealth("boss3")/UnitHealthMax("boss3")
        bossid=tonumber(string.sub(UnitGUID("boss3"),6,10),16)
      end
    end
    if id==bossid then
  if pswasonbossp41==nil then
    pswasonbossp41=1
  end
    pscheckwipe1()
    if pswipetrue and pswasonbossp41~=2 then
      psiccwipereport_p1("wipe", "try")
    end
      pspretectbufftodispell1=name2 --имя
      pspretectbufftodispell2=GetTime() --время начала
      pspretectbufftodispell3=0 --снялось
      pspretectbufftodispell4=0 --кто снял
      pspretectbufftodispell5=0 --отлечено
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==117283 and UnitName("boss1") and pspretectbufftodispell1 and name2==pspretectbufftodispell1 then
  pspretectbufftodispell3=GetTime()
end

if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and arg12==117283 and pspretectbufftodispell1 and name2==pspretectbufftodispell1 then
  pspretectbufftodispell4=name1
end

if arg2=="SPELL_PERIODIC_HEAL" and spellid==117283 and pspretectbufftodispell1 and name2==pspretectbufftodispell1 then
  pspretectbufftodispell5=pspretectbufftodispell5+(arg12-arg13)
end

end