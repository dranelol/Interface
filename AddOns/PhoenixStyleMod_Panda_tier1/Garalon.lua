psbossfilep23=1




function pscmrbossREPORTp231(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp23 and pswasonbossp23==1) then

	if pswasonbossp23==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][2][3][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id123120|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][3][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][2][3][2]==1 then
			strochkavezcrash=pssummon.." |s4id122774|id: "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][3][2]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][2][3][4]==1 and #vezaxname2>2 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122735|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][3][4]], true, vezaxname2, vezaxcrash2, 1)
		end




	end
	if pswasonbossp23==1 or (pswasonbossp23==2 and try==nil) then

		psiccsavinginf(psbossnames[2][2][3], try, pswasonbossp23)

		strochkavezcrash=psmainmdamagefrom.." |s4id123120|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=pssummon.." |s4id122774|id: "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id122735|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp23=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp231(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp23=nil


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



function pscombatlogbossp23(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==123120 then

  if pswasonbossp23==nil then
    pswasonbossp23=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp23~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    

    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][3],2)
  end
end


if (arg2=="SPELL_MISSED" or arg2=="SPELL_DAMAGE") and spellid==122735 then
  if pswasonbossp23==nil then
    pswasonbossp23=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp23~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    addtotwotables4(name2)
    vezaxsort4()
    if pswaitgaralontorep==nil then
      pswaitgaralontorep=GetTime()+1
    end
  end
end




end