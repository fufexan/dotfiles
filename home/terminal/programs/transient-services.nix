{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (builtins) concatStringsSep mapAttrs toString;

  path = lib.optionalString (config.home.sessionPath != []) ''
    export PATH=${concatStringsSep ":" config.home.sessionPath}:$PATH
  '';

  stringVariables = mapAttrs (n: v: toString v) config.home.sessionVariables;

  variables = lib.concatStrings (lib.mapAttrsToList (k: v: ''
      export ${k}="${toString v}"
    '')
    stringVariables);

  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${path}
    ${variables}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  # runs processes as systemd transient services
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -lc "exec ${apply-hm-env} $@"
  '';
in {
  home.packages = [run-as-service];
}
