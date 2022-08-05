{
  pkgs,
  lib,
  ...
}: {
  programs.spicetify = let
    hidePodcasts = pkgs.fetchFromGitHub {
      owner = "theRealPadster";
      repo = "spicetify-hide-podcasts";
      rev = "cfda4ce0c3397b0ec38a971af4ff06daba71964d";
      sha256 = "146bz9v94dk699bshbc21yq4y5yc38lq2kkv7w3sjk4x510i0v3q";
    };

    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "spicetify";
      rev = "8aaacc4b762fb507b3cf7d4d1b757eb849fcbb52";
      sha256 = "sha256-yfRbYM065wRJqaZB+SsOZi4+e2+ZOD0iKyhNVBJcrqA=";
    };

    variants = ["catppuccin-latte" "catppuccin-frappe" "catppuccin-macchiato" "catppuccin-mocha"];
  in {
    enable = true;

    theme = "catppuccin-mocha";
    colorScheme = "flamingo";
    
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;

    enabledExtensions = [
      "fullAppDisplay.js"
      "shuffle+.js"
      "hidePodcasts.js"
      "catppuccin-mocha.js"
    ];

    thirdPartyExtensions = {
      hidePodcasts = "${hidePodcasts}/hidePodcasts.js";
    } // lib.genAttrs variants (n: "${catppuccin}/js/${n}.js");
    
    thirdPartyThemes = lib.genAttrs variants (n: "${catppuccin}/${n}");
  };
}
