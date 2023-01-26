{
  pkgs,
  inputs,
  ...
}: {
  # themable spotify
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.hostPlatform.system}.default;
  in {
    enable = true;

    spotifyPackage = inputs.self.packages.${pkgs.hostPlatform.system}.spotify;

    theme = spicePkgs.themes.catppuccin-mocha;

    colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      hidePodcasts
      shuffle
    ];
  };
}
