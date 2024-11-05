{pkgs, ...}: {
  environment.etc."keyd/default.conf".text = ''
    [ids]
    *

    [main]
    capslock = overload(control, esc)
  '';

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
}
