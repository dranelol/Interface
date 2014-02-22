psbossfilep33=1




function pscmrbossREPORTp331(wipe,try,reset,checkforwipe)
if reset==nil then
if checkforwipe==nil or (checkforwipe and pswasonbossp33 and pswasonbossp33==1) then

	if pswasonbossp33==1 then
		pssetcrossbeforereport1=GetTime()

		if psraidoptionson[2][3][3][2]==1 then
			strochkavezcrash=psmainmdamagefrom.." |s4id130774|id ("..psmainmtotal.."): "
			reportafterboitwotab(psraidchats3[psraidoptionschat[2][3][3][2]], true, vezaxname, vezaxcrash, 1)
		end





	end
	if pswasonbossp33==1 or (pswasonbossp33==2 and try==nil) then

		psiccsavinginf(psbossnames[2][3][3], try, pswasonbossp33)

		strochkavezcrash=psmainmdamagefrom.." |s4id130774|id: "
		reportafterboitwotab("raid", true, vezaxname, vezaxcrash, nil, nil,0,1)


		psiccrefsvin()

	end




	if wipe then
		pswasonbossp33=2
		pscheckbossincombatmcr_3=GetTime()+1
	end
end
end
end


function pscmrbossRESETp331(wipe,try,reset,checkforwipe)
if reset or wipe==nil then
pswasonbossp33=nil


table.wipe(vezaxname)
table.wipe(vezaxcrash)



end
end



function pscombatlogbossp33(arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15)










--if arg2=="SPELL_DAMAGE" and spellid==116281 then

--  if pswasonbossp33==nil then
--    pswasonbossp33=1
--  end
--  psunitisplayer(guid2,name2)
--  if psunitplayertrue then

--    pscheckwipe1()
--    if pswipetrue and pswasonbossp33~=2 then
--      psiccwipereport_p1("wipe", "try")
--    end
--    addtotwotables3(name2)
--    vezaxsort3()
    
      --запись для репорта через 2 сек
--		if psraidoptionson[2][3][3][4]==1 and pswasonbossp33==1 then
--      if psstonebombrep1==nil then
--        psstonebombrep1={}
--        psstonebombrep2=GetTime()+2
--      end
--      table.insert(psstonebombrep1,name2)
--		end

--    local tt2=", "..psdamageceil(arg12)
--    if arg13>=0 then
--      tt2=", "..psdamageceil(arg12-arg13).." |cffff0000("..psoverkill..": "..psdamageceil(arg13)..")|r"
--    end
--    pscaststartinfo(0,spellname..": "..psaddcolortxt(1,name2)..name2..psaddcolortxt(2,name2)..tt2, -1, "id1", 1, "|s4id"..spellid.."|id - "..psinfo,psbossnames[2][3][3],2)
--  end
--end









end