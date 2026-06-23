---------------------
---- KEYBINDINGS ----
---------------------

local function toggle(program)
	local prog = program:sub(1, 14)
	return "pkill " .. prog .. " || uwsm app -- " .. program
end

local function runOnce(program)
	return "pgrep " .. program .. " || uwsm app -- " .. program
end

-- mouse movements
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- compositor commands
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("pkill Hyprland"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + G", hl.dsp.group.toggle())
hl.bind(mod .. " + SHIFT + N", hl.dsp.group.next())
hl.bind(mod .. " + SHIFT + P", hl.dsp.group.prev())
hl.bind(mod .. " + R", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())

-- utility
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("uwsm app -- foot"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd(toggle("wlogout") .. " -p layer-shell"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + I", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + O", hl.dsp.exec_cmd(runOnce("wl-ocr")))
hl.bind("XF86Favorites", hl.dsp.exec_cmd(runOnce("wl-ocr")))
hl.bind("XF86Calculator", hl.dsp.exec_cmd(toggle("gnome-calculator")))
hl.bind(mod .. " + U", hl.dsp.exec_cmd("XDG_CURRENT_DESKTOP=gnome " .. runOnce("gnome-control-center")))

-- move focus
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- screenshot & screen record
local area_screenshot = runOnce("grimblast") .. " --notify copysave area"
local output_screenshot = runOnce("grimblast") .. " --notify copysave output"
local record = runOnce("gpu-screen-recorder-gtk")

hl.bind("Print", hl.dsp.exec_cmd(area_screenshot))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(area_screenshot))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(output_screenshot))
hl.bind(mod .. " + SHIFT + CTRL + R", hl.dsp.exec_cmd(output_screenshot))
hl.bind("ALT + Print", hl.dsp.exec_cmd(record))
hl.bind(mod .. " + SHIFT + ALT + R", hl.dsp.exec_cmd(record))

-- cycle workspaces
hl.bind(mod .. " + bracketleft", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + bracketright", hl.dsp.focus({ workspace = "m+1" }))

-- cycle monitors
hl.bind(mod .. " + SHIFT + bracketleft", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + bracketright", hl.dsp.focus({ monitor = "r" }))

-- send focused workspace to left/right monitors
hl.bind(mod .. " + SHIFT + ALT + bracketleft", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + ALT + bracketright", hl.dsp.workspace.move({ monitor = "r" }))

-- workspaces 1-10
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- launcher (release bind)
-- hl.bind(mod .. " + SUPER_L", hl.dsp.exec_cmd("vicinae toggle"), { release = true })

hl.bind(mod .. " + SUPER_L", function()
	local ws = hl.get_active_workspace()
	if not ws.has_fullscreen then
		hl.dispatch(hl.dsp.exec_cmd("vicinae toggle"))
	end
end, { release = true })

-- media controls (locked)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- volume (locked + repeating)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"),
	{ locked = true, repeating = true }
)

-- backlight (locked + repeating)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brillo -q -u 300000 -A 5"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brillo -q -u 300000 -U 5"), { locked = true, repeating = true })
