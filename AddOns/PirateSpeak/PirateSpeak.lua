-- PirateSpeak by Blaquen - Black DragonFlight - lkraven@gmail.com
-- Currently maintained and updated by Imyself <Savvy> - Echo Isles (www.savvyguild.com)

-- Create our LibDataBroker Object
local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
local psBroker = ldb:NewDataObject("PirateSpeak", { 
	type = "data source",
	label = "Pirate Speak", 
	icon = "Interface\\AddOns\\PirateSpeak\\icon",
	text = "--"
	}
	)


-- Event Handler
local function OnEvent(self, event, addOnName)
	if event == "ADDON_LOADED" and addOnName:lower() == "piratespeak" then

		-- Build our slash commands
		PirateSpeak_OnLoad()

		-- set saved variables for first time users		
		if pirate_talk_on == nil then
   			pirate_talk_on = 1;
  		end
  		if pirate_strict_on == nil then
   			pirate_strict_on = 0; 
  		end

		--  Get our speak tables
		if speakDB == nil then
			CreateSpeakDB()
		end 
			

		-- set the status text of our LDB object
		if (pirate_talk_on == 1) then
			psBroker.text = "|c0000FF00ON |r"
		else
			psBroker.text = "|c00FF0000OFF|r"
		end		
 	elseif event == "PLAYER_LOGOUT" then
		
	end
	OnEvent= nil;
	self:SetScript("OnEvent",nil);
end

-- Create our frame
local psFrame = CreateFrame("FRAME", "PirateSpeak");
psFrame:RegisterEvent("ADDON_LOADED");
psFrame:RegisterEvent("PLAYER_LOGOUT"); 
psFrame:SetScript("OnEvent", OnEvent);


function PirateSpeak_OnLoad()

	-- Create our slash commands
	SlashCmdList["PIRATESPEAKTOGGLE"] = pirate_toggle;
	SLASH_PIRATESPEAKTOGGLE1 = "/piratespeak";
	SLASH_PIRATESPEAKTOGGLE2 = "/pspeak";
	SlashCmdList["PSAY"] = pirate_say;
	SLASH_PSAY1 = "/ps";
	SLASH_PSAY2 = "/psay";
	SlashCmdList["PYELL"] = pirate_yell;
	SLASH_PYELL1 = "/py";
	SLASH_PYELL2 = "/pyell";
	SlashCmdList["PPARTY"] = pirate_party;
	SLASH_PPARTY1 = "/pp";
	SLASH_PPARTY2 = "/pparty";
	SlashCmdList["PGUILD"] = pirate_guild;
	SLASH_PGUILD1 = "/pg";
	SLASH_PGUILD2 = "/pguild";
	SlashCmdList["PSTRICTTOGGLE"] = pirate_strict;
	SLASH_PSTRICTTOGGLE1 = "/pstrict";

	-- announce addon load
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage("PirateSpeak loaded. Yaar, talk like a pirate!");
	end
end


-- Blizzard function to be hooked
local PirateSpeak_SendChatMessage = SendChatMessage;

-- Wintertime and Pirate Speak conflict.
-- If we detect Wintertime we'll note the channel and stay off of it
local wtID, wtName = GetChannelName("WinterTimeGlobal")

function SendChatMessage(msg, system, language, chatnumber) 
	--DEFAULT_CHAT_FRAME:AddMessage("Channel ID: "..chatnumber.." message: "..msg.." ChannelName: "..wtID .. ", " .. wtName);
    if (pirate_talk_on == 1 and msg ~= "" and (string.find(msg, "%[") == nil)) then 
	if ( string.find(msg, "^%/") == nil ) and (chatnumber ~= wtID) then
          msg = piratespeak(msg);
	end
    end
    PirateSpeak_SendChatMessage(msg, system, language, chatnumber);
end 


function prepend_pirate(inputString)
	local phrase_array = speakDB["pirateSpeak_PrependDB"]
	if (pirate_strict_on == 0) then
		inputString = phrase_array[math.random(table.getn(phrase_array))]..inputString
	end
	return inputString
end

function append_pirate(inputString)
 	local phrase_array = speakDB["pirateSpeak_AppendDB"]
	if (pirate_strict_on == 0) then
		inputString = string.gsub(inputString, '([%.%!%?])', phrase_array[math.random(table.getn(phrase_array))].."%1",1)
	end 
	return inputString
end

function sub_pirate(inputString)

	local cur_sub = {}
	local sub_array = speakDB["pirateSpeak_ReplaceDB"]
	
	inputString = string.gsub(inputString, "(%s)", inject_pirate)

	for i = 1, table.getn( sub_array ) do
		cur_sub['o']=sub_array[i]['o']
		cur_sub['r']=sub_array[i]['r']
		for y = 1, table.getn(cur_sub.o) do
			local searchPtn = cur_sub.o[y]
			inputString = string.gsub(inputString, searchPtn, cur_sub.r[math.random(table.getn(cur_sub.r))])
			if ( string.find(searchPtn, "%%") == nil ) then 
				inputString = string.gsub(inputString, string.gsub(searchPtn, "%l", string.upper,1), string.gsub(cur_sub.r[math.random(table.getn(cur_sub.r))], "%l", string.upper,1))
			end
			if ( string.find(searchPtn, "%%") == nil ) then 
				inputString = string.gsub(inputString, string.gsub(searchPtn, "%l", string.upper), string.gsub(cur_sub.r[math.random(table.getn(cur_sub.r))], '%l', string.upper))
			end
		end
	end
	return inputString
end

function inject_pirate(inputString)
	if ( math.random(100) > 98 and pirate_strict_on == 0) then
		inputString = ", yarrr, "
	end
	return inputString
end

function piratespeak(x)
	x = sub_pirate(x)
	if (math.random(100) > 75 ) then
		x = append_pirate(x)
	else
		if(math.random(100) > 50 and pirate_strict_on == 0) then
			x = x .. " Arrr!"
		end
	end
	if ( math.random(100) > 75 ) then
		x = prepend_pirate(x)
	end
	return x;
end

function pirate_toggle(toggle)
	if ( toggle == "on" ) then
		pirate_talk_on = 1
		psBroker.text = "|c0000FF00ON|r"
		DEFAULT_CHAT_FRAME:AddMessage("Pirate talk is on. Arr!")
	elseif ( toggle == "off" ) then
		pirate_talk_on = 0
		psBroker.text = "|c00FF0000OFF|r"
		DEFAULT_CHAT_FRAME:AddMessage("Pirate talk is off.  Arr. :(")
	else	
		DEFAULT_CHAT_FRAME:AddMessage(pirate_helptext(helptext))
	end
end

function pirate_strict(toggle)
	if ( toggle == "on" ) then
		pirate_strict_on = 1
		DEFAULT_CHAT_FRAME:AddMessage("Pirate Speak append, prepend and inject phrases are off")
	elseif ( toggle == "off" ) then
		pirate_strict_on = 0
		DEFAULT_CHAT_FRAME:AddMessage("Pirate Speak append, prepend and inject phrases are on")
	else
		helptext = ""
		DEFAULT_CHAT_FRAME:AddMessage(pirate_helptext(helptext))
	end
end

function pirate_helptext(helptext)
	helptext = "/pspeak (" 
	if (pirate_talk_on == 1) then
		helptext = helptext .. "|c0000FF00on|r|off)"
	else
		helptext = helptext .. "on| |c00FF0000off|r)"
	end
	helptext = helptext .. ": toggle global pirate talk\n/ps,/psay: say something in pirate\n/py,/pyell: yell something in pirate\n/pp,/pparty: party talk something in pirate\n/pg, /pguild: guildtalk in pirate\n/"
	helptext = helptext .. "pstrict ("
	if (pirate_strict_on == 1) then
		helptext = helptext .. "|c0000FF00on|r|off)"
	else
		helptext = helptext .. "on| |c00FF0000off|r)"
	end
	helptext = helptext .. " enables/disables prepend, apend and inject phrases\n"
	return helptext
end


function pirate_say(x)
	x = piratespeak(x)
	SendChatMessage(x);
end

function pirate_yell(x)
	x = piratespeak(x)
	SendChatMessage(x,"YELL");
end

function pirate_party(x)
	x = piratespeak(x)
	SendChatMessage(x,"PARTY");
end

function pirate_guild(x)
	x = piratespeak(x)
	SendChatMessage(x,"GUILD");
end

-- LibDataBroker Functions

-- Create the LDB tooltip
function psBroker:OnTooltipShow()
	statusLine = "Pirate Speak is "
	if (pirate_talk_on == 1) then
		statusLine = statusLine .. "|c0000FF00ON|r"
		if (pirate_strict_on == 1) then
			statusLine = statusLine .. " (strict mode)"			
		else
			statusLine = statusLine .. " (verbose mode)"
		end
	else
		statusLine = statusLine .. "|c00FF0000OFF|r"
	end 
	self:AddLine(statusLine);
	self:AddLine("Left Click toggles Pirate Speak on and off", 1, 1, 1);
    	self:AddLine("Right Click toggles betrween strict and verbose", 1, 1, 1);
    	self:AddLine(" ", 1, 1, 1);
    	self:AddLine("type: /pspeak for command line options", 1, 1, 1);
   
end


-- Toggles functions based on LDB button clicks
function psBroker:OnClick(button)
	if button== "LeftButton" then
		if (pirate_talk_on == 1) then
			pirate_toggle("off")
			psBroker.text = "|c00FF0000OFF|r"
		else
			pirate_toggle("on")
			psBroker.text = "|c0000FF00ON |r"
		end
	elseif button== "RightButton" then
		if (pirate_strict_on == 1) then
			pirate_strict("off")
		else
			pirate_strict("on")
		end
	end
end

-- Create default speak tables

function CreateSpeakDB()
	local pirateSpeak_PrependDB = {
	"Arr! ",
	"Avast! ",
	"Shiver me timbers! ",
	"Ahoy! ",
	"Begad! ",
	"Yarr! ",
	"Blimey! ",
	"Me hearties! ",
	"No quarter! ",
	"Sail ho! ",
	"Sink me! ",
	}
	local pirateSpeak_AppendDB = {
	", ye scurvy dog",
	", matey",
	", or I not be a pirate.  Arrr",
	", by the briny deep",
	", arrrr",
	", landlubber",
	", arrr",
	", arr",
	", yarrr",
	", yarr",
	", thar she blows",
	", scurvy scum",
	", swabby",
	", ye old dog",
	", ye dog",
	", salty dog"
	}
	local pirateSpeak_ReplaceDB = {
	{o={"hello","hiya","^hi there"}, r={"ahoy","avast","ahoy thar"}},
	{o={"^hi "}, r={"ahoy ","avast ","ahoy thar "}},
	{o={" hi "}, r={"ahoy ","avast ","ahoy thar "}}, 
	{o={"^hey[a]?"}, r={"ahoy","avast","ahoy thar"}},
	{o={"thanks", "thank you", " ty ", "^ty ", "^thx ", " thx "}, r={"ye have me gratitude", "I be in yer debt", "thank ye kindly"}},
	{o={"([%A%s])[Hh]e"}, r={"%1%'e"}},
	{o={"^he"}, r={"'e"}},
	{o={" are "," is ", " am "}, r={" be "}},
	{o={"^is ", "^are ", "^am "}, r={"be "}},
	{o={"i'm"}, r={"i be"}},
	{o={"y[eu][sp]"}, r={"aye"}},
	{o={"idiotic","crazy","insane","stupid"}, r={"addled","boozled","bamboozled"}},
	{o={"rear"}, r={"aft"}},
	{o={"loot"}, r={"booty","swag","treasure"}},
	{o={"sea","ocean"}, r={"briny deep","wide blue"}},
	{o={"bosses"}, r={"cap'ns"}},
	{o={"sir","boss","leader"}, r={"cap%'n"}},
	{o={"fool","moron","jerk","dork","idiot"}, r={"blaggard","sea scum","addlepate","scurvy mutt","damn fool","landlubber"}},
	{o={"sword"}, r={"cutlass","blade"}}, 
	{o={"dagger"}, r={"kitchen blade", "dirk"}},
	{o={"mace"}, r={"bludgeon", "wooden leg"}},
	{o={"axe"}, r={"sharp broomstick", "cleaver"}},
	{o={"my "}, r={"me "}},
	{o={"your"}, r={"yar"}},
	{o={"you%'re"}, r={"yar"}},
	{o={"you"}, r={"ye"}},
	{o={"beer","wine","vodka","booze"}, r={"grog","mead","rum","ale"}},
	{o={" hit"}, r={" flog"," slug"}},
	{o={"quickly"}, r={"smartly"}},
	{o={"flagged"}, r={"black marked"}},
	{o={"^np","no problem"}, r={"it be nothin'", "it be no mattar"}},
	{o={"auction house"}, r={"swag exchange", "loot market"}},
	{o={"^ah$"}, r={"swag exchange", "loot market"}},
	{o={" ah$"}, r={" swag exchange", " loot market"}},
	{o={" ah "}, r={" swag exchange", " loot market" }},
	{o={"flag"}, r={"Jolly Roger"}},
	{o={"lady","girl","chick","woman","babe"}, r={"lass","lassie","wench"}},
	{o={"boy"}, r={"laddy"}},
	{o={"guys"}, r={"hearties","merry crew"}},
	{o={"copper"}, r={"fool%'s gold"}},
	{o={"silver"}, r={"pieces o%' eight"}},
	{o={"attack"}, r={"pillage"}},
	{o={" of "}, r={" 'o "}},
	{o={"kill"}, r={"keelhaul","marder"}},
	{o={"killed"}, r={"keelhauled","mardered"}},
	{o={"omw"}, r={"I be comin'","still yer sails, I be comin'"}},
	{o={"jk","j%/k"}, r={"it war a joke.","i be keedin'","a joke, matey"}},
	{o={"lol","hehe","haha","rofl","roflmao"}, r={"that tickles me wooden leg!", "har har!", "that war funny! har!", "me sides are splittin' in laughter!", "haaar!", "I be laughin'!","Yo ho ho!"}},
	{o={"afk","brb","biab"}, r={"I be steppin out far a sec", "I be right back", "man the wheel, I be returnin' in a blink"}},
	{o={"gp"}, r={"doubloons"}},
	{o={"where"}, r={"whar"}},
	{o={"let's"}, r={"let us"}},
	{o={"(%w+)'s (%w+)ing"}, r={"%1 be %2in'"}},
	{o={"(%d)s"}, r={"%1 pieces o%' eight"}},
	{o={"ing "}, r={"in' "}},
	{o={"(%d)g"}, r={"%1 doubloons"}},
	{o={"there"}, r={"thar"}},
	{o={"was"}, r={"war"}},
	{o={"gonna"}, r={"goin' ta"}},
	{o={"noob","n00b","newb"}, r={"sprog","blaggard"}},
	{o={"die"}, r={"go to Davy Jones's locker", "head to a watery grave", "be in Davy's grip"}},
	{o={"died"}, r={"went to Davy Jones's locker", "was sent to a watery grave", "be in Davy's grip"}},
	{o={"dead"}, r={"gone to Davy Jones's locker","headed to a watery grave", "be in Davy's grip"}},
	{o={"captain","gm"}, r={"cap'n"}},
	{o={"food"}, r={"grub"}},
	{o={"omg","omfg"}, r={"Begad!"}}
	}

	speakDB = {}	

	speakDB["pirateSpeak_PrependDB"] = pirateSpeak_PrependDB
	speakDB["pirateSpeak_AppendDB"] = pirateSpeak_AppendDB
	speakDB["pirateSpeak_ReplaceDB"] = pirateSpeak_ReplaceDB


	DEFAULT_CHAT_FRAME:AddMessage("speakDB initialized");
		
end