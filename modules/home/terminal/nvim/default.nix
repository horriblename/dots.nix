{
  self,
  lib,
  config,
  inputs,
  pkgs,
  impurity,
  ...
} @ args: let
  nix2Lua = import ./lib/toLua.nix;
  rawLua = str: {
    _type = "rawLua";
    lua = str;
  };
  setup = module: table: "require('${module}').setup ${nix2Lua table}";
in {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.impurity.nixosModules.default
  ];
  impurity.configRoot = self;

  xdg.configFile."nvim".source = ./config;

  programs.nvf = {
    enable = true;
    settings = import ./nvf.nix (args // {inherit (inputs) nvf;});
  };
}
