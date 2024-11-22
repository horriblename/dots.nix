{
  lib,
  inputs,
  self,
  ...
}: {
  nix.settings.nix-path = ["nixpkgs=${inputs.nixpkgs}" "dots=${self}"];
  nix.extraOptions = "!include nix.local.conf";
  xdg.enable = true;
  imports = [
    ./module.nix
  ];

  impurity = {
    enable = builtins ? currentSystem && builtins.getEnv != "";

    configRoot = self;
  };

  programs.home-manager.enable = true;
  home = {
    username = lib.mkDefault "py";
    homeDirectory = lib.mkDefault "/home/py";
    stateVersion = "22.11";
  };
}
