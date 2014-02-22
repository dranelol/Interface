psbossfilep25=1




function pscmrbossREPORTp251(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp25 and pswasonbossp25==1) then

	if pswasonbossp25==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][2][5][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id121995|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][5][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][2][5][2]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122005|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][5][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][2][5][4]==1 and pstotalhealamber and pstotalhealamber>0 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122532|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][5][4]], true, vezaxname3, vezaxcrash3, 1)
			pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][5][4]], "|s4id122532|id "..pszzpandaaddopttxt4..": "..psdamageceil(pstotalhealamber).." "..psulhp, true)
		end
		if psraidoptionson[2][2][5][6]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122504|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][5][6]], true, vezaxname4, vezaxcrash4, 1)
		end
		if psraidoptionson[2][2][5][7]==1 then
			strochkavezcrash="FAIL |s4id122398|id ("..psmainmtotal.."): "
			local addtext=""
			if pstotaldmgbyexp then
        addtext=" "..pszzpandaaddopttxt17..": "..psdamageceil(pstotaldmgbyexp)
      end
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][5][7]], true, vezaxname5, vezaxcrash5, 1,nil,nil,nil,nil,addtext)
		end
		
			strochkadamageout=pszzpandaaddopttxt46..": "
			reportfromtridamagetables(psraidchats3[psraidoptionschat[2][2][5][8]],nil,1,true)


		if psraidoptionson[2][2][5][9]==1 then
			strochkavezcrash=pszzpandaaddopttxt48..": "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][5][9]], true, vezaxname6, vezaxcrash6, 1)
		end



	end
	if pswasonbossp25==1 or (pswasonbossp25==2 and try==nil) then

		psiccsavinginf(psbossnames[2][2][5], try, pswasonbossp25)

		strochkavezcrash=psmainmdamagefrom.." |s4id121995|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id122005|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id122532|id ("..psmainmtotal.."): "
		if pstotalhealamber and pstotalhealamber>0 then
      reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
      pszapuskanonsa("raid", "|s4id122532|id "..pszzpandaaddopttxt4..": "..psdamageceil(pstotalhealamber).." "..psulhp, true,nil,0,1)
    end
		strochkavezcrash=psmainmdamagefrom.." |s4id122504|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)
		strochkavezcrash="FAIL |s4id122398|id ("..psmainmtotal.."): "
		local addtext=""
		if pstotaldmgbyexp then
      addtext=" "..pszzpandaaddopttxt17..": "..psdamageceil(pstotaldmgbyexp)
    end
		reportafterboitwotab("raid", true, vezaxname5, vezaxcrash5, nil, nil,0,1,nil,addtext)
		
		strochkadamageout=pszzpandaaddopttxt46..": "
		reportfromtridamagetables("raid",nil,1,true,0,1)

		strochkavezcrash=pszzpandaaddopttxt48..": "
		reportafterboitwotab("raid", true, vezaxname6, vezaxcrash6, nil, nil,0,1)


    
		psiccrefsvin()

	end




	if wipe then
		pswasonbossp25=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp251(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp25=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)
table.wipe(vezaxname5)
table.wipe(vezaxcrash5)
table.wipe(vezaxname6)
table.wipe(vezaxcrash6)
pstotalhealamber=nil

psunsoktablbabah1=nil
psunsoktablbabah2=nil
psunsoktablbabah3=nil
psunsoktablbabah4=nil
psunsoktablbabah5=nil
pstotaldmgbyexp=nil

psunsoknohealthem1=nil
psunsoknohealthem2=nil

table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)

psunsokadddamagetrack1=nil
psunsokadddamagetrack2=nil
psunsokadddamagetrack3=nil


end
end



function pscombatlogbossp25(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)







if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12=="ABSORB")) and spellid==121995 and UnitName("boss1") then

  if pswasonbossp25==nil then
    pswasonbossp25=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp25~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    
    local tt2=""
    if arg2=="SPELL_DAMAGE" then
      tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    else
      tt2=", "
      if arg14 then
        tt2=tt2..psdamageceil(arg14).." "
      end
      if arg12 then
        tt2=tt2.."(|cffff0000("..arg12..")|r"
      end
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][5],2)
  end
end





if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12=="ABSORB")) and spellid==122005 and UnitName("boss1") then

  if pswasonbossp25==nil then
    pswasonbossp25=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp25~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    
    local tt2=""
    if arg2=="SPELL_DAMAGE" then
      tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    else
      tt2=", "
      if arg14 then
        tt2=tt2..psdamageceil(arg14).." "
      end
      if arg12 then
        tt2=tt2.."(|cffff0000("..arg12..")|r"
      end
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][5],2)
  end
end





if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_HEAL" or (arg2=="SPELL_MISSED" and arg12=="ABSORB")) and spellid==122532 and UnitName("boss1") then
  if pswasonbossp25==nil then
    pswasonbossp25=1
  end
  pscheckwipe1()
  if pswipetrue and pswasonbossp25~=2 then
    psiccwipereport_p1("wipe", "try")
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue or arg2=="SPELL_HEAL" then
    if psraidoptionson[2][2][5][3]==1 and pswasonbossp25==1 then
      --собираем инфу для репорта по ходу боя
      if psambertabltorep251==nil then
        psambertabltorep251={} --гуид слизней
        psambertabltorep252={} --кого ударило
        psambertabltorep253={} --суммарно отлечено
        psambertabltorep254={} --время репорта
      end
      local bil=0
      if #psambertabltorep251>0 then
        for i=1,#psambertabltorep251 do
          if psambertabltorep251[i]==guid1 then
            if arg2=="SPELL_HEAL" then
              local heal=arg12
              if arg13 and arg13>0 then
                heal=heal-arg13
              end
              psambertabltorep253[i]=psambertabltorep253[i]+heal
            else
              table.insert(psambertabltorep252[i],name2)
            end
            bil=1
          end
        end
      end
      if bil==0 then
        table.insert(psambertabltorep251,guid1)
        table.insert(psambertabltorep252,{})
        table.insert(psambertabltorep253,0)
        table.insert(psambertabltorep254,GetTime()+1.5)
        if arg2=="SPELL_HEAL" then
          local heal=arg12
          if arg13 and arg13>0 then
            heal=heal-arg13
          end
          psambertabltorep253[#psambertabltorep253]=heal
        else
          table.insert(psambertabltorep252[#psambertabltorep252],name2)
        end
      end
    end
    --зависимо от урона или хила выводим инфо в фрейм и сохраняем
    if arg2=="SPELL_HEAL" then
      local tt2=""
      local heal=arg12
      if arg13 and arg13>0 then
        heal=heal-arg13
      end
      tt2=tt2..psdamageceil(heal)

      pscaststartinfo(0,spellname..": |cffff0000"..pszzpandaaddopttxt4..":|r "..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][5],2)
      if pstotalhealamber==nil then
        pstotalhealamber=0
      end
      pstotalhealamber=pstotalhealamber+heal
    else
      local tt2=""
      if arg2=="SPELL_DAMAGE" then
        tt2=", "..psdamageceil(arg12)
        if arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
      else
        tt2=", "
        if arg14 then
          tt2=tt2..psdamageceil(arg14).." "
        end
        if arg12 then
          tt2=tt2.."(|cffff0000("..arg12..")|r"
        end
      end
      pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][5],2)
      addtotwotables3(name2)
      vezaxsort3()
    end
  end
end














--5
if arg2=="SPELL_CAST_START" and spellid==122398 and UnitName("boss1") then
  if pswasonbossp25==nil then
    pswasonbossp25=1
  end
  pscheckwipe1()
  if pswipetrue and pswasonbossp25~=2 then
    psiccwipereport_p1("wipe", "try")
  end
  --записывать в таблицу, если урон прошел хоть по кому тогда репорт
  if psunsoktablbabah1==nil then
    psunsoktablbabah1={} --имя
    psunsoktablbabah2={} --гуид
    psunsoktablbabah3={} --время начала каста
    psunsoktablbabah4={} --урон был?
    psunsoktablbabah5={} --досрочный репорт
  end
  table.insert(psunsoktablbabah1,name1)
  table.insert(psunsoktablbabah2,guid1)
  table.insert(psunsoktablbabah3,GetTime())
  table.insert(psunsoktablbabah4,0)
  table.insert(psunsoktablbabah5,0)
  --pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1), -1, "id1", 53, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][5],2)
  --if psraidoptionson[2][2][5][5]==1 and pswasonbossp25==1 then
  --  pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][5][5]], "{rt8} "..name1.." > |s4id"..spellid.."|id")
  --end
end

if arg2=="SPELL_DAMAGE" and spellid==122398 and psunsoktablbabah1 then
  for i=1,#psunsoktablbabah2 do
    if psunsoktablbabah2[i]==guid1 then
      local dmg=arg12-arg13
      psunsoktablbabah4[i]=psunsoktablbabah4[i]+dmg
      psunsoktablbabah5[i]=GetTime()+1
    end
  end
end




--6
if arg2=="SPELL_DAMAGE" and spellid==122504 and UnitName("boss1") then

  if pswasonbossp25==nil then
    pswasonbossp25=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp25~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables4(name2)
    vezaxsort4()
    
    local tt2=""
    tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 22, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][5],2)
  end
end


--кто лечил чара под дебафом
if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_REFRESH") and spellid==121949 and UnitName("boss1") then
  if psunsoknohealthem1==nil then
    psunsoknohealthem1={} --человек с баффом GUID
    psunsoknohealthem2={} --время наложения
    if pswasonbossp25==nil then
      pswasonbossp25=1
    end
  end
  local bil=0
  if #psunsoknohealthem1>0 then
    for i=1,#psunsoknohealthem1 do
      if psunsoknohealthem1[i]==guid2 then
        bil=1
        psunsoknohealthem2[i]=GetTime()
      end
    end
  end
  if bil==0 then
    table.insert(psunsoknohealthem1,guid2)
    table.insert(psunsoknohealthem2,GetTime())
  end
  if name1 then
    pscaststartinfo(0,psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." |cff00ff00>|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..": "..spellname, -1, "id1", 5, "|s4id121949|id - "..psinfo,psbossnames[2][2][5],2)
  else
    pscaststartinfo(0,"|cff00ff00>|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..": "..spellname, -1, "id1", 5, "|s4id121949|id - "..psinfo,psbossnames[2][2][5],2)
  end
  
end

if arg2=="SPELL_AURA_REMOVED" and spellid==121949 and UnitName("boss1") and psunsoknohealthem1 and #psunsoknohealthem1>0 then
  for i=1,#psunsoknohealthem1 do
    if psunsoknohealthem1[i] and psunsoknohealthem1[i]==guid2 then
      table.remove(psunsoknohealthem1,i)
      table.remove(psunsoknohealthem2,i)
    end
  end
end

--сам хил
--+счетчик ЧТОБЫ ВЫВЕСТИ В КОНЦЕ БОЯ

if arg2=="SPELL_HEAL" and name2 and psunsoknohealthem1 and #psunsoknohealthem1>0 then
  psunitisplayer(guid1,name1)
  if psunitplayertrue then
    for i=1,#psunsoknohealthem1 do
      if psunsoknohealthem1[i]==guid2 and psunsoknohealthem2[i]<GetTime()+30 then
        local more=""
        if arg13 and arg13>0 then
          more=", "..psoverhealed..": "..psdamageceil(arg13)
        end
        local heal=arg12-arg13
        pscaststartinfo(0,psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..": "..spellname.." ("..psdamageceil(heal)..more..")", -1, "id1", 5, "|s4id121949|id - "..psinfo,psbossnames[2][2][5],2)
        addtotridamagetables(name1, heal, 1)
        psdamagetritablsort1()
      end
    end
  end
end



--счетчик урона по чудищам
if arg2=="SPELL_AURA_APPLIED" and spellid==122370 then
  if psunsokadddamagetrack1==nil then
    psunsokadddamagetrack1={} --гуид игрока
    psunsokadddamagetrack2={} --номер для записи
    psunsokadddamagetrack3=0 --текущий номер
  end
  local bil=0
  psunsokadddamagetrack3=psunsokadddamagetrack3+1
  if #psunsokadddamagetrack1>0 then
    for i=1,#psunsokadddamagetrack1 do
      if psunsokadddamagetrack1[i]==guid2 then
        bil=1
        psunsokadddamagetrack2[i]=psunsokadddamagetrack3
      end
    end
  end
  if bil==0 then
    table.insert(psunsokadddamagetrack1,guid2)
    table.insert(psunsokadddamagetrack2,psunsokadddamagetrack3)
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==122370 and psunsokadddamagetrack1 and #psunsokadddamagetrack1>0 then
  for i=1,#psunsokadddamagetrack1 do
    if psunsokadddamagetrack1[i] and psunsokadddamagetrack1[i]==guid2 then
    
      --репорт
      if psraidoptionson[2][2][5][10]==1 then
        local ar3=pssichose5 or 3
        --if #pssidamageinf_title2[pssavedplayerpos][1]>0 then
        --  for ii=1,#psdragontabldamage1[1] do
        --    if psdragontabldamage1[1][ii]==guid2 then
        
              psdamagerep_p1(psraidchats3[psraidoptionschat[2][2][5][10]],pssavedplayerpos,1,psunsokadddamagetrack2[i],ar3,1,2,1, false)
              
        --    end
        --  end
        --end
      end
      
      table.remove(psunsokadddamagetrack1,i)
      table.remove(psunsokadddamagetrack2,i)
    end
  end
end


  if psunsokadddamagetrack1 and #psunsokadddamagetrack1>0 and (arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE") then
  if arg12 then
  for i=1,#psunsokadddamagetrack1 do
    if psunsokadddamagetrack1[i]==guid2 then
      --получение инфо о хозяине если там пет, с учетом по маске
      local source=psgetpetownername(guid1, name1, flag1)
      pselegadddamage(4,source,1000+psunsokadddamagetrack2[i],arg12,arg13,spellid,name2) --1 tip reporta
      addtotwotables6(source,arg12)
      vezaxsort6()
    end
  end
  end
  end


  if psunsokadddamagetrack1 and #psunsokadddamagetrack1>0 and arg2=="SWING_DAMAGE" then
  if spellid then
  for i=1,#psunsokadddamagetrack1 do
    if psunsokadddamagetrack1[i]==guid2 then
      local source=psgetpetownername(guid1, name1, flag1)
      pselegadddamage(4,source,1000+psunsokadddamagetrack2[i],spellid,spellname,0,name2)
      addtotwotables6(source,spellid)
      vezaxsort6()
    end
  end
  end
  end

if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and arg12==122784 and arg13 then
  pscaststartinfo(0,arg13..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." "..arg2.." > "..spellname, -1, "id1", 7, "|s4id"..arg12.."|id - "..psdispellinfo,psbossnames[2][2][5],2)
  
  if psraidoptionson[2][2][5][11]==1 and pswasonbossp25==1 then
    pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][5][11]], "{rt8} "..name1.." > "..name2.." |s4id"..spellid.."|id - |s4id"..arg12.."|id")
  end
  
end




end