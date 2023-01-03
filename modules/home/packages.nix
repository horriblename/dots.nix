{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		file # lf config dependency
		bat
		fzf
		ripgrep
		fd
		lazygit
	];
}
