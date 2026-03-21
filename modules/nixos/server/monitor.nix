{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config.services = mkIf config.services.netdata.enable {
    netdata = {
      config.global = {
        "memory mode" = "ram";
        "debug log" = "none";
        # "access log" = "none";
        "error log" = "syslog";
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "mon.peynch.online".extraConfig = ''
          reverse_proxy 127.0.0.1:19999
        '';
      };
    };
  };
}
