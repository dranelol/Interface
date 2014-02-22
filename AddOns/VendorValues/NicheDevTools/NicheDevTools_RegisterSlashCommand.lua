
do
	local NDT = NicheDevTools;
	if (NDT == nil) then
		NDT = {};
		NicheDevTools = NDT;
	end
	
	if (NDT.RegisterSlashCommand == nil) then
		local function l_HandleSlashCommand(name, info, command)
			local subcommand, args = command:match("^(%S+) (.+)$");
			subcommand = (subcommand or command):lower();
			
			local func = info[subcommand];
			if (func ~= nil) then
				local success, errorText = pcall(func, args);
				if (success == false) then
					DEFAULT_CHAT_FRAME:AddMessage(errorText);
					local helpText = info[false];
					if (helpText ~= nil) then
						subcommand = ("^" .. subcommand:gsub("%-", "%%%1"));
						local index = 2;
						local text = helpText[2];
						while (text ~= nil and text:find(subcommand) == nil) do
							index = (index + 1);
							text = helpText[index];
						end
						if (text ~= nil) then
							DEFAULT_CHAT_FRAME:AddMessage(text);
						end
					end
				end
			else
				local helpText = info[false];
				if (helpText ~= nil) then
					DEFAULT_CHAT_FRAME:AddMessage(name .. ": " .. helpText[1]:format(command));
					for index = 2, #helpText, 1 do
						DEFAULT_CHAT_FRAME:AddMessage(helpText[index]);
					end
				end
			end
		end
		
		NDT.RegisterSlashCommand = function(name, info, prefix1, prefix2)
			hash_SlashCmdList[name] = nil;
			SlashCmdList[name] = (function(command) l_HandleSlashCommand(name, info, command); end);
			_G["SLASH_" .. name .. "1"] = prefix1;
			_G["SLASH_" .. name .. "2"] = prefix2;
		end
	end
end
