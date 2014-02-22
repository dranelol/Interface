local gt = GameTooltip

BrowseBuyoutButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
BrowseBuyoutButton:SetScript('OnClick', function(self, button)
    if IsShiftKeyDown() and button == 'RightButton' then
--    	ChatFrame1:AddMessage('Would have bought '..GetSelectedAuctionItem(AuctionFrame.type)..' for '..AuctionFrame.buyoutPrice)
        PlaceAuctionBid(AuctionFrame.type, GetSelectedAuctionItem(AuctionFrame.type), AuctionFrame.buyoutPrice)
    else
        StaticPopup_Show("BUYOUT_AUCTION")
    end
    self:Disable()
end)
BrowseBuyoutButton:HookScript("OnEnter", function(self)
	gt:SetOwner(self)
	gt:AddLine("Shift-Right-Click to buyout the selected item without confirmation.")
	gt:Show()
end)
BrowseBuyoutButton:HookScript("OnLeave", function(self)
	gt:Hide()
end)

BrowseBidButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
BrowseBidButton:SetScript('OnClick', function(self, button)
    if IsShiftKeyDown() and button == 'RightButton' then
		PlaceAuctionBid("list", GetSelectedAuctionItem("list"), MoneyInputFrame_GetCopper(BrowseBidPrice));
    else
		StaticPopup_Show("BID_AUCTION")
    end
    self:Disable()
end)
BrowseBidButton:HookScript("OnEnter", function(self)
	gt:SetOwner(self)
	gt:AddLine("Shift-Right-Click to bid on the selected item without confirmation.")
	gt:Show()
end)
BrowseBidButton:HookScript("OnLeave", function(self)
	gt:Hide()
end)

SLASH_OCBO1 = "/ocbo"
SLASH_OCBO2 = "/oneclickbuyout"

SlashCmdList["OCBO"] = function(msg)
	OCBO_NoBuyout = not OCBO_NoBuyout
	if OCBO_NoBuyout then
		print("OCBO will not auto-buyout unless the buyout price is the same as the current bid (starting bid).")
	else
		print("OCBO will buyout if available else bid the next bid.")
	end
end
