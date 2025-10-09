{
  lib,
  pkgs,
  config,
  ...
}:
let
  KvLibadwaita = pkgs.fetchFromGitHub {
    owner = "GabePoel";
    repo = "KvLibadwaita";
    rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
    hash = "sha256-32RlnRBNJajD0Ps+vZSwVfDj6HzPpZjfm/LBG7u0eDg=";
    sparseCheckout = [ "src" ];
  };

  qtctConf = {
    Appearance = {
      custom_palette = false;
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
      style = "kvantum";
    };
  };

  defaultFont = "${config.gtk.font.name},${builtins.toString config.gtk.font.size}";
in
{
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.packages = [
    pkgs.qt6Packages.qtstyleplugin-kvantum
    pkgs.qt6Packages.qt6ct
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.libsForQt5.qt5ct
  ];

  xdg.configFile = {
    # Kvantum config
    "Kvantum" = {
      source = "${KvLibadwaita}/src";
      recursive = true;
    };

    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=KvLibadwaitaDark
    '';

    # qtct config
    "qt5ct/qt5ct.conf".text =
      let
        default = ''"${defaultFont},-1,5,50,0,0,0,0,0"'';
      in
      lib.generators.toINI { } (
        qtctConf
        // {
          Fonts = {
            fixed = default;
            general = default;
          };
        }
      );

    "qt6ct/qt6ct.conf".text =
      let
        default = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      in
      lib.generators.toINI { } (
        qtctConf
        // {
          Fonts = {
            fixed = default;
            general = default;
          };
        }
      );
  };
}
