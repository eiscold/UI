local function SetupUI()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", 768 / string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
	
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("autoQuestWatch", 0)
	SetCVar("buffDurations", 1)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatBubblesParty", 0)
	SetCVar("chatBubbles", 0) 
	SetCVar("chatMouseScroll", 1)
	SetCVar("CombatDamage", 1)
	SetCVar("CombatHealing", 0)
	SetCVar("equipmentManager", 1)
	SetCVar("guildMemberNotify", 1)
	SetCVar("hidePartyInRaid", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("maxfpsbk", "24")
	SetCVar("nameplateAllowOverlap", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyGuardians", 0)
	SetCVar("nameplateShowFriendlyPets", 0)
	SetCVar("nameplateShowFriendlyTotems", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowEnemyPets", 1)
	SetCVar("nameplateShowEnemyGuardians", 1)
	SetCVar("nameplateShowEnemyTotems", 0)
	SetCVar("previewTalents", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("scriptProfile", 1)
	SetCVar("showClock", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("showTutorials", 0)
	SetCVar("showLootSpam", 0)
	SetCVar("UnitNameOwn", 0)
	SetCVar("UnitNameNPC", 0)
	SetCVar("UnitNameNonCombatCreatureName", 0)
	SetCVar("UnitNamePlayerGuild", 0)
	SetCVar("UnitNamePlayerPVPTitle", 0)
	SetCVar("UnitNameFriendlyPlayerName", 1)
	SetCVar("UnitNameFriendlyPetName", 0)
	SetCVar("UnitNameFriendlyGuardianName", 0)
	SetCVar("UnitNameFriendlyTotemName", 0)
	SetCVar("UnitNameEnemyPlayerName", 0)
	SetCVar("UnitNameEnemyPetName", 0)
	SetCVar("UnitNameEnemyGuardianName", 0)
	SetCVar("UnitNameEnemyTotemName", 0)

	SetMultisampleFormat(1)

	--FCF_ResetChatWindows()
	FCF_DockFrame(ChatFrame2)

	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 50)
	ChatFrame1:SetHeight(121)
	ChatFrame1:SetWidth(342)
	ChatFrame1:SetUserPlaced(true)

	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
	FCF_SetWindowAlpha(ChatFrame1, 0)
	FCF_SetWindowAlpha(ChatFrame2, 0)

	local channels = {
		"SAY",
		"EMOTE",
		"YELL",
		"GUILD",
		"GUILD_OFFICER",
		"GUILD_ACHIEVEMENT",
		"ACHIEVEMENT",
		"WHISPER",
		"PARTY",
		"PARTY_LEADER",
		"RAID",
		"RAID_LEADER",
		"RAID_WARNING",
		"BATTLEGROUND",
		"BATTLEGROUND_LEADER",
		"CHANNEL1",
		"CHANNEL2",
		"CHANNEL3",
		"CHANNEL4",
		"CHANNEL5",
	}
	for i, v in ipairs(channels) do
		ToggleChatColorNamesByClassGroup(true, v)
	end
end

local SetupFrame = CreateFrame"Frame"
SetupFrame:SetWidth(320)
SetupFrame:SetHeight(SetupFrame:GetWidth() * GetScreenHeight() / GetScreenWidth())
SetupFrame:SetScale(768 / string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
SetupFrame:SetPoint("CENTER", UIParent, "CENTER")
CreateBG(SetupFrame, .7)

SetupFrame.Title = CreateFS(SetupFrame, 36, "CENTER")
SetupFrame.Title:SetText(UI_NAME)
SetupFrame.Title:SetPoint("CENTER", SetupFrame, "CENTER", 0, 30)

SetupFrame.Version = CreateFS(SetupFrame, FONT_SIZE, "CENTER")
SetupFrame.Version:SetText(UI_VERSION)
SetupFrame.Version:SetPoint("TOP", SetupFrame.Title, "BOTTOM")

SetupFrame.Author = CreateFS(SetupFrame, 10, "CENTER")
SetupFrame.Author:SetText(UI_AUTHOR)
SetupFrame.Author:SetPoint("BOTTOM", SetupFrame, "BOTTOM", 0, 1)
SetupFrame.Author:SetTextColor(1, 1, 1, .3)

SetupFrame.Button1 = CreateFrame("Button", nil, SetupFrame, "UIPanelButtonTemplate")
SetupFrame.Button1:SetWidth(100)
SetupFrame.Button1:SetHeight(20)
SetupFrame.Button1:SetPoint("BOTTOMRIGHT", SetupFrame, "BOTTOM", -10, 50)
SetupFrame.Button1:RegisterForClicks"LeftButtonUp"
SetupFrame.Button1.Font = CreateFS(SetupFrame.Button1, 12)
SetupFrame.Button1.Font:SetTextColor(1, 1, 1)
SetupFrame.Button1:SetFontString(SetupFrame.Button1.Font)
SetupFrame.Button1:SetText(L["Install"])
CreateButtonPulse(SetupFrame.Button1)
SetupFrame.Button1:SetScript("OnClick", function(self, button, down)
	SetupUI()
	UIParent:SetAlpha(1)
	SetupFrame:Hide()
	ReloadUI()
	DisableAddOn"!Setup"
end)

SetupFrame.Button2 = CreateFrame("Button", nil, SetupFrame, "UIPanelButtonTemplate")
SetupFrame.Button2:SetWidth(100)
SetupFrame.Button2:SetHeight(20)
SetupFrame.Button2:SetPoint("BOTTOMLEFT", SetupFrame, "BOTTOM", 10, 50)
SetupFrame.Button2:RegisterForClicks"LeftButtonUp"
SetupFrame.Button2.Font = CreateFS(SetupFrame.Button2, 12)
SetupFrame.Button2.Font:SetTextColor(1, 1, 1)
SetupFrame.Button2:SetFontString(SetupFrame.Button2.Font)
SetupFrame.Button2:SetText(CANCEL)
CreateButtonPulse(SetupFrame.Button2)
SetupFrame.Button2:SetScript("OnClick", function(self, button, down)
	UIParent:SetAlpha(1)
	SetupFrame:Hide()
	DisableAddOn"!Setup"
end)

UIParent:SetAlpha(0)
SetupFrame:Show()