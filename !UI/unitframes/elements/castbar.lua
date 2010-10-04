local function UNIT_SPELLCAST_START(self, event, unit, spell, spellrank)
	if self.unit ~= unit then
		return
	end

	local name, rank, text, texture, startTime, endTime, _, castid, NotInterruptible = UnitCastingInfo(unit)
	if not name then
		return self.Castbar:Hide()
	end

	endTime = endTime / 1000
	startTime = startTime / 1000

	self.Castbar.castid = castid
	self.Castbar.duration = GetTime() - startTime
	self.Castbar.casting = true
	self.Castbar.max = endTime - startTime
	self.Castbar.delay = 0

	if self.Castbar.icon then
		self.Castbar.icon:SetTexture(texture)
	end
	if self.Name then
		self.Name:SetText(text)
	end
	if self.Castbar.Time then
		self.Castbar.Time:SetText""
	end
	if self.Castbar.Latency then
		local _, _, lag = GetNetStats()
		self.Castbar.Latency:ClearAllPoints()
		self.Castbar.Latency:SetPoint("TOPRIGHT", self, "TOPRIGHT")
		self.Castbar.Latency:SetWidth(lag / ((endTime - startTime) * 1000) * self.Castbar:GetWidth())
		self.Castbar.Latency:Show()
	end

	self.Castbar:Show()
end

local function UNIT_SPELLCAST_FAILED(self, event, unit, spellname, spellrank, castid)
	if self.unit ~= unit then
		return
	end

	if self.Castbar.castid ~= castid then
		return
	end

	self.Castbar.casting = nil
	self.Castbar:Hide()
end

local function UNIT_SPELLCAST_INTERRUPTED(self, event, unit, spellname, spellrank, castid)
	if self.unit ~= unit then
		return 
	end

	if self.Castbar.castid ~= castid then
		return
	end
	self.Castbar.casting = nil
	self.Castbar.channeling = nil

	self.Castbar:Hide()
end

local function UNIT_SPELLCAST_DELAYED(self, event, unit, spellname, spellrank)
	if self.unit ~= unit then
		return
	end

	local name, rank, text, texture, startTime, endTime = UnitCastingInfo(unit)
	if not startTime then
		return 
	end

	local duration = GetTime() - (startTime / 1000)
	if duration < 0 then
		duration = 0
	end

	self.Castbar.delay = self.Castbar.delay + self.Castbar.duration - duration
	self.Castbar.duration = duration
end

local function UNIT_SPELLCAST_STOP(self, event, unit, spellname, spellrank, castid)
	if self.unit ~= unit then
		return
	end

	if self.Castbar.castid ~= castid then
		return
	end

	self.Castbar.casting = nil
	self.Castbar:Hide()
end

local function UNIT_SPELLCAST_CHANNEL_START(self, event, unit, spellname, spellrank)
	if self.unit ~= unit then
		return
	end

	local name, rank, text, texture, startTime, endTime = UnitChannelInfo(unit)
	if not name then
		return
	end

	endTime = endTime / 1000
	startTime = startTime / 1000
	local duration = endTime - GetTime()

	self.Castbar.duration = duration
	self.Castbar.max = endTime - startTime
	self.Castbar.delay = 0
	self.Castbar.channeling = true

	if self.Castbar.icon then
		self.Castbar.icon:SetTexture(texture)
	end
	if self.Name then
		self.Name:SetText(name)
	end
	if self.Castbar.Time then
		self.Castbar.Time:SetText""
	end
	if self.Castbar.Latency then
		local _, _, lag = GetNetStats()
		self.Castbar.Latency:ClearAllPoints()
		self.Castbar.Latency:SetPoint("TOPLEFT", self, "TOPLEFT")
		self.Castbar.Latency:SetWidth(lag / ((endTime - startTime) * 1000) * self.Castbar:GetWidth())
		self.Castbar.Latency:Show()
	end

	self.Castbar:Show()
end

local function UNIT_SPELLCAST_CHANNEL_UPDATE(self, event, unit, spellname, spellrank)
	if self.unit ~= unit then
		return
	end

	local name, rank, text, texture, startTime, endTime, oldStart = UnitChannelInfo(unit)
	if not name then
		return
	end

	local duration = (endTime / 1000) - GetTime()

	self.Castbar.delay = self.Castbar.delay + self.Castbar.duration - duration
	self.Castbar.duration = duration
	self.Castbar.max = (endTime - startTime) / 1000
end

local function UNIT_SPELLCAST_CHANNEL_STOP(self, event, unit, spellname, spellrank)
	if self.unit ~= unit then
		return
	end

	if self.Castbar:IsShown() then
		self.Castbar.channeling = nil
		self.Castbar:Hide()
	end
end

local function onUpdate(self, elapsed)
	if self.casting then
		local duration = self.duration + elapsed
		if duration >= self.max then
			self.casting = nil
			return self:Hide()
		end

		if self.Time then
			if self.delay ~= 0 then
				self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", self.max - duration, self.delay)
			else
				self.Time:SetFormattedText("%.1f", self.max - duration)
			end
		end

		self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self.Width, 0)
		self.duration = duration
	elseif self.channeling then
		local duration = self.duration - elapsed
		if duration <= 0 then
			self.channeling = nil
			return self:Hide()
		end

		if self.Time then
			if self.delay ~= 0 then
				self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
			else
				self.Time:SetFormattedText("%.1f", duration)
			end
		end

		self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
		self.duration = duration
	else
		self.unitName = nil
		self.channeling = nil
		self:Hide()
	end
end

local function OnShow(self)
	self:SetScript("OnUpdate", onUpdate)
end

local function OnHide(self)
	self:SetScript("OnUpdate", nil)
	local parent = self:GetParent()
	if parent.Name then
		 parent:UNIT_NAME("UNIT_NAME", parent.unit)
	end
end

local function Enable(self, unit)
	if self.Castbar then
		self:RegisterEvent("UNIT_SPELLCAST_START", UNIT_SPELLCAST_START)
		self:RegisterEvent("UNIT_SPELLCAST_FAILED", UNIT_SPELLCAST_FAILED)
		self:RegisterEvent("UNIT_SPELLCAST_STOP", UNIT_SPELLCAST_STOP)
		self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", UNIT_SPELLCAST_INTERRUPTED)
		self:RegisterEvent("UNIT_SPELLCAST_DELAYED", UNIT_SPELLCAST_DELAYED)
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", UNIT_SPELLCAST_CHANNEL_START)
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", UNIT_SPELLCAST_CHANNEL_UPDATE)
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED", 'UNIT_SPELLCAST_INTERRUPTED')
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", UNIT_SPELLCAST_CHANNEL_STOP)
		self.Castbar:SetScript("OnShow", OnShow)
		self.Castbar:SetScript("OnHide", OnHide)
		self.Castbar:Hide()
		return true
	end
end

uf:AddElement("Castbar", function(...) UNIT_SPELLCAST_START(...) UNIT_SPELLCAST_CHANNEL_START(...) end, Enable, nil)