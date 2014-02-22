------------------------------------------------
---- Raeli's Spell Announcer Paladin Module ----
------------------------------------------------
local RSA = LibStub("AceAddon-3.0"):GetAddon("RSA")
local L = LibStub("AceLocale-3.0"):GetLocale("RSA")
local RSA_Paladin = RSA:NewModule("Paladin")
function RSA_Paladin:OnInitialize()
	if RSA.db.profile.General.Class == "PALADIN" then
		RSA_Paladin:SetEnabledState(true)
	else
		RSA_Paladin:SetEnabledState(false)
	end
end -- End OnInitialize
local spellinfo,spelllinkinfo,extraspellinfo,extraspellinfolink,missinfo
function RSA_Paladin:OnEnable()
	RSA.db.profile.Modules.Paladin = true -- Set state to loaded, to know if we should announce when a spell is refreshed.
	local pName = UnitName("player")
	local MonitorConfig_Paladin = {
		player_profile = RSA.db.profile.Paladin,
		SPELL_DISPEL = {
			[4987] = {-- CLEANSE
				profile = 'Cleanse',
				replacements = { TARGET = 1, extraSpellName = "[AURA]", extraSpellLink = "[AURALINK]" }
			},
		}
	}
	RSA.MonitorConfig(MonitorConfig_Paladin, UnitGUID("player"))
	local MonitorAndAnnounce = RSA.MonitorAndAnnounce
	local RSA_DivineGuardian = false
	RSA.ItemSets = {
		["T11 Prot"] = { 60358, 60357, 60356, 60355, 60354, 65228, 65227, 65226, 65225, 65224 }, -- Modifies Guardian of Ancient Kings
	}
	local RSA_GoaKTimer = CreateFrame("Frame", "RSA:GoaKTimer") -- Because GoaK (Prot) has no event for end message.
	local GoaKTimeElapsed = 0.0
	local ArdentDefenderHealed = false
	local ResTarget = L["Unknown"]
	local Ressed
	local function Paladin_Spells(self, _, timestamp, event, hideCaster, sourceGUID, source, sourceFlags, sourceRaidFlag, destGUID, dest, destFlags, destRaidFlags, spellID, spellName, spellSchool, missType, overheal, ex3, ex4)
		local petName = UnitName("pet")
		if source == pName or source == petName then
			if (event == "SPELL_CAST_SUCCESS" and RSA.db.profile.Modules.Reminders_Loaded == true) then -- Reminder Refreshed
				local ReminderSpell = RSA.db.profile.Paladin.Reminders.SpellName
				if spellName == ReminderSpell and (dest == pName or dest == nil) then
					RSA.Reminder:SetScript("OnUpdate", nil)
					if RSA.db.profile.Reminders.RemindChannels.Chat == true then
						RSA.Print_Self(ReminderSpell .. L[" Refreshed!"])
					end
					if RSA.db.profile.Reminders.RemindChannels.RaidWarn == true then
						RSA.Print_Self_RW(ReminderSpell .. L[" Refreshed!"])
					end
				end
			end -- BUFF REMINDER
			if event == "SPELL_AURA_APPLIED" then
				if spellID == 62124 then -- HAND OF RECKONING
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF RECKONING
				if spellID == 25771 then -- FORBEARANCE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.Forbearance.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- FORBEARANCE
				if spellID == 10326 then -- TURN EVIL
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.TurnEvil.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.TurnEvil.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Party == true then
							if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Raid == true then
							if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- TURN EVIL
				if spellID == 853 or spellID == 105593 then -- HAMMER OF JUSTICE / FIST OF JUSTICE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HammerOfJustice.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Party == true then
							if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Raid == true then
							if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAMMER OF JUSTICE / FIST OF JUSTICE
				if spellID == 20066 then -- REPENTANCE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Repentance.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.Repentance.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Party == true then
							if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Raid == true then
							if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- REPENTANCE
				if spellID == 114039 then -- HAND OF PURITY
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfPurity.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF PURITY
				if spellID == 86698 or spellID == 86669 or spellID == 86659 then -- GUARDIAN OF ANCIENT KINGS
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.GoAK.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.GoAK.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Party == true then
							if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Raid == true then
							if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- GUARDIAN OF ANCIENT KINGS
				if spellID == 105809 then -- HOLY AVENGER
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HolyAvenger.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Party == true then
							if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Raid == true then
							if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HOLY AVENGER
			end -- IF EVENT IS SPELL_AURA_APPLIED
			if event == "SPELL_CAST_SUCCESS" then
				if spellID == 31850 then -- ARDENT DEFENDER
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					ArdentDefenderHealed = false
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Party == true then
							if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Raid == true then
							if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- ARDENT DEFENDER
				if spellID == 31821 then -- DEVOTION AURA
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.DevotionAura.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DevotionAura.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DevotionAura.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DevotionAura.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DevotionAura.Party == true then
							if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DevotionAura.Raid == true then
							if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DEVOTION AURA
				if spellID == 498 then -- DIVINE PROTECTION
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Party == true then
							if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Raid == true then
							if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DIVINE PROTECTION
				if spellID == 1044 then -- HAND OF FREEDOM
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF FREEDOM
				if spellID == 1022 then -- HAND OF PROTECTION
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF PROTECTION
				if spellID == 6940 then -- HAND OF SACRIFICE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF SACRIFICE
				if spellID == 1038 then -- HAND OF SALVATION
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF SALVATION
				if spellID == 53563 then -- BEACON OF LIGHT
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Beacon.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.Beacon.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Party == true then
							if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Raid == true then
							if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- BEACON OF LIGHT
				if spellID == 54428 then -- DIVINE PLEA
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.DivinePlea.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DivinePlea.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Party == true then
							if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Raid == true then
							if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DIVINE PLEA
				if spellID == 20925 then -- SACRED SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.SacredShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.SacredShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Party == true then
							if RSA.db.profile.Paladin.Spells.SacredShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.SacredShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- SACRED SHIELD
				if spellID == 642 then -- DIVINE SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.DivineShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DivineShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Party == true then
							if RSA.db.profile.Paladin.Spells.DivineShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.DivineShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DIVINE SHIELD
				if spellID == 31884 then -- AVENGING WRATH
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.AvengingWrath.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Party == true then
							if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Raid == true then
							if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- AVENGING WRATH
			end -- IF EVENT IS SPELL_CAST_SUCCESS
			if event == "SPELL_INTERRUPT" then
				if spellID == 96231 then -- REBUKE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					extraspellinfo = GetSpellInfo(missType)
					extraspellinfolink = GetSpellLink(missType)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[TARSPELL]"] = extraspellinfo, ["[TARLINK]"] = extraspellinfolink,}
					if RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.Rebuke.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Party == true then
							if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Raid == true then
							if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- REBUKE
				if spellID == 31935 then -- AVENGERS SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					extraspellinfo = GetSpellInfo(missType)
					extraspellinfolink = GetSpellLink(missType)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[TARSPELL]"] = extraspellinfo, ["[TARLINK]"] = extraspellinfolink,}
					if RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.AvengersShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.AvengersShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Party == true then
							if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- AVENGERS SHIELD
			end -- IF EVENT IS SPELL_INTERRUPT
			if event == "SPELL_HEAL" then
				if spellID == 633 then -- LAY ON HANDS
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType - overheal, ["[OVERHEAL]"] = overheal}
					if missType == 0 then return end
					if RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.LayOnHands.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"], ["[AMOUNT]"] = missType,}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType,}
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.LayOnHands.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Party == true then
							if RSA.db.profile.Paladin.Spells.LayOnHands.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.LayOnHands.Raid == true then
							if RSA.db.profile.Paladin.Spells.LayOnHands.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.LayOnHands.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				end -- LAY ON HANDS
				if spellID == 130551 then -- WORD OF GLORY
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType - overheal, ["[OVERHEAL]"] = overheal}
					if (missType - overheal) >= tonumber(RSA.db.profile.Paladin.Spells.WordOfGlory.Minimum) then
						if RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start ~= "" then
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Local == true then
								RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace))
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Yell == true then
								RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace))
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
								RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"], ["[AMOUNT]"] = missType,}
								RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace), dest)
								RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType,}
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.CustomChannel.Enabled == true then
								RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.WordOfGlory.CustomChannel.Channel)
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Smart.Say == true then
								RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace))
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Smart.RaidParty == true then
								RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace))
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Party == true then
								if RSA.db.profile.Paladin.Spells.WordOfGlory.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
									RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace))
							end
							if RSA.db.profile.Paladin.Spells.WordOfGlory.Raid == true then
								if RSA.db.profile.Paladin.Spells.WordOfGlory.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
								RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.WordOfGlory.Messages.Start, ".%a+.", RSA.String_Replace))
							end
						end
					end
				end -- WORD OF GLORY
				if spellID == 31850 or spellID == 66235 then -- ARDENT DEFENDER
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					ArdentDefenderHealed = true
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType,}
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal ~= "" then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"], ["[AMOUNT]"] = missType,}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[AMOUNT]"] = missType,}
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Party == true then
							if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Raid == true then
							if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.Heal, ".%a+.", RSA.String_Replace))
						end
					end
				end -- ARDENT DEFENDER
			end -- IF EVENT IS SPELL_HEAL
			if event == "SPELL_AURA_REMOVED" then
				if spellID == 31850 and ArdentDefenderHealed == false then -- ARDENT DEFENDER
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.ArdentDefender.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Party == true then
							if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.ArdentDefender.Raid == true then
							if RSA.db.profile.Paladin.Spells.ArdentDefender.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.ArdentDefender.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- ARDENT DEFENDER
				if spellID == 31821 and dest == pName then -- DEVOTION AURA
					 spellinfo = GetSpellInfo(spellID)
					 spelllinkinfo = GetSpellLink(spellID)
					 RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					 if RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End ~= "" then
						 if RSA.db.profile.Paladin.Spells.DevotionAura.Local == true then
							 RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace))
						 end
						 if RSA.db.profile.Paladin.Spells.DevotionAura.Yell == true then
							 RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace))
						 end
						 if RSA.db.profile.Paladin.Spells.DevotionAura.CustomChannel.Enabled == true then
							 RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DevotionAura.CustomChannel.Channel)
						 end
						 if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.Say == true then
							 RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace))
						 end
						 if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.RaidParty == true then
							 RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace))
						 end
						 if RSA.db.profile.Paladin.Spells.DevotionAura.Party == true then
							 if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								 RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace))
						 end
						 if RSA.db.profile.Paladin.Spells.DevotionAura.Raid == true then
							 if RSA.db.profile.Paladin.Spells.DevotionAura.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							 RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DevotionAura.Messages.End, ".%a+.", RSA.String_Replace))
						 end
					 end
				end -- DEVOTION AURA
				if spellID == 498 then -- DIVINE PROTECTION
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.DivineProtection.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DivineProtection.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Party == true then
							if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineProtection.Raid == true then
							if RSA.db.profile.Paladin.Spells.DivineProtection.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DIVINE PROTECTION
				if spellID == 25771 then -- FORBEARANCE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Forbearance.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.Forbearance.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Forbearance.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- FORBEARANCE
				if spellID == 1044 then -- HAND OF FREEDOM
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfFreedom.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfFreedom.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfFreedom.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfFreedom.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF FREEDOM
				if spellID == 1022 then -- HAND OF PROTECTION
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace), dest)
								RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfProtection.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfProtection.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfProtection.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfProtection.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF PROTECTION
				if spellID == 6940 then -- HAND OF SACRIFICE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfSacrifice.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfSacrifice.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSacrifice.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF SACRIFICE
				if spellID == 1038 then -- HAND OF SALVATION
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfSalvation.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfSalvation.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfSalvation.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfSalvation.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF SALVATION
				if spellID == 20066 then -- REPENTANCE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Repentance.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.Repentance.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Repentance.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Party == true then
							if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Repentance.Raid == true then
							if RSA.db.profile.Paladin.Spells.Repentance.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Repentance.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- REPENTANCE
				if spellID == 53563 then -- BEACON OF LIGHT
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Beacon.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.Beacon.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Beacon.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Party == true then
							if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Beacon.Raid == true then
							if RSA.db.profile.Paladin.Spells.Beacon.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Beacon.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- BEACON OF LIGHT
				if spellID == 10326 then -- TURN EVIL
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.TurnEvil.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.TurnEvil.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Party == true then
							if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.TurnEvil.Raid == true then
							if RSA.db.profile.Paladin.Spells.TurnEvil.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.TurnEvil.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- TURN EVIL
				if spellID == 54428 then -- DIVINE PLEA
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.DivinePlea.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DivinePlea.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Party == true then
							if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivinePlea.Raid == true then
							if RSA.db.profile.Paladin.Spells.DivinePlea.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivinePlea.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DIVINE PLEA
				if spellID == 853 or spellID == 105593 then -- HAMMER OF JUSTICE / FIST OF JUSTICE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HammerOfJustice.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Party == true then
							if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HammerOfJustice.Raid == true then
							if RSA.db.profile.Paladin.Spells.HammerOfJustice.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HammerOfJustice.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAMMER OF JUSTICE / FIST OF JUSTICE
				if spellID == 20925 then -- SACRED SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.SacredShield.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.SacredShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.SacredShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Party == true then
							if RSA.db.profile.Paladin.Spells.SacredShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.SacredShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.SacredShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.SacredShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- SACRED SHIELD
				if spellID == 642 then -- DIVINE SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.DivineShield.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.DivineShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.DivineShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Party == true then
							if RSA.db.profile.Paladin.Spells.DivineShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.DivineShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.DivineShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.DivineShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- DIVINE SHIELD
				if spellID == 31884 then -- AVENGING WRATH
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.AvengingWrath.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Party == true then
							if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengingWrath.Raid == true then
							if RSA.db.profile.Paladin.Spells.AvengingWrath.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AvengingWrath.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- AVENGING WRATH
				if spellID == 114039 then -- HAND OF PURITY
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Whisper == true and dest ~= pName and RSA.Whisperable(destFlags) then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfPurity.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfPurity.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfPurity.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfPurity.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF PURITY
				if spellID == 86698 or spellID == 86669 or spellID == 86659 then -- GUARDIAN OF ANCIENT KINGS
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.GoAK.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.GoAK.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Party == true then
							if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Raid == true then
							if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- GUARDIAN OF ANCIENT KINGS
				if spellID == 105809 then -- HOLY AVENGER
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HolyAvenger.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Party == true then
							if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HolyAvenger.Raid == true then
							if RSA.db.profile.Paladin.Spells.HolyAvenger.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HolyAvenger.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HOLY AVENGER
			end -- IF EVENT IS SPELL_AURA_REMOVED
			if event == "SPELL_MISSED" and missType ~= "IMMUNE" then
				if spellID == 96231 then -- REBUKE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					if missType == "MISS" then
						missinfo = L["missed"]
					elseif missType ~= "MISS" then
						missinfo = L["was resisted by"]
					end
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[MISSTYPE]"] = missinfo,}
					if RSA.db.profile.Paladin.Spells.Rebuke.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.Rebuke.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Party == true then
							if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Raid == true then
							if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- REBUKE
				if spellID == 31935 then -- AVENGERS SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					if missType == "MISS" then
						missinfo = L["missed"]
					elseif missType ~= "MISS" then
						missinfo = L["was resisted by"]
					end
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[MISSTYPE]"] = missinfo,}
					if RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.AvengersShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.AvengersShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Party == true then
							if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- AVENGERS SHIELD
				if spellID == 62124 then -- HAND OF RECKONING
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					if missType == "MISS" then
						missinfo = L["missed"]
					elseif missType ~= "MISS" then
						missinfo = L["was resisted by"]
					end
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[MISSTYPE]"] = missinfo,}
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF RECKONING
			end -- IF EVENT IS SPELL_MISSED AND NOT IMMUNE
			if event == "SPELL_MISSED" and missType == "IMMUNE" then
				if spellID == 96231 then -- REBUKE
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[MISSTYPE]"] = L["Immune"],}
					if RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune ~= "" then
						if RSA.db.profile.Paladin.Spells.Rebuke.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Rebuke.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Party == true then
							if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Rebuke.Raid == true then
							if RSA.db.profile.Paladin.Spells.Rebuke.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Rebuke.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
					end
				end -- REBUKE
				if spellID == 31935 then -- AVENGERS SHIELD
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[MISSTYPE]"] = L["Immune"],}
					if RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune ~= "" then
						if RSA.db.profile.Paladin.Spells.AvengersShield.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.AvengersShield.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Party == true then
							if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.AvengersShield.Raid == true then
							if RSA.db.profile.Paladin.Spells.AvengersShield.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.AvengersShield.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
					end
				end -- AVENGERS SHIELD
				if spellID == 62124 then -- HAND OF RECKONING
					spellinfo = GetSpellInfo(spellID)
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest, ["[MISSTYPE]"] = L["Immune"],}
					if RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune ~= "" then
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.HandOfReckoning.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Party == true then
							if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.HandOfReckoning.Raid == true then
							if RSA.db.profile.Paladin.Spells.HandOfReckoning.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.HandOfReckoning.Messages.Immune, ".%a+.", RSA.String_Replace))
						end
					end
				end -- HAND OF RECKONING
			end -- IF EVENT IS SPELL_MISSED AND IS IMMUNE
			MonitorAndAnnounce(self, _, timestamp, event, hideCaster, sourceGUID, source, sourceFlags, sourceRaidFlag, destGUID, dest, destFlags, destRaidFlags, spellID, spellName, spellSchool, missType, overheal, ex3, ex4)
		end -- IF SOURCE IS PLAYER
	end -- END ENTIRELY
	RSA.CombatLogMonitor:SetScript("OnEvent", Paladin_Spells)
	------------------------------
	---- Resurrection Monitor ----
	------------------------------
	local function Paladin_Redemption(_, event, source, spell, rank, dest, spellID)
		if UnitName(source) == pName then
			if spell == GetSpellInfo(7328) and RSA.db.profile.Paladin.Spells.Redemption.Messages.Start ~= "" then -- REDEMPTION
				if event == "UNIT_SPELLCAST_SENT" then
					Ressed = false
					if (dest == L["Unknown"] or dest == nil) then
						if UnitExists("target") ~= 1 or (UnitHealth("target") > 1 and UnitIsDeadOrGhost("target") ~= 1) then
							if GameTooltipTextLeft1:GetText() == nil then
								dest = L["Unknown"]
								ResTarget = L["Unknown"]
							else
								dest = string.gsub(GameTooltipTextLeft1:GetText(), L["Corpse of "], "")
								ResTarget = string.gsub(GameTooltipTextLeft1:GetText(), L["Corpse of "], "")
							end
						else
							dest = UnitName("target")
							ResTarget = UnitName("target")
						end
					else
						ResTarget = dest
					end
					spellinfo = GetSpellInfo(spell) spelllinkinfo = GetSpellLink(spell)
					RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
					if RSA.db.profile.Paladin.Spells.Redemption.Messages.Start ~= "" then
						if RSA.db.profile.Paladin.Spells.Redemption.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Whisper == true and dest ~= pName then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.Redemption.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Redemption.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Party == true then
							if RSA.db.profile.Paladin.Spells.Redemption.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Raid == true then
							if RSA.db.profile.Paladin.Spells.Redemption.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.Start, ".%a+.", RSA.String_Replace))
						end
					end
				elseif event == "UNIT_SPELLCAST_SUCCEEDED" and Ressed ~= true then
					dest = ResTarget
					Ressed = true
					if RSA.db.profile.Paladin.Spells.Redemption.Messages.End ~= "" then
						if RSA.db.profile.Paladin.Spells.Redemption.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Whisper == true and dest ~= pName then
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = L["You"],}
							RSA.Print_Whisper(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace), dest)
							RSA.Replacements = {["[SPELL]"] = spellinfo, ["[LINK]"] = spelllinkinfo, ["[TARGET]"] = dest,}
						end
						if RSA.db.profile.Paladin.Spells.Redemption.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.Redemption.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Party == true then
							if RSA.db.profile.Paladin.Spells.Redemption.Smart.RaidParty == true and GetNumGroupMembers() == 0 and InstanceType ~= "arena" then return end
								RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.Redemption.Raid == true then
							if RSA.db.profile.Paladin.Spells.Redemption.Smart.RaidParty == true and GetNumGroupMembers() > 0 then return end
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.Redemption.Messages.End, ".%a+.", RSA.String_Replace))
						end
					end
				end
			end -- REDEMPTION
			if spellID == 86659 and event == "UNIT_SPELLCAST_SUCCEEDED" and source == "player" then -- GUARDIAN OF ANCIENT KINGS (PROT)
				if RSA.db.profile.Paladin.Spells.GoAK.Messages.Start ~= "" then
					spelllinkinfo = GetSpellLink(spellID)
					RSA.Replacements = {["[SPELL]"] = spell, ["[LINK]"] = spelllinkinfo,}
					if RSA.db.profile.Paladin.Spells.GoAK.Local == true then
						RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Yell == true then
						RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == true then
						RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel)
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Smart.Say == true then
						RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true then
						RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Party == true then
						RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
					end
					if RSA.db.profile.Paladin.Spells.GoAK.Raid == true then
						RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.Start, ".%a+.", RSA.String_Replace))
					end
				end
				if RSA.db.profile.Paladin.Spells.GoAK.Messages.End ~= "" then
					GoaKTimeElapsed = 0.0 -- Start a timer for end announcement, because GoAK (Prot) has no end event in combat log.
					local duration = 12.0
					if (RSA.SetBonus("T11 Prot") > 3) then
						duration = duration * 2
					end
					local function GoaKTimer(self, elapsed)
						GoaKTimeElapsed = GoaKTimeElapsed + elapsed
						if GoaKTimeElapsed < duration then return end
						GoaKTimeElapsed = GoaKTimeElapsed - floor(GoaKTimeElapsed)
						spelllinkinfo = GetSpellLink(spellID)
						RSA.Replacements = {["[SPELL]"] = spell, ["[LINK]"] = spelllinkinfo,}
						if RSA.db.profile.Paladin.Spells.GoAK.Local == true then
							RSA.Print_LibSink(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Yell == true then
							RSA.Print_Yell(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Enabled == true then
							RSA.Print_Channel(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace), RSA.db.profile.Paladin.Spells.GoAK.CustomChannel.Channel)
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.Say == true then
							RSA.Print_Say(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Smart.RaidParty == true then
							RSA.Print_Smart_RaidParty(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Party == true then
							RSA.Print_Party(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						if RSA.db.profile.Paladin.Spells.GoAK.Raid == true then
							RSA.Print_Raid(string.gsub(RSA.db.profile.Paladin.Spells.GoAK.Messages.End, ".%a+.", RSA.String_Replace))
						end
						RSA_GoaKTimer:SetScript("OnUpdate", nil)
					end
				RSA_GoaKTimer:SetScript("OnUpdate", GoaKTimer)
				end
			return
			end -- GUARDIAN OF ANCIENT KINGS (PROT)
		end
	end -- END FUNCTION
	RSA.ResMon = RSA.ResMon or CreateFrame("Frame", "RSA:RM")
	RSA.ResMon:RegisterEvent("UNIT_SPELLCAST_SENT")
	RSA.ResMon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	RSA.ResMon:SetScript("OnEvent", Paladin_Redemption)
end -- END ON ENABLED
function RSA_Paladin:OnDisable()
RSA.CombatLogMonitor:SetScript("OnEvent", nil)
RSA.ResMon:SetScript("OnEvent", nil)
end