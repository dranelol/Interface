local _, AskMrRobot = ...

AskMrRobot.ItemLinkText = AskMrRobot.inheritsFrom(AskMrRobot.ItemTooltipFrame)

function AskMrRobot.ItemLinkText:new(name, parent)
	local o = AskMrRobot.ItemTooltipFrame:new(name, parent)

	-- use the ItemLinkText class
	setmetatable(o, { __index = AskMrRobot.ItemLinkText })

	-- the item text
	o.itemText = AskMrRobot.FontString:new(o, nil, "ARTWORK", "GameFontWhite")
	o.itemText:SetPoint("TOPLEFT")
	o.itemText:SetPoint("BOTTOMRIGHT")
	o.itemText:SetJustifyH("LEFT")

	return o
end

function AskMrRobot.ItemLinkText:SetFormat(formatText)
	self.formatText = formatText
end

function AskMrRobot.ItemLinkText:SetItemId(itemId, upgradeId, suffixId)
	AskMrRobot.ItemTooltipFrame.SetItemLink(self, link)
	self.itemName = nil
	if itemId > 0 then
		local linkTemplate = "item:%d:0:0:0:0:0:%d:0:%d:0:%d"
		local itemName, itemLink = GetItemInfo(linkTemplate:format(itemId, suffixId, UnitLevel("player"), upgradeId))
		self:SetItemLink(itemLink)
		if itemLink then
			self.itemName = itemName
			if self.formatText then
				self.itemText:SetFormattedText(self.formatText, itemLink:gsub("%[", ""):gsub("%]", ""))
			else
				self.itemText:SetText(itemLink:gsub("%[", ""):gsub("%]", ""))
			end
		else
			self.itemText:SetFormattedText("unknown (%d)", itemId)
			self.itemText:SetTextColor(1,1,1)
			AskMrRobot.RegisterItemInfoCallback(itemId, function(name, itemLink2)
				if self.formatText then
					self.itemText:SetFormattedText(self.formatText, itemLink2:gsub("%[", ""):gsub("%]", ""))
				else
					self.itemText:SetText(itemLink2:gsub("%[", ""):gsub("%]", ""))
				end
				self:SetItemLink(itemLink2)
				self.itemName = name
			end)
		end
	else
		self.itemText:SetText("empty")
		self.itemText:SetTextColor(0.5,0.5,0.5)
		self:SetItemLink(nil)
	end
end

function AskMrRobot.ItemLinkText:SetFontSize(fontSize)
	self.itemText:SetFontSize(fontSize)
end