{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    pre-commit.settings = {
      excludes = [ "flake.lock" ];
      hooks.treefmt.enable = true;
    };

    treefmt.programs = {
      nixfmt.enable = true;

      prettier = {
        enable = true;
        excludes = [
          ".js"
          ".md"
          ".ts"
        ];
      };
    };
  };
}
