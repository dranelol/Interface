psbossfilep59=1




function pscmrbossREPORTp591(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp59 and pswasonbossp59==1) then

	if pswasonbossp59==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][9][1]==1 then
			strochkavezcrash=psmainmgot.." |s4id139869|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][9][1]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp59==1 or (pswasonbossp59==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][9], try, pswasonbossp59)

		strochkavezcrash=psmainmgot.." |s4id139869|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp59=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp591(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp59=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)



end
end



function pscombatlogbossp59(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_INTERRUPT" and spellid==139869 then

  if pswasonbossp59==nil then
    pswasonbossp59=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp59~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." ("..arg13..")", -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][9],2)
  end
end




end