if not Load"map" then
	return
end

WORLDMAP_WINDOWED_SIZE = .82
 
local fontsize = 12 / WORLDMAP_WINDOWED_SIZE

local MapFrame = CreateFrame"Frame"
MapFrame:RegisterEvent"PLAYER_LOGIN"
MapFrame:RegisterEvent"PARTY_MEMBERS_CHANGED"
MapFrame:RegisterEvent"RAID_ROSTER_UPDATE"
MapFrame:RegisterEvent"WORLD_MAP_UPDATE"
MapFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
MapFrame:RegisterEvent"PLAYER_REGEN_DISABLED"
 
local SmallerMap = GetCVarBool"miniWorldMap"
if SmallerMap == nil then
	SetCVar("miniWorldMap", 1)
end
 
local function SmallerMapSkin()
	local ald = CreateFrame("Frame", nil, WorldMapButton)
	ald:SetFrameStrata"TOOLTIP"
	local bg, bd = CreateBG(WorldMapDetailFrame)
	bg:Hide()
	WorldMapButton:SetAllPoints(WorldMapDetailFrame)
	WorldMapFrame:SetFrameStrata"MEDIUM"
	WorldMapDetailFrame:SetFrameStrata"MEDIUM"
	WorldMapDetailFrame:ClearAllPoints()
	WorldMapDetailFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	WorldMapTitleButton:Show()	
	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:SetPoint("TOP", Minimap, "TOP", 0, 40)
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeUpButton:ClearAllPoints()
	WorldMapFrameSizeUpButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, -18)
	WorldMapFrameSizeUpButton:SetFrameStrata"HIGH"
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
	WorldMapFrameCloseButton:SetFrameStrata"HIGH"
	WorldMapFrameSizeDownButton:SetPoint("TOPRIGHT", WorldMapFrameMiniBorderRight, "TOPRIGHT", -66, 5)
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 3, 5)
	WorldMapFrameTitle:SetFont(FONT, fontsize, "OUTLINE")
	WorldMapFrameTitle:SetTextColor(1, 1, 1)
	WorldMapFrameTitle:SetShadowColor(0, 0, 0, 0)
	WorldMapFrameTitle:SetParent(ald)	
	WorldMapQuestShowObjectives:SetParent(ald)
	WorldMapQuestShowObjectives:ClearAllPoints()
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, -1)
	WorldMapQuestShowObjectivesText:SetFont(FONT, fontsize, "OUTLINE")
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", -4, 1)
	WorldMapQuestShowObjectivesText:SetTextColor(1, 1, 1)
	WorldMapQuestShowObjectivesText:SetShadowColor(0, 0, 0, 0)
	WorldMapTrackQuest:SetParent(ald)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("TOPLEFT", WorldMapDetailFrame, 9, -5)
	WorldMapTrackQuestText:SetFont(FONT, fontsize, "OUTLINE")
	WorldMapTrackQuestText:SetTextColor(1, 1, 1)
	WorldMapTrackQuestText:SetShadowColor(0, 0, 0, 0)
	WorldMapTitleButton:SetFrameStrata"TOOLTIP"
	WorldMapTooltip:SetFrameStrata"TOOLTIP"
end
hooksecurefunc("WorldMap_ToggleSizeDown", function()
	SmallerMapSkin()
end)

local function CreateText(offset)
	local text = WorldMapButton:CreateFontString(nil, "ARTWORK")
	text:SetPoint("BOTTOMLEFT", WorldMapButton, 3, offset)
	text:SetFont(FONT, fontsize, "OUTLINE")
	text:SetTextColor(1, 1, 1)
	text:SetJustifyH"LEFT"
	return text
end

function MouseXY()
	local left, top = WorldMapDetailFrame:GetLeft() or 0, WorldMapDetailFrame:GetTop() or 0
	local width, height = WorldMapDetailFrame:GetWidth(), WorldMapDetailFrame:GetHeight()
	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local x, y = GetCursorPosition()
	local cx = (x / scale - left) / width
	local cy = (top - y/scale) / height
	if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
		return
	end
	return cx, cy
end

local function OnUpdate(player, cursor)
	local cx, cy = MouseXY()
	local px, py = GetPlayerMapPosition"player"
	if cx then
		cursor:SetFormattedText("Cursor ".."%.2d,%.2d", 100 * cx, 100 * cy)
	else
		cursor:SetText""
	end
	if px == 0 then
		player:SetText""
	else
		player:SetFormattedText(PNAME.." %.2d,%.2d", 100 * px, 100 * py)
	end
	if InCombatLockdown() then
		WorldMapFrameSizeDownButton:Disable() 
		WorldMapFrameSizeUpButton:Disable() 
	else
		WorldMapFrameSizeDownButton:Enable()
		WorldMapFrameSizeUpButton:Enable() 
	end
end

local function UpdateIconColor(self, t)
	color = RAID_PCLASS_COLORS[select(2, UnitClass(self.unit))]
	self.icon:SetVertexColor(color.r, color.g, color.b)
end

function WorldMapQuestPOI_OnLeave()
	WorldMapTooltip:Hide()
end

do
	local buttons = {
		"WorldMapZoneDropDown",
		"WorldMapZoomOutButton",
		"WorldMapLevelDropDown",
		"WorldMapContinentDropDown",
		"WorldMapZoneMinimapDropDown",
		"WorldMapMagnifyingGlassButton",
		"WorldMapFrameSizeDownButton",
		"WorldMapFrameSizeUpButton",
		--"WorldMapFrameCloseButton",
		--"WorldMapQuestShowObjectives",
	}
	for i = 1, #buttons do
		_G[buttons[i]]:Hide()
		_G[buttons[i]].Show = dummy
	end
end

MapFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "WORLD_MAP_UPDATE" then
		if GetNumDungeonMapLevels() == 0 then
			WorldMapLevelUpButton:Hide()
			WorldMapLevelDownButton:Hide()
		else
			WorldMapLevelUpButton:Show()
			WorldMapLevelDownButton:Show()
			WorldMapLevelUpButton:ClearAllPoints()
			WorldMapLevelUpButton:SetPoint("TOPLEFT", WorldMapFrameCloseButton, "BOTTOMLEFT", 8, 8)
			WorldMapLevelUpButton:SetFrameStrata"MEDIUM"
			WorldMapLevelUpButton:SetFrameLevel(90)
			WorldMapLevelDownButton:ClearAllPoints()
			WorldMapLevelDownButton:SetPoint("TOP", WorldMapLevelUpButton, "BOTTOM", 0, -2)
			WorldMapLevelDownButton:SetFrameStrata"MEDIUM"
			WorldMapLevelDownButton:SetFrameLevel(90)
		end
	end
	local player = CreateText(25)
	local cursor = CreateText(40)
	local elapsed = 0
	self:SetScript("OnUpdate", function(self, u)
		elapsed = elapsed + u
		if elapsed > 0.1 then
			OnUpdate(player, cursor)
			elapsed = 0
		end
	end)
end)