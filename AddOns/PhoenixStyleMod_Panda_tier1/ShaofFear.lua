psbossfilep44=1




function pscmrbossREPORTp441(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp44 and pswasonbossp44==1) then

	if pswasonbossp44==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][4][4][1]==1 then
			strochkavezcrash=psmainmgot.." |s4id119414|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][4][4][1]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp44==1 or (pswasonbossp44==2 and try==nil) then

		psiccsavinginf(psbossnames[2][4][4], try, pswasonbossp44)

		strochkavezcrash=psmainmgot.." |s4id119414|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp44=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp441(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp44=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)



end
end



function pscombatlogbossp44(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_AURA_APPLIED" and spellid==119414 and name1~=name2 then

  if pswasonbossp44==nil then
    pswasonbossp44=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp44~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][4][4],2)
  end
end



if arg2=="SPELL_HEAL" and spellid==129190 then
  if pswasonbossp44==nil then
    pswasonbossp44=1
  end
  local heal=arg12
  if arg13 and arg13>0 then
    heal=heal-arg13
  end
  heal=psdamageceil(heal)
  pscaststartinfo(0,spellname..": |cffff0000-|r "..name2..": "..heal, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][4][4],2)
    if psraidoptionson[2][4][4][2]==1 and pswasonbossp24==1 and select(3,GetInstanceInfo())~=7 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][4][4][2]], "{rt8} |s4id"..spellid.."|id > "..name2..": "..heal)
    end
end

if arg2=="SPELL_DAMAGE" and spellid==129189 then
  if pswasonbossp44==nil then
    pswasonbossp44=1
  end
  pscaststartinfo(0,spellname..": |cff00ff00+|r "..name2, -1, "id1", 2, "|s4id129190|id - "..psinfo,psbossnames[2][4][4],2)
end


end