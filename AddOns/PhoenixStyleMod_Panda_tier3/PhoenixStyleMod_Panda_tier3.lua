function psloadpanda3()

pslocalepandam3()

if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="zhCN" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" then
pslocalepanda3()
end

--description of the menu
psraidoptionstxtp3={}
psraidoptionstxtp3[1]={{"|tip2 "..psmainmdamagefrom.." |sid143412|id", "|tip2 "..psmainmdamagefrom.." |sid143436|id","|tip2 "..psmainmdamagefrom.." |sid143297|id ("..format(psnofirstsec,1)..")"},
{"|tip2 "..psmainmdamagefrom.." |sid144397|id","|tip2 "..psmainmdamagefrom.." |sid143009|id ("..format(psnofirstsec,1)..")","|tip2 "..psmainmdamagefrom.." |sid144367|id"},
{"|tip2 "..psmainmdamagefrom.." |sid145227|id"},
{"|tip2 "..psmainmdamagefrom.." |sid144788|id",pszzpandatuaddopttxt2.." (|sid144358|id)","|tip2 "..psmainmdamagefrom.." |sid144911|id","|tip2 "..psmainmdamagefrom.." |sid147198|id"},
{"|tip2 "..psmainmdamagefrom.." |sid147824|id","|tip2 "..psmainmdamagefrom.." |sid147688|id","|tip2 "..psmainmdamagefrom.." |sid146769|id"},
{"|tip2 "..psmainmdamagefrom.." |sid144316|id"},
{"|tip2 "..psmainmdamagefrom.." |sid144070|id","|tip2 "..psmainmdamagefrom.." |sid144334|id","|tip2 "..psmainmdamagefrom.." |sid143993|id","|tip2 "..psmainmdamagefrom.." |sid144030|id"},
{"|tip2 "..psmainmdamagefrom.." |sid143712|id","|tip2 "..psmainmdamagefrom.." |sid143873|id", "|tip1 "..pszzpandatuaddopttxt3.." |sid143593|id", "|tip2 "..pszzpandatuaddopttxt3.." |sid143593|id"},
{"|tip2 "..psmainmdamagefrom.." |sid142815|id","|tip1 "..pszzpandatuaddopttxt1,"|tip2 "..psmainmdamagefrom.." |sid142816|id","|tip2 "..psmainmdamagefrom.." |sid142849|id"},
{"|tip2 "..psmainmdamagefrom.." |sid145993|id"},
{"|tip2 "..psmainmdamagefrom.." |sid148143|id"},
{"|tip2 "..psmainmdamagefrom.." |sid143327|id","|tip2 "..psmainmdamagefrom.." |sid144335|id","|tip2 "..psmainmdamagefrom.." |sid144662|id","|tip2 "..psmainmdamagefrom.." |sid144210|id","|tip2 "..psmainmgot.." |sid143856|id"},
{"|tip2 "..psmainmdamagefrom.." |sid142232|id","|tip2 "..psmainmdamagefrom.." |sid142950|id"},
{"|tip2 "..psmainmdamagefrom.." |sid144650|id","|tip2 "..psmainmdamagefrom.." |sid144969|id"}
}


for i=1,#psraidoptionstxtp3 do
	for j=1,#psraidoptionstxtp3[i] do
		for k=1,#psraidoptionstxtp3[i][j] do
			psraidoptionstxtp3[i][j][k]=psspellfilter(psraidoptionstxtp3[i][j][k])
		end
	end
end

--chat settings 1 or 2 or 3
psraidoptionschatdefp3={}
psraidoptionschatdefp3[1]={{1,1,1},
{1,1,1},
{1},
{1,1,1,1},
{1,1,1},
{1},
{1,1,1,1},
{1,1,1,1},
{1,1,1,1},
{1},
{1},
{1,1,1,1,1},
{1,1},
{1,1}
}



--chat settings on or off
psraidoptionsondefp2={}
psraidoptionsondefp2[1]={{1,1,1},
{1,1,1},
{1},
{1,1,1,1},
{1,1,1},
{1},
{1,1,1,1},
{1,1,1,1},
{1,1,1,1},
{1},
{1},
{1,1,1,1,1},
{1,1},
{1,1}
}





SetMapToCurrentZone()
if GetCurrentMapAreaID()==pslocations[2][6] then
	PhoenixStyleMod_Panda3:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
	PhoenixStyleMod_Panda3:RegisterEvent("PLAYER_REGEN_DISABLED")
	PhoenixStyleMod_Panda3:RegisterEvent("PLAYER_REGEN_ENABLED")
	PhoenixStyleMod_Panda3:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	PhoenixStyleMod_Panda3:RegisterEvent("ADDON_LOADED")
	PhoenixStyleMod_Panda3:RegisterEvent("CHAT_MSG_ADDON")
	PhoenixStyleMod_Panda3:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	PhoenixStyleMod_Panda3:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	

end



--онапдейт
function psonupdatepanda3(curtime)





--тут всякие онапдейт модули




-- малкорок, задел более 0 (танка не должно трогать) человека конусной атакой
if pspanogmalrokcone2 and curtime>pspanogmalrokcone2 then
  pspanogmalrokcone2=nil
  if #pspanogmalrokcone1>0 then
    local text=""
    for i=1,#pspanogmalrokcone1 do
      text=text..psaddcolortxt(1,pspanogmalrokcone1[i])..pspanogmalrokcone1[i]..psaddcolortxt(2,pspanogmalrokcone1[i])
      if i<8 then
        if i==7 then
          text=text..", ..."
        else
          if i==#pspanogmalrokcone1 then
            text=text.."."
          else
            text=text..", "
          end
        end
      end
    end

    --репорт в чат и в фрейм
    if psraidoptionson[2][6][9][2]==1 and pswasonbossp69==1 then -- ыытест select(3,GetInstanceInfo())~=7 добавить в репорт для лфр
      pszapuskanonsa(psraidchats3[psraidoptionschat[2][6][9][2]], "{rt8} |s4id142849|id ("..#pspanogmalrokcone1.."): "..psremovecolor(text))
    end
  end
  pspanogmalrokcone1=nil
end


if psgenstoika and (GetTime()-psgenstoika)>75 then
  psgenstoika=nil
  table.wipe(vezaxname3)
  table.wipe(vezaxcrash3)
end








--reset not in combat
if psrezetnotcombp3 and curtime>psrezetnotcombp3 then
	local a=GetSpellInfo(20711)
	local b=UnitBuff("player", a)
	if UnitAffectingCombat("player")==nil and UnitIsDeadOrGhost("player")==nil and b==nil then --and UnitName("boss1")
		psiccwipereport_p3(nil,"try")
		psrezetnotcombp3=nil
	end
end




--evade after 3 sec
if pscmrcheckforevade_p3 and curtime>pscmrcheckforevade_p3 then
pscmrcheckforevade_p3=pscmrcheckforevade_p3+7
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
psiccwipereport_p3(nil,"try")
end
end



if pscatamrdelayzone_p3 and curtime>pscatamrdelayzone_p3 then
pscatamrdelayzone_p3=nil
local a1, a2, a3, a4, a5 = GetInstanceInfo()
if UnitInRaid("player") or (a2=="raid" or (a2=="party" and a3==2)) then
SetMapToCurrentZone()
end
if GetCurrentMapAreaID()==pslocations[2][6] then
PhoenixStyleMod_Panda3:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
else
PhoenixStyleMod_Panda3:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
end

--announce delay for phasing
if psiccrepupdate_p3 and curtime>psiccrepupdate_p3 then
psiccrepupdate_p3=nil
psiccwipereport_p3(psdelcount1,psdelcount2,psdelcount3)
psdelcount1=nil
psdelcount2=nil
psdelcount3=nil
end


--прерванные бои
if pscheckbossincombatmcr_p3 and GetTime()>pscheckbossincombatmcr_p3 then
	pscheckbossincombatmcr_p3=pscheckbossincombatmcr_p3+2


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
		pscheckbossincombatmcr_p3=nil
		pscheckbossincombatmcr_p32=GetTime()+1
	end
end

if pscheckbossincombatmcr_p32 and GetTime()>pscheckbossincombatmcr_p32 then
	pscheckbossincombatmcr_p32=nil
	if psbossblock==nil then
		psiccwipereport_p3(nil, nil, "reset")
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
			pscmroncombatstartcheckboss_p3(id)
		else
			pscmrdelayofbosccheck_p3=GetTime()+1
		end
	else
		pscmrdelayofbosccheck_p3=GetTime()+1
	end
end


--постоянная проверка по ходу боя...
if pscmrdelayofbosccheck_p3 and curtime>pscmrdelayofbosccheck_p3 then
pscmrdelayofbosccheck_p3=curtime+1


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
			pscmroncombatstartcheckboss_p3(id)
			pscmrdelayofbosccheck_p3=nil
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

function pscmroncombatstartcheckboss_p3(id)

if psbossblock==nil then

SetMapToCurrentZone()
if GetCurrentMapAreaID()==pslocations[2][6] then
  pscmrcheckforevade_p3=GetTime()+10
end


--ыыытест новые боссы прописывать тут (2 места)



if GetCurrentMapAreaID()==pslocations[2][6] then
	if (id==71543 or id==72436) and psbossfilep61 then
		pswasonbossp61=1
	end
	if (id==71479 or id==71475 or id==71480) and psbossfilep62 then
		pswasonbossp62=1
	end
	if (id==72276) and psbossfilep63 then
		pswasonbossp63=1
	end
	if (id==71734) and psbossfilep64 then
		pswasonbossp64=1
	end
	if (id==72249) and psbossfilep65 then
		pswasonbossp65=1
	end
	if (id==71466) and psbossfilep66 then
		pswasonbossp66=1
	end
	if (id==71859 or id==71858) and psbossfilep67 then
		pswasonbossp67=1
	end
	if (id==71515) and psbossfilep68 then
		pswasonbossp68=1
	end
	if (id==71454) and psbossfilep69 then
		pswasonbossp69=1
	end
	if (id==71889) and psbossfilep610 then
		pswasonbossp610=1
	end
	if (id==71529) and psbossfilep611 then
		pswasonbossp611=1
	end
	if (id==71504) and psbossfilep612 then
		pswasonbossp612=1
	end
	if (id==71152 or id==71153 or id==71154 or id==71155 or id==71156 or id==71157 or id==71158 or id==71160 or id==71161) and psbossfilep613 then
		pswasonbossp613=1
	end
	if (id==71865) and psbossfilep614 then
		pswasonbossp614=1
	end
end


end

end


function psoneventpanda3(self,event,...)


if event == "COMBAT_LOG_EVENT_UNFILTERED" then

local arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18 = ...

--Inst 6
if GetCurrentMapAreaID()==pslocations[2][6] then






if pswasonbossp61 then
pscombatlogbossp61(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp62 then
pscombatlogbossp62(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp63 then
pscombatlogbossp63(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp64 then
pscombatlogbossp64(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp67(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp65 then
pscombatlogbossp65(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp66 then
pscombatlogbossp66(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp67 then
pscombatlogbossp67(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp68 then
pscombatlogbossp68(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp69 then
pscombatlogbossp69(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp610 then
pscombatlogbossp610(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp611 then
pscombatlogbossp611(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp612 then
pscombatlogbossp612(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp613 then
pscombatlogbossp613(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
elseif pswasonbossp614 then
pscombatlogbossp614(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18)
else

pscombatlogbossp61(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp62(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp63(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp64(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp65(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp66(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp67(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp68(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp69(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp610(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp611(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp612(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp613(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)
pscombatlogbossp614(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18)

end

end
--inst 6 end


--res to reset info
if arg2=="SPELL_RESURRECT" and (spellid==83968 or spellid==7328 or spellid==50769 or spellid==2008 or spellid==2006) then
psiccwipereport_p3(nil,"try")
end


else

--остальные евенты

local arg1, arg2, arg3,arg4,arg5,arg6 = ...

if event == "PLAYER_REGEN_DISABLED" then


if (psbilresnut and GetTime()<psbilresnut+3) or pscheckbossincombat then


else

--тут резет всего в начале боя ыытест


pselegontabldamage3={{},{},{},{}}
table.wipe (pselegontabldamage3[1])
table.wipe (pselegontabldamage3[2])
table.wipe (pselegontabldamage3[3])
table.wipe (pselegontabldamage3[4])



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
pscmroncombatstartcheckboss_p3(id)
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
    --  psrezetnotcombp3=GetTime()+3
    --else
      psrezetnotcombp3=GetTime()+5
    --end
	end
end



if event == "ZONE_CHANGED_NEW_AREA" then


psiccwipereport_p3(nil,"try")
pscatamrdelayzone_p3=GetTime()+3


end


if event == "CHAT_MSG_ADDON" then


end

if event =="CHAT_MSG_MONSTER_EMOTE" then



end

if event=="CHAT_MSG_RAID_BOSS_EMOTE" then



end




if event == "ADDON_LOADED" then

if arg1=="PhoenixStyleMod_Panda_tier3" then



local psiccnewveranoncet={}
if GetLocale()=="ruRU" then
psiccnewveranoncet={}
end 




pslastmoduleloadtxt=pscmrlastmoduleloadtxtp1


--перенос переменных

pscmrpassvariables_p3()



	if psraidoptionson[2][6]==nil then psraidoptionson[2][6]={}
	end
	for j=1,#psraidoptionsonp3[1] do
		if psraidoptionson[2][6][j]==nil then
			psraidoptionson[2][6][j]={}
		end
		for t=1,#psraidoptionsonp3[1][j] do
			if psraidoptionson[2][6][j][t]==nil then
				psraidoptionson[2][6][j][t]=psraidoptionsonp3[1][j][t]
			end
		end
	end

	if psraidoptionstxt[6]==nil then psraidoptionstxt[6]={}
	end
	for j=1,#psraidoptionstxtp3[1] do
		if psraidoptionstxt[6][j]==nil then
			psraidoptionstxt[6][j]={}
		end
		for t=1,#psraidoptionstxtp3[1][j] do
			if psraidoptionstxt[6][j][t]==nil then
				psraidoptionstxt[6][j][t]=psraidoptionstxtp3[1][j][t]
			end
		end
	end








--ыытест что мы тут убирали, тестим
--psraidoptionstxtp3=nil



--psraidoptionstxtp31=nil
--psraidoptionstxtp32=nil
--psraidoptionstxtp33=nil
--psraidoptionstxtp34=nil

	if psraidoptionschat[2][6]==nil then psraidoptionschat[2][6]={}
	end
	for j=1,#psraidoptionschatp3[1] do
		if psraidoptionschat[2][6][j]==nil then
			psraidoptionschat[2][6][j]={}
		end
		for t=1,#psraidoptionschatp3[1][j] do
			if psraidoptionschat[2][6][j][t]==nil then
				psraidoptionschat[2][6][j][t]=psraidoptionschatp3[1][j][t]
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
function psiccwipereport_p3(wipe, tryorkill, reset, checkforwipe)
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
	psiccrepupdate_p3=pszapuskdelayphasing
	pszapuskdelayphasing=0
	if psiccrepupdate_p3>7 then psiccrepupdate_p3=7 end
	psiccrepupdate_p3=psiccrepupdate_p3+GetTime()
	psdelcount1=wipe
	psdelcount2=tryorkill
	psdelcount3=reset
	else

		if psiccrepupdate_p3==nil then

--ыыытест новые боссы прописывать тут (2 места)
pscmrcheckforevade_p3=nil



if (pswasonbossp61) then
pscmrbossREPORTp611(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp611(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp62) then
pscmrbossREPORTp621(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp621(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp63) then
pscmrbossREPORTp631(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp631(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp64) then
pscmrbossREPORTp641(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp641(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp65) then
pscmrbossREPORTp651(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp651(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp66) then
pscmrbossREPORTp661(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp661(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp67) then
pscmrbossREPORTp671(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp671(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp68) then
pscmrbossREPORTp681(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp681(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp69) then
pscmrbossREPORTp691(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp691(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp610) then
pscmrbossREPORTp6101(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp6101(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp611) then
pscmrbossREPORTp6111(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp6111(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp612) then
pscmrbossREPORTp6121(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp6121(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp613) then
pscmrbossREPORTp6131(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp6131(wipe, tryorkill, reset, checkforwipe)
end

if (pswasonbossp614) then
pscmrbossREPORTp6141(wipe, tryorkill, reset, checkforwipe)
pscmrbossRESETp6141(wipe, tryorkill, reset, checkforwipe)
end


		end

	end

if wipe==nil and psbossblock==nil then
psbossblock=GetTime()
end

end


function pscmrpassvariables_p3()

if psraidoptionschatp3==nil then psraidoptionschatp3={} end

for i=1,#psraidoptionschatdefp3 do
	if psraidoptionschatp3[i]==nil then
		psraidoptionschatp3[i]={}
	end
	for j=1,#psraidoptionschatdefp3[i] do
		if psraidoptionschatp3[i][j]==nil then
			psraidoptionschatp3[i][j]={}
		end
		for t=1,#psraidoptionschatdefp3[i][j] do
			if psraidoptionschatp3[i][j][t]==nil or (psraidoptionschatp3[i][j][t] and psraidoptionschatp3[i][j][t]==0) then
				psraidoptionschatp3[i][j][t]=psraidoptionschatdefp3[i][j][t]
			end
		end
	end
end

if psraidoptionsonp3==nil then psraidoptionsonp3={} end

for i=1,#psraidoptionstxtp3 do
	if psraidoptionsonp3[i]==nil then
		psraidoptionsonp3[i]={}
	end
	for j=1,#psraidoptionschatdefp3[i] do
		if psraidoptionsonp3[i][j]==nil then
			psraidoptionsonp3[i][j]={}
		end
		for t=1,#psraidoptionschatdefp3[i][j] do
			if psraidoptionsonp3[i][j][t]==nil then
				psraidoptionsonp3[i][j][t]=psraidoptionschatdefp3[i][j][t]
			end
		end
	end
end

end