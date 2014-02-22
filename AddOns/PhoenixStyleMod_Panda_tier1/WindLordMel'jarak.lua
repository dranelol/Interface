psbossfilep24=1




function pscmrbossREPORTp241(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp24 and pswasonbossp24==1) then

	if pswasonbossp24==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][2][4][1]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id121898|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][4][2]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][2][4][3]==1 then
			strochkavezcrash="FAIL |s4id131830|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][4][3]], true, vezaxname2, vezaxcrash2, 1)
			--strochkavezcrash=psmainmdamagefrom.." |s4id131830|id ("..psmainmtotal.."): "
			--reportafterboitwotab(psraidchats3[psraidoptionschat[2][2][4][3]], true, vezaxname3, vezaxcrash3, 1)
		end




	end
	if pswasonbossp24==1 or (pswasonbossp24==2 and try==nil) then

		psiccsavinginf(psbossnames[2][2][4], try, pswasonbossp24)

		strochkavezcrash=psmainmdamagefrom.." |s4id121898|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash="|s4id131830|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psmainmdamagefrom.." |s4id131830|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp24=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp241(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp24=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)

psmaljmob=nil
psmeljarcontol1=nil
psmeljarcontol2=nil
psmeljarcontol3=nil

psmeljaddkilled=nil

psmaxrepmelj=nil
psmaxrepmelj2=nil

end
end



function pscombatlogbossp24(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










if arg2=="SPELL_DAMAGE" and spellid==121898 and UnitName("boss1") then

  if pswasonbossp24==nil then
    pswasonbossp24=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp24~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()


    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][4],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==131830 and UnitName("boss1") then

  if pswasonbossp24==nil then
    pswasonbossp24=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp24~=2 then
      psiccwipereport_p1("wipe", "try")
    end
    --addtotwotables3(name2)
    --vezaxsort3()


    local tt2=", "..psdamageceil(arg12)
    if arg13>=0 then
      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
    end
    --pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 91, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][2][4],2)
  end
end



if arg2=="SPELL_AURA_APPLIED" and spellid==121881 and UnitName("boss1") then
--сей анонсер
--if psiccinst and string.find(psiccinst,psiccheroic) then
if ps_saoptions[2][2][4][1]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
--end
end

if arg2=="SPELL_AURA_APPLIED" and spellid==122064 and UnitName("boss1") then
--сей анонсер
--if psiccinst and string.find(psiccinst,psiccheroic) then
if ps_saoptions[2][2][4][2]==1 then
  ps_sa_sendinfo(name2, spellname.." "..psmain_sa_phrase1, 5, nil, nil)
end
--end
end





--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==122193 and UnitName("boss1") then
  if pswasonbossp24==nil then
    pswasonbossp24=1
  end
pscheckrunningbossid(guid1)
  if psmaljmob==nil then
    psmaljmob={}
  end
  local bil=0
  local nr=0
  if #psmaljmob>0 then
    for i=1,#psmaljmob do
      if psmaljmob[i]==guid1 then
        bil=1
        nr=i
      end
    end
  end
  if bil==0 then
    table.insert(psmaljmob,guid1)
    nr=#psmaljmob
  end
  local addcol1=""
  local addcol2=""
  if nr==2 then
    addcol1="|cff00ff00"
    addcol2="|r"
  elseif nr==3 then
    addcol1="|cffff0000"
    addcol2="|r"
  end
pscaststartinfo(spellid,spellname..": %s ("..addcol1..psmob1.." "..nr..addcol2..") .", 2.5, guid1, 43, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][2][4])
end




--трекер сбивания контроля
if (arg2=="SPELL_AURA_APPLIED" or arg2=="SPELL_AURA_REFRESH") and spellid==122224 and UnitName("boss1") then
  if psmeljarcontol1==nil then
    psmeljarcontol1={} --ид моба
    psmeljarcontol2={} --кто контролил
    psmeljarcontol3={} --время наложения бафа контроля
    psmeldelaytimercheck=GetTime()+1
    if pswasonbossp24==nil then
      pswasonbossp24=1
    end
  end
  local bil=0
  if #psmeljarcontol1>0 then
    for i=1,#psmeljarcontol1 do
      if psmeljarcontol1[i]==guid2 then
        bil=1
        psmeljarcontol2[i]=name1
        psmeljarcontol3[i]=GetTime()
        pscaststartinfo(0,psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." |cff00ff00"..spellname.."|r > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 44, "|s4id122224|id - "..psinfo,psbossnames[2][2][4],2)
      end
    end
  end
  if bil==0 then
    table.insert(psmeljarcontol1,guid2)
    table.insert(psmeljarcontol2,name1)
    table.insert(psmeljarcontol3,GetTime())
    pscaststartinfo(0,psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." |cff00ff00"..spellname.."|r > "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 44, "|s4id122224|id - "..psinfo,psbossnames[2][2][4],2)
  end
end


if arg2=="UNIT_DIED" and UnitName("boss1") then
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==62408 or id==62405 or id==62402 then
    psmeljaddkilled=1
  end
end



if arg2=="SPELL_AURA_BROKEN_SPELL" and UnitName("boss1") and psmeljarcontol1 and #psmeljarcontol1>0 and spellid==122224 and arg12 and arg12~=117624 then
  for i=1,#psmeljarcontol1 do
    if psmeljarcontol1[i] and psmeljarcontol1[i]==guid2 then --GetTime()>psmeljarcontol3[i]+2 только для репорта в чат!! +  psmeljaddkilled==nil
      local tim=math.ceil((GetTime()-psmeljarcontol3[i])*10)/10
      local text="{rt8} "..name1.." "..pszzpandaaddopttxt43.." "..spellname..": "..name2.." > |s4id"..arg12.."|id ("..pszzpandaaddopttxt44..": "..psmeljarcontol2[i]..", "..tim.." "..pssec..")" --чат
      local text2=psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." |cffff0000"..pszzpandaaddopttxt43.."|r "..spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." > "..arg13.." ("..pszzpandaaddopttxt44..": "..psaddcolortxt(1,psmeljarcontol2[i])..psmeljarcontol2[i]..psaddcolortxt(2,psmeljarcontol2[i])..", "..tim.." "..pssec..")" --аддон

      if psmaxrepmelj==nil then
        psmaxrepmelj=0
        psmaxrepmelj2=GetTime()
      end
      if psmaxrepmelj==3 then
        if GetTime()>psmaxrepmelj2+30 then
          psmaxrepmelj=0
        end
      end
      
      if psraidoptionson[2][2][4][4]==1 and pswasonbossp24==1 and psmeljaddkilled==nil and GetTime()>psmeljarcontol3[i]+2 and psmaxrepmelj<3 then --and select(3,GetInstanceInfo())~=7
        pszapuskanonsa(psraidchats3[psraidoptionschat[2][2][4][4]], psremovecolor(text))
        psmaxrepmelj=psmaxrepmelj+1
        psmaxrepmelj2=GetTime()
      end
      
      pscaststartinfo(0,text2, -1, "id1", 44, "|s4id122224|id - "..psinfo,psbossnames[2][2][4],2)
      
      table.remove(psmeljarcontol1,i)
      table.remove(psmeljarcontol2,i)
      table.remove(psmeljarcontol3,i)
    end
  end
end




end