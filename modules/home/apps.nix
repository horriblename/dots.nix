{ inputs, pkgs, config, ... }:
{
	home.packages = with pkgs; [
		xournalpp
		foot
	];
}
