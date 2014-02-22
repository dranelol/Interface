local L = LibStub("AceLocale-3.0"):NewLocale("Rebirther", "enUS", true)
if (L) then

	--[[
	-- Spells
	L["Innervate"] = "Innervate"
	L["Rebirth"] = "Rebirth"
	L["RaiseAlly"] = "Raise Ally"
	L["Soulstone"] = "Soulstone"
	L["Redemption"] = "Redemption"
	L["Resurrection"] = "Resurrection"
	L["Revive"] = "Revive"
	L["Ancestral Spirit"] = "Ancestral Spirit"
	L["Mana Tide"] = "Mana Tide"
	L["Hymn of Hope"] = "Hymn of Hope"
	L["Reincarnation"] = "Reincarnation"
	]]
	L["Res"] = "Res"
	L["Mana"] = "Mana"
	-- windows
	--L["Rebirths"] = "Rebirths"
	--L["Innervates"] = "Innervates"
	L["Battle Resses"] = "Battle Rezzes"
	L["Mana CDs"] = "Mana CDs"

	-- Statuses
	L["Ready"] = "Ready"
	L["Dead"] = "Dead"
	L["Offline"] = "Offline"

	-- Classes
	L["Death Knight"] = "Death Knight"
	L["Druid"] = "Druid"
	L["Priest"] = "Priest"
	L["Shaman"] = "Shaman"
	L["Warlock"] = "Warlock"

	-- Announcements
	-- Requests
	L["Request Hymn of Hope"] = "Use your Hymn of Hope please!"
	L["Request Mana Tide"] = "Drop your Mana Tide Totem please!"
	L["Innervate me!"] = "Innervate me please!"
	L["Res me!"] = "Res me please!"
	L["Your turn to res!"] = "Your turn to res!"
	L["Combat res %t!"] = function (target)
		return "Combat res >>> "..target.." <<<"
	end
	-- Chat frame
	L["X innervated Y"] = function (source, target)
		return source.." innervated "..target
	end
	L["X ressed Y"] = function (source, target)
		return source.." ressed "..target
	end
	L["X is ressing"] = function (source)
		return source.." is ressing!"
	end
	L["X is soulstoned"] = function (target)
		return target.." is soulstoned"
	end
	L["X is ressing"] = function(source)
		return source.." is combat ressing!"
	end
	L["X is ressing Y"] = function(source, target)
		if ( target ) then
			return source.." is ressing "..target.."!"
		else
			return source.." is ressing!"
		end
	end
	L["X mana tide"] = function (source)
		return source.." dropped a Mana Tide Totem"
	end
	L["X hymn of hope"] = function (source)
		return source.." used Hymn of Hope"
	end

	-- Options
	L["Version"] = "Version"
	L["Enable"] = "Enable"
	L["EnablesDesc"] = "Enables / disables this addon"
	L["Test Mode"] = "Test Mode"
	L["Test ModeDesc"] = "Enter a test mode with simulated bars"
	L["Debug Mode"] = "Debug Mode"
	L["Debug ModeDesc"] = "Enter Addon Debug"

		-- Slash commands
		L["Check Group"] = "Check Group"
		L["Check GroupUsage"] = "/rbr Check Group"
		L["Check GroupDesc"] = "Forces a group check (use if you see druids no longer in your group"
		L["Request Res"] = "Request Res"
		L["requestresusage"] = "requestres <name> - where <name> is the name of a dead player in your raid"
		L["requestresdesc"] = "Requests a combat res on <name> from a druid with one available"
		L["requestinnervatedesc"] = "Requests an innervate on yourself from a druid with one available"

		-- General
		L["General"] = "General"
		L["GeneralDesc"] = "Configure general settings"
		L["Show..."] = "Show..."
		--L["Show"] = "Show"
		--L["ShowDesc"] = "Shows / hides this element"
		L["ShowTarget"] = "Targets"
		L["ShowTargetDesc"] = "Shows / hides target's name in timer bars"
		L["Show server name"] = "Server names"
		L["Show server nameDesc"] = "Shows a player's realm in his name if applicable"
		L["Show extra"] = "Druids in all groups"
		L["Show extraDesc"] = "Shows / hides druids in group 6-8 or 3-8 depending on the dungeon difficulty"
		L["Show Rebirth Window"] = "Battle Resses Window"
		L["Show Rebirth WindowDesc"] = "Shows / hides the Battle Resses Window"
		L["Show Innervate Window"] = "Mana CDs Window"
		L["Show Innervate WindowDesc"] = "Shows / hides the Mana CDs Window"
		L["ShowIcon"] = "Icons"
		L["ShowIconDesc"] = "Shows / hides window icons"
		L["Sync"] = "Sync"
		L["SyncDesc"] = "Synchronize with other people using the addon"
		L["Verbose"] = "Verbose"
		L["VerboseDesc"] = "Enables / disables notifications in the chat frame about Rebirths and Innervates being cast"
		L["Miscellaneous"] = "Miscellaneous"
		L["Lock"] = "Lock"
		L["LockDesc"] = "Locks / unlocks moving of windows"
		L["Scale"] = "Scale"
		L["ScaleDesc"] = "Configure how much this addon should scale"
		L["Background Colour"] = "Background Colour"
		L["Background ColourDesc"] = "Colour of the windows' background"
		L["Show Specs"] = "Show mana cooldowns from"
		L["InBalance"] = "Balance"
		L["InBalanceDesc"] = "Show Innervates from druids specialised in the Balance talent tree"
		L["InFeral"] = "Feral"
		L["InFeralDesc"] = "Show Innervates from druids specialised in the Feral talent tree"
		L["InResto"] = "Restoration"
		L["InRestoDesc"] = "Show Innervates from druids specialised in the Restoration talent tree"
		L["InShaman"] = "Shaman"
		L["InShamanDesc"] = "Show Mana Tide Totems from Shamans specialised in the Restoration talent tree"
		L["InPriest"] = "Priest"
		L["InPriestDesc"] = "Show Hymn of Hopes from Priests"
		L["Guess"] = "Guess ghost's name from"
		L["GuessDesc"] = "When ressing a player who's released his ghost you need to guess his name if you want to announce your res."

		--L["Windows"] = "Windows"
		--L["WindowsDesc"] = "Configure the Rebirth and Innverate windows"

		-- Show when...
		L["Show when..."] = "Show when..."
		L["Show when...Desc"] = "Configure when to show this addon"
		L["Auto show"] = "Use Auto Show / Hide"
		L["Auto showDesc"] = "Shows / hides this addon automatically"
		L["ShowInBG"] = "in a Battleground"
		L["ShowInBGDesc"] = "Shows this addon when you enter a battleground"
		L["ShowInRaid"] = "in a Raid"
		L["ShowInRaidDesc"] = "Shows this addon when you enter a raid"
		L["ShowInParty"] = "in a Party"
		L["ShowInPartyDesc"] = "Shows this addon when you enter a party"
		L["ShowWhenSolo"] = "you are solo"
		L["ShowWhenSoloDesc"] = "Shows this addon when you are on your own"

		-- Announce when...
		L["Announcements"] = "Announcements"
		L["AnnouncementsDesc"] = "Configure when to announce your spell casting"
		L["Announce to..."] = "Announce to your..."
		L["Announce when..."] = "Announce when casting..."
		L["AnnounceToBG"] = "Battlegroup"
		L["AnnounceToBGDesc"] = "Announce to your Battleground's group"
		L["AnnounceToRaid"] = "Raid"
		L["AnnounceToRaidDesc"] = "Announce to your Raid"
		L["AnnounceToParty"] = "Party"
		L["AnnounceToPartyDesc"] = "Announce to your Party"
		L["AnnounceToTarget"] = "Target"
		L["AnnounceToTargetDesc"] = "Announce to your Target"
		L["AnnounceOnInnervate"] = "Innervate"
		L["AnnounceOnInnervateDesc"] = "Announce when you are casting Innervate"
		L["AnnounceOnInterrupt"] = "is Interrupted"
		L["AnnounceOnInterruptDesc"] = "Announce when your spellcasting is interrupted"
		L["AnnounceOnManaTide"] = "Mana Tide"
		L["AnnounceOnManaTideDesc"] = "Announce when you summon a Mana Tide Totem"
		L["AnnounceOnHymn"] = "Hymn of Hope"
		L["AnnounceOnHymnDesc"] = "Announce when you are channeling Hymn of Hope"
		L["AnnounceOnRebirth"] = "Battle res"
		L["AnnounceOnRebirthDesc"] = "Announce when you are casting a battle resurrection"
		L["AnnounceOnNormal"] = "A normal res"
		L["AnnounceOnNormalDesc"] = "Announce when you are casting Revive/Redemption/Resurrection/Ancestral Spirit"
		L["AnnounceOnSelf"] = "On self"
		L["AnnounceOnSelfDesc"] = "Announce when you are casting Innervate on yourself"
		L["Announcements for Rebirth"] = "Battle Res"
		L["RebirthWhisper"] = "Whisper"
		L["RebirthWhisperDesc"] = "This is the message your target will receive in a whisper when you cast your Battle Res"
		L["RebirthGroup"] = "Group"
		L["RebirthGroupDesc"] = "This is the message your group will receive when you cast your Battle Res"
		L["Announcements for Innervate"] = "Innervate"
		L["InnervateWhisper"] = "Whisper"
		L["InnervateWhisperDesc"] = "This is the message your target will receive in a whisper when you cast Innervate"
		L["InnervateGroup"] = "Group"
		L["InnervateGroupDesc"] = "This is the message your group will receive when you cast Innervate"
		L["Announcements for Normal"] = "Normal res"
		L["NormalWhisper"] = "Whisper"
		L["NormalWhisperDesc"] = "This is the message your target will receive in a whisper when you're casting a normal res"
		L["NormalGroup"] = "Group"
		L["NormalGroupDesc"] = "This is the message your group will receive when you're casting a normal res"
		L["InterruptGroup"] = "Failed cast"
		L["InterruptGroupDesc"] = "This is the message your group will receive when your spell is interrupted"

		-- Default announcements
		L["DefaultInnervateWhisper"] = "Innervated you!"
		L["DefaultInnervateGroup"] = "Innervating %t!"
		L["DefaultRebirthWhisper"] = "Combat ressing you, make sure it's safe before accepting!"
		L["DefaultRebirthGroup"] = "Combat ressing >>> %t <<<"
		L["DefaultNormalWhisper"] = "Casting %s on you, don't release!"
		L["DefaultNormalGroup"] = "Casting %s on %t!"
		L["DefaultManaTideGroup"] = "Mana Tide Totem is up!"
		L["DefaultHymnGroup"] = "Using Hymn of Hope!"
		L["DefaultInnervateRequest"] = "Innervate me please!"
		L["DefaultInnervateXRequest"] = "Innervate %t please!"
		L["DefaultManaTideRequest"] = "Drop your Mana Tide Totem please!"
		L["DefaultHymnRequest"] = "Use your Hymn of Hope please!"
		L["DefaultRebirthRequest"] = "Res me please!"
		L["DefaultRebirthOnXRequest"] = "Res %t please!"
		L["DefaultInterruptGroup"] = "My %s on %t failed!"

		L["AnnouncementstringDesc"] = "%t and %s will be substituted with your target's name and the spell's name"
		L["AnnounceToChannel"] = "Channel:"
		L["AnnounceToChannelDesc"] = "Announce to a custom chat channel"
		L["Requests"] = "Requests"
		L["InnervateRequest"] = "Innervate on self"
		L["InnervateRequestDesc"] = "The message sent to the druid when you request his Innervate on yourself"
		L["InnervateXRequest"] = "Incoming Innervate on other message"
		L["InnervateXRequestDesc"] = "The message is displayed when someone requests your innervate"
		L["ManaTideRequest"] = "Mana Tide"
		L["ManaTideRequestDesc"] = "The message sent to the Shaman when you request his Mana Tide Totem"
		L["HymnRequest"] = "Hymn of Hope"
		L["HymnRequestDesc"] = "The message sent to the Priest when you request his Hymn of Hope"
		L["RebirthRequest"] = "Rebirth on self"
		L["RebirthRequestDesc"] = "The message sent to the Druid when you request his Rebirth on yourself"
		L["RebirthOnXRequest"] = "Rebirth on other"
		L["RebirthOnXRequestDesc"] = "The message sent to the Druid when you request his Rebirth on a specific person"
		L["OtherAnnouncements"] = "Miscellaneous"
		L["ManaTideGroup"] = "Mana Tide Totem"
		L["ManaTideGroupDesc"] = "This is the message your group will receive when you summon a Mana Tide Totem"
		L["HymnGroup"] = "Hymn of Hope"
		L["HymnGroupDesc"] = "This is the message your group will receive when you cast Hymn of Hope"

		-- Bars
		L["Bars"] = "Bars"
		L["BarsDesc"] = "Configure the visual style of the timer bars"
		L["GrowUp"] = "Grow Upwards"
		L["GrowUpDesc"] = "Places new bars above"
		L["AllowClick"] = "Allow clicking"
		L["AllowClickDesc"] = "If ticked, sends a whisper to the druid whose bar you click"
		L["AllowScroll"] = "Allow scrolling"
		L["AllowScrollDesc"] = "Enable sorting the list of druids with your mouse wheel"
		L["Ready Colour"] = "Ready Colour"
		L["Ready ColourDesc"] = "Colour of bar that is ready"
		L["Cooldown Colour"] = "Cooldown Colour"
		L["Cooldown ColourDesc"] = "Colour of bar that is on cooldown"
		L["Dead Colour"] = "Dead Colour"
		L["Dead ColourDesc"] = "Colour of bar where the druid is dead"
		L["Opacity"] = "Opacity"
		L["OpacityDesc"] = "Opacity of timer bars"
		L["Width"] = "Width"
		L["WidthDesc"] = "Width of timer bars"
		L["Height"] = "Height"
		L["HeightDesc"] = "Height of timer bars"
		L["Spacing"] = "Spacing"
		L["SpacingDesc"] = "Space between bars"
		L["Texture"] = "Texture"
		L["TextureDesc"] = "Set the texture to use on bars"
		L["HideOnCD"] = "Only show available"
		L["HideOnCDDesc"] = "Only show players who are alive and are not on cooldown"
		L["UseClassColours"] = "Colour by Class"
		L["UseClassColoursDesc"] = "Colour bars by their respective class colours"
		L["UseRangeColours"] = "Colour by Range"
		L["UseRangeColoursDesc"] = "Recolour bars if 'target' or 'mouseover' is in range for a battle res"
		L["Range Colour"] = "Range Colour"
		L["Range ColourDesc"] = "Colour of the bar when 'target' or 'mouseover' is in range for a battle res"

		-- Fonts
		L["Fonts"] = "Fonts"
		L["FontsDesc"] = "Configure the the visual style of this addon's text elements"
		L["Name Font Colour"] = "Name Font Colour"
		L["Name Font ColourDesc"] = "Colour of the name inside timer bars"
		L["Time Font Colour"] = "Time Font Colour"
		L["Time Font ColourDesc"] = "Colour of the time inside timer bars"
		L["Target Font Colour"] = "Target Font Colour"
		L["Target Font ColourDesc"] = "Colour of the target name inside timer bars"
		L["Title Font Colour"] = "Title Font Colour"
		L["Title Font ColourDesc"] = "Colour of the title on windows"
		L["Name Font Size"] = "Name Font Size"
		L["Name Font SizeDesc"] = "Size of the name inside timer bars"
		L["Time Font Size"] = "Time Font Size"
		L["Time Font SizeDesc"] = "Size of the time inside timer bars"
		L["Target Font Size"] = "Target Font Size"
		L["Target Font SizeDesc"] = "Size of the target inside timer bars"
		L["Title Font Size"] = "Title Font Size"
		L["Title Font SizeDesc"] = "Size of the title on windows"
		L["Font"] = "Font"
		L["FontDesc"] = "Set the font to use"

		-- Incoming Requests
		L["Incoming Requests"] = true
		L["Incoming Requests Colour"] = true
		L["Output"] = true
		L["IncRequestColourDesc"] = "Incoming Request Colour"
		L["DisplayArea"] = "Display Area"
end

