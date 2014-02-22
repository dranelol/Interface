psbossfilep611=1




function pscmrbossREPORTp6111(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp611 and pswasonbossp611==1) then

	if pswasonbossp611==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][11][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id148143|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][11][1]], true, vezaxname, vezaxcrash, 1)
		end



	end
	if pswasonbossp611==1 or (pswasonbossp611==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][11], try, pswasonbossp611)

		strochkavezcrash=psiccdmgfrom.." |s4id148143|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp611=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp6111(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp611=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

psthokdetails1=nil
psthokdetails2=nil

end
end



function pscombatlogbossp611(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)




if arg2=="SPELL_DAMAGE" and spellid==148143 then
  if pswasonbossp611==nil then
    pswasonbossp611=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp611~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][11],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==143426 then
  if pswasonbossp611==nil then
    pswasonbossp611=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp611~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][11],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==143780 then
  if pswasonbossp611==nil then
    pswasonbossp611=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp611~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][11],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==143773 then
  if pswasonbossp611==nil then
    pswasonbossp611=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp611~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][11],2)
  end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==143445 then
  if pswasonbossp611==nil then
    pswasonbossp611=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp611~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    if psthokdetails1==nil then
      psthokdetails1={} --имя
      psthokdetails2={}
    end
    local bil=0
    for i=1,#psthokdetails1 do
      if psthokdetails1[i]==name2 then
        psthokdetails2[i]=GetTime()
        bil=1
      end
    end
    if bil==0 then
      table.insert(psthokdetails1,name2)
      table.insert(psthokdetails2,GetTime())
    end
  end
end


if arg2=="SPELL_AURA_REMOVED" and spellid==143445 and pswasonbossp611 then
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp611~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    if psthokdetails1 and #psthokdetails1>0 then
      for i=1,#psthokdetails1 do
        if psthokdetails1[i] and psthokdetails1[i]==name2 then
          local time=GetTime()-psthokdetails2[i]
          time=math.ceil(time*10)/10
          pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." > "..time.." "..pssec, -1, "id1", 5, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][11],2)
          table.remove(psthokdetails1,i)
          table.remove(psthokdetails2,i)
        end
      end
    end
  end
end

if arg2=="SPELL_CAST_SUCCESS" and spellid==32375 and pswasonbossp611 then
  pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > "..spellname, -1, "id1", 6, psdispellinfo.." - "..psinfo,psbossnames[2][6][11],2)
end
if arg2=="SPELL_DISPEL" and spellid==32375 and pswasonbossp611 then
  pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..": "..arg13, -1, "id1", 6, psdispellinfo.." - "..psinfo,psbossnames[2][6][11],2)
end


end