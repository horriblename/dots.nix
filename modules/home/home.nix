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
    # external modules
    ../core
    inputs.impurity.nixosModules.default
    inputs.nix-index-database.hmModules.nix-index

    # custom options
    ./module.nix
  ];

  impurity = {
    enable = builtins ? currentSystem && builtins.getEnv "IMPURITY_PATH" != "";

    configRoot = self;
  };

  programs.home-manager.enable = true;
  home = {
    username = lib.mkDefault "py";
    homeDirectory = lib.mkDefault "/home/py";
    stateVersion = "22.11";
  };
}
