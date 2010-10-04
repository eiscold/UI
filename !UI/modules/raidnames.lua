if not Load"raidnames" then
	return
end

local RaidNames = CreateFrame"Frame"
RaidNames:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

RaidNames:RegisterEvent"PLAYER_ENTERING_WORLD"
function RaidNames:PLAYER_ENTERING_WORLD(self, event, ...)
	local _, instanceType = IsInInstance()
	if instanceType == "raid" or instanceType == "party" then
		SetCVar("UnitNameFriendlyPlayerName", 0)
	else
		SetCVar("UnitNameFriendlyPlayerName", 1)
	end
end