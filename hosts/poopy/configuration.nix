{
  imports = [
    ./hardware-configuration.nix
  ];

  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "poopy";
  networking.domain = "";
  services.openssh.enable = true;

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

  system.stateVersion = "23.11";
}
