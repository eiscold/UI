local OnHealthUpdate
do
	local UnitHealth = UnitHealth
	OnHealthUpdate = function(self)
		if self.disconnected then
			return
		end
		local health = UnitHealth(self.unit)
		if health ~= self.min then
			self.min = health
			self:GetParent():UNIT_MAXHEALTH("OnHealthUpdate", self.unit)
		end
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then
		return
	end
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	self.Health.disconnected = not UnitIsConnected(unit)
	self.Health.unit = unit
	self.Health:SetMinMaxValues(0, max)
	if CFG.UnitFrameStyle == "heal" and self.Health.Deficit then
		local r, g, b = GetMyColor()
		local _, class = UnitClass(unit)
		if class and UnitIsPlayer(unit) then
			r, g, b = unpack(classcolors[class])
		end
		self.Health.Deficit:SetTexture(r, g, b, .8)
		self.Health.Deficit:SetWidth((max - min) / max * self:GetWidth())
		if max == min then
			self.Health.Deficit:Hide()
		else
			self.Health.Deficit:Show()
		end
	elseif CFG.ClassColored and UnitIsPlayer(unit) then
		local r, g, b, a = GetMyColor()
		local _, class = UnitClass(unit)
		if class then
			r, g, b = unpack(classcolors[class])
		end
		self.Health:SetStatusBarColor(r, g, b, a)
	else
		self.Health:SetStatusBarColor(GetMyColor())
	end
	if not UnitIsConnected(unit) or UnitIsGhost(unit) then
		self.Health:SetValue(0)
	else
		self.Health:SetValue(min)
	end
	if self.Health.value then
		local r, g, b = GameTooltip_UnitColor(unit)
		self.Health.value:SetTextColor(r, g, b)
		if not UnitIsConnected(unit) then
			self.Health.value:SetText"Off"
		elseif UnitIsDead(unit) then
			self.Health.value:SetText"Dead"
		elseif UnitIsGhost(unit) then
			self.Health.value:SetText"Ghost"
		else
			if unit == "player" then
				self.Health.value:SetFormattedText("|cffffffff%s|r", max == 0 and "" or max)
				self.Health.curvalue:SetFormattedText("%s", GetShortValue(min))
			elseif unit == "target" or unit:find"arena" or unit:find"party" then
				if CFG.UnitFrameStyle == "heal" then
					self.Health.value:SetFormattedText("|cffffffff%s|r", max-min == 0 and "" or "-"..GetShortValue(max - min))
				else
					self.Health.value:SetFormattedText("|cffffffff%s|r %.0f", GetShortValue(min), (min/max)*100)
				end
			elseif unit:find"boss" then
				self.Health.value:SetFormattedText("%.0f |cffffffff%s|r", (min/max)*100, UnitName(unit))
			elseif unit:find"raid" then
				local t = UnitName(unit)
				if CFG.RaidFrameStyle == "grid" then
					if max == min then
						if t and strlen(t) > 4 then
							t = t:sub(1, 4)
						end
					else
						t = "|cffffffff-"..GetShortValue(max - min).."|r"
					end
				end
				self.Health.value:SetText(t)
			end
		end
	end
end

local function Enable(self)
	if self.Health then
		if self.Health.frequentUpdates and (self.unit and not self.unit:match"%w+target$") or not self.unit then
			self.Health.disconnected = true
			self.Health:SetScript("OnUpdate", OnHealthUpdate)
		else
			self:RegisterEvent("UNIT_HEALTH", Update)
		end
		self:RegisterEvent("UNIT_MAXHEALTH", Update)
		self:RegisterEvent("UNIT_FACTION", Update)
		return true
	end
end

uf:AddElement("Health", Update, Enable, nil)