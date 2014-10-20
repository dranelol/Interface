ArkInventoryRules_Example = LibStub( "AceAddon-3.0" ):NewAddon( "ArkInventoryRules_Example" )

function ArkInventoryRules_Example:OnEnable( )
	
	-- register your rule function: example( )
	-- and what function gets called to process the rule
	
	--ArkInventoryRules.Register( self, "example", ArkInventoryRules_Example.Execute )
	
	-- note: if you require another mod to be loaded you will need to add it in the .toc file
	-- in which case make sure you check that that mod actually got loaded (it might not be installed)
	
end

function ArkInventoryRules_Example.Execute( ... )

	-- always check for the hyperlink and that it's an actual item, not a spell (pet/mount)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= "item" then
		return false
	end
	
	local fn = "example" -- your rule name, needs to be set so that error messages are readable
	
	local ac = select( '#', ... )
	
	-- if you need at least 1 argument, this is how you check, if you dont need any arguments then you need to remove this part or rewrite it to suit your needs
	if ac == 0 then
		error( string.format( ArkInventory.Localise["RULE_FAILED_ARGUMENT_NONE_SPECIFIED"], fn ), 0 )
	end
	
	for ax = 1, ac do -- loop through the supplied ... arguments
		
		local arg = select( ax, ... ) -- select the argument were going to work with
		
		-- this code checks item quality, either as text or as a number
		-- your best bet is to check the existing system rules to find one thats close to what you need an modify it to suit your needs
		-- all you have to do is ensure that you return true (matched your criteria) or false (failed to match)
		
		if type( arg ) == "number" then
			
			if arg == ArkInventoryRules.Object.q then
				return true
			end
			
		elseif type( arg ) == "string" then
			
			if string.lower( string.trim( arg ) ) == string.lower( _G[string.format( "ITEM_QUALITY%d_DESC", ArkInventoryRules.Object.q )] ) then
				return true
			end
			
		else
			
			error( string.format( ArkInventory.Localise["RULE_FAILED_ARGUMENT_IS_NOT"], fn, ax, string.format( "%s or %s", ArkInventory.Localise["STRING"], ArkInventory.Localise["NUMBER"] ) ), 0 )
			
		end
		
	end
	
	-- always return false at the end
	return false
	
end
