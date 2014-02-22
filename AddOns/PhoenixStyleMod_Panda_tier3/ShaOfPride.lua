psbossfilep64=1




function pscmrbossREPORTp641(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp64 and pswasonbossp64==1) then

	if pswasonbossp64==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][4][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144788|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][4][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][4][2]==1 then
			strochkavezcrash=pszzpandatuaddopttxt2.." (|s4id144358|id): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][4][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][4][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144911|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][4][3]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][6][4][4]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id147198|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][4][4]], true, vezaxname4, vezaxcrash4, 1)
		end


	end
	if pswasonbossp64==1 or (pswasonbossp64==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][4], try, pswasonbossp64)

		strochkavezcrash=psiccdmgfrom.." |s4id144788|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=pszzpandatuaddopttxt2.." (|s4id144358|id): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id144911|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id147198|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp64=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp641(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp64=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)

end
end



function pscombatlogbossp64(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)




if arg2=="SPELL_DAMAGE" and spellid==144788 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][4],2)
  end
end


--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==144379 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][4])
end



if arg2=="SPELL_AURA_APPLIED" and spellid==144351 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id"..spellid.."|id - "..psdispellinfo,psbossnames[2][6][4],2)
  end
end

if arg2=="SPELL_DISPEL" and arg12==144351 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,"|cff00ff00Dispel:|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." ("..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1)..", "..spellname..")", -1, "id1", 2, "|s4id"..arg12.."|id - "..psdispellinfo,psbossnames[2][6][4],2)
  end
end


if arg2=="SWING_DAMAGE" then


  
    local id=tonumber(string.sub(guid1,6,10),16)
    if id==71734 then
    psunitisplayer(guid2,name2)
    if psunitplayertrue then
      local spbuf=GetSpellInfo(144358)
      if UnitBuff(name2, spbuf) or UnitDebuff(name2, spbuf) then

        pscheckwipe1()
        if pswipetrue and pswasonbossp64~=2 then
          psiccwipereport_p3("wipe", "try")
        end
        addtotwotables2(name2)
        vezaxsort2()
        pscaststartinfo(0,"Melee damage: "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 3, "|s4id144358|id - "..psinfo,psbossnames[2][6][4],2)
      end
    end
    end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==144358 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][4],2)
  end
end



if arg2=="SPELL_DAMAGE" and spellid==144911 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][4],2)
  end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==145215 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": |cff00ff00+|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 5, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][4],2)
  end
end


if arg2=="SPELL_AURA_REMOVED" and spellid==145215 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": |cffff0000-|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 5, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][4],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==147198 then
  if pswasonbossp64==nil then
    pswasonbossp64=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp64~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables4(name2)
    vezaxsort4()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 6, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][4],2)
  end
end



end