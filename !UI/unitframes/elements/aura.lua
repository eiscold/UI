local function OnEnter(self)
	if not self:IsVisible() then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetUnitAura(self.frame.unit, self:GetID(), self.filter)
end

local function OnLeave()
	GameTooltip:Hide()
end

local function OnClick(self)
	CancelUnitBuff(self.frame.unit, self:GetID(), self.filter)
end

local function createAuraIcon(self, icons, index, debuff)
	local button = CreateFrame("Button", nil, icons)
	button:SetWidth(icons.size or 28)
	button:SetHeight(icons.size or 28)
	local cd = CreateFrame("Cooldown", nil, button)
	cd:SetAllPoints(button)
	cd:SetReverse()
	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	local count = CreateFS(button, 13, "CENTER")
	count:SetTextColor(.8, .8, .8)
	count:SetPoint("TOPLEFT", -1, 0)
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetPoint("TOPLEFT", -3, 3)
	overlay:SetPoint("BOTTOMRIGHT", 3, -3)
	overlay:SetFrameStrata"BACKGROUND"
	overlay:SetBackdrop(BACKDROP)
	button.overlay = overlay
	button:SetScript("OnEnter", OnEnter)
	button:SetScript("OnLeave", OnLeave)
	if self.unit == "player" then
		button:RegisterForClicks"RightButtonUp"
		button:SetScript("OnClick", OnClick)
	end
	table.insert(icons, button)
	button.debuff = debuff
	button.parent = icons
	button.count = count
	button.frame = self
	button.icon = icon
	button.cd = cd
	return button
end

local UsefulDebuffs = {
	--[""] = true,
}

local function CustomShowFilter(unit, isDebuff, caster, name)
	if (unit ~= "target" or unit ~= "focus") and caster == "player" then
		return true
	end
	if UnitIsPlayer(unit) or not isDebuff or caster == "player" or UsefulDebuffs[name] then
		return true
	end
	return false
end

local function updateIcon(self, unit, icons, index, offset, filter, isDebuff, max)
	if index == 0 then
		index = max
	end
	local name, rank, texture, count, dtype, duration, timeLeft, caster = UnitAura(unit, index, filter)
	if name then
		local icon = icons[index + offset] or createAuraIcon(self, icons, index, isDebuff)
		local show = CustomShowFilter(unit, isDebuff, caster, name)
		if show then
			local cd = icon.cd
			if duration and duration > 0 then
				cd:SetCooldown(timeLeft - duration, duration)
				cd:Show()
			else
				cd:Hide()
			end
			if isDebuff and dtype then
				local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
				icon.overlay:SetBackdropBorderColor(color.r * 0.5, color.g * 0.5, color.b * 0.5)
			else
				icon.overlay:SetBackdropBorderColor(0, 0, 0)
			end
			icon.icon:SetTexture(texture)
			icon.count:SetText(count > 1 and count)
			icon.filter = filter
			icon.debuff = isDebuff
			icon:SetID(index)
			icon:Show()
		else
			icon:Hide()
		end
		return true
	end
end

local function SetAuraPosition(self, icons, x)
	if icons and x > 0 then
		local col, row = 0, 0
		local gap = icons.gap
		local spacing = icons.spacing or 1
		local size = (icons.size or 28) + spacing
		local anchor = icons.initialAnchor or "TOPRIGHT"
		local growthx = (icons["growth-x"] == "LEFT" and -1) or 1
		local growthy = (icons["growth-y"] == "DOWN" and -1) or 1
		local cols = math.floor(icons:GetWidth() / size + .5)
		local rows = math.floor(icons:GetHeight() / size + .5)
		for i = 1, x do
			local button = icons[i]
			if button and button:IsShown() then
				if gap and button.debuff then
					if col > 0 then
						col = col + 1
					end
					gap = false
				end
				if col >= cols then
					col = 0
					row = row + 1
				end
				button:ClearAllPoints()
				button:SetPoint(anchor, icons, anchor, col * size * growthx, row * size * growthy)
				col = col + 1
			end
		end
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then
		return
	end
	local auras, buffs, debuffs = self.Auras, self.Buffs, self.Debuffs
	if auras then
		local buffs = auras.numBuffs or 32
		local debuffs = auras.numDebuffs or 40
		local max = debuffs + buffs
		local visibleBuffs, visibleDebuffs = 0, 0
		for index = 1, max do
			if index > buffs then
				if updateIcon(self, unit, auras, index % debuffs, visibleBuffs, auras.debuffFilter or auras.filter or "HARMFUL", true, debuffs) then
					visibleDebuffs = visibleDebuffs + 1
				end
			else
				if updateIcon(self, unit, auras, index, 0, auras.buffFilter or  auras.filter or "HELPFUL") then
					visibleBuffs = visibleBuffs + 1
				end
			end
		end
		local index = visibleBuffs + visibleDebuffs + 1
		while (auras[index]) do
			auras[index]:Hide()
			index = index + 1
		end
		auras.visibleBuffs = visibleBuffs
		auras.visibleDebuffs = visibleDebuffs
		auras.visibleAuras = visibleBuffs + visibleDebuffs
		self:SetAuraPosition(auras, max)
	end
	if buffs then
		local filter = buffs.filter or "HELPFUL"
		local max = buffs.num or 32
		local visibleBuffs = 0
		for index = 1, max do
			if not updateIcon(self, unit, buffs, index, 0, filter) then
				max = index - 1
				while(buffs[index]) do
					buffs[index]:Hide()
					index = index + 1
				end
				break
			end
			visibleBuffs = visibleBuffs + 1
		end
		buffs.visibleBuffs = visibleBuffs
		self:SetAuraPosition(buffs, max)
	end
	if debuffs then
		local filter = debuffs.filter or "HARMFUL"
		local max = debuffs.num or 40
		local visibleDebuffs = 0
		for index = 1, max do
			if not updateIcon(self, unit, debuffs, index, 0, filter, true) then
				max = index - 1
				while(debuffs[index]) do
					debuffs[index]:Hide()
					index = index + 1
				end
				break
			end
			visibleDebuffs = visibleDebuffs + 1
		end
		debuffs.visibleDebuffs = visibleDebuffs
		self:SetAuraPosition(debuffs, max)
	end
end

local function Enable(self)
	if self.Buffs or self.Debuffs or self.Auras then
		self.SetAuraPosition = SetAuraPosition
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

uf:AddElement("Aura", Update, Enable, nil)