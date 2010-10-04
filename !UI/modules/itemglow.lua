if not Load"itemglow" then
	return
end

local function UpdateGlow(button, id)
	local quality, texture
	if id then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end
	local glow = button.glow
	if not glow then
		glow = button:CreateTexture(nil, "OVERLAY")
		glow:SetTexture"Interface\\Buttons\\UI-ActionButton-Border"
		glow:SetBlendMode"ADD"
		glow:SetPoint"CENTER"
		glow:SetHeight(70)
		glow:SetWidth(70)
		glow:SetAlpha(.5)
		button.glow = glow
	end

	if texture then
		local r, g, b = GetItemQualityColor(quality)
		if r == 1 then
			r, g, b = 0, 0, 0
		end
		glow:SetVertexColor(r, g, b)
		glow:Show()
	else
		glow:Hide()
	end
end

hooksecurefunc("BankFrameItemButton_Update", function(self)
	UpdateGlow(self, GetInventoryItemID("player", self:GetInventorySlot()))
end)

hooksecurefunc("ContainerFrame_Update", function(self)
	local name = self:GetName()
	local id = self:GetID()
	for i = 1, self.size do
		local button = _G[name.."Item"..i]
		local itemID = GetContainerItemID(id, button:GetID())
		UpdateGlow(button, itemID)
	end
end)

local itemsChar = {
[0] = "Ammo",
 "Head 1",
 "Neck",
 "Shoulder 2",
 "Shirt",
 "Chest 3",
 "Waist 4",
 "Legs 5",
 "Feet 6",
 "Wrist 7",
 "Hands 8",
 "Finger0",
 "Finger1",
 "Trinket0",
 "Trinket1",
 "Back",
 "MainHand 9",
 "SecondaryHand 10",
 "Ranged 11",
 "Tabard",
}
local itemsInspect = {
"Head",
 "Neck",
 "Shoulder",
 "Shirt",
 "Chest",
 "Waist",
 "Legs",
 "Feet",
 "Wrist",
 "Hands",
 "Finger0",
 "Finger1",
 "Trinket0",
 "Trinket1",
 "Back",
 "MainHand",
 "SecondaryHand",
 "Ranged",
 "Tabard",
}
local function updateCharFrame()
	if not CharacterFrame:IsShown() then
		return
	end
	local key, slot
	for i, value in pairs(itemsChar) do
		key, index = string.split(" ", value)
		slot = _G["Character"..key.."Slot"]
		UpdateGlow(slot, GetInventoryItemID("player", i))
	end
end


local function updateInspectFrame()
	if not InspectFrame:IsShown() then
		return
	end
	local unit = InspectFrame.unit
	for i, key in pairs(itemsInspect) do
		local link = GetInventoryItemLink(unit, i)
		local slot = _G["Inspect"..key.."Slot"]
		if slot and link then
			UpdateGlow(slot, link)
		end
	end
end

local CharItemGlow = CreateFrame"Frame"
CharItemGlow:SetParent"CharacterFrame"
CharItemGlow:SetScript("OnShow", updateCharFrame)
CharItemGlow:SetScript("OnEvent", function(self, event, unit)
	if unit == "player" then
		updateCharFrame()
	end
end)
CharItemGlow:RegisterEvent"UNIT_INVENTORY_CHANGED"

local InspectItemGlow = CreateFrame"Frame"
InspectItemGlow:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)

InspectItemGlow.PLAYER_TARGET_CHANGED = updateInspectFrame
InspectItemGlow["ADDON_LOADED"] = function(addon)
	if addon == "Blizzard_InspectUI" then
		InspectItemGlow:SetScript("OnShow", updateInspectFrame)
		InspectItemGlow:SetParent"InspectFrame"
		InspectItemGlow:RegisterEvent"PLAYER_TARGET_CHANGED"
		InspectItemGlow:UnregisterEvent"ADDON_LOADED"
	end
end

if IsAddOnLoaded"Blizzard_InspectUI" then
	InspectItemGlow:SetScript("OnShow", updateInspectFrame)
	InspectItemGlow:SetParent"InspectFrame"
else
	InspectItemGlow:RegisterEvent"ADDON_LOADED"
end