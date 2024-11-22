{
  self,
  lib,
  inputs,
  pkgs,
  config,
  impurity,
  ...
} @ args: {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.impurity.nixosModules.default
  ];
  xdg.configFile."nvim".source = impurity.link ./config;

  programs.nvf = {
    enable = true;
    settings = import ./nvf.nix args;
  };
}
