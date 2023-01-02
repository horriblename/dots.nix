{
  description = "A very basic flake";

  inputs = {
    # attribute sets listing all dependency used within the flake?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      ## home manager uses its own cache(?)
      ## nixpkgs get updated more frequently
      ## but hyprland uses cachix, which is separate from nixpkgs, so we can't
      ## use it...(?)
      # inputs.nixpkgs.follow = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };
      hmConfig = {
        nixos = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "py";
          homeDirectory = "/home/py";
          configuration = {
            imports = [
              ./hm/py/home.nix
            ];
          };
        };
      };
    };
}
