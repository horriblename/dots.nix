{ nixpkgs, home-manager, pkgs, ... }:
{
	programs.lf = {
		enable = true;
		extraConfig = builtins.readFile ./lfrc;
		previewer.source = ./preview;
	};

	xdg.configFile."lf/icons".text = builtins.readFile ./icons;
}
