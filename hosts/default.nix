{ nixpkgs, home-manager, ... }:
let
	# inputs = self.inputs;
	lib = nixpkgs.lib;
	system = lib.currentSystem;
	pkgs = import nixpkgs {
		inherit system;
		# config.allowUnfree = true;
	};
	hmModule = home-manager.nixosModules.home-manager;
in
{
	surface = lib.nixosSystem {
		inherit system;
		modules = [
			./surface/configuration.nix
			./surface/hardware-configuration.nix
				hmModule
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.py = import ../modules/home;
				}
		];
	};
        nixvm = lib.nixosSystem {
          inherit system;
          modules = [
            ./nixvm/configuration.nix
            ./nixvm/hardware-configuration.nix
				hmModule
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.py = import ../modules/home;
				}
          ];
        };
      }
