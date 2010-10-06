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
local ActionBar1 = CreateHolder("ActionBar1", "BonusActionButton", "BOTTOM", 0, 50, 1, "HORIZONTAL", scale, 2)
local ActionBar2 = CreateHolder("ActionBar2", "MultiBarBottomLeftButton", "BOTTOM", 0, 77, 1, "HORIZONTAL", scale, 2, true)
local ActionBar3 = CreateHolder("ActionBar3", "MultiBarBottomRightButton", "BOTTOM", 0, 104, 1, "HORIZONTAL", scale, 2, true)
local ActionBar4 = CreateHolder("ActionBar4", "MultiBarRightButton", "RIGHT", -1, 0, 1, "VERTICAL", scale, 2, true)
local ActionBar5 = CreateHolder("ActionBar5", "MultiBarLeftButton", "RIGHT", -51, 0, 1, "VERTICAL", scale, 2, true)
local ActionBarPet  = CreateHolder("ActionBarPet", "PetActionButton", "BOTTOM", 0, 131, 1, "HORIZONTAL", scale, 2)

for i = 1, 12 do
	_G["ActionButton"..i]:SetParent(ActionBar1)
	if i == 1 then
		_G["ActionButton"..i]:ClearAllPoints()
		_G["ActionButton"..i]:SetPoint("BOTTOMLEFT", ActionBar1, "BOTTOMLEFT")
	else
		_G["ActionButton"..i]:SetPoint("LEFT", _G["ActionButton"..(i - 1)], "RIGHT", 2.85, 0)
	end
end

BonusActionBarFrame:SetParent(ActionBar1)
BonusActionBarFrame:SetWidth(0.01)
BonusActionBarTexture0:Hide()
BonusActionBarTexture1:Hide()
BonusActionButton1:ClearAllPoints()
BonusActionButton1:SetPoint("BOTTOMLEFT", ActionBar1, "BOTTOMLEFT")

MultiBarBottomLeft:SetParent(ActionBar2)
MultiBarBottomLeftButton1:ClearAllPoints()
MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", ActionBar2, "BOTTOMLEFT")

MultiBarBottomRight:SetParent(ActionBar3)
MultiBarBottomRightButton1:ClearAllPoints()
MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", ActionBar3, "BOTTOMLEFT")

MultiBarRight:SetParent(ActionBar4)
MultiBarRight:ClearAllPoints()
MultiBarRight:SetPoint("TOPRIGHT")

MultiBarLeft:SetParent(ActionBar5)
MultiBarLeft:ClearAllPoints()
MultiBarLeft:SetPoint("TOPRIGHT", ActionBar4, "TOPLEFT")

PetActionBarFrame:SetParent(ActionBarPet)
PetActionButton1:ClearAllPoints()
PetActionButton1:SetPoint("BOTTOM", ActionBar3, "TOP", -PetActionButton1:GetWidth() * NUM_PET_ACTION_SLOTS / 2 + PetActionButton1:GetWidth() / 4, 10)

local ActionBarVehicle = CreateFrame("BUTTON", nil, UIParent, "SecureActionButtonTemplate")
ActionBarVehicle:SetWidth(36)
ActionBarVehicle:SetHeight(36)
ActionBarVehicle:SetPoint("LEFT", ActionBar1, "RIGHT", 10, 0) 
ActionBarVehicle:RegisterForClicks"AnyUp"
ActionBarVehicle:SetScript("OnClick", function()
	VehicleExit()
end)
ActionBarVehicle:SetNormalTexture"Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up"
ActionBarVehicle:SetPushedTexture"Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down"
ActionBarVehicle:SetHighlightTexture"Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down"
ActionBarVehicle:RegisterEvent"UNIT_ENTERING_VEHICLE"
ActionBarVehicle:RegisterEvent"UNIT_ENTERED_VEHICLE"
ActionBarVehicle:RegisterEvent"UNIT_EXITING_VEHICLE"
ActionBarVehicle:RegisterEvent"UNIT_EXITED_VEHICLE"
ActionBarVehicle:RegisterEvent"ZONE_CHANGED_NEW_AREA"
ActionBarVehicle:SetScript("OnEvent", function(self, event, arg1)
	if (event == "UNIT_ENTERING_VEHICLE" or event == "UNIT_ENTERED_VEHICLE") and arg1 == "player" then
		ActionBarVehicle:SetAlpha(1)
	elseif (event == "UNIT_EXITING_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and arg1 == "player" or event == "ZONE_CHANGED_NEW_AREA" and not UnitHasVehicleUI"player" then
		ActionBarVehicle:SetAlpha(0)
	end
end)
ActionBarVehicle:SetAlpha(0)

MainMenuBar:SetScale(0.001)
MainMenuBar:SetAlpha(0)
MainMenuBar:EnableMouse(false)
VehicleMenuBar:SetScale(0.001)
VehicleMenuBar:SetAlpha(0)
VehicleMenuBar:EnableMouse(false)

--[[
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
]]

local buttonsize = 27
local flyoutsize = 24
local buttonspacing = 3
local borderspacing = 2

local bordercolors = {
	{.23,.45,.13},    -- Earth
	{.58,.23,.10},    -- Fire
	{.19,.48,.60},   -- Water
	{.42,.18,.74},   -- Air
	{.39,.39,.12}    -- Summon / Recall
}

function CreateBD(f)
	f:SetBackdrop(BACKDROP)
	f:SetBackdropColor(0, 0, 0, 1)
	f:SetBackdropBorderColor(0, 0, 0, 1)
end

local function SkinFlyoutButton(button)
	button.skin = CreateFrame("Frame",nil,button)
	CreateBD(button.skin)
	button:GetNormalTexture():SetTexture(nil)
	button:ClearAllPoints()
	button.skin:ClearAllPoints()
	button.skin:SetFrameStrata"LOW"

	button:SetWidth(buttonsize+borderspacing)
	button:SetHeight(buttonspacing*3 + borderspacing-1)
	button.skin:SetWidth(buttonsize+borderspacing)
	button.skin:SetHeight(buttonspacing*2)
	button:SetPoint("BOTTOM",button:GetParent(),"TOP",0,0)    
	button.skin:SetPoint("TOP",button,"TOP",0,0)

	button:GetHighlightTexture():SetTexture("Interface\\Buttons\\ButtonHilight-Square", "HIGHLIGHT")
	button:GetHighlightTexture():ClearAllPoints()
	button:GetHighlightTexture():SetPoint("TOPLEFT",button.skin,"TOPLEFT",borderspacing,-borderspacing)
	button:GetHighlightTexture():SetPoint("BOTTOMRIGHT",button.skin,"BOTTOMRIGHT",-borderspacing,borderspacing)
end

local function SkinActionButton(button, colorr, colorg, colorb)
	CreateBD(button)
	button:SetBackdropBorderColor(colorr,colorg,colorb)
	button:SetBackdropColor(0,0,0,0)
	button:ClearAllPoints()
	button:SetAllPoints(button.slotButton)
	button.overlay:SetTexture(nil)
	button:GetRegions():SetDrawLayer"ARTWORK"
end

local function SkinButton(button,colorr, colorg, colorb)
	CreateBD(button)
	if button.actionButton then
		CreateBD(button.actionButton)
		button.actionButton:SetPushedTexture""
		button.actionButton:SetCheckedTexture""
	end
	button.background:SetDrawLayer"ARTWORK"
	button.background:ClearAllPoints()
	button.background:SetPoint("TOPLEFT",button,"TOPLEFT",borderspacing,-borderspacing)
	button.background:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-borderspacing,borderspacing)
	button.overlay:SetTexture(nil)
	button:SetSize(27,27)
	button:SetBackdropBorderColor(colorr,colorg,colorb)
end

local function SkinSummonButton(button,colorr, colorg, colorb)
	local icon = select(1,button:GetRegions())
	icon:SetDrawLayer"ARTWORK"
	icon:ClearAllPoints()
	icon:SetPoint("TOPLEFT",button,"TOPLEFT",borderspacing,-borderspacing)
	icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-borderspacing,borderspacing)
	icon:SetTexCoord(.09,.91,.09,.91)

	select(12,button:GetRegions()):SetTexture(nil)
	select(7,button:GetRegions()):SetTexture(nil)
	CreateBD(button)
	button:SetSize(buttonsize,buttonsize)
	button:SetPushedTexture""
	button:SetCheckedTexture""
end

local function SkinFlyoutTray(tray)
	local parent = tray.parent
	local buttons = {select(2,tray:GetChildren())}
	local closebutton = tray:GetChildren()
	local numbuttons = 0

	for i,k in ipairs(buttons) do
		local prev = i > 1 and buttons[i-1] or tray

		if k:IsVisible() then
			numbuttons = numbuttons + 1
		end

		if k.icon then
			k.icon:SetDrawLayer"ARTWORK"
			k.icon:ClearAllPoints()
			k.icon:SetPoint("TOPLEFT",k,"TOPLEFT",borderspacing,-borderspacing)
			k.icon:SetPoint("BOTTOMRIGHT",k,"BOTTOMRIGHT",-borderspacing,borderspacing)

			CreateBD(k)
			k:SetBackdropBorderColor(1, 1, 1)
			if k.icon:GetTexture() ~= "Interface\\Buttons\\UI-TotemBar" then
				k.icon:SetTexCoord(.09,.91,.09,.91)
			end
		end

		k:ClearAllPoints()
		k:SetPoint("BOTTOM",prev,"TOP",0,buttonspacing)
	end

	tray.middle:SetTexture(nil)
	tray.top:SetTexture(nil)
	CreateBD(tray)

	CreateBD(closebutton)
	closebutton:GetHighlightTexture():SetTexture"Interface\\Buttons\\ButtonHilight-Square"
	closebutton:GetHighlightTexture():SetPoint("TOPLEFT",closebutton,"TOPLEFT",borderspacing,-borderspacing)
	closebutton:GetHighlightTexture():SetPoint("BOTTOMRIGHT",closebutton,"BOTTOMRIGHT",-borderspacing,borderspacing)
	closebutton:GetNormalTexture():SetTexture(nil)

	tray:ClearAllPoints()
	closebutton:ClearAllPoints()
	
	tray:SetWidth(flyoutsize + buttonspacing*2)
	tray:SetHeight((flyoutsize+buttonspacing) * numbuttons + buttonspacing)
	closebutton:SetHeight(buttonspacing * 2)
	closebutton:SetWidth(tray:GetWidth())

	tray:SetPoint("BOTTOM",parent,"TOP",0,buttonspacing + (1))
	closebutton:SetPoint("BOTTOM",tray,"TOP",0,1)
	buttons[1]:SetPoint("BOTTOM",tray,"BOTTOM",0,buttonspacing)
end

local AddOn = CreateFrame("Frame", nil, UIParent)
local OnEvent = function(self, event, ...) self[event](self, event, ...) end
AddOn:SetScript("OnEvent", OnEvent)

function AddOn:PLAYER_ENTERING_WORLD()
	if PCLASS == "SHAMAN" then
		local bgframe = CreateFrame("Frame", "TotemBG", MultiCastSummonSpellButton)
		CreateBD(bgframe)
		bgframe:SetHeight(buttonsize + buttonspacing*2)
		bgframe:SetWidth(buttonspacing + (buttonspacing + buttonsize)*6)
		bgframe:SetFrameStrata"LOW"
		bgframe:ClearAllPoints()

		bgframe:SetHeight(buttonsize + buttonspacing*2)
		bgframe:SetWidth(buttonspacing + (buttonspacing + buttonsize)*6)
		bgframe:SetPoint("BOTTOMLEFT",MultiCastSummonSpellButton,"BOTTOMLEFT",-buttonspacing,-buttonspacing)

		for i = 1, 12 do
			if i < 6 then
				local button = _G["MultiCastSlotButton"..i] or MultiCastRecallSpellButton
				local prev = _G["MultiCastSlotButton"..(i-1)] or MultiCastSummonSpellButton
				prev.idx = i - 1
				if i == 1 or i == 5 then
					SkinSummonButton(i == 5 and button or prev, 1, 1, 1)
				end
				if i < 5 then
					SkinButton(button,1, 1, 1)
				end
				button:ClearAllPoints()
				ActionButton1.SetPoint(button,"LEFT",prev,"RIGHT",buttonspacing,0)
			end
			SkinActionButton(_G["MultiCastActionButton"..i], 1, 1, 1)
		end
		MultiCastFlyoutFrame:HookScript("OnShow",SkinFlyoutTray)
		MultiCastFlyoutFrameOpenButton:HookScript("OnShow", function(self)
			if MultiCastFlyoutFrame:IsShown() then
				MultiCastFlyoutFrame:Hide()
			end
			SkinFlyoutButton(self)
		end)
		MultiCastFlyoutFrame:SetFrameLevel(4)
	end
end

AddOn:RegisterEvent"PLAYER_ENTERING_WORLD"