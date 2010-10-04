CFG = {
	AutoBuy = true,
	AutoDisenchant = true,
	AutoInvite = true,
	AutoSell = true,
	ClassColored = true,
	PowerColored = true,
	ConfirmBoPorDE = true,
	EcoFrameRate = true,
	LeaveParty = true,

	RaidFrameStyle = "grid", -- normal or grid
	UnitFrameStyle = "normal", -- normal or heal

	Debug = false,
}

local healers = "Kalgram,"
CFG.UnitFrameStyle = healers:find(PNAME) and "heal" or "normal"
CFG.RaidFrameStyle = CFG.UnitFrameStyle == "heal" and "grid" or "normal"