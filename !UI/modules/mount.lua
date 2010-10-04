if not Load"mount" then
	function Mount(_, _) end
	return
end

function Mount(groundmount, flyingmount)
	if IsMounted() then
		return Dismount()
	end
	if CanExitVehicle() then
		return VehicleExit()
	end

	--use GetCurrentMapAreaID
	--GetZoneText() == L["Dalaran"]
	--GetCurrentMapAreaID()
	
	local flyablex = IsFlyableArea() and (not (GetZoneText() == L["Dalaran"]) or GetSubZoneText():find(L["Krasus"]))
	if GetZoneText() == L["Wintergrasp"] and GetWintergraspWaitTime() == nil then
		flyablex = false
	end
	if IsModifierKeyDown() then
		flyablex = false
	end
	for i = 1, GetNumCompanions"MOUNT" do
		local _, info = GetCompanionInfo("MOUNT", i)
		if flyingmount and info == flyingmount and flyablex then
			return CallCompanion("MOUNT", i)
		elseif groundmount and info == groundmount and not flyablex then
			return CallCompanion("MOUNT", i)
		end
	end
end
