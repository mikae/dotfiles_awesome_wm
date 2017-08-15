#!/usr/bin/env bash

# Find script parent dir path.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done

CONFIG_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
CONFIG_SRC=$CONFIG_DIR/src

# Sources
VICIOUS_SOURCE=https://github.com/Mic92/vicious

DESTINATION_DIR=~/.config/awesome
VICOUS_DESTINATION=$DESTINATION_DIR/vicious

config_clean () {
    rm -rf $DESTINATION_DIR/rc.lua
    rm -rf $DESTINATION_DIR/minagi
    rm -rf $DESTINATION_DIR/local
    rm -rf $DESTINATION_DIR/icon
    rm -rf $DESTINATION_DIR/theme
    rm -rf $DESTINATION_DIR/wallpaper
}

config_install () {
    mkdir $DESTINATION_DIR
    mkdir -p $DESTINATION_DIR/.state

    cp -Rv $CONFIG_SRC/.state $DESTINATION_DIR
    cp -Rv $CONFIG_SRC/minagi $DESTINATION_DIR
    cp -Rv $CONFIG_SRC/theme  $DESTINATION_DIR
    cp -Rv $CONFIG_SRC/rc.lua $DESTINATION_DIR
    [ ! -d $DESTINATION_DIR/local ] && cp -Rv $CONFIG_SRC/local $DESTINATION_DIR

    # Install user-local files
    cp -v $CONFIG_DIR/.xinitrc ~/.xinitrc
}

lib_install () {
    [ ! -d $VICOUS_DESTINATION ] && git clone $VICIOUS_SOURCE $VICOUS_DESTINATION
}

CLEAN=false
INSTALL=false
TEST=false

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --clean)
            CLEAN=true
            ;;

        --install)
            INSTALL=true
            ;;

        --all)
            CLEAN=true
            INSTALL=true
            ;;
    esac

    shift
done

if $CLEAN; then
    config_clean
fi

if $INSTALL; then
    config_install
    lib_install
fi
