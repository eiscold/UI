if not Load"mirrorbars" then
	return
end

for i = 1, 3 do
	_G["MirrorTimer"..i]:SetParent(UIParent)
	_G["MirrorTimer"..i]:SetScale(1)
	_G["MirrorTimer"..i]:SetHeight(12)
	_G["MirrorTimer"..i]:SetWidth(Minimap:GetWidth() - 14)
	_G["MirrorTimer"..i]:ClearAllPoints()
	_G["MirrorTimer"..i]:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 6 * i + 12 * (i - 1))
	CreateBG(_G["MirrorTimer"..i], .7)
	_G["MirrorTimer"..i]:GetRegions():Hide()
	_G["MirrorTimer"..i.."Border"]:Hide()
	_G["MirrorTimer"..i.."Text"] = CreateFS(_G["MirrorTimer"..i], 12)
	_G["MirrorTimer"..i.."Text"]:ClearAllPoints()
	_G["MirrorTimer"..i.."Text"]:SetPoint("CENTER", _G["MirrorTimer"..i.."StatusBar"], "CENTER")
	_G["MirrorTimer"..i.."StatusBar"]:ClearAllPoints()
	_G["MirrorTimer"..i.."StatusBar"]:SetAllPoints(bar)
end

hooksecurefunc("MirrorTimer_Show", function()
	for i = 1, 3 do
		_G["MirrorTimer"..i.."StatusBar"]:SetStatusBarColor(GetMyColor())
	end
end)