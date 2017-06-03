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

DESTINATION_DIR=~/.config/awesome

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
    for f in $(find $CONFIG_SRC -type f); do
        case $f in
            *)
                relative_name=`realpath --relative-to="$CONFIG_SRC" "$f"`
                source_path=$CONFIG_SRC/$relative_name
                destination_path=$DESTINATION_DIR/$relative_name
                destination_dir="$(dirname $destination_path)"

                [ ! -d $destination_dir ] && mkdir -p $destination_dir
                cp -v $source_path $destination_path
                ;;
        esac
    done

    # Install user-local files
    cp -v $CONFIG_DIR/.xinitrc ~/.xinitrc
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
fi
