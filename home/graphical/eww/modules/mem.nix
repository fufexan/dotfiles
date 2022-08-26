{pop, ...}: ''
  (defwidget mem []
    (circular-progress
      :value mem_perc
      :class "membar module"
      :thickness 3
      (button
        :tooltip "using ''${round(mem_perc,0)}% ram"
        :onclick "${pop} system"
        (label :class "icon_text" :text ""))))
''
