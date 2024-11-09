{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./options.nix
    ./desktop
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  time.timeZone = "Europe/Berlin";
  environment.systemPackages = with pkgs; [
    git
  ];

  programs.zsh.enable = true;

  nix = {
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
        ];
    };
  };
}
