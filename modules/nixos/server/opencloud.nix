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
  inherit (builtins) head;
  inherit (lib.modules) mkIf;
  cfg = config.services.opencloud;
  radicaleCfg = config.services.radicale;
in {
  config.services = mkIf config.services.opencloud.enable {
    opencloud = {
      environment = {
        PROXY_TLS = "false"; # disable https when behind reverse-proxy
        INITIAL_ADMIN_PASSWORD = "deez-nuts";
      };

      settings = {
        csp = {
          directives = {
            font-src = [
              "'self'"
              "data:"
              "https://esm.sh/"
            ];
          };
        };
      };
    };

    caddy = {
      enable = true;
      virtualHosts = let
        davHandle = type: ''
          route /${type}/* {
            reverse_proxy ${head radicaleCfg.settings.server.hosts} {
              header_up X-Remote-User {http.auth.user.id}
              header_up X-Script-Name /${type}
            }
          }

          route /.well-known/${type} {
            reverse_proxy ${head radicaleCfg.settings.server.hosts} {
              header_up X-Remote-User {http.auth.user.id}
              header_up X-Script-Name /${type}
            }
          }
        '';
      in {
        "c.peynch.online".extraConfig = ''
          ${davHandle "caldav"}
          ${davHandle "carddav"}

          route {
            reverse_proxy ${cfg.address}:${toString cfg.port}
          }
        '';
      };
    };

    radicale = {
      enable = true;
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
  };
}
