-------------------------------------------------------------------------------
-- CharacterProfiler support
-------------------------------------------------------------------------------

local global = _G;
setmetatable(WhoHas, { __index = _G });
setfenv(1, WhoHas);

Scanner.CharacterProfiler = Scanner.Default:new{ key = "CP" };

function Scanner.CharacterProfiler:ScanPlayer()
   local charData;
   if (myProfile and myProfile[realm] and myProfile[realm].Character) then
      charData = myProfile[realm].Character[player];
   end
   if (charData) then
      playerCache = {};
      self:doBags(charName, charData.Inventory, WHOHAS_CATEGORY_INVENTORY, formats.Inventory, playerCache);
      self:doBags(charName, charData.Bank, WHOHAS_CATEGORY_BANK, formats.Bank, playerCache);
      if (config.inbox) then
         self:doInbox(charName, charData.MailBox, WHOHAS_CATEGORY_INBOX, formats.Inbox, playerCache);
      end
   end
end

function Scanner.CharacterProfiler:ScanAlts()
   if (myProfile and myProfile[realm] and myProfile[realm].Character) then
      for charName, charData in pairs(myProfile[realm].Character) do
         if (charName ~= player and (config.allfactions or charData and charData.FactionEn == faction)) then
            altCache[charName] = {};
            self:doBags(charName, charData.Inventory, WHOHAS_CATEGORY_INVENTORY, formats.Inventory, altCache[charName]);
            self:doBags(charName, charData.Bank, WHOHAS_CATEGORY_BANK, formats.Bank, altCache[charName]);
            if (config.inbox) then
               self:doInbox(charName, charData.MailBox, WHOHAS_CATEGORY_INBOX, formats.Inbox, altCache[charName]);
            end
         end
      end
   end
end

function Scanner.CharacterProfiler:doBags(char, bags, slot, format, cache)
   if (bags) then
      for bag, bagData in pairs(bags) do
         if (bagData.Slots) then
            for i = 1, bagData.Slots do
               local item = bagData.Contents[i]
               if (item and item.Name) then
                  local count = item.Quantity or 1;
                  if (not cache[item.Name]) then
                     cache[item.Name] = {};
                  end
                  cache[item.Name][slot] = count + (cache[item.Name][slot] or 0);
               end
            end
         end
      end
   end
end

function Scanner.CharacterProfiler:doInbox(char, inbox, slot, format, cache)
   if (inbox) then
      for i, msg in ipairs(inbox) do
         if (msg) then
            if (msg.Item and msg.Item.Name) then
               -- pre-2.3 CP
               local item = msg.Item;
               local count = item.Quantity or 1;
               if (not cache[item.Name]) then
                  cache[item.Name] = {};
               end
               cache[item.Name][slot] = count + (cache[item.Name][slot] or 0);
            elseif (msg.Contents) then
               -- post-2.3 CP
               for i, item in pairs(msg.Contents) do
                  if (item and item.Name) then
                     local count = item.Quantity or 1;
                     if (not cache[item.Name]) then
                        cache[item.Name] = {};
                     end
                     cache[item.Name][slot] = count + (cache[item.Name][slot] or 0);
                  end
               end
            end
         end
      end
   end
end
