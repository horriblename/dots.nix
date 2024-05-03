#!/usr/bin/env zsh

WORKDIR=$(mktemp -d)

nix eval -vvvvvvvvvvvvvvvvvvvv --raw --option trace-function-calls true $1 1>/dev/null 2> $WORKDIR/nix-function-calls.trace
stack-collapse.py $WORKDIR/nix-function-calls.trace > $WORKDIR/nix-function-calls.folded
inferno-flamegraph $WORKDIR/nix-function-calls.folded > $WORKDIR/nix-function-calls.svg
echo "$WORKDIR/nix-function-calls.svg"
