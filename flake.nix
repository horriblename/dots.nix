{
  description = "A very basic flake";

  inputs = {
    # attribute sets listing all dependency used within the flake?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, hyprland, ... } @ inputs:
    let
      # inputs = self.inputs;
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # config.allowUnfree = true;
      };

      core = ./modules/core;
      wayland = ./modules/wayland;
    in
    {
      homeConfigurations.py = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          core
          ./modules/home/home.nix
          hyprland.homeManagerModules.default
        ];
        extraSpecialArgs = { inherit inputs; };
      };
      nixosConfigurations.surface = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/surface/configuration.nix
          ./hosts/surface/hardware-configuration.nix
          nixos-hardware.nixosModules.microsoft-surface-pro-3

          core
          ./modules/nixos
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
          wayland
        ];
      };
      nixosConfigurations.nixvm = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixvm/configuration.nix
          ./hosts/nixvm/hardware-configuration.nix

          ./modules/nixos
          wayland
        ];
      };
    };
}
