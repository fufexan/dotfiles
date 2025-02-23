{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    # Default latency sometimes crackles
    (inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin.override {pipewire_latency = "128/48000";})
    gamescope
    prismlauncher
    # (lutris.override {extraPkgs = p: [p.libnghttp2];})
    winetricks
    protontricks
  ];
}
