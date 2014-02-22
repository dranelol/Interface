if (GetLocale() == "zhCN") then
	CT_RaidTracker_Translation_Complete = false;

	CT_RaidTracker_lang_LeftGroup = "([^%s]+)离开了团队";
	CT_RaidTracker_lang_JoinedGroup = "([^%s]+)加入了团队";
	CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+)获得了物品："..CT_ITEMREG.."。";
	CT_RaidTracker_lang_ReceivesLoot2 = "你获得了物品："..CT_ITEMREG.."。";
	CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+)获得了物品："..CT_ITEMREG_MULTI.."。";
	CT_RaidTracker_lang_ReceivesLoot4 = "你得到了物品："..CT_ITEMREG_MULTI.."。";
	CT_RaidTracker_lang_ReceivesLootYou = "你";
	
	CT_RaidTracker_ZoneTriggers = {
		["永恒之眼"] = "The Eye of Eternity",
		["黑曜石圣殿"] = "The Obsidian Sanctum",
		["阿尔卡冯的宝库"] = "Vault of Archavon",
		["纳克萨玛斯"] = "Naxxramas",
		["Ulduar"] = "Ulduar",
	};
	
	CT_RaidTracker_BossUnitTriggers = {
		-- Eye of Eternity
		["Malygos"] = "Malygos",
	
		-- Obsidian Sanctum
		["Sartharion"] = "Sartharion",
	
		-- Vault of Archavon
		["Emalon the Storm Watcher"] = "Emalon the Storm Watcher",
		["Archavon the Stone Watcher"] = "Archavon the Stone Watcher",
		-- Vault of Archavon
		
		-- Naxxramas
		["帕奇维克"] = "Patchwerk",
		["格罗布鲁斯"] = "Grobbulus",
		["格拉斯"] = "Gluth",
		["泰迪斯"] = "Thaddius",
		["教官拉苏维奥斯"] = "Instructor Razuvious",
		["收割者戈提克"] = "Gothik the Harvester",
		["瘟疫使者诺斯"] = "Noth the Plaguebringer",
		["肮脏的希尔盖"] = "Heigan the Unclean",
		["TRANSLATION NEEDED"] = "Loatheb",
		["阿努布雷坎"] = "Anub'Rekhan",
		["黑女巫法琳娜"] = "Grand Widow Faerlina",
		["TRANSLATION NEEDED"] = "Maexxna",
		["TRANSLATION NEEDED"] = "Sapphiron",
		["TRANSLATION NEEDED"] = "Kel'Thuzad",
		["-- 4 Horsemen"] = "-- 4 Horsemen",
		["TRANSLATION NEEDED"] = "Baron Rivendare",
		["TRANSLATION NEEDED"] = "Thane Korth'azz",
		["TRANSLATION NEEDED"] = "Lady Blaumeux",
		["TRANSLATION NEEDED"] = "Sir Zeliek",
		-- Naxxramas
		
		-- Ulduar
		["Hodir"] = "Hodir",
		["Stormcaller Brundir"] = "IGNORE", -- The Assembly of Iron
		["Thorim"] = "Thorim",
		["Steelbreaker"] = "IGNORE", -- The Assembly of Iron
		["Freya"] = "Freya",
		["The Assembly of Iron"] = "The Assembly of Iron",
		["Runemaster Molgeim"] = "IGNORE", -- The Assembly of Iron
		["Flame Leviathan"] = "Flame Leviathan",
		["Ignis the Furnace Master"] = "Ignis the Furnace Master",
		["Razorscale"] = "Razorscale",
		["General Vezax"] = "General Vezax",
		["Yogg-Saron"] = "Yogg-Saron",
		["XT-002 Deconstructor"] = "XT-002 Deconstructor",
		["Auriaya"] = "Auriaya",
		["Kologarn"] = "Kologarn",
		["Mimiron"] = "Mimiron",
		["Algalon the Observer"] = "Algalon the Observer",
		-- Ulduar
		
		["DEFAULTBOSS"] = "Trash mob",
		["Track Members"] = "Track Members",		
	};
	
	CT_RaidTracker_lang_BossKills = {
		-- Ulduar
		["It would appear that I've made a slight miscalculation. I allowed my mind to be corrupted by the fiend in the prison, overriding my primary directive. All systems seem to be functional now. Clear."] = "Mimiron",
--		["I...have...failed..."] = "Ignis the Furnace Master",
		["His hold on me dissipates. I can see clearly once more. Thank you, heroes."] = "Freya",
		["Stay your arms! I yield!"] = "Thorim",
		["I...I am released from his grasp! At...last!"] = "Hodir",
--		["Master, they come..."] = "Kologarn",
--		["You are bad... Toys... Very... Baaaaad!"] = "XT-002 Deconstructor",
--		["Mwa-ha-ha-ha! Oh, what horrors await you?"] = "General Vezax",
		["Your fate is sealed. The end of days is finally upon you and ALL who inhabit this miserable little seedling! Uulwi ifis halahs gag erh'ongg w'ssh."] = "Yogg-Saron",
		["Impossible..."] = "The Assembly of Iron", -- Iron Council Hardmode / Steelbreaker last
		["You rush headlong into the maw of madness!"] = "The Assembly of Iron", -- Iron Council Normalmode / Brundir last
		["What have you gained from my defeat? You are no less doomed, mortals!"] = "The Assembly of Iron", -- Iron Council Semimode / Molgeim last
		-- Ulduar
	};


end;
