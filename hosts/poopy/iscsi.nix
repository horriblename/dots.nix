# block storage mounts
{
  services = {
    openiscsi = {
      enable = true;
      discoverPortal = "169.254.2.2:3260";
      name = "iqn.2015-12.com.oracleiaas:6a2e8816-5763-4768-8fbf-1cc9070042d2";
    };

    # fileSystems."/state" = {
    #   device = "/dev/disk/by-uuid/6a2e8816-5763-4768-8fbf-1cc9070042d2";
    # };
    # sudo iscsiadm -m node -o new -T  -p
    # sudo iscsiadm -m node -o update -T iqn.2015-12.com.oracleiaas:6a2e8816-5763-4768-8fbf-1cc9070042d2 -n node.startup -v automatic
  };
}
