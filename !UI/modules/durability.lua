if not Load"durability" then
	return
end

local CharDurabilityFrame = CreateFrame("Frame", nil, CharacterFrame)

CharDurabilityFrame.SlotIDs = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand", "Ranged"}) do
	CharDurabilityFrame.SlotIDs[slot] = GetInventorySlotInfo(slot.."Slot")
end

local function RYGColorGradient(perc)
	local relperc = perc * 2 % 1
	if perc <= 0 then 
		return 1, 0, 0
	elseif perc < .5 then
		return 1, relperc, 0
	elseif perc == .5 then
		return 1, 1, 0
	elseif perc < 1 then
		return 1 - relperc, 1, 0
	else
		return 0, 1, 0
	end
end

local fontstrings = setmetatable({}, {
	__index = function(t, i)
		local gslot = _G["Character"..i.."Slot"]
		assert(gslot, "Character"..i.."Slot does not exist")
		local fstr = CreateFS(gslot, 9)
		fstr:SetPoint("BOTTOM", gslot, "BOTTOM", 0, 0)
		t[i] = fstr
		return fstr
	end,
})

CharDurabilityFrame:SetScript("OnEvent", function(self, event, ...)
	local min = 1
	for slot, id in pairs(CharDurabilityFrame.SlotIDs) do
		local v1, v2 = GetInventoryItemDurability(id)
		if v1 and v2 and v2 ~= 0 then
			min = math.min(v1 / v2, min)
			local str = fontstrings[slot]
			str:SetTextColor(RYGColorGradient(v1 / v2))
			str:SetText(string.format("%d%%", v1 / v2 * 100))
		else
			local str = rawget(fontstrings, slot)
			if str then
				str:SetText(nil)
			end
		end
	end
	local r, g, b = RYGColorGradient(min)
end)

CharDurabilityFrame:RegisterEvent"ADDON_LOADED"
CharDurabilityFrame:RegisterEvent"UPDATE_INVENTORY_DURABILITY"

DurabilityFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -10, 0)