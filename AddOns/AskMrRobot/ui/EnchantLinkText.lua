local _, AskMrRobot = ...

AskMrRobot.EnchantLinkText = AskMrRobot.inheritsFrom(AskMrRobot.ItemTooltipFrame)

function AskMrRobot.EnchantLinkText:new(name, parent)
	local o = AskMrRobot.ItemTooltipFrame:new(name, parent)

	-- use the ItemLinkText class
	setmetatable(o, { __index = AskMrRobot.EnchantLinkText })

	-- the item text
	o.itemText = AskMrRobot.FontString:new(o, nil, "ARTWORK", "GameFontWhite")
	o.itemText:SetPoint("TOPLEFT")
	o.itemText:SetPoint("BOTTOMRIGHT")
	o.itemText:SetJustifyH("LEFT")

	return o
end

function AskMrRobot.EnchantLinkText:SetEnchantId(enchantId)
	--self.itemName = nil
	if enchantId and enchantId ~= 0 then
		local enchantData = AskMrRobot.ExtraEnchantData[enchantId];
		local spellId = enchantData and enchantData.spellId
		local link = nil
		if spellId then
			link = 'enchant:' .. spellId
		end
		self:SetItemLink(link)
		if enchantData then
			self.itemText:SetText(enchantData.text)
		else
			--self.itemText:SetText(enchantId)
			self.itemText:SetText('unknown')
		end
		-- if self.useSpellName then
		-- 	local spellName = spellId and select(1, GetSpellInfo(spellId))
		-- 	self.itemText:SetText(spellName)
		-- 	self.itemName = spellName
		-- else
		-- 	self.itemName = AskMrRobot.getEnchantName(enchantId)
		-- 	self.itemText:SetText(self.itemName)
		-- end
	else
		self:SetItemLink(nil)
		self.itemText:SetText('')
	end
end

function AskMrRobot.EnchantLinkText:SetFontSize(fontSize)
	self.itemText:SetFontSize(fontSize)
end

function AskMrRobot.EnchantLinkText:UseSpellName()
	self.useSpellName = true
end

AskMrRobot.EnchantLinkIconAndText = AskMrRobot.inheritsFrom(AskMrRobot.EnchantLinkText)

function AskMrRobot.EnchantLinkIconAndText:new(name, parent)
	local o = AskMrRobot.EnchantLinkText:new(name, parent)

	-- use the EnchantLinkIconAndText class
	setmetatable(o, { __index = AskMrRobot.EnchantLinkIconAndText })

	o.iconFrame = AskMrRobot.Frame:new(nil, o)
	o.iconFrame:SetPoint("TOPLEFT", 0, 5)
	o.iconFrame:SetWidth(24)
	o.iconFrame:SetHeight(24)

	o.icon = o.iconFrame:CreateTexture(nil, "BACKGROUND")
	o.icon:SetPoint("TOPLEFT")
	o.icon:SetPoint("BOTTOMRIGHT")

	o.itemText:SetPoint("TOPLEFT", o.iconFrame, "TOPRIGHT", 4, -5)

	o:SetRoundBorder()

	return o
end

function AskMrRobot.EnchantLinkIconAndText:SetRoundBorder()
	self.iconFrame:SetBackdrop({edgeFile = "Interface\\AddOns\\AskMrRobot\\Media\\round-edge", edgeSize = 8})
end

function AskMrRobot.EnchantLinkIconAndText:SetSquareBorder()
	self.iconFrame:SetBackdrop({edgeFile = "Interface\\AddOns\\AskMrRobot\\Media\\square-edge", edgeSize = 8})
end

function AskMrRobot.EnchantLinkIconAndText:SetEnchantId(enchantId)
	AskMrRobot.EnchantLinkText.SetEnchantId(self, enchantId)
	if enchantId and enchantId ~= 0 then
		--local texture = AskMrRobot.getEnchantIcon(enchantId)
		--self.icon:SetTexture('Interface/Icons/' .. texture)
		local enchantData = AskMrRobot.ExtraEnchantData[enchantId];
		local spellId = enchantData and enchantData.spellId
		local link = nil
		if spellId then
			link = 'enchant:' .. spellId
			local _, _, icon = GetSpellInfo(spellId)
			if icon then
				self.icon:SetTexture(icon)
			end
		end

		self.iconFrame:Show()
	else
		self.iconFrame:Hide()
	end
end

function AskMrRobot.EnchantLinkIconAndText:SetFontSize(fontSize)
	self.itemText:SetFontSize(fontSize)
end