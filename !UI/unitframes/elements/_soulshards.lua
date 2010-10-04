if PCLASS ~= "WARLOCK" then
	return
end

local function Update(self, event, unit, powerType)
	if self.unit ~= unit or powerType ~= "SOUL_SHARDS" then
		return
	end
	local num = UnitPower(unit, SHARD_BAR_POWER_INDEX)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if i <= num then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(0)
		end
	end
end

local function Path(self, ...)
	return Update(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit, "SOUL_SHARDS")
end

local function Enable(self)
	if self.SoulShards then
		self.SoulShards.__owner = self
		self.SoulShards.ForceUpdate = ForceUpdate
		self:RegisterEvent("UNIT_POWER", Path)
		return true
	end
end

local function Disable(self)
	if self.SoulShards then
		self:UnregisterEvent("UNIT_POWER", Path)
	end
end

uf:AddElement("SoulShards", Path, Enable, Disable)
