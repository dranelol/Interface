--[[
## Interface: 50001
## Title: BalancePowerTracker_Options
## Version: 1.1.2
## Author: Kurohoshi (EU-Minahonda)
## Notes: BPT's Options. /bpt or /balancepowertracker to show.

--CHANGELOG
v1.1.2 FIXED descriptions, update when options changed from outside, reduced code.
v1.1.1 MoP release
--]]

local function CreateOptions(_,_,name) 
	if name~= "BalancePowerTracker_Options" then
		return 
	end
	
	if not BalancePowerTracker then 
		print("|c00a080ffBalancePowerTracker Options|r: LOADING ERROR: BalancePowerTracker not found") 
		return 
	end
	
	local class = select(2,UnitClass("player"))
	
	local me = {}
	local opt = BalancePowerTracker_Options
	local BPT = BalancePowerTracker
	BalancePowerTracker_Options = BalancePowerTracker_Options or {}
	
	local Propagate = (BPT.CheckAll and function() return BPT.CheckAll(true) end ) or function() return "Not found." end 
	local modules = (BPT and BPT.modules) or {}

	local function switch(t,key)
		t[key] = not t[key]
		Propagate()
	end
	
	me.data = {
		statusbar = {
			["Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill"] = "UI TargetingFrame BarFill",
		},
		border = {
			["Interface\\Tooltips\\UI-Tooltip-Border"] = "UI Tooltip Border", 
		},
		sound = {
			["Interface\\Quiet.ogg"] = "silent",
		},
		font = {
			["Fonts\\FRIZQT__.TTF"] = "BPT default",
		},
	}
	
	-- Libsharedmedia
	local media = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0",true);
	function me.LibSharedMedia_Registered()
		if not media then return end
		
		for k in pairs(me.data) do
			for _, name in pairs(media:List(k)) do
				local path = media:Fetch(k, name)
				if path then
					me.data[k][path] = name
				end
			end
		end
	end
	if media then 
		media.RegisterCallback(me, "LibSharedMedia_Registered")
		me.LibSharedMedia_Registered()
	end
	
	local strata ={
		"BACKGROUND",
		"LOW",
		"MEDIUM",
		"HIGH",
		"DIALOG",
		"FULLSCREEN",
		"FULLSCREEN_DIALOG",
		"TOOLTIP",
	}
	
	local points = {
	    TOPLEFT = "TOPLEFT",
		TOPRIGHT = "TOPRIGHT",
		BOTTOMLEFT = "BOTTOMLEFT",
		BOTTOMRIGHT = "BOTTOMRIGHT",
		TOP = "TOP",
		BOTTOM = "BOTTOM",
		LEFT = "LEFT",
		RIGHT = "RIGHT",
		CENTER  = "CENTER",
	}
	
	local function searchKey(t,value)
		for k,v in pairs(t) do
			if v==value then
				return k
			end
		end
	end
	
	local globalOrder = {[1] = 1, index = 1};
	local function getOrder(order)
		if order == nil then 
			order = globalOrder[globalOrder.index] 
			globalOrder[globalOrder.index] = order+1
		elseif order == 0 then
			globalOrder.index = globalOrder.index+1
			order = 1
			globalOrder[globalOrder.index] = order+1
		elseif order <0 then 
			order = globalOrder[globalOrder.index]
			globalOrder[globalOrder.index] = order+1
			globalOrder.index = globalOrder.index-1
		end
		return order
	end
	
	local function moduleLoaded(moduleKey)
		return modules[moduleKey] and modules[moduleKey].loaded and opt and opt[moduleKey]
	end
	local function moduleUsable(moduleKey)
		if moduleKey == "global" then return true end
	
		return modules[moduleKey] and ((not modules[moduleKey].class) or modules[moduleKey].class[class]) and opt and opt[moduleKey]
	end
	local function isBPTdisabled()
		return not opt.global.enabled
	end
	
	local function CreateToogle(order,name,desc,optTable,optKey,disabled,isLoader)
		local disabled2 = disabled
		if type(disabled) == "function" and not isLoader then
			disabled2 = function() return (not moduleLoaded(optTable)) or disabled() end
		end
		
		return  {	type	= 'toggle',
					name	= name,
					desc	= desc,
					get		= function () return opt[optTable][optKey] end,
					set		= function () switch(opt[optTable],optKey) end,
					order	= getOrder(order),
					disabled = disabled2,
					hidden	= not moduleUsable(optTable),
				}
	end
	local function CreateExecute(order,name,desc,func,confirm,confirmText)
		return  {	type	= 'execute',
					name	= name,
					confirm = confirm,
					confirmText = confirmText,
					desc	= desc,
					func	= func,
					order	= getOrder(order),
				}
	end
	local function CreateHeader(order,name)
		return  {	type	= 'header',
					name    = name,
					order = getOrder(order),
				}
	end
	local function CreateRange(order,name,min,max,step,optTable,optKey,disabled)
		local disabled2 = disabled
		if type(disabled) == "function" then
			disabled2 = function() return (not moduleLoaded(optTable)) or disabled() end
		end
		
		return {	type	= 'range',
					name	= name,
					min		= min,
					max		= max,
					step    = step,
					get		= function () return opt[optTable][optKey] end,
					set		= function (_, new) opt[optTable][optKey] = new; Propagate() end,
					order	= getOrder(order),
					disabled = disabled2,
					hidden	= not moduleUsable(optTable),
				}
	end
	local function CreateSelect(order,name,optTable,optKey,values,disabled)
		local disabled2 = disabled
		if type(disabled) == "function" then
			disabled2 = function() return (not moduleLoaded(optTable)) or disabled() end
		end
		
		return	{	type	= 'select',
					name	= name,
					get		= function () return opt[optTable][optKey]; end,
					set		= function(_,new) opt[optTable][optKey]=new; Propagate() end,
					values	= (type(values)=="function" and values) or function () return values end,
					order	= getOrder(order),
					disabled = disabled2,
					hidden	= not moduleUsable(optTable),
				}
	end
	local function CreateColor(order,name,optTable,optKey)
		return 	{	type = 'color',
					name = name,
					hasAlpha = true,
					get	= function ()local color = opt[optTable][optKey] ;return color.r, color.g, color.b, color.a end,
					set	= function (info, r, g, b, a)local color = opt[optTable][optKey];color.r=r color.g=g color.b=b color.a=a Propagate() end,
					order	= getOrder(order),
					hidden	= not moduleUsable(optTable),
				}
	end
	local function alertOption(key,name,order)
		return {
			name	= name,
			type	= 'group',
			order	= getOrder(order),
			hidden	= not moduleUsable("warning_text"),
			args	= {
					showText	= {
						type	= 'toggle',
						name	= 'Show text',
						get		= function () return opt.warning_text[key].warnThis end,
						set		= function () switch(opt.warning_text[key],"warnThis") end,
						order	= 1,
					},
					text	= {
						type	= 'input',
						name	= "Text shown",
						disabled= function () return not (modules.warning_text and modules.warning_text.loaded and opt and opt.warning_text and opt.warning_text[key].warnThis) end, 
						get		= function () return opt.warning_text[key].text end,
						set		= function(_,new) opt.warning_text[key].text= new end,
						order	= 2,
					},
					playSound	= {
						type	= 'toggle',
						name	= 'Play sound',
						get		= function () return opt.warning_text[key].playThis end,
						set		= function () switch(opt.warning_text[key],"playThis") end,
						order	= 3,
					},
					sound	= {
						type	= 'select',
						name	= "Alert sound",
						disabled= function () return not opt.warning_text[key].playThis end, 
						get		= function () return opt.warning_text[key].sound; end,
						set		= function(_,new) opt.warning_text[key].sound=new; PlaySoundFile(new) end,
						values	= function () return me.data.sound end,
						order	= 4,
					},
					FlashThis	= {
						type	= 'toggle',
						name	= 'Flash screen',
						get		= function () return opt.warning_text[key].flashThis end,
						set		= function () switch(opt.warning_text[key],"flashThis") end,
						order	= 5,
					},
					color	= {
						type = 'color',
						name = "Solar Color",
						hasAlpha = true,
						get	= function ()local color = opt.warning_text[key].color ;return color.r, color.g, color.b, color.a end,
						set	= function (info, r, g, b, a)local color = opt.warning_text[key].color;color.r=r color.g=g color.b=b color.a=a Propagate() end,
						order	= 6,
					},
					MSBTThis	= {
						type	= 'toggle',
						name	= 'MikSBT alert',
						hidden = function() return not MikSBT end,
						get		= function () return opt.warning_text[key].MSBTThis end,
						set		= function () switch(opt.warning_text[key],"MSBTThis") end,
						order	= 7,
					},
					showTexture	= {
						type	= 'toggle',
						name	= 'Show texture',
						desc 	= 'Show texture in MikSBT alert',
						hidden = function() return not (MikSBT and opt.warning_text[key].MSBTThis) end,
						get		= function () return opt.warning_text[key].showTexture end,
						set		= function () switch(opt.warning_text[key],"showTexture") end,
						order	= 8,
					},
					texture = {
						type = "input",
						name	= 'Texture shown',
						hidden = function() return not (MikSBT and opt.warning_text[key].MSBTThis and opt.warning_text[key].showTexture) end,
						get		= function () return opt.warning_text[key].texture end,
						set		= function(_,new) opt.warning_text[key].texture= new end,
						width	= "full",
						order = 9,
					},
					displaytexture = {
						type = "description",
						name = 'Texture',
						image = function() return opt.warning_text[key].texture end,
						hidden = function() return not (MikSBT and opt.warning_text[key].MSBTThis and opt.warning_text[key].showTexture) end,
						order = 10
					},
			},
		}
	end
	
	local options = { 
		name	= BalancePowerTracker.name.." v"..GetAddOnMetadata(BalancePowerTracker.name, "Version"),
		type	= 'group',
		args	= {
			reset = CreateExecute(nil,"Reset all","Reset to default",function() 
							BalancePowerTracker_Options = nil; 
							local text = "|c00a080ffBalancePowerTracker|r: "
							local err = Propagate(); 
							opt = BalancePowerTracker_Options
							if err then 
								text=text..err
							else 
								text=text.."Reset done."
							end
							print(text) 
						end,true,"Reset cannot be undone"),
			verbose	= CreateToogle(nil,"Silent load","Don't show message when successfully loaded","global","muted"),
			Info = {
			    type	= 'group',
				name	= "Info",
				order	= getOrder(),
				args ={
					header = CreateHeader(getOrder(0),BalancePowerTracker.name),
					info1 = {
						type	= 'description',
						name	= "BPT's main purpose is providing a highly configurable eclipse bar with energy prediction to Balance druids. It's focused on using the CPU strictly necessary and no more, therefore, it's divided into several modules.",
						order = getOrder(),
					},
					info2 = {
						type	= 'description',
						name	= "Energy track and prediction supported by LibBalancePowerTracker v"..select(1,LibBalancePowerTracker:GetVersion()).."."..select(2,LibBalancePowerTracker:GetVersion()),
						order = getOrder(),
					},
					info3 = {
						type	= 'description',
						name	= "Masque, MikSBT & LibSharedMedia are supported.",
						order = getOrder(),
					},
					info4 = {
						type	= 'description',
						name	= "Created & maintained by Kurohoshi (EU - Minahonda)",
						order = getOrder(),
					},
					l1	= {
						type	= 'input',
						name	= "WoWinterface:",
						get		= function () return "www.wowinterface.com/downloads/info18000-BalancePowerTracker" end,
						set		= function() end,
						order	= getOrder(),
						width	= "full"
					},
					l2	= {
						type	= 'input',
						name	= "Curse:",
						get		= function () return "www.curse.com/addons/wow/balancepowertracker" end,
						set		= function() end,
						order	= getOrder(-1),
						width	= "full"
					},
				},
			},
			Modules = {
			    type	= 'group',
				name	= "Modules",
				order	= getOrder(),
				args ={
					all	= CreateToogle(0,"BPT Enabled",nil,"global","enabled"),
					header = CreateHeader(nil,"Toogle ON/OFF each module:"),
					eclipse_bar = CreateToogle(nil,"Eclipse bar","Enable/Disable the eclipse bar.","eclipse_bar","load",isBPTdisabled,true),
					warning_text = CreateToogle(nil,"Alerts","Enable/Disable the alerts.","warning_text","load",isBPTdisabled,true),
					hide_default = CreateToogle(nil,"Hide default Eclipse bar","Hide/show default eclipse bar.","hide_default","load",isBPTdisabled,true),
					default_art = CreateToogle(nil,"Default art Eclipse bar","Shows another eclipse bar with the default art and very reduced options","default_art","load",isBPTdisabled,true),
					pipe = CreateToogle(-1,"Pipe","Tries to convince other addons and the UI to use predicted values instead of the real ones. CAN CAUSE TAINT ISSUES AND IS NOT GUARANTEED TO WORK: LEAVE UNCHECKED UNLESS YOU REALLY NEED IT","pipe","load",isBPTdisabled,true),
				},
			},
			eclipse_bar = {
			    type	= 'group',
				name	= "Eclipse Bar",
				order	= getOrder(),
				hidden	= not moduleUsable("eclipse_bar"),
				disabled = function() return not moduleLoaded("eclipse_bar") end,
				args ={
					reset	= CreateExecute(0,"Reset eclipse bar","Reset eclipse bar settings",function () opt.eclipse_bar = nil; Propagate(); end,true,"Reset cannot be undone"),
					move	= CreateToogle(nil,'Move freely',"Move the bar by dragging it","eclipse_bar","moving"),
					x	= CreateRange(nil,"X",-900,900,1,"eclipse_bar","x"),
					y	= CreateRange(nil,"Y",-600,600,1,"eclipse_bar","y"),
					point	= CreateSelect(nil,"Anchor point","eclipse_bar","point",points),
					strata	= {
						type	= 'select',
						name	= "Layer",
						get		= function () return searchKey(strata,opt.eclipse_bar.strata); end,
						set		= function(_,new) opt.eclipse_bar.strata=strata[new]; Propagate() end,
						values	= function () return strata end,
						order	= getOrder(),
					},
					height	= CreateRange(nil,"Height",10,50,1,"eclipse_bar","height"),
					width	= CreateRange(nil,"Width",10,400,1,"eclipse_bar","width"),
					scale	= CreateRange(nil,"Scale",0.5,4,0.05,"eclipse_bar","scale"),
					visibility ={
						name	= "Visibility",
						type	= 'group',
						order	= getOrder(),
						args	= {
							alpha	= CreateRange(0,"Alpha",0,1,0.05,"eclipse_bar","alpha"),
							alphaOOC	= CreateRange(nil,"Alpha out of combat",0,1,0.05,"eclipse_bar","alphaOOC"),
							showInAll	= CreateToogle(nil,'Show in all forms',nil,"eclipse_bar","showInAllStances"),
							showCustomize	= {
								type	= 'multiselect',
								disabled = function () return (not moduleLoaded("eclipse_bar")) or opt.eclipse_bar.showInAllStances; end,
								name	= "Customizable show in form",
								get		=	function(_,keyname)	return opt.eclipse_bar.custom[keyname]; end,
								set		= 	function(_,keyname, state)
												opt.eclipse_bar.custom[keyname] = state;
												if keyname == 27 then
													opt.eclipse_bar.custom[29] = state; --normal flight form
												end
												Propagate();
											end,
								values	= function () return {[1]="Cat",[5]="Bear",[31]="Moonkin",[27]="Flight",[3]="Travel",[4]="Aquatic",[0]="Humanoid"} end,
								order	= getOrder(-1),
							},
						}
					},
					barOptions ={
						name	= "Bar options",
						type	= 'group',
						order	= getOrder(),
						args	= {
							showPredictBar	= CreateToogle(0,'Show predicted energy bar',nil,"eclipse_bar","showPredictBar"),
							barModeColorAll	= CreateToogle(nil,'Color all bar',"Color all bar with arrow's direction color.","eclipse_bar","barModeColorAll"),
							gainSpark	= CreateToogle(nil,'Energy gain spark',"Spark shows where you cast currently is in the predicted energy bar.","eclipse_bar","gainSpark"),
							Growbar	= CreateToogle(nil,'Grow bar mode',"Bar is shown from 0 to the marker.","eclipse_bar","growBar"),
							barModeCastBar	= CreateToogle(nil,'Castbar mode',"When casting a spell that gives eclipse energy, the spark travels all the bar.","eclipse_bar","barModeCastBar"),
							vertical	= CreateToogle(nil,'Vertical bar',nil,"eclipse_bar","vertical"),
							showIcons = CreateToogle(nil,'Show Eclipse icons',nil,"eclipse_bar","showIcons"),
							header1 = CreateHeader(nil,""),
							bartexture	= CreateSelect(nil,"Bar texture","eclipse_bar","barTextureFile",me.data.statusbar),
							header2 = CreateHeader(nil,""),
							showBorder	= CreateToogle(nil,'Show border',nil,"eclipse_bar","showEdge"),
							bordertexture	= CreateSelect(nil,"Border texture","eclipse_bar","edgeFile",me.data.border,function() return not opt.eclipse_bar.showEdge end),
							borderSize	=  CreateRange(-1,"Border Size",1,25,1,"eclipse_bar","edgeSize",function() return not opt.eclipse_bar.showEdge end)
						}
					},	
					text ={
						name	= "Arrow & text options",
						type	= 'group',
						order	= getOrder(),
						args	= {
							predictOnArrow	= CreateToogle(0,'Predict','Show predicted energy on arrow and text',"eclipse_bar","predictOnArrow"),
							arrowscale	= CreateRange(nil,"Arrow scale",0.5,4,0.05,"eclipse_bar","arrowScale"),
							showValue	= CreateToogle(nil,'Show text',nil,"eclipse_bar","showValue"),
							moveTextOutOfTheWay	= CreateToogle(nil,'Move text',"Move text when arrow is over it.","eclipse_bar","moveTextOutOfTheWay",function () return not opt.eclipse_bar.showValue end),
							absoluteText	= CreateToogle(nil,'Show always positive values',nil,"eclipse_bar","absoluteText",function () return not opt.eclipse_bar.showValue end),
							autoFontSize	= CreateToogle(nil,'Auto font size',nil,"eclipse_bar","autoFontSize",function () return not opt.eclipse_bar.showValue end),
							font	= CreateSelect(nil,"Font","eclipse_bar","font",me.data.font,function() return not opt.eclipse_bar.showValue end),
							fontSize	= CreateRange(-1,"Font size",10,32,1,"eclipse_bar","fontSize",function () return (not opt.eclipse_bar.showValue) or opt.eclipse_bar.autoFontSize end)
						}
					},	
					eclipse_icons = {
						type	= 'group',
						name	= "Eclipse Icons",
						order	= getOrder(),
						disabled = function() return not (moduleLoaded("eclipse_bar") and opt.eclipse_bar.showIcons) end,
						args ={
							sx	= CreateRange(0  ,"Solar icon X offset",-900,900,1,"eclipse_bar","sx"),
							sy	= CreateRange(nil,"Solar icon Y offset",-600,600,1,"eclipse_bar","sy"),
							lx	= CreateRange(nil,"Lunar icon X offset",-900,900,1,"eclipse_bar","lx"),
							ly	= CreateRange(nil,"Lunar icon Y offset",-600,600,1,"eclipse_bar","ly"),
							size	= CreateRange(nil,"Icon size",10,50,1,"eclipse_bar","iconSize"),
							predict	= CreateToogle(nil,'Use predicted info',nil,"eclipse_bar","predictOnIcons"),
							bigIcons	= CreateToogle(nil,'Big Icons',"Enlarge nearest Eclipse","eclipse_bar","big_icons"),
							bigscale	= CreateRange(nil,"Big icons scale",0.5,4,0.05,"eclipse_bar","iconBigScale",function () return not opt.eclipse_bar.big_icons end),
							highlight	= {
								type	= 'select',
								name	= "Highlight type",
								get		= function ()
											if opt.eclipse_bar.iconSpellReady then return 3
											elseif opt.eclipse_bar.iconGlow then return 2
											else return 1
											end
										end,
								set		= function(_,new) 
											opt.eclipse_bar.iconSpellReady = new == 3
											opt.eclipse_bar.iconGlow = new == 2 
											Propagate()
										end,
								values	= function () return {"None","Normal","'Spell ready' effect"} end,
								order	= getOrder(-1),
							}
						},
					},
					color ={
						name	= "Color",
						type	= 'group',
						order	= getOrder(-1),
						args	= {
								solarColor	= CreateColor(0,"Solar","eclipse_bar","solarColor"),
								lunarColor	= CreateColor(nil,"Lunar","eclipse_bar","lunarColor"),
								predictedSolarColor	= CreateColor(nil,"Predicted Solar","eclipse_bar","predictedSolarColor"),
								predictedLunarColor	= CreateColor(nil,"Predicted Lunar","eclipse_bar","predictedLunarColor"),
								textColor	= CreateColor(nil,"Text","eclipse_bar","textColor"),
								backGroundColor	= CreateColor(nil,"Background","eclipse_bar","backGroundColor"),
								borderColor	= CreateColor(-1,"Edge","eclipse_bar","borderColor")
						},
					},
				}
			},
			Warning = {
			    type	= 'group',
				name	= "Alerts",
				order	= getOrder(),
				hidden	= not moduleUsable("warning_text"),
				disabled = function() return not moduleLoaded("warning_text") end,
				args ={
					reset	= CreateExecute(0,"Reset alert","Reset alert settings",function () opt.warning_text = nil; Propagate(); end,true,"Reset cannot be undone"),
					move	= CreateToogle(nil,'Move freely',"Move the alerts text by dragging it","warning_text","testing"),
					x	= CreateRange(nil,"X",-900,900,1,"warning_text","x"),
					y	= CreateRange(nil,"Y",-600,600,1,"warning_text","y"),
					point	= CreateSelect(nil,"Anchor point","warning_text","point",points),
					scale	= CreateRange(nil,"Scale",0.5,4,0.05,"warning_text","scale"),
					flashAlpha	= CreateRange(nil,"Flash alpha",0,1,0.05,"warning_text","flashAlpha"),
					spellEffects	= CreateToogle(nil,'Spell effects',"Show the spell effects (sun and moon above yout char) when predicting Eclipse","warning_text","spellEffects"),
					font	= CreateSelect(nil,"Alert font","warning_text","font",me.data.font),
					fontSize	= CreateRange(nil,"Font size",10,32,1,"warning_text","fontSize"),
					RealSolarEclipse = alertOption("RealSolarEclipse","Solar Eclipse alert options"),
					RealLunarEclipse = alertOption("RealLunarEclipse","Lunar Eclipse alert options"),
					PredictedSolarEclipse = alertOption("PredictedSolarEclipse","Predicted Solar Eclipse alert options"),
					PredictedLunarEclipse = alertOption("PredictedLunarEclipse","Predicted Lunar Eclipse alert options"),
					MSBT_sticky	= {
						type	= 'toggle',
						name	= 'MikSBT Sticky',
						hidden	= function() return not MikSBT end,
						desc	= "Make the MikSBT alert sticky",
						get		= function () return opt.warning_text.MSBT_sticky end,
						set		= function () switch(opt.warning_text,"MSBT_sticky") end,
						order	= getOrder(),
					},
					MSBT_scrollArea	= {
						type = 'select',
						name = "MikSBT scroll area",
						desc = nil,
						hidden	= function() return not MikSBT end,
						get		= function () return opt.warning_text.MSBT_scrollArea end,
						set		= function (_, new) opt.warning_text.MSBT_scrollArea = new; end,
						values	= function () 
									local ret = {}
									for scrollAreaKey, scrollAreaName in MikSBT.IterateScrollAreas() do
										ret[scrollAreaKey] = scrollAreaName
									end
								
									return ret
								end,
						order = getOrder(),
					},
					MSBT_outlineIndex	= {
						type = 'range',
						name = "MikSBT Outline Index",
						desc = nil,
						hidden	= function() return not MikSBT end,
						min	= 0,
						max	= 6,
						step = 1,
						get		= function () return opt.warning_text.MSBT_outlineIndex end,
						set		= function (_, new) opt.warning_text.MSBT_outlineIndex = new; end,
						order = getOrder(-1),
					},
				},
			},
			default_art = {
			    type	= 'group',
				name	= "Default art bar",
				order	= getOrder(),
				hidden	= not moduleUsable("default_art"),
				disabled = function() return not moduleLoaded("default_art") end,
				args ={
					reset	= CreateExecute(0,"Reset bar","Reset default art bar settings",function () opt.default_art = nil; Propagate(); end,true,"Reset cannot be undone"),
					move	= CreateToogle(nil,'Move freely',"Move the bar by dragging it","default_art","moving"),
					x	= CreateRange(nil,"X",-900,900,1,"default_art","x"),
					y	= CreateRange(nil,"Y",-600,600,1,"default_art","y"),
					point	= CreateSelect(nil,"Anchor point","default_art","point",points),
					strata	= {
						type	= 'select',
						name	= "Layer",
						get		= function () return searchKey(strata,opt.default_art.strata); end,
						set		= function(_,new) opt.default_art.strata=strata[new]; Propagate() end,
						values	= function () return strata end,
						order	= getOrder(),
					},
					scale	= CreateRange(nil,"Scale",0.5,4,0.05,"default_art","scale"),
					header1 = CreateHeader(nil,""),		
					showIconsOnly = CreateToogle(nil,'Show icons only',"Show moon & sun icons only, hide the bar","default_art","showIconsOnly"), 
					iconSeparation	= {
						type = 'range',
						name = "Icon offset",
						desc = nil,
						min	= -70,
						max	= 300,
						step = 1,
						get		= function () return (opt.default_art.iconSeparation or 0)*2 end,
						set		= function (_, new) opt.default_art.iconSeparation = new/2; Propagate() end,
						order = getOrder(),
					},
					visibility ={
						name	= "Visibility",
						type	= 'group',
						order	= getOrder(),
						args	= {
							alpha	= CreateRange(0,"Alpha",0,1,0.05,"default_art","alpha"),
							alphaOOC	= CreateRange(nil,"Alpha out of combat",0,1,0.05,"default_art","alphaOOC"),
							showInAll	= CreateToogle(nil,'Show in all forms',nil,"default_art","showInAllStances"),
							showCustomize	= {
								type	= 'multiselect',
								disabled = function () return (not moduleLoaded("default_art")) or opt.default_art.showInAllStances; end,
								name	= "Customizable show in form",
								get		=	function(_,keyname)	return opt.default_art and opt.default_art.custom and opt.default_art.custom[keyname]; end,
								set		= 	function(_,keyname, state)
												opt.default_art.custom[keyname] = state;
												if keyname == 27 then
													opt.default_art.custom[29] = state; --normal flight form
												end
												Propagate();
											end,
								values	= function () return {[1]="Cat",[5]="Bear",[31]="Moonkin",[27]="Flight",[3]="Travel",[4]="Aquatic",[0]="Humanoid"} end,
								order	= getOrder(-1),
							},
						}
					},
					text ={
						name	= "Arrow & text options",
						type	= 'group',
						order	= getOrder(),
						args	= {
							predictOnArrow	= CreateToogle(0,'Predict','Show predicted energy on arrow and text',"default_art","predict"),

							showValue	= CreateToogle(nil,'Show text',nil,"default_art","showValue"),
							moveTextOutOfTheWay	= CreateToogle(nil,'Move text',"Move text when arrow is over it.","default_art","moveTextOutOfTheWay",function () return not opt.default_art.showValue end),
							absoluteText	= CreateToogle(nil,'Show always positive values',nil,"default_art","absoluteText",function () return not opt.default_art.showValue end),
							autoFontSize	= CreateToogle(nil,'Auto font size',nil,"default_art","autoFontSize",function () return not opt.default_art.showValue end),
							font	= CreateSelect(nil,"Font","default_art","font",me.data.font,function() return not opt.default_art.showValue end),
							fontSize	= CreateRange(-1,"Font size",10,32,1,"default_art","fontSize",function () return (not opt.default_art.showValue) or opt.default_art.autoFontSize end)
						}
					},	
					color ={
						name	= "Color",
						type	= 'group',
						order	= getOrder(-1),
						args	= {
								textColor	= CreateColor(1,"Text","default_art","textColor"),
						},
					},
				}
			},
		}, 
	} 

	LibStub("AceConfig-3.0"):RegisterOptionsTable(BPT.name,options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(BPT.name,BPT.name)
end

local frame = CreateFrame("Frame",nil,UIParent)
frame:SetScript("OnEvent",CreateOptions)
frame:RegisterEvent("ADDON_LOADED");