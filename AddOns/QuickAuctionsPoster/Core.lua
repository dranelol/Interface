local QAPoster = LibStub("AceAddon-3.0"):NewAddon("QuickAuctionsPoster", "AceEvent-3.0", "AceTimer-3.0");

-- If set to true we will continue posting, but don't continue by default
local enabled = false;

-- Reference to the QA object
local QuickAuctions;

function QAPoster:OnEnable()
	if select(6, GetAddOnInfo("QuickAuctions")) == nil then
		-- When the auction house is first used, add our buttons to it and drop this event (so this event is registered just once)
		self:RegisterEvent("AUCTION_HOUSE_SHOW");
	else
		-- Big error frame
		message("QuickAuctions3 does not appear to be installed or enabled properly...");
	end
end

-- When the auction house is first used, add our buttons to it and then drop this event (so this function is triggered just once per session)
function QAPoster:AUCTION_HOUSE_SHOW()
	-- We no longer need this event
	self:UnregisterEvent("AUCTION_HOUSE_SHOW");
	
	-- Ensure the required addon is loaded if AddonLoader is installed
	if AddonLoader and AddonLoader.LoadAddOn then
		AddonLoader:LoadAddOn("QuickAuctions");
	end
	
	-- Get a referrence to QA's addon object
	QuickAuctions = LibStub("AceAddon-3.0"):GetAddon("QuickAuctions", true);
	
	-- Another check if it exists
	if not QuickAuctions then
		message("QuickAuctions3 does not appear to be installed or enabled properly...");
		return;
	end
	
	-- Events
	
	-- Interrupt the continuation timer when AH is closed
	self:RegisterEvent("AUCTION_HOUSE_CLOSED", function()
		QAPoster:Stop();
	end);
	
	-- Frames
	
	-- Make the continue posting checkbox
	local check = CreateFrame("CheckButton", "cbQAPosterContinueBox", AuctionFrameAuctions, "ChatConfigCheckButtonTemplate");
	check:SetHeight(26);
	check:SetWidth(26);
	check:SetChecked(false);
	check:SetHitRectInsets(0, -195, 0, 0);
	check:SetScript("OnClick", function(self)
		if(self:GetChecked()) then
			-- We won't start our timer yet, the user has to click the post button for that
			enabled = true;
		else
			enabled = false;
			
			-- Don't start a new cycle if we were already running
			QAPoster:Stop();
		end
	end);
	check.tooltip = "Continue scanning and posting items with Quick Auctions after the initial post sequence has been completed.\n\nYou must tick this checkbox on before clicking the post button.";
	-- Position the box
	check:SetPoint("TOPLEFT", AuctionFrameAuctions, "TOPLEFT", 70, -12);
	
	-- Get reference to the text field
	local checkboxText = _G[check:GetName() .. "Text"];
	checkboxText:SetText("Continue posting after initial post");
	-- We like this color more
	checkboxText:SetTextColor(1, 0.8, 0, 1);
	
	self.cbQAPosterContinueBox = check;
	
	-- Hook the QA start posting button
	QuickAuctions.buttons.post:HookScript("OnClick", function()
		QAPoster:Start();
	end);
end

-- Start the timer that takes care of the continueing
function QAPoster:Start()
	-- Cancel an already running timer so this one overwrites it (just overwriting the var won't work)
	self:CancelTimer(self.t, true);
	
	if enabled then
		-- Just keep on trying to continue until the box is disabled or the AH is closed
		self.t = self:ScheduleRepeatingTimer("Continue", 0.5);
	end
end

-- Stop the timer
function QAPoster:Stop()
	-- Stop timer, stay quiet if it doesn't exist
	self:CancelTimer(self.t, true);
end

function QAPoster:Continue()
	if QuickAuctions.status and not QuickAuctions.status.isManaging and not QuickAuctions.status.isCancelling and not QuickAuctions.status.isScanning then
		-- If QA isn't busy scanning or posting
		
		-- Trigger a post
		QuickAuctions.Manage:PostScan();
	end
end
