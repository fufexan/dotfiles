{
  screenWidth,
  scale,
  gaps,
  ...
}: ''
  (defwidget left []
    (box
      :space-evenly false
      :halign "start"
      (launcher)
      (workspaces)))

  (defwidget right []
    (box
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
    (box
      :space-evenly false
      :halign "center"
      (music)))

  (defwidget bar []
    (centerbox
      :class "bar"
      (left)
      (center)
      (right)))

  (defwindow bar
      :monitor 0
      :geometry (geometry :x "0%"
        :y "5px"
        :width "${builtins.toString (builtins.floor (screenWidth / scale - gaps * 2 * scale))}px"
        :height "32px"
        :anchor "top center")
      :stacking "fg"
      :windowtype "dock"
      :exclusive true
      :wm-ignore false
    (bar))
''
