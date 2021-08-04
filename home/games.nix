{ pkgs, config, inputs, self, ... }:

# games

{
  home.packages = with pkgs; [
    # games

    legendary-gl

    (inputs.osu-nix.defaultPackage.x86_64-linux.override {
      location = "$HOME/Games/osu!stable";
    })

    self.packages.x86_64-linux.rocket-league

    (technic-launcher.override {
      src = builtins.fetchurl {
        url = "https://mc-launcher.com/files/unc/Technic.jar";
        sha256 = "sha256-b9ekp9pheryqoGtlOM/JtEe2TUHOlDDQuMFk98VNZs0=";
      };
    })

    inputs.osu-nix.packages.x86_64-linux.wine-tkg
  ];
}
