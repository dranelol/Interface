psbossfilep43=1




function pscmrbossREPORTp431(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp43 and pswasonbossp43==1) then

	if pswasonbossp43==1 then
		pssetcrossbeforereport1=GetTime()


--проверяются на ком стаки остались
if psleishideba1 and #psleishideba1>0 then
  for i=1,#psleishideba1 do
      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==psleishideba1[i] then
            if psleishideba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=psleishideba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(psleishideba1[i],psleishideba2[i])
        vezaxsort2()
      end
  end
end



		if psraidoptionson[2][4][3][2]==1 then
			strochkavezcrash=format(pszzpandaaddopttxt40,"|s4id123121|id").." ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][4][3][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][4][3][3]==1 then
			strochkavezcrash=pszzpandaaddopttxt41..": "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][4][3][3]], true, vezaxname3, vezaxcrash3, 1)
		end


	end
	if pswasonbossp43==1 or (pswasonbossp43==2 and try==nil) then

		psiccsavinginf(psbossnames[2][4][3], try, pswasonbossp43)

		strochkavezcrash=format(pszzpandaaddopttxt40,"|s4id123121|id").." ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=pszzpandaaddopttxt41..": "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp43=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp431(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp43=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)

  psleishinmr=nil
  psleishicount=nil


end
end



function pscombatlogbossp43(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)









if arg2=="SPELL_AURA_APPLIED_DOSE" and spellid==123121 and UnitName("boss1") then
  if pswasonbossp43==nil then
    pswasonbossp43=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp43~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    if psleishideba1==nil then
      psleishideba1={}--имя
      psleishideba2={}--стаки
      psleishideba3={}--время ласт обновления
    end
    local bil=0
    if #psleishideba1>0 then
      for i=1,#psleishideba1 do
        if psleishideba1[i]==name2 then
          psleishideba2[i]=arg13
          psleishideba3[i]=GetTime()
          bil=1
        end
      end
    end
    if bil==0 then
      table.insert(psleishideba1,name2)
      table.insert(psleishideba2,arg13)
      table.insert(psleishideba3,GetTime())
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==123121 and psleishideba1 and UnitName("boss1") then
  for i=1,#psleishideba1 do
    if psleishideba1[i] and psleishideba1[i]==name2 and psleishideba2[i]>7 and psleishideba3[i]+30>GetTime() then
      if psleishidebb1==nil then
        psleishidebb1={}--имя
        psleishidebb2={}--стаков
        psleishidebb3={}--время
        psleishidebb4={}--умер
      end

      local bil=0
      if #vezaxname2>0 then
        for j=1,#vezaxname2 do
          if vezaxname2[j]==psleishideba1[i] then
            if psleishideba2[i]>vezaxcrash2[j] then
              vezaxcrash2[j]=psleishideba2[i]
              vezaxsort2()
            end
            bil=1
          end
        end
      end
      if bil==0 then
        addtotwotables2(psleishideba1[i],psleishideba2[i])
        vezaxsort2()
      end

      table.insert(psleishidebb1,psleishideba1[i])
      table.insert(psleishidebb2,psleishideba2[i])
      table.insert(psleishidebb3,GetTime()+1.5)
      table.insert(psleishidebb4,0)
      
      table.remove(psleishideba1,i)
      table.remove(psleishideba2,i)
      table.remove(psleishideba3,i)
    end
  end
end      
      
if arg2=="UNIT_DIED" and psleishidebb1 and #psleishidebb1>0 then
  for i=1,#psleishidebb1 do
    if psleishidebb1[i]==name2 then
      psleishidebb4[i]=1
    end
  end
end

if arg2=="SPELL_AURA_APPLIED" and spellid==123461 then
  if psleishinmr==nil then
    psleishinmr=0
  end
  psleishinmr=psleishinmr+1
  psleishicount=1
end

if arg2=="SPELL_AURA_REMOVED" and spellid==123461 then
  psleishicount=nil
end



if psleishicount then
  if arg2=="DAMAGE_SHIELD" or arg2=="SPELL_PERIODIC_DAMAGE" or arg2=="SPELL_DAMAGE" or arg2=="RANGE_DAMAGE" then
  if arg12 then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62983 then
      --получение инфо о хозяине если там пет, с учетом по маске
      local source=psgetpetownername(guid1, name1, flag1)
      pselegadddamage(3,source,1000+psleishinmr,arg12,arg13,spellid) --1 tip reporta
      addtotwotables3(source,arg12)
      vezaxsort3()
  end
  end
  end


  if arg2=="SWING_DAMAGE" then
  if spellid then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62983 then
      local source=psgetpetownername(guid1, name1, flag1)
      pselegadddamage(3,source,1000+psleishinmr,spellid,spellname,0)
      addtotwotables3(source,spellid)
      vezaxsort3()
  end
  end
  end
end


end