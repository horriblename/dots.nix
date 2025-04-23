#!/bin/sh

inhibitFile="${XDG_RUNTIME_DIR:-$HOME/.local/state}/fcitx-virtual-keyboard-adapter.stop"
service="wvkbd.service"
function checkInhibitor() {
	if [ -f "$inhibitFile" ]; then
		exit 0;
	fi
}

function printHelp() {
	echo 'Usage:'
	echo ''
	echo '    osk-control COMMAND'
	echo ''
	echo 'COMMAND can be:'
	echo ''
	echo '    activate      Show on-screen keyboard'
	echo '    deactivate    Hide on-screen keyboard'
	echo '    auto-on       Turn on auto-show'
	echo '    auto-off      Turn off auto-show'
	echo '    auto-toggle   Toggle auto-show'
}

case "$1" in
	activate)
		checkInhibitor
		systemctl kill --signal=SIGUSR2 --user "$service"
		;;
	deactivate)
		checkInhibitor
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

