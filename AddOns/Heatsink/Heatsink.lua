local ADDON_NAME, ADDON_TABLE = ...
local addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON_NAME)
local candy = LibStub("LibCandyBar-3.0")
local icd = LibStub("LibInternalCooldowns-1.0")
local media = LibStub("LibSharedMedia-3.0")
local AceGUIWidgetLSMlists = _G.AceGUIWidgetLSMlists

local defaulticon = "Interface\\Icons\\spell_nature_timestop"
local anchor, db, class, faction, lockout
local player, pet, active = {}, {}, {}
local RUNECD = 10


local meta = {
	["DEATHKNIGHT"] = {
		[(GetSpellInfo(113072))] = (GetSpellInfo(110505)), -- 113072 Might of Ursoc (Blood) 
		[(GetSpellInfo(113516))] = (GetSpellInfo(110505))  -- 113516 Wild Mushroom: Plague (Frost/Unholy) 
	},
	["DRUID"] = {
		[(GetSpellInfo(33891))] = (GetSpellInfo(106731)),  -- 33891 Tree of Life -- 106731 Incarnation
		[(GetSpellInfo(102558))] = (GetSpellInfo(106731)), --102558 Son of Ursoc -- 106731 Incarnation
		[(GetSpellInfo(102543))] = (GetSpellInfo(106731)), -- 102543 King of the Jungle -- 106731 Incarnation
		[(GetSpellInfo(102560))] = (GetSpellInfo(106731)),  -- 102560 Chosen of Elune -- 106731 Incarnation
		[(GetSpellInfo(102355))] = (GetSpellInfo(770))      -- 102355 Faerie Swarm -- 770 Faerie Fire
	},
	["HUNTER"] = {
		[(GetSpellInfo(113073))] = (GetSpellInfo(110505))  -- 113073 Dash 
	},
	["MAGE"] = {
		[(GetSpellInfo(113074))] = (GetSpellInfo(110505))  -- 113074 Healing Touch 
	},
	["MONK"] = {
		[(GetSpellInfo(113306))] = (GetSpellInfo(110505)), -- 113306 Survival Instincts (Brewmaster) 
		[(GetSpellInfo(122286))] = (GetSpellInfo(110505)), -- 122286 Savage Defense (Windwalker) 
		[(GetSpellInfo(113275))] = (GetSpellInfo(110505))  -- 113275 Entangling Roots (Mistweaver)
	},
	["PALADIN"] = {
		[(GetSpellInfo(113269))] = (GetSpellInfo(110505)), -- 113269 Rebirth (Holh) 
		[(GetSpellInfo(113075))] = (GetSpellInfo(110505)), -- 113075 Barkskin (Protection) 
		[(GetSpellInfo(122287))] = (GetSpellInfo(110505))  -- 122287 Wrath (Retribution) 
	},
	["PRIEST"] = {
		[(GetSpellInfo(113275))] = (GetSpellInfo(110505)), -- 113275 Entangling Roots (Disciplline/Holy)
		[(GetSpellInfo(113277))] = (GetSpellInfo(110505)), -- 113277 Tranqility (Shadow)
		[(GetSpellInfo(129250))] = (GetSpellInfo(14914))   -- 129250 Power Word: Solace, replaces 14914 Holy Fire
	},
	["ROGUE"] = {
		[(GetSpellInfo(113613))] = (GetSpellInfo(110505))  -- 113613 Growl 
	},
	["SHAMAN"] = {
		[(GetSpellInfo(113287))] = (GetSpellInfo(110505)), -- 113287 Solar Beam (Elemental/Enhancement) 
		[(GetSpellInfo(113289))] = (GetSpellInfo(110505))  -- 113289 Prowl (Restoration) 
	},
	["WARLOCK"] = {
		[(GetSpellInfo(113295))] = (GetSpellInfo(110505))  -- 113295 Rejuvenation	
	},
	["WARRIOR"] = {
		[(GetSpellInfo(122294))] = (GetSpellInfo(110505))  -- 122294 Stampeding Shout
	}
}

local symbiosis = {122292, 112997, 113002, 113004, 110698, 110700, 110701, 122288, 110588, 110597, 110600, 110617, 110788, 110730, 122289, 110791, 110707, 110715, 110717, 110718, 110570, 122282, 122285, 110575, 110802, 110807, 110803, 110806, 110621, 110693, 110694, 110696, 122291, 110810, 122290, 112970, 126458, 126449, 126453, 126456}


local extra = { -- doesn't appear in a spellbook scan, not worth scanning tradeskills for.
	[(GetSpellInfo(80451))] = true, -- Survey
	[(GetSpellInfo(818))] = true, -- Cooking Fire
	[(GetSpellInfo(74497))] = true -- Lifeblood
}

-- Credit to the BigWigs team (Rabbit, Ammo, et al) for the anchor code 
local createAnchor, toggleAnchor, updateAnchor, runTest, startBar, stopBar, getBar
do
	local GameTooltip = _G.GameTooltip

	local function rearrangeBars(anchor)
		local tmp = {}
		for bar in pairs(active) do
			table.insert(tmp, bar)
		end
		table.sort(tmp, function(a,b) return a.remaining > b.remaining end)
		local lastBar = nil
		for i, bar in ipairs(tmp) do
			bar:ClearAllPoints()
			if db.growup then
				bar:SetPoint("BOTTOMLEFT", lastBar or anchor, "TOPLEFT")
				bar:SetPoint("BOTTOMRIGHT", lastBar or anchor, "TOPRIGHT")
			else
				bar:SetPoint("TOPLEFT", lastBar or anchor, "BOTTOMLEFT")
				bar:SetPoint("TOPRIGHT", lastBar or anchor, "BOTTOMRIGHT")
			end
			lastBar = bar
		end
		wipe(tmp)
	end

	local function onDragHandleMouseDown(self)
		self:GetParent():StartSizing("BOTTOMRIGHT")
	end
	
	local function onDragHandleMouseUp(self, button)
		self:GetParent():StopMovingOrSizing()
	end
	
	local function onResize(self, width)
		db.width = width
		rearrangeBars(self)
	end
	
	local function onDragStart(self)
		self:StartMoving()
	end
	
	local function onDragStop(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		db.pos.p = p
		db.pos.rp = rp
		db.pos.x = x
		db.pos.y = y
	end

	local function onControlEnter(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:AddLine(self.tooltipHeader)
		GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
		GameTooltip:Show()
	end
	
	local function onControlLeave()
		GameTooltip:Hide()
	end
	
	function getBar(text)
		local found
		for k in pairs(active) do
			if k.candyBarLabel:GetText() == text then
				found = true
				break
			end
		end
		return found
	end
	
	function stopBar(text)
		if not text then return end
		local found
		for k in pairs(active) do
			if k.candyBarLabel:GetText() == text then
				k:Stop()
				found = true
			end
		end
		if found then rearrangeBars(anchor) end
		return found
	end
	
	function startBar(text, start, duration, icon)
		if not text then return end
		local length = start + duration - GetTime()
		if length < 1 then return end
		if length < db.min then return end
		if length > db.max then return end
		if getBar(text) then
			for bar, barstart in pairs(active) do
				if bar.candyBarLabel:GetText() == text then
					if barstart ~= start then
						stopBar(text)
						startBar(text, start, duration, icon)
					end
				end
			end
		else
			local bar = candy:New(media:Fetch("statusbar", db.texture), db.width, db.height)
			bar:Set("anchor", anchor)
			bar:Set("id", text)
			bar:Set("start", start)
			active[bar] = start
			bar.candyBarBackground:SetVertexColor(unpack(db.color.bg))
			bar:SetColor(unpack(db.color.bar))
			bar.candyBarLabel:SetJustifyH(db.justify)
			bar.candyBarLabel:SetTextColor(unpack(db.color.text))
			bar.candyBarLabel:SetFont(media:Fetch("font", db.font), db.fontsize)
			bar.candyBarDuration:SetFont(media:Fetch("font", db.font), db.fontsize)
			bar:SetLabel(text)
			bar:SetDuration(length)
			bar:SetTimeVisibility(true)
			bar:SetIcon(icon or defaulticon)
			bar:SetScale(db.scale)
			bar:Start()
		end
		rearrangeBars(anchor)
	end
	
	function runTest(anchor)
		local duration = math.random(10, 45)
		local start = GetTime()
		startBar(ADDON_NAME..duration, start, duration, defaulticon)
	end
	
	function toggleAnchor(anchor)
		if anchor:IsShown() then
			anchor:Hide()
		else
			anchor:Show()
		end
	end
	
	function createAnchor(frameName, title)
		local display = CreateFrame("Frame", frameName, _G.UIParent)
		display:EnableMouse(true)
		display:SetMovable(true)
		display:SetResizable(true)
		display:RegisterForDrag("LeftButton")
		display:SetWidth(db.width)
		display:SetHeight(20)
		display:SetMinResize(80, 20)
		display:SetMaxResize(1920, 20)
		display:ClearAllPoints()
		display:SetPoint(db.pos.p, _G.UIParent, db.pos.rp, db.pos.x, db.pos.y)
	
		local bg = display:CreateTexture(nil, "PARENT")
		bg:SetAllPoints(display)
		bg:SetBlendMode("BLEND")
		bg:SetTexture(0, 0, 0, 0.3)
	
		local header = display:CreateFontString(nil, "OVERLAY")
		header:SetFontObject(GameFontNormal)
		header:SetText(title)
		header:SetAllPoints(display)
		header:SetJustifyH("CENTER")
		header:SetJustifyV("MIDDLE")
	
		local drag = CreateFrame("Frame", nil, display)
		drag:SetFrameLevel(display:GetFrameLevel() + 10)
		drag:SetWidth(16)
		drag:SetHeight(16)
		drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", onDragHandleMouseDown)
		drag:SetScript("OnMouseUp", onDragHandleMouseUp)
		drag:SetAlpha(0.5)
	
		local tex = drag:CreateTexture(nil, "BACKGROUND")
		tex:SetTexture("Interface\\AddOns\\"..ADDON_NAME.."\\Textures\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)
	
		local test = CreateFrame("Button", nil, display)
		test:SetPoint("BOTTOMLEFT", display, "BOTTOMLEFT", 3, 3)
		test:SetHeight(14)
		test:SetWidth(14)
		test.tooltipHeader = L["Test"]
		test.tooltipText = L["Creates a new test bar"]
		test:SetScript("OnEnter", onControlEnter)
		test:SetScript("OnLeave", onControlLeave)
		test:SetScript("OnClick", function() runTest() end)
		test:SetNormalTexture("Interface\\AddOns\\"..ADDON_NAME.."\\Textures\\test")
	
		local close = CreateFrame("Button", nil, display)
		close:SetPoint("BOTTOMLEFT", test, "BOTTOMRIGHT", 4, 0)
		close:SetHeight(14)
		close:SetWidth(14)
		close.tooltipHeader = L["Hide"]
		close.tooltipText = L["Hides the anchor"]
		close:SetScript("OnEnter", onControlEnter)
		close:SetScript("OnLeave", onControlLeave)
		close:SetScript("OnClick", function() toggleAnchor(anchor) end)
		close:SetNormalTexture("Interface\\AddOns\\"..ADDON_NAME.."\\Textures\\close")
	
		display:SetScript("OnSizeChanged", onResize)
		display:SetScript("OnDragStart", onDragStart)
		display:SetScript("OnDragStop", onDragStop)
		display.running = {}
		display:Hide()
		return display
	end
	
	function updateAnchor(anchor)
		anchor:SetWidth(db.width)
		for bar in pairs(active) do
			bar.candyBarBar:SetStatusBarTexture(media:Fetch("statusbar", db.texture))
			bar.candyBarBackground:SetTexture(media:Fetch("statusbar", db.texture))
			bar.candyBarBackground:SetVertexColor(unpack(db.color.bg))
			bar.candyBarBar:SetStatusBarColor(unpack(db.color.bar))
			bar.candyBarLabel:SetJustifyH(db.justify)
			bar.candyBarLabel:SetTextColor(unpack(db.color.text))
			bar.candyBarLabel:SetFont(media:Fetch("font", db.font), 10)
			bar.candyBarDuration:SetFont(media:Fetch("font", db.font), 10)
			bar:SetScale(db.scale)
			bar:SetWidth(db.width)
			bar:SetHeight(db.height)
		end	
		rearrangeBars(anchor)
	end
end

local defaults = {
	profile = {
		min = 3,
		max = 3600,
		growup = true,
		texture = "Blizzard",
		font = "ABF",
		fontsize = 10,
		justify = "CENTER",
		width = 250,
		height = 14,
		scale = 1,
		pos = {
			p = "CENTER",
			rp = "CENTER",
			x = 0,
			y = 0,
		},
		color = {
			bg = { 0.5, 0.5, 0.5, 0.3 },
			text = { 1, 1, 1 },
			bar = { 0.25, 0.33, 0.68, 1 },
		},
		show = {
			school = true,
			spells = true,
			pet = true,
			equipped = true,
			inventory = true,
			proc = true,
			pvptimer = true,
		},
	},
}

local options = {
	type = "group",
	args = {
		toggle = {
			type = "execute",
			name = L["Toggle anchor"],
			desc = L["Toggle the bar anchor frame"],
			func = function()
					addon:ToggleAnchor()
				end,
			order = 10,
		},
		test = {
			type = "execute",
			name = L["Test"],
			desc = L["Test bars"],
			func = function()
					addon:RunTest()
				end,
			order = 20,
		},
		duration = {
			name = "Duration settings",
			desc = "Duration settings",
			type = "group",
			args = {
				min = {
					type = "input",
					name = L["Minimum duration"],
					desc = L["Minimum cooldown duration to display"],
					pattern = "%d+",
					get = function() return tostring(addon.db.profile.min) end,
					set = function(info, v) addon.db.profile.min = tonumber(v) end,
					order = 1,
				},
				max = {
					type = "input",
					name = L["Maximum duration"],
					desc = L["Maximum cooldown duration to display"],
					pattern = "%d+",
					get = function() return tostring(addon.db.profile.max) end,
					set = function(info, v) addon.db.profile.max = tonumber(v) end,
					order = 2, 
				},
			},
		},
		bars = {
			order = 10,
			type = "group",
			name = L["Bar settings"],
			desc = L["Bar settings"],
			args = {
				growup = {
					type = "toggle",
					order = 10,
					name = L["Grow upwards"],
					desc = L["Toggle bars grow upwards/downwards from anchor"],
					get = function () return addon.db.profile.growup end,
					set = function (info, v)
							addon.db.profile.growup = v
							addon:UpdateAnchor()
						end,
				},
				scale = {
					type = "range",
					order = 20,
					name = L["Scale"],
					desc = L["Set the scale of the bars"],
					get = function() return addon.db.profile.scale end,
					set = function(info, v)
							addon.db.profile.scale = v
							addon:UpdateAnchor()
						end,
					min = 0.1,
					max = 5,
					step = 0.01,
					isPercent = true,
				},
				texture = {
					type = "select",
					dialogControl = "LSM30_Statusbar",
					order = 30,
					name = L["Texture"],
					desc = L["Set the texture for the timer bars"],
					values = AceGUIWidgetLSMlists.statusbar,
					get = function() return addon.db.profile.texture end,
					set = function(i,v)
							addon.db.profile.texture = v
							addon:UpdateAnchor()
						end,
				},
				barcolor = {
					type = "color",
					hasAlpha = true,
					order = 40,
					name = L["Bar Color"],
					desc = L["Set the bar color"],
					get = function() return unpack(addon.db.profile.color.bar) end,
					set = function(i,r,g,b,a)
							addon.db.profile.color.bar = { r, g, b, a }
							addon:UpdateAnchor()
						end,
				},
				bgcolor = {
					type = "color",
					hasAlpha = true,
					order = 50,
					name = L["Background Color"],
					desc = L["Set the background color"],
					get = function() return unpack(addon.db.profile.color.bg) end,
					set = function(i,r,g,b,a)
							addon.db.profile.color.bg = { r, g, b, a }
							addon:UpdateAnchor()
						end,
				},
				font = {
					type = "select",
					dialogControl = "LSM30_Font",
					order = 60,
					name = L["Font"],
					desc = L["Set the font"],
					values = AceGUIWidgetLSMlists.font,
					get = function() return addon.db.profile.font end,
					set = function(i,v)
							addon.db.profile.font = v
							addon:UpdateAnchor()
						end,
				},
				fontsize = {
					type = "range",
					order = 70,
					name = L["Font Size"],
					desc = L["Set the font size"],
					min = 8,
					max = 24,
					step = 1,
					get = function() return addon.db.profile.fontsize end,
					set = function(i,v)
							addon.db.profile.fontsize = v
							addon:UpdateAnchor()
						end,
				},
				justify = {
					type = "select",
					order = 80,
					name = L["Justify"],
					desc = L["Set the text position"],
					values = {["left"]="LEFT", ["center"]="CENTER"},
					get = function() return addon.db.profile.justify end,
					set = function(i,v)
							addon.db.profile.justify = v
							addon:UpdateAnchor()
						end,
				},
				textcolor = {
					type = "color",
					order = 90,
					name = L["Text Color"],
					desc = L["Set the text color"],
					get = function() return unpack(addon.db.profile.color.text) end,
					set = function(i,r,g,b,a)
							addon.db.profile.color.text = { r, g, b, a }
							addon:UpdateAnchor()
						end,
				},
			},
		},
		show = {
			type = "group",
			name = L["Show cooldowns"],
			desc = L["Toggle showing cooldown types"],
			args = {
				spells = {
					type = "group",
					name = L["Spells"],
					desc = L["Player spells cooldown options"],
					args = {
						enable = {
							type = "toggle",
							name = L["Enable player spells"],
							desc = L["Toggle showing player spells cooldowns"],
							get = function () return addon.db.profile.show.spells end,
							set = function (info, v)
									addon.db.profile.show.spells = v
								end,
							order = 10,
						},
						school = {
							type = "toggle",
							name = L["Show school"],
							desc = L["Spawns single bar if a school is locked out"],
							get = function () return addon.db.profile.show.school end,
							set = function (info, v)
									addon.db.profile.show.school = v
								end,
							disabled = function ()
									   return not addon.db.profile.show.school
								   end,
							order = 100,
						},
					},
					order = 10,
				},
				pet = {
					type = "toggle",
					name = L["Pet spells"],
					desc = L["Toggle showing pet cooldowns"],
					get = function () return addon.db.profile.show.pet end,
					set = function (info, v)
						addon.db.profile.show.pet = v
					end,
					order = 20,
				},
				equipped = {
					type = "toggle",
					name = L["Equipped items"],
					desc = L["Toggle showing equipped items cooldowns"],
					get = function () return addon.db.profile.show.equipped end,
					set = function (info, v)
						addon.db.profile.show.equipped = v
						addon:UNIT_INVENTORY_CHANGED()
					end,
					order = 30,
				},
				bags = {
					type = "toggle",
					name = L["Inventory items"],
					desc = L["Toggle showing inventory items cooldowns"],
					get = function () return addon.db.profile.show.inventory end,
					set = function (info, v)
						addon.db.profile.show.inventory = v
						addon:BAG_UPDATE_COOLDOWN()
					end,
					order = 40,
				},
				proc = {
					type = "toggle",
					name = L["Internal Cooldowns"],
					desc = L["Toggle showing item internal proc cooldowns"],
					get = function () return addon.db.profile.show.proc end,
					set = function (info, v)
						addon.db.profile.show.proc = v
					end,
					order = 50,
				},
				pvptimer = {
					type = "toggle",
					name = L["PVP Timer"],
					desc = L["Toggle showing PVP flag timer"],
					get = function () return addon.db.profile.show.pvptimer end,
					set = function (info, v)
						addon.db.profile.show.pvptimer = v
					end,
					order = 50,
				},
			},
		},
	},
}

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("HeatsinkDB", defaults, "Default")
	db = self.db.profile
	self.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(ADDON_NAME, options)
	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
	local optFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME)
	LibStub("AceConsole-3.0"):RegisterChatCommand( string.lower(ADDON_NAME), function() InterfaceOptionsFrame_OpenToCategory(ADDON_NAME) end )
	anchor = createAnchor(ADDON_NAME.."Anchor", ADDON_NAME)

	local ufg = UnitFactionGroup("player")
	faction = "Interface\\Addons\\"..ADDON_NAME.."\\Icons\\"..ufg.."_active"
	class = select(2, UnitClass("player"))
	meta[class] = meta[class] or {}
	if class == "DRUID" then
		for k,v in pairs(symbiosis) do
			meta["DRUID"][(GetSpellInfo(v))] = (GetSpellInfo(110309))
		end
	end
	wipe(symbiosis)
end

function addon:OnEnable()
	self:RegisterEvent("SPELLS_CHANGED", "ScanSpells")
	self:RegisterEvent("PET_BAR_UPDATE", "ScanPetSpells")
	self:RegisterEvent("PET_BAR_UPDATE_USABLE", "ScanPetSpells")
	self:RegisterEvent("PLAYER_FLAGS_CHANGED", "CheckPVP")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckPVP")
	self:RegisterEvent("LOSS_OF_CONTROL_ADDED")
	self:RegisterBucketEvent("SPELL_UPDATE_COOLDOWN", 0.1)
	self:RegisterBucketEvent("PET_BAR_UPDATE_COOLDOWN", 0.1)
	self:RegisterBucketEvent("UNIT_INVENTORY_CHANGED", 0.1)
	self:RegisterBucketEvent("BAG_UPDATE_COOLDOWN", 0.1)

	icd.RegisterCallback(self, "InternalCooldowns_Proc")
	candy.RegisterCallback(self, "LibCandyBar_Stop")

	self:SPELL_UPDATE_COOLDOWN()
	self:UNIT_INVENTORY_CHANGED()
	self:BAG_UPDATE_COOLDOWN()
	self:CheckPVP()
end

function addon:OnDisable()
	self:UnregisterAllEvents()
	icd.UnregisterCallback(self, "InternalCooldowns_Proc")
	candy.UnregisterCallback(self, "LibCandyBar_Stop")
end

function addon:UpdateProfile()
	db = self.db.profile
	updateAnchor(anchor)
end

function addon:RunTest()
	runTest(anchor)
end

function addon:ToggleAnchor()
	toggleAnchor(anchor)
end

function addon:UpdateAnchor()
	updateAnchor(anchor)
end

function addon:LibCandyBar_Stop(callback, bar)
	local a = bar:Get("anchor")
	if a == anchor and active and active[bar] then
		active[bar] = nil
	end
end

function addon:InternalCooldowns_Proc(callback, item, spell, start, duration, source)
	if db.show.proc then
		local name, icon, _
		if source == "ENCHANT" then
			name, _, icon = GetSpellInfo(spell)
		else
			name, _, _, _, _, _, _, _, _, icon = GetItemInfo(item)
		end
		startBar(name, start, duration, icon)
	end
end

function addon:ScanSpells()
	wipe(player)

	for k,v in pairs(extra) do
		if (GetSpellInfo(k)) then table.insert(player, k) end
	end

	local tabs = 1
	if GetSpecialization() ~= 0 then tabs = 2 end
			
	local name, texture, offset, last = GetSpellTabInfo(tabs)
	local spells = offset + last

	for i = 1, spells do
		local spell = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		local _, id = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)
		local valid = IsPlayerSpell(id)
		GetSpellInfo(spell) -- force a cache update
		spell = meta[class][spell] or spell
		if spell and valid then table.insert(player, spell) end
	end

	for i = 1, GetNumFlyouts() do
		local n = GetFlyoutID(i)
		local name, desc, spells, valid = GetFlyoutInfo(n)
		if valid then
			for j = 1, spells do
				local id, known = GetFlyoutSlotInfo(n,j)
				if known then
					local spell = (GetSpellInfo(id))
					if spell then table.insert(player,spell) end
				end
			end					
		end
	end
end

function addon:ScanPetSpells()
	wipe(pet)
	local check, pettype = HasPetSpells()
	if check then 
		local i = 1
		local continue = true
		while continue do
			local spell = GetSpellBookItemName(i, BOOKTYPE_PET)
			if not spell then continue = false break end 
			if spell then table.insert(pet, spell) end
			i = i + 1
		end
	end
end


function addon:CheckPVP()
	if db.show.pvptimer then
		if IsPVPTimerRunning() then
			local duration = GetPVPTimer()/1000
			local start = GetTime()
			startBar(PVP, start, duration, faction)
		elseif getBar(PVP) then
			stopBar(PVP)
		end
	end
end

function addon:LockoutReset()
	lockout = nil
end

function addon:LOSS_OF_CONTROL_ADDED(callback, index) 
	local loc, spell, text, icon, start, remaining, duration, school, priority, display = C_LossOfControl.GetEventInfo(index); 
	if loc == "SCHOOL_INTERRUPT" then
		local text = school and string.format(LOSS_OF_CONTROL_DISPLAY_INTERRUPT_SCHOOL, GetSchoolString(school))
		startBar(text, start, duration, icon)
		lockout = math.floor(duration)
		self:ScheduleTimer("LockoutReset", duration)
	end
end

function addon:SPELL_UPDATE_COOLDOWN()
	if db.show.spells then 
		for index, spell in pairs(player) do
			local start, duration, enabled = GetSpellCooldown(spell)
			if lockout and duration and lockout == duration then return end
			if class == "DEATHKNIGHT" and duration == RUNECD then return end
			local name, rank, icon = GetSpellInfo(spell)
			if enabled == 1 then
				startBar(name, start, duration, icon)
			elseif duration == 0 then
				stopBar(name)
			end
		end
	end
end

function addon:PET_BAR_UPDATE_COOLDOWN()
	if db.show.pet then
		for index, spell in pairs(pet) do
			local start, duration, enabled = GetSpellCooldown(spell)
			local name, rank, icon = GetSpellInfo(spell)
			if enabled == 1 then
				startBar(name, start, duration, icon)
			elseif duration == 0 then
				stopBar(name)
			end
		end
	end
end

function addon:UNIT_INVENTORY_CHANGED()
	if db.show.equipped then
		for slot = 1,17 do 
			local id = (GetInventoryItemID("player", slot))
			if id then
				local start, duration, enabled = GetInventoryItemCooldown("player", slot)
				local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(id)
				if enabled == 1 then
					startBar(name, start, duration, icon)
				end
			end
		end
	end
end

function addon:BAG_UPDATE_COOLDOWN()
	if db.show.inventory then
		for bag = 0,4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local id = (GetContainerItemID(bag,slot))
				if id then
					local start, duration, enabled = GetContainerItemCooldown(bag,slot)
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(id)
					if enabled == 1 then 
						startBar(name, start, duration, icon)
					elseif duration == 0 then 
						stopBar(name)
					end
				end
			end
		end
	end
	self:UNIT_INVENTORY_CHANGED()
end
