# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{lib, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ragnarok"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.py = {};

  programs.zsh.enable = true;

  services = {
    btrfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
    };

    snapper = {
      cleanupInterval = "1w";
      configs = {
        home = {
          SUBVOLUME = "/home";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = 10;
          TIMELINE_LIMIT_WEEKLY = 3;
          TIMELINE_LIMIT_MONTHLY = 6;
          TIMELINE_LIMIT_QUARTERLY = 0;
          TIMELINE_LIMIT_YEARLY = 3;
          ALLOW_USERS = ["py"];
        };
      };
    };
  };

  virtualisation.waydroid.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  systemd.services.sshd.wantedBy = lib.mkForce [];

  security.tpm2.enable = false;
  systemd.tpm2.enable = false;

  # NOTE: allow connected devices by running `sudo sh -c 'usbguard generate-policy > /var/lib/usbguard/rules.conf'`
  # BEFORE enabling this on a new machine. Otherwise you will be locked out of your machine.
  services.usbguard.enable = true;

  services.nixseparatedebuginfod.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
