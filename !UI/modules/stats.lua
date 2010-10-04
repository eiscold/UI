if not Load"stats" then
	return
end

local totalmemory, memory, n, totaltime, addons, entry = 0, 0, 0, 0, {}

local StatsFrame = CreateFrame("Button", "stats", UIParent)
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
		memory = GetAddOnMemoryUsage(i)
		if memory > 0 then
			n = n + 1
			entry = {name = GetAddOnInfo(i), memory = memory}
			addons[n] = entry
			totalmemory = totalmemory + memory
		end
	end
	sort(addons, SortOrder)
	GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -5, 0)
	GameTooltip:AddDoubleLine(format("%sms", select(3, GetNetStats())), date"%H:%M", 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine" "
	GameTooltip:AddDoubleLine("Addons", format("%.1f kb", totalmemory), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine" "
	for _, entry in next, addons do
		GameTooltip:AddDoubleLine(entry.name, format("%.1f kb", entry.memory), 1, 1, 1,  1, 1, 1)
	end
	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
	totalmemory, n = 0, 0
	wipe(addons)
end

StatsFrame:SetScript("OnEnter", OnEnter)
StatsFrame:SetScript("OnLeave", OnLeave)