psbossfilep612=1




function pscmrbossREPORTp6121(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp612 and pswasonbossp612==1) then

	if pswasonbossp612==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][12][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143327|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][12][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][12][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144335|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][12][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][12][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144662|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][12][3]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][6][12][4]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144210|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][12][4]], true, vezaxname4, vezaxcrash4, 1)
		end
		if psraidoptionson[2][6][12][5]==1 then
			strochkavezcrash=psmainmgot.." |s4id143856|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][12][5]], true, vezaxname5, vezaxcrash5, 1)
		end
		

	end
	if pswasonbossp612==1 or (pswasonbossp612==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][12], try, pswasonbossp612)

		strochkavezcrash=psiccdmgfrom.." |s4id143327|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id144335|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id144662|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id144210|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id143856|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname5, vezaxcrash5, nil, nil,0,1)


		psiccrefsvin()

	end



	if wipe then
		pswasonbossp612=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp6121(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp612=nil


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

end
end



function pscombatlogbossp612(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
if UnitGUID("boss1") then


if arg2=="SPELL_DAMAGE" and spellid==143327 then
  if pswasonbossp612==nil then
    pswasonbossp612=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp612~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][12],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==144335 then
  if pswasonbossp612==nil then
    pswasonbossp612=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp612~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][12],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==144662 then
  if pswasonbossp612==nil then
    pswasonbossp612=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp612~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][12],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==144210 then
  if pswasonbossp612==nil then
    pswasonbossp612=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp612~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables4(name2)
    vezaxsort4()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][12],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==143385 then
  if pswasonbossp612==nil then
    pswasonbossp612=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp612~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 5, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][12],2)
  end
end



if (arg2=="SPELL_AURA_APPLIED_DOSE" or arg2=="SPELL_AURA_APPLIED") and spellid==143856 then
  if pswasonbossp612==nil then
    pswasonbossp612=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp612~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables5(name2)
    vezaxsort5()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 6, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][12],2)
  end
end





end
end