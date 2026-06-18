{
  imports = [
    ./hardware-configuration.nix
    ./iscsi.nix
    ./secrets.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "poopy";
  networking.domain = "";

  users = {
    users.py = {
      group = "py";
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
    };

    groups.py = {};
  };

  nix.settings = {
    trusted-users = ["py"];
    max-jobs = 1;
    cores = 1;
    http-connections = 3;
  };

  security = {
    sudo = {
      extraRules = [
        {
          users = ["py"];
          commands = [
            {
              command = "ALL";
              options = ["SETENV" "NOPASSWD"];
            }
          ];
        }
      ];
    };
  };

  services = {
    openssh.enable = true;

    # opencloud = {
    #   enable = true;
    #   url = "https://c.peynch.online";
    #   address = "127.0.0.1";
    #   port = 9200;
    # };

    wakapi.enable = true;

    # pocket-id.enable = true;
  };

  system.stateVersion = "23.11";
}
