--[[
	GuildShield by Janniie - Stormreaver EU
	
	The purpose of GuildShield is to protect players from being
	contacted by guild invite mods. 
	
	To users: Use this as any other AddOn and you will be protected against some
	          guild invite mods.
			  
	To developers: 1. Put GuildShield.lua in you Guild Invite AddOns' folder and load it before your own, ie in the TOC file.
				   
				   2. Then run the function GuildShield:Initiate(action) inside your AddOn.
				   
				   "action" is the function you wish to call when you find a player with GuildShield
				   active.
				   
				   In my case it's a function that removes the player from my AddOns' invite queue.
				   
				   3. Then call, when fitting, GuildShield:IsShielded(playerName) to check if the player
				      has GuildShield installed. If they have, the "action" you specified earlier should be called
				      automaically, and in my case remove the player.
]]



RegisterAddonMessagePrefix("GUILD_SHIELD")
RegisterAddonMessagePrefix("I_HAVE_SHIELD")

local function IsShielded(self,player)
	SendAddonMessage("GUILD_SHIELD","","WHISPER",player)
end

local function Initiate(self,action)
	local Shield = CreateFrame("Frame")
	Shield:RegisterEvent("CHAT_MSG_ADDON")
	Shield:SetScript("OnEvent",function(self,event,...)
		local prefix,msg,channel,sender = select(1,...)
		if prefix == "I_HAVE_SHIELD" then
			action(sender)
		end
	end)
	print("|cffff8800Guild|r|cff00A2FFShield|r|cff55EE55 has been initiated|r")
end




local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent",function(...)
	local prefix,msg,channel,sender = select(3,...)
	if prefix == "GUILD_SHIELD" and sender ~= UnitName("player") then
		SendAddonMessage("I_HAVE_SHIELD","","WHISPER",sender)
		print("|cffff8800Guild|r|cff00A2FFShield|r|cff55EE55 protected you from an invite (|r|cff00A2FF"..sender.."|r|cff55EE55)|r")
		GuildShield.protects = GuildShield.protects + 1
		GuildShield.lastSession = GuildShield.lastSession + 1
	end
end)

local login = CreateFrame("Frame")
login:RegisterEvent("PLAYER_LOGIN")
login:SetScript("OnEvent",function()
	if type(GuildShield) ~= "table" then
		GuildShield = {}
	end
	GuildShield.protects = GuildShield.protects or 0
	GuildShield.lastSession = GuildShield.lastSession or 0
	print("|cffff8800Guild|r|cff00A2FFShield|r|cff55EE55 Protected you from |r|cffEC55EE"..GuildShield.lastSession.."|r|cff55EE55 invites last game session, for a total of |r|cffEC55EE"..GuildShield.protects.."|r|cff55EE55 blocked invites.|r")
	GuildShield.lastSession = 0
	GuildShield.IsShielded = IsShielded
	GuildShield.Initiate = Initiate
	print("|cffff8800Guild|r|cff00A2FFShield|r|cff55EE55 is active and protecting you|r")
end)

