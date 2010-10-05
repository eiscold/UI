if not Load"fade" then
	return
end

local FadeFrame = CreateFrame"Frame"
FadeFrame.MouseOver = {}
FadeFrame.frames = {
	["ufPlayer"] = {
		alpha = .5,
		hover = {
			alpha = .3,
		},
	},
	["ufPlayerBuffFrame"] = {
		cond = "combatcasttarget",
		alpha = .3,
	},
	["ufFocus"]	= {
		cond = "combatcasttarget",
		hover = {
			alpha = .5,
		},
	},
	["ufPet"] = {
		cond = "combatcasttarget",
		alpha = .5,
		hover = {
			alpha = .5,
		},
	},
	["ufParty"] = {
		cond = "combatcast",
		alpha = .5,
	},
	["ufRaid1"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid2"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid3"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid4"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid5"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid6"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid7"] = {
		cond = "combat",
		alpha = .5,
	},
	["ufRaid8"] = {
		cond = "combat",
		alpha = .5,
	},
	["CoolLineFrame"] = {
		alpha = 0,
		showalpha = .5,
	},
	["ActionBar1"] = {
		cond = "combatcasttarget",
		alpha = .3,
	},
}

function Hide(name, entry)
	if not FadeFrame.MouseOver[name] then
		_G[name]:SetAlpha(entry.alpha or 0)
	end
end

function Show(name, entry)
	_G[name]:SetAlpha(entry.showalpha or 1)
end

function AddMouseOver(frame, name, entry)
	frame:HookScript("OnEnter", function(self, ...)
		FadeFrame.MouseOver[self:GetName()] = true
		Show(name, entry)
	end)
	frame:HookScript("OnLeave", function(self, ...)
		FadeFrame.MouseOver[self:GetName()] = false
		if not Pending"player" then
			Hide(name, entry)
		end
	end)
end

function Pending(unit, cond)
	local num, str = UnitPowerType(unit)
	if cond then
		if UnitCastingInfo(unit) and cond:find"cast" then
			return true
		elseif UnitAffectingCombat(unit) and cond:find"combat" then
			return true
		elseif unit == "pet" and GetPetHappiness() and GetPetHappiness() < 3 then
			return true
		elseif UnitName"target" and cond:find"target" then
			return true
		elseif UnitHealth(unit) < UnitHealthMax(unit) and cond:find"notfullhealth" then
			return true
		elseif (str == "RAGE" or str == "RUNIC_POWER") and UnitPower(unit) > 0 then
			return true
		elseif str ~= "RAGE" and str ~= "RUNIC_POWER" and UnitMana(unit) < UnitManaMax(unit) and cond:find"notfullmana" then
			return true
		end
	else
		if UnitCastingInfo(unit) then
			return true
		elseif UnitAffectingCombat(unit) then
			return true
		elseif unit == "pet" and GetPetHappiness() and GetPetHappiness() < 3 then
			return true
		elseif UnitName"target" then
			return true
		elseif UnitHealth(unit) < UnitHealthMax(unit) then
			return true
		elseif (str == "RAGE" or str == "RUNIC_POWER") and UnitPower(unit) > 0 then
			return true
		elseif str ~= "RAGE" and str ~= "RUNIC_POWER" and UnitMana(unit) < UnitManaMax(unit) then
			return true
		end
	end
end

FadeFrame:SetScript("OnEvent", function(self, event, ...) 
	for name, entry in pairs(FadeFrame.frames) do
		local frame = _G[name]
		if frame and name then
			if Pending("player", entry.cond) then
				Show(name, entry)
			else
				Hide(name, entry)
			end
			if entry.hover and not entry.hover.done then
				AddMouseOver(frame, name, entry)
				entry.hover.done = true
			end
		end
	end
end)

FadeFrame:RegisterEvent"PLAYER_REGEN_DISABLED"
FadeFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
FadeFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
FadeFrame:RegisterEvent"PLAYER_TARGET_CHANGED"
FadeFrame:RegisterEvent"UNIT_HEALTH"
FadeFrame:RegisterEvent"UNIT_MANA"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_START"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_FAILED"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_STOP"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_INTERRUPTED"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_DELAYED"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_CHANNEL_START"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_CHANNEL_UPDATE"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_CHANNEL_INTERRUPTED"
FadeFrame:RegisterEvent"UNIT_SPELLCAST_CHANNEL_STOP"