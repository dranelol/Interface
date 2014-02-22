
local L = LibStub("AceLocale-3.0"):GetLocale("atroxArenaViewer", true)

-- Slash commands
SLASH_ATROXARENAVIEWER1 = "/aav"
SLASH_ATROXARENAVIEWER2 = "/AAV"
SlashCmdList["ATROXARENAVIEWER"] = function(msg)
	msg = string.lower(msg or "")
	
	local self = _G["atroxArenaViewer"]
	
	print("> /aav " .. msg)
	
	if (msg == "broadcast") then
		
		self:changeBroadcast()
		
	elseif (msg == "lookup") then
		atroxArenaViewer:lookup()
		
	elseif (string.find(msg, 'connect%s%d*')) then
		local name = string.sub(msg, 9)
		atroxArenaViewer:connectToBroadcast(name)
			
	elseif (msg == "spectators") then
	
		print("|cffe392c5<AAV>|r current spectators (total: " .. #atroxArenaViewer:getSpectators() .. ")")
		if (#atroxArenaViewer:getSpectators() > 0) then
			for k,v in pairs(atroxArenaViewer:getSpectators()) do
				print("- " .. v)
			end
		end
	
	elseif (msg == "record") then
		
		self:changeRecording()
		
	elseif (msg == "play") then
		if (atroxArenaViewerData.data) then
			print(L.CONF_DESCR_PLAY)
			for k,v in pairs(atroxArenaViewerData.data) do
				print("   " .. k .. " - " .. v.map .. " at " .. v.startTime)
			end
		else
			print(L.NO_MATCHES_FOUND)
		end
	elseif (string.find(msg, 'play%s%d*')) then
		local num = tonumber(string.sub(msg, 6))
		if (num and atroxArenaViewerData.data[num]) then
			self:createPlayer(num)
			self:playMatch(num)
		else
			print(L.ERROR_WRONG_INPUT)
		end
	elseif (msg == "delete") then
		if (atroxArenaViewerData.data) then
			print(L.CONF_DESCR_DELETE)
			for k,v in pairs(atroxArenaViewerData.data) do
				print("   " .. k .. " - " .. v.map .. " at " .. v.startTime)
			end
		else
			print(L.NO_MATCHES_FOUND)
		end
	elseif (msg == "delete all") then
		for k,v in pairs(atroxArenaViewerData.data) do
			parent:deleteMatch(1) 
		end
	elseif (string.find(msg, 'delete%s%d*')) then
		local num = tonumber(string.sub(msg, 8))
		if (num) then			
			self:deleteMatch(num)
			print(L.CONF_MATCH_DELETED)
		else
			print(L.ERROR_WRONG_INPUT)
		end
	else
	
		print(L.CONF_HELP_LINE1)
		print(L.CONF_HELP_LINE2)
		print(L.CONF_HELP_LINE3)
		print(L.CONF_HELP_LINE4)
		print(L.CONF_HELP_LINE5)
		print(L.CONF_HELP_LINE6)
		print(L.CONF_HELP_LINE7)

	end
	
end