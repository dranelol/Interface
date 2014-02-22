--[[

Preform AV Enabler (c) Torrid of torridreflections.com

AUTHOR CONTACT INFORMATION

I can be reached at torrid@torridreflections.com, or user name Torrid at curse.com.


SOFTWARE LICENSE

You MAY:

* Run this software in your World of Warcraft client.
* Distribute this software PRIVATELY to individuals so long that it remains UNALTERED and free of charge.

You MAY NOT:

* Upload this software or derivatives of it to PUBLIC websites.
* Distribute altered copies of this file to ANYBODY.

]]

if ( not PreformAVEnabler ) then
	PreformAVEnabler = {};
end
local pave = PreformAVEnabler;

pave.onUpdateTime = 0;			-- used to prevent redundant status redraws
pave.automateBG = 0;			-- which BG to automate
pave.setMemberFramesPending = false;	-- if true, member frames will be shown or hidden when combat ends
pave.automating = false;

local columnWidth = 125;
local columnNoButtonWidth = columnWidth - 17;
local frameWidth = columnWidth * (pave.NUM_BGS + 1) + 155;


function pave.Frame_OnLoad(self)

	pave.SetWidgets();
	QueueStatusMinimapButton:HookScript("OnClick", pave.MiniMapButton);

	-- set column headers
	for i = 1, pave.NUM_BGS do
		_G["PreformAVEnablerHeaderText"..i]:SetText(pave.BG_NAME[i]);
		_G["PreformAVEnablerHideButton"..i].tooltipText = pave.BG_NAME[i];
	end
	PreformAVEnablerInfoHeader:SetText(PREFORM_AV_ENABLER_INFO);

	-- stripe the backgrounds
	for i = 2, 40, 2 do
		_G["PreformAVEnablerMember"..i]:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
								    tile = true, tileSize = 16, edgeSize = 16, });
		_G["PreformAVEnablerMember"..i]:SetBackdropColor(1, 1, 1, .2);
	end

	pave.CoreOnLoad(self);
end

function pave.SetMemberFrames()

	if ( pave.setMemberFramesPending ) then

		if ( not PreformAVEnablerMember1Button or not InCombatLockdown() ) then
			for i = 1, 40 do
				if ( pave.memberList[i] ) then
					_G["PreformAVEnablerMember"..i]:Show();
				else
					_G["PreformAVEnablerMember"..i]:Hide();
				end
			end

			pave.SetMasterFrameHeight();
			pave.setMemberFramesPending = false;
		end

	end
end

function pave.SetWidgets()

	if ( pave.raidLeader == pave.playerName ) then

		for i = 1, pave.NUM_BGS do
			if ( not pave.config.hideColumn[i] ) then
				_G["PreformAVEnablerFrameQueueButton"..i]:Show();
				_G["PreformAVEnablerFrameJoinButton"..i]:Show();
				_G["PreformAVEnablerFrameLeaveButton"..i]:Show();
				_G["PreformAVEnablerAutomateCheckButton"..i]:Show();
			else
				_G["PreformAVEnablerFrameQueueButton"..i]:Hide();
				_G["PreformAVEnablerFrameJoinButton"..i]:Hide();
				_G["PreformAVEnablerFrameLeaveButton"..i]:Hide();
				_G["PreformAVEnablerAutomateCheckButton"..i]:Hide();
			end
		end

		PreformAVEnablerThresholdSlider:Show();
		--PreformAVEnablerForcedJoinCheckButton:Hide();

	else
		for i = 1, pave.NUM_BGS do
			_G["PreformAVEnablerFrameQueueButton"..i]:Hide();
			_G["PreformAVEnablerFrameJoinButton"..i]:Hide();
			_G["PreformAVEnablerFrameLeaveButton"..i]:Hide();
			_G["PreformAVEnablerAutomateCheckButton"..i]:Hide();
		end
		PreformAVEnablerThresholdSlider:Hide();

		local x = 0;
		for i = 1, pave.NUM_BGS do
			if ( not pave.config.hideColumn[i] ) then
				x = x + 1;
			end
		end

		-- hide forced join check box if all BGs minimized/hidden due to space
		--[[
		if ( x == 0 ) then
			PreformAVEnablerForcedJoinCheckButton:Hide();
		else
			PreformAVEnablerForcedJoinCheckButton:Show();
		end
		]]
	end
end

-- call this instead of Update() to prevent redrawing 40 times at once when 40 users send singals at once
function pave.PaintWindow()

	-- if time since last update is > 0.1 seconds, update immediately
	if ( pave.onUpdateTime > 0.1 ) then
		pave.Update();
	else
		-- something needs a redraw, but we just redrew; update in 0.1 seconds
		pave.onUpdateTime = pave.config.redrawRate - 0.1;
	end
end

function pave.Update()

	if ( not PreformAVEnablerFrame:IsVisible() ) then
		return
	end
	pave.onUpdateTime = 0;

	local fontStr, name, status, deserterTime, deviation, t;
	local unqueued, queued, confirms, insides;
	local damagers, healers, tanks, unknowns = 0, 0, 0, 0;
	local confirmAvgs = {};
	local now = GetTime();

	-- Set column totals
	for i = 1, pave.NUM_BGS do
		
		unqueued, queued, confirms, insides, confirmAvgs[i] = pave.Tally(i);
		fontStr = _G["PreformAVEnablerMajorityText"..i];

		if ( confirms > 0 ) then
			fontStr:SetText(PREFORM_AV_ENABLER_CONFIRM.." "..confirms);
			fontStr:SetTextColor(1, 1, .1);

		elseif ( queued > 0 ) then
			fontStr:SetText(PREFORM_AV_ENABLER_QUEUED..": "..queued);
			fontStr:SetTextColor(.1, 1, 1);
		else
			fontStr:SetText("");
		end
	end

	-- iterate member rows
	for i, name in ipairs( pave.memberList ) do
		fontStr = _G["PreformAVEnablerMember"..i];

		status = pave.memberStatus[name];

		if ( not status ) then
			if ( pave.config.debug ) then
				DEFAULT_CHAT_FRAME:AddMessage("Error: "..name.." has no status table", 0, 1, 1);
			end
			break;
		end


		-- Name column
		fontStr = _G["PreformAVEnablerMember"..i.."NameText"];
		fontStr:SetText(name);

		if ( status.class and status.class ~= UNKNOWN ) then
			fontStr:SetTextColor(RAID_CLASS_COLORS[status.class].r, RAID_CLASS_COLORS[status.class].g, RAID_CLASS_COLORS[status.class].b);
		else
			fontStr:SetTextColor(0.5, 0.5, 0.5);
		end

		-- player not have the addon or has not sent status to us?
		if ( status.version == -1 ) then
			_G["PreformAVEnablerMember"..i.."VersionText"]:SetText("");
			_G["PreformAVEnablerMember"..i.."VersionText"]:SetTextColor(.5, .5, .5);
		else
			-- set version number
			_G["PreformAVEnablerMember"..i.."VersionText"]:SetText(status.version);
			if ( status.version < pave.version ) then
				if ( status.version < 3 ) then
					_G["PreformAVEnablerMember"..i.."VersionText"]:SetTextColor(.8, .4, .4);
				else
					_G["PreformAVEnablerMember"..i.."VersionText"]:SetTextColor(.6, .6, .6);
				end
			else
				_G["PreformAVEnablerMember"..i.."VersionText"]:SetTextColor(.9, .9, .9);
			end
		end

		-- is player offline?
		if ( not status.online ) then
			fontStr:SetTextColor(.5, .5, .5);

		-- deserter debuff?
		elseif ( status.deserter > 0 ) then
			fontStr:SetTextColor(1, .1, .1);
		end


		-- Queue status
		for j = 1, pave.NUM_BGS do
			if ( not pave.config.hideColumn[j] ) then

				fontStr = _G["PreformAVEnablerMember"..i.."StatusText"..j];
				if ( not status.online or status.deserter > 0 ) then
					fontStr:SetText("");
				elseif ( status.queues[j].state == 1 ) then
					fontStr:SetText(PREFORM_AV_ENABLER_QUEUED);
					fontStr:SetTextColor(.1, 1, 1);
				elseif ( status.queues[j].state == 2 ) then
					fontStr:SetText(PREFORM_AV_ENABLER_CONFIRM);
					fontStr:SetTextColor(1, 1, .1);
				elseif ( status.queues[j].state == 3 ) then
					fontStr:SetText(PREFORM_AV_ENABLER_INSIDE);
					fontStr:SetTextColor(1, 1, 1);
				else
					fontStr:SetText("");
				end

				fontStr = _G["PreformAVEnablerMember"..i.."IdText"..j];
				-- set timer text
				if ( not status.online or status.deserter > 0 ) then
					fontStr:SetText("");

				elseif ( status.queues[j].state == 0 ) then
					fontStr:SetText("");

				elseif ( status.queues[j].time > 0 ) then
					t = now - status.queues[j].time;
					if ( t > 99 ) then
						t = floor(t / 60).." m";
					else
						t = floor(t).." s";
					end
					fontStr:SetText(t);
				else
					fontStr:SetText("");
					fontStr:SetTextColor(1, 1, 0);
				end

				-- set timer color
				if ( status.queues[j].state == 1 ) then
					fontStr:SetTextColor(.1, 1, 1);

				elseif ( status.queues[j].state == 2 ) then
					
					-- the closer to average time, the greener it is
					deviation = math.abs(status.queues[j].time - confirmAvgs[j]);
					deviation = (deviation^2)/700;
					if ( deviation > 1 ) then
						deviation = 1;
					end

					fontStr:SetTextColor(0 + deviation, 1 - (deviation / 2), 0.1);

				elseif ( status.queues[j].state == 3 ) then
					fontStr:SetTextColor(1, 1, 1);
				end
			end
		end -- for j = 1, pave.NUM_BGS do

		
		-- Info column
		fontStr = _G["PreformAVEnablerMember"..i.."InfoText"];
		if ( not pave.config.hideInfoColumn ) then

			-- is player offline?
			if ( not status.online ) then
				if ( not pave.config.hideInfoColumn ) then

					if ( status.offlineTime > 0 ) then

						t = now - status.offlineTime;

						if ( t > 99 ) then
							t = floor(t / 60).." m";
						else
							t = floor(t).." s";
						end
					else
						t = "";
					end

					fontStr:SetText(PLAYER_OFFLINE.." "..t);
					fontStr:SetTextColor(.5, .5, .5);
				end

			-- player not have the addon or has not sent status to us?
			elseif ( status.version == -1 ) then

				fontStr:SetText(PREFORM_AV_ENABLER_NOTINSTALLED);
				fontStr:SetTextColor(.5, .5, .5);

			-- deserter debuff?
			elseif ( status.deserter > 0 ) then

				if ( status.deserter > now ) then
					deserterTime = status.deserter - now;
					fontStr:SetText(DESERTER.." "..format(SecondsToTimeAbbrev(deserterTime)));
					fontStr:SetTextColor(1, .1, .1);
				else
					status.deserter = 0;
				end

			else
				local icon;

				if ( status.role == "TANK" ) then
					icon = INLINE_TANK_ICON;
					tanks = tanks + 1;

				elseif ( status.role == "HEALER" ) then
					icon = INLINE_HEALER_ICON;
					healers = healers + 1;

				elseif ( status.role == "DAMAGER" ) then
					icon = INLINE_DAMAGER_ICON;
					damagers = damagers + 1
				else
					icon = "    ";
					unknowns = unknowns + 1;
				end

				if ( status.resilience ~= "?" or status.avgiLevel ~= "?" ) then
					fontStr:SetText(icon..NORMAL_FONT_COLOR_CODE..status.resilience.."|r ("..status.avgiLevel..")");
				else
					fontStr:SetText(icon);
				end
				fontStr:SetTextColor(0.8, 0.8, 0.8);
			end
		end

	end -- for i, name in ipairs( pave.memberList ) do

	if ( not pave.config.hideInfoColumn ) then
		PreformAVEnablerInfoSumText:SetText(INLINE_TANK_ICON..tanks.."  "..INLINE_HEALER_ICON..healers.."  "..INLINE_DAMAGER_ICON..damagers);
	end

	if ( #pave.memberList == 1 ) then
		PreformAVEnablerMember1InfoText:SetText(ERR_QUEST_PUSH_NOT_IN_PARTY_S);
		PreformAVEnablerMember1InfoText:SetTextColor(.5, .5, .5);
	end
end

function PreformAVEnablerFrameStatusButton_OnClick()
	-- prevent spam clicking
	if ( pave.lastCheck < GetTime() ) then
		pave.RequestStatus();
		pave.lastCheck = GetTime() + 5;
	end
end

function PreformAVEnablerFrameLeaveButton_OnClick(self)

	local bg = self:GetID();
	
	pave.RaidLeaveQueue(bg);
end

function PreformAVEnablerJoinButton_OnClick(self)

	local bg = self:GetID();

	pave.RaidJoin(bg);
end

function PreformAVEnablerAutomateCheckButton_OnClick(self)
	if (self:GetChecked()) then
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage(" -- Automate checked for bg "..self:GetID(), 0, 1, 1);
		end

		pave.automating = true;
		pave.automateBG = self:GetID();
		pave.waitUntilReady = false;
		pave.Automate();

		for i = 1, pave.NUM_BGS do
			if ( i ~= self:GetID() ) then
				_G["PreformAVEnablerAutomateCheckButton"..i]:SetChecked(nil);
			end
		end
	else
		if ( pave.config.debug ) then
			DEFAULT_CHAT_FRAME:AddMessage(" -- Automate disengaged", 0, 1, 1);
		end
		pave.automating = false;
		pave.automateBG = 0;
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
end

-- called once per frame
function PreformAVEnablerFrame_OnUpdate(self, arg)

	-- redraw timer
	pave.onUpdateTime = pave.onUpdateTime + arg;
	if ( pave.onUpdateTime > pave.config.redrawRate ) then
		pave.Update();
	end

	-- handle click drag window resize
	if ( self.isResizing ) then
		local _, pos = GetCursorPosition();
		pos = math.floor(pos);

		local h;
		local diff = pos - self.startPos;
		if ( diff == 0 ) then
			return
		end

		h = self.startHeight - diff;
		local members = #pave.memberList;
		if ( members < 5 ) then
			return
		end
		
		local padding = 115;
		if ( pave.raidLeader == pave.playerName ) then
			padding = 190;
		end

		local min = 15 * 5 + padding - 2;
		local max = members * 15 + padding;
		
		if ( h < min ) then
			h = min;
		end
		if ( h >= max ) then
			h = max;
			pave.config.sizeLimit = nil;
		else
			pave.config.sizeLimit = h;
		end

		PreformAVEnablerFrame:SetHeight(h);
		PreformAVEnablerMembersScrollFrame:SetHeight(h - padding + 4);
	end
end

function PreformAVEnablerResizeButton_OnEnter()
	if ( (not issecure() or not InCombatLockdown()) and #pave.memberList > 5 ) then
		SetCursor("CAST_CURSOR");
	end
end

function pave.FakeRaid(max)

	pave.memberList = {};
	pave.memberStatus = {};
	local name, online, i, j;

	if ( not max ) then
		max = 40;
	end

	--math.randomseed(time());
	j = math.floor(GetTime());
	for i = 1, j, 100 do
		random();
	end

	local variance1, variance2, variance3;

	for i = 1, max do
		name = "Player"..i;
		if ( name ) then
			pave.memberList[i] = name;
			if ( not pave.memberStatus[name] ) then
				pave.memberStatus[name] = {
					realm = "Black Dragonflight",
					battlegroup = "Stormstrike",
					version = pave.version,
					online = true,
					offlineTime = 0,
					role = "DAMAGER",
					class = "WARRIOR",
					spec = "",
					avgiLevel = math.random(300, 500),
					resilience = math.random(0, 5000),
					rating = math.random(1000, 2000),
					deserter = 0,
					lastUpdate = GetTime(),
					queues = {},
				};

			end
		end
	end

	local status;
	
	for bg = 1, pave.NUM_BGS do

		variance3 = math.random(0, 60);

		for i, name in ipairs(pave.memberList) do

			variance1 = math.random(0, math.random(0, variance3));
			variance2 = math.random(0, 100);

			status = pave.memberStatus[name];
			status.queues[bg] = {};

			if ( variance2 < 75 ) then
				status.queues[bg].state = 2;
			elseif ( variance2 < 5 ) then
				status.queues[bg].state = 3;
			else
				status.queues[bg].state = 1;
			end
			status.queues[bg].time = GetTime() - variance1;
		end
	end


	if ( max >= 4 ) then
		pave.memberStatus["Player4"].deserter = GetTime() + 30;
	end
	if ( max >= 6 ) then
		pave.memberStatus[pave.memberList[6]].online = false;
		pave.memberStatus[pave.memberList[6]].offlineTime = GetTime();
	end
	if ( max >= 9 ) then
		pave.memberStatus["Player9"].version = -1;
	end
	if ( max >= 10 ) then
		pave.memberStatus["Player10"].class = "DRUID";
		pave.memberStatus["Player10"].role = "TANK";
		pave.memberStatus["Player10"].version = 2.66;
	end
	if ( max >= 11 ) then
		pave.memberStatus["Player11"].class = "PALADIN";
		pave.memberStatus["Player11"].role = "HEALER";
		pave.memberStatus["Player11"].version = 3;
	end
	if ( max >= 12 ) then
		pave.memberStatus["Player12"].version = -1;
		pave.memberStatus["Player12"].class = "DRUID";
	end

	pave.setMemberFramesPending = true;
	pave.SetMemberFrames();

	-- raid member data loaded
	pave.neverUpdated = 1;

	pave.newGroup = false;

	pave.Update();
end

function pave.MiniMapButton(self, button)
	if ( button == "RightButton" ) then
		local info;

		info = UIDropDownMenu_CreateInfo();
		info.isTitle = 1;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);

		info = UIDropDownMenu_CreateInfo();
		info.text = PREFORM_AV_ENABLER_PREFORM;
		info.func = pave.ShowMasterFrame;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
	end
end

function pave.ShowMasterFrame()
	if ( pave.IfSecure() ) then
		return
	end

	PreformAVEnablerFrame:Show();
end

function PreformAVEnablerMenu()
	ToggleDropDownMenu(1, nil, PreformAVEnablerDropDown, "cursor", 0, 0);
end

--[[
function PreformAVEnablerMemberButton_OnLoad(self)
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");

	SecureUnitButton_OnLoad(self, "raid"..self:GetParent():GetID(), PreformAVEnablerMenu);
end
]]
function PreformAVEnablerMemberButton_OnLoad(self)
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");

	SecureUnitButton_OnLoad(self, "raid"..self:GetParent():GetID(), PreformAVEnablerMenu);
end

function PreformAVEnablerDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, PreformAVEnablerDropDown_Initialize, "MENU");
end

function PreformAVEnablerDropDown_Initialize(self)
	local menu;
	local name;
	local id = self:GetParent():GetID();
	local unit = "raid"..id;

	if ( UnitIsUnit(unit, "player") ) then
		menu = "SELF";
	elseif ( UnitIsPlayer(unit) ) then
		id = UnitInRaid(unit);
		if ( id ) then
			menu = "RAID";
			name = GetRaidRosterInfo(id +1);
		elseif ( UnitInParty(unit) ) then
			menu = "PARTY";
		end
	end
	if ( menu ) then
		UnitPopup_ShowMenu(PreformAVEnablerDropDown, menu, unit, name, id);
	end
end

function pave.EnableRaidButtons()
	local f, t;

	for i = 1, 40 do

		f = CreateFrame("Button", "PreformAVEnablerMember"..i.."Button", _G["PreformAVEnablerMember"..i], "SecureUnitButtonTemplate");
		f:SetPoint("TOPLEFT", 0, 0);
		f:SetWidth(75);
		f:SetHeight(15);
		f:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD");
		f:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		SecureUnitButton_OnLoad(f, "raid"..f:GetParent():GetID(), PreformAVEnablerMenu);
	end
end

function PreformAVEnablerButtonize_OnClick(self)
	if ( self:GetChecked() ) then
		if ( not PreformAVEnablerMember1Button ) then

			if ( InCombatLockdown() ) then

				-- can't create buttons in combat
				self:SetChecked(nil);
				PlaySoundFile("sound\\interface\\Error.wav");
				UIErrorsFrame:AddMessage( ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0 );
				return

			else

				-- not in combat, create buttons
				pave.config.buttonize = true;
				pave.EnableRaidButtons();
			end
		else
			-- buttons already created
			pave.config.buttonize = true;
		end
	else
		pave.config.buttonize = false;
	end
end

function pave.IfSecure()
	if ( PreformAVEnablerMember1Button and InCombatLockdown() ) then
		PlaySoundFile("sound\\interface\\Error.wav");
		UIErrorsFrame:AddMessage( ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0 );
		return true;
	end
end

function pave.MemberTemplateOnEnter(frame, frameID)
	local name = pave.memberList[frameID];
	local status = pave.memberStatus[name];
	if ( not status ) then
		return
	end

	local version = status.version;
	if ( version == -1 ) then version = PREFORM_AV_ENABLER_NOTINSTALLED; end

	GameTooltip:SetOwner(frame, "ANCHOR_LEFT");

	local text =
		GREEN_FONT_COLOR_CODE..name..
		"|r\nClass: "..HIGHLIGHT_FONT_COLOR_CODE..(LOCALIZED_CLASS_NAMES_MALE[status.class] or status.class)..
		"|r\nRealm: "..HIGHLIGHT_FONT_COLOR_CODE..status.realm..
		"|r\nBattlegroup: "..HIGHLIGHT_FONT_COLOR_CODE..status.battlegroup..
		"|r\nRole: "..HIGHLIGHT_FONT_COLOR_CODE..(_G[status.role] or status.role)..
		"|r\nResilience: "..HIGHLIGHT_FONT_COLOR_CODE..status.resilience..
		"|r\nAvg iLevel: "..HIGHLIGHT_FONT_COLOR_CODE..status.avgiLevel..
		"|r\nRating: "..HIGHLIGHT_FONT_COLOR_CODE..status.rating..
		"|r\nVersion: "..HIGHLIGHT_FONT_COLOR_CODE..version
	;

	local now = GetTime();

	if ( status.deserter > now ) then
		local deserterTime = status.deserter - now;
		text = text.."\n"..RED_FONT_COLOR_CODE..DESERTER.." "..format(SecondsToTimeAbbrev(deserterTime)).."|r";
	end
	if ( not status.online ) then
		local offlineTime = now - status.offlineTime;
		text = text.."\n|cff808080"..PLAYER_OFFLINE.." "..format(SecondsToTimeAbbrev(offlineTime)).."|r";
	end

	GameTooltip:SetText( text, nil, nil, nil, nil, 1 );
end

function PreformAVEnablerHideButton_OnClick(button, id)
	if ( pave.IfSecure() ) then
		return
	end
	if ( not id ) then
		id = button:GetID();
		PlaySound("igCharacterInfoTab");
	end

	if ( pave.config.hideColumn[id] ) then
		pave.ShowBGColumn(id);
	else
		pave.HideBGColumn(id);
	end
end

function pave.ShowBGColumn(id)
	local button = _G["PreformAVEnablerHideButton"..id];
	
	pave.config.hideColumn[id] = false;
	button:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	button:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
	button:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

	for i = 1, 40 do
		_G["PreformAVEnablerMember"..i.."StatusText"..id]:SetWidth(55);
		_G["PreformAVEnablerMember"..i.."IdText"..id]:SetWidth(70);
	end

	_G["PreformAVEnablerHeaderText"..id]:SetWidth(columnWidth);
	_G["PreformAVEnablerMajorityText"..id]:SetWidth(columnWidth);
	_G["PreformAVEnablerHeaderText"..id]:SetText(pave.BG_NAME[id]);

	_G["PreformAVEnablerMajorityText"..id]:Show();

	pave.SetWidgets();
	pave.SetMasterFrameWidth();

	if ( PreformAVEnablerFrame:IsVisible() ) then
		pave.Update();
	end
end

function pave.HideBGColumn(id)
	local button = _G["PreformAVEnablerHideButton"..id];

	pave.config.hideColumn[id] = true;
	button:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	button:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down");
	button:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

	for i = 1, 40 do
		_G["PreformAVEnablerMember"..i.."StatusText"..id]:SetWidth(16);
		_G["PreformAVEnablerMember"..i.."IdText"..id]:SetWidth(1);
		_G["PreformAVEnablerMember"..i.."StatusText"..id]:SetText("");
		_G["PreformAVEnablerMember"..i.."IdText"..id]:SetText("");
	end

	_G["PreformAVEnablerHeaderText"..id]:SetWidth(17);
	_G["PreformAVEnablerMajorityText"..id]:SetWidth(17);
	_G["PreformAVEnablerHeaderText"..id]:SetText("");
--	_G["PreformAVEnablerMajorityText"..id]:SetText("");

	pave.SetWidgets();
	pave.SetMasterFrameWidth();

	if ( PreformAVEnablerFrame:IsVisible() ) then
		pave.Update();
	end
end

function pave.InfoHideButton_OnClick(button)
	if ( pave.IfSecure() ) then
		return
	end
	PlaySound("igCharacterInfoTab");

	if ( pave.config.hideInfoColumn ) then
		pave.ShowInfoColumn();
	else
		pave.HideInfoColumn();
	end
end

function pave.ShowInfoColumn()

	pave.config.hideInfoColumn = false;

	local button = PreformAVEnablerInfoHideButton;
	button:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	button:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down");
	button:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

	for i = 1, 40 do
		_G["PreformAVEnablerMember"..i.."InfoText"]:SetWidth(columnWidth);
	end

	PreformAVEnablerInfoHeader:SetWidth(columnWidth);
	PreformAVEnablerInfoSumText:SetWidth(columnWidth);
	PreformAVEnablerInfoHeader:SetText(PREFORM_AV_ENABLER_INFO);

	PreformAVEnablerInfoSumText:Show();

	pave.SetMasterFrameWidth();

	if ( PreformAVEnablerFrame:IsVisible() ) then
		pave.Update();
	end
end

function pave.HideInfoColumn()

	pave.config.hideInfoColumn = true;

	local button = PreformAVEnablerInfoHideButton;
	button:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	button:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down");
	button:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight");

	for i = 1, 40 do
		_G["PreformAVEnablerMember"..i.."InfoText"]:SetWidth(16);
		_G["PreformAVEnablerMember"..i.."InfoText"]:SetText("");
	end

	PreformAVEnablerInfoHeader:SetWidth(17);
	PreformAVEnablerInfoSumText:SetWidth(17);
	PreformAVEnablerInfoHeader:SetText("");
	PreformAVEnablerInfoSumText:SetText("");

	pave.SetMasterFrameWidth();

	if ( PreformAVEnablerFrame:IsVisible() ) then
		pave.Update();
	end
end

function pave.SetMasterFrameHeight()
	local members = #pave.memberList;
	if ( members < 1 ) then
		members = 1;
	end

	local padding = 115;
	if ( UnitIsGroupLeader("player") ) then
		padding = 190;
	end

	local height = members * 15 + padding;
	if ( pave.config.sizeLimit and height > pave.config.sizeLimit ) then
		if ( pave.config.sizeLimit < (5 * 15 + padding) ) then
			pave.config.sizeLimit = 5 * 15 + padding;
		end
		PreformAVEnablerFrame:SetHeight(pave.config.sizeLimit);
		PreformAVEnablerMembersScrollFrame:SetHeight(pave.config.sizeLimit - padding + 4);
	else
		PreformAVEnablerFrame:SetHeight(height);
		PreformAVEnablerMembersScrollFrame:SetHeight(height - padding + 4);
	end

	height = 604 - (15 * (40 - members));
	PreformAVEnablerMembersScrollFrameChildFrame:SetHeight(height);

	if ( UnitIsGroupLeader("player") ) then
		PreformAVEnablerInfoSumText:SetPoint("BOTTOMLEFT", PreformAVEnablerFrame, "BOTTOMLEFT", 100, 130);
	else
		PreformAVEnablerInfoSumText:SetPoint("BOTTOMLEFT", PreformAVEnablerFrame, "BOTTOMLEFT", 100, 55);
	end
end

function pave.SetMasterFrameWidth()
	local x = 0;
	-- determine how many columns are hidden to calculate frame width
	for i = 1, pave.NUM_BGS do
		if ( pave.config.hideColumn[i] ) then
			x = x + 1;
		end
	end
	if ( pave.config.hideInfoColumn ) then
		x = x + 1;
	end

	-- set width of master, scroll, and scroll child frames
	PreformAVEnablerFrame:SetWidth(frameWidth - (x * columnNoButtonWidth));
	PreformAVEnablerMembersScrollFrame:SetWidth(frameWidth - 42 - (x * columnNoButtonWidth));
	PreformAVEnablerMembersScrollFrameChildFrame:SetWidth(frameWidth - 15 - (x * columnNoButtonWidth));

	-- set width of member frames
	for i = 1, 40 do
		_G["PreformAVEnablerMember"..i]:SetWidth(frameWidth - 45 - (x * columnNoButtonWidth));
	end
end

function pave.CompactColumn(bg)

	if ( pave.config.autoCompact ) then

		local status;
		local allNone = true;

		for _, name in ipairs( pave.memberList ) do

			status = pave.memberStatus[name];

			if ( status.queues[bg].state ~= 0 ) then
				allNone = false;
				break;
			end
		end

		if ( pave.config.hideColumn[bg] and allNone == false ) then

			pave.ShowBGColumn(bg);

		elseif ( not pave.config.hideColumn[bg] and allNone == true ) then 

			if ( pave.lastQueued ~= bg ) then

				pave.HideBGColumn(bg);
			end
		end
	end
end
