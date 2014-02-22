--
-- Proculas
-- Tracks and gatheres stats on Procs.
--
-- Copyright (c) Xocide, who is:
--  - Korvo on US Proudmoore
--  - Idunnô, Clorell, Mcstabin on US Hellscream
--

-- Scans an item and checks for procs
function Proculas:scanItem(slotID)
	local itemlink = GetInventoryItemLink("player", slotID)
	if itemlink ~= nil then
		local found, _, itemstring = string.find(itemlink, "^|c%x+|H(.+)|h%[.+%]")
		if(found) then
			local _, itemId, enchantId, jewelId1, jewelId2, jewelId3, jewelId4, suffixId, uniqueId, fromLvl = strsplit(":", itemstring)
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemlink)

			-- Enchants and Embroideries
			if tonumber(enchantId) ~= 0 then
				local enchID = tonumber(enchantId)
				if(self.procs.ENCHANTS[enchID]) then
					--if not self.optpc.tracked[enchID] then
					local ench = self.procs.ENCHANTS[enchID]
					if not self.optpc.procs[ench.procId] then
						local procInfo = self.procs.ENCHANTS[enchID]
						local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(procInfo.spellIds[1])
						procInfo.icon = icon
						procInfo.name = name
						procInfo.rank = rank
						self:addProc(procInfo)
					end
				end
			end

			-- Items
			itemId = tonumber(itemId)
			if self.procs.ITEMS[itemId] then
				--for _,spell in pairs(self.procs.ITEMS[itemId].spellIds) do
					if not self.optpc.tracked[spell] then
						local procInfo = self.procs.ITEMS[itemId];
						procInfo.name = itemName
						procInfo.icon = itemTexture
						procInfo.itemId = itemId
						--procInfo.spellId = spell
						self:addProc(procInfo)
					end
				--end
			end
		end
	end
end

-- Scans for Procs
function Proculas:scanForProcs()
	--self:Print("Scanning for procs");

	-- Find Procs
	self:scanItem(GetInventorySlotInfo("MainHandSlot"))
	self:scanItem(GetInventorySlotInfo("SecondaryHandSlot"))
	self:scanItem(GetInventorySlotInfo("Trinket0Slot"))
	self:scanItem(GetInventorySlotInfo("Trinket1Slot"))
	self:scanItem(GetInventorySlotInfo("Finger0Slot"))
	self:scanItem(GetInventorySlotInfo("Finger1Slot"))
	self:scanItem(GetInventorySlotInfo("HeadSlot"))
	self:scanItem(GetInventorySlotInfo("NeckSlot"))
	self:scanItem(GetInventorySlotInfo("ShoulderSlot"))
	self:scanItem(GetInventorySlotInfo("BackSlot"))
	self:scanItem(GetInventorySlotInfo("ChestSlot"))
	self:scanItem(GetInventorySlotInfo("WristSlot"))
	self:scanItem(GetInventorySlotInfo("HandsSlot"))
	self:scanItem(GetInventorySlotInfo("WaistSlot"))
	self:scanItem(GetInventorySlotInfo("LegsSlot"))
	self:scanItem(GetInventorySlotInfo("FeetSlot"))

	-- Add Class Procs
	for index,procs in pairs(self.procs) do
		if(index == playerClass) then
			for spellID,procInfo in pairs(procs) do
				procInfo.spellId = spellID
				local name, rank, icon = GetSpellInfo(spellID)
				procInfo.icon = icon
				procInfo.name = name
				procInfo.rank = rank
				procInfo.spellIds = {}
				table.insert(procInfo.spellIds, spellID)
				self:addProc(procInfo)
			end
		end
	end
end
