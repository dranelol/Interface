psbossfilep69=1




function pscmrbossREPORTp691(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp69 and pswasonbossp69==1) then

	if pswasonbossp69==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][9][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id142815|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][9][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][9][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id142816|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][9][3]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][9][4]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id142849|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][9][4]], true, vezaxname3, vezaxcrash3, 1)
		end
		

	end
	if pswasonbossp69==1 or (pswasonbossp69==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][9], try, pswasonbossp69)

		strochkavezcrash=psiccdmgfrom.." |s4id142815|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id142816|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id142849|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		
		psiccrefsvin()

	end




	if wipe then
		pswasonbossp69=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp691(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp69=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)


end
end



function pscombatlogbossp69(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)



if arg2=="SPELL_DAMAGE" and spellid==142815 then
  if pswasonbossp69==nil then
    pswasonbossp69=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp69~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][9],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==142849 then
  if pswasonbossp69==nil then
    pswasonbossp69=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp69~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    
    if pspanogmalrokcone1==nil then
      pspanogmalrokcone1={} -- кто получал урон
      pspanogmalrokcone2=GetTime()+2 --репорт
    end
    table.insert(pspanogmalrokcone1,name2)
    
    addtotwotables3(name2)
    vezaxsort3()
    
    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][9],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==142816 then
  if pswasonbossp69==nil then
    pswasonbossp69=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp69~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][9],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==143857 then
  if pswasonbossp69==nil then
    pswasonbossp69=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp69~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][9],2)
  end
end



end