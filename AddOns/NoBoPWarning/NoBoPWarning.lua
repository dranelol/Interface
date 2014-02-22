

----- NoBoPWarning Frame -----
NoBoPWarning = CreateFrame('Frame', 'NoBoPWarning', UIParent);
NoBoPWarning:Hide()
NoBoPWarning.table_merge = function (self, n)
	for k,v in pairs(n) do
		self[k] = v
	end
end

NoBoPWarning:table_merge({
	----- VARIABLES -----
	FakeInGroup = false; -- For debugging. Trick the code into thinking you are in a party.
	InGroup = nil;
	ABOP_Notified = false;
	VARIABLES_LOADED = false;
	AutoLootKey = nil;
	Tooltip = CreateFrame("GameTooltip", "NoBoPHiddenTooltip", nil, "GameTooltipTemplate");
	
	-- Localize some global functions
	ITEM_UNIQUE_MULTIPLE = ITEM_UNIQUE_MULTIPLE:gsub("%(%%d%)", "%%((%d+)%%)"); -- "Unique (%d)";
	ITEM_UNIQUE = "Unique";
	IsShiftKeyDown = IsShiftKeyDown;
	IsAltKeyDown = IsAltKeyDown;
	IsControlKeyDown = IsControlKeyDown;
	GetModifiedClick = GetModifiedClick;
	GetCVar = GetCVar;
	StaticPopup_Show = StaticPopup_Show;
	ConfirmLootSlot = ConfirmLootSlot;
	GetNumLootItems = GetNumLootItems;
	GetLootSlotInfo = GetLootSlotInfo;
	OldLootSlot = LootSlot;

	CloseLoot = CloseLoot;
	DisableAddOn = DisableAddOn;
	GetFramesRegisteredForEvent = GetFramesRegisteredForEvent;
	ShowUIPanel = ShowUIPanel;
	IsInGroup = function()
		return UnitExists("party1") or IsInRaid()
	end;
	GetItemCount = GetItemCount;
	GameTooltip_SetDefaultAnchor = GameTooltip_SetDefaultAnchor;
	
	-- Localize global variables
	SlashCmdList = SlashCmdList;
	messageFrame = DEFAULT_CHAT_FRAME;
	LootFrame = CreateFrame("Frame"); -- For OnUpdate used later (maybe)
	
	----- FUNCTIONS -----
	SlashCmdList_AddSlashCommand = function(self, name, func, ...)
		self.SlashCmdList[name] = func
		local command = ''
		for i = 1, select('#', ...) do
			command = select(i, ...)
			if strsub(command, 1, 1) == '/' then
				command = strsub(command, 2)
			end
			_G['SLASH_'..name..i] = '/' .. command
		end
	end;
	
	RegisterEvents = function(self, ...)
		for i = 1, select('#', ...) do
			self:RegisterEvent(select(i, ...));
		end
	end;
	
	-- This function returns whether the specified modifier key is down
	-- takes the value returned by GetModifiedClick("AUTOLOOTTOGGLE") as the only parameter
	ModKey_CallBack = function(self)
		if self.AutoLootKey == 'SHIFT' then
			return self.IsShiftKeyDown();
		elseif self.AutoLootKey == 'ALT' then
			return self.IsAltKeyDown();
		elseif self.AutoLootKey == 'CTRL' then
			return self.IsControlKeyDown();
		end
	end;
	
	AddMessage = function(self, msg)
		self.messageFrame:AddMessage(msg, 1, 1, 1, 1);
	end;
	
	Khaos = function(self)
		local optionSetEasy = {
			id = 'NoBoPWarningBasicSetID';
			text = 'NoBoPWarning';
			helptext = "Enables NoBoPWarning, which will bypass the Bind on Pickup popup box. Will NOT work if you are in a group.";
			difficulty = 1;
			callback = function(state) NoBoPWarning_Enabled = state; end;
			feedback = function(state) local s = '[NoBoPWarning] Enabled.'; if ( not state ) then s = '[NoBoPWarning] Disabled.'; end return s; end;
			options={
				{
					id="Header";
					text='No warning BoP';
					helptext= 'No warning when picking up a BoP item while soloing.';
					type=K_HEADER;
					difficulty=1;
				};
			};
			default={checked=true};
			disabled={checked=false};
		};
		Khaos.registerOptionSet( "frames", optionSetEasy );
	end;
	FixGroupLootFrameScale = function(_, self, onshow)
		local scale = self:GetEffectiveScale()
		if abs(scale - 1) ~= 0 then
			self:SetScale(1 / scale)
		end
		return onshow and GroupLootFrame_OnShow(self) or nil
	end;
	RestoreGroupLootFrameScale = function(_, self, onshow)
		self:SetScale(1)
		return onshow and GroupLootFrame_OnShow(self) or nil
	end;
	----- OnLoad -----
	Load = function(self)
		self.Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
		if ( Khaos ) then
			self:Khaos();
		end
		self:SetScript('OnEvent',
			function(self, event, ...)
				local arg1 = ...
				if event == "VARIABLES_LOADED" then
					if NoBoPWarning_Enabled == nil then
						NoBoPWarning_Enabled = true;
					end
					self.VARIABLES_LOADED = true;
				elseif event == "PLAYER_ENTERING_WORLD" then
					if NoBoPWarning_FixRollFrames then
						for i = 1, NUM_GROUP_LOOT_FRAMES do
							self:FixGroupLootFrameScale(_G["GroupLootFrame"..i], false)
							_G["GroupLootFrame"..i]:SetScript("OnShow", function(self)
								NoBoPWarning:FixGroupLootFrameScale(self, true)
							end)
						end
					end
					self:UnregisterEvent(event)
					self:Show()
				elseif event == "LOOT_OPENED" then
					-- Note to whomever is reading: If you try to loot a slot from here without the LootFrame open,
					-- you will crash the client. Isn't that awesome?

					-- Correction: If you try to loot before this event fires and after LOOT_CLOSED fires
					-- the client will crash.
					
					-- After LOOT_CLOSED fires until LOOT_OPENED fires : loot = crash
					-- After LOOT_OPENED fires until LOOT_CLOSED fires : loot = OK!					

					-- ITEM_UNIQUE_MULTIPLE = ITEM_UNIQUE_MULTIPLE:gsub("%(%%d%)", "%%((%d+)%%)"); -- "Unique (%d)";
					-- ITEM_UNIQUE = "Unique";
					local autoLoot = (self.GetCVar("autoLootDefault") and not self:ModKey_CallBack())
					if (self:ModKey_CallBack() and not self.GetCVar("autoLootDefault")) or autoLoot then -- Probably can't do a modified click in this manner, but it doesn't hurt to check.
						for i = 1, self.GetNumLootItems() do -- Not sure if this will work if there's more than 4 loot items.
							local itemLink, lootItem = (GetLootSlotLink(i)), true
							if itemLink then
								self.Tooltip:ClearLines()
								self.Tooltip:SetHyperlink(itemLink)
								for j = 1, self.Tooltip:NumLines() do
									local line, text = _G["NoBoPHiddenTooltipTextLeft" .. j]
									if line then
										text = line:GetText()
										local quantity = text:match(ITEM_UNIQUE_MULTIPLE)
										if text == ITEM_UNIQUE or quantity then
											if GetItemCount(itemLink, true) == (quantity or 1) then
												lootItem = false
											end
										end
									end
								end
							end
							if lootItem then
								self.LootSlots[i] = true
							end
						end
					end
					self.LootFrame:Show();
				elseif event == "LOOT_SLOT_CLEARED" then
					self.LootSlots[arg1] = nil
				elseif event == "LOOT_CLOSED" then
					for i in pairs(self.LootSlots) do
						self.LootSlots[i] = nil;
					end
					self.LootFrame:Hide()
				end
			end
		);
		
		self:SlashCmdList_AddSlashCommand("NoBoPWarning", function(msg)
			if msg:lower():sub(1, 3) == "fix" then
				NoBoPWarning_FixRollFrames = (not NoBoPWarning_FixRollFrames);
				for i = 1, NUM_GROUP_LOOT_FRAMES do
					if NoBoPWarning_FixRollFrames then
						NoBoPWarning:FixGroupLootFrameScale(_G["GroupLootFrame"..i], false)
						_G["GroupLootFrame"..i]:SetScript("OnShow", function(self)
							NoBoPWarning:FixGroupLootFrameScale(self, true)
						end)
					else
						NoBoPWarning:RestoreGroupLootFrameScale(_G["GroupLootFrame"..i], false)
						_G["GroupLootFrame"..i]:SetScript("OnShow", function(self)
							NoBoPWarning:RestoreGroupLootFrameScale(self, true)
						end)
					end
				end
			else
				NoBoPWarning_Enabled = (not NoBoPWarning_Enabled);
				if NoBoPWarning_Enabled then
					self:AddMessage('[NoBoPWarning] Enabled.');
				else
					self:AddMessage('[NoBoPWarning] Disabled.');
				end
			end
		end, "bop", "nobopwarning");
		
		self:SetScript('OnUpdate', function(self, ...)
			if ( not NoBoPWarning_Enabled or self.InGroup or self.FakeInGroup ) then
				if not UIParent:IsEventRegistered("LOOT_BIND_CONFIRM") then
					UIParent:RegisterEvent("LOOT_BIND_CONFIRM")
				end
			else
				if UIParent:IsEventRegistered("LOOT_BIND_CONFIRM") then
					UIParent:UnregisterEvent("LOOT_BIND_CONFIRM")
				end
			end
			-- Short circuiting will, hopefully, reduce overhead.
			if (not self.ABOP_Notified or AutoBindOnPickup_Enabled == 1) and self.VARIABLES_LOADED and IsAddOnLoaded('AutoBindOnPickup') then
				AutoBindOnPickup_Enabled = 0;
				self.ABOP_Notified = true;
				self.DisableAddOn('AutoBindOnPickup');
				self:AddMessage('[NoBoPWarning] AutoBindOnPickup was found and disabled.');
			end
			self.InGroup = self.IsInGroup();
			self.AutoLootKey = self.GetModifiedClick("AUTOLOOTTOGGLE");
		end);
		
		self:RegisterEvents("PLAYER_ENTERING_WORLD", --[["LOOT_BIND_CONFIRM",]] "VARIABLES_LOADED", "LOOT_OPENED", "LOOT_SLOT_CLEARED", "LOOT_CLOSED");
		self:AddMessage('[NoBoPWarning] Loaded. Type "'..SLASH_NoBoPWarning1..'" to toggle enabled/disabled.');
	end;
	LootSlots = {};
})

LootSlot = function(i)
	if NoBoPWarning.LootSlots[i] then
		NoBoPWarning.LootSlots[i] = nil
		NoBoPWarning.OldLootSlot(i)
	end
end;

function LootButton_OnClick(self, button)
	-- Close any loot distribution confirmation windows
	StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION");
	
	NoBoPWarning.LootFrame.selectedLootButton = self:GetName();
	NoBoPWarning.LootFrame.selectedSlot = self.slot;
	NoBoPWarning.LootFrame.selectedQuality = self.quality;
	NoBoPWarning.LootFrame.selectedItemName = _G[self:GetName().."Text"]:GetText();
	NoBoPWarning.LootSlots[self.slot] = true

	LootFrame.selectedLootButton = self:GetName();
	LootFrame.selectedSlot = self.slot;
	LootFrame.selectedQuality = self.quality;
	LootFrame.selectedItemName = _G[self:GetName().."Text"]:GetText();
	
	NoBoPWarning.LootSlots[self.slot] = true

	LootSlot(self.slot);
end

NoBoPWarning.LootFrame:SetScript("OnUpdate", function(self, ...)
	for i in pairs(NoBoPWarning.LootSlots) do
		NoBoPWarning.LootSlots[i] = nil;
		if not ( UIParent:IsEventRegistered("LOOT_BIND_CONFIRM") ) then
			ConfirmLootSlot(i);
		end
		LootSlot(i);
	end
end)

NoBoPWarning:Load()
