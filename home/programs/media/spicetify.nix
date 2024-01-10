{
  inputs,
  pkgs,
  config,
  ...
}: {
  # themable spotify
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
    variant =
      if config.theme.name == "light"
      then "latte"
      else "mocha";
  in {
    enable = true;

    theme = spicePkgs.themes.catppuccin;

    colorScheme = variant;

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      history
      genre
      hidePodcasts
      shuffle
    ];
  };
}
