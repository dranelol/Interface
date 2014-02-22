--[[
local Player

function createPlayerFrame(num)
	
	Player = atroxArenaViewerData.data[num]
	if (not Player) then
		return
	end
	DEFAULT_CHAT_FRAME:AddMessage("start playing: " .. Player.map .. " at " .. Player.startTime)
	
	local f = CreateFrame("Frame", "Player", UIParent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(500) -- Set these to whatever height/width is needed 
	f:SetHeight(230) -- for your Texture

	f:SetPoint("CENTER",0,0)
	f:SetBackdrop({
	  bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
	  edgeFile="Interface\\Tooltips\\UI-Tooltip-Border", 
	  tile=1, tileSize=10, edgeSize=10, 
	  insets={left=3, right=3, top=3, bottom=3}
	})
	
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetScript("OnMouseDown", f.StartMoving)
	f:SetScript("OnMouseUp", f.StopMovingOrSizing)

	f:Show()

-----
	local menu = MenuClass:New()
	menu:AddItem("Do Something", function()
		print("done")
	end)
	menu:AddItem("Close", function()
		-- do nothing, just close.
	end)

	f:SetScript("OnClick", function(self, button, down)
		menu:Show()
	end)
-----
	return f
end


function createEntityBar(parent, x, y)
	local anchor, offx
	
	if (x==1) then anchor = "TOPLEFT" else anchor = "TOPRIGHT" end
	if (x==1) then offx = 30 else offx = 290 end
	
	local a = CreateFrame("Frame", "$parentEntity" .. x .. y, parent)
	a:SetWidth(180)
	a:SetHeight(30)
	a:SetPoint("TOPLEFT", parent:GetName(), offx, -50-(y*35))
	a:Show()
	
	local c = CreateFrame("Frame", "$parentClazz", a)
	c:SetFrameStrata("MEDIUM")
	c:SetWidth(30)
	c:SetHeight(30)
	
	local t = c:CreateTexture(nil,"BACKGROUND")
	t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark.blp")
	t:SetAllPoints(c)
	c.texture = t
	c:SetPoint("TOPLEFT", a:GetName(), 0, 0)
	c:Show()
	
	local b = CreateFrame("STATUSBAR", "$parentHealthBar", a, "TextStatusBar");
	b:SetFrameStrata("MEDIUM")
	b:SetWidth(150);
	b:SetHeight(30);
	b:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
	b:SetStatusBarColor(5/255, 222/255, 0)
	b:SetMinMaxValues(0,UnitHealth("player"))
	b:SetPoint("TOPLEFT", a:GetName(), 30, 0)
	b:Show()
	
	return b
end

function createBarHealthText(parent)
	local a = parent:CreateFontString("$parentHPText","ARTWORK","GameFontNormal");
	a:SetText("100%")
	a:SetPoint("CENTER", parent:GetName(), 0, 0)
	a:Show()
	
	return a
end
--]]