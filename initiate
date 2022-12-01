#!/bin/bash

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script/246128#246128
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

case "$OSTYPE" in
msys*) exe="FXServer.exe" ;;
cygwin*) exe="FXServer.exe" ;;
*) exe="run.sh" ;;
esac

SERVER_EXE=$SCRIPT_DIR/server/$exe

$SERVER_EXE +exec server.cfg
