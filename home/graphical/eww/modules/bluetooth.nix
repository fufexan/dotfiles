{...}: ''
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
''
