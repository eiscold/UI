if not Load"spamthrottle" then
	return
end

filterActive = true
filterMode = 2 -- 1=color, 2=hide
filterColor = "|cFF5C5C5C"
filterGap = 120
filterFuzzy = 1

local MessageList = {}
local MessageCount = {}
local MessageTime = {}

local function StrNorm(msg, Author)
	local Nmsg = msg:gsub("...hic!",""):gsub("%d",""):gsub("%c",""):gsub("%p",""):gsub("%s",""):upper():gsub("SH","S")
	local c = ""
	local lastc = ""
	local Bmsg = ""
	local ci = 35

	if filterFuzzy ~= 1 then
		return Author:upper()..msg
	end

	if Author ~= nil then
		ci = ci + Author:len()
	end

	for c in Nmsg:gmatch"%u" do
		if c ~= lastc and ci > 0 then
			Bmsg = Bmsg..c
		end
		lastc = c
		ci = ci - 1
	end
	Nmsg = Bmsg

	if Author ~= nil then
		Nmsg = Author:upper()..Nmsg
	end

	return Nmsg
end

local function ChannelMsgFilter(frame, event, message, ...)
	local BlockFlag = false
	local Msg = StrNorm(arg1, arg2)
	local Author = arg2

	if filterActive == false or arg2 == UnitName"player" then
		return false, message, ...
	end

	if event == "CHAT_MSG_YELL" then
		if MessageList[Msg] ~= nil then
			if MessageCount[Msg] > 1 then
				if difftime(time(), MessageTime[Msg]) <= filterGap then
					BlockFlag = true
				end
			end
		end
	else
		if MessageList[Msg] ~= nil then
			if difftime(time(), MessageTime[Msg]) <= filterGap then
				BlockFlag = true
			end
		end
	end

	if BlockFlag then
		if filterMode == 1 then
			local cleantext = arg1:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")
			return false, (filterColor..cleantext.."|r"), arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12
		else
			return true
		end
	end

	MessageTime[Msg] = time()
	return false, message, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChannelMsgFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChannelMsgFilter)

local SpamThrottleFrame = CreateFrame"Frame"

SpamThrottleFrame:RegisterEvent"CHAT_MSG_CHANNEL"
SpamThrottleFrame:RegisterEvent"CHAT_MSG_YELL"
SpamThrottleFrame:RegisterEvent"ADDON_LOADED"

local function EventHandler(frame, event, ...)
	if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" then
		local Msg = StrNorm(arg1, arg2)
		if MessageList[Msg] == nil then
			MessageList[Msg] = true
			MessageCount[Msg] = 1
			MessageTime[Msg] = time()
		else
			MessageCount[Msg] = MessageCount[Msg] + 1
		end
	end
end
SpamThrottleFrame:SetScript("OnEvent", EventHandler)
