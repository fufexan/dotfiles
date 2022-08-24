{pop, ...}: ''
  (defwidget mem []
    (circular-progress
      :value mem_perc
      :class "membar module"
      :thickness 3
      (button
        :tooltip "using ''${mem_perc}% ram"
        :onclick "${pop} system"
        (label :class "icon_text" :text ""))))
''
