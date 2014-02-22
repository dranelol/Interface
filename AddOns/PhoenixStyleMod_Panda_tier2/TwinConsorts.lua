psbossfilep511=1




function pscmrbossREPORTp5111(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp511 and pswasonbossp511==1) then

	if pswasonbossp511==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][11][1]==1 then
			strochkavezcrash=psmainmgot.." |s4id136722|id ("..pssec..", "..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][11][1]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp511==1 or (pswasonbossp511==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][11], try, pswasonbossp511)

		strochkavezcrash=psmainmgot.." |s4id136722|id ("..pssec..", "..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp511=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp5111(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp511=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)



end
end



function pscombatlogbossp511(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==136722 then

  if pswasonbossp511==nil then
    pswasonbossp511=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp511~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][11],2)
  end
end




end