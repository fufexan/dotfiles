{
  pkgs,
  inputs,
  ...
}: {
  programs.spicetify = {
    enable = true;

    spotifyPackage = inputs.self.packages.${pkgs.system}.spotify-wrapped-wm;

    spicetifyPackage = pkgs.spicetify-cli.overrideAttrs (_: rec {
      pname = "spicetify-cli";
      version = "2.9.9";
      src = pkgs.fetchgit {
        url = "https://github.com/spicetify/${pname}";
        rev = "v${version}";
        sha256 = "1a6lqp6md9adxjxj4xpxj0j1b60yv3rpjshs91qx3q7blpsi3z4z";
      };
    });

    theme = "catppuccin-mocha";
    colorScheme = "flamingo";

    enabledExtensions = [
      "fullAppDisplay.js"
      "shuffle+.js"
      "hidePodcasts.js"
    ];
  };
}
