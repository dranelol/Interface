Pirate Speak v2.2.1
maintained by Imyself<Savvy> - Echo Isles
www.savvyguild.com
Original code by Blaquen

2.2.1 10/11/2010
Updated TOC
Minor fixes for 4.0 compatability

2.2.0 09/15/2010
Updated TOC
Moved the English to Pirate translation tables to an account level saved variable. This is the first step towards allowing users to create their own translations. The translation table saved variable will be located in your World of Warcraft directory under:  WTF\Account\accountname\SavedVariables\PirateSpeak.lua  If you are feeling brave and adventurous, you can edit the values in this file to modify existing translations or create new ones. If you screw something up, just log off, delete this file and a clean copy will be created the next time you log on. 

2.1.0 09/24/2009
Updated TOC
Added several new english to pirate translations.
Fixed a bug that was introduced in 2.0 where pirate speak only worked in guild chat, whisper, say, party and raid channels. Pirate speak will once again let you make a fool of yourself in general chat.

2.0.0 07/12/2009
Added LibDataBroker support: Pirate Speak can be managed via a LDB Display addon such as Fortress, ChocolateBar, DockingStation, etc. Left clicking on the LDB display toggles Pirate Speak on and off. Right clicking toggles strict mode on and off (see next paragraph). Mouse-over the LBD display shows a tool-tip with the current status.

Added new command: /pstrict:  This command toggles between the normal verbose mode of Pirate Speak and a new strict mode. By default, Pirate Speak may append, prepend or inject additional phrases to the original text. This results in a simple chat message like "How are you doing Bob?" becoming something like: "Skink me! How ye doin', yarr, Bob? Arrr!". By enabling strict mode, "How are you doing Bob?" would become "How ye doin' Bob?" The superfluous appends, prepends and injected phrases are suppressed. 

Resolved a compatibility issue with Wintertime where Pirate Speak would interact with Wintertime's chat channel causing repeated error messages. 

1.5.0 05/29/2009
Updated TOC

1.4.1 09/19/2008
Minor fix to add 2.0 compatability. Full credit for this update goes to Blaquen
for the original version, and to Kaboom @ Arthas of the German Edition for the 2.0 compatability code.


---------------------------------

Pirate Speak v1.3
by Blaquen - Horde - Black Dragonflight
lkraven@gmail.com

---------------------------------

WHAT IS IT?

Pirate Speak is a WoW UI Mod that will-- wait for it-- wait for it-- make you talk like a Pirate.

USAGE:

/pspeak [on/off] 
toggles it on and off.  Remembered per character.

/pspeak 
by itself will show you the command line help in game

