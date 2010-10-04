local raidAddons = {
	"DXE",
	"DXE_Loader",
	"DXE_Kalimdor",
	"DXE_Citadel",
	"DXE_Northrend",
	"DXE_Coliseum",
	"DXE_Naxxramas",
	"DXE_Ulduar",
	"epgp",
	"epgploot2",
	"PhoenixStyle",
	"PhoenixStyleMod_Coliseum",
	"PhoenixStyleMod_Icecrown",
	"PhoenixStyleMod_Ulduar",
	"Recount",
	"yLoot3",
}
SlashCmdList.ADDONS = function(msg)
	if not msg then
		return
	end
	if string.lower(msg) == "raid" then
        for i in pairs(raidAddons) do
        	EnableAddOn(raidAddons[i])
        end
	else
		for i in pairs(raidAddons) do
        	DisableAddOn(raidAddons[i])
        end
	end
	ReloadUI()
end
SLASH_ADDONS1 = "/addons"
SLASH_ADDONS2 = "/ad"

SlashCmdList.COLLECTGARBAGE = function()
	local oldcount = collectgarbage"count"
	collectgarbage()
	local count = collectgarbage"count"
	print("Garbage collected: "..tostring(math.floor(oldcount - count)).."kb")
end
SLASH_COLLECTGARBAGE1 = "/cg"

SlashCmdList.EXPERIENCE = function()
	print(XP..": "..GetShortValue(UnitXP"player").." / "..GetShortValue(UnitXPMax"player").." | "..(("%%.%df"):format(1)):format(UnitXP"player" / UnitXPMax"player" * 100))
end
SLASH_EXPERIENCE1 = "/xp"
SLASH_EXPERIENCE2 = "/exp"

SlashCmdList.FRAME = function()
	print(GetMouseFocus():GetName())
end
SLASH_FRAME1 = "/gn"

SlashCmdList.GETPARENT = function()
	print(GetMouseFocus():GetParent():GetName())
end
SLASH_GETPARENT1 = "/gp"

SlashCmdList.GETPOINT = function()
	print(GetMouseFocus():GetPoint())
end
SLASH_GETPOINT1 = "/gpt"

SlashCmdList.PURCHASE = function(Cmd)
	local cmd, args = strsplit(" ", Cmd:lower(), 2)
	if cmd == string.lower(PURCHASE) then
		if BankFrame and BankFrame:IsShown() then
			local count, full = GetNumBankSlots()
			if full then
				print(L["PurchaseFull"])
				return
			end
			if args == string.lower(YES) then
				PurchaseSlot()
				return
			else
				print(string.format("%s %.2f g", COSTS_LABEL, GetBankSlotCost() / 10000))
				print(L["PurchaseBuy"])
			end
		else
			print(L["PurchaseOpenFirst"])
		end
	end
end
SLASH_PURCHASE1 = "/bank"

SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = "/rl"

SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = "/rc"

SlashCmdList.TICKET = ToggleHelpFrame
SLASH_TICKET1 = "/gm"
SLASH_TICKET2 = "/ticket"

SlashCmdList.MOBSTOLVLUP = function(mobexp)
	if tonumber(mobexp) > 0 then
		print(L["Mobs to level up"]..": "..math.ceil((tonumber(UnitXPMax"player") - tonumber(UnitXP"player")) / tonumber(mobexp)))
	end
end
SLASH_MOBSTOLVLUP1 = "/mobstolvlup"
SLASH_MOBSTOLVLUP2 = "/mtl"

SlashCmdList.SETUP = function()
	EnableAddOn"!Setup" LoadAddOn"!Setup"
end
SLASH_SETUP1 = "/setup"

SlashCmdList.SPELLID = function(find)
	if not find then
		print(PLAYERSTAT_SPELL_COMBAT.." "..string.lower(UNKNOWN))
	end
	local ids
	for i = 1, 100000 do
		local name, rank = GetSpellInfo(i)
		if string.lower(find) == string.lower(name or " ") then
			if ids then
				ids = ids..", "..tostring(i).." "..tostring(rank)
			else
				ids = tostring(i).." "..tostring(rank)
			end
		end
	end
	print(ids)
end
SLASH_SPELLID1 = "/spellid"

SlashCmdList.TELLTARGET = function(msg)
	if UnitExists"target" and UnitName"target" and UnitIsPlayer"target" and GetDefaultLanguage"player" == GetDefaultLanguage"target" then
		SendChatMessage(msg, "WHISPER", nil, UnitName"target")
	end
end
SLASH_TELLTARGET1 = "/tt"
SLASH_TELLTARGET2 = "/ее"