{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in {
  config = mkIf config.services.forgejo.enable {
    services = {
      forgejo = {
        database.type = "sqlite3";
        settings = {
          server = {
            DOMAIN = "git.peynch.online";
            ROOT_URL = "https://${srv.DOMAIN}";
            HTTP_PORT = 3000;
          };
          service.DISABLE_REGISTRATION = true;
        };
      };

      caddy = {
        enable = true;
        virtualHosts = {
          "${srv.DOMAIN}" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:${toString srv.HTTP_PORT}
            '';
          };
        };
      };
    };
  };
}
