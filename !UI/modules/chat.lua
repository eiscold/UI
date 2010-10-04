if not Load"chat" then
	return
end

DEFAULT_CHATFRAME_ALPHA = 0
ChatFrameMenuButton:Hide()
ChatFrameMenuButton.Show = dummy
FriendsMicroButton:Hide()

ChatTypeInfo["YELL"].sticky = 1
ChatTypeInfo["OFFICER"].sticky = 1
ChatTypeInfo["WHISPER"].sticky = 1
ChatTypeInfo["CHANNEL"].sticky = 1
ChatTypeInfo["RAID_WARNING"].sticky = 1

CHAT_GUILD_GET = "|Hchannel:GUILD|hg|h %s "
CHAT_RAID_GET = "|Hchannel:RAID|hr|h %s "
CHAT_PARTY_GET = "|Hchannel:PARTY|hp|h %s "
CHAT_RAID_WARNING_GET = "RW %s "
CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hR|h %s "
CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|hP|h %s: "
CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|hD|h %s:\32";
CHAT_OFFICER_GET = "|Hchannel:OFFICER|ho|h %s "
CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|hb|h %s "
CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|hB|h %s "
CHAT_WHISPER_INFORM_GET = "To %s "
CHAT_WHISPER_GET = "From %s "
CHAT_SAY_GET = "%s "
CHAT_YELL_GET = "%s "

CHAT_FLAG_AFK = GetMyTextColor().."AFK|r "
CHAT_FLAG_DND = GetMyTextColor().."DND|r "
CHAT_FLAG_GM = "|cffff0000<< GM >>|r "

--CHAT_FRAME_FADE_OUT_TIME = 0
CHAT_TAB_HIDE_DELAY = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0

local lines = {}
local hooks, h = {}
local str = "%d|h %3$s"
local channel = function(...)
	return str:format(...)
end

local function AddMessage(frame, text, ...)
	if type(text) == "string" then
		text = text:gsub("|H(.-)|h%[(.-)%]|h%:?", "|H%1|h%2|h")
		text = text:gsub("(%d+)%. (.+).+(|Hplayer.+)", channel)
		text = text:gsub("%s(%a+)://(%S+[^%p%s])", " "..GetMyTextColor().."|Hurl:%1://%2|h%1://%2|h|r")
		text = text:gsub("%swww%.(%S+[^%p%s])", " "..GetMyTextColor().."|Hurl:www.%1|hwww.%1|h|r")
		text = text:gsub("%s([%w%-%_%.]+)@([%w%-%_%.]+%a)", " "..GetMyTextColor().."|Hurl:%1@%2|h%1@%2|h|r")
		text = text:gsub("%s(%d+%.%d+%.%d+%.%d+)(%S*)", " "..GetMyTextColor().."|Hurl:%1%2|h%1%2|h|r")
	end
	return hooks[frame](frame, text, ...)
end

local CopyFrame = CreateFrame("Frame", nil, UIParent)
CopyFrame:SetWidth(ChatFrame1:GetWidth() + 35)
CopyFrame:SetHeight(350)
CopyFrame:SetPoint("LEFT", UIParent, "LEFT", 50, 0)
CopyFrame:SetFrameStrata"DIALOG"
CopyFrame:Hide()
CreateBG(CopyFrame)

local editBox = CreateFrame("EditBox", "ChatCopyBox", CopyFrame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(20000)
editBox:EnableMouse(true)
editBox:SetAutoFocus(true)
editBox:SetFont(FONT, 12, "OUTLINE")
editBox:SetWidth(ChatFrame1:GetWidth())
editBox:SetScript("OnEscapePressed", function()
	CopyFrame:Hide()
	wipe(lines)
end)

local scrollArea = CreateFrame("ScrollFrame", "ChatCopyScroll", CopyFrame, "UIPanelScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", CopyFrame, "TOPLEFT", 8, -8)
scrollArea:SetPoint("BOTTOMRIGHT", CopyFrame, "BOTTOMRIGHT", -30, 8)
scrollArea:SetScrollChild(editBox)

local function GetLines(...)
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	CopyFrame:Show()
	editBox:SetText(text)
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = "ChatFrame"..tostring(i)

	_G[cf]:SetScript("OnUpdate", nil)
	_G[cf]:SetFont(FONT, 12, "THINOUTLINE")
	_G[cf]:SetShadowColor(0, 0, 0, 0)
	_G[cf]:SetFading(true)
	_G[cf]:SetFadeDuration(2)
	_G[cf]:SetTimeVisible(60)

	_G[cf.."TabLeft"]:Hide()
	_G[cf.."TabMiddle"]:Hide()
	_G[cf.."TabRight"]:Hide()
	_G[cf.."Tab"].noMouseAlpha = 0
	FCFTab_UpdateAlpha(_G[cf])

	_G[cf.."ButtonFrame"]:Hide()
	_G[cf.."ButtonFrame"].Show = dummy
	_G[cf.."ButtonFrameUpButton"]:Hide()
	_G[cf.."ButtonFrameUpButton"].Show = dummy
	_G[cf.."ButtonFrameDownButton"]:Hide()
	_G[cf.."ButtonFrameDownButton"].Show = dummy
	_G[cf.."ButtonFrameBottomButton"]:Hide()
	_G[cf.."ButtonFrameBottomButton"].Show = dummy

	hooks[_G[cf]], _G[cf].AddMessage = _G[cf].AddMessage, AddMessage

	local eb = _G[cf.."EditBox"]
	eb:ClearAllPoints()
	eb:SetAltArrowKeyMode(false)
	eb:SetPoint("BOTTOMLEFT",  cf, "TOPLEFT", -5, 18)
	eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, 18)
	eb:SetFont(FONT, 12, "THINOUTLINE")
	eb:SetShadowColor(0, 0, 0, 0)
	eb.focusLeft:SetTexture(nil)
	eb.focusRight:SetTexture(nil)
	eb.focusMid:SetTexture(nil)

	local a, b, c = select(6, eb:GetRegions())
	a:Hide(); b:Hide(); c:Hide()

	_G[cf.."EditBoxHeader"]:SetFont(FONT, 12, "THINOUTLINE")
	_G[cf.."EditBoxHeader"]:SetShadowColor(0, 0, 0, 0)

	_G[cf.."Tab"]:HookScript("OnClick", function()
		if IsShiftKeyDown() then
			Copy(_G[cf])
		end
	end)

end

local origSetItemRef = SetItemRef
SetItemRef = function(link, ...)
	if link:sub(1, 3) == "url" then
		ChatFrame1EditBox:Show()
		ChatFrame1EditBox:Insert(link:sub(5))
	elseif link:sub(1, 6) == "player" and IsAltKeyDown() then
		InviteUnit(string.match(link, "player:([^:]+)"))
	else
		origSetItemRef(link, ...)
	end
end