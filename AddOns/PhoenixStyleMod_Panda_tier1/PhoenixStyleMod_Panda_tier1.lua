function psloadpanda1()

pslocalepandam1()

if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="zhCN" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocalepanda1()
end

--description of the menu
psraidoptionstxtp1={}
psraidoptionstxtp1[1]={{}}
psraidoptionstxtp1[2]={{"|tip2 "..psmainmdamagefrom.." |sid122336|id","|tip2 |sid122740|id "..psinfo, "|tip1 "..pszzpandaaddopttxt13.." |sid122706|id"},{"|tip1 |sid123175|id ("..pszzpandaaddopttxt21..")","|tip1 "..pszzpandaaddopttxt13.." |sid122994|id","|tip2 "..psmainmdamagefrom.." |sid122853|id", "|tip1 "..pszzpandaaddopttxt32},{"|tip2 "..psmainmdamagefrom.." |sid123120|id","|tip2 "..pssummon.." |sid122774|id","|tip1 "..psmainmdamagefrom.." |sid122735|id "..format(pszzpandaaddopttxt31,"2"),"|tip2 "..psmainmdamagefrom.." |sid122735|id"},
{"|tip2 "..psmainmdamagefrom.." |sid121898|id", "|tip1 |sid131830|id "..psinfo, "|tip2 |sid131830|id "..psinfo, "|tip1 "..pszzpandaaddopttxt42},{"|tip2 "..psmainmdamagefrom.." |sid121995|id","|tip2 "..psmainmdamagefrom.." |sid122005|id","|tip1 |sid122532|id - "..pszzpandaaddopttxt2,"|tip2 |sid122532|id - "..pszzpandaaddopttxt2,"|tip1 |sid122398|id - "..pszzpandaaddopttxt3,"|tip2 "..psmainmdamagefrom.." |sid122504|id","|tip2 |sid122398|id - "..pszzpandaaddopttxt3, "|tip2 "..pszzpandaaddopttxt45, "|tip2 "..pszzpandaaddopttxt47,"|tip1 "..pszzpandaaddopttxt49,"|tip1 "..pszzpandaaddopttxt50},{"|tip1 "..psmainmdamagefrom.." |sid123735|id "..pszzpandaaddopttxt1,"|tip2 "..psmainmdamagefrom.." |sid124849|id","|tip1 "..format(pszzpandaaddopttxt29,"|sid124863|id")}}
psraidoptionstxtp1[3]={{"|tip1 "..psmainmdamagefrom.." |sid130774|id","|tip2 "..psmainmdamagefrom.." |sid130774|id","|tip4 "..pszzpandanotcounttick1.." |sid130774|id","|tip1 "..psmainmdamagefrom.." |sid116281|id "..pszzpandaaddopttxt1,"|tip2 "..psmainmdamagefrom.." |sid116281|id","|tip1 "..pszzpandaaddopttxt5,"|tip2 "..pszzpandaaddopttxt6},{"|tip2 |sid116434|id - "..pswhodidff,"|tip2 "..psmainmdamagefrom.." |sid116793|id","|tip1 "..pszzpandaaddopttxt11,"|tip2 "..pszzpandaaddopttxt11},{},{"|tip1 "..psmainmdamagefrom.." |sid119521|id","|tip2 "..psmainmdamagefrom.." |sid119521|id","|tip2 "..psmainmdamagefrom.." |sid117918|id", "|tip1 "..pszzpandaaddopttxt13.." |sid117921|id","|tip1 "..psmainmdamagefrom.." |sid119553|id + |sid119554|id ("..pszzpandaaddopttxt16..")","|tip2 "..psmainmdamagefrom.." |sid119553|id + |sid119554|id ("..pszzpandaaddopttxt16..")","|tip2 "..psmainmwhogot.." |sid118048|id","|tip1 |sid117961|id - "..psdispellinfo},{"|tip2 "..psmainmdamagefrom.." |sid119722|id","|tip2 "..format(pszzpandaaddopttxt40,"|sid117878|id"),"|tip1 "..pszzpandaaddopttxt13.." |sid117878|id"},{}}
psraidoptionstxtp1[4]={{"|tip2 "..psmainmdamagefrom.." |sid118003|id","|tip1 "..pszzpandaaddopttxt37},{"|tip2 "..psmainmdamagefrom.." |sid122777|id","|tip1 "..pszzpandaaddopttxt38,"|tip2 "..format(pszzpandaaddopttxt40,"|sid122768|id"),"|tip1 "..pszzpandaaddopttxt13.." |sid122768|id"},{"|tip1 "..pszzpandaaddopttxt13.." |sid123121|id","|tip2 "..format(pszzpandaaddopttxt40,"|sid123121|id"),"|tip2 "..pszzpandaaddopttxt41},{"|tip2 "..psmainmwhogot.." |sid119414|id","|tip1 "..pshealing.." |sid129190|id"}}

for i=1,#psraidoptionstxtp1 do
	for j=1,#psraidoptionstxtp1[i] do
		for k=1,#psraidoptionstxtp1[i][j] do
			psraidoptionstxtp1[i][j][k]=psspellfilter(psraidoptionstxtp1[i][j][k])
		end
	end
end

--chat settings 1 or 2 or 3
psraidoptionschatdefp1={}
psraidoptionschatdefp1[1]={{}}
psraidoptionschatdefp1[2]={{1,1,1},{3,1,1,1},{1,1,1,1},{1,1,1,1},{1,1,3,1,1,1,1,1,1,1,1},{3,1,1}}
psraidoptionschatdefp1[3]={{3,1,0,1,1,3,1},{1,1,3,1},{},{1,1,1,3,1,1,1,3},{1,1,1},{}}
psraidoptionschatdefp1[4]={{1,1},{1,1,1,1},{1,1,1},{1,1}}


--chat settings on or off
psraidoptionsondefp1={}
psraidoptionsondefp1[1]={}
psraidoptionsondefp1[2]={{1,1,1},{1,1,1,1},{1,1,1,1},{1,0,1,1},{1,1,0,1,1,1,1,1,1,0,1},{1,1,1}}
psraidoptionsondefp1[3]={{0,1,0,1,1,1,1},{1,1,1,1},{},{1,1,1,1,1,1,1,1},{1,1,1},{}}
psraidoptionsondefp1[4]={{1,1},{1,1,1,1},{1,1,1},{1,0}}




SetMapToCurrentZone()
if GetCurrentMapAreaID()==pslocations[2][1] or GetCurrentMapAreaID()==pslocations[2][2] or GetCurrentMapAreaID()==pslocations[2][3] or GetCurrentMapAreaID()==pslocations[2][4] then
	PhoenixStyleMod_Panda1:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	PhoenixStyleMod_Panda1:RegisterEvent("PLAYER_REGEN_DISABLED")
	PhoenixStyleMod_Panda1:RegisterEvent("PLAYER_REGEN_ENABLED")
	PhoenixStyleMod_Panda1:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PhoenixStyleMod_Panda1:RegisterEvent("ADDON_LOADED")
	PhoenixStyleMod_Panda1:RegisterEvent("CHAT_MSG_ADDON")
	--PhoenixStyleMod_Panda1:RegisterEvent("UNIT_POWER")
	PhoenixStyleMod_Panda1:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	PhoenixStyleMod_Panda1:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	

end



--онапдейт
function psonupdatepanda1(curtime)





--тут всякие онапдейт модули








--унсок взрывы
if psunsoktablbabah3 and #psunsoktablbabah3>0 and (curtime>psunsoktablbabah3[1]+5 or (psunsoktablbabah5[1]~=0 and curtime>psunsoktablbabah5[1])) then

  if psunsoktablbabah4[1]>0 then
    pscaststartinfo(0,GetSpellInfo(122398)..": "..psaddcolortxt(1,psunsoktablbabah1[1])..psunsoktablbabah1[1]..psaddcolortxt(2,psunsoktablbabah1[1])..". "..pszzpandaaddopttxt17..": "..psdamageceil(psunsoktablbabah4[1]), -1, "id1", 53, "|s4id122398|id - "..psinfo,psbossnames[2][2][5],2)
    if psraidoptionson[2][2][5][5]==1 and pswasonbossp25==1 and select(3,GetInstanceInfo())~=7 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][5][5]], "{rt8} "..psunsoktablbabah1[1].." > |s4id122398|id. "..pszzpandaaddopttxt17..": "..psdamageceil(psunsoktablbabah4[1]))
    end
    addtotwotables5(psunsoktablbabah1[1])
    vezaxsort5()
    if pstotaldmgbyexp==nil then
      pstotaldmgbyexp=0
    end
    pstotaldmgbyexp=pstotaldmgbyexp+psunsoktablbabah4[1]
  end
  table.remove(psunsoktablbabah1,1)
  table.remove(psunsoktablbabah2,1)
  table.remove(psunsoktablbabah3,1)
  table.remove(psunsoktablbabah4,1)
  table.remove(psunsoktablbabah5,1)
end




--2 босс диспелы
if pstsulong2 and pstsulong2~=0 and curtime>pstsulong2+1 then
  local text=" "
  if (pstsulong2-pstsulong1)>9.5 then
    text=text.."10 "..pssec.." (|cffff0000"..pszzpandaaddopttxt39.."|r)."
  else
    text=text..(math.ceil((pstsulong2-pstsulong1)*10)/10).." "..pssec..""
    if pstsulong4~=0 then
      text=text.." "..pszzpandaaddopttxt35..": "..pstsulong4.."."
    end
  end
  if pstsulong3>0 then
    text=text.." "..pszzpandaaddopttxt9..": "..psdamageceil(pstsulong3)
  end
  

        if psraidoptionson[2][4][2][2]==1 and pswasonbossp42==1 and pstsulong3>0 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][4][2][2]], "{rt8} |s4id123012|id"..psremovecolor(text))
        end

   pscaststartinfo(0,(GetSpellInfo(123012))..text, -1, "id1", 39, "|s4id123012|id - "..psinfo,psbossnames[2][4][2],2)
   
   pstsulong1=nil
   pstsulong2=nil
   pstsulong3=nil
   pstsulong4=nil
   
end

--1 босс диспелы
if pspretectbufftodispell3 and pspretectbufftodispell3~=0 and curtime>pspretectbufftodispell3+1 then
  local text=" "..pszzpandaaddopttxt34.." "..psaddcolortxt(1,pspretectbufftodispell1)..pspretectbufftodispell1..psaddcolortxt(2,pspretectbufftodispell1)..". "..pszzpandaaddopttxt35..": "
  if pspretectbufftodispell4==0 then
    text=text.."?"
  else
    text=text..psaddcolortxt(1,pspretectbufftodispell4)..pspretectbufftodispell4..psaddcolortxt(2,pspretectbufftodispell4)
  end
  local temptime=pspretectbufftodispell3-pspretectbufftodispell2
  if temptime>29.9 then
    temptime=30
  end
  text=text.." ("..(math.ceil((temptime)*10)/10).." "..pssec..")."
  if pspretectbufftodispell5>0 then
    text=text.." "..pszzpandaaddopttxt36..": "..psdamageceil(pspretectbufftodispell5).." "..psulhp
  end

        if psraidoptionson[2][4][1][2]==1 and pswasonbossp41==1 and pspretectbufftodispell5>0 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][4][1][2]], "{rt8} |s4id117283|id"..psremovecolor(text))
        end

   pscaststartinfo(0,(GetSpellInfo(117283))..text, -1, "id1", 39, "|s4id117283|id - "..psinfo,psbossnames[2][4][1],2)
   
   pspretectbufftodispell1=nil
   pspretectbufftodispell2=nil
   pspretectbufftodispell3=nil
   pspretectbufftodispell4=nil
   pspretectbufftodispell5=nil
   
end




--сняли дебафы на Лей ши
if psleishidebb3 and psleishidebb3[1] and curtime>psleishidebb3[1] then
  local text=": "..psaddcolortxt(1,psleishidebb1[1])..psleishidebb1[1]..psaddcolortxt(2,psleishidebb1[1])..", "
  if psleishidebb2[1]<6 then
    text=text..psstacks..": "..psleishidebb2[1].."."
  elseif psleishidebb2[1]<10 then
    text=text.."|cff00ff00"..psstacks..": "..psleishidebb2[1]..".|r"
  elseif psleishidebb2[1]<15 then
    text=text.."|CFFFFFF00"..psstacks..": "..psleishidebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..psleishidebb2[1]..".|r"
  end
  if psleishidebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
        if psraidoptionson[2][4][3][1]==1 and pswasonbossp43==1 and psleishidebb2[1]>4 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][4][3][1]], "{rt8} |s4id123121|id"..psremovecolor(text))
        end
  end  

  pscaststartinfo(0,GetSpellInfo(123121)..text, -1, "id1", 21, "|s4id123121|id - "..pszzpandaaddopttxt18,psbossnames[2][4][3],2)
  
  table.remove(psleishidebb1,1)
  table.remove(psleishidebb2,1)
  table.remove(psleishidebb3,1)
  --table.remove(psleishidebb3,1)
  table.remove(psleishidebb4,1)
end


--сняли дебафы на тсулонге
if pstsulondebb3 and pstsulondebb3[1] and curtime>pstsulondebb3[1] then
  local text=": "..psaddcolortxt(1,pstsulondebb1[1])..pstsulondebb1[1]..psaddcolortxt(2,pstsulondebb1[1])..", "
  if pstsulondebb2[1]<10 then
    text=text..psstacks..": "..pstsulondebb2[1].."."
  elseif pstsulondebb2[1]<15 then
    text=text.."|cff00ff00"..psstacks..": "..pstsulondebb2[1]..".|r"
  elseif pstsulondebb2[1]<20 then
    text=text.."|CFFFFFF00"..psstacks..": "..pstsulondebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..pstsulondebb2[1]..".|r"
  end
  if pstsulondebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
        if psraidoptionson[2][4][2][4]==1 and pswasonbossp42==1 and pstsulondebb2[1]>4 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][4][2][4]], "{rt8} |s4id122768|id"..psremovecolor(text))
        end
  end  

  pscaststartinfo(0,GetSpellInfo(122768)..text, -1, "id1", 21, "|s4id122768|id - "..pszzpandaaddopttxt18,psbossnames[2][4][2],2)
  
  table.remove(pstsulondebb1,1)
  table.remove(pstsulondebb2,1)
  table.remove(pstsulondebb3,1)
  table.remove(pstsulondebb4,1)
end


--фан модуль, скорость
if pstimertocheckruner and pstimertocheckruner~=0 and curtime>pstimertocheckruner then
  pstimertocheckruner=curtime+0.2
  for u=1,GetNumGroupMembers() do
    local x,y=GetPlayerMapPosition(UnitName("raid"..u))
    if x and x~=0 and x<=0.47560024261475 and pstimertocheckruner and pstimertocheckruner>0 then
      --ранер вин!
      local fdff=UnitName("raid"..u)
      local bil=0
      if #psrunnertabl>0 then
        for i=1,#psrunnertabl do
          if psrunnertabl[i]==fdff then
            bil=1
          end
        end
      end
      if bil==0 then
        table.insert(psrunnertabl,fdff)
        table.insert(psrunnertabl2,GetTime())
      end
      if #psrunnertabl==3 then
        pstimertocheckruner=0
        local text="> "..pszzpandaaddopttxt33..": "
        for m=1,#psrunnertabl do
          text=text..psaddcolortxt(1,psrunnertabl[m])..psnoservername(psrunnertabl[m])..psaddcolortxt(2,psrunnertabl[m])
          if m>1 then
            local time=(psrunnertabl2[m]-psrunnertabl2[1])
            time=math.ceil(time*10)/10
            text=text.." (-"..time.." "..pssec..")"
          end
          if m==#psrunnertabl then
            text=text.."."
          else
            text=text..", "
          end
        end
        if psraidoptionson[2][2][2][4]==1 and pswasonbossp22==1 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][2][4]], "{rt1} PhoenixStyle "..psremovecolor(text))
        end
        pscaststartinfo(0,text, -1, "id1", 87, pszzpandaaddopttxt30.." 2 - fan "..psinfo,psbossnames[2][2][2],2)
      end
    end
  end
end




--гаралон 122735,"Яростный замах"
if pswaitgaralontorep and curtime>pswaitgaralontorep then
  pswaitgaralontorep=nil
  if #vezaxname4~=2 then
    local text="|cffff0000FAIL!|r "..psmainmgot.." |sid122735|id ("..#vezaxname4..")"
    local text2=GetSpellInfo(122735).." |cffff0000FAIL!|r "..psmainmgot.." ("..#vezaxname4..")"
    if #vezaxname4<6 then
      text=text..": "
      text2=text2..": "
      for i=1,#vezaxname4 do
                text=text..psaddcolortxt(1,vezaxname4[i])..vezaxname4[i]..psaddcolortxt(2,vezaxname4[i])
                text2=text2..psaddcolortxt(1,vezaxname4[i])..vezaxname4[i]..psaddcolortxt(2,vezaxname4[i])
                if i==#vezaxname4 then
                  text=text.."."
                  text2=text2.."."
                else
                  text=text..", "
                  text2=text2..", "
                end
      end
    else
      text=text.."."
      text2=text2..": "
      for i=1,#vezaxname4 do
                text2=text2..psaddcolortxt(1,vezaxname4[i])..vezaxname4[i]..psaddcolortxt(2,vezaxname4[i])
                if i==#vezaxname4 then
                  text2=text2.."."
                else
                  text2=text2..", "
                end
      end
    end

        --ыытест без репорта в ЛФР
        if psraidoptionson[2][2][3][3]==1 and pswasonbossp23==1 and select(3,GetInstanceInfo())~=7 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][3][3]], "{rt8} "..psremovecolor(text))
        end

        pscaststartinfo(0,text2, -1, "id1", 97, "|s4id122735|id - "..psinfo,psbossnames[2][2][3],2)

  else

    local text2=GetSpellInfo(122735).." ("..#vezaxname4.."): "
    for i=1,#vezaxname4 do
              text2=text2..psaddcolortxt(1,vezaxname4[i])..vezaxname4[i]..psaddcolortxt(2,vezaxname4[i])
              if i==#vezaxname4 then
                text2=text2.."."
              else
                text2=text2..", "
              end
    end

        pscaststartinfo(0,text2, -1, "id1", 97, "|s4id122735|id - "..psinfo,psbossnames[2][2][3],2)
  end
  table.wipe(vezaxname4)
  table.wipe(vezaxcrash4)
end


--сс, 6 босс, Видения смерти
if psshekvizg6 and curtime>psshekvizg6 then
  psshekvizg6=psshekvizg6+1
  local bil=0
  local uron=0
  for i=1,#psshekvizg3 do
    if psshekvizg3[i]==0 then
      bil=1
    end
    if psshekvizg2[i]>0 then
      uron=uron+psshekvizg2[i]
    end
  end
  if curtime>psshekvizg4+22 or bil==0 then
    if uron>60000 then
      table.wipe(vezaxname2)
      table.wipe(vezaxcrash2)
      for i=1,#psshekvizg1 do
        if psshekvizg2[i]>30000 then
          addtotwotables2(psshekvizg1[i],psshekvizg2[i])
          vezaxsort2()
        end
      end
        if #vezaxname2>0 then
          --репорт, со всех снялось
          --Видения смерти #4. Друж. урон нанесли: Ник1 (500К), Ник2 (300К)
          --psdidfriendlyf
          local text=" #"..psshekvizg5..". "..psdidfriendlyf..": "
          for i=1,#vezaxname2 do
              text=text..psaddcolortxt(1,vezaxname2[i])..vezaxname2[i]..psaddcolortxt(2,vezaxname2[i]).." ("..psdamageceil(vezaxcrash2[i])..")"
              if i==#vezaxname2 then
                text=text.."."
              else
                text=text..", "
              end
          end
        --ыытест без репорта в ЛФР
        if psraidoptionson[2][2][6][3]==1 and pswasonbossp26==1 and uron>300000 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][6][3]], "{rt8} |s4id124863|id"..psremovecolor(text))
        end

        pscaststartinfo(0,GetSpellInfo(124863)..text, -1, "id1", 97, "|s4id124863|id - "..psinfo,psbossnames[2][2][6],2)
        end

    end
    psshekvizg1=nil
    psshekvizg2=nil
    psshekvizg3=nil
    psshekvizg4=nil
    psshekvizg5=nil
    psshekvizg6=nil
  end
end
  


--Сс, 6 босс, кто близко стоял
if psimperattonear3 and curtime>psimperattonear3 then
  psimperattonear3=nil
  local debuffs=2
	if psdifflastfight==25 then
		debuffs=5
	end
	if #psimperattonear1>debuffs then
    --fail дебафов больше.
    local text="FAIL ("..#psimperattonear1.." "..pszzpandaaddopttxt26.." "..debuffs.."). "
    local tabfail={} --игроки которые оказались ближе чем положено.
    for i=1,#psimperattonear1 do
      for j=1,#psimperattonear1 do
        if psimperattonear1[i]~=psimperattonear1[j] and psimperattonear2[i][1]~=0 and psimperattonear2[j][1]~=0 then
          local dist=math.sqrt(math.pow((psimperattonear2[i][1]-psimperattonear2[j][1]),2)+math.pow((psimperattonear2[i][2]-psimperattonear2[j][2]),2))
          local yard=dist/0.0009
          if yard<=5 then
            --добавляем фейлеров в таблицу
            local bil=0
            if #tabfail>0 then
              for z=1,#tabfail do
                if tabfail[z]==psimperattonear1[i] then
                  bil=1
                end
              end
            end
            if bil==0 then
              table.insert(tabfail,psimperattonear1[i])
            end
            bil=0
            if #tabfail>0 then
              for z=1,#tabfail do
                if tabfail[z]==psimperattonear1[j] then
                  bil=1
                end
              end
            end
            if bil==0 then
              table.insert(tabfail,psimperattonear1[j])
            end
          end
        end
      end
    end
    --тут проверять по текущим координатам
    local tabfail2={} --игроки которые оказались ближе чем положено, СЕЙЧАС
    for i=1,#psimperattonear1 do
      local x2,y2=GetPlayerMapPosition(psimperattonear1[i])
      for j=1,#psimperattonear1 do
        local x1,y1=GetPlayerMapPosition(psimperattonear1[j])
        if psimperattonear1[i]~=psimperattonear1[j] and x1~=0 and x2~=0 then
          local dist=math.sqrt(math.pow((x2-x1),2)+math.pow((y2-y1),2))
          local yard=dist/0.0009
          if yard<=5 then
            --добавляем фейлеров в таблицу
            local bil=0
            if #tabfail2>0 then
              for z=1,#tabfail2 do
                if tabfail2[z]==psimperattonear1[i] then
                  bil=1
                end
              end
            end
            if bil==0 then
              table.insert(tabfail2,psimperattonear1[i])
            end
            bil=0
            if #tabfail2>0 then
              for z=1,#tabfail2 do
                if tabfail2[z]==psimperattonear1[j] then
                  bil=1
                end
              end
            end
            if bil==0 then
              table.insert(tabfail2,psimperattonear1[j])
            end
          end
        end
      end
    end
    
    local minfail=(#psimperattonear1-debuffs)+1
    local tabrealfail={}
    local tab=0
    if #tabfail>=minfail and #tabfail<=#tabfail2 and #tabfail2>minfail then
      tab=1
    elseif #tabfail2>=minfail and #tabfail2<=#tabfail then
      tab=2
    elseif #tabfail>#tabfail2 then
      tab=1
    elseif #tabfail2>0 then
      tab=2
    else
      tab=1
    end
    if tab==1 then
      for k=1,#tabfail do
        table.insert(tabrealfail,tabfail[k])
      end
    elseif tab==2 then
      for k=1,#tabfail2 do
        table.insert(tabrealfail,tabfail2[k])
      end
    end
    
    if #tabrealfail>0 then
      --список фейлеров есть!
      text=text.."|cffff0000"..pszzpandaaddopttxt27..":|r "
      for m=1,#tabfail do
        text=text..psaddcolortxt(1,tabrealfail[m])..tabrealfail[m]..psaddcolortxt(2,tabrealfail[m])
        if m==#tabrealfail then
          text=text.."."
        else
          text=text..", "
        end
      end
    else
      text=text..pszzpandaaddopttxt28..": "
      for m=1,#psimperattonear1 do
        text=text..psaddcolortxt(1,psimperattonear1[m])..psimperattonear1[m]..psaddcolortxt(2,psimperattonear1[m])
        if m==#psimperattonear1 then
          text=text.."."
        else
          text=text..", "
        end
      end
    end
    --репорт в чат и в фрейм
    
    --ыытест без репорта в ЛФР
    if psraidoptionson[2][2][6][1]==1 and pswasonbossp26==1 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][6][1]], "{rt8} |s4id123735|id "..psremovecolor(text))
    end

    pscaststartinfo(0,GetSpellInfo(123735)..": "..text, -1, "id1", 98, "|s4id123735|id - "..psinfo,psbossnames[2][2][6],2)
  end
end


--повторный трекер на купола, 1 босс СС
if psdelaycheckkupola and curtime>psdelaycheckkupola then
  psdelaycheckkupola=nil
  SetMapToCurrentZone()
  if pszorlopcupol1 and #pszorlopcupol1>0 then
    for i=1,#pszorlopcupol1 do
      if pszorlopcupol1[i] then
        local spbuf=GetSpellInfo(122706)
        if UnitBuff(pszorlopcupol1[i], spbuf) or UnitDebuff(pszorlopcupol1[i], spbuf) then
          table.remove(pszorlopcupol1,i)
          table.remove(pszorlopcupol2,i)
          table.remove(pszorlopcupol3,i)
        else
          --бафа нет, проверяем ближайших игроков, репортим то инфо, где больше игроков с бафом рядом, если ровно то новое
          local tab1={}--игроки рядом
          local tab2={}--ярды
          --трекерим растояние ко всем рейдам
          local x2,y2=GetPlayerMapPosition(pszorlopcupol1[i])
          if x2 and y2 and x2>0 then
            for u=1,GetNumGroupMembers() do
              if UnitBuff(UnitName("raid"..u), spbuf) or UnitDebuff(UnitName("raid"..u), spbuf) then
                local x,y=GetPlayerMapPosition(UnitName("raid"..u))
                if x and y and x>0 then
                  local dist=math.sqrt(math.pow((x-x2),2)+math.pow((y-y2),2))
                  local yard=dist/0.0019
                  if yard<=10 then
                    yard=math.ceil(yard*10)/10
                    local refdf=UnitName("raid"..u)
                    table.insert(tab1,refdf)
                    table.insert(tab2,yard)
                  end
                end
              end
            end
          end
          local text2="" --фрейм
          text2=psaddcolortxt(1,pszorlopcupol1[i])..pszorlopcupol1[i]..psaddcolortxt(2,pszorlopcupol1[i]).." |cffff0000"..pszzpandaaddopttxt25.."|r "..GetSpellInfo(122706)..". "..pszzpandaaddopttxt24..": "
          --если в новой табл больше то репортим с нее:
          if #tab1>=#pszorlopcupol2[i] and #tab1>0 then
            for c=1,#tab1 do
              text2=text2..psaddcolortxt(1,tab1[c])..tab1[c]..psaddcolortxt(2,tab1[c]).." ("..tab2[c]..")"
              if c==#tab1 then
                text2=text2.."."
              else
                text2=text2..", "
              end
            end
          elseif #pszorlopcupol2[i]>0 then
            for c=1,#pszorlopcupol2[i] do
              text2=text2..psaddcolortxt(1,pszorlopcupol2[i][c])..pszorlopcupol2[i][c]..psaddcolortxt(2,pszorlopcupol2[i][c]).." ("..pszorlopcupol3[i][c]..")"
              if c==#pszorlopcupol2[i] then
                text2=text2.."."
              else
                text2=text2..", "
              end
            end
          end
          
          if #pszorlopcupol2[i]>0 or #tab1>0 then
            if psfsdgjseke==1 then
              pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 2, "|s4id122706|id - "..psinfo,psbossnames[2][2][1],2)
            end
            pscaststartinfo(0,text2, -1, "id1", 2, "|s4id122706|id - "..psinfo,psbossnames[2][2][1],2)
            psfsdgjseke=1
          end
          table.remove(pszorlopcupol1,i)
          table.remove(pszorlopcupol2,i)
          table.remove(pszorlopcupol3,i)
        end
      end
    end
  end
end


--тайлок, Unseen Strike
if psmassiveattackstabletay2 and curtime>psmassiveattackstabletay2+1.4 then
  psmassiveattackstabletay2=nil
    local text=""
    local text2=""
  if psmassiveattackstabletay3 and #psmassiveattackstabletay3>0 then
    --есть труп над репорт
    if #psmassiveattackstabletay3>3 then
      text=text..(#psmassiveattackstabletay3).." "..pszzpandaaddopttxt14.." |sid122994|id. "
      text2=text2..(#psmassiveattackstabletay3).." "..pszzpandaaddopttxt14.." |sid122994|id. "
    else
      for i=1,#psmassiveattackstabletay3 do
        text=text..psaddcolortxt(1,psmassiveattackstabletay3[i])..psmassiveattackstabletay3[i]..psaddcolortxt(2,psmassiveattackstabletay3[i])
        text2=text2..psaddcolortxt(1,psmassiveattackstabletay3[i])..psmassiveattackstabletay3[i]..psaddcolortxt(2,psmassiveattackstabletay3[i])
        if i~=#psmassiveattackstabletay3 then
          text=text..", "
          text2=text2..", "
        end
      end
      text=text.." |cffff0000"..psmainmdiedfrom.."|r |sid122994|id. "
      text2=text2.." |cffff0000"..psdied.."|r. "
    end
  end

    --собираем инфо по тем кто НЕ разделил урон и жив!
    local taball={}
		local psgroup=2
		if psdifflastfight==25 then
			psgroup=5
		end
		for i = 1,GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
			if subgroup<=psgroup and online and isDead==nil and UnitIsDeadOrGhost(name)==nil then
				table.insert(taball,name)
			end
		end
    for k=1,#psmassiveattackstabletay1 do
       if psmassiveattackstabletay1[k] then
         if #taball>0 then
           for j=1,#taball do
             if taball[j] and taball[j]==psmassiveattackstabletay1[k] then
               table.remove(taball,j)
             end
           end
         end
       end
    end
    text=text.."|cffff0000"..pszzpandaaddopttxt15.." ("..#taball..")"
    text2=text2.."|cffff0000"..pszzpandaaddopttxt15.." ("..#taball..")"
    if #taball>0 then
        if #taball<9 then
          text=text..": |r"
          text2=text2..": |r"
          for v=1,#taball do
            text=text..psaddcolortxt(1,taball[v])..psnoservername(taball[v])..psaddcolortxt(2,taball[v])
            text2=text2..psaddcolortxt(1,taball[v])..taball[v]..psaddcolortxt(2,taball[v])
            if v~=#taball then
              text=text..", "
              text2=text2..", "
            end
          end
        else
          text2=text2..": |r"
          for v=1,#taball do
            text2=text2..psaddcolortxt(1,taball[v])..taball[v]..psaddcolortxt(2,taball[v])
            if v~=#taball then
              text2=text2..", "
            end
          end
          text=text..".|r"
        end
    else
      text=text..".|r"
      text2=text2..".|r"
    end


    --репорт в чат и в фрейм
    if psraidoptionson[2][2][2][2]==1 and pswasonbossp22==1 and psmassiveattackstabletay3 and #psmassiveattackstabletay3>0 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][2][2]], "{rt8} "..psremovecolor(text))
    end
        if psstrazhiotstup222 then
          pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 56, "|s4id122994|id - "..psinfo,psbossnames[2][2][2],2)
        end
    pscaststartinfo(0,GetSpellInfo(122994)..": "..text2, -1, "id1", 56, "|s4id122994|id - "..psinfo,psbossnames[2][2][2],2)
    psstrazhiotstup222=1

  --end
  psmassiveattackstabletay3=nil
  psmassiveattackstabletay1=nil
end



--тайлок, винд степ
if pstayaktabwind2 and curtime>pstayaktabwind2 then
  pstayaktabwind2=nil
  if #pstayaktabwind3>1 or (#pstayaktabwind3>0 and pstayaktabwind1~=0) then
    local text=""
    if pstayaktabwind1==0 then
      text="?"
    else
      text=psaddcolortxt(1,pstayaktabwind1)..pstayaktabwind1..psaddcolortxt(2,pstayaktabwind1).."."
    end
    text=text.." "..pszzpandaaddopttxt22.." ("..#pstayaktabwind3.."): "
    for i=1,#pstayaktabwind3 do
      text=text..psaddcolortxt(1,pstayaktabwind3[i])..pstayaktabwind3[i]..psaddcolortxt(2,pstayaktabwind3[i])
      if i==#pstayaktabwind3 then
        text=text.."."
      else
        text=text..", "
      end
    end

    --репорт в чат и в фрейм
    if psraidoptionson[2][2][2][1]==1 and pswasonbossp22==1 and select(3,GetInstanceInfo())~=7 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][2][1]], "{rt8} |s4id123175|id: "..psremovecolor(text))
    end
    pscaststartinfo(0,GetSpellInfo(123175)..": "..text, -1, "id1", 81, "|s4id123175|id - "..psinfo,psbossnames[2][2][2],2)
  end
  pstayaktabwind1=nil
  pstayaktabwind3=nil
end

--мк урон на зорлоке
if pszaorlokmc3 and #pszaorlokmc3>0 then
  for i=1,#pszaorlokmc3 do
    if pszaorlokmc3[i] and pszaorlokmc3[i]~=0 and curtime>pszaorlokmc3[i]+1 then
      local time=math.ceil((pszaorlokmc3[i]-pszaorlokmc2[i])*10)/10
      addtotwotables4(pszaorlokmc1[i],time)
      vezaxsort4()
      table.remove(pszaorlokmc1,i)
      table.remove(pszaorlokmc2,i)
      table.remove(pszaorlokmc3,i)
      table.remove(pszaorlokmc4,i)
    end
  end
end




--зорлок, лучь выдох
if pszorlokluch3 and pszorlokluch3~=0 and curtime>pszorlokluch3+1 then
  local text=GetSpellInfo(122761)..": "..psaddcolortxt(1,pszorlokluch1)..pszorlokluch1..psaddcolortxt(2,pszorlokluch1)
  if pszorlokluch4==1 then
    text=text.."|cffff0000("..psdied..")|r"
  end
  text=text..", "..(math.ceil((pszorlokluch3-pszorlokluch2)*10)/10).." "..pssec.." "..pszzpandaaddopttxt9..": "
        if #vezaxname2>0 then
          for i=1,#vezaxname2 do
              text=text..psaddcolortxt(1,vezaxname2[i])..vezaxname2[i]..psaddcolortxt(2,vezaxname2[i]).." ("..psdamageceil(vezaxcrash2[i])..")"
              if i==#vezaxname2 then
                text=text.."."
              else
                text=text..", "
              end
          end
        end
        
        
        if psstrazhiotstup2322 then
          pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 22, "|s4id122761|id - "..psinfo,psbossnames[2][2][1],2)
        end
    psstrazhiotstup2322=1

  pscaststartinfo(0,text, -1, "id1", 22, "|s4id122761|id - "..psinfo,psbossnames[2][2][1],2)
  
  pszorlokluch1=nil
  pszorlokluch2=nil
  pszorlokluch3=nil
  pszorlokluch4=nil
end



--сняли дебафы на елегоне
if pselegondebb3 and pselegondebb3[1] and curtime>pselegondebb3[1] then
  local text=": "..psaddcolortxt(1,pselegondebb1[1])..pselegondebb1[1]..psaddcolortxt(2,pselegondebb1[1])..", "
  if pselegondebb2[1]<13 then
    text=text..psstacks..": "..pselegondebb2[1].."."
  elseif pselegondebb2[1]<16 then
    text=text.."|cff00ff00"..psstacks..": "..pselegondebb2[1]..".|r"
  elseif pselegondebb2[1]<20 then
    text=text.."|CFFFFFF00"..psstacks..": "..pselegondebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..pselegondebb2[1]..".|r"
  end
  if pselegondebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
        if psraidoptionson[2][3][5][3]==1 and pswasonbossp35==1 and pselegondebb2[1]>5 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][5][3]], "{rt8} |s4id117878|id"..psremovecolor(text))
        end
  end  

  pscaststartinfo(0,GetSpellInfo(117878)..text, -1, "id1", 21, "|s4id117878|id - "..pszzpandaaddopttxt18,psbossnames[2][3][5],2)
  
  table.remove(pselegondebb1,1)
  table.remove(pselegondebb2,1)
  table.remove(pselegondebb3,1)
  table.remove(pselegondebb4,1)
end



--track max hp of adds elegon
if pselegmaxHPadd1 and pselegmaxHPadd1==0 then
	if psdelayhpcheckalakir==nil then
		psdelayhpcheckalakir=curtime+0.5
	end
	if curtime>psdelayhpcheckalakir then
		psdelayhpcheckalakir=curtime+0.5
		for ttg=1,GetNumGroupMembers() do
			if UnitGUID("raid"..ttg.."-target") then
				local id=tonumber(string.sub(UnitGUID("raid"..ttg.."-target"),6,10),16)
				if id==60793 then
          pselegmaxHPadd1=UnitHealthMax("raid"..ttg.."-target")*0.75
					ttg=41
					psdelayhpcheckalakir=nil
				end
			end
		end
	end
end




--непроницаемый щит, короли
if pskingsshieldfirst2 and pskingsshieldfirst2~=0 and curtime>pskingsshieldfirst2+1 then
  local text=" #"..psshielddarknr2..", ("..(math.ceil((pskingsshieldfirst2-pskingsshieldfirst1)*10)/10).." "..pssec..": "
    if pskingsshieldfirst3~=0 then
      text=text..psaddcolortxt(1,pskingsshieldfirst3)..pskingsshieldfirst3..psaddcolortxt(2,pskingsshieldfirst3)
    else
      text=text.."?"
    end

    pscaststartinfo(0,(GetSpellInfo(117961))..text, -1, "id1", 69, "|s4id117961|id - "..psinfo,psbossnames[2][3][4],2)
    pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 69, "|s4id117961|id - "..psinfo,psbossnames[2][3][4],2)


    --репорт в чат и в фрейм
    if psraidoptionson[2][3][4][8]==1 and pswasonbossp34==1 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][4][8]], "{rt2} |s4id117961|id"..psremovecolor(text))
    end

    pskingsshieldfirst1=nil
    pskingsshieldfirst2=nil
    pskingsshieldfirst3=nil   
end


--щит тьмы, короли
if pskingsshielddark2 and pskingsshielddark2~=0 and curtime>pskingsshielddark2+1 then
  local text=(GetSpellInfo(117697)).." #"..psshielddarknr..", ("..(math.ceil((pskingsshielddark2-pskingsshielddark1)*10)/10).." "..pssec..": "
  --Shield of Darkness #1, 10 sec: Name1 (5), Name2(2). Damage to raid: 5M
        if #vezaxname6>0 then
          for i=1,#vezaxname6 do
              text=text..psaddcolortxt(1,vezaxname6[i])..vezaxname6[i]..psaddcolortxt(2,vezaxname6[i]).." ("..vezaxcrash6[i]..")"
              if i==#vezaxname6 then
                text=text.."."
              else
                text=text..", "
              end
          end
        end
   text=text.." "..pszzpandaaddopttxt17..": "..psdamageceil(pskingsshielddark3)
   if pskingsshielddark4 and pskingsshielddark4>100 then
     text=text.." (|cffff0000+ "..psoverkill..": "..psdamageceil(pskingsshielddark4).."|r)."
   else
     text=text.."."
   end
   pscaststartinfo(0,text, -1, "id1", 39, "|s4id117697|id - "..psinfo,psbossnames[2][3][4],2)
   
   pskingsshielddark1=nil
   pskingsshielddark2=nil
   pskingsshielddark3=nil
   pskingsshielddark4=nil
   
end


--короли град стрел через 5 сек
if psreportstreliking and curtime>psreportstreliking then
  psreportstreliking=nil
        if psraidoptionson[2][3][4][5]==1 and pswasonbossp34==1 then
          strochkavezcrash="{rt8} "..psmainmdamagefrom.." |s4id119553|id ("..pszzpandaaddopttxt16.."): "
          reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][4][5]], false, vezaxname4, vezaxcrash4, 1)
        end

        local text=""
        if #vezaxname4>0 then
          for i=1,#vezaxname4 do
              text=text..psaddcolortxt(1,vezaxname4[i])..vezaxname4[i]..psaddcolortxt(2,vezaxname4[i]).." ("..vezaxcrash4[i]..")"
              if i==#vezaxname4 then
                text=text.."."
              else
                text=text..", "
              end
          end
        end
        --pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 56, "|s4id119553|id - "..psinfo,psbossnames[2][3][4],2)
        pscaststartinfo(0,GetSpellInfo(119553).." #"..psshieldnrdrag2..": "..text, -1, "id1", 51, "|s4id119553|id - "..psinfo,psbossnames[2][3][4],2)


        table.wipe(vezaxname4)
        table.wipe(vezaxcrash4)
end



--короли мощнейшие атаки
if psmassiveattackstabletemp2 and curtime>psmassiveattackstabletemp2+1.4 then
  psmassiveattackstabletemp2=nil
  if psmassiveattackstabletemp3 and #psmassiveattackstabletemp3>0 then
    --есть труп над репорт
    local text=""
    local text2=""
    if #psmassiveattackstabletemp3>3 then
      text=text..(#psmassiveattackstabletemp3).." "..pszzpandaaddopttxt14.." |sid117921|id. "
      text2=text2..(#psmassiveattackstabletemp3).." "..pszzpandaaddopttxt14.." |sid117921|id. "
    else
      for i=1,#psmassiveattackstabletemp3 do
        text=text..psaddcolortxt(1,psmassiveattackstabletemp3[i])..psmassiveattackstabletemp3[i]..psaddcolortxt(2,psmassiveattackstabletemp3[i])
        text2=text2..psaddcolortxt(1,psmassiveattackstabletemp3[i])..psmassiveattackstabletemp3[i]..psaddcolortxt(2,psmassiveattackstabletemp3[i])
        if i~=#psmassiveattackstabletemp3 then
          text=text..", "
          text2=text2..", "
        end
      end
      text=text.." |cffff0000"..psmainmdiedfrom.."|r |sid117921|id. "
      text2=text2.." |cffff0000"..psdied.."|r. "
    end

    --собираем инфо по тем кто НЕ разделил урон и жив!
    local taball={}
		local psgroup=2
		if psdifflastfight==25 then
			psgroup=5
		end
		for i = 1,GetNumGroupMembers() do
			local name, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
			if subgroup<=psgroup and online and isDead==nil and UnitIsDeadOrGhost(name)==nil then
				table.insert(taball,name)
			end
		end
    for k=1,#psmassiveattackstabletemp1 do
       if psmassiveattackstabletemp1[k] then
         if #taball>0 then
           for j=1,#taball do
             if taball[j] and taball[j]==psmassiveattackstabletemp1[k] then
               table.remove(taball,j)
             end
           end
         end
       end
    end
    text=text.."|cffff0000"..pszzpandaaddopttxt15.." ("..#taball..")"
    text2=text2.."|cffff0000"..pszzpandaaddopttxt15.." ("..#taball..")"
    if #taball>0 then
        if #taball<9 then
          text=text..": |r"
          text2=text2..": |r"
          for v=1,#taball do
            text=text..psaddcolortxt(1,taball[v])..psnoservername(taball[v])..psaddcolortxt(2,taball[v])
            text2=text2..psaddcolortxt(1,taball[v])..taball[v]..psaddcolortxt(2,taball[v])
            if v~=#taball then
              text=text..", "
              text2=text2..", "
            end
          end
        else
          text2=text2..": |r"
          for v=1,#taball do
            text2=text2..psaddcolortxt(1,taball[v])..taball[v]..psaddcolortxt(2,taball[v])
            if v~=#taball then
              text2=text2..", "
            end
          end
          text=text..".|r"
        end
    else
      text=text..".|r"
      text2=text2..".|r"
    end


    --репорт в чат и в фрейм
    if psraidoptionson[2][3][4][4]==1 and pswasonbossp34==1 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][4][4]], "{rt8} "..psremovecolor(text))
    end
        if psstrazhiotstup22 then
          pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 56, "|s4id117921|id - "..psinfo,psbossnames[2][3][4],2)
        end
    pscaststartinfo(0,GetSpellInfo(117921)..": "..text2, -1, "id1", 56, "|s4id117921|id - "..psinfo,psbossnames[2][3][4],2)
    psstrazhiotstup22=1

  end
  psmassiveattackstabletemp3=nil
  psmassiveattackstabletemp1=nil
end


--щит на фенге
if psshieldisup and curtime>psshieldisup+7 then
psshieldisup=nil
if psshieldnrdrag then
        if psraidoptionson[2][3][2][3]==1 and pswasonbossp32==1 and select(3,GetInstanceInfo())~=7 then
          strochkavezcrash="{rt8} "..pszzpandaaddopttxt12.." |sid115856|id #"..psshieldnrdrag..": "
          reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][2][3]], false, vezaxname3, vezaxcrash3, 1)
        end

        local text=""
        if #vezaxname3>0 then
          for i=1,#vezaxname3 do
            if i<=10 then
              text=text..psaddcolortxt(1,vezaxname3[i])..psnoservername(vezaxname3[i])..psaddcolortxt(2,vezaxname3[i]).." ("..vezaxcrash3[i]..")"
              if i==#vezaxname3 or i==10 then
                if i==10 and #vezaxname3>10 then
                  text=text..", ..."
                else
                  text=text.."."
                end
              else
                text=text..", "
              end
            end
          end
        end
        if psstrazhiotstup then
          pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 56, "|s4id115856|id - "..psinfo,psbossnames[2][3][2],2)
        end
        pscaststartinfo(0,pszzpandaaddopttxt12.." "..GetSpellInfo(115856).." #"..psshieldnrdrag..": "..text, -1, "id1", 56, "|s4id115856|id - "..psinfo,psbossnames[2][3][2],2)
        psstrazhiotstup=1

end
        table.wipe(vezaxname3)
        table.wipe(vezaxcrash3)
end


--стражи, цепи инфо
if psguardchainstab6 then
  if curtime>psdelaycheckguardchain then
    psdelaycheckguardchain=curtime+1
    for i=1,#psguardchainstab6 do
      if psguardchainstab6[i] and psguardchainstab6[i]~=0 and curtime>psguardchainstab6[i]+2 then
        --пора выводить инфо
        --Шурш, Лилу: Тиков без дебафа яшмы: 3. Время с цепями: 40 сек. Полученый урон: 500К+800К.. (более 300К красным?)
        local text=psaddcolortxt(1,psguardchainstab1[i])..psguardchainstab1[i]..psaddcolortxt(2,psguardchainstab1[i])..", "..psaddcolortxt(1,psguardchainstab2[i])..psguardchainstab2[i]..psaddcolortxt(2,psguardchainstab2[i])
        if psguardchainstab7[i]>0 or psguardchainstab8[i]>0 then
          text=text..". "..pszzpandaaddopttxt7..": "
          if psguardchainstab7[i]==0 then
            text=text.."|cff00ff000|r"
          else
            text=text..psguardchainstab7[i]
          end
          text=text.." + "
          if psguardchainstab8[i]==0 then
            text=text.."|cff00ff000|r"
          else
            text=text..psguardchainstab8[i]
          end
        end
        text=text..". "..pszzpandaaddopttxt8..": "..(math.ceil((psguardchainstab6[i]-psguardchainstab5[i])*10)/10).." "..pssec
        if psguardchainstab9[i]==1 or psguardchainstab10[i]==1 then
          text=text.." ("
          local one=0
          if psguardchainstab9[i]==1 then
            text=text..psaddcolortxt(1,psguardchainstab1[i])..psguardchainstab1[i]..psaddcolortxt(2,psguardchainstab1[i]).." |cffff0000"..psdied.."|r"
            one=1
          end
          if psguardchainstab10[i]==1 then
            if one==1 then
              text=text..", "
            end
            text=text..psaddcolortxt(1,psguardchainstab2[i])..psguardchainstab2[i]..psaddcolortxt(2,psguardchainstab2[i]).." |cffff0000"..psdied.."|r"
          end
          text=text..")."
        end
        text=text.." "..pszzpandaaddopttxt9..": "
        local red1=""
        local red2=""
        if psguardchainstab3[i]>300000 then
          red1="|cffff0000"
          red2="|r"
        end
        text=text..red1..psdamageceil(psguardchainstab3[i])..red2.." + "
        red1=""
        red2=""
        if psguardchainstab4[i]>300000 then
          red1="|cffff0000"
          red2="|r"
        end
        text=text..red1..psdamageceil(psguardchainstab4[i])..red2.."."
        if psraidoptionson[2][3][1][6]==1 and pswasonbossp31==1 and select(3,GetInstanceInfo())~=7 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][1][6]], psremovecolor(text))
        end
        if psstrazhiotstup then
          pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 57, "|s4id130395|id - "..psinfo,psbossnames[2][3][1],2)
        end
        pscaststartinfo(0,GetSpellInfo(130395)..": "..text, -1, "id1", 57, "|s4id130395|id - "..psinfo,psbossnames[2][3][1],2)
        psstrazhiotstup=1
        
        
        --ремув всей строчки
        table.remove(psguardchainstab1,i)
        table.remove(psguardchainstab2,i)
        table.remove(psguardchainstab3,i)
        table.remove(psguardchainstab4,i)
        table.remove(psguardchainstab5,i)
        table.remove(psguardchainstab6,i)
        table.remove(psguardchainstab7,i)
        table.remove(psguardchainstab8,i)
        table.remove(psguardchainstab9,i)
        table.remove(psguardchainstab10,i)
      end
    end
  end
end







--унсок, взрывы слизней
if psambertabltorep254 then
  for t=1,#psambertabltorep254 do
    if psambertabltorep254 and psambertabltorep254[t] and curtime>psambertabltorep254[t] then
      local text="{rt8} |s4id122532|id"
      if #psambertabltorep252[t]>0 then
        table.sort(psambertabltorep252[t])
        text=text.." "..psmainmgotm..": "
        for i=1,#psambertabltorep252[t] do
          if psambertabltorep252[t][i] then
            if i~=1 then
              text=text..", "
            end
            text=text..psnoservername(psambertabltorep252[t][i])
          end
        end
        text=text.."."
      end
      if psambertabltorep253[t]>0 then
        text=text.." "..pszzpandaaddopttxt4..": "..psdamageceil(psambertabltorep253[t]).." "..psulhp.."."
      end

      if select(3,GetInstanceInfo())~=7 then
        pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][5][3]], text)
      end

      if #psambertabltorep251>1 then
        table.remove(psambertabltorep251,t)
        table.remove(psambertabltorep252,t)
        table.remove(psambertabltorep253,t)
        table.remove(psambertabltorep254,t)
      else
        psambertabltorep251=nil
        psambertabltorep252=nil
        psambertabltorep253=nil
        psambertabltorep254=nil
      end
    end
  end
end



--спирит кинг, анигиляция
if psspiritkingtab2 and curtime>psspiritkingtab2 then
        local names=""
        for i=1,#psspiritkingtab1 do
          if psspiritkingtab1[i] then
            if i~=1 then
              names=names..", "
            end
            names=names..psnoservername(psspiritkingtab1[i])
          end
        end
        pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][4][1]], "{rt8} "..psmainmdamagefrom.." |s4id117948|id: "..names)
        psspiritkingtab1=nil
        psspiritkingtab2=nil
end


--стражи, аметист лужа
if psstoneguardrep05 and curtime>psstoneguardrep05 then
  strochkavezcrash=psmainmdamagefrom.." |s4id130774|id: "
	reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][1][1]], false, vezaxname2, vezaxcrash2, 1)
  table.wipe(vezaxname2)
  table.wipe(vezaxcrash2)
  psstoneguardrep05=nil
end

--стражи, кобальтовая бомба
if psstonebombrep3 then
  for t=1,#psstonebombrep3 do
    if psstonebombrep3 and psstonebombrep3[t] and curtime>psstonebombrep3[t] then
      if #psstonebombrep1[t]>1 then
        table.sort(psstonebombrep1[t])
        local names=""
        for i=1,#psstonebombrep1[t] do
          if psstonebombrep1[t][i] then
            if i~=1 then
              names=names..", "
            end
            names=names..psnoservername(psstonebombrep1[t][i])
          end
        end
        pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][1][4]], "{rt8} "..names.." "..psmainmgotm.." |s4id116281|id!")
      else
        --не репортим если всего 1 чел!!!
        --if UnitSex(psstonebombrep1[1]) and UnitSex(psstonebombrep1[1])==3 then
        --  pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][1][4]], "{rt8} "..psnoservername(psstonebombrep1[t][1]).." "..psmainmgotinf.." |s4id116281|id!")
        --else
        --  pszapuskanonsa(psraidchats3[psraidoptionschat[2][3][1][4]], "{rt8} "..psnoservername(psstonebombrep1[t][1]).." "..psmainmgotinm.." |s4id116281|id!")
        --end
      end
      if #psstonebombrep1>1 then
        table.remove(psstonebombrep1,t)
        table.remove(psstonebombrep2,t)
        table.remove(psstonebombrep3,t)
      else
        psstonebombrep1=nil
        psstonebombrep2=nil
        psstonebombrep3=nil
      end
    end
  end
end





--reset not in combat
if psrezetnotcombp1 and curtime>psrezetnotcombp1 then
	local a=GetSpellInfo(20711)
	local b=UnitBuff("player", a)
	if UnitAffectingCombat("player")==nil and UnitIsDeadOrGhost("player")==nil and b==nil then --and UnitName("boss1")
		psiccwipereport_p1(nil,"try")
	end
end




--evade after 3 sec
if pscmrcheckforevade_p1 and curtime>pscmrcheckforevade_p1 then
pscmrcheckforevade_p1=pscmrcheckforevade_p1+7
local id=0
if UnitGUID("boss1") then
	id=tonumber(string.sub(UnitGUID("boss1"),6,10),16)
end
local bil=0
if #psbossbugs>0 then
	for i=1,#psbossbugs do
		if psbossbugs[i]==id then
			bil=1
		end
	end
end
if (UnitName("boss1")==nil and UnitName("boss2")==nil and UnitName("boss3")==nil) or bil==1 or (UnitName("boss1") and UnitName("boss1")=="") then
psiccwipereport_p1(nil,"try")
end
end



if pscatamrdelayzone_p1 and curtime>pscatamrdelayzone_p1 then
pscatamrdelayzone_p1=nil
local a1, a2, a3, a4, a5 = GetInstanceInfo()
if UnitInRaid("player") or (a2=="raid" or (a2=="party" and a3==2)) then
SetMapToCurrentZone()
end
if GetCurrentMapAreaID()==pslocations[2][1] or GetCurrentMapAreaID()==pslocations[2][2] or GetCurrentMapAreaID()==pslocations[2][3] or GetCurrentMapAreaID()==pslocations[2][4] then
PhoenixStyleMod_Panda1:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
PhoenixStyleMod_Panda1:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
end

--announce delay for phasing
if psiccrepupdate_p1 and curtime>psiccrepupdate_p1 then
psiccrepupdate_p1=nil
psiccwipereport_p1(psdelcount1,psdelcount2,psdelcount3)
psdelcount1=nil
psdelcount2=nil
psdelcount3=nil
end


--прерванные бои
if pscheckbossincombatmcr_p1 and GetTime()>pscheckbossincombatmcr_p1 then
	pscheckbossincombatmcr_p1=pscheckbossincombatmcr_p1+2


local id=0
if UnitGUID("boss1") then
	id=tonumber(string.sub(UnitGUID("boss1"),6,10),16)
end
local bil=0
if #psbossbugs>0 then
	for i=1,#psbossbugs do
		if psbossbugs[i]==id then
			bil=1
		end
	end
end

	if UnitGUID("boss1") and bil==0 and UnitName("boss1")~="" then
	else
		pscheckbossincombatmcr_p1=nil
		pscheckbossincombatmcr_p12=GetTime()+1
	end
end

if pscheckbossincombatmcr_p12 and GetTime()>pscheckbossincombatmcr_p12 then
	pscheckbossincombatmcr_p12=nil
	if psbossblock==nil then
		psiccwipereport_p1(nil, nil, "reset")
	end
end

if pscatadelaycheckboss and curtime>pscatadelaycheckboss then
pscatadelaycheckboss=nil


	if UnitGUID("boss1") then
		local id2=UnitGUID("boss1")
		local id=tonumber(string.sub(id2,6,10),16)
local bil=0
if #psbossbugs>0 then
	for i=1,#psbossbugs do
		if psbossbugs[i]==id then
			bil=1
		end
	end
end
		if bil==0 and UnitName("boss1")~="" then
			pscmroncombatstartcheckboss_p1(id)
		else
			pscmrdelayofbosccheck_p1=GetTime()+1
		end
	else
		pscmrdelayofbosccheck_p1=GetTime()+1
	end
end


--постоянная проверка по ходу боя...
if pscmrdelayofbosccheck_p1 and curtime>pscmrdelayofbosccheck_p1 then
pscmrdelayofbosccheck_p1=curtime+1


	if UnitGUID("boss1") then
		local id2=UnitGUID("boss1")
		local id=tonumber(string.sub(id2,6,10),16)
local bil=0
if #psbossbugs>0 then
	for i=1,#psbossbugs do
		if psbossbugs[i]==id then
			bil=1
		end
	end
end
		if bil==0 and UnitName("boss1")~="" then
			pscmroncombatstartcheckboss_p1(id)
			pscmrdelayofbosccheck_p1=nil
		end
	end
end


--hunter die delay

if psicchunterdiedelay and curtime>psicchunterdiedelay then
psicchunterdiedelay=nil
--deathwisper/omnitron
if psicchunterdiedelayboss==1 then
for tyu=1,#psicchunterdiedelaytable do
	for euu = 1,GetNumGroupMembers() do local name, _, _, _, _, _, _, _, isDead = GetRaidRosterInfo(euu)
		if (name==psicchunterdiedelaytable[tyu] and (isDead or UnitIsDeadOrGhost(name))) then
			psiccladydeathghostcheck(psicchunterdiedelayarg1, psicchunterdiedelaytable[tyu],8)
		end
	end
end

psicchunterdiedelayarg1=nil
end

psicchunterdiedelaytable=nil
psicchunterdiedelayboss=nil
end







end

function pscmroncombatstartcheckboss_p1(id)

if psbossblock==nil then

SetMapToCurrentZone()
if GetCurrentMapAreaID()==896 or GetCurrentMapAreaID()==897 or GetCurrentMapAreaID()==886 then
  pscmrcheckforevade_p1=GetTime()+10
end


--ыыытест новые боссы прописывать тут (2 места)



if GetCurrentMapAreaID()==896 then
	if (id==60051 or id==60043 or id==59915 or id==60047) and psbossfilep31 then
		pswasonbossp31=1
	end
	if id==60009 and psbossfilep32 then
		pswasonbossp32=1
		pswasonbossp31=nil
	end
	if id==60143 and psbossfilep33 then
		pswasonbossp33=1
		pswasonbossp31=nil
		pswasonbossp32=nil
	end
	if (id==60701 or id==60708 or id==60709 or id==60710) and psbossfilep34 then
		pswasonbossp34=1
	end
	if id==60410 and psbossfilep35 then
		pswasonbossp35=1
	end
	if (id==60399 or id==60400) and psbossfilep36 then
		pswasonbossp36=1
	end
end

if GetCurrentMapAreaID()==897 then

	if id==62980 and psbossfilep21 then
		pswasonbossp21=1
	end
	if id==62543 and psbossfilep22 then
		pswasonbossp22=1
	end
	if id==63191 and psbossfilep23 then
		pswasonbossp23=1
	end
	if id==62397 and psbossfilep24 then
		pswasonbossp24=1
	end
	if id==62511 and psbossfilep25 then
	pswasonbossp24=nil
		pswasonbossp25=1
	end
	if id==62837 and psbossfilep26 then
	pswasonbossp24=nil
	pswasonbossp25=nil
		pswasonbossp26=1
	end
end


if GetCurrentMapAreaID()==886 then



	if (id==60585 or id==60586 or id==60583) and psbossfilep41 then
		pswasonbossp41=1
	end
	if id==62442 and psbossfilep42 then
		pswasonbossp42=1
	end
	if id==62983 and psbossfilep43 then
		pswasonbossp43=1
	end
	if id==60999 and psbossfilep44 then
    if pstempblizzfix==nil or (pstempblizzfix and GetTime()>pstempblizzfix) then
      pswasonbossp44=1
    end
	end
end


end

end


function psoneventpanda1(self,event,...)


--if GetNumGroupMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--ыытест босс блок добавить?! хрен знает нада ли, но в течении 5 сек после кила не смотрит лог?!
if event == "COMBAT_LOG_EVENT_UNFILTERED" then

local arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15 = ...
--ыытест не хватает инст 1

--Inst 2
if GetCurrentMapAreaID()==897 then


if pswasonbossp21 then
pscombatlogbossp21(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp22 then
pscombatlogbossp22(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp23 then
pscombatlogbossp23(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp24 then
pscombatlogbossp24(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp25(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp26(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp25 then
pscombatlogbossp25(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp24(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp26(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp26 then
pscombatlogbossp26(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp24(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp25(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
else

pscombatlogbossp21(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp22(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp23(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp24(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp25(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp26(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)

end

end
--inst 2 end


--Inst 3
if GetCurrentMapAreaID()==896 then

if pswasonbossp31 then
pscombatlogbossp31(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15) --временно !!!! ВСЕ 3 босса смотрю, чтобы не сфейлить !!!
pscombatlogbossp32(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp33(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp32 then
pscombatlogbossp31(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp32(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp33(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp33 then
pscombatlogbossp33(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp34 then
pscombatlogbossp34(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp35 then
pscombatlogbossp35(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp36 then
pscombatlogbossp36(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
else
pscombatlogbossp31(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp32(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp33(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp34(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp35(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp36(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
end
end
--inst 3 end

--inst 4
if GetCurrentMapAreaID()==886 then

if pswasonbossp41 then
pscombatlogbossp41(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp42 then
pscombatlogbossp42(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp43 then
pscombatlogbossp43(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp44 then
pscombatlogbossp44(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
else
pscombatlogbossp41(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp42(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp43(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp44(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
end
end
--inst 4 end


--res to reset info
if arg2=="SPELL_RESURRECT" and (spellid==83968 or spellid==7328 or spellid==50769 or spellid==2008 or spellid==2006) then
psiccwipereport_p1(nil,"try")
end


else

--остальные евенты

local arg1, arg2, arg3,arg4,arg5,arg6 = ...

if event == "PLAYER_REGEN_DISABLED" then


if (psbilresnut and GetTime()<psbilresnut+3) or pscheckbossincombat then


else

--тут резет всего в начале боя ыытест


pselegontabldamage1={{},{},{},{}}
table.wipe (pselegontabldamage1[1])
table.wipe (pselegontabldamage1[2])
table.wipe (pselegontabldamage1[3])
table.wipe (pselegontabldamage1[4])




if UnitGUID("boss1") then
local id2=UnitGUID("boss1")
local id=tonumber(string.sub(id2,6,10),16)
local bil=0
if #psbossbugs>0 then
	for i=1,#psbossbugs do
		if psbossbugs[i]==id then
			bil=1
		end
	end
end
if bil==0 and UnitName("boss1")~="" then
pscmroncombatstartcheckboss_p1(id)
else
pscatadelaycheckboss=GetTime()+2
end

else
pscatadelaycheckboss=GetTime()+2
end


end
end


if event=="PLAYER_REGEN_ENABLED" then
	if UnitAffectingCombat("player")==nil and UnitIsDeadOrGhost("player")==nil then --and UnitName("boss1")==nil
    if pswasonbossp42 then
      psrezetnotcombp1=GetTime()+3
    else
      psrezetnotcombp1=GetTime()+5
    end
	end
end



if event == "ZONE_CHANGED_NEW_AREA" then


psiccwipereport_p1(nil,"try")
pscatamrdelayzone_p1=GetTime()+3


end


if event == "CHAT_MSG_ADDON" then


end

if event =="CHAT_MSG_MONSTER_EMOTE" then



--сс 4 босс
if ((arg1 and string.find(arg1,131830)) or (arg2==GetSpellInfo(131830)) and arg2 ~= arg5 and UnitName("boss1")) then
  if pswasonbossp24==nil then
    pswasonbossp24=1
  end


    pscheckwipe1()
    if pswipetrue and pswasonbossp24~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables2(arg5)
    vezaxsort2()
    
    pscaststartinfo(0,GetSpellInfo(131830)..": |cffff0000FAIL!|r "..psaddcolortxt(1,arg5)..arg5..psaddcolortxt(2,arg5), -1, "id1", 91, "|s4id131830|id - "..psinfo,psbossnames[2][2][4],2)


    if psraidoptionson[2][2][4][2]==1 and pswasonbossp24==1 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][4][2]], "{rt8} |s4id131830|id > "..psnoservername(arg5))
    end

end

end

if event=="CHAT_MSG_RAID_BOSS_EMOTE" then


if arg1 and string.find(arg1,122774) and arg2 ~= arg5 then
  if pswasonbossp23==nil then
    pswasonbossp23=1
  end

    pscheckwipe1()
    if pswipetrue and pswasonbossp23~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables3(arg5)
    vezaxsort3()
    
    pscaststartinfo(0,GetSpellInfo(122774)..": "..psaddcolortxt(1,arg5)..arg5..psaddcolortxt(2,arg5), -1, "id1", 91, "|s4id122774|id - "..psinfo,psbossnames[2][2][3],2)


end




if arg1 and string.find(arg1,122949) and arg2 ~= arg5 then
  --сей анонсер
  if ps_saoptions[2][2][2][1]==1 then
    ps_sa_sendinfo(arg5, GetSpellInfo(122949).." "..psmain_sa_phrase1, 5, nil, nil)
  end
end


end




if event == "ADDON_LOADED" then

if arg1=="PhoenixStyleMod_Panda_tier1" then


if psicctekver_4==nil then psicctekver_4=0 end


local psiccnewveranoncet={}
if GetLocale()=="ruRU" then
psiccnewveranoncet={}
end 


--NEW announce
	if 0-psicctekver_4>0 and #psiccnewveranoncet>0 then --1 первая

local psvercoll=(0-psicctekver_4) --2

		if psvercoll>0 then
			print ("|cff99ffffPhoenixStyle|r - "..pscolnewveranonce1)
		end

if psvercoll>3 then psvercoll=3 end

while psvercoll>0 do
		if psvercoll>0 and psiccnewveranoncet[psvercoll] then
out ("|cff99ffffPhoenixStyle|r - "..psiccnewveranoncet[psvercoll])
		end
psvercoll=psvercoll-1
end
	end

psicctekver_4=0 --ТЕК ВЕРСИЯ!!! и так выше изменить цифру что отнимаем, всего 3 раза




pslastmoduleloadtxt=pscmrlastmoduleloadtxtp1


--перенос переменных

pscmrpassvariables_p1()


for i=1,4 do
	if psraidoptionson[2][i]==nil then psraidoptionson[2][i]={}
	end
	for j=1,#psraidoptionsonp1[i] do
		if psraidoptionson[2][i][j]==nil then
			psraidoptionson[2][i][j]={}
		end
		for t=1,#psraidoptionsonp1[i][j] do
			if psraidoptionson[2][i][j][t]==nil then
				psraidoptionson[2][i][j][t]=psraidoptionsonp1[i][j][t]
			end
		end
	end
end

for i=1,4 do
	if psraidoptionstxt[i]==nil then psraidoptionstxt[i]={}
	end
	for j=1,#psraidoptionstxtp1[i] do
		if psraidoptionstxt[i][j]==nil then
			psraidoptionstxt[i][j]={}
		end
		for t=1,#psraidoptionstxtp1[i][j] do
			if psraidoptionstxt[i][j][t]==nil then
				psraidoptionstxt[i][j][t]=psraidoptionstxtp1[i][j][t]
			end
		end
	end
end

--ыытест что мы тут убирали, тестим
psraidoptionstxtp1=nil



--psraidoptionstxtp11=nil
--psraidoptionstxtp12=nil
--psraidoptionstxtp13=nil
--psraidoptionstxtp14=nil

for i=1,4 do
	if psraidoptionschat[2][i]==nil then psraidoptionschat[2][i]={}
	end
	for j=1,#psraidoptionschatp1[i] do
		if psraidoptionschat[2][i][j]==nil then
			psraidoptionschat[2][i][j]={}
		end
		for t=1,#psraidoptionschatp1[i][j] do
			if psraidoptionschat[2][i][j][t]==nil then
				psraidoptionschat[2][i][j][t]=psraidoptionschatp1[i][j][t]
			end
		end
	end
end



--boss manual localization update
if psbossnames and psbossnames[2] then
psbossnames[2][3][1]=pszzpandabossname31
psbossnames[2][3][4]=pszzpandabossname34
psbossnames[2][3][6]=pszzpandabossname36
psbossnames[2][4][1]=pszzpandabossname41
end


end
end
--остальные евенты конец





end --рейд


end --КОНЕЦ ОНЕВЕНТ


--tryorkill - if try then true, if kill - nil, reset - only reset no report
--pswasonboss42 1 если мы в бою с боссом и трекерим, 2 если вайпнулись и продолжаем трекерить ПОСЛЕ анонса
function psiccwipereport_p1(wipe, tryorkill, reset, checkforwipe)
local aa=""
if wipe then
aa=aa.."wipe:"..wipe.."."
end
if tryorkill then
aa=aa.."tryorkill:"..tryorkill.."."
end
if reset then
aa=aa.."reset:"..reset.."."
end
if checkforwipe then
aa=aa.."checkforwipe:"..checkforwipe.."."
end


	if pszapuskdelayphasing>0 then
	psiccrepupdate_p1=pszapuskdelayphasing
	pszapuskdelayphasing=0
	if psiccrepupdate_p1>7 then psiccrepupdate_p1=7 end
	psiccrepupdate_p1=psiccrepupdate_p1+GetTime()
	psdelcount1=wipe
	psdelcount2=tryorkill
	psdelcount3=reset
	else

		if psiccrepupdate_p1==nil then

--ыыытест новые боссы прописывать тут (2 места)
pscmrcheckforevade_p1=nil


--if (pswasonbossp11) then
--pscmrbossREPORTp111(wipe, tryorkill, reset, checkforwipe)
--pscmrbossRESETp111(wipe, tryorkill, reset, checkforwipe)
--end

--if (pswasonbossp12) then
--pscmrbossREPORTp121(wipe, tryorkill, reset, checkforwipe)
--pscmrbossRESETp121(wipe, tryorkill, reset, checkforwipe)
--end

if (pswasonbossp21) then
pscmrbossREPORTp211(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp211(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp22) then
pscmrbossREPORTp221(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp221(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp23) then
pscmrbossREPORTp231(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp231(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp24) then
pscmrbossREPORTp241(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp241(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp25) then
pscmrbossREPORTp251(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp251(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp26) then
pscmrbossREPORTp261(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp261(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp31) then
pscmrbossREPORTp311(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp311(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp32) then
pscmrbossREPORTp321(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp321(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp33) then
pscmrbossREPORTp331(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp331(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp34) then
pscmrbossREPORTp341(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp341(wipe, tryorkill, reset, checkforwipe)
end
if (pswasonbossp35) then
pscmrbossREPORTp351(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp351(wipe, tryorkill, reset, checkforwipe)
end
if (pswasonbossp36) then
pscmrbossREPORTp361(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp361(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp41) then
pscmrbossREPORTp411(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp411(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp42) then
pscmrbossREPORTp421(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp421(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp43) then
pscmrbossREPORTp431(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp431(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp44) then
pscmrbossREPORTp441(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp441(wipe, tryorkill, reset, checkforwipe)
end


		end

	end

if wipe==nil and psbossblock==nil then
psbossblock=GetTime()
end

end


function pscmrpassvariables_p1()

if psraidoptionschatp1==nil then psraidoptionschatp1={} end

for i=1,#psraidoptionschatdefp1 do
	if psraidoptionschatp1[i]==nil then
		psraidoptionschatp1[i]={}
	end
	for j=1,#psraidoptionschatdefp1[i] do
		if psraidoptionschatp1[i][j]==nil then
			psraidoptionschatp1[i][j]={}
		end
		for t=1,#psraidoptionschatdefp1[i][j] do
			if psraidoptionschatp1[i][j][t]==nil or (psraidoptionschatp1[i][j][t] and psraidoptionschatp1[i][j][t]==0) then
				psraidoptionschatp1[i][j][t]=psraidoptionschatdefp1[i][j][t]
			end
		end
	end
end

if psraidoptionsonp1==nil then psraidoptionsonp1={} end

for i=1,#psraidoptionsondefp1 do
	if psraidoptionsonp1[i]==nil then
		psraidoptionsonp1[i]={}
	end
	for j=1,#psraidoptionsondefp1[i] do
		if psraidoptionsonp1[i][j]==nil then
			psraidoptionsonp1[i][j]={}
		end
		for t=1,#psraidoptionsondefp1[i][j] do
			if psraidoptionsonp1[i][j][t]==nil then
				psraidoptionsonp1[i][j][t]=psraidoptionsondefp1[i][j][t]
			end
		end
	end
end

end