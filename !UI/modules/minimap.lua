if not Load"minimap" then
	return
end

Minimap:ClearAllPoints()
Minimap.scale = .9
Minimap:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50 / Minimap.scale, 50 / Minimap.scale)
Minimap:SetMaskTexture"Interface\\Buttons\\WHITE8X8"
MinimapCluster:SetScale(Minimap.scale)
Minimap.bg, Minimap.bd = CreateBG(Minimap)
Minimap:RegisterEvent"CALENDAR_UPDATE_PENDING_INVITES"
Minimap:RegisterEvent"PLAYER_ENTERING_WORLD"
Minimap:SetScript("OnEvent", function(self, event, ...)
	if CalendarGetNumPendingInvites() > 0 then
		Minimap.bd:SetBackdropColor(.9, .1, .1)
		Minimap.bd:SetBackdropBorderColor(.9, .1, .1)
	else
		Minimap.bd:SetBackdropColor(0, 0, 0)
		Minimap.bd:SetBackdropBorderColor(0, 0, 0)
	end
end)

do
	local frames = {
		"MiniMapInstanceDifficulty",
		"MiniMapBattlefieldBorder",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MiniMapTracking",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MinimapBorder",
		"GameTimeFrame",
	}
	for i = 1, #frames do
		_G[frames[i]]:Hide()
		_G[frames[i]].Show = dummy
	end
end

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
	if zoom > 0 then
		Minimap_ZoomIn()
	else
		Minimap_ZoomOut()
	end
end)

MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("CENTER", Minimap)
MinimapZoneTextButton:SetFrameStrata"HIGH"
MinimapZoneTextButton:SetAlpha(0)
MinimapZoneText:SetFont(FONT, 12, "OUTLINE")
MinimapZoneText:SetShadowColor(0, 0, 0, 0)

Minimap:SetScript("OnEnter", function(self)
	MinimapZoneTextButton:SetAlpha(1)
end)
Minimap:SetScript("OnLeave", function(self)
	MinimapZoneTextButton:SetAlpha(0)
end)

MinimapZoneTextButton:EnableMouse(false)

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
	elseif button == "MiddleButton" then
		if IsModifierKeyDown() then
			ToggleAchievementFrame()
		else
			if not CalendarFrame then
				LoadAddOn"Blizzard_Calendar"
			end
            Calendar_Toggle()
		end
	else
		Minimap_OnClick(self)
	end
end)

MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -6)

MiniMapMailIcon:SetTexture(nil)
MiniMapMailFrame:SetHeight(15)
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint"BOTTOM"
MiniMapMailFrame.mail = CreateFS(MiniMapMailFrame, 12 / Minimap.scale)
MiniMapMailFrame.mail:SetPoint"CENTER"
MiniMapMailFrame.mail:SetText(MAIL_LABEL)

MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -6)