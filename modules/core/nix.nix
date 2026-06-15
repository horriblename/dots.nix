{
  self,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib.attrsets) filterAttrs;
  flakeInputs = filterAttrs (_: input: input.flake or true) inputs;
  flakeRegistries = mapAttrs (_: input: {flake = input;}) flakeInputs;
in {
  nix.package = pkgs.nix;
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.registry =
    {
      n.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
      nixgl.flake = inputs.nixgl;
      dots.flake = self;
      roc.flake = inputs.roc;
    }
    // flakeRegistries;

  # TODO move out
  nix.settings = let
    inherit ((import ../../flake.nix).nixConfig) extra-substituters extra-trusted-public-keys;
  in {
    # nix-path = ["nixpkgs=${inputs.nixpkgs}" "dots=${self}"];
    substituters = extra-substituters;
    trusted-public-keys = extra-trusted-public-keys;
  };
}
