# NOTE: manual setup:
#
# Setting up credentials for user
#
# ```bash
# sudo -u kanidm kanidmd scripting recover-account idm_admin
# # Note down the new password
# kanidm --url https://auth.peynch.online login --name idm_admin
# kanidm --url https://auth.peynch.online person credential create-reset-token py
# ```
#
# Secrets for each OIDC client:
#
# ```bash
# kanidm --url https://auth.peynch.online system oauth2 show-basic-secret wakapi \
#   | awk '{print "WAKAPI_OIDC_PROVIDERS_0_CLIENT_SECRET=" $0 }' \
#   | sudo -u wakapi tee /etc/wakapi/oauthSecret.env
# sudo -u wakapi chmod 600 /etc/wakapi/kanidmSecret.env
# ```
#
# # OAuth General Information
#
# To add a new OAuth2 client, kanidm needs to know:
# - client_id: this is the key under kanidm.provision.systems.*
# - originUrl: where to redirect to once authentication passes
# - scopeMaps: A mapping of groups to what information the client is allowed to
#   see
#
# After provisioning, kanidm generates a secret retrievable via
# `kanidm system oauth2 show-basic-secret` (see above example)
#
# The client now needs to know:
# - client_id: as above
# - endpoint: where to go to for login
# - secret: from above
{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  domain = "auth.peynch.online";
  ldapDomain = "ldap.peynch.online";

  acmeCfg = config.security.acme;
  certCfg = config.security.acme.certs.${domain};

  cfg = config.services.kanidm.server;
in {
  config = mkIf cfg.enable {
    services = {
      kanidm = {
        package = pkgs.kanidm_1_11;
        server = {
          settings = {
            inherit domain;
            origin = "https://${domain}";
            bindaddress = "127.0.0.1:8443";
            ldapbindaddress = "127.0.0.1:9100";

            tls_chain = "${certCfg.directory}/fullchain.pem";
            tls_key = "${certCfg.directory}/key.pem";
            http_client_address_info = {
              x-forward-for = ["127.0.0.1"];
            };
            ldap_client_address_info = {
              proxy-v2 = ["127.0.0.1"];
            };
          };
        };

        client = {
          settings = {
            uri = "https://${domain}";
          };
        };

        provision = {
          enable = true;

          persons = {
            py = {
              displayName = "Py";
            };
          };

          groups = {
            wakapi_users = {
              members = ["py"];
            };
          };

          systems = {
            oauth2 = {
              forgejo = {
                displayName = "Forgejo";
                originUrl = "https://git.peynch.online/";
                originLanding = "https://git.peynch.online/";
                imageFile = "${config.services.forgejo.package.data}/public/assets/img/forgejo.svg";
              };

              wakapi = {
                displayName = "Wakapi";
                allowInsecureClientDisablePkce = true;
                originUrl = "https://wakapi.peynch.online/oidc/kanidm/callback";
                originLanding = "https://wakapi.peynch.online";
                scopeMaps = {
                  wakapi_users = ["openid" "email" "profile"];
                };
              };
            };
          };
        };
      };

      caddy = {
        enable = true;
        virtualHosts = {
          ${domain}.extraConfig = ''
            handle /.well-known/acme-challenge/* {
              root * ${certCfg.webroot or acmeCfg.defaults.webroot}
              file_server
            }


            handle {
              reverse_proxy https://${cfg.settings.bindaddress} {
                transport http {
                  tls
                  tls_server_name ${domain}
                }
              }
            }
          '';

          ${ldapDomain}.extraConfig = ''
            handle /.well-known/acme-challenge/* {
              root * ${certCfg.webroot or acmeCfg.defaults.webroot}
              file_server
            }

            reverse_proxy ${cfg.settings.ldapbindaddress}
          '';
        };
      };
    };

    security.acme.certs = {
      ${domain} = {
        inherit domain;
        extraDomainNames = [ldapDomain];
        group = config.systemd.services.kanidm.serviceConfig.Group;
        reloadServices = ["kanidm" "caddy"];
        postRun = ''
          ${pkgs.acl}/bin/setfacl -m u:kanidm:rx ${certCfg.directory}
          ${pkgs.acl}/bin/setfacl -m u:kanidm:r ${certCfg.directory}/*.pem
        '';
      };
    };
  };
}
