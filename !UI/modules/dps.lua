if not Load"dps" then
	return
end

local DpsFrame = CreateFrame"Frame"
DpsFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

DpsFrame.collecting = false
DpsFrame.startTime = nil
DpsFrame.endTime = nil
DpsFrame.damageDone = 0
DpsFrame.healDone = 0

DpsFrame.damageText = CreateFS(UIParent, 12, "LEFT")
DpsFrame.damageText:SetPoint("BOTTOMLEFT", ufTarget, "TOPLEFT", 0, 14)
DpsFrame.damageTotalText = CreateFS(UIParent, 9, "RIGHT")
DpsFrame.damageTotalText:SetPoint("LEFT", DpsFrame.damageText, "RIGHT")
DpsFrame.healText = CreateFS(UIParent, 12, "LEFT")
DpsFrame.healText:SetPoint("LEFT", DpsFrame.damageTotalText, "RIGHT", 10, 0)
DpsFrame.healTotalText = CreateFS(UIParent, 9, "RIGHT")
DpsFrame.healTotalText:SetPoint("LEFT", DpsFrame.healText, "RIGHT")

DpsFrame.playerGUID = nil
DpsFrame.petGUID = nil
DpsFrame.vehicleGUID = nil

local function UpdateDisplay()
	if DpsFrame.startTime ~= nil then
		local duration = 1
		if (DpsFrame.lastTime - DpsFrame.startTime) > 1 then
			duration = DpsFrame.lastTime - DpsFrame.startTime
		end
		if DpsFrame.damageDone ~= 0 then
			DpsFrame.damageText:SetFormattedText("%i", (DpsFrame.damageDone / duration))
			DpsFrame.damageTotalText:SetFormattedText("%s", tostring(GetShortValue(DpsFrame.damageDone)))
		end
		if DpsFrame.healDone ~= 0 then
			DpsFrame.healText:SetFormattedText("%i", (DpsFrame.healDone / duration) )
			DpsFrame.healTotalText:SetFormattedText("%s", tostring(GetShortValue(DpsFrame.healDone)))
			if DpsFrame.damageDone == 0 then
				DpsFrame.healText:ClearAllPoints()
				DpsFrame.healText:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -114, 314)
			else
				DpsFrame.healText:ClearAllPoints()
				DpsFrame.healText:SetPoint("LEFT", DpsFrame.damageTotalText, "RIGHT", 10, 0)
			end
		end
	else
		DpsFrame.damageText:SetText""
		DpsFrame.damageTotalText:SetText""
		DpsFrame.healText:SetText""
		DpsFrame.healTotalText:SetText""
	end
end

DpsFrame:RegisterEvent"PLAYER_LOGIN"
function DpsFrame:PLAYER_LOGIN(self, event)
	DpsFrame.playerGUID = UnitGUID"player"
	DpsFrame.petGUID = UnitGUID"playerpet"
	DpsFrame.vehicleGUID = UnitGUID"vehicle"
end

DpsFrame:RegisterEvent"UNIT_PET"
function DpsFrame:UNIT_PET(self, event, unit)
	if unit == "player" then
		DpsFrame.petGUID = UnitGUID"playerpet"
	end
end

DpsFrame:RegisterEvent"UNIT_ENTERED_VEHICLE"
function DpsFrame:UNIT_ENTERED_VEHICLE(self, event, unit)
	if unit == "player" then
		DpsFrame.vehicleGUID = UnitGUID"vehicle"
	end
end

DpsFrame:RegisterEvent"UNIT_EXITED_VEHICLE"
function DpsFrame:UNIT_EXITED_VEHICLE(self, event, unit)
	if unit == "player" then
		DpsFrame.vehicleGUID = nil
	end
end

DpsFrame:RegisterEvent"PLAYER_REGEN_DISABLED"
function DpsFrame:PLAYER_REGEN_DISABLED(self, event)
	DpsFrame.collecting = true
	DpsFrame.startTime = nil
	DpsFrame.lastTime = nil
	DpsFrame.damageDone = 0 
	DpsFrame.healDone = 0
	UpdateDisplay()
end

DpsFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
function DpsFrame:PLAYER_REGEN_ENABLED(self, event)
	DpsFrame.collecting = false
	UpdateDisplay()
	DpsFrame.damageText:SetText""
	DpsFrame.damageTotalText:SetText""
	DpsFrame.healText:SetText""
	DpsFrame.healTotalText:SetText""
end

DpsFrame:RegisterEvent"PLAYER_TARGET_CHANGED"
function DpsFrame:PLAYER_TARGET_CHANGED(self, event, arg)
	if arg == nil then
		DpsFrame.damageText:SetText""
		DpsFrame.damageTotalText:SetText""
		DpsFrame.healText:SetText""
		DpsFrame.healTotalText:SetText""
	end
end

DpsFrame:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
function DpsFrame:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, srcGuid, _, _, destGuid, _, _, param1, param2, param3, param4, param5, param6, param7, param8)
	if DpsFrame.collecting and (srcGuid == DpsFrame.playerGUID or srcGuid == DpsFrame.petGUID or srcGuid == DpsFrame.vehicleGUID) then
		if event == "SWING_DAMAGE" then
			DpsFrame.damageDone = DpsFrame.damageDone + param1
			DpsFrame.lastTime = GetTime()
			if DpsFrame.startTime == nil then
				DpsFrame.startTime = GetTime()
			end
			UpdateDisplay()
		elseif event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" then
			DpsFrame.damageDone = DpsFrame.damageDone + param4
			DpsFrame.lastTime = GetTime()
			if DpsFrame.startTime == nil then
				DpsFrame.startTime = GetTime()
			end
			UpdateDisplay()
		elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
			DpsFrame.healDone = DpsFrame.healDone + param4
			DpsFrame.lastTime = GetTime()
			if DpsFrame.startTime == nil then
				DpsFrame.startTime = GetTime()
			end
			UpdateDisplay()
		end
	end
end