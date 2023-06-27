{
  pkgs,
  inputs',
  ...
}:
# games
{
  home.packages = with pkgs; [
    inputs'.nix-gaming.packages.osu-lazer-bin
    gamescope
    # (lutris.override {extraPkgs = p: [p.libnghttp2];})
    winetricks
  ];
}
