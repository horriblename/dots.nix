{
  description = "A very basic flake";

  inputs = {
    # attribute sets listing all dependency used within the flake?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      ## home manager uses its own cache(?)
      ## nixpkgs get updated more frequently
      ## but hyprland uses cachix, which is separate from nixpkgs, so we can't
      ## use it...(?)
      # inputs.nixpkgs.follow = "nixpkgs";
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
      # FIXME standardize home-manager configs (vv this and home-manager-config)
      homeConfigurations.py = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/home/home.nix
          hyprland.homeManagerModules.default
          {
            wayland.windowManager.hyprland = {
              enable = true;
              # package = inputs.hyprland.packages.${pkgs.system}.default.override {
              #   nvidiaPatches = true;
              # };
              systemdIntegration = true;
              # extraConfig = builtins.readFile ../modules/home/hyprland/hyprland.conf;
            };
          }
        ];
      };
      surface = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/surface/configuration.nix
          ./hosts/surface/hardware-configuration.nix
          nixos-hardware.nixosModules.microsoft-surface-pro-3

          core
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
          wayland
        ];
      };
      nixvm = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nixvm/configuration.nix
          ./hosts/nixvm/hardware-configuration.nix
          wayland
        ];
      };
    };
}
