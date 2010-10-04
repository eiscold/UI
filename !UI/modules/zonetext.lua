if not Load"zonetext" then
	return
end

ZoneTextString:ClearAllPoints()
ZoneTextString:SetPoint("CENTER", Minimap)
ZoneTextString:SetWidth(Minimap:GetWidth())
ZoneTextString:SetFont(FONT, 12, "OUTLINE")

SubZoneTextString:SetFont(FONT, 12, "OUTLINE")
SubZoneTextString:SetWidth(Minimap:GetWidth())

PVPInfoTextString:SetFont(FONT, 12, "OUTLINE")
PVPInfoTextString:SetWidth(Minimap:GetWidth())

PVPArenaTextString:SetFont(FONT, 12, "OUTLINE")
PVPArenaTextString:SetWidth(Minimap:GetWidth())