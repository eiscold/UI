if not Load"filter" then
	return
end

local ConfigMode = false
local Spells = {

    ["DEATHKNIGHT"] = {
    -- Frost Fever
    {spellId = 55095, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- Blood Plague
    {spellId = 55078, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Ebon Plague
    {spellId = 51726, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- Unholy Blight
    {spellId = 50536, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
    },
    
    
    ["DRUID"] = {    -- Insect Swarm
    {spellId = 27013, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
    -- Moonfire
    {spellId = 26988, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 280, 0}},
    -- Entangling Roots
    {spellId = 26989, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 317, 0}},
    -- Earth and Moon
     {spellId = 48511, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- Eclipse
     {spellId = 48525, size = 64, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, -80}},
    },
    
    
    ["HUNTER"] = { -- by haylie from wowinterface.com
    -- Hunter's Mark
    {spellId = 53338, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- Serpent Sting
    {spellId = 49001, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
    -- Black Arrow
    {spellId = 63672, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 280, 0}},
    -- Explosive Shot DoT
    {spellId = 60053, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 317, 0}},
    -- Lock and Load
    {spellId = 56453, size = 64, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, 0}},
    -- Aspect of the Viper
    {spellId = 34074, size = 64, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, 70}},
    },
    
    
    ["MAGE"] = {-- by Zaben from wowinterface.com
    -- Living Bomb
    {spellId = 55360, size = 64, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, -80}},
    -- Fingers of Frost (Frost), Missile Barrage (Arcane), Hot Streak (Fire)
    {spellId = 44545, spellId2 = 54490, spellId3 = 44448, size = 64, unitId = "player", isMine = all, filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, 80}},
	-- Fireball! 
    {spellId = 57761, size = 32, unitId = "player", isMine = "all", filter = "HELPFULL", setPoint = {"CENTER", UIParent, "CENTER", 136, 0}},
    -- Clear Casting
    {spellId = 12536, size = 64, unitId = "player", isMine = all, filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, -80}},
    -- Fiery Payback (Rank 1 and 2) 44440
    {spellId = 44442, spellId2 = 44443, size = 32, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 101, 0}},
    -- Impact
    {spellId = 12358, size = 32, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 136, 0}},
    -- Arcane Blast debuff 
    {spellId = 36032, size = 32, unitId = "player", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- Spell Crit - Winter's Chill (Frost), Improved Scorch (Fire)
    {spellId = 28593, spellId2 = 22959, size = 32, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, 0}},
    -- Polymorph - Sheep, Pig, Turkey, Black Cat, Rabbit, Turtle, 
    {spellId = 12826, spellId2 = 28272, spellId3 = 61780, spellId4 = 61305, spellId5 = 61721, spellId6 = 28271, size = 32, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 136, 0}},
    -- Slow (Arcane), Ignite (Fire), Frostbite (Frost)
    {spellId = 31589, spellId2 = 12848, spellId3 = 12497, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 241, 0}},
    },

    
    ["PALADIN"] = {
    },
    
    
    ["PRIEST"] = {
    -- Inner Fire
    {spellId = 48168, size = 32, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 37}},
    -- PW:Shield on self
    {spellId = 48066, size = 32, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},
    -- Renew on target
    {spellId = 25222, size = 32, unitId = "target", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- PW:Shield on target
    {spellId = 48066, size = 32, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Surge of Light
    {spellId = 33151, size = 32, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- SW:Pain
    {spellId = 48125, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- VT (shadow)
    {spellId = 48160, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    -- VE (shadow)
    {spellId = 15286, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
    -- Devouring Plague
    {spellId = 48300, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},
    },
    
    
    ["ROGUE"] = {
    },
    
    
    ["SHAMAN"] = {
    -- Hex
    {spellId = 51514, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 37}},
    -- Water Shield, Earth Shield, Lightning Shield
    {spellId = 57960, spellId2 = 49284, spellId3 = 49281, size = 32, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- Tidal Waves (resto), Maelstrom (ench)
    {spellId = 53390, spellId2 = 53817, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Flame Shock, Frost Shock
    {spellId = 49233, spellId2 = 49236, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- ES on target (resto)
    {spellId = 49284, size = 32, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Riptide (resto)
    {spellId = 61301, size = 32, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    },
    
    
    ["WARLOCK"] = {
    -- CoE, Ebon Plaguebringer, Earth and Moon
    {spellId = 47865, spellId2 = 51161, spellId3 = 48511, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- CoT, CoE, CoW
    {spellId = 11719, spellId2 = 18223, spellId3 = 50511, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Molten Core, (destro)
    {spellId = 47383, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- Decimation (demo), Backdraft (destro)
    {spellId = 63158, spellId2 = 54277, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
    -- Immolation
    {spellId = 47811, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Corruption
    {spellId = 47813, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    -- CoA, CoD
    {spellId = 47864, spellId2 = 47867, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
    },
    
    
    ["WARRIOR"] = {
    -- Blood Draining
    {spellId = 64568, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 37}},
    -- Instant Slam!
    {spellId = 46916, size = 64, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, 0}},
    -- Sudden Death
    {spellId = 52437, size = 64, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, 0}},
    -- Hamstring
    {spellId = 1715, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},
    -- Rend
    {spellId = 47465, size = 32, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 37}},
    -- Instant Shield Slam
    {spellId = 50227, size = 64, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"LEFT", UIParent, "CENTER", 85, 0}},
    -- Armor debuff - major: sunder, expose
    {spellId = 7386, spellId2 = 48669, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Attack speed debuff: warrior clap, feral wounds, dk frost fever
    {spellId = 6343, spellId2 = 48485, spellId3 = 55095, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
    -- Attack power debuff: warrior shout, druid roar, lock curse
    {spellId = 1160, spellId2 = 48560, spellId3 = 50511, size = 32, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
    }
}

local MyUnits = {
    player = true,
    vehicle = true,
    pet = true,
}

local function CreateFilterFrame(data)
    local spellName, _, spellIcon = GetSpellInfo(data.spellId)
    local frame = CreateFrame("Frame", "filter_" .. data.unitId .. "_" .. data.spellId, UIParent)
    frame:SetWidth(data.size)
    frame:SetHeight(data.size)
    frame:SetPoint(unpack(data.setPoint))
    frame:RegisterEvent"UNIT_AURA"
    frame:RegisterEvent"PLAYER_TARGET_CHANGED"
    frame:RegisterEvent"PLAYER_ENTERING_WORLD"
    frame:SetScript("OnEvent", function(self, event, ...)
        local unit = ...
        if data.unitId == unit or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
            self.found = false
            self:SetAlpha(1)
            for i = 1, 40 do
                local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(data.unitId, i, data.filter)
                if (data.isMine ~= 1 or MyUnits[caster]) and (name == GetSpellInfo(data.spellId) or (data.spellId2 and name == GetSpellInfo(data.spellId2)) or (data.spellId3 and name == GetSpellInfo(data.spellId3))) then
                    self.found = true
                    self.icon:SetTexture(icon)
                    self.count:SetText(count > 1 and count or "")
                    if duration > 0 then
                        self.cooldown:Show()
                        CooldownFrame_SetTimer(self.cooldown, expirationTime - duration, duration, 1)
                    else
                        self.cooldown:Hide()
                    end
                    break
                end
            end

            if not self.found then
                self:SetAlpha(0)
                self.icon:SetTexture(spellIcon)
                self.count:SetText""
                self.cooldown:Hide()
            end
        end

        if ConfigMode == true then
            self:SetAlpha(1)
            self.count:SetText(9)
        end
    end)

    if ConfigMode == true then
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton", "RightButton")
        frame:SetScript("OnMouseDown", function(self)
            if arg1 == "LeftButton" then
                if IsShiftKeyDown() or IsAltKeyDown() then
                    self:StartMoving()
                end
            else
                self:ClearAllPoints()
                self:SetPoint(unpack(data.setPoint))
            end
        end)
        frame:SetScript("OnMouseUp", function(self) 
            self:StopMovingOrSizing()
            if arg1 == "LeftButton" then
                local x, y = self:GetCenter()
                print(format("|cffff00ffs|rFilter: setPoint for %s (%s): {\"%s\", UIParent, \"%s\", %s, %s}", data.spellId, spellName, "CENTER", "BOTTOMLEFT", floor(x + 0.5), floor(y + 0.5)))
            end
        end)
    end

    frame.icon = frame:CreateTexture("$parentIcon", "BACKGROUND")
    frame.icon:SetAllPoints(frame)
    frame.icon:SetTexture(spellIcon)
    frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    frame.count = frame:CreateFontString(nil, "OVERLAY")
    frame.count:SetFont("Fonts\\ARIALN.TTF", 13, "OUTLINE")
    frame.count:SetTextColor(1, 1, 1)
    frame.count:SetPoint"TOPRIGHT"

    frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
    frame.cooldown:SetPoint"TOPLEFT"
    frame.cooldown:SetPoint"BOTTOMRIGHT"
    frame.cooldown:SetReverse()

	CreateBG(frame)
end

if Spells and Spells[PCLASS] then
    for index in pairs(Spells) do
        if index ~= PCLASS then
            Spells[index] = nil
        end
    end
    for i = 1, #Spells[PCLASS], 1 do
        CreateFilterFrame(Spells[PCLASS][i])
    end
end