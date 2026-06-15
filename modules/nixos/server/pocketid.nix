# NOTE: action needed: enable the service on host config
{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.services.pocket-id;
in {
  config = mkIf cfg.enable {
    services = {
      pocket-id = {
        settings = {
          APP_URL = "https://auth.peynch.online";
          HOST = "127.0.0.1";
          PORT = "1411";
          ENCRYPTION_KEY_FILE = "/etc/pocket-id/encryption.key";
          TRUST_PROXY = true;
        };
      };

      caddy = {
        enable = true;
        virtualHosts = {
          "auth.peynch.online" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:${toString cfg.settings.PORT}
            '';
          };
        };
      };
    };
  };
}
