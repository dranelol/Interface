--[[ TinyPad 1.9 is a notepad addon ]]

-- SavedVariables
TinyPadPages = { "" } -- numerically-indexed table of pages
TinyPadSettings = {} -- Lock, Font

TinyPad = {

	-- tooltip info for controls
	controls = {
		{"TinyPadNew","New Page","Create a new page at end of book.\n\124cFFA5A5A5Hold Shift to insert after current page."},
		{"TinyPadDelete","Delete Page","Permanently remove this page.\n\124cFFA5A5A5Hold Shift to delete without confirmation."},
		{"TinyPadRun","Run Page","Run this page as a script."},
		{"TinyPadStart","First Page","Go to first page.\n\124cFFA5A5A5Hold Shift to move this page to the first page."},
		{"TinyPadLeft","Flip Back","Go back one page.\n\124cFFA5A5A5Hold Shift to move this page back one page."},
		{"TinyPadRight","Flip Forward","Go forward one page.\n\124cFFA5A5A5Hold Shift to move this page forward one page."},
		{"TinyPadEnd","Last Page","Go to the last page.\n\124cFFA5A5A5Hold Shift to move this page to the last page."},
		{"TinyPadClose","Close TinyPad","Close this window."},
		{"TinyPadLock","Lock","Lock or Unlock window."},
		{"TinyPadFont","Font","Cycle through different fonts."},
		{"TinyPadSearch","Options","Search pages for text, change fonts or lock window."},
		{"TinyPadSearchNext","Find Next","Find next page with this text"},
		{"TinyPadSearchEditBox","Search Criterea","Enter the text to search for here."},
		{"TinyPadUndo","Undo","Revert page to last saved text."},
		{"TinyPadBookmarks","Bookmarks","Go to a bookmarked page or manage bookmarks."},
		{"TinyPadBookmarkAdd","Save Bookmark","Bookmark this page with the title entered to the left."},
		{"TinyPadBookmarkAddButtonFrame","Save Bookmark","Bookmark this page with a named title."},
		{"TinyPadBookmarkEditBox","Bookmark Title","Enter a title for the bookmark here and hit the Enter key or the Save button to the right."},
		{"TinyPadBookmarkDeleteButtonFrame","Delete Bookmark","Remove the bookmark to this page."},
	},

	-- list of fonts to cycle through
	fonts = {
		{"Fonts\\FRIZQT__.TTF",10},
		{"Fonts\\FRIZQT__.TTF",12}, -- default
		{"Fonts\\FRIZQT__.TTF",16},
		{"Fonts\\ARIALN.TTF",12},
		{"Fonts\\ARIALN.TTF",16},
		{"Fonts\\ARIALN.TTF",20},
		{"Fonts\\MORPHEUS.ttf",16,"OUTLINE"},
		{"Fonts\\MORPHEUS.ttf",24,"OUTLINE"}
		-- add fonts here
	},

	current_page = 1, -- page currently viewed
	first_use = 1, -- whether this was used this session
	has_focus = nil, -- whether editbox has focus (set/reset OnFocusGained/Lost)
	last_viewed_trade = nil, -- for tradeskill panel toggling

}

BINDING_HEADER_TINYPAD = "TinyPad"
StaticPopupDialogs["TINYPADCONFIRM"] = { text = "Delete this page?", button1 = "Yes", button2 = "No", timeout = 0, whileDead = 1, OnAccept = function() TinyPad.DeletePage() end}

function TinyPad.OnLoad(self)
	self:SetMinResize(260,96)
	table.insert(UISpecialFrames,"TinyPadFrame")
	table.insert(UISpecialFrames,"TinyPadSearchFrame")
	table.insert(UISpecialFrames,"TinyPadBookmarkFrame")

	SlashCmdList["TINYPADSLASH"] = TinyPad.SlashHandler
	SLASH_TINYPADSLASH1 = "/pad"
	SLASH_TINYPADSLASH2 = "/tinypad"
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("ADDON_LOADED")
end

function TinyPad.OnEvent(self,event,...)
	if event=="PLAYER_LOGIN" then
		TinyPadSettings.Font = TinyPadSettings.Font or 2
		TinyPad.UpdateFont()
		TinyPad.UpdateLock()

		TinyPad.oldChatEdit_InsertLink = ChatEdit_InsertLink
		ChatEdit_InsertLink = TinyPad.newChatEdit_InsertLink
		TinyPad.oldQuestLogTitleButton_OnClick = QuestLogTitleButton_OnClick
		QuestLogTitleButton_OnClick = TinyPad.newQuestLogTitleButton_OnClick
		TinyPad.oldChatEdit_DeactivateChat = ChatEdit_DeactivateChat -- new 3.3.5
		ChatEdit_DeactivateChat = TinyPad.newChatEdit_DeactivateChat

		TinyPadEditFrame:SetBackdropColor(.1,.1,.1,1)
		TinyPadSearchFrame:SetBackdropColor(.3,.3,.3,1)
		TinyPadBookmarkFrame:SetBackdropColor(.2,.2,.2,1)

		TinyPadBookmarkFrame.timer = 0

	elseif event=="ADDON_LOADED" then
		local addon = select(1,...)
		if addon=="Blizzard_TradeSkillUI" then
			TinyPad.oldTradeSkillLinkButton_OnClick = TradeSkillLinkButton:GetScript("OnClick")
			TradeSkillLinkButton:SetScript("OnClick",TinyPad.newTradeSkillLinkButton_OnClick)
		elseif addon=="Blizzard_AchievementUI" then
			TinyPad.oldAchievementButton_OnClick = AchievementButton_OnClick
			AchievementButton_OnClick = TinyPad.newAchievementButton_OnClick
		end
	end
end

--[[ Chat linking hooks ]]

function TinyPad.newAchievementButton_OnClick(self,...)
	if TinyPadEditBox:IsVisible() and TinyPad.has_focus and IsModifiedClick("CHATLINK") then
		TinyPadEditBox:Insert(GetAchievementLink(self.id))
	else
		return TinyPad.oldAchievementButton_OnClick(self,...)
	end
end

function TinyPad.newTradeSkillLinkButton_OnClick(self,...)
	if TinyPadEditBox:IsVisible() and TinyPad.has_focus then
		TinyPadEditBox:Insert(GetTradeSkillListLink())
	else
		return TinyPad.oldTradeSkillLinkButton_OnClick(self,...)
	end
end

function TinyPad.newChatEdit_DeactivateChat(editBox)
	if TinyPadEditBox:IsVisible() and MouseIsOver(TinyPadEditBox) and IsModifiedClick("CHATLINK") then
		return
	else
		return TinyPad.oldChatEdit_DeactivateChat(editBox)
	end
end

function TinyPad.newChatEdit_InsertLink(text)
	if TinyPadEditBox:IsVisible() and TinyPad.has_focus then
		return TinyPadEditBox:Insert(text)
	else
		return TinyPad.oldChatEdit_InsertLink(text)
	end
end

function TinyPad.newQuestLogTitleButton_OnClick(self, button)
	if TinyPadEditBox:IsVisible() and TinyPad.has_focus then
		local questLink = GetQuestLink(self:GetID() + FauxScrollFrame_GetOffset(QuestLogScrollFrame))
		if questLink then
			return TinyPadEditBox:Insert(questLink)
		end
	end
	return TinyPad.oldQuestLogTitleButton_OnClick(self, button)
end

--[[ Slash commands ]]

-- /pad # will go to a page, /pad run # will run a page, /pad alone toggles window
function TinyPad.SlashHandler(msg)
	msg = (msg or ""):lower()
	local page = string.match(msg,"(%d+)")
	if msg=="run" then
		RunScript(TinyPad.GetPageText())
	elseif page then
		page = tonumber(page)
		if TinyPadPages[page] then
			if string.find(string.lower(msg),"run") then
				RunScript(TinyPad.GetPageText(page))
			else
				TinyPad.current_page = page
				TinyPad.ShowPage()
			end
		else
			print(format("TinyPad: Page %d doesn't exist.",page))
		end
	else
		TinyPad.Toggle()
	end
end

-- toggles window on/off screen
function TinyPad.Toggle()
	if TinyPadFrame:IsVisible() then
		TinyPadFrame:Hide()
	else
		TinyPadFrame:Show()
	end
end

-- window movement
function TinyPad.StartMoving(self)
	if not TinyPadSettings.Lock then
		TinyPadFrame:StartMoving()
	end
end

function TinyPad.StopMoving(self)
	TinyPadFrame:StopMovingOrSizing()
end

function TinyPad.Tooltip(self)
	local which = self:GetName()
	for i in pairs(TinyPad.controls) do
		if TinyPad.controls[i][1]==which then
			GameTooltip_SetDefaultAnchor(GameTooltip,UIParent)
			GameTooltip:AddLine(TinyPad.controls[i][2])
			GameTooltip:AddLine(TinyPad.controls[i][3],.85,.85,.85,1)
			GameTooltip:Show()
			return
		end
	end
end

-- Titlebar button clicks
function TinyPad.OnClick(self)

	local which = self:GetName()
	local new_page
	local book = TinyPadPages

	-- actions which don't save the current page go here (make sure to return)

	if which=="TinyPadUndo" then
		TinyPadEditBox:SetText(TinyPad.GetPageText())
		return
	elseif which=="TinyPadLock" then
		TinyPadSettings.Lock = not TinyPadSettings.Lock
		TinyPad.UpdateLock()
		return
	elseif which=="TinyPadFont" then
		TinyPadSettings.Font = TinyPadSettings.Font+1
		TinyPad.UpdateFont()
		return
	elseif which=="TinyPadSearch" then
		if TinyPadSearchFrame:IsVisible() then
			TinyPadSearchFrame:Hide()
		else
			TinyPadSearchFrame:Show()
		end
		return
	elseif which=="TinyPadSearchNext" then
		TinyPad.DoSearch()
		return
	elseif which=="TinyPadDelete" then
		if not IsShiftKeyDown() and TinyPad.GetPageText():len()>0 then
			StaticPopup_Show("TINYPADCONFIRM")
		else
			TinyPad.DeletePage() -- delete empty pages without confirmation
		end
		return
	elseif which=="TinyPadBookmarks" then
		if TinyPadBookmarkFrame:IsVisible() then
			TinyPadBookmarkFrame:Hide()
		else
			TinyPadBookmarkFrame:Show()
		end
	elseif which=="TinyPadBookmarkAdd" then
		TinyPad.BookmarkEditBoxOnEnterPressed()
		return
	end

	TinyPad.SaveCurrentPage()

	-- actions which save the current page go here

	if which=="TinyPadNew" then
		if not IsShiftKeyDown() then
			table.insert(book,"")
			new_page = table.getn(book)
		else
			table.insert(book,TinyPad.current_page+1,"")
			new_page = TinyPad.current_page + 1
		end
	elseif which=="TinyPadRun" then
		TinyPadUndo:Disable()
		RunScript(TinyPad.GetPageText())
	elseif which=="TinyPadStart" then
		if IsShiftKeyDown() then
			local body = TinyPad.GetPageText()
			local bookmark = TinyPad.GetPageText(nil,1)
			table.remove(book,TinyPad.current_page)
			TinyPad.Insert(body,1,bookmark)
		else
			new_page = 1
		end
	elseif which=="TinyPadLeft" then
		if IsShiftKeyDown() then
			TinyPad.SwapPages(TinyPad.current_page,TinyPad.current_page-1)
		end
		new_page = math.max(TinyPad.current_page-1,1)
	elseif which=="TinyPadRight" then
		if IsShiftKeyDown() then
			TinyPad.SwapPages(TinyPad.current_page,TinyPad.current_page+1)
		end
		new_page = math.min(TinyPad.current_page+1,#(book))
	elseif which=="TinyPadEnd" then
		if IsShiftKeyDown() then
			local body = TinyPad.GetPageText()
			local bookmark = TinyPad.GetPageText(nil,1)
			table.remove(book,TinyPad.current_page)
			TinyPad.Insert(body,nil,bookmark)
		else
			new_page = #(book)
		end
	elseif which=="TinyPadClose" then
		TinyPadFrame:Hide()
	end

	if new_page then
		TinyPad.current_page = new_page
		TinyPad.ShowPage()
	end
end

--[[ Page management ]]

function TinyPad.SaveCurrentPage()
	local book = TinyPadPages
	if type(book[TinyPad.current_page])=="table" then
		book[TinyPad.current_page][2] = TinyPadEditBox:GetText()
	else
		book[TinyPad.current_page] = TinyPadEditBox:GetText()
	end
end

-- removes the current page
function TinyPad.DeletePage()
	local book = TinyPadPages
	table.remove(book,TinyPad.current_page)
	if #(book)==0 then
		table.insert(book,"")
	end
	TinyPad.current_page = math.min(TinyPad.current_page,#(book))
	TinyPad.ShowPage()
end

function TinyPad.SwapPages(page1,page2)
	local book = TinyPadPages
	local scratchPage,scratchBookmark

	if not book[page1] or not book[page2] or page1==page2 then
		return
	end
	
	if type(book[page1])=="table" then
		scratchBookmark = book[page1][1]
		scratchPage = book[page1][2]
	else
		scratchPage = book[page1]
	end
	if type(book[page2])=="table" then
		book[page1] = {book[page2][1],book[page2][2]}
		if scratchBookmark then
			book[page2] = {scratchBookmark,scratchPage}
		else
			book[page2] = scratchPage
		end
	else
		book[page1] = book[page2]
		if scratchBookmark then
			book[page2] = {scratchBookmark,scratchPage}
		else
			book[page2] = scratchPage
		end
	end
end

function TinyPad.GetPageText(page,bookmark)
	local book = TinyPadPages
	if not page then
		page = TinyPad.current_page
	end
	if type(book[page])=="table" then
		if bookmark then
			return book[page][1]
		else
			return book[page][2]
		end
	elseif not bookmark then
		return book[page]
	end
end

function TinyPad.GetPageBookmark(page)
	return TinyPad.GetPageText(page,1)
end

function TinyPad.SavePageText(page,text)
	local book = TinyPadPages
	if type(book[page])=="table" then
		book[page][2] = text
	else
		book[page] = text
	end
end

-- for use in macros, TinyPad.Run(#) to run a page
function TinyPad.Run(page)
	if page and tonumber(page) then
		TinyPad.SlashHandler("run "..page)
	end
end

-- called by TinyPad.DeletePagesContaining, use that instead of this
function TinyPad.DeletePagesByRegex(regex)
	for i=1,#TinyPadPages do
		if regex and TinyPad.GetPageText(i):match(regex) then
			table.remove(TinyPadPages,i)
			return 1
		end
	end
end

-- this will delete all pages that contain a regex (ie "^Glyphioneer Suggestions"
-- will delete all pages that begin (^) with "Glyphioneer Suggestions".  This
-- is used primarily for addons that generate a report and want to clean up
-- old copies of data.  Use carefully!
function TinyPad.DeletePagesContaining(regex)
	if type(regex)=="string" then
		while TinyPad.DeletePagesByRegex(regex) do
			-- nothing
		end
		if #TinyPadPages==0 then
			table.insert(book,"")
		end
		TinyPad.current_page = math.min(TinyPad.current_page,#TinyPadPages)
		if TinyPadEditBox:IsVisible() then
			TinyPad.ShowPage()
		end
	end
end

-- for use by other addons or macros
function TinyPad.Insert(body,page,bookmark)
	if type(page)=="number" then
		page = math.max(math.min(page,#TinyPadPages),0) -- keep page in bounds
	elseif type(page)=="string" then
		bookmark = page -- if second parameter is a string, it's a bookmark
		page = nil
	end
	if bookmark then
		if page then
			table.insert(TinyPadPages,page,{bookmark,body})
		else
			table.insert(TinyPadPages,{bookmark,body})
		end
	elseif page then
		table.insert(TinyPadPages,page,body)
	else
		table.insert(TinyPadPages,body)
	end
	TinyPad.current_page = page and page or #TinyPadPages
	TinyPad.ShowPage()
end

-- disables/enables page movement buttons depending on page
function TinyPad.ValidateButtons()

	-- nil for disabled, 1 for enabled
	local function set_state(button,enabled)
		if enabled then
			button:SetAlpha(1)
			button:Enable()
		else
			button:SetAlpha(.5)
			button:Disable()
		end
	end

	set_state(TinyPadStart,1)
	set_state(TinyPadLeft,1)
	set_state(TinyPadRight,1)
	set_state(TinyPadEnd,1)

	if TinyPad.current_page==1 then
		set_state(TinyPadStart)
		set_state(TinyPadLeft)
	end
	if TinyPad.current_page==#(TinyPadPages) then
		set_state(TinyPadRight)
		set_state(TinyPadEnd)
	end

end

-- shows/updates the current page
function TinyPad.ShowPage()
	if not TinyPadFrame:IsVisible() then
		TinyPadFrame:Show()
	end
	local pageText = TinyPad.GetPageText()
	if pageText then
		TinyPadPageNum:SetText(TinyPad.current_page)
		TinyPadEditBox:SetText(pageText)
		TinyPad.ValidateButtons()
	end
end

-- refreshes window when shown
function TinyPad.OnShow(self)
	if TinyPad.first_use then
		-- only when the pad is first shown show last page
		TinyPad.current_page = #(TinyPadPages)
		TinyPad.first_use = nil
	end
	TinyPad.ShowPage()
	TinyPadEditBox:SetWidth(TinyPadFrame:GetWidth()-50)
end

-- saves page when window hides
function TinyPad.OnHide(self)
	TinyPad.SaveCurrentPage()
	TinyPadSearchFrame:Hide()
	TinyPadBookmarkFrame:Hide()
	TinyPadUndo:Disable()
	TinyPadEditBox:ClearFocus()
end

-- changes border and resize grip depending on lock status
function TinyPad.UpdateLock()
	if TinyPadSettings.Lock then
		TinyPadFrame:SetBackdropBorderColor(0,0,0,1)
		TinyPadSearchFrame:SetBackdropBorderColor(0,0,0,1)
		TinyPadResizeGrip:Hide()
	else
		TinyPadFrame:SetBackdropBorderColor(1,1,1,1)
		TinyPadSearchFrame:SetBackdropBorderColor(1,1,1,1)
		TinyPadResizeGrip:Show()
	end
	TinyPad.MakeESCable("TinyPadFrame",TinyPadSettings.Lock)
end

-- updates EditBox font to current settings
function TinyPad.UpdateFont()
	if TinyPadSettings.Font > #(TinyPad.fonts) then
		TinyPadSettings.Font = 1
	end
	local font = TinyPadSettings.Font
	TinyPadEditBox:SetFont(TinyPad.fonts[font][1],TinyPad.fonts[font][2],TinyPad.fonts[font][3])
end

-- adds frame to UISpecialFrames, removes frame if disable true
function TinyPad.MakeESCable(frame,disable)
	local idx
	for i=1,#(UISpecialFrames) do
		if UISpecialFrames[i]==frame then
			idx = i
			break
		end
	end
	if idx and disable then
		table.remove(UISpecialFrames,idx)
	elseif not idx and not disable then
		table.insert(UISpecialFrames,1,frame)
	end
end
	
-- when search summoned, remove ESCability of main window (only search cleared with ESC)
function TinyPad.SearchOnShow()
	TinyPad.MakeESCable("TinyPadFrame","disable")
end

-- when search dismissed, restore ESCability to main window and reset search elements
function TinyPad.SearchOnHide()
	if not TinyPadSettings.Lock then
		TinyPad.MakeESCable("TinyPadFrame")
	end
	TinyPadSearchResults:SetText("Search:")
	TinyPadSearchEditBox:ClearFocus()
end

-- used by search gsubs to create case-insensitive patterns
local function EitherAlpha(a)
	return "["..a:upper()..a:lower().."]"
end

-- does a count on search matches only
function TinyPad.SearchEditBoxOnChange()
	local search = TinyPadSearchEditBox:GetText() or ""

	if search:len()<1 then
		TinyPadSearchResults:SetText("Search:")
	else
		local count = 0
		-- prior method did a case-insensitive search by making both strings lower
		-- which creates a ton of garbage on 800+ page pads. current method is to
		-- format the search string to a [Cc][Aa][Ss][Ee]-insensitive pattern
		search = search:gsub("%a",EitherAlpha)
		for i=1,#(TinyPadPages) do
			count = count + (TinyPad.GetPageText(i):match(search) and 1 or 0)
		end
		TinyPadSearchResults:SetText(count.." found")
	end
end

-- performs a search for the text in the search box
function TinyPad.DoSearch()
	local search = TinyPadSearchEditBox:GetText() or ""

	if search:len()<1 then
		return
	end
	search = search:gsub("%a",EitherAlpha)
	local page = TinyPad.current_page
	for i=1,#(TinyPadPages) do
		page = page + 1
		if page > #(TinyPadPages) then
			page = 1
		end
		if TinyPad.GetPageText(page):match(search) then
			TinyPad.SaveCurrentPage()
			TinyPad.current_page = page
			TinyPad.ShowPage()
			return
		end
	end
end

--[[ Main editbox stuff ]]

function TinyPad.OnTextChanged(self)
	local scrollBar = _G[self:GetParent():GetName().."ScrollBar"]
	self:GetParent():UpdateScrollChildRect()
	local min, max = scrollBar:GetMinMaxValues()
	-- fix for line insert scrolling to end by gix
	if self.max and max > self.max and abs(self.max - floor(scrollbar:GetValue())) < 0.001 then
		scrollbar:SetValue(max)
		self.max = max
	end
	if self:GetText()~=TinyPad.GetPageText() then
		TinyPadUndo:Enable()
	else
		TinyPadUndo:Disable()
	end
end

-- This function happens OnMouseUp in TinyPadEditBox.  Originally it was to handle double clicks
-- for selecting words.  It did so by finding out where the caret was (original method by Tem
-- but replaced here with GetCursorPosition) and looking to left and right of the caret for spaces.
-- For 1.6, this also checks for the start and end of a link around the caret.  If one is found,
-- then it lifts the link out.
function TinyPad.DoubleClick(self)
	local wasDoubleClick
	if TinyPad.ClickTime and (GetTime()-TinyPad.ClickTime)<.5 then
		wasDoubleClick = 1
		TinyPad.ClickTime = nil
	else
		TinyPad.ClickTime = GetTime()
	end
	local s = self:GetCursorPosition()
	if not s then return end
	local txt = self:GetText()

	-- look left and right of caret for whitespace (start/end of word)
	-- and start/end of a link (|c...|h|r)
	-- todo: replace with regex, tho gcinfo tests show minimal garbage created
	local starthighlight,endhighlight,startlink,endlink
	for i=1,s do
		if not string.find(string.sub(txt,i,i),"[^%s]") then
			starthighlight = i
		end
		if string.find(string.sub(txt,i,i+1),"\124c") then
			startlink = i
		end
	end
	for i=s,strlen(txt) do
		if not string.find(string.sub(txt,i,i),"[^%s]") then
			if not endhighlight then
				endhighlight = math.max(i-1,starthighlight or 1)
			end
		end
		if string.find(string.sub(txt,i,i+3),"\124h\124r") then
			if not endlink then
				endlink = i+3
			end
		end
	end

	-- if caret seems to be within a link
	if startlink and endlink then
		-- changed in 3.3.5 (used to check if ChatFrame(1)EditBox:IsVisible and modifiedclick)
		local activeWindow = ChatEdit_GetActiveWindow()
		if IsModifiedClick("CHATLINK") and activeWindow then
			-- shift+clicking to ChatFrameEditBox
			activeWindow:Insert(string.sub(txt,startlink,endlink))
			activeWindow:SetFocus()
			return
		else
			local link = string.sub(txt,startlink,endlink)
			local reflink = string.match(link,"\124H(.-)\124h")
			if reflink and reflink:match("^trade:") then -- special handling for tradeskill links
				if TradeSkillFrame and TradeSkillFrame:IsVisible() and TinyPad.last_viewed_trade==reflink then
					-- default behavior of SetItemRef doesn't toggle tradeskillframe, so make our own
					HideUIPanel(TradeSkillFrame)
					TinyPad.last_viewed_trade = nil
				else
					-- if link is a tradeskill, SetItemRef seems to want the "first" link within as a first param
					SetItemRef(reflink,link)
					TinyPad.last_viewed_trade = reflink
				end
			else
				local foundItem
				if TradeSkillFrame and TradeSkillFrame:IsVisible() then
					-- if a tradeskill window is open, and a link was clicked,
					-- select the linked item in the tradeskill window
					local itemName = GetItemInfo(link)
					for i=1,GetNumTradeSkills() do
						if GetTradeSkillInfo(i)==itemName then
							TradeSkillFrame_SetSelection(i)
							foundItem = 1
							break
						end
					end
				end
				if not foundItem then
					SetItemRef(link,link,GetMouseButtonClicked()) -- display normal link (item, quest, spell)
				end
			end
		end
	elseif endhighlight and wasDoubleClick then
		self:HighlightText(starthighlight,endhighlight)
	end
end

--[[ Bookmark UI ]]

function TinyPad.BookmarkFrameOnUpdate(self,elapsed)
	self.timer = self.timer + elapsed
	if self.timer > .75 then
		self.timer = 0
		if GetMouseFocus()~=TinyPadBookmarks and not MouseIsOver(TinyPadBookmarkFrame) then
			self:Hide()
		end
	end
end

function TinyPad.BookmarkFrameOnShow()
	TinyPad.MakeESCable("TinyPadFrame","disable")
	TinyPad.UpdateBookmarkList()
end

function TinyPad.BookmarkFrameOnHide()
	if not TinyPadSettings.Lock and not TinyPadSearchFrame:IsVisible() then
		TinyPad.MakeESCable("TinyPadFrame")
	end
end

function TinyPad.BookmarkEditBoxOnChange()
	if string.len(TinyPadBookmarkEditBox:GetText() or "")==0 then
		TinyPadBookmarkEditBoxLabel:Show()
		TinyPadBookmarkAdd:Disable()
	else
		TinyPadBookmarkEditBoxLabel:Hide()
		TinyPadBookmarkAdd:Enable()
	end
end

function TinyPad.ClearBookmarkList()
	local buttonNum,button = 1
	while _G["TinyPadBookmarkList"..buttonNum] do
		button = _G["TinyPadBookmarkList"..buttonNum]
		if button then
			button:Hide()
			button.page = nil
		end
		buttonNum = buttonNum + 1
	end
end

function TinyPad.CreateBookmarkListEntry(bookmarkNum,bookmark,page)
	local buttonName = "TinyPadBookmarkList"..bookmarkNum
	local button
	if not _G[buttonName] then
		button = CreateFrame("Button",buttonName,TinyPadBookmarkFrame,"TinyPadBookmarkListTemplate")
		button:SetPoint("TOPLEFT",bookmarkNum==1 and TinyPadBookmarkAddButtonFrame or _G["TinyPadBookmarkList"..bookmarkNum-1],"BOTTOMLEFT")
		local c = bookmarkNum%2==0 and .2 or .25
		_G["TinyPadBookmarkList"..bookmarkNum.."Background"]:SetVertexColor(c,c,c)
	else
		button = _G[buttonName]
	end
	local buttonText = _G[buttonName.."Text"]
	buttonText:SetText(bookmark)
	if page==TinyPad.current_page then
		_G[buttonName.."Mark"]:Show()
		buttonText:SetWidth(128)
	else
		_G[buttonName.."Mark"]:Hide()
		buttonText:SetWidth(138)
	end
	button.page = page
	button:Show()
end

function TinyPad.UpdateBookmarkList()
	TinyPadBookmarkAddEditBoxFrame:Hide()
	if TinyPad.GetPageText(nil,1) then
		TinyPadBookmarkAddButtonFrame:Hide()
		TinyPadBookmarkDeleteButtonFrame:Show()
	else
		TinyPadBookmarkDeleteButtonFrame:Hide()
		TinyPadBookmarkAddButtonFrame:Show()
	end
	TinyPad.ClearBookmarkList()

	local bookmarkNum = 0
	for page=1,#TinyPadPages do
		bookmark = TinyPad.GetPageText(page,1)
		if bookmark then
			bookmarkNum = bookmarkNum + 1
			TinyPad.CreateBookmarkListEntry(bookmarkNum,bookmark,page)
		end
	end

	TinyPadBookmarkFrame:SetHeight(34+bookmarkNum*18-(bookmarkNum==0 and 2 or 0))
end

function TinyPad.BookmarkAddButtonOnClick()
	TinyPadBookmarkAddButtonFrame:Hide()
	TinyPadBookmarkAddEditBoxFrame:Show()
	TinyPadBookmarkEditBox:SetText("")
	TinyPadBookmarkEditBox:SetFocus()
end

function TinyPad.BookmarkEditBoxOnEscapePressed()
	TinyPadBookmarkEditBox:ClearFocus()
	TinyPadBookmarkFrame.timer = 0
	TinyPad.UpdateBookmarkList()
end

function TinyPad.BookmarkEditBoxOnEnterPressed()
	local bookmarkName = TinyPadBookmarkEditBox:GetText()
	if bookmarkName:len()>0 then
		TinyPadPages[TinyPad.current_page] = {bookmarkName,TinyPad.GetPageText()}
	end
	TinyPad.BookmarkEditBoxOnEscapePressed()
end

function TinyPad.BookmarkDeleteButtonOnClick()
	TinyPadPages[TinyPad.current_page] = TinyPad.GetPageText()
	TinyPad.UpdateBookmarkList()
end

function TinyPad.BookmarkListOnClick(self)
	TinyPad.SaveCurrentPage()
	TinyPad.current_page = self.page
	TinyPad.ShowPage()
	if IsShiftKeyDown() then
		RunScript(TinyPad.GetPageText())
	end
	TinyPadBookmarkFrame:Hide()
end

function TinyPad.BookmarkListOnEnter(self)
	GameTooltip_SetDefaultAnchor(GameTooltip,UIParent)
	GameTooltip:AddLine(TinyPad.GetPageText(self.page,1))
	GameTooltip:AddLine("Page "..self.page,.65,.65,.65)
	GameTooltip:AddLine((TinyPad.GetPageText(self.page):sub(1,128):gsub("\n"," ")),.85,.85,.85,1)
	GameTooltip:AddLine("Hold Shift to run this page as a script.",.65,.65,.65,1)
	GameTooltip:Show()
end
