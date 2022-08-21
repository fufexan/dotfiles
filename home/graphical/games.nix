{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with inputs.nix-gaming.packages.${pkgs.system};
    [
      (osu-stable.override {location = "$HOME/Games/osu!stable";})
      osu-lazer-bin

      (inputs.nix-gaming.lib.legendaryBuilder {
        games = {
          rocket-league = {
            desktopName = "Rocket League";
            tricks = ["dxvk" "win10"];
            icon = builtins.fetchurl {
              url = "https://www.pngkey.com/png/full/16-160666_rocket-league-png.png";
              name = "rocket-league.png";
              sha256 = "09n90zvv8i8bk3b620b6qzhj37jsrhmxxf7wqlsgkifs4k2q8qpf";
            };
            discordIntegration = false;
          };
        };

        opts.wine = wine-tkg;
        inherit (pkgs) system;
      })
      .rocket-league
    ]
    ++ (with pkgs; [
      gamescope
      legendary-gl

      inputs.self.packages.${pkgs.system}.tlauncher

      (inputs.self.packages.${pkgs.system}.technic-launcher.override {
        source = builtins.fetchurl rec {
          url = "https://mc-launcher.com/files/unc/Technic.jar";
          name = "technic-${sha256}";
          sha256 = "1hd5kfvkz3x0vral28n1d0srclp82blb2kx63sn10w06qz3pbzsf";
        };
      })
    ]);
}
