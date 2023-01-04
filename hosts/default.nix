{ nixpkgs, home-manager, hyprland, ... }:
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
	# FIXME standardize home-manager configs (vv this and home-manager-config)
	homeConfigurations."py@surface" = home-manager.lib.homeManagerConfiguration {
		inherit pkgs;
		modules = [
			hyprland.homeManagerModules.default
			{
				wayland.windowManager.hyprland = {
					enable = true;
					# package = inputs.hyprland.packages.${pkgs.system}.default.override {
					#   nvidiaPatches = true;
					# };
					systemdIntegration = true;
					extraConfig = builtins.readFile ./hyprland.conf;
				};
			}
		];
	};
	surface = lib.nixosSystem {
		inherit system;
		modules = [
			./surface/configuration.nix
			./surface/hardware-configuration.nix
				hmModule
				home-manager-config
				hyprland.nixosModules.default
				{ programs.hyprland.enable = true; }
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
