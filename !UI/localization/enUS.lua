if L.locale == "enUS" then
-- zones, localization needed
	L["Dalaran"] = "Dalaran"
	L["Krasus"] = "Krasus"
	L["Wintergrasp"] = "Wintergrasp" -- needs localization

-- dialogs
	L["Invite"] = "%s wants to invite you"
	L["PurchaseBuy"] = "Buy a new slot with /bank "..string.lower(PURCHASE).." "..string.lower(YES)
	L["PurchaseFull"] = "Can't buy anymore slots"
	L["PurchaseOpenFirst"] = "You need to open your bank first"
	L["SummonMissed"] = "Summoning missed"
	L["SummonNew"] = "%s wants to summon you to %s"

-- arena / bg timers
	L["1 minute"] = "1 minute"
	L["60 seconds"] = "60 seconds"
	L["30 seconds"] = "30 seconds"
	L["15 seconds"] = "15 seconds"
	L["One minute"] = "One minute"
	L["Forty five seconds"] = "Forty five seconds"
	L["Thirty seconds"] = "Thirty seconds"
	L["Fifteen seconds"] = "Fifteen seconds"

-- professions
	L["Alchemy"] = "Alchemy"
	L["Blacksmithing"] = "Blacksmithing"
	L["Cooking"] = "Cooking"	
	L["Enchanting"] = "Enchanting"
	L["Engineering"] = "Engeneering"
	L["Inscription"] = "Inscription"
	L["Jewelcrafting"] = "Jewelcrafting"
	L["Leatherworking"] = "Leatherworking"
	L["Tailoring"] = "Tailoring"

-- loot
	L["Disenchant"] = "Disenchant"
	L["wins"] = "wins"
	L["won"] = "won"

-- texts
	L["LootRollAllPassed"] = "All passed on %s"
	L["LootRollPassedAuto"] = "%s => %s (auto)"
	L["LootRollPassedSelfAuto"] = "pass %s (auto)"
	L["Mobs to level up"] = "Mobs to level up"
		
	L.localized = true
end