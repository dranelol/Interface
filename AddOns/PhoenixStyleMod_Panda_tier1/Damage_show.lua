tempdmgshowvar=1
function psdamageshow_p1(play,ar1,ar2,ar3)

if pssidamageinf_indexboss[play][ar1][ar2]>1000 and pssidamageinf_indexboss[play][ar1][ar2]<1100 then

--deathwing

local uron=psiccdmgfrom


local psstrochka=""

if ar1==1 then
psstrochka="|CFFFFFF00"..psrestorelinksforexport2(pssidamageinf_title2[play][ar1][ar2]).."\n\r"..uron..":|r "
else
psstrochka="|CFFFFFF00"..pssidamageinf_additioninfo[play][ar1][ar2][1].." - "..psrestorelinksforexport2(pssidamageinf_title2[play][ar1][ar2]).."\n\r"..uron..":|r "
end
local maxnick=#pssidamageinf_damageinfo[play][ar1][ar2][1]
local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
local psinfoshieldtempdamage=0
local pstochki="."


if pssichose5==1 then else
if items[pssichose5]<maxnick then
maxnick=items[pssichose5]
pstochki=",..."
end
end



if #pssidamageinf_damageinfo[play][ar1][ar2][1]>0 then
for i = 1,maxnick do


	psinfoshieldtempdamage=psdamageceil(pssidamageinf_damageinfo[play][ar1][ar2][2][i])


	local rsccodeclass=0

	for j=1,#pssidamageinf_classcolor[play][ar1][1] do
		if pssidamageinf_classcolor[play][ar1][1][j]==pssidamageinf_damageinfo[play][ar1][ar2][1][i] then rsccodeclass=pssidamageinf_classcolor[play][ar1][2][j]
		end
	end


local colorname=pssidamageinf_damageinfo[play][ar1][ar2][1][i]
local tablecolor={"|CFFC69B6D","|CFFC41F3B","|CFFF48CBA","|CFFFFFFFF","|CFF1a3caa","|CFFFF7C0A","|CFFFFF468","|CFF68CCEF","|CFF9382C9","|CFFAAD372","","|cff999999"}

if rsccodeclass==nil or rsccodeclass==0 then rsccodeclass=12 end

if rsccodeclass>0 then
colorname=tablecolor[rsccodeclass]..pssidamageinf_damageinfo[play][ar1][ar2][1][i].."|r"
end

  --запись времени где есть трекеры свитча!!!
	local timesw=""
	--if (pssidamageinf_indexboss[play][ar1][ar2]==202 or pssidamageinf_indexboss[play][ar1][ar2]==203) and #pssidamageinf_switchinfo[play][ar1][ar2][1]>0 then
	--	local bjl=0
	--	for jj=1,#pssidamageinf_switchinfo[play][ar1][ar2][1] do
	--		if pssidamageinf_switchinfo[play][ar1][ar2][1][jj]==pssidamageinf_damageinfo[play][ar1][ar2][1][i] then
	--			timesw=" - "..pssidamageinf_switchinfo[play][ar1][ar2][2][jj].."s"
	--			bjl=1
	--		end
	--	end
	--	if bjl==0 then
	--		timesw=" - ??s"
	--	end
	--end

if i==maxnick then
	--for omnitron to show quantity of attack
	--if pssidamageinf_indexboss[play][ar1][ar2]==4 then
	--	psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage.." - "..pssidamageinf_damageinfo[play][ar1][ar2][3][i]..")"..pstochki
	--else
	psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage..timesw..")"..pstochki
	--end
	if #pssidamageinf_additioninfo[play][ar1][ar2]>1 then
		for tg=2,#pssidamageinf_additioninfo[play][ar1][ar2] do
			if tg==2 then
				psstrochka=psstrochka.."\n\r"..pssidamageinf_additioninfo[play][ar1][ar2][tg]
			else
				psstrochka=psstrochka.."\n"..pssidamageinf_additioninfo[play][ar1][ar2][tg]
			end
		end
	end
	pssavedinfotextframe1:SetText(psstrochka)
else
	--for omnitron to show quantity of attack
	--if pssidamageinf_indexboss[play][ar1][ar2]==4 then
	--	psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage.." - "..pssidamageinf_damageinfo[play][ar1][ar2][3][i].."), "
	--else
	psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage..timesw.."), "
	--end
end
end

end



end --deathwing



end
















function psdamagerep_p1(chat,play,ar1,ar2,ar3,reptype,quant,zapusk, endcombat)



--определяем тип боя
if pssidamageinf_indexboss[play][ar1][ar2]>1000 and pssidamageinf_indexboss[play][ar1][ar2]<1100 then


--deathwing
local psstrochkab=""
if ar1==1 then
psstrochkab="{rt4} PS: "..psrestorelinksforexport2(pssidamageinf_title2[play][ar1][ar2])
else
psstrochkab="{rt4} PS: "..pssidamageinf_additioninfo[play][ar1][ar2][1].." - "..psrestorelinksforexport2(pssidamageinf_title2[play][ar1][ar2])
end
local uron=psiccdmgfrom
--if pssidamageinf_indexboss[play][ar1][ar2]==4 then
--uron=psiccdmgfrom2
--end

--if spetsreport==1 then
--psstrochkab=psstrochkab..". "..pszzdragdiedtoquick
--pssidamageinf_title2[play][ar1][ar2]=pssidamageinf_title2[play][ar1][ar2]..". "..pszzdragdiedtoquick
--end

local psstrochka=""
psstrochka=psstrochka..uron..": "
--local psstrochka2=""
local maxnick=#pssidamageinf_damageinfo[play][ar1][ar2][1]
local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
local psinfoshieldtempdamage=0
local pstochki="."



if ar3==1 then else
if items[ar3]<maxnick then
maxnick=items[ar3]
pstochki=",..."
end
end



if #pssidamageinf_damageinfo[play][ar1][ar2][1]>0 then
for i = 1,maxnick do


	psinfoshieldtempdamage=psdamageceil(pssidamageinf_damageinfo[play][ar1][ar2][2][i])


local kolatak=pssidamageinf_damageinfo[play][ar1][ar2][3][i]

	local timesw=""
	--if (pssidamageinf_indexboss[play][ar1][ar2]==202 or pssidamageinf_indexboss[play][ar1][ar2]==203) and #pssidamageinf_switchinfo[play][ar1][ar2][1]>0 then
	--	local bjl=0
	--	for jj=1,#pssidamageinf_switchinfo[play][ar1][ar2][1] do
	--		if pssidamageinf_switchinfo[play][ar1][ar2][1][jj]==pssidamageinf_damageinfo[play][ar1][ar2][1][i] then
	--			timesw=" - "..pssidamageinf_switchinfo[play][ar1][ar2][2][jj].."s"
	--			bjl=1
	--		end
	--	end
	--	if bjl==0 then
	--		timesw=" - ??s"
	--	end
	--end

if i==maxnick then
	--if string.len(psstrochka)>230 and quant==2 then
		--psstrochka2=psstrochka2..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage..timesw..")"..pstochki
	--else
		--if pssidamageinf_indexboss[play][ar1][ar2]==4 then
		--	psstrochka=psstrochka..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage.." - "..kolatak..")"..pstochki
		--else
		psstrochka=psstrochka..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage..timesw..")"..pstochki
		--end
	--end
	if zapusk then
	pszapuskanonsa(chat, psstrochkab, endcombat)
	pszapuskanonsa(chat, psstrochka, endcombat)
	--pszapuskanonsa(chat, psstrochka2, endcombat)
	else
	local as={psstrochkab,psstrochka}
	if #pssidamageinf_additioninfo[play][ar1][ar2]>1 then
		for tg=2,#pssidamageinf_additioninfo[play][ar1][ar2] do
			table.insert(as,pssidamageinf_additioninfo[play][ar1][ar2][tg])
		end
	end
	if reptype then
		if reptype==1 then
			pssendchatmsg(chat,as)
		end
		if reptype==2 then
			pssendchatmsg("whisper",as,PSFmainfrainsavedinfo_edbox2:GetText())
		end
	end
	end
else
	--if string.len(psstrochka)>230 and quant==2 then
		--if pssidamageinf_indexboss[play][ar1][ar2]==4 then
		--	psstrochka2=psstrochka2..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage.." - "..kolatak.."), "
		--else
			--psstrochka2=psstrochka2..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage..timesw.."), "
		--end
	--else
		--if pssidamageinf_indexboss[play][ar1][ar2]==4 then
		--	psstrochka=psstrochka..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage.." - "..kolatak.."), "
		--else
			psstrochka=psstrochka..pssidamageinf_damageinfo[play][ar1][ar2][1][i].." ("..psinfoshieldtempdamage..timesw.."), "
		--end
	--end
end
end

end



end-- deathwing



end





--сохранение инфо об урон на элегоне
function pselegadddamage(tip,name1,guid2,arg12,arg13,spellid,targetname) --tip nr of trackers, 1001, 1002, 1003, 1004 увеличивать номер +tip и ПИСАТЬ ТУТ В СПИСКЕ

  if pselegontabldamage1 and pselegontabldamage1[1] and #pselegontabldamage1[1]>0 then
    local byl=0
    for u=1,#pselegontabldamage1[1] do
      if pselegontabldamage1[1][u]==guid2 and byl==0 then
        byl=1
        pselegdamadddamage(tip,name1,guid2,arg12,arg13,spellid)
      end
    end
    if byl==0 then
      pselegmodnewadd(tip,name1,guid2,arg12,nil,targetname)
    end
  else
    --создаем новые табл
    if tip==1 or tip==2 then
      pscreatesavedreports3(psbossnames[2][3][5])
    end
    if tip==3 then
      pscreatesavedreports3(psbossnames[2][4][3])
    end
    if tip==4 then
      pscreatesavedreports3(psbossnames[2][2][5])
    end
    
    pscreatefightincombat=1
    psaddclasscolors()
    pselegmodnewadd(tip,name1,guid2,arg12,nil,targetname)
    --psdmgresetinglastfight()
  end
end

function pselegmodnewadd(tip,name1,guid2,arg12,checkforalreadysum,targetname)
local check=0 --проверять на то что гуид уже создан если это надо:

if pselegontabldamage1 and pselegontabldamage1[1] and #pselegontabldamage1[1]>0 and checkforalreadysum==nil then
  for i=1,#pselegontabldamage1[1] do
    if pselegontabldamage1[1][i]==guid2 then
      check=1
    end
  end
end

if check==0 then

  if pscreatefightincombat then
    local h,m = GetGameTime()
    if h<10 then h="0"..h end
    if m<10 then m="0"..m end
    local time=h..":"..m
    local cifra=0
    if tip==1 then
      psiccschet2=psiccschet2+1
      cifra=psiccschet2
    end

    if pselegontabldamage1==nil then
      pselegontabldamage1={{},{},{},{}}
    end


    table.insert(pselegontabldamage1[1],guid2)


    table.insert(pselegontabldamage1[2],arg12)
    table.insert(pselegontabldamage1[3],0)
    table.insert(pselegontabldamage1[4],cifra)
    if tip==1 and pselegmaxHPadd1==nil then
      pselegmaxHPadd1=0
    end


    local an=""
    if tip==1 then
      an="|snpc"..pselegnamedamageadd1.."^60793|fnpc" or "Mob"
      local hptrack=psonlyhpabove
                hptrack=format(psonlyhpabove,25)
      an=an..": "..cifra..". "..hptrack
    end
    if tip==2 then
      an="|snpc"..pselegnamedamageadd2.."^60913|fnpc" or "Mob"
      an=an..": "..pselegonwavenumber
    end
    if tip==3 then
      an="|snpc"..psbossnames[2][4][3].."^62983|fnpc" or "Mob"
      an=an..": "..GetSpellInfo(123461).." "..psleishinmr
    end
    if tip==4 then
      an=targetname
    end
      table.insert(pssidamageinf_indexboss[pssavedplayerpos][1],1000+tip)
      table.insert(pssidamageinf_title2[pssavedplayerpos][1],an)
      if tip==1 or tip==2 then
        table.insert(pssidamageinf_additioninfo[pssavedplayerpos][1],{psbossnames[2][3][5]..", "..time})
      end
      if tip==3 then
        table.insert(pssidamageinf_additioninfo[pssavedplayerpos][1],{psbossnames[2][4][3]..", "..time})
      end
      if tip==4 then
        table.insert(pssidamageinf_additioninfo[pssavedplayerpos][1],{psbossnames[2][2][5]..", "..time})
      end
      table.insert(pssidamageinf_damageinfo[pssavedplayerpos][1],{{},{},{}})
      table.insert(pssidamageinf_switchinfo[pssavedplayerpos][1],{{},{}})

    psupdateframewithnewinfo()
  else
  --тест вставил проверку на созданную табл, если ее нету тоооо с нуля все!

    --создаем новые табл
    if tip==1 or tip==2 then
      pscreatesavedreports3(psbossnames[2][3][5])
    end
    if tip==3 then
      pscreatesavedreports3(psbossnames[2][4][3])
    end
    if tip==4 then
      pscreatesavedreports3(psbossnames[2][2][5])
    end
     
    pscreatefightincombat=1
    psaddclasscolors()
    pselegmodnewadd(tip,name1,guid2,arg12,nil,targetname)

  end--конец теста
end
end




function pselegdamadddamage(tip,name1,guid2,arg12,arg13,spellid)
local lasttabletoaddfortendons=0
for ii=1,#pselegontabldamage1[1] do
	if pselegontabldamage1[1][ii]==guid2 then
    lasttabletoaddfortendons=ii
		if tip==1 then
			local dmg2=arg12
			if pselegmaxHPadd1 and pselegmaxHPadd1~=0 and pselegontabldamage1[2][ii]<pselegmaxHPadd1 and pselegontabldamage1[2][ii]+dmg2>pselegmaxHPadd1 then
				dmg2=math.ceil(pselegontabldamage1[2][ii]+arg12-pselegmaxHPadd1)
			end

			pselegontabldamage1[2][ii]=pselegontabldamage1[2][ii]+arg12

			if pselegmaxHPadd1 and pselegmaxHPadd1~=0 and pselegontabldamage1[2][ii]>pselegmaxHPadd1 then
				psmoddmg_addinfodmg(name1,dmg2,0,ii)
				psmoddmg_sortinfodmg(ii)
			end
		end
		if tip==2 then
			psmoddmg_addinfodmg(name1,arg12,0,ii)
			psmoddmg_sortinfodmg(ii)
      pselegontabldamage1[2][ii]=pselegontabldamage1[2][ii]+arg12
		end
		if tip==3 or tip==4 then
			psmoddmg_addinfodmg(name1,arg12,0,ii)
			psmoddmg_sortinfodmg(ii)
      pselegontabldamage1[2][ii]=pselegontabldamage1[2][ii]+arg12
		end
		
	end
end
if lasttabletoaddfortendons>0 then
		--if tip==2 then
		--	psmoddmg_addinfodmg(name1,arg12,0,lasttabletoaddfortendons)
		--	psmoddmg_sortinfodmg(lasttabletoaddfortendons)
    --  pselegontabldamage1[2][lasttabletoaddfortendons]=pselegontabldamage1[2][lasttabletoaddfortendons]+arg12
		--end
end
end




function psdamageshow_p1_allmerge(play,ar1,ar2,ar3,bosstitle,addemptyline)
  local uron=psiccdmgfrom
  local psstrochka=""
  local ret=0

        local a1=""
        local a2=""
        if pssavedinfocheckexport[1]==1 then
          a1="[color=orange]"
          a2="[/color]"
        end
    psstrochka=addemptyline..a1..psrestorelinksforexport(pssidamageinf_title2[play][ar1][ar2]).."\n\r"..uron..": "..a2

  local maxnick=#pssidamageinf_damageinfo[play][ar1][ar2][1]
  local items = {psiccall, 5, 7, 10, 12, 15, 17, 20}
  local psinfoshieldtempdamage=0
  local pstochki="."

  if pssichose5==1 then else
    if items[pssichose5]<maxnick then
      maxnick=items[pssichose5]
      pstochki=",..."
    end
  end

  if #pssidamageinf_damageinfo[play][ar1][ar2][1]>0 then
    psstrochka=bosstitle..psstrochka
    bosstitle=""
    for i = 1,maxnick do

      psinfoshieldtempdamage=psdamageceil(pssidamageinf_damageinfo[play][ar1][ar2][2][i])
      local rsccodeclass=0

      for j=1,#pssidamageinf_classcolor[play][ar1][1] do
        if pssidamageinf_classcolor[play][ar1][1][j]==pssidamageinf_damageinfo[play][ar1][ar2][1][i] then rsccodeclass=pssidamageinf_classcolor[play][ar1][2][j]
        end
      end

      local colorname=pssidamageinf_damageinfo[play][ar1][ar2][1][i]
      local tablecolor={"|CFFC69B6D","|CFFC41F3B","|CFFF48CBA","|CFFFFFFFF","|CFF1a3caa","|CFFFF7C0A","|CFFFFF468","|CFF68CCEF","|CFF9382C9","|CFFAAD372","","|cff999999"}

      if rsccodeclass==nil or rsccodeclass==0 then rsccodeclass=12 end

      if rsccodeclass>0 then
        colorname=tablecolor[rsccodeclass]..pssidamageinf_damageinfo[play][ar1][ar2][1][i].."|r"
      end

      local timesw=""
      if (pssidamageinf_indexboss[play][ar1][ar2]==202 or pssidamageinf_indexboss[play][ar1][ar2]==203) and #pssidamageinf_switchinfo[play][ar1][ar2][1]>0 then
        local bjl=0
        for jj=1,#pssidamageinf_switchinfo[play][ar1][ar2][1] do
          if pssidamageinf_switchinfo[play][ar1][ar2][1][jj]==pssidamageinf_damageinfo[play][ar1][ar2][1][i] then
            timesw=" - "..pssidamageinf_switchinfo[play][ar1][ar2][2][jj].."s"
            bjl=1
          end
        end
        if bjl==0 then
          timesw=" - ??s"
        end
      end

      if i==maxnick then
        psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage..timesw..")"..pstochki
        if #pssidamageinf_additioninfo[play][ar1][ar2]>1 then
          for tg=2,#pssidamageinf_additioninfo[play][ar1][ar2] do
            if tg==2 then
              psstrochka=psstrochka.."\n\r"..pssidamageinf_additioninfo[play][ar1][ar2][tg]
            else
              psstrochka=psstrochka.."\n"..pssidamageinf_additioninfo[play][ar1][ar2][tg]
            end
          end
        end
        pssavedinfotextframe1:SetText(psstrochka)
      else
        psstrochka=psstrochka..colorname.." ("..psinfoshieldtempdamage..timesw.."), "
      end
    end
    ret=1
    return psstrochka, bosstitle
  end
  if ret==0 then
    return "", bosstitle
  end
end