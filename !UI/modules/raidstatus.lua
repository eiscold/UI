if not Load"raidstatus" then
	return
end

local RaidStatusFrame = CreateFrame("Button", nil, UIParent)
RaidStatusFrame.text = CreateFS(UIParent, 12, "RIGHT")
RaidStatusFrame.text:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -2, -3)
RaidStatusFrame.text:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -3)
RaidStatusFrame.lastUpdate = 0
RaidStatusFrame.updateInterval = 1
RaidStatusFrame.watches = {}

local function AddWatch(name, callback)
	RaidStatusFrame.watches[name] = callback
end

local function memberSortCompare(a, b)
	return ((a.color.r + a.color.g + a.color.b)..a.name) < ((b.color.r + b.color.g + b.color.b)..b.name)
end

local function OnUpdate(self, elapsed)
	RaidStatusFrame.lastUpdate = RaidStatusFrame.lastUpdate + elapsed
	local result = nil
	if RaidStatusFrame.lastUpdate > RaidStatusFrame.updateInterval and GetNumRaidMembers() > 0 then
		RaidStatusFrame.lastUpdate = 0
		for name, callback in pairs(RaidStatusFrame.watches) do
			local count = 0
			for i = 1, GetNumRaidMembers() do
				local unit = "raid"..i
				if UnitExists(unit) and callback(unit) then
					count = count + 1
				end
			end
			if count > 0 then
				result = (result and result..", " or "")..name..": "..count
			end
		end
		if result then
			RaidStatusFrame.text:SetText(result)
			RaidStatusFrame.text:Show()
			RaidStatusFrame:SetWidth(RaidStatusFrame.text:GetWidth())
		else
			RaidStatusFrame.text:Hide()
		end
	elseif GetNumRaidMembers() < 1 then
		RaidStatusFrame.text:Hide()
	end
end

local function OnEnter()
	GameTooltip:SetOwner(RaidStatusFrame, "ANCHOR_TOPLEFT")
	for name, callback in pairs(RaidStatusFrame.watches) do
		local matches = {}
		for i = 1, GetNumRaidMembers() do
			local unit = "raid"..i
			if UnitExists(unit) and callback(unit) then
				local _, classId = UnitClass(unit)
				table.insert(matches, {name = UnitName(unit), color = RAID_CLASS_COLORS[classId]})
			end
		end
		if next(matches) then
			if GameTooltip:NumLines() > 0 then
				GameTooltip:AddLine" "
			end
			GameTooltip:AddLine(name..":", 1, 1, 1)
			table.sort(matches, memberSortCompare)
			for _, match in pairs(matches) do
				GameTooltip:AddLine(match.name, match.color.r, match.color.g, match.color.b)
			end
		end
	end
	GameTooltip:Show()
end

RaidStatusFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -3, -3)
RaidStatusFrame:SetHeight(20)
RaidStatusFrame:SetWidth(120)
RaidStatusFrame:SetScript("OnUpdate", OnUpdate)
RaidStatusFrame:SetScript("OnEnter", OnEnter)
RaidStatusFrame:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

AddWatch(DEAD, function(unit) return UnitIsDeadOrGhost(unit) end)
AddWatch(PLAYER_OFFLINE, function(unit) return not UnitIsConnected(unit) end)
AddWatch(AFK, function(unit) return UnitIsAFK(unit) end)