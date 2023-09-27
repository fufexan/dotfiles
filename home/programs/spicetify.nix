{
  inputs,
  pkgs,
  theme,
  ...
}: {
  # themable spotify
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;

    theme = let
      variant =
        if theme.variant == "light"
        then "latte"
        else "mocha";
    in
      spicePkgs.themes."catppuccin-${variant}";

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
