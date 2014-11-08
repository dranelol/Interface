-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

local math = _G.math
local string = _G.string
local table = _G.table

local pairs = _G.pairs
local ipairs = _G.ipairs

local tostring = _G.tostring
local tonumber = _G.tonumber

local unpack = _G.unpack

-------------------------------------------------------------------------------
-- Localized Blizzard UI globals.
-------------------------------------------------------------------------------
local GetTime = _G.GetTime

-------------------------------------------------------------------------------
-- Addon namespace.
-------------------------------------------------------------------------------
local ADDON_NAME, namespace	= ...

local KNOWN_PREFIXES	= namespace.known_prefixes
local MATCHED_PREFIXES	= namespace.matched_prefixes

local LibStub		= _G.LibStub
local Spamalyzer	= LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local LQT		= LibStub("LibQTip-1.0")
local LDB		= LibStub("LibDataBroker-1.1")
local LDBIcon		= LibStub("LibDBIcon-1.0")
local L			= LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local debugger		= _G.tekDebug and _G.tekDebug:GetFrame(ADDON_NAME)

-------------------------------------------------------------------------------
-- Variables.
-------------------------------------------------------------------------------
local players		= {}	-- List of players and their data.
local sorted_players	= {}

local addons		= {}	-- List of AddOns and their data.
local sorted_addons	= {}

local channels		= {}	-- List of channels and their data.
local sorted_channels	= {}

local guild_classes	= {}	-- Guild cache, updated when GUILD_ROSTER_UPDATE fires.

local timers		= {}	-- Timers currently in use

local track_cache	= {}	-- Cached tracking types to avoid constant string.lower() calls.

-- Messages/bytes in/out
local activity = {
	output = 0,
	input = 0,
	bytes = 0,
	sent = 0,
	received = 0,
	messages = 0,
}

local db
local output_frame	-- ChatFrame to direct AddonMessages to.
local epoch		= GetTime()	-- Beginning time for AddonMessage tracking.

-------------------------------------------------------------------------------
-- Constants.
-------------------------------------------------------------------------------
local ICON_PLUS = [[|TInterface\BUTTONS\UI-PlusButton-Up:15:15|t]]
local ICON_MINUS = [[|TInterface\BUTTONS\UI-MinusButton-Up:15:15|t]]

local DISPLAY_NAMES = {
	L["Output"],
	L["Input"],
	L["Bytes"],
	L["Sent"],
	L["Received"],
	L["Messages"],
}

local DISPLAY_VALUES = {
	"output",
	"input",
	"bytes",
	"sent",
	"received",
	"messages",
}

local CHAT_FRAME_MAP = {
	nil,
	_G.ChatFrame1,
	_G.ChatFrame2,
	_G.ChatFrame3,
	_G.ChatFrame4,
	_G.ChatFrame5,
	_G.ChatFrame6,
	_G.ChatFrame7,
}

local CHANNEL_TYPE_NAMES = {
	INSTANCE_CHAT	= _G.INSTANCE_CHAT,
	GUILD		= _G.GUILD,
	OFFICER		= _G.OFFICER,
	PARTY		= _G.PARTY,
	RAID		= _G.RAID,
	WHISPER		= _G.WHISPER,
}

local MY_NAME		= _G.UnitName("player")

-- Populated in Spamalyzer:UPDATE_CHAT_COLOR()
local CHANNEL_COLORS

-------------------------------------------------------------------------------
-- Debugger.
-------------------------------------------------------------------------------
local function Debug(...)
	if debugger then
		debugger:AddMessage(string.join(", ", ...))
	end
end

-------------------------------------------------------------------------------
-- Tooltip and Databroker methods.
-------------------------------------------------------------------------------
local NUM_COLUMNS = 4

local data_obj
local LDB_anchor
local tooltip

local elapsed_line -- Line in the tooltip where the elapsed time resides.

local ByteStr
do
	local KiB = 1024
	local MiB = KiB * KiB

	function ByteStr(bytes)
		if bytes <= 0 then
			return "0"
		end

		if bytes >= MiB then
			return ("%.2f MiB"):format(bytes / MiB)
		end

		if bytes >= KiB then
			return ("%.2f KiB"):format(bytes / KiB)
		end
		return bytes
	end
end

local function UpdateDataFeed()
	local value = db.datafeed.display
	local display = (value <= 3) and ByteStr(activity[DISPLAY_VALUES[value]]) or activity[DISPLAY_VALUES[value]]
	data_obj.text = DISPLAY_NAMES[value] .. ": " .. (display or _G.NONE)
end

do
	local function TimeStr(val)
		local tm = tonumber(val)

		if tm <= 0 then
			return "0s"
		end
		local hours = math.floor(tm / 3600)
		local minutes = math.floor(tm / 60 - (hours * 60))
		local seconds = math.floor(tm - hours * 3600 - minutes * 60)

		hours = hours > 0 and (hours .. "h") or ""
		minutes = minutes > 0 and (minutes .. "m") or ""
		seconds = seconds > 0 and (seconds .. "s") or ""
		return hours .. minutes .. seconds
	end

	local time_str = TimeStr(GetTime() - epoch) -- Cached value used between updates.

	function Spamalyzer:UpdateElapsed(use_cache)
		if not elapsed_line or not tooltip then
			return
		end

		if use_cache then
			tooltip:SetCell(elapsed_line, NUM_COLUMNS, time_str)
			return
		end
		time_str = TimeStr(GetTime() - epoch)
		tooltip:SetCell(elapsed_line, NUM_COLUMNS, time_str)
	end
end -- do

do
	local last_update = 0

	local function Cleanup()
		Spamalyzer:CancelTimer(timers.tooltip_update)
		Spamalyzer:CancelTimer(timers.elapsed_update)

		timers.tooltip_update = nil
		timers.elapsed_update = nil

		tooltip = LQT:Release(tooltip)
		LDB_anchor = nil
		elapsed_line = nil
		last_update = 0
	end

	function Spamalyzer:UpdateTooltip()
		last_update = last_update + 1

		-- Check for tooltip visibility as well, since DockingStation 0.3.3 (and a few versions below)
		-- handles tooltip hiding _way_ too aggressively.
		if not tooltip or not tooltip:IsVisible() then
			Cleanup()
			return
		end

		if tooltip:IsMouseOver() or (LDB_anchor and LDB_anchor:IsMouseOver()) then
			last_update = 0
		else
			local elapsed = last_update * 0.2

			if elapsed >= db.tooltip.timer then
				Cleanup()
			end
		end
	end
end -- do

local DrawTooltip
do
	local function NameOnMouseUp(cell, index)
		local view_mode = db.tooltip.view_mode
		local entry

		if view_mode == "ADDONS" then
			entry = addons[sorted_addons[index]]
		elseif view_mode == "CHANNEL" then
			entry = channels[sorted_channels[index]]
		elseif view_mode == "PLAYER" then
			entry = players[sorted_players[index]]
		end
		entry.toggled = not entry.toggled
		DrawTooltip(LDB_anchor)
	end

	local function SortOnMouseUp(cell, sort_func)
		db.tooltip.sorting = sort_func
		db.tooltip.sort_ascending = not db.tooltip.sort_ascending

		DrawTooltip(LDB_anchor)
	end

	-------------------------------------------------------------------------------
	-- Sorting
	-------------------------------------------------------------------------------

	-- Iterator states - when drawing the tooltip, we need to know which AddOn or channel we are currently on so
	-- we can accurately sort sub-entries.
	local addon_iter
	local channel_iter

	local ADDON_SORT_FUNCS = {
		name = function(a, b)
			if db.tooltip.sort_ascending then
				return a < b
			end
			return a > b
		end,
		bytes = function(a, b)
			local addon_a, addon_b

			if channel_iter then
				local channel = channels[channel_iter]

				addon_a, addon_b = channel.addons[a], channel.addons[b]
			else
				addon_a, addon_b = addons[a], addons[b]
			end

			if addon_a.output == addon_b.output then
				if db.tooltip.sort_ascending then
					return a < b
				end
				return a > b
			end

			if db.tooltip.sort_ascending then
				return addon_a.output < addon_b.output
			end
			return addon_a.output > addon_b.output
		end,
		messages = function(a, b)
			local addon_a, addon_b

			if channel_iter then
				local channel = channels[channel_iter]

				addon_a, addon_b = channel.addons[a], channel.addons[b]
			else
				addon_a, addon_b = addons[a], addons[b]
			end

			if addon_a.messages == addon_b.messages then
				if db.tooltip.sort_ascending then
					return a < b
				end
				return a > b
			end

			if db.tooltip.sort_ascending then
				return addon_a.messages < addon_b.messages
			end
			return addon_a.messages > addon_b.messages
		end
	}

	local CHANNEL_SORT_FUNCS = {
		name = function(a, b)
			if db.tooltip.sort_ascending then
				return a < b
			end
			return a > b
		end,
		bytes = function(a, b)
			local channel_a, channel_b = channels[a], channels[b]

			if channel_a.output == channel_b.output then
				if db.tooltip.sort_ascending then
					return a < b
				end
				return a > b
			end

			if db.tooltip.sort_ascending then
				return channel_a.output < channel_b.output
			end
			return channel_a.output > channel_b.output
		end,
		messages = function(a, b)
			local channel_a, channel_b = channels[a], channels[b]

			if channel_a.messages == channel_b.messages then
				if db.tooltip.sort_ascending then
					return a < b
				end
				return a > b
			end

			if db.tooltip.sort_ascending then
				return channel_a.messages < channel_b.messages
			end
			return channel_a.messages > channel_b.messages
		end
	}

	local PLAYER_SORT_FUNCS = {
		name = function(a, b)
			if db.tooltip.sort_ascending then
				return a < b
			end
			return a > b
		end,
		bytes = function(a, b)
			local player_a, player_b = players[a], players[b]

			if addon_iter then
				if player_a.addons[addon_iter].output == player_b.addons[addon_iter].output then
					if db.tooltip.sort_ascending then
						return a < b
					end
					return a > b
				end

				if db.tooltip.sort_ascending then
					return player_a.addons[addon_iter].output < player_b.addons[addon_iter].output
				end
				return player_a.addons[addon_iter].output > player_b.addons[addon_iter].output
			end

			if player_a.output == player_b.output then
				if db.tooltip.sort_ascending then
					return a < b
				end
				return a > b
			end

			if db.tooltip.sort_ascending then
				return player_a.output < player_b.output
			end
			return player_a.output > player_b.output
		end,
		messages = function(a, b)
			local player_a, player_b = players[a], players[b]

			if addon_iter then
				if player_a.addons[addon_iter].messages == player_b.addons[addon_iter].messages then
					if db.tooltip.sort_ascending then
						return a < b
					end
					return a > b
				end

				if db.tooltip.sort_ascending then
					return player_a.addons[addon_iter].messages < player_b.addons[addon_iter].messages
				end
				return player_a.addons[addon_iter].messages > player_b.addons[addon_iter].messages
			end

			if player_a.messages == player_b.messages then
				if db.tooltip.sort_ascending then
					return a < b
				end
				return a > b
			end

			if db.tooltip.sort_ascending then
				return player_a.messages < player_b.messages
			end
			return player_a.messages > player_b.messages
		end,
	}

	local CLASS_COLORS = _G.CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS

	local SORT_FUNC_TABLES = {
		ADDONS = ADDON_SORT_FUNCS,
		CHANNEL = CHANNEL_SORT_FUNCS,
		PLAYER = PLAYER_SORT_FUNCS,
	}

	local function GetPlayerClass(player)
		local guildie = guild_classes[player]

		if guildie then
			return guildie
		end
		local _, class_english = _G.UnitClass(player)

		if class_english then
			return class_english
		end
	end

	local VIEW_MODES = {
		ADDONS	= _G.ADDONS,
		CHANNEL	= _G.CHANNEL,
		PLAYER	= _G.PLAYER,
	}

	local SORT_TABLES = {
		ADDONS	= sorted_addons,
		CHANNEL	= sorted_channels,
		PLAYER	= sorted_players,
	}

	local BODY_DRAW_FUNCTIONS = {
		ADDONS = function(sort_method)
			for index, addon_name in ipairs(sorted_addons) do
				local addon = addons[addon_name]
				local toggled = addon.toggled
				local color_table = addon.known and _G.GREEN_FONT_COLOR or _G.RED_FONT_COLOR

				local line = tooltip:AddLine(toggled and ICON_MINUS or ICON_PLUS, " ", addon.messages, ByteStr(addon.output))
				tooltip:SetLineColor(line, 0.63921568627451, 0.63921568627451, 0.63921568627451)

				tooltip:SetCell(line, 2, addon_name, "LEFT")
				tooltip:SetCellTextColor(line, 2, color_table.r, color_table.g, color_table.b)
				tooltip:SetCellColor(line, 3, 0.63921568627451, 0.63921568627451, 0.63921568627451)
				tooltip:SetLineScript(line, "OnMouseUp", NameOnMouseUp, index)

				if toggled then
					if #addon.sorted > 1 then
						table.sort(addon.sorted, PLAYER_SORT_FUNCS[sort_method])
					end

					for index, player_name in ipairs(addon.sorted) do
						local player = players[player_name]
						local class_color = CLASS_COLORS[player.class]

						if not class_color then
							player.class = GetPlayerClass(player_name)
							class_color = CLASS_COLORS[player.class] or _G.GRAY_FONT_COLOR
						end
						line = tooltip:AddLine(" ", " ", player.addons[addon_name].messages, ByteStr(player.addons[addon_name].output))
						tooltip:SetCell(line, 2, ("%s%s"):format(player_name, player.realm or ""), "LEFT")
						tooltip:SetCellTextColor(line, 2, class_color.r, class_color.g, class_color.b)
					end
				end
				addon_iter = addon_name
			end
		end,
		CHANNEL = function(sort_method)
			for index, channel_name in ipairs(sorted_channels) do
				local channel = channels[channel_name]
				local toggled = channel.toggled

				local line = tooltip:AddLine(toggled and ICON_MINUS or ICON_PLUS, " ", channel.messages, ByteStr(channel.output))
				tooltip:SetLineColor(line, 0.63921568627451, 0.63921568627451, 0.63921568627451)

				tooltip:SetCell(line, 2, channel.name, "LEFT")
				tooltip:SetCellColor(line, 3, 0.63921568627451, 0.63921568627451, 0.63921568627451)
				tooltip:SetLineScript(line, "OnMouseUp", NameOnMouseUp, index)

				if toggled then
					if #channel.sorted > 1 then
						table.sort(channel.sorted, ADDON_SORT_FUNCS[sort_method])
					end

					for index, addon_name in ipairs(channel.sorted) do
						local addon = channel.addons[addon_name]
						local color_table = addon.known and _G.GREEN_FONT_COLOR or _G.RED_FONT_COLOR

						line = tooltip:AddLine(" ", " ", addon.messages, ByteStr(addon.output))
						tooltip:SetCell(line, 2, addon_name, "LEFT")
						tooltip:SetCellTextColor(line, 2, color_table.r, color_table.g, color_table.b)
					end
				end
				channel_iter = channel_name
			end
		end,
		PLAYER = function(sort_method)
			for index, player_name in ipairs(sorted_players) do
				local player = players[player_name]
				local toggled = player.toggled
				local class_color = CLASS_COLORS[player.class]

				if not class_color then
					player.class = GetPlayerClass(player_name)
					class_color = CLASS_COLORS[player.class] or _G.GRAY_FONT_COLOR
				end
				local line = tooltip:AddLine(toggled and ICON_MINUS or ICON_PLUS, " ", player.messages, ByteStr(player.output))
				tooltip:SetLineColor(line, 0.63921568627451, 0.63921568627451, 0.63921568627451)

				tooltip:SetCell(line, 2, ("%s%s"):format(player_name, player.realm or ""), "LEFT")
				tooltip:SetCellTextColor(line, 2, class_color.r, class_color.g, class_color.b)
				tooltip:SetCellColor(line, 3, 0.63921568627451, 0.63921568627451, 0.63921568627451)
				tooltip:SetLineScript(line, "OnMouseUp", NameOnMouseUp, index)

				if toggled then
					if #player.sorted > 1 then
						table.sort(player.sorted, ADDON_SORT_FUNCS[sort_method])
					end

					for index, addon_name in ipairs(player.sorted) do
						local addon = player.addons[addon_name]
						local color_table = addon.known and _G.GREEN_FONT_COLOR or _G.RED_FONT_COLOR

						line = tooltip:AddLine(" ", " ", addon.messages, ByteStr(addon.output))
						tooltip:SetCell(line, 2, addon_name, "LEFT")
						tooltip:SetCellTextColor(line, 2, color_table.r, color_table.g, color_table.b)
					end
				end
			end
		end,
	}

	local HINT_TEXTS = {
		L["Left-click to change datafeed type."],
		L["Shift+Left-click to clear data."],
		L["Right-click for options."],
		L["Middle-click to change tooltip mode."],
	}

	function DrawTooltip(anchor)
		elapsed_line = nil

		if not anchor then
			return
		end
		LDB_anchor = anchor

		if not tooltip then
			tooltip = LQT:Acquire(ADDON_NAME .. "Tooltip", NUM_COLUMNS, "LEFT", "CENTER", "CENTER", "CENTER")
			tooltip:EnableMouse(true)

			if _G.TipTac and _G.TipTac.AddModifiedTip then
				-- Pass true as second parameter because hooking OnHide causes C stack overflows
				_G.TipTac:AddModifiedTip(tooltip, true)
			end
		end
		tooltip:Clear()
		tooltip:SmartAnchorTo(anchor)
		tooltip:SetScale(db.tooltip.scale)
		tooltip:SetCellMarginV(1)
		tooltip:SetCellMarginH(2)

		local view_mode = db.tooltip.view_mode
		local line, column = tooltip:AddHeader()
		tooltip:SetLineColor(line, 0.63921568627451, 0.63921568627451, 0.63921568627451)

		tooltip:SetCell(line, 1, ADDON_NAME .. " - " .. (VIEW_MODES[view_mode] or VIEW_MODES.PLAYER), "CENTER", NUM_COLUMNS)
		tooltip:SetCellColor(line, 3, 0.63921568627451, 0.63921568627451, 0.63921568627451)
		tooltip:SetCellTextColor(line, 1, _G.NORMAL_FONT_COLOR.r, _G.NORMAL_FONT_COLOR.g, _G.NORMAL_FONT_COLOR.b)
		tooltip:SetCellTextColor(line, 4, _G.NORMAL_FONT_COLOR.r, _G.NORMAL_FONT_COLOR.g, _G.NORMAL_FONT_COLOR.b)

		tooltip:AddSeparator()
		tooltip:AddSeparator()

		local sort_table = SORT_TABLES[view_mode] or SORT_TABLES.PLAYER

		if #sort_table == 0 then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, _G.EMPTY, "CENTER", NUM_COLUMNS)
			tooltip:AddLine(" ")

			elapsed_line = tooltip:AddLine()
			tooltip:SetCell(elapsed_line, 1, _G.TIME_ELAPSED, "LEFT", 3)

			Spamalyzer:UpdateElapsed(timers.elapsed_update)

			tooltip:Show()
			return
		end
		line = tooltip:AddLine(" ", " ", L["Messages"], L["Bytes"])
		tooltip:SetCell(line, 1, _G.NAME, "LEFT", 2)

		tooltip:SetCellScript(line, 1, "OnMouseUp", SortOnMouseUp, "name")
		tooltip:SetCellScript(line, 3, "OnMouseUp", SortOnMouseUp, "messages")
		tooltip:SetCellScript(line, 4, "OnMouseUp", SortOnMouseUp, "bytes")

		tooltip:AddSeparator()
		tooltip:AddSeparator()

		local sort_funcs = SORT_FUNC_TABLES[view_mode] or SORT_FUNC_TABLES.PLAYER
		local sort_method = _G.type(db.tooltip.sorting) == "string" and db.tooltip.sorting or "name"

		if #sort_table > 1 then
			table.sort(sort_table, sort_funcs[sort_method] or sort_funcs.name)
		end

		-- Reset our iter state.
		addon_iter = nil
		channel_iter = nil

		BODY_DRAW_FUNCTIONS[view_mode](sort_method)

		if db.tooltip.show_stats then
			tooltip:AddSeparator()
			tooltip:AddSeparator()

			for index, name in ipairs(DISPLAY_NAMES) do
				local value = activity[DISPLAY_VALUES[index]]

				line = tooltip:AddLine(" ", " ", " ", (index <= 3) and ByteStr(value) or value)
				tooltip:SetCell(line, 1, name, "LEFT", 2)
			end
		end
		tooltip:AddSeparator()
		tooltip:AddSeparator()

		elapsed_line = tooltip:AddLine()
		tooltip:SetCell(elapsed_line, 1, _G.TIME_ELAPSED, "LEFT", 3)

		Spamalyzer:UpdateElapsed(timers.elapsed_update)

		if not db.tooltip.hide_hint then
			tooltip:AddSeparator()
			tooltip:AddSeparator()

			for index = 1, #HINT_TEXTS do
				line = tooltip:AddLine()
				tooltip:SetCell(line, 1, HINT_TEXTS[index], "LEFT", NUM_COLUMNS)
			end
		end
		tooltip:UpdateScrolling()
		tooltip:Show()
	end
end -- do

-- Fired 1.5 seconds after a call to StoreMessage()
function Spamalyzer:OnMessageUpdate()
	UpdateDataFeed()

	if LDB_anchor and tooltip and tooltip:IsVisible() then
		DrawTooltip(LDB_anchor)
	end
	timers.message_update = nil
end

do
	local COLOR_GREEN	= "|cff00ff00"
	local COLOR_PALE_GREEN	= "|cffa3feba"
	local COLOR_PINK	= "|cffffbbbb"
	local COLOR_RED		= "|cffff0000"

	local function EscapeChar(c)
		return ("\\%03d"):format(c:byte())
	end

	function Spamalyzer:StoreMessage(prefix, message, type, origin, target)
		local tracking = track_cache[type]

		if not tracking and not output_frame then
			return
		end
		local addon_name = KNOWN_PREFIXES[prefix]

		if not addon_name then
			for partial, match_name in pairs(MATCHED_PREFIXES) do
				if prefix:match(partial) then
					addon_name = match_name
					break
				end
			end

			if not addon_name then
				-- Try escaping it and testing for AceComm-3.0 multi-part.
				local escaped_prefix = prefix:gsub("[%c\092\128-\255]", EscapeChar)

				if escaped_prefix:match(".-\\%d%d%d") then
					local matched_prefix = escaped_prefix:match("(.-)\\%d%d%d")

					if KNOWN_PREFIXES[matched_prefix] then
						addon_name = KNOWN_PREFIXES[matched_prefix]
					end
				end
				-- Cache this in the prefix table.
				KNOWN_PREFIXES[prefix] = addon_name
			end
		end
		local channel_color = CHANNEL_COLORS and CHANNEL_COLORS[type] or "cccccc"

		if output_frame and ((addon_name and db.general.display_known) or (not addon_name and db.general.display_unknown)) then
			local color = tracking and COLOR_PALE_GREEN or COLOR_PINK
			local display_name = addon_name or _G.UNKNOWN
			local display_color = addon_name and COLOR_GREEN or COLOR_RED

			message = message or ""
			target = target and (" to " .. target .. ", from ") or ""

			output_frame:AddMessage(("%s%s|r (|cff%s%s|r): %s[%s] [%s]|r %s %s[%s]|r"):format(display_color, display_name, channel_color, CHANNEL_TYPE_NAMES[type], color, prefix, message, target, color, origin))
		end

		-- Not tracking data from this message type, so stop here.
		if not tracking then
			return
		end
		local bytes = string.len(prefix) + string.len(message)

		if bytes == 0 then
			return
		end
		addon_name = addon_name or prefix -- Ensure that addon_name is not nil.

		local player_name, realm = string.split("-", origin, 2)

		-- If the player is on the current realm, player_name will be nil - set it as origin.
		player_name = player_name or origin

		local player = players[player_name]

		if not player then
			player = {
				name = player_name,
				messages = 1,
				output = bytes,
				sorted = {},
				addons = {
					[addon_name] = {
						messages = 1,
						output = bytes,
						known = addon_name and true or false,
					}
				}
			}
			table.insert(player.sorted, addon_name)

			if realm then
				player.realm = "|cff" .. channel_color .. "-" .. realm .. "|r"
			end
			players[player_name] = player
			table.insert(sorted_players, player_name)
		else
			if realm then
				player.realm = "|cff" .. channel_color .. "-" .. realm .. "|r"
			end
			local source = player.addons[addon_name]

			if not source then
				source = {
					known = addon_name and true or false,
					messages = 0,
					output = 0,
				}
				table.insert(player.sorted, addon_name)
				player.addons[addon_name] = source
			end
			source.output = source.output + bytes
			source.messages = source.messages + 1

			player.messages = player.messages + 1
			player.output = player.output + bytes
		end
		local addon = addons[addon_name]

		if not addon then
			addon = {
				messages = 1,
				output = bytes,
				known = addon_name and true or false,
				name = addon_name,
				sorted = {},
				players = {
					[player_name] = true
				}
			}
			table.insert(addon.sorted, player_name)

			addons[addon_name] = addon
			table.insert(sorted_addons, addon_name)
		else
			local player = addon.players[player_name]

			if not player then
				addon.players[player_name] = true
				table.insert(addon.sorted, player_name)
			end
			addon.output = addon.output + bytes
			addon.messages = addon.messages + 1
		end
		local channel = channels[type]

		if not channel then
			channel = {
				name = "|cff" .. channel_color .. CHANNEL_TYPE_NAMES[type] .. "|r",
				messages = 1,
				output = bytes,
				sorted = {},
				addons = {
					[addon_name] = {
						messages = 1,
						output = bytes,
						known = addon_name and true or false,
					}
				}
			}
			table.insert(channel.sorted, addon_name)
			channels[type] = channel
			table.insert(sorted_channels, type)
		else
			local source = channel.addons[addon_name]

			if not source then
				source = {
					known = addon_name and true or false,
					messages = 0,
					output = 0,
				}
				table.insert(channel.sorted, addon_name)
				channel.addons[addon_name] = source
			end
			source.output = source.output + bytes
			source.messages = source.messages + 1

			channel.messages = channel.messages + 1
			channel.output = channel.output + bytes
		end

		if origin == MY_NAME then
			activity.output = activity.output + bytes
			activity.sent = activity.sent + 1
		else
			activity.input = activity.input + bytes
			activity.received = activity.received + 1
		end
		activity.bytes = activity.bytes + bytes
		activity.messages = activity.messages + 1

		if not timers.message_update then
			timers.message_update = self:ScheduleTimer("OnMessageUpdate", 1.5)
		end
	end
end --do

-------------------------------------------------------------------------------
-- Hooked functions.
-------------------------------------------------------------------------------
function Spamalyzer:SendAddonMessage(prefix, message, type, target)
	-- Only gather messages we send to the whiper channel, because we'll catch everything else.
	if target and target ~= "" and type == "WHISPER" then
		self:StoreMessage(prefix, message, type, MY_NAME, target)
	end
end

-------------------------------------------------------------------------------
-- Event functions.
-------------------------------------------------------------------------------
function Spamalyzer:OnInitialize()
	local defaults = {
		global = {
			datafeed = {
				display = 1, -- Output (in bytes)
				minimap_icon = {
					hide = false,
				},
			},
			general = {
				display_frame = 1, -- None.
				display_known = true,
				display_unknown = true,
			},
			tracking = {
				instance_chat = false,
				guild = false,
				officer = false,
				party = true,
				raid = true,
				whisper = true,
			},
			tooltip = {
				hide_hint = false,
				view_mode = "PLAYER",
				show_stats = false,
				scale = 1,
				sorting = "name",
				sort_ascending = true,
				timer = 0.25,
			},
		}
	}

	local temp_db = LibStub("AceDB-3.0"):New(ADDON_NAME .. "DB", defaults)
	db = temp_db.global

	output_frame = CHAT_FRAME_MAP[db.general.display_frame]

	-- Cache the tracking preferences.
	for track_type, val in pairs(db.tracking) do
		track_cache[track_type:upper()] = val
	end
	self:SetupOptions()
end

local VIEW_MODE_TO_INDEX = {
	ADDONS	= 1,
	CHANNEL	= 2,
	PLAYER	= 3,
}

local INDEX_TO_VIEW_MODE = {
	"ADDONS",
	"CHANNEL",
	"PLAYER",

}

function Spamalyzer:OnEnable()
	data_obj = LDB:NewDataObject(ADDON_NAME, {
		type = "data source",
		label = ADDON_NAME,
		text = " ",
		icon = [[Interface\Icons\INV_Letter_16]],
		OnEnter = function(display, motion)
			if not timers.tooltip_update then
				DrawTooltip(display)
				timers.tooltip_update = self:ScheduleRepeatingTimer("UpdateTooltip", 0.2)
			end

			if not timers.elapsed_update then
				timers.elapsed_update = self:ScheduleRepeatingTimer("UpdateElapsed", 1)
			end
		end,
		OnLeave = function()
		-- OnLeave is an empty function because some LDB displays refuse to display a plugin that has an OnEnter but no OnLeave.
		end,
		OnClick = function(display, button)
			if button == "RightButton" then
				local options_frame = _G.InterfaceOptionsFrame

				if options_frame:IsVisible() then
					options_frame:Hide()
				else
					_G.InterfaceOptionsFrame_OpenToCategory(Spamalyzer.options_frame)
				end
			elseif button == "LeftButton" then
				if _G.IsShiftKeyDown() then
					table.wipe(sorted_players)
					table.wipe(players)

					table.wipe(sorted_addons)
					table.wipe(addons)

					table.wipe(sorted_channels)
					table.wipe(channels)

					activity.output = 0
					activity.input = 0
					activity.bytes = 0
					activity.sent = 0
					activity.received = 0
					activity.messages = 0

					epoch = GetTime()
					DrawTooltip(display)
					UpdateDataFeed()
				else
					local cur_val = db.datafeed.display
					db.datafeed.display = (cur_val == 6) and 1 or cur_val + 1
					UpdateDataFeed()
				end
			elseif button == "MiddleButton" then
				local cur_val = VIEW_MODE_TO_INDEX[db.tooltip.view_mode]
				db.tooltip.view_mode = INDEX_TO_VIEW_MODE[(cur_val == 3) and 1 or cur_val + 1]

				DrawTooltip(display)
			end
		end,
	})
	UpdateDataFeed()

	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("GUILD_ROSTER_UPDATE")
	self:RegisterEvent("UPDATE_CHAT_COLOR")

	self:SecureHook("SendAddonMessage")

	-- Break the server soft cap, as per http://us.battle.net/wow/en/forum/topic/2228413591?page=2#23
	--[===[@debug@
	for index = 1, 65 do
		_G.RegisterAddonMessagePrefix("DEBUG_" .. index)
	end
	--@end-debug@]===]

	-- Wait a few seconds to be sure everything is loaded, then request guild and channel information to cache for later use.
	self:ScheduleTimer(_G.GuildRoster, 5)
	self:ScheduleTimer("UPDATE_CHAT_COLOR", 5)

	if LDBIcon then
		LDBIcon:Register(ADDON_NAME, data_obj, db.datafeed.minimap_icon)
	end
end

function Spamalyzer:OnDisable()
	for handle, timer in pairs(timers) do
		self:CancelTimer(timer, true)
		timers[handle] = nil
	end
end

-- Channel names may have been set before this event fired, and must be colorized.
-- This is also fired when the user changes channel colors in the default UI.
function Spamalyzer:UPDATE_CHAT_COLOR()
	CHANNEL_COLORS = CHANNEL_COLORS or {}

	for track_type, val in pairs(db.tracking) do
		local upper_type = track_type:upper()
		local chat_info = _G.ChatTypeInfo[upper_type]

		if channels[upper_type] and chat_info.r and chat_info.g and chat_info.b then
			CHANNEL_COLORS[upper_type] = ("%2x%2x%2x"):format(chat_info.r * 255, chat_info.g * 255, chat_info.b * 255)
			channels[upper_type].name = "|cff" .. CHANNEL_COLORS[upper_type] .. CHANNEL_TYPE_NAMES[upper_type] .. "|r"
		end
	end
end

function Spamalyzer:GUILD_ROSTER_UPDATE()
	if not _G.IsInGuild() then
		return
	end
	table.wipe(guild_classes)

	for count = 1, _G.GetNumGuildMembers(true), 1 do
		local name, _, _, _, _, _, _, _, _, _, class = _G.GetGuildRosterInfo(count)

		if name and class then
			guild_classes[name] = class
		end
	end
end


function Spamalyzer:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
	self:StoreMessage(prefix, message, channel, sender)
end

-------------------------------------------------------------------------------
-- Configuration.
-------------------------------------------------------------------------------
local options

local function GetOptions()
	if not options then
		local function CreateTrackingToggle(order, field)
			local toggle_name = field:upper()

			return {
				order = order,
				type = "toggle",
				name = _G[toggle_name],
				desc = L["Toggle recording of %s AddOn messages."]:format(_G[toggle_name]),
				get = function()
					return db.tracking[field]
				end,
				set = function()
					db.tracking[field] = not db.tracking[field]
					track_cache[toggle_name] = db.tracking[field]
				end
			}
		end

		options = {
			name = ADDON_NAME,
			childGroups = "tab",
			type = "group",
			args = {
				-------------------------------------------------------------------------------
				-- General options.
				-------------------------------------------------------------------------------
				general = {
					name = _G.GENERAL_LABEL,
					order = 10,
					type = "group",
					args = {
						minimap_icon = {
							order = 10,
							type = "toggle",
							width = "full",
							name = L["Minimap Icon"],
							desc = L["Draws the icon on the minimap."],
							get = function()
								return not db.datafeed.minimap_icon.hide
							end,
							set = function(info, value)
								db.datafeed.minimap_icon.hide = not value

								LDBIcon[value and "Show" or "Hide"](LDBIcon, ADDON_NAME)
							end,
						},
						spacer1 = {
							order = 11,
							type = "description",
							name = "\n",
						},
						display_frame = {
							order = 20,
							type = "select",
							name = _G.DISPLAY_OPTIONS,
							desc = L["Secondary location to display AddOn messages."],
							get = function()
								return db.general.display_frame
							end,
							set = function(info, value)
								db.general.display_frame = value
								output_frame = CHAT_FRAME_MAP[value]
							end,
							values = {
								_G.NONE,
								L["ChatFrame1"],
								L["ChatFrame2"],
								L["ChatFrame3"],
								L["ChatFrame4"],
								L["ChatFrame5"],
								L["ChatFrame6"],
								L["ChatFrame7"],
							},
						},
						display_known = {
							order = 30,
							type = "toggle",
							width = "full",
							name = L["Display Known"],
							desc = L["Display messages from known AddOns in the ChatFrame."],
							get = function()
								return db.general.display_known
							end,
							set = function(info, value)
								db.general.display_known = value
							end,
						},
						display_unknown = {
							order = 40,
							type = "toggle",
							width = "full",
							name = L["Display Unknown"],
							desc = L["Display messages from unknown AddOns in the ChatFrame."],
							get = function()
								return db.general.display_unknown
							end,
							set = function(info, value)
								db.general.display_unknown = value
							end,
						},
					},
				},
				-------------------------------------------------------------------------------
				-- Tracking options.
				-------------------------------------------------------------------------------
				tracking = {
					name = L["Tracking"],
					order = 30,
					type = "group",
					args = {
						instance_chat = CreateTrackingToggle(10, "instance_chat"),
						guild = CreateTrackingToggle(20, "guild"),
						officer = CreateTrackingToggle(30, "officer"),
						party = CreateTrackingToggle(40, "party"),
						raid = CreateTrackingToggle(50, "raid"),
						whisper = CreateTrackingToggle(60, "whisper"),
					},
				},
				-------------------------------------------------------------------------------
				-- Tooltip options.
				-------------------------------------------------------------------------------
				tooltip = {
					name = L["Tooltip"],
					order = 40,
					type = "group",
					args = {
						scale = {
							order = 10,
							type = "range",
							width = "full",
							name = L["Scale"],
							desc = L["Move the slider to adjust the scale of the tooltip."],
							min = 0.5,
							max = 1.5,
							step = 0.01,
							get = function()
								return db.tooltip.scale
							end,
							set = function(info, value)
								db.tooltip.scale = math.max(0.5, math.min(1.5, value))
							end,
						},
						timer = {
							order = 20,
							type = "range",
							width = "full",
							name = L["Timer"],
							desc = L["Move the slider to adjust the tooltip fade time."],
							min = 0.2,
							max = 2,
							step = 0.1,
							get = function()
								return db.tooltip.timer
							end,
							set = function(info, value)
								db.tooltip.timer = math.max(0.2, math.min(2, value))
							end,
						},
						hide_hint = {
							order = 30,
							type = "toggle",
							width = "full",
							name = L["Hide Hint Text"],
							desc = L["Hides the hint text at the bottom of the tooltip."],
							get = function()
								return db.tooltip.hide_hint
							end,
							set = function(info, value)
								db.tooltip.hide_hint = value
							end,
						},
						show_stats = {
							order = 40,
							type = "toggle",
							width = "full",
							name = _G.STATISTICS,
							desc = L["Show traffic statistics at the bottom of the tooltip."],
							get = function()
								return db.tooltip.show_stats
							end,
							set = function(info, value)
								db.tooltip.show_stats = value
							end,
						},
					},
				},
			},
		}
	end
	return options
end

function Spamalyzer:SetupOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, GetOptions())
	self.options_frame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME)
end
