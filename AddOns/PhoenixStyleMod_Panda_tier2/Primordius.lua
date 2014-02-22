psbossfilep58=1




function pscmrbossREPORTp581(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp58 and pswasonbossp58==1) then

	if pswasonbossp58==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][8][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id136247|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][8][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][5][8][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id136037|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][8][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][5][8][4]==1 then
			strochkavezcrash=pszzpandattaddopttxt14.." ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][8][4]], true, vezaxname3, vezaxcrash3, 1)
		end



	end
	if pswasonbossp58==1 or (pswasonbossp58==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][8], try, pswasonbossp58)

		strochkavezcrash=psiccdmgfrom.." |s4id136247|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id136037|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=pszzpandattaddopttxt14.." ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		
		psiccrefsvin()

	end




	if wipe then
		pswasonbossp58=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp581(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp58=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)

psbigaoeprimidstabletay1=nil
psbigaoeprimidstabletay2=nil
psbigaoeprimidstabletay3=nil
psstrazhiotstup222=nil

end
end



function pscombatlogbossp58(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_DAMAGE" and spellid==136247 then

  if pswasonbossp58==nil then
    pswasonbossp58=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp58~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][8],2)
  end
end



if arg2=="SPELL_DAMAGE" and spellid==136037 and (pstempname1==nil or (pstempname2 and GetTime()<pstempname2+5 and pstempname1 and name2~=pstempname1)) then

  if pswasonbossp58==nil then
    pswasonbossp58=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp58~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][8],2)
  end
end

if arg2=="SPELL_CAST_SUCCESS" and spellid==136037 then
  pstempname1=name2
  pstempname2=GetTime()
end



--не разделили урон
if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and spellid==136216 then
  local id=tonumber(string.sub(guid1,6,10),16)
  if id==69017 then
psunitisplayer(guid2,name2)
if psunitplayertrue then
  if psbigaoeprimidstabletay1==nil then
    psbigaoeprimidstabletay1={} --имя игрока по которому попало
    psbigaoeprimidstabletay2=GetTime() --время атаки (через 1.5 сек репорт)
    psbigaoeprimidstabletay3={} --список трупов от атаки
    
    if pswasonbossp58==nil then
      pswasonbossp58=1
    end

    pscheckwipe1()
    if pswipetrue and pswasonbossp58~=2 then
      psiccwipereport_p2("wipe", "try")
    end
  end
  local bil=0
  if #psbigaoeprimidstabletay1>0 then
    for i=1,#psbigaoeprimidstabletay1 do
      if psbigaoeprimidstabletay1[i]==name2 then
        bil=1
      end
    end
  end
  if bil==0 then
    table.insert(psbigaoeprimidstabletay1,name2)
  end
  if arg2=="SPELL_DAMAGE" and arg13 and arg13>=0 then
    --труп
    table.insert(psbigaoeprimidstabletay3,psnoservername(name2))
  end
end
  end
end


--трекер плохих дебафов:
if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_APPLIED_DOSE") and (spellid==136181 or spellid==136185 or spellid==136187 or spellid==136183) then
  if pswasonbossp58==nil then
    pswasonbossp58=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp58~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    
    addtotwotables3(name2)
    vezaxsort3()
    
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 3, pszzpandattaddopttxt14.." - "..psinfo,psbossnames[2][5][8],2)
  end
end

--диспел хороших
if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and (arg12==136184 or arg12==136186 or arg12==136182 or arg12==136180 or arg12==140546) then
  if pswasonbossp58==nil then
    pswasonbossp58=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." < "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." ("..spellname..")", -1, "id1", 4, pszzpandattaddopttxt14.." - "..psdispellinfo,psbossnames[2][5][8],2)
  end
end





end