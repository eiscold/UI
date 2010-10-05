if not Load"actionbar" then
	return
end

local function CreateHolder(name, button, a, x, y, alpha, o, scale, offset, mouseover)
	local frame = CreateFrame("Frame", name, UIParent)
	local num = 12
	if name == "ActionBarPet" then
		num = NUM_PET_ACTION_SLOTS
	elseif name == "ActionBarStance" then
		num = NUM_SHAPESHIFT_SLOTS
	elseif name == "ActionBarTotem" then
		num = MAX_TOTEMS
	end
	for i = 2, num do
		local b = _G[button..i]
		b:SetAlpha(alpha)
		b:ClearAllPoints()
		if o == "HORIZONTAL" then
			b:SetPoint("LEFT", _G[button..i-1], "RIGHT", offset / scale, 0)
		else
			b:SetPoint("TOP", _G[button..i-1], "BOTTOM", 0, -offset / scale)
		end
	end
	local size = _G[button..1]:GetWidth()
	frame:SetWidth(o == "HORIZONTAL" and (12 * size + 11 * offset) or size)
	frame:SetHeight(o == "VERTICAL" and (12 * size + 11 * offset) or size)
	frame:SetPoint(a, x / scale, y / scale)
	frame:SetScale(scale)
	if mouseover then
		local function Show()
			for i = 1, num do
				local bu = _G[button..i]
				if bu and bu:IsShown() then
					bu:SetAlpha(1)
				end
			end
		end
		local function Hide()
			for i = 1, num do
				local bu = _G[button..i]
				if bu and bu:IsShown() then
					bu:SetAlpha(0)
				end
			end
		end
		frame:EnableMouse(true)
		frame:SetScript("OnEnter", Show)
		frame:SetScript("OnLeave", Hide)  
		for i = 1, num do
			local pb = _G[button..i]
			pb:SetAlpha(0)
			pb:HookScript("OnEnter", Show)
			pb:HookScript("OnLeave", Hide)
		end
	end
	return frame
end

local scale = .7
local fbar1 = CreateHolder("ActionBar1", "BonusActionButton", "BOTTOM", 0, 50, 1, "HORIZONTAL", scale, 2)
local fbar2 = CreateHolder("ActionBar2", "MultiBarBottomLeftButton", "BOTTOM", 0, 77, 1, "HORIZONTAL", scale, 2, true)
local fbar3 = CreateHolder("ActionBar3", "MultiBarBottomRightButton", "BOTTOM", 0, 104, 1, "HORIZONTAL", scale, 2, true)
local fbar4 = CreateHolder("ActionBar4", "MultiBarRightButton", "RIGHT", -1, 0, 1, "VERTICAL", scale, 2, true)
local fbar5 = CreateHolder("ActionBar5", "MultiBarLeftButton", "RIGHT", -51, 0, 1, "VERTICAL", scale, 2, true)
local fpet  = CreateHolder("ActionBarPet", "PetActionButton", "BOTTOM", 0, 131, 1, "HORIZONTAL", scale, 2)

for i = 1, 12 do
	_G["ActionButton"..i]:SetParent(fbar1)
	if i == 1 then
		_G["ActionButton"..i]:ClearAllPoints()
		_G["ActionButton"..i]:SetPoint("BOTTOMLEFT", fbar1, "BOTTOMLEFT")
	else
		_G["ActionButton"..i]:SetPoint("LEFT", _G["ActionButton"..(i - 1)], "RIGHT", 2.85, 0)
	end
end

BonusActionBarFrame:SetParent(fbar1)
BonusActionBarFrame:SetWidth(0.01)
BonusActionBarTexture0:Hide()
BonusActionBarTexture1:Hide()
BonusActionButton1:ClearAllPoints()
BonusActionButton1:SetPoint("BOTTOMLEFT", fbar1, "BOTTOMLEFT")

MultiBarBottomLeft:SetParent(fbar2)
MultiBarBottomLeftButton1:ClearAllPoints()
MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", fbar2, "BOTTOMLEFT")

MultiBarBottomRight:SetParent(fbar3)
MultiBarBottomRightButton1:ClearAllPoints()
MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", fbar3, "BOTTOMLEFT")

MultiBarRight:SetParent(fbar4)
MultiBarRight:ClearAllPoints()
MultiBarRight:SetPoint("TOPRIGHT")

MultiBarLeft:SetParent(fbar5)
MultiBarLeft:ClearAllPoints()
MultiBarLeft:SetPoint("TOPRIGHT", fbar4, "TOPLEFT")

PetActionBarFrame:SetParent(fpet)
PetActionButton1:ClearAllPoints()
PetActionButton1:SetPoint("BOTTOM", fbar3, "TOP", -PetActionButton1:GetWidth() * NUM_PET_ACTION_SLOTS / 2 + PetActionButton1:GetWidth() / 4, 10)

if PCLASS == "SHAMAN" then
	local ftotem = CreateHolder("ActionBarTotem", "MultiCastActionButton", "BOTTOM", 0, 136, 1, "HORIZONTAL", .7, 5.5)
	MultiCastActionBarFrame:SetParent(ftotem)
	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetPoint("CENTER", ftotem, "CENTER", 0, 0)

	for i = 1, 4 do
		_G["MultiCastActionButton"..i]:SetParent(ftotem)
	end

	local function moveTotem(self, a, ...)
		if a and a ~= "CENTER" then 
			self:ClearAllPoints()
			self:SetPoint("CENTER", "ActionBarTotem", "CENTER", 0, 0)
		end
	end
    
	hooksecurefunc(MultiCastActionBarFrame, "SetPoint", moveTotem)  
end

local fveb = CreateFrame("Frame", "VehicleExitButtonHolder", UIParent)
fveb:SetWidth(36)
fveb:SetHeight(36)
fveb:SetPoint("LEFT", ActionBar1, "RIGHT", 10, 0) 
local veb = CreateFrame("BUTTON", "VehicleExitButton", fveb, "SecureActionButtonTemplate")
veb:SetWidth(36)
veb:SetHeight(36)
veb:SetPoint"CENTER"
veb:RegisterForClicks"AnyUp"
veb:SetNormalTexture"Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up"
veb:SetPushedTexture"Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down"
veb:SetHighlightTexture"Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down"
veb:SetScript("OnClick", function(self)
	VehicleExit()
end)
veb:RegisterEvent"UNIT_ENTERING_VEHICLE"
veb:RegisterEvent"UNIT_ENTERED_VEHICLE"
veb:RegisterEvent"UNIT_EXITING_VEHICLE"
veb:RegisterEvent"UNIT_EXITED_VEHICLE"
veb:SetScript("OnEvent", function(self, event, ...)
	local arg1 = ...
	if ((event == "UNIT_ENTERING_VEHICLE") or (event == "UNIT_ENTERED_VEHICLE")) and arg1 == "player" then
		veb:SetAlpha(1)
	elseif ((event == "UNIT_EXITING_VEHICLE") or (event == "UNIT_EXITED_VEHICLE")) and arg1 == "player" then
		veb:SetAlpha(0)
	end
end)  
veb:SetAlpha(0)

MainMenuBar:SetScale(0.001)
MainMenuBar:SetAlpha(0)
MainMenuBar:EnableMouse(false)
VehicleMenuBar:SetScale(0.001)
VehicleMenuBar:SetAlpha(0)
VehicleMenuBar:EnableMouse(false)