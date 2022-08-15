{
  pkgs,
  inputs,
  ...
}: {
  screenWidth,
  scale,
  gaps,
}: let
  battery = import ./scripts/battery.nix pkgs;
  bluetooth = import ./scripts/bluetooth.nix pkgs;
  brightness = import ./scripts/brightness.nix pkgs;
  memory = import ./scripts/memory.nix pkgs;
  music = import ./scripts/music.nix pkgs;
  net = import ./scripts/net.nix pkgs;
  pop = import ./scripts/pop.nix pkgs;
  volume = import ./scripts/volume.nix pkgs;
  workspaces = import ./scripts/workspaces.nix pkgs inputs;

  eww_yuck = ''
    ;; Variables
    (defpoll clock_date :interval "1h" "date '+%d/%m'")
    (defpoll clock_hour :interval "1m" "date '+%H'")
    (defpoll clock_minute :interval "5s" "date '+%M'")

    (defpoll mic_percent :interval "3s" "${volume} getvol SOURCE")
    (defpoll vol_icon :interval "1s" "${volume} icon")
    (defpoll vol_percent :interval "1s" "${volume} getvol")

    (defpoll brightness_icon :interval "1s" "${brightness} icon")
    (defpoll brightness_percent :interval "1s" "${brightness} level")

    (defpoll bat_wattage :interval "2s" "${battery} wattage")
    (defpoll bat_status :interval "1s" "${battery} status")
    (defpoll bat_color :interval "1s" "${battery} color")

    (defpoll mem_free :interval "2s" "${memory} free")
    (defpoll mem_perc :interval "2s" "${memory} percentage")
    (defpoll mem_total :interval "2s" "${memory} total")
    (defpoll mem_used :interval "2s" "${memory} used")

    (defpoll net_color :interval "10s" "${net} color")
    (defpoll net_icon :interval "10s" "${net} icon")
    (defpoll net_ssid :interval "10s" "${net} essid")

    (defpoll bt_color :interval "2s" "${bluetooth} color")
    (defpoll bt_icon :interval "2s" "${bluetooth} icon")
    (defpoll bt_text :interval "2s" "${bluetooth} text")

    (defpoll cover_art :interval "1s" "${music} cover")
    (defpoll song_artist :interval "1s" "${music} artist")
    (defpoll song_length :interval "1s" "${music} length_time")
    (defpoll song_pos :interval "1s" "${music} position_time")
    (defpoll song_pos_perc :interval "1s" "${music} position")
    (defpoll song_status :interval "1s" "${music} status")
    (defpoll song_title :interval "1s" "${music} title")

    (defvar bright_reveal false)
    (defvar music_reveal false)
    (defvar net_rev false)
    (defvar bt_rev false)
    (defvar time_rev false)
    (defvar vol_reveal false)

    (deflisten workspace "${workspaces}")

    ;; widgets

    (defwidget net []
      (eventbox
        :onhover "''${EWW_CMD} update net_rev=true"
        :onhoverlost "''${EWW_CMD} update net_rev=false"
        (box
          :space-evenly "false"
          (revealer
            :transition "slideright"
            :reveal net_rev
            :duration "350ms"
            (label
              :class "module_ssid module"
              :style "color: ''${net_color};"
              :text net_ssid))
          (button
            :class "module_net module"
            :onclick "networkmanager_dmenu"
            :style "color: ''${net_color};"
            net_icon))))

    (defwidget bluetooth []
      (eventbox
        :onhover "''${EWW_CMD} update bt_rev=true"
        :onhoverlost "''${EWW_CMD} update bt_rev=false"
        (box
          :space-evenly "false"
          (revealer
            :transition "slideright"
            :reveal bt_rev
            :duration "350ms"
            (label
              :class "module_bt module"
              :style "color: ''${bt_color};"
              :text bt_text))
          (button
            :class "module_bt module"
            :onclick "blueman"
            :style "color: ''${bt_color};"
            bt_icon))))

    (defwidget bat []
      (circular-progress
        :value "''${EWW_BATTERY["BAT0"].capacity}"
        :class "batbar module"
        :style "color: ''${bat_color};"
        :thickness 3
        (button
          :tooltip "battery on ''${EWW_BATTERY["BAT0"].capacity}%"
          :onclick "${pop} system"
          (label :class "icon_text" :text ""))))

    (defwidget mem []
      (circular-progress
        :value mem_perc
        :class "membar module"
        :thickness 3
        (button
          :tooltip "using ''${mem_perc}% ram"
          :onclick "${pop} system"
          (label :class "icon_text" :text ""))))

    (defwidget cpu []
      (circular-progress
        :value "''${EWW_CPU.avg}"
        :class "cpubar module"
        :thickness 3
        (button
          :tooltip "using ''${EWW_CPU.avg}% cpu"
          :onclick "${pop} system"
          (label :class "icon_text" :text ""))))

    (defwidget sep []
      (label :class "separ module" :text "|"))

    (defwidget clock_module []
      (eventbox
        :onhover "''${EWW_CMD} update time_rev=true"
        :onhoverlost "''${EWW_CMD} update time_rev=false"
        (box
          ;; :class "module"
          :space-evenly "false"
          :spacing "3"
          :class "module"
          (label
            :text clock_hour
            :class "clock_time_class")
          (label
            :text ":"
            :class "clock_time_sep")
          (label
            :text clock_minute
            :class "clock_minute_class")
          (revealer
            :transition "slideleft"
            :reveal time_rev
            :duration "350ms"
            (button
              :class "clock_date_class module"
              :onclick "${pop} calendar" clock_date)))))

    (defwidget volume []
      (eventbox
        :onhover "''${EWW_CMD} update vol_reveal=true"
        :onhoverlost "''${EWW_CMD} update vol_reveal=false"
        (box
          :class "module"
          :space-evenly "false"
          :spacing "3"
          (revealer
            :transition "slideright"
            :reveal vol_reveal
            :duration "350ms"
            (scale
              :class "volbar"
              :value vol_percent
              :tooltip "''${vol_percent}%"
              :max 100
              :min 0
              :onchange "${volume} setvol SINK {}"))
          (button
            :onclick "${pop} volume"
            :class "vol_icon"
            vol_icon))))

    (defwidget bright []
      (eventbox
        :onhover "''${EWW_CMD} update bright_reveal=true"
        :onhoverlost "''${EWW_CMD} update bright_reveal=false"
        (box
          :class "module"
          :space-evenly "false"
          :spacing "3"
          (revealer
            :transition "slideleft"
            :reveal bright_reveal
            :duration "350ms"
            (scale
              :class "brightbar"
              :min 0
              :max 100
              :value brightness_percent
              :tooltip "''${brightness_percent}%"
              :onchange "${pkgs.light}/bin/light -S {}"))
          (label
            :text brightness_icon
            :class "bright_icon"
            :tooltip "brightness"))))

    (defwidget music []
      (eventbox
        :onhover "''${EWW_CMD} update music_reveal=true"
        :onhoverlost "''${EWW_CMD} update music_reveal=false"
        (box
          :class "module"
          :space-evenly "false"
          (box
            :class "song_cover_art"
            :style "background-image: url(\"''${cover_art}\");")
          (button
            :class "song_module"
            :onclick "${pop} music"
            song_title)
          (revealer
            :transition "slideright"
            :reveal music_reveal
            :duration "350ms"
            (box
              (button :class "song_button" :onclick "${music} prev" "")
              (button :class "song_button" :onclick "${music} toggle" song_status)
              (button :class "song_button" :onclick "${music} next" ""))))))

    (defwidget workspaces []
      (literal
        :content workspace))

    (defwidget left []
      (box
        :space-evenly false
        :halign "start"
        (workspaces)))

    (defwidget right []
      (box
        :space-evenly false
        :halign "end"
        (bright)
        (volume)
        (net)
        (bluetooth)
        (sep)
        (cpu)
        (mem)
        (bat)
        (sep)
        (clock_module)))

    (defwidget center []
      (box
        :space-evenly false
        :halign "center"
        (music)))

    (defwidget bar []
      (centerbox
        :class "bar"
        (left)
        (center)
        (right)))

    (defwindow bar
        :monitor 0
        :geometry (geometry :x "0%"
          :y "5px"
          :width "${builtins.toString (builtins.floor (screenWidth / scale - gaps * 2 * scale))}px"
          :height "32px"
          :anchor "top center")
        :stacking "fg"
        :windowtype "dock"
        :exclusive true
        :wm-ignore false
      (bar))

    (defwidget system []
      (box
        :class "sys_win"
        :orientation "v"

        ; cpu
        (box
          :class "sys_box"
          :space-evenly "false"
          :halign "start"
          (circular-progress
            :value "''${EWW_CPU.avg}"
            :class "sys_cpu"
            :thickness "3"
            (label
              :text ""
              :class "sys_icon_cpu"))
          (box
            :orientation "v"
            :vexpand "false"
            (label
              :text "cpu"
              :halign "start"
              :class "sys_text_cpu")
            (label
              :text "''${round(EWW_CPU.avg,2)}%"
              :halign "start"
              :class "sys_text_sub")
            (label
              :text "''${EWW_CPU.cores[0].freq} MHz"
              :halign "start"
              :class "sys_text_sub")))

        ; memory
        (box
          :class "sys_box"
          :space-evenly "false"
          :halign "start"
          (circular-progress
            :value mem_perc
            :class "sys_mem"
            :thickness "3"
            (label
              :text ""
              :class "sys_icon_mem"))
          (box
            :orientation "v"
            (label
              :text "memory"
              :halign "start"
              :class "sys_text_mem" )
            (label
              :text "''${mem_used} | ''${mem_total}"
              :halign "start"
              :class "sys_text_sub" )))

        ; battery
        (box
          :class "sys_box"
          :space-evenly "false"
          (circular-progress
            :value "''${EWW_BATTERY["BAT0"].capacity}"
            :class "sys_bat"
            :style "color: ''${bat_color};"
            :thickness 3
            (label
              :text ""
              :style "color: ''${bat_color};"
              :class "sys_icon_bat" ))
          (box
            :orientation "v"
            (label
              :text "battery"
              :halign "start"
              :class "sys_text_bat" )
            (label
              :text "''${EWW_BATTERY["BAT0"].capacity}% | ''${bat_wattage}"
              :halign "start"
              :class "sys_text_sub" )
            (label
              :text "''${bat_status}"
              :halign "start"
              :class "sys_text_sub" )))))

    (defwindow calendar_win
      :monitor 0
      :geometry (geometry
        :x "0%"
        :y "1%"
      	:anchor "top right"
        :width "0px"
        :height "0px")
      (calendar))

    (defwidget volume_window []
      (box
        :class "volume_window"
        :orientation "v"
        (box
          :halign "v"
          :space-evenly "false"
          (box
            :class "volume_icon speaker_icon"
            :orientation "v")
          (box
            :orientation "v"
            (label
              :class "volume_text"
              :text "speaker")
            (box
              :class "volume_bar"
              (scale
                :value vol_percent
                :onchange "volume setvol SINK {}"
                :tooltip "volume on ''${vol_percent}%"))))
        (box
          :halign "v"
          :space-evenly "false"
          (box
            :class "volume_icon mic_icon"
            :orientation "v")
            (box
              :orientation "v"
              (label
                :class "volume_text"
                :text "mic")
              (box
                :class "volume_bar"
                (scale
                  :value mic_percent
                  :tooltip "mic on ''${mic_percent}%"
                  :onchange "volume setvol SOURCE {}"))))))

    (defwindow volume_win
      :monitor 0
      :geometry (geometry
        :x "0%"
        :y "1%"
        :anchor "top right"
        :width "0"
        :height "0")
      (volume_window))

    (defwindow system_win
      :monitor 0
      :geometry (geometry
        :x "0%"
        :y "1%"
        :anchor "top right"
        :width "0"
        :height "0")
    (system))

    ;; music window
    (defwidget music_window []
      (box
        :class "music_window"
        (box
          :class "music_cover_art"
          :style "background-image: url(\"''${cover_art}\");")
        (box
          :orientation "v"
          :class "music_box"
          (label
            :class "music_title"
            :limit-width 18
            :text song_title)
          (label
            :class "music_artist"
            :wrap "true"
            :limit-width 30
            :text song_artist)
          (centerbox
            :halign "center"
            :class "music_button_box"
            (button :class "music_button" :onclick "${music} prev" "")
            (button :class "music_button" :onclick "${music} toggle" song_status)
            (button :class "music_button" :onclick "${music} next" ""))
          (box
            :orientation "v"
            (centerbox
              (label
                :xalign 0
                :class "music_time"
                :text song_pos)
              (label)
              (label
                :xalign 1
                :class "music_time"
                :text song_length))
            (box
              :class "music_bar"
              (scale
                :active "false"
                :value song_pos_perc))))))

    (defwindow music_win
      :stacking "fg"
      :focusable "false"
      :monitor 0
      :geometry (geometry
        :x "0%"
        :y "1%"
        :width "0%"
        :height "0%"
        :anchor "top center")
      (music_window))
  '';
in
  eww_yuck
