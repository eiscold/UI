if not Load"ticketstatus" then
	return
end

CreateBG(TicketStatusFrame, .7)
TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -10, 0)
TicketStatusFrameButton:SetAlpha(0)
TicketStatusFrame:SetHeight(50)