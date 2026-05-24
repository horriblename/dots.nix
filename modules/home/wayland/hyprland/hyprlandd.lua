-- Monitor configuration is done in nix

_G.hl = _G.hl or {}

hl.config = {
	general = {
		border_size = 5,
	},

	debug = {
		disable_logs = 0,
	},

	device = {
		name = "ntrg0001:01-1b96:1b0",
		output = "eDP-1",
	},
}

hl.bind("ALT+period", hl.dsp.focus({ workspace = "+1" }))
hl.bind("ALT+comma", hl.dsp.focus({ workspace = "-1" }))

-- hl.bind("ALT+MINUS", hl.dsp.workspace("special")
-- hl.bind("ALT+MINUS", hl.dsp.togglespecialworkspace(""))
-- hl.bind("ALT+CONTROL+MINUS", hl.dsp.movetoworkspace("special"))
-- hl.bind("ALT+SHIFT+MINUS", hl.dsp.movetoworkspacesilent("special"))

hl.bind("ALT+GRAVE", hl.dsp.window.pin())
hl.bind("ALT+F", hl.dsp.window.float())
hl.bind("ALT+SHIFT+F", hl.dsp.window.fullscreen())

hl.bind("SUPER+ALT+Q", hl.dsp.window.close())
hl.bind("SUPER+ALT+SHIFT+E", hl.dsp.exit())

-- hl.bind("ALT+N", hl.dsp.cyclenext(""))
-- hl.bind("ALT+B", hl.dsp.cyclenext("prev"))

hl.bind("ALT+h", hl.dsp.focus({ direction = "l" }))
hl.bind("ALT+l", hl.dsp.focus({ direction = "r" }))
hl.bind("ALT+k", hl.dsp.focus({ direction = "u" }))
hl.bind("ALT+j", hl.dsp.focus({ direction = "d" }))

local eflag = { release = true }
hl.bind("ALT+SHIFT+PERIOD", hl.dsp.focus({ workspace = "+1" }), eflag)
hl.bind("ALT+SHIFT+COMMA", hl.dsp.focus({ workspace = "-1" }), eflag)

-- hl.bind("ALTCONTROL+H", hl.dsp.resizeactive(-40, 0), eflag)
-- hl.bind("ALTCONTROL+L", hl.dsp.resizeactive(40, 0), eflag)
-- hl.bind("ALTCONTROL+K", hl.dsp.resizeactive(0, -40), eflag)
-- hl.bind("ALTCONTROL+J", hl.dsp.resizeactive(0, 40), eflag)


hl.bind("ALT+X", hl.dsp.exec_cmd("foot"))

-- bindm=ALT,mouse:272,movewindow
-- bindm=ALT,mouse:273,resizewindow

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "down", action = "close" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "resize" })
hl.gesture({ fingers = 4, direction = "up", action = "move" })
hl.gesture({ fingers = 4, direction = "pinchout", action = "close" })

hl.plugin.touch_gestures = {
	workspace_swipe_fingers = 4,
	workspace_swipe_edge = "d",
	resize_on_border_long_press = true,
	sensitivity = 5.0,
}

-- if hl.plugin.hyprgrass then
-- 	hl.plugin.hyprgrass.bind {
-- 		gesture = "edge:l:r",
-- 		action = hl.dsp.exec_cmd('hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: left -> right"'),
-- 	}
-- end

--plugin {
--	touch_gestures {
--		workspace_swipe_fingers = 4
--		workspace_swipe_edge = d
--		resize_on_border_long_press = true
--		sensitivity = 5.0
--
--		# hyprgrass-bind = , edge:l:r, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: left -> right"
--		# hyprgrass-bind = , edge:r:l, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: right -> left"
--		# hyprgrass-bind = , edge:u:d, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: up -> down"
--		hyprgrass-bind = , edge:d:u, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: down -> up"
--		hyprgrass-bind = , pinch:4:i, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "pinch: 4 in"
--		hyprgrass-bind = , pinch:4:o, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "pinch: 4 out"
--		# hyprgrass-bind = , pinch:5:i, exec, hyprctl notify -1 10000 "rgb(ff1ea4)" "pinch: 5 in"
--		# hyprgrass-bind = , pinch:5:o, exec, hyprctl notify -1 10000 "rgb(ff1ea4)" "pinch: 5 out"
--
--		hyprgrass-bind = , swipe:3:u, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "Swipe 3 up"
--		hyprgrass-bind = , swipe:4:d, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "Swipe 4 down"
--		hyprgrass-bind = , swipe:4:l, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "Swipe 4 left"
--
--		hyprgrass-bind = , edge:l:rd, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: left -> right-down"
--		hyprgrass-bind = , edge:l:ru, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "edge: left -> right-up"
--
--		# hyprgrass-bindl = , edge:l:r, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "locked edge: left -> right"
--
--		# hyprgrass-bind = , longpress:2, exec, hyprctl notify -1 10000 "rgb(ff1ea3)" "longpress:2"
--		# hyprgrass-bindm = , longpress:3, movewindow
--		# hyprgrass-bindm = , longpress:4, resizewindow
--
--		hyprgrass-hl.gesture({finger = swipe, direction =  4, action =  up,  fullscreen}
--		# hyprgrass-hl.gesture({finger = swipe, direction =  3, action =  up,  move}
--		hyprgrass-hl.gesture({finger = swipe, direction =  3, action =  swipe, workspace}
--		# hyprgrass-hl.gesture({finger = swipe, direction =  3, action =  down,   close}
--		hyprgrass-hl.gesture({finger = longpress, direction =  3, action =  swipe , workspace}
--		hyprgrass-hl.gesture({finger = edge, direction =  u, action =  down, special}
--		hyprgrass-hl.gesture({finger = edge, direction =  l, action =  right, workspace}
--		hyprgrass-hl.gesture({finger = edge, direction =  r, action =  left, workspace}
--		hyprgrass-hl.gesture({finger = edge, direction =  u, action =  horizontal, workspace}
--		# hyprgrass-hl.gesture({finger = pinch, direction =  4, action =  pinchin, close}
--		# hyprgrass-hl.gesture({finger = pinch, direction =  4, action =  pinchout, float}
--	}
--}
