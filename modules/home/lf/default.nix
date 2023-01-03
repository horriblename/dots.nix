{ nixpkgs, home-manager, pkgs, ... }:
{
	programs.lf = {
		enable = true;
		extraConfig = builtins.readFile ./lfrc;
		previewer.source = ./preview;
	};
}
