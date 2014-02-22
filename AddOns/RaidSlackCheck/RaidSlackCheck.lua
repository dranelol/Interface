function rsc_onload()

rsclocale()
if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="zhTW" or GetLocale()=="zhCN" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" or GetLocale()=="ptBR" then
rsclocalel()
end

rscversion=5.420


--zone ID where addon check flasks

rscignorezonedef={{953},{"Siege of Orgrimmar"}}




--==============POTIONS=============
rscpotiontable = {

-- BC
--28494,	-- Insane Strength Potion
--38929,	-- Fel mana potion

-- WOTLK
--53909,	-- Potion of Wild Magic
--53908,	-- Potion of Speed
--53750,	-- Crazy Alchemist's Potion
--53761,	-- Powerful Rejuvenation Potion
--43185,	-- Healing Potion
--43186,	-- Restore Mana
--53753,	-- Nightmare Slumber
--53910,	-- Arcane Protection
--53911,	-- Fire Protection 
--53913,	-- Frost Protection
--53914,	-- Nature Protection
--53915,	-- Shadow Protection
--53762,	-- Indestructible
--67490,	-- runic mana

-- CATACLYSM
--93932,--Draught of War
--79634,--Golemblood Potion
--78992,--Mighty Rejuvenation Potion
--78778,--Mysterious Potion
--78989,--Mythical Healing Potion
--78990,--Mythical Mana Potion
--78993,--Potion of Concentration
--79633,--Potion of the Tol'vir
--79476,--Volcanic Potion
--79475, --Earthen Potion

--Pandaria
105704, --Alchemist's Rejuvenation
105708, --Healing Potion
105709, --Restore Mana
105706, --Potion of Mogu Power
105701, --Potion of Focus
105697, --Virmen's Bite
105702, --Potion of the Jade Serpent
105698, --Potion of the Mountains
}

--==============FOOD=================
rscfoodtable={
	--57356, -- Rhinolicious Wormsteak
	--57358, -- Hearty Rhino
	--57360, -- Snapper Extreme/Worg Tartare
	--57367, -- Blackened Dragonfin
	--57365, -- Cuttlesteak
	--57371, -- Dragonfin Filet
	--57399, -- Fish Feast
	--57329, -- Spiced Worm Burger/Spicy Blue Nettlefish
	--57332, -- Imperial Manta Steak/Very Burnt Worg
	--57327, -- Firecracker Salmon/Tender Shoveltusk Steak
	--57325, -- Mega Mammoth Meal/Poached Northern Sculpin
	--57334, -- Mighty Rhino Dogs/Spicy Fried Herring
	--87551, --Baked Rockfish
	--87552, --Basilisk Liverdog
	--87545, --Beer-Basted Crocolisk
	--87555, --Blackbelly Sushi
	 --Broiled Dragon Feast --слабый стол в кате http://cata.wowhead.com/item=62289#comments
	--87635, --Crocolisk Au Gratin
	--87548, --Delicious Sagefish Tail
	--87558, --Goblin Barbecue --60
	--87550, --Grilled Dragon
	--87549, --Lavascale Minestrone
	--87554, --Mushroom Sauce Mudfish
	-- Seafood Magnifique Feast http://cata.wowhead.com/item=62290#created-by стол в кате
	--87547, --Severed Sagefish Head
	--87546, --Skewered Eel


--Pandaria
  -- +415??
  --104282,
  -- +300 stats:
  146804, -- new
  146805, -- new
  146806, -- new
  146807, -- new
  146808, -- new 450 stam
  146809, -- new 5.4
  101618, -- new
  104272,
  104277,
  104275,
  104280,
  104283, --450 sta
  
  
  --104281, -- 375 Sta

}

--таблица для ДОП еды, активируется по опции
rscfoodtable_additional={

  -- +275 stats:
  104271,
  104274,
  104276,
  104282,
  104279,
  101617, -- new highest stat feast 275
  104282, -- +415 Stamina
  

}

rscfoodtable_additional2={

 -- +250 stats: low food21.
 104264, -- Intellect 
 104267, -- Strength23
 104273, -- Agility24
 104278, -- Spirit25
 104281, -- 375 Stamina
}

--==============FLASKS===============
rscflasktable={
	--17627, -- Distilled Wisdom
	--53752, -- Lesser Flask of Toughness
	--53755, -- Flask of the Frost Wyrm
	--53758, -- Flask of Stoneblood
	--53760, -- Flask of Endless Rage
	--54212, -- Flask of Pure Mojo
	--62380, -- Lesser Flask of Resistance
	
	--92679, --Flask of Battle
	--94160, --Flask of Flowing Water
	--79469, --Flask of Steelskin
	--79470, --Flask of the Draconic Mind
	--79471, --Flask of the Winds
	--79472, --Flask of Titanic Strength
	
--Pandaria
  105693, --Flask of Falling Leaves
  105689, --Flask of Spring Blossoms
  105694, --Flask of the Earth
  105691, --Flask of the Warm Sun
  105696, --Flask of Winter's Bite
  
}

rscflasktableold={
	92679, --Flask of Battle
	94160, --Flask of Flowing Water
	79469, --Flask of Steelskin
	79470, --Flask of the Draconic Mind
	79471, --Flask of the Winds
	79472, --Flask of Titanic Strength
	--the same flasks with different ID ?!
	92730,
	92729,
	92725,
	92731,
	
	--alchemy
	79640,
	79639,
	79638,
	
	105617,
	
	127230, --Visions of Insanity
}

--=============ELIXIRS guard=========
rscelixirtable1={
	--53747, -- Elixir of Spirit
	--53763, -- Elixir of Protection
	--60347, -- Elixir of Mighty Thoughts
	--53764, -- Elixir of Mighty Mageblood
	--53751, -- Elixir of Mighty Fortitude
	--60343, -- Elixir of Mighty Defense

	--79480, --Elixir of Deep Earth
	--79631, --Prismatic Elixir
	--89345, --Stamina scroll
	--89344, --Armor Scroll
	
	--Pandaria
	105687, --Elixir of Mirrors
	105681, --mantid-elixir
}

--=============ELIXIRS battle=========
rscelixirtable2={
	--53746, -- Wrath Elixir
	--53749, -- Guru's Elixir
	--53748, -- Elixir of Mighty Strength
	--28497, -- Elixir of Mighty Agility
	--60346, -- Elixir of Lightning Speed
	--60344, -- Elixir of Expertise
	--60341, -- Elixir of Deadly Strikes
	--60345, -- Elixir of Armor Piercing
	--60340, -- Elixir of Accuracy
	--33721, -- Spellpower Elixir

	--79481, --Elixir of Impossible Accuracy
	--79468, --Ghost Elixir
	--79474, --Elixir of the Naga
	--79477, --Elixir of the Cobra
	--79632, --Elixir of Mighty Speed
	--79635, --Elixir of the Master
	--89343, --Agility Scroll
	--89346, --Strength Scroll
	--89347, --Intellect Scroll
	--89342, --Spirit Scroll
	
	--Pandaria
	105685, --elixir-of-peace
	105686, --elixir-of-perfection
	105684, --elixir-of-the-rapids
	105683, --elixir-of-weaponry
	105688, --monks-elixir
	105682, --mad-hozen-elixir

  109933,
}


--Announses!

--==========FOOD TABLE============
rscfoodmanytable={
--87643,
--87644,
--87915,
126503, --Banquet of the Brew
126497, --Banquet of the Pot
126492,
126501,
126499,
126495,
126504,
126494,
126502,
126498,
126500,
126496,
105193,
104958,
145166,
145169,
145196,
}

rscfoodmanytable_add={
0,
rscadditionalstat2,
rscadditionalstat5,
rscadditionalstat1,
rscadditionalstat3,
rscadditionalstat4,
0,
rscadditionalstat5,
rscadditionalstat1,
rscadditionalstat2,
rscadditionalstat3,
rscadditionalstat4,
0,
0,
}


--==========FLASK TABLE========
rscflaskmanytable={
--92712,
--92649,
}


--==========Repair robots ID========
rscrobotsid={
67826,
22700,
44389,
}


--=========Warlock HP ID==========
rsc_warlockhp={
29893,
}


	if(rscraidlrep==nil) then rscraidlrep=true end
	if(rsccolornick==nil) then rsccolornick=true end
	if rscchatrep==nil then rscchatrep="raid" end

	rscboy=0
	rscboynachat=0
	rscwasheroism=0
	rscwasyellpull=GetTime()
	rscherashowed=0
	rscsmotryuboy=1
	if rscraidrostertable==nil then rscraidrostertable={} end
	if rscpotioninfotable==nil then rscpotioninfotable={} end
	if rschealstoneused==nil then rschealstoneused={} end --кто ел камни
	if rschealstoneused2==nil then rschealstoneused2={} end --кто остался в рейде но не съел еще
	if rscchoosepotion==nil then rscchoosepotion={} end
	if rscbossnamestable==nil then rscbossnamestable={} end

	if rscpotionnotincombat==nil then rscpotionnotincombat={} end
	rsctrackison=0

	if rscpotionscombatsaves==nil then rscpotionscombatsaves=12 end
	if rsconlyfrombosssave==nil then rsconlyfrombosssave=false end

if rscflaskcheckfoodadd==nil then rscflaskcheckfoodadd=1 end
if rscflaskcheckfoodadd2==nil then rscflaskcheckfoodadd2=0 end

	--buff after rez
	if rscwhomustbufflist==nil then rscwhomustbufflist={"","","","","","","","",""} end
	if rscbuffschat==nil then rscbuffschat={"raid","raid"} end
	if rscbuffcheckb2==nil then rscbuffcheckb2={0,1,1,1,0,0} end
	if rscbuffwhichtrack2==nil then rscbuffwhichtrack2={1,1,0,0,0,0,0,0,0} end
	if rscbufftimers==nil then rscbufftimers={15,40} end

	rscrebirth1={} --rebirt awaiting
	rscrebirth2={} --names after reb
	rscrebirth3={} --time begin
	rscrebirth4={} --name for 2 check
	rscrebirth5={} --time for second check

	--check table and potion table
	if rsctableannounce==nil then rsctableannounce={0,0,0,0} end

	--flask check
	if rscminflaskgood==nil then rscminflaskgood=5 end
	if rscflaskcheckb==nil then rscflaskcheckb={1,1,1,0,0,1,1} end
	if rscflaskchat==nil then rscflaskchat={"raid","raid"} end
	rscflaskimportchat1={"whisp","raid"}
	rscflaskimportchat2={0,0}
	rscflaskdelayrep={0,0} -- whips i raid, delay но! цифра не геттайм а геттайм+делей, тоесть если просто больше моей значит репортить можно

	SLASH_RaidSlackCheck1 = "/raidslackcheck"
	SLASH_RaidSlackCheck2 = "/raidslack"
	SLASH_RaidSlackCheck3 = "/slack"
	SLASH_RaidSlackCheck4 = "/слак"
	SLASH_RaidSlackCheck5 = "/рейдслак"
	SLASH_RaidSlackCheck6 = "/rsc"
	SlashCmdList["RaidSlackCheck"] = RaidSlackCheck_Command


	rscframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	rscframe:RegisterEvent("PLAYER_REGEN_DISABLED")
	rscframe:RegisterEvent("PLAYER_REGEN_ENABLED")
	rscframe:RegisterEvent("PLAYER_ALIVE")
	rscframe:RegisterEvent("ADDON_LOADED")
	rscframe:RegisterEvent("CHAT_MSG_ADDON")
	rscframe:RegisterEvent("READY_CHECK")
	rscframe:RegisterEvent("PLAYER_ENTERING_WORLD")


end



function rsc_OnUpdate(curtime)

if rscreportdelay1 and curtime>rscreportdelay1 then
if curtime>rscreportdelay1+10 then
rscreportdelay1=nil
rsctabletoreport1=nil
else
	rscreportdelay1=nil
	if rscdelayannouncecheck1==nil or (rscdelayannouncecheck1 and GetTime()>rscdelayannouncecheck1+50) then
		local chat="raid"
		if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
			chat="raid_warning"
		end
		if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
      chat="Instance_CHAT"
		end
		for i=1,#rsctabletoreport1 do
			SendChatMessage(rsctabletoreport1[i], chat)
		end
	end
rsctabletoreport1=nil
end
end

if rscreportdelay2 and curtime>rscreportdelay2 then
if curtime>rscreportdelay2+10 then
rscreportdelay2=nil
rsctabletoreport2=nil
else
	rscreportdelay2=nil
	if rscdelayannouncecheck2==nil or (rscdelayannouncecheck2 and GetTime()>rscdelayannouncecheck2+50) then
		local chat="raid"
		if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
			chat="raid_warning"
		end
		if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
      chat="Instance_CHAT"
		end
		for i=1,#rsctabletoreport2 do
			SendChatMessage(rsctabletoreport2[i], chat)
		end
	end
rsctabletoreport2=nil
end
end

if rscreportdelay3 and curtime>rscreportdelay3 then
if curtime>rscreportdelay3+10 then
rscreportdelay3=nil
rsctabletoreport3=nil
else
	rscreportdelay3=nil
	if rscdelayannouncecheck3==nil or (rscdelayannouncecheck3 and GetTime()>rscdelayannouncecheck3+50) then
		local chat="raid"
		if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
			chat="raid_warning"
		end
		if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
      chat="Instance_CHAT"
		end
		for i=1,#rsctabletoreport3 do
			SendChatMessage(rsctabletoreport3[i], chat)
		end
	end
rsctabletoreport3=nil
end
end

if rscreportdelay4 and curtime>rscreportdelay4 then
if curtime>rscreportdelay4+10 then
rscreportdelay4=nil
rsctabletoreport4=nil
else
	rscreportdelay4=nil
	if rscdelayannouncecheck4==nil or (rscdelayannouncecheck4 and GetTime()>rscdelayannouncecheck4+50) then
		local chat="raid"
		if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
			chat="raid_warning"
		end
		if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
      chat="Instance_CHAT"
		end
		for i=1,#rsctabletoreport4 do
			SendChatMessage(rsctabletoreport4[i], chat)
		end
	end
rsctabletoreport4=nil
end
end


if rsccheckbossincombat and curtime>rsccheckbossincombat+1 then
rsccheckbossincombat=curtime
if UnitName("boss1") and UnitName("boss1")~="" then
else
rsccheckbossincombat=nil
end
end


if rscdelayforcombat and curtime>rscdelayforcombat+1.5 then
rscdelayforcombat=nil
if rscboy==0 and UnitIsDead("player")==nil and UnitIsDeadOrGhost("player")==nil and UnitName("boss1") and UnitName("boss1")~="" then
	rscnewcombatstart()
	rscnewcombatstartdelay=GetTime()
	rscnewcombattempdel=GetTime()+7
end
end



if rscnewcombattempdel and curtime>rscnewcombattempdel then
rscnewcombattempdel=nil
if UnitAffectingCombat("player")==nil and rscboy==1 then
rscboy=0
end
end


if rscdelaycheckbossbegin and curtime>rscdelaycheckbossbegin then
rscdelaycheckbossbegin=nil
if (UnitName("boss1") and UnitName("boss1")~="") then
rscwasyellpull=GetTime()
rscflaskcheckgo()
end
end


--flask report
if rscdelayreportstart and curtime>rscdelayreportstart+1.5 then
rscdelayreportstart=nil
rscreportslackwithflask("auto", rscflaskchat[1])
end

--removechatfilters
if rscchatfiltime and curtime>rscchatfiltime+11 then
rscchatfiltime=nil
ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", rscChatFilter)
end

--buffs check module
if 1==2 and rscbuffcheckb2[1] and rscbuffcheckb2[1]==1 then


--1 check
if #rscrebirth3>0 and ((rscrebnextupd and curtime>rscrebnextupd) or rscrebnextupd==nil) then

	if rscrebnextupd==nil then
		rscrebnextupd=rscrebirth3[1]
		for tt=1,#rscrebirth3 do
			if rscrebirth3[tt]<rscrebnextupd then
				rscrebnextupd=rscrebirth3[tt]
			end
		end
	end


	if rscrebnextupd and curtime>rscrebnextupd then
		rscrebnextupd=nil

		for yy=1,#rscrebirth3 do
			if rscrebirth3[yy] and curtime>rscrebirth3[yy] then
				--время после реса прошло, проверяем жив ли игрок и в бою ли он

				if UnitIsDeadOrGhost(rscrebirth2[yy])==nil and UnitAffectingCombat(rscrebirth2[yy]) and rscbuffcheckb2[1]==1 and (rscbuffcheckb2[2]==1 or rscbuffcheckb2[3]==1 or rscbuffcheckb2[4]==1 or rscbuffcheckb2[5]==1) and (rscbcanannounce==nil or (rscbcanannounce and GetTime()>rscbcanannounce+180)) then
					--игрок жив в бою, проверка бафов и репорты
					local strin="" --список бафов нету

					--1 модуль для всех

					local tablid={{20217,1126,90363,115921},{6307,469,21562,90364},{1459,61316,109773},{19740,116781,116956}} --ид бафов
					local buffnamelist={rscbuffnameslitnew1,rscbuffnameslitnew2,rscbuffnameslitnew4,rscbuffnameslitnew5}
					local classesnorm={{"PALADIN","DRUID","MONK"},{"PRIEST"},{"MAGE"},{"PALADIN","MONK"}}
					local buffnotneed={{}, {}, {"ROGUE","HUNTER","WARRIOR","DEATHKNIGHT"},{}} --не нужны бафы кому

					if rscspisokid then
					for x=1,#rscspisokid do
						if rscbuffwhichtrack2[x]==1 then
							local byl=0
							for z=1,#tablid[x] do
								local spbuf=GetSpellInfo(tablid[x][z])
								if spbuf and UnitBuff(rscrebirth2[yy], spbuf) then
									byl=1
								end
							end

							if byl==0 then
								if #buffnotneed[x]>0 then
                  local mnam=rscrebirth2[yy]
                  if string.len (mnam)>42 and string.find(mnam,"%-") then
                    mnam=string.sub(mnam,1,string.find(mnam,"%-")-1)
                  end
									local _, plclass = UnitClass(mnam)
									for ccc=1,#buffnotneed[x] do
										if plclass==buffnotneed[x][ccc] then
											byl=1
										end
									end
								end
							end

							if byl==0 then
								local classfound=0

									if rscbuffcheckb2[4]==1 then
										rscbuffcheckprioritylist(x,rscrebirth2[yy],buffnamelist[x],rscbufftimers[1])
									end
									if rscprioritytemp==nil then --только для 1 проверки
										for ee=1,GetNumGroupMembers() do local name, _, _, _, _, claass = GetRaidRosterInfo(ee)
											local sdc=0
											for trt=1,#classesnorm[x] do
												if classesnorm[x][trt]==claass then
													sdc=1
													classfound=1
												end
											end
											if sdc==1 and UnitIsDeadOrGhost(name)==nil and UnitAffectingCombat(name) then
												if rscbuffcheckb2[4]==1 then
													rscreportchatbyname(rscrebirth2[yy],name,rscbufftimers[1],buffnamelist[x],1)
												end
											end
										end
									else
										classfound=1
									end
								if classfound==1 then
									if string.len(strin)>1 then strin=strin..", "
									end
									strin=strin..buffnamelist[x]
								end
							end
						end
					end
					end



					if string.len(strin)>2 and rscbuffcheckb2[2]==1 then
						if UnitSex(rscrebirth2[yy]) and UnitSex(rscrebirth2[yy])==3 then
							rscreportchatnobufs(rscbuffschat[1],"{rt3}"..rscrebirth2[yy].." - "..rscreleasedtxt1f.." "..rscbufftimers[1].." "..rscsec.." "..rscreleasedtxt2..", "..rscreleasedtxt3..": "..strin)
						else
							rscreportchatnobufs(rscbuffschat[1],"{rt3}"..rscrebirth2[yy].." - "..rscreleasedtxt1.." "..rscbufftimers[1].." "..rscsec.." "..rscreleasedtxt2..", "..rscreleasedtxt3..": "..strin)
						end
					end
					


					--перенос таблиц на 2 проверку если они включены
					if string.len(strin)>2 and (rscbuffcheckb2[3]==1 or rscbuffcheckb2[5]==1) then
						table.insert(rscrebirth4,rscrebirth2[yy])
						table.insert(rscrebirth5,(rscrebirth3[yy]+(rscbufftimers[2]-rscbufftimers[1])))
					end

					--удаление таблиц
					table.remove(rscrebirth2,yy)
					table.remove(rscrebirth3,yy)								








				else
					table.remove(rscrebirth2,yy)
					table.remove(rscrebirth3,yy)
				end
			end
		end
	end
end










--2 check
if #rscrebirth5>0 and ((rscrebnextupd2 and curtime>rscrebnextupd2) or rscrebnextupd2==nil) then

	if rscrebnextupd2==nil then
		rscrebnextupd2=rscrebirth5[1]
		for tt=1,#rscrebirth5 do
			if rscrebirth5[tt]<rscrebnextupd2 then
				rscrebnextupd2=rscrebirth5[tt]
			end
		end
	end


	if rscrebnextupd2 and curtime>rscrebnextupd2 then
		rscrebnextupd2=nil
		for yy=1,#rscrebirth5 do
			if rscrebirth5[yy] and curtime>rscrebirth5[yy] then
				--время после реса прошло, проверяем жив ли игрок и в бою ли он
				if UnitIsDeadOrGhost(rscrebirth4[yy])==nil and UnitAffectingCombat(rscrebirth4[yy]) and rscbuffcheckb2[1]==1 and (rscbuffcheckb2[3]==1 or rscbuffcheckb2[5]==1) and (rscbcanannounce==nil or (rscbcanannounce and GetTime()>rscbcanannounce+180)) then
					--игрок жив в бою, проверка бафов и репорты
					local strin="" --список бафов нету


					--1 модуль для всех
					local tablid={{20217,1126,90363,115921},{6307,469,21562,90364},{1459,61316,109773},{19740,116781,116956}} --ид бафов
					local buffnamelist={rscbuffnameslitnew1,rscbuffnameslitnew2,rscbuffnameslitnew4,rscbuffnameslitnew5}
					local classesnorm={{"PALADIN","DRUID","MONK"},{"PRIEST"},{"MAGE"},{"PALADIN","MONK"}}
					local buffnotneed={{}, {}, {"ROGUE","HUNTER","WARRIOR","DEATHKNIGHT"},{}} --не нужны бафы кому

					if rscspisokid then
					for x=1,#rscspisokid do
						if rscbuffwhichtrack2[x]==1 then
							local byl=0
							for z=1,#tablid[x] do
								local spbuf=GetSpellInfo(tablid[x][z])
								if spbuf and UnitBuff(rscrebirth4[yy], spbuf) then
									byl=1
								end
							end

							if byl==0 then
								if #buffnotneed[x]>0 then
                  local mnam=rscrebirth4[yy]
                  if string.len (mnam)>42 and string.find(mnam,"%-") then
                    mnam=string.sub(mnam,1,string.find(mnam,"%-")-1)
                  end
									local _, plclass = UnitClass(mnam)
									for ccc=1,#buffnotneed[x] do
										if plclass==buffnotneed[x][ccc] then
											byl=1
										end
									end
								end
							end

							if byl==0 then
								local classfound=0
									if rscbuffcheckb2[5]==1 then
										rscbuffcheckprioritylist(x,rscrebirth4[yy],buffnamelist[x],rscbufftimers[2],classesnorm[x])
									end
									for ee=1,GetNumGroupMembers() do local name, _, _, _, _, claass = GetRaidRosterInfo(ee)
											local sdc=0
											for trt=1,#classesnorm[x] do
												if classesnorm[x][trt]==claass then
													sdc=1
													classfound=1
												end
											end
										if sdc==1 and UnitIsDeadOrGhost(name)==nil and UnitAffectingCombat(name) then
											if rscbuffcheckb2[5]==1 then
												rscreportchatbyname(rscrebirth4[yy],name,rscbufftimers[2],buffnamelist[x],2)
											end
										end
									end
								if classfound==1 then
									if string.len(strin)>1 then strin=strin..", "
									end
									strin=strin..buffnamelist[x]
								end
							end
						end
					end
					end


					if string.len(strin)>2 and rscbuffcheckb2[3]==1 then
						rscreportchatnobufs(rscbuffschat[2],"{rt4}"..rscrebirth4[yy].." - "..rscbufftimers[2].." "..rscsec.." "..rscreleasedtxt4..": "..strin.." ("..rscreleasedtxt5..")")
					end
					

					--удаление таблиц
					table.remove(rscrebirth4,yy)
					table.remove(rscrebirth5,yy)								



				else
					table.remove(rscrebirth4,yy)
					table.remove(rscrebirth5,yy)
				end
			end
		end
	end
end





end --buff check mod

end --onupd



function rsc_OnEvent(self,event,...)
local arg1, arg2, arg3,arg4,arg5,arg6 = ...

if event == "PLAYER_REGEN_DISABLED" then

rscboy=1

if (rscbilresnut and GetTime()<rscbilresnut+4) or rsccheckbossincombat then
rsccheckbossincombat=nil
else
--обнулять все данные при начале боя тут:


table.wipe(rscrebirth1)
table.wipe(rscrebirth2)
table.wipe(rscrebirth3)
table.wipe(rscrebirth4)
table.wipe(rscrebirth5)

if rscnewcombatstartdelay==nil or (rscnewcombatstartdelay and GetTime()>rscnewcombatstartdelay+5) then
	rscnewcombatstart()
end


end
end

if event == "PLAYER_REGEN_ENABLED" then
rscboy=0
rsccheckbossincombat=GetTime()
if rsclastfightdelay then
rsclastfightdelay=GetTime()
end
end


if event == "PLAYER_ALIVE" then
rscbilresnut=GetTime()
end

if event == "READY_CHECK" then
if rscflaskcheckb[3]==1 then
rscflaskcheckgo()
end
end


if event == 'ADDON_LOADED' then

if arg1=="RaidSlackCheck" then

--перенос переменных в новую
--if rscignorezone and rscignorezone3==nil then
--	rscignorezone3={{},{}}
--	for i=1,#rscignorezone[1] do
--		table.insert(rscignorezone3[1],rscignorezone[1][i])
--		table.insert(rscignorezone3[2],rscignorezone[2][i])
--	end
--	local bil=0
--	for j=1,#rscignorezone3[1] do
--		if rscignorezone3[1][j]==824 then
--			bil=1
--		end
--	end
--	if bil==0 then
--		table.insert(rscignorezone3[1],824)
--		table.insert(rscignorezone3[2],"Dragon Soul")
--	end
--rscignorezone=nil
--elseif rscignorezone3==nil then
if rscignorezone6==nil then
	rscignorezone6={{},{}}
	for i=1,#rscignorezonedef[1] do
		table.insert(rscignorezone6[1],rscignorezonedef[1][i])
		table.insert(rscignorezone6[2],rscignorezonedef[2][i])
	end
rscignorezonedef=nil
end

--font size from PS
rscfontsset={11,12}
if psfontsset then
rscfontsset[1]=psfontsset[1]
rscfontsset[2]=psfontsset[2]
end

if psversion then
rscout1=psreportframe1
rscout2=psreportframe2
rscout3=psreportframe3
rscframetoshowall4=PSFrscflask
rscframetoshowall5=PSFrscbuff

--кнопка препотов
if PSFpotioncheckframe_Buttonprepot then
  PSFpotioncheckframe_Buttonprepot:SetText(rscprepots)
end
else
rscmain3_Buttonprepot:SetText(rscprepots)

rscout1=rscreportframe1
rscout2=rscreportframe2
rscout3=rscreportframe3
rscframetoshowall4=rscmain4
rscframetoshowall5=rscmain5
end

if rscflaskcheckb and rscflaskcheckb[7]==nil then rscflaskcheckb[7]=1 end



end
end

if event =="PLAYER_ENTERING_WORLD" then
if type(RegisterAddonMessagePrefix) == "function" then
RegisterAddonMessagePrefix ("RSCaddon")
RegisterAddonMessagePrefix ("PSaddon")

--a RSCfs1  50
--b RSCfs2  50
--1 RSCf    strtosend.."nyyyck"..tttxt
--2 RSCb    ник и тп на наличие приоритета
--10 PSaddon

--перенесены в RSCaddon


end
end

if event == "CHAT_MSG_ADDON" then

--tables
if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="c" then
if rscdelayannouncecheck1==nil or (rscdelayannouncecheck1 and GetTime()>rscdelayannouncecheck1+50) then
local tbl={}
local tttxt=UnitName("player")
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..UnitName("player")
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,2))
table.sort(tbl)
	if tbl[1]==tttxt then
		rscdelayannouncecheck1=nil
	else
		rscdelayannouncecheck1=GetTime()
	end
end
end

if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="d" then
if rscdelayannouncecheck2==nil or (rscdelayannouncecheck2 and GetTime()>rscdelayannouncecheck2+50) then
local tbl={}
local tttxt=UnitName("player")
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..UnitName("player")
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,2))
table.sort(tbl)
	if tbl[1]==tttxt then
		rscdelayannouncecheck2=nil
	else
		rscdelayannouncecheck2=GetTime()
	end
end
end

if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="e" then
if rscdelayannouncecheck3==nil or (rscdelayannouncecheck3 and GetTime()>rscdelayannouncecheck3+50) then
local tbl={}
local tttxt=UnitName("player")
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..UnitName("player")
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,2))
table.sort(tbl)
	if tbl[1]==tttxt then
		rscdelayannouncecheck3=nil
	else
		rscdelayannouncecheck3=GetTime()
	end
end
end

if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="f" then
if rscdelayannouncecheck4==nil or (rscdelayannouncecheck4 and GetTime()>rscdelayannouncecheck4+50) then
local tbl={}
local tttxt=UnitName("player")
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..UnitName("player")
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,2))
table.sort(tbl)
	if tbl[1]==tttxt then
		rscdelayannouncecheck4=nil
	else
		rscdelayannouncecheck4=GetTime()
	end
end
end

--buffs
if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="2" then

local tbl={}
local tttxt=UnitName("player")
	if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" or UnitName("player")=="Шурш" then
		tttxt="0"..UnitName("player")
	end
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..tttxt
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,2))
table.sort(tbl)
	if tbl[1]==tttxt then
	else
		rscbcanannounce=GetTime()
	end


end

--flasks
if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="1" then

if string.find(arg2,"wchat") and arg4~=UnitName("player") then


local tbl={}
local tttxt=UnitName("player")
	if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" or UnitName("player")=="Шурш" then
		tttxt="0"..UnitName("player")
	end
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..tttxt
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,string.find(arg2,"nyyyck")+6))
table.sort(tbl)
	if tbl[1]==tttxt then
	else
			local byl=0
			local chatik=string.sub(arg2,string.find(arg2,"wchat")+5,string.find(arg2,"+")-1)
			if chatik=="raid" or chatik=="raid_warning" then
				rscflaskimportchat2[2]=GetTime()
			else
				for t=1,#rscflaskimportchat1 do
					if rscflaskimportchat1[t]==chatik then
						rscflaskimportchat2[t]=GetTime()
						byl=1
					end
				end
				if byl==0 then
					table.insert(rscflaskimportchat1,chatik)
					table.insert(rscflaskimportchat2,GetTime())
				end
			end
	end


end


if string.find(arg2,"whisp:yes") and arg4~=UnitName("player") then

local tbl={}
local tttxt=UnitName("player")
	if UnitName("player")=="Шуршик" or UnitName("player")=="Шурши" or UnitName("player")=="Шурш" then
		tttxt="0"..UnitName("player")
	end
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		tttxt="0"..tttxt
	end
table.insert(tbl,tttxt)
table.insert(tbl,string.sub(arg2,string.find(arg2,"nyyyck")+6))
table.sort(tbl)
	if tbl[1]==tttxt then
	else
		rscflaskimportchat2[1]=GetTime()
	end


end


--вижу в чате свои месаги
if arg4==UnitName("player") then
rscdelayreportstart=GetTime()
end


end --"RSCf"

if arg1=="PSaddon" and arg2 and string.sub(arg2,1,2)=="10" and rscflaskcheckb[2] and rscflaskcheckb[2]==1 then
rscflaskcheckgo()
end

if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="a" and arg4~=UnitName("player") then
rscflaskdelayrep[2]=GetTime()
end

if arg1=="RSCaddon" and arg2 and string.sub(arg2,1,1)=="b" and arg4~=UnitName("player") then
rscflaskdelayrep[1]=GetTime()
end

end


if GetNumGroupMembers() > 0 and event == "COMBAT_LOG_EVENT_UNFILTERED" then

local arg1, arg2, arg3,arg4,arg5,arg6,argNEW1,arg7,arg8,arg9,argNEW2,arg10,arg11,arg12,arg13,arg14, arg15 = ...




--ставлю столик
if arg2=="SPELL_CREATE" and arg5 and UnitInRaid(arg5) then
	if rsctableannounce[1]==1 then
    local addtext=""
		local bil=0
		for i=1,#rscfoodmanytable do
			if rscfoodmanytable[i]==arg10 then
				bil=1
				if rscfoodmanytable_add and rscfoodmanytable_add[i] and rscfoodmanytable_add[i]~=0 then
          addtext=" [+ "..rscadditionalstatbonus..": "..rscfoodmanytable_add[i].."]"
        end
			end
		end
		if bil==1 then
		rsctableoffoodbegin=GetTime()
		if rscdelayannouncecheck1==nil or (rscdelayannouncecheck1 and GetTime()>rscdelayannouncecheck1+50) then
			local stxt=UnitName("player")
			if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
				stxt="0"..UnitName("player")
			end
			if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
			SendAddonMessage("RSCaddon", "c"..stxt, "Instance_CHAT")
			else
			SendAddonMessage("RSCaddon", "c"..stxt, "RAID")
			end
			if rsctabletoreport1==nil then
				rsctabletoreport1={}
			end
			rscreportdelay1=GetTime()+2
			table.insert(rsctabletoreport1,"RSC > "..arg5.." "..rsctableused1.." > "..arg11..addtext)
		end
		end
	end
end


--ставлю ФЛАСКИ КОТЕЛ
if arg2=="SPELL_CAST_START" and arg5 and UnitInRaid(arg5) then
	if rsctableannounce[2]==1 then
		local bil=0
		for i=1,#rscflaskmanytable do
			if rscflaskmanytable[i]==arg10 then
				bil=1
			end
		end
		if bil==1 then
		if rscdelayannouncecheck2==nil or (rscdelayannouncecheck2 and GetTime()>rscdelayannouncecheck2+50) then
			local stxt=UnitName("player")
			if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
				stxt="0"..UnitName("player")
			end
			if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
			SendAddonMessage("RSCaddon", "d"..stxt, "Instance_CHAT")
			else
			SendAddonMessage("RSCaddon", "d"..stxt, "RAID")
			end
			if rsctabletoreport2==nil then
				rsctabletoreport2={}
			end
			rscreportdelay2=GetTime()+2
			table.insert(rsctabletoreport2,"RSC > "..arg5.." "..rsctableused2)
		end
		end
	end
end

--ставлю робота
if arg2=="SPELL_SUMMON" and arg5 and UnitInRaid(arg5) then
	if rsctableannounce[3]==1 then
		local bil=0
		for i=1,#rscrobotsid do
			if rscrobotsid[i]==arg10 then
				bil=1
			end
		end
		if bil==1 then
		if rscdelayannouncecheck3==nil or (rscdelayannouncecheck3 and GetTime()>rscdelayannouncecheck3+50) then
			local stxt=UnitName("player")
			if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
				stxt="0"..UnitName("player")
			end
			if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
			SendAddonMessage("RSCaddon", "e"..stxt, "Instance_CHAT")
			else
			SendAddonMessage("RSCaddon", "e"..stxt, "RAID")
			end
			if rsctabletoreport3==nil then
				rsctabletoreport3={}
			end
			rscreportdelay3=GetTime()+2
			table.insert(rsctabletoreport3,"RSC > "..arg5.." "..rsctableused3)
		end
		end
	end
end

--ставлю источник душ
if arg2=="SPELL_CREATE" and arg5 and UnitInRaid(arg5) then
	if rsctableannounce[4]==1 then
		local bil=0
		for i=1,#rsc_warlockhp do
			if rsc_warlockhp[i]==arg10 then
				bil=1
			end
		end
		if bil==1 then
		if rscdelayannouncecheck4==nil or (rscdelayannouncecheck4 and GetTime()>rscdelayannouncecheck4+50) then
			local stxt=UnitName("player")
			if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
				stxt="0"..UnitName("player")
			end
			if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
			SendAddonMessage("RSCaddon", "f"..stxt, "Instance_CHAT")
			else
			SendAddonMessage("RSCaddon", "f"..stxt, "RAID")
			end
			if rsctabletoreport4==nil then
				rsctabletoreport4={}
			end
			rscreportdelay4=GetTime()+2
			table.insert(rsctabletoreport4,"RSC > "..arg5.." "..rsctableused4)
		end
		end
	end
end



if arg2=="SPELL_CAST_SUCCESS" then
for i,usedpotion in ipairs(rscpotiontable) do
	if usedpotion == arg10 then
		if UnitInRaid(arg5) then
			if rscboy==0 and UnitIsDead("player")==nil and UnitIsDeadOrGhost("player")==nil and UnitName("boss1") and UnitName("boss1")~="" and UnitName("player")~=arg5 then
				if rscnewcombatstartdelay==nil or (rscnewcombatstartdelay and GetTime()>rscnewcombatstartdelay+5) then
					if rscdelayforcombat==nil then
						rscdelayforcombat=GetTime()
					end
				end
			end

			if (rscboy==1 or (rscboy==0 and (UnitIsDead("player") or UnitIsDeadOrGhost("player")))) then
				--мы в бою
				if rsctrackison==1 then --ыытест
					rscpotdrunk(1, arg5, arg10, arg11)
				end
			else
				rscclasscheck(arg5)
				table.insert(rscpotionnotincombat, 1, GetTime().."++"..arg5.."!!"..rsccodeclass..arg10)
				rscpotionnotincombat[38]=nil
				if rscframeuse1 and rscsmotryuboy==#rsctemptableval then
					rscnotincombatreflesh()
				end
			end
		end
	end
end

if arg10==6262 and arg5 and UnitInRaid(arg5) and (rscboy==1 or (rscboy==0 and (UnitIsDead("player") or UnitIsDeadOrGhost("player")))) and rsctrackison==1 then
if rschealstoneused and rschealstoneused[1] then
	local bnm=0
	if #rschealstoneused[1]>0 then
		for zx=1,#rschealstoneused do
			if rschealstoneused[zx]==arg5 then
				bnm=1
			end
		end
	end
	if bnm==0 then
		table.insert(rschealstoneused[1],arg5)
		table.sort(rschealstoneused[1])
	end
	if rschealstoneused2 and rschealstoneused2[1] and #rschealstoneused2[1]>0 then
		for i=1,#rschealstoneused2[1] do
			if rschealstoneused2[1][i] and rschealstoneused2[1][i]==arg5 then
				table.remove(rschealstoneused2[1],i)
			end
		end
	end
end
end



end

--героизм
if (arg2=="SPELL_CAST_SUCCESS" and (arg10==2825 or arg10==32182 or arg10==80353 or arg10==90355)) then

			if rscboy==0 and UnitIsDead("player")==nil and UnitIsDeadOrGhost("player")==nil and UnitName("boss1") and UnitName("boss1")~="" and UnitName("player")~=arg5 then
				if rscnewcombatstartdelay==nil or (rscnewcombatstartdelay and GetTime()>rscnewcombatstartdelay+5) then
					if rscdelayforcombat==nil then
						rscdelayforcombat=GetTime()
					end
				end
			end

if (rscboy==1 or (rscboy==0 and (UnitIsDead("player") or UnitIsDeadOrGhost("player")))) then
--мы в бою
if rsctrackison==1 then --ыытест

if rscwasheroism==0 then
rscwasheroism=1
--начало геры
rscvremya=math.ceil(GetTime()-rscboynachat)
rscsec2=math.fmod (rscvremya, 60)
rscmin2=math.floor (rscvremya/60)
rscsec2=math.ceil(rscsec2)
rscpotinfo=""
	if rscmin2<10 then rscpotinfo="0"..rscmin2 else rscpotinfo=rscmin2 end
	if rscsec2<10 then rscpotinfo=rscpotinfo..":0"..rscsec2 else rscpotinfo=rscpotinfo..":"..rscsec2 end
rscpotinfo=rscpotinfo.."+Heroism1"..arg5.."^\124cff71d5ff\124Hspell:"..arg10.."\124h["..arg11.."]\124h\124r"
if rscpotioninfotable[1] then
table.insert(rscpotioninfotable[1], rscpotinfo)
end

--конец геры
rscpotinfo=""
rscvremya=rscvremya+40
rscsec2=math.fmod (rscvremya, 60)
rscmin2=math.floor (rscvremya/60)
rscsec2=math.ceil(rscsec2)
if rscmin2<10 then rscpotinfo="0"..rscmin2 else rscpotinfo=rscmin2 end
if rscsec2<10 then rscpotinfo=rscpotinfo..":0"..rscsec2 else rscpotinfo=rscpotinfo..":"..rscsec2 end
rscpotinfo=rscpotinfo.."+Heroism0\124cff71d5ff\124Hspell:"..arg10.."\124h["..arg11.."]\124h\124r"
if rscpotioninfotable[1] then
table.insert(rscpotioninfotable[1], rscpotinfo)

table.sort(rscpotioninfotable[1])
end

end

end
end

end





--RSC buffs check



if arg2=="SPELL_RESURRECT" and rscbuffcheckb2[1]==1 and (rscbuffcheckb2[6]==1 or (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) or psfnopromrep) and (arg10==48477 or arg10==20484 or arg10==20742 or arg10==20739 or arg10==20747 or arg10==95750 or arg10==61999) and UnitAffectingCombat(arg5) and (rscbcanannounce==nil or (rscbcanannounce and GetTime()>rscbcanannounce+180)) then
--works ONLY IN THE RAID-INSTANCE! and NOT LFR
local a1,a2=IsInInstance()
if select(3,GetInstanceInfo())==7 then
--nothing... LFR!
elseif a1 and a2 and a2=="raid" then

local mojn=1

if #rscignorezone6[1]>0 then
	for ug=1,#rscignorezone6[1] do
		if rscignorezone6[1][ug]==GetCurrentMapAreaID() then
			rscignorezone6[2][ug]=GetRealZoneText()
			mojn=0
		end
	end
end

if mojn==0 then

local bilne=0
if #rscrebirth1>0 then
	for i=1,#rscrebirth1 do
		if rscrebirth1[i]==arg8 then
			bilne=1
		end
	end
end

if bilne==0 then
table.insert(rscrebirth1,arg8)

	if (rscbuffcheckb2[2]==1 and (rscbuffschat[1]~="sebe")) or (rscbuffcheckb2[3]==1 and (rscbuffschat[2]~="sebe")) or rscbuffcheckb2[4]==1 or rscbuffcheckb2[5]==1 then
local stxt=UnitName("player")

if stxt=="Шуршик" or stxt=="Шурши" or stxt=="Шурш" then
	stxt="0"..stxt
end
if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
	stxt="0"..stxt
end
if select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD) then
SendAddonMessage("RSCaddon", "2"..stxt, "Instance_CHAT")
else
SendAddonMessage("RSCaddon", "2"..stxt, "RAID")
end
	end

end
end
end
end


if #rscrebirth1>0 and arg2=="SPELL_AURA_APPLIED" then
local bilne=0
for i=1,#rscrebirth1 do
	if rscrebirth1[i] and rscrebirth1[i]==arg8 then
		bilne=1
		table.remove(rscrebirth1,i)
	end
end


if bilne==1 then
	if #rscrebirth2>0 then
		local biil=0
		for u=1,#rscrebirth2 do
			if rscrebirth2[u] and rscrebirth2[u]==arg8 then
				biil=1
				rscrebirth3[u]=GetTime()+rscbufftimers[1]
			end
		end

		if biil==0 then
			table.insert(rscrebirth2,arg8)
			table.insert(rscrebirth3,GetTime()+rscbufftimers[1])
		end
	else
		table.insert(rscrebirth2,arg8)
		table.insert(rscrebirth3,GetTime()+rscbufftimers[1])
	end
end

end

























end --комбат текст
end --конец основной функции аддона





--==========МЕНЮ==


function RaidSlackCheck_Command(msg)

if psversion then
PSF_potionscheck(1)
else
rscmain1:Hide()
rscmain3:Hide()
rsc_closeallpr()

rscmain1:Show()
rscmain3:Show()
rscframeuse1=1
getglobal("rscmain3_Text"):SetText("    RaidSlackCheck - "..psfpotchecklocal)
rscrefleshinfo(1)
end

end


function rsc_closeallpr()
rscmain3:Hide()
rscmain4:Hide()
rscmain5:Hide()
end

--НАСТРОЙКА данных при загрузке окна настроек
function rsc_showoptions()
bigmenuchatlistrsc = {
rscchatlist1,
rscchatlist2,
rscchatlist3,
rscchatlist4,
rscchatlist5,
rscchatlist6,
rscchatlist7,
rscchatlist8,
}

if rscfirstcreate==nil then
rscfirstcreate=1
if psversion then
rscreporttxt = PSFpotioncheckframe:CreateFontString()
rscreporttxt2 = PSFpotioncheckframe:CreateFontString()
rschsnumtxt1=PSFpotioncheckframe:CreateFontString()
rschsnumtxt2=PSFpotioncheckframe:CreateFontString()
rschsnumtxt3=PSFpotioncheckframe:CreateFontString()
rschsnumtxt4=PSFpotioncheckframe:CreateFontString()
else
rscreporttxt = rscmain3:CreateFontString()
rscreporttxt2 = rscmain3:CreateFontString()
rschsnumtxt1=rscmain3:CreateFontString()
rschsnumtxt2=rscmain3:CreateFontString()
rschsnumtxt3=rscmain3:CreateFontString()
rschsnumtxt4=rscmain3:CreateFontString()
end
rscreporttxt:SetFont(GameFontNormal:GetFont(), 14)
rscreporttxt:SetText(rsclocrep1)
rscreporttxt:SetJustifyH("LEFT")
rscreporttxt:SetPoint("TOPLEFT",565,-150)

rscreporttxt2:SetFont(GameFontNormal:GetFont(), rscfontsset[2])
rscreporttxt2:SetText(rsclocpot12)
rscreporttxt2:SetJustifyH("LEFT")
rscreporttxt2:SetWidth(200)
rscreporttxt2:SetHeight(15)
rscreporttxt2:SetPoint("TOPLEFT",540,-245)


rschsnumtxt1:SetFont(GameFontNormal:GetFont(), 14)
rschsnumtxt1:SetText("")
rschsnumtxt1:SetJustifyH("RIGHT")
rschsnumtxt1:SetWidth(50)
rschsnumtxt1:SetPoint("TOPLEFT",495,-407)

rschsnumtxt2:SetFont(GameFontNormal:GetFont(), 14)
rschsnumtxt2:SetText("")
rschsnumtxt2:SetJustifyH("RIGHT")
rschsnumtxt2:SetWidth(50)
rschsnumtxt2:SetPoint("TOPLEFT",495,-367)


rschsnumtxt3:SetFont(GameFontNormal:GetFont(), 14)
rschsnumtxt3:SetText("")
rschsnumtxt3:SetJustifyH("RIGHT")
rschsnumtxt3:SetWidth(50)
rschsnumtxt3:SetPoint("TOPLEFT",495,-247)

rschsnumtxt4:SetFont(GameFontNormal:GetFont(), 14)
rschsnumtxt4:SetText("")
rschsnumtxt4:SetJustifyH("RIGHT")
rschsnumtxt4:SetWidth(50)
rschsnumtxt4:SetPoint("TOPLEFT",495,-287)


end

openrscchoosbattle()
openrscchoosepot()
openmenureprsc()



if psversion then
if (rscraidlrep) then PSFpotioncheckframe_CheckButton1:SetChecked() else PSFpotioncheckframe_CheckButton1:SetChecked(false) end
if (rsccolornick) then PSFpotioncheckframe_CheckButton2:SetChecked() else PSFpotioncheckframe_CheckButton2:SetChecked(false) end
if (rsconlyfrombosssave) then PSFpotioncheckframe_CheckButton3:SetChecked() else PSFpotioncheckframe_CheckButton3:SetChecked(false) end
else
if (rscraidlrep) then rscmain3_CheckButton1:SetChecked() else rscmain3_CheckButton1:SetChecked(false) end
if (rsccolornick) then rscmain3_CheckButton2:SetChecked() else rscmain3_CheckButton2:SetChecked(false) end
if (rsconlyfrombosssave) then rscmain3_CheckButton3:SetChecked() else rscmain3_CheckButton3:SetChecked(false) end
end


end



function rscchange()

if rscraidlrep then
rscraidlrep=false
else
rscraidlrep=true
end

if psversion then
if (rscraidlrep) then PSFpotioncheckframe_CheckButton1:SetChecked() else PSFpotioncheckframe_CheckButton1:SetChecked(false) end
else
if (rscraidlrep) then rscmain3_CheckButton1:SetChecked() else rscmain3_CheckButton1:SetChecked(false) end
end

end

function rscchange3()
if rsconlyfrombosssave then
rsconlyfrombosssave=false
out ("|cff99ffffRaidSlackCheck|r - "..rsconlybossfig2)
else
rsconlyfrombosssave=true
out ("|cff99ffffRaidSlackCheck|r - "..rsconlybossfig1)
end
end

function rscchange2()

if rsccolornick then
rsccolornick=false
else
rsccolornick=true
end

if psversion then
if (rsccolornick) then PSFpotioncheckframe_CheckButton2:SetChecked() else PSFpotioncheckframe_CheckButton2:SetChecked(false) end
else
if (rsccolornick) then rscmain3_CheckButton2:SetChecked() else rscmain3_CheckButton2:SetChecked(false) end
end

--обн. тек список
if rscframeuse1 and #rsctemptableval==rscsmotryuboy then
--вне боя смотрю
rscnotincombatreflesh()
elseif rscframeuse1 and rscsmotryupot>1 then
--иной пот
rscrefleshchosedpot(rscsmotryuboy, rscsmotryupot-1)
elseif rscframeuse1 then
--просто рефреш
rscrefleshinfo(rscsmotryuboy)
end


end



function rsc_buttonclose()
rsc_closeallpr()
rscmain1:Hide()
rscframeuse1=nil
if rscframeuse3 then
rscsavenicks3()
rscframeuse3=nil
end
end


function bigmenuchatrsc(bigma)
if(bigma==1)then wherereporttempbigma="raid"
	elseif(bigma==2) then wherereporttempbigma="raid_warning"
	elseif(bigma==3) then wherereporttempbigma="officer"
	elseif(bigma==4) then wherereporttempbigma="party"
	elseif(bigma==5) then wherereporttempbigma="guild"
	elseif(bigma==6) then wherereporttempbigma="say"
	elseif(bigma==7) then wherereporttempbigma="yell"
	elseif(bigma==8) then wherereporttempbigma="sebe"
end
end

function bigmenuchatrsc2(bigma2)
if (bigma2=="raid") then bigma2num=1
elseif (bigma2=="raid_warning") then bigma2num=2
elseif (bigma2=="officer") then bigma2num=3
elseif (bigma2=="party") then bigma2num=4
elseif (bigma2=="guild") then bigma2num=5
elseif (bigma2=="say") then bigma2num=6
elseif (bigma2=="yell") then bigma2num=7
elseif (bigma2=="sebe") then bigma2num=8
else
bigma2num=0
end
end




--пот выпит
function rscpotdrunk(boy, imya, idpot, imyapot)
if boy==1 then

	if rscraidrostertable[1] then
		for i,nepilescho in ipairs(rscraidrostertable[1]) do
			if nepilescho == imya then
				table.remove(rscraidrostertable[1],i)

				rscvremya=GetTime()-rscboynachat
				rscsec2=math.fmod (rscvremya, 60)
				rscmin2=math.floor (rscvremya/60)
				rscsec2=math.ceil(rscsec2)
				rscpotinfo=""
				if rscmin2<10 then rscpotinfo="0"..rscmin2 else rscpotinfo=rscmin2 end
				if rscsec2<10 then rscpotinfo=rscpotinfo..":0"..rscsec2 else rscpotinfo=rscpotinfo..":"..rscsec2 end
				rscclasscheck(imya)
				rscpotinfo=rscpotinfo..imya.."++"..rsccodeclass..idpot

				table.insert(rscpotioninfotable[1], rscpotinfo)
				table.sort(rscpotioninfotable[1])

				--проверка открыто ли окно и если да - обновление фреймов в нем
				if rscframeuse1 and rscsmotryuboy==1 and rscsmotryupot==1 then
					rscrefleshinfo(1)
				elseif rscframeuse1 and rscsmotryuboy==1 then
					--выбран иной пот
					rscrefleshchosedpot(rscsmotryuboy, rscsmotryupot)
				end

				bililinet=0
				for i,usedpotion2 in ipairs(rscchoosepotion[1]) do
					if usedpotion2 == imyapot then
						bililinet=1
					end
				end
				if bililinet==0 then
					table.insert (rscchoosepotion[1], imyapot) table.sort(rscchoosepotion[1]) openrscchoosepot()
				end
			end
		end
	end
end
end



--обновление инфы во фреймах
function rscrefleshinfo(numr)
rscout1:Clear()
rscout2:Clear()
rscout3:Clear()

if rscpotioninfotable[numr]==nil then else

	--отображение кто пил поты
	for i=1,#rscpotioninfotable[numr] do
--проверяем не гера ли
		if string.find(rscpotioninfotable[numr][i], "+Heroism") then
		rscherashowed=1
		--гера
		rscout1:AddMessage(string.sub(rscpotioninfotable[numr][i],1,5), 0.0, 1.0, 0.0)
		if string.find(rscpotioninfotable[numr][i], "+Heroism1") then
			rscout3:AddMessage(" ")
			if string.find(rscpotioninfotable[numr][i],"%^") then
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numr][i],string.find(rscpotioninfotable[numr][i],"%^")+1).."< |cff00ff00ON|r ("..string.sub(rscpotioninfotable[numr][i],15,string.find(rscpotioninfotable[numr][i],"%^")-1)..")", 0.0, 1.0, 0.0)
      else
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numr][i],15).."< |cff00ff00ON|r", 0.0, 1.0, 0.0)
      end
		else
			rscout3:AddMessage(" ")
			if string.find(rscpotioninfotable[numr][i],"%^") then
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numr][i],string.find(rscpotioninfotable[numr][i],"%^")+1).."< |cffff0000OFF|r ("..string.sub(rscpotioninfotable[numr][i],15,string.find(rscpotioninfotable[numr][i],"%^")-1)..")", 0.0, 1.0, 0.0)
      else
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numr][i],15).."< |cffff0000OFF|r", 0.0, 1.0, 0.0)
      end
		end


		else


	rscout1:AddMessage(string.sub(rscpotioninfotable[numr][i],1,5))
if rsccolornick then
rsccolorset(string.sub(rscpotioninfotable[numr][i],6,string.find(rscpotioninfotable[numr][i], "++")-1),string.sub(rscpotioninfotable[numr][i],string.find(rscpotioninfotable[numr][i], "++")+2,string.find(rscpotioninfotable[numr][i], "++")+3))
else
  local name=string.sub(rscpotioninfotable[numr][i],6,string.find(rscpotioninfotable[numr][i], "++")-1)
  if string.find(name,"%-") then
    name=string.sub(name,1,string.find(name,"%-")+4)
  end
	rscout2:AddMessage(name)
end
local rscspellname=GetSpellInfo(tonumber(string.sub(rscpotioninfotable[numr][i],string.find(rscpotioninfotable[numr][i], "++")+4)))
	rscout3:AddMessage("\124cff71d5ff\124Hspell:"..string.sub(rscpotioninfotable[numr][i],string.find(rscpotioninfotable[numr][i], "++")+4).."\124h["..rscspellname.."]\124h\124r")



		end
	end

	--кто еще не выпил
	for i=1,#rscraidrostertable[numr] do
	rscout1:AddMessage(" ")
	rscout2:AddMessage(rscraidrostertable[numr][i], 1.0, 0.0, 0.0)
	rscout3:AddMessage(" ")
	end

	--если не было геры 2 пустые клетки
	if rscherashowed==0 then
	rscout1:AddMessage(" ")
	rscout1:AddMessage(" ")
	rscout2:AddMessage(" ")
	rscout2:AddMessage(" ")
	rscout3:AddMessage(" ")
	rscout3:AddMessage(" ")
	else rscherashowed=0 end



end

end



function openrscchoosbattle(last)
if not DropDownMenurscchoosbattle then
if psversion then
CreateFrame("Frame", "DropDownMenurscchoosbattle", PSFpotioncheckframe, "UIDropDownMenuTemplate")
else
CreateFrame("Frame", "DropDownMenurscchoosbattle", rscmain3, "UIDropDownMenuTemplate")
end
end

DropDownMenurscchoosbattle:ClearAllPoints()
DropDownMenurscchoosbattle:SetPoint("TOPLEFT", 535, -15)
DropDownMenurscchoosbattle:Show()


rsctemptableval={}
table.wipe(rsctemptableval)
if rscbossnamestable[1]=="0" or rscbossnamestable[1]==nil then
	rsctemptableval={rscloclastf,}
else
	rsctemptableval={rscbossnamestable[1],}
end
for i=2,# rscpotioninfotable do
	if rscbossnamestable[i]==nil or (rscbossnamestable[i] and rscbossnamestable[i]=="0") then
		table.insert (rsctemptableval, "-"..(i-1))
	else
		table.insert (rsctemptableval, rscbossnamestable[i])
	end
end
table.insert(rsctemptableval, rsclocnotinc)

local items = rsctemptableval

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenurscchoosbattle, self:GetID())

if #rsctemptableval==self:GetID() then
--вне боя активно
rscsmotryuboy=self:GetID()
rscnotincombatreflesh()
rscmain3_Button10:Hide()
rscmain3_Button11:Hide()
rscmain3_ButtonHS:Hide()
rscmain3_ButtonHS2:Hide()
rscmain3_Button30:Show()
rscmain3_Button40:Show()
if rschsnumtxt1 then
rschsnumtxt1:SetText("")
rschsnumtxt2:SetText("")
rschsnumtxt3:SetText("")
rschsnumtxt4:SetText("")
end
if rscreporttxt2 then
  rscreporttxt2:Show()
end
if psversion then
PSFpotioncheckframe_Button10:Hide()
PSFpotioncheckframe_Button11:Hide()
PSFpotioncheckframe_ButtonHS:Hide()
PSFpotioncheckframe_ButtonHS2:Hide()
PSFpotioncheckframe_Button30:Show()
PSFpotioncheckframe_Button40:Show()
if rscreporttxt2 then
  rscreporttxt2:Show()
end
end

else
--просмотр
rscmain3_Button10:Show()
rscmain3_Button11:Show()
rscmain3_ButtonHS:Show()
rscmain3_ButtonHS2:Show()
rscmain3_Button30:Hide()
rscmain3_Button40:Hide()

--отображение сколько хелсстоунов съели

local a1="?"
local a2="?"

if rschealstoneused[self:GetID()] then
	a1=#rschealstoneused[self:GetID()]
end
if rschealstoneused2[self:GetID()] then
	a2=#rschealstoneused2[self:GetID()]
end

if rschsnumtxt1 then
rschsnumtxt1:SetText("|cff00ff00"..a1.."|r")
rschsnumtxt2:SetText("|cffff0000"..a2.."|r")
end

--и сколько потов

local a3="?"
local a4="?"

if rscraidrostertable[self:GetID()] then
	a3=#rscraidrostertable[self:GetID()]
end
if rscpotioninfotable[self:GetID()] then
	local num=0
	if #rscpotioninfotable[self:GetID()]>0 then
		for hn=1,#rscpotioninfotable[self:GetID()] do
			if rscpotioninfotable[self:GetID()][hn] and string.find(rscpotioninfotable[self:GetID()][hn], "+Heroism")==nil then
				num=num+1
			end
		end
	end
	a4=num
end

if rschsnumtxt3 then
rschsnumtxt3:SetText("|cffff0000"..a3.."|r")
rschsnumtxt4:SetText("|cff00ff00"..a4.."|r")
end


if rscreporttxt2 then rscreporttxt2:Hide() end
if psversion then
PSFpotioncheckframe_Button10:Show()
PSFpotioncheckframe_Button11:Show()
PSFpotioncheckframe_ButtonHS:Show()
PSFpotioncheckframe_ButtonHS2:Show()
PSFpotioncheckframe_Button30:Hide()
PSFpotioncheckframe_Button40:Hide()
if rscreporttxt2 then rscreporttxt2:Hide() end
end
rscsmotryuboy=self:GetID()
rscrefleshinfo(self:GetID())
end
openrscchoosepot()


end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

--тут проверка на какой бой смотрим, мб ласт
if last and #rsctemptableval>0 then

--вне боя активно
rscsmotryuboy=#rsctemptableval
rscnotincombatreflesh()
rscmain3_Button10:Hide()
rscmain3_Button11:Hide()
rscmain3_ButtonHS:Hide()
rscmain3_ButtonHS2:Hide()
rscmain3_Button30:Show()
rscmain3_Button40:Show()
if rschsnumtxt1 then
rschsnumtxt1:SetText("")
rschsnumtxt2:SetText("")
rschsnumtxt3:SetText("")
rschsnumtxt4:SetText("")
end
if rscreporttxt2 then rscreporttxt2:Show() end
if psversion then
PSFpotioncheckframe_Button10:Hide()
PSFpotioncheckframe_Button11:Hide()
PSFpotioncheckframe_ButtonHS:Hide()
PSFpotioncheckframe_ButtonHS2:Hide()
PSFpotioncheckframe_Button30:Show()
PSFpotioncheckframe_Button40:Show()
if rscreporttxt2 then rscreporttxt2:Show() end
end

else

rscsmotryuboy=1
rscmain3_Button10:Show()
rscmain3_Button11:Show()
rscmain3_ButtonHS:Show()
rscmain3_ButtonHS2:Show()
rscmain3_Button30:Hide()
rscmain3_Button40:Hide()

--отображение сколько хелсстоунов съели

local a1="?"
local a2="?"

if rschealstoneused[1] then
	a1=#rschealstoneused[1]
end
if rschealstoneused2[1] then
	a2=#rschealstoneused2[1]
end

if rschsnumtxt1 then
rschsnumtxt1:SetText("|cff00ff00"..a1.."|r")
rschsnumtxt2:SetText("|cffff0000"..a2.."|r")
end

--и сколько потов

local a3="?"
local a4="?"

if rscraidrostertable[1] then
	a3=#rscraidrostertable[1]
end
if rscpotioninfotable[1] then
	local num=0
	if #rscpotioninfotable[1]>0 then
		for hn=1,#rscpotioninfotable[1] do
			if rscpotioninfotable[1][hn] and string.find(rscpotioninfotable[1][hn], "+Heroism")==nil then
				num=num+1
			end
		end
	end
	a4=num
end

if rschsnumtxt3 then
rschsnumtxt3:SetText("|cffff0000"..a3.."|r")
rschsnumtxt4:SetText("|cff00ff00"..a4.."|r")
end



if rscreporttxt2 then rscreporttxt2:Hide() end
if psversion then
PSFpotioncheckframe_Button10:Show()
PSFpotioncheckframe_Button11:Show()
PSFpotioncheckframe_ButtonHS:Show()
PSFpotioncheckframe_ButtonHS2:Show()
PSFpotioncheckframe_Button30:Hide()
PSFpotioncheckframe_Button40:Hide()
if rscreporttxt2 then rscreporttxt2:Hide() end
end


end --last

openrscchoosepot()

local check=1
if last and #rsctemptableval>0 then
  check=#rsctemptableval
end


UIDropDownMenu_Initialize(DropDownMenurscchoosbattle, initialize)
UIDropDownMenu_SetWidth(DropDownMenurscchoosbattle, 140);
UIDropDownMenu_SetButtonWidth(DropDownMenurscchoosbattle, 155)
UIDropDownMenu_SetSelectedID(DropDownMenurscchoosbattle,check)
UIDropDownMenu_JustifyText(DropDownMenurscchoosbattle, "LEFT")
end



--меню выбор пота
function openrscchoosepot()
if not DropDownMenurscchoosepot then
if psversion then
CreateFrame("Frame", "DropDownMenurscchoosepot", PSFpotioncheckframe, "UIDropDownMenuTemplate")
else
CreateFrame("Frame", "DropDownMenurscchoosepot", rscmain3, "UIDropDownMenuTemplate")
end
end

DropDownMenurscchoosepot:ClearAllPoints()
DropDownMenurscchoosepot:SetPoint("TOPLEFT", 535, -45)
DropDownMenurscchoosepot:Show()


rsctemptableval2={}
table.wipe(rsctemptableval2)
	if rscsmotryuboy==#rsctemptableval then
	rsctemptableval2={rsclocallpot}
	else
rsctemptableval2={rsclocallpot,}
		if rscchoosepotion[rscsmotryuboy] then
for i=1,# rscchoosepotion[rscsmotryuboy] do
table.insert (rsctemptableval2, rscchoosepotion[rscsmotryuboy][i])
end
		end
	end


local items = rsctemptableval2

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenurscchoosepot, self:GetID())

--
if rscsmotryuboy==#rsctemptableval and self:GetID()==1 then
rscnotincombatreflesh()
elseif self:GetID()==1 then
rscrefleshinfo(rscsmotryuboy)
else
rscrefleshchosedpot(rscsmotryuboy, self:GetID()-1)
end
rscsmotryupot=self:GetID()

if psversion then
if rscsmotryupot>1 then
PSFpotioncheckframe_Button20:Show()
PSFpotioncheckframe_Button11:Hide()
PSFpotioncheckframe_ButtonHS:Hide()
PSFpotioncheckframe_ButtonHS2:Hide()
else
PSFpotioncheckframe_Button20:Hide()
if rscsmotryuboy==#rsctemptableval then else PSFpotioncheckframe_Button11:Show() end
end
else
if rscsmotryupot>1 then
rscmain3_Button20:Show()
rscmain3_Button11:Hide()
rscmain3_ButtonHS:Hide()
rscmain3_ButtonHS2:Hide()
else
rscmain3_Button20:Hide()
if rscsmotryuboy==#rsctemptableval then else rscmain3_Button11:Show() end
end
end

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

rscsmotryupot=1
if psversion then
PSFpotioncheckframe_Button20:Hide()
else
rscmain3_Button20:Hide()
end

UIDropDownMenu_Initialize(DropDownMenurscchoosepot, initialize)
UIDropDownMenu_SetWidth(DropDownMenurscchoosepot, 140);
UIDropDownMenu_SetButtonWidth(DropDownMenurscchoosepot, 155)
UIDropDownMenu_SetSelectedID(DropDownMenurscchoosepot,1)
UIDropDownMenu_JustifyText(DropDownMenurscchoosepot, "LEFT")
end


function rscnotincombatreflesh()
rscout1:Clear()
rscout2:Clear()
rscout3:Clear()

i=#rscpotionnotincombat
while i>0 do

rscvremya=GetTime()-tonumber(string.sub(rscpotionnotincombat[i],1,string.find(rscpotionnotincombat[i], "++")-1))
rscsec2=math.fmod (rscvremya, 60)
rscmin2=math.floor (rscvremya/60)
rscsec2=math.ceil(rscsec2)
rscpotinfo=""
if rscmin2<10 then rscpotinfo="0"..rscmin2 else rscpotinfo=rscmin2 end
if rscsec2<10 then rscpotinfo=rscpotinfo..":0"..rscsec2 else rscpotinfo=rscpotinfo..":"..rscsec2 end
	if rscmin2<0 or rscmin2>999 then
rscout1:AddMessage("-----")
	elseif rscmin2>99 then
rscout1:AddMessage("-"..rscmin2)
	else
rscout1:AddMessage("-"..rscpotinfo)
	end
		if string.find(rscpotionnotincombat[i], "combatstart") then
		rscout2:AddMessage("Combat +", 0.0, 1.0, 0.0)
		rscout3:AddMessage(" ")
		else
if rsccolornick then
rsccolorset(string.sub(rscpotionnotincombat[i],string.find(rscpotionnotincombat[i], "++")+2,string.find(rscpotionnotincombat[i], "!!")-1),string.sub(rscpotionnotincombat[i],string.find(rscpotionnotincombat[i], "!!")+2,string.find(rscpotionnotincombat[i], "!!")+3))
else
  local name=string.sub(rscpotionnotincombat[i],string.find(rscpotionnotincombat[i], "++")+2,string.find(rscpotionnotincombat[i], "!!")-1)
  if string.find(name,"%-") then
    name=string.sub(name,1,string.find(name,"%-")+4)
  end
rscout2:AddMessage(name)
end
local rscspellname=GetSpellInfo(tonumber(string.sub(rscpotionnotincombat[i],string.find(rscpotionnotincombat[i], "!!")+4)))
rscout3:AddMessage("\124cff71d5ff\124Hspell:"..string.sub(rscpotionnotincombat[i],string.find(rscpotionnotincombat[i], "!!")+4).."\124h["..rscspellname.."]\124h\124r")
		end

i=i-1
end
end


function rscrefleshchosedpot(numrboy, numrpot)
if rscotherpotdrunk==nil then rscotherpotdrunk={} end
table.wipe(rscotherpotdrunk)

rscout1:Clear()
rscout2:Clear()
rscout3:Clear()
if rscpotioninfotable[numrboy]==nil then else

	--отображение кто пил поты
	for i=1,#rscpotioninfotable[numrboy] do
--проверяем не гера ли
		if string.find(rscpotioninfotable[numrboy][i], "+Heroism") then
		rscherashowed=1
		--гера
		rscout1:AddMessage(string.sub(rscpotioninfotable[numrboy][i],1,5), 0.0, 1.0, 0.0)
		if string.find(rscpotioninfotable[numrboy][i], "+Heroism1") then
			rscout3:AddMessage(" ")
			if string.find(rscpotioninfotable[numrboy][i],"%^") then
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i],"%^")+1).."< |cff00ff00ON|r "..string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i],"%^")+1)..")", 0.0, 1.0, 0.0)
      else
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numrboy][i],15).."< |cff00ff00ON|r", 0.0, 1.0, 0.0)
      end
		else
			rscout3:AddMessage(" ")
			if string.find(rscpotioninfotable[numrboy][i],"%^") then
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i],"%^")+1).."< |cffff0000OFF|r "..string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i],"%^")+1)..")", 0.0, 1.0, 0.0)
      else
        rscout2:AddMessage(">"..string.sub(rscpotioninfotable[numrboy][i],15).."< |cffff0000OFF|r", 0.0, 1.0, 0.0)
      end
		end
		else


local rscspellname2=GetSpellInfo(tonumber(string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i], "++")+4)))
if rscspellname2==rscchoosepotion[numrboy][numrpot] then
	rscout1:AddMessage(string.sub(rscpotioninfotable[numrboy][i],1,5))
if rsccolornick then
rsccolorset(string.sub(rscpotioninfotable[numrboy][i],6,string.find(rscpotioninfotable[numrboy][i], "++")-1),string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i], "++")+2,string.find(rscpotioninfotable[numrboy][i], "++")+3))
else
  local name=string.sub(rscpotioninfotable[numrboy][i],6,string.find(rscpotioninfotable[numrboy][i], "++")-1)
  if string.find(name,"%-") then
    name=string.sub(name,1,string.find(name,"%-")+4)
  end
	rscout2:AddMessage(name)
end
local rscspellname=GetSpellInfo(tonumber(string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i], "++")+4)))
	rscout3:AddMessage("\124cff71d5ff\124Hspell:"..string.sub(rscpotioninfotable[numrboy][i],string.find(rscpotioninfotable[numrboy][i], "++")+4).."\124h["..rscspellname.."]\124h\124r")
else
--добавить ник в список в конце
table.insert(rscotherpotdrunk, rscpotioninfotable[numrboy][i])


end
		end
	end

	--кто пил отображен зеленым
		if rscotherpotdrunk then
		if #rscotherpotdrunk>0 then
	rscout1:AddMessage("------", 0.0, 1.0, 0.0)
	rscout2:AddMessage("-------------", 0.0, 1.0, 0.0)
	rscout3:AddMessage("------------------", 0.0, 1.0, 0.0)
	
	for i=1,#rscotherpotdrunk do
	rscout1:AddMessage(string.sub(rscotherpotdrunk[i],1,5), 0.0, 1.0, 0.0)
	local name=string.sub(rscotherpotdrunk[i],6,string.find(rscotherpotdrunk[i], "++")-1)
	if string.find(name,"%-") then
    name=string.sub(name,1,string.find(name,"%-")+4)
  end
	rscout2:AddMessage(name, 0.0, 1.0, 0.0)
local rscspellname=GetSpellInfo(tonumber(string.sub(rscotherpotdrunk[i],string.find(rscotherpotdrunk[i], "++")+4)))
	rscout3:AddMessage("\124cff71d5ff\124Hspell:"..string.sub(rscotherpotdrunk[i],string.find(rscotherpotdrunk[i], "++")+4).."\124h["..rscspellname.."]\124h\124r")
	end

		end end

	--кто еще не выпил
	if #rscraidrostertable>0 then
	for i=1,#rscraidrostertable[numrboy] do
	rscout1:AddMessage(" ")
	rscout2:AddMessage(rscraidrostertable[numrboy][i], 1.0, 0.0, 0.0)
	rscout3:AddMessage(" ")
	end
	end


	--если не было геры 2 пустые клетки
	if rscherashowed==0 then
	rscout1:AddMessage(" ")
	rscout1:AddMessage(" ")
	rscout2:AddMessage(" ")
	rscout2:AddMessage(" ")
	rscout3:AddMessage(" ")
	rscout3:AddMessage(" ")
	else rscherashowed=0 end


end



end


function openmenureprsc()
if not DropDownMenureprsc then
if psversion then
CreateFrame("Frame", "DropDownMenureprsc", PSFpotioncheckframe, "UIDropDownMenuTemplate")
else
CreateFrame("Frame", "DropDownMenureprsc", rscmain3, "UIDropDownMenuTemplate")
end
end

DropDownMenureprsc:ClearAllPoints()
DropDownMenureprsc:SetPoint("TOPLEFT", 535, -200)
DropDownMenureprsc:Show()

local items = bigmenuchatlistrsc

if psversion then
items = bigmenuchatlist
end

local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenureprsc, self:GetID())

if psversion then

if self:GetID()>8 then
rscchatrep=psfchatadd[self:GetID()-8]
else
rscchatrep=bigmenuchatlisten[self:GetID()]
end

else
	if self:GetID()>8 then
	bigmenuchatrsc(1)
	else
	bigmenuchatrsc(self:GetID())
	end
rscchatrep=wherereporttempbigma
end

end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end

if psversion then

bigmenuchat2(rscchatrep)
if bigma2num==0 then
rscchatrep=bigmenuchatlisten[1]
bigma2num=1
end

else

bigmenuchatrsc2(rscchatrep)
if bigma2num==0 then
rscchatrep="raid"
bigma2num=1
end

end

UIDropDownMenu_Initialize(DropDownMenureprsc, initialize)
UIDropDownMenu_SetWidth(DropDownMenureprsc, 110)
UIDropDownMenu_SetButtonWidth(DropDownMenureprsc, 125)
UIDropDownMenu_SetSelectedID(DropDownMenureprsc,bigma2num)
UIDropDownMenu_JustifyText(DropDownMenureprsc, "LEFT")
end


function rscrepnopot(chatcustom)
if rscraidrostertable[1] then


local tablpotdrink={}
if #rscpotioninfotable[rscsmotryuboy]>0 then
for i=1,#rscpotioninfotable[rscsmotryuboy] do
     if string.find(rscpotioninfotable[rscsmotryuboy][i],"Heroism") then else
     table.insert(tablpotdrink, string.sub(rscpotioninfotable[rscsmotryuboy][i],6,string.find(rscpotioninfotable[rscsmotryuboy][i],"++")-1))
     end
end
end
table.sort(tablpotdrink)


local rscstrochka=""
local rscstrochka2=""
local kakojboi=""

if rscsmotryuboy==1 then
kakojboi="("..rsclocfight1..")"
elseif rscsmotryuboy==2 then
kakojboi="("..rsclocfight2..")"
else
kakojboi="(-"..(rscsmotryuboy-1).." "..rsclocfight3..")"
end



if #tablpotdrink==0 then
--никто не пил
rscstrochka=rsclocpot17.." "..kakojboi.."."
rscchatsendreports(chatcustom or rscchatrep,rscstrochka, " ", " ", " ", " ")

elseif #rscraidrostertable[rscsmotryuboy]>0 then

rscstrochka="{rt8}"..rsclocpot3.." "..kakojboi.." ("..#rscraidrostertable[rscsmotryuboy].."): "


for i=1,#rscraidrostertable[rscsmotryuboy] do

if rscraidlrep then else
rsccheckleader(rscraidrostertable[rscsmotryuboy][i])
end

			if rscraidleader==nil then
	if #rscraidrostertable[rscsmotryuboy]==i then
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rscraidrostertable[rscsmotryuboy][i].."."
		else
		rscstrochka2=rscstrochka2..rscraidrostertable[rscsmotryuboy][i].."."
		end
	else
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rscraidrostertable[rscsmotryuboy][i]..", "
		else
		rscstrochka2=rscstrochka2..rscraidrostertable[rscsmotryuboy][i]..", "
		end
	end

			end
rscraidleader=nil


end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, rscstrochka2, " ", " ", " ")



else

local rscstrochka=""

if rscsmotryuboy==1 then
rscstrochka=rsclocpot4.." ("..rsclocfight1..")."
elseif rscsmotryuboy==2 then
rscstrochka=rsclocpot4.." ("..rsclocfight2..")."
else
rscstrochka=rsclocpot4.." (-"..(rscsmotryuboy-1).." "..rsclocfight3..")."
end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, " ", " ", " ", " ")


end






end
end



function rscrepnochossedpot()
if rscraidrostertable[1] then
local rscstrochka="{rt6}RaidSlackCheck - "..rsclocpot5.." '"..rscchoosepotion[rscsmotryuboy][rscsmotryupot-1].."' "
local rscstrochka2=""
local rscstrochka3=""
local rscstrochka4=""
local rscstrochka5=""
local rsckakojboj=""

if rscsmotryuboy==1 then
rsckakojboj="("..rsclocfight1..")"
elseif rscsmotryuboy==2 then
rsckakojboj="("..rsclocfight2..")"
else
rsckakojboj="(-"..(rscsmotryuboy-1).." "..rsclocfight3..")"
end

rscstrochka=rscstrochka..rsckakojboj..":"
rscstrochka2="{rt8}"..rsclocpot6

--кто не пил поты
if #rscraidrostertable[rscsmotryuboy]>0 then
	
for i=1,#rscraidrostertable[rscsmotryuboy] do

if rscraidlrep then else
rsccheckleader(rscraidrostertable[rscsmotryuboy][i])
end

			if rscraidleader==nil then

	if #rscraidrostertable[rscsmotryuboy]==i then
		if string.len(rscstrochka2)<230 then
		rscstrochka2=rscstrochka2..rscraidrostertable[rscsmotryuboy][i].."."
		else
		rscstrochka3=rscstrochka3..rscraidrostertable[rscsmotryuboy][i].."."
		end
	else
		if string.len(rscstrochka2)<230 then
		rscstrochka2=rscstrochka2..rscraidrostertable[rscsmotryuboy][i]..", "
		else
		rscstrochka3=rscstrochka3..rscraidrostertable[rscsmotryuboy][i]..", "
		end
	end

			end
rscraidleader=nil

end

else
rscstrochka2=rscstrochka2..rsclocpot7.."."
end

--другие поты

if #rscotherpotdrunk>0 then

rscstrochka4="{rt7}"..rsclocpot8
for i=1,#rscotherpotdrunk do
	if #rscotherpotdrunk==i then
		if string.len(rscstrochka4)<230 then
		rscstrochka4=rscstrochka4..(string.sub(rscotherpotdrunk[i],6,string.find(rscotherpotdrunk[i], "++")-1)).."."
		else
		rscstrochka5=rscstrochka5..(string.sub(rscotherpotdrunk[i],6,string.find(rscotherpotdrunk[i], "++")-1)).."."
		end
	else
		if string.len(rscstrochka4)<230 then
		rscstrochka4=rscstrochka4..(string.sub(rscotherpotdrunk[i],6,string.find(rscotherpotdrunk[i], "++")-1))..", "
		else
		rscstrochka5=rscstrochka5..(string.sub(rscotherpotdrunk[i],6,string.find(rscotherpotdrunk[i], "++")-1))..", "
		end
	end
end

else
rscstrochka4=rsclocpot9
end


rscchatsendreports(rscchatrep,rscstrochka, rscstrochka2, rscstrochka3, rscstrochka4, rscstrochka5)



end
end


function rscchatsendreports(chat,nnn1, nnn2, nnn3, nnn4, nnn5, nnn6, nnn7, nnn8, nnn9, nnn10,nnn11,nnn12)

if chat and (chat=="raid" or chat=="raid_warning" or chat=="party") and (select(3,GetInstanceInfo())==7 or IsLFGModeActive(LE_LFG_CATEGORY_LFD)) then
  chat="Instance_CHAT"
end

if chat=="raid_warning" and (UnitIsGroupAssistant("player")==nil or UnitIsGroupLeader("player")==nil) then chat="raid" end
if nnn2==nil then nnn2=" " end
if nnn3==nil then nnn3=" " end
if nnn4==nil then nnn4=" " end
if nnn5==nil then nnn5=" " end
if nnn6==nil then nnn6=" " end
if nnn7==nil then nnn7=" " end
if nnn8==nil then nnn8=" " end
if nnn9==nil then nnn9=" " end
if nnn10==nil then nnn10=" " end
if nnn11==nil then nnn11=" " end
if nnn12==nil then nnn12=" " end
local nnn={nnn1,nnn2,nnn3,nnn4,nnn5, nnn6, nnn7, nnn8, nnn9, nnn10,nnn11,nnn12}
for i=1,10 do
if string.len(nnn[i])>2 then

if chat=="sebe" then
DEFAULT_CHAT_FRAME:AddMessage(nnn[i])
else
bigmenuchatrsc2(chat)
	if bigma2num>0 or chat=="Instance_CHAT" then
		SendChatMessage(nnn[i], chat)
	else

local nrchatmy=GetChannelName(chat)
	if nrchatmy==0 then
	JoinPermanentChannel(chat)
	ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, chat)
	nrchatmy=GetChannelName(chat)
	end
if nrchatmy>0 then
SendChatMessage(nnn[i], "CHANNEL",nil,nrchatmy)
end

	end
end


end
end
end

function rsccheckleader(nname)
	for i = 1,GetNumGroupMembers() do local name,rank = GetRaidRosterInfo(i)
	if (rank == 2 and nname==name) then rscraidleader=1 end end
end

function rscbeforelastcombatcheck()
if #rscpotionnotincombat>0 then
	local i=1
	while i<=#rscpotionnotincombat do
		if rscboyfound==1 then
			--бой найден собираем инфу о никах до след боя или минуту
			if (string.find(rscpotionnotincombat[i], "combatstart") or (rscttime-tonumber(string.sub(rscpotionnotincombat[i],1,string.find(rscpotionnotincombat[i],"++")-1)))>59) then
				i=100
			else
				table.insert(rscdrinkbeforecom, string.sub(rscpotionnotincombat[i],string.find(rscpotionnotincombat[i],"++")+2,string.find(rscpotionnotincombat[i],"!!")-1))
				table.sort(rscdrinkbeforecom)
			end
		else
			--бой еще не найден, ищем
			if string.find(rscpotionnotincombat[i], "combatstart") then
				rscttime=tonumber(string.sub(rscpotionnotincombat[i],1,string.find(rscpotionnotincombat[i],"++")-1))
				rscboyfound=1
			end
		end
	i=i+1
	end
end
end

function rscrepnortafretcom1(chatcustom)

rscttime=0 --время последнего боя
rscdrinkbeforecom={} --записывать сюда список тех кто пили поты
rscboyfound=0

rscbeforelastcombatcheck()

if #rscdrinkbeforecom>0 then

--тут вывод тех кто пил


local rscstrochka="{rt1}"..rsclocpot13.." ("..#rscdrinkbeforecom.."): "
local rscstrochka2=""

for i=1,#rscdrinkbeforecom do



	if #rscdrinkbeforecom==i then
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rscdrinkbeforecom[i].."."
		else
		rscstrochka2=rscstrochka2..rscdrinkbeforecom[i].."."
		end
	else
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rscdrinkbeforecom[i]..", "
		else
		rscstrochka2=rscstrochka2..rscdrinkbeforecom[i]..", "
		end
	end

end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, rscstrochka2, " ", " ", " ")

elseif rscboyfound==1 then
rscchatsendreports(chatcustom or rscchatrep,"{rt8}"..rsclocpot14, " ", " ", " ", " ")
end

rscttime=nil
rscdrinkbeforecom=nil
rscboyfound=nil

end


function rscrepnortafretcom2(chatcustom)

rscttime=0 --время последнего боя
rscdrinkbeforecom={} --записывать сюда список тех кто пили поты
rscboyfound=0

rscbeforelastcombatcheck()

if #rscdrinkbeforecom==0 then
--никто не пил поты вообще!
if rscboyfound==1 then
rscchatsendreports(chatcustom or rscchatrep,"{rt8}"..rsclocpot14, " ", " ", " ", " ")
end

elseif #rscdrinkbeforecom<4 then
--выпило поты всего пару чел
local rsctxttmp="{rt1}"..rsclocpot15.." "..#rscdrinkbeforecom..": "
local rsckoma=""
	for i=1,#rscdrinkbeforecom do
	if #rscdrinkbeforecom==i then rsckoma="." else rsckoma=", " end
	rsctxttmp=rsctxttmp..rscdrinkbeforecom[i]..rsckoma
	end
rscchatsendreports(chatcustom or rscchatrep,rsctxttmp, " ", " ", " ", " ")

else

--тут собрать список и вывести результат
local rscdrinkallraid={} --весь рейд список

if #rscraidrostertable[1]>0 then
for i=1,#rscraidrostertable[1] do
	table.insert(rscdrinkallraid, rscraidrostertable[1][i])
end
end

if #rscpotioninfotable[1]>0 then
for i=1,#rscpotioninfotable[1] do
	if string.find(rscpotioninfotable[1][i],"Heroism") then else
	table.insert(rscdrinkallraid, string.sub(rscpotioninfotable[1][i],6,string.find(rscpotioninfotable[1][i],"++")-1))
	end
end
end

table.sort(rscdrinkallraid)

--тут отсеивать с теми кто пил
local k=1
while k<=#rscdrinkbeforecom do
	local l=1
	while l<=#rscdrinkallraid do
		if rscdrinkallraid[l]==rscdrinkbeforecom[k] then
			table.remove(rscdrinkallraid,l)
			l=100
		end
	l=l+1
	end
k=k+1
end


--тут вывод списка
if #rscdrinkallraid>0 then

local rscstrochka="{rt8}"..rsclocpot16.." ("..#rscdrinkallraid.."): "
local rscstrochka2=""

for i=1,#rscdrinkallraid do

if rscraidlrep then else
rsccheckleader(rscdrinkallraid[i])
end

			if rscraidleader==nil then
	if #rscdrinkallraid==i then
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rscdrinkallraid[i].."."
		else
		rscstrochka2=rscstrochka2..rscdrinkallraid[i].."."
		end
	else
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rscdrinkallraid[i]..", "
		else
		rscstrochka2=rscstrochka2..rscdrinkallraid[i]..", "
		end
	end

			end
rscraidleader=nil


end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, rscstrochka2, " ", " ", " ")
end

rscdrinkallraid=nil

end




rscttime=nil
rscdrinkbeforecom=nil
rscboyfound=nil

end


--кто пил поты репорт
function rscrepnopot2(chatcustom)


if rscpotioninfotable[1] then

local kakojboi=""
local rscstrochka=""
local rscstrochka2=""

if rscsmotryuboy==1 then
kakojboi="("..rsclocfight1..")"
elseif rscsmotryuboy==2 then
kakojboi="("..rsclocfight2..")"
else
kakojboi="(-"..(rscsmotryuboy-1).." "..rsclocfight3..")"
end


if rscraidrostertable[rscsmotryuboy] and #rscpotioninfotable[rscsmotryuboy]==0 then
--никто не пил поты поты!
rscstrochka=rsclocpot17.." "..kakojboi.."."
end


if rscpotioninfotable[rscsmotryuboy] and #rscraidrostertable[rscsmotryuboy]==0 then
--все пили поты!
rscstrochka=rsclocpot4.." "..kakojboi.."."

elseif #rscpotioninfotable[rscsmotryuboy]>0 then

rscstrochka="{rt1}"..rsclocpot18.." "..kakojboi..": "


local tablpotdrink={}
if #rscpotioninfotable[rscsmotryuboy]>0 then
for i=1,#rscpotioninfotable[rscsmotryuboy] do
	if string.find(rscpotioninfotable[rscsmotryuboy][i],"Heroism") then else
	table.insert(tablpotdrink, string.sub(rscpotioninfotable[rscsmotryuboy][i],6,string.find(rscpotioninfotable[rscsmotryuboy][i],"++")-1))
	end
end
end
table.sort(tablpotdrink)


for i=1,#tablpotdrink do


	if #tablpotdrink==i then
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..tablpotdrink[i].."."
		else
		rscstrochka2=rscstrochka2..tablpotdrink[i].."."
		end
	else
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..tablpotdrink[i]..", "
		else
		rscstrochka2=rscstrochka2..tablpotdrink[i]..", "
		end
	end


end


end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, rscstrochka2, " ", " ", " ")

end
end


--кто съел камень здоровья
function rscwhousedhsreport(chatcustom)


if rschealstoneused[1] then

local kakojboi=""
local rscstrochka=""
local rscstrochka2=""

if rscsmotryuboy==1 then
kakojboi="("..rsclocfight1..")"
elseif rscsmotryuboy==2 then
kakojboi="("..rsclocfight2..")"
else
kakojboi="(-"..(rscsmotryuboy-1).." "..rsclocfight3..")"
end


if rschealstoneused[rscsmotryuboy] and #rschealstoneused[rscsmotryuboy]==0 then
--никто не съел камень
rscstrochka="{rt8}"..rsclocpoths17.." "..kakojboi.."."
elseif rschealstoneused2[rscsmotryuboy] and #rschealstoneused2[rscsmotryuboy]==0 then
rscstrochka="{rt2}"..rsclocpoths172.." "..kakojboi.."."
elseif rschealstoneused[rscsmotryuboy] and #rschealstoneused[rscsmotryuboy]>0 then

rscstrochka="{rt2}"..rsclocpoths18.." "..kakojboi.." "..#rschealstoneused[rscsmotryuboy]..": "


for i=1,#rschealstoneused[rscsmotryuboy] do


	if #rschealstoneused[rscsmotryuboy]==i then
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rschealstoneused[rscsmotryuboy][i].."."
		else
		rscstrochka2=rscstrochka2..rschealstoneused[rscsmotryuboy][i].."."
		end
	else
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rschealstoneused[rscsmotryuboy][i]..", "
		else
		rscstrochka2=rscstrochka2..rschealstoneused[rscsmotryuboy][i]..", "
		end
	end

end


end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, rscstrochka2, " ", " ", " ")

end
end



--кто не съел камень здоровья!
function rscwhousedhsreport2(chatcustom)


if rschealstoneused2[1] then

local kakojboi=""
local rscstrochka=""
local rscstrochka2=""

if rscsmotryuboy==1 then
kakojboi="("..rsclocfight1..")"
elseif rscsmotryuboy==2 then
kakojboi="("..rsclocfight2..")"
else
kakojboi="(-"..(rscsmotryuboy-1).." "..rsclocfight3..")"
end


if rschealstoneused[rscsmotryuboy] and #rschealstoneused[rscsmotryuboy]==0 then
--никто не съел камень
rscstrochka="{rt8}"..rsclocpoths17.." "..kakojboi.."."
elseif #rschealstoneused2[rscsmotryuboy]==0 then
rscstrochka="{rt2}"..rsclocpoths172.." "..kakojboi.."."
elseif #rschealstoneused2[rscsmotryuboy]>0 then

rscstrochka="{rt8}"..rsclocpoths182.." "..kakojboi.." "..#rschealstoneused2[rscsmotryuboy]..": "


for i=1,#rschealstoneused2[rscsmotryuboy] do


	if #rschealstoneused2[rscsmotryuboy]==i then
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rschealstoneused2[rscsmotryuboy][i].."."
		else
		rscstrochka2=rscstrochka2..rschealstoneused2[rscsmotryuboy][i].."."
		end
	else
		if string.len(rscstrochka)<230 then
		rscstrochka=rscstrochka..rschealstoneused2[rscsmotryuboy][i]..", "
		else
		rscstrochka2=rscstrochka2..rschealstoneused2[rscsmotryuboy][i]..", "
		end
	end

end


end

rscchatsendreports(chatcustom or rscchatrep,rscstrochka, rscstrochka2, " ", " ", " ")

end
end



function rscclasscheck(imya)
rsccodeclass="00"
local mnam=imya
if string.len (mnam)>42 and string.find(mnam,"%-") then
  mnam=string.sub(mnam,1,string.find(mnam,"%-")-1)
end
local _, rsctekclass = UnitClass(mnam)
				if rsctekclass then
rsctekclass=string.lower(rsctekclass)

if rsctekclass=="warrior" then rsccodeclass="01"
elseif rsctekclass=="deathknight" then rsccodeclass="02"
elseif rsctekclass=="paladin" then rsccodeclass="03"
elseif rsctekclass=="priest" then rsccodeclass="04"
elseif rsctekclass=="shaman" then rsccodeclass="05"
elseif rsctekclass=="druid" then rsccodeclass="06"
elseif rsctekclass=="rogue" then rsccodeclass="07"
elseif rsctekclass=="mage" then rsccodeclass="08"
elseif rsctekclass=="warlock" then rsccodeclass="09"
elseif rsctekclass=="hunter" then rsccodeclass="10"
elseif rsctekclass=="monk" then rsccodeclass="11"
end
				end
end


function rsccolorset(imya,colid)
if string.find(imya,"%-") then
  imya=string.sub(imya,1,string.find(imya,"%-")+4)
end
if colid=="01" then rscout2:AddMessage("|CFFC69B6D"..imya.."|r")
elseif colid=="02" then rscout2:AddMessage("|CFFC41F3B"..imya.."|r")
elseif colid=="03" then rscout2:AddMessage("|CFFF48CBA"..imya.."|r")
elseif colid=="04" then rscout2:AddMessage("|CFFFFFFFF"..imya.."|r")
elseif colid=="05" then rscout2:AddMessage("|CFF1a3caa"..imya.."|r")
elseif colid=="06" then rscout2:AddMessage("|CFFFF7C0A"..imya.."|r")
elseif colid=="07" then rscout2:AddMessage("|CFFFFF468"..imya.."|r")
elseif colid=="08" then rscout2:AddMessage("|CFF68CCEF"..imya.."|r")
elseif colid=="09" then rscout2:AddMessage("|CFF9382C9"..imya.."|r")
elseif colid=="10" then rscout2:AddMessage("|CFFAAD372"..imya.."|r")
elseif colid=="11" then rscout2:AddMessage("|CFF00FF96"..imya.."|r")
else
rscout2:AddMessage(imya)
end
end


function rscbossfrompssave(bosss,time)
if rscbossnamestable and rscbossnamestable[1]=="0" and bosss and time then
rscbossnamestable[1]=bosss..", "..time
end
end

function rscrezetpot()
if rscboy==0 then

	rscraidrostertable={}
	rscpotioninfotable={}
	rscchoosepotion={}
	rscbossnamestable={}

	rscpotionnotincombat={}





rscmain3_Button10:Show()
rscmain3_Button11:Show()
rscmain3_ButtonHS:Show()
rscmain3_ButtonHS2:Show()
rscmain3_Button30:Hide()
rscmain3_Button40:Hide()
openrscchoosbattle()
if rscreporttxt2 then rscreporttxt2:Hide() end
if psversion then
PSFpotioncheckframe_Button10:Show()
PSFpotioncheckframe_Button11:Show()
PSFpotioncheckframe_ButtonHS:Show()
PSFpotioncheckframe_ButtonHS2:Show()
PSFpotioncheckframe_Button30:Hide()
PSFpotioncheckframe_Button40:Hide()
if rscreporttxt2 then rscreporttxt2:Hide() end
end
rscsmotryuboy=1
rscrefleshinfo(1)
openrscchoosepot()


end
end

function rscwindow1()
rsc_closeallpr()
if rscframeuse3 then
rscsavenicks3()
rscframeuse3=nil
end
rscmain3:Show()
getglobal("rscmain3_Text"):SetText("    RaidSlackCheck - "..psfpotchecklocal)
rscframeuse1=1
rscrefleshinfo(1)
end

function rscwindow2()
--фласкочек
rsc_closeallpr()
if rscframeuse3 then
rscsavenicks3()
rscframeuse3=nil
end
	if psversion then
getglobal("PSFrscflask_Text"):SetText("    "..psfpotchecklocalt2)
	else
getglobal("rscmain4_Text"):SetText("    RaidSlackCheck - "..psfpotchecklocalt2)
	end
rscframetoshowall4:Show()

rsccreateframeflasks()

end

function rscwindow3()

--временно отключено
if 1==2 then

  --бафы после бреса
  rsc_closeallpr()
  if rscframeuse3 then
  rscsavenicks3()
  rscframeuse3=nil
  end
  rscframetoshowall5:Show()
    if psversion then
  getglobal("PSFrscbuff_Text"):SetText("    "..psfpotchecklocalt322)
    else
  getglobal("rscmain5_Text"):SetText("    RaidSlackCheck - "..psfpotchecklocalt322)
    end
  rscframeuse3=1
  rsccreateframebafs()
else
out ("Sorry! This module is disabled at the moment...")
end
end


function rscChatFilter(self, event, msg, author, ...)

if msg and self then
msg=string.lower(msg)
	if msg:find(string.lower(rscflaskwhisptxt1)) or msg:find(string.lower(rscflaskwhisptxt2)) or msg:find(string.lower(rscflaskwhisptxt3)) or msg:find(string.lower(rscflaskwhisptxt4)) or msg:find(string.lower(rscflaskwhisptxt5)) or msg:find(string.lower(rscflaskwhisptxt11)) or msg:find(string.lower(rscflaskwhisptxt33)) or msg:find(string.lower(rscflaskwhisptxt40)) or msg:find(string.lower(rscflaskwhisptxt44)) or msg:find(string.lower(rscflaskwhisptxt55)) or msg:find(string.lower(rscflaskwhisptxt56)) or msg:find(string.lower(rscreleasedtxt6)) or msg:find(string.lower(rscreleasedtxt6f)) or msg:find(string.lower(rscreleasedtxt7)) or msg:find(string.lower(rscreleasedtxt7f)) then
	return true
	end
end
end

function rscchatfiltimefunc()
if rscchatfiltime==nil then
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", rscChatFilter)
rscchatfiltime=GetTime()
else
rscchatfiltime=GetTime()
end
end

function out(text)
DEFAULT_CHAT_FRAME:AddMessage(text)
UIErrorsFrame:AddMessage(text, 1.0, 1.0, 0, 1, 10)
end



function rscnewcombatstart()
rscboy=1


local a1, a2, a3, a4, a5 = GetInstanceInfo()

if a2=="raid" then
SetMapToCurrentZone()
end


if rscflaskcheckb[1]==1 then
if (UnitName("boss1") and UnitName("boss1")~="") then
rscwasyellpull=GetTime()
rscflaskcheckgo()
else
rscdelaycheckbossbegin=GetTime()+4
end
end


--5 сек пауза после окончания боя
if rsclastfightdelay==nil or (rsclastfightdelay and GetTime()-rsclastfightdelay>5) then
	if rsclastfightdelay==nil then
		rsclastfightdelay=GetTime()
	end

	if GetNumGroupMembers() > 0 then
	if rscpotionscombatsaves<3 then rscpotionscombatsaves=3 end
	if rscpotionscombatsaves>30 then rscpotionscombatsaves=30 end



	if (rsconlyfrombosssave and UnitName("boss1") and UnitName("boss1")~="") or rsconlyfrombosssave==false then
		rsctrackison=1

		table.insert(rscraidrostertable,1,{})

		table.insert(rscpotioninfotable,1,{})

		table.insert(rscchoosepotion,1,{})

		table.insert(rscbossnamestable,1,"0")

		table.insert(rschealstoneused,1,{})

		table.insert(rschealstoneused2,1,{})


		if #rscraidrostertable>rscpotionscombatsaves then
			for ty=rscpotionscombatsaves+1,#rscraidrostertable do
	
				rscraidrostertable[ty]=nil
				rscpotioninfotable[ty]=nil
				rscchoosepotion[ty]=nil
				rscbossnamestable[ty]=nil
				rschealstoneused[ty]=nil
				rschealstoneused2[ty]=nil

			end
		end



		local rscskokagrup=5
		if GetRaidDifficultyID()==3 or GetRaidDifficultyID()==5 then
			rscskokagrup=2
		end
		for i = 1,GetNumGroupMembers() do local name,rank,subgroup = GetRaidRosterInfo(i)
		if (subgroup <= rscskokagrup) then do
			table.insert(rscraidrostertable[1],(GetRaidRosterInfo(i)))
			table.insert(rschealstoneused2[1],(GetRaidRosterInfo(i)))
		end end end
		table.sort(rscraidrostertable[1])
		table.sort(rschealstoneused2[1])


	rscboynachat=GetTime()
	rscwasheroism=0



	if UnitName("boss1") and UnitName("boss1")~="" then
		local h,m = GetGameTime()
		if m<10 then m="0"..m end
		rscbossnamestable[1]=UnitName("boss1")..", "..h..":"..m
	end


	openrscchoosbattle()
	openrscchoosepot()
	if rscframeuse1 and rscsmotryuboy==1 then rscrefleshinfo(1) end
else
rsctrackison=0
end --только боссов


	--добавить название бой начат
	table.insert(rscpotionnotincombat, 1, GetTime().."++combatstart")
	rscpotionnotincombat[38]=nil

end
end

end