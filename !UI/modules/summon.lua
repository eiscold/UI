if not Load"summon" then
	return
end

local SummonFrame = CreateFrame("Button", "SummonFrame", UIParent)
SummonFrame:SetHeight(15)
SummonFrame:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 6)
SummonFrame:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 6)
CreateBG(SummonFrame, .7)
SummonFrame:Hide()
SummonFrame:SetScript("OnEvent",
	function(self, event, ...) self[event](self, event, ...)
end)
SummonFrame.glow = CreateFrame("Frame", nil, SummonFrame)
SummonFrame.glow:SetBackdrop(BACKDROP)
SummonFrame.glow:SetPoint("TOPLEFT", SummonFrame, -5, 5)
SummonFrame.glow:SetPoint("BOTTOMRIGHT", SummonFrame, 5, -5)
SummonFrame.glow:SetBackdropBorderColor(GetMyPulseColor())
SummonFrame.glow:SetAlpha(0)
SummonFrame.timer = CreateFS(SummonFrame, 12, "RIGHT")
SummonFrame.timer:SetPoint("TOPLEFT", SummonFrame, "TOPLEFT")
SummonFrame.timer:SetPoint("TOPRIGHT", SummonFrame, "TOPRIGHT")
SummonFrame.summoner = CreateFS(SummonFrame, 12, "CENTER")
SummonFrame.location = CreateFS(SummonFrame, 12, "LEFT")
SummonFrame.location:SetPoint("TOPLEFT", SummonFrame, "TOPLEFT")
SummonFrame.location:SetPoint("TOPRIGHT", SummonFrame, "TOPRIGHT", -25, 0)
SummonFrame.totalElapsed = 0
SummonFrame.pending = false
SummonFrame.battleground = 0

local function Accept()
	if SummonFrame.battleground == 0 then
		ConfirmSummon()
	else
		AcceptBattlefieldPort(SummonFrame.battleground, true)
	end
end

function Update(self, elapsed)
	SummonFrame.totalElapsed = SummonFrame.totalElapsed + elapsed
	if SummonFrame.totalElapsed >= .5 then
		UpdateTimer()
		SummonFrame.totalElapsed = 0
	end
end

function UpdateTimer()
	local timeLeft
	if SummonFrame.battleground == 0 then
		timeLeft = GetSummonConfirmTimeLeft()
	else
		timeLeft = GetBattlefieldPortExpiration(SummonFrame.battleground)
	end
	if timeLeft ~= nil and timeLeft > 0 and SummonFrame.pending then
		local min = floor(timeLeft / 60)
		local sec = tostring(mod(timeLeft, 60))
		if tonumber(sec) < 10 then
			sec = "0"..sec
		end
		SummonFrame.timer:SetFormattedText("%i:%s", min, sec)
	else
		print(L["SummonMissed"])
		SummonFrame.pending = false
		SummonFrame:Hide()
		SummonFrame:SetScript("OnUpdate", nil)
	end
end

SummonFrame:RegisterEvent"CONFIRM_SUMMON"
function SummonFrame:CONFIRM_SUMMON(self, ...)
	StaticPopup_Hide"CONFIRM_SUMMON"
	SummonFrame.pending = true
	SummonFrame.battleground = 0
	SummonFrame.summoner:SetText(GetSummonConfirmSummoner())
	SummonFrame.location:SetText(GetSummonConfirmAreaName())
	print(format(L["SummonNew"], SummonFrame.summoner:GetText(), SummonFrame.location:GetText()))
	SummonFrame:Show()
	SummonFrame:SetScript("OnUpdate", function(...)
		Update(...)
	end)
end

SummonFrame:RegisterEvent"UPDATE_BATTLEFIELD_STATUS"
function SummonFrame:UPDATE_BATTLEFIELD_STATUS(self, ...)
	for i = 1, MAX_BATTLEFIELD_QUEUES do
		status, mapName, instanceID = GetBattlefieldStatus(i)
		if status == "confirm" then
			StaticPopup_Hide"CONFIRM_BATTLEFIELD_ENTRY"
			SummonFrame.pending = true
			SummonFrame.battleground = i
			SummonFrame.location:SetText(mapName)
			print(format("%s: %s", BATTLEFIELD_JOIN, SummonFrame.location:GetText()))
			SummonFrame:Show()
			SummonFrame:SetScript("OnUpdate", function(...) Update(...) end)
		end
	end
end

SummonFrame:RegisterForClicks"AnyUp"
SummonFrame:SetScript("OnClick", function(self, button, down)
	if button == "LeftButton" and SummonFrame.pending then
		Accept()
		SummonFrame:Hide()
		SummonFrame.pending = false
		SummonFrame:SetScript("OnUpdate", nil)
	elseif button == "RightButton" and SummonFrame.pending then
		CancelSummon()
		SummonFrame:Hide()
		SummonFrame.pending = false
		SummonFrame:SetScript("OnUpdate", nil)
	end
end)

SummonFrame:SetScript("OnShow", function(self)
	SummonFrame.glow:SetAlpha(1)
	CreatePulse(SummonFrame.glow)
end)

SummonFrame:SetScript("OnHide", function(self)
	SummonFrame.glow:SetScript("OnUpdate", nil)
	SummonFrame.glow:SetAlpha(0)
end)