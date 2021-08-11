{ pkgs, config, inputs, self, ... }:

# games

{
  home.packages = with inputs.nix-gaming.packages.x86_64-linux; [
    (osu-stable.override {
      location = "$HOME/Games/osu!stable";
    })

    rocket-league

    #(technic-launcher.override {
    #  src = builtins.fetchurl {
    #    url = "https://mc-launcher.com/files/unc/Technic.jar";
    #    sha256 = "sha256-b9ekp9pheryqoGtlOM/JtEe2TUHOlDDQuMFk98VNZs0=";
    #  };
    #})
  ] ++ (with pkgs; [ legendary-gl ]);
}
