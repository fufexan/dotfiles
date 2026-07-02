{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    # Default latency sometimes crackles
    (inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin.override {
      pipewire_latency = "128/48000";
    })
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.rocket-league
    gamescope
    prismlauncher
    # (lutris.override {extraPkgs = p: [p.libnghttp2];})
  ];
}
