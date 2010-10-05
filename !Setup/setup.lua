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

	StaticPopup_Show"RELOAD_UI"
end

StaticPopupDialogs["CONFIGURE_UI"] = {
	text = "Configure !UI?",
	button1 = YES,
	button2 = NO,
	OnAccept = SetupUI,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

StaticPopupDialogs["RELOAD_UI"] = {
	text = "Configuration of !UI finished. Reload?",
	button1 = YES,
	button2 = NO,
	OnAccept = ReloadUI,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true,
}

local LoadFrame = CreateFrame"Frame"
LoadFrame:SetWidth(320)
LoadFrame:SetHeight(200)
LoadFrame:SetScale(768 / string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
LoadFrame:SetScale(UIParent:GetScale())
LoadFrame:SetPoint("CENTER", UIParent, "CENTER")
CreateBG(LoadFrame)

LoadFrame.Text = CreateFS(LoadFrame, FONT_SIZE, "CENTER")
LoadFrame.Text:SetText(UI_NAME.." "..UI_VERSION.." by "..UI_AUTHOR)
LoadFrame.Text:SetPoint("CENTER", LoadFrame, "CENTER")

LoadFrame.Button1 = CreateFrame("Button", nil, LoadFrame)
LoadFrame.Button1:SetWidth(80)
LoadFrame.Button1:SetHeight(12)
LoadFrame.Button1:SetPoint("BOTTOMLEFT", LoadFrame, "BOTTOMLEFT", 10, 10)
LoadFrame.Button1:RegisterForClicks"LeftButtonUp"
LoadFrame.Button1:SetText"Yes"	

LoadFrame.Button2 = CreateFrame("Button", nil, LoadFrame)
LoadFrame.Button2:SetWidth(80)
LoadFrame.Button2:SetHeight(12)
LoadFrame.Button2:SetPoint("BOTTOMRIGHT", LoadFrame, "BOTTOMRIGHT", -10, 10)
LoadFrame.Button2:RegisterForClicks"LeftButtonUp"
LoadFrame.Button2:SetText"No"

--[[
LoadFrame.upTime = 6

UIParent:SetAlpha(0)

LoadFrame:SetScript("OnUpdate", function(self, elapsed)
	self.upTime = self.upTime - elapsed
	if self.upTime <= 0 then
		self:Hide()
		UIParent:SetAlpha(1)	
		self:SetScript("OnUpdate", nil)
	end
end)

StaticPopup_Show"CONFIGURE_UI"
]]

DisableAddOn"!Setup"