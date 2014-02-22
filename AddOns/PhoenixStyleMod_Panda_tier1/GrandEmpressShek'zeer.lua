psbossfilep26=1




function pscmrbossREPORTp261(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp26 and pswasonbossp26==1) then

	if pswasonbossp26==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][2][6][2]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id124849|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][6][2]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp26==1 or (pswasonbossp26==2 and try==nil) then

		psiccsavinginf(psbossnames[2][2][6], try, pswasonbossp26)

		strochkavezcrash=psmainmdamagefrom.." |s4id124849|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp26=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp261(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp26=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

psimperattonear1=nil
psimperattonear2=nil
psimperattonear3=nil

psshekvizg1=nil
psshekvizg2=nil
psshekvizg3=nil
psshekvizg4=nil
psshekvizg5=nil
psshekvizg6=nil

end
end



function pscombatlogbossp26(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==124849 and UnitName("boss1") then

  if pswasonbossp26==nil then
    pswasonbossp26=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp26~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()


    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][6],2)
  end
end








if arg2=="SPELL_DAMAGE" and spellid==123735 and UnitName("boss1") then
  if pswasonbossp26==nil then
    pswasonbossp26=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp26~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    if psimperattonear1==nil then
      psimperattonear1={} --список игроков что задело
      psimperattonear2={} --координаты х и у
      psimperattonear3=GetTime()+1 --через 1 сек репорт
    end
    table.insert(psimperattonear1,name2)
    SetMapToCurrentZone()
    local x2,y2=GetPlayerMapPosition(name2)
    if x2 and y2 and x2>0 then
      table.insert(psimperattonear2,{x2,y2})
    else
      table.insert(psimperattonear2,{0,0})
    end
  end
end


--Видения смерти
if arg2=="SPELL_AURA_APPLIED" and spellid==124863 and UnitName("boss1") then

  --если прошло более 10 сек, тогда резетим все
  if psshekvizg4 and GetTime()>psshekvizg4+10 then
    local uron=0
    for i=1,#psshekvizg3 do
      if psshekvizg2[i]>0 then
        uron=uron+psshekvizg2[i]
      end
    end
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

  if psshekvizg1==nil then
    if pswasonbossp26==nil then
      pswasonbossp26=1
    end
    pscheckwipe1()
    if pswipetrue and pswasonbossp26~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    
    psshekvizg1={} --имена игроков
    psshekvizg2={} --друж урон что нанесли
    psshekvizg3={} --снялся уже дебафф
    psshekvizg4=GetTime() --время наложения дебафа
    if psshekvizg5==nil then
      psshekvizg5=0
    end
    psshekvizg5=psshekvizg5+1 --номер видения
    psshekvizg6=GetTime()+1 --делей таймера для чека
  end


table.insert(psshekvizg1,name2)
table.insert(psshekvizg2,0)
table.insert(psshekvizg3,0)
end

if arg2=="SPELL_DAMAGE" and spellid==124868 and psshekvizg1 and #psshekvizg1>0 and UnitName("boss1") then
  if name1 and name2 and name1~=name2 then
    for i=1,#psshekvizg1 do
      if psshekvizg1[i]==name1 then
        psshekvizg2[i]=psshekvizg2[i]+arg12
      end
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==124863 and psshekvizg1 and #psshekvizg1>0 and UnitName("boss1") then
  for i=1,#psshekvizg1 do
    if psshekvizg1[i]==name2 then
      psshekvizg3[i]=1
      psshekvizg6=GetTime()+1
    end
  end
end



end