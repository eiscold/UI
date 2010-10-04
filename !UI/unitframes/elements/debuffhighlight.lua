local CanDispel = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Poison = true, Disease = true, Curse = true, },
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Curse = true, Poison = true, }
}
local dispellist = CanDispel[PCLASS] or {}
local origColors = {}
local origBorderColors = {}
local origPostUpdateAura = {}

local function GetDebuffType(unit, filter)
	if not UnitCanAssist("player", unit) then
		return nil
	end
	local i = 1
	while true do
		local _, _, texture, _, debufftype = UnitAura(unit, i, "HARMFUL")
		if not texture then break end
		if debufftype and not filter or (filter and dispellist[debufftype]) then
			return debufftype, texture
		end
		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then 
		return
	end
	local debuffType, texture  = GetDebuffType(unit, self.DebuffHighlightFilter)
	if debuffType then
		local color = DebuffTypeColor[debuffType] 
		if self.DebuffHighlightBackdrop then
			self:SetBackdropColor(color.r, color.g, color.b, self.DebuffHighlightAlpha or 1)
		elseif self.DebuffHighlightUseTexture then
			self.DebuffHighlight:SetTexture(texture)
		else
			self.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, self.DebuffHighlightAlpha or .5)
		end
	else
		if self.DebuffHighlightBackdrop then
			local color = origColors[self]
			self:SetBackdropColor(color.r, color.g, color.b, color.a)
			color = origBorderColors[self]
			self:SetBackdropBorderColor(color.r, color.g, color.b, color.a)
		elseif self.DebuffHighlightUseTexture then
			self.DebuffHighlight:SetTexture(nil)
		else
			local color = origColors[self]
			self.DebuffHighlight:SetVertexColor(color.r, color.g, color.b, color.a)
		end
	end
end

local function Enable(self)
	if not self.DebuffHighlightBackdrop and not self.DebuffHighlight then
		return
	end
	if self.DebuffHighlightFilter and not CanDispel[PCLASS] then
		return
	end
	self:RegisterEvent("UNIT_AURA", Update)
	if self.DebuffHighlightBackdrop then
		local r, g, b, a = self:GetBackdropColor()
		origColors[self] = { r = r, g = g, b = b, a = a}
		r, g, b, a = self:GetBackdropBorderColor()
		origBorderColors[self] = { r = r, g = g, b = b, a = a}
	elseif not self.DebuffHighlightUseTexture then -- color debuffs
		local r, g, b, a = self.DebuffHighlight:GetVertexColor()
		origColors[self] = { r = r, g = g, b = b, a = a}
	end
	return true
end

local function Disable(self)
	if self.DebuffHighlightBackdrop or self.DebuffHighlight then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

uf:AddElement("DebuffHighlight", Update, Enable, Disable)

for i, frame in ipairs(uf.objects) do
	Enable(frame)
end