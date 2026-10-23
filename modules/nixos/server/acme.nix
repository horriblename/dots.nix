# Defaults for ACME certs.
#
# Doesn't actually do anything until you add a security.acme.certs.
{
  security.acme = {
    acceptTerms = true;
    defaults.webroot = "/var/lib/acme/acme-challenge/";
  };
}
