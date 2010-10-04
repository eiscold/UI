if not Load"dps" then
	return
end

local DpsFrame = CreateFrame"Frame"
DpsFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)

local collecting = false
local startTime = nil
local endTime = nil
local damageDone = 0
local healDone = 0

local damageText = CreateFS(UIParent, 12, "LEFT")
damageText:SetPoint("BOTTOMLEFT", ufTarget, "TOPLEFT", 0, 14)
local damageTotalText = CreateFS(UIParent, 9, "RIGHT")
damageTotalText:SetPoint("LEFT", damageText, "RIGHT")
local healText = CreateFS(UIParent, 12, "LEFT")
healText:SetPoint("LEFT", damageTotalText, "RIGHT", 10, 0)
local healTotalText = CreateFS(UIParent, 9, "RIGHT")
healTotalText:SetPoint("LEFT", healText, "RIGHT")

local playerGUID = nil
local petGUID = nil
local vehicleGUID = nil

function UpdateDisplay()
	if startTime ~= nil then
		local duration = 1
		if (DpsFrame.lastTime - startTime) > 1 then
			duration = DpsFrame.lastTime - startTime
		end
		if damageDone ~= 0 then
			damageText:SetFormattedText("%i", (damageDone / duration))
			damageTotalText:SetFormattedText("%s", tostring(GetShortValue(damageDone)))
		end
		if healDone ~= 0 then
			healText:SetFormattedText("%i", (healDone / duration) )
			healTotalText:SetFormattedText("%s", tostring(GetShortValue(healDone)))
			if damageDone == 0 then
				healText:ClearAllPoints()
				healText:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", -114, 314)
			else
				healText:ClearAllPoints()
				healText:SetPoint("LEFT", damageTotalText, "RIGHT", 10, 0)
			end
		end
	else
		damageText:SetText""
		damageTotalText:SetText""
		healText:SetText""
		healTotalText:SetText""
	end
end

DpsFrame:RegisterEvent"PLAYER_LOGIN"
function DpsFrame:PLAYER_LOGIN(self, event)
	playerGUID = UnitGUID"player"
	petGUID = UnitGUID"playerpet"
	vehicleGUID = UnitGUID"vehicle"
end

DpsFrame:RegisterEvent"UNIT_PET"
function DpsFrame:UNIT_PET(self, event, unit)
	if unit == "player" then
		petGUID = UnitGUID"playerpet"
	end
end

DpsFrame:RegisterEvent"UNIT_ENTERED_VEHICLE"
function DpsFrame:UNIT_ENTERED_VEHICLE(self, event, unit)
	if unit == "player" then
		vehicleGUID = UnitGUID"vehicle"
	end
end

DpsFrame:RegisterEvent"UNIT_EXITED_VEHICLE"
function DpsFrame:UNIT_EXITED_VEHICLE(self, event, unit)
	if unit == "player" then
		vehicleGUID = nil
	end
end

DpsFrame:RegisterEvent"PLAYER_REGEN_DISABLED"
function DpsFrame:PLAYER_REGEN_DISABLED(self, event)
	collecting = true
	startTime = nil
	DpsFrame.lastTime = nil
	damageDone = 0 
	healDone = 0
	UpdateDisplay()
end

DpsFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
function DpsFrame:PLAYER_REGEN_ENABLED(self, event)
	collecting = false
	UpdateDisplay()
	damageText:SetText""
	damageTotalText:SetText""
	healText:SetText""
	healTotalText:SetText""
end

DpsFrame:RegisterEvent"PLAYER_TARGET_CHANGED"
function DpsFrame:PLAYER_TARGET_CHANGED(self, event, arg)
	if arg == nil then
		damageText:SetText""
		damageTotalText:SetText""
		healText:SetText""
		healTotalText:SetText""
	end
end

DpsFrame:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
function DpsFrame:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, srcGuid, _, _, destGuid, _, _, param1, param2, param3, param4, param5, param6, param7, param8)
	if collecting and (srcGuid == playerGUID or srcGuid == petGUID or srcGuid == vehicleGUID) then
		if event == "SWING_DAMAGE" then
			damageDone = damageDone + param1
			DpsFrame.lastTime = GetTime()
			if startTime == nil then
				startTime = GetTime()
			end
			UpdateDisplay()
		elseif event == "SPELL_DAMAGE" or event == "SPELL_PERIODIC_DAMAGE" or event == "RANGE_DAMAGE" then
			damageDone = damageDone + param4
			DpsFrame.lastTime = GetTime()
			if startTime == nil then
				startTime = GetTime()
			end
			UpdateDisplay()
		elseif event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
			healDone = healDone + param4
			DpsFrame.lastTime = GetTime()
			if startTime == nil then
				startTime = GetTime()
			end
			UpdateDisplay()
		end
	end
end