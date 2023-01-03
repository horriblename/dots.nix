{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		bat
		fzf
		ripgrep
		fd
		lazygit
	];
}
