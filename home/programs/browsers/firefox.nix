{
  config,
  pkgs,
  ...
}: let
  shyfox = pkgs.fetchFromGitHub {
    owner = "Naezr";
    repo = "ShyFox";
    rev = "8d0d0139bbdb538a64e5a05df907160c39c8f008";
    hash = "sha256-k3p8VxFpI/jw1TLBOKskH4KylsiiWBJLRNpffm+w7Bo=";
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
