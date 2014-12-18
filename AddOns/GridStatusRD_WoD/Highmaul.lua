--local zone = "Highmaul"
local zoneid = 994

--zoneid, debuffID, order, icon_priority, colorpriority, timer, stackable, color, defaultdisable, noicon
--, true, true is for stackable

-- Check Compatibility
if GridStatusRD_WoD.rd_version < 600 then
	return
end

--Trash
GridStatusRaidDebuff:DebuffId(zoneid, 175601, 1, 5, 5) -- Trash  TAINTED CLAWS
GridStatusRaidDebuff:DebuffId(zoneid, 172069, 1, 5, 5) -- Trash RADIATING POISON
GridStatusRaidDebuff:DebuffId(zoneid, 56037, 1,  4, 4) -- Trash  RUNE OF DESTRUCTION
GridStatusRaidDebuff:DebuffId(zoneid, 175654, 1, 5, 5) -- Trash RUNE OF DISINTEGRATION
--GridStatusRaidDebuff:DebuffId(zoneid, 1,       , 5, 5) -- Trash  RENDING SLASH

--The Butcher
GridStatusRaidDebuff:BossNameId(zoneid, 10, "The Butcher")
GridStatusRaidDebuff:DebuffId(zoneid, 156152, 11, 5, 5, true, true) --GUSHINGWOUNDS
GridStatusRaidDebuff:DebuffId(zoneid, 156151, 12, 6, 6) --THETENDERIZER
GridStatusRaidDebuff:DebuffId(zoneid, 156143, 13, 5, 5, true, true) --THECLEAVER
GridStatusRaidDebuff:DebuffId(zoneid, 163046, 14, 5, 5) --PALEVITRIOL

--Kargath Bladefist
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Kargath Bladefist")
GridStatusRaidDebuff:DebuffId(zoneid, 159113, 21, 5, 5) --IMPALE
GridStatusRaidDebuff:DebuffId(zoneid, 159178, 22, 6, 6) --OPENWOUNDS
GridStatusRaidDebuff:DebuffId(zoneid, 159213, 23, 7, 7) --MONSTERSBRAWL
GridStatusRaidDebuff:DebuffId(zoneid, 158986, 24, 4, 4) --BERSERKERRUSH
GridStatusRaidDebuff:DebuffId(zoneid, 159410, 25, 5, 5) --MAULINGBREW
GridStatusRaidDebuff:DebuffId(zoneid, 160521, 26, 6, 6) --VILEBREATH
GridStatusRaidDebuff:DebuffId(zoneid, 159386, 27, 5, 5) --IRONBOMB
GridStatusRaidDebuff:DebuffId(zoneid, 159188, 28, 5, 5) --GRAPPLE
GridStatusRaidDebuff:DebuffId(zoneid, 162497, 29, 4, 4) --ONTHEHUNT
GridStatusRaidDebuff:DebuffId(zoneid, 159202, 30, 5, 5) --FLAME JET

--Twin Ogron 
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Twin Ogron")
GridStatusRaidDebuff:DebuffId(zoneid, 158026, 41, 6, 6) --ENFEEBLINGROAR
GridStatusRaidDebuff:DebuffId(zoneid, 158241, 42, 5, 5, true, true) --BLAZE
GridStatusRaidDebuff:DebuffId(zoneid, 155569, 43, 5, 5) --INJURED
GridStatusRaidDebuff:DebuffId(zoneid, 167200, 44, 5, 5, true, true) --ARCANEWOUND
GridStatusRaidDebuff:DebuffId(zoneid, 159709, 45, 6, 6, true, true) --WEAKENEDDEFENSES 159709 167179
GridStatusRaidDebuff:DebuffId(zoneid, 163374, 46, 4, 4) --ARCANEVOLATILITY

--Ko'ragh
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Ko'ragh")
GridStatusRaidDebuff:DebuffId(zoneid, 161242, 51, 4, 4) --CAUSTICENERGY
GridStatusRaidDebuff:DebuffId(zoneid, 161358, 52, 4, 4) --SUPPRESSION FIELD
GridStatusRaidDebuff:DebuffId(zoneid, 162184, 53, 6, 6) --EXPELMAGICSHADOW
GridStatusRaidDebuff:DebuffId(zoneid, 162186, 54, 6, 6) --EXPELMAGICARCANE
GridStatusRaidDebuff:DebuffId(zoneid, 161411, 55, 6, 6) --EXPELMAGICFROST
GridStatusRaidDebuff:DebuffId(zoneid, 163472, 56, 4, 4) --DOMINATINGPOWER
GridStatusRaidDebuff:DebuffId(zoneid, 162185, 57, 7, 7) --EXPELMAGICFEL

--Tectus
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Tectus")
--CRYSTALLINEBARRAGE
GridStatusRaidDebuff:DebuffId(zoneid, 162892, 61, 5, 5) --INFESTINGSPORES--PETRIFICATION

--Brackenspore
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Brackenspore")
GridStatusRaidDebuff:DebuffId(zoneid, 163242, 71, 5, 5, true, true) --INFESTINGSPORES
GridStatusRaidDebuff:DebuffId(zoneid, 163590, 72, 5, 5) --CREEPINGMOSS
GridStatusRaidDebuff:DebuffId(zoneid, 163241, 73, 5, 5, true, true) --ROT
GridStatusRaidDebuff:DebuffId(zoneid, 159220, 74, 4, 4) --NECROTICBREATH
GridStatusRaidDebuff:DebuffId(zoneid, 160179, 75, 6, 6) --MINDFUNGUS
GridStatusRaidDebuff:DebuffId(zoneid, 159972, 76, 6, 6, true, true) --FLESHEATER

--Imperator Mar'gok 
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Imperator Mar'gok")
GridStatusRaidDebuff:DebuffId(zoneid, 156238, 81, 4, 4) --BRANDED  156238 163990 163989 163988
GridStatusRaidDebuff:DebuffId(zoneid, 156467, 82, 5, 5) --DESTRUCTIVERESONANCE  156467 164075 164076 164077
GridStatusRaidDebuff:DebuffId(zoneid, 157349, 83, 5, 5) --FORCENOVA  157349 164232 164235 164240
GridStatusRaidDebuff:DebuffId(zoneid, 158605, 84, 4, 4) --MARKOFCHAOS  158605 164176 164178 164191
GridStatusRaidDebuff:DebuffId(zoneid, 157763, 85, 4, 4) --FIXATE
GridStatusRaidDebuff:DebuffId(zoneid, 158553, 86, 6, 6, true, true) --CRUSHARMOR
