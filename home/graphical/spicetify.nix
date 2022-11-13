{
  pkgs,
  inputs,
  ...
}: {
  # themable spotify
  programs.spicetify = {
    enable = true;

    spotifyPackage = inputs.self.packages.${pkgs.system}.spotify-wrapped-wm;

    theme = "catppuccin-mocha";
    colorScheme = "flamingo";

    enabledExtensions = [
      "fullAppDisplay.js"
      "shuffle+.js"
      "hidePodcasts.js"
    ];
  };
}
