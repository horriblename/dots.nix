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
	 programs.neovim.plugins = [
		pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.nix ])
	 ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
