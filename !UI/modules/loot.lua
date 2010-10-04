if not Load"loot" then
	return
end

local iconsize = 32
local width = 200
local sq, ss, sn

local Loot = CreateFrame("Button", "Loot", UIParent)
Loot:SetFrameStrata"HIGH"
Loot:SetWidth(width)
Loot:SetHeight(64)

Loot.slots = {}

local OnEnter = function(self)
	local slot = self:GetID()
	if LootSlotIsItem(slot) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slot)
		CursorUpdate(self)
	end
end

local OnLeave = function(self)
	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		LootSlot(ss)
	end
end

local createSlot = function(id)
	local frame = CreateFrame("Button", "lootSlot"..id, Loot)
	frame:SetPoint("TOP", Loot, 0, -((id-1)*(iconsize+1)))
	frame:SetPoint"RIGHT"
	frame:SetPoint"LEFT"
	frame:SetHeight(24)
	frame:SetID(id)
	Loot.slots[id] = frame

	CreateBG(frame)

	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(iconsize)
	iconFrame:SetWidth(iconsize)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("RIGHT", frame, "LEFT", -1, 0)

	local icon = iconFrame:CreateTexture(nil, "BACKGROUND")
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", -2, 2)
	frame.icon = icon

	local overlay = CreateFrame("Frame", nil, iconFrame)
	overlay:SetPoint("TOPLEFT", -3, 3)
	overlay:SetPoint("BOTTOMRIGHT", 3, -3)
	overlay:SetFrameStrata"BACKGROUND"
	overlay:SetBackdrop(BACKDROP)
	overlay:SetBackdropBorderColor(0, 0, 0)
	frame.overlay = overlay

	local count = CreateFS(iconFrame, 12, "RIGHT")
	count:SetPoint("BOTTOMRIGHT", iconFrame, -1, 2)
	count:SetText(1)
	frame.count = count

	local name = CreateFS(frame, 12, "LEFT")
	name:SetPoint("RIGHT", frame)
	name:SetPoint("LEFT", icon, "RIGHT", 8, 0)
	name:SetNonSpaceWrap(true)
	frame.name = name

	return frame
end

Loot:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)

Loot.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in next, self.slots do
		v:Hide()
	end
end

Loot.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if not self:IsShown() then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	local x, y = GetCursorPosition()
	x = x / self:GetEffectiveScale()
	y = y / self:GetEffectiveScale()

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x-40, y+20)
	self:Raise()

	if items > 0 then
		for i = 1, items do
			local slot = Loot.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality].hex

			if LootSlotIsCoin(i) then
				item = item:gsub("\n", ", ")
			end

			if quantity > 1 then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end

			slot.quality = quality
			slot.name:SetText(color..item)
			slot.icon:SetTexture(texture)

			slot:Enable()
			slot:Show()
		end
	else
		local slot = Loot.slots[1] or createSlot(1)

		slot.name:SetText""
		slot.icon:SetTexture"Interface\\Icons\\INV_Misc_Herb_AncientLichen"

		items = 1

		slot.count:Hide()
		slot:Disable()
		slot:Show()
	end

	self:SetHeight(math.max((items*(iconsize+10))), 20)
end

Loot.LOOT_SLOT_CLEARED = function(self, event, slot)
	if not self:IsShown() then
		return
	end
	Loot.slots[slot]:Hide()
end

Loot.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(1, nil, GroupLootDropDown, Loot.slots[ss], 0, 0)
end

Loot.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

Loot:SetScript("OnEvent", function(self, event, arg1) self[event](self, event, arg1) end)

Loot:RegisterEvent"LOOT_OPENED"
Loot:RegisterEvent"LOOT_SLOT_CLEARED"
Loot:RegisterEvent"LOOT_CLOSED"
Loot:RegisterEvent"OPEN_MASTER_LOOT_LIST"
Loot:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
Loot:Hide()

LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "Loot")

function _G.GroupLootDropDown_GiveLoot(self)
	if sq >= MASTER_LOOT_THREHOLD then
		local dialog = StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[sq].hex..sn..FONT_COLOR_CODE_CLOSE, self:GetText())
		if dialog then
			dialog.data = self.value
		end
	else
		GiveMasterLoot(ss, self.value)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self, data)
	GiveMasterLoot(ss, data)
end

LOOT_ITEM = LOOT.." %s => %s"
LOOT_ITEM_MULTIPLE = LOOT.." %s => %sx%d"
LOOT_ITEM_SELF = LOOT.." %s"
LOOT_ITEM_SELF_MULTIPLE = LOOT.." %sx%d"
LOOT_ITEM_PUSHED_SELF = LOOT.." %s"
LOOT_ITEM_PUSHED_SELF_MULTIPLE = LOOT.." %sx%d"
LOOT_MONEY = "%s"
YOU_LOOT_MONEY = "%s"
LOOT_MONEY_SPLIT = "%s"
LOOT_ROLL_ALL_PASSED = L["LootRollAllPassed"]
LOOT_ROLL_PASSED_AUTO = L["LootRollPassedAuto"]
LOOT_ROLL_PASSED_SELF_AUTO = L["LootRollPassedSelfAuto"]
LOOT_ROLL_WON = "%s "..L["wins"].." %s"
LOOT_ROLL_YOU_WON = YOU.." "..L["won"].." %s"
LOOT_ROLL_WON_NO_SPAM_DE = "%1$s "..L["wins"].." %3$s "..GetMyTextColor().."("..L["Disenchant"].." %2$d)|r"
LOOT_ROLL_WON_NO_SPAM_NEED = "%1$s "..L["wins"].." %3$s "..GetMyTextColor().."("..NEED.." %2$d)|r"
LOOT_ROLL_WON_NO_SPAM_GREED = "%1$s "..L["wins"].." %3$s "..GetMyTextColor().."("..GREED.." %2$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_DE = YOU.." "..L["won"].." %2$s "..GetMyTextColor().."("..L["Disenchant"].." %1$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_NEED = YOU.." "..L["won"].." %2$s "..GetMyTextColor().."("..NEED.." %1$d)|r"
LOOT_ROLL_YOU_WON_NO_SPAM_GREED = YOU.." "..L["won"].." %2$s "..GetMyTextColor().."("..GREED.." %1$d)|r"