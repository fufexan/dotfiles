{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.regreet;
  settingsType = pkgs.formats.toml {};
in {
  options.programs.regreet = {
    enable = lib.mkEnableOption (lib.mdDoc "ReGreet, a greetd greeter");

    package = lib.mkPackageOptionMD pkgs "regreet" {};

    settings = lib.mkOption {
      inherit (settingsType) type;
      default = {};
      description = lib.mdDoc ''
        ReGreet configuration file. Refer
        <https://github.com/rharish101/ReGreet/blob/main/regreet.sample.toml>
        for options.
      '';
    };

    extraCss = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra CSS rules to apply on top of the GTK theme. Refer to
        [GTK CSS Properties](https://docs.gtk.org/gtk4/css-properties.html) for
        modifiable properties.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd.enable = true;

    environment.etc = {
      "greetd/regreet.toml".source = settingsType.generate "regreet.toml" cfg.settings;
      "greetd/regreet.css".source = pkgs.writeText "regreet.css" cfg.extraCss;
    };

    systemd.tmpfiles.rules = [
      "d /var/log/regreet 0755 greeter greeter - -"
      "d /var/cache/regreet 0755 greeter greeter - -"
    ];
  };
}
