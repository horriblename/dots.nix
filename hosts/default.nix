{ nixpkgs, home-manager, ... }:
let
	# inputs = self.inputs;
	lib = nixpkgs.lib;
	system = lib.currentSystem;
	pkgs = import nixpkgs {
		inherit system;
		# config.allowUnfree = true;
	};
	wayland = ../modules/wayland;
	hmModule = home-manager.nixosModules.home-manager;
	home-manager-config = {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.users.py = import ../modules/home;
	};
in
{
	surface = lib.nixosSystem {
		inherit system;
		modules = [
			./surface/configuration.nix
			./surface/hardware-configuration.nix
				hmModule
				home-manager-config
		];
	};
        nixvm = lib.nixosSystem {
          inherit system;
          modules = [
            ./nixvm/configuration.nix
            ./nixvm/hardware-configuration.nix

				hmModule
				wayland
				home-manager-config
          ];
        };
      }
