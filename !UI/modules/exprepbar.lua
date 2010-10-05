if not Load"exprepbar" then
	return
end

local ExpRepBarFrame = CreateFrame("Frame", nil, UIParent)
ExpRepBarFrame.width = 5
ExpRepBarFrame.height = Minimap:GetHeight() - 14

local function colorize(rank)
	local r, g, b = unpack(reactioncolors[rank])
	return string.format("|cff%2x%2x%2x", r * 255, g * 255, b * 255)
end

local function SetupBars()
	ExpRepBarFrame.backdrop = CreateFrame("Frame", nil, ExpRepBarFrame)
	ExpRepBarFrame.backdrop:SetHeight(ExpRepBarFrame.height)
	ExpRepBarFrame.backdrop:SetWidth(ExpRepBarFrame.width)
	ExpRepBarFrame.backdrop:SetPoint("LEFT", Minimap, "RIGHT", 6, 0)
	CreateBG(ExpRepBarFrame.backdrop, .7)
	ExpRepBarFrame.backdrop:SetBackdrop(BACKDROP)
	ExpRepBarFrame.backdrop:SetBackdropColor(0, 0, 0, .7)
	ExpRepBarFrame.backdrop:SetBackdropBorderColor(0, 0, 0)
	ExpRepBarFrame.backdrop:SetFrameLevel(0)
	
	ExpRepBarFrame.xpBar = CreateFrame("StatusBar", nil, ExpRepBarFrame, "TextStatusBar")
	ExpRepBarFrame.xpBar:SetWidth(ExpRepBarFrame.width - 1)
	ExpRepBarFrame.xpBar:SetHeight(ExpRepBarFrame.height - 1)
	ExpRepBarFrame.xpBar:SetPoint("TOP", ExpRepBarFrame.backdrop, "TOP", 0, -1)
	ExpRepBarFrame.xpBar:SetStatusBarTexture(TEXTURE)
	ExpRepBarFrame.xpBar:SetOrientation"VERTICAL"
	ExpRepBarFrame.xpBar:SetFrameLevel(2)
	
	ExpRepBarFrame.restedxpBar = CreateFrame("StatusBar", nil, ExpRepBarFrame, "TextStatusBar")
	ExpRepBarFrame.restedxpBar:SetWidth(ExpRepBarFrame.width - 1)
	ExpRepBarFrame.restedxpBar:SetHeight(ExpRepBarFrame.height - 1)
	ExpRepBarFrame.restedxpBar:SetPoint("TOP", ExpRepBarFrame.backdrop,"TOP", 0, -1)
	ExpRepBarFrame.restedxpBar:SetStatusBarTexture(TEXTURE)
	ExpRepBarFrame.restedxpBar:SetFrameLevel(1)
	ExpRepBarFrame.restedxpBar:SetOrientation"VERTICAL"
	ExpRepBarFrame.restedxpBar:Hide()
	
	ExpRepBarFrame.repBar = CreateFrame("StatusBar", nil, ExpRepBarFrame, "TextStatusBar")
	ExpRepBarFrame.repBar:SetWidth(ExpRepBarFrame.width - 1)
	ExpRepBarFrame.repBar:SetHeight(1)
	ExpRepBarFrame.repBar:SetPoint("TOP", ExpRepBarFrame.xpBar, "BOTTOM", 0, 0)
	ExpRepBarFrame.repBar:SetStatusBarTexture(TEXTURE)
	ExpRepBarFrame.repBar:SetFrameLevel(1)
	ExpRepBarFrame.repBar:SetOrientation"VERTICAL"
	ExpRepBarFrame.repBar:Hide()

	ExpRepBarFrame.sep = CreateFrame("Frame", nil, ExpRepBarFrame)
	ExpRepBarFrame.sep:SetWidth(ExpRepBarFrame.width - 1)
	ExpRepBarFrame.sep:SetHeight(1)
	ExpRepBarFrame.sep:SetPoint("TOP", ExpRepBarFrame.xpBar, "BOTTOM")
	ExpRepBarFrame.sep:SetBackdrop({
		bgFile = "",
	})
	ExpRepBarFrame.sep:SetBackdropColor(0, 0, 0)
	ExpRepBarFrame.sep:Hide()
	
	ExpRepBarFrame.mouseFrame = CreateFrame("Frame", nil, ExpRepBarFrame)
	ExpRepBarFrame.mouseFrame:SetAllPoints(ExpRepBarFrame.backdrop)
	ExpRepBarFrame.mouseFrame:SetFrameLevel(3)
	ExpRepBarFrame.mouseFrame:EnableMouse(true)
end

local function ShowBars()
	if PLEVEL ~= MAX_PLAYER_LEVEL then
		local XP, maxXP = UnitXP"player", UnitXPMax"player"
		local restXP = GetXPExhaustion()
		local percXP = floor(XP / maxXP * 100)

		if GetXPExhaustion() then 
			if not ExpRepBarFrame.restedxpBar:IsShown() then
				ExpRepBarFrame.restedxpBar:Show()
			end
			ExpRepBarFrame.restedxpBar:SetStatusBarColor(0, .4, .8)
			ExpRepBarFrame.restedxpBar:SetMinMaxValues(min(0, XP), maxXP)
			ExpRepBarFrame.restedxpBar:SetValue(XP + restXP)
		else
			if ExpRepBarFrame.restedxpBar:IsShown() then
				ExpRepBarFrame.restedxpBar:Hide()
			end
		end
		
		ExpRepBarFrame.xpBar:SetStatusBarColor(.5, 0, .75)
		ExpRepBarFrame.xpBar:SetMinMaxValues(min(0, XP), maxXP)
		ExpRepBarFrame.xpBar:SetValue(XP)	

		if GetWatchedFactionInfo() then
			local name, rank, min, max, value = GetWatchedFactionInfo()
			if not ExpRepBarFrame.repBar:IsShown() then
				ExpRepBarFrame.repBar:Show()
			end
			ExpRepBarFrame.repBar:SetStatusBarColor(unpack(factioninfo[rank][1]))
			ExpRepBarFrame.repBar:SetMinMaxValues(min, max)
			ExpRepBarFrame.repBar:SetValue(value)
			ExpRepBarFrame.xpBar:SetHeight(ExpRepBarFrame.height - 1)
			ExpRepBarFrame.restedxpBar:SetHeight(ExpRepBarFrame.height - 1)
			ExpRepBarFrame.sep:Show()
		else
			if ExpRepBarFrame.repBar:IsShown() then
				ExpRepBarFrame.repBar:Hide()
			end
			ExpRepBarFrame.xpBar:SetHeight(ExpRepBarFrame.height - 1)
			ExpRepBarFrame.restedxpBar:SetHeight(ExpRepBarFrame.height - 1)
			if ExpRepBarFrame.sep:IsShown() then
				ExpRepBarFrame.sep:Hide()
			end
		end

		ExpRepBarFrame.mouseFrame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(ExpRepBarFrame.mouseFrame, "ANCHOR_BOTTOMLEFT", -3, ExpRepBarFrame.height - 1)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(PLEVEL.." -> "..PLEVEL + 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(string.format("%s", GetShortValue(maxXP - XP)), string.format("%s/%s (%d%%)", GetShortValue(XP), GetShortValue(maxXP), (XP / maxXP) * 100), 1, 1, 1, 1, 1, 1)
			if restXP then
				GameTooltip:AddDoubleLine(" ", string.format("|cff0066CC%s (%d%%)", GetShortValue(restXP), restXP / maxXP * 100), 1, 1, 1)
			end
			if GetWatchedFactionInfo() then
				local name, rank, min, max, value = GetWatchedFactionInfo()
				GameTooltip:AddLine" "
				GameTooltip:AddDoubleLine(name, string.format(colorize(rank).."%s|r", factioninfo[rank][2]), 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(string.format("%s", GetShortValue(max - value)), string.format("%s/%s (%d%%)", GetShortValue(value - min), GetShortValue(max - min), (value - min) / (max - min) * 100), 1, 1, 1, 1, 1, 1)
			end
			GameTooltip:Show()
		end)
		ExpRepBarFrame.mouseFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

	else
		if GetWatchedFactionInfo() then
			local name, rank, min, max, value = GetWatchedFactionInfo()
			ExpRepBarFrame.xpBar:SetStatusBarColor(unpack(factioninfo[rank][1]))
			ExpRepBarFrame.xpBar:SetMinMaxValues(min, max)
			ExpRepBarFrame.xpBar:SetValue(value)
			ExpRepBarFrame.mouseFrame:SetScript("OnEnter", function()
				GameTooltip:SetOwner(ExpRepBarFrame.mouseFrame, "ANCHOR_BOTTOMLEFT", -3, ExpRepBarFrame.height - 1)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(name, string.format(colorize(rank).."%s|r", factioninfo[rank][2]), 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(string.format("%s", GetShortValue(max-value)), string.format("%s/%s (%d%%)", GetShortValue(value-min), GetShortValue(max - min), (value - min) / (max - min) * 100), 1, 1, 1, 1, 1, 1)
				GameTooltip:Show()
			end)
			ExpRepBarFrame.mouseFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
			if not ExpRepBarFrame:IsShown() then
				ExpRepBarFrame:Show()
			end
		else
			ExpRepBarFrame:Hide()
		end
	end
end

ExpRepBarFrame.setup = false
ExpRepBarFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
ExpRepBarFrame:RegisterEvent"PLAYER_LEVEL_UP"
ExpRepBarFrame:RegisterEvent"PLAYER_XP_UPDATE"
ExpRepBarFrame:RegisterEvent"UPDATE_EXHAUSTION"
ExpRepBarFrame:RegisterEvent"CHAT_MSG_COMBAT_FACTION_CHANGE"
ExpRepBarFrame:RegisterEvent"UPDATE_FACTION"
ExpRepBarFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LEVEL_UP" then
		PLEVEL = PLEVEL + 1
	end
	if not ExpRepBarFrame.setup then
		SetupBars()
		ExpRepBarFrame.setup = true
	end
	ShowBars()
end)