if not Load"spamthrottle" then
	return
end

local SpamThrottleFrame = CreateFrame"Frame"

SpamThrottleFrame.mode = 1 -- 1 = color, 2 = hide
SpamThrottleFrame.color = "|cFF5C5C5C"
SpamThrottleFrame.gap = 120
SpamThrottleFrame.fuzzy = 1
SpamThrottleFrame.list = {}
SpamThrottleFrame.count = {}
SpamThrottleFrame.time = {}

local function StrNorm(msg, Author)
	local Nmsg = msg:gsub(string.sub(SLURRED_SPEECH, 4), ""):gsub("%d", ""):gsub("%c", ""):gsub("%p", ""):gsub("%s", ""):upper():gsub("SH", "S")
	local c = ""
	local lastc = ""
	local Bmsg = ""
	local ci = 35
	if SpamThrottleFrame.fuzzy ~= 1 then
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
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 = message, ...
	local BlockFlag = false
	local Msg = StrNorm(arg1, arg2)
	local Author = arg2
	if Author == PNAME then
		return false, message, ...
	end
	if event == "CHAT_MSG_YELL" then
		if SpamThrottleFrame.list[Msg] ~= nil then
			if SpamThrottleFrame.count[Msg] > 1 then
				if difftime(time(), SpamThrottleFrame.time[Msg]) <= SpamThrottleFrame.gap then
					BlockFlag = true
				end
			end
		end
	else
		if SpamThrottleFrame.list[Msg] ~= nil then
			if difftime(time(), SpamThrottleFrame.time[Msg]) <= SpamThrottleFrame.gap then
				BlockFlag = true
			end
		end
	end
	if BlockFlag then
		if SpamThrottleFrame.mode == 1 then
			local cleantext = arg1:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")
			return false, (SpamThrottleFrame.color..cleantext.."|r"), arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12
		else
			return true
		end
	end
	SpamThrottleFrame.time[Msg] = time()
	return false, message, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChannelMsgFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChannelMsgFilter)

SpamThrottleFrame:RegisterEvent"CHAT_MSG_CHANNEL"
SpamThrottleFrame:RegisterEvent"CHAT_MSG_YELL"
SpamThrottleFrame:RegisterEvent"ADDON_LOADED"
SpamThrottleFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" then
		local arg1, arg2 = ...
		local Msg = StrNorm(arg1, arg2)
		if SpamThrottleFrame.list[Msg] == nil then
			SpamThrottleFrame.list[Msg] = true
			SpamThrottleFrame.count[Msg] = 1
			SpamThrottleFrame.time[Msg] = time()
		else
			SpamThrottleFrame.count[Msg] = SpamThrottleFrame.count[Msg] + 1
		end
	end
end)
