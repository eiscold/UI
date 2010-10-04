﻿UI_NAME = ...
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

function GetMyColor()
	--return .35, .55, .55
	return .35, .35, .35, 1
end

function GetMyTextColor()
	local r, g, b = GetMyColor()
	return string.format("|cff%2x%2x%2x", r * 255, g * 255, b * 255)
end

function dummy() end

function CreateBG(parent, abg, r, g, b, abd)
	local bg = parent:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(parent)
	bg:SetTexture(r or 0, g or 0, b or 0, abg or 1)
	local bd = CreateFrame("Frame", nil, parent)
	bd:SetPoint("TOPLEFT", -5, 5)
	bd:SetPoint("BOTTOMRIGHT", 5, -5)
	bd:SetFrameStrata"BACKGROUND"
	bd:SetBackdrop(BACKDROP)
	bd:SetBackdropColor(r or 0, g or 0, b or 0, a or 1)
	bd:SetBackdropBorderColor(r or 0, g or 0, b or 0, abd or 1)
	return bg, bd
end

function CreateFS(parent, size, justify, style)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont(FONT, size or FONT_SIZE, style or "OUTLINE")
    f:SetShadowColor(0, 0, 0, 0)
    if justify then
		f:SetJustifyH(justify)
	end
    return f
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
		r, g, b = unpack(classcolors[class or "WARRIOR"])
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

FACTION_STANDING_DECREASED = "|3-7(%s) -%d"
FACTION_STANDING_INCREASED = "|3-7(%s) +%d"