--[[    AutoQuest 2 by Ghettogreen (Ghettowned - Garona (Alliance, US))    Report Bugs and Errors: http://wow.curseforge.com/addons/autoquest/create-ticket/]]AutoQuest2 = LibStub("AceAddon-3.0"):NewAddon("AutoQuest 2", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0", "GhettoLibs-1.0");AutoQuest2:SetDefaultModuleState(false)AutoQuest2.name = "AutoQuest 2"; AutoQuest2.nickname = "AutoQuest2"AutoQuest2.quests = AutoQuest2:NewModule("Quests", "AceEvent-3.0", "AceTimer-3.0")AutoQuest2.tracking = AutoQuest2:NewModule("Tracking", "AceEvent-3.0")AutoQuest2.L=LxxfarmValues = {        [1] = "Threaten",        [2] = "Pay",}print(xxfarmValues[1])print(xxfarmValues[2])local core = AutoQuest2core.Paranoia=0----------------------------------------------------------------------------------------------------- Initialize -----------------------------------------------------------------------------------------------------function core:OnInitialize()    --core:RegisterVersionCheck(self)	core:SetupOptions(self)	self:SetEnabledState(self.db.profile.enabled)endfunction core:OnEnable()    self.db.profile.enabled = true;    self:ToggleAllModules()	core:InitializeTracking()    HideUIPanel(GossipFrame)    HideUIPanel(QuestFrame)endfunction core:OnDisable()    self.db.profile.enabled = false;    self:DisableAllModules(self)    HideUIPanel(GossipFrame)    HideUIPanel(QuestFrame)end----------------------------------------------------------------------------------------------------- Core Functions -----------------------------------------------------------------------------------------------------function core:ToggleAllModules()    self:ToggleModule("Quests", true)    self:ToggleModule("Tracking", self.db.profile.tracking_trivial)endfunction core:ToggleModule(module, value)    if ( value == true ) then        self:EnableModule(module)    else        self:DisableModule(module)    endendfunction core:RefreshConfig()    self:ToggleEnabled(self, core.db.profile.enabled)    if ( core.currentProfile ~= core.db:GetCurrentProfile() ) then        core:UpdateOptions(self)        core:ResetTracking()    end    local displayedPanel = InterfaceOptionsFramePanelContainer.displayedPanel    if ( not InterfaceOptionsFrame:IsShown() ) then        return;    elseif ( displayedPanel.parent == "AutoQuest 2" ) then        --[[if ( displayedPanel.name == "Profiles" ) then 12/07/10            return;        end]]    elseif ( not displayedPanel.name == "AutoQuest 2" ) then        return;    end    InterfaceOptionsFrame_OpenToCategory(displayedPanel)endfunction core:ResetConfig()    core.db:ResetProfile()    core:RefreshConfig()endfunction core:WelcomeMessage()    print(format("|cFFFFFF00AutoQuest 2 |r(Version %s)", GetAddOnMetadata("AutoQuest 2", "Version")))    if ( self:IsEnabled() ) then        print("|cFFFFFF00Current Status: |rEnabled")        core:VerboseStatus(self, "|cFFFFFF00Accept Available Quests: |r%s", "accept")        core:VerboseStatus(self, "|cFFFFFF00Turn In Completed Quests: |r%s", "complete")    else        print("|cFFFFFF00Current Status: |rDisabled")        print("Type '/autoquest2' to Enable and change options.")    end    self:UnregisterBucket(self.bucket)end----------------------------------------------------------------------------------------------------- Options -----------------------------------------------------------------------------------------------------local IsDisabled = function()    return not core:IsEnabled()endlocal IsOverride = function()    return not core.db.profile.overrideendlocal get = function(info)    return info.arg and core.db.profile[info.arg] or core.db.profile[info[#info]]endlocal set = function(info, value)    local key = info.arg or info[#info]    core.db.profile[key] = valueendcore.defaults = {    global = {        tracking = nil    },    profile = {        enabled = true,        autoExpand = true,        accept = true,        complete = true,        push = false,        trivial = false,        repeatable = false,        shared = false,        daily = true,        modifier_accept = 1, --Shift        modifier_complete = 1, --Shift        modifier_trivial = 2, --Ctrl        modifier_daily = 3, --Alt        modifier_repeatable = 3, --Alt        feedback_detail = true,        feedback_detailType = 1, --GUI		MoneyMaters = {			Process = true,			Response = "Threaten"		},		feedback_include_reward = true,		        tracking_trivial = true,        questBags = {            ["*"] = 1,            enabled = false,        },    },}core.optionValues = {    ["modifier"] = {        [1] = "shift",        [2] = "ctrl",        [3] = "alt",        [4] = "none",    },}core.oldOptions = {    ["acceptMod"] = {        ["newKey"] = "modifier_accept",        ["newVal"] = {["shift"] = 1,["ctrl"] = 2,["alt"] = 3,["none"] = 4},    },    ["completeMod"] = {        ["newKey"] = "modifier_complete",        ["newVal"] = {["shift"] = 1,["ctrl"] = 2,["alt"] = 3,["none"] = 4},    },    ["trivialMod"] = {        ["newKey"] = "modifier_trivial",        ["newVal"] = {["shift"] = 1,["ctrl"] = 2,["alt"] = 3,["none"] = 4},    },    ["repeatableMod"] = {        ["newKey"] = "modifier_repeatable",        ["newVal"] = {["shift"] = 1,["ctrl"] = 2,["alt"] = 3,["none"] = 4},    },    ["feedback_detailType"] = {        ["newVal"] = {["Quest Detail Panel"] = 1,["Chat Frame Text"] = 2},    },}core.options = core:newT();core.options["AutoQuest 2"] = {    type = "group",    name = "General",    args = {        enabled = {            order = 0,            name = "Enabled",            type = "toggle",            width = "half",            get = get,            set = function(info, value) core:ToggleEnabled(core, value) end,        },        autoExpand = {            order = 2,            name = "Expand Submenu",            desc = "Automaticaly Expand and Collapse the Options Submenu",            type = "toggle",            get = get,            set = function(info, value)                core.db.profile.autoExpand = value;                local buttons = InterfaceOptionsFrameAddOns.buttons                local selection = InterfaceOptionsFrameAddOns.selection                local i = 1                while i <= #buttons do                    if not buttons[i].element then return; end                    if ( buttons[i].element.name == "AutoQuest 2" ) then                        if not selection then return; end                        if ( value == true and not buttons[i].element.collapsed ) then                            return;                        elseif ( value == false and buttons[i].element.collapsed ) then                            return;                        end                        OptionsListButtonToggle_OnClick( _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"] )                    end                    i = i + 1;                end            end,        },    }}core.options["Display"] = {    type = "group",    name = "Display",    args = {        feedback = {            order = 10,            name = "Quest Feedback",            type = "group",            disabled = IsDisabled,            guiInline = true,            args = {                feedback_detail = {                    order = 1,                    name = "Show Quest Detail",                    desc = "Display Quest Detail Information when Accepting Quests",                    type = "toggle",                    width = "full",                    get = get,                    set = set,                },                feedback_detailType = {                    order = 2,                    name = "Quest Detail",                    desc = "Displays the Quest Detail Panel when Accepting Quests.",                    type = "select",                    disabled = function () return not core.db.profile.feedback_detail or not core.db.profile.enabled; end,                    values = {                        "Quest Detail Panel",                        "Chat Frame Text",                    },                    get = get,                    set = set,                },				feedback_include_reward = {					order = 3,					name = "Show Quest Rewards",					desc = "Include Quest Rewards in the Chat Frame Text when Accepting Quests.",					type = "toggle",					hidden = function () return (core.db.profile.feedback_detailType ~= 2) end,					width = "full",					get = get,					set = set,				},            }        },    }}core.farmValues = {        [1] = "Threaten",        [2] = "Pay",}core.options["Farm"] = {    type = "group",    name = "Farm",    args = {        MoneyMaters = {            order = 10,            name = "MoneyMaters",            type = "group",            disabled = IsDisabled,            guiInline = true,            args = {                MoneyMaters_Process = {                    order = 1,                    name = "Process  first dialog of  Money Matters",                    desc = "Either Process or wait for User",                    type = "toggle",                    width = "full",                    get = function () return core.db.profile.MoneyMaters.Process; end,                    set = function (info, value) core.db.profile.MoneyMaters.Process = value; end,                },                MoneyMaters_Response = {                    order = 2,                    name = "Response if second Dialogue",                    desc = "Threaten or Pay",                    type = "select",                    disabled = function () return not core.db.profile.MoneyMaters.Process or not core.db.profile.enabled; end,                    values = {                        "Threaten",                        "Pay",                    },                    get = function () print("get",core.db.profile.MoneyMaters.Response);return core.db.profile.MoneyMaters.Response; end,                    set = function (info, value) print("set",value,core.db.profile.MoneyMaters.Response);core.db.profile.MoneyMaters.Response = value  ; end,                },            }        },    }}----------------------------------------------------------------------------------------------------- Chat Commands -----------------------------------------------------------------------------------------------------core.slashCom = {    "autoquest2",    "autoquest",    "aq2",    "aq",}core.optFunc = function(input)    local input = strupper(input)    if not input or input:trim() == "" then        InterfaceOptionsFrame_OpenToCategory("AutoQuest 2")        return;    elseif ( input == "SUPER" ) then		core.Paranoia=10    elseif ( input == "QUIET" ) then		core.Paranoia=0    elseif ( input == "NOISY" ) then		core.Paranoia=3    elseif ( input == "DEBUG" ) then		core.Paranoia=1    elseif ( input == "ENABLE" ) then        core:Print(core, "AutoQuest 2 is now Enabled")        core:Enable()    elseif ( input == "DISABLE" ) then        core:Print(core, "AutoQuest 2 is now Disabled")        core:Disable()    elseif ( not core.db.profile.enabled ) then        core:Print(core, "AutoQuest 2 is currently Disabled. Please Enable to change options.")        return;    elseif ( input == "ACCEPT" or input == "AVAILABLE" ) then        --12/11/09 Bug Fix: core.db.profile.accept = (not accept changed to core.db.profile.accept)        core.db.profile.accept = not core.db.profile.accept        core:Verbose(core, "Available Quests will %s be Automatically Accepted.", "accept")    elseif ( input == "TURNIN" or input == "COMPLETE" ) then        core.db.profile.complete = not core.db.profile.complete        core:Verbose(core, "Completed Quests will %s be Automatically Turned In.", "complete")    elseif ( input == "TRIVIAL" ) then        core.db.profile.trivial = not core.db.profile.trivial        core:Verbose(core, "Trivial Quests will %s be Accepted.", "trivial")        if ( core.db.profile.tracking_trivial ) then            core:ToggleTrivialTracking(core.db.profile.trivial)        end    elseif ( input == "REPEATABLE" ) then        core.db.profile.repeatable = not core.db.profile.repeatable        core:Verbose(core, "Repeatable Quests will %s be Turned In.", "repeatable")    elseif ( input == "DAILY" ) then        core.db.profile.daily = not core.db.profile.daily        core:Verbose(core, "Daily Quests will %s be Turned In.", "daily")    elseif ( input == "HELP" or input == "COMMANDS" or input == "ARGUMENTS" ) then        core:Print(core, "Commands: '/autoquest2' '/autoquest' '/aq2' '/aq'")        core:Print(core, "'/aq Enable' Enables the addon. Type '/aq' to show configuraton.")        core:Print(core, "'/aq Disable' Disables the entire addon, Including override keys.")        core:Print(core, "'/aq Accept' toggles automatic accepting for quests.")        core:Print(core, "'/aq Complete' toggles automatic turning in quests.")        core:Print(core, "'/aq Trivial' toggles filtering low level quests.")        core:Print(core, "'/aq Repeatable' toggles filtering repeatable quests.")        core:Print(core, "'/aq Daily' toggles filtering daily quests.")    else        core:Print(core, "Type '/autoquest2 help' for a list of commands.")        return;    end    core:RefreshConfig(core)end