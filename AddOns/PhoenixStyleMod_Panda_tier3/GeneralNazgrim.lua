psbossfilep68=1




function pscmrbossREPORTp681(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp68 and pswasonbossp68==1) then

	if pswasonbossp68==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][8][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143712|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][8][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][8][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143873|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][8][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][8][4]==1 then
			strochkavezcrash=pszzpandatuaddopttxt3.." |s4id143593|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][8][4]], true, vezaxname4, vezaxcrash4, 1)
		end

	end
	if pswasonbossp68==1 or (pswasonbossp68==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][8], try, pswasonbossp68)

		strochkavezcrash=psiccdmgfrom.." |s4id143712|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id143873|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=pszzpandatuaddopttxt3.." |s4id143593|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname4, vezaxcrash4, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp68=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp681(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp68=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)
table.wipe(vezaxname4)
table.wipe(vezaxcrash4)

end
end



function pscombatlogbossp68(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)



if arg2=="SPELL_DAMAGE" and spellid==143712 then
  if pswasonbossp68==nil then
    pswasonbossp68=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp68~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][8],2)
  end
end


if arg2=="SPELL_DAMAGE" and spellid==143873 then
  if pswasonbossp68==nil then
    pswasonbossp68=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp68~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][8],2)
  end
end



--сбивание кастов
if arg2=="SPELL_CAST_START" and spellid==143432 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 91, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][8])
end
if arg2=="SPELL_CAST_START" and spellid==143431 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 92, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][8])
end
if arg2=="SPELL_CAST_START" and spellid==143473 then
pscheckrunningbossid(guid1)
pscaststartinfo(spellid,spellname..": %s.", 2, guid1, 93, "|s4id"..spellid.."|id - "..pseventsincomb2,psbossnames[2][6][8])
end


--урон в стойку
if arg2=="SPELL_AURA_APPLIED" and spellid==143593 then
  psgenstoika=GetTime()
  pscaststartinfo(0,spellname.." |cff00ff00START|r", -1, "id1", 3, "|s4id143593|id - "..psinfo,psbossnames[2][6][8],2)
end

if arg2=="SPELL_AURA_REMOVED" and spellid==143593 and psgenstoika then
  if (GetTime()-psgenstoika)>52 and (GetTime()-psgenstoika)<99 then
    psgenstoika=nil
    
    --РЕПОРТ В ЧАТ
          if #vezaxname3>0 then
            local text=pszzpandatuaddopttxt3.." |s4id143593|id: "
            for i=1,#vezaxname3 do
                text=text..vezaxname3[i].." ("..psdamageceil(vezaxcrash3[i])..")"
                if i==#vezaxname3 then
                  text=text.."."
                else
                  text=text..", "
                end
            end
            if psraidoptionson[2][6][8][3]==1 and pswasonbossp68==1 then
              pszapuskanonsa(psraidchats3[psraidoptionschat[2][6][8][3]], "{rt8} "..psremovecolor(text))
            end
          end
    
    table.wipe(vezaxname3)
    table.wipe(vezaxcrash3)
    pscaststartinfo(0,spellname.." |cffff0000FINISHED|r", -1, "id1", 3, "|s4id143593|id - "..psinfo,psbossnames[2][6][8],2)
  else
    psgenstoika=nil
    table.wipe(vezaxname3)
    table.wipe(vezaxcrash3)
  end
end

if psgenstoika and ((GetTime()-psgenstoika)<70) and (arg2=="SPELL_DAMAGE" or arg2=="SWING_DAMAGE" or arg2=="RANGE_DAMAGE") and guid2 then
  if pswasonbossp68==nil then
    pswasonbossp68=1
  end
  local id=tonumber(string.sub(guid2,6,10),16)
  if id==71515 then
    psunitisplayer(guid1,name1)
    if psunitplayertrue then
      
      --у кого бафф тот не фейлит
      local spbuf=GetSpellInfo(143494)
      if UnitBuff(name1, spbuf) or UnitDebuff(name1, spbuf) then
        --return
      else
		  pscheckwipe1()
		  if pswipetrue and pswasonbossp68~=2 then
			psiccwipereport_p3("wipe", "try")
		  end
		  addtotwotables3(name1)
		  vezaxsort3()
		  addtotwotables4(name1)
		  vezaxsort4()
		  if arg2=="SWING_DAMAGE" then
			  pscaststartinfo(0,arg2..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." (melee attack)", -1, "id1", 3, "|s4id143593|id - "..psinfo,psbossnames[2][6][8],2)
		  else
			  local tt2=", "..psdamageceil(arg12)
			  if arg13>=0 then
				tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
			  end
			  pscaststartinfo(0,arg2..": "..psaddcolortxt(1,name1)..name1..psaddcolortxt(2,name1).." ("..spellname..tt2..")", -1, "id1", 3, "|s4id143593|id - "..psinfo,psbossnames[2][6][8],2)
		  end
	  end
    end
  end
end

--конец модуля урон в стойку


end