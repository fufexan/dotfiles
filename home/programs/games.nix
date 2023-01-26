{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with inputs.nix-gaming.packages.${pkgs.hostPlatform.system};
    [
      (osu-stable.override {location = "$HOME/Games/osu!stable";})
      osu-lazer-bin
      roblox-player

      (inputs.nix-gaming.lib.legendaryBuilder {
        games = {
          rocket-league = {
            desktopName = "Rocket League";
            tricks = ["dxvk" "win10"];
            icon = builtins.fetchurl rec {
              url = "https://img.favpng.com/21/12/21/rocket-league-video-game-psyonix-logo-decal-png-favpng-yYh6A3FRCJNh7JYgYZchHxAia.jpg";
              name = "rocket-league-${sha256}.png";
              sha256 = "0ymisjgcmw8mkarnkm95dsndii2aw9yn5i3vfximi2dchy4ng8ab";
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
      inputs.self.packages.${pkgs.hostPlatform.system}.tlauncher
    ]);
}
