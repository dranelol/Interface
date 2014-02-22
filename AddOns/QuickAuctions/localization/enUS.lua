local QuickAuctions = select(2, ...)
local L = {}
L[ [=[

%d in inventory
%d on the Auction House]=] ] = [=[

%d in inventory
%d on the Auction House]=]
L["%d (max %d) posted by yourself (%s)"] = "%d (max %d) posted by yourself (%s)"
L["%d log messages waiting"] = "%d log messages waiting"
L["%d mail"] = "%d mail"
L["%s lowest buyout %s (threshold %s), total posted |cfffed000%d|r (%d by you)"] = "%s lowest buyout %s (threshold %s), total posted |cfffed000%d|r (%d by you)"
L["/qa config - Toggles the configuration"] = "/qa config - Toggles the configuration"
L["/qa summary - Shows the auction summary"] = "/qa summary - Shows the auction summary"
L["/qa tradeskill - Toggles showing the craft queue window for tradeskills"] = "/qa tradeskill - Toggles showing the craft queue window for tradeskills"
L["12 hours"] = "12 hours"
L["24 hours"] = "24 hours"
L["48 hours"] = "48 hours"
L["ALTER_PERFECT"] = "ALTER_PERFECT"
L["Add a new player to your whitelist."] = "Add a new player to your whitelist."
L["Add group"] = "Add group"
L["Add items"] = "Add items"
L["Add items matching"] = "Add items matching"
L["Add items/groups"] = "Add items/groups"
L["Add mail target"] = "Add mail target"
L["Add player"] = "Add player"
L["After a cancel scan has finished, the ready check sound will play indicating user interaction is needed."] = "After a cancel scan has finished, the ready check sound will play indicating user interaction is needed."
L["All items that match the entered name will be automatically added to be mailed to %s, \"Glyph of\" will add all glyphs in your inventory for example."] = "All items that match the entered name will be automatically added to be mailed to %s, \"Glyph of\" will add all glyphs in your inventory for example."
L["Allows you to override bid percent settings for this group."] = "Allows you to override bid percent settings for this group."
L["Allows you to override the auto fallback settings for this group."] = "Allows you to override the auto fallback settings for this group."
L["Allows you to override the default cancel settings for this group."] = "Allows you to override the default cancel settings for this group."
L["Allows you to override the default post time sttings for this group."] = "Allows you to override the default post time sttings for this group."
L["Allows you to override the default stack ignore settings for this group."] = "Allows you to override the default stack ignore settings for this group."
L["Allows you to override the fallback price for this group."] = "Allows you to override the fallback price for this group."
L["Allows you to override the per auction settings for this group."] = "Allows you to override the per auction settings for this group."
L["Allows you to override the post cap settings for this group."] = "Allows you to override the post cap settings for this group."
L["Allows you to override the price gap settings for this group."] = "Allows you to override the price gap settings for this group."
L["Allows you to override the threshold settings for this group."] = "Allows you to override the threshold settings for this group."
L["Allows you to override the undercut settings for this group."] = "Allows you to override the undercut settings for this group."
L["Are you SURE you want to delete this group?"] = "Are you SURE you want to delete this group?"
L["Auction House closed before you could tell Quick Auctions to cancel."] = "Auction House closed before you could tell Quick Auctions to cancel."
L["Auction House must be visible for you to use this."] = "Auction House must be visible for you to use this."
L["Auction settings"] = "Auction settings"
L["Auctions ready to post."] = "Auctions ready to post."
L["Auto mail"] = "Auto mail"
L["Auto mailed items off to %s!"] = "Auto mailed items off to %s!"
L["Auto mailer"] = "Auto mailer"
L[ [=[Auto mailing will let you setup groups and specific items that should be mailed to another character.

Check your spelling! If you typo a name it will send it to the wrong person.]=] ] = [=[Auto mailing will let you setup groups and specific items that should be mailed to another character.

Check your spelling! If you typo a name it will send it to the wrong person.]=]
L["Auto recheck mail"] = "Auto recheck mail"
L[ [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=] ] = [=[Automatically rechecks mail every 60 seconds when you have too much mail.

If you loot all mail with this enabled, it will wait and recheck then keep auto looting.]=]
L["Bid percent"] = "Bid percent"
L["Bracer"] = "Bracer"
L["Bracers"] = "Bracers"
L["Buy"] = "Buy"
L["Cancel"] = "Cancel"
L["Cancel auctions with bids"] = "Cancel auctions with bids"
L["Cancel binding"] = "Cancel binding"
L["Canceling"] = "Canceling"
L["Cancelling interrupted due to Auction House being closed."] = "Cancelling interrupted due to Auction House being closed."
L["Cancelling |cfffed000%d|r of |cfffed000%d|r"] = "Cancelling |cfffed000%d|r of |cfffed000%d|r"
L["Cancels any posted auctions that you were undercut on."] = "Cancels any posted auctions that you were undercut on."
L["Cannot find class index. QA still needs to be localized into %s for this feature to work."] = "Cannot find class index. QA still needs to be localized into %s for this feature to work."
L["Cannot find data for %s."] = "Cannot find data for %s."
L["Cannot finish auto looting, inventory is full or too many unique items."] = "Cannot finish auto looting, inventory is full or too many unique items."
L["Click an item or group to add it to the list of items to be automatically mailed to %s."] = "Click an item or group to add it to the list of items to be automatically mailed to %s."
L["Click an item to add it to this group, you can only have one item in a group at any time."] = "Click an item to add it to this group, you can only have one item in a group at any time."
L["Click an item to remove it from this group."] = "Click an item to remove it from this group."
L[ [=[Click to buy materials required.

This might lock your client up for a few seconds.]=] ] = [=[Click to buy materials required.

This might lock your client up for a few seconds.]=]
L["Click to view Quick Auctions tradeskill queue"] = "Click to view Quick Auctions tradeskill queue"
L["Clicking an item or group will stop Quick Auctions from auto mailing it to %s."] = "Clicking an item or group will stop Quick Auctions from auto mailing it to %s."
L["Clicking this will cancel an auction."] = "Clicking this will cancel an auction."
L["Clicking this will post the auctions."] = "Clicking this will post the auctions."
L["Consumable"] = "Consumable"
L["Craft queue help"] = "Craft queue help"
L["Delete"] = "Delete"
L["Delete group"] = "Delete group"
L["Delete this group, this cannot be undone!"] = "Delete this group, this cannot be undone!"
L["Disable auto cancelling"] = "Disable auto cancelling"
L["Disable automatically cancelling of items in this group if undercut."] = "Disable automatically cancelling of items in this group if undercut."
L["Disables cancelling of auctions with a market price below the threshold, also will cancel auctions if you are the only one with that item up and you can relist it for more."] = "Disables cancelling of auctions with a market price below the threshold, also will cancel auctions if you are the only one with that item up and you can relist it for more."
L["Disabling auto mail, SHIFT key was down when opening the mail box."] = "Disabling auto mail, SHIFT key was down when opening the mail box."
L["Displays the Quick Auctions log describing what it's currently scanning, posting or cancelling."] = "Displays the Quick Auctions log describing what it's currently scanning, posting or cancelling."
L[ [=[Does a status scan that helps to identify auctions you can buyout to raise the price of a group your managing.

This will NOT automatically buy items for you, all it tells you is the lowest price and how many are posted.]=] ] = [=[Does a status scan that helps to identify auctions you can buyout to raise the price of a group your managing.

This will NOT automatically buy items for you, all it tells you is the lowest price and how many are posted.]=]
L["Elemental"] = "Elemental"
L["Elixir"] = "Elixir"
L["Elixirs"] = "Elixirs"
L["Enable auto fallback"] = "Enable auto fallback"
L["Enables Quick Auctions auto mailer, the last batch of mails will take ~10 seconds to send.|n|n[WARNING!] You will not get any confirmation before it starts to send mails, it is your own fault if you mistype your bankers name."] = "Enables Quick Auctions auto mailer, the last batch of mails will take ~10 seconds to send.|n|n[WARNING!] You will not get any confirmation before it starts to send mails, it is your own fault if you mistype your bankers name."
L["Enabling groups will cause them to be active and usable in this profile. If you disable them you will no longer see them in the configuration menu, and they will not be managed by Quick Auctions.|n|nFor all intents and purposes, they do not exist in Quick Auctions."] = "Enabling groups will cause them to be active and usable in this profile. If you disable them you will no longer see them in the configuration menu, and they will not be managed by Quick Auctions.|n|nFor all intents and purposes, they do not exist in Quick Auctions."
L["Enchant materials"] = "Enchant materials"
L["Enchant scrolls"] = "Enchant scrolls"
L["Enchanting"] = "Enchanting"
L["Fallback price"] = "Fallback price"
L["Fallbacks"] = "Fallbacks"
L["Finished cancelling |cfffed000%d|r auctions"] = "Finished cancelling |cfffed000%d|r auctions"
L["Finished posting |cfffed000%d|r items"] = "Finished posting |cfffed000%d|r items"
L["Finished status report"] = "Finished status report"
L["Flask"] = "Flask"
L["Flasks"] = "Flasks"
L["Food"] = "Food"
L["Food & Drink"] = "Food & Drink"
L["Gem"] = "Gem"
L["Gems"] = "Gems"
L["General"] = "General"
L["Get Data"] = "Get Data"
L["Glyph"] = "Glyph"
L["Glyphs"] = "Glyphs"
L["Group name"] = "Group name"
L["Group named \"%s\" already exists!"] = "Group named \"%s\" already exists!"
L["Group status"] = "Group status"
L["Groups"] = "Groups"
L["Help"] = "Help"
L["Herb"] = "Herb"
L["Herbs"] = "Herbs"
L["Hide help text"] = "Hide help text"
L["Hide uncraftables"] = "Hide uncraftables"
L["Hides auction setting help text throughout the group settings options."] = "Hides auction setting help text throughout the group settings options."
L["How long auctions should be up for."] = "How long auctions should be up for."
L["How low the market can go before an item should no longer be posted."] = "How low the market can go before an item should no longer be posted."
L["How many auctions at the lowest price tier can be up at any one time."] = "How many auctions at the lowest price tier can be up at any one time."
L["How many items should be in a single auction, 20 will mean they are posted in stacks of 20."] = "How many items should be in a single auction, 20 will mean they are posted in stacks of 20."
L["How many seconds until the mailbox will retrieve new data and you can continue looting mail."] = "How many seconds until the mailbox will retrieve new data and you can continue looting mail."
L[ [=[How much of a difference between auction prices should be allowed before posting at the second highest value.

For example. If Apple is posting Runed Scarlet Ruby at 50g, Orange posts one at 30g and you post one at 29g, then Oranges expires. If you set price threshold to 30% then it will cancel yours at 29g and post it at 49g next time because the difference in price is 42% and above the allowed threshold.]=] ] = [=[How much of a difference between auction prices should be allowed before posting at the second highest value.

For example. If Apple is posting Runed Scarlet Ruby at 50g, Orange posts one at 30g and you post one at 29g, then Oranges expires. If you set price threshold to 30% then it will cancel yours at 29g and post it at 49g next time because the difference in price is 42% and above the allowed threshold.]=]
L["How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."] = "How much to undercut other auctions by, format is in \"#g#s#c\" but can be in any order, \"50g30s\" means 50 gold, 30 silver and so on."
L[ [=[If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.

Effective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g.]=] ] = [=[If the market price is above fallback price * maximum price, items will be posted at the fallback * maximum price instead.

Effective for posting prices in a sane price range when someone is posting an item at 5000g when it only goes for 100g.]=]
L["Ignore stacks over"] = "Ignore stacks over"
L["Invalid monney format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."] = "Invalid monney format entered, should be \"#g#s#c\", \"25g4s50c\" is 25 gold, 4 silver, 50 copper."
L["Item Enhancement"] = "Item Enhancement"
L["Item groups"] = "Item groups"
L["Item list"] = "Item list"
L["Items"] = "Items"
L["Items that are stacked beyond the set amount are ignored when calculating the lowest market price."] = "Items that are stacked beyond the set amount are ignored when calculating the lowest market price."
L["Log"] = "Log"
L["Log (%d)"] = "Log (%d)"
L["Management"] = "Management"
L["Mass add"] = "Mass add"
L["Mass adds all items matching the below, entering \"Glyph of\" will mass add all items starting with \"Glyph of\" to this group."] = "Mass adds all items matching the below, entering \"Glyph of\" will mass add all items starting with \"Glyph of\" to this group."
L["Mass mailing"] = "Mass mailing"
L["Materials required"] = "Materials required"
L["Maximum price gap"] = "Maximum price gap"
L["Maxmimum price"] = "Maxmimum price"
L["Name of the new group, this can be whatever you want and has no relation to how the group itself functions."] = "Name of the new group, this can be whatever you want and has no relation to how the group itself functions."
L["New group name"] = "New group name"
L["No auctions or inventory items found that are managed by Quick Auctions that can be scanned."] = "No auctions or inventory items found that are managed by Quick Auctions that can be scanned."
L["No auctions posted"] = "No auctions posted"
L["No items have been added to this group yet."] = "No items have been added to this group yet."
L["No name entered."] = "No name entered."
L["No player name entered."] = "No player name entered."
L["None posted by yourself"] = "None posted by yourself"
L["Nothing to cancel"] = "Nothing to cancel"
L["Nothing to cancel, you have no unsold auctions up."] = "Nothing to cancel, you have no unsold auctions up."
L["Ok"] = "Ok"
L["Once market goes below %s/per item, auctions will be automatically posted at the fallback price of %s/per item."] = "Once market goes below %s/per item, auctions will be automatically posted at the fallback price of %s/per item."
L["Open all"] = "Open all"
L["Opening..."] = "Opening..."
L["Override auto fallback"] = "Override auto fallback"
L["Override bid percent"] = "Override bid percent"
L["Override cancel settings"] = "Override cancel settings"
L["Override fallback"] = "Override fallback"
L["Override max price"] = "Override max price"
L["Override per auction"] = "Override per auction"
L["Override post cap"] = "Override post cap"
L["Override post time"] = "Override post time"
L["Override price gap"] = "Override price gap"
L["Override stack settings"] = "Override stack settings"
L["Override threshold"] = "Override threshold"
L["Override undercut"] = "Override undercut"
L["Per auction"] = "Per auction"
L["Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."] = "Percentage of the buyout as bid, if you set this to 90% then a 100g buyout will have a 90g bid."
L["Perfect (.+)"] = "Perfect (.+)"
L["Play sound after scan"] = "Play sound after scan"
L["Player \"%s\" is already a mail target."] = "Player \"%s\" is already a mail target."
L["Player name"] = "Player name"
L["Post"] = "Post"
L["Post binding"] = "Post binding"
L["Post cap"] = "Post cap"
L["Post items from your inventory into the auction house."] = "Post items from your inventory into the auction house."
L["Post time"] = "Post time"
L["Posting"] = "Posting"
L["Posting %s x %d (%d times)"] = "Posting %s x %d (%d times)"
L["Posting %s%s (%d) bid %s, buyout %s"] = "Posting %s%s (%d) bid %s, buyout %s"
L["Posting %s%s (%d) bid %s, buyout %s (Buyout went below zero, undercut by 1 copper instead)"] = "Posting %s%s (%d) bid %s, buyout %s (Buyout went below zero, undercut by 1 copper instead)"
L["Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, lowest price was too high)"] = "Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, lowest price was too high)"
L["Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, market below threshold)"] = "Posting %s%s (%d) bid %s, buyout %s (Forced to fallback price, market below threshold)"
L["Posting %s%s (%d) bid %s, buyout %s (Increased bid price due to going below thresold)"] = "Posting %s%s (%d) bid %s, buyout %s (Increased bid price due to going below thresold)"
L["Posting %s%s (%d) bid %s, buyout %s (Increased buyout price due to going below thresold)"] = "Posting %s%s (%d) bid %s, buyout %s (Increased buyout price due to going below thresold)"
L["Posting %s%s (%d) bid %s, buyout %s (No other auctions up)"] = "Posting %s%s (%d) bid %s, buyout %s (No other auctions up)"
L["Posting %s%s (%d) bid %s, buyout %s (Price difference too high, used second lowest price intead)"] = "Posting %s%s (%d) bid %s, buyout %s (Price difference too high, used second lowest price intead)"
L["Posting auctions for |cfffed000%d|r hours, ignoring auctions with more than |cfffed000%d|r items in them, but will not cancel auctions even if undercut."] = "Posting auctions for |cfffed000%d|r hours, ignoring auctions with more than |cfffed000%d|r items in them, but will not cancel auctions even if undercut."
L["Posting auctions for |cfffed000%d|r hours, ignoring auctions with more than |cfffed000%d|r items in them."] = "Posting auctions for |cfffed000%d|r hours, ignoring auctions with more than |cfffed000%d|r items in them."
L["Preload groups"] = "Preload groups"
L["Price"] = "Price"
L["Price threshold"] = "Price threshold"
L["Price threshold on %s at %s, second lowest is |cfffed000%d%%|r higher and above the |cfffed000%d%%|r threshold, cancelling"] = "Price threshold on %s at %s, second lowest is |cfffed000%d%%|r higher and above the |cfffed000%d%%|r threshold, cancelling"
L["Price to fallback too if there are no other auctions up, the lowest market price is too high."] = "Price to fallback too if there are no other auctions up, the lowest market price is too high."
L["Quantities"] = "Quantities"
L["Queued %s to be posted"] = "Queued %s to be posted"
L["Queued %s to be posted (Cap is |cffff2020%d|r, only can post |cffff2020%d|r need to restock)"] = "Queued %s to be posted (Cap is |cffff2020%d|r, only can post |cffff2020%d|r need to restock)"
L["Quick Auctions"] = "Quick Auctions"
L[ [=[Quick binding you can press to cancel auctions once scan has finished.

This can be any key including space without overwriting your jump key.]=] ] = [=[Quick binding you can press to cancel auctions once scan has finished.

This can be any key including space without overwriting your jump key.]=]
L[ [=[Quick binding you can press to post options.

This can be any key including space without overwriting your jump key.]=] ] = [=[Quick binding you can press to post options.

This can be any key including space without overwriting your jump key.]=]
L[ [=[Read me, important information below!

As of 3.3 Blizzard requires that you use a hardware event (key press or mouse click) to cancel auctions, currently there is a loophole that allows you to get around this by letting you cancel as many auctions as you need for one hardware event.]=] ] = [=[Read me, important information below!

As of 3.3 Blizzard requires that you use a hardware event (key press or mouse click) to cancel auctions, currently there is a loophole that allows you to get around this by letting you cancel as many auctions as you need for one hardware event.]=]
L["Ready to cancel an auction, press \"Cancel\"."] = "Ready to cancel an auction, press \"Cancel\"."
L["Remove items"] = "Remove items"
L["Remove items/groups"] = "Remove items/groups"
L["Rename"] = "Rename"
L["Rename this group to something else!"] = "Rename this group to something else!"
L["Reset craft queue"] = "Reset craft queue"
L["Reset the craft queue list for every item."] = "Reset the craft queue list for every item."
L["Retry |cfffed000%d|r of |cfffed000%d|r for %s"] = "Retry |cfffed000%d|r of |cfffed000%d|r for %s"
L["Scan finished!"] = "Scan finished!"
L["Scan interrupted before it could finish"] = "Scan interrupted before it could finish"
L["Scan interrupted due to Auction House being closed."] = "Scan interrupted due to Auction House being closed."
L["Scanned page |cfffed000%d|r of |cfffed000%d|r for %s"] = "Scanned page |cfffed000%d|r of |cfffed000%d|r for %s"
L["Scanning %s"] = "Scanning %s"
L["Scanning page |cfffed000%d|r of |cfffed000%d|r for %s"] = "Scanning page |cfffed000%d|r of |cfffed000%d|r for %s"
L["Scanning |cfffed000%d|r items..."] = "Scanning |cfffed000%d|r items..."
L["Scroll of (.+)"] = "Scroll of (.+)"
L["Scroll of Enchant (.+)"] = "Scroll of Enchant (.+)"
L["Scroll of Enchant (.+) %- .+"] = "Scroll of Enchant (.+) %- .+"
L["Show craft queue"] = "Show craft queue"
L["Show uncraftables"] = "Show uncraftables"
L["Shows information on how to use the craft queue"] = "Shows information on how to use the craft queue"
L["Simple"] = "Simple"
L["Skipped %s lowest buyout is %s threshold is %s"] = "Skipped %s lowest buyout is %s threshold is %s"
L["Skipped %s need |cff20ff20%d|r for a single post, have |cffff2020%d|r"] = "Skipped %s need |cff20ff20%d|r for a single post, have |cffff2020%d|r"
L["Skipped %s posted |cff20ff20%d|r of |cff20ff20%d|r already"] = "Skipped %s posted |cff20ff20%d|r of |cff20ff20%d|r already"
L["Skipped cancelling %s flagged to not be cancelled."] = "Skipped cancelling %s flagged to not be cancelled."
L["Skipped cancelling %s flagged to post at fallback when market is below threshold."] = "Skipped cancelling %s flagged to post at fallback when market is below threshold."
L["Slash commands"] = "Slash commands"
L["Smart cancelling"] = "Smart cancelling"
L["Starting to cancel..."] = "Starting to cancel..."
L["Status"] = "Status"
L["Stop"] = "Stop"
L["Summary"] = "Summary"
L["Super scan is enabled, you will not be able to use your whitelist. Disable super scanner to use the whitelist again."] = "Super scan is enabled, you will not be able to use your whitelist. Disable super scanner to use the whitelist again."
L[ [=[The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.

Warning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g.]=] ] = [=[The below are fallback settings for groups, if you do not override a setting in a group then it will use the settings below.

Warning! All auction prices are per item, not overall. If you set it to post at a fallback of 1g and you post in stacks of 20 that means the fallback will be 20g.]=]
L[ [=[The craft queue in Quick Auctions is a way of letting you queue up a list of items that can then be seen in that professions Tradeskill window, or through /qa tradeskill with a tradeskill open.

|cffff2020**NOTE**|r This does not work with the enchant scroll category.
Queues are setup through the summary window by holding SHIFT + double clicking an item in the summary.

For example: If you want to cut 20 |cff0070dd[Insightful Earthsiege Diamond]|r you SHIFT + double click the |cff0070dd[Insightful Earthsiege Diamond]|r text in the summary window, it will then show

|cfffed0000 x|r Insightful Earthsiege Diamond|r

This tells you that it is ready and you can input how many you want, once you are done setting how many you want to make hit ENTER. If you were to enter 20 it will now look like

0 x |cff20ff202Insightful Earthsiege Diamond|r
And you're done! Once you open the Jewelcrafting Tradeskill window you will see a frame pop up with

|cff0070dd[Insightful Earthsiege Diamond]|r [20]

If you click that text you will create 20 |cff0070dd[Insightful Earthsiege Diamond]|r providing you have the materials]=] ] = [=[The craft queue in Quick Auctions is a way of letting you queue up a list of items that can then be seen in that professions Tradeskill window, or through /qa tradeskill with a tradeskill open.

|cffff2020**NOTE**|r This does not work with the enchant scroll category.
Queues are setup through the summary window by holding SHIFT + double clicking an item in the summary.

For example: If you want to cut 20 |cff0070dd[Insightful Earthsiege Diamond]|r you SHIFT + double click the |cff0070dd[Insightful Earthsiege Diamond]|r text in the summary window, it will then show

|cfffed0000 x|r Insightful Earthsiege Diamond|r

This tells you that it is ready and you can input how many you want, once you are done setting how many you want to make hit ENTER. If you were to enter 20 it will now look like

0 x |cff20ff202Insightful Earthsiege Diamond|r
And you're done! Once you open the Jewelcrafting Tradeskill window you will see a frame pop up with

|cff0070dd[Insightful Earthsiege Diamond]|r [20]

If you click that text you will create 20 |cff0070dd[Insightful Earthsiege Diamond]|r providing you have the materials]=]
L["The player \"%s\" is already on your whitelist."] = "The player \"%s\" is already on your whitelist."
L[ [=[This is a new info panel that will pop up when something changed in Quick Auctions that you should know, these messages will only show up once.

Settings have been moved around to work better with profiles, groups and all misc smart cancel/etc settings are now global, while per-group settings are per profile.
You can change your profile depending on server or how aggressive you want to be without losing your general settings or your group through /quickauctions.

Because of the move in scope, general settings were reset, as well as auto mailing settings. Make sure you reconfigure them!]=] ] = [=[This is a new info panel that will pop up when something changed in Quick Auctions that you should know, these messages will only show up once.

Settings have been moved around to work better with profiles, groups and all misc smart cancel/etc settings are now global, while per-group settings are per profile.
You can change your profile depending on server or how aggressive you want to be without losing your general settings or your group through /quickauctions.

Because of the move in scope, general settings were reset, as well as auto mailing settings. Make sure you reconfigure them!]=]
L["Toggles hiding items you cannot craft in the summary window."] = "Toggles hiding items you cannot craft in the summary window."
L["Toggles the craft queue window"] = "Toggles the craft queue window"
L["Trade Goods"] = "Trade Goods"
L["Undercut by"] = "Undercut by"
L["Undercut on %s by |cfffed000%s|r, but %s placed a bid of %s so not cancelling"] = "Undercut on %s by |cfffed000%s|r, but %s placed a bid of %s so not cancelling"
L["Undercut on %s by |cfffed000%s|r, buyout %s, yours %s (per item)"] = "Undercut on %s by |cfffed000%s|r, buyout %s, yours %s (per item)"
L["Undercut on %s by |cfffed000%s|r, their buyout %s, yours %s (per item), threshold is %s not cancelling"] = "Undercut on %s by |cfffed000%s|r, their buyout %s, yours %s (per item), threshold is %s not cancelling"
L["Undercutting auctions by %s/per item until price goes below %s/per item, unless there is greater than a |cfffed000%.2f%%|r price difference between lowest and second lowest in which case undercutting second lowest auction."] = "Undercutting auctions by %s/per item until price goes below %s/per item, unless there is greater than a |cfffed000%.2f%%|r price difference between lowest and second lowest in which case undercutting second lowest auction."
L["View a summary of what the highest selling of certain items is."] = "View a summary of what the highest selling of certain items is."
L["Waiting..."] = "Waiting..."
L["When no auctions are up, or the market price is above %s/per item auctions will be posted at the fallback price of %s/per item."] = "When no auctions are up, or the market price is above %s/per item auctions will be posted at the fallback price of %s/per item."
L["When the market price of an item goes below your threshold settings, it will be posted at the fallback setting instead."] = "When the market price of an item goes below your threshold settings, it will be posted at the fallback setting instead."
L["Whitelist"] = "Whitelist"
L["Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."] = "Whitelists allow you to set other players besides you and your alts that you do not want to undercut; however, if somebody on your whitelist matches your buyout but lists a lower bid it will still consider them undercutting."
L["Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."] = "Will cancel auctions even if they have a bid on them, you will take an additional gold cost if you cancel an auction with bid."
L["Will post at most |cfffed000%d|r auctions in stacks of |cfffed000%d|r."] = "Will post at most |cfffed000%d|r auctions in stacks of |cfffed000%d|r."
L["You are at the gold cap and cannot loot gold from the mailbox."] = "You are at the gold cap and cannot loot gold from the mailbox."
L["You are the only one posting %s, the fallback is %s (per item), cancelling so you can relist it for more gold"] = "You are the only one posting %s, the fallback is %s (per item), cancelling so you can relist it for more gold"
L["You do not have any items to add to this group, either your inventory is empty or all the items are already in another group."] = "You do not have any items to add to this group, either your inventory is empty or all the items are already in another group."
L["You do not have any items to post"] = "You do not have any items to post"
L["You do not have any players on your whitelist yet."] = "You do not have any players on your whitelist yet."
L["You do not need to add \"%s\", alts are whitelisted automatically."] = "You do not need to add \"%s\", alts are whitelisted automatically."
L["hours"] = "hours"
L["lowest price"] = "lowest price"
L["minutes"] = "minutes"
L["seconds"] = "seconds"
L["undercut"] = "undercut"


QuickAuctions.L = L
--[===[@debug@
QuickAuctions.L = setmetatable(QuickAuctions.L, {
	__index = function(tbl, value)
		rawset(tbl, value, value)
		return value
	end,
})
--@end-debug@]===]
