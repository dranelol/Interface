psbossfilep512=1




function pscmrbossREPORTp5121(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp512 and pswasonbossp512==1) then

	if pswasonbossp512==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][12][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id136850|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][12][1]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp512==1 or (pswasonbossp512==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][12], try, pswasonbossp512)

		strochkavezcrash=psiccdmgfrom.." |s4id136850|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp512=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp5121(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp512=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)



end
end



function pscombatlogbossp512(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_DAMAGE" and spellid==136850 then

  if pswasonbossp512==nil then
    pswasonbossp512=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp512~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][12],2)
  end
end




end