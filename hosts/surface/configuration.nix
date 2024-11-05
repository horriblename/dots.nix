# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "surface"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # encyrpted home partition
  security.pam.mount.enable = true;
  # NOTE since I cant pass mount options to btrfs (gets consumed by mount.crypt), the partition is structured like so:
  #    btrfs-partition /dev/sdaX
  #    - py            top level 5
  #      - files...
  security.pam.mount.extraVolumes = [
    ''
      <volume user="py"
              path="/dev/disk/by-uuid/3b3599cf-1783-4891-a4c6-15c50de09646"
              />
    ''
    # maybe add option "crypto_name" (see https://man.archlinux.org/man/mount.crypt.8#Mount_options)
  ];

  users.users.py = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "input" "disk"];
    packages = with pkgs; [
      firefox
    ];
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=900";

  services.openssh = {
    enable = true;
    #permitRootLogin = "yes";
  };

  nix = {
    buildMachines = [
      {
        hostName = "archbox";
        system = "x86_64-linux";
        maxJobs = 1;
        speedFactor = 2;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [];
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  services.thermald.enable = true;

  # system.copySystemConfiguration = true;

  system.stateVersion = "
        22.11
        "; # DO NOT CHANGE THIS
}
