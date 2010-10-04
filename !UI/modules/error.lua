if not Load"error" then
	return
end

UIErrorsFrame:UnregisterEvent"UI_ERROR_MESSAGE"

if not CFG.Debug then
	INTERFACE_ACTION_BLOCKED = ""
end