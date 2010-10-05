if not Load"itemglow" then
	return
end

local CharItemGlow = CreateFrame"Frame"
CharItemGlow.items = {
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
CharItemGlow:SetParent"CharacterFrame"
CharItemGlow:SetScript("OnShow", updateCharFrame)
CharItemGlow:SetScript("OnEvent", function(self, event, unit)
	if unit == "player" then
		updateCharFrame()
	end
end)
CharItemGlow:RegisterEvent"UNIT_INVENTORY_CHANGED"

local InspectItemGlow = CreateFrame"Frame"
InspectItemGlow.items = {
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
InspectItemGlow:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)
InspectItemGlow:SetScript("OnShow", updateInspectFrame)
InspectItemGlow:RegisterEvent"PLAYER_TARGET_CHANGED"

function InspectItemGlow:PLAYER_TARGET_CHANGED()
	updateInspectFrame()
end
InspectItemGlow["ADDON_LOADED"] = function(addon)
	if addon == "Blizzard_InspectUI" then
		InspectItemGlow:SetParent"InspectFrame"
		InspectItemGlow:UnregisterEvent"ADDON_LOADED"
	end
end

local function UpdateGlow(button, id)
	local quality, texture
	if id then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end
	if not button.glow then
		button.glow = button:CreateTexture(nil, "OVERLAY")
		button.glow:SetTexture"Interface\\Buttons\\UI-ActionButton-Border"
		button.glow:SetBlendMode"ADD"
		button.glow:SetPoint"CENTER"
		button.glow:SetHeight(70)
		button.glow:SetWidth(70)
		button.glow:SetAlpha(.5)
	end

	if texture and quality then
		local r, g, b = GetItemQualityColor(quality)
		if r == 1 then
			r, g, b = 0, 0, 0
		end
		button.glow:SetVertexColor(r, g, b)
		button.glow:Show()
	else
		button.glow:Hide()
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

function updateCharFrame()
	if not CharacterFrame:IsShown() then
		return
	end
	for i, value in pairs(CharItemGlow.items) do
		local key, index = string.split(" ", value)
		local slot = _G["Character"..key.."Slot"]
		UpdateGlow(slot, GetInventoryItemID("player", i))
	end
end

function updateInspectFrame()
	if not InspectFrame:IsShown() then
		return
	end
	for i, key in pairs(InspectItemGlow.items) do
		local link = GetInventoryItemLink(InspectFrame.unit, i)
		local slot = _G["Inspect"..key.."Slot"]
		UpdateGlow(slot, link)
	end
end

if IsAddOnLoaded"Blizzard_InspectUI" then
	InspectItemGlow:SetScript("OnShow", updateInspectFrame)
	InspectItemGlow:SetParent"InspectFrame"
else
	InspectItemGlow:RegisterEvent"ADDON_LOADED"
end