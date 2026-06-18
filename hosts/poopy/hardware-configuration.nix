{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot = {
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
        extraConfig = ''
          serial --unit=0 --speed=115200
          terminal_input serial console
          terminal_output serial console
        '';
      };
    };

    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = ["nvme"];
    };

    kernelParams = ["console=tty0" "console=ttyS0,115200"];
  };

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
