{pkgs, ...}: ''
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
''
