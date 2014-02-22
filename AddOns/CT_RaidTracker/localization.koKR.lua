if (GetLocale() == "koKR") then
	CT_RaidTracker_Translation_Complete = false;

	CT_RaidTracker_lang_LeftGroup = "([^%s]+) has left the raid group";
	CT_RaidTracker_lang_JoinedGroup = "([^%s]+) has joined the raid group";
	CT_RaidTracker_lang_ReceivesLoot1 = "([^%s]+) receives loot: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot2 = "You receive loot: "..CT_ITEMREG..".";
	CT_RaidTracker_lang_ReceivesLoot3 = "([^%s]+) receives loot: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLoot4 = "You receive loot: "..CT_ITEMREG_MULTI..".";
	CT_RaidTracker_lang_ReceivesLootYou = "You";
	
	CT_RaidTracker_ZoneTriggers = {
		["The Eye of Eternity"] = "The Eye of Eternity",
		["The Obsidian Sanctum"] = "The Obsidian Sanctum",
		["Vault of Archavon"] = "Vault of Archavon",
		["Naxxramas"] = "Naxxramas",
		["Ulduar"] = "Ulduar",
	};
	
	CT_RaidTracker_BossUnitTriggers = {
		-- Eye of Eternity
		["Malygos"] = "Malygos",
	
		-- Obsidian Sanctum
		["Sartharion"] = "Sartharion",
	
		-- Vault of Archavon
		["Emalon the Storm Watcher"] = "Emalon the Storm Watcher",
		["바위 감시자 아카본"] = "Archavon the Stone Watcher",
		-- Vault of Archavon

		-- Naxxramas
		["패치워크"] = "Patchwerk",
		["그라불루스"] = "Grobbulus",
		["글루스"] = "Gluth",
		["타디우스"] = "Thaddius",
		["훈련교관 라주비어스"] = "Instructor Razuvious",
		["영혼 착취자 고딕"] = "Gothik the Harvester",
		["역병술사 노스"] = "Noth the Plaguebringer",
		["부정의 헤이건"] = "Heigan the Unclean",
		["로데브"] = "Loatheb",
		["아눕레칸"] = "Anub'Rekhan",
		["귀부인 팰리나"] = "Grand Widow Faerlina",
		["맥스나"] = "Maexxna",
		["사피론"] = "Sapphiron",
		["켈투자드"] = "Kel'Thuzad",
		["-- 4 Horsemen"] = "-- 4 Horsemen",
		["남작 리븐데어"] = "Baron Rivendare",
		["영주 코스아즈"] = "Thane Korth'azz",
		["여군주 블라미우스"] = "Lady Blaumeux",
		["젤리에크 경"] = "Sir Zeliek",
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
