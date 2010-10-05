if not Load"threatmeter" then
	return
end

local r, g, b = GetMyColor()

local ThreatMeterFrame = CreateFrame("StatusBar", nil, UIParent)
ThreatMeterFrame:SetStatusBarTexture(TEXTURE)
ThreatMeterFrame:SetStatusBarColor(r, g, b)
ThreatMeterFrame:SetMinMaxValues(0, 100)
ThreatMeterFrame:SetWidth(229)
ThreatMeterFrame:SetHeight(5)
ThreatMeterFrame:SetPoint("BOTTOM", ufTarget, "TOP", 0, 6)
ThreatMeterFrame:Hide()
ThreatMeterFrame.bg = ThreatMeterFrame:CreateTexture(nil, "ARTWORK")
ThreatMeterFrame.bg:SetTexture(TEXTURE)
ThreatMeterFrame.bg:SetVertexColor(r, g, b, .2)
ThreatMeterFrame.bg:SetAllPoints(ThreatMeterFrame)
CreateBG(ThreatMeterFrame)
ThreatMeterFrame.text = CreateFS(ThreatMeterFrame, 12, "LEFT")
ThreatMeterFrame.text:SetPoint("BOTTOMLEFT", ThreatMeterFrame, "TOPLEFT", 0, 2)
ThreatMeterFrame.targetGUID = ""
ThreatMeterFrame.targetList = {}

local function AddThreat(unit)
	if not UnitIsVisible(unit) then
		return
	end
	local _, _, perc = UnitDetailedThreatSituation(unit, "target")
	if not perc or perc < 1 then
		return
	end
	local _, class = UnitClass(unit)
	local name = UnitName(unit)
	for index, value in ipairs(ThreatMeterFrame.targetList) do
		if value.name == name then
			tremove(ThreatMeterFrame.targetList, index)
			break
		end
	end
	tinsert(ThreatMeterFrame.targetList, {
		name = name,
		class = class,
		perc = perc,
	})
end

local function SortThreat(a, b)
	return a.perc > b.perc
end

local function UpdateBar()
	sort(ThreatMeterFrame.targetList, SortThreat)
	local tanking = UnitDetailedThreatSituation("player", "target")
	for i, v in ipairs(ThreatMeterFrame.targetList) do
		if (tanking and i == 2) or (not tanking and v.name == PNAME) then
			ThreatMeterFrame:SetStatusBarColor(unpack(reactioncolors[1]))
			ThreatMeterFrame:SetValue(floor(v.perc))
			if tanking then
				ThreatMeterFrame.text:SetText(v.name)
			else
				ThreatMeterFrame:SetStatusBarColor(r, g, b)
				ThreatMeterFrame.text:SetText""
			end
			return ThreatMeterFrame:Show()
		end
	end
	ThreatMeterFrame:Hide()
end

ThreatMeterFrame:SetScript("OnEvent", function(self, event, unit)
	self[event](self, event, unit)
end)

ThreatMeterFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
function ThreatMeterFrame:PLAYER_REGEN_ENABLED()
	wipe(ThreatMeterFrame.targetList)
	UpdateBar()
end

ThreatMeterFrame:RegisterEvent"PLAYER_TARGET_CHANGED"
function ThreatMeterFrame:PLAYER_TARGET_CHANGED()
	wipe(ThreatMeterFrame.targetList)
	if UnitExists"target" and not UnitIsDead"target" and not UnitIsPlayer"target" and not UnitIsFriend("player", "target") then
		ThreatMeterFrame.targetGUID = UnitGUID"target"
		if UnitThreatSituation("player", "target") then
			ThreatMeterFrame:UNIT_THREAT_LIST_UPDATE("UNIT_THREAT_LIST_UPDATE", "target")
		else
			UpdateBar()
		end
	else
		ThreatMeterFrame.targetGUID = ""
		UpdateBar()
	end
end

ThreatMeterFrame:RegisterEvent"UNIT_THREAT_LIST_UPDATE"
function ThreatMeterFrame:UNIT_THREAT_LIST_UPDATE(event, unit)
	if unit and UnitExists(unit) and UnitGUID(unit) == ThreatMeterFrame.targetGUID then
		if GetNumRaidMembers() > 0 then
			for i = 1, GetNumRaidMembers() do
				AddThreat("raid"..i)
			end
		elseif GetNumPartyMembers() > 0 then
			AddThreat"player"
			for i = 1, GetNumPartyMembers() do
				AddThreat("party"..i)
			end
		end
		UpdateBar()
	end
end

ThreatMeterFrame:RegisterEvent"UNIT_THREAT_SITUATION_UPDATE"
ThreatMeterFrame.UNIT_THREAT_SITUATION_UPDATE = ThreatMeterFrame.UNIT_THREAT_LIST_UPDATE