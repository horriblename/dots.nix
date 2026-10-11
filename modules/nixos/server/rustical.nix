{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  domain = "cal.peynch.online";

  kanidmCfg = config.services.kanidm;
  cfg = config.services.rustical;
in {
  config = mkIf cfg.enable {
    services = {
      rustical = {
        environmentFiles = ["/etc/rustical/oidc-secret.env"];
        settings = {
          http = {
            host = "127.0.0.1";
          };

          oidc = {
            name = "kanidm";
            issuer = "${kanidmCfg.server.settings.origin}/oauth2/openid/rustical";
            client_id = "rustical";
            claim_userid = "preferred_username";
            scopes = ["openid" "profile"];
            allow_sign_up = true;
          };

          frontend.allow_password_login = false;
        };
      };

      caddy = {
        enable = true;
        virtualHosts.${domain}.extraConfig = ''
          reverse_proxy 127.0.0.1:${toString cfg.settings.http.port}
        '';
      };

      kanidm = {
        provision = {
          groups.rustical_users.members = ["py"];
          systems.oauth2 = {
            rustical = {
              displayName = "Rustical";
              originUrl = "https://${domain}/frontend/login/oidc/callback";
              originLanding = "https://${domain}";
              scopeMaps = {
                rustical_users = ["openid" "profile"];
              };
            };
          };
        };
      };
    };

    dots.statePaths = [cfg.rustical.environmentFiles];
  };
}
