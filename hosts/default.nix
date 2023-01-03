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
        nixvm = lib.nixosSystem {
          inherit system;
          modules = [
            ./nixvm/configuration.nix
            ./nixvm/hardware-configuration.nix
				hmModule
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.py = import ../hm/py/home.nix;
				}
          ];
        };
      }
