if not Load"nameplates" then
	return
end

local NamePlatesFrames = CreateFrame"Frame"
NamePlatesFrames:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

local function IsValidFrame(frame)
	if frame:GetName() then
		return
	end
	overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
end

local function ThreatUpdate(self, elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed >= .2 then
		if self.oldglow:IsShown() then
			local _, green = self.oldglow:GetVertexColor()
			if green > .7 then
				self.healthBar:SetStatusBarColor(unpack(reactioncolors[4])) -- medium threat
			elseif green > .1 then
				self.healthBar:SetStatusBarColor(1, .5, 0) -- losing aggro
			else
				self.healthBar:SetStatusBarColor(unpack(reactioncolors[8])) -- tanking
			end
		else
			self.healthBar:SetStatusBarColor(self.r, self.g, self.b) -- normal colours e.g. not tanking/not NPC
		end
	self.elapsed = 0
	end
end

local function UpdateFrame(self)
	local r, g, b = self.healthBar:GetStatusBarColor()
	local newr, newg, newb
	if g + b == 0 then
		newr, newg, newb = unpack(reactioncolors[1])
		self.healthBar:SetStatusBarColor(unpack(reactioncolors[1]))
	elseif r + b == 0 then
		newr, newg, newb = .33, .59, .33
		self.healthBar:SetStatusBarColor(.33, .59, .33)
	elseif r + g == 0 then
		newr, newg, newb = GetMyColor()
		self.healthBar:SetStatusBarColor(GetMyColor())
	elseif 2 - (r + g) < 0.05 and b == 0 then
		newr, newg, newb = unpack(reactioncolors[4])
		self.healthBar:SetStatusBarColor(unpack(reactioncolors[4]))
	else
		newr, newg, newb = r, g, b
	end
	self.r, self.g, self.b = newr, newg, newb
	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent())
	self.healthBar:SetHeight(5)
	self.healthBar:SetWidth(80)
	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -2)
	self.castBar:SetHeight(5)
	self.castBar:SetWidth(80)
	self.highlight:SetTexture(nil)
	self.name:SetText(self.oldname:GetText())
	local level, elite = tonumber(self.level:GetText()), self.elite:IsShown()
	self.level:ClearAllPoints()
	self.level:SetPoint("RIGHT", self.healthBar, "LEFT", -2, 0)
	self.level:SetFont(FONT, 12 * UIParent:GetScale(), "OUTLINE")
	self.level:SetShadowColor(0, 0, 0, 0)
	if self.boss:IsShown() then
		self.level:SetText"B"
		self.level:SetTextColor(.8, .05, 0)
		self.level:Show()
	elseif not elite and level == PLEVEL then
		self.level:Hide()
	elseif level == 1 then
		self:Hide()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local function FixCastbar(self)
	self.castbarOverlay:Hide()
	self:SetHeight(5)
	self:SetWidth(80)
	self:ClearAllPoints()
	self:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -2)
end

local function ColorCastBar(self, shielded)
	if shielded then
		self.iconbg:SetTexture(1, 0, 0)
	else
		self.iconbg:SetTexture(0, 0, 0)
	end
end

local function OnSizeChanged(self)
	self.needFix = true
end

local function OnValueChanged(self, curValue)
	if self.needFix then
		FixCastbar(self)
		self.needFix = nil
	end
end

local function OnShow(self)
	self.channeling = UnitChannelInfo"target"
	FixCastbar(self)
	ColorCastBar(self, self.shieldedRegion:IsShown())
end

local function OnEvent(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			ColorCastBar(self, event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		end
	end
end

local CreateFrame = function(frame)
	if frame.done then
		return
	end
	frame.nameplate = true
	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()
	frame.oldname = nameTextRegion
	nameTextRegion:Hide()
	frame.name = CreateFS(healthBar, 12 * UIParent:GetScale(), "CENTER")
	frame.name:SetPoint("BOTTOM", healthBar, "TOP", 0, 3)
	frame.name:SetWidth(80)
	frame.name:SetHeight(7)
	frame.level = levelTextRegion
	healthBar:SetStatusBarTexture(TEXTURE)
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar.shieldedRegion = shieldedRegion
	castBar:SetStatusBarTexture(TEXTURE)
	castBar:HookScript("OnShow", OnShow)
	castBar:HookScript("OnSizeChanged", OnSizeChanged)
	castBar:HookScript("OnValueChanged", OnValueChanged)
	castBar:HookScript("OnEvent", OnEvent)
	castBar:RegisterEvent"UNIT_SPELLCAST_INTERRUPTIBLE"
	castBar:RegisterEvent"UNIT_SPELLCAST_NOT_INTERRUPTIBLE"
	frame.highlight = highlightRegion
	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 10)
	raidIconRegion:SetHeight(14)
	raidIconRegion:SetWidth(14)
	frame.oldglow = glowRegion
	frame.elite = stateIconRegion
	frame.boss = bossIconRegion
	frame.done = true
	glowRegion:SetTexture(nil)
	overlayRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	stateIconRegion:SetTexture(nil)
	bossIconRegion:SetTexture(nil)
	UpdateFrame(frame)
	frame:SetScript("OnShow", UpdateFrame)
	frame:SetScript("OnHide", OnHide)
	frame.elapsed = 0
	frame:SetScript("OnUpdate", ThreatUpdate)
	CreateBG(castBar, .7)
	CreateBG(healthBar, .7)
	local iconFrame = CreateFrame("Frame", nil, castBar)
	iconFrame:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", 2, 2)
	iconFrame:SetHeight(16)
	iconFrame:SetWidth(16)
	castBar.iconbg = CreateBG(iconFrame, .7)
	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetAllPoints(iconFrame)
	spellIconRegion:SetTexCoord(.1, .9, .1, .9)
end

local numKids = 0
local lastUpdate = 0
NamePlatesFrames:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	if lastUpdate > .1 then
		lastUpdate = 0
		if WorldFrame:GetNumChildren() ~= numKids then
			numKids = WorldFrame:GetNumChildren()
			for i = 1, select("#", WorldFrame:GetChildren()) do
				frame = select(i, WorldFrame:GetChildren())
				if IsValidFrame(frame) then
					CreateFrame(frame)
				end
			end
		end
	end
end)