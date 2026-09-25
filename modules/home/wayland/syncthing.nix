{config, ...}: {
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

        pixie = {
          id = "6MDHOXI-2EA5WV4-XUS2A3X-FNDYJAE-OUNYZWW-NYTMCBF-CH2Z3PY-NAZ4GQN";
        };

        pix = {
          id = "V7UMOZP-5KSM24J-ZVHVELR-JSCNFJX-HL3NTYU-HE4IE3A-3SDSOOG-UBJJZQA";
        };

        kirin = {
          id = "25OXMZ6-2HTHN7O-QHD5GUX-BHAPJ22-Z6UBP2X-EA53FV4-MJYEGNM-IUN2XAP";
        };
      };

      folders = {
        Documents = {
          path = "~/Documents";
          devices = [
            "pix"
            "poopy"
            "ragnarok"
            "surface"
          ];
        };

        Pictures = {
          path = "~/Pictures";
          devices = [
            "poopy"
            "ragnarok"
            "surface"
          ];
        };
      };
    };
  };
}
