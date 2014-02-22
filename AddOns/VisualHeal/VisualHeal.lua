local VisualHeal = LibStub("AceAddon-3.0"):NewAddon("VisualHeal", "AceConsole-3.0");
VisualHeal.EventFrame = CreateFrame("Frame");
VisualHeal.EventFrame:SetScript("OnEvent", function (this, event, ...) VisualHeal[event](VisualHeal, ...) end);
VisualHeal.SharedMedia = LibStub("LibSharedMedia-3.0");

--[ Frequently Accessed Globals ]--

local UnitName = UnitName;
local UnitHealth = UnitHealth;
local UnitHealthMax = UnitHealthMax;
local UnitClass = UnitClass;
local UnitIsPlayer = UnitIsPlayer;
local RAID_CLASS_COLORS = RAID_CLASS_COLORS;
local select = select;

--[ Frame Factory and Frame Chains ]--

local incoming;
local freeList;
local outgoingList = {};
local outgoingTable = {};

function VisualHeal:LayoutBars()
    local position = self.db.profile.OutgoingPosition;
    local offset = 0;
    for i, frame in ipairs(outgoingList) do
        frame:ClearAllPoints();
        frame:SetPoint(position.point, position.parent, position.relpoint, position.x, position.y + offset);
        offset = offset + self.db.profile.Height + self.db.profile.Spacing;
    end
end

function VisualHeal:CheckGUID(frame)
    local unitGUID = UnitGUID(frame.unit);
    if (unitGUID ~= frame.unitGUID) then
        if (UnitGUID("target") == frame.unitGUID) then
            frame.unit = "target";
        elseif (UnitGUID("focus") == frame.unitGUID) then
            frame.unit = "focus";
        else
            self:BarRelease(frame);
            return true;
        end
    end
    return false;
end

function VisualHeal:IncomingBarUpdate()
    local frame = incoming or self:BarCreate(true);
    incoming = frame;

    local width = self.db.profile.Width;

    -- Update health
    local health = UnitHealth("player");
    local healthMax = UnitHealthMax("player");
    local hp = health / healthMax;
    frame.health:SetPoint("BOTTOMRIGHT", frame.backdrop, "BOTTOMLEFT", width * hp, 0);
    frame.health:SetVertexColor(hp < 0.5 and 1.0 or 2.0 * (1.0 - hp), hp > 0.5 and 0.8 or 1.6 * hp, 0.0);

    -- Update incoming heal
    local heal = UnitGetIncomingHeals("player") or 0;
    local playerHeal = UnitGetIncomingHeals("player", "player") or 0;
    local othersHeal = heal - playerHeal;
    if (othersHeal > 0) then
        frame.othersHeal:SetPoint("BOTTOMRIGHT", frame.health, "BOTTOMRIGHT", width * othersHeal / healthMax, 0);
        frame:Show();
    else
        frame:Hide();
        return;
    end
end

function VisualHeal:BarUpdate(frame)
    if self:CheckGUID(frame) then return end;

    local width = self.db.profile.Width;

    -- Update health
    local health = UnitHealth(frame.unit);
    local healthMax = UnitHealthMax(frame.unit);
    local hp = health / healthMax;
    frame.health:SetPoint("BOTTOMRIGHT", frame.backdrop, "BOTTOMLEFT", width * hp, 0);
    frame.health:SetVertexColor(hp < 0.5 and 1.0 or 2.0 * (1.0 - hp), hp > 0.5 and 0.8 or 1.6 * hp, 0.0);

    -- Update player's heal
    local playerHeal = UnitGetIncomingHeals(frame.unit, "player") or 0;
    frame.playerHeal:SetPoint("BOTTOMRIGHT", frame.health, "BOTTOMRIGHT", width * playerHeal / healthMax, 0);
    local waste = 0;
    if (playerHeal > (healthMax - health)) then
        waste = (playerHeal - (healthMax - health)) / playerHeal;
    end
    local red = waste > 0.1 and 1 or waste * 10;
    local green = waste < 0.1 and 1 or -2.5 * waste + 1.25;
    if (waste < 0.0) then
        green = 1.0;
        red = 0.0;
    end
    frame.playerHeal:SetVertexColor(red, green, 0.0);

    -- Update other's heal
    local othersHeal = (UnitGetIncomingHeals(frame.unit) or 0) - playerHeal;
    frame.othersHeal:SetPoint("BOTTOMRIGHT", frame.health, "RIGHT", width * othersHeal / healthMax, 0);
end

function VisualHeal:BarConfigureAll()
    if (incoming) then
        self:BarConfigure(incoming);
    end
    for i, frame in ipairs(outgoingList) do
        self:BarConfigure(frame);
    end
    local frame = freeList;
    while (frame) do
        self:BarConfigure(frame);
        frame = frame.nextFrame;
    end
end

function VisualHeal:BarConfigure(frame)
    local barTexture = self.SharedMedia:Fetch('statusbar', self.db.profile.Texture);
    local borderTexture = self.SharedMedia:Fetch("border", self.db.profile.Border);
    local font = self.SharedMedia:Fetch("font", self.db.profile.Font);
    local width = self.db.profile.Width;
    local height = self.db.profile.Height;
    local edgeSize = (height - 2) / 1.5;
    local borderWidth = (edgeSize + 2 / 1.5) / 2;
    if (edgeSize > 16) then
        edgeSize = 16;
        borderWidth = edgeSize / 2;
    end
    frame.border:SetBackdrop({edgeFile = borderTexture, edgeSize = edgeSize});
    frame.border:SetBackdropBorderColor(self.db.profile.BorderBrightness, self.db.profile.BorderBrightness, self.db.profile.BorderBrightness, 1.0);
    frame.border:SetWidth(width + borderWidth - 2);
    frame.border:SetHeight(height + borderWidth - 2);

    frame.health:SetTexture(barTexture);

    if (not frame.isIncoming) then
        frame.playerHeal:SetTexture(barTexture);
    end

    frame.othersHeal:SetTexture(barTexture);

    frame.text:SetFont(font, self.db.profile.FontSize, self.db.profile.FontOutline and "OUTLINE" or nil);

    frame:SetWidth(width);
    frame:SetHeight(height);
    frame.spark:SetHeight(height * 1.5);

    if (frame.isIncoming) then
        local position = self.db.profile.IncomingPosition;
        frame:ClearAllPoints();
        frame:SetPoint(position.point, position.parent, position.relpoint, position.x, position.y);
    else
        local position = self.db.profile.OutgoingPosition;
        frame:ClearAllPoints();
        frame:SetPoint(position.point, position.parent, position.relpoint, position.x, position.y);
    end
end

function VisualHeal:BarCreate(isIncoming)
    local frame = CreateFrame("Frame", nil, UIParent);
    frame:Hide();
    frame.isIncoming = isIncoming;
    frame:SetFrameStrata("HIGH");
    frame.border = CreateFrame("Frame", nil, frame);
    frame.border:SetPoint("CENTER", frame, "CENTER", 0, 0);
    frame.border:Show();

    frame.backdrop = frame:CreateTexture(nil, "BACKGROUND");
    frame.backdrop:SetPoint("TOPLEFT", frame ,"TOPLEFT", 0, 0)
    frame.backdrop:SetPoint("BOTTOMRIGHT", frame ,"BOTTOMRIGHT", 0, 0)
    frame.backdrop:SetTexture(0, 0, 0, 0.5)

    frame.health = frame:CreateTexture(nil, "BORDER")
    frame.health:SetPoint("TOPLEFT", frame.backdrop, "TOPLEFT", 0, 0)

    if (not isIncoming) then
        frame.playerHeal = frame:CreateTexture(nil, "BORDER")
        frame.playerHeal:ClearAllPoints()
        frame.playerHeal:SetPoint("TOPLEFT", frame.health, "TOPRIGHT", 0, 0)
    end

    frame.othersHeal = frame:CreateTexture(nil, "ARTWORK")
    frame.othersHeal:ClearAllPoints()
    frame.othersHeal:SetPoint("TOPLEFT", frame.health, "TOPRIGHT", 0, 0)
    if (isIncoming) then
        frame.othersHeal:SetVertexColor(0.45, 0.65, 0.45, 1);
    else
        frame.othersHeal:SetVertexColor(0.25, 0.45, 0.25, 0.7);
    end

    frame.spark = frame:CreateTexture(nil, "OVERLAY");
    frame.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
    frame.spark:SetVertexColor(1, 1, 1, 1)
    frame.spark:SetBlendMode('ADD');
    frame.spark:SetWidth(10);
    frame.spark:SetPoint("CENTER", frame.health, "RIGHT", 0, 0);

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    frame.text:SetPoint("CENTER", frame.backdrop, "CENTER", 0, 0);

    self:BarConfigure(frame);
    return frame;
end

function VisualHeal:BarAllocate(unit, unitGUID)
    local frame;
    if (freeList) then
        frame = freeList;
        freeList = freeList.nextFrame;
    else
        frame = self:BarCreate();
    end
    frame.unit = unit;
    frame.unitGUID = unitGUID;

    -- Text
    frame.text:SetText(UnitName(unit));
    if (UnitIsPlayer(unit)) then
        local tab = RAID_CLASS_COLORS[select(2, UnitClass(unit)) or ""];
        frame.text:SetTextColor(tab.r, tab.g, tab.b);
    else
        frame.text:SetTextColor(230, 230, 0);
    end

    table.insert(outgoingList, frame);
    outgoingTable[unitGUID] = frame;
    frame:Show();
    self:LayoutBars();
    return frame;
end

function VisualHeal:BarRelease(frame)
    frame:Hide();
    frame.nextFrame = freeList;
    freeList = frame;
    outgoingTable[frame.unitGUID] = nil;
    for i, v in ipairs(outgoingList) do
        if (v == frame) then
            table.remove(outgoingList, i);
            break;
        end
    end
    self:LayoutBars();
end

--[ Settings ]--

function VisualHeal:GetOptionsTable()
    local options =
    {
        type = "group",
        args =
        {
            general =
            {
                type = "group",
                icon = "",
                name = "VisualHeal",
                handler = self,
                childGroups = "tree",
                args =
                {
                    toggleconfigmode =
                    {
                        name = "Configuration Mode",
                        type = "toggle",
                        order = 1,
                        desc = "Toggle configuration mode to allow moving bars and setting appearance options",
                        get = function() return self.ConfigMode end,
                        set = function() self:Toggle() end,
                    },
                    general =
                    {
                        type = "group",
                        name = "General Options",
                        guiInline = true,
                        order = 10,
                        args =
                        {
                            outgoing =
                            {
                                name = "Enable Outgoing",
                                type = "toggle",
                                order = 1,
                                desc = "Toggles display of the bars that show your outgoing healing",
                                get = function() return self.db.profile.ShowOutgoing end,
                                set = function()
                                    self.db.profile.ShowOutgoing = not self.db.profile.ShowOutgoing;
                                    self:Toggle();
                                    self:Toggle();
                                end,
                            },
                            incoming =
                            {
                                name = "Enable Incoming",
                                type = "toggle",
                                order = 2,
                                desc = "Toggles display of the bar that shows incoming healing to you",
                                get = function() return self.db.profile.ShowIncoming end,
                                set = function()
                                    self.db.profile.ShowIncoming = not self.db.profile.ShowIncoming;
                                    self:Toggle();
                                    self:Toggle();
                                end,
                            },
                        },
                    },
                    appearance =
                    {
                        type = "group",
                        name = "Appearance Options",
                        guiInline = true,
                        order = 20,
                        args =
                        {
                            width =
                            {
                                name = "Width",
                                type = "range",
                                order = 1,
                                desc = "Set the width of all bars",
                                min = 100,
                                max = 600,
                                step = 1,
                                get = function() return self.db.profile.Width end,
                                set = function(info, value)
                                    self.db.profile.Width = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            height =
                            {
                                name = "Height",
                                type = "range",
                                order = 2,
                                desc = "Set the height of all bars",
                                min = 10,
                                max = 100,
                                step = 1,
                                get = function() return self.db.profile.Height end,
                                set = function(info, value)
                                    self.db.profile.Height = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            spacing =
                            {
                                name = "Spacing",
                                type = "range",
                                order = 3,
                                desc = "Set the spacing between outgoing bars",
                                min = 0,
                                max = 15,
                                step = 1,
                                get = function() return self.db.profile.Spacing end,
                                set = function(info, value)
                                    self.db.profile.Spacing = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            texture =
                            {
                                name = "Bar Texture",
                                type = 'select',
                                order = 5,
                                desc = "Select texture to use for all bars",
                                dialogControl = 'LSM30_Statusbar',
                                values = AceGUIWidgetLSMlists.statusbar,
                                get = function()
                                    return self.db.profile.Texture;
                                end,
                                set = function(info, value)
                                    self.db.profile.Texture = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            border =
                            {
                                name = "Border Texture",
                                type = 'select',
                                order = 6,
                                desc = "Select texture to use for the border of all bars",
                                dialogControl = 'LSM30_Border',
                                values = AceGUIWidgetLSMlists.border,
                                get = function()
                                    return self.db.profile.Border;
                                end,
                                set = function(info, value)
                                    self.db.profile.Border = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            bordercolor =
                            {
                                name = "Border Color",
                                type = "color",
                                hasAlpha = true,
                                order = 7,
                                desc = "Set color of the border of all bars",
                                get = function(info)
                                    return unpack(self.db.profile.BorderColor);
                                end,
                                set = function(info, r, g, b, a)
                                    self.db.profile.BorderColor = {r, g, b, a};
                                    self:BarConfigureAll();
                                end,
                            },
                            font =
                            {
                                name = "Font",
                                type = "select",
                                order = 8,
                                desc = "Select font to use for all bars",
                                dialogControl = "LSM30_Font",
                                values = AceGUIWidgetLSMlists.font,
                                get = function() return self.db.profile.Font end,
                                set = function(info, value)
                                    self.db.profile.Font = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            fontsize =
                            {
                                name = "Font Size",
                                type = "range",
                                order = 9,
                                desc = "Set the font size of all bars",
                                min = 6,
                                max = 30,
                                step = 1,
                                get = function() return self.db.profile.FontSize end,
                                set = function(info, value)
                                    self.db.profile.FontSize = value;
                                    self:BarConfigureAll();
                                end,
                            },
                            fontoutline =
                            {
                                name = "Font Outline",
                                type = "toggle",
                                order = 10,
                                desc = "Toggles outline on the font of all bars",
                                get = function() return self.db.profile.FontOutline end,
                                set = function()
                                    self.db.profile.FontOutline = not self.db.profile.FontOutline;
                                    self:BarConfigureAll();
                                end,
                            },
                        },
                    },
                },
            },
            profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db),
        },
    };
    return options;
end

function VisualHeal:OpenConfig()
    InterfaceOptionsFrame_OpenToCategory("VisualHeal");
end

--[ ConfigMode Support ]--

function VisualHeal:MakeDragable(frame)
    if (not frame.dragable) then
        frame:SetMovable(true);
        frame:RegisterForDrag("LeftButton");
        self.OnDragStart = self.OnDragStart or function(frame)
            if (self.ConfigMode) then
                GameTooltip:Hide();
                frame:EnableKeyboard(true);
                frame:StartMoving();
            end
        end
        frame:SetScript("OnDragStart", self.OnDragStart);
        self.OnDragStop = self.OnDragStop or function(frame)
            frame:EnableKeyboard(false);
            frame:StopMovingOrSizing();
            local position;
            if (frame.isIncoming) then
                if (not self.db.profile.IncomingPosition) then
                    self.db.profile.IncomingPosition = {};
                end
                position = self.db.profile.IncomingPosition;
            else
                if (not self.db.profile.OutgoingPosition) then
                    self.db.profile.OutgoingPosition = {};
                end
                position = self.db.profile.OutgoingPosition;
            end
            position.point, position.parent, position.relpoint, position.x, position.y = frame:GetPoint();
        end
        frame:SetScript("OnDragStop", self.OnDragStop);
        self.OnKeyUp = self.OnKeyUp or function(frame, key)
            local point, parent, relpoint, x, y = frame:GetPoint();
            if (key == "UP") then y = y + 1;
            elseif (key == "DOWN") then y = y - 1;
            elseif (key == "RIGHT") then x = x + 1;
            elseif (key == "LEFT") then x = x - 1; end
            frame:SetPoint(point, parent, relpoint, x, y);
        end
        frame:SetScript("OnKeyUp", self.OnKeyUp);
        self.OnEnter = self.OnEnter or function(frame)
            if (self.ConfigMode and not frame:IsDragging()) then
                GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
                GameTooltip:SetText("|cFFFFFFFFDrag with mouse.\n|cFFCCCCCCUse arrow keys while dragging to fine tune position.");
            end
        end
        frame:SetScript("OnEnter", self.OnEnter);
        self.OnLeave = self.OnLeave or function(frame)
            GameTooltip:Hide();
        end
        frame:SetScript("OnLeave", self.OnLeave);
        frame:EnableKeyboard(false);
        frame.dragable = true;
    end
    frame:EnableMouse(true);
end

function VisualHeal:ShowBars()
    if (not self.ConfigMode) then
        self.ConfigMode = true;
        self:OnDisable();
    end
    if (incoming) then
        incoming:Hide();
    end
    while (#outgoingList > 0) do
        self:BarRelease(outgoingList[1]);
    end
    if (self.db.profile.ShowIncoming) then
        incoming = incoming or self:BarCreate(true);
        incoming.text:SetText("Incoming");
        incoming.text:SetTextColor(1, 1, 1);
        incoming.health:SetPoint("BOTTOMRIGHT", incoming.backdrop, "BOTTOMRIGHT", 0, 0);
        incoming.othersHeal:SetPoint("BOTTOMRIGHT", incoming.health, "BOTTOMRIGHT", 0, 0);
        incoming.health:SetVertexColor(0.3, 0.3, 0.8);
        incoming.spark:Hide();
        self:MakeDragable(incoming);
        incoming:Show();
    end
    if (self.db.profile.ShowOutgoing) then
        local frame = self:BarAllocate("player", UnitGUID("player"));
        frame.text:SetText("Outgoing");
        frame.text:SetTextColor(1, 1, 1);
        frame.health:SetPoint("BOTTOMRIGHT", frame.backdrop, "BOTTOMRIGHT", 0, 0);
        frame.playerHeal:SetPoint("BOTTOMRIGHT", frame.health, "BOTTOMRIGHT", 0, 0);
        frame.othersHeal:SetPoint("BOTTOMRIGHT", frame.health, "RIGHT", 0, 0);
        frame.health:SetVertexColor(0.3, 0.3, 0.8);
        frame.spark:Hide();
        self:MakeDragable(frame);
        frame:Show();
        self:LayoutBars();
    end
end

function VisualHeal:HideBars()
    if (incoming) then
        incoming:Hide();
        incoming.text:SetText();
        incoming.spark:Show();
        incoming:EnableMouse(false);
    end
    if (#outgoingList > 0) then
        local frame = outgoingList[1];
        frame.spark:Show();
        frame:EnableMouse(false);
        self:BarRelease(frame);
    end
    if (self.ConfigMode) then
        self.ConfigMode = nil;
        self:OnEnable();
    end
end

function VisualHeal:Toggle()
    if (self.ConfigMode) then
        self:HideBars();
    else
        self:ShowBars();
    end
end

CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {};
CONFIGMODE_CALLBACKS["VisualHeal"] =
function(action)
    if (action == "ON") then
        VisualHeal:ShowBars();
    elseif (action == "OFF") then
        VisualHeal:HideBars();
    end
end

--[ Init/Enable/Disable ]--

function VisualHeal:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("VisualHealDB",
    {
        profile =
        {
            ShowOutgoing = true,
            ShowIncoming = true,
            Width = 160,
            Height = 12,
            Spacing = 1,
            Texture = "Castbars",
            Border = "Blizzard Tooltip",
            BorderColor = {0.0, 0.0, 0.0, 0.8},
            Font = "Friz Quadrata TT",
            FontSize = 9,
            FontOutline = false,
            OutgoingPosition = {point = "CENTER", relpoint = "CENTER", x = 0, y = -220},
            IncomingPosition = {point = "CENTER", relpoint = "CENTER", x = 0, y = -295},
        }
    });
    self.db.RegisterCallback(self, "OnProfileChanged", "BarConfigureAll");
    self.db.RegisterCallback(self, "OnProfileCopied", "BarConfigureAll");
    self.db.RegisterCallback(self, "OnProfileReset", "BarConfigureAll");

    self.options = self:GetOptionsTable();
    LibStub("AceConfig-3.0"):RegisterOptionsTable("VisualHeal", self.options);
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("VisualHeal", nil, nil, "general");
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("VisualHeal", "Profiles", "VisualHeal", "profile");
    self:RegisterChatCommand("vh", "OpenConfig");
    self:RegisterChatCommand("visualheal", "OpenConfig");

    self.SharedMedia:Register("statusbar", "Castbars", [[Interface\AddOns\VisualHeal\Castbars]])
    self.SharedMedia.RegisterCallback(self, "LibSharedMedia_Registered", "BarConfigureAll")
    self.SharedMedia.RegisterCallback(self, "LibSharedMedia_SetGlobal", "BarConfigureAll")
end

function VisualHeal:OnEnable()
    if (not self.ConfigMode) then
        self.EventFrame:RegisterEvent("UNIT_HEALTH");
        self.EventFrame:RegisterEvent("UNIT_MAXHEALTH")
        self.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
        self.EventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
        self.EventFrame:RegisterEvent("UNIT_HEAL_PREDICTION");
        self.EventFrame:RegisterEvent("UNIT_PET");
        self.EventFrame:RegisterEvent("PARTY_MEMBERS_CHANGED");
        self.EventFrame:RegisterEvent("RAID_ROSTER_UPDATE");
    end
end

function VisualHeal:OnDisable()
    self.EventFrame:UnregisterAllEvents();
    self.SharedMedia.UnregisterAllCallbacks(self);
end

--[ Event Handlers ]--

local checkList = {};
function VisualHeal:PARTY_MEMBERS_CHANGED()
    for i, frame in ipairs(outgoingList) do
        table.insert(checkList, frame);
    end
    for i, frame in ipairs(checkList) do
        self:CheckGUID(frame);
    end
    table.wipe(checkList);
end

function VisualHeal:RAID_ROSTER_UPDATE()
    self:PARTY_MEMBERS_CHANGED();
end

function VisualHeal:UNIT_HEALTH(unit)
    if (unit == "player" and self.db.profile.ShowIncoming) then
        self:IncomingBarUpdate();
    end
    local unitGUID = UnitGUID(unit);
    local frame = outgoingTable[unitGUID];
    if (frame) then
        self:BarUpdate(frame);
    end
end

function VisualHeal:UNIT_MAXHEALTH(unit)
    self:UNIT_HEALTH(unit);
end

function VisualHeal:UnitUpdate(unit)
    if (not self.db.profile.ShowOutgoing) then return end
    local playerHeal = UnitGetIncomingHeals(unit, "player") or 0;
    local unitGUID = UnitGUID(unit);
    local frame = outgoingTable[unitGUID];
    if (playerHeal == 0 and frame) then
        self:BarRelease(frame);
    elseif (playerHeal > 0) then
        if (not frame) then
            frame = self:BarAllocate(unit, unitGUID);
        elseif (unit ~= "target" and unit ~= "focus") then
            frame.unit = unit;
        end
        self:BarUpdate(frame);
    end
end

local lastTargetGUID;
function VisualHeal:PLAYER_TARGET_CHANGED()
    local frame = outgoingTable[lastTargetGUID];
    if (frame) then
        self:CheckGUID(frame);
    end
    lastTargetGUID = UnitGUID("target");
    self:UnitUpdate("target");
end

local lastFocusGUID;
function VisualHeal:PLAYER_FOCUS_CHANGED()
    local frame = outgoingTable[lastFocusGUID];
    if (frame) then
        self:CheckGUID(frame);
    end
    lastFocusGUID = UnitGUID("focus");
    self:UnitUpdate("focus");
end

petTable = {};
function VisualHeal:UNIT_PET(unit)
    local unitPet = unit .. "pet";
    local unitGUID = UnitGUID(unit);
    local unitPetGUID = UnitGUID(unitPet);
    if (unitPetGUID) then
        petTable[unitGUID] = unitPetGUID;
    else
        unitPetGUID = petTable[unitGUID];
    end
    local frame = outgoingTable[unitPetGUID];
    if (frame) then
        self:CheckGUID(frame);
    end
end

function VisualHeal:UNIT_HEAL_PREDICTION(unit)
    if (unit == "player" and self.db.profile.ShowIncoming) then
        self:IncomingBarUpdate();
    end
    self:UnitUpdate(unit);
end

function VisualHeal:LibSharedMedia_Callback()
    self:BarConfigureAll();
end
