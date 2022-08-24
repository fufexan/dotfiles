{
  pkgs,
  inputs,
  battery,
  brightness,
  memory,
  music,
  net,
  volume,
  workspaces,
  ...
}: ''
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
  (defvar time_rev false)
  (defvar vol_reveal false)

  (deflisten workspace "${workspaces}")
''
