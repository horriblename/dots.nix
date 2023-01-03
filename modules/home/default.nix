{ config, pkgs, home-manager, ... }:
let
  user = "py";
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

	imports = [
		./apps.nix
		./packages.nix
		# ./foot
		./shell
		./lf
	];

  programs.btop.enable = true;

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
