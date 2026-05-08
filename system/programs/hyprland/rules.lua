--------------------------
---- LAYER RULES ---------
--------------------------

-- blurred + low opacity layers
hl.layer_rule({
  match = { namespace = "^(quickshell:notifications:overlay|quickshell:osd|vicinae|logout_dialog|quickshell:sidebar|quickshell:popup)$" },
  blur = true,
})
hl.layer_rule({
  match = { namespace = "^(quickshell:notifications:overlay|quickshell:osd)$" },
  ignore_alpha = 0.2,
})
hl.layer_rule({
  match = { namespace = "^(vicinae|logout_dialog|quickshell:sidebar|quickshell:popup)$" },
  ignore_alpha = 0.5,
})
hl.layer_rule({
  match = { namespace = "^quickshell.*$" },
  blur_popups = true,
})
hl.layer_rule({
  match = { namespace = "^(quickshell:bar)$" },
  ignore_alpha = 0.1,
})
hl.layer_rule({
  match = { namespace = "^(quickshell:notifications:overlay|quickshell:sidebar|quickshell:popup)$" },
  no_anim = true,
})

---------------------------
---- WINDOW RULES ---------
---------------------------

-- telegram media viewer
hl.window_rule({ match = { title = "^(Media viewer)$" }, float = true })

-- Bitwarden extension (Chromium)
hl.window_rule({ match = { class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default" }, float = true })

-- Bitwarden extension (Zen/Firefox, doesn't work)
hl.window_rule({ match = { title = "^(.*Bitwarden Password Manager.*)$" }, float = true })

-- gnome calculator
hl.window_rule({ match = { class = "^(org.gnome.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(org.gnome.Calculator)$" }, size = "360 490" })

-- allow tearing in games
hl.window_rule({ match = { class = "^(osu!|cs2)$" }, immediate = true })

-- make Firefox/Zen PiP window floating and sticky
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, pin = true })

-- throw sharing indicators away
hl.window_rule({ match = { title = "^(Firefox — Sharing Indicator)$" }, workspace = "special silent" })
hl.window_rule({ match = { title = "^(Zen — Sharing Indicator)$" }, workspace = "special silent" })
hl.window_rule({ match = { title = "^(.*is sharing (your screen|a window).)$" }, workspace = "special silent" })

-- start Spotify and YouTube Music in ws9
hl.window_rule({ match = { title = "^(Spotify( Premium)?)$" }, workspace = "9 silent" })
hl.window_rule({ match = { title = "^(YouTube Music)$" }, workspace = "9 silent" })

-- idle inhibit while watching videos
hl.window_rule({ match = { class = "^(mpv|.+exe|celluloid)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^(zen)$", title = "^(.*YouTube.*)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^(zen)$" }, idle_inhibit = "fullscreen" })

-- dim around dialogs
hl.window_rule({ match = { class = "^(gcr-prompter)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(zen)$", title = "^(File Upload)$" }, dim_around = true })

-- fix xwayland apps
hl.window_rule({ match = { xwayland = true }, rounding = 0 })
hl.window_rule({ match = { class = "^(.*jetbrains.*)$", title = "^(Confirm Exit|Open Project|win424|win201|splash)$" }, center = true })
hl.window_rule({ match = { class = "^(.*jetbrains.*)$", title = "^(splash)$" }, size = "640 400" })

-- Matlab
hl.window_rule({ match = { title = "MATLAB" }, tile = true })
hl.window_rule({ match = { class = "MATLAB", title = "DefaultOverlayManager.JWindow" }, no_anim = true })
hl.window_rule({ match = { class = "MATLAB", title = "DefaultOverlayManager.JWindow" }, no_blur = true })
hl.window_rule({ match = { class = "MATLAB", title = "DefaultOverlayManager.JWindow" }, border_size = 0 })
hl.window_rule({ match = { class = "MATLAB", title = "DefaultOverlayManager.JWindow" }, no_shadow = true })

-- less sensitive scroll for some windows
-- browser(-based)
hl.window_rule({ match = { class = "^(zen|firefox|chromium-browser|chrome-.*)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(obsidian)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(steam)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(Zotero)$" }, scroll_touchpad = 0.1 })
-- GTK3
hl.window_rule({ match = { class = "^(com.github.xournalpp.xournalpp)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(libreoffice.*)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(.virt-manager-wrapped)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, scroll_touchpad = 0.1 })
-- Qt5
hl.window_rule({ match = { class = "^(org.prismlauncher.PrismLauncher)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "^(org.kde.kdeconnect.app)$" }, scroll_touchpad = 0.1 })
-- Others
hl.window_rule({ match = { class = "^(org.pwmt.zathura)$" }, scroll_touchpad = 0.1 })
hl.window_rule({ match = { class = "MATLAB" }, scroll_touchpad = 0.1 })
