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
      legendary-gl

      (technic-launcher.override {
        source = builtins.fetchurl rec {
          url = "https://mc-launcher.com/files/unc/Technic.jar";
          name = "technic-${sha256}";
          sha256 = "1yhgyimdhja0aggssd2l0fc50nfdfisfj0ix6qha9g644ag78h5r";
        };
      })
    ]);
}
