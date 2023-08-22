{
  description = "A very basic flake";

  inputs = {
    # attribute sets listing all dependency used within the flake?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-border-actions = {
      url = "github:horriblename/hyprland-border-actions";
      inputs.hyprland.follows = "hyprland";
    };
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
    };
    md-img-paste-vim = {
      url = "github:ferrine/md-img-paste.vim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-index-database,
    nixos-hardware,
    home-manager,
    hyprland,
    anyrun,
    md-img-paste-vim,
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
          pkgs = import nixpkgs ({overlays = [self.overlay];} // nixpkgsConfigs.${machineName});
          modules =
            [
              core
              nix-index-database.hmModules.nix-index
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
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlay];
      };
    in {
      inherit (pkgs) wf-osk kanagawa-gtk hyprworkspaces;
      ghActionsBuilder = pkgs.callPackage ./pkgs/dummy.nix {
        buildInputs = with pkgs; [wf-osk kanagawa-gtk hyprworkspaces];
      };
    });
    overlay = final: prev: {
      wf-osk = final.callPackage ./pkgs/wf-osk.nix {};
      kanagawa-gtk = final.callPackage ./pkgs/kanagawa-gtk.nix {};
      hyprworkspaces = final.callPackage ./pkgs/hyprworkspaces/default.nix {};
      anyrunPackages = anyrun.packages.${final.system};
      md-img-paste-vim = final.vimUtils.buildVimPluginFrom2Nix {
        pname = "md-img-paste-vim";
        version = "master";
        src = md-img-paste-vim;
      };
      lf = final.callPackage ./pkgs/lf-sixel.nix {};

      mpv = prev.mpv.override {scripts = [prev.mpvScripts.mpris];};
    };
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
