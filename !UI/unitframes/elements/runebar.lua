if PCLASS ~= "DEATHKNIGHT" then
	return
end

uf.colors.runes = {
	{.69,.31,.31},
	{.33,.59,.33},
	{.31,.65,.73},
}

local function OnUpdate(self, elapsed)
	local duration = self.duration + elapsed
	if duration >= self.max then
		return self:SetScript("OnUpdate", nil)
	else
		self.duration = duration
		return self:SetValue(duration)
	end
end

local function UpdateType(self, event, rune, alt)
	local colors = uf.colors.runes[GetRuneType(rune) or alt]
	local r, g, b = colors[1], colors[2], colors[3]
	self.Runes[rune]:SetStatusBarColor(r, g, b)
	if self.Runes[rune].bg then
		local mu = self.Runes[rune].bg.multiplier or 1
		self.Runes[rune].bg:SetVertexColor(r * mu, g * mu, b * mu)
	end
end

local function Update(self, event, rid, usable)
	if self.Runes[rid] then
		local start, duration, runeReady = GetRuneCooldown(self.Runes[rid]:GetID())
		if runeReady then
			self.Runes[rid]:SetValue(duration)
			self.Runes[rid]:SetScript("OnUpdate", nil)
		else
			self.Runes[rid].duration = GetTime() - start
			self.Runes[rid].max = duration
			self.Runes[rid]:SetMinMaxValues(1, duration)
			self.Runes[rid]:SetScript("OnUpdate", OnUpdate)
		end
	end
end

local function Enable(self, unit)
	if self.Runes and unit == "player" then
		extendUnitFrame(self)
		for i = 1, 6 do
			self.Runes[i]:SetID(i)
			UpdateType(self, nil, i, math.floor((i + 1)/2))

			if not self.Runes[i]:GetStatusBarTexture() then
				self.Runes[i]:SetStatusBarTexture(TEXTURE)
			end
		end
		self:RegisterEvent("RUNE_POWER_UPDATE", Update)
		self:RegisterEvent("RUNE_TYPE_UPDATE", UpdateType)
		self.Runes:Show()
		RuneFrame:Hide()
		local runeMap = self.Runes.runeMap
		if runeMap then
			for f, t in pairs(runeMap) do
				self.Runes[f], self.Runes[t] = self.Runes[t], self.Runes[f]
			end
		else
			self.Runes[3], self.Runes[5] = self.Runes[5], self.Runes[3]
			self.Runes[4], self.Runes[6] = self.Runes[6], self.Runes[4]
		end
		local width = self.Runes.width
		local height = self.Runes.height
		local spacing = self.Runes.spacing or 0
		local anchor = self.Runes.anchor or "BOTTOMLEFT"
		local growthX, growthY = 0, 0
		if self.Runes.growth == "LEFT" then
			growthX = - 1
		elseif self.Runes.growth == "DOWN" then
			growthY = - 1
		elseif self.Runes.growth == "UP" then
			growthY = 1
		else
			growthX = 1
		end
		for i = 1, 6 do
			if self.Runes[i] then
				self.Runes[i]:SetWidth(width)
				self.Runes[i]:SetHeight(height)
				self.Runes[i]:SetPoint(anchor, self.Runes, anchor, (i - 1) * (width + spacing) * growthX, (i - 1) * (height + spacing) * growthY)
			end
		end
		if runeMap then
			for f, t in pairs(runeMap) do
				self.Runes[f], self.Runes[t] = self.Runes[t], self.Runes[f]
			end
		else
			self.Runes[3], self.Runes[5] = self.Runes[5], self.Runes[3]
			self.Runes[4], self.Runes[6] = self.Runes[6], self.Runes[4]
		end
		return true
	end
end

local function Disable(self)
	if self.Runes then
		self.Runes:Hide()
		shrinkUnitFrame(self)
		RuneFrame:Show()
		self:UnregisterEvent("RUNE_POWER_UPDATE", Update)
		self:UnregisterEvent("RUNE_TYPE_UPDATE", UpdateType)
	end
end

uf:AddElement("Runes", Update, Enable, Disable)
