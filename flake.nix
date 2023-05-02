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
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    hyprland,
    ...
  } @ inputs: let
    # inputs = self.inputs;
    lib = nixpkgs.lib;
    defaultSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forEachSystem = lib.genAttrs defaultSystems;

    core = ./modules/core;
    wayland = ./modules/wayland;
    nixpkgsConfigs = {
      archbox = {system = "x86_64-linux";};
      surface = {system = "x86_64-linux";};
      droid = {system = "aarch64-linux";};
    };
    genHomeConfig = {
      machineName,
      homeConfigurationMode, # can be "terminal" or "full"
    }:
      assert lib.assertOneOf "homeConfigurationMode" homeConfigurationMode ["terminal" "full"];
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs nixpkgsConfigs.${machineName};
          modules =
            [
              core
              {inherit machineName;}
              ./modules/home/home.nix
              ./modules/home/terminal
            ]
            ++ lib.optionals (homeConfigurationMode == "full") [
              hyprland.homeManagerModules.default
              ./modules/home/graphical
            ];
          extraSpecialArgs = {inherit self inputs;};
        };
  in {
    homeConfigurations."py@archbox" = genHomeConfig {
      machineName = "archbox";
      homeConfigurationMode = "full";
    };
    homeConfigurations."py@surface" = genHomeConfig {
      machineName = "surface";
      homeConfigurationMode = "full";
    };
    homeConfigurations.nix-on-droid = genHomeConfig {
      machineName = "droid";
      homeConfigurationMode = "terminal";
    };
    nixosConfigurations.surface = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/surface/configuration.nix
        ./hosts/surface/hardware-configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-3

        core
        ./modules/nixos
        hyprland.nixosModules.default
        {programs.hyprland.enable = true;}
        wayland
      ];
    };
    nixosConfigurations.nixvm = lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixvm/configuration.nix
        ./hosts/nixvm/hardware-configuration.nix

        ./modules/nixos
        wayland
      ];
    };
    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      wf-osk = pkgs.callPackage ./pkgs/wf-osk.nix {};
      kanagawa-gtk = pkgs.callPackage ./pkgs/kanagawa-gtk {};
      hyprworkspaces = pkgs.callPackage ./pkgs/hyprworkspaces/default.nix {};
    });
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
