AAV_TeamStats = {}
AAV_TeamStats.__index = AAV_TeamStats

function AAV_TeamStats:new(parent, teamdata, matchdata, team, bracket)
	
	local self = {}
	setmetatable(self, AAV_TeamStats)
	
	self.posY = ((team-1) * bracket * (25))
	self.teamhead = AAV_Gui:createTeamHead(parent, self.posY, team)
	self.entries = {}
	for i = 1, 5 do
		self.entries[i] = {}
		self.entries[i]["entry"], self.entries[i]["icon"], self.entries[i]["name"], self.entries[i]["damage"], self.entries[i]["high"], self.entries[i]["heal"], self.entries[i]["rating"], self.entries[i]["mmr"] = AAV_Gui:createDetailEntry(parent, self.posY, i-1, team)
	end
	
	self:setValue(parent, teamdata, matchdata, team, bracket)
	
	return self
	
end

function AAV_TeamStats:hideAll()
	for k,v in pairs(self.entries) do
		v["entry"]:Hide()
	end
end

function AAV_TeamStats:trunkHCritSpellName(spellName)
	local spellNameLen = string.len(spellName)
	local MAXLINECHARS = 13
	local tmp
	
	if ( spellNameLen > MAXLINECHARS ) then
		spellName = string.sub(spellName,1,MAXLINECHARS)
	end
	return spellName
end

function AAV_TeamStats:setValue(parent, teamdata, matchdata, team, bracket)
	
	self.parent = parent
	self.team = team
	self.bracket = bracket
	
	self:hideAll()
	
	self.teamhead:SetText(teamdata.name)
	
	local rating, mmr, diff
	local i = 1
	local j = 1
	
	
	for c,w in pairs(matchdata) do
		if (w.player == 1 and w.team == team) then
			if (w.ratingChange and w.ratingChange >= 0) then diff = "+" .. w.ratingChange else diff = w.ratingChange end
			if (not w.rating) then rating = "? (" .. diff .. ")" else rating = w.rating .. " (" .. diff .. ")" end
			if (not w.mmr) then mmr = "-" else mmr = w.mmr end
			local higestDamage = w.hcrit .."\n" .. self:trunkHCritSpellName(w.hCritName)
			
			self.entries[i]["entry"]:Show()
			self.entries[i]["icon"].texture:SetTexture("Interface\\Addons\\aav\\res\\" .. w.class .. ".tga")
			self.entries[i]["name"]:SetText(w.name)
			self.entries[i]["name"]:SetTextColor(AAV_Util:getTargetColor(w, true))
			self.entries[i]["damage"]:SetText(w.ddone)
			self.entries[i]["high"]:SetText(higestDamage)
			self.entries[i]["heal"]:SetText(w.hdone)
			self.entries[i]["rating"]:SetText(rating)
			self.entries[i]["mmr"]:SetText(mmr)
			i = i + 1
		end
	end
	
end