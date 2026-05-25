{
  config,
  lib,
  pkgs,
  ...
}:
let
  themeName = "KvLibadwaita";
in
{
  services.darkman = {
    enable = true;

    settings.usegeoclue = true;

    scripts = {
      dconf = ''${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-$1'"'';

      kvantum = ''
        local variant=""
        [[ "$1" == "dark" ]] && variant="dark"
        cat <<EOF > ${config.xdg.configHome}/Kvantum/kvantum.kvconfig
        [General]
        theme="${themeName}''${variant}"
        EOF
      '';
    };
  };
}
