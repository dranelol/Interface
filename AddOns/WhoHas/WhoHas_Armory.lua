-------------------------------------------------------------------------------
-- Inventory scanning support
-------------------------------------------------------------------------------

local global = _G
setmetatable(WhoHas, { __index = _G })
setfenv(1, WhoHas)

Scanner.Armory = Scanner.Default:new{ key = "Armory" }

function Scanner.Armory:HasVaultData()
   return not not AGB  -- turn AGB into a boolean
end

function Scanner.Armory:ScanPlayer()
   playerCache = {}
   local origProfile = Armory:CurrentProfile()
   Armory:LoadProfile(realm, player)
   self:ScanChar(playerCache)
   Armory:SelectProfile(origProfile)
end

function Scanner.Armory:ScanAlts()
   altCache = {}
   local origProfile = Armory:CurrentProfile()
   for _, profile in ipairs(Armory:Profiles()) do
      if config.allrealms or profile.realm == realm then
         Armory:SelectProfile(profile)
         -- not really "player", but that's how Armory works
         local altName = Armory:UnitName("player")
         if altName ~= player then
            -- not really "player", but that's how Armory works
            if config.allfactions or Armory:UnitFactionGroup("player") == faction then
               altCache[altName] = {}
               self:ScanChar(altCache[altName])
            end
         end
      end
   end
   Armory:SelectProfile(origProfile)
end

function Scanner.Armory:ScanVault()
   if config.vault then
      local frame = ArmoryGuildBankFrame
      local origRealm = frame.selectedRealm
      local origGuild = frame.selectedGuild

      guild = GetGuildInfo("player")
      for _, gbRealm in ipairs(AGB:RealmList()) do
         if config.allrealms or gbRealm == realm then
            for _, gbGuild in ipairs(AGB:GuildList(gbRealm)) do
               local safename = gbGuild
               if (config.allrealms) then
                  safename = gbGuild .. " - " .. gbRealm
               end
               local db = AGB:SelectDb(frame, gbRealm, gbGuild)
               if (gbGuild == guild and gbRealm == realm) then
                  -- my guild - always scan
                  vault[safename] = {}
                  self:ScanGuildBank(db, vault[safename])
               elseif (config.allguilds and 
                       (config.allfactions or 
                        AGB:GetFaction(db) == faction) and
                       (config.allrealms or gbRealm == realm)) then
                  -- only scan other guild banks once, assume they cannot change.
                  -- this is not strictly true with Altoholic or Armory data sharing.
                  if (not vault[safename]) then
                     vault[safename] = {}
                     self:ScanGuildBank(db, vault[safename])
                  end
               end
            end
         end
      end
      AGB:SelectDb(frame, origRealm, origGuild)
   end
end

function Scanner.Armory:ScanGuildBank(db, cache)
   cache.hasTabs = config.vaulttabs
   for tab = 1, MAX_GUILDBANK_TABS do
      if AGB:TabExists(db, tab) then
         if cache.hasTabs then
            cache[tab] = {}
            self:ScanVaultTab(db, tab, cache[tab])
         else
            self:ScanVaultTab(db, tab, cache)
         end
      end
   end
end

function Scanner.Armory:ScanVaultTab(db, tab, cache)
   local items = AGB:GetTabItems(db, tab)
   if items then
      for index in pairs(items) do
         local name, link, _, count = AGB:GetTabItemInfo(db, tab, index)
         if name then
            self:AddItem(cache, name, count, WHOHAS_CATEGORY_VAULT)
         end
      end
   end
end

function Scanner.Armory:ScanChar(cache)
   -- character profile must already be selected in Armory

   -- inventory
   self:ScanBags(cache)
      
   -- equipment
   if (config.equipment) then
      self:ScanEquipment(cache)
   end

   -- bank
   self:ScanBank(cache)
   
   -- bags
   if (config.bags) then
      self:ScanBagTypes(cache)
   end

   -- inbox
   if (config.inbox) then
      self:ScanInbox(cache)
   end

   -- void storage
   if (config.voidstore) then
      self:ScanBag(ARMORY_VOID_CONTAINER, WHOHAS_CATEGORY_VOIDSTORE, cache)
   end

   -- auctions?
end

function Scanner.Armory:ScanInbox(cache)
   -- nice!! it's not always best to emulate the WoW API.... :)
   self:ScanBag(ARMORY_MAIL_CONTAINER, WHOHAS_CATEGORY_INBOX, cache)
end

function Scanner.Armory:ScanEquipment(cache)
   self:ScanBag(ARMORY_EQUIPMENT_CONTAINER, WHOHAS_CATEGORY_EQUIPMENT, cache)
end

function Scanner.Armory:ScanBagTypes(cache)
   for index = 1, NUM_BAG_SLOTS do
      local name = Armory:GetInventoryContainerInfo(index)
      if name then
         self:AddItem(cache, name, 1, WHOHAS_CATEGORY_INVBAGS)
      end
   end
   for index = 1, NUM_BANKBAGSLOTS do
      local name = Armory:GetInventoryContainerInfo(index + NUM_BAG_SLOTS)
      if name then
         self:AddItem(cache, name, 1, WHOHAS_CATEGORY_BANKBAGS)
      end
   end
end

function Scanner.Armory:ScanBags(cache)
   for index = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
      self:ScanBag(index, WHOHAS_CATEGORY_INVENTORY, cache)
   end
end

function Scanner.Armory:ScanBank(cache)
   self:ScanBag(BANK_CONTAINER, WHOHAS_CATEGORY_BANK, cache)
   for index = 1, NUM_BANKBAGSLOTS do
      self:ScanBag(index + NUM_BAG_SLOTS, WHOHAS_CATEGORY_BANK, cache)
   end
end

function Scanner.Armory:ScanBag(bag, type, cache)
   for index = 1, Armory:GetContainerNumSlots(bag) do
      local link = Armory:GetContainerItemLink(bag, index)
      -- GetNameFromLink respect nil links
      local name = Armory:GetNameFromLink(link)
      if name then
         local _, count = Armory:GetContainerItemInfo(bag, index)
         self:AddItem(cache, name, count, type)
      end
   end
end
