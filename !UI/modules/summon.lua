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

local SummonPulseFrame = CreateFrame("Frame", nil, UIParent)
SummonPulseFrame:SetHeight(15)
SummonPulseFrame:SetWidth(SummonFrame:GetWidth())
SummonPulseFrame:SetPoint("CENTER", SummonFrame, "CENTER")
SummonPulseFrame:SetFrameStrata"BACKGROUND"
SummonPulseFrame.bg, SummonPulseFrame.bd = CreateBG(SummonPulseFrame, .7)
SummonPulseFrame.bd:Hide()
SummonPulseFrame.bg:SetTexture(.9, .1, .1)
SummonPulseFrame:Hide()

local timer = CreateFS(SummonFrame, 12, "RIGHT")
timer:SetPoint("TOPLEFT", SummonFrame, "TOPLEFT")
timer:SetPoint("TOPRIGHT", SummonFrame, "TOPRIGHT")
local summoner = CreateFS(SummonFrame, 12, "CENTER")
local location = CreateFS(SummonFrame, 12, "LEFT")
location:SetPoint("TOPLEFT", SummonFrame, "TOPLEFT")
location:SetPoint("TOPRIGHT", SummonFrame, "TOPRIGHT", -25, 0)
local totalElapsed = 0
local pending = false
local bg = 0

local function Accept()
	if bg == 0 then
		ConfirmSummon()
	else
		AcceptBattlefieldPort(bg, true)
	end
end

local function Cancel()
	CancelSummon()
end

function Update(self, elapsed)
	totalElapsed = totalElapsed + elapsed
	if totalElapsed >= .5 then
		UpdateTimer()
		totalElapsed = 0
	end
end

function UpdateTimer()
	local timeLeft
	if bg == 0 then
		timeLeft = GetSummonConfirmTimeLeft()
	else
		timeLeft = GetBattlefieldPortExpiration(bg)
	end
	if timeLeft ~= nil and timeLeft > 0 and pending then
		local min = floor(timeLeft / 60)
		local sec = tostring(mod(timeLeft, 60))
		if tonumber(sec) < 10 then
			sec = "0"..sec
		end
		timer:SetFormattedText("%i:%s", min, sec)
	else
		print(L["SummonMissed"])
		pending = false
		SummonFrame:Hide()
		SummonFrame:SetScript("OnUpdate", nil)
	end
end

SummonFrame:RegisterEvent"CONFIRM_SUMMON"
function SummonFrame:CONFIRM_SUMMON(self, ...)
	StaticPopup_Hide"CONFIRM_SUMMON"
	pending = true
	bg = 0
	summoner:SetText(GetSummonConfirmSummoner())
	location:SetText(GetSummonConfirmAreaName())
	print(format(L["SummonNew"], summoner:GetText(), location:GetText()))
	SummonFrame:Show()
	SummonFrame:SetScript("OnUpdate", function(...) Update(...) end)
end

SummonFrame:RegisterEvent"UPDATE_BATTLEFIELD_STATUS"
function SummonFrame:UPDATE_BATTLEFIELD_STATUS(self, ...)
	for i = 1, MAX_BATTLEFIELD_QUEUES do
		status, mapName, instanceID = GetBattlefieldStatus(i)
		if status == "confirm" then
			StaticPopup_Hide"CONFIRM_BATTLEFIELD_ENTRY"
			pending = true
			bg = i
			location:SetText(mapName)
			print(format("%s: %s", BATTLEFIELD_JOIN, location:GetText()))
			SummonFrame:Show()
			SummonFrame:SetScript("OnUpdate", function(...) Update(...) end)
		end
	end
end

SummonFrame:RegisterForClicks"AnyUp"
SummonFrame:SetScript("OnClick", function(self, button, down)
	if button == "LeftButton" and pending then
		Accept()
		SummonFrame:Hide()
		pending = false
		SummonFrame:SetScript("OnUpdate", nil)
	elseif button == "RightButton" and pending then
		Cancel()
		SummonFrame:Hide()
		pending = false
		SummonFrame:SetScript("OnUpdate", nil)
	end
end)

SummonFrame:SetScript("OnShow", function(self, event, ...)
	SummonPulseFrame:Show()
	CreatePulse(SummonPulseFrame)
end)

SummonFrame:SetScript("OnHide", function(self, event, ...)
	DestroyPulse(SummonPulseFrame)
	SummonPulseFrame:Hide()
end)