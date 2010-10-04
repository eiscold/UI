if not Load"events" then
	return
end

local EventFrame = CreateFrame"Frame"
EventFrame:SetScript("OnEvent", function(self, event, arg1, arg2) self[event](self, event, arg1, arg2) end)

if CFG.EcoFrameRate then
	local delay = 1
	local oldfps, newfps
	EventFrame:SetScript("OnUpdate", function(self, elapsed)
		delay = delay - elapsed
		if delay < 0 then
			if GetUnitSpeed"player" > 0 or UnitAffectingCombat"player" then
				newfps = 80
			else
				newfps = 30
			end
			if newfps ~= oldfps then
				SetCVar("maxfps", newfps)
				oldfps = newfps
			end
			delay = 1
		end
	end)
end

if CFG.AutoSell then
	EventFrame:RegisterEvent"MERCHANT_SHOW"
	function EventFrame:MERCHANT_SHOW(self)
		if CanMerchantRepair() then
			local cost = GetRepairAllCost()
			if cost > 0 and GetMoney() > cost then
				RepairAllItems(CanGuildBankRepair() and 1 or 0)
				print(format("%s %.2fg %s", REPAIR_COST, cost * 0.0001, CanGuildBankRepair() and "(guild bank)" or ""))
			end
		end
		for bag = 0, 4 do
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link and (select(3, GetItemInfo(link)) == 0) then
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end

if CFG.AutoInvite then
	local IsFriend = function(name)
		for i = 1, GetNumFriends() do
			if GetFriendInfo(i) == name then
				return true
			end
		end
		if IsInGuild() then
			for i = 1, GetNumGuildMembers() do
				if GetGuildRosterInfo(i) == name then
					return true
				end
			end
		end
	end

	EventFrame:RegisterEvent"PARTY_INVITE_REQUEST"
	function EventFrame:PARTY_INVITE_REQUEST(self, sender)
		if sender then
			print(format(L["Invite"], sender))
		end
		if IsFriend(sender) then
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if frame.which == "PARTY_INVITE" and frame:IsVisible() then
					frame.inviteAccepted = 1
					return StaticPopup_Hide"PARTY_INVITE"
				end
			end	
		end
	end
end

if CFG.ConfirmBoPorDE then
	EventFrame:RegisterEvent"CONFIRM_DISENCHANT_ROLL"
	function EventFrame:CONFIRM_DISENCHANT_ROLL(self, slot, rollType)
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame.which == "CONFIRM_LOOT_ROLL" and frame:IsVisible() then
				StaticPopup_OnClick(frame, 1)
			end
		end
	end

	EventFrame:RegisterEvent"CONFIRM_LOOT_ROLL"
	function EventFrame:CONFIRM_LOOT_ROLL(self, slot, rollType)
		for i = 1, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame.which == "CONFIRM_LOOT_ROLL" and frame:IsVisible() then
				StaticPopup_OnClick(frame, 1)
			end
		end
	end

	StaticPopupDialogs["LOOT_BIND"].OnCancel = function(self, slot)
		if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then
			ConfirmLootSlot(slot)
		end
	end

	EventFrame:RegisterEvent"LOOT_BIND_CONFIRM"
	function EventFrame:LOOT_BIND_CONFIRM(self, slot)
		StaticPopup_Hide"LOOT_BIND"
		ConfirmLootSlot(slot)
		--[[for i = 1, STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame.which == "LOOT_BIND" and frame:IsVisible() then
				StaticPopup_OnClick(frame, 1)
			end
		end]]
	end
end

if CFG.LeaveParty then
	local reallyLeaveParty = _G.LeaveParty
	StaticPopupDialogs["CONFIRM_LEAVE_PARTY"] = {
		text = PARTY_LEAVE.."?",
		button1 = YES,
		button2 = NO,
		hideOnEscape = 0,
		timeout = 0,
		OnAccept = reallyLeaveParty,
	}

	_G.LeaveParty = function()
		local _, instanceType = IsInInstance()
		if instanceType == "none" or instanceType == "arena" or instanceType == "pvp" then
			return reallyLeaveParty()
		end
		StaticPopup_Show"CONFIRM_LEAVE_PARTY"
	end
end