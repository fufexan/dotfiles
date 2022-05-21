{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.defaultPackage.${pkgs.system};

    languages = import ./languages.nix pkgs;

    settings = {
      theme = "catppuccin";
      editor = {
        true-color = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        a = ["select_all" ":pipe alejandra"]; # format Nix with Alejandra
      };
    };
  };

  home.file.".config/helix/themes/catppuccin.toml".source = "${inputs.catppuccin-helix}/catppuccin.toml";
}
