if not Load"reagents" then
	return
end

local function VendorBuy(name, count)
	for i = 1, 99 do 
		if name == GetMerchantItemInfo(i) then 
			BuyMerchantItem(i, count)
		end
	end
end
			
local function Buy(id, count)
	name, _, _, _, _, _, _, stack = GetItemInfo(id)
	local m = GetItemCount(id)
	local n = count - m
	while (n > stack) do
		VendorBuy(name, stack)
		n = n - stack
	end
	if n > 0 then
		VendorBuy(name, n)
	end
end

local countAnkh = 20
local countArcanePowder = 100
local countFlintweedSeed = 20
local countSacredCandle = 20
local countSymbolOfDivinity = 20
local countSymbolOfKings = 20
local countRuneOfPortals = 20
local countRuneOfTeleportation = 20
local countWildQuillvine = 20

local ReagentBuyerFrame = CreateFrame"Frame"
ReagentBuyerFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

ReagentBuyerFrame:RegisterEvent"MERCHANT_SHOW"
function ReagentBuyerFrame:MERCHANT_SHOW(self)
	if UnitLevel"player" < 20 then
		return
	end 
	if PCLASS == "DRUID" then
		Buy(22148, countWildQuillvine)
		Buy(22147, countFlintweedSeed)
	elseif PCLASS == "PALADIN" then
		Buy(21177, countSymbolOfKings)
		Buy(17033, countSymbolOfDivinity)
	elseif PCLASS == "PRIEST" then
		Buy(17029, countSacredCandle)
	elseif PCLASS == "MAGE" then
		Buy(17020, countArcanePowder)
		Buy(17032, countRuneOfTeleportation)
		Buy(17031, countRuneOfPortals)
	elseif PCLASS == "SHAMAN" then
		Buy(17030, countAnkh)
	end
end