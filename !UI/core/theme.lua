local SkinFrame = CreateFrame("Frame", nil, UIParent)
SkinFrame.color = RAID_CLASS_COLORS[select(2, PCLASS)]
SkinFrame.buttons = {
	"VideoOptionsFrameOkay",
	"VideoOptionsFrameCancel",
	"VideoOptionsFrameDefaults",
	"VideoOptionsFrameApply",
	"AudioOptionsFrameOkay",
	"AudioOptionsFrameCancel",
	"AudioOptionsFrameDefaults",
	"InterfaceOptionsFrameDefaults",
	"InterfaceOptionsFrameOkay",
	"InterfaceOptionsFrameCancel",
	"ChatConfigFrameOkayButton",
	"ChatConfigFrameDefaultButton"
}
SkinFrame.dialogs = {
	"StaticPopup1",
	"StaticPopup2",
	"GameMenuFrame",
	"InterfaceOptionsFrame",
	"VideoOptionsFrame",
	"AudioOptionsFrame",
	"LFDDungeonReadyStatus",
	"ChatConfigFrame",
	"AutoCompleteBox",
}
SkinFrame.headers = {
	"GameMenuFrame",
	"InterfaceOptionsFrame",
	"AudioOptionsFrame",
	"VideoOptionsFrame",
	"ChatConfigFrame"
}
SkinFrame.menus = {
	"Options",
	"SoundOptions",
	"UIOptions",
	"Keybindings",
	"Macros",
	"AddOns",
	"Logout",
	"Quit",
	"Continue",
	"MacOptions"
}

local function Reskin(frame)
	frame.glow = CreateFrame("Frame", nil, frame)
	frame.glow:SetBackdrop(BACKDROP)
	frame.glow:SetPoint("TOPLEFT", frame, -5, 5)
	frame.glow:SetPoint("BOTTOMRIGHT", frame, 5, -5)
	frame.glow:SetBackdropBorderColor(SkinFrame.color.r, SkinFrame.color.g, SkinFrame.color.b)
	frame.glow:SetAlpha(0)
	frame:SetNormalTexture""
	frame:SetHighlightTexture""
	frame:SetPushedTexture""
	frame:SetDisabledTexture""
	CreateBG(frame, .25)
	frame:HookScript("OnEnter", function(self)
		self:SetBackdropBorderColor(SkinFrame.color.r, SkinFrame.color.g, SkinFrame.color.b)
		self:SetBackdropColor(SkinFrame.color.r, SkinFrame.color.g, SkinFrame.color.b, .1)
		CreatePulse(self.glow)
	end)
 	frame:HookScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
		self:SetBackdropColor(0, 0, 0, .25)
		self.glow:SetScript("OnUpdate", nil)
		self.glow:SetAlpha(0)
	end)
end

SkinFrame:RegisterEvent"ADDON_LOADED"
SkinFrame:SetScript("OnEvent", function(self, event, addon)	
	if addon == UI_NAME then			 
		for i = 1, 2 do
			for j = 1, 2 do
				Reskin(_G["StaticPopup"..i.."Button"..j])
			end
		end
		for i = 1, #SkinFrame.dialogs do
			CreateBG(_G[SkinFrame.dialogs[i]])
			CreateBG(_G[SkinFrame.dialogs[i]])
		end

		CreateBG(ChatConfigCategoryFrame, .25)
		CreateBG(ChatConfigBackgroundFrame, .25)
		CreateBG(ChatConfigChatSettingsLeft, .25)
		CreateBG(ChatConfigChatSettingsClassColorLegend, .25)

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:ClearAllPoints()
		ChatConfigFrameDefaultButton:SetPoint("TOP", ChatConfigCategoryFrame, "BOTTOM", 0, -4)
		ChatConfigFrameOkayButton:ClearAllPoints()
		ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)
		 
		for i = 1, #SkinFrame.menus do
			local button = _G["GameMenuButton"..SkinFrame.menus[i]]
			if button then
				Reskin(button)
			end
		end
		for i = 1, #SkinFrame.headers do
			local title = _G[SkinFrame.headers[i].."Header"]
			if title then
				title:SetTexture""
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", SkinFrame.headers[i], 0, 0)
				end
			end
		end
		for i = 1, #SkinFrame.buttons do
			local reskinbutton = _G[SkinFrame.buttons[i]]
			if reskinbutton then
				reskin(reskinbutton)
			end
		end

		_G["VideoOptionsFrameCancel"]:ClearAllPoints()
		_G["VideoOptionsFrameCancel"]:SetPoint("RIGHT", _G["VideoOptionsFrameApply"], "LEFT", -4, 0)		 
		_G["VideoOptionsFrameOkay"]:ClearAllPoints()
		_G["VideoOptionsFrameOkay"]:SetPoint("RIGHT", _G["VideoOptionsFrameCancel"], "LEFT", -4, 0)	
		_G["AudioOptionsFrameOkay"]:ClearAllPoints()
		_G["AudioOptionsFrameOkay"]:SetPoint("RIGHT", _G["AudioOptionsFrameCancel"], "LEFT", -4, 0)		 	 
		_G["InterfaceOptionsFrameOkay"]:ClearAllPoints()
		_G["InterfaceOptionsFrameOkay"]:SetPoint("RIGHT", _G["InterfaceOptionsFrameCancel"], "LEFT", -4, 0)
	end
	if IsMacClient() then
		CreateBG(MacOptionsFrame)
		MacOptionsFrameHeader:SetTexture""
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame)
		CreateBG(MacOptionsFrameMovieRecording, .25)
		CreateBG(MacOptionsITunesRemote, .25)
		Reskin(_G["MacOptionsFrameCancel"])
		Reskin(_G["MacOptionsFrameOkay"])
		Reskin(_G["MacOptionsButtonKeybindings"])
		Reskin(_G["MacOptionsFrameDefaults"])
		Reskin(_G["MacOptionsButtonCompress"])
		_G["MacOptionsButtonCompress"]:SetWidth(136)
		_G["MacOptionsFrameCancel"]:SetWidth(96)
		_G["MacOptionsFrameCancel"]:SetHeight(22)
		_G["MacOptionsFrameCancel"]:ClearAllPoints()
		_G["MacOptionsFrameCancel"]:SetPoint("LEFT", _G["MacOptionsButtonKeybindings"], "RIGHT", 107, 0)
		_G["MacOptionsFrameOkay"]:SetWidth(96)
		_G["MacOptionsFrameOkay"]:SetHeight(22)
		_G["MacOptionsFrameOkay"]:ClearAllPoints()
		_G["MacOptionsFrameOkay"]:SetPoint("LEFT", _G["MacOptionsButtonKeybindings"], "RIGHT", 5, 0)
		_G["MacOptionsButtonKeybindings"]:SetWidth(96)
		_G["MacOptionsButtonKeybindings"]:SetHeight(22)
		_G["MacOptionsButtonKeybindings"]:ClearAllPoints()
		_G["MacOptionsButtonKeybindings"]:SetPoint("LEFT", _G["MacOptionsFrameDefaults"], "RIGHT", 5, 0)
		_G["MacOptionsFrameDefaults"]:SetWidth(96)
		_G["MacOptionsFrameDefaults"]:SetHeight(22)
	end
end)