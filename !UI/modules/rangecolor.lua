if not Load"rangecolor" then
	return
end

function ActionButton_OnUpdate(self, elapsed)
	local rangeTimer = self.rangeTimer
	if rangeTimer then
		rangeTimer = rangeTimer - elapsed
		if rangeTimer <= 0 then
			local isInRange = false
			if ActionHasRange(self.action) and IsActionInRange(self.action) == 0 then
				_G[self:GetName().."Icon"]:SetVertexColor(.9, .1, .1)
				isInRange = true
			end
			if self.isInRange ~= isInRange then
				self.isInRange = isInRange
				ActionButton_UpdateUsable(self)
			end
			rangeTimer = .2
		end
		self.rangeTimer = rangeTimer
	end
end