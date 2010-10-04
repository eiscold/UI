if not Load"scrolldown" then
	return
end

local delay = 20
local funcs = {
	"ScrollUp",
	"ScrollDown",
	"ScrollToTop",
	"PageUp",
	"PageDown",
}
local handlers = {}
local running = {}
local scrolldowns = {}

local ScrolldownFrame = CreateFrame"Frame"
ScrolldownFrame:Hide()
ScrolldownFrame:SetScript("OnUpdate", function (ScrolldownFrame, elapsed)
	for name, v in pairs(handlers) do
		if running[name] then
			v.elapsed = v.elapsed + elapsed
			if v.elapsed >= v.rate then
				v.func(unpack(v))
				v.elapsed = 0
			end
		end
	end
end)

local function Register(name, func, rate, ...)
	handlers[name] = {
		name = name,
		func = func,
		rate = rate or 0,
		...
	}
end

local function Start(name)
	handlers[name].elapsed = 0
	running[name] = true
	ScrolldownFrame:Show()
end

local function Stop(name)
	running[name] = nil
	if not next(running) then
		ScrolldownFrame:Hide()
	end
end

local function ResetFrame(name, ScrolldownFrame)
	Stop(name.."DownTimeout")
	Start(name.."DownTick")
end

local function ScrollOnce(name, ScrolldownFrame)
	if ScrolldownFrame:AtBottom() then
		Stop(name.."DownTick")
	else
		scrolldowns[name](ScrolldownFrame)
	end
end

for i = 1, 7 do
	local name = "ChatFrame" .. i
	local frame = _G[name]
	scrolldowns[name] = frame.ScrollDown
	Register(name.."DownTick", ScrollOnce, 0.1, name, frame)
	Register(name.."DownTimeout", ResetFrame, delay, name, frame)
	for _, func in ipairs(funcs) do
		local orig = frame[func]
		frame[func] = function(...)
			Stop(name.."DownTick")
			Start(name.."DownTimeout", 1)
			orig(...)
		end
	end
end


