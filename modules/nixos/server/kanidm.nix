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
                  # root CA path is hardcoded by NixOS
                  tls_trusted_ca_certs /var/lib/acme/.minica/cert.pem
                }
              }
            }
          '';

          ${ldapDomain}.extraConfig = ''
            reverse_proxy ${cfg.settings.ldapbindaddress}
          '';
        };
      };
    };

    systemd.services = {
      # yeaaaaaaaaa I really should stop using security.acme cuz I have no idea
      # what it really is trying to do
      acme-setup.serviceConfig = {
        # Allow caddy (and everyone else) to read the minica root CA cert
        # that is used for caddy<->kanidm communication
        #
        # ca/cert.pem is bind mounted to /var/lib/acme/.minica/cert.pem
        ExecStartPost = pkgs.writeShellScript "acme-post-setup" ''
          chmod 0644 ca/cert.pem
        '';
        Restart = "no";
      };
    };

    security.acme.certs = {
      ${domain} = {
        inherit domain;
        extraDomainNames = [ldapDomain];
        group = config.systemd.services.kanidm.serviceConfig.Group;
        reloadServices = ["kanidm" "caddy"];
      };
    };
  };
}
