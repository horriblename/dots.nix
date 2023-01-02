{
	description = "A very basic flake";

	inputs = { # attribute sets listing all dependency used within the flake?
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

	};

	outputs = { self, nixpkgs } @ inputs: 
		let
		system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
# config.allowUnfree = true;
	};
	lib = nixpkgs.lib;
	in {
		nixosConfigurations = {
			nixos = lib.nixosSystem {
					inherit system;
					modules = [ 
						./configuration.nix
						./hardware-configuration.nix
					];
			};
		};
	};
}
