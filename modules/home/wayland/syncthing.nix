{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  mkUntrustedDevice = name: {
    inherit name;
    untrusted = true;
    # NOTE: This password is kept on all trusted devices, in plain text.
    # If an attacker has access to a trusted device, protecting the password is
    # moot as they already have access to the folders we are trying to protect.
    # I guess with a leaked secret an attacker can continuously snoop in if
    # they also have access to the untrusted device but like, idk I'm not
    # that paranoid yet
    encryptionPasswordFile = "${config.xdg.configHome}/syncthing-poopy.secret";
  };

  isPoopy = config.dots.preset == "poopy";
in {
  config.services.syncthing = {
    enable = config.dots.wayland.enable;

    # NOTE: settings is set regardless of enable status to enable
    # NixOS module access to config
    settings = {
      devices = {
        poopy = {
          id = "AXAKT35-H3IRXLS-2SBCS3G-ZTHGTR3-BXLXDZE-RDY5OWW-D4KPGHL-IACICQN";
          addresses = [
            "tcp://sync.peynch.online"
          ];
        };

        ragnarok = {
          id = "6GNZ3AI-LWZYREV-HQN2RSI-WN5N3JW-GW5V3IY-2P2QAFU-F3YLBPX-QSSQGAM";
        };

        surface = {
          id = "E3JJSSC-H2SEIHJ-KHJB37F-RF6FWK5-MZRX4W2-S4Z32PL-7W4SWU6-RJTQJAB";
        };

        pix = {
          id = "V7UMOZP-5KSM24J-ZVHVELR-JSCNFJX-HL3NTYU-HE4IE3A-3SDSOOG-UBJJZQA";
          autoAcceptFolders = isPoopy;
        };
      };

      folders = {
        Documents = {
          path = "~/Documents";
          devices = [
            "pix"
            (mkUntrustedDevice "poopy")
            "ragnarok"
            "surface"
          ];
          type = mkIf isPoopy "receiveencrypted";
        };

        Pictures = {
          path = "~/Pictures";
          devices = [
            (mkUntrustedDevice "poopy")
            "ragnarok"
            "surface"
          ];
          type = mkIf (config.dots.preset == "poopy") "receiveencrypted";
        };

        Music = {
          path = "~/Music";
          devices = [
            "pix"
            "poopy"
            "ragnarok"
            "surface"
          ];
        };
      };
    };
  };
}
