psbossfilep62=1




function pscmrbossREPORTp621(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp62 and pswasonbossp62==1) then

	if pswasonbossp62==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][2][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144397|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][2][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][2][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143009|id ("..psmainmtotal..", "..format(psnofirstsec,1).."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][2][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][2][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id144367|id ("..psmainmtotal..", format(psnofirstsec,1)): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][2][3]], true, vezaxname3, vezaxcrash3, 1)
		end
		
		

	end
	if pswasonbossp62==1 or (pswasonbossp62==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][2], try, pswasonbossp62)

		strochkavezcrash=psiccdmgfrom.." |s4id144397|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id143009|id ("..psmainmtotal..", "..format(psnofirstsec,1).."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id144367|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)
		
		psiccrefsvin()

	end




	if wipe then
		pswasonbossp62=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp621(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp62=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)

pspandaosfp1=nil
pspandaosfp2=nil


end
end



function pscombatlogbossp62(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)



if arg2=="SPELL_DAMAGE" and spellid==144397 then
  if pswasonbossp62==nil then
    pswasonbossp62=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp62~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][2],2)
  end
end



--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==143958 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][2])
end
if arg2=="SPELL_CAST_START" and spellid==145631 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 92, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][2])
end

--каст пока невидим в логе
--if arg2=="SPELL_CAST_START" and spellid==143423 then
--pscheckrunningbossid(guid1)
--pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 93, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][2])
--end




if arg2=="SPELL_AURA_APPLIED" and spellid==143840 then
  if pswasonbossp62==nil then
    pswasonbossp62=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp62~=2 then
      psiccwipereport_p3("wipe", "try")
    end

    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][2],2)
  end
end



if arg2=="SPELL_DAMAGE" and spellid==143009 then
  if pswasonbossp62==nil then
    pswasonbossp62=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp62~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    
    
    --первую секунду не учитывать
    if pspandaosfp1==nil then
      pspandaosfp1={} --имя
      pspandaosfp2={} --время
    end
    local bil=0
    if #pspandaosfp1>0 then
      for i=1,#pspandaosfp1 do
        if pspandaosfp1[i]==name2 then
          if GetTime()>pspandaosfp2[i]+2.7 then
            --more than 3 sec passed, not fail
            bil=1
          else
            --fail
            bil=2
          end
          pspandaosfp2[i]=GetTime()
        end
      end
    else
      table.insert(pspandaosfp1,name2)
      table.insert(pspandaosfp2,GetTime())
    end
    if bil==0 then
      table.insert(pspandaosfp1,name2)
      table.insert(pspandaosfp2,GetTime())
    end
    local fail=""
    if bil==2 then

      addtotwotables2(name2)
      vezaxsort2()
      fail=" (|cffff0000fail!|r)"
    end
      local tt2=", "..psdamageceil(arg12)
        if arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
    
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2..fail, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][2],2)
    
  end
end



if arg2=="SPELL_DAMAGE" and spellid==144367 then
  if pswasonbossp62==nil then
    pswasonbossp62=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp62~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables3(name2)
    vezaxsort3()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 4, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][2],2)
  end
end


if arg2=="SPELL_AURA_APPLIED" and spellid==143434 then
  if pswasonbossp62==nil then
    pswasonbossp62=1
  end
  pscheckwipe1()
  if pswipetrue and pswasonbossp62~=2 then
    psiccwipereport_p3("wipe", "try")
  end
  pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2), -1, "id1", 5, "|s4id143434|id - "..psinfo,psbossnames[2][6][2],2)
end

if arg2=="SPELL_DISPEL" and arg12==143434 then
  if pswasonbossp62==nil then
    pswasonbossp62=1
  end
  pscheckwipe1()
  if pswipetrue and pswasonbossp62~=2 then
    psiccwipereport_p3("wipe", "try")
  end
  pscaststartinfo(0,"|cff00ff00Dispel:|r "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." ("..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1)..", "..spellname..")", -1, "id1", 5, "|s4id143434|id - "..psinfo,psbossnames[2][6][2],2)
end



if arg2=="SPELL_CAST_SUCCESS" and spellid==143842 then
  if pspsmapwidth==nil and pspsmapheight==nil then
    SetMapToCurrentZone()
    pspsmapwidth,pspsmapheight=psGetMapSize()
  end
  if pspsmapwidth and pspsmapheight then
    local x1,y1=GetPlayerMapPosition(name1)
    local x2,y2=GetPlayerMapPosition(name2)
    if x1 and x1>0 and y2 and y2>0 then
      local range=math.ceil(math.sqrt(math.pow(pspsmapwidth*(x2-x1),2)+math.pow(pspsmapheight*(y2-y1),2))*10)/10
      if range>=200 then
        pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." => "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." = |cff00ff00"..range.." yd.|r", -1, "id1", 6, "|s4id"..spellid.."|id - ACHIEVEMENT",psbossnames[2][6][2],2)
      else
        pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." => "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2).." = |cffff0000"..range.." yd.|r", -1, "id1", 6, "|s4id"..spellid.."|id - ACHIEVEMENT",psbossnames[2][6][2],2)
      end
    end
  end
end

if arg2=="SPELL_CAST_SUCCESS" and spellid==143812 then
  pscaststartinfo(0,"PHASE CHANGE", -1, "id1", 6, "|s4id"..spellid.."|id - ACHIEVEMENT",psbossnames[2][6][2],2)
end


end


function psGetMapSize()
	-- try custom map size first
	local mapName = GetMapInfo()
	local floor, a1, b1, c1, d1 = GetCurrentMapDungeonLevel()

	--Blizzard's map size
	if not (a1 and b1 and c1 and d1) then
		local zoneIndex, a2, b2, c2, d2 = GetCurrentMapZone()
		a1, b1, c1, d1 = a2, b2, c2, d2
	end

	if not (a1 and b1 and c1 and d1) then return end
	return abs(c1-a1), abs(d1-b1)
end