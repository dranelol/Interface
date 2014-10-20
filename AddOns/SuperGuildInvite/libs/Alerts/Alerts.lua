Alerter = CreateFrame("Frame")
Alerter.items = {}
Alerter.update = 0
Alerter.free = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
}
Alerter.wipe = {}
	
local Alerts = {}

do
	yOfs = 250
	for i = 1,5 do
		Alerter.items[i] = Alerter:CreateFontString()
		Alerter.items[i]:SetFont("Fonts\\FRIZQT__.TTF",40,"OUTLINE")
		Alerter.items[i]:SetPoint("CENTER",ALERT,"CENTER",0,yOfs)
		yOfs = yOfs - 50
	end
end

function Alerter:SendAlert(msg,duration)
	tinsert(Alerts,{m=msg,t=GetTime()+duration})
end

Alerter:SetScript("OnUpdate",function()
	if Alerter.update < GetTime() then
		
		for k,_ in pairs(Alerter.wipe) do
			if Alerter.wipe[k] < GetTime() then
				Alerter.items[k]:SetText("")
				Alerter.wipe[k] = nil
				Alerter.free[k] = true
			end
		end
		
		
		for k,_ in pairs(Alerts) do
			for j,_ in pairs(Alerter.free) do
				if Alerter.free[j] then
					Alerter.items[j]:SetText(Alerts[k].m)
					Alerter.wipe[j] = Alerts[k].t
					Alerter.free[j] = false
					Alerts[k] = nil
					break
				end
			end
		end
		
		
		Alerter.update = GetTime() + 0.2
	end
end)