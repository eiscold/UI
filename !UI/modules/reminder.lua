if not Load"reminder" then
	return
end

local ReminderFrame = CreateFrame("Frame", nil, ufPlayer)
ReminderFrame.reminders = {}
ReminderFrame.buffs = {
	["DEATHKNIGHT"] = {
		[1] = {
			57330, -- horn of Winter
			8075, -- Shaman Strength of Earth Totem
		},
	},
	["DRUID"] = {
		[1] = {
			48469, -- mark of the wild
		},
		[2] = {
			66068, -- thorns
		},
	},
	["HUNTER"] = {
		[1] = {
			13163, -- monkey
			13165, -- hawk
			5118, -- cheetah
			34074, -- viper
			13161, -- beast
			13159, -- pack
			20043, -- wild
			61846, -- dragonhawk
		},
	},
	["MAGE"] = {
		[1] = {
			61024, -- dalaran intellect
			42995, -- arcane intellect
			61316, -- dalaran brilliance
			43002, -- arcane brilliance
		},
		[2] = {
			30482, -- molten armor
			6117, -- mage armor
			168, -- frost armor
			7302, -- ice armor
		},
	},
	["PALADIN"] = {
		[1] = {
			21084, -- seal of righteousness
			20375, -- seal of command
			20164, -- seal of justice
			20165, -- seal of light
			20166, -- seal of wisdom
			53736, -- seal of corruption
			31801, -- seal of vengeance
		},
		[2] = {
			48932, -- blessing of might
		},
	},
	["PRIEST"] = {
		[1] = {
			588, -- inner fire
		},
		[2] = {
			48073, -- divine spirit
			48074, -- prayer of spirit
		},
		[3] = {
			48161, -- power word: fortitude
			48162, -- prayer of fortitude
		},
	},
	["ROGUE"] = {
		[1] = {
		},
	},
	["SHAMAN"] = {
		[1] = {
			52127, -- water shield
			324, -- lightning shield
			974, -- earth shield
		},
	},
	["WARLOCK"] = {
		[1] = {
			28176, -- fel armor
			706, -- demon armor
			687, -- demon skin
		},
	},
	["WARRIOR"] = {
		[1] = {
			47436, -- battle shout
			47440, -- commanding shout
		},
	},
}

local function OnEvent(self, event)
	if event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB" then
		for i = 1, #ReminderFrame.buffs[PCLASS][self.num] do
			local name = GetSpellInfo(ReminderFrame.buffs[PCLASS][self.num][i])
			local usable, nomana = IsUsableSpell(name)
			if usable or nomana then
				self.icon:SetTexture(select(3, GetSpellInfo(ReminderFrame.buffs[PCLASS][self.num][i])))
				break
			end
		end
		if event == "PLAYER_LOGIN" and not self.icon:GetTexture() then
			self:UnregisterAllEvents()
			self:RegisterEvent"LEARNED_SPELL_IN_TAB"
			self:Hide()
			return
		elseif event == "LEARNED_SPELL_IN_TAB" then
			if self.icon:GetTexture() then
				self:UnregisterAllEvents()
				self:RegisterEvent"UNIT_AURA"
				self:RegisterEvent"PLAYER_LOGIN"
				self:RegisterEvent"PLAYER_REGEN_ENABLED"
				self:RegisterEvent"PLAYER_REGEN_DISABLED"
				self:Show()
			else
				self:Hide()
				return
			end
		end
	end
	if not UnitAffectingCombat"player" and not UnitInVehicle"player" and not UnitIsDead"player" and not UnitIsGhost"player" then
		for i = 1, #ReminderFrame.buffs[PCLASS][self.num] do
			local name = GetSpellInfo(ReminderFrame.buffs[PCLASS][self.num][i])
			if name and UnitBuff("player", name) then
				self:Hide()
				return
			end
		end
		self:Show()
	else
		self:Hide()
	end
end

for i = 1, #ReminderFrame.buffs[PCLASS] do
	ReminderFrame.reminders[i] = CreateFrame("Frame", nil, ReminderFrame)
	ReminderFrame.reminders[i]:SetHeight(28)
	ReminderFrame.reminders[i]:SetWidth(28)
	ReminderFrame.reminders[i]:SetPoint("LEFT", ufPlayer, "RIGHT", 3, 0)
	ReminderFrame.reminders[i].icon = ReminderFrame.reminders[i]:CreateTexture(nil, "BACKGROUND")
	ReminderFrame.reminders[i].icon:SetTexCoord(.1, .9, .1, .9)
	ReminderFrame.reminders[i].icon:SetPoint("TOPLEFT", ReminderFrame.reminders[i], "TOPLEFT", 2, -2)
	ReminderFrame.reminders[i].icon:SetPoint("BOTTOMRIGHT", ReminderFrame.reminders[i], "BOTTOMRIGHT", -2, 2)
	ReminderFrame.reminders[i].icon.bd = CreateFrame("Frame", nil, ReminderFrame.reminders[i])
	ReminderFrame.reminders[i].icon.bd:SetPoint("TOPLEFT", -3, 3)
	ReminderFrame.reminders[i].icon.bd:SetPoint("BOTTOMRIGHT", 3, -3)
	ReminderFrame.reminders[i].icon.bd:SetFrameStrata"BACKGROUND"
	ReminderFrame.reminders[i].icon.bd:SetBackdrop(BACKDROP)
	ReminderFrame.reminders[i].icon.bd:SetBackdropColor(0, 0, 0, 1)
	ReminderFrame.reminders[i].icon.bd:SetBackdropBorderColor(0, 0, 0)
	ReminderFrame.reminders[i].num = i
	ReminderFrame.reminders[i]:Show()
	ReminderFrame.reminders[i]:RegisterEvent"UNIT_AURA"
	ReminderFrame.reminders[i]:RegisterEvent"PLAYER_LOGIN"
	ReminderFrame.reminders[i]:RegisterEvent"PLAYER_REGEN_ENABLED"
	ReminderFrame.reminders[i]:RegisterEvent"PLAYER_REGEN_DISABLED"
	ReminderFrame.reminders[i]:SetScript("OnEvent", OnEvent)
end