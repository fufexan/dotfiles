{pkgs, ...}: let
  battery = import ./scripts/battery.nix pkgs;
  brightness = import ./scripts/brightness.nix pkgs;
  cpu = import ./scripts/cpu.nix pkgs;
  memory = import ./scripts/memory.nix pkgs;
  music = import ./scripts/music.nix pkgs;
  net = import ./scripts/net.nix pkgs;
  pop = import ./scripts/pop.nix pkgs;
  volume = import ./scripts/volume.nix pkgs;

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

    (defpoll bat_perc :interval "1s" "${battery} bat")
    (defpoll bat_status :interval "1s" "${battery} bat-remaining")
    (defpoll bat_text :interval "1s" "${battery} bat-text")

    (defpoll mem_free :interval "2s" "${memory} free")
    (defpoll mem_perc :interval "2s" "${memory} percentage")
    (defpoll mem_total :interval "2s" "${memory} total")
    (defpoll mem_used :interval "2s" "${memory} used")

    (defpoll cpu_perc :interval "1s" "${cpu}")

    (defpoll net_color :interval "10s" "${net} color")
    (defpoll net_icon :interval "10s" "${net} icon")
    (defpoll net_ssid :interval "10s" "${net} essid")

    (defpoll cover_art :interval "1s" "${music} cover")
    (defpoll song_artist :interval "1s" "${music} artist")
    (defpoll song_length :interval "1s" "${music} length_time")
    (defpoll song_pos :interval "1s" "${music} position_time")
    (defpoll song_pos_perc :interval "1s" "${music} position")
    (defpoll song_status :interval "1s" "${music} status")
    (defpoll song_title :interval "1s" "${music} title")

    (defpoll cal_day :interval "20h" "date '+%d'")
    (defpoll cal_year :interval "20h" "date '+%Y'")

    (defvar bright_reveal false)
    (defvar music_reveal false)
    (defvar net_rev false)
    (defvar time_rev false)
    (defvar vol_reveal false)

    ;; widgets

    (defwidget net []
      (eventbox :onhover "eww update net_rev=true"
        :onhoverlost "eww update net_rev=false"
        (box :space-evenly "false"
          (button :class "module-net" :onclick "networkmanager_dmenu" :style "color: ''${net_color};" net_icon)
            (revealer :transition "slideright"
              :reveal net_rev
              :duration "350ms"
              (label :class "module_ssid"
                :text net_ssid)))))


    (defwidget bat []
      (box :class "bat_module"
        (circular-progress :value bat_perc
          :class "batbar"
          :thickness 4
          (button
            :class "iconbat"
            :tooltip "battery on ''${bat_perc}%"
            :onclick "${pop} system"
            (label :class "iconbat_text" :text "")))))


    (defwidget mem []
      (box :class "mem_module"
        (circular-progress :value mem_perc
          :class "membar"
          :thickness 4
          (button
            :class "iconmem"
            :tooltip "using ''${mem_perc}% ram"
            :onclick "${pop} system"
            (label :class "iconmem_text" :text "")))))

    (defwidget cpu []
      (box :class "cpu_module"
        (circular-progress :value cpu_perc
          :class "cpubar"
          :thickness 4
          (button
            :class "iconcpu"
              :tooltip "using ''${cpu_perc}% cpu"
            :onclick "${pop} system"
            (label :class "iconcpu_text" :text "")))))

    (defwidget sep []
      (box :class "module-2" :hexpand "false"
        (label :class "separ" :text "|")))

    (defwidget clock_module []
      (eventbox :onhover "eww update time_rev=true"
        :onhoverlost "eww update time_rev=false"
        (box :class "module" :space-evenly "false" :spacing "3"
          (label :text clock_hour :class "clock_time_class")
          (label :text ":" :class "clock_time_sep")
          (label :text clock_minute :class "clock_minute_class")
          (revealer :transition "slideleft"
            :reveal time_rev
            :duration "350ms"
            (button :class "clock_date_class"
              :onclick "${pop} calendar" clock_date)))))

    (defwidget volume []
      (eventbox :onhover "eww update vol_reveal=true"
        :onhoverlost "eww update vol_reveal=false"
        (box :class "module-2" :space-evenly "false" :spacing "3"
          (button :onclick "${pop} audio" :class "vol_icon" vol_icon)
          (revealer :transition "slideleft"
            :reveal vol_reveal
            :duration "350ms"
            (scale :class "volbar"
              :value vol_percent
              :tooltip "''${vol_percent}%"
              :max 100
              :min 0
              :onchange "${volume} setvol SINK {}" )))))

    (defwidget bright []
      (eventbox :onhover "eww update bright_reveal=true" :onhoverlost "eww update bright_reveal=false"
      (box :class "module-2" :space-evenly "false" :spacing "3"
        (label :text brightness_icon :class "bright_icon" :tooltip "brightness")
        (revealer :transition "slideleft"
          :reveal bright_reveal
          :duration "350ms"
          (scale :class "brightbar"
            :min 0
            :max 100
            :value brightness_percent
            :tooltip "''${brightness_percent}%"
            :onchange "${pkgs.light}/bin/light -S {}")))))

    ;; Music
    (defwidget music []
      (eventbox :onhover "eww update music_reveal=true"
        :onhoverlost "eww update music_reveal=false"
        (box :class "module-2" :space-evenly "false"
          (box :class "song_cover_art" :style "background-image: url(\"''${cover_art}\");")
          (button :class "song_module" :onclick "${pop} music" song_title)
          (revealer :transition "slideright"
            :reveal music_reveal
            :duration "350ms"
              (box
                (button :class "song_button" :onclick "${music} prev" "")
                (button :class "song_button" :onclick "${music} toggle" song_status)
                (button :class "song_button" :onclick "${music} next" ""))))))

    (defwidget left []
      (box :class "left_modules"
        :space-evenly false
        :halign "start"
      ))

    (defwidget right []
      (box :class "right_modules"
        :space-evenly false
        :halign "end"
        (bright)
        (volume)
        (net)
        (sep)
        (cpu)
        (mem)
        (bat)
        (sep)
        (clock_module)))

    (defwidget center []
      (box :class "center_modules"
        :space-evenly false
        :halign "center"
        (music)))

    (defwidget bar []
      (centerbox :class "bar"
        (left)
        (center)
        (right)))

    (defwindow bar
        :monitor 0
        :geometry (geometry :x "5px"
          :y "5px"
          :width "99%"
          :height "24px"
          :anchor "top center")
        :stacking "fg"
        :windowtype "dock"
        :exclusive true
        :wm-ignore false
        :focusable false
      (bar))

    (defwidget system []
      (box :class "sys_win" :orientation "v" :space-evenly "false" :spacing 0
      ; cpu
      (box :class "sys_cpu_box"  :space-evenly "false" :halign "start"
        (circular-progress :value cpu_perc
          :class "sys_cpu"
          :thickness "9"
          (label :text ""
            :class "sys_icon_cpu"
            :limit-width 2
            :wrap false))
        (box :orientation "v" :space-evenly "false" :spacing 0 :vexpand "false"
          (label :text "cpu"
            :halign "start"
            :class "sys_text_cpu"
            :limit-width 9
            :wrap false)
          (label :text "''${cpu_perc}%"
            :halign "start"
            :class "sys_text_cpu_sub"
            :limit-width 22
            :wrap false)))
      (label :text "" :class "sys_sep" :halign "center")
      ; memory
      (box :class "sys_mem_box"  :space-evenly "false" :halign "start"
        (circular-progress :value mem_perc
          :class "sys_mem"
          :thickness "9"
          (label :text ""
            :class "sys_icon_mem"
            :limit-width 2
            :wrap false))
        (box :orientation "v" :space-evenly "false" :spacing 0 :vexpand "false"
          (label :text "memory"
            :halign "start"
            :class "sys_text_mem"
            :limit-width 9
            :wrap false)
          (label :text "''${mem_used} | ''${mem_total}"
            :halign "start"
            :class "sys_text_mem_sub"
            :limit-width 22
            :wrap false)))
      (label :text "" :class "sys_sep" :halign "center")
      ; battery
      (box :class "sys_bat_box" :space-evenly "false"
        (circular-progress :value bat_perc
          :class "sys_bat"
          :thickness 9
          (label :text ""
            :class "sys_icon_bat"
            :limit-width 2
            :wrap false))
        (box :orientation "v" :space-evenly "false" :spacing 0 :vexpand "false"
          (label :text "battery"
            :halign "start"
            :class "sys_text_bat"
            :limit-width 9
            :wrap false)
          (label :text "''${bat_text}"
            :halign "start"
            :class "sys_text_bat_sub"
            :limit-width 22
            :wrap false)
          (label :text "''${bat_status}"
            :halign "start"
            :class "sys_text_bat_sub"
            :limit-width 22
            :wrap false)))))

    (defwidget cal []
      (box :class "cal" :orientation "v"
      (box :class "cal-in"
      (calendar :class "cal"
        :day cal_day
        :year cal_year))))

    (defwindow calendar
      :monitor 0
      :geometry (geometry :x "-1%"
      :y "1%"
    	:anchor "top right"
      :width "270px"
      :height "60px")
    (cal))


    (defwidget audio []
      (box :class "audio-box" :orientation "v" :space-evenly "false" :hexpand "false"
        (box :halign "v" :space-evenly "false" :vexpand "false"
          (box :class "speaker_icon" :orientation "v")
          (box :orientation "v" :halign "center" :hexpand "false"
            (label :class "speaker_text" :text "speaker" :valign "center" :halign "left" )
            (box :class "speaker_bar" :halign "center" :hexpand "false"
              (scale :value vol_percent
                :onchange "${volume} setvol SINK {}"
                :tooltip "volume on ''${vol_percent}%"
                :max 100
                :min 0))))

        (label :text "" :class "audio_sep" :halign "center")
        (box :halign "v" :space-evenly "false" :vexpand "false"

        (box :class "mic_icon" :orientation "v")
          (box :orientation "v" :halign "center" :hexpand "false"
            (label :class "mic_text" :text "mic" :valign "center" :halign "left" )
            (box :class "mic_bar" :halign "center" :hexpand "false"
              (scale :value mic_percent
                :tooltip "mic on ''${mic_percent}%"
                :onchange "${volume} setvol SOURCE {}"
                :max 100
                :min 0))))))

    (defwindow audio_ctl
      :monitor 0
      :geometry (geometry :x "-1%"
      :y "1%"
      :anchor "top right"
      :width "0"
      :height "0")
    (audio))


    (defwindow system
      :monitor 0
      :geometry (geometry :x "-1%"
      :y "1%"
      :anchor "top right"
      :width "0"
      :height "0")
    (system))



    ;; Music window
    (defwidget music_pop []
      (box :class "music_pop"
        :space-evenly "false"
        (box :class "music_cover_art"
          :style "background-image: url(\"''${cover_art}\");")
        (box :orientation "v"
          :spacing 20
          :space-evenly "false"
            (label :class "music"
              :wrap "true"
              :limit-width 19
              :text song_title)
            (label :class "music_artist"
              :wrap "true"
              :limit-width 20
              :text song_artist)
            (centerbox
              :halign "center"
              :class "music_button_box"
              (button :class "music_button"
                :onclick "${music} prev" "")
              (button :class "music_button"
                :onclick "${music} toggle" song_status)
              (button :class "music_button"
                :onclick "${music} next" ""))
            (centerbox
              (label :xalign 0
                :class "music_time"
                :text song_pos)
              (label)
              (label :xalign 1
                :class "music_time"
                :text song_length))
        (box :class "music_bar"
          :space-evenly "false"
            (scale
              :min 0
              :max 100
              :active "false"
              :value song_pos_perc)))))

    (defwindow music_win :stacking "fg" :focusable "false"
      :monitor 0
      :geometry (geometry :x "0%"
        :y "1%"
        :width "0%"
        :height "0%"
        :anchor "top center")
        (music_pop))
  '';
in
  eww_yuck
