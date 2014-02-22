psbossfilep32=1




function pscmrbossREPORTp321(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp32 and pswasonbossp32==1) then

	if pswasonbossp32==1 then
		pssetcrossbeforereport1=GetTime()


		if psraidoptionson[2][3][2][1]==1 then
			strochkadamageout=psdidfriendlyf.." |s4id116434|id: "
			reportfromtridamagetables(psraidchats3[psraidoptionschat[2][3][2][1]],nil,1,true)
    end

		if psraidoptionson[2][3][2][2]==1 then
      strochkavezcrash=psmainmdamagefrom.." |s4id116793|id: "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][2][2]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][3][2][4]==1 then
      strochkavezcrash=pszzpandaaddopttxt12.." |s4id115856|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][2][4]], true, vezaxname2, vezaxcrash2, 1)
		end

	end
	if pswasonbossp32==1 or (pswasonbossp32==2 and try==nil) then

		psiccsavinginf(psbossnames[2][3][2], try, pswasonbossp32)


    strochkadamageout=psdidfriendlyf.." |s4id116434|id: "
		reportfromtridamagetables("raid",nil,1,true,0,1)

		strochkavezcrash=psmainmdamagefrom.." |s4id116793|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		
		strochkavezcrash=pszzpandaaddopttxt12.." |s4id115856|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end

  psnotcountafterfightforsec10=GetTime()+10


	if wipe then
		pswasonbossp32=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp321(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp32=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(psdamagename)
table.wipe(psdamagevalue)
table.wipe(psdamageraz)

psshielduptable1=nil
psshielduptable2=nil
psshielduptable3=nil

psshieldnrdrag=nil
psstrazhiotstup=nil

end
end



function pscombatlogbossp32(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if (arg2=="SPELL_DAMAGE" or (arg2=="SPELL_MISSED" and arg12=="ABSORB")) and spellid==116434 and (psnotcountafterfightforsec10==nil or (psnotcountafterfightforsec10 and GetTime()>psnotcountafterfightforsec10)) then
  if pswasonbossp32==nil then
    pswasonbossp32=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then
    psunitisplayer(guid1,name1)
    if psunitplayertrue then
      pscheckwipe1()
      if pswipetrue and pswasonbossp32~=2 then
        psiccwipereport_p1("wipe", "try")
      end
      --addtotwotables1(name1)
      --vezaxsort1(arg12)
      if arg2=="SPELL_DAMAGE" then
        addtotridamagetables(name1, arg12, 1)
      else
        addtotridamagetables(name1, arg14, 1)
      end
      psdamagetritablsort1()

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
          tt2=tt2.."(|cffff0000"..arg12.."|r)"
        end
      end
      pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." --> "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][2],2)
    end
  end
end







if arg2=="SPELL_DAMAGE" and spellid==116793 and UnitName("boss1") then
  if pswasonbossp32==nil then
    pswasonbossp32=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then
      pscheckwipe1()
      if pswipetrue and pswasonbossp32~=2 then
        psiccwipereport_p1("wipe", "try")
      end
      addtotwotables1(name2)
      vezaxsort1()

      local tt2=""
        tt2=", "..psdamageceil(arg12)
        if arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
      pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][2],2)
  end
end


--щит и урон от всяких абилок
if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_APPLIED_DOSE") and (spellid==115856 or spellid==116417 or spellid==27827) and UnitName("boss1") then --+резонанс чар
  if pswasonbossp32==nil then
    pswasonbossp32=1
  end
  pscheckwipe1()
  if pswipetrue and pswasonbossp32~=2 then
    psiccwipereport_p1("wipe", "try")
  end

  if spellid==115856 and (psshieldisup==nil or (psshieldisup and GetTime()>psshieldisup+10)) then
    psshieldisup=GetTime() --6 сек щит АП
    if psshieldnrdrag==nil then
      psshieldnrdrag=0
    end
    psshieldnrdrag=psshieldnrdrag+1
  end
  if psshielduptable1==nil then
    psshielduptable1={} --имя
    psshielduptable2={} --щит
    psshielduptable3={} --ласт обновление
  end
  local bil=0
  if #psshielduptable1>0 then
    for i=1,#psshielduptable1 do
      if psshielduptable1[i]==name2 then
        psshielduptable2[i]=1
        psshielduptable3[i]=GetTime()
        bil=1
      end
    end
  end
  if bil==0 then
    table.insert(psshielduptable1,name2)
    table.insert(psshielduptable2,1)
    table.insert(psshielduptable3,GetTime())
  end
end

if arg2=="SPELL_AURA_REMOVED" and (spellid==115856 or spellid==116417 or spellid==27827) then
  if psshielduptable1 and #psshielduptable1>0 then
    for i=1,#psshielduptable1 do
      if psshielduptable1[i] and psshielduptable1[i]==name2 then
        psshielduptable2[i]=0
      end
    end
  end
end

if arg2=="SPELL_DAMAGE" and (spellid==116365 or spellid==116040) and UnitName("boss1") then
  --есть щит?
  if psshieldisup and GetTime()<=psshieldisup+6 then
    local bil=0
    if psshielduptable1 and #psshielduptable1>0 then
      for i=1,#psshielduptable1 do
        if psshielduptable1[i]==name2 and psshielduptable2[i]==1 and GetTime()<psshielduptable3[i]+6 then
          bil=1
        end
      end
    end
    if bil==0 then

      --фейл игрока
      addtotwotables2(name2)
      vezaxsort2()
      
      --по ходу боя
      addtotwotables3(name2)
      vezaxsort3()
    end
  end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==116784 and UnitName("boss1") then
--сей анонсер
--if psiccinst and string.find(psiccinst,psiccheroic) then
if ps_saoptions[2][3][2][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
--end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==116417 and UnitName("boss1") then
--сей анонсер
--if psiccinst and string.find(psiccinst,psiccheroic) then
if ps_saoptions[2][3][2][2]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 10, nil, nil)
end
--end
end


end