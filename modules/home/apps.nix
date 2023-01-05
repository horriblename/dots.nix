{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [

		# utilities
		foot
		pavucontrol
		tofi

		# general user apps
		mpv
		xournalpp
	];
}
