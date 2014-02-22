if AucAdvanced then
	if not OCBO_AucAdvance_Notified then
		ChatFrame1:AddMessage("OneClickBuyOut is not compatible with Auctioneer Advanced. EasyBuyout will do what you want, anyway. You might as well disable OneClickBuyOut.")
		OCBO_AucAdvance_Notified = true
	else -- if the user has been notified, disable OCBO for them.
		ChatFrame1:AddMessage("OneClickBuyOut told you before that it won't work with Auctioneer Advanced. Disabling.")
		DisableAddOn("OneClickBuyOut")
	end
else
	local function DoBid(index, startingBid, minIncrement, buyoutPrice, bidAmount)
		if buyoutPrice > 0 and not OCBO_NoBuyout then
			bid = buyoutPrice
		else
			bid = math.max(startingBid, bidAmount + minIncrement)
			if bid == 0 then
				bid = buyoutPrice
			end
		end
		PlaceAuctionBid("list", index, bid)
	end
	local f, buyoutPrice, index, startingBid, minIncrement, bidAmount, bid, name, _
	local buttonNames = {"BrowseButton%d"}
	if BaudAuctionFrame then
		tinsert(buttonNames, "BaudAuctionBrowseScrollBoxEntry%d")
	end
	local function OnClick(self, button)
		index = self:GetID() + FauxScrollFrame_GetOffset(BrowseScrollFrame)
		name, _, _, _, _, _, _, startingBid, minIncrement, buyoutPrice, bidAmount = GetAuctionItemInfo("list", index)
		if name then
			DoBid(index, startingBid, minIncrement, buyoutPrice, bidAmount)
		end
	end
	for _, buttonName in pairs(buttonNames) do
		for i = 1, 20 do
			f = _G[buttonName:format(i)]
			if f then
				f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				f:HookScript("OnDoubleClick", function(self, button)
					if IsShiftKeyDown() then
						OnClick(self, button)
				    else
				        StaticPopup_Show("BUYOUT_AUCTION")
					end
				end)
				f:HookScript("OnClick", function(self, button)
					if button == "RightButton" and IsShiftKeyDown() then
						OnClick(self, button)
					end
				end)
			end
		end
	end
	for i = 1, 20 do
		f = _G["AuctionsButton"..i]
		if f then
			f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			f:HookScript("OnClick", function(self, button)
				index = self:GetID() + FauxScrollFrame_GetOffset(AuctionsScrollFrame)
				if button == "RightButton" and IsShiftKeyDown() then
					name = GetAuctionItemInfo("owner", index)
					if name then
						CancelAuction(index)
					end
				end
			end)
		end
	end
end
