if not Load"grouploot" then
	return
end

UIParent:UnregisterEvent"START_LOOT_ROLL"
UIParent:UnregisterEvent"CANCEL_LOOT_ROLL"

local GroupLootFrame = CreateFrame("Frame", "GroupLootFrame", UIParent)
GroupLootFrame:SetPoint("RIGHT", -50, 0)
GroupLootFrame:SetWidth(200)
GroupLootFrame:SetHeight(24)
GroupLootFrame.iconSize = 32
GroupLootFrame.list = {}
GroupLootFrame.frames = {}
GroupLootFrame.strings = {
	[(LOOT_ROLL_PASSED_AUTO):gsub("%%1$s", "(.+)"):gsub("%%2$s", "(.+)")] = 0,
	[(LOOT_ROLL_PASSED_AUTO_FEMALE):gsub("%%1$s", "(.+)"):gsub("%%2$s", "(.+)")] = 0,
	[(LOOT_ROLL_PASSED):gsub("%%s", "(.+)")] = 0,
	[(LOOT_ROLL_GREED):gsub("%%s", "(.+)")] = 2,
	[(LOOT_ROLL_NEED):gsub("%%s", "(.+)")] = 1,
	[(LOOT_ROLL_DISENCHANT):gsub("%%s", "(.+)")] = 3
}

local function FrameOnEvent(self, event, rollId)
	if self.rollId and rollId == self.rollId then
		for index, value in next, GroupLootFrame.list do
			if self.rollId == value.rollId then
				tremove(GroupLootFrame.list, index)
				break
			end
		end
		StaticPopup_Hide("CONFIRM_LOOT_ROLL", self.rollId)
		self.rollId = nil
		UpdateGroupLoot()
	end
end

local function FrameOnClick(self)
	HandleModifiedItemClick(self.rollLink)
end

local function FrameOnEnter(self)
	if not self.rollId then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetLootRollItem(self.rollId)
	if IsShiftKeyDown() then
		GameTooltip_ShowCompareItem()
	end
	CursorUpdate(self)
end

local function FrameOnLeave(self)
	GameTooltip:Hide()
	ResetCursor()
end

local function ButtonOnClick(self, button)
	RollOnLoot(self:GetParent().rollId, self.type)
end

local function SortFunc(a, b)
	return a.rollId < b.rollId
end

function UpdateGroupLoot()
	sort(GroupLootFrame.list, SortFunc)
	for index, value in next, GroupLootFrame.frames do
		value:Hide()
		for i = 0, #value.button do
			value.button[i].text:SetText""
		end
	end
	local frame
	for index, value in next, GroupLootFrame.list do
		frame = GroupLootFrame.frames[index]
		if not frame then
			frame = CreateFrame("Frame", "GroupLootFrame"..index, UIParent)
			frame:EnableMouse(true)
			frame:SetWidth(220)
			frame:SetHeight(24)
			frame:SetPoint("TOP", GroupLootFrame, 0, -((index - 1) * (GroupLootFrame.iconSize + 1)))
			frame:RegisterEvent"CANCEL_LOOT_ROLL"
			frame:SetScript("OnEvent", FrameOnEvent)
			frame:SetScript("OnMouseUp", FrameOnClick)
			frame:SetScript("OnLeave", FrameOnLeave)
			frame:SetScript("OnEnter", FrameOnEnter)
			CreateBG(frame, .7)
			frame.button = {}
			frame.button[0] = CreateFrame("Button", nil, frame)
			frame.button[0].type = 0
			frame.button[0].roll = "pass"
			frame.button[0]:SetWidth(28)
			frame.button[0]:SetHeight(28)
			frame.button[0]:SetNormalTexture"Interface\\Buttons\\UI-GroupLoot-Pass-Up"
			frame.button[0]:SetHighlightTexture"Interface\\Buttons\\UI-GroupLoot-Pass-Down"
			frame.button[0]:SetPoint("RIGHT", 0, 1)
			frame.button[0].text = CreateFS(frame.button[0], 12, "CENTER")
			frame.button[0].text:SetPoint("CENTER", 0, 2)
			frame.button[0].text:SetText""
			frame.button[0]:SetScript("OnClick", ButtonOnClick)
			frame.button[2] = CreateFrame("Button", nil, frame)
			frame.button[2].type = 2
			frame.button[2].roll = "greed"
			frame.button[2]:SetWidth(28)
			frame.button[2]:SetHeight(28)
			frame.button[2]:SetNormalTexture"Interface\\Buttons\\UI-GroupLoot-Coin-Up"
			frame.button[2]:SetPushedTexture"Interface\\Buttons\\UI-GroupLoot-Coin-Down"
			frame.button[2]:SetHighlightTexture"Interface\\Buttons\\UI-GroupLoot-Coin-Highlight"
			frame.button[2]:SetPoint("RIGHT", frame.button[0], "LEFT", -1, -4)
			frame.button[2].text = CreateFS(frame.button[2], 12, "CENTER")
			frame.button[2].text:SetPoint("CENTER", 0, 4)
			frame.button[2].text:SetText""
			frame.button[2]:SetScript("OnClick", ButtonOnClick)
			frame.button[3] = CreateFrame("Button", nil, frame)
			frame.button[3].type = 3
			frame.button[3].roll = "disenchant"
			frame.button[3]:SetWidth(28)
			frame.button[3]:SetHeight(28)
			frame.button[3]:SetNormalTexture"Interface\\Buttons\\UI-GroupLoot-DE-Up"
			frame.button[3]:SetPushedTexture"Interface\\Buttons\\UI-GroupLoot-DE-Down"
			frame.button[3]:SetHighlightTexture"Interface\\Buttons\\UI-GroupLoot-DE-Highlight"
			frame.button[3]:SetPoint("RIGHT", frame.button[2], "LEFT", -1, 2)
			frame.button[3].text = CreateFS(frame.button[3], 12, "CENTER")
			frame.button[3].text:SetPoint("CENTER", 0, 2)
			frame.button[3].text:SetText""
			frame.button[3]:SetScript("OnClick", ButtonOnClick)
			frame.button[1] = CreateFrame("Button", nil, frame)
			frame.button[1].type = 1
			frame.button[1].roll = "need"
			frame.button[1]:SetWidth(28)
			frame.button[1]:SetHeight(28)
			frame.button[1]:SetNormalTexture"Interface\\Buttons\\UI-GroupLoot-Dice-Up"
			frame.button[1]:SetPushedTexture"Interface\\Buttons\\UI-GroupLoot-Dice-Down"
			frame.button[1]:SetHighlightTexture"Interface\\Buttons\\UI-GroupLoot-Dice-Highlight"
			frame.button[1]:SetPoint("RIGHT", frame.button[3], "LEFT", -1, 0)
			frame.button[1].text = CreateFS(frame.button[1], 12, "CENTER")
			frame.button[1].text:SetPoint("CENTER", 0, 2)
			frame.button[1].text:SetText""
			frame.button[1]:SetScript("OnClick", ButtonOnClick)
			frame.text = CreateFS(frame, 12, "LEFT")
			frame.text:SetPoint"LEFT"
			frame.text:SetPoint("RIGHT", frame.button[1], "LEFT")
			local iconFrame = CreateFrame("Frame", nil, frame)
			iconFrame:SetHeight(GroupLootFrame.iconSize)
			iconFrame:SetWidth(GroupLootFrame.iconSize)
			iconFrame:ClearAllPoints()
			iconFrame:SetPoint("RIGHT", frame, "LEFT", -3, 0)
			frame.icon = iconFrame:CreateTexture(nil, "BACKGROUND")
			frame.icon:SetTexCoord(.1, .9, .1, .9)
			frame.icon:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", 2, -2)
			frame.icon:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", -2, 2)
			frame.overlay = CreateFrame("Frame", nil, iconFrame)
			frame.overlay:SetPoint("TOPLEFT", -3, 3)
			frame.overlay:SetPoint("BOTTOMRIGHT", 3, -3)
			frame.overlay:SetFrameStrata"BACKGROUND"
			frame.overlay:SetBackdrop(BACKDROP)
			frame.overlay:SetBackdropBorderColor(0, 0, 0)
			tinsert(GroupLootFrame.frames, frame)
		end
		local texture, name, count, quality, bindOnPickUp, Needable, Greedable, Disenchantable = GetLootRollItemInfo(value.rollId)
		if Disenchantable then
			frame.button[3]:Enable()
		else
			frame.button[3]:Disable()
		end
		if Needable then
			frame.button[1]:Enable()
		else
			frame.button[1]:Disable()
		end
		if Greedable then
			frame.button[2]:Enable()
		else
			frame.button[2]:Disable()
		end
		SetDesaturation(frame.button[3]:GetNormalTexture(), not Disenchantable)
		SetDesaturation(frame.button[1]:GetNormalTexture(), not Needable)
		SetDesaturation(frame.button[2]:GetNormalTexture(), not Greedable)
		frame.text:SetText(ITEM_QUALITY_COLORS[quality].hex..name)
		frame.icon:SetTexture(texture) 
		frame.rollId = value.rollId
		frame.rollLink = GetLootRollItemLink(value.rollId)
		frame:Show()
	end
end

GroupLootFrame:RegisterEvent"CHAT_MSG_LOOT"
GroupLootFrame:RegisterEvent"START_LOOT_ROLL"
GroupLootFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_LOOT" then
		local msg = ...
		for string, type in pairs(GroupLootFrame.strings) do
			local _, _, player, item = string.find(msg, string)
			if player and item then
				for _, frame in ipairs(GroupLootFrame.frames) do
					if frame.rollId and frame.rollLink == item then
						frame.button[type].count = (frame.button[type].count % 5 or 0) + 1
						frame.button[type].text:SetText(frame.button[type].count)
						return
					end
				end
			end
		end
	elseif event == "START_LOOT_ROLL" then
		local rollId, rollTime = ...
		local _, _, _, quality, bop, _, _, canDE = GetLootRollItemInfo(rollId)
		if quality == 2 and not bop and PLEVEL == MAX_PLAYER_LEVEL+1 then
			RollOnLoot(rollId, canDE and 3 or 2)
		else
			tinsert(GroupLootFrame.list, {rollId = rollId})
			UpdateGroupLoot()
		end
	end
end)