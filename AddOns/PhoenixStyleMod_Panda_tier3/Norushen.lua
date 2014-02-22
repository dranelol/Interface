psbossfilep63=1




function pscmrbossREPORTp631(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp63 and pswasonbossp63==1) then

	if pswasonbossp63==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][3][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id145227|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][3][1]], true, vezaxname, vezaxcrash, 1)
		end



	end
	if pswasonbossp63==1 or (pswasonbossp63==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][3], try, pswasonbossp63)

		strochkavezcrash=psiccdmgfrom.." |s4id145227|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp63=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp631(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp63=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)


end
end



function pscombatlogbossp63(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)



if arg2=="SPELL_DAMAGE" and spellid==145227 then
  if pswasonbossp63==nil then
    pswasonbossp63=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp63~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][3],2)
  end
end


if arg2=="SPELL_AURA_APPLIED" and (spellid==144849 or spellid==144851 or spellid==144850) then
  if pswasonbossp63==nil then
    pswasonbossp63=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp63~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": |cff00ff00+|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "TESTS - "..psinfo,psbossnames[2][6][3],2)
  end
end
if arg2=="SPELL_AURA_REMOVED" and (spellid==144849 or spellid==144851 or spellid==144850) then
  if pswasonbossp63==nil then
    pswasonbossp63=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp63~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": |cffff0000-|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "TESTS - "..psinfo,psbossnames[2][6][3],2)
  end
end




end