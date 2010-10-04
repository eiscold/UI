for _, frame in next, {"PlayerFrame", "TargetFrame", "TargetFrameToT", "PetFrame", "FocusFrame"} do
	_G[frame]:UnregisterAllEvents()
	_G[frame].Show = dummy
	_G[frame]:Hide()
	_G[frame.."HealthBar"]:UnregisterAllEvents()
	_G[frame.."ManaBar"]:UnregisterAllEvents()
end

for _, frame in next, {"ComboFrame", "CastingBarFrame", "PetCastingBarFrame"} do
	_G[frame]:UnregisterAllEvents()
	_G[frame].Show = dummy
	_G[frame]:Hide()
end

for i = 1, 4 do
	_G["PartyMemberFrame"..i]:UnregisterAllEvents()
	_G["PartyMemberFrame"..i].Show = dummy
	_G["PartyMemberFrame"..i]:Hide()
	_G["PartyMemberFrame"..i.."HealthBar"]:UnregisterAllEvents()
	_G["PartyMemberFrame"..i.."ManaBar"]:UnregisterAllEvents()
end

for i = 1, MAX_BOSS_FRAMES do
	_G["Boss"..i.."TargetFrame"]:UnregisterAllEvents()
	_G["Boss"..i.."TargetFrame"].Show = dummy
	_G["Boss"..i.."TargetFrame"]:Hide()
 	_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
	_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
end

FocusFrameSpellBar:UnregisterAllEvents()

local event_metatable = {
	__call = function(funcs, self, ...)
		for _, func in next, funcs do
			func(self, ...)
		end
	end,
}

local units, objects, elements = {}, {}, {}
local uf = {}
local style

local function OnEvent(self, event, ...)
	if not self:IsShown() then
		return
	end
	return self[event](self, event, ...)
end

local OnAttributeChanged = function(self, name, value)
	if name == "unit" and value then
		units[value] = self
		if self.unit and self.unit == value then
			return
		end
		self.unit = value
		self.id = value:match"^.-(%d+)"
		self:PLAYER_ENTERING_WORLD"PLAYER_ENTERING_WORLD"
	end
end

local frame_metatable = {__index = CreateFrame"Button"}

function frame_metatable.__index:PLAYER_ENTERING_WORLD()
	local unit = self.unit
	if not UnitExists(unit) then
		return
	end
	for _, func in next, self.__elements do
		func(self, event, unit)
	end
end

do
	local RegisterEvent = frame_metatable.__index.RegisterEvent
	function frame_metatable.__index:RegisterEvent(event, func)
		if type(func) == "string" then
			func = self[func]
		end
		local curev = self[event]
		if curev and func then
			if type(curev) == "function" then
				self[event] = setmetatable({curev, func}, event_metatable)
			else
				for _, infunc in next, curev do
					if infunc == func then
						return
					end
				end

				table.insert(curev, func)
			end
		elseif self:IsEventRegistered(event) then
			return
		else
			if func then self[event] = func end
			RegisterEvent(self, event)
		end
	end
end

local function walkObject(object, unit)	
	object.__elements = {}
	object = setmetatable(object, frame_metatable)
	style(object, unit)
	object:SetAttribute("*type1", "target")
	object:SetHeight(object:GetAttribute"initial-height")
	object:SetWidth(object:GetAttribute"initial-width")

	object:SetScript("OnEvent", OnEvent)
	object:SetScript("OnAttributeChanged", OnAttributeChanged)
	object:SetScript("OnShow", object.PLAYER_ENTERING_WORLD)
	object:RegisterEvent"PLAYER_ENTERING_WORLD"
	for _, element in next, elements do
		if element.enable(object, unit) then
			table.insert(object.__elements, element.update)
		end
	end
	table.insert(objects, object)
end

function uf:RegisterCurrentStyle(func)
	style = func
end

function uf:Spawn(unit, name)
	if unit == "header" then
		local header = CreateFrame("Frame", name, UIParent, "SecureGroupHeaderTemplate")
		header:SetAttribute("template", "SecureUnitButtonTemplate")
		header.initialConfigFunction = walkObject
		return header
	else
		local object = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
		object:SetAttribute("unit", unit)
		object.unit = unit
		object.id = unit:match"^.-(%d+)"
		units[unit] = object
		walkObject(object, unit)
		RegisterUnitWatch(object)
		if unit == "target" then
			object:RegisterEvent("PLAYER_TARGET_CHANGED", "PLAYER_ENTERING_WORLD")
		elseif unit == "focus" then
			object:RegisterEvent("PLAYER_FOCUS_CHANGED", "PLAYER_ENTERING_WORLD")
		end
		return object
	end
end

function uf:AddElement(name, update, enable, disable)
	if elements[name] then
		return error("Element [%s] is already registered", name)
	end
	elements[name] = {
		update = update;
		enable = enable;
		disable = disable;
	}
end

uf.units = units
uf.objects = objects
uf.colors = {
	runes = {
		{1, 0, 0},
		{0, .5, 0},
		{0, 1, 1},
		{.9, .1, 1}
	},
}
uf.elements = elements
uf.frame_metatable = frame_metatable
_G.uf = uf