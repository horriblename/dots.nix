{
  self,
  lib,
  inputs,
  pkgs,
  config,
  ...
} @ args: {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.impurity.nixosModules.default
  ];
  impurity.configRoot = self;

  xdg.configFile."nvim".source = ./config;

  programs.nvf = {
    enable = true;
    settings = import ./nvf.nix args;
  };
}
