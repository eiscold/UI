if not Load"mail" then
	return
end

local MailFrame = CreateFrame("Button", "MailButton", InboxFrame, "UIPanelButtonTemplate")
MailFrame:SetPoint("BOTTOM", InboxFrame, "BOTTOM", -10, 92)
MailFrame:SetWidth(128)
MailFrame:SetHeight(25)
MailFrame.text = CreateFS(MailFrame, 12)
MailFrame.text:SetTextColor(1, 1, 1)
MailFrame.text:SetPoint"CENTER"
MailFrame.processing = false

local function OnEvent()
	if not MailFrame:IsShown() then
		return
	end
	local num = GetInboxNumItems()
	local cash = 0
	local items = 0
	for i = 1, num do
		local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
		if item and COD < 1 then
			items = items + item
		end
		cash = cash + money
	end
	MailFrame.text:SetText(format(GOLD_AMOUNT..", %d "..ITEMS, floor(cash * 0.0001), items))
	if MailFrame.processing then
		if num == 0 then
			MiniMapMailFrame:Hide()
			MailFrame.processing = false
			return
		end
		for i = num, 1, -1 do
			local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
			if item and COD < 1 then
				TakeInboxItem(i)
				return
			end
			if money > 0 then
				TakeInboxMoney(i)
				return
			end
		end
	end
end

local function OnClick()
	if not MailFrame.processing then
		MailFrame.processing = true
		OnEvent()
	end
end

local function OnHide()
	MailFrame.processing = false
end

MailFrame:RegisterEvent"MAIL_INBOX_UPDATE"
MailFrame:SetScript("OnEvent", OnEvent)
MailFrame:SetScript("OnClick", OnClick)
MailFrame:SetScript("OnHide", OnHide)