if not Load"stats" then
	return
end

local StatsFrame = CreateFrame("Button", "stats", UIParent)
StatsFrame.totalMemory = 0
StatsFrame.memory = 0
StatsFrame.count = 0
StatsFrame.totalTime = 0
StatsFrame.addons = {}
StatsFrame.entry = {}
StatsFrame:SetPoint("BOTTOM", Minimap, "BOTTOM")
StatsFrame:SetHeight(20)
StatsFrame:SetWidth(80)

local function SortOrder(a, b)
	return a.memory > b.memory
end

local function OnEnter()
	collectgarbage()
	UpdateAddOnMemoryUsage()
	for i = 1, GetNumAddOns() do
		StatsFrame.memory = GetAddOnMemoryUsage(i)
		if StatsFrame.memory > 0 then
			StatsFrame.count = StatsFrame.count + 1
			StatsFrame.entry = {name = GetAddOnInfo(i), memory = StatsFrame.memory}
			StatsFrame.addons[StatsFrame.count] = StatsFrame.entry
			StatsFrame.totalMemory = StatsFrame.totalMemory + StatsFrame.memory
		end
	end
	sort(StatsFrame.addons, SortOrder)
	GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -5, 0)
	GameTooltip:AddDoubleLine(format("%sms", select(3, GetNetStats())), date"%H:%M", 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine" "
	GameTooltip:AddDoubleLine("Addons", format("%.1f kb", StatsFrame.totalMemory), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine" "
	for _, entry in next, StatsFrame.addons do
		GameTooltip:AddDoubleLine(entry.name, format("%.1f kb", entry.memory), 1, 1, 1,  1, 1, 1)
	end
	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
	StatsFrame.totalMemory, StatsFrame.count = 0, 0
	wipe(StatsFrame.addons)
end

StatsFrame:SetScript("OnEnter", OnEnter)
StatsFrame:SetScript("OnLeave", OnLeave)