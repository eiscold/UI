if L.locale == "deDE" then
	L["Install"] = "Installieren"

-- zones, localization needed
	L["Dalaran"] = "Dalaran"
	L["Krasus"] = "Krasus"
	L["Wintergrasp"] = "Tausendwintersee" -- needs localization

-- dialogs
	L["Invite"] = "%s will dich einladen"
	L["PurchaseBuy"] = "Kaufe einen neuen Bankplatz mit /bank "..string.lower(PURCHASE).." "..string.lower(YES)
	L["PurchaseFull"] = "Kann keine weiteren Taschenpl\195\164tze kaufen" --ä
	L["PurchaseOpenFirst"] = "Du musst zuerst das Bankfenster \195\182ffnen" --ö
	L["SummonMissed"] = "Beschw\195\182rung verpasst" --ö
	L["SummonNew"] = "%s will dich nach %s beschw\195\182ren" --ö

-- arena / bg timers
	L["1 minute"] = "1 Minute"
	L["60 seconds"] = "60 Sekunden"
	L["30 seconds"] = "30 Sekunden"
	L["15 seconds"] = "15 Sekunden"
	L["One minute"] = "Eine Minute"
	L["Forty five seconds"] = "F\195\188nfundvierzig Sekunden" --ü
	L["Thirty seconds"] = "Drei\195\159ig Sekunden" --ß
	L["Fifteen seconds"] = "F\195\188nfzehn Sekunden" --ü

-- professions
	L["Alchemy"] = "Alchimie"
	L["Blacksmithing"] = "Schmiedekunst"
	L["Cooking"] = "Kochkunst"
	L["Enchanting"] = "Verzauberkunst"
	L["Engineering"] = "Ingenieurskunst"
	L["Inscription"] = "Inschriftenkunde"
	L["Jewelcrafting"] = "Juwelenschleifen"
	L["Leatherworking"] = "Lederverarbeitung"
	L["Tailoring"] = "Schneiderei"

-- loot
	L["Disenchant"] = "Entzaubern"
	L["wins"] = "gewinnt"
	L["won"] = "gewinnst"

-- texts
	L["LootRollAllPassed"] = "Alle passen auf %s"
	L["LootRollPassedAuto"] = "%s => %s (auto)"
	L["LootRollPassedSelfAuto"] = "Passe %s (auto)"
	L["Mobs to level up"] = "Mobs bis zum Levelaufstieg"
	
	L.localized = true
end