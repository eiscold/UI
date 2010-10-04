if PCLASS ~= "DRUID" and PCLASS ~= "ROGUE" then
	return
end

local function Update(self, event, unit)
	if self.unit ~= unit and (self.CPoints.unit and self.CPoints.unit ~= unit) then
		return
	end
	if UnitPowerType"player" ~= SPELL_POWER_ENERGY then
		self.CPoints:Hide()
		return
	end
	local cp = GetComboPoints(UnitHasVehicleUI"player" and "vehicle" or "player", "target")
	if cp == 0 then
		shrinkUnitFrame(self)
	else
		extendUnitFrame(self)
	end
	if #self.CPoints == 0 then
		self.CPoints:SetText((cp > 0) and cp)
	else
		for i = 1, MAX_COMBO_POINTS do
			if i <= cp then
				self.CPoints[i]:Show()
			else
				self.CPoints[i]:Hide()
			end
		end
	end
end

local function Enable(self)
	if self.CPoints then
		self:RegisterEvent("UNIT_COMBO_POINTS", Update)
		self:RegisterEvent("VEHICLE_UPDATE", Update)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", Update)
		return true
	end
end

local function Disable(self)
	if self.CPoints then
		self:UnregisterEvent("UNIT_COMBO_POINTS", Update)
		self:UnregisterEvent("VEHICLE_UPDATE", Update)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Update)
		shrinkUnitFrame(self)
	end
end

uf:AddElement("CPoints", Update, Enable, Disable)
