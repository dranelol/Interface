psbossfilep65=1




function pscmrbossREPORTp651(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp65 and pswasonbossp65==1) then

	if pswasonbossp65==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][5][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id147824|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][5][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][5][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id147688|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][5][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][5][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id146769|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][5][2]], true, vezaxname3, vezaxcrash3, 1)
		end


	end
	if pswasonbossp65==1 or (pswasonbossp65==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][5], try, pswasonbossp65)

		strochkavezcrash=psiccdmgfrom.." |s4id147824|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id147688|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id146769|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp65=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp651(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp65=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)

end
end



function pscombatlogbossp65(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)




if arg2=="SPELL_DAMAGE" and spellid==147824 then
  if pswasonbossp65==nil then
    pswasonbossp65=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp65~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][5],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==147688 then
  if pswasonbossp65==nil then
    pswasonbossp65=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp65~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][5],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==146769 then
  if pswasonbossp65==nil then
    pswasonbossp65=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp65~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][5],2)
  end
end









end