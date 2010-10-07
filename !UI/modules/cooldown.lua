if not Load"cooldown" then
	return
end

local Multiplier = .387

local function GetFormattedTime(s)
	if s > 3600 then
		return string.format("%dh", math.floor(s / 3600 + .5)), s % 3600
	elseif s > 60 then
		return string.format("%dm", math.floor(s / 60 + .5)), s % 60
	end
	return math.floor(s + .5), s - math.floor(s)
end

local function Timer_OnUpdate(self, elapsed)
	if self.text:IsShown() then
		if self.nextUpdate > 0 then
			self.nextUpdate = self.nextUpdate - elapsed
		else
			local remain = self.duration - (GetTime() - self.start)
			if math.floor(remain + .5) > 0 then
				local time, nextUpdate = GetFormattedTime(remain)
				self.text:SetText(time)
				self.nextUpdate = nextUpdate
			else
				self.text:Hide()
			end
		end
	end
end

local methods = getmetatable(ActionButton1Cooldown).__index
hooksecurefunc(methods, "SetCooldown", function(self, start, duration)
	if start and duration and start > 0 and duration > 3 then
		local rsize = self:GetParent():GetWidth() * Multiplier
		if rsize < 10 then
			return
		end
		self.start = start
		self.duration = duration
		self.nextUpdate = 0
		local text = self.text
		if not text then
			text = CreateFS(self, rsize, "CENTER")
			text:SetPoint("BOTTOM", 0, -2)
			self.text = text
			self:SetScript("OnUpdate", Timer_OnUpdate)
		end
		text:Show()
	elseif self.text then
		self.text:Hide()
	end
end)