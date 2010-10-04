if not Load"buttons" then
	return
end

local function ButtonUpdate(self)
	self:SetNormalTexture""
	if not self.done then
		local bd = CreateFrame("Frame", nil, self)
		bd:SetPoint("TOPLEFT", -3, 3)
		bd:SetPoint("BOTTOMRIGHT", 3, -3)
		bd:SetFrameStrata"BACKGROUND"
		bd:SetBackdrop(BACKDROP)
		bd:SetBackdropBorderColor(0, 0, 0)
		local name = self:GetName()
		_G[name.."Border"]:Hide()
		_G[name.."Name"]:Hide()
		_G[name.."HotKey"]:Hide()
		_G[name.."HotKey"].Show = dummy
		_G[name.."Count"]:SetFont(FONT, 14, "OUTLINE")
		_G[name.."Count"]:ClearAllPoints()
		_G[name.."Count"]:SetPoint("TOPLEFT", -1, 0)
		_G[name.."Icon"]:SetTexCoord(.1, .9, .1, .9)
		_G[name.."Icon"]:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		_G[name.."Icon"]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 2)
		self.done = true
	end
end

hooksecurefunc("ActionButton_Update", ButtonUpdate)
hooksecurefunc("PetActionButton_OnUpdate", ButtonUpdate)