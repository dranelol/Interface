-------------------------------------------------------------------------------
-- Inventory scanning support
-------------------------------------------------------------------------------

local global = _G;
setmetatable(WhoHas, { __index = _G });
setfenv(1, WhoHas);

Scanner = {}
Scanner.Default = { key = "none" }

function Scanner.Default:new(o)
   o = o or {};
   setmetatable(o, self);
   self.__index = self;
   return o;
end

function Scanner.Default:GetAnnounce()
   return support[self.key] or "";
end

function Scanner.Default:HasVaultData()
   return nil;
end

function Scanner.Default:ScanPlayer()
end

function Scanner.Default:ScanAlts()
end

function Scanner.Default:ScanVault()
   if (config.vault and data and data[realm]) then
      guild = GetGuildInfo("player");
      for who, items in pairs(data[realm]) do
         -- if allguilds is not set, show only our vault
         -- otherwise show only our faction's vaults
         if (who == guild or (config.allguilds and items.faction == faction)) then
            if (config.vaulttabs) then
               vault[who] = items;
               vault[who].hasTabs = 1;
            else
               -- only scan the current guild and guilds we haven't scanned yet
               -- alt guild data can't change
               if (who == guild) then
                  vault[who] = nil;
               end
               if (not vault[who]) then
                  vault[who] = {};
                  for tab = 1, MAX_GUILDBANK_TABS do
                     if (items[tab]) then
                        for name, count in pairs(items[tab]) do
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

function Scanner.Default:AddItem(cache, name, count, category)
   if (name) then
      -- stupid, stupid, stupid. I didn't include the category in vault data,
      -- so I have to treat it differently. review this later.
      if (category == WHOHAS_CATEGORY_VAULT) then
         cache[name] = (cache[name] or 0) + count
      else
         cache[name] = cache[name] or {}
         cache[name][category] = (cache[name][category] or 0) + count
      end
   end
end

-------------------------------------------------------------------------------
-- Guild Bank support
-------------------------------------------------------------------------------

-- these scanning functions are always hooked into the GuildBank, but
-- they don't actually gather any data if we can use data from another
-- backend instead.

function LoadGuildBank()
   if (config.vault and not backend:HasVaultData() and not vaultLoaded) then
      guild = GetGuildInfo("player");
      if (guild) then
         -- suppress updates temporarily
         config.vault = nil;
         for tab = 1, GetNumGuildBankTabs() do
            QueryGuildBankTab(tab);
         end
         -- restore updates and force update now
         vaultLoaded = 1;
         config.vault = 1;
         ScanGuildBank();
      end
   end
end

function ScanGuildBank()
   if (config.vault and not backend:HasVaultData()) then
      guild = GetGuildInfo("player");
      if (guild) then
         local cache = {};
         cache.faction = faction;
         for tab = 1, GetNumGuildBankTabs() do
            cache[tab] = {};
            for slot = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
               local texture, count, _ = GetGuildBankItemInfo(tab, slot);
               if (texture) then
                  local link = GetGuildBankItemLink(tab, slot);
                  if (link) then
                     local name = GetItemInfo(link);
                     cache[tab][name] = count + (cache[tab][name] or 0);
                  end
               end
            end
         end
         data[realm] = data[realm] or {};
         data[realm][guild] = cache;
      end
   end
   VaultChanged();
end
