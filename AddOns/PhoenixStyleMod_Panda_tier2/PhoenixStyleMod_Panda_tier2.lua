function psloadpanda2()

pslocalepandam2()

if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="zhCN" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocalepanda2()
end

--description of the menu
psraidoptionstxtp2={}
psraidoptionstxtp2[1]={{"|tip2 "..psmainmdamagefrom.." |sid137423|id","|tip2 "..psmainmdamagefrom.." |sid137905|id","|tip2 "..psmainmdamagefrom.." |sid137647|id"},
{"|tip1 "..pszzpandattaddopttxt1.." |sid136767|id","|tip2 "..format(pszzpandattaddopttxt2,"|sid136767|id"),"|tip2 "..psmainmdamagefrom.." |sid136739|id","|tip2 "..psmainmdamagefrom.." |sid136723|id","|tip2 "..psmainmdamagefrom.." |sid136646|id","|tip2 "..psmainmdamagefrom.." |sid136490|id"},
{"|tip2 "..psmainmdamagefrom.." |sid137133|id","|tip1 "..pszzpandattaddopttxt4,"|tip2 "..psmainmdamagefrom.." |sid136992|id"},
{"|tip2 "..psmainmdamagefrom.." |sid134539|id","|tip2 "..psmainmdamagefrom.." |sid134011|id"},
{"|tip2 "..psmainmdamagefrom.." |sid139909|id","|tip2 "..psmainmdamagefrom.." |sid139836|id"},
{pszzpandattaddopttxt5,"|tip1 "..psmainmdamagefrom.." |sid134375|id"},
{"|tip1 "..pszzpandattaddopttxt1.." |sid133767|id","|tip2 "..psmainmdamagefrom.." |sid134755|id","|tip2 "..psmainmdamagefrom.." |sid133793|id"},
{"|tip2 "..psmainmdamagefrom.." |sid136247|id","|tip2 "..psmainmdamagefrom.." |sid136037|id","|tip1 "..pszzpandattaddopttxt1.." |sid136216|id","|tip2 "..pszzpandattaddopttxt14.." ("..psmainmtotal..")"},
{"|tip2 "..psmainmwhogot.." |sid139869|id"},
{"|tip2 "..psmainmdamagefrom.." |sid137668|id","|tip2 "..psmainmdamagefrom.." |sid137669|id","|tip2 "..psmainmdamagefrom.." |sid136520|id"},
{"|tip2 "..psmainmwhogot.." |sid136722|id"},
{"|tip2 "..psmainmdamagefrom.." |sid136850|id"},
{}
}

for i=1,#psraidoptionstxtp2 do
	for j=1,#psraidoptionstxtp2[i] do
		for k=1,#psraidoptionstxtp2[i][j] do
			psraidoptionstxtp2[i][j][k]=psspellfilter(psraidoptionstxtp2[i][j][k])
		end
	end
end

--chat settings 1 or 2 or 3
psraidoptionschatdefp2={}
psraidoptionschatdefp2[1]={{1,1,1},
{1,1,1,1,1,1},
{1,1,1},
{1,1},
{1,1},
{1,1},
{1,1,1},
{1,1,1,1},
{1},
{1,1,1},
{1},
{1},
{}
}



--chat settings on or off
psraidoptionsondefp2={}
psraidoptionsondefp2[1]={{1,1,1},
{1,1,1,1,1,1},
{1,1,1},
{1,1},
{1,1},
{1,1},
{1,1,1},
{1,1,1,1},
{1},
{1,1,1},
{1},
{1},
{}
}





SetMapToCurrentZone()
if GetCurrentMapAreaID()==pslocations[2][5] then
	PhoenixStyleMod_Panda2:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	PhoenixStyleMod_Panda2:RegisterEvent("PLAYER_REGEN_DISABLED")
	PhoenixStyleMod_Panda2:RegisterEvent("PLAYER_REGEN_ENABLED")
	PhoenixStyleMod_Panda2:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PhoenixStyleMod_Panda2:RegisterEvent("ADDON_LOADED")
	PhoenixStyleMod_Panda2:RegisterEvent("CHAT_MSG_ADDON")
	PhoenixStyleMod_Panda2:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	PhoenixStyleMod_Panda2:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	

end



--онапдейт
function psonupdatepanda2(curtime)





--тут всякие онапдейт модули












--8 босс разделение урона
if psbigaoeprimidstabletay2 and curtime>psbigaoeprimidstabletay2+1.4 then
  psbigaoeprimidstabletay2=nil
    local text=""
    local text2=""
  if psbigaoeprimidstabletay3 and #psbigaoeprimidstabletay3>0 then
    --есть труп над репорт
    if #psbigaoeprimidstabletay3>3 then
      text=text..(#psbigaoeprimidstabletay3).." "..pszzpandattaddopttxt12.." |sid136216|id. "
      text2=text2..(#psbigaoeprimidstabletay3).." "..pszzpandattaddopttxt12.." |sid136216|id. "
    else
      for i=1,#psbigaoeprimidstabletay3 do
        text=text..psaddcolortxt(1,psbigaoeprimidstabletay3[i])..psbigaoeprimidstabletay3[i]..psaddcolortxt(2,psbigaoeprimidstabletay3[i])
        text2=text2..psaddcolortxt(1,psbigaoeprimidstabletay3[i])..psbigaoeprimidstabletay3[i]..psaddcolortxt(2,psbigaoeprimidstabletay3[i])
        if i~=#psbigaoeprimidstabletay3 then
          text=text..", "
          text2=text2..", "
        end
      end
      text=text.." |cffff0000"..psmainmdiedfrom.."|r |sid136216|id. "
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
    for k=1,#psbigaoeprimidstabletay1 do
       if psbigaoeprimidstabletay1[k] then
         if #taball>0 then
           for j=1,#taball do
             if taball[j] and taball[j]==psbigaoeprimidstabletay1[k] then
               table.remove(taball,j)
             end
           end
         end
       end
    end
    text=text.."|cffff0000"..pszzpandattaddopttxt13.." ("..#taball..")"
    text2=text2.."|cffff0000"..pszzpandattaddopttxt13.." ("..#taball..")"
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
    if psraidoptionson[2][5][8][3]==1 and pswasonbossp58==1 and psbigaoeprimidstabletay3 and #psbigaoeprimidstabletay3>0 then
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][5][8][3]], "{rt8} "..psremovecolor(text))
    end
        if psstrazhiotstup222 then
          pscaststartinfo(0,"|cff00ff00--|r", -1, "id1", 56, "|s4id136216|id - "..psinfo,psbossnames[2][5][8],2)
        end
    pscaststartinfo(0,GetSpellInfo(136216)..": "..text2, -1, "id1", 56, "|s4id136216|id - "..psinfo,psbossnames[2][5][8],2)
    psstrazhiotstup222=1

  --end
  psbigaoeprimidstabletay3=nil
  psbigaoeprimidstabletay1=nil
end



--5 босс диспелы
if psmegeraa2 and #psmegeraa2>0 then
  if curtime>psuglidelaylit then
    psuglidelaylit=curtime+1
    for i=1,#psmegeraa2 do
      if psmegeraa2[i] and psmegeraa2[i]~=0 and curtime>psmegeraa2[i]+1 then
        local text=": "
          text=text..psaddcolortxt(1,psmegeraa3[i])..psmegeraa3[i]..psaddcolortxt(2,psmegeraa3[i]).." "..(math.ceil((psmegeraa2[i]-psmegeraa1[i])*10)/10).." "..pssec..""
          if psmegeraa4[i]~=0 then
            text=text.." "..pszzpandattaddopttxt10..": "..psmegeraa4[i].."."
          end

         pscaststartinfo(0,(GetSpellInfo(139822))..text, -1, "id1", 39, "|s4id139822|id - "..psinfo,psbossnames[2][5][5],2)
         
         table.remove(psmegeraa1,i)
         table.remove(psmegeraa2,i)
         table.remove(psmegeraa3,i)
         table.remove(psmegeraa4,i)
       end
    end
  end
end




--птичка, Кар! лишний урон
if psragnahishandtimerpanda and curtime>psragnahishandtimerpanda then
psragnahishandtimerpanda=nil
if #psragnahishand1>psragnamaxdam then
	local tabl={}
	local all=""
	for i=1,#psragnahishand1 do
		all=all..psragnahishand1[i]
		if #psragnahishand1==i then
		else
			all=all..", "
		end
		if psragnahishand1[i] and i~=#psragnahishand1 then
			local m=i+1
			for j=m,#psragnahishand1 do
				local dist=math.sqrt(math.pow((psragnahishand2[i]-psragnahishand2[j]),2)+math.pow((psragnahishand3[i]-psragnahishand3[j]),2))
				local yard=dist/0.0021003817324125
				if yard<=8 then
					local bil=0
					local bil2=0
					if #tabl>0 then
						for k=1,#tabl do
							if tabl[k]==psragnahishand1[i] then
								bil=1
							end
						end
						
						for k=1,#tabl do
							if tabl[k]==psragnahishand1[j] then
								bil2=1
							end
						end
					end
					if bil==0 then
						table.insert(tabl,psragnahishand1[i])
					end
					if bil2==0 then
						table.insert(tabl,psragnahishand1[j])
					end
				end
			end
		end
	end
	local spellname=GetSpellInfo(134375)
	if #tabl==0 then
		pscaststartinfo(0,spellname..": "..(#psragnahishand1-psragnamaxdam).." "..pszzpandattaddopttxt7.." ("..all..")", -1, "id1", 12, spellname.." - "..psinfo,psbossnames[2][5][6],2)
	else
		local txt1="{rt8} "..spellname.." "..format(pszzpandattaddopttxt8,#psragnahishand1).." "..psragnamaxdam..". "..pszzpandattaddopttxt9..": " --чат
		local txt2=spellname.." "..format(pszzpandattaddopttxt8,#psragnahishand1).." "..psragnamaxdam..". "..pszzpandattaddopttxt9..": " --фрейм
		for q=1,#tabl do
			txt1=txt1..tabl[q]
			txt2=txt2..psaddcolortxt(1,tabl[q])..tabl[q]..psaddcolortxt(2,tabl[q])
			if q==#tabl then
				txt1=txt1.."."
				txt2=txt2.."."
			else
				txt1=txt1..", "
				txt2=txt2..", "
			end
		end

		pscaststartinfo(0,txt2, -1, "id1", 12, spellname.." - "..psinfo,psbossnames[2][5][6],2)
		if psraidoptionson[2][5][6][2]==1 and select(3,GetInstanceInfo())~=7 then
			pszapuskanonsa(psraidchats3[psraidoptionschat[2][5][6][2]], txt1)
		end
	end


end

psragnahishand1=nil
psragnahishand2=nil
psragnahishand3=nil

end



--сняли дебаффы танки на хорридоне
if pshorridebb3 and pshorridebb3[1] and curtime>pshorridebb3[1] then
  local text=": "..psaddcolortxt(1,pshorridebb1[1])..pshorridebb1[1]..psaddcolortxt(2,pshorridebb1[1])..", "
  if pshorridebb2[1]<6 then
    text=text..psstacks..": "..pshorridebb2[1].."."
  elseif pshorridebb2[1]<10 then
    text=text.."|cff00ff00"..psstacks..": "..pshorridebb2[1]..".|r"
  elseif pshorridebb2[1]<15 then
    text=text.."|CFFFFFF00"..psstacks..": "..pshorridebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..pshorridebb2[1]..".|r"
  end
  if pshorridebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
        if psraidoptionson[2][5][2][1]==1 and pswasonbossp52==1 and pshorridebb2[1]>4 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][5][2][1]], "{rt8} |s4id136767|id"..psremovecolor(text))
        end
  end  


  pscaststartinfo(0,GetSpellInfo(136767)..text, -1, "id1", 21, "|s4id136767|id - "..pszzpandattaddopttxt3,psbossnames[2][5][2],2)
  
  table.remove(pshorridebb1,1)
  table.remove(pshorridebb2,1)
  table.remove(pshorridebb3,1)
  --table.remove(pshorridebb3,1)
  table.remove(pshorridebb4,1)
end




--сняли дебаффы танки на дуруме
if psdurumdebb3 and psdurumdebb3[1] and curtime>psdurumdebb3[1] then
  local text=": "..psaddcolortxt(1,psdurumdebb1[1])..psdurumdebb1[1]..psaddcolortxt(2,psdurumdebb1[1])..", "
  if psdurumdebb2[1]<6 then
    text=text..psstacks..": "..psdurumdebb2[1].."."
  elseif psdurumdebb2[1]<10 then
    text=text.."|cff00ff00"..psstacks..": "..psdurumdebb2[1]..".|r"
  elseif psdurumdebb2[1]<15 then
    text=text.."|CFFFFFF00"..psstacks..": "..psdurumdebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..psdurumdebb2[1]..".|r"
  end
  if psdurumdebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
        if psraidoptionson[2][5][7][1]==1 and pswasonbossp57==1 and psdurumdebb2[1]>4 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][5][7][1]], "{rt8} |s4id133767|id"..psremovecolor(text))
        end
  end  


  pscaststartinfo(0,GetSpellInfo(133767)..text, -1, "id1", 21, "|s4id133767|id - "..pszzpandattaddopttxt3,psbossnames[2][5][7],2)
  
  table.remove(psdurumdebb1,1)
  table.remove(psdurumdebb2,1)
  table.remove(psdurumdebb3,1)
  --table.remove(psdurumdebb3,1)
  table.remove(psdurumdebb4,1)
end



--сняли дебаффы танки на птице2
if psptitsdebb3 and psptitsdebb3[1] and curtime>psptitsdebb3[1] then
  local text=": "..psaddcolortxt(1,psptitsdebb1[1])..psptitsdebb1[1]..psaddcolortxt(2,psptitsdebb1[1])..", "
  if psptitsdebb2[1]<6 then
    text=text..psstacks..": "..psptitsdebb2[1].."."
  elseif psptitsdebb2[1]<10 then
    text=text.."|cff00ff00"..psstacks..": "..psptitsdebb2[1]..".|r"
  elseif psptitsdebb2[1]<15 then
    text=text.."|CFFFFFF00"..psstacks..": "..psptitsdebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..psptitsdebb2[1]..".|r"
  end
  if psptitsdebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
  end  


  pscaststartinfo(0,"Info: "..GetSpellInfo(140092)..text, -1, "id1", 21, "|s4id140092|id, |s4id134366|id - "..pszzpandattaddopttxt3,psbossnames[2][5][6],2)
  
  table.remove(psptitsdebb1,1)
  table.remove(psptitsdebb2,1)
  table.remove(psptitsdebb3,1)
  --table.remove(psptitsdebb3,1)
  table.remove(psptitsdebb4,1)
end
--+ 2 raz
if psptitcdebb3 and psptitcdebb3[1] and curtime>psptitcdebb3[1] then
  local text=": "..psaddcolortxt(1,psptitcdebb1[1])..psptitcdebb1[1]..psaddcolortxt(2,psptitcdebb1[1])..", "
  if psptitcdebb2[1]<6 then
    text=text..psstacks..": "..psptitcdebb2[1].."."
  elseif psptitcdebb2[1]<10 then
    text=text.."|cff00ff00"..psstacks..": "..psptitcdebb2[1]..".|r"
  elseif psptitcdebb2[1]<15 then
    text=text.."|CFFFFFF00"..psstacks..": "..psptitcdebb2[1]..".|r"
  else
    text=text.."|cffff0000"..psstacks..": "..psptitcdebb2[1]..".|r"
  end
  if psptitcdebb4[1]==1 then
    text=text.." |cffff0000("..psdied..")|r"
  end  

  pscaststartinfo(0,"Info: "..GetSpellInfo(134366)..text, -1, "id1", 21, "|s4id140092|id, |s4id134366|id - "..pszzpandattaddopttxt3,psbossnames[2][5][6],2)
  
  table.remove(psptitcdebb1,1)
  table.remove(psptitcdebb2,1)
  table.remove(psptitcdebb3,1)
  --table.remove(psptitcdebb3,1)
  table.remove(psptitcdebb4,1)
end



--reset not in combat
if psrezetnotcombp2 and curtime>psrezetnotcombp2 then
	local a=GetSpellInfo(20711)
	local b=UnitBuff("player", a)
	if UnitAffectingCombat("player")==nil and UnitIsDeadOrGhost("player")==nil and b==nil then --and UnitName("boss1")
		psiccwipereport_p2(nil,"try")
		psrezetnotcombp2=nil
	end
end




--evade after 3 sec
if pscmrcheckforevade_p2 and curtime>pscmrcheckforevade_p2 then
pscmrcheckforevade_p2=pscmrcheckforevade_p2+7
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
psiccwipereport_p2(nil,"try")
end
end



if pscatamrdelayzone_p2 and curtime>pscatamrdelayzone_p2 then
pscatamrdelayzone_p2=nil
local a1, a2, a3, a4, a5 = GetInstanceInfo()
if UnitInRaid("player") or (a2=="raid" or (a2=="party" and a3==2)) then
SetMapToCurrentZone()
end
if GetCurrentMapAreaID()==pslocations[2][5] then
PhoenixStyleMod_Panda2:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
PhoenixStyleMod_Panda2:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
end

--announce delay for phasing
if psiccrepupdate_p2 and curtime>psiccrepupdate_p2 then
psiccrepupdate_p2=nil
psiccwipereport_p2(psdelcount1,psdelcount2,psdelcount3)
psdelcount1=nil
psdelcount2=nil
psdelcount3=nil
end


--прерванные бои
if pscheckbossincombatmcr_p2 and GetTime()>pscheckbossincombatmcr_p2 then
	pscheckbossincombatmcr_p2=pscheckbossincombatmcr_p2+2


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
		pscheckbossincombatmcr_p2=nil
		pscheckbossincombatmcr_p22=GetTime()+1
	end
end

if pscheckbossincombatmcr_p22 and GetTime()>pscheckbossincombatmcr_p22 then
	pscheckbossincombatmcr_p22=nil
	if psbossblock==nil then
		psiccwipereport_p2(nil, nil, "reset")
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
			pscmroncombatstartcheckboss_p2(id)
		else
			pscmrdelayofbosccheck_p2=GetTime()+1
		end
	else
		pscmrdelayofbosccheck_p2=GetTime()+1
	end
end


--постоянная проверка по ходу боя...
if pscmrdelayofbosccheck_p2 and curtime>pscmrdelayofbosccheck_p2 then
pscmrdelayofbosccheck_p2=curtime+1


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
			pscmroncombatstartcheckboss_p2(id)
			pscmrdelayofbosccheck_p2=nil
		end
	end
end


--hunter die delay

if psicchunterdiedelay and curtime>psicchunterdiedelay then
psicchunterdiedelay=nil


psicchunterdiedelaytable=nil
psicchunterdiedelayboss=nil
end







end

function pscmroncombatstartcheckboss_p2(id)

if psbossblock==nil then

SetMapToCurrentZone()
if GetCurrentMapAreaID()==pslocations[2][5] then
  pscmrcheckforevade_p2=GetTime()+10
end


--ыыытест новые боссы прописывать тут (2 места)



if GetCurrentMapAreaID()==pslocations[2][5] then
	if (id==69465) and psbossfilep51 then
		pswasonbossp51=1
	end
	if (id==68476) and psbossfilep52 then
		pswasonbossp52=1
	end
	if (id==69078 or id==69132 or id==69134 or id==69131) and psbossfilep53 then
		pswasonbossp53=1
	end
	if (id==67977) and psbossfilep54 then
		pswasonbossp54=1
	end
	if (id==68065 or id==70212 or id==70235 or id==70247) and psbossfilep55 then
		pswasonbossp55=1
	end
	if (id==69712) and psbossfilep56 then
		pswasonbossp56=1
	end
	if (id==68036) and psbossfilep57 then
		pswasonbossp57=1
	end
	if (id==69017) and psbossfilep58 then
		pswasonbossp58=1
	end
	if (id==69427) and psbossfilep59 then
		pswasonbossp59=1
	end
	if (id==68079 or id==68080 or id==68081 or id==68078) and psbossfilep510 then
		pswasonbossp510=1
	end
	if (id==68905 or id==68904) and psbossfilep511 then
		pswasonbossp511=1
	end
	if (id==68397) and psbossfilep512 then
		pswasonbossp512=1
	end
	if (id==62983) and psbossfilep513 then
		pswasonbossp513=1
	end
end


end

end


function psoneventpanda2(self,event,...)


--if GetNumGroupMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

--ыытест босс блок добавить?! хрен знает нада ли, но в течении 5 сек после кила не смотрит лог?!
if event == "COMBAT_LOG_EVENT_UNFILTERED" then

local arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15 = ...

--Inst 5
if GetCurrentMapAreaID()==pslocations[2][5] then






if pswasonbossp51 then
pscombatlogbossp51(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp52 then
pscombatlogbossp52(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp53 then
pscombatlogbossp53(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp54 then
pscombatlogbossp54(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp55 then
pscombatlogbossp55(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp56 then
pscombatlogbossp56(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp57 then
pscombatlogbossp57(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp58 then
pscombatlogbossp58(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp59 then
pscombatlogbossp59(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp510 then
pscombatlogbossp510(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp511 then
pscombatlogbossp511(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp512 then
pscombatlogbossp512(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp513 then
pscombatlogbossp513(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
else

pscombatlogbossp51(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp52(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp53(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp54(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp55(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp56(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp57(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp58(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp59(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp510(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp511(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp512(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp513(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)

end

end
--inst 5 end


--res to reset info
if arg2=="SPELL_RESURRECT" and (spellid==83968 or spellid==7328 or spellid==50769 or spellid==2008 or spellid==2006) then
psiccwipereport_p2(nil,"try")
end


else

--остальные евенты

local arg1, arg2, arg3,arg4,arg5,arg6 = ...

if event == "PLAYER_REGEN_DISABLED" then


if (psbilresnut and GetTime()<psbilresnut+3) or pscheckbossincombat then


else

--тут резет всего в начале боя ыытест


pselegontabldamage2={{},{},{},{}}
table.wipe (pselegontabldamage2[1])
table.wipe (pselegontabldamage2[2])
table.wipe (pselegontabldamage2[3])
table.wipe (pselegontabldamage2[4])



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
pscmroncombatstartcheckboss_p2(id)
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
    --if pswasonbossp42 then
    --  psrezetnotcombp2=GetTime()+3
    --else
      psrezetnotcombp2=GetTime()+5
    --end
	end
end



if event == "ZONE_CHANGED_NEW_AREA" then


psiccwipereport_p2(nil,"try")
pscatamrdelayzone_p2=GetTime()+3


end


if event == "CHAT_MSG_ADDON" then


end

if event =="CHAT_MSG_MONSTER_EMOTE" then



end

if event=="CHAT_MSG_RAID_BOSS_EMOTE" then

if arg1 and string.find(arg1,136769) and arg2 ~= arg5 then
  --сей анонсер
  if ps_saoptions[2][5][2][1]==1 then
    ps_sa_sendinfo(arg5, GetSpellInfo(136769).." "..psmain_sa_phrase1, 6, nil, nil)
  end
end

end




if event == "ADDON_LOADED" then

if arg1=="PhoenixStyleMod_Panda_tier2" then



local psiccnewveranoncet={}
if GetLocale()=="ruRU" then
psiccnewveranoncet={}
end 




pslastmoduleloadtxt=pscmrlastmoduleloadtxtp1


--перенос переменных

pscmrpassvariables_p2()



	if psraidoptionson[2][5]==nil then psraidoptionson[2][5]={}
	end
	for j=1,#psraidoptionsonp2[1] do
		if psraidoptionson[2][5][j]==nil then
			psraidoptionson[2][5][j]={}
		end
		for t=1,#psraidoptionsonp2[1][j] do
			if psraidoptionson[2][5][j][t]==nil then
				psraidoptionson[2][5][j][t]=psraidoptionsonp2[1][j][t]
			end
		end
	end

	if psraidoptionstxt[5]==nil then psraidoptionstxt[5]={}
	end
	for j=1,#psraidoptionstxtp2[1] do
		if psraidoptionstxt[5][j]==nil then
			psraidoptionstxt[5][j]={}
		end
		for t=1,#psraidoptionstxtp2[1][j] do
			if psraidoptionstxt[5][j][t]==nil then
				psraidoptionstxt[5][j][t]=psraidoptionstxtp2[1][j][t]
			end
		end
	end








--ыытест что мы тут убирали, тестим
--psraidoptionstxtp2=nil



--psraidoptionstxtp21=nil
--psraidoptionstxtp22=nil
--psraidoptionstxtp23=nil
--psraidoptionstxtp24=nil

	if psraidoptionschat[2][5]==nil then psraidoptionschat[2][5]={}
	end
	for j=1,#psraidoptionschatp2[1] do
		if psraidoptionschat[2][5][j]==nil then
			psraidoptionschat[2][5][j]={}
		end
		for t=1,#psraidoptionschatp2[1][j] do
			if psraidoptionschat[2][5][j][t]==nil then
				psraidoptionschat[2][5][j][t]=psraidoptionschatp2[1][j][t]
			end
		end
	end




--boss manual localization update



end
end
--остальные евенты конец





end --рейд


end --КОНЕЦ ОНЕВЕНТ


--tryorkill - if try then true, if kill - nil, reset - only reset no report
--pswasonboss42 1 если мы в бою с боссом и трекерим, 2 если вайпнулись и продолжаем трекерить ПОСЛЕ анонса
function psiccwipereport_p2(wipe, tryorkill, reset, checkforwipe)
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
	psiccrepupdate_p2=pszapuskdelayphasing
	pszapuskdelayphasing=0
	if psiccrepupdate_p2>7 then psiccrepupdate_p2=7 end
	psiccrepupdate_p2=psiccrepupdate_p2+GetTime()
	psdelcount1=wipe
	psdelcount2=tryorkill
	psdelcount3=reset
	else

		if psiccrepupdate_p2==nil then

--ыыытест новые боссы прописывать тут (2 места)
pscmrcheckforevade_p2=nil



if (pswasonbossp51) then
pscmrbossREPORTp511(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp511(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp52) then
pscmrbossREPORTp521(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp521(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp53) then
pscmrbossREPORTp531(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp531(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp54) then
pscmrbossREPORTp541(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp541(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp55) then
pscmrbossREPORTp551(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp551(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp56) then
pscmrbossREPORTp561(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp561(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp57) then
pscmrbossREPORTp571(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp571(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp58) then
pscmrbossREPORTp581(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp581(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp59) then
pscmrbossREPORTp591(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp591(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp510) then
pscmrbossREPORTp5101(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp5101(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp511) then
pscmrbossREPORTp5111(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp5111(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp512) then
pscmrbossREPORTp5121(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp5121(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp513) then
pscmrbossREPORTp5131(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp5131(wipe, tryorkill, reset, checkforwipe)
end


		end

	end

if wipe==nil and psbossblock==nil then
psbossblock=GetTime()
end

end


function pscmrpassvariables_p2()

if psraidoptionschatp2==nil then psraidoptionschatp2={} end

for i=1,#psraidoptionschatdefp2 do
	if psraidoptionschatp2[i]==nil then
		psraidoptionschatp2[i]={}
	end
	for j=1,#psraidoptionschatdefp2[i] do
		if psraidoptionschatp2[i][j]==nil then
			psraidoptionschatp2[i][j]={}
		end
		for t=1,#psraidoptionschatdefp2[i][j] do
			if psraidoptionschatp2[i][j][t]==nil or (psraidoptionschatp2[i][j][t] and psraidoptionschatp2[i][j][t]==0) then
				psraidoptionschatp2[i][j][t]=psraidoptionschatdefp2[i][j][t]
			end
		end
	end
end

if psraidoptionsonp2==nil then psraidoptionsonp2={} end

for i=1,#psraidoptionstxtp2 do
	if psraidoptionsonp2[i]==nil then
		psraidoptionsonp2[i]={}
	end
	for j=1,#psraidoptionschatdefp2[i] do
		if psraidoptionsonp2[i][j]==nil then
			psraidoptionsonp2[i][j]={}
		end
		for t=1,#psraidoptionschatdefp2[i][j] do
			if psraidoptionsonp2[i][j][t]==nil then
				psraidoptionsonp2[i][j][t]=psraidoptionschatdefp2[i][j][t]
			end
		end
	end
end

end