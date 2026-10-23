{
  lib,
  config,
  pkgs,
  impurity,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.dots.wayland.enable {
    environment.etc = {
      "keyd/default.conf".source = impurity.link ./keyd.conf;
    };

    systemd.services.keyd = {
      enable = true;
      description = "key remapping daemon";
      requires = ["local-fs.target"];
      after = ["local-fs.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.keyd}/bin/keyd";
      };
      wantedBy = ["sysinit.target"];
    };
  };
}
