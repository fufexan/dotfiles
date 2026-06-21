--------------------------
---- ENVIRONMENT VARS ----
--------------------------
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("HYPRCURSOR_THEME", cursorName)
hl.env("HYPRCURSOR_SIZE", cursorSize)
-- See https://github.com/hyprwm/contrib/issues/142
hl.env("GRIMBLAST_NO_CURSOR", "0")

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor " .. cursorName .. " " .. cursorSize)
	hl.exec_cmd("hyprlock")
end)

--------------------------
---- GENERAL SETTINGS ----
--------------------------
hl.config({
	general = {
		gaps_in = gaps_in,
		gaps_out = gaps_out,
		border_size = 1,
		col = {
			active_border = active_border,
			inactive_border = inactive_border,
		},
		allow_tearing = true,
		resize_on_border = true,
	},

	decoration = {
		rounding = rounding,
		rounding_power = rounding_power,
		blur = {
			enabled = true,
			brightness = 1.0,
			contrast = 1.0,
			noise = 0.01,
			vibrancy = 0.2,
			vibrancy_darkness = 0.5,
			passes = 4,
			size = 7,
			popups = true,
			popups_ignorealpha = 0.2,
		},
		shadow = {
			enabled = true,
			color = "rgba(00000055)",
			offset = { 0, 15 },
			range = 100,
			render_power = 2,
			scale = 0.97,
		},
	},

	animations = {
		enabled = true,
	},

	group = {
		groupbar = {
			font_size = 12,
			font_weight_active = "bold",
			gradients = false,
			height = 20,
			indicator_height = 20,
			indicator_gap = -20,
			rounding = rounding,
			rounding_power = rounding_power,
			text_color = text_color,
			text_color_inactive = text_color_inactive,
			col = {
				active = group_active_color,
				inactive = group_inactive_color,
			},
		},
		col = {
			border_active = active_border,
			border_inactive = inactive_border,
		},
	},

	input = {
		kb_layout = "ro",
		follow_mouse = 1,
		focus_on_close = 1,
		accel_profile = "flat",
		tablet = {
			output = "current",
		},
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		force_default_wallpaper = 0,
		animate_mouse_windowdragging = false,
		vrr = 1,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		focus_on_activate = true,
	},

	gestures = {
		workspace_swipe_forever = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},

	debug = {
		disable_logs = false,
	},
})

--------------------
---- GESTURES ------
--------------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({
	fingers = 4,
	direction = "left",
	action = function()
		hl.dsp.window.move({ monitor = "-1" })
	end,
})
hl.gesture({
	fingers = 4,
	direction = "right",
	action = function()
		hl.dsp.window.move({ monitor = "+1" })
	end,
})
hl.gesture({
	fingers = 4,
	direction = "pinch",
	action = function()
		hl.dsp.window.fullscreen()
	end,
})

-----------------------
----- PERMISSIONS -----
-----------------------
for k, v in ipairs(screencopy_perms) do
	hl.permission({ binary = v, type = "screencopy", mode = "allow" })
end

-- plugin: hyprbars buttons (order is right-to-left)
-- close
-- "rgb(ffb4ab), 15, , hyprctl dispatch killactive"
-- maximize
-- "rgb(b6c4ff), 15, , hyprctl dispatch fullscreen 1"
