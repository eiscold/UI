if not Load"combattext" then
	return
end

ENTERING_COMBAT = "++ "..string.upper(COMBAT).." ++"
LEAVING_COMBAT = "-- "..string.upper(COMBAT).." --"
DAMAGE_TEXT_FONT = FONT

local CombatFrame = CreateFrame"Frame"
CombatFrame.CritPrefix = "*"
CombatFrame.CritPostfix = "*"
CombatFrame.Damage = true
CombatFrame.DamageColor = true
CombatFrame.FontSize = FONT_SIZE
CombatFrame.FontFlag = "THINOUTLINE"
CombatFrame.Healing = true
CombatFrame.Icons = true
CombatFrame.IconSize = 28
CombatFrame.Scrollable = true
CombatFrame.Treshold = 1
CombatFrame.TresholdHeal = 1

if CombatFrame.Damage then
	CombatFrame.Num = 4
else
	CombatFrame.Num = 3
end

local function SetUnit()
	if UnitHasVehicleUI"player" then
		CombatFrame.unit = "vehicle"
	else
		CombatFrame.unit = "player"
	end
	CombatTextSetActiveUnit(CombatFrame.unit)
end

local function LimitLines()
	for i = 1, #CombatFrame.frames do
		CombatFrame.frames[i]:SetMaxLines(CombatFrame.frames[i]:GetHeight() / CombatFrame.FontSize)
	end
end

local function SetScroll()
	for i = 1, #CombatFrame.frames do
		CombatFrame.frames[i]:EnableMouseWheel(true)
		CombatFrame.frames[i]:SetScript("OnMouseWheel", function(self, delta)
			if delta > 0 then
				self:ScrollUp()
			elseif delta < 0 then
				self:ScrollDown()
			end
		end)
	end
end

local function ScrollDirection()
	if COMBAT_TEXT_FLOAT_MODE == "2" then
		CombatFrame.Mode = "TOP"
	else
		CombatFrame.Mode = "BOTTOM"
	end
	for i = 2, 3 do
		CombatFrame.frames[i]:Clear()
		CombatFrame.frames[i]:SetInsertMode(CombatFrame.Mode)
	end
end

local function OnEvent(self, event, subevent, ...)
	if event == "COMBAT_TEXT_UPDATE" then
		local arg2, arg3 = ...
		if SHOW_COMBAT_TEXT == "0" then
			return
		else
			local part = "-%s (%s %s)"
			if subevent == "DAMAGE" then
				CombatFrame1:AddMessage("-"..arg2, .75, .1, .1)
			elseif subevent == "DAMAGE_CRIT" then
				CombatFrame1:AddMessage(CombatFrame.CritPrefix.."-"..arg2..CombatFrame.CritPostfix, 1, .1, .1)
			elseif subevent == "SPELL_DAMAGE" then
				CombatFrame1:AddMessage("-"..arg2, .75, .3, .85)
			elseif subevent == "SPELL_DAMAGE_CRIT" then
				CombatFrame1:AddMessage(CombatFrame.CritPrefix.."-"..arg2..CombatFrame.CritPostfix, 1, .3, .5)
			elseif subevent == "HEAL" then
				CombatFrame2:AddMessage("+"..arg3, .1, .75, .1)
			elseif subevent == "HEAL_CRIT" then
				CombatFrame2:AddMessage(CombatFrame.CritPrefix.."+"..arg3..CombatFrame.CritPostfix, .1, 1, .1)
			elseif subevent == "PERIODIC_HEAL" then
				CombatFrame2:AddMessage("+"..arg3, .1, .5, .1)
			elseif subevent == "SPELL_CAST" then
				CombatFrame3:AddMessage(arg2, 1, .82, 0)
			elseif subevent == "MISS" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(MISS, .5, .5, .5)
			elseif subevent == "DODGE" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(DODGE, .5, .5, .5)
			elseif subevent == "PARRY" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(PARRY, .5, .5, .5)
			elseif subevent == "EVADE" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(EVADE, .5, .5, .5)
			elseif subevent == "IMMUNE" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(IMMUNE, .5, .5, .5)
			elseif subevent == "DEFLECT" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(DEFLECT, .5, .5, .5)
			elseif subevent == "REFLECT" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(REFLECT, .5, .5, .5)
			elseif subevent == "SPELL_MISS" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(MISS, .5, .5, .5)
			elseif subevent == "SPELL_DODGE" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(DODGE, .5, .5, .5)
			elseif subevent == "SPELL_PARRY" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(PARRY, .5, .5, .5)
			elseif subevent == "SPELL_EVADE" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(EVADE, .5, .5, .5)
			elseif subevent == "SPELL_IMMUNE" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(IMMUNE, .5, .5, .5)
			elseif subevent == "SPELL_DEFLECT" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(DEFLECT, .5, .5, .5)
			elseif subevent == "SPELL_REFLECT" and COMBAT_TEXT_SHOW_DODGE_PARRY_MISS == "1" then
				CombatFrame1:AddMessage(REFLECT, .5, .5, .5)
			elseif subevent == "RESIST" and COMBAT_TEXT_SHOW_RESISTANCES == "1" then
				if arg3 then
					CombatFrame1:AddMessage(part:format(arg2, RESIST, arg3), .75, .5, .5)
				else
					CombatFrame1:AddMessage(RESIST, .5, .5, .5)
				end
			elseif subevent == "BLOCK" and COMBAT_TEXT_SHOW_RESISTANCES == "1" then
				if arg3 then
					CombatFrame1:AddMessage(part:format(arg2, BLOCK, arg3), .75, .5, .5)
				else
					CombatFrame1:AddMessage(BLOCK, .5, .5, .5)
				end
			elseif subevent == "ABSORB" and COMBAT_TEXT_SHOW_RESISTANCES == "1" then
				if arg3 then
					CombatFrame1:AddMessage(part:format(arg2, ABSORB, arg3), .75, .5, .5)
				else
					CombatFrame1:AddMessage(ABSORB, .5, .5, .5)
				end
			elseif subevent == "SPELL_RESIST" and COMBAT_TEXT_SHOW_RESISTANCES == "1" then
				if arg3 then
					CombatFrame1:AddMessage(part:format(arg2, RESIST, arg3), .75, .5, .5)
				else
					CombatFrame1:AddMessage(RESIST, .5, .5, .5)
				end
			elseif subevent == "SPELL_BLOCK" and COMBAT_TEXT_SHOW_RESISTANCES == "1" then
				if arg3 then
					CombatFrame1:AddMessage(part:format(arg2, BLOCK, arg3), .75, .5, .5)
				else
					CombatFrame1:AddMessage(BLOCK, .5, .5, .5)
				end
			elseif subevent == "SPELL_ABSORB" and COMBAT_TEXT_SHOW_RESISTANCES == "1" then
				if arg3 then
					CombatFrame1:AddMessage(part:format(arg2, ABSORB, arg3), .75, .5, .5)
				else
					CombatFrame1:AddMessage(ABSORB, .5, .5, .5)
				end
			elseif subevent == "ENERGIZE" and COMBAT_TEXT_SHOW_ENERGIZE == "1" then
				CombatFrame3:AddMessage("+"..arg2, .1, .1, 1)
			elseif subevent == "PERIODIC_ENERGIZE" and COMBAT_TEXT_SHOW_PERIODIC_ENERGIZE == "1" then
				CombatFrame3:AddMessage("+"..arg2, .1, .1, .75)
			elseif subevent == "SPELL_AURA_START" and COMBAT_TEXT_SHOW_AURAS == "1" then
				CombatFrame3:AddMessage("+"..arg2, 1, .5, .5)
			elseif subevent == "SPELL_AURA_END" and COMBAT_TEXT_SHOW_AURAS == "1" then
				CombatFrame3:AddMessage("-"..arg2, .5, .5, .5)
			elseif subevent == "SPELL_AURA_START_HARMFUL" and COMBAT_TEXT_SHOW_AURAS == "1" then
				CombatFrame3:AddMessage("+"..arg2, 1, .1, .1)
			elseif subevent == "SPELL_AURA_END_HARMFUL" and COMBAT_TEXT_SHOW_AURAS == "1" then
				CombatFrame3:AddMessage("-"..arg2, .1, 1, .1)
			elseif subevent == "HONOR_GAINED" and COMBAT_TEXT_SHOW_HONOR_GAINED == "1" then
				CombatFrame3:AddMessage(HONOR.." +"..arg2, .1, .1, 1)
			elseif subevent == "FACTION" and COMBAT_TEXT_SHOW_REPUTATION == "1" then
				CombatFrame3:AddMessage(arg2.." +"..arg3, .1, .1, 1)
			elseif subevent == "SPELL_ACTIVE" and COMBAT_TEXT_SHOW_REACTIVES == "1" then
				CombatFrame3:AddMessage(arg2, 1, .82, 0)
			end
		end
	elseif event == "UNIT_HEALTH"  and  COMBAT_TEXT_SHOW_LOW_HEALTH_MANA == "1" then
		if subevent == CombatFrame.unit then
			if UnitHealth(CombatFrame.unit) / UnitHealthMax(CombatFrame.unit) <= COMBAT_TEXT_LOW_HEALTH_THRESHOLD then
				if not lowHealth then
					CombatFrame3:AddMessage(HEALTH_LOW, 1, .1, .1)
					lowHealth = true
				end
			else
				lowHealth = nil
			end
		end
	elseif event == "UNIT_MANA" and COMBAT_TEXT_SHOW_LOW_HEALTH_MANA == "1" then
		if subevent == CombatFrame.unit then
			local _, powerToken = UnitPowerType(CombatFrame.unit)
			if powerToken == "MANA" and (UnitPower(CombatFrame.unit) / UnitPowerMax(CombatFrame.unit)) <= COMBAT_TEXT_LOW_MANA_THRESHOLD then
				if not lowMana then
					CombatFrame3:AddMessage(MANA_LOW, 1, .1, .1)
					lowMana = true
				end
			else
				lowMana = nil
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" and COMBAT_TEXT_SHOW_COMBAT_STATE == "1" then
			CombatFrame3:AddMessage(LEAVING_COMBAT, .1, 1, .1)
	elseif event == "PLAYER_REGEN_DISABLED" and COMBAT_TEXT_SHOW_COMBAT_STATE == "1" then
			CombatFrame3:AddMessage(ENTERING_COMBAT, 1, .1, .1)
	elseif event == "UNIT_COMBO_POINTS" and COMBAT_TEXT_SHOW_COMBO_POINTS == "1" then
		if subevent == CombatFrame.unit then
			local cp = GetComboPoints(CombatFrame.unit, "target")
				if cp > 0 then
					r, g, b = 1, .82, 0
					if cp == MAX_COMBO_POINTS then
						r, g, b = 0, .82, 1
					end
					CombatFrame3:AddMessage(format(COMBAT_TEXT_COMBO_POINTS, cp), r, g, b)
				end
		end
	elseif event == "RUNE_POWER_UPDATE" then
		local arg1, arg2 = subevent, ...
		if arg2 == true then
			local rune = GetRuneType(arg1)
			local msg = COMBAT_TEXT_RUNE[rune]
			if rune == 1 then 
				r = .75
				g = 0
				b = 0
			elseif rune == 2 then
				r = .75
				g = 1
				b = 0
			elseif rune == 3 then
				r = 0
				g = 1
				b = 1	
			end
			if rune and rune < 4 then
				CombatFrame3:AddMessage("+"..msg, r, g, b)
			end
		end
	elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITING_VEHICLE" then
		if arg1 == "player" then
			SetUnit()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		SetUnit()
		ScrollDirection()
		if CombatFrame.Scrollable then
			SetScroll()
		else
			LimitLines()
		end
	end
end

CombatFrame.frames = {}
for i = 1, CombatFrame.Num do
	CombatFrame.frames[i] = CreateFrame("ScrollingMessageFrame", "CombatFrame"..i, UIParent)
	CombatFrame.frames[i]:SetFont(FONT, CombatFrame.FontSize, CombatFrame.FontFlag)
	CombatFrame.frames[i]:SetShadowColor(0, 0, 0, 0)
	CombatFrame.frames[i]:SetFadeDuration(.2)
	CombatFrame.frames[i]:SetTimeVisible(3)
	CombatFrame.frames[i]:SetMaxLines(128)
	CombatFrame.frames[i]:SetSpacing(1)
	CombatFrame.frames[i]:SetWidth(128)
	CombatFrame.frames[i]:SetHeight(128)
	CombatFrame.frames[i]:SetJustifyH"LEFT"
	CombatFrame.frames[i]:SetPoint("CENTER", 0, 0)
	if i == 1 then
		CombatFrame.frames[i]:SetJustifyH"LEFT"
		CombatFrame.frames[i]:SetPoint("BOTTOMRIGHT", ufTarget, "BOTTOMLEFT", -10, 200)
	elseif i == 2 then
		CombatFrame.frames[i]:SetJustifyH"LEFT"
		CombatFrame.frames[i]:SetPoint("BOTTOMRIGHT", ufTarget, "BOTTOMLEFT", -10, -25)
	elseif i == 3 then
		CombatFrame.frames[i]:SetJustifyH"RIGHT"
		CombatFrame.frames[i]:SetPoint("BOTTOMLEFT", ufTarget, "BOTTOMRIGHT", 10, -25)
	else
		CombatFrame.frames[i]:SetJustifyH"RIGHT"
		CombatFrame.frames[i]:SetPoint("BOTTOMLEFT", ufTarget, "BOTTOMRIGHT", 10, 200)
		if CombatFrame.Icons then
			local a, _, c = CombatFrame.frames[i]:GetFont()
			CombatFrame.frames[i]:SetFont(a, CombatFrame.IconSize / 2, c)
		end
	end
end

CombatFrame:RegisterEvent"COMBAT_TEXT_UPDATE"
CombatFrame:RegisterEvent"UNIT_HEALTH"
CombatFrame:RegisterEvent"UNIT_MANA"
CombatFrame:RegisterEvent"PLAYER_REGEN_DISABLED"
CombatFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
CombatFrame:RegisterEvent"UNIT_COMBO_POINTS"
if PCLASS == "DEATHKNIGHT" then
	CombatFrame:RegisterEvent"RUNE_POWER_UPDATE"
end
CombatFrame:RegisterEvent"UNIT_ENTERED_VEHICLE"
CombatFrame:RegisterEvent"UNIT_EXITING_VEHICLE"
CombatFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
CombatFrame:SetScript("OnEvent", OnEvent)

CombatText:UnregisterAllEvents()
CombatText:SetScript("OnLoad",nil)
CombatText:SetScript("OnEvent",nil)
CombatText:SetScript("OnUpdate",nil)

Blizzard_CombatText_AddMessage = CombatText_AddMessage
function CombatText_AddMessage(message, scrollFunction, r, g, b, displayType, isStaggered)
	CombatFrame3:AddMessage(message, r, g, b)
end

InterfaceOptionsCombatTextPanelFriendlyHealerNames:Hide()
COMBAT_TEXT_SCROLL_ARC = ""

hooksecurefunc("InterfaceOptionsCombatTextPanelFCTDropDown_OnClick", ScrollDirection)

if PCLASS == "PRIEST" then
	local ShadowPriestStopSpamFrame = CreateFrame"Frame"
	ShadowPriestStopSpamFrame:RegisterEvent"UPDATE_SHAPESHIFT_FORM"
	ShadowPriestStopSpamFrame:RegisterEvent"UPDATE_SHAPESHIFT_FORMS"
	ShadowPriestStopSpamFrame:SetScript("OnEvent", function()
		if GetShapeshiftForm() == 1 then
			SetCVar("CombatHealing", 0)
		else
			SetCVar("CombatHealing", 1)
		end
	end)
end

if CombatFrame.Damage then
	InterfaceOptionsCombatTextPanelTargetDamage:Hide()
	InterfaceOptionsCombatTextPanelPeriodicDamage:Hide()
	InterfaceOptionsCombatTextPanelPetDamage:Hide()
	SetCVar("CombatLogPeriodicSpells", 0)
	SetCVar("PetMeleeDamage", 0)
	SetCVar("CombatDamage", 0)
	CombatFrame4:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
	if CombatFrame.DamageColor then
		CombatFrame.dmgcolor = {}
		CombatFrame.dmgcolor[1] = {1, 1, 0} -- physical
		CombatFrame.dmgcolor[2] = {1, .9, .5} -- holy
		CombatFrame.dmgcolor[4] = {1, .5, 0} -- fire
		CombatFrame.dmgcolor[8] = {.3, 1, .3} -- nature
		CombatFrame.dmgcolor[16] = {.5, 1, 1} -- frost
		CombatFrame.dmgcolor[32] = {.5, .5, 1} -- shadow
		CombatFrame.dmgcolor[64] = {1, .5, 1} -- arcane
		CombatFrame.dmindex = {}
		CombatFrame.dmindex[1] = 1
		CombatFrame.dmindex[2] = 2
		CombatFrame.dmindex[3] = 4
		CombatFrame.dmindex[4] = 8
		CombatFrame.dmindex[5] = 16
		CombatFrame.dmindex[6] = 32
		CombatFrame.dmindex[7] = 64
	end

	local function Damage(self, event, ...)
		local msg
		local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = select(1, ...)
		if sourceGUID == UnitGUID"player" or sourceGUID == UnitGUID"pet" then
			local icon
			local msg
			local color = {}
			if eventType == "SWING_DAMAGE" then
				local amount, _, _, _, _, _, critical = select(9, ...)
				if amount >= CombatFrame.Treshold then
					if critical then
						msg = CombatFrame.CritPrefix..amount..CombatFrame.CritPostfix
					else
						msg = amount
					end
					CombatFrame4:AddMessage(msg)
				end
			elseif eventType == "RANGE_DAMAGE" then
				local spellId, _, _, amount, _, _, _, _, _, critical = select(9, ...)
				if amount >= CombatFrame.Treshold then
					if critical then
						msg = CombatFrame.CritPrefix..amount..CombatFrame.CritPostfix
					else
						msg = amount
					end
					CombatFrame4:AddMessage(msg)
				end
			elseif eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" then
				local spellId, _, spellSchool, amount, _, _, _, _, _, critical = select(9, ...)
				local icon
				local color = {}
				if amount >= CombatFrame.Treshold then
					if critical then
						msg = CombatFrame.CritPrefix..amount..CombatFrame.CritPostfix
					else
						msg = amount
					end
					if CombatFrame.Icons then
						_, _, icon = GetSpellInfo(spellId)
					end
					if CombatFrame.DamageColor then
						if CombatFrame.dmgcolor[spellSchool] then
							color = CombatFrame.dmgcolor[spellSchool]
						else
							color = CombatFrame.dmgcolor[1]
						end
					else
						color = {1, 1, 0}
					end
					if icon then
						msg = msg.." \124T"..icon..":"..CombatFrame.IconSize..":"..CombatFrame.IconSize..":0:0:64:64:5:59:5:59\124t"
					end
					CombatFrame4:AddMessage(msg, unpack(color))
				end
			elseif eventType == "SWING_MISSED" then
				local missType, _ = select(9, ...)
				CombatFrame4:AddMessage(missType)
			elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
				local _, _, _, missType, _ = select(9, ...) 
				CombatFrame4:AddMessage(missType)
			elseif eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
				if CombatFrame.Healing then
					local spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(9, ...) 
					local icon 
					local color = {}
					if amount >= CombatFrame.TresholdHeal then
						if critical then 
							msg = CombatFrame.CritPrefix..amount..CombatFrame.CritPostfix
							color = {.1, 1, .1}
						else
							msg = amount
							color = {.1, .75, .1}
						end 
						if CombatFrame.Icons then
							_, _, icon = GetSpellInfo(spellId)
						end
               					if icon then 
               		 				msg = msg.." \124T"..icon..":"..CombatFrame.IconSize..":"..CombatFrame.IconSize..":0:0:64:64:5:59:5:59\124t"
       		         			end 
						CombatFrame4:AddMessage(msg, unpack(color))
					end
				end
	
			end
		end
	end
	CombatFrame4:SetScript("OnEvent", Damage)
end