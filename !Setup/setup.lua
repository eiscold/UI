local function SetupUI()
	SetCVar("useUiScale", 1)
	SetCVar("uiScale", 768 / string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
	SetCVar("showClock", 0)
	SetCVar("hidePartyInRaid", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("maxfpsbk","24")
	SetCVar("scriptProfile", 1)

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
CreatePulseBG(SetupFrame.Button1, "button")
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
CreatePulseBG(SetupFrame.Button2, "button")
SetupFrame.Button2:SetScript("OnClick", function(self, button, down)
	UIParent:SetAlpha(1)
	SetupFrame:Hide()
	DisableAddOn"!Setup"
end)

UIParent:SetAlpha(0)
SetupFrame:Show()