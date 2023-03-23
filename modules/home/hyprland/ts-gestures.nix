{ pkgs
, lib
, config
, inputs
, ...
}:
let
	osk-size = {
		w = "700";
		h = "340";
	};
  ts-gestures = pkgs.writeShellScriptBin "ts-gestures" ''
		#!/bin/sh

		# hide_cursor_on_touch doesn't work after starting lisgd
		hyprctl keyword misc:hide_cursor_on_touch 0
		(sleep 5 && hyprctl keyword misc:hide_cursor_on_touch 1) &

		# [nfingers,gesture,edge,distance,actmode,command]
		exec lisgd -d /dev/input/by-path/platform-INT33C3:00-event  \
			-g '1,DU,L,*,R,brightnessctl s +2%' \
			-g '1,UD,L,*,R,brightnessctl s 2%-' \
			-g '1,LR,L,*,R,brightnessctl s 2%-' \
			-g '1,BL,DLUR,*,R,wf-osk -w ${osk-size.w} --height ${osk-size.h} -a bottom' \
			-g '3,UD,*,*,R,hyprctl dispatch killactive 1' \
			-g '4,LR,*,*,R,hyprctl dispatch movetoworkspace +1' \
			-g '4,RL,*,*,R,hyprctl dispatch movetoworkspace -1' \
			-g '1,UD,U,*,R,hyprctl dispatch togglespecialworkspace ""'

			# -g '3,LR,*,*,R,hyprctl dispatch workspace e-1' \
			# -g '3,RL,*,*,R,hyprctl dispatch workspace e+1' \
  '';
in
{ 
	home.packages = [ts-gestures];
}