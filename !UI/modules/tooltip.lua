if not Load"tooltip" then
	return
end

PVP_ENABLED = ""

GameTooltip_SetDefaultAnchor = function(self, parent)
	self:SetOwner(parent, "ANCHOR_NONE")
	self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 282)
	self.default = 1
end

do
	local tooltips = {
		"GameTooltip",
		"ItemRefTooltip",
		"ShoppingTooltip1",
		"ShoppingTooltip2",
		"ShoppingTooltip3",
		"DropDownList1MenuBackdrop",
		"DropDownList2MenuBackdrop"
	}

	for i = 1, #tooltips do
		_G[tooltips[i]]:SetBackdrop(nil)
		local bg, bd = CreateBG(_G[tooltips[i]])
		bd:SetFrameStrata"TOOLTIP"
	end
end

function HealthBar_OnValueChanged(self)
	self:SetStatusBarColor(GetMyColor())
end

_G["GameTooltipStatusBar"]:SetHeight(3)
_G["GameTooltipStatusBar"]:ClearAllPoints()
_G["GameTooltipStatusBar"]:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMLEFT", 1, 1)
_G["GameTooltipStatusBar"]:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 1)

local classification = {
	worldboss = "",
	rareelite = "R+",
	elite = "+",
	rare = "R",
}

local function OnTooltipSetUnit(self)
	local lines = self:NumLines()
	local name, unit = self:GetUnit()
	if not unit then
		return
	end
	local race = UnitRace(unit) or ""
	local level = UnitLevel(unit) or ""
	local c = UnitClassification(unit)
	local crtype = UnitCreatureType(unit)
	if level and level == -1 then
		if c == "worldboss" then
			level = "|cffe61919"..BOSS.."|r"
		else
			level = "|cffe61919??|r"
		end
	end
	_G["GameTooltipTextLeft1"]:SetText(name)
	if UnitIsPlayer(unit) then
		local InGuild = GetGuildInfo(unit)
		if InGuild then
			_G["GameTooltipTextLeft2"]:SetFormattedText("%s", InGuild)
		end
		local n = InGuild and 3 or 2
		_G["GameTooltipTextLeft"..n]:SetFormattedText("%s %s", level, race)
	else
		for i = 2, lines do
			local line = _G["GameTooltipTextLeft"..i]
			local text = line:GetText() or ""
			if (level and text:find("^"..PLEVEL)) or (crtype and text:find("^"..crtype)) then
				line:SetFormattedText("%s%s %s", level, classification[c] or "", crtype or "")
				break
			end
		end
	end
	local tunit = unit.."target"
	if UnitExists(tunit) and unit ~= "player" then
		local r, g, b = GameTooltip_UnitColor(tunit)
		local text = ""
		if UnitName(tunit) == PNAME then
			text = "T: > "..string.upper(YOU).." <"
		else
			text = "T: "..UnitName(tunit)
		end
		self:AddLine(text, r, g, b)
	end
end
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

local frame = CreateFrame("Frame", "ItemRefTooltipIconFrame", _G["ItemRefTooltip"])
frame:SetPoint("TOPRIGHT", _G["ItemRefTooltip"], "TOPLEFT", -1, 0)
frame:SetHeight(32)
frame:SetWidth(32)

local tex = frame:CreateTexture("ItemRefTooltipIcon", "TOOLTIP")
tex:SetAllPoints(frame)

local border = frame:CreateTexture(nil, "OVERLAY")
border:SetTexture"Interface\\Buttons\\UI-Debuff-Overlays"
border:SetAllPoints(frame)
			
local AddItemIcon = function()
	local frame = _G["ItemRefTooltipIconFrame"]
	frame:Hide()
	local _, link = _G["ItemRefTooltip"]:GetItem()
	local icon = link and GetItemIcon(link)
	if not icon then
		return
	end
	_G["ItemRefTooltipIcon"]:SetTexture(icon)
	frame:Show()
end

hooksecurefunc("SetItemRef", AddItemIcon)