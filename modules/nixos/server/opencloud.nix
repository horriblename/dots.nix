# NOTE: Additional configuration needed
#
# services.opencloud = {
#   enable = true;
#   url = "https://example.com";
#   address = "127.0.0.1";
#   port = (optional);
# }
{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  cfg = config.services.opencloud;
in {
  config.services = mkIf config.services.opencloud.enable {
    opencloud = {
      environment = {
        PROXY_TLS = "false"; # disable https when behind reverse-proxy
        INITIAL_ADMIN_PASSWORD = "deez-nuts";
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "c.peynch.online".extraConfig = ''
          reverse_proxy ${cfg.address}:${toString cfg.port}
        '';
      };
    };
  };
}
