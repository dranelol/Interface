--[[
--
--	ArtPad
--	by Dust of Turalyon
--
--	Naming Convention:
--	- Methods are first letter upper case, camel case
--	- Member variables are first letter lower case
--	- Static handlers start with "On".
--
--]]

--[[ Protocol ]]
-- d(<x>,<y>,<a>,<b>)	-- Draw a line from (x,y) to (a,b)
-- c(<x>,<y>)		-- Clear a point at (x,y)
-- c(<x>,<y>,<a>,<b>)	-- Clear a line from (x,y) to (a,b)
-- c()			-- Clear Canavas
-- f(<r>,<g>,<b>,<a>)	-- Change to given color
-- t(<x>,<y>,"<t>")	-- Draw text t with bottom left corner at (x,y)

ArtPad =
{
-- [[ Version data from the TOC file ]]
version = GetAddOnMetadata("ArtPad", "Version");
saveVersion = GetAddOnMetadata("ArtPad", "X-SaveVersion");
protocolVersion = GetAddOnMetadata("ArtPad", "X-ProtocolVersion");

-- [[ Event Handling ]]
events = {
	["VARIABLES_LOADED"] =
		function (this)
			local ArtPad_Settings_Default = {
				["SaveVersion"]	= this.saveVersion;
				["AdminOnly"]	= true; -- Ignore non-raid admins
				["WarnClear"]	= true; -- Warn before clearing screen
			};
			if not ArtPad_Settings then
				ArtPad_Settings = ArtPad_Settings_Default;
			elseif ArtPad_Settings["SaveVersion"] < this.saveVersion then
				ArtPad_Settings = ArtPad_Settings_Default;
			end;
		end;
	["PLAYER_LOGIN"] =
		function (this)
		end;
	["PLAYER_REGEN_DISABLED"] =
		function (this)
			-- Close window when entering combat
			if this.mainFrame:IsShown() then
				this.mainFrame:Hide();
			end;
		end;
	["PLAYER_REGEN_ENABLED"] =
		function (this)
		end;
	["CHAT_MSG_ADDON"] =
		function (this, prefix, message, disType, sender)
			if prefix == "ArtPad" and sender ~= UnitName("player") then
				if not this:ValidateSender(sender) then
					return;
				end;

				local x,y,a,b = string.match(message, "d%((%d+),(%d+),(%d+),(%d+)%)");
				if x then
					this:DrawLine(x,y,a,b);
					return;
				end;
				local x,y = string.match(message, "c%((%d+),(%d+)%)");
				if x then
					this:ClearLine(x,y);
					return;
				end;

				local x,y,a,b = string.match(message, "c%((%d+),(%d+),(%d+),(%d+)%)");
				if x then
					this:ClearLine(x,y,a,b);
					return;
				end;

				local r,g,b,a = string.match(message, "f%((%d%.?%d*),(%d%.?%d*),(%d%.?%d*),(%d%.?%d*)%)");
				if r then
					this:SetColor(r,g,b,a);
					return;
				end;

				local x,y,t = string.match(message, "t%((%d+),(%d+),\"([^\"]+)\"%)");
				if x then
					this:CreateText(x,y,t);
					return;
				end;

				local a, b = string.find(message, "c%(%)");
				if a then
					this:ClearCanavas();
					return;
				end;
			end;
		end;
};

-- [[ Event Management ]]
RegisterEvents = function (this, eventList)
	for event, handler in pairs(eventList) do
		this.eventFrame:RegisterEvent(event);
	end
end;

UnregisterEvents = function (this, eventList)
	for event, handler in pairs(eventList) do
		this.eventFrame:UnregisterEvent(event);
	end
end;

-- [[ Button Handling ]]
buttons = {
	["Close"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this.mainFrame:Hide();
		end;
	["Clear"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this:ClearCanavas();
			this:SendClear();
		end;
	["Text"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			if this.state == "SLEEP" then
				this.textInput:SetText("");
				this.textInput:Show();
			end;
		end;
	["ColorWhite"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this:SetColor(1,1,1,0.75);
			this:SendColor(1,1,1,0.75);
		end;
	["ColorGrey"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this:SetColor(0.5,0.5,0.5,0.75);
			this:SendColor(0.5,0.5,0.5,0.75);
		end;
	["ColorRed"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this:SetColor(1,0,0,0.75);
			this:SendColor(1,0,0,0.75);
		end;
	["ColorGreen"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this:SetColor(0,1,0,0.75);
			this:SendColor(0,1,0,0.75);
		end;
	["ColorBlue"] =
		function (frame, button, down)
			local this = frame.pad; -- Static Method
			this:SetColor(0,0,1,0.75);
			this:SendColor(0,0,1,0.75);
		end;
};

shortcuts = {
	["Close"] = "ESCAPE";
	["Clear"] = "C";
	["Text"] = "T";
	["ColorWhite"] = "1";
	["ColorGrey"] = "2";
	["ColorRed"] = "3";
	["ColorGreen"] = "4";
	["ColorBlue"] = "5";
};


-- [[ Load Event Handling ]]
OnLoad = function (this)
	--Slash command
	SlashCmdList["ARTPAD"] = this.OnSlashCommand;
	SLASH_ARTPAD1 = "/artpad";
	SLASH_ARTPAD2 = "/ap";

	this.mainFrame:SetScript("OnEnter", this.OnEnter);
	this.mainFrame:SetScript("OnLeave", this.OnLeave);

	--this.mainFrame:EnableKeyboard(true);
	--this.mainFrame:SetScript("OnKeyDown", this.OnKeyDown);
	--this.mainFrame:SetScript("OnKeyUp", this.OnKeyUp);

	this.mainFrame:EnableMouse(true);
	this.mainFrame:SetScript("OnMouseDown", this.OnMouseDown);
	this.mainFrame:SetScript("OnMouseUp", this.OnMouseUp);

	this.mainFrame:SetScript("OnShow", this.OnShow);
	this.mainFrame:SetScript("OnHide", this.OnHide);

	this.textInput:SetScript("OnEnterPressed", this.OnTextEnter);
	this.textInput:SetScript("OnEscapePressed", this.OnTextEscape);

	this.eventFrame:SetScript("OnEvent", this.OnEvent);
	this:RegisterEvents(this.events);

	-- NOT REENTRANT!
	this.OnLoad = nil;
end;

-- [[ Frame Event Handling ]]
OnEvent = function (frame, event, ...)
	local this = frame.pad; -- Static Method

	if this.events[event] then
		this.events[event](this, ...);
	else
		this:Message("ArtPad Error: Unknown Event");
	end;
end;

-- [[ Keyboard Event Handling ]]
OnKeyDown = function (frame, key)
	local this = frame.pad; -- Static Method
end;

OnKeyUp = function (frame, key)
	local this = frame.pad; -- Static Method
	if (key == "ESCAPE") then
		frame:Hide();
	end;
end;

-- [[ Mouse Event Handling ]]
state = "SLEEP";

OnMouseDown = function (frame, button)
	local this = frame.pad; -- Static Method
	if this.FrameMouseDown(frame) then
		this.state = "FRAME";
	elseif this.state == "SLEEP" then
		if button == "LeftButton" then
			this.state = "PAINT";
		else
			this.state = "CLEAR";
		end;
	elseif this.state == "TEXT" then
		this:CreateText(this.lastX, this.lastY,
			this.textInput:GetText());
		this:SendText(this.lastX, this.lastY,
			this.textInput:GetText());
		this.state = "SLEEP";
	end;
end;

OnMouseUp = function (frame, button)
	local this = frame.pad; -- Static Method
	this.FrameMouseUp(frame);
	this.state = "SLEEP";
end;

-- [[ Override Handling ]]
OnShow = function (frame)
	local this = frame.pad; -- Static Method
	-- Set Override
	for b, k in pairs(this.shortcuts) do
		SetOverrideBindingClick(this.mainFrame, true, k, "ArtPad_MainFrame_"..b);
	end;
end;

OnHide = function (frame)
	local this = frame.pad; -- Static Method
	-- Clear Override
	ClearOverrideBindings(this.mainFrame);
end;

-- [[ Tracking Functions ]]
OnEnter = function (frame, motion)
	local this = frame.pad; -- Static Method
	this.mainFrame:SetScript("OnUpdate", this.OnUpdate);
end;

OnLeave = function (frame, motion)
	local this = frame.pad; -- Static Method
	this.mainFrame:SetScript("OnUpdate", nil);
	this.state = "SLEEP";
	this.lastX = nil;
	this.lastY = nil;

end;

mouseX = -1;
mouseY = -1;
OnUpdate = function (frame, elapsed)
	local this = frame.pad; -- Static Method
	local mx, my = GetCursorPosition();
	if mx == this.mouseX and my == this.mouseY then
		return;
	else
		this.mouseX = mx;
		this.mouseY = my;
	end;
	local x, y;		-- Local coordinates
	local scale = this.mainFrame:GetScale()*UIParent:GetScale();

	mx = mx/scale;
	my = my/scale;
	x = math.floor(mx - this.mainFrame:GetLeft());
	y = math.floor(my - this.mainFrame:GetBottom());

	if this.state ~= "SLEEP" then
		this:HandleMove(x, y, this.lastX, this.lastY);
	end;

	this.lastX = x;
	this.lastY = y;
end;

HandleMove = function (this, ...)
	if this.state == "PAINT" then
		this:DrawLine(...);
		this:SendLine(...);
	elseif this.state == "CLEAR" then
		this:ClearLine(...);
		this:SendClear(...);
	end;
end;

OnTextEnter = function (frame)
	local this = frame.pad; -- Static Method
	this.state = "TEXT";
	frame:Hide();
end;

OnTextEscape = function (frame)
	local this = frame.pad; -- Static Method
	frame:Hide();
end;

-- [[ Authorisation ]]
ValidateSender = function (sender)
	if ArtPad_Settings["AdminOnly"] then
		-- Check if sender is a raid admin
		local maxNum = GetNumRaidMembers();
		local authorized = false;
		if (maxNum > 0) then
			for i=1,maxNum do
				local name, rank = GetRaidRosterInfo(i);
				if name == sender then
					authorized = rank > 0;
				end;
			end;
		end;
		return authorized;
	else
		-- No check needed, all are allowed
		return true;
	end;
end;

slashCommands = {
	["show"] =
		function (this)
			this.mainFrame:Show();
		end;
	["hide"] =
		function (this)
			this.mainFrame:Hide();
		end;
	["toggle"] =
		function (this)
			if this.mainFrame:IsShown() then
				this.mainFrame:Hide();
			else
				this.mainFrame:Show();
			end;
		end;
	["clear"] =
		function (this)
			this:ClearCanavas();
		end;
	["adminonly"] =
		function (this, state)
			-- TODO: Generalize
			-- Set
			if state == "off" or state == "false" then
				ArtPad_Settings["AdminOnly"] = false;
			elseif state == "on" or state == "true" then
				ArtPad_Settings["AdminOnly"] = true;
			else -- Toggle
				if ArtPad_Settings["AdminOnly"] then
					ArtPad_Settings["AdminOnly"] = false;
				else
					ArtPad_Settings["AdminOnly"] = true;
				end;
			end;
			if ArtPad_Settings["AdminOnly"] then
				this:Message("ArtPad: AdminOnly enabled");
			else
				this:Message("ArtPad: AdminOnly disabled");
			end;
		end;
};

OnSlashCommand = function (msg)
	local this = ArtPad; -- Static Method
	local cmd, arg = string.match(msg, "^(%a*)%s*(.*)$");
	if cmd then
		cmd = string.lower(cmd);
		if this.slashCommands[cmd] then
			this.slashCommands[cmd](this, arg);
		else
			this:Message("ArtPad:")
			this:Message("/ap [show | hide | toggle | clear]")
			this:Message("/ap [adminonly]")
		end;
	end;
end;

-- [[ Misc ]]
Message = function (this, msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end;

-- [[ Frame Setup and handling ]]
mainFrameWidth = 800;
mainFrameHeight = 600;
mainFrameScale = 1;

mainFrame = nil;	-- For input/output
eventFrame = nil;	-- For event processing

textInput = nil;

brushColorSample = nil;

CreateFrames = function (this)
	local frameM = CreateFrame("Frame", nil, UIParent);
	local frameE = CreateFrame("Frame", nil, UIParent);
	this.mainFrame = frameM;
	this.mainFrame.pad = this;
	this.eventFrame = frameE;
	this.eventFrame.pad = this;

	frameM:SetFrameStrata("DIALOG");
	frameM:SetWidth(this.mainFrameWidth);
	frameM:SetHeight(this.mainFrameHeight);
	frameM:SetScale(this.mainFrameScale);
	frameM:SetPoint("CENTER", 0, 0);
	frameM:SetMovable(true);
	frameM:SetClampedToScreen(true);
	frameM:Hide();

	local frameT = CreateFrame("EditBox", nil, frameM);
	this.textInput = frameT;
	this.textInput.pad = this;

	frameT:SetPoint("BOTTOMLEFT", frameM, "BOTTOMLEFT", 5, 5);
	frameT:SetPoint("TOPRIGHT", frameM, "BOTTOMLEFT", 205, 25);
	frameT:SetFont("Fonts\\FRIZQT__.TTF",12);
	frameT:Hide();

	local t = frameM:CreateTexture(nil, "BACKGROUND");
	t:SetTexture(0,0,0,0.5);
	t:SetAllPoints(frameM);

	local b = frameM:CreateTexture(nil, "ARTWORK");
	b:SetPoint("TOPRIGHT", frameM, "TOPRIGHT", -10, -10);
	b:SetWidth(10); b:SetHeight(10);
	b:SetTexture(1,1,1,1);
	this.brushColorSample = b;

	local a = frameM:CreateFontString(nil, "ARTWORK");
	a:SetPoint("TOPLEFT", frameM, "TOPLEFT", 10, -10);
	a:SetTextColor(0.5, 0.5, 0.5, 0.5);
	a:SetFont("Fonts\\FRIZQT__.TTF",16);
	a:SetJustifyH("LEFT")
	a:SetText("ArtPad v."..this.version);
	local h = frameM:CreateFontString(nil, "ARTWORK");
	h:SetPoint("TOPLEFT", frameM, "TOPLEFT", 10, -30);
	h:SetTextColor(0.5, 0.5, 0.5, 0.5);
	h:SetFont("Fonts\\FRIZQT__.TTF",12);
	h:SetJustifyH("LEFT")
	local hs = "";
	for b, s in pairs(this.shortcuts) do
		hs = hs .. "> " .. b .. ": ".. s .. "\n";
	end;
	h:SetText(hs);

	-- Buttons (NOT REENTRANT!)
	for b, f in pairs(this.buttons) do
		local button = CreateFrame("Button", "ArtPad_MainFrame_"..b, frameM);
		button:SetScript("OnClick", f);
		button.pad = this;
	end

	this.CreateFrames = nil;
end;

FrameMouseDown = function (frame)
	if (IsShiftKeyDown()) then
		frame:StartMoving();
		return true;
--	elseif (IsAltKeyDown()) then
--		local w = frame:GetWidth();
--		local h = frame:GetHeight();
--		local x, y = frame:GetCenter();
--		local mx, my = GetCursorPosition();
--		local scaleL, scaleW;
--		scaleL = frame:GetScale();
--		scaleW = UIParent:GetScale();
--		mx = mx/scaleW;
--		my = my/scaleW;
--		x = x*scaleL;
--		y = y*scaleL
--		x = mx - x;
--		y = my - y;
--		x = x/w*h;
--		if (abs(x) > abs(y)) then
--			if (x > 0) then
--				frame:StartSizing("RIGHT");
--			else
--				frame:StartSizing("LEFT");
--			end;
--		else
--			if (y > 0) then
--				frame:StartSizing("TOP");
--			else
--				frame:StartSizing("BOTTOM");
--			end;
--		end;
--		return true;
	end;
	return false;
end;

FrameMouseUp = function (frame)
	frame:StopMovingOrSizing();
end;

-- [[ Drawing ]]

brushColor = { r = 1.0; g = 1.0; b = 1.0; a = 0.75; };

mainLines = {};
junkLines = {};
mainTexts = {};
junkTexts = {};

SendLine = function (this, x, y, oldX, oldY)
	if oldY and oldY then
		SendAddonMessage("ArtPad", "d("..x..","..y..","..oldX..","..oldY..")", "RAID");
	else
		--SendAddonMessage("ArtPad", "d("..x..","..y..")", "RAID");
	end;
end;

SendClear = function (this, x, y, oldX, oldY)
	if oldY and oldY then
		SendAddonMessage("ArtPad", "c("..x..","..y..","..oldX..","..oldY..")", "RAID");
	elseif x and y then
		SendAddonMessage("ArtPad", "c("..x..","..y..")", "RAID");
	else
		SendAddonMessage("ArtPad", "c()", "RAID");
	end;
end;

SendColor = function (this, r, g, b, a)
	SendAddonMessage("ArtPad", "f("..r..","..g..","..b..","..a..")", "RAID");
end;

SendText = function (this, x, y, text)
	SendAddonMessage("ArtPad", "t("..x..","..y..",\""..text.."\")", "RAID");
end;

DrawLine = function (this, x, y, oldX, oldY)
	if oldX and oldY then
		this:CreateLine(x,y, oldX, oldY);
	else
		--this:CreateLine(x,y);
	end;
end;

ClearLine = function (this, x, y, oldX, oldY)
	for i = #this.mainLines, 1, -1 do
		local px = this.mainLines[i]["lax"];
		local py = this.mainLines[i]["lay"];
		local qx = this.mainLines[i]["lbx"];
		local qy = this.mainLines[i]["lby"];
		-- TODO: Don't only check for intersections, but also min distance
		-- http://www.softsurfer.com/Archive/algorithm_0106/algorithm_0106.htm
		if this:LineLineIntersect(x,y,oldX,oldY,px,py,qx,qy) then
			this:JunkLine(i);
		end;
	end;
	for i = #this.mainTexts, 1, -1 do
		local px = this.mainTexts[i]["lax"];
		local py = this.mainTexts[i]["lay"];
		local qx = this.mainTexts[i]["lbx"];
		local qy = this.mainTexts[i]["lby"];
		if this:LineLineIntersect(x,y,oldX,oldY,px,py,qx,qy) then
			this:JunkText(i);
		end;
	end;
end;

PointPointDist = function (this, px, py, qx, qy)
	return math.sqrt(math.pow(px-qx,2) + math.pow(py-qy,2));
end;

LinePointDist = function (this, lax, lay, lbx, lby, px, py)
	-- http://www.softsurfer.com/Archive/algorithm_0102/algorithm_0102.htm
	-- Note: Not working
	return math.abs((lay-lby)*px+(lbx-lax)*py+(lax*lby-lbx*lay)/
		math.sqrt(math.pow(lbx-lax,2)+math.pow(lby-lay,2)));
end;

LineLineIntersect = function (this, ax0, ay0, ax1, ay1, bx0, by0, bx1, by1)
	--http://www.softsurfer.com/Archive/algorithm_0104/algorithm_0104B.htm#intersect2D_SegSeg()
	local ux, uy = ax1-ax0, ay1-ay0;
	local vx, vy = bx1-bx0, by1-by0;
	local wx, wy = ax0-bx0, ay0-by0;
	local D = ux*vy - uy*vx;

	if (D == 0) then
		-- Parallel
		return false;
	else
		local sI = (vx*wy-vy*wx) / D;
		if (sI < 0 or sI > 1) then -- no intersect with S1
			return false;
		end;

		local tI = (ux*wy-uy*wx) / D;
		if (tI < 0 or tI > 1) then -- no intersect with S2
			return false;
		end;

		return true;
	end;
end;

-- A square brush
ClearCanavas = function (this)
	if ArtPad_Settings["WarnClear"] then
		-- TODO: Ask for permission to clear
	end;
	for i = #this.mainLines, 1, -1 do
		this:JunkLine(i);
	end;
	for i = #this.mainTexts, 1, -1 do
		this:JunkText(i);
	end;
end;

SetColor = function (this, r, g, b, a)
	this.brushColor.r = r;
	this.brushColor.g = g;
	this.brushColor.b = b;
	this.brushColor.a = a;
	this.brushColorSample:SetTexture(r,g,b,a);
end;

SetTexColor = function (this, tex)
	tex:SetVertexColor(this.brushColor.r,
		this.brushColor.g,
		this.brushColor.b,
		this.brushColor.a);
end;

-- [[ Line Handling ]]
-- Allocator
CreateLine = function (this, x, y, a, b)
	local ix = math.floor(x);
	local iy = math.floor(y);
	local ia = math.floor(a);
	local ib = math.floor(b);

	local cx, cy = (ix + ia)/2, (iy + ib)/2;
	local dx, dy = ix-ia, iy-ib;
	local dmax = math.max(math.abs(dx),math.abs(dy));
	local dr = math.sqrt(dx*dx + dy*dy);
	local scale = 1/dmax*32;
	local sinA, cosA = dy/dr*scale, dx/dr*scale;
	if dr == 0 then
		return nil;
	end

	local pix;
	if #(this.junkLines) > 0 then
		pix = table.remove(this.junkLines); -- Recycling ftw!
	else
		pix = this.mainFrame:CreateTexture(nil, "OVERLAY");
		pix:SetTexture("Interface\\AddOns\\ArtPad\\line.tga");
	end;
	this:SetTexColor(pix);
	pix:ClearAllPoints();

	pix:SetPoint("CENTER", this.mainFrame, "BOTTOMLEFT", cx, cy);
	pix:SetWidth(dmax); pix:SetHeight(dmax);
	pix:SetTexCoord(this.GetCoordsForTransform(
		cosA, sinA, -(cosA+sinA)/2+0.5,
		-sinA, cosA, -(-sinA+cosA)/2+0.5));
	pix:Show();
	pix["lax"] = ix;
	pix["lay"] = iy;
	pix["lbx"] = ia;
	pix["lby"] = ib;

	table.insert(this.mainLines, pix);

	return pix, #this.mainLines;
end;

-- Deallocator
JunkLine = function (this, id)
	if this.mainLines[id] then
		local pix = table.remove(this.mainLines, id);
		if pix then
			table.insert(this.junkLines, pix);
			pix:Hide();
		end;
	end;
end;

-- [[ Text Handling ]]
CreateText = function (this, x, y, text)
	local ix = math.floor(x);
	local iy = math.floor(y);

	if #(this.junkTexts) > 0 then
		tex = table.remove(this.junkTexts); -- Recycling ftw!
	else
		tex = this.mainFrame:CreateFontString(nil, "OVERLAY");
	end;
	tex:SetFont("Fonts\\FRIZQT__.TTF",12);
	tex:SetJustifyH("LEFT");
	tex:SetPoint("BOTTOMLEFT", this.mainFrame, "BOTTOMLEFT", ix, iy);
	tex:SetTextColor(this.brushColor.r, this.brushColor.g,
		this.brushColor.b, this.brushColor.a);

	tex:SetText(text);
	tex:Show();
	tex["lax"] = ix;
	tex["lay"] = iy;
	tex["lbx"] = ix + tex:GetWidth();
	tex["lby"] = iy + tex:GetHeight();

	table.insert(this.mainTexts, tex);

	return tex, #this.mainTexts;
end;

JunkText = function (this, id)
	if this.mainTexts[id] then
		local tex = table.remove(this.mainTexts, id);
		if tex then
			table.insert(this.junkTexts, tex);
			tex:Hide();
		end;
	end;
end;

-- [[ Projection ]]
GetCoordsForTransform = function(A, B, C, D, E, F)
	-- http://www.wowwiki.com/SetTexCoord_Transformations
	local det = A*E - B*D;
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy;

	ULx, ULy = ( B*F - C*E ) / det, ( -(A*F) + C*D ) / det;
	LLx, LLy = ( -B + B*F - C*E ) / det, ( A - A*F + C*D ) / det;
	URx, URy = ( E + B*F - C*E ) / det, ( -D - A*F + C*D ) / det;
	LRx, LRy = ( E - B + B*F - C*E ) / det, ( -D + A -(A*F) + C*D ) / det;

	return ULx, ULy, LLx, LLy, URx, URy, LRx, LRy;
end;


}

ArtPad:CreateFrames();
ArtPad:OnLoad();

-- [[ Binding Constants ]]

BINDING_HEADER_ARTPAD = "ArtPad";
BINDING_NAME_ARTPAD_SHOW = "Show Art Window";
BINDING_NAME_ARTPAD_HIDE = "Hide Art Window";
BINDING_NAME_ARTPAD_TOGGLE = "Toggle Art Window";
