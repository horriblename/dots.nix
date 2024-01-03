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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixrun-nvim = {
      url = "github:horriblename/nixrun-nvim";
      flake = false;
    };
    impurity.url = "github:outfoxxed/impurity.nix";
    rss-aggre.url = "github:horriblename/rss-aggregator";
    rss-aggre.inputs.nixpkgs.follows = "nixpkgs";
    roc = {
      url = "github:roc-lang/roc";
    };
    tree-sitter-roc.url = "github:horriblename/tree-sitter-roc";
    tree-sitter-roc.inputs.nixpkgs.follows = "nixpkgs";
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
    nixrun-nvim,
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
      linode = {system = "x86_64-linux";};
      droid = {system = "aarch64-linux";};
    };
    genHomeConfig = {
      machineName,
      homeConfigurationMode, # can be "terminal" or "full"
      extraModules ? [],
    }:
      assert lib.assertOneOf "homeConfigurationMode" homeConfigurationMode ["terminal" "full"];
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs ({overlays = [self.overlay];} // nixpkgsConfigs.${machineName});
          modules =
            [
              core
              nix-index-database.hmModules.nix-index
              {inherit machineName;}
              # enable impurity if $IMPURITY_PATH was set in impure mode
              {impurity.enable = builtins ? getEnv && builtins.getEnv "IMPURITY_PATH" != "";}
              ./modules/home/home.nix
              ./modules/home/terminal
            ]
            ++ lib.optionals (homeConfigurationMode == "full") [
              hyprland.homeManagerModules.default
              ./modules/home/graphical
            ]
            ++ extraModules;
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
    homeConfigurations."py@linode" = genHomeConfig {
      machineName = "linode";
      homeConfigurationMode = "terminal";
      extraModules = [
        {
          impurity.enable = lib.mkForce false;
          programs.neovim-flake.enable = lib.mkForce false;
        }
      ];
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
    nixosConfigurations.linode = let
      system = "x86_64-linux";
    in
      lib.nixosSystem {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlay inputs.agenix.overlays.default];
        };
        modules = [
          {_module.args = {inherit self inputs;};}
          inputs.agenix.nixosModules.default
          inputs.rss-aggre.nixosModules.default
          {
            services.rss-aggre.enable = true;
            services.rss-aggre.package = inputs.rss-aggre.packages.${system}.rss-aggre;
            # services.postgresql.package = nixpkgs.legacyPackages.${system}.postgresql_15;
            age.secrets.rssAggreJwtSecret.file = ./secrets/rssAggreJwtSecret.age;
          }
          ./hosts/linode/configuration.nix
          ./hosts/linode/hardware-configuration.nix

          core
          ./modules/nixos
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
      inherit
        (pkgs)
        wf-osk
        kanagawa-gtk
        hyprworkspaces
        anyrunPackages
        md-img-paste-vim
        nixrun-nvim
        fennel-ls
        mpv
        roc
        roc-ls
        libcallex-vim
        godot4-mono
        treesitter-roc
        ;
      ghActionsBuilder = pkgs.callPackage ./pkgs/dummy.nix {
        buildInputs = with pkgs; [wf-osk kanagawa-gtk hyprworkspaces roc roc-ls];
      };
    });
    overlay = final: prev: {
      wf-osk = final.callPackage ./pkgs/wf-osk.nix {};
      kanagawa-gtk = final.callPackage ./pkgs/kanagawa-gtk.nix {};
      hyprworkspaces = final.callPackage ./pkgs/hyprworkspaces/default.nix {};
      anyrunPackages = anyrun.packages.${final.system};
      md-img-paste-vim = final.vimUtils.buildVimPlugin {
        pname = "md-img-paste-vim";
        version = "master";
        src = md-img-paste-vim;
      };
      nixrun-nvim = final.vimUtils.buildVimPlugin {
        pname = "nixrun";
        version = "master";
        src = nixrun-nvim;
      };
      libcallex-vim = final.vimUtils.buildVimPlugin {
        pname = "libcallex-vim";
        version = "git";
        src = final.callPackage ./pkgs/libcallex-vim.nix {};
      };
      fennel-ls = final.callPackage ./pkgs/fennel-ls.nix {};
      godot4-mono = final.callPackage ./pkgs/godot4-mono.nix {};

      mpv = prev.mpv.override {scripts = [prev.mpvScripts.mpris];};

      rssAggrePackages = inputs.rss-aggre.packages.${final.system};

      roc = inputs.roc.packages.${final.system}.default;
      roc-ls = inputs.roc.packages.${final.system}.lang-server;
      treesitter-roc = inputs.tree-sitter-roc.defaultPackage.${final.system};
    };
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
    templates = import ./templates;
  };
}
