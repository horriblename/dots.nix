{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		foot
		mpv
		pavucontrol
		tofi
		xournalpp
	];
}
