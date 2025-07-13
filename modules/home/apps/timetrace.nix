{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkAfter;
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit pkgs lib;
  };

  timetrace-bwrapped =
    (mkNixPak {
      config = {sloth, ...}: {
        app.package = pkgs.timetrace;
        app.binPath = "bin/timetrace";
        bubblewrap = {
          network = false;
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.config/timetrace"))
              (sloth.concat' sloth.homeDir "/.timetrace")
            ]
          ];
          bind.dev = ["/dev"];
        };
      };
    }).config.script;
in {
  home.packages = [
    timetrace-bwrapped
  ];

  # use mkAfter to ensure it's loaded after compinit and co.
  programs.zsh.initExtra = mkAfter ''
    eval "$(${timetrace-bwrapped}/bin/timetrace completion zsh)"
  '';
}
