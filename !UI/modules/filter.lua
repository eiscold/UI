if not Load"filter" then
	return
end

local Filter = {}
Filter.y = 60
Filter.position = {
	[1] = {"BOTTOMRIGHT", ufTarget, "TOP", -80.5, Filter.y},
	[2] = {"BOTTOMRIGHT", ufTarget, "TOP", -41.5, Filter.y},
	[3] = {"BOTTOMRIGHT", ufTarget, "TOP", -2.5, Filter.y},
	[4] = {"BOTTOMLEFT", ufTarget, "TOP", 2.5, Filter.y},
	[5] = {"BOTTOMLEFT", ufTarget, "TOP", 41.5, Filter.y},
	[6] = {"BOTTOMLEFT", ufTarget, "TOP", 80.5, Filter.y},
}
Filter.spells = {
	["DEATHKNIGHT"] = {
    -- Ebon Plague
    {spellId = 51735, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[3]},
    -- Frost Fever
    {spellId = 55095, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[1]},
    -- Blood Plague
    {spellId = 55078, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[2]},
    -- Unholy Blight
    {spellId = 50536, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
	-- Killing Machine
	{spellId = 51124, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
	-- Rime (Freezing Fog)
	{spellId = 59052, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
	-- Desolation
	{spellId = 66803, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
	-- Icebond Fortitude
	{spellId = 48792, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[5]},
	-- Vampiric Blood, Unbreakable Armor, Bone Shield 
	{spellId = 55233, spellId2 = 51271, spellId3 = 49222, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[6]},
	-- Anti-magic shield and zone
	{spellId = 48707, spellId2 = 50461, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[6]},
	},

    ["DRUID"] = {
    -- Insect Swarm
	{spellId = 27013, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    -- Moonfire
    {spellId = 26988, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[4]},
    -- Entangling Roots
    {spellId = 26989, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[6]},
    -- Earth and Moon, Ebon Plague, CoE
    {spellId = 48511, spellId2 = 51735, spellId3 = 47865, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[3]},
    -- Eclipse
    {spellId = 48525, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[1]},
	-- Lacerate
    {spellId = 48568, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[2]},
    -- Rake
    {spellId = 48574, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[3]},
    -- Rip
    {spellId = 49800, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[4]},
    -- Mangle
    {spellId = 48566, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    -- Barkskin
    {spellId = 22812, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[1]},
    -- Survival Instincts
    {spellId = 61336, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Savage roar
    {spellId = 52610, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[1]},
    },

    ["HUNTER"] = {
    -- Hunter's Mark
    {spellId = 53338, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[1]},
    -- Serpent Sting
    {spellId = 49001, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[6]},
    -- Black Arrow
    {spellId = 63672, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    -- Explosive Shot DoT
    {spellId = 60053, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[2]},
    -- Lock and Load
    {spellId = 56453, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Aspect of the Viper
    {spellId = 34074, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
    },

    ["MAGE"] = {
    -- Living Bomb
    {spellId = 55360, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[4]},
    -- Fingers of Frost (Frost), Missile Barrage (Arcane), Hot Streak (Fire)
    {spellId = 44545, spellId2 = 54490, spellId3 = 44448, size = 34, unitId = "player", isMine = all, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Fireball! 
    {spellId = 57761, size = 34, unitId = "player", isMine = "all", filter = "HELPFULL", setPoint = Filter.position[6]},
    -- Clear Casting
    {spellId = 12536, size = 34, unitId = "player", isMine = all, filter = "HELPFUL", setPoint = Filter.position[4]},
    -- Fiery Payback (Rank 1 and 2)
    {spellId = 44440, spellId2 = 44441, size = 34, unitId = "player", isMine = "all", filter = "HELPFULL", setPoint = Filter.position[6]},
    -- Impact
    {spellId = 12358, size = 34, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = Filter.position[1]},
    -- Arcane Blast debuff 
    {spellId = 36032, size = 34, unitId = "player", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[4]},
    -- Spell Crit - Winter's Chill (Frost), Improved Scorch (Fire)
    {spellId = 28593, spellId2 = 22959, size = 34, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = Filter.position[2]},  
    -- Polymorph - Sheep, Pig, Turkey, Black Cat, Rabbit, Turtle, 
    {spellId = 12826, spellId2 = 28272, spellId3 = 61780, spellId4 = 61305, spellId5 = 61721, spellId6 = 28271, size = 34, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = Filter.position[1]},
    -- Slow (Arcane), Ignite (Fire), Frostbite (Frost)
    {spellId = 31589, spellId2 = 12848, spellId3 = 12497, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    },

    ["PALADIN"] = {
    -- Art of War
    {spellId = 53488, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[1]},
    -- Vengeance
    {spellId = 20053, spellId = 20052, spellId = 20050, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Holy Shield
    {spellId = 20927, spellId = 20928, spellId = 27179, spellId = 48951, spellId = 48952, spellId = 20925, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[1]},
	-- Lights Grace
	{spellId = 31836 , size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Divine Plea
	{spellId = 54428 , size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
    -- Forbearance
	{spellId = 25771, size = 34, unitId = "player", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[2]},
    -- Attack speed debuff: warrior clap, feral wounds, dk frost fever, shamans earth shock, prot paladins judgment
    {spellId = 6343, spellId2 = 48485, spellId3 = 55095, spellId4 = 49231, spellId5 = 53696,  size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[5]},
    -- Attack power debuff: warrior shout, druid roar, lock curse, paladins vindication
    {spellId = 1160, spellId2 = 48560, spellId3 = 50511, spellId4 = 26017, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[6]},
 	},

    ["PRIEST"] = {
    -- PW:Shield on self
    {spellId = 48066, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[1]},
	-- Serendipity, Holy Concentration
	{spellId = 63734, spellId2 = 63725, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[4]},
    -- Renew on target
    {spellId = 25222, size = 34, unitId = "target", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- PW:Shield on target
    {spellId = 48066, size = 34, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[2]},
    -- Surge of Light, Borrowed Time
    {spellId = 33151, spellId2 = 59891, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[5]},
    -- SW:Pain
    {spellId = 48125, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[4]},
    -- VT (shadow)
    {spellId = 48160, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[3]},
    -- Shadow Weaving
	{spellId = 15332, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[6]},
    -- Devouring Plague
    {spellId = 48300, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    },

    ["ROGUE"] = {
	-- Deadly Poison
    {spellId = 57970, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[1]},
	-- Wound Poison 
    {spellId = 57975, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[2]},
   	-- Crippling Poison 
	{spellId = 44289, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    -- Mind-numbing Poison
    {spellId = 41190, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[6]},
	-- Slice and Dice
	{spellId = 6774, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
	-- Rupture
	{spellId = 48672, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},	
    },

    ["SHAMAN"] = {
    -- Hex
    {spellId = 51514, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[6]},
    -- Water Shield, Earth Shield, Lightning Shield
    {spellId = 57960, spellId2 = 49284, spellId3 = 49281, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[1]},
    -- Tidal Waves (resto), Maelstrom (ench)
    {spellId = 53390, spellId2 = 53817, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Flame Shock, Frost Shock
    {spellId = 49233, spellId2 = 49236, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[2]},
    -- ES on target (resto)
    {spellId = 49284, size = 34, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[2]},
    -- Riptide (resto)
    {spellId = 61301, size = 34, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[4]},
    },

    ["WARLOCK"] = {
    -- CoE, Ebon Plague, Earth and Moon
    {spellId = 47865, spellId2 = 51735, spellId3 = 48511, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[1]},
    -- CoT, CoE, CoW
    {spellId = 11719, spellId2 = 18223, spellId3 = 50511, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[1]},
    -- Molten Core(destro), Shadow Trance (afflict)
    {spellId = 47383, spellId2 = 17941, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[2]},
    -- Decimation (demo), Backdraft (destro), Eradication (afflict)
    {spellId = 63158, spellId2 = 54277, spellId3 = 47195, spellId4 = 47196, spellId5 = 47197, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Immolation, Unstable Affliction (afflict)
    {spellId = 47811, spellId2 = 47843, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[4]},
    -- Corruption
    {spellId = 47813, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[5]},
    -- CoA, CoD
    {spellId = 47864, spellId2 = 47867, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[6]},
    -- Haunt
	{spellId = 48181, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[6]},
	-- Life Tap
	{spellId = 63321, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[5]},
	-- Backlash
	{spellId = 34936, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
	},

    ["WARRIOR"] = {
    -- Instant Slam!
    {spellId = 46916, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Sudden Death
    {spellId = 52437, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = Filter.position[3]},
    -- Hamstring
    {spellId = 1715, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[6]},
    -- Rend
    {spellId = 47465, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = Filter.position[4]},
    -- Instant Shield Slam
    {spellId = 50227, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[3]},
	-- Last Stand
	{spellId = 12975, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[6]},
	-- Shield Wall
	{spellId = 871, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = Filter.position[4]},
	-- Armor debuff - major: sunder, expose
    {spellId = 7386, spellId2 = 48669, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[1]},
    -- Attack speed debuff: warrior clap, feral wounds, dk frost fever, shamans earth shock, prot paladins judgment
    {spellId = 6343, spellId2 = 48485, spellId3 = 55095, spellId4 = 49231, spellId5 = 53696,  size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[5]},
    -- Attack power debuff: warrior shout, druid roar, lock curse, paladins vindication
    {spellId = 1160, spellId2 = 48560, spellId3 = 50511, spellId4 = 26017, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = Filter.position[2]},
    }
}

local MyUnits = {
    player = true,
    vehicle = true,
    pet = true,
}

local function CreateFilterFrame(data)
    local spellName, _, spellIcon = GetSpellInfo(data.spellId)
    local frame = CreateFrame("Frame", "filter_".. data.unitId.."_"..data.spellId, UIParent)
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
    end)
	frame.icon = frame:CreateTexture("$parentIcon", "BACKGROUND")
    frame.icon:SetAllPoints(frame)
    frame.icon:SetTexture(spellIcon)
    frame.icon:SetTexCoord(.1, .9, .1, .9)
    frame.count = frame:CreateFontString(nil, "OVERLAY")
    frame.count:SetFont(FONT, 13, "OUTLINE")
    frame.count:SetTextColor(1, 1, 1)
    frame.count:SetPoint"TOPRIGHT"
    frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
    frame.cooldown:SetPoint"TOPLEFT"
    frame.cooldown:SetPoint"BOTTOMRIGHT"
    frame.cooldown:SetReverse()
	CreateBG(frame)
end

if Filter.spells and Filter.spells[PCLASS] then
    for index in pairs(Filter.spells) do
        if index ~= PCLASS then
            Filter.spells[index] = nil
        end
    end
    for i = 1, #Filter.spells[PCLASS], 1 do
        CreateFilterFrame(Filter.spells[PCLASS][i])
    end
end