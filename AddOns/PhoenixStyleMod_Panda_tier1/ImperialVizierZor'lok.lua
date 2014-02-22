psbossfilep21=1




function pscmrbossREPORTp211(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp21 and pswasonbossp21==1) then

	if pswasonbossp21==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][2][1][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122336|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][1][1]], true, vezaxname, vezaxcrash, 1)
		end


		if psraidoptionson[2][2][1][2]==1 then
			strochkavezcrash=pszzpandaaddopttxt19.." |s4id122740|id: "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][1][2]], true, vezaxname3, vezaxcrash3, 1)
			strochkavezcrash=pszzpandaaddopttxt20.." |s4id122740|id ("..pssec.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][1][2]], true, vezaxname4, vezaxcrash4, 1)
		end



	end
	if pswasonbossp21==1 or (pswasonbossp21==2 and try==nil) then

		psiccsavinginf(psbossnames[2][2][1], try, pswasonbossp21)

		strochkavezcrash=psmainmdamagefrom.." |s4id122336|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=pszzpandaaddopttxt19.." |s4id122740|id: "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=pszzpandaaddopttxt20.." |s4id122740|id ("..pssec.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp21=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp211(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp21=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)

pszaorlokmc1=nil
pszaorlokmc2=nil
pszaorlokmc3=nil
pszaorlokmc4=nil

pszorlopcupol1=nil
pszorlopcupol2=nil
pszorlopcupol3=nil

pszorloctemp1=nil
pszorloctemp2=nil
pszorloctemp3=nil

psstrazhiotstup2322=nil
psfsdgjseke=nil

end
end



function pscombatlogbossp21(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==122336 then

  if pswasonbossp21==nil then
    pswasonbossp21=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp21~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    

    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][1],2)
  end
end



if arg2=="SPELL_AURA_APPLIED" and spellid==122761 then
  pszorlokluch1=name2 --имя
  pszorlokluch2=GetTime() --старт
  pszorlokluch3=0 --конец
  pszorlokluch4=0 --умер ли
  table.wipe(vezaxname2)
  table.wipe(vezaxcrash2)
end

if arg2=="SPELL_DAMAGE" and spellid==122760 and pszorlokluch2 then
  addtotwotables2(name2,arg12)
  vezaxsort2()
end

if arg2=="SPELL_AURA_REMOVED" and spellid==122761 and pszorlokluch2 then
  pszorlokluch3=GetTime()
end

if arg2=="UNIT_DIED" and pszorlokluch1 and pszorlokluch1==name2 then
  pszorlokluch4=1
end

if arg2=="SPELL_AURA_APPLIED" and spellid==122740 then
  if pszaorlokmc1==nil then
    pszaorlokmc1={} --имя
    pszaorlokmc2={} --начало
    pszaorlokmc3={} --конец
    pszaorlokmc4={} --гуид игрока
  end
  local bil=0
  if #pszaorlokmc1>0 then
    for i=1,#pszaorlokmc1 do
      if pszaorlokmc1[i]==name2 then
        bil=1
        pszaorlokmc2[i]=GetTime()
        pszaorlokmc3[i]=0
        pszaorlokmc4[i]=guid2
      end
    end
  end
  if bil==0 then
    table.insert(pszaorlokmc1,name2)
    table.insert(pszaorlokmc2,GetTime())
    table.insert(pszaorlokmc3,0)
    table.insert(pszaorlokmc4,guid2)
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==122740 then
  if pszaorlokmc1 and #pszaorlokmc1>0 then
    for i=1,#pszaorlokmc1 do
      if pszaorlokmc1[i]==name2 then
        pszaorlokmc3[i]=GetTime()
      end
    end
  end
end

--урон в МК
if pszaorlokmc1 then
  if arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE" then
  if arg12 then
    local bil=0
    if pszaorlokmc4 and #pszaorlokmc4>0 then
      for i=1,#pszaorlokmc4 do
        if pszaorlokmc4[i]==guid2 then
          bil=1
        end
      end
    end
    if bil==1 then
      --получение инфо о хозяине если там пет, с учетом по маске
      local source=psgetpetownername(guid1, name1, flag1)
      --pselegadddamage(2,source,1000+pscreatenewwaveelegon,arg12,arg13,spellid) --1 tip reporta
      addtotwotables3(source,arg12)
      vezaxsort3()
    end
  end
  end


  if arg2=="SWING_DAMAGE" then
  if spellid then
    local bil=0
    if pszaorlokmc4 and #pszaorlokmc4>0 then
      for i=1,#pszaorlokmc4 do
        if pszaorlokmc4[i]==guid2 then
          bil=1
        end
      end
    end
    if bil==1 then
      local source=psgetpetownername(guid1, name1, flag1)
      --pselegadddamage(2,source,1000+pscreatenewwaveelegon,spellid,spellname,0)
      addtotwotables3(source,spellid)
      vezaxsort3()
    end
  end
  end
end

--купола
if arg2=="SPELL_AURA_APPLIED" and spellid==122713 then
  if pswasonbossp21==nil then
    pswasonbossp21=1
  end
  pscheckwipe1()
  if pswipetrue and pswasonbossp21~=2 then
    psiccwipereport_p1("wipe", "try")
  end

  psdelaycheckkupola=GetTime()+3
  local spbuf=GetSpellInfo(122706)
  pscheckforkilloncup=GetTime()+12
  pszorlopcupol1={} --на них НЕТ купола
  pszorlopcupol2={} --они находятся ближе 10 ярдов и с БАФОМ!
  pszorlopcupol3={} --какое растояние в ярдах
  table.wipe(pszorlopcupol1)
  table.wipe(pszorlopcupol2)
  table.wipe(pszorlopcupol3)
  pszorloctemp1={} --временные таблицы копии, что служат для репорта смертей!
  pszorloctemp2={}
  pszorloctemp3={}
  table.wipe(pszorloctemp1)
  table.wipe(pszorloctemp2)
  table.wipe(pszorloctemp3)
  
		local psgroup=2
		if psdifflastfight==25 then
			psgroup=5
		end
		SetMapToCurrentZone()
		for i = 1,GetNumGroupMembers() do
			local nameq, _, subgroup, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
			if subgroup<=psgroup and online and isDead==nil and UnitIsDeadOrGhost(nameq)==nil then
				--игрок живой
				if UnitBuff(nameq, spbuf)==nil and UnitDebuff(nameq, spbuf)==nil then
          --нет бафа
          table.insert(pszorlopcupol1,nameq)
          table.insert(pszorlopcupol2,{})
          table.insert(pszorlopcupol3,{})
          
          table.insert(pszorloctemp1,nameq)
          table.insert(pszorloctemp2,{})
          table.insert(pszorloctemp3,{})
          --трекерим растояние ко всем рейдам
          local x2,y2=GetPlayerMapPosition(nameq)
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
                    table.insert(pszorlopcupol2[#pszorlopcupol2],refdf)
                    table.insert(pszorlopcupol3[#pszorlopcupol3],yard)
                    
                    table.insert(pszorloctemp2[#pszorloctemp2],refdf)
                    table.insert(pszorloctemp3[#pszorloctemp3],yard)
                  end
                end
              end
            end
          end
        end
			end
		end
end

--если умер кто без купола то сразу репорт
if UNIT_DIED and pszorloctemp1 and #pszorloctemp1>0 and pscheckforkilloncup and pscheckforkilloncup>GetTime() then
  for i=1,#pszorloctemp1 do
    if pszorloctemp1[i] and pszorloctemp1[i]==name2 then
      if pszorloctemp2[i] and #pszorloctemp2[i]>3 then
        --тут репорт без купола
        local text="" --чат
        local text2="" --фрейм
        text=psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." "
        text2=text
        text=text.." |cffff0000"..pszzpandaaddopttxt23.."|r |sid122706|id. "..pszzpandaaddopttxt24.." ("..#pszorloctemp2[i].."): "
        text2=text2.." |cffff0000"..pszzpandaaddopttxt23.."|r "..GetSpellInfo(122706).." "..pszzpandaaddopttxt24.." ("..#pszorloctemp2[i].."): "
        
        for q=1,#pszorloctemp2[i] do
          text=text..psaddcolortxt(1,pszorloctemp2[i][q])..pszorloctemp2[i][q]..psaddcolortxt(2,pszorloctemp2[i][q]).." ("..pszorloctemp3[i][q]..")"
          text2=text2..psaddcolortxt(1,pszorloctemp2[i][q])..pszorloctemp2[i][q]..psaddcolortxt(2,pszorloctemp2[i][q]).." ("..pszorloctemp3[i][q]..")"
          if q==#pszorloctemp2[i] then
            text=text.."."
          else
            text=text..", "
          end
        end
        if psraidoptionson[2][2][1][3]==1 and pswasonbossp21==1 then
          pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][1][3]], "{rt8} "..psremovecolor(text))
        end
        --pscaststartinfo(0,text2, -1, "id1", 2, "|s4id122706|id - "..psinfo,psbossnames[2][2][1],2)
      end
      table.remove(pszorloctemp1,i)
      table.remove(pszorloctemp2,i)
      table.remove(pszorloctemp3,i)
    end
  end
end



end