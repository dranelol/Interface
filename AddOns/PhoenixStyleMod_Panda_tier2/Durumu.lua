psbossfilep57=1




function pscmrbossREPORTp571(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp57 and pswasonbossp57==1) then

	if pswasonbossp57==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][5][7][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id134755|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][7][2]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][5][7][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id133793|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][5][7][2]], true, vezaxname2, vezaxcrash2, 1)
		end





	end
	if pswasonbossp57==1 or (pswasonbossp57==2 and try==nil) then

		psiccsavinginf(psbossnames[2][5][7], try, pswasonbossp57)

		strochkavezcrash=psiccdmgfrom.." |s4id134755|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id133793|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp57=2
		pscheckbossincombatmcr_p2=GetTime()+1
	end
end
end
end


function pscmrbossRESETp571(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp57=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)

table.wipe(vezaxname2)
table.wipe(vezaxcrash2)

end
end



function pscombatlogbossp57(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==134755 then

  if pswasonbossp57==nil then
    pswasonbossp57=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp57~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][7],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==133793 then

  if pswasonbossp57==nil then
    pswasonbossp57=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp57~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][5][7],2)
  end
end




--стаки спадение
if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==133767 and UnitName("boss1") then
  if pswasonbossp57==nil then
    pswasonbossp57=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp57~=2 then
      psiccwipereport_p2("wipe", "try")
    end
    if psdurumdeba1==nil then
      psdurumdeba1={}--имя
      psdurumdeba2={}--стаки
      psdurumdeba3={}--время ласт обновления
    end
    local bil=0
    if #psdurumdeba1>0 then
      for i=1,#psdurumdeba1 do
        if psdurumdeba1[i]==name2 then
          psdurumdeba2[i]=arg13
          psdurumdeba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(psdurumdeba1,name2)
      table.insert(psdurumdeba2,arg13)
      table.insert(psdurumdeba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==133767 and psdurumdeba1 and UnitName("boss1") then
  for i=1,#psdurumdeba1 do
    if psdurumdeba1[i] and psdurumdeba1[i]==name2 and psdurumdeba2[i]>2 then --psdurumdeba3[i]+30>GetTime() --90 сек но смысл?
      if psdurumdebb1==nil then
        psdurumdebb1={}--имя
        psdurumdebb2={}--стаков
        psdurumdebb3={}--время
        psdurumdebb4={}--умер
      end

      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==psdurumdeba1[i] then
            if psdurumdeba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=psdurumdeba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(psdurumdeba1[i],psdurumdeba2[i])
        vezaxsort2()
      end

      table.insert(psdurumdebb1,psdurumdeba1[i])
      table.insert(psdurumdebb2,psdurumdeba2[i])
      table.insert(psdurumdebb3,GetTime()+1.5)
      table.insert(psdurumdebb4,0)
      
      table.remove(psdurumdeba1,i)
      table.remove(psdurumdeba2,i)
      table.remove(psdurumdeba3,i)
    end
  end
end      
      
if arg2=="UNIT_DIED" and psdurumdebb1 and #psdurumdebb1>0 then
  for i=1,#psdurumdebb1 do
    if psdurumdebb1[i]==name2 then
      psdurumdebb4[i]=1
    end
  end
end









end