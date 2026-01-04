{
  description = "A very basic flake";

  inputs = {
    # attribute sets listing all dependency used within the flake?
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-wsl.url = "github:nix-community/NixOS-wsl";
    nix-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixpak.url = "github:nixpak/nixpak";
    nixpak.inputs.nixpkgs.follows = "nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    hyprland-xdg-toplevel-move = {
      url = "github:horriblename/hyprland-xdg-toplevel-move";
      inputs.hyprland.follows = "hyprland";
    };
    nvf = {
      url = "github:horriblename/nvf/personal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    md-img-paste-vim = {
      url = "github:ferrine/md-img-paste.vim";
      flake = false;
    };
    nixrun-nvim = {
      url = "github:horriblename/nixrun-nvim/v2";
      flake = false;
    };
    impurity.url = "github:outfoxxed/impurity.nix";
    rss-aggre.url = "github:horriblename/rss-aggregator";
    rss-aggre.inputs.nixpkgs.follows = "nixpkgs";

    roc = {
      url = "github:roc-lang/roc";
    };
    ssr-nvim.url = "github:horriblename/ssr.nvim/feature/escape";
    ssr-nvim.flake = false;
    luee.url = "github:horriblename/luee";
    luee.flake = false;
    tree-sitter-roc.url = "github:faldor20/tree-sitter-roc";
    tree-sitter-roc.inputs.nixpkgs.follows = "nixpkgs";
    gruvbox-kvantum.url = "github:sachnr/gruvbox-kvantum-themes";
    gruvbox-kvantum.flake = false;
    fcitx-virtual-keyboard-adapter.url = "github:horriblename/fcitx-virtualkeyboard-adapter";
    fcitx-virtual-keyboard-adapter.inputs.nixpkgs.follows = "nixpkgs";
    nixdroidpkgs.url = "github:horriblename/nixdroidpkgs";
    nixdroidpkgs.inputs.nixpkgs.follows = "nixpkgs";
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    perfanno-nvim = {
      url = "github:t-troebst/perfanno.nvim";
      flake = false;
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    styluslabs-write = {
      url = "git+https://github.com/horriblename/Write?ref=wayland&submodules=1";
      flake = false;
    };
    micros = {
      url = "github:snugnug/micros";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    anyrun,
    md-img-paste-vim,
    nixrun-nvim,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    defaultSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ];
    forEachSystem = lib.genAttrs defaultSystems;

    core = ./modules/core;
    pkgsFor = nixpkgs.legacyPackages;

    npinsFor = system: pkgsFor.${system}.callPackage ./npins/sources.nix {};

    genHomeConfig = {
      system,
      preset ? "minimal",
      extraModules ? [],
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.${system};
        modules =
          [
            ./modules/core
            ./modules/home/home.nix
            {dots = {inherit preset;};}
          ]
          ++ extraModules;
        extraSpecialArgs = {
          inherit self inputs;
          pins = npinsFor system;
        };
      };
  in {
    inherit inputs;
    homeConfigurations = {
      "deck" = genHomeConfig {
        preset = "deck";
        system = "x86_64-linux";
      };
      "py@ragnarok" = genHomeConfig {
        preset = "archbox";
        system = "x86_64-linux";
      };
      "py@surface" = genHomeConfig {
        preset = "surface";
        system = "x86_64-linux";
      };
      "pei.ching" = genHomeConfig {
        preset = "darwin-work";
        system = "x86_64-darwin";
        extraModules = [
          {
            home.username = "pei.ching";
            home.homeDirectory = "/Users/pei.ching";
            nix.settings.nix-path = ["nixpkgs=${inputs.nixpkgs}" "dots=${self}"];
          }
        ];
      };
      "py@linode" = genHomeConfig {
        preset = "linode";
        extraModules = [
          {
            programs.nvf.enable = lib.mkForce false;
          }
        ];
      };
      wslUser = genHomeConfig {
        preset = "minimal";
        system = "x86_64-linux";
        extraModules = [
          {
            home.username = lib.mkForce "nixos";
            home.homeDirectory = lib.mkForce "/home/nixos";
          }
        ];
      };
    };

    nixosConfigurations = let
      mkIsoModule = {
        pkgs,
        extraPackages,
      }: {
        imports = ["${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"];

        boot.kernelPackages = pkgs.linuxPackages_latest;

        # Needed for https://github.com/NixOS/nixpkgs/issues/58959
        boot.supportedFilesystems = lib.mkForce ["btrfs" "reisefs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];

        isoImage.squashfsCompression = "gzip -Xcompression-level 1"; # faster compression

        environment.systemPackages =
          extraPackages
          ++ [
            pkgs.neovim
            pkgs.git
            (pkgs.runCommandLocal "dots" {} ''
              mkdir -p $out/share
              ln -s ${self} $out/share
            '')
          ];
      };
    in {
      wsl = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self inputs;};
        modules = [
          inputs.nix-wsl.nixosModules.default
          ./hosts/wsl/configuration.nix
          {wsl.enable = true;}

          core
          ./modules/nixos
        ];
      };

      surface = let
        system = "x86_64-linux";
      in
        lib.nixosSystem {
          inherit system;
          pkgs = pkgsFor.${system};
          specialArgs = {inherit self inputs;};
          modules = [
            ./hosts/surface/configuration.nix
            ./hosts/surface/hardware-configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-3

            core
            ./modules/nixos
            {
              dots.preset = "desktop";
              nix.settings.trusted-users = ["py"];
            }
          ];
        };

      ragnarok = let
        system = "x86_64-linux";
      in
        lib.nixosSystem {
          inherit system;
          specialArgs = {inherit self inputs;};
          pkgs = pkgsFor.${system};
          modules = [
            core
            ./hosts/ragnarok/configuration.nix
            ./modules/nixos
            {
              dots.preset = "desktop";
              nix.settings.trusted-users = ["py"];
              dots.wayland.gaming = true;
            }
          ];
        };

      surface-iso = let
        system = "x86_64-linux";
        pkgs = pkgsFor.${system};
      in
        lib.nixosSystem {
          inherit system;
          modules = [
            (mkIsoModule {
              inherit pkgs;
              extraPackages = [self.nixosConfigurations.surface.config.system.build.toplevel];
            })
          ];
        };

      linode = let
        system = "x86_64-linux";
      in
        lib.nixosSystem {
          inherit system;
          pkgs = pkgsFor.${system};
          specialArgs = {inherit self inputs;};
          modules = [
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
      nixvm = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixvm/configuration.nix
          ./hosts/nixvm/hardware-configuration.nix

          ./modules/nixos
        ];
      };
    };
    darwinConfigurations = {
      work = let
        system = "x86_64-darwin";
        pkgs = pkgsFor.${system};
      in
        inputs.darwin.lib.darwinSystem {
          inherit system;
          modules = [
            {_module = {args = {inherit self inputs;};};}
            # ./configuration.nix
            core
            # home-manager.darwinModules.home-manager
            {
              environment.systemPackages = with pkgs; [nix];
              services.nix-daemon.enable = true;
              fonts = {
                packages = with pkgs; [
                  nerd-fonts.fira-code
                ];
              };
              # services.karabiner-elements.enable = true;
              #services.yabai.enable = true;
              # home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              # home-manager.users."pei.ching" = import ./modules/home/home.nix;

              # home-manager.extraSpecialArgs = {inherit self inputs; };
            }

            # {
            #   home-manager.users."pei.ching" = {
            #     home.username = lib.mkForce "pei.ching";
            #     home.homeDirectory = lib.mkForce "/Users/pei.ching";
            #   };
            # }
          ];
        };
    };

    nixOnDroidConfigurations = {
      kirin = let
        pkgs = pkgsFor."aarch64-linux";
      in
        inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          inherit pkgs;
          modules = [
            ({config, ...}: {
              user.shell = lib.getExe pkgs.zsh;
              environment.packages = [
                pkgs.busybox
                pkgs.neovim
                pkgs.zsh
                pkgs.git
                inputs.nixdroidpkgs.packages.${pkgs.stdenv.system}.openssh
                inputs.nixdroidpkgs.packages.${pkgs.stdenv.system}.termux-auth
              ];
              # TODO: extract along with genHomeConfig
              home-manager = {
                useGlobalPkgs = true;
                config = ./modules/home/home.nix;
                sharedModules = [
                  {
                    nix.package = lib.mkForce config.nix.package;
                    dots.preset = "droid";
                  }
                ];
                extraSpecialArgs = {inherit self inputs;};
              };

              system.stateVersion = "24.05";
            })
          ];
        };
    };

    packages = forEachSystem (system: let
      pkgs = pkgsFor.${system};
      overlayPkgs = builtins.intersectAttrs (self.overlay null null) pkgs;
    in
      overlayPkgs
      // {
        pins = npinsFor system;
        ghActionsBuilder = pkgs.callPackage ./pkgs/dummy.nix {
          buildInputs =
            [
              pkgs.hyprworkspaces
              pkgs.roc
              pkgs.roc-ls
              pkgs.styluslabs-write
              pkgs.nvtopPackages.nvidia
              inputs.nvf.packages.${pkgs.stdenv.system}.blink-cmp
            ]
            ++ (with inputs.nixdroidpkgs.packages.${pkgs.stdenv.system}.crossPkgs.aarch64-linux; [
              termux-auth
              openssh
            ]);
        };
        ghActionsBuilder2 = pkgs.callPackage ./pkgs/dummy.nix {
          buildInputs = [self.nixosConfigurations.surface.config.system.build.kernel];
        };

        styluslabs-write = pkgs.styluslabs-write.overrideAttrs (_final: prev: {
          src = inputs.styluslabs-write;
          postConfigure = ''
            echo "dirty" > ./GITREV
            echo "000" > ./GITCOUNT
          '';

          installPhase =
            prev.installPhase
            + ''
              wrapProgram $out/bin/Write \
                --set SDL_VIDEODRIVER wayland
            '';

          nativeBuildInputs =
            prev.nativeBuildInputs
            ++ [pkgs.wayland-scanner pkgs.makeWrapper];
          buildInputs =
            prev.buildInputs
            ++ [pkgs.wayland];
        });

        ollama-python = pkgs.python3.withPackages (p: with p; [ollama]);
        inherit (pkgs) nvtopPackages; # re-export so that allowUnfreePredicate applies
      });
    overlay = final: prev: let
      pins = npinsFor final.stdenv.system;
    in {
      hyprworkspaces = final.callPackage ./pkgs/hyprworkspaces/default.nix {};
      anyrunPackages = anyrun.packages.${final.stdenv.system};
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
      pendulum-nvim = final.callPackage ./pkgs/pendulum-nvim.nix {
        src = pins.pendulum-nvim;
        inherit (pins.pendulum-nvim) version;
      };
      fennel-ls = final.callPackage ./pkgs/fennel-ls.nix {};

      rssAggrePackages = inputs.rss-aggre.packages.${final.stdenv.system};

      roc = inputs.roc.packages.${final.stdenv.system}.default;
      roc-ls = inputs.roc.packages.${final.stdenv.system}.lang-server;
      treesitter-roc = inputs.tree-sitter-roc.packages.${final.stdenv.system}.default;
      neovim-treesitter-roc = final.callPackage ./pkgs/neovim-treesitter-roc.nix {treesitter-roc-src = inputs.tree-sitter-roc;};

      lf-custom = final.lf.overrideAttrs {
        src = final.fetchFromGitHub {
          owner = "gokcehan";
          repo = "lf";
          rev = "44e716d2f1b36c64a9ef77850edfa7afe0ac7616";
          hash = "sha256-ehM09K1UKHhQnJKDeqw+ogV996TPWdn3724mAT/XxE4=";
        };
        vendorHash = "sha256-ZShpWCfEVPLafrn3MvtxkRsBvwUEOiLBs1gZhKSBrsQ=";
      };

      ixwebsocket = final.callPackage ./pkgs/ixwebsocket.nix {pin = pins.IXWebSocket;};
      rag-cli = final.callPackage ./pkgs/cli-rag/default.nix {src = pins.rag-cli;};
      rag-cli-elm = final.callPackage ./pkgs/cli-rag/elm.nix {pin = pins.rag-cli;};

      microsContainer =
        (inputs.micros.lib.microsSystem {
          modules = [
            "${inputs.micros}/micros/modules/profiles/virtualization/iso-image.nix"
            {
              nixpkgs.hostPlatform = {inherit (final.stdenv) system;};
            }
          ];
        }).config.system.build.image;
    };
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);
    templates = import ./templates;
  };
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://horriblename.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "horriblename.cachix.org-1:FdI7l8gJJNhehkdW66BGcRrwn+14Iy+oC033gyONcs0="
    ];
  };
}
