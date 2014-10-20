local _G = _G
local select = _G.select
local pairs = _G.pairs
local ipairs = _G.ipairs
local string = _G.string
local type = _G.type
local error = _G.error
local table = _G.table

ArkInventory.Lib.StaticDialog:Register( "BATTLE_PET_RENAME", {
	
	text = PET_RENAME_LABEL,
	hide_on_escape = true,
	show_while_dead = false,
	exclusive = true,
	
	buttons = {
		{
			text = ACCEPT,
			on_click = function( self )
				local text = self.editboxes[1]:GetText( )
				C_PetJournal.SetCustomName( self.data, text )
				PetJournal_UpdateAll( )
			end,
		},
		{
			text = PET_RENAME_DEFAULT_LABEL,
			on_click = function( self )
				C_PetJournal.SetCustomName( self.data, "" )
				PetJournal_UpdateAll( )
			end,
		},
		{
			text = CANCEL,
		},
	},
	
	editboxes = {
		{
			
			auto_focus = true,
			max_letters = 16,
			
			on_enter_pressed = function( editbox, data )
				local text = editbox:GetText( )
				C_PetJournal.SetCustomName( data, text )
				PetJournal_UpdateAll( )
				ArkInventory.Lib.StaticDialog:Dismiss( "BATTLE_PET_RENAME", data )
			end,
			
			on_escape_pressed = function( editbox, data )
				ArkInventory.Lib.StaticDialog:Dismiss( "BATTLE_PET_RENAME", data )
			end,
			
		},
	},
	
	on_show = function( self, data )
		self.editboxes[1]:SetText( ArkInventory.PetJournal.GetPetInfo( data ).customName or "" )
	end,
	
} )

ArkInventory.Lib.StaticDialog:Register( "BATTLE_PET_RELEASE", {
	
	hide_on_escape = true,
	show_while_dead = false,
	exclusive = true,
	
	buttons = {
		{
			text = OKAY,
			on_click = function( self )
				C_PetJournal.ReleasePetByID( self.data )
				if ( PetJournalPetCard.petID == self.data ) then
					PetJournal_ShowPetCard( 1 )
				end
			end,
		},
		{
			text = CANCEL,
		},
	},
	
	on_show = function( self, data )
		
		local pd = ArkInventory.PetJournal.GetPetInfo( data )
		
		local qd = ""
		
		if pd.sd.isWild and pd.sd.canBattle then
			qd = _G[string.format( "ITEM_QUALITY%d_DESC", pd.rarity ) ]
			qd = string.format( ", %s%s|r", select( 5, ArkInventory.GetItemQualityColor( pd.rarity ) ), qd )
		end
		
		local text = string.format( "%s|r, %s %d%s", pd.fullName, LEVEL, pd.level, qd )
		
		self.text:SetText( string.format( PET_RELEASE_LABEL, text ) )
		
	end,
	
} )

ArkInventory.Lib.StaticDialog:Register( "BATTLE_PET_PUT_IN_CAGE", {
	
	text = PET_PUT_IN_CAGE_LABEL,
	hide_on_escape = true,
	show_while_dead = false,
	exclusive = true,
	
	buttons = {
		{
			text = OKAY,
			on_click = function( self )
				C_PetJournal.CagePetByID( self.data )
				if ( PetJournalPetCard.petID == self.data ) then
					PetJournal_ShowPetCard( 1 )
				end
			end,
		},
		{
			text = CANCEL,
		},
	},
	
} )

