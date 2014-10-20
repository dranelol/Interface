local addonName, vars = ...
local addon = RaidBuffStatus
local L = vars.L
RBS_svnrev["Config.lua"] = select(3,string.find("$Revision: 677 $", ".* (.*) .*"))

local profile
function addon:UpdateProfileConfig()
        profile = addon.db.profile
end

local buttonoptions = {
	enabledisable = L["Enable/disable buff check"],
	report = L["Report missing to raid"],
	whisper = L["Whisper buffers"],
	buff = L["Buff those missing buff"],
	none = L["None"],
}

local options = { 
	type='group',
    	set = function(info,val)
            local s = profile -- ; for i = 2,#info-1 do s = s[info[i]] end
            s[info[#info]] = val; addon:Debug(info[#info].." set to: "..tostring(val))
        end,
    	get = function(info)
            local s = profile -- ; for i = 2,#info-1 do s = s[info[i]] end
            return s[info[#info]]
        end,
	args = {
		config = {
			type = 'execute',
			name = L["Show configuration options"],
			desc = L["Show configuration options"],
			func = function()
				addon:OpenBlizzAddonOptions()
			end,
			guiHidden = true,
		},
		show = {
			type = 'execute',
			name = L["Show the buff report dashboard."],
			desc = L["Show the buff report dashboard."],
			func = function()
				addon:DoReport()
				addon:ShowReportFrame()
			end,
			guiHidden = true,
		},
		hide = {
			type = 'execute',
			name = L["Hide the buff report dashboard."],
			desc = L["Hide the buff report dashboard."],
			func = function()
				addon:HideReportFrame()
			end,
			guiHidden = true,
		},
		toggle = {
			type = 'execute',
			name = L["Hide and show the buff report dashboard."],
			desc = L["Hide and show the buff report dashboard."],
			func = function()
				if addon.frame then
					if addon.frame:IsVisible() then
						addon:HideReportFrame()
					else
						addon:DoReport()
						addon:ShowReportFrame()
					end
				end
			end,
			guiHidden = true,
		},
		report = {
			type = 'execute',
			name = 'report',
			desc = L["Report to /raid or /party who is not buffed to the max."],
			func = function()
				addon:DoReport()
				addon:ReportToChat(true)
			end,
			guiHidden = true,
		},
		debug = {
			type = 'execute',
			name = 'debug',
			desc = 'Toggles debug messages.',
			func = function()
				profile.Debug = not profile.Debug
			end,
			guiHidden = true,
			cmdHidden = true,
		},
		f = {
			type = 'execute',
			name = 'f',
			desc = 'Testin stuff',
			func = function()
				addon:SendAddonMessage("oRA3", addon:Serialize("Inventory", "Healthstone"))
			end,
			guiHidden = true,
			cmdHidden = true,
		},
		taunt = {
			type = 'execute',
			name = 'taunt',
			desc = 'Refreshes tank list.',
			func = function()
				addon:oRA_MainTankUpdate()
			end,
			guiHidden = true,
			cmdHidden = true,
		},
		versions = {
			type = 'execute',
			name = 'versions',
			desc = 'Lists known RBS versions which other people and I have.',
			func = function()
				addon:Print("Me:" .. addon.version .. " build-" .. addon.revision)
				for name, version in pairs(addon.rbsversions) do
					addon:Print(name .. ":" .. version)
				end
			end,
			guiHidden = true,
			cmdHidden = false,
		},
		buffwizard = {
			type = 'group',
			name = L["Buff Wizard"],
			desc = L["Automatically configures the dashboard buffs and configuration defaults for your class or raid leading role"],
			order = 1,
			args = {
				intro = {
					type = 'description',
					name = L["The Buff Wizard automatically configures the dashboard buffs and configuration defaults for your class or raid leading role."] .. "\n",
					order = 1,
				},
				raidleader = {
					type = 'execute',
					name = L["Raid leader"],
					desc = L["This is the default configuration in which RBS ships out-of-the-box.  It gives you pretty much anything a raid leader would need to see on the dashboard"],
					order = 2,
					func = function(info, v)
						addon:SetAllOptions("raidleader")
					end,
				},
				coreraidbuffs = {
					type = 'execute',
					name = L["Core raid buffs"],
					desc = L["Only show the core class raid buffs"],
					order = 3,
					func = function(info, v)
						addon:SetAllOptions("coreraidbuffs")
					end,
				},
				justmybuffs = {
					type = 'execute',
					name = L["Just my buffs"],
					desc = L["Only show the buffs for which your class is responsible for.  This configuration can be used like a buff-bot where one simply right clicks on the buffs to cast them"],
					order = 4,
					func = function(info, v)
						addon:SetAllOptions("justmybuffs")
					end,
				},
			},
		},
		consumables = {
			type = 'group',
			name = L["Consumable options"],
			desc = L["Options for setting the quality requirements of consumables"],
			order = 2,
			args = {
				oldflaskselixirs = {
					type = 'toggle',
					name = L["Old flasks and elixirs"],
					desc = L["Allow raiders to use flasks and elixirs from last expansion"],
					order = 1,
					width = "double",
					get = function(info) return profile.OldFlasksElixirs end,
					set = function(info, v)
						profile.OldFlasksElixirs = v
					end,
				},
				foodlevel = {
					type = 'range',
					order = 2,
					name = L["Required food quality"],
					desc = L["Select which level of food quality you require for the raiders to be considered 'Well Fed'"],
					min = 0,
					max = 300,
					step = 1,
					bigStep = 25,
					get = function(info) return profile.foodlevel end,
					set = function(info, v)
						profile.foodlevel = v
					end,
				},
				ignoreeating = {
					type = 'toggle',
					name = L["Treat eating as Well Fed"],
					desc = L["Treat players who are currently eating as Well Fed. This assumes they are eating acceptable food."],
					order = 2.5,
					width = "double",
					get = function(info) return profile.ignoreeating end,
					set = function(info, v)
						profile.ignoreeating = v
					end,
				},
				feasttt = {
					type = 'toggle',
					name = L["Augment Banquet Tooltips"],
					desc = L["Augment Banquet Tooltips with stat bonus information"],
					order = 3,
					width = "double",
					get = function(info) return profile.FeastTT end,
					set = function(info, v)
						profile.FeastTT = v
					end,
				},
			},
		},
		reporting = {
			type = 'group',
			name = L["Reporting"],
			desc = L["Reporting options"],
			order = 3,
			args = {
				reportchat = {
					type = 'toggle',
					name = L["Report to raid/party"],
					desc = L["Report to raid/party - requires raid assistant"],
					order = 1,
					get = function(info) return profile.ReportChat end,
					set = function(info, v)
						profile.ReportChat = v
					end,
				},
				reportself = {
					type = 'toggle',
					name = L["Report to self"],
					desc = L["Report to self"],
					order = 2,
					get = function(info) return profile.ReportSelf end,
					set = function(info, v)
						profile.ReportSelf = v
					end,
				},
				reportofficer = {
					type = 'toggle',
					name = L["Report to officers"],
					desc = L["Report to officer channel"],
					order = 3,
					get = function(info) return profile.ReportOfficer end,
					set = function(info, v)
						profile.ReportOfficer = v
					end,
				},
				ignorelastthreegroups = {
					type = 'toggle',
					name = L["Ignore groups 6 to 8"],
					desc = L["Ignore groups 6 to 8 when reporting as these are for subs"],
					order = 4,
					get = function(info) return profile.IgnoreLastThreeGroups end,
					set = function(info, v)
						profile.IgnoreLastThreeGroups = v
					end,
				},
				showmany = {
					type = 'toggle',
					name = L["When many say so"],
					desc = L["When at least N people are missing a raid buff say MANY instead of spamming a list"],
					order = 7,
					get = function(info) return profile.ShowMany end,
					set = function(info, v)
						profile.ShowMany = v
					end,
				},
				whispermany = {
					type = 'toggle',
					name = L["Whisper many"],
					desc = L["When whispering and at least N people are missing a raid buff say MANY instead of spamming a list"],
					order = 8,
					get = function(info) return profile.WhisperMany end,
					set = function(info, v)
						profile.WhisperMany = v
					end,
				},
				howmany = {
					type = 'range',
					name = L["How MANY?"],
					desc = L['Set N - the number of people missing a buff considered to be "MANY"'],
					order = 9,
					min = 1,
					max = 25,
					step = 1,
					bigStep = 1,
					get = function(info) return profile.HowMany end,
					set = function(info, v)
						profile.HowMany = v
					end,
				},
				howoften = {
					type = 'range',
					name = L["Seconds between updates"],
					desc = L["Set how many seconds between dashboard raid scan updates"],
					order = 10,
					min = 1,
					max = 60,
					step = 1,
					bigStep = 5,
					get = function(info) return profile.HowOften end,
					set = function(info, v)
						profile.HowOften = v
						if addon.timer then
							addon:CancelTimer(addon.timer)
							addon.timer = addon:ScheduleRepeatingTimer(addon.DoReport, profile.HowOften)
						end
					end,
				},
				whisperonlyone = {
					type = 'toggle',
					name = L["Whisper only one"],
					desc = L["When there are multiple people who can provide a missing buff such as Fortitude then only whisper one of them at random who is in range rather than all of them"],
					order = 12,
					get = function(info) return profile.whisperonlyone end,
					set = function(info, v)
						profile.whisperonlyone = v
					end,
				},
				abouttorunout = {
					type = 'range',
					name = L["Min remaining buff duration"],
					desc = L["Minimum remaining buff duration in minutes. Buffs with less than this will be considered as missing.  This option only takes affect when the corresponding 'buff' button is enabled on the dashboard."],
					order = 13,
					min = 0,
					max = 10,
					step = 1,
					bigStep = 1,
					get = function(info) return profile.abouttorunout end,
					set = function(info, v)
						profile.abouttorunout = v
					end,
				},
				preferstaticbuff = {
					type = 'toggle',
					name = L["Prefer Static Buff"],
					desc = L["Report missing static buffs even when an equivalent passive aura is already present."],
					order = 14,
					get = function(info) return profile.preferstaticbuff end,
					set = function(info, v)
						profile.preferstaticbuff = v
					end,
				},
-- The aliens stole my brain before I could write the code for this feature.
--				shortennames = {
--					type = 'toggle',
--					name = L["Shorten names"],
--					desc = L["Shorten names in the report to reduce channel spam"],
--					get = function(info) return profile.ShortenNames end,
--					set = function(info, v)
--						profile.ShortenNames = v
--					end,
--				},
			},
		},
		
		appearance = {
			type = 'group',
			name = L["Appearance"],
			desc = L["Skin and minimap options"],
			order = 6,
			args = {
				statusbars = {
					type = 'group',
					name = L["Raid Status Bars"],
					desc = L["Status bars to show raid, dps, tank health, mana, etc"],
					order = 1.5,
					args = {
						statusbarpositioning = {
							type = 'select',
							order = 0,
							name = L["Bar positioning"],
							desc = L["Choose where on the dashboard the bars appear"],
							values = {
								["top"] = L["Top"],
								["onedown"] = L["One group down"],
								["twodown"] = L["Two groups down"],
								["bottom"] = L["Bottom"],
							},
							get = function(info) return profile.statusbarpositioning end,
							set = function(info, v)
								profile.statusbarpositioning = v
								addon:AddBuffButtons()
							end,
						},
						raidhealth = {
							type = 'toggle',
							name = L["Raid health"],
							desc = L["The average party/raid health percent"],
							get = function(info) return profile.RaidHealth end,
							set = function(info, v)
								profile.RaidHealth = v
								addon:AddBuffButtons()
							end,
							order = 1,
						},
						tankhealth = {
							type = 'toggle',
							name = L["Tank health"],
							desc = L["The average tank health percent"],
							get = function(info) return profile.TankHealth end,
							set = function(info, v)
								profile.TankHealth = v
								addon:AddBuffButtons()
							end,
							order = 2,
						},
						raidmana = {
							type = 'toggle',
							name = L["Raid mana"],
							desc = L["The average party/raid mana percent"],
							get = function(info) return profile.RaidMana end,
							set = function(info, v)
								profile.RaidMana = v
								addon:AddBuffButtons()
							end,
							order = 3,
						},
						healermana = {
							type = 'toggle',
							name = L["Healer mana"],
							desc = L["The average healer mana percent"],
							get = function(info) return profile.HealerMana end,
							set = function(info, v)
								profile.HealerMana = v
								addon:AddBuffButtons()
							end,
							order = 4,
						},
						healerdrinkingsound = {
							type = 'toggle',
							name = L["Healer drinking sound"],
							desc = L["Play a sound when a healer drinks and is not full on mana"],
							get = function(info) return profile.healerdrinkingsound end,
							set = function(info, v)
								profile.healerdrinkingsound = v
							end,
							order = 5,
						},
						dpsmana = {
							type = 'toggle',
							name = L["DPS mana"],
							desc = L["The average DPS mana percent"],
							get = function(info) return profile.DPSMana end,
							set = function(info, v)
								profile.DPSMana = v
								addon:AddBuffButtons()
							end,
							order = 6,
						},
						alive = {
							type = 'toggle',
							name = L["Alive"],
							desc = L["The percentage of people alive in the raid"],
							get = function(info) return profile.Alive end,
							set = function(info, v)
								profile.Alive = v
								addon:AddBuffButtons()
							end,
							order = 7,
						},
						dead = {
							type = 'toggle',
							name = L["Dead"],
							desc = L["The percentage of people dead in the raid"],
							get = function(info) return profile.Dead end,
							set = function(info, v)
								profile.Dead = v
								addon:AddBuffButtons()
							end,
							order = 8,
						},
						tanksalive = {
							type = 'toggle',
							name = L["Tanks alive"],
							desc = L["The percentage of tanks alive in the raid"],
							get = function(info) return profile.TanksAlive end,
							set = function(info, v)
								profile.TanksAlive = v
								addon:AddBuffButtons()
							end,
							order = 9,
						},
						healersalive = {
							type = 'toggle',
							name = L["Healers alive"],
							desc = L["The percentage of healers alive in the raid"],
							get = function(info) return profile.HealersAlive end,
							set = function(info, v)
								profile.HealersAlive = v
								addon:AddBuffButtons()
							end,
							order = 10,
						},
						range = {
							type = 'toggle',
							name = L["In range"],
							desc = L["The percentage of people within 40 yards range"],
							get = function(info) return profile.Range end,
							set = function(info, v)
								profile.Range = v
								addon:AddBuffButtons()
							end,
							order = 11,
						},
					},
				},
				minimap = {
					type = 'group',
					name = L["Minimap icon"],
					order = 4,
					args = {
						minimap = {
							type = 'toggle',
							name = L["Minimap icon"],
							desc = L["Toggle to display a minimap icon"],
							order = 1,
							get = function(info) return profile.MiniMap end,
							set = function(info, v)
								profile.MiniMap = v
								addon:UpdateMiniMapButton()
							end,
						},
					},
				},
				skin = {
					type = 'group',
					name = L["Skin and scaling"],
					order = 2,
					args = {
						backgroundcolour = {
							type = 'color',
							name = L["Background colour"],
							desc = L["Background colour"],
							order = 1,
							hasAlpha = true,
							get = function(info)
								local r = profile.bgr
								local g = profile.bgg
								local b = profile.bgb
								local a = profile.bga
								return r, g, b, a
							end,
							set = function(info, r, g, b, a)
								profile.bgr = r
								profile.bgg = g
								profile.bgb = b
								profile.bga = a
								addon:SetFrameColours()
							end,
						},
						bordercolour = {
							type = 'color',
							name = L["Border colour"],
							desc = L["Border colour"],
							order = 2,
							hasAlpha = true,
							get = function(info)
								local r = profile.bbr
								local g = profile.bbg
								local b = profile.bbb
								local a = profile.bba
								return r, g, b, a
							end,
							set = function(info, r, g, b, a)
								profile.bbr = r
								profile.bbg = g
								profile.bbb = b
								profile.bba = a
								addon:SetFrameColours()
							end,
						},
						dashboardcolumns = {
							type = 'range',
							name = L["Dashboard columns"],
							desc = L["Number of columns to display on the dashboard"],
							order = 3,
							min = 6,
							max = 25,
							step = 1,
							bigStep = 1,
							get = function() return profile.dashcols end,
							set = function(info, v)
								profile.dashcols = v
								addon:AddBuffButtons()
							end,
						},
						dashboardscale = {
							type = 'range',
							name = L["Dashboard scale"],
							desc = L["Scale the dashboard window"],
							order = 4,
							min = 0.1,
							max = 5,
							step = 0.1,
							bigStep = 0.1,
							isPercent = true,
							get = function() return profile.dashscale end,
							set = function(info, v)
								local old = addon.frame:GetScale()
								local top = addon.frame:GetTop()
								local left = addon.frame:GetLeft()
								addon.frame:ClearAllPoints()
								addon.frame:SetScale(v)
								left = left * old / v
								top = top * old / v
								addon.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
								addon:SaveFramePosition()
								profile.dashscale = v
							end,
						},
						hidebossrtrash = {
							type = 'toggle',
							name = L["Hide Boss R Trash"],
							desc = L["Always hide the Boss R Trash buttons"],
							order = 5,
							get = function(info) return profile.hidebossrtrash end,
							set = function(info, v)
								profile.hidebossrtrash = v
								addon:AddBuffButtons()
							end,
						},
						highlightmybuffs = {
							type = 'toggle',
							name = L["Highlight my buffs"],
							desc = L["Hightlight currently missing buffs on the dashboard for which you are responsible including self buffs and buffs which you are missing that are provided by someone else. I.e. show buffs for which you must take action"],
							order = 6,
							get = function(info) return profile.HighlightMyBuffs end,
							set = function(info, v)
								profile.HighlightMyBuffs = v
							end,
						},
						optionsscale = {
							type = 'range',
							name = L["Buff Options scale"],
							desc = L["Scale the Buff Options window"],
							order = 7,
							min = 0.1,
							max = 5,
							step = 0.1,
							bigStep = 0.1,
							isPercent = true,
							get = function() return profile.optionsscale end,
							set = function(info, v)
								local old = addon.optionsframe:GetScale()
								local top = addon.optionsframe:GetTop()
								local left = addon.optionsframe:GetLeft()
								addon.optionsframe:ClearAllPoints()
								addon.optionsframe:SetScale(v)
								left = left * old / v
								top = top * old / v
								addon.optionsframe:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
								profile.optionsscale = v
							end,
						},
						tooltipnamecolor = {
							type = 'toggle',
							name = L["Tooltip name coloring"],
							order = 8,
							get = function(info) return profile.TooltipNameColor end,
							set = function(info, v)
								profile.TooltipNameColor = v
							end,
						},
						tooltiproleicons = {
							type = 'toggle',
							name = L["Tooltip role icons"],
							order = 9,
							get = function(info) return profile.TooltipRoleIcons end,
							set = function(info, v)
								profile.TooltipRoleIcons = v
							end,
						},
					},
				},
				automation = {
					type = 'group',
					name = L["Automation"],
					desc = L["Options for automatically opening the dashboard and moving it"],
					order = 3,
					args = {
						autoshowdashraid = {
							type = 'toggle',
							name = L["Show in raid"],
							desc = L["Automatically show the dashboard when you join a raid"],
							order = 1,
							get = function(info) return profile.AutoShowDashRaid end,
							set = function(info, v)
								profile.AutoShowDashRaid = v
							end,
						},
						autoshowdashparty = {
							type = 'toggle',
							name = L["Show in party"],
							desc = L["Automatically show the dashboard when you join a party"],
							order = 2,
							get = function(info) return profile.AutoShowDashParty end,
							set = function(info, v)
								profile.AutoShowDashParty = v
							end,
						},
						autoshowdashbattle = {
							type = 'toggle',
							name = L["Show in battleground"],
							desc = L["Automatically show the dashboard when you join a battleground"],
							order = 3,
							get = function(info) return profile.AutoShowDashBattle end,
							set = function(info, v)
								profile.AutoShowDashBattle = v
							end,
						},
						hideincombat = {
							type = 'toggle',
							name = L["Hide in combat"],
							desc = L["Hide dashboard during combat"],
							order = 4,
							get = function(info) return profile.HideInCombat end,
							set = function(info, v)
								profile.HideInCombat = v
							end,
						},
						disableincombat = {
							type = 'toggle',
							name = L["Disable scan in combat"],
							desc = L["Skip buff checking during combat. You can manually initiate a scan by pressing Scan on the dashboard"],
							order = 5,
							get = function(info) return profile.DisableInCombat end,
							set = function(info, v)
								profile.DisableInCombat = v
							end,
						},
						movewithaltclick = {
							type = 'toggle',
							name = L["Move with Alt-click"],
							desc = L["Require the Alt buton to be held down to move the dashboard window"],
							order = 6,
							get = function(info) return profile.movewithaltclick end,
							set = function(info, v)
								profile.movewithaltclick = v
							end,
						},
					},
				},
				buffbuttonsorting = {
					type = 'group',
					name = L["Buff button sorting"],
					desc = L["Configure how the buff buttons and status bars on the dashboard are sorted and displayed"],
					order = 1,
					args = {
						groupsortstyle = {
							type = 'select',
							order = 1,
							name = L["Grouping style"],
							desc = L["Choose either one big collection of buff checks or traditional style with Warnings, Trash and Boss buff checks"],
							values = {
								["one"] = L["One big group"],
								["three"] = L["Warning, Trash, Boss groups"],
							},
							get = function(info) return profile.groupsortstyle end,
							set = function(info, v)
								profile.groupsortstyle = v
								addon:AddBuffButtons()
							end,
						},
						buffsortone = {
							type = 'select',
							order = 2,
							name = L["Sort buff buttons by"],
--							desc = L[""],
							values = {
								["defaultorder"] = L["Default order"],
								["my"] = L["My buffs"],
								["self"] = L["Self buffs"],
								["single"] = L["Single target buffs"],
								["raid"] = L["Raid-wide buffs"],
								["class"] = L["Class-specific buffs"],
								["consumables"] = L["Consumables"],
								["other"] = L["Other"],
							},
							get = function(info) return profile.buffsort[1] end,
							set = function(info, v)
								profile.buffsort[1] = v
								addon:AddBuffButtons()
							end,
						},
						buffsorttwo = {
							type = 'select',
							order = 3,
							name = L["Then sort buff buttons by"],
--							desc = L[""],
							values = {
								["defaultorder"] = L["Default order"],
								["my"] = L["My buffs"],
								["self"] = L["Self buffs"],
								["single"] = L["Single target buffs"],
								["raid"] = L["Raid-wide buffs"],
								["class"] = L["Class-specific buffs"],
								["consumables"] = L["Consumables"],
								["other"] = L["Other"],
							},
							get = function(info) return profile.buffsort[2] end,
							set = function(info, v)
								profile.buffsort[2] = v
								addon:AddBuffButtons()
							end,
							disabled = function(info)
								return (profile.buffsort[1]):find("defaultorder")
							end,
						},
						buffsortthree = {
							type = 'select',
							order = 4,
							name = L["Then sort buff buttons by"],
--							desc = L[""],
							values = {
								["defaultorder"] = L["Default order"],
								["my"] = L["My buffs"],
								["self"] = L["Self buffs"],
								["single"] = L["Single target buffs"],
								["raid"] = L["Raid-wide buffs"],
								["class"] = L["Class-specific buffs"],
								["consumables"] = L["Consumables"],
								["other"] = L["Other"],
							},
							get = function(info) return profile.buffsort[3] end,
							set = function(info, v)
								profile.buffsort[3] = v
								addon:AddBuffButtons()
							end,
							disabled = function(info)
								return (profile.buffsort[1] .. profile.buffsort[2]):find("defaultorder")
							end,
						},
						buffsortfour = {
							type = 'select',
							order = 5,
							name = L["Then sort buff buttons by"],
--							desc = L[""],
							values = {
								["defaultorder"] = L["Default order"],
								["my"] = L["My buffs"],
								["self"] = L["Self buffs"],
								["single"] = L["Single target buffs"],
								["raid"] = L["Raid-wide buffs"],
								["class"] = L["Class-specific buffs"],
								["consumables"] = L["Consumables"],
								["other"] = L["Other"],
							},
							get = function(info) return profile.buffsort[4] end,
							set = function(info, v)
								profile.buffsort[4] = v
								addon:AddBuffButtons()
							end,
							disabled = function(info)
								return (profile.buffsort[1] .. profile.buffsort[2] .. profile.buffsort[3]):find("defaultorder")
							end,
						},
						buffsortfive = {
							type = 'select',
							order = 6,
							name = L["Then sort buff buttons by"],
--							desc = L[""],
							values = {
								["defaultorder"] = L["Default order"],
								["my"] = L["My buffs"],
								["self"] = L["Self buffs"],
								["single"] = L["Single target buffs"],
								["raid"] = L["Raid-wide buffs"],
								["class"] = L["Class-specific buffs"],
								["consumables"] = L["Consumables"],
								["other"] = L["Other"],
							},
							get = function(info) return profile.buffsort[5] end,
							set = function(info, v)
								profile.buffsort[5] = v
								addon:AddBuffButtons()
							end,
							disabled = function(info)
								return (profile.buffsort[1] .. profile.buffsort[2] .. profile.buffsort[3] .. profile.buffsort[4]):find("defaultorder")
							end,
						},
					},
				},
			},
		},
		mousebuttons = {
			type = 'group',
			name = L["Mouse buttons"],
			desc = L["Dashboard mouse button actions options"],
			order = 8,
			args = {
				leftclick = {
					type = 'select',
					name = L["Left click"],
					desc = L["Select which action to take when you click with the left mouse button over a dashboard buff check"],
					order = 1,
					values = buttonoptions,
					get = function(info) return profile.LeftClick end,
					set = function(info, v)
						profile.LeftClick = v
					end,
				},
				rightclick = {
					type = 'select',
					name = L["Right click"],
					desc = L["Select which action to take when you click with the right mouse button over a dashboard buff check"],
					order = 2,
					values = buttonoptions,
					get = function(info) return profile.RightClick end,
					set = function(info, v)
						profile.RightClick = v
					end,
				},
				controlleftclick = {
					type = 'select',
					name = L["Ctrl-left click"],
					desc = L["Select which action to take when you click with the left mouse button with Ctrl held down over a dashboard buff check"],
					order = 3,
					values = buttonoptions,
					get = function(info) return profile.ControlLeftClick end,
					set = function(info, v)
						profile.ControlLeftClick = v
					end,
				},
				controlrightclick = {
					type = 'select',
					name = L["Ctrl-right click"],
					desc = L["Select which action to take when you click with the right mouse button with Ctrl held down over a dashboard buff check"],
					order = 4,
					values = buttonoptions,
					get = function(info) return profile.ControlRightClick end,
					set = function(info, v)
						profile.ControlRightClick = v
					end,
				},
				shiftleftclick = {
					type = 'select',
					name = L["Shift-left click"],
					desc = L["Select which action to take when you click with the left mouse button with Shift held down over a dashboard buff check"],
					order = 5,
					values = buttonoptions,
					get = function(info) return profile.ShiftLeftClick end,
					set = function(info, v)
						profile.ShiftLeftClick = v
					end,
				},
				shiftrightclick = {
					type = 'select',
					name = L["Shift-right click"],
					desc = L["Select which action to take when you click with the right mouse button with Shift held down over a dashboard buff check"],
					order = 6,
					values = buttonoptions,
					get = function(info) return profile.ShiftRightClick end,
					set = function(info, v)
						profile.ShiftRightClick = v
					end,
				},
				altleftclick = {
					type = 'select',
					name = L["Alt-left click"],
					desc = L["Select which action to take when you click with the left mouse button with Alt held down over a dashboard buff check"],
					order = 7,
					values = buttonoptions,
					get = function(info) return profile.AltLeftClick end,
					set = function(info, v)
						profile.AltLeftClick = v
					end,
				},
				altrightclick = {
					type = 'select',
					name = L["Alt-right click"],
					desc = L["Select which action to take when you click with the right mouse button with Alt held down over a dashboard buff check"],
					order = 8,
					values = buttonoptions,
					get = function(info) return profile.AltRightClick end,
					set = function(info, v)
						profile.AltRightClick = v
					end,
				},
			},
		},
		--[[
		tanklist = {
			type = 'group',
			name = L["Tank list"],
			desc = L["Options to do with configuring the tank list"],
			order = 9,
			args = {
				onlyusetanklist = {
					type = 'toggle',
					name = L["Only use tank list"],
					desc = L["Only use the tank list and ignore spec when there is a tank list for determining if someone is a tank or not"],
					get = function(info) return profile.onlyusetanklist end,
					set = function(info, v)
						profile.onlyusetanklist = v
					end,
				},
			},
		},
		--]]
		tankwarnings = {
			type = 'group',
			name = L["Tank warnings"],
			desc = L["Tank warnings about taunts, failed taunts and mob stealing including accidental taunts from non-tanks"],
			order = 10,
			args = {
				tankwarn = {
					type = 'toggle',
					name = L["Tank warnings"],
					desc = L["Enable tank warnings including taunts, failed taunts and mob stealing"],
					get = function(info) return profile.tankwarn end,
					set = function(info, v)
						profile.tankwarn = v
					end,
					order = 1,
				},
				bossonly = {
					type = 'toggle',
					name = L["Bosses only"],
					desc = L["Enable tank warnings including taunts, failed taunts and mob stealing only on bosses"],
					get = function(info) return profile.bossonly end,
					set = function(info, v)
						profile.bossonly = v
					end,
					disabled = function(info) return not profile.tankwarn end,
					order = 2,
				},
				failimmune = {
					type = 'group',
					name = L["Your taunt immune-fails"],
					desc = L["Warns when your taunts fail due to the target being immune"],
					order = 3,
					args = {
						failselfimmune = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when one of your taunts fails due to the target being immune"],
							get = function(info) return profile.failselfimmune end,
							set = function(info, v)
								profile.failselfimmune = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						failsoundimmune = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when one of your taunts fails due to the target being immune"],
							get = function(info) return profile.failsoundimmune end,
							set = function(info, v)
								profile.failsoundimmune = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						failrwimmune = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when one of your taunts fails due to the target being immune"],
							get = function(info) return profile.failrwimmune end,
							set = function(info, v)
								profile.failrwimmune = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						failraidimmune = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when one of your taunts fails due to the target being immune"],
							get = function(info) return profile.failraidimmune end,
							set = function(info, v)
								profile.failraidimmune = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						failpartyimmune = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when one of your taunts fails due to the target being immune"],
							get = function(info) return profile.failpartyimmune end,
							set = function(info, v)
								profile.failpartyimmune = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						failtestimmune = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["[IMMUNE] Danielbarron FAILED TO TAUNT their target (The Lich King) with Hand of Reckoning"], "failedtauntimmune")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},
				failresist = {
					type = 'group',
					name = L["Your taunt resist-fails"],
					desc = L["Warns when your taunts fail due to resist"],
					order = 4,
					args = {
						failselfresist = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when one of your taunts fails due to resist"],
							get = function(info) return profile.failselfresist end,
							set = function(info, v)
								profile.failselfresist = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						failsoundresist = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when one of your taunts fails due to resist"],
							get = function(info) return profile.failsoundresist end,
							set = function(info, v)
								profile.failsoundresist = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						failrwresist = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when one of your taunts fails due to resist"],
							get = function(info) return profile.failrwresist end,
							set = function(info, v)
								profile.failrwresist = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						failraidresist = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when one of your taunts fails due to resist"],
							get = function(info) return profile.failraidresist end,
							set = function(info, v)
								profile.failraidresist = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						failpartyresist = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when one of your taunts fails due to resist"],
							get = function(info) return profile.failpartyresist end,
							set = function(info, v)
								profile.failpartyresist = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						failtestresist = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["[RESIST] Danielbarron FAILED TO TAUNT their target (The Lich King) with Hand of Reckoning"], "failedtauntresist")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},
				otherfail = {
					type = 'group',
					name = L["Other taunt fails"],
					desc = L["Warns when other people's taunts to your target fail"],
					order = 5,
					args = {
						otherfailself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when other people's taunts to your target fail"],
							get = function(info) return profile.otherfailself end,
							set = function(info, v)
								profile.otherfailself = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						otherfailsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when other people's taunts to your target fail"],
							get = function(info) return profile.otherfailsound end,
							set = function(info, v)
								profile.otherfailsound = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						otherfailrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when other people's taunts to your target fail"],
							get = function(info) return profile.otherfailrw end,
							set = function(info, v)
								profile.otherfailrw = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						otherfailraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when other people's taunts to your target fail"],
							get = function(info) return profile.otherfailraid end,
							set = function(info, v)
								profile.otherfailraid = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						otherfailparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when other people's taunts to your target fail"],
							get = function(info) return profile.otherfailparty end,
							set = function(info, v)
								profile.otherfailparty = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						otherfailtest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["[RESIST] Darinia FAILED TO TAUNT my target (The Lich King) with Taunt"], "otherfail")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},
				taunt = {
					type = 'group',
					name = L["Taunts to my target"],
					desc = L["Warnings when someone else taunts your target"],
					order = 6,
					args = {
						tauntself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when someone else taunts your target"],
							get = function(info) return profile.tauntself end,
							set = function(info, v)
								profile.tauntself = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						tauntsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when someone else taunts your target"],
							get = function(info) return profile.tauntsound end,
							set = function(info, v)
								profile.tauntsound = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						tauntrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when someone else taunts your target"],
							get = function(info) return profile.tauntrw end,
							set = function(info, v)
								profile.tauntrw = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						tauntraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when someone else taunts your target"],
							get = function(info) return profile.tauntraid end,
							set = function(info, v)
								profile.tauntraid = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						tauntparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when someone else taunts your target"],
							get = function(info) return profile.tauntparty end,
							set = function(info, v)
								profile.tauntparty = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						taunttest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["Darinia taunted my target (The Lich King) with Taunt"], "taunt")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},
				ninja = {
					type = 'group',
					name = L["Ninja taunts"],
					desc = L["Warns when someone else taunts your target which is targeting you"],
					order = 7,
					args = {
						ninjaself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when someone else taunts your target which is targeting you"],
							get = function(info) return profile.ninjaself end,
							set = function(info, v)
								profile.ninjaself = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						ninjasound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when someone else taunts your target which is targeting you"],
							get = function(info) return profile.ninjasound end,
							set = function(info, v)
								profile.ninjasound = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						ninjarw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when someone else taunts your target which is targeting you"],
							get = function(info) return profile.ninjarw end,
							set = function(info, v)
								profile.ninjarw = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						ninjaraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when someone else taunts your target which is targeting you"],
							get = function(info) return profile.ninjaraid end,
							set = function(info, v)
								profile.ninjaraid = v
							end,disabled = function(info) return not profile.tankwarn end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						ninjaparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when someone else taunts your target which is targeting you"],
							get = function(info) return profile.ninjaparty end,
							set = function(info, v)
								profile.ninjaparty = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						ninjatest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["Darinia ninjaed my target (The Lich King) with Taunt"], "ninjataunt")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},
				tauntme = {
					type = 'group',
					name = L["Taunts to my mobs"],
					desc = L["Warnings when someone else targets a mob and taunts that mob which is targeting you"],
					order = 8,
					args = {
						tauntmeself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when someone else targets a mob and taunts that mob which is targeting you"],
							get = function(info) return profile.tauntmeself end,
							set = function(info, v)
								profile.tauntmeself = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						tauntmesound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when someone else targets a mob and taunts that mob which is targeting you"],
							get = function(info) return profile.tauntmesound end,
							set = function(info, v)
								profile.tauntmesound = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						tauntmerw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when someone else targets a mob and taunts that mob which is targeting you"],
							get = function(info) return profile.tauntmerw end,
							set = function(info, v)
								profile.tauntmerw = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						tauntmeraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when someone else targets a mob and taunts that mob which is targeting you"],
							get = function(info) return profile.tauntmeraid end,
							set = function(info, v)
								profile.tauntmeraid = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						tauntmeparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when someone else targets a mob and taunts that mob which is targeting you"],
							get = function(info) return profile.tauntmeparty end,
							set = function(info, v)
								profile.tauntmeparty = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						tauntmetest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["Darinia taunted my mob (The Lich King) with Taunt"], "tauntme")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},

				nontanktaunts = {
					type = 'group',
					name = L["Non-tank taunts my target"],
					desc = L["Warnings when someone else taunts your target who is not a tank"],
					order = 8,
					args = {
						nontanktauntself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when someone else who is not a tank taunts your target"],
							get = function(info) return profile.nontanktauntself end,
							set = function(info, v)
								profile.nontanktauntself = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 1,
						},
						nontanktauntsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when someone else who is not a tank taunts your target"],
							get = function(info) return profile.nontanktauntsound end,
							set = function(info, v)
								profile.nontanktauntsound = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 2,
						},
						nontanktauntrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when someone else who is not a tank taunts your target"],
							get = function(info) return profile.nontanktauntrw end,
							set = function(info, v)
								profile.nontanktauntrw = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 3,
						},
						nontanktauntraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when someone else who is not a tank taunts your target"],
							get = function(info) return profile.nontanktauntraid end,
							set = function(info, v)
								profile.nontanktauntraid = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 4,
						},
						nontanktauntparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when someone else who is not a tank taunts your target"],
							get = function(info) return profile.nontanktauntparty end,
							set = function(info, v)
								profile.nontanktauntparty = v
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 5,
						},
						taunttest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:TauntSay(L["NON-TANK Tanagra taunted my target (The Lich King) with Growl"], "nontanktaunt")
							end,
							disabled = function(info) return not profile.tankwarn end,
							order = 6,
						},
					},
				},
			},
		},
		ccbreakwarnings = {
			type = 'group',
			name = L["CC-break warnings"],
			desc = L["Warnings when Crowd Control is broken by tanks and non-tanks"],
			order = 11,
			args = {
				ccwarn = {
					type = 'toggle',
					name = L["CC-break warnings"],
					desc = L["Enable warnings when Crowd Control is broken by tanks and non-tanks"],
					get = function(info) return profile.ccwarn end,
					set = function(info, v)
						profile.ccwarn = v
					end,
					order = 1,
				},
				cconlyme = {
					type = 'toggle',
					name = L["Only me"],
					desc = L["Only show when you and only you break Crowd Control so you can say 'Now I don't believe you wanted to do that did you, ehee?'"],
					get = function(info) return profile.cconlyme end,
					set = function(info, v)
						profile.cconlyme = v
					end,
					disabled = function(info) return not profile.ccwarn end,
					order = 2,
				},
				ccwarntank = {
					type = 'group',
					name = L["Tank breaks CC"],
					desc = L["Warns when a tank breaks Crowd Control"],
					order = 3,
					args = {
						ccwarntankself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when a tank breaks Crowd Control"],
							get = function(info) return profile.ccwarntankself end,
							set = function(info, v)
								profile.ccwarntankself = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 1,
						},
						ccwarntanksound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when a tank breaks Crowd Control"],
							get = function(info) return profile.ccwarntanksound end,
							set = function(info, v)
								profile.ccwarntanksound = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 2,
						},
						ccwarntankrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when a tank breaks Crowd Control"],
							get = function(info) return profile.ccwarntankrw end,
							set = function(info, v)
								profile.ccwarntankrw = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 3,
						},
						ccwarntankraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when a tank breaks Crowd Control"],
							get = function(info) return profile.ccwarntankraid end,
							set = function(info, v)
								profile.ccwarntankraid = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 4,
						},
						ccwarntankparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when a tank breaks Crowd Control"],
							get = function(info) return profile.ccwarntankparty end,
							set = function(info, v)
								profile.ccwarntankparty = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 5,
						},
						ccwarntanktest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:CCBreakSay(L["Danielbarron broke Sheep on The Lich King with Hand of Reckoning"], "ccwarntank")
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 6,
						},
					},
				},
				ccwarnnontank = {
					type = 'group',
					name = L["Non-tank breaks CC"],
					desc = L["Warns when a non-tank breaks Crowd Control"],
					order = 3,
					args = {
						ccwarnnontankself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when a non-tank breaks Crowd Control"],
							get = function(info) return profile.ccwarnnontankself end,
							set = function(info, v)
								profile.ccwarnnontankself = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 1,
						},
						ccwarnnontanksound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when a non-tank breaks Crowd Control"],
							get = function(info) return profile.ccwarnnontanksound end,
							set = function(info, v)
								profile.ccwarnnontanksound = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 2,
						},
						ccwarnnontankrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when a non-tank breaks Crowd Control"],
							get = function(info) return profile.ccwarnnontankrw end,
							set = function(info, v)
								profile.ccwarnnontankrw = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 3,
						},
						ccwarnnontankraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when a non-tank breaks Crowd Control"],
							get = function(info) return profile.ccwarnnontankraid end,
							set = function(info, v)
								profile.ccwarnnontankraid = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 4,
						},
						ccwarnnontankparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when a non-tank breaks Crowd Control"],
							get = function(info) return profile.ccwarnnontankparty end,
							set = function(info, v)
								profile.ccwarnnontankparty = v
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 5,
						},
						ccwarnnontanktest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:CCBreakSay(L["Non-tank Glamor broke Hex on The Lich King with Moonfire"], "ccwarnnontank")
							end,
							disabled = function(info) return not profile.ccwarn end,
							order = 6,
						},
					},
				},
			},
		},
		misdirectionwarnings = {
			type = 'group',
			name = L["Misdirection warnings"],
			desc = L["Warnings when Misdirection or Tricks of the Trade is cast"],
			order = 12,
			args = {
				misdirection = {
					type = 'toggle',
					name = L["Misdirection warnings"],
					desc = L["Enable warnings when Misdirection or Tricks of the Trade is cast"],
					get = function(info) return profile.misdirectionwarn end,
					set = function(info, v)
						profile.misdirectionwarn = v
					end,
					order = 1,
				},
				misdirections = {
					type = 'group',
					name = L["Misdirection warnings"],
					desc = L["Warnings when Misdirection or Tricks of the Trade is cast"],
					order = 2,
					args = {
						misdirectionself = {
							type = 'toggle',
							name = L["Warn to self"],
								desc = L["Warn to self when Misdirection or Tricks of the Trade is cast"],
								get = function(info) return profile.misdirectionself end,
								set = function(info, v)
									profile.misdirectionself = v
								end,
								disabled = function(info) return not profile.misdirectionwarn end,
								order = 1,
						},
						misdirectionsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when Misdirection or Tricks of the Trade is cast"],
							get = function(info) return profile.misdirectionsound end,
							set = function(info, v)
								profile.misdirectionsound = v
							end,
							disabled = function(info) return not profile.misdirectionwarn end,
							order = 2,
						},
						misdirectiontest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:MisdirectionEventLog("Garmann", GetSpellInfo(34477), "Darinia") -- Misdirection
							end,
							disabled = function(info) return not profile.misdirectionwarn end,
							order = 3,
						},
					},
				},
			},
		},
		deathwarnings = {
			type = 'group',
			name = L["Death warnings"],
			desc = L["Warning messages when players die"],
			order = 13,
			args = {
				deathwarn = {
					type = 'toggle',
					name = L["Death warnings"],
					desc = L["Enable warning messages when players die"],
					get = function(info) return profile.deathwarn end,
					set = function(info, v)
						profile.deathwarn = v
					end,
					order = 1,
				},
				tankdeath = {
					type = 'group',
					name = L["Tank death"],
					desc = L["Warn when a tank dies"],
					order = 1,
					args = {
						tankdeathself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when a tank dies"],
							get = function(info) return profile.tankdeathself end,
							set = function(info, v)
								profile.tankdeathself = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 1,
						},
						tankdeathsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when a tank dies"],
							get = function(info) return profile.tankdeathsound end,
							set = function(info, v)
								profile.tankdeathsound = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 2,
						},
						tankdeathrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when a tank dies"],
							get = function(info) return profile.tankdeathrw end,
							set = function(info, v)
								profile.tankdeathrw = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 3,
						},
						tankdeathraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when a tank dies"],
							get = function(info) return profile.tankdeathraid end,
							set = function(info, v)
								profile.tankdeathraid = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 4,
						},
						tankdeathparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when a tank dies"],
							get = function(info) return profile.tankdeathparty end,
							set = function(info, v)
								profile.tankdeathparty = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 5,
						},
						tankdeathtest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:DeathSay(L["Tank Danielbarron has died!"], "tank")
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 6,
						},
					},
				},
				meleedpsdeath = {
					type = 'group',
					name = L["Melee DPS death"],
					desc = L["Warn when a melee DPS dies"],
					order = 2,
					args = {
						meleedpsdeathself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when a melee DPS dies"],
							get = function(info) return profile.meleedpsdeathself end,
							set = function(info, v)
								profile.meleedpsdeathself = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 1,
						},
						meleedpsdeathsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when a melee DPS dies"],
							get = function(info) return profile.meleedpsdeathsound end,
							set = function(info, v)
								profile.meleedpsdeathsound = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 2,
						},
						meleedpsdeathrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when a melee DPS dies"],
							get = function(info) return profile.meleedpsdeathrw end,
							set = function(info, v)
								profile.meleedpsdeathrw = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 3,
						},
						meleedpsdeathraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when a melee DPS dies"],
							get = function(info) return profile.meleedpsdeathraid end,
							set = function(info, v)
								profile.meleedpsdeathraid = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 4,
						},
						meleedpsdeathparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when a melee DPS dies"],
							get = function(info) return profile.meleedpsdeathparty end,
							set = function(info, v)
								profile.meleedpsdeathparty = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 5,
						},
						meleedpsdeathtest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:DeathSay(L["Melee DPS Danielbarron has died!"], "meleedps")
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 6,
						},
					},
				},
				rangeddpsdeath = {
					type = 'group',
					name = L["Ranged DPS death"],
					desc = L["Warn when a ranged DPS dies"],
					order = 3,
					args = {
						rangeddpsdeathself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when a ranged DPS dies"],
							get = function(info) return profile.rangeddpsdeathself end,
							set = function(info, v)
								profile.rangeddpsdeathself = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 1,
						},
						rangeddpsdeathsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when a ranged DPS dies"],
							get = function(info) return profile.rangeddpsdeathsound end,
							set = function(info, v)
								profile.rangeddpsdeathsound = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 2,
						},
						rangeddpsdeathrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when a ranged DPS dies"],
							get = function(info) return profile.rangeddpsdeathrw end,
							set = function(info, v)
								profile.rangeddpsdeathrw = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 3,
						},
						rangeddpsdeathraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when a ranged DPS dies"],
							get = function(info) return profile.rangeddpsdeathraid end,
							set = function(info, v)
								profile.rangeddpsdeathraid = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 4,
						},
						rangeddpsdeathparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when a ranged DPS dies"],
							get = function(info) return profile.rangeddpsdeathparty end,
							set = function(info, v)
								profile.rangeddpsdeathparty = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 5,
						},
						rangeddpsdeathtest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:DeathSay(L["Ranged DPS Garmann has died!"], "rangeddps")
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 6,
						},
					},
				},
				healerdeath = {
					type = 'group',
					name = L["Healer death"],
					desc = L["Warn when a healer dies"],
					order = 3,
					args = {
						healerdeathself = {
							type = 'toggle',
							name = L["Warn to self"],
							desc = L["Warn to self when a healer dies"],
							get = function(info) return profile.healerdeathself end,
							set = function(info, v)
								profile.healerdeathself = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 1,
						},
						healerdeathsound = {
							type = 'toggle',
							name = L["Play a sound"],
							desc = L["Play a sound when a healer dies"],
							get = function(info) return profile.healerdeathsound end,
							set = function(info, v)
								profile.healerdeathsound = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 2,
						},
						healerdeathrw = {
							type = 'toggle',
							name = L["Warn to raid warning"],
							desc = L["Warn using raid warning when a healer dies"],
							get = function(info) return profile.healerdeathrw end,
							set = function(info, v)
								profile.healerdeathrw = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 3,
						},
						healerdeathraid = {
							type = 'toggle',
							name = L["Warn to raid chat"],
							desc = L["Warn to raid chat when a healer dies"],
							get = function(info) return profile.healerdeathraid end,
							set = function(info, v)
								profile.healerdeathraid = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 4,
						},
						healerdeathparty = {
							type = 'toggle',
							name = L["Warn to party"],
							desc = L["Warn to party when a healer dies"],
							get = function(info) return profile.healerdeathparty end,
							set = function(info, v)
								profile.healerdeathparty = v
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 5,
						},
						healerdeathtest = {
							type = 'execute',
							name = L["Test"],
							desc = L["Test what the warning is like"],
							func = function(info, v)
								addon:DeathSay(L["Healer Stormsnow has died!"], "healer")
							end,
							disabled = function(info) return not profile.deathwarn end,
							order = 6,
						},
					},
				},
			},
		},
		utilannounce = {
			type = 'group',
			name = L["Utility announcements"],
			desc = L["Announcement options for raid utilities like Feasts"],
			order = 14,
			args = {
				announceHeader = {
					type = 'header',
					name = L["Utility announcements"],
					order = 0.9,
				},
				announceFeast = {
					type = 'toggle',
					name = L["Feasts"],
					desc = L["Announce to raid warning when a Feast is prepared"],
					order = 1,
				},
				feastautowhisper = {
					type = 'toggle',
					name = L["Feast auto whisper"],
					desc = L["Automatically whisper anyone missing Well Fed when your Feast expire warnings appear"],
					disabled = function() return not profile.announceExpiration end,
					order = 110,
				},
				announceCart = {
					type = 'toggle',
					name = L["Noodle Cart"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Noodle Cart"]),
					order = 2.5,
				},
				announceTable = {
					type = 'toggle',
					name = L["Refreshment Table"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Refreshment Table"]),
					order = 2.75,
				},
				announceCauldron = {
					type = 'toggle',
					name = L["Cauldron"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Cauldron"]),
					order = 3,
				},
				cauldronautowhisper = {
					type = 'toggle',
					name = L["Cauldron auto whisper"],
					desc = L["Automatically whisper anyone missing flasks or elixirs when your Cauldron expire warnings appear"],
					disabled = function() return not profile.announceExpiration end,
					order = 120,
				},
				announceSoulwell = {
					type = 'toggle',
					name = L["Soulwell"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Soulwell"]),
					order = 6,
				},
				wellautowhisper = {
					type = 'toggle',
					name = L["Well auto whisper"],
					desc = L["Automatically whisper anyone missing a Healthstone when your Soul Well expire warnings appear"],
					disabled = function() return not profile.announceExpiration end,
					order = 130,
				},
				announceRepair = {
					type = 'toggle',
					name = L["Repair Bot"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Repair Bot"]),
					order = 7,
				},
				announceMailbox = {
					type = 'toggle',
					name = L["Mailbox"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Mailbox"]),
					order = 8,
				},
				announcePortal = {
					type = 'toggle',
					name = L["Portal"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Portal"]),
					order = 9,
				},
				announceBlingtron = {
					type = 'toggle',
					name = L["Blingtron"],
					desc = L["Announce to raid warning when a %s is prepared"]:format(L["Blingtron"]),
					order = 10,
				},
				expireHeader = {
					type = 'header',
					name = L["Expiration announcements"],
					order = 100,
				},
				announceExpiration = {
					type = 'toggle',
					name = L["Announce expiration"],
					desc = L["Announce to raid warning when a utility is expiring"],
					order = 101,
				},
				antispam = {
					type = 'toggle',
					name = L["Anti spam"],
					desc = L["Wait before announcing to see if others have announced first in order to reduce spam"],
					order = 0.1,
					get = function(info) return profile.antispam end,
					set = function(info, v)
						profile.antispam = v
					end,
				},
				nonleadspeak = {
					type = 'toggle',
					name = L["Announce without lead"],
					desc = L["Announce even when you don't have assist or lead"],
					order = 0.2,
					get = function(info) return profile.nonleadspeak end,
					set = function(info, v)
						profile.nonleadspeak = v
					end,
				},
			},
		},
		autoacceptinvites = {
			type = 'group',
			name = L["Auto-accept invites"],
			desc = L["Automatically accept invites from friends and guild members so you can go for a bio-break whilst waiting for a raid invite"],
			order = 16,
			args = {
				guildmembers = {
					type = 'toggle',
					name = L["Guild members"],
					desc = L["Automatically accept invites from these"],
					order = 1,
					get = function(info) return profile.guildmembers end,
					set = function(info, v)
						profile.guildmembers = v
					end,
				},
				friends = {
					type = 'toggle',
					name = L["Friends"],
					desc = L["Automatically accept invites from these"],
					order = 2,
					get = function(info) return profile.friends end,
					set = function(info, v)
						profile.friends = v
					end,
				},
				bnfriends = {
					type = 'toggle',
					name = L["Battle.net friends"],
					desc = L["Automatically accept invites from these"],
					order = 3,
					get = function(info) return profile.bnfriends end,
					set = function(info, v)
						profile.bnfriends = v
					end,
				},
			},
		},
		autoinviteswhispers = {
			type = 'group',
			name = L["Auto-invite whispers"],
			desc = L["Automatically invite friends and guild members who whisper to you the word 'invite'"],
			order = 17,
			args = {
				guildmembers = {
					type = 'toggle',
					name = L["Guild members"],
					desc = L["Automatically invite these"],
					order = 1,
					get = function(info) return profile.aiwguildmembers end,
					set = function(info, v)
						profile.aiwguildmembers = v
					end,
				},
				friends = {
					type = 'toggle',
					name = L["Friends"],
					desc = L["Automatically invite these"],
					order = 2,
					get = function(info) return profile.aiwfriends end,
					set = function(info, v)
						profile.aiwfriends = v
					end,
				},
				bnfriends = {
					type = 'toggle',
					name = L["Battle.net friends"],
					desc = L["Automatically invite these"],
					order = 3,
					get = function(info) return profile.aiwbnfriends end,
					set = function(info, v)
						profile.aiwbnfriends = v
					end,
				},
			},
		},
		versionannounce = {
			type = 'group',
			name = L["Version announce"],
			desc = L["Tells you when someone in your party, raid or guild has a newer version of RBS installed"],
			order = 18,
			args = {
				versionannounce = {
					type = 'toggle',
					name = L["Version announce"],
					desc = L["Tells you when someone in your party, raid or guild has a newer version of RBS installed"],
					order = 1,
					get = function(info) return profile.versionannounce end,
					set = function(info, v)
						profile.versionannounce = v
					end,
				},
				userannounce = {
					type = 'toggle',
					name = L["User announce"],
					desc = L["Tells you when someone in your party, raid or guild has RBS installed"],
					order = 2,
					get = function(info) return profile.userannounce end,
					set = function(info, v)
						profile.userannounce = v
					end,
				},
			},
		},
	},
}

addon.configOptions = options
LibStub("AceConfig-3.0"):RegisterOptionsTable("RaidBuffStatus", options, {'rbs', 'raidbuffstatus'})
