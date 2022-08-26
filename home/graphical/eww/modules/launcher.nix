{
  pkgs,
  lib,
  ...
}: ''
  (defwidget launcher []
    (button
      :tooltip "launcher"
      :hexpand true
      :class "launcher"
      :onclick "${lib.getExe pkgs.wofi}"
      ""))
''
