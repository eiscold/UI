local UILoad = {
	Loading = true,

	["actionbar"]		= { load = true, },
	["align"]			= { load = true, },
	["aero"]			= { load = true, },
	["bags"]			= { load = true, },
	["buttons"]			= { load = true, },
	["chat"]			= { load = true, },
	["combattext"]		= { load = true, },
	["cooldown"]		= { load = true, },
	["coolline"]		= { load = true, },
	["dps"]				= { load = true, },
	["durability"]		= { load = true, },
	["error"]			= { load = true, },
	["events"]			= { load = true, },
	["exprepbar"]		= { load = true, },
	["fade"]			= { load = true, },
	["filter"]			= { load = true, },
	["gearscore"]		= { load = true, },
	["grouploot"]		= { load = true, },
	["itemglow"]		= { load = true, },
	["loot"]			= { load = true, },
	["mail"]			= { load = true, },
	["map"]				= { load = true, },
	["marking"]			= { load = true, },
	["minimap"]			= { load = true, },
	["mirrorbars"]		= { load = true, },
	["mount"]			= { load = true, localization = true, },
	["nameplates"]		= { load = true, },
	["proflink"]		= { load = true, },
	["pvp"]				= { load = true, localization = true, },
	["raidnames"]		= { load = true, },
	["raidstatus"]		= { load = true, },
	["raidwarningfont"] = { load = true, },
	["rangecolor"]		= { load = true, },
	["reagents"]		= { load = true, class = "DRUID MAGE PALADIN PRIEST SHAMAN", },
	["reminder"]		= { load = true, },
	["scrolldown"]		= { load = true, },
	["spamthrottle"]	= { load = true, },
	["stats"]			= { load = true, },
	["summon"]			= { load = true, },
	["tabs"]			= { load = true, },
	["threatmeter"]		= { load = true, },
	["ticketstatus"]	= { load = true, },
	["tooltip"]			= { load = true, },
	["watchframe"]		= { load = true, },
	["zonetext"]		= { load = true, },

	["unitframes"]		= { load = true, },
}

function Load(name)
	local msg
	local state = false
	if UILoad[name].load and UILoad.Loading then
		if not UILoad[name].class or UILoad[name].class:find(PCLASS) then
			if not UILoad[name].localization then
				msg = "|cFF00FF00"..name.." loaded|r"
				state = true
			else
				if not L.localized then
					msg = "|cFFFF0000"..name.." not loaded (localization missing: "..L.locale..")|r"
					state = false
				elseif L.localized then
					msg = "|cFF00FF00"..name.." loaded|r"
					state = true
				end
			end
		else
			msg = "|cFFFF0000"..name.." not loaded (not designed for this class)|r"
			state = false
		end
	else
		msg = "|cFFFF0000"..name.." not loaded (disabled)|r"
		state = false
	end
	if CFG.Debug then
		print(msg)
	end
	return state
end

print(UI_NAME.." "..UI_VERSION.." by "..UI_AUTHOR)