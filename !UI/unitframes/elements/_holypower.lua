if PCLASS ~= "PALADIN" then
	return
end

local function Update(self, event, unit, powerType)
	if self.unit ~= unit or powerType ~= "HOLY_POWER" then
		return
	end
	local num = UnitPower(unit, HOLY_POWER_INDEX)
	for i = 1, MAX_HOLY_POWER do
		if i <= num then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(0)
		end
	end
end

local function Path(self, ...)
	return Update(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", self.__owner.unit, "HOLY_POWER")
end

local function Enable(self)
	if self.HolyPower then
		self.HolyPower.__owner = self
		self.HolyPower.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_POWER", Path)
		return true
	end
end

local function Disable(self)
	if self.HolyPower then
		self:UnregisterEvent("UNIT_POWER", Path)
	end
end

uf:AddElement("HolyPower", Path, Enable, Disable)
