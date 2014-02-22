if (GetLocale() == "zhTW") then
	CT_RaidTracker_Translation_Complete = false;

	CT_RaidTracker_lang_LeftGroup = "([^%s]+) 離開了團隊";  
	CT_RaidTracker_lang_JoinedGroup = "([^%s]+) 加入了團隊";
	CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) 拾取了物品: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot2 = "你拾取了物品: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) 獲得戰利品: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLoot4 = "你獲得戰利品: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLootYou = "你";
	
	CT_RaidTracker_ZoneTriggers = {
		["永恆之眼"] = "The Eye of Eternity",
		["黑曜聖所"] = "The Obsidian Sanctum",
		["亞夏梵穹殿"] = "Vault of Archavon",
		["納克薩瑪斯"] = "Naxxramas",
		["奧杜亞"] = "Ulduar",
	};
	
	CT_RaidTracker_BossUnitTriggers = {
		-- Eye of Eternity
		["瑪里苟斯"] = "Malygos",
	
		-- Obsidian Sanctum
		["撒爾薩里安"] = "Sartharion",
	
		-- Vault of Archavon
		["『風暴看守者』艾瑪薩"] = "Emalon the Storm Watcher",
		["『石之看守者』亞夏梵"] = "Archavon the Stone Watcher",
		-- Vault of Archavon

		-- Naxxramas
		["縫補者"] = "Patchwerk",
		["葛羅巴斯"] = "Grobbulus",
		["古魯斯"] = "Gluth",
		["泰迪斯"] = "Thaddius",
		["講師拉祖維斯"] = "Instructor Razuvious",
		["『收割者』高希"] = "Gothik the Harvester",
		["『瘟疫使者』諾斯"] = "Noth the Plaguebringer",
		["『不潔者』海根"] = "Heigan the Unclean",
		["憎恨者"] = "Loatheb",
		["阿努比瑞克漢"] = "Anub'Rekhan",
		["大寡婦費琳娜"] = "Grand Widow Faerlina",
		["梅克絲娜"] = "Maexxna",
		["薩菲隆"] = "Sapphiron",
		["科爾蘇加德"] = "Kel'Thuzad",
		["-- 4 Horsemen"] = "-- 4 Horsemen",
		["瑞文戴爾男爵"] = "Baron Rivendare",
		["寇斯艾茲族長"] = "Thane Korth'azz",
		["布洛莫斯女士"] = "Lady Blaumeux",
		["札里克爵士"] = "Sir Zeliek",
		-- Naxxramas
				
		-- Ulduar
    ["霍迪爾"] = "Hodir",
    ["風暴召喚者布倫迪爾"] = "IGNORE", -- The Assembly of Iron
    ["索林姆"] = "Thorim",
    ["破鋼者"] = "IGNORE", -- The Assembly of Iron
    ["芙蕾雅"] = "Freya",
		["The Assembly of Iron"] = "The Assembly of Iron",
    ["符文大師墨吉姆"] = "IGNORE", -- The Assembly of Iron
    ["烈焰戰輪"] = "Flame Leviathan",
    ["『火爐之主』伊格尼司"] = "Ignis the Furnace Master",
    ["銳鱗"] = "Razorscale",
    ["威札斯將軍"] = "General Vezax",
    ["尤格薩倫"] = "Yogg-Saron",
    ["XT-002 拆解者"] = "XT-002 Deconstructor",
    ["奧芮雅"] = "Auriaya",
    ["柯洛剛恩"] = "Kologarn",
    ["彌米倫"] = "Mimiron",
    ["『觀察者』艾爾加隆"] = "Algalon the Observer",
		-- Ulduar
		
		["DEFAULTBOSS"] = "Trash mob",
		["Track Members"] = "Track Members",		
	};

	CT_RaidTracker_lang_BossKills = {
		-- Ulduar
		["It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear."] = "彌米倫", -- Mimiron
--		["I...have...failed..."] = "Ignis the Furnace Master",
		["His hold on me dissipates. I can see clearly once more. Thank you, heroes."] = "芙蕾雅", -- Freya
		["Stay your arms! I yield!"] = "索林姆", -- Thorim
		["I...I am released from his grasp! At...last!"] = "霍迪爾", -- Hodir
--		["Master, they come..."] = "Kologarn",
--		["You are bad... Toys... Very... Baaaaad!"] = "XT-002 Deconstructor",
--		["Mwa-ha-ha-ha! Oh, what horrors await you?"] = "General Vezax",
		["Your fate is sealed. The end of days is finally upon you and ALL who inhabit this miserable little seedling! Uulwi ifis halahs gag erh'ongg w'ssh."] = "尤格薩倫", -- Yogg-Saron
		["Impossible..."] = "The Assembly of Iron", -- Iron Council Hardmode / Steelbreaker last
		["You rush headlong into the maw of madness!"] = "The Assembly of Iron", -- Iron Council Normalmode / Brundir last
		["What have you gained from my defeat? You are no less doomed, mortals!"] = "The Assembly of Iron", -- Iron Council Semimode / Molgeim last
		-- Ulduar
	};

end;
