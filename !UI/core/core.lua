UI_NAME = ...
UI_VERSION = GetAddOnMetadata(UI_NAME, "Version")
UI_AUTHOR = GetAddOnMetadata(UI_NAME, "Author")

FONT_PATH = "Interface\\AddOns\\"..UI_NAME.."\\media\\fonts\\"
TEXTURE_PATH = "Interface\\AddOns\\"..UI_NAME.."\\media\\textures\\"

BACKDROP = {edgeFile = TEXTURE_PATH.."glowTex", edgeSize = 5}
TEXTURE = TEXTURE_PATH.."HalM.tga" --"Interface\\TargetingFrame\\UI-StatusBar"
FONT = FONT_PATH.."arialnarrow.ttf"
FONT_SIZE = 12

_, PCLASS = UnitClass"player"
PLEVEL = UnitLevel"player"
PNAME = UnitName"player"

classcolors = {
	["DEATHKNIGHT"] = {.77, .12, .23},
	["DRUID"] = {1, .49, .04},
	["HUNTER"] = {.67, .83, .45},
	["MAGE"] = {.41, .8, .94},
	["PALADIN"] = {.96, .55, .73},
	["PRIEST"] = {1, 1, 1},
	["ROGUE"] = {1, .96, .41},
	["SHAMAN"] = {.14, .35, 1},
	["WARLOCK"] = {.58, .51, .79},
	["WARRIOR"] = {.78, .61, .43},
}

powercolors = {
	["MANA"] = {.2, .4, 1},
	["RAGE"] = {.9, .1, .1},
	["FUEL"] = {0, .55, .5},
	["FOCUS"] = {.9, .9, .1},
	["ENERGY"] = {.9, .9, .1},
	["AMMOSLOT"] = {.8, .6, 0},
	["RUNIC_POWER"] = {.1, .9, .9},
	["POWER_TYPE_STEAM"] = {.55, .57, .61},
	["POWER_TYPE_PYRITE"] = {.6, .09, .17},
}

reactioncolors = {
	[1] = {1, .4, .2},
	[2] = {1, .4, .2},
	[3] = {1, .4, .2},
	[4] = {1, 1, .3},
	[5] = {.3, 1, .3},
	[6] = {.3, 1, .3},
	[7] = {.3, 1, .3},
	[8] = {.3, 1, .3},
}

factioninfo = {
	[1] = {{unpack(reactioncolors[1])}, FACTION_STANDING_LABEL1},
	[2] = {{unpack(reactioncolors[2])}, FACTION_STANDING_LABEL2},
	[3] = {{unpack(reactioncolors[3])}, FACTION_STANDING_LABEL3},
	[4] = {{unpack(reactioncolors[4])}, FACTION_STANDING_LABEL4},
	[5] = {{unpack(reactioncolors[5])}, FACTION_STANDING_LABEL5},
	[6] = {{unpack(reactioncolors[6])}, FACTION_STANDING_LABEL6},
	[7] = {{unpack(reactioncolors[7])}, FACTION_STANDING_LABEL7},
	[8] = {{unpack(reactioncolors[8])}, FACTION_STANDING_LABEL8},
}

FACTION_STANDING_DECREASED = "|3-7(%s) -%d"
FACTION_STANDING_INCREASED = "|3-7(%s) +%d"

function GetMyColor()
	--return .35, .55, .55
	return .5, .5, .5, 1
end

function GetMyTextColor()
	local r, g, b = GetMyColor()
	return string.format("|cff%2x%2x%2x", r * 255, g * 255, b * 255)
end

function GetMySpecialTextColor()
	local r, g, b = .3, .3, .9
	return string.format("|cff%2x%2x%2x", r * 255, g * 255, b * 255)
end

function GetMyPulseColor()
	return 1, 1, 1
end

function dummy() end

function CreateBD(parent, alpha, r, g, b)
	local bd = CreateFrame("Frame", nil, parent)
	bd:SetPoint("TOPLEFT", -5, 5)
	bd:SetPoint("BOTTOMRIGHT", 5, -5)
	bd:SetFrameStrata"BACKGROUND"
	bd:SetBackdrop(BACKDROP)
	bd:SetBackdropColor(r or 0, g or 0, b or 0, alpha or 1)
	bd:SetBackdropBorderColor(r or 0, g or 0, b or 0, alpha or 1)
	return bd
end

function CreateBG(parent, abg, abd, r, g, b)
	local bg = parent:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(parent)
	bg:SetTexture(r or 0, g or 0, b or 0, abg or 1)
	local bd = CreateFrame("Frame", nil, parent)
	bd:SetPoint("TOPLEFT", -5, 5)
	bd:SetPoint("BOTTOMRIGHT", 5, -5)
	bd:SetFrameStrata"BACKGROUND"
	bd:SetBackdrop(BACKDROP)
	bd:SetBackdropColor(r or 0, g or 0, b or 0, abd or 1)
	bd:SetBackdropBorderColor(r or 0, g or 0, b or 0, abd or 1)
	return bg, bd
end

function CreateFS(parent, size, justify, style)
    local font = parent:CreateFontString(nil, "OVERLAY")
    font:SetFont(FONT, size or FONT_SIZE, style or "OUTLINE")
    font:SetShadowColor(0, 0, 0, 0)
    if justify then
		font:SetJustifyH(justify)
	end
    return font
end

function CreatePulse(frame, low, high, speed, mult, alpha)
	frame.pulse = {}
	frame.pulse.speed = speed or .05
	frame.pulse.mult = mult or 1
	frame.pulse.oldalpha = frame:GetAlpha() or 1
	frame.pulse.alpha = alpha or 1
	frame.pulse.low = low or 0
	frame.pulse.high = high or 1
	frame.pulse.lastupdate = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.pulse.lastupdate = self.pulse.lastupdate + elapsed
		if self.pulse.lastupdate > self.pulse.speed then
			self.pulse.lastupdate = 0
			if self.pulse.low and self.pulse.low > self.pulse.alpha then
				self:SetAlpha(self.pulse.low)
			elseif self.pulse.high and self.pulse.high < self.pulse.alpha then
				self:SetAlpha(self.pulse.high)
			else
				self:SetAlpha(self.pulse.alpha)
			end
		end
		self.pulse.alpha = self.pulse.alpha - elapsed * self.pulse.mult
		if self.pulse.alpha < 0 and self.pulse.mult > 0 then
			self.pulse.mult = self.pulse.mult * -1
			self.pulse.alpha = 0
		elseif self.pulse.alpha > 1 and self.pulse.mult < 0 then
			self.pulse.mult = self.pulse.mult * -1
		end
	end)
end

function CreateButtonPulse(frame)
	frame.glow = CreateFrame("Frame", nil, frame)
	frame.glow:SetBackdrop(BACKDROP)
	frame.glow:SetPoint("TOPLEFT", frame, -5, 5)
	frame.glow:SetPoint("BOTTOMRIGHT", frame, 5, -5)
	frame.glow:SetBackdropBorderColor(GetMyPulseColor())
	frame.glow:SetAlpha(0)
	frame:SetNormalTexture""
	frame:SetHighlightTexture""
	frame:SetPushedTexture""
	frame:SetDisabledTexture""
	frame.bg, frame.bd = CreateBG(frame, 0, .3)
	frame.bg:SetTexture(1, 1, 1, .1)
	frame.bd:SetBackdropColor(1, 1, 1, 1)
	frame.bd:SetBackdropBorderColor(1, 1, 1, 1)
	frame:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, 1, 1)
		self:SetBackdropColor(1, 1, 1 ,.1)
		CreatePulse(self.glow)
	end)
 	frame:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
		self:SetBackdropColor(0, 0, 0, .25)
		self.glow:SetScript("OnUpdate", nil)
		self.glow:SetAlpha(0)
	end)
end

function DestroyPulse(frame)
	if frame.pulse then
		frame:SetScript("OnUpdate", nil)
		if frame.pulse.oldalpha then
			frame:SetAlpha(frame.pulse.oldalpha)
		end
		wipe(frame.pulse)
	end
end

function GetShortValue(val)
	if val > 999999 then
		return format("%.2fm", val * .000001)
	elseif val > 9999 then
		return format("%.1fk", val * .001) 
	else
		return val
	end
end

function GameTooltip_UnitColor(unit)
	local r, g, b = 1, 1, 1
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		r, g, b = unpack(classcolors[class or PCLASS])
	elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or UnitIsDead(unit) then
		r, g, b = .6, .6, .6
	else
		r, g, b = unpack(reactioncolors[UnitReaction("player", unit) or 5])
	end
	return r, g, b
end

function IsInArena()
	local inInstance, instanceType = IsInInstance()
	if inInstance and instanceType == "arena" then
		return true
	else
		return false
	end
end

function StringHash(text)
	local counter = 1
	local len = string.len(text)
	for i = 1, len, 3 do 
		counter = math.fmod(counter * 8161, 4294967279) +
  			(string.byte(text, i) * 16776193) +
  			((string.byte(text, i + 1) or (len - i + 256)) * 8372226) +
  			((string.byte(text, i + 2) or (len - i + 256)) * 3932164)
	end
	return math.fmod(counter, 4294967291)
end

function argprint(...)
	for i = 1, select("#", ...) do
		print(tostring(select(i, ...)))
	end
end

function tprint(t)
	for k, _ in pairs(t) do
		print(k)
	end
end