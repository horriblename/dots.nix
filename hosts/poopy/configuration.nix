{
  imports = [
    ./hardware-configuration.nix
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

  nix.settings.trusted-users = ["py"];

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
    # Workaround for https://github.com/NixOS/nix/issues/8502
    logrotate.checkConfig = false;
    openssh.enable = true;

    opencloud = {
      enable = true;
      url = "https://c.peynch.online";
      address = "127.0.0.1";
      port = 9200;
    };
  };

  system.stateVersion = "23.11";
}
