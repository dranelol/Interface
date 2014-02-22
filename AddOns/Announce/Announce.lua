--------------------
--Default settings--
--------------------
local AnnounceDefaults = {
	["Buttons"] = {
		ChallShout = 1, 
		ShattThrow = 1, 
		EnragRegen = 1, 
		Disarm = 1, 
		ShieldWall = 1, 
		ShieldBlock = 1, 
		LastStand = 1,
		Dismantle = 1, 
		Blind = 1, 
		Sap = 1, 
		Tricks = 1, 
		Deterrence = 1, 
		Misdirection = 1, 
		MisdirectionW = 1, 
		MastersCall = 1, 
		MastersCallW = 1, 
		Wywern = 1, 
		FreezeTrap = 1,
		Soulstone = 1, 
		Teleport = 1, 
		Fear = 1,
		Hex = 1, 
		Grounding = 1,
		FearWard = 1, 
		FearWardW = 1,
		Shackle = 1, 
		MindCon = 1,
		DivineHymn = 1,
		HopeHymn = 1,
		Guardian = 1,
		GuardianW = 1,		
		PainSupp = 1,
		PainSuppW = 1,		
		PowerInf = 1, 
		PsyScream = 1,
		HandOfSalv = 1, 
		HandOfSac = 1,
		HandOfSacW = 1,
		DivineSac = 1,
		Repentance = 1, 
		Hammer = 1, 
		LoH = 1, 
		LoHW = 1, 
		Shield = 1, 
		Aura = 1,
		Ardent = 1,
		Polymorph = 1, 
		Silence = 1, 
		Spellsteal = 1,
		Innervate = 1, 
		Rebirth = 1, 
		RebirthW = 1,
		Bash = 1,
		Cyclone = 1, 
		ChallRoar = 1, 
		Strangulate = 1, 
		HunCold = 1, 
		Gnaw = 1, 
		Hysteria = 1,
		Spelllock = 1,
		Hibernate = 1,
		SurvInst = 1,
		FrenReg = 1,
		Reincarnation = 1,
		IceFort = 1,
		VampBlood = 1,
		UnbArm = 1,
		BoneS = 1,
		Reflect = 1,
		HoP = 1,
		HoPW = 1,
		DivineProt = 1,
		Roots = 1,
		Barkskin = 1,
		TricksW = 1,
		SoulstoneW = 1,
		PowerInfW = 1,
		InnervateW = 1,
		HandOfSalvW = 1, 
		HysteriaW = 1,
	},
	["Character"] = {
		PartyBool = 1,
		RaidBool = 1,
		InterruptBool = 1,
		CustomBool = 0,
		FadesBool = 1,
		ChatString1 = "",
		ChatString2 = " on ",
		ChatString3 = "!",
		ChatBool = 1,
		ChatSpell = 1,
		ChatTarget = 1,
		whiString1 = "",
		whiString2 = " on you!",
		IntString1 = "Interrupted ",
		IntString2 = "'s ",
		IntString3 = "!",
		IntBool = 0,
		IntSpell = 1,
		IntTarget = 1,
		Ress = 1,
		ChannelID = 0,
		ChannelName = "",
	},	
}

-----------------------------------------------------------------------
--Enables addon, registers events and sets defaults when first loaded--
----------------------------------------------------------------------
local Announce = LibStub("AceAddon-3.0"):NewAddon("Announce", "AceEvent-3.0", "AceHook-3.0")
local mousetarget, channel, name, reflected, stolen, broadcast, lastTimestamp, lastInterrupted, grounding, reinc, class

function Announce:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:Hooks()
	if (CharacterSettings == nil) then
		CharacterSettings = AnnounceDefaults["Character"];
	end
	if (SkillSettings == nil) then
		SkillSettings = AnnounceDefaults["Buttons"];
	end
	Announce:CreateSettingsMenu()
	localizedClass, class = UnitClass("player");
end

---------------------------
--Slash commands function--
---------------------------
SLASH_ANNO1 = '/anno';

function SlashCmdList.ANNO(msg)
	local savedspell = "SPELL"
	local savedtarget = "TARGET"
	--------
	--Help--
	--------
	if msg == "" then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce:\124r Broadcasts various spell events to specific channels.");
		DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Usage:\124r /anno (menu | view | reset | chat | int | whi | channel | fades)");
		DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77menu:\124r Opens interface options.");
		DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77reset:\124r Resets the addon to the default state.");
		if CharacterSettings.FadesBool == 1 then
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77fades: [\124r\124cff00ff00On\124r\124cffffff77]\124r Toggle spell fades on/off.");
		else
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77fades: [\124r\124cffff0000Off\124r\124cffffff77]\124r Toggle spell fades on/off.");
		end
		DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77whi: \124r Custom messages for whispers.");	
		if CharacterSettings.InterruptBool == 1 then
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77int: [\124r\124cff00ff00On\124r\124cffffff77]\124r Custom messages for interrupts.");
		else
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77int: [\124r\124cffff0000Off\124r\124cffffff77]\124r Custom messages for interrupts.");
		end
		if CharacterSettings.PartyBool == 1 or CharacterSettings.RaidBool == 1 or CharacterSettings.CustomBool == 1 then		
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77chat: [\124r\124cff00ff00On\124r\124cffffff77]\124r Custom messages for party/raid/custom channel.");
		else		
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77chat: [\124r\124cffff0000Off\124r\124cffffff77]\124r Custom messages for party/raid/custom channel.");
		end
		if CharacterSettings.CustomBool == 1 then
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77channel: [\124r\124cff00ff00On\124r\124cffffff77]\124r Custom channel options.");
		else
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77channel: [\124r\124cffff0000Off\124r\124cffffff77]\124r Custom channel options.");
		end
		
	elseif msg ~= "" then
		if msg == "menu" then
			InterfaceOptionsFrame_OpenToCategory(Announce.Config);
			
		------------------
		--Defaults reset--
		------------------
		elseif msg == "reset" then
			for name, value in pairs(SkillSettings) do
				SkillSettings[name] = 1
			end
			Announce.Config["ChallShoutB"]:SetChecked(true)
			Announce.Config["DisarmB"]:SetChecked(true)
			Announce.Config["EnragRegenB"]:SetChecked(true)
			Announce.Config["ReflectB"]:SetChecked(true)
			Announce.Config["ShattThrowB"]:SetChecked(true)
			Announce.Config["LastStandB"]:SetChecked(true)
			Announce.Config["ShieldBlockB"]:SetChecked(true)
			Announce.Config["ShieldWallB"]:SetChecked(true)
			Announce.Config["TricksB"]:SetChecked(true)
			Announce.Config["TricksWB"]:SetChecked(true)
			Announce.Config["BlindB"]:SetChecked(true)
			Announce.Config["DismantleB"]:SetChecked(true)
			Announce.Config["SapB"]:SetChecked(true)
			Announce.Config["HysteriaB"]:SetChecked(true)
			Announce.Config["HysteriaWB"]:SetChecked(true)
			Announce.Config["BoneSB"]:SetChecked(true)
			Announce.Config["GnawB"]:SetChecked(true)
			Announce.Config["HunColdB"]:SetChecked(true)
			Announce.Config["IceFortB"]:SetChecked(true)
			Announce.Config["StrangulateB"]:SetChecked(true)
			Announce.Config["UnbArmB"]:SetChecked(true)
			Announce.Config["VampBloodB"]:SetChecked(true)
			Announce.Config["SoulstoneB"]:SetChecked(true)
			Announce.Config["SoulstoneWB"]:SetChecked(true)
			Announce.Config["FearB"]:SetChecked(true)
			Announce.Config["SpelllockB"]:SetChecked(true)
			Announce.Config["TeleportB"]:SetChecked(true)
			Announce.Config["MastersCallB"]:SetChecked(true)
			Announce.Config["MastersCallWB"]:SetChecked(true)
			Announce.Config["MisdirectionB"]:SetChecked(true)
			Announce.Config["MisdirectionWB"]:SetChecked(true)
			Announce.Config["DeterrenceB"]:SetChecked(true)
			Announce.Config["FreezeTrapB"]:SetChecked(true)
			Announce.Config["WywernB"]:SetChecked(true)
			Announce.Config["PolymorphB"]:SetChecked(true)
			Announce.Config["SilenceB"]:SetChecked(true)
			Announce.Config["SpellstealB"]:SetChecked(true)
			Announce.Config["GroundingB"]:SetChecked(true)
			Announce.Config["HexB"]:SetChecked(true)
			Announce.Config["ReincarnationB"]:SetChecked(true)
			Announce.Config["FearWardB"]:SetChecked(true)
			Announce.Config["FearWardWB"]:SetChecked(true)
			Announce.Config["GuardianB"]:SetChecked(true)
			Announce.Config["GuardianWB"]:SetChecked(true)
			Announce.Config["PainSuppB"]:SetChecked(true)
			Announce.Config["PainSuppWB"]:SetChecked(true)
			Announce.Config["PowerInfB"]:SetChecked(true)
			Announce.Config["PowerInfWB"]:SetChecked(true)
			Announce.Config["MindConB"]:SetChecked(true)			
			Announce.Config["PsyScreamB"]:SetChecked(true)
			Announce.Config["ShackleB"]:SetChecked(true)
			Announce.Config["DivineHymnB"]:SetChecked(true)
			Announce.Config["HopeHymnB"]:SetChecked(true)
			Announce.Config["HandOfSacB"]:SetChecked(true)
			Announce.Config["HandOfSacWB"]:SetChecked(true)
			Announce.Config["HandOfSalvB"]:SetChecked(true)
			Announce.Config["HandOfSalvWB"]:SetChecked(true)
			Announce.Config["HoPB"]:SetChecked(true)
			Announce.Config["HoPWB"]:SetChecked(true)
			Announce.Config["LoHB"]:SetChecked(true)
			Announce.Config["LoHWB"]:SetChecked(true)
			Announce.Config["AuraB"]:SetChecked(true)
			Announce.Config["ArdentB"]:SetChecked(true)
			Announce.Config["DivineProtB"]:SetChecked(true)
			Announce.Config["DivineSacB"]:SetChecked(true)
			Announce.Config["HammerB"]:SetChecked(true)
			Announce.Config["RepentanceB"]:SetChecked(true)
			Announce.Config["ShieldB"]:SetChecked(true)
			Announce.Config["InnervateB"]:SetChecked(true)
			Announce.Config["InnervateWB"]:SetChecked(true)
			Announce.Config["RebirthB"]:SetChecked(true)
			Announce.Config["RebirthWB"]:SetChecked(true)
			Announce.Config["BarkskinB"]:SetChecked(true)
			Announce.Config["BashB"]:SetChecked(true)
			Announce.Config["ChallRoarB"]:SetChecked(true)
			Announce.Config["CycloneB"]:SetChecked(true)
			Announce.Config["RootsB"]:SetChecked(true)
			Announce.Config["HibernateB"]:SetChecked(true)
			Announce.Config["SurvInstB"]:SetChecked(true)	
			Announce.Config["FrenRegB"]:SetChecked(true)				
			Announce.Config["SettRessB"]:SetChecked(true)
			Announce.Config["SettInterruptB"]:SetChecked(true)
			Announce.Config["SettFadesB"]:SetChecked(true)
			Announce.Config["SettPartyB"]:SetChecked(true)
			Announce.Config["SettRaidB"]:SetChecked(true)
			Announce.Config["SettCustomB"]:SetChecked(false)
			CharacterSettings.PartyBool = 1
			CharacterSettings.RaidBool = 1
			CharacterSettings.InterruptBool = 1
			CharacterSettings.CustomBool = 0
			CharacterSettings.FadesBool = 1
			CharacterSettings.Ress = 1
			CharacterSettings.ChannelID = 0
			CharacterSettings.ChannelName = ""
			CharacterSettings.ChatString1 = ""
			CharacterSettings.ChatString2 = " on "
			CharacterSettings.ChatString3 = "!"
			CharacterSettings.ChatBool = 1
			CharacterSettings.ChatSpell = 1
			CharacterSettings.ChatTarget = 1
			CharacterSettings.whiString1 = ""
			CharacterSettings.whiString2 = " on you!"
			CharacterSettings.IntString1 = "Interrupted "
			CharacterSettings.IntString2 = "'s "
			CharacterSettings.IntString3 = "!"
			CharacterSettings.IntBool = 0
			CharacterSettings.IntSpell = 1
			CharacterSettings.IntTarget = 1
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Addon\124r was reset \124cffffff77[\124r\124cff00ff00successfully\124r\124cffffff77]\124r.")
		
		-------------------
		--Whisper options--
		-------------------
		elseif msg == "whi" then
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Usage:\124r /anno whi (CUSTOMTEXT)");
			DEFAULT_CHAT_FRAME:AddMessage("Whisper options. Text is saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.whiString1..savedspell..CharacterSettings.whiString2.."\124r\124cffffff77]\124r.");
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77CUSTOMTEXT:\124r Sets your custom message for whisper braodcast to CUSTOMTEXT, use SPELL for spell aliases (eg. You have SPELL now!).");
		elseif msg:find("^whi (.+)$") == 1 then
			msg = select(3, msg:find("^whi (.+)$"))
			local whi1, whi2 = msg:find("SPELL")
			CharacterSettings.whiString1 = msg:sub(1, whi1 - 1)
			CharacterSettings.whiString2 = msg:sub(whi2 + 1)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Whisper text\124r was saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.whiString1..savedspell..CharacterSettings.whiString2.."\124r\124cffffff77]\124r.");
	
		----------------
		--Chat options--
		----------------
		elseif msg == "chat" then
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Usage:\124r /anno chat (party | raid | CUSTOMTEXT)");
			if CharacterSettings.ChatSpell == 1 then else savedspell = "" end
			if CharacterSettings.ChatTarget == 1 then else savedtarget = "" end
			if CharacterSettings.ChatBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage("Chat options. Text is saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChatString1..savedspell..CharacterSettings.ChatString2..savedtarget..CharacterSettings.ChatString3.."\124r\124cffffff77]\124r.");
			else
				DEFAULT_CHAT_FRAME:AddMessage("Chat options. Text is saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChatString1..savedtarget..CharacterSettings.ChatString2..savedspell..CharacterSettings.ChatString3.."\124r\124cffffff77]\124r.");
			end
			if CharacterSettings.PartyBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77party: [\124r\124cff00ff00On\124r\124cffffff77]\124r Toggles party broadcast on/off.");
			else
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77party: [\124r\124cffff0000Off\124r\124cffffff77]\124r Toggles party broadcast on/off.");
			end
			if CharacterSettings.RaidBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77raid: [\124r\124cff00ff00On\124r\124cffffff77]\124r Toggles raid broadcast on/off.");
			else
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77raid: [\124r\124cffff0000Off\124r\124cffffff77]\124r Toggles raid broadcast on/off.");
			end
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77CUSTOMTEXT:\124r Sets your custom message for chat braodcast to CUSTOMTEXT, use SPELL and TARGET for spell/target aliases (eg. Casting SPELL on TARGET!).");
		elseif msg == "chat party" then
			if CharacterSettings.PartyBool == 1 then
				CharacterSettings.PartyBool = 0
				Announce.Config["SettPartyB"]:SetChecked(false)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Party\124r broadcast is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
			else
				CharacterSettings.PartyBool = 1
				Announce.Config["SettPartyB"]:SetChecked(true)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Party\124r broadcast is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
			end	
		elseif msg == "chat party on" then
			CharacterSettings.PartyBool = 1
			Announce.Config["SettPartyB"]:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Party\124r broadcast is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
		elseif msg == "chat party off" then
			CharacterSettings.PartyBool = 0
			Announce.Config["SettPartyB"]:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Party\124r broadcast is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
		elseif msg == "chat raid" then
			if CharacterSettings.RaidBool == 1 then
				CharacterSettings.RaidBool = 0
				Announce.Config["SettRaidB"]:SetChecked(false)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Raid\124r broadcast is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
			else
				CharacterSettings.RaidBool = 1
				Announce.Config["SettRaidB"]:SetChecked(true)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Raid\124r broadcast is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
			end
		elseif msg == "chat raid on" then
			CharacterSettings.RaidBool = 1
			Announce.Config["SettRaidB"]:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Raid\124r broadcast is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
		elseif msg == "chat raid off" then
			CharacterSettings.RaidBool = 0
			Announce.Config["SettRaidB"]:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Raid\124r broadcast is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
		elseif msg:find("^chat (.+)$") == 1 then
			msg = select(3, msg:find("^chat (.+)$"))
			local chat1, chat2 = msg:find("SPELL")
			local chat3, chat4 = msg:find("TARGET")
			if chat1 == nil then
				CharacterSettings.ChatString1 = msg:sub(1, chat3 - 1)
				CharacterSettings.ChatString2 = msg:sub(chat4 + 1)
				CharacterSettings.ChatString3 = ""
				CharacterSettings.ChatBool = 0
				CharacterSettings.ChatSpell = 0
				CharacterSettings.ChatTarget = 1
			elseif chat3 == nil then
				CharacterSettings.ChatString1 = msg:sub(1, chat1 - 1)
				CharacterSettings.ChatString2 = msg:sub(chat2 + 1)
				CharacterSettings.ChatString3 = ""
				CharacterSettings.ChatBool = 1
				CharacterSettings.ChatSpell = 1
				CharacterSettings.ChatTarget = 0			
			elseif chat1 < chat3 then
				CharacterSettings.ChatString1 = msg:sub(1, chat1 - 1)
				CharacterSettings.ChatString2 = msg:sub(chat2 + 1, chat3 - 1)
				CharacterSettings.ChatString3 = msg:sub(chat4 + 1)
				CharacterSettings.ChatBool = 1
				CharacterSettings.ChatSpell = 1
				CharacterSettings.ChatTarget = 1
			else
				CharacterSettings.ChatString1 = msg:sub(1, chat3 - 1)
				CharacterSettings.ChatString2 = msg:sub(chat4 + 1, chat1 - 1)
				CharacterSettings.ChatString3 = msg:sub(chat2 + 1)
				CharacterSettings.ChatBool = 0
				CharacterSettings.ChatSpell = 1
				CharacterSettings.ChatTarget = 1
			end
			if CharacterSettings.ChatSpell == 1 then else savedspell = "" end
			if CharacterSettings.ChatTarget == 1 then else savedtarget = "" end
			if CharacterSettings.ChatBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Chat text\124r was saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChatString1..savedspell..CharacterSettings.ChatString2..savedtarget..CharacterSettings.ChatString3.."\124r\124cffffff77]\124r.");
			else
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Chat text\124r was saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChatString1..savedtarget..CharacterSettings.ChatString2..savedspell..CharacterSettings.ChatString3.."\124r\124cffffff77]\124r.");
			end
			
		----------------------
		--Interrupts options--
		----------------------
		elseif msg == "int" then
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Usage:\124r /anno int (toggle | CUSTOMTEXT)");
			if CharacterSettings.IntSpell == 1 then else savedspell = "" end
			if CharacterSettings.IntTarget == 1 then else savedtarget = "" end
			if CharacterSettings.IntBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage("Interrupt options. Text is saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.IntString1..savedspell..CharacterSettings.IntString2..savedtarget..CharacterSettings.IntString3.."\124r\124cffffff77]\124r.");
			else
				DEFAULT_CHAT_FRAME:AddMessage("Interrupt options. Text is saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.IntString1..savedtarget..CharacterSettings.IntString2..savedspell..CharacterSettings.IntString3.."\124r\124cffffff77]\124r.");
			end
			if CharacterSettings.InterruptBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77toggle: [\124r\124cff00ff00On\124r\124cffffff77]\124r Toggles interrupts on/off.");
			else
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77toggle: [\124r\124cffff0000Off\124r\124cffffff77]\124r Toggles interrupts on/off.");
			end
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77CUSTOMTEXT:\124r Sets your custom message for interrupt broadcast to CUSTOMTEXT, use SPELL and TARGET for spell/target aliases (eg. SPELL by TARGET was interrupted!).");
		elseif msg == "int toggle" then
			if CharacterSettings.InterruptBool == 1 then
				CharacterSettings.InterruptBool = 0
				Announce.Config["SettInterruptB"]:SetChecked(false)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Interrupt\124r broadcast is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
			else
				CharacterSettings.InterruptBool = 1
				Announce.Config["SettInterruptB"]:SetChecked(true)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Interrupt\124r broadcast is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
			end	
		elseif msg == "int toggle on" then
			CharacterSettings.InterruptBool = 1
			Announce.Config["SettInterruptB"]:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Interrupt\124r broadcast is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
		elseif msg == "int toggle off" then
			CharacterSettings.InterruptBool = 0
			Announce.Config["SettInterruptB"]:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Interrupt\124r broadcast is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
		elseif msg:find("^int (.+)$") == 1 then
			msg = select(3, msg:find("^int (.+)$"))
			local Int1, Int2 = msg:find("SPELL")
			local Int3, Int4 = msg:find("TARGET")
			if Int1 == nil then
				CharacterSettings.IntString1 = msg:sub(1, Int3 - 1)
				CharacterSettings.IntString2 = msg:sub(Int4 + 1)
				CharacterSettings.IntString3 = ""
				CharacterSettings.IntBool = 0
				CharacterSettings.IntSpell = 0
				CharacterSettings.IntTarget = 1
			elseif Int3 == nil then
				CharacterSettings.IntString1 = msg:sub(1, Int1 - 1)
				CharacterSettings.IntString2 = msg:sub(Int2 + 1)
				CharacterSettings.IntString3 = ""
				CharacterSettings.IntBool = 1
				CharacterSettings.IntSpell = 1
				CharacterSettings.IntTarget = 0			
			elseif Int1 < Int3 then
				CharacterSettings.IntString1 = msg:sub(1, Int1 - 1)
				CharacterSettings.IntString2 = msg:sub(Int2 + 1, Int3 - 1)
				CharacterSettings.IntString3 = msg:sub(Int4 + 1)
				CharacterSettings.IntBool = 1
				CharacterSettings.IntSpell = 1
				CharacterSettings.IntTarget = 1
			else
				CharacterSettings.IntString1 = msg:sub(1, Int3 - 1)
				CharacterSettings.IntString2 = msg:sub(Int4 + 1, Int1 - 1)
				CharacterSettings.IntString3 = msg:sub(Int2 + 1)
				CharacterSettings.IntBool = 0
				CharacterSettings.IntSpell = 1
				CharacterSettings.IntTarget = 1
			end
			if CharacterSettings.IntSpell == 1 then else savedspell = "" end
			if CharacterSettings.IntTarget == 1 then else savedtarget = "" end
			if CharacterSettings.IntBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Interrupt text\124r was saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.IntString1..savedspell..CharacterSettings.IntString2..savedtarget..CharacterSettings.IntString3.."\124r\124cffffff77]\124r.");
			else
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Interrupt text\124r was saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.IntString1..savedtarget..CharacterSettings.IntString2..savedspell..CharacterSettings.IntString3.."\124r\124cffffff77]\124r.");
			end
			
		--------------------------
		--Custom channel options--
		--------------------------
		elseif msg == "channel" then
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Usage:\124r /anno channel (toggle | CUSTOMTEXT)");
			if CharacterSettings.ChannelID == 0 and (strupper(CharacterSettings.ChannelName) ~= "SAY" and strupper(CharacterSettings.ChannelName) ~= "YELL" and strupper(CharacterSettings.ChannelName) ~= "GUILD" and strupper(CharacterSettings.ChannelName) ~= "OFFICER" and strupper(CharacterSettings.ChannelName) ~= "RAID_WARNING" and strupper(CharacterSettings.ChannelName) ~= "BATTLEGROUND") then 
				DEFAULT_CHAT_FRAME:AddMessage("Custom channel options. Channel is saved as \124cffffff77[\124r\124cffff0000"..CharacterSettings.ChannelName.."\124r\124cffffff77]\124r with index of \124cffffff77[\124r\124cffff0000"..CharacterSettings.ChannelID.."\124r\124cffffff77]\124r.");
				DEFAULT_CHAT_FRAME:AddMessage(" ERROR: You are not in this channel.");
			else
				DEFAULT_CHAT_FRAME:AddMessage("Custom channel options. Channel is saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChannelName.."\124r\124cffffff77]\124r with index of \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChannelID.."\124r\124cffffff77]\124r.");
			end
			if CharacterSettings.CustomBool == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77toggle: [\124r\124cff00ff00On\124r\124cffffff77]\124r Toggles custom channel on/off.");
			else
				DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77toggle: [\124r\124cffff0000Off\124r\124cffffff77]\124r Toggles custom channel on/off.");
			end
			DEFAULT_CHAT_FRAME:AddMessage(" - \124cffffff77CUSTOMTEXT:\124r Sets your custom channel to CUSTOMTEXT, allowed special channels are: SAY, YELL, GUILD, OFFICER, RAID_WARNING, BATTLEGROUND and any custom channel by name or index.");
		elseif msg == "channel toggle" then
			if CharacterSettings.CustomBool == 1 then
				CharacterSettings.CustomBool = 0
				Announce.Config["SettCustomB"]:SetChecked(false)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Custom channel\124r is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
			else
				CharacterSettings.CustomBool = 1
				Announce.Config["SettCustomB"]:SetChecked(true)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Custom channel\124r is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
			end		
		elseif msg == "channel toggle on" then
			CharacterSettings.CustomBool = 1
			Announce.Config["SettCustomB"]:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Custom channel\124r is now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
		elseif msg == "channel toggle off" then
			CharacterSettings.CustomBool = 0
			Announce.Config["SettCustomB"]:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Custom channel\124r is now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");	
		elseif msg:find("^channel (.+)$") == 1 then
			CharacterSettings.ChannelName = select(3, msg:find("^channel (.+)$"))
			CharacterSettings.ChannelID = GetChannelName(CharacterSettings.ChannelName)
			if CharacterSettings.ChannelID == 0 and (strupper(CharacterSettings.ChannelName) ~= "SAY" and strupper(CharacterSettings.ChannelName) ~= "YELL" and strupper(CharacterSettings.ChannelName) ~= "GUILD" and strupper(CharacterSettings.ChannelName) ~= "OFFICER" and strupper(CharacterSettings.ChannelName) ~= "RAID_WARNING" and strupper(CharacterSettings.ChannelName) ~= "BATTLEGROUND") then 
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Custom channel\124r was saved as \124cffffff77[\124r\124cffff0000"..CharacterSettings.ChannelName.."\124r\124cffffff77]\124r with index of \124cffffff77[\124r\124cffff0000"..CharacterSettings.ChannelID.."\124r\124cffffff77]\124r.");
				DEFAULT_CHAT_FRAME:AddMessage(" ERROR: You are not in this channel.");
			else
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Custom channel\124r was saved as \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChannelName.."\124r\124cffffff77]\124r with index of \124cffffff77[\124r\124cff00ff00"..CharacterSettings.ChannelID.."\124r\124cffffff77]\124r.");
			end
			
		----------------------
		--Spell fades toggle--
		----------------------
		elseif msg == "fades" then
			if CharacterSettings.FadesBool == 1 then
				CharacterSettings.FadesBool = 0
				Announce.Config["SettFadesB"]:SetChecked(false)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Spell fades\124r are now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
			else
				CharacterSettings.FadesBool = 1
				Announce.Config["SettFadesB"]:SetChecked(true)
				DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Spell fades\124r are now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
			end
		elseif msg == "fades on" then
			CharacterSettings.FadesBool = 1
			Announce.Config["SettFadesB"]:SetChecked(true)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Spell fades\124r are now set to \124cffffff77[\124r\124cff00ff00enabled\124r\124cffffff77]\124r.");
		elseif msg == "fades off" then
			CharacterSettings.FadesBool = 0
			Announce.Config["SettFadesB"]:SetChecked(false)
			DEFAULT_CHAT_FRAME:AddMessage("\124cffffff77Announce: Spell fades\124r are now set to \124cffffff77[\124r\124cffff0000disabled\124r\124cffffff77]\124r.");
		end
	end
end  
-----------------------------------------------------------
--Getting names for corpses of released players (Rebirth)--
-----------------------------------------------------------
function Announce:WorldFrameOnMouseDown(...)
	if GameTooltipTextLeft1:IsVisible() then
		name = select(3, GameTooltipTextLeft1:GetText():find("^Corpse of (.+)$"))
		if name then
			mousetarget = name
		end
	end
	self.hooks[WorldFrame]["OnMouseDown"](...)
end

function Announce:Hooks()
	self:HookScript(WorldFrame, "OnMouseDown", "WorldFrameOnMouseDown")
end

-----------------------------------------------
--Functions for chat and whispering broadcast--
-----------------------------------------------
function Announce:SendText(spell, target, spellID)
	broadcast = "\124cff71d5ff\124Hspell:"..tostring(spellID).."\124h["..spell.."]\124h\124r"
	if (target ~= nil) then
		if CharacterSettings.CustomBool == 1 then
			if CharacterSettings.ChannelName ~= nil then
				CharacterSettings.ChannelID = GetChannelName(CharacterSettings.ChannelName)
				if CharacterSettings.ChannelID ~= 0 and CharacterSettings.ChannelID ~= nil then
					if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
					if CharacterSettings.ChatTarget == 1 then else target = "" end
					if CharacterSettings.ChatBool == 1 then
						if reflected == 1 then
							reflected = 0
							SendChatMessage("Reflect: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
						elseif stolen == 1 then
							stolen = 0
							SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
						else
							SendChatMessage(CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
						end
					else
						if reflected == 1 then
							reflected = 0
							SendChatMessage("Reflect: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
						elseif stolen == 1 then
							stolen = 0
							SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
						else
							SendChatMessage(CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
						end
					end
				elseif (strupper(CharacterSettings.ChannelName) == "SAY") or (strupper(CharacterSettings.ChannelName) == "YELL") or (strupper(CharacterSettings.ChannelName) == "GUILD") or (strupper(CharacterSettings.ChannelName) == "OFFICER") or (strupper(CharacterSettings.ChannelName) == "RAID_WARNING") or (strupper(CharacterSettings.ChannelName) == "BATTLEGROUND") then
					CharacterSettings.ChannelName = strupper(CharacterSettings.ChannelName)
					if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
					if CharacterSettings.ChatTarget == 1 then else target = "" end
					if CharacterSettings.ChatBool == 1 then
						if reflected == 1 then
							reflected = 0
							SendChatMessage("Reflect: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
						elseif stolen == 1 then
							stolen = 0
							SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
						else
							SendChatMessage(CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
						end
					else
						if reflected == 1 then
							reflected = 0
							SendChatMessage("Reflect: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
						elseif stolen == 1 then
							stolen = 0
							SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
						else
							SendChatMessage(CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
						end
					end
				end
			end
		elseif CharacterSettings.RaidBool == 1 and GetNumRaidMembers() > 0 then
			if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
			if CharacterSettings.ChatTarget == 1 then else target = "" end
			if CharacterSettings.ChatBool == 1 then
				if reflected == 1 then
					reflected = 0
					SendChatMessage("Reflect: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "RAID")
				elseif stolen == 1 then
					stolen = 0
					SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "RAID")
				else
					SendChatMessage(CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "RAID")
				end
			else
				if reflected == 1 then
					reflected = 0
					SendChatMessage("Reflect: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "RAID")
				elseif stolen == 1 then
					stolen = 0
					SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "RAID")
				else
					SendChatMessage(CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "RAID")
				end
			end
		elseif CharacterSettings.PartyBool == 1 and GetNumPartyMembers() > 0 then
			if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
			if CharacterSettings.ChatTarget == 1 then else target = "" end
			if CharacterSettings.ChatBool == 1 then
				if reflected == 1 then
					reflected = 0
					SendChatMessage("Reflect: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "PARTY")
				elseif stolen == 1 then
					stolen = 0
					SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "PARTY")
				else
					SendChatMessage(CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "PARTY")
				end
			else
				if reflected == 1 then
					reflected = 0
					SendChatMessage("Reflect: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "PARTY")
				elseif stolen == 1 then
					stolen = 0
					SendChatMessage("Spellsteal: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "PARTY")
				else
					SendChatMessage(CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "PARTY")
				end
			end
		end
	else
		if CharacterSettings.CustomBool == 1 then
			if CharacterSettings.ChannelName ~= nil then
				CharacterSettings.ChannelID = GetChannelName(CharacterSettings.ChannelName)
				if CharacterSettings.ChannelID ~= 0 and CharacterSettings.ChannelID ~= nil then
					if grounding == 1 then
						grounding = 0
						SendChatMessage("Grounded: "..broadcast.."!", "CHANNEL", nil, CharacterSettings.ChannelID)
					else
						SendChatMessage(broadcast.."!", "CHANNEL", nil, CharacterSettings.ChannelID)
					end
				elseif (strupper(CharacterSettings.ChannelName) == "SAY") or (strupper(CharacterSettings.ChannelName) == "YELL") or (strupper(CharacterSettings.ChannelName) == "GUILD") or (strupper(CharacterSettings.ChannelName) == "OFFICER") or (strupper(CharacterSettings.ChannelName) == "RAID_WARNING") or (strupper(CharacterSettings.ChannelName) == "BATTLEGROUND") then
					CharacterSettings.ChannelName = strupper(CharacterSettings.ChannelName)
					if grounding == 1 then
						grounding = 0
						SendChatMessage("Grounded: "..broadcast.."!", CharacterSettings.ChannelName)
					else
						SendChatMessage(broadcast.."!", CharacterSettings.ChannelName)
					end
				end
			end
		elseif CharacterSettings.RaidBool == 1 and GetNumRaidMembers() > 0 then
			if grounding == 1 then
				grounding = 0
				SendChatMessage("Grounded: "..broadcast.."!", "RAID")
			else
				SendChatMessage(broadcast.."!", "RAID")
			end
		elseif CharacterSettings.PartyBool == 1 and GetNumPartyMembers() > 0 then
			if grounding == 1 then
				grounding = 0
				SendChatMessage("Grounded: "..broadcast.."!", "PARTY")
			else
				SendChatMessage(broadcast.."!", "PARTY")
			end
		end
	end
end

function Announce:WhisperText(spell, name, spellID, guid)
	if tonumber(guid:sub(5,5), 16)%8 == 4 then return end
	broadcast = "\124cff71d5ff\124Hspell:"..tostring(spellID).."\124h["..spell.."]\124h\124r"
	SendChatMessage(CharacterSettings.whiString1..broadcast..CharacterSettings.whiString2, "WHISPER", nil, name)
end

function Announce:FadesText(spell, target, spellID)
	broadcast = "\124cff71d5ff\124Hspell:"..tostring(spellID).."\124h["..spell.."]\124h\124r"
	if (target ~= nil) then
		if CharacterSettings.CustomBool == 1 then
			if CharacterSettings.ChannelName ~= nil then
				CharacterSettings.ChannelID = GetChannelName(CharacterSettings.ChannelName)
				if CharacterSettings.ChannelID ~= 0 and CharacterSettings.ChannelID ~= nil then
					if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
					if CharacterSettings.ChatTarget == 1 then else target = "" end
					if CharacterSettings.ChatBool == 1 then
						SendChatMessage("Faded: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
					else
						SendChatMessage("Faded: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "CHANNEL", nil, CharacterSettings.ChannelID)
					end
				elseif (strupper(CharacterSettings.ChannelName) == "SAY") or (strupper(CharacterSettings.ChannelName) == "YELL") or (strupper(CharacterSettings.ChannelName) == "GUILD") or (strupper(CharacterSettings.ChannelName) == "OFFICER") or (strupper(CharacterSettings.ChannelName) == "RAID_WARNING") or (strupper(CharacterSettings.ChannelName) == "BATTLEGROUND") then
					CharacterSettings.ChannelName = strupper(CharacterSettings.ChannelName)
					if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
					if CharacterSettings.ChatTarget == 1 then else target = "" end
					if CharacterSettings.ChatBool == 1 then
						SendChatMessage("Faded: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
					else
						SendChatMessage("Faded: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, CharacterSettings.ChannelName)
					end
				end
			end
		elseif (CharacterSettings.RaidBool == 1 and GetNumRaidMembers() > 0) then
			if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
			if CharacterSettings.ChatTarget == 1 then else target = "" end
			if CharacterSettings.ChatBool == 1 then
				SendChatMessage("Faded: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "RAID")
			else
				SendChatMessage("Faded: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "RAID")
			end
		elseif (CharacterSettings.PartyBool == 1 and GetNumPartyMembers() > 0) then
			if CharacterSettings.ChatSpell == 1 then else broadcast = "" end
			if CharacterSettings.ChatTarget == 1 then else target = "" end
			if CharacterSettings.ChatBool == 1 then
				SendChatMessage("Faded: "..CharacterSettings.ChatString1..broadcast..CharacterSettings.ChatString2..target..CharacterSettings.ChatString3, "PARTY")
			else
				SendChatMessage("Faded: "..CharacterSettings.ChatString1..target..CharacterSettings.ChatString2..broadcast..CharacterSettings.ChatString3, "PARTY")
			end
		end
	else
		if CharacterSettings.CustomBool == 1 then
			if CharacterSettings.ChannelName ~= nil then
				CharacterSettings.ChannelID = GetChannelName(CharacterSettings.ChannelName)
				if CharacterSettings.ChannelID ~= 0 and CharacterSettings.ChannelID ~= nil then
					SendChatMessage("Faded: "..broadcast.."!", "CHANNEL", nil, CharacterSettings.ChannelID)
				elseif (strupper(CharacterSettings.ChannelName) == "SAY") or (strupper(CharacterSettings.ChannelName) == "YELL") or (strupper(CharacterSettings.ChannelName) == "GUILD") or (strupper(CharacterSettings.ChannelName) == "OFFICER") or (strupper(CharacterSettings.ChannelName) == "RAID_WARNING") or (strupper(CharacterSettings.ChannelName) == "BATTLEGROUND") then
					CharacterSettings.ChannelName = strupper(CharacterSettings.ChannelName)
					SendChatMessage("Faded: "..broadcast.."!", CharacterSettings.ChannelName)
				end
			end
		elseif (CharacterSettings.RaidBool == 1 and GetNumRaidMembers() > 0) then
			SendChatMessage("Faded: "..broadcast.."!", "RAID")
		elseif (CharacterSettings.PartyBool == 1 and GetNumPartyMembers() > 0) then
			SendChatMessage("Faded: "..broadcast.."!", "PARTY")
		end
	end	
end

function Announce:InterruptText(spell, target, spellID)
	broadcast = "\124cff71d5ff\124Hspell:"..tostring(spellID).."\124h["..spell.."]\124h\124r"
	if CharacterSettings.CustomBool == 1 then
		if CharacterSettings.ChannelName ~= nil then
			CharacterSettings.ChannelID = GetChannelName(CharacterSettings.ChannelName)
			if CharacterSettings.ChannelID ~= 0 and CharacterSettings.ChannelID ~= nil then
				if CharacterSettings.IntSpell == 1 then else broadcast = "" end
				if CharacterSettings.IntTarget == 1 then else target = "" end
				if CharacterSettings.IntBool == 1 then
					SendChatMessage(CharacterSettings.IntString1..broadcast..CharacterSettings.IntString2..target..CharacterSettings.IntString3, "CHANNEL", nil, CharacterSettings.ChannelID)
				else
					SendChatMessage(CharacterSettings.IntString1..target..CharacterSettings.IntString2..broadcast..CharacterSettings.IntString3, "CHANNEL", nil, CharacterSettings.ChannelID)
				end
			elseif (strupper(CharacterSettings.ChannelName) == "SAY") or (strupper(CharacterSettings.ChannelName) == "YELL") or (strupper(CharacterSettings.ChannelName) == "GUILD") or (strupper(CharacterSettings.ChannelName) == "OFFICER") or (strupper(CharacterSettings.ChannelName) == "RAID_WARNING") or (strupper(CharacterSettings.ChannelName) == "BATTLEGROUND") then
				CharacterSettings.ChannelName = strupper(CharacterSettings.ChannelName)
				if CharacterSettings.IntSpell == 1 then else broadcast = "" end
				if CharacterSettings.IntTarget == 1 then else target = "" end
				if CharacterSettings.IntBool == 1 then
					SendChatMessage(CharacterSettings.IntString1..broadcast..CharacterSettings.IntString2..target..CharacterSettings.IntString3, CharacterSettings.ChannelName)
				else
					SendChatMessage(CharacterSettings.IntString1..target..CharacterSettings.IntString2..broadcast..CharacterSettings.IntString3, CharacterSettings.ChannelName)
				end
			end
		end
	elseif (CharacterSettings.RaidBool == 1 and GetNumRaidMembers() > 0) then
		if CharacterSettings.IntSpell == 1 then else broadcast = "" end
		if CharacterSettings.IntTarget == 1 then else target = "" end
		if CharacterSettings.IntBool == 1 then
			SendChatMessage(CharacterSettings.IntString1..broadcast..CharacterSettings.IntString2..target..CharacterSettings.IntString3, "RAID")
		else
			SendChatMessage(CharacterSettings.IntString1..target..CharacterSettings.IntString2..broadcast..CharacterSettings.IntString3, "RAID")
		end
	elseif (CharacterSettings.PartyBool == 1 and GetNumPartyMembers() > 0) then
		if CharacterSettings.IntSpell == 1 then else broadcast = "" end
		if CharacterSettings.IntTarget == 1 then else target = "" end
		if CharacterSettings.IntBool == 1 then
			SendChatMessage(CharacterSettings.IntString1..broadcast..CharacterSettings.IntString2..target..CharacterSettings.IntString3, "PARTY")
		else
			SendChatMessage(CharacterSettings.IntString1..target..CharacterSettings.IntString2..broadcast..CharacterSettings.IntString3, "PARTY")
		end
	end
end

------------------------
--Combat log filtering--
------------------------
function Announce:COMBAT_LOG_EVENT_UNFILTERED(_,timestamp,event,playerGUID,playerName,_,targetGUID,targetName,targetFlags,spellID,_,_,otherspellID)
	------------------------------------
	--Shaman: Reincarnation - cooldown--
	------------------------------------
	if class == "SHAMAN" then
		if (SkillSettings.Reincarnation == 1) then
			local start, duration = GetSpellCooldown("Reincarnation");
			if start ~= nil and duration ~= nil then
				if reinc ~= 1 then					
					local a,b,c,d,e= GetTalentInfo(3,3)
					if e == 2 then
						if (math.ceil(start + duration - GetTime()) == 2400) or (math.ceil(start + duration - GetTime()) == 2399) then
							reinc = 1
							self:SendText(GetSpellInfo(20608), nil, 20608)
						end
					elseif e == 1 then
						if (math.ceil(start + duration - GetTime()) == 3000) or (math.ceil(start + duration - GetTime()) == 2999) then
							reinc = 1
							self:SendText(GetSpellInfo(20608), nil, 20608)
						end
					elseif e == 0 then
						if (math.ceil(start + duration - GetTime()) == 3600) or (math.ceil(start + duration - GetTime()) == 3599) then
							reinc = 1
							self:SendText(GetSpellInfo(20608), nil, 20608)
						end
					end
				elseif reinc == 1 then
					if (math.ceil(start + duration - GetTime()) == 1) or (math.ceil(start + duration - GetTime()) == 0) then
						reinc = 0
					end
				end
			end
		end
		
		------------------------------------------------
		--Grounding Totem - targetName and targetFlags--
		------------------------------------------------
		if (event == "SPELL_MISSED" and targetName == "Grounding Totem" and targetFlags == 8465 and SkillSettings.Grounding == 1) or (event == "SPELL_DAMAGE" and targetName == "Grounding Totem" and targetFlags == 8465 and SkillSettings.Grounding == 1) then
			grounding = 1
			self:SendText(GetSpellInfo(spellID), nil, spellID)
		end
	end
	
	
	-----------------------------------------------------------
	--Warrior: Spell Reflection - targetGUID and SPELL_MISSED--
	-----------------------------------------------------------
	if class == "WARRIOR" then
		if (targetGUID == UnitGUID("player")) then
			if (event == "SPELL_MISSED") then
				if (SkillSettings.Reflect == 1 and otherspellID == "REFLECT") then
					reflected = 1
					self:SendText(GetSpellInfo(spellID), playerName, spellID)
				end
			end	
		end
	end
	
	
	if (playerGUID == UnitGUID("pet")) then
------------------
--Pet interrupts--
------------------
		if (event == "SPELL_INTERRUPT") then
			if (CharacterSettings.InterruptBool == 1) then 
				if timestamp ~= lastTimestamp or otherspellID ~= lastInterrupted then
					lastTimestamp = timestamp
					lastInterrupted = otherspellID			
					self:InterruptText(GetSpellInfo(otherspellID), targetName, otherspellID)
				end
			end

----------------------
--Pet hostile spells--
----------------------	
		elseif (event == "SPELL_AURA_APPLIED") then
			-------------------------------------------
			--Death Knight: Gnaw, Warlock: Spell Lock--
			-------------------------------------------
			if (SkillSettings.Gnaw == 1 and spellID == 47481) or (SkillSettings.Spelllock == 1 and spellID == 24259) then
				self:SendText(GetSpellInfo(spellID), targetName, spellID)
			end
			
-------------
--Pet fades--
-------------
		elseif (event == "SPELL_AURA_REMOVED") then
			if (CharacterSettings.FadesBool == 1) then
				if (SkillSettings.Gnaw == 1 and spellID == 47481) or (SkillSettings.Spelllock == 1 and spellID == 24259) then
					self:FadesText(GetSpellInfo(spellID), targetName, spellID)
				end
			end
		end
	
	
	elseif (playerGUID == UnitGUID("player")) then
--------------
--Interrupts--
--------------
		if (event == "SPELL_INTERRUPT") then
			if (CharacterSettings.InterruptBool == 1) then 
				if timestamp ~= lastTimestamp or otherspellID ~= lastInterrupted then
					lastTimestamp = timestamp
					lastInterrupted = otherspellID			
					self:InterruptText(GetSpellInfo(otherspellID), targetName, otherspellID)
				end
			end
			
---------
--Fades--
---------		
		elseif (event == "SPELL_AURA_REMOVED") then
			if (CharacterSettings.FadesBool == 1) then
				-----------------
				--Warrior fades--
				-----------------
				if class == "WARRIOR" then
					if (SkillSettings.Disarm == 1 and spellID == 676) or (SkillSettings.ShieldBlock == 1 and spellID == 2565) or (SkillSettings.ShieldWall == 1 and spellID == 871) or (SkillSettings.EnragRegen == 1 and spellID == 55694) or (SkillSettings.LastStand == 1 and spellID == 12975) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end
				---------------
				--Rogue fades--
				---------------
				elseif class == "ROGUE" then
					if (SkillSettings.Dismantle == 1 and spellID == 51722) or (SkillSettings.Blind == 1 and spellID == 2094) or (SkillSettings.Sap == 1 and spellID == 51724) or (SkillSettings.Tricks  == 1 and spellID == 57934) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end			
				----------------------
				--Death Knight fades--
				----------------------
				elseif class == "DEATHKNIGHT" then
					if (SkillSettings.Strangulate == 1 and spellID == 47476) or (SkillSettings.HunCold == 1 and spellID == 49203) or (SkillSettings.IceFort == 1 and spellID == 48792) or (SkillSettings.VampBlood == 1 and spellID == 55233) or (SkillSettings.UnbArm == 1 and spellID == 51271) or (SkillSettings.BoneS == 1 and spellID == 49222) or (SkillSettings.Hysteria == 1 and spellID == 49016) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end
				----------------
				--Hunter fades--
				----------------
				elseif class == "HUNTER" then
					if (SkillSettings.Wywern == 1 and spellID == 19386) or (SkillSettings.Wywern == 1 and spellID == 24132) or (SkillSettings.Wywern == 1 and spellID == 24133) or (SkillSettings.Wywern == 1 and spellID == 27068) or (SkillSettings.Wywern == 1 and spellID == 49011) or (SkillSettings.Wywern == 1 and spellID == 49012) or (SkillSettings.FreezeTrap == 1 and spellID == 55041) or (SkillSettings.FreezeTrap == 1 and spellID == 14309) or (SkillSettings.FreezeTrap == 1 and spellID == 14308) or (SkillSettings.FreezeTrap == 1 and spellID == 3355) or (SkillSettings.Deterrence == 1 and spellID == 19263) or (SkillSettings.MastersCall and spellID == 53271) or (SkillSettings.Misdirection == 1 and spellID == 34477) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end
				--------------
				--Mage fades--
				--------------
				elseif class == "MAGE" then
					if (SkillSettings.Silence == 1 and spellID == 55021) or (SkillSettings.Silence == 1 and spellID == 18469) or (SkillSettings.Polymorph == 1 and spellID == 118) or (SkillSettings.Polymorph == 1 and spellID == 12824) or (SkillSettings.Polymorph == 1 and spellID == 12825) or (SkillSettings.Polymorph == 1 and spellID == 12826) or (SkillSettings.Polymorph == 1 and spellID == 28272) or (SkillSettings.Polymorph == 1 and spellID == 61721) or (SkillSettings.Polymorph == 1 and spellID == 61025) or (SkillSettings.Polymorph == 1 and spellID == 61780) or (SkillSettings.Polymorph == 1 and spellID == 28271) or (SkillSettings.Polymorph == 1 and spellID == 61305) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end
				---------------
				--Druid fades--
				---------------
				elseif class == "DRUID" then
					if (SkillSettings.Innervate and spellID == 29166) or (SkillSettings.Barkskin == 1 and spellID == 22812) or (SkillSettings.Hibernate == 1 and spellID == 2637) or (SkillSettings.Hibernate == 1 and spellID == 18657) or (SkillSettings.Hibernate == 1 and spellID == 18658) or (SkillSettings.Cyclone == 1 and spellID == 33786) or (SkillSettings.Roots == 1 and spellID == 339) or (SkillSettings.Roots == 1 and spellID == 1062) or (SkillSettings.Roots == 1 and spellID == 5195) or (SkillSettings.Roots == 1 and spellID == 5196) or (SkillSettings.Roots == 1 and spellID == 9852) or (SkillSettings.Roots == 1 and spellID == 9853) or (SkillSettings.Roots == 1 and spellID == 26989) or (SkillSettings.Roots == 1 and spellID == 53308) or (SkillSettings.Bash == 1 and spellID == 5211) or (SkillSettings.Bash == 1 and spellID == 6798) or (SkillSettings.Bash == 1 and spellID == 8983) or (SkillSettings.FrenReg == 1 and spellID == 22842) or (SkillSettings.SurvInst == 1 and spellID == 61336) then 
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end
				-----------------
				--Paladin fades--
				-----------------
				elseif class == "PALADIN" then
					if (SkillSettings.HandOfSac == 1 and spellID == 6940) or (SkillSettings.HandOfSalv == 1 and spellID == 1038) or (SkillSettings.HoP == 1 and spellID == 1022) or (SkillSettings.HoP == 1 and spellID == 5599) or (SkillSettings.HoP == 1 and spellID == 10278) or (SkillSettings.DivineProt == 1 and spellID == 498) or (SkillSettings.Repentance == 1 and spellID == 20066) or (SkillSettings.Hammer == 1 and spellID == 853) or (SkillSettings.Hammer == 1 and spellID == 5588) or (SkillSettings.Hammer == 1 and spellID == 5589) or (SkillSettings.Hammer == 1 and spellID == 10308) or (SkillSettings.Shield == 1 and spellID == 63529) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					elseif (SkillSettings.DivineSac == 1 and spellID == 64205 and targetGUID == UnitGUID("player")) or (SkillSettings.Aura == 1 and spellID == 31821 and targetGUID == UnitGUID("player")) or (SkillSettings.Ardent == 1 and spellID == 66233) then
						self:FadesText(GetSpellInfo(spellID), nil, spellID)
					end
				----------------
				--Priest fades--
				----------------
				elseif class == "PRIEST" then
					if (SkillSettings.DivineHymn == 1 and spellID == 64843) or (SkillSettings.HopeHymn == 1 and spellID == 64901) then
						self:FadesText(GetSpellInfo(spellID), nil, spellID)
					elseif (SkillSettings.Shackle == 1 and spellID == 9484) or (SkillSettings.Shackle == 1 and spellID == 9485) or (SkillSettings.Shackle == 1 and spellID == 10955) or (SkillSettings.MindCon == 1 and spellID == 605) or (SkillSettings.PainSupp == 1 and spellID == 33206) or (SkillSettings.Guardian == 1 and spellID == 47788) or (SkillSettings.FearWard == 1 and spellID == 6346) or (SkillSettings.PowerInf == 1 and spellID == 10060) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					elseif (SkillSettings.PsyScream == 1 and spellID == 8122) or (SkillSettings.PsyScream == 1 and spellID == 8124) or (SkillSettings.PsyScream == 1 and spellID == 10888) or (SkillSettings.PsyScream == 1 and spellID == 10890) then
						if timestamp ~= lastTimestamp then
							lastTimestamp = timestamp
							self:FadesText(GetSpellInfo(spellID), targetName, spellID)
						end
					end
				----------------
				--Shaman fades--
				----------------
				elseif class == "SHAMAN" then
					if (SkillSettings.Hex == 1 and spellID == 51514) then
						self:FadesText(GetSpellInfo(spellID), targetName, spellID)
					end
				end
			end
				
--------------
--Cast start--
--------------			
		elseif (event == "SPELL_CAST_START") then
			-----------------------------
			--Warrior: Shattering Throw--
			-----------------------------
			if class == "WARRIOR" then
				if (SkillSettings.ShattThrow == 1 and spellID == 64382) then 
					if (UnitName("target") and UnitIsEnemy("player","target")) then
						self:SendText(GetSpellInfo(spellID), UnitName("target"), spellID)
					end
				end
							
			-------------------------
			--Druid: Rebirth/Revive--
			-------------------------
			elseif class == "DRUID" then
				if (spellID == 20484) or (spellID == 20739) or (spellID == 20742) or (spellID == 20747) or (spellID == 20748) or (spellID == 26994) or (spellID == 48477) then 
					if (UnitName("target") and UnitIsFriend("player","target") and UnitIsDead("target")) then
						if (SkillSettings.Rebirth == 1) then
							self:SendText(GetSpellInfo(spellID), UnitName("target"), spellID)
						end
						if (SkillSettings.RebirthW == 1) then
							self:WhisperText(GetSpellInfo(spellID), UnitName("target"), spellID, targetGUID)
						end
					elseif (UnitName("mouseover") and UnitIsFriend("player","mouseover") and UnitIsDead("mouseover")) then
						if (SkillSettings.Rebirth == 1) then
							self:SendText(GetSpellInfo(spellID), UnitName("mouseover"), spellID)
						end
						if (SkillSettings.RebirthW == 1) then
							self:WhisperText(GetSpellInfo(spellID), UnitName("mouseover"), spellID, targetGUID)
						end
					else
						if (SkillSettings.Rebirth == 1) then
							self:SendText(GetSpellInfo(spellID), mousetarget, spellID)
						end
						if (SkillSettings.RebirthW == 1) then
							self:WhisperText(GetSpellInfo(spellID), mousetarget, spellID, targetGUID)
						end
					end
				elseif (CharacterSettings.Ress == 1 and spellID == 50769) or (CharacterSettings.Ress == 1 and spellID == 50768) or (CharacterSettings.Ress == 1 and spellID == 50767) or (CharacterSettings.Ress == 1 and spellID == 50766) or (CharacterSettings.Ress == 1 and spellID == 50765) or (CharacterSettings.Ress == 1 and spellID == 50764) or (CharacterSettings.Ress == 1 and spellID == 50763) then
					if (UnitName("target") and UnitIsFriend("player","target") and UnitIsDead("target")) then
						self:SendText(GetSpellInfo(spellID), UnitName("target"), spellID)
					elseif (UnitName("mouseover") and UnitIsFriend("player","mouseover") and UnitIsDead("mouseover")) then
						self:SendText(GetSpellInfo(spellID), UnitName("mouseover"), spellID)
					else
						self:SendText(GetSpellInfo(spellID), mousetarget, spellID)
					end
				end
			-----------------------
			--Paladin: Redemption--
			-----------------------
			elseif class == "PALADIN" then
				if (CharacterSettings.Ress == 1 and spellID == 7328) or (CharacterSettings.Ress == 1 and spellID == 10322) or (CharacterSettings.Ress == 1 and spellID == 10324) or (CharacterSettings.Ress == 1 and spellID == 20772) or (CharacterSettings.Ress == 1 and spellID == 20773) or (CharacterSettings.Ress == 1 and spellID == 48949) or (CharacterSettings.Ress == 1 and spellID == 48950) then
					if (UnitName("target") and UnitIsFriend("player","target") and UnitIsDead("target")) then
						self:SendText(GetSpellInfo(spellID), UnitName("target"), spellID)
					elseif (UnitName("mouseover") and UnitIsFriend("player","mouseover") and UnitIsDead("mouseover")) then
						self:SendText(GetSpellInfo(spellID), UnitName("mouseover"), spellID)
					else
						self:SendText(GetSpellInfo(spellID), mousetarget, spellID)
					end
				end		
				
			------------------------
			--Priest: Resurrection--
			------------------------
			elseif class == "PRIEST" then
				if (CharacterSettings.Ress == 1 and spellID == 2006) or (CharacterSettings.Ress == 1 and spellID == 2010) or (CharacterSettings.Ress == 1 and spellID == 10880) or (CharacterSettings.Ress == 1 and spellID == 10881) or (CharacterSettings.Ress == 1 and spellID == 20770) or (CharacterSettings.Ress == 1 and spellID == 25435) or (CharacterSettings.Ress == 1 and spellID == 48171) then
					if (UnitName("target") and UnitIsFriend("player","target") and UnitIsDead("target")) then
						self:SendText(GetSpellInfo(spellID), UnitName("target"), spellID)
					elseif (UnitName("mouseover") and UnitIsFriend("player","mouseover") and UnitIsDead("mouseover")) then
						self:SendText(GetSpellInfo(spellID), UnitName("mouseover"), spellID)
					else
						self:SendText(GetSpellInfo(spellID), mousetarget, spellID)
					end
				end
				
			----------------------------
			--Shaman: Ancestral Spirit--
			----------------------------
			elseif class == "SHAMAN" then
				if (CharacterSettings.Ress == 1 and spellID == 2008) or (CharacterSettings.Ress == 1 and spellID == 20609) or (CharacterSettings.Ress == 1 and spellID == 20610) or (CharacterSettings.Ress == 1 and spellID == 20776) or (CharacterSettings.Ress == 1 and spellID == 20777) or (CharacterSettings.Ress == 1 and spellID == 25590) or (CharacterSettings.Ress == 1 and spellID == 49277) then
					if (UnitName("target") and UnitIsFriend("player","target") and UnitIsDead("target")) then
						self:SendText(GetSpellInfo(spellID), UnitName("target"), spellID)
					elseif (UnitName("mouseover") and UnitIsFriend("player","mouseover") and UnitIsDead("mouseover")) then
						self:SendText(GetSpellInfo(spellID), UnitName("mouseover"), spellID)
					else
						self:SendText(GetSpellInfo(spellID), mousetarget, spellID)
					end
				end
			end
			
-----------------------------------------
--Friendly spells/Spells with no target--	
-----------------------------------------
		elseif (event == "SPELL_CAST_SUCCESS") then
			---------------------------------------------------------------------------------------
			--Warrior: Challenging Shout/Shield Block/Shield Wall/Enraged Regeneration/Last Stand--
			---------------------------------------------------------------------------------------
			if class == "WARRIOR" then
				if (SkillSettings.ChallShout == 1 and spellID == 1161) or (SkillSettings.ShieldBlock == 1 and spellID == 2565) or (SkillSettings.ShieldWall == 1 and spellID == 871) or (SkillSettings.EnragRegen == 1 and spellID == 55694) or (SkillSettings.LastStand == 1 and spellID == 12975) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			
			------------------------------
			--Rogue: Tricks of the Trade--
			------------------------------
			elseif class == "ROGUE" then
				if (spellID == 57934) then
					if (SkillSettings.Tricks  == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.TricksW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				end
				
			---------------------------------------------------------------------------------------------------------
			--Death Knight: Hungering Cold/Icebound Fortitude/Vampiric Blood/Unbreakable Armor/Bone Shield/Hysteria--
			---------------------------------------------------------------------------------------------------------
			elseif class == "DEATHKNIGHT" then
				if (SkillSettings.HunCold == 1 and spellID == 49203) or (SkillSettings.IceFort == 1 and spellID == 48792) or (SkillSettings.VampBlood == 1 and spellID == 55233) or (SkillSettings.UnbArm == 1 and spellID == 51271) or (SkillSettings.BoneS == 1 and spellID == 49222)then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				elseif (spellID == 49016) then
					if (SkillSettings.Hysteria == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.HysteriaW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				end
		
			-------------------------------------------------
			--Hunter: Deterrence/Master's Call/Misdirection--
			-------------------------------------------------
			elseif class == "HUNTER" then
				if (SkillSettings.Deterrence == 1 and spellID == 19263) then 
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				elseif (spellID == 53271) then
					if (SkillSettings.MastersCall == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.MastersCallW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 34477) then
					if (SkillSettings.Misdirection == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.MisdirectionW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				end
				
			---------------------------------------------------
			--Warlock: Demonic Circle Teleport/Howl of Terror--
			---------------------------------------------------
			elseif class == "WARLOCK" then
				if (SkillSettings.Teleport == 1 and spellID == 48020) or (SkillSettings.Fear == 1 and spellID == 5484) or (SkillSettings.Fear == 1 and spellID == 17928) then 
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			---------------------------------------------------------------------------------------
			--Druid: Innervate/Challenging Roar/Barkskin/Frenzied Regeneration/Survival Instincts--
			---------------------------------------------------------------------------------------
			elseif class == "DRUID" then
				if (spellID == 29166) then 
					if (SkillSettings.Innervate == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.InnervateW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (SkillSettings.ChallRoar == 1 and spellID == 5209) or (SkillSettings.Barkskin == 1 and spellID == 22812) or (SkillSettings.FrenReg == 1 and spellID == 22842) or (SkillSettings.SurvInst == 1 and spellID == 61336) then 
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			-------------------------------------------------------------------------------------------------------------------
			--Paladin: Hand of Sacrifice/Hand of Salvation/Hand of Protection/Divine Protection/Divine Sacrifice/Aura Mastery--
			-------------------------------------------------------------------------------------------------------------------
			elseif class == "PALADIN" then
				if (spellID == 6940) then
					if (SkillSettings.HandOfSac == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.HandOfSacW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 1038) then
					if (SkillSettings.HandOfSalv == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.HandOfSalvW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 1022) or (spellID == 5599) or (spellID == 10278) then
					if (SkillSettings.HoP == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.HoPW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 633) or (spellID == 2800) or (spellID == 10310) or (spellID == 27154) or (spellID == 48788) then
					if (SkillSettings.LoH == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.LoHW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (SkillSettings.DivineProt == 1 and spellID == 498) or (SkillSettings.DivineSac == 1 and spellID == 64205) or (SkillSettings.Aura == 1 and spellID == 31821) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			------------------------------------------------------------------------------------
			--Priest: Pain Suppression/Guardian Spirit/Fear Ward/Power Infusion/Psychic Scream--
			------------------------------------------------------------------------------------
			elseif class == "PRIEST" then
				if (spellID == 33206) then
					if (SkillSettings.PainSupp == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.PainSuppW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 47788) then
					if (SkillSettings.Guardian == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.GuardianW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 6346) then
					if (SkillSettings.FearWard == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.FearWardW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (spellID == 10060) then
					if (SkillSettings.PowerInf == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.PowerInfW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				elseif (SkillSettings.DivineHymn == 1 and spellID == 64843) or (SkillSettings.HopeHymn == 1 and spellID == 64901) then
					self:SendText(GetSpellInfo(spellID), nil, spellID)
				elseif (SkillSettings.PsyScream == 1 and spellID == 8122) or (SkillSettings.PsyScream == 1 and spellID == 8124) or (SkillSettings.PsyScream == 1 and spellID == 10888) or (SkillSettings.PsyScream == 1 and spellID == 10890) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			end
			
-----------------
--Buffs/Debuffs--
-----------------	
		elseif (event == "SPELL_AURA_APPLIED") then
			-------------------
			--Warrior: Disarm--
			-------------------
			if class == "WARRIOR" then
				if (SkillSettings.Disarm == 1 and spellID == 676) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
		
			------------------------------
			--Rogue: Dismantle/Blind/Sap--
			------------------------------
			elseif class == "ROGUE" then
				if (SkillSettings.Dismantle == 1 and spellID == 51722) or (SkillSettings.Blind == 1 and spellID == 2094) or (SkillSettings.Sap == 1 and spellID == 51724) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
				
			-----------------------------
			--Death Knight: Strangulate--
			-----------------------------
			elseif class == "DEATHKNIGHT" then
				if (SkillSettings.Strangulate == 1 and spellID == 47476) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
				
			--------------------------------------
			--Hunter: Wywern Sting/Freezing Trap--
			--------------------------------------
			elseif class == "HUNTER" then
				if (SkillSettings.Wywern == 1 and spellID == 19386) or (SkillSettings.Wywern == 1 and spellID == 24132) or (SkillSettings.Wywern == 1 and spellID == 24133) or (SkillSettings.Wywern == 1 and spellID == 27068) or (SkillSettings.Wywern == 1 and spellID == 49011) or (SkillSettings.Wywern == 1 and spellID == 49012) or (SkillSettings.FreezeTrap == 1 and spellID == 55041) or (SkillSettings.FreezeTrap == 1 and spellID == 14309) or (SkillSettings.FreezeTrap == 1 and spellID == 14308) or (SkillSettings.FreezeTrap == 1 and spellID == 3355) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
				
			-----------------------------------------------------------------------
			--Mage: Polymorph: Pig/Rabbit/Serpent/Turkey/Turtle/Sheep/Cat/Silence--
			-----------------------------------------------------------------------
			elseif class == "MAGE" then
				if (SkillSettings.Polymorph == 1) then
					if (spellID == 118) or (spellID == 12824) or (spellID == 12825) or (spellID == 12826) or (spellID == 28272) or (spellID == 61721) or (spellID == 61025) or (spellID == 61780) or (spellID == 28271) or (spellID == 61305) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
				end
				if (SkillSettings.Silence == 1) then
					if (spellID == 55021) or (spellID == 18469) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
				end
				
			----------------------------------------
			--Warlock: Fear/Soulstone Resurrection--
			----------------------------------------
			elseif class == "WARLOCK" then
				if (SkillSettings.Fear == 1 and spellID == 5782) or (SkillSettings.Fear == 1 and spellID == 6213) or (SkillSettings.Fear == 1 and spellID == 6215) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				elseif (spellID == 20707) or (spellID == 20762) or (spellID == 20763) or (spellID == 20764) or (spellID == 20765) or (spellID == 27239) or (spellID == 47883) then
					if (SkillSettings.Soulstone == 1) then
						self:SendText(GetSpellInfo(spellID), targetName, spellID)
					end
					if (SkillSettings.SoulstoneW == 1) then
						self:WhisperText(GetSpellInfo(spellID), targetName, spellID, targetGUID)
					end
				end
				
			--------------------------------------------------
			--Druid: Hibernate/Cyclone/Entangling Roots/Bash--
			--------------------------------------------------
			elseif class == "DRUID" then
				if (SkillSettings.Hibernate == 1 and spellID == 2637) or (SkillSettings.Hibernate == 1 and spellID == 18657) or (SkillSettings.Hibernate == 1 and spellID == 18658) or (SkillSettings.Cyclone == 1 and spellID == 33786) or (SkillSettings.Roots == 1 and spellID == 339) or (SkillSettings.Roots == 1 and spellID == 1062) or (SkillSettings.Roots == 1 and spellID == 5195) or (SkillSettings.Roots == 1 and spellID == 5196) or (SkillSettings.Roots == 1 and spellID == 9852) or (SkillSettings.Roots == 1 and spellID == 9853) or (SkillSettings.Roots == 1 and spellID == 26989) or (SkillSettings.Roots == 1 and spellID == 53308) or (SkillSettings.Bash == 1 and spellID == 5211) or (SkillSettings.Bash == 1 and spellID == 6798) or (SkillSettings.Bash == 1 and spellID == 8983) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
				
			----------------------------------------------------------------------------------
			--Paladin: Repentance/Hammer of Justice/Avenger's Shield silence/Ardent Defender--
			----------------------------------------------------------------------------------
			elseif class == "PALADIN" then
				if (SkillSettings.Repentance == 1 and spellID == 20066) or (SkillSettings.Hammer == 1 and spellID == 853) or (SkillSettings.Hammer == 1 and spellID == 5588) or (SkillSettings.Hammer == 1 and spellID == 5589) or (SkillSettings.Hammer == 1 and spellID == 10308) or (SkillSettings.Shield == 1 and spellID == 63529) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				elseif (SkillSettings.Ardent == 1 and spellID == 66233) then
					self:SendText(GetSpellInfo(spellID), nil, spellID)
				end
			---------------------------------------
			--Priest: Shackle Undead/Mind Control--
			---------------------------------------
			elseif class == "PRIEST" then
				if (SkillSettings.Shackle == 1 and spellID == 9484) or (SkillSettings.Shackle == 1 and spellID == 9485) or (SkillSettings.Shackle == 1 and spellID == 10955) or (SkillSettings.MindCon == 1 and spellID == 605) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			---------------
			--Shaman: Hex--
			---------------
			elseif class == "SHAMAN" then
				if (SkillSettings.Hex == 1 and spellID == 51514) then
					self:SendText(GetSpellInfo(spellID), targetName, spellID)
				end
			end
		elseif (event == "SPELL_STOLEN") then
			if class == "MAGE" then
				if (SkillSettings.Spellsteal == 1 and spellID == 30449) then
					stolen = 1
					self:SendText(GetSpellInfo(otherspellID), targetName, otherspellID)
				end
			end
		end
	end
end

----------------
--Options menu--
----------------

function Announce:CreateSettingsMenu()
	Announce.Config = CreateFrame("Frame", "Announce.Config", UIParent);
	Announce.Config.name = "Announce";

	local ConfigLayout = {
		----------------
		--Skills' text--
		----------------
		Warrior = { Ftype = "FontString", Location = "CENTER", Xoff = -125, Yoff = 203, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Warrior",
				},
		ChallShout = { Ftype = "FontString", Location = "CENTER", Xoff = -120, Yoff = 185, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Chall. Shout",
				},
		Disarm = { Ftype = "FontString", Location = "CENTER", Xoff = -135, Yoff = 170, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Disarm",
				},
		EnragRegen = { Ftype = "FontString", Location = "CENTER", Xoff = -116, Yoff = 155, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Enraged Reg.",
				},
		LastStand = { Ftype = "FontString", Location = "CENTER", Xoff = -123, Yoff = 140, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Last Stand",
				},
		Reflect = { Ftype = "FontString", Location = "CENTER", Xoff = -119, Yoff = 125, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Spell Reflect",
				},
		ShattThrow = { Ftype = "FontString", Location = "CENTER", Xoff = -118, Yoff = 110, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Shatt. Throw",
				},
		ShieldBlock = { Ftype = "FontString", Location = "CENTER", Xoff = -120, Yoff = 95, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Shield Block",
				},
		ShieldWall = { Ftype = "FontString", Location = "CENTER", Xoff = -123, Yoff = 80, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Shield Wall",
				},

		Rogue = { Ftype = "FontString", Location = "CENTER", Xoff = 5, Yoff = 203, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Rogue",
				},
		Tricks = { Ftype = "FontString", Location = "CENTER", Xoff = -11, Yoff = 185, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Tricks",
				},
		Blind = { Ftype = "FontString", Location = "CENTER", Xoff = -12, Yoff = 170, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Blind",
				},
		Dismantle = { Ftype = "FontString", Location = "CENTER", Xoff = 4, Yoff = 155, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Dismantle",
				},		
		Sap = { Ftype = "FontString", Location = "CENTER", Xoff = -15, Yoff = 140, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Sap",
				},		

		DeathKnight = { Ftype = "FontString", Location = "CENTER", Xoff = 130, Yoff = 202, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Death Knight",
				},
		Hysteria = { Ftype = "FontString", Location = "CENTER", Xoff = 128, Yoff = 185, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hysteria",
				},
		BoneS = { Ftype = "FontString", Location = "CENTER", Xoff = 139, Yoff = 170, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Bone Shield",
				},
		Gnaw = { Ftype = "FontString", Location = "CENTER", Xoff = 122, Yoff = 155, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Gnaw",
				},
		HunCold = { Ftype = "FontString", Location = "CENTER", Xoff = 151, Yoff = 140, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hungering Cold",
				},		
		IceFort= { Ftype = "FontString", Location = "CENTER", Xoff = 149, Yoff = 125, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Icebound. Fort.",
				},
		Strangulate = { Ftype = "FontString", Location = "CENTER", Xoff = 139, Yoff = 110, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Strangulate",
				},
		UnbArm = { Ftype = "FontString", Location = "CENTER", Xoff = 139, Yoff = 95, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Unb. Armor",
				},
		VampBlood = { Ftype = "FontString", Location = "CENTER", Xoff = 142, Yoff = 80, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Vamp. Blood",
				},
		
		Warlock = { Ftype = "FontString", Location = "CENTER", Xoff = -125, Yoff = 65, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Warlock",
				},
		Soulstone = { Ftype = "FontString", Location = "CENTER", Xoff = -128, Yoff = 50, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Soulstone",
				},
		Fear = { Ftype = "FontString", Location = "CENTER", Xoff = -125, Yoff = 35, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Fear/Howl",
				},		
		Spelllock = { Ftype = "FontString", Location = "CENTER", Xoff = -122, Yoff = 20, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Silence - SL",
				},		
		Teleport = { Ftype = "FontString", Location = "CENTER", Xoff = -132, Yoff = 5, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Teleport",
				},
		
		Hunter = { Ftype = "FontString", Location = "CENTER", Xoff = 5, Yoff = 125, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Hunter",
				},
		MastersCall = { Ftype = "FontString", Location = "CENTER", Xoff = 16, Yoff = 110, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Master's Call",
				},
		Misdirection = { Ftype = "FontString", Location = "CENTER", Xoff = 13, Yoff = 95, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Misdirection",
				},
		Deterrence = { Ftype = "FontString", Location = "CENTER", Xoff = 7, Yoff = 80, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Deterrence",
				},
		FreezeTrap = { Ftype = "FontString", Location = "CENTER", Xoff = 15, Yoff = 65, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Freezing Trap",
				},
		Wywern = { Ftype = "FontString", Location = "CENTER", Xoff = 17, Yoff = 50, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Wywern Sting",
				},

		Mage = { Ftype = "FontString", Location = "CENTER", Xoff = 130, Yoff = 65, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Mage",
				},
		Polymorph = { Ftype = "FontString", Location = "CENTER", Xoff = 137, Yoff = 50, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Polymorph",
				},
		Silence = { Ftype = "FontString", Location = "CENTER", Xoff = 140, Yoff = 35, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Silence - CS",
				},
		Spellsteal = { Ftype = "FontString", Location = "CENTER", Xoff = 133, Yoff = 20, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Spellsteal",
				},

		Shaman = { Ftype = "FontString", Location = "CENTER", Xoff = 130, Yoff = 5, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Shaman",
				},
		Grounding = { Ftype = "FontString", Location = "CENTER", Xoff = 148, Yoff = -10, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Grounding Tot.",
				},
		Hex = { Ftype = "FontString", Location = "CENTER", Xoff = 117, Yoff = -25, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hex",
				},
		Reincarnation = { Ftype = "FontString", Location = "CENTER", Xoff = 146, Yoff = -40, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Reincarnation",
				},
				
		Priest = { Ftype = "FontString", Location = "CENTER", Xoff = 131, Yoff = -55, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Priest",
				},
		FearWard = { Ftype = "FontString", Location = "CENTER", Xoff = 135, Yoff = -70, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Fear Ward",
				},
		Guardian = { Ftype = "FontString", Location = "CENTER", Xoff = 149, Yoff = -85, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Guardian Spirit",
				},
		PainSupp = { Ftype = "FontString", Location = "CENTER", Xoff = 136, Yoff = -100, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Pain Supp.",
				},
		PowerInf = { Ftype = "FontString", Location = "CENTER", Xoff = 143, Yoff = -115, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Power Infus.",
				},
		DivineHymn = { Ftype = "FontString", Location = "CENTER", Xoff = 145, Yoff = -130, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Divine Hymn",
				},
		HopeHymn = { Ftype = "FontString", Location = "CENTER", Xoff = 149, Yoff = -145, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hymn of Hope",
				},
		MindCon = { Ftype = "FontString", Location = "CENTER", Xoff = 144, Yoff = -160, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Mind Control",
				},
		PsyScream = { Ftype = "FontString", Location = "CENTER", Xoff = 149, Yoff = -175, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Psych. Scream",
				},
		Shackle = { Ftype = "FontString", Location = "CENTER", Xoff = 144, Yoff = -190, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Shackle Und.",
				},
		
		Paladin = { Ftype = "FontString", Location = "CENTER", Xoff = 5, Yoff = 35, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Paladin",
				},
		HandOfSac = { Ftype = "FontString", Location = "CENTER", Xoff = 12, Yoff = 20, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hand of Sac.",
				},
		HandOfSalv = { Ftype = "FontString", Location = "CENTER", Xoff = 14, Yoff = 5, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hand of Salv.",
				},
		HoP = { Ftype = "FontString", Location = "CENTER", Xoff = 13, Yoff = -10, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hand of Prot.",
				},
		LoH = { Ftype = "FontString", Location = "CENTER", Xoff = 16, Yoff = -25, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Lay on Hands",
				},
		Ardent = { Ftype = "FontString", Location = "CENTER", Xoff = 10, Yoff = -40, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Ardent Def.",
				},
		Aura = { Ftype = "FontString", Location = "CENTER", Xoff = 17, Yoff = -55, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Aura Mastery",
				},
		DivineProt = { Ftype = "FontString", Location = "CENTER", Xoff = 10, Yoff = -70, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Divine Prot.",
				},
		DivineSac = { Ftype = "FontString", Location = "CENTER", Xoff = 13, Yoff = -85, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Divine Sacri.",
				},				
		Hammer = { Ftype = "FontString", Location = "CENTER", Xoff = 15, Yoff = -100, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hammer of J.",
				},	
		Repentance = { Ftype = "FontString", Location = "CENTER", Xoff = 11, Yoff = -115, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Repentance",
				},
		Shield = { Ftype = "FontString", Location = "CENTER", Xoff = 11, Yoff = -130, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Silence - AS",
				},
		
		Druid = { Ftype = "FontString", Location = "CENTER", Xoff = -130, Yoff = -10, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Druid",
				},
		Innervate = { Ftype = "FontString", Location = "CENTER", Xoff = -126, Yoff = -25, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Innervate",
				},
		Rebirth = { Ftype = "FontString", Location = "CENTER", Xoff = -134, Yoff = -40, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Rebirth",
				},
		Barkskin = { Ftype = "FontString", Location = "CENTER", Xoff = -131, Yoff = -55, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Barkskin",
				},
		Bash = { Ftype = "FontString", Location = "CENTER", Xoff = -141, Yoff = -70, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Bash",
				},
		ChallRoar = { Ftype = "FontString", Location = "CENTER", Xoff = -123, Yoff = -85, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Chall. Roar",
				},
		Cyclone = { Ftype = "FontString", Location = "CENTER", Xoff = -132, Yoff = -100, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Cyclone",
				},
		Roots = { Ftype = "FontString", Location = "CENTER", Xoff = -126, Yoff = -115, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Ent. Roots",
				},
		FrenReg = { Ftype = "FontString", Location = "CENTER", Xoff = -118, Yoff = -130, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Fren. Regen.",
				},
		Hibernate = { Ftype = "FontString", Location = "CENTER", Xoff = -126, Yoff = -145, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Hibernate",
				},
		SurvInst = { Ftype = "FontString", Location = "CENTER", Xoff = -125, Yoff = -160, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 100, Height = 15, StringVal = "Surv. Inst.",
				},
		
		
		----------------
		--Options text--
		----------------

		Options1 = { Ftype = "FontString", Location = "CENTER", Xoff = -5, Yoff = -150, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 400, Height = 15, StringVal = "Chat settings: /anno",
				},
		Options2 = { Ftype = "FontString", Location = "CENTER", Xoff = -5, Yoff = -165, Parent = Announce.Config,
				R = 1, G = 1, B = 1, Width = 400, Height = 15, StringVal = "Left: Whisper; Right: Chat",
				},
				
				
		-------------------
		--Skills' buttons--
		-------------------
		ChallShoutB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ChallShoutB", Location = "CENTER", Xoff = -170, Yoff = 185, Parent = Announce.Config, variable = SkillSettings.ChallShout,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ChallShoutB"]:GetChecked() == 1 then SkillSettings.ChallShout = 0 else SkillSettings.ChallShout = 1 end	end},
				},
		DisarmB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "DisarmB", Location = "CENTER", Xoff = -170, Yoff = 170, Parent = Announce.Config, variable = SkillSettings.Disarm,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["DisarmB"]:GetChecked() == 1 then SkillSettings.Disarm = 0 else SkillSettings.Disarm = 1 end	end},
				},
		EnragRegenB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "EnragRegenB", Location = "CENTER", Xoff = -170, Yoff = 155, Parent = Announce.Config, variable = SkillSettings.EnragRegen,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["EnragRegenB"]:GetChecked() == 1 then SkillSettings.EnragRegen = 0 else SkillSettings.EnragRegen = 1 end	end},
				},
		LastStandB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "LastStandB", Location = "CENTER", Xoff = -170, Yoff = 140, Parent = Announce.Config, variable = SkillSettings.LastStand,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["LastStandB"]:GetChecked() == 1 then SkillSettings.LastStand = 0 else SkillSettings.LastStand = 1 end	end},
				},
		ReflectB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ReflectB", Location = "CENTER", Xoff = -170, Yoff = 125, Parent = Announce.Config, variable = SkillSettings.Reflect,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ReflectB"]:GetChecked() == 1 then SkillSettings.Reflect = 0 else SkillSettings.Reflect = 1 end	end},
				},
		ShattThrowB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ShattThrowB", Location = "CENTER", Xoff = -170, Yoff = 110, Parent = Announce.Config, variable = SkillSettings.ShattThrow,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ShattThrowB"]:GetChecked() == 1 then SkillSettings.ShattThrow = 0 else SkillSettings.ShattThrow = 1 end	end},
				},				
		ShieldBlockB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ShieldBlockB", Location = "CENTER", Xoff = -170, Yoff = 95, Parent = Announce.Config, variable = SkillSettings.ShieldBlock,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ShieldBlockB"]:GetChecked() == 1 then SkillSettings.ShieldBlock = 0 else SkillSettings.ShieldBlock = 1 end	end},
				},
		ShieldWallB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ShieldWallB", Location = "CENTER", Xoff = -170, Yoff = 80, Parent = Announce.Config, variable = SkillSettings.ShieldWall,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ShieldWallB"]:GetChecked() == 1 then SkillSettings.ShieldWall = 0 else SkillSettings.ShieldWall = 1 end	end},
				},		

		TricksB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "TricksB", Location = "CENTER", Xoff = -40, Yoff = 185, Parent = Announce.Config, variable = SkillSettings.Tricks,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["TricksB"]:GetChecked() == 1 then SkillSettings.Tricks = 0 else SkillSettings.Tricks = 1 end	end},
				},
		TricksWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "TricksWB", Location = "CENTER", Xoff = -60, Yoff = 185, Parent = Announce.Config, variable = SkillSettings.TricksW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["TricksWB"]:GetChecked() == 1 then SkillSettings.TricksW = 0 else SkillSettings.TricksW = 1 end	end},
				},
		BlindB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "BlindB", Location = "CENTER", Xoff = -40, Yoff = 170, Parent = Announce.Config, variable = SkillSettings.Blind,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["BlindB"]:GetChecked() == 1 then SkillSettings.Blind = 0 else SkillSettings.Blind = 1 end	end},
				},
		DismantleB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "DismantleB", Location = "CENTER", Xoff = -40, Yoff = 155, Parent = Announce.Config, variable = SkillSettings.Dismantle,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["DismantleB"]:GetChecked() == 1 then SkillSettings.Dismantle = 0 else SkillSettings.Dismantle = 1 end	end},
				},		
		SapB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SapB", Location = "CENTER", Xoff = -40, Yoff = 140, Parent = Announce.Config, variable = SkillSettings.Sap,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SapB"]:GetChecked() == 1 then SkillSettings.Sap = 0 else SkillSettings.Sap = 1 end	end},
				},
					
		HysteriaB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HysteriaB", Location = "CENTER", Xoff = 90, Yoff = 185, Parent = Announce.Config, variable = SkillSettings.Hysteria,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HysteriaB"]:GetChecked() == 1 then SkillSettings.Hysteria = 0 else SkillSettings.Hysteria = 1 end	end},
				},
		HysteriaWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HysteriaWB", Location = "CENTER", Xoff = 70, Yoff = 185, Parent = Announce.Config, variable = SkillSettings.HysteriaW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HysteriaWB"]:GetChecked() == 1 then SkillSettings.HysteriaW = 0 else SkillSettings.HysteriaW = 1 end	end},
				},					
		BoneSB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "BoneSB", Location = "CENTER", Xoff = 90, Yoff = 170, Parent = Announce.Config, variable = SkillSettings.BoneS,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["BoneSB"]:GetChecked() == 1 then SkillSettings.BoneS = 0 else SkillSettings.BoneS = 1 end	end},
				},
		GnawB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "GnawB", Location = "CENTER", Xoff = 90, Yoff = 155, Parent = Announce.Config, variable = SkillSettings.Gnaw,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["GnawB"]:GetChecked() == 1 then SkillSettings.Gnaw = 0 else SkillSettings.Gnaw = 1 end	end},
				},
		HunColdB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HunColdB", Location = "CENTER", Xoff = 90, Yoff = 140, Parent = Announce.Config, variable = SkillSettings.HunCold,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HunColdB"]:GetChecked() == 1 then SkillSettings.HunCold = 0 else SkillSettings.HunCold = 1 end	end},
				},		
		IceFortB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "IceFortB", Location = "CENTER", Xoff = 90, Yoff = 125, Parent = Announce.Config, variable = SkillSettings.IceFort,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["IceFortB"]:GetChecked() == 1 then SkillSettings.IceFort = 0 else SkillSettings.IceFort = 1 end	end},
				},
		StrangulateB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "StrangulateB", Location = "CENTER", Xoff = 90, Yoff = 110, Parent = Announce.Config, variable = SkillSettings.Strangulate,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["StrangulateB"]:GetChecked() == 1 then SkillSettings.Strangulate = 0 else SkillSettings.Strangulate = 1 end	end},
				},		
		UnbArmB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "UnbArmB", Location = "CENTER", Xoff = 90, Yoff = 95, Parent = Announce.Config, variable = SkillSettings.UnbArm,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["UnbArmB"]:GetChecked() == 1 then SkillSettings.UnbArm = 0 else SkillSettings.UnbArm = 1 end	end},
				},
		VampBloodB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "VampBloodB", Location = "CENTER", Xoff = 90, Yoff = 80, Parent = Announce.Config, variable = SkillSettings.VampBlood,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["VampBloodB"]:GetChecked() == 1 then SkillSettings.VampBlood = 0 else SkillSettings.VampBlood = 1 end	end},
				},
		
		SoulstoneB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SoulstoneB", Location = "CENTER", Xoff = -170, Yoff = 50, Parent = Announce.Config, variable = SkillSettings.Soulstone,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SoulstoneB"]:GetChecked() == 1 then SkillSettings.Soulstone = 0 else SkillSettings.Soulstone = 1 end	end},
				},
		SoulstoneWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SoulstoneWB", Location = "CENTER", Xoff = -190, Yoff = 50, Parent = Announce.Config, variable = SkillSettings.SoulstoneW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SoulstoneWB"]:GetChecked() == 1 then SkillSettings.SoulstoneW = 0 else SkillSettings.SoulstoneW = 1 end	end},
				},		
		FearB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "FearB", Location = "CENTER", Xoff = -170, Yoff = 35, Parent = Announce.Config, variable = SkillSettings.Fear,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["FearB"]:GetChecked() == 1 then SkillSettings.Fear = 0 else SkillSettings.Fear = 1 end	end},
				},		
		SpelllockB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SpelllockB", Location = "CENTER", Xoff = -170, Yoff = 20, Parent = Announce.Config, variable = SkillSettings.Spelllock,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SpelllockB"]:GetChecked() == 1 then SkillSettings.Spelllock = 0 else SkillSettings.Spelllock = 1 end	end},
				},		
		TeleportB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "TeleportB", Location = "CENTER", Xoff = -170, Yoff = 5, Parent = Announce.Config, variable = SkillSettings.Teleport,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["TeleportB"]:GetChecked() == 1 then SkillSettings.Teleport = 0 else SkillSettings.Teleport = 1 end	end},
				},
				
		MastersCallB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "MastersCallB", Location = "CENTER", Xoff = -40, Yoff = 110, Parent = Announce.Config, variable = SkillSettings.MastersCall,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["MastersCallB"]:GetChecked() == 1 then SkillSettings.MastersCall = 0 else SkillSettings.MastersCall = 1 end	end},
				},
		MastersCallWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "MastersCallWB", Location = "CENTER", Xoff = -60, Yoff = 110, Parent = Announce.Config, variable = SkillSettings.MastersCallW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["MastersCallWB"]:GetChecked() == 1 then SkillSettings.MastersCallW = 0 else SkillSettings.MastersCallW = 1 end	end},
				},
		MisdirectionB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "MisdirectionB", Location = "CENTER", Xoff = -40, Yoff = 95, Parent = Announce.Config, variable = SkillSettings.Misdirection,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["MisdirectionB"]:GetChecked() == 1 then SkillSettings.Misdirection = 0 else SkillSettings.Misdirection = 1 end	end},
				},
		MisdirectionWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "MisdirectionWB", Location = "CENTER", Xoff = -60, Yoff = 95, Parent = Announce.Config, variable = SkillSettings.MisdirectionW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["MisdirectionWB"]:GetChecked() == 1 then SkillSettings.MisdirectionW = 0 else SkillSettings.MisdirectionW = 1 end	end},
				},
		DeterrenceB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "DeterrenceB", Location = "CENTER", Xoff = -40, Yoff = 80, Parent = Announce.Config, variable = SkillSettings.Deterrence,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["DeterrenceB"]:GetChecked() == 1 then SkillSettings.Deterrence = 0 else SkillSettings.Deterrence = 1 end	end},
				},
		FreezeTrapB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "FreezeTrapB", Location = "CENTER", Xoff = -40, Yoff = 65, Parent = Announce.Config, variable = SkillSettings.FreezeTrap,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["FreezeTrapB"]:GetChecked() == 1 then SkillSettings.FreezeTrap = 0 else SkillSettings.FreezeTrap = 1 end	end},
				},
		WywernB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "WywernB", Location = "CENTER", Xoff = -40, Yoff = 50, Parent = Announce.Config, variable = SkillSettings.Wywern,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["WywernB"]:GetChecked() == 1 then SkillSettings.Wywern = 0 else SkillSettings.Wywern = 1 end	end},
				},
				
		PolymorphB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "PolymorphB", Location = "CENTER", Xoff = 90, Yoff = 50, Parent = Announce.Config, variable = SkillSettings.Polymorph,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["PolymorphB"]:GetChecked() == 1 then SkillSettings.Polymorph = 0 else SkillSettings.Polymorph = 1 end	end},
				},
		SilenceB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SilenceB", Location = "CENTER", Xoff = 90, Yoff = 35, Parent = Announce.Config, variable = SkillSettings.Silence,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SilenceB"]:GetChecked() == 1 then SkillSettings.Silence = 0 else SkillSettings.Silence = 1 end	end},
				},
		SpellstealB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SpellstealB", Location = "CENTER", Xoff = 90, Yoff = 20, Parent = Announce.Config, variable = SkillSettings.Spellsteal,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SpellstealB"]:GetChecked() == 1 then SkillSettings.Spellsteal = 0 else SkillSettings.Spellsteal = 1 end	end},
				},
		
		GroundingB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "GroundingB", Location = "CENTER", Xoff = 90, Yoff = -10, Parent = Announce.Config, variable = SkillSettings.Grounding,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["GroundingB"]:GetChecked() == 1 then SkillSettings.Grounding = 0 else SkillSettings.Grounding = 1 end	end},
				},
		HexB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HexB", Location = "CENTER", Xoff = 90, Yoff = -25, Parent = Announce.Config, variable = SkillSettings.Hex,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HexB"]:GetChecked() == 1 then SkillSettings.Hex = 0 else SkillSettings.Hex = 1 end	end},
				},
		ReincarnationB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ReincarnationB", Location = "CENTER", Xoff = 90, Yoff = -40, Parent = Announce.Config, variable = SkillSettings.Reincarnation,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ReincarnationB"]:GetChecked() == 1 then SkillSettings.Reincarnation = 0 else SkillSettings.Reincarnation = 1 end	end},
				},

		FearWardB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "FearWardB", Location = "CENTER", Xoff = 90, Yoff = -70, Parent = Announce.Config, variable = SkillSettings.FearWard,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["FearWardB"]:GetChecked() == 1 then SkillSettings.FearWard = 0 else SkillSettings.FearWard = 1 end	end},
				},
		FearWardWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "FearWardWB", Location = "CENTER", Xoff = 70, Yoff = -70, Parent = Announce.Config, variable = SkillSettings.FearWardW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["FearWardWB"]:GetChecked() == 1 then SkillSettings.FearWardW = 0 else SkillSettings.FearWardW = 1 end	end},
				},
		GuardianB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "GuardianB", Location = "CENTER", Xoff = 90, Yoff = -85, Parent = Announce.Config, variable = SkillSettings.Guardian,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["GuardianB"]:GetChecked() == 1 then SkillSettings.Guardian = 0 else SkillSettings.Guardian = 1 end	end},
				},
		GuardianWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "GuardianWB", Location = "CENTER", Xoff = 70, Yoff = -85, Parent = Announce.Config, variable = SkillSettings.GuardianW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["GuardianWB"]:GetChecked() == 1 then SkillSettings.GuardianW = 0 else SkillSettings.GuardianW = 1 end	end},
				},
		PainSuppB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "PainSuppB", Location = "CENTER", Xoff = 90, Yoff = -100, Parent = Announce.Config, variable = SkillSettings.PainSupp,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["PainSuppB"]:GetChecked() == 1 then SkillSettings.PainSupp = 0 else SkillSettings.PainSupp = 1 end	end},
				},
		PainSuppWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "PainSuppWB", Location = "CENTER", Xoff = 70, Yoff = -100, Parent = Announce.Config, variable = SkillSettings.PainSuppW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["PainSuppWB"]:GetChecked() == 1 then SkillSettings.PainSuppW = 0 else SkillSettings.PainSuppW = 1 end	end},
				},
		PowerInfB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "PowerInfB", Location = "CENTER", Xoff = 90, Yoff = -115, Parent = Announce.Config, variable = SkillSettings.PowerInf,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["PowerInfB"]:GetChecked() == 1 then SkillSettings.PowerInf = 0 else SkillSettings.PowerInf = 1 end	end},
				},
		PowerInfWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "PowerInfWB", Location = "CENTER", Xoff = 70, Yoff = -115, Parent = Announce.Config, variable = SkillSettings.PowerInfW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["PowerInfWB"]:GetChecked() == 1 then SkillSettings.PowerInfW = 0 else SkillSettings.PowerInfW = 1 end	end},
				},
		DivineHymnB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "DivineHymnB", Location = "CENTER", Xoff = 90, Yoff = -130, Parent = Announce.Config, variable = SkillSettings.DivineHymn,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["DivineHymnB"]:GetChecked() == 1 then SkillSettings.DivineHymn = 0 else SkillSettings.DivineHymn = 1 end	end},
				},
		HopeHymnB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HopeHymnB", Location = "CENTER", Xoff = 90, Yoff = -145, Parent = Announce.Config, variable = SkillSettings.HopeHymn,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HopeHymnB"]:GetChecked() == 1 then SkillSettings.HopeHymn = 0 else SkillSettings.HopeHymn = 1 end	end},
				},
		MindConB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "MindConB", Location = "CENTER", Xoff = 90, Yoff = -160, Parent = Announce.Config, variable = SkillSettings.MindCon,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["MindConB"]:GetChecked() == 1 then SkillSettings.MindCon = 0 else SkillSettings.MindCon = 1 end	end},
				},
		PsyScreamB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "PsyScreamB", Location = "CENTER", Xoff = 90, Yoff = -175, Parent = Announce.Config, variable = SkillSettings.PsyScream,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["PsyScreamB"]:GetChecked() == 1 then SkillSettings.PsyScream = 0 else SkillSettings.PsyScream = 1 end	end},
				},
		ShackleB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ShackleB", Location = "CENTER", Xoff = 90, Yoff = -190, Parent = Announce.Config, variable = SkillSettings.Shackle,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ShackleB"]:GetChecked() == 1 then SkillSettings.Shackle = 0 else SkillSettings.Shackle = 1 end	end},
				},
		
		HandOfSacB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HandOfSacB", Location = "CENTER", Xoff = -40, Yoff = 20, Parent = Announce.Config, variable = SkillSettings.HandOfSac,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HandOfSacB"]:GetChecked() == 1 then SkillSettings.HandOfSac = 0 else SkillSettings.HandOfSac = 1 end	end},
				},
		HandOfSacWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HandOfSacWB", Location = "CENTER", Xoff = -60, Yoff = 20, Parent = Announce.Config, variable = SkillSettings.HandOfSacW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HandOfSacWB"]:GetChecked() == 1 then SkillSettings.HandOfSacW = 0 else SkillSettings.HandOfSacW = 1 end	end},
				},			
		HandOfSalvB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HandOfSalvB", Location = "CENTER", Xoff = -40, Yoff = 5, Parent = Announce.Config, variable = SkillSettings.HandOfSalv,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HandOfSalvB"]:GetChecked() == 1 then SkillSettings.HandOfSalv = 0 else SkillSettings.HandOfSalv = 1 end	end},
				},
		HandOfSalvWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HandOfSalvWB", Location = "CENTER", Xoff = -60, Yoff = 5, Parent = Announce.Config, variable = SkillSettings.HandOfSalvW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HandOfSalvWB"]:GetChecked() == 1 then SkillSettings.HandOfSalvW = 0 else SkillSettings.HandOfSalvW = 1 end	end},
				},
		HoPB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HoPB", Location = "CENTER", Xoff = -40, Yoff = -10, Parent = Announce.Config, variable = SkillSettings.HoP,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HoPB"]:GetChecked() == 1 then SkillSettings.HoP = 0 else SkillSettings.HoP = 1 end	end},
				},
		HoPWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HoPWB", Location = "CENTER", Xoff = -60, Yoff = -10, Parent = Announce.Config, variable = SkillSettings.HoPW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HoPWB"]:GetChecked() == 1 then SkillSettings.HoPW = 0 else SkillSettings.HoPW = 1 end	end},
				},
		LoHB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "LoHB", Location = "CENTER", Xoff = -40, Yoff = -25, Parent = Announce.Config, variable = SkillSettings.LoH,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["LoHB"]:GetChecked() == 1 then SkillSettings.LoH = 0 else SkillSettings.LoH = 1 end	end},
				},
		LoHWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "LoHWB", Location = "CENTER", Xoff = -60, Yoff = -25, Parent = Announce.Config, variable = SkillSettings.LoHW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["LoHWB"]:GetChecked() == 1 then SkillSettings.LoHW = 0 else SkillSettings.LoHW = 1 end	end},
				},
		ArdentB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ArdentB", Location = "CENTER", Xoff = -40, Yoff = -40, Parent = Announce.Config, variable = SkillSettings.Ardent,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ArdentB"]:GetChecked() == 1 then SkillSettings.Ardent = 0 else SkillSettings.Ardent = 1 end	end},
				},
		AuraB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "AuraB", Location = "CENTER", Xoff = -40, Yoff = -55, Parent = Announce.Config, variable = SkillSettings.Aura,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["AuraB"]:GetChecked() == 1 then SkillSettings.Aura = 0 else SkillSettings.Aura = 1 end	end},
				},
		DivineProtB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "DivineProtB", Location = "CENTER", Xoff = -40, Yoff = -70, Parent = Announce.Config, variable = SkillSettings.DivineProt,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["DivineProtB"]:GetChecked() == 1 then SkillSettings.DivineProt = 0 else SkillSettings.DivineProt = 1 end	end},
				},
		DivineSacB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "DivineSacB", Location = "CENTER", Xoff = -40, Yoff = -85, Parent = Announce.Config, variable = SkillSettings.DivineSac,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["DivineSacB"]:GetChecked() == 1 then SkillSettings.DivineSac = 0 else SkillSettings.DivineSac = 1 end	end},
				},
		HammerB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HammerB", Location = "CENTER", Xoff = -40, Yoff = -100, Parent = Announce.Config, variable = SkillSettings.Hammer,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HammerB"]:GetChecked() == 1 then SkillSettings.Hammer = 0 else SkillSettings.Hammer = 1 end	end},
				},		
		RepentanceB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "RepentanceB", Location = "CENTER", Xoff = -40, Yoff = -115, Parent = Announce.Config, variable = SkillSettings.Repentance,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["RepentanceB"]:GetChecked() == 1 then SkillSettings.Repentance = 0 else SkillSettings.Repentance = 1 end	end},
				},
		ShieldB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ShieldB", Location = "CENTER", Xoff = -40, Yoff = -130, Parent = Announce.Config, variable = SkillSettings.Shield,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ShieldB"]:GetChecked() == 1 then SkillSettings.Shield = 0 else SkillSettings.Shield = 1 end	end},
				},
		
		InnervateB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "InnervateB", Location = "CENTER", Xoff = -170, Yoff = -25, Parent = Announce.Config, variable = SkillSettings.Innervate,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["InnervateB"]:GetChecked() == 1 then SkillSettings.Innervate = 0 else SkillSettings.Innervate = 1 end	end},
				},
		InnervateWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "InnervateWB", Location = "CENTER", Xoff = -190, Yoff = -25, Parent = Announce.Config, variable = SkillSettings.InnervateW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["InnervateWB"]:GetChecked() == 1 then SkillSettings.InnervateW = 0 else SkillSettings.InnervateW = 1 end	end},
				},
		RebirthB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "RebirthB", Location = "CENTER", Xoff = -170, Yoff = -40, Parent = Announce.Config, variable = SkillSettings.Rebirth,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["RebirthB"]:GetChecked() == 1 then SkillSettings.Rebirth = 0 else SkillSettings.Rebirth = 1 end	end},
				},
		RebirthWB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "RebirthWB", Location = "CENTER", Xoff = -190, Yoff = -40, Parent = Announce.Config, variable = SkillSettings.RebirthW,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["RebirthWB"]:GetChecked() == 1 then SkillSettings.RebirthW = 0 else SkillSettings.RebirthW = 1 end	end},
				},
		BarkskinB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "BarkskinB", Location = "CENTER", Xoff = -170, Yoff = -55, Parent = Announce.Config, variable = SkillSettings.Barkskin,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["BarkskinB"]:GetChecked() == 1 then SkillSettings.Barkskin = 0 else SkillSettings.Barkskin = 1 end	end},
				},
		BashB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "BashB", Location = "CENTER", Xoff = -170, Yoff = -70, Parent = Announce.Config, variable = SkillSettings.Bash,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["BashB"]:GetChecked() == 1 then SkillSettings.Bash = 0 else SkillSettings.Bash = 1 end	end},
				},
		ChallRoarB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "ChallRoarB", Location = "CENTER", Xoff = -170, Yoff = -85, Parent = Announce.Config, variable = SkillSettings.ChallRoar,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["ChallRoarB"]:GetChecked() == 1 then SkillSettings.ChallRoar = 0 else SkillSettings.ChallRoar = 1 end	end},
				},				
		CycloneB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "CycloneB", Location = "CENTER", Xoff = -170, Yoff = -100, Parent = Announce.Config, variable = SkillSettings.Cyclone,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["CycloneB"]:GetChecked() == 1 then SkillSettings.Cyclone = 0 else SkillSettings.Cyclone = 1 end	end},
				},
		RootsB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "RootsB", Location = "CENTER", Xoff = -170, Yoff = -115, Parent = Announce.Config, variable = SkillSettings.Roots,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["RootsB"]:GetChecked() == 1 then SkillSettings.Roots = 0 else SkillSettings.Roots = 1 end	end},
				},
		FrenRegB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "FrenRegB", Location = "CENTER", Xoff = -170, Yoff = -130, Parent = Announce.Config, variable = SkillSettings.FrenReg,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["FrenRegB"]:GetChecked() == 1 then SkillSettings.FrenReg = 0 else SkillSettings.FrenReg = 1 end	end},
				},
		HibernateB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "HibernateB", Location = "CENTER", Xoff = -170, Yoff = -145, Parent = Announce.Config, variable = SkillSettings.Hibernate,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["HibernateB"]:GetChecked() == 1 then SkillSettings.Hibernate = 0 else SkillSettings.Hibernate = 1 end	end},
				},
		SurvInstB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SurvInstB", Location = "CENTER", Xoff = -170, Yoff = -160, Parent = Announce.Config, variable = SkillSettings.SurvInst,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SurvInstB"]:GetChecked() == 1 then SkillSettings.SurvInst = 0 else SkillSettings.SurvInst = 1 end	end},
				},
				
		
		------------
		--Settings--
		------------
		SettRess = { Ftype = "FontString", Location = "CENTER", Xoff = -117, Yoff = -185, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Resurections",
				},
		SettInterrupt = { Ftype = "FontString", Location = "CENTER", Xoff = 5, Yoff = -185, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Interrupts",
				},
		SettParty = { Ftype = "FontString", Location = "CENTER", Xoff = -107, Yoff = -202, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Party broadcast",
				},
		SettRaid = { Ftype = "FontString", Location = "CENTER", Xoff = 20, Yoff = -202, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Raid broadcast",
				},
		SettFades = { Ftype = "FontString", Location = "CENTER", Xoff = -123, Yoff = -219, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 100, Height = 15, StringVal = "Spell fades",
				},
		SettCustom = { Ftype = "FontString", Location = "CENTER", Xoff = 16, Yoff = -219, Parent = Announce.Config,
				R = 1, G = 0.8, B = 0.1, Width = 150, Height = 15, StringVal = "Custom chan.",
				},

		SettRessB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SettRessB", Location = "CENTER", Xoff = -170, Yoff = -185, Parent = Announce.Config, variable = CharacterSettings.Ress,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SettRessB"]:GetChecked() == 1 then CharacterSettings.Ress = 0 else CharacterSettings.Ress = 1 end	end},
				},
		SettInterruptB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SettInterruptB", Location = "CENTER", Xoff = -40, Yoff = -185, Parent = Announce.Config, variable = CharacterSettings.InterruptBool,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SettInterruptB"]:GetChecked() == 1 then CharacterSettings.InterruptBool = 0 else CharacterSettings.InterruptBool = 1 end	end},
				},
		SettPartyB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SettPartyB", Location = "CENTER", Xoff = -170, Yoff = -202, Parent = Announce.Config, variable = CharacterSettings.PartyBool,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SettPartyB"]:GetChecked() == 1 then CharacterSettings.PartyBool = 0 else CharacterSettings.PartyBool = 1 end	end},
				},
		SettRaidB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SettRaidB", Location = "CENTER", Xoff = -40, Yoff = -202, Parent = Announce.Config, variable = CharacterSettings.RaidBool,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SettRaidB"]:GetChecked() == 1 then CharacterSettings.RaidBool = 0 else CharacterSettings.RaidBool = 1 end	end},
				},
		SettFadesB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SettFadesB", Location = "CENTER", Xoff = -170, Yoff = -219, Parent = Announce.Config, variable = CharacterSettings.FadesBool,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SettFadesB"]:GetChecked() == 1 then CharacterSettings.FadesBool = 0 else CharacterSettings.FadesBool = 1 end	end},
				},
		SettCustomB = { Ftype = "CheckButton", Inherits = "InterfaceOptionsCheckButtonTemplate",
				FName = "SettCustomB", Location = "CENTER", Xoff = -40, Yoff = -219, Parent = Announce.Config, variable = CharacterSettings.CustomBool,
				Script1 = {event = "OnMouseUp", func = function(self)	if Announce.Config["SettCustomB"]:GetChecked() == 1 then CharacterSettings.CustomBool = 0 else CharacterSettings.CustomBool = 1 end	end},
				},
		}

	for Name, values in pairs(ConfigLayout) do 
		if (values.Ftype == "FontString") then
			Announce.Config[Name] = Announce.Config:CreateFontString(Name, "OVERLAY", "GameFontNormal")
			Announce.Config[Name]:SetWidth(values.Width)
			Announce.Config[Name]:SetHeight(values.Height)
			Announce.Config[Name]:SetTextColor(values.R,values.G,values.B)
			if values.StringVal then
				Announce.Config[Name]:SetText(values.StringVal)
			end
		elseif (values.Ftype == "CheckButton") then
			Announce.Config[Name] = CreateFrame(values.Ftype, values.FName, values.Parent, values.Inherits)
			if values.variable == 1 then
				Announce.Config[Name]:SetChecked(true)
			else
				Announce.Config[Name]:SetChecked(false)
			end
			if values["Script1"] then
				Announce.Config[Name]:SetScript(values["Script1"].event, values["Script1"].func)
			end
		end
		Announce.Config[Name]:SetPoint(values.Location,values.Xoff,values.Yoff)
	end
	InterfaceOptions_AddCategory(Announce.Config);
end