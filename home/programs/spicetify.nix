{
  inputs,
  pkgs,
  ...
}: {
  # themable spotify
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;

    theme = spicePkgs.themes.catppuccin-mocha;

    colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      history
      genre
      hidePodcasts
      shuffle
    ];
  };
}
