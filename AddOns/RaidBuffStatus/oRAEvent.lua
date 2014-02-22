-- oRA2 Event handler compatability layer to work with Ace2
-- Thanks to PRAT author for inspiration
RBS_svnrev["oRAEvent.lua"] = select(3,string.find("$Revision: 513 $", ".* (.*) .*"))

RaidBuffStatus.oRAEvent = {}
function RaidBuffStatus.oRAEvent:RegisterForTankEvent(func)
	if not RaidBuffStatus.eventLibrary then
		RaidBuffStatus.eventLibrary = AceLibrary and AceLibrary:HasInstance("AceEvent-2.0") and AceLibrary("AceEvent-2.0") or nil
	end
	if RaidBuffStatus.eventLibrary then
		RaidBuffStatus.eventLibrary:RegisterEvent("oRA_MainTankUpdate", func)
	end
end

function RaidBuffStatus.oRAEvent:UnRegisterForTankEvent()
	if RaidBuffStatus.eventLibrary then
		if RaidBuffStatus.eventLibrary:IsEventRegistered("oRA_MainTankUpdate") then
			RaidBuffStatus.eventLibrary:UnRegisterEvent("oRA_MainTankUpdate")
		end
	end
end
