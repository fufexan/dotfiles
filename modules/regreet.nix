{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.programs.regreet;
  settingsType = pkgs.formats.toml {};
in {
  options.programs.regreet = {
    enable = mkEnableOption (mdDoc "ReGreet, a greetd greeter");

    package = mkPackageOptionMD pkgs "regreet" {};

    settings = mkOption {
      inherit (settingsType) type;
      default = {};
      description = mdDoc ''
        ReGreet configuration file. Refer
        <https://github.com/rharish101/ReGreet/blob/main/regreet.sample.toml>
        for options.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.greetd.enable = true;

    environment.etc."greetd/regreet.toml".source = settingsType.generate "regreet.toml" cfg.settings;

    systemd.tmpfiles.rules = [
      "d /var/log/regreet 0755 greeter greeter - -"
      "d /var/cache/regreet 0755 greeter greeter - -"
    ];
  };
}
