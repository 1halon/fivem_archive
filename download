#!/bin/bash

case "$OSTYPE" in
msys*) os="windows" ;;
cygwin*) os="windows" ;;
*) os="linux" ;;
esac

if [ -z $1 ]; then
    echo $0: INVALID buildID #&& exit 2
fi

if [ $os == "linux" ]; then
    build="build_proot_linux"
    filename="fx.tar.xz"
    command="tar xf $filename -C server"
fi

if [ $os == "windows" ]; then
    build="build_server_windows"
    filename="server.7z"
    command="7z x -so $filename | tar xf - -C server"
fi

curl https://runtime.fivem.net/artifacts/fivem/$build/master/${1-"5848-4f71128ee48b07026d6d7229a60ebc5f40f2b9db"}/$filename -O && 
    rm -rf server && mkdir server && $($command) && rm -f $filename
