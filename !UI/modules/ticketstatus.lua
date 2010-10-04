if not Load"ticketstatus" then
	return
end

local bg, bd = CreateBG(TicketStatusFrame)
bg:SetTexture(0, 0, 0, 0.7)
bd:SetBackdropColor(0, 0, 0, 0.7)
TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -10, 0)
TicketStatusFrameButton:SetAlpha(0)
TicketStatusFrame:SetHeight(50)