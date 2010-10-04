local OnRangeFrame = CreateFrame"Frame"

local timer = 0
local function OnRangeUpdate(self, elapsed)
	timer = timer + elapsed
	if timer >= .25 then
		for _, object in next, uf.objects do
			if object.Range and object:IsShown() then
				if UnitIsConnected(object.unit) and not UnitInRange(object.unit) then
					if object:GetAlpha() == object.inRangeAlpha then
						object:SetAlpha(object.outsideRangeAlpha)
					end
				elseif object:GetAlpha() ~= object.inRangeAlpha then
					object:SetAlpha(object.inRangeAlpha)
				end
			end
		end
		timer = 0
	end
end

OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)