-- Create frames for the Glow for Enemy/Player, plus 1 more for the Tooltip
PetBattleGlow = {}
for nIndex = 1, 7 do
	local sGlow = "Glow"..tostring(nIndex)
	PetBattleGlow[sGlow] = CreateFrame("Frame", "PetBattleQuality_"..sGlow, UIParent)
	PetBattleGlow[sGlow]:Hide()
	PetBattleGlow[sGlow].Glow = PetBattleGlow[sGlow]:CreateTexture(sGlow, "ARTWORK")
	PetBattleGlow[sGlow].Glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border", false)
	PetBattleGlow[sGlow].Glow:SetBlendMode("ADD")
end

function PetBattleGlow_Update(self)
	-- There must be a petOwner and a petIndex
	if (not self.petOwner) or (not self.petIndex) then return end
	
	-- Is this Enemy or Player?	(This Value will be Added to the Glow Index)
	local nEnemy = 0
	if (self.petOwner == LE_BATTLE_PET_ENEMY) then nEnemy = 3 end
	
	-- Check if this is the Tooltip
	local isTooltip = false
	if (self:GetName() == "PetBattlePrimaryUnitTooltip") then isTooltip = true end
	
	-- Set which Glow frame this will use (Enemy Frames are +3 / Tooltip is 7)
	local sGlow = "Glow7"
	if (not isTooltip) then sGlow = "Glow"..tostring(self.petIndex + nEnemy) end
	
	-- Position the Glow, tricky to set it over Icon, but under Border
	PetBattleGlow[sGlow]:SetParent(self)
	PetBattleGlow[sGlow]:ClearAllPoints()
	PetBattleGlow[sGlow]:SetWidth(self.Icon:GetWidth() * 1.7)
	PetBattleGlow[sGlow]:SetHeight(self.Icon:GetHeight() * 1.7)
	PetBattleGlow[sGlow]:SetPoint("CENTER", self.Icon, "CENTER", 0, 0)
	-- Set the texture for the Glow
	PetBattleGlow[sGlow].Glow:SetParent(self)
	PetBattleGlow[sGlow].Glow:ClearAllPoints()
	PetBattleGlow[sGlow].Glow:SetAllPoints(PetBattleGlow[sGlow])
	PetBattleGlow[sGlow].Glow:SetDrawLayer("ARTWORK", 1)
	
	-- Set the color for the Glow
	local nQuality = C_PetBattles.GetBreedQuality(self.petOwner, self.petIndex) - 1
	local r, g, b, hex = GetItemQualityColor(nQuality)
	PetBattleGlow[sGlow].Glow:SetVertexColor(r, g, b)
	PetBattleGlow[sGlow]:Show()
	
	-- Color the Name with the Quality color
	if (self.Name) then
		local sPetName = C_PetBattles.GetName(self.petOwner, self.petIndex)
		if (sPetName) then self.Name:SetText("|c"..hex..sPetName.."|r") end
	end
	
	-- Color the non-active Health Bars with the Quality color
	if (self.ActualHealthBar) and (not isTooltip) then
		if (self.petIndex ~= 1) then
			-- Fix by: Nullberri
			-- self.ActualHealthBar:SetVertexColor(r, g, b)
			if (self.petIndex ~= C_PetBattles.GetActivePet(self.petOwner)) then
				self.ActualHealthBar:SetVertexColor(r, g, b)
			else
				self.ActualHealthBar:SetVertexColor(0, 1, 0)
			end
		end
	end
end

hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", PetBattleGlow_Update)
