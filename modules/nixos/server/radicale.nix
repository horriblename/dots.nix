{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.services.radicale.enable {
    services = {
      radicale = {
        settings = {
          server = {
            hosts = ["127.0.0.1:5232"];
            ssl = false; # disable SSL, only use behind reverse proxy
          };

          auth = {
            # disable auth, and use the username that OpenCloud provides
            type = "http_x_remote_user";
          };

          web = {
            type = "none";
          };
          storage = {
            filesystem_folder = "/var/lib/radicale/collections";
          };

          logging = {
            # level = "debug";
          };
        };
      };

      caddy = {
        enable = true;
      };
    };
  };
}
