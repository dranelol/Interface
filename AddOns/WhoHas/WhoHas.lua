-- define a few globals
WhoHas = {}

WHOHAS_CONFIG_VERSION = 8;

WhoHasConfig = {
   enabled          = 1,
   totals           = 1,
   stacks           = 1,
   inbox            = 1,
-- removed in v7
-- keyring          = 1,
   bags             = 1,
   equipment        = 1,
   allfactions      = nil,
-- added in v2
   version          = WHOHAS_CONFIG_VERSION,
   vault            = 1,
-- added in v3
   disableWorldTips = nil,
-- added in v4
   mines            = 1,
   ores             = 1,
-- added in v5
   ignore           = nil,
   allguilds        = nil,
   vaulttabs        = nil,
-- added in v6
   backend          = nil,
-- added in v7
   voidstore        = 1,
-- added in v8
   allrealms        = nil,
}

WhoHasData = {
}

-- set up a local environment
-- every symbol NAME after these three lines can be accessed from other addons
-- as "WhoHas.NAME".
local global = _G;
setmetatable(WhoHas, { __index = _G });
setfenv(1, WhoHas);

savedName        = "";
player           = "";
realm            = "";
faction          = "";
guild            = nil;
tooltipText      = {};
altCache         = {};
playerCache      = {};
vault            = {};
inventoryChanged = 1;
altsChanged      = 1;
vaultChanged     = 1;
fullVaultRefresh = 1;
backend          = nil;

config = global.WhoHasConfig;
data   = global.WhoHasData;

-- these are internal strings, not for display
WHOHAS_CATEGORY_INVENTORY = "inventory";
WHOHAS_CATEGORY_BANK      = "bank";
WHOHAS_CATEGORY_INBOX     = "inbox";
WHOHAS_CATEGORY_EQUIPMENT = "equipment";
WHOHAS_CATEGORY_INVBAGS   = "invbags";
WHOHAS_CATEGORY_BANKBAGS  = "bankbags";
WHOHAS_CATEGORY_VAULT     = "vault";
WHOHAS_CATEGORY_TOTAL     = "total";
WHOHAS_CATEGORY_STACK     = "stack";
WHOHAS_CATEGORY_VOIDSTORE = "voidstore";

categories = {
   WHOHAS_CATEGORY_INVENTORY,
   WHOHAS_CATEGORY_BANK,
   WHOHAS_CATEGORY_INBOX,
   WHOHAS_CATEGORY_EQUIPMENT,
   WHOHAS_CATEGORY_INVBAGS,
   WHOHAS_CATEGORY_BANKBAGS,
   WHOHAS_CATEGORY_VOIDSTORE
}

-------------------------------------------------------------------------------
-- OnLoad
-------------------------------------------------------------------------------

function OnLoad(frame)
   SlashCmdList["WHOHAS"] = SlashCommandHandler;
   table.insert(UISpecialFrames, "WhoHasConfigFrame");

   backend = Scanner.Default;

   HookFunction("ReturnInboxItem", ReturnInboxItem);
   HookFunction("SendMail", SendMail);

   HookMethod(ItemRefTooltip, "SetHyperlink", ShowTooltip);

   HookScript(GameTooltip, "OnTooltipSetItem", OnTooltipSetItem);
   HookScript(GameTooltip, "OnTooltipCleared", OnTooltipCleared);

   if (Possessions_ItemButton_OnEnter) then
      Orig_Possessions_ItemButton_OnEnter = Possessions_ItemButton_OnEnter
      Possessions_ItemButton_OnEnter      = Possessions_ItemButton_OnEnter
   end

   if (IsAddOnLoaded("Blizzard_GuildBankUI")) then
      HookScript(GuildBankFrame, "OnShow", LoadGuildBank);
      HookFunction("GuildBankFrame_Update", ScanGuildBank);
   end

   for event in pairs(events) do
      frame:RegisterEvent(event);
   end
end

-------------------------------------------------------------------------------
-- Slash commands
-------------------------------------------------------------------------------

function SlashCommandHandler(msg)
   if (not msg or msg == "") then
      ShowConfigFrame();
   else
      local cmd, arg = string.match(msg, "(.-) (.*)");
      if (cmd and arg and cmd == text.ignore) then
         arg = strtrim(arg, " \t\r\n'\"");
         local item = GetItemInfo(arg);
         if (item) then
            config.ignore = config.ignore or {};
            config.ignore[item] = 1;
            DEFAULT_CHAT_FRAME:AddMessage(string.format(formats.ignore, item));
         else
            DEFAULT_CHAT_FRAME:AddMessage(string.format(formats.noitem, arg));
         end
      else
         DEFAULT_CHAT_FRAME:AddMessage(text.usage);
      end
   end
end

-------------------------------------------------------------------------------
-- Utility functions
-------------------------------------------------------------------------------

function ShowConfigFrame()
   InterfaceOptionsFrame_OpenToCategory(WhoHasOptionsPanel);
   -- WhoHasConfigFrame:Show();
end

function InventoryChanged()
   inventoryChanged = 1;
end

-- pass non-nil to force a complete refresh
function VaultChanged(refresh)
   vaultChanged = 1;
   fullVaultRefresh = refresh;
end

function OptionsChanged()
   inventoryChanged = 1;
   altsChanged = 1;
   vaultChanged = 1;
   fullVaultRefresh = 1;
end

function ForceFullRefresh()
   altCache    = {};
   playerCache = {};
   vault       = {};
   OptionsChanged();
end

function UpdateGuild()
   if (guild ~= GetGuildInfo("player")) then
      guild = GetGuildInfo("player");
      VaultChanged();
   end
end

function UpdateScanner()
   local scanner = nil

   if (config) then
      if (config.backend == "Altoholic") then
         scanner = Scanner.Altoholic
      elseif (config.backend == "Armory") then
         scanner = Scanner.Armory
      elseif (config.backend == "Possessions") then
         if (POSS_USEDBANKBAGS_CONTAINER) then
            scanner = Scanner.Possessions.Lauchsuppe
         else
            scanner = Scanner.Possessions.Siz
         end
      elseif (config.backend == "CharacterProfiler") then
         scanner = Scanner.CharacterProfiler
      end
   end

   -- everything else is default "auto" type
   if (not scanner) then
      if (DataStore) then
         scanner = Scanner.Altoholic
      elseif (ArmoryDB) then
         scanner = Scanner.Armory
      elseif (PossessionsData) then
         if (POSS_USEDBANKBAGS_CONTAINER) then
            scanner = Scanner.Possessions.Lauchsuppe
         else
            scanner = Scanner.Possessions.Siz
         end
      elseif (myProfile) then
         scanner = Scanner.CharacterProfiler
      end
   end

   -- last ditch... we didn't match anything
   if (not scanner) then
      scanner = Scanner.Default
   end

   if (backend ~= scanner) then
      backend = scanner
      ForceFullRefresh()
      DEFAULT_CHAT_FRAME:AddMessage(backend:GetAnnounce())
   end
end

function TooltipIsRecipe(frame)
   if (frame.GetItem) then
      local name, link = frame:GetItem();
      if (link) then
         local _, _, _, _, _, type, subtype = GetItemInfo(link);
         return (type == "Recipe" and subtype ~= "Enchanting");
      end
   end
   return false;
end

function NameFromLink(link)
   return string.match(link, "%[(.+)%]");
end

function DoNothing()
end

function debug(msg)
   DEFAULT_CHAT_FRAME:AddMessage("WhoHas: " .. msg);
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------

events = {}

function OnEvent(frame, event, ...)
   local func = events[event];
   if (func) then
      func(...);
   end
end

function events.ADDON_LOADED(name)
   if (name == "WhoHas") then
      player  = UnitName("player");
      realm   = GetRealmName();
      faction = UnitFactionGroup("player");
      UpdateGuild();
      UpdateScanner();
   elseif (name == "Blizzard_GuildBankUI") then
      HookScript(GuildBankFrame, "OnShow", LoadGuildBank);
      HookFunction("GuildBankFrame_Update", ScanGuildBank);
   end
end

function events.VARIABLES_LOADED()
   -- make sure we have aliases to the loaded data
   config = WhoHasConfig
   data   = WhoHasData
   -- convert old config format to new
   if (not config.version or config.version < 2) then
      config.vault = 1
      config.version = 2
   end
   if (config.version < 4) then
      config.mines = 1
      config.ores = 1
   end
   if (config.version < 7) then
      config.keyring = nil
      config.voidstore = 1
   end
   if (config.version < WHOHAS_CONFIG_VERSION) then
      config.version = WHOHAS_CONFIG_VERSION
   end
   if (LinkWrangler) then
      LinkWrangler.RegisterCallback("WhoHas", ShowTooltip, "refresh")
   end
   UpdateScanner()
end

events.PLAYER_GUILD_UPDATE    = UpdateGuild;
events.PLAYER_ENTERING_WORLD  = UpdateGuild;
events.UNIT_INVENTORY_CHANGED = InventoryChanged;
events.BAG_UPDATE             = InventoryChanged;

function OnShow(frame)
   -- OnShow is the backup entry method.  This is only used for
   -- hover tooltips in the world and minimap.
   tooltip = frame:GetParent();
   -- don't set tooltip here if this is a recipe
   if (tooltip and not config.disableWorldTips and not tooltip.WhoHasShowing and not tooltip.WhoHasRecipe and not TooltipIsRecipe(tooltip)) then
      tooltip.WhoHasShowing = 1;
      ShowTooltip(tooltip);
   end
end

function OnHide(frame)
   tooltip = frame:GetParent();
   tooltip.WhoHasShowing = nil;
   tooltip.WhoHasRecipe = nil;
end

function OnTooltipSetItem(frame)
   -- OnTooltipSetItem is the preferred entry method.  This catches
   -- most tooltips.
   if (frame and not frame.WhoHasShowing) then
      -- recipes call OnTooltipSetItem twice for some reason, with
      -- an OnShow in between.  We only want to mod the tooltip
      -- after the second SetItem.
      if (not frame.WhoHasRecipe and TooltipIsRecipe(frame)) then
         frame.WhoHasRecipe = 1;
         return;
      end
      frame.WhoHasShowing = 1;
      ShowTooltip(frame);
   end
end

function OnTooltipCleared(frame)
   frame.WhoHasShowing = nil;
   frame.WhoHasRecipe = nil;
end

function BackendList_OnLoad(self)
   self.defaultValue = "auto";
   self.value = self.defaultValue;

   self.SetValue = 
      function (self, value)
         self.value = value or self.defaultValue;
         UIDropDownMenu_SetSelectedValue(self, self.value);
      end
   self.GetValue =
			function (self)
         return UIDropDownMenu_GetSelectedValue(self);
			end
   self.ResetValue =
			function (self, value)
         self.value = value or self.defaultValue;
         UIDropDownMenu_Initialize(self, BackendList_Init);
         UIDropDownMenu_SetSelectedValue(self, self.value);
			end

   UIDropDownMenu_EnableDropDown(self);
end

backendOptions = {
   { key="auto",      value="auto" },
   { key="armory",    value="Armory" },
   { key="possess",   value="Possessions" },
   { key="charprof",  value="CharacterProfiler" },
   { key="altoholic", value="Altoholic" },
   -- { key="bagnon",    value="Bagnon" },
};

function BackendList_Init(frame, level, menuList)
   local info = UIDropDownMenu_CreateInfo();
   local selectedValue = frame.value;

   for i, v in ipairs(backendOptions) do
      info.text = text[v.key];
      info.value = v.value;
      info.func = BackendList_OptionSelected;
      info.arg1 = frame;
      if info.value == selectedValue then
         info.checked = 1;
      else
         info.checked = nil;
      end
      UIDropDownMenu_AddButton(info);
   end
end

function BackendList_OptionSelected(item, frame)
   config.backend = item.value;
   frame:SetValue(item.value);
   UpdateScanner();
end

function OptionsPanel_OnShow(frame)
   WhoHasOptionsPanelBackendSelection:ResetValue(config.backend);
end

-------------------------------------------------------------------------------
-- Hooks
-------------------------------------------------------------------------------

function Possessions_ItemButton_OnEnter(args)
   -- don't doctor tooltips inside of Possessions
   skip = true;
   Orig_Possessions_ItemButton_OnEnter(args);
   skip = nil;
end

-------------------------------------------------------------------------------
-- Mail handling
-------------------------------------------------------------------------------

function SendMail(target, subject, body)
   if (config.inbox) then
      -- proper-case the name
      target = string.upper(string.sub(target, 1, 1)) .. string.lower(string.sub(target, 2));
      if (altCache[target]) then
         for i = 1, 12 do
            local item, _, qty, _ = GetSendMailItem(i);
            if (item) then
               altCache[target][item] = altCache[target][item] or {};
               altCache[target][item].inbox = (altCache[target][item].inbox or 0) + qty;
            end
         end
      end
      InventoryChanged();
   end
end

function ReturnInboxItem(mailID)
   if (config.inbox) then
      local _, _, sender, _ = GetInboxHeaderInfo(mailID);

      if (altCache[sender]) then
         for i = 1, 12 do
            local item, _, qty, _ = GetInboxItem(mailID, i);
            if (item) then
               altCache[sender][item] = altCache[sender][item] or {};
               altCache[sender][item].inbox = (altCache[sender][item].inbox or 0) + qty;
            end
         end
      end

      InventoryChanged();
   end
end

-------------------------------------------------------------------------------
-- Hooking functions
-------------------------------------------------------------------------------

function HookMethod(object, name, after, before)
   local func = object[name];
   if (func) then
      object[name] = function(self, ...)
                        if (before) then
                           before(self, ...);
                        end
                        r1, r2, r3, r4, r5, r6 = func(self, ...);
                        if (after) then
                           after(self, ...);
                        end
                        return r1, r2, r3, r4, r5, r6;
                     end
   end
end

function HookFunction(name, after, before)
   local func = global[name];
   if (func) then
      global[name] = function(...)
                    if (before) then
                       before(...);
                    end
                    r1, r2, r3, r4, r5, r6 = func(...);
                    if (after) then
                       after(...);
                    end
                    return r1, r2, r3, r4, r5, r6;
                 end
   end
end

function HookScript(object, name, after, before)
   local func = object:GetScript(name);
   if (func) then
      local newfunc = function(...)
                         if (before) then
                            before(...);
                         end
                         r1, r2, r3, r4, r5, r6 = func(...);
                         if (after) then
                            after(...);
                         end
                         return r1, r2, r3, r4, r5, r6;
                      end
      object:SetScript(name, newfunc);
   end
end

-------------------------------------------------------------------------------
-- Tooltip display
-------------------------------------------------------------------------------

function ShowTooltip(tooltip)
   if (tooltip and config.enabled and not skip) then
      local name = global[tooltip:GetName().."TextLeft1"]:GetText();
      if (not name or name == "") then
         return;
      end

      if (config.ignore and config.ignore[name]) then
         return;
      end

      UpdateCaches();
      UpdateTooltipText(name);
      AddTextToTooltip(tooltip);

      tooltip:Show();
   end
end

function UpdateCaches()
   if (not backend) then
      debug("UpdateCaches called with no backend set!");
      UpdateScanner();
   end

   if (altsChanged) then
      backend:ScanAlts();
      altsChanged = nil;
      savedName = "";
   end
   
   if (inventoryChanged) then
      backend:ScanPlayer();
      inventoryChanged = nil;
      savedName = "";
   end
   
   if (vaultChanged) then
      if (fullVaultRefresh) then
         vault = {};
         fullVaultRefresh = nil;
      end
      backend:ScanVault();
      vaultChanged = nil;
      savedName = "";
   end
end

function UpdateTooltipText(name)
   if (name ~= savedName) then
      tooltipText = {};
      savedName = name;
      GetText(name, tooltipText);
      
      if (config.mines) then
         while mines[name] do
            name = mines[name];
            table.insert(tooltipText, " ");
            table.insert(tooltipText, "(" .. name .. ")");
            if (GetText(name, tooltipText) == 0) then
               table.remove(tooltipText);
               table.remove(tooltipText);
            end
         end
      end
      
      if (config.ores) then
         while xlat[name] do
            name = xlat[name];
            table.insert(tooltipText, " ");
            table.insert(tooltipText, "(" .. name .. ")");
            if (GetText(name, tooltipText) == 0) then
               table.remove(tooltipText);
               table.remove(tooltipText);
            end
         end
      end
      
      if (config.ores) then
         if (enchant[savedName]) then
            name = enchant[savedName];
            table.insert(tooltipText, " ");
            table.insert(tooltipText, "(" .. name .. ")");
            if (GetText(name, tooltipText) == 0) then
               table.remove(tooltipText);
               table.remove(tooltipText);
            end
         end
      end
   end
end

function AddTextToTooltip(tooltip)
   for i, line in ipairs(tooltipText) do
      tooltip:AddLine(line);
   end
end

function GetText(name, text)
   local total = ListOwners(name, text);
   if (config.totals and total > 0) then
      table.insert(text, string.format(formats.total, total));
   end
   if (config.stacks) then
      local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, invTexture = GetItemInfo(name);
      if (itemStackCount and itemStackCount > 1) then
         table.insert(text, string.format(formats.stack, itemStackCount));
      end
   end
   return total;
end

function ListOwners(name, text)
   local total = 0;
   if (playerCache[name]) then
      total = total + ListChar(player, playerCache[name], text);
   end
   for charName, charData in pairs(altCache) do
      if (charData[name]) then
         total = total + ListChar(charName, charData[name], text);
      end
   end
   if (config.vault and vault) then
      total = total + ListVaults(name, text);
   end
   return total;
end

function ListChar(charName, charData, text)
   local total = 0;
   for i, category in ipairs(categories) do
      local count = charData[category];
      if count and count > 0 then
         if formats[category] then
            table.insert(text, string.format(formats[category], count, charName));
            total = total + count;
         else
            debug("category format not found: " .. (category or "nil"))
         end
      end
   end
   return total;
end

function ListVaults(name, text)
   local total = 0;
   for guild, data in pairs(vault) do
      if (guild and data) then
         if (data.hasTabs) then
            for tab = 1,MAX_GUILDBANK_TABS do
               if (data[tab] and data[tab][name]) then
                  -- for some reason, tables get into the vault data when using ArmoryGuildBank
                  -- ... but only sometimes
                  if (type(data[tab][name]) == "number") then
                     local count = data[tab][name];
                     if (config.allguilds) then
                        table.insert(text, string.format(formats.multivaulttab, count, guild, tab));
                     else
                        table.insert(text, string.format(formats.vaulttab, count, tab));
                     end
                     total = total + count;
                  end
               end
            end
         else
            if (data[name]) then
               local count = data[name];
               if (config.allguilds) then
                  table.insert(text, string.format(formats.multivault, count, guild));
               else
                  table.insert(text, string.format(formats.vault, count));
               end
               total = total + count;
            end
         end
      end
   end
   return total;
end
