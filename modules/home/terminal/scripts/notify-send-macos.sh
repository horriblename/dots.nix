#!/bin/bash

# notify-send adapter for terminal-notify (or growlnotify), as used by 
# vagrant-notify <https://github.com/fgrehm/vagrant-notify#os-x>
#
# JSB / 2015-06-09
# ----

### BEGIN: boilerplate bash

SCRIPT_PATH=$( cd $(dirname $0) ; pwd -P )
SCRIPT_NAME=`basename ${BASH_SOURCE[0]}`

set -eu
trap "{ echo -e \"\nError: Something went wrong in $SCRIPT_NAME. ($*)\">&2; exit 1; }" ERR

### END: boilerplate bash

USAGE='
Simple notify-send adapter for MacOS

Usage:

    notify-send {title} [body]
'
usage() {
    echo "$USAGE" >&2
}

# provide a prefix
context=""

escape_quotes() {
    sed -e 's/"/\\"/g' <<< "$@"
}

if [ -z ${1+x} ]; then
    usage
    exit 1
fi

title="$1"
shift

body="$@"

osascript << EOF
display notification "$(escape_quotes "$body")" with title "$(escape_quotes "$title")"
EOF
