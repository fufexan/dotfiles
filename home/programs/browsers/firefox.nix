{
  config,
  pkgs,
  ...
}: let
  shyfox = pkgs.fetchFromGitHub {
    owner = "Naezr";
    repo = "ShyFox";
    rev = "b8687644566e10eae652227b07cb97a6d4b09d63";
    hash = "sha256-EkT1vf3JJdBaM3trlrurGmPNWsBu79HoH0dTWWTVD28=";
  };
in {
  programs.firefox = {
    enable = true;
    profiles.mihai = {
      settings = {
        "apz.overscroll.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "general.autoScroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      extraConfig = builtins.readFile "${shyfox}/user.js";
    };
  };

  home.file.".mozilla/firefox/${config.programs.firefox.profiles.mihai.path}/chrome".source = "${shyfox}/chrome";
}
