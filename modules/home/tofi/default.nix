{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		tofi
	];

	xdg.configFile."tofi/gruvbox-menu.ini".text = builtins.readFile ./gruvbox-menu.ini;
}
