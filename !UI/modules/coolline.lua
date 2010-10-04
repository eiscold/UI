if not Load"coolline" then
	return
end

local CoolLineFrame = CreateFrame("Frame", "CoolLineFrame", UIParent)
CoolLineFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

local height = 38
local width = 213

local activeAlpha = .5
local backdrop = { edgeSize = 16, }
local border = "None"
local hideBag = false
local hideInventory = false
local hidePet = false
local iconPlus = 0
local iconSize = 0
local inactiveAlpha = .5
local reverse = false
local section = 0
local tick0, tick1, tick10, tick30, tick60, tick120, tick300

local cooldowns = {}
local block = {
	["Hearthstone"] = true,
}
local borderColor = {
	r = 1,
	g = 1,
	b = 1,
	a = 1
}
local frames = {}
local noSpellColor = {
	r = 0,
	g = 0,
	b = 0,
	a = 0
}
local spellColor = {
	r = .8,
	g = .4,
	b = 0,
	a = 0
}
local spells = {
	[BOOKTYPE_SPELL] = {},
	[BOOKTYPE_PET] = {},
}

local updatelook, createfs, RuneCheck
local function SetValue(self, v, just)
	self:SetPoint(just or "CENTER", CoolLineFrame, "LEFT", v, 0)
end

CoolLineFrame:RegisterEvent"ADDON_LOADED"
function CoolLineFrame:ADDON_LOADED(addon)
	if addon ~= UI_NAME then 
		return
	end
	CoolLineFrame:UnregisterEvent"ADDON_LOADED"
	CoolLineFrame.ADDON_LOADED = nil

	if PCLASS == "DEATHKNIGHT" then
		local runecd = {  -- fix by NeoSyrex
			[GetSpellInfo(50977) or "Death Gate"] = 11,
			[GetSpellInfo(43265) or "Death and Decay"] = 11,
			[GetSpellInfo(48263) or "Frost Presence"] = 1,
			[GetSpellInfo(48266) or "Blood Presence"] = 1,
			[GetSpellInfo(48265) or "Unholy Presence"] = 1, 
			[GetSpellInfo(42650) or "Army of the Dead"] = 11,
			[GetSpellInfo(49222) or "Bone Shield"] = 11,
			[GetSpellInfo(47476) or "Strangulate"] = 11,
			[GetSpellInfo(51052) or "Anti-Magic Zone"] = 11,
			[GetSpellInfo(63560) or "Ghoul Frenzy"] = 10,
			[GetSpellInfo(49184) or "Howling Blast"] = 8,
			[GetSpellInfo(51271) or "Unbreakable Armor"] = 11,
			[GetSpellInfo(55233) or "Vampiric Blood"] = 11,
			[GetSpellInfo(49005) or "Mark of Blood"] = 11,
			[GetSpellInfo(48982) or "Rune Tap"] = 11,
		}
		RuneCheck = function(name, duration)
			local rc = runecd[name]
			if not rc or (rc <= duration and (rc > 10 or rc >= duration)) then
				return true
			end
		end
	end
	
	createfs = function(f, text, offset, just)
		local fs = f or CoolLineFrame.overlay:CreateFontString(nil, "OVERLAY")
		fs:SetFont(FONT, 11)
		fs:SetTextColor(1, 1, 1, 0)
		fs:SetText(text)
		fs:SetWidth(11 * 3)
		fs:SetHeight(11 + 2)
		fs:SetShadowColor(0, 0, 0, 0)
		fs:SetShadowOffset(1, -1)
		if just then
			fs:ClearAllPoints()
			if reverse then
				just = (just == "LEFT" and "RIGHT") or "LEFT"
				offset = offset + ((just == "LEFT" and 1) or -1)
				fs:SetJustifyH(just)
			else
				offset = offset + ((just == "LEFT" and 1) or -1)
				fs:SetJustifyH(just)
			end
		else
			fs:SetJustifyH"CENTER"
		end
		SetValue(fs, offset, just)
		return fs
	end

	updatelook = function()
		CoolLineFrame:SetWidth(width or 130)
		CoolLineFrame:SetHeight(height or 18)
		CoolLineFrame:SetPoint("CENTER", "ufPlayer", "CENTER")
			
		CoolLineFrame.bg = CoolLineFrame.bg or CoolLineFrame:CreateTexture(nil, "ARTWORK")
		CoolLineFrame.bg:SetTexture(TEXTURE)
		CoolLineFrame.bg:SetVertexColor(0, 0, 0, 0)
		CoolLineFrame.bg:SetAllPoints(CoolLineFrame)
		
		CoolLineFrame.border = CoolLineFrame.border or CreateFrame("Frame", nil, CoolLineFrame)
		CoolLineFrame.border:SetPoint("TOPLEFT", -4, 4)
		CoolLineFrame.border:SetPoint("BOTTOMRIGHT", 4, -4)
		backdrop.edgeFile = border
		CoolLineFrame.border:SetBackdrop(backdrop)
		CoolLineFrame.border:SetBackdropBorderColor(borderColor.r, borderColor.g, borderColor.b, borderColor.a)

		CoolLineFrame.overlay = CoolLineFrame.overlay or CreateFrame("Frame", nil, CoolLineFrame.border)
		CoolLineFrame.overlay:SetFrameLevel(11)

		section = width / 6
		iconSize = height + (iconPlus or 0) - 20
		
		tick0 = createfs(tick0, "0", 0, "LEFT")
		tick1 = createfs(tick1, "1", section)
		tick10 = createfs(tick10, "3", section * 2)
		tick30 = createfs(tick30, "10", section * 3)
		tick60 = createfs(tick60, "60", section * 4)
		tick120 = createfs(tick120, "2m", section * 5)
		tick300 = createfs(tick300, "6m", section * 6, "RIGHT")

		if hidePet then
			CoolLineFrame:UnregisterEvent"UNIT_PET"
			CoolLineFrame:UnregisterEvent"PET_BAR_UPDATE_COOLDOWN"
		else
			CoolLineFrame:RegisterEvent"UNIT_PET"
			CoolLineFrame:UNIT_PET"player"
		end
		if hideBag and hideInventory then
			CoolLineFrame:UnregisterEvent"BAG_UPDATE_COOLDOWN"
		else
			CoolLineFrame:RegisterEvent"BAG_UPDATE_COOLDOWN"
		end
		CoolLineFrame:SetAlpha((CoolLineFrame.unlock or #cooldowns > 0) and activeAlpha or inactiveAlpha)
		for _, frame in ipairs(cooldowns) do
			frame:SetWidth(iconSize)
			frame:SetHeight(iconSize)
		end
	end
	
	if IsLoggedIn() then
		CoolLineFrame:PLAYER_LOGIN()
	else
		CoolLineFrame:RegisterEvent"PLAYER_LOGIN"
	end
end

function CoolLineFrame:PLAYER_LOGIN()
	CoolLineFrame.PLAYER_LOGIN = nil
	CoolLineFrame:RegisterEvent"SPELL_UPDATE_COOLDOWN"
	CoolLineFrame:RegisterEvent"SPELLS_CHANGED"
	CoolLineFrame:RegisterEvent"UNIT_ENTERED_VEHICLE"
	if UnitHasVehicleUI"player" then
		CoolLineFrame:RegisterEvent"ACTIONBAR_UPDATE_COOLDOWN"
		CoolLineFrame:RegisterEvent"UNIT_EXITED_VEHICLE"
	end
	updatelook()
	CoolLineFrame:SPELLS_CHANGED()
	CoolLineFrame:SPELL_UPDATE_COOLDOWN()
	CoolLineFrame:BAG_UPDATE_COOLDOWN()
	CoolLineFrame:SetAlpha((#cooldowns == 0 and inactiveAlpha) or activeAlpha)
end

local elapsed, throt, ptime, isactive = 0, 1.5, 0, false
local function ClearCooldown(f, name)
	name = name or (f and f.name)
	for index, frame in ipairs(cooldowns) do
		if frame.name == name then
			frame:Hide()
			frame.name = nil
			frame.endtime = nil
			tinsert(frames, tremove(cooldowns, index))
			break
		end
	end
end

local function SetupIcon(frame, position, tthrot, active, fl)
	throt = (throt < tthrot and throt) or tthrot
	isactive = active or isactive
	if fl then
		frame:SetFrameLevel(math.random(1, 4) * 2 + 2)
	end
	SetValue(frame, position)
end

local function OnUpdate(this, arg, ctime, dofl)
	elapsed = elapsed + arg
	if elapsed < throt then
		return
	end
	elapsed = 0
	
	if #cooldowns == 0 then
		if not CoolLineFrame.unlock then
			CoolLineFrame:SetScript("OnUpdate", nil)
			CoolLineFrame:SetAlpha(inactiveAlpha)
		end
		return
	end
	
	ctime = ctime or GetTime()
	if ctime > ptime then
		dofl, ptime = true, ctime + .4
	end

	isactive, throt = false, 1.5
	for index, frame in pairs(cooldowns) do
		local remain = frame.endtime - ctime
		if remain < 3 then
			if remain > 1 then
				SetupIcon(frame, section * (remain + 1) * .5, .02, true, dofl)
			elseif remain > .3 then
				SetupIcon(frame, section * remain, 0, true, dofl)
			elseif remain > 0 then
				SetupIcon(frame, section * remain, 0, true, dofl)
			elseif remain > -1 then
				SetupIcon(frame, 0, 0, true, dofl)
				frame:SetAlpha(1 + remain)
			else
				throt = (throt < .2 and throt) or .2
				isactive = true
				ClearCooldown(frame)
			end
		elseif remain < 10 then
			SetupIcon(frame, section * (remain + 11) * .143, remain > 4 and .05 or .02, true, dofl)
		elseif remain < 60 then
			SetupIcon(frame, section * (remain + 140) * .02, .12, true, dofl)
		elseif remain < 120 then
			SetupIcon(frame, section * (remain + 180) * .01666, .25, true, dofl)
		elseif remain < 360 then
			SetupIcon(frame, section * (remain + 1080) * .004166, 1.2, true, dofl)
			frame:SetAlpha(1)
		else
			SetupIcon(frame, 6 * section, 2, false, dofl)
		end
	end
	if not isactive and not CoolLineFrame.unlock then
		CoolLineFrame:SetAlpha(inactiveAlpha)
	end
end

local function NewCooldown(name, icon, endtime, isplayer)
	local f
	for index, frame in pairs(cooldowns) do
		if frame.name == name and frame.isplayer == isplayer then
			f = frame
			break
		elseif frame.endtime == endtime then
			return
		end
	end
	if not f then
		f = f or tremove(frames)
		if not f then
			f = CreateFrame("Frame", nil, CoolLineFrame.border)
			f.icon = f:CreateTexture(nil, "ARTWORK")
			f.icon:SetTexCoord(.1, .9, .1, .9)
			f.icon:SetPoint("TOPLEFT", 1, -1)
			f.icon:SetPoint("BOTTOMRIGHT", -1, 1)
		end
		tinsert(cooldowns, f)
	end
	local ctime = GetTime()
	f:SetWidth(iconSize)
	f:SetHeight(iconSize)
	f:SetAlpha((endtime - ctime > 360) and .6 or 1)
	f.name, f.endtime, f.isplayer = name, endtime, isplayer
	f.icon:SetTexture(icon)
	local c = isplayer and spellColor or noSpellColor
	f:SetBackdropColor(c.r, c.g, c.b, c.a)
	f:Show()
	CoolLineFrame:SetScript("OnUpdate", OnUpdate)
	CoolLineFrame:SetAlpha(activeAlpha)
	OnUpdate(CoolLineFrame, 2, ctime)
end

do
	local CLTip = CreateFrame("GameTooltip", "CLTip", CoolLineFrame, "GameTooltipTemplate")
	CLTip:SetOwner(CoolLineFrame, "ANCHOR_NONE")
	local GetSpellName = GetSpellName
	local cooldown1 = gsub(SPELL_RECAST_TIME_MIN, "%%%.%d[fg]", "(.+)")
	local cooldown2 = gsub(SPELL_RECAST_TIME_SEC, "%%%.%d[fg]", "(.+)")
	local function CheckRight(rtext)
		local text = rtext and rtext:GetText()
		if text and (strmatch(text, cooldown1) or strmatch(text, cooldown2)) then
			return true
		end
	end

	local function CacheBook(btype)
		local name, last
		local sb = spells[btype]
		for i = 1, 500, 1 do
			name = GetSpellName(i, btype)
			if not name then
				break
			end
			if name ~= last then
				last = name
				if sb[name] then
					sb[name] = i
				else
					CLTip:SetSpell(i, btype)
					if CheckRight(CLTipTextRight2) or CheckRight(CLTipTextRight3) or CheckRight(CLTipTextRight4) then
						sb[name] = i
					end
				end
			end
		end
	end

	function CoolLineFrame:SPELLS_CHANGED()
		CacheBook(BOOKTYPE_SPELL)
		if not hidePet then
			CacheBook(BOOKTYPE_PET)
		end
	end
end

do
	local selap = 0
	local spellthrot = CreateFrame("Frame", nil, CoolLineFrame)
	local function CheckSpellBook(btype)
		for name, id in pairs(spells[btype]) do
			local start, duration, enable = GetSpellCooldown(id, btype)
			if enable == 1 and start > 0 and not block[name] and (not RuneCheck or RuneCheck(name, duration)) then
				if duration > 2.5 then
					NewCooldown(name, GetSpellTexture(id, btype), start + duration, btype == BOOKTYPE_SPELL)
				else
					for index, frame in ipairs(cooldowns) do
						if frame.name == name then
							if frame.endtime > start + duration + .1 then
								frame.endtime = start + duration
							end
							break
						end
					end
				end
			else
				ClearCooldown(nil, name)
			end
		end
	end

	spellthrot:SetScript("OnUpdate", function(self, elapsed)
		selap = selap + elapsed
		if selap < .33 then
			return
		end
		selap = 0
		self:Hide()
		CheckSpellBook(BOOKTYPE_SPELL)
		if not hidePet and HasPetUI() then
			CheckSpellBook(BOOKTYPE_PET)
		end
	end)

	spellthrot:Hide()

	function CoolLineFrame:SPELL_UPDATE_COOLDOWN()
		spellthrot:Show()
	end
end

do  -- scans equipments and bags for item cooldowns
	function CoolLineFrame:BAG_UPDATE_COOLDOWN()
		for i = 1, (hideInventory and 0) or 18, 1 do
			local start, duration, enable = GetInventoryItemCooldown("player", i)
			if enable == 1 then
				local name = GetItemInfo(GetInventoryItemLink("player", i))
				if start > 0 and not block[name] then
					if duration > 3 and duration < 3601 then
						NewCooldown(name, GetInventoryItemTexture("player", i), start + duration)
					end
				else
					ClearCooldown(nil, name)
				end
			end
		end
		for i = 0, (hideBag and -1) or 4, 1 do
			for j = 1, GetContainerNumSlots(i), 1 do
				local start, duration, enable = GetContainerItemCooldown(i, j)
				if enable == 1 then
					local name = GetItemInfo(GetContainerItemLink(i, j))
					if start > 0 and not block[name] then
						if duration > 3 and duration < 3601 then
							NewCooldown(name, GetContainerItemInfo(i, j), start + duration)
						end
					else
						ClearCooldown(nil, name)
					end
				end
			end
		end
	end
end

function CoolLineFrame:PET_BAR_UPDATE_COOLDOWN()
	for i = 1, 10, 1 do
		local start, duration, enable = GetPetActionCooldown(i)
		if enable == 1 then
			local name, _, texture = GetPetActionInfo(i)
			if name then
				if start > 0 and not block[name] then
					if duration > 3 then
						NewCooldown(name, texture, start + duration)
					end
				else
					ClearCooldown(nil, name)
				end
			end
		end
	end
end

function CoolLineFrame:UNIT_PET(unit)
	if unit == "player" then
		if UnitExists"pet" and not HasPetUI() then
			CoolLineFrame:RegisterEvent"PET_BAR_UPDATE_COOLDOWN"
		else
			CoolLineFrame:UnregisterEvent"PET_BAR_UPDATE_COOLDOWN"
		end
	end
end

function CoolLineFrame:ACTIONBAR_UPDATE_COOLDOWN()
	for i = 1, 6, 1 do
		local b = _G["VehicleMenuBarActionButton"..i]
		if b and HasAction(b.action) then
			local start, duration, enable = GetActionCooldown(b.action)
			if enable == 1 then
				if start > 0 and not block[GetActionInfo(b.action)] then
					if duration > 3 then
						NewCooldown("vhcle"..i, GetActionTexture(b.action), start + duration)
					end
				else
					ClearCooldown(nil, "vhcle"..i)
				end
			end
		end
	end
end

function CoolLineFrame:UNIT_ENTERED_VEHICLE(unit)
	if unit == "player" and UnitHasVehicleUI"player" then
		CoolLineFrame:RegisterEvent"ACTIONBAR_UPDATE_COOLDOWN"
		CoolLineFrame:RegisterEvent"UNIT_EXITED_VEHICLE"
		CoolLineFrame:ACTIONBAR_UPDATE_COOLDOWN()
	end
end

function CoolLineFrame:UNIT_EXITED_VEHICLE(unit)
	if unit == "player" then
		CoolLineFrame:UnregisterEvent"ACTIONBAR_UPDATE_COOLDOWN"
		for index, frame in ipairs(cooldowns) do
			if strmatch(frame.name, "vhcle") then
				ClearCooldown(nil, frame.name)
			end
		end
	end
end