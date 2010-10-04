local min, max, bar

local OnPowerUpdate
do
	local UnitMana = UnitMana
	OnPowerUpdate = function(self)
		local power = UnitMana(self.unit)
		if power ~= self.min then
			self.min = power
			self:GetParent():UNIT_MAXMANA("OnPowerUpdate", self.unit)
		end
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then
		return
	end
	min, max = UnitMana(unit), UnitManaMax(unit)
	self.Power:SetMinMaxValues(0, max)
	self.Power.unit = unit
	if CFG.PowerColored then
		local _, powerTypeString = UnitPowerType(unit)
		local r, g, b, a = GetMyColor() * 1.2
		if powerTypeString and powercolors[powerTypeString] then
			r, g, b = unpack(powercolors[powerTypeString])
		end
		self.Power:SetStatusBarColor(r, g, b, a)
	end
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		self.Power:SetValue(0)
	else
		self.Power:SetValue(min)
	end
	if self.Power.value then
		if not UnitIsConnected(unit) or min == 0 or UnitIsDead(unit) or UnitIsGhost(unit) then
			self.Power.value:SetText""
		else
			self.Power.value:SetText(GetShortValue(min))
		end
	end
end

local function Enable(self, unit)
	if self.Power then
		if self.Power.frequentUpdates and (unit == "player" or unit == "pet") then
			self.Power:SetScript("OnUpdate", OnPowerUpdate)
		else
			self:RegisterEvent("UNIT_MANA", Update)
			self:RegisterEvent("UNIT_RAGE", Update)
			self:RegisterEvent("UNIT_FOCUS", Update)
			self:RegisterEvent("UNIT_ENERGY", Update)
			self:RegisterEvent("UNIT_RUNIC_POWER", Update)
		end
		self:RegisterEvent("UNIT_MAXMANA", Update)
		self:RegisterEvent("UNIT_MAXRAGE", Update)
		self:RegisterEvent("UNIT_MAXFOCUS", Update)
		self:RegisterEvent("UNIT_MAXENERGY", Update)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Update)
		self:RegisterEvent("UNIT_MAXRUNIC_POWER", Update)
		return true
	end
end

uf:AddElement("Power", Update, Enable, nil)