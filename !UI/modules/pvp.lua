if not Load"pvp" then
	return
end

local PVPCountdownFrame = CreateFrame"Frame"
PVPCountdownFrame.countDown = 0
PVPCountdownFrame.timeTill = {
	[L["1 minute"]] = 62,
	[L["One minute"]] = 62,
	[L["60 seconds"]] = 62,
	[L["30 seconds"]] = 31,
	[L["15 seconds"]] = 16,
	[L["Forty five seconds"]] = 47,
	[L["Thirty seconds"]] = 31,
	[L["Fifteen seconds"]] = 16,
}
PVPCountdownFrame:SetScript("OnEvent", function(self, event, msg)
	self[event](self, event, msg)
end)
PVPCountdownFrame:Hide()
PVPCountdownFrame.text = CreateFS(PVPCountdownFrame, 60, "CENTER")
PVPCountdownFrame.text:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
PVPCountdownFrame.text:SetTextColor(1, 0, 0)

function OnUpdate(self, elapsed)
	PVPCountdownFrame.countDown = PVPCountdownFrame.countDown - elapsed
	if PVPCountdownFrame.countDown > 0.1 then
		PVPCountdownFrame.text:SetText(string.format("%."..(1 or 0).."f", PVPCountdownFrame.countDown))
	else
		PVPCountdownFrame.text:SetText""
		PVPCountdownFrame:Hide()
		PVPCountdownFrame:SetScript("OnUpdate", nil)
		PVPCountdownFrame.countDown = 0	
	end
end

PVPCountdownFrame:RegisterEvent"CHAT_MSG_BG_SYSTEM_NEUTRAL"
function PVPCountdownFrame:CHAT_MSG_BG_SYSTEM_NEUTRAL(self, msg)
	for text, duration in pairs(PVPCountdownFrame.timeTill) do
		if strmatch(strlower(msg), strlower(text)) then
			PVPCountdownFrame.countDown = duration
			break
		end
	end
	if PVPCountdownFrame.countDown > 0 and not PVPCountdownFrame:IsShown() then
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