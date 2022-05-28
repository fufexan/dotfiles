pkgs: let
  awkf = "${pkgs.gawk}/bin/awk '{ print $1 }'";
  awks = "${pkgs.gawk}/bin/awk -F'[][]' '{ print $2 }' | tr -d '%'";
  amixer = "${pkgs.alsa-utils}/bin/amixer -D pipewire";
  pm = "${pkgs.pulsemixer}/bin/pulsemixer";
  playerctl = "${pkgs.playerctl}/bin/playerctl";

  battery = import ./scripts/battery.nix pkgs;
  memory = import ./scripts/memory.nix pkgs;
  music = import ./scripts/music.nix pkgs;
  pop = import ./scripts/pop.nix pkgs;
  wifi = import ./scripts/wifi.nix pkgs;

  eww_yuck = ''
    ;; Variables
    (defpoll clock_hour :interval "5m" "date +\%H")
    (defpoll clock_minute :interval "5s" "date +\%M")
    (defpoll clock_date :interval "10h" "date '+%d/%m'")

    (defpoll volume_percent :interval "3s" "${pm} --get-volume | ${awkf}")
    (defpoll mic_percent :interval "3s" "${amixer} sget Capture | grep 'Left:' | ${awks}")

    (defpoll brightness_percent :interval "5s" "${pkgs.light}/bin/light -G")

    (defpoll battery :interval "15s" "${battery} bat")
    (defpoll battery_text :interval "15s" "${battery} bat-text")
    (defpoll battery_status :interval "15s" "${battery} bat-remaining")

    (defpoll memory_percentage :interval "15s" "${memory} percentage")
    (defpoll memory_used :interval "2m" "${memory} used")
    (defpoll memory_total :interval "2m" "${memory} total")
    (defpoll memory_free :interval "2m" "${memory} free")

    (defpoll wifi_color :interval "1m" "${wifi} color")
    (defpoll wifi_essid :interval "1m" "${wifi} essid")
    (defpoll wifi_icon :interval "1m" "${wifi} icon")

    (defpoll song :interval "1s"  "${music} song")
    (defpoll song_artist :interval "1s"  "${music} artist")
    (defpoll current_status :interval "1s"  "${music} time")
    (defpoll song_position :interval "1s"  "date -d@`${playerctl} position` +%M:%S")
    (defpoll song_time :interval "1s"  "date -d@`${music} ctime` +%M:%S")
    (defpoll song_status :interval "1s"  "${music} status")
    (defpoll cover_art :interval "1s"  "${music} cover")

    (defpoll calendar_day :interval "20h" "date '+%d'")
    (defpoll calendar_year :interval "20h" "date '+%Y'")

    (defvar vol_reveal false)
    (defvar br_reveal false)
    (defvar music_reveal false)
    (defvar wifi_rev false)
    (defvar time_rev false)

    ;; widgets

    (defwidget wifi []
      (eventbox :onhover "eww update wifi_rev=true"
        :onhoverlost "eww update wifi_rev=false"
      (box :space-evenly "false"
      (button :class "module-wif" :onclick "networkmanager_dmenu" :wrap "false" :limit-width 12 :style "color: ''${wifi_color};" wifi_icon)
      (revealer :transition "slideright"
        :reveal wifi_rev
        :duration "350ms"
      (label :class "module_essid"
        :text wifi_essid
        :orientation "h"
        )))))


    (defwidget bat []
      (box :class "bat_module"
        (circular-progress :value battery
            :class "batbar"
            :thickness 4
        (button
            :class "iconbat"
            :tooltip "battery on ''${battery}%"
            :onclick "${pop} system"
            (label :class "iconbat_text" :text "")))))


    (defwidget mem []
      (box :class "mem_module"
        (circular-progress :value memory_percentage
            :class "membar"
            :thickness 4
        (button
            :class "iconmem"
            :tooltip "using ''${memory_percentage}% ram"
            :onclick "${pop} system"
            (label :class "iconmem_text" :text "")))))

    (defwidget sep []
      (box :class "module-2" :hexpand "false"
        (label :class "separ" :text "|")))

    (defwidget clock_module []
      (eventbox :onhover "eww update time_rev=true"
        :onhoverlost "eww update time_rev=false"
        (box :class "module" :space-evenly "false" :orientation "h" :spacing "3"
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
      (box :class "module-2" :space-evenly "false" :orientation "h" :spacing "3"
      (button :onclick "${pop} audio"   :class "volume_icon" "")
      (revealer :transition "slideleft"
        :reveal vol_reveal
        :duration "350ms"
      (scale :class "volbar"
        :value volume_percent
        :tooltip "''${volume_percent}%"
        :max 100
        :min 0
        :onchange "${pm} --set-volume {}" )))))

    (defwidget bright []
      (eventbox :onhover "eww update br_reveal=true" :onhoverlost "eww update br_reveal=false"
      (box :class "module-2" :space-evenly "false" :orientation "h" :spacing "3"
        (label :text "" :class "bright_icon" :tooltip "brightness")
      (revealer :transition "slideleft"
        :reveal br_reveal
        :duration "350ms"
      (scale :class "brightbar"
        :value brightness_percent
        :tooltip "''${brightness_percent}%"
        :max 100
        :min 0
        :onchange "${pkgs.light}/bin/light -S {}" )))))

    ;; Music
    (defwidget music []
      (eventbox :onhover "eww update music_reveal=true"
        :onhoverlost "eww update music_reveal=false"
      (box :class "module-2" :orientation "h" :space-evenly "false"
        (box :class "song_cover_art" :style "background-image: url(\"''${cover_art}\");")
        (button :class "song_module" :onclick "${pop} music" song)
        (revealer :transition "slideright"
          :reveal music_reveal
          :duration "350ms"
            (box :oreintation "h"
              (button :class "song_button" :onclick "${music} prev" "")
              (button :class "song_button" :onclick "${music} toggle" song_status)
              (button :class "song_button" :onclick "${music} next" ""))))))

    (defwidget left []
      (box :orientation "h"
        :space-evenly false
        :halign "end"
        :class "left_modules"
    (bright)
    (volume)
    (wifi)
    (sep)
    (bat)
    (mem)
    (sep)
    (clock_module)))

    (defwidget right []
      (box :orientation "h"
       :space-evenly false
         :halign "start"
       :class "right_modules"
    ))

    (defwidget center []
      (box :orientation "h"
       :space-evenly false
             :halign "center"
       :class "center_modules"
    (music)))


    (defwidget bar_1 []
      (box :class "bar_class"
           :orientation "h"
      (right)
      (center)
      (left)
        ))


    (defwindow bar
        :monitor 0
        :geometry (geometry :x "0"
                     :y "0"
                     :width "100%"
                     :height "30px"
                     :anchor "top center")
        :stacking "fg"
        :windowtype "dock"
        :exclusive true
        :wm-ignore false
      (bar_1))

    (defwidget system []
      (box :class "sys_win" :orientation "v" :space-evenly "false" :spacing 0
      (box :class "sys_bat_box" :orientation "h" :space-evenly "false"
        (circular-progress :value battery
                  :class "sys_bat"
                  :thickness 9
              (label :text ""
                  :class "sys_icon_bat"
                  :limit-width 2
                  :show_truncated false
                  :wrap false))
              (box :orientation "v" :space-evenly "false" :spacing 0 :vexpand "false"
              (label :text "battery"
                  :halign "start"
                  :class "sys_text_bat"
                  :limit-width 9
                  :show_truncated false
                  :wrap false)
              (label :text "''${battery_text}"
                  :halign "start"
                  :class "sys_text_bat_sub"
                  :limit-width 22
                  :show_truncated false
                  :wrap false)
              (label :text "''${battery_status}"
                  :halign "start"
                  :class "sys_text_bat_sub"
                  :limit-width 22
                  :show_truncated false
                  :wrap false)))
              (label :text "" :class "sys_sep" :halign "center")
      (box :class "sys_mem_box" :orientation "h" :space-evenly "false" :halign "start"
        (circular-progress :value memory_percentage
                  :class "sys_mem"
                  :thickness "9"
              (label :text ""
                  :class "sys_icon_mem"
                  :limit-width 2
                  :show_truncated false
                  :wrap false))
              (box :orientation "v" :space-evenly "false" :spacing 0 :vexpand "false"
              (label :text "memory"
                  :halign "start"
                  :class "sys_text_mem"
                  :limit-width 9
                  :show_truncated false
                  :wrap false)
              (label :text "''${memory_used} | ''${memory_total}"
                  :halign "start"
                  :class "sys_text_mem_sub"
                  :limit-width 22
                  :show_truncated false
                  :wrap false)
              (label :text "''${memory_free} free"
                  :halign "start"
                  :class "sys_text_mem_sub"
                  :limit-width 22
                  :show_truncated false
                  :wrap false)))))

    (defwidget cal []
      (box :class "cal" :orientation "v"
      (box :class "cal-in"
      (calendar :class "cal"
        :day calendar_day
        :year calendar_year))))

    (defwindow calendar
      :monitor 0
      :geometry (geometry :x "-1%"
      :y "7%"
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
      (scale :value volume_percent
        :space-evenly "false"
        :orientation "h"
        :onchange "${pm} --set-volume {}"
        :tooltip "volume on ''${volume_percent}%"
        :max 100
        :min 0))))
      (label :text "" :class "audio_sep" :halign "center")
      (box :halign "v" :space-evenly "false" :vexpand "false"
      (box :class "mic_icon" :orientation "v")
      (box :orientation "v" :halign "center" :hexpand "false"
      (label :class "mic_text" :text "mic" :valign "center" :halign "left" )
      (box :class "mic_bar" :halign "center" :hexpand "false"
      (scale :value mic_percent
        :space-evenly "false"
        :orientation "h"
        :tooltip "mic on ''${mic_percent}%"
        :onchange "${amixer} sset Capture {}%"
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
        :orientation "h"
        :space-evenly "false"
        (box :class "music_cover_art"
          :style "background-image: url(\"''${cover_art}\");")
        (box :orientation "v"
          :spacing 20
          :space-evenly "false"
            (label :class "music"
              :wrap "true"
              :limit-width 19
              :text song)
            (label :class "music_artist"
              :wrap "true"
              :limit-width 20
              :text song_artist)
            (box :orientation "h"
              :spacing 15
              :halign "center"
              :space-evenly "false"
            (centerbox :orientation "h"
              :class "music_button_box"
              (button :class "music_button"
                :onclick "${music} prev" "")
              (button :class "music_button"
                :onclick "${music} toggle" song_status)
              (button :class "music_button"
                :onclick "${music} next" "")))
            (centerbox :orientation "h"
              (label :xalign 0
                :class "music_time"
                :text song_position)
              (label)
              (label :xalign 1
                :class "music_time"
                :text song_time))
        (box :class "music_bar"
          :space-evenly "false"
            (scale :onscroll "${pkgs.playerctl}/bin/playerctl position {}+"
              :min 0
              :max 100
              :active "true"
              :value current_status)))))

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
