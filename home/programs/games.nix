{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.osu-lazer-bin
    gamescope
    (lutris.override {extraPkgs = p: [p.libnghttp2];})
    winetricks
  ];
}
