if not Load"pvp" then
	return
end

local timetil = {
	[L["1 minute"]] = 62,
	[L["One minute"]] = 62,
	[L["60 seconds"]] = 62,
	[L["30 seconds"]] = 31,
	[L["15 seconds"]] = 16,
	[L["Forty five seconds"]] = 47,
	[L["Thirty seconds"]] = 31,
	[L["Fifteen seconds"]] = 16,
}

local countDown = 0

local PVPCountdownFrame = CreateFrame"Frame"
PVPCountdownFrame:SetScript("OnEvent", function(self, event, msg)
	self[event](self, event, msg)
end)
PVPCountdownFrame:Hide()

local PVPCountdownString = CreateFS(PVPCountdownFrame, 60, "CENTER")
PVPCountdownString:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
PVPCountdownString:SetTextColor(1, 0, 0)

function OnUpdate(self, elapsed)
	countDown = countDown - elapsed
	if countDown > 0.1 then
		PVPCountdownString:SetText(string.format("%."..(1 or 0).."f", countDown))
	else
		PVPCountdownString:SetText""
		PVPCountdownFrame:Hide()
		PVPCountdownFrame:SetScript("OnUpdate", nil)
		countDown = 0	
	end
end

PVPCountdownFrame:RegisterEvent"CHAT_MSG_BG_SYSTEM_NEUTRAL"
function PVPCountdownFrame:CHAT_MSG_BG_SYSTEM_NEUTRAL(self, msg)
	for text, duration in pairs(timetil) do
		if strmatch(strlower(msg), strlower(text)) then
			countDown = duration
			break
		end
	end
	if countDown > 0 and not PVPCountdownFrame:IsShown() then
		PVPCountdownFrame:Show()
		PVPCountdownFrame:SetScript("OnUpdate", OnUpdate)
	end
end

local PVPResurrectFrame = CreateFrame"Frame"
PVPResurrectFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)
PVPResurrectFrame:RegisterEvent"PLAYER_DEAD"
function PVPResurrectFrame:PLAYER_DEAD()
	if MiniMapBattlefieldFrame.status == "active" or GetZoneText() == L["Wintergrasp"] then
		RepopMe()
	end
end

WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 50, 120)

hooksecurefunc("WorldStateAlwaysUpFrame_Update", function()
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local cb = _G["WorldStateCaptureBar"..i]
		if cb and cb:IsShown() then
			cb:ClearAllPoints()
			cb:SetScale(0.75)
			cb:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -10)
		end
	end
end)