{
  inputs,
  lib,
  pkgs,
  ...
} @ args: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

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
        indent-guides.render = true;
      };

      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        a = ["select_all" ":pipe alejandra"]; # format Nix with Alejandra
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };

    themes = let
      catppuccin-helix = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "helix";
        rev = "dc1d236f610fa9573fa59194c79dd3a5a9c8a639";
        sha256 = "sha256-JfTS1Kgcdd/Gu05QXWwztHlr9zrIy73YXLvx7iaYAqM=";
      };

      variants = ["catppuccin_latte" "catppuccin_frappe" "catppuccin_macchiato" "catppuccin_mocha"];
    in
      lib.genAttrs variants (n: builtins.fromTOML (builtins.readFile "${catppuccin-helix}/italics/${n}.toml"));
  };
}
