psbossfilep613=1




function pscmrbossREPORTp6131(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp613 and pswasonbossp613==1) then

	if pswasonbossp613==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][13][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id142232|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][13][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][13][2]==1 then
			strochkavezcrash=psnotokdamage.." |s4id142950|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][13][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][13][3]==1 then
			strochkavezcrash=psnotokdamage.." |s4id143701|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][13][3]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][6][13][4]==1 then
			strochkavezcrash=psnotokdamage.." |s4id143240|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][13][4]], true, vezaxname4, vezaxcrash4, 1)
		end
		if psraidoptionson[2][6][13][5]==1 then
			strochkavezcrash=psnotokdamage.." |s4id142945|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][13][5]], true, vezaxname5, vezaxcrash5, 1)
		end
		if psraidoptionson[2][6][13][6]==1 then
			strochkavezcrash=psnotokdamage.." |s4id142803|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][13][6]], true, vezaxname6, vezaxcrash6, 1)
		end
		

	end
	if pswasonbossp613==1 or (pswasonbossp613==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][13], try, pswasonbossp613)

		strochkavezcrash=psiccdmgfrom.." |s4id142232|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psnotokdamage.." |s4id142950|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psnotokdamage.." |s4id143701|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=psnotokdamage.." |s4id143240|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)
		strochkavezcrash=psnotokdamage.." |s4id142945|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname5, vezaxcrash5, nil, nil,0,1)
		strochkavezcrash=psnotokdamage.." |s4id142803|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname6, vezaxcrash6, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp613=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp6131(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp613=nil


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
table.wipe(vezaxname6)
table.wipe(vezaxcrash6)

pscurrentcargmetl=nil


end
end



function pscombatlogbossp613(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)



if arg2=="SPELL_DAMAGE" and spellid==142232 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end



if arg2=="SPELL_AURA_APPLIED" and spellid==142649 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": |cff00ff00+|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==142649 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": |cffff0000-|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end

if arg2=="SPELL_AURA_APPLIED" and spellid==142948 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    pscurrentcargmetl=guid2
    pscaststartinfo(0,spellname..": |cff00ff00+|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==142950 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    local addtxt=""
    if pscurrentcargmetl and guid2==pscurrentcargmetl then
      addtxt=" (ok)"
    else
      addtotwotables2(name2)
      vezaxsort2()
    end
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2..addtxt, -1, "id1", 3, "|s4id142948|id - "..psinfo,psbossnames[2][6][13],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==143701 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end


if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_PERIODIC_DAMAGE") and spellid==143240 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables4(name2)
    vezaxsort4()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 5, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end



if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_PERIODIC_DAMAGE") and spellid==142945 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables5(name2)
    vezaxsort5()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 6, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end


if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_PERIODIC_DAMAGE") and spellid==142803 then
  if pswasonbossp613==nil then
    pswasonbossp613=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp613~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables6(name2)
    vezaxsort6()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 7, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][13],2)
  end
end







end