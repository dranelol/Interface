psbossfilep34=1




function pscmrbossREPORTp341(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp34 and pswasonbossp34==1) then

	if pswasonbossp34==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][3][4][2]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id117948|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][4][2]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][3][4][3]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id117918|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][4][3]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][3][4][6]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id119553|id ("..psmainmtotal..", "..pszzpandaaddopttxt16.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][4][6]], true, vezaxname3, vezaxcrash3, 1)
		end
		if psraidoptionson[2][3][4][7]==1 then
			strochkavezcrash=psmainmgot.." |s4id118048|id: "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][4][7]], true, vezaxname5, vezaxcrash5, 1)
		end


	end
	if pswasonbossp34==1 or (pswasonbossp34==2 and try==nil) then

		psiccsavinginf(psbossnames[2][3][4], try, pswasonbossp34)

		strochkavezcrash=psmainmdamagefrom.." |s4id117948|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id117918|id: "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id119553|id ("..psmainmtotal..", "..pszzpandaaddopttxt16.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id118048|id: "
		reportafterboitwotab("raid", true, vezaxname5, vezaxcrash5, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp34=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp341(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp34=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)
table.wipe(vezaxname5)
table.wipe(vezaxcrash5)
table.wipe(vezaxname6)
table.wipe(vezaxcrash6)
psspiritkingtab1=nil
psspiritkingtab2=nil

psshielddarknr=nil

pskingsshieldfirst1=nil
pskingsshieldfirst2=nil
pskingsshieldfirst3=nil


psstrazhiotstup22=nil


end
end



function pscombatlogbossp34(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)








if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and spellid==117948 then

  if pswasonbossp34==nil then
    pswasonbossp34=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp34~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    
      --запись для репорта через 2 сек
		if psraidoptionson[2][3][4][1]==1 and pswasonbossp34==1 then
      if psspiritkingtab1==nil then
        psspiritkingtab1={}
        psspiritkingtab2=GetTime()+2
      end
      table.insert(psspiritkingtab1,name2)
		end

    local tt2=""
    if arg2=="SPELL_DAMAGE" then
      tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    else
      tt2=", "
      if arg14 then
        tt2=tt2..psdamageceil(arg14).." "
      end
      if arg12 then
        tt2=tt2.."|cffff0000("..arg12..")|r"
      end
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][4],2)
  end
end




if arg2=="SPELL_AURA_APPLIED" and spellid==118303 then
--сей анонсер
--if psiccinst and string.find(psiccinst,psiccheroic) then
if ps_saoptions[2][3][3][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
--end
end



if (arg2=="SPELL_DAMAGE") and spellid==117918 then

  if pswasonbossp34==nil then
    pswasonbossp34=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp34~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][4],2)
  end
end


if (arg2=="SPELL_DAMAGE" or arg2=="SPELL_MISSED") and spellid==117921 then
psunitisplayer(guid2,name2)
if psunitplayertrue then
  if psmassiveattackstabletemp1==nil then
    psmassiveattackstabletemp1={} --имя игрока по которому попало
    psmassiveattackstabletemp2=GetTime() --время атаки (через 1.5 сек репорт)
    psmassiveattackstabletemp3={} --список трупов от атаки
    
    if pswasonbossp34==nil then
      pswasonbossp34=1
    end

    pscheckwipe1()
    if pswipetrue and pswasonbossp34~=2 then
      psiccwipereport_p1("wipe", "try")
    end
  end
  local bil=0
  if #psmassiveattackstabletemp1>0 then
    for i=1,#psmassiveattackstabletemp1 do
      if psmassiveattackstabletemp1[i]==name2 then
        bil=1
      end
    end
  end
  if bil==0 then
    table.insert(psmassiveattackstabletemp1,name2)
  end
  if arg2=="SPELL_DAMAGE" and arg13 and arg13>=0 then
    --труп
    table.insert(psmassiveattackstabletemp3,psnoservername(name2))
  end
end
end


if arg2=="SPELL_DAMAGE" and (spellid==119553 or spellid==119554 or spellid==118106 or spellid==118105) then
local id=tonumber(string.sub(guid1,6,10),16)
if id==60710 then
  if pswasonbossp34==nil then
    pswasonbossp34=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp34~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    addtotwotables4(name2)
    vezaxsort4()
    if psreportstreliking==nil then
      psreportstreliking=GetTime()+5
      if psshieldnrdrag2==nil then
        psshieldnrdrag2=0
      end
      psshieldnrdrag2=psshieldnrdrag2+1
    end
  end
end
end


if arg2=="SPELL_AURA_APPLIED" and (spellid==118048 or spellid==118163) then
  if pswasonbossp34==nil then
    pswasonbossp34=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp34~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables5(name2)
    vezaxsort5()
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][4],2)
  end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==118303 then
  pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][4],2)
end


--Щит оф даркнесс
if arg2=="SPELL_AURA_APPLIED" and spellid==117697 then
  if pswasonbossp34==nil then
    pswasonbossp34=1
  end
  pskingsshielddark1=GetTime() --старта щита
  pskingsshielddark2=0 --конец щита
  pskingsshielddark3=0 --полученный
  pskingsshielddark4=0 --полученный избыточный
  -- в везакс 6 будут пуржи храниться
  table.wipe(vezaxname6)
  table.wipe(vezaxcrash6)
  if psshielddarknr==nil then
    psshielddarknr=0
  end
  psshielddarknr=psshielddarknr+1
end

if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and arg12==117697 then
  if pskingsshielddark1 then
    addtotwotables6(name1)
    vezaxsort6()
  end
end

if arg2=="SPELL_AURA_REMOVED" and spellid==117697 then
  if pskingsshielddark2 then
    pskingsshielddark2=GetTime()
  end
end

if arg2=="SPELL_DAMAGE" and spellid==117701 and pskingsshielddark3 then
  pskingsshielddark3=pskingsshielddark3+arg12
  if arg13 and arg13>0 then
    pskingsshielddark4=pskingsshielddark4+arg13
    pskingsshielddark3=pskingsshielddark3-arg13
  end
end



--непроницаемый щит
if arg2=="SPELL_AURA_APPLIED" and spellid==117961 then
  if pswasonbossp34==nil then
    pswasonbossp34=1
  end
  pskingsshieldfirst1=GetTime() --старта щита
  pskingsshieldfirst2=0 --конец щита
  pskingsshieldfirst3=0 --кто снял щит
  if psshielddarknr2==nil then
    psshielddarknr2=0
  end
  psshielddarknr2=psshielddarknr2+1
end

if arg2=="SPELL_AURA_REMOVED" and spellid==117961 then
  if pskingsshieldfirst2 then
    pskingsshieldfirst2=GetTime()
  end
end


if (arg2=="SPELL_DISPEL" or arg2=="SPELL_STOLEN") and spellid==117961 then
  if pskingsshieldfirst1 then
    pskingsshieldfirst3=name1
  end
end

if arg2=="SPELL_MISSED" and arg12 and arg12=="IMMUNE" and pskingsshieldfirst1 and name1 then
  psunitisplayer(guid1,name1)
  if psunitplayertrue then
    pscaststartinfo(0,"|cffff0000"..arg12..":|r "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." - "..spellname, -1, "id1", 69, "|s4id117961|id - "..psinfo,psbossnames[2][3][4],2)
  end
end

if arg2=="SWING_MISSED" and spellid and spellid=="IMMUNE" and pskingsshieldfirst1 and name1 then
  psunitisplayer(guid1,name1)
  if psunitplayertrue then
    pscaststartinfo(0,"|cffff0000"..spellid..":|r "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." - "..psspellschoolm, -1, "id1", 69, "|s4id117961|id - "..psinfo,psbossnames[2][3][4],2)
  end
end


end