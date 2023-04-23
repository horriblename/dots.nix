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
    hyprland.url = "github:horriblename/Hyprland/nix-pluginenv";
    hyprbars.url = "github:horriblename/hyprbars-nix";
    hyprbars.inputs.hyprland.follows = "hyprland";
    hyprbars.inputs.nixpkgs.follows = "nixpkgs";
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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      # config.allowUnfree = true;
    };

    core = ./modules/core;
    wayland = ./modules/wayland;
    machineNames = [
      "archbox"
      "surface"
    ];
    homeConfigs =
      builtins.listToAttrs
      (map
        (machineName: {
          name = "py@${machineName}";
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              core
              ./modules/home/home.nix
              {
                machineName = machineName;
                homeConfigurationMode = "graphical";
              }
              hyprland.homeManagerModules.default
            ];
            extraSpecialArgs = {inherit self inputs;};
          };
        })
        machineNames);
  in {
    homeConfigurations = homeConfigs;
    nixosConfigurations.surface = lib.nixosSystem {
      inherit system;
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
      inherit system;
      modules = [
        ./hosts/nixvm/configuration.nix
        ./hosts/nixvm/hardware-configuration.nix

        ./modules/nixos
        wayland
      ];
    };
    packages = {
      wf-osk = pkgs.callPackage ./pkgs/wf-osk.nix {};
      kanagawa-gtk = pkgs.callPackage ./pkgs/kanagawa-gtk {};
    };
    formatter.${system} = pkgs.alejandra;
  };
}
