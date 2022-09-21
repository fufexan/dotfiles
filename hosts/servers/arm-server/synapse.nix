{
  pkgs,
  config,
  ...
}: let
  domain = "fufexan.ml";
  fqdn = "matrix.${domain}";

  clientConfig = {
    "m.homeserver".base_url = "https://${fqdn}";
    "m.identity_server" = {};
  };

  serverConfig."m.server" = "${config.services.matrix-synapse.settings.server_name}:443";

  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';

  registration-shared-secret = config.age.secrets.synapse-registration-shared-secret.path;
in {
  networking.firewall.allowedTCPPorts = [80 443];

  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };

      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = "return 404;";
        locations."/_matrix".proxyPass = "http://127.0.0.1:8008";
        locations."/_synapse/client".proxyPass = "http://127.0.0.1:8008";
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = domain;
    settings.listeners = [
      {
        port = 8008;
        bind_addresses = ["127.0.0.1" "::1"];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = ["client" "federation"];
            compress = true;
          }
        ];
      }
    ];
    extraConfigFiles = [registration-shared-secret];
  };
}
