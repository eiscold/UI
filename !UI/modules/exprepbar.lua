if not Load"exprepbar" then
	return
end

local W, H = 5, Minimap:GetHeight() - 14

local FactionInfo = {
	[1] = {{unpack(reactioncolors[1])}, FACTION_STANDING_LABEL1},
	[2] = {{unpack(reactioncolors[2])}, FACTION_STANDING_LABEL2},
	[3] = {{unpack(reactioncolors[3])}, FACTION_STANDING_LABEL3},
	[4] = {{unpack(reactioncolors[4])}, FACTION_STANDING_LABEL4},
	[5] = {{unpack(reactioncolors[5])}, FACTION_STANDING_LABEL5},
	[6] = {{unpack(reactioncolors[6])}, FACTION_STANDING_LABEL6},
	[7] = {{unpack(reactioncolors[7])}, FACTION_STANDING_LABEL7},
	[8] = {{unpack(reactioncolors[8])}, FACTION_STANDING_LABEL8},

}

local ExpRepBarFrame = CreateFrame("Frame", nil, UIParent)

local function colorize(rank)
	local r, g, b = unpack(reactioncolors[rank])
	return string.format("|cff%2x%2x%2x", r * 255, g * 255, b * 255)
end

local function SetupBars()
	local backdrop = CreateFrame("Frame", nil, ExpRepBarFrame)
	backdrop:SetHeight(H)
	backdrop:SetWidth(W)
	backdrop:SetPoint("LEFT", Minimap, "RIGHT", 6, 0)
	CreateBG(backdrop)
	backdrop:SetBackdrop(BACKDROP)
	backdrop:SetBackdropColor(0, 0, 0, .6)
	backdrop:SetBackdropBorderColor(0, 0, 0)
	
	backdrop:SetFrameLevel(0)
	ExpRepBarFrame.backdrop = backdrop
	
	local xpBar = CreateFrame("StatusBar", nil, ExpRepBarFrame, "TextStatusBar")
	xpBar:SetWidth(W - 1)
	xpBar:SetHeight(H - 1)
	xpBar:SetPoint("TOP", backdrop,"TOP", 0, -1)
	xpBar:SetStatusBarTexture(TEXTURE)
	xpBar:SetOrientation"VERTICAL"
	xpBar:SetFrameLevel(2)
	ExpRepBarFrame.xpBar = xpBar
	
	local restedxpBar = CreateFrame("StatusBar", nil, ExpRepBarFrame, "TextStatusBar")
	restedxpBar:SetWidth(W - 1)
	restedxpBar:SetHeight(H - 1)
	restedxpBar:SetPoint("TOP", backdrop,"TOP", 0, -1)
	restedxpBar:SetStatusBarTexture(TEXTURE)
	restedxpBar:SetFrameLevel(1)
	restedxpBar:SetOrientation"VERTICAL"
	restedxpBar:Hide()
	ExpRepBarFrame.restedxpBar = restedxpBar
	
	local repBar = CreateFrame("StatusBar", nil, ExpRepBarFrame, "TextStatusBar")
	repBar:SetWidth(W - 1)
	repBar:SetHeight(1)
	repBar:SetPoint("TOP", xpBar, "BOTTOM", 0, 0)
	repBar:SetStatusBarTexture(TEXTURE)
	repBar:SetFrameLevel(1)
	repBar:SetOrientation"VERTICAL"
	repBar:Hide()
	ExpRepBarFrame.repBar = repBar

	local sep = CreateFrame("Frame", nil, ExpRepBarFrame)
	sep:SetWidth(W - 1)
	sep:SetHeight(1)
	sep:SetPoint("TOP", xpBar, "BOTTOM")
	sep:SetBackdrop({
		bgFile = "",
	})
	sep:SetBackdropColor(0, 0, 0)
	sep:Hide()
	ExpRepBarFrame.sep = sep
	
	local mouseFrame = CreateFrame("Frame", nil, ExpRepBarFrame)
	mouseFrame:SetAllPoints(backdrop)
	mouseFrame:SetFrameLevel(3)
	mouseFrame:EnableMouse(true)
	ExpRepBarFrame.mouseFrame = mouseFrame
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
			ExpRepBarFrame.repBar:SetStatusBarColor(unpack(FactionInfo[rank][1]))
			ExpRepBarFrame.repBar:SetMinMaxValues(min, max)
			ExpRepBarFrame.repBar:SetValue(value)
			ExpRepBarFrame.xpBar:SetHeight(H - 1)
			ExpRepBarFrame.restedxpBar:SetHeight(H - 1)
			ExpRepBarFrame.sep:Show()
		else
			if ExpRepBarFrame.repBar:IsShown() then
				ExpRepBarFrame.repBar:Hide()
			end
			ExpRepBarFrame.xpBar:SetHeight(H - 1)
			ExpRepBarFrame.restedxpBar:SetHeight(H - 1)
			if ExpRepBarFrame.sep:IsShown() then
				ExpRepBarFrame.sep:Hide()
			end
		end

		ExpRepBarFrame.mouseFrame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(ExpRepBarFrame.mouseFrame, "ANCHOR_BOTTOMLEFT", -3, H - 1)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(PLEVEL.." -> "..PLEVEL + 1, 1, 1, 1)
			GameTooltip:AddDoubleLine(string.format("%s", GetShortValue(maxXP - XP)), string.format("%s/%s (%d%%)", GetShortValue(XP), GetShortValue(maxXP), (XP / maxXP) * 100), 1, 1, 1, 1, 1, 1)
			if restXP then
				GameTooltip:AddDoubleLine(" ", string.format("|cff0066CC%s (%d%%)", GetShortValue(restXP), restXP / maxXP * 100), 1, 1, 1)
			end
			if GetWatchedFactionInfo() then
				local name, rank, min, max, value = GetWatchedFactionInfo()
				GameTooltip:AddLine" "
				GameTooltip:AddDoubleLine(name, string.format(colorize(rank).."%s|r", FactionInfo[rank][2]), 1, 1, 1, 1, 1, 1)
				GameTooltip:AddDoubleLine(string.format("%s", GetShortValue(max - value)), string.format("%s/%s (%d%%)", GetShortValue(value - min), GetShortValue(max - min), (value - min) / (max - min) * 100), 1, 1, 1, 1, 1, 1)
			end
			GameTooltip:Show()
		end)
		ExpRepBarFrame.mouseFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

	else
		if GetWatchedFactionInfo() then
			local name, rank, min, max, value = GetWatchedFactionInfo()
			ExpRepBarFrame.xpBar:SetStatusBarColor(unpack(FactionInfo[rank][1]))
			ExpRepBarFrame.xpBar:SetMinMaxValues(min, max)
			ExpRepBarFrame.xpBar:SetValue(value)
			ExpRepBarFrame.mouseFrame:SetScript("OnEnter", function()
				GameTooltip:SetOwner(ExpRepBarFrame.mouseFrame, "ANCHOR_BOTTOMLEFT", -3, H - 1)
				GameTooltip:ClearLines()
				GameTooltip:AddDoubleLine(name, string.format(colorize(rank).."%s|r", FactionInfo[rank][2]), 1, 1, 1, 1, 1, 1)
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

local setup = false
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
	if not setup then
		SetupBars()
		setup = true
	end
	ShowBars()
end)