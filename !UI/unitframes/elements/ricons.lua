local function Update(self, event)
	local index = GetRaidTargetIndex(self.unit)
	if index then
		SetRaidTargetIconTexture(self.RaidIcon, index)
		self.RaidIcon:Show()
	else
		self.RaidIcon:Hide()
	end
end

local function Enable(self)
	if self.RaidIcon then
		self:RegisterEvent("RAID_TARGET_UPDATE", Update)
		self.RaidIcon:SetTexture"Interface\\TargetingFrame\\UI-RaidTargetingIcons"
		return true
	end
end

uf:AddElement("RaidIcon", Update, Enable, nil)