
do
	local blankFunc = DoNothing;
	if (blankFunc == nil) then
		blankFunc = (function() end);
		DoNothing = blankFunc;
	end
	
	GuildFrameControlButton:Enable();
	GuildFrameControlButton.Disable = blankFunc;
	
	GuildMemberDetailOfficerNoteLabel:Show();
	GuildMemberDetailOfficerNoteLabel.Hide = blankFunc;
	GuildMemberOfficerNoteBackground:Show();
	GuildMemberOfficerNoteBackground.Hide = blankFunc;
	
	GuildMemberDetailFrame:SetHeight(GUILD_DETAIL_OFFICER_HEIGHT);
	GuildMemberDetailFrame.SetHeight = blankFunc;
end
