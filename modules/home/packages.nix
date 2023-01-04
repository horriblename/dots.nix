{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		# cli tools
		file # lf config dependency
		bat
		trash-cli
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
