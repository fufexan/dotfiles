{
  pkgs,
  inputs,
  ...
}: {
  # themable spotify
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;

    spotifyPackage = inputs.self.packages.${pkgs.system}.spotify-wrapped-wm;

    theme = spicePkgs.themes.catppuccin-mocha;

    colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      hidePodcasts
      shuffle
    ];
  };
}
