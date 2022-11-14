{
  pkgs,
  lib,
  config,
  ...
}:
# manage files in ~
{
  imports = [./nix-index-update-db.nix];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };

  # Product Sans font
  home.file."${config.xdg.dataHome}/fonts/ProductSans".source = lib.cleanSourceWith {
    filter = name: _: (lib.hasSuffix ".ttf" (baseNameOf (toString name)));
    src = pkgs.fetchzip {
      url = "https://befonts.com/wp-content/uploads/2018/08/product-sans.zip";
      sha256 = "sha256-PF2n4d9+t1vscpCRWZ0CR3X0XBefzL9BAkLHoqWFZR4=";
      stripRoot = false;
    };
  };
}
