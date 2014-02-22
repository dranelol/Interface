psbossfilep53=1




function pscmrbossREPORTp531(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp53 and pswasonbossp53==1) then

	if pswasonbossp53==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][3][1]==1 then
			strochkavezcrash=psmainmgot.." |s4id137133|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][3][1]], true, vezaxname, vezaxcrash, 1)
		end

		if psraidoptionson[2][5][3][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id136917|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][3][3]], true, vezaxname2, vezaxcrash2, 1)
		end



	end
	if pswasonbossp53==1 or (pswasonbossp53==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][3], try, pswasonbossp53)

		strochkavezcrash=psmainmgot.." |s4id137133|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id136917|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp53=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp531(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp53=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)

table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

psiccschet2=0
psiccschet3=0


pshertrackdeba1=nil
pshertrackdeba2=nil
pshertrackdeba3=nil

pshcouncildebb1=nil
pshcouncildebb2=nil
pshcouncildebb3=nil
pshcouncildebb4=nil

pshcouncildeba1=nil
pshcouncildeba2=nil
pshcouncildeba3=nil

pshertrackdeboff1=nil
pshertrackdeboff2=nil


psdebtoheal1=nil
psdebtoheal2=nil
psdebtoheal3=nil

end
end



function pscombatlogbossp53(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
if UnitName("boss1") or UnitName("boss2") or UnitName("boss3") then




if arg2=="SPELL_DAMAGE" and spellid==137133 and name1~=name2 then

  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp53~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][3],2)
  end
end






--стаки спадение
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==136903 then
  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp53~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if pshcouncildeba1==nil then
      pshcouncildeba1={}--имя
      pshcouncildeba2={}--стаки
      pshcouncildeba3={}--время ласт обновления
    end
    local bil=0
    if #pshcouncildeba1>0 then
      for i=1,#pshcouncildeba1 do
        if pshcouncildeba1[i]==name2 then
          pshcouncildeba2[i]=arg13
          pshcouncildeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(pshcouncildeba1,name2)
      table.insert(pshcouncildeba2,arg13)
      table.insert(pshcouncildeba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==136767 and pshcouncildeba1 then
  for i=1,#pshcouncildeba1 do
    if pshcouncildeba1[i] and pshcouncildeba1[i]==name2 and pshcouncildeba2[i]>2 then --pshcouncildeba3[i]+30>GetTime() --90 сек но смысл?
      if pshcouncildebb1==nil then
        pshcouncildebb1={}--имя
        pshcouncildebb2={}--стаков
        pshcouncildebb3={}--время
        pshcouncildebb4={}--умер
      end

      table.insert(pshcouncildebb1,pshcouncildeba1[i])
      table.insert(pshcouncildebb2,pshcouncildeba2[i])
      table.insert(pshcouncildebb3,GetTime()+1.5)
      table.insert(pshcouncildebb4,0)
      
      table.remove(pshcouncildeba1,i)
      table.remove(pshcouncildeba2,i)
      table.remove(pshcouncildeba3,i)





      --без репорта сразу запись
        local text=": "..psaddcolortxt(1,pshcouncildebb1[1])..pshcouncildebb1[1]..psaddcolortxt(2,pshcouncildebb1[1])..", "
        if pshcouncildebb2[1]<10 then
          text=text..psstacks..": "..pshcouncildebb2[1].."."
        elseif pshcouncildebb2[1]<13 then
          text=text.."|cff00ff00"..psstacks..": "..pshcouncildebb2[1]..".|r"
        elseif pshcouncildebb2[1]<15 then
          text=text.."|CFFFFFF00"..psstacks..": "..pshcouncildebb2[1]..".|r"
        else
          text=text.."|cffff0000"..psstacks..": "..pshcouncildebb2[1]..".|r"
        end
        if pshcouncildebb4[1]==1 then
          text=text.." |cffff0000("..psdied..")|r"
        end  

        pscaststartinfo(0,GetSpellInfo(136767)..text, -1, "id1", 81, "|s4id136767|id - "..pszzpandattaddopttxt3,psbossnames[2][5][3],2)
        
        table.remove(pshcouncildebb1,1)
        table.remove(pshcouncildebb2,1)
        table.remove(pshcouncildebb3,1)
        table.remove(pshcouncildebb4,1)
    end
  end
end



--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==136189 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][3])
end
if arg2=="SPELL_CAST_START" and spellid==137344 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 92, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][3])
end
if arg2=="SPELL_CAST_START" and spellid==137347 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 93, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][5][3])
end





--счет урона в аддов
if arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE" then
if arg12 then
local id=tonumber(string.sub(guid2,6,10),16)
if id==69480 or id==69491 or id==69492 then
  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
    --получение инфо о хозяине если там пет, с учетом по маске
    local source=psgetpetownername(guid1, name1, flag1)
    pscduhnamedamageadd1=name2
    pscduhadddamage(1,source,guid2,arg12,arg13,spellid) --1 tip reporta
end
if id==69553 or id==69548 or id==69556 then
  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
    --получение инфо о хозяине если там пет, с учетом по маске
    local source=psgetpetownername(guid1, name1, flag1)
    pscduhnamedamageadd2=name2
    pscduhadddamage(2,source,guid2,arg12,arg13,spellid) --1 tip reporta
end
end
end


if arg2=="SWING_DAMAGE" then
if spellid then
local id=tonumber(string.sub(guid2,6,10),16)
if id==69480 or id==69491 or id==69492 then
    pscduhnamedamageadd1=name2
    local source=psgetpetownername(guid1, name1, flag1)
    pscduhadddamage(1,source,guid2,spellid,spellname,0)
end
if id==69553 or id==69548 or id==69556 then
    pscduhnamedamageadd2=name2
    local source=psgetpetownername(guid1, name1, flag1)
    pscduhadddamage(2,source,guid2,spellid,spellname,0)
end
end
end


--если отхилился босс показывать кто дамагал в чат:
--3/15 12:22:20.083  SPELL_HEAL,0xF1310F7300000EC6,"Благословенный дух лоа",0xa48,0x0,0xF1510DD600000257,"Сул Пескорыск",0x10a48,0x80,137303,"Благословенный дар",0x1,0xF1510DD600000257,94709341,1284,66,3,0,7065419,0,0,nil

if arg2=="SPELL_HEAL" and spellid==137303 then
      --репорт
      
      local healed=0
      healed=arg12-arg13
      pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." "..psmainmhealedhimself.." > "..psdamageceil(healed).." "..psulhp, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][3],2)
      if psraidoptionson[2][5][3][2]==1 then
        pszapuskanonsa(psraidchats3[psraidoptionschat[2][5][3][2]], "{rt8} "..name2.." "..psmainmhealedhimself.." > "..psdamageceil(healed).." "..psulhp..": |s4id137303|id")
        
        local ar3=pssichose5 or 4
        if #pssidamageinf_title2[pssavedplayerpos][1]>0 then
          for ii=1,#pscduhontabldamage1[1] do
            if pscduhontabldamage1[1][ii]==guid1 then
              psdamagerep_p2(psraidchats3[psraidoptionschat[2][5][3][2]],pssavedplayerpos,1,ii,ar3,1,2,1, false)
            end
          end
        end
      end
end




--передача стаков для героик версии
--количество стаков на игроках
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==137650 then
  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp53~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if pshertrackdeba1==nil then
      pshertrackdeba1={}--имя
      pshertrackdeba2={}--стаки
      pshertrackdeba3={}--время ласт обновления
    end
    local bil=0
    if #pshertrackdeba1>0 then
      for i=1,#pshertrackdeba1 do
        if pshertrackdeba1[i]==name2 then
          pshertrackdeba2[i]=arg13
          pshertrackdeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(pshertrackdeba1,name2)
      table.insert(pshertrackdeba2,arg13)
      table.insert(pshertrackdeba3,GetTime())
    end
  end
end

--снятие стаков с игрока тоже учесть!!!
if arg2=="SPELL_AURA_REMOVED" and spellid==137650 and pshertrackdeba1 and #pshertrackdeba1>0 then
  for i=1,#pshertrackdeba1 do
    if pshertrackdeba1[i] and name2==pshertrackdeba1[i] then
      table.remove(pshertrackdeba1,i)
      table.remove(pshertrackdeba2,i)
      table.remove(pshertrackdeba3,i)
    end
  end
end


--снятие дебафа
if arg2=="SPELL_AURA_REMOVED" and (spellid==137641 or spellid==137643) then
  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp53~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if pshertrackdeboff1==nil then
      pshertrackdeboff1={}--имя
      pshertrackdeboff2={}--время снятия
    end
    local bil=0
    if #pshertrackdeboff1>0 then
      for i=1,#pshertrackdeboff1 do
        if pshertrackdeboff1[i]==name2 then
          pshertrackdeboff2[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(pshertrackdeboff1,name2)
      table.insert(pshertrackdeboff2,GetTime())
    end
  end
end  


--наложение дебафа
if arg2=="SPELL_AURA_APPLIED" and (spellid==137641 or spellid==137643) then
  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp53~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    local txt=""
    local add=""
    --if pshertrackdeboff1 and #pshertrackdeboff1>1 then
      --add="(?)" --ыыКРАСНЫМ ТУТ
    --end
    
    --с кого спадает
    local bil=0
    if pshertrackdeboff1 and #pshertrackdeboff1>0 then
      for j=1,#pshertrackdeboff1 do
        if pshertrackdeboff1[j] and GetTime()<pshertrackdeboff2[j]+1.5 and bil==0 then
          bil=1
          local stak=""
          if #pshertrackdeba1>0 then
            for i=1,#pshertrackdeba1 do
              if pshertrackdeba1[i]==pshertrackdeboff1[j] and GetTime()<pshertrackdeba3[i]+550 then
                if pshertrackdeba2[i]<3 then
                  stak=" (|cffff0000"..pshertrackdeba2[i].."|r)"
                elseif (pshertrackdeba2[i]<5 or pshertrackdeba2[i]>8) then
                  stak=" (|CFFFFFF00"..pshertrackdeba2[i].."|r)"
                else
                  stak=" ("..pshertrackdeba2[i]..")"
                end
              end
            end
          end
          txt=txt..add..psaddcolortxt(1,pshertrackdeboff1[j])..pshertrackdeboff1[j]..psaddcolortxt(2,pshertrackdeboff1[j])..stak
          table.remove(pshertrackdeboff1,j)
          table.remove(pshertrackdeboff2,j)
        end
      end
    end
    if bil==0 then
      txt=txt.."|cffff0000???|r"--ыыкрасным тут
    end

    txt=txt.." -> "
    
    --на кого вешается
      local stak=""
      if pshertrackdeba1 and #pshertrackdeba1>0 then
        for i=1,#pshertrackdeba1 do
          if pshertrackdeba1[i]==name2 and GetTime()<pshertrackdeba3[i]+550 then
                if pshertrackdeba2[i]<3 then
                  stak=" (|cff00ff00"..pshertrackdeba2[i].."|r)"
                elseif (pshertrackdeba2[i]<10) then
                  stak=" (|CFFFFFF00"..pshertrackdeba2[i].."|r)"
                else
                  stak=" ("..pshertrackdeba2[i]..")"
                end
          end
        end
      end
    txt=txt..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..stak



    pscaststartinfo(0,spellname..": "..txt, -1, "id1", 3, "|s4id137641|id - "..psinfo,psbossnames[2][5][3],2)
  end
end




--битинг колд
if arg2=="SPELL_AURA_APPLIED" and spellid==136992 then
  pstempnametoavoid=name2
  pscaststartinfo(0,"SPELL_AURA_APPLIED: "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 4, "|s4id136917|id - "..psinfo,psbossnames[2][5][3],2)
end

if arg2=="SPELL_DAMAGE" and spellid==136917 and (pstempnametoavoid==nil or (pstempnametoavoid and pstempnametoavoid~=name2)) then

  if pswasonbossp53==nil then
    pswasonbossp53=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp53~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][3],2)
  end
end




--урон по нужному боссу
if arg2=="SPELL_AURA_APPLIED" and spellid==136442 then
  pstimestarttodps=GetTime()
  psdpscouncilok=guid2
  psbossnamecouncilattack=name2
end

if arg2=="SPELL_AURA_REMOVED" and spellid==136442 and pstimestarttodps then
      --изменение текста
        if pssidamageinf_title2[pssavedplayerpos] and pssidamageinf_title2[pssavedplayerpos][1] and #pssidamageinf_title2[pssavedplayerpos][1]>0 and pscduhontabldamage1 and #pssidamageinf_title2[1][9]==#pscduhontabldamage1[1] then
          for ii=1,#pscduhontabldamage1[1] do
            if pscduhontabldamage1[1][ii]==(1000+pstimestarttodps) then
              local time=GetTime()-pstimestarttodps
              time=math.ceil(time*10)/10
              pssidamageinf_title2[pssavedplayerpos][1][ii]=pssidamageinf_title2[pssavedplayerpos][1][ii].." ("..time.." "..pssec..")"
            end
          end
        end
        
  psdpscouncilok=nil
  pstimestarttodps=nil
  psbossnamecouncilattack=nil
end



if psdpscouncilok then
  if arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE" then
  if arg12 then
  if guid2==psdpscouncilok then
      --получение инфо о хозяине если там пет, с учетом по маске
      local source=psgetpetownername(guid1, name1, flag1)
      pscduhadddamage(3,source,1000+pstimestarttodps,arg12,arg13,spellid) --1 tip reporta
  end
  end
  end


  if arg2=="SWING_DAMAGE" then
  if spellid then
  if guid2==psdpscouncilok then
      local source=psgetpetownername(guid1, name1, flag1)
      pscduhadddamage(3,source,1000+pstimestarttodps,spellid,spellname,0)
  end
  end
  end
end




if arg2=="SPELL_AURA_APPLIED" and spellid==136992 then
  if psdebtoheal1==nil then
    psdebtoheal1={} --имя
    psdebtoheal2={} --когда наложился
    psdebtoheal3={} --когда снялся
  end
  local bil=0
  for i=1,#psdebtoheal1 do
    if psdebtoheal1[i]==name2 then
      psdebtoheal2[i]=GetTime()
      psdebtoheal3[i]=0
    end
  end
  if bil==0 then
    table.insert(psdebtoheal1,name2)
    table.insert(psdebtoheal2,GetTime())
    table.insert(psdebtoheal3,0)
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==136992 and psdebtoheal1 and #psdebtoheal1>0 then
  for i=1,#psdebtoheal1 do
    if psdebtoheal1[i]==name2 then
      psdebtoheal3[i]=GetTime()
      --изменение текста
        if pssidamageinf_title2[pssavedplayerpos] and pssidamageinf_title2[pssavedplayerpos][1] and #pssidamageinf_title2[pssavedplayerpos][1]>0 and pscduhontabldamage1 and pssidamageinf_title2[1][9] and #pssidamageinf_title2[1][9]==#pscduhontabldamage1[1] then
          for ii=1,#pscduhontabldamage1[1] do
            if pscduhontabldamage1[1][ii]==(1+psdebtoheal2[i]) then
              local time=GetTime()-psdebtoheal2[i]
              time=math.ceil(time*10)/10
              pssidamageinf_title2[pssavedplayerpos][1][ii]=pssidamageinf_title2[pssavedplayerpos][1][ii].." ("..time.." "..pssec..")"
            end
          end
        end
    end
  end
end


--потестить данные для хила!
--предположим что хил в арг 12 и арг 13
if (arg2=="SPELL_HEAL" or arg2=="SPELL_PERIODIC_HEAL") and arg12 and arg13 and psdebtoheal1 and #psdebtoheal1>0 and spellid then
  --проверка что хилили нужного человека
  if (arg12-arg13)>1 then
    for i=1,#psdebtoheal1 do
      local bil=0
      if psdebtoheal1[i] and psdebtoheal1[i]==name2 and psdebtoheal3[i]==0 and bil==0 then
        bil=1

        --запись
        local source=psgetpetownername(guid1, name1, flag1)
        if spellid==98021 then
          source=psgetpetownername2(guid1, name1, flag1)
        end
        if source==nil then
          source="Unknown"
        end
        pscduhadddamage(4,source,psdebtoheal2[i]+1,arg12,arg13,spellid,name2) --1 tip reporta
      end
    end
  end      
end


if arg2=="UNIT_DIED" and psdebtoheal1 and #psdebtoheal1>0 then
  for i=1,#psdebtoheal1 do
    if psdebtoheal1[i]==name2 and psdebtoheal3[i]~=0 and GetTime()<=psdebtoheal3[i]+1.5 then
      --изменение текста
        if pssidamageinf_title2[pssavedplayerpos] and pssidamageinf_title2[pssavedplayerpos][1] and #pssidamageinf_title2[pssavedplayerpos][1]>0 and pscduhontabldamage1 and #pssidamageinf_title2[1][9]==#pscduhontabldamage1[1] then
          for ii=1,#pscduhontabldamage1[1] do
            if pscduhontabldamage1[1][ii]==(1+psdebtoheal2[i]) then
              pssidamageinf_title2[pssavedplayerpos][1][ii]=pssidamageinf_title2[pssavedplayerpos][1][ii].." - "..psdied
            end
          end
        end
    end
  end
end
  


--unitname boss end
end
end