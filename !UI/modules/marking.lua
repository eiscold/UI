if not Load"marking" then
	return
end

local MarkingFrame = CreateFrame("Frame", "SettingsMarkingFrame", UIParent, "UIDropDownMenuTemplate")

local menuList = {
	{text = RAID_TARGET_NONE, func = function() SetRaidTarget("target", 0) end},
	{text = RAID_TARGET_8, func = function() SetRaidTarget("target", 8) end},
	{text = "|cffff0000"..RAID_TARGET_7.."|r", func = function() SetRaidTarget("target", 7) end},
	{text = "|cff00ffff"..RAID_TARGET_6.."|r", func = function() SetRaidTarget("target", 6) end},
	{text = "|cffC7C7C7"..RAID_TARGET_5.."|r", func = function() SetRaidTarget("target", 5) end},
	{text = "|cff00ff00"..RAID_TARGET_4.."|r", func = function() SetRaidTarget("target", 4) end},
	{text = "|cff912CEE"..RAID_TARGET_3.."|r", func = function() SetRaidTarget("target", 3) end},
	{text = "|cffFF8000"..RAID_TARGET_2.."|r", func = function() SetRaidTarget("target", 2) end},
	{text = "|cffffff00"..RAID_TARGET_1.."|r", func = function() SetRaidTarget("target", 1) end},
}

WorldFrame:HookScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and IsShiftKeyDown() and UnitExists"mouseover" then
		local numparty, numraid = GetNumPartyMembers(), GetNumRaidMembers()
		if (numraid > 0 and select(2, GetRaidRosterInfo(numraid)) ~= 0) or (numraid == 0 and numparty > 0) then
			EasyMenu(menuList, MarkingFrame, "cursor", 0, 0, "MENU", 1)
		end
	end
end)