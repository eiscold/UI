if not Load"aero" then
	return
end

local Aero = CreateFrame"Frame"
Aero.alpha = true
Aero.duration = .15
Aero.scale = false
Aero.addons = {}
Aero.running = {}

local function Animate(frame)
	local value = frame.Aero.start + frame.Aero.diff * frame.Aero.total / Aero.duration
	if value <= 0 then
		value = .01
	end
	if Aero.alpha then
		frame:SetAlpha(value)
	end
	if Aero.scale then
		frame:SetScale(value)
	end
end

local function OnFinish(frame)
	if Aero.alpha then
		frame:SetAlpha(1)
	end
	if Aero.scale then
		frame:SetScale(1)
	end
	if frame.Aero.onfinishhide then
		frame.Aero.onfinishhide = nil
		HideUIPanel(frame)
		frame.Aero.hiding = nil
	end
end

local function OnUpdate(self, elapsed)
	for i, frame in next, Aero.running do
		frame.Aero.total = frame.Aero.total + elapsed
		if frame.Aero.total >= Aero.duration then
			frame.Aero.total = 0
			Aero.running[i] = nil
			OnFinish(frame)
		else
			Animate(frame)
		end
	end
end
Aero:SetScript("OnUpdate", OnUpdate)

local function OnShow(frame)
	if frame.Aero.hiding or Aero.running[frame] or InCombatLockdown() then
		return
	end
	tinsert(Aero.running, frame)
	frame.Aero.start = .5
	frame.Aero.diff = .5
end

local function OnHide(frame)
	if frame.Aero.hiding or Aero.running[frame] or InCombatLockdown() then
		return
	end
	tinsert(Aero.running, frame)
	frame.Aero.start = 1
	frame.Aero.diff = -.5
	frame.Aero.onfinishhide = true
	frame.Aero.hiding = true
	frame:Show()
end

local function RegisterFrames(...)
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		if type(arg) == "string" then
			local frame = _G[arg]
			if not frame and CFG.Debug then
				return print(UI_NAME.." Aero module: |cff98F5FF", select(i, ...), "|r not found")
			else
				frame.Aero = frame.Aero or {}
				frame.Aero.total = 0
				frame:HookScript("OnShow", OnShow)
				frame:HookScript("OnHide", OnHide)
			end
		else
			arg()
		end
	end
end

local function OnEvent(self, event, addon)
	if Aero.addons[addon] then
		RegisterFrames(unpack(Aero.addons[addon]))
		Aero.addons[addon] = nil
	end
end
Aero:RegisterEvent"ADDON_LOADED"
Aero:SetScript("OnEvent", OnEvent)

local function RegisterAddon(addon, ...)
	if IsAddOnLoaded(addon) then
		RegisterFrames(...)
	else
		local _, _, _, enabled = GetAddOnInfo(addon)
		if enabled then
			Aero.addons[addon] = {}
			for i = 1, select("#", ...) do
				local arg = select(i, ...)
				tinsert(Aero.addons[addon], arg)
			end
		end
	end
end

RegisterFrames(
	"ArenaFrame",
	"ArenaRegistrarFrame",
	"AudioOptionsFrame",
	"BattlefieldFrame",
	"CharacterFrame",
	"ChatConfigFrame",
	"ColorPickerFrame",
	"FriendsFrame",
	"GameMenuFrame",
	"GearManagerDialog",
	"GossipFrame",
	"GuildInfoFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemRefTooltip",
	"LFDParentFrame",
	"LootFrame",
	"MailFrame",
	"MerchantFrame",
	"OpacityFrame",
	"OpenMailFrame",
	"PetStableFrame",
	"PVPParentFrame",
	"PVPTeamDetails",
	"QuestLogDetailFrame",
	"QuestLogFrame",
	"ReputationDetailFrame",
	"SpellBookFrame",
	"StackSplitFrame",
	"TabardFrame",
	"TradeFrame",
	"VideoOptionsFrame",
	"WorldMapFrame",
	"WorldStateScoreFrame"
)

RegisterAddon("Blizzard_AchievementUI", "AchievementFrame")
RegisterAddon("Blizzard_AuctionUI", "AuctionFrame", "AuctionDressUpFrame")
RegisterAddon("Blizzard_BattlefieldMinimap", "BattlefieldMinimap")
RegisterAddon("Blizzard_Calendar", "CalendarFrame")
RegisterAddon("Blizzard_CraftUI", "CraftFrame")
RegisterAddon("Blizzard_GMSurveyUI", "GMSurveyFrame")
RegisterAddon("Blizzard_GuildBankUI", "GuildBankFrame")
RegisterAddon("Blizzard_ItemSocketingUI", "ItemSocketingFrame")
RegisterAddon("Blizzard_MacroUI", "MacroFrame")
RegisterAddon("Blizzard_TalentUI", "PlayerTalentFrame")
RegisterAddon("Blizzard_TradeSkillUI", "TradeSkillFrame")
RegisterAddon("Blizzard_TrainerUI", "ClassTrainerFrame")