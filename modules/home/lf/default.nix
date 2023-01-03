{ nixpkgs, home-manager, ... }:
{
	programs.lf = {
		enable = true;
		extraConfig = builtins.readFile ./lfrc;
		previewer.source = ./preview;
	};
}
