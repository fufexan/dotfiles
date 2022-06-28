{
  inputs,
  lib,
  pkgs,
  ...
} @ args: {
  programs.helix = {
    enable = true;
    package = inputs.helix.defaultPackage.${pkgs.system};

    languages = import ./languages.nix args;

    settings = {
      theme = "catppuccin_mocha";
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

  xdg.configFile = let
    variants = ["catppuccin_latte" "catppuccin_frappe" "catppuccin_macchiato" "catppuccin_mocha"];
  in
    lib.mapAttrs' (n: v: lib.nameValuePair "helix/themes/${n}.toml" v) (lib.genAttrs variants (n: {source = "${inputs.catppuccin-helix}/italics/${n}.toml";}));
}
