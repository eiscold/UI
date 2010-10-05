if not Load"watchframe" then
	return
end

WatchFrame:SetMovable(true)
WatchFrame:SetUserPlaced(true)
WatchFrame:ClearAllPoints()
WatchFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -150)
WatchFrame:SetWidth(250)
WatchFrame:SetHeight(700)
WatchFrame.SetPoint = dummy

local nextline = 1
WatchFrameTitle:SetFont(FONT, 12, "OUTLINE")
WatchFrameTitle:SetShadowColor(0, 0, 0, 0)
hooksecurefunc("WatchFrame_Update", function()
		for i = nextline, 50 do
		local line = _G["WatchFrameLine"..i]
		if line then
			line.text:SetFont(FONT, 12, "OUTLINE")
			line.dash:SetFont(FONT, 12, "OUTLINE")
			line.text:SetShadowColor(0, 0, 0, 0)
			line.dash:SetShadowColor(0, 0, 0, 0)
		else
			nextline = i
			break
		end
	end
end)