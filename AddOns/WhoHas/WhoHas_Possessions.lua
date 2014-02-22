-------------------------------------------------------------------------------
-- Possessions support
-------------------------------------------------------------------------------

local global = _G;
setmetatable(WhoHas, { __index = _G });
setfenv(1, WhoHas);

Scanner.Possessions = Scanner.Default:new();
Scanner.Possessions.Siz = Scanner.Possessions:new{ key = "SizPoss" };
Scanner.Possessions.Lauchsuppe = Scanner.Possessions:new{ key = "LSPoss" };

Scanner.Possessions.Lauchsuppe.slots = {
   Inventory = { 0, 1, 2, 3, 4 },
   Bank      = { -1, 5, 6, 7, 8, 9, 10, 11 },
   Keyring   = { -2 },
   Equipment = { -3 },
   Inbox     = { -4 },
   InvBags   = { -5 },
   BankBags  = { -6 }
}

Scanner.Possessions.Siz.slots = {
   Inventory = { 0, 1, 2, 3, 4 },
   Bank      = { -1, 5, 6, 7, 8, 9, 10, 11 },
   Equipment = { -2 },
   Inbox     = { -3 },
   VoidStore = { -4 },
   InvBags   = { -5 },
   BankBags  = { -6 },
   Vault     = { -7 }
}

function Scanner.Possessions.Siz:HasVaultData()
   -- Possessions doesn't track tabs
   return not config.vaulttabs;
end

function Scanner.Possessions:ScanPlayer()
   local charData;
   if (PossessionsData and PossessionsData[realm]) then
      charData = PossessionsData[realm][string.lower(player)];
   end
   if (charData) then
      playerCache = {};
      self:ScanChar(player, charData, playerCache);
   end
end

function Scanner.Possessions:ScanAlts()
   if (PossessionsData and PossessionsData[realm]) then
      for charName, charData in pairs(PossessionsData[realm]) do
         if (charName and charData and (config.allfactions or charData.faction == faction)) then
            -- Possessions lower-cases character names, annoyingly
            charName = string.upper(string.sub(charName, 1, 1)) .. string.sub(charName, 2);
            if (charName ~= player) then
               altCache[charName] = {};
               self:ScanChar(charName, charData, altCache[charName]);
            end
         end
      end
   end
end

function ClearVault()
   -- this is a placeholder to test zeroing out the vault instead of
   -- replacing the whole table
   vault = {};
end

function CleanupVault()
   -- this is meant to delete entries with zero counts, if we need to
end

function Scanner.Possessions.Siz:ScanVault()
   if (config.vaulttabs) then
      -- Possessions doesn't track tabs
      Scanner.Default.ScanVault(self);
   else
      vault = vault or {};
      if (config.vault and self.slots.Vault) then
         if (PossessionsData and PossessionsData[realm]) then
            guild = GetGuildInfo("player");
            for who, data in pairs(PossessionsData[realm]) do
               -- see if it's a vault
               -- note: this isn't portable.  fix the -7 index
               if (data and data.items and data.items[-7]) then
                  -- only show our vault if allguilds is not set,
                  -- otherwise show only our faction, or vaults without a faction
                  if (who == guild or (config.allguilds and (not data.faction or data.faction == faction))) then
                     -- only scan the current guild and guilds we haven't scanned yet
                     -- alt guild data can't change
                     if (who == guild) then
                        vault[who] = nil;
                     end
                     if (not vault[who]) then
                        vault[who] = {};
                        local bags = data.items;
                        for _, index in pairs(self.slots.Vault) do
                           if (bags[index]) then
                              for i, item in pairs(bags[index]) do
                                 if (item and item[1]) then
                                    local name = item[1];
                                    local count = item[3] or 1;
                                    vault[who][name] = count + (vault[who][name] or 0);
                                 end
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end
end

function Scanner.Possessions:ScanChar(charName, charData, cache)
   if (charData and charData.items) then
      self:ScanBags(charName, WHOHAS_CATEGORY_INVENTORY, charData.items, self.slots.Inventory, cache);
      self:ScanBags(charName, WHOHAS_CATEGORY_BANK, charData.items, self.slots.Bank, cache);
      if (config.inbox) then
         self:ScanBags(charName, WHOHAS_CATEGORY_INBOX, charData.items, self.slots.Inbox, cache);
      end
      if (config.voidstore) then
         self:ScanBags(charName, WHOHAS_CATEGORY_VOIDSTORE, charData.items, self.slots.VoidStore, cache);
      end
      if (config.equipment) then
         self:ScanBags(charName, WHOHAS_CATEGORY_EQUIPMENT, charData.items, self.slots.Equipment, cache);
      end
      if (config.bags and self.slots.InvBags) then
         self:ScanBags(charName, WHOHAS_CATEGORY_INVBAGS, charData.items, self.slots.InvBags, cache);
      end
      if (config.bags and self.slots.BankBags) then
         self:ScanBags(charName, WHOHAS_CATEGORY_BANKBAGS, charData.items, self.slots.BankBags, cache);
      end
   end
end

function Scanner.Possessions:ScanBags(char, slot, bags, bagIndex, cache)
   for _, index in pairs(bagIndex) do
      if (bags[index]) then
         for i, item in pairs(bags[index]) do
            if (item and item[1]) then
               local name = item[1];
               local count = item[3] or 1;
               if (not cache[name]) then
                  cache[name] = {};
               end
               cache[name][slot] = count + (cache[name][slot] or 0);
            end
         end
      end
   end
end
