{ pkgs, config, inputs, self, ... }:

# games

{
  home.packages = with inputs.nix-gaming.packages.x86_64-linux; [
    (osu-stable.override {
      location = "$HOME/Games/osu!stable";
    })

    (rocket-league.override { inherit (pkgs) legendary-gl; })

  ] ++ (with pkgs; [
    legendary-gl

    (technic-launcher.override {
      src = builtins.fetchurl {
        url = "https://mc-launcher.com/files/unc/Technic.jar";
        sha256 = "1rwcgzzjxy17qcbczxvq2c8hilmkr16flw48myz93jgx4gii6vxl";
      };
    })
  ]);
}
