if not Load"proflink" then
	function GetTradeSkillLink(_) end
	return
end

local tradeskills = {
	L["Alchemy"],
	L["Blacksmithing"],
	L["Cooking"],
	L["Enchanting"],
	L["Engineering"],
	L["Inscription"],
	L["Jewelcrafting"],
	L["Leatherworking"],
	L["Tailoring"],
}

function GetTradeSkillLink(msg)
	local s = string.lower(msg)	
	if string.find(s, "^!") then
		for i, profession in pairs(tradeskills) do
			if string.find("^!"..string.lower(profession), s) then
				local _, link = GetSpellLink(profession)
				if link then
					return link
				else
					return
				end
			end
		end
	end
end

local ProfLinkFrame = CreateFrame"Frame"
ProfLinkFrame:RegisterEvent"CHAT_MSG_WHISPER"
ProfLinkFrame:SetScript("OnEvent", function(self, event, msg, sender)
	if event == "CHAT_MSG_WHISPER" then
		local link = GetTradeSkillLink(msg)
		if link then
			SendChatMessage(link, "WHISPER", nil, sender)
		end
	end
end)