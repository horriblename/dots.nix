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
    ./nvf.nix
  ];
  xdg.configFile."nvim".source = impurity.link ./config;

  programs.nvf = {
    enable = true;
  };
}
