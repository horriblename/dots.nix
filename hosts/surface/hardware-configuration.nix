# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6d56c01a-f88e-4757-b73c-7a60ac33d162";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/bd1e6603-e735-43bd-8d78-24e962cb308d";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4bad5d11-8134-4f24-850d-02950a7f71d4";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  boot.initrd.luks.devices."crypthome".device = "/dev/disk/by-uuid/3b3599cf-1783-4891-a4c6-15c50de09646";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E490-0A19";
      fsType = "vfat";
    };

  swapDevices = [ {device = "/dev/disk/by-label/swap";} ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
