if not Load"scrolldown" then
	return
end

local ScrolldownFrame = CreateFrame"Frame"
ScrolldownFrame.delay = 30
ScrolldownFrame.funcs = {
	"ScrollUp",
	"ScrollDown",
	"ScrollToTop",
	"PageUp",
	"PageDown",
}
ScrolldownFrame.handlers = {}
ScrolldownFrame.running = {}
ScrolldownFrame.scrollDowns = {}
ScrolldownFrame:Hide()

local function Register(name, func, rate, ...)
	ScrolldownFrame.handlers[name] = {
		name = name,
		func = func,
		rate = rate or 0,
		...
	}
end

local function Start(name)
	ScrolldownFrame.handlers[name].elapsed = 0
	ScrolldownFrame.running[name] = true
	ScrolldownFrame:Show()
end

local function Stop(name)
	ScrolldownFrame.running[name] = nil
	if not next(ScrolldownFrame.running) then
		ScrolldownFrame:Hide()
	end
end

local function ResetFrame(name, frame)
	Stop(name.."DownTimeout")
	Start(name.."DownTick")
end

local function ScrollOnce(name, frame)
	if frame:AtBottom() then
		Stop(name.."DownTick")
	else
		ScrolldownFrame.scrollDowns[name](frame)
	end
end

for i = 1, 7 do
	local name = "ChatFrame" .. i
	local frame = _G[name]
	ScrolldownFrame.scrollDowns[name] = frame.ScrollDown
	Register(name.."DownTick", ScrollOnce, .1, name, frame)
	Register(name.."DownTimeout", ResetFrame, ScrolldownFrame.delay, name, frame)
	for _, func in ipairs(ScrolldownFrame.funcs) do
		local orig = frame[func]
		frame[func] = function(...)
			Stop(name.."DownTick")
			Start(name.."DownTimeout", 1)
			orig(...)
		end
	end
end

ScrolldownFrame:SetScript("OnUpdate", function (ScrolldownFrame, elapsed)
	for name, v in pairs(ScrolldownFrame.handlers) do
		if ScrolldownFrame.running[name] then
			v.elapsed = v.elapsed + elapsed
			if v.elapsed >= v.rate then
				v.func(unpack(v))
				v.elapsed = 0
			end
		end
	end
end)
