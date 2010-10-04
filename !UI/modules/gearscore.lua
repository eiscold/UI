if not Load"gearscore" then
	return
end

local ShowPlayer = 1
local ShowItem = 0

ItemTypes = {
	["INVTYPE_RELIC"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false},
	["INVTYPE_TRINKET"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 33, ["Enchantable"] = false },
	["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2.000, ["ItemSlot"] = 16, ["Enchantable"] = true },
	["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 16, ["Enchantable"] = true },
	["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
	["INVTYPE_RANGED"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = true },
	["INVTYPE_THROWN"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
	["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
	["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
	["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 36, ["Enchantable"] = true },
	["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = false },
	["INVTYPE_HEAD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 1, ["Enchantable"] = true },
	["INVTYPE_NECK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 2, ["Enchantable"] = false },
	["INVTYPE_SHOULDER"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 3, ["Enchantable"] = true },
	["INVTYPE_CHEST"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
	["INVTYPE_ROBE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
	["INVTYPE_WAIST"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 6, ["Enchantable"] = false },
	["INVTYPE_LEGS"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 7, ["Enchantable"] = true },
	["INVTYPE_FEET"] = { ["SlotMOD"] = 0.75, ["ItemSlot"] = 8, ["Enchantable"] = true },
	["INVTYPE_WRIST"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 9, ["Enchantable"] = true },
	["INVTYPE_HAND"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 10, ["Enchantable"] = true },
	["INVTYPE_FINGER"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 31, ["Enchantable"] = false },
	["INVTYPE_CLOAK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 15, ["Enchantable"] = true },
	["INVTYPE_BODY"] = { ["SlotMOD"] = 0, ["ItemSlot"] = 4, ["Enchantable"] = false },
}

Formula = {
	["A"] = {
		[4] = { ["A"] = 91.4500, ["B"] = 0.6500 },
		[3] = { ["A"] = 81.3750, ["B"] = 0.8125 },
		[2] = { ["A"] = 73.0000, ["B"] = 1.0000 }
	},
	["B"] = {
		[4] = { ["A"] = 26.0000, ["B"] = 1.2000 },
		[3] = { ["A"] = 0.7500, ["B"] = 1.8000 },
		[2] = { ["A"] = 8.0000, ["B"] = 2.0000 },
		[1] = { ["A"] = 0.0000, ["B"] = 2.2500 }
	}
}

function QualityColor(Score)
	return 1, 1, 1
--[[
	local QualityMax = 6500
	local QualityMin = 1

	if Score == 0 then
		return 0, 1, 0
	else
		return Score / (QualityMax - QualityMin), 1 - Score / (QualityMax - QualityMin), 0
	end
]]--
end

function OnEvent(self, event, prefix, msg, whisper, sender)
	if event == "PLAYER_REGEN_ENABLED" then
		InCombat = false
		return
	end
	if event == "PLAYER_REGEN_DISABLED" then
		InCombat = true
		return
	end
	if event == "PLAYER_EQUIPMENT_CHANGED" then
	    local MyGearScore = GetScore(UnitName"player", "player")
		local Red, Green, Blue = QualityColor(MyGearScore)
    	PersonalGearScore:SetText(MyGearScore)
		PersonalGearScore:SetTextColor(Red, Green, Blue, 1)
  	end
end

function GetScore(Name, Target)
	if UnitIsPlayer(Target) then
	    local _, Class = UnitClass(Target)
		local GearScore = 0
		local PVPScore = 0
		local ItemCount = 0
		local LevelTotal = 0
		local TitanGrip = 1
		local TempEquip = {}
		local TempPVPScore = 0

		if GetInventoryItemLink(Target, 16) and GetInventoryItemLink(Target, 17) then
      		local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(GetInventoryItemLink(Target, 16))
            if ItemEquipLoc == "INVTYPE_2HWEAPON" then
				TitanGrip = 0.5
			end
		end

		if GetInventoryItemLink(Target, 17) then
			local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(GetInventoryItemLink(Target, 17))
			if ItemEquipLoc == "INVTYPE_2HWEAPON" then
				TitanGrip = 0.5
			end
			TempScore, ItemLevel = GetItemScore(GetInventoryItemLink(Target, 17))
			if Class == "HUNTER" then
				TempScore = TempScore * 0.3164
			end
			GearScore = GearScore + TempScore * TitanGrip
			ItemCount = ItemCount + 1
			LevelTotal = LevelTotal + ItemLevel
		end
		
		for i = 1, 18 do
			if i ~= 4 and i ~= 17 then
        		ItemLink = GetInventoryItemLink(Target, i)
        		ItemLinkTable = {}
				if ItemLink then
        			local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(ItemLink)
     				TempScore = GetItemScore(ItemLink)
					if i == 16 and Class == "HUNTER" then
						TempScore = TempScore * 0.3164
					end
					if i == 18 and Class == "HUNTER" then
						TempScore = TempScore * 5.3224
					end
					if i == 16 then
						TempScore = TempScore * TitanGrip
					end
					GearScore = GearScore + TempScore
					ItemCount = ItemCount + 1
					LevelTotal = LevelTotal + ItemLevel
				end
			end;
		end
		if GearScore <= 0 and Name ~= UnitName"player" then
			GearScore = 0
			return 0, 0
		elseif Name == UnitName"player" and GearScore <= 0 then
		    GearScore = 0
		end
	if ItemCount == 0 then
		LevelTotal = 0
	end		    
	return floor(GearScore), floor(LevelTotal / ItemCount)
	end
end

function GetEnchantInfo(ItemLink, ItemEquipLoc)
	local found, _, ItemSubString = string.find(ItemLink, "^|c%x+|H(.+)|h%[.*%]")
	local ItemSubStringTable = {}

	for v in string.gmatch(ItemSubString, "[^:]+") do
		tinsert(ItemSubStringTable, v)
	end

	ItemSubString = ItemSubStringTable[2]..":"..ItemSubStringTable[3], ItemSubStringTable[2]
	local StringStart, StringEnd = string.find(ItemSubString, ":") 
	ItemSubString = string.sub(ItemSubString, StringStart + 1)

	if ItemSubString == "0" and ItemTypes[ItemEquipLoc]["Enchantable"] then
		 local percent = ( floor((-2 * ( ItemTypes[ItemEquipLoc]["SlotMOD"] )) * 100) / 100 )
		 return(1 + (percent / 100))
	else
		return 1
	end
	
end						

function GetItemScore(ItemLink)
	local QualityScale = 1
	local PVPScale = 1
	local PVPScore = 0
	local GearScore = 0

	if not ItemLink then
		return 0, 0
	end
	
	local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(ItemLink); local Table = {}; local Scale = 1.8618
 	if ItemRarity == 5 then
		QualityScale = 1.3
		ItemRarity = 4
	elseif ItemRarity == 1 then 
		QualityScale = 0.005
		ItemRarity = 2
	elseif ItemRarity == 0 then
		QualityScale = 0.005
		ItemRarity = 2 
	end
    if ItemRarity == 7 then
		ItemRarity = 3
		ItemLevel = 187.05
	end
    if ItemTypes[ItemEquipLoc] then
        if ItemLevel > 120 then
			Table = Formula["A"]
		else
			Table = Formula["B"]
		end
		if ItemRarity >= 2 and ItemRarity <= 4 then
            local Red, Green, Blue = QualityColor((floor(((ItemLevel - Table[ItemRarity].A) / Table[ItemRarity].B) * 1 * Scale)) * 11.25 )
            GearScore = floor(((ItemLevel - Table[ItemRarity].A) / Table[ItemRarity].B) * ItemTypes[ItemEquipLoc].SlotMOD * Scale * QualityScale)
			
			if ItemLevel == 187.05 then
				ItemLevel = 0
			end
			if GearScore < 0 then 
				GearScore = 0
				Red, Green, Blue = QualityColor(1)
			end
			if PVPScale == 0.75 then
				PVPScore = 1
				GearScore = GearScore * 1
			else
				PVPScore = GearScore * 0
			end
			local percent = (GetEnchantInfo(ItemLink, ItemEquipLoc) or 1)
			GearScore = floor(GearScore * percent)
			PVPScore = floor(PVPScore)
			return GearScore, ItemLevel, ItemTypes[ItemEquipLoc].ItemSlot, Red, Green, Blue, PVPScore, ItemEquipLoc, percent
		end
  	end
  	return -1, ItemLevel, 50, 1, 1, 1, PVPScore, ItemEquipLoc, 1
end

function HookSetUnit(arg1, arg2)
	if InCombat then
		return
	end

	local Name = GameTooltip:GetUnit()
	local MouseOverGearScore, MouseOverAverage = 0, 0
	if CanInspect"mouseover" and UnitName"mouseover" == Name and not InCombat then 
		NotifyInspect"mouseover"
		MouseOverGearScore, MouseOverAverage = GetScore(Name, "mouseover")
	end
 	if MouseOverGearScore and MouseOverGearScore > 0 and ShowPlayer == 1 then 
		local Red, Green, Blue = QualityColor(MouseOverGearScore)
		GameTooltip:AddLine("GS: "..MouseOverGearScore, Red, Green, Blue)
	end
end

function SetDetails(tooltip, Name)
	if not UnitName"mouseover" or UnitName"mouseover" ~= Name then
		return
	end
  	for i = 1, 18 do
  	    if not i == 4 then
    		local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(ItemLinkTable[i])
			
			print(tostring(ItemRarity))
			if ItemLink then
				local GearScore, ItemLevel, ItemType, Red, Green, Blue = GetItemScore(ItemLink)
				if GearScore and i ~= 4 then
	        		tooltip:AddDoubleLine("["..ItemName.."]", tostring(GearScore), 1, 1, 1, Red, Green, Blue)
        		end
			end
		end
	end
end

function HookSetItem()
	ItemName, ItemLink = GameTooltip:GetItem()
	HookItem(ItemName, ItemLink, GameTooltip)
end

function HookRefItem()
	ItemName, ItemLink = ItemRefTooltip:GetItem()
	HookItem(ItemName, ItemLink, ItemRefTooltip)
end

function HookCompareItem()
	ItemName, ItemLink = ShoppingTooltip1:GetItem()
	HookItem(ItemName, ItemLink, ShoppingTooltip1)
end

function HookCompareItem2()
	ItemName, ItemLink = ShoppingTooltip2:GetItem()
	HookItem(ItemName, ItemLink, ShoppingTooltip2)
end

function HookItem(ItemName, ItemLink, Tooltip)
	if InCombat then
		return
	end

	if not IsEquippableItem(ItemLink) then
		return
	end

	local ItemScore, ItemLevel, EquipLoc, Red, Green, Blue, PVPScore, ItemEquipLoc, enchantPercent = GetItemScore(ItemLink)
 	if ItemScore >= 0 then
		if ShowItem == 1 then
			Tooltip:AddLine("GS: "..ItemScore, Red, Green, Blue)
			if PCLASS == "HUNTER" then
				if ItemEquipLoc == "INVTYPE_RANGEDRIGHT" or ItemEquipLoc == "INVTYPE_RANGED" then
					Tooltip:AddLine("HunterScore: "..floor(ItemScore * 5.3224), Red, Green, Blue)
				end
				if ItemEquipLoc == "INVTYPE_2HWEAPON" or ItemEquipLoc == "INVTYPE_WEAPONMAINHAND" or ItemEquipLoc == "INVTYPE_WEAPONOFFHAND" or ItemEquipLoc == "INVTYPE_WEAPON" or ItemEquipLoc == "INVTYPE_HOLDABLE" then
					Tooltip:AddLine("HunterScore: "..floor(ItemScore * 0.3164), Red, Green, Blue)
				end
			end
		end
	end
end

function OnEnter(Name, ItemSlot, Argument)
	if UnitName"target" then
		NotifyInspect"target"
		LastNotified = UnitName"target"
	end
	local OriginalOnEnter = Original_SetInventoryItem(Name, ItemSlot, Argument)
	return OriginalOnEnter
end

function MyPaperDoll()
	if not InCombat then
		local MyGearScore = GetScore(UnitName"player", "player")
		local Red, Green, Blue = QualityColor(MyGearScore)
		PersonalGearScore:SetText(MyGearScore)
		PersonalGearScore:SetTextColor(Red, Green, Blue, 1)
	end
end

local GearScoreFrame = CreateFrame("Frame", "GearScore", UIParent)
GearScoreFrame:SetScript("OnEvent", OnEvent)
GearScoreFrame:RegisterEvent"PLAYER_EQUIPMENT_CHANGED"
GearScoreFrame:RegisterEvent"PLAYER_REGEN_ENABLED"
GearScoreFrame:RegisterEvent"PLAYER_REGEN_DISABLED"
GameTooltip:HookScript("OnTooltipSetUnit", HookSetUnit)
GameTooltip:HookScript("OnTooltipSetItem", HookSetItem)
ShoppingTooltip1:HookScript("OnTooltipSetItem", HookCompareItem)
ShoppingTooltip2:HookScript("OnTooltipSetItem", HookCompareItem2)
ItemRefTooltip:HookScript("OnTooltipSetItem", HookRefItem)

PaperDollFrame:HookScript("OnShow", MyPaperDoll)
PersonalGearScore = CreateFS(PaperDollFrame, 10)
PersonalGearScore:SetText"0"
PersonalGearScore:SetPoint("BOTTOMLEFT", PaperDollFrame, "TOPLEFT", 72, -265)
PersonalGearScore:Show()

Original_SetInventoryItem = GameTooltip.SetInventoryItem
GameTooltip.SetInventoryItem = OnEnter

