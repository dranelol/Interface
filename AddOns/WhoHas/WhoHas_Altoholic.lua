-------------------------------------------------------------------------------
-- Inventory scanning support
-------------------------------------------------------------------------------

local global = _G
setmetatable(WhoHas, { __index = _G })
setfenv(1, WhoHas)

Scanner.Altoholic = Scanner.Default:new{ key = "Altoholic" }

Scanner.Altoholic.account = "Default"
Scanner.Altoholic.slots = {
   Inventory = { 1, 2, 3, 4 },
   Bank = { 5, 6, 7, 8, 9, 10, 11 },
}

function Scanner.Altoholic:HasVaultData()
   return 1
end

function Scanner.Altoholic:ScanPlayer()
   playerCache = {}
   local char = DataStore:GetCharacter(player, realm, account)
   self:ScanChar(char, playerCache)
end

function Scanner.Altoholic:ScanAlts()
   altCache = {}
   for altAccount in pairs(DataStore:GetAccounts()) do
      for altRealm in pairs(DataStore:GetRealms(altAccount)) do
         if (config.allrealms or altRealm == realm) then
            for altName, alt in pairs(DataStore:GetCharacters(altRealm, altAccount)) do
               if (altName ~= player) then
                  altCache[altName] = {};
                  if (config.allfactions or DataStore:GetCharacterFaction(alt) == faction) then
                     self:ScanChar(alt, altCache[altName]);
                  end
               end
            end
         end
      end
   end
end

function Scanner.Altoholic:ScanVault()
   if (config.vault) then
      guild = GetGuildInfo("player");
      for gbAccount in pairs(DataStore:GetAccounts()) do
         for gbRealm in pairs(DataStore:GetRealms(gbAccount)) do
            if (config.allrealms or gbRealm == realm) then
               for guildName, guildKey in pairs(DataStore:GetGuilds(gbRealm, gbAccount)) do
                  local safename = guildName
                  if (config.allrealms) then
                     safename = guildName .. " - " .. gbRealm
                  end
                  if (guildName == guild and gbRealm == realm) then
                     -- my guild - always scan
                     vault[safename] = {}
                     self:ScanGuildBank(guildKey, vault[safename])
                  elseif (config.allguilds and 
                          (config.allfactions or 
                           DataStore:GetGuildFaction(guildName, gbRealm, gbAccount) == faction) and
                          (config.allrealms or gbRealm == realm)) then
                     -- only scan other guild banks once, assume they cannot change.
                     -- this is not strictly true with Altoholic or Armory data sharing.
                     if (not vault[safename]) then
                        vault[safename] = {}
                        self:ScanGuildBank(guildKey, vault[safename])
                     end
                  end
               end
            end
         end
      end
   end
end

function Scanner.Altoholic:ScanGuildBank(guildKey, cache)
   cache.hasTabs = config.vaulttabs;
   for tab = 1, MAX_GUILDBANK_TABS do
      local tabData = DataStore:GetGuildBankTab(guildKey, tab)
      if (cache.hasTabs) then
         cache[tab] = {}
         self:ScanBag(tabData, WHOHAS_CATEGORY_VAULT, cache[tab])
      else
         self:ScanBag(tabData, WHOHAS_CATEGORY_VAULT, cache)
      end
   end
end

function Scanner.Altoholic:ScanChar(char, cache)
   if (char) then
      -- inventory
      self:ScanBag(self:GetBag(char, 0), WHOHAS_CATEGORY_INVENTORY, cache) -- backpack
      self:ScanBags(char, self.slots.Inventory, WHOHAS_CATEGORY_INVENTORY, cache)
      
      -- equipment
      if (config.equipment) then
         self:ScanEquipment(char, WHOHAS_CATEGORY_EQUIPMENT, cache)
      end

      -- bags
      if (config.bags) then
         self:ScanBagTypes(char, self.slots.Inventory, WHOHAS_CATEGORY_INVBAGS, cache)
      end

      -- bank
      self:ScanBag(self:GetBag(char, 100), WHOHAS_CATEGORY_BANK, cache) -- main bank
      self:ScanBags(char, self.slots.Bank, WHOHAS_CATEGORY_BANK, cache)
   
      -- bank bags
      if (config.bags) then
         self:ScanBagTypes(char, self.slots.Inventory, WHOHAS_CATEGORY_BANKBAGS, cache)
      end

      -- inbox
      if (config.inbox) then
         self:ScanInbox(char, WHOHAS_CATEGORY_INBOX, cache)
      end

      -- void storage
      if (config.voidstore) then
         self:ScanBag(self:GetBag(char, "VoidStorage"), WHOHAS_CATEGORY_VOIDSTORE, cache)
      end

      -- auctions?
   end
end

function Scanner.Altoholic:ScanInbox(char, type, cache)
   local mails = DataStore:GetNumMails(char)
   if (mails) then
      for index = 1, mails do
         local _, count, link = DataStore:GetMailInfo(char, index)
         if (link) then
            local name = GetItemInfo(link)
            self:AddItem(cache, name, count, type)
         end
      end
   end
end

function Scanner.Altoholic:ScanEquipment(char, type, cache)
   local items = DataStore:GetInventory(char)
   if (items) then
      for _, id in pairs(items) do
         if (id) then
            local name = GetItemInfo(id)
            self:AddItem(cache, name, 1, type)
         end
      end
   end
end

function Scanner.Altoholic:ScanBagTypes(char, bags, type, cache)
   for _, index in pairs(bags) do
      local bag = self:GetBag(char, index)
      if (bag and bag.link) then
         local name = GetItemInfo(bag.link)
         self:AddItem(cache, name, 1, type)
      end
   end
end

function Scanner.Altoholic:ScanBags(char, bags, type, cache)
   for _, index in pairs(bags) do
      self:ScanBag(self:GetBag(char, index), type, cache)
   end
end

function Scanner.Altoholic:ScanBag(bag, type, cache)
   if (bag and bag.ids and bag.counts) then
      for i, id in pairs(bag.ids) do
         if (id) then
            local name = GetItemInfo(id)
            local count = bag.counts[i] or 1
            self:AddItem(cache, name, count, type)
         end
      end
   end
end

function Scanner.Altoholic:GetBag(char, id)
   -- prereq: char must be valid
   if (type(id) == "number") then
      return DataStore:GetContainer(char, id)
   else
      return DataStore:GetContainers(char)[id]
   end
end
