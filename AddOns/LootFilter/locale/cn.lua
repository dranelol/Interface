-- Version : Chinese (by 千皓)
-- Last Update : 26/01/2008
if ( GetLocale() == "zhCN" ) then
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
			["Armor"] = "护甲",
			["Consumables"] = "消耗品",
			["Containers"] = "容器",
			["Gems"] = "宝石",
			["Key"] = "钥匙",
			["Miscellaneous"] = "杂物",
			["Projectile"] = "弹药",
			["Quest"] = "任务物品",
			["Quiver"] = "箭袋",		
			["Recipe"] = "配方",
			["TradeGoods"] = "商品",
			["Weapons"] = "武器",
		},
		radioButtonsText= {
			["QUaGrey"]= "粗糙 (灰色)",
			["QUbWhite"]= "普通 (白色)",
			["QUcGreen"]= "优秀 (绿色)",
			["QUdBlue"]= "精良 (蓝色)",
			["QUePurple"]= "诗史 (紫色)",
			["QUfOrange"]= "传说 (橙色)",
			["QUgRed"]= "神器 (红色)",
			["QUhTan"] = "Heirloom (Tan)",
			["QUhQuest"]= "任务",
	
			-- Armor
			["TYArmorMiscellaneous"]= "杂物",
			["TYArmorCloth"]= "布衣",
			["TYArmorLeather"]= "皮衣",
			["TYArmorMail"]= "锁甲",
			["TYArmorPlate"]= "板甲",
			["TYArmorShields"]= "盾牌",
			["TYArmorLibrams"]= "Librams",
			["TYArmorIdols"]= "圣像",
			["TYArmorTotems"]= "图腾",
			
			-- Consumable
			["TYConsumableFoodDrink"]= "食物 & 饮料",
			["TYConsumablePotion"]= "药水",
			["TYConsumableElixir"]= "药剂",
			["TYConsumableFlask"]= "合剂",
			["TYConsumableBandage"]= "绷带",
			["TYConsumableItem Enhancement"]= "物品增强",
			["TYConsumableScroll"]= "卷轴",
			["TYConsumableOther"]= "其他",
			["TYConsumableConsumable"]= "消耗品",
			
			-- Container
			["TYContainerBag"]= "袋子",
			["TYContainerEnchanting Bag"]= "附魔包",
			["TYContainerEngineering Bag"]= "工程包",
			["TYContainerGem Bag"]= "宝石包",
			["TYContainerHerb Bag"]= "草药包",
			["TYContainerMining Bag"]= "采矿包",
			["TYContainerSoul Bag"]= "灵魂袋",
			["TYContainerLeatherworking Bag"]= "皮革加工袋",
			
			
			-- Miscellaneous
			["TYMiscellaneousJunk"]= "垃圾",
			["TYMiscellaneousReagent"]= "药剂",
			["TYMiscellaneousPet"]= "宠物",
			["TYMiscellaneousHoliday"]= "节日",
			["TYMiscellaneousOther"]= "其他",
			-- Gem
			["TYGemBlue"] = "蓝色",
			["TYGemGreen"] = "绿色",
			["TYGemOrange"] = "橙色",
			["TYGemMeta"] = "彩色",
			["TYGemPrismatic"] = "棱镜",
			["TYGemPurple"] = "紫色",
			["TYGemRed"] = "红色",
			["TYGemSimple"] = "简易",
			["TYGemYellow"] = "黄色",
			
			
			-- Key
			["TYKeyKey"]= "钥匙",
			-- Projectile
			["TYProjectileArrow"]= "弓箭",
			["TYProjectileBullet"]= "子弹",
			-- Quest
			["TYQuestQuest"]= "任务物品",
			
			-- Quiver
			["TYQuiverAmmoPouch"]= "弹药袋",
			["TYQuiverQuiver"]= "箭袋",				
			
			-- Recipe
			["TYRecipeAlchemy"]= "炼金",
			["TYRecipeBlacksmithing"]= "锻造",
			["TYRecipeBook"]= "书籍",
			["TYRecipeCooking"]= "烹饪",
			["TYRecipeEnchanting"]= "附魔",
			["TYRecipeEngineering"]= "工程",
			["TYRecipeFirstAid"]= "急救",
			["TYRecipeLeatherworking"]= "制皮",
			["TYRecipeTailoring"]= "裁缝",
			
					
			-- Trade Goods
			["TYTrade GoodsElemental"] = "元素",
			["TYTrade GoodsCloth"] = "布匹",
			["TYTrade GoodsLeather"] = "皮革",
			["TYTrade GoodsMetal & Stone"] = "金属 & 石头", 
			["TYTrade GoodsMeat"] = "肉类",
			["TYTrade GoodsHerb"] = "药草",
			["TYTrade GoodsEnchanting"] = "附魔", 
			["TYTrade GoodsJewelcrafting"] = "宝石工艺",
			["TYTrade GoodsParts"]= "零件",
			["TYTrade GoodsDevices"]= "装置",
			["TYTrade GoodsExplosives"]= "爆炸物",
			["TYTrade GoodsOther"]= "其他",
			["TYTrade GoodsTradeGoods"]= "商品",
			
			-- Weapon
			["TYWeaponBows"]= "弓",
			["TYWeaponCrossbows"]= "弩",
			["TYWeaponDaggers"]= "匕首",
			["TYWeaponGuns"]= "枪",
			["TYWeaponFishingPoles"]= "渔具",
			["TYWeaponFistWeapons"]= "拳套",
			["TYWeaponMiscellaneous"]= "杂项",
			["TYWeaponOneHandedAxes"]= "单手斧",
			["TYWeaponOneHandedMaces"]= "单手锤",
			["TYWeaponOneHandedSwords"]= "单手剑",
			["TYWeaponPolearms"]= "长柄武器",
			["TYWeaponStaves"]= "法杖",
			["TYWeaponThrown"]= "飞刀类",
			["TYWeaponTwoHandedAxes"]= "双手斧",
			["TYWeaponTwoHandedMaces"]= "双手锤",
			["TYWeaponTwoHandedSwords"]= "双手剑",
			["TYWeaponWands"]= "魔杖",
			
			["OPEnable"]= "开启拾取过滤",
			["OPCaching"]= "开启拾取缓冲",
			["OPTooltips"]= "显示提示",
			["OPNotifyDelete"]= "摧毁时通知",
			["OPNotifyKeep"]= "总是通知",
			["OPNotifyNoMatch"]= "无匹配项时通知",
			["OPNotifyOpen"]= "打开时通知",
			["OPNotifyNew"]= "新版本时通知",
			["OPValKeep"]= "不摧毁物品当价值高于",
			["OPValDelete"]= "摧毁物品当价值低于",
			["OPOpenVendor"]= "和商贩对话时打开",
			["OPAutoSell"]= "自动开始出售",
			["OPNoValue"]= "保留物品，当没有（已知）的价值", 
			["OPMarketValue"]= "利用拍卖市场价格而非NPC售卖价格",
			["OPBag0"]= "主背包",
			["OPBag1"]= "背包 1",
			["OPBag2"]= "背包 2",
			["OPBag3"]= "背包 3",
			["OPBag4"]= "背包 4",
			["TYWands"]= "魔杖"
		},
		LocText = {
			["LTTryopen"] = "正在尝试打开",
			["LTNameMatched"] = "名称匹配",
			["LTQualMatched"] = "品质匹配",
			["LTQuest"] = "任务物品",              -- Used to match Quest Item as Quality Value
			["LTQuestItem"] = "任务匹配",
			["LTTypeMatched"]= "类型匹配",
			["LTKept"] = "被保留",
			["LTNoKnownValue"] = "物品没有已知的价值",
			["LTValueHighEnough"] = "价值足够",
			["LTValueNotHighEnough"] = "价值未达到",
			["LTNoMatchingCriteria"] = "没有找到匹配的标准",
			["LTWasSold"] = "被出售",
			["LTWasDeleted"] = "被摧毁",
			["LTNewVersion1"] = "一个新版本",
			["LTNewVersion2"] = "Loot Filter已检测到. 请从 http://www.lootfilter.com .下载",
			["LTAddedCosQuest"] = "任务补充",
			["LTDeleteItems"] = "摧毁物品",
			["LTSellItems"] = "出售物品",
			["LTFinishedSC"] = "出售完毕/清除完毕.",
			["LTNoOtherCharacterToCopySettings"] = "没有其他的设置可复制.",
			["LTTotalValue"] = "总价值",
			["LTSessionInfo"] = "Below are some item values that have been recorded this session.",
			["LTSessionTotal"] = "Total value",
			["LTSessionItemTotal"] = "Number of items",
			["LTSessionAverage"] = "Average / item",
			["LTSessionValueHour"] = "Average / hour",			
			["LTNoMatchingItems"] = "发现不符合条件的物品.",
			["LTItemLowestValue"] = "物品的最低值",
			["LTVendorWinClosedWhileSelling"] = "卖方窗口关闭，而销售虚拟物品.",
			["LTTimeOutItemNotFound"] = "超时.一个或者多个清单中的物品没有找到.",
		},
		LocTooltip = {
			["LToolTip1"] = "这里列出所有不匹配任何需要保留过滤规则的物品,你可以选择自动出售或者删除这些物品. 使用 shift + 鼠标点击添加物品到保留列表中.",
			["LToolTip2"] = "当你不关心物品是否保留或摧毁时选择它,当选择这一选项后,物品将不会被摧毁,除非你选择了自动以高价值物品替换低价值物品,那么在背包空间不足的情况下,物品将有被高售价物品替换并被摧毁的风险.",
			["LToolTip3"] = "如果你希望强制保留对应物品时选择它.",
			["LToolTip4"] = "如果你希望强制摧毁对应物品选择它.",
			["LToolTip5"] = "和清单中匹配的名字是保留的物品.\n\n在新的一行输入一个新的物品名称. 你可以在名字后用用'#'添加注释. 你也可以使用'#'前缀的格式来匹配名称的一部分. 例如:\n#(.*)护符$ ; 匹配名称以'.'结尾,如\n#(.*)卷轴(.*) ; 匹配所有包括'卷轴'的名字的物品\nUse the '##' prefix to match against text in an item tooltip.",
			["LToolTip6"] = "和清单中匹配的名字是摧毁的物品\n\n在新的一行输入一个新的名称. 你可以在名字后用用'#'添加注释. 你也可以使用'#'前缀的格式来匹配名称的一部分. 例如:\n#(.*)护符$ ; 匹配名称以'.'结尾,如\n#(.*)卷轴(.*) ; 匹配所有包括'卷轴'的名字的物品\nUse the '##' prefix to match against text in an item tooltip.",
			["LToolTip7"] = "物品价值小于这个值将被摧毁.\n\n价格是以金计算. 0.1金等于10银.",
			["LToolTip8"] = "物品价值大于这个值将被保留.\n\n价格是以金计算. 0.1金等于10银.",
			["LToolTip9"] = "输入你想要指定保持的背包空位. 如果背包空位低于你的指定数后,Loot Filter 将会在开始用高价值的物品替换掉低价值的物品,低价值的物品将被摧毁.",
			["LToolTip10"] = "这里列出所有不匹配任何需要保留规则的物品,你可以选择自动出售或者删除这些物品. 使用 shift + 鼠标点击添加物品到保留列表中.",
			["LToolTip11"] = "会被自动打开的物品. 这个选项如果对卷轴类物品使用不会起任何作用,并会产生一条UI错误.\n\n在新的一行中添加新物品时. 你可以在名字后用用'#'添加注释. 你也可以使用'#'前缀的格式来匹配名称的一部分. 例如:\n#(.*)蛤$ ; 匹配名称以'.'结尾,如\n#(.*)蛤(.*) ; 匹配所有包括'蛤'的名字的物品",
			["LToolTip12"] = "选择你想要来计算物品的价值的方法 (价值 * 物品数量). 物品数量可以是一个物品、 自定义堆叠数量或最高堆叠数量."
		},
	};
	
	-- Interface (xml) localization
	LFINT_BTN_GENERAL = "一般选项" ;
	LFINT_BTN_QUALITY = "品质过滤";
	LFINT_BTN_TYPE = "种类过滤";
	LFINT_BTN_NAME = "名称过滤";
	LFINT_BTN_VALUE = "价值过滤";
	LFINT_BTN_CLEAN = "清除过滤";
	LFINT_BTN_OPEN = "打开过滤";
	LFINT_BTN_COPY = "复制设置";
	LFINT_BTN_CLOSE = "关闭";
	LFINT_BTN_DELETEITEMS = "摧毁物品" ;
	LFINT_BTN_YESSURE = "是的，我确认" ;
	LFINT_BTN_COPYSETTINGS = "复制设置";
	LFINT_BTN_DELETESETTINGS = "Delete settings";
	LFINT_BTN_RESET = "Reset";
	
	LFINT_TXT_MOREINFO = "|n|n如果你有疑问或者任何建议，请浏览网页 http://www.lootfilter.com|nor 或者发送 e-mail 到 meter@lootfilter.com . 千皓 翻译";
	LFINT_TXT_SELECTBAGS = "选择你想要使用过滤器的背包.";
	LFINT_TXT_ITEMKEEP = "你想保留的物品.";
	LFINT_TXT_ITEMDELETE = "你想摧毁的物品.";
	LFINT_TXT_INSERTNEWNAME = "在新的一行中添加新的物品.";
	LFINT_TXT_INFORMANTNEED = "如果你想通过价格过滤物品,你必须安装插件'Auctioneer' 的'Informant'组件 ,或者 ItemPriceTooltip 插件." ;
	LFINT_TXT_NUMFREEBAGSLOTS = "可用包空间数量" ;
	LFINT_TXT_SELLALLNOMATCH = "用这个选项来出售或者摧毁所有不属于保留规则中的物品." ;
	LFINT_TXT_AUTOOPEN = "你想要自动拾取并自动打开的物品(比如蛤)." ;
	LFINT_TXT_SELECTCHARCOPY = "选择你希望复制的设置." ;
	LFINT_TXT_COPYSUCCESS = "设置复制成功." ;
	LFINT_TXT_SELECTTYPE = "选择一个子类: ";
	LFINT_TXT_SIZETOCALCULATE = "使用物品价值计算: ";
	LFINT_TXT_SIZETOCALCULATE_TEXT1 = "单个物品";
	LFINT_TXT_SIZETOCALCULATE_TEXT2 = "自定义堆叠数量";
	LFINT_TXT_SIZETOCALCULATE_TEXT3 = "最高堆叠数量";
	
	
	BINDING_NAME_LFINT_TXT_TOGGLE = "切换窗口";
	BINDING_HEADER_LFINT_TXT_LOOTFILTER = "拾取过滤";
end;
