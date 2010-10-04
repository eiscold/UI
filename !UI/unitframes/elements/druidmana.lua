if PCLASS ~= "DRUID" then
	return
end

local function Update(self, event, unit)
	local num, str = UnitPowerType"player"
	if num ~= SPELL_POWER_MANA then
		extendUnitFrame(self)	
		local min, max = UnitPower("player", SPELL_POWER_MANA), UnitPowerMax("player", SPELL_POWER_MANA)
		self.DruidMana:SetMinMaxValues(0, max)
		self.DruidMana:SetValue(min)
		self.DruidMana.text:SetText(min)
		self.DruidMana.text:SetTextColor(self.DruidMana:GetStatusBarColor())
		self.DruidMana:SetAlpha(1)
	else
		self.DruidMana:SetAlpha(0)
		shrinkUnitFrame(self)
	end
end

local function Enable(self, unit)
	if self.DruidMana and unit == "player" then
		self.DruidMana:SetAlpha(0)
		self:RegisterEvent("UNIT_MANA", Update)
		self:RegisterEvent("UNIT_ENERGY", Update)
		self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", Update)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Update)
	end
end

local function Disable(self)
	if self.DruidMana then
		self.DruidMana:Hide()
		self:UnregisterEvent("UNIT_MANA", Update)
		self:UnregisterEvent("UNIT_ENERGY", Update)
		self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM", Update)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
		shrinkUnitFrame(self)
	end
end

uf:AddElement("DruidMana", Update, Enable, Disable)