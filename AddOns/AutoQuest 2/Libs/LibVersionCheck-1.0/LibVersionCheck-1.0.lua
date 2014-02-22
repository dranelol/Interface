--- LibVersionCheck is a library for adding version checking to your addon using the addon communication channels.
-- Versions are automatically checked for your guild, party, raid, battleground, and arena.
-- Multiple queries and responses sent during the same update will be coalesced to reduce the number of messages sent.
-- ChatThrottleLib will be used if it is available. <http://www.wowwiki.com/ChatThrottleLib>

-- @class file
-- @name LibVersionCheck-1.0

-- Author: Simon Ward (Greltok)
-- Documentation: http://wow.curseforge.com/projects/libversioncheck/pages/api/lib-version-check-1-0/
-- SVN: svn://svn.curseforge.net/wow/libversioncheck/mainline/trunk
-- Description: Library to broadcast and receive addon versions.
-- Dependancies: LibStub

--[[
Copyright (c) 2009 Simon Ward (Greltok)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
--]]

--[[
Sample usage:

local MY_ADDON_NAME = "MyAddon"
local MY_ADDON_VERSION = "Rev: 1234"

MyAddon = {}

local lvcLib = LibStub:GetLibrary( "LibVersionCheck-1.0" )

lvcLib:RegisterVersion( MY_ADDON_NAME, MY_ADDON_VERSION, MyAddon, "MyVersionCallback" )

local newestVersion = tonumber( strmatch( MY_ADDON_VERSION, "%d+" ) )

function MyAddon:MyVersionCallback( sender, identifier, version )
    if identifier == MY_ADDON_NAME and version then
        local thisVersion = tonumber( strmatch( version, "%d+" ) )
        if thisVersion > newestVersion then
            newestVersion = thisVersion
            DEFAULT_CHAT_FRAME:AddMessage( string.format( "%s has a newer version of %s. (%s)", sender, MY_ADDON_NAME, version ) )
        end
    end
end
--]]

local MAJOR_VERSION = "LibVersionCheck-1.0"
local MINOR_VERSION = 4

if not LibStub then error( MAJOR_VERSION .. " requires LibStub." ) end
local lib, oldMinor = LibStub:NewLibrary( MAJOR_VERSION, MINOR_VERSION )
if not lib then return end

lib.frame = lib.frame or CreateFrame( "Frame" )
local frame = lib.frame

lib.myVersions = lib.myVersions or {}

lib.groupComms = lib.groupComms or {}
lib.whisperComms = lib.whisperComms or {}

local commPrefix = "LibVersionCheck"
local commPriority = "BULK"

local playerName = UnitName( "player" )

local maxMessageLength = 255 - ( # commPrefix + 1 + 2 )

local function concatIterator( tbl, separator, maxLength )
	local index = 0
	local count = # tbl
	local separatorLength = separator and # separator or 0
	maxLength = maxLength or 0
	return function ()
		index = index + 1
		if index <= count then
			local length = 0
			local endIndex
			for i = index, count do
				local thisLength = # tbl[i]
				if endIndex then
					thisLength = thisLength + separatorLength
				end
				if ( length + thisLength ) <= maxLength then
					length = length + thisLength
					endIndex = i
				else
					break
				end
			end
			if endIndex then
				local startIndex = index
				index = endIndex
				return table.concat( tbl, separator, startIndex, endIndex )
			else
				return tbl[index]
			end
		end
	end
end

local function onEvent( this, event, ... )
    local handler = lib[event]
    if handler then
        handler( lib, ... )
    end
end

local function onUpdate( this, delta )
    local self = lib
    if self.ready then
        self:_FlushComms()
        frame:SetScript( "OnUpdate", nil )
        self.updating = nil
        if not next( self.myVersions ) then
            unregisterEvents()
        end
    end
end

local running
local function registerEvents()
    if not running then
        frame:SetScript( "OnEvent", onEvent )
        frame:RegisterEvent( "CHAT_MSG_ADDON" )
        frame:RegisterEvent( "PLAYER_ENTERING_WORLD" )
        frame:RegisterEvent( "PARTY_MEMBERS_CHANGED" )
        frame:RegisterEvent( "RAID_ROSTER_UPDATE" )
        frame:RegisterEvent( "PLAYER_GUILD_UPDATE" )
        running = true
    end
end

local function unregisterEvents()
    if running then
        frame:SetScript( "OnEvent", nil )
        frame:UnregisterAllEvents()
        running = nil
    end
end

local function encode( s )
    if string.find( s, "[ \\|%%]" ) then
        s = string.gsub( s, "([ \\|%%])", function( c ) return string.format( "%%%02X", string.byte( c ) ) end )
    end
    return s
end

local function decode( s )
    if string.find( s, "%%" ) then
        s = string.gsub( s, "%%(%x%x)", function( h ) return string.char( tonumber( h, 16 ) ) end )
    end
    return s
end

local queryArray = {}
local responseArray = {}
function lib:_SendComms( distribution, comms, name )
    for identifier, query in pairs( comms ) do
        local myVersionInfo = self.myVersions[identifier]
        if myVersionInfo then
            local theArray = query and queryArray or responseArray
            table.insert( theArray, myVersionInfo.encodedInfo )
        end
    end
    
    local CTL = ChatThrottleLib
    
    if CTL then
        for part in concatIterator( queryArray, " ", maxMessageLength ) do
            CTL:SendAddonMessage( commPriority, commPrefix, "Q " .. part, distribution, name )
        end
        for part in concatIterator( responseArray, " ", maxMessageLength ) do
            CTL:SendAddonMessage( commPriority, commPrefix, "R " .. part, distribution, name )
        end
    else
        for part in concatIterator( queryArray, " ", maxMessageLength ) do
            SendAddonMessage( "Q " .. part, distribution, name )
        end
        for part in concatIterator( responseArray, " ", maxMessageLength ) do
            SendAddonMessage( "R " .. part, distribution, name )
        end
    end
    
    wipe( queryArray )
    wipe( responseArray )
end

function lib:_FlushComms()
    for distribution, comms in pairs( self.groupComms ) do
        self:_SendComms( distribution, comms )
        self.groupComms[distribution] = nil
    end
    for name, comms in pairs( self.whisperComms ) do
        self:_SendComms( "WHISPER", comms, name )
        self.whisperComms[name] = nil
    end
end

function lib:_EnqueueSendVersion( identifier, query, distribution, name )
    local comms
    if distribution ~= "WHISPER" then
        comms = self.groupComms[distribution]
        if not comms then
            comms = {}
            self.groupComms[distribution] = comms
        end
    else
        comms = self.whisperComms[name]
        if not comms then
            comms = {}
            self.whisperComms[name] = comms
        end
    end
    
    local oldQuery = comms[identifier]
    if oldQuery == nil or ( query and not oldQuery ) then
        comms[identifier] = query and true or false
    end
    
    if not self.updating then
        self.updating = true
        frame:SetScript( "OnUpdate", onUpdate )
    end
end

function lib:_HandleVersion( identifier, name, version, myVersionInfo )
    local callbackFunction = myVersionInfo.callbackFunction
    if callbackFunction then
        local success, err
        local callbackTarget = myVersionInfo.callbackTarget
        if callbackTarget then
            success, err = pcall( callbackTarget[callbackFunction], callbackTarget, name, identifier, version )
        else
            success, err = pcall( callbackFunction, name, identifier, version )
        end
        if not success then
            geterrorhandler()( err )
       end
    end
end

function lib:_ReceiveVersion( encodedIdentifier, encodedVersion, query, distribution, sender )
    local identifier = decode( encodedIdentifier )
    
    local myVersionInfo = self.myVersions[identifier]
    if myVersionInfo then
        
        if query then
            if not string.find( sender, "-" ) then
                self:_EnqueueSendVersion( identifier, false, "WHISPER", sender )
            else
                self:_EnqueueSendVersion( identifier, false, distribution, sender )
            end
        end
        
        self:_HandleVersion( identifier, sender, decode( encodedVersion ), myVersionInfo )
    end
end

function lib:_QueryAllVersions( distribution, name )
    for identifier in pairs( self.myVersions ) do
        self:_EnqueueSendVersion( identifier, true, distribution, name )
    end
end

function lib:_UpdateGroupStatus()

 --GetNumGroupMembers() 
    if IsInRaid() then
        self.party = nil
        local instanceType = select( 2, IsInInstance() )
        if instanceType == "pvp" or instanceType == "arena" then
            self.raid = nil
            if not self.bg then
                self.bg = true
                self:_QueryAllVersions( "BATTLEGROUND" )
            end
        else
            self.bg = nil
            if not self.raid then
                self.raid = true
                self:_QueryAllVersions( "RAID" )
            end
        end
    else
        self.raid = nil
        self.bg = nil
        if  GetNumGroupMembers() > 0 then
            if not self.party then
                self.party = true
                self:_QueryAllVersions( "PARTY" )
            end
        else
            self.party = nil
        end
    end
end

function lib:_UpdateGuildStatus()
    if IsInGuild() then
        if not self.guild then
            self.guild = true
            self:_QueryAllVersions( "GUILD" )
        end
    else
        self.guild = nil
    end
end

---	Registers an addon and version with the library.
-- The version notification callback will be invoked whenever version info is received.
-- The callback will not be invoked for local versions.
-- The callback will be invoked with these parameters:
-- * sender (string)
-- * identifier (string)
-- * version (string or nil)
-- @param identifier (string) identifier of the addon being registered (max length 50)
-- @param version (string) version of the addon being registered (max length 50)
-- @param callback1 (function or table or nil) callback for version notifications
-- @param callback2 (string or unused) callback method name (used if table parameter above)
function lib:RegisterVersion( identifier, version, callback1, callback2 )
    assert( type( identifier ) == "string", "bad parameter 'identifier' (string expected)" )
    local identifierLength = # identifier
    assert( identifierLength > 0, "bad parameter 'identifier' (empty string)" )
    assert( identifierLength <= 50, "bad parameter 'identifier' (string too long)" )
    assert( type( version ) == "string", "bad parameter 'version' (string expected)" )
    local versionLength = # version
    assert( versionLength > 0, "bad parameter 'version' (empty string)" )
    assert( versionLength <= 50, "bad parameter 'version' (string too long)" )
    
    local encodedInfo = string.format( "%s %s", encode( identifier ), encode( version ) )
    local myVersionInfo = { encodedInfo = encodedInfo }
    
    local callback1Type = type( callback1 )
    if callback1Type == "table" then
        assert( type( callback2 ) == "string", "bad parameter 'callback2' (string expected)" )
        myVersionInfo.callbackTarget = callback1
        myVersionInfo.callbackFunction = callback2
    else
        assert( callback1Type == "function" or callback1Type == "nil", "bad parameter 'callback1' (function or nil expected)" )
        myVersionInfo.callbackFunction = callback1
    end
    
    self.myVersions[identifier] = myVersionInfo
    
    registerEvents()
    
    if self.party then self:_EnqueueSendVersion( identifier, true, "PARTY" ) end
    if self.bg then self:_EnqueueSendVersion( identifier, true, "BATTLEGROUND" ) end
    if self.raid then self:_EnqueueSendVersion( identifier, true, "RAID" ) end
    if self.guild then self:_EnqueueSendVersion( identifier, true, "GUILD" ) end
end

--- Unregisters an addon from the library.
-- @param identifier (string) identifier of the addon being unregistered
function lib:UnregisterVersion( identifier )
    assert( type( identifier ) == "string", "bad parameter 'identifier' (string expected)" )
    assert( self.myVersions[identifier], "bad parameter 'identifier' (unregistered identifier)" )
    
    self.myVersions[identifier] = nil
    
    for _, comms in pairs( self.groupComms ) do
        comms[identifier] = nil
    end
    
    for _, comms in pairs( self.whisperComms ) do
        comms[identifier] = nil
    end
end

---	Sends a version query over the addon channel.
-- @param identifier (string) identifier of the addon
-- @param distribution (string) - distribution for the query
-- @param target (string or nil) - target for the query (used only for "WHISPER" distribution)
function lib:SendVersionQuery( identifier, distribution, target )
    assert( type( identifier ) == "string", "bad parameter 'identifier' (string expected)" )
    assert( type( distribution ) == "string", "bad parameter 'distribution' (string expected)" )
    local targetType = type( target )
    assert( targetType == "string" or targetType == "nil", "bad parameter 'target' (string or nil expected)" )
    assert( self.myVersions[identifier], "bad parameter 'identifier' (unregistered identifier)" )
    self:_EnqueueSendVersion( identifier, true, distribution, target )
end

function lib:CHAT_MSG_ADDON( prefix, message, distribution, sender )
    if prefix == commPrefix and sender ~= playerName then
        local _, _, queryChar, remaining = string.find( message, "^([QR])%s(.+)$" )
        local query = ( queryChar == "Q" )
        for encodedIdentifier, encodedVersion in string.gmatch( remaining, "(%S+)%s(%S+)" ) do
            self:_ReceiveVersion( encodedIdentifier, encodedVersion, query, distribution, sender )
        end
    end
end

function lib:PLAYER_ENTERING_WORLD()
    self.ready = true
    self.bg = nil
    self:_UpdateGroupStatus()
    self:_UpdateGuildStatus()
end

function lib:PARTY_MEMBERS_CHANGED()
    self:_UpdateGroupStatus()
end

function lib:RAID_ROSTER_UPDATE()
    self:_UpdateGroupStatus()
end

function lib:PLAYER_GUILD_UPDATE()
    self:_UpdateGuildStatus()
end

frame:SetScript( "OnUpdate", nil )
frame:SetScript( "OnEvent", nil )
frame:UnregisterAllEvents()

if next( lib.myVersions ) then registerEvents() end
if lib.updating then frame:SetScript( "OnUpdate", onUpdate ) end
