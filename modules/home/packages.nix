{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		# cli tools
		file # lf config dependency
		bat
		fzf
		ripgrep
		fd
		lazygit

		# compilers
		gcc
		cargo
		go
	];
}
