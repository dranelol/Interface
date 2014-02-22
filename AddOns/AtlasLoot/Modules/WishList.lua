--[[
Atlasloot Enhanced
Author Hegarol
Loot browser associating loot with instance bosses
Can be integrated with Atlas (http://www.atlasmod.com)
]]

local AtlasLoot = LibStub("AceAddon-3.0"):GetAddon("AtlasLoot")

local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");

local MODULENAME = "WishList"
WishList = AtlasLoot:NewModule(MODULENAME)
LootTableSort = AtlasLoot:AddLootTableSort(MODULENAME)

local WishListCount = 0
local Wishlists_Info = {
	numWishlists = 1, 		-- number of aviable wishlists
	defaultWishlist = nil,	-- saves the ID of the default wishlist
	curWishlist = 0, 		-- saves the ID of the current wishlist
	IdSave = {},			-- Ids that already on the wishlist [ID] = { wishlist1, wishlist2, ... }
}
WishList.Info = Wishlists_Info

--StaticPopupDialogs
do
	--StaticPopup_Show ("ATLASLOOT_SEND_WISHLIST",AtlasLootWishList["Own"][tab2][tabname]["info"][1]);
	StaticPopupDialogs["ATLASLOOT_SEND_WISHLIST"] = {
		text = AL["Send Wishlist (%s) to"],
		button1 = AL["Send"],
		button2 = CANCEL,
		--OnShow = function()
		--	this:SetFrameStrata("TOOLTIP");
		--end,
		OnAccept = function(self)
			local name = _G[self:GetParent():GetName().."EditBox"]:GetText()
			if string.lower(name) == string.lower(playerName) then
				DEFAULT_CHAT_FRAME:AddMessage(BLUE..AL["AtlasLoot"]..": "..RED..AL["You can't send Wishlists to yourself."]);
				curtabname = ""
				curplayername = ""
			elseif name == "" then

			else
				if SpamProtect(string.lower(name)) then
					AtlasLoot_SendWishList(AtlasLootWishList["Own"][curplayername][curtabname],name)
					curtabname = ""
					curplayername = ""
				else
					local _,_,timeleft = string.find( 10-(GetTime() - SpamFilter[string.lower(name)]), "(%d+)%.")
					DEFAULT_CHAT_FRAME:AddMessage(BLUE..AL["AtlasLoot"]..": "..RED..AL["You must wait "]..WHITE..timeleft..RED..AL[" seconds before you can send a new Wishlist to "]..WHITE..name..RED..".");
				end
			end
		end,
		OnCancel = function ()
			curtabname = ""
			curplayername = ""
		end,
		hasEditBox = 1,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	};
end

local db
local dbDefaults = {
	global = {
		data = {
			['Normal'] = {
				-- Server
				['*'] = {
					-- Name
					['*'] = {
						-- wishlist
						['*'] = {
							[1] = {},
							info = {
								name = "",
								icon = "Interface\\Icons\\INV_Misc_QuestionMark",
								tableSort = {},
								default = false
							},
						},
						[1] = {
							[1] = {},
							info = {
								name = AL["Wishlist"],
								icon = "Interface\\Icons\\INV_Misc_QuestionMark",
								tableSort = {},
								default = true
							},
						},
					},
				},
			},
			['Shared'] = {
				-- Server
				['*'] = {
					-- Name
					['*'] = {
						-- wishlist
						['*'] = {
							[1] = {},
							info = {
								name = "",
								icon = "Interface\\Icons\\INV_Misc_QuestionMark",
								tableSort = {},
							},
						},
					},
				},
			},
		},
	},
	profile = {
		defaultWishlist = false,
		useCharDB = false,
	},
}

local getOptions
do
	local function resetWishlstDefault()
		for _,wishlist in ipairs(WishList.ownWishLists) do
			wishlist.info.default = false
		end
	end
	
	local function AddWishListOption(wlInfo, id)
		local retTab = {
			wlName = {
				type = "input",
				name = AL["Wishlist name:"],
				order = 10,
				get = function(info) 
					LootTableSort:SetConfigTable(wlInfo.tableSort)
					return wlInfo.name 
				end,
				set = function(info, value)
					wlInfo.name = value
				end,
			},
			wlIcon = {
				type = "execute",
				name = "",
				image = wlInfo.icon,
				order = 20,
				--desc = ,
				func = function() WishList:CreateIconSelect(wlInfo) end,
				--order = 3,
			},
			--[[
			wlShare = {
				type = "execute",
				name = AL["Share"],
				order = 40,
				--desc = ,
				func = function() WishList:CreateIconSelect(wlInfo) end,
				--order = 3,
			},
			]]
			wlDelete = {
				type = "execute",
				name = AL["Delete"],
				order = 50,
				confirm = true,
				confirmText = string.format(AL["Are you sure you want to delete Wishlist |cff1eff00%s|r?"], wlInfo.name),
				--desc = ,
				func = function() WishList:DeleteWishlist(wlInfo, id) end,
				--order = 3,
			},
		
		}
		retTab.wlSort = LootTableSort:GetOptionsTable(30)
		
		return retTab
	end
	
	local function AddWishList()
		WishList.ownWishLists[#WishList.ownWishLists + 1] = {
			[1] = {},
			info = {
				name = AL["Wishlist"],
				icon = "Interface\\Icons\\INV_Misc_QuestionMark",
				tableSort = {},
				default = false
			},
		}
		WishList:Refresh()
	end
	
	local options
	function getOptions()
		if not options then
			options = {
				type = "group",
				name = MODULENAME,
				order = 600,
				--childGroups = "tab",
				args = {
					toggle = {
						type = "toggle",
						name = AL["Enable"],
						get = function()
							return AtlasLoot:GetModuleEnabled(MODULENAME)
						end,
						set = function(info, v)
							AtlasLoot:SetModuleEnabled(MODULENAME, v)
						end,
						order = 10,
						width = "full",
					},
					useCharDB = {
						type = "toggle",
						name = AL["Save wishlists at character DB"],
						desc = string.format(AL["Saves the wishlists only for |cff1eff00%s-%s|r.\n Other characters cant view the wishlists, but the memory usage is reduced."], WishList.char, WishList.realm),
						get = function()
							return db.useCharDB
						end,
						set = function(info, v)
							db.useCharDB = v
							WishList:SetupDb(true)
							return db.useCharDB 
						end,
						order = 20,
						width = "full",
					},
					nllockb = {
						type = "description",
						name = "",
						order = 30,
					},
					Own = {
						type = "group",
						name = AL["Own"],
						args = {},
						order = 40,
					},
					Other = {
						type = "group",
						name = AL["Other"],
						args = {},
						order = 50,
					},
					--[[
					Shared = {
						type = "group",
						name = AL["Shared"],
						args = {},
						order = 60,
					},
					]]
				},
			}
		
		end
		wipe(options.args.Own.args)
		options.args.Own.args.defaultWishlist = {
			type = "toggle",
			name = AL["Always use default Wishlist"],
			order = 10,
			--desc = ,
			get = function(info)
				return db.defaultWishlist
			end,
			set = function(info,value)
				db.defaultWishlist = value
				return db.defaultWishlist
			end,
		}
		options.args.Own.args.addWishlist = {
			type = "execute",
			name = AL["Add Wishlist"],
			order = 20,
			--desc = ,
			func = AddWishList,
		}
		for k,v in ipairs(WishList.ownWishLists) do
			--v.info.name
			options.args.Own.args[tostring(k)] = {
				type = "group",
				name = v.info.name,
				icon = v.info.icon,
				args = AddWishListOption(v.info, k),
			}
			options.args.Own.args[tostring(k)].args.wlDefault = {
				type = "toggle",
				name = AL["default"],
				desc = AL["Use as default wishlist"],
				order = 9,
				get = function() return v.info.default end,
				set = function(info, value)
					resetWishlstDefault()
					v.info.default = value
					WishList:Refresh()
					return v.info.default
				end,
			}
			if v.info.default then
				options.args.Own.args[tostring(k)].name = v.info.name..AL[" |cff999999<default>"];
			end
		end
		
		for server,serverTab in pairs(WishList.allWishLists) do
			for charName,nameTab in pairs(serverTab) do
				if charName ~= WishList.char then
					for k,v in ipairs(nameTab) do
						--v.info.name
						options.args.Other.args[tostring(k)..charName..server] = {
							type = "group",
							name = v.info.name.." |cff999999("..charName.."-"..server..")",
							icon = v.info.icon,
							args = AddWishListOption(v.info, k),
						}
					end
				end
			end
		end
		--nameTab.info.name.." ("..charName.."-"..server..")",
		return options
	end
	
end
	
function WishList:OnInitialize()
	if not AtlasLoot.db then AtlasLoot:OnLoaderLoad() end
	self.db = AtlasLoot.db:RegisterNamespace(MODULENAME, dbDefaults)
	self.chardb = AtlasLoot.chardb:RegisterNamespace(MODULENAME, dbDefaults)
	db = self.db.profile
	--LootTableSort:SetConfigTable(db.tableSort)
	AtlasLoot:RegisterModuleOptions(MODULENAME, getOptions, AL["Wishlist"])
	self:SetEnabledState(AtlasLoot:GetModuleEnabled(MODULENAME))
	
	AtlasLoot:AddItemButtonTemplateFunc(WishList.ButtonTemp_AddItemToWishList, "AddItemToWishList")
	AtlasLoot:AddItemButtonTemplateFunc(WishList.ButtonTemp_DeleteItemFromWishList, "DeleteItemFromWishList")
	
	AtlasLoot.ItemFrame.WishListDropDownMenu = CreateFrame("Frame", "AtlasLootWishListDropDownMenu")
	AtlasLoot.ItemFrame.WishListDropDownMenu.displayMode = "MENU"
	AtlasLoot.ItemFrame.WishListDropDownMenu.initialize = self.WishList_DropDownInit
	
	AtlasLoot:RegisterSlashCommand("wishlist", WishList.SlashCommand)
	
	for i in ipairs(AtlasLoot.ItemFrame.ItemButtons) do
		if AtlasLoot.ItemFrame.ItemButtons[i] then
			AtlasLoot.ItemFrame.ItemButtons[i].Frame:HookScript("OnClick", WishList.ButtonOnClick)
		end
	end	
	
	AtlasLoot:PanelAddButton("Wishlist", {
		text = AL["Wishlist"],
		func = function() WishList:ShowWishListList() end,
		order = 60,
		disabled = true,
	})
	
	-- Saved Variables
	self.realm = GetRealmName()
	self.char = UnitName("player")
	
	
	--self.ownWishLists = self.db.global.data['Normal'][self.realm][self.char]
	self:SetupDb()
	self.allWishLists = self.db.global.data['Normal']--[self.realm][self.char]
	self.sharedWishLists = self.db.global.data['Shared'][self.realm][self.char]
end

function WishList:OnEnable()
	AtlasLoot:PanelSetButtonEnable("Wishlist", true)
	self:Refresh()
end

function WishList:OnDisable()
	AtlasLoot:PanelSetButtonEnable("Wishlist", false)

end

local function MoveTable(t, tt)
	tt = tt or {}
	local i, v = next(t, nil)
	while i do
		if type(v)=="table" then 
			v=CopyTable(v)
		end 
		tt[i] = v
		t[i] = nil
		i, v = next(t, i)
	end
	return tt
end

function WishList:SetupDb(change)
	if db.useCharDB then
		if change then
			MoveTable(self.db.global.data['Normal'][self.realm][self.char], self.chardb.global.data['Normal'][self.realm][self.char])
		end
		self.ownWishLists = self.chardb.global.data['Normal'][self.realm][self.char]
	else
		if change then
			MoveTable(self.chardb.global.data['Normal'][self.realm][self.char], self.db.global.data['Normal'][self.realm][self.char])
		end
		self.ownWishLists = self.db.global.data['Normal'][self.realm][self.char]
	end
	if self.ownWishLists then
		local numLists = #self.ownWishLists
		if numLists and #self.ownWishLists > 0 then
			for i = 1, #self.ownWishLists do
				if self.ownWishLists[i] == nil then
					table.remove(self.ownWishLists, i)
				end
			end
		end
	end
end
-- Icon select
do
	local icon_row_height = 36
	local lastButton = 1
	local newIcon, selectedIcon = ""
	local curInfo

	local function onVerticalScroll(self)
		local numMacroIcons = GetNumMacroIcons()
		local wlIcon, wlButton
		local index
		local offset = FauxScrollFrame_GetOffset(AL_WishList_IconSelect)
		
		local texture
		for i=1, 20 do
			wlIcon = _G["AL_WishList_Button_"..i.."Icon"]
			wlButton = _G["AL_WishList_Button_"..i]
			index = (offset * 5) + i;
			texture = GetMacroIconInfo(index);
			
			if ( index <= numMacroIcons ) then
				wlIcon:SetTexture(texture);
				wlButton:Show();
			else
				wlIcon:SetTexture("");
				wlButton:Hide();
			end
			
			if ( WishList.IconSelect.selectedIcon and (index == WishList.IconSelect.selectedIcon) ) then
				wlButton:SetChecked(1);
			elseif ( WishList.IconSelect.selectedIconTexture ==  texture ) then
				wlButton:SetChecked(1);
			else
				wlButton:SetChecked(nil);
			end
		end
		
		-- Scrollbar stuff
		FauxScrollFrame_Update(AL_WishList_IconSelect, ceil(numMacroIcons / 5) , 4, icon_row_height );
	end

	local function cancelButton_OnClick(self, button)
		WishList.IconSelect:Hide()
	end

	local function okayButton_OnClick(self, button)
		curInfo.icon = newIcon
		WishList.IconSelect:Hide()
	end

	local function SelectTexture(selectedIcon)
		newIcon = GetMacroIconInfo(selectedIcon)
		WishList.IconSelect.selectedIcon = selectedIcon
		WishList.IconSelect.selectedIconTexture = nil
		
		onVerticalScroll()
	end

	local function buttonOnClick(self, button)
		SelectTexture(self:GetID() + (FauxScrollFrame_GetOffset(AL_WishList_IconSelect) * 5))
	end

	local function createIconButton(frame)
		local button = CreateFrame("CheckButton", "AL_WishList_Button_"..#WishList.IconSelect.Icons + 1, frame, "WishListIconButtonTemplate")
			button:SetScript("OnClick", buttonOnClick)	
			
		return button	
	end

	function WishList:CreateIconSelect(info)
		if self.IconSelect then 
			self.IconSelect.Title:SetText(info.name)
			self.IconSelect.selectedIcon = nil
			self.IconSelect.selectedIconTexture = info.icon
			self.IconSelect.OkayButton.info = info
			self.IconSelect:Show() 
			return
		end
		
		self.IconSelect = CreateFrame("FRAME")
		
		local IconSelect = self.IconSelect
		IconSelect:ClearAllPoints()
		IconSelect:SetParent(UIParent)
		IconSelect:SetPoint("CENTER", UIParent, "CENTER")
		IconSelect:SetFrameStrata("TOOLTIP")
		IconSelect:SetWidth(297)
		IconSelect:SetHeight(298)
		
		IconSelect.Textures = {}
		
		IconSelect.Textures[1] = IconSelect:CreateTexture(nil, "ARTWORK")
		IconSelect.Textures[1]:SetPoint("TOPLEFT", IconSelect, "TOPLEFT")	
		IconSelect.Textures[1]:SetWidth(256)
		IconSelect.Textures[1]:SetHeight(256)
		IconSelect.Textures[1]:SetTexture("Interface\\MacroFrame\\MacroPopup-TopLeft")
		
		IconSelect.Textures[2] = IconSelect:CreateTexture(nil, "ARTWORK")
		IconSelect.Textures[2]:SetPoint("TOPLEFT", IconSelect, "TOPLEFT", 256, 0)	
		IconSelect.Textures[2]:SetWidth(64)
		IconSelect.Textures[2]:SetHeight(256)
		IconSelect.Textures[2]:SetTexture("Interface\\MacroFrame\\MacroPopup-TopRight")
		
		IconSelect.Textures[3] = IconSelect:CreateTexture(nil, "ARTWORK")
		IconSelect.Textures[3]:SetPoint("TOPLEFT", IconSelect, "TOPLEFT", 0, -256)	
		IconSelect.Textures[3]:SetWidth(256)
		IconSelect.Textures[3]:SetHeight(64)
		IconSelect.Textures[3]:SetTexture("Interface\\MacroFrame\\MacroPopup-BotLeft")
		
		IconSelect.Textures[3] = IconSelect:CreateTexture(nil, "ARTWORK")
		IconSelect.Textures[3]:SetPoint("TOPLEFT", IconSelect, "TOPLEFT", 256, -256)	
		IconSelect.Textures[3]:SetWidth(64)
		IconSelect.Textures[3]:SetHeight(64)
		IconSelect.Textures[3]:SetTexture("Interface\\MacroFrame\\MacroPopup-BotRight")
		
		IconSelect.Title = IconSelect:CreateFontString(nil,"OVERLAY","GameFontNormal")
		IconSelect.Title:SetPoint("CENTER", IconSelect, "TOP", 0, -25)
		IconSelect.Title:SetText(info.name)
		IconSelect.Title:SetWidth(272)
		
		IconSelect.SelectIcon = IconSelect:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
		IconSelect.SelectIcon:SetPoint("TOPLEFT", IconSelect, "TOPLEFT", 24, -69)
		IconSelect.SelectIcon:SetText(MACRO_POPUP_CHOOSE_ICON)
		
		IconSelect.ScrollFrame = CreateFrame("ScrollFrame", "AL_WishList_IconSelect", IconSelect, "ListScrollFrameTemplate")
		IconSelect.ScrollFrame:SetWidth(296)
		IconSelect.ScrollFrame:SetHeight(195)
		IconSelect.ScrollFrame:SetPoint("TOPRIGHT", IconSelect, "TOPRIGHT", -39, -67)
		IconSelect.ScrollFrame:SetScript("OnVerticalScroll", function(self, offset) FauxScrollFrame_OnVerticalScroll(self, offset, icon_row_height, onVerticalScroll) end)
		
		IconSelect.Icons = {}
		for i = 1,4 do
			IconSelect.Icons[#IconSelect.Icons + 1] = createIconButton(IconSelect)
			if i == 1 then
				lastButton = 1
				IconSelect.Icons[#IconSelect.Icons]:SetPoint("TOPLEFT", IconSelect, "TOPLEFT", 24, -85)
				IconSelect.Icons[#IconSelect.Icons]:SetID(#IconSelect.Icons)
			else
				IconSelect.Icons[#IconSelect.Icons]:SetPoint("TOPLEFT", IconSelect.Icons[lastButton], "BOTTOMLEFT", 0, -8)
				IconSelect.Icons[#IconSelect.Icons]:SetID(#IconSelect.Icons)
				lastButton = lastButton + 5
			end
			for j = 1,4 do
				IconSelect.Icons[#IconSelect.Icons + 1] = createIconButton(IconSelect)
				IconSelect.Icons[#IconSelect.Icons]:SetID(#IconSelect.Icons)
				IconSelect.Icons[#IconSelect.Icons]:SetPoint("LEFT", IconSelect.Icons[#IconSelect.Icons - 1], "RIGHT", 10, 0)
			end
		end
		
		IconSelect.CancelButton = CreateFrame("Button", nil, IconSelect, "UIPanelButtonTemplate")
		IconSelect.CancelButton:SetWidth(78)
		IconSelect.CancelButton:SetHeight(22)
		IconSelect.CancelButton:SetPoint("BOTTOMRIGHT", IconSelect, "BOTTOMRIGHT", -11, 13)
		IconSelect.CancelButton:SetText(CANCEL)
		IconSelect.CancelButton:SetScript("OnClick", cancelButton_OnClick)
		
		IconSelect.OkayButton = CreateFrame("Button", nil, IconSelect, "UIPanelButtonTemplate")
		IconSelect.OkayButton:SetWidth(78)
		IconSelect.OkayButton:SetHeight(22)
		IconSelect.OkayButton:SetPoint("RIGHT", IconSelect.CancelButton, "LEFT", -2, 0)
		IconSelect.OkayButton:SetText(OKAY)	
		IconSelect.OkayButton.info = info
		IconSelect.OkayButton:SetScript("OnClick", function(self) 
			self.info.icon = newIcon
			WishList.IconSelect:Hide()
			AtlasLoot:RefreshModuleOptions()
		end)
		
		IconSelect:SetScript("OnShow", onVerticalScroll) 
		onVerticalScroll()
	end

end

-- onClick of a itemButton
function WishList:ButtonOnClick(arg1)
	if not self.par.tableLink and IsAltKeyDown() then
		self.par:AddItemToWishList()
	end
end

function WishList:CheckHeroic()
	local heroic
	local checkName = "|cffFF0000"..AL["Heroic Mode"]
	for itemNum,item in ipairs(AtlasLoot.ItemFrame.ItemButtons) do
		if item.Frame.Name:GetText() == checkName then
			heroic = itemNum
		end
	end
	return heroic
end

function WishList:ShowWishlist(wishlist)
	wishlist = tonumber(string.match(wishlist, "#(%d+)")) or wishlist
	WishList:RefreshCurWishlist(wishlist)
	LootTableSort:SetConfigTable(WishList.ownWishLists[wishlist].info.tableSort)
	LootTableSort:ShowSortedTable(WishList:GetWishlistNameByID(wishlist), WishList.ownWishLists[wishlist][1], MODULENAME.."#"..wishlist)
end

-- /al wishlist, /atlasloot wishlist
-- msg is allways "wishlist"
function WishList:SlashCommand(msg, ...)
	local wishlistName = ...
	if wishlistName then
		WishList:OpenWishlist(wishlistName)
	else
		if AtlasLootDefaultFrame then
			AtlasLootDefaultFrame:Show()
			WishList:ShowWishListList()
		end
	end
end
-- tableLinkFunc
-- Shows all Wishlists in a menu table
function WishList:ShowWishListList()
	if not AtlasLoot_Data[MODULENAME.."MenuList"] then AtlasLoot_Data[MODULENAME.."MenuList"] = {} end
	wipe(AtlasLoot_Data[MODULENAME.."MenuList"])
	if self.Info.numWishlists < 2 then
		self:ShowWishlist(1)
	elseif db.defaultWishlist then
		self:ShowWishlist(self.Info.defaultWishlist)
	else
		AtlasLoot_Data[MODULENAME.."MenuList"].info = {
			name = AL["Wishlists"],
		}
		AtlasLoot_Data[MODULENAME.."MenuList"]["Normal"] = {}
		local lootpage = AtlasLoot_Data[MODULENAME.."MenuList"]["Normal"]
		local menuCount, pageCount = 1, 1
		for wishlistNum,wishlist in ipairs(self.ownWishLists) do
			--{ menuCount, "CraftedWeapons", "INV_Sword_1H_Blacksmithing_02", AL["Crafted Epic Weapons"], ""};
			if not lootpage[pageCount] then lootpage[pageCount] = {} end
			lootpage[pageCount][#lootpage[pageCount] + 1] = { menuCount, MODULENAME.."#"..wishlistNum, wishlist.info.icon, wishlist.info.name, "", tableLinkFunc = WishList.ShowWishlist}
			menuCount = menuCount + 1
			if menuCount > 30 then
				menuCount = 1
				pageCount = pageCount + 1
			end
		end
		AtlasLoot:ShowLootPage(MODULENAME.."MenuList")
	end
end

function WishList:DeleteWishlist(info, id)
	table.remove(self.ownWishLists, id)
	WishList:Refresh()
	collectgarbage("collect")
end
-- ###################################
-- Refresh functions
-- ###################################
function WishList:Refresh()
	if self.ownWishLists then
		self.Info.numWishlists = #self.ownWishLists
		self:RefreshItemIdList()
		self:RefreshDefaultWishlist()
		self:RefreshCurWishlist()
	end
end

function WishList:RefreshItemIdList()
	local IdSave = self.Info.IdSave
	wipe(IdSave)
	for _,wishlist in ipairs(self.ownWishLists) do
		for itemNum,item in ipairs(wishlist[1]) do
			if item[2] then
				if not IdSave[item[2]] then IdSave[item[2]] = {} end
				IdSave[item[2]][#IdSave[item[2]] + 1] = wishlist.info.name
				if item[3] and item[3] ~= "" then
					if not IdSave["s"..item[3]] then IdSave["s"..item[3]] = {} end
					IdSave["s"..item[3]][#IdSave["s"..item[3]] + 1] = wishlist.info.name
				end
			else
				table.remove(self.ownWishLists, itemNum)
			end
		end
	end
end

function WishList:RefreshDefaultWishlist()
	for id,wishlist in ipairs(self.ownWishLists) do
		if wishlist.info.default then
			self.Info.defaultWishlist = id
			return
		end
	end
end

function WishList:RefreshCurWishlist(id)
	if db.defaultWishlist and self.Info.defaultWishlist then
		self.Info.curWishlist = self.Info.defaultWishlist
	elseif id then
		self.Info.curWishlist = tonumber(id)
	else
		if self.Info.defaultWishlist then
			self.Info.curWishlist = self.Info.defaultWishlist
		else
			self.Info.curWishlist = 1
		end
	end
end
-- ###################################
-- API
-- ###################################
function WishList:CheckWishlistForItemOrSpell(id, wishlist)
	local isListed
	if self.Info.curWishlist and self.Info.curWishlist ~= 0 then
		if id and self.Info.IdSave[id] then
			if wishlist then
				for k,v in ipairs(self.Info.IdSave[id]) do
					if v == wishlist then
						isListed = true
					end
				end
				if not isListed then
					isListed = false
				end
			else
				isListed = true
			end
		else
			isListed = false
		end
	end
	return isListed
end

function WishList:GetWishlistNameByID(id)
	if not id then return end
	return self.ownWishLists[id].info.name
end

--- Searchs a wishlist
-- @param name the wishlist name you want to search
function WishList:SearchWishlist(name)
	name = string.lower(name) or ""
	local found
	for k,v in ipairs(WishList.ownWishLists) do
		if string.lower(WishList.ownWishLists[k].info.name) == name then
			found = k
		end
	end
	return found
end

function WishList:OpenWishlist(nameOrId)
	if AtlasLootDefaultFrame then
		if type(nameOrId) == "string" then
			nameOrId = self:SearchWishlist(nameOrId)
		end
		if nameOrId then
			AtlasLootDefaultFrame:Show()
			WishList:ShowWishlist(nameOrId)
		end
		
	end
end
-- ###################################
-- Add/delete Item
-- ###################################
local curItem 
-- DropDown Menu
do
	local function AddItem(self, arg1, arg2, checked)
		if arg1 then
			WishList:RefreshCurWishlist(arg2)
			WishList:AddItemToWishList(unpack(arg1))
		end
	end
	
	local WishList_DropDownInfo = {}
	function WishList:WishList_DropDownInit(level)
		if not level then return end
		wipe(WishList_DropDownInfo)
		if level == 1 then
			for i,v in ipairs(WishList.ownWishLists) do
				WishList_DropDownInfo.text 			= v.info.name
				WishList_DropDownInfo.arg1			= curItem
				WishList_DropDownInfo.arg2			= i
				WishList_DropDownInfo.func			= AddItem
				WishList_DropDownInfo.checked     	= nil
				WishList_DropDownInfo.notCheckable	= 1
				UIDropDownMenu_AddButton(WishList_DropDownInfo, level)
			end
			WishList_DropDownInfo.text         = "|cffff0000"..CLOSE
			WishList_DropDownInfo.func         = function() CloseDropDownMenus() end
			WishList_DropDownInfo.checked      = nil
			WishList_DropDownInfo.notCheckable = 1
			UIDropDownMenu_AddButton(WishList_DropDownInfo, level)			
		end
	end
end

--- Adds a item to the Wishlist
-- @param spellID The spell ID
-- @param itemID The item ID from the crafted spell
-- @param itemName name of the item/spell
-- @param extraText The small text under the name.
-- @param dataID the name of the AtlasLootTable with lootTableType (dataID#lootTableType)
function WishList:AddItemToWishList(spellID, itemID, itemName, extraText, dataID, chatLink)
	spellID = spellID or ""
	local curID = self.Info.curWishlist
	local curName = self:GetWishlistNameByID(curID)
	if not self:CheckWishlistForItemOrSpell(itemID, curName) and not self:CheckWishlistForItemOrSpell("s"..spellID, curName) then
		table.insert(self.ownWishLists[curID][1], { 0, itemID, spellID, itemName, extraText, dataID } )
		print(chatLink..AL[" added to the WishList."])
	else
		print(chatLink..AL[" already in the WishList!"])
	end
	self:RefreshItemIdList()
end

-- Item on click function
function WishList:ButtonTemp_AddItemToWishList()
	if not self.info or not AtlasLoot:GetModuleEnabled(MODULENAME) then return end
	local heroicCheckNumber = AtlasLoot:CheckHeroic()
	if self.itemType and string.find(self.itemType, MODULENAME) then
		self:DeleteItemFromWishList()
	else
		local dataID = AtlasLoot:FormatDataID(AtlasLoot.ItemFrame.dataID)
		if heroicCheckNumber and heroicCheckNumber < self.buttonID then
			lootTableType = "Heroic"
		else
			lootTableType = AtlasLoot.ItemFrame.lootTableType
		end
		curItem = { self.info[1], self.info[2], self.info[3], self.info[4], dataID.."#"..lootTableType, self:GetChatLink() }
		if (db.defaultWishlist and Wishlists_Info.defaultWishlist) or Wishlists_Info.numWishlists <= 1 then
			WishList:RefreshCurWishlist(1)
			if self.info[2] == nil then 
				WishList:AddItemToWishList(self.info[1], self.info[5], self.info[3], self.info[4], dataID.."#"..lootTableType, self:GetChatLink())
			else
				WishList:AddItemToWishList(self.info[1], self.info[2], self.info[3], self.info[4], dataID.."#"..lootTableType, self:GetChatLink())
			end
			
		else
			ToggleDropDownMenu(1, nil, AtlasLoot.ItemFrame.WishListDropDownMenu, self.Frame:GetName(), 0, 0)
		end
	end
end

function WishList:DeleteItemFromWishList(wishlistIndex, spellID, itemID, chatLink)
	wishlistIndex = tonumber(wishlistIndex)
	for itemIndex,item in ipairs(self.ownWishLists[wishlistIndex][1]) do
		if item[2] == itemID or item[3] == spellID then
			table.remove(self.ownWishLists[wishlistIndex][1], itemIndex)
		end
	end
	print(chatLink..AL[" deleted from the WishList."])
	WishList:ShowWishlist(wishlistIndex)
end

-- Item on click function
function WishList:ButtonTemp_DeleteItemFromWishList()
	if not self.info or not AtlasLoot:GetModuleEnabled(MODULENAME) then return end
	WishList:DeleteItemFromWishList(string.match(self.itemType, "#(%d+)"), self.info[1], self.info[2], self:GetChatLink())
end
