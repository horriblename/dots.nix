# NOTE: action needed: enable the service on host config
{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  domain = "wakapi.peynch.online";

  cfg = config.services.wakapi;
in {
  config = mkIf cfg.enable {
    services = {
      wakapi = {
        database.dialect = "sqlite3";
        environmentFiles = [
          config.age.secrets.wakapiEnv.path
          "/etc/wakapi/kanidmSecret.env"
        ];
        settings = {
          server = {
            port = 3474;
            public_url = "https://${domain}";
          };
          security = {
            allow_signup = false;
            oidc = [
              {
                name = "kanidm";
                displayName = "auth.peynch.online";
                client_id = "wakapi";
                endpoint = "https://auth.peynch.online/oauth2/openid/wakapi";
              }
            ];
          };
        };
      };

      caddy = {
        enable = true;
        virtualHosts = {
          ${domain} = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:${toString cfg.settings.server.port}
            '';
          };
        };
      };
    };
  };
}
