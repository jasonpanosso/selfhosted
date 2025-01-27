#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

FILE="$1"
CONFIG_FILENAME="system.xml"
CONFIG_DIRECTORY="/config/config"

if [ ! -d "$CONFIG_DIRECTORY" ]; then
    mkdir -p "$CONFIG_DIRECTORY"
fi

if [ ! -e "$CONFIG_DIRECTORY/$CONFIG_FILENAME" ]; then
    cp -L "$FILE" "$CONFIG_DIRECTORY/$CONFIG_FILENAME"

    echo "Created $CONFIG_DIRECTORY/$CONFIG_FILENAME"
fi
