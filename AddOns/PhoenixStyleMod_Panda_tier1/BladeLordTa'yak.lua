psbossfilep22=1




function pscmrbossREPORTp221(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp22 and pswasonbossp22==1) then

	if pswasonbossp22==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][2][2][3]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id122853|id ("..psmainmtotal..", "..pszzpandaaddopttxt30.." 1): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][2][3]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp22==1 or (pswasonbossp22==2 and try==nil) then

		psiccsavinginf(psbossnames[2][2][2], try, pswasonbossp22)

		strochkavezcrash=psmainmdamagefrom.." |s4id122853|id ("..psmainmtotal..", "..pszzpandaaddopttxt30.." 1): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp22=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp221(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp22=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)


pstayaktabwind1=nil
pstayaktabwind2=nil
pstayaktabwind3=nil

psmassiveattackstabletay1=nil
psmassiveattackstabletay2=nil
psmassiveattackstabletay3=nil
psstrazhiotstup222=nil

pstimertocheckruner=nil
psrunnertabl=nil
psrunnertabl2=nil

end
end



function pscombatlogbossp22(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==122853 and UnitName("boss1") then
  
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp22~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    

    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo.." ("..pszzpandaaddopttxt30.." 1)",psbossnames[2][2][2],2)
  end
end


if arg2=="SPELL_CAST_SUCCESS" and spellid==123175 then
  local id=tonumber(string.sub(guid1,6,10),16)
  if id==62543 then
    if pswasonbossp22==nil then
      pswasonbossp22=1
    end
    pstayaktabwind1=name2 --ник на кого оригинального кинулось
    pstayaktabwind2=GetTime()+5 -- время репорта
    pstayaktabwind3={} --кого еще задело
  end
end

if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_REFRESH") and spellid==123180 then
  local id=tonumber(string.sub(guid1,6,10),16)
  if id==62543 then
    if pstayaktabwind1==nil then
      pstayaktabwind1=0
      pstayaktabwind2=GetTime()+1.5
      pstayaktabwind3={}
    end
    if pstayaktabwind1~=name2 then
      pstayaktabwind2=GetTime()+1.5
      table.insert(pstayaktabwind3,name2)
    end
  end
end



--Unseen Strike
if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and spellid==122994 then
  local id=tonumber(string.sub(guid1,6,10),16)
  if id==62543 then
psunitisplayer(guid2,name2)
if psunitplayertrue then
  if psmassiveattackstabletay1==nil then
    psmassiveattackstabletay1={} --имя игрока по которому попало
    psmassiveattackstabletay2=GetTime() --время атаки (через 1.5 сек репорт)
    psmassiveattackstabletay3={} --список трупов от атаки
    
    if pswasonbossp22==nil then
      pswasonbossp22=1
    end

    pscheckwipe1()
    if pswipetrue and pswasonbossp22~=2 then
      psiccwipereport_p1("wipe", "try")
    end
  end
  local bil=0
  if #psmassiveattackstabletay1>0 then
    for i=1,#psmassiveattackstabletay1 do
      if psmassiveattackstabletay1[i]==name2 then
        bil=1
      end
    end
  end
  if bil==0 then
    table.insert(psmassiveattackstabletay1,name2)
  end
  if arg2=="SPELL_DAMAGE" and arg13 and arg13>=0 then
    --труп
    table.insert(psmassiveattackstabletay3,psnoservername(name2))
  end
end
  end
end





--необузданная буря, фан трекер
if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and spellid==124783 then
    if pswasonbossp22==nil then
      pswasonbossp22=1
    end
  if pstimertocheckruner==nil then
    SetMapToCurrentZone()
    pstimertocheckruner=GetTime()+4
    if psrunnertabl==nil then
      psrunnertabl={}
      psrunnertabl2={}
    end
  end
end



end