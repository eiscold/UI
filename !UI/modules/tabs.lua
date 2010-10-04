if not Load"tabs" then
	return
end

local ChatTabFrame = CreateFrame"Frame"
local inherit = GameFontNormalSmall
local r, g, b = unpack(reactioncolors[1])
local alpha = .3

local function updateFS(self, inc, flags, ...)
	local font, fontSize = inherit:GetFont()
	if inc then
		self:GetFontString():SetFont(font, fontSize + 1, flags)
	else
		self:GetFontString():SetFont(font, fontSize, flags)
	end
	if ... then
		self:GetFontString():SetTextColor(...)
	end
end

local function OnEnter(self)
	updateFS(self, _G["ChatFrame"..self:GetID().."TabFlash"]:IsShown(), "OUTLINE", r, g, b)
end

local function OnLeave(self)
	local r, g, b
	if _G["ChatFrame"..self:GetID()] == SELECTED_CHAT_FRAME then
		r, g, b = GetMyColor()
	elseif _G["ChatFrame"..self:GetID().."TabFlash"]:IsShown() then
		r, g, b = 1, 0, 0
	else
		r, g, b = 1, 1, 1
	end
	updateFS(self, _G["ChatFrame"..self:GetID().."TabFlash"]:IsShown(), nil, r, g, b, alpha)
end

local function ChatFrame2_SetAlpha(self, alpha)
	if CombatLogQuickButtonFrame_Custom then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local function ChatFrame2_GetAlpha(self)
	if CombatLogQuickButtonFrame_Custom then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local function StyleTab(frame, sel)
	if not frame.ChatTabFrame then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()
		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()
		frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
		frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
		frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide
		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()
		frame.leftHighlightTexture.Show = frame.leftHighlightTexture.Hide
		frame.middleHighlightTexture.Show = frame.middleHighlightTexture.Hide
		frame.rightHighlightTexture.Show = frame.rightHighlightTexture.Hide
		frame:HookScript("OnEnter", OnEnter)
		frame:HookScript("OnLeave", OnLeave)
		frame:SetAlpha(1)
		if frame:GetID() ~= 2 then
			frame.SetAlpha = UIFrameFadeRemoveFrame
		else
			frame.SetAlpha = ChatFrame2_SetAlpha
			frame.GetAlpha = ChatFrame2_GetAlpha
			if CombatLogQuickButtonFrame_Custom then
				CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
			end
		end
		frame.ChatTabFrame = true
	end
	if frame:GetID() == SELECTED_CHAT_FRAME:GetID() then
		local r, g, b = GetMyColor()
		updateFS(frame, nil, nil, r, g, b, alpha)
	else
		updateFS(frame, nil, nil, 1, 1, 1, alpha)
	end
end

hooksecurefunc("FCF_StartAlertFlash", function(frame)
	updateFS(_G["ChatFrame"..frame:GetID().."Tab"], true, nil, 1, 0, 0)
end)

hooksecurefunc("FCFTab_UpdateColors", StyleTab)

for i=1, NUM_CHAT_WINDOWS do
	StyleTab(_G["ChatFrame".. i .."Tab"])
end

ChatTabFrame:RegisterEvent"ADDON_LOADED"
function ChatTabFrame:ADDON_LOADED(event, addon)
	if addon == "Blizzard_CombatLog" then
		self:UnregisterEvent(event)
		self[event] = nil
		return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
	end
end

ChatTabFrame:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end)