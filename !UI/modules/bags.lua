if not Load"bags" then
	return
end

local Spacing = 2
local Columns = 8
local NumBags = 1
local NumBankBags = 7
local BankColumns = 12

local bu, con, col, row
local firstopened, firstbankopened = 1, 1
local buttons, bankbuttons = {}, {}

local function GetNumBags()
	if GetContainerNumSlots(4) == 0 then
		if GetContainerNumSlots(3) == 0 then
			if GetContainerNumSlots(2) == 0 then
				if GetContainerNumSlots(1) == 0 then
					return 1
				else
					return 2
				end
			else
				return 3
			end
		else
			return 4
		end
	else
		return 5
	end
end

--[[
local buttonsConsumables, buttonsEquipment, buttonsQuest, buttonsTradeGoods, buttonsStuff = {}, {}, {}, {}, {}
local Weapon, Armor, Container, Consumables, Glyph, Trades, Projectile, Quiver, Recipe, Gem, Misc, Quest = GetAuctionItemClasses()

local function onlyConsumables(item)
	return item.type and item.type == Consumables
end

local function onlyQuest(item)
	return item.type and item.type == Quest
end

local function onlyTradeGoods(item)
	return item.type and item.type == Trades
end

local function onlyStuff(item)
	return item.type and (item.type == Armor or item.type == Weapon)
end

local function hideEmpty(item)
	return item.texture ~= nil
end -- for keyring, stuff, quest, consumable

local item2setEM = {}
local function cacheSetsEM()
    for k in pairs(item2setEM) do
		item2setEM[k] = nil
	end
    for k = 1, GetNumEquipmentSets() do
        local sName = GetEquipmentSetInfo(k)
        local set = GetEquipmentSetItemIDs(sName)
        for _, item in next, set do
            if item then
				item2setEM[item] = true
			end
        end
    end
    --cargBags:UpdateBags()
end
local EquipmentSetChangedFrame = CreateFrame"Frame"
EquipmentSetChangedFrame:RegisterEvent"PLAYER_LOGIN"
EquipmentSetChangedFrame:RegisterEvent"EQUIPMENT_SETS_CHANGED"
EquipmentSetChangedFrame:SetScript("OnEvent", cacheSetsEM)

local function filterItemSets(item)
    if not item.link then
		return false
	end
	local _, _, itemStr = string.find(item.link, "^|c%x+|H(.+)|h%[.*%]")
    local _, itemID = strsplit(":", itemStr)
    if item2setEM[tonumber(itemID)] then
		return true
	end    
    return false
end
]]

local function MoveButtons(table, frame, columns)
	col, row = 0, 0
	for i = 1, #table do
		bu = table[i]
		bu:ClearAllPoints()
		bu:SetPoint("TOPLEFT", frame, "TOPLEFT", col * (37 + Spacing), -1 * row * (37 + Spacing))
		bu.SetPoint = dummy
		if col > (columns - 2) then
			col = 0
			row = row + 1
		else
			col = col + 1
		end
		co = _G[bu:GetName().."Count"]
		co:ClearAllPoints()
		co:SetPoint("TOPLEFT", 1, -2)
	end

	frame:SetHeight((row + (col == 0 and 0 or 1)) * (37 + Spacing) + 16)
	frame:SetWidth(columns * 37 + Spacing * (columns - 1))
end

local holder = CreateFrame("Button", "BagsHolder", UIParent)
holder:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 50)
holder:SetFrameStrata"HIGH"
holder:Hide()
CreateBG(holder, .7)

--[[
local holderEquipment = CreateFrame("Button", "BagsHolderEquipment", UIParent)
holderEquipment:SetPoint("BOTTOM", holder, "TOP", 0, 10)
holderEquipment:SetFrameStrata"HIGH"
holderEquipment:Hide()
holderEquipment.title = CreateFS(holderEquipment, 12, "CENTER")
holderEquipment.title:SetPoint("BOTTOMRIGHT", holderEquipment, "BOTTOMRIGHT", 0, 2)
holderEquipment.title:SetText"Equipment"
CreateBG(holderEquipment):SetTexture(0, 0, 0, .7)

local holderStuff = CreateFrame("Button", "BagsHolderStuff", UIParent)
holderStuff:SetPoint("BOTTOM", holderEquipment, "TOP", 0, 10)
holderStuff:SetFrameStrata"HIGH"
holderStuff:Hide()
holderStuff.title = CreateFS(holderStuff, 12, "CENTER")
holderStuff.title:SetPoint("BOTTOMRIGHT", holderStuff, "BOTTOMRIGHT", 0, 2)
holderStuff.title:SetText"Stuff"
CreateBG(holderStuff):SetTexture(0, 0, 0, .7)

local holderConsumables = CreateFrame("Button", "BagsHolderConsumables", UIParent)
holderConsumables:SetPoint("BOTTOM", holderStuff, "TOP", 0, 10)
holderConsumables:SetFrameStrata"HIGH"
holderConsumables:Hide()
holderConsumables.title = CreateFS(holderStuff, 12, "CENTER")
holderConsumables.title:SetPoint("BOTTOMRIGHT", holderConsumables, "BOTTOMRIGHT", 0, 2)
holderConsumables.title:SetText"Consumables"
CreateBG(holderConsumables):SetTexture(0, 0, 0, .7)

local holderQuest = CreateFrame("Button", "BagsHolderQuest", UIParent)
holderQuest:SetPoint("BOTTOM", holderConsumables, "TOP", 0, 10)
holderQuest:SetFrameStrata"HIGH"
holderQuest:Hide()
holderQuest.title = CreateFS(holderStuff, 12, "CENTER")
holderQuest.title:SetPoint("BOTTOMRIGHT", holderQuest, "BOTTOMRIGHT", 0, 2)
holderQuest.title:SetText"Quest"
CreateBG(holderQuest):SetTexture(0, 0, 0, .7)

local holderTradeGoods = CreateFrame("Button", "BagsHolderTradeGoods", UIParent)
holderTradeGoods:SetPoint("BOTTOM", holderQuest, "TOP", 0, 10)
holderTradeGoods:SetFrameStrata"HIGH"
holderTradeGoods:Hide()
holderTradeGoods.title = CreateFS(holderStuff, 12, "CENTER")
holderTradeGoods.title:SetPoint("BOTTOMRIGHT", holderTradeGoods, "BOTTOMRIGHT", 0, 2)
holderTradeGoods.title:SetText"Trade Goods"
CreateBG(holderTradeGoods):SetTexture(0, 0, 0, .7)
]]

local function ReanchorButtons()
	if firstopened == 1 then
		NumBags = GetNumBags()
		for f = 1, NumBags do
			con = "ContainerFrame"..f
			_G[con]:EnableMouse(false)
			_G[con.."CloseButton"]:Hide()
			_G[con.."PortraitButton"]:EnableMouse(false)

			for i = 1, 7 do
				select(i, _G[con]:GetRegions()):SetAlpha(0)
			end

			for i = GetContainerNumSlots(f - 1), 1, -1  do
				bu = _G[con.."Item"..i]

				--[[
				local item = {}
				item.bagID = f - 1
				item.slotID = i

				item.clink = GetContainerItemLink(f - 1, i)
				if item.clink then
					item.texture, item.count, item.locked, item.quality, item.readable = GetContainerItemInfo(f - 1, i)
					item.cdStart, item.cdFinish, item.cdEnable = GetContainerItemCooldown(f - 1, i)
					item.isQuestItem, item.questID, item.questActive = GetContainerItemQuestInfo(f - 1, i)
					item.name, item.link, item.rarity, item.level, item.minLevel, item.type, item.subType, item.stackCount, item.equipLoc, item.texture = GetItemInfo(item.clink)
				end
				]]

				bu:SetFrameStrata"HIGH"
				--[[
				if filterItemSets(item) then
					tinsert(buttonsEquipment, bu)
				elseif onlyStuff(item) then
					tinsert(buttonsStuff, bu)
				elseif onlyConsumables(item) then
					tinsert(buttonsConsumables, bu)
				elseif onlyQuest(item) then
					tinsert(buttonsQuest, bu)
				elseif onlyTradeGoods(item) then
					tinsert(buttonsTradeGoods, bu)				
				else
				]]
					tinsert(buttons, bu)
				--end
			end
		end
		MoveButtons(buttons, holder, Columns)
		--[[
		MoveButtons(buttonsConsumables, holderConsumables, Columns)
		MoveButtons(buttonsEquipment, holderEquipment, Columns)
		MoveButtons(buttonsQuest, holderQuest, Columns)
		MoveButtons(buttonsTradeGoods, holderTradeGoods, Columns)
		MoveButtons(buttonsStuff, holderStuff, Columns)
		]]
		firstopened = 0
	end
	holder:Show()
	--[[
	holderConsumables:Show()
	holderEquipment:Show()
	holderQuest:Show()
	holderTradeGoods:Show()
	holderStuff:Show()
	]]
end

local money = _G["ContainerFrame1MoneyFrame"]
money:SetFrameStrata"DIALOG"
money:SetParent(holder)
money:ClearAllPoints()
money:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 12, 2)

local bankholder = CreateFrame("Button", "BagsBankHolder", UIParent)
bankholder:SetFrameStrata"HIGH"
bankholder:Hide()

CreateBG(bankholder, .7)

local function ReanchorBankButtons()
	if firstbankopened == 1 then
		for f = 1, 28 do
			bu = _G["BankFrameItem"..f]
			bu:SetFrameStrata"HIGH"
			tinsert(bankbuttons, bu)
		end
		_G["BankFrame"]:EnableMouse(false)
		_G["BankCloseButton"]:Hide()

		for f = 1, 5 do
			select(f, _G["BankFrame"]:GetRegions()):SetAlpha(0)
		end

		for f = NumBags + 1, NumBags + NumBankBags, 1 do
			con = "ContainerFrame"..f
			_G[con]:EnableMouse(false)
			_G[con.."CloseButton"]:Hide()
			_G[con.."PortraitButton"]:EnableMouse(false)

			for i = 1, 7 do
				select(i, _G[con]:GetRegions()):SetAlpha(0)
			end

			for i = GetContainerNumSlots(f-1), 1, -1  do
				bu = _G[con.."Item"..i]
				bu:SetFrameStrata"HIGH"
				tinsert(bankbuttons, bu)
			end
		end
		MoveButtons(bankbuttons, bankholder, BankColumns)
		bankholder:SetPoint("BOTTOMRIGHT", "BagsHolder", "BOTTOMLEFT", -10 , 0)
		firstbankopened = 0
	end
	bankholder:Show()
end

local money = _G["BankFrameMoneyFrame"]
money:SetFrameStrata"DIALOG"
money:ClearAllPoints()
money:SetPoint("BOTTOMRIGHT", bankholder, "BOTTOMRIGHT", 12, 2)

_G["BankFramePurchaseInfo"]:Hide()
_G["BankFramePurchaseInfo"].Show = dummy

local BankBagButtons = {
	BankFrameBag1, 
	BankFrameBag2, 
	BankFrameBag3, 
	BankFrameBag4, 
	BankFrameBag5, 
	BankFrameBag6, 
	BankFrameBag7,
}

local BagButtons = {
	CharacterBag0Slot, 
	CharacterBag1Slot, 
	CharacterBag2Slot, 
	CharacterBag3Slot, 
}

for f = 1, 7 do
	_G["BankFrameBag"..f]:SetParent(bankholder)
	_G["BankFrameBag"..f]:ClearAllPoints()
	_G["BankFrameBag"..f]:SetScale(0.75)

	if f == 1 then
		_G["BankFrameBag"..f]:SetPoint("TOPRIGHT", bankholder, "BOTTOMRIGHT", 3, -5)
	else
		_G["BankFrameBag"..f]:SetPoint("RIGHT", _G["BankFrameBag"..f - 1], "LEFT", -5, 0)
	end
	
	_G["BankFrameBag"..f]:SetAlpha(0)
	_G["BankFrameBag"..f]:HookScript("OnEnter", function(self)
		for _, g in pairs(BankBagButtons) do
			g:SetAlpha(1)
		end
	end)
	_G["BankFrameBag"..f]:HookScript("OnLeave", function(self)
		for _, g in pairs(BankBagButtons) do
			g:SetAlpha(0)
		end
	end)
end

for i = 0, 3 do
	_G["CharacterBag"..i.."Slot"]:SetParent(holder)
	_G["CharacterBag"..i.."Slot"]:ClearAllPoints()
	_G["CharacterBag"..i.."Slot"]:SetScale(1)

	if i == 0 then
		_G["CharacterBag"..i.."Slot"]:SetPoint("TOPRIGHT", holder, "BOTTOMRIGHT", 3, -5)
	else
		_G["CharacterBag"..i.."Slot"]:SetPoint("RIGHT", _G["CharacterBag"..(i - 1).."Slot"], "LEFT", -5, 0)
	end

	_G["CharacterBag"..i.."Slot"]:SetAlpha(0)
	_G["CharacterBag"..i.."Slot"]:HookScript("OnEnter", function(self)
		for _, g in pairs(BagButtons) do
			g:SetAlpha(1)
		end
	 end)
	_G["CharacterBag"..i.."Slot"]:HookScript("OnLeave", function(self)
		for _, g in pairs(BagButtons) do
			g:SetAlpha(0)
		end
	end)
end

tinsert(UISpecialFrames, bankholder)
tinsert(UISpecialFrames, holder)
--[[
tinsert(UISpecialFrames, holderConsumables)
tinsert(UISpecialFrames, holderEquipment)
tinsert(UISpecialFrames, holderQuest)
tinsert(UISpecialFrames, holderTradeGoods)
tinsert(UISpecialFrames, holderStuff)
]]

local function CloseBags()
	bankholder:Hide()
	holder:Hide()
	--[[
	holderConsumables:Hide()
	holderEquipment:Hide()
	holderQuest:Hide()
	holderTradeGoods:Hide()
	holderStuff:Hide()
	]]
	for i = 0, 11 do
		CloseBag(i)
	end
end

local function OpenBags()
	for i = 0, 11 do
		OpenBag(i)
	end
end

local function ToggleBags()
	if IsBagOpen(0) then
		CloseBankFrame()
		CloseBags()
	else
		OpenBags()
	end
end

hooksecurefunc(_G["ContainerFrame"..NumBags], "Show", ReanchorButtons)
hooksecurefunc(_G["ContainerFrame"..NumBags], "Hide", CloseBags)
hooksecurefunc(BankFrame, "Show", function()
	OpenBags()
	ReanchorBankButtons()
end)
hooksecurefunc(BankFrame, "Hide", CloseBags)

ToggleBackpack = ToggleBags
OpenAllBags = ToggleBags
OpenBackpack = OpenBags
CloseBackpack = CloseBags
CloseAllBags = CloseBags

local oldNumBags = GetNumBags()
holder:RegisterEvent"PLAYER_ENTERING_WORLD"
holder:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent"PLAYER_ENTERING_WORLD"
		numBags = GetNumBags()
		self:RegisterEvent"BAG_UPDATE"
	end
	if numBags ~= oldNumBags then
		oldNumBags = numBags
		ReanchorButtons()
		CloseBags()
	end
end)