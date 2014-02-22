{\rtf1\ansi\ansicpg1252\cocoartf949\cocoasubrtf540
{\fonttbl\f0\fswiss\fcharset0 ArialMT;}
{\colortbl;\red255\green255\blue255;}
\vieww12000\viewh15840\viewkind0
\deftab720
\pard\pardeftab720\ql\qnatural

\f0\fs24 \cf0 -Coming Soon: Version 2.5-\
* Minimap Icon.\
* Better quest icons.\
-- Repeatable quests that can be accepted into the player's quest log will display a normal blue '!' quest icon.\
-- Repeatable quests that can only be completed (quest turn-ins) will display a blue '?' quest icon.\
* Complete code revamp.\
--The addon will be slightly faster and A LOT less prone to bugs.\
-- Better organization means that I can hopefully come out with new features more often.\
* Better plug and play ability with other addons.\
--There are a few addons that just happen to work with AutoQuest 2. (QuestRewards). But there are other addons that haven't been designed to work very well together.\
--I plan on eventually adding Bazooka support and stuff like that once I can better organize the addon files.\
* Maybe some other stuff I can think of later.\
\
-AutoQuest 2 Version 2.12-\
--Description--\
This addon is designed to speed up the process of Accepting and Turning In Quests. It might not sound like such a huge pain in the you-know-what, since you're most likely used to clicking through all the useless quest panels, but it can be a huge time saver when binge questing.\
The addon works a lot like the Auto Loot Function built in to World of Warcraft. Available quests are automatically Accepted and Completed Quests are automatically Turned In.\
\
--Features--\
Unlike other addons that simply select the quests without any user feedback, I designed this addon to be intelligent and user friendly.\
* Quest Feedback\
-- When Quests are Accepted, Quest Objectives can be displayed in the Quest Frame, as Chat Text, or Disabled to Accept Quests Silently.\
* Quest Sharing\
-- Accepted Quests can be automatically shared with other party members. The addon isn't required for other players to receive the shared quests, but they do if they want to automatically Accept them. Feel free to share this information with other players questing with you.\
* Quest Types\
-- Repeatable and Trade-In Quests, such as Cloth Turn-Ins ("A Donation of Wool"), are Ignored by Default. When this function is Enabled, the Quest will only be Completed if the player has the appropriate items. Otherwise, it will not be selected.\
-- Low Level Quests are Disabled by Default and are normally skipped over. When Enabled, Normal Level Quests have priority over Low Level Quests. Otherwise, they are Accepted.\
-- Shared Quests are automatically Accepted by Default, but this can be Disabled if the player desides they don't want their quest logs fillled with "Wanted: Hogger" quests :P\
* Quest Blacklist\
-- Quests that players probably don't want Turned In, such as Quests that switch profession specializations or factions are  Ignored and won't be Accepted or Turned In.\
* Descriptive Quest Icons and Text\
-- Quests that were ignored, such as Repeatable Quests that can't be completed, display blue '!' icons and (repeatable). Blacklisted Quests display a black '!' and (disabled). This allows the player to see why a quest was ignored without having to click on it.\
\
-- Usage --\
* Accepting Quests\
-- To automatically Accept quests, speak to a Questgiver. If the NPC has available quests that the player can accept, your quest will immediately appear in your quest log. This Function can be Disabled by Unchecking the 'Automatically Accept Quests' box in the Interface Options Panel or by typing '/autoquest2 accept' in the chat frame.\
* Turning In Quests\
-- To automatically Turn In a Completed quest, speak to a Questgiver as you normally would. If the Active Quest you're Turning In has more than one selectable reward, the Default Quest Frame will show and allow you to choose a reward. After the Quest is Completed, and following Available Quests will be automatically Accepted (If the Automatically Accept Quest option is Enabled).\
This Function can be Disabled by Unchecking 'Automatically Turn In Quests' in the Option Interface Panel or by typing '/autoquest2 complete' in the chat frame.\
* Sharing Quests\
-- Automatic Quest Sharing is Disabled by Default since no all players will be aware of this function at first. Feel free to Enable this if you wish to automatically Share Accepted Quests will other party members. Note: Other players do not need AutoQuest 2 installed to receive Shared Quests, but is is recommended if they want to automatically Accept them.\
* Overriding Options\
-- The Override Modifier Keys effectively do the opposite as the set user option. If an option is Enabled, the override key will temporarily Disabled the option, and visa versa.\
-- To temporarily override the automatically Accept and Turn In Quests option, press and hold the 'Shift' key when speaking to a Questgiver to display the Default Quest Panel.\
-- To temporarily override the Trivial Quests option, press and hold the 'Ctrl' key when speaking to a Questgiver.\
-- To temporarilly override the Repeatable Quests option, press and hold the 'Alt' key when speaking to a Questgiver.\
* Changing Options\
--Changing options can be accomplished in two ways. The first being the Interface Options Panel. This panel uses checkboxes to Enable and Disable options. When the checkbox is checked, that option or function is Enabled.\
The second way of changing options is by using Slash Commands. To change an option, type '/autoquest2' followed by the option name '/autoquest2 option' to toggle the option. Typing '/autoquest2' alone will show the Interface Options Panel.\
* Managing Profiles\
-- User Profiles can be changed by clicking on the 'Profiles' tab on the left of the Interface Options Panel. Here you can change how Options are saved. You can either use separate profiles for each character, realm, class, or default profile for every character.\
\
-- Slash Commands\
'/autoquest2' '/autoquest' '/aq2' '/aq\
'/aq Enable' Enables the addon. Type '/aq' to show configuraton.\
'/aq Disable' Disables the entire addon, Including modifier keys.\
'/aq Accept' toggles automatic accepting for quests.\
'/aq Complete' toggles automatic turning in quests.\
'/aq Trivial' toggles filtering low level quests.\
'/aq Repeatable' toggles filtering repeatable quests.\
\
-- Default Settings --\
-- Automatically Accept Quests: Enabled\
-- Automatically Turn In Quests: Enabled\
* Quest Types\
-- Shared Quests: Enabled\
-- Trivial Quests: Disabled\
-- Repeatable Quests: Disabled\
* Override Keys\
-- Accept: Shift\
-- Turn In: Shift\
-- Trivial: Ctrl\
-- Repeatable: Alt\
* Display\
-- Quest Objectives: Quest Frame\
-- Auto Toggle Trivial Quests: Enabled\
}