{pop, ...}: ''
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
''
