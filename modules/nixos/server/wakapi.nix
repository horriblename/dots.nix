# NOTE: action needed: enable the service on host config
{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.services.wakapi;
in {
  config = mkIf cfg.enable {
    services = {
      wakapi = {
        database.dialect = "sqlite3";
        environmentFiles = [
          config.age.secrets.wakapiEnv.path
        ];
        settings = {
          server.port = 3474;
        };
      };

      caddy = {
        enable = true;
        virtualHosts = {
          "wakapi.peynch.online" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:${toString cfg.settings.server.port}
            '';
          };
        };
      };
    };
  };
}
