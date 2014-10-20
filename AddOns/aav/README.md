AAV - Atrox Arena Viewer
===

**AAV** is an arena replay addon, that lets you record or even broadcast arena matches. These arena matches can be viewed within WoW, while doing your daily quests, raids or just idling in Dalaran. It's optimized to run in very good-performance.

If you ever wanted to analyze your arena matches, why you died on that particular time on that particular match against that particular game and what skill could have been used, then AAV is a gem for you! Or if you want to follow your guildmates while they're doing arena, just hop in to their broadcast and watch their play.

Features
---
* record, replay, delete arena matches
* broadcast arena matches to guild mates
* see used skills
* casting bar
* cooldown bar
* interrupts (school locks)
* target system
* health and mana tracking
* change game speed in replay
* minimap icon menu
* match statistics (damage/healing done, ratings)

Limitation
---
**AAV** is like a graphical and interactive combatlog, that parses every action in the arena. However, it's not possible to keep track of the positionings. Who knows, maybe Blizzard opens up their API to make coordination gathering available in arena; this would make AAV more workable.

Slash Commands
---
* **/play [number]** - plays a given match.
* **/delete [number]** - deletes a give match.
* **/record** - whether a match will be recorded.
* **/broadcast** - enable/disable broadcasting.
* **/lookup** - lists all available broadcasts.
* **/connect [name]** - connects to the broadcast with the given name.

Known Bugs
---
* crowd control timers overlap with existing timers (good visible by Heroism)
* in rare cases stealth classes are not visible at all
* during broadcasting the icon and healthbar of combatants may switch places in rare cases and the buff and debuf bar doesn't fit

FAQ
---
**How much Memory does the addon use?**

The addon is optimized for high-performance and as few memory usage as possible. Due to these requirements the player uses in play less than 1 MB memory. An average match takes up from 60 ~ 180kb, depends on heavy usage of spells and events (warlocks and resto druids do their job pretty well!). Matches can be deleted to free memory if needed.

**Does it hurt my FPS rate?**

Not at all. From the stated requirements in the first question the addon is designed for high-performance and you won't notice any FPS loss.

**Does my ping increase while broadcasting?**

Not at all as well. The sent data is small and won't delay your latency. Additionally a sending mechanism takes care of the sending behaviour so you will never burst in sending data.

**Isn't it possible to disconnect when sending too much data?**

Yes, it is possible, but in AAV a sending mechanism takes care of all outgoing data. Rather sending all data at once, it apportions the big load of data over a certain time, that prevents from being disconnected.

**Where is the match data stored to?**

World of Warcraft\WTF\<your account>\SavedVariables\aav.lua

**I don't record/broadcast any combat events anymore, only Healthbar and Mana changes, why?**

This happens when your combat log and any addons that use the COMBAT_LOG_EVENT_UNFILTERED event (like AAV or afflicted) get screwed up due to massive glitched spam (courtesy of Blizzard). If you're familiar with the /run CombatLogClearEntries() command, that's being fired on every frame update, then you should be fine. Otherwise type /run ReloadUI() or relog will solve this problem. The incomplete match data that have been recorded under the bug cannot be fixed to show other events than Health's or Mana's.

**The damage in the score board doesn't match with my recount's, why?**

In the current version pets are completely disabled, means, their damage and contribution doesn't count yet.
