# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
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

  users.users.py = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "input" ];
    packages = with pkgs; [
      firefox
      thunderbird
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    keyd
  ];

  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    capslock = overload(control, esc)
  '';

  systemd.services.keyd = {
    enable = true;
    description = "key remapping daemon";
    requires = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
    wantedBy = [ "sysinit.target" ];
  };


  programs.neovim = {
    enable = true;
    configure = {
      customRC = builtins.readFile ../../pkgs/config.vim;
    };
  };

  services.openssh = {
    enable = true;
    #permitRootLogin = "yes";
  };

  nix = {
    settings = {
      substituters = [
        https://cache.nixos.org
        https://horriblename.cachix.org
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "horriblename.cachix.org-1:FdI7l8gJJNhehkdW66BGcRrwn+14Iy+oC033gyONcs0="
      ];
    };

    buildMachines = [{
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
      mandatoryFeatures = [ ];
    }];
    distributedBuilds = true;
    extraOptions = ''
      			builders-use-substitutes = true
      		'';
  };

  # system.copySystemConfiguration = true;

  system.stateVersion = "
        22.11
        "; # DO NOT CHANGE THIS

}


