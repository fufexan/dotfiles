{
  pop,
  volume,
  ...
}: ''
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
''
