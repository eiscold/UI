if not Load"minimap" then
	return
end

local Scale = 0.9

Minimap:ClearAllPoints()
Minimap:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50 / Scale, 50 / Scale)
Minimap:SetMaskTexture"Interface\\Buttons\\WHITE8X8"
MinimapCluster:SetScale(Scale)

local bg, bd = CreateBG(Minimap)

Minimap:RegisterEvent"CALENDAR_UPDATE_PENDING_INVITES"
Minimap:RegisterEvent"PLAYER_ENTERING_WORLD"
Minimap:SetScript("OnEvent", function(self, event, ...)
	local inv = CalendarGetNumPendingInvites()
	if inv > 0 then
		bd:SetBackdropColor(0.9, 0.1, 0.1)
		bd:SetBackdropBorderColor(0.9, 0.1, 0.1)
	else
		bd:SetBackdropColor(0, 0, 0)
		bd:SetBackdropBorderColor(0, 0, 0)
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
local mail = CreateFS(MiniMapMailFrame, 12 / Scale)
mail:SetPoint"CENTER"
mail:SetText(MAIL_LABEL)

MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -6)