{ nixpkgs, self, ... }:
let
	inputs = self.inputs;
	hmModule = inputs.home-manager.nixosModules.home-manager;
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
