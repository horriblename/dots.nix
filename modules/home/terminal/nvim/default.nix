{
  self,
  lib,
  config,
  inputs,
  pkgs,
  impurity,
  ...
}@args: let
  nix2Lua = import ./lib/toLua.nix;
  rawLua = str: {
    _type = "rawLua";
    lua = str;
  };
  setup = module: table: "require('${module}').setup ${nix2Lua table}";
in {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
    inputs.impurity.nixosModules.default
  ];
  impurity.configRoot = self;

  xdg.configFile."nvim".source = ./config;

  programs.neovim-flake = {
    enable = true;
    settings = import ./neovim-flake.nix (args // {inherit (inputs) neovim-flake;});
  };
}
