if not Load"unitframes" then
	return
end

local fontsize = 12
local hr, hg, hb, ha = GetMyColor()
local pr, pg, pb, pa = hr * 1.5, hg * 1.5, hb * 1.5, ha

local function ColorAggro(self, event, unit)
	if not unit then
		return
	end
	local s = UnitThreatSituation(self.unit)
	if s and s > 0 then
		local r, g, b = .8, 0, 0
		if s == 1 then
			r, g, b = .5, .5, 0
		elseif s == 2 then
			r, g, b = 0.5, 0, 0
		end
		self.bd:SetBackdropBorderColor(r, g, b)
	else
		self.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

function getNameTT(name)
	if name == PNAME then
		return "|cffe61919> "..string.upper(YOU).." <|r"
	else
		return name
	end
end

local function menu(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)
	if unit == "party" or unit == "partypet" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local function updateName(self, event, unit)
	if self.unit ~= unit then
		return
	end
	if unit then
		self.Name:SetText(UnitName(unit))
	end
end

local function updateAuraTrackerTime(self, elapsed)
	if self.active then
		self.bd:Show()
		self:Show()
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, 0, 0)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture""
			self.text:SetText""
		else
			self.text:SetFormattedText("%.1f", self.timeleft)
		end
	else
		self.bd:Hide()
		if self.text == "" then
			self:Hide()
		end
	end
end

function extendUnitFrame(self)
	self.bg:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, -8)
	self.bd:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
	self.bd:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -13)
end

function shrinkUnitFrame(self)
	self.bg:SetPoint("TOPLEFT", self, "TOPLEFT")
	self.bg:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	self.bd:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
	self.bd:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
end

_G["BuffFrame"]:Hide()
_G["BuffFrame"]:UnregisterAllEvents()
_G["BuffFrame"]:SetScript("OnUpdate", nil)
for i = 1, 2 do
    _G["TempEnchant"..i.."Icon"]:Hide()
    _G["TempEnchant"..i.."Count"]:Hide()
    _G["TempEnchant"..i.."Border"]:Hide()
    _G["TempEnchant"..i.."Duration"]:ClearAllPoints()
	_G["TempEnchant"..i.."Duration"]:SetFont(FONT, 9, "OUTLINE")
	_G["TempEnchant"..i.."Duration"]:SetShadowColor(0, 0, 0, 0)
	_G["TempEnchant"..i]:SetAllPoints(_G["TempEnchant"..i.."Duration"])
end

local height, width = 0, 0
local function SharedUnitFramesFunc(self, unit)
	self.menu = menu

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
    
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")
	
	self.bg, self.bd = CreateBG(self)
	self.bg:SetTexture(0, 0, 0, .5)

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetHeight(18)
	self.Health:SetStatusBarTexture(TEXTURE)
	self.Health:SetParent(self)
	self.Health:SetPoint"TOP"
	self.Health:SetPoint"LEFT"
	self.Health:SetPoint"RIGHT"

	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(TEXTURE)
	self.Health.bg:SetVertexColor(0, 0, 0, .2)
	
	self.Health.value = CreateFS(self.Health, fontsize)
	self.Health.value:SetPoint("RIGHT", self, "TOPRIGHT", 0, 1)
	self.Health.curvalue = CreateFS(self.Health, fontsize, "LEFT")
	self.Health.curvalue:SetPoint("LEFT", self, "TOPLEFT", 0, 1)

	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetHeight(3)
	self.Power:SetStatusBarTexture(TEXTURE)
	if not CFG.PowerColored then
		self.Power:SetStatusBarColor(pr, pg, pb, pa)
	end
	self.Power:SetParent(self)
	self.Power:SetPoint"BOTTOMLEFT"
	self.Power:SetPoint"BOTTOMRIGHT"

	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(TEXTURE)
	self.Power.bg:SetVertexColor(0, 0, 0, .2)

	self.Power.value = CreateFS(self.Power, fontsize, "LEFT")
	self.Power.value:SetPoint("RIGHT", self.Health.value, "BOTTOMRIGHT", 0, -5)

	self.Name = CreateFS(self.Health, fontsize)
	self.Name:SetPoint("LEFT", self, "TOPLEFT", 0, 1)
	self:RegisterEvent("UNIT_NAME", updateName)
	tinsert(self.__elements, updateName)

	if unit == "player" then
		width, height = 229, 16

		self.Health:SetHeight(12)
		self.Health.frequentUpdates = true
		self.Health.value:Hide()

		self.Power:SetHeight(3)
		self.Power.frequentUpdates = true
		self.Power.value:SetPoint("RIGHT", self, "TOPRIGHT", 0, 1)
		self.Power.value:SetJustifyH"RIGHT"

		self.Name:Hide()

		self.Buffs = CreateFrame("Frame", "ufPlayerBuffFrame", UIParent)
		self.Buffs:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -50)
		self.Buffs["growth-y"] = "DOWN"
		self.Buffs["growth-x"] = "LEFT"
		self.Buffs:SetHeight(500)
		self.Buffs:SetWidth(336)

		self.Debuffs = CreateFrame("Frame", "ufPlayerDebuffFrame", self)
		self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 1, (PCLASS == "DEATHKNIGHT" or PCLASS == "DRUID" or PCLASS == "ROGUE" or PCLASS == "SHAMAN") and -10 or -2)
		self.Debuffs["growth-x"] = "LEFT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs.num = 16
		self.Debuffs:SetHeight(60)
		self.Debuffs:SetWidth(220)

		if PCLASS == "DEATHKNIGHT" then
			self.Runes = CreateFrame("Frame", nil, self)
			self.Runes:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
			self.Runes:SetHeight(7)
			self.Runes:SetWidth(width)
			self.Runes.anchor = "TOPLEFT"
			self.Runes.growth = "RIGHT"
			self.Runes.height = 7
			self.Runes.width = width / 6 - 0.85
			self.Runes.spacing = 1
			for i = 1, 6 do
				self.Runes[i] = CreateFrame("StatusBar", self:GetName().."Runes"..i, self.Runes)
				self.Runes[i]:SetStatusBarTexture(TEXTURE)
				self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "BORDER")
				self.Runes[i].bg:SetAllPoints(self.Runes[i])
				self.Runes[i].bg:SetTexture(TEXTURE)
				self.Runes[i].bg.multiplier = .2
			end
		end

		if PCLASS == "DRUID" then
			self.DruidMana = CreateFrame("StatusBar", nil, self)
			self.DruidMana:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
			self.DruidMana:SetStatusBarTexture(TEXTURE)
			self.DruidMana:SetStatusBarColor(45/255, 113/255, 191/255)
			self.DruidMana:SetHeight(7)
			self.DruidMana:SetWidth(width)
			self.DruidMana.bg = self.DruidMana:CreateTexture(nil, "BORDER")
			self.DruidMana.bg:SetAllPoints(self.DruidMana)
			self.DruidMana.bg:SetTexture(TEXTURE)
			self.DruidMana.bg:SetVertexColor(0, 0, 0, 0.2)
			self.DruidMana.text = CreateFS(self.DruidMana, fontsize, "CENTER")
			self.DruidMana.text:SetPoint("RIGHT", self.Power.value, "LEFT", -1, 0)
		end
		
		--[[
		if PCLASS == "HUNTER" then
			--cata focus
		end
		]]

		--[[
		if PCLASS == "PALADIN" then
			self.HolyPower = CreateFrame("Frame", nil, self)
			self.HolyPower:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
			self.HolyPower:SetHeight(7)
			self.HolyPower:SetWidth(width)
			self.HolyPower.anchor = "TOPLEFT"
			self.HolyPower.growth = "RIGHT"
			for i = 1, 3 do
				self.HolyPower[i] = CreateFrame("StatusBar", nil, self.HolyPower)
				self.HolyPower[i]:SetStatusBarTexture(TEXTURE)
				self.HolyPower[i]:SetHeight(7)
				self.HolyPower[i]:SetWidth(width / 3 - 0.85)
				self.HolyPower[i]:SetStatusBarColor(1, .95, .33)
				if i == 1 then
					self.HolyPower[i]:SetPoint("TOPLEFT", self.HolyPower, "TOPLEFT")
				else
					self.HolyPower[i]:SetPoint("TOPLEFT", self.HolyPower[i - 1], "TOPRIGHT", 1, 0)
				end
				self.HolyPower[i].bg = self.HolyPower[i]:CreateTexture(nil, "BACKGROUND")
				self.HolyPower[i].bg:SetAllPoints(self.HolyPower[i])
				self.HolyPower[i].bg:SetTexture(TEXTURE)
				self.HolyPower[i].bg.multiplier = .2
			end
		end
		]]

		if PCLASS == "DRUID" or PCLASS == "ROGUE" then
			self.CPoints = CreateFrame("Frame", nil, self)
			self.CPoints:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
			self.CPoints:SetHeight(7)
			self.CPoints:SetWidth(width)
			for i = 1, 5 do
				self.CPoints[i] = CreateFrame("StatusBar", nil, self.CPoints)
				self.CPoints[i]:SetStatusBarTexture(TEXTURE)
				self.CPoints[i]:SetHeight(7)
				self.CPoints[i]:SetWidth(width / 5 - .85)
				self.CPoints[i]:SetStatusBarColor(.9, .1, .1)
				if i == 1 then
					self.CPoints[i]:SetPoint("TOPLEFT", self.CPoints, "TOPLEFT")
				else
					self.CPoints[i]:SetPoint("TOPLEFT", self.CPoints[i - 1], "TOPRIGHT", 1, 0)
				end
				self.CPoints[i].bg = self.CPoints[i]:CreateTexture(nil, "BACKGROUND")
				self.CPoints[i].bg:SetAllPoints(self.CPoints[i])
				self.CPoints[i].bg:SetTexture(TEXTURE)
				self.CPoints[i].bg.multiplier = .2
			end
		end

		if PCLASS == "SHAMAN" then
			self.TotemBar = {}
			self.TotemBar.Destroy = true
			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."TotemBar"..i, self)
				self.TotemBar[i]:SetHeight(7)
				self.TotemBar[i]:SetWidth(width / 4 - 0.85)
				if i == 1 then
					self.TotemBar[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
				else
					self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 1, 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(TEXTURE)
				self.TotemBar[i]:SetBackdrop{}
				self.TotemBar[i]:SetBackdropColor(0, 0, 0)
				self.TotemBar[i]:SetMinMaxValues(0, 1)
				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
				self.TotemBar[i].bg:SetTexture(TEXTURE)
				self.TotemBar[i].bg.multiplier = .2
			end
		end

		--[[
		if PCLASS == "WARLOCK" then
			self.SoulShards = CreateFrame("Frame", nil, self)
			self.SoulShards:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
			self.SoulShards:SetHeight(7)
			self.SoulShards:SetWidth(width)
			self.SoulShards.anchor = "TOPLEFT"
			self.SoulShards.growth = "RIGHT"
			for i = 1, 3 do
				self.SoulShards[i] = CreateFrame("StatusBar", nil, self.SoulShards)
				self.SoulShards[i]:SetStatusBarTexture(TEXTURE)
				self.SoulShards[i]:SetHeight(7)
				self.SoulShards[i]:SetWidth(width / 3 - 0.85)
				self.SoulShards[i]:SetStatusBarColor(.86, .44, 1)
				if i == 1 then
					self.SoulShards[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
				else
					self.SoulShards[i]:SetPoint("TOPLEFT", self.SoulShards[i - 1], "TOPRIGHT", 1, 0)
				end
				self.SoulShards[i].bg = self.SoulShards[i]:CreateTexture(nil, "BACKGROUND")
				self.SoulShards[i].bg:SetAllPoints(self.SoulShards[i])
				self.SoulShards[i].bg:SetTexture(TEXTURE)
				self.SoulShards[i].bg.multiplier = .2
			end
		end
		]]

		local dur1 = _G["TempEnchant1Duration"]
    		local dur2 = _G["TempEnchant2Duration"]
    		dur1:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 3)
    		dur2:SetPoint("TOP", dur1, "BOTTOM")
    		hooksecurefunc("TempEnchantButton_OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetInventoryItem("player", self:GetID())
		end)
		hooksecurefunc("TempEnchantButton_OnUpdate", function(self)
			local text = _G[self:GetName().."Duration"]:GetText()
			--text = text:gsub("%s+%w+%p+", "m")
			--text = text:gsub("%s+%w", "s")
			_G[self:GetName().."Duration"]:SetText(text)
		end)
		dur1:SetVertexColor(1, 1, 1)
 		dur2:SetVertexColor(1, 1, 1)
 		dur1.SetVertexColor = dummy
		dur2.SetVertexColor = dummy

		self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(18)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -5, 2)
	end

	if unit == "pet" then
		width, height = 113, 10

		self.Health:SetHeight(6)
		self.Health.value:Hide()

		self.Power:SetHeight(3)
		self.Power.value:Hide()

		self.Name:SetPoint("BOTTOM", self, "TOP", 0, 2)
		self.Name:SetPoint"RIGHT"
		self.Name:SetPoint"LEFT"
		
		--[[
		if PCLASS == "HUNTER" then
			self.Health.colorHappiness = true  
		end
		]]
	end
	
    if unit == "target" then
		width, height = 229, 18

		self.Health:SetHeight(14)
		self.Health.frequentUpdates = true
		self.Health.value = CreateFS(self.Health, 12, "LEFT")
		self.Health.value:SetPoint("LEFT", self, "TOPLEFT", 0, 1)

		self.Power:SetHeight(3)
		self.Power.frequentUpdates = true
		self.Power.value:SetPoint("BOTTOMLEFT", self.Health.value, "BOTTOMRIGHT")
		
		self.Name:SetPoint("BOTTOMLEFT", self.Power.value, "BOTTOMRIGHT")
		self.Name:SetPoint("RIGHT", self)
		self.Name:SetJustifyH"RIGHT"
		
		--[[
		if PCLASS == "ROGUE" or PCLASS == "DRUID" then
			self.CPoints = CreateFS(self, 14, "RIGHT")
			self.CPoints:SetPoint("LEFT", self, "RIGHT", 3, 2)
		end
		]]
		
		self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(18)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -5, 2)
		
		self.Auras = CreateFrame("Frame", "ufTargetAuraFrame", self)
		self.Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -1, -2)
		self.Auras.initialAnchor = "TOPLEFT"
		self.Auras["growth-x"] = "RIGHT"
		self.Auras["growth-y"] = "DOWN"
		self.Auras.numDebuffs = 16
		self.Auras.numBuffs = 24
		self.Auras:SetHeight(500)
		self.Auras:SetWidth(229 + 15)
		self.Auras.gap = true
	end
	
	if unit == "focus" then
		width, height = 113, 10

		self.Health:SetHeight(6)
		self.Health.value:Hide()

		self.Power:SetHeight(3)
		self.Power.value:Hide()

		self.Name:SetPoint("BOTTOM", self, "TOP", 0, 2)
		self.Name:SetPoint"RIGHT"
		self.Name:SetPoint"LEFT"

		self.Debuffs = CreateFrame("Frame", "ufFocusAuraFrame", self)
		self.Debuffs:SetPoint("RIGHT", self, "LEFT", 1, 0)
		self.Debuffs.initialAnchor = "BOTTOMRIGHT"
		self.Debuffs["growth-x"] = "LEFT"
		self.Debuffs["growth-y"] = "DOWN"
		self.Debuffs:SetHeight(22)
		self.Debuffs:SetWidth(115)
		self.Debuffs.size = 22
		self.Debuffs.num = 5
	end

	if unit and unit:find"arena%d" and not unit:find"arena%dtarget" then
		width, height = 229, 18

		self.Health:SetHeight(14)
		self.Health.frequentUpdates = true
		self.Health.value = CreateFS(self.Health, fontsize, "LEFT")
		self.Health.value:SetPoint("LEFT", self, "TOPLEFT", 0, 1)

		self.Power:SetHeight(3)
		self.Power.frequentUpdates = true
		self.Power.value:SetPoint("BOTTOMLEFT", self.Health.value, "BOTTOMRIGHT")

		self.Name:SetPoint("BOTTOMLEFT", self.Power.value, "BOTTOMRIGHT")
		self.Name:SetPoint("RIGHT", self)
		self.Name:SetJustifyH"RIGHT"

		self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(18)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -5, 2)
	end

	if self:GetParent():GetName():match"ufParty" then
		width, height = 229, 18

		self.Health:SetHeight(14)
		self.Health.value = CreateFS(self.Health, fontsize, "LEFT")
		self.Health.value:SetPoint("LEFT", self, "TOPLEFT", 0, 1)

		self.Power:SetHeight(3)
		self.Power.value:SetPoint("BOTTOMLEFT", self.Health.value, "BOTTOMRIGHT")

		self.Name:SetPoint("BOTTOMLEFT", self.Power.value, "BOTTOMRIGHT")
		self.Name:SetPoint("RIGHT", self)
		self.Name:SetJustifyH"RIGHT"

		self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(18)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -5, 2)

		self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
		self.ReadyCheck:SetPoint"TOPLEFT"
		self.ReadyCheck:SetHeight(12)
		self.ReadyCheck:SetWidth(12)

		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", ColorAggro)
		self:RegisterEvent("UNIT_TARGET", ColorAggro)
	end

    if self:GetParent():GetName():match"ufRaid" then
		if CFG.RaidFrameStyle == "normal" then
			width, height = 70, 12
		elseif CFG.RaidFrameStyle == "grid" then
			width, height = 40, 40
		end

		self.Health:SetHeight(height)

		self.Health.value = CreateFS(self.Health, fontsize, "LEFT")
		if CFG.RaidFrameStyle == "normal" then
			self.Health.value:SetPoint("LEFT", self, "RIGHT", 2, 0)
		elseif CFG.RaidFrameStyle == "grid" then
			self.Health.value:SetPoint("CENTER", self, "CENTER", 0, 0)
		end

		self.Power:Hide()
		self.Power.value:Hide()

		self.Name:Hide()

		self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
		self.ReadyCheck:SetPoint"TOPLEFT"
		self.ReadyCheck:SetHeight(12)
		self.ReadyCheck:SetWidth(12)

		self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetHeight(12)
		self.RaidIcon:SetWidth(12)
		self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -5, 0)

		if CFG.RaidFrameStyle == "normal" then
			self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
			self.RaidIcon:SetHeight(12)
			self.RaidIcon:SetWidth(12)
			self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -5, 0)
		elseif CFG.RaidFrameStyle == "grid" then
			self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
			self.RaidIcon:SetHeight(12)
			self.RaidIcon:SetWidth(12)
			self.RaidIcon:SetPoint("TOP", self, "TOP", 0, -2)
		end

		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", ColorAggro)
		self:RegisterEvent("UNIT_TARGET", ColorAggro)
	end

	if unit and unit:find"boss" then
		width, height = 126, 12

		self.Health:SetHeight(height)

		self.Health.value = CreateFS(self.Health, 12, "LEFT")
		self.Health.value:SetPoint("RIGHT", self, "TOPRIGHT", 0, 1)
		self.Health.value:SetPoint("LEFT", self, "TOPLEFT", 0, 1)

		self.Power:Hide()
		self.Power.value:Hide()

		self.Name:Hide()
	end

	local MT = self:GetParent():GetName() == "ufMainTank"
	local MTT = self:GetParent():GetName() == "ufMainTankTarget"
	local MTTT = self:GetParent():GetName() == "ufMainTankTargetTarget"
	if MT or MTT or MTTT then
		width, height = 229 / 3, 25

		self.Health:SetHeight(height - 1)
		self.Health.value = CreateFS(self.Health, 12, "CENTER")
		self.Health.value:SetPoint("RIGHT", self, "RIGHT", 2, 0)
		self.Health.value:SetPoint("LEFT", self, "LEFT", -2, 0)

		self.Power:Hide()

		self.Name:Hide()
	end

	if CFG.UnitFrameStyle == "heal" then
		self.Health:SetHeight(self.Health:GetHeight() + 1)
		self.Health:SetStatusBarColor(0, 0, 0, 0)
		self.Health.Deficit = self.Health:CreateTexture(nil, "BACKGROUND")
		self.Health.Deficit:SetHeight(self.Health:GetHeight())
		self.Health.Deficit:SetWidth(0)
		self.Health.Deficit:SetPoint("TOPRIGHT", self, "TOPRIGHT")
		self.Health.Deficit:Hide()
		self.Power:SetHeight(self.Power:GetHeight() - 1)
		if unit ~= "player" then
			self.Power.value:Hide()
		end
	end

	if unit == "player" or unit == "target" or unit == "focus" or unit == "pet" or (unit and unit:find"arena%d" and not unit:find"arena%dtarget") or self:GetParent():GetName():match"ufParty" then
	    self.Castbar = CreateFrame("Frame", nil, self)
		self.Castbar:SetAllPoints(self.Health)
		self.Castbar:SetFrameStrata"HIGH"
		self.Castbar.Width = width
		self.Castbar.Spark = self.Castbar:CreateTexture(nil, "OVERLAY")
		self.Castbar.Spark:SetTexture"Interface\\CastingBar\\UI-CastingBar-Spark"
		self.Castbar.Spark:SetBlendMode"ADD"
		self.Castbar.Spark:SetHeight(self.Health:GetHeight() * 2.5)
		self.Castbar.Spark:SetWidth(16)
		if unit == "player" or unit == "target" or (unit and unit:find"arena%d" and not unit:find"arena%dtarget") or self:GetParent():GetName():match"ufParty" then
			self.Castbar.iconFrame = CreateFrame("Frame", nil, self.Castbar)
			self.Castbar.iconFrame:SetPoint("LEFT", self, "RIGHT", 3, 0)
			self.Castbar.iconFrame:SetHeight(28)
			self.Castbar.iconFrame:SetWidth(28)
			self.Castbar.icon = self.Castbar.iconFrame:CreateTexture(nil, "BACKGROUND")
			self.Castbar.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			self.Castbar.icon:SetPoint("TOPLEFT", self.Castbar.iconFrame, "TOPLEFT", 2, -2)
			self.Castbar.icon:SetPoint("BOTTOMRIGHT", self.Castbar.iconFrame, "BOTTOMRIGHT", -2, 2)
			self.Castbar.icon.bd = CreateFrame("Frame", nil, self.Castbar.iconFrame)
			self.Castbar.icon.bd:SetPoint("TOPLEFT", -3, 3)
			self.Castbar.icon.bd:SetPoint("BOTTOMRIGHT", 3, -3)
			self.Castbar.icon.bd:SetFrameStrata"BACKGROUND"
			self.Castbar.icon.bd:SetBackdrop(BACKDROP)
			self.Castbar.icon.bd:SetBackdropColor(0, 0, 0, 1)
			self.Castbar.icon.bd:SetBackdropBorderColor(0, 0, 0)
			self.Castbar.Time = CreateFS(self.Castbar.iconFrame, 11)
			self.Castbar.Time:SetPoint("BOTTOM", self.Castbar.iconFrame, "BOTTOM", 0, -2)
		end
		if unit == "player" then
			self.Castbar.Latency = self.Castbar:CreateTexture(nil, "BACKGROUND")
			self.Castbar.Latency:SetTexture(0.9, 0.1, 0.1, 0.5)
			self.Castbar.Latency:SetHeight(self.Health:GetHeight())
			self.Castbar.Latency:SetWidth(0)
			self.Castbar.Latency:SetPoint("RIGHT", self, "RIGHT")
			self.Castbar.Latency:Hide()
		end
	end

	if unit == "player" or unit == "target" or (unit and unit:find"arena%d" and not unit:find"arena%dtarget") or self:GetParent():GetName():match"ufParty" then
		self.AuraTracker = CreateFrame("Frame", nil, self)
		self.AuraTracker:SetWidth(28)
		self.AuraTracker:SetHeight(28)
		self.AuraTracker:SetPoint("RIGHT", self, "LEFT", -3, 0)
		self.AuraTracker:SetFrameStrata"HIGH"
		self.AuraTracker.icon = self.AuraTracker:CreateTexture(nil, "ARTWORK")
		self.AuraTracker.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		self.AuraTracker.icon:SetPoint("TOPLEFT", self.AuraTracker, "TOPLEFT", 2, -2)
		self.AuraTracker.icon:SetPoint("BOTTOMRIGHT", self.AuraTracker, "BOTTOMRIGHT", -2, 2)
		self.AuraTracker.text = CreateFS(self.AuraTracker, 11)
		self.AuraTracker.text:SetPoint("BOTTOM", self.AuraTracker, 0, -2)
		self.AuraTracker.bd = CreateFrame("Frame", nil, self.AuraTracker)
		self.AuraTracker.bd:SetPoint("TOPLEFT", -3, 3)
		self.AuraTracker.bd:SetPoint("BOTTOMRIGHT", 3, -3)
		self.AuraTracker.bd:SetFrameStrata"BACKGROUND"
		self.AuraTracker.bd:SetBackdrop(BACKDROP)
		self.AuraTracker.bd:SetBackdropColor(0, 0, 0, 1)
		self.AuraTracker.bd:SetBackdropBorderColor(0, 0, 0)
		self.AuraTracker:SetScript("OnUpdate", updateAuraTrackerTime)
	end
		
	self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.DebuffHighlight:SetAllPoints(self.Health)
	self.DebuffHighlight:SetTexture(TEXTURE)
	self.DebuffHighlight:SetBlendMode"ADD"
	self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightFilter = true
    
	if not unit then
		self.Range = true
		self.inRangeAlpha = 1.0
		self.outsideRangeAlpha = 0.5
    end
	
	self:SetWidth(width)
	self:SetHeight(height)
	self:SetAttribute("initial-height", height) 
	self:SetAttribute("initial-width", width) 
	
	return self   
end

uf:RegisterCurrentStyle(SharedUnitFramesFunc)

--[[
local player = uf:Spawn("player", "ufPlayer")
player:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 450, 420)
]]

local target = uf:Spawn("target", "ufTarget")
target:SetPoint("TOP", UIParent, "BOTTOM", 0, 300)

local player = uf:Spawn("player", "ufPlayer")
player:SetPoint("BOTTOMRIGHT", ufTarget, "BOTTOMLEFT", -200, 140)

local focus = uf:Spawn("focus", "ufFocus")
focus:SetPoint("BOTTOMLEFT", ufPlayer, "TOPLEFT", 0, 14)

local pet = uf:Spawn("pet", "ufPet")
pet:SetPoint("BOTTOMRIGHT", ufPlayer, "TOPRIGHT", 0, 14)

local tt = CreateFrame("Frame", "ufTargetTarget", UIParent)
tt:SetPoint("BOTTOMLEFT", ufTarget, "TOP", 4, 14)
tt:SetWidth(110)
tt:SetHeight(12)
local ttt = CreateFS(tt, 12, "RIGHT")
ttt:SetAllPoints(tt)
tt:SetScript("OnUpdate", function()
	ttt:SetText(getNameTT(UnitName"targettarget"))
end)

local party = uf:Spawn("header", "ufParty")
party:SetPoint("BOTTOM", ufPlayer, "TOP", 0, 45)
party:SetAttribute("showParty", true)
party:SetAttribute("yOffset", -45)
party:Show()
party:SetAttribute("showRaid", false)

local partytarget = {}
for i = 1, 5 do
	partytarget[i] = CreateFrame("Frame", "ufPartyTarget"..i, _G["ufPartyUnitButton"..i])
	partytarget[i]:SetPoint("BOTTOMLEFT", _G["ufPartyUnitButton"..i], "TOP", 4, 14)
	partytarget[i]:SetWidth(110)
	partytarget[i]:SetHeight(12)
	partytarget[i].text = CreateFS(partytarget[i], 12, "RIGHT")
	partytarget[i].text:SetAllPoints(partytarget[i])
	partytarget[i]:SetScript("OnUpdate", function()
		partytarget[i].text:SetText(getNameTT(UnitName("party"..i.."target")))
	end)
end

local arena = {}
local arenatarget = {}
for i = 1, 5 do
	arena[i] = uf:Spawn("arena"..i, "ufArena"..i)
	if i == 1 then
		--arena[i]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -450, 420)
		arena[i]:SetPoint("BOTTOMLEFT", ufTarget, "BOTTOMRIGHT", 200, 140)
	else 
		arena[i]:SetPoint("BOTTOM", _G["ufArena"..i - 1], "TOP", 0, 45)
	end
	arenatarget[i] = CreateFrame("Frame", "ufArenaTarget"..i, _G["ufArena"..i])
	arenatarget[i]:SetPoint("BOTTOMLEFT", _G["ufArena"..i], "TOP", 4, 14)
	arenatarget[i]:SetWidth(110)
	arenatarget[i]:SetHeight(12)
	arenatarget[i].text = CreateFS(arenatarget[i], 12, "RIGHT")
	arenatarget[i].text:SetAllPoints(arenatarget[i])
	arenatarget[i]:SetScript("OnUpdate", function()
		arenatarget[i].text:SetText(getNameTT(UnitName("arena"..i.."target")))
	end)
end

local raid = {}
for i = 1, NUM_RAID_GROUPS do
	local RaidGroup = uf:Spawn("header", "ufRaid" .. i)
	RaidGroup:SetAttribute("groupFilter", tostring(i))
	RaidGroup:SetAttribute("showRaid", true)
	RaidGroup:SetAttribute("yOffset", -5)
	RaidGroup:SetAttribute("point", "TOP")
	RaidGroup:SetAttribute("showRaid", true)
	table.insert(raid, RaidGroup)
	if CFG.RaidFrameStyle == "normal" then
		if i == 1 then
			RaidGroup:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
		else
			RaidGroup:SetPoint("TOP", raid[i-1], "BOTTOM", 0, -5)
		end
	elseif CFG.RaidFrameStyle == "grid" then
		local a = "BOTTOMLEFT"
		if i == 1 then
			--RaidGroup:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", -690, 420)
			RaidGroup:SetPoint("BOTTOMLEFT", ufTarget, "BOTTOMRIGHT", 200, 140)
		else
			if a == "BOTTOMRIGHT" then
				RaidGroup:SetPoint("BOTTOMRIGHT", raid[i - 1], "BOTTOMLEFT", -5, 0)
			elseif a == "BOTTOM" then
				RaidGroup:SetPoint("BOTTOM", raid[i - 1], "TOP", 0, 5)
			elseif a == "BOTTOMLEFT" then
				RaidGroup:SetPoint("BOTTOMLEFT", raid[i - 1], "BOTTOMRIGHT", 5, 0)
			elseif a == "LEFT" then
				RaidGroup:SetPoint("LEFT", raid[i - 1], "RIGHT", 5, 0)
			elseif a == "TOPLEFT" then
				RaidGroup:SetPoint("TOPLEFT", raid[i - 1], "TOPRIGHT", 5, 0)
			elseif a == "TOP" then
				RaidGroup:SetPoint("TOP", raid[i - 1], "BOTTOM", 0, -5)
			elseif a == "TOPRIGHT" then
				RaidGroup:SetPoint("TOPRIGHT", raid[i - 1], "TOPLEFT", -5, 0)
			elseif a == "RIGHT" then
				RaidGroup:SetPoint("RIGHT", raid[i - 1], "LEFT", -5, 0)
			end
		end
	end
	RaidGroup:Show()
end

if CFG.UnitFrameStyle == "heal" then
	local maintank = uf:Spawn("header", "ufMainTank")
	maintank:SetPoint("TOPLEFT", ufPlayer, "BOTTOMLEFT", 0, 220)
	maintank:SetAttribute("showRaid", true)
	maintank:SetAttribute("groupFilter", "MAINTANK")
	maintank:SetAttribute("yOffSet", -5)
	maintank:SetAttribute("template", "ufMainTankTarget")
	maintank:SetAttribute("template", "ufMainTankTargetTarget")
	maintank:Show()
end

local boss = {}
for i = 1, MAX_BOSS_FRAMES do
	boss[i] = uf:Spawn("boss"..i, "ufBoss"..i)
	boss[i]:SetPoint("BOTTOM", i == 1 and Minimap or _G["ufBoss"..i-1], "TOP", 0, 10)
	boss[i]:Show()
 end

local partyToggle = CreateFrame"Frame"
partyToggle:RegisterEvent"PLAYER_LOGIN"
partyToggle:RegisterEvent"RAID_ROSTER_UPDATE"
partyToggle:RegisterEvent"PARTY_LEADER_CHANGED"
partyToggle:RegisterEvent"PARTY_MEMBER_CHANGED"
partyToggle:SetScript("OnEvent", function(self)
	if InCombatLockdown() then
		self:RegisterEvent"PLAYER_REGEN_ENABLED"
	else
		self:UnregisterEvent"PLAYER_REGEN_DISABLED"
		if GetNumRaidMembers() > 0 and not IsInArena() then
			party:Hide()
		else
			party:Show()
		end
	end
end)

local raidToggle = CreateFrame"Frame"
raidToggle:RegisterEvent"PLAYER_LOGIN"
raidToggle:RegisterEvent"RAID_ROSTER_UPDATE"
raidToggle:RegisterEvent"PARTY_LEADER_CHANGED"
raidToggle:RegisterEvent"PARTY_MEMBERS_CHANGED"
raidToggle:SetScript("OnEvent", function(self)
	if GetNumRaidMembers() > 0 and not IsInArena() then
		for i = 1, 8 do
			raid[i]:Show()
		end
	else
		for i = 1, 8 do
			raid[i]:Hide()
		end	
	end
end)