{
  pop,
  music,
  ...
}: ''
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
''
