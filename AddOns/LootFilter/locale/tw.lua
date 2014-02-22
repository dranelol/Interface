--------------------------------------------------------------------------
-- Traditional Chinese Locale
-- by 巴納扎爾 天外天 Jane
-- Last Modified 10/02/2008
--------------------------------------------------------------------------
if ( GetLocale() == "zhTW" ) then
	LootFilter.Locale = {
		-- weird looking keys for quality because we need to sort on them
		qualities= {
			["QUaGrey"]= 0,
			["QUbWhite"]= 1,
			["QUcGreen"]= 2,
			["QUdBlue"]= 3,
			["QUePurple"]= 4,
			["QUfOrange"]= 5,
			["QUgRed"]= 6,
			["QUhTan"] = 7,
			["QUhQuest"]= -1 
		},
		types = {
			["Armor"] = "護甲",
			["Consumables"] = "消耗品",
			["Containers"] = "容器",
			["Gems"] = "珠寶",
			["Key"] = "鑰匙",
			["Miscellaneous"] = "雜物",
			["Projectile"] = "彈藥",
			["Quest"] = "任務物品",
			["Quiver"] = "箭袋",		
			["Recipe"] = "配方",
			["TradeGoods"] = "商品",
			["Weapons"] = "武器",
		},
		radioButtonsText= {
			["QUaGrey"]= "粗糙 (灰色)",
			["QUbWhite"]= "普通 (白色)",
			["QUcGreen"]= "優秀 (綠色)",
			["QUdBlue"]= "精良 (藍色)",
			["QUePurple"]= "史詩 (紫色)",
			["QUfOrange"]= "傳說 (橘色)",
			["QUgRed"]= "神器 (紅色)",
			["QUhTan"] = "Heirloom (Tan)",
			["QUhQuest"]= "任務",
	
			-- Armor
			["TYArmorMiscellaneous"]= "其他",
			["TYArmorCloth"]= "布甲",
			["TYArmorLeather"]= "皮甲",
			["TYArmorMail"]= "鎖甲",
			["TYArmorPlate"]= "鎧甲",
			["TYArmorShields"]= "盾牌",
			["TYArmorLibrams"]= "聖契",
			["TYArmorIdols"]= "塑像",
			["TYArmorTotems"]= "圖騰",
			
			-- Consumable
			["TYConsumableFoodDrink"]= "食物和飲料",
			["TYConsumablePotion"]= "藥水",
			["TYConsumableElixir"]= "藥劑",
			["TYConsumableFlask"]= "精煉藥劑",
			["TYConsumableBandage"]= "繃帶",
			["TYConsumableItem Enhancement"]= "物品附魔",
			["TYConsumableScroll"]= "卷軸",
			["TYConsumableOther"]= "其他",
			["TYConsumableConsumable"]= "消耗品",
			
			-- Container
			["TYContainerBag"]= "容器",
			["TYContainerEnchanting Bag"]= "附魔包",
			["TYContainerEngineering Bag"]= "工程包",
			["TYContainerGem Bag"]= "寶石背包",
			["TYContainerHerb Bag"]= "草蘗包",
			["TYContainerMining Bag"]= "礦石包",
			["TYContainerSoul Bag"]= "靈魂裂片包",
			["TYContainerLeatherworking Bag"]= "製皮包",
			
			
			-- Miscellaneous
			["TYMiscellaneousJunk"]= "垃圾",
			["TYMiscellaneousReagent"]= "施法材料",
			["TYMiscellaneousPet"]= "寵物",
			["TYMiscellaneousHoliday"]= "節慶用品",
			["TYMiscellaneousOther"]= "其他",
			-- Gem
			["TYGemBlue"] = "藍色",
			["TYGemGreen"] = "綠色",
			["TYGemOrange"] = "橘色",
			["TYGemMeta"] = "變換",
			["TYGemPrismatic"] = "稜彩",
			["TYGemPurple"] = "紫色",
			["TYGemRed"] = "紅色",
			["TYGemSimple"] = "簡單",
			["TYGemYellow"] = "黃色",
			
			
			-- Key
			["TYKeyKey"]= "鑰匙",
			-- Projectile
			["TYProjectileArrow"]= "箭",
			["TYProjectileBullet"]= "子彈",
			-- Quest
			["TYQuestQuest"]= "任務",
			
			-- Quiver
			["TYQuiverAmmoPouch"]= "彈藥包",
			["TYQuiverQuiver"]= "箭袋",				
			
			-- Recipe
			["TYRecipeAlchemy"]= "鍊金術",
			["TYRecipeBlacksmithing"]= "鍛造",
			["TYRecipeBook"]= "書籍",
			["TYRecipeCooking"]= "烹飪",
			["TYRecipeEnchanting"]= "附魔",
			["TYRecipeEngineering"]= "工程學",
			["TYRecipeFirstAid"]= "急救",
			["TYRecipeLeatherworking"]= "製皮",
			["TYRecipeTailoring"]= "裁縫",
			
					
			-- Trade Goods
			["TYTrade GoodsElemental"] = "元素材料",
			["TYTrade GoodsCloth"] = "布料",
			["TYTrade GoodsLeather"] = "皮革",
			["TYTrade GoodsMetal & Stone"] = "金屬與石頭", 
			["TYTrade GoodsMeat"] = "肉類",
			["TYTrade GoodsHerb"] = "草藥",
			["TYTrade GoodsEnchanting"] = "附魔", 
			["TYTrade GoodsJewelcrafting"] = "珠寶設計",
			["TYTrade GoodsParts"]= "零件",
			["TYTrade GoodsDevices"]= "裝置",
			["TYTrade GoodsExplosives"]= "爆裂物",
			["TYTrade GoodsOther"]= "其他",
			["TYTrade GoodsTradeGoods"]= "商品",
			
			-- Weapon
			["TYWeaponBows"]= "弓",
			["TYWeaponCrossbows"]= "弩",
			["TYWeaponDaggers"]= "匕首",
			["TYWeaponGuns"]= "槍械",
			["TYWeaponFishingPoles"]= "魚竿",
			["TYWeaponFistWeapons"]= "拳套",
			["TYWeaponMiscellaneous"]= "其他",
			["TYWeaponOneHandedAxes"]= "單手斧",
			["TYWeaponOneHandedMaces"]= "單手錘",
			["TYWeaponOneHandedSwords"]= "單手劍",
			["TYWeaponPolearms"]= "長柄武器",
			["TYWeaponStaves"]= "法杖",
			["TYWeaponThrown"]= "投擲武器",
			["TYWeaponTwoHandedAxes"]= "雙手斧",
			["TYWeaponTwoHandedMaces"]= "雙手錘",
			["TYWeaponTwoHandedSwords"]= "雙手劍",
			["TYWeaponWands"]= "魔杖",
			
			["OPEnable"]= "啟用 Loot Filter",
			["OPCaching"]= "啟用拾取快取",
			["OPTooltips"]= "顯示提示訊息",
			["OPNotifyDelete"]= "刪除時提示訊息",
			["OPNotifyKeep"]= "保留時提示訊息",
			["OPNotifyNoMatch"]= "無符合條件時提示訊息",
			["OPNotifyOpen"]= "自動開啟提示訊息",
			["OPNotifyNew"]= "新版本提示訊息",
			["OPValKeep"]= "保留物品 - 出售價格大於",
			["OPValDelete"]= "刪除物品 - 出售價格小於",
			["OPOpenVendor"]= "與商人交談時自動開啟",
			["OPAutoSell"]= "自動開始出售",
			["OPNoValue"]= "保留未知價格的物品", 
			["OPMarketValue"]= "使用 Auctioneer 插件提供的拍賣場價格取代給商人的出售價格",
			["OPBag0"]= "背包",
			["OPBag1"]= "背包 1",
			["OPBag2"]= "背包 2",
			["OPBag3"]= "背包 3",
			["OPBag4"]= "背包 4",
			["TYWands"]= "魔杖"
		},
		LocText = {
			["LTTryopen"] = "嘗試開啟",
			["LTNameMatched"] = "名稱符合",
			["LTQualMatched"] = "品質符合",
			["LTQuest"] = "任務",              -- Used to match Quest Item as Quality Value
			["LTQuestItem"] = "任務物品",
			["LTTypeMatched"]= "類型符合",
			["LTKept"] = "已保留",
			["LTNoKnownValue"] = "物品價格未知",
			["LTValueHighEnough"] = "價格已高到設定條件",
			["LTValueNotHighEnough"] = "價格未高到設定條件",
			["LTNoMatchingCriteria"] = "未找到匹配條件",
			["LTWasSold"] = "已售出",
			["LTWasDeleted"] = "已刪除",
			["LTNewVersion1"] = "新版本",
			["LTNewVersion2"] = "Loot Filter 已經找到。 請至 http://www.lootfilter.com 下載。",
			["LTAddedCosQuest"] = "Added because of quest",
			["LTDeleteItems"] = "刪除物品",
			["LTSellItems"] = "售出物品",
			["LTFinishedSC"] = "已完成 售出/清除。",
			["LTNoOtherCharacterToCopySettings"] = "你目前沒有任何可供複製設定的角色。",
			["LTTotalValue"] = "全部價格",
			["LTSessionInfo"] = "以下某些物品的價格已經在本次處理中被記錄下來。",
			["LTSessionTotal"] = "全部價格",
			["LTSessionItemTotal"] = "物品的數量",
			["LTSessionAverage"] = "平均價格 / 每件",
			["LTSessionValueHour"] = "平均價格 / 每小時",
			["LTNoMatchingItems"] = "沒有找到符合的物品。",
			["LTItemLowestValue"] = "物品有最低價格",
			["LTVendorWinClosedWhileSelling"] = "當售出物品時關閉商人視窗。",
			["LTTimeOutItemNotFound"] = "逾時。 在清單中的物品有一或多項無法找到。",
		},
		LocTooltip = {
			["LToolTip1"] = "此清單為沒有附合任何一個保留條件的物品。 你可以選擇自動售出或刪除這些物品。 使用 shift-滑鼠左鍵 點擊物品名稱來新增物品到保留清單中。",
			["LToolTip2"] = "如果你不在意物品是否具備此項特徵請選取此項。",
			["LToolTip3"] = "如果你想 保留 具有此特徵的物品，請選取此項。",
			["LToolTip4"] = "如果你想 刪除 具有此特徵的物品，請選取此項。",
			["LToolTip5"] = "只要符合此清單中任何一個名稱的物品將會被 保留。\n\n每一行輸入一個名稱。 你可以在名稱之後加上一個 ';' 來輸入註解。 你可以使用 '#' 前置字元來設定樣式以進行部份名稱的比對。 這裡是一些樣式的設定範例:\n#(.*)藥水$ ; 比對名稱結尾為 '藥水' 的物品\n#(.*)卷軸(.*) ; 比對名稱中包含 '卷軸' 的物品\n使用 '##' 前置字串可以用來比對物品的提示說明內容。",
			["LToolTip6"] = "只要符合此清單中任何一個名稱的物品將會被 刪除。\n\n每一行輸入一個名稱。 你可以在名稱之後加上一個 ';' 來輸入註解。 你可以使用 '#' 前置字元來設定樣式以進行部份名稱的比對。 這裡是一些樣式的設定範例:\n#(.*)藥水$ ; 比對名稱結尾為 '藥水' 的物品\n#(.*)卷軸(.*) ; 比對名稱中包含 '卷軸' 的物品\n使用 '##' 前置字串可以用來比對物品的提示說明內容。",
			["LToolTip7"] = "物品價格小於此設定值會被 刪除。\n\n此值的設定單位為金，0.1 金等於 10 銀。",
			["LToolTip8"] = "物品價格大於此設定值會被 保留。\n\n此值的設定單位為金，0.1 金等於 10 銀。",
			["LToolTip9"] = "Enter the number of free bag slots you want to keep. Loot Filter will start replacing lower valued items with higher ones if the number of free slots is less than what you enter here.",
			["LToolTip10"] = "此清單為沒有附合任何一個保留條件的物品。 你可以選擇自動售出或刪除這些物品。 使用 shift-滑鼠左鍵 點擊物品名稱來新增物品到保留清單中。",
			["LToolTip11"] = "符合此清單中名稱的物品將會被自動開啟。 此功能不能使用在如卷軸這一類的物品上，否則會產生一個錯誤。\n\n你可以在名稱之後加上一個 ';' 來輸入註解。 你可以使用 '#' 前置字元來設定樣式以進行部份名稱的比對。 這裡是一些樣式的設定範例:\n#(.*)蚌殼$ ; 比對名稱結尾為 '蚌殼' 的物品\n#(.*)蚌殼(.*) ; 比對名稱中包含 '蚌殼' 的物品",
			["LToolTip12"] = "選取你想要用來計算物品價格的方式 (價格 * 物品數量)。 物品數量可以是單一物品、目前堆疊的數量或最大堆疊的數量。"
		},
	};
	
	-- Interface (xml) localization
	LFINT_BTN_GENERAL = "一般設定" ;
	LFINT_BTN_QUALITY = "品質";
	LFINT_BTN_TYPE = "類型";
	LFINT_BTN_NAME = "名稱";
	LFINT_BTN_VALUE = "價格";
	LFINT_BTN_CLEAN = "清除";
	LFINT_BTN_OPEN = "開啟";
	LFINT_BTN_COPY = "複製設定";
	LFINT_BTN_CLOSE = "關閉";
	LFINT_BTN_DELETEITEMS = "刪除物品" ;
	LFINT_BTN_YESSURE = "是的，我確定" ;
	LFINT_BTN_COPYSETTINGS = "複製設定";
	LFINT_BTN_DELETESETTINGS = "Delete settings";
	LFINT_BTN_RESET = "重置";
	
	LFINT_TXT_MOREINFO = "|n|n如果你有任何使用上的問題或建議，請至 http://www.lootfilter.com 網站|n或寫 Email 給 meter@lootfilter.com 。";
	LFINT_TXT_SELECTBAGS = "選取你想要套用 Loot Filter 的背包：";
	LFINT_TXT_ITEMKEEP = "你想要保留的物品：";
	LFINT_TXT_ITEMDELETE = "你想要刪除的物品：";
	LFINT_TXT_INSERTNEWNAME = "每一行指定一個名稱。";
	LFINT_TXT_INFORMANTNEED = "如果你想要使用物品價格來進行物品過濾，你必須先安裝支援 GetSellValue API 的插件 (例如：Informant, ItemPriceTooltip)。" ;
	LFINT_TXT_NUMFREEBAGSLOTS = "Number of free bag slots" ;
	LFINT_TXT_SELLALLNOMATCH = "使用這個功能來將未符合任何保留條件的物品進行出售或刪除。" ;
	LFINT_TXT_AUTOOPEN = "你想要進行自動開啟及拾取的物品 (例如：蚌殼)：" ;
	LFINT_TXT_SELECTCHARCOPY = "選擇你想要做為複製來源的角色名稱：" ;
	LFINT_TXT_COPYSUCCESS = "設定已成功複製。" ;
	LFINT_TXT_SELECTTYPE = "選取一個子類型： ";
	LFINT_TXT_SIZETOCALCULATE = "計算物品價格使用： ";
	LFINT_TXT_SIZETOCALCULATE_TEXT1 = "單一物品";
	LFINT_TXT_SIZETOCALCULATE_TEXT2 = "目前堆疊的數量";
	LFINT_TXT_SIZETOCALCULATE_TEXT3 = "最大堆疊的數量";
	
	
	BINDING_NAME_LFINT_TXT_TOGGLE = "切換視窗";
	BINDING_HEADER_LFINT_TXT_LOOTFILTER = "Loot Filter";
end;