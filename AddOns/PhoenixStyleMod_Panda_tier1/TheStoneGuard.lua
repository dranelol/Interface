psbossfilep31=1




function pscmrbossREPORTp311(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp31 and pswasonbossp31==1) then

	if pswasonbossp31==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][3][1][2]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id130774|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][1][2]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][3][1][5]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id116281|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][1][5]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][3][1][7]==1 then
			strochkavezcrash=pszzpandaaddopttxt10..": "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][1][7]], true, vezaxname4, vezaxcrash4, 1)
		end




	end
	if pswasonbossp31==1 or (pswasonbossp31==2 and try==nil) then

		psiccsavinginf(psbossnames[2][3][1], try, pswasonbossp31)

		strochkavezcrash=psmainmdamagefrom.." |s4id130774|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id116281|id: "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=pszzpandaaddopttxt10..": "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp31=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp311(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp31=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)

psstonetableozero1=nil
psstonetableozero2=nil

psguardyashmaon1=nil
psguardyashmaon2=nil
psguardyashmaon3=nil

psguardchainstab1=nil
psguardchainstab2=nil
psguardchainstab3=nil
psguardchainstab4=nil
psguardchainstab5=nil
psguardchainstab6=nil
psguardchainstab7=nil
psguardchainstab8=nil
psguardchainstab9=nil
psguardchainstab10=nil

psstrazhiotstup=nil

end
end


function pscombatlogbossp31(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)






if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==130774 and UnitName("boss1") then
  if pswasonbossp31==nil then
    pswasonbossp31=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then
    pscheckwipe1()
    if pswipetrue and pswasonbossp31~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    
    if psstonetableozero1==nil then
      psstonetableozero1={} --GUID
      psstonetableozero2={} --тик
    end
    
    --записывает в табл
    local bil=0
    if #psstonetableozero1>0 then
      for i=1,#psstonetableozero1 do
        if psstonetableozero1[i] and psstonetableozero1[i]==guid2 then
          if psstonetableozero2[i]<GetTime()-5 then
            bil=1 --1 tick
            psstonetableozero2[i]=GetTime()
          else
            bil=2 --считать всегда
            psstonetableozero2[i]=GetTime()
          end
        end
      end
    end
    if bil==0 then
      bil=1
      table.insert(psstonetableozero1,guid2)
      table.insert(psstonetableozero2,GetTime())
    end
    if psraidoptionson[2][3][1][3]==0 or (psraidoptionson[2][3][1][3]==1 and bil==2) then
      addtotwotables(name2)
      vezaxsort1()

      local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
      pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][1],2)

      --тут репортить по ходу боя, с задержкой в 0.5 сек
      if psraidoptionson[2][3][1][1]==1 and pswasonbossp31==1 and select(3,GetInstanceInfo())~=7 then
        if psstoneguardrep05==nil then
          psstoneguardrep05=GetTime()+0.5
        end
        addtotwotables2(name2)
        vezaxsort2()
      end
    end
  end      
end







if arg2=="SPELL_DAMAGE" and spellid==116281 and UnitName("boss1") then

  if pswasonbossp31==nil then
    pswasonbossp31=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp31~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    if arg12 and arg12>50000 then
      addtotwotables3(name2)
      vezaxsort3()
    end
    
    
		if psraidoptionson[2][3][1][4]==1 and pswasonbossp31==1 then
      if psstonebombrep1==nil then
        psstonebombrep1={} --ники кто попал
        psstonebombrep2={} --гуид ловушек
        psstonebombrep3={} --время когда репортить!
      end
      local bil=0
      if #psstonebombrep2>0 then
        for i=1,#psstonebombrep2 do
          if psstonebombrep2[i]==guid1 then
            table.insert(psstonebombrep1[i],name2)
            bil=1
          end
        end
      end
      if bil==0 then
        table.insert(psstonebombrep1,{name2})
        table.insert(psstonebombrep2,guid1)
        table.insert(psstonebombrep3,GetTime()+2)
      end
		end
    
    local dmgf=psdamageceil(arg12)
    if arg12>50000 then
      dmgf="|cffff0000"..dmgf.."|r"
    end
    local tt2=", "..dmgf
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][1],2)
  end
end





--Яшмовые цепи


--таблица правильного дебафа на яшму:
if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_APPLIED_DOSE") and spellid==116038 and UnitName("boss1") then
  if psguardyashmaon1==nil then
    psguardyashmaon1={}--ники игроков
    psguardyashmaon2={}--яшма на нем
    psguardyashmaon3={}--последнее время обновления
  end
  local bil=0
  if #psguardyashmaon1>0 then
    for i=1,#psguardyashmaon1 do
      if psguardyashmaon1[i]==name2 then
        psguardyashmaon2[i]=1
        psguardyashmaon3[i]=GetTime()
        bil=1
      end
    end
  end
  if bil==0 then
    table.insert(psguardyashmaon1,name2)
    table.insert(psguardyashmaon2,1)
    table.insert(psguardyashmaon3,GetTime())
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==116038 then
  if psguardyashmaon1 and #psguardyashmaon1 then
    for i=1,#psguardyashmaon1 do
      if psguardyashmaon1[i] and psguardyashmaon1[i]==name2 then
        psguardyashmaon2[i]=0
      end
    end
  end
end


--вешаются цепи
if arg2=="SPELL_AURA_APPLIED" and spellid==130395 and UnitName("boss1") then


--сей анонсер
if ps_saoptions[2][3][1][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end


  if pswasonbossp31==nil then
    pswasonbossp31=1
  end
    pscheckwipe1()
    if pswipetrue and pswasonbossp31~=2 then
      psiccwipereport_p1("wipe", "try")
    end

  if psguardchainstab1==nil then
    psdelaycheckguardchain=GetTime()+2
    psguardchainstab1={} --имя 1 игрока
    psguardchainstab2={} --имя второго игрока
    psguardchainstab3={} --урон получен 1 игроком
    psguardchainstab4={} --урон получен 2 игроком
    psguardchainstab5={} --время наложения дебафа
    psguardchainstab6={} --время снятия дебафа (2 сек трекерим на смерть игрока?)
    psguardchainstab7={} --тиков полученных 1 игроком без дебафа
    psguardchainstab8={} --тиков полученных 2 игроком без дебафа
    psguardchainstab9={} --1 игрок умер
    psguardchainstab10={} --2 игрок умер
  end
  local bil=0
  if #psguardchainstab1>0 then
    if psguardchainstab2[#psguardchainstab2]==0 and psguardchainstab5[#psguardchainstab5]>=GetTime()-3 then
      bil=1
      psguardchainstab2[#psguardchainstab2]=name2
    end
  end
  if bil==0 then
    table.insert(psguardchainstab1,name2)
    table.insert(psguardchainstab2,0)
    table.insert(psguardchainstab3,0)
    table.insert(psguardchainstab4,0)
    table.insert(psguardchainstab5,GetTime())
    table.insert(psguardchainstab6,0)
    table.insert(psguardchainstab7,0)
    table.insert(psguardchainstab8,0)
  end
end

if arg2=="UNIT_DIED" then
  if psguardchainstab6 and #psguardchainstab6>0 then
    for i=1,#psguardchainstab6 do
      if psguardchainstab6[i]~=0 then
        if psguardchainstab1[i]==name2 then
          psguardchainstab9[i]=1
        end
        if psguardchainstab2[i]==name2 then
          psguardchainstab10[i]=1
        end
      end
    end
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==130395 then
  if psguardchainstab6 and #psguardchainstab6>0 then
    local i=#psguardchainstab6
    while i>0 do
      if psguardchainstab1[i]==name2 or psguardchainstab2[i]==name2 then
        psguardchainstab6[i]=GetTime()
        i=0
      end
      i=i-1
    end
  end
end

if arg2=="SPELL_DAMAGE" and spellid==130404 and UnitName("boss1") then
    pscheckwipe1()
    if pswipetrue and pswasonbossp31~=2 then
      psiccwipereport_p1("wipe", "try")
    end
  if psguardchainstab1 and #psguardchainstab1>0 then
    for i=1,#psguardchainstab1 do
      if (psguardchainstab1[i]==name1 or psguardchainstab1[i]==name2) and (psguardchainstab2[i]==name1 or psguardchainstab2[i]==name2) then
        if name2==psguardchainstab1[i] then
          psguardchainstab3[i]=psguardchainstab3[i]+arg12
        end
        if name2==psguardchainstab2[i] then
          psguardchainstab4[i]=psguardchainstab4[i]+arg12
        end
        local deb=0 --нет дебафа
        if psguardyashmaon1 and #psguardyashmaon1>0 then
          for j=1,#psguardyashmaon1 do
            if psguardyashmaon1[j]==name2 and psguardyashmaon2[j]==1 and psguardyashmaon3[j]>=GetTime()-20 then
              deb=1
            end
          end
        end
        if deb==0 then
          if name2==psguardchainstab1[i] then
            psguardchainstab7[i]=psguardchainstab7[i]+1
          end
          if name2==psguardchainstab2[i] then
            psguardchainstab8[i]=psguardchainstab8[i]+1
          end
          if GetTime()>=psguardchainstab5[i]+3 then
            --3 сек прошло считаем фейл
            addtotwotables4(name2)
            vezaxsort4()
          end
        end
      end
    end
  end
end








end