{
  pkgs,
  config,
  lib,
  ...
}:
{
  home = {
    sessionVariables = {
      # default is qt5ct, breaks apps
      QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
      # default is kvantum, we shouldn't set it
      QT_STYLE_OVERRIDE = lib.mkForce null;
    };
  };

  qt = {
    enable = true;
    # see home/services/system/theme.nix for kvantum config
    style.name = "kvantum";
    platformTheme.name = "qtct";

    qt6ctSettings =
      let
        defaultFont = "${config.gtk.font.name},${builtins.toString config.gtk.font.size}";
        default = ''"${defaultFont},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      in
      {
        Appearance = {
          custom_palette = true;
          color_scheme_path = "/home/mihai/.config/qt6ct/style-colors.conf";
          icon_theme = config.gtk.iconTheme.name;
          standard_dialogs = "xdgdesktopportal";
          style = "kvantum";
        };
        Fonts = {
          fixed = default;
          general = default;
        };
      };
  };

  xdg.configFile =
    let
      KvLibadwaita = pkgs.fetchFromGitHub {
        owner = "GabePoel";
        repo = "KvLibadwaita";
        rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
        hash = "sha256-32RlnRBNJajD0Ps+vZSwVfDj6HzPpZjfm/LBG7u0eDg=";
        sparseCheckout = [ "src" ];
      };
    in
    {
      # Kvantum config
      "Kvantum" = {
        source = "${KvLibadwaita}/src";
        recursive = true;
      };
    };
}
