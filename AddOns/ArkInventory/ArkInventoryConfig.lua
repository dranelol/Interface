local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table


function ArkInventory.Frame_Config_Hide( )
	return ArkInventory.Lib.Dialog:Close( ArkInventory.Const.Frame.Config.Internal )
end
	
function ArkInventory.Frame_Config_Show( ... )
	
	if not IsAddOnLoaded( "ArkInventoryConfig" ) then
		
		local loaded, reason = LoadAddOn( "ArkInventoryConfig" )
		if reason then
			ArkInventory.OutputError( "Failed to load configuration module: ", getglobal( "ADDON_" .. reason ) )
			return
		else
			ArkInventory.ConfigInternal( )
		end
		
	end
	
	ArkInventory.Config.Frame = ArkInventory.Lib.Dialog:Open( ArkInventory.Const.Frame.Config.Internal, ... )
	
end

function ArkInventory.Frame_Config_Toggle( )

	if not ArkInventory.Frame_Config_Hide( ) then
		ArkInventory.Frame_Config_Show( )
	end
	
end

function ArkInventory.ConfigBlizzard( )
	
	local path = ArkInventory.Config.Blizzard
	
	path.args = {
		version = {
			order = 100,
			name = ArkInventory.Global.Version,
			type = "description",
		},
		notes = {
			order = 200,
			name = function( )
				local t = GetAddOnMetadata( ArkInventory.Const.Program.Name, string.format( "Notes-%s", GetLocale( ) ) ) or ""
				if t == "" then
					t = GetAddOnMetadata( ArkInventory.Const.Program.Name, "Notes" ) or ""
				end
				return t or ""
			end,
			type = "description",
		},
		config = {
			order = 300,
			name = ArkInventory.Localise["CONFIG"],
			desc = ArkInventory.Localise["CONFIG_TEXT"],
			type = "execute",
			func = function( )
				ArkInventory.Frame_Config_Show( )
			end,
		},
		enabled = {
			order = 400,
			name = ArkInventory.Localise["ENABLED"],
			type = "toggle",
			get = function( info )
				return ArkInventory:IsEnabled( )
			end,
			set = function( info, v )
				if v then
					ArkInventory:Enable( )
				else
					ArkInventory:Disable( )
				end
			end,
		},
		debug = {
			order = 500,
			name = ArkInventory.Localise["CONFIG_DEBUG"],
			type = "toggle",
			get = function( info )
				return ArkInventory.Const.Debug
			end,
			set = function( info, v )
				ArkInventory.OutputDebugModeSet( not ArkInventory.Const.Debug )
			end,
		},
		
		-- slash commands
		
		restack = {
			guiHidden = true,
			order = 9000,
			type = "execute",
			name = ArkInventory.Localise["RESTACK"],
			desc = ArkInventory.Localise["RESTACK_TEXT"],
			func = function( )
				ArkInventory.Restack( )
			end,
		},
		
		cache = {
			guiHidden = true,
			order = 9000,
			name = ArkInventory.Localise["SLASH_CACHE"],
			desc = ArkInventory.Localise["SLASH_CACHE_TEXT"],
			type = "group",
			args = {
				erase = {
					name = ArkInventory.Localise["SLASH_CACHE_ERASE"],
					desc = ArkInventory.Localise["SLASH_CACHE_ERASE_TEXT"],
					type = "group",
					args = {
						confirm = {
							name = ArkInventory.Localise["SLASH_CACHE_ERASE_CONFIRM"],
							desc = ArkInventory.Localise["SLASH_CACHE_ERASE_CONFIRM_TEXT"],
							type = "execute",
							func = function( )
								ArkInventory.EraseSavedData( )
							end,
						},
					},
				},
			},
		},
		
		edit = {
			guiHidden = true,
			order = 9000,
			name = ArkInventory.Localise["MENU_ACTION_EDITMODE"],
			type = "execute",
			func = function( )
				ArkInventory.Frame_Main_Show( ArkInventory.Const.Location.Bag )
				ArkInventory.ToggleEditMode( )
			end,
		},
		
		rules = {
			guiHidden = true,
			order = 9000,
			name = ArkInventory.Localise["CONFIG_RULES"],
			type = "execute",
			func = function( )
				ArkInventory.Frame_Rules_Toggle( )
			end,
		},
		
		search = {
			guiHidden = true,
			order = 9000,
			name = ArkInventory.Localise["SEARCH"],
			type = "execute",
			func = function( )
				ArkInventory.Frame_Search_Toggle( )
			end,
		},
		
		track = {
			guiHidden = true,
			order = 9000,
			name = ArkInventory.Localise["SLASH_TRACK"],
			desc = ArkInventory.Localise["SLASH_TRACK_TEXT"],
			type = "input",
			set = function( info, v )
				
				local name, h = GetItemInfo( v )
				
				if not name or not h then
					ArkInventory.OutputWarning( "no matching item found: ", v )
					return
				end
				
				local class, id = ArkInventory.ObjectStringDecode( h )
				
				if class ~= "item" then
					ArkInventory.OutputWarning( "not an item: ", v )
					return
				end
				
				if ArkInventory.db.global.option.tracking.items[id] then
					--remove
					ArkInventory.db.global.option.tracking.items[id] = nil
					ArkInventory.Global.Me.ldb.tracking.item.tracked[id] = false
					ArkInventory.Output( "Removed ", h, " from tracking list" )
				else
					--add
					ArkInventory.db.global.option.tracking.items[id] = true
					ArkInventory.Global.Me.ldb.tracking.item.tracked[id] = true
					ArkInventory.Output( "Added ", h, " to tracking list" )
				end
				
				ArkInventory.LDB.Tracking_Item:Update( )
				
			end,
		},
		
		translate = {
			guiHidden = true,
			order = 9000,
			name = "translate", -- ArkInventory.Localise["MENU_ACTION_EDITMODE"],
			desc = "attempts to get translations from the game again, a ui reload might be better",
			type = "execute",
			func = function( )
				ArkInventory.TranslateTryAgain( )
			end,
		},
		
		reposition = {
			guiHidden = true,
			order = 9000,
			name = "Reposition",
			desc = "repositions all arkinventory frames inside the game window, if the frame is already fully inside then it wont move",
			type = "execute",
			func = function( )
				ArkInventory.Frame_Main_Reposition_All( )
			end,
		},
		
		summon = {
			guiHidden = true,
			order = 9000,
			name = "summon a pet or mount",
			type = "group",
			args = {
				mount = {
					order = 100,
					name = ArkInventory.Localise["LDB_MOUNTS_SUMMON"],
					type = "execute",
					func = function( )
						ArkInventory.LDB.Mounts.OnClick( )
					end,
				},
				pet = {
					order = 100,
					name = ArkInventory.Localise["LDB_PETS_SUMMON"],
					type = "execute",
					func = function( )
						ArkInventory.LDB.Pets.OnClick( )
					end,
				},
			},
		},
		
--[[
		db = {
			guiHidden = true,
			order = 9000,
			name = ArkInventory.Localise["SLASH_DB"],
			desc = ArkInventory.Localise["SLASH_DB_TEXT"],
			type = "group",
			args = {
				reset = {
					name = ArkInventory.Localise["SLASH_DB_RESET"],
					desc = ArkInventory.Localise["SLASH_DB_RESET_TEXT"],
					type = "group",
					args = {
						confirm = {
							name = ArkInventory.Localise["SLASH_DB_RESET_CONFIRM"],
							desc = ArkInventory.Localise["SLASH_DB_RESET_CONFIRM_TEXT"],
							type = "execute",
							func = function( )
								ArkInventory.DatabaseReset( )
							end,
						},
					},
				},
			},
		},
]]--
		
		petbattlehelp = {
			guiHidden = true,
			cmdHidden = true,
			order = 12000,
			name = "petbattlehelp",
			desc = "attempts to help you pick appropriate battle pets for the current battle",
			type = "execute",
			func = function( )
				ArkInventory:LISTEN_PET_BATTLE_OPENING_DONE( "MANUAL_COMMAND", "PET_BATTLE_HELP" )
			end,
		},
		
		petinfo = {
			guiHidden = true,
			cmdHidden = true,
			order = 12000,
			name = "petinfo",
			desc = "gets information about the targeted battle pet",
			type = "execute",
			func = function( )
				ArkInventory.PetJournal.BattlePetInfoTarget( )
			end,
		},
		
	}
	
end
