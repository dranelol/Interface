EnchantingShuffler = LibStub("AceAddon-3.0"):NewAddon("EnchantingShuffler", "AceConsole-3.0")

------------------------------------------
-- Initialises --

EnchantingShuffler_Opened = "No"

EnchantingShuffler_Database = "ESDBPHolder"

EnchantingShuffler:RegisterChatCommand("EShuffler","ESOpen")

EnchantingShufflerErrorRunOnce = 0

EnchantingShufflerOpts_Opened = "No"
-------------------------------------------

---Event Handler / frame ---
EnchantingShufflerEventFrame = CreateFrame("FRAME")
EnchantingShufflerEventFrame:SetScript("OnEvent", function(the, event, ...)
	EnchantingShufflerEvents[event](...)
end)
EnchantingShufflerEventFrame:RegisterEvent("ADDON_LOADED")
EnchantingShufflerEvents = {}

--- Varibles loading ---
function EnchantingShufflerEvents.ADDON_LOADED(addon)
------ First Time loading--
	if not EnchantingShufflerDB then
		EnchantingShufflerDB = {}-- Create new DB entry
	end
	if not EnchantingShufflerDB.Auction_DB then EnchantingShufflerDB.Auction_DB = "ESDBPHolder" end
	EnchantingShuffler_Database = EnchantingShufflerDB.Auction_DB
	EnchantingShufflerEventFrame:UnregisterEvent("ADDON_LOADED")

end

function ESDBPSelector()
	if EnchantingShufflerDB.Auction_DB == "ESDBPHolder" then
		if TSMAPI then
			EnchantingShufflerDB.Auction_DB =  "TradeSkillMaster"
			EnchantingShuffler_Database = EnchantingShufflerDB.Auction_DB
		elseif AuctionatorLoaded then
			EnchantingShufflerDB.Auction_DB = "Auctionator"
			EnchantingShuffler_Database = EnchantingShufflerDB.Auction_DB
		end
	end
end

function ESDatabaseSelection()
	-- Database selection --
	if EnchantingShuffler_Database == "TradeSkillMaster" then
		EnchantingShufflerOpts_TSMCheckButton:SetChecked(true)
	elseif EnchantingShuffler_Database == "Auctionator" then
		EnchantingShufflerOpts_AuctionatorCheckButton:SetChecked(true)
	else
		if EnchantingShufflerErrorRunOnce == 0 then
			EnchantingShuffler:Print("No database found, please install one of the following databases: TradeSkillMaster_AuctionDB or Auctionator")
			EnchantingShufflerErrorRunOnce = 1
		end
	end
end

--- Slash Commands ---
function EnchantingShuffler:ESOpen(input)
	if input == "Options" or input == "Opts" or input == "opts" or input == "options" then
		if EnchantingShufflerOpts_Opened == "No" then
			EnchantingShufflerOpts:Show()
			EnchantingShufflerOpts_Opened = "Yes"

		elseif EnchantingShufflerOpts_Opened == "Yes" then
			EnchantingShufflerOpts:Hide()
			EnchantingShufflerOpts_Opened = "No"
		end
	else
		if EnchantingShuffler_Opened == "No" then
			EnchantingShuffler_Opened = "Yes"
			EnchantingShufflerGUI:Show()
		elseif EnchantingShuffler_Opened == "Yes" then
			EnchantingShuffler_Opened = "No"
			EnchantingShufflerGUI:Hide()
		end
	end
end
--- tool tips Pricing Modules ---

function ESPricingTooltips(ITEM)
	local PriceMin = 0
	local PriceMarket = 0
	local PriceMinEach = 0
	local PriceMarketEach = 0
	if ITEM == "Spirit Dust" then
		PriceMin = EnchantingShuffler_GetValue(74249,"Stack","Min")
		PriceMarket = EnchantingShuffler_GetValue(74249,"Stack","Market")
		PriceMinEach = EnchantingShuffler_GetValue(74249,"Each","Min")
		PriceMarketEach = EnchantingShuffler_GetValue(74249,"Each","Market")
	elseif ITEM == "Mysterious Essence" then
		PriceMin = EnchantingShuffler_GetValue(74250,"Stack","Min")
		PriceMarket = EnchantingShuffler_GetValue(74250,"Stack","Market")
		PriceMinEach = EnchantingShuffler_GetValue(74250,"Each","Min")
		PriceMarketEach = EnchantingShuffler_GetValue(74250,"Each","Market")
	elseif ITEM == "Ethereal Shard" then
		PriceMin = EnchantingShuffler_GetValue(74247,"Stack","Min")
		PriceMarket = EnchantingShuffler_GetValue(74247,"Stack","Market")
		PriceMinEach = EnchantingShuffler_GetValue(74247,"Each","Min")
		PriceMarketEach = EnchantingShuffler_GetValue(74247,"Each","Market")
	elseif ITEM == "Sha Crystal" then
		PriceMin = EnchantingShuffler_GetValue(74248,"Stack","Min")
		PriceMarket = EnchantingShuffler_GetValue(74248,"Stack","Market")
		PriceMinEach = EnchantingShuffler_GetValue(74248,"Each","Min")
		PriceMarketEach = EnchantingShuffler_GetValue(74248,"Each","Market")
	end
	if TSMAPI then
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:AddLine(ITEM.." details:")
		GameTooltip:AddLine("Each:")
		GameTooltip:AddLine("Lowest price: "..PriceMinEach.."g")
		GameTooltip:AddLine("Market Price: "..PriceMarketEach.."g")
		GameTooltip:AddLine("Per stack:")
		GameTooltip:AddLine("Lowest price: "..PriceMin.."g")
		GameTooltip:AddLine("Market Price: "..PriceMarket.."g")
		GameTooltip:Show();
	elseif AuctionatorLoaded then
		GameTooltip:ClearLines();
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:AddLine(ITEM.." details:")
		GameTooltip:AddLine("Each:")
		GameTooltip:AddLine("Lowest price: "..PriceMinEach.."g")
		GameTooltip:AddLine("Per stack:")
		GameTooltip:AddLine("Lowest price: "..PriceMin.."g")
		GameTooltip:Show();
	end
end

function HideTooltips()
	GameTooltip:Hide()
end


-- The Main Working things--

function EnchantingShufflerMain()
	-- Prices each -
	ESSpiritDust = EnchantingShuffler_GetValue(74249,"Each","Min")
	--print(ESSpiritDust)
	ESMysteriousEssence = EnchantingShuffler_GetValue(74250,"Each","Min")
	--print(ESMysteriousEssence)
	ESEtherealShard = EnchantingShuffler_GetValue(74247,"Each","Min")
	--print(ESEtherealShard)
	ESShaCrystal = EnchantingShuffler_GetValue(74248,"Each","Min")
	--print(ESShaCrystal)
	--
	local DustToDust = "---"
	local DustToEssence = floor((ESAhcut(ESMysteriousEssence) - (ESSpiritDust * 5)))
	local DustToShard = floor((ESAhcut(ESEtherealShard) - (ESSpiritDust * 25)))
	local DustToCrystal = floor((ESAhcut(ESShaCrystal) - (ESSpiritDust * 125)))
	--
	local EssenceToDust = floor(((ESSpiritDust * 3) - ESAhcut(ESMysteriousEssence)))
	local EssenceToEssence = "---"
	local EssenceToShard = floor((ESAhcut(ESEtherealShard) - (ESMysteriousEssence * 5 )))
	local EssenceToCrystal = floor((ESAhcut(ESShaCrystal) - (ESMysteriousEssence * 25 )))
	--
	local ShardToDust = floor(((3 * (ESSpiritDust * 3)) - ESAhcut(ESEtherealShard)))
	local ShardToEssence = floor(((ESMysteriousEssence * 3) - ESAhcut(ESEtherealShard)))
	local ShardToShard = "---"
	local ShardToCrystal = floor((ESAhcut(ESShaCrystal) - (ESEtherealShard * 5)))
	--
	local CrystalToDust = floor(((2 * (3 * (ESSpiritDust * 3)))- ESAhcut(ESShaCrystal)))
	local CrystalToEssence =  floor(((2 * (ESMysteriousEssence * 3)) - ESAhcut(ESShaCrystal)))
	local CrystalToShard = floor(((ESEtherealShard * 2) - ESAhcut(ESShaCrystal)))
	local CrystalToCrystal = "---"
	--
	ConversionTable_ESDustToDust:SetText(DustToDust)
	ConversionTable_ESDustToEssence:SetText(DustToEssence .."g")
	ConversionTable_ESDustToShard:SetText(DustToShard .."g")
	ConversionTable_ESDustToCrystal:SetText(DustToCrystal .."g")
	--
	ConversionTable_ESEssenceToDust:SetText(EssenceToDust.."g")
	ConversionTable_ESEssenceToEssence:SetText(EssenceToEssence)
	ConversionTable_ESEssenceToShard:SetText(EssenceToShard .."g")
	ConversionTable_ESEssenceToCrystal:SetText(EssenceToCrystal .."g")
	--
	ConversionTable_ESShardToDust:SetText(ShardToDust.."g")
	ConversionTable_ESShardToEssence:SetText(ShardToEssence .."g")
	ConversionTable_ESShardToShard:SetText(ShardToShard)
	ConversionTable_ESShardToCrystal:SetText(ShardToCrystal .."g")
	--
	ConversionTable_ESCrystalToDust:SetText(CrystalToDust.."g")
	ConversionTable_ESCrystalToEssence:SetText(CrystalToEssence .."g")
	ConversionTable_ESCrystalToShard:SetText(CrystalToShard.."g")
	ConversionTable_ESCrystalToCrystal:SetText(CrystalToCrystal)
end


--- Price getting --
function EnchantingShuffler_GetValue(ITEM,TYPE,TSMVar)
	local Price -- create price local
	if EnchantingShuffler_Database == "TradeSkillMaster" then
		if TSMVar == "Market" then
			if TYPE == "Stack" then
				Price = ((TSMAPI:GetItemValue(ITEM,"DBMarket") / 10000) * 20)
			elseif TYPE == "Each" then
				Price = (TSMAPI:GetItemValue(ITEM,"DBMarket") / 10000)
			end
		elseif TSMVar == "Min" or TSMVar == nil then
			if TYPE == "Stack" then
				Price = ((TSMAPI:GetItemValue(ITEM,"DBMinBuyout") / 10000) * 20)
			elseif TYPE == "Each" then
				Price = (TSMAPI:GetItemValue(ITEM,"DBMinBuyout") / 10000)
			end
		end
	-- Auctionator Database --
	elseif EnchantingShuffler_Database == "Auctionator" then
		if TSMVar == "Market" or TSMVar == "Min" or TSMVar == nil or TSMVar == "Market" then
			if TYPE == "Stack" then
				Price = ((GetAuctionBuyout(ITEM) / 10000) * 20)
			elseif TYPE == "Each" then
				Price = (GetAuctionBuyout(ITEM) / 10000)
			end
		end
	else
		if EnchantingShufflerErrorRunOnce == 0 then
			Price = 0
			EnchantingShuffler:Print("No database found, please install on of the following databases: TradeSkillMaster_AuctionDB or Auctionator")
			EnchantingShufflerErrorRunOnce = 1
		end
	end

	if Price == nil or Price == 0 then
		Price = 0
	end
	--EnchantingShuffler:Print(Price)
	return Price
end

-------- AH Cut ------
function  ESAhcut(PRICE)
	local cut = (PRICE * .05)
	local price = (PRICE - cut)
	return price
end


------------- Stolen modules from an unfinished addon of mine -----
function EnchantingShufflerCheckBoxChecker(AddonName)
	EnchantingShuffler_Database = AddonName
	if AddonName == "TradeSkillMaster" then
		EnchantingShufflerDB.Auction_DB = "TradeSkillMaster"
		EnchantingShufflerOpts_TSMCheckButton:SetChecked(true)
	else
		EnchantingShufflerOpts_TSMCheckButton:SetChecked(false)
	end

	if AddonName == "Auctionator" then
		EnchantingShufflerDB.Auction_DB = "Auctionator"
		EnchantingShufflerOpts_AuctionatorCheckButton:SetChecked(true)
	else
		EnchantingShufflerOpts_AuctionatorCheckButton:SetChecked(false)
	end
end


