#!/bin/sh

inhibitFile="${XDG_RUNTIME_DIR:-$HOME/.local/state}/fcitx-virtual-keyboard-adapter.stop"
service="wvkbd.service"

function isKeyboardConnected() {
	libinput list-devices | awk '
BEGIN {
	blacklist[0] = "Video Bus"
	blacklist[1] = "Surface Pro 3/4 Buttons"
	blacklist[2] = "keyd virtual keyboard"
	exitcode = 1
}

# Capture the device name
/^Device:/ {
	device = substr($0, index($0, ":") + 1)
	gsub(/^ +| +$/, "", device)
}

# When we see capabilities, check if it’s a keyboard
/^Capabilities:/ {
	if (index($0, "keyboard")) {
		skip = 0
		for (i in blacklist) {
			if (device == blacklist[i]) {
				skip = 1
				break
			}
		}
		if (!skip) {
			# Found a real keyboard → exit success immediately
			print("keyboard found: ", device) > "/dev/stderr"
			exitcode = 0
			exit 0
		}
	}
}

END {
    exit exitcode
}
'
}

function checkInhibitor() {
	if [ -f "$inhibitFile" ]; then
		exit 0;
	fi
}

echoerr () {
	echo "$@" >&2
}

function printHelp() {
	echoerr 'Usage:'
	echoerr ''
	echoerr '    osk-control COMMAND'
	echoerr ''
	echoerr 'COMMAND can be:'
	echoerr ''
	echoerr '    activate      Show on-screen keyboard'
	echoerr '    deactivate    Hide on-screen keyboard'
	echoerr '    auto-on       Turn on auto-show'
	echoerr '    auto-off      Turn off auto-show'
	echoerr '    auto-toggle   Toggle auto-show'
}

case "$1" in
	activate)
		checkInhibitor
		if isKeyboardConnected; then
			echoerr "keyboard exists, ignoring activate request"
			exit 0
		fi
		systemctl kill --signal=SIGUSR2 --user "$service"
		;;
	deactivate)
		checkInhibitor
		if isKeyboardConnected; then
			echoerr "keyboard exists, ignoring deactivate request"
			exit 0
		fi
		systemctl kill --signal=SIGUSR1 --user "$service"
		;;
	auto-on)
		if [ -f "$inhibitFile" ]; then
			rm "$inhibitFile"
		fi
		;;
	auto-off)
		systemctl kill --signal=SIGUSR1 --user "$service"
		mkdir -p $(dirname "$inhibitFile")
		touch "$inhibitFile"
		;;
	auto-toggle)
		if [ -f "$inhibitFile" ]; then
			rm "$inhibitFile"
		else
			systemctl kill --signal=SIGUSR1 --user "$service"
			mkdir -p $(dirname "$inhibitFile")
			touch "$inhibitFile"
		fi
		;;
	*)
		printHelp
		exit 1
esac

