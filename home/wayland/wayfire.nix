{
  pkgs,
  default,
  ...
}: let
  inherit (default) xrgbaColors;
in {
  home.packages = [pkgs.wayfire];

  xdg.configFile."wayfire.ini".text = ''
    [alpha]
    min_value = 0.100000
    modifier = <alt> <super>

    [animate]
    close_animation = fade
    open_animation = zoom
    startup_duration = 300
    duration = 300
    enabled_for = type equals "toplevel" | (type equals "x-or" & focusable equals true))

    fade_duration = 400
    fade_enabled_for = type equals "overlay"

    [autostart]
    0_environment = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY
    1_hm = systemctl --user start graphical-session.target
    2_eww = eww daemon

    autostart_wf_shell = false
    background = swaybg -i ~/.config/wallpaper.png
    idle = swayidle -w \
             timeout 360 'swaylock' \
             before-sleep 'swaylock'
    panel = eww open bar

    [blur]
    blur_by_default = type is "toplevel"

    bokeh_degrade = 1
    bokeh_iterations = 5
    bokeh_offset = 5.000000

    box_degrade = 1
    box_iterations = 2
    box_offset = 1.000000

    gaussian_degrade = 1
    gaussian_iterations = 2
    gaussian_offset = 1.000000

    kawase_degrade = 3
    kawase_iterations = 3
    kawase_offset = 1.000000

    method = kawase
    saturation = 1.000000
    #toggle = <super> KEY_B

    [command]
    binding_launcher = <super> KEY_SPACE
    binding_lock = <super> KEY_L
    binding_logout = <super> KEY_ESC
    binding_mute = KEY_MUTE
    binding_mic_mute = KEY_F20
    binding_next = KEY_NEXTSONG
    binding_pause = KEY_PLAYPAUSE
    binding_prev = KEY_PREVIOUSSONG
    binding_screenshot = KEY_PRINT | <super> <shift> KEY_R
    binding_screenshot_interactive = <ctrl> KEY_PRINT | <super> <shift> <ctrl> KEY_R
    binding_terminal = <super> KEY_ENTER

    command_launcher = wofi --show=drun -I
    command_light_down = brillo -q -u 300000 -U 5
    command_light_up = brillo -q -u 300000 -A 5
    command_lock = swaylock
    command_logout = wlogout -p layer-shell
    command_mute = wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    command_mic_mute = wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    command_next = playerctl next
    command_pause = playerctl play-pause
    command_prev = playerctl previous
    command_screenshot = screenshot area
    command_screenshot_interactive = screenshot monitor
    command_terminal = ${default.terminal.name}
    command_volume_down = pulsemixer --change-volume -6
    command_volume_up = pulsemixer --change-volume +6

    repeatable_binding_light_down = KEY_BRIGHTNESSDOWN
    repeatable_binding_light_up = KEY_BRIGHTNESSUP
    repeatable_binding_volume_down = KEY_VOLUMEDOWN
    repeatable_binding_volume_up = KEY_VOLUMEUP

    [core]
    background_color = #${xrgbaColors.base00}
    close_top_view = <super> KEY_Q | <alt> KEY_F4
    focus_button_with_modifiers = false
    focus_buttons = BTN_LEFT | BTN_MIDDLE | BTN_RIGHT
    focus_buttons_passthrough = true
    plugins = autostart \
      blur \
      command \
      decoration \
      expo \
      fast-switcher \
      idle \
      matcher \
      move \
      oswitch \
      place \
      resize \
      simple-tile \
      vswipe \
      window-rules \
      wrot \
      zoom
    vheight = 3
    vwidth = 3
    xwayland = true

    [cube]
    activate = <alt> <ctrl> BTN_LEFT
    background = #${xrgbaColors.base00}
    background_mode = simple
    cubemap_image =
    deform = 0
    initial_animation = 350
    light = true
    rotate_left = <alt> <ctrl> KEY_LEFT
    rotate_right = <alt> <ctrl> KEY_RIGHT
    skydome_mirror = true
    skydome_texture =
    speed_spin_horiz = 0.020000
    speed_spin_vert = 0.020000
    speed_zoom = 0.070000
    zoom = 0.100000

    [decoration]
    active_color = #${xrgbaColors.base00}
    border_size = 0
    button_order = minimize maximize close
    font = Roboto
    ignore_views = none
    inactive_color = #${xrgbaColors.base04}
    title_height = 20

    [expo]
    background = #${xrgbaColors.base00}
    duration = 50
    offset = 10
    select_workspace_1 = KEY_1
    select_workspace_2 = KEY_2
    select_workspace_3 = KEY_3
    select_workspace_4 = KEY_4
    select_workspace_5 = KEY_5
    select_workspace_6 = KEY_6
    select_workspace_7 = KEY_7
    select_workspace_8 = KEY_8
    select_workspace_9 = KEY_9
    toggle = <super>

    [extra-gestures]
    close_fingers = 5
    move_delay = 500
    move_fingers = 3

    [fast-switcher]
    activate = <alt> KEY_ESC
    activate_backward = <alt> <shift> KEY_ESC

    [fisheye]
    radius = 450.000000
    toggle = <ctrl> <super> KEY_F
    zoom = 7.000000

    [grid]
    duration = 300
    restore = <super> KEY_DOWN | <super> KEY_KP0
    slot_b = <super> KEY_KP2
    slot_bl = <super> KEY_KP1
    slot_br = <super> KEY_KP3
    slot_c = <super> KEY_UP | <super> KEY_KP5
    slot_l = <super> KEY_LEFT | <super> KEY_KP4
    slot_r = <super> KEY_RIGHT | <super> KEY_KP6
    slot_t = <super> KEY_KP8
    slot_tl = <super> KEY_KP7
    slot_tr = <super> KEY_KP9
    type = crossfade

    [idle]
    cube_max_zoom = 1.500000
    cube_rotate_speed = 1.000000
    cube_zoom_speed = 1000
    disable_on_fullscreen = true
    dpms_timeout = 300
    screensaver_timeout = -1
    toggle = none

    [input]
    click_method = default
    cursor_size = 24
    cursor_theme = "Bibata-Modern-Classic"
    disable_touchpad_while_mouse = false
    disable_touchpad_while_typing = false
    gesture_sensitivity = 1.000000
    middle_emulation = false
    modifier_binding_timeout = 400
    mouse_accel_profile = flat
    natural_scroll = true
    touchpad_scroll_speed = 0.3
    xkb_layout = ro
    xkb_rules = evdev

    [invert]
    preserve_hue = false
    toggle = <super> KEY_I

    [move]
    activate = <super> BTN_LEFT
    enable_snap = true
    enable_snap_off = true
    join_views = false
    quarter_snap_threshold = 50
    snap_off_threshold = 10
    snap_threshold = 10
    workspace_switch_after = -1

    [oswitch]
    next_output = <super> KEY_O
    next_output_with_win = <shift> <super> KEY_O

    [output]
    mode = auto
    position = auto
    scale = 1.000000
    transform = normal

    [place]
    mode = center

    [preserve-output]
    last_output_focus_timeout = 10000

    [resize]
    activate = <super> BTN_RIGHT

    [scale]
    allow_zoom = false
    bg_color = #${xrgbaColors.base00}
    duration = 750
    inactive_alpha = 0.750000
    interact = false
    middle_click_close = false
    spacing = 50
    text_color = #${xrgbaColors.base00}
    title_font_size = 14
    title_overlay = all
    title_position = center
    toggle = <super> KEY_P
    toggle_all =

    [switcher]
    next_view = <alt> KEY_TAB
    prev_view = <alt> <shift> KEY_TAB
    speed = 500
    view_thumbnail_scale = 1.000000

    [vswipe]
    background = #${xrgbaColors.base00}
    duration = 180
    enable_smooth_transition = true
    enable_vertical = true
    fingers = 3
    gap = 32.000000
    speed_cap = 0.500000
    speed_factor = 500.000000
    #threshold = 0.250000

    [vswitch]
    background = #${xrgbaColors.base00}
    binding_down = <ctrl> <super> KEY_DOWN
    binding_left = <ctrl> <super> KEY_LEFT
    binding_right = <ctrl> <super> KEY_RIGHT
    binding_up = <ctrl> <super> KEY_UP
    binding_win_down = <ctrl> <shift> <super> KEY_DOWN
    binding_win_left = <ctrl> <shift> <super> KEY_LEFT
    binding_win_right = <ctrl> <shift> <super> KEY_RIGHT
    binding_win_up = <ctrl> <shift> <super> KEY_UP
    duration = 300
    gap = 20
    wraparound = false

    [window-rules]

    [wm-actions]
    minimize = none
    toggle_always_on_top = none
    toggle_fullscreen = <super> KEY_F
    toggle_maximize = none
    toggle_showdesktop = none
    toggle_sticky = none

    [wobbly]
    friction = 3.000000
    grid_resolution = 6
    spring_k = 8.000000

    [workarounds]
    all_dialogs_modal = true
    app_id_mode = stock
    dynamic_repaint_delay = false

    [wrot]
    activate = <ctrl> <super> BTN_RIGHT
    activate-3d = <shift> <super> BTN_RIGHT
    invert = false
    reset = <ctrl> <super> KEY_R
    reset-one = <super> KEY_R
    reset_radius = 25.000000
    sensitivity = 24

    [zoom]
    modifier = <super>
    smoothing_duration = 300
    speed = 0.010000

    [simple-tile]
    button_move = <super> BTN_LEFT
    button_resize = <super> BTN_RIGHT
    inner_gap_size = 2
    keep_fullscreen_on_adjacent = true
    key_focus_above = <super> KEY_K
    key_focus_below = <super> KEY_J
    key_focus_left = <super> KEY_H
    key_focus_right = <super> KEY_L
    key_toggle = <super> KEY_T
    tile_by_default = type is "toplevel"
    #wm-actions.toggle_always_on_top
  '';
}
