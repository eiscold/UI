if PCLASS ~= "SHAMAN" then
	return
end

local total = 0
local delay = 0.01

-- fire, earth, water, air
local colors = {
	[1] = {0.752,0.172,0.02},
	[2] = {0.741,0.580,0.04},		
	[3] = {0,0.443,0.631},
	[4] = {0.6,1,0.945},	
}

local function Abbrev(name)	
	return (string.len(name) > 10) and string.gsub(name, "%s*(.)%S*%s*", "%1. ") or name
end

local function TotemOnClick(self, ...)
	local id = self.ID
	local mouse = ...
		if IsShiftKeyDown() then
			for j = 1, 4 do 
				DestroyTotem(j)
			end 
		else 
			DestroyTotem(id) 
		end
end
	
local function InitDestroy(self)
	for i = 1 , 4 do
		local Destroy = CreateFrame("Button", nil, self.TotemBar[i])
		Destroy:SetAllPoints(self.TotemBar[i])
		Destroy:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		Destroy.ID = i
		Destroy:SetScript("OnClick", TotemOnClick)
	end
end

local function UpdateSlot(self, slot)
	haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)
	self.TotemBar[slot]:SetStatusBarColor(unpack(self.TotemBar.colors[slot]))
	self.TotemBar[slot]:SetValue(0)
	if self.TotemBar[slot].bg.multiplier then
		local mu = self.TotemBar[slot].bg.multiplier
		local r, g, b = GetMyColor()
		r, g, b = r * mu, g * mu, b * mu
		self.TotemBar[slot].bg:SetVertexColor(r, g, b) 
	end
	self.TotemBar[slot].ID = slot
	if haveTotem then
		if self.TotemBar[slot].Name then
			self.TotemBar[slot].Name:SetText(Abbrev(name))
		end					
		if duration >= 0 then
			self.TotemBar[slot]:SetAlpha(1)
			self.TotemBar[slot]:SetValue(1 - ((GetTime() - startTime) / duration))	
			self.TotemBar[slot]:SetScript("OnUpdate", function(self, elapsed)
					total = total + elapsed
					if total >= delay then
						total = 0
						haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(self.ID)
							if (GetTime() - startTime) == 0 then
								self:SetValue(0)
							else
								self:SetValue(1 - ((GetTime() - startTime) / duration))
							end
					end
				end)					
		else
			self.TotemBar[slot]:SetScript("OnUpdate", nil)
			self.TotemBar[slot]:SetValue(0)
		end 
	else
		if self.TotemBar[slot].Name then
			self.TotemBar[slot].Name:SetText" "
		end
		self.TotemBar[slot]:SetValue(0)
	end

end

local function Update(self, unit)
	for i = 1, 4 do 
		UpdateSlot(self, i)
	end
end

local function Event(self, event, ...)
	if event == "PLAYER_TOTEM_UPDATE" then
		UpdateSlot(self, ...)
	end
end

local function Enable(self, unit)
	if self.TotemBar then
		extendUnitFrame(self)	
		self:RegisterEvent("PLAYER_TOTEM_UPDATE" , Event)
		self.TotemBar.colors = setmetatable(self.TotemBar.colors or {}, {__index = colors})
		delay = self.TotemBar.delay or delay
		if self.TotemBar.Destroy then
			InitDestroy(self)
		end		
		TotemFrame:UnregisterAllEvents()		
		return true
	end	
end

local function Disable(self,unit)
	if self.TotemBar then
		self.TotemBar:Hide()
		shrinkUnitFrame(self)
		self:UnregisterEvent("PLAYER_TOTEM_UPDATE", Event)
		TotemFrame:Show()
	end
end
			
uf:AddElement("TotemBar", Update, Enable, Disable)