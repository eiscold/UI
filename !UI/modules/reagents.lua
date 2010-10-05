if not Load"reagents" then
	return
end

local ReagentBuyerFrame = CreateFrame"Frame"
ReagentBuyerFrame.countAnkh = 20
ReagentBuyerFrame.countArcanePowder = 100
ReagentBuyerFrame.countFlintweedSeed = 20
ReagentBuyerFrame.countSacredCandle = 20
ReagentBuyerFrame.countSymbolOfDivinity = 20
ReagentBuyerFrame.countSymbolOfKings = 20
ReagentBuyerFrame.countRuneOfPortals = 20
ReagentBuyerFrame.countRuneOfTeleportation = 20
ReagentBuyerFrame.countWildQuillvine = 20
ReagentBuyerFrame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

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
	while n > stack do
		VendorBuy(name, stack)
		n = n - stack
	end
	if n > 0 then
		VendorBuy(name, n)
	end
end

ReagentBuyerFrame:RegisterEvent"MERCHANT_SHOW"
function ReagentBuyerFrame:MERCHANT_SHOW(self)
	if UnitLevel"player" < 20 then
		return
	end 
	if PCLASS == "DRUID" then
		Buy(22148, ReagentBuyerFrame.countWildQuillvine)
		Buy(22147, ReagentBuyerFrame.countFlintweedSeed)
	elseif PCLASS == "PALADIN" then
		Buy(21177, ReagentBuyerFrame.countSymbolOfKings)
		Buy(17033, ReagentBuyerFrame.countSymbolOfDivinity)
	elseif PCLASS == "PRIEST" then
		Buy(17029, ReagentBuyerFrame.countSacredCandle)
	elseif PCLASS == "MAGE" then
		Buy(17020, ReagentBuyerFrame.countArcanePowder)
		Buy(17032, ReagentBuyerFrame.countRuneOfTeleportation)
		Buy(17031, ReagentBuyerFrame.countRuneOfPortals)
	elseif PCLASS == "SHAMAN" then
		Buy(17030, ReagentBuyerFrame.countAnkh)
	end
end