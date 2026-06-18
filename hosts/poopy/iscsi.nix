# block storage mounts
#
# XXX: Manual steps:
#
#   sudo iscsiadm -m node -o new -T iqn.2015-12.com.oracleiaas:6a2e8816-5763-4768-8fbf-1cc9070042d2 -p 169.254.2.2:3260
#   sudo iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:6a2e8816-5763-4768-8fbf-1cc9070042d2 -n node.startup -v automatic
#   sudo iscsiadm -m node -T iqn.2015-12.com.oracleiaas:6a2e8816-5763-4768-8fbf-1cc9070042d2 -p 169.254.2.2:3260 -l
#
# It should be possible to wrap this script into a systemd unit but I'm too lazy
{
  services = {
    openiscsi = {
      enable = true;
      discoverPortal = "169.254.2.2:3260";
      name = "iqn.2015-12.com.oracleiaas:6a2e8816-5763-4768-8fbf-1cc9070042d2";
    };
  };
}
