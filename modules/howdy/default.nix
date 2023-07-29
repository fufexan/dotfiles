{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.howdy;
  settingsType = pkgs.formats.ini {};
in {
  options = {
    services.howdy = {
      enable =
        mkEnableOption (mdDoc "")
        // {
          description = mdDoc ''
            Howdy and PAM module for face recognition. See
            `services.linux-enable-ir-emitter` for enabling the IR emitter support.
          '';
        };

      package = mkPackageOptionMD pkgs "howdy" {};

      settings = mkOption {
        inherit (settingsType) type;
        default = import ./config.nix;
        description = mdDoc ''
          Howdy configuration file. Refer to
          <https://github.com/boltgolt/howdy/blob/beta/howdy/src/config.ini>
          for options.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [cfg.package];
      environment.etc."howdy/config.ini".source = settingsType.generate "howdy-config.ini" cfg.settings;
    })
    {
      services.howdy.settings = mapAttrsRecursive (_: mkDefault) (import ./config.nix);
    }
  ];
}
