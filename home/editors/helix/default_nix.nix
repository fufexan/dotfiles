{
  inputs,
  lib,
  pkgs,
  ...
}:
# adapted from https://git.privatevoid.net/max/config/-/tree/master/users/max/home/editor
let
  package = inputs.helix.defaultPackage.${pkgs.system};

  clipboardProvider = pkgs.wl-clipboard;

  hx = {
    config = {
      theme = "base16_dark";
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
        a = "%|alejandra"; # format Nix with Alejandra
      };
    };
    languages = import ./languages.nix pkgs;
  };

  mkTOML = name: value: let
    json = pkgs.writeText "helix-${name}.json" (builtins.toJSON value);
  in
    pkgs.runCommandNoCC "helix-${name}.toml" {} "${pkgs.remarshal}/bin/remarshal --if json --of toml -i ${json} -o $out";

  path = lib.makeBinPath [clipboardProvider];

  # weird double-wrapping because nix-cargo-integration isn't overridable
  finalPackage =
    pkgs.runCommandNoCC package.name
    {
      nativeBuildInputs = [
        pkgs.makeWrapper
      ];
    } ''
      makeWrapper ${package}/bin/hx $out/bin/hx \
        --prefix PATH : ${path}
    '';
in {
  home.packages = [finalPackage];

  home.file = {
    ".config/helix/config.toml".source = mkTOML "config" hx.config;
    ".config/helix/languages.toml".source = mkTOML "languages" hx.languages;
  };
}
