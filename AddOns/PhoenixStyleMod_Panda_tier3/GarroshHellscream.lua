psbossfilep614=1




function pscmrbossREPORTp6141(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp614 and pswasonbossp614==1) then

	if pswasonbossp614==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][14][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144650|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][14][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][14][2]==1 then
			--strochkavezcrash=psiccdmgfrom.." |s4id144969|id ("..psmainmtotal.."): "
			--reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][14][1]], true, vezaxname2, vezaxcrash2, 1)
		end


	end
	if pswasonbossp614==1 or (pswasonbossp614==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][14], try, pswasonbossp614)

		strochkavezcrash=psiccdmgfrom.." |s4id144650|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		--strochkavezcrash=psiccdmgfrom.." |s4id144969|id ("..psmainmtotal.."): "
		--reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp614=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp6141(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp614=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)


end
end



function pscombatlogbossp614(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18)



if arg2=="SPELL_DAMAGE" and spellid==144650 then
  if pswasonbossp614==nil then
    pswasonbossp614=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp614~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][14],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==144969 then
  if pswasonbossp614==nil then
    pswasonbossp614=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp614~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][14],2)
  end
end


if arg2=="SPELL_CAST_START" and spellid==144583 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][14])
end


--приглось добавить новые arg чтоб добраться до этого значения
if arg2=="SPELL_INTERRUPT" and arg12==145599 then
pscaststartinfo(0,arg13..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." ("..spellname..", SPELL_INTERRUPT)", -1, "id1", 62, "|s4id"..arg12.."|id - "..psinfo,psbossnames[2][6][14],2)
end
--11/25 21:11:47.663  SPELL_INTERRUPT,0x07800000026FFCD0,"Демонз-Галакронд",0x514,0x0,0x07800000043B3489,"Дайруссгун-Дракономор",0x1248,0x0,57994,"Пронизывающий ветер",0x8,0x0000000000000000,0,0,0,0,0,145599,"Касание И'Шараджа",32



end