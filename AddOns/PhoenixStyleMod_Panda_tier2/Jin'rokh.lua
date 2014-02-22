psbossfilep51=1




function pscmrbossREPORTp511(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp51 and pswasonbossp51==1) then

	if pswasonbossp51==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][1][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id137423|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][1][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][5][1][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id137905|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][1][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][5][1][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id137647|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][1][3]], true, vezaxname3, vezaxcrash3, 1)
		end



	end
	if pswasonbossp51==1 or (pswasonbossp51==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][1], try, pswasonbossp51)

		strochkavezcrash=psiccdmgfrom.." |s4id137423|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id137905|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id137647|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp51=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp511(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp51=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)


psjinsfera1=nil
psjinsfera2=nil


end
end



function pscombatlogbossp51(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
if UnitName("boss1") then




if arg2=="SPELL_DAMAGE" and spellid==137423 then

  if pswasonbossp51==nil then
    pswasonbossp51=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp51~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][1],2)
  end
end



if arg2=="SPELL_CAST_SUCCESS" and spellid==137399 and UnitName("boss1") then
if ps_saoptions[2][5][1][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
end



--средоточение молний трекер
if arg2=="SPELL_AURA_APPLIED" and spellid==137422 then
  if pswasonbossp51==nil then
    pswasonbossp51=1
  end
  if psjinsfera1==nil then
    psjinsfera1={} --name
    psjinsfera2={} --time start
  end
  local bil=0
  if #psjinsfera1>0 then
    for i=1,#psjinsfera1 do
      if psjinsfera1[i]==name2 then
        bil=1
        psjinsfera2[i]=GetTime()
      end
    end
  end
  if bil==0 then
    table.insert(psjinsfera1,name2)
    table.insert(psjinsfera2,GetTime())
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==137422 and #psjinsfera1>0 then
  for i=1,#psjinsfera1 do
    if psjinsfera1[i] and psjinsfera1[i]==name2 then
      local time=GetTime()-psjinsfera2[i]
      time=(math.ceil(time*10))/10
      pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." - "..time.." "..pssec, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][1],2)
      table.remove(psjinsfera1,i)
      table.remove(psjinsfera2,i)
    end
  end
end

if arg2=="SPELL_DAMAGE" and spellid==137507 then
  if pstimerimlos==nil or (pstimerimlos and GetTime()>pstimerimlos+1) then
    pstimerimlos=GetTime()
    pscaststartinfo(0,"|cffff0000"..spellname.."!!!|r", -1, "id1", 2, psiccdmgfrom.." |s4id137422|id - "..psinfo,psbossnames[2][5][1],2)
  end
end
if arg2=="SPELL_DAMAGE" and spellid==138990 then
    pscaststartinfo(0,"|cffff0000"..spellname.." >|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id137422|id - "..psinfo,psbossnames[2][5][1],2)
end



if arg2=="SPELL_DAMAGE" and spellid==137905 then

  if pswasonbossp51==nil then
    pswasonbossp51=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp51~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][1],2)
  end
end



if arg2=="SPELL_DAMAGE" and spellid==137647 then

  if pswasonbossp51==nil then
    pswasonbossp51=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp51~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][1],2)
  end
end


if arg2=="SPELL_DISPEL" and arg13==138732 then
  pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." ("..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1)..", "..spellname..")", -1, "id1", 5, "|s4id"..arg13.."|id - "..psinfo,psbossnames[2][5][1],2)
end

if arg2=="SPELL_DAMAGE" and spellid==138743 and name1 then
  psunitisplayer(guid2,name2)
  if psunitplayertrue then
      local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,"|cffff0000FAIL:|r "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > |cffff0000"..spellname.."|r > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 5, "|s4id138732|id - "..psinfo,psbossnames[2][5][1],2)
  end
end

if arg2=="SPELL_DAMAGE" and spellid==138733 and name1 then
  psunitisplayer(guid1,name1)
  if psunitplayertrue then
    psunitisplayer(guid2,name2)
    if psunitplayertrue then
      local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
      pscaststartinfo(0,"|cff00ff00FAIL:|r "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > |cffff0000"..spellname.."|r > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 5, "|s4id138732|id - "..psinfo,psbossnames[2][5][1],2)
    end
  end
end



end
end