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

local bg = ThreatMeterFrame:CreateTexture(nil, "ARTWORK")
bg:SetTexture(TEXTURE)
bg:SetVertexColor(r, g, b, 0.2)
bg:SetAllPoints(ThreatMeterFrame)

CreateBG(ThreatMeterFrame)

local nametext = CreateFS(ThreatMeterFrame, 12, "LEFT")
nametext:SetPoint("BOTTOMLEFT", ThreatMeterFrame, "TOPLEFT", 0, 2)
 
local tunit, tguid = "target", ""
local tlist = {}

local function AddThreat(unit)
	if not UnitIsVisible(unit) then
		return
	end
	local _, _, perc = UnitDetailedThreatSituation(unit, tunit)
	if not perc or perc < 1 then
		return
	end
	local _, class = UnitClass(unit)
	local name = UnitName(unit)
	for index, value in ipairs(tlist) do
		if value.name == name then
			tremove(tlist, index)
			break
		end
	end
	tinsert(tlist, {
		name = name,
		class = class,
		perc = perc,
	})
end

local function SortThreat(a, b)
	return a.perc > b.perc
end

local function UpdateBar()
	sort(tlist, SortThreat)
	local tanking = UnitDetailedThreatSituation("player", tunit)
	for i, v in ipairs(tlist) do
		if (tanking and i == 2) or (not tanking and v.name == PNAME) then
			ThreatMeterFrame:SetStatusBarColor(1, .35, .2)
			ThreatMeterFrame:SetValue(floor(v.perc))
			if tanking then
				nametext:SetText(v.name)
			else
				ThreatMeterFrame:SetStatusBarColor(r, g, b)
				nametext:SetText""
			end
			return ThreatMeterFrame:Show()
		end
	end
	ThreatMeterFrame:Hide()
end

ThreatMeterFrame:SetScript("OnEvent", function(self, event, unit) self[event](self, event, unit) end)

ThreatMeterFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
function ThreatMeterFrame:PLAYER_REGEN_ENABLED()
	wipe(tlist)
	UpdateBar()
end

ThreatMeterFrame:RegisterEvent"PLAYER_TARGET_CHANGED"
function ThreatMeterFrame:PLAYER_TARGET_CHANGED()
	wipe(tlist)
	if UnitExists(tunit) and not UnitIsDead(tunit) and not UnitIsPlayer(tunit) and not UnitIsFriend("player", tunit) then
		tguid = UnitGUID(tunit)
		if UnitThreatSituation("player", tunit) then
			ThreatMeterFrame:UNIT_THREAT_LIST_UPDATE("UNIT_THREAT_LIST_UPDATE", tunit)
		else
			UpdateBar()
		end
	else
		tguid = ""
		UpdateBar()
	end
end

ThreatMeterFrame:RegisterEvent"UNIT_THREAT_LIST_UPDATE"
function ThreatMeterFrame:UNIT_THREAT_LIST_UPDATE(event, unit)
	if unit and UnitExists(unit) and UnitGUID(unit) == tguid then
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