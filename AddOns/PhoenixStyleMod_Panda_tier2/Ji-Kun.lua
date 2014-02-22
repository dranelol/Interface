psbossfilep56=1




function pscmrbossREPORTp561(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp56 and pswasonbossp56==1) then

	if pswasonbossp56==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][6][1]==1 then
      local fsdfsdf=GetSpellInfo(134380)
			strochkavezcrash=psiccdmgfrom.." |s4id138319|id ("..pszzpandattaddopttxt6.." "..fsdfsdf.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][6][1]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp56==1 or (pswasonbossp56==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][6], try, pswasonbossp56)

    local fsdfsdf=GetSpellInfo(134380)
		strochkavezcrash=psiccdmgfrom.." |s4id138319|id ("..pszzpandattaddopttxt6.." "..fsdfsdf.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp56=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp561(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp56=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)

psragnahishand1=nil
psragnahishand2=nil
psragnahishand3=nil



end
end



function pscombatlogbossp56(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










--стаки спадение
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==140092 and UnitName("boss1") then
  if pswasonbossp56==nil then
    pswasonbossp56=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp56~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if psptitsdeba1==nil then
      psptitsdeba1={}--имя
      psptitsdeba2={}--стаки
      psptitsdeba3={}--время ласт обновления
    end
    local bil=0
    if #psptitsdeba1>0 then
      for i=1,#psptitsdeba1 do
        if psptitsdeba1[i]==name2 then
          psptitsdeba2[i]=arg13
          psptitsdeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(psptitsdeba1,name2)
      table.insert(psptitsdeba2,arg13)
      table.insert(psptitsdeba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==140092 and psptitsdeba1 and UnitName("boss1") then
  for i=1,#psptitsdeba1 do
    if psptitsdeba1[i] and psptitsdeba1[i]==name2 and psptitsdeba2[i]>2 then --psptitsdeba3[i]+30>GetTime() --90 сек но смысл?
      if psptitsdebb1==nil then
        psptitsdebb1={}--имя
        psptitsdebb2={}--стаков
        psptitsdebb3={}--время
        psptitsdebb4={}--умер
      end


      table.insert(psptitsdebb1,psptitsdeba1[i])
      table.insert(psptitsdebb2,psptitsdeba2[i])
      table.insert(psptitsdebb3,GetTime()+1.5)
      table.insert(psptitsdebb4,0)
      
      table.remove(psptitsdeba1,i)
      table.remove(psptitsdeba2,i)
      table.remove(psptitsdeba3,i)
    end
  end
end      
      
if arg2=="UNIT_DIED" and psptitsdebb1 and #psptitsdebb1>0 then
  for i=1,#psptitsdebb1 do
    if psptitsdebb1[i]==name2 then
      psptitsdebb4[i]=1
    end
  end
end


--стаки спадение2
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==134366 and UnitName("boss1") then
  if pswasonbossp56==nil then
    pswasonbossp56=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp56~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if psptitcdeba1==nil then
      psptitcdeba1={}--имя
      psptitcdeba2={}--стаки
      psptitcdeba3={}--время ласт обновления
    end
    local bil=0
    if #psptitcdeba1>0 then
      for i=1,#psptitcdeba1 do
        if psptitcdeba1[i]==name2 then
          psptitcdeba2[i]=arg13
          psptitcdeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(psptitcdeba1,name2)
      table.insert(psptitcdeba2,arg13)
      table.insert(psptitcdeba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==134366 and psptitcdeba1 and UnitName("boss1") then
  for i=1,#psptitcdeba1 do
    if psptitcdeba1[i] and psptitcdeba1[i]==name2 and psptitcdeba2[i]>2 then --psptitcdeba3[i]+30>GetTime() --90 сек но смысл?
      if psptitcdebb1==nil then
        psptitcdebb1={}--имя
        psptitcdebb2={}--стаков
        psptitcdebb3={}--время
        psptitcdebb4={}--умер
      end


      table.insert(psptitcdebb1,psptitcdeba1[i])
      table.insert(psptitcdebb2,psptitcdeba2[i])
      table.insert(psptitcdebb3,GetTime()+1.5)
      table.insert(psptitcdebb4,0)
      
      table.remove(psptitcdeba1,i)
      table.remove(psptitcdeba2,i)
      table.remove(psptitcdeba3,i)
    end
  end
end      
      
if arg2=="UNIT_DIED" and psptitcdebb1 and #psptitcdebb1>0 then
  for i=1,#psptitcdebb1 do
    if psptitcdebb1[i]==name2 then
      psptitcdebb4[i]=1
    end
  end
end


--перья + корм
if arg2=="SPELL_CAST_SUCCESS" and spellid==134380 then
psperiyastart=GetTime()
pscaststartinfo(0,spellname..": |cff00ff00START|r", -1, "id1", 1, "|s4id138319|id - "..psinfo,psbossnames[2][5][6],2)
end

if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==138319 and psperiyastart and GetTime()<psperiyastart+8 then
  if pswasonbossp56==nil then
    pswasonbossp56=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp56~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][6],2)
  end
end




--кто стоял оч близко при кар!
if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and spellid==134375 then
psragnamaxdam=2
if select(3,GetInstanceInfo())==4 or select(3,GetInstanceInfo())==6 or select(3,GetInstanceInfo())==7 then
psragnamaxdam=5
end


psunitisplayer(guid2,name2)
if psunitplayertrue then

  psragnahishandtimerpanda=GetTime()+2

  if psragnahishand1==nil then
    psragnahishand1={} --ник кого ударило
    psragnahishand2={} --координаты игрока X
    psragnahishand3={} --координаты игрока Y
  end

  local obil=0
  if #psragnahishand1>0 then
    for i=1,#psragnahishand1 do
      if psragnahishand1[i]==name2 then
        obil=1
        local x,y=GetPlayerMapPosition(name2)
        psragnahishand2[i]=x
        psragnahishand3[i]=y
      end
    end
  end
  if obil==0 then
  table.insert(psragnahishand1,name2)
  local x,y=GetPlayerMapPosition(name2)
  table.insert(psragnahishand2,x)
  table.insert(psragnahishand3,y)
  end

end
end



--первородный корм
if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_APPLIED_DOSE") and spellid==140741 then
  if pswasonbossp56==nil then
    pswasonbossp56=1
  end
  local add=""
  if arg2=="SPELL_AURA_APPLIED_DOSE" and arg13 then
    add=" > "..arg13
  end
  pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..add, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][6],2)
end



end