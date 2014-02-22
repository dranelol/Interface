psbossfilep55=1




function pscmrbossREPORTp551(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp55 and pswasonbossp55==1) then

	if pswasonbossp55==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][5][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id139909|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][5][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][5][5][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id139836|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][5][2]], true, vezaxname2, vezaxcrash2, 1)
		end




	end
	if pswasonbossp55==1 or (pswasonbossp55==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][5], try, pswasonbossp55)

		strochkavezcrash=psiccdmgfrom.." |s4id139909|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id139836|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp55=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp551(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp55=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

psmegeraa1=nil
psmegeraa2=nil
psmegeraa3=nil
psmegeraa4=nil

end
end



function pscombatlogbossp55(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==139909 then

  if pswasonbossp55==nil then
    pswasonbossp55=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp55~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][5],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==139836 then

  if pswasonbossp55==nil then
    pswasonbossp55=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp55~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][5],2)
  end
end


--угли кто снял
if arg2=="SPELL_AURA_APPLIED" and spellid==139822 then
  if pswasonbossp55==nil then
    pswasonbossp55=1
  end
    if psmegeraa1==nil then
      psmegeraa1={}
      psmegeraa2={}
      psmegeraa3={}
      psmegeraa4={}
    end
    psuglidelaylit=GetTime()+1
    local bil=0
    if #psmegeraa3>0 then
      for i=1,#psmegeraa3 do
        if psmegeraa3[i]==name2 then
          psmegeraa1[i]=GetTime()
          psmegeraa2[i]=0
          psmegeraa4[i]=0
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(psmegeraa1,GetTime()) --время начала
      table.insert(psmegeraa2,0) --конец
      table.insert(psmegeraa3,name2) --на ком повесилось
      table.insert(psmegeraa4,0) --кто снял
    end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==139822 and psmegeraa2 then
  if #psmegeraa3>0 then
    for i=1,#psmegeraa3 do
      if psmegeraa3[i]==name2 then
        psmegeraa2[i]=GetTime()
      end
    end
  end
end


if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and arg12==139822 and psmegeraa2 then
  if #psmegeraa3>0 then
    for i=1,#psmegeraa3 do
      if psmegeraa3[i]==name2 then
        psmegeraa4[i]=name1
      end
    end
  end
end



--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==140178 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][5])
end
if arg2=="SPELL_CAST_START" and spellid==140179 and UnitName("boss1") then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 92, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][5])
end


--SA
if arg2=="SPELL_AURA_APPLIED" and spellid==139822 and UnitName("boss1") then
if ps_saoptions[2][5][5][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
end


end