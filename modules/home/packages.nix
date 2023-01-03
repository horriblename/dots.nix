{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		fzf
		ripgrep
		fd
		lazygit
	];
}
