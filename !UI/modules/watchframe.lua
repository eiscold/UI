if not Load"watchframe" then
	return
end

WatchFrame:SetMovable(true)
WatchFrame:ClearAllPoints()
WatchFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -150)
WatchFrame:SetWidth(250)
WatchFrame:SetHeight(700)
WatchFrame:SetUserPlaced(true)
WatchFrame.SetPoint = dummy

hooksecurefunc("WatchFrame_Update", function()
	local nextline = 1
	WatchFrameTitle:SetFont(FONT, 12, "OUTLINE")
	WatchFrameTitle:SetShadowColor(0, 0, 0, 0)
	for i = nextline, 50 do
		line = _G["WatchFrameLine"..i]
		if line then
			line.text:SetFont(FONT, 12, "OUTLINE")
			line.dash:SetFont(FONT, 12, "OUTLINE")
			line.text:SetShadowColor(0, 0, 0, 0)
			line.dash:SetShadowColor(0, 0, 0, 0)
		else
			nextline = ik
			break
		end
	end
end)