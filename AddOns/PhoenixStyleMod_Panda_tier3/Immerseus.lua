psbossfilep61=1




function pscmrbossREPORTp611(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp61 and pswasonbossp61==1) then

	if pswasonbossp61==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][6][1][1]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143412|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][1][1]], true, vezaxname, vezaxcrash, 1)
		end
		if psraidoptionson[2][6][1][2]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143436|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][1][2]], true, vezaxname2, vezaxcrash2, 1)
		end
		if psraidoptionson[2][6][1][3]==1 then
			strochkavezcrash=psiccdmgfrom.." |s4id143297|id ("..psmainmtotal..", "..format(psnofirstsec,1).."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][6][1][3]], true, vezaxname3, vezaxcrash3, 1)
		end


	end
	if pswasonbossp61==1 or (pswasonbossp61==2 and try==nil) then

		psiccsavinginf(psbossnames[2][6][1], try, pswasonbossp61)

		strochkavezcrash=psiccdmgfrom.." |s4id143412|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id143436|id ("..psmainmtotal.."): "
		reportafterboitwotab("raid", true, vezaxname2, vezaxcrash2, nil, nil,0,1)
		strochkavezcrash=psiccdmgfrom.." |s4id143297|id ("..psmainmtotal..", "..format(psnofirstsec,1).."): "
		reportafterboitwotab("raid", true, vezaxname3, vezaxcrash3, nil, nil,0,1)

		psiccrefsvin()

	end




	if wipe then
		pswasonbossp61=2
		pscheckbossincombatmcr_p3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp611(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp61=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)
table.wipe(vezaxname2)
table.wipe(vezaxcrash2)
table.wipe(vezaxname3)
table.wipe(vezaxcrash3)

qpspandaosfp1=nil
qpspandaosfp2=nil


end
end



function pscombatlogbossp61(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)





if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==143412 then
  if pswasonbossp61==nil then
    pswasonbossp61=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp61~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables1(name2)
    vezaxsort1()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][1],2)
  end
end


if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==143436 then
  if pswasonbossp61==nil then
    pswasonbossp61=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp61~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    addtotwotables2(name2)
    vezaxsort2()
    local tt2=", "..psdamageceil(arg12)
      if arg13>=0 then
        tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
      end
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 2, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][1],2)
  end
end



if arg2=="SPELL_PERIODIC_DAMAGE" and spellid==143297 then
  if pswasonbossp61==nil then
    pswasonbossp61=1
  end
  psunitisplayer(guid2,name2)
  if psunitplayertrue then

    pscheckwipe1()
    if pswipetrue and pswasonbossp61~=2 then
      psiccwipereport_p3("wipe", "try")
    end
    
    
    --первую секунду не учитывать
    if qpspandaosfp1==nil then
      qpspandaosfp1={} --имя
      qpspandaosfp2={} --время
    end
    local bil=0
    if #qpspandaosfp1>0 then
      for i=1,#qpspandaosfp1 do
        if qpspandaosfp1[i]==name2 then
          if GetTime()>qpspandaosfp2[i]+2.7 then
            --more than 3 sec passed, not fail
            bil=1
          else
            --fail
            bil=2
          end
          qpspandaosfp2[i]=GetTime()
        end
      end
    else
      table.insert(qpspandaosfp1,name2)
      table.insert(qpspandaosfp2,GetTime())
    end
    if bil==0 then
      table.insert(qpspandaosfp1,name2)
      table.insert(qpspandaosfp2,GetTime())
    end
    local fail=""
    if bil==2 then

      addtotwotables3(name2)
      vezaxsort3()
      fail=" (|cffff0000fail!|r)"
    end
      local tt2=", "..psdamageceil(arg12)
        if arg13>=0 then
          tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
        end
    
    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2..fail, -1, "id1", 3, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][6][1],2)
    
  end
end


end