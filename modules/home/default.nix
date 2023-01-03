{ config, pkgs, home-manager, ... }:
let
  user = "py";
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";

	imports = [
		./packages.nix
		#./shell/default
	];

	# shell = "zsh";

  programs.btop.enable = true;

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
