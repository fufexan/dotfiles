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
      enable = mkEnableOption (mdDoc "Howdy and PAM module for face recognition");

      package = mkPackageOptionMD pkgs "howdy" {};

      device = mkOption {
        type = types.path;
        default = "/dev/video2";
        description = mdDoc ''
          Device file connected to the IR sensor.
        '';
      };

      settings = mkOption {
        type = settingsType.type;
        default = import ./config.nix;
        description = mdDoc ''
          Howdy configuration file. Refer to
          <https://github.com/boltgolt/howdy/blob/beta/howdy/src/config.ini>
          for options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    environment.etc."howdy/config.ini".source = settingsType.generate "howdy-config.ini" (lib.recursiveUpdate (import ./config.nix) cfg.settings);
  };
}
