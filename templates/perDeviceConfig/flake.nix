{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia"
        ];
    };
  in {
    packages.x86_64-linux.default = pkgs.symlinkJoin {
      name = "user-packages";
      paths = with pkgs; [
        inputs.nixGL.packages.${system}.default
      ];
    };
  };
}
