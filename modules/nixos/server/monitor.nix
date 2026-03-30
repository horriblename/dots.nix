{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config.services = mkIf config.services.netdata.enable {
    netdata = {
      config = {
        global = {
          "memory mode" = "ram";
          "debug log" = "none";
          # "access log" = "none";
          "error log" = "syslog";
        };
        web.mode = "none";
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "mon.peynch.online".extraConfig = ''
          basic_auth * argon2id {
            py $argon2id$v=19$m=47104,t=1,p=1$h5aVt2bQUMkTAX7dZeHRsw$tMfIcQ2+bikgBHaoGweM7JgT/8uIC9udnl6LOOz5vYM
          }

          reverse_proxy 127.0.0.1:19999
        '';
      };
    };
  };
}
