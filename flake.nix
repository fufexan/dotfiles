{
  description = "fufexan's NixOS and Home-Manager flake";

  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack { overrides = args.tackOverrides or { }; }) // {
        inherit self;
      };

      extendedSelf = self // {
        inherit inputs;
      };
    in
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
        self = extendedSelf;
      }
      {
        systems = [ "x86_64-linux" ];

        imports = [
          ./hosts
          ./lib
          ./modules
          ./pkgs
          ./fmt-hooks.nix
        ];

        perSystem =
          {
            config,
            pkgs,
            ...
          }:
          {
            devShells.default = pkgs.mkShell {
              packages = [
                pkgs.git
                config.packages.repl
                inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default
              ];
              name = "dots";
              env.DIRENV_LOG_FORMAT = "";
              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };
          };
      };
}
